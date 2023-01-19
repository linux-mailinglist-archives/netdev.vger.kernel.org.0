Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9983967406E
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjASSBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjASSBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:01:06 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD588758;
        Thu, 19 Jan 2023 10:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4cnYUwfrkdsesrrT+SXjYPoP9CYZdtUkqI2mtBXQK3g=; b=JUbA8ODkFhLyd+VvNpV3OS4155
        5j/VVNdsJs7Nip7RKV4gTD/WYcV41Uy9/hiqAdU/FsVu9QfqLON1qJKHukeKUohQ10JPkd9cICZIi
        vXNyMbmLcFx9QB6PYPTNaJyE4q827ld9ln6ezeiM+12gok+SbKlNVz1mC4kkFR1qdIAoZMTwVU/8k
        OPrQ0weRhPKp+KYfEBHFPNDv4kNWuPcuKKAYEuCJCrJE9/WbUWi04pHp2RQE4QXQDP29XA2nJNZDN
        9Y9CYs6njl9l+vaQ0fBZnr1kSqa4v0fz8DK1vBf+wGpwQU1PkbtySXFu3j01z4JZCQ2P4tWjZ7+Mz
        WW3NXaYg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36214)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIZDB-0004oT-TJ; Thu, 19 Jan 2023 18:00:29 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIZD2-0000fc-CQ; Thu, 19 Jan 2023 18:00:20 +0000
Date:   Thu, 19 Jan 2023 18:00:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Michael Walle <michael@walle.cc>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wells Lu <wellslutw@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RESEND net-next 0/4] net: mdio: Remove support for
 building C45 muxed addresses
Message-ID: <Y8mFNMwtCyiMwcN7@shell.armlinux.org.uk>
References: <20230119130700.440601-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119130700.440601-1-michael@walle.cc>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 02:06:56PM +0100, Michael Walle wrote:
> [Russell told me that his mailserver rejected my mail because of
> an ill-formated "To:" header. Resending now with plain git-send-email
> instead of b4 send.]
> 
> I've picked this older series from Andrew up and rebased it onto
> the latest net-next.
> 
> With all drivers which support c45 now being converted to a seperate c22
> and c45 access op, we can now remove the old MII_ADDR_C45 flag.

Great!

For the series:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
