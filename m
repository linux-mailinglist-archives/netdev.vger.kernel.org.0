Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0856A0D41
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233850AbjBWPof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWPoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:44:34 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565AB5507A
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:44:33 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536bf92b55cso194824427b3.12
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 07:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cMdLu+X1lwwCcK1w4Ao4S49761LN/GfaTIdj6Pj5kW4=;
        b=YYJjjOZMYrG9LyyuXMsxNMmETReBuS/PhAQ6Vayapfg8mRUa/8ygcc/pLmLa6nPADi
         xNQuPUD3oFq/ztK9N2Nur08W/zWV+bIhMd2e66DaogQb/A8tIaIikUBauXlm6+qGMDCx
         5v2g6UFHcM6lsQCup+hfJvD33W4RVvvnkAn/e+IoL1MXdvoU7D8k/f9Jnm5Bp2v2Kimg
         NlQHl+nVQWkHvP93Ib8tzTGAKpbwb5QfIuiuWTOgk3Yf6KCvtuQvv8IgHlDFssE3WD4+
         83r5O6OuEyuEPKFg2Vzhs7c4zLO+oP0ij+UzyiLrSGQatIww8N20MTd7cWGElBVKJZPM
         7fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cMdLu+X1lwwCcK1w4Ao4S49761LN/GfaTIdj6Pj5kW4=;
        b=snGa1IkljOq7d4qfDjQL2R6OaW5/W1h5z3eZ/4NaiMunyxiRim5LsUBfkFEKcDIjMo
         /Oxcb4Uuu2fwVhfGCYohL2WD946bmoXNvN6mdfFeWfuuG6VS7CYq0c8r/+HOi/ERQgue
         UbLmOGj4UFsUjXy4b14L3XA78hKXcyaB5PpwuXia+LxIeZZCbFBYVtnbIW5e5gVwS/9W
         +pCAKMkARa0LnidANn17Z48oIaGX/S1wDYIez/jWkl1AwBfg+b0AV2SedDObogVvEOfr
         Fl6BfTw7fcJh9RnyZxcSJ3Fiqq0xqFfH8GFttoQ9Y6nXLk5cT6lLXoFTwjFhax5t5C5l
         K2aw==
X-Gm-Message-State: AO0yUKWfJqKVPjmmVxQr7CSZpaEJ5vtF2mv9Q6OLY1RHEsnGKGpO+pBx
        XvSZ8+hA5e/Hobx5fSqEw9FUiVXvQvMjeOygiEuvNQ==
X-Google-Smtp-Source: AK7set/SJPQaF7qBMNoM3d8lVj1sJf5HmM8QtnqHYHLhfW71WAX5nkEpFSQfO1mAA20y/wLdCeGec37P84LAbQrGZPc=
X-Received: by 2002:a5b:403:0:b0:919:6843:a74c with SMTP id
 m3-20020a5b0403000000b009196843a74cmr2242813ybp.12.1677167072526; Thu, 23 Feb
 2023 07:44:32 -0800 (PST)
MIME-Version: 1.0
References: <20230223141639.13491-1-pctammela@mojatatu.com>
In-Reply-To: <20230223141639.13491-1-pctammela@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 23 Feb 2023 10:44:21 -0500
Message-ID: <CAM0EoMkrTANy8gkohy1wCnP5CKEWuec816DmpdV4LzF88jG7sQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: act_connmark: handle errno on tcf_idr_check_alloc
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, error27@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 9:17 AM Pedro Tammela <pctammela@mojatatu.com> wrote:
>
> Smatch reports that 'ci' can be used uninitialized.
> The current code ignores errno coming from tcf_idr_check_alloc, which
> will lead to the incorrect usage of 'ci'. Handle the errno as it should.
>
> Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/act_connmark.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/net/sched/act_connmark.c b/net/sched/act_connmark.c
> index 8dabfb52ea3d..cf4086a9e3c0 100644
> --- a/net/sched/act_connmark.c
> +++ b/net/sched/act_connmark.c
> @@ -125,6 +125,7 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>         if (!nparms)
>                 return -ENOMEM;
>
> +       ci = to_connmark(*a);
>         parm = nla_data(tb[TCA_CONNMARK_PARMS]);
>         index = parm->index;
>         ret = tcf_idr_check_alloc(tn, &index, a, bind);
> @@ -137,14 +138,11 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>                         goto out_free;
>                 }
>
> -               ci = to_connmark(*a);
> -
>                 nparms->net = net;
>                 nparms->zone = parm->zone;
>
>                 ret = ACT_P_CREATED;
>         } else if (ret > 0) {
> -               ci = to_connmark(*a);
>                 if (bind) {
>                         err = 0;
>                         goto out_free;
> @@ -158,6 +156,9 @@ static int tcf_connmark_init(struct net *net, struct nlattr *nla,
>                 nparms->zone = parm->zone;
>
>                 ret = 0;
> +       } else {
> +               err = ret;
> +               goto out_free;
>         }
>
>         err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
> --
> 2.34.1
>
