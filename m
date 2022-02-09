Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1849F4AE77F
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 04:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbiBIDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 22:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359829AbiBICy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 21:54:56 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AA7C061353;
        Tue,  8 Feb 2022 18:54:54 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id fy20so3402180ejc.0;
        Tue, 08 Feb 2022 18:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bqtTdK0TT1VP41J1UOPy1VjbkVSMizRyRzOZ6tCheig=;
        b=YGMb3cSiC+KMDWUz6c19IGO3meyMeEvPpvT5otEh9gmMcxTJI0mXLKFss01Z5RXhcb
         gQpLjvm4ww5pDScz7YMNV/tsQkwmLNJ0b2dNAwE8CfqBuhXmA/OBl9i6GMT91S/hduRD
         JWyuxGCRc4b7ujDPDaYTySxMbw4pL3zyKnbt2cLP7PVdwL1IHkk+BZpKlKfeHfveeOEn
         JMn5QFN0rb0txSwO16ec2rKdR6IYKjSX3G2gCh+3CiqnIp3prs9qPqlcA/MFWucIP5X6
         pULY1pPvrJ+rX2pSOKm0Goxo2SrEmuYdJmrUXhd1E1Pal4bW3EOJQIMmkdSRAKWLuEHi
         uwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bqtTdK0TT1VP41J1UOPy1VjbkVSMizRyRzOZ6tCheig=;
        b=DeEAoOzqJH9Iz4jE3bRnGNBslgSlkkCg8ketD5CahPPqbvGtuT2cOa4Xy40QPVzr7E
         gXQshJCt704F3xioUDleWnybMMGMBXFgbEuEJmpMEOenFadPOWdLYUdPW/N3jEfUnUm4
         mv3xnCsHs/mTK5RARLK0/bB3PJ6fuDMe3TZ/hElnP626LLzpnH6xg0YEyH8Uim+Wk4GP
         jn9y5vc05h4vvJIfuSnJzWiHzqIaLQIWTMiknri7Bkabwn/qBXQs4QcEm+P6aSnLxvJq
         pz7dqeeCvQa45O0OEc4Pz4FQ41nZu/UEfdQmFuw4hthUDXEk5h4lb612r6XVk7drkVed
         ypZQ==
X-Gm-Message-State: AOAM530hcfjBt7O7343MCQ1kCICMSuEs2fSXTlCshCVSdY2y/GWmeEwR
        3ebQhhitB8GZ99Dp/OMf2KtRhrROu0r1+NGyjIM=
X-Google-Smtp-Source: ABdhPJx/sXJPPMltCJF9E0Vjqb/4igaQXZtp/9XYDrYiYKZHe+ter1DfujLLeM1I3woh5KWwCIMlYTNyQ2WZs6gIco4=
X-Received: by 2002:a17:906:b819:: with SMTP id dv25mr100613ejb.689.1644375293354;
 Tue, 08 Feb 2022 18:54:53 -0800 (PST)
MIME-Version: 1.0
References: <20220208072836.3540192-1-imagedong@tencent.com>
 <20220208072836.3540192-3-imagedong@tencent.com> <YgKFHyQphAwMgsEY@shredder>
In-Reply-To: <YgKFHyQphAwMgsEY@shredder>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 9 Feb 2022 10:49:59 +0800
Message-ID: <CADxym3aPfdM2ZFN8KnM3wXqXQ7FXZqUKNpVWzEDaxjRMWM9hYA@mail.gmail.com>
Subject: Re: [PATCH v7 net-next 2/2] net: drop_monitor: support drop reason
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On Tue, Feb 8, 2022 at 10:58 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Tue, Feb 08, 2022 at 03:28:36PM +0800, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> > drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> > drop_monitor is able to report the drop reason to users by netlink.
> >
> > The drop reasons are reported as string to users, which is exactly
> > the same as what we do when reporting it to ftrace.
> >
> > Signed-off-by: Menglong Dong <imagedong@tencent.com>
> > ---
> > v7:
> > - take the size of NET_DM_ATTR_REASON into accounting in
> >   net_dm_packet_report_size()
> > - let compiler define the size of drop_reasons
> >
> > v6:
> > - check the range of drop reason in net_dm_packet_report_fill()
> >
> > v5:
> > - check if drop reason larger than SKB_DROP_REASON_MAX
> >
> > v4:
> > - report drop reasons as string
> >
> > v3:
> > - referring to cb->reason and cb->pc directly in
> >   net_dm_packet_report_fill()
> >
> > v2:
> > - get a pointer to struct net_dm_skb_cb instead of local var for
> >   each field
> > ---
> >  include/uapi/linux/net_dropmon.h |  1 +
> >  net/core/drop_monitor.c          | 34 ++++++++++++++++++++++++++++----
> >  2 files changed, 31 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> > index 66048cc5d7b3..1bbea8f0681e 100644
> > --- a/include/uapi/linux/net_dropmon.h
> > +++ b/include/uapi/linux/net_dropmon.h
> > @@ -93,6 +93,7 @@ enum net_dm_attr {
> >       NET_DM_ATTR_SW_DROPS,                   /* flag */
> >       NET_DM_ATTR_HW_DROPS,                   /* flag */
> >       NET_DM_ATTR_FLOW_ACTION_COOKIE,         /* binary */
> > +     NET_DM_ATTR_REASON,                     /* string */
> >
> >       __NET_DM_ATTR_MAX,
> >       NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> > diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> > index 7b288a121a41..28c55d605566 100644
> > --- a/net/core/drop_monitor.c
> > +++ b/net/core/drop_monitor.c
> > @@ -48,6 +48,19 @@
> >  static int trace_state = TRACE_OFF;
> >  static bool monitor_hw;
> >
> > +#undef EM
> > +#undef EMe
> > +
> > +#define EM(a, b)     [a] = #b,
> > +#define EMe(a, b)    [a] = #b
> > +
> > +/* drop_reasons is used to translate 'enum skb_drop_reason' to string,
> > + * which is reported to user space.
> > + */
> > +static const char * const drop_reasons[] = {
> > +     TRACE_SKB_DROP_REASON
> > +};
> > +
> >  /* net_dm_mutex
> >   *
> >   * An overall lock guarding every operation coming from userspace.
> > @@ -126,6 +139,7 @@ struct net_dm_skb_cb {
> >               struct devlink_trap_metadata *hw_metadata;
> >               void *pc;
> >       };
> > +     enum skb_drop_reason reason;
> >  };
> >
> >  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> > @@ -498,6 +512,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
> >  {
> >       ktime_t tstamp = ktime_get_real();
> >       struct per_cpu_dm_data *data;
> > +     struct net_dm_skb_cb *cb;
> >       struct sk_buff *nskb;
> >       unsigned long flags;
> >
> > @@ -508,7 +523,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
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
> > @@ -574,6 +591,8 @@ static size_t net_dm_packet_report_size(size_t payload_len)
> >              nla_total_size(sizeof(u32)) +
> >              /* NET_DM_ATTR_PROTO */
> >              nla_total_size(sizeof(u16)) +
> > +            /* NET_DM_ATTR_REASON */
> > +            nla_total_size(SKB_DR_MAX_LEN + 1) +
>
> Nothing ensures that the reason is not longer than this length and
> nothing ensures that this assumption remains valid as more reasons are
> added.
>
> I think "SKB_DR_MAX_LEN" can be removed completely. Pass "reason" to
> this function and do "strlen(drop_reasons[reason]) + 1". Any reason it
> can't work?

Yeah, it can work. But it feels a little weird to pass this param to
net_dm_packet_report_size(). I'll give it a try.

>
> >              /* NET_DM_ATTR_PAYLOAD */
> >              nla_total_size(payload_len);
> >  }
> > @@ -606,8 +625,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
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
> > @@ -620,10 +640,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
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
>
> In which cases can this happen? Might be better to perform this
> validation in net_dm_packet_trace_kfree_skb_hit() and set "cb->reason"
> to "SKB_DROP_REASON_NOT_SPECIFIED" in this case. That way we don't need
> to perform the validation in later code paths

Logically speaking, this shouldn't happen, as the reason is always be
'enum skb_drop_reason'. I added this part out of misunderstanding
your previous reply, and now I'm not sure if we should keep this.

For security considering, let's keep it for the moment, and I'll move it
to net_dm_packet_trace_kfree_skb_hit()

Thanks!
Menglong Dong

>
> > +         nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
> >               goto nla_put_failure;
> >
> > -     snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> > +     snprintf(buf, sizeof(buf), "%pS", cb->pc);
> >       if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
> >               goto nla_put_failure;
> >
> > --
> > 2.34.1
> >
