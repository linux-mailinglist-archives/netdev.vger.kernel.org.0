Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559835B884A
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 14:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiINMdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 08:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiINMde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 08:33:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E773236DD2;
        Wed, 14 Sep 2022 05:33:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GipRR9oLQqDjYLVXBO2tUnE+zwwx+UQKXVhtVvXgZY7R6mG1gkRapPxHTkwYPbjQsFQnE8NsgP+RoDhsIb1HI/gMNwP++K0i3AxgTMkda9MFxjAyB5NAon5+zDRq5UVXd0WahjjJ63tqJZ7OWYN8U9Qy9C8pJPD1UcWFH/H+8xkk2P1raEubN2tEQasnfdSoW6EADzrjFg1wYYBxJ7OZqq8PDJ3db1ethO/Uq1lEKFHXtgy4qIkAL9kFtr6UgrgD/AzlPHl29sCyaTVGLE6epvhNgjXJfg5mndq3jypZqreIyHf6ec9vv+QdYB0ZZZh5UDVl0BhnskYtz6FqGpBPsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L6KSJFEGCKXULKDj6YcRaTO8VvBpiU3UwTBoHjMwhDA=;
 b=gXPd28Ld0w5RjyeZwm4YOL3jDrkFsWGL+g3aELM6tsD0P5ZsUCnK0vIyCbwOxtbJGy87F/jyUSyFh1yZikmLmAQz4r7MWj8BfmYOpoyAqMGt2MYlkcp4AUx6BWASDnWLO/dXtEf/TQTefcNWGA6dM2fG7PykzVYlem4xQLtqCmOkGzhzelzjnvoEpO0TlQa4O0z6IXQl5JTNhrOxeHhmwzemjyN+UNUd5jhgBcB+he46Az5bxunJjRBaYqTnj+NGHJqyhg8oIruBkPhRHWnjeB+pLqUlq0DW87+mxPClevn2CJSe5aX9ZAAnO5nQL9vCOHKNeICCnXsd/KHIbX179A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=amd.com smtp.mailfrom=xilinx.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6KSJFEGCKXULKDj6YcRaTO8VvBpiU3UwTBoHjMwhDA=;
 b=alxGqWHpL0sLeeHZc0iWSiu6YIV+4M7bsRtdYJBZYJ7tDCEBSVpiWrByDvc8obEhEndwAmZjdwdxoiBYPL5pRPTx5Yv4lk8uwXZdZOrgRh7N/myCdMnIh7SPOdPCcZrpuY5RG4QTzPX+BJXuPWPKArviBYoMzrJJHU4T9SUTV1U=
Received: from DM6PR02CA0039.namprd02.prod.outlook.com (2603:10b6:5:177::16)
 by DM6PR02MB6730.namprd02.prod.outlook.com (2603:10b6:5:220::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Wed, 14 Sep
 2022 12:33:32 +0000
Received: from DM3NAM02FT022.eop-nam02.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::8a) by DM6PR02CA0039.outlook.office365.com
 (2603:10b6:5:177::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Wed, 14 Sep 2022 12:33:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com; pr=C
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 DM3NAM02FT022.mail.protection.outlook.com (10.13.5.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Wed, 14 Sep 2022 12:33:32 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 14 Sep 2022 05:33:31 -0700
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2507.9 via Frontend Transport; Wed, 14 Sep 2022 05:33:31 -0700
Envelope-to: git@amd.com,
 radhey.shyam.pandey@amd.com,
 davem@davemloft.net,
 edumazet@google.com,
 kuba@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 andrew@lunn.ch,
 claudiu.beznea@microchip.com,
 conor.dooley@microchip.com,
 nicolas.ferre@microchip.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.3] (port=50634 helo=xhdvnc103.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1oYRa6-0009NF-Qn; Wed, 14 Sep 2022 05:33:31 -0700
Received: by xhdvnc103.xilinx.com (Postfix, from userid 13245)
        id 0C5971054C9; Wed, 14 Sep 2022 18:03:30 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
To:     <michal.simek@xilinx.com>, <nicolas.ferre@microchip.com>,
        <claudiu.beznea@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <conor.dooley@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Subject: [PATCH v3 net-next 0/2] macb: add zynqmp SGMII dynamic configuration support
Date:   Wed, 14 Sep 2022 18:03:14 +0530
Message-ID: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3NAM02FT022:EE_|DM6PR02MB6730:EE_
X-MS-Office365-Filtering-Correlation-Id: f6af237c-0627-48ae-c204-08da964d55f6
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yoMApdSQ+LqYsT/eJ6YkXGdlhlNHYCdAHdMNDjF6ba+pFbz5SsnpeS+FkeEKcx+CErj0EkluS41hPVYrJelsBlfjF6M7y95CohzZ75+uoRKYQc+xqWBJI3QyLQaj3R/quorqf7qAetk3hZEVD1PAlrXm5jH8Up02QO7noisAtfoyWVovyRpTCbrYsz3UfMVZ495aOT7CQwHbed8ohlvEZX/surVeS67juvEeZCp3lLdbQWCL0P+fd4yxbYerVJatfzaGM7ZAKzTJP30/jWjwBmQNWpgOtk9K0DbP9AR+mYJ3hYOKRbNzcq47FjidXa8DRyu6Ua8bTNqU1i88N7MuHHik0mWsAoV6p0rwQdeGqu8dedsyKHLgcV7WIoeYKvMqB70Vn1UMkoXhlrvpi6XQZWg42GA3vGncqmV/OEAG0lHZXx84+gSn2jgiMaDntBNVgAJP0MXam2YTj7GHgbdl9jmS1+iuNrHx5xyE1HzY9LGICyotXoZXty+YtYYLkYw5ryDXiKy1aSEOLBFbmHb670+uXmyWh7MNTQNzOS3K5BdN//ulAI0YSTy1b6UGvvgASTvpURvV2Pi9zxVzHFEoTtfxtzn+I8nxZ7OUxp8tgt4Nj6QtEmUHS1rMYCVnMFCc4k6CZiXuiDxT7aVoh9e3KyNEbTuFyo2Z16Jr18H1ECswKdQOavqYKM6+vVKBkGIKRtd+ngjbTyuT3F98YXQcErZrxmy0h6jD4c/xSga9vfgsqYXj9wREbHla8Le2EB9xDUTWdLHrDrV2i+YugrKzK7v893LmL5UuGQhJQX0wLyCHUMsPH/A2Qlhrr/7JrjAY
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(82310400005)(316002)(6266002)(41300700001)(54906003)(70586007)(2616005)(336012)(36756003)(40480700001)(4326008)(83170400001)(40460700003)(478600001)(186003)(70206006)(8936002)(110136005)(2906002)(42186006)(6666004)(7416002)(5660300002)(356005)(7636003)(42882007)(26005)(921005)(47076005)(82740400003)(8676002)(36860700001)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 12:33:32.4135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6af237c-0627-48ae-c204-08da964d55f6
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: DM3NAM02FT022.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6730
X-Spam-Status: No, score=1.3 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Changes for v3:
- Introduce goto for common phy_exit return path.
- Use enum kernel-doc comment style for enum pm_sd_config_type and
  pm_gem_config_type.

Changes for v2:
- Add phy_exit() in error return paths.
- Use tab indent for zynqmp_pm_set_sd/gem_config return documentation.


Radhey Shyam Pandey (1):
  net: macb: Add zynqmp SGMII dynamic configuration support

Ronak Jain (1):
  firmware: xilinx: add support for sd/gem config

 drivers/firmware/xilinx/zynqmp.c         | 31 ++++++++++++++++
 drivers/net/ethernet/cadence/macb_main.c | 22 ++++++++++++
 include/linux/firmware/xlnx-zynqmp.h     | 45 ++++++++++++++++++++++++
 3 files changed, 98 insertions(+)

-- 
2.25.1

