Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95589438AEE
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhJXRVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:12 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:35552
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230426AbhJXRVE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:21:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mIWHONvfZIhiB486esYPMb6TLPstBs17rWfGEZqtWhQX2PvVsQ+MmYNF5BTRTQlJVdjP1/paiO9LfuTM4nHQ31TfQ0aXQLBYNAlP4F54cMvoINzEyeOQfi9OQFLNWmS4TavuYfiUD+DR1dCr431xdvhtfhLcoBzJYmhzfwdArVCGKrr5ZkbKc7Db4YbxnRfRueP4ePx92bV8ibl8vyDWzF43xtWmzhSSzo28za9zlNvXKjiRBiOtInUdyFRpaItRZCgL/CMaa6HyrkcxY71NPDFA20ChnVybR5GpoQaFfHWTebpaaN41fUSKkzdAlvlztyx2R9ofHyA4Fz1mr/ha2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tBDsL9rFEzOE+N05o+H5pPZzyw+f2fkQtQ74UrthfI0=;
 b=cN2Fc/5TrAEgpv3OjnucDlhIfQ2pfp+FWGQIz8KEDQ3XIzHsFIREIClnODZvTIwXtQvi5bBHqjkgxuP3TKGelAtRDfRsZVHK+dy/+I2YshyclBGM1OBElUvX/HwJAULlRIvInQrZdX+5CzICr4SUG1X3UNDnKhNsffmbvG/NJy4nu79fAPy6Q6LjXPl9lVmrngPm54Ks7c7BrKYpKizHdto1HtWgKH9tHZNk+qClPe9gV4R8QfZp68c0066Rg5CP/oIne0lNpuGpsig+D7Ag+RkwOqXlVpGr27CXF3FSBRtOBq4Ea8jnSnO1Xj2yd1J0AUC7LFjXGKrhJ49JcRPsSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBDsL9rFEzOE+N05o+H5pPZzyw+f2fkQtQ74UrthfI0=;
 b=q7NytyoxKail9+y7LMwZtJrLmN62+dLwkWJoOm+FF+J/F2FeRbjMySKv7krXumCdOcXzCPOw2PO1icdMGukj/ynas0LiMkFVfdrSowQIlVuKVTIgKUs7lv2iEXDPajRijTWXEt2STCagK3lcFZqYDCU1NupGrJpEVSnPNfHuZwM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v5 net-next 08/10] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
Date:   Sun, 24 Oct 2021 20:17:55 +0300
Message-Id: <20211024171757.3753288-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51363080-89d8-4950-2977-08d9971252a3
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2510:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25100544AF8B1BC96CCABB96E0829@VI1PR0401MB2510.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whUxfm9xBPQagvbpgKivReFKeB/xWEtO9KQfczPWZNKPWXA9nzvgfbdgxwqkRmAefTIVfzWp2yDdShYWXbfata+Niw99FUCsM64cxc697wZlMDSLH1PtQ7lH2r7Dh5Be+HBdMuAMtWYITNv+qeYwu6C0vi+r7f1oAHoT/HoJUov60XHWU0TS//buZiywPEWac2fuWu3vBDQNEE46QRmUhw4Yggz99OxBvWYGznxiWXc/pgbDdj8vT8AxpfEo4+0aJ8ybAqwaLJqHKueM0Nz9hoC6Je7qCtUTJVerDh1gUnCB3jWHd8imHInhqOiF0dRWIMVma3ut/v9RLrGHImpGT6Bv7XSpA+z+3YB+DFjuycHdPxmxwmcPo0RTPBrp4XWcjLleViAwjesjZM13dzjsqQ3DucSWWHetYgeagFoRblqX6vIgY7vTyflblDO98cI1phDzMKVEnCwLASgnXjAuuHMtHct4FHCpZYvR1LoXYrwoqyOGEeKQy7z09SK8xKnbVPYJznUx8/UqsT9MLjzVU37l9+hYdl8OlCNrkQUotbHkI2dVDgWFOKIUrrRLXC0pKpQlnB7Xbu53UntIHfvHkXjrhnPOFk0KLhLgbPFHL6L+eOkEJu+4H1NOtwabM951Do8i1ZfMvyHrU0lKgnsxESJK17WRWc2y9NwzTM0RDDJfXn8PeiuHBUN8XYVP8AVtSvF8213sUXJKflUgbRdc7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(66946007)(66476007)(8936002)(7416002)(316002)(54906003)(4326008)(956004)(1076003)(66556008)(5660300002)(6512007)(6666004)(6506007)(83380400001)(44832011)(38350700002)(38100700002)(8676002)(6486002)(6916009)(86362001)(508600001)(52116002)(186003)(26005)(2906002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MtEMDgMvve9pD41J6l18XCbUN1JDp/6l0mh3FjrcFAVXgRVTukgSzikh2iFi?=
 =?us-ascii?Q?K2xW7WbclNLDXmx0ILFsixfU98l58H/QzA/xQDQK23R2DyRhSEKfPVgmT0x6?=
 =?us-ascii?Q?X91DOZX2hXu68IFZrMnWHjuXYqK7LXZhu+kwahpZ/wbhB6pGc74uM4IKnIMZ?=
 =?us-ascii?Q?RhJJefJ9kvQbHlkLi4WvCvOE1TSf2OM3DWrQyWBYRcvMFczusVHqDRJpjbzu?=
 =?us-ascii?Q?VZwOiz1W/CsS0oHJ75rjad2m8WOMJUdyF2k38K4nBE8gn9ITqeb9HhF7vetF?=
 =?us-ascii?Q?25ySTvMmyk3nUKU/vRqTfmwUBGQKdjn8kiax4uOD0a8GpCmiCkiPujqeqgNL?=
 =?us-ascii?Q?GtC5XK/9e4empa90daFSdFdJeadsrZY/mZoRCSvPVmYG1c5hvNSrYSwlR0EK?=
 =?us-ascii?Q?LF8Rd95axyQQK7V7qsjaRL7GjF7BeEXhfzT+mPLoOagDKyg7EJ/GEqcMcbXm?=
 =?us-ascii?Q?49a4+b1W4pMIzZakkxI2QYkAFvSW8QWldWoYBLZFxf9L+uNO9F68F6RcUeON?=
 =?us-ascii?Q?Qws23AW21i/AoKOBQMWxfTaWROgBXftfEGMjFZEFOk2pHtPax9sbXitm+ha4?=
 =?us-ascii?Q?g8pq9yk3+f4NNAaQf5i6YOPz8HFBZykrxxslrwTYUNmdn/q02pnX+HGShZSZ?=
 =?us-ascii?Q?umSS9tzKC+RAwgUVCpOWr7l4jqiks8kMXhLpvHgAoMYYrit9Lke49A5XLt3c?=
 =?us-ascii?Q?Gh9xj/4tRWfE2c8H1L1yQy4yWh3MdGtOm6Ua3yMwmfvKie91KJ1Laj/lWuAr?=
 =?us-ascii?Q?5L2rG2XH4RdvOaGjOaqt6HraSt0vH7ZedmYWlYhCozvSsJZvVNmdbceUeLln?=
 =?us-ascii?Q?ZbKdTWys8vadr9Jlkq+98TXiOs5brU+owFs6+h0qEbX+URPB2iP3jCjQP0I4?=
 =?us-ascii?Q?1m1YZhhj0bx3KzueEk4MV5bpBrYfgxUvSXMruTtHyj3c0hVQk9iayhCMBFQR?=
 =?us-ascii?Q?blFrihcFUmGmUJpJIT4uLHbtToVUakvl5ajkCXf4ILR19aWYQppLcXlpVa8f?=
 =?us-ascii?Q?TDaKCkpTwJajdMJcaPUKomTipniZUxr4XFMD6lMuwK+D5LzM5acfg71AqrSD?=
 =?us-ascii?Q?eN3seotqfoux6s/QPg+9eR6KWs4XzJPkLw6fTMWdL+3nkPGUMNwSneuv5tlQ?=
 =?us-ascii?Q?ON+juSsho0VAR8opXc19/wUrTBmqiDS7Cpc0cWmlCG/PPG3BmxRgbqAtXBgc?=
 =?us-ascii?Q?UWCvxbKcmOvaweGmf1lT01efPXZupaS88ngQWX6YbI5PKs1ARZiEWmovmFGD?=
 =?us-ascii?Q?17ofzEwJRn6NG1iDmM5R62JI6gTHgCHO7taSWVcNbvSMx3PdlYK0OyMygK+T?=
 =?us-ascii?Q?hgV8WsxFtKeNBOj+u9mhM0j9WFc+mMw85RsWRvlbJNJutApdvGreHsihH+ve?=
 =?us-ascii?Q?1819eWpTfkeC/Yp0/Vxg9H7/C+DS2/UqX5q6p3r8CG9hYk/iIggiI+Z/4r5/?=
 =?us-ascii?Q?DVcJNC3ig9lT8ioqgeAvP5I13Hl3wia41IToo8SUm/tJi2MV4F+O0eOmTvLs?=
 =?us-ascii?Q?UVytFwJERVJEUtQ+l7Rq5CUJHLgQcciPaslz284iPXCu0WouoLgw7cXcHqzK?=
 =?us-ascii?Q?/2t7bcyNx1SBPmqyuu5pUvARoMJ/gC5V54BLOneqjGC2N8rMafL5yT5cp3QO?=
 =?us-ascii?Q?vIjQh/hidLYixqgeerw6bHw=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51363080-89d8-4950-2977-08d9971252a3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:40.2505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PVeKEsF7QiUaE4tofR+lWPn9cOj8yOxLAE4D1Th8FIvXTFtBNAjVT01sNOSQ71B9P4gzaD0ZkqxvSCDyhhlDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After talking with Ido Schimmel, it became clear that rtnl_lock is not
actually required for anything that is done inside the
SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE deferred work handlers.

The reason why it was probably added by Arkadi Sharshevsky in commit
c9eb3e0f8701 ("net: dsa: Add support for learning FDB through
notification") was to offer the same locking/serialization guarantees as
.ndo_fdb_{add,del} and avoid reworking any drivers.

DSA has implemented .ndo_fdb_add and .ndo_fdb_del until commit
b117e1e8a86d ("net: dsa: delete dsa_legacy_fdb_add and
dsa_legacy_fdb_del") - that is to say, until fairly recently.

But those methods have been deleted, so now we are free to drop the
rtnl_lock as well.

Note that exposing DSA switch drivers to an unlocked method which was
previously serialized by the rtnl_mutex is a potentially dangerous
affair. Driver writers couldn't ensure that their internal locking
scheme does the right thing even if they wanted.

We could err on the side of paranoia and introduce a switch-wide lock
inside the DSA framework, but that seems way overreaching. Instead, we
could check as many drivers for regressions as we can, fix those first,
then let this change go in once it is assumed to be fairly safe.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v5: none

 net/dsa/slave.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 9d9fef668eba..adcfb2cb4e61 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2413,7 +2413,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	dp = dsa_to_port(ds, switchdev_work->port);
 
-	rtnl_lock();
 	switch (switchdev_work->event) {
 	case SWITCHDEV_FDB_ADD_TO_DEVICE:
 		if (switchdev_work->host_addr)
@@ -2448,7 +2447,6 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 		break;
 	}
-	rtnl_unlock();
 
 	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-- 
2.25.1

