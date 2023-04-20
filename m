Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054436E98B6
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 17:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjDTPry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbjDTPrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 11:47:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17417E41
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:47:51 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dm2so7375085ejc.8
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 08:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682005669; x=1684597669;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ii0rJDmD6wGcfR9R86o46jWR7Sx2THT0mFJ55bpx/lc=;
        b=XK4cAxcm9V+tmT5sYaMjsisB8fWSfvuQ3Whf7RuncKhI7VhoZ4bCjDetHGvfTfIm5f
         TvT4iDeOzqgdC7mdtXMmOezBUtCgt6BrOOlodawLenZ6trC1ZceJ6OfZV9CV5NpBxRXx
         k3+pXE/yBt55rJ7IGr13BDleUvH2P3i8F4cIhwVd30YHPkfVKjEIFZIj39cl8zk+9AVx
         XvhwAiQr9lz0VL+itTJCDEoEofnBo2a7IfNvV/DD6vNAodHU9yIR4vyU7Gldv8cCwxdm
         aRH8ewKOrL/gfzSc7kCFKR3paTDTKNOG2/Hwho1K/uFh38sH3Lv7q1roYKsx54I3RTP0
         r5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682005669; x=1684597669;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ii0rJDmD6wGcfR9R86o46jWR7Sx2THT0mFJ55bpx/lc=;
        b=gjTIn+QhbiOgwE5AF56hHPQJiG3RLGZjnUriMDww7vhX2CPjFIodkJwSxz6ZOXITqV
         6PmZcB9xgVE24wxtaOrqbpZ7qDMLQNzN29IUvyAhzapr1y2Q6HNbX0oO+BOTEjOF7BOC
         obqgePerobBQ1oIyE2iyHD21BQNbQpvXFCzVX4HufsadailD/Uo2EFwUZPeB/6JJWSBS
         TtRge9zPniF228AOet5779OlD7xGV7stTHy4oNWKq2/BA+QAumoSt+pHy3j2fiDOVB/n
         eIxTLUwzMJLLjflzIHG7HyJL7U/WXTiesf077M1MM2jhZ8Kawkkc0X++v/kFOurBqpqU
         hKhA==
X-Gm-Message-State: AAQBX9czjLrxH/azyJjg72WAThwDqHJ+CUsE3YHqXboxbgGH4FjQ7IwI
        /jShob52mdDhTIlVM5yo9j/2cw==
X-Google-Smtp-Source: AKy350bigdojBVAu1yf8DpxqzPZ+1OFcdgyfRolFxaaBBS3Mmcpps74+3jkoTtBj2wvJL7j/Sn3gIQ==
X-Received: by 2002:a17:906:7215:b0:94f:61b2:c990 with SMTP id m21-20020a170906721500b0094f61b2c990mr2092604ejk.25.1682005669571;
        Thu, 20 Apr 2023 08:47:49 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:bcb8:77e6:8f45:4771? ([2a02:810d:15c0:828:bcb8:77e6:8f45:4771])
        by smtp.gmail.com with ESMTPSA id a8-20020a1709063e8800b0094e4684e5c0sm867274ejj.25.2023.04.20.08.47.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 08:47:49 -0700 (PDT)
Message-ID: <c7be28da-45f0-c743-9bd9-cfac2114f167@linaro.org>
Date:   Thu, 20 Apr 2023 17:47:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/4] dt-bindings: net: can: Make interrupt attributes
 optional for MCAN
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>, Judith Mendez <jm@ti.com>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Schuyler Patton <spatton@ti.com>, Nishanth Menon <nm@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230419223323.20384-1-jm@ti.com>
 <20230419223323.20384-3-jm@ti.com>
 <20230420-zoom-demystify-c31d6bf25295-mkl@pengutronix.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230420-zoom-demystify-c31d6bf25295-mkl@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2023 12:01, Marc Kleine-Budde wrote:
> On 19.04.2023 17:33:21, Judith Mendez wrote:
>> For MCAN, remove interrupt and interrupt names from the required
>> section.
>>
>> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
>> routed to A53 Linux, instead they will use software interrupt
>> by hrtimer. Make interrupt attributes optional in MCAN node
>> by removing from required section.
>>
>> Signed-off-by: Judith Mendez <jm@ti.com>
> 
> This series basically adds polling support to the driver, which is
> needed due to HW limitations.
> 
> The proposed logic in the driver is to use polling if
> platform_get_irq_byname() fails (due to whatever reason) use polling
> with a hard-coded interval.
> 
> In the kernel I've found the following properties that describe the
> polling interval:
> 
> bindings/input/input.yaml:
> 
> |   poll-interval:
> |     description: Poll interval time in milliseconds.
> |     $ref: /schemas/types.yaml#/definitions/uint32
> 
> 
> bindings/thermal/thermal-zones.yaml:
> 
> |       polling-delay:
> |         $ref: /schemas/types.yaml#/definitions/uint32
> |         description:
> |           The maximum number of milliseconds to wait between polls when
> |           checking this thermal zone. Setting this to 0 disables the polling
> |           timers setup by the thermal framework and assumes that the thermal
> |           sensors in this zone support interrupts.
> 
> bindings/regulator/dlg,da9121.yaml
> 
> |   dlg,irq-polling-delay-passive-ms:
> |     minimum: 1000
> |     maximum: 10000
> |     description: |
> |       Specify the polling period, measured in milliseconds, between interrupt status
> |       update checks. Range 1000-10000 ms.
> 
> From my point of view the poll-interval from the input subsystem looks
> good. Any objections to use it to specify the polling interval for
> IRQ-less devices, too?

Better to skip it, if delay can be figured out by driver based on
something else (e.g. clocks).

Best regards,
Krzysztof

