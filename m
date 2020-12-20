Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F75D2DF5C1
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 15:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbgLTOyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 09:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbgLTOyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 09:54:10 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC2FC0613CF
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 06:53:19 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id y21so2520027uag.2
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 06:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ypizNTWjAttv3UN3LTBMjtSTaXLL1c1NPCf0bTj9C/E=;
        b=FRrI+DnbXg0n8ccUYU34AsTrMvSesgL/vgkr8cuECNOv+VuHvGKL3fvSOJUEwPUf9e
         OC265lDo+5yEYRSs9hfm6m69gYqn0qprcnjaBkFoz3Zx0wYe9+QwsR40WkySPe+Ks21t
         WqdZQEqYIyO3cqrxBE7sJNWoLtQkB9x7knKbcFpzNepI7LcDDiTh7qvh1c5gDtPDkI76
         RfNlOx6/Ei+OzwgfQFufuBoAhLV5yLV2zgweeh/N7UfSdOTER7DB5fGzLo2n71bc9rws
         bOTFt3ooGwpf+MnVvUersYWJCJHO3awVGxltfd0xyby5Mi9ezbW4YSgyxBHMd5k5SERs
         aq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ypizNTWjAttv3UN3LTBMjtSTaXLL1c1NPCf0bTj9C/E=;
        b=p0CNnAWxNteD5e/FLipNNGz4byH6LqYy5eqklG1Ad5H0Knx+uLdwHOC3yyapnfZjo8
         poT14qXJRumqvXI0+Qi4uFTdRRJ1isx6Q3PWauL5JqlgYUiUNxj5GzXNnjHbywFW8Tns
         E9zVhd88IzUBGdybntG+rxjE+i35U52fSwqYJYhPGWcpQ5Amf/S+XZMf53SwVl4g+GuT
         caCwp+gD5Zh3yRJnIDnl6EwUSCCDgvsXvDaXJmYBYqXzr2qi83KNRFhPCjAWCVxx9uR0
         esIKUYMtlVi+PUHpXMQidya92KdnpC7bNz4cf5LhFjn0rstF+UuEGaWC1iFtauqYQs5q
         jMLw==
X-Gm-Message-State: AOAM533ZgSIUl/jUk3z+yjj9c20gJ5lmjPO2jpydK8ZMEVWDUloHoZ2X
        nwgts1Sl61zTcmkpfOuJD5qgTcPghgg=
X-Google-Smtp-Source: ABdhPJwnTFK/YNBOT76xty7RsvbXiCpFn3diCod9MKYOnABfm1oJzHnZKnFHVCZ7yBTVaVPpZSuZ/Q==
X-Received: by 2002:ab0:6588:: with SMTP id v8mr10494547uam.96.1608475998265;
        Sun, 20 Dec 2020 06:53:18 -0800 (PST)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id y14sm3205201uag.11.2020.12.20.06.53.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Dec 2020 06:53:17 -0800 (PST)
Received: by mail-vs1-f41.google.com with SMTP id z16so4039366vsp.5
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 06:53:17 -0800 (PST)
X-Received: by 2002:a67:bd0a:: with SMTP id y10mr9966817vsq.28.1608475996519;
 Sun, 20 Dec 2020 06:53:16 -0800 (PST)
MIME-Version: 1.0
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
 <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
 <20201217102037.6f5ceee9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTScTEthUW=s+5_jnnHj4SQeFr0=HsgwVeNegNOaCNQ+C=Q@mail.gmail.com> <873600q577.fsf@tarshish>
In-Reply-To: <873600q577.fsf@tarshish>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 20 Dec 2020 09:52:40 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfffAACpSisWgGAcHbvPWgBrQVRQe8ZJS8TmFUKdMdQ5w@mail.gmail.com>
Message-ID: <CA+FuTSfffAACpSisWgGAcHbvPWgBrQVRQe8ZJS8TmFUKdMdQ5w@mail.gmail.com>
Subject: Re: [PATCH net 2/2] docs: networking: packet_mmap: don't mention PACKET_MMAP
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        =?UTF-8?Q?Ulisses_Alonso_Camar=C3=B3?= <uaca@alumni.uv.es>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 20, 2020 at 3:00 AM Baruch Siach <baruch@tkos.co.il> wrote:
>
> Hi Willem,
>
> On Thu, Dec 17 2020, Willem de Bruijn wrote:
> > On Thu, Dec 17, 2020 at 2:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >>
> >> On Tue, 15 Dec 2020 18:51:17 +0200 Baruch Siach wrote:
> >> > Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
> >> > used to be a CONFIG_PACKET_MMAP config symbol that depended on
> >> > CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
> >> > feature, implying that it can be disabled. Another naming variant is
> >> > "Packet MMAP".
> >> >
> >> > Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
> >> > text the implied mmap() feature disable option.
> >>
> >> Should we maybe say AF_PACKET mmap() ?
> >
> > I don't think that the feature name PACKET_MMAP implies
> > CONFIG_PACKET_MMAP, or thus that the name is obsolete now that the
> > latter is.
>
> Current text says "if PACKET_MMAP is not enabled ...". This clearly
> implies a CONFIG_ symbol. Besides, the PACKET_MMAP term is mentioned
> nowhere else in the source tree. At the very least we need to clarify
> what it means.

At this point I don't think renaming will simplify anything. It is by
now referred to by that name outside the kernel, a google search
shows. It is also even the name of the documentation file
(packet_mmap.rst).

The file starts with

  PACKET_MMAP

  Abstract

  This file documents the mmap() facility available with the PACKET
  socket interface on 2.4/2.6/3.x kernels. This type of sockets is used for

That introduces the term well enough, I think.

Agreed that references to old kernel versions and the previous compile
time configurability of the feature are no longer relevant.

> > If it needs a rename, the setsockopt is PACKET_[RT]X_RING. So, if this
> > needs updating, perhaps PACKET_RING would be suitable. Or TPACKET,
> > based on the version definitions.
>
> So how would you rephrase text like "PACKET_MMAP provides a size
> configurable circular buffer ..."?

PACKET_RING provides a size configurable circular buffer would work,
but see previous comment.
