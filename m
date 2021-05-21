Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC138CB8C
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhEURJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 13:09:08 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:17952
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238000AbhEURJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 13:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNf61TNXRM4xhk7JAcb2MJR3xPHh8EEFdoXJx8qvB4XYh+kYGMm2QOc7nwbFGmeE266voe1jAHzgM/ELmnRsftDaBpq6oTZILJKPzCwtc2UQ2j3uKsxQ/p4CW+b1DJQpw0lZimv/1eJjQFF6TX3+9VhRn4w23x+oJY3fSNsAPVR48Xy5Kh1axZGf0+GCVATsiYUQhsTuxr1Q8u1V1I9BWFwKHsYO4FBjFXMXyzcWTG5hD5qng+kVtrLu6CFdLS3WvzkZaLwkKCNtv5rXqAsX5Ww8ljJI3dHy/W5S+8WXV0JNdcU0sYZEWgdQA/01Lxo2D+1z7//r+rrRiG4Oc6ZcUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQrhig7HLnTdz69Yx8O+RzgPTmt6VQJuV3l9vKrKZgk=;
 b=NyIyGBhvKLzrVE1UWuApSs9fjdDRWkeR1as8jkqH+8U3P3Zvn+G3pFtIM1UCV3D3WxAF1nKlgOAYlNLCq3KE+p7HQa9k8aDW90q4l/vyCzhtBoGC9+HEtc2Jfxs7PgWmsKFG/M69HP9n2z1+eOaEBMWiQ4NH5hFiQknVCFkN6AQDSjB+vq0VlVR/MY9RVTjNpURPXl+MPtbQ6l/CBn5SHQ4bTSgIzRcKqHnA3pzfhOcys8F0B778BLtK7BvmNwq1ukV4kFzkmi1TM1WWVpJ33eekwixLfNZfXN2ksdeGKEl+1bbiUA0/PxyyNz5IjwhHhOQxEwto6KruQzg2wJ6P1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQrhig7HLnTdz69Yx8O+RzgPTmt6VQJuV3l9vKrKZgk=;
 b=Q+Ni4CEurvtUxlw/T+SmCpxV1T6PKv9CICFbPrryHXp4cQAIjxW4Yt9+s14mcRKO/41Baup0gLMBWStP6cqksy7//zujLwQSUPApGPU/sHTbqi/yM0WeL1MFiXQDNEvZ7LynEawjSHTHDKjHsnFRrq/taH3/DYP1AhhIGB4rFbK9Ej1Buymcxw/RJaIyCOULXzzMukfa1t5pyf6JlhSFix4teoGFFy8/Z3P9aSPHFgsTrVa8dOUTw1HKf4CYA9TphvWgn4ExS9fUDjgelubaFH+YT6lnU7Y5ms43mIPO7mXewpq7InQo9kQpsbvQB4zz/ONEo3L61p+8vnaMBGC6cQ==
Received: from BN9PR03CA0793.namprd03.prod.outlook.com (2603:10b6:408:13f::18)
 by MWHPR12MB1264.namprd12.prod.outlook.com (2603:10b6:300:d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 17:07:39 +0000
Received: from BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13f:cafe::9b) by BN9PR03CA0793.outlook.office365.com
 (2603:10b6:408:13f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend
 Transport; Fri, 21 May 2021 17:07:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT019.mail.protection.outlook.com (10.13.176.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Fri, 21 May 2021 17:07:39 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 21 May
 2021 17:07:38 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 21 May 2021 17:07:37 +0000
From:   Ariel Levkovich <lariel@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Ariel Levkovich <lariel@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH iproute2-next 2/2] tc: f_flower: Add missing ct_state flags to usage description
Date:   Fri, 21 May 2021 20:07:07 +0300
Message-ID: <20210521170707.704274-3-lariel@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210521170707.704274-1-lariel@nvidia.com>
References: <20210521170707.704274-1-lariel@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b5db1ba-b1c3-4261-391c-08d91c7af05f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1264:
X-Microsoft-Antispam-PRVS: <MWHPR12MB126421853CEE367EEB2B0B6AB7299@MWHPR12MB1264.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lhdn1DNfSAPt76uhCkQUFzUJdKFUKCoTkBItxvM21jbYmzmEpCMcYJr8QA25yG47jRml/ua5s31CiMrD4PFmOzjlK+r95IvYTtN2C6Vy8h+OqVD8huVK2fUkyexbzy0B5WPqS6ssHSbyTk5JwmQ0yqmQF5sB4g6Baaz8qAxPyWggmtYq5J1gezo/yOB1NNE6zycYJSArCgmtdZPINMd4oI83MYjqIqnnC36sLTeXbrzvbtSkCaQIY7y/6T+JxT3dUyT35j4manZrF9Lzi1TyOPsoBY4bYgPpG28uD1JohNq6SG5i3j18TKHlIiy9OZ+MQtETZ/kVukblQO1L1FFFhD7ULPRXTw6UDtHQVsH9zxohnCaCX8kAJuct69Tp5cH3whvjoMSliKc3u4EWPlbyvwNndxj82j8M7lmzFqwt/qQf3oX5ix13P+0z9YRMyYj18amnrGg4R9KAA+nNhoqptq1FLCGU/X71EjoWtfRA80CgmXTnMuZdR4p1/uZbhMeD6MumqGh4LdgwdYrA7mV0CXqXq8KWo4n+f6anPxpWfXcmckk88sSHvH6txEcZaSwcfEpqYFymWgknYZMcZ7XHw/aEFaKd3xVN4m33GJMkLnsQpWCJ6k28em+XeweFamH38HPotelklRlbxxO97gbvYg==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(376002)(346002)(36840700001)(46966006)(8676002)(356005)(6666004)(2906002)(2616005)(70206006)(70586007)(8936002)(478600001)(1076003)(4744005)(26005)(7636003)(336012)(426003)(86362001)(5660300002)(186003)(47076005)(36906005)(6916009)(54906003)(36860700001)(82310400003)(316002)(36756003)(4326008)(83380400001)(82740400003)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 17:07:39.2037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5db1ba-b1c3-4261-391c-08d91c7af05f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1264
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ct_state flags rpl and inv to the commands usage
description

Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 tc/f_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/f_flower.c b/tc/f_flower.c
index 29db2e23..c5af0276 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -94,7 +94,7 @@ static void explain(void)
 		"	LSE := lse depth DEPTH { label LABEL | tc TC | bos BOS | ttl TTL }\n"
 		"	FILTERID := X:Y:Z\n"
 		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
-		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new,rel\n"
+		"	MASKED_CT_STATE := combination of {+|-} and flags trk,est,new,rel,rpl,inv\n"
 		"	ACTION-SPEC := ... look at individual actions\n"
 		"\n"
 		"NOTE:	CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
-- 
2.25.2

