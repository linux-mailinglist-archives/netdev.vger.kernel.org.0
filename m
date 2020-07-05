Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699D9214F47
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728269AbgGEU2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728244AbgGEU2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:28:43 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756A5C061794;
        Sun,  5 Jul 2020 13:28:43 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g2so21452993lfb.0;
        Sun, 05 Jul 2020 13:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ek2PpDZYRO+i/mdUnqsyt/43gJ47t+GKFxroPoIrl44=;
        b=DbuQ0P1+lRZWG9ipVNGMMZWlEIyiqoo5qz9ydQ+A2GlzRqx8OUobUKmfVaquyJjY22
         L3fNGzkoiHivKM7UhPuBOLif8ewnJp7KOnmWsNW37KDuz8G6M/v4URgeA/7Qjics8oh5
         M82Sq+gjn++3AqB8e+xGIe5EvBMUZ5VDNLScFY17jm0FlwwYaCjAkONULe2g6KP92uFR
         Tweq0BxPbxYIQvRZpOPzBFqF5RpEYJ/Td5P1YkELYvh+eu1oQ6QicPiAgsuXpVIJg4Ct
         5mujXbn2/Aq0effxGAMCiWxs3ly34OpuXwI+5fp5H1wlUp3ZgOJQKfITFN2S6fwVINzb
         uzXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ek2PpDZYRO+i/mdUnqsyt/43gJ47t+GKFxroPoIrl44=;
        b=AT4q04hSaNLSZjBiazWQ1lKzu3t6T+ZInSkEeSyIFJfAPfAWEuTAJ/bQbyAMesF4mA
         m/EEkj/wSUnnNN4VbU/QnI8OqXPkJaEc0exzBnnpup4TSTBvNwcP46SkmskxaG2H62/o
         u2heYYUj8/M6K5NbkViVyd7IVOajz6NFpB4B1urYT8EFO7xa7ohZ9U6KEhgVj8CdnQfg
         n7ic2nI7OHuMZCQGjAxqEyM7MZC3j3mHoFP9XqlFjTEYv8N6ctJiPeMq+QXlOGCR3PKV
         ojDD2ZUWPZqzfJl1wuQpkn0w2jWnjTkU1iv7t7Yjs/PNkvMAOlVIG1CGfX30lgTxIdrC
         AMzw==
X-Gm-Message-State: AOAM532s0rvF4PEnBgQJ5Wgfb1gLNvGTN4pnP6szDyrdrykYPgWnWkUh
        prBBIw3hCr3gXsGyCPWRdzs=
X-Google-Smtp-Source: ABdhPJzOPezRKUV6+afIDsMh2+sXI5DSDT5NEuBv/m9x6Ui5hMjIUKjYn+b4sx2bws3gIF8XVyXW4w==
X-Received: by 2002:ac2:54b9:: with SMTP id w25mr27959839lfk.127.1593980921790;
        Sun, 05 Jul 2020 13:28:41 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:4a1:e2b8:d584:b506:6691:9661? ([2a00:1fa0:4a1:e2b8:d584:b506:6691:9661])
        by smtp.gmail.com with ESMTPSA id e9sm7391630ljn.61.2020.07.05.13.28.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:28:41 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH/RFC] net: ethernet: ravb: Try to wake subqueue instead of
 stop on timeout
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc:     "REE dirk.behme@de.bosch.com" <dirk.behme@de.bosch.com>,
        "Shashikant.Suguni@in.bosch.com" <Shashikant.Suguni@in.bosch.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <1590486419-9289-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <TY2PR01MB369266A27D1ADF5297A3CFFCD89C0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <9f71873b-ee5e-7ae3-8a5a-caf7bf38a68e@gmail.com>
 <TY2PR01MB36926D80F2080A3D6109F11AD8980@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <TY2PR01MB36926B67ED0643A9EAA9A4F3D86E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <a1dc573d-78b0-7137-508d-efcdfa68d936@cogentembedded.com>
 <TY2PR01MB3692A9F68ACC62E920EE2965D86F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Organization: Brain-dead Software
Message-ID: <e7e5fd5f-1ed4-7699-1a1f-f4f1bb5495cf@gmail.com>
Date:   Sun, 5 Jul 2020 23:28:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB3692A9F68ACC62E920EE2965D86F0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 30.06.2020 8:22, Yoshihiro Shimoda wrote:

>>>>>>> From: Yoshihiro Shimoda, Sent: Tuesday, May 26, 2020 6:47 PM
>>>>>>>
>>>>>>> According to the report of [1], this driver is possible to cause
>>>>>>> the following error in ravb_tx_timeout_work().
>>>>>>>
>>>>>>> ravb e6800000.ethernet ethernet: failed to switch device to config mode
>>>>>>>
>>>>>>> This error means that the hardware could not change the state
>>>>>>> from "Operation" to "Configuration" while some tx queue is operating.
>>>>>>> After that, ravb_config() in ravb_dmac_init() will fail, and then
>>>>>>> any descriptors will be not allocaled anymore so that NULL porinter

    Pointer. :-)

>>>>>>> dereference happens after that on ravb_start_xmit().
>>>>>>>
>>>>>>> Such a case is possible to be caused because this driver supports
>>>>>>> two queues (NC and BE) and the ravb_stop_dma() is possible to return
>>>>>>> without any stopping process if TCCR or CSR register indicates
>>>>>>> the hardware is operating for TX.

    Maybe we should just fix those blind assumptions?

>>>>>>> To fix the issue, just try to wake the subqueue on
>>>>>>> ravb_tx_timeout_work() if the descriptors are not full instead
>>>>>>> of stop all transfers (all queues of TX and RX).
>>>>>>>
>>>>>>> [1]
>>>>>>> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
>>>>>>>
>>>>>>> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
>>>>>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>>>>>> ---
>>>>>>>     I'm guessing that this issue is possible to happen if:
>>>>>>>     - ravb_start_xmit() calls netif_stop_subqueue(), and
>>>>>>>     - ravb_poll() will not be called with some reason, and
>>>>>>>     - netif_wake_subqueue() will be not called, and then
>>>>>>>     - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().
>>>>>>>
>>>>>>>     However, unfortunately, I didn't reproduce the issue yet.
>>>>>>>     To be honest, I'm also guessing other queues (SR) of this hardware
>>>>>>>     which out-of tree driver manages are possible to reproduce this issue,
>>>>>>>     but I didn't try such environment for now...
>>>>>>>
>>>>>>>     So, I marked RFC on this patch now.
>>>>>>
>>>>>> I'm afraid, but do you have any comments about this patch?
>>>>>
>>>>>       I agree that we should now reset only the stuck queue, not both but I
>>>>> doubt your solution is good enough. Let me have another look...
>>>>
>>>> Thank you for your comment! I hope this solution is good enough...
>>>
>>> I'm sorry again and again. But, do you have any time to look this patch?
>>
>>      Yes, in the sense of reviewing -- I don't consider it complete. And no, in
>> the sense of looking into the issue myself... Can we do a per-queue tear-down
>> and re-init (not necessarily all in 1 patch)?

    In fact, it would ensue many changes...

> Thank you for your comment! I'm not sure this "re-init" mean. But, we can do

    Well, I meant the ring re-allocation and re-formatting... but (looking at 
sh_eth) the former is not really necessary, it's enough to just stop the TX 
ring and then re-format it and re-start... Well, unfortunately, the way I 
structured the code, we can't do *just* that...

> a per-queue tear-down if DMAC is still working. And, we can prepare new descriptors
> for the queue after tear-down.
> 
> < Tear-down >
> 1. Set DT_EOS to the desc_bat[queue].
> 2. Set DLR.LBAx to 1.
> 3. Check if DLA.LBAx is cleared.

    DLR.LBAx, you mean?
    Well, I was thinking of polling TCCR and CSR like the current 
ravb_stop_dma() does, but if that works...

> < Prepare new descriptors and start again >
> 4. Prepare new descriptors.

    That's where the cause for using the workqueue lies -- the descriptors are 
allocated with GFP_KERNEL, not GFP_ATOMIC... if you have time/desire to 
untangle all this, I'd appreciate it; else I'd have to work on this in my 
copious free time... :-)

> 5. Set DT_LINKFIX to the desc_bat[queue].
> 6. Set DLR.LBAx to 1.
> 7. Check if DLA.LBAx is cleared.
> 
> 
> I'm thinking doing tear-down and "re-init" of the descriptors is better
> than just try to wake the subqueue. But, what do you think?

    Definitely better, yes...

> Best regards,
> Yoshihiro Shimoda

MBR, Sergei
