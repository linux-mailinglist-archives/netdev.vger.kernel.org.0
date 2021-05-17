Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F72383B22
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242778AbhEQRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:27 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:52742 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242634AbhEQRVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:05:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzwoULW9jqXIfqPGY27AMpv5swYXOrTvBAqwUvJOEXc26LeQYV1EAnJtFSoGfEaXlWZm5lZtxj7JdtZgp8Ro3W0wTlQJUz5/m2xLtysUtekKNt9CWjWJmYXXyfC2vGfXfWIQI7SlxRI91FlOP6FNWxfji8vArvC+pIBXRkAnf4GHmzf+kc+qHhEhhY5JI0kmgy8wxP9y7QvkywqA1xKTBAxr2cWZYsypBROz2E4HfUIGEJIdImE7XmzTC7iqWE7c6R56Ye3Ph5hzmuNEyJSlAwOHqWhp2VIY98piGC0fblHCr4duxbdT4qAQ9dspwUPmr1kSz/z0mwbmPp6Senykqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpHqQnLqnSf7SeLQuq6OeYgUZ2oRydJgLm+BED2FZGE=;
 b=Ljy3THXJKScakBJlbutvUcR+BpHev9Srn7Y5QI0IJm0Me6UyCa7by95DueiIoDRNyeAjzpAgiHweQi3rimkS6E1+c4NNVLJfV8TFUeagLGEK8UqlKUw92szj6X1qbUFnm9zlye7lvYZky+Q3IchiQbSozrTXXKJMzPRx5Obcl0fD3PBrWzigyiBUFr95QilVyQ11tS+nlpgjq2nlZRS+5dZilRTSPt9D/jMqsynH2AAnGQvw/IFRWGIKtheL514xRoXVOjD93TQVafSL3u4pDR2V62sxTQaJOfPVVA2cCAgYG+TcSsHCPyAl7m5q+7Dn9rUF6tHz0ttB1NR0KH9pMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zpHqQnLqnSf7SeLQuq6OeYgUZ2oRydJgLm+BED2FZGE=;
 b=JhAJnDrwYkToG49U80MD67ECtd4MKxmuivr9fyYD5vMI5EqBcyvZXFCskDH12f52vz0as4nDUbJyDX9oVgAKQP32S36ZYoAs3n2KfEXAXF9aCj9VH/TbekSxk3MoZjZ5/6qJlgfKEYgvGcrod5EMfSD7ubYQpRyujHIFyGhHiGoCpCZrhVWPoSFGTbxBy58ikaRzrnsLCNqGgPYnKpXCGzImCyRN30h3v/jdPJl/vlTlJm8gbIvIb2b/8/Uy8hp18spOM+LP0i4kpQZWP0H0khWH+4rhC2N3jo3JJqFBRYJPMyeuLia/Bh6ySJWteNwf5TLvvEOHcQW3JG30/AqQHw==
Received: from DM5PR07CA0141.namprd07.prod.outlook.com (2603:10b6:3:13e::31)
 by DM5PR12MB1194.namprd12.prod.outlook.com (2603:10b6:3:6e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Mon, 17 May
 2021 17:05:02 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::ac) by DM5PR07CA0141.outlook.office365.com
 (2603:10b6:3:13e::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend
 Transport; Mon, 17 May 2021 17:05:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:05:02 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:04:58 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 08/11] mlxsw: core: Avoid unnecessary EMAD buffer copy
Date:   Mon, 17 May 2021 20:03:58 +0300
Message-ID: <20210517170401.188563-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5381c74e-5d11-47b8-2922-08d91955e944
X-MS-TrafficTypeDiagnostic: DM5PR12MB1194:
X-Microsoft-Antispam-PRVS: <DM5PR12MB1194EE105F379A3406247366B22D9@DM5PR12MB1194.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gM40WhxJPOwJkhfhVE8f2eO9Ahik8Ln2feq3tgXgGx+cXZlFvXH7tXfNMRYYxaJ8IO7UOEcjyiHkDyBoxi2Vepxqo4LZ06wNxkXwSyKlDk2/X5iJH6JpmNJBXJikGMIMnmt/FzTMr2IZLm2h1/3okoct6TmigkdY3YDxdQ+9AlMhGKtpzFlsH4ZAR25UeD1K2l6pduQ5L7AkSOAD9VGPfHjr44gfZgTdjj2X8AGfAYrezsTTO2BIOsAp8E4aj4Gi4NrUEq0qKffR7ayOKNYc+6WnCohGN0MY3Qk8qlZg9K0CAkNbYS8L607nwLG/Z5mFq7r3s0Ra30sjZgzlRV9SfkuFjorRCu+89ryl1oHFtFd/x/pFwp4yS7r7YylJujcCkpUlbXjPFbQEoQLlgPfRjUfeDJK6RuQhlBqPeqsdKayfTaugcakrf+gAT4oVsw0w7Km/U4USuxPtpbNaKxXDBtPpj0d86WKaCTpj6bh3U0irklZ/q8ofh3KFTHTQ/kdt2MJXh6xfyvfIptYnh/d7crSZ0SP9p+tbzuko1cCvwMucO0/hyeAfJhFPpRsErhr+4MWTDgEjwWbdeGjUysM0u3huifO9dCk0notxBv+OEBmaSvmeEWOWrxD4Ypuxj6OgyG/189SWtk77ncRNxEaerwQYpZ+TKYm29hqLOWR2tK8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(46966006)(36840700001)(316002)(36906005)(107886003)(26005)(5660300002)(36756003)(4326008)(1076003)(54906003)(70206006)(70586007)(8676002)(16526019)(2616005)(426003)(336012)(8936002)(6916009)(186003)(86362001)(82740400003)(7636003)(36860700001)(47076005)(82310400003)(83380400001)(356005)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:05:02.4279
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5381c74e-5d11-47b8-2922-08d91955e944
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1194
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlxsw_emad_transmit() takes care of sending EMAD transactions to the
device. Since these transactions can time out, the driver performs up to
5 retransmissions, each time copying the skb with the original request.

The data of the skb does not change throughout the process, so there is
no need to copy it each time. Instead, only the skb itself can be
copied. Therefore, use skb_clone() instead of skb_copy().

This reduces the latency of the function by about 16%.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 7e9a7cb31720..ad93e01b2cda 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -630,7 +630,7 @@ static int mlxsw_emad_transmit(struct mlxsw_core *mlxsw_core,
 	struct sk_buff *skb;
 	int err;
 
-	skb = skb_copy(trans->tx_skb, GFP_KERNEL);
+	skb = skb_clone(trans->tx_skb, GFP_KERNEL);
 	if (!skb)
 		return -ENOMEM;
 
-- 
2.31.1

