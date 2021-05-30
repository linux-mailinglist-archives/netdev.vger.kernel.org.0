Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7907F394F0D
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 05:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhE3DXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 23:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhE3DXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 23:23:36 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C8EC061574;
        Sat, 29 May 2021 20:21:59 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id h11so6939502ili.9;
        Sat, 29 May 2021 20:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9AEjPwmoanhxhl/4ZSEBznbLBkCR/LXMU3xQfCQv0BM=;
        b=WpU7DU6vYzkH/Oc5oaix4Wn3/z8Icwol6KjkUB/qogxd57gK19KzULE9PoAi8LmiJ6
         WauSelVJGVsSddCluLyzcBS83MOZ7ZHndDahIuGAYbwB7oqYjtu3CrXf/g49H6NZx1Jq
         pb1Rs6cAyI9S6Tz9XFaQmy592rv8AeWdQPF0Kips2yDjhZQLhjMFDlSQUiD9t5GjOqsU
         TbzQMcgmChfhJUK56OuPuxBKz/alr3QPf9vtwyGpd+i7FB3/KAQ7PZEaEFvASie1nV8w
         DrGt3M016oE8Nzc3w5PM3vNE+9is+X6kbXVfrf6UIzCshr16fu87ZtbWWWaXMVX8zz5i
         rqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AEjPwmoanhxhl/4ZSEBznbLBkCR/LXMU3xQfCQv0BM=;
        b=FoGYiJEJuFVnyVR7e8EBaNHTR6LkKX6Ouc/j+ej7dbWeVNnBrEFWISQpBfQ7jf4Ps1
         f9SR/Xs18vhnmhILnEoPhjWRGv906b1KEt9wyKKQSUcKUzR/jJhzaaov6YJS+yUVl1M0
         CF+H3vDRE7hTjQgoztIYETUcOv79KYoTeMqBDJCOpjsU9wPC4hI35Hm368xMnIYCIwu1
         QWPAZ8iqSN64aGum3xjCdmH8ZDRBbWqvsQ72EWAF1yc0A1R17jXY0EiJIbUcuTSc2g7j
         vYb48UBv4pc2zhKWYiR7ev1qtT9oNsjGI9nPMcuzGPWL3OFO2rYXO3/5hkHnZ/x8t1JD
         DWow==
X-Gm-Message-State: AOAM532AQYbJpbP+LFhXTXtfbQhC6cSBfcUBnvVzckBXNjYV1L56O/un
        QYNW4AX0jfFazhIJCaNIzwDe3ywAgw+Lh2rLMko=
X-Google-Smtp-Source: ABdhPJwcQuaDcE2zy4B/pEdJ2JsfOmiUFawznd72jKAbDd3GYSIM3y3FTCzNvtbd3/SEolbWD7XHMQ==
X-Received: by 2002:a63:1d61:: with SMTP id d33mr15973946pgm.331.1622338643906;
        Sat, 29 May 2021 18:37:23 -0700 (PDT)
Received: from [192.168.1.16] ([120.229.69.188])
        by smtp.gmail.com with ESMTPSA id x15sm211010pfp.79.2021.05.29.18.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 May 2021 18:37:23 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net: sched: implement TCQ_F_CAN_BYPASS for
 lockless qdisc
To:     Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, olteanv@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, andriin@fb.com, edumazet@google.com,
        weiwan@google.com, cong.wang@bytedance.com, ap420073@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, mkl@pengutronix.de,
        linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com, hdanton@sina.com, jgross@suse.com,
        JKosina@suse.com, mkubecek@suse.cz, bjorn@kernel.org,
        alobakin@pm.me
References: <1622170197-27370-1-git-send-email-linyunsheng@huawei.com>
 <1622170197-27370-3-git-send-email-linyunsheng@huawei.com>
 <20210528180012.676797d6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <a6a965ee-7368-d37b-9c70-bba50c67eec9@huawei.com>
 <20210528213218.2b90864c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <ee1a62da-9758-70db-abd3-c5ca2e8e0ce0@huawei.com>
 <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <9cc9f513-7655-07df-3c74-5abe07ae8321@gmail.com>
Date:   Sun, 30 May 2021 09:37:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210529114919.4f8b1980@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/30 2:49, Jakub Kicinski wrote:
> On Sat, 29 May 2021 15:03:09 +0800 Yunsheng Lin wrote:
>> On 2021/5/29 12:32, Jakub Kicinski wrote:
>>> On Sat, 29 May 2021 09:44:57 +0800 Yunsheng Lin wrote:  
>>>> MISSED is only set when there is lock contention, which means it
>>>> is better not to do the qdisc bypass to avoid out of order packet
>>>> problem,   
>>>
>>> Avoid as in make less likely? Nothing guarantees other thread is not
>>> interrupted after ->enqueue and before qdisc_run_begin().
>>>
>>> TBH I'm not sure what out-of-order situation you're referring to,
>>> there is no ordering guarantee between separate threads trying to
>>> transmit AFAIU.  
>> A thread need to do the bypass checking before doing enqueuing, so
>> it means MISSED is set or the trylock fails for the bypass transmiting(
>> which will set the MISSED after the first trylock), so the MISSED will
>> always be set before a thread doing a enqueuing, and we ensure MISSED
>> only be cleared during the protection of q->seqlock, after clearing
>> MISSED, we do anther round of dequeuing within the protection of
>> q->seqlock.
> 
> The fact that MISSED is only cleared under q->seqlock does not matter,
> because setting it and ->enqueue() are not under any lock. If the thread
> gets interrupted between:
> 
> 	if (q->flags & TCQ_F_CAN_BYPASS && nolock_qdisc_is_empty(q) &&
> 	    qdisc_run_begin(q)) {
> 
> and ->enqueue() we can't guarantee that something else won't come in,
> take q->seqlock and clear MISSED.
> 
> thread1                thread2             thread3
> # holds seqlock
>                        qdisc_run_begin(q)
>                        set(MISSED)
> pfifo_fast_dequeue
>   clear(MISSED)
>   # recheck the queue
> qdisc_run_end()
>                        ->enqueue()
>                                             q->flags & TCQ_F_CAN_BYPASS..
>                                             qdisc_run_begin() # true
>                                             sch_direct_xmit()
>                        qdisc_run_begin()
>                        set(MISSED)
> 
> Or am I missing something?
> 
> Re-checking nolock_qdisc_is_empty() may or may not help.
> But it doesn't really matter because there is no ordering
> requirement between thread2 and thread3 here.

I were more focued on explaining that using MISSED is reliable
as sch_may_need_requeuing() checking in RFCv3 [1] to indicate a
empty qdisc, and forgot to mention the data race described in
RFCv3, which is kind of like the one described above:

"There is a data race as below:

      CPU1                                   CPU2
qdisc_run_begin(q)                            .
        .                                q->enqueue()
sch_may_need_requeuing()                      .
    return true                               .
        .                                     .
        .                                     .
    q->enqueue()                              .

When above happen, the skb enqueued by CPU1 is dequeued after the
skb enqueued by CPU2 because sch_may_need_requeuing() return true.
If there is not qdisc bypass, the CPU1 has better chance to queue
the skb quicker than CPU2.

This patch does not take care of the above data race, because I
view this as similar as below:

Even at the same time CPU1 and CPU2 write the skb to two socket
which both heading to the same qdisc, there is no guarantee that
which skb will hit the qdisc first, becuase there is a lot of
factor like interrupt/softirq/cache miss/scheduling afffecting
that."

Does above make sense? Or any idea to avoid it?

1. https://patchwork.kernel.org/project/netdevbpf/patch/1616404156-11772-1-git-send-email-linyunsheng@huawei.com/

> 
>> So if a thread has taken the q->seqlock and the MISSED is not set yet,
>> it is allowed to send the packet directly without going through the
>> qdisc enqueuing and dequeuing process.
>>
>>> IOW this check is not required for correctness, right?  
>>
>> if a thread has taken the q->seqlock and the MISSED is not set, it means
>> other thread has not set MISSED after the first trylock and before the
>> second trylock, which means the enqueuing is not done yet.
>> So I assume the this check is required for correctness if I understand
>> your question correctly.
>>
>>>> another good thing is that we could also do the batch
>>>> dequeuing and transmiting of packets when there is lock contention.  
>>>
>>> No doubt, but did you see the flag get set significantly often here 
>>> to warrant the double-checking?  
>>
>> No, that is just my guess:)
> 
> 
