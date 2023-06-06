Return-Path: <netdev+bounces-8248-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6164B72347A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 03:29:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AB262814B8
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 01:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62E2386;
	Tue,  6 Jun 2023 01:29:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DBC7F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 01:29:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD45E103
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686014977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LO0PcoIQipRUJHYAP4IZqQY6Y4aLmW6KIu9FvB1onCA=;
	b=ggVnQReOn2wuDhgo2dFb62pht5aKUqJ28qX4EgOOxx2sJUiVk3cVFTRI8Qul2YMeXsZlIO
	UHhDuj8LSV6rfr6vedM7rxwLDX2930+6Xh2zTCJv+Ipw9A5Dgfv7JJxnWtROmn+yyTqyd6
	ibLf+VpMDzq6g/EQX3S+YFhmtZ4YgA8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-Ok7dA-pDPy2i847RAmGZ4Q-1; Mon, 05 Jun 2023 21:29:35 -0400
X-MC-Unique: Ok7dA-pDPy2i847RAmGZ4Q-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b1bbe83720so17520981fa.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 18:29:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686014974; x=1688606974;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LO0PcoIQipRUJHYAP4IZqQY6Y4aLmW6KIu9FvB1onCA=;
        b=U6pUj5zbipJHQqSjLD1pqL0hKQtuVzh/Tk20ZQyWZM0zLZdgEon8OPSvE7b2v/SRvY
         Su8Ks151g2xUGK2eRVM4jQA3XHXQqXdJye7utTn9/4Z/0kGp8pOeqMWB6A10RP2h3Dyv
         j6ovTDH/ADCdo0i5qLT3hf8IpjYUxmFHcDXMW5SnXRuJyf+or1ABmpFgu7rST3dPnSr4
         dlVUgdbWT7KtC4IbahHfwT5iuA0TD/1aMauOkaSop9ANWnI9DsM07zJUZnDVseSz/pdj
         iidIJwZ2J0oQtZEELVcVBZR+eoQ6exGclorS9a7chY6niZIjtd9A5/E9YA02QyFfKuPf
         NgUw==
X-Gm-Message-State: AC+VfDzeY/GcghehWkS7fnejLnkaS7HR8ZLaESfw1bynGL2/Stxj9tlS
	4pOUTvt1EMZcU4AFfrSpjAP+PlZPimox2ACSpDOJPdQKZOTJxMqvM1ASZ2G5rwTlX16yIJGwgz9
	Uc+gvGYHga1NrAPnOZAXRYxd99yxIdJDq
X-Received: by 2002:a05:651c:90:b0:2ac:770f:8831 with SMTP id 16-20020a05651c009000b002ac770f8831mr471623ljq.40.1686014974165;
        Mon, 05 Jun 2023 18:29:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7q8xwsG2H2HJLbjrNSEB15Tcb4Vhw2h23yOvguszqhRoiFXNx/aA4LQRn2qI/jZv0NF0GvO+g7EwDrFoZVmEY=
X-Received: by 2002:a05:651c:90:b0:2ac:770f:8831 with SMTP id
 16-20020a05651c009000b002ac770f8831mr471619ljq.40.1686014973831; Mon, 05 Jun
 2023 18:29:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605110644.151211-1-sgarzare@redhat.com> <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org> <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org> <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
In-Reply-To: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 6 Jun 2023 09:29:22 +0800
Message-ID: <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Shannon Nelson <shannon.nelson@amd.com>, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 10:58=E2=80=AFPM Stefano Garzarella <sgarzare@redhat=
.com> wrote:
>
> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote=
:
> >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wro=
te:
> >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_B=
ASE)
> >> > > > > don't support packed virtqueue well yet, so let's filter the
> >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_feature=
s().
> >> > > > >
> >> > > > > This way, even if the device supports it, we don't risk it bei=
ng
> >> > > > > negotiated, then the VMM is unable to set the vring state prop=
erly.
> >> > > > >
> >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> >> > > > > Cc: stable@vger.kernel.org
> >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> > > > > ---
> >> > > > >
> >> > > > > Notes:
> >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vh=
ost_vdpa:
> >> > > > >     better PACKED support" series [1] and backported in stable=
 branches.
> >> > > > >
> >> > > > >     We can revert it when we are sure that everything is worki=
ng with
> >> > > > >     packed virtqueues.
> >> > > > >
> >> > > > >     Thanks,
> >> > > > >     Stefano
> >> > > > >
> >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.=
18947-1-shannon.nelson@amd.com/
> >> > > >
> >> > > > I'm a bit lost here. So why am I merging "better PACKED support"=
 then?
> >> > >
> >> > > To really support packed virtqueue with vhost-vdpa, at that point =
we would
> >> > > also have to revert this patch.
> >> > >
> >> > > I wasn't sure if you wanted to queue the series for this merge win=
dow.
> >> > > In that case do you think it is better to send this patch only for=
 stable
> >> > > branches?
> >> > > > Does this patch make them a NOP?
> >> > >
> >> > > Yep, after applying the "better PACKED support" series and being
> >> > > sure that
> >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should rever=
t this
> >> > > patch.
> >> > >
> >> > > Let me know if you prefer a different approach.
> >> > >
> >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the k=
ernel
> >> > > interprets them the right way, when it does not.
> >> > >
> >> > > Thanks,
> >> > > Stefano
> >> > >
> >> >
> >> > If this fixes a bug can you add Fixes tags to each of them? Then it'=
s ok
> >> > to merge in this window. Probably easier than the elaborate
> >> > mask/unmask dance.
> >>
> >> CCing Shannon (the original author of the "better PACKED support"
> >> series).
> >>
> >> IIUC Shannon is going to send a v3 of that series to fix the
> >> documentation, so Shannon can you also add the Fixes tags?
> >>
> >> Thanks,
> >> Stefano
> >
> >Well this is in my tree already. Just reply with
> >Fixes: <>
> >to each and I will add these tags.
>
> I tried, but it is not easy since we added the support for packed
> virtqueue in vdpa and vhost incrementally.
>
> Initially I was thinking of adding the same tag used here:
>
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
>
> Then I discovered that vq_state wasn't there, so I was thinking of
>
> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state=
()")
>
> So we would have to backport quite a few patches into the stable branches=
.
> I don't know if it's worth it...
>
> I still think it is better to disable packed in the stable branches,
> otherwise I have to make a list of all the patches we need.
>
> Any other ideas?

AFAIK, except for vp_vdpa, pds seems to be the first parent that
supports packed virtqueue. Users should not notice anything wrong if
they don't use packed virtqueue. And the problem of vp_vdpa + packed
virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
I guess.

Thanks

>
> Thanks,
> Stefano
>
>


