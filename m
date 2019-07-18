Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF906C989
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 08:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbfGRG6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 02:58:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37355 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfGRG6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 02:58:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so2301888wrr.4;
        Wed, 17 Jul 2019 23:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w67IyN95gTj3RhuSrYGK7BpCk3sEigKFRh3/KoBI/NE=;
        b=uJHwK/EgcZHsa6kff9Sy1oZ16ko0nFwEXzf0ubk5VI4cztgO78V+srFXNy8EB9pmfX
         0+VZOCav2hb+JXUPl32b+O8sHyRSC6MqDiwG9j8/DM04+KnKB0O/17yIcRv5SSW7A8AW
         PTKBjilwpUGZuHnxzH7QYIytGoHcmw03ijfMgdMfrC4Lu7N4WbdVNE382zpFa/N7mY3c
         MmZbFhiH9D/ugT1JglzrHrL8fYiIAv9qn/NLVbF09nOV1ippcyvxrmiwBQRl0PKfBN91
         fDME7IyFA8YsE3Sd4kaaBHe7W7S3cuD6jeDaBc1S803DSJGmB7e3YubWHd8/Wh6oX2Xo
         GX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w67IyN95gTj3RhuSrYGK7BpCk3sEigKFRh3/KoBI/NE=;
        b=HlgcXvh1hXL7hQXB/bAhIpet5NQxAjMY3FSFs2z6c99Ymv+lR77QnnSCHGyqGt/h36
         8uOyNymMihhcAHH6dTyUgUiFOf0Momc3DUHqWWbPqprf8XNYqw1O549sGChbdqWWqwki
         Km/InUC/PUTAWk6D1zbIyfxBt4iNNEASkkrOuK6MbWJsIcv+Owgp80qCI75odS96c44l
         OYaRreWqHrlPb6TiRn6pdsDyOXiLVgvp59PM+AI8GbjqocvECPKdpJFVG9NUEx623WJP
         Sx4OqrZfW97/pA1xa3nh79Ci8KdxFBqeMiozB9ysUSX6ydZlCPFHW1x4fBZKF22DJytT
         amKA==
X-Gm-Message-State: APjAAAX60aEfh33nWExkk2tinKkhkq0KyAbIhj1n9V3ildeiaIxRBlyq
        V/4DBUK2XuUOk3uyW1FN029AcQp9
X-Google-Smtp-Source: APXvYqzmc6/F56Fq9sryYZ2gARiMxs2u5uBNxaObAYp3kGcq3TAxeeeMzWN5fkaYchYAdDNh+ydzgQ==
X-Received: by 2002:a5d:5308:: with SMTP id e8mr9437678wrv.219.1563433096040;
        Wed, 17 Jul 2019 23:58:16 -0700 (PDT)
Received: from [192.168.8.147] (72.160.185.81.rev.sfr.net. [81.185.160.72])
        by smtp.gmail.com with ESMTPSA id g19sm27357652wmg.10.2019.07.17.23.58.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 23:58:15 -0700 (PDT)
Subject: Re: regression with napi/softirq ?
To:     Thomas Gleixner <tglx@linutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20190717201925.fur57qfs2x3ha6aq@debian>
 <alpine.DEB.2.21.1907172238490.1778@nanos.tec.linutronix.de>
 <CADVatmO_m-NYotb9Htd7gS0d2-o0DeEWeDJ1uYKE+oj_HjoN0Q@mail.gmail.com>
 <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <052e43b6-26f8-3e46-784e-dc3c6a82bdf0@gmail.com>
Date:   Thu, 18 Jul 2019 08:58:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1907172345360.1778@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/19 11:52 PM, Thomas Gleixner wrote:
> Sudip,
> 
> On Wed, 17 Jul 2019, Sudip Mukherjee wrote:
>> On Wed, Jul 17, 2019 at 9:53 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>> You can hack ksoftirq_running() to return always false to avoid this, but
>>> that might cause application starvation and a huge packet buffer backlog
>>> when the amount of incoming packets makes the CPU do nothing else than
>>> softirq processing.
>>
>> I tried that now, it is better but still not as good as v3.8
>> Now I am getting 375.9usec as the maximum time between raising the softirq
>> and it starting to execute and packet drops still there.
>>
>> And just a thought, do you think there should be a CONFIG_ option for
>> this feature of ksoftirqd_running() so that it can be disabled if needed
>> by users like us?
> 
> If at all then a sysctl to allow runtime control.
>  
>> Can you please think of anything else that might have changed which I still need
>> to change to make the time comparable to v3.8..
> 
> Something with in that small range of:
> 
>  63592 files changed, 13783320 insertions(+), 5155492 deletions(-)
> 
> :)
> 
> Seriously, that can be anything.
> 
> Can you please test with Linus' head of tree and add some more
> instrumentation, so we can see what holds off softirqs from being
> processed. If the ksoftirqd enforcement is disabled, then the only reason
> can be a long lasting softirq disabled region. Tracing should tell.

ksoftirqd might be spuriously scheduled from tx path, when
__qdisc_run() also reacts to need_resched().

By raising NET_TX while we are processing NET_RX (say we send a TCP ACK packet
in response to incoming packet), we force __do_softirq() to perform
another loop, but before doing an other round, it will also check need_resched()
and eventually call wakeup_softirqd()

I wonder if following patch makes any difference.

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 11c03cf4aa74b44663c74e0e3284140b0c75d9c4..ab736e974396394ae6ba409868aaea56a50ad57b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -377,6 +377,8 @@ void __qdisc_run(struct Qdisc *q)
        int packets;
 
        while (qdisc_restart(q, &packets)) {
+               if (qdisc_is_empty(q))
+                       break;
                /*
                 * Ordered by possible occurrence: Postpone processing if
                 * 1. we've exceeded packet quota

