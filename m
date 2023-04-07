Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862496DB08C
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 18:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjDGQ1X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 12:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDGQ1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 12:27:22 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2056BB
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 09:27:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id p15so49474790ybl.9
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 09:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1680884840; x=1683476840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pyEHfUQzRgIBrTJfSvdW81ZmDev3XyUb+m8xcDXYEdk=;
        b=pGQhNNjU6HB4e2ZvfBoLTho2UK6pTT9b1HP0Wdvb1DJfsLTM4RHP3/G5U/bZWR9+Fs
         GVMsaah6Shmxnwom0u09l0Sj2h2VphtUywVvseK2NoEBaUCagvPkcp8f0IGT1l6MoymP
         0z3bQv6tkGgpVed7yyymwljNUChkXMS2a+8FrLsGVTZg3WRCfQp7ATUHZY/b4gE5DgaC
         oKK0tTUGpWgd6cF5VLz3Gf90w8673tBlsrm0yprHXEB3SgL4PpWWTAXiTxMbx5Ka2ntR
         tLbm6WHyIb8iFEi/Qz6JfTtH0QIWnEHyTFUteKvc/Anq/KkgIjRDEm9V2X9jxI8ht9A8
         Z3Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680884840; x=1683476840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pyEHfUQzRgIBrTJfSvdW81ZmDev3XyUb+m8xcDXYEdk=;
        b=Kt/VOIHJHxt6KveeyUIpSz1dukElry6ZbYDZjKjL3mGyZ3RUAtjmRitXpM3dUXa8RZ
         kQ7CfnUt7xeOzveNn00VBAK5gj0WEPv3JlKZSu6uEnpTbwgZJpGaSI2ddE8pV9Cc0LBn
         B7qN0xKS/Gl9TtSwNj4pC9jezh0IvnKqeuihYZpaUCNdl306YCi1HU0RsAqq2V1H64F9
         XJX15l+Jyxjd94XB2u7KgS/nfWEFxOuTPfbOVrXYCe2e5+ERwhQhyRhw1FurRQCj0EWZ
         9VLd09vaY2T/61/0PfQpDULwynTa+ybyU4SQFIHUPrWZ0UAr5SkFgzEKqgX1PCuJmil0
         /OQw==
X-Gm-Message-State: AAQBX9fxbiz3ouyt/GIyF/7jaOq+aA7Y1/23vhF3iwCiv6jbFK+D+A8r
        Y6rI3yvCM45ecE3YsummT7nfAe0mLNJUlg6JS+hYaQ==
X-Google-Smtp-Source: AKy350bRIczYj2zahttMfKVZxwkvz5zulO4uoz7qri/Mf8wokiHFZuw63Fv6fRhvuCSezhf5VQnnnpEn+A+2oGGvz2Q=
X-Received: by 2002:a25:ca85:0:b0:b8b:f52c:a785 with SMTP id
 a127-20020a25ca85000000b00b8bf52ca785mr2163431ybg.7.1680884839818; Fri, 07
 Apr 2023 09:27:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com> <20230403103440.2895683-8-vladimir.oltean@nxp.com>
In-Reply-To: <20230403103440.2895683-8-vladimir.oltean@nxp.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 7 Apr 2023 12:27:08 -0400
Message-ID: <CAM0EoM=u14_S6oKbMCZFZm=52vncYY2athQrwTo2cmJGeLZozQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 7/9] net/sched: taprio: allow per-TC user
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
> This is a duplication of the FP adminStatus logic introduced for
> tc-mqprio. Offloading is done through the tc_mqprio_qopt_offload
> structure embedded within tc_taprio_qopt_offload. So practically, if a
> device driver is written to treat the mqprio portion of taprio just like
> standalone mqprio, it gets unified handling of frame preemption.
>
> I would have reused more code with taprio, but this is mostly netlink
> attribute parsing, which is hard to transform into generic code without
> having something that stinks as a result. We have the same variables
> with the same semantics, just different nlattr type values
> (TCA_MQPRIO_TC_ENTRY=3D5 vs TCA_TAPRIO_ATTR_TC_ENTRY=3D12;
> TCA_MQPRIO_TC_ENTRY_FP=3D2 vs TCA_TAPRIO_TC_ENTRY_FP=3D3, etc) and
> consequently, different policies for the nest.
>
> Every time nla_parse_nested() is called, an on-stack table "tb" of
> nlattr pointers is allocated statically, up to the maximum understood
> nlattr type. That array size is hardcoded as a constant, but when
> transforming this into a common parsing function, it would become either
> a VLA (which the Linux kernel rightfully doesn't like) or a call to the
> allocator.
>
> Having FP adminStatus in tc-taprio can be seen as addressing the 802.1Q
> Annex S.3 "Scheduling and preemption used in combination, no HOLD/RELEASE=
"
> and S.4 "Scheduling and preemption used in combination with HOLD/RELEASE"
> use cases. HOLD and RELEASE events are emitted towards the underlying
> MAC Merge layer when the schedule hits a Set-And-Hold-MAC or a
> Set-And-Release-MAC gate operation. So within the tc-taprio UAPI space,
> one can distinguish between the 2 use cases by choosing whether to use
> the TC_TAPRIO_CMD_SET_AND_HOLD and TC_TAPRIO_CMD_SET_AND_RELEASE gate
> operations within the schedule, or just TC_TAPRIO_CMD_SET_GATES.
>
> A small part of the change is dedicated to refactoring the max_sdu
> nlattr parsing to put all logic under the "if" that tests for presence
> of that nlattr.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Ferenc Fejes <fejes@inf.elte.hu>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---
> v3->v4: none
> v2->v3: none
> v1->v2: slightly reword commit message
>
>  include/uapi/linux/pkt_sched.h |  1 +
>  net/sched/sch_taprio.c         | 65 +++++++++++++++++++++++++++-------
>  2 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sche=
d.h
> index b8d29be91b62..51a7addc56c6 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1252,6 +1252,7 @@ enum {
>         TCA_TAPRIO_TC_ENTRY_UNSPEC,
>         TCA_TAPRIO_TC_ENTRY_INDEX,              /* u32 */
>         TCA_TAPRIO_TC_ENTRY_MAX_SDU,            /* u32 */
> +       TCA_TAPRIO_TC_ENTRY_FP,                 /* u32 */
>
>         /* add new constants above here */
>         __TCA_TAPRIO_TC_ENTRY_CNT,
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index cbad43019172..76db9a10ef50 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -7,6 +7,7 @@
>   */
>
>  #include <linux/ethtool.h>
> +#include <linux/ethtool_netlink.h>
>  #include <linux/types.h>
>  #include <linux/slab.h>
>  #include <linux/kernel.h>
> @@ -96,6 +97,7 @@ struct taprio_sched {
>         struct list_head taprio_list;
>         int cur_txq[TC_MAX_QUEUE];
>         u32 max_sdu[TC_MAX_QUEUE]; /* save info from the user */
> +       u32 fp[TC_QOPT_MAX_QUEUE]; /* only for dump and offloading */
>         u32 txtime_delay;
>  };
>
> @@ -1002,6 +1004,9 @@ static const struct nla_policy entry_policy[TCA_TAP=
RIO_SCHED_ENTRY_MAX + 1] =3D {
>  static const struct nla_policy taprio_tc_policy[TCA_TAPRIO_TC_ENTRY_MAX =
+ 1] =3D {
>         [TCA_TAPRIO_TC_ENTRY_INDEX]        =3D { .type =3D NLA_U32 },
>         [TCA_TAPRIO_TC_ENTRY_MAX_SDU]      =3D { .type =3D NLA_U32 },
> +       [TCA_TAPRIO_TC_ENTRY_FP]           =3D NLA_POLICY_RANGE(NLA_U32,
> +                                                             TC_FP_EXPRE=
SS,
> +                                                             TC_FP_PREEM=
PTIBLE),

Same comment applies as in patch 6 here..

cheers,
jamal

>
>  static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] =
=3D {
> @@ -1524,6 +1529,7 @@ static int taprio_enable_offload(struct net_device =
*dev,
>         mqprio_qopt_reconstruct(dev, &offload->mqprio.qopt);
>         offload->mqprio.extack =3D extack;
>         taprio_sched_to_offload(dev, sched, offload, &caps);
> +       mqprio_fp_to_offload(q->fp, &offload->mqprio);
>
>         for (tc =3D 0; tc < TC_MAX_QUEUE; tc++)
>                 offload->max_sdu[tc] =3D q->max_sdu[tc];
> @@ -1671,13 +1677,14 @@ static int taprio_parse_clockid(struct Qdisc *sch=
, struct nlattr **tb,
>  static int taprio_parse_tc_entry(struct Qdisc *sch,
>                                  struct nlattr *opt,
>                                  u32 max_sdu[TC_QOPT_MAX_QUEUE],
> +                                u32 fp[TC_QOPT_MAX_QUEUE],
>                                  unsigned long *seen_tcs,
>                                  struct netlink_ext_ack *extack)
>  {
>         struct nlattr *tb[TCA_TAPRIO_TC_ENTRY_MAX + 1] =3D { };
>         struct net_device *dev =3D qdisc_dev(sch);
> -       u32 val =3D 0;
>         int err, tc;
> +       u32 val;
>
>         err =3D nla_parse_nested(tb, TCA_TAPRIO_TC_ENTRY_MAX, opt,
>                                taprio_tc_policy, extack);
> @@ -1702,15 +1709,18 @@ static int taprio_parse_tc_entry(struct Qdisc *sc=
h,
>
>         *seen_tcs |=3D BIT(tc);
>
> -       if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU])
> +       if (tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]) {
>                 val =3D nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_MAX_SDU]);
> +               if (val > dev->max_mtu) {
> +                       NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds de=
vice max MTU");
> +                       return -ERANGE;
> +               }
>
> -       if (val > dev->max_mtu) {
> -               NL_SET_ERR_MSG_MOD(extack, "TC max SDU exceeds device max=
 MTU");
> -               return -ERANGE;
> +               max_sdu[tc] =3D val;
>         }
>
> -       max_sdu[tc] =3D val;
> +       if (tb[TCA_TAPRIO_TC_ENTRY_FP])
> +               fp[tc] =3D nla_get_u32(tb[TCA_TAPRIO_TC_ENTRY_FP]);
>
>         return 0;
>  }
> @@ -1720,29 +1730,51 @@ static int taprio_parse_tc_entries(struct Qdisc *=
sch,
>                                    struct netlink_ext_ack *extack)
>  {
>         struct taprio_sched *q =3D qdisc_priv(sch);
> +       struct net_device *dev =3D qdisc_dev(sch);
>         u32 max_sdu[TC_QOPT_MAX_QUEUE];
> +       bool have_preemption =3D false;
>         unsigned long seen_tcs =3D 0;
> +       u32 fp[TC_QOPT_MAX_QUEUE];
>         struct nlattr *n;
>         int tc, rem;
>         int err =3D 0;
>
> -       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
>                 max_sdu[tc] =3D q->max_sdu[tc];
> +               fp[tc] =3D q->fp[tc];
> +       }
>
>         nla_for_each_nested(n, opt, rem) {
>                 if (nla_type(n) !=3D TCA_TAPRIO_ATTR_TC_ENTRY)
>                         continue;
>
> -               err =3D taprio_parse_tc_entry(sch, n, max_sdu, &seen_tcs,
> +               err =3D taprio_parse_tc_entry(sch, n, max_sdu, fp, &seen_=
tcs,
>                                             extack);
>                 if (err)
> -                       goto out;
> +                       return err;
>         }
>
> -       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++) {
>                 q->max_sdu[tc] =3D max_sdu[tc];
> +               q->fp[tc] =3D fp[tc];
> +               if (fp[tc] !=3D TC_FP_EXPRESS)
> +                       have_preemption =3D true;
> +       }
> +
> +       if (have_preemption) {
> +               if (!FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> +                       NL_SET_ERR_MSG(extack,
> +                                      "Preemption only supported with fu=
ll offload");
> +                       return -EOPNOTSUPP;
> +               }
> +
> +               if (!ethtool_dev_mm_supported(dev)) {
> +                       NL_SET_ERR_MSG(extack,
> +                                      "Device does not support preemptio=
n");
> +                       return -EOPNOTSUPP;
> +               }
> +       }
>
> -out:
>         return err;
>  }
>
> @@ -2023,7 +2055,7 @@ static int taprio_init(struct Qdisc *sch, struct nl=
attr *opt,
>  {
>         struct taprio_sched *q =3D qdisc_priv(sch);
>         struct net_device *dev =3D qdisc_dev(sch);
> -       int i;
> +       int i, tc;
>
>         spin_lock_init(&q->current_entry_lock);
>
> @@ -2080,6 +2112,9 @@ static int taprio_init(struct Qdisc *sch, struct nl=
attr *opt,
>                 q->qdiscs[i] =3D qdisc;
>         }
>
> +       for (tc =3D 0; tc < TC_QOPT_MAX_QUEUE; tc++)
> +               q->fp[tc] =3D TC_FP_EXPRESS;
> +
>         taprio_detect_broken_mqprio(q);
>
>         return taprio_change(sch, opt, extack);
> @@ -2223,6 +2258,7 @@ static int dump_schedule(struct sk_buff *msg,
>  }
>
>  static int taprio_dump_tc_entries(struct sk_buff *skb,
> +                                 struct taprio_sched *q,
>                                   struct sched_gate_list *sched)
>  {
>         struct nlattr *n;
> @@ -2240,6 +2276,9 @@ static int taprio_dump_tc_entries(struct sk_buff *s=
kb,
>                                 sched->max_sdu[tc]))
>                         goto nla_put_failure;
>
> +               if (nla_put_u32(skb, TCA_TAPRIO_TC_ENTRY_FP, q->fp[tc]))
> +                       goto nla_put_failure;
> +
>                 nla_nest_end(skb, n);
>         }
>
> @@ -2281,7 +2320,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk=
_buff *skb)
>             nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_dela=
y))
>                 goto options_error;
>
> -       if (oper && taprio_dump_tc_entries(skb, oper))
> +       if (oper && taprio_dump_tc_entries(skb, q, oper))
>                 goto options_error;
>
>         if (oper && dump_schedule(skb, oper))
> --
> 2.34.1
>
