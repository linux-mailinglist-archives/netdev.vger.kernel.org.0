Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C158245231D
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344006AbhKPBTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:19:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233786AbhKPBQU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 20:16:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 438CA60F6E;
        Tue, 16 Nov 2021 01:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637025200;
        bh=EY96g0UCuL5Xvi/3eOGLMAuCu+ebe0mgcopCcRBtgiM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hoMDYf1u4QigiY2urIxEzheI0nj7DiOd4dy/gXX3z7CUGjYmyy8B2L4RLmjHnUQZy
         PJSRxjRU+T++rIDVfsI6Cv7FsnP9mhp/mUFnTxy3tiSrH7hNFxpgGxN7G4lNuwiFES
         CT05qEtt+4vzjTE7CL4zxs4j25WH6WXAkYFehGiob1ePzioXcuYpzwYmbnY/Hg9jkb
         2DyPg7ptgOJ8oL9mdgTjnoHRq1xh5Lj8j1m0TUvdm9/F/ZkI7pRCeCuVGmzri3EfRS
         GX7ymFZZk/6DWEHTIddLU8rZXX7a2j06t/1GxbyByQd+QRUI4ZtbXEMMiGBH7hd78V
         CYRrQFaxOzrCw==
Date:   Mon, 15 Nov 2021 17:13:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Willem de Bruijn <willemb@google.com>, netdev@vger.kernel.org,
        Florian Schmidt <flosch@nutanix.com>,
        Thilak Raj Surendra Babu <thilakraj.sb@nutanix.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: virtio_net_hdr_to_skb: count transport header
 in UFO
Message-ID: <20211115171319.7d2e9f40@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211115151618.126875-1-jonathan.davies@nutanix.com>
References: <20211115151618.126875-1-jonathan.davies@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 15:16:17 +0000 Jonathan Davies wrote:
> +		if (gso_type & SKB_GSO_UDP && skb->len - p_off + thlen > gso_size ||

Compilers don't like mixing && and || without bracketing, and will warn
here, at least with W=1. Please add explicit brackets.
