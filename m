Return-Path: <netdev+bounces-2713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45A317032DB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 18:26:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58484281354
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38243FBE0;
	Mon, 15 May 2023 16:26:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202ABC8ED
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 16:26:12 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A595
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:26:10 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f42c86543bso50257585e9.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1684167968; x=1686759968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WcjyJ4f2hV+VYMVZDZ/87BsHeuaz2N5BzUdms5sJR54=;
        b=Pr46RbGt5lhHRgQqazQmVjm25lQT8dOouNUaBS6Aggj/Sw1st9l53mG6q8gmmSwFoW
         lSWv3rgu5jHOM/SR7Oetthu9NLcR4/NEz4gEzQQ34zcxk1UN5xLGC0ebGGywQvDmQYfU
         xrVxTAJdro53CJf9MjEozJLviaXJbmty5pnfjbLsB0Wdgk7495CXLAQoVi53n2u7LfYB
         SNnNpVM0bLI6OlAWQ7Y2Y29J8ZV5zOMvN25RSEvbjECYI33x/36ijwsvMlg288ixbe0d
         v1Fi8K9tYXDOlIEz0f4dhG6pHLVC1+JQ/4HGlz9460eTJxjUTXKCOtYllr/XhgOu0Lir
         gYOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684167968; x=1686759968;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WcjyJ4f2hV+VYMVZDZ/87BsHeuaz2N5BzUdms5sJR54=;
        b=Q/4J/9/zQyEc96Q/85og802RfwjtCpL13td9ME93lfOnLTSpTMBvk8aObogEc/Dv52
         O5OBNtumjXRvECEwXhWEhJZpBYWYWigmu/wke8B+kfmhag1QJKTImVU/CkASNtZedkeZ
         9E/ZLY6GvUIblPPEHH6Jw0gakYFp8GMkTRm4cdbzanxGSgjZruIomxpfRnM4YxNNm8Ja
         2r6tPZPDQVlyikz76i+kfiMHL3oK5ejdhKjckOGTZIoe99CWgf1TsdmAcy6lcltRB3Rz
         xEB+lJJ/31f8+3+yr6Wsu/bqkBYVFpZmK/dfUch/v3nNcPH4muYwXk3B6LPIS0ctjK+W
         /XJg==
X-Gm-Message-State: AC+VfDxv7H26SbAQmw6FW3uSJwYHKnG+F6K77jkTuYC12a05t3pudsLQ
	Ejx3ILOJ8UVQ04fMMCeA2Z0IKA==
X-Google-Smtp-Source: ACHHUZ7S3jKVqq8IbrDNX0+1Te4dZntni8kqKANL0kSL/xMj1Z7oYhSiUetbvRXqGWqeTtXS0dDfEQ==
X-Received: by 2002:a05:6000:120a:b0:306:4054:6e41 with SMTP id e10-20020a056000120a00b0030640546e41mr27854752wrx.53.1684167968560;
        Mon, 15 May 2023 09:26:08 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id r10-20020a5d52ca000000b003079c402762sm270909wrv.19.2023.05.15.09.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 09:26:08 -0700 (PDT)
Message-ID: <eb6d0724-92d6-3c3f-b698-9734adc7e1b9@arista.com>
Date: Mon, 15 May 2023 17:25:55 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v6 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Andy Lutomirski <luto@amacapital.net>, Ard Biesheuvel <ardb@kernel.org>,
 Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>,
 David Laight <David.Laight@aculab.com>, Dmitry Safonov
 <0x7f454c46@gmail.com>, Eric Biggers <ebiggers@kernel.org>,
 "Eric W. Biederman" <ebiederm@xmission.com>,
 Francesco Ruggeri <fruggeri05@gmail.com>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>,
 Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
References: <20230512202311.2845526-1-dima@arista.com>
 <20230512202311.2845526-2-dima@arista.com>
 <ZGG5rtuHB4lvLyKI@gondor.apana.org.au>
Content-Language: en-US
From: Dmitry Safonov <dima@arista.com>
In-Reply-To: <ZGG5rtuHB4lvLyKI@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 05:48, Herbert Xu wrote:
> On Fri, May 12, 2023 at 09:22:51PM +0100, Dmitry Safonov wrote:
>> TCP-AO, similarly to TCP-MD5, needs to allocate tfms on a slow-path,
>> which is setsockopt() and use crypto ahash requests on fast paths,
>> which are RX/TX softirqs. Also, it needs a temporary/scratch buffer
>> for preparing the hash.
>>
>> Rework tcp_md5sig_pool in order to support other hashing algorithms
>> than MD5. It will make it possible to share pre-allocated crypto_ahash
>> descriptors and scratch area between all TCP hash users.
>>
>> Internally tcp_sigpool preferences crypto_clone_ahash() API over
>> pre-allocating per-CPU crypto requests. Kudos to Herbert, who provided
>> this new crypto API [1]. Currently, there's still per-CPU crypto request
>> allocation fallback, that is needed for ciphers, that yet don't support
>> cloning (TCP-AO requires cmac(aes128) in RFC5925).
>>
>> I was a little concerned over GFP_ATOMIC allocations of ahash and
>> crypto_request in RX/TX (see tcp_sigpool_start()), so I benchmarked both
>> "backends" with different algorithms, using patched version of iperf3[2].
>> On my laptop with i7-7600U @ 2.80GHz:
>>
>>                          clone-tfm                per-CPU-requests
>> TCP-MD5                  2.25 Gbits/sec           2.30 Gbits/sec
>> TCP-AO(hmac(sha1))       2.53 Gbits/sec           2.54 Gbits/sec
>> TCP-AO(hmac(sha512))     1.67 Gbits/sec           1.64 Gbits/sec
>> TCP-AO(hmac(sha384))     1.77 Gbits/sec           1.80 Gbits/sec
>> TCP-AO(hmac(sha224))     1.29 Gbits/sec           1.30 Gbits/sec
>> TCP-AO(hmac(sha3-512))    481 Mbits/sec            480 Mbits/sec
>> TCP-AO(hmac(md5))        2.07 Gbits/sec           2.12 Gbits/sec
>> TCP-AO(hmac(rmd160))     1.01 Gbits/sec            995 Mbits/sec
>> TCP-AO(cmac(aes128))     [not supporetd yet]      2.11 Gbits/sec
>>
>> So, it seems that my concerns don't have strong grounds and per-CPU
>> crypto_request allocation can be dropped/removed from tcp_sigpool once
>> ciphers get crypto_clone_ahash() support.
> 
> This support is now in the upstream kernel.  Please let me know
> if you run into any issues using it.

Hi Herbert, thanks for your patches. Could you point me to the repo that
has ciphers clone-tfm support? I've looked in Torvald's/master, your
cryptodev-2.6.git and in linux-next, but I can't see anywhere in
cmac_create() something of inst->alg.base.clone_tfm = cmac_clone_tfm kind.

As I wrote two paragraphs above, it's required for TCP-AO to provide
cmac(aes128) support. Let me know if you have cmac clone-tfm somewhere
or if you're cooking it. On the cover-letter for this patch set, it's in
TODO.

Thanks,
         Dmitry


