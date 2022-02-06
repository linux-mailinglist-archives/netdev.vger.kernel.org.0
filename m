Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C5E4AB0EB
	for <lists+netdev@lfdr.de>; Sun,  6 Feb 2022 18:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237351AbiBFRSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Feb 2022 12:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiBFRSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Feb 2022 12:18:36 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84734C06173B;
        Sun,  6 Feb 2022 09:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=WZawEW9E5ypY6Rh387lFEt31JC2J35mGwrAMc0/AAzo=; b=XzNSINIBxMQVdoTpXXnrPQzf2q
        pk211w38Qs3kErnL+k8t7syiQ5zoeirAlUJzTwt8Pa9w4ZsO1Q3czT///aWzv7KhIoCecbc2T1dX4
        sjLBD4lghAlPv2APe5J7BKKvuLm3XrBMLH4Eu944Sdxm+MUow+GPxxZuB18qF4hLE3cGvLXfGnzXs
        QD1nvXzPzUX1jbTLT2bjSfxfuhBGI9gQ7wZBi1lNKWSiuAye/avfUJ898gwSmhNRXsRy2CJxNHXsm
        ZTjfU1x3MY16/PXPNMnO7py0r3uzDheMhlQYjjPXtjhf1N3lH4RyYMcosQcRnwBHcNOS4qfrs/K+7
        MGhNDhOQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57066)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nGlBA-0000Ad-EQ; Sun, 06 Feb 2022 17:18:24 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nGlB6-00073Y-AG; Sun, 06 Feb 2022 17:18:20 +0000
Date:   Sun, 6 Feb 2022 17:18:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Raag Jadav <raagjadav@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Message-ID: <YgAC3I/7EENrN8r7@shell.armlinux.org.uk>
References: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
 <Yf6QbbqaxZhZPUdC@lunn.ch>
 <20220206171234.GA5778@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220206171234.GA5778@localhost>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 06, 2022 at 10:42:34PM +0530, Raag Jadav wrote:
> Once the PHY auto-negotiates parameters such as speed and duplex mode
> with its link partner over the copper link as per IEEE 802.3 Clause 27,
> the link partner’s capabilities are then transferred by PHY to MAC
> over 1000BASE-X or SGMII link using the auto-negotiation functionality
> defined in IEEE 802.3z Clause 37.

This is slightly incorrect. 1000BASE-X is only capable of operating at
gigabit speed, not at 100M or 10M.

The PHY _might_ signal the copper side pause resolution via the
1000BASE-X negotiation word, and even rarer would be whether operating
at 1G FD or 1G HD.

Out of the two, only SGMII is capable of operating at 1G, 100M and 10M,
FD or HD. No pause resolution is passed. SGMII is not an 802.3 defined
protocol, it's an adaption of 1000BASE-X by Cisco.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
