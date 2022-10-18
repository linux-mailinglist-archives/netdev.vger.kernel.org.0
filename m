Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873B4602D7A
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 15:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiJRNza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 09:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbiJRNzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 09:55:25 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36D3BA268
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:55:23 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id cr19so6375224qtb.0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 06:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pf6LGWRADEPquzcDVS6WIhexsoIsbJlr5uJbbzXLTRU=;
        b=FjM+V2FgRyo5VfMYOJKrX9qr/mp9aAmeJH4XTiaswih5oE2GsyJgqU+dEB1+8j2GlZ
         JORXWGtAmn95cdb6X1F6zBpkPrKWKZoEkXnOXmonyWNltgCAIig+GRZzhSqnWSrULXeN
         RXH879Y3vk/527LLQoLlHeQ45bbcdz9LQsAHIawXkE7SNTDg9iWksAW1D9SjF6kcw/3H
         0StCuYWPF2uNztN7mwp4OhFsrgCxlCfqRL9dMI/NtHsnkWKFdn2fXrKjI/8y9FCr+Xd8
         oXKA+FRg3VCV1SLPTpuAa1naLeV0c26f7JEyFAClXYb2FPz0mQHrtgHDHt5VcydBbo8f
         H45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pf6LGWRADEPquzcDVS6WIhexsoIsbJlr5uJbbzXLTRU=;
        b=ibydn8RaavVDsN4iWMHsKEgCB1yPf9v69lpur+oT517oEk9/dw+FDGId7LST7YMVbn
         INqxaCc8PE8neS3MGglJ8kmg9ki0z7bTmQw4bH4W5vzBtCWaWrPtt7xQKZytaIYGfwg0
         0/1szBfE5ILab5VuCzixekTtb3ekUIdHpGVCqxF7nLmojgvib1sf1UaemGgKZ3bnZqqO
         R3AWYrhpIfLse+FenBcWEOduNLsDPHit2yvjI+/+WDsDkgziEj2CSwz9bLl9JLARO2B6
         126xaVoF2yvXETGCDBghCbAhNZ12bBtZsgmEFJ85x1H7rxJZJuvPdQXZkOoomVP/fp8K
         9IwQ==
X-Gm-Message-State: ACrzQf0yO4M3/+mPfdVspGyOQgsJYlrPd9n/bbk5qrXukBRNyMJ39EAo
        4USv+AhnGEBbRXgEyEWTYr6TwQ==
X-Google-Smtp-Source: AMsMyM5hABrhjZ5bunQ3odusEla5f1ECmgb6/iAg2mrHybO4TG1a2vr9UTYtBhhJB8T9Poxa7lAVhA==
X-Received: by 2002:a05:622a:114:b0:39c:b7ec:345a with SMTP id u20-20020a05622a011400b0039cb7ec345amr2064397qtw.677.1666101322890;
        Tue, 18 Oct 2022 06:55:22 -0700 (PDT)
Received: from [192.168.10.124] (pool-72-83-177-149.washdc.east.verizon.net. [72.83.177.149])
        by smtp.gmail.com with ESMTPSA id m13-20020a05620a24cd00b006ce76811a07sm2440858qkn.75.2022.10.18.06.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Oct 2022 06:55:22 -0700 (PDT)
Message-ID: <a524333b-f318-c532-e484-72df776d4752@linaro.org>
Date:   Tue, 18 Oct 2022 09:55:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Shang XiaoJing <shangxiaojing@huawei.com>,
        bongsu.jeon@samsung.com, kuba@kernel.org, netdev@vger.kernel.org
References: <20221017084408.18834-1-shangxiaojing@huawei.com>
 <bb57c67a9235cb47d62a7cf8c01b70b8815b2d29.camel@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <bb57c67a9235cb47d62a7cf8c01b70b8815b2d29.camel@redhat.com>
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

On 18/10/2022 05:32, Paolo Abeni wrote:
> @Krzysztof: it looks like that the send() return value is always
> ignored. Do you plan to use it at some point or could we change the
> return type to void?

Are you sure it is ignored? I think it is being returned in
nci_send_frame().

Best regards,
Krzysztof

