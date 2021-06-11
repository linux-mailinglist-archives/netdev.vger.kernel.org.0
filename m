Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8313A4482
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhFKPAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:00:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231318AbhFKPAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623423482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t7t9i6rMyWuByO+c/GmhouwKqq18hXtoe9jqv+4wd88=;
        b=ZzTBqBs2Lj6lHz8YIr77OJy6opx45MbxrkY+avE+ORkgYxVMsFU+LyHN3QRpQByarTaucX
        RFoPOXKNqujqKbzhoOUuQQMsqB0YF2VoAs45wQZM+pZdo1i5pIaC1bk+ZB9bOyU1EoyQyT
        eeZBGH74fFUsbzi9sPMD4OaVHfKcsig=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-j9RqmWMRPNmto3Gp7kYI-A-1; Fri, 11 Jun 2021 10:58:01 -0400
X-MC-Unique: j9RqmWMRPNmto3Gp7kYI-A-1
Received: by mail-ej1-f71.google.com with SMTP id z15-20020a1709063a0fb029040d43ca6e95so1258088eje.12
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 07:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t7t9i6rMyWuByO+c/GmhouwKqq18hXtoe9jqv+4wd88=;
        b=csSGRvVRdbw4Z1Kch9o43fEgVtH4L+A1yBklZyIs2BzeskdkaklbxRqPqNtjpc8LqW
         JgH1WQWG4MjuuwPeQIf8S5NoQws9tfUa8j55fOpeMc8/YH6mS5arzsovBaK8VNrqAZKM
         +cZlqoLqfNMLVqPoHenmksbsTdcnjwQoH3UxMj6t7rsJ0FXqbIRqQ5oMFWnsQalS3wJB
         gA2Hw1ghO3UAyn2Pf2Sspj30Z2cw30nGS066OvoHpi8QRS8ssJWAjdK7uQ0g6Ky+H+7q
         HWKmV39Co1RU3gjRkd8uOm3Ei5sGq765aXwfs0iDcwXY9/SaKR4YfhR7U/CESvfxRTKw
         y2EA==
X-Gm-Message-State: AOAM532ohS5KQ3IYi+dTFyCZfUSPKE9nePqaJ+iUOFgSNVG7DFx0023R
        VZVunDy05aZ6UvD80L1bhmu3UJfZArSPE0O2NHlhLmmnyaaQydDn0hcjqD5pdGOp9aAAFC4zqWL
        CjKxpAH3WbxZcHy97
X-Received: by 2002:a17:906:5a9a:: with SMTP id l26mr4120572ejq.490.1623423479991;
        Fri, 11 Jun 2021 07:57:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8VqZfIaLC40HefRlsycmNOXzMhFAN1j/Qj/MysEFnXaFHjn+zcDKs93tZTDyfEUtgXzDS+g==
X-Received: by 2002:a17:906:5a9a:: with SMTP id l26mr4120562ejq.490.1623423479766;
        Fri, 11 Jun 2021 07:57:59 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id o4sm2647440edc.94.2021.06.11.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 07:57:59 -0700 (PDT)
Date:   Fri, 11 Jun 2021 16:57:56 +0200
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
Message-ID: <20210611145756.lfi7dwvxqwjhkctr@steredhat>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
 <59b720a8-154f-ad29-e7a9-b86b69408078@kaspersky.com>
 <20210611122533.cy4jce4vxhhou5ms@steredhat>
 <10a64ff5-86df-85f3-5cf2-2fa7e8ddc294@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <10a64ff5-86df-85f3-5cf2-2fa7e8ddc294@kaspersky.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 05:39:01PM +0300, Arseny Krasnov wrote:
>
>On 11.06.2021 15:25, Stefano Garzarella wrote:
>> Hi Arseny,
>>
>> On Fri, Jun 11, 2021 at 02:17:00PM +0300, Arseny Krasnov wrote:
>>> On 11.06.2021 14:07, Arseny Krasnov wrote:
>>>> 	This patchset implements support of SOCK_SEQPACKET for virtio
>>>> transport.
>>>> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
>>>> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
>>>> set to 1 in last RW packet of message.
>>>> 	Now as  packets of one socket are not reordered neither on vsock
>>>> nor on vhost transport layers, such bit allows to restore original
>>>> message on receiver's side. If user's buffer is smaller than message
>>>> length, when all out of size data is dropped.
>>>> 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
>>>> 	Implementation also supports 'MSG_TRUNC' flags.
>>>> 	Tests also implemented.
>>>>
>>>> 	Thanks to stsp2@yandex.ru for encouragements and initial design
>>>> recommendations.
>>>>
>>>>  Arseny Krasnov (18):
>>>>   af_vsock: update functions for connectible socket
>>>>   af_vsock: separate wait data loop
>>>>   af_vsock: separate receive data loop
>>>>   af_vsock: implement SEQPACKET receive loop
>>>>   af_vsock: implement send logic for SEQPACKET
>>>>   af_vsock: rest of SEQPACKET support
>>>>   af_vsock: update comments for stream sockets
>>>>   virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
>>>>   virtio/vsock: simplify credit update function API
>>>>   virtio/vsock: defines and constants for SEQPACKET
>>>>   virtio/vsock: dequeue callback for SOCK_SEQPACKET
>>>>   virtio/vsock: add SEQPACKET receive logic
>>>>   virtio/vsock: rest of SOCK_SEQPACKET support
>>>>   virtio/vsock: enable SEQPACKET for transport
>>>>   vhost/vsock: enable SEQPACKET for transport
>>>>   vsock/loopback: enable SEQPACKET for transport
>>>>   vsock_test: add SOCK_SEQPACKET tests
>>>>   virtio/vsock: update trace event for SEQPACKET
>>>>
>>>>  drivers/vhost/vsock.c                              |  56 ++-
>>>>  include/linux/virtio_vsock.h                       |  10 +
>>>>  include/net/af_vsock.h                             |   8 +
>>>>  .../trace/events/vsock_virtio_transport_common.h   |   5 +-
>>>>  include/uapi/linux/virtio_vsock.h                  |   9 +
>>>>  net/vmw_vsock/af_vsock.c                           | 464 ++++++++++++------
>>>>  net/vmw_vsock/virtio_transport.c                   |  26 ++
>>>>  net/vmw_vsock/virtio_transport_common.c            | 179 +++++++-
>>>>  net/vmw_vsock/vsock_loopback.c                     |  12 +
>>>>  tools/testing/vsock/util.c                         |  32 +-
>>>>  tools/testing/vsock/util.h                         |   3 +
>>>>  tools/testing/vsock/vsock_test.c                   | 116 ++++++
>>>>  12 files changed, 730 insertions(+), 190 deletions(-)
>>>>
>>>>  v10 -> v11:
>>>>  General changelog:
>>>>   - now data is copied to user's buffer only when
>>>>     whole message is received.
>>>>   - reader is woken up when EOR packet is received.
>>>>   - if read syscall was interrupted by signal or
>>>>     timeout, error is returned(not 0).
>>>>
>>>>  Per patch changelog:
>>>>   see every patch after '---' line.
>>> So here is new version for review with updates discussed earlier :)
>> Thanks, I'll review next week, but I suggest you again to split in two
>> series, since patchwork (and netdev maintainers) are not happy with a
>> series of 18 patches.
>>
>> If you still prefer to keep them together during development, then
>> please use the RFC tag.
>>
>> Also did you take a look at the FAQ for netdev that I linked last 
>> time?
>> I don't see the net-next tag...
>
>I didn't use next tag because two patches from first seven(which was
>
>considered to be sent to netdev) - 0004 and 0006
>
>were changed in this patchset(because of last ideas about queueing
>
>whole message). So i removed R-b line and now there is no sense to
>
>use net-next tag for first patches. When it will be R-b - i'll send it 

Okay, in that case better to use RFC tag.

>to
>
>netdev with such tag and we can continue discussing second part
>
>of patches(virtio specific).

Don't worry for now. You can do it for the next round, but I think all 
the patches will go through netdev and would be better to split in 2 
series, both of them with net-next tag.

Thanks,
Stefano

