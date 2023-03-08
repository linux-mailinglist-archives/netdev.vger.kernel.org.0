Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2106B0400
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 11:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjCHKXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 05:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjCHKXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 05:23:07 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86BDD7EFE
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 02:22:58 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x3so63532539edb.10
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 02:22:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678270977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ANOvCOjcR37YHU0tLH/+xDUx5MoqGm95UD+lp6dowFE=;
        b=l6wFqk+Gzy82OQVrxAen6MrjYgfZlwIndoLoD11KzR1wpXVQVW64nQKxoouwOCR1uJ
         nsE1Jz1sJYjAxPpdVOSiKZcqx6I8Ww8JP2VI/+FBV74p12IMrEx9wZZbTAZyJFOTl9OP
         wDYZApf0Ndcy2rHyyYSuAmL+X1zffkGgRydX2qNzpu9Q6J4yhKHgQluRvYXGGHg6otcl
         7mkStY5JNYG6UodrnO/6od4rftuL9fgGa3PLB6TH4aZ4t3uFldboi8Kyr65NnbLPwD2/
         C8dGRbSwzLPT4SzBmNR1M6zIgZ/BiuJL10UXZ5LiVvr48ADojz2qcL1AKlX2mkOOQpep
         YvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678270977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ANOvCOjcR37YHU0tLH/+xDUx5MoqGm95UD+lp6dowFE=;
        b=H1WA3Cbdiq+2Y/g4IRzOvZyTqY/y9mhzTlpfF9ubMAzojbs+Y5mqh3rLDHyOFHDJ/q
         YVp3evp1Gx2rxGKrKzEPmXll0eyZQB7gALbS3p06R3k54k3jx0wCqrawJo0rTp89pwef
         n/2ZtQDFi10F9wB1Cr9qjaV5blsd1FYjrnHrgYA7ejAicPF1U8t0DTgil+60abpB5NfP
         MBcn6laolBWxvBCHbuRoT8jft4HQ/NqPmpa3mnKSS6dsffYFRTHFhHbt6WvWOsH/DmYD
         pJzNVMt3M9PBtNDvGp6gKiBYwy+UiUvWnWpB47gW0qQ10n9QTSw0VkAk7DmJHBEa1Tx7
         oHKg==
X-Gm-Message-State: AO0yUKVhlQsEAnFQ+u9minfR0UHHKCzO+Jz8VWR0SzcNb6utkZvwIq1f
        E9DdyHDRCrAIhth2fDhd80QVPA==
X-Google-Smtp-Source: AK7set+KucngWxAK/nbtRhR0yZNXWWWlrTXtUnifJvxvgsmJKY3NVgXSHU9WOCciMZlioLt5STCC+w==
X-Received: by 2002:a50:ee18:0:b0:4af:69b8:52af with SMTP id g24-20020a50ee18000000b004af69b852afmr15524679eds.24.1678270976869;
        Wed, 08 Mar 2023 02:22:56 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:ff33:9b14:bdd2:a3da? ([2a02:810d:15c0:828:ff33:9b14:bdd2:a3da])
        by smtp.gmail.com with ESMTPSA id v30-20020a50955e000000b004bf2d58201fsm7983065eda.35.2023.03.08.02.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 02:22:56 -0800 (PST)
Message-ID: <9cad9f9e-3619-67a4-2f63-bd334b3d88f7@linaro.org>
Date:   Wed, 8 Mar 2023 11:22:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] nfc: pn533: initialize struct pn533_out_arg properly
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org,
        syzbot+1e608ba4217c96d1952f@syzkaller.appspotmail.com
References: <20230306214838.237801-1-pchelkin@ispras.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230306214838.237801-1-pchelkin@ispras.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2023 22:48, Fedor Pchelkin wrote:
> struct pn533_out_arg used as a temporary context for out_urb is not
> initialized properly. Its uninitialized 'phy' field can be dereferenced in
> error cases inside pn533_out_complete() callback function. It causes the
> following failure:
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

