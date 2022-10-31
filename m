Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1D613355
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiJaKLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiJaKLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:11:21 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2055.outbound.protection.outlook.com [40.107.104.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324A7DF3A;
        Mon, 31 Oct 2022 03:11:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeS3/vw6DiKhoYXglvAYSQccIma1OdcjySFhyuXUtfj4pbJA4anPNlhwp7jiXknvDGAAbl3QF5WYofV85LmJnIYKJLOzjq380nI3FzEbA6gGMlqI0Sasxkim8PHV9HQMCAyvpF2kOTqKHr90a3c3igyPwSsie31GQ82pQqKGEGA7wiAoP8xQRs17GjgSvDD1ab+qb8uHFkM7kzDqATZwyrUzLj8CL3M9P0FP/x5TUniAQiT5DYb2QdM7plR79efVhDX0Oq1sET/3UToQnFisV6dda6qR/LCJkXCZPC4Rt8IvdFvIqQQ02SLLpMa32XJjMHGWQCVbMSpozWbA09INWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wwSLKc9V0Hs7DETMZgkC5L53NL59IDlYTWcuh9Jgo8Q=;
 b=jRO7uVBl6dc8dEnAxzDGV4xTx4rliZd5G2Hnn2AYaBQnYx3SpEXlfrQrII7AJR3QvvS79JT4YJBCKLLnXOj5YJ+rjLS7stNhDBHLJ/4h54fszt5syWbdBsJI+8scPqCpIiODD6gBDoaMGgMuTaByaWyUCcINlaWFBoa7XQ4VUwv6kK4z+VLh7hy73v3p3vhJBJLaKkReHoeiRZ1ufIPtcopeBJzeIE9GQs5XZga/pBZ3AwNfWWrx+mxhmFhkIGzpwN/fUs7gyQIQbLOMUB4YD7/k7tO1zNFDrYOtbtoDi7GY6gF1ylwqIpOqxAxGBSKYAQO3VJPiN2ndZnPqV3ZkmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwSLKc9V0Hs7DETMZgkC5L53NL59IDlYTWcuh9Jgo8Q=;
 b=J3TGEMq+XtpjcASjJlV7xE+fC4FmfiZ7MMVysyhjieWJiX6BRX2o5gOx1Y+2N9ZDO8eZof8XMiiqHPj1Qy/WLBapIwF8+NBJS5ISXTyPY/xrV9W7TExXZnzmDvFUFAmMitvEeDUcRHoZnsg47CQ8Sm4EFheipxb3pETPi2e9leUycRvoJ23ZPsfkNvssbrj49JGA/mMTiU8JJvnNTmivy7Z81aBTsTiWl/2OM8eVnaWxSlSsiz+T2TZuR+QQfk6PD3AncAvt4Yf/akvBVgjRJKC5sj7XhoVCyEvy6/U5tSSbZ6eZEvEOn+gzG8jJCXRnG2/LGNMEoPDq8xTB46Wv2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by VE1PR04MB7261.eurprd04.prod.outlook.com (2603:10a6:800:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 10:11:18 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:18 +0000
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
Subject: [PATCH 1/5] dt-bindings: net: snps, dwmac: add NXP S32CC support
Date:   Mon, 31 Oct 2022 18:10:48 +0800
Message-Id: <20221031101052.14956-2-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031101052.14956-1-clin@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0210.jpnprd01.prod.outlook.com
 (2603:1096:404:29::30) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|VE1PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d94bfc9-5f4a-465f-24dc-08dabb28406d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oaG9LfGhpX+g6V8itXqRzNQSz5L6WgfINto78PwzOEQsaO/Ge+vZg0Arm6dAU3q0a6YVZYYPjG/NkVr/8zWqMKof0ezajY9JXCdT6pBI1QBvKPtMbR1F+8LissiHX6nwELonGVErKTgOXhdVE9sfyHw6E3WKf4HxhfwEJ91FZYkH1aG/WcvvTmf7FSRAJkNeLV/11DgmlyzeWBIzicHLP2EQJckcLPxGmiIwk0Ne2e+4Rw+E1mpnXsj0TzT6riQiVgufl0d3krMYce4l8ddUR0FTOCFGZxpkQTTYAfqXpN1aFds194vO+UhtoVBdqqWDo2TtWoq6WvcA8yA1jCQcRxcT+lGlI4DdZluBTBqKeg3Ut281JYchIps88FITEamiqraM5mBEDn69ee9Ulp+DAVUp22XMHgUIoO9Yh8xbpHCYIAywIs5LunUxSrc0oIBOOHdV+YIy4aMzETU6ITRmVLs66TfSb5abm/HnDrZabca/OeTbjfzrftu+EW/n5SuNHflaYpJ4QOFUeBUOuUZKvddUVAxr4my7Ded8EhqANQkLFNWz86CfgPWP0HTMbYEm/BiBsB1FlIfe6jRKYcsqSzML7N61q3NV2pV6bRhCkS8FPEuk+mS+evJLudyoMIRKgwI57pee8jbp31UnlpHuLCW4BBd2ai3ToCVM3OIdPlnmjo1jPcPyFxxqB5ng0WC53T/dkU7PWKKmk0hwkb/UUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39850400004)(376002)(366004)(346002)(451199015)(6486002)(478600001)(110136005)(54906003)(316002)(6666004)(86362001)(8676002)(6506007)(4326008)(66476007)(66946007)(66556008)(2906002)(26005)(38100700002)(41300700001)(6512007)(2616005)(186003)(1076003)(83380400001)(8936002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?roIhUy7jZNqavzGicFzrpRX4YmtzaXpn7O1QOAuUiU1qpAylDkY4D4SPctHn?=
 =?us-ascii?Q?PW0OjqR85yWqhTxFA6blMtR8TdNHohKt84KKgtVcH8ug6nhPu4jmo+yPTb+I?=
 =?us-ascii?Q?sWVaTMW93Yy5LXFhSYFWXZqatXaZ9qjtofASPU6HyJA4+Nh24t534f631AXt?=
 =?us-ascii?Q?uF6EvCD1XU34e6sAjZHDZLbxkSv8cKDBOJwOaXkSdP8Em/DC8s82kWkv5pd8?=
 =?us-ascii?Q?OmakocGxeZPBEsWje7kaaTXD/hhfZ2eZIYlV7cHVoeEjMPy89zCVNEgEUaDa?=
 =?us-ascii?Q?82bJr3Itfa5BNn1vkMEuJJx/Rl90woVmGp0NNrl2uRhwQk4psaMB5jSy30vg?=
 =?us-ascii?Q?bGNz0NQh31mpbsiFgDocJRL1qFu3OKYhoB2lvfpsSmzu1C9fwvpomm/ndBRi?=
 =?us-ascii?Q?bzr8Aw5hOkh8/rAm//6qMF42ddSTDyEiDuczWNcb0jhBEqC5rAnARMXtHbr4?=
 =?us-ascii?Q?edDEPg9daBSlCYkt+azwdi1HFq5PSlJ0Z/QdWcMdVwcUQStfkyvrh28BhsQY?=
 =?us-ascii?Q?sDwkIZDgcN39oOxlZvjWjee8gjypUzFKmFZx7JOZHoFux65DXwxYoUCKgEVE?=
 =?us-ascii?Q?T+DhH3QwFqBd0Wg6Ewyq0ehi4dBl7dqwb/oRWmUjujBpWEMX6ozKphrjpRJY?=
 =?us-ascii?Q?oSMSI/GGnPZjIg1d6hBXa47Gx6djWeLcZHOQ1iCrjIMhuN+beFrP16FmLNZw?=
 =?us-ascii?Q?dj/tvO7mAkip9+R4A3vYGFKb/V6Hoev2nrEQFzrzHUBt6oL2Ry9mSX3DEhZo?=
 =?us-ascii?Q?AdetZfEO2N1M0vLMC9ItX0GzheTCq+oYMYlRTRtAmL4Yo7PYaLI3+t4pKG29?=
 =?us-ascii?Q?pV17b5ai0ZOpgPsVOodA980n3WDA3EfTbExxGbnnwDUV9mZDHEmAy50qLnCl?=
 =?us-ascii?Q?Lf8PwwFvB34F+CGl78PQJEMKlOcSul49FwhbjqbOHZui5wyPXuJ9bj51MHYx?=
 =?us-ascii?Q?+w5tV8zvHVUfWOnd29u/wqP2OxHxPvTdf7h2CYLOUCmsGLh/z0pIY/zFwUiL?=
 =?us-ascii?Q?sBwsrPCVSnyo0L++yCdxrgiggHWO5mBkDkvUCzxLiibhDpBR66j7XMcpGYxo?=
 =?us-ascii?Q?bVAdzgttmF9VgYNsrJc6CxNrnDVx382r5ajo0kHm2cFFoQf9hdQkyfgOAm3A?=
 =?us-ascii?Q?MTcFMWw8/BtH36bsKDiwSJ5cqMRCVCXEH6iHENl0FNJitVz8qfPYlQ416N+V?=
 =?us-ascii?Q?RwuhiM4PZE+WsMxkS5oS+gf3CcY/FVRL6WSi8kS2D43lr5LSEui9MfFigm+D?=
 =?us-ascii?Q?s7QqDfjWYQ/qBeh+PfozivkWUpLEwEnXcIrNoQkrz7lOgpv3mXRYBO1wW2ug?=
 =?us-ascii?Q?uUKJxrRNCkKqs0QeaLwc9q3kUskVzIWaH1LZuC4vX1nTMD06n526L1Emut/w?=
 =?us-ascii?Q?63RSehg7OQPrGh0YprkovkLqZa2X+RSsKw5vLaORGHzCMifEGvnZwLuN0gGx?=
 =?us-ascii?Q?0orq/JexO2K3Xdg+H8tFeoBVAAkJp+F8z/WigsETWMViJXWqC0A8TFqUFVkb?=
 =?us-ascii?Q?neSloQiY9t550KESItWzQGW05VX4vz9qJuvcPI4sm7ffh65zRWujSBpChI77?=
 =?us-ascii?Q?8SdPSbELEfN/1s8Q6D4=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d94bfc9-5f4a-465f-24dc-08dabb28406d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:18.1576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COPXWoP/7//4fPQjKqY46mPJzs8eU3KxIsf8BCH+wcP2sn//ttlc8+p6zeAJTK4b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

