Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8FA6DDAFB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 14:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDKMh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 08:37:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKMh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 08:37:26 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3193C25;
        Tue, 11 Apr 2023 05:37:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CeXT+tJdKFEvUh3nQmyYTAUZUZTphlXg9kRCI8+bnoKXO2ZabgNC8lFHskeqUfyPtNtvxiE0vLihl/SZxBx9Emm1yRv7xHIWMSomQqWrF3ehH9DgUW5mEt1/4ZaCE4VL8gypWbK1ez0mK7he52AhtkYLQIpQbRVY8Iqud+2Vz5VvrzVGMqgfDPVYLNnNln6alq3h/5yEexDFz4teFVsc9Ng+PLOA6Ua3UNYsjU5Rs9NGJM+gQo+oQsrEvh7WFbuo0jKgCcd0p8enpGKCPa7yJzxUjsu4DHiVkjWDb8xhNDYeAjBm8QsH5t3UobdztYWjR/uZZspa6mlEJfrHa0JM4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGMWer7zCL9iGjCLGGxnPxTMGXkU03z+Xn7MH7ik/40=;
 b=CgNxCON/wTpwddi6SDy6kUJEp2nXWmVB6tmAmz6+ijmmar3Imp3g3NRnov9sqZ47mUxdBhnwAwhfDivZdf3XlpNv6FqNyy2wq8Pf9zncc10JMVHh+Q9tbyy6MpjxGAy3nYK49gyXUXRd9+iPvrvT1sFI2mxbGTRr5IfvIzUVprucYrICSSKxoVf2rlZPatGxBIC+0zS1rqGxwx6E+gopiqsnBfLV0lFQpTsrKVPehHSgQt5DUnlsXmLKBOALwmxN9bmjUGhUkQ9VV/Iy5EvZAaG+wGPxuX0yh+WQ8nFUrWPeCEWPmAWPU4KrvxfRcBzYpOB8Orqsc40AcSGhvpXrxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGMWer7zCL9iGjCLGGxnPxTMGXkU03z+Xn7MH7ik/40=;
 b=wNrfeSXWpmN3m81Uk2ResGrqKTwy41dzwd4u9LUI/ssQVGOq8Sx5kp0ahNN3dtb95Lmhlsr7b7wLbRQUrLQmK7Rsjfz8BvmkLIug9Un5VqCe+VjeYAP0XWZbc2+WjctgQ7yovKmRUbaU59R611PUfmUVZboT81uJ230ZT/7Hor4=
Received: from DS7PR06CA0003.namprd06.prod.outlook.com (2603:10b6:8:2a::27) by
 PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 12:37:23 +0000
Received: from DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::40) by DS7PR06CA0003.outlook.office365.com
 (2603:10b6:8:2a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.40 via Frontend
 Transport; Tue, 11 Apr 2023 12:37:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT079.mail.protection.outlook.com (10.13.173.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.29 via Frontend Transport; Tue, 11 Apr 2023 12:37:22 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 11 Apr
 2023 07:37:22 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.34 via Frontend
 Transport; Tue, 11 Apr 2023 07:37:18 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@amd.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@amd.com>
Subject: [PATCH net-next v5 0/3] Macb PTP minor updates
Date:   Tue, 11 Apr 2023 18:07:09 +0530
Message-ID: <20230411123712.11459-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT079:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5e2220-a6b0-49fe-a936-08db3a897f94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2R9ddizqcu14uB/LEVgoWHAfWcAbPbP6WSnfXZbSUDAjets//LzB4IzdwYANxthhVwwj5woHKpYYN6UZTbJbKqTApmzPzUpK8HnSXkiJbwQq94W0hsoAY/K3lB7+TVgALM6BiZmGqokE2Nw+qhuH8WOd4yZR3mUqKKMrF+Itt4Qwt4BVkYDrSETz4/6nM+Q1BjNaAi5RkJQVKabwGj4ySKk/Kccd/bYIs6/PL5/36pxwVipgZ1A2Y7qHluOzB9eWljADj8XlOc7JLpOMWByq7516sDLPfr7dQiPFoB7xrCKWz/LNqn/4TYGXhjM3ZvyK5mgmksBGomr+m3F7dXBIYBT8oqYvE9q3gd8Aws42mh0V3RZIjNdmrWOx2+zYSAxQ/bUf6h2DAulspk1W6cHUCG8D1f1x5wyFUxee8OsONOhohChhT2BbWvWgFo+nkc4e9b/7sTxNQjIVFPbRpET7DwxBQiz4Yz9tw4GjHtkO6guMcU11pI3WEzz+Ic1Fz2mhUn/1ugIHeV6xjfcCErB4vv+zyr91tzpSenqSFzj6m1RCz3YLwZxAH43kUhUm33hpRPMHnEQN9v5vAbLoVscRDC9GOxmMJzV4+1i3xWyxMjVp89hFJUxTRVN79t6ebdE3sgHO+WGZYlkNJBDC+Ow6GgxTjSGdya3u+3AgizWDQnfmOPEnXPTEpet9mPDZVJ4jYTmT1JZGrxishv9NHrv+BaE5Q3E9HHqIJT1wztLF25s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199021)(40470700004)(46966006)(36840700001)(8936002)(6666004)(15650500001)(40460700003)(40480700001)(44832011)(4744005)(7416002)(5660300002)(86362001)(4326008)(8676002)(70586007)(70206006)(478600001)(110136005)(316002)(82310400005)(36860700001)(82740400003)(81166007)(356005)(54906003)(83380400001)(2906002)(1076003)(186003)(2616005)(336012)(426003)(47076005)(41300700001)(36756003)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 12:37:22.7655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5e2220-a6b0-49fe-a936-08db3a897f94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT079.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Enable PTP unicast
- Optimize HW timestamp reading

v5:
Remove unnecessary braces and !! in gem_has_ptp

v4:
Fix kernel test robot error; use static check for
CONFIG_MACB_USE_HWTSTAMP where necessary

v3:
Add patch to move CONFIG_MACB_USE_HWTSTAMP check into gem_has_ptp

v2:
- Handle unicast setting with one register R/W operation
- Update HW timestamp logic to remove sec_rollover variable
- Removed Richard Cochran's ACK as patch 2/2 changed

Harini Katakam (3):
  net: macb: Update gem PTP support check
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  6 +++++-
 drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++----
 drivers/net/ethernet/cadence/macb_ptp.c  |  4 ++--
 3 files changed, 20 insertions(+), 7 deletions(-)

-- 
2.17.1

