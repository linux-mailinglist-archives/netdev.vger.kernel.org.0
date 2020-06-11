Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C660F1F6607
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 12:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgFKKyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 06:54:45 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:26282
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726407AbgFKKyo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 06:54:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TewBJbmie9eDZ9GML92e2trFWTBCcpnflBV+RcIRWn8iPgugT2a6kPcY9/t0YILtW29bDKevmNh475eMlwzVLtToehUG7MjDJmd2RfOwwWm8yY1rwFisW1gyb6R2VmdEuvpFdb99ahxyjz57GHXzhCc5qG7TxF7lplz4EVTcHYQ03Tmxwa0BVOcaUWVP6iAPNmiL5J3O5EkH7Scymz0SLr4Nc0mEPjya4z6V5nv2SUpR+GrJ7+qA2Co31li/fPFBSkGzC4o7+mj9U9E/2EKU8uRgUIGFuCcQu/Y3P7atCuNip8fV7AFOW5B7d2hh2zASKpZ/NGfM8EpR2zuTfx+SMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2Oir8Thnm7LYG1HGXakDdnvvBp7S9QmlwP/dUB1ufE=;
 b=FjoWFXLzFguumsGH231kHwB9XyCZpoE0/nZMhqKz5hi9KxCG67GzAomXy7u6OOh5jmkpH4MgQ+CrCmSs+Gpn+MdN1aC54h+uYTzBDUX0w37KhZhhq/yd9AoMSvor46NtTN+dNu5pRH7ZhPFbi5flEMSnwcqFlRAki8Ezq/Ian9Be0xaNT0JAmBahg0akFwMjEAH9GfNJt0OlFpwVM8ph+lFDzDyXWn6ikbF3QRYMqGNr9XEqMsSIZaPIG4EPXIB8r4SZv1tAOHPM/FCBtUR3OWUml1ZyLoxLQAbuk0jdv/MuCRDyQxgP/61DoSO6weG36ZPQkbwq0YpV2N/GyuR9Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2Oir8Thnm7LYG1HGXakDdnvvBp7S9QmlwP/dUB1ufE=;
 b=bPtjf7FdyNac9x34FQXPlUD/iAkRES5myR1q/SqA7DHEBNltCuuYEZwqbrjzgd1zT6X5ad+UHr/Gr7Vk2xH6BIiXnMzIZg4AQ4a5OcqXbvwnWQGURyOQvLvC3/udLBGQqieDBjRn8kqBsSIVVLyte9bFmkCujfYqLQWNfq6Te44=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB7089.eurprd05.prod.outlook.com (2603:10a6:20b:1a1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 11 Jun
 2020 10:39:35 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724%3]) with mapi id 15.20.3088.018; Thu, 11 Jun 2020
 10:39:35 +0000
References: <1591846217-3514-1-git-send-email-wenxu@ucloud.cn> <1591846217-3514-2-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pablo@netfilter.org,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net 2/2] flow_offload: fix miss cleanup flow_block_cb of indr_setup_ft_cb type
In-reply-to: <1591846217-3514-2-git-send-email-wenxu@ucloud.cn>
Date:   Thu, 11 Jun 2020 13:39:31 +0300
Message-ID: <vbfk10dsx7g.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::14) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Thu, 11 Jun 2020 10:39:34 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f853f18-0b0f-4195-dc56-08d80df3bba1
X-MS-TrafficTypeDiagnostic: AM7PR05MB7089:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB70898D5BFF30397599C2D66AAD800@AM7PR05MB7089.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r09PtiskyAF0jVinYfbdOEVVeLSUJoKhUNMMkxvnxIfk31VDuqdQR01Wynh+GzAlBCryT6stgfu+I4+B3cSgkkIoXLpGG06sIfggWtzZKGbN06slJ3g48J/2GHtFZzOPi3jjKFA0N8ogFDBr9nFB9UXtkyaDrQU21yZGbGn8e7q2hYqRI1NMY1W2AHnAaGqWZAWg2hwX7VbreN8aI+X+RO0bXcE62km3mSom9dOIp+cOqIlZvO2z01dyb9g3fyYDIiNWlEsZqxk2Caz7J4J1YwDcrZ9PtBc4k1RTrvAlhaAB9iadaKpftCNaleZ/dFBMxmOaLYVONOvgS5kzxh4G4DJ7Q2ZSAZ+jMTcnZdLm4BWBlqdczI6IRrePTL4LuiIvZCQP3J6rU7KhgWH/0WVFbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(6916009)(107886003)(2906002)(66556008)(8676002)(6486002)(4326008)(66476007)(86362001)(66946007)(36756003)(478600001)(966005)(8936002)(5660300002)(30864003)(7696005)(16526019)(186003)(2616005)(45080400002)(26005)(6666004)(83380400001)(52116002)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CwGx3chgxOisfbdB1r+6JSiEpGaxDroI8zCSFxqYeiYUCk90OcfPfuH4tK51/tJRm9duGHUKrHWL+4ct07X5oZEz7qmhhRwQj4NSKM9T+bchbXrV+W+NRIlXchuTjVQfLhMBDoETLEKatwQlYPZulWRL8ZiR2DUuydChBkCWpEZyviLz/felhU/vIuZQ2DyUdsFWT7iFeL1/Rqm8iVSvlIf07/S7NBsYY3r62osobbDpiZZtoZs52LddtH9vr8n0xmdtX8budGM54wt4v2j90am3ULd0dKtFkNCHyrSAFOZsFrnBvfBq+8cdaYEpxOUrYk+qq88kRiUOWxmRqhMmb+iGkkpOsVZ+VdEcRVPo0ebaHusu5KiCFzf065QFjONgsALlNCuYWbpdo4FjnJnQ6oe9x1l3UkFshGB8fnn8WOJlwQzFSvESThVDa7odJNqH0UtgmmHuACziC33HjvhuKPk/qN0EGrPOz7gEbrIzoHA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f853f18-0b0f-4195-dc56-08d80df3bba1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 10:39:35.1525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3/F8uzv78Bqev9MDszf03C8T6pt2jfnfrmEzJvvf8f7URCgd7/5z2dSHjd0tqm990S4a/133Nz5D7bi0wWBNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB7089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 11 Jun 2020 at 06:30, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> Currently indr setup supoort both indr_setup_ft_cb and indr_setup_tc_cb.
> But the __flow_block_indr_cleanup only check the indr_setup_tc_cb in
> mlx5e driver.
> It is better to just check the indr_release_cb, all the setup_cb type
> share the same release_cb.
>
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Hi wenxu,

With this series applied I'm getting several failures in our test suite.

First one is block->nooffloaddevcnt warning with following dmesg log:

[  760.667058] #####################################################
[  760.668186] ## TEST test-ecmp-add-vxlan-encap-disable-sriov.sh ##
[  760.669179] #####################################################
[  761.780655] :test: Fedora 30 (Thirty)
[  761.783794] :test: Linux reg-r-vrt-018-180 5.7.0+
[  761.822890] :test: NIC ens1f0 FW 16.26.6000 PCI 0000:81:00.0 DEVICE 0x1019 ConnectX-5 Ex
[  761.860244] mlx5_core 0000:81:00.0 ens1f0: Link up
[  761.880693] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  762.059732] mlx5_core 0000:81:00.1 ens1f1: Link up
[  762.234341] :test: unbind vfs of ens1f0
[  762.257825] :test: Change ens1f0 eswitch (0000:81:00.0) mode to switchdev
[  762.291363] :test: unbind vfs of ens1f1
[  762.306914] :test: Change ens1f1 eswitch (0000:81:00.1) mode to switchdev
[  762.309237] mlx5_core 0000:81:00.1: E-Switch: Disable: mode(LEGACY), nvfs(2), active vports(3)
[  763.282598] mlx5_core 0000:81:00.1: E-Switch: Supported tc offload range - chains: 4294967294, prios: 4294967295
[  763.362825] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  763.444465] mlx5_core 0000:81:00.1 ens1f1: renamed from eth0
[  763.460088] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  763.502586] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  763.552429] ens1f1_0: renamed from eth0
[  763.569569] mlx5_core 0000:81:00.1: E-Switch: Enable: mode(OFFLOADS), nvfs(2), active vports(3)
[  763.629694] ens1f1_1: renamed from eth1
[  764.631552] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_0: link becomes ready
[  764.670841] :test: unbind vfs of ens1f0
[  764.681966] :test: unbind vfs of ens1f1
[  764.726762] mlx5_core 0000:81:00.0 ens1f0: Link up
[  764.766511] mlx5_core 0000:81:00.1 ens1f1: Link up
[  764.797325] :test: Add multipath vxlan encap rule and disable sriov
[  764.798544] :test: config multipath route
[  764.812732] mlx5_core 0000:81:00.0: lag map port 1:2 port 2:2
[  764.874556] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  765.603681] :test: OK
[  765.659048] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_1: link becomes ready
[  765.675085] :test: verify rule in hw
[  765.694237] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  765.711892] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  766.979230] :test: OK
[  768.125419] :test: OK
[  768.127519] :test: - disable sriov ens1f1
[  768.131160] pci 0000:81:02.2: Removing from iommu group 75
[  768.132646] pci 0000:81:02.3: Removing from iommu group 76
[  769.179749] mlx5_core 0000:81:00.1: E-Switch: Disable: mode(OFFLOADS), nvfs(2), active vports(3)
[  769.455627] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:1
[  769.703990] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  769.988637] mlx5_core 0000:81:00.1 ens1f1: renamed from eth0
[  769.990022] :test: - disable sriov ens1f0
[  769.994922] pci 0000:81:00.2: Removing from iommu group 73
[  769.997048] pci 0000:81:00.3: Removing from iommu group 74
[  771.035813] mlx5_core 0000:81:00.0: E-Switch: Disable: mode(OFFLOADS), nvfs(2), active vports(3)
[  771.339091] ------------[ cut here ]------------
[  771.340812] WARNING: CPU: 6 PID: 3448 at net/sched/cls_api.c:749 tcf_block_offload_unbind.isra.0+0x5c/0x60
[  771.341728] Modules linked in: act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mlxfw act_ct nf_flow_table kvm_intel nf_nat kvm nf_conntrack irqbypass crct10dif_pclmul igb crc32_pclmul nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 crc32c_intel ghash_clmulni_intel ptp ipmi_ssif intel_cstate pps_c
ore ses intel_uncore mei_me iTCO_wdt joydev ipmi_si iTCO_vendor_support i2c_i801 enclosure mei ioatdma dca lpc_ich wmi ipmi_devintf pcspkr acpi_power_meter ipmi_msghandler acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  771.347818] CPU: 6 PID: 3448 Comm: test-ecmp-add-v Not tainted 5.7.0+ #1146
[  771.348727] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  771.349646] RIP: 0010:tcf_block_offload_unbind.isra.0+0x5c/0x60
[  771.350553] Code: 4a fd ff ff 83 f8 a1 74 0e 5b 4c 89 e7 5d 41 5c 41 5d e9 07 93 89 ff 8b 83 a0 00 00 00 8d 50 ff 89 93 a0 00 00 00 85 c0 75 df <0f> 0b eb db 0f 1f 44 00 00 41 57 41 56 41 55 41 89 cd 41 54 49 89
[  771.352420] RSP: 0018:ffffb33144cd3b00 EFLAGS: 00010246
[  771.353353] RAX: 0000000000000000 RBX: ffff8b37cf4b2800 RCX: 0000000000000000
[  771.354294] RDX: 00000000ffffffff RSI: ffff8b3b9aad0000 RDI: ffffffff8d5c6e20
[  771.355245] RBP: ffff8b37eb546948 R08: ffffffffc0b7a348 R09: ffff8b3b9aad0000
[  771.356189] R10: 0000000000000001 R11: ffff8b3ba7a0a1c0 R12: ffff8b37cf4b2850
[  771.357123] R13: ffff8b3b9aad0000 R14: ffff8b37cf4b2820 R15: ffff8b37cf4b2820
[  771.358039] FS:  00007f8a19b6e740(0000) GS:ffff8b3befa00000(0000) knlGS:0000000000000000
[  771.358965] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  771.359885] CR2: 00007f3afb91c1a0 CR3: 000000045133c004 CR4: 00000000001606e0
[  771.360825] Call Trace:
[  771.361764]  __tcf_block_put+0x84/0x150
[  771.362712]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  771.363658]  qdisc_destroy+0x3e/0xc0
[  771.364594]  dev_shutdown+0x7a/0xa5
[  771.365522]  rollback_registered_many+0x20d/0x530
[  771.366458]  ? netdev_upper_dev_unlink+0x15d/0x1c0
[  771.367387]  unregister_netdevice_many.part.0+0xf/0x70
[  771.368310]  vxlan_netdevice_event+0xa4/0x110 [vxlan]
[  771.369454]  notifier_call_chain+0x4c/0x70
[  771.370579]  rollback_registered_many+0x2f5/0x530
[  771.371719]  rollback_registered+0x56/0x90
[  771.372843]  unregister_netdevice_queue+0x73/0xb0
[  771.373982]  unregister_netdev+0x18/0x20
[  771.375168]  mlx5e_vport_rep_unload+0x56/0xc0 [mlx5_core]
[  771.376327]  esw_offloads_disable+0x81/0x90 [mlx5_core]
[  771.377512]  mlx5_eswitch_disable_locked.cold+0xcb/0x1af [mlx5_core]
[  771.378679]  mlx5_eswitch_disable+0x44/0x60 [mlx5_core]
[  771.379822]  mlx5_device_disable_sriov+0xad/0xb0 [mlx5_core]
[  771.380968]  mlx5_core_sriov_configure+0xc1/0xe0 [mlx5_core]
[  771.382087]  sriov_numvfs_store+0xfc/0x130
[  771.383195]  kernfs_fop_write+0xce/0x1b0
[  771.384302]  vfs_write+0xb6/0x1a0
[  771.385410]  ksys_write+0x5f/0xe0
[  771.386500]  do_syscall_64+0x5b/0x1d0
[  771.387569]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  771.388626] RIP: 0033:0x7f8a19c5d0f8
[  771.389652] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 25 96 0d 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 60 c3 0f 1f 80 00 00 00 00 48 83 ec 28 48 89
[  771.391753] RSP: 002b:00007ffe304c5838 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  771.392785] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f8a19c5d0f8
[  771.393795] RDX: 0000000000000002 RSI: 0000556555968700 RDI: 0000000000000001
[  771.394779] RBP: 0000556555968700 R08: 00000000ffffffff R09: 000000000000000a
[  771.395736] R10: 0000556555989080 R11: 0000000000000246 R12: 0000000000000002
[  771.396682] R13: 00007f8a19d32780 R14: 0000000000000002 R15: 00007f8a19d2d740
[  771.397614] ---[ end trace 27ef08fb29ae2829 ]---
[  771.619221] mlx5_core 0000:81:00.0: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  771.871734] mlx5_core 0000:81:00.0 ens1f0: renamed from eth0
[  771.872730] :test: - enable sriov ens1f0
[  771.889195] mlx5_core 0000:81:00.0: E-Switch: Enable: mode(LEGACY), nvfs(2), active vports(3)
[  771.995275] pci 0000:81:00.2: [15b3:101a] type 00 class 0x020000
[  771.996685] pci 0000:81:00.2: enabling Extended Tags
[  771.999261] pci 0000:81:00.2: Adding to iommu group 73
[  772.000895] mlx5_core 0000:81:00.2: enabling device (0000 -> 0002)
[  772.002317] mlx5_core 0000:81:00.2: firmware version: 16.26.6000
[  772.266185] mlx5_core 0000:81:00.2: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  772.291676] mlx5_core 0000:81:00.2: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  772.457280] mlx5_core 0000:81:00.2 ens1f0np0v0: renamed from eth0
[  772.468203] pci 0000:81:00.3: [15b3:101a] type 00 class 0x020000
[  772.469187] pci 0000:81:00.3: enabling Extended Tags
[  772.471229] pci 0000:81:00.3: Adding to iommu group 74
[  772.472343] mlx5_core 0000:81:00.3: enabling device (0000 -> 0002)
[  772.473812] mlx5_core 0000:81:00.3: firmware version: 16.26.6000
[  772.732455] mlx5_core 0000:81:00.3: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  772.758153] mlx5_core 0000:81:00.3: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  772.924349] mlx5_core 0000:81:00.3 ens1f0np0v1: renamed from eth0
[  773.033980] :test: ERROR: Detected errors in the log
[  773.056361] :test: ERROR: TEST FAILED


Second one is a list corruption in mlx5:

[  815.444696] ##################################
[  815.445843] ## TEST test-ecmp-rule-stats.sh ##
[  815.446907] ##################################
[  816.638976] :test: Fedora 30 (Thirty)
[  816.644307] :test: Linux reg-r-vrt-018-180 5.7.0+
[  816.697938] :test: NIC ens1f0 FW 16.26.6000 PCI 0000:81:00.0 DEVICE 0x1019 ConnectX-5 Ex
[  816.731794] mlx5_core 0000:81:00.0 ens1f0: Link up
[  816.749621] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  816.915999] mlx5_core 0000:81:00.1 ens1f1: Link up
[  817.094362] :test: unbind vfs of ens1f0
[  817.110148] :test: Change ens1f0 eswitch (0000:81:00.0) mode to switchdev
[  817.136297] :test: unbind vfs of ens1f1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          [  817.152025] :test: Change ens1f1 eswitch (0000:81:00.1) mode to switchdev
[  817.154771] mlx5_core 0000:81:00.1: E-Switch: Disable: mode(LEGACY), nvfs(2), active vports(3)
[  818.108242] mlx5_core 0000:81:00.1: E-Switch: Supported tc offload range - chains: 4294967294, prios: 4294967295
[  818.192932] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  818.282515] mlx5_core 0000:81:00.1 ens1f1: renamed from eth0
[  818.300305] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  818.346376] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  818.399141] ens1f1_0: renamed from eth0
[  818.413829] mlx5_core 0000:81:00.1: E-Switch: Enable: mode(OFFLOADS), nvfs(2), active vports(3)
[  818.468683] ens1f1_1: renamed from eth1
[  819.476990] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_0: link becomes ready
[  819.515915] :test: unbind vfs of ens1f0
[  819.526618] :test: unbind vfs of ens1f1
[  819.574644] mlx5_core 0000:81:00.0 ens1f0: Link up
[  819.614459] mlx5_core 0000:81:00.1 ens1f1: Link up
[  819.632795] :test: test_ecmp_rule_stats
[  819.634208] :test: config multipath route
[  819.648547] mlx5_core 0000:81:00.0: lag map port 1:2 port 2:2
[  819.709057] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  820.436795] :test: OK
[  820.442020] :test: bind vfs of ens1f0
[  820.449123] mlx5_core 0000:81:00.2: enabling device (0000 -> 0002)
[  820.450491] mlx5_core 0000:81:00.2: firmware version: 16.26.6000
[  820.507714] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_1: link becomes ready
[  820.526056] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  820.543646] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  820.752858] mlx5_core 0000:81:00.2: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  820.778347] mlx5_core 0000:81:00.2: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  820.913209] mlx5_core 0000:81:00.2 ens1f0np0v0: renamed from eth0
[  820.927999] mlx5_core 0000:81:00.3: enabling device (0000 -> 0002)
[  820.929165] mlx5_core 0000:81:00.3: firmware version: 16.26.6000
[  821.228167] mlx5_core 0000:81:00.3: Rate limit: 127 rates are supported, range: 0Mbps to 97656Mbps
[  821.253696] mlx5_core 0000:81:00.3: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  821.393251] mlx5_core 0000:81:00.3 ens1f0np0v1: renamed from eth0
[  821.433875] :test: -- both ports up
[  821.512444] mlx5_core 0000:81:00.2 ens1f0np0v0: Link up
[  821.530699] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0np0v0: link becomes ready
[  821.608883] :test: -- starts with 0
[  821.729947] :test: -- ping and expect 100 packets
[  833.839721] :test: OK
[  833.841320] :test: -- port0 down
[  833.885179] mlx5_core 0000:81:00.0: modify lag map port 1:2 port 2:2
[  835.886923] :test: -- ping and expect 200 packets
[  847.955471] :test: OK
[  847.956919] :test: -- port0 up
[  847.976352] mlx5_core 0000:81:00.0 ens1f0: Link up
[  847.978939] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:1
[  847.980368] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  847.994343] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  848.988277] :test: -- port1 down
[  849.032642] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:1
[  851.034696] :test: -- ping and expect 300 packets
[  863.100660] :test: OK
[  863.102038] :test: -- port1 up
[  863.140155] mlx5_core 0000:81:00.1 ens1f1: Link up
[  863.142867] mlx5_core 0000:81:00.0: modify lag map port 1:2 port 2:2
[  863.144391] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  863.213571] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  863.317213] ------------[ cut here ]------------
[  863.317999] list_del corruption. prev->next should be ffff8b3bde16c100, but was 00001a0000001400
[  863.318651] WARNING: CPU: 18 PID: 5595 at lib/list_debug.c:51 __list_del_entry_valid+0x79/0x90
[  863.319270] Modules linked in: act_gact act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mlxfw act_ct nf_flow_table kvm_intel nf_nat kvm nf_conntrack irqbypass crct10dif_pclmul igb crc32_pclmul nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 crc32c_intel ghash_clmulni_intel ptp ipmi_ssif intel_cst
ate pps_core ses intel_uncore mei_me iTCO_wdt joydev ipmi_si iTCO_vendor_support i2c_i801 enclosure mei ioatdma dca lpc_ich wmi ipmi_devintf pcspkr acpi_power_meter ipmi_msghandler acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  863.324144] CPU: 18 PID: 5595 Comm: ip Tainted: G        W         5.7.0+ #1146
[  863.324891] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  863.326405] Code: c3 48 89 fe 4c 89 c2 48 c7 c7 88 b2 19 8d e8 30 b3 bd ff 0f 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 c0 b2 19 8d e8 19 b3 bd ff <0f> 0b 31 c0 c3 48 c7 c7 00 b3 19 8d e8 08 b3 bd ff 0f 0b 31 c0 c3
[  863.327995] RSP: 0018:ffffb331463f76d0 EFLAGS: 00010286
[  863.328791] RAX: 0000000000000000 RBX: ffffb331463f7760 RCX: 0000000000000000
[  863.329591] RDX: ffff8b3befba7f60 RSI: ffff8b3befb99d80 RDI: ffff8b3befb99d80
[  863.330406] RBP: ffff8b3bde16c100 R08: ffff8b3befb99d80 R09: 00000000000007cb
[  863.331204] R10: 0000000000000001 R11: ffffffff8cedecc0 R12: ffff8b3bde16c110
[  863.332008] R13: ffffb331463f7780 R14: ffffb331463f7780 R15: ffffb331463f7760
[  863.332811] FS:  00007efcb929ce40(0000) GS:ffff8b3befb80000(0000) knlGS:0000000000000000
[  863.333617] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  863.334419] CR2: 00000000004cffc0 CR3: 000000081d85c005 CR4: 00000000001606e0
[  863.335226] Call Trace:
[  863.336097]  mlx5e_rep_indr_setup_block+0x106/0x2d0 [mlx5_core]
[  863.336914]  flow_indr_dev_setup_offload+0x57/0x160
[  863.337717]  ? tcf_block_unbind+0xe0/0xe0
[  863.338519]  tcf_block_offload_cmd.isra.0+0x23f/0x280
[  863.339327]  tcf_block_offload_unbind.isra.0+0x36/0x60
[  863.340146]  __tcf_block_put+0x84/0x150
[  863.340949]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  863.341748]  qdisc_destroy+0x3e/0xc0
[  863.342543]  dev_shutdown+0x7a/0xa5
[  863.343339]  rollback_registered_many+0x20d/0x530
[  863.344139]  ? netdev_upper_dev_unlink+0x15d/0x1c0
[  863.344938]  unregister_netdevice_many.part.0+0xf/0x70
[  863.345749]  rtnl_delete_link+0x47/0x70
[  863.346551]  rtnl_dellink+0xf1/0x300
[  863.347343]  ? rtnl_getlink+0x304/0x3b0
[  863.348129]  rtnetlink_rcv_msg+0x2b0/0x360
[  863.348911]  ? copyout+0x22/0x30
[  863.349684]  ? _copy_to_iter+0xa1/0x410
[  863.350481]  ? _cond_resched+0x15/0x30
[  863.351254]  ? rtnl_calcit.isra.0+0x110/0x110
[  863.352028]  netlink_rcv_skb+0x49/0x110
[  863.352807]  netlink_unicast+0x191/0x230
[  863.353574]  netlink_sendmsg+0x243/0x480
[  863.354333]  sock_sendmsg+0x5e/0x60
[  863.355077]  ____sys_sendmsg+0x1f3/0x260
[  863.355809]  ? copy_msghdr_from_user+0x5c/0x90
[  863.356522]  ___sys_sendmsg+0x81/0xc0
[  863.357216]  ? wp_page_copy+0x310/0xb10
[  863.357887]  ? __wake_up_common_lock+0x8a/0xc0
[  863.358535]  ? fsnotify_grab_connector+0x4a/0x80
[  863.359164]  __sys_sendmsg+0x59/0xa0
[  863.359789]  do_syscall_64+0x5b/0x1d0
[  863.360368]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  863.360943] RIP: 0033:0x7efcb94657b8
[  863.361506] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  863.362677] RSP: 002b:00007fff72f4fba8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  863.363249] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007efcb94657b8
[  863.363818] RDX: 0000000000000000 RSI: 00007fff72f4fc20 RDI: 0000000000000003
[  863.364384] RBP: 000000005ee1e8cf R08: 0000000000000001 R09: 00007efcb9529cc0
[  863.364948] R10: fffffffffffffca3 R11: 0000000000000246 R12: 0000000000000001
[  863.365515] R13: 00007fff72f503b0 R14: 00007fff72f516ff R15: 0000000000485540
[  863.366078] ---[ end trace 27ef08fb29ae282a ]---
[  863.366653] ------------[ cut here ]------------
[  863.367208] list_del corruption. prev->next should be ffff8b3bde16cc00, but was dead000000000100
[  863.367780] WARNING: CPU: 18 PID: 5595 at lib/list_debug.c:51 __list_del_entry_valid+0x79/0x90
[  863.368348] Modules linked in: act_gact act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp mlxfw act_ct nf_flow_table kvm_intel nf_nat kvm nf_conntrack irqbypass crct10dif_pclmul igb crc32_pclmul nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 crc32c_intel ghash_clmulni_intel ptp ipmi_ssif intel_cstate pps_core ses intel_uncore mei_me iTCO_wdt joydev ipmi_si iTCO_vendor_support i2c_i801 enclosure mei ioatdma dca lpc_ich wmi ipmi_devintf pcspkr acpi_power_meter ipmi_msghandler acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  863.372861] CPU: 18 PID: 5595 Comm: ip Tainted: G        W         5.7.0+ #1146
[  863.373563] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  863.374273] RIP: 0010:__list_del_entry_valid+0x79/0x90
[  863.374987] Code: c3 48 89 fe 4c 89 c2 48 c7 c7 88 b2 19 8d e8 30 b3 bd ff 0f 0b 31 c0 c3 48 89 f2 48 89 fe 48 c7 c7 c0 b2 19 8d e8 19 b3 bd ff <0f> 0b 31 c0 c3 48 c7 c7 00 b3 19 8d e8 08 b3 bd ff 0f 0b 31 c0 c3
[  863.376489] RSP: 0018:ffffb331463f76d0 EFLAGS: 00010286
[  863.377248] RAX: 0000000000000000 RBX: ffffb331463f7760 RCX: 0000000000000027
[  863.378015] RDX: 0000000000000027 RSI: 0000000000000082 RDI: ffff8b3befb99d88
[  863.378789] RBP: ffff8b3bde16cc00 R08: ffff8b3befb99d80 R09: 0000000000000807
[  863.379571] R10: 0000000000000001 R11: ffffffff8cedecc0 R12: ffff8b3bde16cc10
[  863.380372] R13: ffff8b3bde16c110 R14: ffffb331463f7780 R15: ffffb331463f7760
[  863.381162] FS:  00007efcb929ce40(0000) GS:ffff8b3befb80000(0000) knlGS:0000000000000000
[  863.381966] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  863.382775] CR2: 00000000004cffc0 CR3: 000000081d85c005 CR4: 00000000001606e0
[  863.383595] Call Trace:
[  863.384436]  mlx5e_rep_indr_setup_block+0x106/0x2d0 [mlx5_core]
[  863.385274]  flow_indr_dev_setup_offload+0x57/0x160
[  863.386115]  ? tcf_block_unbind+0xe0/0xe0
[  863.386958]  tcf_block_offload_cmd.isra.0+0x23f/0x280
[  863.387805]  tcf_block_offload_unbind.isra.0+0x36/0x60
[  863.388653]  __tcf_block_put+0x84/0x150
[  863.389497]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  863.390362]  qdisc_destroy+0x3e/0xc0
[  863.391212]  dev_shutdown+0x7a/0xa5
[  863.392057]  rollback_registered_many+0x20d/0x530
[  863.392907]  ? netdev_upper_dev_unlink+0x15d/0x1c0
[  863.393765]  unregister_netdevice_many.part.0+0xf/0x70
[  863.394621]  rtnl_delete_link+0x47/0x70
[  863.395472]  rtnl_dellink+0xf1/0x300
[  863.396302]  ? rtnl_getlink+0x304/0x3b0
[  863.397114]  rtnetlink_rcv_msg+0x2b0/0x360
[  863.397915]  ? copyout+0x22/0x30
[  863.398704]  ? _copy_to_iter+0xa1/0x410
[  863.399490]  ? _cond_resched+0x15/0x30
[  863.400285]  ? rtnl_calcit.isra.0+0x110/0x110
[  863.401063]  netlink_rcv_skb+0x49/0x110
[  863.401837]  netlink_unicast+0x191/0x230
[  863.402600]  netlink_sendmsg+0x243/0x480
[  863.403360]  sock_sendmsg+0x5e/0x60
[  863.404105]  ____sys_sendmsg+0x1f3/0x260
[  863.404838]  ? copy_msghdr_from_user+0x5c/0x90
[  863.405553]  ___sys_sendmsg+0x81/0xc0
[  863.406247]  ? wp_page_copy+0x310/0xb10
[  863.406915]  ? __wake_up_common_lock+0x8a/0xc0
[  863.407566]  ? fsnotify_grab_connector+0x4a/0x80
[  863.408197]  __sys_sendmsg+0x59/0xa0
[  863.408806]  do_syscall_64+0x5b/0x1d0
[  863.409388]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  863.409977] RIP: 0033:0x7efcb94657b8
[  863.410543] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  863.411721] RSP: 002b:00007fff72f4fba8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  863.412297] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007efcb94657b8
[  863.412868] RDX: 0000000000000000 RSI: 00007fff72f4fc20 RDI: 0000000000000003
[  863.413435] RBP: 000000005ee1e8cf R08: 0000000000000001 R09: 00007efcb9529cc0
[  863.414003] R10: fffffffffffffca3 R11: 0000000000000246 R12: 0000000000000001
[  863.414563] R13: 00007fff72f503b0 R14: 00007fff72f516ff R15: 0000000000485540
[  863.415124] ---[ end trace 27ef08fb29ae282b ]---
[  864.449904] :test: unbind vfs of ens1f0
[  866.264465] :test: unbind vfs of ens1f1
[  866.275639] :test: unbind vfs of ens1f1
[  866.291734] :test: Change ens1f1 eswitch (0000:81:00.1) mode to legacy
[  866.297496] mlx5_core 0000:81:00.1: E-Switch: Disable: mode(OFFLOADS), nvfs(2), active vports(3)
[  866.801978] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  867.097835] mlx5_core 0000:81:00.1 ens1f1: renamed from eth0
[  867.102023] mlx5_core 0000:81:00.1: E-Switch: Enable: mode(LEGACY), nvfs(2), active vports(3)
[  868.187531] :test: ERROR: Detected errors in the log
[  868.208891] :test: ERROR: TEST FAILED


You can find the tests here: https://github.com/Mellanox/ovs-tests

Regards,
Vlad
