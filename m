Return-Path: <netdev+bounces-7735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4920721545
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 09:11:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A33C1C20ADA
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 07:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C5E623CE;
	Sun,  4 Jun 2023 07:11:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F212215C1
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:11:28 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02430CE;
	Sun,  4 Jun 2023 00:11:27 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-969f90d71d4so529912566b.3;
        Sun, 04 Jun 2023 00:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685862685; x=1688454685;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CdY1xECaQ7uIIAFwsETpqr7THC0KWut2Dk3l5L2AH78=;
        b=Ed26xd3Qeizh7Tv78x+uPhSHbPDhA6ItJzPBeTGQNjiSh5O69mBjKVOrDusBVNP22Q
         U1Iiz+D5RMi8j5FcDrze8t7SrvoHINYUf1O5F5xFgPFZPvWiNNSMdKz7V8TryORmUsAs
         zmyBq5mvSU5ljoL2/M3jLRjVMQ16EsM2md3LDxwhX2JO7X8B/7EHsHXh7/AV6aLhVP0n
         HJJrbVI873+Efhlbk5YhaOtfGo4HrUjNho4PVhbh87Mo0YW8RhPFRf4Mg3ryV4sF57TX
         Efkp1TgvM6NQXswuUYKV8BbCBSG/ex1X4GGWK9o3Afh+Anj8UT/g2u7ixRWOInWCCn2J
         QfdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685862685; x=1688454685;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CdY1xECaQ7uIIAFwsETpqr7THC0KWut2Dk3l5L2AH78=;
        b=SG3MMoN934qi7makl6iwvj37yxtda84SzWk8A2gDjPa0d5sLeE4iXDLu0u2Bhf7CPk
         RIjoUjY9PkjSbhUrsea4i05lzpSVkJ4J6sNsr6FDYcNNCv5bjjDGLJOdUPU8x2Yyq9WC
         ma3rrShQ7NzjPfd8sjNj0jg2EQXgMO2cL0eh0Qdu1AzsOSjBG436OwK9z/87+uf7e6e+
         UxpUbELx2CbBGlzkP6ZChxfl+cU0QrcSNV7sVhXp12seQ93dAYlS65esN3BydqXHA9ug
         irO1VcgTDFdy1K3dowMdr/Uf9aaJfWXRz0zAD21IBgLa6l4CleyYG68D17YxI7/iPwC2
         qpXQ==
X-Gm-Message-State: AC+VfDyqLnj7Lx1J57aC7eMJ3XdKC56sLkNmlv5jacd2doKuVM7BCA1/
	Wje5EZRMu5qpvmV22HffXIU=
X-Google-Smtp-Source: ACHHUZ5ODTRVbt47h4Jx3gjzear0IhLOxhnHwhEcfOFybG8dg9n3S5Uv6MY/guUO+f8WecPpdVAX7g==
X-Received: by 2002:a17:907:6d86:b0:96a:4f89:3916 with SMTP id sb6-20020a1709076d8600b0096a4f893916mr3186781ejc.58.1685862685065;
        Sun, 04 Jun 2023 00:11:25 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id gq14-20020a170906e24e00b00969f44bbef3sm2797052ejb.11.2023.06.04.00.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jun 2023 00:11:24 -0700 (PDT)
Date: Sun, 4 Jun 2023 10:11:22 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 05/30] net: dsa: mt7530: read XTAL value from
 correct register
Message-ID: <20230604071122.kb3xenjbptm6jebh@skbuf>
References: <20230524165701.pbrcs4e74juzb4r3@skbuf>
 <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
 <20230525133140.xewm6g5rl7sm57d2@skbuf>
 <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-6-arinc.unal@arinc9.com>
 <20230524165701.pbrcs4e74juzb4r3@skbuf>
 <7c915d5b-56c9-430d-05ac-544f76966eb1@arinc9.com>
 <20230525133140.xewm6g5rl7sm57d2@skbuf>
 <f9e29db7-7b95-290c-b44c-97cf95476141@arinc9.com>
 <f9e29db7-7b95-290c-b44c-97cf95476141@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f9e29db7-7b95-290c-b44c-97cf95476141@arinc9.com>
 <f9e29db7-7b95-290c-b44c-97cf95476141@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 04, 2023 at 09:34:38AM +0300, Arınç ÜNAL wrote:
> > I disagree as a matter of principle with the reasoning. The fact that
> > XTAL constants are defined under HWTRAP is not a reason to change the
> > code to read the XTAL values from the HWTRAP register. The fact that
> > XTAL_FSEL is read-only in MHWTRAP is indeed a reason why you *could*
> > read it from HWTRAP, but also not one why you *should* make a change.
> 
> Makes sense. I have refactored the hardware trap constants definitions
> by looking at the documents for MT7530 and MT7531. The registers are the
> same on both switches so I combine the bits under MT753X_(M)HWTRAP.
> 
> I put the r/w bits on MHWTRAP to MWHTRAP, the read-only bits on HWTRAP
> and MHWTRAP to HWTRAP. Mind that the MT7531_CHG_STRAP bit exists only on
> the MHWTRAP register.
> 
> To follow this, I read XTAL for MT7530 from HWTRAP instead of MHWTRAP
> since the XTAL bits are read-only. Would this change make sense as a
> matter of refactoring?

Possibly. The maintainers of mt7530 have the definitive word on that.
Behavior changes (reading XTAL from HWTRAP instead of MHWTRAP) should
still have their separate change which isn't noisy, separate from the
renaming of constants.

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 5b77799f41cc..444fa97db7c0 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -420,9 +420,9 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
>  	struct mt7530_priv *priv = ds->priv;
>  	u32 ncpo1, ssc_delta, i, xtal;
> -	mt7530_clear(priv, MT7530_MHWTRAP, MHWTRAP_P6_DIS);
> +	mt7530_clear(priv, MT753X_MHWTRAP, MT7530_P6_DIS);
> -	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
> +	xtal = mt7530_read(priv, MT753X_HWTRAP) & MT7530_XTAL_MASK;
>  	if (interface == PHY_INTERFACE_MODE_RGMII) {
>  		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
> @@ -431,21 +431,21 @@ mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
>  		mt7530_rmw(priv, MT7530_P6ECR, P6_INTF_MODE_MASK,
>  			   P6_INTF_MODE(1));
> -		if (xtal == HWTRAP_XTAL_25MHZ)
> +		if (xtal == MT7530_XTAL_25MHZ)
>  			ssc_delta = 0x57;
>  		else
>  			ssc_delta = 0x87;
>  		if (priv->id == ID_MT7621) {
>  			/* PLL frequency: 125MHz: 1.0GBit */
> -			if (xtal == HWTRAP_XTAL_40MHZ)
> +			if (xtal == MT7530_XTAL_40MHZ)
>  				ncpo1 = 0x0640;
> -			if (xtal == HWTRAP_XTAL_25MHZ)
> +			if (xtal == MT7530_XTAL_25MHZ)
>  				ncpo1 = 0x0a00;
>  		} else { /* PLL frequency: 250MHz: 2.0Gbit */
> -			if (xtal == HWTRAP_XTAL_40MHZ)
> +			if (xtal == MT7530_XTAL_40MHZ)
>  				ncpo1 = 0x0c80;
> -			if (xtal == HWTRAP_XTAL_25MHZ)
> +			if (xtal == MT7530_XTAL_25MHZ)
>  				ncpo1 = 0x1400;
>  		}
> @@ -487,12 +487,12 @@ mt7531_pll_setup(struct mt7530_priv *priv)
>  	val = mt7530_read(priv, MT7531_CREV);
>  	top_sig = mt7530_read(priv, MT7531_TOP_SIG_SR);
> -	hwstrap = mt7530_read(priv, MT7531_HWTRAP);
> +	hwstrap = mt7530_read(priv, MT753X_HWTRAP);
>  	if ((val & CHIP_REV_M) > 0)
> -		xtal = (top_sig & PAD_MCM_SMI_EN) ? HWTRAP_XTAL_FSEL_40MHZ :
> -						    HWTRAP_XTAL_FSEL_25MHZ;
> +		xtal = (top_sig & PAD_MCM_SMI_EN) ? MT7531_XTAL_FSEL_40MHZ :
> +						    MT7531_XTAL_FSEL_25MHZ;
>  	else
> -		xtal = hwstrap & HWTRAP_XTAL_FSEL_MASK;
> +		xtal = hwstrap & MT7531_XTAL25;

xtal = hwstrap & BIT(7). The "xtal" variable will either hold the value
of 0 or BIT(7), do you agree?

>  	/* Step 1 : Disable MT7531 COREPLL */
>  	val = mt7530_read(priv, MT7531_PLLGP_EN);
> @@ -521,13 +521,13 @@ mt7531_pll_setup(struct mt7530_priv *priv)
>  	usleep_range(25, 35);
>  	switch (xtal) {
> -	case HWTRAP_XTAL_FSEL_25MHZ:
> +	case MT7531_XTAL_FSEL_25MHZ:

reworded:
	case 1:

when will "xtal" be equal to 1?

>  		val = mt7530_read(priv, MT7531_PLLGP_CR0);
>  		val &= ~RG_COREPLL_SDM_PCW_M;
>  		val |= 0x140000 << RG_COREPLL_SDM_PCW_S;
>  		mt7530_write(priv, MT7531_PLLGP_CR0, val);
>  		break;
> -	case HWTRAP_XTAL_FSEL_40MHZ:
> +	case MT7531_XTAL_FSEL_40MHZ:
>  		val = mt7530_read(priv, MT7531_PLLGP_CR0);
>  		val &= ~RG_COREPLL_SDM_PCW_M;
>  		val |= 0x190000 << RG_COREPLL_SDM_PCW_S;

