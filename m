Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39E761CF7AE
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgELOqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbgELOqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:46:48 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716A7C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 07:46:47 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id o134so1430195ybg.2
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 07:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZTV0bm+dV5myg55NhhzvxBWYLy4KkmNSDNOaICvrWD4=;
        b=NmORQ5fOIAygXzpMJJXlJg0HHZcRwW21Ot/Giy2g9wWu5xbddhbTvWJpLXqq8WOvZU
         5Ie0vmZhijkwyPozPOKOUNNQnZg7+fdtFAxTTAYMlq0gtt2x2bXh3Ra/hXJ9Ve1kHFae
         gST+evpsAdJYIA92BtnOsEwVDuwkDcXPBzRBbpy3WQlICUxIG1/qq12C25nTuIMEem4L
         ZpecOl3N22B1p3CzZoWT6uXeiAZL8gVhQzKCI3CSpvIHBpGNIE8JjnFXag4IKnbwUTma
         SkJ5B5+SK3x7qBpcRqOx98kO9Sud5T+0fl1pDZAIfgFjeh5McPQGVLGxbJYkXPOoSwRq
         BjWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZTV0bm+dV5myg55NhhzvxBWYLy4KkmNSDNOaICvrWD4=;
        b=i6rOtq9p9pSX2m1dZVDYOTFN4eOA8U/u2l4A7wYA3I68cIhEf6herplZfIBh1Qdedg
         QvqS0xnhMvQR4nr4ShJOz1lNCcsDKdJITbYiL/GODwf4PrUKCl/msPLCx6GqMOU/qRFB
         e2AAC6rHyydsa5egUbrRHrZ8iYRwbB9h9FC5FFrv0yu2K71dpHTobC8a7iP096x7st8v
         8nWk8l+sdPIty0cJalkfSxGIw56mkjU6HAkISbmzEc7VNCHou5JxnCueoKmMGpExwI9i
         eKoemLcsDaydnTbF3fZCdZqpIR9W8Wy853jl1ckB4zhMRdzvPeO80PcWDRzMAtEWypou
         alBA==
X-Gm-Message-State: AGi0PuZgKN7UStYgmz1fS+jsR3nK9uu7snlHD2rwx4vTSEjDtYtu86WA
        jReSWdaVWYl/xxp3SHYzvJLcVXsNywJHMDibFJRUSA==
X-Google-Smtp-Source: APiQypIIIpB4QacdNi1KJkR6szUGxSmxYwJBlm5v4pPMuFIaXobVSbOmBGyg0w/VhB4LP7bN7HYpqVkiWq7RgKCXzSc=
X-Received: by 2002:a5b:58a:: with SMTP id l10mr35516773ybp.173.1589294806315;
 Tue, 12 May 2020 07:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1589280857.git.pabeni@redhat.com> <81c3f2f857c2e68e22f8e8b077410ffd2960a29f.1589280857.git.pabeni@redhat.com>
In-Reply-To: <81c3f2f857c2e68e22f8e8b077410ffd2960a29f.1589280857.git.pabeni@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 12 May 2020 07:46:34 -0700
Message-ID: <CANn89iLyoaduBmtVWo4bSxebGwBOQFbfYbnRAmVzCTQ3Lx-PsQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] mptcp: add new sock flag to deal with join subflows
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 7:11 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> MP_JOIN subflows must not land into the accept queue.
> Currently tcp_check_req() calls an mptcp specific helper
> to detect such scenario.
>
> Such helper leverages the subflow context to check for
> MP_JOIN subflows. We need to deal also with MP JOIN
> failures, even when the subflow context is not available
> due to allocation failure.
>
> A possible solution would be changing the syn_recv_sock()
> signature to allow returning a more descriptive action/
> error code and deal with that in tcp_check_req().
>
> Since the above need is MPTCP specific, this patch instead
> uses a TCP socket hole to add an MPTCP specific flag.
> Such flag is used by the MPTCP syn_recv_sock() to tell
> tcp_check_req() how to deal with the request socket.
>
> This change is a no-op for !MPTCP build, and makes the
> MPTCP code simpler. It allows also the next patch to deal
> correctly with MP JOIN failure.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/linux/tcp.h      |  1 +
>  include/net/mptcp.h      | 17 ++++++++++-------
>  net/ipv4/tcp_minisocks.c |  2 +-
>  net/mptcp/protocol.c     |  7 -------
>  net/mptcp/subflow.c      |  2 ++
>  5 files changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index e60db06ec28d..dc12c59db41e 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -385,6 +385,7 @@ struct tcp_sock {
>                            */
>  #if IS_ENABLED(CONFIG_MPTCP)
>         bool    is_mptcp;
> +       bool    drop_req;
>  #endif

This looks like this should only be needed in struct tcp_request_sock ?

Does this information need to be kept in the TCP socket after accept() ?

>
>  #ifdef CONFIG_TCP_MD5SIG
> diff --git a/include/net/mptcp.h b/include/net/mptcp.h
> index e60275659de6..c4809c24a185 100644
> --- a/include/net/mptcp.h
> +++ b/include/net/mptcp.h
> @@ -68,6 +68,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
>         return tcp_rsk(req)->is_mptcp;
>  }
>
> +static inline bool sk_drop_req(const struct sock *sk)
> +{
> +       return tcp_sk(sk)->is_mptcp && tcp_sk(sk)->drop_req;
> +}
> +
>  void mptcp_space(const struct sock *ssk, int *space, int *full_space);
>  bool mptcp_syn_options(struct sock *sk, const struct sk_buff *skb,
>                        unsigned int *size, struct mptcp_out_options *opts);
> @@ -121,8 +126,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
>                                  skb_ext_find(from, SKB_EXT_MPTCP));
>  }
>
> -bool mptcp_sk_is_subflow(const struct sock *sk);
> -
>  void mptcp_seq_show(struct seq_file *seq);
>  #else
>
> @@ -140,6 +143,11 @@ static inline bool rsk_is_mptcp(const struct request_sock *req)
>         return false;
>  }
>
> +static inline bool sk_drop_req(const struct sock *sk)
> +{
> +       return false;
> +}
> +
>  static inline void mptcp_parse_option(const struct sk_buff *skb,
>                                       const unsigned char *ptr, int opsize,
>                                       struct tcp_options_received *opt_rx)
> @@ -190,11 +198,6 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
>         return true;
>  }
>
> -static inline bool mptcp_sk_is_subflow(const struct sock *sk)
> -{
> -       return false;
> -}
> -
>  static inline void mptcp_space(const struct sock *ssk, int *s, int *fs) { }
>  static inline void mptcp_seq_show(struct seq_file *seq) { }
>  #endif /* CONFIG_MPTCP */
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 7e40322cc5ec..ba7cfb22dc79 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -774,7 +774,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>         if (!child)
>                 goto listen_overflow;
>
> -       if (own_req && sk_is_mptcp(child) && mptcp_sk_is_subflow(child)) {
> +       if (own_req && sk_drop_req(child)) {
>                 reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
>                 inet_csk_reqsk_queue_drop_and_put(sk, req);
>                 return child;
> diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
> index e1f23016ed3f..a61e60e94137 100644
> --- a/net/mptcp/protocol.c
> +++ b/net/mptcp/protocol.c
> @@ -1638,13 +1638,6 @@ bool mptcp_finish_join(struct sock *sk)
>         return ret;
>  }
>
> -bool mptcp_sk_is_subflow(const struct sock *sk)
> -{
> -       struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
> -
> -       return subflow->mp_join == 1;
> -}
> -
>  static bool mptcp_memory_free(const struct sock *sk, int wake)
>  {
>         struct mptcp_sock *msk = mptcp_sk(sk);
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 009d5c478062..b39a66ffac7a 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -500,6 +500,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
>                         ctx->remote_key = mp_opt.sndr_key;
>                         ctx->fully_established = mp_opt.mp_capable;
>                         ctx->can_ack = mp_opt.mp_capable;
> +                       tcp_sk(child)->drop_req = false;
>                 } else if (ctx->mp_join) {
>                         struct mptcp_sock *owner;
>
> @@ -512,6 +513,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
>                                 goto close_child;
>
>                         SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
> +                       tcp_sk(child)->drop_req = true;
>                 }
>         }
>
> --
> 2.21.3
>
