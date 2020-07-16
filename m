Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEDFC22246A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgGPN4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:56:09 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:43763 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728805AbgGPN4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 09:56:08 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f105c750000>; Thu, 16 Jul 2020 21:56:05 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 16 Jul 2020 06:56:05 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 16 Jul 2020 06:56:05 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 16 Jul
 2020 13:55:55 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 16 Jul 2020 13:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGQNLPKbJLhdAhxcKOHFmFzxsze0BGyg9O4HdBJ93Yy/iX67MphGheJRkTzE4hE0m+tBtg9AD6s8xZXkaA+LwKwbZtrpoHc1gxqs8qEwBqtWe8/ZWy/fU472iBK7lMU6eAvd1lUSfMm09u4xg8Qa0HMSrZQ7AG7EoRaQ+LV0x3KmpFT6dyhH4eqptAqewHuRdMs3WFWnpRhBJgTfrclyZvKQ1get8e5QyQ6grlM0sPDuIFH0robEtRJwYBClc+xrlRu7Ax+j5zWXNM9D+tokxXMjGBKu5jMevkpnbv7H36jhDZqpO6ORaJQNcDsDu6oj4SAFQsmdL056pSLMQ8G3XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=336705n8xlNAOqHqrLLikuac5iYOyEydNTzJmJw3ED0=;
 b=GILwstrdvme6QBlMcgQamGwJjSGjNvl6wht8Y85U6p+inpVcl1wDjZ0rlSGOM506OPnGqA8+Pk0HCmwG93hRRYLUbw+X7TUv7vqVOZvE9sUE73srASC9sbfZ9wqqz4Tprsf8IU8oQ0dx5VHNMnvvejG3RjiXypxj0Jz+jZeVNcM1tNrnTt5HnRDB/OrdpHNM1HthP1uO5oFPpn9elquZe0TFkaIbNMNDBSpWaoquWoyf/l11eeySxXurPrFa0jy4upFYmJ/39bY5gp7Miql0dQCYFCn8fOLVQQ1Il7fczTgzH/98Fws7nqx9VoATpKv4kBiGlyNj61f1cMa+4PSgHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1514.namprd12.prod.outlook.com (2603:10b6:4:f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Thu, 16 Jul 2020 13:55:53 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 13:55:53 +0000
Date:   Thu, 16 Jul 2020 10:55:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>, <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-rc] RDMA/cm: Protect access to remote_sidr_table
Message-ID: <20200716135550.GB2626442@nvidia.com>
References: <20200716105519.1424266-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200716105519.1424266-1-leon@kernel.org>
X-ClientProxiedBy: YT1PR01CA0087.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::26) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0087.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:2d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Thu, 16 Jul 2020 13:55:52 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jw4MY-00B1Hk-O4; Thu, 16 Jul 2020 10:55:50 -0300
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b047f3a9-86b1-4a14-06bb-08d8298ff431
X-MS-TrafficTypeDiagnostic: DM5PR12MB1514:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1514F7AA775A3830535A3905C27F0@DM5PR12MB1514.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P7ZBjmrWtdpgHsuEQQFpg2kNhzqrJmMqyt0FvI8JohXxabGPpQtuXNUVavzcmBLrFv77QN/jpHcCym8MLIWkgotiUO1R6Snm8NcEukNGFOmDwjD/Zfd4GpSotAk7m0rUit44hs78jrBCG1u9qVwbvBzC4RDRdHSmiO1LLB1VIXndPJA7XMxZoEmVzx2MyzLib3kUDL/vUbcjfRiz2QI5c/yoV5E1pqZnYiH4Y+cls5LJS+JFZ6ACYGjlCSZHZ6oftnxWszA4MyK/yQYzEm5xFzachAblz3XIJCK4RCuhQhipezqokmcJk+3zr7uJPPMpN4bg5mGv4FYnKWnAOVhwSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(8936002)(36756003)(2616005)(45080400002)(478600001)(66946007)(26005)(186003)(66476007)(54906003)(9746002)(426003)(316002)(33656002)(66556008)(9786002)(2906002)(86362001)(83380400001)(6916009)(4326008)(5660300002)(1076003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oS+l73UD4GScq3kE77vaxeDYBlV6dss0rNlSX+cEcYMva2G4jLS97OeQNpRFmQT/yG8r7FRS7X2f6gEcl1Pyi23yVEnCyivbKweBxew+N9fUWLYbegtnwZDYN456OHqJwHrUdzvKyn1uDdlWfnHy8vfoqvGPz7T99WOK5kmwx/+GwVCxORNFZpOI+3ZPAokraU+y63GhMGeshdhCwD7CWcsRA43eBMfYifExpaHzdHtkbhBEF6Ip7faXJFVP59IILeAY2JI5ZQ/+TKnxgmfgtxPta2pHTG2b+iiIAfxBuCiJl6O2jTtp4oHWSQBtEds9TTyHp5SohA6SBVyN2YAz8LM2meTcgSXfImF5o17xVjr5Hh/06bA2RqlENmVnYt0RNIH9xksMCOmRCh9BYh8Lw0P8p4lKUz8FsfurZVeG+BJ2b3XRV19zdjDTNWPcZAY2p/ItQ80lyFLra76AGKjfctscH4056WsCt3d2pUFh2c9JjmmvPvwCKjfAD3jumgWP
X-MS-Exchange-CrossTenant-Network-Message-Id: b047f3a9-86b1-4a14-06bb-08d8298ff431
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 13:55:52.8350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMaORyYmpKaaPf/QSO4HEtAuy+ad0AM7f4zELAH7akWesBpjgZaA3f7ZgnezREA3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1514
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594907765; bh=336705n8xlNAOqHqrLLikuac5iYOyEydNTzJmJw3ED0=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=pW5gHE9B5g9f2RBq+xzhpFMcTqC7bgtwVVgiYr7VqCTL79ZMw2uWD7AEImGz8CqE5
         5ZDCF5/fA9YRvEHtq1oMJd0Wg3qywRYrx4J8S5dtwaIMy4hlIrpI5EbbLB+McFDWNh
         3cSEIlulbRHU4qmSqq89ckhJbg13s2xuDHJacKLuux7FmtKPd98cF3iLhGty8VdUGG
         0+a/kCaqVEeGvCzwqosOJyq12fD+xI883+g1AXCWXNZO/aXEvoFSsYskOe6zu4Okdk
         ntFge17x+HNEHbR3G4UGQif674nvepvdqjr5KH6cwWTjX8XAlPkMmFfNqher2QqvpJ
         OtD3llocWO+FA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 01:55:19PM +0300, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@mellanox.com>
> 
> cm.lock must be held while access to remote_sidr_table.
> This fix the below NULL pointer dereference.
> 
>  [ 2666.146138] BUG: kernel NULL pointer dereference, address: 0000000000000000
>  [ 2666.151565] #PF: supervisor write access in kernel mode
>  [ 2666.152896] #PF: error_code(0x0002) - not-present page
>  [ 2666.154184] PGD 0 P4D 0
>  [ 2666.154911] Oops: 0002 [#1] SMP PTI
>  [ 2666.155859] CPU: 2 PID: 7288 Comm: udaddy Not tainted 5.7.0_for_upstream_perf_2020_06_09_15_14_20_38 #1
>  [ 2666.158123] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>  [ 2666.161909] RIP: 0010:rb_erase+0x10d/0x360
>  [ 2666.163549] Code: 00 00 00 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 74 48 f6 02 01 75 af 48 8b
> 7a 10 48 89 c1 48 83 c9 01 48 89 78 08 48 89 42 10 <48> 89 0f 48 8b 08 48 89 0a 48 83 e1 fc 48
>  89 10 0f 84 b1 00 00 00
>  [ 2666.169743] RSP: 0018:ffffc90000f77c30 EFLAGS: 00010086
>  [ 2666.171646] RAX: ffff8883df27d458 RBX: ffff8883df27da58 RCX: ffff8883df27d459
>  [ 2666.174026] RDX: ffff8883d183fa58 RSI: ffffffffa01e8d00 RDI: 0000000000000000
>  [ 2666.176325] RBP: ffff8883d62ac800 R08: 0000000000000000 R09: 00000000000000ce
>  [ 2666.178618] R10: 000000000000000a R11: 0000000000000000 R12: ffff8883df27da00
>  [ 2666.180919] R13: ffffc90000f77c98 R14: 0000000000000130 R15: 0000000000000000
>  [ 2666.183197] FS:  00007f009f877740(0000) GS:ffff8883f1a00000(0000) knlGS:0000000000000000
>  [ 2666.186318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [ 2666.188293] CR2: 0000000000000000 CR3: 00000003d467e003 CR4: 0000000000160ee0
>  [ 2666.190614] Call Trace:
>  [ 2666.191896]  cm_send_sidr_rep_locked+0x15a/0x1a0 [ib_cm]
>  [ 2666.193902]  ib_send_cm_sidr_rep+0x2b/0x50 [ib_cm]
>  [ 2666.195695]  cma_send_sidr_rep+0x8b/0xe0 [rdma_cm]
>  [ 2666.197559]  __rdma_accept+0x21d/0x2b0 [rdma_cm]
>  [ 2666.199335]  ? ucma_get_ctx+0x2b/0xe0 [rdma_ucm]
>  [ 2666.201105]  ? _copy_from_user+0x30/0x60
>  [ 2666.202741]  ucma_accept+0x13e/0x1e0 [rdma_ucm]
>  [ 2666.204549]  ucma_write+0xb4/0x130 [rdma_ucm]
>  [ 2666.206306]  vfs_write+0xad/0x1a0
>  [ 2666.207780]  ksys_write+0x9d/0xb0
>  [ 2666.209316]  do_syscall_64+0x48/0x130
>  [ 2666.210915]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>  [ 2666.212810] RIP: 0033:0x7f009ef60924
>  [ 2666.214354] Code: 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 80 00 00 00 00 8b
> 05 2a ef 2c 00 48 63 ff 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3
>  66 90 55 53 48 89 d5 48 89 f3 48 83
>  [ 2666.220512] RSP: 002b:00007fff843edf38 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
>  [ 2666.223546] RAX: ffffffffffffffda RBX: 000055743042e1d0 RCX: 00007f009ef60924
>  [ 2666.225889] RDX: 0000000000000130 RSI: 00007fff843edf40 RDI: 0000000000000003
>  [ 2666.228228] RBP: 00007fff843ee0e0 R08: 0000000000000000 R09: 0000557430433090
>  [ 2666.230572] R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
>  [ 2666.232931] R13: 00007fff843edf40 R14: 000000000000038c R15: 00000000ffffff00
>  [ 2666.235272] Modules linked in: nfsv3 nfs_acl rpcsec_gss_krb5
> auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache xt_MASQUERADE
> mlx5_ib nf_conntrack_netlink nfnetlink iptable_nat xt_addrtype
> iptable_filter bpfilter xt_conntrack br_netfilter bridge stp llc overlay
> rpcrdma ib_isert iscsi_target_mod ib_iser ib_srpt target_core_mod ib_srp
> ib_ipoib rdma_ucm ib_uverbs sb_edac mlx5_core kvm_intel iTCO_wdt
> iTCO_vendor_support kvm ib_umad mlxfw pci_hyperv_intf act_ct
> nf_flow_table irqbypass nf_nat rdma_cm crc32_pclmul rfkill nf_conntrack
> crc32c_intel ghash_clmulni_intel virtio_net ib_cm i2c_i801 pcspkr
> nf_defrag_ipv6 net_failover failover nf_defrag_ipv4 ptp i2c_core lpc_ich
> iw_cm pps_core mfd_core ib_core sunrpc sch_fq_codel ip_tables serio_raw
>  [ 2666.258905] CR2: 0000000000000000
>  [ 2666.260386] ---[ end trace 92a3d3f267f6faa3 ]---
>  [ 2666.262174] RIP: 0010:rb_erase+0x10d/0x360
>  [ 2666.263781] Code: 00 00 00 48 89 c1 48 89 d0 48 8b 50 08 48 39 ca 74
> 48 f6 02 01 75 af 48 8b 7a 10 48 89 c1 48 83 c9 01 48 89 78 08 48 89 42
>    10 <48> 89 0f 48 8b 08 48 89 0a 48 83 e1 fc 48 89 10 0f 84 b1 00 00
>       00
>  [ 2666.269994] RSP: 0018:ffffc90000f77c30 EFLAGS: 00010086
>  [ 2666.272008] RAX: ffff8883df27d458 RBX: ffff8883df27da58 RCX: ffff8883df27d459
>  [ 2666.274465] RDX: ffff8883d183fa58 RSI: ffffffffa01e8d00 RDI: 0000000000000000
>  [ 2666.276978] RBP: ffff8883d62ac800 R08: 0000000000000000 R09: 00000000000000ce
>  [ 2666.279437] R10: 000000000000000a R11: 0000000000000000 R12: ffff8883df27da00
>  [ 2666.281941] R13: ffffc90000f77c98 R14: 0000000000000130 R15: 0000000000000000
>  [ 2666.284397] FS:  00007f009f877740(0000) GS:ffff8883f1a00000(0000) knlGS:0000000000000000
>  [ 2666.287708] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [ 2666.289817] CR2: 0000000000000000 CR3: 00000003d467e003 CR4: 0000000000160ee0
>  [ 2666.292274] Kernel panic - not syncing: Fatal exception
>  [ 2666.294689] Kernel Offset: disabled
>  [ 2666.296253] ---[ end Kernel panic - not syncing: Fatal exception]---

Don't word wrap oops reports, and I prefer the timestamp is stripped out

> Fixes: 6a8824a74bc9 ("RDMA/cm: Allow ib_send_cm_sidr_rep() to be done under lock")
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/cm.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to for-rc

Thanks,
Jason
