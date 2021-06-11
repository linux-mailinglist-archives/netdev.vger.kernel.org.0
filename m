Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FD73A4A74
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 23:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231172AbhFKVCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 17:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:37584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230040AbhFKVCM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 17:02:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C1690613CD;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623445213;
        bh=BFn579BHo+V6RuRMsasFONBDcF/mkZeJBCnimQQAz84=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o5goQld7cEvRqWyuOYLz7Dn2f0Ty4jMMh+mWSQ7w3Knnr62pmAnIxhTAyvWPlSNx5
         0kDtK2nyKwYbZ3jZcYlhhrOE/MbKanhQtzObL7FX1A5XrsROYy68pJNM4tnWoqFeR/
         z/tmTbvVqCUZiU0+y/hbAkV2KCLLhlfEKva1NAA7H9sic1gK+MEQbXSL/8pSOEggVi
         RNImNX9lDRWuw5IGMXlizgdwUOAuvY8qzv4FC//rEGKYOxsWgwouChkO8h/eviNe4T
         hqflJczogl9mkZFZIFY6GEotdEWQedEPifgqEuIcJazbSdOldCQNoQSS2H/tXq8X/j
         mD480OKzj+u3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B531760D07;
        Fri, 11 Jun 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v11 00/18] virtio/vsock: introduce SOCK_SEQPACKET support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162344521373.30951.11000282953901961373.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Jun 2021 21:00:13 +0000
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org,
        andraprs@amazon.com, nslusarek@gmx.net, colin.king@canonical.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Jun 2021 14:07:40 +0300 you wrote:
> This patchset implements support of SOCK_SEQPACKET for virtio
> transport.
> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> do it, new bit for field 'flags' was added: SEQ_EOR. This bit is
> set to 1 in last RW packet of message.
> 	Now as  packets of one socket are not reordered neither on vsock
> nor on vhost transport layers, such bit allows to restore original
> message on receiver's side. If user's buffer is smaller than message
> length, when all out of size data is dropped.
> 	Maximum length of datagram is limited by 'peer_buf_alloc' value.
> 	Implementation also supports 'MSG_TRUNC' flags.
> 	Tests also implemented.
> 
> [...]

Here is the summary with links:
  - [v11,01/18] af_vsock: update functions for connectible socket
    https://git.kernel.org/netdev/net-next/c/a9e29e5511b9
  - [v11,02/18] af_vsock: separate wait data loop
    https://git.kernel.org/netdev/net-next/c/b3f7fd54881b
  - [v11,03/18] af_vsock: separate receive data loop
    https://git.kernel.org/netdev/net-next/c/19c1b90e1979
  - [v11,04/18] af_vsock: implement SEQPACKET receive loop
    https://git.kernel.org/netdev/net-next/c/9942c192b256
  - [v11,05/18] af_vsock: implement send logic for SEQPACKET
    https://git.kernel.org/netdev/net-next/c/fbe70c480796
  - [v11,06/18] af_vsock: rest of SEQPACKET support
    https://git.kernel.org/netdev/net-next/c/0798e78b102b
  - [v11,07/18] af_vsock: update comments for stream sockets
    https://git.kernel.org/netdev/net-next/c/8cb48554ad82
  - [v11,08/18] virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
    https://git.kernel.org/netdev/net-next/c/b93f8877c1f2
  - [v11,09/18] virtio/vsock: simplify credit update function API
    https://git.kernel.org/netdev/net-next/c/c10844c59799
  - [v11,10/18] virtio/vsock: defines and constants for SEQPACKET
    https://git.kernel.org/netdev/net-next/c/f07b2a5b04d4
  - [v11,11/18] virtio/vsock: dequeue callback for SOCK_SEQPACKET
    https://git.kernel.org/netdev/net-next/c/44931195a541
  - [v11,12/18] virtio/vsock: add SEQPACKET receive logic
    https://git.kernel.org/netdev/net-next/c/e4b1ef152f53
  - [v11,13/18] virtio/vsock: rest of SOCK_SEQPACKET support
    https://git.kernel.org/netdev/net-next/c/9ac841f5e9f2
  - [v11,14/18] virtio/vsock: enable SEQPACKET for transport
    https://git.kernel.org/netdev/net-next/c/53efbba12cc7
  - [v11,15/18] vhost/vsock: support SEQPACKET for transport
    https://git.kernel.org/netdev/net-next/c/ced7b713711f
  - [v11,16/18] vsock/loopback: enable SEQPACKET for transport
    https://git.kernel.org/netdev/net-next/c/6e90a57795aa
  - [v11,17/18] vsock_test: add SOCK_SEQPACKET tests
    https://git.kernel.org/netdev/net-next/c/41b792d7a86d
  - [v11,18/18] virtio/vsock: update trace event for SEQPACKET
    https://git.kernel.org/netdev/net-next/c/184039eefeae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


