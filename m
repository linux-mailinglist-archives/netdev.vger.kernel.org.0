Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DF8546E65
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 22:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350831AbiFJU0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 16:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347083AbiFJU0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 16:26:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0E1315DD1;
        Fri, 10 Jun 2022 13:24:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BZl6U9b2Z3L3dmk6FMGy7Pji082gkjP6+EyKcVnU18k2t3CeJ76vpKM1fHKNaaKZzbQDZwg4U1gM/wEXBJgucf8UD3gAN2oeQ74Ek1vO7g+eD1mbOyL+Yoi5BMOY0Wwb1x0uOynZke18YzbieCzkBCoUa8dmuo2tPRPJd/6eshte5R/TgLUUTfn6M02AKsfmo+xWOZh9de4IZi6Hrwd27oiLEoctJ8D6wfeFf8l0pGtJH54dBBdIK+sPs82OOTtGbPWKdPFB+acp/hulpr3hUUYOOAGKqfg3gS/1m4pEU61pVd1syZf37OgcbWJLNXsYnr3R9LUXCMuVyPlbcA+Rag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=dGAdqiNrX6EjF8N0D+8mLhRafFsHQHHKHL/NslxTjE53UxW1pLiXlnDalum5aO7GQ1mdFaNlAITb7qAn8tkskMPk42FbfJtAxX0pK1oYxVbuEaKJS3cWdbAuYeEGspaIIUSAIH7KVLa65YV/rhuWGSNB5S1N2dr7F0E9nDEc0zflfiZ+mEsEX/sywNBuckZG4K19S6IrDQE/ZR/9j5z0neE9nBqufWFYwx9A7d2v8+Gcmn1OqZAZZzlwRf13t4IIrG6b3tG3dzlDOrHe3EULBwIh8ke9SctlfZlJYiOYr4Pr5pIg07WoA8sOp9HepKT8MkFXsTvWuAoi95GDV6F+cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpcqD3YrPb8E3bZrxcGsy544jFxVoAUX4RKcmXtCjec=;
 b=uWl71PZrTVisDSme6crGXmesilEKvsg8cB2xislVa2hZSq3ojnOcXslveJShBALdZU9Dv2v5BE6/fz0CmGJ6zCj5rifnRARmTCR/H3p2ohDR2fiJXrpWBdb33CBwJ1PACsph83caoHTwZoZvKfeynFQAndnAB/TT4FYID41uI1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1629.namprd10.prod.outlook.com
 (2603:10b6:301:9::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Fri, 10 Jun
 2022 20:23:49 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b8c0:76a2:4c89:d10f%7]) with mapi id 15.20.5332.014; Fri, 10 Jun 2022
 20:23:49 +0000
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
Subject: [PATCH v10 net-next 5/7] resource: add define macro for register address resources
Date:   Fri, 10 Jun 2022 13:23:28 -0700
Message-Id: <20220610202330.799510-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220610202330.799510-1-colin.foster@in-advantage.com>
References: <20220610202330.799510-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0246.namprd04.prod.outlook.com
 (2603:10b6:303:88::11) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee623b9-7860-45ca-1579-08da4b1f20e1
X-MS-TrafficTypeDiagnostic: MWHPR10MB1629:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB16291B3E17F52A7F8F22DAB5A4A69@MWHPR10MB1629.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i9NnR7ttXicfJIl7dPgdTgdQwxn9nLXjbAcM9NtFzLAbvCJSDAFWGTg04h1xhuvVidjf1cUYwGktQEoPBvl9ZG+hf6nA9HiDiA7OScOplWDgCKZlaKvBm4uo7LlIvTwe2MloCdZTmWhIMsPWbOvsrh6fhJuGOaOHYVG4Zv0G79x7ut4O4QTAujYhJEl0+x5uf+VNRmFJairfQIzJcjtYHt5iK0fhOtd4G86H2iyOHZ4yAjH+apzy1fA6L6AUTViiGScjOjbmzxHowBRADjNpARVkdKPpYR83cO7Nxg5ALPjp/PjrieuZOwCpOL0ETjMpt68DjyY/NCUrAuyl2M+cBtJnc31D6rI+2jQqHYK6bfACBiFkynbQmSa6VLCfWiDJ7u3emtZet08UNluEBrVzBfElk5xOb2h0p+jJr9+sewdTleKmIdblyL66/kzoD6x/0WfHMTb3AR2P+1tWuJGYY/FkKf63RmDmOfjv5dt60560Ob4SVwxA/kYjQ1PSHLGfj15jDfxlhMnyfM7FaxywUbunZ+1niIo/8UF4593NiDvSsyzj2mjROqVIVUILs8rhwn4yB8NaHlesGxA9ZjEclrl6pkYvBh2Ya3RM8msuw+EnYDsejKnJopfccnfNmtSn0jcfFyBm/cT6hJnVD+oLjVG8JGo+97M5QPgynB8aHhBQcFM8B40DsO2WPbRYppYlC+N47SISXwEsVyMnwog18g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39830400003)(396003)(366004)(346002)(316002)(2616005)(2906002)(1076003)(6486002)(54906003)(8936002)(36756003)(6666004)(52116002)(6512007)(6506007)(26005)(186003)(41300700001)(86362001)(4744005)(44832011)(66556008)(66476007)(38100700002)(38350700002)(5660300002)(4326008)(7416002)(8676002)(508600001)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tY04v83dEnsA9d2GaMoQz46JNgH7c4dbmwWpB0oR6qdwBCCCdpLGOXviKIlA?=
 =?us-ascii?Q?jHHpAQei+TkmGheML+ZMFAWYA24/iBN0PtKPJOKC1CaE30cnQ+YbTCw2rWZq?=
 =?us-ascii?Q?TJWXYRvKDx1S4c80p3a82gaGwjc1NzvB2o+z50NWooUM53dBskpqxewYp1Yo?=
 =?us-ascii?Q?sH6KxiLs+ibTQVlmnrcf90hforWk1HwlY3hJB6QMoe0FKR1ijJ/gkHoPfR5N?=
 =?us-ascii?Q?ApN4FuxLJLmTbAJfCTRODZ32ocTS9jpVzwb9Rrw5vaEH0P/l4vIzNiqK24yu?=
 =?us-ascii?Q?EQuNclAz6FlzU/jw/y29+xoZDiauOA0w/MSWbGlOVY7wTxdr+8rihfG/r1EF?=
 =?us-ascii?Q?JOrn/rZTW55j1gwsqKr16Q2JOws+m2gHWyHOKnpk9u98JEf+ly5OhnlzazK4?=
 =?us-ascii?Q?Cn00EUnO1/hJ3SPZ91z1ybKs8VMw/sei9yLcXhHfsi6U/e1a72JsBWGtFTcz?=
 =?us-ascii?Q?27EvvJZTh0T7Ed7xud5RbKAlcr6c1+l3MjvvFF3j2HddNED+2cQlq4RU4qoW?=
 =?us-ascii?Q?/JeljySn49ZRVZdeJxq804RY4JsmcPsxywDIfU6xa97ZsPp/H41KQtvY3Lj9?=
 =?us-ascii?Q?pt8Y/ucq8SrrcJDQmHOARuNmelJgLz9z7XUGU7+bLWZWPaoPOZtbWXULIXKK?=
 =?us-ascii?Q?7QO8hiR9uyZOx69nHBR3M6MQ6ZgKUWEJQlBfHvU1VkIkoHlPE4JsnLOMCJmM?=
 =?us-ascii?Q?mY+ZlPpSvGmXR0JPTNDbMk+QzheC4aEKyedp6CqnOElhgJw44z9SJgNwXSSv?=
 =?us-ascii?Q?58ADcVoKjNPpLeRINyeRiFIl6iSwjmh/A9sHXj116rVV2jLQjhHq8q/LpQIe?=
 =?us-ascii?Q?jZ7olnZJbh/gblP8CtOc1zdVXgy2dXgnrmn5F/J04LyfncwjqbobRbgb1z/H?=
 =?us-ascii?Q?zmNZgJ00f43z+s6jk7cU1pYF8UQyStVblHNNtu0WrGUN6C1cexxt8tsGyQIf?=
 =?us-ascii?Q?0kbHwiGSBAX3A4bSgSLnJoHE7mMeFQn+jIRSrBlatr+Qz71LPaUa23199lt9?=
 =?us-ascii?Q?r1oa8gQveNphpAkxG4uee4KjFslljLdt78f0AqFxoJErea3NaS1NQ6lcaRyS?=
 =?us-ascii?Q?II7doz2NgZBFm7CMZVw5fePUqrtkEFgyQGpDC2Wn4zWV9AMdc9g0nZHJdISk?=
 =?us-ascii?Q?zpFdW60OqobwXSdx+ykxORJ4DEaW+mKdhn15NnUvrXudKf10qLhH98zDhevr?=
 =?us-ascii?Q?HgleYuKAPBCTCH7pbjJg5fi5sUUZnGAZZLjxndYhJ9Q/wRFOkNLjdLJ5nIBG?=
 =?us-ascii?Q?WyBLkUj53H0vLxPy9rUAnLSpoSoJvEiqeVib+akjsKV4bAkh0XyD5xqmAj8q?=
 =?us-ascii?Q?ME0juFFWvulVGyNPLo+55Wm/QwdInXnV3JwzLRgMIe34zCH9OS3jWLc4yKeQ?=
 =?us-ascii?Q?CosbVG6rIfkyQNTmBQFgh7ciyXW3Bdx1vediWdQRxqzARV05P1vBLpwJFUpz?=
 =?us-ascii?Q?hyXagKof0h8TyH/9iAkPEm18YQPOxyxDdfe+5AhFeFEQklznWN5RlFu/Hy98?=
 =?us-ascii?Q?KS5yKT3vz9On1TGHWa3Pj81lPiVlwT9kNs6hJ8VUbgGaywOMswEZt6V2Cz8F?=
 =?us-ascii?Q?Yd7Cls0ASV//jO/YzuMcUPW6///4dkO3qJUcrrO9+gf5aFZ6oha6LfLjg7bk?=
 =?us-ascii?Q?oW8tdKDzWOsCKEexM5yT6Iu39B7Akzb7h9BV1y4EjDBgdAL/btHZSpruGP+u?=
 =?us-ascii?Q?Sz/fiQjFo0hjA0w9/7MsPX38N6ncR4i0hMFKOEJAAnI2m5GUSbV1G/zieOcZ?=
 =?us-ascii?Q?0UbZjIdxXyt/PRzcdCjQTgH5bsxwWujUd511+rNFTVW2p6BMrTGX?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee623b9-7860-45ca-1579-08da4b1f20e1
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2022 20:23:49.5756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsqIFD7w9OpeDrlRH5Cp+YKPxdbq0X2tMaK/91skCTLOjr3Wz2wxgyNukRv+yJIDImycAfeZ9pAjpzEIF+5pDKFVhnHtRO9SHBZELUUJdRQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1629
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

