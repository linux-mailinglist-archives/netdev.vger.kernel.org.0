Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B40438CB8B
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237973AbhEURJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:09:02 -0400
Received: from mail-bn8nam12on2083.outbound.protection.outlook.com ([40.107.237.83]:65120
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237950AbhEURI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 13:08:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuZD8F/3G7TmUGTZfTk0LL0iYYoIwJS3bDUVZOC1RjF4mMRgpFM8F0LnnDUv3/pAqRtfnQV7KR+pQphNGPk6q7aoRenjpYIt6ujyE6K0HJR2bt5JNwLBrdk6qhDfz4Oql2keqrplAfM43d4CiaOkQ/yb0L1mMo5qQrXAq+IW87Lh73abdIT9D9QlFM9YM2yKMSFlQ3wYZlpa/nX3vq2K/itBE3mRMWyKM8XfDkRr28d3MtMSE32qD0xpnmVwZKJU+cu3YlfdWE5Y5hVP2cNeobJMnF0NKzPW/OyZ93ZoO0NKMa7TlInEFNOB9WbptkSTjrLsQNs4+N1C7SFifW5xBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeZIJVGXof04G5SS2BlwzsqnsG9I936Hy/9Meq/7xNs=;
 b=G6qb3zZJBC2Y6N5/v+vTtwEA0d9fh/qnIwqs0g6twJ+Bq8tu9Q87xyxTaSuyae96WW7FeeaZ1HbTn1iQLyC7mLt+9N2F1pwx90PQtAE+TabyvaX01JN6Pi+x2v39e+Z7kOCwOyZU1D0N6RyhzdvLFc10PczXPJTqJoOLapIgff/UX6TzOyfmL8ak4p9MeZf1Aru3BrIwiHLEyRRGGwzhCI9WuGaQPtJyri4kkyHWgmDgJ7AZ6IQ3lZ0Mbs+90XWyDFW6MljSwZ6nmhxZyok9xM0wM9Crm/KdTu0vMTzly1+EYA+RhE0SVk3zjfERpAHyrhBQitR3iRcL3cJE+wKCHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GeZIJVGXof04G5SS2BlwzsqnsG9I936Hy/9Meq/7xNs=;
 b=NYGasrzKa357XeGe7+obSRicTKRPJzh8/PXIdekG5wx9gnjPTrbnBpFr8HEX5YqDT64He5gKpE9Eer68qz0A1UC5Ta/MBJJu+Ukc75J2FlNB38wYtaBwr3p4xxjbZjaejp8sVjbGrMqvNFPl7jjSB8CiXMDvYH8bUeqT0gclWRTiPOuIGH0SiD1YdDA+ICbEReKp8fFiiRmCv6XBOq7GDgV0JL/OhXX0lAZFXjy2xGkPpbWaNgdD3+QmO/pImUxYQ/4B3YvGGhzpvBs9/gfzv25EG+V6mePYQrfCZTfVZd5ZdU79Da+AzFiOTiktIRQCyirum47Sl6ZNJOuo1L8g7A==
Received: from BN6PR2001CA0034.namprd20.prod.outlook.com
 (2603:10b6:405:16::20) by DM6PR12MB4764.namprd12.prod.outlook.com
 (2603:10b6:5:31::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 21 May
 2021 17:07:33 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::de) by BN6PR2001CA0034.outlook.office365.com
 (2603:10b6:405:16::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Fri, 21 May 2021 17:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 17:07:33 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 17:07:32 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 17:07:31 +0000
From:   Ariel Levkovich <lariel@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 1/2] tc: f_flower: Add option to match on related ct state
Date:   Fri, 21 May 2021 20:07:06 +0300
Message-ID: <20210521170707.704274-2-lariel@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210521170707.704274-1-lariel@nvidia.com>
References: <20210521170707.704274-1-lariel@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c35452cf-fc08-4ed2-4ed7-08d91c7aed12
X-MS-TrafficTypeDiagnostic: DM6PR12MB4764:
X-Microsoft-Antispam-PRVS: <DM6PR12MB476440CDFF76AC1868E59EE6B7299@DM6PR12MB4764.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1AAP8sEpls+3snQnpZfvyY76PESDunOQLSjdWATYvG7n9uFfLdRur0NOZzInaaHuEuDq8QOUT9YRsUaL7rYBhVDB/wY6KF7oKcukBckgTFRVOBV0j1/Pf1urxtRIGBbsb7IchglSGpRZlJT5zsB4JPFaVAGy6994JlPCfKgGLTBiN6et3L9o9ez1uonhAqrkpN4t45a5164qcOR1+pZw76AfK2hvmmJApRhpMQXbtKJ49/4ROYW+AG2+wSZtGCLsQ4w8o+IMtKYY/Ujy0kOWyEestqwhNxKaWNZsFiY/xhYIiJRH54rZyDZumDJG/pcr3IPnG0GQanvBTGIkx0KUewZj7MKgMI6obDF16yC9qLbeWPjo2pHmNYVR6o8ERZfYtCJyYfJf3iKi8btsc91fMmEFpQRbc659bZO7MiACzyvuFGdSn8T+Kh0/slJNb5PzFcYwax6fHFK1D0EgTiEWx65pi/fOjPUIw5FZH3sBj8NoKumgYC7AWcblvHLn6ksx1QB01Xv3PEK2jZctBKhnrdMypGksEyDaHnrKwH27Nv6EyLPkMnWUGe4pzprZmPxqLawEiLdevrLL6rPeVw9AoBMHxw/5kItjIt1SEUFHghWqUapds38WiTHTlxU8vBVvH6yDtn9ys7ZsHFhK0qUeqq509M8Tnp+yfEQdk+XLNic=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(396003)(346002)(36840700001)(46966006)(86362001)(336012)(426003)(186003)(6916009)(36860700001)(6666004)(47076005)(1076003)(2906002)(8676002)(478600001)(107886003)(4326008)(8936002)(2616005)(5660300002)(36756003)(26005)(316002)(36906005)(82740400003)(70586007)(82310400003)(83380400001)(70206006)(356005)(7636003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:07:33.6235
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c35452cf-fc08-4ed2-4ed7-08d91c7aed12
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4764
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for matching on ct_state flag related.
The related state indicates a packet is associated with an existing
connection.

Example:
$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state -est-rel+trk \
  action mirred egress redirect dev ens1f0_1

$ tc filter add dev ens1f0_0 ingress prio 1 chain 1 proto ip flower \
  ct_state +rel+trk \
  action mirred egress redirect dev ens1f0_1

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 man/man8/tc-flower.8 | 2 ++
 tc/f_flower.c        | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/man/man8/tc-flower.8 b/man/man8/tc-flower.8
index f7336b62..4541d937 100644
--- a/man/man8/tc-flower.8
+++ b/man/man8/tc-flower.8
@@ -391,6 +391,8 @@ rpl - The packet is in the reply direction, meaning that it is in the opposite d
 .TP
 inv - The state is invalid. The packet couldn't be associated to a connection.
 .TP
+rel - The packet is related to an existing connection.
+.TP
 Example: +trk+est
 .RE
 .TP
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 53822a95..29db2e23 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -94,7 +94,7 @@ static void explain(void)
 		"	LSE := lse depth DEPTH { label LABEL | tc TC | bos BOS | ttl TTL }\n"
 		"	FILTERID := X:Y:Z\n"
 		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
-		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new\n"
+		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new,rel\n"
 		"	ACTION-SPEC := ... look at individual actions\n"
 		"\n"
 		"NOTE:	CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
@@ -345,6 +345,7 @@ static struct flower_ct_states {
 	{ "trk", TCA_FLOWER_KEY_CT_FLAGS_TRACKED },
 	{ "new", TCA_FLOWER_KEY_CT_FLAGS_NEW },
 	{ "est", TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED },
+	{ "rel", TCA_FLOWER_KEY_CT_FLAGS_RELATED },
 	{ "inv", TCA_FLOWER_KEY_CT_FLAGS_INVALID },
 	{ "rpl", TCA_FLOWER_KEY_CT_FLAGS_REPLY },
 };
-- 
2.25.2

