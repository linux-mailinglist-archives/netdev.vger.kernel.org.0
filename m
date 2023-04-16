Return-Path: <netdev+bounces-186-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E510D6F5BC1
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:09:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 304EB2816A4
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:09:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C32107BF;
	Wed,  3 May 2023 16:09:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F1DD2F7
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 16:09:00 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2456A6EB6;
	Wed,  3 May 2023 09:08:56 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-7512da2d994so249177385a.2;
        Wed, 03 May 2023 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683130135; x=1685722135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UBlYzxwGsBqzQjKQLLHpIxV7OVXNorW8b0KsGQQ+08Q=;
        b=BvVd9tVSovuazzkUJWkaaFEfs66ykjepvKN3kFWlBkgQ5oc+DRZCjz8k10Cax49BHE
         Rd146nnmpyneR72rY33CbwceRXhLTQzN3DAQCKHeigyzn+v/Q0/fYfGATkHqZUFdsC4i
         cah46llk3pLjug+21T1ldE1IWoasQAJdHmDQkp8iT+729xlaIuI0ecFJactF3fKJ3jMW
         FZvbzGgID2WOLS3hDg/SDiMqlVmY6SMge6LMvJB+2yopEbAJHVe4i4LkB65uz5IaQXEj
         +T8aZ38mzVAgoTORi2ovpicpy6B2H49jNzbaesomqFWGXvNZEw/4owDghqG8KJnrr9VI
         5CMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683130135; x=1685722135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UBlYzxwGsBqzQjKQLLHpIxV7OVXNorW8b0KsGQQ+08Q=;
        b=juD4zJ1SULlnUPkVOKfqdXOHq/MDVn20zan62aNZ/U2S4mJJRl3EfeHp2GLMBbz/os
         NVOgICxMRuAzj08cD3qJD8WYQsehl0XrzcsmJ5S31bhcE47Fts5Qfy9qmTnvFpgLoCv9
         GgFa24bYSHZEIKiVtQ1d5rZT8gRpTevITfNisGUFlyUqb4MiOFjBcYqUiDgaHs2ee4PL
         A8OcxwuRB1VBc3RjcQca0BHQknzUcdt9OeQf0uu8m0Ie/PCTay2RGyUrdeViyKTbPLbh
         wyEyti6LLciKE9XfbhYTsJJuO3/DAx/u43SD6NiUWjIEcQM2uKD5Tg0Uz5mf0MRsyNzL
         FcwQ==
X-Gm-Message-State: AC+VfDx46pyxxFma/mcIR7RvElcvLREKptdyjtHssyafBs2uCAjbpBpU
	YhmdArNglSUwsGaQOH3xPoEOfGLUQl//QTW7Z1E=
X-Google-Smtp-Source: ACHHUZ7an2EVmUCSUz+eMDflGDqKQMO/JDa11APs2mLziI3jVbhHE9emVqq/+N2Z12XcQpX2nxYVsA==
X-Received: by 2002:a05:6214:494:b0:61b:7bac:aeb7 with SMTP id pt20-20020a056214049400b0061b7bacaeb7mr1870406qvb.40.1683130134978;
        Wed, 03 May 2023 09:08:54 -0700 (PDT)
Received: from localhost (151.240.142.34.bc.googleusercontent.com. [34.142.240.151])
        by smtp.gmail.com with ESMTPSA id u24-20020a0cb418000000b0061b698e2acesm1555599qve.18.2023.05.03.09.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 09:08:54 -0700 (PDT)
Date: Sun, 16 Apr 2023 06:40:45 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <ZDuYbUatimaNsELh@bullseye>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
 <ZDt+PDtKlxrwUPnc@bullseye>
 <20230503133913.GF757667@fedora>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230503133913.GF757667@fedora>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 03, 2023 at 09:39:13AM -0400, Stefan Hajnoczi wrote:
> On Sun, Apr 16, 2023 at 04:49:00AM +0000, Bobby Eshleman wrote:
> > On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
> > > On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > 
> > > > When virtqueue_add_sgs() fails, the skb is put back to send queue,
> > > > we should not deliver the copy to tap device in this case. So we
> > > > need to move virtio_transport_deliver_tap_pkt() down after all
> > > > possible failures.
> > > > 
> > > > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> > > > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > > > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > > > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > > > ---
> > > >  net/vmw_vsock/virtio_transport.c | 5 ++---
> > > >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > > index e95df847176b..055678628c07 100644
> > > > --- a/net/vmw_vsock/virtio_transport.c
> > > > +++ b/net/vmw_vsock/virtio_transport.c
> > > > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> > > >  		if (!skb)
> > > >  			break;
> > > >  
> > > > -		virtio_transport_deliver_tap_pkt(skb);
> > > > -		reply = virtio_vsock_skb_reply(skb);
> > > > -
> > > >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> > > >  		sgs[out_sg++] = &hdr;
> > > >  		if (skb->len > 0) {
> > > > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> > > >  			break;
> > > >  		}
> > > >  
> > > > +		virtio_transport_deliver_tap_pkt(skb);
> > > > +		reply = virtio_vsock_skb_reply(skb);
> > > 
> > > I don't remember the reason for the ordering, but I'm pretty sure it was
> > > deliberate. Probably because the payload buffers could be freed as soon
> > > as virtqueue_add_sgs() is called.
> > > 
> > > If that's no longer true with Bobby's skbuff code, then maybe it's safe
> > > to monitor packets after they have been sent.
> > > 
> > > Stefan
> > 
> > Hey Stefan,
> > 
> > Unfortunately, skbuff doesn't change that behavior.
> > 
> > If I understand correctly, the problem flow you are describing
> > would be something like this:
> > 
> > Thread 0 			Thread 1
> > guest:virtqueue_add_sgs()[@send_pkt_work]
> > 
> > 				host:vhost_vq_get_desc()[@handle_tx_kick]
> > 				host:vhost_add_used()
> > 				host:vhost_signal()
> > 				guest:virtqueue_get_buf()[@tx_work]
> > 				guest:consume_skb()
> > 
> > guest:deliver_tap_pkt()[@send_pkt_work]
> > ^ use-after-free
> > 
> > Which I guess is possible because the receiver can consume the new
> > scatterlist during the processing kicked off for a previous batch?
> > (doesn't have to wait for the subsequent kick)
> 
> Yes, drivers must assume that the device completes request before
> virtqueue_add_sgs() returns. For example, the device is allowed to poll
> the virtqueue memory and may see the new descriptors immediately.
> 
> I haven't audited the current vsock code path to determine whether it's
> possible to reach consume_skb() before deliver_tap_pkt() returns, so I
> can't say whether it's safe or not.
> 

I see, thanks for the clarification.

Best,
Bobby

