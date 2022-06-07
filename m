Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9278253FF39
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243213AbiFGMox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239633AbiFGMow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:44:52 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F52A49251
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 05:44:51 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id q1so34968482ejz.9
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 05:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=uQiTgrKp2j5ylnfr6ZLy6DqHacfk0nHCMZVLuHI5zrg=;
        b=TZbf5La9krEQsFLerRcSFIYX1Q/ggP05UNSLG2d2k6lUkLydtbDJvUuwIh686qn5Bn
         fWT4JHjy0OK5221hYNKq9rlsA/UIpRn9VvOlX3NIMdGONUqodV+I1ycFDv/aoE9qiTFp
         7wP9Qi9tgguDfaqBYWxpWWhU1B6TsTwPPrIXuT0D8aauT6O4DUyxg3DvOu4O0b98K/Rc
         vqPwXBhZN2tP6xAckRMggsTbmwrSeEC8zmI2VenpslEuL6StTBuCncDQEQf3Kw/YPNgh
         /8Igi0JtbftgiKmAqJt3uj+8L6ErFttxRBfc4yCUDEvRBwXsV0OylV8f45XtvpIAsLaY
         TSLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uQiTgrKp2j5ylnfr6ZLy6DqHacfk0nHCMZVLuHI5zrg=;
        b=Yc2/1IeWtLFY2bf8qug//QDVXPqSesoo2BL0A/AEgyp2hR20fB0Oux1g9F+D4kzGAl
         dRHtaqpIY2EoxjKjZM8TFr/bnqobvIE0up5uA/qC/dsNimAusbAEySZ+fa926TK74tSH
         CxkAyde/h+XsGVkRe6yB/MeWcfXb6LMZGvPlKLyL0tZ6eMhsnuKRGdJ6efe5DScZktv1
         ELfZrWzfzhBsw8opgSgHTJatkLxI/BfGvd4touh2P5Yjf3z8RGt+i/5UAJKVt11sq7Z5
         PfnKP4QG9mZxXGmMWa7mCHq1MzwEeUUJoJN7MoaZj/MlNlE8kplWrcG/eOCWD9kkSNLZ
         c1gQ==
X-Gm-Message-State: AOAM530PqRvM/vA1/sem1+w++dEB9sUNpfIe1y6OIxv8/o+pOtNWPqcT
        KOwLBSOF5RqOIzdOU+kY8ZI4tKBXQdJeog==
X-Google-Smtp-Source: ABdhPJzKh0VsB6f0Ke44cBMK6Efz5LUw/feuZP1UFv8kvNQc1NaRuCcTlz+/ibqdTUZrOV7TSosCkQ==
X-Received: by 2002:a17:907:3e09:b0:6ff:20f:9b1a with SMTP id hp9-20020a1709073e0900b006ff020f9b1amr26736563ejc.679.1654605889604;
        Tue, 07 Jun 2022 05:44:49 -0700 (PDT)
Received: from [192.168.0.184] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id h15-20020a170906110f00b006fe98c7c7a9sm7552672eja.85.2022.06.07.05.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:44:49 -0700 (PDT)
Message-ID: <aaa0979c-abd0-b3cf-ac3e-3813aaa84185@linaro.org>
Date:   Tue, 7 Jun 2022 14:44:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/1] nfc: nfcmrvl: Fix memory leak in
 nfcmrvl_play_deferred
Content-Language: en-US
To:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220607083230.6182-1-xiaohuizhang@ruc.edu.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220607083230.6182-1-xiaohuizhang@ruc.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2022 10:32, Xiaohui Zhang wrote:
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
> Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>


Best regards,
Krzysztof
