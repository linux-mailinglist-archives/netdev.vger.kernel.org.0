Return-Path: <netdev+bounces-8014-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA8B7226BA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:00:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FB9B1C2095B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 000ED19512;
	Mon,  5 Jun 2023 13:00:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B5B6ABC
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:00:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A30D2
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685970033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bbubscZftjyRYYL2p4m/teVFWDkt0vBAkgkuXdu/w1E=;
	b=PaDyhoi5M2Wybz2aXAWRKa6Qow24lnGuV4raeaysBnOTf3r9uIHRze36Qw4RNK5QjOe64i
	FuhYZqZVXzL/QkIQySHwdHiTYzlBI8oPRyvovHUs/GMiAQb16luScqGGHI0E5eB/Kz8dNl
	FjalMmXDHQeU9usi0YDviduEOZ0+6oA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-sTg9Ob9rMrSzffRRpvd7aA-1; Mon, 05 Jun 2023 09:00:31 -0400
X-MC-Unique: sTg9Ob9rMrSzffRRpvd7aA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f739a73ba4so5280475e9.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685970030; x=1688562030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bbubscZftjyRYYL2p4m/teVFWDkt0vBAkgkuXdu/w1E=;
        b=U4EAaI0uuOA4cbgTRTz/okg5BjVxZiEJ7GohD8OR23qnMESTKsMQv6qb+/TGqC5qYI
         XnEL+GKYbw856c4m+qFc4G9N/pbVLteSLAg9MLc6lO+ok5PyYDk8mgCiQwmMz+qzdPbo
         x2YGw3s61l458J3MvaEdnbclJ1j2+dSzyUnfUCFxlFhqtt+fTw2eKnrLSaHWk4V5sj1m
         aiRLv++tmCKs52pAxVdOTktdC7L9+QOelLCBb6Jj4UH7guyOXc0ofbwnfNrViHwHP48q
         A3tqXL+91Uuc6I6hD4eGZHrLWVrqK+MZ3cKeiP/LPgSEfO8rzBziCAr80L0NevAqv8+1
         COEg==
X-Gm-Message-State: AC+VfDxKQZZ8OS9rWlib19MO//rHpkIO8iExWh2e7TLkBnjvJt+yF7QW
	7sl8xWsn+hrgQzvb3KtNF6/3YZ3EYoTNEuQ2s5qSNKH3u25W4EZfx/vThxKYx5cC91AbVN0EH01
	EnEVlJbhRVxabbLb7
X-Received: by 2002:a5d:4d4a:0:b0:30a:f1dd:dc55 with SMTP id a10-20020a5d4d4a000000b0030af1dddc55mr3686139wru.53.1685970029830;
        Mon, 05 Jun 2023 06:00:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6DD3cwjpmZBvtInHDuWJuM4v9sDwnhYfReDafcIwBsT4j0UbFV+PmO399VIFuafC8KUQM2Tg==
X-Received: by 2002:a5d:4d4a:0:b0:30a:f1dd:dc55 with SMTP id a10-20020a5d4d4a000000b0030af1dddc55mr3686125wru.53.1685970029458;
        Mon, 05 Jun 2023 06:00:29 -0700 (PDT)
Received: from redhat.com ([2.55.4.169])
        by smtp.gmail.com with ESMTPSA id p6-20020a056000018600b0030aefd11892sm9708331wrx.41.2023.06.05.06.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:00:28 -0700 (PDT)
Date: Mon, 5 Jun 2023 09:00:25 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605085840-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > don't support packed virtqueue well yet, so let's filter the
> > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > 
> > > This way, even if the device supports it, we don't risk it being
> > > negotiated, then the VMM is unable to set the vring state properly.
> > > 
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > > 
> > > Notes:
> > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > >     better PACKED support" series [1] and backported in stable branches.
> > > 
> > >     We can revert it when we are sure that everything is working with
> > >     packed virtqueues.
> > > 
> > >     Thanks,
> > >     Stefano
> > > 
> > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > 
> > I'm a bit lost here. So why am I merging "better PACKED support" then?
> 
> To really support packed virtqueue with vhost-vdpa, at that point we would
> also have to revert this patch.
> 
> I wasn't sure if you wanted to queue the series for this merge window.
> In that case do you think it is better to send this patch only for stable
> branches?
> > Does this patch make them a NOP?
> 
> Yep, after applying the "better PACKED support" series and being sure that
> the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> patch.
> 
> Let me know if you prefer a different approach.
> 
> I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> interprets them the right way, when it does not.
> 
> Thanks,
> Stefano
> 

If this fixes a bug can you add Fixes tags to each of them? Then it's ok
to merge in this window. Probably easier than the elaborate
mask/unmask dance.

> > 
> > >  drivers/vhost/vdpa.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > > index 8c1aefc865f0..ac2152135b23 100644
> > > --- a/drivers/vhost/vdpa.c
> > > +++ b/drivers/vhost/vdpa.c
> > > @@ -397,6 +397,12 @@ static long vhost_vdpa_get_features(struct vhost_vdpa *v, u64 __user *featurep)
> > > 
> > >  	features = ops->get_device_features(vdpa);
> > > 
> > > +	/*
> > > +	 * IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE) don't support
> > > +	 * packed virtqueue well yet, so let's filter the feature for now.
> > > +	 */
> > > +	features &= ~BIT_ULL(VIRTIO_F_RING_PACKED);
> > > +
> > >  	if (copy_to_user(featurep, &features, sizeof(features)))
> > >  		return -EFAULT;
> > > 
> > > 
> > > base-commit: 9561de3a55bed6bdd44a12820ba81ec416e705a7
> > > --
> > > 2.40.1
> > 


