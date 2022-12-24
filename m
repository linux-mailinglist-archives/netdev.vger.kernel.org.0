Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E5C655A48
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 15:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiLXOKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 09:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiLXOKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 09:10:06 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93933D122
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 06:10:04 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id bp15so10455770lfb.13
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 06:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xRkQwgBe7HWm5g+rGsBSlZ8V1FHuzygC6ObFsMxF+Og=;
        b=HSMjPsGwp90bvzU0vk/VE/jN+FuWj4+OnsqNqWZ4+5udbnEeR/iLZM3slZ/NgCsJTh
         ecFd7zSIq6GDEXYvlgQYTagDYo/os0y832LEQps5EWQ79jJd0QJeA748FdQW92ANFLnn
         Te2KTLlgKhHXE/zpWa8k6YWHZOLm/jSeXu58k55bgl9z1EHxwfeXRwBlbRMjQAXLt+Pv
         zfjF52hR+Kk/2dZfS7C/3KHFIsDeVX6/dsZrzT5aVLmyBTNUDW6nK1RFMB9ZJ7Nwi6lZ
         jNxx3CcN1Ru60nreIFCRedQgjmWxpjFzvwioSHoeDx0gETArGrNBzXvAJnroktWdXQWb
         +E8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xRkQwgBe7HWm5g+rGsBSlZ8V1FHuzygC6ObFsMxF+Og=;
        b=wqJMFwGaPLSAk4DHSrxWhgMqMi7utBA6xWLHM8XG+bNrD4wmOFgXmULoLQILhwNb7G
         rLH2PsH4T9Cncr2rq86X+4Xqn6lTr6k7TmYkj8K27e9HisKbPc4VbkcgWTdVz9PyTRBy
         O7qXsBSWymqkQXP00IpguHeHH/xZo8bV04ktrTgYacb+wXLXMN5zwMPPOkUrwqJXYWa0
         X6vpeBqQBphy6cLvrH9X5FgCj+30xATYA9j2YUzszbA8f9givMlAOGQ9Om+yrxF90+R6
         PhOpSMn6SN95QmH+nPTh5kELGUmbCpgkHyb7FbJDTHHTq8rXnWgoQ2dOIiOndRrBUxy+
         H/Iw==
X-Gm-Message-State: AFqh2kpdQYqUM7UUPyRkGm6+3D6ErUf1HyxbjzyAMKtpqLPLer4QkL9k
        Tlj7VIkDpsvVVuXT2LV37HGJEg==
X-Google-Smtp-Source: AMrXdXuXxTY+4fe+gJq0r10sxB8QiRd0M+PyK8Yqf8FdgddSN8TzYACAFRfCCUoADbN1gDdMxphz2w==
X-Received: by 2002:a05:6512:1582:b0:4b6:e494:a98d with SMTP id bp2-20020a056512158200b004b6e494a98dmr4464218lfb.44.1671891001257;
        Sat, 24 Dec 2022 06:10:01 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c19-20020a056512075300b004b53eb60e3csm690306lfs.256.2022.12.24.06.10.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Dec 2022 06:10:00 -0800 (PST)
Message-ID: <e9bcf47b-f48c-60c8-4747-36fc0f88f39d@linaro.org>
Date:   Sat, 24 Dec 2022 15:09:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCHv1 linux-next 1/4] dt-bindings: net: rockchip-dwmac: fix
 rv1126 compatible warning
Content-Language: en-US
To:     Anand Moon <anand@edgeble.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        David Wu <david.wu@rock-chips.com>
Cc:     Jagan Teki <jagan@edgeble.ai>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20221223132235.16149-1-anand@edgeble.ai>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221223132235.16149-1-anand@edgeble.ai>
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

On 23/12/2022 14:22, Anand Moon wrote:
> Fix compatible string for RV1126 gmac, and constrain it to
> be compatible with Synopsys dwmac 4.20a.
> 
> fix below warning
> arch/arm/boot/dts/rv1126-edgeble-neu2-io.dtb: ethernet@ffc40000:
> 		 compatible: 'oneOf' conditional failed, one must be fixed:
>         ['rockchip,rv1126-gmac', 'snps,dwmac-4.20a'] is too long
>         'rockchip,rv1126-gmac' is not one of ['rockchip,rk3568-gmac', 'rockchip,rk3588-gmac']
> 
> Signed-off-by: Anand Moon <anand@edgeble.ai>
> Signed-off-by: Jagan Teki <jagan@edgeble.ai>

This SoB order is a bit unexpected - who is the author and who is
sending it?

Best regards,
Krzysztof

