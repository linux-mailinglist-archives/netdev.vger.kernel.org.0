Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E37438AE4
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhJXRUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:20:51 -0400
Received: from mail-am6eur05on2041.outbound.protection.outlook.com ([40.107.22.41]:63681
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229821AbhJXRUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVsN8EtexzDzb1MLdSpnPwTw6Z8xxn9fwwwbdMm94n3OBai/CySWLympnHO7CqNsoaDMDTte2x8tGs/4+gPPI6N2An9yDVY+hyntLBjXDB/dEznsZMVf18ICVcKOHIB/nwBtHhjlBXnfWYkD0NRq0G5Jee16JGtfWaVhA588mNI/WpMHYyviQTGOpfeuvigAtsdl7DPamDi31My9wpBjt/5mhxz7VhAllOlZCMq+cpJ2EhnlvEbSHRgj1GGPHSGmrRuN2XbBD+dQjygVFiVS4lDBlTmF0dXABrSYQNXrShwzgRTx06NuYSdk3g0nW1hcKujAs9yXdeaFgBqzTWc5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6ZCEjHkWSDUcZxGe0OhuNiBOTjyaajPFV+EeSvSE38=;
 b=BwV88jpgAPVknbte+oydoky4BgsUuk0R6vpTPdlhsaOHJlqv0K6MM5yVQoDHFn2ZnJ6TsbcgkQ4cRNZJi9KGNS+3ikZVQHv4NySqXT4Zl4Gu2L9ehKbHnjzZhJhOaTKupzuRa+JTnYOkELfrVZel1ObbzoAhct1J49R30W7M6+sxw4ZR43crmuK6nbrxQFKHczfafDuxuNWKUMpqop67br+b2hypZEk2r/jywWn9VbGEhtfQxcrB4Tja/tJeyMzgAJJIUSlv3ly12ueFwXvpyJFGRuNql5FxubHX026KwsBYRlepHupk/OZ+xltsrPDbeM2ZapS46K+VczdaU7me7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6ZCEjHkWSDUcZxGe0OhuNiBOTjyaajPFV+EeSvSE38=;
 b=AX+GEh4VY7KmQtpf1Vt669f+Lypdi5X795EF1FxXLag5Dyyxro+L2dC0CXOuOJ/jliqgyPUhITENVqb+ftp000epeKcBCH6QewFakeFP4Wu7n632+jJ8wVAbd9AZlFISb+7kWYVnX2fP3j9I+02wVX5yevToPptfPqox9nYpKTk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:27 +0000
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
Subject: [PATCH v5 net-next 01/10] net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
Date:   Sun, 24 Oct 2021 20:17:48 +0300
Message-Id: <20211024171757.3753288-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd57cf6b-0128-4491-c83c-08d997124abb
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35521CF2CEF956958029A8BFE0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T8+dJMOE/80os5qkHVrjTKraZJmcLVAfS3OkPFVMUl0U65Aed0n/BVUqVJ8XTlVPRMXLm3efHLc8lY6dLPkQdyRWWRd0HS3u8HLp0GMzD1nl/EX2mTDcG6PdCbCn1k8BZ1MPJEmiHK5pUATFEv9LzO8ZtoIZ+4ThmfkQDxcwADiGf4def+x7JsPCSdQT52kyY/q0HW+yJN/8Kp9pDiDcJL25gz7nvvGCA+SjJcGMuh2tbMfwUh4blbLOH45IARDPKjxh8KA287yJYEOE8TSwhrkHOLK9c1oxYSxVY0x+MGJ3Y16HxG+UcXENtnd3uPVCL1eSebFHDFPc/6342JHUHAa84QPe+7zm0r9yKsoWZ75TBXMdcJxs3i1QlASWQUOHiQ93G9ktveY6tDWX3HXQpPPmibEG8KGl/1eMbtpcHIzajVmlxtss7+36jxPFcoHtcOPQdaKyIeR4CeP7zAHtNkOV1spc6pZDDgRQKgUe9GFOk7E0SWi/AbqZ9wOwfj9EiymLPltl+yMxLfBgYuzKTa3j4oUD2jmYErMcPa/PpIYerqSu6jLWUlh66ObV7UQyyQY7vqzcYE5dgYotjlGEotZlhp3rszwYluvXO6RJOnVYG6x1fd9E02RclOws2iJwoSYok0FFd/G4Om993Tx7wzvzJC9mWGEQ2Jcw01u7tFt81W6nKHY/1jnBrEeS7TATUI4/AiIeEN9Q27XB0JGD1w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LSO1q1zHZ76J1yS2ecLHtExrZzUBB4tVs3gGVYx9qfvaBrUb+cC0Xry6E99n?=
 =?us-ascii?Q?Jlt1S+l1I87lETWl2MC3wrI3NsY08RTbWyI5HWjP3NLQT0xLuH8jKpzE+RqR?=
 =?us-ascii?Q?ANlqjohyjueqnPHJFutqdVw+sf2c292xyGTrnqMb0hHKLhmhXiAHXBjfd7VV?=
 =?us-ascii?Q?/+yfwDKQWa0F5He9irBn9teKapaUnZOS58B+5pyn57+BMSZ8BBaJ61h9sq/8?=
 =?us-ascii?Q?dNtq7bmEWaBp8TD4N+SQdwD4YS/mFx7posnesozAlunqlFIcjPaq4hopThAB?=
 =?us-ascii?Q?by0qKBTgdeIpXwqYdIbC3BeLHsBBB8fr91jU55vp+qm6gPiO4Cys1jkddO5m?=
 =?us-ascii?Q?vzkvugbFBYunuFBy3gArAFc+vpa7hCOqg1lG9rGgjp88NRYpToVbRkXSq16w?=
 =?us-ascii?Q?fOYh5lakOfmkmLRFHw949DsttWRvhpAkWWnLnO7jJiVACOBk7bA8yv4PK7nr?=
 =?us-ascii?Q?OoygHwYbnqgI/Q7h2KQUvSjWphSqHsy0CIAwoRbvAgsjemnkJelW3unFxnMy?=
 =?us-ascii?Q?C086SJsbFTOHhv1ZzTmnBWgdOuOOQH5zOGy3nH4/jrBjqqKCFYif5Jl/aSZn?=
 =?us-ascii?Q?YEHLPFJ1Kaz5VcD4SONi8fQ1tI9yvgF8mqepJpeAF8pxXUwd1UD2H8z4ROCM?=
 =?us-ascii?Q?MBQ5Z5ZNwdIVG9HQslHZrs+ku7JbDEAQ7Wid2tX5rlI4JCocqMwHqmqrAYvt?=
 =?us-ascii?Q?yGZ9PmMD5Jvf4ztDd5+O+vwvrPmHVp2i8oq3XQFzMy5LuA9ZFXv4OsRq84nk?=
 =?us-ascii?Q?8B74nX8naQbNb3VIhLSTqfk0G8lVOWEscVH+QNNnampw7XJaPAyrUHPfDTVc?=
 =?us-ascii?Q?sSk7hFpIRtuJlzU09JGJqFlUh8tGTfZnjaR65rCEZ26HA6LoYINrgQ6zwy1X?=
 =?us-ascii?Q?GKRrI5QLqOBTzl96P5DLEJp1pfTq+xh9UFlYkLh2rbjrOqoh+yvL2gLXb2rS?=
 =?us-ascii?Q?Xymd8WdITy95y3iWSznO22DTApsJ+eDgt2xmZJQTzzUT7KmG7ua5jmIjFBNV?=
 =?us-ascii?Q?rqD0yC9F0bzwpKPXvqDmm2S+Qqr7M0riJhNAobTt0weR962V72wjF0CMq9Hl?=
 =?us-ascii?Q?vBk/WPSIgqle9J5NwKymZnNGF1agpORxd8NjXGDHXd+TIL93eE6KQatljOgD?=
 =?us-ascii?Q?WLqtdrJhEDw0zO9ppQETe10OJJ/lNpqGXfsHQibMNQQej9QAyzBwTSWR6VA2?=
 =?us-ascii?Q?WHGl9awsNOByPhORayIAS+HXxidW6P/U2++vMj4Bjwd7aUyNg0IgmBO/tYBz?=
 =?us-ascii?Q?OVta+5O23Gh/i2dAJLGngTH7xpigUdAV5D75xT/zKYdxLX3JZAOpD0tacKWF?=
 =?us-ascii?Q?4XF3ceanjfMqct0DoSQ2sV5rx5o1aP4NthnMKKg791tWj7hssz+VGK4VsEf4?=
 =?us-ascii?Q?PvCexU4qBGdWoFUMGyov6+QEIhpAbhXRKtEv2VD1Et+7lmx/LWLlAF5oHiuE?=
 =?us-ascii?Q?X8WYM/mT9iS07i3e1NnuJLbZ//3/zbxrOKEpDNTQhvFPYcvh0kPW2IGHyDuW?=
 =?us-ascii?Q?+xhsmc0r5y52RVv2KNFrnwgNbFnXmzJFV43TrpE454i/09EwDmfv2eJDKRU6?=
 =?us-ascii?Q?Bwozs0VUmDppB0MTSwpG5YU7NoSbuHNYkQiZtcndRErTZrAwu3VQ3fnjr7zT?=
 =?us-ascii?Q?f+8nTM2DczRYud/cm8aA3hE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd57cf6b-0128-4491-c83c-08d997124abb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:27.1090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0RvIqETbJD0FkrEtlUVqKsvZSs/TB4hpbwzvycGyjo299uomDup3VgGq9d6A2u/aQGcybUqG1aicPmU89Vtv7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, when either of ds->ops->port_fdb_del() or ds->ops->port_mdb_del()
return a non-zero error code, we attempt to save the day and keep the
data structure associated with that switchdev object, as the deletion
procedure did not complete.

However, the way in which we do this is suspicious to the checker in
lib/refcount.c, who thinks it is buggy to increment a refcount that
became zero, and that this is indicative of a use-after-free.

Fixes: 161ca59d39e9 ("net: dsa: reference count the MDB entries at the cross-chip notifier level")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v4->v5: patch is new.

This is a minor fix and slightly unrelated to the series, but my other
patches touch this area and there isn't enough time until the merge
window to wait for another net -> net-next merge. I've annotated it with
a Fixes: tag and sent it to net-next (also made it the first patch), in
the idea that if it could be picked up by AUTOSEL it would be nice, and
if not, the problem it fixes isn't so critical anyway.

 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 2b1b21bde830..8f8ed8248c2c 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -266,7 +266,7 @@ static int dsa_port_do_mdb_del(struct dsa_port *dp,
 
 	err = ds->ops->port_mdb_del(ds, port, mdb);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
@@ -333,7 +333,7 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 
 	err = ds->ops->port_fdb_del(ds, port, addr, vid);
 	if (err) {
-		refcount_inc(&a->refcount);
+		refcount_set(&a->refcount, 1);
 		return err;
 	}
 
-- 
2.25.1

