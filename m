Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82783E5836
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbhHJKWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:22:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238996AbhHJKWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 06:22:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628590940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkEsYqcZoVzU6TDNVQwAe6gXcRO/lGHCdqvrhN4Xm2Y=;
        b=ct2/LG1vpr1AOigueB870Bk+11r0CRzPQ3S+YWKiraopHh5etcuSR7AcFpcgDu/bqyHtFF
        qs/9G1kan5IAskxxPYlABmGY1WUT/B/3RU4J3m6rkGJ0hwB8DwTI5S5LzNi7GAIkUAc4rZ
        h35Tz0fLBu/zs3SH1j24CaT0R87mBCU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-O0mez6WUNOmUH7ZRS3VLKA-1; Tue, 10 Aug 2021 06:22:19 -0400
X-MC-Unique: O0mez6WUNOmUH7ZRS3VLKA-1
Received: by mail-lf1-f71.google.com with SMTP id j6-20020ac253a60000b02903b68cc7d130so7363133lfh.16
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 03:22:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=MkEsYqcZoVzU6TDNVQwAe6gXcRO/lGHCdqvrhN4Xm2Y=;
        b=MeWT2DRnpObWketQVCfkD1BuDil6pGufIQEp4drurDxTfO35Mt4hC9jaWaHuA9fQs8
         /lSd3Xs2eXfoS/7kNU9o+Pl5ezBjcQlMWK/+G6SnmAbKklorzh4a6lUaQUyPUwzdlOXE
         XXRs8RxtmfhW0eBgcyXund9rNggIjQ8TsrLTKK/5/bIpJjcTZLmHlFsf9ju+xmNMugYE
         9DOGD8fvT3u6l7qZG8xse7G+LlVTypJY6gqxQFQHIl3cEFIc3BMt17X+rXzRqmmFP9f1
         i6HILnVnmyZo2N1CpfhyhsZ8a5CtFRLNsXyPPr09jRe9LgRc5Q/9fdGKP2PHPTyNW5mI
         pSfA==
X-Gm-Message-State: AOAM531mdbdVjo2p6oyefcMKvJyZlhQpSv/T7wgkxuU0JNhonsSX3Wb2
        LFQpc8J1Dz8mqide3vN0YUye1ah9KvoJ0APEOS/4ADe07WBTHvVGBxhZddK3/gLtVc830We0rwm
        s1apJ/WVIwLDWxp7x
X-Received: by 2002:a05:6512:4ce:: with SMTP id w14mr20952999lfq.564.1628590937384;
        Tue, 10 Aug 2021 03:22:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeOME/sPpBu8VFuHZ0Ug4EBy2Xuf7CclNO4iHVokOSSdfBU7UxnFXTEYLY/1EXT5iJSCN8Iw==
X-Received: by 2002:a05:6512:4ce:: with SMTP id w14mr20952978lfq.564.1628590936840;
        Tue, 10 Aug 2021 03:22:16 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id bu22sm1260688lfb.290.2021.08.10.03.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 03:22:16 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com
Subject: Re: Intro into qdisc writing?
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Thorsten Glaser <t.glaser@tarent.de>, netdev@vger.kernel.org
References: <1e2625bd-f0e5-b5cf-8f57-c58968a0d1e5@tarent.de>
 <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com>
Message-ID: <da23ab42-6b99-4981-97f0-3cd7a76c96b8@redhat.com>
Date:   Tue, 10 Aug 2021 12:22:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <d14be9a8-85b2-010e-16f3-cae1587f8471@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/08/2021 10.34, Eric Dumazet wrote:
> On 8/10/21 5:17 AM, Thorsten Glaser wrote:
>> Hi,
>>
>> I hope this is the right place to ask this kind of questions,
>> and not just send patches ☺
>>
>> I’m currently working with a… network simulator of sorts, which
>> has so far mostly used htb, netem, dualpi2 and fq_codel to do the
>> various tricks needed for whatever they do, but now I have rather
>> specific change requests (one of which I already implemented).
>>
>> The next things on my list basically involve delaying all traffic
>> or a subset of traffic for a certain amount of time (in the one‑ to
>> two-digit millisecond ballpark, so rather long, in CPU time). I’ve
>> seen the netem source use qdisc_watchdog_schedule_ns for this, but,
>> unlike the functions I used in my earlier module changes, I cannot
>> find any documentation for this.
>>
>> Similarily, is there an intro of sorts for qdisc writing, the things
>> to know, concepts, locking, whatever is needed?
>>
>> My background is multi-decade low-level programmer, but so far only
>> userland, libc variants and bootloaders, not kernel, and what bit of
>> kernel I touched so far was in BSD land so any pointers welcome.
>>
>> If it helps: while this is for a customer project, so far everything
>> coming out of it is published under OSS licences; mostly at
>> https://github.com/tarent/sch_jens/tree/master/sch_jens as regards
>> the kernel module (and ../jens/ for the relayfs client example) but
>> https://github.com/tarent/ECN-Bits has a related userspace project.
>>
>> Thanks in advance,
>> //mirabilos
>>
> Instead of writing a new qdisc, you could simply use FQ packet scheduler,
> and a eBPF program adjusting skb->tstamp depending on your needs.
>
> https://legacy.netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF


Good link and reference.

If you want to see some code doing this via BPF see: 
https://github.com/xdp-project/bpf-examples/blob/master/traffic-pacing-edt/

I've unfortunately not had time to document the 'traffic-pacing-edt' 
code, as this was done under time pressure, for solving a production 
problem at an ISP. They needed packet pacing or transmission smoothing 
due to switches with too small buffers to handle bursts, but as close to 
1Gbit/s as possible as they sold 1G to their customers.

The comments in the code and scripts should hopefully be enough for you 
to understand the concept. Eric's slides describe the overall concept 
and background.


The main code you want to look at is in 'edt_pacer_vlan.c' [1], but 
notice that is assumes it have lockless access to the datastructure. 
This assumption is only true because the XDP-prog in 'xdp_cpumap_qinq.c' 
[2] moves packets associated with the datastructure to the right CPU 
(and invokes/starts the normal networks stack on that CPU).


[1] 
https://github.com/xdp-project/bpf-examples/blob/master/traffic-pacing-edt/edt_pacer_vlan.c

[2] 
https://github.com/xdp-project/bpf-examples/blob/master/traffic-pacing-edt/xdp_cpumap_qinq.c


--Jesper


