Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8EB69AE03
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 15:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjBQO0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 09:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjBQO0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 09:26:13 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC37E384
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 06:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=iFTFSjUDEc09Dg+zzleu8t2Pvc3oX+TINsQ4PoDARnM=; b=i+k9sgMvno2vjlXYHrJEpwOvhS
        sXtp8Reh0RpQ4oq+wOywpTf8pQ24RQi5UU0YOcbfYJT+pQtBbdKGvO8JQM8mPDRZ7qo8VAR/br2Si
        NAQAOse3I0XwR4MUTQ8DuAwtM1pAnw2GSV+P6oXxPiiHzdt0G99cq+/P7tvFKrBUDRp1ZJlxgV4ws
        QDmP9s1jkwXWmLg6obOf5oOa1f0sbFWTJaYvqk6kYsRlr5TwEhQ4sm13pqEeJunsldkJlZTeMQPkR
        n8yDK/kxTc9ZVOJQAa48v2uUzQ0787ZdPHjx4fyvgNgDBhFzMkb3dAZzDokR9fmiCTow1Z3dSV2eQ
        s5RnZbYA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49278)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pT1gZ-00016C-HA; Fri, 17 Feb 2023 14:26:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pT1gT-0006sL-7P; Fri, 17 Feb 2023 14:25:57 +0000
Date:   Fri, 17 Feb 2023 14:25:57 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Doug Berger <opendmb@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        UNGLinuxDriver@microchip.com, Byungho An <bh74.an@samsung.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH RFC 00/18] Rework MAC drivers EEE support
Message-ID: <Y++OdVY3S8D7uopq@shell.armlinux.org.uk>
References: <20230217034230.1249661-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217034230.1249661-1-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 04:42:12AM +0100, Andrew Lunn wrote:
> phy_init_eee() is supposed to be called once auto-neg has been
> completed to determine if EEE should be used with the current link
> mode. The MAC hardware should then be configured to either enable or
> disable EEE. Many drivers get this wrong, calling phy_init_eee() once,
> or only in the ethtool set_eee callback.

Looking at some of the recent EEE changes (not related to this patch
set) I've come across:

commit 9b01c885be364526d8c05794f8358b3e563b7ff8
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Sat Feb 11 08:41:10 2023 +0100

    net: phy: c22: migrate to genphy_c45_write_eee_adv()

This part of the patch is wrong:

__genphy_config_aneg():
-       if (genphy_config_eee_advert(phydev))
+       err = genphy_c45_write_eee_adv(phydev, phydev->supported_eee);

The problem here is that these are not equivalent.

genphy_config_eee_advert() only clears the broken EEE modes in the
advertisement, it doesn't actually set the advertisement to anything
in particular.

The replacement code _configures_ the advertisement to whatever the
second argument is, which means each time the advertisement is
changed (and thus __genphy_config_aneg() is called) the EEE
advertisement will ignore whatever the user configured via the
set_eee() APIs, and be restored to the full EEE capabilities in the
supported mask.

This is an obvious regression that needs fixing, especially as the
merge window is potentially due to open this weekend.

Moreover, it looks like Oleksij's patch was not Cc'd to me (I can't
find it in my mailbox) and as I'm listed in MAINTAINERS for phylib,
this should have been brought up _before_ Oleksij's patch was
applied to net-next (despite me being unlikely to reply to it due
to covid, it still would be nice to have reviewed it, or even
reply to the damn patch about these concerns.) But I'm having to
pick some other damn series to bring up this concern.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
