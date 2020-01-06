Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E06EF1312A0
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgAFNNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 08:13:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:47590 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgAFNNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 08:13:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3024CB1E8;
        Mon,  6 Jan 2020 13:13:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 199BBE008B; Mon,  6 Jan 2020 14:13:29 +0100 (CET)
Date:   Mon, 6 Jan 2020 14:13:29 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     yu kuai <yukuai3@huawei.com>, klassert@kernel.org,
        davem@davemloft.net, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, willy@infradead.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200106131329.GH22387@unicorn.suse.cz>
References: <20200106125337.40297-1-yukuai3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200106125337.40297-1-yukuai3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 06, 2020 at 08:53:37PM +0800, yu kuai wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
> 
> drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
> drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
> ‘mii_reg1’ set but not used [-Wunused-but-set-variable]
> 
> It is never used, and so can be removed.
> 
> Signed-off-by: yu kuai <yukuai3@huawei.com>
> ---
> changes in V2
> -The read might have side effects, don't remove it.
[...]
> @@ -1605,7 +1605,6 @@ vortex_up(struct net_device *dev)
>  	window_write32(vp, config, 3, Wn3_Config);
>  
>  	if (dev->if_port == XCVR_MII || dev->if_port == XCVR_NWAY) {
> -		mii_reg1 = mdio_read(dev, vp->phys[0], MII_BMSR);
>  		mdio_read(dev, vp->phys[0], MII_LPA);
>  		vp->partner_flow_ctrl = ((mii_reg5 & 0x0400) != 0);
>  		vp->mii.full_duplex = vp->full_duplex;

Here you removed the read, as you did in previous version of the patch.

Michal Kubecek
