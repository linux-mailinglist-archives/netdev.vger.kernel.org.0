Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6912E6CFD
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 02:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbgL2BVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 20:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727330AbgL2BVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 20:21:18 -0500
Received: from mail-vk1-xa2e.google.com (mail-vk1-xa2e.google.com [IPv6:2607:f8b0:4864:20::a2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DD3C0613D6
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:20:37 -0800 (PST)
Received: by mail-vk1-xa2e.google.com with SMTP id m145so2682184vke.7
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FwLto/ZBV2G6H0YpMzAWzKM7ccpLka7+kI4pzhpyY60=;
        b=dIfi5/b5mryN/OQ7oVFTqmUS9y1O0luF9cN505GMc28VviwUetdzp9Fm7cxIANVBCg
         yTNZYi6hARw9n+u9UxSa6R62Ibs+/1CeBt4b2dSXn5XY9zOjpT4h8w8+OZde8hkgvh2u
         j6vUOwJPa6HOpWoumLawwzRHfSEMTJh01gFrhZGljmLDYKbtkiQwG7j8opiAugTOTlhM
         x6poKkAy5Cwi/+NGygWwYJ9EUAHF+gq8uHz9y4oEFuXIh1RfcEIKn5DJJGspyl153hQr
         tJVzYhi+tZ8st9PG97u7igwpGW4eRO/ExmiHn+v/SfxqcVydY/Qt+jzm+eEv50hs0FnF
         gKLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FwLto/ZBV2G6H0YpMzAWzKM7ccpLka7+kI4pzhpyY60=;
        b=l9TmT3Gzf3068YAzXdXwURQmL2XCQ8wwCRQA5NdXsr1eDm9hRVKuFGOE//0SUlIW5h
         8QWDtBblTRaEfzEnKjDJSi5/s/wLTEOp9JFbHA0sNuDU8gXKIWWyBPCY6Cdo483spLp5
         cB+zJe++t4M57iE2J55MEhZ0x6/FXWj2RPM96W+H00kYK5IZY9qTwaPrnm32PCi0qg/N
         wznJWz4onp+8BTV2JxVc3wdfaPstkahhlwgNlFQ3od5Bj3pmF0dZwNSKoP4nqUDLiF+R
         XYpr4V7zzFIxgSTS7QuQpaPa0IVJgSkJ5Q+LCzrZ5MfVC6Txsauo5UxXEm1FrBXGR4tE
         UgHA==
X-Gm-Message-State: AOAM532i1dNxNi6FPZnXdOGXUWsJnv5qOYtf374YPNFCJFI6qxUaJSlh
        ag1/CLm/0UY/6sY4G7d8d4Qx3Sa87wM=
X-Google-Smtp-Source: ABdhPJzW+/q/f3MrqqXaLS7G2k9zPvOWN24UhSc6OuIl4uGp43x6UeYbFfUWV/7Votr6kAQvklKpjg==
X-Received: by 2002:a1f:9fce:: with SMTP id i197mr30201340vke.18.1609204836656;
        Mon, 28 Dec 2020 17:20:36 -0800 (PST)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id e3sm5563265vkh.11.2020.12.28.17.20.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 17:20:36 -0800 (PST)
Received: by mail-vs1-f47.google.com with SMTP id j140so6399569vsd.4
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 17:20:35 -0800 (PST)
X-Received: by 2002:a67:3201:: with SMTP id y1mr29614104vsy.22.1609204835326;
 Mon, 28 Dec 2020 17:20:35 -0800 (PST)
MIME-Version: 1.0
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-2-willemdebruijn.kernel@gmail.com>
 <20201228112657-mutt-send-email-mst@kernel.org> <CA+FuTSdYLxV2O2WiD3D0cy2vaVbiECWheW0j7OGKKgV84wkScA@mail.gmail.com>
 <20201228122155-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201228122155-mutt-send-email-mst@kernel.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 28 Dec 2020 20:19:58 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdDAS9sxLX5j31YzA54UPx0Gu+knHqnnJP+btR2PwAYxg@mail.gmail.com>
Message-ID: <CA+FuTSdDAS9sxLX5j31YzA54UPx0Gu+knHqnnJP+btR2PwAYxg@mail.gmail.com>
Subject: Re: [PATCH rfc 1/3] virtio-net: support transmit hash report
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 12:28 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 28, 2020 at 11:47:45AM -0500, Willem de Bruijn wrote:
> > On Mon, Dec 28, 2020 at 11:28 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Dec 28, 2020 at 11:22:31AM -0500, Willem de Bruijn wrote:
> > > > From: Willem de Bruijn <willemb@google.com>
> > > >
> > > > Virtio-net supports sharing the flow hash from host to guest on rx.
> > > > Do the same on transmit, to allow the host to infer connection state
> > > > for more robust routing and telemetry.
> > > >
> > > > Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
> > > > and updates these fields on error with sk_rethink_txhash. This feature
> > > > allows the host to make similar decisions.
> > > >
> > > > Besides the raw hash, optionally also convey connection state for
> > > > this hash. Specifically, the hash rotates on transmit timeout. To
> > > > avoid having to keep a stateful table in the host to detect flow
> > > > changes, explicitly notify when a hash changed due to timeout.
> > >
> > > I don't actually see code using VIRTIO_NET_HASH_STATE_TIMEOUT_BIT
> > > in this series. Want to split out that part to a separate patch?
> >
> > Will do.
> >
> > I wanted to make it clear that these bits must be reserved (i.e.,
> > zero) until a later patch specifies them.
>
> Already the case for the padding field I think ...

Good. Is this something that the device should enforce? Meaning, drop
requests with reserved bits set.

Once a bit is defined and device updated to accept it, it cannot
distinguish between a new driver aware of the bit and an old one that
wrote to padding. More problematic, a well behaved new driver will
gets packets dropped by an old device.

The proper way is to negotiate this is through features, of course.
But I don't think we want to add one for each new bit. That's why I
squished the bit definition in here, even in absence of an
implementation.
