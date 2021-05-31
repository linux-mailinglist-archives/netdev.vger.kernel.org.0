Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7239683B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 21:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbhEaTHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 15:07:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbhEaTHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 15:07:09 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77B1C061574
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 12:05:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so108451wmk.1
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 12:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E5fsgcIUhtplCNbgdWogUqprk6tV7/MNmDKHXGYOLVM=;
        b=juEnkIUM7By1pRsrZ0y6f8bZUR0JM6rfu4GjMFPbpseT31oVDvYlQ5puwwbm63BjnV
         nhTID/cnBmvCeY2VbtfZzlr9za9xxzo/euRoUbaYkLKtOdrUPvv/F0S/wKIrn+MZm2ZG
         HtFscYTf2mc7WuCHZ7+vjXKLBO4n/OaMEYFyskpk2b22d5Ex/I2f/rtIIIXPxip+JAbx
         5UIX3MykV5QVpNUOWlukcco8HimL7OffF5o08FHtNO7rLieONsZ1wyenlqbvFB6a0gGq
         gGKFelLogRjDJ85/cITOMTiZdLisROaR/m+U1wQSMv11yXrxRzTnipzhq9Vy5fCADg0t
         i1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E5fsgcIUhtplCNbgdWogUqprk6tV7/MNmDKHXGYOLVM=;
        b=M20Ja7F/cNcvBkwWl8cQDIuA3PePz2etsD1ThKaIpoBhNyVU06WYoclugThapy2iL4
         Dy4/f6rZ+QWEyQ8UAyq2859noidb4MwztyRyfx9Ys1Z3pX3tsGa25A84AYHhKam2T76b
         tp5dm61yMG6sAEFJvHXE6ez3BOCa1K4Exa7JZphPbIzfD4f4arh1GnrWvBMZLtxkFrDA
         4ANnAUWO3qEbKwO0fw+Sfs5EwLoSJ1XTn4nG5Wh0MBIv8xX/Dfi+nMJD7Ehznn5nQ+gW
         +6jsGZ5ilJMDuN6ymfXLnqefrsPJFgd77YxhBPLNc+wHifVireC5GtpHYCfgOWdMan0A
         Wx7g==
X-Gm-Message-State: AOAM531aA2tlqQKSELsqivuLWzgQkkowfb59EbnhImMduciINHy8JgtG
        YM2GqmFuxSQ4FdqbYxuoqoQ=
X-Google-Smtp-Source: ABdhPJzgYsBPe+qGsVNSXx6ZrZfydTMoW1vVOJcpB2JrytJnbhfp+gRrnjyjZ9fwL351GV69ZYQaZw==
X-Received: by 2002:a1c:4d03:: with SMTP id o3mr6246850wmh.28.1622487922278;
        Mon, 31 May 2021 12:05:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:c00:fca7:2d8d:9b75:3e89? (p200300ea8f2f0c00fca72d8d9b753e89.dip0.t-ipconnect.de. [2003:ea:8f2f:c00:fca7:2d8d:9b75:3e89])
        by smtp.googlemail.com with ESMTPSA id t12sm784986wre.9.2021.05.31.12.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 May 2021 12:05:21 -0700 (PDT)
To:     Nikolai Zhubr <zhubr.2@gmail.com>, netdev <netdev@vger.kernel.org>
Cc:     Jeff Garzik <jgarzik@pobox.com>
References: <60B24AC2.9050505@gmail.com>
 <ca333156-f839-9850-6e3d-696d7b725b09@gmail.com>
 <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com>
 <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Realtek 8139 problem on 486.
Message-ID: <bf4e6e02-06ce-3001-29c8-9f0bd3f58cd8@gmail.com>
Date:   Mon, 31 May 2021 21:05:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <60B514A0.1020701@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.05.2021 18:53, Nikolai Zhubr wrote:
> Hi all,
> 
> 31.05.2021 2:17, Nikolai Zhubr:
> [...]
>> However indeed, it seems a problem was introduced with a rework of
>> interrupt handling (rtl8139_interrupt) in 2.6.3, because I have already
>> pushed all other differences from 2.6.3 to 2.6.2 and it still keeps
>> working fine.
>> My resulting minimized diff is still ~300 lines, it is too big and
>> complicated to be usefull to post here as is.
> 
> Some more input.
> 
> I was able to minimize the problematic diff to basically one screenfull, it is quite comprehencable now, and I'm including it below. It is the change in status/event handling due to a switch to NAPI that intruduced the problem.
> Now, in some more detailed tests, I observe that _receiving_ still works fine. It is _sending_ that suffers, and apparently, only when trying to send a lot at a time. In such case I see these warnings:
> 
> NETDEV WATCHDOG: eth0: transmit timed out
> eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
> 
> It looks like the queue of tx frames somehow gets messed up.
> 
> The essential diff fragment:
> ================================================
>      dev->open = rtl8139_open;
>      dev->hard_start_xmit = rtl8139_start_xmit;
> +    dev->poll = rtl8139_poll;
>      dev->weight = 64;
>      dev->stop = rtl8139_close;
>      dev->get_stats = rtl8139_get_stats;
> @@ -2015,7 +2010,7 @@
>              tp->stats.rx_bytes += pkt_size;
>              tp->stats.rx_packets++;
> 
> -            netif_rx (skb);
> +            netif_receive_skb (skb);
>          } else {
>              if (net_ratelimit())
>                  printk (KERN_WARNING
> @@ -2138,10 +2133,8 @@
>      u16 status, ackstat;
>      int link_changed = 0; /* avoid bogus "uninit" warning */
>      int handled = 0;
> -    int boguscnt = max_interrupt_work;
> 
>      spin_lock (&tp->lock);
> -    do {
>      status = RTL_R16 (IntrStatus);
> 
>      /* shared irq? */
> @@ -2169,8 +2162,14 @@
>      if (ackstat)
>          RTL_W16 (IntrStatus, ackstat);
> 
> -    if (netif_running (dev) && (status & RxAckBits))
> -        rtl8139_rx (dev, tp, 1000000000);
> +    /* Receive packets are processed by poll routine.
> +       If not running start it now. */
> +    if (status & RxAckBits){
> +        if (netif_rx_schedule_prep(dev)) {
> +            RTL_W16_F (IntrMask, rtl8139_norx_intr_mask);
> +            __netif_rx_schedule (dev);
> +        }
> +    }
> 
>      /* Check uncommon events with one test. */
>      if (unlikely(status & (PCIErr | PCSTimeout | RxUnderrun | RxErr)))
> @@ -2182,16 +2181,6 @@
>          if (status & TxErr)
>              RTL_W16 (IntrStatus, TxErr);
>      }
> -    boguscnt--;
> -    } while (boguscnt > 0);
> -
> ================================================
> 
> 
> Thank you,
> 
> Regards,
> Nikolai
> 
> 
> 
>>
>>
Issue could be related to rx and tx processing now potentially running in parallel.
I only have access to the current 8139too source code, hopefully the following
works on the old version:

In the end of rtl8139_start_xmit() there's
if ((tp->cur_tx - NUM_TX_DESC) == tp->dirty_tx)
		netif_stop_queue (dev);

Try changing this to

if (tp->cur_tx - NUM_TX_DESC == tp->dirty_tx) {
	smp_wmb();
	netif_stop_queue (dev);
	smp_mb__after_atomic();       /* if this doesn't exist yet, use mb() */
	if (tp->cur_tx - NUM_TX_DESC != tp->dirty_tx)
		netif_start_queue(dev);
}


And at the end of rtl8139_tx_interrupt() change

	if (tp->dirty_tx != dirty_tx) {
		tp->dirty_tx = dirty_tx;
		mb();
		netif_wake_queue (dev);
	}

to

	if (tp->dirty_tx != dirty_tx) {
		tp->dirty_tx = dirty_tx;
		mb();
		if (netif_queue_stopped(dev) && tp->cur_tx - NUM_TX_DESC != tp->dirty_tx)
			netif_wake_queue (dev);
	}
