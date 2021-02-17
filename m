Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE39231DF2D
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 19:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhBQSlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 13:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhBQSlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 13:41:13 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAE2C061574;
        Wed, 17 Feb 2021 10:40:33 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w1so12168691ilm.12;
        Wed, 17 Feb 2021 10:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=K3g3DKWQxE+26feOLv3IYgt9bNcU2Di7yBLrODeixrs=;
        b=pUO21YPSyXEyukRbCwVyjKK+ThVu+K0iWK5AADoUUTyc/q9t+0APdidmuUPVXDoQlw
         SzqD9h93Qqq4nnyCmmRuBNvEiFzgAkdFdaGCfmkpfzE0rq0Q4OPxnoxBDop2CeZe2wkX
         +1DaVLGAu/fjhpS+NBQw8gvslPkun3mM1D6Ja2lryTPTHjK8XZhNPt/nwSZIIcVxOwLo
         NfJ3W0OBPDJXWMfmPTnreQcvxgnVeiKkd+q9cgpOnfHcZ1nJY4rP3+CVf10ntVnxZwyj
         tcXyAXGGyTIo3KqzdASu7658lIwxShHLFa1p58Ff1EcwrN60vd4HBJ/JmMHxqcxkKHVK
         6PFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=K3g3DKWQxE+26feOLv3IYgt9bNcU2Di7yBLrODeixrs=;
        b=oI2h91smWrK8Ga3IONZQp4SU+fu4HqeHgMvis088Tq3tjg4V6LGUcHCEtysGsZ+rgZ
         no/zqfAdy/8VcPIA5OcQnx1iZgrk21cu5poMi080uqs6D4xWVS3thJSofNmaoHs8DhIa
         AH61rwBY3OEVrIVtenDntKIXwIsGLpVyvz4v2GT2hroJQTdMo8hlp0GUnwmkjj+sSUts
         cNSqaat/0O/z3J0QLWwRNALl4QGjf/y3ahkwkq2hg8tMiGUBIH5kKPoErZN0hVOYll78
         eWdhP5olmu+wKXeU6hRBnrkjyBo6BWLCeCEF3tGweknFGUPvbnC8GatbYPCUNHg22MHu
         PPNQ==
X-Gm-Message-State: AOAM530QfQDXaYuxzOGY4XZVO9ouy9nOMhFdV6y0fI385dVNwMEaxFMe
        ngDyVtae6Mc7ipQhJ0e/FHw=
X-Google-Smtp-Source: ABdhPJw2x5PN2MTrz0ZbytdS+sfLazYnPrAtgt6LKw6g7+c3tpDxYuwtM+y8ypuYGSdZkoFBw8EFcg==
X-Received: by 2002:a92:cc4d:: with SMTP id t13mr398749ilq.150.1613587233105;
        Wed, 17 Feb 2021 10:40:33 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id i20sm1527019ilc.2.2021.02.17.10.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 10:40:32 -0800 (PST)
Date:   Wed, 17 Feb 2021 10:40:24 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602d631877e40_aed9208bc@john-XPS-13-9370.notmuch>
In-Reply-To: <20210216064250.38331-5-xiyou.wangcong@gmail.com>
References: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
 <20210216064250.38331-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v4 4/5] skmsg: move sk_redir from TCP_SKB_CB to
 skb
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
> Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> does not work for any other non-TCP protocols. We can move them to
> skb ext, but it introduces a memory allocation on fast path.
> 
> Fortunately, we only need to a word-size to store all the information,
> because the flags actually only contains 1 bit so can be just packed
> into the lowest bit of the "pointer", which is stored as unsigned
> long.
> 
> Inside struct sk_buff, '_skb_refdst' can be reused because skb dst is
> no longer needed after ->sk_data_ready() so we can just drop it.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Great, its likely we have more space in sk_buff we can use if needed
as well. queue_mapping, skb_iif, vlan*, fields come to mind. Couple
comments inline, but looks good to me.

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -494,6 +494,8 @@ static int sk_psock_skb_ingress_self(struct sk_psock *psock, struct sk_buff *skb
>  static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  			       u32 off, u32 len, bool ingress)
>  {
> +	skb_bpf_redirect_clear(skb);
> +
>  	if (!ingress) {
>  		if (!sock_writeable(psock->sk))
>  			return -EAGAIN;
> @@ -525,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  		len = skb->len;
>  		off = 0;
>  start:
> -		ingress = tcp_skb_bpf_ingress(skb);
> +		ingress = skb_bpf_ingress(skb);
>  		do {
>  			ret = -EIO;
>  			if (likely(psock->sk->sk_socket))
> @@ -631,7 +633,12 @@ void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
>  
>  static void sk_psock_zap_ingress(struct sk_psock *psock)
>  {
> -	__skb_queue_purge(&psock->ingress_skb);
> +	struct sk_buff *skb;
> +
> +	while ((skb = __skb_dequeue(&psock->ingress_skb)) != NULL) {
> +		skb_bpf_redirect_clear(skb);
> +		kfree_skb(skb);
> +	}
>  	__sk_psock_purge_ingress_msg(psock);
>  }
>  
> @@ -752,7 +759,7 @@ static void sk_psock_skb_redirect(struct sk_buff *skb)
>  	struct sk_psock *psock_other;
>  	struct sock *sk_other;
>  
> -	sk_other = tcp_skb_bpf_redirect_fetch(skb);
> +	sk_other = skb_bpf_redirect_fetch(skb);
>  	/* This error is a buggy BPF program, it returned a redirect
>  	 * return code, but then didn't set a redirect interface.
>  	 */
> @@ -802,9 +809,10 @@ int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
>  		 * TLS context.
>  		 */
>  		skb->sk = psock->sk;
> -		tcp_skb_bpf_redirect_clear(skb);
> +		skb_dst_drop(skb);
> +		skb_bpf_redirect_clear(skb);

Do we really need the skb_dst_drop() I thought we would have already dropped this here
but I've not had time to check yet.

>  		ret = sk_psock_bpf_run(psock, prog, skb);
> -		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>  		skb->sk = NULL;
>  	}
>  	sk_psock_tls_verdict_apply(skb, psock->sk, ret);
> @@ -816,7 +824,6 @@ EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
>  static void sk_psock_verdict_apply(struct sk_psock *psock,
>  				   struct sk_buff *skb, int verdict)
>  {
> -	struct tcp_skb_cb *tcp;
>  	struct sock *sk_other;
>  	int err = -EIO;
>  
> @@ -828,8 +835,7 @@ static void sk_psock_verdict_apply(struct sk_psock *psock,
>  			goto out_free;
>  		}
>  
> -		tcp = TCP_SKB_CB(skb);
> -		tcp->bpf.flags |= BPF_F_INGRESS;
> +		skb_bpf_set_ingress(skb);
>  
>  		/* If the queue is empty then we can submit directly
>  		 * into the msg queue. If its not empty we have to
> @@ -890,9 +896,10 @@ static void sk_psock_strp_read(struct strparser *strp, struct sk_buff *skb)
>  	skb_set_owner_r(skb, sk);
>  	prog = READ_ONCE(psock->progs.skb_verdict);
>  	if (likely(prog)) {
> -		tcp_skb_bpf_redirect_clear(skb);
> +		skb_dst_drop(skb);

Same here.

> +		skb_bpf_redirect_clear(skb);
>  		ret = sk_psock_bpf_run(psock, prog, skb);
> -		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>  	}
>  	sk_psock_verdict_apply(psock, skb, ret);
>  out:
> @@ -1005,9 +1012,10 @@ static int sk_psock_verdict_recv(read_descriptor_t *desc, struct sk_buff *skb,
>  	skb_set_owner_r(skb, sk);
>  	prog = READ_ONCE(psock->progs.skb_verdict);
>  	if (likely(prog)) {
> -		tcp_skb_bpf_redirect_clear(skb);
> +		skb_dst_drop(skb);

And here. 

> +		skb_bpf_redirect_clear(skb);
>  		ret = sk_psock_bpf_run(psock, prog, skb);
> -		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +		ret = sk_psock_map_verd(ret, skb_bpf_redirect_fetch(skb));
>  	}
>  	sk_psock_verdict_apply(psock, skb, ret);

Thanks for doing this.
