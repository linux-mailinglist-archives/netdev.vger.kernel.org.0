Return-Path: <netdev+bounces-814-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EB86FA01A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A55A280EF5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6069613AF6;
	Mon,  8 May 2023 06:47:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500F033E3
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:47:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E18283C5
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683528435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iPcE+tPXUEU9Pj6uvbRoX+sGl02xWP0SMsbFFZ3dcbg=;
	b=YFNOKMBsD5Bzpd6pPlLaYpcgz7E3wwQ/nuNw/phv4JQ7VHJUUIigynI2W/YWtCqe9fCNA2
	bB2tt0+ARGGvITydKiU3wYen1rYIj5mr1oBrHW0HFssHwlBdn0ZRszpBq/dbxGKoOTu19n
	KEmtIf+k0lz7aOL8KlFAis/hAadngB4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-Dn8L1cSjN5mCaNo0RJHquw-1; Mon, 08 May 2023 02:47:14 -0400
X-MC-Unique: Dn8L1cSjN5mCaNo0RJHquw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f321e60feaso15168705e9.0
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 23:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683528433; x=1686120433;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iPcE+tPXUEU9Pj6uvbRoX+sGl02xWP0SMsbFFZ3dcbg=;
        b=ATxuwksPruWFZeHUFXRbUHRHP9e7uQ3BB7toyFed3Rd2qnJKrxVgZJ8MLsqR24ST9y
         JriP3ulTC/LK2NfEzApyodEq5tjG9GGIlku//2IpW2pZpHG41N6Ab16R3sNwvNZMMV0r
         IcA6TWLYS0ps2PPElr1WShV+M4axwidD0QLJdg3BoVVe/r7tndgUzRNuYQqNKQ5oWIWA
         csagN3b3YVc/U8XntIxXbPJmFcO+Z9RjawKcNQ4R+moQ7XgI2ObmxxmUqxnoPQJSTD22
         Btf4Xkc5ZQpwizLuhQLBTqc5nvnrFa9p2UMGZgj+7GAGxXJbeb9x0eU67jPBOtrudu9I
         9k3Q==
X-Gm-Message-State: AC+VfDxW1USpMN/Nvu7UKj0/3SOtTrRyP1Smib/UszGqWZiADAPJiNre
	wMsYcV8EB7qgrNl0sCUTJUueff5KB9cdtcJ0YmTb9Rk0BKTV+EUc1dK/LX6p6jnKFrKKdpX/Fiz
	C0Nz6nZZkOCd2Hkpv
X-Received: by 2002:a1c:f704:0:b0:3f1:9526:22be with SMTP id v4-20020a1cf704000000b003f1952622bemr6095768wmh.23.1683528433437;
        Sun, 07 May 2023 23:47:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4vYeuFr5Bz2rslLpzPqeYDEDuyU1V6E3rGgoS88aNCbpJ9YMyQlWE3PZrEOwea2SRvN6MNbQ==
X-Received: by 2002:a1c:f704:0:b0:3f1:9526:22be with SMTP id v4-20020a1cf704000000b003f1952622bemr6095754wmh.23.1683528433143;
        Sun, 07 May 2023 23:47:13 -0700 (PDT)
Received: from redhat.com ([31.187.78.15])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c22c200b003f42328b5d9sm3729073wmg.39.2023.05.07.23.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 23:47:12 -0700 (PDT)
Date: Mon, 8 May 2023 02:47:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230508024433-mutt-send-email-mst@kernel.org>
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
 <20230507093328-mutt-send-email-mst@kernel.org>
 <2b5cf90a-efa8-52a7-9277-77722622c128@redhat.com>
 <20230508020717-mutt-send-email-mst@kernel.org>
 <CACGkMEuQdy8xi=eD4v7-UNQ12xOUdnuyQ73vvC6vdGXUfeasug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuQdy8xi=eD4v7-UNQ12xOUdnuyQ73vvC6vdGXUfeasug@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 02:13:42PM +0800, Jason Wang wrote:
> On Mon, May 8, 2023 at 2:08 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, May 08, 2023 at 11:12:03AM +0800, Jason Wang wrote:
> > >
> > > 在 2023/5/7 21:34, Michael S. Tsirkin 写道:
> > > > On Fri, May 05, 2023 at 11:28:25AM +0800, Jason Wang wrote:
> > > > > On Thu, May 4, 2023 at 10:27 AM Wenliang Wang
> > > > > <wangwenliang.1995@bytedance.com> wrote:
> > > > > > For multi-queue and large ring-size use case, the following error
> > > > > > occurred when free_unused_bufs:
> > > > > > rcu: INFO: rcu_sched self-detected stall on CPU.
> > > > > >
> > > > > > Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> > > > > > Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > > > > > ---
> > > > > > v2:
> > > > > > -add need_resched check.
> > > > > > -apply same logic to sq.
> > > > > > v3:
> > > > > > -use cond_resched instead.
> > > > > > v4:
> > > > > > -add fixes tag
> > > > > > ---
> > > > > >   drivers/net/virtio_net.c | 2 ++
> > > > > >   1 file changed, 2 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > > index 8d8038538fc4..a12ae26db0e2 100644
> > > > > > --- a/drivers/net/virtio_net.c
> > > > > > +++ b/drivers/net/virtio_net.c
> > > > > > @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
> > > > > >                  struct virtqueue *vq = vi->sq[i].vq;
> > > > > >                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > > > > >                          virtnet_sq_free_unused_buf(vq, buf);
> > > > > > +               cond_resched();
> > > > > Does this really address the case when the virtqueue is very large?
> > > > >
> > > > > Thanks
> > > >
> > > > it does in that a very large queue is still just 64k in size.
> > > > we might however have 64k of these queues.
> > >
> > >
> > > Ok, but we have other similar loops especially the refill, I think we may
> > > need cond_resched() there as well.
> > >
> > > Thanks
> > >
> >
> > Refill is already per vq isn't it?
> 
> Not for the refill_work().
> 
> Thanks

Good point, refill_work probably needs cond_resched, too.
And I guess virtnet_open?


> >
> >
> > > >
> > > > > >          }
> > > > > >
> > > > > >          for (i = 0; i < vi->max_queue_pairs; i++) {
> > > > > >                  struct virtqueue *vq = vi->rq[i].vq;
> > > > > >                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > > > > >                          virtnet_rq_free_unused_buf(vq, buf);
> > > > > > +               cond_resched();
> > > > > >          }
> > > > > >   }
> > > > > >
> > > > > > --
> > > > > > 2.20.1
> > > > > >
> >


