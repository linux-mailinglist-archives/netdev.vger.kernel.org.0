Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2846B9A65
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbjCNPxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjCNPxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:53:00 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A6EB3712
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:52:30 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id j11so63900954edq.4
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678809149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zg/dbJqx6C7WUc0OA0EewndlIUFYWOD5txSdJQdofgE=;
        b=yP9Owfjo7PGRIP3B1HLP+d1MYxOHfoc9ijHXD+z7wWi9d3lgFnDRzQYw8DUlAG+rPo
         jsOJbsKpbB2kx+ZKt9HmL/daQOii/q8YjwtzXC2Wl/YEdq1DVCLiuK1ken1LjCGPBQHv
         8C9rpqYS3OSPyET/LGqcguh4LMMBgryr7aEW/22UqjuugjEiCnqTgs1rLt1SEkHzHADG
         SBaHRR9WqywGtdFOKHOwUwLWr802MLmvlWupgRNw5L6k8aehiHgkI7iRUe6RVquTscDu
         LVe+bCHma+dk8aYllgGyj7+Vdwk6jAV2/hxNMvMF0iUcW72bZfM/kzC/vboVUshEAJ0b
         7uCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678809149;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zg/dbJqx6C7WUc0OA0EewndlIUFYWOD5txSdJQdofgE=;
        b=6jMXXxHQD82q6zGn1s8lLarjZvqXJUpWkxSZ4QHuhwWyetjiS/E+7W9UAQ150efJMP
         rd/nbahnE7nv5vNvpN6eqNe8LwQ4a2LWt3tAJn/Y7tBStH94a99YptHrLTgD7D99VXeu
         ne4mTfvtdlF0cyKhN0ns+u3bpUINwzK8c2KZfDyNlRbXPyRE7NfKVmvok5y+t+vC5zu/
         pFZ7LAkT7BI0BZpMjNWEwbKnfKPvkobCfUIczL9bWfqMJ2Xbmx+Wc5Ow1F6NV/SyFsJl
         rATYh7/Pi8PPM0wDV2aDcsmL14/AKUlRGodc3mDcb2MGYHc1ubqT2VdghsoIiH11rZdR
         X3/Q==
X-Gm-Message-State: AO0yUKWZjAk0bWc8k2bQrRnoNxcjPUOVUUpPjjCvogEh3qpcgPd1wW2Z
        exiTxDoyVwGHxW2TZR2lx6doHg==
X-Google-Smtp-Source: AK7set8sczpur0csEsVFPsaUidWA5OBlNs02kM223Cbb9T4gydo9WzUp9PB+4f/EVPEN0CpPIDSa1g==
X-Received: by 2002:aa7:c245:0:b0:4ac:c44e:a493 with SMTP id y5-20020aa7c245000000b004acc44ea493mr37940365edo.2.1678809149107;
        Tue, 14 Mar 2023 08:52:29 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:59be:4b3f:994b:e78c? ([2a02:810d:15c0:828:59be:4b3f:994b:e78c])
        by smtp.gmail.com with ESMTPSA id le20-20020a170906ae1400b00921c608b737sm1297788ejb.126.2023.03.14.08.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 08:52:28 -0700 (PDT)
Message-ID: <b919ce2b-7f0f-a0ea-1ac8-ccc8d0c1b11b@linaro.org>
Date:   Tue, 14 Mar 2023 16:52:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        anirudha.sarangi@amd.com, harini.katakam@amd.com, git@amd.com
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <20230313161510.540f6653@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313161510.540f6653@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 00:15, Jakub Kicinski wrote:
> On Wed, 8 Mar 2023 11:42:23 +0530 Sarath Babu Naidu Gaddam wrote:
>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>
>> Convert the bindings document for Xilinx AXI Ethernet Subsystem
>> from txt to yaml. No changes to existing binding description.
>>
>> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>> Signed-off-by: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
> 
> Rob, Krzysztof, looks good?

Thanks for ping, unfortunately needs some changes or clarifications. I
responded with review.

Best regards,
Krzysztof

