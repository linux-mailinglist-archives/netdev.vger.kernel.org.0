Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F1A4ACEB1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345962AbiBHCKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345928AbiBHCKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:10:24 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD4DC03E907;
        Mon,  7 Feb 2022 18:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=E1JRzX7mOGLhHiS73dczVs4lf+o1P6khOplF/he8OTo=; b=esBuyYaicdEcEBw43ZI5nhYoTI
        s8NGh821NpRFGdar3iha+ICGEgQ9B4+VM5LuFiLR/Z4/603fsfmJcxEH+I/sq4aVl7iDhjxBO+t/a
        oH9FbbjhicRFTpF1Prs93SxPFpXMOOW+nLhyWqug572rfBx+OliXa9+W8+bHrkKqstuc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHFwy-004jou-8n; Tue, 08 Feb 2022 03:09:48 +0100
Date:   Tue, 8 Feb 2022 03:09:48 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <YgHQ7Kf+2c9knxk3@lunn.ch>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
 <YgANBQjsrmK+T/N+@lunn.ch>
 <20220207174948.GA5183@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207174948.GA5183@localhost>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> MAC implementation[1] in a lot of NXP SoCs comes with in-band aneg enabled
> by default, and it does expect Clause 37 auto-negotiation to complete
> between MAC and PHY before the actual data transfer happens.
> 
> [1] https://community.nxp.com/pwmxy87654/attachments/pwmxy87654/t-series/3241/1/AN3869(1).pdf
> 
> I faced such issue while integrating VSC85xx PHY
> with one of the recent NXP SoC having similar MAC implementation.
> Not sure if this is a problem on MAC side or PHY side,
> But having Clause 37 support should help in most cases I believe.

So please use this information in the commit message.

The only danger with this change is, is the PHY O.K with auto-neg
turned on, with a MAC which does not actually perform auto-neg? It
could be we have boards which work now because PHY autoneg is turned
off.

      Andrew
