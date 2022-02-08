Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061E04ACFCE
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 04:36:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbiBHDgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 22:36:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiBHDgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 22:36:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1F717C0401D6
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 19:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644291398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RvjYmb4fznf4B7CPoj9ot4B6+UX+ip1V7EfG8FVrs/w=;
        b=J6jpZnN172CHsC92PnckzcEffL5Z3Z7TSZZkuuwUbFsZ7cTogEyXaht+ErzD2/xZ8EaMvX
        cmACS4ilfkBveXX3g/zUzki/wvBIg4OlzTkDZjDAmbilJV9JGhHxvjFZjK3Pj3c9elnzW6
        I7Nc1orWWOKWd2rvNtGRrTd6wJs7710=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-V18G3fZNNRKcGPCAq4BfZw-1; Mon, 07 Feb 2022 22:36:36 -0500
X-MC-Unique: V18G3fZNNRKcGPCAq4BfZw-1
Received: by mail-lf1-f72.google.com with SMTP id u14-20020a196a0e000000b0044139d17aceso190999lfu.15
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 19:36:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RvjYmb4fznf4B7CPoj9ot4B6+UX+ip1V7EfG8FVrs/w=;
        b=s/id3qIwTiEgoDqcr7t+FpxDRU7I6wHEOvsGigUNxP328d50SrhuNcQxLxyVL9i+k8
         xUbUabIglmnFAY0fJjBgXNsZnaE4mmDI0h2LzXw+xUk9gmfyEpzcMbC8QVxnmp1Dmryz
         ya2YJ3w33RCki1maU455s7XK5smRhG16Xf1ORlK2ZRfhBccs5NByDYCssPLjNq+PM7m2
         FANTplYlU4Uxp4OI+bGlHisYAnd9NJvcs5SuSJLYW9xy2pF8z1shNRDF3PTdxBOhfIgo
         E5il0CjfleNxdD4m07jZEteQ9n7XCk0PcfnaNuiTv9r4Z1aJ6AxnM33Qrysg78jPwCTY
         8hFw==
X-Gm-Message-State: AOAM533va+KGHwwlLVN6GODB4zSjV3wWvxv+pVlijHGrT2xcIv7LdGGD
        qilGr1f6wAMR8kSUyRSnxx2wT6tHN+PyyAbzUD42GJoC/qtYo4vMS10MEhnlvQs74/65YIFNTVv
        KBJdQVfLGRdLuYT1iC8oxil5ZxFvaELt4
X-Received: by 2002:a2e:9c02:: with SMTP id s2mr1568575lji.217.1644291394397;
        Mon, 07 Feb 2022 19:36:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMI8o//xEA9K104uQ3Yysm0k68EfVhZh1ieP1yTpxYlAIN/TFaRuip8eyeyhBON0GOKIx6a2oM+t+M5gdNlNU=
X-Received: by 2002:a2e:9c02:: with SMTP id s2mr1568554lji.217.1644291394065;
 Mon, 07 Feb 2022 19:36:34 -0800 (PST)
MIME-Version: 1.0
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
 <20220126073533.44994-2-xuanzhuo@linux.alibaba.com> <28013a95-4ce4-7859-9ca1-d836265e8792@redhat.com>
 <1644213876.065673-2-xuanzhuo@linux.alibaba.com> <CACGkMEuJ_v5g2ypLZ3eNhAcUM9Q3PpWuiaeWVfEC6KACGzWAZw@mail.gmail.com>
 <1644286649.5989025-1-xuanzhuo@linux.alibaba.com> <CACGkMEvVmKg0r4WudojL6dGt3vG4f=_4Pnsn-kBwQcge63jNqQ@mail.gmail.com>
 <1644290312.0241497-3-xuanzhuo@linux.alibaba.com> <CACGkMEtOoSF293nDwLFpAcs9M1+sUZufO309kCO0tRy7w40vdQ@mail.gmail.com>
 <1644290712.5535257-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644290712.5535257-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 8 Feb 2022 11:36:23 +0800
Message-ID: <CACGkMEshTp8vSP9=pKj82y8+DDQFu9tFAk1EGhMZLvXUE-OSEA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 11:29 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrot=
e:
>
> On Tue, 8 Feb 2022 11:24:13 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> > On Tue, Feb 8, 2022 at 11:20 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> =
wrote:
> > >
> > > On Tue, 8 Feb 2022 11:03:17 +0800, Jason Wang <jasowang@redhat.com> w=
rote:
> > > > On Tue, Feb 8, 2022 at 10:17 AM Xuan Zhuo <xuanzhuo@linux.alibaba.c=
om> wrote:
> > > > >
> > > > > On Mon, 7 Feb 2022 16:06:15 +0800, Jason Wang <jasowang@redhat.co=
m> wrote:
> > > > > > On Mon, Feb 7, 2022 at 2:07 PM Xuan Zhuo <xuanzhuo@linux.alibab=
a.com> wrote:
> > > > > > >
> > > > > > > On Mon, 7 Feb 2022 11:41:06 +0800, Jason Wang <jasowang@redha=
t.com> wrote:
> > > > > > > >
> > > > > > > > =E5=9C=A8 2022/1/26 =E4=B8=8B=E5=8D=883:35, Xuan Zhuo =E5=
=86=99=E9=81=93:
> > > > > > > > > Add queue_notify_data in struct virtio_pci_common_cfg, wh=
ich comes from
> > > > > > > > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > > > > > > > >
> > > > > > > > > Since I want to add queue_reset after it, I submitted thi=
s patch first.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > > > > > ---
> > > > > > > > >   include/uapi/linux/virtio_pci.h | 1 +
> > > > > > > > >   1 file changed, 1 insertion(+)
> > > > > > > > >
> > > > > > > > > diff --git a/include/uapi/linux/virtio_pci.h b/include/ua=
pi/linux/virtio_pci.h
> > > > > > > > > index 3a86f36d7e3d..492c89f56c6a 100644
> > > > > > > > > --- a/include/uapi/linux/virtio_pci.h
> > > > > > > > > +++ b/include/uapi/linux/virtio_pci.h
> > > > > > > > > @@ -164,6 +164,7 @@ struct virtio_pci_common_cfg {
> > > > > > > > >     __le32 queue_avail_hi;          /* read-write */
> > > > > > > > >     __le32 queue_used_lo;           /* read-write */
> > > > > > > > >     __le32 queue_used_hi;           /* read-write */
> > > > > > > > > +   __le16 queue_notify_data;       /* read-write */
> > > > > > > > >   };
> > > > > > > >
> > > > > > > >
> > > > > > > > So I had the same concern as previous version.
> > > > > > > >
> > > > > > > > This breaks uABI where program may try to use sizeof(struct
> > > > > > > > virtio_pci_common_cfg).
> > > > > > > >
> > > > > > > > We probably need a container structure here.
> > > > > > >
> > > > > > > I see, I plan to add a struct like this, do you think it's ap=
propriate?
> > > > > > >
> > > > > > > struct virtio_pci_common_cfg_v1 {
> > > > > > >         struct virtio_pci_common_cfg cfg;
> > > > > > >         __le16 queue_notify_data;       /* read-write */
> > > > > > > }
> > > > > >
> > > > > > Something like this but we probably need a better name.
> > > > >
> > > > >
> > > > > how about this?
> > > > >
> > > > >         /* Ext Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
> > > > >         struct virtio_pci_common_cfg_ext {
> > > > >                 struct virtio_pci_common_cfg cfg;
> > > > >
> > > > >                 __le16 queue_notify_data;       /* read-write */
> > > > >
> > > > >                 __le16 reserved0;
> > > > >                 __le16 reserved1;
> > > > >                 __le16 reserved2;
> > > > >                 __le16 reserved3;
> > > > >                 __le16 reserved4;
> > > > >                 __le16 reserved5;
> > > > >                 __le16 reserved6;
> > > > >                 __le16 reserved7;
> > > > >                 __le16 reserved8;
> > > > >                 __le16 reserved9;
> > > > >                 __le16 reserved10;
> > > > >                 __le16 reserved11;
> > > > >                 __le16 reserved12;
> > > > >                 __le16 reserved13;
> > > > >                 __le16 reserved14;
> > > > >         };
> > > >
> > > > I still think the container without padding is better. Otherwise
> > > > userspace needs to use offset_of() trick instead of sizeof().
> > >
> > > In this case, as virtio_pci_common_cfg_ext adds new members in the fu=
ture, we
> > > will add more container structures.
> > >
> > > In that case, I think virtio_pci_common_cfg_v1 is a good name instead=
.
> >
> > Something like "virtio_pci_common_cfg_notify" might be a little bit bet=
ter.
>
> Although there is only one notify_data in this patch, I plan to look like=
 this
> after my patch set:
>
>         struct virtio_pci_common_cfg_v1 {
>                 struct virtio_pci_common_cfg cfg;
>
>                 __le16 queue_notify_data;       /* read-write */
>                 __le16 queue_reset;       /* read-write */
>         }
>
> If we use virtio_pci_common_cfg_notify, then we will get two structures a=
fter
> this patch set:
>
>         struct virtio_pci_common_cfg_notify {
>                 struct virtio_pci_common_cfg cfg;
>
>                 __le16 queue_notify_data;       /* read-write */
>         }
>
>         struct virtio_pci_common_cfg_reset {
>                 struct virtio_pci_common_cfg_notify cfg;
>
>                 __le16 queue_reset;       /* read-write */
>         }

Right, this is sub-optimal, and we need padding in cfg_notify
probably. But I couldn't think of a better idea currently, maybe we
can listen from others opinion

But we use something like this for vnet_header extension

struct virtio_net_hdr_v1{
};

struct virtio_net_hdr_v1_hash{
struct virtio_net_hdr_v1;
__le32 XXX;
...
__le16 padding;
};

And it's not hard to imagine there would be another container for
struct virtio_net_hdr_v1_hash in the future if we want to extend vnet
header.

Thanks

>
>
> Thanks.
>
> >
> > Thanks
> >
> > >
> > > Thanks.
> > >
> > >
> > > >
> > > > Thanks
> > > >
> > > > >
> > > > > Thanks
> > > > >
> > > > > >
> > > > > > Thanks
> > > > > >
> > > > > > >
> > > > > > > Thanks.
> > > > > > >
> > > > > > > >
> > > > > > > > THanks
> > > > > > > >
> > > > > > > >
> > > > > > > > >
> > > > > > > > >   /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> > > > > > > >
> > > > > > >
> > > > > >
> > > > >
> > > >
> > >
> >
>

