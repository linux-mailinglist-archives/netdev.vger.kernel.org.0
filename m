Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50EF4EFFF5
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354016AbiDBJHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 05:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352788AbiDBJHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 05:07:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686051AD1F8
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 02:05:53 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id o10so10431193ejd.1
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 02:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=i56pZTJZbMTqJ1szGeJrJw33a1B1pMeoG3pE9Kf8CoE=;
        b=F63lJcwWjNo/5C0WBqJeb8nzuPzlNouA+lK519Eh8ZcNcqD4ibCPHb5+vjetL+Tbf/
         rFE2k5K8EeTfHnSrXST4uIruK6wm38GADoqnTEKN3XAu52ngOBkpSjQ4NoxookSSK25t
         bm0OToc+orTmsSF69ID/Oi+aAGuk3mXby36z7tYA41006L2bvcAX3w9jb0hBsZtxfM+y
         bLQkMQNsffJsUtrFfmrylZREbz+boVwFFIztfIhspGes5j3qo3Yv6CBR2j0MC8j+6pus
         kr4VTzkH3bUUfs8VpiyRkOnbuMkoPbzGHLiCIDf4Jb3S/GdKaxFOgYjH8k0ojP596RkQ
         G/xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=i56pZTJZbMTqJ1szGeJrJw33a1B1pMeoG3pE9Kf8CoE=;
        b=nVez4rxfV70MaT5gra4R4S7latlTWvh6voBG8/yOe2m6Iij6GhqxENBhxBx1vm55Ix
         PXS1Kz8GrRwkmCIBKp767ia9BnSXAsLpblEQi285ZAIFCu3FW7Ju2h7jtjKC1v+qV8NH
         VdjzVQosHUgYsxTVv9JI8cR9ctvPblS+pWWEpJqUCI7XlBMZJrJ+RooRwH3m+Kj0WhRd
         cUMIX0AXY+XRdlXObDux5DGBtsPNZtf/kB7x6fs03dcB4uDK5efppIE9BFJbTLFMfSaE
         f/63+zp7Yq96GpRyttzn8OA+X8T5pJnCb0jYzG7Wz3DJX37OP36nVM/UBcMrOx93oKy3
         fbAQ==
X-Gm-Message-State: AOAM533eltLLewEptmDEaiC6Zk+ioaVjX93VGSsUY/5dfg0sDc6jyEAd
        U6Hl/SvYoA5dsJYOVlPVji5xiME2sXy28/rZ
X-Google-Smtp-Source: ABdhPJxFlKynEhZo1xH9XqGiMkbguuq6peG/cHYUSjEGZm6jWFx/LRwsY6MsOnEA9vA5TeLKFpreDA==
X-Received: by 2002:a17:906:16cc:b0:6ce:e607:ff02 with SMTP id t12-20020a17090616cc00b006cee607ff02mr3074551ejd.418.1648890351859;
        Sat, 02 Apr 2022 02:05:51 -0700 (PDT)
Received: from [192.168.0.170] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id k12-20020aa7c38c000000b0041939d9ccd0sm2156777edq.81.2022.04.02.02.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 Apr 2022 02:05:51 -0700 (PDT)
Message-ID: <e296bd4a-2f52-390b-c3a0-b73e4449f097@linaro.org>
Date:   Sat, 2 Apr 2022 11:05:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 3/3] nfc: st21nfca: fix incorrect sizing calculations
 in EVT_TRANSACTION
Content-Language: en-US
To:     Martin Faltesek <mfaltesek@chromium.org>, netdev@vger.kernel.org,
        kuba@kernel.org, christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
References: <20220401181048.2026145-1-mfaltesek@google.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220401181048.2026145-1-mfaltesek@google.com>
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

On 01/04/2022 20:10, Martin Faltesek wrote:
> The transaction buffer is allocated by using the size of the packet buf,
> and subtracting two which seem intended to remove the two tags which are
> not present in the target structure. This calculation leads to under
> counting memory because of differences between the packet contents and the
> target structure. The aid_len field is a u8 in the packet, but a u32 in
> the structure, resulting in at least 3 bytes always being under counted.
> Further, the aid data is a variable length field in the packet, but fixed
> in the structure, so if this field is less than the max, the difference is
> added to the under counting.
> 
> The last validation check for transaction->params_len is also incorrect
> since it employs the same accounting error.
> 
> To fix, perform validation checks progressively to safely reach the
> next field, to determine the size of both buffers and verify both tags.
> Once all validation checks pass, allocate the buffer and copy the data.
> This eliminates freeing memory on the error path, as those checks are
> moved ahead of memory allocation.
> 
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Fixes: 4fbcc1a4cb20 ("nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION")
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Your SoB does not match sender's email. Please fix (previous patches
maybe as well).

> ---
>  drivers/nfc/st21nfca/se.c | 58 ++++++++++++++++++++-------------------
>  1 file changed, 30 insertions(+), 28 deletions(-)
> 

Best regards,
Krzysztof
