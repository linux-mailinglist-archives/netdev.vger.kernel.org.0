Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B9F184EC1
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 19:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCMShH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 14:37:07 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43687 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727195AbgCMShH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 14:37:07 -0400
Received: by mail-oi1-f193.google.com with SMTP id p125so10444588oif.10;
        Fri, 13 Mar 2020 11:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z2trbxzJC/FwVJ14wGx3MPfubEaOIzpJQIrh+2wVgFY=;
        b=mzcuKmtUQZyWH4Pf77Qr0js03KndplB9ELTaUosYTbR+YkMlpJ4m/Jkr7GY09fCYaP
         triLZawvMDZ63a7oJ1Eab7BhdGKN+Uu0PT9ccrkCVTebkEM5KQmcFDT3smzxjAusjlaQ
         dhb07csyUj8c74jUdhcL5YzoPQH7J5B2yS5PlRscyJAeLcA7OA31C0c4DsP8rKnUmLoC
         YGJmYMqqrlMrsjQj8bU6XnJLe/23BS3lUMSWG7oOHvayD3gGsiKLAWvmyKWWUcBTH/FD
         05SD9iA7/zcUX4Sn+ILHHMFoxI8vPEyb8fWUhpYCXfr12D53xFBVMKZHTpc3GftXovLe
         VNCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z2trbxzJC/FwVJ14wGx3MPfubEaOIzpJQIrh+2wVgFY=;
        b=dIwXvgNikPrLn7sv/aqhl4zHVkOYYsl/WI4YpmXnE19Ubur7tRLwXHBkwYcFRwrByh
         5QSiTbiDYGPMscI/kJ9JUwodmjkZ0WYvqN/3A95kWGkejOsy4mn/uH0Yl9S0bX10fJHH
         ijXv4brVMJLrJIVIxujWzwBR8T8+RTI7YJ+3e6nl0pi16drrzft7cx6Rvu626s3eIfzV
         t7n8qzAhCXiQkY9tfvsn3EaQ9nAeXY2zJG6hk+Tq5SuhshtZJo7fWp0Zq7I0j9uVFbri
         GFdWnrdR251wrgLjKLey/pTQKrUlU5Macir5F151PswkNzOTPXbbBzCMsIn9//+oY6jX
         7AZw==
X-Gm-Message-State: ANhLgQ1FplmExJJapZAo6tMRYabfp1UvcekGQUvv7PfFCwV2WThyrQM+
        Wk2xZxtMlsfX5WgTsBjk+vAoMYT/uIPgrTQxtNU=
X-Google-Smtp-Source: ADFU+vs7RYmyl77czaL//uHcgbnbdjFxtE/PfPB2JTe7UrcBmbnG/Zw6x3QRUaTwTPDYg9FZgY0m8+9wSKekn3kpzGE=
X-Received: by 2002:aca:d489:: with SMTP id l131mr8388649oig.5.1584124626176;
 Fri, 13 Mar 2020 11:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200306125608.11717-1-Po.Liu@nxp.com> <20200306125608.11717-3-Po.Liu@nxp.com>
In-Reply-To: <20200306125608.11717-3-Po.Liu@nxp.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 13 Mar 2020 11:36:54 -0700
Message-ID: <CAM_iQpW-qjM5H00sUbPhrimJ2aPDAiO=bTVuF88bCtPH=qz4gQ@mail.gmail.com>
Subject: Re: [RFC,net-next 2/9] net: qos: introduce a gate control flow action
To:     Po Liu <Po.Liu@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        roy.zang@nxp.com, mingkai.hu@nxp.com, jerry.huang@nxp.com,
        leoyang.li@nxp.com, michael.chan@broadcom.com, vishal@chelsio.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, moshe@mellanox.com,
        ivan.khoronzhuk@linaro.org, Murali Karicheri <m-karicheri2@ti.com>,
        andre.guedes@linux.intel.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 6, 2020 at 5:14 AM Po Liu <Po.Liu@nxp.com> wrote:
> +static int parse_gate_list(struct nlattr *list,
> +                          struct tcf_gate_params *sched,
> +                          struct netlink_ext_ack *extack)
> +{
> +       struct nlattr *n;
> +       int err, rem;
> +       int i = 0;
> +
> +       if (!list)
> +               return -EINVAL;
> +
> +       nla_for_each_nested(n, list, rem) {
> +               struct tcfg_gate_entry *entry;
> +
> +               if (nla_type(n) != TCA_GATE_ONE_ENTRY) {
> +                       NL_SET_ERR_MSG(extack, "Attribute isn't type 'entry'");
> +                       continue;
> +               }
> +
> +               entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +               if (!entry) {
> +                       NL_SET_ERR_MSG(extack, "Not enough memory for entry");
> +                       return -ENOMEM;
> +               }

You need to free all previous allocated entries on this list
when an error happens, right?


> +
> +               err = parse_gate_entry(n, entry, i, extack);
> +               if (err < 0) {
> +                       kfree(entry);
> +                       return err;
> +               }
> +
> +               list_add_tail(&entry->list, &sched->entries);
> +               i++;
> +       }
> +
> +       sched->num_entries = i;
> +
> +       return i;
> +}
> +
> +static int tcf_gate_init(struct net *net, struct nlattr *nla,
> +                        struct nlattr *est, struct tc_action **a,
> +                        int ovr, int bind, bool rtnl_held,
> +                        struct tcf_proto *tp, u32 flags,
> +                        struct netlink_ext_ack *extack)
> +{
> +       struct tc_action_net *tn = net_generic(net, gate_net_id);
> +       enum tk_offsets tk_offset = TK_OFFS_TAI;
> +       struct nlattr *tb[TCA_GATE_MAX + 1];
> +       struct tcf_chain *goto_ch = NULL;
> +       struct tcfg_gate_entry *next;
> +       struct tcf_gate_params *p;
> +       struct gate_action *gact;
> +       s32 clockid = CLOCK_TAI;
> +       struct tc_gate *parm;
> +       struct tcf_gate *g;
> +       int ret = 0, err;
> +       u64 basetime = 0;
> +       u32 gflags = 0;
> +       s32 prio = -1;
> +       ktime_t start;
> +       u32 index;
> +
> +       if (!nla)
> +               return -EINVAL;
> +
> +       err = nla_parse_nested_deprecated(tb, TCA_GATE_MAX,
> +                                         nla, gate_policy, NULL);
> +       if (err < 0)
> +               return err;
> +
> +       if (!tb[TCA_GATE_PARMS])
> +               return -EINVAL;
> +       parm = nla_data(tb[TCA_GATE_PARMS]);
> +       index = parm->index;
> +       err = tcf_idr_check_alloc(tn, &index, a, bind);
> +       if (err < 0)
> +               return err;
> +
> +       if (err && bind)
> +               return 0;
> +
> +       if (!err) {
> +               ret = tcf_idr_create_from_flags(tn, index, est, a,
> +                                               &act_gate_ops, bind, flags);
> +               if (ret) {
> +                       tcf_idr_cleanup(tn, index);
> +                       return ret;
> +               }
> +
> +               ret = ACT_P_CREATED;
> +       } else if (!ovr) {
> +               tcf_idr_release(*a, bind);
> +               return -EEXIST;
> +       }
> +
> +       if (tb[TCA_GATE_PRIORITY])
> +               prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
> +
> +       if (tb[TCA_GATE_BASE_TIME])
> +               basetime = nla_get_u64(tb[TCA_GATE_BASE_TIME]);
> +
> +       if (tb[TCA_GATE_FLAGS])
> +               gflags = nla_get_u32(tb[TCA_GATE_FLAGS]);
> +
> +       if (tb[TCA_GATE_CLOCKID]) {
> +               clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
> +               switch (clockid) {
> +               case CLOCK_REALTIME:
> +                       tk_offset = TK_OFFS_REAL;
> +                       break;
> +               case CLOCK_MONOTONIC:
> +                       tk_offset = TK_OFFS_MAX;
> +                       break;
> +               case CLOCK_BOOTTIME:
> +                       tk_offset = TK_OFFS_BOOT;
> +                       break;
> +               case CLOCK_TAI:
> +                       tk_offset = TK_OFFS_TAI;
> +                       break;
> +               default:
> +                       NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
> +                       goto release_idr;
> +               }
> +       }
> +
> +       err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> +       if (err < 0)
> +               goto release_idr;
> +
> +       g = to_gate(*a);
> +
> +       gact = kzalloc(sizeof(*gact), GFP_KERNEL);
> +       if (!gact) {
> +               err = -ENOMEM;
> +               goto put_chain;
> +       }
> +
> +       p = get_gate_param(gact);
> +
> +       INIT_LIST_HEAD(&p->entries);
> +       if (tb[TCA_GATE_ENTRY_LIST]) {
> +               err = parse_gate_list(tb[TCA_GATE_ENTRY_LIST], p, extack);
> +               if (err < 0)
> +                       goto release_mem;
> +       }
> +
> +       if (tb[TCA_GATE_CYCLE_TIME]) {
> +               p->tcfg_cycletime = nla_get_u64(tb[TCA_GATE_CYCLE_TIME]);
> +       } else {
> +               struct tcfg_gate_entry *entry;
> +               ktime_t cycle = 0;
> +
> +               list_for_each_entry(entry, &p->entries, list)
> +                       cycle = ktime_add_ns(cycle, entry->interval);
> +               p->tcfg_cycletime = cycle;
> +       }
> +
> +       if (tb[TCA_GATE_CYCLE_TIME_EXT])
> +               p->tcfg_cycletime_ext =
> +                       nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
> +
> +       p->tcfg_priority = prio;
> +       p->tcfg_basetime = basetime;
> +       p->tcfg_clockid = clockid;
> +       p->tcfg_flags = gflags;
> +
> +       gact->tk_offset = tk_offset;
> +       spin_lock_init(&gact->entry_lock);
> +       hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS);
> +       gact->hitimer.function = gate_timer_func;
> +
> +       err = gate_get_start_time(gact, &start);
> +       if (err < 0) {
> +               NL_SET_ERR_MSG(extack,
> +                              "Internal error: failed get start time");
> +               goto release_mem;
> +       }
> +
> +       gact->current_close_time = start;
> +       gact->current_gate_status = GATE_ACT_GATE_OPEN | GATE_ACT_PENDING;
> +
> +       next = list_first_entry(&p->entries, struct tcfg_gate_entry, list);
> +       rcu_assign_pointer(gact->next_entry, next);
> +
> +       gate_start_timer(gact, start);
> +
> +       spin_lock_bh(&g->tcf_lock);
> +       goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
> +       gact = rcu_replace_pointer(g->actg, gact,
> +                                  lockdep_is_held(&g->tcf_lock));
> +       spin_unlock_bh(&g->tcf_lock);
> +
> +       if (goto_ch)
> +               tcf_chain_put_by_act(goto_ch);
> +       if (gact)
> +               kfree_rcu(gact, rcu);
> +
> +       if (ret == ACT_P_CREATED)
> +               tcf_idr_insert(tn, *a);
> +       return ret;
> +
> +release_mem:
> +       kfree_rcu(gact, rcu);

No need to bother RCU for an error path, right?

Thanks.
