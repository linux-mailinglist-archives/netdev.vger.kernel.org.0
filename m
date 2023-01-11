Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AED6665EA5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjAKPCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbjAKPCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:02:39 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0DA310FE
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:02:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bIIni2NI7QTPXWk6yAJjztk0k7biDh1/Ks2QjGmmixf8TLbqKIBiJHpcsgYe841EI5e9zum984UhLp8D4f9bK6E8hrUO767TZ4LdK0N1n2dH8U5M+rsXwHZ6fFnV8oiW/SvdR5nN4C3SKsHSx9+iz1x42c8lM4kSLOFhp0KgLJ8meCoedHgik5tWajIaM/4t4mwNacSQLcUkVgTASK++hXJJnq+hjXhMheGdvuqxHgTyWpIFdNHFsbodv0anVdcMiws5uKKtSieLVlgDRQnfN3jWBdj6WvTTRvMUByMK9eqVOq8T8PX5izaEPF+FxipMfLP0s0RtxmpTbjV08TY73A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24rgD4WDN0nlHXyGZV9LXT9doazl1rNviahifofhG44=;
 b=djcv4o1IkvkPlgU3uxdn+sM6qnCN9oZUGbVJtaVwL+20P83iprukBL9b4fFuYhkoFPs9T+Is5pjbC0AQNTlVVewOV6TevkmOH7I7Akbd9bJeuZWsPU5r3HqMDi6WggteOop4p4sJvW8QNdtQy67RWw1fR3doz957Q2XrvXE5llWBuFzUXaDJLVUhSZMadq9PsuLy/3Lemx7N7PJkauAp8tWzqE5dA02XhKz4jlic7WdKIIJrnpN/oWtyr0p2O1snKclFAG35LlWu2Mz4tSdsIY7tHOSiR/+2stUnjKt15dgjgJdVhja+ItRX2El0XpuDzJqn7Gw+w2qzOMbbfsSfTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24rgD4WDN0nlHXyGZV9LXT9doazl1rNviahifofhG44=;
 b=iGJMXLcK4AN7HdZ+MiUfcG5eZKbHGcmZLGV9JJLkBYJa0Tmf1wNusq8wHF1GGrTPaxbBaEPuVlvpMO5gYxqXJUWDC3YywNRee7rvtIx290zwHRwTdM4qa39VCZNofFUwb1OeXx7WiTSf5hxAzzCxWRIQ9rwKouCFAdrmLwOsB6nS6XA7bXA1fgplIxl+TS6GdrfWmOiVGDZyJfzIkNCLJpIyL1hStEH7x7VgrIeqXH5/n1djWZxvlCocxISOZ5YrO06tfBfuphmvDnSAgpv0bUZRPRea6XIl5UKbMBzBPZwsyJaIepZ0fknjzTTRSxMl7Rc9yVuitkjeXKIYgUgS7g==
Received: from BN0PR04CA0022.namprd04.prod.outlook.com (2603:10b6:408:ee::27)
 by PH8PR12MB7303.namprd12.prod.outlook.com (2603:10b6:510:220::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 11 Jan
 2023 15:02:36 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ee:cafe::ed) by BN0PR04CA0022.outlook.office365.com
 (2603:10b6:408:ee::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12 via Frontend
 Transport; Wed, 11 Jan 2023 15:02:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Wed, 11 Jan 2023 15:02:35 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:26 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 11 Jan
 2023 07:02:25 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 11 Jan
 2023 07:02:23 -0800
From:   <ehakim@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <sd@queasysnail.net>,
        <atenart@kernel.org>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v9 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Wed, 11 Jan 2023 17:02:09 +0200
Message-ID: <20230111150210.8246-2-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230111150210.8246-1-ehakim@nvidia.com>
References: <20230111150210.8246-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT055:EE_|PH8PR12MB7303:EE_
X-MS-Office365-Filtering-Correlation-Id: 79e7cad2-8dd5-40cf-1d0d-08daf3e4dfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oVlk8FTYJUM26ckRpyNPjzlxmRwDwHIQ4WjYo/WtxrPPc5RJAeF90B/zzBi0RE4DlrBWiqNJzwUujfDrg+MPVTaGDZXQZOcErwvNQScxDSWc5RIEa12/RqtY9T4CKLaps3qm0uj+9KxJCrjNFhcIwwdHsrxwjZ0RGuk1Ga+NHtYlgkkcM3UkKYXSAxlc1JfIqmnZHSrFwtcbbLLiEjX9/smpf4Q17ZLtPbAWnGq7KGpevT4AgSdCu7fZV5WdvjqnkaN8oLaF94XB3K03UybOFOEBJ9rrUf2I3aqbFWnTL1A5nE9HnHSepM1xJmVuIf+VVm5ouou8qtR5EN6viFfD7GZiMmhl1svaAkYaDFAUImqJV9jU3U+ofJlUt2dTRlEgEobwpqbTC17o4RicazPD/PL+JIzJ20fCpcH+MW/zbfXMHqqsDGcMu/doqriSvaUwUey+GOv8DLE4g2HbE8ltRui6p3S8fh8A6/98QePJPCyJoaOPhpQ60j03aJQfBy3wmrwoMHKeyvorCB+eGHUmqMQamYmGj9iO/PpLjGyJpXbjB722DzejQtnEhH1eca7Psq2WSk7JxM78GI7y/AePJyymnVRbQSv6txWyEplrpByoDOHJH9DYqawgd8r4onJGsQKh0xOPkkS7ilutZi8Cr+hpCRIJ0+uyY5iCaVcS63RXj3eDDvdXGgtIfV7jagRmDVfJAab0fVeHLDHgJqeBqw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(136003)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(7636003)(86362001)(8676002)(356005)(82740400003)(6916009)(70206006)(40460700003)(36860700001)(41300700001)(70586007)(47076005)(8936002)(2906002)(316002)(478600001)(82310400005)(5660300002)(83380400001)(1076003)(426003)(336012)(2616005)(7696005)(2876002)(6666004)(186003)(107886003)(26005)(4326008)(40480700001)(54906003)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:02:35.7104
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 79e7cad2-8dd5-40cf-1d0d-08daf3e4dfcc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7303
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Add support for changing Macsec offload selection through the
netlink layer by implementing the relevant changes in
macsec_changelink.

Since the handling in macsec_changelink is similar to macsec_upd_offload,
update macsec_upd_offload to use a common helper function to avoid
duplication.

Example for setting offload for a macsec device:
    ip link set macsec0 type macsec offload mac

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
v8 -> v9: - Initialize ret variable to prevent returning uninitialized value.
v7 -> v8: - Dont call mdo_upd_secy when mdo_add_secy has been just called.
v6 -> v7: - Dont change rtnl_lock position after commit f3b4a00f0f62 ("net: macsec: fix net device access prior to holding a lock").
v5 -> v6: - Locking issue got fixed in a separate patch so rebase
V4 -> V5: - Fail immediately if macsec ops does not exist
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
                 - Fix code style.
                 - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                        to be sent to "net" branch as a fix.
                  - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                    to changelink
V1 -> V2: - Add common helper to avoid duplicating code
 drivers/net/macsec.c | 115 +++++++++++++++++++++++--------------------
 1 file changed, 61 insertions(+), 54 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index bf8ac7a3ded7..4ba6712d5831 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,16 +2583,57 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
+static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
+{
+	enum macsec_offload prev_offload;
+	const struct macsec_ops *ops;
+	struct macsec_context ctx;
+	struct macsec_dev *macsec;
+	int ret = 0;
+
+	macsec = macsec_priv(dev);
+
+	/* Check if the offloading mode is supported by the underlying layers */
+	if (offload != MACSEC_OFFLOAD_OFF &&
+	    !macsec_check_offload(offload, macsec)) {
+		return -EOPNOTSUPP;
+	}
+
+	/* Check if the net device is busy. */
+	if (netif_running(dev))
+		return -EBUSY;
+
+	/* Check if the device already has rules configured: we do not support
+	 * rules migration.
+	 */
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	prev_offload = macsec->offload;
+
+	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
+			       macsec, &ctx);
+	if (!ops)
+		return -EOPNOTSUPP;
+
+	macsec->offload = offload;
+
+	ctx.secy = &macsec->secy;
+	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
+					    : macsec_offload(ops->mdo_add_secy, &ctx);
+	if (ret)
+		macsec->offload = prev_offload;
+
+	return ret;
+}
+
 static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
 	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
-	const struct macsec_ops *ops;
-	struct macsec_context ctx;
+	enum macsec_offload offload;
 	struct macsec_dev *macsec;
+	struct net_device *dev;
 	int ret = 0;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -2621,55 +2662,9 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
-	if (macsec->offload == offload)
-		goto out;
-
-	/* Check if the offloading mode is supported by the underlying layers */
-	if (offload != MACSEC_OFFLOAD_OFF &&
-	    !macsec_check_offload(offload, macsec)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* Check if the net device is busy. */
-	if (netif_running(dev)) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
-
-	/* Check if the device already has rules configured: we do not support
-	 * rules migration.
-	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
-
-	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
-			       macsec, &ctx);
-	if (!ops) {
-		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
-
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
 
-	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
-	if (ret)
-		goto rollback;
-
-	rtnl_unlock();
-	return 0;
-
-rollback:
-	macsec->offload = prev_offload;
+	if (macsec->offload != offload)
+		ret = macsec_update_offload(dev, offload);
 out:
 	rtnl_unlock();
 	return ret;
@@ -3817,6 +3812,8 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 			     struct netlink_ext_ack *extack)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
+	bool macsec_offload_state_change = false;
+	enum macsec_offload offload;
 	struct macsec_tx_sc tx_sc;
 	struct macsec_secy secy;
 	int ret;
@@ -3840,8 +3837,18 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		offload = nla_get_u8(data[IFLA_MACSEC_OFFLOAD]);
+		if (macsec->offload != offload) {
+			macsec_offload_state_change = true;
+			ret = macsec_update_offload(dev, offload);
+			if (ret)
+				goto cleanup;
+		}
+	}
+
 	/* If h/w offloading is available, propagate to the device */
-	if (macsec_is_offloaded(macsec)) {
+	if (!macsec_offload_state_change && macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
 
-- 
2.21.3

