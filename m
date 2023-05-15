Return-Path: <netdev+bounces-2455-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06BF67020EB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 03:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B49121C209DF
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 01:06:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95B010F5;
	Mon, 15 May 2023 01:06:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CF710EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 01:06:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6EA10F1
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 18:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684112769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uv5aIwjLG1oqVCUluD4Q4yzDZrBh0xxmyz40kJIsGCI=;
	b=LCW9/MsipLW7rqu2tZmRrjUsDqa9ic4zYgdv1d/TO0ngZYgyEFXKJuZJi/cB+Vlhqzq5f0
	ZVcEUiQrLAQ0mpvaoZudld0Tad/VEabUkLeNi/PmpbzpyeuoWgsN6yzIfk2xUWl7xdbuea
	DFqjQZ3EQZFjlv1PrIWr8YUNRKvCa/M=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-308-Vml-cdnsN_qQP3bgRToDoQ-1; Sun, 14 May 2023 21:06:07 -0400
X-MC-Unique: Vml-cdnsN_qQP3bgRToDoQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4ecb00906d0so7097056e87.1
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 18:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684112765; x=1686704765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uv5aIwjLG1oqVCUluD4Q4yzDZrBh0xxmyz40kJIsGCI=;
        b=YNL2Wtc5tS9gQVova+gNJ/P+pkfOV7qru6DvS7hu3eNA2CtLn1jfGDLiu38gs2Eq6X
         5IYf497FR7hsLQVzyNA8guvabByoop5OP2g6InmXM+NzOUZTkNtQL3tJSLtiV9ZCWOq3
         IDEj5GB/3kgaBQNmKJ+47YLqCpR6eWfGuVoE+pn5S0MU1Rz/nx+1uQNemai1O/Wa0eoH
         YtbQqPsCbgtLAmhPFKluzRP0U28tRJAAWCG3imfIpBeoIBFHjvy4ScbS4RBsq5cJjMHt
         6+lFNgo5AkAtJrZiRxMlGU903DjYFfjgX6qR25xkNWqZBvuA9u2Jvu6GVi9uxWcFyC9+
         9hkQ==
X-Gm-Message-State: AC+VfDzwB4i0qny8SdnmJxejz9P6zrNzVEjsacVQ8nMJxtiv5FRu4r+n
	VLuJdZkH0sZPHIPk3obPh7tY0T02sKwUM2B5KM2ew/YVcymam0GLNlv9nQ6KmYb8MTOoGFbmNwU
	04dWD+HFKvHfa6EvOospzk3K+80+ryKTK
X-Received: by 2002:ac2:4c21:0:b0:4ec:8c1e:c816 with SMTP id u1-20020ac24c21000000b004ec8c1ec816mr5376382lfq.34.1684112765556;
        Sun, 14 May 2023 18:06:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5YPiZxBxVtf9zRH0XfAMrcB1fgSrLC9Ac+IoZn18054L1JMAhHHN2gwfb+4PNChIHs918idKFjoqWhSD5pyIM=
X-Received: by 2002:ac2:4c21:0:b0:4ec:8c1e:c816 with SMTP id
 u1-20020ac24c21000000b004ec8c1ec816mr5376369lfq.34.1684112765255; Sun, 14 May
 2023 18:06:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230413064027.13267-1-jasowang@redhat.com> <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org> <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org> <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230510012951-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 09:05:54 +0800
Message-ID: <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com, 
	alvaro.karsz@solid-run.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com, 
	david.marchand@redhat.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 1:33=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > On Fri, Apr 14, 2023 at 3:21=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > > Forget to cc netdev, adding.
> > > >
> > > > On Fri, Apr 14, 2023 at 12:25=E2=80=AFAM Michael S. Tsirkin <mst@re=
dhat.com> wrote:
> > > > >
> > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > > > This patch convert rx mode setting to be done in a workqueue, t=
his is
> > > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > > response since current code is executed under addr spin lock.
> > > > > >
> > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > >
> > > > > I don't like this frankly. This means that setting RX mode which =
would
> > > > > previously be reliable, now becomes unreliable.
> > > >
> > > > It is "unreliable" by design:
> > > >
> > > >       void                    (*ndo_set_rx_mode)(struct net_device =
*dev);
> > > >
> > > > > - first of all configuration is no longer immediate
> > > >
> > > > Is immediate a hard requirement? I can see a workqueue is used at l=
east:
> > > >
> > > > mlx5e, ipoib, efx, ...
> > > >
> > > > >   and there is no way for driver to find out when
> > > > >   it actually took effect
> > > >
> > > > But we know rx mode is best effort e.g it doesn't support vhost and=
 we
> > > > survive from this for years.
> > > >
> > > > > - second, if device fails command, this is also not
> > > > >   propagated to driver, again no way for driver to find out
> > > > >
> > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > without breaking normal drivers.
> > > >
> > > > It's not specific to VDUSE. For example, when using virtio-net in t=
he
> > > > UP environment with any software cvq (like mlx5 via vDPA or cma
> > > > transport).
> > > >
> > > > Thanks
> > >
> > > Hmm. Can we differentiate between these use-cases?
> >
> > It doesn't look easy since we are drivers for virtio bus. Underlayer
> > details were hidden from virtio-net.
> >
> > Or do you have any ideas on this?
> >
> > Thanks
>
> I don't know, pass some kind of flag in struct virtqueue?
>         "bool slow; /* This vq can be very slow sometimes. Don't wait for=
 it! */"
>
> ?
>

So if it's slow, sleep, otherwise poll?

I feel setting this flag might be tricky, since the driver doesn't
know whether or not it's really slow. E.g smartNIC vendor may allow
virtio-net emulation over PCI.

Thanks

> --
> MST
>


