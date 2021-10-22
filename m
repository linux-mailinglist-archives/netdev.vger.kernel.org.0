Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39C98437BEE
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233835AbhJVRcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:46 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233794AbhJVRcp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUfiC5QI5kHu/sTDAn5EJVZsRgOxJbvMi7x44D/jvuN0SQVf3EhKc+wLB8GjJTtJrUTbQkOHsaJBXOER+LTA4m8u+zRKgbNRTziwOVI0hLVPy5mk6oxYq94OjLu7j+aXTOLdakXr+IPuDiYTMcUk5ADLj7G4MR+IzM7eN9hSRMyQ9brmPhD4CAZTYvcphIShyHuDnvy0NnD2m4K0oeLdY4D/jYUMfEMt/WG7IzLvgvTFFxd4KMiaFBNh4siWcctaV6uRKiezjAS+sZkoKHmSTLj3DB6x8zJX02e+yWkDsaXxqr8VnNi4jIE34txSBtlTY8FCSHQE6F2bCigLZskoMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moRF2dH6E8ZFK1D4xqVmioIbskX61Dz3VexgeVOa1AA=;
 b=oUatXRo92iU8zm9B/P5ePNEWduT84ooJ+BwwRUdCylosoBOUG67JGYQx4EJINsvinZ8rP1Ig6VsjZ75aEwI131HRayEITd5IWRlLPkmYEVUW6nqqzxvZtNCaafhz/c2UK2VgNf5UgT0ETi5s0VyP1EpgVauekM2em/DOOu96YN0OgVbKgd8TpWJnoV2cO57Ang6A9kLP5fRlVhRoBnJA1QIvKqF6fhwWwtFuKX+ifhdKISyltdWt8snS5YOKGql4yaqCEaHlZm/SqjHAkphFyKvZQNpOLMIq4zmaExD51HPx58Vr2fQOAHNntmJU3DV5YtR3C0RK0FNA1IoBmnI+Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=moRF2dH6E8ZFK1D4xqVmioIbskX61Dz3VexgeVOa1AA=;
 b=jNyODdvryEiZCWE6pgFK6zd8eteUfVYg9fQtDYbFXM8H7h4GqOIPP/0FQ2U+/Oc/S0JU69lcYrP1LY0P6s7OKK7r3A60yUfO2uehtwlpkH58GMFPWxUP880JFIgiLcYC2Hc/Uz6qXM58L4GDgXlCOJ5UaZp70B/mCkzPjZoBhD4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v3 net-next 7/9] net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
Date:   Fri, 22 Oct 2021 20:27:26 +0300
Message-Id: <20211022172728.2379321-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c8a75d4-4137-43ba-4a29-08d995819ed9
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504A9B6928542EC04643F7AE0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1lPr/4r5xvpvR6GnRg17zjLhmnIkl+yfSzTuI2ROjyD3tTuOCuIVXI3DhrDD3NMHlDM1dBkEjGF7XcPv+jFLjIWymcVjrMJkECvBy+QBlFyxMyOCtWehhLKSW6vDRegvzlkLL9DGxQPF/CDtVLpU7rJT3z6/D4Cf/VauHrrV0UiQ8FNx2FjEtLSVnJpFNQr0WeprtoDfhsbpDN4yM/p+jBaDY0VPkBTdc2X/ODWBO/NBGhJgo01iSX92Lf4ev629+ofx9Bgaq4X2ryz30bRI1Ku2HoHtoiVLhdoWDOGk5BrWpmbev2YXJ9B4xYW3Ycpsql96qtgn9o0yWLbuXrcgbH3GJahrJe7l5mjDoExKij1ezegkjh6WTgUV/p5HpYRzHMB74bLWmA7/tP1U5bgqzwiV1NJwQT3/3r5Yd3YNsAa9LTV259UKZD9gVhcl9He8rprSldG2yGGPtJ9++JfiN4V2KlhROdA0y2Y8hpIWay9U5JiYpCrg7B4k7GRxMatFyrBVA11iYiNOqWbXT1KyaytbJMGgy5DyuYjVG2m72r/BpehQj4nSw/BCYVZ0QPG9ZynCTW0XyPWI6CjBgSvSigZ9amsuylMYTBTQt2oVh6eNT45GJ5/2WOWOTMXjV5wsF7fctKrrStVf6vPe3lMfqc/WHDkgr7JeUHUD+iGpCYZf5bJT7cyEKydKtmQONqT1vghoiXtYUMzVSM5SZpWZLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2RdSgrP/JscuYZJNcKk4OY+TZ6IzvmtvFcwNfE/BEh8F2bFvnBH0bWR8qF2G?=
 =?us-ascii?Q?FUPXiv6q8LPfydxtfCq1Zs/uELbQ3t6gb2Y2LJaar6bvs6n2HRtR/fIhtqcH?=
 =?us-ascii?Q?CBLu+SfurZLDgvQsewM6W00cT3GugBJp+GQHTri4KPDJLfVEvaFgW8n1oeJj?=
 =?us-ascii?Q?VEiz/n/znNCYUkdd14s9Ac8/TfoDkgknC6DcQegcmmXVt3WESioEviHh/Od4?=
 =?us-ascii?Q?v49SEc4VjxL1iIfdLO5CsbMF+SLjf4AvieYmTPWNUQx8ggH82DDTVRdzIE0Z?=
 =?us-ascii?Q?pHw2j45car4XqOpwxl7SKn/a033DqsgAdbsMtcifVKAyaBdyEnGLgCsTgOik?=
 =?us-ascii?Q?ZDMxqNn5OO7E+sXcUbSQMV0DlfwzSp3RALpNOfINWfnjFYwwWgjeIz/gL4vL?=
 =?us-ascii?Q?sh6kY8ZE8kX1Y+NDji9KV0Jn5AlSjcvMsvuea7Lua4R0demnSyVC7miw5cHj?=
 =?us-ascii?Q?r7YzjqYXaVNMjZ0La2DxBOO849x74Ai9x2Kx4DALfuEWjGRE9RbbICHwsjrk?=
 =?us-ascii?Q?Jwjl8MA4rvTevFqEphnXCn7+zQc7Rf0xmVqHTepWWz5fRr+h7TEwNzH4SJpC?=
 =?us-ascii?Q?uI2zQF9avBkeqpw8gKquGqRZUv51WVPO2UzoOMHsbZ/DeFKf5JrXPEKKO7Qn?=
 =?us-ascii?Q?BQG0n4cq3pJdUJ+UrWUbHo2u4KBTkKVv5XeuVP+825tU+xGXDcaNZ4+PROe9?=
 =?us-ascii?Q?rqc2LWtTw9sco7CGBoEJyxFC/7dVm1e2mIANEH15seFC+c+4k066hydjtUbN?=
 =?us-ascii?Q?d8JpcZcit3NN1n5OQywzjniARShiUCRwn2GRgrwVq9jSZPOZ3WpcGPyTwiM6?=
 =?us-ascii?Q?CjY6oGie+cxBVNGjBXmoarQY+yFAsMZfwN1YM9m4sHCsJQxefqwRnRLWOryc?=
 =?us-ascii?Q?CvbO0XIuP9WVvVpXTBCUDRirXxqHOONus2yu6TktZiYgo/JNIv/aAd9IAWno?=
 =?us-ascii?Q?+R+8acNQz3eIn2vaFeKeIRVn767e0Lm+I49f/iiuwXNl1FzpISGqFriaKELd?=
 =?us-ascii?Q?PtybI79u4YVLOcXf57gXTERv5SqtPw6kLXEdB5u3GSXt8jGVZlFNWoHQRvjY?=
 =?us-ascii?Q?xQbgervM6dhFsfTQRr0LjeqRRNDah+BBCG3o/G2RVn0hetiCZyi0KzxBS1d8?=
 =?us-ascii?Q?oLWsx1L8L5gUw+KFe8CmGoMplMrSAu8qNU5VWvwVbg5MHCqtUY8BUeaXZSjG?=
 =?us-ascii?Q?83Pcmd9v0N8MzTMoCDIpCUShKlhn2BruvtH3doqHQc5vSpH4x8VxFm7sYeDz?=
 =?us-ascii?Q?OhQhV8sVZSQHEyzB2vXX6VseHnRijQapFp5dM0dUN48nVR6oQ0BDh0pTBWLS?=
 =?us-ascii?Q?L2vDwwFgFfcr8Y3iENuVhkUYzz06/nKmsI2ff7mIvlEZ66MaqQ1nOvpEtAak?=
 =?us-ascii?Q?1D761Kdq7pI71xXb3WfsjBpOItol9gRvWQwoxkcn+z8qz77zbJcDFBIlHs11?=
 =?us-ascii?Q?2mbiCfwnKxPRK29x1zLVUAwcDQGoBsl4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c8a75d4-4137-43ba-4a29-08d995819ed9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:19.9944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
---
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

