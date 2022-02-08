Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F214ACF6F
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346009AbiBHDDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345998AbiBHDDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:03:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A9644C043189
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 19:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644289411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1stUz3RjxkgpjesKm8AllvYm9uCvOROobIu3B8b6FdQ=;
        b=TYAxsUSS4Bbski11Jc54103z9A+8Gj1mqSCvRdGdgCtspDyL8/FwbCjjMi+UwGGHTxXb0C
        WFHZcM8EFeIQl6UBuGp9UZ8xTsFxZTfe1LFkO8eAzdghBQy5AunuIklR/mOJ5bolLklc3Z
        wM/6OK/8zZMXF2lGLM3uBJsPMui+Lms=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-HyE3Idl4P1C9TAj3X8rZBA-1; Mon, 07 Feb 2022 22:03:30 -0500
X-MC-Unique: HyE3Idl4P1C9TAj3X8rZBA-1
Received: by mail-lf1-f72.google.com with SMTP id c25-20020a056512325900b0043fc8f2e1f6so766376lfr.6
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 19:03:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1stUz3RjxkgpjesKm8AllvYm9uCvOROobIu3B8b6FdQ=;
        b=D0B3VtjLkT3rP1/A14nrEVisJTDH56C1Fo4qQ2/dvTyBzsuM3Imk74yld/KAO2Ml88
         pqx1QtBERC1vf4r1eEAqUmfZf0Bg9aDZypWnB7/FRA1PMx8RG2cxoq4U/h9J6cFcstrl
         io05ogPSMmQrEy2QQ3dndbp/cL6YQxfkKjV6uY4ASMXlB88Snj5A0WyE7oQwbaf6514I
         9pcF4kP/1nn77aPKquByhOl4pR1Rr9zrkDLkiO9vrdw/V5w6BogSJQ/Dere5jpYCB2+L
         Gs6ALN/5LA/lReTTH2NOdX1Cea8f7NxjtcygA8kCx4pxGnhb8HtvdpTFoY1ZLGz++JDQ
         hLEA==
X-Gm-Message-State: AOAM530CmeHOdEAgSfqEvIUFs8naPHiZCXKKSRkoorI8OqFQG3plvzES
        JynsHu9cS173L7YJRexJx2Haf0JNtn1RnjV0//brtfa+YEm14042DWYEGZxmtwjIKRI6OifW/fs
        Za/2RW8P0T8Wl1VUMEZpYp6dVLMt4g+Rx
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr1655482lfb.498.1644289409289;
        Mon, 07 Feb 2022 19:03:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmeEqb7xD2hGfktnYzPM5khykAVWnfXuFl/OpdtF49m/bu9JXiTZeeM/TggfJswdv3D87HxYGThmUGSyAcckM=
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr1655467lfb.498.1644289409038;
 Mon, 07 Feb 2022 19:03:29 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <CACGkMEuJ_v5g2ypLZ3eNhAcUM9Q3PpWuiaeWVfEC6KACGzWAZw@mail.gmail.com> <1644286649.5989025-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644286649.5989025-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 8 Feb 2022 11:03:17 +0800
Message-ID: <CACGkMEvVmKg0r4WudojL6dGt3vG4f=_4Pnsn-kBwQcge63jNqQ@mail.gmail.com>
Subject: Re: [PATCH v3 01/17] virtio_pci: struct virtio_pci_common_cfg add queue_notify_data
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 10:17 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Mon, 7 Feb 2022 16:06:15 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Mon, Feb 7, 2022 at 2:07 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> w=
rote:
> > >
> > > On Mon, 7 Feb 2022 11:41:06 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > >
> > > > =E5=9C=A8 2022/1/26 =E4=B8=8B=E5=8D=883:35, Xuan Zhuo =E5=86=99=E9=
=81=93:
> > > > > Add queue_notify_data in struct virtio_pci_common_cfg, which come=
s from
> > > > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > > > >
> > > > > Since I want to add queue_reset after it, I submitted this patch =
first.
> > > > >
> > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >   include/uapi/linux/virtio_pci.h | 1 +
> > > > >   1 file changed, 1 insertion(+)
> > > > >
> > > > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux=
/virtio_pci.h
> > > > > index 3a86f36d7e3d..492c89f56c6a 100644
> > > > > --- a/include/uapi/linux/virtio_pci.h
> > > > > +++ b/include/uapi/linux/virtio_pci.h
> > > > > @@ -164,6 +164,7 @@ struct virtio_pci_common_cfg {
> > > > >     __le32 queue_avail_hi;          /* read-write */
> > > > >     __le32 queue_used_lo;           /* read-write */
> > > > >     __le32 queue_used_hi;           /* read-write */
> > > > > +   __le16 queue_notify_data;       /* read-write */
> > > > >   };
> > > >
> > > >
> > > > So I had the same concern as previous version.
> > > >
> > > > This breaks uABI where program may try to use sizeof(struct
> > > > virtio_pci_common_cfg).
> > > >
> > > > We probably need a container structure here.
> > >
> > > I see, I plan to add a struct like this, do you think it's appropriat=
e?
> > >
> > > struct virtio_pci_common_cfg_v1 {
> > >         struct virtio_pci_common_cfg cfg;
> > >         __le16 queue_notify_data;       /* read-write */
> > > }
> >
> > Something like this but we probably need a better name.
>
>
> how about this?
>
>         /* Ext Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
>         struct virtio_pci_common_cfg_ext {
>                 struct virtio_pci_common_cfg cfg;
>
>                 __le16 queue_notify_data;       /* read-write */
>
>                 __le16 reserved0;
>                 __le16 reserved1;
>                 __le16 reserved2;
>                 __le16 reserved3;
>                 __le16 reserved4;
>                 __le16 reserved5;
>                 __le16 reserved6;
>                 __le16 reserved7;
>                 __le16 reserved8;
>                 __le16 reserved9;
>                 __le16 reserved10;
>                 __le16 reserved11;
>                 __le16 reserved12;
>                 __le16 reserved13;
>                 __le16 reserved14;
>         };

I still think the container without padding is better. Otherwise
userspace needs to use offset_of() trick instead of sizeof().

Thanks

>
> Thanks
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > > >
> > > > THanks
> > > >
> > > >
> > > > >
> > > > >   /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> > > >
> > >
> >
>

