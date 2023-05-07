Return-Path: <netdev+bounces-751-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D5596F98A8
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 15:34:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ECDE280EB4
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A443D87;
	Sun,  7 May 2023 13:34:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA27023CD
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 13:34:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052BB1248D
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 06:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683466453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65lQRJ+gv4EXk4uO01YGhnAV/eJrvV/vUJvZ5bnqIuQ=;
	b=SUqrfA/HiJnTfk63a/hV5ut5bxskMtolnasGYJc2C3Ltswg2Ek+Sa9pokexJ3a+uWJBOMw
	5bzSkzblF8QuBfL7pgq/PokTaBBvvUvOSCJpPrbPjHqB8dRkua/U1WZQD0DWwxuz84GlUI
	Yyqdp6/LA5ltnaRsIogjzG4sQbQ1FYg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-L842mEtQM6eCUJ-WcOF4aw-1; Sun, 07 May 2023 09:34:11 -0400
X-MC-Unique: L842mEtQM6eCUJ-WcOF4aw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f33f8ffa05so22227035e9.1
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 06:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683466450; x=1686058450;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=65lQRJ+gv4EXk4uO01YGhnAV/eJrvV/vUJvZ5bnqIuQ=;
        b=SpNiVIB1sEERV6aVrRNOCYDX+CqKef+cqlvKQCGijydUQ745/4TbSjXxXfIYRI0TUk
         WYMLb1YWLoXYfdjfqK9yXChpI849+3eaQhvX9j3kdxRRYJc2Lt096o279FIOWfCw4Xk+
         nxHSqyBtPOS322RQjhstqIm++1EM8hKFClnCOY979BUK9gmi+HKbkeD9Ne5mTK5B19ut
         IRWT+k+5k9/+h7vgAhkPfXDPCQDhy0D4L0QLGJiLli9fdB1f1jkwXtmj7+4IvSw3Yt/m
         F0ZFIFgTYcF4vUqi6XRnWd3BVR+5Tw9ldRiqvIdGBiWfKJnLbII4y4hfHP/wnT+C+A4g
         ZXXg==
X-Gm-Message-State: AC+VfDwtJLyjzSF24Cuk8V0BS0TX/AGyd1ipauBXL9JYsch81JIdwFEg
	O3k2ZGwBzVvr7tbh1GI+g+wHcbpUPOAuevbyEWv2ZI6/D0nKmTb1iSskUEUZLfvAgNdd28gLiYN
	VBK34l8gxa89YsrlW
X-Received: by 2002:a05:600c:28b:b0:3f4:2438:31c7 with SMTP id 11-20020a05600c028b00b003f4243831c7mr595362wmk.19.1683466450676;
        Sun, 07 May 2023 06:34:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dlYJQ5LxrwZA0O74DMJJmxxnf1OSnMdKKrqzXaZWy/VspuXbmfoua2VeVLQcpx7zhqb/0Fw==
X-Received: by 2002:a05:600c:28b:b0:3f4:2438:31c7 with SMTP id 11-20020a05600c028b00b003f4243831c7mr595347wmk.19.1683466450367;
        Sun, 07 May 2023 06:34:10 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id z17-20020a1c4c11000000b003ee20b4b2dasm13605868wmf.46.2023.05.07.06.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 06:34:09 -0700 (PDT)
Date: Sun, 7 May 2023 09:34:05 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230507093328-mutt-send-email-mst@kernel.org>
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 11:28:25AM +0800, Jason Wang wrote:
> On Thu, May 4, 2023 at 10:27 AM Wenliang Wang
> <wangwenliang.1995@bytedance.com> wrote:
> >
> > For multi-queue and large ring-size use case, the following error
> > occurred when free_unused_bufs:
> > rcu: INFO: rcu_sched self-detected stall on CPU.
> >
> > Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> > Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > ---
> > v2:
> > -add need_resched check.
> > -apply same logic to sq.
> > v3:
> > -use cond_resched instead.
> > v4:
> > -add fixes tag
> > ---
> >  drivers/net/virtio_net.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index 8d8038538fc4..a12ae26db0e2 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
> >                 struct virtqueue *vq = vi->sq[i].vq;
> >                 while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> >                         virtnet_sq_free_unused_buf(vq, buf);
> > +               cond_resched();
> 
> Does this really address the case when the virtqueue is very large?
> 
> Thanks


it does in that a very large queue is still just 64k in size.
we might however have 64k of these queues.

> >         }
> >
> >         for (i = 0; i < vi->max_queue_pairs; i++) {
> >                 struct virtqueue *vq = vi->rq[i].vq;
> >                 while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> >                         virtnet_rq_free_unused_buf(vq, buf);
> > +               cond_resched();
> >         }
> >  }
> >
> > --
> > 2.20.1
> >


