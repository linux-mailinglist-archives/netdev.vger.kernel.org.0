Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7354C038
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 05:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245571AbiFODiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 23:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbiFODiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 23:38:05 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED8E4D9CB;
        Tue, 14 Jun 2022 20:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lsrUjjkep0NIk/RaiU0ydFTVhZTu6GbkH8h9icB/mZo=; b=wpBbpHFPbowTv9BFpVZtgpy50b
        8rxx7MmritivOZbz1xS6bbDZFevf3XIcE3gSM/tScbgJC96tXUCi5HB4H8nsV+j3h+Sou/qF4d2me
        6Id55Bwo0gddSpx7C7I1hUdxd1K2y5JF3S2Gttm28uQVCvZ16GS34zX/YZ8gOLNMUKHM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1Jqk-006xbQ-9w; Wed, 15 Jun 2022 05:37:46 +0200
Date:   Wed, 15 Jun 2022 05:37:46 +0200
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
Message-ID: <YqlUCtJhR1Iw3o3F@lunn.ch>
References: <20220608093403.3999446-1-o.rempel@pengutronix.de>
 <YqS+zYHf6eHMWJlD@lunn.ch>
 <20220613125552.GA4536@pengutronix.de>
 <YqdQJepq3Klvr5n5@lunn.ch>
 <20220614185221.79983e9b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614185221.79983e9b@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 06:52:21PM -0700, Jakub Kicinski wrote:
> On Mon, 13 Jun 2022 16:56:37 +0200 Andrew Lunn wrote:
> > That would suggest we
> > want a ETHTOOL_LINK_MODE_REMOTE_FAULT_BIT, which we can set in
> > supported and maybe see in lpa?
> 
> Does this dovetail well with ETHTOOL_A_LINKSTATE_EXT_STATE /
> ETHTOOL_A_LINKSTATE_EXT_SUBSTATE ?
> 
> That's where people who read extended link state out of FW put it
> (and therefore it's read only now).

I did wonder about that. But this is to do with autoneg which is part
of ksetting. Firmware hindered MAC drivers also support ksetting
set/get.  This patchset is also opening the door to more information
which is passed via autoneg. It can also contain the ID the link peer
PHY, etc. This is all part of 802.3, where as
ETHTOOL_A_LINKSTATE_EXT_STATE tends to be whatever the firmware
offers, not something covered by a standard.

	Andrew
