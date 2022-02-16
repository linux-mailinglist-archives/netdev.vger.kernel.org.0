Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB014B85E1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiBPKbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:31:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiBPKbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:31:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2062c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C50222DD3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:31:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oYzllugaCqCQsjj7JZrg7JLdUlFpLmvZW71OqrmeCxjBqQREpXuo0Kv+fRBwh/aGVTuyl/Y3rjkz7WJytgV8nfVNIrLZmvfVr5x9PqZcD0WwMmkMWIDH8t4Ypym2gl6TY5p2XnS8sMVRpduQdmos8UZvZDGrbOBXw6dyYluXKpY0CTOXNVGZAJOGFG+3S3C0ubjBbtiiZP947qLV4kmOA6FdwNnI0jU1XxJI8/u0DdJKNAmauy73xHgtpzbxiyqag9fCH1SpxUsUF3GPOwlbj9QwHXYv3kGBbxqfk/9hy4Ih8AxmTQ+GPRi5lJTg3ZUW1BhRzdbTEBpTtfn1GsA3jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AKmjZrJHSauMRZykIDcqDgggcqWkp0aUsdIywtYgv3Y=;
 b=f2q1NxcJF3mZqjuMs2rDxub6lmGNwmY2tDavKjGLDe2uyHRT0QkJdpR/Fb0fewJluXn8X02jTqvC59R7dNKdP6Rl5YWmECsQVwAVvcogOSEzkiIAzvu3QfRz9WDm95f9xobsPvP9tsuWyaGK1BP4P4t3vTFq39r90BVBg6het7RaFs/zc7uANsiBYgmt1cnzSoDK4cgWtzzyUS1410O7uaqplQJ7ipZ1sBVSkk9KzvJCJETP/BxSCyPKLCHAsvz1BS/03INxJNjIul+C6KsSNTqOL/J1cNu0NYYueAzP6QLu6S95RLbcz08PDi8xzys5aFLXF8Hp9sijCjDRMjBcrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKmjZrJHSauMRZykIDcqDgggcqWkp0aUsdIywtYgv3Y=;
 b=nDmE2Bb0/D+pi9s6KnB4ocwKuWTqaVdSW4QJIOlpSZdBiUCjvdrTGjQO1jK+kGNBRTAes4MSm8ycJxyKftzj7fPnlaA1xH67cOZ1AeGVFAXbdLckSO1GBU1xcUXz73S/gZLZcohVFbyiTtkBl2kEMKBmJZi4DZPTz0sAM9JlRRa1PI1f5bevyPyjSHjXxJVRzuQ8oLyaJuBtnMzyeE7lYFZg305RjqHaftiPZE/JWFnAkDv7KVcvWeMnDw9xeSK/7GLOA27PlaK8kTS7LtNcebSf8Zp271QxOvh9C2S+l1KYO6ecHALsJIg+mTKgUjUP9TAd5pW3hn9sMh5i4koVbw==
Received: from BN9PR03CA0616.namprd03.prod.outlook.com (2603:10b6:408:106::21)
 by DM4PR12MB5134.namprd12.prod.outlook.com (2603:10b6:5:391::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Wed, 16 Feb
 2022 10:31:08 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:106:cafe::4c) by BN9PR03CA0616.outlook.office365.com
 (2603:10b6:408:106::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15 via Frontend
 Transport; Wed, 16 Feb 2022 10:31:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 10:31:07 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 10:31:06 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 02:31:05 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Wed, 16 Feb
 2022 02:31:03 -0800
From:   Gal Pressman <gal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Gal Pressman <gal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH net-next] net: gro: Fix a 'directive in macro's argument list' sparse warning
Date:   Wed, 16 Feb 2022 12:31:00 +0200
Message-ID: <20220216103100.9489-1-gal@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7f94efc-bdba-4278-0e13-08d9f137717d
X-MS-TrafficTypeDiagnostic: DM4PR12MB5134:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5134E1A82574A14284EDD715C2359@DM4PR12MB5134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:651;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSr/FmtoGESdFUGgJoaLI8iL/OxEPVv7EyNiM3VTERAkOuI8cEhhRwMOQiVk5qj6MaBJ6sHGC9QXGh0BqXDpYDzDt25XK6tZuwy8TEhwIT2EX46t1TTYoW+ivIzu7GjYjJcpUih9owT6F5yqFMqPzsazVkjn6kxO36Floh/AdHpYPq3Vin7dN/O3/yRiPverkVhdMgUzcCKhDsbP0blivxnM4008SvQ8E7tmNrZ9blf1Sc9CAnQOKGuaBIvv1cavgad9hjf52Qr+cnWLn8beq7c5sKkGlWVHFv+le9VyxRJgmcg9ZmMqXE6Vr2HTcslCglrAooCH9itQQFg1tLBpFDs+o7BIFYM33TBPPLTYzx0Kv+HWq4/J5lcBjBR2hFIVt912v9b/GLPf+QjXsNUF9eVyCoPUgtuXihYmOc3BhhC4+MA4M2D8PFV4o9cNkfQc7aYF+43y8P9q1P6+VwiVWGvM3yq1NGRzjc+IYFqVhCiy96ml0fdLGWxgVH3y2SoMww8SMff650xbodhb/ALojYx7yZWNYMOr77e+K3aXBnv6Fj8eE1CEm2YkEYZITQLOB4jMrh8ifM7ovVhcTokyXCEw7YwFXwyj9Ni65z5HpP0C8Bw5d9WCeYDtk1bm+4wa2xNZGt3L0vCQaHbF3tOkFX1KolVsU+75739tq5GgVb4BmS5B8rP4/LQSJ7otYUe21qJJghyBY6cANgNTKTTDZg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36860700001)(2906002)(83380400001)(107886003)(2616005)(7696005)(508600001)(426003)(1076003)(26005)(82310400004)(47076005)(336012)(186003)(54906003)(36756003)(81166007)(4326008)(70206006)(8936002)(40460700003)(110136005)(316002)(86362001)(8676002)(70586007)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 10:31:07.7433
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f94efc-bdba-4278-0e13-08d9f137717d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5134
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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
---
 include/net/gro.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index a765fedda5c4..146e2af8dd7d 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -35,6 +35,8 @@ struct napi_gro_cb {
 	/* jiffies when first packet was created/queued */
 	unsigned long age;
 
+#define NAPI_GRO_FREE		  1
+#define NAPI_GRO_FREE_STOLEN_HEAD 2
 	/* portion of the cb set to zero at every gro iteration */
 	struct_group(zeroed,
 
@@ -55,8 +57,6 @@ struct napi_gro_cb {
 
 		/* Free the skb? */
 		u8	free:2;
-#define NAPI_GRO_FREE		  1
-#define NAPI_GRO_FREE_STOLEN_HEAD 2
 
 		/* Used in foo-over-udp, set in udp[46]_gro_receive */
 		u8	is_ipv6:1;
-- 
2.25.1

