Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2E034F811
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 06:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhCaElF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 00:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhCaEk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 00:40:57 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F949C061574;
        Tue, 30 Mar 2021 21:40:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id v10so8304055pfn.5;
        Tue, 30 Mar 2021 21:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X6eY81cRt6EiGMhoMyYvfGPdOh1xN5EvDeFMwXUiigg=;
        b=BBqAgqWos6JCoxi8NNnsgva5ECiAX69VIkMl5jiW/l7ozMFZTTfrnqLI6TwSWXp2+N
         mdm2LZnmmaEoQHB6b4HSWAKIbvJOKNx7zyLReQEb8XA3VCvP0TvIar6/zCu43yjG+oLA
         S+IDkjkPSZCLzzNOozz7m73F7A3LIq9tSyZtivj/kmd4+rYXlViQUi1edyDeGDIPvGZ0
         9/Kau/4W64XM5FyAMhwIq9PIP5fdgtLmBtLFUsvhiOtOc744ceINwhYQpHjjPKrKrToP
         YFcfgdW3hhh/I51eljcBLU/qtxhh+pGCMC41OVz3kpysvc86Qyjm1jbpR/Sf2XvbzGKl
         WTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X6eY81cRt6EiGMhoMyYvfGPdOh1xN5EvDeFMwXUiigg=;
        b=MeM/x/B7E5ucz0D6fyzxtl+zSAoxyPzLwSfjRaWsCwC7WlT7TSuyDGTTAPGTzNTuBV
         NA9QQS0LLrj8JcooPxlhBsPkNXZqiPwDyQko/XVP8x6ImmhIsG/PEI1/ITq1uw56jysW
         skDjNLSSD9/+Qx3tTX4q7062NL7U0mLqp9DxhdjLJgdw664OECt5eVHYFnBDR+zWm6PR
         FT6M1NaEAYlZwM0amWjfvts8QiMzlfud3su0XhQYvVYSRlg2CP/zNRhTO8ecyaBpfbks
         cBz7Tfw5eqpI0VNSOsrkRjly7DJHvm0llnIDZG1lPRtplVUvzSeO/gsFDLc5Qm8kRXJ6
         qiQA==
X-Gm-Message-State: AOAM533zXNE1gud/bd2ZZpwWabgNu9Mmo5wdeR3Jl7mAw3HdWk8R4MXh
        k6ijtLcni/xMP2EJsPbu4C+lgzClLO/+vcegbec=
X-Google-Smtp-Source: ABdhPJxjUkJrHAzAD1t1NE7lY5hZwlE74WTvgqCV93EN+fBjD4cmoKfoMryJJKr19UPaJkb0jt03IIbw/iBsCanJEus=
X-Received: by 2002:a63:6a41:: with SMTP id f62mr1402263pgc.428.1617165656183;
 Tue, 30 Mar 2021 21:40:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210329225322.143135-1-memxor@gmail.com>
In-Reply-To: <20210329225322.143135-1-memxor@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Mar 2021 21:40:45 -0700
Message-ID: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] net: sched: bump refcount for new action in ACT
 replace mode
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 3:55 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index b919826939e0..43cceb924976 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
>         if (err != ACT_P_CREATED)
>                 module_put(a_o->owner);
>
> +       if (!bind && ovr && err == ACT_P_CREATED)
> +               refcount_set(&a->tcfa_refcnt, 2);
> +

Hmm, if we set the refcnt to 2 here, how could tcf_action_destroy()
destroy them when we rollback from a failure in the middle of the loop
in tcf_action_init()?

Thanks.
