Return-Path: <netdev+bounces-840-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 03D486FAC73
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 13:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE9BF280E4E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 11:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2924171A2;
	Mon,  8 May 2023 11:24:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7590168DD
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 11:24:41 +0000 (UTC)
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD903A5E3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:24:37 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 3f1490d57ef6-b9246a5f3feso6910900276.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 04:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683545076; x=1686137076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIGhf3eRAjihUJXQEWIYc02wnTiI4XPwL0ihUb83Waw=;
        b=OmtuiNHh/0mYopJ2E3ln7anz6SL7k7OlWoQ+Jjv4kFH7ceI9OnXCKkqFmmjd7G2vV+
         PfvuJUD6KWGOgRRzAkYRgLP02ubjYdYebw1QIy7OXai0nGFtS/r+7PxB1x7cdlYbppNt
         CSkebv+h1HWH2679CKhDW12tjbgP/7EysinpQUiDvrsPSWbeg1Qy5f2kr8Z62aeHkwi4
         DXeQL8ZSTHhhuzKAXoYe94sIzYSDgEz1C0tCx00QH7ebBJJpd5HRs2Klfyzso3DZ21bh
         IaOFGCJrcL66d85IwuVBasel48pJpWQ2YY92NRzKgvDJEqAemaA9AF0mZQ7LS31fNRia
         MUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683545076; x=1686137076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIGhf3eRAjihUJXQEWIYc02wnTiI4XPwL0ihUb83Waw=;
        b=D0e7PZDD7eWIUdxBP2YMUmacBL7lc0RiOtNLd6GuBINDVi6mvvAyA/xVeRLGl8OK/R
         6vFmjvQu7zl4LvOKI2JhNvEbNvxBvO27GZN96wV2mph+pp4zVvt7t+nKyc7Y5uSUcMIG
         g2v+fNc3X9el/0vlmQMvQeWXaz7UUHSOZNgMf9J0dLY+SIIRIr6n4ssxGOSexn8JCJWF
         ch9AMVSPokPF7ACptwuxQRKGKY29ZhiIoBJ5YU3u34ZRXGFgr3wqCKV81ZFy9y5ISQde
         jMoeGtGOiBqo39wkr41dfX0lHP4Z78GRPVgjD3uu9RylbcGrW91Uofx7YynEK+s9WdvT
         /Q4A==
X-Gm-Message-State: AC+VfDyjYGZMk9AHu7Cy6C/BA5Ml6iaY3/JAzH+PGfRintjihAihjGlp
	jQCAuiLWB8PeRBMd8ZeITN2B00IqcNnUssiQKzo7gw==
X-Google-Smtp-Source: ACHHUZ6Hs0l5aEi7EewTSFlNC+EkBAT54ACkp3N6Zc1EHO8wzU5wK1Z1ej8SuhfI1vY3FSFbF/9TFwF/7FYfGS1eqCc=
X-Received: by 2002:a25:6fc6:0:b0:b9e:6894:289c with SMTP id
 k189-20020a256fc6000000b00b9e6894289cmr9519837ybc.59.1683545076214; Mon, 08
 May 2023 04:24:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1683326865.git.peilin.ye@bytedance.com> <846336873bfba19914397a1656ba1eb42051ed87.1683326865.git.peilin.ye@bytedance.com>
In-Reply-To: <846336873bfba19914397a1656ba1eb42051ed87.1683326865.git.peilin.ye@bytedance.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Mon, 8 May 2023 07:24:25 -0400
Message-ID: <CAM0EoMnPL_UcZmBYJk=nUAc9hG26EoKwyUd3gUGeCE_nBtTAFg@mail.gmail.com>
Subject: Re: [PATCH net 4/6] net/sched: Prohibit regrafting ingress or clsact Qdiscs
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

On Fri, May 5, 2023 at 8:14=E2=80=AFPM Peilin Ye <yepeilin.cs@gmail.com> wr=
ote:
>
> Currently, after creating an ingress (or clsact) Qdisc and grafting it
> under TC_H_INGRESS (TC_H_CLSACT), it is possible to graft it again under
> e.g. a TBF Qdisc:
>
>   $ ip link add ifb0 type ifb
>   $ tc qdisc add dev ifb0 handle 1: root tbf rate 20kbit buffer 1600 limi=
t 3000
>   $ tc qdisc add dev ifb0 clsact
>   $ tc qdisc link dev ifb0 handle ffff: parent 1:1
>   $ tc qdisc show dev ifb0
>   qdisc tbf 1: root refcnt 2 rate 20Kbit burst 1600b lat 560.0ms
>   qdisc clsact ffff: parent ffff:fff1 refcnt 2
>                                       ^^^^^^^^
>
> clsact's refcount has increased: it is now grafted under both
> TC_H_CLSACT and 1:1.
>
> ingress and clsact Qdiscs should only be used under TC_H_INGRESS
> (TC_H_CLSACT).  Prohibit regrafting them.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> ---
>  net/sched/sch_api.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 383195955b7d..49b9c1bbfdd9 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1596,6 +1596,11 @@ static int tc_modify_qdisc(struct sk_buff *skb, st=
ruct nlmsghdr *n,
>                                         NL_SET_ERR_MSG(extack, "Invalid q=
disc name");
>                                         return -EINVAL;
>                                 }
> +                               if (q->flags & TCQ_F_INGRESS) {
> +                                       NL_SET_ERR_MSG(extack,
> +                                                      "Cannot regraft in=
gress or clsact Qdiscs");
> +                                       return -EINVAL;
> +                               }
>                                 if (q =3D=3D p ||
>                                     (p && check_loop(q, p, 0))) {
>                                         NL_SET_ERR_MSG(extack, "Qdisc par=
ent/child loop detected");
> --
> 2.20.1
>

