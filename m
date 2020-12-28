Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6272E2E6C61
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729679AbgL1Wzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729275AbgL1Tbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 14:31:51 -0500
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9893AC0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:31:11 -0800 (PST)
Received: by mail-ua1-x934.google.com with SMTP id t15so3654299ual.6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3BJ5esnFQukEGJPUA6O1ADA24la79M+/XQkO2LPRNkc=;
        b=X+XV3552fBBK1tjz6k7cY5dwoNjbSrjXQc3RWSQdXdcf0dfgE9zyb5x1nX6/LMsK60
         rL17SN/dFQQ7K33yH9hwaZBWI7V3aEGm5l5802qrTv09DHOEcoUdDw20uFNyB0PSDJj9
         2NMnbeaQ/rBrZAMDg09MisaS6oTW/ulCMeMIP3T7lDBjdZOuwR7sIZQXzCCiDOIfqgYj
         TJbtPEZnhiGCcWOIIBjYG1Cba0Sf64Pfr2qn2F81VSChxVuOsPNqWcssLEbUdzeeEinp
         9j2guH6TQhNsx4COPZaJ2NHnFLEMFqOp4SzMc4geWkcmvefs4XhnGoETeFkb0LBRqvRz
         f3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3BJ5esnFQukEGJPUA6O1ADA24la79M+/XQkO2LPRNkc=;
        b=i7vhhlgihvVszAdCESZYK7Yv7f/5G2yIHR/CnGQ1lbM84KCKQCRxCcVafqbnJaFuim
         0wArugFNlyPjZdJIuKM2/N6+p5CrrWUxMosmdb2insvzAwMsweMrVSNfudAN+xfPMUvf
         D6BzIYkBoVl7JvU4SleMVSWy/SLZLVlsQQvly2mT66ZEheMwGM2SMrO40AM7QmpY0NWC
         UDuv4Pbp3iHhJVWLmymB/qqwzqizcT2LY8AHYrq/c8y1CCdYGG7Qd65MwRHpkL+p5eku
         tRU5zmwRPzUPZ8eXqq+o474ExmIgP5DTzSYs49E71q+B3FucxyX6pbw/OZkNsAWFH620
         TGXw==
X-Gm-Message-State: AOAM533lpnUzp/7QfuaHd8rj9TEl+J2QbFeC6IkhkRFUDz+gT+8tAOrk
        bRjV24JFnPCCpwGdn24oGR6YEeP3utM=
X-Google-Smtp-Source: ABdhPJwBgvQAhJVt2SLU9ImZYaMheqHoHJeUiFaNWPCQnMsr4uYH3DxME0n/Lyt9Ynwij5tdqtWCag==
X-Received: by 2002:ab0:2e8e:: with SMTP id f14mr28605397uaa.22.1609183869839;
        Mon, 28 Dec 2020 11:31:09 -0800 (PST)
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com. [209.85.221.179])
        by smtp.gmail.com with ESMTPSA id b7sm4699037uaq.4.2020.12.28.11.31.08
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 11:31:08 -0800 (PST)
Received: by mail-vk1-f179.google.com with SMTP id l187so2518095vki.6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 11:31:08 -0800 (PST)
X-Received: by 2002:a1f:9ed4:: with SMTP id h203mr29461301vke.1.1609183868110;
 Mon, 28 Dec 2020 11:31:08 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com> <20201228122253-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228122253-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 14:30:31 -0500
X-Gmail-Original-Message-ID: <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
Message-ID: <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > From: Willem de Bruijn <willemb@google.com>
> >
> > Add optional PTP hardware timestamp offload for virtio-net.
> >
> > Accurate RTT measurement requires timestamps close to the wire.
> > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > virtio-net header is expanded with room for a timestamp. A host may
> > pass receive timestamps for all or some packets. A timestamp is valid
> > if non-zero.
> >
> > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > international atomic time (CLOCK_TAI) as global clock base. It is
> > guest responsibility to sync with host, e.g., through kvm-clock.
> >
> > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > index f6881b5b77ee..0ffe2eeebd4a 100644
> > --- a/include/uapi/linux/virtio_net.h
> > +++ b/include/uapi/linux/virtio_net.h
> > @@ -57,6 +57,7 @@
> >                                        * Steering */
> >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> >
> > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> >       };
> >  };
> >
> > +struct virtio_net_hdr_v12 {
> > +     struct virtio_net_hdr_v1 hdr;
> > +     struct {
> > +             __le32 value;
> > +             __le16 report;
> > +             __le16 flow_state;
> > +     } hash;
> > +     __virtio32 reserved;
> > +     __virtio64 tstamp;
> > +};
> > +
> >  #ifndef VIRTIO_NET_NO_LEGACY
> >  /* This header comes first in the scatter-gather list.
> >   * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
>
>
> So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
> VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?

Do you mean VIRTIO_NET_F_TX_TSTAMP depends on VIRTIO_NET_F_RX_TSTAMP?

I think if either is enabled we need to enable the extended layout.
Regardless of whether TX_HASH or HASH_REPORT are enabled. If they are
not, then those fields are ignored.

> I am not sure what does v12 mean here.
>
> virtio_net_hdr_v1 is just with VIRTIO_F_VERSION_1,
> virtio_net_hdr_v1_hash is with VIRTIO_F_VERSION_1 and
> VIRTIO_NET_F_HASH_REPORT.
>
> So this one is virtio_net_hdr_hash_tstamp I guess?

Sounds better, yes, will change that.

This was an attempt at identifying the layout with the likely next
generation of the spec, 1.2. Similar to virtio_net_hdr_v1. But that is
both premature and not very helpful.
