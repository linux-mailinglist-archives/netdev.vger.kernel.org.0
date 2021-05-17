Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBDD383C09
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 20:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236922AbhEQSRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 14:17:33 -0400
Received: from azhdrrw-ex02.nvidia.com ([20.64.145.131]:53249 "EHLO
        AZHDRRW-EX02.NVIDIA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243087AbhEQSRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 14:17:30 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 mxs.oss.nvidia.com (10.13.234.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.858.12; Mon, 17 May
 2021 11:16:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bouWyWdpRKcHLkw0Cna4ilJZeC/MEnhdFKDGMn3D4CBgB5wJ11qakW0PcM7p1ycbT0K4ld/tJOZIOG7w5XXxyn8cxnqpUJbiLh44jqIKtpHTqgi3HdYwKkMr9o/Cihi/xyW7AvzcufH/lBm7Yp3lLvu6BBfSk7pCJa/hBlbD6Xh9KDyVNkli32nQyVXhXag6bEwRCie/k5pQ81uXzgP4n+3B8dj4bq91dB7vmvzswa2dvFOj3aVL72wuu17u1Aq90kIvmWrBFW70B1MTux0kQQNDMOLVwsVUatiiZoAQQWGiWeJTIwqNmPwOxMvbBS8ZfZaIPFZbVpWvQ5oUn+c2Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9XfaAhe8svnnA/ik/y+VVKQ086Ae6psV6rIusF5JJc=;
 b=YNv2akd+bJDVYOZAUqktjYJr4+msFBF0Tf8Y9jdx0/o3sBJDLSGUIRygUpvx40E7bwhDfD4udxVbbZ8Ae+ZMcz7vHpM9ywonoMsDxPFl3XQzjtkLyz9tx3gkrGbyBON7mPVRxAalbObro3jGkeAjp2PFVw6TDtwBmcbVSCGRRZdCVNjQLu4M45xXPTb9NxemOpkR+z5Y0KzwbWpaxSm9yDZsthPORDZfhXXiTE9IYNHNBgo+IuhBpPMhBnlb3ZR7Ck4SaTKkgVICX9sglaCopojAG8p25P7MNm94OXDcS4kA5eVHtroaeaCvqtBg9GhnK4jhTw3xw1P7VKx7i7P6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K9XfaAhe8svnnA/ik/y+VVKQ086Ae6psV6rIusF5JJc=;
 b=RdMh1k8NzxGUaNnII3PwENaB76+5FMIt+hRBaRWERMswsAIPJfeHNGnHUYz2Jwsj3HF+1elGsNOFlGeXEZ057rhBis9Qm5ZU20HYJfk6gbg2DhVChqZZ5dHvXhafQ0iAy5betcNEcgila2RT7X26OZz0S0/9Q4XnFmZl3gwgyBBAaVE0zBP/EjVSv3OXHfGbVJZQGILWGYd4gXzv6qMh3AHPBrKdmugqmagO5QWxYXBof+gTbeYS5iXBzUti4HXbwxWLAqh+HC1/Xt8cBresn2ykhVwvabMxzu1AfUCvSMAxiAyrTnGj2ajYwb/yEhiOuICj5lvuv/R4pi0FkB1W1A==
Received: from BN7PR02CA0022.namprd02.prod.outlook.com (2603:10b6:408:20::35)
 by BN9PR12MB5384.namprd12.prod.outlook.com (2603:10b6:408:105::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Mon, 17 May
 2021 18:16:11 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::9f) by BN7PR02CA0022.outlook.office365.com
 (2603:10b6:408:20::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend
 Transport; Mon, 17 May 2021 18:16:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 18:16:11 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 18:16:07 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <petrm@OSS.NVIDIA.COM>, <roopa@OSS.NVIDIA.COM>,
        <nikolay@OSS.NVIDIA.COM>, <ssuryaextr@gmail.com>,
        <mlxsw@OSS.NVIDIA.COM>, Ido Schimmel <idosch@OSS.NVIDIA.COM>
Subject: [PATCH net-next 01/10] ipv4: Calculate multipath hash inside switch statement
Date:   Mon, 17 May 2021 21:15:17 +0300
Message-ID: <20210517181526.193786-2-idosch@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9aa5fce6-238f-4a9a-2208-08d9195fd9ce
X-MS-TrafficTypeDiagnostic: BN9PR12MB5384:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53843D68DDEFC17CD6656E21B22D9@BN9PR12MB5384.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cuRqWX/m9UPUWIMzLVMEEPYTISiyQ5bBxoKiy/TLYid29oQbfZ/9KwNZxBZRiY35SMDazVUUuFMvqL7OULDgw8ERoYvUocV5O47mjRu8YumWfnadwJOGIEM0z/l54V+U5SSMZ2HkfPFvPoOyHj25Esj3Mo9KBzqqBvSbAakNV1XaQ0KrpPiRVPDpYR7U8gzhOZiWUu4HIg8u8/tqakzrtgBxZ12FS4U8XuKJjybVWT6qcIhWaIqhMjIkdFZUoy67Lg2BRBOEac7f0XowPjdbO40kTb+txQ9effvnuZLSXG5n8zTEty5gfunrTLzCne/7x84xayV2FeLw03ZRXhmI605AamCM6C12aY40MPN060d1eiWGWGz06mlXxotyePtEMSvcvBaBG01863/BkcpbsIxfgy7kUohFmYsS14djt+MxZvRr/WOk9QoQog9R3MRnduklmw+ix2obo1O2SKOxPTbR5H06EgYotIxdAvjHgpwVlqt0+iRR9OaDHlDaCK/P/yMy25Zmi1lxXTKkQmoSaS2U+LwpbCJnMQHDkYKgO59YzW1PT87nC+qudGRsDZGTBPE8o4keEZldf2bOhA6WtatTdGKPOq19kRWv8felwRofkMwwl1bR4LVfzSZwBYm4PX5gPCq76TKgd+Z4bdmIgKp9dcoSIeFHqpbwjvDnEts=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(346002)(39860400002)(36840700001)(46966006)(6916009)(2616005)(83380400001)(107886003)(316002)(36906005)(8936002)(8676002)(36756003)(478600001)(1076003)(54906003)(16526019)(70586007)(70206006)(426003)(82740400003)(6666004)(356005)(336012)(7636003)(5660300002)(36860700001)(47076005)(2906002)(82310400003)(4326008)(86362001)(26005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 18:16:11.4589
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa5fce6-238f-4a9a-2208-08d9195fd9ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A subsequent patch will add another multipath hash policy where the
multipath hash is calculated directly by the policy specific code and
not outside of the switch statement.

Prepare for this change by moving the multipath hash calculation inside
the switch statement.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/route.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index f6787c55f6ab..9d61e969446e 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1912,7 +1912,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 {
 	u32 multipath_hash = fl4 ? fl4->flowi4_multipath_hash : 0;
 	struct flow_keys hash_keys;
-	u32 mhash;
+	u32 mhash = 0;
 
 	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
 	case 0:
@@ -1924,6 +1924,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 1:
 		/* skb is currently provided only when forwarding */
@@ -1957,6 +1958,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.ports.dst = fl4->fl4_dport;
 			hash_keys.basic.ip_proto = fl4->flowi4_proto;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	case 2:
 		memset(&hash_keys, 0, sizeof(hash_keys));
@@ -1987,9 +1989,9 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 			hash_keys.addrs.v4addrs.src = fl4->saddr;
 			hash_keys.addrs.v4addrs.dst = fl4->daddr;
 		}
+		mhash = flow_hash_from_keys(&hash_keys);
 		break;
 	}
-	mhash = flow_hash_from_keys(&hash_keys);
 
 	if (multipath_hash)
 		mhash = jhash_2words(mhash, multipath_hash, 0);
-- 
2.31.1

