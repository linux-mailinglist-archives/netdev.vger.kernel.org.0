Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6473BAC21
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhGDIdd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:33:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58185 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229476AbhGDIdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625387457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5mjv6RdL7FMrY4HG6p07wZrW4/GnliOhXTbPvIgXM+o=;
        b=H8THpi2wAXgD4xRxaIMpHH1/wIRiAf8o95SRKboOploAm87ookkwqHgBorKmJUj7dWPEic
        BVT1eleqQzftnHXhWo/b6XrKRyI94HSvXzNVECXCmcg5KQwIgoMXfvAKHxjK3afO7cx9YD
        gnACHFXL+ojo9LakNIpOSf0wxoWq0lc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-x9ONYpzxOQWuw_LjM7RuKA-1; Sun, 04 Jul 2021 04:30:56 -0400
X-MC-Unique: x9ONYpzxOQWuw_LjM7RuKA-1
Received: by mail-wm1-f72.google.com with SMTP id t82-20020a1cc3550000b02901ee1ed24f94so8204307wmf.9
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 01:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5mjv6RdL7FMrY4HG6p07wZrW4/GnliOhXTbPvIgXM+o=;
        b=iHA4v6SCbEyRc5d/AJxzRRO7ld9amDsS3Lw5mjs+dBxPSNcUpKedY8cJcm66z3ODjt
         5MXbv14/jXcSXYm0T2tg6jUN7p2Od+VyxTN5GFm7NcK0t+jYqcJHZHcRoXIvgmbxkBWx
         M649eqf7jS4TR1c37TwtVFiWDv6fec5r6NJyJhu5IidC97Pb4M2OqQANQ06hBcn8ekIR
         P6XvNdo+Uh1dEbSAA+YaoRCcLiiAtkUqfnOhK6pYrgABQpMiSSKXVVEWjEXbqrL+XHPk
         dGADmmc5iQPjutUuzQn8UM3eR5HPRZ80Fe9rnueHiGiO6Wn6tFBFB2aPFm7lw9IOsi/j
         iITA==
X-Gm-Message-State: AOAM5300Vz60eX7Ceys/ILHay0YHACctb6Vm0VJocsGebOVnrl3ZaQ4V
        5uhVRAdtb9rrg4/SO5DFCKlKIogSdnCD8wB7ug3I0R6Y+jaINcH36IKC3XZDfl2h7DmCceTsdHf
        sIfr9Dxc7vN287rqa
X-Received: by 2002:adf:e5c9:: with SMTP id a9mr8700555wrn.376.1625387455168;
        Sun, 04 Jul 2021 01:30:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwxGgBxRdRHKsi3pLvnR9YQmU1IRGI0nidEiliUf/DDtuDrxohgpJHy7wgnQWR8PGRO13Hew==
X-Received: by 2002:adf:e5c9:: with SMTP id a9mr8700530wrn.376.1625387454934;
        Sun, 04 Jul 2021 01:30:54 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id l10sm8293941wrt.49.2021.07.04.01.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 01:30:54 -0700 (PDT)
Date:   Sun, 4 Jul 2021 04:30:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v2 0/6] Improve SOCK_SEQPACKET receive logic
Message-ID: <20210704042843-mutt-send-email-mst@kernel.org>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 04, 2021 at 11:08:13AM +0300, Arseny Krasnov wrote:
> 	This patchset modifies receive logic for SOCK_SEQPACKET.
> Difference between current implementation and this version is that
> now reader is woken up when there is at least one RW packet in rx
> queue of socket and data is copied to user's buffer, while merged
> approach wake up user only when whole message is received and kept
> in queue. New implementation has several advantages:
>  1) There is no limit for message length. Merged approach requires
>     that length must be smaller than 'peer_buf_alloc', otherwise
>     transmission will stuck.
>  2) There is no need to keep whole message in queue, thus no
>     'kmalloc()' memory will be wasted until EOR is received.
> 
>     Also new approach has some feature: as fragments of message
> are copied until EOR is received, it is possible that part of
> message will be already in user's buffer, while rest of message
> still not received. And if user will be interrupted by signal or
> timeout with part of message in buffer, it will exit receive loop,
> leaving rest of message in queue. To solve this problem special
> callback was added to transport: it is called when user was forced
> to leave exit loop and tells transport to drop any packet until
> EOR met.

Sorry about commenting late in the game.  I'm a bit lost


SOCK_SEQPACKET
Provides sequenced, reliable, bidirectional, connection-mode transmission paths for records. A record can be sent using one or more output operations and received using one or more input operations, but a single operation never transfers part of more than one record. Record boundaries are visible to the receiver via the MSG_EOR flag.

it's supposed to be reliable - how is it legal to drop packets?


> When EOR is found, this mode is disabled and normal packet
> processing started. Note, that when 'drop until EOR' mode is on,
> incoming packets still inserted in queue, reader will be woken up,
> tries to copy data, but nothing will be copied until EOR found.
> It was possible to drain such unneeded packets it rx work without
> kicking user, but implemented way is simplest. Anyway, i think
> such cases are rare.


>     New test also added - it tries to copy to invalid user's
> buffer.
> 
> Arseny Krasnov (16):
>  af_vsock/virtio/vsock: change seqpacket receive logic
>  af_vsock/virtio/vsock: remove 'seqpacket_has_data' callback
>  virtio/vsock: remove 'msg_count' based logic
>  af_vsock/virtio/vsock: add 'seqpacket_drop()' callback
>  virtio/vsock: remove record size limit for SEQPACKET
>  vsock_test: SEQPACKET read to broken buffer
> 
>  drivers/vhost/vsock.c                   |   2 +-
>  include/linux/virtio_vsock.h            |   7 +-
>  include/net/af_vsock.h                  |   4 +-
>  net/vmw_vsock/af_vsock.c                |  44 ++++----
>  net/vmw_vsock/virtio_transport.c        |   2 +-
>  net/vmw_vsock/virtio_transport_common.c | 103 ++++++++-----------
>  net/vmw_vsock/vsock_loopback.c          |   2 +-
>  tools/testing/vsock/vsock_test.c        | 120 ++++++++++++++++++++++
>  8 files changed, 193 insertions(+), 91 deletions(-)
> 
>  v1 -> v2:
>  Patches reordered and reorganized.
> 
> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
> ---
>  cv.txt | 0
>  1 file changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 cv.txt
> 
> diff --git a/cv.txt b/cv.txt
> new file mode 100644
> index 000000000000..e69de29bb2d1
> -- 
> 2.25.1

