Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD5374713
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhEERnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238940AbhEERlB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:41:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7787C06125F
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 10:14:09 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z6so2665909wrm.4
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=1lz9G0fat8v7fxuPl5XJxBj6PYvQw7R7TVkQuwMcYKk=;
        b=O1oYab4uSWeF+UBj62kKyA/0KHUMMO0pprTdGMTBXnB/Y8JRCZPV4O9SDfvygljUjs
         NrEEHgz2a/83/FFPL9A73YbErzKityvYYmMQVaPndFiuQaUlKaQlu2pCPc0THfI+J3Ko
         h4Kn+U2hjn8m2xXWg1Q4O9VdkAdT7/MwYRlRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=1lz9G0fat8v7fxuPl5XJxBj6PYvQw7R7TVkQuwMcYKk=;
        b=cvlFVcOPebJKRn1at+5Dth1Gwbj647uKLKkKW/Vex4HYZc/sYqmMnqyzYsnNhyGaxh
         jvOxoVsqgDEtUNgenktrRzPRYgewf4wz49Bm1+qdk5gPLrTSNQpDa/mvhtTIQCsAFAtv
         5XwBWuZlhV6PIpXYC0DXhnQQGQpPe0JP96hSvM32ZgvunStJQq+aX9Zr6wq+f2GWmw2R
         NeboiFCh86rCvvgFOyZWFmnz5fDEi87RP8Lh+lUNjVdgVEsj2vbfep8nCoIpWF6aA8tO
         4AsJIBeuxMntFmr6kwtxb6oYTL5sHybAvrTRQ4i2FgwETEGG0Ss4wDdlf6YDidItWD56
         H2jw==
X-Gm-Message-State: AOAM533vuPDRHiFpqEiYrWQeJdcFWpWu3MQwIt/V6zLLOay1nujKv9CF
        DbwrkJtuiKs37e53TDr5ol3zVQ==
X-Google-Smtp-Source: ABdhPJwGyyhGwULxQhCFpC+UDgsTbWEgaJuojBmfGu1ve7YoZyxqzOG3wmWB8puqHuy8WXOautFHSg==
X-Received: by 2002:a5d:4e0b:: with SMTP id p11mr105069wrt.220.1620234848397;
        Wed, 05 May 2021 10:14:08 -0700 (PDT)
Received: from cloudflare.com (83.31.64.64.ipv4.supernova.orange.pl. [83.31.64.64])
        by smtp.gmail.com with ESMTPSA id m16sm10482036wru.68.2021.05.05.10.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:14:07 -0700 (PDT)
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-3-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        jiang.wang@bytedance.com, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for
 sockmap
In-reply-to: <20210426025001.7899-3-xiyou.wangcong@gmail.com>
Date:   Wed, 05 May 2021 19:14:06 +0200
Message-ID: <87pmy5umqp.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 04:49 AM CEST, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> Implement ->read_sock() for AF_UNIX datagram socket, it is
> pretty much similar to udp_read_sock().
>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/unix/af_unix.c | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 5a31307ceb76..f4dc22db371d 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -661,6 +661,8 @@ static ssize_t unix_stream_splice_read(struct socket *,  loff_t *ppos,
>  				       unsigned int flags);
>  static int unix_dgram_sendmsg(struct socket *, struct msghdr *, size_t);
>  static int unix_dgram_recvmsg(struct socket *, struct msghdr *, size_t, int);
> +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> +			  sk_read_actor_t recv_actor);
>  static int unix_dgram_connect(struct socket *, struct sockaddr *,
>  			      int, int);
>  static int unix_seqpacket_sendmsg(struct socket *, struct msghdr *, size_t);
> @@ -738,6 +740,7 @@ static const struct proto_ops unix_dgram_ops = {
>  	.listen =	sock_no_listen,
>  	.shutdown =	unix_shutdown,
>  	.sendmsg =	unix_dgram_sendmsg,
> +	.read_sock =	unix_read_sock,
>  	.recvmsg =	unix_dgram_recvmsg,
>  	.mmap =		sock_no_mmap,
>  	.sendpage =	sock_no_sendpage,
> @@ -2183,6 +2186,41 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg,
>  	return err;
>  }
>
> +static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
> +			  sk_read_actor_t recv_actor)
> +{
> +	int copied = 0;
> +
> +	while (1) {
> +		struct unix_sock *u = unix_sk(sk);
> +		struct sk_buff *skb;
> +		int used, err;
> +
> +		mutex_lock(&u->iolock);
> +		skb = skb_recv_datagram(sk, 0, 1, &err);
> +		if (!skb) {
> +			mutex_unlock(&u->iolock);
> +			return err;
> +		}
> +
> +		used = recv_actor(desc, skb, 0, skb->len);
> +		if (used <= 0) {
> +			if (!copied)
> +				copied = used;
> +			mutex_unlock(&u->iolock);
> +			break;
> +		} else if (used <= skb->len) {
> +			copied += used;
> +		}
> +		mutex_unlock(&u->iolock);

Do we need hold the mutex for recv_actor to process the skb?

> +
> +		if (!desc->count)
> +			break;
> +	}
> +
> +	return copied;
> +}
> +
>  /*
>   *	Sleep until more data has arrived. But check for races..
>   */
