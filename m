Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5BC59EAC6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 20:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233726AbiHWSQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 14:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiHWSQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 14:16:24 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F5B57545
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:31:31 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h5so16852215wru.7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 09:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=nKoC8OE/O/GQsF3EPOMsruSTs9kLL6O0oaBfPq3e28g=;
        b=SK7ynHMFvo1X+2v4fJkRdHRHQ1Ryfr6uKbFvpzEINyt6alx2V4q3i53DNdbSoUYAlA
         Umo7SyI3XBZldXE3rT8UonEPS9tgLeakleqyt/vV3GzmDro1anDbdiOVuHTLnUyGL/WI
         VPp1C0D4rueHf/CN4BMj2PNEEcP1C9htAj1bZw2Q2FxL9p7ddlSFNaGxHDryqN93l1pD
         +YD9gPw+cJiR/3jxZT35YcDP4EtmaWabhbI31kerfPU+1GlzT+XewXDqUScid1rwZ9J1
         3lb14OXgu5ZjS1/worMgsvXMSybqsUSpdL8miLbmTMvv6RDx3tWg6lx0osYH28xOKFoA
         rA8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nKoC8OE/O/GQsF3EPOMsruSTs9kLL6O0oaBfPq3e28g=;
        b=C7nMx0LS3CiHDW1HNpf8eu/lvTMNCSgLHD436k6LhmxUnTGDoEKvoFULKYZemQQ2kY
         fFwjW269Hqv7TNWfJONom6wLkcp/iV3ikAeeUb7Mw+jQzQ8Q7/DGoSs9rxfPMDg4vFAK
         Is9hdPeZ/ML1yBCzUzdxfUiYoydk4ZF03EPovfqgBcP9EYqL2cQ7wRxiruXoXDeTHvz1
         42S20j+tcJq+87pRQ0+E0LZGK5L4ckJ/iKnWquR4FP5JtYWNV/prrYWiYVHvspWb2TXB
         yubD1Ei1nQoIhCpMkrVUbxlphBGwV5s+Q1jE9H+FXIRsIJyLETcIzwKQhVNPITG89LVR
         IDzw==
X-Gm-Message-State: ACgBeo35C4Le1NGAuABUr8M2LbucSw45Nk+5Q3z7iWXzAnrjXQuLX7ct
        195rf+kkFcYvbu5TRPZM2dGYXw==
X-Google-Smtp-Source: AA6agR5USOIOfMIu3eXWb5tNMXUpwOsRF3pXjUg/3KIyzqgQANYdz3Mucb1dJhvQB5q5M83QcbNCMA==
X-Received: by 2002:a5d:5985:0:b0:222:c827:11d5 with SMTP id n5-20020a5d5985000000b00222c82711d5mr14038109wri.323.1661272289310;
        Tue, 23 Aug 2022 09:31:29 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id a14-20020adfed0e000000b0022511d35d5bsm14974943wro.12.2022.08.23.09.31.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 09:31:28 -0700 (PDT)
Message-ID: <f3910cac-84c4-61fa-c06a-268ec171f464@arista.com>
Date:   Tue, 23 Aug 2022 17:31:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 00/31] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220818170005.747015-1-dima@arista.com>
 <fc05893d-7733-1426-3b12-7ba60ef2698f@gmail.com>
 <a83e24c9-ab25-6ca0-8b81-268f92791ae5@kernel.org>
 <8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com>
 <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <7ad5a9be-4ee9-bab2-4a70-b0f661f91beb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/22 16:30, Leonard Crestez wrote:
> On 8/22/22 23:35, Dmitry Safonov wrote:
>> Hi Leonard, David,
[..]
>> At this particular moment, it seems neither of patch sets is ready to be
>> merged "as-is". But it seems that there's enough interest from both
>> sides and likely it guarantees that there will be enough effort to make
>> something merge-able, that will work for all interested parties.
>>
>> As for my part, I'm interested in the best code upstream, regardless who
>> is the author. This includes:
>> - reusing the existing TCP-MD5 code, rather than copying'n'pasting for
>>    TCP-AO with intent to refactor it some day later
> 
> I had a requirement to deploy on linux 5.4 so I very deliberately
> avoided touching MD5. I'm not sure there very much duplication anyway.

Yeah, I know what you mean: we deployed it on v4.19. But for the code
upstream I personally prefer to see "reusing" rather than copying.
Lesser code is easier to maintain in future.
Upstream submissions in my view should be based on "what would be easier
to maintain in future", rather than on "what would be easier to backport
to my maintenance release".

>> - making setsockopt()s and other syscalls extendable
>> - cover functionality with selftests
> 
> My implementation is tested with a standalone python package, this is a
> design choice which doesn't particularly matter.
> 
>> - following RFC5925 in implementation, especially "required" and "must"
>>    parts
> 
> I'm not convinced that "don't delete current key" needs to be literally
> interpreted as a hard requirement for the linux ABI. Most TCP RFCs don't
> specify any sort of API at all and it would be entirely valid to
> implement BGP-TCP-AO as a single executable with no internally
> documented boundaries.

I agree that RFC requirements and "musts" can be implemented in
userspace, rather than in kernel. On the other hand, my opinion is that
if you have "must"/"must not"/"required" in RFC and it's not hard to
limit those in kernel, than you _should_ do it.
In this point of view, debugging "hey, setsockopt() for key removal
returned -EBUSY, what's going on?" is better than "hey, tcp connection
died on my side and I didn't have tcp dump running, what was that?".

>> I hope that clarifies how and why now there are two patch sets that
>> implement the same RFC/functionality.
> 
> As far as I can tell the biggest problem is that is quite difficult to
> implement the userspace side of TCP-AO complete with key rollover. Our
> two implementation both claim to support this but through different ABI
> and both require active management from userspace.
> 
> I think it would make sense to push key validity times and the key
> selection policy entirely in the kernel so that it can handle key
> rotation/expiration by itself. This way userspace only has to configure
> the keys and doesn't have to touch established connections at all.

Respectfully I disagree here. I think all such policies should be
implemented in userspace. The kernel has to have as lesser as possible,
but enough to provide a way to sign, verify, log messages on TCP segments.
All the logic that may change, all business decisions and key management
should be implemented in userspace, keeping the kernel part as easier in
"KISS" sense as possible.

> My series has a "flags" field on the key struct where it can filter by
> IP, prefix, ifindex and so on. It would be possible to add additional
> flags for making the key only valid between certain times (by wall time).
> 
> The kernel could then make key selections itself:
>  - send rnextkeyid based on the key with the longest recv lifetime
>  - send keyid based on remote rnextkeyid.
>    - If not applicable (rnextkeyid not found locally, or for SYN) pick
> based on longest send lifetime.
>  - If all keys expire then return an error on write()
>  - Solve other ambiguities in a predictable way: if valid times are
> equal then pick the lowest numeric send_id or recv_id.
> 
> Explicit key selection from userspace could still be supported but it
> would be optional and most apps wouldn't bother implementing their own
> policy. The biggest advantage is that it would be much easier for
> applications to adopt TCP-AO.

Personally, I would think that all you mentioned better stay in
userspace app. The kernel should do as minimal and as much predictable
as possible job here, without 10 possible outcomes. If you want to share
the logic of key rotation/expiration, all timers and synchronization
between different BGP applications, that would be a proper job for a
shared library.

Thanks,
          Dmitry
