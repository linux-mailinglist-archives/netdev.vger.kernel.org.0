Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1058FD9A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfHPITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:19:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37770 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbfHPITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 04:19:37 -0400
Received: by mail-wr1-f67.google.com with SMTP id z11so726734wrt.4;
        Fri, 16 Aug 2019 01:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ih81cmjP0TC8sbhrB1z4mmZ7XiZ/5cGAXydJGdybczA=;
        b=Oh3cq/rHUzrBEdvWDyyFt4lkYBIvp+bttTvqetWMAWHLDk27z1aiLJTkRxQk6Ljdf1
         ClmDxc+7ndRFnTdkLESApMPsBMZ76HPcTMYzKLDC+EFj6M53fUkbsQmRdqdSgZWTkypO
         D+TLLgoEWO6OWHkEiOqmKbBwxlLKzDnLU0h6gdpYzfRpQ7ajuz9+65lqHBLHOy8YUnos
         v1FuXUMnNA1dQKQf0bFPf2I6lr22dWOdYUMScV+ClLIA204YeP8daFLWIp5S293H4wRw
         xVxtBJrjFqrHtc4rJzkh0t5aTtfSVrjzE+FYU4JnA30pdvZOcb/jUdl1zrk+TwBtP05N
         Rjag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ih81cmjP0TC8sbhrB1z4mmZ7XiZ/5cGAXydJGdybczA=;
        b=ouq5BPVADzNsBsdTFom7IucFQVgTvxcfGIFzQor21U8WmI1wOwVIrQluWCIFYJFYHN
         RMCnzAQnT/gPHrzJ8a38IDe2NakLyteuytZNAbExRtMHYDAkjmcr8pRxXgfisZ65A52u
         +NL6TrkK53HWaOTQu5KCk/+B1qU61JJOXM1Ll5VHDsNQLkI42UpJ5HlC+Wt2BOguugOD
         QUaj/3cpcFmOLI609g8T5f1Z/S8ABZ2PvsxAhYxcVTJu9HpTzLGkG0OaBKhoiAkLHQbw
         Oa1ELAHEYbGsj/GV0ZWLmbAPI32Eh/R/W8Un3uoE1e2JG5bo9CI6hkWGN9sgEGuCEjA7
         fwRA==
X-Gm-Message-State: APjAAAW64gd0Mq8N9EQ0uRznIi0S1yb9y7FX/3C+WvBSVF2xP6DfoUhK
        nV87/xOVupB2t/AAP3UgpFd3tRiW
X-Google-Smtp-Source: APXvYqxqGnWs+sGNRtQVxsclqeR5R2BGunevD+LeIHpgnoJFi3Pkom2JraUkBslO/eu3Hvtgmne7wQ==
X-Received: by 2002:a5d:4b41:: with SMTP id w1mr8605097wrs.23.1565943575268;
        Fri, 16 Aug 2019 01:19:35 -0700 (PDT)
Received: from [192.168.8.147] (187.170.185.81.rev.sfr.net. [81.185.170.187])
        by smtp.gmail.com with ESMTPSA id s64sm7336977wmf.16.2019.08.16.01.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 01:19:34 -0700 (PDT)
Subject: Re: [PATCH net-next] r8152: divide the tx and rx bottom functions
To:     Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1394712342-15778-301-Taiwan-albertk@realtek.com>
 <9749764d-7815-b673-0fc4-22475601efec@gmail.com>
 <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <68015004-fb60-f6c6-05b0-610466223cf5@gmail.com>
Date:   Fri, 16 Aug 2019 10:19:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB2F18D470D@RTITMBSVM03.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/19 10:10 AM, Hayes Wang wrote:
> Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> Sent: Friday, August 16, 2019 2:40 PM
> [...]
>> tasklet and NAPI are scheduled on the same core (the current
>> cpu calling napi_schedule() or tasklet_schedule())
>>
>> I would rather not add this dubious tasklet, and instead try to understand
>> what is wrong in this driver ;)
>>
>> The various napi_schedule() calls are suspect IMO.
> 
> The original method as following.
> 
> static int r8152_poll(struct napi_struct *napi, int budget)
> {
> 	struct r8152 *tp = container_of(napi, struct r8152, napi);
> 	int work_done;
> 
> 	work_done = rx_bottom(tp, budget); <-- RX
> 	bottom_half(tp); <-- Tx (tx_bottom)
> 	[...]
> 
> The rx_bottom and tx_bottom would only be called in r8152_poll.
> That is, tx_bottom wouldn't be run unless rx_bottom is finished.
> And, rx_bottom would be called if tx_bottom is running.
> 
> If the traffic is busy. rx_bottom or tx_bottom may take a lot
> of time to deal with the packets. And the one would increase
> the latency time for the other one.
> 
> Therefore, when I separate the tx_bottom and rx_bottom to
> different tasklet and napi, the callback functions of tx and
> rx may schedule the tasklet and napi to different cpu. Then,
> the rx_bottom and tx_bottom may be run at the same time.


Your patch makes absolutely no guarantee of doing what you
want, I am afraid.

> 
> Take our arm platform for example. There are five cpus to
> handle the interrupt of USB host controller. When the rx is
> completed, cpu #1 may handle the interrupt and napi would
> be scheduled. When the tx is finished, cpu #2 may handle
> the interrupt and the tasklet is scheduled. Then, napi is
> run on cpu #1, and tasklet is run on cpu #2.
> 
>> Also rtl8152_start_xmit() uses skb_queue_tail(&tp->tx_queue, skb);
>>
>> But I see nothing really kicking the transmit if tx_free is empty ?
> 
> Tx callback function "write_bulk_callback" would deal with it.
> The callback function would check if there are packets waiting
> to be sent.

Which callback ?

After an idle period (no activity, no prior packets being tx-completed ...),
a packet is sent by the upper stack, enters the ndo_start_xmit() of a network driver.

This driver ndo_start_xmit() simply adds an skb to a local list, and returns.

Where/how is scheduled this callback ?

Some kind of timer ?
An (unrelated) incoming packet ?

> 
> 
> Best Regards,
> Hayes
> 
> 
