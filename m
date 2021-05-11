Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A56379F37
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 07:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEKFfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 01:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbhEKFfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 01:35:46 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF821C061574;
        Mon, 10 May 2021 22:34:39 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n40so1285770ioz.4;
        Mon, 10 May 2021 22:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=uQWk7HphOi8JaZQ9rKhZ3FNjobByMHuBC/zeBOelz30=;
        b=iTtErxT+5SBiDTAGyl+fRso5STMEz25OBWQjCGMUFFWEEfzsJxmBgEbhWX06vK27M7
         ZBWM204QBg00GAfDUBOc2gbMlBOiqEXU2pBpcN71pjn4+nGYD6hAnvaX8zgFRElpz5rQ
         7/sK1uIM+NvERYPB118KVUGoZupHleA06jfkkys75Rn/gjexceTqGwHb13i/nBaV4qte
         vRsxWS2rnnSiP9zXlhXxdhud/7gttfD4X/DTPVQSYiMUWXnaD5rCJfIul0MwiTz4Bqpu
         hXzx7SWYDCKnvH0XG8XTjiKapQ0It4JdiVfZ82DflUdXozYZxN2a2f/nGleIvTYAzGB7
         qvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=uQWk7HphOi8JaZQ9rKhZ3FNjobByMHuBC/zeBOelz30=;
        b=TcNN2vkZ2Kejvc9YrLB8/ALEu1MOJgJB8A40/7OJphmh5rz3pOBxDIzGN/LqqZutPL
         +n79FRGdlpwkYgBbv5Emvo3pbFnCcZ6rJ4GYG3IrRLtQGFqa6EGVr4lo0gOsHGSP76pm
         EVa/8ZFwxroanvIaSWG0/Bm3RlbMkZIdFEuAwWpkRhahQiv2K7u1gkgvpblC7A5m2TzE
         ImVBJmbHx1QAPOvt5dFtTrx0GcrtQAuJKiMBKiAFCgfc29JvTy//a+sMq/wD/wrCVszd
         EIUJunbUU9SzaJVM+5STmUrvuamZFRfjBGrijWDkKUeibD28+/42cI9sN5eGsx0wahp1
         Ml5Q==
X-Gm-Message-State: AOAM530BPThXICC+Sb/2vTScoZJuo5timRuvkZuTbK3R6KyhjmPyXzL+
        dicaoNLlallQu3eFVw1zAcY=
X-Google-Smtp-Source: ABdhPJz9V2soDps2wgveW5Yz++nuERQ8ApaaxGTW26K6zULD9kvJ2Sf3HG0X1Oy401CpvGadrMfG9g==
X-Received: by 2002:a5e:8a08:: with SMTP id d8mr21349962iok.192.1620711279251;
        Mon, 10 May 2021 22:34:39 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x13sm9084654ilq.85.2021.05.10.22.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 22:34:38 -0700 (PDT)
Date:   Mon, 10 May 2021 22:34:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <609a1765cf6d7_876892080@john-XPS-13-9370.notmuch>
In-Reply-To: <20210426025001.7899-3-xiyou.wangcong@gmail.com>
References: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
 <20210426025001.7899-3-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 02/10] af_unix: implement ->read_sock() for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
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

Here we should check copied and break if copied is >0. Sure the caller here
has desc.count = 1 but its still fairly fragile.

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
> -- 
> 2.25.1
> 


