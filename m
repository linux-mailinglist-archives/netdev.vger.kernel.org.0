Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFED66D9BD
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbjAQJYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:24:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236444AbjAQJXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:23:17 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473DE3C10
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 01:18:31 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id o17-20020a05600c511100b003db021ef437so2535091wms.4
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 01:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=tnJ5DdYrw54qQSx3lEI+x+lBLUOeQnMl1o76vv7Dgu4=;
        b=elVY3nR3vVxjUxSkeUPM277bE5WR5Yv1YPiiHAzuFxbrxRH4z7x+TVUV/kw01Q22TI
         5VOFKNEh9TJjkFGh5AZztVRZDDjgYelylcw8u6htm5ws62jgXKIMDsXWIGtGeblBEwD/
         q4Aq5nuZBKajSlU8Ww+nkrwR/ITwB6fxC6RwxjHWTwrPn+jMiM74jM8YE6xAh9TJ9qt6
         k0/1KI5RFcalaQH4gk61OVKV8XCMay2sqRchMpeZ4U/XGPwMXIet7EcE2cJAW6wIQSP+
         aO9c4z/BXvYaL49+HL5nEmlQNb/UPolssJCfPmQhRN+QsyZKMTtFLleIjZd+8jutWWS/
         S4Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnJ5DdYrw54qQSx3lEI+x+lBLUOeQnMl1o76vv7Dgu4=;
        b=i1IF8Q+acjcc8/lvjOfY7sB/vAk95VuWCWTg3M6sc8dVd0IIuuYEUlA8Utx4rTLxnD
         IMjuZXKNLQkAESdeo3RhGaDk75PfxbM8mO57tyN9vqF4rqFXaUWUKHNZT4DaBx01C4iX
         1e5+p+99Q4JtStufNm2eUUSHStf+juaDtcCcHnE9sQsTf9dEz9OP1MGXLvbs/7z+/AT+
         YYjoMi0bcAbAwSOiGhu81DtyEbmZGekvkmPaO96dBDmtnJvJdnu8xgI5QyDJY0le2r6c
         slhnD5E+yWmno0J14Rnr/qCOGoWDO3ssv1VdfVTbjwEnFrV+w9fP3GJZsg+19Yqiqq/X
         dhhg==
X-Gm-Message-State: AFqh2kojzx+/g05alVs/6nghBLLvCLGZiugUVlh7QQecqwSHznzgH4vs
        pI63hjWyc3Xn7UF+x7Hwm5zCiA==
X-Google-Smtp-Source: AMrXdXvDAOYefx+I2HK3Eib4cvfR8BUz4uU/fSfbsNpNlRCgv8K3V0M707BZH2a1DbPUP+dJK0l1WQ==
X-Received: by 2002:a05:600c:982:b0:3da:f5b5:13ec with SMTP id w2-20020a05600c098200b003daf5b513ecmr2230308wmp.34.1673947109790;
        Tue, 17 Jan 2023 01:18:29 -0800 (PST)
Received: from localhost (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003db0cab0844sm276263wms.40.2023.01.17.01.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:18:29 -0800 (PST)
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-2-jbrunet@baylibre.com>
 <4be60ea2-cb67-7695-1144-bf39453e9e1f@kernel.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Jerome Brunet <jbrunet@baylibre.com>
To:     Krzysztof Kozlowski <krzk@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: add amlogic gxl mdio
 multiplexer
Date:   Tue, 17 Jan 2023 10:05:56 +0100
In-reply-to: <4be60ea2-cb67-7695-1144-bf39453e9e1f@kernel.org>
Message-ID: <1jzgah1puj.fsf@starbuckisacylon.baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 17 Jan 2023 at 09:31, Krzysztof Kozlowski <krzk@kernel.org> wrote:

> On 16/01/2023 10:16, Jerome Brunet wrote:
>> Add documentation for the MDIO bus multiplexer found on the Amlogic GXL
>> SoC family
>
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.
>

Hi Krzysztof,

I do use get_maintainers.pl but I also filter based on past experience
to avoid spamming to much. It seems I stayed on the pre-2015
requirement to send only to devicetree list (I was actually making an
exception specifically for DT) ... and there was no complain so far ;)

I've read documentation again and it is explicit. This will be fixed for
v2.

Thanks for pointing this out.
