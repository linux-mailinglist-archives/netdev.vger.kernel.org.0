Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74376EC6AC
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 09:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbjDXHBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 03:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjDXHBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 03:01:42 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D7610C
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:01:41 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-94f3cd32799so732517766b.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 00:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682319699; x=1684911699;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cAMolMF/0A91B5GkAOKhgDLGZThujf5CyOxv40ltXw0=;
        b=J5lj6XRZGCkvCTcF7VnaYV56c40TbbkAkmFxrRXNDwdfZPsZuisqBUZWPmwZD6af3B
         Y8pe+xTQ2L2nYJrYpAzJ4ZZlWHEWlWHtGUUhe3g3mLjohIUfDEpieOkWGk+WrqpYnvbR
         uaf0M2ON09K6KIbkhzo4NJ7C9KQKaPB984mpJpUI+uLiQu7qFdadX3uij+4ktKkWs7Sq
         FhxILPn7Tcx28lko6wnyYKkO4r6Zb0JLLpcqwsjVoCdPbdG4x8UbV7eLy11Ty6KUnDv7
         +rq8q6NTyiyUGMdECysXQrhuGip8YzkeAgzZGf4nrHd9rgEDPdaSDTLTS5SCiTdAp+dZ
         e+hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682319699; x=1684911699;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cAMolMF/0A91B5GkAOKhgDLGZThujf5CyOxv40ltXw0=;
        b=EGC7ZsqPwWvwYiIzw48x9O8DU4Pnjb6qG74bGPooYzj+7lLAEijowZVteQvdgucELR
         RaMNW+gAikNlKoh+7V6qSypfSgKQGkyLz04y1lZ2/k1GkaTXRd2Rl+dxPlsvLkCd4/ma
         Pa4fGRenN3ibxb7FQWbsXZ4GHlQdf3VZl0cSQ9S2CWu/vYazn6svlc1CjGCyqTz1JUaS
         p51BcNXhqXnR/Eur2LKoXWfGVt0QZgyrZB7/3onB8b8OpWsoxPgC6wGiJkSM32xLDWyh
         uJZ4xIQysDWrlT924EqduIcQ3u+aJGrNrVzUV8KA+pqDTua5KckP8uWjBnlpBUugvdTr
         gTAg==
X-Gm-Message-State: AAQBX9e3IcKiWtEEzz3o6L310XaFE2ahzSN7fsNpA95/62ZzmCM7Iumd
        VJaZJVGoDTjpemOZ5EYou28/NmY+d5QLLTnXn2w=
X-Google-Smtp-Source: AKy350aDLD/mZWyW4UWiZOr+Tv9jOTXgUlnhG5JdEneUkzO4rI9t9amSpsZLJGzNXSZ6V4sTbrorkw==
X-Received: by 2002:a17:906:5904:b0:94f:928a:af0f with SMTP id h4-20020a170906590400b0094f928aaf0fmr8529727ejq.47.1682319699600;
        Mon, 24 Apr 2023 00:01:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:fcdb:bf53:d053:3a52? ([2a02:810d:15c0:828:fcdb:bf53:d053:3a52])
        by smtp.gmail.com with ESMTPSA id qp24-20020a170907207800b00882f9130eafsm5159020ejb.26.2023.04.24.00.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 00:01:39 -0700 (PDT)
Message-ID: <47e8113d-39ad-cf18-a763-89ee883da233@linaro.org>
Date:   Mon, 24 Apr 2023 09:01:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drivers: nfc: nfcsim: remove return value check of
 `dev_dir`
Content-Language: en-US
To:     Jianuo Kuang <u202110722@hust.edu.cn>,
        Thierry Escande <thierry.escande@collabora.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Dongliang Mu <dzm91@hust.edu.cn>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230424024140.34607-1-u202110722@hust.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230424024140.34607-1-u202110722@hust.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/04/2023 04:41, Jianuo Kuang wrote:
> Smatch complains that:
> nfcsim_debugfs_init_dev() warn: 'dev_dir' is an error pointer or valid
> 
> According to the documentation of the debugfs_create_dir() function,
> there is no need to check the return value of this function.
> Just delete the dead code.
> 
> Fixes: f9ac6273e5b8 ("NFC: nfcsim: Add support for sysfs control entry")
> Signed-off-by: Jianuo Kuang <u202110722@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

