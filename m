Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7351C1FDA09
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgFRADF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:03:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbgFRADF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 20:03:05 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA19321556;
        Thu, 18 Jun 2020 00:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592438584;
        bh=k0lDJz0QpUzIU87rE/Ev3aFAs+zQM4rYyN98+nDPbm0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ec4ORowQoCzWclk3oXnBTRuURufcx6EJQc7QpmEBux5umZzTnc6t7vPqS21vAGDGp
         NXKjn4H8GU22tSEuLqwpxTKyD1x2jCBHWlKwY3jJWczeIEZB/QckqqOriNJUMh0Fnk
         vBHMXP23gb/cEtP+6853d8MjnckhVHjwGXLlidN0=
Date:   Wed, 17 Jun 2020 17:03:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Subject: Re: [PATCH net-next 4/5] net: tso: cache transport header length
Message-ID: <20200617170303.4fb4d0b1@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617184819.49986-5-edumazet@google.com>
References: <20200617184819.49986-1-edumazet@google.com>
        <20200617184819.49986-5-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 11:48:18 -0700 Eric Dumazet wrote:
> Add tlen field into struct tso_t, and change tso_start()
> to return skb_transport_offset(skb) + tso->tlen
> 
> This removes from callers the need to use tcp_hdrlen(skb) and
> will ease UDP segmentation offload addition.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>

drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c: In function otx2_sq_append_tso:
drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c:631:6: warning: hdr_len is used uninitialized in this function [-Wuninitialized]
 631 |  if (otx2_dma_map_tso_skb(pfvf, sq, skb, first_sqe, hdr_len)) {
     |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
