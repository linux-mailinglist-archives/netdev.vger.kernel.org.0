Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3B2B6951E0
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 21:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjBMUai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 15:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjBMUag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 15:30:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDEAB30D5
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 12:30:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PoZOCp6l1Jtn1ofAS58CIXO6ZfIEwrn7EC/wZzFuRfw4WROBGH5E2YUEBYvqCbpP0Ls1l+vdW2gysDEZ/JVfnG/ZnSMG/T0xTHn5OEr2RiZrYcmc06BEn3IXdibylZQa+eLhMgutjcCJdZCmJ2ZeNitZ8UV44zRVZGSLSEVtNUTl2QTECEQZKE0QFM0qkbUT4NPyALb780Wuu+ZXT16tJt7uICP6vLt4LBF0K5euZ2yJqHW5cprFQY86sI1QWjG7tgnQU6w7foO78fimcY0LtPwnJOnL0eTK2+VL1+z/FgSge8D5oM+wAEpEL11hKc1p70s/W0BPHNyJ7HBJC0R9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dY1i2zx/d6w21LyxcOO2zVxW9zSAQ1Oq7EzIfQ/ixys=;
 b=GbAmnqPCSrPaEWYwv9uVckCZfZzdkdjuDLk1tPsHHCyvwa/4XJISy+CBBH+rNIBuOXFaRdsOnLbiaAL59VjY/AGu6Q1ENC+xOh9Mv0AO5KYBXIzQVfrFvyFF8/yew4jA2eX1yMuMkmJI/6wZRDizTGMukCXsPtdaL3yyrufp7vcaAu880gR2yt05zLmG29qx8Nq4nNcKdyrgb13GwQSVtave8JyzF8kOlvUwTPjYiGay+44pHzFVUUe3qLC70zjwHJuQjZqXbMtXycwE9L71hbCE+FhdAiXuZbeBjiZHSx08IzCiLGJIs5E45p1HIxlrF6aboS9ljh5USvSP85AoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dY1i2zx/d6w21LyxcOO2zVxW9zSAQ1Oq7EzIfQ/ixys=;
 b=LSpT6agAkFSHQchk1szIHGdQRZEyBBLjyK4afziQ7ZsN4+vv/2536teAhKdXM/+fWXQfgRlQ8X2Ahcm0jCl3sl5DdyrWUrs/Pkf1RJgRngyHJZyr7svTThms0qvilfZqwzQ3/ugOxDVGis0BIT5j3EhKBRS5HnUlJYFfDIAiJHY=
Received: from DM6PR08CA0017.namprd08.prod.outlook.com (2603:10b6:5:80::30) by
 DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.23; Mon, 13 Feb 2023 20:30:33 +0000
Received: from DS1PEPF0000E64C.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::8e) by DM6PR08CA0017.outlook.office365.com
 (2603:10b6:5:80::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 20:30:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E64C.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.8 via Frontend Transport; Mon, 13 Feb 2023 20:30:33 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 14:30:32 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <mkubecek@suse.cz>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH ethtool-next 2/2] ethtool: add support for get/set rx push in ringparams
Date:   Mon, 13 Feb 2023 12:30:08 -0800
Message-ID: <20230213203008.2321-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213203008.2321-1-shannon.nelson@amd.com>
References: <20230213203008.2321-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E64C:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: 50dbf22b-70ff-4a44-ff49-08db0e012847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5Evjx2M/r01sQ9Vjb7f4GxgmnKY0PzEZ06NCLiLUiPxxYIaxVUCxIYhrcxiV84gn40zWKEkAglY7msB844Pmxveahu4EV4cqXklTSHtBzCV2ozQH/K48kN1wMaNpAnKoVK4pueV39/MQSKlANjQdq6TEZSzOE3kICcVIqaHGezY/ttb3ZPuhGzKs9IXBS7tO+Z4OBuoPpB9XYHiVpsYePsAvZu4HFwXYqkYqC/TZV21g3J0/TkhLlzNmVXsM+EDTuS6g7UuFXG4VPE/2uuOpNAH9Rz1C5+8m61ymH61d+wJGcEuBurhmdHyGmhkEvtELE0KWAPhf/FfKAoALZ+BoD2iHfRJ7qL6rtjGIISwEw3fQuzWX2HZs1jvMwS7KI/DH+FhWRMr3OS89VojYo2z14XEQtmhB3kjFnfi7RlYWAL3r9f6+w2qJnqqI2dvoHliM+2qi5mABemfqm3qjCSADKuvAO6Nl/4LfUXLMRZjZtPUdYQKQVKfcGUFYafw88b65JqqtNxnAxdJPFfNVzCB1QBKKBVbMhABFL5uvtJBesd7zlJFBlHZkBHo2RAzS6xz8FD59uoPURHNvzZg7PvkYH+Bp+aNSeZKRxmSqXIIPaI+2N6hYC0ki0zi9maz1ORsMuBnKrWa1812o6dR2WVToD3NZcNbAyGi3F2C62xgRmmMQ8oVsv4x8KAR+wdNTO9kiM5yibIzV4q3UZxpY/WRROxUnNlg+1cL0HVKMoPJTnQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199018)(36840700001)(40470700004)(46966006)(36756003)(2906002)(26005)(36860700001)(83380400001)(186003)(2616005)(1076003)(16526019)(86362001)(40460700003)(478600001)(47076005)(70206006)(6666004)(336012)(70586007)(4326008)(426003)(8676002)(40480700001)(44832011)(316002)(41300700001)(5660300002)(8936002)(54906003)(82740400003)(81166007)(356005)(110136005)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 20:30:33.5526
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50dbf22b-70ff-4a44-ff49-08db0e012847
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E64C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RX Push was recently added to the kernel's netlink messages
along side tx push, and in use in the ionic NIC driver.
Add support for "ethtool -G <dev> rx-push on|off" and "ethtool
-g <dev>" to set/get rx push mode.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 ethtool.8.in           | 4 ++++
 ethtool.c              | 1 +
 netlink/desc-ethtool.c | 1 +
 netlink/rings.c        | 7 +++++++
 4 files changed, 13 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 116f801..1708053 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -201,6 +201,7 @@ ethtool \- query or control network driver and hardware settings
 .BN rx\-buf\-len
 .BN cqe\-size
 .BN tx\-push
+.BN rx\-push
 .HP
 .B ethtool \-i|\-\-driver
 .I devname
@@ -621,6 +622,9 @@ Changes the size of completion queue event.
 .TP
 .BI tx\-push \ on|off
 Specifies whether TX push should be enabled.
+.TP
+.BI rx\-push \ on|off
+Specifies whether RX push should be enabled.
 .RE
 .TP
 .B \-i \-\-driver
diff --git a/ethtool.c b/ethtool.c
index c81c430..cdb9c2a 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5750,6 +5750,7 @@ static const struct option args[] = {
 			  "		[ rx-buf-len N]\n"
 			  "		[ cqe-size N]\n"
 			  "		[ tx-push on|off]\n"
+			  "		[ rx-push on|off]\n"
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index d72974e..2d8aa39 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -158,6 +158,7 @@ static const struct pretty_nla_desc __rings_desc[] = {
 	NLATTR_DESC_U8_ENUM(ETHTOOL_A_RINGS_TCP_DATA_SPLIT, rings_tcp_data_split),
 	NLATTR_DESC_U32(ETHTOOL_A_RINGS_CQE_SIZE),
 	NLATTR_DESC_BOOL(ETHTOOL_A_RINGS_TX_PUSH),
+	NLATTR_DESC_BOOL(ETHTOOL_A_RINGS_RX_PUSH),
 };
 
 static const struct pretty_nla_desc __channels_desc[] = {
diff --git a/netlink/rings.c b/netlink/rings.c
index d51ef78..57bfb36 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -57,6 +57,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32("rx-buf-len", "RX Buf Len:\t", tb[ETHTOOL_A_RINGS_RX_BUF_LEN]);
 	show_u32("cqe-size", "CQE Size:\t", tb[ETHTOOL_A_RINGS_CQE_SIZE]);
 	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
+	show_bool("rx-push", "RX Push:\t%s\n", tb[ETHTOOL_A_RINGS_RX_PUSH]);
 
 	tcp_hds_fmt = "TCP data split:\t%s\n";
 	tcp_hds_key = "tcp-data-split";
@@ -154,6 +155,12 @@ static const struct param_parser sring_params[] = {
 		.handler        = nl_parse_u8bool,
 		.min_argc       = 1,
 	},
+	{
+		.arg            = "rx-push",
+		.type           = ETHTOOL_A_RINGS_RX_PUSH,
+		.handler        = nl_parse_u8bool,
+		.min_argc       = 1,
+	},
 	{}
 };
 
-- 
2.31.1

