Return-Path: <netdev+bounces-8807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC69D725DBD
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 973382812B9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BF433C86;
	Wed,  7 Jun 2023 11:55:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696CE28C3D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:55:59 +0000 (UTC)
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3271BCB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 04:55:48 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686138947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LgbVx+VONYx61lTwlFBrmfRny0xuECpEY6dHfbhYDRk=;
	b=jO/wa+wX5zsNP6oG9dvPnHTUYuu2XWezQhuuessj4xSbijjDKBYWsY8b0DVz7k3sWOGB+P
	NBoWbbubEzv3bPwrbu5nspZqkc7XXO3d1p7lHV/99jYpaKVw4iYnlvc8P5VuI2mzq7NsEn
	3v6gN8PYK9NAKexuQCylhGNfUDb+7P5Z5/hDuVukrHpSUZXzur1mQkbmIx1Ru+YC9tVcko
	lwdFf+AwYdoPGWd0TYyvjf6bsCLrqJq4KwQvPQr8alyDzT9XyA80BSmXe2V4eKG6aTXGIl
	w8SwFeZd13rnoNkEDtYi5xESCLs7JSY+NSSYrc4cmwaPn/sskCKaeAEM3qlIgA==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id B6CA6C0002;
	Wed,  7 Jun 2023 11:55:44 +0000 (UTC)
Date: Wed, 7 Jun 2023 15:48:21 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: Feiyang Chen <chenfeiyang@loongson.cn>
Cc: peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
 joabreu@synopsys.com, netdev@vger.kernel.org,
 loongson-kernel@lists.loongnix.cn, chris.chenfeiyang@gmail.com, Yanteng Si
 <siyanteng@loongson.cn>
Subject: Re: [PATCH] net: stmmac: Fix stmmac_mdio_unregister() build errors
Message-ID: <20230607154821.3b3e8807@pc-7.home>
In-Reply-To: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
References: <20230607093440.4131484-1-chenfeiyang@loongson.cn>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

On Wed,  7 Jun 2023 17:34:40 +0800
Feiyang Chen <chenfeiyang@loongson.cn> wrote:

> When CONFIG_PCS_LYNX is not set, lynx_pcs_destroy() will not be
> exported. Add #ifdef CONFIG_PCS_LYNX around that code to avoid
> build errors like these:
> 
> ld: drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o: in function `stmmac_mdio_unregister':
> stmmac_mdio.c:(.text+0x1440): undefined reference to `lynx_pcs_destroy'

I have sent a series aiming to fix this yesterday [1], which I'll followup today
addressing the last pieces for the fix. Sorry about this,

Maxime

> Reported-by: Yanteng Si <siyanteng@loongson.cn>
> Fixes: 5d1f3fe7d2d5 ("net: stmmac: dwmac-sogfpga: use the lynx pcs driver")
> Signed-off-by: Feiyang Chen <chenfeiyang@loongson.cn>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> index c784a6731f08..c1a23846a01c 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
> @@ -665,8 +665,10 @@ int stmmac_mdio_unregister(struct net_device *ndev)
>  	if (priv->hw->xpcs)
>  		xpcs_destroy(priv->hw->xpcs);
>  
> +#ifdef CONFIG_PCS_LYNX
>  	if (priv->hw->lynx_pcs)
>  		lynx_pcs_destroy(priv->hw->lynx_pcs);
> +#endif
>  
>  	mdiobus_unregister(priv->mii);
>  	priv->mii->priv = NULL;


