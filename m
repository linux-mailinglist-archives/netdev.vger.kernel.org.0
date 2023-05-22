Return-Path: <netdev+bounces-4416-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DAA670CA2A
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 22:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E66B1C20B7E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 20:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2774171CB;
	Mon, 22 May 2023 20:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E09F171A9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:00:23 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB7297
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:00:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-96f7377c86aso705595666b.1
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 13:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684785620; x=1687377620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lUUTkxDOeNQc49q1uFdzXTVNH5MDt5cKVYNrr8G3jto=;
        b=kDU2302JAvhLLtd/nPw3lYxy2dfnb9FhztPKjFYkbDd7lj6IuNPSmUi+WCbapQ4gP3
         92mVG0Q0CEsDOwR2ErlO4sKKAg0FFmA7AmDQbZsQO3xSPiPqDCMsJy1/Zuu7+QwW7Aeh
         fhzlMWvvXkBylRcqhIoCMw9s6LlNIqAb3eRPZx8zSeBWuycTz+3w/K2UCsqcSXcmRtoI
         RSEjDcc99vu8XUEKFCiXnjlY2ZMR6r3RE5+25Qgla0tY9PBZdV6YL9iDjfVjkqfiIA9+
         TEAmiCt+fWqLhLzVODOBNlvrPOLIR75/FgwrWQftQOl4zcl9PBy/sO7dtw7hjYsXOMoI
         Cx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684785620; x=1687377620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUUTkxDOeNQc49q1uFdzXTVNH5MDt5cKVYNrr8G3jto=;
        b=H14S2nCQDXqzTAdBf+2Cry9kX1RVih2ATPwr5AZU5t8ARFYtgoJs01Msq52d+fDw9C
         7LEtdzJjO2XA05hBfWVIGSHl+yey5ykGaGX4oumPlV8gJWtYPhybAPNpb+KitBFk0LBd
         4bqh3cgYTBl5/KY2oUgjE+sBkW8WPYf1INdYHyQfgGfEpgX1rRsUClbZPjfMscq+xR9P
         xupX7KI3ucog99bYVmqvtZ5JZ7D9679xMqiz7B7NzaqEAE1MQ+8gD6PMAiwyJEpoPnTW
         Cdd5YHsbHX1AgNXeKs/icoQsrECqf2LKahvfKXzc3cPKOwrrkoDZM66VWDcynfcMO1Lx
         9oFg==
X-Gm-Message-State: AC+VfDz9g2lT9fbnmrEHS6pf6yoEr2M6YgmrTXrQvMGeK9u9J5LAdILP
	q8Z47FNkoGsXtuM1qujwXENoKjUeX/8=
X-Google-Smtp-Source: ACHHUZ5rN9XB/r3/sxKEY8KEd2bTq7ddzdaYDJYdMkZo7EqEkcqobwRvIFEe58+g7ZbWxESDdn2JnA==
X-Received: by 2002:a17:907:268c:b0:961:a67:28d with SMTP id bn12-20020a170907268c00b009610a67028dmr10466187ejc.22.1684785619710;
        Mon, 22 May 2023 13:00:19 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c506:b200:dd98:9b90:4551:7dd3? (dynamic-2a01-0c23-c506-b200-dd98-9b90-4551-7dd3.c23.pool.telefonica.de. [2a01:c23:c506:b200:dd98:9b90:4551:7dd3])
        by smtp.googlemail.com with ESMTPSA id r22-20020aa7d596000000b0050b57848b01sm3250762edq.82.2023.05.22.13.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 13:00:18 -0700 (PDT)
Message-ID: <d48727e7-451a-39f4-5878-0ba957c92114@gmail.com>
Date: Mon, 22 May 2023 22:00:17 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next] r8169: Use a raw_spinlock_t for the register
 locks.
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Mike Galbraith <efault@gmx.de>, Paolo Abeni <pabeni@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, nic_swsd@realtek.com
References: <20230522134121.uxjax0F5@linutronix.de>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230522134121.uxjax0F5@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 22.05.2023 15:41, Sebastian Andrzej Siewior wrote:
> The driver's interrupt service routine is requested with the
> IRQF_NO_THREAD if MSI is available. This means that the routine is
> invoked in hardirq context even on PREEMPT_RT. The routine itself is
> relatively short and schedules a worker, performs register access and
> schedules NAPI. On PREEMPT_RT, scheduling NAPI from hardirq results in
> waking ksoftirqd for further processing so using NAPI threads with this
> driver is highly recommended since it NULL routes the threaded-IRQ
> efforts.
> 
> Adding rtl_hw_aspm_clkreq_enable() to the ISR is problematic on
> PREEMPT_RT because the function uses spinlock_t locks which become
> sleeping locks on PREEMPT_RT. The locks are only used to protect
> register access and don't nest into other functions or locks. They are
> also not used for unbounded period of time. Therefore it looks okay to
> convert them to raw_spinlock_t.
> 
> Convert the three locks which are used from the interrupt service
> routine to raw_spinlock_t.
> 
> Fixes: e1ed3e4d91112 ("r8169: disable ASPM during NAPI poll")
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> 
> This is the only ethernet driver doing IRQF_NO_THREAD. It was recently
> enabled and based on thread it was argued to offer better performance
> with threaded interrupts and NAPI threads. So I'm trying this instead of
> reverting the whole thing since it does not seem necessary. Maybe the
> NAPI-threads could some special treats, I take a look.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 44 +++++++++++------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 

Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>



