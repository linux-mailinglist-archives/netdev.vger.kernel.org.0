Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5845D414
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfGBQPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:15:46 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:45774 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfGBQPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:15:46 -0400
Received: from ramsan ([84.194.98.4])
        by xavier.telenet-ops.be with bizsmtp
        id XsFi2000t05gfCL01sFiK5; Tue, 02 Jul 2019 18:15:44 +0200
Received: from geert (helo=localhost)
        by ramsan with local-esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hiLRW-0003TW-LY; Tue, 02 Jul 2019 18:15:42 +0200
Date:   Tue, 2 Jul 2019 18:15:42 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>
cc:     "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [for-next V2 06/10] linux/dim: Move implementation to .c files
In-Reply-To: <20190625205701.17849-7-saeedm@mellanox.com>
Message-ID: <alpine.DEB.2.21.1907021810220.13058@ramsan.of.borg>
References: <20190625205701.17849-1-saeedm@mellanox.com> <20190625205701.17849-7-saeedm@mellanox.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Saeed, Tal,

On Tue, 25 Jun 2019, Saeed Mahameed wrote:
> From: Tal Gilboa <talgi@mellanox.com>
>
> Moved all logic from dim.h and net_dim.h to dim.c and net_dim.c.
> This is both more structurally appealing and would allow to only
> expose externally used functions.
>
> Signed-off-by: Tal Gilboa <talgi@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

This is now commit 4f75da3666c0c572 ("linux/dim: Move implementation to
.c files") in net-next.

> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -8,6 +8,7 @@ config NET_VENDOR_BROADCOM
> 	default y
> 	depends on (SSB_POSSIBLE && HAS_DMA) || PCI || BCM63XX || \
> 		   SIBYTE_SB1xxx_SOC
> +	select DIMLIB

Merely enabling a NET_VENDOR_* symbol should not enable inclusion of
any additional code, cfr. the help text for the NET_VENDOR_BROADCOM
option.

Hence please move the select to the config symbol(s) for the driver(s)
that need it.

> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -562,6 +562,14 @@ config SIGNATURE
> 	  Digital signature verification. Currently only RSA is supported.
> 	  Implementation is done using GnuPG MPI library
>
> +config DIMLIB
> +	bool "DIM library"
> +	default y

Please drop this line, as optional library code should never be included
by default.

Thanks!

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
