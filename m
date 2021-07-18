Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8E33CCA28
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 19:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhGRRwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 13:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGRRwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 13:52:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9762C061762;
        Sun, 18 Jul 2021 10:49:38 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id m2so18811284wrq.2;
        Sun, 18 Jul 2021 10:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BEhWtFLnLqQZHRzYwBcEqayGanVCaoPpdKEQEbL7vlw=;
        b=C7PSXlWSVUZz/H0ZN0JJ3JD6m2kSg4VZ3Y7SZ14tP/++GDWFXsWsO2puhWvg14q/XA
         iBcU/kHBqDYPEw+6fj7ipgM5PRp8AcQBd44hw2J6+nf86Ja5kh86Jk18t6IaEqJVstWs
         NTxLDxU63V5l80XoG/Xq0Vc5C1jFYbZeNrd1cZA8fez9+TeoirXkOE0ONPrZnH79O9hs
         JNs3aPjeFJsAXHgPktxBec2a6qg9Jpd0OMic97aRlix1NtEZ4PSpzDjM3/bZc3HO2lrg
         glsJvm8QqGNnPXl80Y2TNM+TvmiJXFNA4HYmjy0UM7vufu4AOIF2qQ0/yxvPmNAGXWt3
         On/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BEhWtFLnLqQZHRzYwBcEqayGanVCaoPpdKEQEbL7vlw=;
        b=WVMCppiX4R13t404SehWf9ynfnrCg2/HdXTOSKhSYpsUILEJgirUvUuQbAauq8QFRc
         OetHtwdfrTXcK96QSaB4ZU/ynyO9CRo7pU3B/JZVwkWrfBlGxNLwb4m6nbAtdfHfDml5
         zQyapJzHK1LlAL4hvIUK0yUv5laNSmdFOATts/DJxwGTMfAmE4zr09I6IS1oMkutHCuo
         vBDNWu2Oo2Tq8FfQI6XGQ13taQTP0UU0DqWh38bkDSFI7gMHemFQij6nfeR8kS5qC7D1
         qWobWsCGDAsUtvB2R73NnrAGmVCElcTEkXOSRRPqOb82k8mcKA8bJfo6qmgdNFMXJNsY
         Qz+w==
X-Gm-Message-State: AOAM533vLgmAITiEjazzBPkeS3m3sJ4HEVMoMjDhU8/l03UrWKsavL22
        Y1le5zW/f2d/Xo+crUE9zUs=
X-Google-Smtp-Source: ABdhPJxsnPcNqdGui/Gej71ZtmTqm68wZmisMrokPTVdmiZBXESCi2nHTLpPlJ8VciGvx2XH4KcJqg==
X-Received: by 2002:adf:fe0d:: with SMTP id n13mr25059202wrr.73.1626630577153;
        Sun, 18 Jul 2021 10:49:37 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.22.19])
        by smtp.gmail.com with ESMTPSA id e15sm17059080wrp.29.2021.07.18.10.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 10:49:36 -0700 (PDT)
Subject: Re: [PATCH bpf-next v5 07/11] af_unix: implement
 unix_dgram_bpf_recvmsg()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com>
 <20210704190252.11866-8-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a76f89b3-0911-e1f1-d1c1-707b9bc5478a@gmail.com>
Date:   Sun, 18 Jul 2021 19:49:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210704190252.11866-8-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/21 9:02 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> We have to implement unix_dgram_bpf_recvmsg() to replace the
> original ->recvmsg() to retrieve skmsg from ingress_msg.
> 
> AF_UNIX is again special here because the lack of
> sk_prot->recvmsg(). I simply add a special case inside
> unix_dgram_recvmsg() to call sk->sk_prot->recvmsg() directly.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/af_unix.h |  2 ++
>  net/unix/af_unix.c    | 19 +++++++++--
>  net/unix/unix_bpf.c   | 75 +++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 93 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/af_unix.h b/include/net/af_unix.h
> index cca645846af1..435a2c3d5a6f 100644
> --- a/include/net/af_unix.h
> +++ b/include/net/af_unix.h
> @@ -82,6 +82,8 @@ static inline struct unix_sock *unix_sk(const struct sock *sk)
>  long unix_inq_len(struct sock *sk);
>  long unix_outq_len(struct sock *sk);
>  
> +int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> +			 int flags);
>  #ifdef CONFIG_SYSCTL
>  int unix_sysctl_register(struct net *net);
>  void unix_sysctl_unregister(struct net *net);
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 573253c5b5c2..89927678c0dc 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2098,11 +2098,11 @@ static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
>  	}
>  }
>  
> -static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
> -			      size_t size, int flags)
> +int __unix_dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t size,
> +			 int flags)
>  {
>  	struct scm_cookie scm;
> -	struct sock *sk = sock->sk;
> +	struct socket *sock = sk->sk_socket;
>  	struct unix_sock *u = unix_sk(sk);
>  	struct sk_buff *skb, *last;
>  	long timeo;
> @@ -2205,6 +2205,19 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  	return err;
>  }
>  
> +static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
> +			      int flags)
> +{
> +	struct sock *sk = sock->sk;
> +
> +#ifdef CONFIG_BPF_SYSCALL
> +	if (sk->sk_prot != &unix_proto)
> +		return sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
> +					    flags & ~MSG_DONTWAIT, NULL);
> +#endif
> +	return __unix_dgram_recvmsg(sk, msg, size, flags);
> +}
> +
>  static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
>  			  sk_read_actor_t recv_actor)
>  {
> diff --git a/net/unix/unix_bpf.c b/net/unix/unix_bpf.c
> index b1582a659427..db0cda29fb2f 100644
> --- a/net/unix/unix_bpf.c
> +++ b/net/unix/unix_bpf.c
> @@ -6,6 +6,80 @@
>  #include <net/sock.h>
>  #include <net/af_unix.h>
>  
> +#define unix_sk_has_data(__sk, __psock)					\
> +		({	!skb_queue_empty(&__sk->sk_receive_queue) ||	\
> +			!skb_queue_empty(&__psock->ingress_skb) ||	\
> +			!list_empty(&__psock->ingress_msg);		\
> +		})
> +
> +static int unix_msg_wait_data(struct sock *sk, struct sk_psock *psock,
> +			      long timeo)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	struct unix_sock *u = unix_sk(sk);
> +	int ret = 0;
> +
> +	if (sk->sk_shutdown & RCV_SHUTDOWN)
> +		return 1;
> +
> +	if (!timeo)
> +		return ret;
> +
> +	add_wait_queue(sk_sleep(sk), &wait);
> +	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
> +	if (!unix_sk_has_data(sk, psock)) {
> +		mutex_unlock(&u->iolock);
> +		wait_woken(&wait, TASK_INTERRUPTIBLE, timeo);
> +		mutex_lock(&u->iolock);
> +		ret = unix_sk_has_data(sk, psock);
> +	}
> +	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
> +	remove_wait_queue(sk_sleep(sk), &wait);
> +	return ret;
> +}
> +
> +static int unix_dgram_bpf_recvmsg(struct sock *sk, struct msghdr *msg,
> +				  size_t len, int nonblock, int flags,
> +				  int *addr_len)
> +{
> +	struct unix_sock *u = unix_sk(sk);
> +	struct sk_psock *psock;
> +	int copied, ret;
> +
> +	psock = sk_psock_get(sk);
> +	if (unlikely(!psock))
> +		return __unix_dgram_recvmsg(sk, msg, len, flags);
> +
> +	mutex_lock(&u->iolock);

u->iolock mutex is owned here.

> +	if (!skb_queue_empty(&sk->sk_receive_queue) &&
> +	    sk_psock_queue_empty(psock)) {
> +		ret = __unix_dgram_recvmsg(sk, msg, len, flags);

But __unix_dgram_recvmsg() will also try to grab this mutex ?

> +		goto out;
> +	}
> +
> +msg_bytes_ready:
> +	copied = sk_msg_recvmsg(sk, psock, msg, len, flags);
> +	if (!copied) {
> +		long timeo;
> +		int data;
> +
> +		timeo = sock_rcvtimeo(sk, nonblock);
> +		data = unix_msg_wait_data(sk, psock, timeo);
> +		if (data) {
> +			if (!sk_psock_queue_empty(psock))
> +				goto msg_bytes_ready;
> +			ret = __unix_dgram_recvmsg(sk, msg, len, flags);
> +			goto out;
> +		}
> +		copied = -EAGAIN;
> +	}
> +	ret = copied;
> +out:
> +	mutex_unlock(&u->iolock);
> +	sk_psock_put(sk, psock);
> +	return ret;
> +}
> +
>  static struct proto *unix_prot_saved __read_mostly;
>  static DEFINE_SPINLOCK(unix_prot_lock);
>  static struct proto unix_bpf_prot;
> @@ -14,6 +88,7 @@ static void unix_bpf_rebuild_protos(struct proto *prot, const struct proto *base
>  {
>  	*prot        = *base;
>  	prot->close  = sock_map_close;
> +	prot->recvmsg = unix_dgram_bpf_recvmsg;
>  }
>  
>  static void unix_bpf_check_needs_rebuild(struct proto *ops)
> 
