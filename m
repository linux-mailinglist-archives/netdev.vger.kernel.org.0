Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5731D322E56
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhBWQGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbhBWQGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 11:06:19 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C925C06178A
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 08:05:38 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id 74so2144044iob.0
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 08:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qp39F608telK2g5bl2vnH3DV36nCXGkIBvfuxBxCEpY=;
        b=Fc5JL2D74YRtPChhudq6t+o1f9MaKKi0XlmCIBRl9Nb9+83049FLi9RX5ILEingifB
         iDeeO2qENKsoDyvLmOpm/9LEKPg4VlXj69JSymwOTlw2m07mmiFkYNvWRosyNfxhNNi1
         VBiaQp9WMVqPK/Om3Ue+HMFISRBNBYltEArzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qp39F608telK2g5bl2vnH3DV36nCXGkIBvfuxBxCEpY=;
        b=Dc+lwcDelxiE3ZrQOseh8/7TKFSQYA0WVj8ap9xoekBRCGGyT3mrlFMT/8Bkv1ZfPN
         mffNicXRRzyeYttTaLF/Sp5c8JKv4WJNYhrWPy620kVjHx3KJBzT+yc9tsAf7KX9gjQc
         gZE8yfwjXwM3pcEzbvoWp4PB0t1FQhYp6PBwgZKZ0g9peWy//jCSj5neJncNcMUxMAR4
         +iYrKESekPDDS2Jda+bVBSUKNC9NrU+Q4nKGbz8+4t4hGQ2roCp7bJNdXaGIOcjdYrgz
         ni90t111kDBkJqs63/HBs0spxXJa15xSIH6dGtuu5Ko8aSkX4sYpszTKkx7v17ekqxqL
         E2wQ==
X-Gm-Message-State: AOAM533yKy/6vSSK8pE3p9WbtZuxQ21TAB6O9398JwrO0mwcOfcRjwgb
        j3JtnaPdThYeDr/25BFpzzkiXbRAtqrjcQ==
X-Google-Smtp-Source: ABdhPJyCtLBbrhnuCswxsSSKtEbIVZs8PMT6HfXbak31SxSBn5MDXpSC4e9rcFyuUuZVPvBGFxcGiQ==
X-Received: by 2002:a5d:8ac5:: with SMTP id e5mr19743306iot.33.1614096337331;
        Tue, 23 Feb 2021 08:05:37 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id s14sm3978152ilj.83.2021.02.23.08.05.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 08:05:36 -0800 (PST)
Subject: Re: [PATCH] drivers: ipa: Add missing IRQF_ONESHOT
To:     Yang Li <yang.lee@linux.alibaba.com>, elder@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1614071362-123210-1-git-send-email-yang.lee@linux.alibaba.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <d57e0a43-4d87-93cf-471c-c8185ea85ced@ieee.org>
Date:   Tue, 23 Feb 2021 10:05:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1614071362-123210-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/23/21 3:09 AM, Yang Li wrote:
> fixed the following coccicheck:
> ./drivers/net/ipa/ipa_smp2p.c:186:7-27: ERROR: Threaded IRQ with no
> primary handler requested without IRQF_ONESHOT
> 
> Make sure threaded IRQs without a primary handler are always request
> with IRQF_ONESHOT

SMP2P interrupts are handled as nested interrupts.  The hard
handler for a registered SMP2P interrupt is never called, and
is in fact ignored (it should really be NULL when registering).

The "main" SMP2P interrupt handler is a ONESHOT threaded
interrupt handler, and all registered SMP2P interrupts are
handled within (called by) that main handler thread function.

It is not *necessary* to provide the IRQF_ONESHOT flag when
registering an SMP2P interrupt handler.  I don't think it
does real harm to add it, but unless I'm mistaken, the
interrupt handling is actually simpler if ONESHOT is *not*
set in this case.

I could be convinced otherwise, but until I would rather
not accept this patch.

					-Alex

> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>   drivers/net/ipa/ipa_smp2p.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
> index a5f7a79..1149ed8 100644
> --- a/drivers/net/ipa/ipa_smp2p.c
> +++ b/drivers/net/ipa/ipa_smp2p.c
> @@ -183,7 +183,7 @@ static int ipa_smp2p_irq_init(struct ipa_smp2p *smp2p, const char *name,
>   	}
>   	irq = ret;
>   
> -	ret = request_threaded_irq(irq, NULL, handler, 0, name, smp2p);
> +	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT, name, smp2p);
>   	if (ret) {
>   		dev_err(dev, "error %d requesting \"%s\" IRQ\n", ret, name);
>   		return ret;
> 

