Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C8469D1BC
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjBTQ50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:57:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbjBTQ5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:57:25 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE091D911
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:57:23 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id p8so2036207wrt.12
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kwv6znKz3Eoo3aqqWo9NDOw9GIUxjeSkvIbkrVuAVC0=;
        b=QCtW9f52c3WhCXFog/acp9ajq3DG6g9cyJLFXB3PErOf6SUbisSOkA+NFCH+j1XvDT
         /5vODNZtc3QAmOVZyfN9iydI9hLfXLmciA87f1fp/knIbEPbGXw8aZ11sWWzR7NWkr3c
         2AEWukfSysI9WGtAQcyVSbctuzi06lGDS3B6y0bf9owm2+ZR7pVHXNJP26DD6F+tZ7MA
         PB8ziBcNmylx/L023iJWGsfCUkP921ifoGqI+b07c+uF7+7ETpoiYz0CExkLOJWxribi
         U++SsChuv9uqmsI+4q+XBx+sq9lOGrGB3fNwmYKF20JFet1MhWc1Dzb8Xmf8FDAIS9Le
         nHkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kwv6znKz3Eoo3aqqWo9NDOw9GIUxjeSkvIbkrVuAVC0=;
        b=twUC8SVYWbmJrwAqeD4le6wiCZXXP3vyZujL1OM/2BHI7vrkg+utDaN+84lN/1miL5
         pi2UUF5OkJEmrYsLtaBKFjIgOqhTCs7CVUMtxQckKfdmhCbxdB2vYPbfaEm49eyCbg0+
         H4BWGOFdAz/wrtZkm2a2wpYEVCYS0bEyRUMTmFcmdLkC2dUXGMbQ3D+1311KtvlnKsCK
         DB/HRw94YhfI92AZIl6E+WqE8g6DqCHhHwNRor+xdE8GoRY9uXXJUhic2Cyt/42KdyFN
         eFMPHHeFtYGSH2Xm9Gthz7UESSGKWgzTz3/eV/bV7kJhXR7TECYvbIGfkrvPBa0UBPQ6
         ao8g==
X-Gm-Message-State: AO0yUKX+bMwp3f8ZluXduiRnMFy7GeYnmO36aGEg/xm/Tona1HXHXqgI
        VofCq1qdExtjAArMPVwxQTzkzA==
X-Google-Smtp-Source: AK7set9utMidQPfF/+lU6HJd7mSFiYVFPiN9AsN/ma4nxOxNzwTYBKzLhzb3LnnENQVkLO1hje3MYg==
X-Received: by 2002:a5d:5147:0:b0:2c5:52c3:cdb9 with SMTP id u7-20020a5d5147000000b002c552c3cdb9mr2160492wrt.66.1676912242321;
        Mon, 20 Feb 2023 08:57:22 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id z3-20020adff1c3000000b002c559def236sm569446wro.57.2023.02.20.08.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Feb 2023 08:57:21 -0800 (PST)
Message-ID: <bd40ff2f-b015-4ed4-7755-f9d547c8b868@arista.com>
Date:   Mon, 20 Feb 2023 16:57:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v4 01/21] net/tcp: Prepare tcp_md5sig_pool for TCP-AO
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Laight <David.Laight@aculab.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Francesco Ruggeri <fruggeri05@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
References: <20230215183335.800122-1-dima@arista.com>
 <20230215183335.800122-2-dima@arista.com>
 <Y/NAXtPrOkzjLewO@gondor.apana.org.au>
Content-Language: en-US
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y/NAXtPrOkzjLewO@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

On 2/20/23 09:41, Herbert Xu wrote:
> On Wed, Feb 15, 2023 at 06:33:15PM +0000, Dmitry Safonov wrote:
>> TCP-AO similarly to TCP-MD5 needs to allocate tfms on a slow-path, which
>> is setsockopt() and use crypto ahash requests on fast paths, which are
>> RX/TX softirqs. It as well needs a temporary/scratch buffer for
>> preparing the hashing request.
>>
>> Extend tcp_md5sig_pool to support other hashing algorithms than MD5.
>> Move it in a separate file.
>>
>> This patch was previously submitted as more generic crypto_pool [1],
>> but Herbert nacked making it generic crypto API. His view is that crypto
>> requests should be atomically allocated on fast-paths. So, in this
>> version I don't move this pool anywhere outside TCP, only extending it
>> for TCP-AO use-case. It can be converted once there will be per-request
>> hashing crypto keys.
>>
>> [1]: https://lore.kernel.org/all/20230118214111.394416-1-dima@arista.com/T/#u
>> Signed-off-by: Dmitry Safonov <dima@arista.com>
>> ---
>>  include/net/tcp.h        |  48 ++++--
>>  net/ipv4/Kconfig         |   4 +
>>  net/ipv4/Makefile        |   1 +
>>  net/ipv4/tcp.c           | 103 +++---------
>>  net/ipv4/tcp_ipv4.c      |  97 +++++++-----
>>  net/ipv4/tcp_minisocks.c |  21 ++-
>>  net/ipv4/tcp_sigpool.c   | 333 +++++++++++++++++++++++++++++++++++++++
>>  net/ipv6/tcp_ipv6.c      |  58 +++----
>>  8 files changed, 493 insertions(+), 172 deletions(-)
>>  create mode 100644 net/ipv4/tcp_sigpool.c
> 
> Please wait for my per-request hash work before you resubmit this.

Do you have a timeline for that work?
And if you don't mind I keep re-iterating, as I'm trying to address TCP
reviews and missed functionality/selftests.

> Once that's in place all you need is a single tfm for the whole
> system.

Unfortunately, not really: RFC5926 prescribes the mandatory-to-implement
MAC algorithms for TCP-AO: HMAC-SHA-1-96 and AES-128-CMAC-96. But since
the RFC was written sha1 is now more eligible for attacks as well as
RFC5925 has:
> The option should support algorithms other than the default, to
> allow agility over time.
> TCP-AO allows any desired algorithm, subject to TCP option
> space limitations, as noted in Section 2.2. The use of a set
> of MKTs allows separate connections to use different
> algorithms, both for the MAC and the KDF.

As well as from a customer's request we need to support more than two
required algorithms. So, this implementation let the user choose the
algorithm that is supported by crypto/ layer (more or less like xfrm does).

Which means, that it still has to support multiple tfms. I guess that
pool of tfms can be converted to use per-request keys quite easily.

> As to request pools what exactly is the point of that? Just kmalloc
> them on demand.

1) before your per-request key patches - it's not possible.
2) after your patches - my question would be: "is it better to
kmalloc(GFP_ATOMIC) in RX/TX for every signed TCP segment, rather than
pre-allocate it?"

The price of (2) may just well be negligible, but worth measuring before
switching.

Thanks,
          Dmitry
