Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1B6C36A9
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjCUQNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCUQNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:13:16 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCABE18E;
        Tue, 21 Mar 2023 09:13:10 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t17-20020a05600c451100b003edc906aeeaso926336wmo.1;
        Tue, 21 Mar 2023 09:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679415188;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Pk7IjbqaJIEEKsGiYXSoq0xQcxrVnoZL7rQBDJ5gFyo=;
        b=JJlheVt73rKm0X/Gw5EvGnFVdk8pxIjDe6hawHWy6HG0j14Ml9yuCNNiCiGS1ElkJ4
         FDwK7ikjHVH6cQbl9wbP0xFexbFxsKBHs4SD8312/HTB3efNEDVXoujQRUHFQbbQZNVr
         MyLoeXM5qvmqSdc0OV9luJJVf+TYLpfTBehyE96zatjk+fTa5/fG08zOWBqdzbeCV9HL
         almVUq1eF/p3WcHexcp36GQIGPzSz0to6oS51bS0uh995l9xehQQ3S0pdFNg81EmDprn
         OUicM5QjBLbRyR2KJ63JojA0PyGYFrWwHr7LbTDeEVU3icNgYAQwJeu2JMEfYTxYGB5e
         doTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679415188;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pk7IjbqaJIEEKsGiYXSoq0xQcxrVnoZL7rQBDJ5gFyo=;
        b=EyZBGXMtolXNFU6jZVGmIM2AUw6Y0FfdJrsocj8pxhSfB/lRaPGeu3REJacZEwAi46
         x5KoIZeTKdpSwifxKgO2YHqkqi7xs6LK6ZUPrS/EGE+3+nc9o+vI/SkL43ZWcPqZTCYO
         6kFQcj4GDSEhwa7Sayc8hyjw6d/U5E0QrJ6Ho8lKJudwIPylPrmcLTvV9Cl7st5eS8Qo
         XodDU5UMH+8Pyv+2hB8PnShs1YmeQCgfO5l+PXiysEwD1w/C9xI+jHBn88BHjIU5ghV7
         6Iv8Dv4jxLH2HeuVk9Ki2qhUeliDMrA1/SjncX1PqN2mV1DgiB2GMDMs2Qy42kSLp0Ip
         KJQg==
X-Gm-Message-State: AO0yUKXbE15F5Ri2KMKaPLiBaeimqzEwXHml+BwuTaKKHGHcNXZYivK6
        ytFMnNOn2ItSUKHR1t4f+eqvJkprcD0=
X-Google-Smtp-Source: AK7set/UHc3VryuQe4vmOCNthOI8y5hUPmcaxq9SL3XP9hauniO7Ssi4Bsnu4r6WzLO5iry5I/3gqg==
X-Received: by 2002:a05:600c:2148:b0:3ed:af6b:7fb3 with SMTP id v8-20020a05600c214800b003edaf6b7fb3mr2942703wml.2.1679415188348;
        Tue, 21 Mar 2023 09:13:08 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id f26-20020a7bc8da000000b003ed2d7f9135sm13812938wml.45.2023.03.21.09.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 09:13:07 -0700 (PDT)
Message-ID: <6419d793.7b0a0220.f0640.a82c@mx.google.com>
X-Google-Original-Message-ID: <ZBnXkkZ8sOBY36YG@Ansuel-xps.>
Date:   Tue, 21 Mar 2023 17:13:06 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED
 is disabled
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
 <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
 <64189d72.190a0220.8d965.4a1c@mx.google.com>
 <5ee3c2cf-8100-4f35-a2df-b379846a8736@lunn.ch>
 <6419c60e.df0a0220.1949a.c432@mx.google.com>
 <c07d07b3-42bc-4433-8f8d-3bee75218df7@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c07d07b3-42bc-4433-8f8d-3bee75218df7@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 05:02:42PM +0100, Andrew Lunn wrote:
> > BTW yes I repro the problem.
> > 
> > Checked the makefile and led-core.c is compiled with NEW_LEDS and
> > led-class is compiled with LEDS_CLASS.
> > 
> > led_init_default_state_get is in led-core.c and this is the problem with
> > using LEDS_CLASS instead of NEW_LEDS...
> > 
> > But actually why we are putting led_init_default_state_get behind a
> > config? IMHO we should compile it anyway.
> 
> It is pointless if you don't have any LED support. To make it always
> compiled, you would probably need to move it into leds.h. And then you
> bloat every user with some code which is not hot path.
> 

Ok think just to be safe we should wait one more day for the 0 day bot
and then finally send v6? 

-- 
	Ansuel
