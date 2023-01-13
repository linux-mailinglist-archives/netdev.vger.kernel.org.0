Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80074668A3D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236727AbjAMDfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbjAMDfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:35:10 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2067.outbound.protection.outlook.com [40.107.6.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5C8963D2A;
        Thu, 12 Jan 2023 19:34:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXz7dLkXucPPQcmuPso4qK58kwft2X0Ui4ZaoCk9A2kJR0FZx0IKlqt4AguS0uh6rZZh4gIpfrE3sFoj2995u0IOPmXApMbN3etDVFn8vvVcCAkVdb33NJ6mZxgUfrKYsXyXDgr+U6+7U7kpL864DJgACHeibowkZ34WbHp2bqF58jCEdmuXqpNfkxjZyY/YTshkhMiWFoS/U+66QBuNhDKdaO/zxqJVSauvnzkhp/Sy/TqFhYPrb7YTgpxfcLT34gYd+/EWdTA19/v9LzuVe/eZydQBdLZuzbHghP7UyItJL1tbDCeKjN98gEd+o84xUdkoKYLMXPlXJTEPe5RXvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XEtchS5dleUyXMBf13Gq5hhn8uF2x7J1NOLe8pdH3aU=;
 b=AKmrspXF/ieQaht0JPLSCnBYmYuA0mY1k95KnUqzpXncdsQJ0T9Rp1aXlqSOIxK/FYuW6pD/6Q8sPqczjL/5G0psF8ElPdf7cAJw6v5/YMlq2iXCW1zBJCc/WmvYFEqk/RjM4mUZdqGW6vr4pKnfg8MXyBFcr9OoJ242svPF+oOLh77MS7AtqiYUFjPQgnuYuE9Kw1LNVfTpm+Giisng/Q6W+8UkbKbWTMWTeMb9Kw1YDmomKCMFy5cDIOxepqPGtJXU52qotDvaXBXGmFR6a7Jh/5Pbp6s0uMi+rx1jcyjWl1bpWhja7+oywv0FUgFr4TrAm2Ia2GmaAgtavM/k/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEtchS5dleUyXMBf13Gq5hhn8uF2x7J1NOLe8pdH3aU=;
 b=EsJoKflipnMLHqG+K0HPNqY8AONMOPX85pPPtWebFjp423JnpShm6EKGoxCTjmNK0/S5vkh3SotHH7jD9sknJjx/KTwzpozQTVWSMU+izoVxIk+jnmxnU8BHbBBS4i/Jvjbs3lMpFlSt+Xq4lI6Ntq8i7cHIFhI5V08bA8L4My0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8247.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 03:34:51 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%12]) with mapi id 15.20.5986.019; Fri, 13 Jan
 2023 03:34:51 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH V2 3/7] dt-bindings: net: fec: add mx93 description
Date:   Fri, 13 Jan 2023 11:33:43 +0800
Message-Id: <20230113033347.264135-4-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ddc621b-18f5-408a-9610-08daf51720e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: meM2sUdVHkU+ehRem7TsWrl+yljY/SjAUOLxXFDqgpSqn0Tk4VAgmnvIuCr1Vl7i61wBBiriJ+1rdHbPNXQMjaIQYDFb7B27ME+gKWjQEp+8mWMhtha4tduCaaqg4wQzvsA2cVFQwtJMGlCj5IKfwfPPcoCnDT3R/OLvDgf2//gQ9mx6zuLVHcpmDNoUO2yt71FrNFsS60X9vNuqcFIBlPTiaDWwSat1LkQdAm67Jd112m0Way2a/P93m0hRt8bWhvNWMKQaTvmvwFjdcx6OHJ+OVsMKHV2NMkB6tMiFyS7Lm3lDFP4d02P9bRQK5QzDAoU85URDn3xkrz5qh6C1Ks8dctdDJWCXt9oZ5UP+W6EXElTT4e4kS2GDZzx69yU++4E6I9g/5qKyGuNfkE9p3oXnwbM8WBc1eRhWLsKMzK3qCYGDQ6kNALy7Gi43ea1ZrFrEGrcXpgao11pkJe5XCUIDFJUniOyiuhEn2CZRSJkcXb7iDz6A/ZnIJN3O3M5y/BBYTwOpWX8DEV4gPRqiDYnavLwm16tAWRwiAmvOGB9cCRQBzDabhiDHgCB/98hTlr7gDDl3n+dU0bhYJlYfIoYVPLxLFcLUbNp5t30xHpoyacteWoEwFMLSX5gpCOVpz0zSt/hK0RZzmSbEziU3E5R7d+DY99v//erUm2bxYFzcKBnPlOW5qc9eXr65qDlVncSWWPsd6HFzovhSZ6qe6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(4744005)(41300700001)(66556008)(8676002)(66476007)(66946007)(4326008)(5660300002)(7416002)(921005)(316002)(8936002)(2906002)(86362001)(38100700002)(478600001)(6486002)(36756003)(52116002)(38350700002)(6666004)(186003)(26005)(6506007)(1076003)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEweTmK8U9jhoVwopn/kD0c27uQJurExl8hsWd4SQk32V9cfEztiBgk9m8pv?=
 =?us-ascii?Q?9LkD5wgkmkJyM9XhjguKPJOxS4Wkn8UNDFqnwKQkt7z2O2XmPfdYsyBD7ISO?=
 =?us-ascii?Q?CO3CrpWr9C3cl1RFJL7P+W98CUWLZGMeJL5DK4/14T3cQ/xpRrhZc6KwhWBu?=
 =?us-ascii?Q?E+JKtBCsCrf5FVmdIZUOT208S057WjAXKzg5lRwYsFlxbH1Sc/v2zlV7Ti2X?=
 =?us-ascii?Q?W4ADtPuj97ACQlwv/mH+FPByr10AYfRZ8F8SfH9ZL4GTTvYJgY7feRuW8SRg?=
 =?us-ascii?Q?WG87ZMbOn5XvtmVwMpCJosWWiPxju9iI3qn+2eOfKPrDoyE7AU2YbrrWWohd?=
 =?us-ascii?Q?2WEmcg50oa/cdinMuihw7L8noLbD1qK8U74njgx+19jTsu9BsMs9QzUOVNAW?=
 =?us-ascii?Q?/Ar9Vul2mRuhvC5OW/autePH8B39WT9CGRPELxv+NVb/M96UrGasEPiHeaaj?=
 =?us-ascii?Q?kDvM3hX0v1eZnTmyCwT3nCokNsn4yyxgHeeiVgYoLgjQlHd5b/KANbWj9cW/?=
 =?us-ascii?Q?KxMQq/+QjbySHW3nmThV8Ox9cT/QAOapf2Ul66vAAxHHadXaYYKIlN2y3fkx?=
 =?us-ascii?Q?7tjwyHB0hLbq4jh6hh+kpwxMnM2gYrWgW16VknTRy6PdgM63wDIonKjefIjl?=
 =?us-ascii?Q?hPHi9Czd2PkJ1XVbE4wLulqFp6Xi3KGvq/ETYQ+fdS4iZdmySXelx0ZoR2mC?=
 =?us-ascii?Q?ymlvHen/KTXSBjC67Mk90F/oVi2MdRBvzkOT1BtM5IyRmvKI9RNjwGafqSAb?=
 =?us-ascii?Q?V5mXg5weMOtM+yCKSXnzoAW7P6P498Pe0AjQ6xMEBUpSW6lo7qt5gU/D9wsS?=
 =?us-ascii?Q?6m8fREWmsj9ArGXFVZhp5/1UeoxRXkU4H7mfcVPTxWND/LF5liZ234eGmy3/?=
 =?us-ascii?Q?XdA5JdVqBSO+somVwhpNXu1qXWTAxNl28SoVSWnmkk5zCCmIOG3A/4p8itP8?=
 =?us-ascii?Q?BXAw0Cb8BvX5QLAve//sL1mvRB7gSCPMRg9JEBUXHepWb7YOLbL+UtPFweBi?=
 =?us-ascii?Q?1fhdoDcYVuU43Nt0ls09aoVJvrZW47LBGpL+T90oqPjq9syY/ZEK2uelWo9d?=
 =?us-ascii?Q?PsZngA/K6xpq+O15USdtP3CTwl7UzkzF+gx6t9KJ+hHHEDh27uM/3hsvQi4l?=
 =?us-ascii?Q?BZSE4BE5hBOROYNAke3J7fgRyBjcp0BKPs8wiBzriapjVFCaGHq4V2/qu8qo?=
 =?us-ascii?Q?kLM0lAABk0kj0/vVd32xGHAL7IEJV8gI2ZIuW42ZWBxAxQpqxVrye4q9s+uy?=
 =?us-ascii?Q?v++g2KtVEIr8hD03O8FmOcdqSJNsqfGJH4u9mU4CRFI+BHU8n4ZU529zxdiO?=
 =?us-ascii?Q?JuPMmrotI7Jrduc2LcD+mfUl/Ow6d27CT15xCZ3A+Bhd/gUf0ktjvc13jxY7?=
 =?us-ascii?Q?pHjXbOGOgV7Eg3PQhfzM3cLRG1zTa5R8tFxG+WJqF6lCecjtMIfm2AIGbx4H?=
 =?us-ascii?Q?njhUDit/TIDTAoBIEZD8+Of2bUGdkf9d/Du6twQ370kRJI8SL7TZNOL2S0Ur?=
 =?us-ascii?Q?NisBDb2t5EZ/O30w28fHOIsfwyqUfmb6ETpOJhb/IDQ/MDVgK5EFZu1gUHEw?=
 =?us-ascii?Q?fuNzLnxFb6IxkwBh/ljoGqvIMEqBgw91+S4yJMce?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ddc621b-18f5-408a-9610-08daf51720e7
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 03:34:51.6447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lvLk+JTvAhrYSyrizrTRDtNpMWKuPHATHAEtwWRl8ZcH7cmW1v1lG0G2ktxl841V187/umHo0j05qriYiOJMww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add mx93 compatible string for fec driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
New patch added in V2 for FEC
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index 77e5f32cb62f..e6f2045f05de 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -51,6 +51,7 @@ properties:
               - fsl,imx8mm-fec
               - fsl,imx8mn-fec
               - fsl,imx8mp-fec
+              - fsl,imx93-fec
           - const: fsl,imx8mq-fec
           - const: fsl,imx6sx-fec
       - items:
-- 
2.34.1

