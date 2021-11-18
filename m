Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DF14563BB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 20:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhKRTyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 14:54:55 -0500
Received: from mail-eopbgr80113.outbound.protection.outlook.com ([40.107.8.113]:20537
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229576AbhKRTyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 14:54:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjgnj19929qdAXx4kiosqhc3kVjtTcEYxI2sMbHCZH33qGoJEidojjxPytlwPXAgmDGECu0t1h0lyVNTvBvm+RKet5G8n6S0Yz3cm2+d1Qzsr2kYvLnUIZkqTNr39xMi6du+bJVPp8kWc4pT3O/ueYFb0pUwoPcmhAO4a9dG6bkUnnkEy/OmBZ5tMEkpzgH73ZK2ks+UPvZC45um09lydg0ZuZdyqwpGhkmgfRsxpYNbt/vVIQHzCa8tkTJJm5iOLwPg7zvfV3aTimwQ2c12vK5ISyod1aPSIfV4bZqPtpljuFhJxe60TbQobV3RTjjMWClOeoaZdm7dMHOU056A1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HAYOzrrBbirVOQ81GfNGC0pm1BoD9I6KXRH8lRyLFqs=;
 b=d+v7Cnp6VVj0OiWecM1jAgnlkQEhPn+gtRNXk8xDUoM6zCNr7uTXc3038VpGhCUZP2pdAFzDIYIuGInYQL3dOxkyOWGBWbQiqb+oSjVBZLr+EVs9m0+shc912mfM+ugt3rlHp44fAsgB42O4t50qMUdPMlphdQT6V+08J9OLcsejmzZZhn2MYI7AnhDF7i62zTQenkDnO2Xr9G7dAGZaGw6foTvEdAvIxihOBQ6UD0Q/9SxA7QR7KE7Kpsy3DYU3EnQKkwwr9vpHc9QOEj9qn4BrDaZrL8hGCZUE8i5JdYhCGtQ96R0kLxkKGNsmdc6kgh6R5A2Gx0Fudi+jmQ725g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAYOzrrBbirVOQ81GfNGC0pm1BoD9I6KXRH8lRyLFqs=;
 b=Z5xgEp6WDAwmgrlWgahFEcXMUJDqRkBluyDg38myAYWKR7lDlnzA3ksk9hBcNlgoSMt6wAyBWQ1ntgZXpXFUcMrJCJ/m4CCb4KzFtxuTwJkxU1whOylONeYNXhXs2XkStloFg6rf/pYqB8tvWUBVGHfthSKbQvv74NcTsj/PA20=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VE1P190MB0927.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:1b1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Thu, 18 Nov
 2021 19:51:50 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::a1aa:fd40:3626:d67f%6]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 19:51:50 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     vladimir.oltean@nxp.com, ioana.ciornei@nxp.com,
        mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix double free issue on err path
Date:   Thu, 18 Nov 2021 21:51:40 +0200
Message-Id: <1637265100-24752-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0106.eurprd04.prod.outlook.com
 (2603:10a6:20b:31e::21) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8PR04CA0106.eurprd04.prod.outlook.com (2603:10a6:20b:31e::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 19:51:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24c10fa0-5d64-4235-abb7-08d9aaccdcb0
X-MS-TrafficTypeDiagnostic: VE1P190MB0927:
X-Microsoft-Antispam-PRVS: <VE1P190MB09278C444D9D109B03280B1C8F9B9@VE1P190MB0927.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:359;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AsLSwKk1QiPUcfjQJ0SADpRIAR2iBX+9yiXenWVTJSJIPWMmbBc09aj5TPzIPGje2QRLuVODkW/s4DAUXAOiYFNAy9V/4tKGA+i0QJx6o2GbTfCX7s+9OY7WSvCjz0gw7SyzgZ9SuGYeWo4RXeVjX6WRpQOjlDNCJRwovPnpkQim7/vjtPYcoG9CbpWlS+9yanATvu6wm5oOiVN2dSNMNQtav5Iyv2yQCBITftgUpCkqi3cQT3+GrmQauSvJh0mivdOE24RY+oybk3bb90MFTIjaCXjNO+aNx1CxywLLn9Wt8iN2yPhrjWWShTJKPEMKKm6Fqp9kp4YuFBtFw98aRFR+l9HcNUjluW39KvTq+kFM6k9vI9M+M+05vazzmIdVflScM/DuET35tNdFDe6Oun5TGXhI7zb6N0dGr9lhacEDIWT8iySkToeyNDJkkgQ1+m7E5EF35mONGCoXgTWMAH1X//o7/u9Mu/bHa/cMfK9QHik68tzRzksfH4TQAPqz9kpvlwJHA4/Nh01KIJjewip41K9EvAbsKvIqLr2rMdOFI9FoutajKNbCMN/B+Xr8IcvG/tSStMmjxE4H6Igh2tMKhZEVWkJzT8B8ZITjZH45D2buHOYianaUCjtocmOlOtvzDlBy6ictuiLeS/gXDmA7SbFhLOzMgYm36ahIH7f568qUfp7lL8eX+3YmzpIJ1kCMtV/pAeF62Pu5Q67S6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(956004)(44832011)(45080400002)(2616005)(4326008)(508600001)(86362001)(2906002)(83380400001)(316002)(36756003)(54906003)(66556008)(26005)(66476007)(6666004)(5660300002)(6916009)(186003)(6512007)(52116002)(6506007)(38100700002)(38350700002)(8936002)(6486002)(8676002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bsJ5h4BR18xpbwy5XfJiI5uCvXAuTj/BWtm3qmHTrbWUI4oYP1LR7RW9Bwfn?=
 =?us-ascii?Q?A9RF5r83xj5GrH7KRH9wQ6I9RFx88e19ZctZxtrnCza4LxRCZHuenfhYB3+c?=
 =?us-ascii?Q?PQhTcN+yA/9psllH8L1GSkqs5xu8VW+56A67VFIeEui87/zJm1+oAGukT9vt?=
 =?us-ascii?Q?vrhoYh+922lgNv1p68j8s6Gst1FYnsGX/PiX5xEdo/mwc/eIi0eEdY4xPom4?=
 =?us-ascii?Q?Ga747Y47mDU96aOgh9Ixr5cIpyiqU2O15goM9/Xn4IoJalnF3HjEXOidOV9K?=
 =?us-ascii?Q?+mrwpAfNB3ivJJZFwXMR4vQzfF4ZOaUSZ2dwHSKaEoYoRY/k5U4RJOsDIQsQ?=
 =?us-ascii?Q?pZfbGghr2O5JTU6phkcQMC3XYDCginhwqT+DOGXoMHWWi4caYf2/EwA0ozBU?=
 =?us-ascii?Q?zlIb3JDL0CFHZkQq9HJjPlFMj9GDc2Fy79QXrEgh4hU43kx6LZS5KIem71y+?=
 =?us-ascii?Q?JojtX9Hv7Qewt25Nijmz/UFG6LGW9DtMmN67K7fyT/H8V+lmlUi5qTipUCdi?=
 =?us-ascii?Q?sdBB6xUKX2rkzRabT7rrrqMR/ouQvcRXqcXuJLJ3ojpY+5zq9945Jga9w0Oh?=
 =?us-ascii?Q?usKVTlJ4kJzWwvHrakeU11hyLN09Rpwn0K4dTt9L8OcJzyNQ4TDHOBLDi7uk?=
 =?us-ascii?Q?J2EcDJKRILF9JpyjnS3LVkXWNNYs6jpOqSgSLfKHOjdLRIOW3PF9jzsONX+n?=
 =?us-ascii?Q?/a01O8ZbHAWw7N0vHkTckNbOqJpZoNZfv4iYMHC01jsgckjeT3rvCfwUPauG?=
 =?us-ascii?Q?na8JOT/L/W2ahIqT8DeFs9PmJlNPX8WcJpIZRQM3vxilx3v2SBxqws9geB3k?=
 =?us-ascii?Q?0UwEAT96XcTaMz+SreZ3+XlN2d/n6wpZpvMzhphe0wD9PEk2RW9UNTn0aan1?=
 =?us-ascii?Q?7DQxNtIwN6CD+W5latnndLUtMN6/jlAMBXKeDNRX5L63OXiSKc4ez99DEPLo?=
 =?us-ascii?Q?yAD3oa0VTvj8xDqH3oWHIhDcgirxqIcXGUFi3uL/8CY+n/Fek5vc7seHzQ5c?=
 =?us-ascii?Q?ThgR5RDJaD1oT7/12hIYpwxffHVS34IEgroRkqN2QIP3KUhdrHYoz9WbdOFo?=
 =?us-ascii?Q?vRmM1dlfoGextnZuGjtq4vude4jXGWwt/FHhP5J48jwacrflP8jKclwFl8lv?=
 =?us-ascii?Q?tnkcvuSYukRAkm3ErElJY70qkYu0lP9x09b2KxJxz7Sz2nHIPsCS9c18ijsp?=
 =?us-ascii?Q?rRyecD4Gu7GTSGo58aPJSRRsLr0tenfgnQNT+3P9lObrq0OSka07QP0FSinL?=
 =?us-ascii?Q?wGZ7+NfyjYbeIkF+EpmNfch516LqE/BbAGK/g/Eg1pl7EoYXuHllI+ALKGcv?=
 =?us-ascii?Q?rbNLX/iphbV7a73ZifVD7I6wahitF0F1fYsXIbyk4zViDawxYBIxuov9tJ/L?=
 =?us-ascii?Q?pznDB0cbqmwo6Mjd0Gd4wG2KcI8keotQN9mNbf9NAgozm9xbkPdS19QtUOQ0?=
 =?us-ascii?Q?eTbUA0hOWSKPELPh+KTD/w2PkBHkYkvl2tFc/IYpP4D/gMbX1oOk0HYbanSg?=
 =?us-ascii?Q?ym2ICMGl1bEea9YLVQ8AIxgtHcNV3mIetRSn/4WCFMWJeL7quNDSvU5CmdEQ?=
 =?us-ascii?Q?V2d98Zj1VCpnmKzbGsd4qeV5yhrFEgdgYoALNWfuLBOMOxTea3gwATV7TOF4?=
 =?us-ascii?Q?SLDISFhQPm04Krs5RMxxD7n5eMvFRtsXJ9ZH2elCfkj3yk6NOdgAI3/PhWs6?=
 =?us-ascii?Q?FMnrgQ=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 24c10fa0-5d64-4235-abb7-08d9aaccdcb0
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 19:51:50.3367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbZnrWqgVHieXBiYMYC4NLJfxTVsFKbLQeeXqANy8w1E0HgXovepNrvjAiSTj+LWWolaw4DhTzTn6yvXWlYF8ELabi9Z1nQKV0XYSO+ZIFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1P190MB0927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

fix error path handling in prestera_bridge_port_join() that
cases prestera driver to crash (see below).

 Trace:
   Internal error: Oops: 96000044 [#1] SMP
   Modules linked in: prestera_pci prestera uio_pdrv_genirq
   CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
   pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
   lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
   sp : ffff800011a1b0f0
   ...
   x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
    Call trace:
   prestera_bridge_destroy+0x2c/0xb0 [prestera]
   prestera_bridge_port_join+0x2cc/0x350 [prestera]
   prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
   prestera_netdev_event_handler+0xf4/0x110 [prestera]
   raw_notifier_call_chain+0x54/0x80
   call_netdevice_notifiers_info+0x54/0xa0
   __netdev_upper_dev_link+0x19c/0x380

Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 79f2fca0d412..b4599fe4ca8d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -497,8 +497,8 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 
 	br_port = prestera_bridge_port_add(bridge, port->dev);
 	if (IS_ERR(br_port)) {
-		err = PTR_ERR(br_port);
-		goto err_brport_create;
+		prestera_bridge_put(bridge);
+		return PTR_ERR(br_port);
 	}
 
 	err = switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,
@@ -519,8 +519,6 @@ int prestera_bridge_port_join(struct net_device *br_dev,
 	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
 err_switchdev_offload:
 	prestera_bridge_port_put(br_port);
-err_brport_create:
-	prestera_bridge_put(bridge);
 	return err;
 }
 
-- 
2.7.4

