Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8AE63B142
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbiK1S0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbiK1S0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:26:17 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF3052A722;
        Mon, 28 Nov 2022 10:18:37 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id q1so10655367pgl.11;
        Mon, 28 Nov 2022 10:18:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jl9LwyzvZGZ+R8ZUT6uj3txcdq+TRbDdiFqFW3GqqXs=;
        b=DRQhAljFH7gaI7GHMcW092eFfDr099fwQ42CbREAtfmOskpRzjuBYvGT5cz2wCb+3Q
         xgjKPZJqwhD2EjUraea10Sn3RR//okjrTmuO6/ozeCQih6N1RhC/GkIr2hn+maOYU/LX
         BErTSL38j9/N668vm2mL0QdIMsZibv6cLVV98m4TvrgvWNKw7jsmSh+lKBKGB04zrqU7
         /9HizJq3Z6e+QCN99Vd173Xdpm0dq/hI77XkGsMg7gdtgSMV9AT7pZoOfgN2t8ilhbeX
         h6Ui8RAiyJpsgGG3+/dT1Z2eduBhWOy79OiRXNikmemVJge0WRuD0PwG07aacCZ+yt8p
         AF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jl9LwyzvZGZ+R8ZUT6uj3txcdq+TRbDdiFqFW3GqqXs=;
        b=jwGYboa0wkLQqYsKoWgZjUS+1HSqI04LqBsriBgEaXI4kEfIGegKxwaEhroQGJ3gzU
         mx8+DrsKOAmj9B87zZCzVJ5isTIxgKhE2YkvW2hxBrL3I3S8nuGdEOAojtXf2ldxq33v
         EGszm6Klcx+OzxkDO8Je+5iWiFmMZTDdD6pUUqmOZFOOkmR+KcsM2t8E47xgFNthZZRn
         fd56eXdcnTZiFa1A0Iv5xZgULnpuJJnXBfEKuL9mvWCNVDDVEyNIcKxLe2M8N+XaJ2ht
         Ov2nD/OQKUClGzcyrZLtcN7naXwY9+7poYs8NsUtDQPCvlx74yVCwKQtFXoZINPDZ/uX
         l2Vw==
X-Gm-Message-State: ANoB5pkzAZQ4zW0j67Bdg7dBq4bj8ebaWlwinH+UsBwam8uqrqdmjFvz
        sPxzrd10mU5cx7v19qwYibzzMQSa2bk=
X-Google-Smtp-Source: AA0mqf65GLsr7aElacw+Ek+fcYL8sVgCAt5lX9pGnAKQ65xdyTGCopW6DvDftmzjwjlY/ayNFhjthA==
X-Received: by 2002:a63:d556:0:b0:46b:158f:6265 with SMTP id v22-20020a63d556000000b0046b158f6265mr28357549pgi.193.1669659517079;
        Mon, 28 Nov 2022 10:18:37 -0800 (PST)
Received: from localhost ([2605:59c8:6f:2810:7d97:f259:85c:a462])
        by smtp.gmail.com with ESMTPSA id i15-20020a62870f000000b005754f96f89fsm1543443pfe.76.2022.11.28.10.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 10:18:36 -0800 (PST)
Date:   Mon, 28 Nov 2022 10:18:33 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Pengcheng Yang <yangpc@wangsu.com>
Cc:     'John Fastabend' <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, 'Daniel Borkmann' <daniel@iogearbox.net>,
        'Lorenz Bauer' <lmb@cloudflare.com>
Message-ID: <6384fb79f28f0_59da0208e7@john.notmuch>
In-Reply-To: <87cz97cnz8.fsf@cloudflare.com>
References: <1669082309-2546-1-git-send-email-yangpc@wangsu.com>
 <1669082309-2546-3-git-send-email-yangpc@wangsu.com>
 <637d8d5bd4e27_2b649208eb@john.notmuch>
 <000001d8ff01$053529d0$0f9f7d70$@wangsu.com>
 <87cz97cnz8.fsf@cloudflare.com>
Subject: Re: [PATCH RESEND bpf 2/4] bpf, sockmap: Fix missing BPF_F_INGRESS
 flag when using apply_bytes
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Wed, Nov 23, 2022 at 02:01 PM +08, Pengcheng Yang wrote:
> > John Fastabend <john.fastabend@gmail.com> wrote:
> >> 
> >> Pengcheng Yang wrote:
> >> > When redirecting, we use sk_msg_to_ingress() to get the BPF_F_INGRESS
> >> > flag from the msg->flags. If apply_bytes is used and it is larger than
> >> > the current data being processed, sk_psock_msg_verdict() will not be
> >> > called when sendmsg() is called again. At this time, the msg->flags is 0,
> >> > and we lost the BPF_F_INGRESS flag.
> >> >
> >> > So we need to save the BPF_F_INGRESS flag in sk_psock and assign it to
> >> > msg->flags before redirection.
> >> >
> >> > Fixes: 8934ce2fd081 ("bpf: sockmap redirect ingress support")
> >> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> >> > ---
> >> >  include/linux/skmsg.h | 1 +
> >> >  net/core/skmsg.c      | 1 +
> >> >  net/ipv4/tcp_bpf.c    | 1 +
> >> >  net/tls/tls_sw.c      | 1 +
> >> >  4 files changed, 4 insertions(+)
> >> >
> >> > diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> >> > index 48f4b64..e1d463f 100644
> >> > --- a/include/linux/skmsg.h
> >> > +++ b/include/linux/skmsg.h
> >> > @@ -82,6 +82,7 @@ struct sk_psock {
> >> >  	u32				apply_bytes;
> >> >  	u32				cork_bytes;
> >> >  	u32				eval;
> >> > +	u32				flags;
> >> >  	struct sk_msg			*cork;
> >> >  	struct sk_psock_progs		progs;
> >> >  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> >> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> >> > index 188f855..ab2f8f3 100644
> >> > --- a/net/core/skmsg.c
> >> > +++ b/net/core/skmsg.c
> >> > @@ -888,6 +888,7 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
> >> >  		if (psock->sk_redir)
> >> >  			sock_put(psock->sk_redir);
> >> >  		psock->sk_redir = msg->sk_redir;
> >> > +		psock->flags = msg->flags;
> >> >  		if (!psock->sk_redir) {
> >> >  			ret = __SK_DROP;
> >> >  			goto out;
> >> > diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> >> > index ef5de4f..1390d72 100644
> >> > --- a/net/ipv4/tcp_bpf.c
> >> > +++ b/net/ipv4/tcp_bpf.c
> >> > @@ -323,6 +323,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
> >> >  		break;
> >> >  	case __SK_REDIRECT:
> >> >  		sk_redir = psock->sk_redir;
> >> > +		msg->flags = psock->flags;
> >> >  		sk_msg_apply_bytes(psock, tosend);
> >> >  		if (!psock->apply_bytes) {
> >> >  			/* Clean up before releasing the sock lock. */
> >>                  ^^^^^^^^^^^^^^^
> >> In this block reposted here with the rest of the block
> >> 
> >> 
> >> 		if (!psock->apply_bytes) {
> >> 			/* Clean up before releasing the sock lock. */
> >> 			eval = psock->eval;
> >> 			psock->eval = __SK_NONE;
> >> 			psock->sk_redir = NULL;
> >> 		}
> >> 
> >> Now that we have a psock->flags we should clera that as
> >> well right?
> >
> > According to my understanding, it is not necessary (but can) to clear
> > psock->flags here, because psock->flags will be overwritten by msg->flags
> > at the beginning of each redirection (in sk_psock_msg_verdict()).
> 
> 1. We should at least document that psock->flags value can be garbage
>    (undefined) if psock->sk_redir is null.

Per v2 I think we should not have garbage flags. Just zero the flags
field no point in saving a single insn here IMO.

> 
> 2. 'flags' is amiguous (flags for what?). I'd suggest to rename to
>    something like redir_flags.
> 
>    Also, since we don't care about all flags, but just the ingress bit,
>    we should store just that. It's not about size. Less state passed
>    around is easier to reason about. See patch below.

rename makes sense to me.

> 
> 3. Alternatively, I'd turn psock->sk_redir into a tagged pointer, like
>    skb->_sk_redir is. This way all state (pointer & flags) is bundled
>    and managed together. It would be a bigger change. Would have to be
>    split out from this patch set.
> 
> --8<--
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 70d6cb94e580..84f787416a54 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -82,6 +82,7 @@ struct sk_psock {
>  	u32				apply_bytes;
>  	u32				cork_bytes;
>  	u32				eval;
> +	bool				redir_ingress; /* undefined if sk_redir is null */
>  	struct sk_msg			*cork;
>  	struct sk_psock_progs		progs;
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 14d45661a84d..5b70b241ce71 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -2291,8 +2291,8 @@ int tcp_bpf_update_proto(struct sock *sk, struct sk_psock *psock, bool restore);
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk);
>  #endif /* CONFIG_BPF_SYSCALL */
>  
> -int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg, u32 bytes,
> -			  int flags);
> +int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> +			  struct sk_msg *msg, u32 bytes, int flags);
>  #endif /* CONFIG_NET_SOCK_MSG */
>  
>  #if !defined(CONFIG_BPF_SYSCALL) || !defined(CONFIG_NET_SOCK_MSG)
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index e6b9ced3eda8..53d0251788aa 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -886,13 +886,16 @@ int sk_psock_msg_verdict(struct sock *sk, struct sk_psock *psock,
>  	ret = sk_psock_map_verd(ret, msg->sk_redir);
>  	psock->apply_bytes = msg->apply_bytes;
>  	if (ret == __SK_REDIRECT) {
> -		if (psock->sk_redir)
> +		if (psock->sk_redir) {
>  			sock_put(psock->sk_redir);
> -		psock->sk_redir = msg->sk_redir;
> -		if (!psock->sk_redir) {
> +			psock->sk_redir = NULL;
> +		}
> +		if (!msg->sk_redir) {
>  			ret = __SK_DROP;
>  			goto out;
>  		}
> +		psock->redir_ingress = sk_msg_to_ingress(msg);
> +		psock->sk_redir = msg->sk_redir;
>  		sock_hold(psock->sk_redir);
>  	}
>  out:
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index cf9c3e8f7ccb..490b359dc814 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -131,10 +131,9 @@ static int tcp_bpf_push_locked(struct sock *sk, struct sk_msg *msg,
>  	return ret;
>  }
>  
> -int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
> -			  u32 bytes, int flags)
> +int tcp_bpf_sendmsg_redir(struct sock *sk, bool ingress,
> +			  struct sk_msg *msg, u32 bytes, int flags)
>  {
> -	bool ingress = sk_msg_to_ingress(msg);
>  	struct sk_psock *psock = sk_psock_get(sk);
>  	int ret;
>  
> @@ -337,7 +336,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>  		release_sock(sk);
>  
>  		origsize = msg->sg.size;
> -		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
> +		ret = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
> +					    msg, tosend, flags);
>  		sent = origsize - msg->sg.size;
>  
>  		if (eval == __SK_REDIRECT)
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 264cf367e265..b22d97610b9a 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -846,7 +846,8 @@ static int bpf_exec_tx_verdict(struct sk_msg *msg, struct sock *sk,
>  		sk_msg_return_zero(sk, msg, send);
>  		msg->sg.size -= send;
>  		release_sock(sk);
> -		err = tcp_bpf_sendmsg_redir(sk_redir, &msg_redir, send, flags);
> +		err = tcp_bpf_sendmsg_redir(sk_redir, psock->redir_ingress,
> +					    &msg_redir, send, flags);
>  		lock_sock(sk);
>  		if (err < 0) {
>  			*copied -= sk_msg_free_nocharge(sk, &msg_redir);


