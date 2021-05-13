Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3A8380082
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 00:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhEMWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 18:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhEMWvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 18:51:11 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BF6C061574
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 15:50:00 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h4so28295009wrt.12
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 15:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ATN39DRCz8pzx8WORLKs8c98mAFPFohNIMiUYedv4lY=;
        b=ZsY/y5jBd9Jm02ofaNw6BLyPZ/sGqD22z5qq3/LsJAkR0iqP2MBXpuyVdyKI5HU6nJ
         c0b16xg/ns8MA4zCjqwF0qosFqxX10f5JzSnTDFZXw+TtiPp7Ve2RUbhGTD7dND2QX5C
         J+5S18d4FzzZ9PsL6ILszVoygrqRSvSP97AOHeVw4jMD9N0fup+HDsW1XBcsPEvQULLW
         am1FghHz0Rxo6IncQu1ehEZYc4ixxI84HZ76WfBHb/De29NLQMls5QrLdu/PVkF/4LAE
         iUvVYl7i0++RHfo6C7IDMFVOAJz3PD0M6K/hLbUKKTFBdOs7QNVWP27bZwi8bvzDftBd
         1v8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ATN39DRCz8pzx8WORLKs8c98mAFPFohNIMiUYedv4lY=;
        b=SkhoGQ/D9UpN+6CN69U1fxACblwXtJyUC5Q11/WNexBau8PTlr+PwQvj51id3sAmYF
         GYdSBfsHSaDFTVBrhEg8sZkHMTS6fgiyA4c/PbVxtSJlfKsew3bo9Ec8dg0NZNPViYo9
         iChx+Ft+yOBahgEoREuqX25BJ6v/FDtHBUqVQ6dI4g5fec283K7/ISrNShShIP3vaf+a
         dMIhfs2GW4woUjIYAM+JhZ3FF6WEMocKLoWLIAql2nOfS5Ab4RJiGan7ccWq3Xb1r3Wv
         0TPZRv8ULYcu9j2czjgjszRmbNxlR8/FjauxIQMRT03AQUvCHhrciakrXKQVSiR4/tBM
         fCTw==
X-Gm-Message-State: AOAM5315aW3i8oXq65EhClV05RVkFtk0PQqczaZSwjTys6a7wcmUp+nA
        6hSBWAb8Ir2zPTNfDOLrLKqrPB0OPwIA+qBf6A0wbA==
X-Google-Smtp-Source: ABdhPJwbFjEZ6S/TmhMI+BiQumDOhwhyjhAGz39TJJz1Jz76wzS533mOTFuUFdcORgz3KeDbbqsIGEeFSOAZLPDtdaw=
X-Received: by 2002:a5d:6285:: with SMTP id k5mr19722511wru.50.1620946199527;
 Thu, 13 May 2021 15:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
From:   Willem de Bruijn <willemb@google.com>
Date:   Thu, 13 May 2021 18:49:21 -0400
Message-ID: <CA+FuTSewRRBMkbdKzKoQv+E749jgcO9rgB4DsDTCJG2OcRQH5Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/4] virtio-net: add tx-hash, rx-tstamp, tx-tstamp
 and tx-time
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 1:56 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> RFCv2 for four new features to the virtio network device:
>
> 1. pass tx flow state to host, for routing + telemetry
> 2. pass rx tstamp to guest, for better RTT estimation
> 3. pass tx tstamp to guest, idem
> 3. pass tx delivery time to host, for accurate pacing
>
> All would introduce an extension to the virtio spec.
> Concurrently with code review I will write ballots to
> https://www.oasis-open.org/committees/ballots.php?wg_abbrev=virtio
>
> These changes are to the driver side. Evaluation additionally requires
> achanges to qemu and at least one back-end. I implemented preliminary
> support in Linux vhost-net. Both patches available through github at
>
> https://github.com/wdebruij/linux/tree/virtio-net-txhash-2
> https://github.com/wdebruij/qemu/tree/virtio-net-txhash-2
>
> Changes RFC -> RFCv2
>   - add transmit timestamp patch
>   - see individual patches for other changes
>
> Willem de Bruijn (4):
>   virtio-net: support transmit hash report
>   virtio-net: support receive timestamp
>   virtio-net: support transmit timestamp
>   virtio-net: support future packet transmit time

Seeing Yuri's patchset adding new features reminded me that I did not
follow-up on this patch series on the list.

The patches themselves are mostly in good shape. The last tx tstamp
issue can be resolved.

But the device implementation I target only supports legacy mode.
Below conversation that we had in one of the patches makes clear that
supporting this in legacy is not feasible. Nor is upgrading that
device in the short term. Until there is a device implementation that
implements these offloads, these features are a dead letter. Not moving
forward for now.

Somewhat related: is there a plan for when we run out of 64 feature bits?

> > > Actually, would it be possible to make new features available on
> > > legacy devices? There is nothing in the features bits precluding it.
> >
> > I think it won't be possible: you are using feature bit 55,
> > legacy devices have up to 32 feature bits. And of course the
> > header looks a bit differently for legacy, you would have to add special
> > code to handle that when mergeable buffers are off.
>
> I think I can make the latter work. I did start without a dependency
> on the v1 header initially.
>
> Feature bit array length I had not considered. Good point. Need to
> think about that. It would be very appealing if in particular the
> tx-hash feature could work in legacy mode.
