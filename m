Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0776E43A673
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 00:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhJYW1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 18:27:04 -0400
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:57392
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233533AbhJYW1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 18:27:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATeugIa3FOg5DtfeYPQxv34PGLiteZX3YRrCgUhFPw8+p0kWbrJA778Dzu3snLGZh4sCdsomYwhRFsls2+aEtn6HeOJufwXYHR/ZnDLcsuPLfT+yiK/7ZrQe5U0w5lKu4SskDeaDWx9ir1u3BFBZiIL6eg4YHO4VdmJEvvF/QZXzggybnUJC/Vi4Glan/JZ3tijSndm9T1IpX5pKsd0I10kL6HqzGzBieN0mc1TqSHp3Z5Xlmo6bZWS/uLPT9Q+PqQ8+as5oepAsV0wU8jAEoZ33CJs5H1IZIZkiM51gi5rh24tUzKauYZcQZLzIYBhDP9YBp/Jr9c+p57iyfaJ/Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvbRHe2D2GOhqslN/gUHsBLkoTEA8CQqSFeQfiZwFDk=;
 b=jBapBFL3nY9geJj4KBS/hfF9xNUB9gcf2Np1k0aOQhBlcKxrXFuRS+I6drMy6Kxg/rEY3gBQagvsHhjWJIekdEQaMjWNF+DBpQTG8CcJXrQlUZzWnYsFSx2hCVs0eUZXDlX98XAB4A1M+cxBc3VZwvifQjF9dx3NXgbtrWnbcLJzoydnuz7t6JZCKB8vTn45/ofh6Ktyjlpy5IkQZ90LVuIf98eE+Suay03AKErDdSt6oLyVhVoSMfKuglKEU39Etv0/u4E8D9hJvlmAm3sCaO/+dvea9qLgkpmU8a3a2YXSXrtHRJc4RP0KCHcBxf97MyOFSuDK+JndQ/KIlYj+qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvbRHe2D2GOhqslN/gUHsBLkoTEA8CQqSFeQfiZwFDk=;
 b=R48uapZz1TWR6j9Jt6I7Vy5xwWIH3IpO/2cjvTpx6b0z7FDhRMphfBTk9v3kUoeWOKTLxai3Y91M8/nIIUwg68qeyF6RxpFtcEajfPt68wUPaQaui7IaBQDm13p5+WbHMFascZcRPYrkPNC6wf8mjQ9rPC3ilIEA7tRMBJ19OIA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2304.eurprd04.prod.outlook.com (2603:10a6:800:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20; Mon, 25 Oct
 2021 22:24:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 22:24:34 +0000
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
Subject: [RFC PATCH net-next 04/15] net: bridge: rename br_fdb_insert to br_fdb_add_local
Date:   Tue, 26 Oct 2021 01:24:04 +0300
Message-Id: <20211025222415.983883-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211025222415.983883-1-vladimir.oltean@nxp.com>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0137.eurprd07.prod.outlook.com
 (2603:10a6:207:8::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM3PR07CA0137.eurprd07.prod.outlook.com (2603:10a6:207:8::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.12 via Frontend Transport; Mon, 25 Oct 2021 22:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 800973ae-f028-43b7-9e50-08d998063907
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2304:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23043E148CB3E3DE0E9FB5CDE0839@VI1PR0401MB2304.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOTcQphPiKOr32y4TcctViziMXIGYmOmJMYI2YYzRU7M2QGfYwcKsAQm1b+6+oxvPIq5c/i/au1wmcc003dWxuS5Fb/O5HjGbrWPv54LbNL658uSV/MCWxb+kSipVIU/Ho6f8Nz0qE+ii79Lb4Im5lPwyXBaQmWz32oFtvsirA2Q4dED4yspT4HfK5S+PhvH0oVKqwqRd0ZBOhqUl78dQI61/yWJ7KBvclp6z30BkYzzP1ZalzMJ0ankcaF0o8nhWaqvoijP44k5b5VNLTBD1IrYTmEYzZ3SoncF+MEXTSI4oaha3xDYK0W+vHqGyW0RwbrYPzbBf2gY4jHPylQzfHcjZpiN65dmR1uajRvArnLKh3GvTYyBQxRH5/we/PDLZJFT9wMqmuEZKc3cLsvs9rPSyiAIMo2KhQfW/BM+F1lPZVbzkBW8QeyIQmVmtn0x25UY4H5kvqYm7Wswi0ei7kXYEtAuAvib53tEHbBA41uErPhnGDJeSI+qyARtM9NlYFkVc7+3KQUbvL3/UGWR+2mjARJb0/3mggmumqBfv0TV8wCh4A0eshreDgZ3yF7n2SmuL/xy0NjWwTZcU2MzVATIXjvfF2FQOefwjn3ojmkwG2AcZcjejqPmaooo25XYpLvldaKfIkdABz4DAzL1n5r+O8RpsyFQDRJWqWFzca+/wqVzmqXYmBuW0mpDbPeCVJqI0wJx5UD+aH13Av4gwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(26005)(38350700002)(6486002)(186003)(8936002)(7416002)(956004)(2616005)(66476007)(36756003)(8676002)(44832011)(5660300002)(6512007)(6506007)(508600001)(83380400001)(52116002)(54906003)(316002)(6666004)(4326008)(110136005)(66946007)(1076003)(66556008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iZc7P9hc/utcoSH+4BhWhyk1eSwU3xlJodyGkMKZIxh2N4SyZV6F2l0nITgF?=
 =?us-ascii?Q?5CqkY/IaLWXHkWH1jzeRXUVJfTBpxf9FRGl8OBMQqKa3w7qultAJJIIX89qN?=
 =?us-ascii?Q?txwFqr6ZOYCCUpVM1VTcHM9hQuokSbnwPpvlOx5vil7xUd1cpgCS6B/znFvp?=
 =?us-ascii?Q?IIX6r2j9jTDbWNPBbYoBcbBvD2NSSLVzaWXkKTYyulKDf95qRZIl5IBSq2rz?=
 =?us-ascii?Q?cWtIylo70LZesp5mv8GN3YWNY4qR1tFlMevFyImSeiMG0uDKVSah77pR5b2b?=
 =?us-ascii?Q?NWtkaEYKZUYKEtoQqcUvBGdvFhRNT7oM51Gunp40FcOzFWKbzwZKWpAOA/is?=
 =?us-ascii?Q?Ae9kX55/SPsVUl0NOFIQaaiymGKdtHkCuH1RVTV6qHnqfpgKKocEqmjlFR3Y?=
 =?us-ascii?Q?50fz8DLdlR3z277/5K/ItMNRbqmcBvATDdNXufCSIQysdD5eK6w7sIwYgqOw?=
 =?us-ascii?Q?Em7tYfb+VqIN8bSA2FXBbP5vT7f2VAuONmOKOnFts4e2RWVJ26hCcM3+KuXw?=
 =?us-ascii?Q?wCZgB3pGCffzzfuzGKLCXA1G60EdV39oCu+DpddaRuEQYNoaMmjH7TnXTr2y?=
 =?us-ascii?Q?0cuGcFfh0e/BPPHIxK33A02dMeSPPGl6BR1/aQp2X9jHmSc5Ct/aIj/LgWyf?=
 =?us-ascii?Q?oZlvKfZiSd+/culRsdr7W/B1xw5FITaOd7elVu2cvjW+Bvaocoq1hYeFOPZL?=
 =?us-ascii?Q?J9OX7mt1UGLIdw53nJ4tiTQdpbdn6AQPayp7D99zC5kOOR0Lvj6k+MNCOHLz?=
 =?us-ascii?Q?iL4qqBIjNJemtnU+0JY5EzIBObHiwlSAy5bMRGblY94lY1wWJs0GtBDs2A9Q?=
 =?us-ascii?Q?tEVq94UoIZ7iXsqUdNNeRQor03M16AQSupSOgQG96u6tnomD3MRvqrGRzsgj?=
 =?us-ascii?Q?YHPoSjAa2VY60iQilsG/gQDTFgw5HJ6PzB2FVIZm1tjacUFC7/gSSc3nZHlZ?=
 =?us-ascii?Q?MBovqrZ4S05vrWYSb0DfT7blCoR6Rf3q9RR7DWZ4FX/65bpjKPo57jr4Kmsx?=
 =?us-ascii?Q?K74DF1mEqs9pqvyQ2wE41dzfsjaqA/VEx7oOLagP0eWUOAaP3COwqNJaTewz?=
 =?us-ascii?Q?kiSYWU+Qb67uKLNyw1oR9Tcd+/BmnFTWvhGBc4T+Y0aKudlIgBHgUF85syzA?=
 =?us-ascii?Q?92ciuTvnz/hPXIPdOyqPeIucfkRKXbo0bApXC2G9fGEkHs0sfCXZnDWmXatA?=
 =?us-ascii?Q?aD+/kaO78F6V/HEGnxGlCbBoEVMd+TFnDsXmfSHWXzNGgdb1glyjFiTV6GHH?=
 =?us-ascii?Q?LHvyuZTnzJZUxgMuDP+DRYQeiaMx4WoewLA/7zpLA1OnEdNfGxzD8q7mNePn?=
 =?us-ascii?Q?HBo4QJaTPdkQp3QNC1OJYOepEojQ1Er1XPTonYQpKecWNeCT3piaRn5eZMRs?=
 =?us-ascii?Q?nwPaXfzqn4QZbVkfGYFEK5IYi3xBtk0qP5QJHr3FkNLdl/tU6vnOWFvvqtwD?=
 =?us-ascii?Q?ei43sLgktX3teJ7aJ5nABNOuVeazLcUCiv+roNh2u62PpVCmBE+VFKKah1UW?=
 =?us-ascii?Q?lk2rmrHPioK9ATlKHWyPeiTsU85MGjiVjzieIak/HU9y9RO8JRvfCydCOHDn?=
 =?us-ascii?Q?EfxfNGfT+XQdMiqm351iwI78zWlyog6BwKNkb/9RZn6XB6WTxw3SrP1T6CKX?=
 =?us-ascii?Q?QqUhujn1zfwq7pbtJ8wK6cA=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 800973ae-f028-43b7-9e50-08d998063907
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 22:24:34.4971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n1ou0TgxSPMsoa0kmz+aBV/xmaJTkb9IlUw5U7CuamJLn4WPeeHlcJItUrrKK0CPijty1C4YiaEEM8xBSNYhvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2304
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
index 0d6fb25c2ab2..d955deea1b4d 100644
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

