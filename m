Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110DA1E8DD5
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgE3E1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:37 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:36101
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728787AbgE3E1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgA57vOc3Kukn43oDlxPf1h9k8MqSuzOHwPOFT1DbZ4BB7UZV3Bo3NrI9LATUroRLOvG0uSwT5XRxmbqPMpK6qNAnFa60W57PrlCvhwGqroLDnnBNfKhr5A3a+tYp6FbHAcakOxeRMtWOnLGuXhv0S+7TRuzBEXltv+U7exJgqOYTncjMtYs9487of1wv3sMhwukJBxat6ttSu4XVIIXPBGZlk9acWTxj0OM3N7hflZ+34luBq7ErG/pNHaRxDpBqTe+QrsEhk2D2xfQEaTg91oVjXVL42qY4M1gGEFnV7dN5sPJ4vV3BpN84FKHjNWQayo/N3UvpVi9RRAXyiF/Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rey+scZ62xMoGa4nUwm+wzPpdCIBoI8mpwLpzwSJFyo=;
 b=n04EJjTO7UPi1BoSMybmlYhqUAmBv3G6nO/lip+eMXwwoUlcNWKUSOW7XKZhtrENo5nsY1q469Xc6nD5r7lJpr3hhLyMod3zqnupxO5PYpNi+LTd4qC6ytHU0wtrS43NdpHNIU7JzQDo0Dl8Mc0vglUopr4oriZeknhwvA2go518uCnkpKaDstoYSXPOVzAuT9J9HAmK0RLYM8ILl1z3mwbkypsKTDkbquC1fZONMprrIYbeppbWVMFzPzZKZidDDd3mrZeGaLlrF0xIWBBIll/S6olqSKM0qb8JZAWsnpc5JS4th06bMsTS3qg4+P3FhWRwq8ORdD0j0P4B30Jyfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rey+scZ62xMoGa4nUwm+wzPpdCIBoI8mpwLpzwSJFyo=;
 b=BbtLDPE7zmqGvAO62+QlHMFZ3rPAmQgQx/+LnfCobUDJoGryl7K5R8XS6H5yb5ZZJafJWMiB4PhJOLAOpyye3pdM91qL0KOjnJBVrghye9NlF5oKkCZyG5+nZztIWAW0VaDscXh6LpSpTj9P4bRtoOPDq6pWwpMb0gDBBxAzAXc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:27:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:27:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: en_tc: Fix cast to restricted __be32 warning
Date:   Fri, 29 May 2020 21:26:25 -0700
Message-Id: <20200530042626.15837-15-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:27:16 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6417cb68-3ad9-475c-71c1-08d80451bcbd
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB34083AB1B32F59578B31F74ABE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Khw1q0uTmIbfa+BM4n8p3h2cyEvjSxDbWWw0Wmuaqtj5GZKxkReZNTDb8SqgbL3cgxhDszYhAJGhWFVgWdLMdx/hJ1bjvLJX6MNtKD4cp3pLxxpfoVH0zTmahplbfS5rzLSPDa4ZSalJWzcOKTwL31qjRL0PKDZ1ckYYjNQk1hXs0tpnpc06qyrVdxmNfz03dhSmCjsKX4XnsEwPJGc34blVtPsFi26sVpxAWx7t3PqHeYCeGxRTC4iMpmobs/7PNXsg5nkif2mtFT0kjDfWFuY2ICyx/xni/7LDnvvmIw4f/x0WLnioD/a7gbOQjJ5ka0YHZAD7741/YKXMAw9wHjAeFGeiqEfBgfXWpJpq3aaMbXHSBLSkqMAn1bPR2bKN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: B7OJjuwEuD4uZ78qlAnUjeRUDl8MWbpXI+YLlt38QpluNOg6h/aG8gnIErbN3s/5DL0x1hfJUakbxUp2VcxQ6TZXS8Fy7cDOsNUsvjGui+A9KfVG2uVT/j0VRDMF1JERoJjtmqS0mJfjUoOIGt7Y6JrZb/DoIm0CbiMCV5I6g7wxIvcE9FTo7GANzAITgYTV/NfqQMC48/Y4TJB84/ov7w0G8MVvkje26pyyf//3O0KqVU0pE2qJu15kIjshjOowREwZUK4Scb73dMqdcdUdNdfsprUj+w8mAltg6Lmjlyjntp3FUu3/QBWaXQkPU95OL9XBxzBe9Yk+4LIyBDYF8dn88lIy52r7+SnrQFo9lyDLDRPGeGgkH29N8GFuA+6/mVuXPxLlOOWJ4czfB6RSihYg2hNR01315Wh0coTjkj6NeVR9qUV448dx1j8Oat2bFbFDcCuS/c6C2Nrt93ePmG4AfEyHHUkUkW7z2YrOQqc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6417cb68-3ad9-475c-71c1-08d80451bcbd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:27:18.0607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z92ixXFfedDoJtcun5vbTCgnRYuCieGZfPni1Er2FZ+AaAfDXIW0BoyXMLwom+koXdrWVB6gjuiV3dFWpkk/OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes sparse warnings:
warning: cast to restricted __be32
warning: restricted __be32 degrades to integer

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e866f209f2523..3ce177c24d525 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -210,8 +210,8 @@ mlx5e_tc_match_to_reg_match(struct mlx5_flow_spec *spec,
 	fmask = headers_c + soffset;
 	fval = headers_v + soffset;
 
-	mask = cpu_to_be32(mask) >> (32 - (match_len * 8));
-	data = cpu_to_be32(data) >> (32 - (match_len * 8));
+	mask = (__force u32)(cpu_to_be32(mask)) >> (32 - (match_len * 8));
+	data = (__force u32)(cpu_to_be32(data)) >> (32 - (match_len * 8));
 
 	memcpy(fmask, &mask, match_len);
 	memcpy(fval, &data, match_len);
@@ -2815,10 +2815,10 @@ static int offload_pedit_fields(struct mlx5e_priv *priv,
 			continue;
 
 		if (f->field_bsize == 32) {
-			mask_be32 = (__be32)mask;
+			mask_be32 = (__force __be32)(mask);
 			mask = (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
 		} else if (f->field_bsize == 16) {
-			mask_be32 = (__be32)mask;
+			mask_be32 = (__force __be32)(mask);
 			mask_be16 = *(__be16 *)&mask_be32;
 			mask = (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
 		}
-- 
2.26.2

