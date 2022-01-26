Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F415249C550
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238501AbiAZIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiAZIcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 03:32:36 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8646C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:32:36 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id o9-20020a9d7189000000b0059ee49b4f0fso11776703otj.2
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 00:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e2BGPbgxNsjIOcq9lLJ9KQzQO0Zg9McVWQ2H+KEkY/8=;
        b=IuF0OHqM0YtU+6Ni8u9RjwmM75GrCxWoyVk4PDoMariwcrvsfp2YuifnjJWjufDcSm
         13iUSKEGxgEBLZDhNb4mS4ESnWp0l5FqFxXXR7ZrFQR1Z9VbnMhuAyCgTxQ66ab3u1S3
         Q/2W/tHwp7TRz4fIFQrRy0/V1tj8qRxQ+m52iMOYuS7RSQFQbRt/lLECdvi6ER/UdiO6
         MmnGb4Ijjut54FHIVE1ufzmRWGeCI6glhHhYTf3EUTJgGY46r7c7EEF0WIXRjhQ63Jne
         qRrHeYfCKZQRP/pd1cS9ONanSzhHaI0f+8ZT9YnU4nmPiIV1ETutvIXdnFOsI1XbG+YF
         bBdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e2BGPbgxNsjIOcq9lLJ9KQzQO0Zg9McVWQ2H+KEkY/8=;
        b=YafnUA89bVdWtx2knO5/OVqIQKlxj33WRFF5240paOko+vmehDiquchCYpBQsedhjs
         HttE+7OlOoXBBj3DByMWWGY5rFffNeT1hZb8uIHRw2Uyw7PRYq/n824mfy1KkOQ+HF7O
         WrHF5TG1JQNBKMC8bTtfIO7i+ZqcnDU2u4KL1DlHD61PkuUdECnF4OTakhyQ68LPU9YT
         4qcCiWBNDs5t5P1x0ahhpM6pfIaTHioihNTisJJD7sK81wA8GsxmmMngpQo5gZ5G+o3k
         KGDH6HX7ATCLPaizDsHt1+JOI0dHxrHRy12N03GaxRRBQiJzFu7kHHSr2l1RH+5SP5TO
         5D3Q==
X-Gm-Message-State: AOAM5315hg1LNbONWkqpnzLC+fBK0u3uE7dMcmkLw1SKmlLQyya/ypVL
        yKZOSSKPQFfC0u7FcaEJ9GP1RcHi5jXk17UqiEJsSQ==
X-Google-Smtp-Source: ABdhPJz1eMtqPc7zF2TNXjxiyxOoImyr6IMt5tZ8nz4RKJOIHml02NLosf18hu6uaIzph0k5GPQaTnHAFDmrKNtyTEo=
X-Received: by 2002:a05:6830:4013:: with SMTP id h19mr11781846ots.153.1643185956172;
 Wed, 26 Jan 2022 00:32:36 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <1643183537.4001389-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <1643183537.4001389-1-xuanzhuo@linux.alibaba.com>
From:   Yuri Benditovich <yuri.benditovich@daynix.com>
Date:   Wed, 26 Jan 2022 10:32:24 +0200
Message-ID: <CAOEp5OcwLiLZuVOAxx+pt6uztP-cGTgqsUSQj7N7HKTZgmyN3w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] TUN/VirtioNet USO features support.
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Andrew Melnychenko <andrew@daynix.com>,
        Yan Vugenfirer <yan@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 9:54 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>
> On Tue, 25 Jan 2022 10:46:57 +0200, Andrew Melnychenko <andrew@daynix.com> wrote:
> > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > Technically they enable NETIF_F_GSO_UDP_L4
> > (and only if USO4 & USO6 are set simultaneously).
> > It allows to transmission of large UDP packets.
> >
> > Different features USO4 and USO6 are required for qemu where Windows guests can
> > enable disable USO receives for IPv4 and IPv6 separately.
> > On the other side, Linux can't really differentiate USO4 and USO6, for now.
> > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> >
> > Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
> >
> > New types for VirtioNet already on mailing:
> > https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html
>
> Seems like this hasn't been upvoted yet.
>
>         https://github.com/oasis-tcs/virtio-spec#use-of-github-issues

Yes, correct. This is a reason why this series of patches is RFC.

>
> Thanks.
>
> >
> > Also, there is a known issue with transmitting packages between two guests.
> > Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
> >
> > Andrew Melnychenko (5):
> >   uapi/linux/if_tun.h: Added new ioctl for tun/tap.
> >   driver/net/tun: Added features for USO.
> >   uapi/linux/virtio_net.h: Added USO types.
> >   linux/virtio_net.h: Added Support for GSO_UDP_L4 offload.
> >   drivers/net/virtio_net.c: Added USO support.
> >
> >  drivers/net/tap.c               | 18 ++++++++++++++++--
> >  drivers/net/tun.c               | 15 ++++++++++++++-
> >  drivers/net/virtio_net.c        | 22 ++++++++++++++++++----
> >  include/linux/virtio_net.h      | 11 +++++++++++
> >  include/uapi/linux/if_tun.h     |  3 +++
> >  include/uapi/linux/virtio_net.h |  4 ++++
> >  6 files changed, 66 insertions(+), 7 deletions(-)
> >
> > --
> > 2.34.1
> >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
