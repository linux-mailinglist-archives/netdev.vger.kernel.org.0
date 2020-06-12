Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F38D1F79B8
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 16:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgFLOXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 10:23:34 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:19268
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgFLOXd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 10:23:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3qwJaI3qm9JlNbOABLKPdJexrDUHJidCnJxRNpaokepgNUya1YiQsXs8xlE+80hu9oR//gdLSE+RxiaPZksoPhrNa3ViKxgtMCvXdwC4Lp6FChX3uE+tYHQGjWPOkkaW51BYo6Dwb6KuLp1yp3LFPjNIAjBTlhMn5rG2kPzyl6Jg9VGwAJBVQZ0VF0uKGHyb2+yOEDZOr7UmbLOz933ozWr9VWBftHZOXMiu3rHc72q43KRiEF3c62uLI/7/DpyuP20svXoxN3cfynMj01ErduvA3Dg7eR7XzIwsdQn+rMfEmktA6L/I2zAiimYSJ415QSL20jsCGHx8Mc9sIlUOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/HQkiWTwU+7cDdM8GwMBMK8N0BQQDNF8rFD/9cbh8o=;
 b=CavRVJYLYyC50GL/aevXEgDwaVho0f2pX2O3btxNZ/8gdkieY2IO99XyZosS2wCTZsB1afyDulH9s9iDhwfi6EQXDNc6YB6LFJDLEr277OxN2BRfT051DpRJuFUSO5KecYSEf7qI89OtRE78W+68m5WWrWBSoq7e/8nDYZoeWq4rJ+IN5PfIMSb9XQ2A0ksdc2whBg99zhhBBdlSXcEVNmMyY/ezCKKLQFY0mccFp6RpdZ1GXNw/9cufWqWe/sdUi1SicclZIJ3k1No35mAKuUmdTS0LChz6EDrRsB60BzTKtL3FnkHDulj+JdnK/eLVax3ptux5s5PSB90mqIaQ1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/HQkiWTwU+7cDdM8GwMBMK8N0BQQDNF8rFD/9cbh8o=;
 b=I0wMPxiAgh+ZfCYKN+2qOmWoXkO1Ymd8JiXFUoY+a7rhO0ldZ1f/4ERpr9ON8m0fM7SN1Eg+fp6w5FFThTpOowcFb6iHqWdr/EqxSTCuFUm4mWZcbzuZQ6bYRx7XfetzPcRxvxZhN7pouM5jbVIwrLJSEmmO5bindxQcBL91n5E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6882.eurprd05.prod.outlook.com (2603:10a6:20b:1a0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Fri, 12 Jun
 2020 14:23:28 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::8ca0:e31e:6890:3724%3]) with mapi id 15.20.3088.025; Fri, 12 Jun 2020
 14:23:27 +0000
References: <1591894327-11915-1-git-send-email-wenxu@ucloud.cn>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v3 1/2] flow_offload: fix incorrect cleanup for indirect flow_blocks
In-reply-to: <1591894327-11915-1-git-send-email-wenxu@ucloud.cn>
Date:   Fri, 12 Jun 2020 17:23:24 +0300
Message-ID: <vbftuzgicrn.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::18) To AM7PR05MB6995.eurprd05.prod.outlook.com
 (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Fri, 12 Jun 2020 14:23:27 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 49a12d96-9262-4f10-d014-08d80edc2ca1
X-MS-TrafficTypeDiagnostic: AM7PR05MB6882:
X-Microsoft-Antispam-PRVS: <AM7PR05MB68824643926B51850D2B99DBAD810@AM7PR05MB6882.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0432A04947
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZuY3P9SKLsBofJ0u4IAwAsfxxQEWFiLXOd36jxxDLfJT3QTaUe5dW2mnoHBmIjB9rXWVS/O47tiBIhEIjGZpBWsxWLihLUjvJ01K/SBvJOEd1S5hfiErNWG4ZQKIvcXzQaaMc1a2ot+3BIa+hfY8HbRGbS67y6/0L9nlvoDPzVQO1WH6ZpFz/0LetdY/c5xLXNSh6RPa7HCa0U8xTI6buR9WcYS972ToVpiNISnpZ9g9KMyhugGVGbJIs9BpxIEBVUAex2SGOX8OV752J3+VwezfA6LVCV9bfmmORwa5hWERF8nuYMCXKqeBwetg3yH27U8MIQ7mT6U7kRYut4Hfk3qxq1h4lLtp5U1kA+tbQzx8RZ0ibT4xnPg8RWIvTMsx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(52116002)(6486002)(16526019)(186003)(316002)(4326008)(26005)(2616005)(7696005)(956004)(66946007)(86362001)(5660300002)(36756003)(83380400001)(8676002)(8936002)(6666004)(30864003)(2906002)(45080400002)(478600001)(66476007)(66556008)(6916009)(4226003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: SD5nr+dGuBYDwbTueEfJinFsGtKDLA5ApL3WSl7tCBNp9P62S3G+3ljT3X7TDCykAcfN6GPKBzNTcYUbEdJh3qEZEHg3tTwATVV/6AJXFuFKqXQa+9lHH982S3medX4ZUsc7kcOJ/JvxDFXwskAI3qB0xzzTe+E6Ia2yDx0Is6wLpHBjwtxaJJe2p7ESm90toL8snecDv56p1a/Npuf7EOw7R6rlpuHwzRLeQ4cDciQmJVRZKZCkjmX2FI2xKvNBdk+KINSKvCIJrwiWVY3IwIBYR75KthkfiVbQ9d+4lk2VhS8CcD0q3NY1i9phHZOzKHmye9A95mbCKIiHZJ6a3bY4oHXYokKrnxKUy7b/pNShthxk3dNsXS5nzMF4/qwODbobIN9UAwFXhrtJn0bc+aLG+7iyrG3WkycTJLRuR/Czl8rc6/oGkk7CmWJKqUnggbYWI+z8ZDZ2dV5+oLbFRJgDnG4uBtmcPmKYdm0qKEY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a12d96-9262-4f10-d014-08d80edc2ca1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2020 14:23:27.8844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ykgx/sUMi4hCxvgw+oAxqcCpfYKNzX71sJfbA2wrwrH0JV6OpPgSZb/QSJzWG4URti6B4xM9UJ1w9ORjvtzwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6882
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 11 Jun 2020 at 19:52, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> If the representor is removed, then identify the indirect
> flow_blocks that need to be removed by the release callback.
>
> Fixes: 1fac52da5942 ("net: flow_offload: consolidate indirect flow_block infrastructure")
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---

Hi wenxu,

With this series applied I get following list manipulation warnings
followed by NULL-pointer dereference in one of the tests:

[  521.784646] ####################################
[  521.785926] ## TEST test-ecmp-restore-rule.sh ##
[  521.787104] ####################################
[  522.967128] :test: Fedora 30 (Thirty)
[  522.971233] :test: Linux reg-r-vrt-018-180 5.7.0+
[  523.015770] :test: NIC ens1f0 FW 16.27.6008 PCI 0000:81:00.0 DEVICE 0x1019 ConnectX-5 Ex
[  523.044090] mlx5_core 0000:81:00.0 ens1f0: Link up
[  523.214128] mlx5_core 0000:81:00.1 ens1f1: Link up
[  523.225365] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  523.227661] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  523.396909] :test: unbind vfs of ens1f0
[  523.416515] :test: Change ens1f0 eswitch (0000:81:00.0) mode to switchdev
[  523.445505] :test: unbind vfs of ens1f1
[  523.463484] :test: Change ens1f1 eswitch (0000:81:00.1) mode to switchdev
[  523.467798] mlx5_core 0000:81:00.1: E-Switch: Disable: mode(LEGACY), nvfs(2), active vports(3)
[  524.433828] mlx5_core 0000:81:00.1: E-Switch: Supported tc offload range - chains: 4294967294, prios: 4294967295
[  524.517146] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  524.599812] mlx5_core 0000:81:00.1 ens1f1: renamed from eth0
[  524.620856] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  524.666250] mlx5_core 0000:81:00.1: MLX5E: StrdRq(1) RqSz(8) StrdSz(2048) RxCqeCmprss(0)
[  524.712324] ens1f1_0: renamed from eth0
[  524.734302] mlx5_core 0000:81:00.1: E-Switch: Enable: mode(OFFLOADS), nvfs(2), active vports(3)
[  524.767315] ens1f1_1: renamed from eth1
[  525.799619] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_0: link becomes ready
[  525.840549] :test: unbind vfs of ens1f0
[  525.850744] :test: unbind vfs of ens1f1
[  525.869147] ------------[ cut here ]------------
[  525.870064] list_add corruption. prev->next should be next (ffffffffc0826ce0), but was 2bbe836be6455630. (prev=ffff98a2cec42500).
[  525.871454] WARNING: CPU: 22 PID: 5290 at lib/list_debug.c:26 __list_add_valid+0x4d/0x70
[  525.872159] Modules linked in: act_gact act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac mlxfw x86_pkg_temp_thermal act_ct nf_flow_table intel_powerclamp nf_nat coretemp nf_conntrack kvm_intel kvm igb nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 irqbypass ptp ioatdma ses crct10dif_pclmul pps_core iTCO_wdt crc32_pclmul enclosure crc32c_intel ipmi_ssif iTCO_vendor_support joydev mei_me dca i2c_i801 mei ghash_clmulni_intel ipmi_si intel_cstate wmi lpc_ich ipmi_devintf intel_uncore pcspkr ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  525.877504] CPU: 22 PID: 5290 Comm: tc Not tainted 5.7.0+ #1152
[  525.878353] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  525.879222] RIP: 0010:__list_add_valid+0x4d/0x70
[  525.880088] Code: c3 4c 89 c1 48 c7 c7 78 b1 19 b0 e8 cf b3 bd ff 0f 0b 31 c0 c3 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 c8 b1 19 b0 e8 b5 b3 bd ff <0f> 0b 31 c0 c3 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 18 b2 19 b0 e8
[  525.881882] RSP: 0018:ffffbbe044ecb850 EFLAGS: 00010282
[  525.882777] RAX: 0000000000000000 RBX: ffff98a2cec42500 RCX: 0000000000000000
[  525.883670] RDX: ffff98a2efca7f60 RSI: ffff98a2efc99d80 RDI: ffff98a2efc99d80
[  525.883670] RDX: ffff98a2efca7f60 RSI: ffff98a2efc99d80 RDI: ffff98a2efc99d80
[  525.884565] RBP: ffff98a29960c800 R08: ffff98a2efc99d80 R09: 0000000000000725
[  525.885458] R10: 0000000000000001 R11: ffffffffafedecc0 R12: ffff98a2ed1c7980
[  525.886349] R13: ffffbbe044ecb900 R14: ffff98a2ed1c7990 R15: ffffbbe044ecb900
[  525.887231] FS:  00007fa9b95be480(0000) GS:ffff98a2efc80000(0000) knlGS:0000000000000000
[  525.888140] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  525.889039] CR2: 00007fa9b97df7a0 CR3: 000000082c7d8005 CR4: 00000000001606e0
[  525.889963] Call Trace:
[  525.890929]  mlx5e_rep_indr_setup_block+0x23a/0x2d0 [mlx5_core]
[  525.891867]  flow_indr_dev_setup_offload+0x57/0x160
[  525.892770]  ? tcf_block_unbind+0xe0/0xe0
[  525.893683]  tcf_block_offload_cmd.isra.0+0x23f/0x280
[  525.894589]  tcf_block_get_ext+0x207/0x4c0
[  525.895528]  ingress_init+0x70/0xa0 [sch_ingress]
[  525.896442]  qdisc_create+0x1b9/0x4d0
[  525.897347]  ? kmem_cache_alloc_trace+0x159/0x210
[  525.898262]  ? dev_ingress_queue_create+0x30/0x90
[  525.899154]  tc_modify_qdisc+0x126/0x740
[  525.900042]  rtnetlink_rcv_msg+0x2b0/0x360
[  525.900921]  ? copyout+0x22/0x30
[  525.901777]  ? _copy_to_iter+0xa1/0x410
[  525.902638]  ? _cond_resched+0x15/0x30
[  525.903479]  ? rtnl_calcit.isra.0+0x110/0x110
[  525.904326]  netlink_rcv_skb+0x49/0x110
[  525.905179]  netlink_unicast+0x191/0x230
[  525.905997]  netlink_sendmsg+0x243/0x480
[  525.906806]  sock_sendmsg+0x5e/0x60
[  525.907597]  ____sys_sendmsg+0x1f3/0x260
[  525.908392]  ? copy_msghdr_from_user+0x5c/0x90
[  525.909185]  ? ____sys_recvmsg+0xa7/0x180
[  525.909976]  ___sys_sendmsg+0x81/0xc0
[  525.910758]  ? filemap_map_pages+0x291/0x400
[  525.911507]  ? handle_mm_fault+0x15f2/0x1e00
[  525.912244]  __sys_sendmsg+0x59/0xa0
[  525.912968]  do_syscall_64+0x5b/0x1d0
[  525.913664]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  525.914337] RIP: 0033:0x7fa9b97847b8
[  525.914991] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  525.916340] RSP: 002b:00007ffd365b1d58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  525.916982] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa9b97847b8
[  525.917622] RDX: 0000000000000000 RSI: 00007ffd365b1dd0 RDI: 0000000000000003
[  525.918256] RBP: 000000005ee36c31 R08: 0000000000000001 R09: 00000000008ac9c0
[  525.918894] R10: 0000000000404fa8 R11: 0000000000000246 R12: 0000000000000001
[  525.919501] R13: 00007ffd365c2020 R14: 0000000000000000 R15: 00000000004866a0
[  525.920091] ---[ end trace 27bb705e50a7c6a4 ]---
[  525.920710] ------------[ cut here ]------------
[  525.921889] list_add corruption. prev->next should be next (ffffffffc0826ce0), but was 2bbe836be6455630. (prev=ffff98a2cec42500).
[  525.924309] WARNING: CPU: 11 PID: 5290 at lib/list_debug.c:26 __list_add_valid+0x4d/0x70
[  525.925565] Modules linked in: act_gact act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac mlxfw x86_pkg_temp_thermal act_ct nf_flow_table intel_powerclamp nf_nat coretemp nf_conntrack kvm_intel kvm igb nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 irqbypass ptp ioatdma ses crct10dif_pclmul pps_core iTCO_wdt crc32_pclmul enclosure crc32c_intel ipmi_ssif iTCO_vendor_support joydev mei_me dca i2c_i801 mei ghash_clmulni_intel ipmi_si intel_cstate wmi lpc_ich ipmi_devintf intel_uncore pcspkr ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  525.935182] CPU: 11 PID: 5290 Comm: tc Tainted: G        W         5.7.0+ #1152
[  525.936671] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  525.938148] RIP: 0010:__list_add_valid+0x4d/0x70
[  525.939631] Code: c3 4c 89 c1 48 c7 c7 78 b1 19 b0 e8 cf b3 bd ff 0f 0b 31 c0 c3 48 89 d1 4c 89 c6 4c 89 ca 48 c7 c7 c8 b1 19 b0 e8 b5 b3 bd ff <0f> 0b 31 c0 c3 48 89 f2 4c 89 c1 48 89 fe 48 c7 c7 18 b2 19 b0 e8
[  525.942744] RSP: 0018:ffffbbe044ecb850 EFLAGS: 00010282
[  525.944325] RAX: 0000000000000000 RBX: ffff98a2cec42500 RCX: 0000000000000000
[  525.945950] RDX: ffff98a2efb67f60 RSI: ffff98a2efb59d80 RDI: ffff98a2efb59d80
[  525.947547] RBP: ffff989eed19d800 R08: ffff98a2efb59d80 R09: 000000000000075c
[  525.949166] R10: 0000000000000001 R11: ffffffffafedecc0 R12: ffff98a2e7484880
[  525.950798] R13: ffff98a2ed1c7990 R14: ffff98a2e7484890 R15: ffffbbe044ecb900
[  525.952413] FS:  00007fa9b95be480(0000) GS:ffff98a2efb40000(0000) knlGS:0000000000000000
[  525.954084] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  525.955763] CR2: 00007f2fc46ebbf0 CR3: 000000082c7d8001 CR4: 00000000001606e0
[  525.957440] Call Trace:
[  525.959191]  mlx5e_rep_indr_setup_block+0x23a/0x2d0 [mlx5_core]
[  525.961037]  flow_indr_dev_setup_offload+0x57/0x160
[  525.962764]  ? tcf_block_unbind+0xe0/0xe0
[  525.964505]  tcf_block_offload_cmd.isra.0+0x23f/0x280
[  525.966244]  tcf_block_get_ext+0x207/0x4c0
[  525.967988]  ingress_init+0x70/0xa0 [sch_ingress]
[  525.969727]  qdisc_create+0x1b9/0x4d0
[  525.971457]  ? kmem_cache_alloc_trace+0x159/0x210
[  525.973216]  ? dev_ingress_queue_create+0x30/0x90
[  525.974964]  tc_modify_qdisc+0x126/0x740
[  525.976722]  rtnetlink_rcv_msg+0x2b0/0x360
[  525.978458]  ? copyout+0x22/0x30
[  525.980208]  ? _copy_to_iter+0xa1/0x410
[  525.981918]  ? _cond_resched+0x15/0x30
[  525.983583]  ? rtnl_calcit.isra.0+0x110/0x110
[  525.985216]  netlink_rcv_skb+0x49/0x110
[  525.986845]  netlink_unicast+0x191/0x230
[  525.988459]  netlink_sendmsg+0x243/0x480
[  525.990048]  sock_sendmsg+0x5e/0x60
[  525.991656]  ____sys_sendmsg+0x1f3/0x260
[  525.993243]  ? copy_msghdr_from_user+0x5c/0x90
[  525.994831]  ? ____sys_recvmsg+0xa7/0x180
[  525.996397]  ___sys_sendmsg+0x81/0xc0
[  525.997950]  ? filemap_map_pages+0x291/0x400
[  525.999437]  ? handle_mm_fault+0x15f2/0x1e00
[  526.000917]  __sys_sendmsg+0x59/0xa0
[  526.002355]  do_syscall_64+0x5b/0x1d0
[  526.003730]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  526.005090] RIP: 0033:0x7fa9b97847b8
[  526.006389] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  526.009053] RSP: 002b:00007ffd365b1d58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  526.010356] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa9b97847b8
[  526.011642] RDX: 0000000000000000 RSI: 00007ffd365b1dd0 RDI: 0000000000000003
[  526.012908] RBP: 000000005ee36c31 R08: 0000000000000001 R09: 00000000008ac9c0
[  526.014169] R10: 0000000000404fa8 R11: 0000000000000246 R12: 0000000000000001
[  526.015379] R13: 00007ffd365c2020 R14: 0000000000000000 R15: 00000000004866a0
[  526.016556] ---[ end trace 27bb705e50a7c6a5 ]---
[  526.025447] :test: test_restore_rule
[  526.026960] :test: config multipath route
[  526.043825] mlx5_core 0000:81:00.0 ens1f0: Link up
[  526.057844] mlx5_core 0000:81:00.1 ens1f1: Link up
[  526.063851] mlx5_core 0000:81:00.0: lag map port 1:2 port 2:2
[  526.103667] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  526.816682] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1_1: link becomes ready
[  526.832204] :test: OK
[  526.851599] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  526.869223] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  526.893771] :test: -- both ports up
[  526.894837] :test: add rule
[  528.008899] :test: OK
[  529.060487] :test: OK
[  529.118610] :test: -- port0 down
[  529.159987] mlx5_core 0000:81:00.0: modify lag map port 1:2 port 2:2
[  529.161377] :test: add rule
[  530.309132] :test: OK
[  531.365195] :test: OK
[  531.366387] :test: -- port0 up
[  531.395563] mlx5_core 0000:81:00.0 ens1f0: Link up
[  531.399867] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:1
[  531.402847] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  531.413342] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f0: link becomes ready
[  535.525947] :test: OK
[  536.580387] :test: OK
[  536.641604] :test: -- port1 down
[  536.683886] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:1
[  536.684212] :test: add rule
[  537.854675] :test: OK
[  538.938304] :test: OK
[  538.940384] :test: -- port1 up
[  538.961971] mlx5_core 0000:81:00.1 ens1f1: Link up
[  538.965176] IPv6: ADDRCONF(NETDEV_CHANGE): ens1f1: link becomes ready
[  538.966296] mlx5_core 0000:81:00.0: modify lag map port 1:2 port 2:2
[  538.968003] mlx5_core 0000:81:00.0: modify lag map port 1:1 port 2:2
[  542.081377] :test: OK
[  543.144289] :test: OK
[  543.277272] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  543.278051] #PF: supervisor read access in kernel mode
[  543.278514] #PF: error_code(0x0000) - not-present page
[  543.278958] PGD 800000044d344067 P4D 800000044d344067 PUD 455d97067 PMD 0
[  543.279363] Oops: 0000 [#1] SMP PTI
[  543.279729] CPU: 14 PID: 5423 Comm: ip Tainted: G        W         5.7.0+ #1152
[  543.280154] Hardware name: Supermicro SYS-2028TP-DECR/X10DRT-P, BIOS 2.0b 03/30/2017
[  543.280539] RIP: 0010:__list_del_entry_valid+0x25/0x90
[  543.280949] Code: c3 0f 1f 40 00 48 8b 17 4c 8b 47 08 48 b8 00 01 00 00 00 00 ad de 48 39 c2 74 26 48 b8 22 01 00 00 00 00 ad de 49 39 c0 74 2b <49> 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00
[  543.281811] RSP: 0018:ffffbbe04525b6d0 EFLAGS: 00010217
[  543.282261] RAX: dead000000000122 RBX: ffffbbe04525b760 RCX: ffff98a2ed1c7990
[  543.282680] RDX: 0000000000000000 RSI: ffffbbe04525b780 RDI: ffff98a2ed1c7980
[  543.283151] RBP: ffff98a2ed1c7980 R08: 0000000000000000 R09: ffffbbe04525b780
[  543.283575] R10: 0000000000000001 R11: ffff98a29b293ca0 R12: ffff98a2ed1c7990
[  543.284036] R13: ffffbbe04525b780 R14: ffffbbe04525b780 R15: ffffbbe04525b760
[  543.284477] FS:  00007fdba234ae40(0000) GS:ffff989eefc00000(0000) knlGS:0000000000000000
[  543.284935] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  543.285404] CR2: 0000000000000000 CR3: 0000000453d84004 CR4: 00000000001606e0
[  543.285845] Call Trace:
[  543.286313]  mlx5e_rep_indr_setup_block+0x106/0x2d0 [mlx5_core]
[  543.286762]  ? set_next_entity+0xab/0x1f0
[  543.287213]  flow_indr_dev_setup_offload+0x57/0x160
[  543.287670]  ? tcf_block_unbind+0xe0/0xe0
[  543.288129]  tcf_block_offload_cmd.isra.0+0x23f/0x280
[  543.288587]  tcf_block_offload_unbind.isra.0+0x36/0x60
[  543.289073]  __tcf_block_put+0x84/0x150
[  543.289544]  ingress_destroy+0x1b/0x20 [sch_ingress]
[  543.290008]  qdisc_destroy+0x3e/0xc0
[  543.290473]  dev_shutdown+0x7a/0xa5
[  543.290948]  rollback_registered_many+0x20d/0x530
[  543.291410]  ? netdev_upper_dev_unlink+0x15d/0x1c0
[  543.291879]  unregister_netdevice_many.part.0+0xf/0x70
[  543.292346]  rtnl_delete_link+0x47/0x70
[  543.292818]  rtnl_dellink+0xf1/0x300
[  543.293322]  ? rtnl_getlink+0x304/0x3b0
[  543.293788]  rtnetlink_rcv_msg+0x2b0/0x360
[  543.294249]  ? copyout+0x22/0x30
[  543.294703]  ? _copy_to_iter+0xa1/0x410
[  543.295162]  ? _cond_resched+0x15/0x30
[  543.295619]  ? rtnl_calcit.isra.0+0x110/0x110
[  543.296082]  netlink_rcv_skb+0x49/0x110
[  543.296543]  netlink_unicast+0x191/0x230
[  543.297027]  netlink_sendmsg+0x243/0x480
[  543.297496]  sock_sendmsg+0x5e/0x60
[  543.297946]  ____sys_sendmsg+0x1f3/0x260
[  543.298389]  ? copy_msghdr_from_user+0x5c/0x90
[  543.298839]  ___sys_sendmsg+0x81/0xc0
[  543.299282]  ? wp_page_copy+0x310/0xb10
[  543.299720]  ? __wake_up_common_lock+0x8a/0xc0
[  543.300157]  ? fsnotify_grab_connector+0x4a/0x80
[  543.300603]  __sys_sendmsg+0x59/0xa0
[  543.301066]  do_syscall_64+0x5b/0x1d0
[  543.301505]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  543.301923] RIP: 0033:0x7fdba25137b8
[  543.302331] Code: 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 65 8f 0c 00 8b 00 85 c0 75 17 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 48 83 ec 28 89 54
[  543.303171] RSP: 002b:00007fffd1568f78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  543.303588] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fdba25137b8
[  543.304005] RDX: 0000000000000000 RSI: 00007fffd1568ff0 RDI: 0000000000000003
[  543.304426] RBP: 000000005ee36c41 R08: 0000000000000001 R09: 00007fdba25d7cc0
[  543.304861] R10: fffffffffffffca3 R11: 0000000000000246 R12: 0000000000000001
[  543.305314] R13: 00007fffd1569780 R14: 00007fffd156a6ff R15: 0000000000485540
[  543.305733] Modules linked in: act_gact act_mirred act_tunnel_key cls_flower dummy vxlan ip6_udp_tunnel udp_tunnel sch_ingress nfsv3 nfs_acl nfs lockd grace fscache tun bridge stp llc sunrpc rdma_ucm rdma_cm iw_cm ib_cm mlx5_ib ib_uverbs ib_core mlx5_core intel_rapl_msr intel_rapl_common sb_edac mlxfw x86_pkg_temp_thermal act_ct nf_flow_table intel_powerclamp nf_nat coretemp nf_conntrack kvm_intel kvm igb nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 irqbypass ptp ioatdma ses crct10dif_pclmul pps_core iTCO_wdt crc32_pclmul enclosure crc32c_intel ipmi_ssif iTCO_vendor_support joydev mei_me dca i2c_i801 mei ghash_clmulni_intel ipmi_si intel_cstate wmi lpc_ich ipmi_devintf intel_uncore pcspkr ipmi_msghandler acpi_power_meter acpi_pad ast i2c_algo_bit drm_vram_helper drm_kms_helper drm_ttm_helper ttm drm mpt3sas raid_class scsi_transport_sas
[  543.309029] CR2: 0000000000000000
[  543.309557] ---[ end trace 27bb705e50a7c6a6 ]---
[  543.313014] RIP: 0010:__list_del_entry_valid+0x25/0x90
[  543.313614] Code: c3 0f 1f 40 00 48 8b 17 4c 8b 47 08 48 b8 00 01 00 00 00 00 ad de 48 39 c2 74 26 48 b8 22 01 00 00 00 00 ad de 49 39 c0 74 2b <49> 8b 30 48 39 fe 75 3a 48 8b 52 08 48 39 f2 75 48 b8 01 00 00 00
[  543.314714] RSP: 0018:ffffbbe04525b6d0 EFLAGS: 00010217
[  543.315319] RAX: dead000000000122 RBX: ffffbbe04525b760 RCX: ffff98a2ed1c7990
[  543.315885] RDX: 0000000000000000 RSI: ffffbbe04525b780 RDI: ffff98a2ed1c7980
[  543.316477] RBP: ffff98a2ed1c7980 R08: 0000000000000000 R09: ffffbbe04525b780
[  543.317065] R10: 0000000000000001 R11: ffff98a29b293ca0 R12: ffff98a2ed1c7990
[  543.317622] R13: ffffbbe04525b780 R14: ffffbbe04525b780 R15: ffffbbe04525b760
[  543.318241] FS:  00007fdba234ae40(0000) GS:ffff989eefc00000(0000) knlGS:0000000000000000
[  543.318815] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
