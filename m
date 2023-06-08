Return-Path: <netdev+bounces-9299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 921757285CF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E83AB1C21009
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:52:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3382182B8;
	Thu,  8 Jun 2023 16:52:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F6417FE9
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:52:17 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36691BE2
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:52:03 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-568f9caff33so7190667b3.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686243123; x=1688835123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ex5SxXxMZHySOL7xX/t6ob44vxnfsnMabgoOst0WIsk=;
        b=PBGgNLDPMiyBo5qps8SvwkgO1tVDbBUwnU3KRjarpbtGX3NaHyv2OeeaC5kD86Hvlk
         TW41qUaOU/eiqA8K+Ohr+u66c4Npv+b3VDanC1aqzVnkIiGVQbbjj6dixgJW510zPr82
         pv9uUZTO2BnR060CakKTKG1gktTniHRWiLiVlaYfv2N9vjiry38TJ1UnWd9Ye96EwT7c
         2zAFmw5xLRTijEA2v5p/0Iz7in4uHu48V3DUdJ+/SbSoVrsn5FGXa/aWb8X1wiIe+DH/
         EN+Kh+Oh3VYNjTPbEfHw1VKVIxO90k34fGhNuJD10QZjgHlpM7/Y1JiTfaor1UIWTBs3
         eWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686243123; x=1688835123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ex5SxXxMZHySOL7xX/t6ob44vxnfsnMabgoOst0WIsk=;
        b=lOtmY8CoGGQSfO3ZClBKkt6MT0RzrW5NuMGdAU4ktOrGwYG8GntEn6is/CIsQw1Jjj
         Wb1c4qb+V9opVc9hRNKOQq/XmIMErRff7793RO2p8sBGFmoBlWB4RmbHzpZJloK/StOF
         /qEKgvsFj/+H767GngUFEv+4+Cp7U/AMSu7PjxAei0Et/K47hVw6Bi7GfVPO2qjcaMv5
         cqOqieNAHYj3sJ4R+ZYnW9oNzPv+joEjhlipbi7U0z5pWmR7kQiIPSGqHe2wtG2khcu5
         qHWm+kDCGzjUYu0Ao8PSienSJ01tZME5qrtdEi/ORNsbWPvKM6430zYP/Ra3T6ddz/GG
         18+w==
X-Gm-Message-State: AC+VfDxLNKZ+NAikBL273pA/nN/ua08ZatWhLZ1DmyTTEQ6MS/uG+AW+
	reCSabiFbLgGTRgHx03aJ/yCKZB5Mp0im2mm1EKX9Q==
X-Google-Smtp-Source: ACHHUZ7IGQqy3F6KncI9VKP8kUGTzitXQar+yj6CWRRKDVssUENNtbJGwWXAY7zk52hQ8i52YYu9HS169xwAQuxdmaQ=
X-Received: by 2002:a0d:e8ce:0:b0:561:be2a:43f9 with SMTP id
 r197-20020a0de8ce000000b00561be2a43f9mr229448ywe.41.1686243122936; Thu, 08
 Jun 2023 09:52:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608140246.15190-1-fw@strlen.de> <20230608140246.15190-2-fw@strlen.de>
In-Reply-To: <20230608140246.15190-2-fw@strlen.de>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 12:51:51 -0400
Message-ID: <CAM0EoMk6_CMeOGG1KMjNthgUXnB-fHtz4U2Uje+aYpxXe9HuPA@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] net/sched: act_ipt: add sanity checks on table
 name and hook locations
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com, 
	davem@davemloft.net, pabeni@redhat.com, xiyou.wangcong@gmail.com, 
	jiri@resnulli.us, Simon Horman <simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 10:03=E2=80=AFAM Florian Westphal <fw@strlen.de> wro=
te:
>
> Looks like "tc" hard-codes "mangle" as the only supported table
> name, but on kernel side there are no checks.
>
> This is wrong.  Not all xtables targets are safe to call from tc.
> E.g. "nat" targets assume skb has a conntrack object assigned to it.
> Normally those get called from netfilter nat core which consults the
> nat table to obtain the address mapping.
>
> "tc" userspace either sets PRE or POSTROUTING as hook number, but there
> is no validation of this on kernel side, so update netlink policy to
> reject bogus numbers.  Some targets may assume skb_dst is set for
> input/forward hooks, so prevent those from being used.
>
> act_ipt uses the hook number in two places:
> 1. the state hook number, this is fine as-is
> 2. to set par.hook_mask
>
> The latter is a bit mask, so update the assignment to make
> xt_check_target() to the right thing.
>
> Followup patch adds required checks for the skb/packet headers before
> calling the targets evaluation function.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  v2: add Fixes tag, diff unchanged.
>
>  net/sched/act_ipt.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
>
> diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
> index 5d96ffebd40f..ea7f151e7dd2 100644
> --- a/net/sched/act_ipt.c
> +++ b/net/sched/act_ipt.c
> @@ -48,7 +48,7 @@ static int ipt_init_target(struct net *net, struct xt_e=
ntry_target *t,
>         par.entryinfo =3D &e;
>         par.target    =3D target;
>         par.targinfo  =3D t->data;
> -       par.hook_mask =3D hook;
> +       par.hook_mask =3D 1 << hook;
>         par.family    =3D NFPROTO_IPV4;
>
>         ret =3D xt_check_target(&par, t->u.target_size - sizeof(*t), 0, f=
alse);
> @@ -85,7 +85,8 @@ static void tcf_ipt_release(struct tc_action *a)
>
>  static const struct nla_policy ipt_policy[TCA_IPT_MAX + 1] =3D {
>         [TCA_IPT_TABLE] =3D { .type =3D NLA_STRING, .len =3D IFNAMSIZ },
> -       [TCA_IPT_HOOK]  =3D { .type =3D NLA_U32 },
> +       [TCA_IPT_HOOK]  =3D NLA_POLICY_RANGE(NLA_U32, NF_INET_PRE_ROUTING=
,
> +                                          NF_INET_NUMHOOKS),
>         [TCA_IPT_INDEX] =3D { .type =3D NLA_U32 },
>         [TCA_IPT_TARG]  =3D { .len =3D sizeof(struct xt_entry_target) },
>  };
> @@ -158,15 +159,27 @@ static int __tcf_ipt_init(struct net *net, unsigned=
 int id, struct nlattr *nla,
>                         return -EEXIST;
>                 }
>         }
> +
> +       err =3D -EINVAL;
>         hook =3D nla_get_u32(tb[TCA_IPT_HOOK]);
> +       switch (hook) {
> +       case NF_INET_PRE_ROUTING:
> +               break;
> +       case NF_INET_POST_ROUTING:
> +               break;
> +       default:
> +               goto err1;
> +       }
> +
> +       if (tb[TCA_IPT_TABLE]) {
> +               /* mangle only for now */
> +               if (nla_strcmp(tb[TCA_IPT_TABLE], "mangle"))
> +                       goto err1;
> +       }
>
> -       err =3D -ENOMEM;
> -       tname =3D kmalloc(IFNAMSIZ, GFP_KERNEL);
> +       tname =3D kstrdup("mangle", GFP_KERNEL);
>         if (unlikely(!tname))
>                 goto err1;
> -       if (tb[TCA_IPT_TABLE] =3D=3D NULL ||
> -           nla_strscpy(tname, tb[TCA_IPT_TABLE], IFNAMSIZ) >=3D IFNAMSIZ=
)
> -               strcpy(tname, "mangle");
>
>         t =3D kmemdup(td, td->u.target_size, GFP_KERNEL);
>         if (unlikely(!t))
> --
> 2.40.1
>

