Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FCF1EA659
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgFAO5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 10:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgFAO5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 10:57:31 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B0FC03E96F
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 07:57:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id q19so4194901eja.7
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 07:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GtVCS7DBg5IZVzTuXW5+e+BS6VDlNJ+w0jwnfdmJFNc=;
        b=lY3UBbOzpbjBvBEzUK5rHRGykpyVJjthCrnOeoVxAC/ueanpx1CXourOABHBXwtwlx
         wsQr06GMoTnr7P6Tqky72hhY5D5xRwMKhDrdHRFldSkI7bw3IvlH29jwR8b74466wRbc
         CRH+i4sBIgGx7dgPntxKjo6fhVKMChRUUis/c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GtVCS7DBg5IZVzTuXW5+e+BS6VDlNJ+w0jwnfdmJFNc=;
        b=E6MkO+77ObXJDfsuK/CpUGTEF9Wb/lkZdlnrWxStxGQO4Lj25IUIQfC+3kEL/Qg+5/
         iO+jn83DhZDiIxeyVfw0dWaY7p5RM1tX8o6z2E2PpqCiLPCTqEWFwxb0Dr1pQRN8nBzH
         ZZjFd5Pt6VLy9OjgclgQp3Qto6VMkWbOKvcazt0+SLrJ8wirKHWVlTePrR9FoQ/7ma5o
         2tdSoLiVLIwT54Ot1BMX8EjoPuFp6fiDykMamMbA4YL6jZlvdOfljBhgLkOcw27Aug46
         JBbR+TCirwNW8QWJaiGbK+cNwvKOUTayUsLDzVSQt8tXEX2zkIVpzuBYeMY6alGY3/qE
         O1rg==
X-Gm-Message-State: AOAM533YtdsHAsRMCSBj067J9gZaRNjzSSxbaIO5FGHZdcDbaDBOUuxm
        mMdMe/OPmr+l+bvaw/1xkaPRSw==
X-Google-Smtp-Source: ABdhPJyA5gtmrMEOC8h3czFqyOTNZU9VDREUeQV5/TGDeA8LJad0KAjx5TO2gAkp/ZnwZamIONgeWg==
X-Received: by 2002:a17:906:3a43:: with SMTP id a3mr19190464ejf.121.1591023449974;
        Mon, 01 Jun 2020 07:57:29 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m30sm15259301eda.16.2020.06.01.07.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 07:57:20 -0700 (PDT)
Date:   Mon, 1 Jun 2020 16:57:16 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Subject: Re: [bpf-next PATCH 2/3] bpf: fix running sk_skb program types with
 ktls
Message-ID: <20200601165716.5a6fa76a@toad>
In-Reply-To: <159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
        <159079361946.5745.605854335665044485.stgit@john-Precision-5820-Tower>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 16:06:59 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> KTLS uses a stream parser to collect TLS messages and send them to
> the upper layer tls receive handler. This ensures the tls receiver
> has a full TLS header to parse when it is run. However, when a
> socket has BPF_SK_SKB_STREAM_VERDICT program attached before KTLS
> is enabled we end up with two stream parsers running on the same
> socket.
> 
> The result is both try to run on the same socket. First the KTLS
> stream parser runs and calls read_sock() which will tcp_read_sock
> which in turn calls tcp_rcv_skb(). This dequeues the skb from the
> sk_receive_queue. When this is done KTLS code then data_ready()
> callback which because we stacked KTLS on top of the bpf stream
> verdict program has been replaced with sk_psock_start_strp(). This
> will in turn kick the stream parser again and eventually do the
> same thing KTLS did above calling into tcp_rcv_skb() and dequeuing
> a skb from the sk_receive_queue.
> 
> At this point the data stream is broke. Part of the stream was
> handled by the KTLS side some other bytes may have been handled
> by the BPF side. Generally this results in either missing data
> or more likely a "Bad Message" complaint from the kTLS receive
> handler as the BPF program steals some bytes meant to be in a
> TLS header and/or the TLS header length is no longer correct.
> 
> We've already broke the idealized model where we can stack ULPs
> in any order with generic callbacks on the TX side to handle this.
> So in this patch we do the same thing but for RX side. We add
> a sk_psock_strp_enabled() helper so TLS can learn a BPF verdict
> program is running and add a tls_sw_has_ctx_rx() helper so BPF
> side can learn there is a TLS ULP on the socket.
> 
> Then on BPF side we omit calling our stream parser to avoid
> breaking the data stream for the KTLS receiver. Then on the
> KTLS side we call BPF_SK_SKB_STREAM_VERDICT once the KTLS
> receiver is done with the packet but before it posts the
> msg to userspace. This gives us symmetry between the TX and
> RX halfs and IMO makes it usable again. On the TX side we
> process packets in this order BPF -> TLS -> TCP and on
> the receive side in the reverse order TCP -> TLS -> BPF.
> 
> Discovered while testing OpenSSL 3.0 Alpha2.0 release.
> 
> Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h |    8 ++++++++
>  include/net/tls.h     |    9 +++++++++
>  net/core/skmsg.c      |   43 ++++++++++++++++++++++++++++++++++++++++---
>  net/tls/tls_sw.c      |   20 ++++++++++++++++++--
>  4 files changed, 75 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index ad31c9f..08674cd 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -437,4 +437,12 @@ static inline void psock_progs_drop(struct sk_psock_progs *progs)
>  	psock_set_prog(&progs->skb_verdict, NULL);
>  }
>  
> +int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb);
> +
> +static inline bool sk_psock_strp_enabled(struct sk_psock *psock)
> +{
> +	if (!psock)
> +		return false;
> +	return psock->parser.enabled;
> +}
>  #endif /* _LINUX_SKMSG_H */
> diff --git a/include/net/tls.h b/include/net/tls.h
> index bf9eb48..b74d59b 100644
> --- a/include/net/tls.h
> +++ b/include/net/tls.h
> @@ -567,6 +567,15 @@ static inline bool tls_sw_has_ctx_tx(const struct sock *sk)
>  	return !!tls_sw_ctx_tx(ctx);
>  }
>  
> +static inline bool tls_sw_has_ctx_rx(const struct sock *sk)
> +{
> +	struct tls_context *ctx = tls_get_ctx(sk);
> +
> +	if (!ctx)
> +		return false;
> +	return !!tls_sw_ctx_rx(ctx);
> +}
> +
>  void tls_sw_write_space(struct sock *sk, struct tls_context *ctx);
>  void tls_device_write_space(struct sock *sk, struct tls_context *ctx);
>  
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 9d72f71..351afbf 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -7,6 +7,7 @@
>  
>  #include <net/sock.h>
>  #include <net/tcp.h>
> +#include <net/tls.h>
>  
>  static bool sk_msg_try_coalesce_ok(struct sk_msg *msg, int elem_first_coalesce)
>  {
> @@ -714,6 +715,38 @@ static void sk_psock_skb_redirect(struct sk_psock *psock, struct sk_buff *skb)
>  	}
>  }
>  
> +static void sk_psock_tls_verdict_apply(struct sk_psock *psock,
> +				       struct sk_buff *skb, int verdict)
> +{
> +	switch (verdict) {
> +	case __SK_REDIRECT:
> +		sk_psock_skb_redirect(psock, skb);
> +		break;
> +	case __SK_PASS:
> +	case __SK_DROP:

The two cases above need a "fallthrough;", right?

> +	default:
> +		break;
> +	}
> +}
> +
> +int sk_psock_tls_strp_read(struct sk_psock *psock, struct sk_buff *skb)
> +{
> +	struct bpf_prog *prog;
> +	int ret = __SK_PASS;
> +
> +	rcu_read_lock();
> +	prog = READ_ONCE(psock->progs.skb_verdict);
> +	if (likely(prog)) {
> +		tcp_skb_bpf_redirect_clear(skb);
> +		ret = sk_psock_bpf_run(psock, prog, skb);
> +		ret = sk_psock_map_verd(ret, tcp_skb_bpf_redirect_fetch(skb));
> +	}
> +	rcu_read_unlock();
> +	sk_psock_tls_verdict_apply(psock, skb, ret);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(sk_psock_tls_strp_read);
> +
>  static void sk_psock_verdict_apply(struct sk_psock *psock,
>  				   struct sk_buff *skb, int verdict)
>  {
> @@ -792,9 +825,13 @@ static void sk_psock_strp_data_ready(struct sock *sk)
>  	rcu_read_lock();
>  	psock = sk_psock(sk);
>  	if (likely(psock)) {
> -		write_lock_bh(&sk->sk_callback_lock);
> -		strp_data_ready(&psock->parser.strp);
> -		write_unlock_bh(&sk->sk_callback_lock);
> +		if (tls_sw_has_ctx_rx(sk)) {
> +			psock->parser.saved_data_ready(sk);
> +		} else {
> +			write_lock_bh(&sk->sk_callback_lock);
> +			strp_data_ready(&psock->parser.strp);
> +			write_unlock_bh(&sk->sk_callback_lock);
> +		}
>  	}
>  	rcu_read_unlock();
>  }
> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
> index 2d399b6..61043c6 100644
> --- a/net/tls/tls_sw.c
> +++ b/net/tls/tls_sw.c
> @@ -1731,6 +1731,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  	long timeo;
>  	bool is_kvec = iov_iter_is_kvec(&msg->msg_iter);
>  	bool is_peek = flags & MSG_PEEK;
> +	bool bpf_strp_enabled;
>  	int num_async = 0;
>  
>  	flags |= nonblock;
> @@ -1740,6 +1741,7 @@ int tls_sw_recvmsg(struct sock *sk,
>  
>  	psock = sk_psock_get(sk);
>  	lock_sock(sk);
> +	bpf_strp_enabled = sk_psock_strp_enabled(psock);
>  
>  	/* Process pending decrypted records. It must be non-zero-copy */
>  	err = process_rx_list(ctx, msg, &control, &cmsg, 0, len, false,
> @@ -1793,11 +1795,12 @@ int tls_sw_recvmsg(struct sock *sk,
>  
>  		if (to_decrypt <= len && !is_kvec && !is_peek &&
>  		    ctx->control == TLS_RECORD_TYPE_DATA &&
> -		    prot->version != TLS_1_3_VERSION)
> +		    prot->version != TLS_1_3_VERSION &&
> +		    !sk_psock_strp_enabled(psock))

Is this recheck of parser state intentional? Or can we test for
"!bpf_strp_enabled" here also?

>  			zc = true;
>  
>  		/* Do not use async mode if record is non-data */
> -		if (ctx->control == TLS_RECORD_TYPE_DATA)
> +		if (ctx->control == TLS_RECORD_TYPE_DATA && !bpf_strp_enabled)
>  			async_capable = ctx->async_capable;
>  		else
>  			async_capable = false;
> @@ -1847,6 +1850,19 @@ int tls_sw_recvmsg(struct sock *sk,
>  			goto pick_next_record;
>  
>  		if (!zc) {
> +			if (bpf_strp_enabled) {
> +				err = sk_psock_tls_strp_read(psock, skb);
> +				if (err != __SK_PASS) {
> +					rxm->offset = rxm->offset + rxm->full_len;
> +					rxm->full_len = 0;
> +					if (err == __SK_DROP)
> +						consume_skb(skb);
> +					ctx->recv_pkt = NULL;
> +					__strp_unpause(&ctx->strp);
> +					continue;
> +				}
> +			}
> +
>  			if (rxm->full_len > len) {
>  				retain_skb = true;
>  				chunk = len;
> 

