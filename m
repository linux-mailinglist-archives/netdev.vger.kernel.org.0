Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24622465728
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245666AbhLAUdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245591AbhLAUdD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:33:03 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C1EC061748;
        Wed,  1 Dec 2021 12:29:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id o13so54813288wrs.12;
        Wed, 01 Dec 2021 12:29:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=IQVCvC7bWt4Xisw903m5V4gdM4PCh3ZxZ6pWb+wSumc=;
        b=Ttc/daCKB1xsqJSAbBWUAhTaX1mkQwqfih6zlAgigRQxLe+55NertkiTHpkBZfyydU
         6O/4xP0D0314+dldLp8W/ZznrR321dGeNqMd/YUdr8tQD9y+a3S4CojVFcI3ne7R3IQ1
         E9g40HkSLEVWPtWLxjP0IZAkJkFEVat8Ajrn9vkSP9wl8j6MhF1ox0PtX9SVk/T4y2m6
         YzTyxunyWPC7g7pZeRXQfZSEdNtFgrQvqtgC3nXT8BBVid1qiTwLFCjVKKwaT0X8vUG/
         HhEGtU7wNUNlXFAQc8kxhAaAlA8uadibxtaslqWdHj1iiITN6LjYGSl+s/ieC8XJduxF
         mYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=IQVCvC7bWt4Xisw903m5V4gdM4PCh3ZxZ6pWb+wSumc=;
        b=O4pXpz7Z6lx5Mncam/MrL5qEGkb8cb8dx+E4rYbym3wljoyufYimv4B311OkA9eLxv
         JOer6RMaEa8oX1SnX8UypkqHZzP6DxeM8mwQmNkrITXUFgXWvD28nyZn9pXlUUkLrrFz
         HUeiy68yb/TSGagzjhxzV+hgYGjeuB4BRZkaFTebZL6sWObTFQAP3VvvHcT8wXxs1yYW
         zjBq15TDW8oCOGSbJveT5O3qHaMPxZf+fzVBBZ40Vo64i+Ra9fSV6qRJSR87dXzLbtUa
         jhANJolqCstiDh0AqDr0Gzmdjge89O+uZcnvndaD7WC/gslm1Ai2UNhI5Bb/ZH93zpS+
         DI6Q==
X-Gm-Message-State: AOAM532CF0dWGGxfL0+ewvVihJs7VkYy5aWIcgwD40IM3JqIf3aEMMhq
        PgXAcCI7hsqWpX6hhcP2BQzuxy2LOMw=
X-Google-Smtp-Source: ABdhPJzKfq7KUmQMQVNcnV6iSRGFXP9Dj/YjvokmXuumucaJRS8nro+os98lnGPjzGJ9bszkoJpZPw==
X-Received: by 2002:a5d:69ca:: with SMTP id s10mr9213840wrw.312.1638390578238;
        Wed, 01 Dec 2021 12:29:38 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id 38sm770626wrc.1.2021.12.01.12.29.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:29:37 -0800 (PST)
Message-ID: <d5a07e01-7fc3-2f73-a406-21246a252876@gmail.com>
Date:   Wed, 1 Dec 2021 20:29:30 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
In-Reply-To: <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 19:59, Pavel Begunkov wrote:
> On 12/1/21 18:10, Willem de Bruijn wrote:
>>> # performance:
>>>
>>> The worst case for io_uring is (4), still 1.88 times faster than
>>> msg_zerocopy (2), and there are a couple of "easy" optimisations left
>>> out from the patchset. For 4096 bytes payload zc is only slightly
>>> outperforms non-zc version, the larger payload the wider gap.
>>> I'll get more numbers next time.
>>
>>> Comparing (3) and (4), and (5) vs (6), @flush doesn't affect it too
>>> much. Notification posting is not a big problem for now, but need
>>> to compare the performance for when io_uring_tx_zerocopy_callback()
>>> is called from IRQ context, and possible rework it to use task_work.
>>>
>>> It supports both, regular buffers and fixed ones, but there is a bunch of
>>> optimisations exclusively for io_uring's fixed buffers. For comparison,
>>> normal vs fixed buffers (@nr_reqs=8, @flush=0): 75677 vs 116079 MB/s
>>>
>>> 1) we pass a bvec, so no page table walks.
>>> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
>>>     still doing page get/put (see 4/12) slashed 4-5%.
>>> 3) avoiding get_page/put_page in 5/12
>>> 4) completion events are posted into io_uring's CQ, so no
>>>     extra recvmsg for getting events
>>> 5) no poll(2) in the code because of io_uring
>>> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
>>>     io_uring caches the structures reducing it to nearly zero-overhead.
>>
>> Nice set of complementary optimizations.
>>
>> We have looked at adding some of those as independent additions to
>> msg_zerocopy before, such as long-term pinned regions. One issue with
>> that is that the pages must remain until the request completes,
>> regardless of whether the calling process is alive. So it cannot rely
>> on a pinned range held by a process only.
>>
>> If feasible, it would be preferable if the optimizations can be added
>> to msg_zerocopy directly, rather than adding a dependency on io_uring
>> to make use of them. But not sure how feasible that is. For some, like
>> 4 and 5, the answer is clearly it isn't.  6, it probably is?

Forgot about 6), io_uring uses the fact that submissions are
done under an per ring mutex, and completions are under a per
ring spinlock, so there are two lists for them and no extra
locking. Lists are spliced in a batched manner, so it's
1 spinlock per N (e.g. 32) cached ubuf_info's allocations.

Any similar guarantees for sockets?

[...]

-- 
Pavel Begunkov
