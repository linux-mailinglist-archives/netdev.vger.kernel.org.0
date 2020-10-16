Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1408E28FDB4
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389862AbgJPFnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:17 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33504
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388851AbgJPFnN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/HwZpWucY6PG+0mJNoDanZ+mMHizRP8galko1goM4SMhPSmJ7eqUmCh4+Un3BKSD/hIjHpcs0x1Lzl9gS32KLoAgOBrIy8m/GVfh9/UeLjWRplppWioGqeqRmvQ5r11WFDPYo1geasH4i/6kMWcUULBIWtAKuxZJu2pNTx5H2kIY39y9iiPlwMtGgeNliGTxhTc18vqQ66VYKDdAedZp1LRQsl0QSYMHdy4daVzE6cnofhek4b6nt5/PhAhnIu/nkYNUqlc3EGheHKjmHca6wD3bhV/kupv0Z+3NrQCtChe78J/Vy8VwdYPSrjDDI9g462eFAeCfKrtKVVWvGWVxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=DOrKXfPCmWt7qX0Agq7oXPb/PcnX9k/WK37AwUfD+ifdCrmUQP0J3+L+FoMHZF2HSjMPFdxHLDOpviyjX4d7k8IznvxwSaiyHtiN19CoJfed+ZcZ88h7ceq8hpNHfVZ04n8mtcc19KJdcXNYv9kTC/NZ+GIVsgD/sJbaywQ0emGaODvs9WXdUYy5qgrSz1di9PZCXCYnxWteuSizFD+vakamrWGDbqDwBZtOO7Q/PBkpwc4nGb3lT8Jtn32Hbi/hl0h50RhhceSpLKZ1uKrvO0+lCzE9w4DzJaViTaUE0nwIS1Suzm/bK6aCNdUxYNfXhV+L0yZyggBITKFnSDxXzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=M2Pb+wRyeB9W7oEwakHlpHMuYGje74xf40p+hM4i6UvldUkx4FVQLgBD0uFLINxb9zfef4HKPkx+N+7InlOaYAbRh/GyorHO9R3vLm2SXVbhpY91dhxkxpUOUqhWKKFPO+dj4o9Tk/7RHZMdN94K3IMlsnmcVw4723+J+e0cGNk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] dt-bindings: can: flexcan: fix fsl,clk-source property
Date:   Fri, 16 Oct 2020 21:43:16 +0800
Message-Id: <20201016134320.20321-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:43:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3013073c-aba1-49f7-ceef-08d871965a58
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB73339E5AAB0FBC1A400A66F9E6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5Pcp7WTAXp1/IiIaZ5vCo8nLTl8tljx1ijDHGy9aL3h+GH8uac2RZpbevj8AiCo4ARkPXECvD+1A6z0EIzS8pjAForCruM+EEV/LRmnf+6k2hPDvnVdyqKmdiwyFROH8o7WL3pCxNzY/pw171xaKw1fH4vzvEXwJnSLHLmNLokg31pmhOyuPZrQW4PPyhUyMdem/RrbEBtdVewnPIfgG7ogSZrof4U2ij3lLLWkiDBYjlz4kcp1s2Zv7Rl3RLWmesARHz9nkUaIekKLWHTE4TZckxOpCl3DC+rVL7QBzlFXMs7JEH0jo9y+/1hyvGGoRsJeTcenQtC75rqjg2Y95GKc5XWv8D7/gw5hzysgyrmuRf0xIcqXtMWeBifI5fsHVcbIKqiWWmRozttptYip5FNVXdDKBLU0mu1s5J9TkF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(4744005)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(6666004)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Rghswu2eGu5ENgqmPSFM4e1hpO/tEusRsy8qlbKLgX1FWiIsbKzVOZF/z6QDfAdjwsJlcIPTkTZSTF8aE5SoCpOl5ShoNUf/ggMFolSPdPQZZ2x83FKeO7Gqb7n75Me9Lsp4do574lvD/URQiQh9aEOzvhWXY98e8418eQ6wJevzn+pigZNsY/mtXyNuYNx/NrrtCcb7/Yscyv4N7BlGtm9RQwOXjXTbaAtSXINs1UJfZxYrigvAyoQ15fHsEMcHHi7R+3NQ9GZXV3G20g/tsNxuMpggMkjvllXRSrEsTyXkBUaJ9v1zSKxd+pbDhOMaidvz7NNIw2sFcYOjd5JA7I+rHlsOgFz6f9qL6aIL55ZDHsJ/+XiALkS8sZ1DyvwdJTGooOluXLVUIn2kyypfS21DdO20s2Ga2jrxWQJ5iOBTU79wVBDTX5z6MZ2VyfDGvpLNxLIKegh0LxpW75xueOYTlETGrOrY7FXoeXpGK/Re8hA0LsZx9OnJ7x8v+d2FtnxXwTvFlMb7qgJty0Xx+vwmYsymISvZJg4e6pSK7fvIGgQzgByNgr/45GFEmrnfcBSMUQ5n/IclU4ZimIgm5B8T37YUkY7mQHrTXSp4HJndpnHKOpdDVlw9hIWEnXeq+y9VpfAAPW7eYyYLfkJehA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3013073c-aba1-49f7-ceef-08d871965a58
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:05.1431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwqJOi3ubtXqzqJkeG69uJY1VcM2Zg/ClUOMuxZ/NLF6Rnqi0ybmpoPMfzbikgiv781e/WuaBpKETH9V2RKPXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct fsl,clk-source example since flexcan driver uses "of_property_read_u8"
to get this property.

Fixes: 9d733992772d ("dt-bindings: can: flexcan: add PE clock source property to device tree")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
index e10b6eb955e1..6af67f5e581c 100644
--- a/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
+++ b/Documentation/devicetree/bindings/net/can/fsl-flexcan.txt
@@ -53,5 +53,5 @@ Example:
 		interrupts = <48 0x2>;
 		interrupt-parent = <&mpic>;
 		clock-frequency = <200000000>; // filled in by bootloader
-		fsl,clk-source = <0>; // select clock source 0 for PE
+		fsl,clk-source = /bits/ 8 <0>; // select clock source 0 for PE
 	};
-- 
2.17.1

