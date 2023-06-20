Return-Path: <netdev+bounces-12225-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FAF736D2F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E66961C20B7E
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C93C6156E6;
	Tue, 20 Jun 2023 13:22:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE12E156D3
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:22:46 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9501FDB
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:22:22 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-3f80b192aecso10819475e9.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687267286; x=1689859286;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M0gIgvDtcmYiR+ujZPiaQl78n9DjwDyLMnh3WVrRmj8=;
        b=VX7c8Md5L1IYeHh+NqkcU0nic7CQasvLsqYX7pVvajuxBwE5U+5ueBDHZY1LjLXx8u
         Kp1rw1R3kWvIveubMZcbISatA1scA0i6jiaQ1970LBMaVZaiaiVvwDu+ctOqWNSzYJCF
         25+RizwCSR5rHi6RTsEl2qOqMMvqrgvMs2UW2LJXAMv9Qh/otISUnp7wu0BLUC7aE/J6
         ABGDLBRcruPYO4G/92sVgaGx/iRy+deY/zQteYScaZzg/cL6tI1vC7lj6ce35UvrZwDk
         5f98Xgz186WE+WefPifrjbdDFHijjdk+7KElId7ZiA5nmfqtlKGhMrVXsK9Wzr/2Wcs9
         OwcA==
X-Gm-Message-State: AC+VfDys42zla3GveWCYsliYE/+JMplUNAi4OEwy+SKORNBl4ZP3zsVd
	9YNoXNtv0RFmgtC4xsbCU5A=
X-Google-Smtp-Source: ACHHUZ7zg4z9RjgldGtqe8IpCuU8GFLSgMUFIdBFIlkfgwmzKEOXqIww85lq8+Mo0Ec4dDibVER4JA==
X-Received: by 2002:adf:f7c5:0:b0:30a:f103:1f55 with SMTP id a5-20020adff7c5000000b0030af1031f55mr8724379wrq.0.1687267285850;
        Tue, 20 Jun 2023 06:21:25 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p9-20020adfcc89000000b003113f0ba414sm2006920wrj.65.2023.06.20.06.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:21:25 -0700 (PDT)
Message-ID: <5bbb6ce4-a251-a357-3efc-9e899e470b9c@grimberg.me>
Date: Tue, 20 Jun 2023 16:21:22 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/4] net/tls: implement ->read_sock()
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 Boris Pismenny <boris.pismenny@gmail.com>
References: <20230620102856.56074-1-hare@suse.de>
 <20230620102856.56074-5-hare@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230620102856.56074-5-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> Implement ->read_sock() function for use with nvme-tcp.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Cc: Boris Pismenny <boris.pismenny@gmail.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>   net/tls/tls.h      |  2 ++
>   net/tls/tls_main.c |  2 ++
>   net/tls/tls_sw.c   | 78 ++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 82 insertions(+)
> 
> diff --git a/net/tls/tls.h b/net/tls/tls.h
> index d002c3af1966..ba55cd5c4913 100644
> --- a/net/tls/tls.h
> +++ b/net/tls/tls.h
> @@ -114,6 +114,8 @@ bool tls_sw_sock_is_readable(struct sock *sk);
>   ssize_t tls_sw_splice_read(struct socket *sock, loff_t *ppos,
>   			   struct pipe_inode_info *pipe,
>   			   size_t len, unsigned int flags);
> +int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		     sk_read_actor_t read_actor);
>   
>   int tls_device_sendmsg(struct sock *sk, struct msghdr *msg, size_t size);
>   void tls_device_splice_eof(struct socket *sock);
> diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
> index 7b9c83dd7de2..1a062a8c6d33 100644
> --- a/net/tls/tls_main.c
> +++ b/net/tls/tls_main.c
> @@ -963,10 +963,12 @@ static void build_proto_ops(struct proto_ops ops[TLS_NUM_CONFIG][TLS_NUM_CONFIG]
>   	ops[TLS_BASE][TLS_SW  ] = ops[TLS_BASE][TLS_BASE];
>   	ops[TLS_BASE][TLS_SW  ].splice_read	= tls_sw_splice_read;
>   	ops[TLS_BASE][TLS_SW  ].poll		= tls_sk_poll;
> +	ops[TLS_BASE][TLS_SW  ].read_sock	= tls_sw_read_sock;
>   
>   	ops[TLS_SW  ][TLS_SW  ] = ops[TLS_SW  ][TLS_BASE];
>   	ops[TLS_SW  ][TLS_SW  ].splice_read	= tls_sw_splice_read;
>   	ops[TLS_SW  ][TLS_SW  ].poll		= tls_sk_poll;
> +	ops[TLS_SW  ][TLS_SW  ].read_sock	= tls_sw_read_sock;
>   
>   #ifdef CONFIG_TLS_DEVICE
>   	ops[TLS_HW  ][TLS_BASE] = ops[TLS_BASE][TLS_BASE];
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 97379e34c997..e918c98bbeb2 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -2231,6 +2231,84 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
>   	goto splice_read_end;
>   }
>   
> +int tls_sw_read_sock(struct sock *sk, read_descriptor_t *desc,
> +		     sk_read_actor_t read_actor)
> +{
> +	struct tls_context *tls_ctx = tls_get_ctx(sk);
> +	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
> +	struct strp_msg *rxm = NULL;
> +	struct tls_msg *tlm;
> +	struct sk_buff *skb;
> +	ssize_t copied = 0;
> +	int err, used;
> +
> +	err = tls_rx_reader_lock(sk, ctx, true);
> +	if (err < 0)
> +		return err;

Unlike recvmsg or splice_read, the caller of read_sock is assumed to
have the socket locked, and tls_rx_reader_lock also calls lock_sock,
how is this not a deadlock?

I'm not exactly clear why the lock is needed here or what is the subtle
distinction between tls_rx_reader_lock and what lock_sock provides.

