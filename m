Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A00644C06
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLFSvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiLFSvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:51:51 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15ED3B9C1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:51:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AiEQU2alY19jukEl6HTi6wxvf9G0fyO8mUvvl+HKkD86gzJL0SsEmGRyLbQAwxIQ1xyaaRlhioupEc2bNITqml1P6vWxGSsdXB76A5bIPEGYsIXLnnHkjbPpUhSwUgpTDO91XZAZ3wbnNYqOfUcT+UczjSoWadWQnBmd5RcBEG81DbHLld/u0gw/Svg3D2iqxwSZ58rLqhR+06YFExPlrNcRmmoWb+OyRRWKDYAS/sooVy9IMMSFD5EDh9uRVEN/xOpmZFLwEYhaC/y4gmiijVTjsvE12tOcETc3Lsx66oKWd/pb8FwPqF6t64HQXWQkA7bAKMeFpSy3d3EnM5nuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEk75armTjQMXhv/3iXutSaYHINTuBgEa3LZ8ajTnKk=;
 b=iUi44nBdXfY1t2z1Tpl4UdtKeYLdQhw7dqNa6W7nhujqyrwJIEkEQB8C7XwHAllrdMmJEeKwSop/4POyw3gQV5ISG8VQIbGHrdpixOGpsPN56ayxFNdqkzBPpeX9Jg2fxQMwpcOOVmoh3dKI9cMRTZqvD6H1JMf+EB5WUrWyyDfe+qRBis8TV85GA+JUi/On1aDm4Lnjsee3QpjSHT9zYkm0bOOv7v5Sbx6YY1P9UqZHzI4vbfcJYqy8Nw5y3uFEHkmETYPGRHq+vNHD/XctYDTC7+0imM6On2MDJggTrkHRnpSWPwK/YP3uumd+RqRDOM+cxE+6pAfTHGIj5YKkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEk75armTjQMXhv/3iXutSaYHINTuBgEa3LZ8ajTnKk=;
 b=rX1/pVFqFyjQCEQGy2gGtE9YPKJUt816NXE8D8o72lTlvjDrnTSooqJQESn66rGlgirJqV+iqa2asxNXy6rghnLDFqFoCTefiarjO0sqU0Y/Oq4gyWdMfDrrjaiQcxnpk/vdFtKKm9W1ZOO0iE84ecElye+0sAnyak0rReEC9na1N9+VOaecYhP6Sbe+er0YaRg2+gwWfV2gsjwCR/dd37zco0Pu2sMCKd3nqWcDg+gHbkxu5dxIwdjt78OdPGWGWLPGknwKMjBoxnLwHMTivB7gbD2VDcLkGXQrrTPG3BIXyJCtErTCW9fgecpSSlf11mOW1Yeta+7I8q8LgbbUjA==
Received: from DS7PR06CA0040.namprd06.prod.outlook.com (2603:10b6:8:54::28) by
 CH2PR12MB4101.namprd12.prod.outlook.com (2603:10b6:610:a8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Tue, 6 Dec 2022 18:51:46 +0000
Received: from DS1PEPF0000E645.namprd02.prod.outlook.com
 (2603:10b6:8:54:cafe::20) by DS7PR06CA0040.outlook.office365.com
 (2603:10b6:8:54::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E645.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 18:51:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:36 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:34 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 2/8] devlink: Validate port function request
Date:   Tue, 6 Dec 2022 20:51:13 +0200
Message-ID: <20221206185119.380138-3-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E645:EE_|CH2PR12MB4101:EE_
X-MS-Office365-Filtering-Correlation-Id: 47588b28-e1f3-4029-0cb7-08dad7baecdf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZNfLPyLOT0MDFJj3rh3Bqgq/yp0RgEgyn+L0xD/OxjrRtG4yD4GDp8cIcWXgbJwzUe3a0iE9Ex6ri7xNt5hqaclchjtdYg0WfdF8mHUjKonf3vLFE2nfGKY1dKQRFTo5DB8YsEJtmAQA96cYB2AZ5h0GTvNQKIUofBOfkS4xvp8DVY1G037E2LO/88oY4GWabv/OI39pmVdumnDEH8mQE9GxuYRdVVC8eTq/AFGIWzawaGJU+y0OhxO59q7SNUkMu51UupxDyDAuqld5fPWRBUyMMvbySjYXMMg3vXTb7ARaPminyjaNsJefd6UUEleXQZZmjMSWbssygAeMwadz0zWyYf5E2VXF9aqeyYsQ5WBMH8dK5YXWe8doeTAKCR2J5od/G9NJGyzAlmXP5LTRkqYuZFGwFJCgHOJ7WAhmatQ67ObJWiLAB3EvFbo8403QAosO2zI9XIzjojfEz2/N6B+AUSNrTBkZ0KPgTkqGR6HP+w7KJfvb+wI7m9WVqdaDiEzeib9tAfj0vgna3gPDnc+s0d3ScpdVeirumUtbhkfyyvG6iRDTrfDkaZl9OFegnF1JofEGzt6xXQl2R/Z8orLGUfO4hSWZpedNSjSyLmQDrfTcHlmU+3U/0jqA8y8OtTEq2/fLOPHPCHRrC78hQiZ9zmlUuX4GpQ+beYvS87UsKdtC+IWE/f7b2ei32ENJXZABYgGzKF+t3o1C7YW6XA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(36840700001)(40470700004)(46966006)(26005)(110136005)(54906003)(478600001)(107886003)(6666004)(36756003)(426003)(47076005)(40480700001)(82740400003)(356005)(7636003)(86362001)(186003)(16526019)(1076003)(2616005)(336012)(36860700001)(82310400005)(83380400001)(40460700003)(15650500001)(2906002)(5660300002)(4326008)(70206006)(70586007)(8676002)(8936002)(41300700001)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:46.2713
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 47588b28-e1f3-4029-0cb7-08dad7baecdf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E645.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4101
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to avoid partial request processing, validate the request
before processing it.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 907df7124157..035249c5dd17 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1632,11 +1632,6 @@ static int devlink_port_function_hw_addr_set(struct devlink_port *port,
 		}
 	}
 
-	if (!ops->port_function_hw_addr_set) {
-		NL_SET_ERR_MSG_MOD(extack, "Port doesn't support function attributes");
-		return -EOPNOTSUPP;
-	}
-
 	return ops->port_function_hw_addr_set(port, hw_addr, hw_addr_len,
 					      extack);
 }
@@ -1650,12 +1645,27 @@ static int devlink_port_fn_state_set(struct devlink_port *port,
 
 	state = nla_get_u8(attr);
 	ops = port->devlink->ops;
-	if (!ops->port_fn_state_set) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Function does not support state setting");
+	return ops->port_fn_state_set(port, state, extack);
+}
+
+static int devlink_port_function_validate(struct devlink_port *devlink_port,
+					  struct nlattr **tb,
+					  struct netlink_ext_ack *extack)
+{
+	const struct devlink_ops *ops = devlink_port->devlink->ops;
+
+	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
+	    !ops->port_function_hw_addr_set) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
+				    "Port doesn't support function attributes");
 		return -EOPNOTSUPP;
 	}
-	return ops->port_fn_state_set(port, state, extack);
+	if (tb[DEVLINK_PORT_FN_ATTR_STATE] && !ops->port_fn_state_set) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR],
+				    "Function does not support state setting");
+		return -EOPNOTSUPP;
+	}
+	return 0;
 }
 
 static int devlink_port_function_set(struct devlink_port *port,
@@ -1672,6 +1682,10 @@ static int devlink_port_function_set(struct devlink_port *port,
 		return err;
 	}
 
+	err = devlink_port_function_validate(port, tb, extack);
+	if (err)
+		return err;
+
 	attr = tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR];
 	if (attr) {
 		err = devlink_port_function_hw_addr_set(port, attr, extack);
-- 
2.38.1

