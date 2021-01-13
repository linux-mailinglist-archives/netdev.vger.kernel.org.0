Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF712F4216
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 03:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbhAMCyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 21:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbhAMCyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 21:54:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6C4B2311F;
        Wed, 13 Jan 2021 02:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610506423;
        bh=uEMDyYxD3uqbtHcF7hYnqi8etYdbkhTDaF/kptgnbfo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mIna82veh0HKt1uffkHNFp5kD8B1L6vLCudqXMfzAxj+CeumQtSfFJfJbUCzNQtDL
         17KXf5xi/DmP0pzM+ROfW/98JJ7mF5IE5OBy+O2AwnB/mjbL3IphjjF/458DWWqMtS
         i1Zc7Tq4CGl7CQsMOz2vH/Yqh02E2meuW+gg0CFkSkIETzI4BILszHYxvU0QaCUMKC
         OZ4yGu5Q/pfRkWQ/mPHZYdTOWn3uTS9yQC/6fj4bjl/ECN1eBbWnuOApClIcH3zrUY
         GKEwlwza5hHTOsBQ5h3TN8wjZrIOTIF13tO7x0eClNU230W8D8GhyfRmHpvRuH5X4m
         3cCC80jFB2xzg==
Date:   Tue, 12 Jan 2021 18:53:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com
Subject: Re: [PATCH net] net: dsa: unbind all switches from tree when DSA
 master unbinds
Message-ID: <20210112185342.6d3c3116@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6d6cc153-85ca-62c8-8d9c-4f4c6a325e91@gmail.com>
References: <20210111230943.3701806-1-olteanv@gmail.com>
        <6d6cc153-85ca-62c8-8d9c-4f4c6a325e91@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 10:51:39 -0800 Florian Fainelli wrote:
> On 1/11/21 3:09 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > Currently the following happens when a DSA master driver unbinds while
> > there are DSA switches attached to it:
> > 
> > $ echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> > ------------[ cut here ]------------
> > WARNING: CPU: 0 PID: 392 at net/core/dev.c:9507
> > Call trace:
> >  rollback_registered_many+0x5fc/0x688
> >  unregister_netdevice_queue+0x98/0x120
> >  dsa_slave_destroy+0x4c/0x88
> >  dsa_port_teardown.part.16+0x78/0xb0
> >  dsa_tree_teardown_switches+0x58/0xc0
> >  dsa_unregister_switch+0x104/0x1b8
> >  felix_pci_remove+0x24/0x48
> >  pci_device_remove+0x48/0xf0
> >  device_release_driver_internal+0x118/0x1e8
> >  device_driver_detach+0x28/0x38
> >  unbind_store+0xd0/0x100
> > [...]
> > 
> > Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks!
