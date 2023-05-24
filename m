Return-Path: <netdev+bounces-5117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFA0770FAF6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 592DE1C20DC5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B9CA19BDD;
	Wed, 24 May 2023 15:58:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8026D1951F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:58:09 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0001BE5D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:57:41 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-562108900acso15228127b3.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684943858; x=1687535858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJiMWuDa/DxlBPF1DUDfxqZn3kh1sZxnRyYMTBJ/oLI=;
        b=aByDRh1HcNbPhakCSpYG5gxvilodKlUAyE6Gz164POBR6EMez0lUzcYKxMKhI/iXOH
         l6hP1copodEB+P3hJRUnBITkYkYAUCXuaDpkMmFPNj2hQbYAzGxq6SUWhMTeCq8Ie/kO
         zzwm+C1TwzbjSf59hDMnGe42NDXJhYMlguNpbQFvky123/EjXKwJDFs1NdQ/2pdb2GAb
         madzh5HpcSec8vE9dUJE5MtrkKFfKO9JyIBR6AeW6A9VbK8wHBCrv4seF8eWQvBZ5Ka4
         9z7enp8BC4+X32DjvFHHKKAQ27alezJfqbd0nDkI3u+W2XFlQw7p/JzQCjYKPjAUqJuL
         Dq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684943858; x=1687535858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJiMWuDa/DxlBPF1DUDfxqZn3kh1sZxnRyYMTBJ/oLI=;
        b=RhH0X2ygtB+n8cpU7UxXR3K62gvLaVqrYzC6Gr2HaGEVJIlbQIi2PWI6Pu4VRLWuy8
         4e4/iTvpohCFmcvzV3vZN0fZAzd5AAb9TmI6cSNfSndCJXkliOi9vRdvD5NJNjQzw1vn
         HxPXr5LWV8f6YIuX6HJeBFq+Pe4/izCj6CrMnuJEcThVBmnOaNjCnMmnjZTfyMqHxgzt
         Hy1E6ZWQY1KY/Gw3n7X/3T6Q8f3SgpQnShNzPvHiieA5JmZwyvSGp9WlhVPm2/17Qmie
         maIJjrUWYUONRyvQE7d/NHrTfgrxHwp/6d99mIZMDIQ28rQmIc8JebsFgQB2biW2/TOB
         0BmQ==
X-Gm-Message-State: AC+VfDyXKScZBfKykunoOtwTL8jG38gIPkeLfzAGWuwoiNnE+IhlQmmE
	AoHkSef8ctK0vT3HS5XL17AoawXmg8vfOZSiVm1bNA==
X-Google-Smtp-Source: ACHHUZ537ndFuIxP/FBndgBgTkyor6Xtz5icmfDcHzO3+uizN8pTXYA3KB4wflWNyUpcmKKq/NmgVrTpHF9aHyWAcRA=
X-Received: by 2002:a81:7bd7:0:b0:565:5e75:6fb9 with SMTP id
 w206-20020a817bd7000000b005655e756fb9mr4336776ywc.32.1684943858705; Wed, 24
 May 2023 08:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684887977.git.peilin.ye@bytedance.com> <b0dcc6677248210348f08d9cb4e93013e7c95262.1684887977.git.peilin.ye@bytedance.com>
In-Reply-To: <b0dcc6677248210348f08d9cb4e93013e7c95262.1684887977.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 24 May 2023 11:57:27 -0400
Message-ID: <CAM0EoMm4KfeLEhDm3Zz6KW48vaJ-LqdWDBt6Yszmom-ue1dpSg@mail.gmail.com>
Subject: Re: [PATCH v5 net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Vlad Buslov <vladbu@mellanox.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 9:18=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> w=
rote:
>
> From: Peilin Ye <peilin.ye@bytedance.com>
>
> ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
> Return -EOPNOTSUPP if 'parent' is not TC_H_INGRESS, similar to
> mq_init().
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/0000000000006cf87705f79acf1a@google.com=
/
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
> ---
> change in v5:
>   - avoid underflowing @ingress_needed_key in ->destroy(), reported by
>     Pedro
>
> change in v3, v4:
>   - add in-body From: tag
>
>  net/sched/sch_ingress.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 84838128b9c5..f9ef6deb2770 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -80,6 +80,9 @@ static int ingress_init(struct Qdisc *sch, struct nlatt=
r *opt,
>         struct net_device *dev =3D qdisc_dev(sch);
>         int err;
>
> +       if (sch->parent !=3D TC_H_INGRESS)
> +               return -EOPNOTSUPP;
> +
>         net_inc_ingress_queue();
>
>         mini_qdisc_pair_init(&q->miniqp, sch, &dev->miniq_ingress);
> @@ -101,6 +104,9 @@ static void ingress_destroy(struct Qdisc *sch)
>  {
>         struct ingress_sched_data *q =3D qdisc_priv(sch);
>
> +       if (sch->parent !=3D TC_H_INGRESS)
> +               return;
> +
>         tcf_block_put_ext(q->block, sch, &q->block_info);
>         net_dec_ingress_queue();
>  }
> --
> 2.20.1
>

