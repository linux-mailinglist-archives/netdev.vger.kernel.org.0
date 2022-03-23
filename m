Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97574E582C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbiCWSLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239514AbiCWSLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:11:50 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2543D88B24
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:10:19 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id h1so2862222edj.1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 11:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/fVOY+xiXSrrbAqtCK4dXmnHz3DPzT70K8fJJKIRegc=;
        b=gFquLzXrl13qnjJZwZDDowBlLDe/Ikr1Z1BHXgo4aGNDSRp/xlHnafEpK9uMnu1vpm
         Ran5pDWNzKRen2j5p6cpfDh4K98v6tJS7T44dyY2cdlYH1/WYvc74Y8uYr7sodn90Sl7
         50ts4PCQ7F7WVN3E/2DkTLwVoGH7Rruo6djc1lvmMRZZHfI9QuNfA+q7QmOCBMpmQcbR
         YXfzd52vzZrd8ZNyKHIkiMywnvhPpK5d37jZ6fhOprz3XI3ggPHdQWy+KLb5TCIJDmMI
         z6lYqOR5OvDPY8h2DZY+pBlCdHiztoaz8rTd8U1cCAFwO2ZpTHWXpjuARq/5Cra7peC5
         hjWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/fVOY+xiXSrrbAqtCK4dXmnHz3DPzT70K8fJJKIRegc=;
        b=RsWZDKj7nA018SANfTrQgPzRT5u7DrKuXcR3dx91Z3OsXXEbpo/kFzrc/Rs3VyEXDw
         a+F2QkucCwl8GF4nQJg1Mr9WUCR/+K9g4t/7/XTMOGPNRHbRXoYGK9rTZNORUFSMM6+w
         VV5Saf76jPzqzmY2G5vuPA7vhufsF4j9tNumsHZeVhsn6TgR3Z7HSR6YgPsZsKogFrk4
         UwcC1jFbuz4hwLCy1TJ4WoHDQWu55Gg6F++gGOrNWj+XWHhg4vsAu18A81noyUKzyUvZ
         zykh/yb9Nu1uW96rZplHm0t/CUY5q5Mp0xDyupBovbCp9zTPuDyQ5AU9EhlItBxm7Xfb
         7PTQ==
X-Gm-Message-State: AOAM533F78Pu5xoN6LJlfqJ+3m+LKfCRyemkmXcQnYJ+S9PeIvwPSWs6
        Obpd4I2qDeZdqrKphzBeXCtK5xZbGaeNVyNsYFI=
X-Google-Smtp-Source: ABdhPJxDWb30szhMCyeFzE2Foy6tmTy+2WcNLiyaX68CrTyvbwW/oeHP2S5qI7v0VFIKi1eztHZAD0r6OZqzZzaKMcw=
X-Received: by 2002:a05:6402:5106:b0:419:45cd:7ab0 with SMTP id
 m6-20020a056402510600b0041945cd7ab0mr1775967edd.116.1648059017399; Wed, 23
 Mar 2022 11:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220323021447.34800-1-xiangxia.m.yue@gmail.com> <20220323021447.34800-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20220323021447.34800-3-xiangxia.m.yue@gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Wed, 23 Mar 2022 13:10:03 -0500
Message-ID: <CAA93jw6MMWxSdO9TkcrQn4qw88us7+k+0f8oHMkkq=bOT5owqw@mail.gmail.com>
Subject: Re: [net-next v11 2/2] net: sched: support hash selecting tx queue
To:     xiangxia.m.yue@gmail.com
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:45 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch allows users to pick queue_mapping, range
> from A to B. Then we can load balance packets from A
> to B tx queue. The range is an unsigned 16bit value
> in decimal format.
>
> $ tc filter ... action skbedit queue_mapping skbhash A B
>
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> is enhanced with flags: SKBEDIT_F_TXQ_SKBHASH
>
>   +----+      +----+      +----+
>   | P1 |      | P2 |      | Pn |
>   +----+      +----+      +----+
>     |           |           |
>     +-----------+-----------+
>                 |
>                 | clsact/skbedit
>                 |      MQ
>                 v
>     +-----------+-----------+
>     | q0        | qn        | qm
>     v           v           v
>   HTB/FQ       FIFO   ...  FIFO
>
> For example:
> If P1 sends out packets to different Pods on other host, and
> we want distribute flows from qn - qm. Then we can use skb->hash
> as hash.
>
> setup commands:
> $ NETDEV=3Deth0
> $ ip netns add n1
> $ ip link add ipv1 link $NETDEV type ipvlan mode l2
> $ ip link set ipv1 netns n1
> $ ip netns exec n1 ifconfig ipv1 2.2.2.100/24 up
>
> $ tc qdisc add dev $NETDEV clsact
> $ tc filter add dev $NETDEV egress protocol ip prio 1 \
>         flower skip_hw src_ip 2.2.2.100 action skbedit queue_mapping skbh=
ash 2 6
> $ tc qdisc add dev $NETDEV handle 1: root mq
> $ tc qdisc add dev $NETDEV parent 1:1 handle 2: htb
> $ tc class add dev $NETDEV parent 2: classid 2:1 htb rate 100kbit
> $ tc class add dev $NETDEV parent 2: classid 2:2 htb rate 200kbit
> $ tc qdisc add dev $NETDEV parent 1:2 tbf rate 100mbit burst 100mb latenc=
y 1

aside from the utility of this patch the above example settings for
burst and latency are a bit awkward.

> $ tc qdisc add dev $NETDEV parent 1:3 pfifo
> $ tc qdisc add dev $NETDEV parent 1:4 pfifo
> $ tc qdisc add dev $NETDEV parent 1:5 pfifo
> $ tc qdisc add dev $NETDEV parent 1:6 pfifo
> $ tc qdisc add dev $NETDEV parent 1:7 pfifo

pfifo's default packet limit is 1000 packets, 5 queues like this could
create about 650ms of latency with tbf, more with htb & gso.

> $ ip netns exec n1 iperf3 -c 2.2.2.1 -i 1 -t 10 -P 10

Given the structure of this test, you are probably more regulated by
tsq than pfifo, however a packet capture of
the actual tcp rtt induced would be interesting. substitute fq_codel
for pfifo, also.

It's great to send lots of packets over lots of queues, but not so
great to have seconds of data outstanding in them.
>
> pick txqueue from 2 - 6:
> $ ethtool -S $NETDEV | grep -i tx_queue_[0-9]_bytes
>      tx_queue_0_bytes: 42
>      tx_queue_1_bytes: 0
>      tx_queue_2_bytes: 11442586444
>      tx_queue_3_bytes: 7383615334
>      tx_queue_4_bytes: 3981365579
>      tx_queue_5_bytes: 3983235051
>      tx_queue_6_bytes: 6706236461
>      tx_queue_7_bytes: 42
>      tx_queue_8_bytes: 0
>      tx_queue_9_bytes: 0
>
> txqueues 2 - 6 are mapped to classid 1:3 - 1:7
> $ tc -s class show dev $NETDEV
> ...
> class mq 1:3 root leaf 8002:
>  Sent 11949133672 bytes 7929798 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class mq 1:4 root leaf 8003:
>  Sent 7710449050 bytes 5117279 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class mq 1:5 root leaf 8004:
>  Sent 4157648675 bytes 2758990 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class mq 1:6 root leaf 8005:
>  Sent 4159632195 bytes 2759990 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> class mq 1:7 root leaf 8006:
>  Sent 7003169603 bytes 4646912 pkt (dropped 0, overlimits 0 requeues 0)
>  backlog 0b 0p requeues 0
> ...
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
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/tc_act/tc_skbedit.h        |  1 +
>  include/uapi/linux/tc_act/tc_skbedit.h |  2 ++
>  net/sched/act_skbedit.c                | 49 ++++++++++++++++++++++++--
>  3 files changed, 50 insertions(+), 2 deletions(-)
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
> index 800e93377218..6cb6101208d0 100644
> --- a/include/uapi/linux/tc_act/tc_skbedit.h
> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
> @@ -29,6 +29,7 @@
>  #define SKBEDIT_F_PTYPE                        0x8
>  #define SKBEDIT_F_MASK                 0x10
>  #define SKBEDIT_F_INHERITDSFIELD       0x20
> +#define SKBEDIT_F_TXQ_SKBHASH          0x40
>
>  struct tc_skbedit {
>         tc_gen;
> @@ -45,6 +46,7 @@ enum {
>         TCA_SKBEDIT_PTYPE,
>         TCA_SKBEDIT_MASK,
>         TCA_SKBEDIT_FLAGS,
> +       TCA_SKBEDIT_QUEUE_MAPPING_MAX,
>         __TCA_SKBEDIT_MAX
>  };
>  #define TCA_SKBEDIT_MAX (__TCA_SKBEDIT_MAX - 1)
> diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> index d5799b4fc499..2634c725bc75 100644
> --- a/net/sched/act_skbedit.c
> +++ b/net/sched/act_skbedit.c
> @@ -23,6 +23,20 @@
>  static unsigned int skbedit_net_id;
>  static struct tc_action_ops act_skbedit_ops;
>
> +static u16 tcf_skbedit_hash(struct tcf_skbedit_params *params,
> +                           struct sk_buff *skb)
> +{
> +       u16 queue_mapping =3D params->queue_mapping;
> +
> +       if (params->flags & SKBEDIT_F_TXQ_SKBHASH) {
> +               u32 hash =3D skb_get_hash(skb);
> +
> +               queue_mapping +=3D hash % params->mapping_mod;
> +       }
> +
> +       return netdev_cap_txqueue(skb->dev, queue_mapping);
> +}
> +
>  static int tcf_skbedit_act(struct sk_buff *skb, const struct tc_action *=
a,
>                            struct tcf_result *res)
>  {
> @@ -62,7 +76,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const s=
truct tc_action *a,
>  #ifdef CONFIG_NET_EGRESS
>                 netdev_xmit_skip_txqueue(true);
>  #endif
> -               skb_set_queue_mapping(skb, params->queue_mapping);
> +               skb_set_queue_mapping(skb, tcf_skbedit_hash(params, skb))=
;
>         }
>         if (params->flags & SKBEDIT_F_MARK) {
>                 skb->mark &=3D ~params->mask;
> @@ -96,6 +110,7 @@ static const struct nla_policy skbedit_policy[TCA_SKBE=
DIT_MAX + 1] =3D {
>         [TCA_SKBEDIT_PTYPE]             =3D { .len =3D sizeof(u16) },
>         [TCA_SKBEDIT_MASK]              =3D { .len =3D sizeof(u32) },
>         [TCA_SKBEDIT_FLAGS]             =3D { .len =3D sizeof(u64) },
> +       [TCA_SKBEDIT_QUEUE_MAPPING_MAX] =3D { .len =3D sizeof(u16) },
>  };
>
>  static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
> @@ -112,6 +127,7 @@ static int tcf_skbedit_init(struct net *net, struct n=
lattr *nla,
>         struct tcf_skbedit *d;
>         u32 flags =3D 0, *priority =3D NULL, *mark =3D NULL, *mask =3D NU=
LL;
>         u16 *queue_mapping =3D NULL, *ptype =3D NULL;
> +       u16 mapping_mod =3D 1;
>         bool exists =3D false;
>         int ret =3D 0, err;
>         u32 index;
> @@ -157,6 +173,25 @@ static int tcf_skbedit_init(struct net *net, struct =
nlattr *nla,
>         if (tb[TCA_SKBEDIT_FLAGS] !=3D NULL) {
>                 u64 *pure_flags =3D nla_data(tb[TCA_SKBEDIT_FLAGS]);
>
> +               if (*pure_flags & SKBEDIT_F_TXQ_SKBHASH) {
> +                       u16 *queue_mapping_max;
> +
> +                       if (!tb[TCA_SKBEDIT_QUEUE_MAPPING] ||
> +                           !tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX]) {
> +                               NL_SET_ERR_MSG_MOD(extack, "Missing requi=
red range of queue_mapping.");
> +                               return -EINVAL;
> +                       }
> +
> +                       queue_mapping_max =3D
> +                               nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING_MAX=
]);
> +                       if (*queue_mapping_max < *queue_mapping) {
> +                               NL_SET_ERR_MSG_MOD(extack, "The range of =
queue_mapping is invalid, max < min.");
> +                               return -EINVAL;
> +                       }
> +
> +                       mapping_mod =3D *queue_mapping_max - *queue_mappi=
ng + 1;
> +                       flags |=3D SKBEDIT_F_TXQ_SKBHASH;
> +               }
>                 if (*pure_flags & SKBEDIT_F_INHERITDSFIELD)
>                         flags |=3D SKBEDIT_F_INHERITDSFIELD;
>         }
> @@ -208,8 +243,10 @@ static int tcf_skbedit_init(struct net *net, struct =
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
> @@ -276,6 +313,13 @@ static int tcf_skbedit_dump(struct sk_buff *skb, str=
uct tc_action *a,
>                 goto nla_put_failure;
>         if (params->flags & SKBEDIT_F_INHERITDSFIELD)
>                 pure_flags |=3D SKBEDIT_F_INHERITDSFIELD;
> +       if (params->flags & SKBEDIT_F_TXQ_SKBHASH) {
> +               if (nla_put_u16(skb, TCA_SKBEDIT_QUEUE_MAPPING_MAX,
> +                               params->queue_mapping + params->mapping_m=
od - 1))
> +                       goto nla_put_failure;
> +
> +               pure_flags |=3D SKBEDIT_F_TXQ_SKBHASH;
> +       }
>         if (pure_flags !=3D 0 &&
>             nla_put(skb, TCA_SKBEDIT_FLAGS, sizeof(pure_flags), &pure_fla=
gs))
>                 goto nla_put_failure;
> @@ -325,6 +369,7 @@ static size_t tcf_skbedit_get_fill_size(const struct =
tc_action *act)
>         return nla_total_size(sizeof(struct tc_skbedit))
>                 + nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_PRIORITY */
>                 + nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPIN=
G */
> +               + nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_QUEUE_MAPPIN=
G_MAX */
>                 + nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MARK */
>                 + nla_total_size(sizeof(u16)) /* TCA_SKBEDIT_PTYPE */
>                 + nla_total_size(sizeof(u32)) /* TCA_SKBEDIT_MASK */
> --
> 2.27.0
>


--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
