Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CFE57698B
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbiGOWFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiGOWEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:04:04 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60048.outbound.protection.outlook.com [40.107.6.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7B18E4EB;
        Fri, 15 Jul 2022 15:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ge1LK00p4qsx1cJb/F/1xDhD7wmq/iEhYCJsS3T3n1HO/iOWl/tNm0IxGfqeOYq7Kyz7Da1NgdqW9upsClgV9Zg1VoQkIcMADQh3b78NhEVZtW1TjitE3iTDgS/Z9dFgWqtr/UiIJvXYnlPX8i55Z7jdI44N0OvyR73/Tf6q7aHIRUnjlwMV6+8djsiOjtiuB+jKUCCBYzhWyFeHQLvpkaP4rvInOlLmohHGrIaoXNoUEu9Tfg7ThSRSEEcdWMqV0mVVWYG4ugdkMJ72+HWZI2wzYNAA8FCGdB1QLAm90Q3cqZG09TzUUQwn8Sck6jVRNeIxPRLwNOHEAVjUwb30Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6F6kJr389oREnPSKtMqwsCZtWk3wAG2vXWfopMgx64=;
 b=BRSUA4cI3hkV898BfyzyRrkgCOWsPKCve4pxVDMlGDMsGdUo9wb0uJejD8XvFGMShgS8pKyGGDihck4E8UgrAVs87RKSRJfbNVwqm7L1F9iJrqWX2tHZO653l6yQvWnV0tEkzK/YeyIzQrd0l2Tudt9InGHAJUDWMOiADE7TlHxfREpnfuRg3vo2xY7kspWFD8dlCRL59WpvrA0SZ9P0lkSWdz+yh9OwqFKBbdgbzPpT5MkqCAZYU4MTIIf+s5UYTkjJCBgBkrLklitQqftdftGHRBLBkYpxTPOWoy3MuyEPEoE3DJN3tHYFlSXDnmCW5DxzqPsLl5SS53J5DnPg0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6F6kJr389oREnPSKtMqwsCZtWk3wAG2vXWfopMgx64=;
 b=yQK7HUcfEbXBgPMS2BggpN36aym6b5OclmccN7UowuWab7wYp8NnKmI/HQ2R8Eqk8KRV0BVKx815P/SbAO/tR5htx6cHFrMvBnCV8MLlHISP3pYqtFZXjuaNO0SEvaW0wNsB+yiDUsMmWVWgfCsbU2p53iHMzC4LE41YpO4mjGlTn49RLE6UuE0VqZkAwpXgz+ogDV7kqkG1HA7WqL5lVjL6KknK0HlVqTyyIQv7nx5ckditeIURw072up+GSq3fBoDmRG6HhU8Ow0u70+irZnTeeaPsAIUWHjnR/dV+k0aSNn/sxLh1MR4YP4foDYZ+vA9hcSPUk0P0AeB7wt68Fg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DB6PR03MB2902.eurprd03.prod.outlook.com (2603:10a6:6:34::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 22:01:27 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:27 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v3 33/47] net: fman: Clean up error handling
Date:   Fri, 15 Jul 2022 17:59:40 -0400
Message-Id: <20220715215954.1449214-34-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48241f1c-f73b-40b8-3653-08da66ad90f6
X-MS-TrafficTypeDiagnostic: DB6PR03MB2902:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9xGR8Ksh1zAv34zXVtzWtHL3CtSDHO4ZY2gceuLvL0mvOR7mwD/DRcGc7D97yU1e0oWYNnNJqaH1SNXK4jYHoyS9Oj+b/1DthLD6Ek+NNYwDBF4FDAHALZNo5LDOZeMqCpoRRRjG7Wl1HuLyWcZYRZjZE7jNrHgw5klWH+rcbY4Ifojek4RUOyNlWLt5t/Li8eM7edxkrNrAZzAqBICc0yKcFvLQOWWCv6Y0/UYJ4p4quv6bwEGg62kOpvlbXT3Hsgyq5vE41WnmFYlxhvbluY8mqdTihn7MLyAewZ/sZKfqLuYmnJbSIliX2v15jY27zs8haNXFy5PZxSXS6Ji4iNXh5ehxBTou1bjgurYDpCp5aAHDQOwWK/N//JDnmSTqhgRWqdfxhVlJ4fajY2afYrRCMgThIo1P4BzahkQlzEH70oQh+qzG9zs5cRQgR/Gvp9gxahyp61XcpL8BWgUZrwKqbJKrH3JCbuPiQleL+qrO05YV1fk9TLryUBCXSDSNQpYHDsSLiwYHyf3GFAW6gIpmzU3pnenxHLhIhpKIt67wW5m7B9n60ocpLXi+EDk8TbqLee4urzNd1fjHGdhH1Bkw5mPV7de4kVI0EFpTT73vNLMxxLOLJgAnOaC7UThd+wEP2y6k28qo/RmeulHSJelDuh02hBJWSi8zHb4O0fDVEaTQH+xPc4N9KfFgp68fwpS5jgFitbt5Dm9M42w26OjxAl8A0zueyLeCgaONfy5/80YuiDQsM95AjOBe2uVtUdL84mC7yR3U63syb0oWMwNy8SVutanxcVxfPHfDZ0xutgd0EccTfswBAtS/kgx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39840400004)(136003)(376002)(396003)(86362001)(5660300002)(83380400001)(6512007)(1076003)(107886003)(38350700002)(38100700002)(186003)(2616005)(36756003)(26005)(6486002)(52116002)(316002)(41300700001)(6666004)(478600001)(6506007)(110136005)(54906003)(2906002)(8676002)(66946007)(66476007)(66556008)(44832011)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X3ud3n1PUIDTo+ILvitoh2PYJLXxONCse6OFjfpnpgt49T3UtFwH9iceQWmn?=
 =?us-ascii?Q?GlLwPgnwnVqCe+rNx9n5TqbWjpO0rXawBxevboRuFChb5S9lnENhIcdPmQP9?=
 =?us-ascii?Q?NWR4oPwwImJIXsFY6ikBe/5fW39XXMUCD8lcMmpIl/YJ4IPSLie7/W9/sYeC?=
 =?us-ascii?Q?/RgtbugFzJrUVRRMjhLZISrhdF02Bi9C575FnUYsxlPdzP8IzWHzrUfFQZ+h?=
 =?us-ascii?Q?DiHn0oEFHqZei5EQrfV4LlFV0+v1TbYe67MabUBJfu3LcEdWCXhzh6E1CUn1?=
 =?us-ascii?Q?/XSV2M+eWVneNPXfbQmgIP4N9lJCgUUFQDQy2RlMaHr6ebv2uqYoyUPY2+Hz?=
 =?us-ascii?Q?vKUT6+08Im0g2YhetW7HH6WA0srf70uDR3wBQ/h9iQElSvbvGEogEicksIZX?=
 =?us-ascii?Q?9Px8mqFoNxoBrBl257LDfzDyZXhhBUiqoIV2GPHZDSSdV5JID7MnCZxKIE8o?=
 =?us-ascii?Q?CIKJ15JVQQYunv9kPQqLUjul+QImHFManjlKelYvCCFH91J+bWrpxcOW5WIE?=
 =?us-ascii?Q?EKDkOG+aCMXREzrZlZnO0EbV/twJY3np2U34FNUIaAsWqpZfgwnrgqAABYvM?=
 =?us-ascii?Q?Dcxst6rvQ2nfJe5anm5Hj6Wf3UbQmIRNwlYz3Dz7OlKhROTa/lUxMG799ugi?=
 =?us-ascii?Q?SFnyHOrb74Zv3jnY50ofD/cIvpZQ8kaSfkR4f0g7UELMuJhfk+93AQUPgpNR?=
 =?us-ascii?Q?v1vxvbRxk4fAo1xoxMqCNfAmMZmfgMFeHJ8uNENLonSlvlZvYnabtb4h0IGz?=
 =?us-ascii?Q?ITIUCUtAO4jcTKQ0xdxl0oXbUJPGWHUtd0eAeifYD9gVMZTPNZdJ9HQk94qN?=
 =?us-ascii?Q?tJdKmVKVJ7tQyOhJkEkOJHhFxdXu/b/PGkYko2wrQmypIhH4DlDfwKfYheHo?=
 =?us-ascii?Q?q1Y/81KZc/utBx9tc3Hac/p+b/JSN8Wp1kvzOg+UQym63YeQSAAqyk17saBM?=
 =?us-ascii?Q?o0/1t2z3EOM160Mv0wVUYTtXCR1UNrQPYZEIT55ubY1Gs146Uaos5e3O2pfo?=
 =?us-ascii?Q?wEdmy6PzMSGo0aiBtU6i4xnyUcnVCHcdPHiDGkw7DKdtVrkAMIks+Y8raZo1?=
 =?us-ascii?Q?BSMI7T14Wi56o61/99U3NmbVxUSGu55n14goS8TsmlvDBrvMuroIdRcUsyB2?=
 =?us-ascii?Q?vTS+4iDe3MssYG+YVIuQpg8Sf9JyJIvScUF8kfHjM/pH1qrlmpDfFhxGFEqH?=
 =?us-ascii?Q?NPFbdiWpm8bX41pX2e1uWcdHg1qWYEAx9+J+3KIwMKYl8Hrj9vKgvEMtBzMB?=
 =?us-ascii?Q?VbEP6/gWQkbgY8y6oc0hl1U/2tzwJbajlNF3574yX2+iFf1OpTlUNxYnyDNt?=
 =?us-ascii?Q?W2iOBdV9QBn2FN2AFHmZrU1o0cZ3BNJk4oIK9+8NAzag4zert+spd3CVnPNz?=
 =?us-ascii?Q?rvrwXHrV2P6V6DqoK8Bp+JP4PQvTSixucU1v+gp/0V0rAYLuqe4GIVQOKVEi?=
 =?us-ascii?Q?QRmaeQOsC77i/A1inQFydY0htOLWU5cqDVFQue47EVXWC5eyGO7out+I9oVu?=
 =?us-ascii?Q?N5d1gHjPBmwh9oF4QabbtVbiLkv/bx555qMyvSX/ZWY9JxkYZv2mCA2+pKm3?=
 =?us-ascii?Q?MsAkEXywy/g5N95+OkpWSA8MVZEvhoziB0kTgduy2/ZWzS93Y+giGLRlefi7?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48241f1c-f73b-40b8-3653-08da66ad90f6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:27.5026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAnovIGUtPphlR1aTEmEkg2Qeygp+JUNWqun8WWyigdB18IMCmNzqbbLv7LuhNhUWo0u6+QNfQ0y3/XN4M0DGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB2902
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the _return label, since something like

	err = -EFOO;
	goto _return;

can be replaced by the briefer

	return -EFOO;

Additionally, this skips going to _return_of_node_put when dev_node has
already been put (preventing a double put).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 43 ++++++++---------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 66a3742a862b..7b7526fd7da3 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -291,15 +291,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	init = of_device_get_match_data(dev);
 
 	mac_dev = devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
-	if (!mac_dev) {
-		err = -ENOMEM;
-		goto _return;
-	}
+	if (!mac_dev)
+		return -ENOMEM;
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		err = -ENOMEM;
-		goto _return;
-	}
+	if (!priv)
+		return -ENOMEM;
 
 	/* Save private information */
 	mac_dev->priv = priv;
@@ -312,8 +308,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!dev_node) {
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -352,28 +347,24 @@ static int mac_probe(struct platform_device *_of_dev)
 	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
 	if (err) {
 		dev_err_probe(dev, err, "could not request resource\n");
-		goto _return_of_node_put;
+		return err;
 	}
 
 	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
 	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
-		err = -EIO;
-		goto _return_of_node_put;
+		return -EIO;
 	}
 	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
-	if (!of_device_is_available(mac_node)) {
-		err = -ENODEV;
-		goto _return_of_node_put;
-	}
+	if (!of_device_is_available(mac_node))
+		return -ENODEV;
 
 	/* Get the cell-index */
 	err = of_property_read_u32(mac_node, "cell-index", &val);
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 	priv->cell_index = (u8)val;
 
@@ -387,15 +378,13 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (unlikely(nph < 0)) {
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
 			mac_node);
-		err = nph;
-		goto _return_of_node_put;
+		return nph;
 	}
 
 	if (nph != ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
 			mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -404,8 +393,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		if (!dev_node) {
 			dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
 				mac_node);
-			err = -EINVAL;
-			goto _return_of_node_put;
+			return -EINVAL;
 		}
 
 		of_dev = of_find_device_by_node(dev_node);
@@ -465,7 +453,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
-		goto _return_of_node_put;
+		return err;
 	}
 
 	/* pause frame autonegotiation enabled */
@@ -492,11 +480,10 @@ static int mac_probe(struct platform_device *_of_dev)
 		priv->eth_dev = NULL;
 	}
 
-	goto _return;
+	return err;
 
 _return_of_node_put:
 	of_node_put(dev_node);
-_return:
 	return err;
 }
 
-- 
2.35.1.1320.gc452695387.dirty

