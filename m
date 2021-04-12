Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE835BB26
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhDLHqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhDLHqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 03:46:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D67D600CD;
        Mon, 12 Apr 2021 07:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618213587;
        bh=bsIzX5dfgjfXmWvXk5Z9i0P2mHR4lorJDM/8OOTW4Kg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdLo1Ru24agaLHA+qs9JBcX7lSqROCirwc8l1QrQ6Pn0yH+HfMdYbe8G2i3Ctv8Y0
         6M0Fq6bk+0P3CZL0HBhEuldKjfIAgWcye0rBilFChQbUSWikTixWYQMa3XDFAxvJRB
         MHPs+WEdvI5YSNcgFas/ckRJbOguIH1oyEMWyiskK6gQhns/yHrUaFGH4kFJ+5aIZf
         R+uJASGyBVIh6teqj9GhFLpNgSGT01/H/1lD5+naeJtJdHcrNTSSOKg/jgBhMq8Aul
         GBF9V7vfGHedi3LL+DQ5Pcm9cZN4OhsphGjN1/T6gwV+o6xRToZYwG7+RtwqIe3MYl
         OY1avN2eJorvQ==
Date:   Mon, 12 Apr 2021 10:45:55 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        liuwe@microsoft.com, netdev@vger.kernel.org, andrew@lunn.ch,
        bernd@petrovitsch.priv.at, rdunlap@infradead.org,
        shacharr@microsoft.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Message-ID: <YHP6s2zagD67Xr0z@unreal>
References: <20210412023455.45594-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210412023455.45594-1-decui@microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 07:34:55PM -0700, Dexuan Cui wrote:
> Add a VF driver for Microsoft Azure Network Adapter (MANA) that will be
> available in the future.
> 
> Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Co-developed-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  MAINTAINERS                                   |    4 +-
>  drivers/net/ethernet/Kconfig                  |    1 +
>  drivers/net/ethernet/Makefile                 |    1 +
>  drivers/net/ethernet/microsoft/Kconfig        |   29 +
>  drivers/net/ethernet/microsoft/Makefile       |    5 +
>  drivers/net/ethernet/microsoft/mana/Makefile  |    6 +
>  drivers/net/ethernet/microsoft/mana/gdma.h    |  728 +++++++
>  .../net/ethernet/microsoft/mana/gdma_main.c   | 1525 +++++++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.c  |  854 ++++++++
>  .../net/ethernet/microsoft/mana/hw_channel.h  |  190 ++
>  drivers/net/ethernet/microsoft/mana/mana.h    |  549 +++++
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 1924 +++++++++++++++++
>  .../ethernet/microsoft/mana/mana_ethtool.c    |  252 +++
>  .../net/ethernet/microsoft/mana/shm_channel.c |  298 +++
>  .../net/ethernet/microsoft/mana/shm_channel.h |   21 +
>  15 files changed, 6386 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/net/ethernet/microsoft/Kconfig
>  create mode 100644 drivers/net/ethernet/microsoft/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
>  create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h
> 

<...>

> +/* Microsoft Azure Network Adapter (MANA)'s definitions
> + *
> + * Structures labeled with "HW DATA" are exchanged with the hardware. All of
> + * them are naturally aligned and hence don't need __packed.
> + */
> +
> +#define ANA_MAJOR_VERSION	0
> +#define ANA_MINOR_VERSION	1
> +#define ANA_MICRO_VERSION	1

Please don't introduce drier versions.

Thanks
