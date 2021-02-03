Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2982930E4D1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 22:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhBCVRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 16:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbhBCVRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 16:17:18 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF82AC061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 13:16:37 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so1471516ejc.1
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 13:16:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wERgaNtBKmioDXI4NuWAON27uwzoNSQ9EO+QRSyVJTE=;
        b=lZZOeUuTqkceLM+J5w8iuWPkVJ//NwXIoSRoIAhzlTMPMn2g5IGxct54j8lg/VqqvS
         h/m4aOZT/e2QXMDJ806q+ZAQCKoIlj6+FI5DRV2yW1zWJEqzC7vT+tazZIG+VVvR1629
         9ryXiaB04hXGI6w9PmWRo9J7LJm0WvbY+GoeG9y13Lr/hen5n4nlQJf6W67W3vbMMu5S
         jVZSivbThdugDD2oU/brWif0iH9Ww6GuIBUUqvFn1oMAHuAyUpSBxbfo3liYi73xkezl
         P9ICZTBzxT/FZuLwrbZWe6aZsp4l6MxWXo/sxfVfSsNgoPqw8CGTpM/8/fcQ56f9B1mN
         OCCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wERgaNtBKmioDXI4NuWAON27uwzoNSQ9EO+QRSyVJTE=;
        b=tHEFeDcOWEwGKC8cnLtoffZr9JcqQOvduNGEARU9Nt/FzK4VOMGTkdPZ5W4TaQWJS9
         3YsbZyZ5xhEezi/9uEpYusGekrAOHt3cIXKAVn4IZQCmRCwouw7B18CmRBLUpBNKlbe6
         yzJyLTB9c9lJ+mIcxTxOHeX6Hs73k10pI67z+6VtyjtMVB4Wo0LU91vwxw4QVv2ZQzF8
         4TXWZ08xjacWFciJSmsY/g0ROUuRoQ6C7m0px2ydSWuugjenxzuASsmYcWiIyEzH0Thk
         P0pOSEYNKz+X43XBZQykxcAoEW17E5u5IEq7vwS7MeLieIIR6Y2MrvaoDGtr/UqqOTwQ
         Sr/g==
X-Gm-Message-State: AOAM532UZTRa56hCDij40qZ8eMJ3mGMRZ99AsuhtM6LAshKpJLh0W3UK
        H596FDhbTXDO+AJCuv/KWKY=
X-Google-Smtp-Source: ABdhPJyXkQY0UjaZX3cMgllPYSxqkC3B31n7Y4lYXX8+crVn8r/q0O/v3K9muF2UdpyqHwEHz/eucQ==
X-Received: by 2002:a17:906:719:: with SMTP id y25mr5063319ejb.180.1612386996505;
        Wed, 03 Feb 2021 13:16:36 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id q14sm1477591edw.52.2021.02.03.13.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 13:16:35 -0800 (PST)
Date:   Wed, 3 Feb 2021 23:16:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
Message-ID: <20210203211634.t7trwhtbhha5voms@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com>
 <20210201145943.ajxecwnhsjslr2uf@skbuf>
 <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
 <20210202003729.oh224wtpqm6bcse3@skbuf>
 <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=MhuJtuXGDQHU_5w+AVf9DqdNh=zioJoZOuOYF5Jat-eQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:49:25AM -0600, George McCollister wrote:
> > > This part is not intuitive and I don't have a copy of the documents
> > > where v0 was defined. It's unfortunate this code even supports v0
> > > because AFAIK no one else uses it; but it's in here so we have to keep
> > > supporting it I guess.
> > > In v1 the tag has an eth type of 0x892f and the encapsulated
> > > supervisory frame has a type of 0x88fb. In v0 0x88fb is used for the
> > > eth type and there is no encapsulation type. So... this is correct
> > > however I compared supervisory frame generation before and after this
> > > patch for v0 and I found a problem. My changes make it add 0x88fb
> > > again later for v0 which it's not supposed to do. I'll have to fix
> > > that part somehow.
> >
> > Step 1: Sign up for HSR maintainership, it's currently orphan
> > Step 2: Delete HSRv0 support
> > Step 3: See if anyone shouts, probably not
> > Step 4: Profit.
> 
> not a bad idea however user space defaults to using v0 when doing:
> ip link add name hsr0 type hsr slave1 eth0 slave2 eth1
> 
> To use v1 you need to append "version 1".
> 
> It seems like it might be a hard sell to break the userspace default
> even if no one in their right mind is using it. Still think it's
> possible?

While HSRv0 is the default, IFLA_HSR_VERSION won't be put in the netlink
message generated by iproute2 unless you explicitly write "version 0".
So it's not like ip-link will now error out on a default RTM_NEWLINK
message, the kernel will just use a different (and more sane, according
to you) default.
Removing support for a protocol is pretty radical, but I guess if you
can make a convincing argument that nobody depends on it, it may get
accepted.
