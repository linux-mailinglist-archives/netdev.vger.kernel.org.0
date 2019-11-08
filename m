Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D55F5393
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbfKHSeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:34:15 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35134 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728425AbfKHSeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:34:15 -0500
Received: by mail-wr1-f65.google.com with SMTP id p2so8196124wro.2
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lDOuVdyU/NGOBA/NOIi8OTDcCGXKckSDWCSgU9rLWOY=;
        b=GBKXo9ZRoH0e4wUtSlIUb3jLlN2tyv9jvO1lXk+hjiCvbGNWQclRoE+DnjB/QX5s41
         n5jw9WlfRYPle46v3JyStnKYvmiB68HHm8MwEc3LtJM1565Q1c29Wy5nndmi1oxHjKOQ
         e7gd9wD8Ru/6hhdn7UBLdZGgDSRNNPxEUGue3/3568fVQ2SrfWs0EqyFeSGE11HwoaMs
         LO6A3HRwfGUZBpn1zOYHoo+pC/UlzOfXuxJ0mUntwb/fEO/PP6PPwhCtZzRzMcMPLzbL
         Osn7dwCJpldAT3RahOhb3EB8blyvIRKuPLxwioaGSwTuP2RiKOFctQJMUk2muhn7Xofs
         yOwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lDOuVdyU/NGOBA/NOIi8OTDcCGXKckSDWCSgU9rLWOY=;
        b=Y9wYNAQT/dN1/AkHjb8QhxvdkG7Fh2xK/iG49syBeuqfQcJu1PwIuyDmHIZIrwTQcu
         M7/lv2JhCrPF3/I3/QRhlDvZnCEu89Yj78WOt0uBbw05j2Sk0qNIA75P3xoaMcWHq3Ey
         Y7ftk0aVPPyGdfTeejHMaCIEQ56P9NGlg2DOWy4DpsYAnWQJb8dWov02KdXRHOZAmqUA
         KmDD6GPikV5sP8ou0omo9pa5+ovwYEZUyOmAXem2UblHI7tIfKgcULZTzlw1sU4NIkcR
         hDGXK7XM+If4q3hjPo9w52m1Wrax3k3DRTHwkFBmGgKu14f+/J848Pf8mbxspplohCeC
         uS6w==
X-Gm-Message-State: APjAAAUHCNZLW2714ZT1NXffaacSZKQthiaV7L87ROk4gobt6ixuNEj+
        GJx9E0QAy2x5h+wozaOfVFhFvQ==
X-Google-Smtp-Source: APXvYqxLI+jBORt6enjDcoO/Lv3XygiUH9GQ1c32a7/0zht8rn1PTzF2lBpOGDEQ2Gc6QciF69dDcA==
X-Received: by 2002:adf:c401:: with SMTP id v1mr9446418wrf.375.1573238053124;
        Fri, 08 Nov 2019 10:34:13 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id p25sm3094919wma.20.2019.11.08.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 10:34:12 -0800 (PST)
Date:   Fri, 8 Nov 2019 19:34:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Message-ID: <20191108183411.GW6990@nanopsycho>
References: <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108163139.GQ6990@nanopsycho>
 <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108181119.GT6990@nanopsycho>
 <AM0PR05MB48667057857062CB24DD57D2D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48667057857062CB24DD57D2D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 07:23:44PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>
>[..]
>> Well, I don't really need those in the phys_port_name, mainly simply because
>> they would not fit. However, I believe that you should fillup the PF/VF devlink
>> netlink attrs.
>> 
>> Note that we are not talking here about the actual mdev, but rather
>> devlink_port associated with this mdev. And devlink port should have this info.
>> 
>> 
>> >
>> >> >What in hypothetical case, mdev is not on top of PCI...
>> >>
>> >> Okay, let's go hypothetical. In that case, it is going to be on top
>> >> of something else, wouldn't it?
>> >Yes, it will be. But just because it is on top of something, doesn't mean we
>> include the whole parent dev, its bridge, its rc hierarchy here.
>> >There should be a need.
>> >It was needed in PF/VF case due to overlapping numbers of VFs via single
>> devlink instance. You probably missed my reply to Jakub.
>> 
>> Sure. Again, I don't really care about having that in phys_port_name.
>> But please fillup the attrs.
>> 
>Ah ok. but than that would be optional attribute?
>Because you can have non pci based mdev, though it doesn't exist today along with devlink to my knowledge.

Non-optional now. We can always change the code to not fill it up or
fill up another attr instead. no UAPI harm.
