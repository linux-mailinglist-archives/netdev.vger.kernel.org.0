Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A308E5AFF97
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 10:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiIGIv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 04:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIGIv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 04:51:27 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E76C895DB
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 01:51:25 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z8so18658524edb.6
        for <netdev@vger.kernel.org>; Wed, 07 Sep 2022 01:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=sMwf+4Qa0oDcAfmEKyOzVnlT9knkPpFo0fLzfGKsyJg=;
        b=5rkqGiUY61CvaVbFuB7J9cW4wMJAqWUpU9RdlvXI3JIEw+3ZO7D1AmvN1YtVDfdsvl
         8N25CQ83Ind7Y0ExV/aT2IxsgTh9r/Dwe0pFKdG5rl5jKonJlq3aYysyDNWLcYQ0ah3M
         a+Tq94K7AdY93p1kNUeu8o3cYhxvXZHZSoiHoVpcLwzmjLVYGlslZQXEXrbp2wZX+doC
         Ay/iHCSLaKsCpgdc2N0WDagRvVterDhQje2oN2BaGHrZH5mXgl2sPh6zPJIXkb6wErtg
         ONDufTf0g5U2LyROr5sOd8ZfmHnxHn1fNdzNKEr7/+w2ERrK3qo4y5mNFPoruSy4z6+u
         mxaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=sMwf+4Qa0oDcAfmEKyOzVnlT9knkPpFo0fLzfGKsyJg=;
        b=r3MK+jbehfAwHfB3nf8MKvgmr+5QoWQlZUBzDCu6IkGKhtJGDGvj3/0OEVUqGmgfpb
         QYTqvT6U0iVYa+F1BwPRgqFODxNNvlpG+4SL6blUOV4ZHasf9SYMIHSYxUivDCfRFIHK
         OwnGInnb0xS3c5nJb7u1w7v29PSo+qFnClsgy/D+o66YlM2rB+sgVDlAwdYB4vgum1dd
         16jxwv2OqXUzy/Ra0fzMoAg2EgmxB7uKtIjrnH5Yi+eD+hx6i+iASMqcJuikTM5DZo5o
         vJNqQq75ObLXMfcOTSfvO+e/pJNhWkOwb1RQ6UEpXyBvkSPAcwv5dXhADrHMEi9T9Z+n
         VKMA==
X-Gm-Message-State: ACgBeo38TgV4ZnO3koOoGj016mX31UNoEPoFqCGd6rIOTeNAL6Qhzpxk
        NSuTVtr299t00s0mo5VZTYWO6Q==
X-Google-Smtp-Source: AA6agR5oWNRcBXhwwCNsaXplqSNZ4pMAjVttS+0vtmNfaUNTs9zO4uCMcJjtIb+kzZwvt57HMP0YDg==
X-Received: by 2002:aa7:dd0a:0:b0:44e:a27b:fec with SMTP id i10-20020aa7dd0a000000b0044ea27b0fecmr2184631edv.168.1662540683593;
        Wed, 07 Sep 2022 01:51:23 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:ef98:1cae:6a14:a74f? ([2a02:578:8593:1200:ef98:1cae:6a14:a74f])
        by smtp.gmail.com with ESMTPSA id l18-20020a1709063d3200b00722e50dab2csm8007228ejf.109.2022.09.07.01.51.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 01:51:23 -0700 (PDT)
Message-ID: <873298fe-7fc2-4417-2852-5180f81f94aa@tessares.net>
Date:   Wed, 7 Sep 2022 10:51:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net v2] net: mptcp: fix unreleased socket in accept queue
Content-Language: en-GB
To:     menglong8.dong@gmail.com, pabeni@redhat.com
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, fw@strlen.de,
        peter.krystad@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>
References: <20220907083304.605526-1-imagedong@tencent.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20220907083304.605526-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Menglong,

On 07/09/2022 10:33, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> The mptcp socket and its subflow sockets in accept queue can't be
> released after the process exit.
> 
> While the release of a mptcp socket in listening state, the
> corresponding tcp socket will be released too. Meanwhile, the tcp
> socket in the unaccept queue will be released too. However, only init
> subflow is in the unaccept queue, and the joined subflow is not in the
> unaccept queue, which makes the joined subflow won't be released, and
> therefore the corresponding unaccepted mptcp socket will not be released
> to.

Thank you for the patch!

(...)

> ---
>  net/mptcp/protocol.c | 13 +++++++++----
>  net/mptcp/subflow.c  | 33 ++++++++-------------------------
>  2 files changed, 17 insertions(+), 29 deletions(-)
> 
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index d398f3810662..fe6b7fbb145c 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -2796,13 +2796,12 @@ static void __mptcp_destroy_sock(struct sock *sk)
>  	sock_put(sk);
>  }
>  
> -static void mptcp_close(struct sock *sk, long timeout)
> +void mptcp_close_nolock(struct sock *sk, long timeout)

I didn't look at it into details but like the previous previous, I don't
think this one compiles without errors: you define this (non static)
function here in protocol.c but you don't "expose" it in protocol.h ...
(see below)

> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index c7d49fb6e7bd..cebabf2bb222 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c

(...)

> @@ -1765,11 +1740,19 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
>  		struct sock *sk = (struct sock *)msk;
>  		bool slow;
>  
> +		sock_hold(sk);
>  		slow = lock_sock_fast_nested(sk);
>  		next = msk->dl_next;
>  		msk->first = NULL;
>  		msk->dl_next = NULL;
> +
> +		/* mptcp_close_nolock() will put a extra reference on sk,
> +		 * so we hold one here.
> +		 */
> +		sock_hold(sk);
> +		mptcp_close_nolock(sk, 0);

... I guess the compiler will complain if you try to use it here from
subflow.c, no?

Also, did you have the opportunity to run the different MPTCP selftests
with this patch?

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
