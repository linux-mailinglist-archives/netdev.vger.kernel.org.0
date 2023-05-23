Return-Path: <netdev+bounces-4553-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F71D70D360
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E1B101C20C39
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:52:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59DB31B90A;
	Tue, 23 May 2023 05:52:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBCC1B8F1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:52:32 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C93109;
	Mon, 22 May 2023 22:52:30 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-970028cfb6cso291696866b.1;
        Mon, 22 May 2023 22:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684821149; x=1687413149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAnZGDk/FN7vuQkDTHFR40h0pyNa8eDVqn6h/H/qRE4=;
        b=AHUVle6SGyOqFZNmxo/n79Q/lkpN45w+hs1HUOKjnZpfVgJG50GAuBK7o4MIiK3944
         1+vvNNqrhuF3GVVjPTds3M1ffZaFfzvp3aceE5TurXJ6oQUxQzKiRUgrRQ9qh1c2f4g9
         hGNb1lzhECE65Pn0RbLjIf5B0bwzyk8To09cQ1Y27AfWwe77mwqUL2XqjcI5Q1F+WLjU
         zuyBpz0ns/HZ/gSdL2ZrWtB+MceHLKC+gZz45Mts3aAELWizJP2pIz0DJd6pAhxPDv00
         h/GNNoXZD+MfODSkAlPSMP8I9vcbqsMNShIIUISCwWuwWravTFoF8zyEyR0AClrtsEBp
         QbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684821149; x=1687413149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAnZGDk/FN7vuQkDTHFR40h0pyNa8eDVqn6h/H/qRE4=;
        b=DmuciBPBuhLochUeZtDTyFcvW1NK1Tge3Sjf1g4lX/tgjNa2i8KsITwzx+zxwAvYP0
         FV8Nvh3bdtWG0rqzoDCWZJUI0x4WCJrTEmYlYafj+YOdFgBx8YoDtGNPunFgc4HMOR1R
         WlwbUdJM6WPXCCiqGe1AXyABxa/DnEC2UMv/0B6WUrdADqDXN2ODUJEfwAMYJexm2s+e
         mPTEhoU4K5G1LfuDJhyCnmdN75IpxFh9YZNaXg8a6LoEWSkqf3ijFzJwypsEvebgtZWO
         sHZmT8T2irCG3i0rDkM/9opbIwzerMri2E9G1YtY2O4DxA2F+d13hvmZHeORjh8bGsvq
         1nvw==
X-Gm-Message-State: AC+VfDzOAr4JcBOAEK/bUU3PvSrWPPeygH3btC5m1BiuINpGw75Rv2+e
	CXbMahBEKTvAFORJFaqKmVJiTTptfeI7/zOCAjg=
X-Google-Smtp-Source: ACHHUZ4I4AQ7WeHjg7BWPjCFZusXPuOrzMi+WsHqXJzeSQakVfl2dBkawp2cayOw96DPe7VZs7Y63KY7sij+zmVjiUk=
X-Received: by 2002:a17:907:16a9:b0:959:a9a1:589e with SMTP id
 hc41-20020a17090716a900b00959a9a1589emr12631243ejc.76.1684821148506; Mon, 22
 May 2023 22:52:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <000000000000a589d005fc52ee2d@google.com> <13528f21-0f36-4fa2-d34f-eecee6720bc1@linux.dev>
 <CAD=hENeCo=-Pk9TWnqxOWP9Pg-JXWk6n6J19gvPo9_h7drROGg@mail.gmail.com>
 <CAD=hENdoyBZaRz7aTy4mX5Kq1OYmWabx2vx8vPH0gQfHO1grzw@mail.gmail.com>
 <0d515e17-5386-61ba-8278-500620969497@linux.dev> <CAD=hENcqa0jQvLjuXw9bMtivCkKpQ9=1e0-y-1oxL23OLjutuw@mail.gmail.com>
 <CAD=hENdXdqfcxjNrNnP8CoaDy6sUJ4g5uxcWE0mj3HtNohDUzw@mail.gmail.com>
 <CAD=hENda4MxgEsgT-GUhYHH66m79wi8yxBQS8CYnxc_DsQKGwg@mail.gmail.com> <5b6b8431-92c7-62df-299b-28f3a5f61d5f@linux.dev>
In-Reply-To: <5b6b8431-92c7-62df-299b-28f3a5f61d5f@linux.dev>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 13:52:15 +0800
Message-ID: <CAD=hENc72B+gLLd_Xn7w8bd_qDw=mFd5sC0RKEsHpNA=85a9KA@mail.gmail.com>
Subject: Re: [syzbot] [rdma?] INFO: trying to register non-static key in
 skb_dequeue (2)
To: Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: syzbot <syzbot+eba589d8f49c73d356da@syzkaller.appspotmail.com>, jgg@ziepe.ca, 
	leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 1:44=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/23/23 13:18, Zhu Yanjun wrote:
> > On Tue, May 23, 2023 at 1:08=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmail.co=
m> wrote:
> >> On Tue, May 23, 2023 at 12:29=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmail.=
com> wrote:
> >>> On Tue, May 23, 2023 at 12:10=E2=80=AFPM Guoqing Jiang <guoqing.jiang=
@linux.dev> wrote:
> >>>>
> >>>>
> >>>> On 5/23/23 12:02, Zhu Yanjun wrote:
> >>>>> On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@gma=
il.com> wrote:
> >>>>>> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.ji=
ang@linux.dev> wrote:
> >>>>>>>
> >>>>>>> On 5/23/23 10:13, syzbot wrote:
> >>>>>>>> Hello,
> >>>>>>>>
> >>>>>>>> syzbot tried to test the proposed patch but the build/boot faile=
d:
> >>>>>>>>
> >>>>>>>> failed to apply patch:
> >>>>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> >>>>>>>> patch: **** unexpected end of file in patch
> >>>>>> This is not the root cause. The fix is not good.
> >>>>> This problem is about "INFO: trying to register non-static key. The
> >>>>> code is fine but needs lockdep annotation, or maybe"
> >>> This warning is from "lock is not initialized". This is a
> >>> use-before-initialized problem.
> >>> The correct fix is to initialize the lock that is complained before i=
t is used.
> >>>
> >>> Zhu Yanjun
> >> Based on the call trace, the followings are the order of this call tra=
ce.
> >>
> >> 291 /* called by the create qp verb */
> >> 292 int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp,
> >> struct rxe_pd *pd,
> >> 297 {
> >>              ...
> >> 317         rxe_qp_init_misc(rxe, qp, init);
> >>              ...
> >> 322
> >> 323         err =3D rxe_qp_init_resp(rxe, qp, init, udata, uresp);
> >> 324         if (err)
> >> 325                 goto err2;   <--- error
> >>
> >>              ...
> >>
> >> 334 err2:
> >> 335         rxe_queue_cleanup(qp->sq.queue); <--- Goto here
> >> 336         qp->sq.queue =3D NULL;
> >>
> >> In rxe_qp_init_resp, the error occurs before skb_queue_head_init.
> >> So this call trace appeared.
> > 250 static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
> > 254 {
> >                          ...
> > 264
> > 265                 type =3D QUEUE_TYPE_FROM_CLIENT;
> > 266                 qp->rq.queue =3D rxe_queue_init(rxe, &qp->rq.max_wr=
,
> > 267                                         wqe_size, type);
> > 268                 if (!qp->rq.queue)
> > 269                         return -ENOMEM;    <---Error here
> > 270
> >
> > ...
> >
> > 282         skb_queue_head_init(&qp->resp_pkts); <-this is not called.
> > ...
> > This will make spin_lock of resp_pkts is used before initialized.
>
> IMHO, the above is same as
>
> > Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not called
> > given rxe_qp_init_resp returns error, but the cleanup still trigger the
> > chain.
> >
> > rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts ->
> > skb_dequeue(&qp->resp_pkts)
>
> my previous analysis. If not, could you provide another better way to
> fix it?

Move the initialization to the beginning. This can fix this problem.
See below:

"
diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c
b/drivers/infiniband/sw/rxe/rxe_qp.c
index c5451a4488ca..22ef6188d7b1 100644
--- a/drivers/infiniband/sw/rxe/rxe_qp.c
+++ b/drivers/infiniband/sw/rxe/rxe_qp.c
@@ -176,6 +176,9 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe,
struct rxe_qp *qp,
        spin_lock_init(&qp->rq.producer_lock);
        spin_lock_init(&qp->rq.consumer_lock);

+       skb_queue_head_init(&qp->req_pkts);
+       skb_queue_head_init(&qp->resp_pkts);
+
        atomic_set(&qp->ssn, 0);
        atomic_set(&qp->skb_out, 0);
 }
@@ -234,8 +237,6 @@ static int rxe_qp_init_req(struct rxe_dev *rxe,
struct rxe_qp *qp,
        qp->req.opcode          =3D -1;
        qp->comp.opcode         =3D -1;

-       skb_queue_head_init(&qp->req_pkts);
-
        rxe_init_task(&qp->req.task, qp, rxe_requester);
        rxe_init_task(&qp->comp.task, qp, rxe_completer);

@@ -279,8 +280,6 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe,
struct rxe_qp *qp,
                }
        }

-       skb_queue_head_init(&qp->resp_pkts);
-
        rxe_init_task(&qp->resp.task, qp, rxe_responder);

        qp->resp.opcode         =3D OPCODE_NONE;
"

>
> Guoqing

