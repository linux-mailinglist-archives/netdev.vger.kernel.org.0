Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2C74D36EE
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiCIRmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236714AbiCIRmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:42:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC7211C7CC;
        Wed,  9 Mar 2022 09:41:04 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id c16-20020a17090aa61000b001befad2bfaaso2966765pjq.1;
        Wed, 09 Mar 2022 09:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wl0N9LJBIu5bgZc5JB64O5GlI4w0K6BBrj1XBdNcAhc=;
        b=nXfyFGdc4UZwTcu3K8l5DcqcFI0uFFe675zKBvwr1awBx/wOziDHpVhaXz3HMzN+jE
         jvlfX+5H/j98nhI31M/u8FljaAgWtA66fgFw9tt4yCqVTFB6dwRxa5Ae3Nleu2K9WFFI
         wFuFj35YOIfg83+WNBt0ooaj1s9whUmyTCVksT6WAmwq2YKABMGXJsaRMicCK3QbRC8I
         zRwZ1tGR5djyh1uqbqZTkI+68APnanTMObVDjAdHG80J/56krxwOX2WRnSR/Rhz3aLzV
         2ZnK1Ngyl9PYayatoI9i6ijby6zPGgTgh6qAMFKJcCYcGFaqjbbmTNP/oaCber6s3t4w
         fxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wl0N9LJBIu5bgZc5JB64O5GlI4w0K6BBrj1XBdNcAhc=;
        b=WviOfL3V1rbWhm7edpJRNaFpaTsviapVA0dD95doLsdZQQLjtR3UxShwxQ6FIRfKfb
         IHK3vYukZVLh+7bs+w0qo4+lPDnZPGsMUCuUyJYBdrBaSdcD3u1Gvno3xqJsnitiCzIN
         yjehZvqkao3Ymq47EYXvj6RzpTgbUiSN8gFNgI+DInUmIztRixdMSxN+peXDHimCRJ2E
         Jc/1u+t910UJi0fjNZRzwqk5wDtqDkWq/Fm6Dbs9oJCJ1NkArb289w6ID3o/XGK8hrXo
         3hze63iFLjPaLV5D9HEHYE+D2OHWXsSSAW+GU67NIe+HcHZFG/BwWVi1llPGSWWozlRf
         Hbrg==
X-Gm-Message-State: AOAM530MroQIuW96f6j3CK3sbX9y5dqA48daMo0N8lJFBpSwPo0yJX/h
        8Arc5S1SqqJH7HJRIyu8Kbw=
X-Google-Smtp-Source: ABdhPJzhZYZho4JJsYb2521RY80COHSwjWybalG9zqGpe8Sy6P0yIkRAnfSYjjaEpIYkpinrybi6Tg==
X-Received: by 2002:a17:903:2490:b0:14d:57a5:a472 with SMTP id p16-20020a170903249000b0014d57a5a472mr550272plw.17.1646847662907;
        Wed, 09 Mar 2022 09:41:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u15-20020a056a00124f00b004f67314db4dsm3799994pfi.104.2022.03.09.09.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 09:41:01 -0800 (PST)
Subject: Re: [PATCH] net: phy: DP83822: clear MISR2 register to disable
 interrupts
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Andrew F . Davis" <afd@ti.com>, Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
References: <20220309142228.761153-1-clement.leger@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eda7f852-af2b-dac3-bb71-0be7f3230170@gmail.com>
Date:   Wed, 9 Mar 2022 09:40:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220309142228.761153-1-clement.leger@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 6:22 AM, Clément Léger wrote:
> MISR1 was cleared twice but the original author intention was probably
> to clear MISR1 & MISR2 to completely disable interrupts. Fix it to
> clear MISR2.
> 
> Fixes: 87461f7a58ab ("net: phy: DP83822 initial driver submission")
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
