Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643822B8155
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgKRP55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:57:57 -0500
Received: from sender11-of-o52.zoho.eu ([31.186.226.238]:21365 "EHLO
        sender11-of-o52.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgKRP54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:57:56 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1605715025; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=WjzgxdOVTogBKmBQjO2meIoe1mDOq7hRrBVkt59W4xfz/5jTVsXzQ1mnTvM0fxNJMZ2ZVo1j/blr4DNzP8hd0Gz7UJoCx15UeRr4yoyvfyiaRfP4/XVleAp6xLqUp6vZjt2ciikyQi2h4WTXX8VihaNJX+ci16vzpDk023brWrU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1605715025; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=r734+KKew+kGS2tJrjpen3pnF+qZa2+AOhj0cSasEhU=; 
        b=bLvYuPB9M9j4eNg1ALkoZPtgTN20oBWWl9BOu6yxPVpmLArfOYV/bf2UkAwmTwpBOOekIoOTHby6wg1+ZuyIBtk7/FkAW/1ATtw8pjGxJG2ruvO6MSQVeWhqdC+qwSV62bFE6ZQIFp5pSWPEekihKO90rlQ9j+W9gS8IufE1hcg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        dkim=pass  header.i=shytyi.net;
        spf=pass  smtp.mailfrom=dmytro@shytyi.net;
        dmarc=pass header.from=<dmytro@shytyi.net> header.from=<dmytro@shytyi.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1605715025;
        s=hs; d=shytyi.net; i=dmytro@shytyi.net;
        h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=r734+KKew+kGS2tJrjpen3pnF+qZa2+AOhj0cSasEhU=;
        b=I1xV/Sytw+s1XvVsI9+t7hdm0eSE2ZpnSTzBmj2i+L1fGItQkbOW5/HvUKLyPStI
        d/IGg2RxsQTTA5ep6H1yjTiqFpm3TRCUIyjlX6jI1LjgQtl4gR7uX2UE+/u+iETai3y
        qmFb5kafFN9NKxBRcKWUdhF8wW7ZLtJFuRTIXCWY=
Received: from mail.zoho.eu by mx.zoho.eu
        with SMTP id 1605715018978132.54482825616162; Wed, 18 Nov 2020 16:56:58 +0100 (CET)
Date:   Wed, 18 Nov 2020 16:56:58 +0100
From:   Dmytro Shytyi <dmytro@shytyi.net>
To:     "Jakub Kicinski" <kuba@kernel.org>
Cc:     "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <175dc12c4e0.10495546f370275.5966814804122496347@shytyi.net>
In-Reply-To: <20201118075027.18083d19@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
        <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
        <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
        <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <175db965378.e5454e1c360034.2264030307026794920@shytyi.net> <20201118075027.18083d19@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Subject: Re: [PATCH net-next V5] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

---- On Wed, 18 Nov 2020 16:50:27 +0100 Jakub Kicinski <kuba@kernel.org> wrote ----

 > On Wed, 18 Nov 2020 14:41:03 +0100 Dmytro Shytyi wrote: 
 > >  > > @@ -2576,9 +2590,42 @@ int addrconf_prefix_rcv_add_addr(struct 
 > >  > >                   u32 addr_flags, bool sllao, bool tokenized, 
 > >  > >                   __u32 valid_lft, u32 prefered_lft) 
 > >  > >  { 
 > >  > > -    struct inet6_ifaddr *ifp = ipv6_get_ifaddr(net, addr, dev, 1); 
 > >  > > +    struct inet6_ifaddr *ifp = NULL; 
 > >  > >      int create = 0; 
 > >  > > 
 > >  > > +    if ((in6_dev->if_flags & IF_RA_VAR_PLEN) == IF_RA_VAR_PLEN && 
 > >  > > +        in6_dev->cnf.addr_gen_mode != IN6_ADDR_GEN_MODE_STABLE_PRIVACY) { 
 > >  > > +        struct inet6_ifaddr *result = NULL; 
 > >  > > +        struct inet6_ifaddr *result_base = NULL; 
 > >  > > +        struct in6_addr curr_net_prfx; 
 > >  > > +        struct in6_addr net_prfx; 
 > >  > > +        bool prfxs_equal; 
 > >  > > + 
 > >  > > +        result_base = result; 
 > >  > > +        rcu_read_lock(); 
 > >  > > +        list_for_each_entry_rcu(ifp, &in6_dev->addr_list, if_list) { 
 > >  > > +            if (!net_eq(dev_net(ifp->idev->dev), net)) 
 > >  > > +                continue; 
 > >  > > +            ipv6_addr_prefix_copy(&net_prfx, &pinfo->prefix, pinfo->prefix_len); 
 > >  > > +            ipv6_addr_prefix_copy(&curr_net_prfx, &ifp->addr, pinfo->prefix_len); 
 > >  > > +            prfxs_equal = 
 > >  > > +                ipv6_prefix_equal(&net_prfx, &curr_net_prfx, pinfo->prefix_len); 
 > >  > > + 
 > >  > > +            if (prfxs_equal && pinfo->prefix_len == ifp->prefix_len) { 
 > >  > > +                result = ifp; 
 > >  > > +                in6_ifa_hold(ifp); 
 > >  > > +                break; 
 > >  > > +            } 
 > >  > > +        } 
 > >  > > +        rcu_read_unlock(); 
 > >  > > +        if (result_base != result) 
 > >  > > +            ifp = result; 
 > >  > > +        else 
 > >  > > +            ifp = NULL; 
 > >  > 
 > >  > Could this be a helper of its own? 
 > > 
 > > Explain the thought please. It is not clear for me. 
 >  
 > At the look of it the code under this if statement looks relatively 
 > self-contained, and has quite a few local variables. Rather than making 
 > the surrounding function longer would it be possible to factor it out 
 > into a helper function? 
 > 
Understood.
Thanks.

Best regards,
Dmytro SHYTYI.
