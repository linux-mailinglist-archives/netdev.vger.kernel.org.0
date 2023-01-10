Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA776643A2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 15:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbjAJOuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 09:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbjAJOtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 09:49:24 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB15A56896
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 06:49:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpoU6drr+VU38QlWeQbmk2QOrsSU93SUuzWGxLHQkxfM8CirHwi/cyvexkOu1ejXeKUNAfsBcmrHIRj4u0tMYPIJxudE7EwQXyQUks7EXe3adb4fkjMnTrQjOU7TmgUU6P1EnUghnGCN/HvixxzQUqA52UF0sVC8Nm7thnn/cG+zkZqTNFQDL0Qhaa1ZsODIN6Mi4al/36fhEJLT/ABmFjD7LWWwXNSPWy9VfVRL9WXtDMMeH6euieEyLpetZsT0txab+qjWd6AyDRseF9FOPMlP1zndKhlW+CXUc/dQXP1g6ydNl9mukX52aKlsG1bTIzJj2d0tWEp9ex1pBIs02A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iDRnoJmslYl41Hp69fQ1m6KcK/Ni0x3KXDKYvr+gOBM=;
 b=U3zh/FcsbSOKvii+W9cuJp/kpIN8NVqk+1ibaUeLheWBfxklIPcRKc6UT54NTpmQ3JL8W352/hLjXFwfJyIS2KcQnSv6/cpcKBXphj3+Kn2Ng6Xi/vllX5+77/gO2T+3KubcOdnrFQgF9m6Uv8bcb1xpZy6Nd3Ruqq6n2YT9r+94wRVo/YIE/zRv9guQa3StGUU2b5Z3vUOKLUPIGH0+a51af7ucC7fnR+w9Xrj3jhF+Bs5ozVq7I9XJ+Dm7mSm1cQ0mxxboflvQmyrIofK2B1dbcY1lEOw0fo2TpXqt/HcaTSYRto5wuhv8Pw2/lq19YxTUME+o7q6G4+rrcYY8Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=queasysnail.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iDRnoJmslYl41Hp69fQ1m6KcK/Ni0x3KXDKYvr+gOBM=;
 b=Uxw9najxJ6Wapj+sYefwb7qya/03ghk/REJiggaCRwXKsYOXCREH2wLwrndprfXpINwzTkpiciyyio12i0RzXP0iS7hnlKNr1eC1fXiY9qGSO35umQipofUpCpiWM+U53Ipa3pydtmaP1hW2KtrWyWFCpWTdYwAjgDBvXrkP+NnaxoTo919tnJx621RBUaoSCzOJPzdU/+oevZxcNNUvHSohJ2LCnQohciqiPPlQ3I7hMjWnkHwYSekjdDgfDi4TH8E+X/HsYMoHukNaPSgd2zREr74BaefludTlKX8dbcwd5pB/freTPuKDb/QrLZTKHcj5o5PZ9fytGL1tLDwSWQ==
Received: from BN9PR03CA0485.namprd03.prod.outlook.com (2603:10b6:408:130::10)
 by IA1PR12MB8520.namprd12.prod.outlook.com (2603:10b6:208:44d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 14:49:20 +0000
Received: from BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:130:cafe::92) by BN9PR03CA0485.outlook.office365.com
 (2603:10b6:408:130::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 14:49:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT101.mail.protection.outlook.com (10.13.177.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18 via Frontend Transport; Tue, 10 Jan 2023 14:49:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 06:49:08 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 10 Jan 2023 06:49:08 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 06:49:06 -0800
From:   <ehakim@nvidia.com>
To:     <sd@queasysnail.net>
CC:     <dsahern@kernel.org>, <netdev@vger.kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH main v2 1/1] macsec: Fix Macsec replay protection
Date:   Tue, 10 Jan 2023 16:49:01 +0200
Message-ID: <20230110144901.31826-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT101:EE_|IA1PR12MB8520:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cb66d0b-c134-49ba-b67e-08daf319dafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 55SFwTx0X8Y1z6Ijqtfbf2K7lS7HgWgqizK+7Z7PYaxCqCtefBlTOy57pvCYgXSBDE75332cyx6h7WAeQpmL2f7qy+8OaAP+yiaVkH+RsJZOaRDEXajnztnaqK0WvVyZ2bKDWxgKEo4EQz2AiH9bDz9pqw+LD3mEzZiV04hFdCeAfjVGFGOOW72kVHGapKPqSOff8cr+jolj+VCeYJcIW1+nTTe3nmxESo1BECLnd5k44pFHEzI/pjPsJ/IOE0MzWLGXjE+5rWomNlLVySBUFFazN2qGVC4GndjgC0ve2Tk/PIjI2fMxWR3XZhikV2IX3i9BNOAjIiGPd3rt3l3+ynrY+Y184MPuhVbX9cZmPLrrPoG2Hvq2yUlNaLBlXaPR613FSGPPokc1/UVrDQXI82UlbA+uPqsVE7kHLPA3ZeoWZ3ZQFk6Ugkgj5lMQV6F8C5/rPCBk6Zbck3wLkEF22PRWQEW1tQ17ITOGwghTa0sKecGvdvnXC3rMqd3Vk8gg/dq1dFZzMDKMIIjpuK3ldMvNsdk8K1jkqTd+QS6tFqQo4jl01FV0ZuErEGBEgVs8iKS8s/7f2lbHqZWySOyDQDkvFy6jzJAsr1oUxt4XfI4KeJvZhkdCW8MNz84dcuPRY4dyEiuVTkiSwmibVaxafDkFGZwOVX1hHlJZCqgweIJnc/0+md8+ZzSiJi0TDHJ7QfI4jmE0ZLvXHOBdXGlpnQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(2906002)(7696005)(478600001)(26005)(107886003)(186003)(6666004)(83380400001)(70206006)(2616005)(4326008)(54906003)(336012)(1076003)(70586007)(6916009)(426003)(36756003)(8676002)(316002)(47076005)(40460700003)(41300700001)(40480700001)(5660300002)(82740400003)(2876002)(36860700001)(8936002)(82310400005)(86362001)(356005)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 14:49:19.8042
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb66d0b-c134-49ba-b67e-08daf319dafc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT101.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8520
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Currently when configuring macsec with replay protection,
replay protection and window gets a default value of -1,
the above is leading to passing replay protection and
replay window attributes to the kernel while replay is
explicitly set to off, leading for an invalid argument
error when configured with extended packet number (XPN).
since the default window value which is 0xFFFFFFFF is
passed to the kernel and while XPN is configured the above
value is an invalid window value.

Example:
ip link add link eth2 macsec0 type macsec sci 1 cipher
gcm-aes-xpn-128 replay off

RTNETLINK answers: Invalid argument

Fix by passing the window attribute to the kernel only if replay is on

Fixes: b26fc590ce62 ("ip: add MACsec support")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
V1 -> V2: - Dont use boolean variable for replay protect since it will
            silently break disabling replay protection on an existing device.
          - Update commit message.
 ip/ipmacsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 6dd73827..d96d69f1 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1517,7 +1517,8 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
 			  &cipher.icv_len, sizeof(cipher.icv_len));
 
 	if (replay_protect != -1) {
-		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
+		if (replay_protect)
+			addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
 		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
 			 replay_protect);
 	}
-- 
2.21.3

