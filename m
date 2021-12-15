Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5A8475088
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 02:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhLOBey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 20:34:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbhLOBey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 20:34:54 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14A6C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 17:34:53 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id r11so68434569edd.9
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 17:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/w8oEgouasTk+RPiIPyGMgxG/0A+ZYYy3FkVOun0qz0=;
        b=BEr5SXzP4DMncIT5EnXOhP54/hnX/Jl+d/LpX+dl3KTYPphduadCg15dRZhW0gg2NS
         ehbF1GUm2+IvK6fZIxWKpOZDb2LzabMKrHvgbwE5ykESLYVkRiunXdBLSq8Dmvj+Ddd9
         FzK98zTfjRfxEE883D5hAYHLU3hdmet0yZBKj35iFqL9pOcrD5Bt2sC2H7bzkyx9CsDP
         nq+Bava8DSNsFr/x2rv5Rsxi+iLiJRjuWqxQwX1Ht/moTTBHMHb71HcS3+Pz8NGTLxqn
         1aZAERzrbaaPRSJAKbSG85R7sUgVTME7LFMFmxE9oWYBfe3NLm/6Nfes1pIrsi+RXz6B
         cy0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/w8oEgouasTk+RPiIPyGMgxG/0A+ZYYy3FkVOun0qz0=;
        b=lUFozONygrKfdji12vMiugxr2ZJWv+Kx1TvogijpJ0iPzbw6blQAXJCzuVnMKCiSLj
         MYlbc/tOcheB3angdXwIqLQ8CgH5F+b2kbRBkbwMRSC5SCr1z3vS7rmb8Ta5Y2TkfPir
         rp7P+nKmyShF+mmxawVjSnAhlZqHyWHKnE2dPpnvmGdiGnt15oSlwTBD7+A/nHG+j00p
         RrWwJAHQzwc8xQkhNYsknL09DMvubO2OytJxZ8wIWG8ysC7df8xn2Z6JJk1Cc/zBWGLP
         nZBlL44c0pRNo9aKRR1QRkAidac/paSg14gFZOiINZtvC6SUxx3ySQt5SERFi1ns5G82
         kcvQ==
X-Gm-Message-State: AOAM531AIs0i34ybvy/lCNyiC61V4dDzW4w3x0k2otc2giEv/Eo8P8Dw
        EMTGp/ofEsx1iV+2gb0QsLZjAxRfP5ZKWUC+QeI=
X-Google-Smtp-Source: ABdhPJz+1ITasMHMzMAorZ/0DEHFZ6vmpkWgu62AffOVj9qgjgg/93LSImgx2WWULQIoPTaOkcBmBQwraIdcPwe2gi8=
X-Received: by 2002:a17:906:1e05:: with SMTP id g5mr9008179ejj.552.1639532092140;
 Tue, 14 Dec 2021 17:34:52 -0800 (PST)
MIME-Version: 1.0
References: <20211210023626.20905-1-xiangxia.m.yue@gmail.com> <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211210023626.20905-3-xiangxia.m.yue@gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 15 Dec 2021 09:34:15 +0800
Message-ID: <CAMDZJNXF6C8xc-PDUq6rRSKyq0Eg6ywhY1SPuqNvYcO2S4ocZQ@mail.gmail.com>
Subject: Re: [net-next v3 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 10:36 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch allows users to select queue_mapping, range
> from A to B. And users can use skb-hash, cgroup classid
> and cpuid to select Tx queues. Then we can load balance
> packets from A to B queue. The range is an unsigned 16bit
> value in decimal format.
>
> $ tc filter ... action skbedit queue_mapping hash-type normal A B
>
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit") is
> enhanced with flags:
> * SKBEDIT_F_QUEUE_MAPPING_HASH
> * SKBEDIT_F_QUEUE_MAPPING_CLASSID
> * SKBEDIT_F_QUEUE_MAPPING_CPUID
>
> Use skb->hash, cgroup classid, or cpuid to distribute packets.
> Then same range of tx queues can be shared for different flows,
> cgroups, or CPUs in a variety of scenarios.
>
> For example, flows F1 may share range R1 with flows F2. The best
> way to do that is to set flag to SKBEDIT_F_QUEUE_MAPPING_HASH.
> If cgroup C1 share the R1 with cgroup C2 .. Cn, use the
> SKBEDIT_F_QUEUE_MAPPING_CLASSID. Of course, in some other scenario,
> C1 uses R1, while Cn can use Rn.
>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Alexander Lobakin <alobakin@pm.me>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Talal Ahmad <talalahmad@google.com>
> Cc: Kevin Hao <haokexin@gmail.com>
> Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Cc: Antoine Tenart <atenart@kernel.org>
> Cc: Wei Wang <weiwan@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Hi Jakub, Eric
Do you have any comment=EF=BC=9FWe talk about this patchset in this thread.
Should I resend this patchset with more commit message ?
> ---
>  include/net/tc_act/tc_skbedit.h        |  1 +
>  include/uapi/linux/tc_act/tc_skbedit.h |  8 +++
>  net/sched/act_skbedit.c                | 74 ++++++++++++++++++++++++--
>  3 files changed, 79 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbe=
dit.h
> index 00bfee70609e..ee96e0fa6566 100644
> --- a/include/net/tc_act/tc_skbedit.h
> +++ b/include/net/tc_act/tc_skbedit.h
> @@ -17,6 +17,7 @@ struct tcf_skbedit_params {
>         u32 mark;
>         u32 mask;
>         u16 queue_mapping;
> +       u16 mapping_mod;
>         u16 ptype;
>         struct rcu_head rcu;
>  };
> diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/=
tc_act/tc_skbedit.h
> index 800e93377218..5642b095d206 100644
> --- a/include/uapi/linux/tc_act/tc_skbedit.h
> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
> @@ -29,6 +29,13 @@
>  #define SKBEDIT_F_PTYPE                        0x8
>  #define SKBEDIT_F_MASK                 0x10
>  #define SKBEDIT_F_INHERITDSFIELD       0x20
> +#define SKBEDIT_F_QUEUE_MAPPING_HASH   0x40
> +#define SKBEDIT_F_QUEUE_MAPPING_CLASSID        0x80
> +#define SKBEDIT_F_QUEUE_MAPPING_CPUID  0x100
> +
> +#define SKBEDIT_F_QUEUE_MAPPING_HASH_MASK (SKBEDIT_F_QUEUE_MAPPING_HASH =
| \
> +                                          SKBEDIT_F_QUEUE_MAPPING_CLASSI=
D | \
> +                                          SKBEDIT_F_QUEUE_MAPPING_CPUID)
>
>  struct tc_skbedit {
>         tc_gen;
> @@ -45,6 +52,7 @@ enum {
>         TCA_SKBEDIT_PTYPE,
>         TCA_SKBEDIT_MASK,
>         TCA_SKBEDIT_FLAGS,
> +       TCA_SKBEDIT_QUEUE_MAPPING_MAX,
>         __TCA_SKBEDIT_MAX
>  };
>  #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index 498feedad70a..0b0d65d7112e 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -10,6 +10,7 @@
>  #include <linux/kernel.h>
>  #include <linux/skbuff.h>
>  #include <linux/rtnetlink.h>
> +#include <net/cls_cgroup.h>
>  #include <net/netlink.h>
>  #include <net/pkt_sched.h>
>  #include <net/ip.h>
> @@ -23,6 +24,37 @@
>  static unsigned int skbedit_net_id;
>  static struct tc_action_ops act_skbedit_ops;
>
> +static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
> +                           struct sk_buff *skb)
> +{
> +       u16 queue_mapping =3D params->queue_mapping;
> +       u16 mapping_mod =3D params->mapping_mod;
> +       u32 mapping_hash_type =3D params->flags &
> +                               SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
> +       u32 hash =3D 0;
> +
> +       if (!mapping_hash_type)
> +               return netdev_cap_txqueue(skb->dev, queue_mapping);
> +
> +       switch (mapping_hash_type) {
> +       case SKBEDIT_F_QUEUE_MAPPING_CLASSID:
> +               hash =3D jhash_1word(task_get_classid(skb), 0);
> +               break;
> +       case SKBEDIT_F_QUEUE_MAPPING_HASH:
> +               hash =3D skb_get_hash(skb);
> +               break;
> +       case SKBEDIT_F_QUEUE_MAPPING_CPUID:
> +               hash =3D raw_smp_processor_id();
> +               break;
> +       default:
> +               net_warn_ratelimited("The type of queue_mapping hash is n=
ot supported. 0x%x\n",
> +                                    mapping_hash_type);
> +       }
> +
> +       queue_mapping =3D queue_mapping + hash % mapping_mod;
> +       return netdev_cap_txqueue(skb->dev, queue_mapping);
> +}
> +
>  static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *=
a,
>                            struct tcf_result *res)
>  {
> @@ -57,10 +89,9 @@ static int tcf_skbedit_act(struct sk_buff *skb, const =
struct tc_action *a,
>                         break;
>                 }
>         }
> -       if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> -           skb->dev->real_num_tx_queues > params->queue_mapping) {
> +       if (params->flags & SKBEDIT_F_QUEUE_MAPPING) {
>                 netdev_xmit_skip_txqueue();
> -               skb_set_queue_mapping(skb, params->queue_mapping);
> +               skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb))=
;
>         }
>         if (params->flags & SKBEDIT_F_MARK) {
>                 skb->mark &=3D ~params->mask;
> @@ -94,6 +125,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBE=
DIT_MAX + 1] =3D {
>         [TCA_SKBEDIT_PTYPE]             =3D { .len =3D sizeof(u16) },
>         [TCA_SKBEDIT_MASK]              =3D { .len =3D sizeof(u32) },
>         [TCA_SKBEDIT_FLAGS]             =3D { .len =3D sizeof(u64) },
> +       [TCA_SKBEDIT_QUEUE_MAPPING_MAX] =3D { .len =3D sizeof(u16) },
>  };
>
>  static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
> @@ -110,6 +142,7 @@ static int tcf_skbedit_init(struct net *net, struct n=
lattr *nla,
>         struct tcf_skbedit *d;
>         u32 flags =3D 0, *priority =3D NULL, *mark =3D NULL, *mask =3D NU=
LL;
>         u16 *queue_mapping =3D NULL, *ptype =3D NULL;
> +       u16 mapping_mod =3D 0;
>         bool exists =3D false;
>         int ret =3D 0, err;
>         u32 index;
> @@ -154,7 +187,30 @@ static int tcf_skbedit_init(struct net *net, struct =
nlattr *nla,
>
>         if (tb[TCA_SKBEDIT_FLAGS] !=3D NULL) {
>                 u64 *pure_flags =3D nla_data(tb[TCA_SKBEDIT_FLAGS]);
> +               u64 mapping_hash_type =3D *pure_flags &
> +                                       SKBEDIT_F_QUEUE_MAPPING_HASH_MASK=
;
> +               if (mapping_hash_type) {
> +                       u16 *queue_mapping_max;
> +
> +                       /* Hash types are mutually exclusive. */
> +                       if (mapping_hash_type & (mapping_hash_type - 1))
> +                               return -EINVAL;
> +
> +                       if (!tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX])
> +                               return -EINVAL;
>
> +                       if (!tb[TCA_SKBEDIT_QUEUE_MAPPING])
> +                               return -EINVAL;
> +
> +                       queue_mapping_max =3D
> +                               nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX=
]);
> +
> +                       if (*queue_mapping_max < *queue_mapping)
> +                               return -EINVAL;
> +
> +                       mapping_mod =3D *queue_mapping_max - *queue_mappi=
ng + 1;
> +                       flags |=3D mapping_hash_type;
> +               }
>                 if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
>                         flags |=3D SKBEDIT_F_INHERITDSFIELD;
>         }
> @@ -206,8 +262,10 @@ static int tcf_skbedit_init(struct net *net, struct =
nlattr *nla,
>         params_new->flags =3D flags;
>         if (flags & SKBEDIT_F_PRIORITY)
>                 params_new->priority =3D *priority;
> -       if (flags & SKBEDIT_F_QUEUE_MAPPING)
> +       if (flags & SKBEDIT_F_QUEUE_MAPPING) {
>                 params_new->queue_mapping =3D *queue_mapping;
> +               params_new->mapping_mod =3D mapping_mod;
> +       }
>         if (flags & SKBEDIT_F_MARK)
>                 params_new->mark =3D *mark;
>         if (flags & SKBEDIT_F_PTYPE)
> @@ -274,6 +332,14 @@ static int tcf_skbedit_dump(struct sk_buff *skb, str=
uct tc_action *a,
>                 goto nla_put_failure;
>         if (params->flags & SKBEDIT_F_INHERITDSFIELD)
>                 pure_flags |=3D SKBEDIT_F_INHERITDSFIELD;
> +       if (params->flags & SKBEDIT_F_QUEUE_MAPPING_HASH_MASK) {
> +               if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
> +                               params->queue_mapping + params->mapping_m=
od - 1))
> +                       goto nla_put_failure;
> +
> +               pure_flags |=3D params->flags &
> +                             SKBEDIT_F_QUEUE_MAPPING_HASH_MASK;
> +       }
>         if (pure_flags !=3D 0 &&
>             nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_fla=
gs))
>                 goto nla_put_failure;
> --
> 2.27.0
>


--=20
Best regards, Tonghao
