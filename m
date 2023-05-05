Return-Path: <netdev+bounces-491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0EED6F7C6D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:30:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D106C280F69
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 05:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5041C08;
	Fri,  5 May 2023 05:30:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE791876
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 05:30:42 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B72A27E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 22:30:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-957dbae98b4so202137166b.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 22:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683264639; x=1685856639;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIkcvnwuAmcyQmXPve17BqdaffE2rozwiGIlKI+pPD4=;
        b=N9vUDUS5nsZUmdSrKh+yFDHqMTJ8P9Q2SZTT4XYTaRi3rE0FpprOkDj2RNtUKbib1n
         ZOUbat3smhevHSq9vC1REDnKxpCpbWpih6M0xsvyXQsd7vBYG26+n0CFDx0O7mjPYSnc
         A8RY8yX2ZKnaLTtpc0556ozycoy64uWhPVPTT03BM/Et8T2S7Txtu5aqpeRYZj6QlCvb
         6qvc9tjK56lvq6ELJMU6ZqBcAEupjdQ1GljqxQ/QK/v1mqwy2omhlnrLn9H8sG78zvWc
         APCulgE56WpACA/DGLve3tKPyH+gGqkFrVs0qu8g2ng+4CKF0ZO093Tyi+JYBixYz8uZ
         2dSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683264639; x=1685856639;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIkcvnwuAmcyQmXPve17BqdaffE2rozwiGIlKI+pPD4=;
        b=DRuuQLBoJwrJoB7NqrVaD6KdTRHrMyOiewwK6aDCvPGqjt54W2NH6o05LOJWf1RIIV
         wTzBvzpf4otu2VGkesY7Dh0uOcDqH8RDFV7aFrpnME++w1q6kNVW/oaK5YtyqqUPBDn4
         RmsjML+p/qT5PyPhebBYLri46+vmWmyy4/OV7Lgg1biR7vbRXC1LfcUgXzvbfw8aFSZ5
         f8lJk3+nOIUjNkBMVY2EvmSpbEbkJ4bxyrSdXIFB62M2rCFgkfvQYGsXfzt9eka/MD/Z
         FccGfkBNGq3lMo3X9bzP9zZQ61eaECnyfbZzjiq4++l+FWy25zYQNQmnScFUZ9XPp6lQ
         OUVQ==
X-Gm-Message-State: AC+VfDxmX39kWlOtCrhfKLa9pMGh+/7aYnkkn/oBjiG2wL5RgTxUFeV3
	TYIozAwHt4meYWpX3xyTIGGFYwQCA7A=
X-Google-Smtp-Source: ACHHUZ5bOP8B81ImdfvH2XpcJTr0XoNfpIVR24L2XWJPO9YXwEUwjgP27dMqxh16TmwXOU5euV0WnA==
X-Received: by 2002:a17:907:268a:b0:965:d17b:26d with SMTP id bn10-20020a170907268a00b00965d17b026dmr75108ejc.35.1683264638400;
        Thu, 04 May 2023 22:30:38 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c112:d700:49ae:b252:6c1b:157b? (dynamic-2a01-0c23-c112-d700-49ae-b252-6c1b-157b.c23.pool.telefonica.de. [2a01:c23:c112:d700:49ae:b252:6c1b:157b])
        by smtp.googlemail.com with ESMTPSA id ht7-20020a170907608700b0094f71500bfesm468186ejc.4.2023.05.04.22.30.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 22:30:37 -0700 (PDT)
Message-ID: <1f150b78-4406-841d-a8cf-1ec4845ce3eb@gmail.com>
Date: Fri, 5 May 2023 07:30:36 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Richard Schneiderman <schneiderman.richard@yahoo.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <533870578.436621.1683243397555.ref@mail.yahoo.com>
 <533870578.436621.1683243397555@mail.yahoo.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: r8125b ethernet hardware
In-Reply-To: <533870578.436621.1683243397555@mail.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 05.05.2023 01:36, Richard Schneiderman wrote:
> Hi LinuxDevs,
> 
> I have a Gigabyte Aorus Elite z690 AX ddr4 board.  I'm sure you're familiar with the r8125B ethernet issues.  So on the 5.19 kernel, if i run the r8169 driver i get a disconnect pretty quicky from my ethernet, around 20 min,  If i compile the recent r8125 module from realtek, i can can just over an hour before disconnect.
> 
This sounds like you suspect a general issue on all systems with RTL8125B.
In this case we would have seen another number of reports. So it seems to
be something specific to your system.
What do you mean with "disconnect", you refer to link loss? In this case
root cause may be somewhere on the physical side, e.g. cabling,
RJ45 sockets, link partner.

> the r8169 module seems a bit longer using kernel 6.1.3, sometimes an hour.  I"m using mainline installer for ubuntu to switch kernels.
> 
Note that Ubuntu uses a modified downstream kernel that's not supported
here. Preferably compile a mainline kernel yourself.

> So hear are my questions.
> 
> 1. Will this ever be resolved?
> 2. Is RealTek working on this.  Even with the win10 drivers, i'm getting disconnects but the connection comes back immediately.  ubuntu requires a reboot.  the 10.056 windows driver seems to be the most stable.
> 
Typically the Windows driver is the one best maintained by Realtek. If you
face the issue even with this driver, then it's less likely that root cause
is an issue with the r8169 driver.

> 3.  Would you be able to set me up, so that i can be of some assistance to resolve?
> 
> Hoping to hear from you guys.
> 
> Thanks,
> Richard Schneiderman
> 


