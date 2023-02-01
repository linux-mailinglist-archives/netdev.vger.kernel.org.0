Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9C686327
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjBAJvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbjBAJvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:51:44 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAD032505;
        Wed,  1 Feb 2023 01:51:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ogBaG4s08coPCdOK9G8kAXexpNKzyrqmg+MiuCfmCE8+DFYZakzHOQyWvUyUNMKVpzOoniJHDoyAe5FDgIg2WwIoE/K1qGC7iVZbebYyBJECTpiweQ/25VH7/YcNDWIGaIqa+13xsGyA6hTKf6HiisWO9ZvXeDQOIKf0mN5gxAAdNclIBoM2afRRRe/I7qJdKocgrlZdRKFmkCH8jlz7QG62W/4F+1ARtK/dy3PD2WJ4KLFRF+oHQQ8u0m7epze0rZsbcZz0lnXmOO64dkFCmi2JYCz23Q1fEOXON7DEkU80vSSdjp7YpfsbPIOY6TdJUv7Qs4XUXSKSeRsjSwruxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ph/P5g8TqZrIzrqzad20GM+C9dMWut7nZdxT4haqymo=;
 b=NPUICXB4MeFoO3hMTzJQiHy/lEq/9UqPeF4MlDQOmCojeOftbiasmYIFhUGTzhWcoMVXwrN+W+lsHOIEJe3jKOG9RJYJP/Tc4n199g8S++oMrbbVu8KbS2gd/35DTXw5/xP6S+Tqt7yTn+31/z1cSXo+c4aRN1CejDZHWpgcpkQj9brwhki0JCRYGQTU5Pu8Lypx67LsyKdxGPypQO/w1ksyHVI/Nzocn12KMORjEHnlNPUHrP7DweBeWBrvWjkIt2gSWnwLDJEvXEM4n6lF1k3/mdLYKxZKmS06IaY2WGrOJsysm55r9/yaOt1lr5i1yiCbtIcEr50X2mSE2qIi2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ph/P5g8TqZrIzrqzad20GM+C9dMWut7nZdxT4haqymo=;
 b=UfuamTFrIxNaritC64vT6JoF4/cFk7ZO+48MVRKzrcdj8mt60/lpyK2RI75SdYTGY0vhhUF2nH0ju4DwiM+lNCq64QScXsla7adAl8PSE2I3LR6pHvfVzD1yp/2qHsbvmIcB4J6lnrxQLwQaAu/7cH/ugIijsrVX2Kz4+M/xA5Y0SnEqwajBYKm9ttgVzjI8CCKxCRV6bERYUOqgOVm9Tsxeq263ISkHA5e0zW1u8eQ2CXdRNqXUpcG9d1/c4Pbgwf4HpwiE+75KjFlUZ4ausla9QUdkqmVQRgpCJY4gbHlwk0svF4T79LLzEMi5Z+IgiIpPcHBzDqiRGSLbm1+Vrw==
Received: from DS7PR05CA0055.namprd05.prod.outlook.com (2603:10b6:8:2f::15) by
 CY8PR12MB7610.namprd12.prod.outlook.com (2603:10b6:930:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.38; Wed, 1 Feb 2023 09:51:40 +0000
Received: from DS1PEPF0000E656.namprd02.prod.outlook.com
 (2603:10b6:8:2f:cafe::88) by DS7PR05CA0055.outlook.office365.com
 (2603:10b6:8:2f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22 via Frontend
 Transport; Wed, 1 Feb 2023 09:51:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E656.mail.protection.outlook.com (10.167.18.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.21 via Frontend Transport; Wed, 1 Feb 2023 09:51:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 01:51:25 -0800
Received: from localhost (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 01:51:24 -0800
Date:   Wed, 1 Feb 2023 11:51:21 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        <netdev@vger.kernel.org>, <shiraz.saleem@intel.com>,
        <mustafa.ismail@intel.com>, <jgg@nvidia.com>,
        <linux-rdma@vger.kernel.org>,
        Marcin Szycik <marcin.szycik@linux.intel.com>,
        Jakub Andrysiak <jakub.andrysiak@intel.com>
Subject: Re: [PATCH net 2/6] ice: Do not use WQ_MEM_RECLAIM flag for workqueue
Message-ID: <Y9o2GQs7VvcWZqdt@unreal>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230131213703.1347761-3-anthony.l.nguyen@intel.com>
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E656:EE_|CY8PR12MB7610:EE_
X-MS-Office365-Filtering-Correlation-Id: d9da3d85-735b-405b-f226-08db0439eaec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iL5ttzLd6SyF6hpBzPQ5yaAYNdNx+pUEPSu/MWYLLBPCGx2JJ1fn+yDENjTmB5znIJsuG/Qm8VpvTAI0HgKfiWPH/MdTcw0I/bj4C3yX4FbtqmQGD9dAkgZWk2Bh0NuBehQ1zbv1TLXYFfUfZo/ouFioViU3192D/8whEAAiVyrKwAY7fu2CBY2ZJG0JY62THph/8Tm5Cw4C4qwJRDwil0IRgY9ElL7ZEMLTfR3Z4hBMhN5Z8/K2t3gR4ZL7D7GCUFfNVHke6H3sCumu87nlvfEyJrY/rU9Y65hY+GJE2k/qOCkKzly/ID7imT90YwT9GhPjS8wsKPptIyA44zB4PsPZsc8ScjJDV81CjP67kCBD7PtKIm8eOgvy5KB1JSj8J9y5qVExi/dORGrvbaJ3lU6UsUNVNHC5G8CDZQN/FRCPN+H1OwP1L/0NqI/CgRAdb5Y5wVzpkVnX9b0kTGfBIk3VPcKSpdBkIWWC6dPzY3E1eoFzZvDkX5Xpicd5CnkRuDNHrCdtdzutS8WBbOcZu79uMAlOE3o7qkZ1y9locEYJTCOm5OYMyj8lIwL+N/Hryad6q/s4rwvd5zkDRDb2JAO1oH/p5bczRV4hZLHBeReAxH9D+s+/vC3KK1c71GxttYLcaPPiy5cobfCKdV/UWAt5vbFdf7Xa5ipN9GJXKgopwGsk2pBntd090djjTRo+k9Wvu+0dJs/ui6xkQooVYw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(7916004)(136003)(396003)(39860400002)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(2906002)(86362001)(7416002)(5660300002)(47076005)(83380400001)(426003)(33716001)(336012)(40460700003)(82310400005)(54906003)(9686003)(45080400002)(8936002)(8676002)(4326008)(16526019)(70586007)(6916009)(26005)(41300700001)(356005)(70206006)(7636003)(36860700001)(316002)(82740400003)(186003)(478600001)(6666004)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 09:51:40.2538
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9da3d85-735b-405b-f226-08db0439eaec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E656.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7610
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:36:59PM -0800, Tony Nguyen wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> When both ice and the irdma driver are loaded, a warning in
> check_flush_dependency is being triggered. This is due to ice driver
> workqueue being allocated with the WQ_MEM_RECLAIM flag and the irdma one
> is not.
> 
> According to kernel documentation, this flag should be set if the
> workqueue will be involved in the kernel's memory reclamation flow.
> Since it is not, there is no need for the ice driver's WQ to have this
> flag set so remove it.
> 
> Example trace:
> 
> [  +0.000004] workqueue: WQ_MEM_RECLAIM ice:ice_service_task [ice] is flushing !WQ_MEM_RECLAIM infiniband:0x0
> [  +0.000139] WARNING: CPU: 0 PID: 728 at kernel/workqueue.c:2632 check_flush_dependency+0x178/0x1a0
> [  +0.000011] Modules linked in: bonding tls xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_cha
> in_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables nfnetlink bridge stp llc rfkill vfat fat intel_rapl_msr intel
> _rapl_common isst_if_common skx_edac nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct1
> 0dif_pclmul crc32_pclmul ghash_clmulni_intel rapl intel_cstate rpcrdma sunrpc rdma_ucm ib_srpt ib_isert iscsi_target_mod target_
> core_mod ib_iser libiscsi scsi_transport_iscsi rdma_cm ib_cm iw_cm iTCO_wdt iTCO_vendor_support ipmi_ssif irdma mei_me ib_uverbs
> ib_core intel_uncore joydev pcspkr i2c_i801 acpi_ipmi mei lpc_ich i2c_smbus intel_pch_thermal ioatdma ipmi_si acpi_power_meter
> acpi_pad xfs libcrc32c sd_mod t10_pi crc64_rocksoft crc64 sg ahci ixgbe libahci ice i40e igb crc32c_intel mdio i2c_algo_bit liba
> ta dca wmi dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler fuse
> [  +0.000161]  [last unloaded: bonding]
> [  +0.000006] CPU: 0 PID: 728 Comm: kworker/0:2 Tainted: G S                 6.2.0-rc2_next-queue-13jan-00458-gc20aabd57164 #1
> [  +0.000006] Hardware name: Intel Corporation S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0010.010620200716 01/06/2020
> [  +0.000003] Workqueue: ice ice_service_task [ice]
> [  +0.000127] RIP: 0010:check_flush_dependency+0x178/0x1a0
> [  +0.000005] Code: 89 8e 02 01 e8 49 3d 40 00 49 8b 55 18 48 8d 8d d0 00 00 00 48 8d b3 d0 00 00 00 4d 89 e0 48 c7 c7 e0 3b 08
> 9f e8 bb d3 07 01 <0f> 0b e9 be fe ff ff 80 3d 24 89 8e 02 00 0f 85 6b ff ff ff e9 06
> [  +0.000004] RSP: 0018:ffff88810a39f990 EFLAGS: 00010282
> [  +0.000005] RAX: 0000000000000000 RBX: ffff888141bc2400 RCX: 0000000000000000
> [  +0.000004] RDX: 0000000000000001 RSI: dffffc0000000000 RDI: ffffffffa1213a80
> [  +0.000003] RBP: ffff888194bf3400 R08: ffffed117b306112 R09: ffffed117b306112
> [  +0.000003] R10: ffff888bd983088b R11: ffffed117b306111 R12: 0000000000000000
> [  +0.000003] R13: ffff888111f84d00 R14: ffff88810a3943ac R15: ffff888194bf3400
> [  +0.000004] FS:  0000000000000000(0000) GS:ffff888bd9800000(0000) knlGS:0000000000000000
> [  +0.000003] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  +0.000003] CR2: 000056035b208b60 CR3: 000000017795e005 CR4: 00000000007706f0
> [  +0.000003] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  +0.000003] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  +0.000002] PKRU: 55555554
> [  +0.000003] Call Trace:
> [  +0.000002]  <TASK>
> [  +0.000003]  __flush_workqueue+0x203/0x840
> [  +0.000006]  ? mutex_unlock+0x84/0xd0
> [  +0.000008]  ? __pfx_mutex_unlock+0x10/0x10
> [  +0.000004]  ? __pfx___flush_workqueue+0x10/0x10
> [  +0.000006]  ? mutex_lock+0xa3/0xf0
> [  +0.000005]  ib_cache_cleanup_one+0x39/0x190 [ib_core]
> [  +0.000174]  __ib_unregister_device+0x84/0xf0 [ib_core]
> [  +0.000094]  ib_unregister_device+0x25/0x30 [ib_core]
> [  +0.000093]  irdma_ib_unregister_device+0x97/0xc0 [irdma]
> [  +0.000064]  ? __pfx_irdma_ib_unregister_device+0x10/0x10 [irdma]
> [  +0.000059]  ? up_write+0x5c/0x90
> [  +0.000005]  irdma_remove+0x36/0x90 [irdma]
> [  +0.000062]  auxiliary_bus_remove+0x32/0x50
> [  +0.000007]  device_release_driver_internal+0xfa/0x1c0
> [  +0.000005]  bus_remove_device+0x18a/0x260
> [  +0.000007]  device_del+0x2e5/0x650
> [  +0.000005]  ? __pfx_device_del+0x10/0x10
> [  +0.000003]  ? mutex_unlock+0x84/0xd0
> [  +0.000004]  ? __pfx_mutex_unlock+0x10/0x10
> [  +0.000004]  ? _raw_spin_unlock+0x18/0x40
> [  +0.000005]  ice_unplug_aux_dev+0x52/0x70 [ice]
> [  +0.000160]  ice_service_task+0x1309/0x14f0 [ice]
> [  +0.000134]  ? __pfx___schedule+0x10/0x10
> [  +0.000006]  process_one_work+0x3b1/0x6c0
> [  +0.000008]  worker_thread+0x69/0x670
> [  +0.000005]  ? __kthread_parkme+0xec/0x110
> [  +0.000007]  ? __pfx_worker_thread+0x10/0x10
> [  +0.000005]  kthread+0x17f/0x1b0
> [  +0.000005]  ? __pfx_kthread+0x10/0x10
> [  +0.000004]  ret_from_fork+0x29/0x50
> [  +0.000009]  </TASK>
> 
> Fixes: 940b61af02f4 ("ice: Initialize PF and setup miscellaneous interrupt")
> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
> Tested-by: Jakub Andrysiak <jakub.andrysiak@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
