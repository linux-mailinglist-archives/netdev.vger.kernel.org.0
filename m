Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22D52E6CEF
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 02:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgL2BGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 20:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgL2BGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 20:06:49 -0500
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC1C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:06:09 -0800 (PST)
Received: by mail-vs1-xe29.google.com with SMTP id x4so6375617vsp.7
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a5G4RQwBAVLyGfpmJVJyrosEMrC9BH0a7AK+9laY72M=;
        b=FXCJ4vOf0CaYtPxaTlOoON9DcPx5aOZzOjBK2Y3wyULwgEm+2UWoXc8EUBSzWEG4O4
         7lIe3rTSfIzWFmT+9Pjv/QQN9SI2mgUg4fvnod8TiX/o0+/2yLE0aVD903FNpJrLb4dP
         lor0aMXO37hLDjwXboNMLaAPAY+iow6bWfVvzMHItNq8CEJCgVuqblyO49YtXTJD73WZ
         h3rPsjcw80tzHorSNW6caG9lLyZgvqVZ69wU+RD5d4Vz1kA9WfQj83sx6ePaGa27cg4O
         +u17glZG8py0GQ66eGDxQ8QiIvtebnqLyUsIK24gloF36ySILNPoeFlhAZxbzw7eVrCy
         2Dxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a5G4RQwBAVLyGfpmJVJyrosEMrC9BH0a7AK+9laY72M=;
        b=fiFD+w3F72I6ntFBS6UklZe6Yhi9safwQ2dmRrs5OpYyktTDkR9wlcf63aqw4Xc1xK
         Om0kGo5dUGWTdWR7lxmcbLMEI3JP7ISzkRuUDPqOqst+0vUa8BoWSIwteJuGuMAaNvMl
         h+t1VQKQ06jZjBc2CrrKc6pmgjIrcLB+BHhbvQ05EHDN81gKRvctbsX0NZ5qt2KgXqV+
         +J/GTIsEG1wsNGNj8IYlpBbGs5Fu4vOpXgYRjq/fr8OgM/+7HQfi0Fr3qCbA6l5h9w0y
         7vNGWnGeFybHMkxuFUvOeMKHn0CQkWkrSBNohvvCE0s6nVqPAr+rjQvpBOK02oe6Ufjn
         5vtQ==
X-Gm-Message-State: AOAM5337tBd17rl2lA/aL/Nebk1AneIvwTEnsmIyMs/3T3hhk3lSAS0I
        wlqF9VlQsXUrmOvyUhE18A3pIP2d7Z0=
X-Google-Smtp-Source: ABdhPJxMUiThfRpBv2wRzie5Q5s5SRERDPbWDyVGp3kkCetFhxOmVSS6pP1dnKko5xeCgl6rio+7Gw==
X-Received: by 2002:a67:7f41:: with SMTP id a62mr27567436vsd.55.1609203967868;
        Mon, 28 Dec 2020 17:06:07 -0800 (PST)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com. [209.85.217.53])
        by smtp.gmail.com with ESMTPSA id s65sm5572049vka.5.2020.12.28.17.06.07
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 17:06:07 -0800 (PST)
Received: by mail-vs1-f53.google.com with SMTP id x26so6401227vsq.1
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:06:07 -0800 (PST)
X-Received: by 2002:a67:bd0a:: with SMTP id y10mr28348842vsq.28.1609203966578;
 Mon, 28 Dec 2020 17:06:06 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228122253-mutt-send-email-mst@kernel.org> <CA+FuTScguDWkvk=Lc+GzP=UCK2wjRFNJ_GEn_bniHpCDWdkfjg@mail.gmail.com>
 <20201228162903-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228162903-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 20:05:29 -0500
X-Gmail-Original-Message-ID: <CA+FuTSffjFZGGwpMkpnTBbHHwnJN7if=0cVf0Des7Db5UFe0bw@mail.gmail.com>
Message-ID: <CA+FuTSffjFZGGwpMkpnTBbHHwnJN7if=0cVf0Des7Db5UFe0bw@mail.gmail.com>
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

On Mon, Dec 28, 2020 at 7:55 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 02:30:31PM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 28, 2020 at 12:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Dec 28, 2020 at 11:22:32AM -0500, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > Add optional PTP hardware timestamp offload for virtio-net.
> > > >
> > > > Accurate RTT measurement requires timestamps close to the wire.
> > > > Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> > > > virtio-net header is expanded with room for a timestamp. A host may
> > > > pass receive timestamps for all or some packets. A timestamp is valid
> > > > if non-zero.
> > > >
> > > > The timestamp straddles (virtual) hardware domains. Like PTP, use
> > > > international atomic time (CLOCK_TAI) as global clock base. It is
> > > > guest responsibility to sync with host, e.g., through kvm-clock.
> > > >
> > > > Signed-off-by: Willem de Bruijn <willemb@google.com>
> > > > diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> > > > index f6881b5b77ee..0ffe2eeebd4a 100644
> > > > --- a/include/uapi/linux/virtio_net.h
> > > > +++ b/include/uapi/linux/virtio_net.h
> > > > @@ -57,6 +57,7 @@
> > > >                                        * Steering */
> > > >  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23        /* Set MAC address */
> > > >
> > > > +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Host sends TAI receive time */
> > > >  #define VIRTIO_NET_F_TX_HASH   56    /* Guest sends hash report */
> > > >  #define VIRTIO_NET_F_HASH_REPORT  57 /* Supports hash report */
> > > >  #define VIRTIO_NET_F_RSS       60    /* Supports RSS RX steering */
> > > > @@ -182,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
> > > >       };
> > > >  };
> > > >
> > > > +struct virtio_net_hdr_v12 {
> > > > +     struct virtio_net_hdr_v1 hdr;
> > > > +     struct {
> > > > +             __le32 value;
> > > > +             __le16 report;
> > > > +             __le16 flow_state;
> > > > +     } hash;
> > > > +     __virtio32 reserved;
> > > > +     __virtio64 tstamp;
> > > > +};
> > > > +
> > > >  #ifndef VIRTIO_NET_NO_LEGACY
> > > >  /* This header comes first in the scatter-gather list.
> > > >   * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must
> > >
> > >
> > > So it looks like VIRTIO_NET_F_RX_TSTAMP should depend on both
> > > VIRTIO_NET_F_RX_TSTAMP and VIRTIO_NET_F_HASH_REPORT then?
> >
> > Do you mean VIRTIO_NET_F_TX_TSTAMP depends on VIRTIO_NET_F_RX_TSTAMP?
> >
> > I think if either is enabled we need to enable the extended layout.
> > Regardless of whether TX_HASH or HASH_REPORT are enabled. If they are
> > not, then those fields are ignored.
>
> I mean do we waste the 8 bytes for hash if TSTAMP is set but HASH is not?
> If TSTAMP depends on HASH then point is moot.

True, but the two features really are independent.

I did consider using configurable metadata layout depending on
features negotiated. If there are tons of optional extensions, that
makes sense. But it is more complex and parsing error prone. With a
handful of options each of a few bytes, that did not seem worth the
cost to me at this point.

And importantly, such a mode can always be added later as a separate
VIRTIO_NET_F_PACKED_HEADER option.

If anything, perhaps if we increase the virtio_net_hdr_* allocation,
we should allocate some additional reserved space now? As each new
size introduces quite a bit of boilerplate. Also, e.g., in qemu just
to pass the sizes between virtio-net driver and vhost-net device.
