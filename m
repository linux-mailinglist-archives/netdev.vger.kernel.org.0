Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9787348C8D8
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355356AbiALQx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244049AbiALQx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:53:57 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25152C06173F;
        Wed, 12 Jan 2022 08:53:57 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id q9-20020a7bce89000000b00349e697f2fbso3228340wmj.0;
        Wed, 12 Jan 2022 08:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=CmDqim83S7smzzgFZYQWzZX82mxSbacYZtG0Bvj74CE=;
        b=Gooqz3pGE2xIZxIbIGJQLrIRjMArFhSLcIUWoQhBsOBmW3e6PZatoyF5z2wG0PUGFa
         CLu0xfko08vECly+rrW1caHq9cUkCoBLK4sZ7Nmv3/akl398RmOa7WOCqEQmsiUodE7m
         ZZ01UnVnq6Gn45kOTPR/RIHBRXuQW5UOhmvYMH9JRSW6UdEA61wf6OnFKIwwRiEXs4bf
         78yOnQBWP2v9FA7VC2T23ZEc+o3q3zBj8On2aOzEha/F7w6mWTKLa6eJ4ApadYnA8Lpk
         SV0niXyNoamldwV8nYStwUh8lOaCbr1oyp9uknXYLsUk+I92IvzcNAPJaP2D6eNVJd3X
         hMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=CmDqim83S7smzzgFZYQWzZX82mxSbacYZtG0Bvj74CE=;
        b=BrhUC1gcnZC5JnBq8dRj0b+EzxHDjH7iKcjjUSGlvPE0Mz2cdomZ1vI4yS5r2iWcXe
         qD7VTG88CVwKjYdwUzajTplg6TyY2SVzonFLrKS0zJe/m5KW9Jr6Fqm07L5VvbG65cDh
         76srvJWLW6yknZNbLv9bwqe2IZxBE3Bkl9osAX4847GZnBskOqnpi/pWA951ECTmhpOY
         9JJ6hXPIXk+tEklBwrFbLoc6e6Rs6VM88Bkpf/LLplMBWX5yeO2dsa9i1oGz1TVLLfgY
         /2UtwFmO5lkilDyp4hv37IKVcqgnvKPVr1payyTGQKwyK3saUSc/0SQEiicORQ23giHV
         0G8A==
X-Gm-Message-State: AOAM530BG/fNHUlZsocnj2MxSVrngQDYACdV7kSWPH8ccyEgEyQWhHrY
        rDFjDjD/pJ6Z6ezjmOvi020=
X-Google-Smtp-Source: ABdhPJzEx82qM4/HY7q08tCkRCENMDysIpj+x69sPQaBHYvrmCKcp+8FVgnGuprjzwwhBjMa+VHEYA==
X-Received: by 2002:a05:600c:190c:: with SMTP id j12mr328180wmq.166.1642006435674;
        Wed, 12 Jan 2022 08:53:55 -0800 (PST)
Received: from [192.168.8.198] ([148.252.129.73])
        by smtp.gmail.com with ESMTPSA id j8sm69412wms.46.2022.01.12.08.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 08:53:55 -0800 (PST)
Message-ID: <9701c478-6815-74c7-eedd-9a2f02458b35@gmail.com>
Date:   Wed, 12 Jan 2022 16:53:06 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
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
 <4bc0e57b-ee3b-ae77-5d5d-213a48bdf4b0@gmail.com>
 <cf5eb67e-05dc-3b8d-3e61-ddf9a9706265@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cf5eb67e-05dc-3b8d-3e61-ddf9a9706265@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/22 03:39, Hao Xu wrote:
> 在 2022/1/11 下午11:50, Pavel Begunkov 写道:
>> On 1/11/22 13:51, Hao Xu wrote:
>>> 在 2021/12/21 下午11:35, Pavel Begunkov 写道:
>>>> Instead of the net stack managing ubuf_info, allow to pass it in from
>>>> outside in a struct msghdr (in-kernel structure), so io_uring can make
>>>> use of it.
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>> Hi Pavel,
>>> I've some confusions here since I have a lack of
>>> network knowledge.
>>> The first one is why do we make ubuf_info visible
>>> for io_uring. Why not just follow the old MSG_ZEROCOPY
>>> logic?
>>
>> I assume you mean leaving allocation up and so in socket awhile the
>> patchset let's io_uring to manage and control ubufs. In short,
>> performance and out convenience
>>
>> TL;DR;
>> First, we want a nice and uniform API with io_uring, i.e. posting
>> an CQE instead of polling an err queue/etc., and for that the network
>> will need to know about io_uring ctx in some way. As an alternative it
>> may theoretically be registered in socket, but it'll quickly turn into
>> a huge mess, consider that it's a many to many relation b/w io_uring and
>> sockets. The fact that io_uring holds refs to files will only complicate
>> it.
> Make sense to me, thanks.
>>
>> It will also limit API. For instance, we won't be able to use a single
>> ubuf with several different sockets.
> Is there any use cases for this multiple sockets with single
> notification?

Don't know, scatter send maybe? It's just one of those moments when
a design that feels right (to me) yields more flexibility than was
initially planned, which is definitely a good thing


>> Another problem is performance, registration or some other tricks
>> would some additional sync. It'd also need sync on use, say it's
>> just one rcu_read, but the problem that it only adds up to complexity
>> and prevents some other optimisations. E.g. we amortise to ~0 atomics
>> getting refs on skb setups based on guarantees io_uring provides, and
>> not only. SKBFL_MANAGED_FRAGS can only work with pages being controlled
>> by the issuer, and so it needs some context as currently provided by
>> ubuf. io_uring also caches ubufs, which relies on io_uring locking, so
>> it removes kmalloc/free for almost zero overhead.
>>
>>
>>> The second one, my understanding about the buffer
>>> lifecycle is that the kernel side informs
>>> the userspace by a cqe generated by the ubuf_info
>>> callback that all the buffers attaching to the
>>> same notifier is now free to use when all the data
>>> is sent, then why is the flush in 13/19 needed as
>>> it is at the submission period?
>>
>> Probably I wasn't clear enough. A user has to flush a notifier, only
>> then it's expected to post an CQE after all buffers attached to it
>> are freed. io_uring holds one ubuf ref, which will be release on flush.
> I see, I saw another ref inc in skb_zcopy_set() which I previously
> misunderstood and thus thought there was only one refcount. Thanks!
>> I also need to add a way to flush without send.
>>
>> Will spend some time documenting for next iteration.

-- 
Pavel Begunkov
