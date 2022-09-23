Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2A15E84D3
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 23:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbiIWVZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 17:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIWVZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 17:25:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7837122A4E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:25:18 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s14so1891896wro.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 14:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=QYrS8aOXLdxfqH2E62RLs+f9pZwOFHbwNujxln9jHyA=;
        b=Hi/H8ExZPdy/8PAaeHOmAMG4nWm4ghmynArm3W8PbYmlmyXQ3uIANZI82QLoqaM/LK
         +BoF/anj5m2URzuhNwoMgMAMxabnMnq0TO2Mz77ywAMxXgtrWK1r0jmiNeCZaaH17+PQ
         2HCNtgyOGG518WvjJ9V0TKkzJ5TBAUuYfyeN/vBZhTcNKOzzD+4+5D1xg3B6OTjW1T8K
         HG8S3fcDIGgnHrdWp4sK+r4pIfxNjSkX7BW3xbZ4j4wvtHbQ7Za1Jveq2/M0Qdo0tZWS
         95pG0iCzlH34rashvM5klN6fQaN0NnuvRo5txYugnQNmUZiwLK5xZN/0QlfY/dRrTLs6
         HzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=QYrS8aOXLdxfqH2E62RLs+f9pZwOFHbwNujxln9jHyA=;
        b=K5Vr66hKOwU4iVt7zvILWxewEjvGwLOyikkXHMR7Omh9JhRV76PKTE3bcHma2IogeP
         YWlzQrVC28uvl1w09aqwCWh+gvMujDZLwAq9n7QyqbcU6L39sTeZ9wt4ETJmEcumPOqE
         iphkmNsGuWBP0adZtnHFAWuLl7D7R2ICOThoGOgUMVvonUGikf0XU0Qo+1U6e72rAboS
         WmrjOFgrQ/nZVCIJYa6Rp1OrmO07qz8icUyyZP4fKPfaNTZwpbjJS9LD2yUZB1OP8dE/
         hn/L8PG3OqGgaOxShw+teoKDxkBDv2YAc8qhnxNLZgeDrR1tWSnZkv5PpFdh5MZQPRjJ
         Hw5A==
X-Gm-Message-State: ACrzQf3BM8RSusN/vbdgZ1w1Ae7YrIKwdBaDYPJ5nOO3JGFaFHNl3AtG
        fbGZ/ANiToyoK0zrLH8n7+JWBQ==
X-Google-Smtp-Source: AMsMyM7gocVlrtj5dqu1OiHtiRCqcKRbRfs4z/zcbr9ci9j7iMZlVMSPxnq0HVdqw7xJsq30MrKBAA==
X-Received: by 2002:a5d:47c5:0:b0:22a:6d4c:f21e with SMTP id o5-20020a5d47c5000000b0022a6d4cf21emr6462523wrc.417.1663968317189;
        Fri, 23 Sep 2022 14:25:17 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id u9-20020a056000038900b002252884cc91sm8155982wrf.43.2022.09.23.14.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 14:25:16 -0700 (PDT)
Message-ID: <3cf03d51-74db-675c-b392-e4647fa5b5a6@arista.com>
Date:   Fri, 23 Sep 2022 22:25:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 00/35] net/tcp: Add TCP-AO support
Content-Language: en-US
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Leonard Crestez <cdleonard@gmail.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
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
        linux-crypto@vger.kernel.org
References: <20220923201319.493208-1-dima@arista.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20220923201319.493208-1-dima@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/22 21:12, Dmitry Safonov wrote:
> Changes from v1:
> - Building now with CONFIG_IPV6=n (kernel test robot <lkp@intel.com>)
> - Added missing static declarations for local functions
>   (kernel test robot <lkp@intel.com>)
> - Addressed static analyzer and review comments by Dan Carpenter
>   (thanks, they were very useful!)
> - Fix elif without defined() for !CONFIG_TCP_AO
> - Recursively build selftests/net/tcp_ao (Shuah Khan), patches in:
>   https://lore.kernel.org/all/20220919201958.279545-1-dima@arista.com/T/#u
> - Don't leak crypto_pool reference when TCP-MD5 key is modified/changed
> - Add TCP-AO support for nettest.c and fcnal-test.sh
>   (will be used for VRF testing in later versions)
> 
> Version 1: https://lore.kernel.org/all/20220818170005.747015-1-dima@arista.com/T/#u

I think it's worth answering the question: why am I continuing sending
patches for TCP-AO support when there's already another proposal? [1]
Pre-history how we end up with the second approach is here: [2]
TLDR; we had a customer and a deadline to deliver, I've given reviews to
Leonard, but in the end it seems to me what we got is worth submitting
as it's better in my view in many aspects.

The biggest differences between two proposals, that I care about
(design-decisions, not implementation details):

1. Per-netns TCP-AO keys vs per-socket TCP-AO keys. The reasons why this
proposal is using per-socket keys (that are added like TCP-MD5 keys with
setsockopt()) are:
- They scale better: you don't have to lookup in netns database for a
key. This is a major thing for Arista: we have to support customers that
want more than 1000 peers with possible multiple keys per-peer. This
scales well when the keys are split by design for each socket on every
established connection.
- TCP-AO doesn't require CAP_NET_ADMIN for usage.
- TCP-AO is not meant to be transparent (like ipsec tunnels) for
applications. The users are BGP applications which already know what
they need.
- Leonard's proposal has weird semantics when setsockopt() on some
socket will change keys on other sockets in that network namespace. It
should have been rather netlink-managed API or something of the kind if
the keys are per-netns.

2. This proposal seeks to do less in kernel space and leave more
decision-making to the userspace. It is another major disagreement with
Leonard's proposal, which seeks to add a key lifetime, key rotation
logic and all other business-logic details into the kernel, while here
those decisions are left for the userspace.
If I understood Leonard correctly, he is placing more things in kernel
to simplify migration for user applications from TCP-MD5 to TCP-AO. I
rather think that would be a job for a shared library if that's needed.
As per my perception (1) was also done to relieve userspace from the job
of removing an outdated key simultaneously from all users in netns,
while in this proposal this job is left for userspace to use available
IPC methods. Essentially, I think TCP-AO in kernel should do only
minimum that can't be done "reasonably" in userspace. By "reasonably" I
mean without moving the TCP-IP stack into userspace.

3. Re-using existing kernel code vs copy'n'pasting it, leaving
refactoring for later. I'm a big fan of reusing existing functions. I
think lesser amount of code in the end reduces the burden of maintenance
as well as simplifies the code (both reading and changing). I can see
Leonard's point of simplifying backports to stable releases that he
ships to customers, but I think any upstream proposal should add less
code and try reusing more.

4. Following RFC5925 closer to text. RFC says that rnext_key from the
peer MUST be respected, as well as that current_key MUST not be removed
on an established connection. In this proposal if the requirements of
RFC can be met, they are followed, rather than broken.

5. Using ahash instead of shash. If there's a hardware accelerator - why
not using it? This proposal uses crypto_ahash through per-CPU pool of
crypto requests (crypto_pool).

6. Hash algorithm UAPI: magic constants vs hash name as char *. This is
a thing I've asked Leonard multiple times and what he refuses to change
in his patches: let the UAPI have `char tcpa_alg_name[64]' and just pass
it to crypto_* layer. There is no need for #define MY_HASHING_ALGO 0x2
and another in-kernel array to convert the magic number to algorithm
string in order to pass it to crypto.
The algorithm names are flexible: we already have customer's request to
use other than RFC5926 required hashing algorithms. And I don't see any
value in this middle-layer. This is already what kernel does, see for
example, include/uapi/linux/xfrm.h, grep for alg_name.

7. Adding traffic keys from the beginning. The proposal would be
incomplete without having traffic keys: they are pre-calculated in this
proposal, so the TCP stack doesn't have to do hashing twice (first for
calculation of the traffic key) for every segment on established
connections. This proposal has them naturally per-socket.

I think those are the biggest differences in the approaches and they are
enough to submit a concurrent proposal. Salam, Francesco, please add if
I've missed any other disagreement or major architectural/design
difference in the proposals.

> In TODO (expect in next versions):
> - selftests on older kernels (or with CONFIG_TCP_AO=n) should exit with
>   SKIP, not FAIL
> - Support VRFs in setsockopt()
> - setsockopt() UAPI padding + a test that structures are of the same
>   size on 32-bit as on 64-bit platforms
> - IPv4-mapped-IPv6 addresses (might be working, but no selftest now)
> - Remove CONFIG_TCP_AO dependency on CONFIG_TCP_MD5SIG
> - Add TCP-AO static key
> - Measure/benchmark TCP-AO and regular TCP connections
> - setsockopt(TCP_REPAIR) with TCP-AO
[..]
[1]:
https://lore.kernel.org/linux-crypto/cover.1662361354.git.cdleonard@gmail.com/
[2]:
https://lore.kernel.org/all/8097c38e-e88e-66ad-74d3-2f4a9e3734f4@arista.com/T/#u

Thanks,
          Dmitry
