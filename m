Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF23F6937D6
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 15:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjBLO6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 09:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBLO6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 09:58:22 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22458FF1B
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 06:58:20 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id 81so1089040ybp.5
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 06:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j2W3RDmfVzdYC6knFyv68XFnHgsCGdtUUVN7lLhOJtI=;
        b=k0HGTEJyrIkyeXkTaLpEfd7HaD2OmFwxNtThBIW5SGbZ5qD+5kxbhXuNGEurS4dmUV
         FTBd9hcrI+WjP38xeaTH0mwEHfwBTktN+SvsGVZBFa5j/dxMvxEw+pkGbIOlB1DSKQBe
         uLQSun74tnScJZObQVVUuPUkrVn6YLf+k+paKZuUJjXVmTptkbi0RRY0Xc80SKOXEeMK
         YZLvTO+6iIN4VpwSXNBugsnDGtxOqMex+J4TLRV+sl9baEr26EBUl0O3PXMl7cm8p9ch
         YSkFykyLuz/HT++4BX+4y6iXIPdtawY6iL8pDXZ/E5qm+WGGGu71J7QAOQ07+L32SUbJ
         NmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j2W3RDmfVzdYC6knFyv68XFnHgsCGdtUUVN7lLhOJtI=;
        b=mr0Nm//iCTAlMx5biaKKk1TRel47NWiU3mKzf/kg0s6f0Ogdv2Z+pXT9QEwHnHARJP
         GGgGtbGT0JtctVslfY+xCFMr23cfXFN4FvNJaAJRvLRv9D94ADIz/rOHbCfz1AiYTRpn
         3CYGVs6ilJBz1nDFEFijKfDAlHM/RMgqZd08qtG+yfGvMHA1ZZ52PAkU8Qr8UBn5Zr3f
         lyUj7S/kEx1VLfjw9TxG8p12KAtZClbQ2jjh/fcsJXmrsMo3QZBkEqQ9t5adchcXdDnD
         eqWndJmKB/p+Qo12vmsCdMhaCteJ8vdwzWSamY22BZvG/0+Cjjr4UoRIFbfj0s1Mn5uU
         5Hvw==
X-Gm-Message-State: AO0yUKXiqExutZ/AUJbbITR0TUo9rCWkvE6Un4Ec581HyahrJxWgTipk
        LZZ8V7KWMZTGjUxN+/KThZLRICKLi4NoC8iZQh3HxuKVpwKYjQ==
X-Google-Smtp-Source: AK7set9ukt+7VTLb/tUBXuisGCgMxyYhFEu7EhHf5RKx4Ca6K4cgrby3q2/4r+QxGbNMZNV3c69Bjn7PY5tMR9Np3ok=
X-Received: by 2002:a05:6902:504:b0:927:b32c:eac3 with SMTP id
 x4-20020a056902050400b00927b32ceac3mr3069ybs.65.1676213898848; Sun, 12 Feb
 2023 06:58:18 -0800 (PST)
MIME-Version: 1.0
References: <20230212132520.12571-1-ozsh@nvidia.com> <20230212132520.12571-2-ozsh@nvidia.com>
In-Reply-To: <20230212132520.12571-2-ozsh@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 12 Feb 2023 09:58:07 -0500
Message-ID: <CAM0EoMm-EQDw8AZUQyiHK=XJkhamyqfy0f6wYYkuzF22n9N7FQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/9] net/sched: optimize action stats api calls
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

On Sun, Feb 12, 2023 at 8:25 AM Oz Shlomo <ozsh@nvidia.com> wrote:
>
> Currently the hw action stats update is called from tcf_exts_hw_stats_update,
> when a tc filter is dumped, and from tcf_action_copy_stats, when a hw
> action is dumped.
> However, the tcf_action_copy_stats is also called from tcf_action_dump.
> As such, the hw action stats update cb is called 3 times for every
> tc flower filter dump.
>
> Move the tc action hw stats update from tcf_action_copy_stats to
> tcf_dump_walker to update the hw action stats when tc action is dumped.
>
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

This patch is trivial, but if an ACK is needed, then:

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/act_api.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index cd09ef49df22..f4fa6d7340f8 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -539,6 +539,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
>                                (unsigned long)p->tcfa_tm.lastuse))
>                         continue;
>
> +               tcf_action_update_hw_stats(p);
> +
>                 nest = nla_nest_start_noflag(skb, n_i);
>                 if (!nest) {
>                         index--;
> @@ -1539,9 +1541,6 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
>         if (p == NULL)
>                 goto errout;
>
> -       /* update hw stats for this action */
> -       tcf_action_update_hw_stats(p);
> -
>         /* compat_mode being true specifies a call that is supposed
>          * to add additional backward compatibility statistic TLVs.
>          */
> --
> 1.8.3.1
>
