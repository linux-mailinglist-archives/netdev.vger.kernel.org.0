Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F45F2E69B2
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 18:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgL1RYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 12:24:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728302AbgL1RYB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 12:24:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609176155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jke4od+O1Dw2orQ/EEeWLodrstqfYPkGTioL6w+PUps=;
        b=i/kC3yGxfMl0tNYmm7aS2+6zWAJpdjgreEL1TVHqHeGQKH+RUw3+EX1f6LTfEo+nSEqmKM
        /j08QevfaWo72i1cJCg04ia8jsOnsdvP2PWAg5EDKFSv+BQq6KgYZXaLBX9XBa+CxDeBRs
        cuoqOh2+COx8GoFI/3hsi2cnaARkHyQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-574-NPHtePQ9Owm6XffdVIo8pQ-1; Mon, 28 Dec 2020 12:22:33 -0500
X-MC-Unique: NPHtePQ9Owm6XffdVIo8pQ-1
Received: by mail-wm1-f69.google.com with SMTP id b4so7180335wmj.4
        for <netdev@vger.kernel.org>; Mon, 28 Dec 2020 09:22:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jke4od+O1Dw2orQ/EEeWLodrstqfYPkGTioL6w+PUps=;
        b=HnhesA4Qnx/sLD7tldwf0BfvJ5rnOytam6QtvTqY+8+IrmjTa9fhmB2yQuEEGE3m3o
         SOB0rl5tCz07ZR8TVhKe7IlIkRNNPtVFxy/Mch76fxDIfuZBKk5QJoxWXxKh+enPxRHA
         oJmzq9Q52VvexyeX5PVaiX4BQxxBvBgXq2ZVICLZSZkqV9ftnStm6oPw2VVd9S0w2bz4
         R4F0n7uN+vb0q9sgqzOENXYg5ngJvow2ambTa5nSMbHG92w/QkwiXaMIMrUiGqnm3sBM
         tnWIqcyhZ4ZLy/w/YOdT5Hm180G0oaylKA7RQcT1yd+q0b7Hj/wDp+dFvgrWjtm2aU2u
         WZBA==
X-Gm-Message-State: AOAM532QjhUfuFeUkViw68wx11M3sIcvJETJWybJvAFZNmAuBLMnrLFs
        e7Uhh3RInVzch89f3wZg6DIvvORspGJ6CsPaeuQXni25OoIFvauG7YJ1rlCoF22ggxZfAjkelKe
        szzMCnjYAf/8tet5q
X-Received: by 2002:adf:f989:: with SMTP id f9mr51181804wrr.299.1609176152676;
        Mon, 28 Dec 2020 09:22:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUaLe8ioYv03NOJ5oWSAsKkAyD/zpt3/mAAaDWrtV3sTLDw5RRuJRsa1hapzoRwdVJi8dQMA==
X-Received: by 2002:adf:f989:: with SMTP id f9mr51181792wrr.299.1609176152435;
        Mon, 28 Dec 2020 09:22:32 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id t10sm54905044wrp.39.2020.12.28.09.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 09:22:31 -0800 (PST)
Date:   Mon, 28 Dec 2020 12:22:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH rfc 1/3] virtio-net: support transmit hash report
Message-ID: <20201228122155-mutt-send-email-mst@kernel.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-2-willemdebruijn.kernel@gmail.com>
 <20201228112657-mutt-send-email-mst@kernel.org>
 <CA+FuTSdYLxV2O2WiD3D0cy2vaVbiECWheW0j7OGKKgV84wkScA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdYLxV2O2WiD3D0cy2vaVbiECWheW0j7OGKKgV84wkScA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 11:47:45AM -0500, Willem de Bruijn wrote:
> On Mon, Dec 28, 2020 at 11:28 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Dec 28, 2020 at 11:22:31AM -0500, Willem de Bruijn wrote:
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > Virtio-net supports sharing the flow hash from host to guest on rx.
> > > Do the same on transmit, to allow the host to infer connection state
> > > for more robust routing and telemetry.
> > >
> > > Linux derives ipv6 flowlabel and ECMP multipath from sk->sk_txhash,
> > > and updates these fields on error with sk_rethink_txhash. This feature
> > > allows the host to make similar decisions.
> > >
> > > Besides the raw hash, optionally also convey connection state for
> > > this hash. Specifically, the hash rotates on transmit timeout. To
> > > avoid having to keep a stateful table in the host to detect flow
> > > changes, explicitly notify when a hash changed due to timeout.
> >
> > I don't actually see code using VIRTIO_NET_HASH_STATE_TIMEOUT_BIT
> > in this series. Want to split out that part to a separate patch?
> 
> Will do.
> 
> I wanted to make it clear that these bits must be reserved (i.e.,
> zero) until a later patch specifies them.

Already the case for the padding field I think ...

> The timeout notification feature requires additional plumbing between
> the TCP protocol stack and device driver, probably an skb bit. I'd
> like to leave that as follow-up for now.
> 
> Thanks for the fast feedback!

