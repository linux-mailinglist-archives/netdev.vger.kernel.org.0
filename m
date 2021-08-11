Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9FB63E9ACF
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhHKWSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:18:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhHKWST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFDA560462;
        Wed, 11 Aug 2021 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628720275;
        bh=wzM7Bor7mBQbvZigYD8y3YZZKI+s6v9JGuLfCpbEJpo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Px3t8aLqDtz9L7JFrpNsOVpFi9Hh4lfRvf0P10njbVJkJvcIr6KsDT2e0FUee5+d2
         xW8NTZoiUmXeiRxPYfrZINov8ZLPotp0aM1VJ2KnKSCO8iYwrvHCKq9z1Ed4dO9rx6
         fQHn6PwtN9Ip4FbXmJQ80VOFs+hK9cEhB3+9USRBHZ3sv0J7D3R4zWWXtmcHVP24pH
         F9/h3BiSp7ExdxMwSXRKAhBL6Rxzx3nu9vBkT51vAfZqKX+Om4Gp/8T1LjAujhfGwY
         Q4UzIsLLDmn4c97dVDKF/QuOy/2Wnvq6vOCgXK8Iqhjp12JxtjGRZhhY6Wb/KjIQYH
         J/s/4R/GUahCw==
Date:   Wed, 11 Aug 2021 15:17:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivan@prestigetransportation.com,
        xiangxia.m.yue@gmail.com, willemb@google.com, edumazet@google.com
Subject: Re: [RFC PATCH] virtio-net: use NETIF_F_GRO_HW instead of
 NETIF_F_LRO
Message-ID: <20210811151754.030a22a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210811081623.9832-1-jasowang@redhat.com>
References: <20210811081623.9832-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Aug 2021 16:16:23 +0800 Jason Wang wrote:
> Try to fix this by using NETIF_F_GRO_HW instead so we're not
> guaranteed to be re-segmented as original. 

This sentence may need rephrasing.

> Or we may want a new netdev
> feature like RX_GSO since the guest offloads for virtio-net is
> actually to receive GSO packet.
> 
> Or we can try not advertise LRO is control guest offloads is not
> enabled. This solves the warning but will still slow down the traffic.

IMO gro-hw fits pretty well, patch looks good.
