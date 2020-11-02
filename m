Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 679EA2A2DEF
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 16:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbgKBPSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 10:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgKBPSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 10:18:14 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1C8C0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 07:18:13 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id j24so19335834ejc.11
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 07:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WDJQEJ1oFq73LlJA/SqjFAECrs390cw6RHVDy4xJXTo=;
        b=VHKcNGjSoUWgu0WI/wDrXMc/ZB+CUlc35gpvo9B18xeRhSs6DBIa/YAc40C0M1u8rL
         pQwQixJhg3JZhGn1UX6YPd6z9Q8UjrKy966K5ziI1HJEXUnHkAPCv4fwEOkbpCsgmImz
         JuTwwTri801r9PwOR/EzoVup5RCLbTQq/1m2VvmIuY6hGuOOQN1VSMT23UrkcDcL5047
         pSycePHjFJWeM4UcliuIIEawP4nOXBLlqpk2Jmo5PJ018CBJUDLG0k8Vlk3WBKfcPIg/
         L+KpAMtzahOYhR7Xp6CGL8y8E7v7EI7lLNT1AiKCryfmNOLAjoKfmXWlx/QTh8sHkxxn
         5vQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WDJQEJ1oFq73LlJA/SqjFAECrs390cw6RHVDy4xJXTo=;
        b=R5TGpBcWm0l6YAZaYaEwAhFZh56GFDuSkUqhBsl9FAxjG8xn+hKZAmRxeH/keyP9ZV
         bjb8Zfwr7xb2VZNwKNR6wMfzeHQGYb3t2p64pFvIiX/ssBoqefQRn0+cyFECHjJTAtfB
         QWCIyY72Tx2VgDPbB8fgaZLBdg9n2yxbfRSUK7jOFaAu5kaUAx9oitMOCjPi/pUbR6+6
         RvxzA5fTHQNFG7aOVt6fg3UHqtyL56AmBjXB0TvAiaxXf/uwr2E8l3u/Q6dMjlJJ4+H6
         8XddjTPbMlvf4KQ33+Neh1DEH9uFQPB5RPI5V+GbKaXV8XyGwsPIsS/HuwY5tq8VUt2G
         Wwqg==
X-Gm-Message-State: AOAM532G3nHFNhF0hX/j6y71loLp2L4H57oI7IskSQmzCu6v4BO8EWKz
        asrnC+4PaFuQ/scXSUxvnIGprSXMy4I=
X-Google-Smtp-Source: ABdhPJz/X7jzwsurhHnqAyEgnyxexl+U/S4f/R45AfCBtJq1cW1krlxmYdsDkQWnUFiEiWFobgpGlg==
X-Received: by 2002:a17:907:420d:: with SMTP id oh21mr7008171ejb.429.1604330292378;
        Mon, 02 Nov 2020 07:18:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:7ce1:60e1:9597:1002? (p200300ea8f2328007ce160e195971002.dip0.t-ipconnect.de. [2003:ea:8f23:2800:7ce1:60e1:9597:1002])
        by smtp.googlemail.com with ESMTPSA id i20sm10496590edv.96.2020.11.02.07.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 07:18:11 -0800 (PST)
Subject: Re: [PATCH net-next] r8169: set IRQF_NO_THREAD if MSI(X) is enabled
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <446cf5b8-dddd-197f-cb96-66783141ade4@gmail.com>
 <20201102000652.5i5o7ig56lymcjsv@skbuf>
 <b8d6e0ec-7ccb-3d11-db0a-8f60676a6f8d@gmail.com>
 <20201102124159.hw6iry2wg4ibcggc@skbuf>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e67de3a4-d65d-0bbc-d644-25d212c04fdd@gmail.com>
Date:   Mon, 2 Nov 2020 16:18:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201102124159.hw6iry2wg4ibcggc@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.11.2020 13:41, Vladimir Oltean wrote:
> On Mon, Nov 02, 2020 at 09:01:00AM +0100, Heiner Kallweit wrote:
>> As mentioned by Eric it doesn't make sense to make the minimal hard irq
>> handlers used with NAPI a thread. This more contributes to the problem
>> than to the solution. The change here reflects this.
> 
> When you say that "it doesn't make sense", is there something that is
> actually measurably worse when the hardirq handler gets force-threaded?
> Rephrased, is it something that doesn't make sense in principle, or in
> practice?
> 
> My understanding is that this is not where the bulk of the NAPI poll
> processing is done anyway, so it should not have a severe negative
> impact on performance in any case.
> 
> On the other hand, moving as much code as possible outside interrupt
> context (be it hardirq or softirq) is beneficial to some use cases,
> because the scheduler is not in control of that code's runtime unless it
> is in a thread.
> 

According to my understanding the point is that executing the simple
hard irq handler for NAPI drivers doesn't cost significantly more than
executing the default hard irq handler (irq_default_primary_handler).
Therefore threadifying it means more or less just overhead.

forced threading:
1. irq_default_primary_handler, wakes irq thread
2. threadified driver hard irq handler (basically just calling napi_schedule)
3. NAPI processing

IRQF_NO_THREAD:
1. driver hard irq handler, scheduling NAPI
2. NAPI processing

>> The actual discussion would be how to make the NAPI processing a
>> thread (instead softirq).
> 
> I don't get it, so you prefer the hardirq handler to consume CPU time
> which is not accounted for by the scheduler, but for the NAPI poll, you
> do want the scheduler to account for it? So why one but not the other?
> 

The CPU time for scheduling NAPI is neglectable, but doing all the
rx and tx work in NAPI processing is significant effort.

>> For using napi_schedule_irqoff we most likely need something like
>> if (pci_dev_msi_enabled(pdev))
>> 	napi_schedule_irqoff(napi);
>> else
>> 	napi_schedule(napi);
>> and I doubt that's worth it.
> 
> Yes, probably not, hence my question.
> 

