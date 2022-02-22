Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F014BF8E3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiBVNPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiBVNPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:15:20 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B66EA15C65E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:14:55 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id r15-20020a4ae5cf000000b002edba1d3349so17416827oov.3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CEerrz21cbosvpLV95NRyIff4EV45dk3/IMZ19l1mpI=;
        b=MYcI+sOXGRtToSec1JNnWD66yy1q0es9zhN+oL36gOb/Hu4+7wh/Pa1XfmSaoSSix9
         1nOcIApEvHjHTYH8dN78QQduPQkbCzC6j0vOyQ23VlQtL9S4gP+B/LDNt/gTwnCjskmH
         cqD45Ozrf/uG+AHj91OaeuXR8cy0SysEfuOWS4FGCv11uISFfgtzy+pC8zYPUxfZ7tEx
         QSLLqgRVljcO28Qoy7llIGxinK0jfrV2vj6YzSCPsGSpl1QMc0Ovbe/IrkT+3ioXqmbQ
         MxOoOIWr0WF60Tfgx9toC5/p1XkyDv25Wila7Xl96aze7/KHxKP+Jn1ktiCkut+aSWsA
         F9/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CEerrz21cbosvpLV95NRyIff4EV45dk3/IMZ19l1mpI=;
        b=qfW0b3GMuYXv6x8m84ugPc0prJD7jPWAORAm8W3d2IZM4v4n0w0gvzFIpM+xAVr9b1
         feUO2VBW3vCMrS1bVcqwcr4NnxSshd2YN/xgC9bdahLJN2FMXO6LVtI+PsIyNtnfb76D
         cQxWrkymXHj6nNfWHiUs48NhX3HWa3ftKFfHxgDtxRzJpK0Pyf4IPw5UaHuyYRRZNAfd
         hPMx9oGTQgReMUfFo5tAL1Al4klHeWXCeOn+bHJLGY9fZ3czLNfOWyjkPaSOZE0RVQIL
         OO+Fdwua2IGi9dm1Orhgy7jWSV9X5NbjNVuzxo1fEYFahIU7zdamS22sBJIPLw9tZ/BR
         rZtQ==
X-Gm-Message-State: AOAM531FXFalicVDFcffNBA7xRsJwxX2UxjxfaHw3KkJ9u7WZAGWMOo4
        dEmGDmsBrregNPrfZfQ+ntcLg2KwFTtQsxbvsXKYnw==
X-Google-Smtp-Source: ABdhPJzzMUNAaPhJBgVrHvZGRzZ8MtWaaLKCnyy9cfxZkQsuxRulZ5I865w9LO7+zeY/fxq84ZXXKr0g749GxGoldwM=
X-Received: by 2002:a05:6870:6106:b0:d4:473f:7671 with SMTP id
 s6-20020a056870610600b000d4473f7671mr1500451oae.327.1645535695116; Tue, 22
 Feb 2022 05:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <20220125084702.3636253-4-andrew@daynix.com>
 <158bf351-9ffd-39d0-8658-52d4667f781d@redhat.com>
In-Reply-To: <158bf351-9ffd-39d0-8658-52d4667f781d@redhat.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Tue, 22 Feb 2022 15:14:44 +0200
Message-ID: <CABcq3pF=_ocbk=GaNZqr5YRSzFt11F508Fb76JxKRXFzfh1D2w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/5] uapi/linux/virtio_net.h: Added USO types.
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,



On Wed, Feb 9, 2022 at 6:41 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/1/25 =E4=B8=8B=E5=8D=884:47, Andrew Melnychenko =E5=86=99=
=E9=81=93:
> > Added new GSO type for USO: VIRTIO_NET_HDR_GSO_UDP_L4.
> > Feature VIRTIO_NET_F_HOST_USO allows to enable NETIF_F_GSO_UDP_L4.
> > Separated VIRTIO_NET_F_GUEST_USO4 & VIRTIO_NET_F_GUEST_USO6 features
> > required for Windows guests.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >   include/uapi/linux/virtio_net.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virti=
o_net.h
> > index 3f55a4215f11..620addc5767b 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -56,6 +56,9 @@
> >   #define VIRTIO_NET_F_MQ     22      /* Device supports Receive Flow
> >                                        * Steering */
> >   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23       /* Set MAC address */
> > +#define VIRTIO_NET_F_GUEST_USO4      54      /* Guest can handle USOv4=
 in. */
> > +#define VIRTIO_NET_F_GUEST_USO6      55      /* Guest can handle USOv6=
 in. */
> > +#define VIRTIO_NET_F_HOST_USO        56      /* Host can handle USO in=
. */
>
>
> I think it's better to be consistent here. Either we split in both guest
> and host or not.
>
> Thanks
>

The main reason that receives USO packets depends on the kernel, where
transmitting the feature that VirtIO implements.
Windows systems have the option to manipulate receive offload. That's
why there are two GUEST_USO features.
For HOST_USO - technically there is no point in "split" it, and there
is should not be any difference between IPv4/IPv6.
Technically, we either support transmitting big UDP packets or not.

>
> >
> >   #define VIRTIO_NET_F_HASH_REPORT  57        /* Supports hash report *=
/
> >   #define VIRTIO_NET_F_RSS      60    /* Supports RSS RX steering */
> > @@ -130,6 +133,7 @@ struct virtio_net_hdr_v1 {
> >   #define VIRTIO_NET_HDR_GSO_TCPV4    1       /* GSO frame, IPv4 TCP (T=
SO) */
> >   #define VIRTIO_NET_HDR_GSO_UDP              3       /* GSO frame, IPv=
4 UDP (UFO) */
> >   #define VIRTIO_NET_HDR_GSO_TCPV6    4       /* GSO frame, IPv6 TCP */
> > +#define VIRTIO_NET_HDR_GSO_UDP_L4    5       /* GSO frame, IPv4 & IPv6=
 UDP (USO) */
> >   #define VIRTIO_NET_HDR_GSO_ECN              0x80    /* TCP has ECN se=
t */
> >       __u8 gso_type;
> >       __virtio16 hdr_len;     /* Ethernet + IP + tcp/udp hdrs */
>
