Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272C25BCAC1
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 13:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiISLaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 07:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiISL3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 07:29:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45E515806;
        Mon, 19 Sep 2022 04:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+uLY05c49ecqS91zmmiEb12QI7sOr+RmFbptlGn3Ypk=; b=SgKWhnBdZUGfUYaD7jCyqSh3sQ
        Vpr2XdOB5RPtruhHeZGTRUWQy/IsQI8LMNoSGlQBXH6h6Nrbxur2rTe8F/ufqVAZvE1eZEXhAJiUq
        RMmWDjHBXwk0X1bC8KfUv5njGb03/l3r/ZXpRw822B3fP2R2GaSTVICBunqjRgA+w1WbYhyWXl2vW
        h6QrbkibWGsH9bFMoV/044qDwnWfD4LYW8SLFAEDidHd7r+MNCw2ij6P/IPSAv+XHL9E/8Wy+XuAo
        XrIfdpyZMCY7ge8+aLWwKfyjJyNa3cRkcrLdKcTbAOfdYxJ6sa8P4hCWXQW3JikQ90klKN7vmLqyW
        05msk2Tw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34402)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oaEy0-0000oO-TO; Mon, 19 Sep 2022 12:29:36 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oaExy-0006Lv-GH; Mon, 19 Sep 2022 12:29:34 +0100
Date:   Mon, 19 Sep 2022 12:29:34 +0100
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
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/5] net: mediatek: sgmii:
 mtk_pcs_setup_mode_an: don't rely on register defaults
Message-ID: <YyhSnqacAE4ajRdy@shell.armlinux.org.uk>
References: <20220919083713.730512-1-lynxis@fe80.eu>
 <20220919083713.730512-4-lynxis@fe80.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919083713.730512-4-lynxis@fe80.eu>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:37:10AM +0200, Alexander Couzens wrote:
> Ensure autonegotiation is enabled.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index 18de85709e87..6f4c1ca5a36f 100644
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
>  	regmap_write(mpcs->regmap, SGMSYS_SGMII_MODE, val);
>  
>  	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &val);
> -	val |= SGMII_AN_RESTART;
> +	val |= SGMII_AN_RESTART | SGMII_AN_ENABLE;

I'm not sure if I've asked this before, but why does SGMII_AN_RESTART
need to be set here? It could do with a comment in the code.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
