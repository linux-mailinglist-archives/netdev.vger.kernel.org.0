Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0796220D850
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbgF2TiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:38:05 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:52934 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387479AbgF2Th7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:37:59 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ef9f8050000>; Mon, 29 Jun 2020 22:17:41 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Mon, 29 Jun 2020 07:17:41 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Mon, 29 Jun 2020 07:17:41 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 29 Jun
 2020 14:17:41 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 29 Jun 2020 14:17:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tm6oMebc6DLzGg8ZQiwfobSMbZxQWsy+LC+Q/IVueEcsAH26SnM+GMf7cQz2Q7TnDJdnHX0tVpm72n6barrZKvagjyo+lFYetRxAZqNZmR5vBS0gg3s1fmyvSuZWGjcX9PdDMG/kEU0zePypntvmXXVwwwZKoEPWYfEPprXMqwgk+ulA2bmOQUCGJyUXZp7rQ/HyxcMbzbCMUfPSvxphMMlluSIoOw3rKWDYLnUEIwi5Djh1L2gUsLMg7RwwRYtQIVt6V++PRHrQMM/yjG8wfs6HQlkPii+/S8IWbZHA6ij5mMzHAXXS85SLm5h+JO/mnY/914r5kOnXl9NT3dM5Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9T4kKwtuWxM8emLqgtOzDH90iXrg66I3lbFSG+kFxY=;
 b=Z4fHoQffHCsU5xoKpQeLkK8EnXP340Ey8dCAlFART+KmTAczvSqPyWQnNQ8LeFxoSpMZvUIy7bDukjXDGnoTPIih4GoL0gv1RYMVchVODQOq912Ly+K3fttK36FR4nQuzb3gbml2XeemBZlFlw6ozDbHGcwO7aoUD2nHLyoBoQqShPbdF+msGD3B+4ND7h9kycA2p9a5oT3eghrAsTirUHNZ9ti06INVbAZBTHoq4zG3UcrF53rSqJsdQe/8n//NPoKmG36AxdNrv66EjJtBLYsqIB2V/7Ub2kLnD+fHUgcdK0TM93Aq4WrHUldJa8RDOwV5feVZ/foFI5Iy6Kr0mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4012.namprd12.prod.outlook.com (2603:10b6:5:1cc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 14:17:38 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 14:17:38 +0000
Date:   Mon, 29 Jun 2020 11:17:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     <santosh.shilimkar@oracle.com>
CC:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+274094e62023782eeb17@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: general protection fault in rds_ib_add_one
Message-ID: <20200629141735.GA264799@nvidia.com>
References: <20200224103913.2776-1-hdanton@sina.com>
 <8c0a6d58-fd96-ded0-d5ad-a8ffc8d7a620@oracle.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8c0a6d58-fd96-ded0-d5ad-a8ffc8d7a620@oracle.com>
X-ClientProxiedBy: MN2PR15CA0002.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::15) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by MN2PR15CA0002.namprd15.prod.outlook.com (2603:10b6:208:1b4::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Mon, 29 Jun 2020 14:17:37 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jpubH-0016u6-VP; Mon, 29 Jun 2020 11:17:35 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12656af7-2c4d-4577-4ec2-08d81c372cf1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4012:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4012D3159965D52B1F072C0BC26E0@DM6PR12MB4012.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 044968D9E1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWwIm9Ncj4w2Hm9sEwqYIZZbNWIml+nTfyQbswtmjpj5PnyZd6So9fQ3dS/FJqIohUBP2WsLnYC6/d0/pZq9s4JewbJih200i4uzWtIKlfLKRKRMpn+RH+uGSnp1mhFG61XTPpvkJt/oXZvkr87b0thxcinEf7gdxJ440ahkYKz+OXcWbZA9h7xjVRowY3SeZl3WIDmCcR4Qvj9bfcMuXBGptkA98pi6BT6Gpy9F4YesjjkXDpsiAndLWwNe22CfAI6vwrEXurkV5MWjt2+2AppKbSbOk64L2tGEjqDezgSVMw44Xe/61yBNg0Ej59QpByEkqjT5jJpSCw3PoZ12OE2QChOs5KAJ6jX/ShAUHvAjO6to0uHXrA2D6Z5Cj2r9vn5gSH9J+3gVHECUsR3mD0DI2S6rFl2OHgxXwbMwNUFgIMgZgtrYZ8bkVZQM6nw4xpXlKU4ZWtd06u0tOBtlJ1dDwEs54zC4yrf12Hx1T74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39860400002)(9746002)(9786002)(83380400001)(53546011)(83080400001)(2906002)(7416002)(478600001)(33656002)(36756003)(5660300002)(2616005)(966005)(4326008)(6916009)(54906003)(26005)(66556008)(66946007)(66476007)(8676002)(86362001)(1076003)(186003)(8936002)(316002)(426003)(27376004)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5LB6YUswrAkxJQcn7zHgaf2b9YfsxbLWUToDUaUT0JESwxeu1/6i4yt4nCkWGaCH3On5xQE3kEnhmaPXiLbSQ85ujWmqx520xnQO5iL3qiDB0VydmrBFO02Ao7ckYeoQY3dJlWzdjTCqgkba1CXbUXFK49voMcxQEGUqFACsTUErTemZ7Hd+oQzTHjnSjOgCEWGHxjXSjlNZxJf+zrA903XGFENDsbk1fpXr1fXsqRGz+QMqbIHk6PjgKsZZG8+06hMVIX1mFKIkXU8OfR1DuCcLQef8frXxtYBh2iDT1dc5POqjJIs/s9bBQ1wiS+Enn/JIHOScc7ypt22K+hgdjXHKpA6sfAuU08M3+oNxqc0c8G89hdoKsDra8hma5IjU8RkPS9OEOYXndysSAArhSJ6oxw+VX4/czdvxSq1EM+KRQkDiive36xjRLnsIvKmsxKSvYmzm9iRLZslOzHkS5Rlr1urXUVTAyoR9l8Ty2cM=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12656af7-2c4d-4577-4ec2-08d81c372cf1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2020 14:17:38.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpjRZzQ1Qj1NDNtri2l/zjwIBVgaEo5QDYYcOcouxQt2B89HjhyuBLYye3dmO81I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4012
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1593440261; bh=s9T4kKwtuWxM8emLqgtOzDH90iXrg66I3lbFSG+kFxY=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-Forefront-PRVS:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=APaCQTKdBxVfVeqTDugWheHhaxk+HxZqCGb7zZPHQkvZ96DPGm9LBIoNblPa3w5gB
         dywBWRlamJjYWRbZTPqsFxAkn7RvFecPkOJJYj+TeoLk9lNeCVLB6fOvK1wIMKLSft
         fDpNgZgTaXmPH1ycW9bBwEVQIzmIO2TePV8QarGGa/10o0yoplfHtPbWSdvLg8xfX1
         FPxrHsOiHTDED0++L4JmiZxPKUj5CnzPjJFq3feZzoZtFV87DCTNO9+MOZna/u9Yhg
         Z1O4cv36qJ24nuftpdM6i0UiU7jsQuCbFShaqnmh6JsdCle2iS89mOmqhiKWDkpnJj
         PPzv2VAcCwqsQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 09:51:01AM -0800, santosh.shilimkar@oracle.com wrote:
> On 2/24/20 2:39 AM, Hillf Danton wrote:
> > 
> > On Mon, 24 Feb 2020 00:38:13 -0800
> > > syzbot found the following crash on:
> > > 
> > > HEAD commit:    b0dd1eb2 Merge branch 'akpm' (patches from Andrew)
> > > git tree:       upstream
> > > console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=13db9de9e00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauXTR6PmUg$
> > > kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=a6001be4097ab13c__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUIjkEraA$
> > > dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=274094e62023782eeb17__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauXEUExfYg$
> > > compiler:       clang version 10.0.0 (https://urldefense.com/v3/__https://github.com/llvm/llvm-project/__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUcUeVf2A$  c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > > syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=10ad6a7ee00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauX2w5ISoA$
> > > C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=13da7a29e00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauUf3qIVeQ$
> > > 
> > > Bisection is inconclusive: the first bad commit could be any of:
> 
> [...]
> 
> > > 868df536 Merge branch 'odp_fixes' into rdma.git for-next
> > > 
> > > bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=1542127ee00000__;!!GqivPVa7Brio!O9xt2mwp7Vb5SndsHmi1c7ynTdDMNXebFTWfSklgQdlUqRdC218qPSAXMuDUauVrB3NY9g$
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+274094e62023782eeb17@syzkaller.appspotmail.com
> > > 
> > > batman_adv: batadv0: Interface activated: batadv_slave_1
> > > infiniband syz1: set active
> > > infiniband syz1: added vlan0
> > > general protection fault, probably for non-canonical address 0xdffffc0000000086: 0000 [#1] PREEMPT SMP KASAN
> > > KASAN: null-ptr-deref in range [0x0000000000000430-0x0000000000000437]
> > > CPU: 0 PID: 8852 Comm: syz-executor043 Not tainted 5.6.0-rc2-syzkaller #0
> > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > > RIP: 0010:dev_to_node include/linux/device.h:663 [inline]
> > > RIP: 0010:rds_ib_add_one+0x81/0xe50 net/rds/ib.c:140
> > > Code: b7 a8 06 00 00 4c 89 f0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 f7 e8 0e e4 1d fa bb 30 04 00 00 49 03 1e 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 f0 0a 00 00 8b 1b 48 c7 c0 28 0c 09 89 48
> > > RSP: 0018:ffffc90003087298 EFLAGS: 00010202
> > > RAX: 0000000000000086 RBX: 0000000000000430 RCX: 0000000000000000
> > > RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> > > RBP: ffffc900030872f0 R08: ffffffff87964c3c R09: ffffed1014fd109c
> > > R10: ffffed1014fd109c R11: 0000000000000000 R12: 0000000000000000
> > > R13: dffffc0000000000 R14: ffff8880a7e886a8 R15: ffff8880a7e88000
> > > FS:  0000000000c3d880(0000) GS:ffff8880aea00000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f0318ed0000 CR3: 00000000a3167000 CR4: 00000000001406f0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > Call Trace:
> > >   add_client_context+0x482/0x660 drivers/infiniband/core/device.c:681
> > >   enable_device_and_get+0x15b/0x370 drivers/infiniband/core/device.c:1316
> > >   ib_register_device+0x124d/0x15b0 drivers/infiniband/core/device.c:1382
> > >   rxe_register_device+0x3f6/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:1231
> > >   rxe_add+0x1373/0x14f0 drivers/infiniband/sw/rxe/rxe.c:302
> > >   rxe_net_add+0x79/0xe0 drivers/infiniband/sw/rxe/rxe_net.c:539
> > >   rxe_newlink+0x31/0x90 drivers/infiniband/sw/rxe/rxe.c:318
> > >   nldev_newlink+0x403/0x4a0 drivers/infiniband/core/nldev.c:1538
> > >   rdma_nl_rcv_msg drivers/infiniband/core/netlink.c:195 [inline]
> > >   rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
> > >   rdma_nl_rcv+0x701/0xa20 drivers/infiniband/core/netlink.c:259
> > >   netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
> > >   netlink_unicast+0x766/0x920 net/netlink/af_netlink.c:1328
> > >   netlink_sendmsg+0xa2b/0xd40 net/netlink/af_netlink.c:1917
> > >   sock_sendmsg_nosec net/socket.c:652 [inline]
> > >   sock_sendmsg net/socket.c:672 [inline]
> > >   ____sys_sendmsg+0x4f7/0x7f0 net/socket.c:2343
> > >   ___sys_sendmsg net/socket.c:2397 [inline]
> > >   __sys_sendmsg+0x1ed/0x290 net/socket.c:2430
> > >   __do_sys_sendmsg net/socket.c:2439 [inline]
> > >   __se_sys_sendmsg net/socket.c:2437 [inline]
> > >   __x64_sys_sendmsg+0x7f/0x90 net/socket.c:2437
> > >   do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
> > >   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > 
> > Fall back to NUMA_NO_NODE if needed.
> > 
> > +++ b/net/rds/ib.c
> > @@ -137,7 +137,8 @@ static void rds_ib_add_one(struct ib_dev
> >   		return;
> >   	rds_ibdev = kzalloc_node(sizeof(struct rds_ib_device), GFP_KERNEL,
> > -				 ibdev_to_node(device));
> > +				 device->dev.parent ?
> > +				 ibdev_to_node(device) : NUMA_NO_NODE);
> >   	if (!rds_ibdev)
> >   		return;
> > 
> This seems good. Can you please post it as properly formatted patch ?

Reminder please, this still shows in the dashboards?

Jason
