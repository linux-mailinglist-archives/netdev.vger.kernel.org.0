Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B552F48B15F
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349728AbiAKPyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 10:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349717AbiAKPyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 10:54:03 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FF5C06173F;
        Tue, 11 Jan 2022 07:54:03 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id v123so11392307wme.2;
        Tue, 11 Jan 2022 07:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nB8ZCrankHzHcyFv7VI9Wl5C6LAOn4lhmHRycfbWy7U=;
        b=QmTwbWUjBoUAuxlE8ytjljwFhZDpavttR3I3lLL4Xyo/D5dapapFbgcjfVazavMIVR
         hGUJL3/MpGOE1TD7y+KCDQQtt0mZ8VpglkJIBA8602zPhjUTISus8UNAK+WmUMX2W7qA
         6BDBrjur9ZYht0brx6qNPS92J0weRCIMmaBLaLCVEK7VkHWNAC8ghinEHI/pghgQ8DJi
         j73kfZ+/Ht0QmzS+DWtATGo1/M+DRtlooE6NnzbnfGDZXxD2a26BGjl57yUcpGVhTnRV
         jnznb0pTpYeHGhGwHh032hn+lNKrC5iH7v7Rm0gR5zb21HBCrVPo2s1zGlsc4mE7btFa
         aiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nB8ZCrankHzHcyFv7VI9Wl5C6LAOn4lhmHRycfbWy7U=;
        b=W2jOht2CN1vdH9xR9QY/64KSrbsRn3g0exFjqnMB0Sm2bzzCtB6YBUcU3TztUakQ8e
         NyetZoarOybgfY4LZ5bbewd+vfZAjAmCxrteEgUnnesw0Kb5APp65i3z0BVfPclWj8K7
         rAq2GORo1WQ/NWCB57mSaSPhinoQjSkZ5nCDsocwI+jyDtuP/367xs1+Ep5p3r7+a0Dx
         IaHUE+j1QpfxFk6msGn9CABK7IwRAdnYgnFF+TwGpg6rWdJsE+jL7fQs7Yo5b6IkRNEz
         plx7Sg3uv2AoBD3UZL7e82IyC5Ok6NFcPtU4OCrdJxU/QwDUVv+H/Vgveqa65ObHGTg8
         zHWQ==
X-Gm-Message-State: AOAM533zFPEuPzNnPfqK7rilxVxqIol10LrxmHf3Tdjx98vz5uAZHrOt
        rrlIe0FH56hFJffarkdXEMc=
X-Google-Smtp-Source: ABdhPJz2+BnH0HpORwHCCQLaK+gBsBJKXKIJuW6bYZSnWVrDA0yD7jrhkEsZxi4+Td24tzU4eM4S6g==
X-Received: by 2002:a7b:c5c4:: with SMTP id n4mr3028051wmk.134.1641916441690;
        Tue, 11 Jan 2022 07:54:01 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id az6sm922297wmb.48.2022.01.11.07.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 07:54:01 -0800 (PST)
Message-ID: <4bc0e57b-ee3b-ae77-5d5d-213a48bdf4b0@gmail.com>
Date:   Tue, 11 Jan 2022 15:50:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC v2 02/19] skbuff: pass a struct ubuf_info in msghdr
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1640029579.git.asml.silence@gmail.com>
 <7dae2f61ee9a1ad38822870764fcafad43a3fe4e.1640029579.git.asml.silence@gmail.com>
 <fd376342-13e2-4ce9-074a-f6b3da69be3b@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd376342-13e2-4ce9-074a-f6b3da69be3b@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 13:51, Hao Xu wrote:
> 在 2021/12/21 下午11:35, Pavel Begunkov 写道:
>> Instead of the net stack managing ubuf_info, allow to pass it in from
>> outside in a struct msghdr (in-kernel structure), so io_uring can make
>> use of it.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> Hi Pavel,
> I've some confusions here since I have a lack of
> network knowledge.
> The first one is why do we make ubuf_info visible
> for io_uring. Why not just follow the old MSG_ZEROCOPY
> logic?

I assume you mean leaving allocation up and so in socket awhile the
patchset let's io_uring to manage and control ubufs. In short,
performance and out convenience

TL;DR;
First, we want a nice and uniform API with io_uring, i.e. posting
an CQE instead of polling an err queue/etc., and for that the network
will need to know about io_uring ctx in some way. As an alternative it
may theoretically be registered in socket, but it'll quickly turn into
a huge mess, consider that it's a many to many relation b/w io_uring and
sockets. The fact that io_uring holds refs to files will only complicate
it.

It will also limit API. For instance, we won't be able to use a single
ubuf with several different sockets.

Another problem is performance, registration or some other tricks
would some additional sync. It'd also need sync on use, say it's
just one rcu_read, but the problem that it only adds up to complexity
and prevents some other optimisations. E.g. we amortise to ~0 atomics
getting refs on skb setups based on guarantees io_uring provides, and
not only. SKBFL_MANAGED_FRAGS can only work with pages being controlled
by the issuer, and so it needs some context as currently provided by
ubuf. io_uring also caches ubufs, which relies on io_uring locking, so
it removes kmalloc/free for almost zero overhead.


> The second one, my understanding about the buffer
> lifecycle is that the kernel side informs
> the userspace by a cqe generated by the ubuf_info
> callback that all the buffers attaching to the
> same notifier is now free to use when all the data
> is sent, then why is the flush in 13/19 needed as
> it is at the submission period?

Probably I wasn't clear enough. A user has to flush a notifier, only
then it's expected to post an CQE after all buffers attached to it
are freed. io_uring holds one ubuf ref, which will be release on flush.
I also need to add a way to flush without send.

Will spend some time documenting for next iteration.

-- 
Pavel Begunkov
