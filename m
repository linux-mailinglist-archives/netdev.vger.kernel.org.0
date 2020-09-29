Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2F27BE41
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 09:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgI2Hmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 03:42:54 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:10874 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Hmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 03:42:54 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f72e5710000>; Tue, 29 Sep 2020 00:42:41 -0700
Received: from mtl-vdi-166.wap.labs.mlnx (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 29 Sep
 2020 07:42:52 +0000
Date:   Tue, 29 Sep 2020 10:42:48 +0300
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <jasowang@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <elic@nvidia.com>
Subject: Re: [PATCH V1 vhost-next] vdpa/mlx5: Make vdpa core driver a
 distinct module
Message-ID: <20200929074248.GA123696@mtl-vdi-166.wap.labs.mlnx>
References: <20200924143231.GA186492@mtl-vdi-166.wap.labs.mlnx>
 <20200928155448-mutt-send-email-mst@kernel.org>
 <20200929062026.GB120395@mtl-vdi-166.wap.labs.mlnx>
 <20200929022430-mutt-send-email-mst@kernel.org>
 <20200929063433.GC120395@mtl-vdi-166.wap.labs.mlnx>
 <20200929025038-mutt-send-email-mst@kernel.org>
 <20200929065744.GE120395@mtl-vdi-166.wap.labs.mlnx>
 <20200929031348-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200929031348-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.5 (bf161cf53efb) (2018-04-13)
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1601365361; bh=khNyUg6fCBHz2WjAbLMQyLYkEJvYeDmjiMJT4IcmDR4=;
        h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
         Content-Type:Content-Disposition:In-Reply-To:User-Agent:
         X-Originating-IP:X-ClientProxiedBy;
        b=n1Ox6h0L1r6zOGQpGzRyQfSzRq3NzlDT35HuIqTIFBGQgtpjIQVsDtbeflwSaQJ6K
         XkVDzlEe31USSyJKRh7tk4xxdTAuRRA0x4cx+zMnrhjodwWqTj+c3M7fQER3Kn1ACY
         7CuVNm0Ye7x0rMtuCeOA4zmgij1kdii+MiYBUyDgDKoWugX9H6E+0euCubuykyP7jV
         8wHDiakvHVmXta6n3mBT9KDPzKUO+hm4W3oEHGWRoRDqbpXcNhG/LawykCdM48Yg2m
         HqbXV439INGTKl1HpYlDyGsexuvPc+zwHktE0xNSfJIpcrgvs4qI2nFTPuZPi/4ZSQ
         sOoSVd7Oz71Lg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:17:05AM -0400, Michael S. Tsirkin wrote:
> > 
> > Use "select MLX5_CORE"
> > instead of "depends on MLX5_CORE"
> > 
> > Wasn't this agreed upon?
> 
> Hmm I don't know. I recall a similar discussion around VHOST_IOTLB.
> That's different ...

I see.

> 
> I see
> 
> [linux]$ git grep MLX5_CORE|grep depends
> drivers/infiniband/hw/mlx5/Kconfig:     depends on NETDEVICES && ETHERNET && PCI && MLX5_CORE
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on NETDEVICES && ETHERNET && INET && PCI && MLX5_CORE
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN && RFS_ACCEL
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN && NET_SWITCHDEV
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN && DCB
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on TLS=y || MLX5_CORE=m
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on TLS=y || MLX5_CORE=m
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN
> drivers/net/ethernet/mellanox/mlx5/core/Kconfig:        depends on MLX5_CORE_EN && MLX5_ESWITCH
> drivers/vdpa/Kconfig:   depends on MLX5_CORE
> 
> and no selects of this symbol, I guess you are saying you are changing everything
> else to select - is that right? Then I guess vdpa should follow suit ...
> 

No, I will leave that and will discuss internally if/who/when will do
this.
