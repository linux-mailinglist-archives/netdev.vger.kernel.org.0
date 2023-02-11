Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060D969310E
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 13:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjBKMqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 07:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBKMq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 07:46:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5823B0EB;
        Sat, 11 Feb 2023 04:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BLTpt9NribeB5KMCID04Kp1GCZg75vTmz/0Yqc7IzK8=; b=SYdAdt329gXs0IyLorGGnNrYdS
        DiDXFkDFWfxgHN3HJC5FK/t2HW2KvLZkhzruaFkR2Pcf4qf6KMOR+mto7EY92Gruhe/BTtRiFCL2h
        sp2wW+5rsLboE6bTcfE7fnViX6xGGVT3Ua/+nhB/VO2+7jiPTkEY64zzXDCB/Uidq18tbLbQ7er9+
        hueOkzq+yPWOuu2Xa7Bi9CWzYWyD+7Y0hZClKdV3mNMr05nqCYDYiXHzOZgOpWHM/ErFUnbsQzefn
        LL3JOtDQSva9o74ZvNnaO5ieglQUUgFrf6cUjeckaQyeKnMhvPzNh/7IWf0X6f7EDVKWC7rGqLEgx
        KsLL4OVA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:60042)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pQpGk-0001av-9g; Sat, 11 Feb 2023 12:46:18 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pQpGd-00017Z-BF; Sat, 11 Feb 2023 12:46:11 +0000
Date:   Sat, 11 Feb 2023 12:46:11 +0000
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
Subject: Re: [PATCH v4 07/12] net: ethernet: mtk_eth_soc: only write values
 if needed
Message-ID: <Y+eOEx2KqvfV4TNo@shell.armlinux.org.uk>
References: <cover.1676071507.git.daniel@makrotopia.org>
 <ca95a266578bc52df44b432dfb2de7410d5202d9.1676071508.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ca95a266578bc52df44b432dfb2de7410d5202d9.1676071508.git.daniel@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 11:38:36PM +0000, Daniel Golle wrote:
> Only restart auto-negotiation and write link timer if actually
> necessary.
> 
> Tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
