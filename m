Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35794506A4A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351214AbiDSLZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351287AbiDSLZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:25:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59532DA92;
        Tue, 19 Apr 2022 04:21:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/Y830lh2h0aQ78j8b8pp2zA2jzaKMpW14a6gJhzGVpbkDdDcZ2VtnxIv1T9dWckh1nI+k1Jm4Sao0XzZXVy2Ms0dxefDkT5NK/7l47b+76L9B6U6LTDWebdVDtcv0k4rGep302fJjgfgRIHsY2yTFTRUStvvIw1mEKzw/tRpHcbC9HNpEgtAdpg0lXvf9VQ6G88VsTXqoSD7xnmKuJ1o/3JtcpLya1Zh7XGQ8rq3f0I4pVo2I6m6+s28UEZCI9w+yq0JxVQbUYaAf1mmMMljcZS2u2l8/1OdudcszqEltdzbYPguzesQP4ddTVp/CuecNNTpMa71a1jq6amtFSMBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flmSPf9D8ZH6MOsh6Oj8LJRInrPK//j7iSrj/5Sjp34=;
 b=HVVxQIG/vdII9+ymDMwrCGCTVZcBI+cWDzA7+pVn04MAPMBIL94bCGNhubCKAQn28HTwxsuqWWNdoimii7b6r70Tx0Ph7ztPSUuGXuHC1ft4O6AYpz/IdhR9nCQOoHq5y25Jx88isph8T9wGdrFj3lvJF5CqRoxKrJTPOTVkinEdNPPw+IYQmB3DajC+Yyuy6JAcq+ObMYlml6Ixx7nEvgcLNWSHsODIVwj5ac1XWcSh7Kaj9SFsV4K6c3xNMveH/OSarRHKVHMmZYNrH5eW2CMe8DY52y+47vvjY3Mez6Hnmr5MILy8v7dP7JNzOz0d6LQyYmjT9Ok6K2dt7oEKYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flmSPf9D8ZH6MOsh6Oj8LJRInrPK//j7iSrj/5Sjp34=;
 b=lq322gsCO7i9Oxm2hwDGhS3ibzpZRSXJUk5aRXbSjXJFQLPEBcX4K2EAAP2jAwCfZp/wj7drbqjBF2Dw/1R89N6ednMrZD8lBDyez6ctXZjrrR417d4fiIU5J5v3sNdXMFntMTpQ2Oiyms/OSGxCdmNIjV3SWbBCmj3HVAeOFEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:28 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:28 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 12/13] dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:20:55 +0300
Message-Id: <20220419112056.1808009-13-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 821ad21d-e5a0-4a81-333c-08da21f6bf1c
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB75388035BAC52E494D4CB8B7F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJ+9Y9pDVDHrJPYaf9OYmER7+a/J64l6wJS9F9t4XCj/EtfK2dhw88ojEiPXctpj3HWVGKHRlMl9VtoXs4k9SvjHk41ppkrCjfj/St9uJdtIhiyXvCGv8vM4SkrjgfJN7wE4g19n8iuMBYIGIQxPkTiSqs16vE+CT5Zw78K/okhJbYkpdt4a+T+7fY51fZXuInA28CCq1pexmsPU5l9bmysW6aINSPbfx58vO+yDqppQ4uxYynNCFHda8KVLhp1VtfjgiYMe+/KdfhghGmm3vx2zHXACPMeuOAObw1KLmg7NjsaZx+lgirE4dGviPAfLtq6Q9KsLGuk80dJXgQvJhvk7m+b0RVHKdfWgtteW+gPSWvftjGgKtVae/j/5ZD3FJFKHb2PpDhN0cDVxV6yIPr8UG4saTPE+//rbAYN3aM6UnyAPvWuyAjuSJN8YuzJHnmvBLoTY8w5CNygh6NAt2kg1ns39akizkSxbdqfNZ6obH+a7FU2q7JnSjQ5OtOL8H4WbXETn5hIAjMh46AJ9JtkdqQiFkH9aN6dYMeC2sMSTQdP9RjS63tU00wxq287rqxP5cjHe8jQfilrf0+EvBXHFYxfKwh6YIe3ZVtN/3YXUxdmezm0Vzr0CiRUeReRB5CpZ4AMK9wllnfO7kUpRu4j7LAuD0qdweELRgCFjKIOV4YGfMKirwAV1n4vLrv8JZZEPvjehixKJRHNvsMAq2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZVm0MQzw0gEiY+rJU4YkPPqtDtJ1vcSBCoDia2Ccle4czwHQIQYucl+H37A?=
 =?us-ascii?Q?s2agqt5Z2bSDjS7ki/dfONTvKUxQriP3TbBHufnrIGKn2waEt9u+pVjxupgD?=
 =?us-ascii?Q?boGzUu9NNXgcqlnNox43Oi+qTHSnHhCx7ydA7gaiNfp5G6q6U7DKbcwTiKtW?=
 =?us-ascii?Q?OTzvDRnVuW4X07i1sn2XlbcZlhXFbngCZve/gTvd5wXDgRQG9WAdFE9eE1Zr?=
 =?us-ascii?Q?qv3RbDTjrInT0szpuSi+M9/c26gkPZ9ByURa7kRWjuB2zXPEDT7PELAy4079?=
 =?us-ascii?Q?65DxbGeVl0uk8IO/q6mO49mTGGYu5rWmjwvPXoTWjzwjEqs3qKpPkjyq0UL1?=
 =?us-ascii?Q?hY4RKmQ2xXGTGYnt3AGM0j7W4iTxic8pEgBketz1uFwyBNebjmH4ePcEjsXZ?=
 =?us-ascii?Q?ENFsSEQzOqVf33Liag19ZnYmq/HL13dSjjb0xo2dY1NdOQnDdFVMIsMihmNB?=
 =?us-ascii?Q?/rMeT5TwrsXXf96oR82Z0rlayXIhcBj0irggR6FCCLaa0VGl0K73wFjZ4Sq7?=
 =?us-ascii?Q?DAyRkPAxNv/4wFTurBZvsi9A7yVyZPr0OEMxaFJJKu/D6lvyrWkdAm/BUquw?=
 =?us-ascii?Q?b2Vlxgu/jG70Y67QQigfPuRQEBTjfa1s084aNo0Ill3RgF22A9cpBmtV+xBm?=
 =?us-ascii?Q?xPrGtdbilkwg9PNH6+TTD7HEOpfeFhP+8TEmJXZEKsrrK4FiQqd3rbIaY73W?=
 =?us-ascii?Q?FWdExNoGx6EGu3R7pPhyCLzsBqttcEaHK+ns+hq/hPiCCtJ/CQilHTvWMxqt?=
 =?us-ascii?Q?jqR6f2VKsLy8ELnkM5UfxdHDjB6MvRNI7w62x2uEIwqSk6OGpVZORUEm+Cfz?=
 =?us-ascii?Q?k+UiqQ2boBgxtrJDzzMluZmB2pjt3kX6bRnPoxKVon6Hf0qSZBtrJuf+Tdp9?=
 =?us-ascii?Q?Y6Yia7a6emoArATd/xeUmJckUt9wcj++Al+a9GhelJY2zswbFCgJobbrj+BD?=
 =?us-ascii?Q?F/3jGrq7mPYNn4yMJZch8/8VrqBlIftxCee3GGk9CjEkQaKbxLy87pIX68PF?=
 =?us-ascii?Q?vDj8wnfS0Hc7gym6b+a1E6rpwcl5VYKYaY0VaYlFcVNNuvPp1skqRuMFpRvC?=
 =?us-ascii?Q?iThYzm3QOBOFYSu60Rti3QaGIfZLhpfqUkPErAV1KOGrg3Rn7Hyz2E+W/Nqn?=
 =?us-ascii?Q?FoiF5auqu4fsu0y3D3R18497LbmpazU1+8a8R4ttKiqQnik+KY7eDdwAyuiI?=
 =?us-ascii?Q?jD4YakM6jAjjs6yx8TfpxkU7NMw0LBQLwBBQTjPhO+allF3SaOLoh5BswKtD?=
 =?us-ascii?Q?qD2yiLZSt0Xbwe3zUvjBAfniv1OG/l7rnv5qGVrAX7zfYY7USwgbTvVVYkE0?=
 =?us-ascii?Q?7F55mZqqCh149Myy1Z2ZNh5iEH96N0+Xbin4Gcd18KC6uBFEAMSuHARBbDs6?=
 =?us-ascii?Q?BRZttW6UnxWNBjxZDzVffvw9h/O28eV25qfqWTyeLK7MZ6jpR0cfW1n26Cyp?=
 =?us-ascii?Q?x2vNwoyD/ZNKYf6qekgcgEZbqAKc5Ee54Zh/fm/0NyWLaQ33qHKOM7jgukod?=
 =?us-ascii?Q?5F+fRH84s+jmUdVAeyC3f0o6hQ6RFh5ICUih/uZc06OxBuzjljXeOHUIZYe3?=
 =?us-ascii?Q?Zxn+kvamsN0DItQOqqnssla7zbFfmUE7RJW9TcYDma4xwguO3s51sDswZzI/?=
 =?us-ascii?Q?a4m5x213waYtBk8yBkRxqHF9clWkYnF4gTcHJKZlXLClTk9kOwjx98utCU2D?=
 =?us-ascii?Q?oeJd9TMetNWoQUeCMOgNXM/6J5xtUgIM36NVTAnA/tps6cYnKV4bIjuS2S51?=
 =?us-ascii?Q?/s1D2vhqfQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 821ad21d-e5a0-4a81-333c-08da21f6bf1c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:28.0657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6lSTs6fVa9IZZq0hj4j0W7sV+KBsgDmS1f8G0pe3h0H1Ug5Mjxoyag0JsQBg4o4kkiSxCY+6OYFxROXIFAmRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to ci-hdrc-usb2 bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
index a5c5db6a0b2d..c650efc47e92 100644
--- a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -11,6 +11,7 @@ Required properties:
 	"fsl,imx6ul-usb"
 	"fsl,imx7d-usb"
 	"fsl,imx7ulp-usb"
+	"fsl,imx8dxl-usb"
 	"lsi,zevio-usb"
 	"qcom,ci-hdrc"
 	"chipidea,usb2"
-- 
2.34.1

