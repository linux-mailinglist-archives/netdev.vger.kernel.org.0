Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889FF57B579
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240925AbiGTLaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbiGTL3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:29:42 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2796F7CE;
        Wed, 20 Jul 2022 04:29:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YToVGJQttCUh+S2RcQ2M426oqjvznc4malJSV8NgYUDEhdz1d+a8ZLi9DxAEpBPVGbzFHSCzdzhx5MeQ/B05ImJMAsmUI1IifQ/YnWZJ9AC/yBfm/we4rLRWIIOidA2ghnv4hN+uARclkeM7pEim1nr4EYHB7UaDskB8dT6tTgHSagCk6g3SB0AQJ/HriF16vQMy9S5cgkVJ65fwxYhdy5D4wBwUjzeL/ydf8Cmb9cEanFOD6Z6i4ukJt6M3aVIH6XQmNoGNc/JUvalacShcF1/zAtvloFuhMzmkgaGRQkw+mRn5gXVfpJOj39KEomvcvYxlKRLflZpTuE0rGbwoEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kh69VC/iDq5DbcNIh4VRZTSNXiqsNSndlqU66rZg6vU=;
 b=bNhd4lsXz6spIBMl7hevcrhbpYlJfs8eyeGAJMXkh6v8h/tAqFzn99efMebzM23Y1bJxtzflfQcwwzbMFwuNHvROismQFwPC+Ndw/uE0PV/VItE2jeKfsBzXHoT6IYwj648zoe0RpjJN/6hxlMEWHOtadpBszxmm25sfj07rnlkg6q2QKYxBoQfBygyFiCG3JwbwHkmmCYBb6C3slq2PgmMIok1JBdEm8AXp9FL11xJMiA+gvWgPnUS+MpfwFSsLaE6Q0JYSJ9GGNyYtb6jaoFHHRTQvTHzSjV2j9meJvy0kzCW8CBhvdV6vvEoMpreAoO0xxvCiQBXTTBIrkWs5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=microchip.com smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kh69VC/iDq5DbcNIh4VRZTSNXiqsNSndlqU66rZg6vU=;
 b=RfYVUJEK6x2wogGSSlvVZ2kDz/DNmuKU/ZEis4f6/IzReAlBK0qysYv9B6k9XqJGmrNlx8Irhe+84KCL6usyZjk/lQmYXH0coOaLrMgYi0vIuzNrhskvNNVXEB/608p8GEGqaDdhguIBX6WSYT2lMC+Q9Svkt6FRsOdY8d4T00c=
Received: from BN0PR02CA0019.namprd02.prod.outlook.com (2603:10b6:408:e4::24)
 by PH7PR02MB8955.namprd02.prod.outlook.com (2603:10b6:510:1f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Wed, 20 Jul
 2022 11:29:30 +0000
Received: from BN1NAM02FT037.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:e4:cafe::38) by BN0PR02CA0019.outlook.office365.com
 (2603:10b6:408:e4::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.13 via Frontend
 Transport; Wed, 20 Jul 2022 11:29:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch02.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch02.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT037.mail.protection.outlook.com (10.13.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 11:29:30 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 20 Jul 2022 04:29:29 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Wed, 20 Jul 2022 04:29:29 -0700
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
 devicetree@vger.kernel.org
Received: from [10.140.6.13] (port=60628 helo=xhdharinik40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1oE7tQ-0006pR-Up; Wed, 20 Jul 2022 04:29:29 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     <nicolas.ferre@microchip.com>, <davem@davemloft.net>,
        <claudiu.beznea@microchip.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>,
        <harini.katakam@xilinx.com>, <devicetree@vger.kernel.org>,
        <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 0/2] Add Versal compatible string to Macb driver
Date:   Wed, 20 Jul 2022 16:59:22 +0530
Message-ID: <20220720112924.1096-1-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ffc087c-2e86-4908-4905-08da6a431cb3
X-MS-TrafficTypeDiagnostic: PH7PR02MB8955:EE_
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ot/4edbMh1VMZgYtxzvy9UluBoam+CY/drYnyYNohxN2l+FToDbtl8RLsvh9RKPhL3SKcfrIkcnTJpTJXbrnq/QJYYsJ/5N0acjEoRkBevUT6N3pR0nbP77ndzn7v/OLted864F72kCxb0FNae0TPK3eioR0p6y3Jrq1qiY+4S3kGsbxdp3x7Y+ioSynJdvPVK3pFRORlpM+rpTqfWUqNbrPKJPX9JuwITM+2+knA/yZwvGKYZJhrzWY3xxJMFN+Is1eEhHlEk4uqL0jmV0o5gX+xzpW7sZOpkxQ5XC6GzeYQ3cGIbV+Gi767TMyH3xD1ic8dug2IgQihH9/CxrnumGVGw8ScXy5QHASl+e1y4HHPleZ3fo5ZC0u6BgBAfwYcieHBK9Lgvf/yIl2iWtTfir4VeWtdM1+k6zbJU3G2Yc89bSsu/wyhBp5EkUosHKg4/stN0gawjAPb7RMpGYjUc5kEuyK/L17ka4ULCHsKhQxTTq5YFF66XesBG0KRgnEpigge8f6339ZqH/YWYviRvXCHdisWKIumhf3+DuqIx/Zf9R/uGJFY80rWDsY7+JryAS54ktAzot6foY1XqG2+es0PvJbGxrSJZvyh3JSLfus3OduL2hpATInsF9cWB89gxpNTbZ8rarvJnR0Y065PL62f1bE5LH/ZFBCPwNxDBTCGDBuGnycWbGwMP48ck4BzmLnNj9pdFfRjfZfk7fYIMm46FlTty2GSJ1TKLMflIQaFtIeG5x7S3SRMHNOXXjXNMSiLRCR+b5UqQ+m+UuHr3oZ8u5+VHAW2uEoVdq9f+GTJvQb2VOZC9HfMO7Fh3wHnHjAOaqNi2au2frvkaaSjg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch02.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(136003)(396003)(40470700004)(36840700001)(46966006)(316002)(36860700001)(110136005)(336012)(82740400003)(82310400005)(70206006)(8676002)(70586007)(356005)(7636003)(40480700001)(4326008)(54906003)(47076005)(36756003)(5660300002)(41300700001)(8936002)(2906002)(26005)(4744005)(6666004)(83380400001)(478600001)(186003)(2616005)(426003)(7416002)(40460700003)(9786002)(7696005)(107886003)(44832011)(1076003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 11:29:30.1805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffc087c-2e86-4908-4905-08da6a431cb3
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch02.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT037.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB8955
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add Versal device support.

Harini Katakam (1):
  net: macb: Update tsu clk usage in runtime suspend/resume for Versal

Radhey Shyam Pandey (1):
  dt-bindings: net: cdns,macb: Add versal compatible string

 .../devicetree/bindings/net/cdns,macb.yaml      |  1 +
 drivers/net/ethernet/cadence/macb.h             |  1 +
 drivers/net/ethernet/cadence/macb_main.c        | 17 +++++++++++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

-- 
2.17.1

