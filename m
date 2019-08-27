Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF549DEA9
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 09:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfH0HYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 03:24:55 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:28688 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbfH0HYz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 03:24:55 -0400
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id 44CC1201EB;
        Tue, 27 Aug 2019 09:24:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1566890689; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJMTtUj8Ra+odPWVkrfvhn2xJpbg4XTU+hLSZTGs2WA=;
        b=ChrZR7qMGM+a6B00tnrZ5ZiY4CyP6EItaZ/LwPHlY/rt5S43xRoI6soOQ1XQNvAGPpBOfG
        jJT1jT2D3hWa/Jf98KTSJQ4fae0P2kNLJyAff7sA7ijSAz6lpw7f2XDhA3xuOq6wndtDq9
        eljxzIDSuG2pfBnJmu6bsf7VrICOQQmw/e3fdZ0E6FIzy+d6IbVpc8gTIwTotcXh0IF448
        dVSsEVPpKtKjGtyAkr1hpwUw3B7BPZ2s4VjHCOThcsWfxODn9rraxDK+xDhp1EAwBY22iy
        33iNPV89c3LqqiZs9qL/HXG2BXtr4afSLA6dHYmNxd9wbKHZbdArtl2a9VjaUQ==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id 6CF34BEEBD;
        Tue, 27 Aug 2019 09:24:48 +0200 (CEST)
Message-ID: <5D64DABF.4010601@bfs.de>
Date:   Tue, 27 Aug 2019 09:24:47 +0200
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Mao Wenan <maowenan@huawei.com>
CC:     saeedm@mellanox.com, leon@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
References: <20190827031251.98881-1-maowenan@huawei.com>
In-Reply-To: <20190827031251.98881-1-maowenan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.10
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         TO_DN_SOME(0.00)[];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         MID_RHS_MATCH_FROM(0.00)[];
         BAYES_HAM(-3.00)[100.00%];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM(-0.00)[-0.999,0];
         RCVD_COUNT_TWO(0.00)[2];
         RCVD_TLS_ALL(0.00)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Am 27.08.2019 05:12, schrieb Mao Wenan:
> When MLX5_CORE_EN=y and PCI_HYPERV_INTERFACE is not set, below errors are found:
> drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_enable':
> en_main.c:(.text+0xb649): undefined reference to `mlx5e_hv_vhca_stats_create'
> drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_disable':
> en_main.c:(.text+0xb8c4): undefined reference to `mlx5e_hv_vhca_stats_destroy'
> 
> This because CONFIG_PCI_HYPERV_INTERFACE is newly introduced by 'commit 348dd93e40c1
> ("PCI: hv: Add a Hyper-V PCI interface driver for software backchannel interface"),
> Fix this by making MLX5_CORE_EN imply PCI_HYPERV_INTERFACE.
> 
> Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index 37fef8c..a6a70ce 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -35,6 +35,7 @@ config MLX5_CORE_EN
>  	depends on IPV6=y || IPV6=n || MLX5_CORE=m

OT but ...
is that IPV6 needed at all ? can there be something else that yes or no ?

re,
 wh

>  	select PAGE_POOL
>  	select DIMLIB
> +	imply PCI_HYPERV_INTERFACE
>  	default n
>  	---help---
>  	  Ethernet support in Mellanox Technologies ConnectX-4 NIC.
