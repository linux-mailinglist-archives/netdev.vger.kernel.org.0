Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DF963FAF6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiLAWvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiLAWvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:51:24 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AA7C8686
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:50:26 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id y4so3055654plb.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 14:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fC7GRsfU9487zvkZ00n0yK00IS3v6qRRBNuKWVaoA3U=;
        b=iC4iteAPISIUjyDOTh+rS65EwB8rDVM5P7hVLZJUwBiBvPYWFrTdUF/YBavMs7FzKF
         R1IcF7xQ1IpJd8oxQR5X1mb5XepEeaFSlUblesgIkIEAPaE1M9Uql+rGeXV4WVAh5YWt
         NUeH6C8aFRELdXhHy1SkPo+whmdFSdQswqD49MYv7bgwUiDT9OoLroVS31tkT0PzlIYF
         54Aaz0sE9GeUjW4wYZP3xWrJBlHEobLpgd/f05uUIj6lgtK6XA6XKrXAbDV5qeJ6HpiG
         tlP32sN+zwdZNo7VZR4nU7uj4slju1xyOZObCOzjobdQoLrU65N88SVPZ7ZA/V3Ov7lR
         aVKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fC7GRsfU9487zvkZ00n0yK00IS3v6qRRBNuKWVaoA3U=;
        b=NUWcK+CSkY0ZIq84nR13aG/QGEGx0whvW6UWZ44VvnnxkLPd+dSDAs+SOaFewJmqh7
         TnP54YwWiHHS7THlkSwp73GWcwBNjnGI28dYqlG/lJc67nplHQfNvsTWkFAO0uaxW4lU
         4teoYYyOfimKRnsqFGuPAOzWGPRazZb3rK5HnBCmFGUv392Pz/++qFKSwBSM0E+yC58P
         dm3xjHyV7E+ioYyQK+bOWoOc3nR6PtFwY3vAaz/+yufxX1fc2RjQet916u11tzDwb+AC
         hgUWo9I+On6XQNi69XDUiuKQAIJyzVUexQt+KsG8x77CJS7YAR6ngzdjb3MYG1daXhAa
         xc2Q==
X-Gm-Message-State: ANoB5pkYu9eCKcqqgmjtbvxYWMlKUaCy0IPYEtL22AnxDvBgVx1OG0US
        UzSRAyIwtheqLh3dk+yL43VjLEXijRE3ErhV1CEZmg==
X-Google-Smtp-Source: AA0mqf6FWoZVhGaziJ0DWoZLVEWjJu8bXNVWon7OsLKFnQGym/jUIE4LmI1FgqCsX+3UEAK+0KsWrwIVbi2mqTsFnKk=
X-Received: by 2002:a17:903:50c:b0:189:6de9:deb9 with SMTP id
 jn12-20020a170903050c00b001896de9deb9mr30943805plb.153.1669935025832; Thu, 01
 Dec 2022 14:50:25 -0800 (PST)
MIME-Version: 1.0
References: <20221201215644.246571-1-andrew@daynix.com> <20221201173252-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221201173252-mutt-send-email-mst@kernel.org>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Fri, 2 Dec 2022 00:35:03 +0200
Message-ID: <CABcq3pGaf1-XchxYAhX=3k9dEAPLR4p-VR9QUxNa1dNKzwWHXw@mail.gmail.com>
Subject: Re: [PATCH v4 0/6] TUN/VirtioNet USO features support.
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jasowang@redhat.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, got issues with the internet during sending it. Now, all should be done.

On Fri, Dec 2, 2022 at 12:33 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Thu, Dec 01, 2022 at 11:56:38PM +0200, Andrew Melnychenko wrote:
> > Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> > Technically they enable NETIF_F_GSO_UDP_L4
> > (and only if USO4 & USO6 are set simultaneously).
> > It allows the transmission of large UDP packets.
> >
> > UDP Segmentation Offload (USO/GSO_UDP_L4) - ability to split UDP packets
> > into several segments. It's similar to UFO, except it doesn't use IP
> > fragmentation. The drivers may push big packets and the NIC will split
> > them(or assemble them in case of receive), but in the case of VirtioNet
> > we just pass big UDP to the host. So we are freeing the driver from doing
> > the unnecessary job of splitting. The same thing for several guests
> > on one host, we can pass big packets between guests.
> >
> > Different features USO4 and USO6 are required for qemu where Windows
> > guests can enable disable USO receives for IPv4 and IPv6 separately.
> > On the other side, Linux can't really differentiate USO4 and USO6, for now.
> > For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> > In the future, there would be a mechanism to control UDP_L4 GSO separately.
> >
> > New types for virtio-net already in virtio-net specification:
> > https://github.com/oasis-tcs/virtio-spec/issues/120
> >
> > Test it WIP Qemu https://github.com/daynix/qemu/tree/USOv3
> >
> > Andrew (5):
> >   uapi/linux/if_tun.h: Added new offload types for USO4/6.
> >   driver/net/tun: Added features for USO.
> >   uapi/linux/virtio_net.h: Added USO types.
> >   linux/virtio_net.h: Support USO offload in vnet header.
> >   drivers/net/virtio_net.c: Added USO support.
> >
> > Andrew Melnychenko (1):
> >   udp: allow header check for dodgy GSO_UDP_L4 packets.
>
> I don't see patches except 0 on list.
>
> >  drivers/net/tap.c               | 10 ++++++++--
> >  drivers/net/tun.c               |  8 +++++++-
> >  drivers/net/virtio_net.c        | 24 +++++++++++++++++++++---
> >  include/linux/virtio_net.h      |  9 +++++++++
> >  include/uapi/linux/if_tun.h     |  2 ++
> >  include/uapi/linux/virtio_net.h |  5 +++++
> >  net/ipv4/udp_offload.c          |  3 ++-
> >  net/ipv6/udp_offload.c          |  3 ++-
> >  8 files changed, 56 insertions(+), 8 deletions(-)
> >
> > --
> > 2.38.1
> >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
> >
>
