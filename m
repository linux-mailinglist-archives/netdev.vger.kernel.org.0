Return-Path: <netdev+bounces-8407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D236723F2C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 773101C20DF3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:18:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27F72A715;
	Tue,  6 Jun 2023 10:18:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73AA28C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:18:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A60E5B
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686046734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WdTmcarTjpToePhx1ty5NLOSGd6QvPabttahqlaLQ7A=;
	b=MZAThLxnfhYg4JhjwBBmADB183AuILWlGFJK3bulR/TzVSb4V0ZnWQBURsdVW4dhZiV9FR
	LQ2kpeFjm7v2hy+kDn5KPFUw2FVj093HT1TvtO9SxFIWOVGL4S9PT6IXmJSY0wCT21baZd
	XjWoD9GVdeYsnM9x58MPKoiEpZszVvw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-pCplkgCaMG6COJl_eh-58w-1; Tue, 06 Jun 2023 06:18:52 -0400
X-MC-Unique: pCplkgCaMG6COJl_eh-58w-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f60fb7b31fso25544285e9.2
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 03:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686046731; x=1688638731;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdTmcarTjpToePhx1ty5NLOSGd6QvPabttahqlaLQ7A=;
        b=e8yFS+2yyMEDyXIOdh/BQU5plin/Emzhnvy3rmshKXGikXTGJc/W6IQZyz60BqeK78
         VK29/kj0Ka7AEJDl/20DDPd+WWCyJWe78MdfCYmBmsm00olTvX++EXBp7+Dkkz9dBeA8
         T+K2YFTcmfwmmYjew7Du20cbOW+16NFnvMx8ZlSLD6tT9nkT2HE5e9x2pxzl8s75XfM7
         dj5ZTpE4AOYz0NXm1OBz2LT9+E1yVPcCt1+hq4VeUNe+JIqtJCTlJJUMqkJEqx2fQYBQ
         6oy3vcimiZ7C9FwytjwZrzNkwU1QndWBxaJYUvLjZc4yalOe4vDWQ19clEtwogUueadG
         2HgQ==
X-Gm-Message-State: AC+VfDzIz5p5uFCOK/Ssrg7wPAs+AGIyHhxanKBYRqrrGi1f1T50z7Sc
	g0DmibQl9ltkMKx4zhpeTWdIiL10RcBV6qIlg0iHC0tX3hNDpTR9DHiuHi/FSWjTk/iCezlIhP3
	WBZWRRjQ3LtCvwUxe
X-Received: by 2002:adf:ff89:0:b0:30a:8995:1dc3 with SMTP id j9-20020adfff89000000b0030a89951dc3mr1371961wrr.55.1686046731707;
        Tue, 06 Jun 2023 03:18:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Fk6MqA/8GgHa5USB5P2+VXOKgfrHs1qQGdgd9HhZcWc64fMDe2Prhx8xF8VumCgAaHZmb7w==
X-Received: by 2002:adf:ff89:0:b0:30a:8995:1dc3 with SMTP id j9-20020adfff89000000b0030a89951dc3mr1371952wrr.55.1686046731415;
        Tue, 06 Jun 2023 03:18:51 -0700 (PDT)
Received: from sgarzare-redhat (93-44-29-47.ip95.fastwebnet.it. [93.44.29.47])
        by smtp.gmail.com with ESMTPSA id hn20-20020a05600ca39400b003f71ad792f2sm2097422wmb.1.2023.06.06.03.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:18:50 -0700 (PDT)
Date: Tue, 6 Jun 2023 12:18:40 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Shannon Nelson <shannon.nelson@amd.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <ufyif62swl2voj3k5wvbiyn4nbfgfzdf46xhr4dtj5jranwwrr@cvtskm6sff3x>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
>On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
>> >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
>> >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
>> >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
>> >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
>> >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
>> >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
>> >> > > > > don't support packed virtqueue well yet, so let's filter the
>> >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
>> >> > > > >
>> >> > > > > This way, even if the device supports it, we don't risk it being
>> >> > > > > negotiated, then the VMM is unable to set the vring state properly.
>> >> > > > >
>> >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>> >> > > > > Cc: stable@vger.kernel.org
>> >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> >> > > > > ---
>> >> > > > >
>> >> > > > > Notes:
>> >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
>> >> > > > >     better PACKED support" series [1] and backported in stable branches.
>> >> > > > >
>> >> > > > >     We can revert it when we are sure that everything is working with
>> >> > > > >     packed virtqueues.
>> >> > > > >
>> >> > > > >     Thanks,
>> >> > > > >     Stefano
>> >> > > > >
>> >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
>> >> > > >
>> >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
>> >> > >
>> >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
>> >> > > also have to revert this patch.
>> >> > >
>> >> > > I wasn't sure if you wanted to queue the series for this merge window.
>> >> > > In that case do you think it is better to send this patch only for stable
>> >> > > branches?
>> >> > > > Does this patch make them a NOP?
>> >> > >
>> >> > > Yep, after applying the "better PACKED support" series and being
>> >> > > sure that
>> >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
>> >> > > patch.
>> >> > >
>> >> > > Let me know if you prefer a different approach.
>> >> > >
>> >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
>> >> > > interprets them the right way, when it does not.
>> >> > >
>> >> > > Thanks,
>> >> > > Stefano
>> >> > >
>> >> >
>> >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
>> >> > to merge in this window. Probably easier than the elaborate
>> >> > mask/unmask dance.
>> >>
>> >> CCing Shannon (the original author of the "better PACKED support"
>> >> series).
>> >>
>> >> IIUC Shannon is going to send a v3 of that series to fix the
>> >> documentation, so Shannon can you also add the Fixes tags?
>> >>
>> >> Thanks,
>> >> Stefano
>> >
>> >Well this is in my tree already. Just reply with
>> >Fixes: <>
>> >to each and I will add these tags.
>>
>> I tried, but it is not easy since we added the support for packed
>> virtqueue in vdpa and vhost incrementally.
>>
>> Initially I was thinking of adding the same tag used here:
>>
>> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>>
>> Then I discovered that vq_state wasn't there, so I was thinking of
>>
>> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
>>
>> So we would have to backport quite a few patches into the stable branches.
>> I don't know if it's worth it...
>>
>> I still think it is better to disable packed in the stable branches,
>> otherwise I have to make a list of all the patches we need.
>>
>> Any other ideas?
>
>AFAIK, except for vp_vdpa, pds seems to be the first parent that

IIUC also vduse and snet supports packed virtqueue.

>supports packed virtqueue. Users should not notice anything wrong if
>they don't use packed virtqueue. And the problem of vp_vdpa + packed
>virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
>I guess.

Okay, maybe I'm overthinking it, not having a specific problem I don't
object, it was just a concern about uAPI.

Thanks,
Stefano


