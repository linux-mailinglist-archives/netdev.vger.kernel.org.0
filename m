Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF53E3A41EE
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhFKM1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230377AbhFKM1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623414338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+saQX1pFifHAMfA75K26b9IDNQxzW3sh1B/T8sEy8xE=;
        b=P7fQO0LHTp9kcgF1zZ03nFMXrCEGkvVSqBQ2+eQeadktk4YT+AXvOV3Jn0iWv6h0Aq+Fey
        +czm6UqcoV0B0xZ6fiiq9bW/sq/EUfXyyQKvHS/4djoiJs5vc2PHd0UZ+9reC+weuNF4wm
        Xaq8QI2ow7pO6ACiZDmJSHCAcCrcaAQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-0rgkunsiNCuZgyjAh03l3A-1; Fri, 11 Jun 2021 08:25:37 -0400
X-MC-Unique: 0rgkunsiNCuZgyjAh03l3A-1
Received: by mail-ej1-f71.google.com with SMTP id p18-20020a1709067852b02903dab2a3e1easo1072376ejm.17
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 05:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+saQX1pFifHAMfA75K26b9IDNQxzW3sh1B/T8sEy8xE=;
        b=F0CCAdPO6UyPzzB51+bJNxrR/1EmBYs9aAZZoqkyNTmVgfoBcvddPAOHIMPzytwbH/
         GtHUsIBx11Am/nUK2xosx1mMa3+2c1G7H2DV4S9u3oUB6RWOqQL8kj4dM7A7wOF1Ay9w
         8+OSo5CYidsCSpbLXUwtIrspIBB6m2SnezTzZ4ilgIXnfacRW9YhCx+SuC4joyJ3P6hT
         0MfQa0MvEGEbupVTXJMVQbOi5LWT1zoopy/PVnjXg5fb7n3t5yROfCIfnvsraw86aa4M
         p9SX59fNibfgzM5NTD4GR8iQCHtGJ7GFCh+ffczA2FLX2OC6WFaFxqepXRT48iwa9Abu
         jhMw==
X-Gm-Message-State: AOAM532Kfr+2kGAB2/Sp1wqNsZNs2MD75rSNtbd/h1wDaTfh+9QabNL7
        3B95juOvL36W1dskbmXwoedWnTjsOOxJ7OTNDfdqsjEZPNyWXH455CMD71JXiaVEGgI2Sb8fPOZ
        U7Ek4HKSvGQtHRFjL
X-Received: by 2002:a17:906:2b04:: with SMTP id a4mr3391580ejg.6.1623414336106;
        Fri, 11 Jun 2021 05:25:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPbmShTD8/mzWY6bPdx7L57uktKQ4wfEOyzzKRXT1hmYodewrqYPlF9qdrHraWuNSTa7EpDQ==
X-Received: by 2002:a17:906:2b04:: with SMTP id a4mr3391574ejg.6.1623414335924;
        Fri, 11 Jun 2021 05:25:35 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id x15sm2111520edd.6.2021.06.11.05.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 05:25:35 -0700 (PDT)
Date:   Fri, 11 Jun 2021 14:25:33 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
Subject: Re: [PATCH v11 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
Message-ID: <20210611122533.cy4jce4vxhhou5ms@steredhat>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <59b720a8-154f-ad29-e7a9-b86b69408078@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <59b720a8-154f-ad29-e7a9-b86b69408078@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny,

On Fri, Jun 11, 2021 at 02:17:00PM +0300, Arseny Krasnov wrote:
>
>On 11.06.2021 14:07, Arseny Krasnov wrote:
>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>> transport.
>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>> set to 1 in last RW packet of message.
>> 	Now as  packets of one socket are not reordered neither on vsock
>> nor on vhost transport layers, such bit allows to restore original
>> message on receiver's side. If user's buffer is smaller than message
>> length, when all out of size data is dropped.
>> 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
>> 	Implementation also supports 'MSG_TRUNC' flags.
>> 	Tests also implemented.
>>
>> 	Thanks to stsp2@yandex.ru for encouragements and initial design
>> recommendations.
>>
>>  Arseny Krasnov (18):
>>   af_vsock: update functions for connectible socket
>>   af_vsock: separate wait data loop
>>   af_vsock: separate receive data loop
>>   af_vsock: implement SEQPACKET receive loop
>>   af_vsock: implement send logic for SEQPACKET
>>   af_vsock: rest of SEQPACKET support
>>   af_vsock: update comments for stream sockets
>>   virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>>   virtio/vsock: simplify credit update function API
>>   virtio/vsock: defines and constants for SEQPACKET
>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>   virtio/vsock: add SEQPACKET receive logic
>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>   virtio/vsock: enable SEQPACKET for transport
>>   vhost/vsock: enable SEQPACKET for transport
>>   vsock/loopback: enable SEQPACKET for transport
>>   vsock_test: add SOCK_SEQPACKET tests
>>   virtio/vsock: update trace event for SEQPACKET
>>
>>  drivers/vhost/vsock.c                              |  56 ++-
>>  include/linux/virtio_vsock.h                       |  10 +
>>  include/net/af_vsock.h                             |   8 +
>>  .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>>  include/uapi/linux/virtio_vsock.h                  |   9 +
>>  net/vmw_vsock/af_vsock.c                           | 464 ++++++++++++------
>>  net/vmw_vsock/virtio_transport.c                   |  26 ++
>>  net/vmw_vsock/virtio_transport_common.c            | 179 +++++++-
>>  net/vmw_vsock/vsock_loopback.c                     |  12 +
>>  tools/testing/vsock/util.c                         |  32 +-
>>  tools/testing/vsock/util.h                         |   3 +
>>  tools/testing/vsock/vsock_test.c                   | 116 ++++++
>>  12 files changed, 730 insertions(+), 190 deletions(-)
>>
>>  v10 -> v11:
>>  General changelog:
>>   - now data is copied to user's buffer only when
>>     whole message is received.
>>   - reader is woken up when EOR packet is received.
>>   - if read syscall was interrupted by signal or
>>     timeout, error is returned(not 0).
>>
>>  Per patch changelog:
>>   see every patch after '---' line.
>So here is new version for review with updates discussed earlier :)

Thanks, I'll review next week, but I suggest you again to split in two 
series, since patchwork (and netdev maintainers) are not happy with a 
series of 18 patches.

If you still prefer to keep them together during development, then 
please use the RFC tag.

Also did you take a look at the FAQ for netdev that I linked last time?
I don't see the net-next tag...

Thanks,
Stefano

