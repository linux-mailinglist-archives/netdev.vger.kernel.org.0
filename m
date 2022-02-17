Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EABD4B9AA0
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235369AbiBQIIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:08:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbiBQIIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:08:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF2127DF38
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:08:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBT/7vH8sUcNaS/DfZIHvcIMN+3EiopnS8bjJl1n488RjpcCJc9KOQfg9jZ4iTut/qPCEuIbnd6ES+FaV6Iw/H5/XcIYL02njUotfAyf/0OQBIIyjiX2gUg95n39ZqkFhSw6fM919YGXOWhYVVUr1ofIWvEKblKb7h+Yzjrm8jTR2Eh/sWoR3Xau/0N8n/OAZzUXRIiGe39pngDvFGZ2oHmqyzhRrNF6Gis1N09092RHIlci4nn1Jl+ZKB2S0H/QOMeMZGssVNSRspgc/rJ7IiR1kENMH4vI6x4eFmvN+ziQVjg3r7wcR229RL8/+nrYQpT+VtHS5HwS1+l923jtVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMo4PT//px8/QPf19igfhVnfqv+AavRS8bfMAiKZIjk=;
 b=QRpPNqF8Kp6yxkbMNbx3gX24ezVSg/uat0Tub40rTqptpQicq26lR8EViBo2016OgsRk5wS/kNQPSDnD9FI8JYguQNPw8tGXpy9LCKVClkOGXcbuzYv/rCSI+hBCc//SP1V7EdEj7yrz/HZz2KRjEICnTmzUJohbJVoByYn3rsQF5bH9v0+FhXwBQAnmEoo7OeCtFICCMxcuKEayvMeTT3AfwfNKEU52AE1+XQSQkFiUbiiwcjv1Csy2h/HT4TwEZdFuPVgd+5bvp2IJHAbjEaztOOZkLOpteSC1D+hIPRVWx0TOh0wTOOmFRlyOJC3zajoGImEJSxUqe/AltSkfKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMo4PT//px8/QPf19igfhVnfqv+AavRS8bfMAiKZIjk=;
 b=Ly6D6Mk+dt3YEnrOFfNx2APgt5b17dxWY74IH9Gorh4qpF+uTd9bwxCdDy99MMDJs7oQVWR6b0Xx1RCpDwb4mJtf2qxGZK2IouoSecjynj+xn8kg2LrEWmyRPKuhwnjH/Et4W0EK6KfQzhc1xwyVX+ObzFAuMJwcAfFLrDSDBLMMUpE60Rdd757toX6wLRU6FmUO57yQkfk2YExH3LMFuJFTs+bMCF+N3N4y9WgLVT6SMqGsf5rtjIlpJJfDqWYCxzoeEAH4YuL59acnfMk+Kkqwu4OKaZvOr0QU2YUXYIJ41tjpuRCOioiCiV8Im+imnl3U2JQRfzCcNzXsGt/wGQ==
Received: from MW4PR04CA0108.namprd04.prod.outlook.com (2603:10b6:303:83::23)
 by BYAPR12MB3526.namprd12.prod.outlook.com (2603:10b6:a03:13d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 08:08:03 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::be) by MW4PR04CA0108.outlook.office365.com
 (2603:10b6:303:83::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Thu, 17 Feb 2022 08:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 08:08:02 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 08:07:57 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 00:07:56 -0800
Received: from vdi.nvidia.com (10.127.8.11) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 00:07:54 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net-next v2] net: gro: Fix a 'directive in macro's argument list' sparse warning
Date:   Thu, 17 Feb 2022 10:07:55 +0200
Message-ID: <20220217080755.19195-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 146bcfc7-db48-44e1-d92e-08d9f1ec9ed7
X-MS-TrafficTypeDiagnostic: BYAPR12MB3526:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3526B9D8D64A08CD9829A385C2369@BYAPR12MB3526.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EDmxgdnvO6KrxCcQAAyVGfdh9Hwa5RW0ao/KKHqKm+28UnrQmx+VEnhf4L2bVJaSWn8CNPqxXavgJk4Q1LY67NndHQt+B9wcoaXsk1u5akKsLNkFO19S3+1dNPZHH52vg3OvOQm1MP2wkZJ9K5Ln3VlbuPCv3kkQc1DvGo0UV6qYFOPJvRa5Jc0d31h95//Inka6xzNg+hpbmh0IqTLW9VeFS9MjcIzJ2us0o6eg6tnA7RDIAuxlpyHPO4lED9t53Xjj2peMRHn2JmU+ajRPP73GDeWzE4s7HzEkGreRoo9XCFNBhwUXNMs0V69PPhuZQ7LYno4fvJAtjsilZa9qv1nHTDafVRXMuezyTKUAPxZerdvcQs/eqsLFKKXuFJbYvuWptqcLipVXQN2je+EAfYUk6q+lUdg/1doOP0HREGzIee5o/Ob81lpFpcU44eW8imgQfGOwOFC5lm0cUOuHWpzR+IfcIMrLEfLVPv9qfAYStHFEtjm4yXIhZ+yFMkxM6GQsVXbbw8eyP+e1uulW0mgU7jlIduDcnI4BvinWSmegyokj0EcNw4AcuXr7oPhmdRqPFVgNefIPsvUwc+ZZxdh9rlOSEcUoRg7eLg8gDvhOap6VS0mQBii76sz4TIbvYKsB0j/7iAyo8P7TtiTfnG6xlmke0cQLMjSqXgkccsj3f9mOlHtxcvGS/1ssz1rnikQ9IZn1oh9BpSpjdajLbdwjG7/qEbu92uaw3/B3cIOGOhfWXiAj3xctV/9atBrbYJN+s4in7zgjjBK0tZMrrAaqEm55Zh47bPtj+3CM3ps=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8936002)(2906002)(36860700001)(36756003)(70206006)(966005)(8676002)(86362001)(4326008)(5660300002)(47076005)(83380400001)(70586007)(82310400004)(1076003)(40460700003)(426003)(336012)(2616005)(186003)(26005)(508600001)(54906003)(81166007)(316002)(7696005)(110136005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:08:02.8064
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 146bcfc7-db48-44e1-d92e-08d9f1ec9ed7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3526
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the cited commit, sparse started complaining about:
../include/net/gro.h:58:1: warning: directive in macro's argument list
../include/net/gro.h:59:1: warning: directive in macro's argument list

Fix that by moving the defines out of the struct_group() macro.

Fixes: de5a1f3ce4c8 ("net: gro: minor optimization for dev_gro_receive()")
Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
Changelog -
v1->v2: https://lore.kernel.org/netdev/20220216103100.9489-1-gal@nvidia.com/
* Add a comment and fix alignment
---
 include/net/gro.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index a765fedda5c4..867656b0739c 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -35,6 +35,9 @@ struct napi_gro_cb {
 	/* jiffies when first packet was created/queued */
 	unsigned long age;
 
+/* Used in napi_gro_cb::free */
+#define NAPI_GRO_FREE             1
+#define NAPI_GRO_FREE_STOLEN_HEAD 2
 	/* portion of the cb set to zero at every gro iteration */
 	struct_group(zeroed,
 
@@ -55,8 +58,6 @@ struct napi_gro_cb {
 
 		/* Free the skb? */
 		u8	free:2;
-#define NAPI_GRO_FREE		  1
-#define NAPI_GRO_FREE_STOLEN_HEAD 2
 
 		/* Used in foo-over-udp, set in udp[46]_gro_receive */
 		u8	is_ipv6:1;
-- 
2.25.1

