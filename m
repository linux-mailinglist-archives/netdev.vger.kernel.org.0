Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7399437A1AC
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 10:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhEKIZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 04:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbhEKIZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 04:25:09 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75937C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:24:03 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso16828525otn.3
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 01:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8c3iY9QRs+Fk/AUUgLxZIXmDXwT2HDilLt2LH9nAQ6U=;
        b=SqBwnwM/kJAFlwEGwiDXj9c7Ma91fjZu8ayYoELqm6GAIraQZAPdhEQs9Hoyl60W7M
         9Ce+tx+Gq0OFiKUjBDFbh8nmAsNk3mVX8aqVUZ/0OUYvPd6aP9FxVuD8qcxKLUJqcJFj
         puE3BNalWBDmjJhF+s/HUDKh2qdbsPyxeVVBrifg/Hfyf/Ctj6UoSwML0EHIFaxkD+QY
         gm+xTm6+/oSes6XIfdyECwuy1wC3CzjtM0nDX3ec/4ay5/DjTSzzkuiH7noGXBu/Z66t
         4Pbpacn7kC8sS5PNmMjh0yzrPmqbjG8KPdHgYw9ca0CNg+In5D9zM8//YMnN6E18QQmV
         TvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8c3iY9QRs+Fk/AUUgLxZIXmDXwT2HDilLt2LH9nAQ6U=;
        b=Z7TcBU9SKuIoRXkIUa27h1BJoDd1t7Wcm4trGyD5VhLC/99bWFWtqFiHVOyn4NLxCX
         qtKC/mc2W5SDNilA1siBhzR9Xmqdowt4SEYmMS7SJihRC0JjBpvgRdm2+O0r/JrMh1kT
         JD2+e6CIRiTvGl7A8X9Lgzvt1yKNmZLXWiRDOCq/BxnhZxKCWivdqNqe0tB28OM7t6eZ
         dE+m+UQt731Fcr8/c3ujG3C/iwkVkmYkiUYQfywAfO0o6BdrPTN0QkGi5hybiZdqwRMn
         viZdf7FyActv4ErqN1m9+ukxJOxPwKdM9QrwVJpzjAU1ZYX5UWEtuDLIHd03MTjVZDW6
         CPHg==
X-Gm-Message-State: AOAM531YzOMM+o+GycyMJoeSQYCdqDXIJaptdBAtpv2aXLH65/APj83K
        ZtWlYZNvPCG+GzLgixK0GA0OgT3mtTltPyXvO66HSQ==
X-Google-Smtp-Source: ABdhPJyzEzyAj7Z5kcPuJk020RtLC8q4XOzVGi2sBCvpkZMkNcD6BbF/QWJXnNothiQ8DxWnWDUczdozPrAwgSSS7bA=
X-Received: by 2002:a05:6830:4103:: with SMTP id w3mr20687928ott.27.1620721442871;
 Tue, 11 May 2021 01:24:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210511044253.469034-1-yuri.benditovich@daynix.com>
 <20210511044253.469034-3-yuri.benditovich@daynix.com> <0e31ea70-f12a-070e-c72b-6e1d337a89bc@redhat.com>
In-Reply-To: <0e31ea70-f12a-070e-c72b-6e1d337a89bc@redhat.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Tue, 11 May 2021 11:23:50 +0300
Message-ID: <CAOEp5Ofi52eCV1R261afkC2Oqgn5v8V6w3QQP8tHWcEiLmsUSQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] virtio-net: add support of UDP segmentation (USO) on
 the host
To:     Jason Wang <jasowang@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Yan Vugenfirer <yan@daynix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 9:47 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/11 =E4=B8=8B=E5=8D=8812:42, Yuri Benditovich =E5=86=99=
=E9=81=93:
> > Large UDP packet provided by the guest with GSO type set to
> > VIRTIO_NET_HDR_GSO_UDP_L4 will be divided to several UDP
> > packets according to the gso_size field.
> >
> > Signed-off-by: Yuri Benditovich <yuri.benditovich@daynix.com>
> > ---
> >   include/linux/virtio_net.h | 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > index b465f8f3e554..4ecf9a1ca912 100644
> > --- a/include/linux/virtio_net.h
> > +++ b/include/linux/virtio_net.h
> > @@ -51,6 +51,11 @@ static inline int virtio_net_hdr_to_skb(struct sk_bu=
ff *skb,
> >                       ip_proto =3D IPPROTO_UDP;
> >                       thlen =3D sizeof(struct udphdr);
> >                       break;
> > +             case VIRTIO_NET_HDR_GSO_UDP_L4:
> > +                     gso_type =3D SKB_GSO_UDP_L4;
> > +                     ip_proto =3D IPPROTO_UDP;
> > +                     thlen =3D sizeof(struct udphdr);
> > +                     break;
>
>
> This is only for rx, how about tx?

In terms of the guest this is only for TX.
Guest RX is a different thing, this is actually coalescing of
segmented UDP packets into a large one.
This feature is not defined in the virtio spec yet and the support of
it first of all depends on the OS.
For example: TCP LSO (guest TX) is supported almost by all the
versions of Windows.
TCP RSC (coalescing of TCP segments) is supported by Win 8 / Server 2012 an=
d up.
UDP segmentation is supported by Windows kernels 1903+
UDP coalescing is defined by Windows kernels 2004+ and not supported
by the driver yet.

>
> Thanks
>
>
>
> >               default:
> >                       return -EINVAL;
> >               }
>
