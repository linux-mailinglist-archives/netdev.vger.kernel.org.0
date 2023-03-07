Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B18C6AE4BA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 16:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjCGPar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 10:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjCGPai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 10:30:38 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B2C6426F
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 07:30:32 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id u9so53914544edd.2
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 07:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678203031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1cJcrz6lSZqEPyZpf9el6jLT5Rfm1txs/U7Twr5hdkM=;
        b=kazVUt+JNQmxHwqC8SlVYNyAUi5+4UZhgXJYjEL0D+IoxS/OdobVQNMeqSUBo4wy6M
         fI0ghGG2qFgdSapQPainruurC6BpebWE+YLtr6oTyUFlfLhvJV8sYm4LE/1xwiVyjlFy
         in63LJarU82nT51BzKq9fphjAxjROSrrxxu5854RKWBTXFe1JUO1t4v0yppuiHunxdfz
         XowuyvHdDPyYTPSwH2JG9yQeY/AjZIj4WhwwBGyYXmuWfn1V2uq4CYsKojAYWCNff1/P
         4IwoHTnz+vKNq0JeV6TXJg0vyORD8cMqOLUAvtJSOy9q6AtbXANk676SQfu+GKVdBb0z
         ZH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678203031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1cJcrz6lSZqEPyZpf9el6jLT5Rfm1txs/U7Twr5hdkM=;
        b=lENYsvstchKP3zQNqi1X25gFa0o7DRZ1GuPA6wMkaKoKBPRXyISOjP+u3LqDIDergz
         6zTeh13WqYZNUrfI36urTTZl/aA7B/OTHJQxGc5FjWy1Zm9nt6m/0K5wc1of8LnSkfDJ
         rVQKt+FFA7NIwpaMD9tAcuh1ZmRqEAQCTnBkq2GnQzYuBOUaOuKm0m1R6q8gZ85ar3xU
         IyQKiwdjEnK5yeNXgA2uFozBITJ1tZTOaV7M3V79jq5ueMpKdTR2H0bRtfxbOtQsKr6G
         yLfR7LzpdX2hfunQ1RaiXmXA/aC/I6fTyjMnBJjJ/Ju2x356ZwWA6CUJTaVe9l8+WMPI
         ycvQ==
X-Gm-Message-State: AO0yUKU3lb+hXoCwK948u/DiinsAVg6FDY1++ANSvmKwe4GDOIvL8Ut3
        Pw/s8XCe4c6uv7ofGImkzXA=
X-Google-Smtp-Source: AK7set8GmC8eH95F5oksSGefBb3wXqvsxcpsux1VduvhZsdj7EaSOO/dWpRnMIHLBpyXfqvzCcJmEQ==
X-Received: by 2002:a17:906:6dd8:b0:8eb:27de:444d with SMTP id j24-20020a1709066dd800b008eb27de444dmr12537429ejt.0.1678203030639;
        Tue, 07 Mar 2023 07:30:30 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:d2b4])
        by smtp.gmail.com with ESMTPSA id e7-20020a170906c00700b008cff300cf47sm6197661ejz.72.2023.03.07.07.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Mar 2023 07:30:30 -0800 (PST)
Message-ID: <3e4544cf-a8b3-4eeb-9ace-327e55ab37d7@gmail.com>
Date:   Tue, 7 Mar 2023 15:29:32 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next] net: reclaim skb->scm_io_uring bit
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20230307145959.750210-1-edumazet@google.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230307145959.750210-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 14:59, Eric Dumazet wrote:
> Commit 0091bfc81741 ("io_uring/af_unix: defer registered
> files gc to io_uring release") added one bit to struct sk_buff.
> 
> This structure is critical for networking, and we try very hard
> to not add bloat on it, unless absolutely required.
> 
> For instance, we can use a specific destructor as a wrapper
> around unix_destruct_scm(), to identify skbs that unix_gc()
> has to special case.

We also should be able to use struct unix_sock :: gc_flags for
that, not sure why I didn't do it in the first place.

In any case, looks good, thanks

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/skbuff.h | 2 --
>   include/net/af_unix.h  | 1 +
>   io_uring/rsrc.c        | 3 +--
>   net/unix/garbage.c     | 2 +-
>   net/unix/scm.c         | 6 ++++++
>   5 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index ff7ad331fb8259fd06c07913dfa197d7ac448390..fe661011644b8f468ff5e92075a6624f0557584c 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -810,7 +810,6 @@ typedef unsigned char *sk_buff_data_t;
>    *	@csum_level: indicates the number of consecutive checksums found in
>    *		the packet minus one that have been verified as
>    *		CHECKSUM_UNNECESSARY (max 3)
> - *	@scm_io_uring: SKB holds io_uring registered files
>    *	@dst_pending_confirm: need to confirm neighbour
>    *	@decrypted: Decrypted SKB
>    *	@slow_gro: state present at GRO time, slower prepare step required
> @@ -989,7 +988,6 @@ struct sk_buff {
>   #endif
>   	__u8			slow_gro:1;
>   	__u8			csum_not_inet:1;
> -	__u8			scm_io_uring:1;
>   
>   #ifdef CONFIG_NET_SCHED
>   	__u16			tc_index;	/* traffic control index */
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index 480fa579787e597f264ae26a32e519c235ce1d39..45ebde587138e59f8331d358420d3fca79d9ee66 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -11,6 +11,7 @@
>   void unix_inflight(struct user_struct *user, struct file *fp);
>   void unix_notinflight(struct user_struct *user, struct file *fp);
>   void unix_destruct_scm(struct sk_buff *skb);
> +void io_uring_destruct_scm(struct sk_buff *skb);
>   void unix_gc(void);
>   void wait_for_unix_gc(void);
>   struct sock *unix_get_socket(struct file *filp);
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a59fc02de5983c4f789e9cdfea3a1376f578ebe6..27ceda3b50cf4e677cde5e2417a80adad66e162f 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -867,8 +867,7 @@ int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
>   
>   		UNIXCB(skb).fp = fpl;
>   		skb->sk = sk;
> -		skb->scm_io_uring = 1;
> -		skb->destructor = unix_destruct_scm;
> +		skb->destructor = io_uring_destruct_scm;
>   		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
>   	}
>   
> diff --git a/net/unix/garbage.c b/net/unix/garbage.c
> index dc27635403932154f3dec069c2e10d2ae365d8cb..2405f0f9af31c0ccefe2aa404002cfab8583c090 100644
> --- a/net/unix/garbage.c
> +++ b/net/unix/garbage.c
> @@ -305,7 +305,7 @@ void unix_gc(void)
>   	 * release.path eventually putting registered files.
>   	 */
>   	skb_queue_walk_safe(&hitlist, skb, next_skb) {
> -		if (skb->scm_io_uring) {
> +		if (skb->destructor == io_uring_destruct_scm) {
>   			__skb_unlink(skb, &hitlist);
>   			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
>   		}
> diff --git a/net/unix/scm.c b/net/unix/scm.c
> index aa27a02478dc1a7e4022f77e6ea7ac55f40b95c7..f9152881d77f636f9500d1b57fdda584df845fc2 100644
> --- a/net/unix/scm.c
> +++ b/net/unix/scm.c
> @@ -152,3 +152,9 @@ void unix_destruct_scm(struct sk_buff *skb)
>   	sock_wfree(skb);
>   }
>   EXPORT_SYMBOL(unix_destruct_scm);
> +
> +void io_uring_destruct_scm(struct sk_buff *skb)
> +{
> +	unix_destruct_scm(skb);
> +}
> +EXPORT_SYMBOL(io_uring_destruct_scm);

-- 
Pavel Begunkov
