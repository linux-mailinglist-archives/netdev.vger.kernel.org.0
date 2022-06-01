Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09E353A4DD
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 14:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243732AbiFAMYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 08:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352853AbiFAMYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 08:24:18 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD15E60DB1
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 05:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4ALA5/NV31o85n+AiWzeUJgxITGfpqwLOldaIoDoY8K4ewRxrUx63j4WgDMDPgxnA5iffILRAEdxrVlJGPgrktDEZLjMXfnOVVIWTQfCXSx5/UJSEL65GdnQcgJfp/0rUjtJoOE7OXxcsQOsOHWzqFwFKJ5Pcn/ORvZXWp/2kq6l4MUh81bu2Dlydp5aPJ2eadfHCyyX+jalcWsKn1CR/LTFXkvafSPrHNpEUoTCpG4sFgMfxyrROeijYRcPJh+7njQR4QgTTmrDEtNh2kX+Kwv/e/FLMBpfqWjpyzA8QTiv/TLVRtlVw0C2YJGq9lqRnHd0w+XjiQluodU3sO6pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=txv6WAMsOQSeBqIeG0dbepoNnP7HeMThf/tP1MpO4PE=;
 b=DYpWo9/TtoN4uh2PkN86Unt4T79CDPaywhKqDKpUVSHoOEXYYQfWII4HHUMab+I/okTtyWBpKq7OO8tv4Mf9hEv+ITxGWvDlD3MVQDKccmTpLrADgjAbAR5K4zABHs9fvySSPDzz6NCi5I0oKPLq5jA1W01LAr7j0brpLMJFhrv1rfi+qloEDbtMqiAvZjaLcm+r6+SluTD5V31U0T++hEpq6H2/OGKkVzF0nx+msqFu38uS2UQvAfJLvIGbOeJCi3kHFaoW0LaVnID8gqxpL/NMRddOfO5rdMfvket0jEPDheCoxfAa5T5NXyVOJ9xj+3uzD5loq4JfxG0Dn6WnkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=txv6WAMsOQSeBqIeG0dbepoNnP7HeMThf/tP1MpO4PE=;
 b=tNftaKBFKbZdiO4J5ebUuBkyGS5YkSO5C+v/CIBqm+Rs4xh6snXupZ7Xlf5Axj03ASYs75m9YS4rEldCbzNRzwB8TmUYwotQkJs0H+lzObsK4ppTzwjgDTCnwOyTsfi3NgZ9qhrvFT7r8GZN54ad3EFFpprMg7CEG9oZeDJlgSLXhK8piN8ZNq8ZzkABFV2VONbrmt4utesdURW/uABfjnpmP8TUkx+Pxoi+5NYHAowfsUfbYtol8eHTtaKr9WHfLaP/Zuwrudur9uuKfuZpCNwVzK8o1SPArDoMaULMhC8+gu/Nj4X74RAXdkcqOxkSp5Avsfr8VO40I+ep+nV55g==
Received: from DM3PR08CA0011.namprd08.prod.outlook.com (2603:10b6:0:52::21) by
 SN1PR12MB2543.namprd12.prod.outlook.com (2603:10b6:802:2a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5293.16; Wed, 1 Jun 2022 12:23:51 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:52:cafe::a9) by DM3PR08CA0011.outlook.office365.com
 (2603:10b6:0:52::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12 via Frontend
 Transport; Wed, 1 Jun 2022 12:23:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5314.12 via Frontend Transport; Wed, 1 Jun 2022 12:23:51 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 1 Jun 2022 12:23:51 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 1 Jun 2022 05:23:49 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 1 Jun 2022 05:23:47 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH iproute2-next] ss: Shorter display format for TLS zerocopy sendfile
Date:   Wed, 1 Jun 2022 15:23:43 +0300
Message-ID: <20220601122343.2451706-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e970b1e-50dd-479a-7a43-08da43c99658
X-MS-TrafficTypeDiagnostic: SN1PR12MB2543:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB25432AAF248172A23F2DAB69DCDF9@SN1PR12MB2543.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lBnRMlLguNDSKFJlvlR9HPkfo9AilrjvsH4fBo7Us77vZET9uYxi2P8NTA4Smfq6UmH651PoZryxDMOhlzWNxxS5UB4sSVPPbKQlyE2wdjV4BlJBPfVof2lVgHiGCpeAwu44Th2Ckp7XsR1abrRr/MzFyaMEurh02u4Fc5MgfGJ10cp+9swVDMKIEVeZRdFic7NtNMK9t5nsGoajdQDi9ufUlKZof5SUYDpJmDJsvpENNNC4jP2k2VeOQGpM5yegLkXk650RNOIQtawxVHWxrawZqlP0uCLWfE6WHSSl5CRJe2o1GrO6ZeGGMkYjoWOsjcnARHOc7n2ZeM2PMK6C+qmbXWuOVh3dPw8uAb3+s/Q/UDywwRV5/UE8QlSsJIzKn6VQjLK1DoR1ZuZ7DsZYgEg2NN8CQSm+LaO4tctrbn+actyqWCYyNITxl/67xPb9jWNdrEVzVak++/LNQNJ5h5r96FsSZuQuV9Bl3CYND9xGxRMDBtWwEz19CfW1J1QO2rbMY6SlYa7OKbTjybOpsD4hcxkwcKVSv//x/qmmZdwrOP7E0Za6UdpYF233dz4I7CBvd3zZedj0lVjlmDGrELMKvr7dfQcVEpcPn4XTNBV7f0J4eY9p4bg9Fn6dYEHn/NPLE4DisPlmjc0//eAZhjBaac2YVQ4OkQmRhv/3Hidog1XT9+CItE3KSDxQeoZ60k/BdvweIOHCNFFqgFGEXg==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(70206006)(81166007)(356005)(82310400005)(86362001)(2906002)(83380400001)(36756003)(54906003)(508600001)(70586007)(110136005)(8676002)(316002)(4326008)(6666004)(426003)(1076003)(7696005)(336012)(186003)(5660300002)(2616005)(47076005)(40460700003)(36860700001)(8936002)(26005)(4744005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 12:23:51.4964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e970b1e-50dd-479a-7a43-08da43c99658
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2543
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 21c07b45688f ("ss: Show zerocopy sendfile status of TLS
sockets") started displaying the activation status of zerocopy sendfile
on TLS sockets, exposed via sock_diag. This commit makes the format more
compact: the flag's name is shorter and is printed only when the feature
is active, similar to other flag options.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
---
 misc/ss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index c4434a20..2bbb3b4d 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -2988,7 +2988,8 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 
 static void tcp_tls_zc_sendfile(struct rtattr *attr)
 {
-	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
+	if (attr)
+		out(" zc_sendfile");
 }
 
 static void mptcp_subflow_info(struct rtattr *tb[])
-- 
2.25.1

