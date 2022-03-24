Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F9E4E69EF
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 21:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353980AbiCXUqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 16:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353965AbiCXUqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 16:46:05 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A1483034;
        Thu, 24 Mar 2022 13:44:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso3275613wmz.4;
        Thu, 24 Mar 2022 13:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fNKXEVdpYIDjy1cDiL8tXlqPPh5ev350Tqb/YbJnoHA=;
        b=J5k1FwGywxft0f+YhzhpsLF+r+SafZFAfR55ybMnyi1Kx7coqNOskOHwji1N36CuJp
         bp6LWBWAyRZvfNXl1dW9iZEeIBLNr/cAiV72i3SkhZenSth8f4E64EKD1OSc1sG+BcSC
         JbUDqYp0ldSNj4NFygtM42Ipa6QQDOQ8W6bNM7d+/CHeFYMAbIJuy2weZglOtonz5q5a
         AbGvdr2FxQXcqU5dopmf6TWYADPiApyf96ms4Fz/CZviz30PD1Z02W7p44q0P6WPZLod
         Y+o7JCWzdLbLhktiLmZUmGl3f2y+BGVJL6wfmuyfgTm9c0rHR7C3ll6SSbM6eOR6R7ni
         94ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fNKXEVdpYIDjy1cDiL8tXlqPPh5ev350Tqb/YbJnoHA=;
        b=JMoslk2Kksyby6DhIZe1RVTOEJY5Cqr73DV8aImVePwis1SUutOFTxGdPw6mPUxzmj
         /DdcAFQUxWhsTs/+OS+RJVYqsYINDSU+p4nvFjLJVYCeA3lH9utRe0MYGvif41ExDqMq
         jA70QrcnjvUD43P+6OL7MPPzEA3SEcbIDRCNJ2CNlJ+rgJVfZgSFKpgxpr+Ve5R6Pfzp
         6g8Mkd1lJw4K5uoMYH3m6oA+yXHaa7dPUJhYckLllBVYgtuBGShJlq1ZFTpFQF4CM+Ub
         fWGu6qxRLYyjYi626y2sdv1QQeWq3j72TmkwD4+KhX3ecqp+lh6EeCj6sgkv6Np4oA6v
         5RBw==
X-Gm-Message-State: AOAM531QLpMh98ar8ghL2eNjC/TVpMi8RMNXX5wyvPze6lhSgWJbn3tF
        gRG/rJs0pPa99FnquSdW34E=
X-Google-Smtp-Source: ABdhPJxkbZv2ALBacicMWxoxJJU2tEpPJp3fu2m2BBFrBQAfM205r+v1eO1eKzHTuCU9W6BrNCPSsg==
X-Received: by 2002:a7b:cb05:0:b0:38c:7910:d935 with SMTP id u5-20020a7bcb05000000b0038c7910d935mr16047896wmj.170.1648154669979;
        Thu, 24 Mar 2022 13:44:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.gmail.com with ESMTPSA id a6-20020a05600c224600b0038cbfb9cfbcsm4761831wmm.47.2022.03.24.13.44.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 13:44:29 -0700 (PDT)
Date:   Thu, 24 Mar 2022 21:44:27 +0100
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <YjzYK3oDDclLRmm2@Ansuel-xps.localdomain>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
 <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 12:45:24PM +0200, Vladimir Oltean wrote:
> On Tue, Mar 22, 2022 at 03:03:36PM +0100, Ansuel Smith wrote:
> > On Tue, Mar 22, 2022 at 03:55:35PM +0200, Vladimir Oltean wrote:
> > > On Tue, Mar 22, 2022 at 02:38:08PM +0100, Ansuel Smith wrote:
> > > > On Tue, Mar 22, 2022 at 01:58:12PM +0200, Vladimir Oltean wrote:
> > > > > On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> > > > > > Drop the MTU array from qca8k_priv and use slave net dev to get the max
> > > > > > MTU across all user port. CPU port can be skipped as DSA already make
> > > > > > sure CPU port are set to the max MTU across all ports.
> > > > > > 
> > > > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > > > ---
> > > > > 
> > > > > I hardly find this to be an improvement and I would rather not see such
> > > > > unjustified complexity in a device driver. What are the concrete
> > > > > benefits, size wise?
> > > > >
> > > > 
> > > > The main idea here is, if the value is already present and accessible,
> > > > why should we duplicate it? Tracking the MTU in this custom way already
> > > > caused some bugs (check the comment i'm removing). We both use standard
> > > > way to track ports MTU and we save some additional space. At the cost of
> > > > 2 additional checks are are not that much of a problem.
> > > 
> > > Where is the bug?
> > 
> > There was a bug where we tracked the MTU with the FCS and L2 added and
> > then in the change_mtu code we added another time the FCS and L2 header
> > just because we used this custom way and nobody notice that we were adding
> > 2 times the same headers. (it's now fixed but still it's a reason why
> > using standard way to track MTU would have prevented that)
> 
> No, I'm sorry, this is completely unjustified complexity - not to
> mention it's buggy, too. Does qca8k support cascaded setups? Because if
> it does:
> 
> 	/* We have only have a general MTU setting. So check
> 	 * every port and set the max across all port.
> 	 */
> 	list_for_each_entry(dp, &ds->dst->ports, list) {
> 		/* We can ignore cpu port, DSA will itself chose
> 		 * the max MTU across all port
> 		 */
> 		if (!dsa_port_is_user(dp))
> 			continue;
> 
> 		if (dp->index == port)	// <- this will exclude from the max MTU calculation the ports in other switches that are numerically equal to @port.
> 			continue;
> 
> 		/* Address init phase where not every port have
> 		 * a slave device
> 		 */
> 		if (!dp->slave)
> 			continue;
> 
> 		if (mtu < dp->slave->mtu)
> 			mtu = dp->slave->mtu;
> 	}
> 
> Not to mention it's missing the blatantly obvious. DSA calls
> ->port_change_mtu() on the CPU port with the max MTU, every time that
> changes.
> 
> You need the max MTU.
> 
> Why calculate it again? Why don't you do what mt7530 does, which has a
> similar restriction, and just program the hardware when the CPU port MTU
> is updated?
>

I just checked and wow it was that easy...
Also wonder if I should add some check for jumbo frame... (I should
check what is the max MTU for the switch and if it can accept jumbo
frame+fcs+l2)

> You may think - does this work with multiple CPU ports? Well, yes it
> does, since DSA calculates the largest MTU across the entire tree, and
> not just across the user ports affine to a certain CPU port.
> 
> If it wasn't for this possibility, I would have been in favor of
> introducing a dsa_tree_largest_mtu(dst) helper in the DSA core, but I
> can't find it justifiable.
> 
> > > > Also from this I discovered that (at least on ipq806x that use stmmac)
> > > > when master needs to change MTU, stmmac complains that the interface is
> > > > up and it must be put down. Wonder if that's common across other drivers
> > > > or it's only specific to stmmac.
> > > 
> > > I never had the pleasure of dealing with such DSA masters. I wonder why
> > > can't stmmac_change_mtu() check if netif_running(), call dev_close and
> > > set a bool, and at the end, if the bool was set, call dev_open back?
> > 
> > Oh ok so it's not standard that stmmac_change_mtu() just refuse to
> > change the MTU instead of put the interface down, change MTU and reopen
> > it... Fun stuff...
> > 
> > From system side to change MTU to a new value (so lower MTU on any port
> > or set MTU to a higher value for one pot) I have to:
> > 1. ifconfig eth0 down
> > 2. ifconfig lan1 mtu 1600 up
> > 3. ifconfig eth up
> > 
> > If I just ifconfig lan1 mtu 1600 up it's just rejected with stmmac
> > complaining.
> 
> Not sure if there is any hard line on this. But I made a poll, and the
> crushing majority of drivers in drivers/net/ethernet/ do not require
> !netif_running() in ndo_change_mtu. The ones that do are:
> 
> nixge
> macb
> altera tse
> axienet
> renesas sh
> ksz884x
> bcm63xx_enet
> sundance
> stmmac
> 
> (compared to more than 100 that don't, and even have a dedicated code
> path for live changes)
> 
> By the way, an an interesting aside - I've found the xgene, atl1c and
> xgmac drivers to be obviously odd (meaning that more drivers might be
> odd in the same way, but in more subtle ways I haven't noticed):
> when netif_running() is false, they simply return 0, but they don't
> change dev->mtu either, they just ignore the request.
> 
> So on one hand you have drivers that _want_ to be down to change the
> MTU, and on the other you have drivers that silently ignore MTU changes
> when they're down. Hard for DSA to do something reasonable to handle
> both cases...

Wonder if I should propose a change for stmmac and just drop the
interface and restart it when the change is down.

-- 
	Ansuel
