Return-Path: <netdev+bounces-6899-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 446D97189DC
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81DB728151D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13A719E4E;
	Wed, 31 May 2023 19:09:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA12578
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:09:26 +0000 (UTC)
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20DB125;
	Wed, 31 May 2023 12:08:56 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-5147e441c33so240614a12.0;
        Wed, 31 May 2023 12:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685560135; x=1688152135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zyxR30g2bKMnEjOEuROEiWjiUjocH3rGbPWdVsGv92s=;
        b=Ye2IWrnhoxGCqV8CGZvUTZnGQFK30FN7eFPb3mkua59MXfEURFTToTqMIc9p4HZwMP
         wFzjlVy9+QNsDn11n5oBQPUWKVZnTri5EvZYXX1lbvupKK/+7zMxPcBPoMJN839ELKW9
         a1pgRCPWS7GNpT+c1HzgV+ns6eEcXkOses3w16nXfaSiXwV1vQJr86mZsPBcDWh3byPy
         lPMencn3DjE+it5T1fGr1w6nHJ67qk4Bc8giOLvY+PenGdUi6wMJS29BtBXJdbiVu/+6
         gZaLhB2bkTvf02Mdre9GTMnAcN8mLKnnjMiRp55fte9LFOqZf4BXk3L4hm5yihFbKZDz
         XFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685560135; x=1688152135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyxR30g2bKMnEjOEuROEiWjiUjocH3rGbPWdVsGv92s=;
        b=IWpyQphcW6Z5uhCXJTtrPBNMDEutfQlECtR3IN/QE/b4R3cT9BPhuYOyEirPRM8sqr
         prMKBpA5fruEx8XnGNuqIkkrLU2o8Z61/EGfjYF9l45ShbuJYN6N7H4DxfnVqRP3DNZz
         eIuSacu7WvxvdPU5Ht//0wBRExNS/RNbFrb8yGE+1mQqJU4OAhHtyH34WE/c/9P/hV8+
         DHVfP7nc+PcClFZ6xqS/dveeIT8qEa+L2U8KeUZgy8fFvAgB37vpP1fLazQpavNjOehV
         TY6UD6GzYPw+M761+S01IyIVDcETHD3J7+4C9plBWsuCEzJzcCY1kXHS0MRyYA4WfczR
         GklQ==
X-Gm-Message-State: AC+VfDzCd127y1refm3+AEVDP9wKa3tFGDwK63Owm7rgfkazVeZGWiC3
	iFJj+OIbKi5/RveJ/wd/G6c=
X-Google-Smtp-Source: ACHHUZ7fgGkI5VqrGVbz2CLufCaK0JikIDl9Hwd+z7uJFtvba3mR751C8zmx9S8daTsL5HhTRk9D+w==
X-Received: by 2002:a05:6402:5107:b0:514:9311:e83a with SMTP id m7-20020a056402510700b005149311e83amr7142584edd.8.1685560134877;
        Wed, 31 May 2023 12:08:54 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c18f:4600:8999:532:b66e:c213? (dynamic-2a01-0c23-c18f-4600-8999-0532-b66e-c213.c23.pool.telefonica.de. [2a01:c23:c18f:4600:8999:532:b66e:c213])
        by smtp.googlemail.com with ESMTPSA id d25-20020a50fb19000000b0050cc4461fc5sm6101880edq.92.2023.05.31.12.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 12:08:54 -0700 (PDT)
Message-ID: <4a6c413c-8791-fd00-a73e-7a12413693e3@gmail.com>
Date: Wed, 31 May 2023 21:08:53 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 2/2] net: phy: realtek: Add optional external PHY clock
To: Detlev Casanova <detlev.casanova@collabora.com>,
 linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org
References: <20230531150340.522994-1-detlev.casanova@collabora.com>
 <20230531150340.522994-2-detlev.casanova@collabora.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230531150340.522994-2-detlev.casanova@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 31.05.2023 17:03, Detlev Casanova wrote:
> In some cases, the PHY can use an external clock source instead of a
> crystal.
> 
> Add an optional clock in the phy node to make sure that the clock source
> is enabled, if specified, before probing.
> 
> Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
> ---
>  drivers/net/phy/realtek.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 3d99fd6664d7..70c75dbbf799 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -12,6 +12,7 @@
>  #include <linux/phy.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/clk.h>
>  
>  #define RTL821x_PHYSR				0x11
>  #define RTL821x_PHYSR_DUPLEX			BIT(13)
> @@ -80,6 +81,7 @@ struct rtl821x_priv {
>  	u16 phycr1;
>  	u16 phycr2;
>  	bool has_phycr2;
> +	struct clk *clk;
>  };
>  
>  static int rtl821x_read_page(struct phy_device *phydev)
> @@ -103,6 +105,11 @@ static int rtl821x_probe(struct phy_device *phydev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	priv->clk = devm_clk_get_optional_enabled(dev, "xtal");

Why add priv->clk if it isn't used outside probe()?

How about suspend/resume? Would it make sense to stop the clock
whilst PHY is suspended?

> +	if (IS_ERR(priv->clk))
> +		return dev_err_probe(dev, PTR_ERR(priv->clk),
> +				     "failed to get phy xtal clock\n");
> +
>  	ret = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
>  	if (ret < 0)
>  		return ret;


