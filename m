Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06E4863A0EC
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK1Ft6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiK1Ftx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:49:53 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2058.outbound.protection.outlook.com [40.107.15.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3250CBE00;
        Sun, 27 Nov 2022 21:49:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2g4aOsGnZx/vPG9fhFfPwYa+llv5FxMEX6+D7WQrXrCLcJlmX0aQcyfILTwbxs4N8kSIbKJ+/BXjUAHly/q74TowndFoDa4JKOBQX5B8S9AHdiAvmHUWNKCubYxuDayrMPNhqPjLJ6cEsSd2iC8ichz3Ah5+AOEU7lKpmmCWCSE75giEq/cxjbyow4Jk7EXQ2x/3ieytKgtwi4LhQkhfN2mh6EYwq211KP4nP5tTE9pKzopW1wZuMZpHO+rzXN7FD8wf7WT8gtqKbBGJKO+NukLIvjOrsxFxCpjFpgnlCgjWa8RkqFF+NO2h4huFZoL32mwEXH51m11Dyo5/KXhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdH3e61WUGMnQzTzPNjZyKhF29vyfTW1EjV9r8NZPco=;
 b=Urmdidk/DHORXCUFWgV9L62j6imO2vOF4MS0RT3y1gYiF3DMiw+bD2PE8W43A8IEWxIACL+4uOzNwi/K/R+lMjKqHllIogTnhB7mVZT8rjDtsrGKzwbp7t+bfrRtBjexkk7ezPjJtyYLA+OkoL9t7t5+8q4QGXOIrWKBI1dvwhKop/AZ9LWvu6TnloDbCXx4DU2KiDj5sYFhTbNhd4N22IxBuzQYEMMb4gNJntG1s87W5TV53QnR4yeED9b8T2V/XB/XMbcL7Lx+aW/kXgxuacNhVtD2CxOmd/941WDc60lq8n1X+lBOo3MplmIljdYe8iw3DnqiqCKRIqTctEyXyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gdH3e61WUGMnQzTzPNjZyKhF29vyfTW1EjV9r8NZPco=;
 b=rpjOJQDd3+zRddy9qFjcrqCBryhG9MSEXvwfQXAT6SDxSOYPKERKn9+ieJGIUqNiO2+gSzNpZqqZyCsc4pIcvxYtkwsJkgzv9BzHAdXWJgHwXLebIFRNtvWHCdlI6Gx56LXwLMwkI2YZaknniShnPCqlbujuXZ0GmCePGduVBayGbh/wHCL2kp01rGl1roVhqdMIb1uX3A7n8oskD3p6R/q2uJ1aap4uMCkOKAze+SBS7fT2ShHi8v8x9cAT0CMytAZo3s/fE2eJd0GIyUnAO8vRJUuIpRT8U0UwTqCQKvbwabKjEyCm8HjuWUN7hyiftCGlEOIVZuPJpZ5suk+UGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by AS8PR04MB7655.eurprd04.prod.outlook.com (2603:10a6:20b:292::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Mon, 28 Nov
 2022 05:49:37 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::28d6:1b8:94d9:89f5%7]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 05:49:37 +0000
From:   Chester Lin <clin@suse.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org, s32@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>,
        Jan Petrous <jan.petrous@nxp.com>
Subject: [PATCH v2 1/5] dt-bindings: net: snps, dwmac: add NXP S32CC support
Date:   Mon, 28 Nov 2022 13:49:16 +0800
Message-Id: <20221128054920.2113-2-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221128054920.2113-1-clin@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0144.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::8) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|AS8PR04MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: c6364fc4-c3ec-4107-033d-08dad104557e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jpaavhAZnCEX8rB22Q7P+y01ZSZ1ReWBMfUfm+KWeTnK+QvHq3vd1V2JFmZNtrUJvEiG8rD9T6KXDhCT/P45oXYVAM46wwk4SFc17/8wvtvNj2i0CbvBp6kpcDFrjPZX4o+8VQgL3lYDpY4d61JkIi+wl/Vtkezl9mGEIWYF8GYVqHywOiiXgUZB8pm5S9YkSxNhpIR1rD9XYmBw4asn7+WhWnVPgRARPQprHIiPUZ/ZmdAsR+uNAnxRDovmeooHo82V1tvWMJpfvxgW8XEk64b+1xQudThXlVPYLN3mLte/HPT4HxApK3kTJS5Heuyixd+IDs11y8Pv/w4C68o9AJeiH82NfV8n1zifDh28LiOxuMD/GQKMgUOfoxipwSwdk4LCKEOwQwZWzZjh1pPexg6gkAVy5aFEP+0SQSBSvFdLhINUGiH75bU8eK7SPVs04FInzn5iw/Y1M7bs7DYd4k4yMt3oy+nVoQSf05pDvYpAU3BVG3QQ3bqPa3UmtTbKcyCI+SulO0gdwQah5ex/9yY4WgiXbPmThz7a+KwwU17dw91MkojUtwPjf1GqlF/kw5cCVw9Ca2xb8qFIrHkddIRQK4oqEa3vSbF3FfnvPhuTTfudJKkp2td1OgVjRtOMGHGfMf9eD5SlHeclOw78hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(136003)(396003)(376002)(451199015)(2616005)(6506007)(6512007)(36756003)(7416002)(1076003)(186003)(5660300002)(54906003)(86362001)(110136005)(66476007)(8676002)(4326008)(66946007)(66556008)(2906002)(41300700001)(38100700002)(316002)(83380400001)(8936002)(478600001)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LC8iTK388pTxMg3MQD5U0BslLZkZSQYJw5AkkUjLPJ5/cS3jCP2+HIKd1Jw?=
 =?us-ascii?Q?sYB6Alj0yOlzHU91DgLh3e7MVHBZgFgZe2IfbSGNVhjYMopgkw8dvd/22IJ6?=
 =?us-ascii?Q?TmEgrka6bJW9iE0v5e7EgTrfu/kpt2gHaTQaSw+iq/5YdLpCArGqNHhM/60+?=
 =?us-ascii?Q?zi8ded6z/gJAAQ8yFRIxIjLOhGzplsL9J2DYR3lf9qQPDZUzDQXsmwJDM4Dw?=
 =?us-ascii?Q?GOaocAuO/v/159umqw2pxiHtM48P0x0Wks1gLPQr09xlY0f78b9seR42qn2a?=
 =?us-ascii?Q?HP/980zyRVN/rwMi5Hg5keNk8N+wXcxFpDqLp/mmirJMmUy3T5vNaP5AGLeG?=
 =?us-ascii?Q?fbfMCwbkFVeVOmOxRo4l++xtc7mZjg97GUbZtMvsnlLYsk8nNCRJZ+WFpZmT?=
 =?us-ascii?Q?2yXbJ3ooxgpxzQw/f4n6xdRRwtNKkz/l2ISXgMcmnwDe6UgoYEDbQHWM5OXM?=
 =?us-ascii?Q?ry/4ZuJWl2tZc/8mneYOgbHQbAx3k8+WlKYhheJOdioaUJgYbTWbmrFXIBw9?=
 =?us-ascii?Q?hmvrtCFqjgN5esdf67zobq8uw2A8FdcMBggvz13ZG4iLRZyP/y9fTpmWzwbv?=
 =?us-ascii?Q?gsYOgp0yKTevmPg6OcfMzdKwBrW3QxJcVZnU6a00lL/yR8rmq8GdaSF2XE4t?=
 =?us-ascii?Q?zgrQmFVn+GLfqi2XbhrQF09V88VKRx/o8JlufCvA65i726tvOB6yHskLKNz4?=
 =?us-ascii?Q?lk6Qkol/4o2ws18VXBRm4v9c2GIYestpWJR6aW0tFYnCzLjI0WbA/+9cObiz?=
 =?us-ascii?Q?Iz9OzySzfH/5CLxwAAHrCD5XTycb39RtXZwm0jlPPT1xSCi5tYxt045jaopw?=
 =?us-ascii?Q?0KARzAAWCNY/Y32IxfotqIzf2h80s8/aAYn6Kn4hrsaivJwKGq+RkDLvhr2V?=
 =?us-ascii?Q?CAlPxDrnq5ivr47o61kaH8Vysi5QT2WC8GytA2mWt+tZiwH3UPMlER0tuVcK?=
 =?us-ascii?Q?EObT+Ss/H6yr58mvXkFOszSFMsSo/VbcKQu47KCjYPVDfReHlo+zFo53UPF4?=
 =?us-ascii?Q?r8T8/MrWoDJLCg3XMkyIjgzD1icsxAjo3J7aI9gRXor8L+4u5V1hnvVJMECn?=
 =?us-ascii?Q?oB4uKx2L8M1SA86J2314Ccpt7NQ0KhximEJQawskxe8HpTrLAlm/sCuXtvJM?=
 =?us-ascii?Q?EAKW/zC8DvoI2/qEjD2/IGoZxj7E068E22uOv/kCVVg6DgBGSALCTdhxD+1X?=
 =?us-ascii?Q?X25PdIJB3BTHQtSrYuDDn3izHEJ8A2MhtyhqRVQIZzdSd8rbh/llmdVUUBhm?=
 =?us-ascii?Q?60D3s9yxk6xXLzMku1G2NWXQRKuXJ+aY6EGicArbrEbhJwFBo5neVGGCaA6E?=
 =?us-ascii?Q?KURMP+jcRca+xGAlDCpdEj7Snr8sZ35J3W9tqYCGftSBulyQRagd0GFCI/SX?=
 =?us-ascii?Q?0ITvRTkSfVnVQQ7XV8oUZAUhotA3ubG31mMYaA2fvktWnnU6MHkEfoop1wG+?=
 =?us-ascii?Q?193+Ea3QvQJXYaXtfSCGlf9Tf2KEoWKxTSqtaZftnaxP88ZrsdWBkgG3R1yw?=
 =?us-ascii?Q?I3yp9zy90XF6EaNc5Hh1W+lQV/NN/bwkgnEbhCr2sNnNvdg0rOYscjHrXvOD?=
 =?us-ascii?Q?GMqKBpZjogDguXO1ZkowyeQonxud8dFIwvGiNEKaseoFo1Td+RjbW0Vhi6hc?=
 =?us-ascii?Q?aNhdMkNw0kL18GjtTZIrBRAmcERwtj2Nx8O9xkE2/wyv?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6364fc4-c3ec-4107-033d-08dad104557e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 05:49:37.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /M67qg2EQ/o/wmUMpda+/8+1NLdCqFt+cr0cTBaN4lmU6B93gi3nyD0reePsj35P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7655
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new compatible string for NXP S32CC DWMAC glue driver. The maxItems
of clock and clock-names need be increased because S32CC has up to 11
clocks for its DWMAC.

Signed-off-by: Chester Lin <clin@suse.com>
---

No change in v2.

 Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
index 13b984076af5..c174d173591e 100644
--- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
@@ -65,6 +65,7 @@ properties:
         - ingenic,x2000-mac
         - loongson,ls2k-dwmac
         - loongson,ls7a-dwmac
+        - nxp,s32cc-dwmac
         - renesas,r9a06g032-gmac
         - renesas,rzn1-gmac
         - rockchip,px30-gmac
@@ -110,7 +111,7 @@ properties:
 
   clocks:
     minItems: 1
-    maxItems: 8
+    maxItems: 11
     additionalItems: true
     items:
       - description: GMAC main clock
@@ -122,7 +123,7 @@ properties:
 
   clock-names:
     minItems: 1
-    maxItems: 8
+    maxItems: 11
     additionalItems: true
     contains:
       enum:
-- 
2.37.3

