Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D21CD6CD87
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 13:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390134AbfGRLmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 07:42:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35188 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRLmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 07:42:22 -0400
Received: by mail-wr1-f68.google.com with SMTP id y4so28349228wrm.2;
        Thu, 18 Jul 2019 04:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PijpInlE527a+rdVTufMG3rRmIKSIHorWYltr+6jmWw=;
        b=d0JfECyQz/eVERxa6e933a9px4BcGK/gQW5oTRoegQHxucAA5S3QUqenPuR6ok7Vpv
         ZhE0WGFTcBVCUx6hLX6jOoq2xVFKHhkb3l3xSv8fN00pe0NmB2jsiGP7R4ZoLL3SeRPE
         mKGJ9UnWpOdbwI8NJ8+NiDONoY451zNJPBEt9gMFawqhmhOevSBUUglEoA/9fuwx1hWM
         d7jaDXDpvOjPdWByyXNj0CUUBo7LTp2aS6H34PBj7ioOEH7B6Usw4/6R1BJb6cE+FTnm
         LV0m5qUOrowf2pZGpnLNwVeesTgLxVCBowYp9TuwiWyKdCso/v1oB5bJoNOLO0q3Dp9W
         DMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PijpInlE527a+rdVTufMG3rRmIKSIHorWYltr+6jmWw=;
        b=Yr8HoQ293EJZzq2tNbXKh00b93Jhgc6tzVvZQTHuJsizVdD4hgcXa4RteaFiBwnSq2
         Fyte2fzefryXXg2TCufA9wB/nJ9suW8Dfq3eonCjBVUlbcc2sdOplx7o2j0N6cqIFF3B
         4UoGjA9CQocL6x0vQDPDdpc2o6kVRAMR6uYxyXzYCwVKsoiinhIE9QGqfUTtP+LKEHLz
         8AV504CQygx1iFS51cb4XDv6/xOB4DTRQSoUWi6lfr8KzE+qKHDnpLeC+NesIRLgRGJK
         207oecsp3NLh04JJUBbpaDo8HaN+M2bUKepyLMUkdlNecwi8Ke7FvUoiO98LQK0D87J1
         Ee9g==
X-Gm-Message-State: APjAAAUwqngOG9qAglIt6TmjHC5L2MbLDi1+0H1Bm/a0IItVGTNFhHp0
        BV9tTio+97ccdn12rNuUMYzP5bQ2
X-Google-Smtp-Source: APXvYqyEK2jDav3KYr6OQaebRfcUtrMDs5V4LwmTgl7HKthbDEby9YhT8iVKbV4PYNafvrdb7dxhiA==
X-Received: by 2002:a5d:4cca:: with SMTP id c10mr47012717wrt.233.1563450139861;
        Thu, 18 Jul 2019 04:42:19 -0700 (PDT)
Received: from [192.168.8.147] (72.160.185.81.rev.sfr.net. [81.185.160.72])
        by smtp.gmail.com with ESMTPSA id b8sm32031938wmh.46.2019.07.18.04.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 04:42:19 -0700 (PDT)
Subject: Re: regression with napi/softirq ?
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20190717201925.fur57qfs2x3ha6aq@debian>
 <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
 <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com>
 <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8124bbe5-eaa8-2106-2695-4788ec0f6544@gmail.com>
Date:   Thu, 18 Jul 2019 13:42:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CADVatmN6xNO1iMQ4ihsT5OqV2cuj2ajq+v00NrtUyOHkiKPo-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/19 1:18 PM, Sudip Mukherjee wrote:
> Hi Eric,
> 
> On Thu, Jul 18, 2019 at 7:58 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 7/17/19 11:52 PM, Thomas Gleixner wrote:
>>> Sudip,
>>>
>>> On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
>>>> On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>>>> You can hack ksoftirq_running() to return always false to avoid this, but
>>>>> that might cause application starvation and a huge packet buffer backlog
>>>>> when the amount of incoming packets makes the CPU do nothing else than
>>>>> softirq processing.
>>>>
>>>> I tried that now, it is better but still not as good as v3.8
>>>> Now I am getting 375.9usec as the maximum time between raising the softirq
>>>> and it starting to execute and packet drops still there.
>>>>
>>>> And just a thought, do you think there should be a CONFIG_ option for
>>>> this feature of ksoftirqd_running() so that it can be disabled if needed
>>>> by users like us?
>>>
>>> If at all then a sysctl to allow runtime control.
>>>
> 
> <snip>
> 
>>
>> ksoftirqd might be spuriously scheduled from tx path, when
>> __qdisc_run() also reacts to need_resched().
>>
>> By raising NET_TX while we are processing NET_RX (say we send a TCP ACK packet
>> in response to incoming packet), we force __do_softirq() to perform
>> another loop, but before doing an other round, it will also check need_resched()
>> and eventually call wakeup_softirqd()
>>
>> I wonder if following patch makes any difference.
>>
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index 11c03cf4aa74b44663c74e0e3284140b0c75d9c4..ab736e974396394ae6ba409868aaea56a50ad57b 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -377,6 +377,8 @@ void __qdisc_run(struct Qdisc *q)
>>         int packets;
>>
>>         while (qdisc_restart(q, &packets)) {
>> +               if (qdisc_is_empty(q))
>> +                       break;
> 
> unfortunately its v4.14.55 and qdisc_is_empty() is not yet introduced.
> And I can not backport 28cff537ef2e ("net: sched: add empty status
> flag for NOLOCK qdisc")
> also as TCQ_F_NOLOCK is there. :(
> 

On old kernels, you can simply use

static inline bool qdisc_is_empty(struct Qdisc *q)
{
	return !qdisc_qlen(q);
}

