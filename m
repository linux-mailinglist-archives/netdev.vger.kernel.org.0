Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBA1681694
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237600AbjA3Qkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235698AbjA3Qkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:40:41 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8654E366BA
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:40:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEA/N+jEhk9pD7Nycu2ZAXM8LkGQc6I8oG1xde+jJVQH1GtwvO9Luz3MERTSrfR8drAYiDcVa6PYsinl343XoBWJH7uNriEvK90FXjUqVEWC3DF6nPCdH/SIETmhZ6ctgMrDZNJ1Tl601fxYQuQ9ugh/IvEVY/QW4tivH2u8tyUBtS75097Yom2Qy+/iXSOi9c9Y804AQNULgomGpirc6A6xG7oX4fMS4pMrv3lYpNgrFukG2VDMU39LkSfXKmlUx2wEJYNDFotjjgvk/kpBBZXfMrdL64z0Flvttfb6XKKbZyfLB4y115rHWljL+mwqM7EfLovWdyKBYL4V89N6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHBeLhfU7zWeCfUovPEVLValgzk8nWaGgpND1Tu7Kzg=;
 b=OM99p1GHHUri/NO34901+dXxM9mXDxckzgfj65PRcXsbz9TL0c6juUC6+AfgQ83MHSXMoyis0vX1QoYU2dVsKYqzuz5k3VXbyCnX0PQ7SXJd492PTd31d49UcCUdOYOOUxbwhnd1ox/NuSd9uWDdWVehBR4V3DHJercW8sHwEUHJtmGutDQf07TBWywm7m4PpZAOHcYtKFrL7Vi2Fvg+xTFbDE3FzZaxjHYP1lYTE1jmMTR1ltFEc4lCt1Nny7ekQ/XNKP50jiBAp6VhccY3R0+sW6r8oHJYPxTDucUGupPuB1qc5nW/2IVZ6l4CBqeIqnX51GWRr+4RygcrNhYGRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHBeLhfU7zWeCfUovPEVLValgzk8nWaGgpND1Tu7Kzg=;
 b=tCutm0hXD4YZco/GBUABhpRHOfVcKDEOKkjAmpNGExsqpMbYKtrmgKOBOEBiNYqq+hZZmCyKz3kj7lcKSAOcGmG/yW2J9LOiS5e6NI2fb5WUhCCBgoukKtI5kPlyeem8JAoUybOppmiiVoc+qGHLjGz6Ww84xWPQWetHmZRZJ+yowFb2HrH7KYZUhDbmWRLv0ArNreTS7Y5xX1unfrgyaXNCxibOUOWFNOMwdYp0YaOJpaq3QGi6JYna5BoqaMkgkTy3ucCv1iyqMAMgAzrtr3aIaWRTP3yfOkROVun4g9FWLw7VoHrtD+tDBqIkzXxpSiznj29vF7hG3q0VYvOjDQ==
Received: from MW4PR04CA0170.namprd04.prod.outlook.com (2603:10b6:303:85::25)
 by DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 16:40:38 +0000
Received: from CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::98) by MW4PR04CA0170.outlook.office365.com
 (2603:10b6:303:85::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36 via Frontend
 Transport; Mon, 30 Jan 2023 16:40:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT027.mail.protection.outlook.com (10.13.174.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22 via Frontend Transport; Mon, 30 Jan 2023 16:40:38 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:29 -0800
Received: from localhost.localdomain (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 30 Jan
 2023 08:40:27 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 2/4] selftests: mlxsw: qos_dscp_router: Convert from lldptool to dcb
Date:   Mon, 30 Jan 2023 17:40:02 +0100
Message-ID: <22f095fbeab77b159e917a6e548629912cdc921a.1675096231.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675096231.git.petrm@nvidia.com>
References: <cover.1675096231.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT027:EE_|DM6PR12MB4957:EE_
X-MS-Office365-Filtering-Correlation-Id: 242a32b1-1117-400c-8a8b-08db02e0b7d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d3Yo3LDc+9mkiqMTXjVEUbfNlRDfFgqEHgxn+bPPYsH+HvDJYhO7kTATIsg/QjouetteBpZGJCs7rVMEAx7pWjpFi7Its/taRRjsZQF8W5AoEpCDY8lAfyR7TvUYD7Zzy+N3Sp02qJnoeWxlMiZIye1cPVUNvIvRBifxS+MwTGtRq7MxOtMJmHjPdtwaLqhZjQ3gsrUMXVxFhzdIH+FZQf2Dh1VaqSK7EAavNUo3oyV6u+w0t8WGPvjhi2jRm3xfZRe7tpfHjLJI4FziU96apFjq8vS/Kn3b3WRMlihKKcv62DUHFDmkmCz+BAfNlxoMKupKpgQkKNhvhMhGki/pwksdUgoi/osIGQuXrL/ZONY0l5Aj/4BIpMevW5YDl+IYl6EIYKFcIhHU3zOvQIj9k4Rl9tQW4fvbECAL5YOxockhrtvK08zjTr1TM43Vvvm61B0QO1ftXOV/StYRCXotFx5+74FvkUek67ZvM3Es8+tLpYQPEcT/y8DS1BV6K8A8gm94yFDTTotS+FI3XKhevzdmMka5zBuhs5T2KlWxOwZaUyVa4LLCE4hN8QWUJEiPm6A8mV+vXCESxDGOseAYcddoqoVhGEwHqnMQ7kQyaGKr/VODxjNblg9Sgnxr2UDX9DmHSAvHybraJLaEu4GPOhZPBj2P1GAQT9jYX4azGzlzOd0qtnOrTX9FKZ1ATRUFXEZVoB2O39pIQvcgjEAchw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(36756003)(316002)(110136005)(54906003)(70206006)(8676002)(4326008)(70586007)(8936002)(5660300002)(36860700001)(86362001)(356005)(82740400003)(7636003)(107886003)(26005)(16526019)(186003)(6666004)(336012)(66574015)(82310400005)(2906002)(40460700003)(40480700001)(478600001)(426003)(47076005)(41300700001)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 16:40:38.2536
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 242a32b1-1117-400c-8a8b-08db02e0b7d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set up DSCP prioritization through the iproute2 dcb tool, which is easier
to understand and manage.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
---
 .../drivers/net/mlxsw/qos_dscp_router.sh      | 27 +++++--------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
index 4cb2aa65278a..f6c23f84423e 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
@@ -94,16 +94,6 @@ h2_destroy()
 	simple_if_fini $h2 192.0.2.18/28
 }
 
-dscp_map()
-{
-	local base=$1; shift
-	local prio
-
-	for prio in {0..7}; do
-		echo app=$prio,5,$((base + prio))
-	done
-}
-
 switch_create()
 {
 	simple_if_init $swp1 192.0.2.2/28
@@ -112,17 +102,14 @@ switch_create()
 	tc qdisc add dev $swp1 clsact
 	tc qdisc add dev $swp2 clsact
 
-	lldptool -T -i $swp1 -V APP $(dscp_map 0) >/dev/null
-	lldptool -T -i $swp2 -V APP $(dscp_map 0) >/dev/null
-	lldpad_app_wait_set $swp1
-	lldpad_app_wait_set $swp2
+	dcb app add dev $swp1 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+	dcb app add dev $swp2 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
 }
 
 switch_destroy()
 {
-	lldptool -T -i $swp2 -V APP -d $(dscp_map 0) >/dev/null
-	lldptool -T -i $swp1 -V APP -d $(dscp_map 0) >/dev/null
-	lldpad_app_wait_del
+	dcb app del dev $swp2 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
+	dcb app del dev $swp1 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
 
 	tc qdisc del dev $swp2 clsact
 	tc qdisc del dev $swp1 clsact
@@ -265,13 +252,11 @@ test_dscp_leftover()
 {
 	echo "Test that last removed DSCP rule is deconfigured correctly"
 
-	lldptool -T -i $swp2 -V APP -d $(dscp_map 0) >/dev/null
-	lldpad_app_wait_del
+	dcb app del dev $swp2 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
 
 	__test_update 0 zero
 
-	lldptool -T -i $swp2 -V APP $(dscp_map 0) >/dev/null
-	lldpad_app_wait_set $swp2
+	dcb app add dev $swp2 dscp-prio 0:0 1:1 2:2 3:3 4:4 5:5 6:6 7:7
 }
 
 trap cleanup EXIT
-- 
2.39.0

