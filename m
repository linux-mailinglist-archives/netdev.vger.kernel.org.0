Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D1B2EC716
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 00:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbhAFXws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 18:52:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbhAFXws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 18:52:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 455EB2313E;
        Wed,  6 Jan 2021 23:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609977127;
        bh=jqFd6ElbrRui+hOtHEhlykrx436lT8EmkWT/nXg15Yg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OWyfMURa0uRj3/7IMp4hX1x5SZ2OOan24kF9e3rK/9HqCLZnoGvyArqn884VJn3nO
         Ly2a3lI9zf7st7F+ZEWrqL/XUuZBOyvgqqgT1JHwe2SpLs9Jxr5lx3GaoSi98lwJOy
         ejLFE25EC/1EkLVJGyVcxvucsBDstpRrC0pFZUzKLBKljMpiDCO08rofcSGEQGUBQ2
         h3N5sudEHLMYroaRb0R3s/tK4Mo7QezNx1LP2ir4lhHujPy7y7Q5nPmWrQg9bUqjfd
         JuUfV9TVdoU3Y0b8ZXbSWbk319t1On0KsVLgn9jIb2l3hONUNrHnnpJvqSJu3BSW3W
         pOamW5FhJd3vg==
Date:   Wed, 6 Jan 2021 15:52:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aya Levin <ayal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Axtens <dja@axtens.net>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH net V2] net: ipv6: Validate GSO SKB before finish IPv6
 processing
Message-ID: <20210106155206.6f872e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1609854201-30143-1-git-send-email-ayal@nvidia.com>
References: <1609854201-30143-1-git-send-email-ayal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Jan 2021 15:43:21 +0200 Aya Levin wrote:
> There are cases where GSO segment's length exceeds the egress MTU.

Please name same for posterity.

Please widen the CC list.

> If so:
>  - Consume the SKB and its segments.
>  - Issue an ICMP packet with 'Packet Too Big' message containing the
>    MTU, allowing the source host to reduce its Path MTU appropriately.
> 
> Note: These cases are handled in the same manner in IPv4 output finish.
> This patch aligns the behavior of IPv6 and the one of IPv4.
>
> Fixes: 9e50849054a4 ("netfilter: ipv6: move POSTROUTING invocation before fragmentation")

Not sure if this commit actually adds the problem or just moves the
problematic snippet around. But probably doesn't matter that much for
10+ years old code.

> Signed-off-by: Aya Levin <ayal@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

The code itself looks reasonable AFAICT.
