Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617E854377F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244435AbiFHPfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244330AbiFHPf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:35:27 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2053.outbound.protection.outlook.com [40.107.100.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C337610F364
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SYLnx1fgZ23HIAzWWsUW8ItqZJWgh0c8lusVYf2/rAmfy/9YoY3l0DY210beKGYdv0Ne50Va3O14VS8t7fsgq1Vpzb9ZJCBGgUsNspakjQiWG92rLUXgnLuFPZNooO+0bVq5fln+rFcagjlCdrs/Uz9YEz0nQhdbDL3l5rMhD9XPG4fhu0G73pgf3HCL317hMUbhaLnd94NB2qpGSYljbeQG56U1uxHT6Z9y+00KRICJQ6AEl3Fc0IrnoftU9HeCz0msHuolP9iUGzHjiL7c5EOgZsIN4DWB9XTNtLT9yoz3eiIwSQPDBMzhN11Ub0R5/dxzCDJdyJuaQeSAcqIEww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXavTQ7RUAW4onxBKbkplweKT2nvhW4GWZH42jTXH6I=;
 b=nQfo7Y8ZnAF3GMoZgMGULnFWisrXc4KfC9Zblr2oy5wTIq3NT1PyhNGF0O5fnyCiOx2bAYZnBnIdVjq/RubRYVlkMZCmNQnsAQlUE7u6WYmv492ZdQrOXf/k0orCk3DM3RjbzdG+Siw+JjgI2we1TaR/qw6p/lZXeDhpsT9kLKMsq+w38TIYByiC93pr5GxUneSLMqgGUOMHeuNPmfYviIDlfgwUg2p53iMujmRwxHWs3aVh/p32eTj097PPyIq6z3MoG8+s9CyFSWT58SKGk39kilkysYIjfqI91n8u1WcExZJPi6urPVU1VYSeheFmgwMo7v/iQhuGbpKrDDhFOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXavTQ7RUAW4onxBKbkplweKT2nvhW4GWZH42jTXH6I=;
 b=tVm4wEnswzNHkZumUur1QsLM9lAAiKimC7Az9Zk3YwOk4ywsrf7ia0G/9vS8ftyAJs79NCAV+rRlTlv5+F0Tblv/23A4ZnMAn+BJEqBG3ZKbg11X4h/lWGPcc+EpV0gSN9Mdn0XHCM2JwUywXeaME0m6D2mHM3klu00NXbUntaUXlkqMlLYI/HSc4OGtgfihsOezW7+7twOgin7Ldikjk6ELY5P9EK+xFJZweRrt4cNBjx+wqR+O1oMvLejDEqC0RvgWO528LFKz68MwL/+kxEUkgvsrlryjNBUsekK9akS23t7Q2RGuBWo4MV3m1bQ59YKB4CVsfQJlIlkvmTXN1g==
Received: from DM6PR02CA0131.namprd02.prod.outlook.com (2603:10b6:5:1b4::33)
 by BYAPR12MB2631.namprd12.prod.outlook.com (2603:10b6:a03:6b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Wed, 8 Jun
 2022 15:34:55 +0000
Received: from DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::32) by DM6PR02CA0131.outlook.office365.com
 (2603:10b6:5:1b4::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15 via Frontend
 Transport; Wed, 8 Jun 2022 15:34:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT019.mail.protection.outlook.com (10.13.172.172) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 8 Jun 2022 15:34:55 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 8 Jun
 2022 15:34:54 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 8 Jun 2022
 08:34:53 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 8 Jun
 2022 08:34:50 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH iproute2-next v4] ss: Shorter display format for TLS zerocopy sendfile
Date:   Wed, 8 Jun 2022 18:34:45 +0300
Message-ID: <20220608153445.3152112-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 861c3187-5e4b-49fe-a18a-08da49647028
X-MS-TrafficTypeDiagnostic: BYAPR12MB2631:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB26316E5CE1A59873250FC6B6DCA49@BYAPR12MB2631.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xE3hk2hoo7g6aABcOJyrTlE8jY3Db0HyRvDrnAcGxbxvaamBwtJt9EpJxVD9CFYejjCAihyihzgjqkbmm1NiLaffkAWXpTNDQl7HUHo+QWkJ9rwxXE/Joum1nJvaxt3XRuo6kE7rYC4bA9d0wUuB3nTFKaWi4QtCsWMGsKqAPbtxzWQtAcrF8hscjG0y0dPJzRY8zDyMmaAKxycisTNnuyA0+YEIc6fxwGHrEEQBBXXH+SbVwlGnjR+GLS2ZjpiaArFW6Pe3igIO6J0sAMSHDSpqmOLY7nJATuR/FK53nnx0hrGDL4EanVjE8BnGhoMcAY6kslf15sgyjwKCrAfHSIE6zwZW3CnE+NAL9WTjwcqa6+Pve/r5v++LCcAv5jQWyqNZ0p54go8MS0jBQuFOZSk/SHxWaYxJ58fPlwT2y6iBP40wTzuXwmRzwWNaxLfaKLbWHHmJRMwCbLmpAH52mPOjvpnvi0liJk6GiREdg2Q45mzkf0zd2XFjESMbEc0ppgmkRM7ZAW9pNd0HvjJBFaFsDBga+LZ4wNyuE+dayVmvQC2oFcJQpT2bye+yc2cRQbJxvxX1Wfk7eZAAMIcrUiCQ4QL1j680pCnt2WIE0RMsiq7J0hCpK/UPIkUBk2hqZc5y1PiFHHt+YvZ2/eoCbP6ld0R+3gw7GiKM18bpkt+Zvwy4UgH2efFpTBZP+bCU5o8+FnfIpImJ7nBLNzH2HQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(83380400001)(70586007)(4326008)(36860700001)(82310400005)(1076003)(110136005)(508600001)(7696005)(86362001)(8676002)(186003)(2616005)(6666004)(40460700003)(426003)(336012)(47076005)(2906002)(54906003)(70206006)(8936002)(26005)(81166007)(356005)(316002)(5660300002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 15:34:55.2364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 861c3187-5e4b-49fe-a18a-08da49647028
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT019.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2631
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
sockets") started displaying the activation status of zerocopy sendfile
on TLS sockets, exposed via sock_diag. This commit makes the format more
compact: the flag's name is shorter and is printed only when the feature
is active, similar to other flag options.

The flag's name is also generalized ("sendfile" -> "tx") to embrace
possible future optimizations, and includes an explicit indication that
the underlying data must not be modified during transfer ("ro").

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 include/uapi/linux/tls.h | 2 +-
 misc/ss.c                | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
index 83a3cea4..4f868648 100644
--- a/include/uapi/linux/tls.h
+++ b/include/uapi/linux/tls.h
@@ -161,7 +161,7 @@ enum {
 	TLS_INFO_CIPHER,
 	TLS_INFO_TXCONF,
 	TLS_INFO_RXCONF,
-	TLS_INFO_ZC_SENDFILE,
+	TLS_INFO_ZC_RO_TX,
 	__TLS_INFO_MAX,
 };
 #define TLS_INFO_MAX (__TLS_INFO_MAX - 1)
diff --git a/misc/ss.c b/misc/ss.c
index c4434a20..ff985cd8 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2988,7 +2988,8 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 
 static void tcp_tls_zc_sendfile(struct rtattr *attr)
 {
-	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
+	if (attr)
+		out(" zc_ro_tx");
 }
 
 static void mptcp_subflow_info(struct rtattr *tb[])
@@ -3221,7 +3222,7 @@ static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 			tcp_tls_cipher(tlsinfo[TLS_INFO_CIPHER]);
 			tcp_tls_conf("rxconf", tlsinfo[TLS_INFO_RXCONF]);
 			tcp_tls_conf("txconf", tlsinfo[TLS_INFO_TXCONF]);
-			tcp_tls_zc_sendfile(tlsinfo[TLS_INFO_ZC_SENDFILE]);
+			tcp_tls_zc_sendfile(tlsinfo[TLS_INFO_ZC_RO_TX]);
 		}
 		if (ulpinfo[INET_ULP_INFO_MPTCP]) {
 			struct rtattr *sfinfo[MPTCP_SUBFLOW_ATTR_MAX + 1] =
-- 
2.25.1

