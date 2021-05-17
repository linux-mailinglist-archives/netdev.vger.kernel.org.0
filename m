Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E642D383C0D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244190AbhEQSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:47 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53253 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239704AbhEQSRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:41 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 11:16:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OngCc30YaBvnhyRACyGQFPp0TMPfpQJav4ZtBePr907ibkpj5qiql/+5lLCVdRdslaFIPRQLd9zOAtOCmsRGvY+uId9g5Hyd5CoBtG0f9PAh5xJSaGlx4RKmXTOiLThFD6LXZktQMVUrX4ZfOYimQ+s+MMysC8rQCL/JjTGHVE8yjbw2DsSHjH2aly4l4NH2e/B5qd1LjSZJRHd2QUNo/bduZXJ9TKiFLpvd5Qa2wB/zplzECrtfnD/f58ngvSazdpAh8nC8wvAnnPmYcdq/AgEGAliivmN5scso8Pv41nyF+Hcujj3L3hzAPgMeYAY5qbMQ5TKUVGlEi1HOi+nldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Hb7LJhqYxag4p4A2hyy6aJYl3wSvPqzaD5cruVPeUg=;
 b=lPLmcoPU2AFMb3P9QMsms3pJRmKxlX6wNXoeQBbQWCgniGUGBeEufvroSfiJ3s7cNDJYbVVCL/DuDh3ZbKbIpfd5TwkuWC0GJtC1W2tlSQXer0o2b7R/sklhHJHpNnoUzoTdQV8yXJhbBjTopi9v/LkWoeiQyxoMtxgBdwHOt40OynC8UZaL78qkKHhK0NLl230yG7OW8tfxo2PpxWt7L9lmHWRcikJggydaAXWTbQtysXhOGNlxZ/5vIvG29+Y6zYW3Iv77dwEmKn5ojrn2TWVLiLcSYsWRtUVTMmS3jwhmQP0GYpuytDNxFGSbXRdUpQCw6wQrP5l5d4GwOJefPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Hb7LJhqYxag4p4A2hyy6aJYl3wSvPqzaD5cruVPeUg=;
 b=VJH7Ogb2pk+OZnJOFdPiCFBLRNtKLQQfCS/v86nZxK5jIzkI1FiGyK6VFD/YhpCxMGWUOJmFWMDmQeff63EdrynOcQGxiA8vG0Id5nqmUiDvjpsezAchs47dOUIxhvHQZn6Wvqt8k72vqHsDRs0KTR+zuZ82Y6vqgahttI6wPDS/6MejOeFzKv5fYqnvpRScwfarHhzMqlcpO0gVmCcnlpUbeGr0C1liOVVkviSDGnIRlaT0o4eurkMZdbyyL7Mg4Mad/U6bP0KCXswpVLczdTF8qL71uWAxIl+y5sTsDKRUNsJBnbGEL+xjH0vXs9PwZOhwXfWQT+depWaX1jWNzA==
Received: from BN8PR16CA0010.namprd16.prod.outlook.com (2603:10b6:408:4c::23)
 by BL1PR12MB5206.namprd12.prod.outlook.com (2603:10b6:208:31c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 18:16:23 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::65) by BN8PR16CA0010.outlook.office365.com
 (2603:10b6:408:4c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:23 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:19 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 04/10] ipv6: Use a more suitable label name
Date:   Mon, 17 May 2021 21:15:20 +0300
Message-ID: <20210517181526.193786-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517181526.193786-1-idosch@nvidia.com>
References: <20210517181526.193786-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1792ce9-c2b8-4a76-e938-08d9195fe0f7
X-MS-TrafficTypeDiagnostic: BL1PR12MB5206:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5206714E3BF259A5FA45173AB22D9@BL1PR12MB5206.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:1051;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mG3FHis80xc/D+ffKGbcLCW2ccXVFsaC3hKRXnw+nfp3MJiOS58ywflW3D3OCsWRkGhb7GGyoWSi/DKg1eK1Nhdlv4Xomh80SVc1fIvInAV9OfLgXmQLAVCE0ZzsAKVfK1wN7pICvpRd0edLbQH0cXOWB5yoq7yeIWttwLUievHmwoAJ4uG7n41kQ6n8qFjeG1IWXIw5JgV4zpHo79vIiCNEGXxMCWS+zSxrDWPbnI24xgq7blhDIclJ8tbB+HxWtNp3ZZdXfFTHvpk+Lhl22E8PMENQ5jgOeDl5vCsAzGexRZYi3DVJ+hwdy/HWqgdYS8KWStgAO+U7SpfPTsI2+HnTZYkRAGauV+oAxeCNNBNoVirWNmKmuhS4CMylPn9p43CH9fXhB5MThki1qvrBW3iGptYSr+7mzOjwmz8ssxbvnsO3KqsrU9RtKQyt8wmmEiiiwzvExpJLw/tPifmv8NrbsAwzgbXNzUWp1kQV9lxyFyDvFSKaVeoyn7i42boFVnn4z2fPyZM9cspSuQRHXIjNZ0VuaabUAzk33zjGdfNsVzzvivbgInpdPZjJH0ve3rPN3jKhqv4I7TH3+ZeGdhRLaHsULlOHRddyzfXu7qrxmfQVzBmlrDnCuwrOzJPnhjNVjxWYN4C7j64NyRYZd7Drwqv/IvUPhL02nW5AQNo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39860400002)(136003)(36840700001)(46966006)(426003)(83380400001)(336012)(186003)(6916009)(82310400003)(356005)(2616005)(36906005)(1076003)(26005)(2906002)(54906003)(47076005)(36756003)(6666004)(70206006)(86362001)(70586007)(8676002)(36860700001)(8936002)(107886003)(16526019)(7636003)(82740400003)(316002)(4326008)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:23.4218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1792ce9-c2b8-4a76-e938-08d9195fe0f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'out_timer' label was added in commit 63152fc0de4d ("[NETNS][IPV6]
ip6_fib - gc timer per namespace") when the timer was allocated on the
heap.

Commit 417f28bb3407 ("netns: dont alloc ipv6 fib timer list") removed
the allocation, but kept the label name.

Rename it to a more suitable name.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/ip6_fib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 679699e953f1..33d2d6a4e28c 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2362,7 +2362,7 @@ static int __net_init fib6_net_init(struct net *net)
 
 	net->ipv6.rt6_stats = kzalloc(sizeof(*net->ipv6.rt6_stats), GFP_KERNEL);
 	if (!net->ipv6.rt6_stats)
-		goto out_timer;
+		goto out_notifier;
 
 	/* Avoid false sharing : Use at least a full cache line */
 	size = max_t(size_t, size, L1_CACHE_BYTES);
@@ -2407,7 +2407,7 @@ static int __net_init fib6_net_init(struct net *net)
 	kfree(net->ipv6.fib_table_hash);
 out_rt6_stats:
 	kfree(net->ipv6.rt6_stats);
-out_timer:
+out_notifier:
 	fib6_notifier_exit(net);
 	return -ENOMEM;
 }
-- 
2.31.1

