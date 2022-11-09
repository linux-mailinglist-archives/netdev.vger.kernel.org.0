Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73DC622A43
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKILUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230404AbiKILUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:20:42 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799D427B08
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:20:41 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id h12so25239093ljg.9
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=88yTM1uJKEU4nUryrFzcHBneq7U0QfCFix/2TI4Onpk=;
        b=DfkZOEZylfFUnSWpURoh/sz7HSBi78Kh0RQ7SssObIac18QqVqnmtclaK6tpj9/Czv
         JBWGdhgT+SmtmlSSh92nInbwROaBgh3JSgt7eTSJ3jxcKHn5yrKoqvmWar3FimbjYLwQ
         F/tFC4zzeXf4IKywa7ksSp2XWOHlyVcSU6Ytd7CWzdcfGWDzlr5X6oBCnZZFcdo4yKcm
         SH617uPem+06DdgPb0Vl7tv7YF/FY7A4OkmnNPUblYpuSijCVUdOrMUgYwohWfqAQciM
         P4fgTN0iJypSm6BI6nmFPhOQjUf37bzOiz5SxHWS9NozP+K7ucNmD4TX4Id5KQU5N7eT
         ysOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=88yTM1uJKEU4nUryrFzcHBneq7U0QfCFix/2TI4Onpk=;
        b=PQMAoHb2IGMhnF+DD8f3gTFlQA+d6QLcWLlDzu1tmpiHY5KbnB7QF/U90WL+fjSdN/
         hDgrWtGDjMxn8v8m0C5Pg2KD0iohmS/1hV3Jh8hpl0YMd65sNpuwRUQCHzqs8MqbV88r
         JscRve6Vyzp1+Kz7Ty/gVrnbnJPmdiT8BvDfARZbeXL7DrQOUmMdCUIiiGDfcbtX45wv
         b15OtPNh2ticazwKv7BRS5/PyHWvpqV9T0INO6Py1VXPLr2N+mtVI5NFD7ppzKcFD3Mc
         NQqOvgGnwpHwF52SWvdZANTXB76GQF1LN7iKVlq8eK61K8+LgVrxchXmgy5PwMbIOeDI
         JGVQ==
X-Gm-Message-State: ACrzQf0jbiYm6ppj3ZKFlxuoYlg2gv2P6VQzZ/BJ2dLL9NPzYXaq0PrI
        bHldKfTaX/kSdSgSRhL0NYdM9g==
X-Google-Smtp-Source: AMsMyM7gOlyu5kF/XFyAzve3EYtqXVo+h9qSupfEhKOd0KIj7d1NxKjvrTEy/mIcW1/4AID0bhfUSA==
X-Received: by 2002:a2e:6e13:0:b0:26d:f70e:3415 with SMTP id j19-20020a2e6e13000000b0026df70e3415mr7962169ljc.216.1667992839869;
        Wed, 09 Nov 2022 03:20:39 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id bd22-20020a05651c169600b0027703e09b71sm2066440ljb.64.2022.11.09.03.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:20:39 -0800 (PST)
Message-ID: <a9901cbd-8af3-04aa-12f5-df7c563f873a@linaro.org>
Date:   Wed, 9 Nov 2022 12:20:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 5/6] can: m_can: Add ECC functionality for message RAM
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100302epcas5p276282a3a320649661939dcb893765fbf@epcas5p2.samsung.com>
 <20221109100928.109478-6-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221109100928.109478-6-vivek.2311@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 11:09, Vivek Yadav wrote:
> Whenever MCAN Buffers and FIFOs are stored on message ram, there are
> inherent risks of corruption known as single-bit errors.
> 
> Enable error correction code (ECC) data integrity check for Message RAM
> to create valid ECC checksums.
> 
> ECC uses a respective number of bits, which are added to each word as a
> parity and that will raise the error signal on the corruption in the
> Interrupt Register(IR).
> 
> This indicates either bit error detected and Corrected(BEC) or No bit
> error detected when reading from Message RAM.
> 
> Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>

(...)

>  
> +static int m_can_plat_init(struct m_can_classdev *cdev)
> +{
> +	struct  m_can_ecc_regmap *ecc_cfg = &cdev->ecc_cfg_sys;
> +	struct device_node *np = cdev->dev->of_node;
> +	int ret = 0;
> +
> +	if (cdev->mram_cfg_flag != ECC_ENABLE) {
> +		/* Initialize mcan message ram */
> +		ret = m_can_init_ram(cdev);
> +
> +		if (ret)
> +			return ret;
> +
> +		cdev->mram_cfg_flag = ECC_ENABLE;
> +	}
> +
> +	if (ecc_cfg->ecc_cfg_flag != ECC_ENABLE) {
> +		/* configure error code check for mram */
> +		if (!ecc_cfg->syscon) {
> +			ecc_cfg->syscon =
> +			syscon_regmap_lookup_by_phandle_args(np,
> +							     "tesla,mram-ecc-cfg"
> +							     , 1,

, goes to previous line

> +							     &ecc_cfg->reg);
> +		}
> +
> +		if (IS_ERR(ecc_cfg->syscon)) {
> +			dev_err(cdev->dev, "couldn't get the syscon reg!\n");

Didn't you just break all platforms using ECC?

Best regards,
Krzysztof

