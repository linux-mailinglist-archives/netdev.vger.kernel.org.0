Return-Path: <netdev+bounces-4530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB9470D320
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A5151C20C39
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ED671B8EF;
	Tue, 23 May 2023 05:18:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A98816421
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 05:18:46 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8C8FA;
	Mon, 22 May 2023 22:18:44 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96f6a9131fdso628332566b.1;
        Mon, 22 May 2023 22:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684819123; x=1687411123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWon3XOer///EpYOeNOCuppT1Gx0RQBd4QqlEexGDfE=;
        b=fLxWh82riN/RSp+9VdFowelr3fjNCE8v1bNYv1x53IS/bOiIuHgpGcY4yZYfYtubvG
         6EtIJNWt2bqLH2E7DoauJgDNpy0g7q1jOIH/qWOuaL7EhzFn7Gke0ZaNZ5b9fUiz5S1T
         gQDh7lLxAg0gBp36DrvBqlTqWKy1eZgpBX9jsgb7E3bOeVg1iqkXGMmw5xJh/+LToheT
         AszPbt+2Q59iBPCMyiAbCm8n6FvHcoReRxh1baaBYdoes4Ij14ATQCTR80oXY1Kl7bqi
         VFHuBuGp1lzQWvEJHhvYqJ6zYmJaHaqrMAfeNTLYndgu7OdWm07cpAXh6MStXics5f+q
         pkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684819123; x=1687411123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWon3XOer///EpYOeNOCuppT1Gx0RQBd4QqlEexGDfE=;
        b=SezxgLVInPzyTAWkSjWRh7ZoI4KGdD0KWaB3+TbJ9LhXYQG+JgJjH4kt4i/pVLZYLe
         RvONFwjhc3Puqa5LgRI38w7keTU5K+V9QDP/8Fk/Cm1ORBRCCOCsj3W0UkvK60Afia8f
         PZImByT3petfHwOPupnNeJo0RfJFQuFO1Ci7BOvkgapUiNi+hjyGtbsZtLs3RwdLbRqF
         8o38WXzPmKWc7mTH+1wZ5eMCclfNiMMjpJuhyvcw/Jlh3MxQgGvoiV3a9Vtz8phRCdeq
         tlTvvKUcce7+Lk9koodG1dakjhkcjW8MrVPxkPyxXXet9AdgOl88v4H+idu+ZbiCKkkU
         f2gw==
X-Gm-Message-State: AC+VfDzxD11juOXIvCKmDnD9oK1ZBmfidoNRJwvFLk7DCaAtvpVZsnhL
	tp4uuBLwq7uydEc1AzqxbKDp6mIsQy/aB/HNn+o=
X-Google-Smtp-Source: ACHHUZ7NX01XYphonSTPdlJWziIbbT/pDO/tEN08zfHyvBAeazAbDgXn6aqJ8pN20GBGIGSbWeVT1zxJorwexS3YGrw=
X-Received: by 2002:a17:907:a4c:b0:94e:e30e:7245 with SMTP id
 be12-20020a1709070a4c00b0094ee30e7245mr9525973ejc.8.1684819123106; Mon, 22
 May 2023 22:18:43 -0700 (PDT)
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
In-Reply-To: <CAD=hENdXdqfcxjNrNnP8CoaDy6sUJ4g5uxcWE0mj3HtNohDUzw@mail.gmail.com>
From: Zhu Yanjun <zyjzyj2000@gmail.com>
Date: Tue, 23 May 2023 13:18:30 +0800
Message-ID: <CAD=hENda4MxgEsgT-GUhYHH66m79wi8yxBQS8CYnxc_DsQKGwg@mail.gmail.com>
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

On Tue, May 23, 2023 at 1:08=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmail.com> w=
rote:
>
> On Tue, May 23, 2023 at 12:29=E2=80=AFPM Zhu Yanjun <zyjzyj2000@gmail.com=
> wrote:
> >
> > On Tue, May 23, 2023 at 12:10=E2=80=AFPM Guoqing Jiang <guoqing.jiang@l=
inux.dev> wrote:
> > >
> > >
> > >
> > > On 5/23/23 12:02, Zhu Yanjun wrote:
> > > > On Tue, May 23, 2023 at 11:47=E2=80=AFAM Zhu Yanjun <zyjzyj2000@gma=
il.com> wrote:
> > > >> On Tue, May 23, 2023 at 10:26=E2=80=AFAM Guoqing Jiang <guoqing.ji=
ang@linux.dev> wrote:
> > > >>>
> > > >>>
> > > >>> On 5/23/23 10:13, syzbot wrote:
> > > >>>> Hello,
> > > >>>>
> > > >>>> syzbot tried to test the proposed patch but the build/boot faile=
d:
> > > >>>>
> > > >>>> failed to apply patch:
> > > >>>> checking file drivers/infiniband/sw/rxe/rxe_qp.c
> > > >>>> patch: **** unexpected end of file in patch
> > > >> This is not the root cause. The fix is not good.
> > > > This problem is about "INFO: trying to register non-static key. The
> > > > code is fine but needs lockdep annotation, or maybe"
> >
> > This warning is from "lock is not initialized". This is a
> > use-before-initialized problem.
> > The correct fix is to initialize the lock that is complained before it =
is used.
> >
> > Zhu Yanjun
>
> Based on the call trace, the followings are the order of this call trace.
>
> 291 /* called by the create qp verb */
> 292 int rxe_qp_from_init(struct rxe_dev *rxe, struct rxe_qp *qp,
> struct rxe_pd *pd,
> 297 {
>             ...
> 317         rxe_qp_init_misc(rxe, qp, init);
>             ...
> 322
> 323         err =3D rxe_qp_init_resp(rxe, qp, init, udata, uresp);
> 324         if (err)
> 325                 goto err2;   <--- error
>
>             ...
>
> 334 err2:
> 335         rxe_queue_cleanup(qp->sq.queue); <--- Goto here
> 336         qp->sq.queue =3D NULL;
>
> In rxe_qp_init_resp, the error occurs before skb_queue_head_init.
> So this call trace appeared.

250 static int rxe_qp_init_resp(struct rxe_dev *rxe, struct rxe_qp *qp,
254 {
                        ...
264
265                 type =3D QUEUE_TYPE_FROM_CLIENT;
266                 qp->rq.queue =3D rxe_queue_init(rxe, &qp->rq.max_wr,
267                                         wqe_size, type);
268                 if (!qp->rq.queue)
269                         return -ENOMEM;    <---Error here
270

...

282         skb_queue_head_init(&qp->resp_pkts); <-this is not called.
...
This will make spin_lock of resp_pkts is used before initialized.

Zhu Yanjun
>
> Zhu Yanjun
>
> > >
> > > Which is caused by  "skb_queue_head_init(&qp->resp_pkts)" is not call=
ed
> > > given rxe_qp_init_resp returns error, but the cleanup still trigger t=
he
> > > chain.
> > >
> > > rxe_qp_do_cleanup -> rxe_completer -> drain_resp_pkts ->
> > > skb_dequeue(&qp->resp_pkts)
> > >
> > > But I might misunderstood it ...
> > >
> > > Thanks,
> > > Guoqing

