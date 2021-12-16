Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441E0476D66
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 10:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235361AbhLPJ2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 04:28:43 -0500
Received: from mail-bn8nam08on2070.outbound.protection.outlook.com ([40.107.100.70]:44257
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235370AbhLPJ2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 04:28:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mjt45cpxiil02yHFtCshSQEQy1dn9hMrmyIdlDAmPkHOvaEaCMQUZY46PSA+bmY3xQeLymIlodHIPQbpTUsgkhIxI6lceBxRGor19QfGP9n12COWTo0gAiJkYUkYyv1peLs3vHMywyhJaQR1YOIezy6PRt+KDOR8D6yLgd5PD5Q+7ynksG9gc+b+nh/rtOaV0RYp9vg/LLqXiUmYqLEDvjJn+rxx+imz8ZAnqgGcuZ/v0jjumckZvLCc8Zzrf3WX6oRwCmpog9elApmlySp/vo6z50WoUW10Wo6OAPS22vFY/1aSwbArg9PNMck5AmL//7tNZX+Ya3VOenl9RA9Lyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wHMpq2G8xiS/OrJbFWjHlhZiuXZ+xZDQeBBq5MutwAI=;
 b=GK+b3+HHx3GbX7bGd8DeN23j5BbJ5Iwhd9wvYlUMHQ4O55oQwn6hvw/8z9QgQg2OV2kC94nbHW7ozii8YY5bn52oF3jecFLoQq4nvufrPenWtEbhKZJirGvHvldiDhO8ERBmnFnFoT09/m+IZ90CL5pbejouSrH+oM2xWEuDhj0Z9JO0g5M3DoK6lNymC+Z3m+4eLOC5ErgrvjYD9Uzl7SlQvA+Jx23NvsYgzFbDiKrOBoxc11gfJuNB9ciiRdiKPuT0yihkwLZbII75M/ZOLTbn7RnHRPGbTRfz0ktQ/3aZiSWjakJ7YxR4c40cv/NgD5nvc9ESdsyfthGje5qcbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHMpq2G8xiS/OrJbFWjHlhZiuXZ+xZDQeBBq5MutwAI=;
 b=saV7oIkrTFhRMPhtVep8bbMYIgjQuGiX1BLMelyunSf2Dvt3faRk6xZlDALVPBtxrvKaeJPDbOTBx+Czx2rapuC9hnqeJrwGYgvL9jChlW3yCPi28qAPei549t8LAXmis3DWJlMuX4dQNJkVWL1Cm1tObnvmR3Jp7LCwItNZ1Ysn8+axTJNEyzBxl8i3u4etGLHzwXfSQvF6zWpIhsOP/kEi2TvE5DxfaxBCI/uc2B0Rnrji/eeL/ZnJegisBAvZaoFcUpDrVDa7ZfgO9ZyN9NhWl2yKGJBsykg3xSE9TcpcbFv0OcPr7XSUr7sKj2LJBj/ZfKRSiQWecHzrWUtZhg==
Received: from MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14)
 by DM6PR12MB2841.namprd12.prod.outlook.com (2603:10b6:5:49::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 09:28:38 +0000
Received: from CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:115:cafe::69) by MWHPR11CA0028.outlook.office365.com
 (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14 via Frontend
 Transport; Thu, 16 Dec 2021 09:28:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT006.mail.protection.outlook.com (10.13.174.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Thu, 16 Dec 2021 09:28:38 +0000
Received: from HQMAIL109.nvidia.com (172.20.187.15) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 09:28:36 +0000
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 16 Dec
 2021 01:28:35 -0800
Received: from vdi.nvidia.com (172.20.187.5) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 16 Dec 2021 09:28:34 +0000
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Gal Pressman <gal@nvidia.com>
Subject: [PATCH net] net: Fix double 0x prefix print in SKB dump
Date:   Thu, 16 Dec 2021 11:28:25 +0200
Message-ID: <20211216092826.30068-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0caddd5e-7899-4fc6-5944-08d9c0767107
X-MS-TrafficTypeDiagnostic: DM6PR12MB2841:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB284154E8656D72D32AEE60AFC2779@DM6PR12MB2841.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:110;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6x3drMIk35JEZjJ6UN+42aqtS4OqZlnJJRFr8rJ3+/3tZBXZQv34ukQnaoLn3z2wkC/KsJcEWAaBrW0AkFv29Xw0fGD3TWtKlSczcZ4eMej2qgdY2QeFrEeyj3aAifRTCiUr4s01+ravTeVm3/i8yviXvxMcXT2PXIacBaZG9jhDbeAhJvV3uSIR/EgQOkRWaNf5cyBomqyJCXtHEeEYIfqmzhXAt4wx6hc7OGWQmI9tA0Uo5e4jImgj6O2DzuevLEYkD13XJ6Xq4assHkuFQlGqiyBv/DUT502WgEWp/kYi5ot3vq9cvGHtBJiKefYpaV5LuozL18x/LGYSyFHCQrS1KWYf1jw4fH2ZnSRnSnQsc0Ke9UvZx123q4CBmUgBWSHBdQ4Hp28iJykUtoiyaf36ac23DzWLH8osY14moYrdjMEfjbry8g4mbyITTev/65WDBfc0gcK0vACUYCpg2HBvlF/fQzDFvoP4UKYH60noFc2o430c9PCLH1cJtgWzi9rll7Seq11v8eibxWEaiDkh13PamuXXcWDLLnUEQgXFUeeyjZZ2pzr+MTuYfCoZuvW69r3N6Yyp1x3+L+ofoULHSVYP5ivSi1Brz1mMFlgvYwMEr3dXSRXN6M6SiHzqQXeYgKmG6Hy3j+aGlKqS5/CuiCJLFVqpN7lqaq5VJ+y4HwMXmtEM1jlW+UeFfIq3Vko1nK/ez2GPEwR7SM14sZc3WAERSxMQaQZjnJ9ppXJgXG/j5d7050X5OlN68c+8HoCyTYf+Rnd3sMgGz/rpI/bkMTm/egLBiATU90gnrERUoG3mNuc38DiHsPgH/r9lQAB0NI0+81hqMIstvGJwmw==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(6666004)(86362001)(36860700001)(7696005)(1076003)(70586007)(70206006)(5660300002)(356005)(81166007)(4744005)(36756003)(2906002)(107886003)(2616005)(4326008)(26005)(54906003)(8676002)(110136005)(316002)(83380400001)(508600001)(186003)(34020700004)(426003)(82310400004)(336012)(47076005)(8936002)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 09:28:38.3679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0caddd5e-7899-4fc6-5944-08d9c0767107
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2841
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When printing netdev features %pNF already takes care of the 0x prefix,
remove the explicit one.

Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
Signed-off-by: Gal Pressman <gal@nvidia.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a33247fdb8f5..275f7b8416fe 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -832,7 +832,7 @@ void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt)
 	       ntohs(skb->protocol), skb->pkt_type, skb->skb_iif);
 
 	if (dev)
-		printk("%sdev name=%s feat=0x%pNF\n",
+		printk("%sdev name=%s feat=%pNF\n",
 		       level, dev->name, &dev->features);
 	if (sk)
 		printk("%ssk family=%hu type=%u proto=%u\n",
-- 
2.25.1

