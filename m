Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F963293626
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405532AbgJTHyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:16 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:34434
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405491AbgJTHyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtsyxFQufT5frQh2jU1FwP2NjiF2UXhVo2/iDh9epvqsaox21/289Z3D8YACcCJQMg5rEm5YII7GXtRtM6sR/jslpVGrLoD7+Oa/2L0lejY5/Ql51Dxz3BZRXqzXcFVYshJEGNdlVDcX/aYT1fkRulCM+mzwgOjGYtRX2p6MBrPzyCCjWmFfbOCVAub0Ev2etuZ5EyBNH/12CfHiyU4KJ7cYrSw5qd1dyt1k6+90lfQsEymZeS6dpfKwMBTlIgLXgaui3nRQ3ee9xi97+6p4c5OaTHPHyPnc1a9P2NT6cIq27fsQzhGFAIwR7HlL0S1sg9ect7i7peOt5XJ5f7iyng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=XoxyEbAxBFJwLM1mxq29x03mvq9X0pTpVyyO7lBphjqHjg3h70S0jRyb5QbfAcdYZQNq89ZaL37fQMmx1MVCOw2KgGcT5qJ94Vx52fnuYG0sY73f9YX17MzvCAnRO8if9mrj3pofVWiVifVjQqNW0CZ55Lvah1umZBs9YOzXzRadztM0poWYpWU5Q1iHtblS2TWMgW6iP528OrNaE0bH0cN/ehlmuX6wkjCuksxjgrW1w4Tyz3fdZiLyUZMu4ewSkmAz7S/uxqAU1p168s3NI2vxCS2SOmGwAA5z4tseC+W5GCCiTj3E7LKb2f5npAd34k4a2YPUQ3gpdYETjRGjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ur08Q6AfFGrPIwCDQuAKK4njckBVmBZasrWQCnYHC5c=;
 b=bOGk8USIhH+dPABMPVMMAbtsYevVKZ3+bQCuJgWHqOzbvhkhSkMeGJ0eKg5cTy+iw9nwin1mOCLYIKG/mAOm0k0n4i6XBuiKiBU5sjPIsuAGcxHXCStSU0I1Ed3NChvg11HmbatP90AqWW4VH6/4DDymBFY6mH181q9CpU9Znhc=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Tue, 20 Oct
 2020 07:54:13 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:13 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 02/10] dt-bindings: can: flexcan: fix fsl,clk-source property
Date:   Tue, 20 Oct 2020 23:53:54 +0800
Message-Id: <20201020155402.30318-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73ef7820-f27c-4b13-ad02-08d874cd55d1
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333DD758EC0E4A21A5C4E0CE61F0@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MsewblXGa/t5H4UlvfBYXq+Yht37fra5a4zHo222mu1lRXjAazNzvIqu9FhOe5bVn7xX+HJ4KoWGh+sd1a6LcyXEwcPS8EVh1CM+3YfCC/kerAoaViyUALTS6KAY726pnrbYuqNpigdWwT5Ozt/J+nBuB718u9BXbOOzVdPXFvg5Z0OynbaMJn4RwtSpQres13GMdLGcIZfSfIenOPfpyJC/K7VXz1XtZUpLYIWRJt+rSaUr8RrUw2K3Kt4paBpqNNxyjhEG6UMFTI0bFtYgmAaXrcgbUN3FA5yNZqGPiIaysrJML0jS67zF69LR8ImJNsr+hIJNpSGCmeNb49rrZ5qd/DI3cWQ83arLIuMIdGPtiGPSI/BR6W3HqJkct8pc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39860400002)(346002)(396003)(6512007)(2906002)(66476007)(52116002)(66946007)(956004)(2616005)(36756003)(1076003)(6666004)(83380400001)(69590400008)(66556008)(26005)(316002)(4326008)(6506007)(8676002)(16526019)(5660300002)(4744005)(186003)(8936002)(6486002)(478600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: A/UFasU5RK9Ft3U260N9UwF4kij9j9sSm7+KYiR6bgGG8emYrtDX3oSM4wVrS1LQnnhTomKlQ8i3UiqzwRHlquUHZB7hoJEqsBJiZ/DD6ynKbEDB7ojQ4z7j8wkcgmyXE9FskKRiwnTbnvocwCGrQgrYnnz3fjgW+yQcno0KG9DgsS7MLtYP0610ceWlCNGg0BBNnDMIRYm0fFJx087akl51dINJ6diOB3SrfNv3QydIobakhMZmOX7qSvGZk0+UUJNpGBC3mP8NDmf0qpLPGNUIVSPbf9og9RqyFZi2icmFdCYGR3iqeKWpP2WbVzCfA/Sqn4oU8RjW3FvB8bY+JoNkzvdERFZwvIG3LBTyCCiLRVijD01rBD1gVgFhtmW5B06jHLYBkbwXN5duv6Z2E7JKRAzdBEjh08C25h7mNHz9MW7ONO9AH//G9v8tj93HsaedjmMnM6i5Ki/OFoLa385iA5hG+OKIT38tCCC2yWhGFGLdlBnkLayFH62StGKMyPaEjjMtVlUlpUhCSolh2gG3c13K1eROeztO5LYKeX37KHuywsoaRn8DT0yTjFTgW+5J0IhTaH1e4ipE4/UGD54x7K+AChK9L4K/Le+S2aclcfFtudf+em4N/TeNgxQPA0HY2IXqvuNcXhUXN36bCg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73ef7820-f27c-4b13-ad02-08d874cd55d1
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:13.2744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOdqRps32/RiDZZv89CJJ2vnTjqmKQ/UlRbvTi1b7F2rHkX6jDkgOdm5YQpL0fGVvgcWr/IDM68r+Iy7ZuG1Lg==
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

