Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03E01FA31C
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 23:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgFOV4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 17:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgFOV4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 17:56:02 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706B2C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:56:02 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id y6so7403318edi.3
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 14:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PN81bWnj5IHjcIQHDQ+ucmT6rCxKmzZVxxr303wIVpg=;
        b=tz2WZA5oL45VIGGEMoVtlG3y0ZpWjIOBor3y8xr5FdPf6nRBIEi6MdX55pohDnD3Rp
         YzedziNY+6qebjjK36lrHVyCDc2PLsx5qEUaMVoTbRN6HfYZCPXTRKsW+pLYwWtRaHnr
         DCRXtkR0HsXifBJDccNIsR0yjxg1JrpMj/liGzQUP1Tv/NE5tzLkvL2S8aNqFTpWJlZF
         RVeSu+SB3chDzEWbcE4f/Kei9QMbjCYXXBbFm4haQJDsNdNnmdqB2AGzLTvf4yddVk5C
         CpWbQORghPbKJH2fREIDIBiM8NjQmBdR7uX7E4fkNcqJQ4fOZSN5emCgELOqGKmtLKxw
         mv3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PN81bWnj5IHjcIQHDQ+ucmT6rCxKmzZVxxr303wIVpg=;
        b=BJgB9k5ZGmjMddEn+XN0f5R8DH8kEU/s/Jph1HYWgEsY1XM9k3uLRfs89/XuZlCFmC
         JHEqb/LwtEAU0CUXQQTqzzg280nnLxx9pf60XJjiXWRm0iGPaVzkQH+YJLofqaG9lXcj
         ZUygoUCbUasUmWAZJTP9uFKpyMXzexOhBH2kl7jQ8Uhk1eUSL7ogQ0dc9kbp38/lSMjq
         vWrkXIC9kZZPLRctR8vxCoGWhCx9VC0zG0w3W3AXpjyK+l/ptYDQqBrfAz70D+DcWF6w
         2DY1Ow2E97j0449n/ZadzvKoQSB9wMtazGD3ZWJ8ne+D41T77oV2S8OM6V8r+OKmVtLU
         06fA==
X-Gm-Message-State: AOAM533W4d4d/Wf+qJQ41YFwHbiJ+KKh54fzKn8a9Dsj52L8gNPrQkp1
        IblnZCX5fNVdv60zZr9TMuOR+8aBvq0TNBA3MZ8=
X-Google-Smtp-Source: ABdhPJzMlecpw6hiHeIA7x0KS0tkDklpyeWTcC40ppwZN9atSgWq6m+LSLjIOW1AlDIgFyyVwKSe8BPl3tqF269zrIw=
X-Received: by 2002:aa7:dc50:: with SMTP id g16mr26634707edu.318.1592258161085;
 Mon, 15 Jun 2020 14:56:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592247564.git.dcaratti@redhat.com> <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
In-Reply-To: <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 16 Jun 2020 00:55:50 +0300
Message-ID: <CA+h21ho1x1-N+HyFXcy+pqdWcQioFWgRs0C+1h+kn6w8zHVUwQ@mail.gmail.com>
Subject: Re: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the
 periodic timer
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Jun 2020 at 22:33, Davide Caratti <dcaratti@redhat.com> wrote:
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
> v2: avoid 'goto' in gate_setup_timer (thanks to Cong Wang)
>

The change log is put under the 3 '---' characters for a reason: it is
relevant only to reviewers, and git automatically trims it when
applying the patch. The way it is now, the commit message would
contain this line about "v2 ...".

> CC: Ivan Vecera <ivecera@redhat.com>
> Fixes: a01c245438c5 ("net/sched: fix a couple of splats in the error path of tfc_gate_init()")
> Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  net/sched/act_gate.c | 88 ++++++++++++++++++++++++++------------------
>  1 file changed, 53 insertions(+), 35 deletions(-)
>
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 6775ccf355b0..3c529a4bcca5 100644
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

I think it's horrible to do this just to get out of atomic context.
What if you split the "replace" functionality of gate_setup_timer into
a separate gate_cancel_timer function, which you could call earlier
(before taking the spin lock)? That change would look like this:

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 3c529a4bcca5..47c625a0e70c 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -273,19 +273,8 @@ static int parse_gate_list(struct nlattr *list_attr,
 }

 static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
-                 enum tk_offsets tko, s32 clockid,
-                 bool do_init)
+                 enum tk_offsets tko, s32 clockid)
 {
-    if (!do_init) {
-        if (basetime == gact->param.tcfg_basetime &&
-            tko == gact->tk_offset &&
-            clockid == gact->param.tcfg_clockid)
-            return;
-
-        spin_unlock_bh(&gact->tcf_lock);
-        hrtimer_cancel(&gact->hitimer);
-        spin_lock_bh(&gact->tcf_lock);
-    }
     gact->param.tcfg_basetime = basetime;
     gact->param.tcfg_clockid = clockid;
     gact->tk_offset = tko;
@@ -293,6 +282,17 @@ static void gate_setup_timer(struct tcf_gate
*gact, u64 basetime,
     gact->hitimer.function = gate_timer_func;
 }

+static void gate_cancel_timer(struct tcf_gate *gact, u64 basetime,
+                  enum tk_offsets tko, s32 clockid)
+{
+    if (basetime == gact->param.tcfg_basetime &&
+        tko == gact->tk_offset &&
+        clockid == gact->param.tcfg_clockid)
+        return;
+
+    hrtimer_cancel(&gact->hitimer);
+}
+
 static int tcf_gate_init(struct net *net, struct nlattr *nla,
              struct nlattr *est, struct tc_action **a,
              int ovr, int bind, bool rtnl_held,
@@ -381,6 +381,8 @@ static int tcf_gate_init(struct net *net, struct
nlattr *nla,
     gact = to_gate(*a);
     if (ret == ACT_P_CREATED)
         INIT_LIST_HEAD(&gact->param.entries);
+    else
+        gate_cancel_timer(gact, basetime, tk_offset, clockid);

     err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
     if (err < 0)
@@ -416,8 +418,7 @@ static int tcf_gate_init(struct net *net, struct
nlattr *nla,
         p->tcfg_cycletime_ext =
             nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);

-    gate_setup_timer(gact, basetime, tk_offset, clockid,
-             ret == ACT_P_CREATED);
+    gate_setup_timer(gact, basetime, tk_offset, clockid);
     p->tcfg_priority = prio;
     p->tcfg_flags = gflags;
     gate_get_start_time(gact, &start);
@@ -451,8 +452,7 @@ static int tcf_gate_init(struct net *net, struct
nlattr *nla,
     /* action is not in: hitimer can be inited without taking tcf_lock */
     if (ret == ACT_P_CREATED)
         gate_setup_timer(gact, gact->param.tcfg_basetime,
-                 gact->tk_offset, gact->param.tcfg_clockid,
-                 true);
+                 gact->tk_offset, gact->param.tcfg_clockid);
     tcf_idr_release(*a, bind);
     return err;
 }


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
> @@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
>         if (goto_ch)
>                 tcf_chain_put_by_act(goto_ch);
>  release_idr:
> +       /* action is not in: hitimer can be inited without taking tcf_lock */
> +       if (ret == ACT_P_CREATED)
> +               gate_setup_timer(gact, gact->param.tcfg_basetime,
> +                                gact->tk_offset, gact->param.tcfg_clockid,
> +                                true);
>         tcf_idr_release(*a, bind);
>         return err;
>  }
> @@ -443,9 +463,7 @@ static void tcf_gate_cleanup(struct tc_action *a)
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

Thanks,
-Vladimir
