Return-Path: <netdev+bounces-26-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71A906F4C4F
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 23:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38FF280CE1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 21:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF79AD4C;
	Tue,  2 May 2023 21:39:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9F19472
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 21:39:51 +0000 (UTC)
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE67170B;
	Tue,  2 May 2023 14:39:50 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso3338978b3a.0;
        Tue, 02 May 2023 14:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683063590; x=1685655590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cev0eINesUcgFuY/+/ktONQEwCD+ajN6dFmAU85irpU=;
        b=Zh/KZ1iOTO5CbX9tPiWo6OhZT3KO8KkgtV43BCj/1O45mn9L8ETTMX7bGq+A6CaXMc
         N+iPbgCjN5PSJK6VDR4J1ODpyJiW8nFDF+9x2na+6VPgAxO8jmBT/MJM9U7EkDYJzIGZ
         zzcbgJUk2lzPifFTwvEj+WN3ZlGtxCFOAUfb5NgKlBsDMUeDaIC8PGHKMHimxDZMUomp
         uVyfbddnWZUrZoVS11uK3bQEA1wZS9qq9E+U7xZinS+K7Xb1hnUgLu5d8oUoX7ZNLuzT
         T1nD1MA8g5wRN/cRJERDq03WolXEDD/MiiDgY6lJ3p5T0MWf/WxDjzZJu0ERVMYcZn4B
         aAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683063590; x=1685655590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cev0eINesUcgFuY/+/ktONQEwCD+ajN6dFmAU85irpU=;
        b=BPXp5jeunthj1tA3XsqhCcb3X1g6Xn3XLl4yuVxh01WRw3yGXPHN0Zp0iP+1RqIYM/
         NxzwJHXKM5TIT40xG1mRL1IraA+Fl0WQ01kz9e6rAaaezOlMpyvb67P3eQ69WIIkj1Ta
         0el2RKlaKux26A+Y7uK2m80Nsm8rslKzj6DCpnYfuFJYUJ4+Ncz9ewx2tOqvOJzG4QbS
         fz6jBd6nrCJMhn8usHcpzVnneJ+vT8eWKKfTcLOvtXpNQri3CcdWMrYcE83EZgy8x03M
         bRLvS/T9AWOGNTh5CKCaMIP4VZVyJo7y/5l2i5qzdkcHT0xWp4F2Efzfl9VygxypAF+u
         +R8g==
X-Gm-Message-State: AC+VfDzCVzE59ljUYXFy+FgdMgMrBRoztfvYMjGQMEgDoZBi0GWJpAJn
	zDv8dIuLUiBbSxaxho3hPQ8=
X-Google-Smtp-Source: ACHHUZ6/hi6aJ3CJ23mHvv5dwtWHavAR33ucxmynXxFM7m7Oae5d3++pThSMJUdACqyaOKy8GNHwoA==
X-Received: by 2002:a05:6a00:2347:b0:643:96e:666b with SMTP id j7-20020a056a00234700b00643096e666bmr1045577pfj.34.1683063589508;
        Tue, 02 May 2023 14:39:49 -0700 (PDT)
Received: from localhost (ec2-52-9-159-93.us-west-1.compute.amazonaws.com. [52.9.159.93])
        by smtp.gmail.com with ESMTPSA id e9-20020a056a001a8900b00640e14330d8sm15044640pfv.28.2023.05.02.14.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 14:39:49 -0700 (PDT)
Date: Sun, 16 Apr 2023 04:49:00 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
	Cong Wang <cong.wang@bytedance.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [Patch net] vsock: improve tap delivery accuracy
Message-ID: <ZDt+PDtKlxrwUPnc@bullseye>
References: <20230502174404.668749-1-xiyou.wangcong@gmail.com>
 <20230502201418.GG535070@fedora>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502201418.GG535070@fedora>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 04:14:18PM -0400, Stefan Hajnoczi wrote:
> On Tue, May 02, 2023 at 10:44:04AM -0700, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> > 
> > When virtqueue_add_sgs() fails, the skb is put back to send queue,
> > we should not deliver the copy to tap device in this case. So we
> > need to move virtio_transport_deliver_tap_pkt() down after all
> > possible failures.
> > 
> > Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > Cc: Stefano Garzarella <sgarzare@redhat.com>
> > Cc: Bobby Eshleman <bobby.eshleman@bytedance.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
> >  net/vmw_vsock/virtio_transport.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > index e95df847176b..055678628c07 100644
> > --- a/net/vmw_vsock/virtio_transport.c
> > +++ b/net/vmw_vsock/virtio_transport.c
> > @@ -109,9 +109,6 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> >  		if (!skb)
> >  			break;
> >  
> > -		virtio_transport_deliver_tap_pkt(skb);
> > -		reply = virtio_vsock_skb_reply(skb);
> > -
> >  		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
> >  		sgs[out_sg++] = &hdr;
> >  		if (skb->len > 0) {
> > @@ -128,6 +125,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> >  			break;
> >  		}
> >  
> > +		virtio_transport_deliver_tap_pkt(skb);
> > +		reply = virtio_vsock_skb_reply(skb);
> 
> I don't remember the reason for the ordering, but I'm pretty sure it was
> deliberate. Probably because the payload buffers could be freed as soon
> as virtqueue_add_sgs() is called.
> 
> If that's no longer true with Bobby's skbuff code, then maybe it's safe
> to monitor packets after they have been sent.
> 
> Stefan

Hey Stefan,

Unfortunately, skbuff doesn't change that behavior.

If I understand correctly, the problem flow you are describing
would be something like this:

Thread 0 			Thread 1
guest:virtqueue_add_sgs()[@send_pkt_work]

				host:vhost_vq_get_desc()[@handle_tx_kick]
				host:vhost_add_used()
				host:vhost_signal()
				guest:virtqueue_get_buf()[@tx_work]
				guest:consume_skb()

guest:deliver_tap_pkt()[@send_pkt_work]
^ use-after-free

Which I guess is possible because the receiver can consume the new
scatterlist during the processing kicked off for a previous batch?
(doesn't have to wait for the subsequent kick)

Best,
Bobby

