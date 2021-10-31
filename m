Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50C7440F30
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 16:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhJaPlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 11:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhJaPlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 11:41:00 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC05EC061570
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 08:38:28 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id ay21so7041689uab.12
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 08:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/DMyohOWdXPyhg1wQ6EXkgg16+mKidkiCYKLquXwk3o=;
        b=iOSJ3zT4CzRoNn5efFa/M784mUmjitd1sxBCleHNmGY1VnNmg8MRCjTel14ollf2+c
         aJE14EtUsvImlxR/QznTnF2DxiQkaz2TEwlD/WHF2uP69spnzHiJGPv7NGbqTsjktQDT
         0U4Rm3t1t56p9fx5UM94ifmlhvnewPasV3fbi0iiWklDQ4XHzlnOHpiKlXYeb7vt0571
         6LkGX2b/AxV49vp5TBxp8DJZa8fwLxvQIgfyTSNl11PESGgAnDUGUiaynA9vF9ytcLKH
         2qTK5XvcC7u185IyKcMEJceJPmxppBTZcRUSnk8yEQKPfLrrmHzgWgASlD45wvOjoQJ/
         L1hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/DMyohOWdXPyhg1wQ6EXkgg16+mKidkiCYKLquXwk3o=;
        b=zXBCLrMmE/n9/9H144+kPHM6EZ2E/L5w7qt13+ZjMQDMg43gTlLGgW2+7ncV7HM+Gv
         pZ5OEkvVoLGvonQzsCbQ+G6rlliEpFUiQgGzMBoGTBKtTojPLuEIt3yCy77Lpq1Hryli
         4sK+uwHACJv120mPFI2eBEmX6JWPkMFsv8+VjjwkM28VNGt+1gsiEiLJYbYrDu1Tr6Ky
         etCYjaD6KbVctq0AAUJJIU47G8ITSNApaQgqbHBHeD5zJxzTz6T606N+baZ1ldKcJu+e
         Cb8jJfWP71kmkdt9995Y9IU1l1qZahVREZQIQjCINT4avRsRU/QTUrh28hgLpwC/0RKC
         GfjQ==
X-Gm-Message-State: AOAM533oi4ccoBPV9ITrdFtHIFqZyuJ6MAtwEy/8Jw3BQQcZ3xPM20T4
        cka/FeJwmeBYvJIYDWFG2Nk8D+SbqxE=
X-Google-Smtp-Source: ABdhPJx28nW/7pADgSUHizMr7+hMdrJC46Oi/zoV+HOH6GW2fut4gyprSASVz/AdZQlyJ8bqgKGj0g==
X-Received: by 2002:ab0:271a:: with SMTP id s26mr23160708uao.77.1635694708148;
        Sun, 31 Oct 2021 08:38:28 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id j27sm546373vkp.46.2021.10.31.08.38.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Oct 2021 08:38:27 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id e2so27536957uax.7
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 08:38:27 -0700 (PDT)
X-Received: by 2002:a67:facc:: with SMTP id g12mr2351426vsq.22.1635694707053;
 Sun, 31 Oct 2021 08:38:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211031045959.143001-1-andrew@daynix.com> <20211031045959.143001-4-andrew@daynix.com>
 <CA+FuTScq-B9tXjV8qO5oBpFGObhGGZDSXC+iRMxwH89TvEhexw@mail.gmail.com>
In-Reply-To: <CA+FuTScq-B9tXjV8qO5oBpFGObhGGZDSXC+iRMxwH89TvEhexw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Oct 2021 11:37:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTScP-LcRO5PXjohzDS8NXmF6j6u5nxprtnj89q6Cucmgbw@mail.gmail.com>
Message-ID: <CA+FuTScP-LcRO5PXjohzDS8NXmF6j6u5nxprtnj89q6Cucmgbw@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] drivers/net/virtio_net: Added basic RSS support.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Andrew Melnychenko <andrew@daynix.com>, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuri.benditovich@daynix.com,
        yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +               hdr_hash = (struct virtio_net_hdr_v1_hash *)(hdr);
> > +
> > +               switch (hdr_hash->hash_report) {
> > +               case VIRTIO_NET_HASH_REPORT_TCPv4:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv4:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6:
> > +               case VIRTIO_NET_HASH_REPORT_TCPv6_EX:
> > +               case VIRTIO_NET_HASH_REPORT_UDPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L4;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_IPv4:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6:
> > +               case VIRTIO_NET_HASH_REPORT_IPv6_EX:
> > +                       rss_hash_type = PKT_HASH_TYPE_L3;
> > +                       break;
> > +               case VIRTIO_NET_HASH_REPORT_NONE:
> > +               default:
> > +                       rss_hash_type = PKT_HASH_TYPE_NONE;
> > +               }
>
> Is this detailed protocol typing necessary? Most devices only pass a bit is_l4.
> > +static void virtnet_init_default_rss(struct virtnet_info *vi)
> > +{
> > +       u32 indir_val = 0;
> > +       int i = 0;
> > +
> > +       vi->ctrl->rss.table_info.hash_types = vi->rss_hash_types_supported;
>
> Similar to above, and related to the next patch: is this very detailed
> specification of supported hash types needed? When is this useful? It
> is not customary to specify RSS to that degree.

My bad. This is also implemented by bnxt, for one. I was unaware of
this feature.
