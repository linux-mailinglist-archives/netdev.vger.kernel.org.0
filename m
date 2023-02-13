Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99FB06945B8
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBMMYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjBMMYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:24:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF236A71;
        Mon, 13 Feb 2023 04:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gOEavSKobxzkNUwIbNjE6psRFHrp/W2anCwg7BkkLCc=; b=ObDVlDbZLK9iuH4F+Lz0ntxyzW
        4s555KAxM8FkX5eXfRjE0I/9j9dVWUeM69v2YVi9jDwHrTban4YD0k5PRV3XgTNRBhcDW8OIxkIaS
        MAlOagHiPjt1Y32EREWUz7m7PNcgoELK8FNv3iF96qEe1MELulK6Q0lN2aYSBNgt8miKyUHCEE4vq
        KZT3KL94ZnJBbZ7NCiJgkO4vfbCFdJ9ADBriaX4hap1BU1ECSlzsEBW+E7/MqcIFZ0HIzqiIArLu6
        HmdVIexH0CKP+5F2PZlwOy+KnaW3PC7MZ4CM0O+e2Zm1OQIl78bSDqKveQNeVQaJeE9W7z5Hex7mo
        6Hdvp+Lw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58250)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pRXsF-00041Z-RT; Mon, 13 Feb 2023 12:23:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pRXs8-0002xY-TH; Mon, 13 Feb 2023 12:23:52 +0000
Date:   Mon, 13 Feb 2023 12:23:52 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Subject: Re: [PATCH v5 10/12] net: pcs: add driver for MediaTek SGMII PCS
Message-ID: <Y+or2P8K+BzDL7vi@shell.armlinux.org.uk>
References: <cover.1676128246.git.daniel@makrotopia.org>
 <ea7658198d2a1480746882a7e31adf0f37793086.1676128247.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea7658198d2a1480746882a7e31adf0f37793086.1676128247.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 11, 2023 at 04:04:51PM +0000, Daniel Golle wrote:
> The SGMII core found in several MediaTek SoCs is identical to what can
> also be found in MediaTek's MT7531 Ethernet switch IC.
> As this has not always been clear, both drivers developed different
> implementations to deal with the PCS.
> 
> Add a dedicated driver, mostly by copying the code now found in the
> Ethernet driver. The now redundant code will be removed by a follow-up
> commit.
> 
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
