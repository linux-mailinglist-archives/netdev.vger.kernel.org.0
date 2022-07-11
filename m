Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33E5570370
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiGKM4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiGKM4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:56:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4629D2BB03;
        Mon, 11 Jul 2022 05:56:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id v12so6096243edc.10;
        Mon, 11 Jul 2022 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=xqiYcac4kjvK9KyWMTADB4nPOj16J3aqFw3fSaQHU2s=;
        b=D60vK179GfL0CW7TTo/zvY1tKnXlZu2QJzzeiLfRqaUgh25JFtFQofkIuXHheYhAxr
         KMLa+MlvNT4HvMTldeqvMW5DgXtgoib54d4NmpdHqYn2XkSrhE57ZKl10sbEGe5f+GYa
         NxvpY1rbnD/fL2VxCIRBXOxEsaWnGiHvRmx3XRgzeVJ/NYC+ETphc2FL69PEzd3cV9pb
         7OTi/hEXw9HO6RjXUGXevRcUH8N7uTkt/zv+RiQ08tpJ4zZi7s/FP/6DOtuyq5I7nBkk
         7KbpDNBVuMz/kZ3Klyz8FixO0fmCnQLSzftsqJtMKfgfHKf6cF9cAJULxA+Z4nW6A2VN
         1HVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=xqiYcac4kjvK9KyWMTADB4nPOj16J3aqFw3fSaQHU2s=;
        b=p0ivP0sFk+HGIs3+I1oNVNCikh/87ao2DOdcLZZwC/82QHWG3MTM5z6PD/6Oz/GzCi
         YB4if66I9ib2p52s3dl6jsrBXKd1aQUl9QG6Eru4xZfIEuoZkHcu9JZAyMBSzeiwKXj/
         7L5VHNXWwreYEs/intToyGncFS/Fn3tnN/srA3Sju0X04O6oX1THHBConj0npBXXNB3b
         sxsSLhQ/AHdn0KpImCD62WcRSa0Y5jJI5QfeKVmMoCe1p9N9v8LZDs8c4r/9dP5NwOpo
         e7tJjgRy9IZ6XGKax2MTmRs/o1ZSHyRwEsk0RSLV3fWQ9T0BOiUuu1GjNkUAMMocdp2Z
         pdbQ==
X-Gm-Message-State: AJIora9WJfn2VwpDuzqLQBvAP2ihqxXl7DNqMcSpr4vg0TllgoGAyp1b
        r+Gu/gDoUpGXLbR/bdFRsDY=
X-Google-Smtp-Source: AGRyM1steBmZK6pUZ6poaeHbH2Prq62ZvS22AqIXf7JWoPHh3Nn0MSJ+kSf6usvWedT/aZc27UKgaw==
X-Received: by 2002:a05:6402:11d3:b0:43a:c43b:7ff9 with SMTP id j19-20020a05640211d300b0043ac43b7ff9mr15254891edw.130.1657544188835;
        Mon, 11 Jul 2022 05:56:28 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c093:600::1:ac34])
        by smtp.gmail.com with ESMTPSA id j11-20020a50ed0b000000b0043a6b86f024sm4250111eds.67.2022.07.11.05.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 05:56:28 -0700 (PDT)
Message-ID: <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
Date:   Mon, 11 Jul 2022 13:56:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     David Ahern <dsahern@kernel.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
In-Reply-To: <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/22 15:26, Pavel Begunkov wrote:
> On 7/8/22 05:10, David Ahern wrote:
>> On 7/7/22 5:49 AM, Pavel Begunkov wrote:
>>> NOTE: Not be picked directly. After getting necessary acks, I'll be working
>>>        out merging with Jakub and Jens.
>>>
>>> The patchset implements io_uring zerocopy send. It works with both registered
>>> and normal buffers, mixing is allowed but not recommended. Apart from usual
>>> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
>>> the userspace when buffers are freed and can be reused (see API design below),
>>> which is delivered into io_uring's Completion Queue. Those "buffer-free"
>>> notifications are not necessarily per request, but the userspace has control
>>> over it and should explicitly attaching a number of requests to a single
>>> notification. The series also adds some internal optimisations when used with
>>> registered buffers like removing page referencing.
>>>
>>>  From the kernel networking perspective there are two main changes. The first
>>> one is passing ubuf_info into the network layer from io_uring (inside of an
>>> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
>>> caching on the io_uring side, but also helps to avoid cross-referencing
>>> and synchronisation problems. The second part is an optional optimisation
>>> removing page referencing for requests with registered buffers.
>>>
>>> Benchmarking with an optimised version of the selftest (see [1]), which sends
>>> a bunch of requests, waits for completions and repeats. "+ flush" column posts
>>> one additional "buffer-free" notification per request, and just "zc" doesn't
>>> post buffer notifications at all.
>>>
>>> NIC (requests / second):
>>> IO size | non-zc    | zc             | zc + flush
>>> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
>>> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
>>> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
>>> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
>>>
>>> dummy (requests / second):
>>> IO size | non-zc    | zc             | zc + flush
>>> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
>>> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
>>> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
>>> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
>>>
>>> Previously it also brought a massive performance speedup compared to the
>>> msg_zerocopy tool (see [3]), which is probably not super interesting.
>>>
>>
>> can you add a comment that the above results are for UDP.
> 
> Oh, right, forgot to add it
> 
> 
>> You dropped comments about TCP testing; any progress there? If not, can
>> you relay any issues you are hitting?
> 
> Not really a problem, but for me it's bottle necked at NIC bandwidth
> (~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
> Was actually benchmarked by my colleague quite a while ago, but can't
> find numbers. Probably need to at least add localhost numbers or grab
> a better server.

Testing localhost TCP with a hack (see below), it doesn't include
refcounting optimisations I was testing UDP with and that will be
sent afterwards. Numbers are in MB/s

IO size | non-zc    | zc
1200    | 4174      | 4148
4096    | 7597      | 11228

Because it's localhost, we also spend cycles here for the recv side.
Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
omitted optimisations will somewhat help. I don't consider it to be a
blocker. but would be interesting to poke into later. One thing helping
non-zc is that it squeezes a number of requests into a single page
whenever zerocopy adds a new frag for every request.

Can't say anything new for larger payloads, I'm still NIC-bound but
looking at CPU utilisation zc doesn't drain as much cycles as non-zc.
Also, I don't remember if mentioned before, but another catch is that
with TCP it expects users to not be flushing notifications too much,
because it forces it to allocate a new skb and lose a good chunk of
benefits from using TCP.


diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1111adefd906..c4b781b2c3b1 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3218,9 +3218,7 @@ static inline int skb_orphan_frags(struct sk_buff *skb, gfp_t gfp_mask)
  /* Frags must be orphaned, even if refcounted, if skb might loop to rx path */
  static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
  {
-	if (likely(!skb_zcopy(skb)))
-		return 0;
-	return skb_copy_ubufs(skb, gfp_mask);
+	return skb_orphan_frags(skb, gfp_mask);
  }

-- 
Pavel Begunkov
