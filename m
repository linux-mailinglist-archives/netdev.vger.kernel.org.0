Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B32E6C02
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgL1Wzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729532AbgL1VeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 16:34:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609191175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kky13YYeGMwwJq8+sgfQqrY11M1VAYKqZAzG0e5Oygw=;
        b=cwjy8fTuKVAZPD70BW/HMpJNRJ/nzbtZuhXTquFaVVMStqREMPBd6cn9mJPFg3ni68c0ba
        mGBHHfsrdD7zwV84clzzNKF3mzL9NYzEYxUj3OgqMCSeiRnU2ylnhq48U1aKLUpSMhswxw
        1K9LkZvoxs3UAYc6U3GWZzfNUCtgXwk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-QdKgu8b3NwaQkwGzVZcgFA-1; Mon, 28 Dec 2020 16:32:53 -0500
X-MC-Unique: QdKgu8b3NwaQkwGzVZcgFA-1
Received: by mail-wm1-f69.google.com with SMTP id k67so238224wmk.5
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 13:32:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kky13YYeGMwwJq8+sgfQqrY11M1VAYKqZAzG0e5Oygw=;
        b=IyV7LxAyAHhGlLmphcl61szJ04Dwrk+9YHppTObDWPS6ItB/ZtUY9SfHDPXdPSXFsU
         O2c1nQm9ImXTLwVasKENXFFOJMCXI9EwAOIevVHuRiUytOeZGgoXS+wS1ehyp5qyMrDI
         wXV9V1cZvqPaoIOCXy4lbdsHN0JQsS0OV8CMRUCpzv6ePGgMdm9ZZ0CUl83yMJ7Gs8y5
         29+3JlmPvOttHZGOhZoL5g+U6OJis/5/2KGuTSkTEz4IjvRYChAg5JSfazeXAPZRYLxC
         UtWwIbzeWVMTsMocOGfYicASPLcsrfHgR/j9OmXnTTbbDkzelg1kt6LdWtHeGXcVitT9
         BMaQ==
X-Gm-Message-State: AOAM531WMAvJPso/PcyD0ZIAqcSU8o7uYt9PP+lMqeJMQMm2DYckXoKx
        cceP6ds46Ke8lfitpSKsZ5xYbTo0xGZf3uRqJE+4XAF5ilSWHAx8H2KKprc3cxhQ6pPYh28oVDT
        +mLfCPtlKDRBGAun5
X-Received: by 2002:adf:ee51:: with SMTP id w17mr54347192wro.97.1609191172395;
        Mon, 28 Dec 2020 13:32:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzlzIRThR3mCdWiZJqKQ1c7BH9fh0IsVBW/4vumudyEYrxI50Ukp5ubWsWCpdQyJq+bQyBQIw==
X-Received: by 2002:adf:ee51:: with SMTP id w17mr54347180wro.97.1609191172185;
        Mon, 28 Dec 2020 13:32:52 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id n8sm56352037wrs.34.2020.12.28.13.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 13:32:51 -0800 (PST)
Date:   Mon, 28 Dec 2020 16:32:48 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
Message-ID: <20201228162903-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228122253-mutt-send-email-mst@kernel.org>
 <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 02:30:31PM -0500, Willem de Bruijn wrote:
> On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Add optional PTP hardware timestamp offload for virtio-net.
> > >
> > > Accurate RTT measurement requires timestamps close to the wire.
> > > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > > virtio-net header is expanded with room for a timestamp. A host may
> > > pass receive timestamps for all or some packets. A timestamp is valid
> > > if non-zero.
> > >
> > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > international atomic time (CLOCK_TAI) as global clock base. It is
> > > guest responsibility to sync with host, e.g., through kvm-clock.
> > >
> > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > > index f6881b5b77ee..0ffe2eeebd4a 100644
> > > --- a/include/uapi/linux/virtio_net.h
> > > +++ b/include/uapi/linux/virtio_net.h
> > > @@ -57,6 +57,7 @@
> > >                                        * Steering */
> > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > >
> > > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> > >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> > >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> > >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> > >       };
> > >  };
> > >
> > > +struct virtio_net_hdr_v12 {
> > > +     struct virtio_net_hdr_v1 hdr;
> > > +     struct {
> > > +             __le32 value;
> > > +             __le16 report;
> > > +             __le16 flow_state;
> > > +     } hash;
> > > +     __virtio32 reserved;
> > > +     __virtio64 tstamp;
> > > +};
> > > +
> > >  #ifndef VIRTIO_NET_NO_LEGACY
> > >  /* This header comes first in the scatter-gather list.
> > >   * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
> >
> >
> > So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
> > VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?
> 
> Do you mean VIRTIO_NET_F_TX_TSTAMP depends on VIRTIO_NET_F_RX_TSTAMP?
> 
> I think if either is enabled we need to enable the extended layout.
> Regardless of whether TX_HASH or HASH_REPORT are enabled. If they are
> not, then those fields are ignored.

I mean do we waste the 8 bytes for hash if TSTAMP is set but HASH is not?
If TSTAMP depends on HASH then point is moot.



> > I am not sure what does v12 mean here.
> >
> > virtio_net_hdr_v1 is just with VIRTIO_F_VERSION_1,
> > virtio_net_hdr_v1_hash is with VIRTIO_F_VERSION_1 and
> > VIRTIO_NET_F_HASH_REPORT.
> >
> > So this one is virtio_net_hdr_hash_tstamp I guess?
> 
> Sounds better, yes, will change that.
> 
> This was an attempt at identifying the layout with the likely next
> generation of the spec, 1.2. Similar to virtio_net_hdr_v1. But that is
> both premature and not very helpful.

