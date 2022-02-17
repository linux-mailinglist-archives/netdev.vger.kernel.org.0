Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF5A4BA026
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240453AbiBQMa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:30:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240389AbiBQMau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:30:50 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2079.outbound.protection.outlook.com [40.107.236.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406372AE285
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 04:30:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9rdXTr5yK8n293hjIeNCh345As+/oLn+yGyxtuKAbY9Sb82/g7Up2ucbPXxn0G2YkPIZvzDi3WrL7K9Fh85LJ6cdzj0ckahdGss4n/lzvKn2a/FOPhhjsqoCDKVFBTY/VuZG5rEcX5f1luWiT3h9bnF2nNx0Bon7yXzD/uFbuTPrxmu7I6VhfG2bWyIHghSi+xp8rsRw/mQq65BvR810dGj4Vzwfla6eZJrVl6yTEiF4t+5B7R/d/ngubWfmkVN8W0I/fGlreB7Dqn0FT9XYrV1FdOtZ9EE7PrAoOSm1r/p/Akm1MaEUr+uuF1HeyvqwljlYQcpkgSDSumvbcbDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vqd1bV42DTyPW9q1B6EotDRiKAzl2TFfYZq4u8ZPlqc=;
 b=epao9FXs4GiA0NDIIRjS1HU57L+z1Mr28G5vQsSaTH/wlYgGQ8+wXm5AATuTmI+OXx4iClPe/XgA2q8xBy3bpBAL67Syio6iKu1LCQSNGAl6pesCX+ZFU60zSlAsAci3RLbEDNOdCgzgdi19xamJwb3FgIVr+vUCZn8w8AODs0Jqmgt2ZDTHlpFLUrJwR0cqHn8OQ9CcQkhhqszoSIlceceLPNA2LjRlEaDfLoeDP3/YYrxxJAH6GF61ENNEb8p+9Y1uKg/PWU3YLCOD+JhVygCGPaYfVdeuCXrqeETK0yhW2a3tiERrY4KsPHxEG1YTabVb8qSWDJC9XGQQLPzPFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vqd1bV42DTyPW9q1B6EotDRiKAzl2TFfYZq4u8ZPlqc=;
 b=ShHgwh0B2XUnSQil0bY0Tkl6ESY+LTX8Kl1Krj4IEVEgv1HH1KxMAvy/eW4oi2B43HuT9IoNU6mbGi9ibTbqiDkaWbjypXuyIPNn7Hdj69xqoHOgCg5gvf6pjycsg1DE/oTZgWMJG2wg/JxdCKPPUW39gEmelzdB8//1iob3GmrPqOdO6str0wLnKZnQ7vdbyh//F94nP+AwTTaN/N7LiznvLCcSeoq0IHQAUIZWoUohOTpRGZ/k6wKWx74ZbvwpiEwCar46L5nWMpDf9LGErybJGje40ggo0h+6FNcihZh35NDC1Maq9vU9Hb2W454SquTksy64rQOGKIzpFP7Rog==
Received: from DM6PR01CA0024.prod.exchangelabs.com (2603:10b6:5:296::29) by
 BN9PR12MB5179.namprd12.prod.outlook.com (2603:10b6:408:11c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Thu, 17 Feb
 2022 12:30:34 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::4) by DM6PR01CA0024.outlook.office365.com
 (2603:10b6:5:296::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Thu, 17 Feb 2022 12:30:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Thu, 17 Feb 2022 12:30:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 17 Feb
 2022 12:30:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 17 Feb 2022
 04:30:32 -0800
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 17 Feb
 2022 04:30:30 -0800
From:   Eli Cohen <elic@nvidia.com>
To:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     <jasowang@redhat.com>, <lulu@redhat.com>, <si-wei.liu@oracle.com>,
        "Eli Cohen" <elic@nvidia.com>, Jianbo Liu <jianbol@mellanox.com>
Subject: [PATCH v2 1/4] vdpa: Remove unsupported command line option
Date:   Thu, 17 Feb 2022 14:30:21 +0200
Message-ID: <20220217123024.33201-2-elic@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220217123024.33201-1-elic@nvidia.com>
References: <20220217123024.33201-1-elic@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd9ec239-138c-4a74-b8b0-08d9f2114b5e
X-MS-TrafficTypeDiagnostic: BN9PR12MB5179:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB5179FBA07D64FB0DC4614E8CAB369@BN9PR12MB5179.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:510;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ngZmz8pVIPg2rxr89NkMfaBFKAMzmUQtmv5VUZrAyMGfx0eJdP73epYCnkzh8PZPPEFdLVCylpM59Z9hG8+kQE3IR65f1g0oPTYrtUOuRtcWj39jqeZqr3ZPrBzY8XOurDIfAlOn3ork/C9gEPw2kya1R6I3u2RUBfzjHDM+6VoHGWGZ4w6IxX53KASs1lLipWx6y+TLcVJV6rhWqESaaqRFuS0q5PkYbxdhs2VUo0GqJ2eT10LTENlHrTNhXwOxCAij+y5xiIdjWMstmH2IAiM1SZ8dpIQQvltgJQdNCe4nbDspY+dbYPdkNVfgQLkqUytDxYknTPlL2xVpstezkc41JR50/nFv+Tlyvd/oPO9tWg8tGhoswuigCt3USJz2RsGgbfilkJmct/ZizMOV0WXbDduJMlbl94seB6AadlYr0juhF6S+9tFcu/W+Hj456SumNI13k2uPhlwKQX1dg/hWWdsZsc15gc4GLT3UOJ+XK2hlUTABdPNd+8QFL1svtlsQ5bDayZpA5AIcdDKS4aml8htrq/gSawyl6aKBhJMWG3zUhK6MNhVlu3uXgzWPXE0VctPURztq2XbCUWNaeC7xSMmXH+xL1sO330OpEv8qfLW262vP6m6SlIriK4/QK0+lHhK6huWnXN3QbFdIhYY2dxlbINHKxKjJGYtEjSYDEidwEkXNV8LUruJD+ft9MHx00ZuN7SAVFjQMOBTNIg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(107886003)(82310400004)(2906002)(6666004)(8936002)(7696005)(8676002)(4744005)(36860700001)(5660300002)(40460700003)(83380400001)(47076005)(110136005)(54906003)(508600001)(2616005)(36756003)(81166007)(356005)(86362001)(4326008)(316002)(426003)(70586007)(70206006)(336012)(186003)(1076003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 12:30:34.1094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9ec239-138c-4a74-b8b0-08d9f2114b5e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5179
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"-v[erbose]" option is not supported.
Remove it.

Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Signed-off-by: Eli Cohen <elic@nvidia.com>
---
 vdpa/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
index f048e470c929..4ccb564872a0 100644
--- a/vdpa/vdpa.c
+++ b/vdpa/vdpa.c
@@ -711,7 +711,7 @@ static void help(void)
 	fprintf(stderr,
 		"Usage: vdpa [ OPTIONS ] OBJECT { COMMAND | help }\n"
 		"where  OBJECT := { mgmtdev | dev }\n"
-		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] | -v[erbose] }\n");
+		"       OPTIONS := { -V[ersion] | -n[o-nice-names] | -j[son] | -p[retty] }\n");
 }
 
 static int vdpa_cmd(struct vdpa *vdpa, int argc, char **argv)
-- 
2.35.1

