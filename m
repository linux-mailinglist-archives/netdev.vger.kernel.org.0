Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7C567C7FB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjAZKDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:03:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbjAZKDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:03:51 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577AE6601A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:03:49 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id e19-20020a05600c439300b003db1cac0c1fso2903368wmn.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1f4VhC6BSvSQ+e5t5OrJSoX9lSlfxjIbZ7RXVnsqUl8=;
        b=l2Nr52HOCvPddY5X06qLICnZNj+//HDoBz6gyGIEbnnYFxlQi5utN9oMlQnWU4atsO
         X7RH5+BGEG4/y/mhunSLzgHfZ3WZoA3H46mwW571mYY2Z0gk1K988++NO5UoT+C08ltb
         MA2ixWaMC+5t7HFIeM672wXMOEVtU5K8W0kW0DgOwpOP3wav4IeKIq+1MtCQ7QR4Hjve
         Fz/oHZhV2/yEBoQ7BJzLXTccVDEidZMYHDqgky8Xy8GA5pJFSym66LwvqjaiZ1CafuHk
         XMj7tqMjIPq7f63yqMidoOoo+UN6kDa0ioreX/YVk6AxiP1AroZ00nHkS77HPg8SMka9
         uuzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1f4VhC6BSvSQ+e5t5OrJSoX9lSlfxjIbZ7RXVnsqUl8=;
        b=Bo+dTcs6TvXMpC4K5Jn3uWBaeGArDGEmJtFH6SLEDW3IkoxNAIacQbHEYc79wY3BO/
         4xE0gW9uWrJ2HzaP6e4gH7ugtguG9BNVS+SIcu9euy0sgm7mx6AtcKrT4gaEeSjC+yRB
         8beVA3UUO6AQHus+3iAQB1Sl9B3PXVQlj4YVdB0P3lyuAm/6hG37tfO6umsHYCf0Hx1l
         x1UkDk7DW5hcZxOYG1FgKfQjf0ybRcZ7ww5ZKknAIjLH39JEkbq8BQwvDbKNrNUAGd8p
         AafU5BSrypH3n7t+qGt2HKhkuGJmD1FRiZRhMxd0txfV3CRI37Nx4juPbeu5hMuLNhfB
         7eaQ==
X-Gm-Message-State: AFqh2kptgeprLID42r2fBNQBnMK+/87ZFwBTQjTZ3FAm+eWZmCWjn2pI
        MhL9G7gQhUCriaUau9Ne2j/6EA==
X-Google-Smtp-Source: AMrXdXtNoLKYwDxA+EFs+kUucwoNJxgfjrbFdIGPGi7iYFfbnIMch/yNQ7aFuf8KY3o9vZ6JFcOhhg==
X-Received: by 2002:a05:600c:468f:b0:3dc:c5c:b94f with SMTP id p15-20020a05600c468f00b003dc0c5cb94fmr10524314wmo.39.1674727427869;
        Thu, 26 Jan 2023 02:03:47 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id p24-20020a05600c1d9800b003dafadd2f77sm4749025wms.1.2023.01.26.02.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 02:03:47 -0800 (PST)
Message-ID: <7ca0f553-664b-19ce-4c93-e5fad4b71bfd@linaro.org>
Date:   Thu, 26 Jan 2023 11:03:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v2 2/5] dt-bindings: bluetooth: marvell: add max-speed
 property
Content-Language: en-US
To:     Francesco Dolcini <francesco@dolcini.it>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Stefan Eichenberger <stefan.eichenberger@toradex.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
References: <20230126074356.431306-1-francesco@dolcini.it>
 <20230126074356.431306-3-francesco@dolcini.it>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230126074356.431306-3-francesco@dolcini.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 08:43, Francesco Dolcini wrote:
> From: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> 
> The 88W8997 bluetooth module supports setting the max-speed property.
> 
> Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

