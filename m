Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19406447C4
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235394AbiLFPQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiLFPP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:15:57 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2040.outbound.protection.outlook.com [40.107.6.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCEC430F65;
        Tue,  6 Dec 2022 07:12:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpoixbBX7B4g22nLPMiTduHeZSSojsmpoDQQSZA/AIZv9z7LJzPG/jJMK4RwUGLnVUxDU04r2lTDoAKH5RVA9B/08T2fTeiMOGhEwyFNQQrEm61CuVoGmDfNvWLJhcGW+sedgAkwryJic9Si2lvrNfOqz5sKmJrCLX8RuQXLPrpEn0cXiK2v6NM5V/UtX/82mC6UNiFizsZkhv0Ghdg9s042P68gYjJ40ga/L8OdQSH95LZFq0ZA+8nPy2G80mWdv8xjNwyynwEw+8yXH1tdJzvKFPFCGOHk9qmNEK0GuBLXEq98sxl4NY/mDPSzu8NZbjZSMUu5cLbbFODHVIgxKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1FOk5ZnTM5XtvUvEST+UWG5H5IAvzTSXGeQRleoXYZM=;
 b=ES7APreYZUQ+N243cmxNZ1fSd9WXcBKaDkvEEWdc9OPoK7QlqAbRLPfHEEo7lJJkdgXhGqRNHti2LrFlo+OeEn5F0NDaUoOtsiU80ytlHzg0EGhRzTE5mggN0m6T8TdmTc4aDlXVO32RqFeJwq861nUlYC98YY2SNINWbVvTH7ek3u+4t1919bsTvyAC9Ybw3dIAa70bBIOh+z9z1H/XAbnptehC2LmkPBC0sJESDQZs8f6CLEpwtV2sb7rfMLfxEHiCqIB0MKM7YQm1J15lnObIN8nBo8Z6siK+4vASHSPyyRYLoS/pMDM5NxAVTbHaUtNElueJYsUXlruxZWcRww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1FOk5ZnTM5XtvUvEST+UWG5H5IAvzTSXGeQRleoXYZM=;
 b=lrVNPpoW5Vu5rN30f51ByROC/J/WOvJLVoGfFCPUt3jmOAPTYvthVIwOj8H+qFQSPHqAcMX3AW1pUUjODZfRRjNTXtkZXFcBaAxBEFLasbdKLYwA34WEz94XZ4gueXqo+w+URJxuPD8ZJwXUVWjU6JkeDsZkK0fvbCEw+mIbQKk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com (2603:10a6:20b:409::7)
 by PA4PR04MB9365.eurprd04.prod.outlook.com (2603:10a6:102:2a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 15:11:58 +0000
Received: from AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9]) by AM9PR04MB8954.eurprd04.prod.outlook.com
 ([fe80::8966:68e3:9b91:a6e9%8]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 15:11:58 +0000
From:   "Radu Nicolae Pirea (OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     olteanv@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net, f.fainelli@gmail.com,
        Radu Pirea <radu-nicolae.pirea@nxp.com>
Subject: [PATCH] net: dsa: sja1105: fix slab-out-of-bounds in sja1105_setup
Date:   Tue,  6 Dec 2022 17:11:36 +0200
Message-Id: <20221206151136.802344-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0011.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::14) To AM9PR04MB8954.eurprd04.prod.outlook.com
 (2603:10a6:20b:409::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8954:EE_|PA4PR04MB9365:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d46f41-862e-43e2-d3c2-08dad79c3854
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c/6rk6Z5Ac3T/5K3hdTpojCJz3vIya5IIGm7C9y1LURVj0s3t+L7/yQOWdUhbvc2+nBeMac0G2qbtBsvQHLjlzNCO2p+BFkjRHV3vT00GnHIKTa4QbmbdIT7IWi5CwsFqDsDd0jw45n/0ty620LrmDDQVaqoujejvnBg7UOGDipsD5xUJEny0nyXng6jqYlT8jiQgF0MoAMfyo9dso17yKC9zS+01OarfQDPMyAo39CenKAAEGZWMBJEJpPyerLptGQwX4fQwmq/jC7qB9lsRu+G2tOIipVvhik0Sk73YV1nh0ef9DkG2QaMCfw2rCUTQvWzHCTIjct7FIG+eLB4MAuTt2EENYkJcHEh8YYmnU7X5lxatg6f3PyKL+vlEWZPjwzbHM3hfx4BWXosG0qUmeNIwh06Pe1KiEo5+nTkpS4Hz47unMXol6x5GQVH3OqmuDk0yRsStRUIF31H5+PfC2FfJDogfvBDEVz6YHAMmrKCUByhIHXsPvdQjyX8ITgvqV7psOPzlFHWu+ivxugixMBdGpWuU/Kc9XtfMgE+n8d8wLXVaQIenWoWgevjHNTFfp1X6YYZQQ3a5s7JMcHFTfW4nhD77rFLz9myv3S1wCeXRz4zNHTapNnMAZKsf2RWWran1UqTGIilaJ1h5Xa8dk3B972puO3TKH3CUlRVwCZhSmy6MOuhjEcLMV5pFj8PSc4UHUnce7sCPqVSjU+UZB8HtHLuYDdRt1CFnHXUm+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8954.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199015)(86362001)(316002)(478600001)(6666004)(66946007)(7416002)(6486002)(8676002)(4326008)(66476007)(66556008)(2906002)(41300700001)(8936002)(5660300002)(38100700002)(38350700002)(6506007)(6512007)(52116002)(26005)(1076003)(83380400001)(2616005)(186003)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NOLvaVDKlCDfK5gVe5BQQPXhCWrGrt5V0KS83C6dtbl2fWnITH5ALFONtXWu?=
 =?us-ascii?Q?vUJAiWk/rfQrylapmT6zMtHv6w1jaIVyaiXzfXmAuZybBdm8eDh4knGw+27T?=
 =?us-ascii?Q?ND4GlzTPZgCDht86gPe9iTVh9vfIkdH8sxtiRBO71aWz32PnCok9w5DklAO+?=
 =?us-ascii?Q?Eu8NSMVCh7Mans354Y8XPDQ0jesdACnGbCwdDM8f6xiyIgB1+9WIF42S4Cma?=
 =?us-ascii?Q?fypz8rrCnc9adp2Rx50v6Ali7q3Y9HLZT+u4qzNLhSrpvwebqKBuaZz/mgcV?=
 =?us-ascii?Q?lWnVdYDEmbT8skBlHfVnqaQtUIKcb/6xf/k4RJg1ouQdmUAKITFFSaUcPZp9?=
 =?us-ascii?Q?Qe5c827aSh1zWuSG7ByKYI7gluGThudJ8270HxEA9dzdcaD2OhEbcM/TR55U?=
 =?us-ascii?Q?DxUfxEGxVeAygmN+2iljxVBl+E/2ewBYoFCW12xBr2zmMjiuOgv3e+bewRYy?=
 =?us-ascii?Q?+LGeCYWMcnaTsKT9ZyfozMI82R/TLiZJk/J3J3WRNT+7gs/eOQa7BtS5nAdz?=
 =?us-ascii?Q?hzvM86Hprec7BotO/NcCAnJkSVCS2mUaevo3jkhi3GxE/alj9mtKU9ZPr0XD?=
 =?us-ascii?Q?Sf+XKUQRPiadGbaVaQVSIKEkjG3lwkyW7oWBj+hLtkzoTsT4/aMUy37GCPAF?=
 =?us-ascii?Q?+WNrNObQCafwZ3BXYlNZGdiuoEuwASYUsDp3+w+VuEVcPrMaTNvWHYMJLvXx?=
 =?us-ascii?Q?bUs1hXVP0dmVv9QzOEkJP89pF+cFUArbnslFpUxvkZ9GbKF4yIUPtpLpD4oY?=
 =?us-ascii?Q?L3NopMkKJZrXV0VffGMgTZcTM6S7SGkn/OUknwa/EkZZDChJgBoCwVLreRqX?=
 =?us-ascii?Q?b6TZ/70eruuFUCM02AAWE3H4hXA6nYxXKAKnw7WYRu2PimhLEJ9hsypydQku?=
 =?us-ascii?Q?huQLUkIswCFci8B+FakdEJaCSDF8Fr3fzR5VFDfw0ry0jMOcjwTL070Nzj5W?=
 =?us-ascii?Q?2r2nanv6rwCGJJu0KJXRnpdK5Gq2tg3DWEerCQvIhRq9qTN4oMgW1oZ1KxtJ?=
 =?us-ascii?Q?acn1nY2uSTvmGQv/2690qI8gK6ksALF9LxoZf9UsNv5srxG1FM3RxXwH0ZaB?=
 =?us-ascii?Q?iHgGSfFk5mQ1h3Xuwvh3vpBzFlIgNkncJFJjR1FUdRixirFb5RfXs4T2KsqP?=
 =?us-ascii?Q?KetwfYmp1kBFj0lbDqGgbt1y1J3hM9a+ta7OLnstHqzjZpcMThDijfnz0QeK?=
 =?us-ascii?Q?Nvy29zImd2p98bE+7W5BA5pJrA0GsfVYjgtqv5qthKGaYV83Yhpru6n5qJu8?=
 =?us-ascii?Q?/tV7F4Wn9Ztzrxj03uDNq+Xedij6XCRZ21d7LpgrSwEVHFKN4FV/TUymwO+e?=
 =?us-ascii?Q?EAEHLLEBVjhDBR9WdmNRfpUnBTvf76mauNTIW1cWhOtOxKWLfIrA+krNN1Tw?=
 =?us-ascii?Q?PEVNEibwj1zyvnrlhjBZO6aD6nFGi0f6oF3+YbVotS5GEeIqcmus9+jKSD+Y?=
 =?us-ascii?Q?57plz+vPM9/xI2LbKYROdVfQMnolm63eYfhHS7YlY+zPY2fvvVxwh00C/qo7?=
 =?us-ascii?Q?oTM0KS180lyYHkJNzwpcJFYQTLLNYLQyTHQbglJRcJNrE2KIDbQlUpclCL/b?=
 =?us-ascii?Q?uup9cS6IjJTaJJWfybFf2LfPA15DqCg8Os979ccRuHYlByUsQuarrxr8Yuok?=
 =?us-ascii?Q?DQ=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d46f41-862e-43e2-d3c2-08dad79c3854
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8954.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 15:11:58.8643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lbh1ym4m5+445Sa2ElNE8iqBrkxE4xTtFxmoQsQVczAyZkdTVydt/YsO5krGY4aCS/aQCIGFVyJtIbXsubvHzKJSJUHCALgVZ3CLHBzkixk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radu Pirea <radu-nicolae.pirea@nxp.com>

Fix slab-out-of-bounds in sja1105_setup.

Kernel log:

[   98.394543] sja1105 spi5.0: Probed switch chip: SJA1105Q
[   98.425782] ==================================================================
[   98.425819] BUG: KASAN: slab-out-of-bounds in sja1105_setup+0x1cbc/0x2340
[   98.425880] Write of size 8 at addr ffffff880bd57708 by task kworker/u8:0/8

[   98.425921] CPU: 0 PID: 8 Comm: kworker/u8:0 Tainted: G           O      5.15.73-rt52-00001-g9f4226d49b44 #6
[   98.425955] Hardware name: NXP S32G2XXX-EVB (DT)
[   98.425975] Workqueue: events_unbound deferred_probe_work_func
[   98.426039] Call trace:
[   98.426049]  dump_backtrace+0x0/0x2b4
[   98.426099]  show_stack+0x18/0x24
[   98.426140]  dump_stack_lvl+0x68/0x84
[   98.426179]  print_address_description.constprop.0+0x78/0x29c
[   98.426221]  kasan_report+0x1d4/0x240
[   98.426261]  __asan_store8+0x98/0xd0
[   98.426299]  sja1105_setup+0x1cbc/0x2340
[   98.426331]  dsa_register_switch+0x1284/0x18d0
[   98.426381]  sja1105_probe+0x748/0x840
[   98.426411]  spi_probe+0xb0/0x110
[   98.426458]  really_probe.part.0+0xf8/0x48c
[   98.426503]  __driver_probe_device+0xd4/0x180
[   98.426546]  driver_probe_device+0xf8/0x1e0
[   98.426588]  __device_attach_driver+0xe8/0x1a0
[   98.426631]  bus_for_each_drv+0xf4/0x15c
[   98.426670]  __device_attach+0x120/0x270
[   98.426711]  device_initial_probe+0x14/0x20
[   98.426753]  bus_probe_device+0xec/0x100
[   98.426793]  deferred_probe_work_func+0xe8/0x130
[   98.426835]  process_one_work+0x3cc/0x664
[   98.426872]  worker_thread+0xa0/0x72c
[   98.426904]  kthread+0x21c/0x230
[   98.426946]  ret_from_fork+0x10/0x20

[   98.426988] Allocated by task 8:
[   98.427004]  kasan_save_stack+0x28/0x60
[   98.427040]  __kasan_kmalloc+0x8c/0xb0
[   98.427072]  __kmalloc+0xdc/0x1a0
[   98.427100]  kmalloc_array.constprop.0+0x20/0x34
[   98.427131]  sja1105_setup+0x1bcc/0x2340
[   98.427160]  dsa_register_switch+0x1284/0x18d0
[   98.427203]  sja1105_probe+0x748/0x840
[   98.427232]  spi_probe+0xb0/0x110
[   98.427274]  really_probe.part.0+0xf8/0x48c
[   98.427316]  __driver_probe_device+0xd4/0x180
[   98.427357]  driver_probe_device+0xf8/0x1e0
[   98.427398]  __device_attach_driver+0xe8/0x1a0
[   98.427441]  bus_for_each_drv+0xf4/0x15c
[   98.427478]  __device_attach+0x120/0x270
[   98.427516]  device_initial_probe+0x14/0x20
[   98.427557]  bus_probe_device+0xec/0x100
[   98.427596]  deferred_probe_work_func+0xe8/0x130
[   98.427636]  process_one_work+0x3cc/0x664
[   98.427668]  worker_thread+0xa0/0x72c
[   98.427698]  kthread+0x21c/0x230
[   98.427737]  ret_from_fork+0x10/0x20

[   98.427775] The buggy address belongs to the object at ffffff880bd57000
                which belongs to the cache kmalloc-2k of size 2048
[   98.427801] The buggy address is located 1800 bytes inside of
                2048-byte region [ffffff880bd57000, ffffff880bd57800)
[   98.427833] The buggy address belongs to the page:
[   98.427848] page:0000000065dd1b0f refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x88bd57
[   98.427881] flags: 0x8000000000000200(slab|zone=2)
[   98.427935] raw: 8000000000000200 fffffffe1c296ad8 fffffffe1c296b80 ffffff8800000400
[   98.427966] raw: 0000000000000000 ffffff880bd57000 0000000100000001
[   98.427982] page dumped because: kasan: bad access detected

[   98.428003] Memory state around the buggy address:
[   98.428021]  ffffff880bd57600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   98.428046]  ffffff880bd57680: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   98.428072] >ffffff880bd57700: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   98.428088]                       ^
[   98.428106]  ffffff880bd57780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   98.428131]  ffffff880bd57800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   98.428148] ==================================================================

Signed-off-by: Radu Pirea <radu-nicolae.pirea@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Can be applied on top of 5.15.81 stable branch.

Cheers.
Radu P.

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 412666111b0c..b70dcf32a26d 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1038,7 +1038,7 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 		policing[bcast].sharindx = port;
 		/* Only SJA1110 has multicast policers */
-		if (mcast <= table->ops->max_entry_count)
+		if (mcast < table->ops->max_entry_count)
 			policing[mcast].sharindx = port;
 	}
 
-- 
2.34.1

