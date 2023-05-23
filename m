Return-Path: <netdev+bounces-4558-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4084A70D38F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:05:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF98528123D
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD41A1B917;
	Tue, 23 May 2023 06:05:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EC81B8F1
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:05:08 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D917109;
	Mon, 22 May 2023 23:05:06 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-510dabb39aeso680259a12.2;
        Mon, 22 May 2023 23:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684821904; x=1687413904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DnKfesUMiH7wOnVepwf4hrKeQ60+TETd1ypPNhelM7E=;
        b=WpUcsauiggIVyug7xNF89uiLsBGsvbyRDOJoRA1hUi/lkjPwrPhCFHbvKWomWdpdau
         CtpcJcGe7b00tiJr/0/gWRnNjEppQlLMe7nO4GTfs7NKgJEeSK28iTSBOSMMoK2lkEiN
         k2wIbAZVUZylLqBoXm6VEJMqZL+g0+jOP79eNsRf+c09jtl9R2n1Tp89p4m8XgHv/bEA
         MI6bOPuiTVi6Whzz7aFjRzVpiQQtmwm2abV+bML+L0xf1Qw9lmKHKjLoZnpBQbtKmxr9
         EloZKoEz/v0X26m2IH/amUhYCKGmGTiHNf/LRgcKaHRoKv1Hcv+1eaByWi+u50jZ0SvE
         4eAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684821904; x=1687413904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnKfesUMiH7wOnVepwf4hrKeQ60+TETd1ypPNhelM7E=;
        b=dytRqDQi22e5va4olgrR8dbD5e8SA0yPFTVteLtW09ixjG31/12oKzrO0Rx17aJuOQ
         WpX0NvJ8vPpvQDZEWwJ2cv1Qka8VcVLFYAApsT5fgslX8efuI36g68kt481lyNwQz6gW
         5LYunN0O+liL+I4LmqYfMs42r3BWBMJuCP3j8f1uMr1EA1Y+2bY052RvWg325ciUcMT/
         mH2tzSsihT7XCBszXrYUDjLoq96dCtKUsCiyXGqR+Wh2TuV4AP5+kNh5y6QvSolsQwkf
         5+7tCluLE1fUIsSs8izxYXi4SZkoXB0tn7d4P9Fgc48GNjM2yBc/kAp9IgHRrsLqGYkM
         E//Q==
X-Gm-Message-State: AC+VfDwEgrPPJyWb5kXEUBuexmc048MU6tAvFYRYRJRP4BHLjiThWzBV
	vnhhut5PTyy0YKMumOLGWuTDt6g6Z4F+A1Vp8B4=
X-Google-Smtp-Source: ACHHUZ4RpAsJ46vl8Z8UjPGAaHskIXtQbKsxs0tTy5TH57b8k2Q2oSSpEvR0HsSHyzzTJnsMzH3o+k8XXbEkxWbf6Cc=
X-Received: by 2002:a17:907:94d3:b0:96f:e2c4:a063 with SMTP id
 dn19-20020a17090794d300b0096fe2c4a063mr6448810ejc.33.1684821904353; Mon, 22
 May 2023 23:05:04 -0700 (PDT)
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
 <CAD=hENda4MxgEsgT-GUhYHH66m79wi8yxBQS8CYnxc_DsQKGwg@mail.gmail.com>
 <5b6b8431-92c7-62df-299b-28f3a5f61d5f@linux.dev> <CAD=hENc72B+gLLd_Xn7w8bd_qDw=mFd5sC0RKEsHpNA=85a9KA@mail.gmail.com>
 <e2a3a27e-9c12-f180-4bb6-1906aa1a1844@linux.dev>
In-Reply-To: <e2a3a27e-9c12-f180-4bb6-1906aa1a1844@linux.dev>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 14:04:49 +0800
Message-ID: <CAD=hENcMLEfLgjoRqxwwR1jdAKTHfB+iEBtjpfkfhzwsJoLVow@mail.gmail.com>
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

On Tue, May 23, 2023 at 1:56=E2=80=AFPM Guoqing Jiang <guoqing.jiang@linux.=
dev> wrote:
>
>
>
> On 5/23/23 13:52, Zhu Yanjun wrote:
> > On Tue, May 23, 2023 at 1:44=E2=80=AFPM Guoqing Jiang <guoqing.jiang@li=
nux.dev> wrote:
> >>
> >>
> >> On 5/23/23 13:18, Zhu Yanjun wrote:
> >>> On Tue, May 23, 2023 at 1:08=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmail.=
com> wrote:
> >>>> On Tue, May 23, 2023 at 12:29=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmai=
l.com> wrote:
> >>>>> On Tue, May 23, 2023 at 12:10=E2=80=AFPM Guoqing Jiang <guoqing.jia=
ng@linux.dev> wrote:
> >>>>>>
> >>>>>> On 5/23/23 12:02, Zhu Yanjun wrote:
> >>>>>>> On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@g=
mail.com> wrote:
> >>>>>>>> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.=
jiang@linux.dev> wrote:
> >>>>>>>>> On 5/23/23 10:13, syzbot wrote:
> >>>>>>>>>> Hello,
> >>>>>>>>>>
> >>>>>>>>>> syzbot tried to test the proposed patch but the build/boot fai=
led:
> >>>>>>>>>>
> >>>>>>>>>> failed to apply patch:
> >>>>>>>>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> >>>>>>>>>> patch: **** unexpected end of file in patch
> >>>>>>>> This is not the root cause. The fix is not good.
> >>>>>>> This problem is about "INFO: trying to register non-static key. T=
he
> >>>>>>> code is fine but needs lockdep annotation, or maybe"
> >>>>> This warning is from "lock is not initialized". This is a
> >>>>> use-before-initialized problem.
> >>>>> The correct fix is to initialize the lock that is complained before=
 it is used.
> >>>>>
> >>>>> Zhu Yanjun
> >>>> Based on the call trace, the followings are the order of this call t=
race.
> >>>>
> >>>> 291 /* called by the create qp verb */
> >>>> 292 int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp,
> >>>> struct rxe_pd *pd,
> >>>> 297 {
> >>>>               ...
> >>>> 317         rxe_qp_init_misc(rxe, qp, init);
> >>>>               ...
> >>>> 322
> >>>> 323         err =3D rxe_qp_init_resp(rxe, qp, init, udata, uresp);
> >>>> 324         if (err)
> >>>> 325                 goto err2;   <--- error
> >>>>
> >>>>               ...
> >>>>
> >>>> 334 err2:
> >>>> 335         rxe_queue_cleanup(qp->sq.queue); <--- Goto here
> >>>> 336         qp->sq.queue =3D NULL;
> >>>>
> >>>> In rxe_qp_init_resp, the error occurs before skb_queue_head_init.
> >>>> So this call trace appeared.
> >>> 250 static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *q=
p,
> >>> 254 {
> >>>                           ...
> >>> 264
> >>> 265                 type =3D QUEUE_TYPE_FROM_CLIENT;
> >>> 266                 qp->rq.queue =3D rxe_queue_init(rxe, &qp->rq.max_=
wr,
> >>> 267                                         wqe_size, type);
> >>> 268                 if (!qp->rq.queue)
> >>> 269                         return -ENOMEM;    <---Error here
> >>> 270
> >>>
> >>> ...
> >>>
> >>> 282         skb_queue_head_init(&qp->resp_pkts); <-this is not called=
.
> >>> ...
> >>> This will make spin_lock of resp_pkts is used before initialized.
> >> IMHO, the above is same as
> >>
> >>> Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not call=
ed
> >>> given rxe_qp_init_resp returns error, but the cleanup still trigger t=
he
> >>> chain.
> >>>
> >>> rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts ->
> >>> skb_dequeue(&qp->resp_pkts)
> >> my previous analysis. If not, could you provide another better way to
> >> fix it?
> > Move the initialization to the beginning. This can fix this problem.
> > See below:
> >
> > "
> > diff --git a/drivers/infiniband/sw/rxe/rxe_qp.c
> > b/drivers/infiniband/sw/rxe/rxe_qp.c
> > index c5451a4488ca..22ef6188d7b1 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_qp.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_qp.c
> > @@ -176,6 +176,9 @@ static void rxe_qp_init_misc(struct rxe_dev *rxe,
> > struct rxe_qp *qp,
> >          spin_lock_init(&qp->rq.producer_lock);
> >          spin_lock_init(&qp->rq.consumer_lock);
> >
> > +       skb_queue_head_init(&qp->req_pkts);
> > +       skb_queue_head_init(&qp->resp_pkts);
> > +
> >          atomic_set(&qp->ssn, 0);
> >          atomic_set(&qp->skb_out, 0);
> >   }
> > @@ -234,8 +237,6 @@ static int rxe_qp_init_req(struct rxe_dev *rxe,
> > struct rxe_qp *qp,
> >          qp->req.opcode          =3D -1;
> >          qp->comp.opcode         =3D -1;
> >
> > -       skb_queue_head_init(&qp->req_pkts);
> > -
> >          rxe_init_task(&qp->req.task, qp, rxe_requester);
> >          rxe_init_task(&qp->comp.task, qp, rxe_completer);
> >
> > @@ -279,8 +280,6 @@ static int rxe_qp_init_resp(struct rxe_dev *rxe,
> > struct rxe_qp *qp,
> >                  }
> >          }
> >
> > -       skb_queue_head_init(&qp->resp_pkts);
> > -
> >          rxe_init_task(&qp->resp.task, qp, rxe_responder);
> >
> >          qp->resp.opcode         =3D OPCODE_NONE;
> > "
>
> It is weird to me that init them in init_misc instead of init_req/resp,
> given they
> are dedicated/used for the different purpose. But just my 0.02$.

There are some initialization problems in qp init. This needs
refactoring the related functions to fix all the problems.
Currently I am working on this. You know, this is not an easy task.
It will take me a lot of time and effort.
Now I use init_misc to initialize the related variables just as I did
in the past.
This is because init_misc is designed to initialize some variables.
And it will not cause the similar use-before-initialization problems.

Zhu Yanjun
>
> Guoqing

