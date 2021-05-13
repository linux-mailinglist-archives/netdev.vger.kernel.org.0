Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF46837F96C
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhEMOLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:11:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230355AbhEMOLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:11:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620915024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cUgVX0TtQOw33OQHk7jduOTQRZ441iaMNO9LgK0Gtaw=;
        b=AHZx9IYhxb+Eoaxu8GKScAthgEP6V1hHaCuO72a+Y1SCfKBuKqtNG4usH2B1FRw9jl/qGb
        DdlXp3R6PXFZRxJdeLzv1oeff88go7L53Ok9umG2PDvAz7cW7mhJ3OUdQeozJO0LEoB7XH
        /37WToMzkH+8L4hcRCB+FY8NZTQoctA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-tK1QSYHRPJqwa4cfAFxzlQ-1; Thu, 13 May 2021 10:10:23 -0400
X-MC-Unique: tK1QSYHRPJqwa4cfAFxzlQ-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a0564025214b029038752a2d8f3so14696231edd.2
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 07:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cUgVX0TtQOw33OQHk7jduOTQRZ441iaMNO9LgK0Gtaw=;
        b=hC7VApq+kqmTV8B5OCBjvKbJUvzTKWLMXX7UKZWVfZhx8vYWR3ohFjoTDYF1P4W61u
         r0r/nTKMzIkHN6+y3NagAv9H794LGSWs3g2CLVuSbvmkeS/P6ir+tS5TXCAs6XLj2+5u
         a82KehtRX3GaOCHhCJ8oawb/+hpjMv72uuf6kQK/jQmTH0VhQskZop+rqT9+HUbaKOcM
         PYf+tFMgBKF02k4ARg37RkUFVVfkKFa04Y45f4CQhxvQddHq0FX2Nkvb/VpqjyaxG026
         ewgtaNtiu1tAqVbBwBQJZWqXNg+C4VwTp4vKT8YB7TTWDnm/r7faBF0Q9xPm3Wy/2h6b
         bMnA==
X-Gm-Message-State: AOAM5300804QPEmYuN8TkLPK4VWVhNmNdrrURZkO6ZE3ci4Mv1mXniWe
        bxG3YqBr8XOHWNTlcCk+SBPOgJLh1ftnYDCqzBwEzYO+E+UFtrYtrJ0YSnqawEkiL1i32bXUzi+
        OmfdiIcrmSP8d+6SU
X-Received: by 2002:a05:6402:2753:: with SMTP id z19mr50413596edd.158.1620915021916;
        Thu, 13 May 2021 07:10:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp3m8czj990oJcgrq3r1y1d2MyGwI6B6St58aGtioobv+NKtOs+1ULQ9LjfW982v9t9xMbEw==
X-Received: by 2002:a05:6402:2753:: with SMTP id z19mr50413547edd.158.1620915021631;
        Thu, 13 May 2021 07:10:21 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id z4sm2390717edc.1.2021.05.13.07.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 07:10:20 -0700 (PDT)
Date:   Thu, 13 May 2021 16:10:18 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v9 00/19] virtio/vsock: introduce SOCK_SEQPACKET
 support
Message-ID: <20210513141018.pqsmb5wqbjrbwwho@steredhat>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Sat, May 08, 2021 at 07:30:23PM +0300, Arseny Krasnov wrote:
>	This patchset implements support of SOCK_SEQPACKET for virtio
>transport.
>	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>set to 1 in last RW packet of message.
>	Now as  packets of one socket are not reordered neither on vsock
>nor on vhost transport layers, such bit allows to restore original
>message on receiver's side. If user's buffer is smaller than message
>length, when all out of size data is dropped.
>	Maximum length of datagram is not limited as in stream socket,
>because same credit logic is used. Difference with stream socket is
>that user is not woken up until whole record is received or error
>occurred. Implementation also supports 'MSG_TRUNC' flags.
>	Tests also implemented.
>
>	Thanks to stsp2@yandex.ru for encouragements and initial design
>recommendations.
>
> Arseny Krasnov (19):
>  af_vsock: update functions for connectible socket
>  af_vsock: separate wait data loop
>  af_vsock: separate receive data loop
>  af_vsock: implement SEQPACKET receive loop
>  af_vsock: implement send logic for SEQPACKET
>  af_vsock: rest of SEQPACKET support
>  af_vsock: update comments for stream sockets
>  virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>  virtio/vsock: simplify credit update function API
>  virtio/vsock: defines and constants for SEQPACKET
>  virtio/vsock: dequeue callback for SOCK_SEQPACKET
>  virtio/vsock: add SEQPACKET receive logic
>  virtio/vsock: rest of SOCK_SEQPACKET support
>  virtio/vsock: enable SEQPACKET for transport
>  vhost/vsock: enable SEQPACKET for transport
>  vsock/loopback: enable SEQPACKET for transport
>  vsock_test: add SOCK_SEQPACKET tests
>  virtio/vsock: update trace event for SEQPACKET
>  af_vsock: serialize writes to shared socket
>
> drivers/vhost/vsock.c                        |  42 +-
> include/linux/virtio_vsock.h                 |   9 +
> include/net/af_vsock.h                       |   8 +
> .../events/vsock_virtio_transport_common.h   |   5 +-
> include/uapi/linux/virtio_vsock.h            |   9 +
> net/vmw_vsock/af_vsock.c                     | 417 +++++++++++------
> net/vmw_vsock/virtio_transport.c             |  25 +
> net/vmw_vsock/virtio_transport_common.c      | 129 ++++-
> net/vmw_vsock/vsock_loopback.c               |  11 +
> tools/testing/vsock/util.c                   |  32 +-
> tools/testing/vsock/util.h                   |   3 +
> tools/testing/vsock/vsock_test.c             |  63 +++
> 12 files changed, 594 insertions(+), 159 deletions(-)
>
> v8 -> v9:
> General changelog:
> - see per patch change log.
>

I reviewed this series and left some comments.

Before remove the RFC tag, please check that all the commit messages 
contains the right information.

Also, I recommend you take a look on how the other commits in the Linux 
tree are written because the commits in this series look like todo 
lists.
For RFC could be fine, but for the final version it would be better to 
rewrite them following the advice written here: 
Documentation/process/submitting-patches.rst

Thanks,
Stefano

