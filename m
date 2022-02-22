Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDA494BF8B6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 14:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiBVNF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 08:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiBVNF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 08:05:59 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9196A137744
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:05:31 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id k9-20020a056830242900b005ad25f8ebfdso9552869ots.7
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 05:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=y01kJbrbcxAmMynqwHOhpegkdcYtXci9FUmRqGex7Vk=;
        b=MYLIC1UuwnuT1lAmTqdLKxfPFzcJiWQU2Dy7VgzbPDvSgwmStLXeAxRIh9n8JPMWV8
         XmMpMBQpxZwL4AT3xNJ6LR71Nu9IKuOGIo0O23r/qewTwRuOyI6ujQnPFpa2ZacYa7Xx
         l1hfO4vid7eVt7ws4qJKTkGffb+K2MZduPRxRpis4x0Qh7otWBQ0o7HjkVcZgR+AmjoO
         8K04zn0WmTi2HQAjEw+Qt3JmZEvqe3jYqWfdx31qMenF6Dqz8+Ce/mpgH8cBHXIV8wLA
         emRghWmB0+UAYctbX9DT0on05ydMXNw8IfNpcTJ5T32GSKLpYFxhJUf+8bG6v4SDOneV
         B/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=y01kJbrbcxAmMynqwHOhpegkdcYtXci9FUmRqGex7Vk=;
        b=4M2TY00wrgLNBdheTsvx8NOQI9g//7VR8DrQWW8kE9JQLBwP6sjtodmeq1irznqQnM
         nRxdnEv//K3VthSRxS3kRR75w7SpUnyje9djykwR54FfiSkuTdrOoQpkZXcr32qR8iXR
         cPEQwmkSRjm3oD6NxiVeTtQ9gBchsuEPBcIjPXLCWcSuLJB0l3ntAX9+2Ss3jqwwlJmY
         931yKZgy2gh1XsZY+/GeuBh/L97497Vncu9PxXGV39SNUXS6OXCuIAewIYxMfUOogoOx
         WIlK9N+3pzkRSH32b+nlFMcaydJnQjDBlL0yVmNGCa2ZXacE5vcXUf+KPWaOZPQeuvBS
         aVxw==
X-Gm-Message-State: AOAM533rbcSlbnfIcuEOU63H1Ull1uvhF6iOeEWIWXHd8uBkuVbQ4x6R
        nNYqqUujH34JW9QpYMJZVnktpt6ah+YE1QlekxoN8g==
X-Google-Smtp-Source: ABdhPJz4oJQbfPa+jyB8PwWlxFFv+uK2vA7h3V8F0P2qHSPcHtxfpVfHkTBak96qlDXOkT/dhxGoWYCfAiK/NnGx1HQ=
X-Received: by 2002:a05:6830:1dd2:b0:5a2:2d10:c3ba with SMTP id
 a18-20020a0568301dd200b005a22d10c3bamr8282177otj.41.1645535130874; Tue, 22
 Feb 2022 05:05:30 -0800 (PST)
MIME-Version: 1.0
References: <20220125084702.3636253-1-andrew@daynix.com> <1643183537.4001389-1-xuanzhuo@linux.alibaba.com>
 <CAOEp5OcwLiLZuVOAxx+pt6uztP-cGTgqsUSQj7N7HKTZgmyN3w@mail.gmail.com>
 <CABcq3pE43rYojwUCAmpW-FKv5=ABcS47B944Y-3kDqr-PeqLwQ@mail.gmail.com> <3ab523ac-0ab5-5011-5328-e119840e1c07@redhat.com>
In-Reply-To: <3ab523ac-0ab5-5011-5328-e119840e1c07@redhat.com>
From:   Andrew Melnichenko <andrew@daynix.com>
Date:   Tue, 22 Feb 2022 15:05:19 +0200
Message-ID: <CABcq3pG3c32b8uHdfNq2LkgCAo8hnOQcY-wQXEG58vPe4FBmUg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] TUN/VirtioNet USO features support.
To:     Jason Wang <jasowang@redhat.com>
Cc:     Yuri Benditovich <yuri.benditovich@daynix.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Yan Vugenfirer <yan@daynix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On Wed, Feb 9, 2022 at 7:41 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2022/2/8 =E4=B8=8B=E5=8D=889:09, Andrew Melnichenko =E5=86=99=
=E9=81=93:
> > Hi people,
> > Can you please review this series?
>
>
> Are there any performance number to demonstrate the difference?
>
> Thanks
>

Yeah, I've used udpgso_bench from Linux to test.
Here are some numbers:

Sending packets with size 10000

Without USO:
```
$ ./udpgso_bench_tx -4 -D 192.168.15.1 -s 10000 -S 1000
random: crng init done
random: 7 urandom warning(s) missed due to ratelimiting
udp tx:     36 MB/s     3863 calls/s   3863 msg/s
udp tx:     32 MB/s     3360 calls/s   3360 msg/s
udp tx:     31 MB/s     3340 calls/s   3340 msg/s
udp tx:     31 MB/s     3353 calls/s   3353 msg/s
udp tx:     32 MB/s     3359 calls/s   3359 msg/s
udp tx:     32 MB/s     3370 calls/s   3370 msg/s
```

With USO:
```
$ ./udpgso_bench_tx -4 -D 192.168.15.1 -s 10000 -S 1000
random: crng init done
random: 7 urandom warning(s) missed due to ratelimiting
udp tx:    120 MB/s    12596 calls/s  12596 msg/s
udp tx:    122 MB/s    12885 calls/s  12885 msg/s
udp tx:    120 MB/s    12667 calls/s  12667 msg/s
udp tx:    123 MB/s    12969 calls/s  12969 msg/s
udp tx:    116 MB/s    12232 calls/s  12232 msg/s
udp tx:    108 MB/s    11389 calls/s  11389 msg/s
```


>
> >
> > On Wed, Jan 26, 2022 at 10:32 AM Yuri Benditovich
> > <yuri.benditovich@daynix.com> wrote:
> >> On Wed, Jan 26, 2022 at 9:54 AM Xuan Zhuo <xuanzhuo@linux.alibaba.com>=
 wrote:
> >>> On Tue, 25 Jan 2022 10:46:57 +0200, Andrew Melnychenko <andrew@daynix=
.com> wrote:
> >>>> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> >>>> Technically they enable NETIF_F_GSO_UDP_L4
> >>>> (and only if USO4 & USO6 are set simultaneously).
> >>>> It allows to transmission of large UDP packets.
> >>>>
> >>>> Different features USO4 and USO6 are required for qemu where Windows=
 guests can
> >>>> enable disable USO receives for IPv4 and IPv6 separately.
> >>>> On the other side, Linux can't really differentiate USO4 and USO6, f=
or now.
> >>>> For now, to enable USO for TUN it requires enabling USO4 and USO6 to=
gether.
> >>>> In the future, there would be a mechanism to control UDP_L4 GSO sepa=
rately.
> >>>>
> >>>> Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
> >>>>
> >>>> New types for VirtioNet already on mailing:
> >>>> https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010=
.html
> >>> Seems like this hasn't been upvoted yet.
> >>>
> >>>          https://github.com/oasis-tcs/virtio-spec#use-of-github-issue=
s
> >> Yes, correct. This is a reason why this series of patches is RFC.
> >>
> >>> Thanks.
> >>>
> >>>> Also, there is a known issue with transmitting packages between two =
guests.
> >>>> Without hacks with skb's GSO - packages are still segmented on the h=
ost's postrouting.
> >>>>
> >>>> Andrew Melnychenko (5):
> >>>>    uapi/linux/if_tun.h: Added new ioctl for tun/tap.
> >>>>    driver/net/tun: Added features for USO.
> >>>>    uapi/linux/virtio_net.h: Added USO types.
> >>>>    linux/virtio_net.h: Added Support for GSO_UDP_L4 offload.
> >>>>    drivers/net/virtio_net.c: Added USO support.
> >>>>
> >>>>   drivers/net/tap.c               | 18 ++++++++++++++++--
> >>>>   drivers/net/tun.c               | 15 ++++++++++++++-
> >>>>   drivers/net/virtio_net.c        | 22 ++++++++++++++++++----
> >>>>   include/linux/virtio_net.h      | 11 +++++++++++
> >>>>   include/uapi/linux/if_tun.h     |  3 +++
> >>>>   include/uapi/linux/virtio_net.h |  4 ++++
> >>>>   6 files changed, 66 insertions(+), 7 deletions(-)
> >>>>
> >>>> --
> >>>> 2.34.1
> >>>>
> >>>> _______________________________________________
> >>>> Virtualization mailing list
> >>>> Virtualization@lists.linux-foundation.org
> >>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>
