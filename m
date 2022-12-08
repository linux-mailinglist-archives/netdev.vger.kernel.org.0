Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B46466C0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLHCLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHCLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:11:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6C87061D;
        Wed,  7 Dec 2022 18:11:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3E26B821CC;
        Thu,  8 Dec 2022 02:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF965C433C1;
        Thu,  8 Dec 2022 02:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670465458;
        bh=7fSMzabGdeXBXdSRzsXw0OXmPL8SYgx4xc8ELsxJnKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rcj7fBEQEMAY220RaPL1GkzxfdHKdMhwCtlrcOzuwu8idsyiW5IQVvJ+w3C/wS1t/
         xmRc1lX0bbdXM3ym5bhgGBsjsmJ/npP0NFBnKJtYwDgcy6k6VVvE0EL0NizSU9hUaG
         9nPi89KI6DnKrhuwIUxNEZXk/TpITKboCxYJbBq8uPKOjjT1IVeEBtYpgDtP1sgoxX
         XKh6D/nvy1U5+MwuqgHj41cmqoQ+dzVIWvofZNdCpA+qyVO1N9DpJy/Qp9L1QtIZQO
         tHPNmTAaZmFJ44yW1DQFeu8WP02vgeNpuKZYgWxqsV7BrCY/4P/eAjsx5RzH6C/u7G
         Y1ueh8zFYjeuA==
Date:   Wed, 7 Dec 2022 18:10:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <20221207181056.121cdf34@kernel.org>
In-Reply-To: <Y5CQY0pI+4DobFSD@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
        <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
        <20221206195014.10d7ec82@kernel.org>
        <Y5CQY0pI+4DobFSD@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 14:08:51 +0100 Piergiorgio Beruto wrote:
> > > +  ``ETHTOOL_A_PLCA_ENABLED``              u8      PLCA Admin State
> > > +  ``ETHTOOL_A_PLCA_NODE_ID``              u8      PLCA unique local node ID
> > > +  ``ETHTOOL_A_PLCA_NODE_CNT``             u8      Number of PLCA nodes on the
> > > +                                                  netkork, including the  
> > 
> > netkork -> network  
> Got it, thanks.
> 
> > > +                                                  coordinator  
> > 
> > This is 30.16.1.1.3 aPLCANodeCount ? The phrasing of the help is quite
> > different than the standard. Pure count should be max node + 1 (IOW max
> > of 256, which won't fit into u8, hence the question)
> > Or is node 255 reserved?  
> This is indeed aPLCANodeCount. What standard are you referring to
> exactly? This is the excerpt from IEEE802.3cg-2019
> 
> "
> 30.16.1.1.3 aPLCANodeCount
> ATTRIBUTE
> APPROPRIATE SYNTAX:
> INTEGER
> BEHAVIOUR DEFINED AS:
> This value is assigned to define the number of nodes getting a transmit opportunity before a new
> BEACON is generated. Valid range is 0 to 255, inclusive. The default value is 8.;

FWIW this is what I was referring to. To a layperson this description
reads like a beacon interval. While the name and you documentation
sounds like the define max number of endpoints. 

> And this is what I can read in the OPEN Alliance documentation:
> 
> "
> 4.3.1 NCNT
> This field sets the maximum number of PLCA nodes supported on the multidrop
> network. On the node with PLCA ID = 0 (see 4.3.2), this value must be set at
> least to the number of nodes that may be plugged to the network in order for
> PLCA to operate properly. This bit maps to the aPLCANodeCount object in [1]
> Clause 30.
> "
> 
> So the valid range is actually 1..255. A value of 0 does not really mean
> anything. PHYs would just clamp this to 1. So maybe we should set a
> minimum limit in the kernel?

SG, loosing limits is easy. Introducing them once they are in 
a released kernel is almost impossible.

> Please, feel free to ask more questions here, it is important that we
> fully understand what this is. Fortunately, I am the guy who invented
> PLCA and wrote the specs, so I should be able to answer these questions :-D.

I am a little curious why beacon interval == node count here, but don't
want to take up too much of your time for explaining things I could
likely understand by reading the spec, rather than fuzzy-mapping onto
concepts I comprehend :(

This is completely unrelated to the series - do you know if any of
the new 10BASE stuff can easily run over a DC power rail within 
a server rack? :)

> > > +When set, the ``ETHTOOL_A_PLCA_STATUS`` attribute indicates whether the node is
> > > +detecting the presence of the BEACON on the network. This flag is
> > > +corresponding to ``IEEE 802.3cg-2019`` 30.16.1.1.2 aPLCAStatus.  
> > 
> > I noticed some count attributes in the spec, are these statistics?
> > Do any of your devices support them? It'd be good to add support in
> > a fixed format via net/ethtool/stats.c from the start, so that people
> > don't start inventing their own ways of reporting them.
> > 
> > (feel free to ask for more guidance, the stats support is a bit spread
> > out throughout the code)  
> Are you referring to this?
> 
> "
> 45.2.3.68f.1 CorruptedTxCnt (3.2294.15:0)
> Bits 3.2294.15:0 count up at each positive edge of the MII signal COL.
> When the maximum allowed value (65 535) is reached, the count stops until
> this register is cleared by a read operation.
> "
> 
> This is the only one statistic counter I can think of. Although, it is a
> 10BASE-T1S PHY related register, it is not specific to PLCA, even if its
> main purpose is to help the user distinguish between logical and
> physical collisions.
> 
> I would be inclined to add this as a separate feature unrelated to PLCA.
> Please, let me know what you think.

Fair point, I just opened the standard and searched counters.
Indeed outside of the scope here.

> > >   * @start_cable_test: Start a cable test
> > >   * @start_cable_test_tdr: Start a Time Domain Reflectometry cable test
> > >   *
> > > @@ -819,6 +823,13 @@ struct ethtool_phy_ops {
> > >  	int (*get_strings)(struct phy_device *dev, u8 *data);
> > >  	int (*get_stats)(struct phy_device *dev,
> > >  			 struct ethtool_stats *stats, u64 *data);
> > > +	int (*get_plca_cfg)(struct phy_device *dev,
> > > +			    struct phy_plca_cfg *plca_cfg);
> > > +	int (*set_plca_cfg)(struct phy_device *dev,
> > > +			    struct netlink_ext_ack *extack,
> > > +			    const struct phy_plca_cfg *plca_cfg);  
> > 
> > extack is usually the last argument  
> I actually copied from the cable_test_tdr callback below. Do you still
> want me to change the order? Should we do this for cable test as well?
> (as a different patch maybe?). Please, let me know.

Let's not move it in the existing callbacks but yes, cable_test_tdr
is more of an exception than a rule here, I reckon.

> > > +	int (*get_plca_status)(struct phy_device *dev,
> > > +			       struct phy_plca_status *plca_st);  
> > 
> > get status doesn't need exact? I guess..  
> This is my assumption. I would say it is similar to get_config, and I
> would say it is mandatory. I can hardly think of a system that does not
> implement get_status when supporting PLCA.
> Thoughts?

Sounds good.

> > The casts are unnecessary, but if you really really want them they 
> > can stay..  
> Removed it. Sorry, In the past I used to work in an environment where
> thay wanted -unnecessary- casts everywhere. I just need to get used to
> this...

:( Turns out the C language is evolving more than one would have
thought. Or at least what's considered good taste. In the kernel
we don't require casts. Here the helper has type in its name,
so it's very obvious.

> > > +	[ETHTOOL_A_PLCA_NODE_ID]	= { .type = NLA_U8 },  
> > 
> > Does this one also need check against 255 or is 255 allowed?  
> Good question. 255 has a special meaning --> unconfigured.
> So the question is, do we allow the user to set nodeID back to
> unconfigured? My opinion is yes, I don't really see a reson why not and
> I can see cases where I actually want to do this.
> Would you agree?

Just asking because of the tendency to limit inputs where possible
for backward compatibility. I'd think user space should be happy
with just disabling a node, but I defer to your expertise on whether
there's possible cases for giving the access to the full range to 
the user.

> > > +	if (tb[ETHTOOL_A_PLCA_BURST_TMR]) {
> > > +		plca_cfg.burst_tmr = nla_get_u8(tb[ETHTOOL_A_PLCA_BURST_TMR]);
> > > +		mod = true;
> > > +	}  
> > 
> > Could you add a helper for the modifications? A'la ethnl_update_u8, but
> > accounting for the oddness in types (ergo probably locally in this file
> > rather that in the global scope)?  
> I put the helper locally. We can always promote them later if more
> features follow this 'new' approach suggested by Andrew. Makes sense?

SG
