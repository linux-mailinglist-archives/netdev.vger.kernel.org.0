Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6600253E25E
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbiFFIbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiFFIbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:31:23 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFCE9D4E4;
        Mon,  6 Jun 2022 01:31:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNClM5yYehkgHewyT6qCJ59tRTOpD0m7ezEty+MF47ZNGqmCjPa3DApzKOdEb8jw4BkbXKuzmiETiXRReVQYdGydGsTYEffYO4x5TGoWCZLj2E2eMXCCJ554Q4M3uA758zgyR+BQ1c8nnKH8Em28jxcsoo+ptSbcbzFx1m2LZuz0kXokxfnNuHiW7wz9RfGv6lG9XLozVOfus5LxUza++G+hu9s3fPa0kzSIvuqwQE2HJ1EQBnfkikMlP6XqYGcXiL0NmlvrP/W4LMVSn22QN6HtCYShuAhnUoNpsa5QtaLQ3alDsKo+ZiQ3ST3SQZhzBS07heKXAazyO0gdsK54ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w3pTFAbFWjdnru4Lo4rhHpoZHd4B6jfCtabfm6qLXW4=;
 b=ZJgy+25x5dHbjPC/ttNJgJVHqxQKiw5AYRA25SFzVk6GW0iteajcuh08PbjvtYu2CmSqxtNzkrHRScMKdwimvXIuj4jeILZlGuaHaKpAP4U0M0WUUonKqjCUz3QVJ4JAyfvhT+7s7tbjQR5w/pOq2eQ170REE8zUbLkD9oQkBw5NupaDTPQVUUtfxujPcUEK0GCjpUpkXNVxhitL61zHIUKc1uGaiMHdRO+176UfclyhH4sTjLaw8qk+cxU6KSLcdgrubr2kb4gXNDTQvy0nxsqE79P3paYj0U/SdYhQw60EGaYCNpgld5vVzXsFxsH/LWU4LAqiL5GfTRJvu4a+/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w3pTFAbFWjdnru4Lo4rhHpoZHd4B6jfCtabfm6qLXW4=;
 b=f9koqim8xJ8BO3hi4YcvG8EuvV5mdK6wVOfiYmR0v1oC8ITzbIKdRXSQThl55scF4jcYmZrtx66L4GA6JcmERDUl+O1rg9xnWzP+OufYvBE6fQ6iMEqBLRxXrcDpY2Z9PfO1JGOvu/HHTrzT/QjYzg0ux9L7YxWfMPtFYVUusH3T2QancZWblU8K50dHis32G+CHHxB8i9ITzp+A9olDETo4bffxfrMhlzDyahoUrADuMnVd49qfENl19lqy6ADIM4mBxz+9XWj1azFjrPADBuMYh0cdJ3/D4Z9qrbbhJGDp32x8tZ5oW4mmNHEXbA4gRAad6zYgOyou9JBIMCp8Kg==
Received: from BN8PR15CA0072.namprd15.prod.outlook.com (2603:10b6:408:80::49)
 by BN8PR12MB3620.namprd12.prod.outlook.com (2603:10b6:408:49::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Mon, 6 Jun
 2022 08:31:20 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::96) by BN8PR15CA0072.outlook.office365.com
 (2603:10b6:408:80::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19 via Frontend
 Transport; Mon, 6 Jun 2022 08:31:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Mon, 6 Jun 2022 08:31:20 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 6 Jun
 2022 08:31:19 +0000
Received: from [172.27.11.36] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 6 Jun 2022
 01:31:15 -0700
Message-ID: <0338001c-4a8c-bf28-b857-42e1bc775ea0@nvidia.com>
Date:   Mon, 6 Jun 2022 11:31:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] net/mlx5: Add affinity for each irq
Content-Language: en-US
To:     Yajun Deng <yajun.deng@linux.dev>, <saeedm@nvidia.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220606071351.3550997-1-yajun.deng@linux.dev>
From:   Shay Drory <shayd@nvidia.com>
In-Reply-To: <20220606071351.3550997-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8105cdf-db6e-4e93-6e51-08da4796eec7
X-MS-TrafficTypeDiagnostic: BN8PR12MB3620:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB36201634D2AC097E6DE76773CFA29@BN8PR12MB3620.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wZGF24sTJLmoODzuG31Jbdjm5/85MIQa93i0YuKiXkqnQIB5+J5OKchdrSGhy9p8tM/gH/I8zR+DzMSf4eA0iYgSFpHF33ddaiS2bWGP3Ml0EP3xN6MaV72S/uFqZPH9nhG4c/yHR/xvKRaJs1rL6bXZuOeYuO7cZsPwKPnTBVLkkFtl0tWM6opCnN1w3dSG9F3JDYbCkG+oRwlAOi8ZeAi6cFmnPv4jxLzPgeycx9DlTIQz5oapC097kkZgjfx0bsx4Lwc++VATSjBEWxVEtjSj2Hk2OWg6bUsNs+AI0Ymkhf9WwpnHGYmQxWSryr36eJtPOYPbm0IhlD4J+201r2StJ93OBZChFxh/NmJOHwyGRE/SCeIqPAdyT7k0bD3pyQDHrt1yav2gwG1ysIFxeuDZyEUxTPV11alZ0lQ357/b+YBN5Sk4/zOSQ4A8WaUqTEBVBJAxvBpq6sN0S7r6ymnkGKv/gptdoO48CjqOixFzYbxsS2JJ7K1vRhPqy7EvzKrZa/Te+5k4TVBI5kve6+jpNYx4Gia8a3tTJA5bcQrgDad4UDTOhShLtXSs4aag1c0GFsAghFwTHJXAX4ydPT4XnWifYygJnQqvGyizLAUn3nX2EInSebx00ukD+BTaMzolWZY1Gs3tvFT7dDdh2e+zNwyUuAxMOj2TuDHaGd6BDlteV1v58zQoi9C4IvLOX481jLR/ig6BtRtJnDhFkrydj+BRQT0WpRIGX+np9tZ8FXByB+6q690DFiuiTOd/
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(70206006)(47076005)(426003)(336012)(16526019)(186003)(2616005)(54906003)(110136005)(5660300002)(8936002)(508600001)(26005)(31686004)(70586007)(36756003)(53546011)(82310400005)(83380400001)(45080400002)(6666004)(356005)(81166007)(86362001)(31696002)(36860700001)(16576012)(316002)(4326008)(8676002)(40460700003)(2906002)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 08:31:20.1341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8105cdf-db6e-4e93-6e51-08da4796eec7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3620
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/6/2022 10:13, Yajun Deng wrote:
> The mlx5 would allocate no less than one irq for per cpu, we can bond each
> irq to a cpu to improve interrupt performance.

The maximum number of affinity set is hard coded to 4. in case nvec > 4 
* (num_CPUs)[1]
we will hit the following WARN[2].
Also, we hit an oops following this WARN...

[1]
mlx5 support up to 2K MSIX (depends on the HW). e.g.: if we max out mlx5 
MSIX capability,
we will cross this limit on any machine, at least that I know of.

[2]

This is a machine with 10 CPUs and 350 MSIX

[    1.633436] ------------[ cut here ]------------
  [    1.633437] WARNING: CPU: 2 PID: 194 at kernel/irq/affinity.c:443 irq_create_affinity_masks+0x175/0x270
  [    1.633467] Modules linked in: mlx5_core(+)
  [    1.633474] CPU: 2 PID: 194 Comm: systemd-modules Not tainted 5.18.0+ #1
  [    1.633480] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [    1.633483] RIP: 0010:irq_create_affinity_masks+0x175/0x270
  [    1.633492] Code: 5c 41 5d 41 5e 41 5f c3 48 c7 46 20 90 6d 19 81 48 c7 c0 90 6d 19 81 8b 34 24 4c 89 ef ff d0 41 83 7d 08 04 0f 86 de fe ff ff <0f> 0b 45 31 f6 eb c5 45 8b 5d 00 8b 34 24 43 8d 04 1f 42 8d 0c 1e
  [    1.633497] RSP: 0018:ffff88810716bac0 EFLAGS: 00010202
  [    1.633501] RAX: 000000000000000a RBX: 0000000000000001 RCX: 0000000000000200
  [    1.633504] RDX: ffffffff82605000 RSI: ffffffff82605000 RDI: 0000000000000000
  [    1.633507] RBP: ffff88810716bbd0 R08: 000000000000000a R09: ffffffff82604fc0
  [    1.633510] R10: 0000000000000008 R11: 000ffffffffff000 R12: 0000000000000000
  [    1.633513] R13: ffff88810716bbd0 R14: 0000000000000160 R15: 0000000000000160
  [    1.633516] FS:  00007f8d72994b80(0000) GS:ffff88852c900000(0000) knlGS:0000000000000000
  [    1.633525] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [    1.633528] CR2: 00007f8d73ba4490 CR3: 0000000103fce001 CR4: 0000000000370ea0
  [    1.633531] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  [    1.633534] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
  [    1.633536] Call Trace:
  [    1.633549]  <TASK>
  [    1.633553]  __pci_enable_msix_range+0x2b9/0x4c0
  [    1.633572]  pci_alloc_irq_vectors_affinity+0xa5/0x100
  [    1.633579]  mlx5_irq_table_create.cold+0x6d/0x22f [mlx5_core]
  [    1.634032]  ? probe_one+0x1aa/0x280 [mlx5_core]
  [    1.634193]  ? pci_device_probe+0xa4/0x140
  [    1.634201]  ? really_probe+0xc9/0x350
  [    1.634205]  ? pm_runtime_barrier+0x43/0x80
  [    1.634213]  ? __driver_probe_device+0x80/0x170
  [    1.634218]  ? driver_probe_device+0x1e/0x90
  [    1.634223]  ? __driver_attach+0xcd/0x1b0
  [    1.634226]  ? __device_attach_driver+0xf0/0xf0
  [    1.634231]  ? __device_attach_driver+0xf0/0xf0
  [    1.634235]  ? bus_for_each_dev+0x77/0xc0
  [    1.634243]  ? bus_add_driver+0x184/0x1f0
  [    1.634247]  ? driver_register+0x8f/0xe0
  [    1.634251]  ? 0xffffffffa0180000
  [    1.634256]  ? init+0x62/0x1000 [mlx5_core]
  [    1.634413]  ? do_one_initcall+0x4a/0x1e0
  [    1.634418]  ? kmem_cache_alloc_trace+0x33/0x420
  [    1.634426]  ? do_init_module+0x72/0x260
  [    1.634434]  ? __do_sys_finit_module+0xbb/0x130
  [    1.634443]  ? do_syscall_64+0x3d/0x90
  [    1.634452]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
  [    1.634461]  </TASK>
  [    1.634463] ---[ end trace 0000000000000000 ]---
  [[0;32m  OK  [0m] Finished [0;1;39mudev Coldplug all Devices[0m.
  [    1.713428] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: mlx5_irq_table_create+0x9c/0xa0 [mlx5_core]
  [    1.715521] CPU: 2 PID: 194 Comm: systemd-modules Tainted: G        W         5.18.0+ #1
  [    1.715524] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [    1.715525] Call Trace:
  [    1.715532]  <TASK>
  [    1.715533]  dump_stack_lvl+0x34/0x44
  [    1.715538]  panic+0x100/0x255
  [    1.715542]  ? mlx5_irq_table_create+0x9c/0xa0 [mlx5_core]
  [    1.715602]  __stack_chk_fail+0x10/0x10
  [    1.715607]  mlx5_irq_table_create+0x9c/0xa0 [mlx5_core]
  [    1.715662]  ? probe_one+0x1aa/0x280 [mlx5_core]
  [    1.715709]  ? pci_device_probe+0xa4/0x140
  [    1.715712]  ? really_probe+0xc9/0x350
  [    1.715715]  ? pm_runtime_barrier+0x43/0x80
  [    1.715718]  ? __driver_probe_device+0x80/0x170
  [    1.715719]  ? driver_probe_device+0x1e/0x90
  [    1.715721]  ? __driver_attach+0xcd/0x1b0
  [    1.715722]  ? __device_attach_driver+0xf0/0xf0
  [    1.715723]  ? __device_attach_driver+0xf0/0xf0
  [    1.715724]  ? bus_for_each_dev+0x77/0xc0
  [    1.715727]  ? bus_add_driver+0x184/0x1f0
  [    1.715728]  ? driver_register+0x8f/0xe0
  [    1.715730]  ? 0xffffffffa0180000
  [    1.715731]  ? init+0x62/0x1000 [mlx5_core]
  [    1.715778]  ? do_one_initcall+0x4a/0x1e0
  [    1.715781]  ? kmem_cache_alloc_trace+0x33/0x420
  [    1.715784]  ? do_init_module+0x72/0x260
  [    1.715788]  ? __do_sys_finit_module+0xbb/0x130
  [    1.715790]  ? do_syscall_64+0x3d/0x90
  [    1.715792]  ? entry_SYSCALL_64_after_hwframe+0x46/0xb0
  [    1.715796]  </TASK>
  [    1.715938] Kernel Offset: disabled
  [    1.732563] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: mlx5_irq_table_create+0x9c/0xa0 [mlx5_core] ]---

>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>   .../net/ethernet/mellanox/mlx5/core/pci_irq.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> index 662f1d55e30e..d13fc403fe78 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
> @@ -624,11 +624,27 @@ int mlx5_irq_table_get_num_comp(struct mlx5_irq_table *table)
>   	return table->pf_pool->xa_num_irqs.max - table->pf_pool->xa_num_irqs.min;
>   }
>   
> +static void mlx5_calc_sets(struct irq_affinity *affd, unsigned int nvecs)
> +{
> +	int i;
> +
> +	affd->nr_sets = (nvecs - 1) / num_possible_cpus() + 1;
> +
> +	for (i = 0; i < affd->nr_sets; i++) {
> +		affd->set_size[i] = min(nvecs, num_possible_cpus());
> +		nvecs -= num_possible_cpus();
> +	}
> +}
> +
>   int mlx5_irq_table_create(struct mlx5_core_dev *dev)
>   {
>   	int num_eqs = MLX5_CAP_GEN(dev, max_num_eqs) ?
>   		      MLX5_CAP_GEN(dev, max_num_eqs) :
>   		      1 << MLX5_CAP_GEN(dev, log_max_eq);
> +	struct irq_affinity affd = {
> +		.pre_vectors = 0,
> +		.calc_sets   = mlx5_calc_sets,
> +	};
>   	int total_vec;
>   	int pf_vec;
>   	int err;
> @@ -644,7 +660,8 @@ int mlx5_irq_table_create(struct mlx5_core_dev *dev)
>   		total_vec += MLX5_IRQ_CTRL_SF_MAX +
>   			MLX5_COMP_EQS_PER_SF * mlx5_sf_max_functions(dev);
>   
> -	total_vec = pci_alloc_irq_vectors(dev->pdev, 1, total_vec, PCI_IRQ_MSIX);
> +	total_vec = pci_alloc_irq_vectors_affinity(dev->pdev, 1, total_vec,
> +						   PCI_IRQ_MSIX | PCI_IRQ_AFFINITY, &affd);
>   	if (total_vec < 0)
>   		return total_vec;
>   	pf_vec = min(pf_vec, total_vec);
