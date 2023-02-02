Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0186885E9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjBBSBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBBSBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:01:08 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2053.outbound.protection.outlook.com [40.107.101.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CA777539
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 10:00:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlDDhdp8Ft4trAVnStXSHVug8jObAVAwFJzIpZwEBOo0JqEvs23HPr7e5CZrveg3thQ8qf4ulswkqblfa8TiV9lpkS9hHqkXidRAODRoNW8CqP9kzP2Qr5A54mjITo9Gd39/71vM5sP1lx97hGUwQkiLyP1/wi16OYrBRVPrReJwgrqCp7TnvhrvlRYcD/xs9q9PPiSPOpgyiRiowvVOSgLoF6kHc8OWOtAcJZdBmhMB+xHaDmO4xsw5P8cmF2FZ6q/HQqCMzd4zC1INEasgzfKVlRq/wdZfXKGOJJZQNAq+s01/srfFY5Tz7Tq29rZLGTk8DiEaiSNHbZ5h+ja0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QfwDjRcqFxkcs4B67gJfwkJ/lZDxYu654RNOFOi9rw=;
 b=WxRYFwDO1TuexSfgGiUIWyqaSoIq57WfMqyyIJyK7iLt/BtBhfX4K0oGqEWV3dGNR9smFiuA/sHDeCsf8SeeXJ5DA+rDTfc+lTKJYmDpUC28tGVUZwOMumFOJ84vURbt50RNgcQrK2ghmfeStcorDtYIFe4yGT4UAtVscnVLBg5jvTMXbJRkIoSLiIKeO8hGnI9ydOpfsRkufcx0DOKpyF2uDDOuwS3TsNdfevksIZN3nxWSdR++o1ZnIV2hdFRg0PWQwGHuEkQTYJBVApUOlFhOMMDyoADctxor9IMn1+gf3bGKJqthAlCpcX06es+wgCsJPg9kSd/zMme3uI7D1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QfwDjRcqFxkcs4B67gJfwkJ/lZDxYu654RNOFOi9rw=;
 b=sZ3xncyqVF1XgrvVS+hMkWaw6Dng/cvaxEqPuoPeN5TOMcrWZdh2QreNCCEXo1ar4pT+1al5bn066ntCBqO9igU1MdnB4PbdnWx1LEzJMbAy7sYszpzfbG47QAs+mtBQWVAsrHbjNwuWe6is6D4jMaMvx5sLUbwDghiOo9hJNFilwGucCSeMPmvsqWoTt0s34uGpG7RkaCBVTKBFTpUJTIgdobYRp7o+SVUJ20+6zoOric7yI9U/5SH9bRf8O4a9pPV42y1RAtOrzLcm/+1+8v5GK/q6FzrOQQ6jcnJgo4vEXIcapC7oYj1NjdzNGC7x1SxCotFgDdz5AlqKG7IC+A==
Received: from MW3PR06CA0020.namprd06.prod.outlook.com (2603:10b6:303:2a::25)
 by BY5PR12MB4210.namprd12.prod.outlook.com (2603:10b6:a03:203::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 18:00:57 +0000
Received: from CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::94) by MW3PR06CA0020.outlook.office365.com
 (2603:10b6:303:2a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.23 via Frontend
 Transport; Thu, 2 Feb 2023 18:00:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT031.mail.protection.outlook.com (10.13.174.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 18:00:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:42 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 2 Feb 2023
 10:00:39 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        <netdev@vger.kernel.org>
CC:     <bridge@lists.linux-foundation.org>,
        Petr Machata <petrm@nvidia.com>,
        "Ido Schimmel" <idosch@nvidia.com>
Subject: [PATCH net-next v3 10/16] selftests: forwarding: bridge_mdb: Fix a typo
Date:   Thu, 2 Feb 2023 18:59:28 +0100
Message-ID: <5fe3778e89161cc9dfa998ddec6ba0b20621995b.1675359453.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675359453.git.petrm@nvidia.com>
References: <cover.1675359453.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT031:EE_|BY5PR12MB4210:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a8fe4b0-8f61-4e59-15af-08db05476f6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ha/dqcjPOiOTNDzf1DUXxBNVulfZo5Qr2Cv5+wBLMY7I4clXaBwfoOweTbEzQe4ZRJ/VzFv/My8iiko+LqL7TFCUquhDFBVO4MmhbNimfT2jHZ4tw1CrAtXcnwiA+NTChhTR5kqETqWX/FO09BBQZSBZ+VtBJvKIXxhLNo6u0mG+TUAwszSv8KhvKy04npLKzl27QPenN7txLB2BuKJbX0Sr9IoQ06WSzIjFDSzW7EghnAeOPu6RpbH20FnRCDlaMbmf30pilLPMZHtHriQhCEJIxen+yACVP7bLLkqTrfajtRNNghpH3IDH7ArZtSnjStZkg1I2Cg/jqewFNR21QMi5EYMTox2ImubNP2Rit63KKg7pkFuNAhWxettc2OvzcDxplvRkACJp53KhWhE9AeVMpfKjyYEXUYAn9AZ9e5511aIUGljh/KxQon74y0U7UTdp8jVDM8KB3Bu0P3p7XCvW/gitLn3BwF5gD84GL44ulSYprRqttobbVms9CuTFHukUL4GjofPyqJMof118tldnCooxIN6rXIuKD8LOqCS6bF4MlFiGmF6cKepzFDYwAWmBZEcg4u87ZLxt3HMVEdsIiUYDtuhFEbxT3niAKuozOpL2Tv0cdoZQQ11Bgzm1kXb5YvFOfa4X9ghRMeHhdQEtaQs0RmZGQ8OvSrSBigmihw40AJPHyHvKwOLHcj0CVHLH4NCe640YJpJGPjD3iA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(46966006)(36840700001)(40470700004)(82740400003)(356005)(7636003)(36860700001)(40480700001)(70586007)(4326008)(70206006)(41300700001)(8936002)(86362001)(16526019)(6666004)(426003)(40460700003)(83380400001)(2616005)(186003)(107886003)(478600001)(47076005)(82310400005)(36756003)(316002)(54906003)(110136005)(8676002)(26005)(336012)(4744005)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 18:00:57.1666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a8fe4b0-8f61-4e59-15af-08db05476f6c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4210
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the letter missing from the word "INCLUDE".

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
index 51f2b0d77067..4e16677f02ba 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -1054,7 +1054,7 @@ ctrl_igmpv3_is_in_test()
 
 	bridge mdb del dev br0 port $swp1 grp 239.1.1.1 vid 10
 
-	log_test "IGMPv3 MODE_IS_INCLUE tests"
+	log_test "IGMPv3 MODE_IS_INCLUDE tests"
 }
 
 ctrl_mldv2_is_in_test()
-- 
2.39.0

