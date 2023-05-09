Return-Path: <netdev+bounces-1028-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E116FBD8F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 05:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54F391C20AA0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 03:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370C8137A;
	Tue,  9 May 2023 03:14:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFED392
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:14:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9DE1BE6
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 20:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683602085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ld87/slb6DhEyhzdo2ZLKHyFwRbfschMCykFI8qBdcQ=;
	b=fwlzHOUeXMk3Y1GwQpQIwPzLzrSbbhREt0TmfqEiELf6bBkuJ3T/Ftuv5b+N3sB7iCZ+S+
	r5mGOTeoECkosofODBDxIYGenbRi0ELs2Lo3aWBYQF2sTXsjwvcYws6aGb7dZKqoRTOg3X
	3mlfh1zx7IZsF0g8WohT4qcv0FdbUkA=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-9mEXhPGJP2Sp_LoQ5hRLbw-1; Mon, 08 May 2023 23:14:43 -0400
X-MC-Unique: 9mEXhPGJP2Sp_LoQ5hRLbw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2ad8df9f9a8so11037801fa.1
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 20:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683602082; x=1686194082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ld87/slb6DhEyhzdo2ZLKHyFwRbfschMCykFI8qBdcQ=;
        b=Ka+QR4DQfBOlzTr/8jnH64LnyHNXAxydpo03zfrxUBhFbCWT1gQ4IAFQNkY4u4OBcp
         ozN6BHLaPsujL5j0e1M8jTKn7yRUA/RRzPgQ+Us2gwEqImXSFMC7rVSAePFXExX9B84i
         Jz9ZnsunNBIBLRR5dyNlp/ZBZ2U71mocV5Fyk2lk+/dtQAXEFdd83h2IfHfphhwmt1vS
         kstTNJer6ZRvqRgfX6u5sI1MTRFLriARd5wTnZBG/Bdw99CIcZftUzcPeS+HFk4k5F3M
         DyacmlJlcY+1mtnH3J7EvmIUGMQKH46BcKWBjrDa7FdzgLwMwK7wwso8K/CVCmeFF/7D
         9F1g==
X-Gm-Message-State: AC+VfDzICRddLILUluNFpx1IECilSJUKDcPTXzMIDAaNL0en+7rCZXHV
	Ilque+r0cH+ug7R7C3J+PdhU8N8MRgwuEqi+86K0+9fCmzE9WkexLaiTdDhg/rvhm2/pnfXnh32
	/xua1iUMsJRhxXwh9pL3RWdOr0DlvJwAc
X-Received: by 2002:a2e:b709:0:b0:2a7:b0b4:4fa with SMTP id j9-20020a2eb709000000b002a7b0b404famr347562ljo.12.1683602082261;
        Mon, 08 May 2023 20:14:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ79eiCfzLyk9Oyqt17OGFinhWOXT+nm7R+MDoGAfwhOe5u+yBG9Ddqg3s68GG6hamkZC0LkhQFQeQghV6pd5tQ=
X-Received: by 2002:a2e:b709:0:b0:2a7:b0b4:4fa with SMTP id
 j9-20020a2eb709000000b002a7b0b404famr347548ljo.12.1683602081962; Mon, 08 May
 2023 20:14:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
 <20230507093328-mutt-send-email-mst@kernel.org> <2b5cf90a-efa8-52a7-9277-77722622c128@redhat.com>
 <20230508020717-mutt-send-email-mst@kernel.org> <CACGkMEuQdy8xi=eD4v7-UNQ12xOUdnuyQ73vvC6vdGXUfeasug@mail.gmail.com>
 <20230508024433-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230508024433-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 9 May 2023 11:14:30 +0800
Message-ID: <CACGkMEuYcR21_k0hyisWzTVHG4+a3Y=ym101Z5P8TSWyNkHWxA@mail.gmail.com>
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 2:47=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Mon, May 08, 2023 at 02:13:42PM +0800, Jason Wang wrote:
> > On Mon, May 8, 2023 at 2:08=E2=80=AFPM Michael S. Tsirkin <mst@redhat.c=
om> wrote:
> > >
> > > On Mon, May 08, 2023 at 11:12:03AM +0800, Jason Wang wrote:
> > > >
> > > > =E5=9C=A8 2023/5/7 21:34, Michael S. Tsirkin =E5=86=99=E9=81=93:
> > > > > On Fri, May 05, 2023 at 11:28:25AM +0800, Jason Wang wrote:
> > > > > > On Thu, May 4, 2023 at 10:27=E2=80=AFAM Wenliang Wang
> > > > > > <wangwenliang.1995@bytedance.com> wrote:
> > > > > > > For multi-queue and large ring-size use case, the following e=
rror
> > > > > > > occurred when free_unused_bufs:
> > > > > > > rcu: INFO: rcu_sched self-detected stall on CPU.
> > > > > > >
> > > > > > > Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> > > > > > > Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com=
>
> > > > > > > ---
> > > > > > > v2:
> > > > > > > -add need_resched check.
> > > > > > > -apply same logic to sq.
> > > > > > > v3:
> > > > > > > -use cond_resched instead.
> > > > > > > v4:
> > > > > > > -add fixes tag
> > > > > > > ---
> > > > > > >   drivers/net/virtio_net.c | 2 ++
> > > > > > >   1 file changed, 2 insertions(+)
> > > > > > >
> > > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_ne=
t.c
> > > > > > > index 8d8038538fc4..a12ae26db0e2 100644
> > > > > > > --- a/drivers/net/virtio_net.c
> > > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > > @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct v=
irtnet_info *vi)
> > > > > > >                  struct virtqueue *vq =3D vi->sq[i].vq;
> > > > > > >                  while ((buf =3D virtqueue_detach_unused_buf(=
vq)) !=3D NULL)
> > > > > > >                          virtnet_sq_free_unused_buf(vq, buf);
> > > > > > > +               cond_resched();
> > > > > > Does this really address the case when the virtqueue is very la=
rge?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > it does in that a very large queue is still just 64k in size.
> > > > > we might however have 64k of these queues.
> > > >
> > > >
> > > > Ok, but we have other similar loops especially the refill, I think =
we may
> > > > need cond_resched() there as well.
> > > >
> > > > Thanks
> > > >
> > >
> > > Refill is already per vq isn't it?
> >
> > Not for the refill_work().
> >
> > Thanks
>
> Good point, refill_work probably needs cond_resched, too.
> And I guess virtnet_open?

Yes, let me draft a patch.

Thanks

>
>
> > >
> > >
> > > > >
> > > > > > >          }
> > > > > > >
> > > > > > >          for (i =3D 0; i < vi->max_queue_pairs; i++) {
> > > > > > >                  struct virtqueue *vq =3D vi->rq[i].vq;
> > > > > > >                  while ((buf =3D virtqueue_detach_unused_buf(=
vq)) !=3D NULL)
> > > > > > >                          virtnet_rq_free_unused_buf(vq, buf);
> > > > > > > +               cond_resched();
> > > > > > >          }
> > > > > > >   }
> > > > > > >
> > > > > > > --
> > > > > > > 2.20.1
> > > > > > >
> > >
>


