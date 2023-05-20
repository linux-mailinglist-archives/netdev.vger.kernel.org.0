Return-Path: <netdev+bounces-4048-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C5B170A4B0
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 04:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2167C1C20B89
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 02:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E357A636;
	Sat, 20 May 2023 02:54:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865D632
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 02:54:52 +0000 (UTC)
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBC410CE;
	Fri, 19 May 2023 19:54:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae557aaf1dso33777195ad.2;
        Fri, 19 May 2023 19:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684551283; x=1687143283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CmKjA7HK49s/EaR6u002ntY4Vma6S5zT8kw4gQSu83c=;
        b=d0htBs5hH+b2fhO3gn6jI1fIuzbZvf5Tu5zUCTIqlxSfrKFreMpcAUiVLaMCH1oONs
         H3c/ho2dVTh+tfLAB5a21tGXBMibg+djpYCCfzdr/GGbcZbDx/66L9p75cGizF+BWSV6
         1oEbqcqfbtGfkKeivifK6DAHsKx4ZftLDYi/QAK7Gw8zSwR5OuZFQIXuz0HrBoHpB7Q9
         zxyxk/8yQgCf7BZCsFRxv2thY94aM3nAesiKduQPD6jKx5qmTUqb3n8ZxMRIZin6nY3p
         N7/yKIJqeb4WRjbDgjaWz+kl3K9V/bo3cnVeZbD6/aH4akUNzTC/5H0qA/AViFudgZtQ
         mimQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684551283; x=1687143283;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CmKjA7HK49s/EaR6u002ntY4Vma6S5zT8kw4gQSu83c=;
        b=cZ9zPlVnoEhhoMAU3F1jV1PJ2fVK9t6k+FUoB6+h/tJclRfULtwcYaiJs3gWxunjRP
         2ti9ljpnNBxyZSpt7uEpGlGnn/m7VYrlQp3wE7gEJevDLE9j09YCzv1US6/aNxZzBdRn
         zDn6WpjVhmFD9B96jbriS328IyLEQ6XDZjuE24QItaS9GtMlsyWkRwEIlZvkxmzqlHwQ
         VNvEh5sC++mMAEx7JceVCfXOuMRgSperHwTUgwrZYvOfFpB4RHkOZB7Ap6m8A6krH+4Y
         TKirQTABfJ3pw6ihP5ILnfhZfFwCiQ0oS5iPI2UWdOoAZy11v/6SjefpooQbeOBa4wi0
         KjJw==
X-Gm-Message-State: AC+VfDyHDGmcwcW+sxseRucwvkhGM0C60ngXM2KKFkkYv2NuebMtTkTY
	EN7BZw2uPGpJ9NsX1QY/MrI=
X-Google-Smtp-Source: ACHHUZ4ofPjA2XOOxSLpk0elb6ZYfeeTncezcO1GrUScVq8bZJA2l3ZbbXN1O6ik2xcQ0bGVg5HxJQ==
X-Received: by 2002:a17:902:ef82:b0:1a5:3319:12f7 with SMTP id iz2-20020a170902ef8200b001a5331912f7mr4166292plb.50.1684551283113;
        Fri, 19 May 2023 19:54:43 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g7-20020a1709029f8700b001ab1b7bae5asm322145plq.184.2023.05.19.19.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 19:54:42 -0700 (PDT)
Message-ID: <1ea7974c-5956-c32d-67a2-34be3be7739f@gmail.com>
Date: Fri, 19 May 2023 19:54:39 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v2 3/7] net: dsa: mv88e6xxx: use
 mv88e6xxx_phy_is_internal in mv88e6xxx_port_ppu_updates
Content-Language: en-US
To: alexis.lothore@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
 Vladimir Oltean <olteanv@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Richard Cochran <richardcochran@gmail.com>, Rob Herring
 <robh+dt@kernel.org>, Krzysztof Kozlowski
 <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>,
 Russell King <linux@armlinux.org.uk>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
 paul.arola@telus.com, scott.roberts@telus.com, =?UTF-8?Q?Marek_Beh=c3=ban?=
 <kabel@kernel.org>
References: <20230519141303.245235-1-alexis.lothore@bootlin.com>
 <20230519141303.245235-4-alexis.lothore@bootlin.com>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230519141303.245235-4-alexis.lothore@bootlin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/19/2023 7:12 AM, alexis.lothore@bootlin.com wrote:
> From: Alexis Lothoré <alexis.lothore@bootlin.com>
> 
> Make sure to use existing helper to get internal PHYs count instead of
> redoing it manually
> 
> Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

