Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B177857E06B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbiGVLDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbiGVLDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:03:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2075.outbound.protection.outlook.com [40.107.220.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9176BB8D7;
        Fri, 22 Jul 2022 04:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaRVp/lvWFr48cQLI9qCxuoqj2VUDdAnGVntDtM/SuW8eQ+HNficpZLpcI/ui4HTY8zZAN74oOOUyniN7W8K2dInX1tTqb+y2ryrL6++KZTUzo/4EGiVyJnoQbJXQLlbB3CcXApF6kUxtOzLSo0COTDSG1J186+AU5PGjs9yfPvEhSZKq8T1Wx6BRr8rrs1Q3atmPtYeVtDQqMUjR7RF/XfC2xucfvE6UyFUGztXE4cLjRx8qpw6CUbxsgpv6iSTzfALOzhfM5EJO7LX0JB8dA2rrqxr1PpHocj/Q3FxuSqiIc3ip+i5xFkSuZ6m/EmKFsmdlPMxc/38RJBUx8dhJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9nDcrDnl1U0QJzWkrhdXtVYEPPySUQXdNItBOiQIA8=;
 b=V+6ghhae+MF9PJR2XnInkLEks/CUEVaJLXovhRckvcE5VlLxYTE7QM35qZnbFxVgQlAcTdJQCtj0ymxuv5kw3wgxiUeRz6pufH3Y3RKfElrCWyRwjsGYxg3kQFhZezbUmI7aKTNSrZQEhvNkUlnptTkl4jP4LEVC2W/j4MXrP7qNyjVq7gLgqManVZtaGNgIDcLHsW+mQY4RZ0HgfZt1WDrlpJvCJEZC52pSbccxJVzLFqQjUr3N0xMd5rsz4ePofwblGRydNG4Iug2dlcgimk7cv45MVnrqYKwSyGVb1GDK2CsqXSGC/D9WvAJA+hDB+uP9LOYP5WnAi5kcfj+eOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9nDcrDnl1U0QJzWkrhdXtVYEPPySUQXdNItBOiQIA8=;
 b=nR3Uanam3z3togmH5zN84rPs7wgmGp2VdNNi1Few+7UMFqq0l5xCfzBTlJD1rL6sQpMlru4lPe2XsEtlWdfkBxd+RzN81vjk0mzWHU8ZYTEu8oWDe1fvDGJklMgeVrHSyz/6iVuwonktTL8btyQlSQBsxXHUNjXVUBzXgFAqzQc=
Received: from SN6PR05CA0022.namprd05.prod.outlook.com (2603:10b6:805:de::35)
 by SN4PR0201MB8792.namprd02.prod.outlook.com (2603:10b6:806:203::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 11:03:40 +0000
Received: from SN1NAM02FT0005.eop-nam02.prod.protection.outlook.com
 (2603:10b6:805:de:cafe::e8) by SN6PR05CA0022.outlook.office365.com
 (2603:10b6:805:de::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1 via Frontend
 Transport; Fri, 22 Jul 2022 11:03:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 SN1NAM02FT0005.mail.protection.outlook.com (10.97.4.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 11:03:40 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 04:03:39 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 04:03:39 -0700
Envelope-to: nicolas.ferre@microchip.com,
 davem@davemloft.net,
 claudiu.beznea@microchip.com,
 kuba@kernel.org,
 edumazet@google.com,
 pabeni@redhat.com,
 robh+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org,
 netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 harinikatakamlinux@gmail.com,
 harini.katakam@amd.com,
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=33588 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oEqRX-0001lP-9K; Fri, 22 Jul 2022 04:03:39 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <harini.katakam@amd.com>,
        <devicetree@vger.kernel.org>, <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal compatible string
Date:   Fri, 22 Jul 2022 16:33:28 +0530
Message-ID: <20220722110330.13257-2-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220722110330.13257-1-harini.katakam@xilinx.com>
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd7b5c7f-0282-4560-1ffe-08da6bd1d5b0
X-MS-TrafficTypeDiagnostic: SN4PR0201MB8792:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNZwcv1RCQ7upfVHVo8xbI+hFQNlIOKN2MB/uCkpj2bBpn8iq5TUUNk3fpHWJUZ6NIauQ8t3cfLcHop/A+ZatFP98P+HmUo31Yxjgy6vxLuq6hBAAO/9jfKbwDhU0TYRZ/TY3U0jr2SGEq1hC0yjC2Oxk6V0KBu6gXmywTXGM8I0vLkt9TefPb9J0kt8JmlIFYx6OFYR4sM6RFwh0NacVB0oHMfzzMF/APQf/RNvaaVJEwDfGcVLPxndBIGlmORtd2GC8hp7pEI2I18X7rzShC9gV6IzlEUb22nZMasK7ZYFNkDn4vK8trs+pOTNwW9dR5qCLdDHeIy3HdDbTOgb/lAC9T8NYxc819G9TNY/FRKtiSbKDDsdCj2NBVxfzf6JGbhrLexiTPqjiwEnl0HB53GBBJ+tWex6RsZlAsRLfItS8y6ZT/B4lo6/+nxpW/WpWeKp+l3nKSEcukFhiq0hedT9M/60P4026Hi99ztHdq2O5HaXhTCbMHm2pSNRVjFID8Ix4wt3lYZMj+reqpx/2BKLB/VBqIz5o3sKECrC1X8V/ijbifCnwIqw6thQIQmxnYHU0Zi4TzOSuxs1NABizcGAwMa+oFZRuN/Y/SWF42HRomZNYxW4ZlPYYSMPdOKvcDVtJ5iEm39/Hd2h/6PL+CFfnFNSdMMw4oItYUxwCB+pNMkvVquW5Er/YZV+s+kcvxGLuF2XlB9YzK+6tdV9IIe1CsrdbO6u+CN5ZNTRcjuieUkBITmZxk8DzTryYWjlLGMDVDVuWo1QCKk3k0lHwpj8lAhOOVypzUwhsKLfmCa6E6zDCiQkH2/f79wNKOe7KkdSLI+WJRksJx9xBz736A==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(346002)(396003)(40470700004)(46966006)(36840700001)(36756003)(336012)(356005)(107886003)(316002)(2616005)(6666004)(41300700001)(478600001)(82740400003)(1076003)(186003)(110136005)(426003)(26005)(44832011)(4744005)(7636003)(8676002)(82310400005)(7416002)(9786002)(4326008)(70586007)(47076005)(5660300002)(8936002)(40480700001)(54906003)(40460700003)(2906002)(7696005)(36860700001)(70206006)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 11:03:40.2991
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7b5c7f-0282-4560-1ffe-08da6bd1d5b0
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1NAM02FT0005.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0201MB8792
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

Add versal compatible string.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
---
v2:
Sort compatible string alphabetically.

 Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 9c92156869b2..762deccd3640 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -20,6 +20,7 @@ properties:
 
       - items:
           - enum:
+              - cdns,versal-gem       # Xilinx Versal
               - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
               - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
           - const: cdns,gem           # Generic
-- 
2.17.1

