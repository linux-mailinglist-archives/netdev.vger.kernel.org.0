Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C336662DDE
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbjAISAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbjAIR76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:59:58 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664613F1A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:58:38 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id g13so14223611lfv.7
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BJGs8UsMtxy7O9L6gYfXogpuu+vcm86IF8PiMybX+R0=;
        b=nv8Oq7uowxQKovM1q4s2KRVMj4usndTvRmwuaAkm8PUj3GOkHckBWQc2HC+s6nA7Dt
         GxFDIHfh6Rb72yONQDkwBRrwp8I1xuOBJjak1D+16IJUugzy+WZd9W+42Vbogc63gDo8
         pgwYV5zQiLChzLtvfLOTnjQBM7GM6zAus266lNCfQU25+djnSZqjiMpNN9fVpoD96CvW
         9a/OF9dewDXfAqh1fDrtKt8lwdaTjCPR6UPTI8N6FVQ+Bg7zFug1agsKawOYkAHr8XQ8
         O3HfgXKvii7Bwj7xC+bglFf0o3ZeCG3U0bUub3R7HdN42k8gKLUmwQek9/tG4SB43NZ4
         xbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJGs8UsMtxy7O9L6gYfXogpuu+vcm86IF8PiMybX+R0=;
        b=06Q49ADh48/+1AI9dYKcOLnJfoHKvwFeCsC3zCZnlq3a1x1v29ReeDAaf8BAO3yMWj
         /Jhv9gHNJkGecRRCPoejb7CNPFJ8bFuxrDcYJ8kAYnDqLO6NfAa0m1eVjtzF9iHvdvoc
         ROmQuUzLe2gKQlPB9SXN4zU4jrK35cJCLZZJkyqdJ75luYgDgnceG7ZZxia/hCvbs4qA
         XnTQ+VJp/L6k7CS6bLLa6W/kZJFaKI65J9kqmZYNXB9LrDshyZwRa7/2jtAU5x1XmfJ+
         xLE3aY4FZ8a0+YiFsY6iZeC2aG3gwY2ol5OX4OAcr9ul1rXgo2oY/fk1wDBNjex9gfZ0
         NwNQ==
X-Gm-Message-State: AFqh2kp6/ygDg0aaYRS/LtkMt7KpwA0m3Y8Dniw8MA2Dwy+JZIXnbWmF
        U2cw+KLYDd7GnrX9NSJvkUWKYkFyDgfARg8e
X-Google-Smtp-Source: AMrXdXsDWgpV2aWXf7dTVnahAo1RGu9ske+kMrXOGt4ywy+xFpTpsLA3ncbrqWehSlXMgHkGOLaACg==
X-Received: by 2002:ac2:5102:0:b0:4b5:6649:eb6c with SMTP id q2-20020ac25102000000b004b56649eb6cmr27606254lfb.25.1673287116612;
        Mon, 09 Jan 2023 09:58:36 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id x9-20020a0565123f8900b004a1e104b269sm1717625lfa.34.2023.01.09.09.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 09:58:35 -0800 (PST)
Message-ID: <bbd21894-234e-542e-80ec-8f2bb11e268e@linaro.org>
Date:   Mon, 9 Jan 2023 18:58:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 02/18] clk: qcom: add the GCC driver for sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, Shazad Hussain <quic_shazhuss@quicinc.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-3-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230109174511.1740856-3-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9.01.2023 18:44, Bartosz Golaszewski wrote:
> From: Shazad Hussain <quic_shazhuss@quicinc.com>
> 
> Add support for the Global Clock Controller found in the QTI SA8775P
> platforms.
> 
> Signed-off-by: Shazad Hussain <quic_shazhuss@quicinc.com>
> [Bartosz: made the driver ready for upstream]
> Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
[...]

> +
> +static struct gdsc usb20_prim_gdsc = {
> +	.gdscr = 0x1C004,
Please use lowercase hex literals outside #defines.

> +	.pd = {
> +		.name = "usb20_prim_gdsc",
> +	},
> +	.pwrsts = PWRSTS_OFF_ON,
> +};
> +
[...]

> +
> +static const struct regmap_config gcc_sa8775p_regmap_config = {
> +	.reg_bits = 32,
> +	.reg_stride = 4,
> +	.val_bits = 32,
> +	.max_register = 0x472cffc,
This is faaaaar more than what your DT node specifies.

With these two fixed, LGTM:

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> +	.fast_io = true,
> +};
> +
> +static const struct qcom_cc_desc gcc_sa8775p_desc = {
> +	.config = &gcc_sa8775p_regmap_config,
> +	.clks = gcc_sa8775p_clocks,
> +	.num_clks = ARRAY_SIZE(gcc_sa8775p_clocks),
> +	.resets = gcc_sa8775p_resets,
> +	.num_resets = ARRAY_SIZE(gcc_sa8775p_resets),
> +	.gdscs = gcc_sa8775p_gdscs,
> +	.num_gdscs = ARRAY_SIZE(gcc_sa8775p_gdscs),
> +};
> +
> +static const struct of_device_id gcc_sa8775p_match_table[] = {
> +	{ .compatible = "qcom,gcc-sa8775p" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, gcc_sa8775p_match_table);
> +
> +static int gcc_sa8775p_probe(struct platform_device *pdev)
> +{
> +	struct regmap *regmap;
> +	int ret;
> +
> +	regmap = qcom_cc_map(pdev, &gcc_sa8775p_desc);
> +	if (IS_ERR(regmap))
> +		return PTR_ERR(regmap);
> +
> +	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
> +				       ARRAY_SIZE(gcc_dfs_clocks));
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Keep the clocks always-ON
> +	 * GCC_CAMERA_AHB_CLK, GCC_CAMERA_XO_CLK, GCC_DISP1_AHB_CLK,
> +	 * GCC_DISP1_XO_CLK, GCC_DISP_AHB_CLK, GCC_DISP_XO_CLK,
> +	 * GCC_GPU_CFG_AHB_CLK, GCC_VIDEO_AHB_CLK, GCC_VIDEO_XO_CLK.
> +	 */
> +	regmap_update_bits(regmap, 0x32004, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x32020, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0xc7004, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0xc7018, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x33004, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x33018, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x7d004, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x34004, BIT(0), BIT(0));
> +	regmap_update_bits(regmap, 0x34024, BIT(0), BIT(0));
> +
> +	return qcom_cc_really_probe(pdev, &gcc_sa8775p_desc, regmap);
> +}
> +
> +static struct platform_driver gcc_sa8775p_driver = {
> +	.probe = gcc_sa8775p_probe,
> +	.driver = {
> +		.name = "gcc-sa8775p",
> +		.of_match_table = gcc_sa8775p_match_table,
> +	},
> +};
> +
> +static int __init gcc_sa8775p_init(void)
> +{
> +	return platform_driver_register(&gcc_sa8775p_driver);
> +}
> +subsys_initcall(gcc_sa8775p_init);
> +
> +static void __exit gcc_sa8775p_exit(void)
> +{
> +	platform_driver_unregister(&gcc_sa8775p_driver);
> +}
> +module_exit(gcc_sa8775p_exit);
> +
> +MODULE_DESCRIPTION("Qualcomm SA8775P GCC driver");
> +MODULE_LICENSE("GPL");
