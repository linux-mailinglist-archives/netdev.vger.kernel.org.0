Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE2691370
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjBIWhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjBIWhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:37:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D45D32E58
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 14:37:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkaBF0Lei99jnSRd5/S5BuxnSqlCCQvT5mKDKvMCDAam4wnrF4QbICPsnxRUHpuFA+Gmj6iJwRgYA4KTc0ogRLQ+03rXIqWActM3JwOJy0auz+XJtNFLuFs9doLRzxgBC/2pwFhssV6+YU35RkxVz6hzRRgOYikG1+MqOXbesU8DNs60Fy7N+ymnPdEI8Se3n4JScza4x0FBgYltAbxKtSa52O6TbUQV7ATCfu2efbORD2jr+CakoMNO36pVCFhX7f2YTpcqkZjGFHpwcz+D1OGuJoGV/iWFQGoTxUo9qKA3q6gOjXGH2DKsN1tcBboBOFhQI+Pt+8g/bp+V5wp0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukKoHZ8Tric3cOY7/k9wD5KqXlvO9UTykk66VeObZiw=;
 b=febm2ze0ShHDuxYG6yL12iKhBxhcjYo3CFX4LEHvFWozTJ9x+WIF3xkR67R1aireU8MAo4s2XClzJDyO6QRGEF6Zm8jiPpZHvbtugPb/0n29j74rMiZflMPT0ZrX9mcftJEfIKJ+sMYo+h41TjJ3JsNIRF84usKgmbuiLx7/6FTurse8ClUslfwhbK5VN0pEyIbXQzRVq43K4NztlpAylCzacVEKgkrFR5MzeHp+JRqWbJucMovhg3DHtzdpDXv7+sUeHb36DFI3lqB5l4HrPJZzbyfX1538RzVCtzMYKoREX23YasOFgPMqG0gN/eLsXqetSQKZINybuNeO/Zy5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukKoHZ8Tric3cOY7/k9wD5KqXlvO9UTykk66VeObZiw=;
 b=0SGxBmf6UMRtbil4/JypGzj/2Y+oPnK0nS/KkuRcuV+E8/E2EVvlb3AIaFLlPhUOoZBDa6M5N6u+qdh2ajy+pDa9d+1BZS2j9zGhTv1/wKw/k83qClFnktc4nXmsdyPGyn01w4og5yuy/782lwvHj8ir0LO81WmRjpzHO2bUURY=
Received: from MW4PR04CA0059.namprd04.prod.outlook.com (2603:10b6:303:6a::34)
 by SJ2PR12MB7990.namprd12.prod.outlook.com (2603:10b6:a03:4c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Thu, 9 Feb
 2023 22:37:15 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::aa) by MW4PR04CA0059.outlook.office365.com
 (2603:10b6:303:6a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Thu, 9 Feb 2023 22:37:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.19 via Frontend Transport; Thu, 9 Feb 2023 22:37:15 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 9 Feb
 2023 16:37:14 -0600
Message-ID: <34be65a9-a741-7e4e-c7f3-a80d3e660528@amd.com>
Date:   Thu, 9 Feb 2023 16:37:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <jacob.e.keller@intel.com>, <gal@nvidia.com>, <moshe@nvidia.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
 <20230209133144.3e699727@kernel.org>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
In-Reply-To: <20230209133144.3e699727@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT028:EE_|SJ2PR12MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: 4762ef10-890a-42c9-6ddc-08db0aee31c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0brT624X/No8GvWs4bsq3QYZazE9+yN8O2pPWvnOiX57kcuD0Hv/0o3HYevDrRoxEEWznPKFwy3BkmxulPUfRFip01N+kx1vuQZGF+qtp1d6Sai3PFzZLAh9684to4nwKocxRTIHWlFD9+vrNHofOH5q7czEs+OFfEsq9iNYYu0+7l1oXscu98O9t+TeKx7PB4J/ZCytwpmBH6L6CXXFyal8jRLUVy3VmWKsCpVnwsOhFMtpCxCicx1iK8m195sVrqR9HaYlVE8aK1+X0+FT/RboyBlUbLGiNub9Q9rdL2Ie8Fd5nFj7sV0NchbbmU2QWPZ9JWhsfnOqbRUulTv9uIg5Mr0HNkzcePguVNcrWpsFCJwoOWnoZWJcyP3o6N4O8u4cv86NGrsMyF7V4RwN12ZjshEGZM2fTpxmZ01PNY0bC/giSTNrTVBZmIqtZcA2K+MTCzrXJ1efea85ujKXR5IDcFAOB9Jg1lmzlya1Qna1N1+yLxZ1F5hmjMHKO8Z32yyE/tOTYqhZyFEzm3Lr+FaDJ0YShlen/goj186HXCCjuiJTVmIVTw1h/y7XsAv3qtiwdzkgC+92vSsFPseyze61p0e97IWqRud8aHnuY9IHU83VUfmW5atKRAQBG2BdI6eAX9sxTFJH292xryj3Q5HL4HDgsJAMCst5Kl7yCYId84KLVSlW986Ffld+vuy2cc/4Ce0tEZt5yzCtazVgUUAy5edGCulDzQeM8P52Q3j4/MsK3a7XaJO1j7F85hG0nKM6VcfIUgP8EUURAoUJw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(86362001)(2616005)(336012)(478600001)(53546011)(47076005)(31686004)(36756003)(83380400001)(4326008)(426003)(316002)(8936002)(41300700001)(186003)(45080400002)(54906003)(16576012)(82310400005)(40480700001)(26005)(6916009)(36860700001)(70586007)(8676002)(70206006)(44832011)(5660300002)(7416002)(16526019)(31696002)(40460700003)(2906002)(356005)(81166007)(82740400003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 22:37:15.4814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4762ef10-890a-42c9-6ddc-08db0aee31c2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7990
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 3:31 PM, Jakub Kicinski wrote:
> On Thu, 9 Feb 2023 15:05:46 -0600 Kim Phillips wrote:
>> Is there a different tree the series can be rebased on, until net-next
>> gets fixed?
> 
> merge in net-next, the fix should be there but was merged a couple of
> hours ago so probably not yet in linux-next

I=Ok, I took next-20230209, git merged net-next/master, fixed a merge
conflict to use the latter net-next/master version:

<<<<<<< HEAD
	if (err == NOTIFY_BAD) {
		dl_trap->trap.action = action_orig;
		err = trap_event_ctx.err;
	}
out:
	return err;
=======
	if (err == NOTIFY_BAD)
		dl_trap->trap.action = action_orig;

	return trap_event_ctx.err;
 >>>>>>> net-next/master

...and unfortunately still get a splat on that same Rome system:

[   22.647832] mlx5_core 0000:21:00.0: firmware version: 14.22.1002
[   22.653879] mlx5_core 0000:21:00.0: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
[   23.228950] mlx5_core 0000:21:00.0: E-Switch: Total vports 10, per vport: max uc(1024) max mc(16384)
[   23.245100] mlx5_core 0000:21:00.0: Port module event: module 0, Cable plugged
[   23.570053] mlx5_core 0000:21:00.0: Supported tc offload range - chains: 1, prios: 1
[   23.577812] mlx5_core 0000:21:00.0: mlx5e_tc_post_act_init:40:(pid 9): firmware level support is missing
[   23.594377] mlx5_core 0000:21:00.0: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0 basic)
[   23.605492] mlx5_core 0000:21:00.1: firmware version: 14.22.1002
[   23.611536] mlx5_core 0000:21:00.1: 63.008 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x8 link)
[   24.199756] mlx5_core 0000:21:00.1: E-Switch: Total vports 10, per vport: max uc(1024) max mc(16384)
[   24.216876] mlx5_core 0000:21:00.1: Port module event: module 1, Cable unplugged
[   24.555670] mlx5_core 0000:21:00.1: Supported tc offload range - chains: 1, prios: 1
[   24.563428] mlx5_core 0000:21:00.1: mlx5e_tc_post_act_init:40:(pid 9): firmware level support is missing
[   24.580084] mlx5_core 0000:21:00.1: MLX5E: StrdRq(0) RqSz(1024) StrdSz(256) RxCqeCmprss(0 basic)
[   24.593808] systemd-udevd[1974]: Using default interface naming scheme 'v245'.
[   24.602595] systemd-udevd[1974]: ethtool: autonegotiation is unset or enabled, the speed and duplex are not writable.
[   24.613314] mlx5_core 0000:21:00.0 enp33s0f0np0: renamed from eth0
[   24.701259] ------------[ cut here ]------------
[   24.705888] WARNING: CPU: 228 PID: 2318 at net/devlink/leftover.c:9643 devl_param_driverinit_value_get+0xe5/0x1f0
[   24.716153] Modules linked in: mlx5_ib(+) ib_uverbs ib_core mlx5_core ast i2c_algo_bit drm_shmem_helper hid_generic drm_kms_helper syscopyarea sysfillrect sysimgblt usbhid pci_hyperv_intf crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd mlxfw hid psample drm ahci tls libahci i2c_piix4 wmi
[   24.745589] CPU: 228 PID: 2318 Comm: systemd-udevd Not tainted 6.2.0-rc7-next-20230209+ #4
[   24.753856] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
[   24.761943] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
[   24.767955] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 58 cd 08 00 48 8d bf 28 02 00 00 be ff ff ff ff e8 03 2a 07 00 85 c0 0f 85 43 ff ff ff <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
[   24.786702] RSP: 0018:ffffc217dfff7a28 EFLAGS: 00010246
[   24.791925] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
[   24.799058] RDX: 0000000000000000 RSI: ffff9d7458b00228 RDI: ffff9d835f588d50
[   24.806194] RBP: ffffc217dfff7a40 R08: 0000000000000000 R09: ffff9d8316157c00
[   24.813325] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9d7458b00000
[   24.820455] R13: ffffc217dfff7a50 R14: 0000000000000001 R15: 0000000000000002
[   24.827589] FS:  00007f03c4b0a880(0000) GS:ffff9d92c8c00000(0000) knlGS:0000000000000000
[   24.835677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   24.841422] CR2: 00007ffd0c160f48 CR3: 000080109f420000 CR4: 0000000000350ee0
[   24.848557] Call Trace:
[   24.851003]  <TASK>
[   24.853117]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
[   24.858010]  ? __kmalloc+0x53/0x1b0
[   24.861512]  mlx5r_probe+0x149/0x170 [mlx5_ib]
[   24.865974]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
[   24.870957]  auxiliary_bus_probe+0x45/0xa0
[   24.875059]  really_probe+0x17b/0x3e0
[   24.878731]  __driver_probe_device+0x7e/0x180
[   24.883090]  driver_probe_device+0x23/0x80
[   24.887191]  __driver_attach+0xcb/0x1a0
[   24.891027]  ? __pfx___driver_attach+0x10/0x10
[   24.895475]  bus_for_each_dev+0x89/0xd0
[   24.899311]  driver_attach+0x22/0x30
[   24.902894]  bus_add_driver+0x1b9/0x240
[   24.906735]  driver_register+0x66/0x130
[   24.910584]  __auxiliary_driver_register+0x73/0xe0
[   24.915385]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
[   24.919846]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
[   24.924831]  do_one_initcall+0x7a/0x2b0
[   24.928677]  ? kmalloc_trace+0x2e/0xe0
[   24.932433]  do_init_module+0x6a/0x260
[   24.936191]  load_module+0x1e90/0x2050
[   24.939942]  ? ima_post_read_file+0xd6/0xf0
[   24.944138]  __do_sys_finit_module+0xc8/0x140
[   24.948497]  ? __do_sys_finit_module+0xc8/0x140
[   24.953036]  __x64_sys_finit_module+0x1e/0x30
[   24.957399]  do_syscall_64+0x3f/0x90
[   24.960987]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   24.966047] RIP: 0033:0x7f03c513673d
[   24.969628] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
[   24.988380] RSP: 002b:00007ffd0c1665f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   24.995943] RAX: ffffffffffffffda RBX: 0000556e1aec4d30 RCX: 00007f03c513673d
[   25.003078] RDX: 0000000000000000 RSI: 00007f03c5016ded RDI: 000000000000000e
[   25.010210] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000556e1ae664e8
[   25.017343] R10: 000000000000000e R11: 0000000000000246 R12: 00007f03c5016ded
[   25.024477] R13: 0000000000000000 R14: 0000556e1aeee320 R15: 0000556e1aec4d30
[   25.031621]  </TASK>
[   25.033815] ---[ end trace 0000000000000000 ]---
[   25.072333] ------------[ cut here ]------------
[   25.076971] WARNING: CPU: 100 PID: 2318 at net/devlink/leftover.c:9643 devl_param_driverinit_value_get+0xe5/0x1f0
[   25.087406] Modules linked in: mlx5_ib(+) ib_uverbs ib_core mlx5_core ast i2c_algo_bit drm_shmem_helper hid_generic drm_kms_helper syscopyarea sysfillrect sysimgblt usbhid pci_hyperv_intf crct10dif_pclmul crc32_pclmul ghash_clmulni_intel sha512_ssse3 aesni_intel crypto_simd cryptd mlxfw hid psample drm ahci tls libahci i2c_piix4 wmi
[   25.116844] CPU: 100 PID: 2318 Comm: systemd-udevd Tainted: G        W          6.2.0-rc7-next-20230209+ #4
[   25.126576] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
[   25.134665] RIP: 0010:devl_param_driverinit_value_get+0xe5/0x1f0
[   25.140676] Code: 00 5b b8 ea ff ff ff 41 5c 41 5d 5d e9 58 cd 08 00 48 8d bf 28 02 00 00 be ff ff ff ff e8 03 2a 07 00 85 c0 0f 85 43 ff ff ff <0f> 0b 49 8b 84 24 18 01 00 00 48 83 78 18 00 0f 85 41 ff ff ff 0f
[   25.159421] RSP: 0018:ffffc217dfff7a28 EFLAGS: 00010246
[   25.164646] RAX: 0000000000000000 RBX: 0000000000000009 RCX: 0000000000000000
[   25.171779] RDX: 0000000000000000 RSI: ffff9d745c680228 RDI: ffff9d835f588d50
[   25.178910] RBP: ffffc217dfff7a40 R08: 0000000000000000 R09: ffff9d835e860400
[   25.186045] R10: 0000000000000001 R11: 0000000000000000 R12: ffff9d745c680000
[   25.193178] R13: ffffc217dfff7a50 R14: 0000000000000001 R15: 0000000000000002
[   25.200310] FS:  00007f03c4b0a880(0000) GS:ffff9d92b8c00000(0000) knlGS:0000000000000000
[   25.208395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.214141] CR2: 00007f03c520d52c CR3: 000080109f420000 CR4: 0000000000350ee0
[   25.221275] Call Trace:
[   25.223726]  <TASK>
[   25.225831]  mlx5_is_roce_on+0x3a/0xb0 [mlx5_core]
[   25.230678]  ? __kmalloc+0x53/0x1b0
[   25.234172]  mlx5r_probe+0x149/0x170 [mlx5_ib]
[   25.238641]  ? __pfx_mlx5r_probe+0x10/0x10 [mlx5_ib]
[   25.243624]  auxiliary_bus_probe+0x45/0xa0
[   25.247724]  really_probe+0x17b/0x3e0
[   25.251393]  __driver_probe_device+0x7e/0x180
[   25.255761]  driver_probe_device+0x23/0x80
[   25.259868]  __driver_attach+0xcb/0x1a0
[   25.263707]  ? __pfx___driver_attach+0x10/0x10
[   25.268159]  bus_for_each_dev+0x89/0xd0
[   25.272001]  driver_attach+0x22/0x30
[   25.275577]  bus_add_driver+0x1b9/0x240
[   25.279421]  driver_register+0x66/0x130
[   25.283264]  __auxiliary_driver_register+0x73/0xe0
[   25.288062]  mlx5_ib_init+0xda/0x110 [mlx5_ib]
[   25.292519]  ? __pfx_init_module+0x10/0x10 [mlx5_ib]
[   25.297496]  do_one_initcall+0x7a/0x2b0
[   25.301337]  ? kmalloc_trace+0x2e/0xe0
[   25.305088]  do_init_module+0x6a/0x260
[   25.308841]  load_module+0x1e90/0x2050
[   25.312595]  ? ima_post_read_file+0xd6/0xf0
[   25.316797]  __do_sys_finit_module+0xc8/0x140
[   25.321155]  ? __do_sys_finit_module+0xc8/0x140
[   25.325696]  __x64_sys_finit_module+0x1e/0x30
[   25.330057]  do_syscall_64+0x3f/0x90
[   25.333635]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   25.338687] RIP: 0033:0x7f03c513673d
[   25.342266] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 23 37 0d 00 f7 d8 64 89 01 48
[   25.361015] RSP: 002b:00007ffd0c1665f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   25.368579] RAX: ffffffffffffffda RBX: 0000556e1aec4d30 RCX: 00007f03c513673d
[   25.375713] RDX: 0000000000000000 RSI: 00007f03c5016ded RDI: 000000000000000e
[   25.382843] RBP: 0000000000020000 R08: 0000000000000000 R09: 0000556e1ae664e8
[   25.389976] R10: 000000000000000e R11: 0000000000000246 R12: 00007f03c5016ded
[   25.397109] R13: 0000000000000000 R14: 0000556e1aeee320 R15: 0000556e1aec4d30
[   25.404249]  </TASK>
[   25.406437] ---[ end trace 0000000000000000 ]---

Did I do the merge wrong, or is the problem still there?

Thanks,

Kim
