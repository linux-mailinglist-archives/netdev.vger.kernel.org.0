Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DDA219115
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgGHUAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHUAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:00:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E806C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 13:00:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b92so29026pjc.4
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 13:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SLscqespRgogjJeRhwObVUm76Z89B0PoejPznjVNdek=;
        b=LAxxt4quPgUJUb69Wya2OY/arBzpYs2B5beK7HrRVFL5m5f/k+pTb+pA+qCfC5Folj
         0UW8Kw57mB9NcnNOB2eqrFGSfSd0xkrxI8COq1DypDn+ZwN/XGrwmER/4cqywZRYnnEc
         CxfYhfWMH5KOToXr63w9uIABHtTcOFGttx1PmGCjbNogXOLkvs825KnLUwT9/EKjco6r
         Slfc1bagChZ3DXPFib8z5wxjE0F/ejjoHoGG3wbriaTysaypETxYd+0kbmSmvdPqB0xT
         gsB8JwkQMm+K+lRfiKuYfU4n3OKAJoa4lrD69y7JUH3t1U2T/SvK81+TU1GV72Fz/oaE
         6okQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SLscqespRgogjJeRhwObVUm76Z89B0PoejPznjVNdek=;
        b=GrB2z25OVXZBPC9DwefkzY5s6Mz4OGOH9IE7FHStDLdgeyHZendmeJSNyuCyB4MAGI
         SFx/1PNvHTvnfkKxIMhXnQYnG9Oo5SjjqSR44x2TWpdrYtcoeR61wlRE4a2StThqAom7
         R4oXqNuRmn0l+Lm60KUxyzPaiUdjR0lk/YFNUadOBqX6HGxGW9MlMuFlw35+3QU94bct
         0HKpAvkCdA82vyY3U4onSfGTSvfqGbcHtgH4tnzcaQHwJq8cwpULl+xAjGcv0trMoBPn
         jEIfD19o/l1yDbl2+/X3AinabztgfHM5bSnULOGg6LjAfdTw7c2WZBpZlfLtJKwPldPV
         kBiQ==
X-Gm-Message-State: AOAM532IVxcPoFlMtKZVK55eIIiQs+XTuFAFG3tN16JuvEnvgJ5hxsHm
        y05w6pWr9sOWzLUej3OrsRU=
X-Google-Smtp-Source: ABdhPJwKn2MyynuKF4/rFW/X0YKW7dov8cAL9wSQSALwyQ1wBjdEyfNB+JKuguCQs2QkKawJ1lk/Eg==
X-Received: by 2002:a17:902:fe11:: with SMTP id g17mr52154924plj.145.1594238436942;
        Wed, 08 Jul 2020 13:00:36 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a11sm339918pjw.35.2020.07.08.13.00.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 13:00:36 -0700 (PDT)
Subject: Re: [Patch net v2] cgroup: fix cgroup_sk_alloc() for sk_clone_lock()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cameron Berkenpas <cam@neo-zeon.de>,
        Peter Geis <pgwipeout@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        =?UTF-8?Q?Dani=c3=abl_Sonck?= <dsonck92@gmail.com>,
        Zhang Qiang <qiang.zhang@windriver.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Roman Gushchin <guro@fb.com>
References: <20200702185256.17917-1-xiyou.wangcong@gmail.com>
 <20200708153327.GA193647@roeck-us.net>
 <CAM_iQpWLcbALSZDNkiCm7zKOjMZV8z1XnC5D0vyiYPC6rU3v8A@mail.gmail.com>
 <fe638e54-be0e-d729-a20f-878d017d0da7@roeck-us.net>
 <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <d871c759-c77e-de5e-5658-e97e81e8bcfe@roeck-us.net>
Date:   Wed, 8 Jul 2020 13:00:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpWWXmrNzNZc5-N=bXo2_o58V0=3SeFkPzmJaDL3TVUeEA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 12:32 PM, Cong Wang wrote:
> On Wed, Jul 8, 2020 at 12:07 PM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 7/8/20 11:34 AM, Cong Wang wrote:
>>> Hi,
>>>
>>> On Wed, Jul 8, 2020 at 8:33 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>>> This patch causes all my s390 boot tests to crash. Reverting it fixes
>>>> the problem. Please see bisect results and and crash log below.
>>>>
>>> ...
>>>> Crash log:
>>>
>>> Interesting. I don't see how unix socket is any special here, it creates
>>> a peer sock with sk_alloc(), but this is not any different from two separated
>>> sockets.
>>>
>>> What is your kernel config? Do you enable CONFIG_CGROUP_NET_PRIO
>>> or CONFIG_CGROUP_NET_CLASSID? I can see there might be a problem
>>> if you don't enable either of them but enable CONFIG_CGROUP_BPF.
>>>
>>
>> cgroup specific configuration bits:
>>
>> CONFIG_CGROUPS=y
>> CONFIG_BLK_CGROUP=y
>> CONFIG_CGROUP_WRITEBACK=y
>> CONFIG_CGROUP_SCHED=y
>> CONFIG_CGROUP_PIDS=y
>> CONFIG_CGROUP_RDMA=y
>> CONFIG_CGROUP_FREEZER=y
>> CONFIG_CGROUP_HUGETLB=y
>> CONFIG_CGROUP_DEVICE=y
>> CONFIG_CGROUP_CPUACCT=y
>> CONFIG_CGROUP_PERF=y
>> CONFIG_CGROUP_BPF=y
>> # CONFIG_CGROUP_DEBUG is not set
>> CONFIG_SOCK_CGROUP_DATA=y
>> CONFIG_BLK_CGROUP_RWSTAT=y
>> CONFIG_BLK_CGROUP_IOLATENCY=y
>> CONFIG_BLK_CGROUP_IOCOST=y
>> # CONFIG_BFQ_CGROUP_DEBUG is not set
>> # CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
>> CONFIG_NET_CLS_CGROUP=y
>> CONFIG_CGROUP_NET_PRIO=y
>> CONFIG_CGROUP_NET_CLASSID=y
>>
>> This originates from arch/s390/configs/defconfig; I don't touch
>> any cgroup specific configuration in my tests.
> 
> Good to know you enable everything related here.
> 
Maybe, but on the other side I would argue that not having everything
enabled should not result in a crash.

>>
>>> And if you have the full kernel log, it would be helpful too.
>>>
>>
>> https://kerneltests.org/builders/qemu-s390-pending-fixes/builds/222/steps/qemubuildcommand/logs/stdio
> 
> It looks like cgroup_sk_alloc_disabled is always false in your case.
> This makes the bug even more weird. Unless there is a refcnt bug
> prior to my commit, I don't see how it could happen.
> 
>>
>> Interestingly, enabling CONFIG_BFQ_CGROUP_DEBUG makes the problem disappear.
> 
> Yeah, I guess there might be some cgroup refcnt bug which could
> just paper out with CONFIG_BFQ_CGROUP_DEBUG=y.
> 
> If you can test patches, I can send you a debugging patch for you
> to collect more data. I assume this is 100% reproducible on your
> side?
> 
Sure, I'll be happy to do that. And, yes, it is always reproducible.

Guenter
