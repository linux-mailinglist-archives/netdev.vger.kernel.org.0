Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2D675471
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjATM3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjATM3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:29:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C7B474E3
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BAnj54q3G2IuYIg+d7K053Jr+b6tj8/22zh4/txePyE=; b=VyRuNa3p262V8pnC4G1JDSQ6nI
        rReLQ/bE6sv2wXNamtDA5CWhhA4wusH+/fwZ6hVIuLO530z19I5Be0ClzUsfuNXju58SK5b+iuCWX
        OKF1tyaEKjnnZTymiRlvkebTmwED2TXnK2qpxipPkJUijOZQwf4aEmZZ5fHGwB2paVAgYWx9h3Dal
        9y4RZ6ABVXPg6/8Rx3ly8tCiXxeZb1ghoAERJB7gCL98NfY1n766WNFFvaIYdS8GqPFhBCmZqbOOL
        4XLZ9E9772KWuFhStJaiLuPl2zehvkoTkM98WP5kZFQz1mvJuubdSiMvEjjSnOfvRCGlZtgtNDIXB
        TKR/jjvQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:36228)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pIqWO-0006fy-T7; Fri, 20 Jan 2023 12:29:28 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pIqWN-0001Re-CS; Fri, 20 Jan 2023 12:29:27 +0000
Date:   Fri, 20 Jan 2023 12:29:27 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>
Subject: Re: [PATCH v2 net 3/3] mtk_sgmii: enable PCS polling to allow SFP
 work
Message-ID: <Y8qJJ7XWd9tAO+op@shell.armlinux.org.uk>
References: <20230120104947.4048820-1-bjorn@mork.no>
 <20230120104947.4048820-4-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230120104947.4048820-4-bjorn@mork.no>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 11:49:47AM +0100, Bjørn Mork wrote:
> From: Alexander Couzens <lynxis@fe80.eu>
> 
> Currently there is no IRQ handling (even the SGMII supports it).
> Enable polling to support SFP ports.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>
> Signed-off-bu: Bjørn Mork <bjorn@mork.no>

Typo in this attributation.

> ---
>  drivers/net/ethernet/mediatek/mtk_sgmii.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> index c4261069b521..24ea541bf7d7 100644
> --- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
> +++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
> @@ -187,6 +187,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss, struct device_node *r, u32 ana_rgc3)
>  			return PTR_ERR(ss->pcs[i].regmap);
>  
>  		ss->pcs[i].pcs.ops = &mtk_pcs_ops;
> +		ss->pcs[i].pcs.poll = 1;

As "poll" is a bool, we prefer true/false rather than 1/0. Using
1/0 will probably cause someone to submit a patch changing this, so
it's probably best to fix this up at submission time.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
