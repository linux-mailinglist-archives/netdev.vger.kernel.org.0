Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB4D691264
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 22:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBIVFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 16:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjBIVFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 16:05:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD3E469527
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 13:05:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpguZgmDML1K4590frm1d8T8Zt7sWhRyMjT0qQIZaJqfmLSho9w8AEntshm/RFq08CTohUA6En2Q1wBIxGJLrLynPlR87A1Ye/tzSO2jrwwjfzfcaQg8AfHkliAhWTF2z7Rw/T7XXMdsWDN/hVLY7OcbORGagV362KXSEtjlEdRlSjJqyBm6NJywGm1XlX63pLjXtfOA43JAr7k6MqzGI3Gzs2FruzBvcCE/xok/uRJ91DQyAWWjIp1E3XSRtEpR2bellE0qfXi1uC2w/PXvQLjuLoyqHu+51xhypLR4A5kfQN2It1giE+c0IfqSPvjDITDzewMHQOsGm5hi1PND6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O31I2DPEhZIEaPQERqxKaj90uV01qF7Kbi2OQAZ3HZA=;
 b=MjzzLnFK+ASwZvliPADKJQqau4PDbizTnqxqBzdug8Ll7LyPflqo2emJ3XTwZBbohhO4Nkzp7m89nRhHmxOIjRpz5XG4DnonC2t7MxZJKc7rSOHfDCfLdtCGz9t7Oibtbg2p/XpfZPG0r/jDqKGROKpJ3c22Wl3YczmE7XKEVPNkRYgkDVgJ9HDsCMKAiXGRff9Q7rwcoiep1Bes7+hBA5iRdYEcIQXQ3C+o0Yp4ryul1HOp+K9BCkc+v0qZXOXxXyZI8ba0LiA+T7HO1pzhL8ytdwr5V32sHTZqWuZHvWCeTMrK5iUbesK9cEjHZ3fSrbc2WrBrqGsoVIfpezkYfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=resnulli.us smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O31I2DPEhZIEaPQERqxKaj90uV01qF7Kbi2OQAZ3HZA=;
 b=NuehwbgA/6jIncEA+cKuEtCmQZkGFtr1h58PWrwlfld2BpEwzvkn11QsBDa6E/Kf44yavcxhpxL95sSP0VeX8lEMS+LWhCpYWcLDTZXa19fjR8th2j6Rok1ogHFoRulX51dgvSwqfXbfZpinZOhmPLqlOo94Gy1Pbb7ow+KA33Y=
Received: from DM6PR07CA0125.namprd07.prod.outlook.com (2603:10b6:5:330::7) by
 SJ0PR12MB8140.namprd12.prod.outlook.com (2603:10b6:a03:4e3::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.19; Thu, 9 Feb 2023 21:05:48 +0000
Received: from DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::8a) by DM6PR07CA0125.outlook.office365.com
 (2603:10b6:5:330::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19 via Frontend
 Transport; Thu, 9 Feb 2023 21:05:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT042.mail.protection.outlook.com (10.13.173.165) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 9 Feb 2023 21:05:47 +0000
Received: from [10.236.30.70] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 9 Feb
 2023 15:05:47 -0600
Message-ID: <81b9453b-87e4-c4d4-f083-bab9d7a85cbe@amd.com>
Date:   Thu, 9 Feb 2023 15:05:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <tariqt@nvidia.com>, <saeedm@nvidia.com>,
        <jacob.e.keller@intel.com>, <gal@nvidia.com>, <moshe@nvidia.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [patch net-next 0/7] devlink: params cleanups and
 devl_param_driverinit_value_get() fix
In-Reply-To: <20230209154308.2984602-1-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT042:EE_|SJ0PR12MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc0fcea-3512-4672-43e1-08db0ae16ae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zn+LCUR3eaKMOaxuBwSq3wptRAISPAR+AVZsKrcZyz5/H38Y3IN6NqcwGtnOU7ichJ4/LKsOa3/B98X3lg9Egi7hQEkdk51DsWVPdJRbT5Fh88ivCK+eYOZPvJ/nkwWi+mlxfNvFc6MHxCV9XV6Fwiah3GmIVGEMOk3qoGWkbK1F/TK/2pfDboWw72OuGQHpet0bGVCmGZmSCIKA171d7LtRJjAiRoWgnZ1lbB2uA4uD322gPvYI/ok0M0BJ7HDcGNbp4NNkIcvMPk7xAAsfWLf5l4Ow7T1xu+s0mkCWBoxWrPioVZCYhLpp43quRJZnDaDBBtOnCYuUhPVId48V5XhHap1olPqU7wgELMCCk93R9LA8YLOCbRGRBqyW10h3nluj8Pn7MF8u0fIDq+IrCI8AI6LpQkO76hoqHUNhQsCdJVX1Ny2hJ43CDC0v2vD1RwYtmXKP+9VhlxZfgjvyncQB/XUDsXU6e1v4FbSpcczmbULiu7iU6JjlSuTmahQsZw56AfKHcvtf+8M+/WyzMa4bvNROqTINGPrX/YrnnNaXoeOGjlW+4lNSMYIbW5vh01sd3unlelrlKWnb7aM0LyaBKcnisps8DgNjj6IQsR365FTARMqlbA1C2gDNrHpDsiLHjqCuKuC4GilCYeRVXkzVK+QIUECnvNxJV7aMuBPKT33xRCPFYdZ/mk0MIMqMk4O4LoMAE+KgPJd4sAqk0yQ2eSUrgpTB9wxU4kKZyB9XiKtSz+imSxlY1E3CdMX5cNQPgQiQ+NE8EyssQzAeeloEzdxbD3UMLqun2L902rA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(396003)(451199018)(40470700004)(46966006)(36840700001)(44832011)(2906002)(186003)(45080400002)(31696002)(7416002)(40460700003)(86362001)(426003)(16526019)(47076005)(2616005)(8936002)(81166007)(336012)(5660300002)(26005)(82310400005)(36756003)(53546011)(478600001)(31686004)(83380400001)(316002)(4326008)(41300700001)(16576012)(40480700001)(8676002)(36860700001)(70586007)(356005)(82740400003)(54906003)(70206006)(110136005)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 21:05:47.9343
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc0fcea-3512-4672-43e1-08db0ae16ae1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8140
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/9/23 9:43 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> The primary motivation of this patchset is the patch #6, which fixes an
> issue introduced by 075935f0ae0f ("devlink: protect devlink param list
> by instance lock") and reported by Kim Phillips <kim.phillips@amd.com>
> (https://lore.kernel.org/netdev/719de4f0-76ac-e8b9-38a9-167ae239efc7@amd.com/)
> and my colleagues doing mlx5 driver regression testing.

I can't provide my Tested-by because this series doesn't apply
cleanly to today's (or the original day's) linux-next tag, and
today's net-next/{master,main} (5131a053f292) won't boot on any
of my systems, whether or not this series is applied, with:

[   19.478836] ------------[ cut here ]------------
[   19.483474] kernel BUG at mm/usercopy.c:102!
[   19.487761] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   19.492988] CPU: 196 PID: 1903 Comm: systemd-udevd Not tainted 6.2.0-rc6+ #119
[   19.500204] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
[   19.508284] RIP: 0010:usercopy_abort+0x7f/0x81
[   19.512738] Code: 4c 0f 45 de 51 4c 89 d1 48 c7 c2 7b 66 b6 9c 57 48 c7 c6 a8 b4 b5 9c 48 c7 c7 b8 4b c0 9c 48 0f 45 f2 4c 89 da e8 1e 56 ff ff <0f> 0b 49 89 d8 4c 89 c9 44 89 ea 31 f6 48 c7 c7 c5 66 b6 9c e8 68
[   19.531484] RSP: 0018:ffffaeabdc8d3ad0 EFLAGS: 00010246
[   19.536708] RAX: 000000000000006b RBX: 0000000000000053 RCX: 0000000000000000
[   19.543833] RDX: 0000000000000000 RSI: 00000000ffdfffff RDI: 00000000ffffffff
[   19.550964] RBP: ffffaeabdc8d3ae8 R08: 0000000000000000 R09: ffffaeabdc8d3950
[   19.558088] R10: 0000000000000001 R11: 0000000000000001 R12: ffff93700bf72a80
[   19.565214] R13: 0000000000000001 R14: ffff93700bf72ad3 R15: 0000000000000040
[   19.572346] FS:  00007f2b4b275880(0000) GS:ffff938e80c00000(0000) knlGS:0000000000000000
[   19.580432] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.586177] CR2: 00007ffc48657b08 CR3: 000080108f998000 CR4: 0000000000350ee0
[   19.593300] Call Trace:
[   19.595746]  <TASK>
[   19.597853]  __check_heap_object+0x9f/0xe0
[   19.601950]  __check_object_size+0x1f7/0x220
[   19.606221]  simple_copy_to_iter+0x2f/0x60
[   19.610323]  __skb_datagram_iter+0x78/0x2e0
[   19.614507]  ? __pfx_simple_copy_to_iter+0x10/0x10
[   19.619300]  ? __skb_recv_datagram+0x8b/0xc0
[   19.623574]  skb_copy_datagram_iter+0x66/0xe0
[   19.627933]  netlink_recvmsg+0xd1/0x400
[   19.631772]  ? apparmor_socket_recvmsg+0x22/0x30
[   19.636391]  sock_recvmsg+0xaa/0xb0
[   19.639882]  ____sys_recvmsg+0x9b/0x200
[   19.643715]  ? import_iovec+0x1f/0x30
[   19.647379]  ? copy_msghdr_from_user+0x77/0xb0
[   19.651817]  ___sys_recvmsg+0x80/0xc0
[   19.655483]  ? __lock_acquire.isra.0+0x123/0x540
[   19.660102]  ? sched_clock+0xd/0x20
[   19.663595]  __sys_recvmsg+0x66/0xc0
[   19.667176]  __x64_sys_recvmsg+0x23/0x30
[   19.671099]  do_syscall_64+0x3f/0x90
[   19.674680]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   19.679731] RIP: 0033:0x7f2b4b8a9487
[   19.683311] Code: 64 89 02 48 c7 c0 ff ff ff ff eb c1 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2f 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
[   19.702057] RSP: 002b:00007ffc48657968 EFLAGS: 00000246 ORIG_RAX: 000000000000002f
[   19.709623] RAX: ffffffffffffffda RBX: 000055cb525ae070 RCX: 00007f2b4b8a9487
[   19.716755] RDX: 0000000000000000 RSI: 00007ffc48657a10 RDI: 0000000000000005
[   19.723888] RBP: 00007ffc48659b40 R08: 00000000ffffffff R09: 0000000000000020
[   19.731010] R10: 000055cb525ae818 R11: 0000000000000246 R12: 0000000000000000
[   19.738134] R13: 00007ffc48657af0 R14: 000055cb522372a0 R15: 000055cb525ae1c0
[   19.745262]  </TASK>
[   19.747453] Modules linked in:
[   19.750524] ---[ end trace 0000000000000000 ]---
[   19.755148] RIP: 0010:usercopy_abort+0x7f/0x81
[   19.759598] Code: 4c 0f 45 de 51 4c 89 d1 48 c7 c2 7b 66 b6 9c 57 48 c7 c6 a8 b4 b5 9c 48 c7 c7 b8 4b c0 9c 48 0f 45 f2 4c 89 da e8 1e 56 ff ff <0f> 0b 49 89 d8 4c 89 c9 44 89 ea 31 f6 48 c7 c7 c5 66 b6 9c e8 68
[   19.778347] RSP: 0018:ffffaeabdc8d3ad0 EFLAGS: 00010246
[   19.783571] RAX: 000000000000006b RBX: 0000000000000053 RCX: 0000000000000000
[   19.790703] RDX: 0000000000000000 RSI: 00000000ffdfffff RDI: 00000000ffffffff
[   19.797838] RBP: ffffaeabdc8d3ae8 R08: 0000000000000000 R09: ffffaeabdc8d3950
[   19.804971] R10: 0000000000000001 R11: 0000000000000001 R12: ffff93700bf72a80
[   19.812102] R13: 0000000000000001 R14: ffff93700bf72ad3 R15: 0000000000000040
[   19.819236] FS:  00007f2b4b275880(0000) GS:ffff938e80c00000(0000) knlGS:0000000000000000
[   19.827330] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.833075] CR2: 00007ffc48657b08 CR3: 000080108f998000 CR4: 0000000000350ee0
[   19.840545] printk: systemd-udevd: 23 output lines suppressed due to ratelimiting
[   19.864222] ------------[ cut here ]------------
[   19.868843] WARNING: CPU: 68 PID: 0 at net/netlink/af_netlink.c:414 netlink_sock_destruct+0xa1/0xc0
[   19.877886] Modules linked in:
[   19.880947] CPU: 68 PID: 0 Comm: swapper/68 Tainted: G      D            6.2.0-rc6+ #119
[   19.889033] Hardware name: AMD Corporation DAYTONA_X/DAYTONA_X, BIOS RDY1009A 09/16/2020
[   19.897119] RIP: 0010:netlink_sock_destruct+0xa1/0xc0
[   19.902172] Code: 29 41 8b 84 24 9c 02 00 00 85 c0 75 2b 49 83 bc 24 68 05 00 00 00 75 08 41 5c 5d e9 bd ac 28 00 0f 0b 41 5c 5d e9 b3 ac 28 00 <0f> 0b 41 8b 84 24 9c 02 00 00 85 c0 74 d5 0f 0b eb d1 66 66 2e 0f
[   19.920916] RSP: 0018:ffffaeab87e3ce38 EFLAGS: 00010202
[   19.926140] RAX: 0000000000000380 RBX: ffff937ed3c27d30 RCX: 0000000000000000
[   19.933274] RDX: 0000000000000102 RSI: ffffffff9bf21a23 RDI: 0000000000000000
[   19.940406] RBP: ffffaeab87e3ce40 R08: 0000000000000001 R09: 0000000000000000
[   19.947539] R10: 0000000000000000 R11: 0000000000000000 R12: ffff937ed3c27800
[   19.954672] R13: ffff937ed3c27f30 R14: ffff937ed3304b80 R15: ffffaeab87e3cf20
[   19.961804] FS:  0000000000000000(0000) GS:ffff938e70c00000(0000) knlGS:0000000000000000
[   19.969889] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   19.975637] CR2: 0000000000000000 CR3: 0000800ade212000 CR4: 0000000000350ee0
[   19.982771] Call Trace:
[   19.985221]  <IRQ>
[   19.987237]  __sk_destruct+0x33/0x230
[   19.990906]  ? deferred_put_nlk_sk+0x1d/0x100
[   19.995265]  sk_destruct+0x52/0x60
[   19.998672]  __sk_free+0x30/0xd0
[   20.001902]  sk_free+0x2e/0x50
[   20.004964]  deferred_put_nlk_sk+0x6b/0x100
[   20.009148]  rcu_core+0x4c2/0x7a0
[   20.012467]  ? rcu_core+0x47e/0x7a0
[   20.015961]  rcu_core_si+0x12/0x20
[   20.019366]  __do_softirq+0x11f/0x353
[   20.023034]  irq_exit_rcu+0xaf/0xe0
[   20.026533]  sysvec_apic_timer_interrupt+0xb4/0xd0
[   20.031326]  </IRQ>
[   20.033432]  <TASK>
[   20.035536]  asm_sysvec_apic_timer_interrupt+0x1f/0x30
[   20.040679] RIP: 0010:cpuidle_enter_state+0x126/0x4d0
[   20.045738] Code: 00 31 ff e8 bc f9 46 ff 80 7d d7 00 74 16 9c 58 0f 1f 40 00 f6 c4 02 0f 85 8e 03 00 00 31 ff e8 d0 19 4f ff fb 0f 1f 44 00 00 <45> 85 ff 0f 88 d9 01 00 00 49 63 c7 4c 2b 75 c8 48 8d 14 40 48 8d
[   20.064484] RSP: 0018:ffffaeab80797e48 EFLAGS: 00000246
[   20.069711] RAX: ffff938e70c00000 RBX: 0000000000000002 RCX: 000000000000001f
[   20.076844] RDX: 0000000000000000 RSI: ffffffff9cb59380 RDI: ffffffff9cb5eaaf
[   20.083973] RBP: ffffaeab80797e80 R08: 000000049ffc9237 R09: 0000000000000e04
[   20.091110] R10: ffff938e70df3964 R11: ffff938e70df3944 R12: ffff9370025afc00
[   20.098240] R13: ffffffff9d35b180 R14: 000000049ffc9237 R15: 0000000000000002
[   20.105377]  ? cpuidle_enter_state+0x104/0x4d0
[   20.109819]  cpuidle_enter+0x32/0x50
[   20.113397]  call_cpuidle+0x23/0x50
[   20.116892]  do_idle+0x1d4/0x250
[   20.120123]  cpu_startup_entry+0x24/0x30
[   20.124051]  start_secondary+0x114/0x130
[   20.127974]  secondary_startup_64_no_verify+0xd3/0xdb
[   20.133032]  </TASK>
[   20.135218] ---[ end trace 0000000000000000 ]---
[   21.988002] raid6: avx2x4   gen() 27873 MB/s
[   22.060002] raid6: avx2x2   gen() 28291 MB/s
[   22.132001] raid6: avx2x1   gen() 23642 MB/s
[   22.136275] raid6: using algorithm avx2x2 gen() 28291 MB/s
[   22.208001] raid6: .... xor() 17406 MB/s, rmw enabled
[   22.213051] raid6: using avx2x2 recovery algorithm
[   22.222249] xor: automatically using best checksumming function   avx
[   22.234862] async_tx: api initialized (async)
[   22.555209] Btrfs loaded, crc32c=crc32c-intel, zoned=yes, fsverity=yes

(it then drops to the initramfs prompt).

Is there a different tree the series can be rebased on, until net-next
gets fixed?

Thanks,

Kim
