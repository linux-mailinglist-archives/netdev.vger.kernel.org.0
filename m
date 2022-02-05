Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34124AA784
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 09:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348609AbiBEIBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 03:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiBEIBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 03:01:24 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0193CC061346;
        Sat,  5 Feb 2022 00:01:22 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id m11so17985015edi.13;
        Sat, 05 Feb 2022 00:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Spi4/TBWuPHr2EowITjtYU4PenRDdKDN3wwrLsjSjk4=;
        b=cvL613u1xOlgUDBHgPmghGnK1CdTmaklLNkMaQZ0R1bIp46Zp2C23aDSqiNG3FEdGT
         b96KvwJW4riA5fuQbd9Kb9KgxNBsjjTIpDOEQtocAe9P/onMf7Fke+coev4X1/L2crTW
         nxvYguQbbBm61i5uIO6Eqsl6Y2of7QnTyv8u2Q1UyBDr1yqspp6QmdTvga+JL9UvFuRr
         XBwnAXTddRTd13/o2Ei67SLk1lvmGPvBZ18ZqGM2h7ZpkIOpbBoaT3T4GWB60eBwxTAl
         kUJLafF25jv95yG2gZWv+8wxdo4LBx5SlN0AsP6bU+ZmqKwG47UB7v1QkdRoF8rQlxRp
         OHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Spi4/TBWuPHr2EowITjtYU4PenRDdKDN3wwrLsjSjk4=;
        b=P4iZczR0H3O+Q2lWDa7oFVt8+ETo1tBr4ecQnsUTnnMJUFICWIdBmQLAuUd5XZatdP
         kA0vrB6sW/4hQCNfI1yxuDTlf8rUBXoQzW+a2Nn/s/S8XJP3ZS/K/zo1O5QQdL67Cw+l
         DFIb0AhDP0+oAVqm16H0TjLA7TZukg9mbYq5M+IUIWzkoPOTMEFs6yM0mAaPhD5X9j9j
         L3ybodsQIaDJRcfNFNXg2wZ1HJrOfsdug0q1+dlG3osF3zCJRtoQXd6Ru9/a9JtoVkBL
         Hs/AJ3LgDJxh50+wTtRDR/leBVKTuvAAMD/z5tmttH3bzQ+SqYhC4I+DIv3MNYzSjujQ
         9tMQ==
X-Gm-Message-State: AOAM5335NYL8fMtNZovIr95WJg99xNESqt5iyYS+MuMmz2ykdl5/5l3p
        R5EWVXeREFMoGB3sxMK/NVvnpcgOFUyXk+M+Bys=
X-Google-Smtp-Source: ABdhPJxM1BHtMF4dTwKP6fg1UinVXOr+sBR/5ESOhk3z5WlFXdO9MAXRdxxLLkuNO1j+84XOCVJuxShiOa2a4vYfoD4=
X-Received: by 2002:a05:6402:5290:: with SMTP id en16mr688163edb.236.1644048081477;
 Sat, 05 Feb 2022 00:01:21 -0800 (PST)
MIME-Version: 1.0
References: <20220204140813.4007173-1-imagedong@tencent.com>
In-Reply-To: <20220204140813.4007173-1-imagedong@tencent.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Sat, 5 Feb 2022 15:56:28 +0800
Message-ID: <CADxym3aQqMhgcOnK-HMto29GQ3zN_4fvqE9WpYuL_ZVwqWyp4Q@mail.gmail.com>
Subject: Re: [PATCH v5 net-next] net: drop_monitor: support drop reason
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
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

On Fri, Feb 4, 2022 at 10:08 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
>
> The drop reasons are reported as string to users, which is exactly
> the same as what we do when reporting it to ftrace.
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v5:
> - check if drop reason larger than SKB_DROP_REASON_MAX
>
> v4:
> - report drop reasons as string
>
> v3:
> - referring to cb->reason and cb->pc directly in
>   net_dm_packet_report_fill()
>
> v2:
> - get a pointer to struct net_dm_skb_cb instead of local var for
>   each field
> ---
>  include/uapi/linux/net_dropmon.h |  1 +
>  net/core/drop_monitor.c          | 29 +++++++++++++++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 66048cc5d7b3..1bbea8f0681e 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -93,6 +93,7 @@ enum net_dm_attr {
>         NET_DM_ATTR_SW_DROPS,                   /* flag */
>         NET_DM_ATTR_HW_DROPS,                   /* flag */
>         NET_DM_ATTR_FLOW_ACTION_COOKIE,         /* binary */
> +       NET_DM_ATTR_REASON,                     /* string */
>
>         __NET_DM_ATTR_MAX,
>         NET_DM_ATTR_MAX = __NET_DM_ATTR_MAX - 1
> diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
> index 7b288a121a41..2d1c8e8dec83 100644
> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -48,6 +48,16 @@
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
>
> +#undef EM
> +#undef EMe
> +
> +#define EM(a, b)       [a] = #b,
> +#define EMe(a, b)      [a] = #b
> +
> +static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {
> +       TRACE_SKB_DROP_REASON
> +};
> +
>  /* net_dm_mutex
>   *
>   * An overall lock guarding every operation coming from userspace.
> @@ -126,6 +136,7 @@ struct net_dm_skb_cb {
>                 struct devlink_trap_metadata *hw_metadata;
>                 void *pc;
>         };
> +       enum skb_drop_reason reason;
>  };
>
>  #define NET_DM_SKB_CB(__skb) ((struct net_dm_skb_cb *)&((__skb)->cb[0]))
> @@ -498,6 +509,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>  {
>         ktime_t tstamp = ktime_get_real();
>         struct per_cpu_dm_data *data;
> +       struct net_dm_skb_cb *cb;
>         struct sk_buff *nskb;
>         unsigned long flags;
>
> @@ -508,7 +520,9 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
>         if (!nskb)
>                 return;
>
> -       NET_DM_SKB_CB(nskb)->pc = location;
> +       cb = NET_DM_SKB_CB(nskb);
> +       cb->reason = reason;
> +       cb->pc = location;
>         /* Override the timestamp because we care about the time when the
>          * packet was dropped.
>          */
> @@ -606,8 +620,9 @@ static int net_dm_packet_report_in_port_put(struct sk_buff *msg, int ifindex,
>  static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>                                      size_t payload_len)
>  {
> -       u64 pc = (u64)(uintptr_t) NET_DM_SKB_CB(skb)->pc;
> +       struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
>         char buf[NET_DM_MAX_SYMBOL_LEN];
> +       enum skb_drop_reason reason;
>         struct nlattr *attr;
>         void *hdr;
>         int rc;
> @@ -620,10 +635,16 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
>         if (nla_put_u16(msg, NET_DM_ATTR_ORIGIN, NET_DM_ORIGIN_SW))
>                 goto nla_put_failure;
>
> -       if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, pc, NET_DM_ATTR_PAD))
> +       if (nla_put_u64_64bit(msg, NET_DM_ATTR_PC, (u64)(uintptr_t)cb->pc,
> +                             NET_DM_ATTR_PAD))
> +               goto nla_put_failure;
> +
> +       reason = cb->reason;
> +       if (reason < SKB_DROP_REASON_MAX &&
> +           nla_put_string(msg, NET_DM_ATTR_REASON, drop_reasons[reason]))
>                 goto nla_put_failure;

I guess I made a mistake here: assuming that the enum is unsigned.
Please ignore this version, I'll make a new one.

Thanks!
Menglong Dong

>
> -       snprintf(buf, sizeof(buf), "%pS", NET_DM_SKB_CB(skb)->pc);
> +       snprintf(buf, sizeof(buf), "%pS", cb->pc);
>         if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
>                 goto nla_put_failure;
>
> --
> 2.34.1
>
