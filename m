Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218AE3A3133
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 18:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhFJQqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 12:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFJQqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 12:46:43 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18D3C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 09:44:33 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id o17-20020a9d76510000b02903eabfc221a9so377036otl.0
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 09:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=g8tVa/tKF1Z1CFOTKrCMtVkTz0WRgBPyaTEt7gz3464=;
        b=W1+d+fDE8NSQkxbRbfU7zYcFBjCkx/2su5gXnqeg4CLRMyq2bz8jAz/745Fm/ABMiE
         g2JgptK7cOjALXDUq9nxVJg3FpvkS20L3IRxTQONFGFNt27nfkwUUVlXgV1DsvvzTn0X
         OqEZ7Huloj8M/ZorHEkpoDbk4NE0IjYfU3040AtiyYJh9QRAr9YuwfjloRqge4dXayq2
         VMY1bi5fnuQCxbJcbZoT/USdC4LvjjX+8LmLui/XyBjn4pBkdJ4wxVE69YC/7l8f9XdE
         2RWjczc/NJLLLksutLckOMeJS23epSZ1ywSt33bO4g6igszI7OAXVuHXq/JU/RR2cGbr
         5VnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=g8tVa/tKF1Z1CFOTKrCMtVkTz0WRgBPyaTEt7gz3464=;
        b=Q3MQlI7BJrlb7Kb8OVep2A/Fp4akZhCGEgUZFOFp/22XeTPcJrErwzCPpeTC6T0e+F
         iv2JyHT8y4KC+OAvbbTAPEk2IJWVuWX/pexajsb/+rGXc8nXKDgsTsrUSwzkLQA9stNi
         SzBsKzWVrlxe0m0OsQJfUbJADIBaw+DR4Gcs95jTkrb+r/lCQ5ZQhQFevSAoDr0e3stl
         hHpqWwxYhca1UEYzKenLiqZeUg26foxBW63mks7kC9CTbVTYuTbeGNZdoofpq3YSqe2D
         L5oD86dWtUBTjsjdDkyyIfFB5M7hy7/u8nl6yYW4Ct2jJMp04cHABzIYIkv7QJUzu8yR
         RmYA==
X-Gm-Message-State: AOAM530b7yHkad3IvQkdgzh1gTO6Y8Ml4nNlOaVvaszxKZY3VAWpkBhX
        34sDUOna8+IIGjqCA6VnQgZ4nAgPikLQIdzZxflOHQ==
X-Google-Smtp-Source: ABdhPJynSuOt7MYRmCjZvAc5B4VmBGBKyZsPveniHvv9WSF0sbxlVWyakjj9xBT1MIK+WtKSHQrs2p3/PxCc3y/Cw4o=
X-Received: by 2002:a05:6830:2117:: with SMTP id i23mr3087102otc.279.1623343473082;
 Thu, 10 Jun 2021 09:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <da90f17a-1c24-b475-76ef-f6a7fc2bcdd5@redhat.com> <CAP_N_Z_VDd+JUJ_Y-peOEc7FgwNGB8O3uZpVumQT_DbW62Jpjw@mail.gmail.com>
 <ac0c241c-1013-1304-036f-504d0edc5fd7@redhat.com> <20210610072358.3fuvsahxec2sht4y@steredhat>
 <47ce307b-f95e-25c7-ed58-9cd1cbff5b57@redhat.com> <20210610095151.2cpyny56kbotzppp@steredhat>
In-Reply-To: <20210610095151.2cpyny56kbotzppp@steredhat>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Thu, 10 Jun 2021 09:44:22 -0700
Message-ID: <CAP_N_Z8u5U2yxMWG2bNgp1cbRcVqv4gEHA_i-4=r9h1HFFGYOA@mail.gmail.com>
Subject: Re: Re: [RFC v1 0/6] virtio/vsock: introduce SOCK_DGRAM support
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
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

On Thu, Jun 10, 2021 at 2:52 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Thu, Jun 10, 2021 at 03:46:55PM +0800, Jason Wang wrote:
> >
> >=E5=9C=A8 2021/6/10 =E4=B8=8B=E5=8D=883:23, Stefano Garzarella =E5=86=99=
=E9=81=93:
> >>On Thu, Jun 10, 2021 at 12:02:35PM +0800, Jason Wang wrote:
> >>>
> >>>=E5=9C=A8 2021/6/10 =E4=B8=8A=E5=8D=8811:43, Jiang Wang . =E5=86=99=E9=
=81=93:
> >>>>On Wed, Jun 9, 2021 at 6:51 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>>>
> >>>>>=E5=9C=A8 2021/6/10 =E4=B8=8A=E5=8D=887:24, Jiang Wang =E5=86=99=E9=
=81=93:
> >>>>>>This patchset implements support of SOCK_DGRAM for virtio
> >>>>>>transport.
> >>>>>>
> >>>>>>Datagram sockets are connectionless and unreliable. To avoid
> >>>>>>unfair contention
> >>>>>>with stream and other sockets, add two more virtqueues and
> >>>>>>a new feature bit to indicate if those two new queues exist or not.
> >>>>>>
> >>>>>>Dgram does not use the existing credit update mechanism for
> >>>>>>stream sockets. When sending from the guest/driver, sending packets
> >>>>>>synchronously, so the sender will get an error when the
> >>>>>>virtqueue is full.
> >>>>>>When sending from the host/device, send packets asynchronously
> >>>>>>because the descriptor memory belongs to the corresponding QEMU
> >>>>>>process.
> >>>>>
> >>>>>What's the use case for the datagram vsock?
> >>>>>
> >>>>One use case is for non critical info logging from the guest
> >>>>to the host, such as the performance data of some applications.
> >>>
> >>>
> >>>Anything that prevents you from using the stream socket?
> >>>
> >>>
> >>>>
> >>>>It can also be used to replace UDP communications between
> >>>>the guest and the host.
> >>>
> >>>
> >>>Any advantage for VSOCK in this case? Is it for performance (I
> >>>guess not since I don't exepct vsock will be faster).
> >>
> >>I think the general advantage to using vsock are for the guest
> >>agents that potentially don't need any configuration.
> >
> >
> >Right, I wonder if we really need datagram consider the host to guest
> >communication is reliable.
> >
> >(Note that I don't object it since vsock has already supported that,
> >just wonder its use cases)
>
> Yep, it was the same concern I had :-)
> Also because we're now adding SEQPACKET, which provides reliable
> datagram support.
>
> But IIUC the use case is the logging where you don't need a reliable
> communication and you want to avoid to keep more open connections with
> different guests.
>
> So the server in the host can be pretty simple and doesn't have to
> handle connections. It just waits for datagrams on a port.

Yes. With datagram sockets, the application code is simpler than the stream
sockets. Also, it will be easier to port existing applications written
for dgram,
such as UDP or unix domain socket with datagram types to the vsock
dgram sockets.

Compared to UDP, the vsock dgram has a minimum configuration. When
sending data from the guest to the host, the client in the guest knows
the host CID will always be 2. For UDP, the host IP may change depending
on the configuration.

The advantage over UNIX domain sockets is more obvious. We
have some applications talking to each other with UNIX domain sockets,
but now the applications are running inside VMs, so we will need to
use vsock and those applications use datagram types, so it is natural
and simpler if vsock has datagram types too.

And we can also run applications for vmware vsock dgram on
the QEMU directly.

btw, SEQPACKET also supports datagram, but the application code
logic is similar to stream sockets and the server needs to maintain
connections.

> >
> >
> >>
> >>>
> >>>An obvious drawback is that it breaks the migration. Using UDP you
> >>>can have a very rich features support from the kernel where vsock
> >>>can't.
> >>>
> >>
> >>Thanks for bringing this up!
> >>What features does UDP support and datagram on vsock could not support?
> >
> >
> >E.g the sendpage() and busy polling. And using UDP means qdiscs and
> >eBPF can work.
>
> Thanks, I see!
>
> >
> >
> >>
> >>>
> >>>>
> >>>>>>The virtio spec patch is here:
> >>>>>>https://www.spinics.net/lists/linux-virtualization/msg50027.html
> >>>>>
> >>>>>Have a quick glance, I suggest to split mergeable rx buffer into an
> >>>>>separate patch.
> >>>>Sure.
> >>>>
> >>>>>But I think it's time to revisit the idea of unifying the
> >>>>>virtio-net and
> >>>>>virtio-vsock. Otherwise we're duplicating features and bugs.
> >>>>For mergeable rxbuf related code, I think a set of common helper
> >>>>functions can be used by both virtio-net and virtio-vsock. For other
> >>>>parts, that may not be very beneficial. I will think about more.
> >>>>
> >>>>If there is a previous email discussion about this topic, could
> >>>>you send me
> >>>>some links? I did a quick web search but did not find any related
> >>>>info. Thanks.
> >>>
> >>>
> >>>We had a lot:
> >>>
> >>>[1] https://patchwork.kernel.org/project/kvm/patch/5BDFF537.3050806@hu=
awei.com/
> >>>[2] https://lists.linuxfoundation.org/pipermail/virtualization/2018-No=
vember/039798.html
> >>>[3] https://www.lkml.org/lkml/2020/1/16/2043
> >>>
Got it. I will check, thanks.

> >>When I tried it, the biggest problem that blocked me were all the
> >>features strictly related to TCP/IP stack and ethernet devices that
> >>vsock device doesn't know how to handle: TSO, GSO, checksums, MAC,
> >>napi, xdp, min ethernet frame size, MTU, etc.
> >
> >
> >It depends on which level we want to share:
> >
> >1) sharing codes
> >2) sharing devices
> >3) make vsock a protocol that is understood by the network core
> >
> >We can start from 1), the low level tx/rx logic can be shared at both
> >virtio-net and vhost-net. For 2) we probably need some work on the
> >spec, probably with a new feature bit to demonstrate that it's a vsock
> >device not a ethernet device. Then if it is probed as a vsock device we
> >won't let packet to be delivered in the TCP/IP stack. For 3), it would
> >be even harder and I'm not sure it's worth to do that.
> >
> >
> >>
> >>So in my opinion to unify them is not so simple, because vsock is not
> >>really an ethernet device, but simply a socket.
> >
> >
> >We can start from sharing codes.
>
> Yep, I agree, and maybe the mergeable buffer is a good starting point to
> share code!
>
> @Jiang, do you want to take a look of this possibility?

Yes. I already read code about mergeable buffer in virtio-net, which I thin=
k
is the only place so far to use it. I will check how to share the code.

Thanks for all the comments.

> Thanks,
> Stefano
>
