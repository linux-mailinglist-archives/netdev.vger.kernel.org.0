Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529391FC1E1
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgFPWxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgFPWxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 18:53:12 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B68C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:53:11 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id dr13so187417ejc.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 15:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W9+v/xUPTt3A0iA2Dk+Y5cuoAhjim6oQMYqIfaI0TIA=;
        b=IkCgyrt4b5VaAZLcL1Br7x9LKlwNje+Nm4Q9d++iT6OUzwpQpTkBNgHYfLbPPMqQUy
         iUVGX/3TRSx/ShPCuMSi7Co+ADnWkUZZkcBXNNbkRGuPTWDB/LJ3k5ekNqk3LXz9xe+i
         kvATtmwThilrA0vqiRRbglBlA1wlP4rWvRwTJ3NSp8LsKle1TAX9R8i5sXbM/5kKG7xr
         QpfCY7rnRBest5+aP2gb0wCSMCMOBYlacA+rlWDphYts1Us5q6JPYNVOPWM/6TeDsER1
         TXR2l4FXjr2Ss5la+gTz596BooTgAn+MNpQFktFXYe1YOlCd2qMXp9mbaHOCTEIkoj8C
         YshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W9+v/xUPTt3A0iA2Dk+Y5cuoAhjim6oQMYqIfaI0TIA=;
        b=gI8nTE978v3ME5PX2Ox3DVAw19f1didnjskWQXBCvh+uDmXcWRqtuBrPyR/KtV4K1s
         FAIanx5m7h4zIeltPquaJvYkP36P1Qi3e+/d7fU9v5hlDqCVkp8YVeVMij0i68RxUng9
         UKrWHM4cM/RbZOXNgkMMOWntItaWQUtAvYIWk0hG9GZ3fHgyDjsKAE/4x+Lxbi1bTxmJ
         +dvhsOeVc3kBTezWsGEzIEQfL4dIfhjjnkvcKmF1IZvx178VWp6JVkoTWnQz+prbeJCf
         yanJvFRL3A9/N3PQCzVODMLoovkYieuvnOTltklrGJ1YNp5Z3wq19VT4u1ZnTbKjQWPa
         hcWA==
X-Gm-Message-State: AOAM5327fj0UuWXYzoHf0g/N5u1ljyv3Bzsi0D4HW3n2ZR9moFxPs1dk
        h1N18A7utnCrs3IS+ZS38vk8o9GPq79RXt/dwt0=
X-Google-Smtp-Source: ABdhPJwMNsUauTAvYifHE1oDEnf/8jnNd7CJzX9QfVubwbLqKFX5XtfHK6bYcOXO3l6CueZ6UXfxfacltxrr41kEh+k=
X-Received: by 2002:a17:906:e47:: with SMTP id q7mr4837722eji.279.1592347989651;
 Tue, 16 Jun 2020 15:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592338450.git.dcaratti@redhat.com> <bca565004b9fd7ff7aba09f41aa65dab2085154b.1592338450.git.dcaratti@redhat.com>
In-Reply-To: <bca565004b9fd7ff7aba09f41aa65dab2085154b.1592338450.git.dcaratti@redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jun 2020 01:52:58 +0300
Message-ID: <CA+h21hqEnC_oYDqvGhJnTszHXKdBYb_PLzd7fFx7K=if6KKQiw@mail.gmail.com>
Subject: Re: [PATCH net v3 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 23:25, Davide Caratti <dcaratti@redhat.com> wrote:
>
> assigning a dummy value of 'clock_id' to avoid cancellation of the cycle
> timer before its initialization was a temporary solution, and we still
> need to handle the case where act_gate timer parameters are changed by
> commands like the following one:
>
>  # tc action replace action gate <parameters>
>
> the fix consists in the following items:
>
> 1) remove the workaround assignment of 'clock_id', and init the list of
>    entries before the first error path after IDR atomic check/allocation
> 2) validate 'clock_id' earlier: there is no need to do IDR atomic
>    check/allocation if we know that 'clock_id' is a bad value
> 3) use a dedicated function, 'gate_setup_timer()', to ensure that the
>    timer is cancelled and re-initialized on action overwrite, and also
>    ensure we initialize the timer in the error path of tcf_gate_init()
>
> v3: improve comment in the error path of tcf_gate_init() (thanks to
>     Vladimir Oltean)
> v2: avoid 'goto' in gate_setup_timer (thanks to Cong Wang)
>
> CC: Ivan Vecera <ivecera@redhat.com>
> Fixes: a01c245438c5 ("net/sched: fix a couple of splats in the error path of tfc_gate_init()")
> Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/sched/act_gate.c | 90 +++++++++++++++++++++++++++-----------------
>  1 file changed, 55 insertions(+), 35 deletions(-)
>
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 94e560c2f81d..323ae7f6315d 100644
> --- a/net/sched/act_gate.c
> +++ b/net/sched/act_gate.c
> @@ -272,6 +272,27 @@ static int parse_gate_list(struct nlattr *list_attr,
>         return err;
>  }
>
> +static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
> +                            enum tk_offsets tko, s32 clockid,
> +                            bool do_init)
> +{
> +       if (!do_init) {
> +               if (basetime == gact->param.tcfg_basetime &&
> +                   tko == gact->tk_offset &&
> +                   clockid == gact->param.tcfg_clockid)
> +                       return;
> +
> +               spin_unlock_bh(&gact->tcf_lock);
> +               hrtimer_cancel(&gact->hitimer);
> +               spin_lock_bh(&gact->tcf_lock);
> +       }
> +       gact->param.tcfg_basetime = basetime;
> +       gact->param.tcfg_clockid = clockid;
> +       gact->tk_offset = tko;
> +       hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
> +       gact->hitimer.function = gate_timer_func;
> +}
> +
>  static int tcf_gate_init(struct net *net, struct nlattr *nla,
>                          struct nlattr *est, struct tc_action **a,
>                          int ovr, int bind, bool rtnl_held,
> @@ -303,6 +324,27 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>         if (!tb[TCA_GATE_PARMS])
>                 return -EINVAL;
>
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
> +                       return -EINVAL;
> +               }
> +       }
> +
>         parm = nla_data(tb[TCA_GATE_PARMS]);
>         index = parm->index;
>
> @@ -326,10 +368,6 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>                 tcf_idr_release(*a, bind);
>                 return -EEXIST;
>         }
> -       if (ret == ACT_P_CREATED) {
> -               to_gate(*a)->param.tcfg_clockid = -1;
> -               INIT_LIST_HEAD(&(to_gate(*a)->param.entries));
> -       }
>
>         if (tb[TCA_GATE_PRIORITY])
>                 prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
> @@ -340,33 +378,14 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>         if (tb[TCA_GATE_FLAGS])
>                 gflags = nla_get_u32(tb[TCA_GATE_FLAGS]);
>
> -       if (tb[TCA_GATE_CLOCKID]) {
> -               clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
> -               switch (clockid) {
> -               case CLOCK_REALTIME:
> -                       tk_offset = TK_OFFS_REAL;
> -                       break;
> -               case CLOCK_MONOTONIC:
> -                       tk_offset = TK_OFFS_MAX;
> -                       break;
> -               case CLOCK_BOOTTIME:
> -                       tk_offset = TK_OFFS_BOOT;
> -                       break;
> -               case CLOCK_TAI:
> -                       tk_offset = TK_OFFS_TAI;
> -                       break;
> -               default:
> -                       NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
> -                       goto release_idr;
> -               }
> -       }
> +       gact = to_gate(*a);
> +       if (ret == ACT_P_CREATED)
> +               INIT_LIST_HEAD(&gact->param.entries);
>
>         err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
>         if (err < 0)
>                 goto release_idr;
>
> -       gact = to_gate(*a);
> -
>         spin_lock_bh(&gact->tcf_lock);
>         p = &gact->param;
>
> @@ -397,14 +416,10 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>                 p->tcfg_cycletime_ext =
>                         nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
>
> +       gate_setup_timer(gact, basetime, tk_offset, clockid,
> +                        ret == ACT_P_CREATED);
>         p->tcfg_priority = prio;
> -       p->tcfg_basetime = basetime;
> -       p->tcfg_clockid = clockid;
>         p->tcfg_flags = gflags;
> -
> -       gact->tk_offset = tk_offset;
> -       hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
> -       gact->hitimer.function = gate_timer_func;
>         gate_get_start_time(gact, &start);
>
>         gact->current_close_time = start;
> @@ -433,6 +448,13 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>         if (goto_ch)
>                 tcf_chain_put_by_act(goto_ch);
>  release_idr:
> +       /* action is not inserted in any list: it's safe to init hitimer
> +        * without taking tcf_lock.
> +        */
> +       if (ret == ACT_P_CREATED)
> +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> +                                gact->tk_offset, gact->param.tcfg_clockid,
> +                                true);
>         tcf_idr_release(*a, bind);
>         return err;
>  }
> @@ -443,9 +465,7 @@ static void tcf_gate_cleanup(struct tc_action *a)
>         struct tcf_gate_params *p;
>
>         p = &gact->param;
> -       if (p->tcfg_clockid != -1)
> -               hrtimer_cancel(&gact->hitimer);
> -
> +       hrtimer_cancel(&gact->hitimer);
>         release_entry_list(&p->entries);
>  }
>
> --
> 2.26.2
>
