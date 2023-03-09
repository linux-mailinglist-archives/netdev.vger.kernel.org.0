Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7AF6B2880
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjCIPQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjCIPP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:15:58 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324F82FCFA
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:15:32 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id cw28so8372328edb.5
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678374930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mQA8zVGSZEd3NdUPFxku2QhVjxGbRpRzZCwjcHEfzPQ=;
        b=YB2nEXNXk28bv80cXK816Sek1wqu8I73hZbxilr80g2zX1FjE/G1gS9XL+nbkADISx
         QDBp7Ludy8l+u6DNvGyK5gHvID1vFhxxpheMr6QHvP8byDJVk4Hm5XS3MCw6izo+E78h
         UkrPUF/XECN076Pt/PdrZXIRpFyQmBAcqonqapeoKwXLk8FIXMhKqgEIih9pYhl3nPrA
         6OIuPJVlVb2OvrMKAD0VaTCrDxzuN7LyWe4TAl29drdOytpfidIMLaZbAcNw5QDRcfrV
         VPPajqgJD/Ol4RCkmd9H/DV/jNyuvs1WSmhfkF/ntqWFipmezl2Wj/Iiux/YLz674vaG
         jNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678374930;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQA8zVGSZEd3NdUPFxku2QhVjxGbRpRzZCwjcHEfzPQ=;
        b=r44aCTDhbTIItp6Kv4zXP8MCWyi5Vi3gmlxsjBc3qEgmDzdYPNQUOO/PsRpZ60PNtF
         7rGup9q/gR/cXDIgHw4OktU1lVtFUSTO5efJinEngXO3q9YfRlAKiV2T8aKWzKBm/OIl
         8LQhv37i1SIkRC8TKaL2ck4mtK99TokPSyo2IgbIamABmd9f+maR4tE/zTuA2p3L9KUq
         bkbvbEQdmpJVKP2AQr3o6PkavgQM7cO9OLZ92Hj9hHO8E2OKAvzDw9csQfdM0kusRyr8
         p2/CujAUPpbR4TgnZsd63excZB70LNnDZCwvXlDYiYuhlE+W1SP3utsqpjkIvEGyMWFY
         YKDw==
X-Gm-Message-State: AO0yUKVA8Aa+AVWLFoeqzZMVkfH2r5AWJMBu1JxhN+unohSUf9MyksdK
        3ZMmPcWEBPCQiXxPvrei8oo=
X-Google-Smtp-Source: AK7set8ODD88EaIsyyMr61ykKYqcL5FzCVnrokJrJEZ32c2Me5wJAYcgqQ+NWjMIsIZ5gCbjnukBVw==
X-Received: by 2002:a17:906:c001:b0:8b2:d70c:34ae with SMTP id e1-20020a170906c00100b008b2d70c34aemr22676689ejz.71.1678374930617;
        Thu, 09 Mar 2023 07:15:30 -0800 (PST)
Received: from [192.168.0.106] ([77.126.33.94])
        by smtp.gmail.com with ESMTPSA id si7-20020a170906cec700b008e68d2c11d8sm8964756ejb.218.2023.03.09.07.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 07:15:29 -0800 (PST)
Message-ID: <3c9eaf1b-b9eb-ed06-076a-de9a36d0993f@gmail.com>
Date:   Thu, 9 Mar 2023 17:15:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 7/7] tls: rx: do not use the standard
 strparser
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        borisp@nvidia.com, john.fastabend@gmail.com, maximmi@nvidia.com,
        tariqt@nvidia.com, vfedorenko@novek.ru,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220722235033.2594446-1-kuba@kernel.org>
 <20220722235033.2594446-8-kuba@kernel.org>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20220722235033.2594446-8-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        NORMAL_HTTP_TO_IP,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,WEIRD_PORT autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/07/2022 2:50, Jakub Kicinski wrote:
> TLS is a relatively poor fit for strparser. We pause the input
> every time a message is received, wait for a read which will
> decrypt the message, start the parser, repeat. strparser is
> built to delineate the messages, wrap them in individual skbs
> and let them float off into the stack or a different socket.
> TLS wants the data pages and nothing else. There's no need
> for TLS to keep cloning (and occasionally skb_unclone()'ing)
> the TCP rx queue.
> 
> This patch uses a pre-allocated skb and attaches the skbs
> from the TCP rx queue to it as frags. TLS is careful never
> to modify the input skb without CoW'ing / detaching it first.
> 
> Since we call TCP rx queue cleanup directly we also get back
> the benefit of skb deferred free.
> 
> Overall this results in a 6% gain in my benchmarks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Hi Jakub,

A few fixes were introduced for this patch, but it seems to still cause 
issues.

I'm running simple client/server test with wrk and nginx and TLS RX 
device offload on.
It fails with TlsDecryptError on the client side for the large file 
(256000b), while succeeding for the small one (10000b). See repro 
details below.

I narrowed the issue down to this offending patch, by applying a few 
reverts (had to solve trivial conflicts):

Revert "tls: rx: do not use the standard strparser"
Revert "tls: rx: fix the false positive warning"
Revert "tls: rx: device: bound the frag walk"
Revert "tls: rx: device: don't try to copy too much on detach"
Revert "tls: rx: react to strparser initialization errors"
Revert "tls: strp: make sure the TCP skbs do not have overlapping data"

The error is caught by the if below, inside gcmaes_decrypt.

  819         /* Compare generated tag with passed in tag. */ 

  820         if (crypto_memneq(auth_tag_msg, auth_tag, auth_tag_len)) { 

  821                 memzero_explicit(auth_tag, sizeof(auth_tag)); 

  822                 return -EBADMSG; 

  823         }

but I couldn't yet identify the root cause.

Any idea what could it be?

Reproduction:

$ ethtool --features eth2 tls-hw-rx-offload on

$ wrk_openssl_3_0_0 -b2.2.2.2 -t10 -c1000 -d5 --timeout 5s 
https://2.2.2.3:20443/10000b.img
Running 5s test @ https://2.2.2.3:20443/10000b.img
   10 threads and 1000 connections
Ready 8/10
Ready 2/10
Ready 9/10
Ready 3/10
Ready 4/10
Ready 6/10
Ready 0/10
Ready 1/10
Ready 7/10
Ready 5/10
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
   Thread Stats   Avg      Stdev     Max   +/- Stdev
     Latency   112.97ms   19.05ms 160.31ms   80.71%
     Req/Sec     0.88k   122.34     1.07k    61.86%
   37495 requests in 5.06s, 366.24MB read
Requests/sec:   7415.86
Transfer/sec:     72.44MB

$ cat /proc/net/tls_stat
TlsCurrTxSw                             0
TlsCurrRxSw                             0
TlsCurrTxDevice                         0
TlsCurrRxDevice                         0
TlsTxSw                                 0
TlsRxSw                                 0
TlsTxDevice                             1000
TlsRxDevice                             1000
TlsDecryptError                         0
TlsRxDeviceResync                       1000
TlsDecryptRetry                         0
TlsRxNoPadViolation                     0

$ wrk_openssl_3_0_0 -b2.2.2.2 -t10 -c1000 -d5 --timeout 5s 
https://2.2.2.3:20443/256000b.img
Running 5s test @ https://2.2.2.3:20443/256000b.img
   10 threads and 1000 connections
Ready 6/10
Ready 2/10
Ready 7/10
Ready 9/10
Ready 1/10
Ready 4/10
Ready 8/10
Ready 3/10
Ready 5/10
Ready 0/10
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
Ready all
   Thread Stats   Avg      Stdev     Max   +/- Stdev
     Latency     3.94s   106.78ms   4.10s    50.00%
     Req/Sec     0.67      0.82     2.00     83.33%
   38 requests in 7.71s, 154.14MB read
   Socket errors: connect 0, read 1810, write 0, timeout 0
Requests/sec:      4.93
Transfer/sec:     19.98MB

$ cat /proc/net/tls_stat
TlsCurrTxSw                             0
TlsCurrRxSw                             0
TlsCurrTxDevice                         0
TlsCurrRxDevice                         0
TlsTxSw                                 0
TlsRxSw                                 0
TlsTxDevice                             3810
TlsRxDevice                             3810
TlsDecryptError                         3634
TlsRxDeviceResync                       3060
TlsDecryptRetry                         0
TlsRxNoPadViolation                     0

More monitors:

$ bpftrace -e 'kretprobe:generic_gcmaes_decrypt { @retval[retval] = 
count(); }'
Attaching 1 probe...
^C

@retval[4294967222]: 2067
@retval[0]: 26143


$ bpftrace -e 'kprobe:generic_gcmaes_decrypt { @[kstack] = count(); }'
Attaching 1 probe...
^C

@[
     generic_gcmaes_decrypt+1
     tls_decrypt_sg+1258
     tls_rx_one_record+72
     tls_sw_recvmsg+870
     inet_recvmsg+71
     sock_recvmsg+68
     ____sys_recvmsg+111
     ___sys_recvmsg+126
     __sys_recvmsg+78
     do_syscall_64+61
     entry_SYSCALL_64_after_hwframe+70
]: 27623
