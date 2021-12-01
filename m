Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514F14651C0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351014AbhLAPgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:36:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbhLAPgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:36:13 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C192DC061574;
        Wed,  1 Dec 2021 07:32:52 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id j140-20020a1c2392000000b003399ae48f58so22595274wmj.5;
        Wed, 01 Dec 2021 07:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=z1V9o3659iPfdup74dALWjx0yYdBSgLCQ5oAR/ZzaQs=;
        b=lxnQ4umUeWipBDpN2gZjlZykRF7m4hJaKOyzlcQG8U3t9Fw/WO7NcDRNDXeSKfGpDZ
         YxZRsb2aUWRzriDHbIJ0hUF7/lLzAZUtzCDflJ/1yetTeFeVGGkprCAatokvV0ZrnI/C
         g90RwDZllj8JYXmQuQnnxDqzxhJs8+jAETm5kH9QXNHcJdYcvSKB+sRvsY3xvnYQ1zLS
         L1XBVfkhJv9PreUQSwtH+Tu38ibBugfdo0wSFP2xxo8/NeJsDxkKmNA874o7WemBj3kN
         ZMJ0twfQH9MM49I0uLOZgwM7iXWAsNNs63qofSIHV+5sna9MlfJp4izI085AKE8M5nc7
         0mTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=z1V9o3659iPfdup74dALWjx0yYdBSgLCQ5oAR/ZzaQs=;
        b=JDExmbHexqtSDwK5xoRJebaljHs2z5yhWf3gJdbcG/h0QixbW7Tv0OaRvSmf3pHXwc
         XoTx1ysy/VYcyEL6s5Y/vqm+TRXbBr/eiVw7BZTTI61TXrzKE+RP1/WvtwZWWkBYXVnF
         mD6HVuBwzH2ptVrdT4WixaDXhhjkvRT5bRB0eWTiBIisnCibgJuvmEelYtg062DI3EXN
         BqXnIgW5WjHH+r1Csr5obPDqt6Banv4xru9AS4VSUxvZ01ZlH9G7kvBw44EGRvbQ4F34
         fJ5s217YxbCJUW0d3MYHAEy5kmkWrNNL/bMoW6qCB5Kd1Uw2TjVfnZmlURSRQC43bASz
         e2gg==
X-Gm-Message-State: AOAM530GY7Gc//e4AMCW8eA/pMTL+AfOdLB27ukvSpMO/CmDn4XvklW/
        LO97kBBc4HveQ9Uv1e2RQSw=
X-Google-Smtp-Source: ABdhPJz6yQt0JgWoTo72Vz2EXFyUjMRkcWx6iGLk1uOrjm+1+3VsgHwSOnOE3hC4TysnhQVPwi71Hg==
X-Received: by 2002:a05:600c:1c1a:: with SMTP id j26mr8109049wms.28.1638372771338;
        Wed, 01 Dec 2021 07:32:51 -0800 (PST)
Received: from [192.168.43.77] (82-132-228-4.dab.02.net. [82.132.228.4])
        by smtp.gmail.com with ESMTPSA id r11sm140905wrw.5.2021.12.01.07.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 07:32:50 -0800 (PST)
Message-ID: <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
Date:   Wed, 1 Dec 2021 15:32:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 03:10, David Ahern wrote:
> On 11/30/21 8:18 AM, Pavel Begunkov wrote:
>> Early proof of concept for zerocopy send via io_uring. This is just
>> an RFC, there are details yet to be figured out, but hope to gather
>> some feedback.
>>
>> Benchmarking udp (65435 bytes) with a dummy net device (mtu=0xffff):
>> The best case io_uring=116079 MB/s vs msg_zerocopy=47421 MB/s,
>> or 2.44 times faster.
>>
>> № | test:                                | BW (MB/s)  | speedup
>> 1 | msg_zerocopy (non-zc)                |  18281     | 0.38
>> 2 | msg_zerocopy -z (baseline)           |  47421     | 1
>> 3 | io_uring (@flush=false, nr_reqs=1)   |  96534     | 2.03
>> 4 | io_uring (@flush=true,  nr_reqs=1)   |  89310     | 1.88
>> 5 | io_uring (@flush=false, nr_reqs=8)   | 116079     | 2.44
>> 6 | io_uring (@flush=true,  nr_reqs=8)   | 109722     | 2.31
>>
>> Based on selftests/.../msg_zerocopy but more limited. You can use
>> msg_zerocopy -r as usual for receive side.
>>
> ...
> 
> Can you state the exact command lines you are running for all of the
> commands? I tried this set (and commands referenced below) and my

Sure. First, for dummy I set mtu by hand, not sure can do it from
the userspace, can I? Without it __ip_append_data() falls into
non-zerocopy path.

diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..5c5aeacdabd5 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -132,7 +132,8 @@ static void dummy_setup(struct net_device *dev)
  	eth_hw_addr_random(dev);
  
  	dev->min_mtu = 0;
-	dev->max_mtu = 0;
+	dev->mtu = 0xffff;
+	dev->max_mtu = 0xffff;
  }

# dummy configuration

modprobe dummy numdummies=1
ip link set dummy0 up
# force requests to <dummy_ip_addr> go through the dummy device
ip route add <dummy_ip_addr> dev dummy0


With dummy I was just sinking the traffic to the dummy device,
was good enough for me. Omitting "taskset" and "nice":

send-zc -4 -D <dummy_ip_addr> -t 10 udp

Similarly with msg_zerocopy:

<kernel>/tools/testing/selftests/net/msg_zerocopy -4 -p 6666 -D <dummy_ip_addr> -t 10 -z udp


For loopback testing, as zerocopy is not allowed for it as Willem explained in
the original MSG_ZEROCOPY cover-letter, I used a hack to bypass it:

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ebb12a7d386d..42df33b175ce 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2854,9 +2854,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
  /* Frags must be orphaned, even if refcounted, if skb might loop to rx path */
  static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
  {
-	if (likely(!skb_zcopy(skb)))
-		return 0;
-	return skb_copy_ubufs(skb, gfp_mask);
+	return skb_orphan_frags(skb, gfp_mask);
  }
  
  /**

Then running those two lines below in parallel and looking for the numbers
send shows. It was in favor of io_uring for me, but don't remember
exactly. perf shows that "send-zc" spends lot of time receiving, so
wasn't testing performance of it after some point.

msg_zerocopy -r -v -4 -t 20 udp
send-zc -4 -D 127.0.0.1 -t 10 udp


> mileage varies quite a bit.

Interesting, any brief notes on the setup and the results? Dummy
or something real? io_uring doesn't show if it was really zerocopied
or not, but I assume you checked it (e.g. with perf/bpftrace).

I expected that @flush=true might be worse with real devices,
there is one spot to be patched, but apart from that and
cycles spend in a real LLD offseting the overhead, didn't
anticipate any problems. I'll see once I try a real device.


> Also, have you run this proposed change (and with TCP) across nodes
> (ie., not just local process to local process via dummy interface)?

Not yet, I tried dummy, and localhost UDP as per above and similarly
TCP. Just need to grab a server with a proper NIC, will try it out
soon.

>> Benchmark:
>> https://github.com/isilence/liburing.git zc_v1
>>
>> or this file in particular:
>> https://github.com/isilence/liburing/blob/zc_v1/test/send-zc.c
>>
>> To run the benchmark:
>> ```
>> cd <liburing_dir> && make && cd test
>> # ./send-zc -4 [-p <port>] [-s <payload_size>] -D <destination> udp
>> ./send-zc -4 -D 127.0.0.1 udp
>> ```
>>
>> msg_zerocopy can be used for the server side, e.g.
>> ```
>> cd <linux-kernel>/tools/testing/selftests/net && make
>> ./msg_zerocopy -4 -r [-p <port>] [-t <sec>] udp
>> ```

-- 
Pavel Begunkov
