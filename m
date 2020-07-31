Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0C5234447
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 12:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbgGaKuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 06:50:11 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:53202
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732603AbgGaKuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 06:50:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RpHXpIDQUcZ950Mz4lzYVTDB3MH3bVEiS6ScpaZltLI9kc2uWC6rqT8w8kdRp0QHkJ28a+rqjo+qqbA2ICVfUqCS8Nifk1lvNfzSBriv2dJoqcZPEvpMCZBujsKX4e4L5973OTtGACkpqnTHuNVWUjQG3epeW6eL+2PwUq39LiB9MiteJIOMzJvnrxUmDyJAAuJ1ne45My6Oq93jOO8O3c5GFRxz5hdbpeHMHY9z7PMnjmFilNvv0rGlfSI/U92xrtgQHLLA8WqvcrvnCBMVMHAr0qH0/TKLXlrSo80PuoqmOgBZ2tCn8D5MW9Q8+P5tP0w33G93Csn+eBCwIoKktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6GlLuC1+27Yc2RsbK8XJ2jfktPx4G5JeeDQhlePDeI=;
 b=U2Rmr6zkqRgNI/AaV6BpYRmUFIW0beLG1UH3fmW6PFPrkLt4JJWMBSpUl6EqBDUzMLgrul50NK7DjloteCXS8+CQkDyU84trHnf6CTNaFRRyHWrfw1Lf502jhdjcCJXBSPpKjrsMNkGdyzxhy9RjWesfM0ZHnkd+LAwnAusLAfz21GhIS8qnsbigmk8PFYEmx4tXfBI1U+I/wwR7F5l0qprGyfhDRWPG8llC3NqJzzQEwEKq32Xb+mkaH537eivwFtI9UbMabcGTB/lRIJUdTVMWabvzmdU9qwzIBkdB3Y4vmvRS2GidrthA6PwXeKm09/yKzGpHxvKpgfNAwNo4tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c6GlLuC1+27Yc2RsbK8XJ2jfktPx4G5JeeDQhlePDeI=;
 b=V85PCcNILpVNiGuHVPqRWNVTXEWD5DPV0riE/73I2S9t0auhv7kf5sFiRmiJZMFhM7BWqAEIE3JM9eQXenBsYMlZPSWGIlMAhDqsB2jWnL8gdh3LlgZHbXYToXYZTSjhZ6NbvmMgLPcNPQFNEVr9ATMBWT+Wm/vhsN8tEk4p5SA=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR04MB5943.eurprd04.prod.outlook.com (2603:10a6:20b:99::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Fri, 31 Jul
 2020 10:49:55 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 10:49:55 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Markus.Elfring@web.de
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net v2 3/5] fsl/fman: fix unreachable code
Date:   Fri, 31 Jul 2020 13:49:20 +0300
Message-Id: <1596192562-7629-4-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
References: <1596192562-7629-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0103.eurprd04.prod.outlook.com
 (2603:10a6:208:be::44) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR04CA0103.eurprd04.prod.outlook.com (2603:10a6:208:be::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 10:49:55 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: debe6ea2-c224-43e6-c49d-08d8353f7626
X-MS-TrafficTypeDiagnostic: AM6PR04MB5943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB594347FDA0DA73C45BCB8F5DFB4E0@AM6PR04MB5943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7DEhBArrda9sHwzvPR5xbUXBtubCTuDYo50UdPocq5ni4RQsP97Im8aZupUnqpSWij2mRi38iPbREtVL80NmWjz4F4Yow/XipB34YO3VmY40O+BGC1Qasbu2zu1STU1IRecpm9kq7JKLtfdMsRrHjO0Yhs+zAYIqk8GOzmlL53pG6zKFHZBINx0cpa3O8k7w+T1R2UQLL4Mzo6WTcv7uxWplwGnaGfxArNIxIdXwpSHN1v5WVeomJXMEQDBmWV5/1OFffrtD0iqYnabLA0eCYyQqRmj6NF8Xm+YFBKuMQAN0M0+TavVRki44l9lN6H0W8j6VD0XOTdproDLgJM/TLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(3450700001)(6666004)(478600001)(83380400001)(36756003)(52116002)(2906002)(4326008)(6486002)(316002)(66946007)(66556008)(6512007)(5660300002)(8676002)(86362001)(8936002)(4744005)(956004)(2616005)(186003)(16526019)(26005)(44832011)(6506007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1WNSESmY888oLJ/mCYV0hyDcC9t93b0WCm5bB977rbhEoK46lcqd2IEII54KVtu9oRSuQfrVEdjZCnXSTC5toi3aUv6+7YqZO9PtfWLEqbhaizDRnw/ZqODx06NB4W3GjO7syuWaxMZgTvoTw78mU8zUNqRSEq6tY83+465zadvo/AgbexccMoKpT/JfaChGZQNs1KML9hxsMig5pAOLneqJtInJQxTh0Z0YgeIFSHOSS3Uqr0gpqo3VFhMJ3LxVSpNof+RQOVq2jqYxqLqOSc+aSZj811dslwiYvDeu61V5bL0dY+GoJQTgCqU9H60/JJD83PCFfYZIWB5Vhb4wGjJDPQuFZc8v2ffuRcQEWFfEk5QX7Raem5R7pMCFWObHv0kc0kUJ+vwj+Kdlv23281432fXlGzq8G1ourA6pTnJLu0jcz5Dx0TWL7JH30pL+pQdiURAlDu77s7IqSQp/bWaIsAqiXLmxOVeus5LcRMKBavohq790pCQSLC2+e0bvbd4m090Gbw4LsczN/lrRlB4hAiv9pjdptSGDll8IQvScNYJ39iC+DmfoRPGCIID8n3iXwSjKiLYMVbx/pHin5Xbhx3d+LkTCrGYEXuwl/QetaBRP9PsieHnctZHhmsDHMUdr5ziQe4SRppnurCVLyg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: debe6ea2-c224-43e6-c49d-08d8353f7626
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 10:49:55.5928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x6+57e4hr+Dd/9Hwock3QmSyfSStULz+CmOzPBnHtehehpVkxLsmW6A5/AkSsXY7gFbEH+HDwcfEHdc6VjRm4hUlx6sBAx8mx5Cl0QcRgYk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5943
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter 'priority' is incorrectly forced to zero which ultimately
induces logically dead code in the subsequent lines.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_memac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index a5500ed..bb02b37 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -852,7 +852,6 @@ int memac_set_tx_pause_frames(struct fman_mac *memac, u8 priority,
 
 	tmp = ioread32be(&regs->command_config);
 	tmp &= ~CMD_CFG_PFC_MODE;
-	priority = 0;
 
 	iowrite32be(tmp, &regs->command_config);
 
-- 
1.9.1

