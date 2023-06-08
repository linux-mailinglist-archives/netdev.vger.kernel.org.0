Return-Path: <netdev+bounces-9286-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5FA7285A7
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:45:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C7471C20E9B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C98417AC1;
	Thu,  8 Jun 2023 16:45:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099F423D7
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:44:59 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC1A30C2
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fErNiHQnWsH/rkWMcKFbIjb3z1rTjfhIMbM5MnVX14MXYXIKzMVR8A9jZrQK7pvbviyHmNOqaXHfdA4nHtlo+nuttjW78XLG6EVp7XnkHMyapaX5Wmp9kI8OULSrI+NgZ20hJUHht9z8U3vmes7LoPKXvDsARlKVt9lBONCz34d4TD2Lqyu3ccMlYZUuLvk/cwlKQV34EpfQw1OGfuQmLWXD8JXY6zQamNrADcHBZHSSvbwuk+Cse42jd/Bz/6QFQNrmyn7sw1xPoSJ9gYFJ4sBJ5NFCiRPAtneE/cPvPyeG3PuoHnRuPDAIYzceE+Wjp0ys7saHI7KWV8wFW94SXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dnVKHdhd/oqaCjZwwl+1OUcMgzGmOEC4ZLp4ov+HG28=;
 b=DYyknTu90RCaui83w07x3ydV7WLUWJGxXt6PVYH2F3FHS5IXlQ15Azh7YN4uKN96jBDQdfdZLAA5W/tbJ/LbZ0nGvOGs8fL6qipiOPD3qtufD0SbmtRgWeXHnUHsGgy0zfXbCHAcWs+Lg9p+YMeWdsJJmxJ6V5YV7HvIOk8KPbofALWVKAqIjRg3LwnfGawZrmNxzxGpISKW5OGYGnQWYpH31D+ED4L3mcmSigo/+ydiJ4WQPJZTqONFgoscOjIQzx7lc+eeTq1asUo/zKCApbUU8cHun4IiC6Y8d+e+rbvT4h+vKrefJZOXyFWJozlTK4iRnfCGDVNHCiRv4SHA/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnVKHdhd/oqaCjZwwl+1OUcMgzGmOEC4ZLp4ov+HG28=;
 b=UpLM8xbWSJuJECqpevyIaERpVdHxgOa74msHutJiTb7i5S3ToHkbD+0YJuQuoN7KZPvs5DUjiaoo5/swg3jDGSljpmEY8mRy5NfoeyCGLuVPv10Jxa3PGi7Gnmr3G8k+E//ubh9SkcoW1d6umHuERacQ50zpy1RKTxsm+kHyME0=
Received: from CY8PR11CA0001.namprd11.prod.outlook.com (2603:10b6:930:48::27)
 by MW4PR12MB5665.namprd12.prod.outlook.com (2603:10b6:303:187::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 16:44:13 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:930:48:cafe::be) by CY8PR11CA0001.outlook.office365.com
 (2603:10b6:930:48::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.27 via Frontend
 Transport; Thu, 8 Jun 2023 16:44:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.13 via Frontend Transport; Thu, 8 Jun 2023 16:44:12 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:11 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 09:44:11 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 8 Jun 2023 11:44:10 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 0/6] sfc: TC encap actions offload
Date: Thu, 8 Jun 2023 17:42:29 +0100
Message-ID: <cover.1686240142.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|MW4PR12MB5665:EE_
X-MS-Office365-Filtering-Correlation-Id: a26bf2ad-ff66-4511-2f55-08db683f96a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GWCRfpn6eQtZs97AwXV6Dk1Hh3RzcSWSHGw/RsqXrDfDLR9tOBqsciqsr5vsWokZ79hzC2lL4bJGYXApmR0L6CTK6ks2y9SdNiuFSmM77a/cCl4NcjWE8FDuf9H7x89gre2Agx345tekDbgHs0u+dKHG3r+3FUpUg4PTHu/I0JfMgyQRLrpCiHreddetaA9mgj6p58aR34ZYSGtZsV1jjtvd49Reu5TeRfQoqdSr+Z9KTkaPFuwKKLQTsyjn4XaxiL/dq8pMvTD/48iRyrW6Ypm733tKGl38Z7FqT9tpUw8OSfgvGTuKyIUcW2v3mlM/2l8fbSrr/UBdx4+gwkPS7cS04xQkvtJ7W/7WOIqeKwneGPIrV1AWjuzddP+5T09/c1vvCMVgi87dvoyDwAeOZf9pvqOI4ynB1AWayPHVaKMQvGqHSrPkmFSYDUcbY8IjjW7IVRYISEmuwJw72DfO2bXUWz9Echdw2BRLv481snR5cVkrRzyQOjfUkX1d1hPvstGE1r3YD8CUr6X9C+EWDM8ENgULDEtDkVCUT0l6e5DJk5kIx0bRU23/xBYc5fHtJzvuI2nllYecvKvEw0/JpjVYm11PypxWdblgkAtvY3bqHcbEbUAcbYpGV22nofgZfhtpxjSmaGYVygBbXw7Z5dOxihK3PgpVPm1K5mMywKlhPg6YZ6I2aOeOIhvL6LLtkJjJHLCLDiFUnu/ATtstXeeL6MI9waulb3d6aHCk5KEFqEVXeBffywBgsBY+M+45sTGossIqr4TYtWzvtdkROw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(40470700004)(46966006)(36840700001)(9686003)(26005)(186003)(82310400005)(336012)(47076005)(83380400001)(36860700001)(426003)(6666004)(82740400003)(2906002)(81166007)(70206006)(356005)(70586007)(40460700003)(86362001)(8676002)(5660300002)(36756003)(2876002)(110136005)(54906003)(478600001)(41300700001)(55446002)(8936002)(316002)(4326008)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 16:44:12.1755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a26bf2ad-ff66-4511-2f55-08db683f96a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5665
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

This series adds support for offloading TC tunnel_key set actions to the
 EF100 driver, supporting VxLAN and GENEVE tunnels over IPv4 or IPv6.

Edward Cree (6):
  sfc: add fallback action-set-lists for TC offload
  sfc: some plumbing towards TC encap action offload
  sfc: add function to atomically update a rule in the MAE
  sfc: MAE functions to create/update/delete encap headers
  sfc: neighbour lookup for TC encap action offload
  sfc: generate encap headers for TC offload

 drivers/net/ethernet/sfc/Makefile           |   3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c     |  34 +
 drivers/net/ethernet/sfc/mae.c              | 113 ++-
 drivers/net/ethernet/sfc/mae.h              |   8 +
 drivers/net/ethernet/sfc/net_driver.h       |   3 +
 drivers/net/ethernet/sfc/tc.c               | 182 ++++-
 drivers/net/ethernet/sfc/tc.h               |  23 +
 drivers/net/ethernet/sfc/tc_bindings.c      |  13 +
 drivers/net/ethernet/sfc/tc_bindings.h      |   2 +
 drivers/net/ethernet/sfc/tc_encap_actions.c | 746 ++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_encap_actions.h | 103 +++
 11 files changed, 1222 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.c
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.h


