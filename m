Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06565F5346
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfKHSLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:11:23 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40185 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfKHSLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:11:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id i10so8080484wrs.7
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 10:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1FM8QFGTLjjSibNr8z3FzFAXtJs+Q+MMqCNcWLcfyKM=;
        b=rP9g6knGkFLJa1uyXIxNYNHfvIeC9g1irjsUWgyttp8Gf7uB+JKNeSPz/ff/6IyOv2
         m92L2zBk31Exhu+S102+6+fYZTRJPkQuFaOvJIOwGwzn6J7p4x0s7r9g+UpoZXluUvIU
         siYH+wfmJI7OYsxpv1edzIBIof/B0xWsgi/AmHG2QKcgzG5wgiAe1LzdvknSsWyhCFL5
         pE32zetBOJ08KjGbLKqxEVzIWQSJYjbORCsu52KyXbbrkANX3W6X0v4Itv2xuiWNz/bV
         2Cx6EesjGfIRv4SbQ61H/XzzBzxYRkNvNm0BHF15IoMq9BoILXXRcp0naIPbC29ty0nV
         M3Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1FM8QFGTLjjSibNr8z3FzFAXtJs+Q+MMqCNcWLcfyKM=;
        b=FtjHsTIcC4xvMrRWGNnM85droOQ07IZiZOeqsQ0xNev5vAYE004b33TGdLLLUS/Y+i
         +Pz4NvX0XX/ouiu3wj9K0zbGltqosZe0jZnATRmRC9633EOHceAoAu8XJCmXOgS9OEmg
         Yu/pA+HTK0msLLwmIp/D09F4a36vxNq9nRO2ipQrZcOQKZ32kxwYSAyzB9R6cGomrGSC
         H0T7U+H8Dt63uJ90gIQeGcgyH00LTwx6v0h33LG3bYu/sMgX8J0YZefQ6JYUoq9t/OTp
         l0m1Qmt/+bpbfNyjp3FhBNkpmir0KOaSIwVSMHbCnyxQOnbYlLOXgnugUk4R5ZO936A2
         ytoA==
X-Gm-Message-State: APjAAAWeQQIsqq7C7H2ItX3CxcMh3kw71qqgj2DSNcY+AcGqvyBZWzsF
        IShfclbEVen1CX7twq+3DKSQxA==
X-Google-Smtp-Source: APXvYqwD1AWXYjVLbesng+NxQG+U5rLVvJR/bhhbMwNiGe/rg6alOWTyuPFT58vLUBnXWmXvlSBoUg==
X-Received: by 2002:a5d:4684:: with SMTP id u4mr5749770wrq.352.1573236680049;
        Fri, 08 Nov 2019 10:11:20 -0800 (PST)
Received: from localhost (ip-94-113-220-175.net.upcbroadband.cz. [94.113.220.175])
        by smtp.gmail.com with ESMTPSA id y8sm5193758wmi.9.2019.11.08.10.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 10:11:19 -0800 (PST)
Date:   Fri, 8 Nov 2019 19:11:19 +0100
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
Message-ID: <20191108181119.GT6990@nanopsycho>
References: <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108163139.GQ6990@nanopsycho>
 <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Nov 08, 2019 at 05:43:43PM CET, parav@mellanox.com wrote:
>
>
>> -----Original Message-----
>> From: Jiri Pirko <jiri@resnulli.us>
>> >> >> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
>> >> >> > > I'm talking about netlink attributes. I'm not suggesting to
>> >> >> > > sprintf it all into the phys_port_name.
>> >> >> > >
>> >> >> > I didn't follow your comment. For devlink port show command
>> >> >> > output you said,
>> >> >> >
>> >> >> > "Surely those devices are anchored in on of the PF (or possibly
>> >> >> > VFs) that should be exposed here from the start."
>> >> >> > So I was trying to explain why we don't expose PF/VF detail in
>> >> >> > the port attributes which contains
>> >> >> > (a) flavour
>> >> >> > (b) netdev representor (name derived from phys_port_name)
>> >> >> > (c) mdev alias
>> >> >> >
>> >> >> > Can you please describe which netlink attribute I missed?
>> >> >>
>> >> >> Identification of the PCI device. The PCI devices are not linked
>> >> >> to devlink ports, so the sysfs hierarchy (a) is irrelevant, (b)
>> >> >> may not be visible in multi- host (or SmartNIC).
>> >> >>
>> >> >
>> >> >It's the unique mdev device alias. It is not right to attach to the PCI
>> device.
>> >> >Mdev is bus in itself where devices are identified uniquely. So an
>> >> >alias
>> >> suffice that identity.
>> >>
>> >> Wait a sec. For mdev, what you say is correct. But here we talk about
>> >> devlink_port which is representing this mdev. And this devlink_port
>> >> is very similar to VF devlink_port. It is bound to specific PF (in
>> >> case of mdev it could be PF-VF).
>> >>
>> >But mdev port has unique phys_port_name in system, it incorrect to use
>> PF/VF prefix.
>> 
>> Why incorrect? It is always bound to pf/vf?
>> 
>Because mdev device already identified using its unique alias. Why does it need prefix?
>Mdev core generating the alias is not aware of the prefixes applied devlink. it shouldn't be.
>We want more letters towards uniqueness of the alias and filling it up with such prefixes doesn't make sense.

mdev belongs undev pf/vf, no matter how uniqueue the name/alias is.

Well, I don't really need those in the phys_port_name, mainly simply
because they would not fit. However, I believe that you should fillup
the PF/VF devlink netlink attrs.

Note that we are not talking here about the actual mdev, but rather
devlink_port associated with this mdev. And devlink port should have
this info.


>
>> >What in hypothetical case, mdev is not on top of PCI...
>> 
>> Okay, let's go hypothetical. In that case, it is going to be on top of something
>> else, wouldn't it?
>Yes, it will be. But just because it is on top of something, doesn't mean we include the whole parent dev, its bridge, its rc hierarchy here.
>There should be a need.
>It was needed in PF/VF case due to overlapping numbers of VFs via single devlink instance. You probably missed my reply to Jakub.

Sure. Again, I don't really care about having that in phys_port_name.
But please fillup the attrs.


>Here it is no overlap.
>
