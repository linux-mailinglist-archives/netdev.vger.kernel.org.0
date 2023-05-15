Return-Path: <netdev+bounces-2489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 085CC70232D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF0051C20A3A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 05:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C7D1FA2;
	Mon, 15 May 2023 05:13:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B101B10E6
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:13:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0095DE71
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684127628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PWL+vmE+VOJe076wrGPBFtIigtHfPH7nZD62FaxHuXw=;
	b=GmE2SfuI9vJK1FnfdxIgx/j4xGY8027vMaT6VjEQn6fHswMRuCR68LxclScrvYOePl1CuT
	iM3v/qyEE+R7wXKmqriHdeJ7s5o3SaHudYyhaaLFHIgr5XWicfEtl64diKQL4SlJ4JxHuO
	GW7Fq8HzKXZzebJyirqLaKWwDQ6zRe0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-M1-93CcpNEWS_sFAX5YKFw-1; Mon, 15 May 2023 01:13:46 -0400
X-MC-Unique: M1-93CcpNEWS_sFAX5YKFw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f26157450aso3293239e87.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 22:13:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684127625; x=1686719625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWL+vmE+VOJe076wrGPBFtIigtHfPH7nZD62FaxHuXw=;
        b=OFVsuZb7rM7QayE/3e/c06UNZCVF24KTnWpEWJB9hz60k7wxLZAF6AyoJOp6QN+T/V
         ALjNcw1XfUg1Wk7c9FbcB0wJPVfPlXO6MveiZT56Z32vNaecrlBCDj5bvKW/2V5356Vv
         LjDmSj8V039LsZkj8B9i824TOZurc4BOh1Gk6zj0KSvtEZuI5fMPCActC3N0oP8JzezS
         nGY3e4FAztV8SI00fKE8oUZNo5meFwFL7qdYhf1Dwj8vV60ARYOUrYnMEuDd6nV+MiaA
         yv2E/jiXi1hXn5rhORdfjlc2PFZBusJYcriIWgLLj2ltcRLQsw6fGYAU6PBW0lKER+XI
         TE3Q==
X-Gm-Message-State: AC+VfDwrAyneYjX5xhAcle4OjrYtoDojNcFeRKOIkTmBwkNRzH0DLvoS
	GQkRspK+brhFoPwYZWQ8S6m4w1TRwpg0gQUY+AksD7WDMWQs8D4xM3btyWQkLFPJk/urnNDW4iD
	UJJb/9ScA+NGimOFuloIT2rRDh3J7WK9X
X-Received: by 2002:ac2:4c32:0:b0:4f2:e145:7170 with SMTP id u18-20020ac24c32000000b004f2e1457170mr1682373lfq.11.1684127625478;
        Sun, 14 May 2023 22:13:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZDYbQ+I0fYbiU45FL35gM04BNhJdJfhiYH+NriIaHw8/yqwgU+oUXPwnN3SEJjYQbqiGN9mYQ8oRKuot6BZU=
X-Received: by 2002:ac2:4c32:0:b0:4f2:e145:7170 with SMTP id
 u18-20020ac24c32000000b004f2e1457170mr1682370lfq.11.1684127625214; Sun, 14
 May 2023 22:13:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230413064027.13267-1-jasowang@redhat.com> <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org> <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org> <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org> <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
 <20230515004422-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230515004422-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 15 May 2023 13:13:33 +0800
Message-ID: <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
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

On Mon, May 15, 2023 at 12:45=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Mon, May 15, 2023 at 09:05:54AM +0800, Jason Wang wrote:
> > On Wed, May 10, 2023 at 1:33=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > > > On Fri, Apr 14, 2023 at 3:21=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > > > > Forget to cc netdev, adding.
> > > > > >
> > > > > > On Fri, Apr 14, 2023 at 12:25=E2=80=AFAM Michael S. Tsirkin <ms=
t@redhat.com> wrote:
> > > > > > >
> > > > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > > > > > This patch convert rx mode setting to be done in a workqueu=
e, this is
> > > > > > > > a must for allow to sleep when waiting for the cvq command =
to
> > > > > > > > response since current code is executed under addr spin loc=
k.
> > > > > > > >
> > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > >
> > > > > > > I don't like this frankly. This means that setting RX mode wh=
ich would
> > > > > > > previously be reliable, now becomes unreliable.
> > > > > >
> > > > > > It is "unreliable" by design:
> > > > > >
> > > > > >       void                    (*ndo_set_rx_mode)(struct net_dev=
ice *dev);
> > > > > >
> > > > > > > - first of all configuration is no longer immediate
> > > > > >
> > > > > > Is immediate a hard requirement? I can see a workqueue is used =
at least:
> > > > > >
> > > > > > mlx5e, ipoib, efx, ...
> > > > > >
> > > > > > >   and there is no way for driver to find out when
> > > > > > >   it actually took effect
> > > > > >
> > > > > > But we know rx mode is best effort e.g it doesn't support vhost=
 and we
> > > > > > survive from this for years.
> > > > > >
> > > > > > > - second, if device fails command, this is also not
> > > > > > >   propagated to driver, again no way for driver to find out
> > > > > > >
> > > > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > > > without breaking normal drivers.
> > > > > >
> > > > > > It's not specific to VDUSE. For example, when using virtio-net =
in the
> > > > > > UP environment with any software cvq (like mlx5 via vDPA or cma
> > > > > > transport).
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > Hmm. Can we differentiate between these use-cases?
> > > >
> > > > It doesn't look easy since we are drivers for virtio bus. Underlaye=
r
> > > > details were hidden from virtio-net.
> > > >
> > > > Or do you have any ideas on this?
> > > >
> > > > Thanks
> > >
> > > I don't know, pass some kind of flag in struct virtqueue?
> > >         "bool slow; /* This vq can be very slow sometimes. Don't wait=
 for it! */"
> > >
> > > ?
> > >
> >
> > So if it's slow, sleep, otherwise poll?
> >
> > I feel setting this flag might be tricky, since the driver doesn't
> > know whether or not it's really slow. E.g smartNIC vendor may allow
> > virtio-net emulation over PCI.
> >
> > Thanks
>
> driver will have the choice, depending on whether
> vq is deterministic or not.

Ok, but the problem is, such booleans are only useful for virtio ring
codes. But in this case, virtio-net knows what to do for cvq. So I'm
not sure who the user is.

Thanks

>
>
> > > --
> > > MST
> > >
>


