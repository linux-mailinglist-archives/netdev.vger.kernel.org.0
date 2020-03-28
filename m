Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FAB196669
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 14:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgC1Nug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 09:50:36 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37862 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgC1Nuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 09:50:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id de14so15014035edb.4;
        Sat, 28 Mar 2020 06:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHUoNlW4AN0MRi17LN+8q4poGwZjZmjsHEnqvsLCyFE=;
        b=W+5KvZ48DwlzV0fdRjU8TYgBewkoL+66hPcXx3k3zIdXL9B95haxOfiJUKST+RLwAD
         Ba3zqP0PwhhqG4P6Pw7M6bPvuJiN+isHtAVxYaidf+IXVr0/G22Cq9k2gceBrs7lJ4/+
         h66XB/dV5I1iGAjOqBYhUYhtq98rkUNfODA59cCAK6J58Xft4ek9hUlP6KRiGQmEgP7c
         O9fuUaDBwG83h6TxDYEvZRUXBwrnofiqT51zEfaiEVKGkE6I8W7et5Gj/ok4aoO/aTE1
         QsgLbwiowJE1yyEv/wqkb0fvaHtZJ1H51cjMQ/tMYdmnssJ0N6zoSu8JSa4BfGIsoq8T
         0aqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHUoNlW4AN0MRi17LN+8q4poGwZjZmjsHEnqvsLCyFE=;
        b=aIKfG8R/n5mCWiAulBfIqYsJx1Egcg7gI1ITgLz+pFzptHAyd15I1z3Ee4eDbW46nE
         dkQXNOvjnWvCF/dy0yvjQqyfEacG02RB5j7Wjff2EqLT/6AX41Oj9ZX/jH5ZjEVcvMet
         IaLHH1zwdGRzWMmpaF2Nr9v6eUqetn6Iprem7JOngy0RIY0eW8qUrcPX2B87kvZDET6s
         HIO3Yl9+Jatruri+C2GfnOjGBsq4IU+VFVQjlgcCJ8AIDROXbS5Zhkidb86IyNkyUXy3
         IHw7Rw/ftJhPvFvJOZxaT6YCgyQ/N3tl66ZAWDWQW6vJn1wb/I6HuMsoFc88/7RIc5fo
         voNQ==
X-Gm-Message-State: ANhLgQ2iRqIsXhf3r4vXklnFpDr4b2IkogQVgq98XjhQuLq21wGj1zD7
        b81mAOAqIDGKawL4U7bQ7mwMmFm41xytt29zDm0=
X-Google-Smtp-Source: ADFU+vuLANcnio5W6UPAxtTTwZWHj6vl2aGfMN4DZR2j+vUv4D3Hm1l1Hx6fr8E9HM1ycsoLFb2LEGZh3yrRefjL6OI=
X-Received: by 2002:aa7:d602:: with SMTP id c2mr3804561edr.118.1585403433295;
 Sat, 28 Mar 2020 06:50:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200328123739.45247-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20200328123739.45247-1-xiaoliang.yang_1@nxp.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 28 Mar 2020 15:50:22 +0200
Message-ID: <CA+h21hpQO=KACy9yKCmOVQenyyoTjLyFD4mX3Cj7PCQnxCB8sA@mail.gmail.com>
Subject: Re: [net-next,v1] net: mscc: ocelot: add action of police on vcap_is2
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Li Yang <leoyang.li@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

Thanks for the patch. I've tested it, but sadly, as-is it doesn't compile.
But then again, net-next doesn't compile either, so there...

On Sat, 28 Mar 2020 at 14:41, Xiaoliang Yang <xiaoliang.yang_1@nxp.com> wrote:
>
> Ocelot has 384 policers that can be allocated to ingress ports,
> QoS classes per port, and VCAP IS2 entries. ocelot_police.c
> supports to set policers which can be allocated to police action
> of VCAP IS2. We allocate policers from maximum pol_id, and
> decrease the pol_id when add a new vcap_is2 entry which is
> police action.
>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_ace.c    | 62 ++++++++++++++++++++---
>  drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++
>  drivers/net/ethernet/mscc/ocelot_flower.c |  9 ++++
>  drivers/net/ethernet/mscc/ocelot_police.c | 24 +++++++++
>  drivers/net/ethernet/mscc/ocelot_police.h |  5 ++
>  include/soc/mscc/ocelot.h                 |  1 +
>  6 files changed, 98 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
> index 906b54025b17..159490212f4b 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ace.c
> +++ b/drivers/net/ethernet/mscc/ocelot_ace.c
> @@ -7,6 +7,7 @@
>  #include <linux/proc_fs.h>
>
>  #include <soc/mscc/ocelot_vcap.h>
> +#include "ocelot_police.h"
>  #include "ocelot_ace.h"
>  #include "ocelot_s2.h"
>
> @@ -299,9 +300,9 @@ static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
>  }
>
>  static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
> -                          enum ocelot_ace_action action)
> +                          struct ocelot_ace_rule *ace)
>  {
> -       switch (action) {
> +       switch (ace->action) {
>         case OCELOT_ACL_ACTION_DROP:
>                 vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
>                 vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
> @@ -319,6 +320,14 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
>                 vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
>                 vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
>                 break;
> +       case OCELOT_ACL_ACTION_POLICE:
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 0);
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX, ace->pol_ix);
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
> +               vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
> +               break;
>         }
>  }
>
> @@ -611,7 +620,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
>         }
>
>         vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
> -       is2_action_set(ocelot, &data, ace->action);
> +       is2_action_set(ocelot, &data, ace);
>         vcap_data_set(data.counter, data.counter_offset,
>                       vcap_is2->counter_width, ace->stats.pkts);
>
> @@ -639,12 +648,19 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
>         rule->stats.pkts = cnt;
>  }
>
> -static void ocelot_ace_rule_add(struct ocelot_acl_block *block,
> +static void ocelot_ace_rule_add(struct ocelot *ocelot,
> +                               struct ocelot_acl_block *block,
>                                 struct ocelot_ace_rule *rule)
>  {
>         struct ocelot_ace_rule *tmp;
>         struct list_head *pos, *n;
>
> +       if (rule->action == OCELOT_ACL_ACTION_POLICE) {
> +               block->pol_lpr--;
> +               rule->pol_ix = block->pol_lpr;
> +               ocelot_ace_policer_add(ocelot, rule->pol_ix, &rule->pol);
> +       }
> +
>         block->count++;
>
>         if (list_empty(&block->rules)) {
> @@ -697,7 +713,7 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>         int i, index;
>
>         /* Add rule to the linked list */
> -       ocelot_ace_rule_add(block, rule);
> +       ocelot_ace_rule_add(ocelot, block, rule);
>
>         /* Get the index of the inserted rule */
>         index = ocelot_ace_rule_get_index_id(block, rule);
> @@ -713,7 +729,33 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
>         return 0;
>  }
>
> -static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
> +static void ocelot_ace_police_del(struct ocelot *ocelot,
> +                                 struct ocelot_acl_block *block,
> +                                 u32 ix)
> +{
> +       struct ocelot_ace_rule *tmp;
> +       int index = -1;
> +
> +       if (ix < block->pol_lpr)
> +               return;
> +
> +       list_for_each_entry(tmp, &block->rules, list) {
> +               index++;
> +               if (tmp->action == OCELOT_ACL_ACTION_POLICE &&
> +                   tmp->pol_ix < ix) {
> +                       tmp->pol_ix += 1;
> +                       ocelot_ace_policer_add(ocelot, tmp->pol_ix,
> +                                              &rule->pol);

The "rule" variable doesn't exist here, you probably mean "tmp".
But I'm sure this patch was written before commit ce6659c55b7d ("net:
mscc: ocelot: replace "rule" and "ocelot_rule" variable names with
"ace""), can we please stick to that convention and name the variable
"ace" where possible (and here is an example of that)? It's easier to
follow the code.

> +                       is2_entry_set(ocelot, index, tmp);
> +               }
> +       }
> +
> +       ocelot_ace_policer_del(ocelot, block->pol_lpr);
> +       block->pol_lpr++;
> +}
> +
> +static void ocelot_ace_rule_del(struct ocelot *ocelot,
> +                               struct ocelot_acl_block *block,
>                                 struct ocelot_ace_rule *rule)
>  {
>         struct ocelot_ace_rule *tmp;
> @@ -722,6 +764,9 @@ static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
>         list_for_each_safe(pos, q, &block->rules) {
>                 tmp = list_entry(pos, struct ocelot_ace_rule, list);
>                 if (tmp->id == rule->id) {
> +                       if (tmp->action == OCELOT_ACL_ACTION_POLICE)
> +                               ocelot_ace_police_del(ocelot, block, tmp->pol_ix);
> +
>                         list_del(pos);
>                         kfree(tmp);
>                 }
> @@ -744,7 +789,7 @@ int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
>         index = ocelot_ace_rule_get_index_id(block, rule);
>
>         /* Delete rule */
> -       ocelot_ace_rule_del(block, rule);
> +       ocelot_ace_rule_del(ocelot, block, rule);
>
>         /* Move up all the blocks over the deleted rule */
>         for (i = index; i < block->count; i++) {
> @@ -779,6 +824,7 @@ int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
>  int ocelot_ace_init(struct ocelot *ocelot)
>  {
>         const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
> +       struct ocelot_acl_block *block = &ocelot->acl_block;
>         struct vcap_data data;
>
>         memset(&data, 0, sizeof(data));
> @@ -807,6 +853,8 @@ int ocelot_ace_init(struct ocelot *ocelot)
>         ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
>                          OCELOT_POLICER_DISCARD);
>
> +       block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
> +
>         INIT_LIST_HEAD(&ocelot->acl_block.rules);
>
>         return 0;
> diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
> index b9a5868e3f15..29d22c566786 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ace.h
> +++ b/drivers/net/ethernet/mscc/ocelot_ace.h
> @@ -7,6 +7,7 @@
>  #define _MSCC_OCELOT_ACE_H_
>
>  #include "ocelot.h"
> +#include "ocelot_police.h"
>  #include <net/sch_generic.h>
>  #include <net/pkt_cls.h>
>
> @@ -176,6 +177,7 @@ struct ocelot_ace_frame_ipv6 {
>  enum ocelot_ace_action {
>         OCELOT_ACL_ACTION_DROP,
>         OCELOT_ACL_ACTION_TRAP,
> +       OCELOT_ACL_ACTION_POLICE,
>  };
>
>  struct ocelot_ace_stats {
> @@ -208,6 +210,8 @@ struct ocelot_ace_rule {
>                 struct ocelot_ace_frame_ipv4 ipv4;
>                 struct ocelot_ace_frame_ipv6 ipv6;
>         } frame;
> +       struct ocelot_policer pol;
> +       u32 pol_ix;
>  };
>
>  int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
> index 873a9944fbfb..1af7968ad598 100644
> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> @@ -12,6 +12,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                                       struct ocelot_ace_rule *ace)
>  {
>         const struct flow_action_entry *a;
> +       s64 burst;
> +       u64 rate;
>         int i;
>
>         if (!flow_offload_has_one_action(&f->rule->action))
> @@ -29,6 +31,13 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
>                 case FLOW_ACTION_TRAP:
>                         ace->action = OCELOT_ACL_ACTION_TRAP;
>                         break;
> +               case FLOW_ACTION_POLICE:
> +                       ace->action = OCELOT_ACL_ACTION_POLICE;
> +                       rate = a->police.rate_bytes_ps;
> +                       ace->pol.rate = (u32)div_u64(rate, 1000) * 8;
> +                       burst = rate * PSCHED_NS2TICKS(a->police.burst);
> +                       ace->pol.burst = (u32)div_u64(burst, PSCHED_TICKS_PER_SEC);
> +                       break;
>                 default:
>                         return -EOPNOTSUPP;
>                 }
> diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
> index faddce43f2e3..8d25b2706ff0 100644
> --- a/drivers/net/ethernet/mscc/ocelot_police.c
> +++ b/drivers/net/ethernet/mscc/ocelot_police.c
> @@ -225,3 +225,27 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
>
>         return 0;
>  }
> +
> +int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
> +                          struct ocelot_policer *pol)
> +{
> +       struct qos_policer_conf pp = { 0 };
> +
> +       if (!pol)
> +               return -EINVAL;
> +
> +       pp.mode = MSCC_QOS_RATE_MODE_DATA;
> +       pp.pir = pol->rate;
> +       pp.pbs = pol->burst;
> +
> +       return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
> +}
> +
> +int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
> +{
> +       struct qos_policer_conf pp = { 0 };
> +
> +       pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
> +
> +       return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
> +}
> diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
> index ae9509229463..22025cce0a6a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_police.h
> +++ b/drivers/net/ethernet/mscc/ocelot_police.h
> @@ -19,4 +19,9 @@ int ocelot_port_policer_add(struct ocelot *ocelot, int port,
>
>  int ocelot_port_policer_del(struct ocelot *ocelot, int port);
>
> +int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
> +                          struct ocelot_policer *pol);
> +
> +int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix);
> +
>  #endif /* _MSCC_OCELOT_POLICE_H_ */
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 007b584cc431..388504c94f6e 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -468,6 +468,7 @@ struct ocelot_ops {
>  struct ocelot_acl_block {
>         struct list_head rules;
>         int count;
> +       int pol_lpr;
>  };
>
>  struct ocelot_port {
> --
> 2.17.1
>

For what it's worth, I am preparing another patch series for port
policers in DSA, and I'm keeping your patch in my tree and rebasing on
top of it. Depending on how things go with review, do you mind if I
just take your patch to address other received feedback, and repost
your flow-based policers together with my port-based policers?

Regards,
-Vladimir
