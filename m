Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981832C4A20
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732491AbgKYVeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731950AbgKYVeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:34:46 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA06206E0;
        Wed, 25 Nov 2020 21:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606340086;
        bh=3lVrLTTsCdkal7E8HZY0NZKVZlVawWDZoX8smDNr+OU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=itRkywL78OBNGH52rhDRkPoFkhM3SRjKqcUj37jk1l+Ecdj83u88Pt4/wAxr0+wq6
         hu4Ps/mY1fYVxNvdzw8GiZgYjq4BngFEhtGk9scnsLM7qmAfjQ6Je3pNpYd8RrAaVz
         es3lIG3e/2qvKxpWP7vEm848nIIQvEGFFMCZM5LM=
Date:   Wed, 25 Nov 2020 13:34:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <nikolay@nvidia.com>, <roopa@nvidia.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] bridge: mrp: Implement LC mode for MRP
Message-ID: <20201125133444.22f09660@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124082525.273820-1-horatiu.vultur@microchip.com>
References: <20201124082525.273820-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 09:25:25 +0100 Horatiu Vultur wrote:
> Extend MRP to support LC mode(link check) for the interconnect port.
> This applies only to the interconnect ring.
> 
> Opposite to RC mode(ring check) the LC mode is using CFM frames to
> detect when the link goes up or down and based on that the userspace
> will need to react.
> One advantage of the LC mode over RC mode is that there will be fewer
> frames in the normal rings. Because RC mode generates InTest on all
> ports while LC mode sends CFM frame only on the interconnect port.
> 
> All 4 nodes part of the interconnect ring needs to have the same mode.
> And it is not possible to have running LC and RC mode at the same time
> on a node.
> 
> Whenever the MIM starts it needs to detect the status of the other 3
> nodes in the interconnect ring so it would send a frame called
> InLinkStatus, on which the clients needs to reply with their link
> status.
> 
> This patch adds InLinkStatus frame type and extends existing rules on
> how to forward this frame.
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Applied, thanks!
