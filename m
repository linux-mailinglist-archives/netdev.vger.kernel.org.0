Return-Path: <netdev+bounces-9591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05767729EFE
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A8BE281968
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:46:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7563319BC0;
	Fri,  9 Jun 2023 15:46:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6968719539
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:46:38 +0000 (UTC)
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A33584
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:46:36 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 38308e7fff4ca-2b1fe3a1a73so21389091fa.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686325595; x=1688917595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CsymM+sZ3qbYclB4M5H6X6tKIPBYp8xhsDNrjslRkGA=;
        b=U0R15ttGv/TbjJ/B0vIXcPj2HSXCDddhALpM01VZFZQTSUX/D+s7Ehb/WdfHwXH6Lx
         VVA5/zt+L6jd1UrKxu/koUhE7WKHHaMNKpruaUwQk7ELsOvZTCS5cJZmD2JEl1TMomI4
         wlWYjgUVgX0TMvBj49rT8ipW6imBtR6LNkDvKEQQ5cTdk3hH4yYDETtRAb3pLLo74baL
         QEGwXfrVHhuyCjVWf5WjSwPeDvHlFZcKTx6PoH55pi4fwThFNo/PoAd0UEse6X4/pc30
         5jm0ZR8uVHdIaKH0Bm/Xav7bIzsZPjrLKkm7v5OywhVgXxKdjSl6+vprnrBK3n4mrbDS
         vGHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686325595; x=1688917595;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsymM+sZ3qbYclB4M5H6X6tKIPBYp8xhsDNrjslRkGA=;
        b=NWocPkL8xN80sKPhbE6RCnLqliNHBpYCI5Pl6jKUdw9ckQhapNpCSHXMVDiAazv6v6
         CPmr9qmeyxaHWfhle8qqoP+jWOsjtxu2LK2E8o4J1MXW++EOAizCwEk6sP4wvUsu4Ufm
         TBD1Sd4e5Ht7dreGAy+FoAR9XVnyDomJSb15ZwnIKFHuh3X4mWA1EMOPCiZpNLwBFLHf
         S6QPub6af+mlMampsYgkgMcsrkUlCZU4BulCFzSI9jCoAmETJavzOnmNkS1lkmae/MyL
         65GY7Xdpv6tdJmu3jFSJ/04nsekzUa5ckbNUMu/kP0tLqaCcQOXIlsAIZB5pmaYfrUZM
         SWEQ==
X-Gm-Message-State: AC+VfDzTtkerf0wTPD/WNZ66OLBk+R9zzPnXgh4iwbQ4VESFu2dUnF5c
	UypjBQOwzHPj2YWcExs5TK7ybg==
X-Google-Smtp-Source: ACHHUZ6H7GAfgliIQ7vuLHDItb52P6CVINhTdC1Q32aXlHSelmdJ38e92Lqf8weZj9+3H/UIebQ3Ig==
X-Received: by 2002:a2e:a402:0:b0:2b1:b301:e650 with SMTP id p2-20020a2ea402000000b002b1b301e650mr1433992ljn.1.1686325594809;
        Fri, 09 Jun 2023 08:46:34 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id l14-20020aa7c30e000000b00514b0f6a75esm1869455edq.97.2023.06.09.08.46.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 08:46:34 -0700 (PDT)
Message-ID: <e2bb439c-9b72-991b-00f6-0b5e7602efd9@linaro.org>
Date: Fri, 9 Jun 2023 17:46:31 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v2 2/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Content-Language: en-US
To: Raymond Hackley <raymondhackley@protonmail.com>,
 linux-kernel@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
 Michael Walle <michael@walle.cc>,
 =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
 Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20230609154033.3511-1-raymondhackley@protonmail.com>
 <20230609154200.3620-1-raymondhackley@protonmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230609154200.3620-1-raymondhackley@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/06/2023 17:42, Raymond Hackley wrote:
> PN547/553, QN310/330 chips on some devices require a pad supply voltage
> (PVDD). Otherwise, the NFC won't power up.
> 
> Implement support for pad supply voltage pvdd-supply that is enabled by
> the nxp-nci driver so that the regulator gets enabled when needed.
> 
> Signed-off-by: Raymond Hackley <raymondhackley@protonmail.com>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 42 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index d4c299be7949..1b8877757cee 100644
> --- a/drivers/nfc/nxp-nci/i2c.c
> +++ b/drivers/nfc/nxp-nci/i2c.c
> @@ -35,6 +35,7 @@ struct nxp_nci_i2c_phy {
>  
>  	struct gpio_desc *gpiod_en;
>  	struct gpio_desc *gpiod_fw;
> +	struct regulator *pvdd;
>  
>  	int hard_fault; /*
>  			 * < 0 if hardware error occurred (e.g. i2c err)
> @@ -263,6 +264,22 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
>  	{ }
>  };
>  
> +static void nxp_nci_i2c_poweroff(void *data)
> +{
> +	struct nxp_nci_i2c_phy *phy = data;
> +	struct device *dev = &phy->i2c_dev->dev;
> +	struct regulator *pvdd = phy->pvdd;
> +	int r;
> +
> +	if (!IS_ERR(pvdd) && regulator_is_enabled(pvdd)) {

Why do you need these checks? This should be called in correct context,
so when regulator is valid and enabled. If you have such checks it
suggests that code is buggy and this is being called in wrong contexts.

> +		r = regulator_disable(pvdd);
> +		if (r < 0)
> +			dev_warn(dev,
> +				 "Failed to disable regulator pvdd: %d\n",
> +				 r);

Weird wrapping. Why r is wrapped?

> +	}
> +}
> +
>  static int nxp_nci_i2c_probe(struct i2c_client *client)
>  {
>  	struct device *dev = &client->dev;
> @@ -298,6 +315,29 @@ static int nxp_nci_i2c_probe(struct i2c_client *client)
>  		return PTR_ERR(phy->gpiod_fw);
>  	}
>  
> +	phy->pvdd = devm_regulator_get_optional(dev, "pvdd");
> +	if (IS_ERR(phy->pvdd)) {
> +		r = PTR_ERR(phy->pvdd);
> +		if (r != -ENODEV)
> +			return dev_err_probe(dev, r,
> +					     "Failed to get regulator pvdd\n");
> +	} else {
> +		r = regulator_enable(phy->pvdd);
> +		if (r < 0) {
> +			nfc_err(dev,
> +				"Failed to enable regulator pvdd: %d\n",
> +				r);

Weird wrapping. Why r is wrapped?

> +			return r;
> +		}
> +	}
> +
> +	r = devm_add_action_or_reset(dev, nxp_nci_i2c_poweroff, phy);
> +	if (r < 0) {
> +		nfc_err(dev, "Failed to install poweroff handler: %d\n",
> +			r);

Weird wrapping. Why r is wrapped?

Just move it to the success path of enabling regulator.


> +		return r;
> +	}
> +
>  	r = nxp_nci_probe(phy, &client->dev, &i2c_phy_ops,
>  			  NXP_NCI_I2C_MAX_PAYLOAD, &phy->ndev);
>  	if (r < 0)
> @@ -319,6 +359,8 @@ static void nxp_nci_i2c_remove(struct i2c_client *client)
>  
>  	nxp_nci_remove(phy->ndev);
>  	free_irq(client->irq, phy);
> +
> +	nxp_nci_i2c_poweroff(phy);

Why? This code is buggy...



Best regards,
Krzysztof


