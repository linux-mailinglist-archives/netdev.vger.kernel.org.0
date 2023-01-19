Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC9BB67407A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 19:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbjASSDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 13:03:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjASSDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 13:03:52 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE89BB9F
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:03:49 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id m15so2189943wms.4
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 10:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4bF12/qep1PDbFnO6gUHntH+OCUapHjuYPjeXCbRLq0=;
        b=Odx7DxEIHZg8hwb036lS+h52uP+N0Tzhudi68CBDrmtYNk4vhRChvSAU4G/Ef3QKpl
         DDu4aZrVvOK4k461M5Uaz9yoV7yPZn1lsqiO1sYqS+WH3hmQxk6dPGS6FLJqVz6USbQa
         IDja8SUPgnIMu53xDiEj/bdsop6E+QJjuAiHNKCmBVG9Vx+vJINg1qzFC/eFsixJrOaj
         GonQkyr8FlkomBOO6y6mcn4xemD5LY+hDcbWo8KJnXlN/ypB1aqUr9hI4tqjmaybnppx
         ynSjLVJRnrJNij25tUESpT0bEWbyeOBmtPwKlpx2ew5WD3q728fhYgYFc1pL69J8RdY/
         y37w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4bF12/qep1PDbFnO6gUHntH+OCUapHjuYPjeXCbRLq0=;
        b=stGF2U7WO347M3UbQnBzPBizcnaCIvieydEa125TpD9C/mOAlIFPby9A0UjfPmASMZ
         fJDh7p6w2klsoPhT/vR2gm+giloShOyehymHhja0v3vKjCIGWNkpzh+9D1SvBcMfbcoZ
         1nd5aQnw0BhyCNFIWbKh3jEX800wBoqAxeAKfEV3DsvtJ1o8qdvtwT4s52TNkiVWsXrS
         6vg6CCSRpPbA5m5UcR2y/O3xtUPwhDydApyimNBj7rdTUxoVybKElkO04ZrO7wGMFFup
         N/ewoLnaudUeXOnR8ygqJW9d0OJmignoKhD0VkCaQZbl0XIVeS00CYHRsgdkfjFBJ92h
         6pgg==
X-Gm-Message-State: AFqh2kqVoJ9LDDLhYc4LcSDJaDob9QPlFjeNoftR08BcTOwkt7vQeJmJ
        YrwZh2Zd/bEdiSLCo9kCR20rQQ==
X-Google-Smtp-Source: AMrXdXszga0ovrLNYBNRra1xJWbMqemjj5lTl/z+wA8QSmzAs91cZM/qUtPy8gH84Fx22A2yFJ+LzQ==
X-Received: by 2002:a05:600c:1f0a:b0:3db:1200:996e with SMTP id bd10-20020a05600c1f0a00b003db1200996emr6839875wmb.16.1674151427540;
        Thu, 19 Jan 2023 10:03:47 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m9-20020a7bca49000000b003d98f92692fsm5382293wml.17.2023.01.19.10.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 10:03:47 -0800 (PST)
Message-ID: <7c4138b4-e7dd-c9c5-11ac-68be90563cad@arista.com>
Date:   Thu, 19 Jan 2023 18:03:40 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 1/4] crypto: Introduce crypto_pool
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230118214111.394416-1-dima@arista.com>
 <20230118214111.394416-2-dima@arista.com>
 <Y8kSkW4X4vQdFyOl@gondor.apana.org.au>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y8kSkW4X4vQdFyOl@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 1/19/23 09:51, Herbert Xu wrote:
> On Wed, Jan 18, 2023 at 09:41:08PM +0000, Dmitry Safonov wrote:
>> Introduce a per-CPU pool of async crypto requests that can be used
>> in bh-disabled contexts (designed with net RX/TX softirqs as users in
>> mind). Allocation can sleep and is a slow-path.
>> Initial implementation has only ahash as a backend and a fix-sized array
>> of possible algorithms used in parallel.
>>
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>  crypto/Kconfig        |   3 +
>>  crypto/Makefile       |   1 +
>>  crypto/crypto_pool.c  | 333 ++++++++++++++++++++++++++++++++++++++++++
>>  include/crypto/pool.h |  46 ++++++
>>  4 files changed, 383 insertions(+)
>>  create mode 100644 crypto/crypto_pool.c
>>  create mode 100644 include/crypto/pool.h
> 
> I'm still nacking this.
> 
> I'm currently working on per-request keys which should render
> this unnecessary.  With per-request keys you can simply do an
> atomic kmalloc when you compute the hash.

Adding per-request keys sounds like a real improvement to me.
But that is not the same issue I'm addressing here. I'm maybe bad at
describing or maybe I just don't see how per-request keys would help.
Let me describe the problem I'm solving again and please feel free to
correct inline or suggest alternatives.

The initial need for crypto_pool comes from TCP-AO implementation that
I'm pusing upstream, see RFC5925 that describes the option and the
latest version of patch set is in [1]. In that patch set hashing is used
in a similar way to TCP-MD5: crypto_alloc_ahash() is a slow-path in
setsockopt() and the use of pre-allocated requests in fast path, TX/RX
softirqs.

For TCP-AO 2 algorithms are "must have" in any compliant implementation,
according to RFC5926: HMAC-SHA-1-96 and AES-128-CMAC-96, other
algorithms are optional. But having in mind that sha1, as you know, is
not secure to collision attacks, some customers prefer to have/use
stronger hashes. In other words, TCP-AO implementation needs 2+ hashing
algorithms to be used in a similar manner as TCP-MD5 uses MD5 hashing.

And than, I look around and I see that the same pattern (slow allocation
of crypto request and usage on a fast-path with bh disabled) is used in
other places over kernel:
- here I convert to crypto_pool seg6_hmac & tcp-md5
- net/ipv4/ah4.c could benefit from it: currently it allocates
crypto_alloc_ahash() per every connection, allocating user-specified
hash algorithm with ahash = crypto_alloc_ahash(x->aalg->alg_name, 0, 0),
which are not shared between each other and it doesn't provide
pre-allocated temporary/scratch buffer to calculate hash, so it uses
GFP_ATOMIC in ah_alloc_tmp()
- net/ipv6/ah6.c is copy'n'paste of the above
- net/ipv4/esp4.c and net/ipv6/esp6.c are more-or-less also copy'n'paste
with crypto_alloc_aead() instead of crypto_alloc_ahash()
- net/mac80211/ - another example of the same pattern, see even the
comment in ieee80211_key_alloc() where the keys are allocated and the
usage in net/mac80211/{rx,tx}.c with bh-disabled
- net/xfrm/xfrm_ipcomp.c has its own manager for different compression
algorithms that are used in quite the same fashion. The significant
exception is scratch area: it's IPCOMP_SCRATCH_SIZE=65400. So, if it
could be shared with other crypto users that do the same pattern
(bh-disabled usage), it would save some memory.

And those are just fast-grep examples from net/, looking closer it may
be possible to find more potential users.
So, in crypto_pool.c it's 333 lines where is a manager that let a user
share pre-allocated ahash requests [comp, aead, may be added on top]
inside bh-disabled section as well as share a temporary/scratch buffer.
It will make it possible to remove some if not all custom managers of
the very same code pattern, some of which don't even try to share
pre-allocated tfms.

That's why I see some value in this crypto-pool thing.
If you NACK it, the alternative for TCP-AO patches would be to add just
another pool into net/ipv4/tcp.c that either copies TCP-MD5 code or
re-uses it.

I fail to see how your per-request keys patches would provide an API
alternative to this patch set. Still, users will have to manage
pre-allocated tfms and buffers.
I can actually see how your per-request keys would benefit *from* this
patch set: it will be much easier to wire per-req keys up to crypto_pool
to avoid per-CPU tfm allocation for algorithms you'll add support for.
In that case you won't have to patch crypto-pool users.

[1]:
https://lore.kernel.org/all/20221027204347.529913-1-dima@arista.com/T/#u

Thanks, waiting for your input,
          Dmitry
