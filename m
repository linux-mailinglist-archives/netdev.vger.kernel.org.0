Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A19E6EACD0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbjDUO0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjDUO0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:26:00 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F2E5125B2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 07:25:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fFBxbdz8KxLxD580fidgS1Bm7xFPU4R4rTIRyG6TNksdc4TimqwQWxpgGIYweJouixJ7m34I+lS674kOJhDOkQ7B3r+IItoJWvKWHzaFlPg8qcebtTzvk1+DoHgHemGhUVUqTlw6exxGWFuhPkoc7Edx4G+F2PyIFaJ7iLcGvFl6whzVnuRKG07orOFD9/i9ry3WBzPaKg5XVkXWSumaV+3bKxgo0dGUnXX53R2OOpeZXOO7Gmi+2XVSOOvs8717LanTOT831jbB4yjqWqiaBMvKdME8U/kcqRTzrrtPJMwooW2sIcRf60nOfBuy6SOBB4yMzQ2jRVFfVNkQZtAfFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXfvzqLxE+u7HZ/Ro5f2w0EyE07HJaQYn4HWk07YFwA=;
 b=GSivX2DQAOgE1pMFxsTKl1zSD9Mc1id6RyfvegX6RFqiQBSJCoUe1aARJAianfw0UkmBLNtbAXHJCuILvaY6WihVBrEJPqt6MOBVazo0VJ+ZptwEjhm0oJJNz74cq5l0ftHrIuXg1cNiuPRLKLGEfgt9iLf9dehaQY8IUHw8/Mzcf4hXWTGgyQn6/VqAI7XdyIF4wo91KH1mbJdJTrirSEXg2rW+KNP4XXSig/fh0qMRv0h86qMv4/9zTRgqture+/lznwtaZDgfbPd3McG5LEiJE/y4/snWxr+AJ0olvGJUam1fh9xJw6Uc7zP3CBJrRm46XM0pvZ4n4mY+DtHV0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=networkplumber.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oXfvzqLxE+u7HZ/Ro5f2w0EyE07HJaQYn4HWk07YFwA=;
 b=ruepVNl0dnBX4doy9Xh69cLTIclQhxTxncSQtVzBnA2HcW4WxcilIb1yhJf2pUVxWxIcookWWhqfXHQhcRkXuxr5LYLb6bUpgec0Nq4TKJPrIgtECQ7OgHbQS4rzokBN6Tizdo/Q2wPYgehTQdpZhFqaAIiC38W57di95tbeCPUKzeMCYCNnmWeGa/XwRK3O/1db0gr0myxigNcTAu+LAp0NHIvWnhZK1aflHInwTLCf2G2xFer752OuwdJS9pftgmQhfXLD0q1VwK3Gr0FzDk06mxpdyQkEhelKhF/TfJvdiRW1L1dZYoJkVc3QvVpMAUKZdN/ohMdLGvHSvt4zOA==
Received: from BN0PR08CA0010.namprd08.prod.outlook.com (2603:10b6:408:142::11)
 by PH7PR12MB6586.namprd12.prod.outlook.com (2603:10b6:510:212::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 14:25:55 +0000
Received: from BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::92) by BN0PR08CA0010.outlook.office365.com
 (2603:10b6:408:142::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Fri, 21 Apr 2023 14:25:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT070.mail.protection.outlook.com (10.13.177.50) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.26 via Frontend Transport; Fri, 21 Apr 2023 14:25:54 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 07:25:47 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 07:25:46 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 07:25:44 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH iproute2-next V2 1/3] Update kernel headers
Date:   Fri, 21 Apr 2023 17:25:04 +0300
Message-ID: <20230421142506.1063114-2-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421142506.1063114-1-dchumak@nvidia.com>
References: <20230421142506.1063114-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT070:EE_|PH7PR12MB6586:EE_
X-MS-Office365-Filtering-Correlation-Id: 8332340e-0c7f-489e-6323-08db42745141
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h7UiXL2pMTjrmEWUzjh0je1g3MPWteitN+XLhMncSgxbgw+n8iX3l1vZ458xQocuqYJ4NiKi2lt6Xk60T+6sKhDuUB0gMqx7IF4LdOxKT75JP4GUbn3xwCTodgC76vBCmufpCcaU5BWiLvEHoJYRAF3Q+KAvLJCyWstTX4ymlsi2FK/OMKdNO/WYSy1A6dHwxMiAJDY8aq1rmkL3suhNB7EbzDr2zftCjB0TyqcCni0230Hxngz5Hfr+e25XT13/AV6whP9J8u6LCEzTvnoG4WcReuuaaKq7Ddnzk26p+3xW5mIZKX476dpsHQlck3vu7cvDyKfk/gW7JC6t2fugANq2Eq3iOFGLsyTt6Q1KhU9ax8aIa3aEcp/BXGV1oTJCyOpBaCFxWMJ1CWOBLZH0QboVqOboTtvd7+9qgE+5SRBCvKKPo9Srsa4SOHL8Iu6IOb0sBxUKLEzZ+//XtKK8ONHg2F0mjbEV+BfjJIbznUgQ4wIjeNe7VTMvpUM4yAeGCMEa47eynoYhhRAYEs3fV4jONwap0CZSBmtt6ogO+zP+qjLIaGTd20tub84dhA9UdP3DjwTA8Xtf5atUKQvcQnqZKR0BlQD5a370nUoolaDf/GoP6ZYuL+wzolaLVNLRaFhE7JpPVhba2pjwhzA14wy3110Xk2Otnk+U4D228Hr3oAYUdtufRJaZw6xOLrENDEMsQy/rrfoFQAtWU0TsS7bQnyecezPsSap1iRC6DVZgv77ruZU2mSsem0XvD+mOeeyyv71o6YfVuOtPideBvKt5P9fP+hT3vOVjHO2Jhys=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199021)(46966006)(36840700001)(40470700004)(54906003)(34020700004)(47076005)(36860700001)(2616005)(478600001)(26005)(1076003)(7696005)(107886003)(6666004)(82740400003)(316002)(4326008)(110136005)(186003)(426003)(336012)(70206006)(70586007)(41300700001)(82310400005)(8676002)(8936002)(356005)(7636003)(5660300002)(36756003)(2906002)(40460700003)(40480700001)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 14:25:54.7905
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8332340e-0c7f-489e-6323-08db42745141
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT070.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6586
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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

