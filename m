Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547C76C1141
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCTLyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjCTLyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:54:08 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D7510435;
        Mon, 20 Mar 2023 04:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tpDwlTsLlGREtqpgpuzE2hrkLzTmenU/2dk0EKrGIFQ=; b=qH7vwDbeu7NOkQjdNnjmMHg4Km
        AVUaSWNMOCYcQh+eiRXWhSDPRWWIh0PFMS4g31XIG8Lamrf+o+0yYyDzqZChLNpGZquU/fBi9Giuo
        5AS3d15IsN0sANS7RJIBluz6QTLscG5IhgG2iQg4XflOF9QZMldaj4Sf3YMHrlFdzGiiU6GsvbnqU
        rDv7AjclGKxa7UXrQbf313h4pnWoA5TtRN2QyKBMG2DBbezxsmu1DdeWrf6hquwQ8rcFPUpQiOV/h
        9dq1SFpnaxb7jJJzttd92ysK3R8HWmFI1o7qYCCPVqbaMQSufO2MG/LpuB9a1BZ5dWT+H8Kp82idB
        muLftrZw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46278)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1peE5P-0007Jo-LV; Mon, 20 Mar 2023 11:53:59 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1peE5O-0006Ud-Ll; Mon, 20 Mar 2023 11:53:58 +0000
Date:   Mon, 20 Mar 2023 11:53:58 +0000
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
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH net-next v14 9/9] net: dsa: mt7530: use external PCS
 driver
Message-ID: <ZBhJVr8FkdpTJRGf@shell.armlinux.org.uk>
References: <cover.1679230025.git.daniel@makrotopia.org>
 <a770f39662182c5dd494d98717820f5bd98a47e2.1679230025.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a770f39662182c5dd494d98717820f5bd98a47e2.1679230025.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 12:58:43PM +0000, Daniel Golle wrote:
> Implement regmap access wrappers, for now only to be used by the
> pcs-mtk-lynxi driver.
> Make use of this external PCS driver and drop the now reduntant
> implementation in mt7530.c.
> As a nice side effect the SGMII registers can now also more easily be
> inspected for debugging via /sys/kernel/debug/regmap.
> 
> Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
