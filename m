Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D923FF06D
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 17:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345905AbhIBPqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 11:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbhIBPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 11:46:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F07D0C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 08:45:11 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t15so3676975wrg.7
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 08:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rDNftNGmU54xsGRS67zsRu7m0uNE4X5v/MoeNFVfn7E=;
        b=sDw++GMRrMyzpeH1bwkM+FYPVg6fxrVV0LN1kGCn4YN+vcSZbmpwOKB4KWRrH4PWzF
         tplhblDAyL2RdW+Ojd3dMWXFs2O8dskVrgRaQw6rYDu3d21HyGhW2c9qOWLRe4bz8B6i
         cyaCcddl/Sqvj49yDnQyEXtu/D8DBfXbMOXgd2/IebWbFgSpslUPSbYQtpxBr0flFAg3
         VoEYbRI5+J/DxzgpC3s2PCyLmjQpPoRg9WVFh9sc1Xm8ZKxAKAe+kUVsnNZTO2l5TLdD
         EOko/woKE+VkWyg9+PV9wbXM+hb11rL9RZGyx4LMfgz8v5ab/VJ7gXtmNZdSq0bWr1DD
         +YPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rDNftNGmU54xsGRS67zsRu7m0uNE4X5v/MoeNFVfn7E=;
        b=p00UA90kvpHp4HCCefzmBBEVObilrP5TiGJrlwJGJIKhkh9zSPSSIVlLKORlDLkQN4
         HnE6ATtCh6Gqpi9IuJlRkg1aAZLe3yxEcoKyumrs5nycToIapOej0sHPXTvUumOHNvep
         6DMq+QJ5qAHtY7B+Nwmx/YnpkPVZzQ2FgaaSXqtuofQRgTmmGBDeuGTvBhSL6rJJQiZT
         XPCk8XTSRquiV6TuC3u+Nwx603o96+joirC2CKWpVkChHAvhS77Q5xDCFNCkOPuTFSDy
         KWniLayPU1g1dGzp2XJucQXM8gqXo8f9ujqnekAoEN7eIwJUMZAPea89WlbuaecZRFIF
         nl3w==
X-Gm-Message-State: AOAM532MWzPeYP9TmHbZDxWVlxLgTqzMf0pKY8tsYVpHZOKpYcHw2FEM
        QnoxEoJlNiRKbORVhx+eGJUl2awo4+1VOlIVOfNmpA==
X-Google-Smtp-Source: ABdhPJzrEuwh9wgaE+IJ9h+uXMRqJBofSl0PNBOp35s9vzEP0/FozcYSj/LHKR3v8LJwVerCjPOjjlIAbzBATeDztN8=
X-Received: by 2002:adf:e4ce:: with SMTP id v14mr4523745wrm.49.1630597510045;
 Thu, 02 Sep 2021 08:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210902093358.28345-1-yan2228598786@gmail.com>
In-Reply-To: <20210902093358.28345-1-yan2228598786@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 2 Sep 2021 08:44:57 -0700
Message-ID: <CANn89iLHg8cjLFKVzO+CkewLs_NkjEjQGetwARVnkuKRS9iUfQ@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` and SNMP parameters for
 tracing v3
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>, 2228598786@qq.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 2, 2021 at 2:34 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
>
> I used the suggestion from `Brendan Gregg`. In addition to the
> `reason` parameter there is also the `field` parameter pointing
> to `SNMP` to distinguish the `tcp_drop` cause. I know what I
> submitted is not accurate, so I am submitting the current
> patch to get comments and criticism from everyone so that I
> can submit better code and solutions.And of course to make me
> more familiar and understand the `linux` kernel network code.
> Thank you everyone!
>
> Signed-off-by: Zhongya Yan <yan2228598786@gmail.com>
> ---
>  include/trace/events/tcp.h |  39 +++---------
>  net/ipv4/tcp_input.c       | 126 ++++++++++++++-----------------------
>  2 files changed, 57 insertions(+), 108 deletions(-)
>
> diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
> index 699539702ea9..80892660458e 100644
> --- a/include/trace/events/tcp.h
> +++ b/include/trace/events/tcp.h
> @@ -371,28 +371,10 @@ DEFINE_EVENT(tcp_event_skb, tcp_bad_csum,
>         TP_ARGS(skb)
>  );
>
> -// from author @{Steven Rostedt}
> -#define TCP_DROP_REASON                                                        \
> -       REASON_STRING(TCP_OFO_QUEUE,            ofo_queue)                      \
> -       REASON_STRING(TCP_DATA_QUEUE_OFO,               data_queue_ofo)                 \
> -       REASON_STRING(TCP_DATA_QUEUE,           data_queue)                     \
> -       REASON_STRING(TCP_PRUNE_OFO_QUEUE,              prune_ofo_queue)                \
> -       REASON_STRING(TCP_VALIDATE_INCOMING,    validate_incoming)              \
> -       REASON_STRING(TCP_RCV_ESTABLISHED,              rcv_established)                \
> -       REASON_STRING(TCP_RCV_SYNSENT_STATE_PROCESS, rcv_synsent_state_process) \
> -       REASON_STRINGe(TCP_RCV_STATE_PROCESS,   rcv_state_proces)

??? On which tree / branch this patch is based on ?

> -
> -#undef REASON_STRING
> -#undef REASON_STRINGe
> -
> -#define REASON_STRING(code, name) {code , #name},
> -#define REASON_STRINGe(code, name) {code, #name}
> -
> -
>  TRACE_EVENT(tcp_drop,
> -               TP_PROTO(struct sock *sk, struct sk_buff *skb, __u32 reason),
> +               TP_PROTO(struct sock *sk, struct sk_buff *skb, int field, const char *reason),
>
> -               TP_ARGS(sk, skb, reason),
> +               TP_ARGS(sk, skb, field, reason),
>
>                 TP_STRUCT__entry(
>                         __array(__u8, saddr, sizeof(struct sockaddr_in6))
> @@ -409,9 +391,8 @@ TRACE_EVENT(tcp_drop,
>                         __field(__u32, srtt)
>                         __field(__u32, rcv_wnd)
>                         __field(__u64, sock_cookie)
> -                       __field(__u32, reason)
> -                       __field(__u32, reason_code)
> -                       __field(__u32, reason_line)
> +                       __field(int, field)
> +                       __string(reason, reason)
>                         ),
>
>                 TP_fast_assign(
> @@ -437,21 +418,19 @@ TRACE_EVENT(tcp_drop,
>                                 __entry->ssthresh = tcp_current_ssthresh(sk);
>                                 __entry->srtt = tp->srtt_us >> 3;
>                                 __entry->sock_cookie = sock_gen_cookie(sk);
> -                               __entry->reason = reason;
> -                               __entry->reason_code = TCP_DROP_CODE(reason);
> -                               __entry->reason_line = TCP_DROP_LINE(reason);
> +                               __entry->field = field;
> +
> +                               __assign_str(reason, reason);
>                 ),
>
>                 TP_printk("src=%pISpc dest=%pISpc mark=%#x data_len=%d snd_nxt=%#x snd_una=%#x \
>                                 snd_cwnd=%u ssthresh=%u snd_wnd=%u srtt=%u rcv_wnd=%u \
> -                               sock_cookie=%llx reason=%d reason_type=%s reason_line=%d",
> +                               sock_cookie=%llx field=%d reason=%s",
>                                 __entry->saddr, __entry->daddr, __entry->mark,
>                                 __entry->data_len, __entry->snd_nxt, __entry->snd_una,
>                                 __entry->snd_cwnd, __entry->ssthresh, __entry->snd_wnd,
>                                 __entry->srtt, __entry->rcv_wnd, __entry->sock_cookie,
> -                               __entry->reason,
> -                               __print_symbolic(__entry->reason_code, TCP_DROP_REASON),
> -                               __entry->reason_line)
> +                               field, __get_str(reason))
>  );
>
>  #endif /* _TRACE_TCP_H */
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index b2bc49f1f0de..bd33fd466e1e 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -100,7 +100,6 @@ int sysctl_tcp_max_orphans __read_mostly = NR_FILE;
>  #define FLAG_UPDATE_TS_RECENT  0x4000 /* tcp_replace_ts_recent() */
>  #define FLAG_NO_CHALLENGE_ACK  0x8000 /* do not call tcp_send_challenge_ack()  */
>  #define FLAG_ACK_MAYBE_DELAYED 0x10000 /* Likely a delayed ACK */
> -#define FLAG_DSACK_TLP         0x20000 /* DSACK for tail loss probe */
>
>  #define FLAG_ACKED             (FLAG_DATA_ACKED|FLAG_SYN_ACKED)
>  #define FLAG_NOT_DUP           (FLAG_DATA|FLAG_WIN_UPDATE|FLAG_ACKED)
> @@ -455,12 +454,11 @@ static void tcp_sndbuf_expand(struct sock *sk)
>   */
>
>  /* Slow part of check#2. */
> -static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
> -                            unsigned int skbtruesize)
> +static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb)

???

>  {
>         struct tcp_sock *tp = tcp_sk(sk);
>         /* Optimize this! */
> -       int truesize = tcp_win_from_space(sk, skbtruesize) >> 1;
> +       int truesize = tcp_win_from_space(sk, skb->truesize) >> 1;

???

>         int window = tcp_win_from_space(sk, sock_net(sk)->ipv4.sysctl_tcp_rmem[2]) >> 1;
>
>         while (tp->rcv_ssthresh <= window) {
> @@ -473,27 +471,7 @@ static int __tcp_grow_window(const struct sock *sk, const struct sk_buff *skb,
>         return 0;
>  }
>
> -/* Even if skb appears to have a bad len/truesize ratio, TCP coalescing
> - * can play nice with us, as sk_buff and skb->head might be either
> - * freed or shared with up to MAX_SKB_FRAGS segments.
> - * Only give a boost to drivers using page frag(s) to hold the frame(s),
> - * and if no payload was pulled in skb->head before reaching us.
> - */
> -static u32 truesize_adjust(bool adjust, const struct sk_buff *skb)
> -{
> -       u32 truesize = skb->truesize;
> -
> -       if (adjust && !skb_headlen(skb)) {
> -               truesize -= SKB_TRUESIZE(skb_end_offset(skb));
> -               /* paranoid check, some drivers might be buggy */
> -               if (unlikely((int)truesize < (int)skb->len))
> -                       truesize = skb->truesize;
> -       }
> -       return truesize;
> -}

It seems clear you are doing wrong things.

Have you silently reverted a prior patch ?
