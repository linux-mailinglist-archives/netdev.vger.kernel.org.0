Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D131585336
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiG2QNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 12:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbiG2QNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 12:13:20 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D108051A
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:13:15 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id w8-20020a05600c014800b003a32e89bc4eso2699470wmm.5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 09:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=ndPzYPx7a+lxlREQ5VWInpGZ4vTgIRtRwCd3iQNfXK8=;
        b=bjZweXK8UJ0AlRVWS2sdMyAkg5VvIQ9Xi02IPaDT1VpXCdn4TO6E0No+orkEsE9PUL
         +NZXNQQMK/XOIlS0xFFW2tMNWhgXGNzA+XBsvUR9xGmCZa2PCBWKx/cXxHFNV10zW1X4
         Gb+8csJTKV9du0EVWYkmAB+Xe0gOERqGu+GAHd/noVjOFYNYzgj8OAeZhn0OJK0aPuih
         XX91oCAOv6QPXvjH/lrorxNY+G+UJPWHNivXZwtw4dqQQ0FlfuiCWthsqaTMQ/ZtbPe7
         wInugXnkB42bZeUX33y4whDL3gipGhknOvNemnsPf34IN3cDl0rDq+KYnYpg6OgNZGxC
         Dl2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=ndPzYPx7a+lxlREQ5VWInpGZ4vTgIRtRwCd3iQNfXK8=;
        b=jdxBSgcA9iGYQm/2LPP5W4fiNeJzgFKN/p7FOHzRyXSBqG3lOOZBLaAeBOg6XuAw1T
         kqWAIp3pvkwFncN7SHdXn1hEjVfYaXaYZ1UF64XMPTfUwi9X5P+2p2H9h+PEsx36IK5J
         RkuxInlNtDrAbyGFDA47BUEAuTHsU57Be15sG4LgcPkGt/WfwzeAgO/y1xI7iszLGfgO
         Me+cVbpaU05BqPAM67/Yn51YXpWbc9dJ0iUnGI3mpcnA0M0kRMciCV/eyRY/DVxP2bGE
         yUy5R8POskBEJrH/u+rvgiJsYnLgJ9qvx+koKLTuL9A5eEdqtiWV8cD57Z5T3GRQMKQE
         c+1w==
X-Gm-Message-State: AJIora+SREZWIh59EYyOPtVkV9PCzNwUGHmAae33qvZgvh25DJ02WK9D
        A6kcL3iqg0HvIRzShNeVAhLtfw==
X-Google-Smtp-Source: AGRyM1s2nA7c8Bvd3lIiVE5hNAV55JnHcmqJb/93IsJEAn/pPyJxekokYnyBgpPVwFGRF0BfAtRSBA==
X-Received: by 2002:a7b:c3c5:0:b0:3a2:e327:ba6d with SMTP id t5-20020a7bc3c5000000b003a2e327ba6dmr3284954wmj.184.1659111194003;
        Fri, 29 Jul 2022 09:13:14 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id d10-20020adffbca000000b0021e4f446d43sm4047932wrs.58.2022.07.29.09.13.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 09:13:13 -0700 (PDT)
Message-ID: <26d5955b-3807-a015-d259-ccc262f665c2@arista.com>
Date:   Fri, 29 Jul 2022 17:13:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 0/6] net/crypto: Introduce crypto_pool
Content-Language: en-US
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20220726201600.1715505-1-dima@arista.com>
 <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <YuCEN7LKcVLL0zBn@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 7/27/22 01:17, Herbert Xu wrote:
> On Tue, Jul 26, 2022 at 09:15:54PM +0100, Dmitry Safonov wrote:
>> Add crypto_pool - an API for allocating per-CPU array of crypto requests
>> on slow-path (in sleep'able context) and to use them on a fast-path,
>> which is RX/TX for net/ users (or in any other bh-disabled users).
>> The design is based on the current implementations of md5sig_pool.
>>
>> Previously, I've suggested to add such API on TCP-AO patch submission [1], 
>> where Herbert kindly suggested to help with introducing new crypto API.
> 
> What I was suggesting is modifying the actual ahash interface so
> that the tfm can be shared between different key users by moving
> the key into the request object.

My impression here is that we're looking at different issues.
1. The necessity of allocating per-CPU ahash_requests.
2. Managing the lifetime and sharing of ahash_request between different
kernel users.

Removing (1) will allow saving (num_possible_cpus() - 1)*(sizeof(struct
ahash_request) + crypto_ahash_reqsize(tfm)) bytes. Which would be very
nice for the new fancy CPUs with hundreds of threads.

For (2) many kernel users try manage it themselves, resulting in
different implementations, as well as some users trying to avoid using
any complication like ref counting and allocating the request only once,
without freeing it until the module is unloaded. Here for example,
introducing TCP-AO would result in copy'n'paste of tcp_md5sig_pool code.
As well as RFC5925 for TCP-AO let user to have any supported hashing
algorithms, with the requirement from RFC5926 of hmac(sha1) & aes(cmac).
If a user wants more algorithms that implementation would need to be
patched.

I see quite a few net/ users that could use some common API for this
besides TCP-MD5 and TCP-AO. That have the same pattern of allocating
crypto algorithm on a slow-path (adding a key or module initialization)
and using it of a fast-path, which is RX/TX.
Besides of sharing and lifetime managing, those users need a temporary
buffer (usually the name is `scratch'), IIUC, it is needed for async
algorithms that could use some hardware accelerator instead of CPU and
need to write the result anywhere, but on vmapped stack.

So, here I'm trying to address (2) in order to avoid copy'n'pasting of
tcp_md5sig_pool code for introduction of TCP-AO support.
I've also patched tcp-md5 code to dynamically disable the static branch,
which is not crypto change.

There's also a chance I've misunderstood what is your proposal :-)

Thanks,
          Dmitry
