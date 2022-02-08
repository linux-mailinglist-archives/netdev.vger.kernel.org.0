Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4524D4ADA77
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377012AbiBHNzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357662AbiBHNzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:55:39 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2091.outbound.protection.outlook.com [40.107.92.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12454C03FECE;
        Tue,  8 Feb 2022 05:55:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuhGP2U19i8nKHPyaP6GX44j8GoqDEbx/TGefigGr5AS4W3zIlOzsVGT10A4L5mjvfgnWsouz1jMK9n55U3Vbid1e5NbQ96OdmGuGbxWXyDcIKyVpomPfAYmKZqyVshyOhj8H0sdtUYhVhMNydo0J8+nCKo85742crx4XkpFwQ5dCB5xlIsE8D6PKuXApyb++EIdhStqOaQMgOfua/ErshyjooDQFtnZaf9MG530ScVS30S5cayZWjD9VtGwqgGg0zuajFYtXFUKcBLv5+fW/Rj4cXxkg2HvVB1ybXVWqxD1JgzJcP7gxiGzGKjEYgw5RLJwHotOXTDN7gJ77EgU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RgqlFp+OPpd2XggpFgCesukttC9K1SJK+XAPrqvzcCk=;
 b=gp5M9fQkXJea7mxrCZRD7PRJhXDJNCT6sZNgQq9HsIphCAlLbJHdiN9bxnf1/hm8LPS3OSvKHhM1H+LJZYWEJtc5s+TtzKaaEXKgAxwKYPwiRhtD5vrE1SpEYjIUS/IATnm2IKr1S75Bk0SUMIP1EomGBYSnvY8DPBLoy1yU0vETzmGufiZ4lgHgVva2q8kXY/IDD6kCqjdOkYzUnjEiP7VUp6L8f7cYjIDhBjdACmhyYy+CVAdtw+SPFnKVKAP1Nx2yJResPEXaTgggp3CFvAJUfSgl7bWEGCC2gXEVxQ66RRxcJltyBw3ADflhSzqPBm0FLG9kftqL3ZVh5BKAFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RgqlFp+OPpd2XggpFgCesukttC9K1SJK+XAPrqvzcCk=;
 b=FFfOCboPt2FEVn6nFgQ0ICwNBb+oahLIJmtQzibT0FTVhfnHDA8TR2i+Y31AKBMmHwRYsSWs9/fjCS++P5lB6cMNH+WPGVn/sGkC1jkQ2oE+zD2M/O3JPUtWOSMNO2+Y5EUKu5JpAKyijvYsSg+kt/sxMvBANgHhjt7FuL0ym/Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM8PR10MB5447.namprd10.prod.outlook.com
 (2603:10b6:8:32::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Tue, 8 Feb
 2022 13:55:35 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 13:55:35 +0000
Date:   Tue, 8 Feb 2022 05:55:32 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Message-ID: <20220208135532.GB246307@euler>
References: <20220208044644.359951-1-colin.foster@in-advantage.com>
 <20220208133016.axi7ruhop2lc65ly@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208133016.axi7ruhop2lc65ly@skbuf>
X-ClientProxiedBy: CO2PR04CA0162.namprd04.prod.outlook.com
 (2603:10b6:104:4::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a7c0cf18-1376-48a2-dfc7-08d9eb0aadfc
X-MS-TrafficTypeDiagnostic: DM8PR10MB5447:EE_
X-Microsoft-Antispam-PRVS: <DM8PR10MB5447E4E735D806F657165C9BA42D9@DM8PR10MB5447.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0bb7woZPku634KTFMvyKaqyzMlOQ8YL6W0SfINNe4kAVfN2zP0llkGNXLNhxCbOIq1EuwMK5eeR6I6TUTiNjC1WZIYY27jEKNZCsxh7wXiIfXigNxAP7pZ4urzkEKqnPfY2Bnj5u58GjWItI0OlQjoh2V9uUyyhunP0HM+nrBJISe5tiLFcGdlZmCLIvsFGABK8emPOtEzWsrcUi9MaMGm04ZwLG1787lTIU4RcZ5F3xVmuPCBL4i9J9gVAZIjEXtgN8BRZCeAnskh599FivSavCxO8S5Tk1n2IP2tFY0+pwxYRodUYOlEY86B36gkph/A5tParmi9/a2omOUzuhfZyOlB/E7BZua1MeN/ki3Z5rCWmSKf4QQpE8gJKGaRQtn5CdLDhIeSBlD3oYiLb6IMw7T2biNOJJ45s3+mZI6cMBvyFfesnhnDwuGFqRyQ89H9ETaTsRF3a4iEc5oNYmvwfcPYsnWqo1bV7QX5GpMN496q/XAJN6TyD11Ygr6yssBAH8k4iUaIKVRp3pGb5erTuhjYiT1etRYTuQpmeOpQiOkNJ2NezCUAQIiHyAq5LRImt0G8pDT0+iGoF7PxDcHysrXJX8L1onmcVZuDRBJm9/WoXuL5nzfeRi6b4rrBaeyQBosGctKB5wgHGm4ZiZ+cJNJKp2St30pFIB9sl2gyiaxNZR9sQU9dN1ZoPRp+w4ZeRd/5oVowwCPWPKmcfXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(39830400003)(396003)(346002)(366004)(42606007)(136003)(1076003)(186003)(6512007)(9686003)(26005)(8936002)(52116002)(83380400001)(6506007)(6486002)(316002)(33716001)(45080400002)(54906003)(6916009)(6666004)(44832011)(33656002)(2906002)(86362001)(66946007)(5660300002)(30864003)(508600001)(38350700002)(38100700002)(66556008)(4326008)(66476007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X0wIAhWWXSjQaicKpYsQ95j7AHsD0oUz9FkDT0QOAid7eO7sIX3ljUfjWScf?=
 =?us-ascii?Q?bbvmgb0foB7JbJvB9XC5K9MkgTAxWgA5UgsCstwDJHL9C07QdWPgGLXjq3Oh?=
 =?us-ascii?Q?Ia5lJaGFTNS+gYhAj7UPXoalw/xSHWhztzpHVRRocLuRzC7POUi1FK+jsHot?=
 =?us-ascii?Q?nv7X5f0W/CNqkvDudV/y1SI18DwmU67IzGqYV3wPeOgjdhgowZUX1DYgFodA?=
 =?us-ascii?Q?JjBLdZMv+qVWDvKTcpmdpvD/0c3URGxpqMpeOOG4bcAh0u4K28x9zfZ0J3CE?=
 =?us-ascii?Q?IhUEr9eAM8bUpbPSqDdPs3o3wlG6c7ysSDw6upEepeDr3wOnHR1azNi2GAZC?=
 =?us-ascii?Q?6vhttrCJJYUBw0dODQkob2SMZugNwc2lqI1YzcOlXGnbJwpsmHSD7VlygKEF?=
 =?us-ascii?Q?bHafQp6zNQ4+1VM7A5jVpBhaoLo/lkiEx3SMkk5q2sKDT9cEni3zMwD4rOvG?=
 =?us-ascii?Q?gcZ2druTsA14gD2LWdRPbSkqTGHwW93nbjsYejYOrvjsNwGKtaC/UgZUD+kk?=
 =?us-ascii?Q?ls1sLbRPyO2W4SiUsmPb3vvi2cF1XTNvqGy/L9K/fRPzDTPG76IPv+XNg6dW?=
 =?us-ascii?Q?de9W5f4pnNOnufE6YLsXvY9jDnBffGNDqfoH/hEj0G6hjjNtOQgFXobeJKGf?=
 =?us-ascii?Q?W/De0mzIJ5kV+PFfZUJdovtiw4qRJLuR57b6FPjZKtgGgti6dnBXKxD9M6hd?=
 =?us-ascii?Q?LHg99W0KS9b4sQDThiwMOmYfG53PCUpSodn5yTUTXGyo5WYPZ77rDGjYfwG7?=
 =?us-ascii?Q?gjFGx5l7jVza5cO8+lb5QC4m0mgCroj96gW+GoSSgE1bWG+QQy5H4DwwzQoT?=
 =?us-ascii?Q?AC516Gto0olJBJhYLJDdGeHzLqd8TDjxOEN3vJ8AGc+kYUs4ZB119HtuE3bZ?=
 =?us-ascii?Q?EvWbqjsdM++4Qjh/3IEmQKJ5/6QJD8A3PTtqE35725zIlfSFHNgooKpbbxVE?=
 =?us-ascii?Q?lSLQNvrIRfVLDPUsl+e/C1p+9W0Q/O+pQb5bM9NR/NWEa96B+g6W9jCzJOlX?=
 =?us-ascii?Q?8iUT7UfEB+Azi3KafD1gSgx2zyKCfHLt/i266+5vvw/gOY2QrIyLb4AVU71H?=
 =?us-ascii?Q?LF9gvEgI7GEWpajQDVI1nS1XqgQHoux9mUYW3dli4WVIBGX21aikVe1mWvWK?=
 =?us-ascii?Q?mhoxnRbZ4GnLYD9ZPHxQgZPpAKwo/alnwqKveuNP2Y/MmN7IlLgKReUtoq0V?=
 =?us-ascii?Q?u8ueekfbw6KC8UUqDIwPusz7ua0rDrS3FFtL95OKvOFo52GUoQctfkMrtskb?=
 =?us-ascii?Q?QQ44XOEuyot2D0N9mDCd80Eub2XUTTuIrknUrVldQIgdj9Jz0CVwzRDyndfk?=
 =?us-ascii?Q?9wHC/3VffuNXh/xNuRQ5tuaadmOTPUG+bHhzV9Og/dtxdSId2C/B2+jfEjbO?=
 =?us-ascii?Q?ELaPA19kYkl7ABvTVOsri42wfJzHEIauTB9mMcp2sr2FoYRekzDdhDx4E2iq?=
 =?us-ascii?Q?JuT+px6c27BVyPM1skNdGkA3VBjlvKKvqEsmmvj0KEb3aDB1leWoPk8GTkms?=
 =?us-ascii?Q?/YlPoAysN7ju40EFE2m+T95Il7gY/m9/08wTEmYcFM4D+OUBnJ6mA3uRmJs2?=
 =?us-ascii?Q?eaGsvhyUSgl+qWsmNO/ztMFwFW+H80LtVVDstq14VZa9yq+PtHE3GlXIgegE?=
 =?us-ascii?Q?v0lnPgoSF7CiVZa4kLsbaWvKJoAfIo9aRDduaW3EgVv30DMYPbYxXCIFKpEp?=
 =?us-ascii?Q?q+5O1g=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7c0cf18-1376-48a2-dfc7-08d9eb0aadfc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 13:55:35.3991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8WppkvJuuhMVGNKa/ftIlNk/c9U8sdKeYrueLZWvlvf4M6zdpihrZBaAmpk3XAD33LIVujJnVEl6y/9iAtDInU1QYkl892Or9tZ8Q0w7OoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5447
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 08, 2022 at 01:30:16PM +0000, Vladimir Oltean wrote:
> On Mon, Feb 07, 2022 at 08:46:41PM -0800, Colin Foster wrote:
> > Ocelot loops over memory regions to gather stats on different ports.
> > These regions are mostly continuous, and are ordered. This patch set
> > uses that information to break the stats reads into regions that can get
> > read in bulk.
> >
> > The motiviation is for general cleanup, but also for SPI. Performing two
> > back-to-back reads on a SPI bus require toggling the CS line, holding,
> > re-toggling the CS line, sending 3 address bytes, sending N padding
> > bytes, then actually performing the read. Bulk reads could reduce almost
> > all of that overhead, but require that the reads are performed via
> > regmap_bulk_read.
> >
> > v1 > v2: reword commit messages
> > v2 > v3: correctly mark this for net-next when sending
> > v3 > v4: calloc array instead of zalloc per review
> > v4 > v5:
> >     Apply CR suggestions for whitespace
> >     Fix calloc / zalloc mixup
> >     Properly destroy workqueues
> >     Add third commit to split long macros
> >
> >
> > Colin Foster (3):
> >   net: ocelot: align macros for consistency
> >   net: mscc: ocelot: add ability to perform bulk reads
> >   net: mscc: ocelot: use bulk reads for stats
> >
> >  drivers/net/ethernet/mscc/ocelot.c    | 78 ++++++++++++++++++++++-----
> >  drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
> >  include/soc/mscc/ocelot.h             | 57 ++++++++++++++------
> >  3 files changed, 120 insertions(+), 28 deletions(-)
> >
> > --
> > 2.25.1
> >
> 
> Please do not merge these yet. I gave them a run on my board and the
> kernel crashed on boot.
> 
> [    8.043170] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 0
> [    8.050241] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 1
> [    8.057142] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 2
> [    8.064021] mscc_felix 0000:00:00.5: Found PCS at internal MDIO address 3
> [    8.128668] ------------[ cut here ]------------
> [    8.133315] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_vsc9959.c:1007 vsc9959_wm_enc+0x2c/0x40
> [    8.143107] Modules linked in:
> [    8.146181] CPU: 1 PID: 44 Comm: kworker/u4:2 Not tainted 5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
> [    8.155355] Hardware name: LS1028A RDB Board (DT)
> [    8.160079] Workqueue: events_unbound deferred_probe_work_func
> [    8.165945] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    8.172940] pc : vsc9959_wm_enc+0x2c/0x40
> [    8.176967] lr : ocelot_setup_sharing_watermarks+0x94/0x1fc
> [    8.182568] sp : ffff800008863810
> [    8.185896] x29: ffff800008863810 x28: 0000000000000308 x27: 0000000000000001
> [    8.193079] x26: 000000000300001a x25: 0000000000000008 x24: 0000000000000080
> [    8.200261] x23: 0000000088888889 x22: 0000000000000000 x21: 0000000000000000
> [    8.207441] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e2afa23b28
> [    8.214623] x17: 0000000000000015 x16: 0000000000000041 x15: 0000000000000000
> [    8.221803] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 0000000000000009
> [    8.228984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e2ad6ce0f8
> [    8.236165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 0000000000000001
> [    8.243345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 0000000000000000
> [    8.250525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 00000000000040c0
> [    8.257706] Call trace:
> [    8.260162]  vsc9959_wm_enc+0x2c/0x40
> [    8.263841]  ocelot_devlink_sb_register+0x33c/0x380
> [    8.268742]  felix_setup+0x438/0x750
> [    8.272334]  dsa_register_switch+0x988/0x114c
> [    8.276713]  felix_pci_probe+0x138/0x1fc
> [    8.280654]  local_pci_probe+0x4c/0xc0
> [    8.284423]  pci_device_probe+0x1b0/0x1f0
> [    8.288451]  really_probe.part.0+0xa4/0x310
> [    8.292654]  __driver_probe_device+0xa0/0x150
> [    8.297030]  driver_probe_device+0xcc/0x164
> [    8.301231]  __device_attach_driver+0xc4/0x130
> [    8.305695]  bus_for_each_drv+0x84/0xe0
> [    8.309547]  __device_attach+0xe4/0x190
> [    8.313400]  device_initial_probe+0x20/0x30
> [    8.317601]  bus_probe_device+0xac/0xb4
> [    8.321454]  deferred_probe_work_func+0x98/0xd4
> [    8.326004]  process_one_work+0x294/0x700
> [    8.330037]  worker_thread+0x80/0x480
> [    8.333717]  kthread+0x10c/0x120
> [    8.336961]  ret_from_fork+0x10/0x20
> [    8.340554] irq event stamp: 50432
> [    8.343968] hardirqs last  enabled at (50431): [<ffffd8e2ade442b0>] _raw_spin_unlock_irqrestore+0x90/0xb0
> [    8.353581] hardirqs last disabled at (50432): [<ffffd8e2ade36e44>] el1_dbg+0x24/0x90
> [    8.361448] softirqs last  enabled at (50148): [<ffffd8e2ac6908f0>] __do_softirq+0x480/0x5f8
> [    8.369923] softirqs last disabled at (50143): [<ffffd8e2ac728e3c>] __irq_exit_rcu+0x17c/0x1b0
> [    8.378577] ---[ end trace 0000000000000000 ]---
> [    8.383304] ------------[ cut here ]------------
> [    8.387942] WARNING: CPU: 1 PID: 44 at drivers/net/dsa/ocelot/felix_vsc9959.c:1007 vsc9959_wm_enc+0x2c/0x40
> [    8.397729] Modules linked in:
> [    8.400800] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W         5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
> [    8.411369] Hardware name: LS1028A RDB Board (DT)
> [    8.416092] Workqueue: events_unbound deferred_probe_work_func
> [    8.421955] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    8.428948] pc : vsc9959_wm_enc+0x2c/0x40
> [    8.432975] lr : ocelot_setup_sharing_watermarks+0xc0/0x1fc
> [    8.438573] sp : ffff800008863810
> [    8.441900] x29: ffff800008863810 x28: 0000000000000308 x27: 0000000000000001
> [    8.449081] x26: 000000000300001a x25: 0000000000000008 x24: 0000000000000080
> [    8.456262] x23: 0000000088888889 x22: 0000000000000000 x21: 0000000000000000
> [    8.463443] x20: 00000000ffff2d17 x19: ffff2d17039d8010 x18: ffffd8e2afa23b28
> [    8.470623] x17: 0000000000000015 x16: 0000000000000041 x15: 0000000000000000
> [    8.477804] x14: ffffd8e2afa49228 x13: 0000000000025700 x12: 0000000000000009
> [    8.484984] x11: ffff2d1703a96c18 x10: 0000000000000004 x9 : ffffd8e2ad6ce124
> [    8.492165] x8 : ffff2d1700be4240 x7 : ffffd8e2af981000 x6 : 0000000000000001
> [    8.499345] x5 : ffffd8e2ad1e1440 x4 : 0000000000000000 x3 : 0000000000000001
> [    8.506525] x2 : 0000000000000000 x1 : ffffd8e2ad3d2810 x0 : 00000000000040c0
> [    8.513705] Call trace:
> [    8.516161]  vsc9959_wm_enc+0x2c/0x40
> [    8.519840]  ocelot_devlink_sb_register+0x33c/0x380
> [    8.524740]  felix_setup+0x438/0x750
> [    8.528331]  dsa_register_switch+0x988/0x114c
> [    8.532708]  felix_pci_probe+0x138/0x1fc
> [    8.536648]  local_pci_probe+0x4c/0xc0
> [    8.540415]  pci_device_probe+0x1b0/0x1f0
> [    8.544443]  really_probe.part.0+0xa4/0x310
> [    8.548646]  __driver_probe_device+0xa0/0x150
> [    8.553022]  driver_probe_device+0xcc/0x164
> [    8.557225]  __device_attach_driver+0xc4/0x130
> [    8.561688]  bus_for_each_drv+0x84/0xe0
> [    8.565540]  __device_attach+0xe4/0x190
> [    8.569393]  device_initial_probe+0x20/0x30
> [    8.573594]  bus_probe_device+0xac/0xb4
> [    8.577447]  deferred_probe_work_func+0x98/0xd4
> [    8.581997]  process_one_work+0x294/0x700
> [    8.586026]  worker_thread+0x80/0x480
> [    8.589706]  kthread+0x10c/0x120
> [    8.592949]  ret_from_fork+0x10/0x20
> [    8.596541] irq event stamp: 50450
> [    8.599955] hardirqs last  enabled at (50449): [<ffffd8e2ade442b0>] _raw_spin_unlock_irqrestore+0x90/0xb0                                                                                                
> [    8.609566] hardirqs last disabled at (50450): [<ffffd8e2ade36e44>] el1_dbg+0x24/0x90
> [    8.617431] softirqs last  enabled at (50446): [<ffffd8e2ac6908f0>] __do_softirq+0x480/0x5f8
> [    8.625907] softirqs last disabled at (50435): [<ffffd8e2ac728e3c>] __irq_exit_rcu+0x17c/0x1b0
> [    8.634559] ---[ end trace 0000000000000000 ]---
> [    8.640586] device eth1 entered promiscuous mode
> [    8.645499] Unable to handle kernel paging request at virtual address 00000010400020bc
> [    8.653496] Mem abort info:
> [    8.656340]   ESR = 0x96000044
> [    8.659413]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    8.664784]   SET = 0, FnV = 0
> [    8.667855]   EA = 0, S1PTW = 0
> [    8.671044]   FSC = 0x04: level 0 translation fault
> [    8.675979] Data abort info:
> [    8.678875]   ISV = 0, ISS = 0x00000044
> [    8.682762]   CM = 0, WnR = 1
> [    8.685795] [00000010400020bc] user address but active_mm is swapper
> [    8.692272] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [    8.697865] Modules linked in:
> [    8.700928] CPU: 1 PID: 44 Comm: kworker/u4:2 Tainted: G        W         5.17.0-rc2-07010-ga9b9500ffaac-dirty #2104
> [    8.711490] Hardware name: LS1028A RDB Board (DT)
> [    8.716206] Workqueue: events_unbound deferred_probe_work_func
> [    8.722065] pstate: 00000005 (nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [    8.729051] pc : ocelot_phylink_mac_link_down+0x70/0x314
> [    8.734381] lr : felix_phylink_mac_link_down+0x24/0x30
> [    8.739536] sp : ffff800008863840
> [    8.742856] x29: ffff800008863840 x28: 0000000000000000 x27: ffffd8e2af8ef180
> [    8.750022] x26: 0000000000000001 x25: 0000001040002000 x24: 0000000000000000
> [    8.757187] x23: 0000000000000180 x22: ffff2d1703a92000 x21: 0000000000000004
> [    8.764352] x20: 0000000000000004 x19: ffff2d17039d8010 x18: ffffd8e2afa23b28
> [    8.771516] x17: 0000000000040006 x16: 0000000500030008 x15: ffffffffffffffff
> [    8.778680] x14: ffffffffffff0000 x13: ffffffffffffffff x12: 0000000000000010
> [    8.785845] x11: 0101010101010101 x10: 0000000000000004 x9 : ffffd8e2ad3d0814
> [    8.793009] x8 : fefefefefeff6a6d x7 : 0000ffffffffffff x6 : 0000000000000000
> [    8.800173] x5 : 00000000ffffffff x4 : 0000000000000001 x3 : 000000000d000007
> [    8.807338] x2 : 0000000000000010 x1 : 0000000000000000 x0 : 0000001040002000
> [    8.814502] Call trace:
> [    8.816949]  ocelot_phylink_mac_link_down+0x70/0x314
> [    8.821929]  felix_phylink_mac_link_down+0x24/0x30
> [    8.826734]  dsa_port_link_register_of+0xa8/0x240
> [    8.831454]  dsa_port_setup+0xb4/0x180
> [    8.835212]  dsa_register_switch+0xdb4/0x114c
> [    8.839581]  felix_pci_probe+0x138/0x1fc
> [    8.843515]  local_pci_probe+0x4c/0xc0
> [    8.847275]  pci_device_probe+0x1b0/0x1f0
> [    8.851296]  really_probe.part.0+0xa4/0x310
> [    8.855490]  __driver_probe_device+0xa0/0x150
> [    8.859860]  driver_probe_device+0xcc/0x164
> [    8.864054]  __device_attach_driver+0xc4/0x130
> [    8.868510]  bus_for_each_drv+0x84/0xe0
> [    8.872355]  __device_attach+0xe4/0x190
> [    8.876200]  device_initial_probe+0x20/0x30
> [    8.880395]  bus_probe_device+0xac/0xb4
> [    8.884240]  deferred_probe_work_func+0x98/0xd4
> [    8.888783]  process_one_work+0x294/0x700
> [    8.892808]  worker_thread+0x80/0x480
> [    8.896480]  kthread+0x10c/0x120
> [    8.899715]  ret_from_fork+0x10/0x20
> [    8.903303] Code: 52800202 f874d839 52800001 aa1903e0 (b900bf25)
> [    8.909417] ---[ end trace 0000000000000000 ]---
> 
> Investigating...

I just did a sanity check on my latest tree and it doesn't crash. I'll
keep an eye out here as well.

Gives me an opportunity to fix up your other suggestion.

Thanks for reviewing and testing Vladimir!
