Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1025FCEF2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 01:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJLXdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 19:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJLXc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 19:32:58 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E761792E8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 16:32:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y1so425850pfr.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 16:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r149X74hOPKSCMQ7kzOpFxouMfO9XIu5ZtdRVqiYktU=;
        b=cTrr4Kd6/SNJ8eQFfOeNRhOMEru2e8EIj0urPu2e8nwIbBqF8r1kHJG9Fpd6E3uuTp
         08jWkk38gco7M5Bh1g/ulZyJso47EzWPUA/E5Ra5YIDBOuUVUoSqbQq84am/gJi/0SJ9
         B8aSasKNPCzLeOFNY44QwCv/h/zhF/cIPeK8pMuSBZpQ63ITsgi4SUmBdvZofef5kZEQ
         jX6EzYo0IlWZBM0wPKUtEvGfE9c5oyXVtFyWq2JnD5GldQFATHCY4KVbyZY6eCL6MjsY
         XDws8fe9irIRyWwxZrW3VjtFEOxrGrClgz8u+K10CAZX0o7kCqsBhkU3LAVTcy3qSBm/
         L0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r149X74hOPKSCMQ7kzOpFxouMfO9XIu5ZtdRVqiYktU=;
        b=GIfU9qbC0R+jFODoBit2qGowcKbNEyLjG4L8IHMRjeeNce2bZm6ZzvsbaG0zaSoHWa
         MIuwGOCL52KFGGMEKfh0oeRaFFlhXX/Ak0I6blYNf5vFWf3QhlguY7Aw07sG57FerMuK
         SlU5IHmUmJFnBwrINMwpx/8eSloIKKMu1f+ZZVO/ibx2t/Oilz4tLdMW5YP9c5L06Y/r
         GjGBRWaW3O7iacpetuvoxNLO+3xXfzTzc4fmoijdtY+/C8IgPQln+zXomfzWetQi14oL
         //4S9EgdZktPVt1MLCsiTsZ5aeWtswXUBPyYQ+n2uDRCVGM6tGXDQeIqMUxWBRTC0Jdk
         lUJQ==
X-Gm-Message-State: ACrzQf1rZKtT9TzE/JLowZUnbI+skKa9CUtmTAYWrKWfC2BKTLJ2k9Vw
        Oz5Z2Gggu6B7yvVoXa3CRObCImP/G3s=
X-Google-Smtp-Source: AMsMyM5Q6CpDBd779DZQYYPYhY9gkRkBCEYiCM2b5lgoHZkfGbTGKSfmfLNNEzV04zsQApD1uthgTg==
X-Received: by 2002:a63:4850:0:b0:45d:6ee6:1c18 with SMTP id x16-20020a634850000000b0045d6ee61c18mr28456628pgk.255.1665617577748;
        Wed, 12 Oct 2022 16:32:57 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9517:7fc4:6b3f:85b4? ([2620:15c:2c1:200:9517:7fc4:6b3f:85b4])
        by smtp.gmail.com with ESMTPSA id x2-20020a655382000000b00442c70b659esm7789657pgq.91.2022.10.12.16.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 16:32:57 -0700 (PDT)
Message-ID: <2b195a93-a88b-33c2-661a-85fa8513c063@gmail.com>
Date:   Wed, 12 Oct 2022 16:32:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: qdisc_watchdog_schedule_range_ns granularity
Content-Language: en-US
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
References: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de>
 <44a7e82b-0fe9-d6ba-ee12-02dfa4980966@gmail.com>
 <a896ad54-297b-c55e-1d34-14ab26949ab6@tarent.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <a896ad54-297b-c55e-1d34-14ab26949ab6@tarent.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/22 16:15, Thorsten Glaser wrote:
> On Wed, 12 Oct 2022, Eric Dumazet wrote:
>
>> CONFIG_HIGH_RES_TIMERS=y
> It does.
>
>> I don't know how you measure this latency, but net/sched/sch_fq.c has
>> instrumentation,
> On enqueue I add now+extradelay and save that as enqueue timestamp.
> On dequeue I check that now>=timestamp then process the packet,
> measuring now-timestamp as queue delay. This is surprisingly higher.

When packets are eligible, the qdisc itself can be stopped if NIC is 
full (or BQL triggers)

net/sched/sch_fq.c is not using the skb tstamp which could very well be 
in the past,

but an internal variable (q->time_next_delayed_flow)


>
> I’ll add some printks as well, to see when I’m called next after
> such a watchdog scheduling.
>
>> Under high cpu pressure, it is possible the softirq is delayed,
>> because ksoftirqd might compete with user threads.
> Is it a good idea to renice these?


Depends if you want to starve user thread(s) under flood/attack, I guess 
you can try.


>
> Thanks,
> //mirabilos
