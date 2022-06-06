Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2853E7A7
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234255AbiFFKqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 06:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiFFKqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 06:46:15 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA83D02B8
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 03:46:11 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id me5so27580001ejb.2
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 03:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=GPYQ+AuyiK9k5AoDNUEqPMRN9dkEbEVU3yU8yAlgQoU=;
        b=BEv/JTxRgpGr7BGlfYF0U0qsD54SzLKZzQkeX5W/aGHpqjBXxHNmd0E4Gj5UVWAJyX
         BDYIhO/7JRo43hEmkPXy/6XwVNk/Jb7jJx8KkBtEiyqGRjrDacUR1ZMjjSDd50K+1rHo
         hM7ihbV1mYd3vwkKEMGEvuLCMeAIGPNrND5jrOwTgOsT3XzOLqql8lOVC1kUi4bAgVgF
         NQQuzxXQzxDeAQqgAZuS8Vw1TDlqpI4/F3Yje1H0tUCsxRKr2tNfMGSk+7TN/hZbVByV
         WAv15G7nbkKPF0Uu3oGPvIamY+2p8Ek6iCmbOoyzbS7svPnnVHsdgwjPE6neMlakC+tz
         Np1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GPYQ+AuyiK9k5AoDNUEqPMRN9dkEbEVU3yU8yAlgQoU=;
        b=TIDHyf/T7QgXnLxUZf8V4bnoukRdH0Rxd9LYSxzPiaZUpWXQnoZF6C8aSafYpev3lN
         2qss/2d4M81A48MK++3kH0WAHoxklbAeHPnLjGqDzStLQ8MP6pjuN8Edq4soxwKaKqkk
         rZQ5Yvvo5CfdM4qDMBOcJwM7ENS5j7ma8qMgUYHrsWtUY5ixHUQyTqGB95t4ycdAghsF
         SWH5t6Fy4Pn/N8URIguwSpo8nWYKO0gnzXOpXoZna9LuV7P/G63yvjj70OcXCkMs2fY3
         1l0FhcCg+ra72R/0EQEA9CM8z4gwJ7jwu+kPexPy5/BpCR48hjSK8ENCl035jRMA6mLO
         MENA==
X-Gm-Message-State: AOAM531E1yla9T6RyUD7W6bnVYMVregg25lYgSO7+YYTWsYIwt0/8i1D
        SNRHrbqV5N0X3ixQdGVSOW7O/A6OHqPDgQ==
X-Google-Smtp-Source: ABdhPJw3Gcs+m6/c2jbbElb142U1e3voZcEH6hO7Gp5nRMsTCw9B4WCDP0CMjSTAGUBINsW4ooXnqw==
X-Received: by 2002:a17:907:60d4:b0:708:850:bc91 with SMTP id hv20-20020a17090760d400b007080850bc91mr21580631ejc.102.1654512369943;
        Mon, 06 Jun 2022 03:46:09 -0700 (PDT)
Received: from [192.168.0.181] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id c24-20020a056402159800b0042617ba63c2sm8422723edv.76.2022.06.06.03.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 03:46:09 -0700 (PDT)
Message-ID: <80637186-e3ef-14c1-78e5-bfa6deec595a@linaro.org>
Date:   Mon, 6 Jun 2022 12:46:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] nfc: nfcmrvl: Fix memory leak in
 nfcmrvl_play_deferred
Content-Language: en-US
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220605081455.34610-1-ruc_zhangxiaohui@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220605081455.34610-1-ruc_zhangxiaohui@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06/2022 10:14, Xiaohui Zhang wrote:
> From: xiaohuizhang98 <ruc_zhangxiaohui@163.com>
> 
> We detected a suspected bug with our code clone detection tool.
> 
> Similar to the handling of play_deferred in commit 19cfe912c37b
> ("Bluetooth: btusb: Fix memory leak in play_deferred"), we thought
> a patch might be needed here as well.
> 
> Currently usb_submit_urb is called directly to submit deferred tx
> urbs after unanchor them.
> 
> So the usb_giveback_urb_bh would failed to unref it in usb_unanchor_urb
> and cause memory leak.
> 
> Put those urbs in tx_anchor to avoid the leak, and also fix the error
> handling.
> 
> Signed-off-by: xiaohuizhang98 <ruc_zhangxiaohui@163.com>

This name still does not match your name used in email.

Best regards,
Krzysztof
