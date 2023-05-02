Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190586F3DD9
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 08:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbjEBGxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 02:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbjEBGxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 02:53:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B13B4EE6
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 23:52:31 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-50bcb229adaso2070216a12.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 23:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683010350; x=1685602350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qp50p2Ws7bkjK436XWAEC92FxJZeHIdYYG8HIYuRl1w=;
        b=Y5pd7ipHf5khD4XXKqFvFfxPCqEek3mtfmLwTKDEHg7xHWpfqhktBQFGAo9UHWTgOv
         3zdZU6nD1TC58buCWqJqP0aLcYi594gaFF1xeJ/KGUYh04G3wDTO0HYvAN15XuSCYxyR
         kvdu20eomVrXxX9MVwcFM3uZGjOENIcCEhq/vCnK7cByoL+Q8md6dV1FHVe1kthW7V/2
         Y8kvqlu9h7Jce79Oe4Y7/ZrnnYv9Plkvi4ePgBJQkYAy+gVs2+x3qPVlanp2fqnKkuHO
         Dt/57xMiYLdgxaZlq7/+ftvHlJaqsCOEwCEU6R4+mAiBGWb7lDakeLjwcir5pzHnAsNp
         KvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683010350; x=1685602350;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qp50p2Ws7bkjK436XWAEC92FxJZeHIdYYG8HIYuRl1w=;
        b=M4GEqMbDng4KLBXCQkyBGJVX9YfdGbtCxnmwSFlcnAQTCtO5Zk1vlNTRqHwYZBDv6S
         djphrzE7O8zDiC5XHf4SKyhR5xuCFWlzJLR7JJNLKbmzvh6YjwZ+h0Uhaihtc7jFFi3c
         z4Gd2sg4r0CPN+D5VdmO58ocKwTAUD0cQ3Rvcw8WVXOWlKtYstFRNn2OIsbATEF0cGs5
         KykFKk7GEHYDvl3jc0a6ipHwAkj9sriHjYX/WX4r8Aj90DeJ/ql2fMRCxzh7OGU1sAPX
         cDjQ5vj8UwV4JwEMlNjh0gi0UJUzaFOLTbiPNJjP48axmbjzYTgocvuZT7pruVqyv6B/
         8uWw==
X-Gm-Message-State: AC+VfDy0U4h3PM1K3AYskXSeCRbpKQUK00ZmHsSYoc55AMhWucVcnfzU
        ZzSrEKITEQNkp3wa9NlKgcivgA==
X-Google-Smtp-Source: ACHHUZ4gBYHT+yHlP2EQUafOqVWSMCUgol+Ynv+bGX1fRtxeQk2R3Ue7g8hGpMWN1q2Xo43rvnlgZQ==
X-Received: by 2002:a17:907:3f9e:b0:95e:d74d:c4e6 with SMTP id hr30-20020a1709073f9e00b0095ed74dc4e6mr15909803ejc.25.1683010349936;
        Mon, 01 May 2023 23:52:29 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:bafd:1283:b136:5f6a? ([2a02:810d:15c0:828:bafd:1283:b136:5f6a])
        by smtp.gmail.com with ESMTPSA id hy13-20020a1709068a6d00b009606806b2fesm6457878ejc.217.2023.05.01.23.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 23:52:29 -0700 (PDT)
Message-ID: <c3395692-7dbf-19b2-bd3f-31ba86fa4ac9@linaro.org>
Date:   Tue, 2 May 2023 08:52:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v4 0/4] Enable multiple MCAN on AM62x
Content-Language: en-US
To:     Judith Mendez <jm@ti.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Simon Horman <simon.horman@corigine.com>
References: <20230501224624.13866-1-jm@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230501224624.13866-1-jm@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2023 00:46, Judith Mendez wrote:
> On AM62x there is one MCAN in MAIN domain and two in MCU domain.
> The MCANs in MCU domain were not enabled since there is no
> hardware interrupt routed to A53 GIC interrupt controller.
> Therefore A53 Linux cannot be interrupted by MCU MCANs.
> 
> This solution instantiates a hrtimer with 1 ms polling interval
> for MCAN device when there is no hardware interrupt and there is
> poll-interval property in DTB MCAN node. The hrtimer generates a
> recurring software interrupt which allows to call the isr. The isr
> will check if there is pending transaction by reading a register
> and proceed normally if there is.
> 
> On AM62x, this series enables two MCU MCAN which will use the hrtimer
> implementation. MCANs with hardware interrupt routed to A53 Linux
> will continue to use the hardware interrupt as expected.
> 
> Timer polling method was tested on both classic CAN and CAN-FD
> at 125 KBPS, 250 KBPS, 1 MBPS and 2.5 MBPS with 4 MBPS bitrate
> switching.
> 
> Letency and CPU load benchmarks were tested on 3x MCAN on AM62x.
> 1 MBPS timer polling interval is the better timer polling interval
> since it has comparable latency to hardware interrupt with the worse
> case being 1ms + CAN frame propagation time and CPU load is not
> substantial. Latency can be improved further with less than 1 ms
> polling intervals, howerver it is at the cost of CPU usage since CPU
> load increases at 0.5 ms.
> 
> Note that in terms of power, enabling MCU MCANs with timer-polling
> implementation might have negative impact since we will have to wake
> up every 1 ms whether there are CAN packets pending in the RX FIFO or
> not. This might prevent the CPU from entering into deeper idle states
> for extended periods of time.
> 
> This patch series depends on 'Enable CAN PHY transceiver driver':
> Link: https://lore.kernel.org/lkml/775ec9ce-7668-429c-a977-6c8995968d6e@app.fastmail.com/T/
> 
> v2:
> Link: https://lore.kernel.org/linux-can/20230424195402.516-1-jm@ti.com/T/#t
> 
> V1:
> Link: https://lore.kernel.org/linux-can/19d8ae7f-7b74-a869-a818-93b74d106709@ti.com/T/#t
> 
> RFC:
> Link: https://lore.kernel.org/linux-can/52a37e51-4143-9017-42ee-8d17c67028e3@ti.com/T/#t
> 
> Changes since v3:
> - Wrong patch sent, resend correct patch series

Sending patchsets every 10 minutes does not help us...

Best regards,
Krzysztof

