Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E471606083
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 14:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJTMp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 08:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiJTMpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 08:45:25 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7918D16910F
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:45:21 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l14-20020a05600c1d0e00b003c6ecc94285so2317429wms.1
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 05:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W7TpexVXzoD6Pi9Bw4JOhzbTLopx5qELK6AW5BpVBlg=;
        b=POonAFutxlJ5UiTLuwhgcNB0+oFdCIjAtq2PfAamQpywlez401oRmlVDeOvEux7vnt
         h+ZBBiDfIudQJjPsVLH7DMRJhNaphLp2Niq02RWtEAqjHahi9zlB3yTZ1EVBywgkKftG
         u6e7Dvy6c3PAMooOBg8vSY81Hp6vhVDaqm8z3VwNfdZ6wTdsnp0rnC3vCkBRgy5R2Equ
         ExEHFLnyltUlyjl3dj9bT8+vsLCOpKBUwHv5m2P/LwM47BBCqaCNfwJlLUx7rurSEeXW
         /r4A8X7dmQF+MW4O9ng8VKgBDNvhyCuJwAp1TYoeDpW2iguYlW0pbyv/FEMKhYkvHo0w
         ssfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7TpexVXzoD6Pi9Bw4JOhzbTLopx5qELK6AW5BpVBlg=;
        b=t1llOPOlCfIQt9v+K9GypytE8/VU2HQ1ItSRpNdJJGyW6ABhdKqUSZ6lxZPflqQy4n
         blbfbvAyPDVB00RdM3QzmTJtLqHbtNQbhEgLl2zWeujhc7U72YrdptsdASrL5lTyPmEU
         6Y3wOHF4HfA2Py0VC81zVNaazS9voRBMKv7qpq5FmQkXHLVM95EVc/q6K1g8jlz9nuG9
         JxC1ZVkuf9sZQBUIbZaQMmEdLyX5BscrawchZzXjcAPtabSxiyTnWBd5jLvuBkgxmcI+
         8kA4yl+kJa7dIMCWh+9ayXy4bOe0dJjentwPXYPNJjG3DsdD7xWf22wvP5v4Oi1mz7Uu
         25RQ==
X-Gm-Message-State: ACrzQf1cwmTIR5/DT3rlcj3OrWUUiaqGOzMy6P0KiPQ9TVLsp244IIgi
        zOkEg0eE7loLXXMf14F0EjUANg==
X-Google-Smtp-Source: AMsMyM7kmIKbIy0Q4AvE6vV+FPVTFZDhMltJBAwIwo1aakb0ftG8fFF3hY2kgJfaz8Br7UGgrz9KSQ==
X-Received: by 2002:a05:600c:4e8c:b0:3c6:ea09:9cf0 with SMTP id f12-20020a05600c4e8c00b003c6ea099cf0mr9165284wmq.43.1666269919638;
        Thu, 20 Oct 2022 05:45:19 -0700 (PDT)
Received: from ?IPV6:2a02:578:8593:1200:d3a7:8451:3ef5:2fdf? ([2a02:578:8593:1200:d3a7:8451:3ef5:2fdf])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5009000000b0022e3d7c9887sm16186491wrt.101.2022.10.20.05.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 05:45:19 -0700 (PDT)
Message-ID: <d92dae5c-30bd-897d-8ffe-13a1a860541c@tessares.net>
Date:   Thu, 20 Oct 2022 14:45:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 net-next 1/5] inet6: Remove inet6_destroy_sock() in
 sk->sk_prot->destroy().
Content-Language: en-GB
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        mptcp@lists.linux.dev
References: <20221019223603.22991-1-kuniyu@amazon.com>
 <20221019223603.22991-2-kuniyu@amazon.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
In-Reply-To: <20221019223603.22991-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuniyuki

On 20/10/2022 00:35, Kuniyuki Iwashima wrote:
> After commit d38afeec26ed ("tcp/udp: Call inet6_destroy_sock()
> in IPv6 sk->sk_destruct()."), we call inet6_destroy_sock() in
> sk->sk_destruct() by setting inet6_sock_destruct() to it to make
> sure we do not leak inet6-specific resources.
> 
> Now we can remove unnecessary inet6_destroy_sock() calls in
> sk->sk_prot->destroy().
> 
> DCCP and SCTP have their own sk->sk_destruct() function, so we
> change them separately in the following patches.

(...)

> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index f599ad44ed24..2e16c897c229 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -3898,12 +3898,6 @@ static const struct proto_ops mptcp_v6_stream_ops = {
>  
>  static struct proto mptcp_v6_prot;
>  
> -static void mptcp_v6_destroy(struct sock *sk)
> -{
> -	mptcp_destroy(sk);
> -	inet6_destroy_sock(sk);
> -}
> -
>  static struct inet_protosw mptcp_v6_protosw = {
>  	.type		= SOCK_STREAM,
>  	.protocol	= IPPROTO_MPTCP,
> @@ -3919,7 +3913,6 @@ int __init mptcp_proto_v6_init(void)
>  	mptcp_v6_prot = mptcp_prot;
>  	strcpy(mptcp_v6_prot.name, "MPTCPv6");
>  	mptcp_v6_prot.slab = NULL;
> -	mptcp_v6_prot.destroy = mptcp_v6_destroy;
>  	mptcp_v6_prot.obj_size = sizeof(struct mptcp6_sock);
>  
>  	err = proto_register(&mptcp_v6_prot, 1);

Thank you for the new version!

For the modifications in net/mptcp here above:

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
