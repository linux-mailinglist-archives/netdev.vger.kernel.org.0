Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA6A513655F
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgAJCdk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:33:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730823AbgAJCdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:33:40 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADA6615736417;
        Thu,  9 Jan 2020 18:33:39 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:33:39 -0800 (PST)
Message-Id: <20200109.183339.173768060466817001.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, adelva@google.com,
        willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200105132120.92370-1-mst@redhat.com>
References: <20200105132120.92370-1-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:33:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 5 Jan 2020 08:22:07 -0500

> The only way for guest to control offloads (as enabled by
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
> through CTRL_VQ. So it does not make sense to
> acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
> VIRTIO_NET_F_CTRL_VQ.
> 
> The spec does not outlaw devices with such a configuration, so we have
> to support it. Simply clear VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> Note that Linux is still crashing if it tries to
> change the offloads when there's no control vq.
> That needs to be fixed by another patch.
> 
> Reported-by: Alistair Delva <adelva@google.com>
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Same patch as v1 but update documentation so it's clear it's not
> enough to fix the crash.

Where are we with this patch?  There seems to still be some unresolved
discussion about how we should actually handle this case.

Thanks.
