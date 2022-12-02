Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E13640A29
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbiLBQFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiLBQF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:05:29 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99BCB10D3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:05:28 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f18so8475816wrj.5
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 08:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A4plGiHlub60BVY8D9kHvBG6FtL4/mP8A73R7KLdoXE=;
        b=kDwyRP3HDPtXHMXyiMzur1MfMJv8oUqOvot3X20rgo7thl07NDJXSVp6Op+TLLldDk
         GsPw5mQJgmZnlYVU1QHpiSwOzRRrwVaE5rLuoqlxVVgy1Rddj9sqaj4m/pQzACZHcPaf
         5DA/xrfGrVaDRF3UC2sobZlFX7bZbHZOJVMP0dym5iBxtkoDsNfFGR/pTkTynnbY74L6
         sPbAxRBNmoYioFldYFlj5cGRp4e8M6XooNTmdp4ZWhUSY7tB7UXirs8K1zya9M1pVWUA
         G/8bvhq5dSKgizuQORpnq57EKe7iAl5kjN91Cl3IsX0CsB5gsuuF26Wxur0YehZL9jzY
         FOxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4plGiHlub60BVY8D9kHvBG6FtL4/mP8A73R7KLdoXE=;
        b=VnfXhJdjpRv/mT83wu1nHuGslW3Vw6abtBWkq2dFCv8ZxqB8grffSYdQWKxfnej54W
         cKc/Fj3sKHxNZzD47YjU4/51VOj8RCicNMDIzIvsYUgbB0xTCNsE8bJsVS09bINlyk4o
         Og6+RjwihDJTwMHjS0D3/+F/J4N2yaj0mpqv/Xvc5uAsLZal7hIVISS/VosnBrJjgNGH
         zb57WV+u2d0Gr07tqgoocETmVTmlYBcoA9heYip4tbvwtY3HN4SCQsRXql94/H5v3Dq1
         WiUX2AcraWhtRM2e3kPPQ3C+k6chLWSHY3CUSVkjfW/xoSW2M4tbJ33dj30aBntH1F76
         Yxlw==
X-Gm-Message-State: ANoB5pkF1M/uxCwyn6kizVi4oM/5af6ElHfi8q4BICNaIY3Nn/lxW52N
        P0zoSG2EU/z7B5i/MKhFhRMYXx/4ZEbg9lmL
X-Google-Smtp-Source: AA0mqf7b30ci1jTYzdKabWp0mqjfvjjCgu9+9DHeaSGA6AmZeZJAsIyIq0ztAPAp4fYw3ETrpk0BaQ==
X-Received: by 2002:adf:ea01:0:b0:242:272b:ed2a with SMTP id q1-20020adfea01000000b00242272bed2amr10863879wrm.378.1669997126990;
        Fri, 02 Dec 2022 08:05:26 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id n187-20020a1ca4c4000000b003d005aab31asm9185021wme.40.2022.12.02.08.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 08:05:26 -0800 (PST)
Message-ID: <2d42f8cd-2301-44ca-2a4b-2ddbadd3408e@arista.com>
Date:   Fri, 2 Dec 2022 16:05:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next] tcp: use 2-arg optimal variant of kfree_rcu()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        "Paul E . McKenney" <paulmck@kernel.org>
References: <20221202052847.2623997-1-edumazet@google.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <20221202052847.2623997-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/22 05:28, Eric Dumazet wrote:
> kfree_rcu(1-arg) should be avoided as much as possible,
> since this is only possible from sleepable contexts,
> and incurr extra rcu barriers.
> 
> I wish the 1-arg variant of kfree_rcu() would
> get a distinct name, like kfree_rcu_slow()
> to avoid it being abused.

Thanks again!

> Fixes: 459837b522f7 ("net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: Paul E. McKenney <paulmck@kernel.org>

Reviewed-by: Dmitry Safonov <dima@arista.com>

> ---
>  net/ipv4/tcp_ipv4.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7fae586405cfb10011a0674289280bf400dfa8d8..8320d0ecb13ae1e3e259f3c13a4c2797fbd984a5 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1245,7 +1245,7 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
>  
>  			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
>  			rcu_assign_pointer(tp->md5sig_info, NULL);
> -			kfree_rcu(md5sig);
> +			kfree_rcu(md5sig, rcu);
>  			return -EUSERS;
>  		}
>  	}
> @@ -1271,7 +1271,7 @@ int tcp_md5_key_copy(struct sock *sk, const union tcp_md5_addr *addr,
>  			md5sig = rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk));
>  			net_warn_ratelimited("Too many TCP-MD5 keys in the system\n");
>  			rcu_assign_pointer(tp->md5sig_info, NULL);
> -			kfree_rcu(md5sig);
> +			kfree_rcu(md5sig, rcu);
>  			return -EUSERS;
>  		}
>  	}

-- 
          Dmitry

