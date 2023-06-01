Return-Path: <netdev+bounces-7234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6819071F37B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:14:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1C4828190E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9BA94076C;
	Thu,  1 Jun 2023 20:14:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D357823DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 20:14:48 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A09D1;
	Thu,  1 Jun 2023 13:14:43 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-75d13719304so107828485a.3;
        Thu, 01 Jun 2023 13:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685650482; x=1688242482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OG/rCN+OmsjvZqSpHKkTEhSoHCNMP8tcTTpNoQzhqWw=;
        b=kq2eymw2VSjHxgZ8bD2qhvvonK2PEHdjli0KOfLUxmQ/reYbP3lOLdnC+/bDkkptnS
         WXO8dmaxEX/I0+uFe3e1gs3BkwGdOBXbA8WYwfY2lcHy4HNTjFyDG4XEyZSH7PmT0UWP
         nc112NetAYEetGwtatwT3IceRMroEras5Fn+drBKH1g6lhs6yHflY9u5HM10uZ17dKHt
         dVLAVvuFIrnzfyqXc+5pTg0FFhnaKVAhYcCPhd7IR30XOKIwk4aNJl8iuLLNDstqYR31
         H+Mow4/CJyqAJ5g1l3Gn+IyMEmth8sXZiwh9aMNNeO4PKg6gkiVXH3EX0NEEAGNt+uAc
         nw1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685650482; x=1688242482;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OG/rCN+OmsjvZqSpHKkTEhSoHCNMP8tcTTpNoQzhqWw=;
        b=JwGaVM5kiHCKcgdFL0578I/opskKuvSAgsc6aJmsDW13wMfLukBCrriRqg4d0bY0VY
         BHC09zbBWCA1CaKQWUKKkOv9hRxHzG7LCKQeAmgj2PqrP94shSElGfEe0uwJf3s9WPi6
         vO22TzQs8TLjEYgu2sds//vutDtGkmhQeqrhjvIekbZVda8G6+paiJdH59L+U9zlnL2S
         5hFrSBW5EgqiZ1tjVWjCgywpecdCAjq/kypjQZBlaqNv9aJGxdnRNk3QFmoPy62PFwm2
         sSzK9InbYYet533rnbQE5Jk2fkjrs0cMx9HNGucmSUF71kDSp/IVoL6nep02JRefgicH
         QsZg==
X-Gm-Message-State: AC+VfDyiBDuI2eA0JB0gXP5UOQeR4ok3c5xY0/NDy1sR9+qEz3nRXzRp
	X/2DAcvyGj9NWADcEXkT36M=
X-Google-Smtp-Source: ACHHUZ4AV6WD1JfrulwBn2M+UAuEznKd8O2ihs18fRBEsZf19tJuZpS3f6qRw6lQmik/Y6HYPT3UvA==
X-Received: by 2002:a05:620a:2e1:b0:75b:23a1:3ec with SMTP id a1-20020a05620a02e100b0075b23a103ecmr9220461qko.2.1685650482328;
        Thu, 01 Jun 2023 13:14:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c11-20020a05620a134b00b0074e0abe59a0sm7035104qkl.78.2023.06.01.13.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 13:14:41 -0700 (PDT)
Message-ID: <94d74b65-55ad-d070-2590-d21b79ff5abb@gmail.com>
Date: Thu, 1 Jun 2023 13:14:27 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 2/2] net: phy: realtek: Add optional external PHY clock
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>,
 Detlev Casanova <detlev.casanova@collabora.com>
Cc: linux-kernel@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <linux@armlinux.org.uk>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20230531150340.522994-1-detlev.casanova@collabora.com>
 <20230531150340.522994-2-detlev.casanova@collabora.com>
 <4a6c413c-8791-fd00-a73e-7a12413693e3@gmail.com> <5682492.DvuYhMxLoT@arisu>
 <7bde15a1-08fe-4036-9256-b13280340b6b@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <7bde15a1-08fe-4036-9256-b13280340b6b@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/1/23 12:37, Andrew Lunn wrote:
>> I'm not sure about this. Isn't the clock still necessary when suspended for
>> things like wake on lan ?
> 
> Yes, but the PHY should know if its a WoL source, and not disable its
> own clock. There is some support for this in phylib, and Florian has
> also reworked it recently for Broadcom PHYs.

If you want to have the PHY driver have a chance to disable the clock if 
Wake-on-LAN is disabled and therefore conserve power, you should set 
PHY_ALWAYS_CALL_SUSPEND in the phy_driver::flags and in the 
suspend/resume functions do something like:

suspend:
	/* last step after all registers are accessed */
	if (!phydev->wol_enabled)
		clk_disable_unprepare()
resume:
	/* first step before registers are accessed */
	if (!phydev->wol_enabled)
		clk_prepare_enable()

The flag is necessary to ensure that the PHY driver's suspend function 
will be called. The resume will be called regardless of Wake-on-LAN 
being enabled or not.
-- 
Florian


