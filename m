Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE96BC629
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 07:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjCPGhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 02:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCPGhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 02:37:14 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC4FA90BE
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:36:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z21so3508701edb.4
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 23:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678948617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=av/tqDDKKhxpDzt2MvIK/BO/pYsWdyny3iBroUh8N5w=;
        b=HvwtSh7Q+hEijwXrOgOErle3K6lILbfTzZLTN8S0W4xkLKWdLQ9XS/UwBD6j1K4sFd
         BjOQxFMrvc/jSJcz8ibY94S7AVV/I5bA9pIRLgvynSzr5CPzHm0sg7dAnZWj76uYph4n
         FfT3spDyTHH76PkSHXTJI76epTsNdh6fQDH+P4mF/R22lQEdDDXTbDIv8HA2IxlnxSmV
         737QXuGjA9Q2xVPpmZv/uI0YnuQPFiNktWsfxLT4S0qyisOg3QSB8Ug1fOdPXaLrXrr2
         HjIWoVoCjV9pBa7DNmti1NDWjAje18reN64myG0MQlBfbqzP0fhPbZw4EfxxcErh/Rcv
         E99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678948617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=av/tqDDKKhxpDzt2MvIK/BO/pYsWdyny3iBroUh8N5w=;
        b=y2PCbyrHqKnGvIlt0WBZW93d4xPRBhCDl2a8xH0AlhfqvSs7CYeeoZ/QlBA62ywZrc
         k8kM+++oaizNuEDED1WNADzO0Jejx5WBCfBnbf07gF03JTqN5s1yM4NIbcBXTIy3IJ5r
         7pfaUB8f9m+OkLh34yexskMIOeiUa8BKr2DG0hOBQjNK2L8xgyXBrhvtqizfZfUtJnkU
         P1PdaOUbOmaDT/lD4yLh+nRHyn49/gpQQ8pTacZxdkPEumdC8HEmW/yKUSmg+ZoURIf5
         z956LXshQ8yXV1/EmZc+3hSxZOTzrQy3gPZk+R98DI8eL9fzJpbtJzpb5etw17vl/sh2
         1p4A==
X-Gm-Message-State: AO0yUKWRaKJi1fA5NsItMGOXDxgjCpFe8NGUuo6MtRYxPGdFsL+tDErS
        zQ85RQxWx9MOTufvf/TPNj6rCw==
X-Google-Smtp-Source: AK7set9U6K671sZ1LAjH8kt45mPJjlYKj/AWN5njbDj/sltxWQWaw/4J2Kj+ynE5o2nniFzRLVqA+w==
X-Received: by 2002:aa7:d88f:0:b0:4fb:6796:14c0 with SMTP id u15-20020aa7d88f000000b004fb679614c0mr4959482edq.22.1678948617242;
        Wed, 15 Mar 2023 23:36:57 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id h1-20020a50c381000000b004c0c5864cc5sm3353074edf.25.2023.03.15.23.36.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 23:36:56 -0700 (PDT)
Message-ID: <b168a98c-686d-9908-18af-c4b4915be92f@linaro.org>
Date:   Thu, 16 Mar 2023 07:36:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH V2 3/3] dt-bindings: pinctrl: k3: Deprecate header with
 register constants
Content-Language: en-US
To:     Nishanth Menon <nm@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Sekhar Nori <nsekhar@ti.com>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20230315155228.1566883-1-nm@ti.com>
 <20230315155228.1566883-4-nm@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230315155228.1566883-4-nm@ti.com>
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

On 15/03/2023 16:52, Nishanth Menon wrote:
> For convenience (less code duplication), the pin controller pin
> configuration register values were defined in the bindings header.
> These are not some IDs or other abstraction layer but raw numbers used
> in the registers.
> 
> These constants do not fit the purpose of bindings. They do not
> provide any abstraction, any hardware and driver independent ID. In
> fact, the Linux pinctrl-single driver actually do not use the bindings
> header at all.
> 
> All of the constants were moved already to headers local to DTS
> (residing in DTS directory), so remove any references to the bindings
> header and add a warning that it is deprecated.
> 
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Link: https://lore.kernel.org/linux-arm-kernel/71c7feff-4189-f12f-7353-bce41a61119d@linaro.org/
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> New patch in V2 series and we expect to remove this header after a kernel
> rev.
> 
>  include/dt-bindings/pinctrl/k3.h | 7 +++++++
>  1 file changed, 7 insertions(+)

This should go to the same branch as DTS, so not pinctrl tree, to avoid
warnings.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

