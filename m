Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBAF59EA46
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiHWRlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiHWRkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:40:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC333AE59;
        Tue, 23 Aug 2022 08:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2Rl6PT1536lA2IP06YI5LrnFMzs1N1iwWlAcF8miKJ4=; b=UuDNQGRbnDfbUd/dTOHyoFNsug
        ySjHNNXvPl5QocbaJbT/BU33sKvz0veJEl8H+Kh2JI1YfGzM+xgusg/EeYSrBULWGMvl/1WsVI4WZ
        a3SHRDdjb8nnjl39oCCwPOi5/D+STPY5Gm+BXpJDwmHTJb0klkNtdUif3HLw3fFVYdUR3tMK7OfLE
        RKZfuDt5yh5MiBdDWu4gVV0HCVWXw/ab3A/FJZa+P86RDzee397qzSuRTcxtfhHqjYqHyIgDTFtlV
        /vREv5cn8A0uu63W5+VJx+K2wtXB41ZIPKf+yfxR/nrjtUmN/ePsNKQ1rjhNZQzM9HJyqwDhjmAXn
        AhKJktKw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33896)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQVph-0003LE-16; Tue, 23 Aug 2022 16:28:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQVpg-0003FV-0u; Tue, 23 Aug 2022 16:28:48 +0100
Date:   Tue, 23 Aug 2022 16:28:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Alexander Couzens <lynxis@fe80.eu>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Golle <daniel@makrotopia.org>
Subject: Re: [PATCH 3/4] net: mediatek: sgmii: mtk_pcs_setup_mode_an: don't
 rely on register defaults
Message-ID: <YwTyLwRnQ+eTXeDr@shell.armlinux.org.uk>
References: <20220820224538.59489-1-lynxis@fe80.eu>
 <20220820224538.59489-4-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220820224538.59489-4-lynxis@fe80.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 12:45:37AM +0200, Alexander Couzens wrote:
> Ensure autonegotiation is enabled.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 782812434367..aa69baf1a42f 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -32,12 +32,13 @@ static int mtk_pcs_setup_mode_an(struct mtk_pcs *mpcs)
>  	regmap_write(mpcs->regmap, SGMSYS_PCS_LINK_TIMER,
>  		     SGMII_LINK_TIMER_DEFAULT);
>  
> +	/* disable remote fault & enable auto neg */
>  	regmap_read(mpcs->regmap, SGMSYS_SGMII_MODE, &val);
> -	val |= SGMII_REMOTE_FAULT_DIS;
> +	val |= SGMII_REMOTE_FAULT_DIS | SGMII_SPEED_DUPLEX_AN;

Does SGMII_SPEED_DUPLEX_AN need to be cleared in
mtk_pcs_setup_mode_force(), so mtk_pcs_link_up() can force the
duplex setting for base-X protocols?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
