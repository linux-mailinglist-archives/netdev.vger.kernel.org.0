Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989D74E61E9
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 11:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349563AbiCXKrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 06:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232195AbiCXKrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 06:47:00 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1A02183F;
        Thu, 24 Mar 2022 03:45:28 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z92so5092232ede.13;
        Thu, 24 Mar 2022 03:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=biC8XxjFBFJRBfbkCPR5EBa1a0P/0ynYveve2Ep0qV0=;
        b=BKGYyvWHbcDloPXiM3TtjomUTbLfpzjijDz1CUSMhMaYPyoP3DDsynib8PvwvPKHyt
         UNTv8XB05nqKaIIDHAerB8rsXwEmvE45ceAmjFYSCPNMnbHpaO48y5GDYPMePNhwX7lI
         o5i9CI9lzs9jgCla3yX2ocXiX3gd7WuwDyWckIcQvoyHdydpOnKFjBshnTUd99XAJDyf
         Wc5uHrsmTJrU95KUMR8lNley0KngxodcMNKaFD1LVESWQ3WOBRNG5O9XlgkU86e+//wk
         PWN0ceFjeybY9GZkCcozPZa/5tp33JxdM7twsyvYqQHqKVAbeyCMUSIC27iR3Rf5LmzZ
         YCcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=biC8XxjFBFJRBfbkCPR5EBa1a0P/0ynYveve2Ep0qV0=;
        b=NP1XewJMMgrqIkWRIgbPkkDCxkxQqJXAxaS8c0+OuoFJM3PLOqak/6iQIUDgv6xbJx
         juKLLbS92qH6MsSrb2ZFlra06NLt7ZdOMwNL2/0LJIZgJUGJL8GJinSTlSH1ZDGsNnYI
         3J7YTG3E5lJH3QQf6olKrk2Lb7c9B6hRLwctpbHczsplgyOL7vGp7uoAxDMjEgQDkDq9
         Eehhf6nFqsaHWlrdRHuZSFAmj9LaVYLp3Ve5+83z7vbegryxxKYdnL9n4R/+d6QW/S2D
         UD5me58NyRXI5FHq9ADavUGwPR5GvrQFrep23+X8OhlozD0m1CHWvSF9V6hVRZj7cN8R
         Su1g==
X-Gm-Message-State: AOAM530ghnJ3td4EXCKT+yjSYBqNZmyyW4IiAymkLwGrq/5w3gr5ObyG
        GQvZoY6UuyEbgBlwvHN3Fa0=
X-Google-Smtp-Source: ABdhPJxFxnDREh0n5f0+pNhgYiDN9+Ajv4H6dyWMHZPH1qTkzrd6lQMnJ1PAQ0M8xc8YrN7oALPptg==
X-Received: by 2002:a50:c099:0:b0:415:f5c7:700e with SMTP id k25-20020a50c099000000b00415f5c7700emr5791631edf.205.1648118726677;
        Thu, 24 Mar 2022 03:45:26 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090600d600b006dfbc46efabsm981075eji.126.2022.03.24.03.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 03:45:25 -0700 (PDT)
Date:   Thu, 24 Mar 2022 12:45:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 1/4] drivers: net: dsa: qca8k: drop MTU tracking
 from qca8k_priv
Message-ID: <20220324104524.ou7jyqcbfj3fhpvo@skbuf>
References: <20220322014506.27872-1-ansuelsmth@gmail.com>
 <20220322014506.27872-2-ansuelsmth@gmail.com>
 <20220322115812.mwue2iu2xxrmknxg@skbuf>
 <YjnRQNg/Do0SwNq/@Ansuel-xps.localdomain>
 <20220322135535.au5d2n7hcu4mfdxr@skbuf>
 <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjnXOF2TZ7o8Zy2P@Ansuel-xps.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 03:03:36PM +0100, Ansuel Smith wrote:
> On Tue, Mar 22, 2022 at 03:55:35PM +0200, Vladimir Oltean wrote:
> > On Tue, Mar 22, 2022 at 02:38:08PM +0100, Ansuel Smith wrote:
> > > On Tue, Mar 22, 2022 at 01:58:12PM +0200, Vladimir Oltean wrote:
> > > > On Tue, Mar 22, 2022 at 02:45:03AM +0100, Ansuel Smith wrote:
> > > > > Drop the MTU array from qca8k_priv and use slave net dev to get the max
> > > > > MTU across all user port. CPU port can be skipped as DSA already make
> > > > > sure CPU port are set to the max MTU across all ports.
> > > > > 
> > > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > > > > ---
> > > > 
> > > > I hardly find this to be an improvement and I would rather not see such
> > > > unjustified complexity in a device driver. What are the concrete
> > > > benefits, size wise?
> > > >
> > > 
> > > The main idea here is, if the value is already present and accessible,
> > > why should we duplicate it? Tracking the MTU in this custom way already
> > > caused some bugs (check the comment i'm removing). We both use standard
> > > way to track ports MTU and we save some additional space. At the cost of
> > > 2 additional checks are are not that much of a problem.
> > 
> > Where is the bug?
> 
> There was a bug where we tracked the MTU with the FCS and L2 added and
> then in the change_mtu code we added another time the FCS and L2 header
> just because we used this custom way and nobody notice that we were adding
> 2 times the same headers. (it's now fixed but still it's a reason why
> using standard way to track MTU would have prevented that)

No, I'm sorry, this is completely unjustified complexity - not to
mention it's buggy, too. Does qca8k support cascaded setups? Because if
it does:

	/* We have only have a general MTU setting. So check
	 * every port and set the max across all port.
	 */
	list_for_each_entry(dp, &ds->dst->ports, list) {
		/* We can ignore cpu port, DSA will itself chose
		 * the max MTU across all port
		 */
		if (!dsa_port_is_user(dp))
			continue;

		if (dp->index == port)	// <- this will exclude from the max MTU calculation the ports in other switches that are numerically equal to @port.
			continue;

		/* Address init phase where not every port have
		 * a slave device
		 */
		if (!dp->slave)
			continue;

		if (mtu < dp->slave->mtu)
			mtu = dp->slave->mtu;
	}

Not to mention it's missing the blatantly obvious. DSA calls
->port_change_mtu() on the CPU port with the max MTU, every time that
changes.

You need the max MTU.

Why calculate it again? Why don't you do what mt7530 does, which has a
similar restriction, and just program the hardware when the CPU port MTU
is updated?

You may think - does this work with multiple CPU ports? Well, yes it
does, since DSA calculates the largest MTU across the entire tree, and
not just across the user ports affine to a certain CPU port.

If it wasn't for this possibility, I would have been in favor of
introducing a dsa_tree_largest_mtu(dst) helper in the DSA core, but I
can't find it justifiable.

> > > Also from this I discovered that (at least on ipq806x that use stmmac)
> > > when master needs to change MTU, stmmac complains that the interface is
> > > up and it must be put down. Wonder if that's common across other drivers
> > > or it's only specific to stmmac.
> > 
> > I never had the pleasure of dealing with such DSA masters. I wonder why
> > can't stmmac_change_mtu() check if netif_running(), call dev_close and
> > set a bool, and at the end, if the bool was set, call dev_open back?
> 
> Oh ok so it's not standard that stmmac_change_mtu() just refuse to
> change the MTU instead of put the interface down, change MTU and reopen
> it... Fun stuff...
> 
> From system side to change MTU to a new value (so lower MTU on any port
> or set MTU to a higher value for one pot) I have to:
> 1. ifconfig eth0 down
> 2. ifconfig lan1 mtu 1600 up
> 3. ifconfig eth up
> 
> If I just ifconfig lan1 mtu 1600 up it's just rejected with stmmac
> complaining.

Not sure if there is any hard line on this. But I made a poll, and the
crushing majority of drivers in drivers/net/ethernet/ do not require
!netif_running() in ndo_change_mtu. The ones that do are:

nixge
macb
altera tse
axienet
renesas sh
ksz884x
bcm63xx_enet
sundance
stmmac

(compared to more than 100 that don't, and even have a dedicated code
path for live changes)

By the way, an an interesting aside - I've found the xgene, atl1c and
xgmac drivers to be obviously odd (meaning that more drivers might be
odd in the same way, but in more subtle ways I haven't noticed):
when netif_running() is false, they simply return 0, but they don't
change dev->mtu either, they just ignore the request.

So on one hand you have drivers that _want_ to be down to change the
MTU, and on the other you have drivers that silently ignore MTU changes
when they're down. Hard for DSA to do something reasonable to handle
both cases...
