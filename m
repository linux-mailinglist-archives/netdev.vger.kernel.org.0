Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1043F6BC8EA
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCPIWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbjCPIV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:21:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C117A1BD
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:21:27 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id eg48so4170204edb.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kr5S3N/jEq5QwRC+Tpsp/PcT+FJdWvsgMrBLfYurMwQ=;
        b=RZGQwNocBSzKfZ/I0mZHLwo5C1c+A8CZ0dZSAbZlwlZ4gay7AkptpHxaHnOdKC88Cg
         1PiF8gp7UxeKS3+Ni50Fxt4joaAX18eqdVju2tKJIRYeDF+ETNXI428rvvoRJy0UP8nV
         wWNSQdRMuuJOL97mSg0OkOHp/0DZk7RyRYNFleCN1PwcFn2nPe8hxjiXmVeNw4+EGXDa
         9Ek5To5Mv1mzFElNhOCRfzNhfpE7LZQ/wTmEgWTdc4uNrE46th4E/jekj3Y+efP349nb
         3WwVvrxzwG1vO3kYxRwvUXRdCM9NcGNJEw7FkUfKrVoJ6Gv+YpZmtRZ6rjzApZUsgUmy
         uBdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kr5S3N/jEq5QwRC+Tpsp/PcT+FJdWvsgMrBLfYurMwQ=;
        b=ZtV9mKPwJyV0WDinpkd4qAeXgdsP3QaH2hFA/7uv057n4nsTayeAMfA4CHZl7db4Ad
         V3HH8yrnW/iwMI+NQv8EWkzkObQxmqOMZlMoUBh1XXRikDsCIvPZKACJFGYSD/K9vuEj
         EzwyI4C+Ftn4DYShdJheRj+RK8lzQoM6fcwkbimXO5Ivc02pKrgXDAwIB11TRLfmywh6
         koHElx5C69LBDVna9er3UYtHzKzPUKkPZO7T4Ibb71WSF3H2Af5d6DFALnz/8LQmzUwK
         yaVuCs0IadgEL2JR7cFITw2R84PEJOFQuGXk3j8yJrO7KUArWuPolFk8qtpPYAmIdaGY
         1/Xw==
X-Gm-Message-State: AO0yUKUMkxdcDsTf7wHW0QdXSf6ItKGI2K8Zvlv92suKu+u07k5RQmKG
        S3LGhZzx1SbdQotvEc8s4GKI5w==
X-Google-Smtp-Source: AK7set8lsrc4SyqgZ926RFfnOkUzML/zlYEUE6aKYVpIdBM1JJJkXl+8HJIGSLY/D2fxwfpSzGkxYA==
X-Received: by 2002:a17:906:8cc:b0:871:dd2:4af0 with SMTP id o12-20020a17090608cc00b008710dd24af0mr8808989eje.26.1678954884472;
        Thu, 16 Mar 2023 01:21:24 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id i18-20020a1709064fd200b0092be390b51asm3490949ejw.113.2023.03.16.01.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:21:24 -0700 (PDT)
Message-ID: <1fbb6626-90cd-1dc1-a165-337b6378e165@linaro.org>
Date:   Thu, 16 Mar 2023 09:21:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 01/12] net: dsa: lantiq_gswip: mark OF related data as
 maybe unused
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org
References: <20230311173303.262618-1-krzysztof.kozlowski@linaro.org>
 <20230311181434.lycxr5h2f6xcmwdj@skbuf>
 <d9b197c8-56fe-b59d-5fca-bc863ac1e7ed@linaro.org>
 <20230312105729.bnxn4a6mf2gav7ym@skbuf> <20230314222244.4325bb3f@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230314222244.4325bb3f@kernel.org>
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

On 15/03/2023 06:22, Jakub Kicinski wrote:
> On Sun, 12 Mar 2023 12:57:29 +0200 Vladimir Oltean wrote:
>>> Sorry, I don't follow. I don't touch that wrappers, just fix errors
>>> related to OF device ID tables, although in few cases it is indeed
>>> related to of_match_node.  
>>
>> I'm saying this because in lantiq_gswip.c, xway_gphy_match is accessed
>> through of_match_node(). If the shim definition for of_match_node() was
>> different, the variable wouldn't have been unused with CONFIG_OF=n.
>> I guess it's worth considering changing that wrapper instead of adding
>> the __maybe_unused.
> 
> Hi Krzysztof, have you had a chance to check if using an empty static
> inline is enough to silence the compiler? Seems like it could save
> us quite some churn? Or do we want the of_match_node() decorations
> to go away in general?

I am pretty sure fixing of_match_node() and of_match_ptr() (independent
case) would supersed this patchset, but it is a bit bigger change than I
have available time now.  I didn't try it yet.


Best regards,
Krzysztof

