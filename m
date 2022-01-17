Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F944904D2
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235670AbiAQJ1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:27:49 -0500
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:40001
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235665AbiAQJ1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 04:27:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBS1mSc/Ruq1iokmwx5CyxK28Cj53QriHbB/9qbxHvHOIeLLIjMTcbdW8cOLQwu6M1/Gn46LZq59K1Zr5nDsBsHQPC+IU+1k+stlwnGRzafg6/QcrEvNuW2oIwrXtd2cuO4PcvpAS1WYR5kT5JIZM82Shd8yIMYdcecthVAlA4VjlE8KJNxcVAh2poeAP1i9QSMw+Y8r4v4ByfvuxpQ47ku93QgNGy+5rwUMEe3hOiYG8/hQcaCmeWaX4pqASgT3w3YVGCJGYM/1givGON5B4zOiMcZSD48dtleU3MJp0y/nWjc5ZUXyqm7qA0zjPX3Y0x+5UhU/7PQZoEBbWTI2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XG6xIanPfeoU9DU5taDFOOiMH03kJVFW0w2VzFoRPF8=;
 b=ctVMW/nsbm9h9un/YlKR652yU2opw6i0T1Hgd0mrw2U/Kj+Gxl9Bu5gRYBUtiYMWmi0akl50yDKs8kM/GhAsjbRp/k0B62pkNvLdfqxoXzBDwkMXQSpICyKNNWV//qQd5Crk0k4AVifN0XAYSjfg58DAWmnxs+jRYsyQfbXpiSoHRayezYOszOdSOMN1a/PtXhOtxB4e7o3oKtAgzOcREqE8Ih7oRRuYSrCpklggMdCciEle4vXCZ8AoPss+vyx/6L4fBwDD36gnckyrEQziSgsbJHiCBvZrKUergd3jjd0098BkD0kxQPhDosv6OKCpLfbOeT3kyuORY+XEzD8hHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XG6xIanPfeoU9DU5taDFOOiMH03kJVFW0w2VzFoRPF8=;
 b=A4v4O2kcAOjqfnVAwJKShIfJpcpotJXCzL1CLKvbH2RhFE0PoIwas7Y0mRLGGTKPggDKMtbd5p714BYKtxwBJC9xQqcUsuzSJrHH10C3SBur0TSq834gG494wPoxsZwp8/v18xWW4EjJiQhcxUQ0nLPR5MpkTikiuBortRF+AQBIzAlrV4Z5T8fCzIi2Jt7vxKhqnwswNTinr7O0Tm6MzYJyM2xDY2lwzobxQH9KlyKviv6Q6PJjdYRtkq7Bz3hGfpAHEDf3rW4bNGqtuhTDPbgE0+07Jdq7MZBKQn8Okj/cGP06ijLjjWMchsx3IGovnbx01jR03YKrrTi2GSUddw==
Received: from DM6PR14CA0063.namprd14.prod.outlook.com (2603:10b6:5:18f::40)
 by DM6PR12MB4452.namprd12.prod.outlook.com (2603:10b6:5:2a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Mon, 17 Jan
 2022 09:27:47 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::78) by DM6PR14CA0063.outlook.office365.com
 (2603:10b6:5:18f::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10 via Frontend
 Transport; Mon, 17 Jan 2022 09:27:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Mon, 17 Jan 2022 09:27:47 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:46 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:46 +0000
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 17
 Jan 2022 09:27:44 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net 1/2] net/tls: Fix another skb memory leak when running kTLS traffic
Date:   Mon, 17 Jan 2022 11:27:32 +0200
Message-ID: <20220117092733.6627-2-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117092733.6627-1-gal@nvidia.com>
References: <20220117092733.6627-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3fadaa1-53f7-4543-b6a0-08d9d99b9fab
X-MS-TrafficTypeDiagnostic: DM6PR12MB4452:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB44528AE37C4EF056999AB3A3C2579@DM6PR12MB4452.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eP6OdBPr/xeppMCOkOOGmfzivKd2ya9jzm4oJw3/EgHdGQJDALXH3FX4jFc7rx82yhCzuEADM0xT7E4ulzeAfBkwuLUZbhcsr6TUu0uMJmPNe+gj1IuxCI4ejddUYcO/BSt4GhFKLEUAK+A/KRHRPCZr0Dxm7A9Fl+Akr3EpPhk7GDTOCmAsz2WS619lLVt84ZCriwzVBz1QbWVS52lo3jRr3/trWLErL+jRrVE9j6P2dr+Vh7ts1qGzPQNRb8fNFZCA0NwAZJFmm7BzejVKv6DnvaKDwtiMu5FK6EiS9kbUr3AernCGZyv6vjKgHEhyVAVF/zxp5TmfACTc6y/R9myjOZ6r0dRfadIuBYsgqLMtdW2O+J8nwF2pT0PvttrcR8H2A8nfzz1jGoPJCzWrn4wXhtc/VvpDleQNIGZJ7MVwxjqK/csgtIdWOwiOFJ9/8Xrrh1fHFYGiexZMkT5LZXvm2zP03sz2wVdh7qU5PzzjcccojEEhlskebnacYAivS5HUSiid9KcWzw+mvbgnaSmhAFCal7X483CESbhBkE2ljHep2w+ndxi/vy3PLuq8M1CB13klGVhoL8jv0H843k+QNCJV8nhaGREDJU+xuQSQVFYq/AHPfQz1Gi+4KareBYF6bqpAotTG1F21+uAYJiAw0rBwamgRXCpUiXoF7tEU4LeTvf2cmopESTCaAHGDixbgS6nZys9yhOn5EftHZ603JErWP7Ad6StN6MHUB9W5+NvEeYBP8JcORXQyUAB8x9BKdS2K/KxSKa0kBcZ5xCZu9R3W5Uk6+0RkEONaLlw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(40470700002)(36840700001)(107886003)(4744005)(47076005)(336012)(426003)(2906002)(1076003)(54906003)(70586007)(70206006)(36756003)(86362001)(36860700001)(356005)(110136005)(40460700001)(5660300002)(4326008)(316002)(8936002)(81166007)(508600001)(7696005)(8676002)(26005)(83380400001)(2616005)(82310400004)(186003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 09:27:47.0374
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3fadaa1-53f7-4543-b6a0-08d9d99b9fab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4452
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is a followup to
commit ffef737fd037 ("net/tls: Fix skb memory leak when running kTLS traffic")

Which was missing another sk_defer_free_flush() call in
tls_sw_splice_read().

Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/tls/tls_sw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 95e774f1b91f..efc84845bb6b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2059,6 +2059,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 
 splice_read_end:
 	release_sock(sk);
+	sk_defer_free_flush(sk);
 	return copied ? : err;
 }
 
-- 
2.25.1

