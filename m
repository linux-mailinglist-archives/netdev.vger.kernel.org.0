Return-Path: <netdev+bounces-785-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E56F46F9F67
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68178280E98
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3A013ADF;
	Mon,  8 May 2023 06:08:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023A5125DB
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 06:08:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E23E150E7
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 23:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683526084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=496riEt70CLjVEPXxKBFIzM6DccwKHKgAN0XgS7K+xk=;
	b=WU3MR5nPwyORCS4PDfIDUkkSu3M9zLSEngYD76mv+AO7vSBezbqusIT1qIq9bMi+o9Kni5
	eJ3KJa3nYJ5lajV9cBqiMcdG3l1G1jJ1ruJgT8Z+O5JdUVuqBJwkdEMM3rLmJSk4goWcHm
	Es7bUys3H2Xczgetv6iWj1C9fC2+xAs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-397-pjv908yINAqGnSVou2vLYQ-1; Mon, 08 May 2023 02:08:03 -0400
X-MC-Unique: pjv908yINAqGnSVou2vLYQ-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3064d0b726fso1367379f8f.0
        for <netdev@vger.kernel.org>; Sun, 07 May 2023 23:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683526082; x=1686118082;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=496riEt70CLjVEPXxKBFIzM6DccwKHKgAN0XgS7K+xk=;
        b=cVQzX2TqO7m4Ek3FQGz3/w6B8vbz9k5Y2gfap67V5y6E0X6fz8zdF/ZzbxKJ6D4mRx
         /t2l40vYNoBG6aiAtcFiYHeB2JJCOBFhBlCz18TAf9OFIeX9kzvGpL1zMl2Ja/OEtEse
         4ZnQemSwuagPrA+7UspqgUrtMzm84S65QrZT5h5mAbBVOQ9qokx6B1/oo8ssI+JCjf7X
         OwIaK17KG6LR5wzyCCZOWkxSEewTItyRvKmKgnQbPuxosrZjHX5ZwbWOgfQCeQvrVylR
         S4m21rqPjkXypkWaOlzUuW1h3wYjOSFuWmRlCCJwWNxyOi1Co/B81txPmSxZflFS1u3L
         MtOg==
X-Gm-Message-State: AC+VfDx/Uy/9LChLezmDiSR9KZTckhlRy71eebX7qCKzIGpU/L03MjzD
	TAd5uLeeSOpwVKhXlKQfDvqDPr5Z7N7PbNhstQ9E2ki5JiZOELYaXolXBXMxtr+t60POgPHe96l
	U5CigmwAihOVMXEPZTRL+/bh2
X-Received: by 2002:a5d:6801:0:b0:306:2b64:fd1b with SMTP id w1-20020a5d6801000000b003062b64fd1bmr6387829wru.52.1683526082131;
        Sun, 07 May 2023 23:08:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7f8poeeWKuFbkFRFraXJPQPQU8mq+PdFxmJfqKohdU/FLK+Ng7mCXc+1OoWwdFP0rxufKFDA==
X-Received: by 2002:a5d:6801:0:b0:306:2b64:fd1b with SMTP id w1-20020a5d6801000000b003062b64fd1bmr6387812wru.52.1683526081830;
        Sun, 07 May 2023 23:08:01 -0700 (PDT)
Received: from redhat.com ([2.52.158.28])
        by smtp.gmail.com with ESMTPSA id k15-20020a5d428f000000b003062d815fa6sm10182362wrq.85.2023.05.07.23.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 May 2023 23:08:01 -0700 (PDT)
Date: Mon, 8 May 2023 02:07:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Wenliang Wang <wangwenliang.1995@bytedance.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	zhengqi.arch@bytedance.com, willemdebruijn.kernel@gmail.com,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH v4] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230508020717-mutt-send-email-mst@kernel.org>
References: <1683167226-7012-1-git-send-email-wangwenliang.1995@bytedance.com>
 <CACGkMEs_4kUzc6iSBWvhZA1+U70Pp0o+WhE0aQnC-5pECW7QXA@mail.gmail.com>
 <20230507093328-mutt-send-email-mst@kernel.org>
 <2b5cf90a-efa8-52a7-9277-77722622c128@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b5cf90a-efa8-52a7-9277-77722622c128@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 11:12:03AM +0800, Jason Wang wrote:
> 
> 在 2023/5/7 21:34, Michael S. Tsirkin 写道:
> > On Fri, May 05, 2023 at 11:28:25AM +0800, Jason Wang wrote:
> > > On Thu, May 4, 2023 at 10:27 AM Wenliang Wang
> > > <wangwenliang.1995@bytedance.com> wrote:
> > > > For multi-queue and large ring-size use case, the following error
> > > > occurred when free_unused_bufs:
> > > > rcu: INFO: rcu_sched self-detected stall on CPU.
> > > > 
> > > > Fixes: 986a4f4d452d ("virtio_net: multiqueue support")
> > > > Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>
> > > > ---
> > > > v2:
> > > > -add need_resched check.
> > > > -apply same logic to sq.
> > > > v3:
> > > > -use cond_resched instead.
> > > > v4:
> > > > -add fixes tag
> > > > ---
> > > >   drivers/net/virtio_net.c | 2 ++
> > > >   1 file changed, 2 insertions(+)
> > > > 
> > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > index 8d8038538fc4..a12ae26db0e2 100644
> > > > --- a/drivers/net/virtio_net.c
> > > > +++ b/drivers/net/virtio_net.c
> > > > @@ -3560,12 +3560,14 @@ static void free_unused_bufs(struct virtnet_info *vi)
> > > >                  struct virtqueue *vq = vi->sq[i].vq;
> > > >                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > > >                          virtnet_sq_free_unused_buf(vq, buf);
> > > > +               cond_resched();
> > > Does this really address the case when the virtqueue is very large?
> > > 
> > > Thanks
> > 
> > it does in that a very large queue is still just 64k in size.
> > we might however have 64k of these queues.
> 
> 
> Ok, but we have other similar loops especially the refill, I think we may
> need cond_resched() there as well.
> 
> Thanks
> 

Refill is already per vq isn't it?


> > 
> > > >          }
> > > > 
> > > >          for (i = 0; i < vi->max_queue_pairs; i++) {
> > > >                  struct virtqueue *vq = vi->rq[i].vq;
> > > >                  while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
> > > >                          virtnet_rq_free_unused_buf(vq, buf);
> > > > +               cond_resched();
> > > >          }
> > > >   }
> > > > 
> > > > --
> > > > 2.20.1
> > > > 


