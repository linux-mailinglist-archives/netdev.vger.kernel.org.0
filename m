Return-Path: <netdev+bounces-837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 957F46FAC50
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51686280C8D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3B0168DC;
	Mon,  8 May 2023 11:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F28168D1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:23:11 +0000 (UTC)
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BE6394BB
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:23:07 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 3f1490d57ef6-b983027d0faso5839395276.0
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683544987; x=1686136987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbLxNx5ZTLFtJfBmyYGqFUyF5NENfzsiaOtRcsrhjlE=;
        b=o3OQkgZgD/WY9opGNlHlsV4/NU2A5cemEhoLcU5WNR34kHgn4MxycFAJPhUApExswE
         3VDdWdDGvrt5exhYc5OGjXow3Y2ZpU3yFwMQO8qTXy7/1S0d3BeBTdaqTR2lRrbIx4bf
         TuxY7QBMEKRieP1e1phESc7x4WFJdJUoW5HqYmEvvrDAlRT7/g3Hly4GylD+hhov4H3S
         BdShWv0LIK/1A5gplQk/7H+sWoTj59hMLNpPUzTUx6kddAb1iLGWKpD0Zg4uKKPcFOGl
         rEPoIwKvx5HVHOpfSEiEsqLaXAROGTjBVz58Hc8M8gNvakjiyk47Yfh5RPen0HjwJZni
         /QtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683544987; x=1686136987;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbLxNx5ZTLFtJfBmyYGqFUyF5NENfzsiaOtRcsrhjlE=;
        b=fB8t/+5c0sNNy9RCZxPCjcTQSyOZK6kadQIs8jZF3rZ7gtVEtZa46ejUnDEFw2mzgP
         J5dSvj6b8ZrFSyzEflHDKvIzu8Y3v1lLcZqi2GVcZdyeeuSTiKxZj/0e3VE7kTEoQIPB
         CGaGoVgHHWWIBKl/X82DblwIc8zBo5ZCNpmlUYn39ReliSMDRcEuROHBVKl+DZGy1F/A
         ypkMpk29Ro66ugGoCN15aLVx6AUYeHca2BdWb/zc4GRYJTb3UCHQcDWdeY9/TbQw5OGH
         6t5omjQLqX/PTvE8DViQUBovCwjjZ2htYrMkLT5X3LE2seLt0gU+dSlzikc3Aw6Rslbr
         wh/g==
X-Gm-Message-State: AC+VfDyvMeEM0odFJ+glygYyklQYITQ5bUd2oILlx2ZpIZkzs/eR8RIK
	WmeZYWxCZXADVqLWDTYlR1WIhjQWIeRTW3EDT3ELaw==
X-Google-Smtp-Source: ACHHUZ585X6xeUyd9o8OyxwKy1fYbCc5vS4z3frP5dtvkLrTIl3xed33FgpAb5R050oyQcWU9Hq4kC+0DRGJgAl8xko=
X-Received: by 2002:a25:4284:0:b0:b8f:490c:a0db with SMTP id
 p126-20020a254284000000b00b8f490ca0dbmr11124953yba.59.1683544985454; Mon, 08
 May 2023 04:23:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683326865.git.peilin.ye@bytedance.com> <d24b49826204dbdd1aa1a209e79bbfe384a96b67.1683326865.git.peilin.ye@bytedance.com>
In-Reply-To: <d24b49826204dbdd1aa1a209e79bbfe384a96b67.1683326865.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 May 2023 07:22:54 -0400
Message-ID: <CAM0EoMng6Au3SfHkBuaXu1c1o6U3+iSR_csH7DsZRpGBvZn_TQ@mail.gmail.com>
Subject: Re: [PATCH net 1/6] net/sched: sch_ingress: Only create under TC_H_INGRESS
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.r.fastabend@intel.com>, Vlad Buslov <vladbu@mellanox.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 8:12=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> wr=
ote:
>
> ingress Qdiscs are only supposed to be created under TC_H_INGRESS.
> Similar to mq_init(), return -EOPNOTSUPP if 'parent' is not
> TC_H_INGRESS.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/netdev/0000000000006cf87705f79acf1a@google.=
com
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/sch_ingress.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
> index 84838128b9c5..3d71f7a3b4ad 100644
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
> --
> 2.20.1
>

