Return-Path: <netdev+bounces-4865-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9781C70EE14
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 08:38:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3CD12811CC
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0495F15D5;
	Wed, 24 May 2023 06:38:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18F815B9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 06:38:52 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7667D18D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:38:48 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96f5d651170so1160649466b.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684910327; x=1687502327;
        h=content-transfer-encoding:in-reply-to:subject:from:cc
         :content-language:references:to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=z9qKa9RqSjKQDvTKCOJFhrIeOFF4u6aV7AZVl7uk18k=;
        b=ZBpInanbrCzHVCQI7SLNfxU6ZvLsyBdQ5Pp+GMCNyzWz/S7Tmh836LHu+UYjbtmzsL
         o3bbIiJXLMT8U9P6G+kKkLKozMElZDF5J2DV1tcfaJh4HJIUiCLSvV3SIqTgtieIzUH0
         Hg3lq1uQbBAGeUv38CLNxA7NvrimhbyKmUHUOvlD66gfJHzNR1giegZVrd/ElSAGBMbC
         erN9747wAF2xw0NMKS1fNkavhefUSgIX9kYyZT+LTSMZDdAoI4u/vib4hX95r21+Y5mL
         7TLxm/G9mgoEjaqyWMPGIDHN1gf7H6NrOvSFxSNrxOHn4wpnbz1z1NOtWEopLdC/Fq9R
         wFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684910327; x=1687502327;
        h=content-transfer-encoding:in-reply-to:subject:from:cc
         :content-language:references:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z9qKa9RqSjKQDvTKCOJFhrIeOFF4u6aV7AZVl7uk18k=;
        b=QPab24traGy0B17c+zEPRBPwebLCPYDM0yG3LIbpdywA35v3DaBysw6XgHUfZsXQMV
         O9Hzzxudm8/UwkVMo2R5Ja4AIQxgikkkI6G7oTib9+G0UopoYoNijOqTLaRdH1y/j6kp
         HZ2T3zXMz7KWjW/ABeDZC7CTYAPIsNgWBbxaWBm20shzrwJDOeYsvKUtdE09QcEalBWc
         bZblpoS6Tf60CrJ4Xw0XJnHGcJ1dfBkYHIH5M9AnCLhj5q80azrmOjhQgmLfXl9cEqYs
         MCjSqvgD2gRERcHTrgUCg4/wGo8cdvRYbGnhxGFHCXmEtrb4oWdhQ0SeokxJIL720b6y
         /CCA==
X-Gm-Message-State: AC+VfDxU41B1A4QxMxzVCtnrJKKBuWtXqgHoepubPgDAC/BZS7Cjqvd/
	OUccMwb76AdMfpOQwGSVRW9nLIZI9UA=
X-Google-Smtp-Source: ACHHUZ7S3ocIZrGabnev92IGt6SgQM3nF0NEzspHL6TjFSLDik2UUJJ0tqR0G8D4SVlMoSNHcpFrpw==
X-Received: by 2002:a17:907:2d0a:b0:94a:6229:8fc1 with SMTP id gs10-20020a1709072d0a00b0094a62298fc1mr17215446ejc.31.1684910326214;
        Tue, 23 May 2023 23:38:46 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c519:9c00:b49b:cbaf:f9dc:9438? (dynamic-2a01-0c23-c519-9c00-b49b-cbaf-f9dc-9438.c23.pool.telefonica.de. [2a01:c23:c519:9c00:b49b:cbaf:f9dc:9438])
        by smtp.googlemail.com with ESMTPSA id mf6-20020a170906cb8600b00966265be7adsm5329418ejb.22.2023.05.23.23.38.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 23:38:45 -0700 (PDT)
Message-ID: <ace88928-93b3-72fe-59e5-c7b5b7527f5e@gmail.com>
Date: Wed, 24 May 2023 08:38:43 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
To: Genevieve Chan <genevieve.chan@starfivetech.com>,
 "ddaney@caviumnetworks.com" <ddaney@caviumnetworks.com>
References: <8eb8860a698b453788c29d43c6e3f239@EXMBX172.cuchost.com>
 <907b769ca48a482eaf727b89ead56db4@EXMBX172.cuchost.com>
Content-Language: en-US
Cc: Andrew Lunn <andrew@lunn.ch>,
 Russell King - ARM Linux <linux@armlinux.org.uk>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Marvell_of_reg_init function
In-Reply-To: <907b769ca48a482eaf727b89ead56db4@EXMBX172.cuchost.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 24.05.2023 08:13, Genevieve Chan wrote:
> ++
> 
> Hi Heiner,
> 
>  
> 
> Hope you’re doing well. I am Genevieve Chan, a linux junior software developer for RISC-V based processor. As mentioned in the email thread below, I have came across a possible issue when attempting to issue reg-init onto Page 0 Reg 4, involving advertisement register of PHY. I have stated the observation and the root cause and possible solution. Would like to ask if this proposed solution is probable and I could submit a patch for this?
> 

Please address all phylib maintainers and the netdev mailing list.

You should start with explaining why you want to set these registers,
and why via device tree. There should never be the need to manually
fiddle with C22 standard registers via device tree.

If you need a specific register initialization for a particular PHY,
then the config_init callback of the PHY driver typically is the right
place.

And no, generic code should not query vendor-specific DT properties.

>  
> 
> Thank you and have a nice day!
> 
>  
> 
> Best regards,
> 
> Genevieve Chan（陈巧艳）
> 
> Software Team, MDC
> 
> Starfive Technology Sdn. Bhd.
> 
>  
> 
> *From:*Genevieve Chan
> *Sent:* Wednesday, May 24, 2023 1:57 PM
> *To:* 'ddaney@caviumnetworks.com' <ddaney@caviumnetworks.com>
> *Subject:* Marvell_of_reg_init function
> 
>  
> 
> Hi David,
> 
>  
> 
> How are you doing? I am Genevieve Chan, a Linux Junior Software Developer for RISC-V Based Processor. I was working on GMAC driver and came across this wonderful feature you’ve enabled long ago, to modify PHY registers using device tree nodes.
> 
>  
> 
> I did try to modify a number of registers, but one 0:4 was overwritten by other config function:
> 
>  
> 
> Device tree node:
> 
>  
> 
> Output log:
> 
>  
> 
> As shown in the screenshots above, I have intended to set 0x441 to page 0 reg 4. In m88e1121_config_aneg, it got overwritten with 0xc61, in which when stepping in, it is *_due to this function_*:
> 
>  
> 
>  
> 
> *_Problem:_* If any user intend to modify page 0 register 4, it becomes redundant as it will eventually be overwritten by this function.
> 
>  
> 
> *_Here is my proposed solution:_*
> 
>   * Add in a condition if CONFIG_OF_MDIO is enabled, and check if “marvell,reg-init” node is present, then return 0, else proceed to check valid advertisement*__*
> 
> *_ _*
> 
> *_Screenshot of proposal:_*
> 
> *__*
> 
> *_ _*
> 
> *_ _*
> 
> Would like to reach out to you to gather you opinions and suggestion, if it’s okay for me to submit a patch for this.
> 
>  
> 
>  
> 
> Thank you and have a nice day!
> 
>  
> 
> Best regards,
> 
> Genevieve Chan（陈巧艳）
> 
> Software Team, MDC
> 
> Starfive Technology Sdn. Bhd.
> 
>  
> 


