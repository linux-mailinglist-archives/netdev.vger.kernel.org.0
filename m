Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CE36B1E80
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 09:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCIIpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 03:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCIIod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 03:44:33 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A50C199E1
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 00:44:31 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id a25so4137248edb.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 00:44:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678351469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MjlA6uCufuqlZrfEKLJAcU79DaDC/XvsK8BuSRfBJ7g=;
        b=h9RXhYo7aj6JCf1dnu77xoa+YvR00ajmZOZ4DclnWAciRLuDF5Ac1HlTOZl76UnEUk
         014tlZJV3VVXqYzbN72NdRABr1fC9AOTe8gRJA1RwOOAsB+kcJgdT78FeuqeY2WqVesS
         82t0SMtsvS+R0qMsccSaQa4WQxNnSCXdww6niEEeVeqUlpchJAQXpoHPWJiFTstipzV1
         y5xZ6KdwinQkLqqflnKeNpboyBMed5QzlOALhfONbFyTMSA80aDG1seWOf8WbA+VC/9D
         YfJMJ0Hf9L9sqhBh5Gvy0xVJMQDSk/qCNKtFiKxBvVL8Dt+fT3sAMwVX1C9x5ZCkq0oE
         cHNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678351469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MjlA6uCufuqlZrfEKLJAcU79DaDC/XvsK8BuSRfBJ7g=;
        b=IO6CN+c8Ck4SKLW8bAzpC9+Xlbl0bU8o5e/p2kbP8d27r5N3VjSaLf+t/imvqMRxpv
         zNRLP2Nu4YB0gSmWvd2mcWKOaJGktbJyeYUV3k2wSlIYnO1T2bSgsufMrr/SNELfiiYm
         E4I5ueqh6U0Vyi58SI9J28TxosoDnDdcJsOgfhGDXFerXSfRcXOGDVQz3osHW9yHdWA1
         Wg5To+DvGhYP90qiL0zg5+czBpvPgnBwNxFjzwUlfkeI4YKFaZkNglgPnrhV3anTpjIb
         RzF4Sw2cTmQsftZfKJTjSG4GKov7qBfJ0gSvjxCMXqIzcSPz/3ReFHfQYYnvHrS3hq4P
         OVPg==
X-Gm-Message-State: AO0yUKXkZd2ChC/Ub9/dU+UNp+hdm9fBlL3za9+XcZl/fVi2URqeg2Gs
        RFnTxkIgLOKCvPovYoPRO0jAvQ==
X-Google-Smtp-Source: AK7set/alrx+x5n4OdtSHE1779Y3dliU0rVmShvw5s0eIwOOfaNDpNwIQ8mPQP7r5uM4tjmRWILVKw==
X-Received: by 2002:a05:6402:6d2:b0:4af:51b6:fe49 with SMTP id n18-20020a05640206d200b004af51b6fe49mr23544903edy.13.1678351469660;
        Thu, 09 Mar 2023 00:44:29 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:7ee2:e73e:802e:45c1? ([2a02:810d:15c0:828:7ee2:e73e:802e:45c1])
        by smtp.gmail.com with ESMTPSA id y4-20020a170906524400b008d71e08c78dsm8434987ejm.81.2023.03.09.00.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 00:44:29 -0800 (PST)
Message-ID: <9af4b615-8aa3-097f-e82f-96ceb526529f@linaro.org>
Date:   Thu, 9 Mar 2023 09:44:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, nsekhar@ti.com,
        rogerq@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230309073612.431287-1-s-vadapalli@ti.com>
 <20230309073612.431287-2-s-vadapalli@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230309073612.431287-2-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2023 08:36, Siddharth Vadapalli wrote:
> Update bindings to include Serdes PHY as an optional PHY, in addition to
> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
> Serdes PHY is optional. The Serdes PHY handle has to be provided only
> when the Serdes is being configured in a Single-Link protocol. Using the
> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
> driver can obtain the Serdes PHY and request the Serdes to be
> configured.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

