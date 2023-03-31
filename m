Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80C66D1AD9
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCaIwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjCaIwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:52:39 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E06D338
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:52:37 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id e9so7020009ljq.4
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680252756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7jypaeq3aGRlS5bQnlUqvvtZS/6KlIqAhZDD/eEODHU=;
        b=UVAN9q26acRYUP6EqsVjsXDhwEGt0ntXO3aIC3my8pIjihNznNFn6MHmPyhjxiX89D
         AOfZn1D8novdogR4YC9/m0QRw87dGrfpQkDoANT0cyKa5cXZ5MHe+llgGUbOf2QEL9mV
         87mYvRp6bC3GpHXEuwPR4Efhx6J6g1k1zmP3LtPv1xmqzJcFoWuZ74A4KSK7AHBVzNVk
         dDPX63pxR7BPJFRjKxjHuciqOvRmn95LAHQxEJ7hbuPjxeN8vdZAHoBwQKL/j6ZHcnoN
         FuIG4wA9sSR1rhSdsOUj2AJvGF/y4zrl+g2ek+llR7sfa35ga0gJnexGO0S6HzbnEGJT
         YW6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680252756;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7jypaeq3aGRlS5bQnlUqvvtZS/6KlIqAhZDD/eEODHU=;
        b=XVbDiG7ttS6cIFpg1836IE5Tf0ewxOJZlXyyHeckhLZcSDkpIh9F24EuZw3b+2uRtx
         sJu3j/lNpgraBt6HNIviQy0YaNGfFAVi7Ce3U4Foq/lsa1fByVJzXcyQ6+4GoiZnWJv/
         tC5dLgwNt1jopPBShtg//jYed3j1jNqSgWaAAW+rAzdsLQqjZ5m9HWHHM8JyEuMdrSOl
         AjqpC7K5BQSi8gm8p3WGOjdVU8sE/ojxjoiZnDGs/EdSH27wCUpHETYMxIu1v4Xbsaai
         QgPsNjukWkUSbGR/5SDS5Ml9JUsCka6VbXZnfgcyAahlR+WrzbJxF9PPMxBNNxdiUG3v
         yn9w==
X-Gm-Message-State: AAQBX9dykp4DQ9e8hJzp9evtw+CK/HRW3y7UxuXHUkLdxMCdAVYYZebA
        /cxSpldZdkUqs32KShkgWeYWndS+pWM9O7J3Ywo=
X-Google-Smtp-Source: AKy350ZYdPAOwb5YcjbUtsrUjfCFIoL5A/rOTnHUwm9tFhUqi5aDkvfqycWa54AO/gMVHj0bcooGTw==
X-Received: by 2002:a2e:b611:0:b0:2a5:fe8c:ba57 with SMTP id r17-20020a2eb611000000b002a5fe8cba57mr4539046ljn.32.1680252756071;
        Fri, 31 Mar 2023 01:52:36 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id v14-20020a2e990e000000b00295b59fba40sm267121lji.25.2023.03.31.01.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 01:52:35 -0700 (PDT)
Message-ID: <57d6de05-2f6a-3262-cf91-19b55a697c63@linaro.org>
Date:   Fri, 31 Mar 2023 10:52:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] dt-bindings: net: fec: add power-domains property
Content-Language: en-US
To:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
References: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/03/2023 08:15, Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add optional power domains property

This we see from the diff. You should explain why.


> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

