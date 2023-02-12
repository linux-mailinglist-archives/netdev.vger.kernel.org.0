Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DACB6937E4
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBLPOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 10:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBLPOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 10:14:43 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3131026D
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:14:41 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id 139so10191347ybe.3
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 07:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vwDZ2PZ1TeRfM6Eht6/PakX2NCuZbGx51K9QMfaXBec=;
        b=M5DDPHjQt0NCkvQuoaMfO7BVBoZmmeSfG1F2tnBdLxweC06usevSWxfhfVcLeSJ1hs
         OfSSpyVRk+dgc7r1/aSeIFKqUCaTU7f17HegqDhTxYnBhGr6OUmnJdIuEatAubdGcnpc
         eQ8QTccANWKQFP9SbeDUXokKIg9ZoUGnbDtk4PCB8XdqtMzRRRHrMr9B6GawYrPTwkqn
         ekk5DKMUgR/a7M6QJKC3p6K2SQneFDunA2/wMDNOF2yaPazfVaVpD/Q4IEwGG3y00jnW
         184qqZv6mvhAnQscLbv016NK4UCaqVGH+9D34fEHNty2zkocY/0AOTw7A0SQj/8RYITC
         cZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vwDZ2PZ1TeRfM6Eht6/PakX2NCuZbGx51K9QMfaXBec=;
        b=8GXoExkwLvzeUpoaibaBCxKC0chI8eylcJXl8ILRxaBbePGR0HtPf9myL2tAfIID18
         r7gNtj9cgVCRSZY+mH/DAMdRa3nOtoK9VbGDMa2c7iLLBoj+yBxzmLC6SXqc92b9AsvP
         driLsapDEImgGcRySH84fssP8G7wpkJG6zV6jG/NrUDDCA+70XqjL+H03Z9mD+VmZXBV
         qPouIoXGlEOJpRcbzz5jgiEkkyqQdqoKYve3m16nU32/nHLgiWvbfP2+H3XtdZW9pBFT
         zwBfJnneOrxeHPO0XB5fp8DKpdHrnUtr4+O9nSfFfir9h+gkCkVjhvgJJYxWMEC+/Ihv
         TafA==
X-Gm-Message-State: AO0yUKWpA8epGQ2xvPlbSsX23/7an051rVnYurCuNGYydlA/4ItQbVS8
        e+XglWODt/RBhgXN/8BngMMSo/EA1Lq2sKS27CleeQ==
X-Google-Smtp-Source: AK7set+VNK1vow6l8vXgk3mbPdnbDu9foWdByTtfkhA4zkxEUsy3xnGFvw66Z84q9LdAKiYJYRYZUaNO31Ahkvkfyfo=
X-Received: by 2002:a05:6902:504:b0:927:b32c:eac3 with SMTP id
 x4-20020a056902050400b00927b32ceac3mr6271ybs.65.1676214881139; Sun, 12 Feb
 2023 07:14:41 -0800 (PST)
MIME-Version: 1.0
References: <20230212132520.12571-1-ozsh@nvidia.com> <20230212132520.12571-5-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-5-ozsh@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 10:14:30 -0500
Message-ID: <CAM0EoM=ewhz5UBZQXco-PDgDkxGFcKRtSQZa1sYN4APkTgt94A@mail.gmail.com>
Subject: Re: [PATCH net-next v4 4/9] net/sched: introduce flow_offload action cookie
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
> Currently a hardware action is uniquely identified by the <id, hw_index>
> tuple. However, the id is set by the flow_act_setup callback and tc core
> cannot enforce this, and it is possible that a future change could break
> this. In addition, <id, hw_index> are not unique across network namespaces.
>
> Uniquely identify the action by setting an action cookie by the tc core.
> Use the unique action cookie to query the action's hardware stats.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

LGTM.
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  include/net/flow_offload.h | 2 ++
>  net/sched/act_api.c        | 1 +
>  net/sched/cls_api.c        | 1 +
>  3 files changed, 4 insertions(+)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 0400a0ac8a29..d177bf5f0e1a 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
>  struct flow_action_entry {
>         enum flow_action_id             id;
>         u32                             hw_index;
> +       unsigned long                   act_cookie;
>         enum flow_action_hw_stats       hw_stats;
>         action_destr                    destructor;
>         void                            *destructor_priv;
> @@ -610,6 +611,7 @@ struct flow_offload_action {
>         enum offload_act_command  command;
>         enum flow_action_id id;
>         u32 index;
> +       unsigned long cookie;
>         struct flow_stats stats;
>         struct flow_action action;
>  };
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index f4fa6d7340f8..917827199102 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -192,6 +192,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
>         fl_action->extack = extack;
>         fl_action->command = cmd;
>         fl_action->index = act->tcfa_index;
> +       fl_action->cookie = (unsigned long)act;
>
>         if (act->ops->offload_act_setup) {
>                 spin_lock_bh(&act->tcfa_lock);
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 5b4a95e8a1ee..bfabc9c95fa9 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3577,6 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
>                 for (k = 0; k < index ; k++) {
>                         entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
>                         entry[k].hw_index = act->tcfa_index;
> +                       entry[k].act_cookie = (unsigned long)act;
>                 }
>
>                 j += index;
> --
> 1.8.3.1
>
