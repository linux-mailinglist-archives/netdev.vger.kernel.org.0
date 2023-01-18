Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E366E671FCB
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbjAROi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjAROhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:37:51 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFBB66FA9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:28:00 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id bk15so26142041ejb.9
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 06:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tGsNaYd8lzrEJBZWh/jXK77/CF4jiaEZbxlPMQt1yUA=;
        b=yGgv4bRS23TPtTiAaUpfhM7ARvm/Md/VxtiJeL6mzD/ShTWfpUCOmR2JYuBXb9nwV8
         Hnjx4/fhXVb75lGNMSC6kR+eOmOGg/nsAmix226J9z1IltroWTgraHT67mb9C0NSlgdN
         2FYm9ogR/3dvC6TGl4uV+C8JvUBo2QsX32nYkjO7uxAY88e5q0qLkoORP56kXrt7Jarm
         ojfbGc/I9iN1zTbo6RyJVjKsvbObTFE+NL8H98j6OKruudOMBLu/d7fqP7bVkTcd9kAT
         4q2GB6mH24pr3FviUt7tBrEoXfy18t2g/bPCy6tmkaGbCg1s9txiRVGS64UFnxK6Uhzz
         YCoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tGsNaYd8lzrEJBZWh/jXK77/CF4jiaEZbxlPMQt1yUA=;
        b=2fPAYVO6AIIFM5B4MJA7N43mJLPtVfej+VIi5b7YU3p4hNUQ/a5N3f7vFd9wBIwG90
         QhQDEpFsZGSnmqm9PVdR5dkzYMCLOhZa9qerFfzmgPYtqc8mFBUuch2bYiDbHpeyplQa
         k9IKzjVmT3ib4bIf4aDUACIxNbTb7RtkajXmMEpiCtznjk0gGxwNw0vblZQt8tUTvtxR
         eUbrAC8eouYjRccr6X/fOUeA9I+PO1lJ1PlV68aexzme6J3TseS/wfnWJY6rX4Dwv+G7
         2fhwrk5xz98Y4F3vjx3CH6wqrl5751mocv1j9tKsqAFNVHxnGPUodNAJGu2g9nhcILD2
         tpjg==
X-Gm-Message-State: AFqh2kqaOzxoc7vexTw1VREf4BIC0HgO0PYH49UZprn0T5m3egeNHL5f
        UfGrNuSV0i6Vqd/kfQhg1Mf1rA==
X-Google-Smtp-Source: AMrXdXtaZoCq1axVrnXR3NO7JWhyRBJo7prw3mrcpWnr7PBsifQfh/PbqAmQtCohleDsgwL+x5LqLQ==
X-Received: by 2002:a17:906:5906:b0:870:2f70:c624 with SMTP id h6-20020a170906590600b008702f70c624mr7429241ejq.3.1674052078711;
        Wed, 18 Jan 2023 06:27:58 -0800 (PST)
Received: from [192.168.1.101] (abxh252.neoplus.adsl.tpnet.pl. [83.9.1.252])
        by smtp.gmail.com with ESMTPSA id um41-20020a170907cb2900b0086c4fbb8507sm6114730ejc.225.2023.01.18.06.27.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 06:27:58 -0800 (PST)
Message-ID: <e47e3ec7-4c89-0472-cc87-9c9cc6db8519@linaro.org>
Date:   Wed, 18 Jan 2023 15:27:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/2] clk: qcom: add the GCC driver for sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Shazad Hussain <quic_shazhuss@quicinc.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230117180429.305266-1-brgl@bgdev.pl>
 <20230117180429.305266-3-brgl@bgdev.pl>
From:   Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <20230117180429.305266-3-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17.01.2023 19:04, Bartosz Golaszewski wrote:
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
> +static int __init gcc_sa8775p_init(void)
> +{
> +	return platform_driver_register(&gcc_sa8775p_driver);
> +}
> +subsys_initcall(gcc_sa8775p_init);
core_initcall, otherwise you'll be waiting for years :P

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Konrad
> +
> +static void __exit gcc_sa8775p_exit(void)
> +{
> +	platform_driver_unregister(&gcc_sa8775p_driver);
> +}
> +module_exit(gcc_sa8775p_exit);
> +
> +MODULE_DESCRIPTION("Qualcomm SA8775P GCC driver");
> +MODULE_LICENSE("GPL");
