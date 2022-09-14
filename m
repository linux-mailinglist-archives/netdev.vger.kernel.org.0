Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6AD5B8732
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 13:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiINLXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 07:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiINLX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 07:23:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2085.outbound.protection.outlook.com [40.107.243.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A21F61139
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 04:23:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOCKnXAr3pPYHrmqX7oELcvZpsnlPa0Uf/y6m+y+mqa4WteN+13hA1j6myg1zBsEnEjMiVuqobtIG91dEgAEYXK3W0A1m1+z2cH2HU9wxuEZAPf9JLs/Rp6dfTWO9lh/sEvO6P+Lfcq1h9gwtEowbi/uMmeESCeMIpmaRhs0hr8s+SOWPt3oFuEW/5GtDAMtRAx85Azp0b4uUcsUaXS3fF+GjU5vB72R1UW0Vbur0ibg+1BCkPZkdprT0NAQOPaZlHxQcn75In6gztt1T5mznofs5VT19nQOP9L9JtM02V+riFvdn+6uspHot3bykR4jD9jPjyTwwwKL6ryOpQVAgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhyLgNUooeFBJHCOitZeCjmY2/juD0JxhKCoMtSh/Xo=;
 b=FhjZDMV3F/DObDhboQqj078s5YwG8ppji42LjX27AvTtVGwyyqGSWa7/s1jmbs7VrzjUC2fM+BqeXQwvz7bAl1XXiX7rFHHzVLr5SWooRrlGBfS9YLopbws2GvqdwbT8o28cmi9EuQqfBm1bt72pDz/Yvl6FChPAUnOzlpn+qrb3i0hJwmtqw1njef7IZHYJigFU80Vdji9Xm2ILjyAY03lUR7kDXtbrmFR/gV3E8omwVm7XbpwaJfBwrB8PpIo/vM9g+VRclPoUQuKuB/rQ/y01BOCsqSHAVrj5X11ET2rLEr1LBVXm0vQTUYj1Z5oNWdjzPZ/1OAYwW+VWVwReRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhyLgNUooeFBJHCOitZeCjmY2/juD0JxhKCoMtSh/Xo=;
 b=MbMUuGCHcu8iN+uFOVhUP5j+AlHt//4Sy58V6RwZFNYk4Gx8f3Vnm9KSR6Mh+UVTHfMPBVI4nxdR1+pHrL5X18fjGX92cTi8tuc6vFTpVwGg5mO95Xrrhsqsmx1bgGsgiu9/gxd5T0MUvVAYOxEOn4vYXTUPQAyhyVjMwyPMGvBLeX598gA7OyY25cPC9eSWXjrnB9t9KcaeqZrqtEdCM6oc/F5SSaa/r5WeM8O4N89VGZQ2/7GycE93csQzbcmCgsTWiYEIra+g0qBb7OifiPZN5bNJDFbVLVBYL8ofxSzxedn8QbyrezbtThQ/+hssDiSmAcS08uD+zZhaF07diQ==
Received: from BN9PR03CA0268.namprd03.prod.outlook.com (2603:10b6:408:ff::33)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Wed, 14 Sep
 2022 11:23:26 +0000
Received: from BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::9a) by BN9PR03CA0268.outlook.office365.com
 (2603:10b6:408:ff::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14 via Frontend
 Transport; Wed, 14 Sep 2022 11:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT068.mail.protection.outlook.com (10.13.177.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 11:23:25 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 14 Sep
 2022 04:23:10 -0700
Received: from localhost.localdomain (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 14 Sep
 2022 04:23:07 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 3/5] selftests: devlink_lib: Add function for querying maximum pool size
Date:   Wed, 14 Sep 2022 13:21:50 +0200
Message-ID: <a8d945171e2254739e229e1dd9565b2a1bf12e42.1663152826.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1663152826.git.petrm@nvidia.com>
References: <cover.1663152826.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT068:EE_|SA0PR12MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b9a48cf-3d15-4f1c-6cec-08da96438acb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NXuyRAYilR8fe+n/deDUrl6bgCTdwrGD4kMbZKku8kf70Yqqc1EVGUwQ6perR74TI91EoqNBdmNfwYsLPDU4X7IWWEuCh4KSuhw1WCIG8MGMBUaD3ENvSgfPZWWslyzPweSpClilFzdthmQLYTyoHSktO4r18Z2ka5fbA231uXeOHKSCRn4GuflwEnkIxO0ciohE3wkIuQMQXQVIVJ0H+Q+LiyhxSfBhBvTvu8Ufr0Bq2mjwOnO+wuCJWXTypsc9T3IIQt0p0sYNd5yNAo7k0QeHmFhXE4Iaqi7CqN92/Jdd+gjyNUoaniXCAWPgqT/e9cglsy5tWLWIu4pO/QjbTDqs94mD0blYfxOLvx9JRlVh8IOTGvxammSD3wRkdavsClaUDKE79xnKONmZsqYy7GmnfGan/H1Dd+F7u2kffGdcOE6LLkrKw1t1W/vQAYAm6Ub6SXv24ZncXgTd2gQpJ4XZSHQ2FtpaU2rK2AhlhhIb4u+WpevqRRzMDNY70x6B05OVTOXnHa8hCZOknq3GTYz/QZFHlmu3jD0E/tAjB1O2VE6XeJPJQlXQpGX8VQSTTHWgwmmkHFyCJ70/gyb4AnkCi0cew8Q1sEx80mTbN5wsYXcm38jlgNq+X/ocHo9mli5Z80wTCVJFXsDQVQLJfKaO8WAQc8/1AHV8ZWPEsCtRyIGZNHP0qgy2oMedKR60yH+i1SHOWfOxS+JV7/0tWfI8kZiMWd5rTODx0XMpOtfaXBNCA+oPDRDDXvZk/TLPm6p7Ee7siX9UldLvLOaUMA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(8676002)(336012)(47076005)(426003)(36756003)(7636003)(40460700003)(356005)(86362001)(82740400003)(2906002)(26005)(8936002)(4744005)(5660300002)(40480700001)(107886003)(6666004)(478600001)(41300700001)(70586007)(70206006)(36860700001)(16526019)(4326008)(186003)(82310400005)(316002)(2616005)(54906003)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:23:25.9721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b9a48cf-3d15-4f1c-6cec-08da96438acb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT068.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The maximum pool size is exposed via 'devlink sb' command. The next
patch will add a test which increases some pools to the maximum size.

Add a function to query the value.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/net/forwarding/devlink_lib.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index de9944d42027..601990c6881b 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -584,3 +584,8 @@ devlink_cell_size_get()
 	devlink sb pool show "$DEVLINK_DEV" pool 0 -j \
 	    | jq '.pool[][].cell_size'
 }
+
+devlink_pool_size_get()
+{
+	devlink sb show "$DEVLINK_DEV" -j | jq '.[][][]["size"]'
+}
-- 
2.35.3

