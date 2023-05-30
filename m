Return-Path: <netdev+bounces-6519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67176716BF8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 111671C20CCC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 543142D249;
	Tue, 30 May 2023 18:11:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A081EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:11:33 +0000 (UTC)
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BDAD9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:11:31 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-6261a8bbe5fso22991146d6.0
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 11:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685470291; x=1688062291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GcvZSleHoWWovuNBoUoUWDR3x8EnOuv6MuTKRIzbD8s=;
        b=Dj9zLPvKRFljZZWNZEjp5Q1O9/LBpq1HX6EYjkizT71WBc/eAYNu0cCEq4Q0DONGly
         tryRfVak00SHsG4s+rNW17Zay87+TBk5/oekMUrgHbJyPfAHXekJ0MXhbawSor3AZr62
         k308rDtQ6UZd4NnFmEn4MXURdq1k4X2ffFMvWaiuAm4YGoSrQwY1XcgEdy2wahn0hcX3
         X4d1tNY96v5rj0fqbyJf28jTtm8CmUEHQaalvDV0piC11tGWjk0fRpX4IWGRpQB2EZvj
         4zXj5Kr7kUd6ne1ZndCa4XQ68vGcDkcnDE/UuCVuqAphoPV8RpW+6U8esQaPPxKXqG0J
         9ZWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685470291; x=1688062291;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GcvZSleHoWWovuNBoUoUWDR3x8EnOuv6MuTKRIzbD8s=;
        b=TBZtyWZzFH1szTfHqs/wD8igBZGII2xJB58ePOW/sAyCdk5gz2AG+zjyx4phd7whcS
         Kua01D/IRr9g/PJS8KUj7l+v9PRp/LmeVT6fiHL4EC/RfwBaVAzbBAsqexm99m1M2qdh
         HkkEcmvTO5/373MtN97OS5QY6oM8XgM8tZPIi0GYQkDiekfHl/fRv9PvibteRnJA+i0j
         ayfY7LjAwK5nducZ/mDMgbnBD9nE+hvcCkGoNB6kcLd6lTMxDQqxjz5djaerWKsZ86/J
         /ZgN9fA0Mky0ktp9wqNwSXUVA1mFV9rGvzM/twHh4P995ogaRL5iI62GC8TjpsZl/aWW
         eZmw==
X-Gm-Message-State: AC+VfDxZm3PkYfbdoUm2ITt6u6ALvII4uut/rCEVYyia61E2O3oqmBXB
	s0GXcFRX/HlIWEhvxn+kKDI=
X-Google-Smtp-Source: ACHHUZ5XH4lmffsLb5fJNbpSJH+beV0FIGQYDlb0Rda2xyWv5tP+1JZxtPoITWZC2/kdKD3Eatp08Q==
X-Received: by 2002:a05:6214:2487:b0:621:83d:3a47 with SMTP id gi7-20020a056214248700b00621083d3a47mr3446322qvb.39.1685470290769;
        Tue, 30 May 2023 11:11:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dk7-20020a056214092700b006261c80d76dsm2385468qvb.71.2023.05.30.11.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 11:11:30 -0700 (PDT)
Message-ID: <5c7a9903-2d4b-cb25-d481-bf78bd70d1ee@gmail.com>
Date: Tue, 30 May 2023 11:11:22 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 04/24] net: phy: Keep track of EEE tx_lpi_enabled
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
 Russell King <rmk+kernel@armlinux.org.uk>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <20230331005518.2134652-5-andrew@lunn.ch>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230331005518.2134652-5-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 3/30/23 17:54, Andrew Lunn wrote:
> Have phylib keep track of the EEE tx_lpi_enabled configuration.  This
> simplifies the MAC drivers, in that they don't need to store it.
> 
> Future patches to phylib will also make use of this information to
> further simplify the MAC drivers.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian


