Return-Path: <netdev+bounces-10067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D715E72BCF4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 11:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8FEA2810D3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 09:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE56E18AFF;
	Mon, 12 Jun 2023 09:45:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37AA182C4
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:45:48 +0000 (UTC)
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F63171B
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:45:45 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f6370ddd27so4684255e87.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 02:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686563144; x=1689155144;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DWwcG8B478jMSpAgeoJrfgqQXgVZW1IwS0fWhOn6gk0=;
        b=upBU3IKs93WTyz/V/gEN+RLEp9WIg19EH3y6zBS6ow1ie08c4Ipr7gH1W7uhqwZOZI
         lHfKdssyJ2ly3Fgt/rckwxO3zaArORYq2ZFx8c17CQHCAsSfdrg7KsckJGSP0yKEU0Le
         DR/5IZGAvGTxCdtwx/N/S9z7bWRqufplkmUQ9wk2OEmy9ZahyBakPrxs4eboJOwYkPQE
         anV+zG3p1ay1p4RJxaaMU3uW1z1NCTEFyK2SO42tFuiFuAZu/d0MOqBNMizvH07LrfLg
         VKKf9/6i55Jqj6kFbbj0TPbZhChRYgMDsqpcRE9tkFansq7SNLw3JHSdfqJE6ugpNGZD
         Gt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686563144; x=1689155144;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DWwcG8B478jMSpAgeoJrfgqQXgVZW1IwS0fWhOn6gk0=;
        b=Tgvmkn9sysaG4xUAIaltTHvG4VDHJ834M7hicLC5cd5ozFDqXBKpnbvVsOB2j0lVDl
         4MX9tf262sx11vLeVjfPXcYPJo3KTWRhmDpYWr/t7OIYTwB6muwGIjzTjTgs8iihu4k0
         yxy7D/gczj3qzb0q+AKRKSfT4G3BfAjIKYnCBO1uZBLrnXU/CxgzKcbDLotd9X830xPg
         sr/TDvmXmHpElMJuTgmu7xVUPtbRl+11Ss+6vBBOdSK5JK3Uts8QHRBpR6NKk0YSvtl6
         GTzY2QoTETLP/IY4MnKtF+p1r56oFG8O183cDkLLO7EBInYdicTv6Bhy+NElY83l/ZLu
         KBSw==
X-Gm-Message-State: AC+VfDyIOE1ktnGXKc3PhcfuwKlZY1qjei8mnXBqViIZ13Wj+sVU5vQ2
	xkOnXpXN5y7TvXGanWdbS6bxwg==
X-Google-Smtp-Source: ACHHUZ43/gi+znYlYQvf2z3Zeqhx6w4RHoSruCkErpQAm+KwwannknuxHnOqh55jxAdULPv7Gxv4YA==
X-Received: by 2002:a2e:908f:0:b0:2b1:e943:8abe with SMTP id l15-20020a2e908f000000b002b1e9438abemr2380153ljg.47.1686563144165;
        Mon, 12 Jun 2023 02:45:44 -0700 (PDT)
Received: from [192.168.1.101] (abyj190.neoplus.adsl.tpnet.pl. [83.9.29.190])
        by smtp.gmail.com with ESMTPSA id n23-20020a2e86d7000000b002ac78893a9csm1672079ljj.72.2023.06.12.02.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 02:45:43 -0700 (PDT)
Message-ID: <7fe7078e-404d-28e5-0dd1-53b7f9cd7626@linaro.org>
Date: Mon, 12 Jun 2023 11:45:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 03/26] phy: qcom: add the SGMII SerDes PHY driver
Content-Language: en-US
To: Bartosz Golaszewski <brgl@bgdev.pl>, Vinod Koul <vkoul@kernel.org>,
 Bhupesh Sharma <bhupesh.sharma@linaro.org>, Andy Gross <agross@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Kishon Vijay Abraham I <kishon@kernel.org>,
 Giuseppe Cavallaro <peppe.cavallaro@st.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Jose Abreu <joabreu@synopsys.com>
Cc: netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-phy@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com,
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230612092355.87937-1-brgl@bgdev.pl>
 <20230612092355.87937-4-brgl@bgdev.pl>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230612092355.87937-4-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 12.06.2023 11:23, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Implement support for the SGMII/SerDes PHY present on various Qualcomm
> platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
> +static const struct regmap_config qcom_dwmac_sgmii_phy_regmap_cfg = {
> +	.reg_bits		= 32,
> +	.val_bits		= 32,
> +	.reg_stride		= 4,
> +	.use_relaxed_mmio	= true,
> +	.disable_locking	= true,
The last two are rather brave, no?

Konrad
> +};
> +
> +static int qcom_dwmac_sgmii_phy_probe(struct platform_device *pdev)
> +{
> +	struct qcom_dwmac_sgmii_phy_data *data;
> +	struct device *dev = &pdev->dev;
> +	struct phy_provider *provider;
> +	struct clk *refclk;
> +	void __iomem *base;
> +	struct phy *phy;
> +
> +	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	base = devm_platform_ioremap_resource(pdev, 0);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	data->regmap = devm_regmap_init_mmio(dev, base,
> +					     &qcom_dwmac_sgmii_phy_regmap_cfg);
> +	if (IS_ERR(data->regmap))
> +		return PTR_ERR(data->regmap);
> +
> +	phy = devm_phy_create(dev, NULL, &qcom_dwmac_sgmii_phy_ops);
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	refclk = devm_clk_get_enabled(dev, "sgmi_ref");
> +	if (IS_ERR(refclk))
> +		return PTR_ERR(refclk);
> +
> +	provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(provider))
> +		return PTR_ERR(provider);
> +
> +	phy_set_drvdata(phy, data);
> +	platform_set_drvdata(pdev, data);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id qcom_dwmac_sgmii_phy_of_match[] = {
> +	{ .compatible = "qcom,sa8775p-dwmac-sgmii-phy" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, qcom_dwmac_sgmii_phy_of_match);
> +
> +static struct platform_driver qcom_dwmac_sgmii_phy_driver = {
> +	.probe	= qcom_dwmac_sgmii_phy_probe,
> +	.driver = {
> +		.name	= "qcom-dwmac-sgmii-phy",
> +		.of_match_table	= qcom_dwmac_sgmii_phy_of_match,
> +	}
> +};
> +
> +module_platform_driver(qcom_dwmac_sgmii_phy_driver);
> +
> +MODULE_DESCRIPTION("Qualcomm DWMAC SGMII PHY driver");
> +MODULE_LICENSE("GPL");

