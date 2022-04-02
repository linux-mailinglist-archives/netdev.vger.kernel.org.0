Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59534EFFD3
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 10:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbiDBI5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 04:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiDBI5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 04:57:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9042BB38
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 01:55:14 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id b15so5508237edn.4
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 01:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PZDo1a7O6UxF1uYAQRTat0qN4jx7JaeRIZCQdUVHSzE=;
        b=hHlIQPpUaXrJnVUlpQeMWke2PCpE20KkOoASIS8q1v6JaBZbGIax0QxJRuU99Ba4kM
         xhkaiXfn3SY814Y4Q5oRz2Tz38GWhknzar6EjrrKFwTohHl8B1wwVIr2FJ0wPwo8lDvt
         FfQHeQaqkQ0HthbLXCtQyC6GgMf4qibpxKS1aYqSguoHy+TqiZZm/ud3DFynzeBztR6q
         bqbFrbI30B8HQl6henh6JoIHU9isdGDiwykiuDojBUhoiflqXcrItCqmF5poHDUjay+f
         PbajaMS8riAKg+U+EjYj3LSHqPnICKTNG0DVHBw4xYax3Uwmu1Z7PUIuok0hh2WfUWxL
         1fAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PZDo1a7O6UxF1uYAQRTat0qN4jx7JaeRIZCQdUVHSzE=;
        b=gW5u29lzNz0ulfQ4SQKxRdY8tnF91rw/dmOgZ62YkVsQYoby0DxZuKcA+oyJsKtecY
         oXfFTqUuF2x33FXMWFboeQg2QtKUkkifFiW3ukzx1VuTfZE2zeUdlaPF5VG6eZms4HH8
         kTJ/xpvdkFizxl4J/xh5V2193f4BGZOtBsWBdDo2s7vUtOKuHVUwC975fEFyTGbyjbK/
         3gFBI49fvasiKnGHmBdw/g17dFFCAm8kBpv22bnHIYoIXpLhV5aXkDfCefzCGNnzoHNn
         3lKHxDXp64weB/58kxqQhJ24wPMSwG9kSxx4aLWaCioGzsuAgh0kxcEUwXS2VL/4XRFn
         Fo0w==
X-Gm-Message-State: AOAM533q2sSsSYbd3tKA8tzKUuQYb7OkF8zm7cJreIv029dEgpL6T0dv
        o5UQXJOfiJlBNJDvciTC7WKvLA==
X-Google-Smtp-Source: ABdhPJwHHSAJTrCi0o9mjkv/sXEXHc7StxjjvVh6+XJW4+7aZtWxDtNOun98QySCo81A/ffDCLCQxA==
X-Received: by 2002:a50:ec16:0:b0:40f:28a0:d0d6 with SMTP id g22-20020a50ec16000000b0040f28a0d0d6mr24704292edr.368.1648889712774;
        Sat, 02 Apr 2022 01:55:12 -0700 (PDT)
Received: from [192.168.0.170] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id n27-20020a1709062bdb00b006da975173bfsm1899335ejg.170.2022.04.02.01.55.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 01:55:12 -0700 (PDT)
Message-ID: <503e1144-df8b-bee3-0e9e-411e6599c21b@linaro.org>
Date:   Sat, 2 Apr 2022 10:55:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/3] nfc: st21nfca: fix incorrect validating logic in
 EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@chromium.org>, netdev@vger.kernel.org,
        kuba@kernel.org, christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
References: <20220401180955.2025877-1-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401180955.2025877-1-mfaltesek@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/04/2022 20:09, Martin Faltesek wrote:
> The first validation check for EVT_TRANSACTION has two different checks
> tied together with logical AND. One is a check for minimum packet length,
> and the other is for a valid aid_tag. If either condition is true (fails),
> then an error should be triggered.  The fix is to change && to ||.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>
> ---
>  drivers/nfc/st21nfca/se.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
