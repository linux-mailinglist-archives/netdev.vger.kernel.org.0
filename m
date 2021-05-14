Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC50D3809D7
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 14:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbhENMsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 08:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbhENMsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 08:48:50 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217EBC061574
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 05:47:39 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id b17so34579637ede.0
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 05:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HymSORogEmezZKPe6k3z0mroHhthunf7PpEqJRP7zL0=;
        b=RPD+OijAMQuR6wAEY8XZWKOyKaKIUHXEXC24Y14snxgXcRxs1Cl72ncd2DBXx4XinR
         ayXLuwrj3dktgKhaaDh3tpOshdrGc7ZZtOGgbeI7H537PacWsjZXww/0RLG/oyUXoWF6
         SBDZuAaiUsBIsRr1dX+niAlfwpwiaTzOEjjFYdVu4YhHrO7+mLq0ZLjb34b3ZfLF2Rzo
         s9GXEl0ip7tELQ6tzSZOUS0r7p6ic5wlzVJfGeC7z2d2PKM0heIDk91OiBUnLQrKXj9O
         XFDfLD8fGG5i1S5jZ5Nwgj++KgpLzqbvTXD8y7Eyi09kOVSwViEA4CfCzD1fA2kT/3o8
         hE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HymSORogEmezZKPe6k3z0mroHhthunf7PpEqJRP7zL0=;
        b=b87ldGovvFUwoO0NbWlzf21AowwWi55q/XHfLAzBx8XUJl+2yk8C6s0t3d3/b381zG
         sNEJXaabHGzXW48uRCB0/AiCItpMIPmqsUoR5bcHLxvPG4CmC4ttwpK11zQtscJ2Jzg5
         QGM8e6hrCzyCw8mXb88dOEQLCR2yHx8mBYLm+hk64cjIthUFjfbkBn9bEhWLqToW3NJI
         taMxIP418GzksjZifS2laRHbu291DkTPhHYtUc9sFkidZhOT++wvNRpx/xlppa2rc5sM
         43OHj7BHsl115Ws4pqywdK6YozavdN/EJTD2/XeS71OAgOduea947Wl5SqobMARak7zy
         kMyw==
X-Gm-Message-State: AOAM533Q7sfIsXELUFPBnix+yqh2bi92uORheBwhrTtiIJ1UHIJd4njf
        5oX1nMlW+e6T9v+m+z8VNNaLxz1Y4NhMWQ==
X-Google-Smtp-Source: ABdhPJzRCPvbTlV5Mb96vZYDVdvQ0gmu7q8zSL/8KccvL56CnfA4cBdUBZln3ihg77p2SsqwnG8IPA==
X-Received: by 2002:a50:8a99:: with SMTP id j25mr55288940edj.253.1620996457064;
        Fri, 14 May 2021 05:47:37 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id h9sm2084328edr.10.2021.05.14.05.47.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 05:47:36 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id v12so29896143wrq.6
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 05:47:36 -0700 (PDT)
X-Received: by 2002:a05:6000:52:: with SMTP id k18mr379123wrx.419.1620996455651;
 Fri, 14 May 2021 05:47:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <CA+FuTSewRRBMkbdKzKoQv+E749jgcO9rgB4DsDTCJG2OcRQH5Q@mail.gmail.com> <CACGkMEszcyhb+QXCuOeJcgDCDrLHVMQ6n6Z-1f2=DN+7+dKA=Q@mail.gmail.com>
In-Reply-To: <CACGkMEszcyhb+QXCuOeJcgDCDrLHVMQ6n6Z-1f2=DN+7+dKA=Q@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 14 May 2021 08:46:59 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdAeeu+TuWNwg2KAWoEo35oUuUssgWhvwotXM4XkPPPMg@mail.gmail.com>
Message-ID: <CA+FuTSdAeeu+TuWNwg2KAWoEo35oUuUssgWhvwotXM4XkPPPMg@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/4] virtio-net: add tx-hash, rx-tstamp, tx-tstamp
 and tx-time
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 3:12 AM Jason Wang <jasowang@redhat.com> wrote:
>
> On Fri, May 14, 2021 at 6:50 AM Willem de Bruijn <willemb@google.com> wrote:
> >
> > On Mon, Feb 8, 2021 at 1:56 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > From: Willem de Bruijn <willemb@google.com>
> > >
> > > RFCv2 for four new features to the virtio network device:
> > >
> > > 1. pass tx flow state to host, for routing + telemetry
> > > 2. pass rx tstamp to guest, for better RTT estimation
> > > 3. pass tx tstamp to guest, idem
> > > 3. pass tx delivery time to host, for accurate pacing
> > >
> > > All would introduce an extension to the virtio spec.
> > > Concurrently with code review I will write ballots to
> > > https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
> > >
> > > These changes are to the driver side. Evaluation additionally requires
> > > achanges to qemu and at least one back-end. I implemented preliminary
> > > support in Linux vhost-net. Both patches available through github at
> > >
> > > https://github.com/wdebruij/linux/tree/virtio-net-txhash-2
> > > https://github.com/wdebruij/qemu/tree/virtio-net-txhash-2
> > >
> > > Changes RFC -> RFCv2
> > >   - add transmit timestamp patch
> > >   - see individual patches for other changes
> > >
> > > Willem de Bruijn (4):
> > >   virtio-net: support transmit hash report
> > >   virtio-net: support receive timestamp
> > >   virtio-net: support transmit timestamp
> > >   virtio-net: support future packet transmit time
> >
> > Seeing Yuri's patchset adding new features reminded me that I did not
> > follow-up on this patch series on the list.
> >
> > The patches themselves are mostly in good shape. The last tx tstamp
> > issue can be resolved.
> >
> > But the device implementation I target only supports legacy mode.
> > Below conversation that we had in one of the patches makes clear that
> > supporting this in legacy is not feasible. Nor is upgrading that
> > device in the short term. Until there is a device implementation that
> > implements these offloads, these features are a dead letter. Not moving
> > forward for now.
> >
> > Somewhat related: is there a plan for when we run out of 64 feature bits?
>
> A quick thought: we need add (or reserve) a new feature bit to
> indicate that we need more bits, and have transport specific
> implementation of those extra bits negotiation. E.g for PCI, we can
> introduce new fields in the capability.

Thanks Jason. Yes, that makes sense to me.

The difference from 32 to 64 bit between virtio_pci_legacy.c and
virtio_pci_modern.c is a good example:

  static u64 vp_get_features(struct virtio_device *vdev)
  {
        struct virtio_pci_device *vp_dev = to_vp_device(vdev);

        /* When someone needs more than 32 feature bits, we'll need to
         * steal a bit to indicate that the rest are somewhere else. */
        return ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
 }

  u64 vp_modern_get_features(struct virtio_pci_modern_device *mdev)
  {
        struct virtio_pci_common_cfg __iomem *cfg = mdev->common;

        u64 features;

        vp_iowrite32(0, &cfg->device_feature_select);
        features = vp_ioread32(&cfg->device_feature);
        vp_iowrite32(1, &cfg->device_feature_select);
        features |= ((u64)vp_ioread32(&cfg->device_feature) << 32);

        return features;
  }

device_feature_select is a 32-bit field, of which only values 0 and 1
are defined so far, per the virtio 1.1 spec:

"
device_feature_select
The driver uses this to select which feature bits device_feature
shows. Value 0x0 selects Feature Bits 0 to 31, 0x1 selects Feature
Bits 32 to 63, etc.
"

That leaves plenty of room for expansion, at least for pci devices.

>
> >
> > > > > Actually, would it be possible to make new features available on
> > > > > legacy devices? There is nothing in the features bits precluding it.
> > > >
> > > > I think it won't be possible: you are using feature bit 55,
> > > > legacy devices have up to 32 feature bits. And of course the
> > > > header looks a bit differently for legacy, you would have to add special
> > > > code to handle that when mergeable buffers are off.
> > >
> > > I think I can make the latter work. I did start without a dependency
> > > on the v1 header initially.
> > >
> > > Feature bit array length I had not considered. Good point. Need to
> > > think about that. It would be very appealing if in particular the
> > > tx-hash feature could work in legacy mode.
> >
>
