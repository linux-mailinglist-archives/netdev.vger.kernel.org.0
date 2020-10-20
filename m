Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437E32936E4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 10:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392078AbgJTIgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 04:36:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:45844 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389056AbgJTIga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 04:36:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603182986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y5swQdbkQzp2TrJXK+MEV+AIBrovWzGv7cK2LDPOoXo=;
        b=EMW9UoyZIQV5PYksP3BVDhRbAj/gTi6El9Byo7wr+0wYYIgkFdvc5PykkNfd62KLheB1Jc
        y8A9iaiu/tlyDYUAG4JgxA2X2LXHSDcRFXfrvkkJ0pApEv3by4PJtm6Q3iRoKegu6+mTf9
        rpBFXP8QaD895mAoEfNWqtfAToFBu9Y=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2055.outbound.protection.outlook.com [104.47.2.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-TdyGAyicP7SzQ4t-yOcD_A-1; Tue, 20 Oct 2020 10:36:24 +0200
X-MC-Unique: TdyGAyicP7SzQ4t-yOcD_A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVc/xsChpUXY5XP6Xrg28SE4d+fyaE0CwrBBfKJW3ZdaPPsLAHJVlRgf6kiXxswNz9/gtW5mzdEg1bzlcBcFkt7sqG7BPFcleiOQ7g0iSTdH6CLlYpqEvHiOX+2H0DICQ7AOODQf+sk8V/Y7B880LKbHiROGG66OIQQH6RxBawV4SQuCMxD+oxLXM0hdjkJTW/Xvh0Ohsd1n6unXNHxoRlgh5Cf9enJuQ22hKlhwYJKD7C1nU/DZWPrVrZ5m0EWyihXL33I/V9DCytsmQ0wcw4ibZCvzVYd31cYC3AzfeNwQgyw7isPNt5zhown8n59ZZSW8QIvemM4QabAi8FifAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y5swQdbkQzp2TrJXK+MEV+AIBrovWzGv7cK2LDPOoXo=;
 b=mJXlvdgZQA1tAhluKx+1Cf6GKiCHnrZ9skDxUGP7O3g1mJEoGvlcHyYAzZI6p1vkQZ7ifAuYUe7RmyJssufqSMzePyOA8Mfhfej0y86lLSayMFASoVWAqNIH0K0PKPGWWWPAeAJTu3TGaOPrwzwhcIJl3g3FfnXPSRgWRYpzesuciKb3c3i8SZmbVQW7pZn7PJzrNYBLR8PqSnjMl9JBFJuGfz5qyeMDDGvkd+pTPWoe+xxf/PodyexSRffgV+c0mbDYyTK72GsXbJjVShNEDJGZXLKKGGUDnRm/F/VuLloqdWz40Gw51qnGuOagCwhalhoPHAvdKl/ZuBUMsXKUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com (2603:10a6:10:20::21)
 by DB7PR04MB4841.eurprd04.prod.outlook.com (2603:10a6:10:13::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 20 Oct
 2020 08:36:20 +0000
Received: from DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff]) by DB7PR04MB5177.eurprd04.prod.outlook.com
 ([fe80::7585:5b21:1072:f5ff%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 08:36:19 +0000
Date:   Tue, 20 Oct 2020 16:36:09 +0800
From:   Shung-Hsi Yu <shung-hsi.yu@suse.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] staging: qlge: Initialize devlink health dump
 framework
Message-ID: <20201020083609.GL7183@syu-laptop>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-3-coiby.xu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201014104306.63756-3-coiby.xu@gmail.com>
X-Originating-IP: [2001:b400:e256:5604:908c:43ff:fe8c:2fe3]
X-ClientProxiedBy: AM0PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::29) To DB7PR04MB5177.eurprd04.prod.outlook.com
 (2603:10a6:10:20::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from syu-laptop (2001:b400:e256:5604:908c:43ff:fe8c:2fe3) by AM0PR06CA0088.eurprd06.prod.outlook.com (2603:10a6:208:fa::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22 via Frontend Transport; Tue, 20 Oct 2020 08:36:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a0810c4-4de3-4653-8a0a-08d874d3377d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4841:
X-Microsoft-Antispam-PRVS: <DB7PR04MB4841A248506DFFCC9619CCB8BF1F0@DB7PR04MB4841.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: erAMvxRXau+6fnoo0WJpqp76pDLo3/VkjD+l+pCtxZPl4PgtHluwm+ndK7bjA1G8TdTwLKRMwQ6xxXDaXbpNIKpuGwhFUAayhwYR+mH5ChGeO1q0YjrIzmAF4ke9VoDn7usfuHIp0PEPXdDmi3oQD8L3cHRMym7L49f3S3CI990WxEEoC0Zj9ABcsMC3gnEx5OK7jlQKHN0nXrS7+3D2c4YLuayQ+NWRaBB8Okj5O9wbZ2JGxwVFDtoFJC6DFBRsMyb4bCMWCEgZhN2Ggum5Yc6Q/UX07oaFFNriPxStL2hEVtZzqbXqG8ECJ0xa6B6iiDGl8HIgU/tBYmQAo3htnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5177.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(396003)(39860400002)(8676002)(54906003)(4326008)(7416002)(33716001)(83380400001)(478600001)(2906002)(9686003)(52116002)(8936002)(66946007)(5660300002)(6496006)(6666004)(86362001)(316002)(16526019)(1076003)(6916009)(55016002)(66476007)(33656002)(66556008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vkpokVFKsU/GuiYquPFOTh1xpzpK8b1Gdk9O778Rh1hpF07q8N1nrvc9JFJBogGVoKrsF3uFKi6CKeyYC8eLtdr+WKFlGwT1sHVv5w+Ve+aDnxD17SMgJNgkSUeEjR3NrtmBiNOIb92IjZN4rVKCbcLXhOCq7Y727OZ8mI9XPBPF2SVzVT2+8zJ256DN2Z9EWbp4BAV8I+bLLqPkmWvhUuXnwotBHfzqI46VbFg66JKqXVrU3V3SuIWuluBsesU0pCrOtGpX8Dg/IXYq1qO0igvSPCYl1+ZisVTH4ABLrCDx4OjZMbIWn2nQt2JgwPwLvVzWHnN7+Ji1QJxoKZ4uDBn0VSY+R1k+x1sehaE7Rppd93m9x18fSgzeogF+K+DF5WpjkeLzniUI3/TZS32FRASdv5DPIt1plznUaTj0zDaZvUqVW39DqJE6z0cWtpURdAFmdbKi/9L8/wP2sZebm6XjxDDz9wweWBmzAVBZLNfeOCG/3BZWWpAQ4jThxdNHqVmgW2G0tVI43SKRQKYdHJVnCchrQkPtmsnCs65AidlGW/zZ/YoWppslRCFI7D94Izppa3IGbuNSSBo/MvLmIf6sJBm91+UWuYcMuBTEMq3++no0XPeiqiPcGrakdK9F1fXTGo7xoRLw/KkUmEZZ5/YbXR4VDC/UkSXsPEl4sGt0QH82qw3/ZUNVHPohFhtNFNe50UacJG8+SIZ7vMyUeg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a0810c4-4de3-4653-8a0a-08d874d3377d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5177.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 08:36:19.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lW/JlAlBC7h3I2DpjAhMJ8ayktoZ2619CljSwhqVTnLhLjPIjdDOmsk9za6qOzOs72iO4Dg6h9t+Jr6HGsbebQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4841
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

