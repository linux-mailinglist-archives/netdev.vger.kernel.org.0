Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF292A2D45
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 15:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgKBOru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 09:47:50 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4390 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgKBOru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 09:47:50 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa01c190001>; Mon, 02 Nov 2020 06:47:53 -0800
Received: from [172.27.13.219] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 2 Nov
 2020 14:47:39 +0000
Subject: Re: [PATCH mlx5-next v1 02/11] net/mlx5: Properly convey driver
 version to firmware
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        gregkh <gregkh@linuxfoundation.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, <linux-rdma@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, <netdev@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        <virtualization@lists.linux-foundation.org>,
        <alsa-devel@alsa-project.org>, <tiwai@suse.de>,
        <broonie@kernel.org>, "David S . Miller" <davem@davemloft.net>,
        <ranjani.sridharan@linux.intel.com>,
        <pierre-louis.bossart@linux.intel.com>, <fred.oh@linux.intel.com>,
        <shiraz.saleem@intel.com>, <dan.j.williams@intel.com>,
        <kiran.patil@intel.com>, <linux-kernel@vger.kernel.org>
References: <20201101201542.2027568-1-leon@kernel.org>
 <20201101201542.2027568-3-leon@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <67ff0c7b-d111-9e8f-76d5-858ecf4ba692@nvidia.com>
Date:   Mon, 2 Nov 2020 16:47:37 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101201542.2027568-3-leon@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604328473; bh=8Ups38YJuQ+UfstT0esti7tM74Cc7GXxoMtke6CiT2s=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=GQGMTbElQGFFPjgRGdF7N1IK6iE/aXb6Jrl/qA2b839r/fv3l5hbzRjO/9ZEYnlRR
         dq2AD6G/KJzN3NjAoVeRYUtS+M0bNkgF1VS4sjStSMS/cmgiEUYY35MaDgi4ldDnsY
         Yz1E198i97yHS4kopwrYJd7kVMwj4YrVFNiOwiryHB5toEjt61g3DL+3vj794icIoN
         bz6roc98IvYgNaVd2E49fmBBySriSEanlWaDQ4lbG+jjX3WKsD3HoMR0npBeeBvSOT
         UHetBjOSaDHOE0X9W4smdCtKZGdEaYaq57b1Pjtt6JhtJWqZZSZZjjBnEs2j5O8hWw
         S5ysyN/kqw0bg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-11-01 10:15 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> mlx5 firmware expects driver version in specific format X.X.X, so
> make it always correct and based on real kernel version aligned with
> the driver.
> 
> Fixes: 012e50e109fd ("net/mlx5: Set driver version into firmware")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/main.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> index 8ff207aa1479..71e210f22f69 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> @@ -50,6 +50,7 @@
>   #ifdef CONFIG_RFS_ACCEL
>   #include <linux/cpu_rmap.h>
>   #endif
> +#include <linux/version.h>
>   #include <net/devlink.h>
>   #include "mlx5_core.h"
>   #include "lib/eq.h"
> @@ -233,7 +234,10 @@ static void mlx5_set_driver_version(struct mlx5_core_dev *dev)
>   	strncat(string, ",", remaining_size);
> 
>   	remaining_size = max_t(int, 0, driver_ver_sz - strlen(string));
> -	strncat(string, DRIVER_VERSION, remaining_size);
> +
> +	snprintf(string + strlen(string), remaining_size, "%u.%u.%u",
> +		 (u8)(LINUX_VERSION_CODE >> 16), (u8)(LINUX_VERSION_CODE >> 8),
> +		 (u16)(LINUX_VERSION_CODE & 0xff));
> 
>   	/*Send the command*/
>   	MLX5_SET(set_driver_version_in, in, opcode,
> --
> 2.28.0
> 

Reviewed-by: Roi Dayan <roid@nvidia.com>
