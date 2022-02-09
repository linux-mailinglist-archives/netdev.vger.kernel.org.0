Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB44AF444
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 15:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbiBIOl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 09:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiBIOlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 09:41:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3AAC06157B
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 06:41:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaNSVSdZjq/gaNo97H/NaazzrmU8LxX5I7IgAWS2rGf2PxsAKvmZqtZ/TMMi6SHzwO0M3aa+sdbOjcesSfyJUgFeHCjUFiXI9U2r6db+Wi6lN2A1hpKIM1cR+CIOuHdYxFxA4LNCCRVkqlEcKfWVSUiq/oMErEEwTe9cdW81+FmDhopw/LxPGTID5WTOEM7Zk+lst3Xtc+hjhkqh9K2CrTWzsRU8fCNLcdhHh1noEnCm/im1RWXqIk9nXLFv7ktHKcwB1CPadxRwNi6MFm0sE6nF711g1z643kq0MxCT4Z2LCOw9wc506BvbrO6b7Ewnke9wFQoLpEz97TRcYbdBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOfjlnvB7Jf8VFf9SFDvQHi9rhC/0nWrS87tnn6hyes=;
 b=KvpdqEeES15YPyWod3zj1bSCKe7KQTFHvTdMGdTalMyZ2FbCILvT+Bvq08Ql1Dz0m4Z97F59aD0/Waztd1Ab+6SiIO4ImVwFzN8bLSgsw9KgQvhQJ3IaxKQdHWx1/166wBvN3cfY0CNaNosDJM8fL84yeaG55SERNWbzzLlEtmtHPCoGVZ7CZ+kUVO+seOmE9eIz+W6HCXPlfamKLxA2s7YAO5/Y4l4fQh1xWuNcKidaR6iR24Mf3n8DzixFU6nqDPwPGv9gLM9TfXvol4wmkdgtUji9zmDvCYMZefVs7xpKNFHOXncwiwmefnBej1jpiQJO0P2Kz+daZX35Bpsv1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOfjlnvB7Jf8VFf9SFDvQHi9rhC/0nWrS87tnn6hyes=;
 b=jPTtei2sLYgeyDrsA1mKl1V8VAB91a9K9NefLH5aG5zLd3DZsn7DyXJiMdP1/SnWp5C0p54/yppfH+fIKTtzBEuyNDhoDD1YdvqlL+GCJf7KczVP7iGgHyAOWjdUZaL1NUvCyOZquz7myQvMQHit4LOBtVHsdlW5GYhs4iEneOoArDmLZ4XSv37VKqLiMDNcEcs8mGhGxnUF8qTNSV0LV2bTY5FNlI03RC6bm42vUA7mmwaJsqQG0j8DuC+JYIXrqySdC3+/Q+puDb94CU3nthESq69oqS1rn6BcC0OaiPY2eHWejbpEHYSRl32J25875egtGaIySsRLw330W0nX6g==
Received: from BN9PR03CA0631.namprd03.prod.outlook.com (2603:10b6:408:13b::6)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Wed, 9 Feb
 2022 14:41:57 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::f9) by BN9PR03CA0631.outlook.office365.com
 (2603:10b6:408:13b::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 9 Feb 2022 14:41:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 14:41:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 9 Feb
 2022 14:41:55 +0000
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Wed, 9 Feb 2022 06:41:54 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Maksym Yaremchuk <maksymy@nvidia.com>
Subject: [PATCH iproute2] dcb: Fix error reporting when accessing "dcb app"
Date:   Wed, 9 Feb 2022 15:41:40 +0100
Message-ID: <df581d8de2491fac4bffa732e9f1c5923ef1bf4a.1644417638.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84c167fa-d588-49b3-b025-08d9ebda5277
X-MS-TrafficTypeDiagnostic: DM4PR12MB5748:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5748F29956A2E597EF983C40D62E9@DM4PR12MB5748.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pv32ghej9Ml5uWE7F9FaAKuiMK3Ulieoy4YVNUA2IiJkI2UIBj9EBrbVip1nqjgWy4X06qREbGgpHe+lFBEcmY2nGZ40ARU2RyuqeXupLZKEpVZKqQ7/VkSylYAlddKpzaSaF9lKt7fmriz7YuUEMMYq02Ij7u+JmKxotuw1tCfR9BHXuIxDEaC++dUhx6hbPU04Ym0fZ4ygDxCbn6YPcMbcBtfX8NXtNtOwmqKL58wBc/ogIHLDeM7YIP9lnePpxEZtjQKYh3u5Jygo+6UQcJaJRTpyRPcTkm2QGubInrlCT00PhnlhTkIejdlnlU2/F50u49/2fYqJ+4/0+8pR016ADJNh606cP7QLFK76agpS39E2nGxoQiDYYpFubZv/gM0I4AoZQGKi2YL8ONfXPTqQBGKn4PNdlg5xLa9fdDVXOvICsZwyz+/Xgce3d24JGpM5m/qfdEFrsjNlWWK8GTlRHA2uyXw3NcR6uGXmexPZGMZg9YQuS7xdIzsXSgscuMWVHgl9LKSx5+lWCJ2MJQjmv7JmT3m0qbDmb/0gtuZUZ0PdBRW1EMt2sxa8l49jDPsSjl9VIun/ILHHiutqyFIBakl4liNeyjrjvAre8jcVeYnzJxpYI9ScTk7NGbtX9h2euRGP16xOD3aoUI9gCCp4VrVIc3boZUFMSrtVHefkduGEVVnI7r4GagmziDgRyFBGCBxeODCFBxJ45JSmMw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(2906002)(6666004)(8676002)(47076005)(316002)(26005)(426003)(81166007)(336012)(186003)(83380400001)(54906003)(508600001)(6916009)(36756003)(70206006)(7696005)(5660300002)(2616005)(40460700003)(70586007)(86362001)(36860700001)(16526019)(107886003)(82310400004)(356005)(4326008)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 14:41:56.6890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84c167fa-d588-49b3-b025-08d9ebda5277
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently dcb decodes the response from "dcb app add" and "del" by
interpreting the returned attribute as u8. But the value stored there is
actually a negative errno value.

Additionally, "dcb app" currently shows two sets of messages, one in
dcb_set_attribute_attr_cb() where the issue is detected, and another as a
result of error return from that function.

The current state is as follows:

	# dcb app add dev swp36 dscp-prio 20:2
	Error when attempting to set attribute: Unknown error 239
	Attribute write: No such file or directory

Fix the "unknown error" issue by correctly decoding the attribute as i8 and
negating it. Furthermore, set errno to that value, and let the top-level
"attribute write" error message show the correct message.

Initialize errno to 0 before the dcb_talk() dispatch, and make the error
print conditional on errno != 0. This way the few error messages that are
worth describing in the place where they are detected will not cause the
second error message to be printed.

The fixed reporting looks like this:

	# dcb app add dev swp36 dscp-prio 20:2
	Attribute write: File exists

Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 dcb/dcb.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/dcb/dcb.c b/dcb/dcb.c
index b7c2df54..8d75ab0a 100644
--- a/dcb/dcb.c
+++ b/dcb/dcb.c
@@ -106,7 +106,7 @@ static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
 {
 	struct dcb_set_attribute_response *resp = data;
 	uint16_t len;
-	uint8_t err;
+	int8_t err;
 
 	if (mnl_attr_get_type(attr) != resp->response_attr)
 		return MNL_CB_OK;
@@ -117,10 +117,12 @@ static int dcb_set_attribute_attr_cb(const struct nlattr *attr, void *data)
 		return MNL_CB_ERROR;
 	}
 
+	/* The attribute is formally u8, but actually an i8 containing a
+	 * negative errno value.
+	 */
 	err = mnl_attr_get_u8(attr);
 	if (err) {
-		fprintf(stderr, "Error when attempting to set attribute: %s\n",
-			strerror(err));
+		errno = -err;
 		return MNL_CB_ERROR;
 	}
 
@@ -242,9 +244,11 @@ static int __dcb_set_attribute(struct dcb *dcb, int command, const char *dev,
 	if (ret)
 		return ret;
 
+	errno = 0;
 	ret = dcb_talk(dcb, nlh, dcb_set_attribute_cb, &resp);
 	if (ret) {
-		perror("Attribute write");
+		if (errno)
+			perror("Attribute write");
 		return ret;
 	}
 	return 0;
-- 
2.31.1

