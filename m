Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA214AB667
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 09:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240201AbiBGIOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 03:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244079AbiBGIGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 03:06:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D2C6C043184
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 00:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644221189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hrBG/poLkL/lLZ3kXUYigUvYKKxYkaMg+jNVui/yCn4=;
        b=bfo/skn0HcyXTB5gfikfNiJUs41xkyUCSzRvrUdoNse4aOWvXYuc+kGU+F37CBBfhFi9Od
        pIyTDoBhAwKK4Bv2+cMk/iqsKQLUFPuH054DO7yt6IwpnvcKIpHmutvYVYZf/lRJG+3A8T
        8MEWGHN7edQHaePQpuztViqvJLk+91c=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-sDI0xNlZMaak5UJQliLZPQ-1; Mon, 07 Feb 2022 03:06:27 -0500
X-MC-Unique: sDI0xNlZMaak5UJQliLZPQ-1
Received: by mail-lj1-f198.google.com with SMTP id w4-20020a05651c102400b0023d50aba238so4147462ljm.22
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 00:06:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hrBG/poLkL/lLZ3kXUYigUvYKKxYkaMg+jNVui/yCn4=;
        b=0+jbpgk+k/z6cyjgBLGsucDauxXpyq8Nq9H7Zoj2gOdqfl5vc83gSr3RnPPDby0+Ez
         CC2cAxhmBWPVFeXsZoz0llzDqm0imWVTc8IaRLwb0rwOfXEcMieUlZfeIf+ErTpEiVTs
         ryfdIp+0NabqCqt9PWKqFD3kiO0XcogJcVPBm7qu4WlLjxu8FLZulcLANOveypIV3H1e
         YlEV4Pm62qMcMpMz/nOMWK+ZT9PSXcYbOmDVpLhNu/uXSh+2ok89hnOL4EMiVSEviUk+
         IGUXXaJ/raOLpqyDngeeuIRsTuPJdgbVCvwh3ZmZgXW4KbvrxmPb16UE0Svk+YtvEMhD
         Jjjw==
X-Gm-Message-State: AOAM531FHlx4SHvWtptDRd8ZxP+1JTQ90si34SpFjKtUq7K/yovWOcGY
        zvHztVfZzx0+h7AHVsitlsmri3hqgxdV9uX4IgqidGkY1LFOxCVZRDlbJp+COzlGnydg59u/42y
        XcEYSBCQnMt4xpM1bEbQkYr6NvyjnmrfG
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr6687398lfb.498.1644221186248;
        Mon, 07 Feb 2022 00:06:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0DHyEmoITa1BBraG4UZnw98YqyHS8LEhTKBkLYYBW2asYSlz9ovqB44ewRvgt48bhRU26fe8jVPKrnUet8ao=
X-Received: by 2002:a05:6512:e9c:: with SMTP id bi28mr6687376lfb.498.1644221185952;
 Mon, 07 Feb 2022 00:06:25 -0800 (PST)
MIME-Version: 1.0
References: <28013a95-4ce4-7859-9ca1-d836265e8792@redhat.com> <1644213876.065673-2-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1644213876.065673-2-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 7 Feb 2022 16:06:15 +0800
Message-ID: <CACGkMEuJ_v5g2ypLZ3eNhAcUM9Q3PpWuiaeWVfEC6KACGzWAZw@mail.gmail.com>
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

On Mon, Feb 7, 2022 at 2:07 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote=
:
>
> On Mon, 7 Feb 2022 11:41:06 +0800, Jason Wang <jasowang@redhat.com> wrote=
:
> >
> > =E5=9C=A8 2022/1/26 =E4=B8=8B=E5=8D=883:35, Xuan Zhuo =E5=86=99=E9=81=
=93:
> > > Add queue_notify_data in struct virtio_pci_common_cfg, which comes fr=
om
> > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > >
> > > Since I want to add queue_reset after it, I submitted this patch firs=
t.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >   include/uapi/linux/virtio_pci.h | 1 +
> > >   1 file changed, 1 insertion(+)
> > >
> > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/vir=
tio_pci.h
> > > index 3a86f36d7e3d..492c89f56c6a 100644
> > > --- a/include/uapi/linux/virtio_pci.h
> > > +++ b/include/uapi/linux/virtio_pci.h
> > > @@ -164,6 +164,7 @@ struct virtio_pci_common_cfg {
> > >     __le32 queue_avail_hi;          /* read-write */
> > >     __le32 queue_used_lo;           /* read-write */
> > >     __le32 queue_used_hi;           /* read-write */
> > > +   __le16 queue_notify_data;       /* read-write */
> > >   };
> >
> >
> > So I had the same concern as previous version.
> >
> > This breaks uABI where program may try to use sizeof(struct
> > virtio_pci_common_cfg).
> >
> > We probably need a container structure here.
>
> I see, I plan to add a struct like this, do you think it's appropriate?
>
> struct virtio_pci_common_cfg_v1 {
>         struct virtio_pci_common_cfg cfg;
>         __le16 queue_notify_data;       /* read-write */
> }

Something like this but we probably need a better name.

Thanks

>
> Thanks.
>
> >
> > THanks
> >
> >
> > >
> > >   /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> >
>

