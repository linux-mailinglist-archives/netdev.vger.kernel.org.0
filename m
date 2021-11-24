Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699BE45B2F8
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhKXELC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:32784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232238AbhKXELB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:11:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ECCB6604DC;
        Wed, 24 Nov 2021 04:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637726872;
        bh=gimb9YELOGsigTc06I0EWXYMHyUnxqGxrQ5Y/uQLVjM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FZe8lz5M2O+cbKKUUM4VZh3vcZB37wQjkmGcfOpd/Xq0LjAf+zjh9+ljWfEC92E9a
         Li0aNNXzHTS0WGZc3brzgCVrP0TT62MADR0NH4Ii4H81AUM73zP8ufvNLS44oWNT7l
         YdQ1rhDTbLYmhHdbr+HVtMV+nZwN2plzepckJ3WGmjZ1A0NWttDypYYiwDfSTgqS8v
         pPFHVcbFsigS69CjFif0gvA+pUkS28F0LiWLxoVmIb4fL1cZrJNW3HNuog1+3ZFblM
         SV8r5GB6GZLdI7rDEGqxYnIl9+svotOr5qpe7cr/YJgHhqv4gtYJKUXL6j9jAAPxd8
         yQXbN2lc7Kx6g==
Date:   Tue, 23 Nov 2021 20:07:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
Subject: Re: [PATCH net] net: stmmac: Disable Tx queues when reconfiguring
 the interface
Message-ID: <20211123200751.3de326e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
References: <20211123185448.335924-1-yannick.vignon@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 19:54:48 +0100 Yannick Vignon wrote:
> From: Yannick Vignon <yannick.vignon@nxp.com>
> 
> The Tx queues were not disabled in cases where the driver needed to stop
> the interface to apply a new configuration. This could result in a kernel
> panic when doing any of the 3 following actions:
> * reconfiguring the number of queues (ethtool -L)
> * reconfiguring the size of the ring buffers (ethtool -G)
> * installing/removing an XDP program (ip l set dev ethX xdp)
> 
> Prevent the panic by making sure netif_tx_disable is called when stopping
> an interface.
> 
> Without this patch, the following kernel panic can be observed when loading
> an XDP program:
> 
> Unable to handle kernel paging request at virtual address ffff80001238d040
> [....]
>  Call trace:
>   dwmac4_set_addr+0x8/0x10
>   dev_hard_start_xmit+0xe4/0x1ac
>   sch_direct_xmit+0xe8/0x39c
>   __dev_queue_xmit+0x3ec/0xaf0
>   dev_queue_xmit+0x14/0x20
> [...]
> [ end trace 0000000000000002 ]---
> 
> Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>

Fixes tag: Fixes: 78cb988d36b6 ("net: stmmac: Add initial XDP support")
Has these problem(s):
	- Target SHA1 does not exist
