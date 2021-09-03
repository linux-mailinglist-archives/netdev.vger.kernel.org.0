Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFB4007D6
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350341AbhICWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:18:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:45014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234285AbhICWSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 18:18:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20E7D61056;
        Fri,  3 Sep 2021 22:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630707452;
        bh=X4y0f2yJvHJHj3wVFotoUayliSDgcX5Ub4uOXuNYiDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Du+WrwD5eMYuCCEYYiFWHngZxZmpTA7kmKZtOb4LZ7FeGjI3pmz3Rr2EOh4hPcMW7
         AdmEqGwe9KfyXPwtPYsQDEeTMnLEnI2y0wO/+utnk6HrWYUugDG1Xf7qu5xxAnR+Wd
         aEPjA5RYD3I1cKkj+7nQ+nUgxuXkhM5vRkGHuAu8KHvvwG3ppXlsF++/hbBAZSG2cX
         TP6HP/9KBvUEsOq00Ottgf9OIcJi22UQYt92TYo2jpPC67hXoTkQe+5g4mqumxS8lT
         OHeru3PQ1+yDzfAlQFkZv5diCXpzTozy1zuUxp3oFJLxzrzmKunschhzdpLItLfcVR
         rgIzoto6AXE6Q==
Date:   Fri, 3 Sep 2021 15:17:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: Re: [PATCH net-next v5 0/6] virtio/vsock: introduce MSG_EOR flag
 for SEQPACKET
Message-ID: <20210903151731.427ce359@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
References: <20210903123016.3272800-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Sep 2021 15:30:13 +0300 Arseny Krasnov wrote:
> 	This patchset implements support of MSG_EOR bit for SEQPACKET
> AF_VSOCK sockets over virtio transport.
> 	First we need to define 'messages' and 'records' like this:
> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
> etc. It has fixed maximum length, and it bounds are visible using
> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
> Current implementation based on message definition above.
> 	Record has unlimited length, it consists of multiple message,
> and bounds of record are visible via MSG_EOR flag returned from
> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
> receiver will see MSG_EOR when corresponding message will be processed.
> 	Idea of patchset comes from POSIX: it says that SEQPACKET
> supports record boundaries which are visible for receiver using
> MSG_EOR bit. So, it looks like MSG_EOR is enough thing for SEQPACKET
> and we don't need to maintain boundaries of corresponding send -
> receive system calls. But, for 'sendXXX()' and 'recXXX()' POSIX says,
> that all these calls operates with messages, e.g. 'sendXXX()' sends
> message, while 'recXXX()' reads messages and for SEQPACKET, 'recXXX()'
> must read one entire message from socket, dropping all out of size
> bytes. Thus, both message boundaries and MSG_EOR bit must be supported
> to follow POSIX rules.
> 	To support MSG_EOR new bit was added along with existing
> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
> is used to mark 'MSG_EOR' bit passed from userspace.
> 	This patchset includes simple test for MSG_EOR.

Assuming you want this merged to net-next:


# Form letter - net-next is closed

We have already sent the networking pull request for 5.15 
and therefore net-next is closed for new drivers, features, 
code refactoring and optimizations. We are currently accepting 
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
