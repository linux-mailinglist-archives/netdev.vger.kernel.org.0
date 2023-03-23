Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D1C6C6646
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbjCWLOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCWLOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:14:03 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32367234D1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:13:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FugjTwJ7Ct0yCgptaafWHIy4x2ClTaRp2Kbf5to5ewVlFAiGWwLC0Fm480nL9vn8CnEwCjIACDRXPv0WUPKbUbckrfq3E3I9uTbnxhkckvQU2pkSAM77l60ORRVfyj6EmrsmrL7xuC5qXVj1ZEQoVJW/i08vca+Vet+SOwTe+e0r1K0J05n0RC676SUpyokcL9r2XWNJEJjpApp2e93kt+U46K1CYQTQRxQS15wehpkCvDWzwx0jxNF24LQLbhRSTYupufWWCpCusko7/2I5JKZiymKJCduIknHdQpV8kS/llGwVdtJWNcMIMnQauUy+mpgUCKvYgm0Iz7zl+y1TYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXfvzqLxE+u7HZ/Ro5f2w0EyE07HJaQYn4HWk07YFwA=;
 b=VQOhPXlNS3/g+jJ0MRrYo2mO63kTFlFf0MnaHAtUt/sDpjC44Mt3vYp/+OdSxjzOoLdeH2vkBTqUr/lPw1dpcvhxw1YnHxV/+Ns7oHqT+Hx/mmZlJzYy9V/6OkyWsRFqxEVjaI/dk+B2yOpdPzKOhSMlbIyn2ORhvQ/KJvMpnknj+/Hsw3FtAxZnmi6zNwX6fr3JAs588lxTLKsvabdgyA4idLwYkMGCRPWhFvcCmsa/rXcD+LQWFwISt5AJPaxAZ5PVDrVBc2kNWf6MeD0kGh6OseBf/BXuytdKDvb7BQXWCkaycocGVdQkewPel31k1r5WgrWIukhK1zfwoSBDag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXfvzqLxE+u7HZ/Ro5f2w0EyE07HJaQYn4HWk07YFwA=;
 b=IXDFVDZxwozanhBiZ5nCvB0xjTDsXWNnnklH0rn5jXhDMqbWJKbEFH+G3NbG+PB4TPtD5iM47wU6qNZmwduQ1/0YT1ZhVYx1GpaP0zYuVUQTPv/tAhRsJ4rbiWI7o8x4AX5gktJXeH+gZ/Yd03dW7zzX9p686u0p1PRYgbcY0ZRJVl8deOvpiPM56LMwYjOuuykBOCoZOYYwRDWeYlHaYN+Sx9wHWXXo4edNPuTPiAYvzG0iMMeO0LV38D1JHenf/Wy/FOe5QVJdh1lYZvYGvkoP091tg6OvMkOVUTugP7dfBe/BdQkMM8hDEpEzw1/wKbvsXnFot3WBgYnNoMZuAQ==
Received: from MW4PR03CA0351.namprd03.prod.outlook.com (2603:10b6:303:dc::26)
 by MN0PR12MB6272.namprd12.prod.outlook.com (2603:10b6:208:3c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 11:13:37 +0000
Received: from CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::54) by MW4PR03CA0351.outlook.office365.com
 (2603:10b6:303:dc::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Thu, 23 Mar 2023 11:13:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT016.mail.protection.outlook.com (10.13.175.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.17 via Frontend Transport; Thu, 23 Mar 2023 11:13:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:13:34 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Thu, 23 Mar 2023 04:13:33 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.5 via Frontend
 Transport; Thu, 23 Mar 2023 04:13:31 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Jiri Pirko" <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next 1/3] Update kernel headers
Date:   Thu, 23 Mar 2023 13:13:11 +0200
Message-ID: <20230323111313.211866-1-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT016:EE_|MN0PR12MB6272:EE_
X-MS-Office365-Filtering-Correlation-Id: b794e64f-ed3f-40bf-d27d-08db2b8fa61d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKlaFv9J1jE0mFBvB3zLab6v8hc+72lKpzjhJRAZF1OEf6Sayx7/ipKNIiJdOtDdTjXRUZmDqvXRR90gqFPNvYUE7rnA994PQJnHAenrIPlzptXGrpDMDPGyBYPXEJoOCzVTw+gZKD9BIeMb74z8glpq490HiuTYKV6GE5Jp7xy3dtC+iUNE/oxewfed+pmq63SARw3S4/1/IErw2FB1Jym0n8fMeOkrx87edqBnDvnEd1ccFFv1ujHA8V1+XqIqP3tghb7E6qNRG2BiGCpjc2ON0ylV6ILe2/PilT0R7Fcg8Rs+efckHLqnvUdpUMFQ+qT8m62mFGmpfklyhyIFwahmNldwoJkk5sFOha7W40z23sjHbko8/5awQ8SMgBWyTtAVByCgiQl8zWMEOQa0ZaKLPKoM73x+CGcrtlKhKpr5bfdXDohKCpor4B2ij/zAxRpalrymdNTqB9YwCeDmIjvFDxNAdRoAzJCD1g0WkxrU6RDH26Dq6UAwrUzCFi7gtQgT0Fg+Pd81S+fgBTFK7SAjh4ksTEQtlKQqVmSJ25feTlZ1e24g9hgGw6J6WSjIW7I8WnvgN+MUB6rmwoaXPrgnf7vBgWA3maUuXm4QeRQKkQLAXCevekfUWLaDPeOM4hyyeqxrQ0HGlhgsM8N/KPpSMfSR2NEZ+35MbgzwqIH/g1AuHg9VdApQvII2utDV3gKH8CjFflU+Za7UGTcwJlpqOJGIxVenvMlF4rN0cc/zAd8V7f+jnNki2DJFYvxk
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(5660300002)(8936002)(41300700001)(36860700001)(4326008)(54906003)(86362001)(82310400005)(40480700001)(356005)(36756003)(40460700003)(82740400003)(7636003)(2906002)(107886003)(478600001)(336012)(426003)(6666004)(186003)(7696005)(2616005)(47076005)(26005)(316002)(1076003)(110136005)(70206006)(8676002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:13:36.9409
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b794e64f-ed3f-40bf-d27d-08db2b8fa61d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT016.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6272
X-Spam-Status: No, score=0.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/linux/devlink.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 45d110254e96..8b9b98e75059 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -661,6 +661,8 @@ enum devlink_resource_unit {
 enum devlink_port_fn_attr_cap {
 	DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT,
 	DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT,
+	DEVLINK_PORT_FN_ATTR_CAP_IPSEC_PACKET_BIT,
 
 	/* Add new caps above */
 	__DEVLINK_PORT_FN_ATTR_CAPS_MAX,
@@ -669,6 +671,8 @@ enum devlink_port_fn_attr_cap {
 #define DEVLINK_PORT_FN_CAP_ROCE _BITUL(DEVLINK_PORT_FN_ATTR_CAP_ROCE_BIT)
 #define DEVLINK_PORT_FN_CAP_MIGRATABLE \
 	_BITUL(DEVLINK_PORT_FN_ATTR_CAP_MIGRATABLE_BIT)
+#define DEVLINK_PORT_FN_CAP_IPSEC_CRYPTO _BITUL(DEVLINK_PORT_FN_ATTR_CAP_IPSEC_CRYPTO_BIT)
+#define DEVLINK_PORT_FN_CAP_IPSEC_PACKET _BITUL(DEVLINK_PORT_FN_ATTR_CAP_IPSEC_PACKET_BIT)
 
 enum devlink_port_function_attr {
 	DEVLINK_PORT_FUNCTION_ATTR_UNSPEC,
-- 
2.40.0

