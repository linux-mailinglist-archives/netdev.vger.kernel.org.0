Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55788293741
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390094AbgJTI5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:57:30 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:35107 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389950AbgJTI52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:57:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603184246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y5swQdbkQzp2TrJXK+MEV+AIBrovWzGv7cK2LDPOoXo=;
        b=anj14bbQ1JfIRng4qk0F/bisSsRXbbi8kAx52E+XiLJxk7unmHoPCL5Av+FOiH//z+iWCX
        p3m9jAg/x+0NCcgjhu+xZFG4znqFgC8T50YL7AraPYg/xBpmZZ61p0ln5lDCNyS52xLzud
        e4HJpDMbCFl2d9tX3HuXCkY8NlnZUFc=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2057.outbound.protection.outlook.com [104.47.6.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-1dKKEJ2BMjW-YjNcQ2KSMQ-1; Tue, 20 Oct 2020 10:57:24 +0200
X-MC-Unique: 1dKKEJ2BMjW-YjNcQ2KSMQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYUyovzmZud//0stMzoa1a2KGsQS5sN06/FsqOO4Z/bj/3TxIBhjOPyTptANMtNIRteF+r9fXFu06lbEYNfHXi7pNtJy4CgbCbl2u19rLXN/BPuHJ2a+WgmrU+0y5Ed20bCdMEDMqargPJImk4y42VQllBvDtfDMvIznuPlcsNqyIr3/vO+qxaTlT4kBw9dQwiAKM1mYHzbcrt+8ZSZzBf3Cw9Pp9URRkb4E5Sn0jLOuKz+l5lNnFhgIHQ+Y1olhaE7P+qqHx045+c3r9UVyrAlNsp9cQ5D2sQFBwQSh9JWdmBpxOhlUfzEqgoKUDlqFKcmcf4iujG4/WikJTlhhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5swQdbkQzp2TrJXK+MEV+AIBrovWzGv7cK2LDPOoXo=;
 b=QAAKNqavBKf51aHmVs7uL8YkfFmVFtbLfygNEsd1B1qg+Dui1IABu2IGRmmgHGguIZoifqVu9inF8PSwFGEAAMjmtIpOObQnirOKmuEIb0kKZgZkiUOp/YLIKYSavSloV4Mc6u8jZkGZP+50lUrIzgoLDdllA+cmLe+ObRSdo5oR1ya7hjbmj0ziaAVgIIHN01ynntwYkykM4Qd3fDEaoEliojA/sBnczJAAhP3aMZWMrns5IHp9eZla9l8zQwUheRpzuLWoFoKXprsmbFQJAWTP194tsEpj4Q9luYLeaxdzNztUEJdJ/7Rlys2lN16fYFuAXanslZ2Ax7HAtqlqMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB8PR04MB6492.eurprd04.prod.outlook.com (2603:10a6:10:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 08:57:20 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 08:57:20 +0000
Date:   Tue, 20 Oct 2020 16:57:11 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201020085711.GM7183@syu-laptop>
References: <20201016115407.170821-1-coiby.xu@gmail.com>
 <20201016115407.170821-3-coiby.xu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201016115407.170821-3-coiby.xu@gmail.com>
X-Originating-IP: [2001:b400:e256:5604:908c:43ff:fe8c:2fe3]
X-ClientProxiedBy: AM0PR03CA0071.eurprd03.prod.outlook.com (2603:10a6:208::48)
 To DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (2001:b400:e256:5604:908c:43ff:fe8c:2fe3) by AM0PR03CA0071.eurprd03.prod.outlook.com (2603:10a6:208::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 08:57:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdd1fbc0-baa4-4837-cd7e-08d874d6270c
X-MS-TrafficTypeDiagnostic: DB8PR04MB6492:
X-Microsoft-Antispam-PRVS: <DB8PR04MB6492E9DE510CEA1A76691FB6BF1F0@DB8PR04MB6492.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1GbXSBT+BG02zOnvJIxLRTxNJKbbnRpRb3B4iBCGto78OLGHo+FuOUOSBLa3U5p/Ff2FRoX3g2eSTNbd7GpBWVQGk7sD11Ls/THCf3Ey+oaMF2LHU/13JM5LRTGMCAYPpKMEdD37yPrKg/bantbaubySh+INZlHnX5bl4yaj8ZPzUVU91PiROiP/Z/9eZ9jh59C7JjlB3cSgVcPGqwyi0PLHVds68KHQFBvZX83RpiDb66ZrcTzt7BNAjigqvnXhSGg+pFREHkVG6lUXYuE4l7pDDpzDXNwdoNEqHuaiD/z4J/cwrsFUF5YeDDlmc2dGxyakgIxc1aZiOuVImhmgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(16526019)(33716001)(33656002)(8676002)(83380400001)(54906003)(8936002)(6496006)(186003)(55016002)(316002)(52116002)(86362001)(6666004)(2906002)(4326008)(6916009)(9686003)(1076003)(478600001)(5660300002)(66946007)(66556008)(66476007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZVBBspaGPzHvdGsAhE8+xsjTJhTWrF22U9KcxssruVY6V5Lr1FGgjAySunk5HHUTwuzQhZxXyC5vCk1KsAkdl5J5OPw3AEULrhdTieNWdkZthMg2a9GBPjqtb0yxrvXYqxIYC3/uyHfMqw1Di0pxqRowG4QwOc7fGE9fTerCguv5Q/u01K+tXDpjySQgVXQRwiGgWnNAH1SB1ltTiWNjhnZUg55AnjwtY8OqdtO22nLHzJO+U/HU2NrANJopwjyFx7fr/ljGMb6SCjz7uhCvP8vnV74ElxQ99UE3X/Ye928XU3nAV8RS4yhdepJKsngZkHEoN4fhh1zdM6WSG0tYZNL69wnHKv2tTMRmQkSZypu5nJo/DfrUMSkVcju6hp5xVxhMZ7EFzLvxDT3vktg4O2+fGNoZY4GObBgIKWuB5jGp99/eROx5WNOdZ4C/t3w7c0SHPl8j6nupOfNeEZQiExxiYUnQSuZv+8mh1Tmn7cem6NNU1WPDvv5oWybQgDPqFfUznjCHsc5FIZMkI+dKA7DZNoNZkwX/lTei763RBvfdkOy6G84s25tl4zkhDzAzek5iBLJruItBrYjTd4mDywMtpDm5Hiuc8ATqN8Q82yz9XU5bpfpWrY/0Cp74O9tlw3W7r+QvzeMCCzhle1DRyTjbKlZW4Wm1uOZjKdpQcStZe54r9Tkg8DLELb5Q7qft2d0ldG+sDwxfS1t+OEhyMA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdd1fbc0-baa4-4837-cd7e-08d874d6270c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 08:57:20.2147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z6HapCSJAAyb84rcRPNYbwyLkz6nZd5ArNt0xlR44lu64lIfoFW7Q2xFm9C2C7p82+WWqy+xdl8yDNGlWH+WQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch trigger the following KASAN error inside qlge_init_device().

[...] general protection fault, probably for non-canonical address 0xdffffc000000004b: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN PTI
[...] KASAN: null-ptr-deref in range [0x0000000000000258-0x000000000000025f]
[...] CPU: 0 PID: 438 Comm: systemd-udevd Tainted: G         C  E     5.9.0-kvmsmall+ #7
[...] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-48-
g...ilt.opensuse.org 04/01/2014
[...] RIP: 0010:qlge_get_8000_flash_params+0x377/0x6e0 [qlge]
[...] Code: 03 80 3c 02 00 0f 85 57 03 00 00 49 8b af 68 08 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d bd 5f 02 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 c6 02 00 00
[...] RSP: 0018:ffffc90000f97788 EFLAGS: 00010207
[...] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
[...] RDX: 000000000000004b RSI: ffffffffc08cb843 RDI: 000000000000025f
[...] R10: fffffbfff5f718a0 R11: 0000000000000001 R12: dffffc0000000000
[...] R13: ffff888111085d40 R14: ffff888111085d40 R15: ffff888111080280
[...] FS:  00007f315f5db280(0000) GS:ffff8881f5200000(0000) knlGS:0000000000000000
[...] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[...] CR2: 000055bb25297170 CR3: 0000000110674000 CR4: 00000000000006f0
[...] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[...] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[...] Call Trace:
[...]  ? qlge_get_8012_flash_params+0x600/0x600 [qlge]
[...]  ? static_obj+0x8a/0xc0
[...]  ? lockdep_init_map_waits+0x26a/0x700
[...]  qlge_init_device+0x425/0x1000 [qlge]
[...]  ? debug_mutex_init+0x31/0x60
[...]  qlge_probe+0xfe/0x6c0 [qlge]
[...]  ? qlge_set_mac_addr+0x330/0x330 [qlge]
[...]  local_pci_probe+0xd8/0x170
[...]  pci_call_probe+0x156/0x3d0
[...]  ? pci_match_device+0x30c/0x620
[...]  ? pci_pm_suspend_noirq+0x980/0x980
[...]  ? pci_match_device+0x33c/0x620
[...]  ? kernfs_put+0x18/0x30
[...]  pci_device_probe+0x1e0/0x270
[...]  ? pci_dma_configure+0x57/0xd0
[...]  really_probe+0x218/0xd20
[...]  driver_probe_device+0x1e6/0x2c0
[...]  device_driver_attach+0x209/0x270
[...]  __driver_attach+0xf6/0x260
[...]  ? device_driver_attach+0x270/0x270
[...]  bus_for_each_dev+0x114/0x1a0
[...]  ? subsys_find_device_by_id+0x2d0/0x2d0
[...]  ? bus_add_driver+0x2d2/0x620
[...]  bus_add_driver+0x352/0x620
[...]  driver_register+0x1ee/0x4b0
[...]  ? 0xffffffffc08e9000
[...]  do_one_initcall+0xbb/0x400
[...]  ? trace_event_raw_event_initcall_finish+0x1c0/0x1c0
[...]  ? rcu_read_lock_sched_held+0x3f/0x70
[...]  ? trace_kmalloc+0xa2/0xd0
[...]  ? kasan_unpoison_shadow+0x33/0x40
[...]  ? kasan_unpoison_shadow+0x33/0x40
[...]  do_init_module+0x1ce/0x780
[...]  load_module+0x14b1/0x16d0
[...]  ? post_relocation+0x3a0/0x3a0
[...]  ? device_driver_attach+0x270/0x270
[...]  bus_for_each_dev+0x114/0x1a0
[...]  ? subsys_find_device_by_id+0x2d0/0x2d0
[...]  ? bus_add_driver+0x2d2/0x620
[...]  bus_add_driver+0x352/0x620
[...]  driver_register+0x1ee/0x4b0
[...]  ? 0xffffffffc08e9000
[...]  do_one_initcall+0xbb/0x400
[...]  ? trace_event_raw_event_initcall_finish+0x1c0/0x1c0
[...]  ? rcu_read_lock_sched_held+0x3f/0x70
[...]  ? trace_kmalloc+0xa2/0xd0
[...]  ? kasan_unpoison_shadow+0x33/0x40
[...]  ? kasan_unpoison_shadow+0x33/0x40
[...]  do_init_module+0x1ce/0x780
[...]  load_module+0x14b1/0x16d0
[...]  ? post_relocation+0x3a0/0x3a0
[...]  ? kernel_read_file_from_fd+0x4b/0x90
[...]  __do_sys_finit_module+0x110/0x1a0
[...]  ? __ia32_sys_init_module+0xa0/0xa0
[...]  do_syscall_64+0x33/0x80
[...]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

With qlge_get_8000_flash_params+0x377/0x6e0 corresponding to the following:

	if (qdev->flash.flash_params_8000.data_type1 == 2)
		memcpy(mac_addr,
		       qdev->flash.flash_params_8000.mac_addr1,
		       qdev->ndev->addr_len); // <---- Here

IIRC I didn't see this with v1. However I didn't test v2, so I'm not sure if
this issue is introduced during v2 or v3.

Best,
Shung-Hsi

