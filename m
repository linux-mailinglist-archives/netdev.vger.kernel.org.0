Return-Path: <netdev+bounces-7867-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05CA7721E5B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 658DD1C2097F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78EC5254;
	Mon,  5 Jun 2023 06:41:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC2E382
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:41:27 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755FFE48
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:41:03 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-5147f7d045bso6547596a12.2
        for <netdev@vger.kernel.org>; Sun, 04 Jun 2023 23:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685947255; x=1688539255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WKyJTEWAr2/bbgJ4qj5g0DH+qXUa8fA/In0KtxR+hDE=;
        b=j9sEsVQGcZI0ww4pUAZR4LvJgzBAxv+VHBf2ykJK4FV2Paspea3UMvQUD1Hat0/DK6
         C1ZtBMO0d3gCnu84BBRsvmgPvqeZWNbC0SiDrn8YrEbCDKDVrsHe+EKYYeg3fsAUF7vi
         DSMcugAkDnGFX/wvFCMlCWIAp3F4e5CINRNi6nZC2wLz/C8EA3k6ePtwqvAgx/SHDbsx
         wfXBw4epXXiMf3xILHbRp5rHLLAKMgzGSyhjm08P6v4i92CM2NgMsCPyX5CKBUVqB6Qx
         VLFd208uwr6/GMyOws242w3aXkOsKtMtTh4F1pwluQ09WVNCwATda+lT649Ol+DlX3Mf
         Hidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685947255; x=1688539255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WKyJTEWAr2/bbgJ4qj5g0DH+qXUa8fA/In0KtxR+hDE=;
        b=AoszzTn9/kJXgJvfjQ+cCaTQMo9+exVTIoHT1++IoYjoWpGe0OEcvhmPpwRlF/It/o
         wy0pGE4VBLTan627eRRhsirOzlO6CH9+9tXyDuSZV4etUObW7ew1D6tgp1rf7wbV90xR
         elopZkjbGMJkZKgXWvk8dw9zkyEI32kBRiRTzGfk3EJIMDntyH+g2J1rFRLUaYRHJPjt
         coany34FtL+i2n2gsq6W2cP2e7t12qps0wntpJL1DtrbELZjtN126RYfTCyDCJ7ke6o/
         qQBoLd9rDN6DvSvyy7yMDgFJypLuKRThe3p+8L1N7+mtn5/ySlkbL5g+YKDkBNnnhNEp
         cMOA==
X-Gm-Message-State: AC+VfDyQ5g9bAL7DBMk4AX8Q2xlNFnhXWMZPi83xqBXc6WGWDnpNau0+
	CmhbMb6AL6OBXrpjt0RLAivM5Q==
X-Google-Smtp-Source: ACHHUZ5rD9LvlGRhmhSXQ6m7PkXkbDSH3OreIA9ygN8V+18zsEuiGBcHP+HOLFbqCky2LbZl2Bq7Kg==
X-Received: by 2002:a17:907:6d19:b0:973:ea73:b883 with SMTP id sa25-20020a1709076d1900b00973ea73b883mr5710250ejc.66.1685947255077;
        Sun, 04 Jun 2023 23:40:55 -0700 (PDT)
Received: from [192.168.1.20] ([178.197.219.26])
        by smtp.gmail.com with ESMTPSA id qt23-20020a170906ecf700b00977ca5de275sm2220115ejb.13.2023.06.04.23.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Jun 2023 23:40:54 -0700 (PDT)
Message-ID: <cb6db583-fec9-f20c-23b3-6fda437e65a7@linaro.org>
Date: Mon, 5 Jun 2023 08:40:50 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH 06/21] ARM: configs: at91: add mcan support
Content-Language: en-US
To: Varshini Rajendran <varshini.rajendran@microchip.com>,
 tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
 nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
 claudiu.beznea@microchip.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, gregkh@linuxfoundation.org,
 linux@armlinux.org.uk, mturquette@baylibre.com, sboyd@kernel.org,
 sre@kernel.org, broonie@kernel.org, arnd@arndb.de,
 gregory.clement@bootlin.com, sudeep.holla@arm.com,
 balamanikandan.gunasundar@microchip.com, mihai.sain@microchip.com,
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-clk@vger.kernel.org,
 linux-pm@vger.kernel.org
Cc: Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
 durai.manickamkr@microchip.com, manikandan.m@microchip.com,
 dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
 balakrishnan.s@microchip.com
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-7-varshini.rajendran@microchip.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230603200243.243878-7-varshini.rajendran@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 03/06/2023 22:02, Varshini Rajendran wrote:
> Enable MCAN configs to support sam9x7 soc family
> 

There is no need to enable config items one by one. Squash these.

Best regards,
Krzysztof


