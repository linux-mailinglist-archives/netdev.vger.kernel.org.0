Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7838749C4C4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238066AbiAZHyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:54:13 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:33604 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbiAZHyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:54:10 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V2ucAWv_1643183646;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2ucAWv_1643183646)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:54:07 +0800
Message-Id: <1643183537.4001389-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH 0/5] TUN/VirtioNet USO features support.
Date:   Wed, 26 Jan 2022 15:52:17 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     yan@daynix.com, yuri.benditovich@daynix.com, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com, jasowang@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
In-Reply-To: <20220125084702.3636253-1-andrew@daynix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 10:46:57 +0200, Andrew Melnychenko <andrew@daynix.com> wrote:
> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> Technically they enable NETIF_F_GSO_UDP_L4
> (and only if USO4 & USO6 are set simultaneously).
> It allows to transmission of large UDP packets.
>
> Different features USO4 and USO6 are required for qemu where Windows guests can
> enable disable USO receives for IPv4 and IPv6 separately.
> On the other side, Linux can't really differentiate USO4 and USO6, for now.
> For now, to enable USO for TUN it requires enabling USO4 and USO6 together.
> In the future, there would be a mechanism to control UDP_L4 GSO separately.
>
> Test it WIP Qemu https://github.com/daynix/qemu/tree/Dev_USOv2
>
> New types for VirtioNet already on mailing:
> https://lists.oasis-open.org/archives/virtio-comment/202110/msg00010.html

Seems like this hasn't been upvoted yet.

	https://github.com/oasis-tcs/virtio-spec#use-of-github-issues

Thanks.

>
> Also, there is a known issue with transmitting packages between two guests.
> Without hacks with skb's GSO - packages are still segmented on the host's postrouting.
>
> Andrew Melnychenko (5):
>   uapi/linux/if_tun.h: Added new ioctl for tun/tap.
>   driver/net/tun: Added features for USO.
>   uapi/linux/virtio_net.h: Added USO types.
>   linux/virtio_net.h: Added Support for GSO_UDP_L4 offload.
>   drivers/net/virtio_net.c: Added USO support.
>
>  drivers/net/tap.c               | 18 ++++++++++++++++--
>  drivers/net/tun.c               | 15 ++++++++++++++-
>  drivers/net/virtio_net.c        | 22 ++++++++++++++++++----
>  include/linux/virtio_net.h      | 11 +++++++++++
>  include/uapi/linux/if_tun.h     |  3 +++
>  include/uapi/linux/virtio_net.h |  4 ++++
>  6 files changed, 66 insertions(+), 7 deletions(-)
>
> --
> 2.34.1
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
