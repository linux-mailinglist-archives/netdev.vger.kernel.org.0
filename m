Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D712B5A52C0
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiH2RJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiH2RIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:08:45 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B81057E23
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 10:08:19 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-33dce2d4bc8so211970847b3.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 10:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=xICyMVVdCsY5/fofBo/xR4lYqmLE701ZtHc0T6bkZNY=;
        b=f2mnCMTUX8MUcwoig9BX5a/hSjp+haWVlmf/zgLb1ELSvOm4uiJPmBTdc9u7mpkywY
         tRpcIfusLS82Y1a6vcFzbfzXwHeCu6PMEvaOgzBsxlccY1llfu5kN9XGPU0vpG3hhdnv
         0yvXSMaUSu4L0cByn9rY8ZqMIk4O/F7PdjtWDnW3XyQouMtnpCqMGaMuRwCd39znHM2y
         208DPvXLnpvYdHqfW5k8BN24f9Us8BGbwVErhbN9a3a4ELCIVR8T/EFvlrh1+787gf3/
         FEr018E1RH9SPJIVg+pAs9j3RV+dyC0szpV28VCjQ5AbGBKiiFRGvieGmRgRr/I0Ue5r
         ip4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=xICyMVVdCsY5/fofBo/xR4lYqmLE701ZtHc0T6bkZNY=;
        b=taOhxfldAigWeE2NBLjAw/G9S2Nxg0pFi1amwyQgCyF2Jw72kWxo4bqeT6r7ksy2oQ
         lJWY+Nt0qeDhAvMb2u6xlKnvKOFaFs1Rt3FNxurUyFOfL1OXiZdhmxwt7x8KvCuT810k
         N/pT4TdQ/Rc/VJuEPO/nBZuXeLZrGXvZ/mFai3t6j+BgE01AjL6rJrh+Phxd855hoUIE
         mv2clXzBL9xuJa9CUm1wKviJOwyz5UE0F8GTmA5GV+HPU17ui6HvTjsR1VPBQzv1lTSx
         TVMQvra1MI0xydlqb4Y/k5/nUu/ZeecmtazPdRH/ZTB7XEeVdg3PXGbaCLKzKu9U0ubR
         89/Q==
X-Gm-Message-State: ACgBeo1tuGuiqAtpX1NVjSYkoLSW/4KVYdUkXoRL8UcD3pBli6qpIzDb
        vOJYhUXKyZG0A4vDEoCjn5MqzjP34RUSd+KG8HH33g==
X-Google-Smtp-Source: AA6agR5yrPfoLQlXKTsr14uC5F5xcL/3RWe+3GyqlPJK4pfC0blNh/6a1jD6exelzaWA170WinDrqAKgH/iopkF9eN0=
X-Received: by 2002:a25:7cc6:0:b0:67a:6a2e:3d42 with SMTP id
 x189-20020a257cc6000000b0067a6a2e3d42mr9035859ybc.231.1661792898498; Mon, 29
 Aug 2022 10:08:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220829081704.255235-1-shaozhengchao@huawei.com> <20220829081704.255235-2-shaozhengchao@huawei.com>
In-Reply-To: <20220829081704.255235-2-shaozhengchao@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Aug 2022 10:08:07 -0700
Message-ID: <CANn89iLqXB-O7AP5qf+gGtK48fgYYxpciCyZa76jJNac9Bq1aQ@mail.gmail.com>
Subject: Re: [PATCH net-next,v2 1/3] net: sched: choke: remove unused
 variables in struct choke_sched_data
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, weiyongjun1@huawei.com,
        YueHaibing <yuehaibing@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 1:14 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> The variable "other" in the struct choke_sched_data is not used. Remove it.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
> v1: qdisc_drop() already counts drops, unnecessary to use "other" to duplicate the same information.
> ---
>  include/uapi/linux/pkt_sched.h | 1 -
>  net/sched/sch_choke.c          | 2 --
>  2 files changed, 3 deletions(-)
>
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index f292b467b27f..32d49447cc7a 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -396,7 +396,6 @@ struct tc_choke_qopt {
>  struct tc_choke_xstats {
>         __u32           early;          /* Early drops */
>         __u32           pdrop;          /* Drops due to queue limits */
> -       __u32           other;          /* Drops due to drop() calls */

You can not remove a field in UAPI.

>         __u32           marked;         /* Marked packets */
>         __u32           matched;        /* Drops due to flow match */
>  };
> diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
> index 25d2daaa8122..3ac3e5c80b6f 100644
> --- a/net/sched/sch_choke.c
> +++ b/net/sched/sch_choke.c
> @@ -60,7 +60,6 @@ struct choke_sched_data {
>                 u32     forced_drop;    /* Forced drops, qavg > max_thresh */
>                 u32     forced_mark;    /* Forced marks, qavg > max_thresh */
>                 u32     pdrop;          /* Drops due to queue limits */
> -               u32     other;          /* Drops due to drop() calls */
>                 u32     matched;        /* Drops to flow match */
>         } stats;
>
> @@ -464,7 +463,6 @@ static int choke_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
>                 .early  = q->stats.prob_drop + q->stats.forced_drop,
>                 .marked = q->stats.prob_mark + q->stats.forced_mark,
>                 .pdrop  = q->stats.pdrop,
> -               .other  = q->stats.other,
>                 .matched = q->stats.matched,
>         };
>
> --
> 2.17.1
>
