Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B215546C07
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 19:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350257AbiFJR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 13:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350244AbiFJR5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 13:57:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE946D94D;
        Fri, 10 Jun 2022 10:57:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzVkVAc4IZujGrAsmY03znJQNHeo35z+V0o4/z/JmfBKnQpPtzj+X2jfJGdWV1A19uHJL6mWWM8+QxjkizU+2tTyiYzJzG/8YJlcY9rGgZea3iw3ykoknLloQPTVlZSxnJT8OzNx2jyIOitYlHKdYz9Pd8PMF1+CSf1nRtxAzkwuwFK/rBfC/YHwNPtoJnSQfXcoRrSnPdvlOEwFVTmZZjwTSk/s2HFlRxZ8FxuMuUt8CPdMlsKt6NHHchYpT8bFMyQAnWCA7aR+2T76ZOzRMffT2jzzA0egWYXddrKRTdv+s2/gOMiKGkJtDnn4MTAFDo6HLQHU757WaTG2FNUdEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=Sy+pn5PcJV5WkOcryTmVmv1OmBPU3Nht9FAVExwrhgndgnmzxDxSUgfQPPLuR5rBlooA/DkE8A2WJrj8ZTrfyD1yGu2z484CXRIBaLNKmtcEBNJSNDBHkwrImmpQxXIWon44t9J140YKKra7ZMVFxXW7q2PLn4Kcz+mQMHmoiw6jGICDDI4TBAwI/dcUTNCroDBsZ60o6Ow0IaHWty4SnCTkBenG+TY1ZUhKC5wDLSCUSZ6fjmv4IpDE+YqmM/3tnmAg5ToTDFtgrxp56hJ4qukUju8JaJJfwGZc0iXtDhseZQK+pmRilcwShnX94LF2vpc6lHHA9xKnibgHrtieCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=AIPPSuOaJVvFI9/Km0vYo6r65PD6uJ+dkk4BgNExqwXX6CWEii86Y0o/VvU5yE5Jvn8mfwZ7s0b6A2AdLkAxMjCu26/h01uY8Vn7i107GmNT6E+VYqxJiTkzggRFDZ3DGSJpRKqTBZ6krfdBi65orV48WHi/nPzgLgG1xs+Fbag=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB3356.namprd10.prod.outlook.com
 (2603:10b6:5:1a9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.15; Fri, 10 Jun
 2022 17:57:09 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 17:57:09 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v9 net-next 5/7] resource: add define macro for register address resources
Date:   Fri, 10 Jun 2022 10:56:53 -0700
Message-Id: <20220610175655.776153-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610175655.776153-1-colin.foster@in-advantage.com>
References: <20220610175655.776153-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0070.namprd19.prod.outlook.com
 (2603:10b6:300:94::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52fdbd1-8a34-437e-adab-08da4b0aa374
X-MS-TrafficTypeDiagnostic: DM6PR10MB3356:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB33563882C5C7AC992CFB2448A4A69@DM6PR10MB3356.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZEfd8E+ZT7MKBxQHK1fSTtwRG7tmT6TJid+xPHw9JNXq1/IhAh5dzplNHYrlH+h5H6SbBR9PGP/Jnf4w5Dg0KCM4CMynTie38RLQJePESajcZs4Ij/zRQmo8G74HZqrEK2vpFxe4hrV7jbXzNBr8lHD1cfKjQbbucFdixpz93CO1L8Bh8G2t29pRxjlkWKB8TlJkqWpo3X8N0Pl99nbN660yT47d+SxQ6ECHVjMGvXEK2RyEazCgeAI1eYxeYPOpjqWxPvimGohpZAXzQsa8Z4OTK/Uo1DcsqNemxsyHb9/ZUFrHm5/TrZTH9h3pOQObLxUGD2MKaUz69tppMTTu2xNOHqVoJ31q0CMUA3XgetkecX7QwYuhesZHAxRbtfx5dKnIrajlSkYHwO2VCzXaDy5e5ty8SaynyZg5Q8gSzQvYPKe4DgaDT3aDNBzljagLzfQuZfLFSXARiS30jza+P/JyO9LWy8t2RiJv2P+4OVP9xz27qhCaDDUrQyE0i2fbHd/bqXKtnxgnvt1dtdD7MhOCtva5+eNQuQlkKfFk6I75SiVQtmU+mJGN866r0ZIjokcCwXhobVkX6Xa65eOnuVvNTMEftnMgpwNPuWU1VKxUGrgeOwk3MZHabDp1mjNGfjJ1cNId/MFwrH2Ltal4hMyjnbixsbFVuBk0s/HBoSAlwYD4KYmjCJTKZOkzRCU5BWCb6SWE1gOklnbDMLZ0NQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(396003)(136003)(39830400003)(1076003)(54906003)(316002)(4326008)(52116002)(8676002)(2616005)(86362001)(508600001)(6512007)(26005)(6506007)(6666004)(41300700001)(6486002)(186003)(2906002)(38350700002)(4744005)(44832011)(8936002)(36756003)(38100700002)(66556008)(66946007)(66476007)(7416002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ewnyNBQWbjL7RXWZTS7jftgNSdbSqz5z7nakZt78aieWWwoRoLjFkMCuxKeh?=
 =?us-ascii?Q?VGiOz5CokbTQr0qIOB9fQ9arOE/kfMXE798L0jsywxUqoFvr6ayNs30yUPPV?=
 =?us-ascii?Q?jT+ZcqNEvYTYJxfuhXtFwQvVgZmboh3PRVGQHq6vnIGOrO5c3OkiPAq3thrF?=
 =?us-ascii?Q?4M9D2sVEq6s8+8WxGFF/C7XHIpKYYKEXhs7e0YrFX0HWWkPTc44eht45f5I5?=
 =?us-ascii?Q?9ZBBNaA/QBT3bt1R0xcUS8lfrh2KnrpDMQcdwR9ZsBspomYmLsyIKdyuSRTW?=
 =?us-ascii?Q?fMa8y93fjqLk220HidKCpJP49AIqYd9IxI5o+9XvP7s1dD66veu1v2LDOFXI?=
 =?us-ascii?Q?vIry9M6Uwepf6KSMk84/nOePW9ZsMjn7SE+JctzwTzVDKZwma7dmi18f92mM?=
 =?us-ascii?Q?opw3F6zMhlM2Kfe/Uk1Ne1PYKCK4LgcUQBplz4Sj3uKJxKcdIutxKhOYECK7?=
 =?us-ascii?Q?7WravmHYJ9lKAv4g4QBzofZ7wTJoNJjxgP6MlM4cUYf+kAQf8ZaiJfUC5e1G?=
 =?us-ascii?Q?85C5GxDxnad6xc5xJOly/9WwuOkXYijsZZeDsgz1qKqysjsRdGeFgWBDaGIF?=
 =?us-ascii?Q?WLajg+2gSUAr/7i6k/4z9H5cc85NPL7OC7IY2zth6vAuV3CI5vrIM2yQbNso?=
 =?us-ascii?Q?deutaaHzXt66ZBseHOXa5Ws/rixnE8nKiU5+3z4vE7v5iWli8AlRDvvnISZ0?=
 =?us-ascii?Q?nHF2ORVTfm6vDLgOWFLZr4hSUpfe2HvtL9rRYwJW0TrkVWPErXjNbrUvKpJG?=
 =?us-ascii?Q?vbNeQBYUcD3UOqaqtOV6LLD3CMpbHDWUaF2jfIYjKOXWX+1+7WSDHNOXsNwa?=
 =?us-ascii?Q?rE4Je6meIVPWRe9tswGYXT9XZKnJFHK8ph0Qq6X/2VUowSCjXNSn70aNgcov?=
 =?us-ascii?Q?GSeTcs1Jr3cL+wwm6dhBcUFhUEkjUwZYZMrLBr3me44P6iVX6NX9clj0xpkN?=
 =?us-ascii?Q?+quv4seajH19XfrqelTrM2bN2jU4cGg/YDprTZUwa1jBgE8UpR+TpmuFv1L6?=
 =?us-ascii?Q?QuPHL+aDrhzCkQJYbmgaDnSrtirdsSjLg/JFRmlwUM0FGnrfBa/x82yMvAz0?=
 =?us-ascii?Q?9FmCYRgWVeBbkJqE6xm6TPyHVEOui+XtIPa//bAoTexotQ1ClXZ7y9hb+anL?=
 =?us-ascii?Q?ay4UGc2tL9i4BUGRt1TJk8ghWHJXzF5nfjXKKhpQLLe7+fIAykerv2eeHI8J?=
 =?us-ascii?Q?+6HeL18Z9vKHp8weZEl/RN99t6J/JAgO6vY2BKqlF/yABG9hKm1esj11ujGw?=
 =?us-ascii?Q?pRFY+wyT5GwdWZHr/gVKy38SMfEdCECYQ2Fr8T3le9Lhs8kDnNkqQYxoyMRL?=
 =?us-ascii?Q?N8mk61Tz/m4kykTStW6K6yP6v+nLSoMCEPKFS6H6h0tGueasb9QJSeidiiY4?=
 =?us-ascii?Q?sEP8jwLRRTVQe1EtGou49TrU11L+ZwWfwEX5YYLPtI428t/ecrHf+cc/J5kz?=
 =?us-ascii?Q?ODT80y1sWQGHPS2yz1pqLVwiYD/AstkCrJcyMFT4F4/xUjdtmlKk/F540ESd?=
 =?us-ascii?Q?NMu6F/xyYq2lR9/kMxaxgNqw7/4xJfzkIoyqRWfrznLBxFSZQ9AcIHDtiUjQ?=
 =?us-ascii?Q?I6H+Nra/BWDKaGzYDj/5EsuxReAx4jksW0gqKjnk4nRWZE2AAfHn3rA1zqz7?=
 =?us-ascii?Q?xoWn3Dj9Tfn8Oqo0yRYggJy+D2x7za1jLKKwPl8WXfCUJ0V2Ulwl3krFECa3?=
 =?us-ascii?Q?dcUDIXhQEDToxPPA9mpm+brhqCL3YakTA4Fw22whdcV7G9ZYBsROjQ7dJ6H/?=
 =?us-ascii?Q?8yPLDySyHvjMwfW05pPCfGfRWOjLR/PAfnTTItp0vkUbyv/D5zmq?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52fdbd1-8a34-437e-adab-08da4b0aa374
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 17:57:09.2779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYl1sXsznaRiLJAG82XgJJKyJwYNAMNQXOzVGWso/Iie+PJXMHTSOv/r6Ya7ksoCJBocSILeJVfj6j+PHaGmtrbmJFY2OCqrx4Eg9LwZCNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3356
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DEFINE_RES_ macros have been created for the commonly used resource types,
but not IORESOURCE_REG. Add the macro so it can be used in a similar manner
to all other resource types.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 include/linux/ioport.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index ec5f71f7135b..f3b0e238c020 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -171,6 +171,11 @@ enum {
 #define DEFINE_RES_MEM(_start, _size)					\
 	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
 
+#define DEFINE_RES_REG_NAMED(_start, _size, _name)			\
+	DEFINE_RES_NAMED((_start), (_size), (_name), IORESOURCE_REG)
+#define DEFINE_RES_REG(_start, _size)					\
+	DEFINE_RES_MEM_NAMED((_start), (_size), NULL)
+
 #define DEFINE_RES_IRQ_NAMED(_irq, _name)				\
 	DEFINE_RES_NAMED((_irq), 1, (_name), IORESOURCE_IRQ)
 #define DEFINE_RES_IRQ(_irq)						\
-- 
2.25.1

