Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405FA2253AA
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 21:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgGSTU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jul 2020 15:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgGSTUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 15:20:25 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A343CC0619D2;
        Sun, 19 Jul 2020 12:20:24 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h22so17951423lji.9;
        Sun, 19 Jul 2020 12:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sD69AATEEFhB3oerj/7s8Wh1AeeNkpT/hRDGFMykfno=;
        b=o7Uc8k598H6AdeStsCjxk6fIlA9NgRLdQQ5yOC/vuxp7ZyiXK/z+EHcp5g27Te49Qp
         ytTZ8vS7L8lr/cTahtqlsnaenqchBiKvdCAedbd8BmS6vBWxKoEeW3x8ZWz+GxrMgzVy
         IP+O4UPtHu9KwSedH9dc+9HttDdGvWe5A2ZONdOBPaV7L9hkWyRhs2XzzCNW5Bx733fc
         g6ML4tZcw59//B0C7nn0P2JRRPjorWJvIyjJQmBjEci0OQCFLbgijCQYoFu8T33KwzZ9
         xv+cfG6fM97SietThEi/Jb7ss6aZbhC88aq9DlLEnkbiVTqr6cpoGOlCuvymcm7nPFkx
         BxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sD69AATEEFhB3oerj/7s8Wh1AeeNkpT/hRDGFMykfno=;
        b=HsdGOvIuONrVMoUeAsQcNAmoAk0uVkqEf9jeJ7NTehPMM+7J4yx3Zm/fBo8fW2hV5/
         Anc/KOJkcdBCNJgqbTpS1bIEzHLp5zIC/iBvfgosIVE6DAquzLBG2OQXrxLbF53nbooY
         QOKdDtuVkg1txwy7y7C8LVrfbKYbx+TVTCaaNqE92KhPIzUzb0u7kAkjWLDswjf/Kk+j
         R1zpxjmE5umpI62QsGRlqtRk2uJJVC7pwsHz+vh7q5UmC1rga8LrlSIufercdRg8z6PQ
         FNeaK5O8ht+ljw6U/BeIir/pPIimtpXM2AkfVdC7HO2Ufv3TeNh86LEXdey5PHhapavA
         iSjA==
X-Gm-Message-State: AOAM530y9dhoSWEOaR1mqShPsr8zRk0YBEhxhH9Lg3O4c5+FzmK74m7h
        PWpHKWZm76hf/MtcYrauAtZRMcxg
X-Google-Smtp-Source: ABdhPJwAWXNcHHzEJ/PxDltTe59ctJUfazSxG3nYsbVb7MCfFXpRO1CshMgSiQ04u4nyb5KGX38i/A==
X-Received: by 2002:a2e:90cc:: with SMTP id o12mr8775113ljg.231.1595186421390;
        Sun, 19 Jul 2020 12:20:21 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:46c8:7d95:c54c:ff58:cf9:a6e4])
        by smtp.gmail.com with ESMTPSA id c14sm2816916ljj.112.2020.07.19.12.20.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Jul 2020 12:20:20 -0700 (PDT)
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
 <e7e5fd5f-1ed4-7699-1a1f-f4f1bb5495cf@gmail.com>
 <TY2PR01MB3692E49BB082DEF855A3ACBAD8690@TY2PR01MB3692.jpnprd01.prod.outlook.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <64414933-c918-1613-255e-880017bc426a@gmail.com>
Date:   Sun, 19 Jul 2020 22:20:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <TY2PR01MB3692E49BB082DEF855A3ACBAD8690@TY2PR01MB3692.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   Sorry about another late reply, was having h/w issues on the new work...

On 07/06/2020 12:25 PM, Yoshihiro Shimoda wrote:

>>>>>>>>> From: Yoshihiro Shimoda, Sent: Tuesday, May 26, 2020 6:47 PM
>>>>>>>>>
>>>>>>>>> According to the report of [1], this driver is possible to cause
>>>>>>>>> the following error in ravb_tx_timeout_work().
>>>>>>>>>
>>>>>>>>> ravb e6800000.ethernet ethernet: failed to switch device to config mode
>>>>>>>>>
>>>>>>>>> This error means that the hardware could not change the state
>>>>>>>>> from "Operation" to "Configuration" while some tx queue is operating.
>>>>>>>>> After that, ravb_config() in ravb_dmac_init() will fail, and then
>>>>>>>>> any descriptors will be not allocaled anymore so that NULL porinter
>>
>>     Pointer. :-)
> 
> Oops! I should fix it :)
> 
>>>>>>>>> dereference happens after that on ravb_start_xmit().
>>>>>>>>>
>>>>>>>>> Such a case is possible to be caused because this driver supports
>>>>>>>>> two queues (NC and BE) and the ravb_stop_dma() is possible to return
>>>>>>>>> without any stopping process if TCCR or CSR register indicates
>>>>>>>>> the hardware is operating for TX.
>>
>>     Maybe we should just fix those blind assumptions?
> 
> Maybe I should have described some facts instead of assumptions like below?
> If so, I should modify the code too.
> 
> After ravb_stop_dma() was called, the driver assumed any transfers were
> stopped. However, the current ravb_tx_timeout_work() doesn't check whether
> the ravb_stop_dma() is succeeded without any error or not. So, we should
> fix it.

   Yes. Better a stuck TX queue (with a chance to recover) than kernel oops...

>>>>>>>>> To fix the issue, just try to wake the subqueue on
>>>>>>>>> ravb_tx_timeout_work() if the descriptors are not full instead
>>>>>>>>> of stop all transfers (all queues of TX and RX).
>>>>>>>>>
>>>>>>>>> [1]
>>>>>>>>> https://lore.kernel.org/linux-renesas-soc/20200518045452.2390-1-dirk.behme@de.bosch.com/
>>>>>>>>>
>>>>>>>>> Reported-by: Dirk Behme <dirk.behme@de.bosch.com>
>>>>>>>>> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
>>>>>>>>> ---
>>>>>>>>>     I'm guessing that this issue is possible to happen if:
>>>>>>>>>     - ravb_start_xmit() calls netif_stop_subqueue(), and
>>>>>>>>>     - ravb_poll() will not be called with some reason, and
>>>>>>>>>     - netif_wake_subqueue() will be not called, and then
>>>>>>>>>     - dev_watchdog() in net/sched/sch_generic.c calls ndo_tx_timeout().
>>>>>>>>>
>>>>>>>>>     However, unfortunately, I didn't reproduce the issue yet.
>>>>>>>>>     To be honest, I'm also guessing other queues (SR) of this hardware
>>>>>>>>>     which out-of tree driver manages are possible to reproduce this issue,
>>>>>>>>>     but I didn't try such environment for now...
>>>>>>>>>
>>>>>>>>>     So, I marked RFC on this patch now.
>>>>>>>>
>>>>>>>> I'm afraid, but do you have any comments about this patch?
>>>>>>>
>>>>>>>       I agree that we should now reset only the stuck queue, not both but I
>>>>>>> doubt your solution is good enough. Let me have another look...
>>>>>>
>>>>>> Thank you for your comment! I hope this solution is good enough...
>>>>>
>>>>> I'm sorry again and again. But, do you have any time to look this patch?
>>>>
>>>>      Yes, in the sense of reviewing -- I don't consider it complete. And no, in
>>>> the sense of looking into the issue myself... Can we do a per-queue tear-down
>>>> and re-init (not necessarily all in 1 patch)?
>>
>>     In fact, it would ensue many changes...
> 
> I think so.
> 
>>> Thank you for your comment! I'm not sure this "re-init" mean. But, we can do
>>
>>     Well, I meant the ring re-allocation and re-formatting... but (looking at
>> sh_eth) the former is not really necessary, it's enough to just stop the TX
>> ring and then re-format it and re-start...
> 
> I got it. I also think the ring re-allocation is not really necessary.
> 
>> Well, unfortunately, the way I
>> structured the code, we can't do *just* that...
> 
> I agree. We need refactoring for it.
> 
>>> a per-queue tear-down if DMAC is still working. And, we can prepare new descriptors
>>> for the queue after tear-down.
>>>
>>> < Tear-down >
>>> 1. Set DT_EOS to the desc_bat[queue].
>>> 2. Set DLR.LBAx to 1.
>>> 3. Check if DLA.LBAx is cleared.
>>
>>     DLR.LBAx, you mean?
> 
> Yes. I heard this procedure from BSP team.
> 
>>     Well, I was thinking of polling TCCR and CSR like the current
>> ravb_stop_dma() does, but if that works...
> 
> I'm not sure whether polling TCCR and CSR is enough or not.
> Instead of polling those registers, maybe we should poll whether
> ravb_stop_dma() is succeeded or not?

   Yes, if by polling you mean just checking the result of it. :-)

> Especially, result of ravb_config() is
> a key point whether the hardware is really stopped or not.
> So, I'm thinking that just polling the ravb_stop_dma() in
> ravb_tx_timeout_work() is better than the per-queue tear-down and
> re-init now. But, what do you think?

   I don't think it's better since we're now supposed to handle a per-queue
TX timeout (still not sure it's possible with this h/w). But of course, it's
better as it's simple enough for a bug fix.

>>> < Prepare new descriptors and start again >
>>> 4. Prepare new descriptors.
>>
>>     That's where the cause for using the workqueue lies -- the descriptors are
>> allocated with GFP_KERNEL, not GFP_ATOMIC...
> 
> IIUC, we can avoid to use the workqueue if re-allocation is not really necessary.
> 
>> if you have time/desire to
>> untangle all this, I'd appreciate it; else I'd have to work on this in my
>> copious free time... :-)
> 
> If we don't need refactoring, I think I can do it :)

   Let's go forward with the simple fix (assuming it fixes the original oops).

[...]

MBR, Sergei
