Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209C743A67A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhJYW1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:20 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:7454
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233793AbhJYW1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ix2J54hhY3Nl0LFUYr0w+Ufb5UymNyrLvccu5OMfhixBbYJ/ODDfEdG4pvDGVP9yQw4zqqC1UwAWyyain9c5ICxopszsPKnKkciyYP2w8IhaQhFWA5b8MQKdPFWhZFyY6I0rPuq3NaOasGmUJkbTxsyUC3AncRpMDCVAEmxayvwy1gS59+rPyBU+l7Chryjyn5PPD9eP/tuEa5CRCqJn+FrMd7Mot9GESjOBxVkN61WEbtUQiv08LHcBU5gUynZQ4Ylx0k7H3qZlFy2V7FjcbOtY4leXvLLafkGfn/VQhXq3jUbqQlhB3n8JV6pgQgiV7tZWY6yEHVMd0+7IDgolog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LR+ObiurjHiozJR8hv2b+mLaYdcQiWO/WOrDbkXj3M=;
 b=eLwqZPEaA/X+rHtD2F0Yftl07AtSviR/6mZL+/KM7lK8zO4w30jaOS/Up03BRHFIos2hZKDwqtmLkrnuLxbe5aZ8oaZTx9bGFS7mGNtsDi4x3L65ujRxP8kGLSEwjSfz8icidUF70A1CPRVC2bOGkiEfXqQTdpD6qsJr0GNBknF3uJdixw7ciOf+6NORv5VHaAqBvEdbTXu0Cjj95yshVnz+JxxB7AyA8ZukzLDPeypVoudi4IsoFSEHDsD+opWuOhCoKCDXM1xCu9u2jU/F707bCGu33jEfPAo2K1ISt5Za51dkPOS7fG2FdGKXGUYDxZiXI4O0Mpau48d8OAXr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LR+ObiurjHiozJR8hv2b+mLaYdcQiWO/WOrDbkXj3M=;
 b=Vnqc7O6WoKXudrBPx7U0zDqTA7fKZCu23RWHNm+XZ1CRtp+OU2s+XjbBTZbtx6BhvMyda5Ocgn/e9heswYP62UVZNW9VuAgCEybIv2C/uXgMdtQDr/zrpP9bISuAtomHjYClhsdWsa0RZqXwshdWu4kvEXbkMiI4Bw2ty3iauME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [RFC PATCH net-next 08/15] net: bridge: take the hash_lock inside fdb_add_entry
Date:   Tue, 26 Oct 2021 01:24:08 +0300
Message-Id: <20211025222415.983883-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cad3a2b-4c05-42e2-83c2-08d998063bef
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23049C3EE8ADCBB5A9C53C42E0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZR9jL+E1Fz7N7SyUsJ1L9fC9K8k34drV1GAaotTg9qAi8xDidIjWzszzvrr/UzD8Ebfm8sagHiEUVIUfYjgx6CJnrPYAwADZ+Pj5qtmZ2Yt1rm4fOxdm21RPmRILdPTWN2hMNberg+5x55kdHYqptIp6+X5Z70PkeCZYpQcRJrZZjeHp58S6SPzBbQ+UvR3ygmLZOh03qnq+z39qLYM7n5Ai4KDg3/F97KKkEiydSYsYorQQqmR8PV1abccG7zWK5k6iFDvoQ+yJqDPbk93xz8SNsVt8g5j7eZJxP+B+eWqPQZ0xUexFfuIPHbrhzV9BOoxmdPKNW3yt6kcQ/BNhTTnv5vo3ggOkuC9owYH7kqxO2X63ffxswhIQibUYfZyg9Uy2j7Jvlcb8TmRr7SxlsUh6EPPbb2+K3CthZoUIh8hjbO75+V6y8S+fXgbT4ZIeuPAUeBJgWIT+HYsz4/lNvVtRqaMikQ2wu4w0KAis1mI/9S3+3BCpth75/zUyjpGcblWafYI+y3uNoPpUcXIWPCHlFlIg9lXTEZjiUSvCR3Z7YAV2bDnkQcyrmwv9uZmzrhXwiGAIchcdQTZHKbnvU3ir2Hp/Vx8TOQ7xeql9Cz4E+Y0H//rV9izkLtyVDV4Y1ZfD5TGClqQBHXBYdDnXnIzNI4tetPdyKNv5XQDkvQbT7uViPx9489DwPC7U+801sFZY7MXY2Nui1WlR3dYuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PoQgKefsoTypK+FPZHq4J7c6GE2KOJBgCvnlYLTgF9pvHFlGncdIKtTOz5+J?=
 =?us-ascii?Q?YDfygrdGUbpif5RRL70qZSFrKQdxCTy/7612m4RT3llRLWeIgl2CxlsOgg7i?=
 =?us-ascii?Q?xAWXpY2pVZ0XeWF4Eiy7KOHURGj2nxVbaNJs+5gKwvCH3THglhwjNB1lL7sY?=
 =?us-ascii?Q?WOygmg/rpcldNfjPjEfRLqssMzes4BTEd8V5qAJiu/DE7Pd2kZRG6q29M7ZJ?=
 =?us-ascii?Q?SwvCQ6go15/erVMXxBHPHSci1j/Y26MOUPKc2uC83JKltg/DjM4ncj4xSed8?=
 =?us-ascii?Q?OAYPXckNbExjG0zNAuiQVZeNx29d6THcSfSzGgdWHs+QxLcptNOLsEfs10ko?=
 =?us-ascii?Q?y8atBsPgYwtWFM4r+oUvQI5ys1WVosXWhyGEDbh/69k+t8n/BJkevAS2wQfd?=
 =?us-ascii?Q?f+J0eAPYygwS7nrJSRIz8MpSHEG6RY1ubOLgmSWoP2X38qcpE5nz9mZWwJX0?=
 =?us-ascii?Q?SZ/C4psP9HNywaxOVNRDFhbz34VyEUiKkXfnCJHPAAMXRpgao0v5NjO0Hzee?=
 =?us-ascii?Q?q6hSneRvMGOyZgGrm1Ymei4HhwqkFqg/96Ni8qxQTxsUAK7iuoxNdMpF/HOj?=
 =?us-ascii?Q?iFkDOmaEUhdO9XWX6h2hjLmZ4ExqzON9czJDNkTj1cl4WuIcwqJLaeTzSEEU?=
 =?us-ascii?Q?b5iXk2D+hM7LW+wji1S5lR+6dG2FzWRs1THQAzi/BX9BPUNIUwpa3VBSpmZ2?=
 =?us-ascii?Q?1xvTI+ss4JnunNdeMNkQzCf+kBMqfqQX/rLtMIn70uls46pHplvtqSDE/f0t?=
 =?us-ascii?Q?66jjzNDFBU3BWPp3Y0PV4IQkMS0YvO1T6FgwWHh53v7Ci7AaAL+Yy9pn4TFl?=
 =?us-ascii?Q?XpeRTfoDNWkCkLlIkBGDJe4CMYthvu9D1PZscLJ2gaIwK274yFBrjDd6HOWd?=
 =?us-ascii?Q?Z463aVWb+TUOoFC5pWT/rU7ayV0itpS39GaPHxpRyp2GHPYjHWcZxf3PAoNo?=
 =?us-ascii?Q?MR0P1KDkxlAW54ZhbfmNzbiUq+Ndz2wDa+OP0woSe/cIMEVoleB4FxPx5bXF?=
 =?us-ascii?Q?MELl1sdQikvnaktbYfLpHS4aSSu1NQm9KLZKwbCri300FW5Tww2qdFXs8Abp?=
 =?us-ascii?Q?z9OHywn2FnQeWhpkZzyugaZwaNWQF3Gja8Nq7gZiE/DnGbRjdHXt3Gf2ZwF5?=
 =?us-ascii?Q?jV6Dha882scmU2Oj3mcv8t7y7EkwOyqYwdSnprVU7FlgvXKq8U2HdSpcl4qy?=
 =?us-ascii?Q?nuJ298M4XI1cwZMdFVoKXBM/InMWKBbhYQtKgrmXmcFuM3b0bh7aCmMFiCJW?=
 =?us-ascii?Q?u5zQEezbozE0tz+wVbfCoISK0w2RNkBYRnWzbS3jYOXCf1pmOMOyLAG5AoSS?=
 =?us-ascii?Q?F4X3lYq6bW5EMNvOqNdKFKJc0azAgGplXwX2Ql9sULB0urL0qsPILrVT16VY?=
 =?us-ascii?Q?EMR7nJ6rQpqURKOreJYgMicTBOvpkE2o5jrIsPCSecJUdQoIpvC9V1sREeTf?=
 =?us-ascii?Q?lSNtpYLEv5E17ulL8m1YgBEbpk4Lxv7+T/oMaZ4xPKYyMkLppsh7mm8E2b6e?=
 =?us-ascii?Q?Ahja/gd/d/v2KR2hhWbOgs4UHp6CJaSRxCArgcRZzvTMK359D1hKyIJGmgF5?=
 =?us-ascii?Q?m46YAWXDMtebiTJL5TWbg69IAg9aqFX2hY0juicDCJ1SD7Ee/pwOebZziwiz?=
 =?us-ascii?Q?sW8h6trXjt1lgz/6U2g+9Yk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cad3a2b-4c05-42e2-83c2-08d998063bef
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:39.3533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyvKx0UHbV9pGbIdkS5pdS7MspmVANewd7B62/wWZjNo2ty8rUvMIBi8i3L6Ig81+DerGkcR08wyw15zoEqiUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of a future change where fdb_add_entry() will do some
work with the &br->hash_lock not held, make the noisy change of taking
that lock inside the function separately.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 9c57040d8341..421b8960945a 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -893,19 +893,27 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			return -EINVAL;
 	}
 
+	spin_lock_bh(&br->hash_lock);
+
 	fdb = br_fdb_find(br, addr, vid);
 	if (fdb == NULL) {
-		if (!(flags & NLM_F_CREATE))
+		if (!(flags & NLM_F_CREATE)) {
+			spin_unlock_bh(&br->hash_lock);
 			return -ENOENT;
+		}
 
 		fdb = fdb_create(br, source, addr, vid, 0);
-		if (!fdb)
+		if (!fdb) {
+			spin_unlock_bh(&br->hash_lock);
 			return -ENOMEM;
+		}
 
 		modified = true;
 	} else {
-		if (flags & NLM_F_EXCL)
+		if (flags & NLM_F_EXCL) {
+			spin_unlock_bh(&br->hash_lock);
 			return -EEXIST;
+		}
 
 		if (READ_ONCE(fdb->dst) != source) {
 			WRITE_ONCE(fdb->dst, source);
@@ -948,6 +956,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		fdb_notify(br, fdb, RTM_NEWNEIGH, true);
 	}
 
+	spin_unlock_bh(&br->hash_lock);
+
 	return 0;
 }
 
@@ -980,9 +990,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
 		}
 		err = br_fdb_external_learn_add(br, p, addr, vid, true);
 	} else {
-		spin_lock_bh(&br->hash_lock);
 		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
-		spin_unlock_bh(&br->hash_lock);
 	}
 
 	return err;
-- 
2.25.1

