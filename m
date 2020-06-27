Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D03DE20C359
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgF0Rlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgF0Rlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 13:41:44 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8E9C03E979
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 10:41:44 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id m16so6139110ybf.4
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 10:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRe8sWy60YaY/7mbOXD0PIdOGZMU8jUZOhmSrisijAQ=;
        b=aA0sJKtUTkS8N2vr2zU4XmGBqtqDpQzgj0okpMJCFM9eIyVJiqff2k1BWhaIV4FZOt
         opRxEwnHRD3453BuhoMzF40+sBlrST+msAaUNXXkHTLfy8phZ3DI5CVJl/Rx285sLmmd
         C292Y5twzPlp2bNNPdxNJlHa2ZoDBvIX5TRMEEVLJQgAmcW6UYPnAmWgQoLf12e0re+n
         HOgqIoI2GL9uVeplF00QXa5RAHlh80J0od8XEUcHXXchfKktRQiLcP6m87VUz2FI/8FF
         RsODMAt8wIvyvPUKeg48eIEvBNSFK1FxxQ/RO5jcIh41zlo4MgoJC9+2LFyjaBxsa/cm
         WSJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRe8sWy60YaY/7mbOXD0PIdOGZMU8jUZOhmSrisijAQ=;
        b=CsqM65IFhqOcuPNnWpqAlOFO7zbDuNNxF+59LFC75ovlI2tPHkpQ+d32fVBjKODfgM
         t2cQa0/fpJcZhc5AV7Scv/nd0bskZjJxaRC8sbqmZ+frhIXHAuR1dIVft4cpm3i9CkJS
         JwQyQDh2JlW9rPTch1ufPgtDXmB2oIaM6fhFhhzDaOISZkpA85zrDBQekluY4dCJIBem
         z/529+FD4u2ckBZNt0RPf4TaqtAqe5UBC9F7OuqgksElJ9VEYHcrvQDbVd4TuF1WXXWb
         dAA/RCuvkeRuAQNipe3lZ1JgsTXFCYJYQR2LAt5kTjzAGKNnYcUv/TgLVPKQYJuj+nI+
         QC6Q==
X-Gm-Message-State: AOAM533OG69QC14JtD4X2qqMVbHMiUncLacqOZNjAuGoxOCM0x06CAc5
        xNPHZ9Nh9JrsG/Svx5lQHTIU8/zLJ/LdeC80qyVl+w==
X-Google-Smtp-Source: ABdhPJwaqP+Ck9iMWmz/N7+/xPVTwBsvxwtfMHTQNUbCyHdPnqyqyw0z+Q8YD+g5Rj/8b3OkxfwTFrXIbu4kDk/VYow=
X-Received: by 2002:a25:b8c6:: with SMTP id g6mr15103507ybm.101.1593279703314;
 Sat, 27 Jun 2020 10:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200626175501.1459961-1-kafai@fb.com> <20200626175508.1460345-1-kafai@fb.com>
In-Reply-To: <20200626175508.1460345-1-kafai@fb.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 27 Jun 2020 10:41:32 -0700
Message-ID: <CANn89iLJNWh6bkH7DNhy_kmcAexuUCccqERqe7z2QsvPhGrYPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] tcp: Use a struct to represent a saved_syn
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel-team <kernel-team@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:55 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The total length of the saved syn packet is currently stored in
> the first 4 bytes (u32) and the actual packet data is stored after that.
>
> A latter patch will also want to store an offset (bpf_hdr_opt_off) to
> a TCP header option which the bpf program will be interested in parsing.
> Instead of anonymously storing this offset into the second 4 bytes,
> this patch creates a struct for the existing saved_syn.
> It can give a readable name to the stored lengths instead of implicitly
> using the first few u32(s) to do that.
>
> The new TCP bpf header offset (bpf_hdr_opt_off) added in a latter patch is
> an offset from the tcp header instead of from the network header.
> It will make the bpf programming side easier.  Thus, this patch stores
> the network header length instead of the total length of the syn
> header.  The total length can be obtained by the
> "network header len + tcp_hdrlen".  The latter patch can
> then also gets the offset to the TCP bpf header option by
> "network header len + bpf_hdr_opt_off".
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/tcp.h        | 11 ++++++++++-
>  include/net/request_sock.h |  7 ++++++-
>  net/core/filter.c          |  4 ++--
>  net/ipv4/tcp.c             |  9 +++++----
>  net/ipv4/tcp_input.c       | 12 ++++++------
>  5 files changed, 29 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> index 3bdec31ce8f4..9d50132d95e6 100644
> --- a/include/linux/tcp.h
> +++ b/include/linux/tcp.h
> @@ -404,7 +404,7 @@ struct tcp_sock {
>          * socket. Used to retransmit SYNACKs etc.
>          */
>         struct request_sock __rcu *fastopen_rsk;
> -       u32     *saved_syn;
> +       struct saved_syn *saved_syn;
>  };
>
>  enum tsq_enum {
> @@ -482,6 +482,15 @@ static inline void tcp_saved_syn_free(struct tcp_sock *tp)
>         tp->saved_syn = NULL;
>  }
>
> +static inline u32 tcp_saved_syn_len(const struct saved_syn *saved_syn)
> +{
> +       const struct tcphdr *th;
> +
> +       th = (void *)saved_syn->data + saved_syn->network_hdrlen;
> +
> +       return saved_syn->network_hdrlen + __tcp_hdrlen(th);
> +}


Ah... We have a patch extending TCP_SAVE_SYN to save all headers, so
keeping the length in a proper field would be better than going back
to TCP header to get __tcp_hdrlen(th)

I am not sure why trying to save 4 bytes in this saved_syn would matter ;)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index c9fcfa4ec43f3f0d75763e2bc6773e15bd38d68f..8ecdc5f87788439c7a08d3b72f9567e6369e7c4e
100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -258,7 +258,7 @@ struct tcp_sock {
                fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
                fastopen_no_cookie:1, /* Allow send/recv SYN+data
without a cookie */
                is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
-               unused:2;
+               save_syn:2;     /* Save headers of SYN packet */
        u8      nonagle     : 4,/* Disable Nagle algorithm?             */
                thin_lto    : 1,/* Use linear timeouts for thin streams */
                recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
@@ -270,7 +270,7 @@ struct tcp_sock {
                syn_fastopen_exp:1,/* SYN includes Fast Open exp. option */
                syn_fastopen_ch:1, /* Active TFO re-enabling probe */
                syn_data_acked:1,/* data in SYN is acked by SYN-ACK */
-               save_syn:1,     /* Save headers of SYN packet */
+               unused_save_syn:1,      /* Moved above */
                is_cwnd_limited:1,/* forward progress limited by snd_cwnd? */
                syn_smc:1;      /* SYN includes SMC */
        u32     tlp_high_seq;   /* snd_nxt at the time of TLP retransmit. */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index fa62baf509c8075cb7da30ee0f65059ac35c1c60..7e108de07fb4e45a994d3d75331489ad82f9deb7
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3097,7 +3097,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
                break;

        case TCP_SAVE_SYN:
-               if (val < 0 || val > 1)
+               /* 0: disable, 1: enable, 2: start from ether_header */
+               if (val < 0 || val > 2)
                        err = -EINVAL;
                else
                        tp->save_syn = val;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7ce5bad2308134954133f612ec129cf56946d9a1..5513f8aaae9f6c0303fac4d2c590ead1a6076502
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6708,11 +6708,19 @@ static void tcp_reqsk_record_syn(const struct sock *sk,
        if (tcp_sk(sk)->save_syn) {
                u32 len = skb_network_header_len(skb) + tcp_hdrlen(skb);
                u32 *copy;
+               void *base;
+
+               if (tcp_sk(sk)->save_syn == 2) {  /* Save full header. */
+                       len += skb->network_header - skb->mac_header;
+                       base = skb_mac_header(skb);
+               } else {
+                       base = skb_network_header(skb);
+               }

                copy = kmalloc(len + sizeof(u32), GFP_ATOMIC);
                if (copy) {
                        copy[0] = len;
-                       memcpy(&copy[1], skb_network_header(skb), len);
+                       memcpy(&copy[1], base, len);
                        req->saved_syn = copy;
                }
        }
