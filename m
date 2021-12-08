Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A1346CDFC
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244382AbhLHHEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:04:12 -0500
Received: from mail-dm6nam10on2068.outbound.protection.outlook.com ([40.107.93.68]:24897
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244367AbhLHHEK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:04:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkjWbvM0jeg31GgnTcnfD8Krs4je8reJqfMADxkO18JqZ9KY0oxvhAKZfVTYlca7zQzDsEWWw+z9AwHIL4DqeY066W0/fUz0nIemW2/3oTznjNIp4dt9nIqzySn0/GASjbaSWo8n7Jgble7MgYAUo6MS7itAmXebR+tjXBDv8CvRRJajLa2rNcrkqrX0M4N/2qMeGnUfQHBil/8QTEUKckzOuM5VMSX80yyxK9Z26okzQg52Xhs846+CglT/iQpRgqrAle48J5vRQ76nhZsYtqT4gAPz3uRNLif15qd7RBx9m0+pj4+IPYXpW+omqwt8DZ89d85wuLhH4OAYOYorHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iw6bqMgsKhuJbetX05vg9QR3N2qkz/8D5ZXiHWqGOFY=;
 b=LaOzSFxpAeaKGjPqvtJM089lEoYuMU+4iTtKGOFgPVEdAYi5ByXqi4tJryJGNOGHSBZeNOMznoaDv8FvDBXm7vL+gviFJxWbCJbGtpcP1vbsm+nCBsVxF/1NJQUQczq3/QESYPLwxhtUngmC8IHOpO6Hvy3YETWXtqefV6lxLKjuMnsX6s3eGVNoGvfJ1kA9Bmtb6ksqLOM4vb9DPUVZtEVqlQyUpFByzdEYFJcMWWNeKhS9E/PjB1R5TMSxOzYaq/s6OL7t+/0iXh2qYfu7zfI4rf5QM6OqvdEspVQNyTuYDh/Wy8ZfETDIH2NUcMz0FjErz/EzXbcypyqeyit6dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iw6bqMgsKhuJbetX05vg9QR3N2qkz/8D5ZXiHWqGOFY=;
 b=lVN/sllG3KjiRwiPa/II4g1jb0d6Wq40iZoC4UmJaCQlCLiR9CqLhG784LpphSbvKNGFwMUgyeUvHhAc0zVHCOw4M7LkgwyMEnyZtSLns2uQZFjjIPzrH5sIFUJOLsqsJ0IpKbn+Z3zR5BrXOyUkiKhyAaD32LPHOIRm0hrAfiFHgdk+LglUS7RIClxnWPvDtRe0BPNlGWjpRiFTmDph29xSoyn2JiPSMRskivzWP7rvBDrGkhnO5NoU3qTAf34+5EKI0HMA5JBCI5M6xsYL/XpGmCzX4JhE8QlqWAimY7MFBO5yPfZvfdZwUkEACtCcngOvJ8Oa/fPLEK4kKu/sug==
Received: from DS7PR03CA0336.namprd03.prod.outlook.com (2603:10b6:8:55::20) by
 BYAPR12MB3014.namprd12.prod.outlook.com (2603:10b6:a03:d8::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.12; Wed, 8 Dec 2021 07:00:37 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::b7) by DS7PR03CA0336.outlook.office365.com
 (2603:10b6:8:55::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend
 Transport; Wed, 8 Dec 2021 07:00:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:00:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:00:23 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:00:19 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 1/6] devlink: Add new "io_eq_size" generic device param
Date:   Wed, 8 Dec 2021 09:00:01 +0200
Message-ID: <20211208070006.13100-2-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211208070006.13100-1-shayd@nvidia.com>
References: <20211208070006.13100-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dac00f2f-d568-4aff-9b4a-08d9ba187005
X-MS-TrafficTypeDiagnostic: BYAPR12MB3014:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3014AD5A32C87EFB8CE7981DCF6F9@BYAPR12MB3014.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pr68vENoDbldJ+l+FjXjhLKYzl1C8HfsVJ9VxvW3U+twSDCESMiCWA4AZbYa8hkdJMGkF1ElsxutZjlaJpfheUTGnRDx9Mwb/osne/P0IKh1s18y2R3YluYMOfhS9sqPQqCinsDYLH829XxJQJQ+BwqzBAu+HhCAl9fPrNdgK8MsEKxckfJjwbPPDOP+WgVEvJPTJnqEeD6NqSlWbr8RCnaG8E5i7ZQXZgNLU3LRHh81ohWOTQLASESAsz9OtbOOTKyx9l7UZ8iCBV3nWIHuiRR2qkGgEwoQZQ+mhEEc7YlYw5uoQGD/isro8EoRFTy7yz8LfxTcMJ08N4x5coBk6zNG8ZDUXy3QSVOZtTYGLPTUMmAtUvvVVffJVi9XY6aeiKZ3V2m+cVNHg3NKIxd3WbEPAKAQiiN77icWjSP2PFbJbsbr303Bo40Vo68y6H69G9/x+xlmZZtL0OJ3ru0/oZpaOgZR2KJTgU74FHfb0jKAkpeskkB6fbloCEOVBFZhRWGn/tOBtslqscN7Qz9+80ttZ79DcdzzksEcPkeW8LHvdg+R0CKD20AapV5Hhy9/5tgy9tpO0pS1+cVp/WEd5ctZCCm10BNBK3quxpFda9hN5i0pzBYEIaQOyfzp3g3Wur6ljMWOwfjX9zZWwHV4HlySSgoCzj6Q8lIELBTNkGAxDFdjHpSx7uCzJ8ED0g7MLuEdzSQFiT+D/ZdwykLtQ0jly2eq595chslpBr18I8PKMKdiHxDPnBMhtM+0gsD+S1TpNFIy5GVfg4Lo5C6tro4gy1fLlV59pRDF6REwubBw3S7Fx2odn9rrg2X1SqXNqcmV2clN6gCjq3NSYiccvA==
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(70206006)(5660300002)(70586007)(426003)(336012)(6666004)(2616005)(1076003)(34070700002)(8676002)(47076005)(40460700001)(4326008)(36860700001)(8936002)(508600001)(36756003)(7636003)(356005)(82310400004)(86362001)(107886003)(83380400001)(316002)(186003)(16526019)(2906002)(26005)(110136005)(54906003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:00:36.6502
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dac00f2f-d568-4aff-9b4a-08d9ba187005
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new device generic parameter to determine the size of the
I/O completion EQs.

For example, to reduce I/O EQ size to 64, execute:
$ devlink dev param set pci/0000:06:00.0 \
              name io_eq_size value 64 cmode driverinit
$ devlink dev reload pci/0000:06:00.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 Documentation/networking/devlink/devlink-params.rst | 3 +++
 include/net/devlink.h                               | 4 ++++
 net/core/devlink.c                                  | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
index b7dfe693a332..cd9342305a13 100644
--- a/Documentation/networking/devlink/devlink-params.rst
+++ b/Documentation/networking/devlink/devlink-params.rst
@@ -129,3 +129,6 @@ own name.
        will NACK any attempt of other host to reset the device. This parameter
        is useful for setups where a device is shared by different hosts, such
        as multi-host setup.
+   * - ``io_eq_size``
+     - u16
+     - Control the size of I/O completion EQs.
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3276a29f2b81..61efa45b8786 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -459,6 +459,7 @@ enum devlink_param_generic_id {
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
+	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
 
 	/* add new param generic ids above here*/
 	__DEVLINK_PARAM_GENERIC_ID_MAX,
@@ -511,6 +512,9 @@ enum devlink_param_generic_id {
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
 #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE DEVLINK_PARAM_TYPE_BOOL
 
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U16
+
 #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
 {									\
 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
diff --git a/net/core/devlink.c b/net/core/devlink.c
index db3b52110cf2..0d4e63d11585 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4466,6 +4466,11 @@ static const struct devlink_param devlink_param_generic[] = {
 		.name = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
 		.type = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
 	},
+	{
+		.id = DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
+		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
+		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
+	},
 };
 
 static int devlink_param_generic_verify(const struct devlink_param *param)
-- 
2.21.3

