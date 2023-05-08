Return-Path: <netdev+bounces-841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A2306FACF4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 144871C2096A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:29:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007BA168DC;
	Mon,  8 May 2023 11:29:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3717171A5
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:29:54 +0000 (UTC)
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134B137868
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:29:39 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id 3f1490d57ef6-ba2362d4ea9so1574649276.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683545377; x=1686137377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lf9xP+nKNZcWbJUD0fYGLuCSyrgF1CkVpqBfetT/SAU=;
        b=E6dUadmg+Ly4O4sVQh47014bqUNwGP9dxF8kaL5813rMQVWgWpomZo7LK4lgo+hECb
         X8bDFdqTn5yHRbBb3BDv7V/lZtaFQVFcPE2GNrwoKw3TA8VvoE9pZRsdn8QS0c6Ttl0K
         +4gSUqnMiDEb+afvJ3UHrkcmOtGQcI9aXtUiVTH7o0vBDgkQfN2H0qT80TvcAUhrxyvo
         z/AXJYe6goSRSsNoKCNqyyj8YaMBqfJCsGh7lWTOeI/nBUrbVGPKoVk5nw3bTiKnZYGk
         ZDu5+YQZS1/IgGwZCxjZBXSsPb2jOipUVkQavGRMtGGNI0vpWgyeFmI8NgNpc4x+JxUT
         Ry0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683545377; x=1686137377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lf9xP+nKNZcWbJUD0fYGLuCSyrgF1CkVpqBfetT/SAU=;
        b=ZXFIYmFNxZpyyiVpCc0taAQPuT7tAtXMaKEW6/vNhwWSkIPV/czx0CltkVeKrMkzRg
         unS1X7s8eIAECBr0NBcFofEkhLIz7QAfKfqWxazyJcob5ac7HURoNsyeTvgWD5NxzqBR
         yZAwXFFPHLvp5yaiSfmpDRlJELT9h88TMTzMcQ5ZU7PYlKEFw1YRSxsIPNKiFI6Dp3xh
         6G4s9IiAjk9aOnWIKeoWFBTNLv+NtG/JT4wCBVBtD3lPvU7o4lJfFm70Cf1O93vxLCIh
         DA8nDzNhKJ7/9YDIK6jwO9q8rVLqljveRcOebw2YBabaJWmIDuz99pxZnZq8crAQ6BG5
         RQhg==
X-Gm-Message-State: AC+VfDyYiGBPfuwn33yTYPxgIYlWArAtXguKd0hoydwNIudWbJ05EiIj
	yjl1qrNwL1NPKqFk65vWA6zuybIsztzR8N3A7L2kaQ==
X-Google-Smtp-Source: ACHHUZ5xyZWRYekPbCi2C7w1p87Zm4tTv/KQ2mAxymaMTwuF8atX1+St0eMFDqFU5z3lqW7m1UNA77qNBooXreMpMA0=
X-Received: by 2002:a25:ab62:0:b0:b94:bbf2:6d9d with SMTP id
 u89-20020a25ab62000000b00b94bbf26d9dmr11309852ybi.48.1683545377452; Mon, 08
 May 2023 04:29:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683326865.git.peilin.ye@bytedance.com> <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
In-Reply-To: <1cd15c879d51e38f6b189d41553e67a8a1de0250.1683326865.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 May 2023 07:29:26 -0400
Message-ID: <CAM0EoM=o862LdMEwmqpCSOFT=dMM8LhxgY3QUvpAow1rHSe7DA@mail.gmail.com>
Subject: Re: [PATCH net 5/6] net/sched: Refactor qdisc_graft() for ingress and
 clsact Qdiscs
To: Peilin Ye <yepeilin.cs@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>, 
	Peilin Ye <peilin.ye@bytedance.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Vlad Buslov <vladbu@mellanox.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Cong Wang <cong.wang@bytedance.com>, John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 5, 2023 at 8:15=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> wr=
ote:
>
> Grafting ingress and clsact Qdiscs does not need a for-loop in
> qdisc_graft().  Refactor it.  No functional changes intended.
>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Fixed John's email address.

This one i am not so sure;  num_q =3D 1 implies it will run on the for
loop only once. I am not sure it improves readability either. Anyways
for the effort you put into it i am tossing a coin and saying:
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal


>  net/sched/sch_api.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 49b9c1bbfdd9..f72a581666a2 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1073,12 +1073,12 @@ static int qdisc_graft(struct net_device *dev, st=
ruct Qdisc *parent,
>
>         if (parent =3D=3D NULL) {
>                 unsigned int i, num_q, ingress;
> +               struct netdev_queue *dev_queue;
>
>                 ingress =3D 0;
>                 num_q =3D dev->num_tx_queues;
>                 if ((q && q->flags & TCQ_F_INGRESS) ||
>                     (new && new->flags & TCQ_F_INGRESS)) {
> -                       num_q =3D 1;
>                         ingress =3D 1;
>                         if (!dev_ingress_queue(dev)) {
>                                 NL_SET_ERR_MSG(extack, "Device does not h=
ave an ingress queue");
> @@ -1094,18 +1094,18 @@ static int qdisc_graft(struct net_device *dev, st=
ruct Qdisc *parent,
>                 if (new && new->ops->attach && !ingress)
>                         goto skip;
>
> -               for (i =3D 0; i < num_q; i++) {
> -                       struct netdev_queue *dev_queue =3D dev_ingress_qu=
eue(dev);
> -
> -                       if (!ingress)
> +               if (!ingress) {
> +                       for (i =3D 0; i < num_q; i++) {
>                                 dev_queue =3D netdev_get_tx_queue(dev, i)=
;
> +                               old =3D dev_graft_qdisc(dev_queue, new);
>
> -                       old =3D dev_graft_qdisc(dev_queue, new);
> -                       if (new && i > 0)
> -                               qdisc_refcount_inc(new);
> -
> -                       if (!ingress)
> +                               if (new && i > 0)
> +                                       qdisc_refcount_inc(new);
>                                 qdisc_put(old);
> +                       }
> +               } else {
> +                       dev_queue =3D dev_ingress_queue(dev);
> +                       old =3D dev_graft_qdisc(dev_queue, new);
>                 }
>
>  skip:
> --
> 2.20.1
>

