Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD0835D995
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhDMIGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:06:33 -0400
Received: from mail-bn8nam08on2086.outbound.protection.outlook.com ([40.107.100.86]:62554
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238378AbhDMIGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 04:06:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF2+jGC1ogHVmNjtGCVSyjimpvOi7ltD6U8KhJmZMAcqZ42WbvWVdhE+v8amPrIWR8rzyZXDbwIbWu17euoo5l3KgZTp2DCaYemIJ8S/WdPkKeXVaXtROAXhWQuhHpBpBtY6F1k/yLh9tpn+q0hQRdeqADYX0fH8rGq+j5UlzGhHlfDkbgw1htbt0nfDCwvkJnxIm0g8J/1xkT0UQ40LHvmqlGQG3s2tU0/wm48BNLlleO8+t8YtOltXM8hE/ehIBTfsaCYSRUrTAijrg8wBCzqL+tYORNIlgWoOnMoAsR09H2DQIVv227EytNA1hP+LfHz3AmFtA4qhgbDOcfhHag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmhXM8l34fZyoC1DTPQLz8KnxUR3Q3bsumDsm4MeGAs=;
 b=Wm/wpWIrpS6pHDU3r8DzKZeK6dWM2PCbRLL9yWOlJ4Q6azfv9LiYs5MbNdu2P7haS7nsPGQlz0dA9jj+FU1cNNVhKgHjihsIhMoVd2qOBAoIpYx1kf1mzAiG1+fQ9Fsn4J506qRtwVnluMfgQqeiLTkNrjlxZZwaMxmnCjEoZf5o7HnXoFP1+eFVIqKSTRMXmobe5pfbERgQJJ3b0UAQSY2M3Ufgfhc0KtFB94+YlcYkC/fIAoKFxmpd9O+61q9usQAq7i37FHIciyF7CynANbzdb43XQDOcRGR33lgVL9/plEBe0rIQHNp9pK8wErQBBMp8nkctE8ft3G22bE9Hhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmhXM8l34fZyoC1DTPQLz8KnxUR3Q3bsumDsm4MeGAs=;
 b=TIOwIKgJPj/cmdfupv9+eY9fObztTTNrTOk7tD02OSJvoAa0q9rG7cjgKU2FyvjQKz0Y8AbEYgrzimUj6aNvN/b2BoN3bvoXkq/rxO3Qv5b9ztIDHwGXSZzHGF1aFNXHOKvMlOKQdsEc0vk+rmIgipash0S3J4FMDtHkfWZf2C1kIMARiU8W+mJgH4v5X6cvpzQTqKw9YVURgSezDtOAEd+kTKEzVXohAVlv1n0rkgMLJttMZ5EHIcjsRn3irqnpQHyUMsp4dm+Yfw1Gr8CAXqapGU4lH4L7h+EJVjKRG3Za1WuHS7SCu0L0r1+d6WntDOeEDs8gPqZTBbNy+PIvuA==
Received: from MWHPR1201CA0008.namprd12.prod.outlook.com
 (2603:10b6:301:4a::18) by BL0PR12MB4899.namprd12.prod.outlook.com
 (2603:10b6:208:1cf::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Tue, 13 Apr
 2021 08:06:10 +0000
Received: from CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4a:cafe::e) by MWHPR1201CA0008.outlook.office365.com
 (2603:10b6:301:4a::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Tue, 13 Apr 2021 08:06:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT066.mail.protection.outlook.com (10.13.175.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 08:06:09 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Apr
 2021 08:06:09 +0000
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 13 Apr 2021 08:06:07 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Oz Shlomo" <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next v2 1/1] netfilter: flowtable: Add FLOW_OFFLOAD_XMIT_UNSPEC xmit type
Date:   Tue, 13 Apr 2021 11:06:05 +0300
Message-ID: <20210413080605.2108422-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7b5097f-229b-48e5-7334-08d8fe52ff7a
X-MS-TrafficTypeDiagnostic: BL0PR12MB4899:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4899F1197F4C6B85F0DE0D15B84F9@BL0PR12MB4899.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sjtmtBjVuexXFm6BCvTC7gbuhRBeE36Hql0c8QH1Xy1IPxvpvuFqbKu4HR3RbMSTE765IBKyDm78VRR4VgBgqffq/yK7r12DLFi8hQ5lpg1GIfg0VVM3khdho2hRTVw6tMssgKTOW4Yk7CrNKGiGHlHu7cuv8fn2ZnV0O3XXUaH5ZuV8V/fv0PBxB5IGn211HbZ8W4Vt14W5w+uScglNJyWG3xjS3x4fpjQRzs/aABj3ZEp8sfNbErlsteKw7Fg94o+njDbJMY4BQPlpdp3Oc5NKk9Vr1L9SgiMJvLcrFzNpRy3xZjD+TOGAsOf6VweBaVPxyxfFgL+AVOmc68dJFd4f/L/0AvKWf5TG+rfg9EMLgIwPl0pPXGamBKalRwQ6sZJXoZxsvDHUmsg5bwHpWk7of1xXzIWSKuGZZCsPQKFcP9KRd1aTB9peaIx8J8tZsBXHHjm2rUUSipiYIZw5qmdjz+rQI56rHicmkI+ICTKweejczqMM+QXzpzN+JZoVOt0dHOCN5DilTDQIzhmpQIGwZFY2KSyuvsYIdNNbMYEf5g/DjA/6Q8z4An4LiIoAAaljc4jgWKeP9ZdVcs7/yO66tztNhQPTKf1mLrfP+tqmQR6MGAEAGNCJbhxC3qQaB9O9wZqE9P032Tjk/jbJC2pkAj5d8ZdjNnhBD3v+vX0=
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(396003)(46966006)(36840700001)(70206006)(36756003)(186003)(4326008)(83380400001)(26005)(36860700001)(70586007)(478600001)(8936002)(47076005)(6916009)(7636003)(2616005)(5660300002)(1076003)(82310400003)(2906002)(8676002)(86362001)(356005)(107886003)(82740400003)(336012)(36906005)(426003)(316002)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 08:06:09.8714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b5097f-229b-48e5-7334-08d8fe52ff7a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4899
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It could be xmit type was not set and would default to FLOW_OFFLOAD_XMIT_NEIGH
and in this type the gc expect to have a route info.
Fix that by adding FLOW_OFFLOAD_XMIT_UNSPEC which defaults to 0.

Fixes: 8b9229d15877 ("netfilter: flowtable: dst_check() from garbage collector path")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---

Notes:
    v2
    - add FLOW_OFFLOAD_XMIT_UNSPEC instead of still using neigh as default and checking dst for null

 include/net/netfilter/nf_flow_table.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 583b327d8fc0..9b42c6523b4d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -90,7 +90,8 @@ enum flow_offload_tuple_dir {
 #define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
 enum flow_offload_xmit_type {
-	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
+	FLOW_OFFLOAD_XMIT_UNSPEC	= 0,
+	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
 };
-- 
2.26.2

