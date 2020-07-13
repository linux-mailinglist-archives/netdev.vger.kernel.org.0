Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D676B21DBA4
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbgGMQ0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729027AbgGMQZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:25:59 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6832C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:25:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j19so6219703pgm.11
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SZ+lJY8bTrNCSrX9OWSAw8i2p1Pn/EowQcIFVQ4AL7s=;
        b=uB+yaLV54zBDGQzVxLXuW5CMjUprgHMB7HARUIxMZX1IaK6V2uMrepA9Q9nUeqQNDr
         hs6N//qmt6dX7/qkch1cXWOUAam9BQUVH12mVR+jJtvaoN+svMT18ICA0czXopcSSNQD
         r18Lgh6SZcfUhh+ko4ezGt2FGVELpFr3FqOf+fV2IiYEQ2Vlmuht4vDS21RaaqeiPwEM
         eauadlveWMvyicKZ5dZSwrYeG+7GSijdSaLsG5u1hVVpkLMHFDVws3ksr4KNPFPjEvKw
         C2AN6w1pLralsdrEQjDKkb1wo55x0tAqDpteJZ8Yv4Jg+BJDSm7aKs8RGl7/t8p3eKI0
         crNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SZ+lJY8bTrNCSrX9OWSAw8i2p1Pn/EowQcIFVQ4AL7s=;
        b=peD5bk6ARQcmJpHh6GC5tbwGX9+y3YnUkRhm3kMN9pNLTWeQazzQrjIno9CxV4FdPJ
         6uDp0YFGYCVC+I23gcJ2LAr7zmeT3D9HIfuAsi8n04ulr7fv+yE23xCPlaAO3Ev32zCR
         c3vr5XYV3qCTsR9E5GyXBnfExHz49hbjEKvFIM6Xsyx1XpgobcYH+Vtp+M6kjCFHs4we
         3QUJYKJ8+CZP/dEVYdlySsmUAynb4NXyABcq/wmyJwgC4xcxjPwsvmcWg98PNVGSB+c5
         q4iecDK8HZ3t5NwdJgOrsOlEaFhFthjcGRdRolsykRcV4whD1pDTgYay+b019KwuYuzM
         JArg==
X-Gm-Message-State: AOAM530W5IY6FK4i0WPaL2EqRqsOkbmMOpcYKjiQSrK8YjsHMM+pwP8k
        aTVuGPP+o2K30G4gqXGoyCs=
X-Google-Smtp-Source: ABdhPJwAcI3z26u91g4rjis/CYKQvrc5JnshFDJbAfuiesk+OjjY5B7BEVN4+gQvkv2rjJw7VPRS8A==
X-Received: by 2002:a05:6a00:1510:: with SMTP id q16mr600102pfu.164.1594657559158;
        Mon, 13 Jul 2020 09:25:59 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id j11sm14873436pfn.38.2020.07.13.09.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 09:25:58 -0700 (PDT)
Subject: Re: [PATCH V2 net-next 1/7] net: ena: avoid unnecessary rearming of
 interrupt vector when busy-polling
To:     akiyano@amazon.com, davem@davemloft.net, netdev@vger.kernel.org
Cc:     dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        shayagr@amazon.com, sameehj@amazon.com
References: <1594593371-14045-1-git-send-email-akiyano@amazon.com>
 <1594593371-14045-2-git-send-email-akiyano@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3f3cc8e6-a5fd-44f7-7a86-8862e296c40c@gmail.com>
Date:   Mon, 13 Jul 2020 09:25:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594593371-14045-2-git-send-email-akiyano@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/20 3:36 PM, akiyano@amazon.com wrote:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> In napi busy-poll mode, the kernel invokes the napi handler of the
> device repeatedly to poll the NIC's receive queues. This process
> repeats until a timeout, specific for each connection, is up.
> By polling packets in busy-poll mode the user may gain lower latency
> and higher throughput (since the kernel no longer waits for interrupts
> to poll the queues) in expense of CPU usage.
> 
> Upon completing a napi routine, the driver checks whether
> the routine was called by an interrupt handler. If so, the driver
> re-enables interrupts for the device. This is needed since an
> interrupt routine invocation disables future invocations until
> explicitly re-enabled.
> 
> The driver avoids re-enabling the interrupts if they were not disabled
> in the first place (e.g. if driver in busy mode).
> Originally, the driver checked whether interrupt re-enabling is needed
> by reading the 'ena_napi->unmask_interrupt' variable. This atomic
> variable was set upon interrupt and cleared after re-enabling it.
> 
> In the 4.10 Linux version, the 'napi_complete_done' call was changed
> so that it returns 'false' when device should not re-enable
> interrupts, and 'true' otherwise. The change includes reading the
> "NAPIF_STATE_IN_BUSY_POLL" flag to check if the napi call is in
> busy-poll mode, and if so, return 'false'.
> The driver was changed to re-enable interrupts according to this
> routine's return value.
> The Linux community rejected the use of the
> 'ena_napi->unmaunmask_interrupt' variable to determine whether
> unmasking is needed, and urged to use napi_napi_complete_done()
> return value solely.
> See https://lore.kernel.org/patchwork/patch/741149/ for more details

Yeah, and I see you did not bother to CC me on this new submission.

> 
> As explained, a busy-poll session exists for a specified timeout
> value, after which it exits the busy-poll mode and re-enters it later.
> This leads to many invocations of the napi handler where
> napi_complete_done() false indicates that interrupts should be
> re-enabled.
> This creates a bug in which the interrupts are re-enabled
> unnecessarily.
> To reproduce this bug:
>     1) echo 50 | sudo tee /proc/sys/net/core/busy_poll
>     2) echo 50 | sudo tee /proc/sys/net/core/busy_read
>     3) Add counters that check whether
>     'ena_unmask_interrupt(tx_ring, rx_ring);'
>     is called without disabling the interrupts in the first
>     place (i.e. with calling the interrupt routine
>     ena_intr_msix_io())
> 
> Steps 1+2 enable busy-poll as the default mode for new connections.
> 
> The busy poll routine rearms the interrupts after every session by
> design, and so we need to add an extra check that the interrupts were
> masked in the first place.
> 
> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 7 ++++++-
>  drivers/net/ethernet/amazon/ena/ena_netdev.h | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 91be3ffa1c5c..90c0fe15cd23 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -1913,7 +1913,9 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
>  		/* Update numa and unmask the interrupt only when schedule
>  		 * from the interrupt context (vs from sk_busy_loop)
>  		 */
> -		if (napi_complete_done(napi, rx_work_done)) {
> +		if (napi_complete_done(napi, rx_work_done) &&
> +		    READ_ONCE(ena_napi->interrupts_masked)) {
> +			WRITE_ONCE(ena_napi->interrupts_masked, false);
>  			/* We apply adaptive moderation on Rx path only.
>  			 * Tx uses static interrupt moderation.
>  			 */
> @@ -1961,6 +1963,9 @@ static irqreturn_t ena_intr_msix_io(int irq, void *data)
>  
>  	ena_napi->first_interrupt = true;
>  
> +	WRITE_ONCE(ena_napi->interrupts_masked, true);
> +	smp_wmb(); /* write interrupts_masked before calling napi */

It is not clear where is the paired smp_wmb() 

> +
>  	napi_schedule_irqoff(&ena_napi->napi);
>  
>  	return IRQ_HANDLED;
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> index ba030d260940..89304b403995 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
> @@ -167,6 +167,7 @@ struct ena_napi {
>  	struct ena_ring *rx_ring;
>  	struct ena_ring *xdp_ring;
>  	bool first_interrupt;
> +	bool interrupts_masked;
>  	u32 qid;
>  	struct dim dim;
>  };
> 

Note that writing/reading over bool fields from hard irq context without proper sync is not generally allowed.

Compiler could perform RMW over plain 32bit words.

Sometimes we accept the races, but in this context this might be bad.
