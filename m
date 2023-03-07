Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCBDD6ADA1A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 10:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjCGJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 04:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjCGJUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 04:20:06 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670BC86176
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 01:20:01 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cw28so49580564edb.5
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 01:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678180800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IzQo7ACRtABeHVtQ4D7zqYvAtCiwC9n8/XfqHD2Rxc8=;
        b=FSvUJkm4RPpLhAHF8QisYObMMowi0+kIX2o0u0RvT2huAi97xCjE0PfI6PwnO1QlRf
         Zl2Ppb2i2/nAIr4+v7y5FmgWyvChaOA/SY2y5vrYpUuzwXiWWfU9n8o3aIb3wBaZVw7V
         auGH9SwatTumL9n9cK6l6KJ/5w0ysUdQArFUSR/7DTUfeIYNY+wDjUWgqySK/vxAHNTP
         bP+/ZbWwXGFwmDQw72i7RT/fkpJuuzxixO5HwYh8KfF0M3+X9+fZ8rNcPj7tHVP2Nnhx
         iZF3QQC2Unf7B+8jrCJAeQsHfO3c6Fh2AdWZ9ioVRYBnWJXgT4eKkZpDooKRiPwSugdK
         xqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678180800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzQo7ACRtABeHVtQ4D7zqYvAtCiwC9n8/XfqHD2Rxc8=;
        b=vyij2VgYfCkA2U8ZEn71pXIoDiEE55UyM6LZv8H0E0qUi0xTxrOJ5cw/X2KDMDHe+i
         rbxzYjtYtLXVR/hWZO/59DXDV14A2fmzfDH65iCin+0yX1ccwYq4sQHrvc+TgDxiKqF3
         Gigv/yaF8DvtunvlRGlwalDLrhpDup1OSIhcKxmUc8PCQaHGUKwEKJDlCi7QMQJlGJ88
         7Hp55vBQdKK11fifrFAM6vkPPzND8CsCdrvRHXl5JZWvbYzJ54iwI2m1u1uujSTKxPjH
         yf3O2/Hy0zE/F7IweJfMrDqUQa61mmnQEBxhGMyd1vZrfBIrMrUVZiD2bI/n+osSfJf1
         IFxg==
X-Gm-Message-State: AO0yUKUTXX7ztkcbPHURw7ZX4oO6QlOCrN/LgapxwN0VZw3EotODM1WO
        Wy9Pz88J+7vxGoycY7R47+lvSA==
X-Google-Smtp-Source: AK7set98ksW9rs50yKitdSxLDce6QStPj3hvHEQeoO0MfL6r8ueGUAWtmey0LhC8oeipnH4yqo5uIQ==
X-Received: by 2002:a17:906:434c:b0:908:6a98:5b48 with SMTP id z12-20020a170906434c00b009086a985b48mr13239479ejm.40.1678180799975;
        Tue, 07 Mar 2023 01:19:59 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:5310:35c7:6f9e:2cd3? ([2a02:810d:15c0:828:5310:35c7:6f9e:2cd3])
        by smtp.gmail.com with ESMTPSA id v30-20020a50955e000000b004bf2d58201fsm6399243eda.35.2023.03.07.01.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 01:19:59 -0800 (PST)
Message-ID: <a81ee827-87cf-e7ea-8e91-e8d790a9984f@linaro.org>
Date:   Tue, 7 Mar 2023 10:19:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] nfc: change order inside nfc_se_io error path
Content-Language: en-US
To:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
References: <20230306212650.230322-1-pchelkin@ispras.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230306212650.230322-1-pchelkin@ispras.ru>
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

On 06/03/2023 22:26, Fedor Pchelkin wrote:
> cb_context should be freed on the error path in nfc_se_io as stated by
> commit 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in
> nfc_genl_se_io").
> 
> Make the error path in nfc_se_io unwind everything in reverse order, i.e.
> free the cb_context after unlocking the device.
> 
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

