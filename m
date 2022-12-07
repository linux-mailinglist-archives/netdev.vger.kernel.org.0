Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEE96459F3
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLGMid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiLGMiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:38:18 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD8D43871
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:38:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QV+kK2RLcUz2LLcrXSU+8FbuonD3Tf6sEu69V7t9p85Ju6ILfWmpQg4eXxfFpIQJSoD7ALJcpmm05ed0g6e5jDS2rGrQe+BiKkrBAT8t1mQDWyfXT0sKPTZG7SSvdBZKY3UkIVNpBjQgXfrNgdIpoR4CG8jjYELBPmq/2buLoXPrUD7RP6yxoZJ3RgXt8drMu4xWB8EnZ+OEjHxK093kry2YsGPgbAgEWYWEEhwP4HBoTOoxLK8vC1flOI32tuho0bXuscALyZL0CpGNETPv1wPxv3rMmCH3U0gArrpcJspcFUaRkge5H32gR7D2p2zianBnQeex0wDoqFhzF0Br9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hs8isbxeZBl2/0df5Ox0O56kHE2TLP1dhRgmASxAOwY=;
 b=B65/fKl7qa3Pi5gRLKzV5lMysXmleIpSxZ6Wu3/WlmyhUcXFexfQhIaEzdxSdLRwr2UtBRiVReHL+7taSQ87m0eS4oe2bTjt6SCNkW4xTQSSJELYJX7gutyctS6QunBmGqqIaQIcroJncJU2p9owzynmGchZhmkskjXYPuaghyNBNh5xxm6WouiUf2JDaJIIsfeE14dMrk1afROAM+p8AyL3dSkEEkACELcVjdMdcpJ82GdBQLGZLNO3Sv/GNzwY5SUazO4WORENac5ngFR59BuswsISBPVOofEknBXCcVgxbs0tt8KFOWzB74JuBRnbvdzsczdWzN8Jj8cKv4X3KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hs8isbxeZBl2/0df5Ox0O56kHE2TLP1dhRgmASxAOwY=;
 b=er2eMXzgJ8Bakkbqg6zCzVgjkxFKQf+/I9lCahb/8PrnkZv9ogQoFXH0Aj/1YoLsg5KWetNXEDz8Vt3y6S57jG2ggCwhuChzYtF3G3LHS5ppSLGVlxwwCjnuGnqeZp8gksQFGGAbdLzTKVnVOjMrbpdJFdZOhxzzcL7Ok3gXti52MrlUsq93za0ak7fH3002L46+818DIFrShi9lqFHcoF5MjZGgdy7+y2mlEPKDuskb4xqkRRCtaEEjW4fNNoBhbLVdGCOomkp3NfkdMbv+xBAzWbDdCS2xzW8IR3exBypWnr7/2z48NJtUPwM5WiQ6cRtYiDBSqg2idOLdKomnnQ==
Received: from DM6PR11CA0072.namprd11.prod.outlook.com (2603:10b6:5:14c::49)
 by LV2PR12MB5870.namprd12.prod.outlook.com (2603:10b6:408:175::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 12:38:04 +0000
Received: from DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::bb) by DM6PR11CA0072.outlook.office365.com
 (2603:10b6:5:14c::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:38:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT087.mail.protection.outlook.com (10.13.172.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 12:38:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:55 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:52 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 6/6] selftests: mlxsw: Move IPv6 decap_error test to shared directory
Date:   Wed, 7 Dec 2022 13:36:47 +0100
Message-ID: <ee4d4f1562d6f5711c729cdcd7e54c20828e453b.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
References: <cover.1670414573.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT087:EE_|LV2PR12MB5870:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b22623a-a841-40b3-b523-08dad84fe1c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: evUB/zo17XOrVWMGml4g+FR3F2CuSBKCPAAPZ8cY4iefHPtjLEW2Zam7lrcxjsx/pDheAzO8hCCL3ArNVFLBfbB4+MuSLRUjFlfsnZ4Ryhvs7KsZsvwgojr9kWbVPyUHHHeAycFRlREM5GU31/pLqcU9B7k4HcL68z59JR6bDsU0nxYmuEJtd2wvOVDoM+Orj40DoBOKhBmuLAxFrpJAQJKeia1JgjUxYlOiKK33ChthkCNIrlknsA2UPund+730twSMqvDXtbjMLmhsRvnf7roXTIzvbCUM/rdk13KDuBnU5s48WBP7YzkZkWxb/K+093uwHGb5lycsmENlsBk3iukh5zUDBZV2IYpRe/oZL4rpZBgaaTnngc+Snruvf5DULd7G8DhIUPCXBoT0770W1Mgy9rJY+bWSjxitVvzukHcAxRRchn9A1q1ARBqioi4Hu2f/6ym5YJzk5/wc55NcUtmfywWUurUDabd4OF4pkQfemsZ8SvDjx66Snc+tV735zdxEE+xiQuiq3KUJ8gyEbXndKhiZ/TcWTkFm5QPicsqD5SLrlP7YnqtD62NNLEFIiZOPBC3X8X+hBRUA038kyHNFPhuP/S/rxQ9zUHFyJOZ6CLX4Ycj5WtN8k4W4FZXgYtMLkFtAWUUuvaoy/OtMz+HNFTJ0WkIZlsxcv3BP8PlVrSBD2ernb+ZLDwpTU+Pcl08CBB7l7T1D57Xv4pb2ow==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(46966006)(36840700001)(40470700004)(83380400001)(36860700001)(8676002)(70206006)(4326008)(5660300002)(7636003)(356005)(2906002)(82740400003)(41300700001)(8936002)(40460700003)(82310400005)(40480700001)(26005)(7696005)(336012)(47076005)(6666004)(16526019)(107886003)(426003)(186003)(70586007)(110136005)(478600001)(2616005)(54906003)(316002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:38:02.6565
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b22623a-a841-40b3-b523-08dad84fe1c4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5870
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Now that Spectrum-1 gained ip6gre support we can move the test out of
the Spectrum-2 directory.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../net/mlxsw/{spectrum-2 => }/devlink_trap_tunnel_ipip6.sh     | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/drivers/net/mlxsw/{spectrum-2 => }/devlink_trap_tunnel_ipip6.sh (99%)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip6.sh
similarity index 99%
rename from tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
rename to tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip6.sh
index f62ce479c266..878125041fc3 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_ipip6.sh
@@ -31,7 +31,7 @@
 # |    2001:db8:10::2/64    |
 # +-------------------------+
 
-lib_dir=$(dirname $0)/../../../../net/forwarding
+lib_dir=$(dirname $0)/../../../net/forwarding
 
 ALL_TESTS="
 	decap_error_test
-- 
2.35.3

