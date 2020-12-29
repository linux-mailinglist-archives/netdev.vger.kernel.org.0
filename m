Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DAE2E7154
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 15:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgL2OVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Dec 2020 09:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgL2OVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Dec 2020 09:21:34 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F6AC0613D6
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 06:20:54 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id x26so7134442vsq.1
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 06:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BI7YG4D/264hD48pBSTZ/cy9Mm52S+GHG7c9KEI8pu0=;
        b=e81ECpwp2xvN7FDpxWZQqIl3/z89VLROaeHh9a+okFWDolCAek/dh8YpVolJ6Tjip/
         0hdwcqTKFd/nLcDajbtrs8pf3w/5Ms+ee+tgUn+0xaxYB52Bpy9BhFknAWBvlYbYZ0SI
         kz4izi51Xe5Xx4A5Azll9kChtXimwHc2eQ4viGcsJcN+qMIAtkLuPoFb+bdY8RTT02Yj
         QUkcnue03cIpYiT6jnixkVyTwdEbRaOkgjzR7j7bR3UxDx6pgHxqhieyEQfpyRuamkht
         qxK3Ixwy1TyZPCBCSw7eO7bC6YfQY4QUstQBn0n0d8sff2PzZpn6Q05XMVJ0tZ7U3xaU
         rg2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BI7YG4D/264hD48pBSTZ/cy9Mm52S+GHG7c9KEI8pu0=;
        b=SZKr+NFgT+921Z8BcJim6pmO04MZTuX9YslPiSfko97fAkcKUZkIXVtIQNZmZvzkem
         dSmcfCqxUddyaOb0dGDsYUzmfMEdSo2zmhJItM+hKKMLMCDdavn0FCtjpZnAIC5LMZRc
         abrftrDwXkNqU/9jMUs7Vvn8/NKCkt+qg+WBhS8Pszy0vD6igWdz/z+8CYId1bWBNuYn
         dSdoP/w2a5PyeejNrC1KCsBdEjzRhFvRgOevKvCceFax4pz35/rMpkAfPtJCMn1kZmly
         whel+5BB4s+shXyklKtZmDoH5eU5BICmGUzWkpQh+uZx1tC7xUphcb/giSTa+djj8Ku6
         WFEQ==
X-Gm-Message-State: AOAM531xVAIgpNkKcXiRAOq0XN33H852ZKBz94E9iUv0a+Qd8g/YdVFY
        jnosA/e/LD6/pC/4zeKfTPyzo6Y3o/A=
X-Google-Smtp-Source: ABdhPJwY3V8IrWBPxsPJuH2BHoTObxIlRgzE8ao6vXsPQ+moR6eR07f4/tEVxk9s5N3xBaRxfOu6oA==
X-Received: by 2002:a67:c89e:: with SMTP id v30mr29668539vsk.54.1609251652652;
        Tue, 29 Dec 2020 06:20:52 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id 45sm7434925uai.16.2020.12.29.06.20.51
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Dec 2020 06:20:51 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id f29so4371628uab.0
        for <netdev@vger.kernel.org>; Tue, 29 Dec 2020 06:20:51 -0800 (PST)
X-Received: by 2002:ab0:2:: with SMTP id 2mr19938128uai.108.1609251650821;
 Tue, 29 Dec 2020 06:20:50 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228122253-mutt-send-email-mst@kernel.org> <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
 <20201228162903-mutt-send-email-mst@kernel.org> <CA+FuTSffjFZGGwpMkpnTBbHHwnJN7if=0cVf0Des7Db5UFe0bw@mail.gmail.com>
 <1881606476.40780520.1609233449300.JavaMail.zimbra@redhat.com>
In-Reply-To: <1881606476.40780520.1609233449300.JavaMail.zimbra@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 29 Dec 2020 09:20:14 -0500
X-Gmail-Original-Message-ID: <CA+FuTScycxSHqxvZZRjK9+tpXVV2iTv8vqeFc5U_m2CGDR3jog@mail.gmail.com>
Message-ID: <CA+FuTScycxSHqxvZZRjK9+tpXVV2iTv8vqeFc5U_m2CGDR3jog@mail.gmail.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
To:     Jason Wang <jasowang@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 29, 2020 at 4:23 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> > On Mon, Dec 28, 2020 at 7:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Dec 28, 2020 at 02:30:31PM -0500, Willem de Bruijn wrote:
> > > > On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com>
> > > > wrote:
> > > > >
> > > > > On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > > > > > From: Willem de Bruijn <willemb@google.com>
> > > > > >
> > > > > > Add optional PTP hardware timestamp offload for virtio-net.
> > > > > >
> > > > > > Accurate RTT measurement requires timestamps close to the wire.
> > > > > > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > > > > > virtio-net header is expanded with room for a timestamp. A host may
> > > > > > pass receive timestamps for all or some packets. A timestamp is valid
> > > > > > if non-zero.
> > > > > >
> > > > > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > > > > international atomic time (CLOCK_TAI) as global clock base. It is
> > > > > > guest responsibility to sync with host, e.g., through kvm-clock.
> > > > > >
> > > > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > > > diff --git a/include/uapi/linux/virtio_net.h
> > > > > > b/include/uapi/linux/virtio_net.h
> > > > > > index f6881b5b77ee..0ffe2eeebd4a 100644
> > > > > > --- a/include/uapi/linux/virtio_net.h
> > > > > > +++ b/include/uapi/linux/virtio_net.h
> > > > > > @@ -57,6 +57,7 @@
> > > > > >                                        * Steering */
> > > > > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > > > > >
> > > > > > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI
> > > > > > receive time */
> > > > > >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> > > > > >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> > > > > >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > > > > > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> > > > > >       };
> > > > > >  };
> > > > > >
> > > > > > +struct virtio_net_hdr_v12 {
> > > > > > +     struct virtio_net_hdr_v1 hdr;
> > > > > > +     struct {
> > > > > > +             __le32 value;
> > > > > > +             __le16 report;
> > > > > > +             __le16 flow_state;
> > > > > > +     } hash;
> > > > > > +     __virtio32 reserved;
> > > > > > +     __virtio64 tstamp;
> > > > > > +};
> > > > > > +
> > > > > >  #ifndef VIRTIO_NET_NO_LEGACY
> > > > > >  /* This header comes first in the scatter-gather list.
> > > > > >   * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it
> > > > > >   must
> > > > >
> > > > >
> > > > > So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
> > > > > VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?
> > > >
> > > > Do you mean VIRTIO_NET_F_TX_TSTAMP depends on VIRTIO_NET_F_RX_TSTAMP?
> > > >
> > > > I think if either is enabled we need to enable the extended layout.
> > > > Regardless of whether TX_HASH or HASH_REPORT are enabled. If they are
> > > > not, then those fields are ignored.
> > >
> > > I mean do we waste the 8 bytes for hash if TSTAMP is set but HASH is not?
> > > If TSTAMP depends on HASH then point is moot.
> >
> > True, but the two features really are independent.
> >
> > I did consider using configurable metadata layout depending on
> > features negotiated. If there are tons of optional extensions, that
> > makes sense. But it is more complex and parsing error prone. With a
> > handful of options each of a few bytes, that did not seem worth the
> > cost to me at this point.
>
> Consider NFV workloads(64B) packet. Most fields of current vnet header
> is even a burdern.

Such workloads will not negotiate these features, I imagine.

I think this could only become an issue if a small packet workload
would want to negotiate one optional feature, without the others.

Even then, the actual cost of a few untouched bytes is negligible, as
long as the headers don't span cache-lines. I expect it to be cheaper
than having to parse a dynamic layout.

> It might be the time to introduce configurable or
> self-descriptive vnet header.

I did briefly toy with a type-val encoding. Not type-val-len, as all
options have fixed length (so far), so length can be left implicit.
But as each feature is negotiated before hand, the type can be left
implicit too. Leaving just the data elements tightly packed. As long
as order is defined.

> > And importantly, such a mode can always be added later as a separate
> > VIRTIO_NET_F_PACKED_HEADER option.
>
> What will do feature provide?

The tightly packed data elements. Strip out the elements for non
negotiated features. So if either tstamp option is negotiated, but
hash is not, exclude the 64b of hash fields. Note that I'm not
actually arguing for this (at this point).
