Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B906DB074
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjDGQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDGQWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:22:40 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B6EBB9D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:22:38 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54c12009c30so91199017b3.9
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680884558; x=1683476558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15kCeiA0aGjktmO+FFF2uLQMQdL/UDkjQnchVRiJ2Kw=;
        b=FxmzAmvpaoo9Jfn27OdcA9YaeAjwKVODA9N7luqP/Jdiq2kVQUXwCzi42GbCRL0RW9
         8CpnQw8zvg0zMBwiw9hqzwWnzMD6RAGARm20AASCr7X44ypM9PV27QoMYzlaFw9lSakJ
         eIti911K7udjHsxZR7umpbUPUBADaUTwbVve0eZM7Mie/YapXnMn8DBSSZq1qCdluw7Z
         E9bGScMM3XS6Up/1yBd4k8CvpoJhp2dWMVZCa+5/pHA7fm/CfU/vHF3leaDem2pdLU4p
         808S5wHfoYMOAzXr33iThit+LzFW0LHhnQvjsTBLt0snIZkgGRG1Z5dmxs3iQX0VxATJ
         7erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680884558; x=1683476558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15kCeiA0aGjktmO+FFF2uLQMQdL/UDkjQnchVRiJ2Kw=;
        b=Aafphwun/E6Ji0j+mg+lJDR9jEz4tofeAACc7HpXSNxxcRw036slOghXbhlTAyeIth
         +fXmd45aoHuINTXzImWfy93BuPn7j+Y1f1wjZewKPhYdp1FSdgqLgsUjEVk9zxg/Qhvp
         RdLJSj3gJBw1cqHOCH/MXauq5DPEPoXdPmTkLEFw5YrO7/23LP0HFc1KwCGOCI8oJdxw
         LE8J0E8Ae/I2N1Wr/DspIlH/BaV874AJ+vZnppPLOHIK2N2C2M8axRPkRZb+v0LEkeEL
         OPA3V4C/70OgB4f1z810RtlVro30jeoX7kfSajDpqOS697OG4KOztR8WUEMTN9TUhBZi
         4l0g==
X-Gm-Message-State: AAQBX9fhSpEzt12Q0C0S35XTiE8NSRrpfVlDOZidMjzzV9s2RF4BzJ+V
        JFkRUIsHiNkvO38L76oAA0M7nII32pYmTvdPw8uHUA==
X-Google-Smtp-Source: AKy350YKH8q+/I0PANAOzXegOloGojE/2g1YadkOOjppjz7Qx027O7HaXkU0TWrfm9B+mTRD6MxuLes0sTZzJQtGPYk=
X-Received: by 2002:a05:690c:31b:b0:54c:15ad:11e4 with SMTP id
 bg27-20020a05690c031b00b0054c15ad11e4mr1798465ywb.0.1680884557715; Fri, 07
 Apr 2023 09:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-7-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-7-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:22:26 -0400
Message-ID: <CAM0EoMn9iwTBUW-OaK2sDtTS-PO2_nGLuvGmrqY5n8HYEdt7XQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 6:35=E2=80=AFAM Vladimir Oltean <vladimir.oltean@nxp=
.com> wrote:
>
> IEEE 802.1Q-2018 clause 6.7.2 Frame preemption specifies that each
> packet priority can be assigned to a "frame preemption status" value of
> either "express" or "preemptible". Express priorities are transmitted by
> the local device through the eMAC, and preemptible priorities through
> the pMAC (the concepts of eMAC and pMAC come from the 802.3 MAC Merge
> layer).
>
> The FP adminStatus is defined per packet priority, but 802.1Q clause
> 12.30.1.1.1 framePreemptionAdminStatus also says that:
>
> | Priorities that all map to the same traffic class should be
> | constrained to use the same value of preemption status.
>
> It is impossible to ignore the cognitive dissonance in the standard
> here, because it practically means that the FP adminStatus only takes
> distinct values per traffic class, even though it is defined per
> priority.
>
> I can see no valid use case which is prevented by having the kernel take
> the FP adminStatus as input per traffic class (what we do here).
> In addition, this also enforces the above constraint by construction.
> User space network managers which wish to expose FP adminStatus per
> priority are free to do so; they must only observe the prio_tc_map of
> the netdev (which presumably is also under their control, when
> constructing the mqprio netlink attributes).
>
> The reason for configuring frame preemption as a property of the Qdisc
> layer is that the information about "preemptible TCs" is closest to the
> place which handles the num_tc and prio_tc_map of the netdev. If the
> UAPI would have been any other layer, it would be unclear what to do
> with the FP information when num_tc collapses to 0. A key assumption is
> that only mqprio/taprio change the num_tc and prio_tc_map of the netdev.
> Not sure if that's a great assumption to make.
>
> Having FP in tc-mqprio can be seen as an implementation of the use case
> defined in 802.1Q Annex S.2 "Preemption used in isolation". There will
> be a separate implementation of FP in tc-taprio, for the other use
> cases.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
> v3->v4: none
> v2->v3: none
> v1->v2:
> - slightly reword commit message
> - move #include <linux/ethtool_netlink.h> to this patch
> - remove self-evident comment "only for dump and offloading"
>
>  include/net/pkt_sched.h        |   1 +
>  include/uapi/linux/pkt_sched.h |  16 +++++
>  net/sched/sch_mqprio.c         | 127 ++++++++++++++++++++++++++++++++-
>  net/sched/sch_mqprio_lib.c     |  14 ++++
>  net/sched/sch_mqprio_lib.h     |   2 +
>  5 files changed, 159 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
> index b43ed4733455..f436688b6efc 100644
> --- a/include/net/pkt_sched.h
> +++ b/include/net/pkt_sched.h
> @@ -172,6 +172,7 @@ struct tc_mqprio_qopt_offload {
>         u32 flags;
>         u64 min_rate[TC_QOPT_MAX_QUEUE];
>         u64 max_rate[TC_QOPT_MAX_QUEUE];
> +       unsigned long preemptible_tcs;
>  };
>
>  struct tc_taprio_caps {
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sche=
d.h
> index 000eec106856..b8d29be91b62 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -719,6 +719,11 @@ enum {
>
>  #define __TC_MQPRIO_SHAPER_MAX (__TC_MQPRIO_SHAPER_MAX - 1)
>
> +enum {
> +       TC_FP_EXPRESS =3D 1,
> +       TC_FP_PREEMPTIBLE =3D 2,
> +};

Suggestion: Add a MAX to this enum (as is traditionally done)..

> +
>  struct tc_mqprio_qopt {
>         __u8    num_tc;
>         __u8    prio_tc_map[TC_QOPT_BITMASK + 1];
> @@ -732,12 +737,23 @@ struct tc_mqprio_qopt {
>  #define TC_MQPRIO_F_MIN_RATE           0x4
>  #define TC_MQPRIO_F_MAX_RATE           0x8
>
> +enum {
> +       TCA_MQPRIO_TC_ENTRY_UNSPEC,
> +       TCA_MQPRIO_TC_ENTRY_INDEX,              /* u32 */
> +       TCA_MQPRIO_TC_ENTRY_FP,                 /* u32 */
> +
> +       /* add new constants above here */
> +       __TCA_MQPRIO_TC_ENTRY_CNT,
> +       TCA_MQPRIO_TC_ENTRY_MAX =3D (__TCA_MQPRIO_TC_ENTRY_CNT - 1)
> +};
> +
>  enum {
>         TCA_MQPRIO_UNSPEC,
>         TCA_MQPRIO_MODE,
>         TCA_MQPRIO_SHAPER,
>         TCA_MQPRIO_MIN_RATE64,
>         TCA_MQPRIO_MAX_RATE64,
> +       TCA_MQPRIO_TC_ENTRY,
>         __TCA_MQPRIO_MAX,
>  };
>
> diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
> index 5287ff60b3f9..bc158a7fd6ba 100644
> --- a/net/sched/sch_mqprio.c
> +++ b/net/sched/sch_mqprio.c
> @@ -5,6 +5,7 @@
>   * Copyright (c) 2010 John Fastabend <john.r.fastabend@intel.com>
>   */
>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/kernel.h>
> @@ -27,6 +28,7 @@ struct mqprio_sched {
>         u32 flags;
>         u64 min_rate[TC_QOPT_MAX_QUEUE];
>         u64 max_rate[TC_QOPT_MAX_QUEUE];
> +       u32 fp[TC_QOPT_MAX_QUEUE];
>  };
>
>  static int mqprio_enable_offload(struct Qdisc *sch,
> @@ -63,6 +65,8 @@ static int mqprio_enable_offload(struct Qdisc *sch,
>                 return -EINVAL;
>         }
>
> +       mqprio_fp_to_offload(priv->fp, &mqprio);
> +
>         err =3D dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_QDISC_MQPRIO,
>                                             &mqprio);
>         if (err)
> @@ -145,13 +149,94 @@ static int mqprio_parse_opt(struct net_device *dev,=
 struct tc_mqprio_qopt *qopt,
>         return 0;
>  }
>
> +static const struct
> +nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] =3D {
> +       [TCA_MQPRIO_TC_ENTRY_INDEX]     =3D NLA_POLICY_MAX(NLA_U32,
> +                                                        TC_QOPT_MAX_QUEU=
E),

And use it here...

Out of curiosity, could you have more that 16 queues in this spec? I
noticed 802.1p mentioned somewhere (typically 3 bits).
Lead up question: if the max is 16 then can preemptible_tcs for example be =
u32?

cheers,
jamal

> +       [TCA_MQPRIO_TC_ENTRY_FP]        =3D NLA_POLICY_RANGE(NLA_U32,
> +                                                          TC_FP_EXPRESS,
> +                                                          TC_FP_PREEMPTI=
BLE),
> +};
> +
>  static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] =3D {
>         [TCA_MQPRIO_MODE]       =3D { .len =3D sizeof(u16) },
>         [TCA_MQPRIO_SHAPER]     =3D { .len =3D sizeof(u16) },
>         [TCA_MQPRIO_MIN_RATE64] =3D { .type =3D NLA_NESTED },
>         [TCA_MQPRIO_MAX_RATE64] =3D { .type =3D NLA_NESTED },
> +       [TCA_MQPRIO_TC_ENTRY]   =3D { .type =3D NLA_NESTED },
>  };
>
> +static int mqprio_parse_tc_entry(u32 fp[TC_QOPT_MAX_QUEUE],
> +                                struct nlattr *opt,
> +                                unsigned long *seen_tcs,
> +                                struct netlink_ext_ack *extack)
> +{
> +       struct nlattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1] =3D { };
> +       int err, tc;
> +
> +       err =3D nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
> +                              mqprio_tc_entry_policy, extack);
> +       if (err < 0)
> +               return err;
> +
> +       if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
> +               NL_SET_ERR_MSG(extack, "TC entry index missing");
> +               return -EINVAL;
> +       }
> +
> +       tc =3D nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
> +       if (*seen_tcs & BIT(tc)) {
> +               NL_SET_ERR_MSG(extack, "Duplicate tc entry");
> +               return -EINVAL;
> +       }
> +
> +       *seen_tcs |=3D BIT(tc);
> +
> +       if (tb[TCA_MQPRIO_TC_ENTRY_FP])
> +               fp[tc] =3D nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_FP]);
> +
> +       return 0;
> +}
> +
> +static int mqprio_parse_tc_entries(struct Qdisc *sch, struct nlattr *nla=
ttr_opt,
> +                                  int nlattr_opt_len,
> +                                  struct netlink_ext_ack *extack)
> +{
> +       struct mqprio_sched *priv =3D qdisc_priv(sch);
> +       struct net_device *dev =3D qdisc_dev(sch);
> +       bool have_preemption =3D false;
> +       unsigned long seen_tcs =3D 0;
> +       u32 fp[TC_QOPT_MAX_QUEUE];
> +       struct nlattr *n;
> +       int tc, rem;
> +       int err =3D 0;
> +
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +               fp[tc] =3D priv->fp[tc];
> +
> +       nla_for_each_attr(n, nlattr_opt, nlattr_opt_len, rem) {
> +               if (nla_type(n) !=3D TCA_MQPRIO_TC_ENTRY)
> +                       continue;
> +
> +               err =3D mqprio_parse_tc_entry(fp, n, &seen_tcs, extack);
> +               if (err)
> +                       goto out;
> +       }
> +
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> +               priv->fp[tc] =3D fp[tc];
> +               if (fp[tc] =3D=3D TC_FP_PREEMPTIBLE)
> +                       have_preemption =3D true;
> +       }
> +
> +       if (have_preemption && !ethtool_dev_mm_supported(dev)) {
> +               NL_SET_ERR_MSG(extack, "Device does not support preemptio=
n");
> +               return -EOPNOTSUPP;
> +       }
> +out:
> +       return err;
> +}
> +
>  /* Parse the other netlink attributes that represent the payload of
>   * TCA_OPTIONS, which are appended right after struct tc_mqprio_qopt.
>   */
> @@ -234,6 +319,13 @@ static int mqprio_parse_nlattr(struct Qdisc *sch, st=
ruct tc_mqprio_qopt *qopt,
>                 priv->flags |=3D TC_MQPRIO_F_MAX_RATE;
>         }
>
> +       if (tb[TCA_MQPRIO_TC_ENTRY]) {
> +               err =3D mqprio_parse_tc_entries(sch, nlattr_opt, nlattr_o=
pt_len,
> +                                             extack);
> +               if (err)
> +                       return err;
> +       }
> +
>         return 0;
>  }
>
> @@ -247,7 +339,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlat=
tr *opt,
>         int i, err =3D -EOPNOTSUPP;
>         struct tc_mqprio_qopt *qopt =3D NULL;
>         struct tc_mqprio_caps caps;
> -       int len;
> +       int len, tc;
>
>         BUILD_BUG_ON(TC_MAX_QUEUE !=3D TC_QOPT_MAX_QUEUE);
>         BUILD_BUG_ON(TC_BITMASK !=3D TC_QOPT_BITMASK);
> @@ -265,6 +357,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlat=
tr *opt,
>         if (!opt || nla_len(opt) < sizeof(*qopt))
>                 return -EINVAL;
>
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +               priv->fp[tc] =3D TC_FP_EXPRESS;
> +
>         qdisc_offload_query_caps(dev, TC_SETUP_QDISC_MQPRIO,
>                                  &caps, sizeof(caps));
>
> @@ -415,6 +510,33 @@ static int dump_rates(struct mqprio_sched *priv,
>         return -1;
>  }
>
> +static int mqprio_dump_tc_entries(struct mqprio_sched *priv,
> +                                 struct sk_buff *skb)
> +{
> +       struct nlattr *n;
> +       int tc;
> +
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
> +               n =3D nla_nest_start(skb, TCA_MQPRIO_TC_ENTRY);
> +               if (!n)
> +                       return -EMSGSIZE;
> +
> +               if (nla_put_u32(skb, TCA_MQPRIO_TC_ENTRY_INDEX, tc))
> +                       goto nla_put_failure;
> +
> +               if (nla_put_u32(skb, TCA_MQPRIO_TC_ENTRY_FP, priv->fp[tc]=
))
> +                       goto nla_put_failure;
> +
> +               nla_nest_end(skb, n);
> +       }
> +
> +       return 0;
> +
> +nla_put_failure:
> +       nla_nest_cancel(skb, n);
> +       return -EMSGSIZE;
> +}
> +
>  static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
>  {
>         struct net_device *dev =3D qdisc_dev(sch);
> @@ -465,6 +587,9 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_b=
uff *skb)
>             (dump_rates(priv, &opt, skb) !=3D 0))
>                 goto nla_put_failure;
>
> +       if (mqprio_dump_tc_entries(priv, skb))
> +               goto nla_put_failure;
> +
>         return nla_nest_end(skb, nla);
>  nla_put_failure:
>         nlmsg_trim(skb, nla);
> diff --git a/net/sched/sch_mqprio_lib.c b/net/sched/sch_mqprio_lib.c
> index c58a533b8ec5..83b3793c4012 100644
> --- a/net/sched/sch_mqprio_lib.c
> +++ b/net/sched/sch_mqprio_lib.c
> @@ -114,4 +114,18 @@ void mqprio_qopt_reconstruct(struct net_device *dev,=
 struct tc_mqprio_qopt *qopt
>  }
>  EXPORT_SYMBOL_GPL(mqprio_qopt_reconstruct);
>
> +void mqprio_fp_to_offload(u32 fp[TC_QOPT_MAX_QUEUE],
> +                         struct tc_mqprio_qopt_offload *mqprio)
> +{
> +       unsigned long preemptible_tcs =3D 0;
> +       int tc;
> +
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +               if (fp[tc] =3D=3D TC_FP_PREEMPTIBLE)
> +                       preemptible_tcs |=3D BIT(tc);
> +
> +       mqprio->preemptible_tcs =3D preemptible_tcs;
> +}
> +EXPORT_SYMBOL_GPL(mqprio_fp_to_offload);
> +
>  MODULE_LICENSE("GPL");
> diff --git a/net/sched/sch_mqprio_lib.h b/net/sched/sch_mqprio_lib.h
> index 63f725ab8761..079f597072e3 100644
> --- a/net/sched/sch_mqprio_lib.h
> +++ b/net/sched/sch_mqprio_lib.h
> @@ -14,5 +14,7 @@ int mqprio_validate_qopt(struct net_device *dev, struct=
 tc_mqprio_qopt *qopt,
>                          struct netlink_ext_ack *extack);
>  void mqprio_qopt_reconstruct(struct net_device *dev,
>                              struct tc_mqprio_qopt *qopt);
> +void mqprio_fp_to_offload(u32 fp[TC_QOPT_MAX_QUEUE],
> +                         struct tc_mqprio_qopt_offload *mqprio);
>
>  #endif
> --
> 2.34.1
>
