Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B351F6656B0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236311AbjAKJBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232241AbjAKJA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:00:56 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D2A3B3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:00:54 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso7711685wms.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 01:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=UIgNk4h0ykNf4W9R10f+g8s9MtlXPDlZWGID0CLp804=;
        b=ACz2pUEAplUyKMwahar14IEYYnawh0ar2G+KL0+AdO+fXKDb6L1+7Aq1cR/JhRxMxF
         mptt0m7OE+hHLEPyv2GGxmbq78+4PKJIg2OU+Et0ss+4vM4s35EB+0jdnp7VOr0n3o4Y
         sVNrXDS1NCtl4llNRycijVOG7GqCqJE9sTXrkMnrFCkCNHARqK/VingD2ZFf2CaIyh5R
         BkUyz70LPfPlxaoLoSrL9Eyv1OPob/snhvTSgSee+4oBHoO28UzKBMYs7qZmo3PKc7Oj
         TZY7YEEZvny5IzPNF2MZFoR+8B8dExdbws1pT2JocEc7BXwbvR4fsYcDcyxTp6JjTglr
         yNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIgNk4h0ykNf4W9R10f+g8s9MtlXPDlZWGID0CLp804=;
        b=ABV4l6ji6umohE7+ZBVc9dqRnnzGO+mRVewyz2qz55kgSa/prucC9RTl5iGG6h+HH3
         eExncPQx8834BvI1MLncXlwzkm3zjjOlL4LfPA2FVMmpO05kSQqOAY5D64nSdBoadFDl
         GXTmbfMx2Xg0bGIZms3yOPKwSPWDjWXzUKOIRIaUefHGyO6596zE0FlSTWyJ+nqh0Xg5
         lJVy4xFt3FXz7S6BrvK6xGjRrR0ODFMrjiQAVQ33ldOsIWVrjYTSNkutsI1UUXx/Aojl
         j87J2prm1UTSmwBYp62kFSdsQB1k7Ug1XOa5ChBAS02/nGPinmHuz3l4B+OSZOjqE3gZ
         EJuQ==
X-Gm-Message-State: AFqh2krWWrraVrEPtrxBct93SnknX1UTwgjZAUzXwsLpwcpnyb50OR2u
        ukubIzzUKIDdTkhltwXMKYv/vw==
X-Google-Smtp-Source: AMrXdXu50nuURvF/uZXf+xmLuSwesdnOY8E4IcaZoYRp8Au4jWUve2YDc0RJ8X2U2aelNYBfkHhv2g==
X-Received: by 2002:a05:600c:34d0:b0:3d6:b691:b80d with SMTP id d16-20020a05600c34d000b003d6b691b80dmr50949988wmq.21.1673427652953;
        Wed, 11 Jan 2023 01:00:52 -0800 (PST)
Received: from ?IPV6:2a01:e0a:982:cbb0:d95d:43b7:d6a9:39a5? ([2a01:e0a:982:cbb0:d95d:43b7:d6a9:39a5])
        by smtp.gmail.com with ESMTPSA id o21-20020a1c7515000000b003d995a704fdsm17507540wmc.33.2023.01.11.01.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:00:52 -0800 (PST)
Message-ID: <08698c06-49b0-1cf7-efd3-1038104972cf@linaro.org>
Date:   Wed, 11 Jan 2023 10:00:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Neil Armstrong <neil.armstrong@linaro.org>
Reply-To: neil.armstrong@linaro.org
Subject: Re: [PATCH v2 00/11] dt-bindings: first batch of dt-schema
 conversions for Amlogic Meson bindings
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
 <20230110152324.1e19974d@kernel.org>
Organization: Linaro Developer Services
In-Reply-To: <20230110152324.1e19974d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Hi,

On 11/01/2023 00:23, Jakub Kicinski wrote:
> On Mon, 09 Jan 2023 13:53:25 +0100 Neil Armstrong wrote:
>> - patch 12: added reviewed-by
>> - Link to v1: https://lore.kernel.org/r/20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org
> 
> I'm guessing patch 12 is patch 11 in this posting.
> Should we take it via net-next? Looks acked & ready.

Exact it's ready to be taken

Thanks,
Neil

