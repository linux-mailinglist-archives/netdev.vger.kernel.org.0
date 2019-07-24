Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDEBD72ACD
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfGXI5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:57:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35229 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfGXI5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 04:57:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so46063087wrm.2;
        Wed, 24 Jul 2019 01:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nS11U7aQYbR6FrVLZkmgGzedl7yGkGWQ5Fg3AiFJx50=;
        b=aK7rHmIRnnPnTg3ntYCBn9NyiVtMIT7A64kixmaBRA/gox+o5LYGXplpw37OdbJXqJ
         GJBrZBojsznBd/7xMa2QaRo1w3+77FDro8GJcRHNRquOxZm0ZafM/TyhNEHZjLhAtSLu
         vahNDA+jF0m1b4upnuxaIvJx/pb2egfoKfWCr0Db82NN2Ddglspe958Krd8kBG+05e2a
         tAoUbrT91Zp57QfDPnbMsNgEuLBLsy40996WKGSgkMfS4hkFANjgIx6yz5vdOqDThZof
         KCfIjZNw3HoCDSvtGlp/QVMN73SudqPJuYJ8OZpGcuPdnfytl09zRdcH/rDW16Lb6t3k
         dAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nS11U7aQYbR6FrVLZkmgGzedl7yGkGWQ5Fg3AiFJx50=;
        b=UXQsqhMOh3/iRlilKV1hBCE6VEI7eE6nTIE3hZ0lV0z/+HYUeJsChqcRuK6WJnVW+7
         rTTq1FDB9piKQjoARw1DsITOBJVUglIyIb30F3T9f/pqiPlRRDumXdRcwQbVW73fOd9B
         qmTmHdkqO5SC0FhZyYrk+cXc/li63rtaECqy1TUeDoWfN7qg5B9eKAMKa/vLziD1Qffp
         ca2E9vQGM4NlIpZ1JNq24E6kWNwy5HqWVkrOk+HbeSWhbknFy59S+lnActW1FSTrAYWO
         4tDcA3a6r6a4AM2AX5d6iFK4YI+j+E+KNsy7rKDrqzI+tmK/CGxvnfjBhShIymLOQh5P
         xPCg==
X-Gm-Message-State: APjAAAUGUByIbt+xNj+y+HMcoQvRyTU7E9LIn1GUFU49xYHtHX6j9H0j
        YHqtP1kyH3D1HCSRpQM25MQ=
X-Google-Smtp-Source: APXvYqzVkHjQ4fYrwflU5EfZZ7N6g3BUBLzJHgZ4PHqokfI3W6tGoyr4GYhF5mfDCiyDpCJkTp8wvA==
X-Received: by 2002:a5d:52c5:: with SMTP id r5mr67154185wrv.146.1563958618470;
        Wed, 24 Jul 2019 01:56:58 -0700 (PDT)
Received: from [192.168.8.147] (200.150.22.93.rev.sfr.net. [93.22.150.200])
        by smtp.gmail.com with ESMTPSA id v124sm48139208wmf.23.2019.07.24.01.56.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 01:56:57 -0700 (PDT)
Subject: Re: [RFC] performance regression with commit-id<adb03115f459> ("net:
 get rid of an signed integer overflow in ip_idents_reserve()")
To:     Zhangshaokun <zhangshaokun@hisilicon.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        "guoyang (C)" <guoyang2@huawei.com>,
        "zhudacai@hisilicon.com" <zhudacai@hisilicon.com>
References: <051e93d4-0206-7416-e639-376b8d2eb98b@hisilicon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <3d77a08a-22e9-16e8-4091-c5ba4851ff13@gmail.com>
Date:   Wed, 24 Jul 2019 10:56:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <051e93d4-0206-7416-e639-376b8d2eb98b@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/24/19 10:38 AM, Zhangshaokun wrote:
> Hi,
> 
> I've observed an significant performance regression with the following commit-id <adb03115f459>
> ("net: get rid of an signed integer overflow in ip_idents_reserve()").

Yes this UBSAN false positive has been painful



> 
> Here are my test scenes:
> ----Server----
> Cmd: iperf3 -s xxx.xxx.xxxx.xxx -p 10000 -i 0 -A 0
> Kenel: 4.19.34
> Server number: 32
> Port: 10000 – 10032
> CPU affinity: 0 – 32
> CPU architecture: aarch64
> NUMA node0 CPU(s): 0-23
> NUMA node1 CPU(s): 24-47
> 
> ----Client----
> Cmd: iperf3 -u -c xxx.xxx.xxxx.xxx -p 10000 -l 16 -b 0 -t 0 -i 0 -A 8
> Kenel: 4.19.34
> Client number: 32
> Port: 10000 – 10032
> CPU affinity: 0 – 32
> CPU architecture: aarch64
> NUMA node0 CPU(s): 0-23
> NUMA node1 CPU(s): 24-47
> 
> Firstly, With patch <adb03115f459> ("net: get rid of an signed integer overflow in ip_idents_reserve()") ,
> client’s cpu is 100%, and function ip_idents_reserve() cpu usage is very high, but the result is not good.
> 03:08:32 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> 03:08:33 AM      eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
> 03:08:33 AM      eth1      0.00 3461296.00      0.00 196049.97      0.00      0.00      0.00      0.00
> 03:08:33 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
> 
> Secondly, revert that patch, use atomic_add_return() instead, the result is better, as below:
> 03:23:24 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> 03:23:25 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
> 03:23:25 AM      eth1      0.00 12834590.00      0.00 726959.20      0.00      0.00      0.00      0.00
> 03:23:25 AM      eth0      7.00     11.00      0.40      2.95      0.00      0.00      0.00      0.00
> 
> Thirdly, atomic is not used in ip_idents_reserve() completely ,while each cpu core allocates its own ID segment,
> Such as: cpu core0 allocate ID 0 – 1023, cpu core1 allocate 1024 – 2047, …,etc
> the result is the best:

Not sure what you mean.

Less entropy in IPv4 ID is not going to help when fragments _are_ needed.

Send 40,000 datagrams of 2000 bytes each, add delays, reorders, and boom, most of the packets will be lost.

This is not because your use case does not need proper IP ID that we can mess with them.

If you need to send packets very fast,  maybe use AF_PACKET ?

> 03:27:06 AM     IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s   txcmp/s  rxmcst/s   %ifutil
> 03:27:07 AM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
> 03:27:07 AM      eth1      0.00 14275505.00      0.00 808573.53      0.00      0.00      0.00      0.00
> 03:27:07 AM      eth0      0.00      2.00      0.00      0.18      0.00      0.00      0.00      0.00
> 
> Because atomic operation performance is bottleneck when cpu core number increase, Can we revert the patch or
> use ID segment for each cpu core instead?


This has been discussed in the past.

https://lore.kernel.org/lkml/b0160f4b-b996-b0ee-405a-3d5f1866272e@gmail.com/

We can revert now UBSAN has been fixed.

Or even use Peter patch : https://lore.kernel.org/lkml/20181101172739.GA3196@hirez.programming.kicks-ass.net/

However, you will still hit badly a shared cache line, not matter what.

Some arches are known to have terrible LL/SC implementation :/

