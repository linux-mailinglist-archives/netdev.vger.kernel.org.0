Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1D866BFD7
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjAPNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjAPNdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:33:16 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A211D923
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:33:13 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so22150493wms.2
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=vNvOX7djjjBjKEHmE27QSb/utZxm3kNjauubSDkICIY=;
        b=6bhtEiB/26w40qL9HaO/mVd9X3p8jy6vR7QeqGrPRJ9VB4cbhqVmYX8lVFCN97bDp8
         +SwI6iuAHzjQLzrGzQdusMA6GrMJ5o4ITzzzqlWBSXyBsu96TRSSoTiYjuDKjfoEIQTl
         UOJLQioaei3BPtjjyn1U51LZtT64WFjP9YS1Uz6XnRV7A9TBSxPARRUB5iUO58JFaAaa
         VHJfn12xJ5HIT8jyQD6neJWmA+Sr7sVm3iU4xnZi3JOxzzOBH/F4ZzRVmL8SSVUeuVy0
         /O1ujgi0twVfWd0t7dgMSPfB2CpWz+cngGXWzdcdt96kJ7AIAb9UlnOVcDmlcxb7bsap
         GJRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vNvOX7djjjBjKEHmE27QSb/utZxm3kNjauubSDkICIY=;
        b=3Hbz4/NdFo+E6O9nHi7cShCg0eQg/lzDDz6f/NR61m9CJSSvRlEwjqEFj7kbcm6P8o
         aDcXwAbj/6FA01x9x7ZYFUtjymbx5PsbBWr7h4JayxXoBi4Gg6/J+Vuc4jS01hXq6u32
         E7crSKIvQzsEwrA/jfBDbtwK4vANHJ5IGpvcknY332mViZDCduR4+tn/2mbeHCEDn4oA
         OtlkMB2Sh7WBDd2UZcAil2C2msopeu1jwMg6I+SEYVQN2gXrID4gSka3MTyXnrQTGMtR
         hXvyjIHPnjrXYw3KncHwRUCXpgSm14yrcQA4FUGT3nZDDyXvL8UySUPpyHWjED18T5rh
         wYeQ==
X-Gm-Message-State: AFqh2krRlAwlZ6R/0S1N7UZFjSyx/8MTPl9dJmMn5/Cp6UmHlLbHePmu
        0Bu48v65xbCsFpAD12Bx4GK5IA==
X-Google-Smtp-Source: AMrXdXs7Udt0PVl+BdLhxYFkzaWgm2loEFFrkTgEVgK1GDAx8n6smMRhZQAkQmlOxiad+c7F5VlOMw==
X-Received: by 2002:a05:600c:4d23:b0:3da:270b:ba6b with SMTP id u35-20020a05600c4d2300b003da270bba6bmr9967300wmp.41.1673875992502;
        Mon, 16 Jan 2023 05:33:12 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id d6-20020a05600c3ac600b003da0dc39872sm16227317wms.6.2023.01.16.05.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 05:33:12 -0800 (PST)
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-3-jbrunet@baylibre.com>
 <Y8U+1ta6bmt86htm@corigine.com>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: mdio: add amlogic gxl mdio mux support
Date:   Mon, 16 Jan 2023 14:27:57 +0100
In-reply-to: <Y8U+1ta6bmt86htm@corigine.com>
Message-ID: <1jk01mhaeg.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 16 Jan 2023 at 13:11, Simon Horman <simon.horman@corigine.com> wrote:

> On Mon, Jan 16, 2023 at 10:16:36AM +0100, Jerome Brunet wrote:
>> Add support for the mdio mux and internal phy glue of the GXL SoC
>> family
>> 
>> Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
>> ---
>>  drivers/net/mdio/Kconfig              |  11 ++
>>  drivers/net/mdio/Makefile             |   1 +
>>  drivers/net/mdio/mdio-mux-meson-gxl.c | 160 ++++++++++++++++++++++++++
>>  3 files changed, 172 insertions(+)
>>  create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c
>
> Hi Jerome,
>
> please run this patch through checkpatch.

Shame ... I really thought I did, but I forgot indeed.
I am really sorry for this. I'll fix everything.

>
> ...
>
>> diff --git a/drivers/net/mdio/mdio-mux-meson-gxl.c b/drivers/net/mdio/mdio-mux-meson-gxl.c
>> new file mode 100644
>> index 000000000000..205095d845ea
>> --- /dev/null
>> +++ b/drivers/net/mdio/mdio-mux-meson-gxl.c
>
> ...
>
>> +static int gxl_enable_internal_mdio(struct gxl_mdio_mux *priv)
>> +{
>
> nit: I think void would be a more appropriate return type for this
>      function. Likewise gxl_enable_external_mdio()
>
> ...
>
>> +static int gxl_mdio_mux_probe(struct platform_device *pdev){
>
> nit: '{' should be at the beginning of a new line
>
>> +	struct device *dev = &pdev->dev;
>> +	struct clk *rclk;
>> +	struct gxl_mdio_mux *priv;
>
> nit: reverse xmas tree for local variable declarations.
>
>> +	int ret;
>> +
>> +	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
>> +	if (!priv)
>> +		return -ENOMEM;
>
> nit: may be it is nicer to use dev_err_probe() here for consistency.

That was on purpose. I only use the `dev_err_probe()` when the probe may
defer, which I don't expect here.

I don't mind changing if you prefer it this way.

>
>> +	platform_set_drvdata(pdev, priv);
>> +
>> +	priv->regs = devm_platform_ioremap_resource(pdev, 0);
>> +	if (IS_ERR(priv->regs))
>> +		return PTR_ERR(priv->regs);
>
> And here.
>
> ...

