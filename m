Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D444B98BD
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 07:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiBQGHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 01:07:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiBQGHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 01:07:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A601F26F0
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 22:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645078013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESdxth7tNrd453Iq06KhDm/ZhPhGbHQPQPRlQYMFL9w=;
        b=ZQDtQ2FfDri7Imkw4zm3/nkdspFw2p07xZ7sDMevAIqqLXhYILE4ELWkob/oPzkcx4EBPx
        3Zku25UAFvrArXJ/eCsGAcUUfU2B8PMTVscZD/Miw23grP0gJjRT910iCnYYEbh3dVxBos
        S3F9k8VQJX46pZGyq+A4TEhKZEWY+jI=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-hBj-dnJKMI6CO8hOpcHPTw-1; Thu, 17 Feb 2022 01:06:51 -0500
X-MC-Unique: hBj-dnJKMI6CO8hOpcHPTw-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-2d61f6c1877so4111057b3.15
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 22:06:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ESdxth7tNrd453Iq06KhDm/ZhPhGbHQPQPRlQYMFL9w=;
        b=zeC95j51OkI1a6LMR52itFOdvoDEJ9fo7uLD7ACw8ooxVdEzjOdCIH0rZHJ8VzoLuY
         PVyPHrVmjuv3zUOkrDkHbIqacBszzyxJKV3qaaopllp5HKvrgNTak4Kurmgj/MabDSCs
         F7wAosyBN1F7oT773GsOZA9YvLZnKekc3EU/jbD2KxRbaLBcd8UbYJxenhietwJL+q2a
         FhfPiFf6MCdtcOdE3M3AqbsOYKcCpnyKx9HUHnN2178oueb0L2WI+4yI2p3f23c4ozjS
         jlFhCMUI/efKDLmd8vFESwb8qvBLNBmGf0DEJbVyKcoapN2DoKB7mFAK4yQlWArPPiH7
         /nKA==
X-Gm-Message-State: AOAM533V0iR3EH2A4uDcDF40qGqYmcOOnW9mdTI6Pj4xks5BdwTXWku1
        89jSSdI22DNJd8iDOX721lTRYDXHm/tBDXQvPy3eHpV40mKaWdAYCsfQ6zuV7t2vtl+sPTCOxvT
        P200rHF2CbzkRB3Q/QHvOnDQzRcH93Ygy
X-Received: by 2002:a25:3187:0:b0:61e:5f5:4cb9 with SMTP id x129-20020a253187000000b0061e05f54cb9mr1211626ybx.544.1645078011096;
        Wed, 16 Feb 2022 22:06:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz47hKloiTQaZ66ZLbgNvK4Rz7cNg9uk6v48ujwkPVqtw8cj7HH8KYBlve6VqxUTfFEJSvbn2qgpU5LKX+x8JI=
X-Received: by 2002:a25:3187:0:b0:61e:5f5:4cb9 with SMTP id
 x129-20020a253187000000b0061e05f54cb9mr1211602ybx.544.1645078010838; Wed, 16
 Feb 2022 22:06:50 -0800 (PST)
MIME-Version: 1.0
References: <20220207125537.174619-1-elic@nvidia.com> <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
 <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx> <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
 <20220210092718.GA226512@mtl-vdi-166.wap.labs.mlnx> <185b96bb-68bd-9aef-b473-1f312194b42b@redhat.com>
 <20220216071553.GB2109@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20220216071553.GB2109@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 17 Feb 2022 14:06:39 +0800
Message-ID: <CACGkMEvNoG89M0m_=Z9E-d2U0tPJ2_-eiEEj3s_FGYOKTbkH0w@mail.gmail.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent features
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Gautam Dawar <gdawar@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 3:16 PM Eli Cohen <elic@nvidia.com> wrote:
>
> On Mon, Feb 14, 2022 at 02:06:54PM +0800, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/2/10 =E4=B8=8B=E5=8D=885:27, Eli Cohen =E5=86=99=E9=81=
=93:
> > > On Thu, Feb 10, 2022 at 04:35:28PM +0800, Jason Wang wrote:
> > > > On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
> > > > > On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> > > > > > On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrot=
e:
> > > > > > > Define bit fields for device independent feature bits. We nee=
d them in a
> > > > > > > follow up patch.
> > > > > > >
> > > > > > > Also, define macros for start and end of these feature bits.
> > > > > > >
> > > > > > > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > > > > > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > > > > > ---
> > > > > > >   include/uapi/linux/virtio_config.h | 16 ++++++++--------
> > > > > > >   1 file changed, 8 insertions(+), 8 deletions(-)
> > > > > > >
> > > > > > > diff --git a/include/uapi/linux/virtio_config.h b/include/uap=
i/linux/virtio_config.h
> > > > > > > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > > > > > > --- a/include/uapi/linux/virtio_config.h
> > > > > > > +++ b/include/uapi/linux/virtio_config.h
> > > > > > > @@ -45,14 +45,14 @@
> > > > > > >   /* We've given up on this device. */
> > > > > > >   #define VIRTIO_CONFIG_S_FAILED         0x80
> > > > > > >
> > > > > > > -/*
> > > > > > > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > > > > > > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > > > > > > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > > > > > > - * rest are per-device feature bits.
> > > > > > > - */
> > > > > > > -#define VIRTIO_TRANSPORT_F_START       28
> > > > > > > -#define VIRTIO_TRANSPORT_F_END         38
> > > > > > > +/* Device independent features per virtio spec 1.1 range fro=
m 28 to 38 */
> > > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > > > > > > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> > > > > > Haven't gone through patch 3 but I think it's probably better n=
ot
> > > > > > touch uapi stuff. Or we can define those macros in other place?
> > > > > >
> > > > > I can put it in vdpa.c
> > > > >
> > > > > > > +
> > > > > > > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > > > > > > +#define VIRTIO_F_RING_EVENT_IDX 29
> > > > > > > +#define VIRTIO_F_IN_ORDER 35
> > > > > > > +#define VIRTIO_F_NOTIFICATION_DATA 38
> > > > > > This part belongs to the virtio_ring.h any reason not pull that=
 file
> > > > > > instead of squashing those into virtio_config.h?
> > > > > >
> > > > > Not sure what you mean here. I can't find virtio_ring.h in my tre=
e.
> > > > I meant just copy the virtio_ring.h in the linux tree. It seems cle=
aner.
> > > I will still miss VIRTIO_F_ORDER_PLATFORM and VIRTIO_F_NOTIFICATION_D=
ATA
> > > which are only defined in drivers/net/ethernet/sfc/mcdi_pcol.h for bl=
ock
> > > devices only.
> > >
> > > What would you suggest to do with them? Maybe define them in vdpa.c?
> >
> >
> > I meant maybe we need a full synchronization from the current Linux uap=
i
> > headers for virtio_config.h and and add virtio_ring.h here.
> >
>
> virtio_config.h is updatd already and virtio_ring.h does not add any
> flag definition that we're missing.
>
> The flags I was missing are
> +#define VIRTIO_F_IN_ORDER 35
> +#define VIRTIO_F_NOTIFICATION_DATA 38

Right, so Gautam posted a path for _F_IN_ORDER [1].

We probably need another patch for NOTIFICATION_DATA.


>
> and both of these do not appear in the linux headers. They appear as
> block specific flags:
>
> drivers/net/ethernet/sfc/mcdi_pcol.h:21471:#define VIRTIO_BLK_CONFIG_VIRT=
IO_F_IN_ORDER_LBN 35
> drivers/net/ethernet/sfc/mcdi_pcol.h:21480:#define VIRTIO_BLK_CONFIG_VIRT=
IO_F_NOTIFICATION_DATA_LBN 38
>
> So I just defined these two in vdpa.c (in patch v1).

Fine, but we need to remove them if we get update from linux kernel uapi he=
aders

[1] https://lkml.org/lkml/2022/2/15/43

Thanks

>
> > Thanks
> >
> >
> > >
> > > > Thanks
> > > >
> > > > > > Thanks
> > > > > >
> > > > > > >   #ifndef VIRTIO_CONFIG_NO_LEGACY
> > > > > > >   /* Do we get callbacks when the ring is completely used, ev=
en if we've
> > > > > > > --
> > > > > > > 2.34.1
> > > > > > >
> >
>

