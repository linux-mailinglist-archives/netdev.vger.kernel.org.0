Return-Path: <netdev+bounces-2847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CA7470444A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1A651C20D38
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 085961953A;
	Tue, 16 May 2023 04:18:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A7DF6C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:18:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE6B1BD0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 21:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684210685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9NWCEVhUxXac0SgI8SdAC5oCHCztYJjiGcJEkQVeZHg=;
	b=D913Kbj4uihQvafEkQ4JYmDPaxrpYW6PpA6aFGL6bl8fHDMm9WXdxeBQIhxD6pgUrAvns+
	CnhdV4grg/xAmPND/zo05vSudPW4MouvR6QD1PIeROo8kbJ13UFEb8j/1n+s9+RIzdoq93
	NS1StMpTofYWHm272DlSJ9PHWuz+pfQ=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-IHUgFiL4MI2syNGii8vg4g-1; Tue, 16 May 2023 00:18:03 -0400
X-MC-Unique: IHUgFiL4MI2syNGii8vg4g-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4f37c82f185so1565577e87.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 21:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684210682; x=1686802682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9NWCEVhUxXac0SgI8SdAC5oCHCztYJjiGcJEkQVeZHg=;
        b=j0GNKikXP7ldYA4YERE68RVRIxS5qlcqtUboTTiE3D3yC6GMhiondPPlUzX8XfEgza
         4FvXg46PE+bVy6f44LWPSFTGxboInxRV/a0g9yp6ms8yVDnhHHPF0uel0zz62pjxAzC4
         p531G2wTRhwm89uM3LAaW0XGcKgbw1exx+fGmYyLJJByZ8wbzlSRIfE7hckhUJPmuLfc
         VeJ37vBTZkvfXJnj0tsjrhW+ieoQN+LoOweIRmJjFYavAgIknXC69gbqK0zil7Bz703w
         VskZGMZYM+8NBqb9n5mNTI4IgShbrEMGT8Olj9/gu+TfWffLTUTWVRqrY/kG+elwv0qI
         ZWQA==
X-Gm-Message-State: AC+VfDwE94STkSQCuMmK9LbvXDg1n8KPnZK4ekbKCYhD79UQneF1iujh
	81tqQVV88zRE6wPE0C+Qj6J5UTfLSMmIomD1PXQ+Q1VkTY+2Ij3z6imN+o7QLVsdGDX6LMojH8e
	O1yy0W+D5M0muIneVCXIoB4to5ccTGPm7
X-Received: by 2002:ac2:4a75:0:b0:4f1:444e:6c5a with SMTP id q21-20020ac24a75000000b004f1444e6c5amr6738617lfp.8.1684210682021;
        Mon, 15 May 2023 21:18:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7ZTyVVhSMJw2IulnTZup4VUyz0KR2czGgnHsQrh3Ne6itX4gHPwy0Kq/Y5JuXUsrcYrkZ8FsnaekOT7u9hHTE=
X-Received: by 2002:ac2:4a75:0:b0:4f1:444e:6c5a with SMTP id
 q21-20020ac24a75000000b004f1444e6c5amr6738602lfp.8.1684210681690; Mon, 15 May
 2023 21:18:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230413121525-mutt-send-email-mst@kernel.org>
 <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org> <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org> <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
 <20230515004422-mutt-send-email-mst@kernel.org> <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
 <20230515061455-mutt-send-email-mst@kernel.org> <CACGkMEt8QkK1PnTrRUjDbyJheBurdibr4--Es8P0Y9NZM659pQ@mail.gmail.com>
 <20230516000829-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230516000829-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 May 2023 12:17:50 +0800
Message-ID: <CACGkMEvCHQLFbtB2fbF27oCd5fNSjUtUOS0q-Lx7=MeYR8KzRA@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
To: "Michael S. Tsirkin" <mst@redhat.com>, kuba@kernel.org
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com, eperezma@redhat.com, 
	xuanzhuo@linux.alibaba.com, david.marchand@redhat.com, 
	netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 12:13=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Tue, May 16, 2023 at 10:44:45AM +0800, Jason Wang wrote:
> > On Mon, May 15, 2023 at 6:17=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Mon, May 15, 2023 at 01:13:33PM +0800, Jason Wang wrote:
> > > > On Mon, May 15, 2023 at 12:45=E2=80=AFPM Michael S. Tsirkin <mst@re=
dhat.com> wrote:
> > > > >
> > > > > On Mon, May 15, 2023 at 09:05:54AM +0800, Jason Wang wrote:
> > > > > > On Wed, May 10, 2023 at 1:33=E2=80=AFPM Michael S. Tsirkin <mst=
@redhat.com> wrote:
> > > > > > >
> > > > > > > On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > > > > > > > On Fri, Apr 14, 2023 at 3:21=E2=80=AFPM Michael S. Tsirkin =
<mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrot=
e:
> > > > > > > > > > Forget to cc netdev, adding.
> > > > > > > > > >
> > > > > > > > > > On Fri, Apr 14, 2023 at 12:25=E2=80=AFAM Michael S. Tsi=
rkin <mst@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang =
wrote:
> > > > > > > > > > > > This patch convert rx mode setting to be done in a =
workqueue, this is
> > > > > > > > > > > > a must for allow to sleep when waiting for the cvq =
command to
> > > > > > > > > > > > response since current code is executed under addr =
spin lock.
> > > > > > > > > > > >
> > > > > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > > >
> > > > > > > > > > > I don't like this frankly. This means that setting RX=
 mode which would
> > > > > > > > > > > previously be reliable, now becomes unreliable.
> > > > > > > > > >
> > > > > > > > > > It is "unreliable" by design:
> > > > > > > > > >
> > > > > > > > > >       void                    (*ndo_set_rx_mode)(struct=
 net_device *dev);
> > > > > > > > > >
> > > > > > > > > > > - first of all configuration is no longer immediate
> > > > > > > > > >
> > > > > > > > > > Is immediate a hard requirement? I can see a workqueue =
is used at least:
> > > > > > > > > >
> > > > > > > > > > mlx5e, ipoib, efx, ...
> > > > > > > > > >
> > > > > > > > > > >   and there is no way for driver to find out when
> > > > > > > > > > >   it actually took effect
> > > > > > > > > >
> > > > > > > > > > But we know rx mode is best effort e.g it doesn't suppo=
rt vhost and we
> > > > > > > > > > survive from this for years.
> > > > > > > > > >
> > > > > > > > > > > - second, if device fails command, this is also not
> > > > > > > > > > >   propagated to driver, again no way for driver to fi=
nd out
> > > > > > > > > > >
> > > > > > > > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > > > > > > > without breaking normal drivers.
> > > > > > > > > >
> > > > > > > > > > It's not specific to VDUSE. For example, when using vir=
tio-net in the
> > > > > > > > > > UP environment with any software cvq (like mlx5 via vDP=
A or cma
> > > > > > > > > > transport).
> > > > > > > > > >
> > > > > > > > > > Thanks
> > > > > > > > >
> > > > > > > > > Hmm. Can we differentiate between these use-cases?
> > > > > > > >
> > > > > > > > It doesn't look easy since we are drivers for virtio bus. U=
nderlayer
> > > > > > > > details were hidden from virtio-net.
> > > > > > > >
> > > > > > > > Or do you have any ideas on this?
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > I don't know, pass some kind of flag in struct virtqueue?
> > > > > > >         "bool slow; /* This vq can be very slow sometimes. Do=
n't wait for it! */"
> > > > > > >
> > > > > > > ?
> > > > > > >
> > > > > >
> > > > > > So if it's slow, sleep, otherwise poll?
> > > > > >
> > > > > > I feel setting this flag might be tricky, since the driver does=
n't
> > > > > > know whether or not it's really slow. E.g smartNIC vendor may a=
llow
> > > > > > virtio-net emulation over PCI.
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > driver will have the choice, depending on whether
> > > > > vq is deterministic or not.
> > > >
> > > > Ok, but the problem is, such booleans are only useful for virtio ri=
ng
> > > > codes. But in this case, virtio-net knows what to do for cvq. So I'=
m
> > > > not sure who the user is.
> > > >
> > > > Thanks
> > >
> > > Circling back, what exactly does the architecture you are trying
> > > to fix look like? Who is going to introduce unbounded latency?
> > > The hypervisor?
> >
> > Hypervisor is one of the possible reason, we have many more:
> >
> > Hardware device that provides virtio-pci emulation.
> > Userspace devices like VDUSE.
>
> So let's start by addressing VDUSE maybe?

It's reported by at least one hardware vendor as well. I remember it
was Alvaro who reported this first in the past.

>
> > > If so do we not maybe want a new feature bit
> > > that documents this? Hypervisor then can detect old guests
> > > that spin and decide what to do, e.g. prioritise cvq more,
> > > or fail FEATURES_OK.
> >
> > We suffer from this for bare metal as well.
> >
> > But a question is what's wrong with the approach that is used in this
> > patch? I've answered that set_rx_mode is not reliable, so it should be
> > fine to use workqueue. Except for this, any other thing that worries
> > you?
> >
> > Thanks
>
> It's not reliable for other drivers but has been reliable for virtio.
> I worry some software relied on this.

It's probably fine since some device like vhost doesn't support this
at all and we manage to survive for several years.

> You are making good points though ... could we get some
> maintainer's feedback on this?

That would be helpful. Jakub, any input on this?

Thanks

>
> > >
> > > > >
> > > > >
> > > > > > > --
> > > > > > > MST
> > > > > > >
> > > > >
> > >
>


