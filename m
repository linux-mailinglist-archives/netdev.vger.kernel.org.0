Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6DC2DE71B
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 17:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgLRQCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 11:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgLRQCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 11:02:20 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C3DC0617B0;
        Fri, 18 Dec 2020 08:01:40 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id v3so2578216ilo.5;
        Fri, 18 Dec 2020 08:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rl8I9qC64AT1N2yeIU5z2zHom6dvztvor/CjU2dVBak=;
        b=WdTvzh3kr5AUkqPIRRc8ffN/FM2OKgN9F5j8ZcoV0OiY8lU1GQNd0B/hpxTBbXbOds
         7ZAQ0o5KhnbPaCB4l696bLSS2MlaNXmBi4jdC+F2CvHEAe2LW5iiq8B2nvNpJbOh3F4+
         nNM5/PGplkLrNKo241jea1DDR99lBw9WKAaGOIz1QUXc4Erdgen9odR/NL5KVrON6jQx
         n7pL2Ba4igoRw4OisxJkm1wy6iOd+mL2//xyDUC1MIt7cN5KaAsw2So3VT0Pvo5i33G8
         CSfUwArOd20TlVbugO38dFNAvRx1d5QB6PvLdtxlqDdlIqNjz9LgrwD5Z4Kevlw4UERy
         bbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rl8I9qC64AT1N2yeIU5z2zHom6dvztvor/CjU2dVBak=;
        b=iZnNLBZqIn/feSTrGYTqgNmeI92AX35uAVVT/T1/6bhQcbvVGhB307+0C/TFGW79hY
         Sb8GrKAqjtmrLA2yWl3j2bBPxz8HhoHjJtZUHm3F4/DhNx7FNM7ozLZRkII93sBp+ClU
         M5Pcy2PyjbDp63FiJeFS/u2TFsNy5kFns2rGADopA/9et9rMuCNUqKtdL/5LIxdmkuR7
         x2en6ewp6rFZRxXgxpUqeubNk438R3U+bokyR4sDdNeVZ/fFzCdHlUmN9JwC3jLgQcjZ
         m3DL2fVsh3fGhlUj1AP+yilYMuhZG8bmkxDFHJVKxcJOVt1gjVdcdGznTqWk58accXJC
         lO0Q==
X-Gm-Message-State: AOAM530kTkdGKum8UabhIA7ZhrtTOPuC38rQhp8G80oWZ22Mv7Gpjo3+
        sQu+j/DuTvxVzXhiebxe1o7V83k4X/fcQnv2OXQ=
X-Google-Smtp-Source: ABdhPJyrgMC/chkhuXb+0j6ZD82xcNgCPRWIGsJJ+7j402VgONkG+F9KGU+F3tO1lzVZLS03kngRhxQ0R21Agy0vJiI=
X-Received: by 2002:a05:6e02:929:: with SMTP id o9mr4436248ilt.42.1608307299439;
 Fri, 18 Dec 2020 08:01:39 -0800 (PST)
MIME-Version: 1.0
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com> <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 18 Dec 2020 08:01:28 -0800
Message-ID: <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Parav Pandit <parav@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 9:20 PM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Friday, December 18, 2020 8:41 AM
> >
> > On Thu, Dec 17, 2020 at 5:30 PM David Ahern <dsahern@gmail.com> wrote:
> > >
> > > On 12/16/20 3:53 PM, Alexander Duyck wrote:
> > The problem is PCIe DMA wasn't designed to function as a network switch
> > fabric and when we start talking about a 400Gb NIC trying to handle over 256
> > subfunctions it will quickly reduce the receive/transmit throughput to gigabit
> > or less speeds when encountering hardware multicast/broadcast replication.
> > With 256 subfunctions a simple 60B ARP could consume more than 19KB of
> > PCIe bandwidth due to the packet having to be duplicated so many times. In
> > my mind it should be simpler to simply clone a single skb 256 times, forward
> > that to the switchdev ports, and have them perform a bypass (if available) to
> > deliver it to the subfunctions. That's why I was thinking it might be a good
> > time to look at addressing it.
> Linux tc framework is rich to address this and already used by openvswich for years now.
> Today arp broadcasts are not offloaded. They go through software path and replicated in the L2 domain.
> It is a solved problem for many years now.

When you say they are replicated in the L2 domain I assume you are
talking about the software switch connected to the switchdev ports. My
question is what are you doing with them after you have replicated
them? I'm assuming they are being sent to the other switchdev ports
which will require a DMA to transmit them, and another to receive them
on the VF/SF, or are you saying something else is going on here?

My argument is that this cuts into both the transmit and receive DMA
bandwidth of the NIC, and could easily be avoided in the case where SF
exists in the same kernel as the switchdev port by identifying the
multicast bit being set and simply bypassing the device.
