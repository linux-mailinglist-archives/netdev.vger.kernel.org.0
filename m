Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAF940F717
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 14:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243248AbhIQMGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 08:06:22 -0400
Received: from kylie.crudebyte.com ([5.189.157.229]:39771 "EHLO
        kylie.crudebyte.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243166AbhIQMGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 08:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=hN7PXduh+4F9HCcwImkhXok2Qq7HXWLR5dTfGzrGPic=; b=oVnW+udNM9sIU2SCDBSDw6wzV8
        9tGH4VZa+ofwuYMl/zl7RymYxYT3hvoY91w0Wd8rdYrho4hkO65lqeurgG5ZQMnaHeJVeG7MtpE2d
        Wme3ZZENQvQEdqE+pp+MOC4/wDsMizai5QJJ0Hje+/41j/pMSZHLtuVscGXgrT7Dc46g3PysrhGHY
        +cRf8qX5HztCLbN+3wiCe9mVUd3xj02aoZnfXkLj7SfpRL9S2WS2evJMhaDmTItZ5CtsOY++z7MSY
        P3nSYD9Z5IeUZb95VF7Ys691uwTVVt7ZROt/wz2OLcMqA+Rp71i3h8xjEnQ7sovQkpWyR2CXL8MyO
        PDDK59atOsXRyquRnTCJR6LbOTaey64n/MMD/d69JdrBfF961gqUMcCgmqtmRUwwLWukAOpZiyDXh
        8AmPSkBsbipY78c8BCvWUppVKNYcdpYCNGH1Z2TIjgkl8fxEZtClmpZtIbxq73qK4qPm9XAH+w3gu
        2P/gIFyXacED12bprXGO0rRZ8fqDqRJPeueNQ8/J8/4LuJt9iffNEb16K0cxoACz5T4SRTt5uRl7D
        a0bgPAxsFarI8ZT+dwU4sHzbyeTmOvNXKKHaqsNrey13Fw9uXk5DNZ/BHTgDlTxuBNXrCa0byrjeN
        24QFvY9T1ayEDrpju46bqwzA+EoUsEQ5IJ0VQcK1M=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/7] net/9p: remove msize limit in virtio transport
Date:   Fri, 17 Sep 2021 14:04:50 +0200
Message-ID: <2915494.F4Y4y7BOdD@silver>
In-Reply-To: <20210916190908.19824be5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1631816768.git.linux_oss@crudebyte.com> <20210916190908.19824be5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Freitag, 17. September 2021 04:09:08 CEST Jakub Kicinski wrote:
> On Thu, 16 Sep 2021 20:26:08 +0200 Christian Schoenebeck wrote:
> > This is an initial draft for getting rid of the current 500k 'msize'
> > limitation in the 9p virtio transport, which is currently a bottleneck for
> > performance of Linux 9p mounts.
> > 
> > This is a follow-up of the following series and discussion:
> > https://lore.kernel.org/all/28bb651ae0349a7d57e8ddc92c1bd5e62924a912.16307
> > 70829.git.linux_oss@crudebyte.com/T/#eb647d0c013616cee3eb8ba9d87da7d8b1f47
> > 6f37
> > 
> > Known limitation: With this series applied I can run
> > 
> >   QEMU host <-> 9P virtio <-> Linux guest
> > 
> > with up to 3 MB msize. If I try to run it with 4 MB it seems to hit some
> > 
> > limitation on QEMU side:
> >   qemu-system-x86_64: virtio: too many write descriptors in indirect table
> > 
> > I haven't looked into this issue yet.
> > 
> > Testing and feedback appreciated!
> 
> nit - please run ./scripts/kernel-doc -none on files you're changing.
> There seems to be a handful of warnings like this added by the series:
> 
> net/9p/trans_virtio.c:155: warning: This comment starts with '/**', but
> isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Sure, I'll take care about that in v2. Thanks!

Best regards,
Christian Schoenebeck


