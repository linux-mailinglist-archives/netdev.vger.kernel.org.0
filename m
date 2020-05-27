Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935451E451C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbgE0ODO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730223AbgE0ODM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:03:12 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87715206F1;
        Wed, 27 May 2020 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590588192;
        bh=7KEBN8QuPIzKTX9gxsHtjgCELp/KT9SAVYTu62u0cWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zX4y3ZgFlwopC39SN2bl6mTt5Auw2oYxOhj9YLGBD8ewmYVos79HLxV0p3ftPa7aF
         nlNcbO49zLNQfIn8XeXITrtqzbwOfaJA1rY31Ocra5kohcH9TeWOKGbIOnuc4m6w8u
         2RXZ7cq6pXOeNmsE0yudvp8I9+ZfRahnSRbqy86M=
Date:   Wed, 27 May 2020 17:03:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Max Gurtovoy <maxg@mellanox.com>
Cc:     jgg@mellanox.com, dledford@redhat.com, galpress@amazon.com,
        dennis.dalessandro@intel.com, netdev@vger.kernel.org,
        sagi@grimberg.me, linux-rdma@vger.kernel.org, bvanassche@acm.org,
        santosh.shilimkar@oracle.com, tom@talpey.com,
        aron.silverton@oracle.com, israelr@mellanox.com, oren@mellanox.com,
        shlomin@mellanox.com, vladimirk@mellanox.com
Subject: Re: [PATCH 2/9] RDMA/mlx4: remove FMR support for memory registration
Message-ID: <20200527140308.GG349682@unreal>
References: <20200527094634.24240-1-maxg@mellanox.com>
 <20200527094634.24240-3-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200527094634.24240-3-maxg@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 12:46:27PM +0300, Max Gurtovoy wrote:
> HCA's that are driven by mlx4 driver support FRWR method to register
> memory. Remove the ancient and unsafe FMR method.
>
> Signed-off-by: Max Gurtovoy <maxg@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c       |  10 --
>  drivers/infiniband/hw/mlx4/mlx4_ib.h    |  16 ---
>  drivers/infiniband/hw/mlx4/mr.c         |  93 ----------------
>  drivers/net/ethernet/mellanox/mlx4/mr.c | 183 --------------------------------
>  include/linux/mlx4/device.h             |  21 +---
>  5 files changed, 2 insertions(+), 321 deletions(-)

I don't see this line removed and all "max_fmr_maps" related.
➜  kernel git:(rdma-next) git grep fmr drivers/infiniband/hw/mlx4/ | head -1
drivers/infiniband/hw/mlx4/main.c: props->max_map_per_fmr = dev->dev->caps.max_fmr_maps;

Thanks
