Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3A6488CD6
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiAIWVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:21:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34728 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235130AbiAIWVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:21:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5503F60F9D;
        Sun,  9 Jan 2022 22:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3792FC36AED;
        Sun,  9 Jan 2022 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766906;
        bh=fTxXZcnjYfj7uywni7veFgQiu0t+gG2YA3LFRYOnqwI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oFg5mQmenzWbjgUs6t87cFHabOG8iZDH8W1LZkQhGkkp2SaPVzWaIkxr9iaBrAhP+
         5AIZQyzlcoTBMdc6OQznkT1N0MHA5XGXYIFZQAgXmBNDV2T1nbxKAZsJRZmatr4/4k
         WGKpsFlzU/mA9BM3sc4k8/pw9k+DV2mP49IYn5iVmq6BQwFKL8jSzEIiZPTgOH6cwu
         KypzrU7wQcXoeu+5W1R57MyXYgthUEtVQhUy+nlYPjjxEFdll3pk/9+GFFUTkXpG0o
         Wdnnv9tWkCSA0tnxaraaf+PSqekqHkIH8F8oQJFGGecO/NzVZOVwTk93oAj/mFzIB7
         zMozLQguB55Qg==
Date:   Sun, 9 Jan 2022 14:21:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        jasowang@redhat.com, mst@redhat.com, yan@daynix.com,
        yuri.benditovich@daynix.com
Subject: Re: [PATCH 1/4] drivers/net/virtio_net: Fixed padded vheader to use
 v1 with hash.
Message-ID: <20220109142145.54447b38@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109210659.2866740-2-andrew@daynix.com>
References: <20220109210659.2866740-1-andrew@daynix.com>
        <20220109210659.2866740-2-andrew@daynix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  9 Jan 2022 23:06:56 +0200 Andrew Melnychenko wrote:
> The header v1 provides additional info about RSS.
> Added changes to computing proper header length.
> In the next patches, the header may contain RSS hash info
> for the hash population.
>=20
> Signed-off-by: Andrew Melnychenko <andrew@daynix.com>

You can't break build in between patches:

drivers/net/virtio_net.c: In function =E2=80=98page_to_skb=E2=80=99:
drivers/net/virtio_net.c:398:15: error: =E2=80=98struct virtnet_info=E2=80=
=99 has no member named =E2=80=98has_rss_hash_report=E2=80=99
  398 |         if (vi->has_rss_hash_report)
      |               ^~
