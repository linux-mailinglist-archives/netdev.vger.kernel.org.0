Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA831496B6
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAYQwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:52:13 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:32842 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 11:52:13 -0500
Received: by mail-ed1-f65.google.com with SMTP id r21so6279829edq.0
        for <netdev@vger.kernel.org>; Sat, 25 Jan 2020 08:52:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVjmHsvxbZknMu9OmgHVwi1Zue8kqkJZ8azPsQvxLQI=;
        b=TKXjVQpBcCoxskwUf7AgH5ofcnpiA6TutJPMR9lTOJy/Bql5p5QMUx18YF9YSRn9vw
         yuD8537lbAgD77q1yMWu2f/bytKiBeg5M8VRIxvs34VoefICuIxoh/dnG9ZYTikBjwqa
         yEgzqgmxjrnBAHSaAl4gKJiEyYSyZhSb97MVJomilx82p4chA5OuExudVWQGXcZ6BXfU
         y7sItFmhHGmnzr29AdilKDfOXF2k8GIH2LgozfWJA74WeXS5MwUaeho5ppdE1sgi94nY
         aEgc3EISkWqyXHzGagYpH6ZgbnJtUeOvahuK4/JROWTTthTP0UNLw2P6TlqmDsUWBaVl
         dDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVjmHsvxbZknMu9OmgHVwi1Zue8kqkJZ8azPsQvxLQI=;
        b=qze5i3Z+ujKztbiwUAkwR9lLBWc+5XWv4uKzfnmDd5CQjzE4oro52Xkih8+NSD6WVi
         f2344nvb3oUXFDBZGVUYgW7/u/GDO1jVmXJpe2j5kQWK9qlatnRzpkHy/x1LQ1wOCzAI
         lhwxiYHXI9sqwc8sIuJ8BycDmOhj5Kz09B1ZQbVQ19Tc/c60BdRzde+OWNaWiGA4beH+
         Y0DQOnoSyOnT2TapJJ191k1g0xwBsRgPAgeB1YX7BJ80F/8nrvQrW24zaeG2CQKwh7Px
         M9V/wFYZXiakPyU51qtZcm4R2/HleMYBpRdngEcSzuqxATcIDW7I5+sKR8rRP9hLlm7l
         1ucQ==
X-Gm-Message-State: APjAAAVwzg/cY93t3uvhmhZ4iejjPNmhqP1edckChPTB9c6IeL/dxlxr
        FKnW/dxT9y8zLIFh2dHR/aHzfKINuzBK5MU1zyM=
X-Google-Smtp-Source: APXvYqx11ftZqVAfC1xwEPTIwMvMlswuKiRdluOQl94TVKJCtumYiN71LAscXCFXySsAS9AtzMgeoIt1z+KZ9CpqgMg=
X-Received: by 2002:aa7:d3cb:: with SMTP id o11mr7427423edr.145.1579971130961;
 Sat, 25 Jan 2020 08:52:10 -0800 (PST)
MIME-Version: 1.0
References: <20200125005320.3353761-1-vinicius.gomes@intel.com> <20200125005320.3353761-4-vinicius.gomes@intel.com>
In-Reply-To: <20200125005320.3353761-4-vinicius.gomes@intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 25 Jan 2020 18:52:00 +0200
Message-ID: <CA+h21hr3Ej2wBUCBOYe4CU1XRpQnj047RoRVdYSg8uhFNPYqnw@mail.gmail.com>
Subject: Re: [PATCH net v1 3/3] taprio: Allow users not to specify "flags"
 when changing schedules
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Jan 2020 at 02:52, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> When any offload mode is enabled, users had to specify the
> "flags" parameter when adding a new "admin" schedule.
>
> This fix allows that parameter to be omitted when adding a new
> schedule.
>
> Also move 'taprio_flags' to a smaller scope, so we reduce the region
> where we have two variables with the similar concepts ('taprio_flags'
> and 'q->flags').
>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---

Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/sched/sch_taprio.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index dfbecb9ee2f4..65357e2ba04e 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1375,7 +1375,6 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>         struct taprio_sched *q = qdisc_priv(sch);
>         struct net_device *dev = qdisc_dev(sch);
>         struct tc_mqprio_qopt *mqprio = NULL;
> -       u32 taprio_flags = 0;
>         unsigned long flags;
>         ktime_t start;
>         int i, err;
> @@ -1389,7 +1388,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                 mqprio = nla_data(tb[TCA_TAPRIO_ATTR_PRIOMAP]);
>
>         if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
> -               taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
> +               u32 taprio_flags = nla_get_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
>
>                 if (q->flags != taprio_flags) {
>                         NL_SET_ERR_MSG_MOD(extack, "Changing 'flags' of a running schedule is not supported");
> @@ -1402,7 +1401,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                 q->flags = taprio_flags;
>         }
>
> -       err = taprio_parse_mqprio_opt(dev, mqprio, extack, taprio_flags);
> +       err = taprio_parse_mqprio_opt(dev, mqprio, extack, q->flags);
>         if (err < 0)
>                 return err;
>
> @@ -1457,7 +1456,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                                                mqprio->prio_tc_map[i]);
>         }
>
> -       if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
> +       if (FULL_OFFLOAD_IS_ENABLED(q->flags))
>                 err = taprio_enable_offload(dev, mqprio, q, new_admin, extack);
>         else
>                 err = taprio_disable_offload(dev, q, extack);
> @@ -1477,14 +1476,14 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                 q->txtime_delay = nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
>         }
>
> -       if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
> -           !FULL_OFFLOAD_IS_ENABLED(taprio_flags) &&
> +       if (!TXTIME_ASSIST_IS_ENABLED(q->flags) &&
> +           !FULL_OFFLOAD_IS_ENABLED(q->flags) &&
>             !hrtimer_active(&q->advance_timer)) {
>                 hrtimer_init(&q->advance_timer, q->clockid, HRTIMER_MODE_ABS);
>                 q->advance_timer.function = advance_sched;
>         }
>
> -       if (FULL_OFFLOAD_IS_ENABLED(taprio_flags)) {
> +       if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
>                 q->dequeue = taprio_dequeue_offload;
>                 q->peek = taprio_peek_offload;
>         } else {
> @@ -1501,7 +1500,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>                 goto unlock;
>         }
>
> -       if (TXTIME_ASSIST_IS_ENABLED(taprio_flags)) {
> +       if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
>                 setup_txtime(q, new_admin, start);
>
>                 if (!oper) {
> @@ -1528,7 +1527,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>
>                 spin_unlock_irqrestore(&q->current_entry_lock, flags);
>
> -               if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
> +               if (FULL_OFFLOAD_IS_ENABLED(q->flags))
>                         taprio_offload_config_changed(q);
>         }
>
> --
> 2.25.0
>
