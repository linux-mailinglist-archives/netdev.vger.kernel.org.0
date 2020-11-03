Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46872A442C
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 12:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgKCL0i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 06:26:38 -0500
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:1661
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726058AbgKCL0i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 06:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRzmMNxRm1+uPzRAhszx8z7cq+iO75G4Du5w7Tva75GIIuxvcFsUNiyhB8/C0aQty8q8w+SuRaWL+aYPPrlfeK5aPF/S2zjPHqnBDoymlCTU6pOB6SinuGtKT6Lz98/xCYWg2Aai1g5hBxCm7NFqCRjpmPMYGG2qcvb8Q58av/d0Btye3byiMUPnZ3FRcwO8YUfpZdTkHdS7zU5kfv4cKGEGze85W/thW4PjVv05NVnYSztFtHHcSYajZBHQAZfUuJbl28ASaNFF5B4fJytuTyFx5JqOlOk3eLR3Dwo+J38KlSfGNsiAzI8fjZAvKTAuIEe611t5PMpdaDMQwngKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AId25eaEt+HMjxOwWABVPE54f8c6ZMKSb14uTJQCogw=;
 b=C9pLmW8Z0axF3LHFfWlY+CQLllLAW583NzK3GBOHdV01+kqZmPdQoowcfjKLhT6XezVHVDOH0KWXFGTTEkWEO/lqoSKrX/koTSBN5Mq51CAjK9KesRkKz0Oix1TKvIkTmzlpxJYrXqTLHOJZLmG0nbKeeN+1xyfke4Yi3c9bq34lu36Q+DxzdpRRY6r4EmPR5tLZ4g5jnFcZdIM0SjHzS0jjF/quCZcXKvo/A/Y8AjaWQCeI6wdnMgjsYj8A0m6BKF8FJS9uKL/LptuUljUK7arLQ7BE4jQtnuepVqPZ8oc+AVW2yCj7SS/oFxecKAF5p+Cw6c4QySNmYlGo7Ho1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=davemloft.net smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AId25eaEt+HMjxOwWABVPE54f8c6ZMKSb14uTJQCogw=;
 b=HF4ff6qwQYY+IOYV3uiVkatUkDEPtXJh5eenAyYAuUQ33IV4LqSbU062TXBdhzZy4NyA7JwSXxw/fVfWXrayf9Ty+oPrYSe3SlTx5hjpUbMNkQYMek5/DptB5/3w3urOBgZcE1Bfn4B50cg6G37e25mD7ThTUt+7Kas61OOCwac=
Received: from CY4PR1101CA0014.namprd11.prod.outlook.com
 (2603:10b6:910:15::24) by MW4PR02MB7124.namprd02.prod.outlook.com
 (2603:10b6:303:7c::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 11:26:33 +0000
Received: from CY1NAM02FT061.eop-nam02.prod.protection.outlook.com
 (2603:10b6:910:15:cafe::b7) by CY4PR1101CA0014.outlook.office365.com
 (2603:10b6:910:15::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend
 Transport; Tue, 3 Nov 2020 11:26:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 CY1NAM02FT061.mail.protection.outlook.com (10.152.75.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.3520.15 via Frontend Transport; Tue, 3 Nov 2020 11:26:33 +0000
Received: from xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Tue, 3 Nov 2020 03:26:14 -0800
Received: from smtp.xilinx.com (172.19.127.96) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server id
 15.1.1913.5 via Frontend Transport; Tue, 3 Nov 2020 03:26:14 -0800
Envelope-to: git@xilinx.com,
 michal.simek@xilinx.com,
 davem@davemloft.net,
 kuba@kernel.org,
 mchehab+samsung@kernel.org,
 gregkh@linuxfoundation.org,
 linux-arm-kernel@lists.infradead.org,
 nicolas.ferre@microchip.com,
 linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org
Received: from [172.23.64.106] (port=57202 helo=xhdvnc125.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1kZuS5-0008FY-M6; Tue, 03 Nov 2020 03:26:13 -0800
Received: by xhdvnc125.xilinx.com (Postfix, from userid 13245)
        id D5954121187; Tue,  3 Nov 2020 16:56:12 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <michal.simek@xilinx.com>, <mchehab+samsung@kernel.org>,
        <gregkh@linuxfoundation.org>, <nicolas.ferre@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <git@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 0/2] net: axienet: Dynamically enable MDIO interface
Date:   Tue, 3 Nov 2020 16:56:08 +0530
Message-ID: <1604402770-78045-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.1.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8f116ff-bf35-46b4-550e-08d87feb517f
X-MS-TrafficTypeDiagnostic: MW4PR02MB7124:
X-Microsoft-Antispam-PRVS: <MW4PR02MB71242C8B749B95691CB55196C7110@MW4PR02MB7124.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7nKZI226q5+029JMFpDUBrhHsYB1dmUspucdGRS9ihekBfnJD0Q2GdOqVTio6xWv5rnzrj/es+PORkXPS9xHQl7lezMk5w9vgRxtSOiurhUc/F/tyrJYqLkD+i9kbnqN8406DsepcNMCryKdPsAc9Up9jTt5oaF+9HUrjvQY1fYWIB231qzwTtfqFwo883/EVO8OzduH4kUNDAe37lcHTciLQCdwW71RkgVV5QiqL+7EhuE8kGnpVy501ioUplCxm0LX8UAyrD/N69ZA0BRdcv+v029b53hsnU545/k0WUtvtl4VlTJWsTX/2SfP+sUoZL3QgJHRhiB1UcpUnT4c1mE7QfeIYLkQZaevp7OTSSzRXcns24ygxXwukM9ZDAQu5iL06dYOFadWUL23TaA0O6floFhLUGr2JS+HeCyRTc=
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(136003)(396003)(46966005)(356005)(82740400003)(5660300002)(426003)(7636003)(2906002)(70206006)(47076004)(70586007)(478600001)(36906005)(42186006)(54906003)(110136005)(336012)(316002)(186003)(8676002)(83380400001)(8936002)(4326008)(6266002)(4744005)(26005)(36756003)(82310400003)(6666004)(2616005)(107886003)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 11:26:33.3626
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f116ff-bf35-46b4-550e-08d87feb517f
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: CY1NAM02FT061.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patchset dynamically enable MDIO interface. The background for this
change is coming from Cadence GEM controller(macb) in which MDC is active 
only during MDIO read or write operations while the PHY registers are
read or written. It is implemented as an IP feature. 

For axiethernet as dynamic MDC enable/disable is not supported in hw
we are implementing it in sw. This change doesn't affect any existing
functionality.

Clayton Rayment (1):
  net: xilinx: axiethernet: Enable dynamic MDIO MDC

Radhey Shyam Pandey (1):
  net: xilinx: axiethernet: Introduce helper functions for MDC
    enable/disable

 drivers/net/ethernet/xilinx/xilinx_axienet.h      |  2 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 21 ++-------
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c | 56 ++++++++++++++++++-----
 3 files changed, 51 insertions(+), 28 deletions(-)

-- 
2.7.4

