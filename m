Return-Path: <netdev+bounces-5696-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 455B2712772
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC301C20FE0
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 13:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F1AD19E7A;
	Fri, 26 May 2023 13:25:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CEF18B1D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 13:25:15 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C63012C;
	Fri, 26 May 2023 06:25:13 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so12413a12.3;
        Fri, 26 May 2023 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685107512; x=1687699512;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=REExVQcWcE2QjJuxENKUcGpJCKWSMyccL07DCITDofY=;
        b=qAyvFDmhsukPnn4WvAmi10pKd4n2FqmPW1UufHxkYNGGWR1dx/1llwEa2WCcXAF303
         iZSKlaO95+NI673tZOCG378LltKAUkLJ43xWBX7PpV6ldciulJYU3G9VtFCQuIY3DzyQ
         DIYkf63t3HV5ykQ5j3MzC+JC891jSE78LK9v+3J5+RUpfMUPue4tp0FVpG3njoUjYxGw
         pWj12qVyTRMGMzVjmi0c9p6E0VbZFqWuW+aaLw8IfmRFgKyEt7+D8H9TJvhinsq6O0og
         rYOf7VV/1stJPN98PqhwrStnYYw0Nha+46hA6GksIdoqlqVNlrQ8/4IDICYuTZV+dNjl
         OiUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685107512; x=1687699512;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=REExVQcWcE2QjJuxENKUcGpJCKWSMyccL07DCITDofY=;
        b=JzPrWh7Zw3hOkqOYXw3bSug2NreEA8ekjIOvWUD7byAr4t2er2xCEHHkiP94Obzuew
         CwRdhuO6C97JejrLC4gasZTz+YfIveN+aHkCZoH26cd4Ip7BVKG0okQeeS4gxUDxs/fG
         mPgC1AJg6oY5sZy6ZZNQGwc09r0iCDUMN2ux3AjiIefZRMG/EjuL5CuYAFXaoc3SLmUI
         gPEHeybiTDlivYRaPQckKVe2+pLoyb3RYDGBXO/wITJVqOL0n3snEpgzFtsJuGfrfASm
         u181Rh2idlVwzGRtkz6M4hg/ZNtaPH6RbLFz6d94ZNsz1yrEsIabABiX67QNMH59o+1b
         X0kg==
X-Gm-Message-State: AC+VfDyhtV6mrDpDcOZUby7XX42vfqHfidKjADO0TxAe4zuKx4AwtmAO
	Nz6kUXeg1hxUpHjy+Rse73E=
X-Google-Smtp-Source: ACHHUZ7q1MafXAsr6kPnoxH9sRKukcbZuU+ag0QnY9abimtOnkEmvW+csQfASzKbX2SjUCLFmdg0kQ==
X-Received: by 2002:a17:907:9345:b0:973:9857:b98a with SMTP id bv5-20020a170907934500b009739857b98amr2330770ejc.55.1685107511683;
        Fri, 26 May 2023 06:25:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z17-20020a170906715100b0094e597f0e4dsm2123613ejj.121.2023.05.26.06.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 06:25:11 -0700 (PDT)
Date: Fri, 26 May 2023 16:25:08 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: arinc9.unal@gmail.com
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
	=?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com, mithat.guner@xeront.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net-next 19/30] net: dsa: mt7530: set interrupt register
 only for MT7530
Message-ID: <20230526132508.fxgljrpozuuzelal@skbuf>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
 <20230522121532.86610-20-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230522121532.86610-20-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 03:15:21PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Setting this register related to interrupts is only needed for the MT7530
> switch. Make an exclusive check to ensure this.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Acked-by: Daniel Golle <daniel@makrotopia.org>
> Tested-by: Daniel Golle <daniel@makrotopia.org>
> ---

Why does it matter? What prompted you to make this change? I guess it's
not needed for MT7988? Or the register is not present? Or?...

>  drivers/net/dsa/mt7530.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 99f5da8b27be..0c261ef87bee 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2029,7 +2029,7 @@ mt7530_setup_irq(struct mt7530_priv *priv)
>  	}
>  
>  	/* This register must be set for MT7530 to properly fire interrupts */
> -	if (priv->id != ID_MT7531)
> +	if (priv->id == ID_MT7530 || priv->id == ID_MT7621)
>  		mt7530_set(priv, MT7530_TOP_SIG_CTRL, TOP_SIG_CTRL_NORMAL);
>  
>  	ret = request_threaded_irq(priv->irq, NULL, mt7530_irq_thread_fn,
> -- 
> 2.39.2
> 

