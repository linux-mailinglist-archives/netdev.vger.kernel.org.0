Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095D76E0F66
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbjDMN6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 09:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbjDMN6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 09:58:32 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B62E2;
        Thu, 13 Apr 2023 06:58:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id hg14-20020a17090b300e00b002471efa7a8fso1662260pjb.0;
        Thu, 13 Apr 2023 06:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394305; x=1683986305;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kNAKWgcTdccs6pLBAEnODiUJFNRZ60PfDd70QCWylRo=;
        b=OMmoyDLs/mgzA/yZkqT0BaVNgS7Yd6qGXkgFW4eMMilRCrzb/GFwHroxYkElC4aCJc
         161ipsYN4gkcfhPTS0uqbvY+/eBzrBsizJd4xINJbi7sf9zEQyMo9ynsGU0/qZh091bA
         qk5vEfY8s5CUDn6A5zP7mgt2d5pewmnGrWFMTqDpnUSjskk+WmZxJGV0f7zUurMgMcyk
         Ukios3yK/ov2hE7hAeP7z4ky6mMbeWFy+V7gbuiTvBScATMKlkekeca9v1nkHiOyorkm
         Du0goKa6UrTrMlr9VG9rm5cxxUOWPQYuYlh3gqT3o03tGo09WPXXMurJvtlN/xxa3Uro
         WMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394305; x=1683986305;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kNAKWgcTdccs6pLBAEnODiUJFNRZ60PfDd70QCWylRo=;
        b=LXPMg2WMh461HT0/Nrcn2lWrCp3FxPf8OAxfv1s7Daneo09c2H3SzPBeuq9hWS296h
         f/7AtlgWVIHN/PLS8Omag+wmb/TYA5uCyPPti0KuNaooE3+TXhc0YuGtzPgxhMgAFfOn
         0dtnTBOudtXnWu0FmtzZ7pOb8Iv73oO9c4wLCh6ro0/xpvH1gLTcSXmvWP0Z9V4Jbbem
         ZL4+Xu7g/rYKDeFYyKLi2LLSBm8d+CT2nXSsWMnQN5wgWpHUALcwZGP0+tHxz9D5F6px
         5Y/V38RH9Z/36SdIzryf5kp0kVI5oIOh+d+47s6bWReUWYpRaZMHqBInw1OmV/TFkpxv
         ThGQ==
X-Gm-Message-State: AAQBX9d4TiKWt7mvTlCoZ7GH4FWUAXhV9Cd5dGCgYTaGg+k9QzEeP7oB
        4/Ie+EL6bF3JBpqM8fHTgHg=
X-Google-Smtp-Source: AKy350bYXy7ZQOs05ZvuMGmmL8mnLdJcmamc//JFEqPwaaskjfTM3+ijZJKDOck+na/NYMoDGmHr/A==
X-Received: by 2002:a17:902:d54a:b0:1a6:5fa2:aa50 with SMTP id z10-20020a170902d54a00b001a65fa2aa50mr2657370plf.1.1681394305169;
        Thu, 13 Apr 2023 06:58:25 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f7c900b00192aa53a7d5sm1538113plw.8.2023.04.13.06.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 06:58:24 -0700 (PDT)
Message-ID: <eae41b12-10c5-5caa-56b3-84a88a6ce463@gmail.com>
Date:   Thu, 13 Apr 2023 06:58:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next PATCH v6 04/16] leds: Provide stubs for when CLASS_LED
 & NEW_LEDS are disabled
Content-Language: en-US
To:     Christian Marangi <ansuelsmth@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230327141031.11904-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/27/2023 7:10 AM, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Provide stubs for devm_led_classdev_register_ext() and
> led_init_default_state_get() so that LED drivers embedded within other
> drivers such as PHYs and Ethernet switches still build when LEDS_CLASS
> or NEW_LEDS are disabled. This also helps with Kconfig dependencies,
> which are somewhat hairy for phylib and mdio and only get worse when
> adding a dependency on LED_CLASS.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
