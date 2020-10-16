Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EA529007A
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404499AbgJPJFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 05:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404265AbgJPJFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 05:05:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C70C061755;
        Fri, 16 Oct 2020 02:05:30 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id md26so2036414ejb.10;
        Fri, 16 Oct 2020 02:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kdEvLM24ShjG3wNe7OPqA0oEeaBKoO7Zc9qCuXiw5Co=;
        b=rw6Q862j9e0sIhzDYZ3knhzfJ32UWPYURiSgJaA9UYdrWSD/gCAq5fXxsV49VbCa6N
         xlb4HJ3EgMmk1R4KBu4iNc2NoWn6gKH2SOMj98ncY/jxFtvzi/XBuyZEbv81rDLB25YV
         CdiPkVOAM0d2dlY4t4KPu9BicCikwB+qASHo+uTiviGHtq0Aleg7VZXQGg3Hxyyn8ojY
         w2Sxx/kT9Grf8emddsJNU3p2CU5SQ5mgGoG3o4roXg+5yBV7TWlA44YSCj73o09CYEu7
         XAwdm2Hg8lV7RG8rkEWXv1sMAibB3K9hX7c3254klNhjNL7OiV1JSHyTLJvvcUAi/wUb
         uC2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kdEvLM24ShjG3wNe7OPqA0oEeaBKoO7Zc9qCuXiw5Co=;
        b=P81N5IkFfvvGLdDC8GJj+RW+D5YXjx+oStNf2syJhd6iGH2qYLfDwZBv7ximxFoQUT
         qUAmIT3XFpUU8uWVJrDqUH/OitTCghhSdvfjFVmUMju011tYPylgJF01ax0fCNg4YWea
         AAARdld58IP60eBmnjE8ADc74Jmgd2pwjt/cjH8YsPggcO4pMdlO9MDVJc9bNN+sIL1e
         qsz8k8uOPt6TTNGsc10i96ZT7YMhhzYZ02FqLwnBwpgPmTVdQbmMsoo3GszTLxe0sMf7
         Hfi3J0+diPfrT4bLJ5pbOhjXjSJ0+n7DcaGXu+NUuV3qvye35PTxAB/mNukq0Y83Nvpa
         on/A==
X-Gm-Message-State: AOAM531cs62kyJ84YzKwn++6ES0ESOUNMzKoRmemWq1Ei9aQe8+YIRUy
        CGsIV0xu3JKOC8rvk4AjJBk=
X-Google-Smtp-Source: ABdhPJzVqiIBv+lNnb/onQp56fC/qDt9S2d7tJodghoSe00Q9F4qSbvBr2ma51/poCL4iW1V7cR27g==
X-Received: by 2002:a17:906:bc42:: with SMTP id s2mr2587128ejv.251.1602839129464;
        Fri, 16 Oct 2020 02:05:29 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id qw1sm1099691ejb.44.2020.10.16.02.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 02:05:29 -0700 (PDT)
Date:   Fri, 16 Oct 2020 12:05:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201016090527.tbzmjkraok5k7pwb@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
 <1647199.FWNDY5eN7L@n95hx1g2>
 <875z7asjfd.fsf@kurt>
 <4467366.g9nP7YU7d8@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4467366.g9nP7YU7d8@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 11:00:20AM +0200, Christian Eggers wrote:
> On Friday, 16 October 2020, 09:45:42 CEST, Kurt Kanzenbach wrote:
> > On Thu Oct 15 2020, Christian Eggers wrote:
> > > On Wednesday, 14 October 2020, 19:31:03 CEST, Vladimir Oltean wrote:
> > >> What problem are you actually trying to solve?
> > >
> > > After (hopefully) understanding the important bits, I would like to solve
> > > the problem that after calling __skb_put_padto() there may be no tailroom
> > > for the tail tag.
> > >
> > > The conditions where this can happen are quite special. You need a
> > > skb->len < ETH_ZLEN and the skb must be marked as cloned. One condition
> > > where this happens in practice is when the skb has been selected for TX
> > > time stamping in dsa_skb_tx_timestamp() [cloned] and L2 is used as
> > > transport for PTP [size < ETH_ZLEN]. But maybe cloned sk_buffs can also
> > > happen for other reasons.
> > Hmm. I've never observed any problems using DSA with L2 PTP time
> > stamping with this tail tag code. What's the impact exactly? Memory
> > corruption?
> It looks like skb_put_padto() is only used by the tag_ksz driver. So it's
> unlikely that other drivers are affected by the same problem.
> 
> If I remember correctly, I got a skb_panic in skb_put() when adding the tail
> tag. But with the current kernel I didn't manage to create packets where the
> skb allocated by __skb_put_padto has not enough spare room for the tag tag.
> Either I am trying with wrong packets, or something else has been changed in
> between.
> 
> I just sent a new patch which should solve the problem correctly here:
> https://patchwork.ozlabs.org/project/netdev/list/?series=208269

Kurt is asking, and rightfully so, because his tag_hellcreek.c driver
(for a 1588 switch with tail tags) is copied from tag_ksz.c.
I have also attempted to replicate your issue at my end and failed to do
so. In principle, it is indeed true that a cloned skb should not be
modified without calling skb_unshare() first. The DSA core
(dsa_slave_xmit) should do that. But that doesn't explain the symptoms
you're seeing, which is why I asked for skb_dump.
