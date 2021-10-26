Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FBD43B40A
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236554AbhJZObA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:31:00 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:8192
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236512AbhJZOaw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=komsrvHFsW7WaDRK2yNd5Zl7SHC9qL3x+/zOGut61Gwq7uwommRqAfKHvjylPrkfEl2eJ3XIe3rdLoEN+k859y6uUAMesPW141GA4jW5Q7GbcO1cWoX2lDcUdoqiCUwPXN5Bmu1CJ6cQk9vxEGJvRXFLINUT3PMVx1B17ancxYEtkOfdfmkGHHNIx0c6dsLhG2cxz0XIbGyOUFZIH/ozhJ2L8kT8wFN370ojeo0KWao7d60oN9B9uIv8m0HKilSRzzDzqqtmfE7cWOU1oXT7tcLixzwU/vkKCYdGXBytJHafYgpoN1QY374bOOBOE7ipiKdNGghkXuaZhvoToi5BZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NSGBvYH2SkLrUBf8LsXqjJ8gnHKRMsbSl22BNP8YTec=;
 b=Mqi9EcPaadFSZU3tFkkgGj0YbFtm9stAM6I7Ksg0BgkYjcrs3KeyCpdiJTu+W8xb+bEBjbAYr3ES+V5mJiLGAq2Uw/iQI8MumOaVhiZNn1McNK0ymEwktImNsEuCWEe5CpADkAvf/ffEVwe9TDHcEsb0Od+LD3GcIe4fBEbAmlZCCdftT6vnga2MONgfSFJ/fMLGAMVCd4KjoRYm4UPx1h6tBSeGfWwYZwvysPtdhg5W4gq0Sl6a0qK4LvxET1FZuEBN2Zdpg8HFirMUGbv1h9LrJMThQdty61tkeUv97qcwAALqw7SPIC/aW7V74iE5UCHuA/c1vzki39W1eYxYXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NSGBvYH2SkLrUBf8LsXqjJ8gnHKRMsbSl22BNP8YTec=;
 b=VcNWU8MMYDsZrJgfxIU1bGaCxffHwdeMINm1LjcQXzK2TvlOUN4zNv7F9bblYNh2WeJlrHivxpOxpTRHQJDaYwQ8pT9MFB13FxtcYKiB9+i29CiNfgeSBqbI0bCOFy3n7CFSTtnACw/pWGIZlkXAM9VmKUU5+PGQteHq/0m9C1s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6016.eurprd04.prod.outlook.com (2603:10a6:803:d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 14:28:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 14:28:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 4/8] net: bridge: rename br_fdb_insert to br_fdb_add_local
Date:   Tue, 26 Oct 2021 17:27:39 +0300
Message-Id: <20211026142743.1298877-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
References: <20211026142743.1298877-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0113.eurprd07.prod.outlook.com
 (2603:10a6:207:7::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0113.eurprd07.prod.outlook.com (2603:10a6:207:7::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10 via Frontend Transport; Tue, 26 Oct 2021 14:28:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e84b9a64-7c65-485c-2525-08d9988cd4cc
X-MS-TrafficTypeDiagnostic: VI1PR04MB6016:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6016838AE4640FAD7C595C8CE0849@VI1PR04MB6016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nt2HNc2Ypwmt5cpZ6zOw8AeoPQMn7AhIQ8FJ38s1jA/8lZfksdAgheS1iG/bK7h22K+FraLHidzsenIaSrWz4Ab7FkNeqdTnZiiyfbwjukj0zmMYp0zbliuQgtCwYU/DrZbL6gQzFAnjiXWVECyASSjIKTmweXEHHCKKFRDp4lnD8XDPurn+HKkvXHoqG5ka4H/BSFlOoyoObJiADQRs3BohKaW+cLjq5nMppDSmMEKlsbbxnHAtj80CyVbs4FIzk/q31dnK/sli9ep7Z7C81uh7TPBXoC7lvG+SFxNnLmRDpfFxKZLKYAxreUGuZ0WRCHRcqYuIU7y42iHD8Wf4USHkHiGnYEXgEQGGcCgImJyngFVMpg4rd5qYE25D/MW6xNsSdDCCHigJBtG9YRKC1109cPV/txPmS9WP2EE14vv+SmXIxN6N7EfAhPvJeEek9o+RBp1aU9CDARJHkbulsiJfkTC+IEou/aMGCrkWI+McR28LlCffJ96FUyEsIzAmBmEmb6iZZCDHuDT9BFZyjQOhfqXZAktug7O5YFOaEbSKMUbfyV0lrYVvGUkrMN9MjoKp+KxQ/hxRUNHr8Zm6QNwYU9C3QtGXwoIFAUV43MtbW7DK4XDVglwcRZ886nyUkoJeamNh4malht88wPKHbSCCarmYhG9Buq9ks9Wiye4MsSmr7UYccmKiBFvhTCyNPOdIetJrAgJbQYJGg1KEwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(52116002)(44832011)(66476007)(26005)(38100700002)(54906003)(8676002)(86362001)(5660300002)(2616005)(38350700002)(7416002)(6486002)(6506007)(6666004)(66556008)(316002)(6512007)(956004)(6916009)(36756003)(83380400001)(66946007)(2906002)(186003)(8936002)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nuVjn/5NV2JIggG6aUUkkoiZLyXSd7PY59DbDT++A8OrDyhC4S4tQEVnvMVK?=
 =?us-ascii?Q?+IWn2D8vDfKDhywt9cWAH1NdlkP5+qzWM4CwjGBywY8MtDxQgCLAwPe6ozjR?=
 =?us-ascii?Q?PyCwlGFBJlBp2qWHRcIUM2SxvUB8D4TDW4lJu7EATTfZV6Mm1KftNwe45A8x?=
 =?us-ascii?Q?I3IC0tzkJu4Q4jJ+bHQUZgHVuKY6yMbAa+Bfv5b7tvmJBe+W/MR8Kr1/UBw+?=
 =?us-ascii?Q?tQolz2o2Uz2wmES4t0Rx4Wb+KMty7F57LkinlJf3ZCUefCpqqIV2aziODtby?=
 =?us-ascii?Q?PC7vg5YKpMOO8scJv2qIjfD+WwxV3tjRnCm5dkrVCDk7rVTzj79P7kOrLVqg?=
 =?us-ascii?Q?cvGWimoTQkDUoe0S9gCpP8pYUzD3prxp6gJ14T0FSuYdsRuRt4SOC3oiKgFl?=
 =?us-ascii?Q?EY0iL1SlomlKoDZFpgaeXwOTimbPh+Q7dnZLb+RrrCSoXt5CEE8Ad2t/wZLu?=
 =?us-ascii?Q?ukL6ACvta6yge2VDIlZmWoHRDjZ7bWK9yCda7fxYSXbeHyMAyTrOxt6xCM+R?=
 =?us-ascii?Q?cv8ZoNVyM7/iXQ3wYy/mRfBDQXFblVjQXn6dQRhTtuIwmVW5Nwcd33igPdZg?=
 =?us-ascii?Q?9QlE2a6/X2G9jLsVE7KI5qZuBNoVU5WfYjNb//Y4supUOz9/O/3lRvyvhg8m?=
 =?us-ascii?Q?qguU28DxB4achAuLu+itEXTIaTA2/zJo4Mz0QBq5fS1288bMfRH1WWVHBuIn?=
 =?us-ascii?Q?PAfNSVA0slE+3eI8gQYc8gmpqRW7epToiSacg8teKmmPdPgbxGolvnX+upmi?=
 =?us-ascii?Q?Q/Wl75oEKZM0kwHMqMUKffoROxyH61+UDGSWx8geiLC7o5lbC/Wr/2Mq6Ka3?=
 =?us-ascii?Q?5nmoNTz0t7ldurLBA3mllW4sGeNRfuL6zAeFIWLj8ggs/6XrnmOHQ11jh8JT?=
 =?us-ascii?Q?Hqz3YeL5G/s++sUMywpQylrJtkKocr2OyhaPZ6q/PZIxanjdkAn0zJdxcJwY?=
 =?us-ascii?Q?HLoLhmyGR/pJI6uKkxkPduUNoMShqXW4U+Jlhc/UdJfBMkUJO7ElPxCM/hRW?=
 =?us-ascii?Q?i2rCmsvSkNLMJnte8BuaJLPkVGEa9h4A9s9efO7tBvNOoeDUjh9CaYjSWvDc?=
 =?us-ascii?Q?C/PlIm+zMCxdSJ8wGbBZtCAwBpoGEziwo78UxoeMP7vIAyJYEn86ok0pMuGX?=
 =?us-ascii?Q?YLM87mhJCrmFNJU1WbUpirXaSnCXRgOGtoqKdBVxHsq2VWMyb8ImvMjN5Irw?=
 =?us-ascii?Q?OMVrjztDbHnprd4KYUWFfAp0SFKmFlsxi2q7LC1Tj7NuVTESPWtPBXAxRqLx?=
 =?us-ascii?Q?Cn/70YVmpt7ixnMCkzUWr13HgDEUuQ60kM7+xhYu9gBRZraR1R3cKDFd4Ike?=
 =?us-ascii?Q?7MNqDWtUXsakYeQeXkIq3WaspanYWcYxw65YnLDavZW3Al66NdDFcmprGY6x?=
 =?us-ascii?Q?PF8UFFs96qeDXtyDK4DijodoaToBp8kii4cLSz4jybW3CGEhquQ/wmQkg6Gr?=
 =?us-ascii?Q?ltwMMKTjrKWgdDX+U/zMyzCvh6Za5+6c2QFSLsqJbrKA6tsHQQxe26cbwvps?=
 =?us-ascii?Q?I6Uf1WKVXLoIjvXmzEMM5Mg7NyGAiS1FI02t63lC+ooYnj4TCB7z0d/QxYPG?=
 =?us-ascii?Q?imCdnmEfgVGh8BW1mrUWPa2D4w0wq3Sccvzfra9wCFHIIrL2oMv/fLYQN1aU?=
 =?us-ascii?Q?rbtzSeBOCDYECon+sQxqECA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e84b9a64-7c65-485c-2525-08d9988cd4cc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2021 14:28:08.3997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqiFGEzGAUhj0yPdehfvYD6QY777vKi5HMnHT3UWn4I+KauRSEo85DTU9HULkOHOUfe9ubPg7twRVlxdMfTdVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6016
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_fdb_insert() is a wrapper over fdb_insert() that also takes the
bridge hash_lock.

With fdb_insert() being renamed to fdb_add_local(), rename
br_fdb_insert() to br_fdb_add_local().

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_fdb.c     | 4 ++--
 net/bridge/br_if.c      | 2 +-
 net/bridge/br_private.h | 4 ++--
 net/bridge/br_vlan.c    | 5 ++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 668f87db7644..09e7a1dd9e3c 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -679,8 +679,8 @@ int br_fdb_fillbuf(struct net_bridge *br, void *buf,
 }
 
 /* Add entry for local address of interface */
-int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		  const unsigned char *addr, u16 vid)
+int br_fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
+		     const unsigned char *addr, u16 vid)
 {
 	int ret;
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index c11bba3e7ec0..c1183fef1f21 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -670,7 +670,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	else
 		netdev_set_rx_headroom(dev, br_hr);
 
-	if (br_fdb_insert(br, p, dev->dev_addr, 0))
+	if (br_fdb_add_local(br, p, dev->dev_addr, 0))
 		netdev_err(dev, "failed insert local address bridge forwarding table\n");
 
 	if (br->dev->addr_assign_type != NET_ADDR_SET) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 37ca76406f1e..705606fc2237 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -767,8 +767,8 @@ struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
 int br_fdb_test_addr(struct net_device *dev, unsigned char *addr);
 int br_fdb_fillbuf(struct net_bridge *br, void *buf, unsigned long count,
 		   unsigned long off);
-int br_fdb_insert(struct net_bridge *br, struct net_bridge_port *source,
-		  const unsigned char *addr, u16 vid);
+int br_fdb_add_local(struct net_bridge *br, struct net_bridge_port *source,
+		     const unsigned char *addr, u16 vid);
 void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
 		   const unsigned char *addr, u16 vid, unsigned long flags);
 
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 19f65ab91a02..57bd6ee72a07 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -293,7 +293,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 
 	/* Add the dev mac and count the vlan only if it's usable */
 	if (br_vlan_should_use(v)) {
-		err = br_fdb_insert(br, p, dev->dev_addr, v->vid);
+		err = br_fdb_add_local(br, p, dev->dev_addr, v->vid);
 		if (err) {
 			br_err(br, "failed insert local address into bridge forwarding table\n");
 			goto out_filt;
@@ -683,8 +683,7 @@ static int br_vlan_add_existing(struct net_bridge *br,
 			goto err_flags;
 		}
 		/* It was only kept for port vlans, now make it real */
-		err = br_fdb_insert(br, NULL, br->dev->dev_addr,
-				    vlan->vid);
+		err = br_fdb_add_local(br, NULL, br->dev->dev_addr, vlan->vid);
 		if (err) {
 			br_err(br, "failed to insert local address into bridge forwarding table\n");
 			goto err_fdb_insert;
-- 
2.25.1

