Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C392E6B42
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbgL1XBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 18:01:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729738AbgL1XAf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 18:00:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 631AF2222A;
        Mon, 28 Dec 2020 22:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609196394;
        bh=Cf32QYAlzKXTR+qaNpfnf4jEJkVABxe90olm7N+G/YE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxqUoGbnPwGLZoHoFxs+Wib7LWix1rsMljN29XcM9K8P3tpyQrfOmFi6sqyxa/rIk
         QHCx4Xp1fXlRzEhVuZKF7ta7mgUjq6+T+egVjL8x9NxU7PO5iovaP5K/B29EgknB1q
         GYOhPNN7sTXLZT8+voU7e/a6ibVczo0mCKc/8wR/Hc9wknrunmE4HX5Hu8HE675kxu
         z4A+uUebEsc2n+0ZsrZzCVt+FIaxCJFqK4CIl3JCGXkMKl+nhulY2ApV/mSUmM9hJ2
         8L6tfpQMsHx56byKsQUzzKqWrCV+zZ68b4NzPaFYzmXHxnTTniQN6Ag71tDjSNh3Te
         vUH7kTx5nGNLw==
Date:   Mon, 28 Dec 2020 14:59:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
Message-ID: <20201228145953.08673c8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
        <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Dec 2020 11:22:32 -0500 Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Add optional PTP hardware timestamp offload for virtio-net.
> 
> Accurate RTT measurement requires timestamps close to the wire.
> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> virtio-net header is expanded with room for a timestamp. A host may
> pass receive timestamps for all or some packets. A timestamp is valid
> if non-zero.
> 
> The timestamp straddles (virtual) hardware domains. Like PTP, use
> international atomic time (CLOCK_TAI) as global clock base. It is
> guest responsibility to sync with host, e.g., through kvm-clock.

Would this not be confusing to some user space SW to have a NIC with 
no PHC deliver HW stamps?

I'd CC Richard on this, unless you already discussed with him offline.
