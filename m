Return-Path: <netdev+bounces-1086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A656FC230
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:59:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9DA1C20B04
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D0C3568F;
	Tue,  9 May 2023 08:59:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2961317C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:59:43 +0000 (UTC)
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C26D2D0;
	Tue,  9 May 2023 01:59:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-50bc394919cso8449286a12.2;
        Tue, 09 May 2023 01:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683622780; x=1686214780;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GDtBIUCKzCwJt/NTlGsGyPq+Rx4a8Y3iaj9pBTWWw7o=;
        b=a8xa4SQp4odNm62rbpLy34SczopmBPGOxUG1gtj25aZMbW99jXOLvJJ+BvqntJMDBZ
         VLBGwQOX2nZesPJF7QTXMTlmZaOf2FhzSXvHai3pqJ2LuQ3hnd18x+Awh6WcZD6l5+Vg
         DCVBnn9HbWheRp7vCtcNajaQnPoGKpz9ZSKpYmi6W/ioEeU3BZznhlUnvBZjkr594Zqb
         Shxf4xLdBhWueVQ5INqXxlVOfLctwFmrJrFYhCTPSX1fLi1NNmpAr9Sg9rtpFxmvYNry
         hMHnVGfdgLUnQUkmpPpJgu3xg/+HxcWSmlFsfkmFgSiOwMv0xfeqPSt1aWTN3SAzZw2Z
         iFSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683622780; x=1686214780;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GDtBIUCKzCwJt/NTlGsGyPq+Rx4a8Y3iaj9pBTWWw7o=;
        b=VDRJCvFudfdyCSGdiZjQdEWZ9+r/rkaVBqWVofXB3AJBiirbdORzbQpDsAxN0tWreM
         bdD7pzZIIppAwmedc+Jr8JjteJj0Xz/0WH0JD/NXo7CUYNhHRzPHAyufb3kz57uXO0Q3
         vgPQVQgVmmIJT2G/1t+nKAP3ek5oCPraH2eg+S1ZjRlPmhs+P9ijFqrpYrCrMFc6FQwu
         cp9AjA1GB+GndCwSn4U5Cy4+jbCWyEeb+9VnX01el7/w7uPsksAbR9AqHBF2OytHNalT
         haAfZFk1EmVK8Og159e0RfvdT1v3LesJCEd1JO8jL56tnh6Olm5qDG3FfJaEpIbuXqXv
         umpQ==
X-Gm-Message-State: AC+VfDwIR7jzhBHToCNFCwiIp0bp27oVHP27KiVIihzhBqTs0bZPTw/A
	UhmdKKm4CRJfZlzzE1jD5Y4=
X-Google-Smtp-Source: ACHHUZ6XzeflNUEIzuP+TjFi6Xtht2J4Sf3OV4/BX2yxhucEqVcNC+RxwbgDRdPUyamWtBjTfmPEdA==
X-Received: by 2002:a17:907:6d20:b0:969:e304:441d with SMTP id sa32-20020a1709076d2000b00969e304441dmr2041828ejc.4.1683622779535;
        Tue, 09 May 2023 01:59:39 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7655:7200:7d37:a922:8b7f:288b? (dynamic-2a01-0c22-7655-7200-7d37-a922-8b7f-288b.c22.pool.telefonica.de. [2a01:c22:7655:7200:7d37:a922:8b7f:288b])
        by smtp.googlemail.com with ESMTPSA id b16-20020a170906195000b0094e96e46cc0sm1055184eje.69.2023.05.09.01.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 01:59:39 -0700 (PDT)
Message-ID: <7a53f0d3-3e9a-4024-6b19-72ad9c19ab97@gmail.com>
Date: Tue, 9 May 2023 10:59:38 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2] net: phy: dp83867: add w/a for packet errors seen
 with short cables
Content-Language: en-US
To: Siddharth Vadapalli <s-vadapalli@ti.com>, andrew@lunn.ch,
 linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230509052124.611875-1-s-vadapalli@ti.com>
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230509052124.611875-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09.05.2023 07:21, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Introduce the W/A for packet errors seen with short cables (<1m) between
> two DP83867 PHYs.
> 
> The W/A recommended by DM requires FFE Equalizer Configuration tuning by
> writing value 0x0E81 to DSP_FFE_CFG register (0x012C), surrounded by hard
> and soft resets as follows:
> 
> write_reg(0x001F, 0x8000); //hard reset
> write_reg(DSP_FFE_CFG, 0x0E81);
> write_reg(0x001F, 0x4000); //soft reset
> 
> Since  DP83867 PHY DM says "Changing this register to 0x0E81, will not
> affect Long Cable performance.", enable the W/A by default.
> 
> Fixes: 2a10154abcb7 ("net: phy: dp83867: Add TI dp83867 phy")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
> 
> V1 patch at:
> https://lore.kernel.org/r/20230508070019.356548-1-s-vadapalli@ti.com
> 
> Changes since v1 patch:
> - Wrap the line invoking phy_write_mmd(), limiting it to 80 characters.
> - Replace 0X0E81 with 0x0e81 in the call to phy_write_mmd().
> - Replace 0X012C with 0x012c in the new define for DP83867_DSP_FFE_CFG.
> 
> RFC patch at:
> https://lore.kernel.org/r/20230425054429.3956535-2-s-vadapalli@ti.com/
> 
> Changes since RFC patch:
> - Change patch subject to PATCH net.
> - Add Fixes tag.
> - Check return value of phy_write_mmd().
> 
>  drivers/net/phy/dp83867.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index d75f526a20a4..bbdcc595715d 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -44,6 +44,7 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_STRAP_STS2	0x006f
>  #define DP83867_RGMIIDCTL	0x0086
> +#define DP83867_DSP_FFE_CFG	0x012c
>  #define DP83867_RXFCFG		0x0134
>  #define DP83867_RXFPMD1	0x0136
>  #define DP83867_RXFPMD2	0x0137
> @@ -941,8 +942,23 @@ static int dp83867_phy_reset(struct phy_device *phydev)
>  
>  	usleep_range(10, 20);
>  
> -	return phy_modify(phydev, MII_DP83867_PHYCTRL,
> +	err = phy_modify(phydev, MII_DP83867_PHYCTRL,
>  			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
> +	if (err < 0)
> +		return err;
> +

Would be good to add a comment here explaining what this magic write does.

> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG,
> +			    0x0e81);
> +	if (err < 0)
> +		return err;
> +
> +	err = phy_write(phydev, DP83867_CTRL, DP83867_SW_RESTART);
> +	if (err < 0)
> +		return err;
> +
> +	usleep_range(10, 20);
> +
> +	return 0;
>  }
>  
>  static void dp83867_link_change_notify(struct phy_device *phydev)


