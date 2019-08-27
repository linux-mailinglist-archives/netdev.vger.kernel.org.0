Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508CA9E4DD
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729010AbfH0Jvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:51:37 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39248 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbfH0Jvg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 05:51:36 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CB11264F9331295C534B;
        Tue, 27 Aug 2019 17:51:34 +0800 (CST)
Received: from [127.0.0.1] (10.177.96.96) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 27 Aug 2019
 17:51:32 +0800
Subject: Re: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
To:     <wharms@bfs.de>
References: <20190827031251.98881-1-maowenan@huawei.com>
 <5D64DABF.4010601@bfs.de>
CC:     <saeedm@mellanox.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   maowenan <maowenan@huawei.com>
Message-ID: <092f56bf-3e94-a3b6-926c-da33ba26ee37@huawei.com>
Date:   Tue, 27 Aug 2019 17:51:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <5D64DABF.4010601@bfs.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/8/27 15:24, walter harms wrote:
> 
> 
> Am 27.08.2019 05:12, schrieb Mao Wenan:
>> When MLX5_CORE_EN=y and PCI_HYPERV_INTERFACE is not set, below errors are found:
>> drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_enable':
>> en_main.c:(.text+0xb649): undefined reference to `mlx5e_hv_vhca_stats_create'
>> drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_disable':
>> en_main.c:(.text+0xb8c4): undefined reference to `mlx5e_hv_vhca_stats_destroy'
>>
>> This because CONFIG_PCI_HYPERV_INTERFACE is newly introduced by 'commit 348dd93e40c1
>> ("PCI: hv: Add a Hyper-V PCI interface driver for software backchannel interface"),
>> Fix this by making MLX5_CORE_EN imply PCI_HYPERV_INTERFACE.
>>
>> Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
>> index 37fef8c..a6a70ce 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
>> @@ -35,6 +35,7 @@ config MLX5_CORE_EN
>>  	depends on IPV6=y || IPV6=n || MLX5_CORE=m
> 
> OT but ...
> is that IPV6 needed at all ? can there be something else that yes or no ?

If I set IPV6=m, errors are found as below:
drivers/net/ethernet/mellanox/mlx5/core/main.o: In function `mlx5_unload':
main.c:(.text+0x275): undefined reference to `mlx5_hv_vhca_cleanup'
drivers/net/ethernet/mellanox/mlx5/core/main.o: In function `mlx5_cleanup_once':
main.c:(.text+0x2e8): undefined reference to `mlx5_hv_vhca_destroy'
drivers/net/ethernet/mellanox/mlx5/core/main.o: In function `mlx5_load_one':
main.c:(.text+0x23c1): undefined reference to `mlx5_hv_vhca_create'
main.c:(.text+0x248f): undefined reference to `mlx5_hv_vhca_init'
main.c:(.text+0x25e0): undefined reference to `mlx5_hv_vhca_cleanup
> 
> re,
>  wh
> 
>>  	select PAGE_POOL
>>  	select DIMLIB
>> +	imply PCI_HYPERV_INTERFACE
>>  	default n
>>  	---help---
>>  	  Ethernet support in Mellanox Technologies ConnectX-4 NIC.
> 
> .
> 

