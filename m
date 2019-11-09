Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB6CF5EAA
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 12:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfKILSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 06:18:14 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34031 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfKILSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 06:18:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id e6so9837893wrw.1
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 03:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lV8hsrpV1/CMqW5H35jpAhibR2n/EfxU4U4hpbJbzmA=;
        b=lefa59EPd0gxstPKf3O9h6NkqIxDk7oRkQwnqI1H4BQt2PsIKG3RCECBKO92Z/sZU5
         vv+bRD5U0ECT/rqoyGJt6wNABR5da/ke0ZpldJjobVbcfcBeDNZXOOyP+13aqIuC16eT
         dZrUyfJdDOUHV7W6qIU6HASKg3txt1bfbYiaXgBeSMfVkESmbSP3iJmBeeBVc8aooBMh
         TCWE1l468lvYG0N32PPoXqB/G9f14ytM3Nhhv/zPZzz4GFo0Nkh7cFc/xZUpp+oAmfGq
         EfwdO5o7qdZVP4fzKDLBm7j50S2WxXxVz7ztX3AjgEbCgKd23S3WeFiUvrHrk7p47ubd
         xJCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lV8hsrpV1/CMqW5H35jpAhibR2n/EfxU4U4hpbJbzmA=;
        b=STpD+OgLin+6otTn9bWKNOisEe18LRMhIaXPNGOuYmrbg2qCgSUC0ICtEcxQcEyWSO
         LAWv9lb7ADLQ2FlrYUYgFQbkMQduAnPRDNLa7mwl5IuZr0YuJ4TJUB3RH4HJ6k9pRyM1
         jyzsJuH95xhb8CMAmR+LDyUBlQedRMmAm2iYHWezT+1KVxsdtIfGJa6SEP2eKJ5Gn+QM
         9jQSGJstQ9GO/JuZ7luqC7mbSxPSxSMN4a2ehcV0b3m0NCRHSDPs/lfzAXtSk9/Dye63
         qhYpHFE8yhPSh3z72DmCXR3ZzqeXx581Fd3gG0AFcXR6yM5NzazGCYh9qosZUu9GDZ0k
         cW+A==
X-Gm-Message-State: APjAAAXZivQ6p2TEyhMY2kIOP+zIQvLpRD9+KdKxfG0qA87cJ3kjSoxP
        ktRDSzmLAr79T5U+KjPL6jAnhg==
X-Google-Smtp-Source: APXvYqxEEl878jIf6IfioC+KhBx68+cuPbduRA51yoF2RJH6ODhB0oWi8jy8ob4tQie1H4BhbuTlHg==
X-Received: by 2002:adf:eb41:: with SMTP id u1mr12329876wrn.89.1573298291131;
        Sat, 09 Nov 2019 03:18:11 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id 62sm9593721wre.38.2019.11.09.03.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 03:18:10 -0800 (PST)
Date:   Sat, 9 Nov 2019 12:18:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Parav Pandit <parav@mellanox.com>,
        David M <david.m.ertman@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Message-ID: <20191109111809.GA9565@nanopsycho>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
 <20191108121233.GJ6990@nanopsycho>
 <20191108144054.GC10956@ziepe.ca>
 <AM0PR05MB486658D1D2A4F3999ED95D45D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108111238.578f44f1@cakuba>
 <20191108201253.GE10956@ziepe.ca>
 <20191108134559.42fbceff@cakuba>
 <20191109004426.GB31761@ziepe.ca>
 <20191109084659.GB1289838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109084659.GB1289838@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Nov 09, 2019 at 09:46:59AM CET, gregkh@linuxfoundation.org wrote:
>On Fri, Nov 08, 2019 at 08:44:26PM -0400, Jason Gunthorpe wrote:
>> There has been some lack of clarity on what the ?? should be. People
>> have proposed platform and MFD, and those seem to be no-goes. So, it
>> looks like ?? will be a mlx5_driver on a mlx5_bus, and Intel will use
>> an ice_driver on a ice_bus, ditto for cxgb4, if I understand Greg's
>> guidance.
>
>Yes, that is the only way it can work because you really are just
>sharing a single PCI device in a vendor-specific way, and they all need
>to get along with each one properly for that vendor-specific way.  So
>each vendor needs its own "bus" to be able to work out things properly,
>I doubt you can make this more generic than that easily.
>
>> Though I'm wondering if we should have a 'multi_subsystem_device' that
>> was really just about passing a 'void *core_handle' from the 'core'
>> (ie the bus) to the driver (ie RDMA, netdev, etc). 
>
>Ick, no.
>
>> It seems weakly defined, but also exactly what every driver doing this
>> needs.. It is basically what this series is abusing mdev to accomplish.
>
>What is so hard about writing a bus?  Last I tried it was just a few
>hundred lines of code, if that.  I know it's not the easiest in places,
>but we have loads of examples to crib from.  If you have
>problems/questions, just ask!
>
>Or, worst case, you just do what I asked in this thread somewhere, and
>write a "virtual bus" where you just create devices and bind them to the
>driver before registering and away you go.  No auto-loading needed (or
>possible), but then you have a generic layer that everyone can use if
>they want to (but you loose some functionality at the expense of
>generic code.)

Pardon my ignorance, just to be clear: You suggest to have
one-virtual-bus-per-driver or rather some common "xbus" to serve this
purpose for all of them, right?
If so, isn't that a bit ugly to have a bus in every driver? I wonder if
there can be some abstraction found.


>
>Are these constant long email threads a way that people are just trying
>to get me to do this work for them?  Because if it is, it's working...

Maybe they are just confused, like I am :)


>
>thanks,
>
>greg k-h
