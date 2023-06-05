Return-Path: <netdev+bounces-8181-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9900722FB0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83A6F280D1F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:21:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9634924EA3;
	Mon,  5 Jun 2023 19:20:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A36DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:20:06 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01EF135
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WtJh5utCRxLBpASwK/ADbL28tVBBJiploDEKr/9Nh3GXJcpYsWQ6kg40ooF3c20SpZXMTcbLhwiaLIICWqNFxjzL+t8CooNjTQWzIaZ5n1yny5/wveDXbekEwiZ8iCdxiJEMRi16tMqf1NeIen5rQnjtJtm9OZYg91kggE/tGhRBlQOB4ksId6hwevN5hWPEgJa7g2ftC3A+3zoYQqsA7gLmws9KMCvBMrRIQs/v4yuH4oLv+zvRM6MbuS4ismFH0uxYl7GII6kf4gRdO/zoGy+U5WNUKgXpeyQDkPUlxNNfEzRcuEm/zGiXnSnMuDxwsK83Bqeu2OdxWT6EYp9aFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQQdrd32HmDcg1pUhWv+blb0jLQsRmz8e41z7LN2HO0=;
 b=Rhx0YmwticAQRemzQk47oLvy3u+qcVGYylrOhgY2Tv1upmhM31W3nUfQL7MTC9kIaoi8oQ/2IN0IYNihnawQi5s3kQRN/3/OprZ846U3qdSg9JxsgmJD03M/B9RGU5KPkoPJ5Nx+IUO19BrGujaT5OEXXf6/YrbDKQ0PcLuf8SVo2sWXciafoazTuc6ZqzJ2sXANCT6XVQnK2VLzSN1G7wYGVYdjOpHwZ24YMyJJ4SUh40+EpsaJnN6Hk2C2LIwCrUx0YyzaXovpAUVzE1jNrcF3O0CGEn0d/9HFOH8YoB9/18yA228UkwAz5ZEIsbH44rSE8FhNVSckqZ3W70VG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQQdrd32HmDcg1pUhWv+blb0jLQsRmz8e41z7LN2HO0=;
 b=fqILGuVIebRRcrFOK6fj2nrVbr8fggTnATvuJVpoS4FNly3HBZSFxYyJ3j5QLMEn3aaLRK/CObMSHHkotWs/WuQ9Y057CvajNgRPLNXhyhnRUYAkQ3DM8hnQANViomAmG3v+OLEhR2soMG+Su4b1qr/6X/dU68DRzPh/a1LsM4M=
Received: from DM6PR06CA0034.namprd06.prod.outlook.com (2603:10b6:5:120::47)
 by PH7PR12MB8778.namprd12.prod.outlook.com (2603:10b6:510:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Mon, 5 Jun
 2023 19:18:28 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::6) by DM6PR06CA0034.outlook.office365.com
 (2603:10b6:5:120::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:27 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:25 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:11 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:10 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 0/6] sfc: TC encap actions offload
Date: Mon, 5 Jun 2023 20:17:33 +0100
Message-ID: <cover.1685992503.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|PH7PR12MB8778:EE_
X-MS-Office365-Filtering-Correlation-Id: a4ba46d9-e7ca-4c86-80da-08db65f9a402
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6c3HMW+gefxwA4QQQjBFJ+Tjir0kucCWNpyW80cLZXvP3VpKxgZYN0oBDovgz4jwn5hOF/DDSueJbdq9roUVoOnK2gCo1uTgr821G1ZvY+khZBR/XVj9Yk6jkl8qaK8MFEgKN5pL6qKcVhiJwb/cvHf5qhqtP6BKYWM0wKR5P4J0gKxZV700Ssd8ufXo4spJysCUm4aEHPQvb1/B7uG75HY6M6vb51/7DahI2NHjVQZVgsB2/QB+ty8UgmiXBHYghT2McDuWbr1NDyTboe0UmiKIX3uG/8tpyG54Q8gdRr+iB0/i0V55EYeRIrx0LHu9Z8ahAi3+EP97ut0hRAvv/Rti7P1MD4yl0hLpcNG+0V8KS0s43wrIhF9KPu7rTyGm5PtALBnUCmCN8xBne69ip+J2q9Aj1Bj/Hy+Er4JXjLv1oMkJJfFrMx0iGendfm6RV7QSE8+g2SwNYV8t90FxjYP20ZEQrgvRQxHFgGobyJVTzxuPK1YkUsB02sejRslwnfAegCZEW+lb2CVgLfrG24uP1UxaqnRz8NgNKt477bGkJBbbKhpJ/rPrFI7dDMjwlYECIy7mdL2uRsvXsc1BXAop4XsjX4UM18S2483/jaYWsK2rU/1ahFwCsClaRi5jMle3ok8hwwKwZmXaRKGVhoFdiLACngFB+tciIpJLji9PB9WPBK9KB2OGRPTD+3theVTEFfuSkk7BeA/yTjhyMj27IYsgHHyoYbNmJqZjP8FJcKCPWmpfBtG9XNMycBdgAIYBGkWWPmHqnWHySJoFZg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199021)(40470700004)(46966006)(36840700001)(5660300002)(9686003)(26005)(2876002)(336012)(47076005)(36860700001)(8936002)(426003)(2906002)(186003)(8676002)(83380400001)(55446002)(41300700001)(478600001)(54906003)(110136005)(40460700003)(316002)(6666004)(82740400003)(356005)(40480700001)(81166007)(82310400005)(86362001)(70586007)(70206006)(4326008)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:27.5165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ba46d9-e7ca-4c86-80da-08db65f9a402
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8778
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
 drivers/net/ethernet/sfc/tc_encap_actions.c | 742 ++++++++++++++++++++
 drivers/net/ethernet/sfc/tc_encap_actions.h |  99 +++
 11 files changed, 1214 insertions(+), 8 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.c
 create mode 100644 drivers/net/ethernet/sfc/tc_encap_actions.h


