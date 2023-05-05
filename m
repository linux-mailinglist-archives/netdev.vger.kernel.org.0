Return-Path: <netdev+bounces-565-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF456F8322
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 14:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6FF71C218D5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:40:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8019B79FC;
	Fri,  5 May 2023 12:39:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E8156CD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:39:51 +0000 (UTC)
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51021CFD9
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 05:39:49 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-94a34a14a54so334358666b.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 05:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1683290388; x=1685882388;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=F/JdDhiv34w+Wck7q3/xIhZSxhvoEqSEFRkvAcvQ/Po=;
        b=yKVO2FTCC1RN1QdH3pfIOGEu21WaItYK5sMbKKDzINEA6nJJhhWEYSARfgkM/NaFxn
         MO91KBrnSBnQPv47lWLov+oV8d99L9mKw9o/ZHchcpLyPPYh9pJ8vIJozccxAf3UZZwQ
         rWi0sQRmLBLip1G06RceQo/wZDiZo19k/4Kl0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683290388; x=1685882388;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/JdDhiv34w+Wck7q3/xIhZSxhvoEqSEFRkvAcvQ/Po=;
        b=X/qxuVqNFi3aJK5bM1JmFdQqEPi1A8j+vwWMxbEAs/Z6joDAS/o7zeWKgKMjTPW3U2
         rf/IJkXUnuaun3scfPa0ra3KBZ0QXwSecl7ngr2p4bPo++W9cM1UjPYKW/XBU1hl2ocX
         RGGj8DXBCVCfwqYP+z1ZWe4k/4AbjVDqVeD4pUFHwQ5V/5mfXrOaEwEUX9x8SO1W/NiQ
         5BbvOdJnVqDBm+OhfKuNLzgLesoZ/n6pgfYnsCCYk9CpgZBB+F4rATORH0aXLCHFkCU8
         E6dAz3s7UwmQlsudzsj8/k+YuVgZAVpBJXb5HDwdSZxfgJYLoYxF3Q0bMl4Bdrx0nJXe
         3ykQ==
X-Gm-Message-State: AC+VfDwsf/msHfm7uLWPb4kC1ZO0Kq97bKlSd8YQLI0pwtN9xepUQb78
	TXMKnFbUVzRglqMops6FZaUqSg==
X-Google-Smtp-Source: ACHHUZ4EMmK+sWMZIPI6mvu3MouTljTrM94efrXc0ilcY7Zaz19SfMhs5sghyjbcew/Cn5ZyLSCvlA==
X-Received: by 2002:a17:906:4fce:b0:965:a414:7cd6 with SMTP id i14-20020a1709064fce00b00965a4147cd6mr1195885ejw.17.1683290388362;
        Fri, 05 May 2023 05:39:48 -0700 (PDT)
Received: from cloudflare.com (79.184.132.119.ipv4.supernova.orange.pl. [79.184.132.119])
        by smtp.gmail.com with ESMTPSA id k19-20020a170906129300b0094e954fd015sm902426ejb.175.2023.05.05.05.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 05:39:47 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-9-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 08/13] bpf: sockmap, incorrectly handling copied_seq
Date: Fri, 05 May 2023 14:14:12 +0200
In-reply-to: <20230502155159.305437-9-john.fastabend@gmail.com>
Message-ID: <87zg6jvtnx.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> The read_skb() logic is incrementing the tcp->copied_seq which is used for
> among other things calculating how many outstanding bytes can be read by
> the application. This results in application errors, if the application
> does an ioctl(FIONREAD) we return zero because this is calculated from
> the copied_seq value.
>
> To fix this we move tcp->copied_seq accounting into the recv handler so
> that we update these when the recvmsg() hook is called and data is in
> fact copied into user buffers. This gives an accurate FIONREAD value
> as expected and improves ACK handling. Before we were calling the
> tcp_rcv_space_adjust() which would update 'number of bytes copied to
> user in last RTT' which is wrong for programs returning SK_PASS. The
> bytes are only copied to the user when recvmsg is handled.
>
> Doing the fix for recvmsg is straightforward, but fixing redirect and
> SK_DROP pkts is a bit tricker. Build a tcp_psock_eat() helper and then
> call this from skmsg handlers. This fixes another issue where a broken
> socket with a BPF program doing a resubmit could hang the receiver. This
> happened because although read_skb() consumed the skb through sock_drop()
> it did not update the copied_seq. Now if a single reccv socket is
> redirecting to many sockets (for example for lb) the receiver sk will be
> hung even though we might expect it to continue. The hang comes from
> not updating the copied_seq numbers and memory pressure resulting from
> that.
>
> We have a slight layer problem of calling tcp_eat_skb even if its not
> a TCP socket. To fix we could refactor and create per type receiver
> handlers. I decided this is more work than we want in the fix and we
> already have some small tweaks depending on caller that use the
> helper skb_bpf_strparser(). So we extend that a bit and always set
> the strparser bit when it is in use and then we can gate the
> seq_copied updates on this.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/net/tcp.h  | 10 ++++++++++
>  net/core/skmsg.c   |  7 +++++--
>  net/ipv4/tcp.c     | 10 +---------
>  net/ipv4/tcp_bpf.c | 28 +++++++++++++++++++++++++++-
>  4 files changed, 43 insertions(+), 12 deletions(-)
>
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index db9f828e9d1e..76bf0a11bdc7 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -1467,6 +1467,8 @@ static inline void tcp_adjust_rcv_ssthresh(struct sock *sk)
>  }
>  
>  void tcp_cleanup_rbuf(struct sock *sk, int copied);
> +void __tcp_cleanup_rbuf(struct sock *sk, int copied);
> +
>  
>  /* We provision sk_rcvbuf around 200% of sk_rcvlowat.
>   * If 87.5 % (7/8) of the space has been consumed, we want to override
> @@ -2323,6 +2325,14 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
>  #endif /* CONFIG_BPF_SYSCALL */
>  
> +#ifdef CONFIG_INET
> +void tcp_eat_skb(struct sock *sk, struct sk_buff *skb);
> +#else
> +static inline void tcp_eat_skb(struct sock *sk, struct sk_buff *skb)
> +{
> +}
> +#endif
> +
>  int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
>  			  struct sk_msg *msg, u32 bytes, int flags);
>  #endif /* CONFIG_NET_SOCK_MSG */
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 3c0663f5cc3e..18c4f4015559 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -1017,11 +1017,14 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
>  		}
>  		break;
>  	case __SK_REDIRECT:
> +		tcp_eat_skb(psock->sk, skb);
>  		err = sk_psock_skb_redirect(psock, skb);
>  		break;
>  	case __SK_DROP:
>  	default:
>  out_free:
> +		tcp_eat_skb(psock->sk, skb);
> +		skb_bpf_redirect_clear(skb);
>  		sock_drop(psock->sk, skb);
>  	}
>  

I have a feeling you wanted to factor out the common
skb_bpf_redirect_clear() into out_free: block, but maybe forgot to
update the jump sites?

[...]

