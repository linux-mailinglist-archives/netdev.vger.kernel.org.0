Return-Path: <netdev+bounces-6521-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36764716C18
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB5A1280EB8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8892D25F;
	Tue, 30 May 2023 18:17:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3C1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:17:09 +0000 (UTC)
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8876DE8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:17:06 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-75b0b2eb9ecso297926985a.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685470625; x=1688062625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mcu2KkDF9web2ZO2/zYLufdbTvumYWDgELVD052XqhU=;
        b=kHMXxg/iG7DfbBP35ZAnHLcozob8AjCOOBZdyKHLGsKlWbpt71R1pgi4tFYKytp8e6
         EvbejyyHrI5kABcZHk5mfEozQwFlbFUZew5NbwJsgt/ReWBsMsudZrLMUXMi1zbVJRTr
         KmiUiYPm3HrHDhBrSXrq2W0m5lGPRYGCAIJKhWn2AEcBkXR408BRUx+xDNDpnOzoqU6f
         vUndNwosjNfWPmM1+4irueay78ovJ0vB0eGldFWPPbcmt8fE4CdDZK57NKhRU+CHl/7c
         o0yO67p8cKfJ+BBh3NMf7EJyKLIc97gkrboL+Tv5WjUDYagPJJTQO4RRnoScE66iKJre
         x4Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685470625; x=1688062625;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mcu2KkDF9web2ZO2/zYLufdbTvumYWDgELVD052XqhU=;
        b=M3vrPyzkczLres5TioT0EEIp0IZ8ilr9L36PBjyirP5o1zt5POUFcosRL23eRXGJdy
         kiLCPptyCrtEhWj+wfBWAgIYH2Bi/EbjgVgp5rB36zg4fVzUD3T0KYm0A4gA3t8fqM6r
         LX6UB/cQ1SoKhFTtWRWLPVABhTWxNDbzYyqXkkfyQvh8vPuKtZFlUzOIYTnIn4R1Kv2L
         pIBOjSzYFNOtwI72GWPkgnd6VO1kgLOzWdQfCOnA6yExm21cvy6K8zkZan+93uxyRXjy
         19WWpTvXwrllwGiHMNM8v6Eb96QHErNmaRR3YU0g9hQDcj5EoHGksdqcKZ9gLmus1DuV
         mdoQ==
X-Gm-Message-State: AC+VfDxt9JHKh7r1jjCr0aTiYnN2lpj+joss0YncpWC/4hC8khlE59h4
	MBu802lRgTUMMh4q0gEi/Ko=
X-Google-Smtp-Source: ACHHUZ5GoYg0Uq8ElSpPM3t/cnQZcs0uLYGwca2QoAiIQsg8B+kzPHGMdlHlkDLW1F0tDZagw9uznQ==
X-Received: by 2002:a05:620a:414d:b0:75b:23a1:406 with SMTP id k13-20020a05620a414d00b0075b23a10406mr3278665qko.28.1685470625629;
        Tue, 30 May 2023 11:17:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a19-20020a05620a16d300b0074df476504asm3937666qkn.61.2023.05.30.11.17.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:17:05 -0700 (PDT)
Message-ID: <db8157eb-d88d-53cf-b0ab-9f93ec71f790@gmail.com>
Date: Tue, 30 May 2023 11:16:58 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 20/24] net: phy: Add phy_support_eee() indicating MAC
 support EEE
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-21-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-21-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:55, Andrew Lunn wrote:
> In order for EEE to operate, both the MAC and the PHY need to support
> it, similar to how pause works. Copy the pause concept and add the
> call phy_support_eee() which the MAC makes after connecting the PHY to
> indicate it supports EEE. phylib will then advertise EEE when auto-neg
> is performed.

Nit: there is SmartEEE/AutogrEEEn which are specifically designed for 
MACs that do not support EEE, but in spirit, there is still the 
auto-negotiation aspect that needs to be looked at the MAC driver to 
enable SmartEEE/AutogrEEEn at the PHY level.

With that added/reworded a bit:

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


