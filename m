Return-Path: <netdev+bounces-9690-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1683772A322
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6570280D14
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:32:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0239C1D2BF;
	Fri,  9 Jun 2023 19:32:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A21800E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:32:23 +0000 (UTC)
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E062139
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:32:22 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so3245446a12.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 12:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686339140; x=1688931140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e+7TJ2Bz4PP84jI71k9rtSrZBuTihEfvjYh1C5ap+bM=;
        b=dwuJQ2Nfv3uoOXXnIfCtewKQKhPdrx1lMxuhEwkh/apP2l8A5U36iSzQ1LQ9Tp9ZIy
         iuuL7Ur1Fg6eeDqDI3KzMcpa9Dlob2NiJb/XZ1Rd4ziQGLYwA5yaMYCVzmbRhG8O0jzS
         IosOLT7eRJ89zYXtJ8hC7NyQueCE4kMBsunVLvb9aUyAWnFKrzivwQ3pWOQmq52O37Pp
         0oRHuqlsG5dpYcjsqnX+fGDYPAjupfxNSVUWh0ZWHcqOTx9JC2QPW5uuIHdr2CRfeVzo
         CrtfePDBNwmmCWI6LerZWKFB0JYgDwGIOJPH78aFq+bDkQ8UMrmNO3vzDtcl43Jex/yD
         0ngA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686339140; x=1688931140;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e+7TJ2Bz4PP84jI71k9rtSrZBuTihEfvjYh1C5ap+bM=;
        b=RKxCkgqpZ6tGiDPJPWbWpvBqmD/MEUzcavOzxVn0vHFrVxx4lkoyG48S7qr7KIX/Vb
         UY6Ua2r6Sqcr9EsLh5DmmBliXM+IHrBVNB5zWl8Ua9pZAqBqDGj7Urz3hR7cDvkdnLVh
         6dB7cxCtRWOxe6x3Pq/H3LvU973LDvu63ov2ytwI27f2f3bn65zviShGv54LsMv530Xl
         pOeKggAJeb8y1iMwuh3t9djqLV2D3724DgUlOa+wZxIBEoMFthF4P0jkPHA11d54FE9H
         E0s2cBZwOX9jzFMKrx9sqApYJDfRKNJsanjYg+20EDxYjRtjO4fYoNjM8uHe0uk275Wv
         XPTg==
X-Gm-Message-State: AC+VfDzewGCzd5nVzIlkgwwoYXtO8iWlcX5jetYo0ScAIQvtauRMjO76
	h5yUigPdUhU6fHeA28dMneB3uA==
X-Google-Smtp-Source: ACHHUZ47CXjFiaJRYtVFHZQsAMutpuxSWyyvSPvy1BZQ/QZWq+q14Z5qFYjDWmabnbmTrxtzAlY2Mw==
X-Received: by 2002:aa7:d14c:0:b0:514:666b:1e04 with SMTP id r12-20020aa7d14c000000b00514666b1e04mr1775182edo.35.1686339140518;
        Fri, 09 Jun 2023 12:32:20 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id p4-20020aa7d304000000b005169ffc81absm2089208edq.51.2023.06.09.12.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 12:32:20 -0700 (PDT)
Message-ID: <4c37d4cd-cb8f-8c73-e09b-37e32cd79c30@linaro.org>
Date: Fri, 9 Jun 2023 21:32:18 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [RESEND PATCH v3 2/2] NFC: nxp-nci: Add pad supply voltage
 pvdd-supply
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
References: <20230609183639.85221-1-raymondhackley@protonmail.com>
 <20230609183639.85221-3-raymondhackley@protonmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230609183639.85221-3-raymondhackley@protonmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 09/06/2023 20:37, Raymond Hackley wrote:
> PN547/553, QN310/330 chips on some devices require a pad supply voltage
> (PVDD). Otherwise, the NFC won't power up.
> 
> Implement support for pad supply voltage pvdd-supply that is enabled by
> the nxp-nci driver so that the regulator gets enabled when needed.
> 
> Signed-off-by: Raymond Hackley <raymondhackley@protonmail.com>
> ---
>  drivers/nfc/nxp-nci/i2c.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/nfc/nxp-nci/i2c.c b/drivers/nfc/nxp-nci/i2c.c
> index d4c299be7949..6f01152d2c83 100644
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
> @@ -263,6 +264,20 @@ static const struct acpi_gpio_mapping acpi_nxp_nci_gpios[] = {
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
> +		r = regulator_disable(pvdd);
> +		if (r < 0)
> +			dev_warn(dev, "Failed to disable regulator pvdd: %d\n", r);

Why resending? This should be explained.

It's like third or fourth patchset today. You need to slow down.
Unresolved comments from v2, so I still don't agree with this. I don't
like that I have to write the same three times because you sent three
patchsets...

Best regards,
Krzysztof


