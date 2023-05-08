Return-Path: <netdev+bounces-838-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D28A26FAC5E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:23:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BD7A1C20960
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:23:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FCDE168DF;
	Mon,  8 May 2023 11:23:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358151094C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:23:39 +0000 (UTC)
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B10139B96
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:23:35 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-55cc8aadc97so65394327b3.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683545014; x=1686137014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3HDqCPrs24l1NkbnJJInDbRYqXfvO1t54JWNGO76NLA=;
        b=FF125Ih+uoXp+/eeHm3AmcrIs2XIdIQRSqC6DtSUJjl/op8ooHtHT15GlsjRpj+Hse
         s/6FNyHPNYxSMtmmJbWP3tfaoBXd8SrJohSujKEmHV6rYRBc6BouvycyqYQiUrh+13lP
         D7e0qccH1wqz0+8P7XwMeDsTT6fCqqC+7HPJbxdOCanW9aZC9cW3BK8oY7GUJlfUJtff
         QO+dlO+oae0mcxHNwb8e0udA4XBol8+R8ELDCTsCD5wEowmtC3H4s3+J+gkiPx9xTS3A
         Bj3ErIMU5wquK7SBRgGPx7BGtN2ZAwVW/VRQ+gbeJoe6gxsvtcrPWucIgmOXLefrLdtk
         ImUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683545014; x=1686137014;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3HDqCPrs24l1NkbnJJInDbRYqXfvO1t54JWNGO76NLA=;
        b=A9D31KYo1XCxwdr0jsNHNMdPR8VGrrFRFkJXomh2zJhGV8mg5GVFCMtfMEGCjGwZu0
         6KZCtoksauSHfg4pMMZNdXNQpKG9caDIolS8Z+UxbeZ6sH2W8xskxQE5vapQaw440Yfx
         4i1175PDfdINOcmFGBaeGsOQyb2wdIfu4GKHqHD+wrhFDQchQ3Cr9toRRBaUqgtuDidd
         A3bJRAXuWLpM4mDimKFFuvy3Ptyu+AzL8Pn97Vr9pKF87Khanw779TCeP963z7TcOHV5
         h1WGYGzgDthFpFKZoMyNr+4AaFLtMa1AIXdsSBu2UHebK8OAnzo7TcdsdOElg+hHXtoV
         5svA==
X-Gm-Message-State: AC+VfDw1J7UUFUUWQoI4ViZOKUNXNvpooq+XHDLO1cFK25VUHEhf0/H0
	IcWL48BJzUwijaKkM7EKpcFs/v1AhQCkWhUPqG+CAg==
X-Google-Smtp-Source: ACHHUZ6MpjIBJdNYtjx66B1qfv3EXuYJyXm1IefrzeQQtnZhBvk1XCfTRTl1o9RhvwE+w+KwH+TFvMU+nyte6rRDUbs=
X-Received: by 2002:a25:688b:0:b0:b9a:6349:f3a with SMTP id
 d133-20020a25688b000000b00b9a63490f3amr10466806ybc.56.1683545014509; Mon, 08
 May 2023 04:23:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683326865.git.peilin.ye@bytedance.com> <21f1455040137e531f64fdc4edc3d36840e076ed.1683326865.git.peilin.ye@bytedance.com>
In-Reply-To: <21f1455040137e531f64fdc4edc3d36840e076ed.1683326865.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 May 2023 07:23:23 -0400
Message-ID: <CAM0EoM=upsZ1QFokoR5=A4E8Sp=U+UbXDq-jO5r_7pOcq4OL0w@mail.gmail.com>
Subject: Re: [PATCH net 2/6] net/sched: sch_clsact: Only create under TC_H_CLSACT
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
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 8:13=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> wr=
ote:
>
> clsact Qdiscs are only supposed to be created under TC_H_CLSACT (which
> equals TC_H_INGRESS).  Return -EOPNOTSUPP if 'parent' is not
> TC_H_CLSACT.
>
> Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
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
> index 3d71f7a3b4ad..13218a1fe4a5 100644
> --- a/net/sched/sch_ingress.c
> +++ b/net/sched/sch_ingress.c
> @@ -222,6 +222,9 @@ static int clsact_init(struct Qdisc *sch, struct nlat=
tr *opt,
>         struct net_device *dev =3D qdisc_dev(sch);
>         int err;
>
> +       if (sch->parent !=3D TC_H_CLSACT)
> +               return -EOPNOTSUPP;
> +
>         net_inc_ingress_queue();
>         net_inc_egress_queue();
>
> --
> 2.20.1
>

