Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E9530E057
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhBCQ7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:59:13 -0500
Received: from mail-eopbgr00096.outbound.protection.outlook.com ([40.107.0.96]:21157
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231761AbhBCQ6E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:58:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WRgBDB0nHgMnzPdcBs+P/lRdEdycMUNtBBZGh0rVsst53LbdlfSWzKTVzn/ReNGl4UytUU+rIZ1pz2AtayGeinC2RvqETMjI3IVLKhK/ik3WmOxeWX8Rd8FLcMKRidN2zN0yn3jH2eNw4BitQceBmWqrzSW9Cd3nTd3cnWAtnNlIpmLW3vzUHjxPq+iKWwLk3PEw9mYFR1XuKzja3fyTaYy5dzRWlA5TLFw2TZ0Kt141p6TrK2xRxDZohI91i03fgCFE2HnqLgKfm8za6UVyCa7s0uaqgzR94flc+AkVAW+Z/m1ZNra3g4SB0xQ7qXvGfVMaiFcUH1QeFizpzgN7Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U68oR9IpMYbdQeZf3zPXyAyevSD/TnNuxfBGQSbUIxU=;
 b=lrtadPSpYp7ExkrkIytqZ9yMIP3ZxwW+2fRzhhM4cgRx6aHrOs4iCdLV8o11NyCIe4T7X4IKRUjm+mCohR4JzVrM018wS+N4nS4mo9Y7TQKSuJPqVqDpiVx38rhVwSNj2CGmhZUCrArswyRmKI46VEyrqWGYy/zpVpAi/3WQq1v+zKjSfeXspA47vdgEHWpvinDRApYvHcLx/3NKcO7d2h//zZE7mK8OENUDMkozikNeU/q+ORhpH3cGFGezBinsL+et98m4701UYZDTq4mLTkS1rSSSreBwCtnztu8JPcjJFfYpJdR4Bc2bVV+8az/VfP7IEwrYTRKYfb/LyLMeNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U68oR9IpMYbdQeZf3zPXyAyevSD/TnNuxfBGQSbUIxU=;
 b=jkYd0dNV7bExWbJFszmjMr5OwxTy7iFrpV7gzgCSeBQUOqvn3h0ERjdRnDWFj9vi4spXc73MKOXwaot/bOcaoMbww5eMFHEhtylNgsKc80v5B49r7ZsrGvE/hEXZdD7F1DnbOmBcLruJ4KL47ODjWGNAEny5uTC+yS7mQVIGHe0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:56:00 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:56:00 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: marvell: prestera: fix port event handling on init
Date:   Wed,  3 Feb 2021 18:54:58 +0200
Message-Id: <20210203165458.28717-8-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ef115064-1f0e-4aa4-d7e5-08d8c864954c
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05391D5E59C1FA645D566E0C95B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BqAY4NzdpKaZ5eA3dRKHfvsM9qiB6e1A+xn9GXiGIMTKrqeFZaz10OT7yt2p3I5B3RYZ830DJDEafZxU0MmC9dOjhoj+tGJ6LdOG9SDHB9CUl3zumqJrxI/pSBwKCqe9Ofd6FuwJ2D8REzVbO4m3PP6vtx6Nb211d1Ins8z4t2kQ164RwUoM3/Oozfknyb+Csz/zBSAqhe2BxwvsmBLuHDvP7tZoCbgDbe+jUBu/3sg/lBUs9pU/VY+uZn2YayqzAcXHMgc0sTbFgt6B5fWAl7nk6VU7AwlnPYKd9NecJuXfrzPCuYnxb9O2y8BRNhbMVLVqT7cVzyaMj0RyV5ls1+HrPDetbRpXcarsPbZ/Ao9W3Gz1iv+5vnoOXQ34XA+BiR+GGxZY7uY85yYxHOqNm8m5TgS3WyAS2Fjvz9f/+mHoCSMF5I+EgOxi3vmxe/GEG/y/wM3VudvOD1v2Ln56UHpHArvlERtsP5ePogyyKwI4D7WIkiCnBkUwHwYgLbOPqHD/879rPp5b4XI+qpBwyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(83380400001)(45080400002)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(1076003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?9K60y9W494ALdPISHmfT3Q+8vWtKm/SAGMpZYK0YrD/aTVeHkLYv1OHTFyLD?=
 =?us-ascii?Q?8c5mD2QOWEZQCOsNIH7dg1c0R2VTHrhlfhJwxbdTDnV5FdoqfMyuIruHx9ZO?=
 =?us-ascii?Q?2mj2GDWuLUYWVjZ3M8Qa6gxkQQf4CA4r2IDPVGrtCAIEiCYEhjivZbt1JSSi?=
 =?us-ascii?Q?MJ1/ButiQ4PEBNHIh3CqmBU7K4vkpARKTC0MM1IJJ2YrNvHAgQZaawtQTfft?=
 =?us-ascii?Q?pTb41M8ogUxfRm+XOMt6yZ2sQPbYCfUoQ+qeLlRL3pjChU+Ikzsv+SkvJvxs?=
 =?us-ascii?Q?zDmlaLk9fqD+OUW4uFnx4ADRCJPKer765Q0GfDYxrtyPUe0cJM0M85LFTuAI?=
 =?us-ascii?Q?ibheMa6RR0sqVNq7t9F1GN+OQwlw4kS5RAUzATK72A64WBeUnVMoWKyD+Q2w?=
 =?us-ascii?Q?IO3v5lFLc0RHr/AvbdnoppKSFXf96Ng1jXGVLSVf3uWFD5drGe+DALQbp1pl?=
 =?us-ascii?Q?zLe96nYTH+5cYbLYAjoUK3/kXOtl04EQB25jGYQHr0q74OB+5UF8zmS7DK6n?=
 =?us-ascii?Q?+BOOL+XJak9Da4RFQcC9LaXNIJ8X+t0DRBKPdXkLadZQYg+ygpqrir8vAJck?=
 =?us-ascii?Q?YmhSEhodGrOVNMNlG3xMOMd8L5S7SwhS7QVn+FHwK4ibGwm3Zw2DhV/nb47y?=
 =?us-ascii?Q?PRJ+xSiyw6jCXy9SCIONLdUZNZvp+ARKXvFDdNfdSeT4iBklMDVKchDzBL9t?=
 =?us-ascii?Q?O3K2WDE2+KI3ZfuninPWUfL2vLlSw+twtwVoxc5+pFRbTkk8FIyq8lwmOi2q?=
 =?us-ascii?Q?NTj3c76NAadzBXNca+0pM5gdGaGVS7BTayBvVG6TJ71MZmZf+Ih70lA3vW1r?=
 =?us-ascii?Q?EV1FpKlNEM7PQHO6A1kIXw5ay8+0Q/gmyB19ex2nuJbzu4UPxKwN2AK8qcyN?=
 =?us-ascii?Q?yIfTfcUfBn9mtiQYsGAffOmfJIgA+sgIoMjch3uUCo/XdLvcveMuO4HHPPzE?=
 =?us-ascii?Q?xaUyKG+tUxwHzur6IdWMpV5XzLBueCMUID6g+B9qIORJBDN2EveFM8Cl/M8z?=
 =?us-ascii?Q?7ZD7FduhNWxSgdn1M7/IZTuPb2mOzqCdNKSDb3952+Rm2XazOJ1DgD0InYrO?=
 =?us-ascii?Q?IsegSyBRPh6YpOZ2PuPRRTKYcB0mDYqZ1bxOPal6wxR2kAMypBRsBhKYVdYO?=
 =?us-ascii?Q?8+MhhG3I0EBN1zmSecbF6Pk1EbA2d81CQqnEHlRhKeOAvCxr1jon9fNnus0f?=
 =?us-ascii?Q?lyZ/DjXSEcZBySgOZ7Zts9/dJGYsWA8ZEbZCTA30QYbyoX+cUVtE7wZVXuEq?=
 =?us-ascii?Q?HU1hp+eHRmi6OBwYPeXOlASykFX7rJW6eKcjIpNUR9vUxsBulpTKQCavomrh?=
 =?us-ascii?Q?+6TW9Z3BC7qHtglN/nQp0ohG?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ef115064-1f0e-4aa4-d7e5-08d8c864954c
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:56:00.2079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwXFTBxMMdrfbQzSUH2h+I4HYZYp4xKcfFONoInq6X2wWY2ZtGjYAOvf6TMP2er7GJXCES7LLKTjqjlvEa8NRDmvFJZBPdM2i8ivAroYnIA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some reason there might be a crash during ports creation if port
events are handling at the same time  because fw may send initial
port event with down state.

The crash points to cancel_delayed_work() which is called when port went
is down.  Currently I did not find out the real cause of the issue, so
fixed it by cancel port stats work only if previous port's state was up
& runnig.

The following is the crash which can be triggered:

[   28.311104] Unable to handle kernel paging request at virtual address
000071775f776600
[   28.319097] Mem abort info:
[   28.321914]   ESR = 0x96000004
[   28.324996]   EC = 0x25: DABT (current EL), IL = 32 bits
[   28.330350]   SET = 0, FnV = 0
[   28.333430]   EA = 0, S1PTW = 0
[   28.336597] Data abort info:
[   28.339499]   ISV = 0, ISS = 0x00000004
[   28.343362]   CM = 0, WnR = 0
[   28.346354] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000100bf7000
[   28.352842] [000071775f776600] pgd=0000000000000000,
p4d=0000000000000000
[   28.359695] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   28.365310] Modules linked in: prestera_pci(+) prestera
uio_pdrv_genirq
[   28.372005] CPU: 0 PID: 1291 Comm: kworker/0:1H Not tainted
5.11.0-rc4 #1
[   28.378846] Hardware name: DNI AmazonGo1 A7040 board (DT)
[   28.384283] Workqueue: prestera_fw_wq prestera_fw_evt_work_fn
[prestera_pci]
[   28.391413] pstate: 60000085 (nZCv daIf -PAN -UAO -TCO BTYPE=--)
[   28.397468] pc : get_work_pool+0x48/0x60
[   28.401442] lr : try_to_grab_pending+0x6c/0x1b0
[   28.406018] sp : ffff80001391bc60
[   28.409358] x29: ffff80001391bc60 x28: 0000000000000000
[   28.414725] x27: ffff000104fc8b40 x26: ffff80001127de88
[   28.420089] x25: 0000000000000000 x24: ffff000106119760
[   28.425452] x23: ffff00010775dd60 x22: ffff00010567e000
[   28.430814] x21: 0000000000000000 x20: ffff80001391bcb0
[   28.436175] x19: ffff00010775deb8 x18: 00000000000000c0
[   28.441537] x17: 0000000000000000 x16: 000000008d9b0e88
[   28.446898] x15: 0000000000000001 x14: 00000000000002ba
[   28.452261] x13: 80a3002c00000002 x12: 00000000000005f4
[   28.457622] x11: 0000000000000030 x10: 000000000000000c
[   28.462985] x9 : 000000000000000c x8 : 0000000000000030
[   28.468346] x7 : ffff800014400000 x6 : ffff000106119758
[   28.473708] x5 : 0000000000000003 x4 : ffff00010775dc60
[   28.479068] x3 : 0000000000000000 x2 : 0000000000000060
[   28.484429] x1 : 000071775f776600 x0 : ffff00010775deb8
[   28.489791] Call trace:
[   28.492259]  get_work_pool+0x48/0x60
[   28.495874]  cancel_delayed_work+0x38/0xb0
[   28.500011]  prestera_port_handle_event+0x90/0xa0 [prestera]
[   28.505743]  prestera_evt_recv+0x98/0xe0 [prestera]
[   28.510683]  prestera_fw_evt_work_fn+0x180/0x228 [prestera_pci]
[   28.516660]  process_one_work+0x1e8/0x360
[   28.520710]  worker_thread+0x44/0x480
[   28.524412]  kthread+0x154/0x160
[   28.527670]  ret_from_fork+0x10/0x38
[   28.531290] Code: a8c17bfd d50323bf d65f03c0 9278dc21 (f9400020)
[   28.537429] ---[ end trace 5eced933df3a080b ]---

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 39465e65d09b..122324dae47d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -433,7 +433,8 @@ static void prestera_port_handle_event(struct prestera_switch *sw,
 			netif_carrier_on(port->dev);
 			if (!delayed_work_pending(caching_dw))
 				queue_delayed_work(prestera_wq, caching_dw, 0);
-		} else {
+		} else if (netif_running(port->dev) &&
+			   netif_carrier_ok(port->dev)) {
 			netif_carrier_off(port->dev);
 			if (delayed_work_pending(caching_dw))
 				cancel_delayed_work(caching_dw);
-- 
2.17.1

