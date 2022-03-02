Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B3A4C9E10
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 07:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbiCBG5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 01:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239778AbiCBG5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 01:57:04 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2056.outbound.protection.outlook.com [40.107.96.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45ACDB16D5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 22:56:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/GLelKxIjg/yhi8sDTAO8wukTk8p+dyR7IU+8KBt0Wcl1T/zk/I0SBaGL3u/f5McRxuTspjaZ84oPDiL0xsFHKp+IKuscHfBs2DUnM8E05GEpsqN2lob8BkmU1PVoT7w7UzM+vcJ2OomAXUBxsMbX1A/sn1LatQ5ae7j706dSNqJX5kjfiBg4DjExCd87ZdVFwCHwmLU9sKqGF5HM/XPIpzWc5VMPwkL2DYiedJ9N50Bpgkn/8Vujh85LdBHxv2p/COqbaJxemsu0k5LqYqP3njZhoO+1leWUo1kH2uNTYROw18e0yCZBsGCtPwUz/QT8mZZgFuuZUnehZgXOeTAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4i2wM42sRbk7uM+bRoMb0tmUy1kZxWcl/SClPkAcEU=;
 b=ZGHUHJTPTY0253U8/vZAAMnJyCwgUFsZE/jjp66UT8jSs0q2k+xBin3vy6ZcXWMpCseiiRWGN9v0euI7G+GqHLIdZmD2S4GEEwKkU/IOpzQPB1BjRhT92UL8XWykNA8BMZ7W/S03CMYieO6dLfSNVyCyGHMJLau8HBwpV5imYuJyX8rE431IKn4bRBsgXg7qC4nxvXCYTLdRYC0Gv1mM7Niodv9QWQY0V6ij5fuf0tV4iIkJMWIBBn6aENWrybYJA2gx1Q9wRNBuXG3T4Cl+jMsmI4skRhJoBFWllNCAxlqIn5d8lj2VFSb6ChB7XaXKrIiaXEtM9Y7edQ4Y90aEOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4i2wM42sRbk7uM+bRoMb0tmUy1kZxWcl/SClPkAcEU=;
 b=UHFQ0Djme02PtRQNy+9QMOUjyTkHM5su9Mx0XmtpG2GTREv9r3CmWo09L+PMJD/gbbqOT44r9mY4tcYYrow7CK16xPbRBAcqWYcOJJUyljiucp5VbfN7RHMwvdTvG3S/7vv34rI9g6y0wH+o014SEFaghK1hWP5QfuAzzOjhDqmuSCROSCpe1TrnYK2dX2Xk1c/0cG9E5+iawo3cPcpS3xLjSS6cxY6XTvLaywJQiEXZxeC8H4Qff9HwU//oH48adt1lPAdfTYUSYuHCnmQ9/lG+Iq5mJ7Mr8GrzWBh/jvdj5yOKG3vb0753geWxwwJJV1TdjyYhyyw5HqRFbZGJWQ==
Received: from BN6PR14CA0005.namprd14.prod.outlook.com (2603:10b6:404:79::15)
 by BN6PR12MB1345.namprd12.prod.outlook.com (2603:10b6:404:18::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 06:56:20 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:79:cafe::b0) by BN6PR14CA0005.outlook.office365.com
 (2603:10b6:404:79::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14 via Frontend
 Transport; Wed, 2 Mar 2022 06:56:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5038.14 via Frontend Transport; Wed, 2 Mar 2022 06:56:19 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 2 Mar
 2022 06:55:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 1 Mar 2022
 22:55:28 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 1 Mar
 2022 22:55:26 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <jasowang@redhat.com>, <mst@redhat.com>, <lulu@redhat.com>,
        <si-wei.liu@oracle.com>, <parav@nvidia.com>,
        Eli Cohen <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v4 1/4] vdpa: Remove unsupported command line option
Date:   Wed, 2 Mar 2022 08:54:41 +0200
Message-ID: <20220302065444.138615-2-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302065444.138615-1-elic@nvidia.com>
References: <20220302065444.138615-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62da41f8-0e74-45d6-d2f3-08d9fc19c172
X-MS-TrafficTypeDiagnostic: BN6PR12MB1345:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1345AFC919DD51BE457913D1AB039@BN6PR12MB1345.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dbv7M3sXHMVn6NfkoSwalFpxulZT2+QtPF7vS//g/qCcp8Z8K9jN/NQyounGLc/abY6Wc4JlWmEp7CURW2NzwyCJSr88qJu2kZgmUtGs5mXnLkCL6/sTB2TR01zvYYp5bA7O+2+hv7RGTknD4j618zB4yy0NspRG6wZVKhtI9jK7IOGpNj2InKVVYT63xszo9tSD4+Z5PAON4OOIebEEjCaSiDfqJ1jFaHThefwy3ExR9ZLxvGhcVhW3ZM2GYRHAXcrWIzxvGISdjx+x5IK/hrMlAIKVayPGnN+ZJpun1ggXabw17nDLEfwILN8TBuL3sO2JihuD0EehYMJeU4fwyVsQ/M/OWNKKaB/3walrnBvKYNVLeqctLiTUvX06yEQJ7RCYy0cP7UCR9e/uxKqS/7jIgEJWAHFZqbL4m4hfilLipv+m7ujdRKik32Idsllvabo5yxYX8I8IvYyinEmWWtFuo/w6oGSEprOT13UDbJ8hMK9ox7unNGJtqG1ghun3t0whuHMqBlC6zmBKQPLjf0kpa+YCNucJOl0PVlQzo3vwcEbyY5zwI0ewD//vagGalv0/b81fXaGCYP9AfJPfIXUDh/w70uL/0nQE6iAmdNsQBAY7DRP3/rHlCmn4A+YB/+tQu7R/kT1bLUVQpcBfYJNu0VQAaqyYQmDATzEuJuVIUGj7kpzwaNgYGmrKx5OM0+CfIPb84SX0SmO2U7prqQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(81166007)(356005)(316002)(2906002)(36860700001)(8936002)(4744005)(40460700003)(5660300002)(47076005)(83380400001)(336012)(2616005)(426003)(508600001)(110136005)(4326008)(70586007)(26005)(6666004)(186003)(86362001)(8676002)(7696005)(70206006)(107886003)(54906003)(1076003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 06:56:19.7983
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 62da41f8-0e74-45d6-d2f3-08d9fc19c172
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1345
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e470c929..4ccb564872a0 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -711,7 +711,7 @@ static void help(void)
 	fprintf(stderr,
 		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"where  OBJECT := { mgmtdev | dev }\n"
-		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
 }
 
 static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
-- 
2.35.1

