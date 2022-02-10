Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350C34B0881
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 09:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237608AbiBJIfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 03:35:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiBJIfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 03:35:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2D00E7A
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:35:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644482142;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XqjXLI97NOutn89dUCnZGpbZDvFUlvmc/e2dV+qUZL0=;
        b=JpMH1Hyk5nfYXx41QXbFvjfnUTr0E50lhj5Q451/NHpESWd4jgVaaUko/1wT6jL8AMxgn0
        Sq7RwdC2Fy/VrEg9+ZV481eHE5l+CHXX4Ef+dtPx57nYSxbQi4rzp2C5z+NojOUC6gplQp
        N5jQFn2I5IgQngC2wcPTb2JebainmHs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-QLk1Xq4iOy2p8XbyhLoDCA-1; Thu, 10 Feb 2022 03:35:41 -0500
X-MC-Unique: QLk1Xq4iOy2p8XbyhLoDCA-1
Received: by mail-lj1-f199.google.com with SMTP id k22-20020a2e8896000000b0023f97d5d855so2264139lji.12
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 00:35:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqjXLI97NOutn89dUCnZGpbZDvFUlvmc/e2dV+qUZL0=;
        b=s8/MyGC0C0hYDeaRn9eelBaT4rCsk4QobRbjV3cS3JyJb8SLLHLKMwvv4xXbWgytSE
         33/RYxZICTelM+Xc83C9eO7CbArV2l7nzE9Q7DMOPMK2HBD7/9aWeQcH/sWhPsplcug8
         1DtNvWT8MSClaRVR/9LiQ8wGzBNZ9aNNZUK+3/hGP1wTESeepRBcI1mOGPdDpysU5Oiz
         OwaIjvSURYFFUmaGGROh5qVQ31FcneXvd1RSaBPhOWGfdgalh14XOcAQlO9/3tZLNlAf
         JnF3jC7NCnmfPWBPAyK4ivUWwnQJrhk7BKeVObDu6DHAvABEgHDltJzeefIqr80NplF8
         VvLg==
X-Gm-Message-State: AOAM530u7g3PAHEmhG9I/eFrD7a5RXRX5RoCBC8utXkMcpE1dNZ1Vz05
        7mNA7rJrfkSxDvWiQkTJzPGG1K20DklofYh0OazGPpsd53u59BPLeZjMqqbQG9xpgQCFugObYm0
        +Qx0XbrBZf/hP+ueS3F5wO6mcESERR7QR
X-Received: by 2002:a05:651c:12c5:: with SMTP id 5mr4161383lje.420.1644482140137;
        Thu, 10 Feb 2022 00:35:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFSiS9Gw4HQgTyfbolBizZz4LwvJo7dHT63FjXO5jcUqWEfH6krIsAAx9lTiWBFYn2iiicV25zLNOPDwTy+vM=
X-Received: by 2002:a05:651c:12c5:: with SMTP id 5mr4161374lje.420.1644482139931;
 Thu, 10 Feb 2022 00:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20220207125537.174619-1-elic@nvidia.com> <20220207125537.174619-3-elic@nvidia.com>
 <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com> <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20220210083050.GA224722@mtl-vdi-166.wap.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Feb 2022 16:35:28 +0800
Message-ID: <CACGkMEtBq_q_NQZgs4LobSRkA-4eOafBPLXZJ7ny9f8XJygSzw@mail.gmail.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent features
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 4:31 PM Eli Cohen <elic@nvidia.com> wrote:
>
> On Thu, Feb 10, 2022 at 03:54:57PM +0800, Jason Wang wrote:
> > On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
> > >
> > > Define bit fields for device independent feature bits. We need them in a
> > > follow up patch.
> > >
> > > Also, define macros for start and end of these feature bits.
> > >
> > > Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> > > Signed-off-by: Eli Cohen <elic@nvidia.com>
> > > ---
> > >  include/uapi/linux/virtio_config.h | 16 ++++++++--------
> > >  1 file changed, 8 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> > > index 3bf6c8bf8477..6d92cc31a8d3 100644
> > > --- a/include/uapi/linux/virtio_config.h
> > > +++ b/include/uapi/linux/virtio_config.h
> > > @@ -45,14 +45,14 @@
> > >  /* We've given up on this device. */
> > >  #define VIRTIO_CONFIG_S_FAILED         0x80
> > >
> > > -/*
> > > - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> > > - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> > > - * being used (e.g. virtio_ring, virtio_pci etc.), the
> > > - * rest are per-device feature bits.
> > > - */
> > > -#define VIRTIO_TRANSPORT_F_START       28
> > > -#define VIRTIO_TRANSPORT_F_END         38
> > > +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> > > +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> > > +#define VIRTIO_DEV_INDEPENDENT_F_END   38
> >
> > Haven't gone through patch 3 but I think it's probably better not
> > touch uapi stuff. Or we can define those macros in other place?
> >
>
> I can put it in vdpa.c
>
> > > +
> > > +#define VIRTIO_F_RING_INDIRECT_DESC 28
> > > +#define VIRTIO_F_RING_EVENT_IDX 29
> > > +#define VIRTIO_F_IN_ORDER 35
> > > +#define VIRTIO_F_NOTIFICATION_DATA 38
> >
> > This part belongs to the virtio_ring.h any reason not pull that file
> > instead of squashing those into virtio_config.h?
> >
>
> Not sure what you mean here. I can't find virtio_ring.h in my tree.

I meant just copy the virtio_ring.h in the linux tree. It seems cleaner.

Thanks

>
> > Thanks
> >
> > >
> > >  #ifndef VIRTIO_CONFIG_NO_LEGACY
> > >  /* Do we get callbacks when the ring is completely used, even if we've
> > > --
> > > 2.34.1
> > >
> >
>

