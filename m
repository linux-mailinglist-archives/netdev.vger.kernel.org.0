Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E441F57DBE7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbiGVINJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234866AbiGVIMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:12:51 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F241B9E787;
        Fri, 22 Jul 2022 01:12:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3kfO7+CL/X2BDrTl28DV1og1gMgfw54MxI7h5AV6EW1QuSQFbAnKNCFWLST/6dcUR3BvHiEsCkslX0rbQ+j4/a6MK3dyoW8vNVDrrxKrHse/FO52uGYiIXZ68khuu3ffJOHq1cgaxQ96FB//TOA7ev9yIruMRa+mo/qcoQHaRdOOxvIg92PPND63al2iJL3XpwwhVm8FVFrBy7nnmpCz8betZCRzZCBDzAiU+qVYB0BFvlsf+ZKGx9ZVlk+iha3quTwvxcIE+AVToU27Xc1GmxNs0vGZg39l86LgA3QgY1wNxEe2htqJWf30158kto+cqQLxe6cTLNj2HtD9qjOGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uFksvKC3MhMib39+gWClGvVTi/XDHbvw9XNRnLc8QKY=;
 b=AL3t10j35z3jctvu3vxLAE2mbZPfB6J0uhoETW4sRwa+0B1WRU7wqAP3wHJYct6qPtS6BuK1blyEXCCfsyF4hSmW5BoPKh5DAxHJsVOr8pzZ14s5xPB6G4KDOVrKykvl/WUq1Xt4UAqlBR4ncPQYj3T4E4MIY8/LP5sUAQPs79dm+yYziN+jWKR2Y4j80AxOMMuGPwFhmZTqPXqmK6aY99VkO2TnkWEH7bfGnJO9DtZX/E56xtKIuJeXWZ7H1/Iqrr+UAsKjB6yMUVz7XhcVoLhKmI1hJqXkHRqgXQn3J+HVXK5LocVjl6hmxzX0y9F6Xt1QVwuatqULDNqpZn64og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uFksvKC3MhMib39+gWClGvVTi/XDHbvw9XNRnLc8QKY=;
 b=V+oa70hCtXdBGpiWkmh1KLxZyX1sfidyn2hhb6X2Q5Ldl68c72NcRD1zSQ2CzHZswXb8qzdVQTbYS6TLkg31oXYTa13KM8YW8glFVt59JU1TtMK2Hdvqmw7qUzopnGtabR8nF+Tixxfe7sSldoOwKzzBVDqtQqLZFFYF82+anVo=
Received: from DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) by
 SA1PR02MB8637.namprd02.prod.outlook.com (2603:10b6:806:1fc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Fri, 22 Jul
 2022 08:12:36 +0000
Received: from DM3NAM02FT042.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::cb) by DM6PR07CA0065.outlook.office365.com
 (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20 via Frontend
 Transport; Fri, 22 Jul 2022 08:12:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT042.mail.protection.outlook.com (10.13.4.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 08:12:36 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 22 Jul 2022 01:12:35 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 22 Jul 2022 01:12:35 -0700
Envelope-to: git@xilinx.com,
 git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 claudiu.beznea@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.2] (port=60636 helo=xhdvnc102.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oEnlz-0000Nx-6q; Fri, 22 Jul 2022 01:12:35 -0700
Received: by xhdvnc102.xilinx.com (Postfix, from userid 13245)
        id 6478F104569; Fri, 22 Jul 2022 13:42:34 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>,
        "Radhey Shyam Pandey" <radhey.shyam.pandey@amd.com>
Subject: [PATCH net-next 0/2] macb: add zynqmp SGMII dynamic configuration support
Date:   Fri, 22 Jul 2022 13:41:58 +0530
Message-ID: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 850eeaeb-d94f-456d-42e9-08da6bb9f017
X-MS-TrafficTypeDiagnostic: SA1PR02MB8637:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xkatV1zde8hDWG8fGB0q2OfrwhGGdneip1mwhpdUVZevEcA8E7i/lsTt8emhy5WyoQqysY2gK5FLiOjTjQn+wf+obrSrmJhyn4QunYly18IE/5QT3fNYoTbgEYxauIJWywmxFOa7iAD9MLk/4xZrbxu8KCTjJ1cHhO8qfm7Ch6YrhxKMZwNEk4caiTBrRgv67rJIPansLSCmhXRI6E95gDrcmWqbEV/Y1sfhpqbCtroZnJkyPHFmZORWNiH0Okww5gwAP3/MaHFOeSnutGIS80KfAy962SFQXoVklrA53TROYbNkhc9tWGnwKM0c5WxnhrldrzH54udHzCPnhjtrxpOfdQuUMbNOGI+zagk9WTBHYkKnVs9gn8w7TT1rQ/aieWq3ZSw8NnMNsqf99d5qJvtc4Dp1j+6zPnPy+K04ahKUCg4A0ruS6gwAPGBF7rgj4F+8Gag0QLA3JinyX27osdL0eB0AzMZ35U4QDmS+GLqBY+e6etVDbLCGDQ7l+SKW+mS77Pb6AlMrbsat6ShgWvJK92g0GxzEjSdhyfp2C8PjDsGXK6ZCw++l/3pMI0riEMNySWLjtVJaNhb/emWDSBhphrsn84nWWxjnFv9DJ0nUSBPzFY9n1dV/1kSJftnmXROwmPmSo3EGqGPZC++NQiAqflt9yJeWHpCebcsFRQ3T9BO2IGZe2aTV4XGa4Rg0Mxn5U9VLHbA83OQ2HAw5SCM+O11iPJkkkluLMP3IyY5smhn+2mVWzo6hZeBbqQTuYQjezRBkikyc2i0wMqu55fdlCGbPyWgs9rfwpIpoJ27HGIHAQKJfd+sgLoVvY8lTRN5nW9nu0Eo+rCP4GIVWrw==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(39860400002)(396003)(36840700001)(46966006)(40470700004)(186003)(42882007)(336012)(4326008)(47076005)(70586007)(70206006)(8676002)(36860700001)(40480700001)(2906002)(82310400005)(36756003)(5660300002)(7636003)(82740400003)(356005)(8936002)(7416002)(4744005)(478600001)(42186006)(316002)(26005)(6666004)(41300700001)(40460700003)(6266002)(110136005)(83170400001)(2616005)(54906003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 08:12:36.6587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 850eeaeb-d94f-456d-42e9-08da6bb9f017
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT042.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB8637
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset add firmware and driver support to do SD/GEM dynamic
configuration. In traditional flow GEM secure space configuration 
is done by FSBL. However in specific usescases like dynamic designs
where GEM is not enabled in base vivado design, FSBL skips GEM 
initialization and we need a mechanism to configure GEM secure space
in linux space at runtime.

mmc: sdhci-of-arasan: Add support for dynamic configuration will 
be send post this series.

Radhey Shyam Pandey (1):
  net: macb: Add zynqmp SGMII dynamic configuration support

Ronak Jain (1):
  firmware: xilinx: add support for sd/gem config

 drivers/firmware/xilinx/zynqmp.c         | 31 ++++++++++++++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 20 ++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h     | 33 ++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

-- 
2.25.1

