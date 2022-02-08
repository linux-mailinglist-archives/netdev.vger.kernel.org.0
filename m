Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01A04ACF50
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346289AbiBHC7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345777AbiBHC7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:59:17 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FE7BC06109E;
        Mon,  7 Feb 2022 18:59:16 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id f17so17325889edd.2;
        Mon, 07 Feb 2022 18:59:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WC7nvBT4t6u2JKkTS9J0CfU3z+ZLMOQNawlmGZkvWlM=;
        b=XYFhzYgZ34QZfbd1PNPFXrVaWPycD1IijIXOeHwVoGOTa8/ZLykFt5KArST9jrS6vV
         CZEmKnTE4O9nGoEpy0ixPt/lsPb4mrkXCHsD0gXcQ+KLcXD03eAHLIddv5/t1da0sXBi
         QjbDdwcd/edhWRurf8PtC0UO8GjV0zdi017ttJ9cQDLCpl61PtSeIcHFuRJ9CgCozKXd
         l8tQvUppC67q7UJbKNAPYCdLOUFKq8C6LZd1YJJkfzHhu9NSOCB1d5iEoEx3omSfwY8C
         dTAVKp5lViC+djP13d7Wv/1nODUDEWw/2iZfPR8hOjEd1lg82Z03IyDITkP/T/R0Y7vQ
         wSZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WC7nvBT4t6u2JKkTS9J0CfU3z+ZLMOQNawlmGZkvWlM=;
        b=P4ILWd7yxVhSyQASlclIS+nuly8sEVkVFl6aORi2CmcMTZVz048zXU/O4MLECTbo1e
         0KVqd399joqb9u4j9Jvva8ZC/QexEpouXpQhNdryueHZcHnpitsYchbQbNd3UcT8PoJg
         a8gpiHWV4Tt9lGeqorjm9Hr7MIRObWw9WeWAQaXN5n8cDizJE7HJFDQhNRhbqEhh8drx
         qah6BatxI3NBHdZ7rwH97515NXPEBL305tjeDyX5VMj1UMxcFH86J6FU1R2izvvzwuGn
         0XxZ/uZVmX37QGL71+9dYss7bfomCnb66Bj2Gmg/lGsyKUcU3suldQ2ZyrG6/dim/hmM
         fc0g==
X-Gm-Message-State: AOAM531nmWed/pHUSncGj7idk/WskRvUUQDJCZo1SsIm+vys7p/N1t7c
        x1X2vN3xZi3kzT5FaB2UWqPQiqlCXWwt17ak69Y=
X-Google-Smtp-Source: ABdhPJwB2mY6FQgnQezO/xKBJppV0NAkZlUSarliDu5+ppsxzl7SveX/LNr85/MXtfvommSzUruZGBwJ550jyh5Dsm8=
X-Received: by 2002:a50:ccd3:: with SMTP id b19mr2345435edj.253.1644289155048;
 Mon, 07 Feb 2022 18:59:15 -0800 (PST)
MIME-Version: 1.0
References: <20220205081738.565394-1-imagedong@tencent.com> <Yf+wcVAAWzmSz93n@shredder>
In-Reply-To: <Yf+wcVAAWzmSz93n@shredder>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 8 Feb 2022 10:54:22 +0800
Message-ID: <CADxym3aphsF=i4WbrdomPki+3Lz2=dOm-6h8P8fupV1ZtTPSaQ@mail.gmail.com>
Subject: Re: [PATCH v6 net-next] net: drop_monitor: support drop reason
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 6, 2022 at 7:26 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sat, Feb 05, 2022 at 04:17:38PM +0800, menglong8.dong@gmail.com wrote:
> > diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> > index 7b288a121a41..1180f1a28599 100644
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -48,6 +48,16 @@
> >  static int trace_state = TRACE_OFF;
> >  static bool monitor_hw;
> >
> > +#undef EM
> > +#undef EMe
> > +
> > +#define EM(a, b)     [a] = #b,
> > +#define EMe(a, b)    [a] = #b
> > +
> > +static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
> > +     TRACE_SKB_DROP_REASON
> > +};
> > +
> >  /* net_dm_mutex
> >   *
> >   * An overall lock guarding every operation coming from userspace.
> > @@ -126,6 +136,7 @@ struct net_dm_skb_cb {
> >               struct devlink_trap_metadata *hw_metadata;
> >               void *pc;
> >       };
> > +     enum skb_drop_reason reason;
> >  };
> >
> >  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> > @@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
> >  {
> >       ktime_t tstamp = ktime_get_real();
> >       struct per_cpu_dm_data *data;
> > +     struct net_dm_skb_cb *cb;
> >       struct sk_buff *nskb;
> >       unsigned long flags;
> >
> > @@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
> >       if (!nskb)
> >               return;
> >
> > -     NET_DM_SKB_CB(nskb)->pc = location;
> > +     cb = NET_DM_SKB_CB(nskb);
> > +     cb->reason = reason;
> > +     cb->pc = location;
> >       /* Override the timestamp because we care about the time when the
> >        * packet was dropped.
> >        */
> > @@ -606,8 +620,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
> >  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >                                    size_t payload_len)
> >  {
> > -     u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> > +     struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
> >       char buf[NET_DM_MAX_SYMBOL_LEN];
> > +     unsigned int reason;
> >       struct nlattr *attr;
> >       void *hdr;
> >       int rc;
> > @@ -620,10 +635,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
> >       if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
> >               goto nla_put_failure;
> >
> > -     if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> > +     if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
> > +                           NET_DM_ATTR_PAD))
> > +             goto nla_put_failure;
> > +
> > +     reason = (unsigned int)cb->reason;
> > +     if (reason < SKB_DROP_REASON_MAX &&
> > +         nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
>
> You need to make sure 'msg' has enough room for this attribute. Account
> for it in net_dm_packet_report_size()
>

Ok, I see what you mean now, thanks!

> >               goto nla_put_failure;
> >
> > -     snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> > +     snprintf(buf, sizeof(buf), "%pS", cb->pc);
> >       if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
> >               goto nla_put_failure;
> >
> > --
> > 2.27.0
> >
