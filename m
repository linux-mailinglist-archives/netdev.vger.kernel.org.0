Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BAB4904D3
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 10:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiAQJ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 04:27:54 -0500
Received: from mail-mw2nam12on2077.outbound.protection.outlook.com ([40.107.244.77]:9425
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235668AbiAQJ1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 04:27:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJ5YNl31BEe0AWGiTYjffqvFVY1RV2yFzPsEcTzL6Zx3DoMFC7b/DPpD0TPMckkZkFh6+b5CSMuZYkEZdTHp8f3Q3wDeZuYv9798B06AV5Yi1mD3ZVMDtvCczk22kohw8hoYQIbNG3xvQetajPUhZn5SL3EoOf3V60PqfvPeJivpaumXHWHBd3jyJ3DBlm/o+QjOydIzK6g89kANZNRb6sEtjVZfEwWQda7akjcGJDWLSnan9BcKV23tAD9t7afmRbIFdynzexWMuR/JOxjQVvc4pNnzbk0Nqabg9CYaNoyO+jwYe58gQrmWorjvUK0CHE4BVcICG/uaaZvj/uSpRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RTvX/pAeomt5KO3TS2qwRk4VC4UhwZ19i2gMSGSARl8=;
 b=YCoJh3MLfjhr5JWRhfH5sZAmEtOCRWoQkkAJ7QZ48r1Qq33ywtsaOoGA3oph1VDUcN6DSiIz1NKubft4od4FRgC0NsD+RgERHgCgNBOZ5d1pxyjGvXF6yfOiklkjqQIZ+WPV1vTyiu4cEsOXGEMF2KvepnAaRPcWa4WPcdsysWMbiaffnTskwDJMmDYqJ+gTxIkrkqSXyM7dEdpcoaJAwBkY8erA3Vk2lHcREv6tWI2e2g5AZGzythULAQAeHUIC2ppQGvrtwxJS2WHEBUi1QcK/uXB6XouWHj1YruBxHvL2LXCD7F3d8IxoOR2qhV3XO+qDREzHifYUc+0Fo7zVcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTvX/pAeomt5KO3TS2qwRk4VC4UhwZ19i2gMSGSARl8=;
 b=GGjHxDxFvAfJj4otoUxtRsKPFS/WmLh27rmpdHGLHfw1+kT9qqIgA1CPTto0nAMR9jAJq4//csKyjMTIq7PA9aQ8IcybHrDxhh4ubRmq1h33TL/44VNhNpzxc4YWT5DWivd+4av9hZC/3e0J5q/SFxv8DPpa40B+b4/EAHz+N+yKOFDkt06hEY9Vh2g/P3MpBFvdRLcu9xZDVOBXngaYWEMmEKXQvY3FLlcRIRXfcx2czXD/wNaN1w4jO6bzgovmwDKr0L8+2Oy2JOsFpmBbQ7WzincSe9bdzzfjeUvikCBwMYl8mgNK8PNnpiiDEMgrr2hRWhqvgRsn3h7whY6rqw==
Received: from BN6PR2001CA0033.namprd20.prod.outlook.com
 (2603:10b6:405:16::19) by DM5PR12MB1562.namprd12.prod.outlook.com
 (2603:10b6:4:d::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Mon, 17 Jan
 2022 09:27:52 +0000
Received: from BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:16:cafe::3c) by BN6PR2001CA0033.outlook.office365.com
 (2603:10b6:405:16::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11 via Frontend
 Transport; Mon, 17 Jan 2022 09:27:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT041.mail.protection.outlook.com (10.13.177.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4888.9 via Frontend Transport; Mon, 17 Jan 2022 09:27:51 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 17 Jan
 2022 09:27:50 +0000
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server id 15.0.1497.18 via Frontend Transport; Mon, 17
 Jan 2022 09:27:48 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [PATCH net 2/2] net: Flush deferred skb free on socket destroy
Date:   Mon, 17 Jan 2022 11:27:33 +0200
Message-ID: <20220117092733.6627-3-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220117092733.6627-1-gal@nvidia.com>
References: <20220117092733.6627-1-gal@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 804853db-f357-4d86-f81d-08d9d99ba296
X-MS-TrafficTypeDiagnostic: DM5PR12MB1562:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1562085C238434227BB2BD91C2579@DM5PR12MB1562.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yfDxjrjFh6tnXxQxxVBtjM4vPD+chIVzKcQgXK6pA5vq/VTcpIuvoqc5zxqQnxbM2ICAk1ER7TqIvwnv3P/FuoUef+vzlvyKV/pkAKVpFYQjBOwKPHZqHK3NbnwD216NePQ5NNw4kdf/KJSq/0GK/VakAfVZ724fhWIIdDAY6m3vE93fFIX1ANHtGXCn7EHXIW7Rit1gRhf3xPQluvJooeE+Zk/Z5N27C3njn5YGWQQ69Ly/ZexKyXrLDytqwhAj1b7/8jU97ftq1+/n4G/W8rkfippv651b0izFbHrNrqks3MNEO7ALX7+kfRp7qSG3sxg+NLaQzCKX/z3JWBsGpbw7PiS3gaJLq32UL5Q8e/002lOGJ2EwYjF2BXTI8bhUSC+iaPDNrtXvqC4y71UuWgYdtnXH/zb6nk5nOfqsUEQ7D6i5o8HQ/cVu/mRsNBSqLSGipyTK4ZaDgx1fOprUKaN35RnurFszjhOxLYCKz97Z87ftkaRB5R79F0jr/ysZMPJWTpkoKhKbqwYEkgdUqM7JPdSgKRPKWFSlkS4Oulzj6CkUKSRny26qnnN6RwlBdGAJd1tti94CL9oYj9c2WKkROZ5fBWiMWpZQf23Z8trTbrqbvqoa6eUSEjXXWAqWpyXot1wgcHXRbrVCuw0aI5XUiZb2m183mGrqjJov7t7rbNzvUm2Ak9/VpJbrxQHJzUpWEYYTQQQGY8fUAadcbPvTIL4lUIDGHq1MB6Yh+PRmxEK68FkGMKAh9oVxn2DbEsLgELsfHpqtSbdIQ0alxTDI8THahBezKn96TD/y1V0=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(36840700001)(46966006)(6666004)(1076003)(5660300002)(7696005)(356005)(47076005)(81166007)(83380400001)(86362001)(186003)(26005)(82310400004)(40460700001)(8936002)(107886003)(508600001)(336012)(2906002)(70586007)(2616005)(426003)(36756003)(36860700001)(316002)(110136005)(4744005)(70206006)(4326008)(8676002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2022 09:27:51.8878
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 804853db-f357-4d86-f81d-08d9d99ba296
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1562
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited Fixes patch moved to a deferred skb approach where the skbs
are not freed immediately under the socket lock.  Add a WARN_ON_ONCE()
to verify the deferred list is empty on socket destroy, and empty it to
prevent potential memory leaks.

Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/core/sock.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index f32ec08a0c37..4ff806d71921 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2049,6 +2049,9 @@ void sk_destruct(struct sock *sk)
 {
 	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
 
+	WARN_ON_ONCE(!llist_empty(&sk->defer_list));
+	sk_defer_free_flush(sk);
+
 	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
 		reuseport_detach_sock(sk);
 		use_call_rcu = true;
-- 
2.25.1

