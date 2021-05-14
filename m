Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932F9380409
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 09:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232847AbhENHNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 03:13:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230247AbhENHNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 03:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620976349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=coVnp21qHs3g1zUzdD/v9oVQ2VSsjSE0G6biYzm153E=;
        b=C5Q3E0/xuhoOzIQDp9KlzrQVgXPiH43TTOKxY7hgAVmz8D8rIw4SsKH+5aal7s+EYmu2jW
        XxHgYlLFak4tfYL2n0P/CLfQrSC0eZPXF//8/3tD2SDWho8OyXD1EmZHXUVAIGRxPaCwo9
        eqQ8jBixnk20z4VMwbnPn/bmJRxTfMs=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-BUaOmEH3MpGzbOti-bUZJA-1; Fri, 14 May 2021 03:12:25 -0400
X-MC-Unique: BUaOmEH3MpGzbOti-bUZJA-1
Received: by mail-lj1-f197.google.com with SMTP id v15-20020a2e7a0f0000b02900da3de76cfdso15594133ljc.22
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 00:12:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=coVnp21qHs3g1zUzdD/v9oVQ2VSsjSE0G6biYzm153E=;
        b=o1O7AknG/UPANEThD0hSI70OmzWhCrV9vRLBVe+qvNFu1r/OYiS2Nvybpt7CEx60fz
         lglgcd6iXF0cMgERztK9ttXv413GtfAXshLGVNnJngrxzO3+HQPb+FdtnFt6Hml2MHJQ
         lRYzoKgxIccH2NZYijZ3YG9QbNAjvdNZZfyKePevwd8vdGU7um8SaesFo+G8tXQ3t/wM
         Y2mKzqSXF8CPcWpYjWgON2vCpok4TH2FIp/2frYBgMeI6VKJ/zzyTYun94C+msaVls9t
         BgLBARB4c6ljxE0A5AoKgguj82S5D/eEeanUT/Xd3cPo0mARnLMkTpm753XBvz+SUMGM
         Ab6w==
X-Gm-Message-State: AOAM531W3HheD/CwGjBEkG5ljxhtrWTU1pc6OVPgj+JGkOCL5Ax6sl15
        XsGCQAzl6y5p0TlEHfULUxtdmtT8UBL6ZajOS1pBaeuuNAiVwqyBH+CG2s6ZVM8MyEChLJ8g4Lo
        QcFikZdvspaPZqI2Fvr356sOTG6ujxkvI
X-Received: by 2002:ac2:43ac:: with SMTP id t12mr31034120lfl.258.1620976344355;
        Fri, 14 May 2021 00:12:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5EyQYx5qCs6YL+71OUtGBJyqEb7whqcU6FBBTbi0dlrL1AGLNFUrL4i8UEYyd0Rm3HmYeZTm3uHUiQz6VaOM=
X-Received: by 2002:ac2:43ac:: with SMTP id t12mr31034107lfl.258.1620976344198;
 Fri, 14 May 2021 00:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com> <CA+FuTSewRRBMkbdKzKoQv+E749jgcO9rgB4DsDTCJG2OcRQH5Q@mail.gmail.com>
In-Reply-To: <CA+FuTSewRRBMkbdKzKoQv+E749jgcO9rgB4DsDTCJG2OcRQH5Q@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 14 May 2021 15:12:09 +0800
Message-ID: <CACGkMEszcyhb+QXCuOeJcgDCDrLHVMQ6n6Z-1f2=DN+7+dKA=Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/4] virtio-net: add tx-hash, rx-tstamp, tx-tstamp
 and tx-time
To:     Willem de Bruijn <willemb@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 6:50 AM Willem de Bruijn <willemb@google.com> wrote:
>
> On Mon, Feb 8, 2021 at 1:56 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > From: Willem de Bruijn <willemb@google.com>
> >
> > RFCv2 for four new features to the virtio network device:
> >
> > 1. pass tx flow state to host, for routing + telemetry
> > 2. pass rx tstamp to guest, for better RTT estimation
> > 3. pass tx tstamp to guest, idem
> > 3. pass tx delivery time to host, for accurate pacing
> >
> > All would introduce an extension to the virtio spec.
> > Concurrently with code review I will write ballots to
> > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> >
> > These changes are to the driver side. Evaluation additionally requires
> > achanges to qemu and at least one back-end. I implemented preliminary
> > support in Linux vhost-net. Both patches available through github at
> >
> > https://github.com/wdebruij/linux/tree/virtio-net-txhash-2
> > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-2
> >
> > Changes RFC -> RFCv2
> >   - add transmit timestamp patch
> >   - see individual patches for other changes
> >
> > Willem de Bruijn (4):
> >   virtio-net: support transmit hash report
> >   virtio-net: support receive timestamp
> >   virtio-net: support transmit timestamp
> >   virtio-net: support future packet transmit time
>
> Seeing Yuri's patchset adding new features reminded me that I did not
> follow-up on this patch series on the list.
>
> The patches themselves are mostly in good shape. The last tx tstamp
> issue can be resolved.
>
> But the device implementation I target only supports legacy mode.
> Below conversation that we had in one of the patches makes clear that
> supporting this in legacy is not feasible. Nor is upgrading that
> device in the short term. Until there is a device implementation that
> implements these offloads, these features are a dead letter. Not moving
> forward for now.
>
> Somewhat related: is there a plan for when we run out of 64 feature bits?

A quick thought: we need add (or reserve) a new feature bit to
indicate that we need more bits, and have transport specific
implementation of those extra bits negotiation. E.g for PCI, we can
introduce new fields in the capability.

Thanks

>
> > > > Actually, would it be possible to make new features available on
> > > > legacy devices? There is nothing in the features bits precluding it.
> > >
> > > I think it won't be possible: you are using feature bit 55,
> > > legacy devices have up to 32 feature bits. And of course the
> > > header looks a bit differently for legacy, you would have to add special
> > > code to handle that when mergeable buffers are off.
> >
> > I think I can make the latter work. I did start without a dependency
> > on the v1 header initially.
> >
> > Feature bit array length I had not considered. Good point. Need to
> > think about that. It would be very appealing if in particular the
> > tx-hash feature could work in legacy mode.
>

