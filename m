Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE2B5701E7
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 14:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiGKMVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 08:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiGKMVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 08:21:02 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B071758A;
        Mon, 11 Jul 2022 05:21:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id oy13so3635427ejb.1;
        Mon, 11 Jul 2022 05:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uKA5XThrP7I2nX8lNpiC7vhH5hhUaMwToTzr5MGFKtw=;
        b=YmT+PXQW+sZv0zPCwNeH7XLRn7rZwge975c83z5htppn4ZyBHGC+G0mX9Mtj00u+5G
         7oko7pUNjNOzsVJj6xQC4FaLYix6anKwMe+EQ9U6MHfuW9woVS82JpFZzH4MMhcpVa7j
         MMvjGe3HZe6/xcqclV8re6KjYC/5yNDct2rdcmyWeMagH1OXozAOzXVsTBdC6DeprtYD
         zUif+UBSXeJe6asi6TxQ47Xkr9zPC8umUt04MYIFL4HeMitbbLIGzB7vdeB7GLh0CKmY
         70K5hgSZSyNOh+GUSJ+GrJSZFPc+SZJkCGOiWXi1AClmssOhhiI6U+VNFjEG+HEFbip1
         58MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uKA5XThrP7I2nX8lNpiC7vhH5hhUaMwToTzr5MGFKtw=;
        b=hFJncy/Kd+CZjwc9bwGTIymfV3p4TrNtfm9q1wGL3AMa91moYe/iQLaJgDi7V828Wj
         5qq6zd35XNs78oRPWC0UvhZ1xqAekze9fgR4dVEIZFRFoVpCtNGtTBn1LoDdJtOSkg9d
         c0KraNA4tFPXNxT1wT6BzL3Ol8cNeqtFHLIyH3pja+dlH+n0VG/4S0OM2XJdAx9jnnXm
         mmobWYKCgVXmGWf/Z3q1O8erlkO/278jDJx4SdrRObwYPSNphRF50e+QJFjOH3aPUGmC
         m+S0SIjolF3f6TKvKor90GK0jWJvrI5ths/0AVVu+ecljSgs7ghbgLtXn/a53ai3X8ks
         0KSQ==
X-Gm-Message-State: AJIora8clVlgeLj2+jW1eVR6e3Ok4jjN/bbyHl6PigvxLi8foX94Mp5+
        BLxjEu4mvSsCcJs26RJVidhENa2TE7khJRDg
X-Google-Smtp-Source: AGRyM1tjdHvVvXfFLsXeSKQaVK3FIywDXatGxV4lcbkw/9BJ3pfvV5b9yVe5ScENPQhYaiO18bm08w==
X-Received: by 2002:a17:906:8448:b0:72b:5659:9873 with SMTP id e8-20020a170906844800b0072b56599873mr4519375ejy.117.1657542059639;
        Mon, 11 Jul 2022 05:20:59 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c093:600::1:ac34])
        by smtp.gmail.com with ESMTPSA id cb1-20020a0564020b6100b0043a6dc3c4b0sm4253373edb.41.2022.07.11.05.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 05:20:59 -0700 (PDT)
Message-ID: <a2527c63-1b74-fe10-a959-097ec7f68135@gmail.com>
Date:   Mon, 11 Jul 2022 13:20:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 06/27] net: Allow custom iter handler in
 msghdr
Content-Language: en-US
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <968c344a59315ec5d0095584a95bb7dd5a3ac617.1657194434.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <968c344a59315ec5d0095584a95bb7dd5a3ac617.1657194434.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/22 12:49, Pavel Begunkov wrote:
> From: David Ahern <dsahern@kernel.org>
> 
> Add support for custom iov_iter handling to msghdr. The idea is that
> in-kernel subsystems want control over how an SG is split.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> [pavel: move callback into msghdr]
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/linux/skbuff.h |  7 ++++---
>   include/linux/socket.h |  4 ++++
>   net/core/datagram.c    | 14 ++++++++++----
>   net/core/skbuff.c      |  2 +-
>   4 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 8e12b3b9ad6c..a8a2dd4cfdfd 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1776,13 +1776,14 @@ void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
>   void msg_zerocopy_callback(struct sk_buff *skb, struct ubuf_info *uarg,
>   			   bool success);
>   
> -int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
> -			    struct iov_iter *from, size_t length);
> +int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
> +			    struct sk_buff *skb, struct iov_iter *from,
> +			    size_t length);
>   
>   static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
>   					  struct msghdr *msg, int len)
>   {
> -	return __zerocopy_sg_from_iter(skb->sk, skb, &msg->msg_iter, len);
> +	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len);
>   }
>   
>   int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 7bac9fc1cee0..3c11ef18a9cf 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -14,6 +14,8 @@ struct file;
>   struct pid;
>   struct cred;
>   struct socket;
> +struct sock;
> +struct sk_buff;
>   
>   #define __sockaddr_check_size(size)	\
>   	BUILD_BUG_ON(((size) > sizeof(struct __kernel_sockaddr_storage)))
> @@ -70,6 +72,8 @@ struct msghdr {
>   	__kernel_size_t	msg_controllen;	/* ancillary data buffer length */
>   	struct kiocb	*msg_iocb;	/* ptr to iocb for async requests */
>   	struct ubuf_info *msg_ubuf;
> +	int (*sg_from_iter)(struct sock *sk, struct sk_buff *skb,
> +			    struct iov_iter *from, size_t length);
>   };
>   
>   struct user_msghdr {
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index 50f4faeea76c..b3c05efd659f 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -613,10 +613,16 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
>   }
>   EXPORT_SYMBOL(skb_copy_datagram_from_iter);
>   
> -int __zerocopy_sg_from_iter(struct sock *sk, struct sk_buff *skb,
> -			    struct iov_iter *from, size_t length)
> +int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
> +			    struct sk_buff *skb, struct iov_iter *from,
> +			    size_t length)
>   {
> -	int frag = skb_shinfo(skb)->nr_frags;
> +	int frag;
> +
> +	if (msg && msg->sg_from_iter && msg->msg_ubuf == skb_zcopy(skb))

I'm killing "msg->msg_ubuf == skb_zcopy(skb)", which I added with an
intention to make it less fragile, but it disables the optimisation for
TCP because skb_zerocopy_iter_stream() assigns ubuf to the skb only after
calling __zerocopy_sg_from_iter().



> +		return msg->sg_from_iter(sk, skb, from, length);
> +
> +	frag = skb_shinfo(skb)->nr_frags;
>   
>   	while (length && iov_iter_count(from)) {
>   		struct page *pages[MAX_SKB_FRAGS];
> @@ -702,7 +708,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
>   	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
>   		return -EFAULT;
>   
> -	return __zerocopy_sg_from_iter(NULL, skb, from, ~0U);
> +	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U);
>   }
>   EXPORT_SYMBOL(zerocopy_sg_from_iter);
>   
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index fc22b3d32052..f5a3ebbc1f7e 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -1358,7 +1358,7 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
>   	if (orig_uarg && uarg != orig_uarg)
>   		return -EEXIST;
>   
> -	err = __zerocopy_sg_from_iter(sk, skb, &msg->msg_iter, len);
> +	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len);
>   	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
>   		struct sock *save_sk = skb->sk;
>   

-- 
Pavel Begunkov
