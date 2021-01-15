Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6DC52F7626
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 11:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbhAOKA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 05:00:27 -0500
Received: from forward103p.mail.yandex.net ([77.88.28.106]:43402 "EHLO
        forward103p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730699AbhAOKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 05:00:19 -0500
Received: from iva7-b2551a6f14a8.qloud-c.yandex.net (iva7-b2551a6f14a8.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f9c:0:640:b255:1a6f])
        by forward103p.mail.yandex.net (Yandex) with ESMTP id 08A5518C0FCB;
        Fri, 15 Jan 2021 12:59:37 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by iva7-b2551a6f14a8.qloud-c.yandex.net (mxback/Yandex) with ESMTP id C4vTl272uK-xaDuFG0R;
        Fri, 15 Jan 2021 12:59:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1610704776;
        bh=3nwl8ujtSIs9eCC8kSIL1MZLqNVqrBzoldVBFcpqhp0=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=nVmCPkOAFYrbTW+xC0K4x/0O+6/NgZ2btTTQVzBwuLuM2Uskw/Vlib78QBjHkon+E
         1d5mx5gP218R+7m5IYf41gc1b7WjW86ozI9hLHLayy6mU7gM/rKCL98xuXz0tfYmwQ
         eOsGMxjAI3/cVxaFil4nz2TDBCfWxLk35UvaP/zQ=
Authentication-Results: iva7-b2551a6f14a8.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id mW8S2PjIqj-xZIi97rg;
        Fri, 15 Jan 2021 12:59:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [RFC PATCH v2 00/13] virtio/vsock: introduce SOCK_SEQPACKET
 support.
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        oxffffaa@gmail.com
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <2fd6fc75-c534-7f70-c116-50b1c804b594@yandex.ru>
Date:   Fri, 15 Jan 2021 12:59:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

15.01.2021 08:35, Arseny Krasnov пишет:
> 	This patchset impelements support of SOCK_SEQPACKET for virtio
> transport.
> 	As SOCK_SEQPACKET guarantees to save record boundaries, so to
> do it, new packet operation was added: it marks start of record (with
> record length in header), such packet doesn't carry any data.  To send
> record, packet with start marker is sent first, then all data is sent
> as usual 'RW' packets. On receiver's side, length of record is known
> from packet with start record marker. Now as  packets of one socket
> are not reordered neither on vsock nor on vhost transport layers, such
> marker allows to restore original record on receiver's side. If user's
> buffer is smaller that

than


>   record length, when

then


>   v1 -> v2:
>   - patches reordered: af_vsock.c changes now before virtio vsock
>   - patches reorganized: more small patches, where +/- are not mixed

If you did this because I asked, then this
is not what I asked. :)
You can't just add some static func in a
separate patch, as it will just produce the
compilation warning of an unused function.
I only asked to separate the refactoring from
the new code. I.e. if you move some code
block to a separate function, you shouldn't
split that into 2 patches, one that adds a
code block and another one that removes it.
It should be in one patch, so that it is clear
what was moved, and no new warnings are
introduced.
What I asked to separate, is the old code
moves with the new code additions. Such
things can definitely go in a separate patches.

NB: just trying to help, as I already played
with your code a bit. I am neither a
maintainer nor a contributor here, but
it would be cool to have the vsock SEQPACKET
support.

