Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E58054D24A
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 22:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241016AbiFOUIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 16:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbiFOUIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 16:08:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B40D40E4C;
        Wed, 15 Jun 2022 13:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BBcKY2EoP2XAVkQOai1YZk1rJli37iClEl0y13zev2I=; b=vM/EiOeN0aRI7dKUjK6oA1UQxm
        lHMtho/S4DJQ27LEmGYgKnCQ8gnBBmwHyMaKsF0aTqypej1hhG5Y05u183Np8fewsqc+ZeYRqsri4
        XtnE5WuFEHGP3rbIL+pvPKWDitQxifCUXjmcGCzJe1u3VQrgUz97HsyELz7CzxBdYwlc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1ZIc-0073FI-5V; Wed, 15 Jun 2022 22:07:34 +0200
Date:   Wed, 15 Jun 2022 22:07:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: phy: add remote fault support
Message-ID: <Yqo8BuxL+XKw8U+a@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
 <YqdQJepq3Klvr5n5@lunn.ch>
 <20220614185221.79983e9b@kernel.org>
 <YqlUCtJhR1Iw3o3F@lunn.ch>
 <20220614220948.5f0b4827@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614220948.5f0b4827@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 10:09:48PM -0700, Jakub Kicinski wrote:
> On Wed, 15 Jun 2022 05:37:46 +0200 Andrew Lunn wrote:
> > > Does this dovetail well with ETHTOOL_A_LINKSTATE_EXT_STATE /
> > > ETHTOOL_A_LINKSTATE_EXT_SUBSTATE ?
> > > 
> > > That's where people who read extended link state out of FW put it
> > > (and therefore it's read only now).  
> > 
> > I did wonder about that. But this is to do with autoneg which is part
> > of ksetting. Firmware hindered MAC drivers also support ksetting
> > set/get.  This patchset is also opening the door to more information
> > which is passed via autoneg. It can also contain the ID the link peer
> > PHY, etc. This is all part of 802.3, where as
> > ETHTOOL_A_LINKSTATE_EXT_STATE tends to be whatever the firmware
> > offers, not something covered by a standard.
> 
> I see, yeah, I think you're right.
> 
> But I'm missing the bigger picture. I'm unclear on who is supposed 
> to be setting the fault user space or kernel / device?

It is also a bit unclear, but at the moment, i think user
space. However, i can see the kernel making use of maybe RF TEST to
ask the link peer to go quiet in order to perform a cable test.

Oleksij, what are your use cases? Maybe add something to patch 0/X
indicating how you plan to make use of this?

	 Andrew
