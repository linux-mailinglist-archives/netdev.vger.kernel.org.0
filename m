Return-Path: <netdev+bounces-8080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A89722A13
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C101280FFD
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E337F1F16E;
	Mon,  5 Jun 2023 14:56:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785910FB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:56:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA24DF4
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685977002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iM7FqUtZoblM2J1vfVR4GtdyLSINqEtLQvkMkp8oaNA=;
	b=HmLcKQwlB/y3tWxgbZXxkssRTQOgsBaf5TpixlHGtpWkw9Yg2mqA1r1AHxNyzIeBMzFfAf
	Aox+HV59/Ow7QDFfBFSqY7XjExdMoaZGMiQWzZMGgT4q7GbzKXLgN3QpkEBxLoab4k9Fye
	KZCfBRIMaVIC7xUNVIzHJCsMxrDUDAQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-UFhvGX34MnuABopEP9EVQA-1; Mon, 05 Jun 2023 10:56:41 -0400
X-MC-Unique: UFhvGX34MnuABopEP9EVQA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f41a04a297so23987465e9.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 07:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685977000; x=1688569000;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iM7FqUtZoblM2J1vfVR4GtdyLSINqEtLQvkMkp8oaNA=;
        b=AwiU3hcvVAsHJku0KbUPS2n17K3iUIlwESxW5y1Fem8eVo4/wXgoj8NjsA9F01lDEI
         sS/60TIyyKcrc7S/AD67H8VYoBGsbWN0tOcexKREJbuMvXka8aNNIxJjcLddaIJOJ9u4
         DfzGzBEiO2wP6ste1HwOh7NFd31vp1PnCKDYYBCcbwN2oSF0UkmqsS28z/n+2ahY6Rrg
         xEQpLTQrAnEisFh0f+sXyQ3VVLTP3l4I3pcXHYOueBP1FhaoDMOSw5K4TyVZA6NF28Iv
         mZlxHuQhGVNzFHJ6i5r5PPeDCduzHmp7Vl+Fsora/aQsIigsgjmjZxVOXk95wu3VdsHq
         XPgA==
X-Gm-Message-State: AC+VfDy3BJL266CMTqcmMrUjxwOhOZEtN8CCVxqlJODL4AOuMFdqR1IT
	FPRj8sfqkfWHnMJx2mkkIr8vWDB1j2soktPOo0CpBkum9NBYiGYBgFfTQ22gHWJOmGGtYVAd1Dk
	PuN2MC1cJT+fHVxMs
X-Received: by 2002:a7b:c3d0:0:b0:3f6:1a3:4cee with SMTP id t16-20020a7bc3d0000000b003f601a34ceemr7047077wmj.14.1685977000614;
        Mon, 05 Jun 2023 07:56:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7l4TdvDr6o9XW/L55yGS61L3quL2CQtXB9IsLkpcz4S8Wf/T1gUnxE76eS3+xlCYUvLcEtYw==
X-Received: by 2002:a7b:c3d0:0:b0:3f6:1a3:4cee with SMTP id t16-20020a7bc3d0000000b003f601a34ceemr7047062wmj.14.1685977000262;
        Mon, 05 Jun 2023 07:56:40 -0700 (PDT)
Received: from sgarzare-redhat ([5.77.94.106])
        by smtp.gmail.com with ESMTPSA id o7-20020a05600c4fc700b003f71ad792f2sm20247339wmq.1.2023.06.05.07.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:56:39 -0700 (PDT)
Date: Mon, 5 Jun 2023 16:56:37 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Shannon Nelson <shannon.nelson@amd.com>, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230605095404-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
>On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
>> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
>> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
>> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
>> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
>> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
>> > > > > don't support packed virtqueue well yet, so let's filter the
>> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
>> > > > >
>> > > > > This way, even if the device supports it, we don't risk it being
>> > > > > negotiated, then the VMM is unable to set the vring state properly.
>> > > > >
>> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> > > > > Cc: stable@vger.kernel.org
>> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > > > ---
>> > > > >
>> > > > > Notes:
>> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>> > > > >     better PACKED support" series [1] and backported in stable branches.
>> > > > >
>> > > > >     We can revert it when we are sure that everything is working with
>> > > > >     packed virtqueues.
>> > > > >
>> > > > >     Thanks,
>> > > > >     Stefano
>> > > > >
>> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> > > >
>> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
>> > >
>> > > To really support packed virtqueue with vhost-vdpa, at that point we would
>> > > also have to revert this patch.
>> > >
>> > > I wasn't sure if you wanted to queue the series for this merge window.
>> > > In that case do you think it is better to send this patch only for stable
>> > > branches?
>> > > > Does this patch make them a NOP?
>> > >
>> > > Yep, after applying the "better PACKED support" series and being
>> > > sure that
>> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
>> > > patch.
>> > >
>> > > Let me know if you prefer a different approach.
>> > >
>> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
>> > > interprets them the right way, when it does not.
>> > >
>> > > Thanks,
>> > > Stefano
>> > >
>> >
>> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
>> > to merge in this window. Probably easier than the elaborate
>> > mask/unmask dance.
>>
>> CCing Shannon (the original author of the "better PACKED support"
>> series).
>>
>> IIUC Shannon is going to send a v3 of that series to fix the
>> documentation, so Shannon can you also add the Fixes tags?
>>
>> Thanks,
>> Stefano
>
>Well this is in my tree already. Just reply with
>Fixes: <>
>to each and I will add these tags.

I tried, but it is not easy since we added the support for packed 
virtqueue in vdpa and vhost incrementally.

Initially I was thinking of adding the same tag used here:

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")

Then I discovered that vq_state wasn't there, so I was thinking of

Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")

So we would have to backport quite a few patches into the stable branches.
I don't know if it's worth it...

I still think it is better to disable packed in the stable branches,
otherwise I have to make a list of all the patches we need.

Any other ideas?

Thanks,
Stefano


