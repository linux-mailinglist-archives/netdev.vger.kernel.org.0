Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43336937E2
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 16:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBLPMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 10:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBLPMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 10:12:45 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2481206B
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:12:43 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id b132so10494775ybc.12
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7wK7qv0h04Z9KyTN0Jrp5+azwprevgMfOij5+AgcdNk=;
        b=wo5QyecEVhcnTA5vUmeXr/YwQYD9WQFqr0XlGiNbrVG5tDoiQyk1DiRYMjjql6eUfV
         uqPEGgdpqVcr11c+RxN19yP/IYJf1oxu09g87G6SSSRxhgl4T6pa+Ct6wdSK1fs/B3HM
         uqMSHsMLhc+E+Ayx1DAEIzJP3sael3Fo0I5y/SU7selXDWXT+PA0++7wJylbku3cSAxx
         qxOM9aJUiMJRNnUoj56JGhYbpqQAL7ZV5zYbxwdhnOyt7iGjvpg4pGYTHgIjf0EBioHQ
         HRSP93Fppq5z0xTc8NcDsgKlb1IpneiXKXQ6DrGMP5q33C4DreCkjjPf+LzTfy7/Zle9
         6Afg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7wK7qv0h04Z9KyTN0Jrp5+azwprevgMfOij5+AgcdNk=;
        b=WOLyS0LFodYey2g0NvYNZ59falh9N+uzfbmoakFxd7TyOnhfu3jW7Uwf3LhzQHTDOA
         xvOJ+CoV9aqh+rFEkRjecd9XJbw31iPbGvxq9c9Bq5tA9bn8cCOG7qJBgDiS1iVc1Jq8
         OoPNXPdKtyY/afWDIh0qxmGb3vSrrzOTmq1pqyku+auq/Ja+xbPS/2m92u76pkfagIsa
         hAxRaCWiISBPSmsWPgueSYHQvVWxqCq9dMQqKcbdDprbQOgwKGuGcScMCOMD0SJ46hUG
         Bxm/TLKElhQP0pmjbElbLvN2CuBxixqMup2eZaRm2A443PHT6Sg7Px7M4I3ttUHaLiiz
         rSkg==
X-Gm-Message-State: AO0yUKVZ99ub/ctXkT3Psyk4n7u+rq9wfMSIqCjc1LBLWTjUh3uc8EQH
        OxSBFczAEckeT4IDFtvPreZ3/ZazECP9yrf613X6Ig==
X-Google-Smtp-Source: AK7set/OhMjSEVttGGqeQ7u8gAvJNLX+1SeKQvKRnxDlChKWaBerWl7btLr0zlaavon57KgwBJENremVDpYPDLqHiUs=
X-Received: by 2002:a25:9109:0:b0:8d0:40b4:23ac with SMTP id
 v9-20020a259109000000b008d040b423acmr1757630ybl.214.1676214763150; Sun, 12
 Feb 2023 07:12:43 -0800 (PST)
MIME-Version: 1.0
References: <20230212132520.12571-1-ozsh@nvidia.com> <20230212132520.12571-6-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-6-ozsh@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 10:12:31 -0500
Message-ID: <CAM0EoM=7EgtOWtBFM7JDfr5E8FukoNRjEVFfJawkdfhSG63h7w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 5/9] net/sched: support per action hw stats
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 12, 2023 at 8:26 AM Oz Shlomo <ozsh@nvidia.com> wrote:
>
> There are currently two mechanisms for populating hardware stats:
> 1. Using flow_offload api to query the flow's statistics.
>    The api assumes that the same stats values apply to all
>    the flow's actions.
>    This assumption breaks when action drops or jumps over following
>    actions.
> 2. Using hw_action api to query specific action stats via a driver
>    callback method. This api assures the correct action stats for
>    the offloaded action, however, it does not apply to the rest of the
>    actions in the flow's actions array.
>
> Extend the flow_offload stats callback to indicate that a per action
> stats update is required.
> Use the existing flow_offload_action api to query the action's hw stats.
> In addition, currently the tc action stats utility only updates hw actions.
> Reuse the existing action stats cb infrastructure to query any action
> stats.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

I just looked for functional equivalency and it LGTM.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
> Change log:
>
> V1 -> V2
>     - Fix static function without inline keyword in header file
>     - Rearrange flow_cls_offload members such that stats and use_act stats
>       will be on the same cache line
>     - Fall-through to flow stats when hw_stats update returns an error
>       (this aligns with current behavior).
> ---
>  include/net/flow_offload.h |  1 +
>  include/net/pkt_cls.h      | 29 +++++++++++++++++++----------
>  net/sched/act_api.c        |  8 --------
>  net/sched/cls_flower.c     |  2 +-
>  net/sched/cls_matchall.c   |  2 +-
>  5 files changed, 22 insertions(+), 20 deletions(-)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index d177bf5f0e1a..8c05455b1e34 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -594,6 +594,7 @@ struct flow_cls_common_offload {
>  struct flow_cls_offload {
>         struct flow_cls_common_offload common;
>         enum flow_cls_command command;
> +       bool use_act_stats;
>         unsigned long cookie;
>         struct flow_rule *rule;
>         struct flow_stats stats;
> diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
> index bf50829d9255..ace437c6754b 100644
> --- a/include/net/pkt_cls.h
> +++ b/include/net/pkt_cls.h
> @@ -292,9 +292,15 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>  #define tcf_act_for_each_action(i, a, actions) \
>         for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
>
> +static inline bool tc_act_in_hw(struct tc_action *act)
> +{
> +       return !!act->in_hw_count;
> +}
> +
>  static inline void
>  tcf_exts_hw_stats_update(const struct tcf_exts *exts,
> -                        struct flow_stats *stats)
> +                        struct flow_stats *stats,
> +                        bool use_act_stats)
>  {
>  #ifdef CONFIG_NET_CLS_ACT
>         int i;
> @@ -302,16 +308,18 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
>         for (i = 0; i < exts->nr_actions; i++) {
>                 struct tc_action *a = exts->actions[i];
>
> -               /* if stats from hw, just skip */
> -               if (tcf_action_update_hw_stats(a)) {
> -                       preempt_disable();
> -                       tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
> -                                               stats->lastused, true);
> -                       preempt_enable();
> -
> -                       a->used_hw_stats = stats->used_hw_stats;
> -                       a->used_hw_stats_valid = stats->used_hw_stats_valid;
> +               if (use_act_stats || tc_act_in_hw(a)) {
> +                       if (!tcf_action_update_hw_stats(a))
> +                               continue;
>                 }
> +
> +               preempt_disable();
> +               tcf_action_stats_update(a, stats->bytes, stats->pkts, stats->drops,
> +                                       stats->lastused, true);
> +               preempt_enable();
> +
> +               a->used_hw_stats = stats->used_hw_stats;
> +               a->used_hw_stats_valid = stats->used_hw_stats_valid;
>         }
>  #endif
>  }
> @@ -769,6 +777,7 @@ struct tc_cls_matchall_offload {
>         enum tc_matchall_command command;
>         struct flow_rule *rule;
>         struct flow_stats stats;
> +       bool use_act_stats;
>         unsigned long cookie;
>  };
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 917827199102..eda58b78da13 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -169,11 +169,6 @@ static bool tc_act_skip_sw(u32 flags)
>         return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
>  }
>
> -static bool tc_act_in_hw(struct tc_action *act)
> -{
> -       return !!act->in_hw_count;
> -}
> -
>  /* SKIP_HW and SKIP_SW are mutually exclusive flags. */
>  static bool tc_act_flags_valid(u32 flags)
>  {
> @@ -308,9 +303,6 @@ int tcf_action_update_hw_stats(struct tc_action *action)
>         struct flow_offload_action fl_act = {};
>         int err;
>
> -       if (!tc_act_in_hw(action))
> -               return -EOPNOTSUPP;
> -
>         err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
>         if (err)
>                 return err;
> diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
> index cb04739a13ce..885c95191ccf 100644
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -502,7 +502,7 @@ static void fl_hw_update_stats(struct tcf_proto *tp, struct cls_fl_filter *f,
>         tc_setup_cb_call(block, TC_SETUP_CLSFLOWER, &cls_flower, false,
>                          rtnl_held);
>
> -       tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats);
> +       tcf_exts_hw_stats_update(&f->exts, &cls_flower.stats, cls_flower.use_act_stats);
>  }
>
>  static void __fl_put(struct cls_fl_filter *f)
> diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
> index b3883d3d4dbd..fa3bbd187eb9 100644
> --- a/net/sched/cls_matchall.c
> +++ b/net/sched/cls_matchall.c
> @@ -331,7 +331,7 @@ static void mall_stats_hw_filter(struct tcf_proto *tp,
>
>         tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false, true);
>
> -       tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats);
> +       tcf_exts_hw_stats_update(&head->exts, &cls_mall.stats, cls_mall.use_act_stats);
>  }
>
>  static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
> --
> 1.8.3.1
>
