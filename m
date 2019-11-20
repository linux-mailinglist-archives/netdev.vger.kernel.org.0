Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC5103970
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 13:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfKTMDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 07:03:17 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39334 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfKTMDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 07:03:16 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so7520955wmi.4
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 04:03:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yjRiD2kmmMRgYTSYZHwBpw4xHFxxldWWaxVd0ST+IRI=;
        b=uLwZwRXuR7RR9MWQK50X/fnTYqFKIzC0nCXYKI+LmwX3scSCk73r3mAOaoRVd3g6ZI
         b46HmYnowlwgWdkbwTBojaPSiqsNTL0qLPZo0G72Q/GNKaHPHGvcQ5hp7YoaUInLMfIt
         dfBV0V9AuG5BZwkIba3EF0KqxrLPIr+EIMQrGsLn63IBEl0gy6YxM0bYD8hdSyX6L2Ky
         RMTZ/hBr9SeI4T3D7PmBNGU7l+X0BJRA9wbj6Pk/V5AT9vPByRr7IPFBEwdyAEn66qEw
         rJG+QB881r9nolN9HdkGGUjNweL+PKnyww3lR+KIa8yFfJEw9QNx53xLc/Ge/PXPT9Qb
         9WIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yjRiD2kmmMRgYTSYZHwBpw4xHFxxldWWaxVd0ST+IRI=;
        b=nEt68CFKT71YWDVkjXfzT5NwlJmq+InpEcr7PMP5LbiXOwzdVzI+zu2diSoC4DDHNL
         PGmyEnid7jsCPm4simTIplO0SciVX3q8Ltb4wmpHHeFd707Mt3g0VYrG2lce20ZZQYEg
         vr9iE/VOUKjHzNb/I4MfDZ7+KIb0UoPWVUjNSYbOevYNx9NWvgSwWGBIYxkK7LftCvcU
         LZ5xIsEWFdCwUUtuU6215VvZPEGX9HoAS21+Mi0Av409aKMtpr0KIoYAsfldaoMZAv49
         u5O/7c79yl5hwoUQCgxVfzKs7PCQ8Pp200e4b/SHFoSQ82/DuRO/RfJAfLIDv0pm9cTD
         vfGg==
X-Gm-Message-State: APjAAAUYeGNITywpB+3Uk8WBWS3CvznFTwXndJ4voLTsDbSNe9Khoxk8
        Lp8mgzZp+sZSFj4XKqdRzUjB6Q==
X-Google-Smtp-Source: APXvYqwZgu5xYG/oAHHARg5Rpjkn9pw3zFuIkK7AtEPOhtiRgFkglPya9zGGZ6vw98QIXmK/udISlg==
X-Received: by 2002:a1c:6309:: with SMTP id x9mr2646067wmb.108.1574251393563;
        Wed, 20 Nov 2019 04:03:13 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d7sm31464695wrx.11.2019.11.20.04.03.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 04:03:12 -0800 (PST)
Date:   Wed, 20 Nov 2019 13:03:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@mellanox.com>,
        Jason Wang <jasowang@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Dave Ertman <david.m.ertman@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>, Kiran Patil <kiran.patil@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Tiwei Bie <tiwei.bie@intel.com>
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
Message-ID: <20191120120311.GA2297@nanopsycho>
References: <AM0PR05MB4866CF61828A458319899664D1700@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <a40c09ee-0915-f10c-650e-7539726a887b@redhat.com>
 <AM0PR05MB4866C40A177D3D60BFC558F7D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <13946106-dab2-6bbe-df79-ca6dfdeb4c51@redhat.com>
 <AM0PR05MB486685F7C839AD8A5F3EEA91D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <ead356f5-db81-cb01-0d74-b9e34965a20f@redhat.com>
 <AM0PR05MB486605742430D120769F6C45D14C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <743601510.35622214.1574219728585.JavaMail.zimbra@redhat.com>
 <AM0PR05MB48664221FB6B1C14BDF6C74AD14F0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191120034839-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120034839-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Nov 20, 2019 at 09:52:23AM CET, mst@redhat.com wrote:
>On Wed, Nov 20, 2019 at 03:38:18AM +0000, Parav Pandit wrote:
>> 
>> 
>> > From: Jason Wang <jasowang@redhat.com>
>> > Sent: Tuesday, November 19, 2019 9:15 PM
>> > 
>> > ----- Original Message -----
>> > >
>> > >
>> > > > From: Jason Wang <jasowang@redhat.com>
>> > > > Sent: Tuesday, November 19, 2019 1:37 AM
>> > > >
>> > >
>> > > Nop. Devlink is NOT net specific. It works at the bus/device level.
>> > > Any block/scsi/crypto can register devlink instance and implement the
>> > > necessary ops as long as device has bus.
>> > >
>> > 
>> > Well, uapi/linux/devlink.h told me:
>> > 
>> > "
>> >  * include/uapi/linux/devlink.h - Network physical device Netlink interface "
>> > 
>> > And the userspace tool was packaged into iproute2, the command was named
>> > as "TC", "PORT", "ESWITCH". All of those were strong hints that it was network
>> > specific. Even for networking, only few vendors choose to implement this.
>> > 
>> It is under iproute2 tool but it is not limited to networking.
>
>Want to fix the documentation then?
>That's sure to confuse people ...

Will do.

>
>-- 
>MST
>
