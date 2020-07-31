Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D17233F60
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgGaGrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:47:00 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:50639
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731369AbgGaGq7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:46:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPHEJLfbE95d+OGqjpIkWz8+8SLUcrta/LNpozn6lRlPB+Glv3LmAcT9YOAutZkYq1EqR87R2S47oWLKI43J58u0ZTaElBJWVUu7+1Km1YvKAhwh1pfFuFLUKEGEz7h69TAWsFIzwy6DoemgZ+g8I0NLyqppak+yNX0ZAEdPH3TvwlVBwA7CB+cMyCWNM3Rx5IHrGj+2MaQQGEON+C7L+jIOwtupUFdpIf6hWJsrgRcfSJ0D2DfBVmwpeNn8fGaeQMA9t6EHCNt0llCobTKacvgOEk5OlB9ie+064yaCkXSr8rZyCf/KX5EA9vgYcEn62kTLSQRONQvMy8w+m0RSdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+k3zTGIorzKzSF9q3bLCk7znC0tnDPekh7/p0sGHCM=;
 b=DYQFgJnGfT+MF+QjHl89gBSe4n2YKgW9BtgUYWITMV+QU7VVoHJfI5GbHoLbcm1zBNcWbfZ49RNLoCcofJnd8VmWzcwL1+Z1hUw14yrPE0xmBAJ2rF4F9BbMiHThTPmVVQlepvQI6Kka2l5yU2tsjPKoP1V8l5fu55EGak8qSO3/zFB1aEcWqdhLQdua2r7O8rhk5VH1mpsje4rrXnNqXyvF0IIF/w1GXQSGsg5RPWTftTXDzxSBZguCYL6KU/5Oz3s0l3PcFv8ttaRpXz1tgbaWd5M0bszr1EHtUDESQLiZbWFGIKZnP3BlTYahlfk4VV+WPsj+O+WLrqXGLzzx5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+k3zTGIorzKzSF9q3bLCk7znC0tnDPekh7/p0sGHCM=;
 b=KeBv5tCrGibuHiaaUACBO7g3ltnNB30M/0iHHNHH4C8WI5QFxw35rhNa38bAptFgcIT8Ie3Ga/HO9zPN1IbNWcXWcDiTGVBd/wUS0CwOq2lsmaRZEhudeoXqzp8qH3cHJcPffV2GUzYtJj0L9TUpO+kZodaeRGJxVfMVvhlrvDw=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com (2603:10a6:20b:94::20)
 by AM6PR0402MB3527.eurprd04.prod.outlook.com (2603:10a6:209:6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Fri, 31 Jul
 2020 06:46:49 +0000
Received: from AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99]) by AM6PR04MB5447.eurprd04.prod.outlook.com
 ([fe80::e115:af36:613c:5a99%5]) with mapi id 15.20.3239.019; Fri, 31 Jul 2020
 06:46:49 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     madalin.bucur@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net 3/5] fsl/fman: fix unreachable code
Date:   Fri, 31 Jul 2020 09:46:07 +0300
Message-Id: <1596177969-27645-4-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
References: <1596177969-27645-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To AM6PR04MB5447.eurprd04.prod.outlook.com
 (2603:10a6:20b:94::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3239.16 via Frontend Transport; Fri, 31 Jul 2020 06:46:48 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: defbf991-07ff-4240-c8f1-08d8351d8007
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3527:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB352717A061C2A37E9B12C994FB4E0@AM6PR0402MB3527.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rr60HwNFaYDwZFhxEnaV5gqDWPJcAzeu+sdhzY0WKR01ScQdctAkqjTGVH9YfSuZEURmEI/Hz6Mwr+hTrUb3NzZYu2n9OSvO4zVFKzg/yNXexicW/EGOnWHmZTm52ScdYjyIgwq4Tsl3vs0T4js6/w/PPe/Js17wtgTqElu6LbUImU3fyHpHttBbJB+saDVAE2XDO2/QyW+JYedwF9YN1vVzAeOjrLbj8YRzmFd0IxGdpic1lxxZ6NZ43XWM2Qy6zXgfUO/Q+7euTE8094kChA6wnBU5OYU0MnwlDVP9GjGJvGJzhIlvG8TRA19h4DpRNnE16whFNVKfp7mcT95XkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5447.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(316002)(83380400001)(36756003)(44832011)(66946007)(5660300002)(2906002)(66476007)(6506007)(66556008)(8676002)(6486002)(26005)(6666004)(2616005)(956004)(8936002)(4744005)(4326008)(3450700001)(16526019)(6512007)(86362001)(478600001)(186003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L8s1e6nberJ4edZ8mRLQT1BdDgi1kqOIS6z47nMho+jQf/xYfywzTv70rBDExc/ltghxhzEiKh1VvBrbB5+tjndRvMAdTzzPtnim7t5sNAJxLTE6ICUawEWw0uL6iUn6mbYRoXDu6xfwhSTZ6DwsOmbMQLLapVVtDR4UQuHfNqDZGHHHxyv8OTCkd72LZk+ybCQl4rbuVdnTj+ncuqaNHTQ2QUTuHq4kmuFdbP0v9oaS5byFucBje95esnXonMWHZYFrYd/E9n74VmXJBF6xAN5MluKkxAS0dZoTeQK0Za8KcFsyQB5uVmIeg98Lm9eKlGQGrXOltnOnHRX+g4oLR4Ll13PbQUyARyjy/au69NdZjX2Ravx7coehnviZme1rFSchQu8dJIAsZ+fmqGpFaLNVAffsxk+TsoMOTCEniG0lhn12RhF4RnhiOlQ6NFFuBV0bZu//sz06c5ryHTyQ/jteegT8ShmppWwhWDyt/OY=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defbf991-07ff-4240-c8f1-08d8351d8007
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5447.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2020 06:46:49.2711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi6Od3WjNGH4ZZ+q53feIjZRQevvaM3tALhyN0FbFYjNWlxKlbZ1f2YyCuyz4LwYjiY8xVccrX47n6vIRr/FIJvyezw8JW3hdOOsMgLRn+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3527
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The parameter 'priority' is incorrectly forced to zero which ultimately
induces logically dead code in the subsequent lines.

Fixes: 57ba4c9b ("fsl/fman: Add FMan MAC support")

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

