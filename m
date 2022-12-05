Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46065642454
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiLEIRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbiLEIR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:17:29 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CC015FEA
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:17:28 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id a19so12689813ljk.0
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 00:17:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bf6Nbj5cxRxF5T9bn4Fy/raNIgAK309Q68fjLTBm7eI=;
        b=p5kQNYNHPNalXdM+733RBJdI9HKCqDM+hMORWwDeb5fyl1AvTEzc+Y3gEjY9kwh2zp
         uge52YfmoJfA7DYYyObmwDaaDMhiG2MYUhsaZ4MM7YGpsy05vxD/QNePpYTrXoR4mXwH
         upZXn0q3UHrz2P/zQsTky0fjB0pzud4kJiq4HB6HSFZJ9WDyMJPB/COY/33rCF5qbPsJ
         WPqz4miEWVYeU3IWoHXbk5K8baf99T/KLQIvuqe2+pFdb1kBFF1XETB6P8Mnln+8PyFr
         ddWwTZZBNQD4qnpD+GikamKbbuc8GK/sU+w4LU9fUQqjVwrMT9rNLNDDw3Jl+c69xdKp
         DRvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bf6Nbj5cxRxF5T9bn4Fy/raNIgAK309Q68fjLTBm7eI=;
        b=5kPqJ9Ks2xs9Wh+LBjcoS/FvieZNfytHtg6wlpEAg7QY5ZEI54Fd8Hslh40HPhaaJK
         cQtIMAhzFjeoCeZh8P3Hx64asnBsVCatHSTvkBaUl+EVLVJ+ZyWXV+yQyp8zsmCYFRUb
         a1PgVpzBrOvgELKM+KlgGB4tPbIROHHo5lKU+jyoHENXhIbTxqonHF4Jd7mRFl7XuzLK
         hcyyrH6r5tUy8wCgv6vr4bBk3cNQb0HYUged5voSnp1Djuxa3zVSAlwOKUU0PPwZMiR5
         LGho8Qrt9iLC1rM/kKm0fvzk8IAqm7nngLNbhjU4Hi6Dn/IgUBoRZzXOY2wVjaH6LEdU
         oKNQ==
X-Gm-Message-State: ANoB5plPbpE6HKbdNYRw1hgKDrnX5Lo+3x6XGjzChlk2d0NP6RdToV1b
        fIfa4NvO5sDOaVxHfh8q6KxojA==
X-Google-Smtp-Source: AA0mqf5kKgi93Ya3eHrNU7WE2C68xMRTgktckuxGsCFsnTqA54QrDg9C+bwHtTwQXyWbIA+VbTq8Yw==
X-Received: by 2002:a2e:b550:0:b0:27a:273:eb51 with SMTP id a16-20020a2eb550000000b0027a0273eb51mr672981ljn.485.1670228246336;
        Mon, 05 Dec 2022 00:17:26 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id a11-20020ac25e6b000000b0048a9e899693sm2057639lfr.16.2022.12.05.00.17.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 00:17:25 -0800 (PST)
Message-ID: <a2458e6a-6b19-cd67-2b84-5cef6388e011@linaro.org>
Date:   Mon, 5 Dec 2022 09:17:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH] NFC: nci: Bounds check struct nfc_target arrays
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>
Cc:     syzbot+210e196cef4711b65139@syzkaller.appspotmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Ilan Elias <ilane@ti.com>, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20221202214410.never.693-kees@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221202214410.never.693-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/12/2022 22:44, Kees Cook wrote:
> While running under CONFIG_FORTIFY_SOURCE=y, syzkaller reported:
> 
>   memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)
> 
> This appears to be a legitimate lack of bounds checking in
> nci_add_new_protocol(). Add the missing checks.
> 
> Reported-by: syzbot+210e196cef4711b65139@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/lkml/0000000000001c590f05ee7b3ff4@google.com
> Fixes: 019c4fbaa790 ("NFC: Add NCI multiple targets support")
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

