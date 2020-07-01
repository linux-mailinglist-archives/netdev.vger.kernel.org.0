Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259EB210579
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 09:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgGAHxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 03:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgGAHxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 03:53:12 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82E2C03E979
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 00:53:11 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id b25so22207878ljp.6
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 00:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netrounds-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I6jje35VsFRz6jv7tvpP0AVIpIT82ru81cthZO6pOyk=;
        b=DNLvKr7NzJdvQ6C1tcqcsopb9P2bnSZ/vPIzAWH83R3MBzDBd1xAZFodpLQhZAzi8z
         E/f+CgW49DF+EW1/tHXJJnmHN7zFxUXxRZuhWLIbNaGYhaCpC4Gs3TihgcNtyrVW/JUB
         OOUuFiitfji0VQqOG3AP5WKjtQXkuh+sTQXmYN+gggPvIFY+xeP7SyUEe3l6auf3mS/v
         SGE2tAy4ZbD3h5WugmEeFL1JDpxl/sUtIEBAR9rd6Jk1kWe9JR+TwQyQzfpUlWZBO4dQ
         teNME//+EqrfAT1votBU0CJoLL8OvMpOwgeP6/RXXcaX77uNCVt5HeSLpvUpz2RGFBV4
         30sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I6jje35VsFRz6jv7tvpP0AVIpIT82ru81cthZO6pOyk=;
        b=OthJjCZXsYzt2+60ad2XBL1I/ExOt/A9c3HTeHGtmH03SHH/Enpi2RdTrfA9mIbBvB
         0w+b4YOP+0fTgG4aPYJQWngtZaGGXAGdi2mDUssFMVPevopbDJLTgBtZlBDP+2QyJpYx
         c5zjXKkDtWzbdvJARkCdYcEab0Z6xM1hYJVtWiHQPEYTMQro7lwf5yYP0rrDvTXfKLSG
         LNe2VD1Yy2WFPnogdy/JOG76ICC7PrJrE0vu6nvP3W12m875UITEmVezzPl/D/zz4qHY
         YuiFdEHnWo3F69BPGecTnh/hKeLQ2mzWQG5qIiLmKL20K4KfFpdELjqXsNPpyxFEBth+
         IsVA==
X-Gm-Message-State: AOAM530K/coQNsIdomOfixA47G5FpnPM1kfxofwGKYuB7jJ5Z99wO6Ip
        J+dFP5OLZTm6pYowtrmypFgQKxTkXUFJeQ==
X-Google-Smtp-Source: ABdhPJxdpz2tH01kb7IckiV9kCoNsYzBpgZRoMzs31iw6kmyzx6gY/hJX32NMHyZhhshivQdrF9htA==
X-Received: by 2002:a2e:81c4:: with SMTP id s4mr9535420ljg.284.1593589989902;
        Wed, 01 Jul 2020 00:53:09 -0700 (PDT)
Received: from [10.0.155.59] ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id e13sm1392521lfs.33.2020.07.01.00.53.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 00:53:09 -0700 (PDT)
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Josh Hunt <johunt@akamai.com>, pabeni@redhat.com
Cc:     Michael Zhivich <mzhivich@akamai.com>, davem@davemloft.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com>
 <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
From:   Jonas Bonn <jonas.bonn@netrounds.com>
Message-ID: <2a9ae83f-abd8-1985-d84f-743e594c1189@netrounds.com>
Date:   Wed, 1 Jul 2020 09:53:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30/06/2020 21:14, Josh Hunt wrote:
> On 6/23/20 6:42 AM, Michael Zhivich wrote:
>>> From: Jonas Bonn <jonas.bonn@netrounds.com>
>>> To: Paolo Abeni <pabeni@redhat.com>,
>>>     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
>>>     LKML <linux-kernel@vger.kernel.org>,
>>>     "David S . Miller" <davem@davemloft.net>,
>>>     John Fastabend <john.fastabend@gmail.com>
>>> Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
>>> Date: Fri, 11 Oct 2019 02:39:48 +0200
>>> Message-ID: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com> (raw)
>>> In-Reply-To: <95c5a697932e19ebd6577b5dac4d7052fe8c4255.camel@redhat.com>
>>>
>>> Hi Paolo,
>>>
>>> On 09/10/2019 21:14, Paolo Abeni wrote:
>>>> Something alike the following code - completely untested - can possibly
>>>> address the issue, but it's a bit rough and I would prefer not adding
>>>> additonal complexity to the lockless qdiscs, can you please have a spin
>>>> a it?
>>>
>>> We've tested a couple of variants of this patch today, but unfortunately
>>> it doesn't fix the problem of packets getting stuck in the queue.
>>>
>>> A couple of comments:
>>>
>>> i) On 5.4, there is the BYPASS path that also needs the same treatment
>>> as it's essentially replicating the behavour of qdisc_run, just without
>>> the queue/dequeue steps
>>>
>>> ii)  We are working a lot with the 4.19 kernel so I backported to the
>>> patch to this version and tested there.  Here the solution would seem to
>>> be more robust as the BYPASS path does not exist.
>>>
>>> Unfortunately, in both cases we continue to see the issue of the "last
>>> packet" getting stuck in the queue.
>>>
>>> /Jonas
>>
>> Hello Jonas, Paolo,
>>
>> We have observed the same problem with pfifo_fast qdisc when sending 
>> periodic small
>> packets on a TCP flow with multiple simultaneous connections on a 4.19.75
>> kernel.  We've been able to catch it in action using perf probes (see 
>> trace
>> below).  For qdisc = 0xffff900d7c247c00, skb = 0xffff900b72c334f0,
>> it takes 200270us to traverse the networking stack on a system that's 
>> not otherwise busy.
>> qdisc only resumes processing when another enqueued packet comes in,
>> so the packet could have been stuck indefinitely.
>>
>>     proc-19902 19902 [032] 580644.045480: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0xffff900bfc294af0 band=2 atomic_qlen=0
>>     proc-19902 19902 [032] 580644.045480:     
>> probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 
>> skb=0xffffffff9b69d8c0 band=2
>>     proc-19927 19927 [014] 580644.045480:      
>> probe:tcp_transmit_skb2: (ffffffff9b6dc4e5) skb=0xffff900b72c334f0 
>> sk=0xffff900d62958040 source=0x4b4e dest=0x9abe
>>     proc-19902 19902 [032] 580644.045480: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
>>     proc-19927 19927 [014] 580644.045481:      
>> probe:ip_finish_output2: (ffffffff9b6bc650) net=0xffffffff9c107c80 
>> sk=0xffff900d62958040 skb=0xffff900b72c334f0 __func__=0x0
>>     proc-19902 19902 [032] 580644.045481:        
>> probe:sch_direct_xmit: (ffffffff9b69e570) skb=0xffff900bfc294af0 
>> q=0xffff900d7c247c00 dev=0xffff900d6a140000 txq=0xffff900d6a181180 
>> root_lock=0x0 validate=1 ret=-1 again=155
>>     proc-19927 19927 [014] 580644.045481:            
>> net:net_dev_queue: dev=eth0 skbaddr=0xffff900b72c334f0 len=115
>>     proc-19902 19902 [032] 580644.045482:     
>> probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 
>> skb=0xffffffff9b69d8c0 band=1
>>     proc-19927 19927 [014] 580644.045483:     
>> probe:pfifo_fast_enqueue: (ffffffff9b69d9f0) skb=0xffff900b72c334f0 
>> qdisc=0xffff900d7c247c00 to_free=18446622925407304000
>>     proc-19902 19902 [032] 580644.045483: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
>>     proc-19927 19927 [014] 580644.045483: 
>> probe:pfifo_fast_enqueue_end: (ffffffff9b69da9f) 
>> skb=0xffff900b72c334f0 qdisc=0xffff900d7c247c00 
>> to_free=0xffff91d0f67ab940 atomic_qlen=1
>>     proc-19902 19902 [032] 580644.045484:          
>> probe:__qdisc_run_2: (ffffffff9b69ea5a) q=0xffff900d7c247c00 packets=1
>>     proc-19927 19927 [014] 580644.245745:     
>> probe:pfifo_fast_enqueue: (ffffffff9b69d9f0) skb=0xffff900d98fdf6f0 
>> qdisc=0xffff900d7c247c00 to_free=18446622925407304000
>>     proc-19927 19927 [014] 580644.245745: 
>> probe:pfifo_fast_enqueue_end: (ffffffff9b69da9f) 
>> skb=0xffff900d98fdf6f0 qdisc=0xffff900d7c247c00 
>> to_free=0xffff91d0f67ab940 atomic_qlen=2
>>     proc-19927 19927 [014] 580644.245746:     
>> probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 
>> skb=0xffffffff9b69d8c0 band=0
>>     proc-19927 19927 [014] 580644.245746: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0xffff900b72c334f0 band=2 atomic_qlen=1
>>     proc-19927 19927 [014] 580644.245747:     
>> probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 
>> skb=0xffffffff9b69d8c0 band=2
>>     proc-19927 19927 [014] 580644.245747: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0xffff900d98fdf6f0 band=2 atomic_qlen=0
>>     proc-19927 19927 [014] 580644.245748:     
>> probe:pfifo_fast_dequeue: (ffffffff9b69d8c0) qdisc=0xffff900d7c247c00 
>> skb=0xffffffff9b69d8c0 band=2
>>     proc-19927 19927 [014] 580644.245748: 
>> probe:pfifo_fast_dequeue_end: (ffffffff9b69d99d) 
>> qdisc=0xffff900d7c247c00 skb=0x0 band=3 atomic_qlen=0
>>     proc-19927 19927 [014] 580644.245749:          
>> qdisc:qdisc_dequeue: dequeue ifindex=5 qdisc handle=0x0 parent=0xF 
>> txq_state=0x0 packets=2 skbaddr=0xffff900b72c334f0
>>     proc-19927 19927 [014] 580644.245749:        
>> probe:sch_direct_xmit: (ffffffff9b69e570) skb=0xffff900b72c334f0 
>> q=0xffff900d7c247c00 dev=0xffff900d6a140000 txq=0xffff900d6a181180 
>> root_lock=0x0 validate=1 ret=-1 again=155
>>     proc-19927 19927 [014] 580644.245750:       
>> net:net_dev_start_xmit: dev=eth0 queue_mapping=14 
>> skbaddr=0xffff900b72c334f0 vlan_tagged=0 vlan_proto=0x0000 
>> vlan_tci=0x0000 protocol=0x0800 ip_summed=3 len=115 data_len=0 
>> network_offset=14 transport_offset_valid=1 transport_offset=34 
>> tx_flags=0 gso_size=0 gso_segs=1 gso_type=0x1
>>
>> I was wondering if you had any more luck in finding a solution or 
>> workaround for this problem
>> (that is, aside from switching to a different qdisc)?
>>
>> Thanks,
>> ~ Michael
>>
> 
> Jonas/Paolo
> 
> Do either of you know if there's been any development on a fix for this 
> issue? If not we can propose something.

Hi Josh,

No, I haven't been able to do any more work on this and the affected 
user switched qdisc (to avoid this problem) so I lost the reliable 
reproducer that I had...

/Jonas

> 
> Thanks
> Josh
