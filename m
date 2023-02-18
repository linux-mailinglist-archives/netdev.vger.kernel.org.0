Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040BC69BA50
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 14:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjBRN5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 08:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBRN5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 08:57:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DBE310244
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 05:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qbcjYWnkFEGwB01PH89oG6HLeHe4RvLZMWwpkyonTFc=; b=QFohq7y5a/AJL/+PkRe9Rfl4Zt
        jYInID9D4IPlqTp450uyWhCKO8WNfXCPdKF2CeRB5cUfcP2sxjlX1nE2HoP5XuVHnw/kB1omyC/2V
        WAWDZQXsepvcD1w9PVlVLfPl7pAPd4QbkinPo/dn+DOrKGQGCCsKuV/v5W/2BjdSatGJq3TjVcwTj
        ikeEq3dbHkqmKxRpuc3UWpNwT781r8JdoQYEdUBydZYhEfjk4SMx2W1OrN8ALULe0fQ4xuumBJE19
        WjL0IRC5ZyZ3F5M7DQbtswErnq7gjPJtHOsAqxDpYExRLJ9Sb9WWdFtflh6n3WXoau30+zfOIFQjL
        PY5Z247A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51444)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pTNhw-00025t-3R; Sat, 18 Feb 2023 13:56:56 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pTNhu-0007nw-SN; Sat, 18 Feb 2023 13:56:54 +0000
Date:   Sat, 18 Feb 2023 13:56:54 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Angelo Dureghello <angelo@kernel-space.org>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <Y/DZJmn4OfVA+hRq@shell.armlinux.org.uk>
References: <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
 <20230216125040.76ynskyrpvjz34op@skbuf>
 <Y+4oqivlA/VcTuO6@lunn.ch>
 <20230216153120.hzhcfo7t4lk6eae6@skbuf>
 <07ac38b4-7e11-82bd-8c24-4362d7c83ca0@kernel-space.org>
 <20230218133036.ec3fsaefs5jn7l7f@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230218133036.ec3fsaefs5jn7l7f@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 03:30:36PM +0200, Vladimir Oltean wrote:
> On Thu, Feb 16, 2023 at 07:39:11PM +0100, Angelo Dureghello wrote:
> > I have a last issue, migrating from 5.4.70,
> > in 5.15.32 i have this error for both sfp cages:
> > 
> > # [   45.860784] mv88e6085 5b040000.ethernet-1:1d: p0: phylink_mac_link_state() failed: -95
> > [   45.860814] mv88e6085 5b040000.ethernet-1:1d: p0: phylink_mac_link_state() failed: -95
> > [   49.093371] mv88e6085 5b040000.ethernet-1:1d: p1: phylink_mac_link_state() failed: -95
> > [   49.093400] mv88e6085 5b040000.ethernet-1:1d: p1: phylink_mac_link_state() failed: -95
> > 
> > Is seems related to the fact that i am in in-band-status,
> > but 6321 has not serdes_pcs_get_state() op.
> > 
> > How can i fix this ?
> > 
> > Thanks !
> > -- 
> > Angelo Dureghello
> 
> Looking at mv88e6321_ops in the latest net-next and in 5.4, I see no
> serdes ops implemented in net-next. OTOH, in 5.4, the equivalent of the
> current .serdes_pcs_get_state() which is now missing was .port_link_state().
> In 5.4, mv88e6321_ops had .port_link_state() set to mv88e6352_port_link_state(),
> but this got deleted with commit dc745ece3bd5 ("net: dsa: mv88e6xxx:
> remove port_link_state functions") and seemingly was not replaced with
> anything for 6321.
> 
> I don't actually know how this is supposed to work. Maybe Russell King can help?

I've no idea offhand, and as today I feel utterly shit due to post-
Covid, I'm not going to be able to sort through and work out what
happened for a few days. Sorry. I'll try to look at it next week
provided I feel better.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
