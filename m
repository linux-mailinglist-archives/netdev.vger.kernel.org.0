Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BDE64E9F7
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiLPLG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:06:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiLPLGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:06:17 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9F530571
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:06:13 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id q6so2915887lfm.10
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nWwD7yi6dLlMGSUE/zB+/IBPn3bSJ7pcQB2OAC/RxMI=;
        b=t1mum5FsO1hC6xNYTKNoqOJKipNV7LXcIuH0929xhlqEtUM+n3Km3L8gNCZgCRB9eb
         CKrXaj5Vn6yykjAZSfjpMDwJ1oXy8SUf3GlXRhN/9Q3n6WtRl5pSAVcHLEkE2S1VQVpW
         lZi9rur9SvwotSewu+XAwwCZDzJc5zjyuGquIY95K3kx7FIGBHS2Q125GmQ/2AE+iZsP
         EvYqWVkvzc28aRdHk/T6Od4uhygUHkhV5Vtis1nVDzomH/rJcTTBtyVUG/VeHsTzc6sR
         VmZrf/x6jCXpTfn4GqYctUDqntucjM9vy5wxgujEc0Chff9eAjPpv4ign2sTr8t9pB2w
         qH9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWwD7yi6dLlMGSUE/zB+/IBPn3bSJ7pcQB2OAC/RxMI=;
        b=p6VxAD5LdSc6FupEoEppzSYLF8PzuvA4r6uBY6dIpDrluba+ZU89sgho/WLdYde933
         Un7Mznbf3pmms4sQ/cqrNxzv7wiaC19bP18dtGgujf7CQEbO1gSI235D9ZSeTPL4/9kt
         AOkaV67lQg0F2fVC3V7sQ42bVEVmx5ra5+YYrJoS9paG0ruE/36pWMdPWG1D8iWa7X3v
         o2GThbB6kExK0qpXN/KrQNaaeaVRbBsnSVTCdZl4J9A9WoewwHcShLWgRhdv1aQLZVtM
         Dz69Yp8NByv7sg6uyf4/r2YKhreOWhIjzir+A4fgEMzxslsZ+FNJNKvqSqU/1RXrSCvg
         HxGg==
X-Gm-Message-State: ANoB5pk5q9dG4ujZC81raJZNrJv4c9zp+RO5dGUDbe+lqm7Y3afvPR8Q
        6VfQUxgjSayah+rWj3Ah+p3xaw==
X-Google-Smtp-Source: AA0mqf4wZV02mHd6JVlBfvVxPzAtzLRWGiIk5hcgUumZmOSbhTAExJo0O+ngKichPTF35vO6AkHA1Q==
X-Received: by 2002:a19:5f5a:0:b0:4b5:9b5b:ae92 with SMTP id a26-20020a195f5a000000b004b59b5bae92mr8827282lfj.10.1671188771594;
        Fri, 16 Dec 2022 03:06:11 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m8-20020ac24288000000b004a2c3fd32edsm190452lfh.144.2022.12.16.03.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:06:11 -0800 (PST)
Message-ID: <a8e09f78-704f-13f0-15ad-6c6dca6997f3@linaro.org>
Date:   Fri, 16 Dec 2022 12:06:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 4/9] dt-bindings: net: Add bindings for StarFive dwmac
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-5-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221216070632.11444-5-yanhong.wang@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/12/2022 08:06, Yanhong Wang wrote:
> Add documentation to describe StarFive dwmac driver(GMAC).
> 

Subject: drop second, redundant "bindings for".

Best regards,
Krzysztof

