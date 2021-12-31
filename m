Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1905A482282
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 07:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhLaGio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 01:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhLaGio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 01:38:44 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFC3C061574;
        Thu, 30 Dec 2021 22:38:43 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id w16so106032170edc.11;
        Thu, 30 Dec 2021 22:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7QdT5wIqMLqiDjnbc5NO2sqm1YBwnpTrRkOEfrSvYtM=;
        b=BRrX0UNubaRo0jTyr/gSq1Vv3qZcep0y9pArACTiMqqa5PvMX1Xed25KkzJAKU1k9e
         I2ATbje+ranMVDT7J7sRMPx7Jj1ZBUYhp816LNlX11Hl4iGHgwCfdVWXysjkGeOzjfco
         y8Hls+QQbk2DsQUmr8b4VJ7EAcdq85NNpNPrtTKNSCK9w7NY5OOO9efCzoW2mQ3+8IJI
         JuRr9YINEmBuoZJN0H/YpXPApT9sMxRUG43XaOfS7pqG5lMUD5eW79v8QbXPj6D6aemY
         1SXX5y8iD6mZbAC+Pmr2zc0hiHToOMW2y8y4TvdsA1bTxKqqWlPlEIxJ4XnQ4K3pta8+
         mvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7QdT5wIqMLqiDjnbc5NO2sqm1YBwnpTrRkOEfrSvYtM=;
        b=ci7I+Pi1cWjXkyYHnet6zOA+aDNuqd4xJqMag5iwmHuJuAxhe25qg97B8Q0hurdec/
         gUDBTfYEzN+fU7Qxji7GoLVSw2PRlOHS1gCEA22juaYdg6CZghWh+Ys7IUu0cfzY0Me5
         0jpeo8u0eqQJ4KTqSdX+QNHe8Zb8ttC0RisDlgDcRd61lNCnvCPiGTR4JmBMKpmweFcA
         qoHwS32wuO2vZBzGmUd04sNPNIZay8sghKbIDYM0GT5sW9g5dlwgKHfMdbFi5xy54d3y
         q70nVO5nfIKT3rYDo3BRJX5n5Lg1/wgxPoHliCN+mY4czT7qpd+OUCZKofkbsbfi58j1
         UrhA==
X-Gm-Message-State: AOAM531PmrX1xKOPT8w3iAdxyfre0v6+GzXj0U1/AMkbWIipSm8DMf/4
        FNQ3RE6v1RPptLBy2LGk7esyuTmIN3ol/vWlr50=
X-Google-Smtp-Source: ABdhPJwR3+AiHDBRUwjjjhAFaLoDRHgkHJb+lzXnAPIhYb6d3AGfZdHkoXYjtLknto7c4ODWZaHR0o2TZmaJEgCFXrU=
X-Received: by 2002:a17:907:7e9e:: with SMTP id qb30mr26583877ejc.348.1640932722369;
 Thu, 30 Dec 2021 22:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20211230093240.1125937-1-imagedong@tencent.com>
 <20211230093240.1125937-2-imagedong@tencent.com> <20211230172619.40603ff3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230172619.40603ff3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 31 Dec 2021 14:35:31 +0800
Message-ID: <CADxym3aonWQoR=XkoLqn_taEhjBYeMf7f2Tgjgnq7fCNT2kHNw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/3] net: skb: introduce kfree_skb_with_reason()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        David Ahern <dsahern@kernel.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        jonathan.lemon@gmail.com, alobakin@pm.me,
        Kees Cook <keescook@chromium.org>,
        Paolo Abeni <pabeni@redhat.com>, talalahmad@google.com,
        haokexin@gmail.com, Menglong Dong <imagedong@tencent.com>,
        atenart@kernel.org, bigeasy@linutronix.de,
        Wei Wang <weiwan@google.com>, arnd@arndb.de, vvs@virtuozzo.com,
        Cong Wang <cong.wang@bytedance.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mengen Sun <mengensun@tencent.com>, mungerjiang@tencent.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 9:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Dec 2021 17:32:38 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > Introduce the interface kfree_skb_with_reason(), which is used to pass
> > the reason why the skb is dropped to 'kfree_skb' tracepoint.
> >
> > Add the 'reason' field to 'trace_kfree_skb', therefor user can get
> > more detail information about abnormal skb with 'drop_monitor' or
> > eBPF.
>
> >  void skb_release_head_state(struct sk_buff *skb);
> >  void kfree_skb(struct sk_buff *skb);
>
> Should this be turned into a static inline calling
> kfree_skb_with_reason() now? BTW you should drop the
> '_with'.
>

I thought about it before, but I'm a little afraid that some users may trace
kfree_skb() with kprobe, making it inline may not be friendly to them?

> > +void kfree_skb_with_reason(struct sk_buff *skb,
> > +                        enum skb_drop_reason reason);
>
> continuation line is unaligned, please try checkpatch
>
> >  void kfree_skb_list(struct sk_buff *segs);
> >  void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
> >  void skb_tx_error(struct sk_buff *skb);
> > diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> > index 9e92f22eb086..cab1c08a30cd 100644
> > --- a/include/trace/events/skb.h
> > +++ b/include/trace/events/skb.h
> > @@ -9,29 +9,51 @@
> >  #include <linux/netdevice.h>
> >  #include <linux/tracepoint.h>
> >
> > +#define TRACE_SKB_DROP_REASON                                        \
> > +     EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)        \
> > +     EMe(SKB_DROP_REASON_MAX, HAHA_MAX)
>
> HAHA_MAX ?

Enn......WOW_MAX? Just kidding, I'll make it 'MAX' (or remove this line,
as it won't be used).

>
> > +
> > +#undef EM
> > +#undef EMe
> > +
> > +#define EM(a, b)     TRACE_DEFINE_ENUM(a);
> > +#define EMe(a, b)    TRACE_DEFINE_ENUM(a);
> > +
> > +TRACE_SKB_DROP_REASON
> > +
> > +#undef EM
> > +#undef EMe
> > +#define EM(a, b)     { a, #b },
> > +#define EMe(a, b)    { a, #b }
> > +
> > +
>
> double new line

Get it!

Thanks~
Menglong Dong

>
> >  /*
> >   * Tracepoint for free an sk_buff:
> >   */
> >  TRACE_EVENT(kfree_skb,
> >
> > -     TP_PROTO(struct sk_buff *skb, void *location),
> > +     TP_PROTO(struct sk_buff *skb, void *location,
> > +              enum skb_drop_reason reason),
> >
> > -     TP_ARGS(skb, location),
> > +     TP_ARGS(skb, location, reason),
> >
> >       TP_STRUCT__entry(
> > -             __field(        void *,         skbaddr         )
> > -             __field(        void *,         location        )
> > -             __field(        unsigned short, protocol        )
> > +             __field(void *,         skbaddr)
> > +             __field(void *,         location)
> > +             __field(unsigned short, protocol)
> > +             __field(enum skb_drop_reason,   reason)
> >       ),
> >
> >       TP_fast_assign(
> >               __entry->skbaddr = skb;
> >               __entry->location = location;
> >               __entry->protocol = ntohs(skb->protocol);
> > +             __entry->reason = reason;
> >       ),
> >
> > -     TP_printk("skbaddr=%p protocol=%u location=%p",
> > -             __entry->skbaddr, __entry->protocol, __entry->location)
> > +     TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
> > +             __entry->skbaddr, __entry->protocol, __entry->location,
> > +             __print_symbolic(__entry->reason, TRACE_SKB_DROP_REASON))
> >  );
> >
> >  TRACE_EVENT(consume_skb,
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 644b9c8be3a8..9464dbf9e3d6 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -4899,7 +4899,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
> >                       if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
> >                               trace_consume_skb(skb);
> >                       else
> > -                             trace_kfree_skb(skb, net_tx_action);
> > +                             trace_kfree_skb(skb, net_tx_action,
> > +                                             SKB_DROP_REASON_NOT_SPECIFIED);
> >
> >                       if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
> >                               __kfree_skb(skb);
> > diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> > index 3d0ab2eec916..7b288a121a41 100644
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
> >
> >  struct net_dm_alert_ops {
> >       void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
> > -                             void *location);
> > +                             void *location,
> > +                             enum skb_drop_reason reason);
> >       void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
> >                               int work, int budget);
> >       void (*work_item_func)(struct work_struct *work);
> > @@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
> >       spin_unlock_irqrestore(&data->lock, flags);
> >  }
> >
> > -static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
> > +static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
> > +                             void *location,
> > +                             enum skb_drop_reason reason)
> >  {
> >       trace_drop_common(skb, location);
> >  }
> > @@ -490,7 +493,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
> >
> >  static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
> >                                             struct sk_buff *skb,
> > -                                           void *location)
> > +                                           void *location,
> > +                                           enum skb_drop_reason reason)
> >  {
> >       ktime_t tstamp = ktime_get_real();
> >       struct per_cpu_dm_data *data;
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 275f7b8416fe..570dc022a8a1 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -770,11 +770,31 @@ void kfree_skb(struct sk_buff *skb)
> >       if (!skb_unref(skb))
> >               return;
> >
> > -     trace_kfree_skb(skb, __builtin_return_address(0));
> > +     trace_kfree_skb(skb, __builtin_return_address(0),
> > +                     SKB_DROP_REASON_NOT_SPECIFIED);
> >       __kfree_skb(skb);
> >  }
> >  EXPORT_SYMBOL(kfree_skb);
> >
> > +/**
> > + *   kfree_skb_with_reason - free an sk_buff with reason
> > + *   @skb: buffer to free
> > + *   @reason: reason why this skb is dropped
> > + *
> > + *   The same as kfree_skb() except that this function will pass
> > + *   the drop reason to 'kfree_skb' tracepoint.
> > + */
> > +void kfree_skb_with_reason(struct sk_buff *skb,
> > +                        enum skb_drop_reason reason)
> > +{
> > +     if (!skb_unref(skb))
> > +             return;
> > +
> > +     trace_kfree_skb(skb, __builtin_return_address(0), reason);
> > +     __kfree_skb(skb);
> > +}
> > +EXPORT_SYMBOL(kfree_skb_with_reason);
> > +
> >  void kfree_skb_list(struct sk_buff *segs)
> >  {
> >       while (segs) {
>
