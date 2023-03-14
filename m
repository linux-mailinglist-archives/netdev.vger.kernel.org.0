Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E1F6B9888
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCNPHe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjCNPHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:07:31 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F49ADC1E
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678806445; x=1710342445;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0/gkbKWwlRO68IzZO2FNp9FVfEhP/7I9BkXrgqkPQyU=;
  b=mSbiaOELEXSNbsphjLuz46sN/deSi2p8YGplcYEE1z0NJOBHAH4XGQMF
   8LiICXzF5nua7FE6vFbmONL/YXnCaNnibaV9IhIOOu6vNAH7LGzDmy2J1
   EOoei7mHGB9KRu7Jv7OcU+R0DGgzRo8ujL5lePmMe/SXk3M0JrVvo/8N7
   M0pFPbe7ah2kjiUtrH8ad5ctkbUwwuSPBdzpT9GUPX4m64TPEzuX9Lrmy
   WaSIzR9iWXeX9IXtndalckb1x1Rd3xTbXcRfAtOPoRyEhZnt9Il3leS6n
   jwqmj3BtA6kY/zm8wNCJo3nmtSoKIdCIqVSqk5PViB9BRd/YaFFT6Q/zk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="317099574"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="317099574"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 08:07:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="789403003"
X-IronPort-AV: E=Sophos;i="5.98,260,1673942400"; 
   d="scan'208";a="789403003"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 14 Mar 2023 08:07:24 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:07:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 08:07:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 08:07:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 08:07:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XT//tyefwRrPTpq6SmskTLxf9S/V5g1Ce95yMYu2fFN4gK5nzvJfzA2kugmU/2cW4W+SqG9kllvzSenhJys8tmLpMOpp93NnkE+c9oiM7fl6QzsHkgAoUNBtBM7t38AdPUkfUigi5PGkGrEPwEJ+sxYD7AegblTPGii8kcdaQyuTvMdl6b6TdWDa4hkjka1fc6tBhEmtFgXm7qzU4f69+INpOwsyFzVK0fA2r6uhj+NU765KFn15Wv19+9c8HEzyJvfIXHu8ox4kd5YUWvmUvLJfTq2qPsvoBUOovXAz4ZSWMKPioJfuCDYCKA0tm0Bmr/5IjNdBY8EPoE4zRH8PpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LYBj1obcLxTa8Tp9vCLTH8tX/9UXim+SeWcvtdILHOg=;
 b=apJRCYZ5WCjH3apxfXzeVWwLA8rvAnPEdVFFCBrSA7aucJS/ky3g0R01kp9WRRjxir41vaQO5JHwhvYxwBVfqchoKaztc/X5tqwADiEZ85RtUAcCLprDjguJQscCsY2uaB0/2D47hte7OWV4YfIlniC48sRo407kl63CCyjiNegNkAbGCeKU4Voek4q3mpVbzrDhAHjFCgG0fBZ/yVZdiIM6oGsHfNeOzvLKUyEgzge0T3eKBxcjmHmBkTiKH0w1kWOr9g5qYFpkcOI58R/DcNLtw5gG5XdskRzug7IHd7sVQrU8TNo5T0SF3yQYAG14r+EQfOQwaaYo2DMEft3kUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 PH0PR11MB7469.namprd11.prod.outlook.com (2603:10b6:510:286::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Tue, 14 Mar 2023 15:07:21 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::cece:5e80:b74f:9448%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:07:21 +0000
Date:   Tue, 14 Mar 2023 16:07:15 +0100
From:   Michal Kubiak <michal.kubiak@intel.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>
CC:     <netdev@vger.kernel.org>, <monis@voltaire.com>,
        <syoshida@redhat.com>, <j.vosburgh@gmail.com>,
        <andy@greyhouse.net>, <kuba@kernel.org>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
Subject: Re: [PATCH net v2 3/4] bonding: restore bond's IFF_SLAVE flag if a
 non-eth dev enslave fails
Message-ID: <ZBCNozKDnFQGwR4A@localhost.localdomain>
References: <20230314111426.1254998-1-razor@blackwall.org>
 <20230314111426.1254998-4-razor@blackwall.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230314111426.1254998-4-razor@blackwall.org>
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|PH0PR11MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5dc0e5-2e06-4b68-65d4-08db249dcf63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0B0STgCJ/rQaddZFpbj4ZZAb+UcLfeFvPh6iQCh4WUbpjH88tRIJK5vFIYL8GTZN3n1ntJwxgSX3kyr9vOp1pAMuVa645iCh7LvJ8wIv5IIkwn3giKT6OF5qLPaAevyFh2R5up5+O3uCxQrDNTfbomz/bPk3lb0kbfmJcsH0AKSwO3f+alLsJZkHoBrf6ALYAzM1GswU04e5Ftv1PHcpo6MM0JDdDNt9nuUGiwavFiD0g6zFwGnbGRU0PKf0VKXdt/vOyquANEKIUz/pt0ejJM56cQapzaVRhW3dacGnxWJpskMXerbUSn8jxbR4zGAzkpGxu8ERmnhhno8yVZbx1fH8S8tzifgPopTzkVNqbzH0FXfxumZMGx6o75i4MT8vQiMvNPgyDqu2Y4Sxkx9XLqsx3vbOtwQwNrsOsiTGLEadmcEbtccHpXgoBxPQhI1ynPumcGrsCWmVF7Unl2NCyPx8PCxHVMS1BnhyoLoYJrR6zVOHTq1oTIysUlIWA3FrzWJKw3T7LahDeHU0kv3jJo1BM1up9paqd0oB7WKphLHl7Y2KddDcjcpZmxOLKj0ZESUli2r1WL7WfM+XpMVintDSnU5zNrn2+MoWOgWiSSCSd3JYoOwBaIv6NkkLSKpvT5z3d2d84NTjxxGzghDRbm5130BV4l7AhxEXp4SAjjWeME+QMOn1ul0t1be/hbiF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199018)(86362001)(82960400001)(38100700002)(478600001)(8676002)(66556008)(66476007)(66946007)(6916009)(41300700001)(8936002)(4326008)(316002)(5660300002)(2906002)(7416002)(6486002)(83380400001)(44832011)(45080400002)(6666004)(26005)(966005)(9686003)(6512007)(6506007)(186003)(99710200001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mTqDUNiyJUy1+20qnJZZfQPTjrfyfeeiJBu4n69BuGHwRwnCBAQ/Wc5CbTp3?=
 =?us-ascii?Q?xmdHuacFt+TbXpO1mmNTSVpT4ALvTXYcBcEg9HT7BJ8cmmhLOW1iJjAmn0UR?=
 =?us-ascii?Q?MsPsSTunyuNivWx2GOFrAOHISYUYpwCyNTBXIOAsRl+3/TSYxPAGoQ2ZkaHB?=
 =?us-ascii?Q?1Ihbtho/7soD6qo/q+Er15f09Iatx4vnHIr0/JPzMMKpmrvRV4zmqYAb0k6c?=
 =?us-ascii?Q?FTfk8J4z2JkmeawZ1FgKRmSv4SNKvqCUTPGuASTQxnZGgzOgEfXSJ/MrowY9?=
 =?us-ascii?Q?7QJjzN4QcuzPvIAWair7Svn5mDAkPuEPnoCTR9h6zxCrVo9bM2hHC5jByLwu?=
 =?us-ascii?Q?VbSWmLDWojK6mKHNkQg0e1e8nprIaDCntjcXnSqIz2+Wc2+0/9qmWMEyXUEB?=
 =?us-ascii?Q?bPUl2gFRU63cyfmOtq0dxmuV7iRvlyEsvqfUmlBDv/Bfj+uS9lmyudNLnh/H?=
 =?us-ascii?Q?fVBLsb+dQe2vSL0iNiTgIkzcKED20ZGvwTm1vfJpAc6Jjw7g/yy3A58Gnxg3?=
 =?us-ascii?Q?9hUUYX4qqq2GgTfSt6j39YR1SfbTSCMAcdGJ2U/+oHvb6rdCNowhpzRBCc8n?=
 =?us-ascii?Q?egM8YtByDdx4s2d+rrDtS10MeEl3CzPtWiYSYbFs2HKLIy0m4kLREKltBT2c?=
 =?us-ascii?Q?7sz3PMFxjhE1R29Z5QwmrD27Xmu6nYmfADzpA8X91BPcTiQjo9RhxyaIIH+y?=
 =?us-ascii?Q?xZ/iGX8DkXTCSIVJkLTtYlLeCPRj640eavXj71yCmvZN8x/Sm9ycuMWrbfCy?=
 =?us-ascii?Q?4GWaaFcy5iVPOj6qVf7KKk/ajp5qBHsFH+TVKPQtZqjEmg9Y2TGcgcYgvO+K?=
 =?us-ascii?Q?RY2lXMwx269f75lLqwGkKUNGtdhs6cQ3XFB4MD4PsZliLTrtkbyv7W3aBO7m?=
 =?us-ascii?Q?cnFDe1xos434lOqUD4p/51W9eAsynIzJ4N5qGzI7Em4MM+WZ/pjQsXIFNwMt?=
 =?us-ascii?Q?4fJb2ufl81JQeX6hxr7/dFqdjV76qK0x0tXa9D32kAyaF3dJbRfCiSuYzRrZ?=
 =?us-ascii?Q?DHOZAHsDSjcZtjKGK/87ES0qlYoIttuWS+g5MPT0Qy8896Pl2kNMLjNAKm4l?=
 =?us-ascii?Q?FTe79PZ1JGMFCgQjaiVFbFcCeOejR/sbs2WVWfbd6OdWTyLl0l+bjyKetW3Z?=
 =?us-ascii?Q?SqkQiCAuLZUJg1yApXyuRUVa3WhPGStlWRvBKfcPyfZ8+jkLSdGwVrAWADNT?=
 =?us-ascii?Q?pW0fMsP74uAMQypd/IsF3ut0ZoDNNbVcwa3qFxKRZDKkrOJlepSVWUhR9Bs0?=
 =?us-ascii?Q?sLqZ5CdnF+ZQTUl45ls1gZZ8epT4IxAsnBKsm7T/pMrKtJwTGZutdtA9aDty?=
 =?us-ascii?Q?kZ7ES+NaiX5lD1yXlV/UyLe9I307HyrsdbBkC6EWljXb8doLiT5Zwtjo4+Eq?=
 =?us-ascii?Q?jexur3mTZcLxP2YOn6GaQjghW6dD9NcSCV3neME/53q+x5vcz/TkRoNmGqAx?=
 =?us-ascii?Q?zFjn6Rq1s9ab0U3gUqbYjAjm2j5Pg+rcrZNyskVujXCBd+SEePCSrxQadXku?=
 =?us-ascii?Q?Xg0UE51sQawX8Ulsp/6WnUMcLrJhzSSkGgJarxjyboJSAqsxRJqVjU77ONqd?=
 =?us-ascii?Q?yzVhu8l6SBQCcu/8Nc9q0REVqv8hklk/ocBC4ukZ10WMtFjpMBvHnn6vyoKK?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5dc0e5-2e06-4b68-65d4-08db249dcf63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:07:21.2482
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEV5372E7c/lL0wVnWeFSB0rud8FKGUP2AAnwKcdZn3XAJDdF1szJRE8rJpPenVAiwvYE8trc/ZyqIXgvCnwAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7469
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 01:14:25PM +0200, Nikolay Aleksandrov wrote:
> syzbot reported a warning[1] where the bond device itself is a slave and
> we try to enslave a non-ethernet device as the first slave which fails
> but then in the error path when ether_setup() restores the bond device
> it also clears all flags. In my previous fix[2] I restored the
> IFF_MASTER flag, but I didn't consider the case that the bond device
> itself might also be a slave with IFF_SLAVE set, so we need to restore
> that flag as well. Use the new bond_ether_setup helper which does the
> right thing and restores the bond's flags properly.
> 
> Steps to reproduce using a nlmon dev:
>  $ ip l add nlmon0 type nlmon
>  $ ip l add bond1 type bond
>  $ ip l add bond2 type bond
>  $ ip l set bond1 master bond2
>  $ ip l set dev nlmon0 master bond1
>  $ ip -d l sh dev bond1
>  22: bond1: <BROADCAST,MULTICAST,MASTER> mtu 1500 qdisc noqueue master bond2 state DOWN mode DEFAULT group default qlen 1000
>  (now bond1's IFF_SLAVE flag is gone and we'll hit a warning[3] if we
>   try to delete it)
> 
> [1] https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> [2] commit 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> [3] example warning:
>  [   27.008664] bond1: (slave nlmon0): The slave device specified does not support setting the MAC address
>  [   27.008692] bond1: (slave nlmon0): Error -95 calling set_mac_address
>  [   32.464639] bond1 (unregistering): Released all slaves
>  [   32.464685] ------------[ cut here ]------------
>  [   32.464686] WARNING: CPU: 1 PID: 2004 at net/core/dev.c:10829 unregister_netdevice_many+0x72a/0x780
>  [   32.464694] Modules linked in: br_netfilter bridge bonding virtio_net
>  [   32.464699] CPU: 1 PID: 2004 Comm: ip Kdump: loaded Not tainted 5.18.0-rc3+ #47
>  [   32.464703] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.1-2.fc37 04/01/2014
>  [   32.464704] RIP: 0010:unregister_netdevice_many+0x72a/0x780
>  [   32.464707] Code: 99 fd ff ff ba 90 1a 00 00 48 c7 c6 f4 02 66 96 48 c7 c7 20 4d 35 96 c6 05 fa c7 2b 02 01 e8 be 6f 4a 00 0f 0b e9 73 fd ff ff <0f> 0b e9 5f fd ff ff 80 3d e3 c7 2b 02 00 0f 85 3b fd ff ff ba 59
>  [   32.464710] RSP: 0018:ffffa006422d7820 EFLAGS: 00010206
>  [   32.464712] RAX: ffff8f6e077140a0 RBX: ffffa006422d7888 RCX: 0000000000000000
>  [   32.464714] RDX: ffff8f6e12edbe58 RSI: 0000000000000296 RDI: ffffffff96d4a520
>  [   32.464716] RBP: ffff8f6e07714000 R08: ffffffff96d63600 R09: ffffa006422d7728
>  [   32.464717] R10: 0000000000000ec0 R11: ffffffff9698c988 R12: ffff8f6e12edb140
>  [   32.464719] R13: dead000000000122 R14: dead000000000100 R15: ffff8f6e12edb140
>  [   32.464723] FS:  00007f297c2f1740(0000) GS:ffff8f6e5d900000(0000) knlGS:0000000000000000
>  [   32.464725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  [   32.464726] CR2: 00007f297bf1c800 CR3: 00000000115e8000 CR4: 0000000000350ee0
>  [   32.464730] Call Trace:
>  [   32.464763]  <TASK>
>  [   32.464767]  rtnl_dellink+0x13e/0x380
>  [   32.464776]  ? cred_has_capability.isra.0+0x68/0x100
>  [   32.464780]  ? __rtnl_unlock+0x33/0x60
>  [   32.464783]  ? bpf_lsm_capset+0x10/0x10
>  [   32.464786]  ? security_capable+0x36/0x50
>  [   32.464790]  rtnetlink_rcv_msg+0x14e/0x3b0
>  [   32.464792]  ? _copy_to_iter+0xb1/0x790
>  [   32.464796]  ? post_alloc_hook+0xa0/0x160
>  [   32.464799]  ? rtnl_calcit.isra.0+0x110/0x110
>  [   32.464802]  netlink_rcv_skb+0x50/0xf0
>  [   32.464806]  netlink_unicast+0x216/0x340
>  [   32.464809]  netlink_sendmsg+0x23f/0x480
>  [   32.464812]  sock_sendmsg+0x5e/0x60
>  [   32.464815]  ____sys_sendmsg+0x22c/0x270
>  [   32.464818]  ? import_iovec+0x17/0x20
>  [   32.464821]  ? sendmsg_copy_msghdr+0x59/0x90
>  [   32.464823]  ? do_set_pte+0xa0/0xe0
>  [   32.464828]  ___sys_sendmsg+0x81/0xc0
>  [   32.464832]  ? mod_objcg_state+0xc6/0x300
>  [   32.464835]  ? refill_obj_stock+0xa9/0x160
>  [   32.464838]  ? memcg_slab_free_hook+0x1a5/0x1f0
>  [   32.464842]  __sys_sendmsg+0x49/0x80
>  [   32.464847]  do_syscall_64+0x3b/0x90
>  [   32.464851]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>  [   32.464865] RIP: 0033:0x7f297bf2e5e7
>  [   32.464868] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bb 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
>  [   32.464869] RSP: 002b:00007ffd96c824c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>  [   32.464872] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f297bf2e5e7
>  [   32.464874] RDX: 0000000000000000 RSI: 00007ffd96c82540 RDI: 0000000000000003
>  [   32.464875] RBP: 00000000640f19de R08: 0000000000000001 R09: 000000000000007c
>  [   32.464876] R10: 00007f297bffabe0 R11: 0000000000000246 R12: 0000000000000001
>  [   32.464877] R13: 00007ffd96c82d20 R14: 00007ffd96c82610 R15: 000055bfe38a7020
>  [   32.464881]  </TASK>
>  [   32.464882] ---[ end trace 0000000000000000 ]---
> 
> Fixes: 7d5cd2ce5292 ("bonding: correctly handle bonding type change on enslave failure")
> Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=391c7b1f6522182899efba27d891f1743e8eb3ef
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

