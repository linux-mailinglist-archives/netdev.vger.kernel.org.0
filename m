Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F14C3EAA37
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 20:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhHLS1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 14:27:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232844AbhHLS1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 14:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628792810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qYXg2tlqyoci4gGaxK6MgW8sEbsOw0KF5DADu56IPRk=;
        b=e2R/mriG6jPVtz69UHOwQBzZMW6wNyW1VQYDCjq65lj17epvSBDkkdBZeW9ywPLzlTTge/
        5xmn7p7eencF+UvLdJU494NXn7MeSUSlGmq24uvjfG+dtp4hrvlIgM0Js9Gu9kERdudMMF
        tVhChB0dBbwn7rTXsPxc116rMNA3YTs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-MI9VsZRcOzWDYu_QhsRBpw-1; Thu, 12 Aug 2021 14:26:49 -0400
X-MC-Unique: MI9VsZRcOzWDYu_QhsRBpw-1
Received: by mail-wr1-f71.google.com with SMTP id l12-20020a5d6d8c0000b029015488313d96so2116188wrs.15
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 11:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qYXg2tlqyoci4gGaxK6MgW8sEbsOw0KF5DADu56IPRk=;
        b=dSUvtbmwgQ9Prhru1g2leVo40c0GQpTlkb9RyyEPxWrazZeOnmDQ9qGbxdHk3Qr1F2
         T+B4VHjYhGWgdbvmKWXVfIrZaSjEl4Se4m/TIzetQEbKw/rkRR1EQkitUOS6zD8gqyNZ
         41Rg82lRrLCKudD3j261eYagrfDCbPfZq7lfuG/G0W7Bw06stDX9cjGkjzS83RfqOnCQ
         A1SF6v9/+wCudKcSgaGCaL2NVv4h2gMku+LUN8qIImMMIl3kZbylf2ckDL44xUkS+TNN
         U6G3pPv7D6Rmn62ASYwCJNPR9ThLRI5plkh32//MixevmDLH9Po+jZhIcaiPyHuqSdKU
         bn2A==
X-Gm-Message-State: AOAM53135tPjNSf/qWcx3B70I9pi/PItX5/ftrXLT7vtCK9PbN3oeAt6
        Sj5LWWwF7gz+ZyOGT6lE04nx1y7c9VUs0Dw1r0OwFLm1r6xXAG+d9i/lpCNB0KPC8jcTgzfuUjF
        jdftI40iNT0Ztc3Ph
X-Received: by 2002:adf:b350:: with SMTP id k16mr5508896wrd.37.1628792808611;
        Thu, 12 Aug 2021 11:26:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyI8bjv53j2gMWyLBTbdBlwhit3AlIGikq1BbrwBmCe4oPno7y2Y8w6UodzIx+Snr43nhZqLA==
X-Received: by 2002:adf:b350:: with SMTP id k16mr5508882wrd.37.1628792808350;
        Thu, 12 Aug 2021 11:26:48 -0700 (PDT)
Received: from pc-23.home (2a01cb058d01b600c841afd12834a14e.ipv6.abo.wanadoo.fr. [2a01:cb05:8d01:b600:c841:afd1:2834:a14e])
        by smtp.gmail.com with ESMTPSA id w29sm4035148wra.88.2021.08.12.11.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 11:26:47 -0700 (PDT)
Date:   Thu, 12 Aug 2021 20:26:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     James Carlson <carlsonj@workingcode.com>,
        Chris Fowler <cfowler@outpostsentinel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
Message-ID: <20210812182645.GA10725@pc-23.home>
References: <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali>
 <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
 <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
 <20210811173811.GE15488@pc-32.home>
 <20210811180401.owgmie36ydx62iep@pali>
 <20210812092847.GB3525@pc-23.home>
 <20210812134845.npj3m3vzkrmhx6uy@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210812134845.npj3m3vzkrmhx6uy@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 03:48:45PM +0200, Pali Rohár wrote:
> On Thursday 12 August 2021 11:28:47 Guillaume Nault wrote:
> > On Wed, Aug 11, 2021 at 08:04:01PM +0200, Pali Rohár wrote:
> > > ifname is not atomic (first it creates ppp<id> interface and later it is
> > > renamed) and have issues. Due to bug described here:
> > > https://lore.kernel.org/netdev/20210807160050.17687-1-pali@kernel.org/
> > > you may get your kernel into state in which it is not possible to create
> > > a new ppp interface. And this issue does not happen when using "unit"
> > > argument.
> > 
> > This is specific to the ioctl api. Netlink doesn't have this problem.
> 
> netlink does not have problem with implementing ifname option
> atomically. That is why I started looking at netlink how to avoid
> problems with renaming. As on some systems I see that some udev rules or
> NetworkManager tries to query newly created interfaces, but based on
> name (not id). So early renaming cause issues to these tools...
> 
> But netlink is affected by above bug when "ifname" is not specified.

As disscussed in another part of the thread, let's fix that with a new
netlink attribute.

> > > To fix above issue it is needed to migrate pppd from ioctl API to rtnl.
> > 
> > It would have helped a lot if you had explained that before.
> > 
> > > But this would be possible only after rtnl API starts providing all
> > > features, including specifying custom "unit" argument...
> > 
> > You can already simulate the "unit" option by setting the interface
> > name as "ppp${unit}" and retrieving the kernel assigned id with
> > ioctl(PPPIOCGUNIT). What's wrong with that?
> 
> This is possible to implement. But then unit part from "ppp${unit}"
> would not match PPPIOCGUNIT number - like it is currently. And it is
> something which applications expect. Basically there is no difference
> between ppp interface created by ioctl and ppp interface created by
> rtnl. You can use other rtnl commands on ppp interface created by ioctl
> and also you can use other ppp ioctls on ppp interface created by rtnl.

But the application knows if it created the ppp device with a specified
unit id or not. So it knows if an ioctl(PPPIOCGUNIT) call is necessary
to get the unit id. And if we allow the interface name to be unrelated
to the unit id, the application will also know that, because it
explicitely requested it.

> But I understand your arguments. You are looking at ppp unit id as some
> internal kernel number; which should probably stay in kernel.

Well, it has to be exported, but it should be opaque to user space
(appart from the ioctl() api which is established behaviour).

> My point of view is that this is legacy identifier bound to the every
> ppp network interface, and which is exported to userspace. And because
> there is API for userspace how userspace can force particular id for
> particular ppp interface, it means that userspace have full control how
> these ids are generated. Even it is "internal" kernel number. And it
> does not matter how are ppp interfaces created, via which method. It is
> bounded to every ppp interface independently how ppp was created.
> 
> By this design, userspace application may choose to create mapping
> between /dev/ttyUSB<N> and ppp unit <id> by having <N> == <id>.
> 
> This ppp unit id is used for some operations, so it is required to know
> it. And if application is doing e.g. above assumption (it does not use
> PPPIOCGUNIT, but derive ppp unit id from /dev/ttyUSB* name) which
> current ioctl API allows, then this application cannot be migrated from
> ioctl to rtnl API without rewriting code which uses above assumption.

Migrating such application requires writing the netlink code for the new
api. How could a simple ioctl(PPPIOCGUNIT) call prevent such migration?
BTW, using PPPIOCGUNIT is much cleaner an more robust that parsing the
device name, so it's a win in any case. And the application is still
able to name the ppp interface ppp<N> to keep things simple for its
users.

> I'm not saying if this is a good or bad idea, just I'm describing what
> ioctl API allows and what does not. (And yes, in my opinion it is a bad
> idea, but ppp is designed to allow it).
> 
> If I was designing ppp again, I would have probably used interface id as
> ppp unit id...

With all the building blocks we have now in the Linux kernel, there's
much more that I'd change. But the landscape and constraints were
obviously very different at the time.

> > > I hit above problem, so now I'm migrating all pppd setups from "ifname"
> > > to "unit" option.
> > 
> > Why did you write 3125f26c51482 ("ppp: Fix generating ppp unit id when
> > ifname is not specified") then?
> 
> Well, I hope that this kernel fix propagates into kernels used on
> affected machines. But it will take some time. And until it happens this
> migration is needed. Lets say it is workaround for unspecific time
> period.

Makes sense.

