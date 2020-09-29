Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC47127CC6E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733166AbgI2MgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:36:14 -0400
Received: from mail-eopbgr80089.outbound.protection.outlook.com ([40.107.8.89]:38990
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729495AbgI2LU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS2enRw0vibi41Us4J7wJZPhPHhI8R4QnBygf0ge+2FfgkL394gQLBfd3vsBL3B9hLp7fVgs8Qwqfcj574ZF8bikyKKKb6mtzeQb9rRz5po4khDBuv2nf7gEtLWvgtcvEhDDRGHNY5WSjOmby/uh6yb0yVllnQ0rvuPXnUuvHY5q4sSeeO1bXtpsIQaJiVHsO11OSrW8A7x0bPb5DHFTjBXRTySZJ9d+TTLvlhV6d8WZaiLxgl3OW/Vsoj69O4xDCKczeFvs/5kBsHao8F5YimdOTh1tHj8eE3Urn15HAgJyqCsFOasSMjOXYA2sT9YN5hJWcXjtlRTMvYIWVjNtjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7Xd4+M63AyV6SS5947tBSjqxuumOdGDNNbqAYBSMFE=;
 b=nJ6K1TGMZ3hlOERFAT+ZTuC7DcBjyePIQiLRzqcaX4V5DIZkV4zaOt2uQs09o8Tsxh5BHxOkHxPyiQIRT4uciD69lbsQjG/k+bwxfMdThbzl1M4JwrgFG72Yw787uQSSe/jLmRQqivA8VF8IPZaxUzfJfKbdiisgdZji8+0SD0CpluDXiveyhssYXlXG7Wi3On/zohXpj14B6fs4VzM464O4/IfDbQBFQtAO7wf2f9B/wtPTI+C7VGJchvDBwP74/0It/xPeYegFRjDyDW85SiVRv1e0+5xI+61j4tg0/hdSVbvYNplcOSk0dr/Y7IlJV5L8Ufunzt9xCoU6/60UgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7Xd4+M63AyV6SS5947tBSjqxuumOdGDNNbqAYBSMFE=;
 b=KdFUcG7yscQuOGIrugPhMHfLjGzCevYr0hrRjUz83ChUDKStzBLIryxm76ncTPMQWT2GThEXUGok+d9OOgGOkPK6D4IUwhtPpestv71a9NyptgYlnlE2KnuNr+NVXxoddQrMfJIVjbYJGHOrnHONKNCdYfVI7TO2HQBtmiRUnrk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.23; Tue, 29 Sep
 2020 11:20:39 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:20:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net 0/2] More incorrect VCAP offsets for mscc_ocelot switch
Date:   Tue, 29 Sep 2020 14:20:23 +0300
Message-Id: <20200929112025.3759284-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM4PR0902CA0013.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM4PR0902CA0013.eurprd09.prod.outlook.com (2603:10a6:200:9b::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Tue, 29 Sep 2020 11:20:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d6d9251a-efd8-4ece-8b15-08d86469b193
X-MS-TrafficTypeDiagnostic: VI1PR04MB4688:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB46881E4B08FC1922D804082EE0320@VI1PR04MB4688.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VtvqXJVcNhGSoGXcPagr68GXqGf7jmJXY466xZggb1dS7Ozj7s+57j5mhdDb9/OAP0CF6Bn98R9wNuTa+zyQIFUOorqtNXz0PHonqXO0iPysBzuXEh+a/CXqqqSM3+oTNtTJtqUPQjK5WBpbhPTV62ES6Ui7GZUgSkLtnLR7Fn5uSnxHr9Bn/scOGbTnvyZiLegQ6kFosGmwMbaCXckVAefVgXloxqp+xY36j2V+d/vKH9KPgMhqmlO6pSfIoca+yX9ArokdwPV//vZ0jUwk7i3lp1uI5llDNUpBJBbOQHo/QGeAWxZb9ZUggA8ac2ph6cAkmtHo3xb/XxCEFJ2oLGGPCC1IHTLUYE30VL9Pzd3OZA5jLy2FctMLcvERzF5d+BaJC9qW/ISN9DOvs1zGFrfwZ1UG16jcz4tsEvXAzxljifcZlPywmp+0Impedqq/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(376002)(396003)(2906002)(8936002)(44832011)(5660300002)(66556008)(66476007)(36756003)(6666004)(66946007)(4744005)(69590400008)(6486002)(83380400001)(6512007)(4326008)(8676002)(316002)(186003)(86362001)(16526019)(26005)(2616005)(6506007)(956004)(1076003)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bQ3qOOz2HnhU3CHj43Rxdx4JkLDHYs7G2rICtqNN8gEZnCl62yNyZBrp7eWhCT1wQ6O/CUkrJSrYEbEZe4cfzj8cTNLdLINexBlkeomzMK5DG9VSEEk0gCOmAt19XYmv4tmWL1fasjknQq8Ze/2JvZLqSHPOIfwGcJfMoIzjyRtizqzs53Ase9+16RLr8KqzvaIPsLw2vwMeatmXRIZwYGjI+bjw1TvijXqdfXmhsqYDUw231Zz5JTXcebaB/xf551ZFZDa/bWdaqnW2EzeDqForIFgYCPKnY4uuuoFlwXZXyMm9eLKuYK0UjlDYgFyFXfqxhU5G2V9/F2wQEkAs1EeZB32nsA3nOpEM+ozL3BEFPmPyr4s1Y/U1Y4l5rU4eMxM3SR3UpmYzk8pOYVTNG3e9v8LdPquTV7PMW+IxHgrVaevtOHLRqxoCoIe/rQaKm+l3fM8kDdYqe5eSr0zyCdBEFmGqnBJlgC2Gec49Aj7gVnWa2XDHgFU9S3fX6A9ZGyt8uaHySnt53tZTjcLT4xG4Q35XDZE1oRM124LknLwyFfpERCIORBsF6tSLx9dH1n/po4I5mlGR+Npc/8BeYjT62lRWN1RLvqS3YD2y20Gyu9zZAGcRayEMNBy7bM5+nwleGre6q2oP4dDheCmqAQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d9251a-efd8-4ece-8b15-08d86469b193
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2020 11:20:38.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJ74hu8DHX9wmO85QRzkk55NBCmEa1ADkDeCXxxsxM2ClIjNaqFhiTKykziuwnK7G072EjMAjXy+XaFIKc0ztQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small series fixes some wrong tc-flower action fields in the
Seville and Felix DSA drivers.

Vladimir Oltean (2):
  net: dsa: felix: fix incorrect action offsets for VCAP IS2
  net: dsa: seville: fix VCAP IS2 action width

 drivers/net/dsa/ocelot/felix_vsc9959.c   | 12 ++++++------
 drivers/net/dsa/ocelot/seville_vsc9953.c |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.25.1

