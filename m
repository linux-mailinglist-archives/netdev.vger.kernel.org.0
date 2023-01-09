Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9D6662EB3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237584AbjAISVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbjAISUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:20:43 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C543C00
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:18:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id f34so14271908lfv.10
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5LmS5ZO2TtDQ6P61GlWGjss8FaAkcuFxtuwA1Gc1BKc=;
        b=UQ5oyt2wJYJPvyhWkud0csDfT4+TRsuKrLRKk7KKa1oMDZW4QLxwSANhoO8h33NFWQ
         TwhEa6L9sgnJuFkQFsEw5ML75KiOXSskXam//k1BJ4BI7vjDw+AjsComy+UjSZb7IO0X
         FfikElm0UKN8L+NnGOe6XnIpw9tvOK8d4BOf8a7tBYsJADC2dmc0L7/9REDH6h95T/gh
         VnrzXsBENgmzMN1untytGy5hdxcDWSB28wXjOKBZkHN1dBa4ab4X3xV7OhVdP0eHS5sI
         OP35GZH9N8NjE4KZcXniYEfIj/TRbvCYZ/YJl4f2IG7CeHuL2HpTPGRAOzu4EK06yWgR
         YH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5LmS5ZO2TtDQ6P61GlWGjss8FaAkcuFxtuwA1Gc1BKc=;
        b=10+1NhQCM858FwntZBjPZxJI9dYBrrzrOM1baIqQtLxyCq5r5tamy8ihs45fb0PT3t
         /uZEjAQpw/t+/xcOOXawknHG3iBkOy5V+hpd9xqyDJHG6XLa1tdTn95kQ2NwUFJ5j0NB
         zf5FUpPcUiR4pJsoN0noMllIdskcOL6+MyYQol5b2kO8VIuzSe9ee5FLSPrR6/NKloWe
         3vCUfH7vY35381C9IAwwzjA3FBC6JdxYmch87CAnTXPJeszcvc0E42hYrC9RRAOd/5e0
         3myvWUs1XYQ+LNR0DNvdKL5Ie99U8SgBASAxP4ZxvlYX+jVk8hYyhT3XHw2IprG3w9hC
         CSjg==
X-Gm-Message-State: AFqh2kr4cBDz6G9w01zklAngGJ5XF5LRVvOIoS+aQ+DfXEqMJngXg7zB
        c3mF45prXJdPCC+ZBJG3qjSO0A==
X-Google-Smtp-Source: AMrXdXvvfOFbQwwZ3SbTKgeWOk2i/0UCppSMUdlr8v90NtZNo80+hz5+ach7NcITAU1Ni/Itfyh0Wg==
X-Received: by 2002:a05:6512:c1b:b0:4cb:3e50:f5e3 with SMTP id z27-20020a0565120c1b00b004cb3e50f5e3mr8899209lfu.61.1673288315004;
        Mon, 09 Jan 2023 10:18:35 -0800 (PST)
Received: from [192.168.1.101] (abxi45.neoplus.adsl.tpnet.pl. [83.9.2.45])
        by smtp.gmail.com with ESMTPSA id e15-20020a05651236cf00b00492e3c8a986sm1718439lfs.264.2023.01.09.10.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:18:33 -0800 (PST)
Message-ID: <7b58565f-c512-57c4-c417-49dcff19fa2b@linaro.org>
Date:   Mon, 9 Jan 2023 19:18:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 02/18] clk: qcom: add the GCC driver for sa8775p
Content-Language: en-US
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
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
 <bbd21894-234e-542e-80ec-8f2bb11e268e@linaro.org>
In-Reply-To: <bbd21894-234e-542e-80ec-8f2bb11e268e@linaro.org>
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



On 9.01.2023 18:58, Konrad Dybcio wrote:
> 
> 
> On 9.01.2023 18:44, Bartosz Golaszewski wrote:
>> From: Shazad Hussain <quic_shazhuss@quicinc.com>
>>
>> Add support for the Global Clock Controller found in the QTI SA8775P
>> platforms.
>>
>> Signed-off-by: Shazad Hussain <quic_shazhuss@quicinc.com>
>> [Bartosz: made the driver ready for upstream]
>> Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>> ---
> [...]
> 
>> +
>> +static struct gdsc usb20_prim_gdsc = {
>> +	.gdscr = 0x1C004,
> Please use lowercase hex literals outside #defines.
> 
>> +	.pd = {
>> +		.name = "usb20_prim_gdsc",
>> +	},
>> +	.pwrsts = PWRSTS_OFF_ON,
>> +};
>> +
> [...]
> 
>> +
>> +static const struct regmap_config gcc_sa8775p_regmap_config = {
>> +	.reg_bits = 32,
>> +	.reg_stride = 4,
>> +	.val_bits = 32,
>> +	.max_register = 0x472cffc,
> This is faaaaar more than what your DT node specifies.
> 
> With these two fixed, LGTM:
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> Konrad
>> +	.fast_io = true,
>> +};
>> +
>> +static const struct qcom_cc_desc gcc_sa8775p_desc = {
>> +	.config = &gcc_sa8775p_regmap_config,
>> +	.clks = gcc_sa8775p_clocks,
>> +	.num_clks = ARRAY_SIZE(gcc_sa8775p_clocks),
>> +	.resets = gcc_sa8775p_resets,
>> +	.num_resets = ARRAY_SIZE(gcc_sa8775p_resets),
>> +	.gdscs = gcc_sa8775p_gdscs,
>> +	.num_gdscs = ARRAY_SIZE(gcc_sa8775p_gdscs),
>> +};
>> +
>> +static const struct of_device_id gcc_sa8775p_match_table[] = {
>> +	{ .compatible = "qcom,gcc-sa8775p" },
One more thing, this should be qcom,sa8775p-gcc.

Konrad
>> +	{ }
>> +};
>> +MODULE_DEVICE_TABLE(of, gcc_sa8775p_match_table);
>> +
>> +static int gcc_sa8775p_probe(struct platform_device *pdev)
>> +{
>> +	struct regmap *regmap;
>> +	int ret;
>> +
>> +	regmap = qcom_cc_map(pdev, &gcc_sa8775p_desc);
>> +	if (IS_ERR(regmap))
>> +		return PTR_ERR(regmap);
>> +
>> +	ret = qcom_cc_register_rcg_dfs(regmap, gcc_dfs_clocks,
>> +				       ARRAY_SIZE(gcc_dfs_clocks));
>> +	if (ret)
>> +		return ret;
>> +
>> +	/*
>> +	 * Keep the clocks always-ON
>> +	 * GCC_CAMERA_AHB_CLK, GCC_CAMERA_XO_CLK, GCC_DISP1_AHB_CLK,
>> +	 * GCC_DISP1_XO_CLK, GCC_DISP_AHB_CLK, GCC_DISP_XO_CLK,
>> +	 * GCC_GPU_CFG_AHB_CLK, GCC_VIDEO_AHB_CLK, GCC_VIDEO_XO_CLK.
>> +	 */
>> +	regmap_update_bits(regmap, 0x32004, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x32020, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0xc7004, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0xc7018, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x33004, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x33018, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x7d004, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x34004, BIT(0), BIT(0));
>> +	regmap_update_bits(regmap, 0x34024, BIT(0), BIT(0));
>> +
>> +	return qcom_cc_really_probe(pdev, &gcc_sa8775p_desc, regmap);
>> +}
>> +
>> +static struct platform_driver gcc_sa8775p_driver = {
>> +	.probe = gcc_sa8775p_probe,
>> +	.driver = {
>> +		.name = "gcc-sa8775p",
>> +		.of_match_table = gcc_sa8775p_match_table,
>> +	},
>> +};
>> +
>> +static int __init gcc_sa8775p_init(void)
>> +{
>> +	return platform_driver_register(&gcc_sa8775p_driver);
>> +}
>> +subsys_initcall(gcc_sa8775p_init);
>> +
>> +static void __exit gcc_sa8775p_exit(void)
>> +{
>> +	platform_driver_unregister(&gcc_sa8775p_driver);
>> +}
>> +module_exit(gcc_sa8775p_exit);
>> +
>> +MODULE_DESCRIPTION("Qualcomm SA8775P GCC driver");
>> +MODULE_LICENSE("GPL");
