Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC06552124
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 17:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiFTPgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 11:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbiFTPgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 11:36:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E58113F5C
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 08:36:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgIRm0DftInhEW91OsWqaA/oX5dmT/7zwe7NzO5THBDtHgtw02UmH+xovDRYxfHfb7k0JkQjkB0jA9xI22aGN0q6yGSudS9m7TG6ppZ6s9io6fXRAYXlyDGdmIwH/o2kXZ/BG7RrN6V9ZlUbNQYr7cnz3ZPI8fwNlCoqn8umGAjhb8E2Tw/y29hXBpe0wVLWe/UeBzE2xiImJQ/+QKzs+QRq+tpA1oEoQqkxF6VlLIytnAIEfmy+nFiVb8TStBQ22IBlKW9Sgl+qzCf497H98Uw6jMSA4Tfz6FSCPeU+Ifs46mZhKBxeNmIMWZmWliRoqrGrojxxTJJNaB7s1BO5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3sKPCqJSZ30rOpFI6Pf+0LrOLkY+QuIjyTtFqn0uH84=;
 b=W/UzD3j/ynDdiL4SlibDIbhCzQW7khJo6U87dZzBKXCT+/aZPXUNJO7BeWMrdPGjMSEHr5lfTb1KRdQrVFQq/kUfwuHLQI7wsGBxofYmLIE69qylO1RuIE1uy+GSdgoN6Qaw3kfnEWvQsecH61VoIR8lkBDrAo0mvv+bEo+VJ34UllOR9R+yie7r6+8wb7M7P0kFID+PIaIxYm2/1KrdKAK/aPDsh1/KqK/VWv6icombeUlJbmYCbUTRS6Zrqc0op9hm1znZdCmM6unkCfgVpEQjo5Beoqare0T8HX2Br7thAmASCdxHiVZHrb3HIcHlTy/rPcvjhJI0FJtKGadz6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3sKPCqJSZ30rOpFI6Pf+0LrOLkY+QuIjyTtFqn0uH84=;
 b=M677BZq54ND7Zt/kh/1Sq7H8xE/fqrczL0sMqgibcHXdzb2lY7W9lpnGGygnqkWsrcgiCJQkNd95IDvHeG3pTtbtyf/wfHj/JXwcMsk2Nu1elA2n2wkUE4j8/edwXkiv3H4fnFXf/jGJVaQEzdQt8XQG27h4nHKgST1PF2gpTg8MqbRUpgRVWRnYTIn5gvEK16ktXwE2H5mHY4wLoiEWUFmQvzkR8XWr8ELo+7eNhOX6e+4P/FlCRBZWFRVROk3vCUV+C3bXdNjoK62AuCinSpmsrXY2OlYKB4FhtRlUHCRWofpQzVc8Qdod+oexEfMq8ScgyZ5b/WlemVFYmDUSWw==
Received: from DM5PR06CA0026.namprd06.prod.outlook.com (2603:10b6:3:5d::12) by
 MN2PR12MB4813.namprd12.prod.outlook.com (2603:10b6:208:1bb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 15:36:15 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:5d:cafe::75) by DM5PR06CA0026.outlook.office365.com
 (2603:10b6:3:5d::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14 via Frontend
 Transport; Mon, 20 Jun 2022 15:36:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 15:36:14 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Mon, 20 Jun 2022 15:36:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 20 Jun 2022 08:36:13 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Mon, 20 Jun 2022 08:36:11 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 1/5] uapi: devlink.h DEVLINK_ATTR_RATE_LIMIT_TYPE
Date:   Mon, 20 Jun 2022 18:35:51 +0300
Message-ID: <20220620153555.2504178-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78db0ddc-572d-4504-dad2-08da52d29c87
X-MS-TrafficTypeDiagnostic: MN2PR12MB4813:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB48134F313949EB0E5F7929AFD5B09@MN2PR12MB4813.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XlkZ1/V02Dh4fSm8bZJ5RZTLe1y/5SjUZImanTdXxfnMqBf/JXqMGIeqt/VQzz9YBf968m7rAFYBOed/G+OeECGOx0LwsOiVJ8FwN86Gx3kcB2G0o3w1HW5HqKFgSRKYokHOnlJ2Mgo1R3VI+/xjygH54UNjF3FzeLs0joXJaSWcbVIlfuLRfA+vDTZvdk7+YjvZZY317WXgQ4+u2dw5zAsJTiCE9v7bw2aqChPtaeDzE9xsv/rnmXxgh+ZNhG7JMZfZCy4fUPdFDMt6kL5+25wib+3y21YeWuOMbAvrz0lSMZka+95Vejasx5IJOSHHnjmzTcbnsxijzCYAAXPdQUPOS4sUtlR5QsrnDBhgPoAzI4Aif0B2plXoH5FVfsWmy0srPu53RCK/1wnXRj1rH7SLi8FZpGRcqa3YVuL5OqQrCOhmS4Fna3CxUDlVc4rSm1lZAzlsNvcjMgBj0o/oI7kAsrDVptgGXVxzs0VNgXeDLQVvEjE5GjvTB9mxpE1O9FclNE4/Zy07Y8MKT4VVh5bTsL2tJZTE9OtlBoze/ImRpsbwGBLRQA1Qw616Ja6vNhIFa+rnR7Nxrmker2CpbuhVuvidm7Tjmmp1hYZdKvvX+xlJTd/wPItW8/EWXQ+kEVk4vM8wGnSILuycwtcc6vpI/FdvUppvHitNMXTgP0c5sYx+CgSx1bqtl7WbVr0DAHSiHUDtEKUopBl2d2WPzbfboctwl9yDyB5zs6Zkc5oLUd9N9b6KDcWKWO4ExLOb
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(40470700004)(46966006)(70586007)(70206006)(54906003)(478600001)(316002)(4744005)(2906002)(110136005)(8676002)(26005)(36756003)(86362001)(4326008)(107886003)(8936002)(41300700001)(2616005)(81166007)(40460700003)(336012)(5660300002)(82310400005)(83380400001)(426003)(82740400003)(7696005)(1076003)(6666004)(40480700001)(356005)(36860700001)(186003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 15:36:14.8011
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 78db0ddc-572d-4504-dad2-08da52d29c87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4813
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
---
 include/uapi/linux/devlink.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index da0f1ba8f7a0..4b2653b1c11c 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -221,6 +221,11 @@ enum devlink_rate_type {
 	DEVLINK_RATE_TYPE_NODE,
 };
 
+enum devlink_rate_limit_type {
+	DEVLINK_RATE_LIMIT_TYPE_UNSET,
+	DEVLINK_RATE_LIMIT_TYPE_SHAPING,
+};
+
 enum devlink_param_cmode {
 	DEVLINK_PARAM_CMODE_RUNTIME,
 	DEVLINK_PARAM_CMODE_DRIVERINIT,
@@ -576,6 +581,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
 	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
 
+	DEVLINK_ATTR_RATE_LIMIT_TYPE,		/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.36.1

