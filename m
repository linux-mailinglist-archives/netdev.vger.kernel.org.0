Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF0C646F1F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 12:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLHL4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 06:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiLHLzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 06:55:43 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86456880E1;
        Thu,  8 Dec 2022 03:55:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ey30akczinEAGQrxcHPTX6uL1XoM5VAUtmnfciyGIN28OTAjoABfXW6qlaEdSd9dJSwr3rc+8V+wbkrEf0WAXA4zs2W0ZxnqWIjUTKipCgJw5QtzyJCXGPzDlHLxrL19r8mIeeocwCvRoGhmtqjioQaoVLBzaa2PF2gUpRQXsI4QOYbfW6+omUETvy//npBRMmDFRAMpku6kv0nVzS33l2Af8tVrLV1L93amrijPHb2+QI+MgavdFHKUtFLxUQe7dmiwaW6NBA5q3hAqnZEsKhS9fB+ew2Jl1j5a0dRBXK+PYoz6z+bON+BwcrJIB21FVMR/T7bFc0qQC7G/V/1bqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4al1wQPMFFB+voxMfm94AVtyaEUR/eqIx4z821iB814=;
 b=cdmpav6duttG7f304TK9hmeyV/Xw6hwZVfFQzXRQgo7kiCz7vMECc+Ww5kyHxCZe4F5oMkM2z9tM1DdMU4ACiwMpQ73gF/sfvbR2SQszkbhYwt0xjTS41L9GnE5MCdQLl7eSsbWgznBxq1gr2AGNOdThOZ7/rmQ9S8bm44EzMKHSPUttzUM58n03QWWJorQMufHjP0wCeFwGhd+Jt6XYP4TzCpwKJ4HNUIs3g9F61FaViqQnr2zoT22KvVQwlavd9E+2a2UcGSGdsMD4iUednSDjIN1DX8O8z6LVh+uss4KH7holO5A4XArfK7b3Bevr7CnPfAsRQUDKYBMMOYVj9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4al1wQPMFFB+voxMfm94AVtyaEUR/eqIx4z821iB814=;
 b=OaK2wV8RZTOAfY0y5oVzcJlYSHr83osa01xgI2j/yXvSqySWH7/XiXxoQboxfyy2dyCjg72m4+2bIJ76UlZPAD2X5wPvKbnomJoqnhifCxSvT9Tlt8aC7hrht3C+BHN0Xoi1LhmS2sixJNbamZ6NvvZ+/GRHOX2cDTcnSU/w3AMpojzyiSqrIWkDTdOLX5OzVyhaQLhnJGsAJQGKOzeEs1KeoI+QVr4nCzzznIeFzdcpImtkA2HXL2HwHRYb7YIS2FXLaCEc9Mey2oEbsrGW7xTwGwf5lRSHTobfp1KnrF2JrNnMBM/bhucTbbfAhbOPnRXJDtviSLDJdEpAJ3yWFw==
Received: from BL0PR1501CA0012.namprd15.prod.outlook.com
 (2603:10b6:207:17::25) by DM6PR12MB4404.namprd12.prod.outlook.com
 (2603:10b6:5:2a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 11:55:40 +0000
Received: from BL02EPF0000C409.namprd05.prod.outlook.com
 (2603:10b6:207:17:cafe::15) by BL0PR1501CA0012.outlook.office365.com
 (2603:10b6:207:17::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Thu, 8 Dec 2022 11:55:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0000C409.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Thu, 8 Dec 2022 11:55:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 03:55:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 8 Dec 2022
 03:55:27 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 8 Dec
 2022 03:55:24 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v4 1/2] macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
Date:   Thu, 8 Dec 2022 13:55:16 +0200
Message-ID: <20221208115517.14951-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C409:EE_|DM6PR12MB4404:EE_
X-MS-Office365-Filtering-Correlation-Id: 56122c5a-c36d-4b72-d846-08dad91320d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xRK4HBLNC8zakedO5geCfEUdu/MHu6Ho8YfNA+nuQTIWoKEt9hIjs2wE/pG6euHL4rgMAyuSvOMK97nCXWm8zS6aRSRnT9HNs2eOM9gRHZR5VqA/vm5LJxzXc/mzMxIlQiyj9XlI1UlWBOZKTYozEYt3uxlFWCo3NxWopnYXb/M7WKLaAixhw1EzCGEUbVYtluvw1bBi7pAyGcLjOU+Gboc+cOlQs20qoslpBGN3HFKyC+BmdPNHmHJYNZ/QX6OavaA4efq9TKNnU9awhrnNLl64S8KrrExiY7SZeQCFECpsriBklyvDMDrG0aMkkoEfnewcysytFvRhGq2H/6WCQRkRb0qlsx6FZkFXfUtfuKz/BsMoF7I7IY9I7E4j5/AEVUK93QVGdutMFnJOmbE2fBTkTJXNKNjPHOXkFOInwNQk+b/HcAvkEVI1KQe7ic/jA+q0VpaJTcqRap9mfBiVejvNMeTDd5fMgSvOBmFIP8NCNyrt7RJAiLVeTpXM60OWpR8RV1ugJdK1tomPouwo3aPEZ8i7KlAj5JkuK4iUByk6bmM9Q4MvqthFLrxucyREQ1+zm3E4qryty+UF1RBc9M4gypW8PXaXt/TvilaGqzm8Df3EjWNgr/k01cdGZEG1kSqyoRrHJSFDA3pw8Xb2+j1MP/bem6opGL4FdC8vV6yAb8ltCrSulbEA9LE1Za4PE0oV0rSVKmSwIs3abzguJg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199015)(40470700004)(46966006)(36840700001)(316002)(82740400003)(36860700001)(36756003)(4326008)(8936002)(70206006)(70586007)(186003)(26005)(47076005)(426003)(8676002)(40460700003)(54906003)(6916009)(1076003)(7696005)(40480700001)(5660300002)(83380400001)(82310400005)(2616005)(86362001)(336012)(356005)(2906002)(7636003)(41300700001)(107886003)(2876002)(478600001)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 11:55:40.2715
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56122c5a-c36d-4b72-d846-08dad91320d6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C409.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4404
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

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V3 -> V4: - Dont pass whole attributes data to macsec_update_offload, just pass relevant attribute.
		  - Fix code style.
		  - Remove macsec_changelink_upd_offload
V2 -> V3: - Split the original patch into 3 patches, the macsec_rtnl_policy related change (separate patch)
                       to be sent to "net" branch as a fix.
                 - Change the original patch title to make it clear that it's only adding IFLA_MACSEC_OFFLOAD
                   to changelink
V1 -> V2: Add common helper to avoid duplicating code

 drivers/net/macsec.c | 100 +++++++++++++++++++++++--------------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d73b9d535b7a..abfe4a612a2d 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2583,38 +2583,16 @@ static bool macsec_is_configured(struct macsec_dev *macsec)
 	return false;
 }
 
-static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+static int macsec_update_offload(struct net_device *dev, enum macsec_offload offload)
 {
-	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
-	enum macsec_offload offload, prev_offload;
-	int (*func)(struct macsec_context *ctx);
-	struct nlattr **attrs = info->attrs;
-	struct net_device *dev;
+	enum macsec_offload prev_offload;
 	const struct macsec_ops *ops;
 	struct macsec_context ctx;
 	struct macsec_dev *macsec;
-	int ret;
-
-	if (!attrs[MACSEC_ATTR_IFINDEX])
-		return -EINVAL;
-
-	if (!attrs[MACSEC_ATTR_OFFLOAD])
-		return -EINVAL;
-
-	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
-					attrs[MACSEC_ATTR_OFFLOAD],
-					macsec_genl_offload_policy, NULL))
-		return -EINVAL;
+	int ret = 0;
 
-	dev = get_dev_from_nl(genl_info_net(info), attrs);
-	if (IS_ERR(dev))
-		return PTR_ERR(dev);
 	macsec = macsec_priv(dev);
 
-	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
-		return -EINVAL;
-
-	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
 	if (macsec->offload == offload)
 		return 0;
 
@@ -2627,43 +2605,65 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (netif_running(dev))
 		return -EBUSY;
 
-	rtnl_lock();
-
-	prev_offload = macsec->offload;
-	macsec->offload = offload;
-
 	/* Check if the device already has rules configured: we do not support
 	 * rules migration.
 	 */
-	if (macsec_is_configured(macsec)) {
-		ret = -EBUSY;
-		goto rollback;
-	}
+	if (macsec_is_configured(macsec))
+		return -EBUSY;
+
+	prev_offload = macsec->offload;
 
 	ops = __macsec_get_ops(offload == MACSEC_OFFLOAD_OFF ? prev_offload : offload,
 			       macsec, &ctx);
-	if (!ops) {
+	if (!ops)
 		ret = -EOPNOTSUPP;
-		goto rollback;
-	}
 
-	if (prev_offload == MACSEC_OFFLOAD_OFF)
-		func = ops->mdo_add_secy;
-	else
-		func = ops->mdo_del_secy;
+	macsec->offload = offload;
 
 	ctx.secy = &macsec->secy;
-	ret = macsec_offload(func, &ctx);
+	ret = offload == MACSEC_OFFLOAD_OFF ? macsec_offload(ops->mdo_del_secy, &ctx)
+					    : macsec_offload(ops->mdo_add_secy, &ctx);
+
 	if (ret)
-		goto rollback;
+		macsec->offload = prev_offload;
 
-	rtnl_unlock();
-	return 0;
+	return ret;
+}
+
+static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
+{
+	struct nlattr *tb_offload[MACSEC_OFFLOAD_ATTR_MAX + 1];
+	struct nlattr **attrs = info->attrs;
+	enum macsec_offload offload;
+	struct net_device *dev;
+	int ret;
+
+	if (!attrs[MACSEC_ATTR_IFINDEX])
+		return -EINVAL;
+
+	if (!attrs[MACSEC_ATTR_OFFLOAD])
+		return -EINVAL;
+
+	if (nla_parse_nested_deprecated(tb_offload, MACSEC_OFFLOAD_ATTR_MAX,
+					attrs[MACSEC_ATTR_OFFLOAD],
+					macsec_genl_offload_policy, NULL))
+		return -EINVAL;
+
+	dev = get_dev_from_nl(genl_info_net(info), attrs);
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
-rollback:
-	macsec->offload = prev_offload;
+	if (!tb_offload[MACSEC_OFFLOAD_ATTR_TYPE])
+		return -EINVAL;
+
+	offload = nla_get_u8(tb_offload[MACSEC_OFFLOAD_ATTR_TYPE]);
+
+	rtnl_lock();
+
+	ret = macsec_update_offload(dev, offload);
 
 	rtnl_unlock();
+
 	return ret;
 }
 
@@ -3831,6 +3831,12 @@ static int macsec_changelink(struct net_device *dev, struct nlattr *tb[],
 	if (ret)
 		goto cleanup;
 
+	if (data[IFLA_MACSEC_OFFLOAD]) {
+		ret = macsec_update_offload(dev, nla_get_u8(data[IFLA_MACSEC_OFFLOAD]));
+		if (ret)
+			goto cleanup;
+	}
+
 	/* If h/w offloading is available, propagate to the device */
 	if (macsec_is_offloaded(macsec)) {
 		const struct macsec_ops *ops;
-- 
2.21.3

