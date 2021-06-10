Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C403A22EF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 05:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhFJDqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 23:46:24 -0400
Received: from mail-ot1-f43.google.com ([209.85.210.43]:42540 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhFJDqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 23:46:23 -0400
Received: by mail-ot1-f43.google.com with SMTP id w23-20020a9d5a970000b02903d0ef989477so21739989oth.9
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 20:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d/HsOChtoCYv2fZLAnHj+L8OfimOjEe4YM7F//2V4UM=;
        b=Xh67DyPE6Dr/kBZT1T6WHVHNDgnklob0hvRge79XgS3dUfpC+iqe3geJA0EJxO4kzK
         Ot37b8Pulgxw5XN5Fa6KGf7GYNhkyGy+9RcqdrLjnpbSuIDFQPEbKb0Xf44MrNP1zLm2
         WrWY3RAEWZtR0mQ87N4jnbpzkvSxN3+BHFZgazaGKzsNdaOKZFiEScjc0GExA2l5UsJ4
         F0wFDYmOkxIRvWpAt2j18370FgzP+3AndnwDqjm1R/xH7PG3XDpFClhwRA5bo5+vnqTl
         HWjnxbrNmbjoFG/D0xBPsqZ+n+UakseIticWoF9S9UcgMHc0R+YVxkD8cqlRd/7fe3CB
         Zt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d/HsOChtoCYv2fZLAnHj+L8OfimOjEe4YM7F//2V4UM=;
        b=AsY+U/wynkQip9WARy5MmwnzagZ5GLaemZ/wBNWEIMTxxjdHqtAANr4Nv0QQ4b/asI
         QMSleSa75WOWQH5DrJQFKZy6S/o7aYtl2acF1q2Vu360bjDVvMWvzxWZhCEfAGppS0dP
         cfrsjgVAAsRlRqnvXnIj8kmgOsVyWuCdmSSTCNRBF+pwWc/T6oqYo99LOeitUf2M+jRA
         X6zyKMVuIXRPMCnoGPOcHIDpQsqRIWt18aL7WjlHJNIhfvRztqmANNIr994uAqNqdwCu
         67lG/LJs7Coeg6mXNlcGWgP0Kus2FW6PJTfn7k7MJMBL+4Z75+btyDxZq7SfkcqoOMPU
         5SMg==
X-Gm-Message-State: AOAM532r4inl90FDEGwiyvu42QB3+Z3uhpPwkFNsGFepesyMAv9YIBUL
        1juqxYFo0AxFW68zYPi4PWYwe1nJ5Vp1ObJypGA7BQ==
X-Google-Smtp-Source: ABdhPJwaI7pY5h+Lp2iauvfmhJT8Zg+jqsNfguAo720I85KWBapKSLe5j38W7lEBj40rsZP877aszFSAKUNQM7jHv0A=
X-Received: by 2002:a9d:711c:: with SMTP id n28mr704194otj.180.1623296592541;
 Wed, 09 Jun 2021 20:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com> <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
In-Reply-To: <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Wed, 9 Jun 2021 20:43:01 -0700
Message-ID: <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
Subject: Re: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     Jason Wang <jasowang@redhat.com>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Lu Wei <luwei32@huawei.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/6/10 =E4=B8=8A=E5=8D=887:24, Jiang Wang =E5=86=99=E9=81=93=
:
> > This patchset implements support of SOCK_DGRAM for virtio
> > transport.
> >
> > Datagram sockets are connectionless and unreliable. To avoid unfair con=
tention
> > with stream and other sockets, add two more virtqueues and
> > a new feature bit to indicate if those two new queues exist or not.
> >
> > Dgram does not use the existing credit update mechanism for
> > stream sockets. When sending from the guest/driver, sending packets
> > synchronously, so the sender will get an error when the virtqueue is fu=
ll.
> > When sending from the host/device, send packets asynchronously
> > because the descriptor memory belongs to the corresponding QEMU
> > process.
>
>
> What's the use case for the datagram vsock?
>
One use case is for non critical info logging from the guest
to the host, such as the performance data of some applications.

It can also be used to replace UDP communications between
the guest and the host.

> >
> > The virtio spec patch is here:
> > https://www.spinics.net/lists/linux-virtualization/msg50027.html
>
>
> Have a quick glance, I suggest to split mergeable rx buffer into an
> separate patch.

Sure.

> But I think it's time to revisit the idea of unifying the virtio-net and
> virtio-vsock. Otherwise we're duplicating features and bugs.

For mergeable rxbuf related code, I think a set of common helper
functions can be used by both virtio-net and virtio-vsock. For other
parts, that may not be very beneficial. I will think about more.

If there is a previous email discussion about this topic, could you send me
some links? I did a quick web search but did not find any related
info. Thanks.

> Thanks
>
>
> >
> > For those who prefer git repo, here is the link for the linux kernel=EF=
=BC=9A
> > https://github.com/Jiang1155/linux/tree/vsock-dgram-v1
> >
> > qemu patch link:
> > https://github.com/Jiang1155/qemu/tree/vsock-dgram-v1
> >
> >
> > To do:
> > 1. use skb when receiving packets
> > 2. support multiple transport
> > 3. support mergeable rx buffer
> >
> >
> > Jiang Wang (6):
> >    virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
> >    virtio/vsock: add support for virtio datagram
> >    vhost/vsock: add support for vhost dgram.
> >    vsock_test: add tests for vsock dgram
> >    vhost/vsock: add kconfig for vhost dgram support
> >    virtio/vsock: add sysfs for rx buf len for dgram
> >
> >   drivers/vhost/Kconfig                              |   8 +
> >   drivers/vhost/vsock.c                              | 207 ++++++++--
> >   include/linux/virtio_vsock.h                       |   9 +
> >   include/net/af_vsock.h                             |   1 +
> >   .../trace/events/vsock_virtio_transport_common.h   |   5 +-
> >   include/uapi/linux/virtio_vsock.h                  |   4 +
> >   net/vmw_vsock/af_vsock.c                           |  12 +
> >   net/vmw_vsock/virtio_transport.c                   | 433 ++++++++++++=
++++++---
> >   net/vmw_vsock/virtio_transport_common.c            | 184 ++++++++-
> >   tools/testing/vsock/util.c                         | 105 +++++
> >   tools/testing/vsock/util.h                         |   4 +
> >   tools/testing/vsock/vsock_test.c                   | 195 ++++++++++
> >   12 files changed, 1070 insertions(+), 97 deletions(-)
> >
>
