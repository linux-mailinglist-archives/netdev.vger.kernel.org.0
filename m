Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D403C61BC
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 19:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhGLRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 13:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhGLRUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 13:20:51 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CDAC0613DD;
        Mon, 12 Jul 2021 10:18:01 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id p3so302556ilg.8;
        Mon, 12 Jul 2021 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=E2uZcTnkvQEbUkwDoJh2J7VxR1MnGDciKE6wC9rRzGc=;
        b=dBPaNHIKkHmeiak13FqxlBuLKgJlSr7gdChukV+bdm8AFIYmPFYTQXuOeZc/k/xYN3
         VNSdYbMPBp1rQIqQRZUu2f0i7sofp5XVlsLCiT6TAo+NJ/tL68QSj9bVT0ndMhNlwwAK
         MY66ooQVVp3iGJfkOEl+MadLWkiR9zmBKPTPyYvJ9PlzPJlQja0bj1vM22DUsS2w3CNm
         48zIQvQgPpXs8itP0l0S6iaOu+CccGNvmFGaHM11BNnZAKTOksxGl9TGeiIaTw4fEKxB
         jFW6k/ByIo5K7XvMG/FSgIhI71vEOqbvZyUfK6rrJGjmJPL9084BQM0nZl4ViFZfxiA2
         Numg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=E2uZcTnkvQEbUkwDoJh2J7VxR1MnGDciKE6wC9rRzGc=;
        b=IUwpNT1iRZYke1Wo7B7MIDg1nn0evI8Yy8m5uwzJ7BrZ4pxSgJKZlL0Ea5hEV+88NG
         DqHYIKMMfSltKd8SHORA/yNe1JqJmsJhD2x1x94JYH8ZLEcLcGCdeVL0k1SM6Pjta+OI
         miBvs7WcTWy3EO61OEKBM2JBk2HVD1HLfSsfZT4fe5N0y88aEB/4jlIxfn/R50+dTJrm
         VlNnrmAyJrfB4ZxZRTKQ9HI98uhKg0fL49u0Hr5v9Md8F0dD+gy/59FWuhwFtmxAuSrl
         9zs2yCViGE/tEwHc88X/3tA16wHSJg8vQMoTEZ9iKz/li9F9gdyjrEDmz28Vg7jraopw
         CPyQ==
X-Gm-Message-State: AOAM533UyQZOl79dZ2PCzW4UU8aCD9j/JcJBOBOM6ksyu7kqugADnAHk
        PODZHr1BeK8nsIHLNvp5Wc4=
X-Google-Smtp-Source: ABdhPJxyN3rf47F3sVF46gjPAyWI9sKB2rLlhhs8tIGGnLXZ5X76rmwLAWWEOPd3EFC9ZQg0WCtSHA==
X-Received: by 2002:a92:c524:: with SMTP id m4mr14965115ili.42.1626110281240;
        Mon, 12 Jul 2021 10:18:01 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id t3sm5176253ilm.87.2021.07.12.10.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 10:18:00 -0700 (PDT)
Date:   Mon, 12 Jul 2021 10:17:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <60ec794151075_29dcc208fd@john-XPS-13-9370.notmuch>
In-Reply-To: <871r84ro73.fsf@cloudflare.com>
References: <20210706163150.112591-1-john.fastabend@gmail.com>
 <20210706163150.112591-3-john.fastabend@gmail.com>
 <871r84ro73.fsf@cloudflare.com>
Subject: Re: [PATCH bpf v3 2/2] bpf, sockmap: sk_prot needs inuse_idx set for
 proc stats
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Tue, Jul 06, 2021 at 06:31 PM CEST, John Fastabend wrote:
> > Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> > We currently do not set this correctly from sockmap side. The result is
> > reading sock stats '/proc/net/sockstat' gives incorrect values. The
> > socket counter is incremented correctly, but because we don't set the
> > counter correctly when we replace sk_prot we may omit the decrement.
> >
> > Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  net/core/sock_map.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> > index 60decd6420ca..27bdf768aa8c 100644
> > --- a/net/core/sock_map.c
> > +++ b/net/core/sock_map.c
> > @@ -185,10 +185,19 @@ static void sock_map_unref(struct sock *sk, void *link_raw)
> >
> >  static int sock_map_init_proto(struct sock *sk, struct sk_psock *psock)
> >  {
> > +	int err;
> > +#ifdef CONFIG_PROC_FS
> > +	int idx = sk->sk_prot->inuse_idx;
> > +#endif
> >  	if (!sk->sk_prot->psock_update_sk_prot)
> >  		return -EINVAL;
> >  	psock->psock_update_sk_prot = sk->sk_prot->psock_update_sk_prot;
> > -	return sk->sk_prot->psock_update_sk_prot(sk, psock, false);
> > +	err = sk->sk_prot->psock_update_sk_prot(sk, psock, false);
> > +#ifdef CONFIG_PROC_FS
> > +	if (!err)
> > +		sk->sk_prot->inuse_idx = idx;
> > +#endif
> > +	return err;
> >  }
> >
> >  static struct sk_psock *sock_map_psock_get_checked(struct sock *sk)
> 
> We could initialize inuse_idx just once in {tcp,udp}_bpf_rebuild_protos,
> if we changed {tcp,udp}_bpf_v4_build_proto to be a late_initcall, so
> that it runs after inet_init when {tcp,udp}_prot and udp_prot are
> already registered and have inuse_idx assigned.

OK does seem slightly nicer. Then I guess the diff is just,

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index f26916a62f25..d3e9386b493e 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -503,7 +503,7 @@ static int __init tcp_bpf_v4_build_proto(void)
        tcp_bpf_rebuild_protos(tcp_bpf_prots[TCP_BPF_IPV4], &tcp_prot);
        return 0;
 }
-core_initcall(tcp_bpf_v4_build_proto);
+late_initcall(tcp_bpf_v4_build_proto);
 
 static int tcp_bpf_assert_proto_ops(struct proto *ops)
 {
