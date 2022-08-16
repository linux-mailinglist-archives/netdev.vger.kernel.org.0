Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16335595B39
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbiHPMGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiHPMFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:05:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92813D8F;
        Tue, 16 Aug 2022 04:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6xIvaoiXwkpRnwh63XkPasgjUZS3aTd0hXJpWmD3fK+O2LyLjgZw0gA9SaiUVXbbEOulrbWCp2m9oyqrzQ8pT2KBsRnZpUoLe93U7p2FojbxxvqAdmwWRj6EPMZ1dEa+kn6lan/b33XkbKvx7NhwScOq5oE29s7t/fA15FDjzFgxgT2qoXvBM7Y1JIBdtXBGKrpYYlTeT6tYf/jVEt/YypFppDS4jBz568jnTRUYajNUQ8+KzHxTykmyBPqv2hK7GjakS+KTE+n6wzUgQ9ROeYZTrbgJCpTqtis2LODJa2irixLHQddmqMy4YlCiny8C7ds5+DXYsoGJs5EvoYj5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HZUVJTFdm23UzkJW9BcbQGhtCVIfVJ6pcOO74cSL/ao=;
 b=b78ywA+fFFSm4fqwds+qTLqrB3CZKyc179utlm3SzSRe62w0P/+SApNojUmerdw3vXjBi0FY+iMLDBhyz1yfyvzi0tn/P754FvtO/4d/3aI2/9r3nZRBdQ7anPJN71a4as0PHgexKh60foTXIqqmUfwxeNQ2lEjFV5DDB7MI+/jHF+2/iGG96Re49b6fqi+d6JPR5Ej4e5lYzHfL0jyPZuVGnIVB6cPZcACts2YJ7hUqBiOUe3xDPRdCZAtWl8TpxC0SMRrVvx7u0IWUL1GTC0eT2S86r7rMR3/wddT3B+ZPaZ/lsF2n9bwlg/EAYCsP+D9SXosxWF9C/IE781Ihyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=microchip.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HZUVJTFdm23UzkJW9BcbQGhtCVIfVJ6pcOO74cSL/ao=;
 b=ivCwxTMuzgcfOTAKBhk/e6OCgtwEAhXYeMulFgrSMDLtEb+O9DMH55EyHdZsUw1MY/T3Niw3fuMWsIvPfIwQosMelNUTswU16Nc/iHUfqGYC2Zw6Oe1zf+SmHHQq+RNQ9m3JbIygoVvzX8XmbEUiu9cK7zDOB8TevEfDgz911o4=
Received: from MW2PR2101CA0022.namprd21.prod.outlook.com (2603:10b6:302:1::35)
 by BN7PR12MB2772.namprd12.prod.outlook.com (2603:10b6:408:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 16 Aug
 2022 11:55:08 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:302:1:cafe::c3) by MW2PR2101CA0022.outlook.office365.com
 (2603:10b6:302:1::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.3 via Frontend
 Transport; Tue, 16 Aug 2022 11:55:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5525.11 via Frontend Transport; Tue, 16 Aug 2022 11:55:07 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 16 Aug
 2022 06:55:06 -0500
Received: from xhdharinik40.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2375.28 via Frontend
 Transport; Tue, 16 Aug 2022 06:55:01 -0500
From:   Harini Katakam <harini.katakam@amd.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <claudiu.beznea@microchip.com>,
        <andrei.pistirica@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <michal.simek@amd.com>,
        <harini.katakam@amd.com>, <radhey.shyam.pandey@amd.com>
Subject: [RESEND PATCH 0/2] Macb PTP enhancements
Date:   Tue, 16 Aug 2022 17:24:58 +0530
Message-ID: <20220816115500.353-1-harini.katakam@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a7f3946-12c3-4ff8-8b8c-08da7f7e2a1b
X-MS-TrafficTypeDiagnostic: BN7PR12MB2772:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r5ucxb5g8YGR436lvyeG/fLp/pS8Yrd0qgGjf8Y68lAjH7q6hdUTJwW1m5YfN+aIX8p3YwizEypTVC7xmpuFwcTxtqyTxmU2aUoRdezYPB4wO/JrAgb/d8p+gKHYGTcAaw2FdPUk8hY1AijhVfYfGJ1hMJ+2pkpczttLA/MlJ3Cju7vjPDkniJVVl1o7V9rGQ7Fa3XeD0sr+1kS/jDtoMD2HrO0QliACT1a4DCb4wUzDrobTQzLB3ppv5lXISn56AlVCxlv/wR0KFpebVbzxax1vs+SnJQ7G0UX2k/6fkdZdBHvZ3QmGlOg801GGDPt04BbMhWepdHGASKeOsefow54avSHwwd5UQLb0oypvMhpHAcImQ34tbOsxz9rNU5PqWSlEzGZXlotkIZWv517gyROeaZmI/OYVzOTkiUhntbIFc3XwC6cSJaGmVdiT6vIPAqPQI12z9jCktCuKH/nSaCeZlrvdYrnKcAeHcJppfdB3zLY7aaSTajNnUJVg7fsf6xwBwpV7JU/v24pb9jnTHa8c07jw24bgW+lNQkGqwjPbwMGfyDHCoeFzEJMgdyoa+gXxZ1fUrTbXltPiV+XcLTHCbywyOha4YMmEPgmTX+GFaSn5ofRZ/wf6qv8JGVQhJCmhmBcxKk9TXo7ltwDzggqiUrn2WT7yROuGL41CfZT9BR3ewIcInCE95Mrs4v0/uGNek6ghK3U/UahncgkIRraJ+BtmnjPGjjcpi7A//U5PmjjCazD5Cvl1kJcIy23/pf8GkEru74nuGFhhYm1xhkXOVOvAZaKX7dVVOv4A8H1aRzfpwTdj+DYoxRzeTwNFXpCUCuvP3QGCozbJKzXMc+z3jq1b0SWKf4JDhroVXWwB4jbSjZafe18E93TGDq0FNNqdEI/PDYIUV77JmntQMCYa/eifbSbgm5hJtS009dA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(36840700001)(46966006)(40470700004)(2906002)(5660300002)(8676002)(4326008)(70586007)(70206006)(7416002)(83380400001)(36756003)(36860700001)(8936002)(316002)(4744005)(44832011)(478600001)(40480700001)(26005)(41300700001)(6666004)(82310400005)(54906003)(110136005)(86362001)(426003)(47076005)(2616005)(1076003)(966005)(186003)(336012)(356005)(82740400003)(81166007)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 11:55:07.3682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a7f3946-12c3-4ff8-8b8c-08da7f7e2a1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2772
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is a follow up for patches 2 and 3 from a previous series:
https://lore.kernel.org/all/ca4c97c9-1117-a465-5202-e1bf276fe75b@microchip.com/
https://lore.kernel.org/all/20220517135525.GC3344@hoboy.vegasvil.org/
Sorry for the delay.

ACK is added only to patch 3 (now patch 2).
Patch 1 is updated with check for gem_has_ptp as per Claudiu's comments.

Resending as net-next was closed when this series was sent a few weeks ago.

Harini Katakam (2):
  net: macb: Enable PTP unicast
  net: macb: Optimize reading HW timestamp

 drivers/net/ethernet/cadence/macb.h      |  4 ++++
 drivers/net/ethernet/cadence/macb_main.c | 13 ++++++++++++-
 drivers/net/ethernet/cadence/macb_ptp.c  |  8 ++++++--
 3 files changed, 22 insertions(+), 3 deletions(-)

-- 
2.17.1

