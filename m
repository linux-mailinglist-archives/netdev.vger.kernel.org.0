Return-Path: <netdev+bounces-1370-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0ED566FD9EE
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 101BC1C20CDB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E61136E;
	Wed, 10 May 2023 08:50:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A920364
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 08:50:46 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2040.outbound.protection.outlook.com [40.107.220.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB6410C0;
	Wed, 10 May 2023 01:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kplq1uJIJf0Hw/IQcKY5si35LqF5lIhLrXtNwXPR8GZ89Z9SzcCcHQwgfsIiYQh5lz+JgO3tlo9Y8VsrloZQFN+ob2yDhClVZWCmLmP2Gq+LWBlRzlMKNP33j2kaHPQYf1n+mIIi529Pri2zxoo/vpiYe37RrGZ2ToH8HYiTMPdXRTUW4VdiUxgnR26O5Ho9a7UPv+5CD2wDBEBKGH6FdCj3WDHkNq0V6Zo8aXGP7INjrYV+EUjX5LxNX7Jux4E8pZpE3EN3up4ykbLc0O+sJcZG1o82Cj/ZeviDgNwZzfUxsrkxkbbv3qeRrtC6rbJz1Htt4O3uEmgpPD16AOn2iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oT4+n2FqgD9yiqL9BzSJvUsxwslmJXjIfEkb4sEPvwE=;
 b=RYvrttuRvpikj9/YGztKi/+ZyHAqn/RDewTLyb1i7jhL8t8cLs1Z55/K895e0ygjWlPsTEGgLr2ehAweUwu4S8o05iNOWs4Ho1SGmsnxofZT0DGzMpI3b9LLuD+xuKtx/UdRqUa/XWGOuRd7tnI++tvtjVy23igjCf8FW0giFp5oIGu8x1Rk8x1nvxGGCkARjEGHUc59d4xK63lUpzRk91cQz1moboKQVmTLTNnfcIswINWFozxTrvzPEVCYuCmttm9QYPOgiA21CKvZaXMCmmX6tCUuN/68J+QD10aDpKlly4ad384EsoxxT8LdaeBT3rWpS4z1zdN6+kxqIs9ndg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oT4+n2FqgD9yiqL9BzSJvUsxwslmJXjIfEkb4sEPvwE=;
 b=yQ4rGSj2UDpPklaUbO0fJDTng6BE1GOKAmkygBdoykkpaQctMKrYHDLBWr4nrfnR8HCxnJYkK2RpaGGUYp9k3ymL5L9BEjAsoP7DnmGgWsr2Tj7aDjomk3G/dQo+gyNvv7ld7BWIarek3Sk5Bg+MNWJ8YgiQ/iuVEpQWzbfYNmI=
Received: from DS7PR05CA0103.namprd05.prod.outlook.com (2603:10b6:8:56::18) by
 SA1PR12MB8700.namprd12.prod.outlook.com (2603:10b6:806:388::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 08:50:38 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::f1) by DS7PR05CA0103.outlook.office365.com
 (2603:10b6:8:56::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20 via Frontend
 Transport; Wed, 10 May 2023 08:50:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6387.19 via Frontend Transport; Wed, 10 May 2023 08:50:37 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 10 May
 2023 03:50:36 -0500
Received: from xhdsneeli40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Wed, 10 May 2023 03:50:31 -0500
From: Sarath Babu Naidu Gaddam <sarath.babu.naidu.gaddam@amd.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>
CC: <linux@armlinux.org.uk>, <michal.simek@amd.com>,
	<radhey.shyam.pandey@amd.com>, <netdev@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <anirudha.sarangi@amd.com>,
	<harini.katakam@amd.com>, <sarath.babu.naidu.gaddam@amd.com>, <git@amd.com>
Subject: [PATCH net-next V3 0/3] net: axienet: Introduce dmaengine 
Date: Wed, 10 May 2023 14:20:28 +0530
Message-ID: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|SA1PR12MB8700:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b56dbd5-5ba2-4de5-acdb-08db5133a06a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OcLztLACFonEZRPEPpI7tkk6TFwj2K8tYy1t39gPcw3956lSrTqDCaKwD2ygTWFCpzTZymjrPIeYEGKU+rRZyQNuOY0xD2jxuDZIya4d8RZ+bdTab1l8p3+EYhSSZJijwlwweGIthDG1xrGy5FZt9GK+AvA9CODxOj9B1v9hH05g0+DDODXsUHWNdSc0ByDkY9JYNOw/oLa6Hin024pfZ5Z6N81MaFOX7ltrG3TZr7vqqXTXW+toP9pwf+Za3y3k1luD+GP7IGbFFJtSkV1vAcLGJS9jjYIlnBuGLwMCR5tttZw2VvR9xkVdd0o/NkLfRXlmC2+2GL90Ct3Tlyjaj7g1VQX8Qw4RvRxoNL57SyfHueoC8TJCbP6Sb1oQfTkuF2h+K5TF9xbYyZQ5WcsVImMvPEOB8Tamc3nRhpJZOpe8sAA9YOVxTdP1XfvU6o3M+iezlwd1AckyxNJ0avT3me7raBCfwEybLSlU2G/kdaRtwbGm7IjXHVj7RZ8ysGO2k2L5mMnIO+WQA2IMm7bWG3BV8ifw5bX1iwrabsnLBQTUbQCKZjrIKrbaBa0l0n1VtrAm0pBTzEOmu8IqDuit6sKup9fPc6J2NWF7VfWtj+afz7oYyhoWQc6QntEHmcTmNjqmzTk7RTC2DvUlUgAKGL1A7AYFM+Nsaq70DB6m6Tz6jJEdV0/R3KOWejRqOCEcTog1jFkSVbR6N6cA+g9Zw4ayoRMBmzmtMbRlL/dvo1bfqaE4kXZtAp0Yvg9AVVkJKavTbVrIgRI4HErQPgF68dcyjdY4hy4kMUayNTEU9PICZIA6F0zA67vBFp+SYYAq
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199021)(46966006)(36840700001)(40470700004)(478600001)(36860700001)(83380400001)(54906003)(110136005)(86362001)(70206006)(70586007)(82310400005)(426003)(356005)(336012)(4326008)(81166007)(316002)(47076005)(2616005)(6666004)(966005)(7416002)(8676002)(40480700001)(8936002)(36756003)(41300700001)(82740400003)(2906002)(66899021)(5660300002)(103116003)(4743002)(26005)(40460700003)(186003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 08:50:37.8803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b56dbd5-5ba2-4de5-acdb-08db5133a06a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8700
X-Spam-Status: No, score=1.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The axiethernet driver can use the dmaengine framework to communicate
with the xilinx DMAengine driver(AXIDMA, MCDMA). The inspiration behind
this dmaengine adoption is to reuse the in-kernel xilinx dma engine
driver[1] and remove redundant dma programming sequence[2] from the
ethernet driver. This simplifies the ethernet driver and also makes
it generic to be hooked to any complaint dma IP i.e AXIDMA, MCDMA
without any modification.

The dmaengine framework was extended for metadata API support during
the axidma RFC[3] discussion. However, it still needs further enhancements
to make it well suited for ethernet usecases.

Backward compatibility support:
To support backward compatibility, we are planning to use below approach,
1) Use "dmas" property as an optional for now to differentiate
   dmaengine based ethernet Driver or built-in dma ethernet driver.
   Will move this property to required property some time later.
2) after some time, will introduce a new compatible string to support
   the dmaengine method, This new compatible name will use different
   APIs for init and data transfer.

Comments, suggestions, thoughts to implement remaining functional features
are very welcome!

[1]: https://github.com/torvalds/linux/blob/master/drivers/dma/xilinx/xilinx_dma.c
[2]: https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/xilinx/xilinx_axienet_main.c#L238
[3]: http://lkml.iu.edu/hypermail/linux/kernel/1804.0/00367.html

Changes in V3:
1) Moved RFC to PATCH.
2) Removed ethtool get/set coalesce, will be added later.
3) Added backward comapatible support.
4) Split the dmaengine support patch of V2 into two patches(2/3 and 3/3).
https://lore.kernel.org/all/20220920055703.13246-4-sarath.babu.naidu.gaddam@amd.com/

Changes in V2:
1) Add ethtool get/set coalesce and DMA reset using DMAengine framework.
2) Add performance numbers.
3) Remove .txt and change the name of file to xlnx,axiethernet.yaml.
4) Fix DT check warning(Fix DT check warning('device_type' does not match
   any of the regexes:'pinctrl-[0-9]+' From schema: Documentation/
   devicetree/bindings/net/xilinx_axienet.yaml).

Radhey Shyam Pandey (1):
  dt-bindings: net: xilinx_axienet: Introduce dmaengine binding support

Sarath Babu Naidu Gaddam (2):
  net: axienet: Preparatory changes for dmaengine support
  net: axienet: Introduce dmaengine support

 .../bindings/net/xlnx,axi-ethernet.yaml       |  12 +
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |   8 +
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 636 ++++++++++++++----
 3 files changed, 533 insertions(+), 123 deletions(-)

-- 
2.25.1


