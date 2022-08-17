Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB92E59672D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbiHQCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238210AbiHQCDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:03:14 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150040.outbound.protection.outlook.com [40.107.15.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8E01160;
        Tue, 16 Aug 2022 19:03:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmhOaO+1xph9bdLUGJY0+UBXpPTGmS6rAwdO12mCCnGXKqNHQtP0jKqPERg2e8j0/3wTlRh2dokzYcg9hKpAozdygFBR5/jZBNhIKCxCafKwR9esCN+jnqht0IFPErj4ryn6m/8B4LpDtC/wp1DUSONwDwb4jCuy2guIJhvQ2RGXPjmkE94VFrDtC/q+3I3YIZ4Ky5yATjdG8hIJChz4gZWv9OLg2TQWqsPdDoAGFB4m/cI+FU0LyXNY90ZaUPW1ikfxUf+fTmTMiu+I9GbZD9jA9/5IegBJnp3uiWNrhfPFj0txRlnZYkgbjqqu8oxkOXRi1ri1OeNOVizHOXZ2Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URkEtq7uAp8//JZsIrY+9niAU5lQ7mH4b/FpuGj2g/Q=;
 b=OebAeckE58QPwcUAU4hQdDr3NCPFP+OMWPf73YoArP37doMVKafEB2Ta5D3dUZKW0Ycgci8+LBC6TVFRQ0RBgbA0ZyCKSByHlKfu6awQC+iYQzQ11QpxbArP2ESKQSF2ZeHBB38ZIqcmf77lQ8giQq5jgdj8uhrvfNeLNKBUUlJqd6nFP9LvkxIaVA9Dmhg9NDwwbZHIGmaAOAjmaisYy2Cpa5tEleHmDarFcwQLttqcIY5PROBZBH/huPYy6lDFRyvi4JTZtZKVZu0rMZbbVj8PAHSuvMxOqyrmCmAM1R5OM4S9mvfXzcmqYe6JBAoEI7ioB5Po6Q8VNmBhWbBBgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=URkEtq7uAp8//JZsIrY+9niAU5lQ7mH4b/FpuGj2g/Q=;
 b=q8W2/Z/H4+lGfo4YFzSk/BMLzm+Et4MCroOcrBIdjHYd3ipYOcX++n5Rse0Hl3fp+zDP97n9mX/cXR8qpqyVIBYnqE9rx3WNBBEBhGosfhNBfKvBeraHK8wHzp7w+wZm75r3KAecuxShrxUwl+fpt9davXxPBZ8bK+fibE+tOvM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR0401MB2350.eurprd04.prod.outlook.com (2603:10a6:800:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 02:03:07 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 02:03:07 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net 0/2] Add DT property to disable hibernation mode
Date:   Wed, 17 Aug 2022 10:03:20 +0800
Message-Id: <20220817020322.454369-1-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0191.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::6) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9721441f-265c-4f47-7ab9-08da7ff4a0af
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2350:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /K8dw6EHzHezDIRK29o+8qhNPbDdDCz589Wdbe9lp6QcOYzpJhHemyY3rog+YtzYBhUI1cHNE4VqmCYtqry9qcY1Mkcklby4URAjuHceIXvqF35U5okNA5hcuqvESyjFMSMuUsB2dAVmWZE3ZC1TsNmL1uCLe9BJ8zJExjU+3zgC5gcdmFJDDADMphh8yYYeyTIufXtFiG0h/Of6BPg7Tbo8js3knB7l8hpGpE7XERUfxPjmMqJn9YeEm50Eierryn7Nl4eiJzmHAUZe/af9R88q7ajM6KN4UtfEjmZWoMejwAMrV87izr5Mn3mubdtbTMxhvPmGCMeD71Gr4625qXajcNNiFEldr/Mo0k4PAVmJTBCk2G3KPAQUwDs/aXBbg/BonrGbSuLXNXQKKXMrGWtodeOSXjYokeNCaHmnUq1MusV7D/wcIwY5+MesiW2OKvYgcT5BWzqSM+KXZijl8JkTr0Pc64mPlJ+gyqMz4Knjz2284R6iWClbRtYYjP2ux6LQH9j5o/rYkt/KRNDyEPSWbYjt/HTux2y3iSpH/nB99y7IPFQTAW2dg7wbf/uy/TXlVoBEY1mr9fd/KrK+eBMYTQE+jGHv00sx8ajq3yJXcWSlGjSXlaiGmkwd8m5TaVXZflHVt8mHaaQ0tdpf2sYEvyOUeXgmEI5U86x0E/2dM6Ci8x8FeDDWWwMc9xFhiTZ43ffFBibK1tVE2QhicnqAlVXGAUq+A/9PCXh64RmjJfO8Atu7U/UYdoTxbP2a3/rBYSsczVkSkIl6La6vinP+nOU/zsRJRb5D1ADd9b+8BGfAsFEqNXCUzNA5f3lC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(316002)(83380400001)(6506007)(186003)(5660300002)(2616005)(4744005)(41300700001)(7416002)(921005)(6666004)(1076003)(38350700002)(52116002)(38100700002)(9686003)(6512007)(26005)(2906002)(36756003)(478600001)(8936002)(86362001)(8676002)(66556008)(66476007)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iHrVoCbSzbNg7yAfzgXMIkHWcxvqbosU26TXzRe8+mNAV1fG2XkeojGEdVmk?=
 =?us-ascii?Q?TN9hFYIO9X8ST1+zexEyd9qZWYG/q8dHH68sDeP+pMKQDIUMMI57MTwEF23J?=
 =?us-ascii?Q?PWuJKdjbHc1Yf1PWFTM1DXFhNksAlBleoGmxGaPErQSpiE3iVNTtvhr4RgVb?=
 =?us-ascii?Q?0z804awNlpho3OTRSJZwWYNzeXk+NBKO7NvgES8VcDWKrp2T/P7fcfcBrRzG?=
 =?us-ascii?Q?f//KyfGwalhEJvK8t3pqpAcKBAlqL3HkZjg9a3fWMdNxb3TaAcrT2DBKSHDc?=
 =?us-ascii?Q?KmnZZVE14UPCDMoqgqJM/AA6iqRq33kb+2mgQCNuJJKv2wN0WLJCH/XmFCIr?=
 =?us-ascii?Q?epOOoZGmugi1Tu8PljEemOf+DyXyQ+uHebsrwI3IPyo9dkHEZUY5ZZStWjXu?=
 =?us-ascii?Q?KX6G65XfNydtfojKDrGoVsKzGMK02+k1VyVIZ67VkLsVJ+SvL5kqhC3ni5K4?=
 =?us-ascii?Q?sDyZ1Gz9ag+jIwxIPsGcrvjp2OOqIPA+xs7D2IH337dRMNlqv3PGp141LGSJ?=
 =?us-ascii?Q?JiL3KPiUOLQKCnNEnkAjkPO/b4hjszXR8R1sfZBRLoT2IakR9zBDgNzRYtaN?=
 =?us-ascii?Q?unH3wwGVqorDweFhFg2pvGMdJn4a434GNZ8Cvz13C8Nsaa8HVTTJFIAktvYw?=
 =?us-ascii?Q?OXTriOm8NNIscbGTOgiUge4iqgeCKl7Kpo3VuzYBA0jyYHSrZ+lep/4dbHp2?=
 =?us-ascii?Q?G9hygdDYAODmdTCGM936XkGAv6xCJc3H4ouHPpBFOvImkokYLR9+OewiSa2/?=
 =?us-ascii?Q?T0Zjv7sChk9+myohF8QKQoR0bsTTRGiBJuBG+TUtaTZzfly+DXQ6xuphZbsN?=
 =?us-ascii?Q?u/i9Cl3oYXT2gYXBXd/0lXPK4KU5MUIJ/mDAyBwbqoONrT5OdvswFGt4DOrV?=
 =?us-ascii?Q?4i2BsY46sxnz8mQWsNrq2EaRMH1Uun/+Ma6t+qDqUSaEiS+6XoBCfXuNZntJ?=
 =?us-ascii?Q?+EsmnMu7w3WM5uctxoBz7brAV6e5/DE2Xa/3JmdbYRrnygFqxB6OOZkmdUdO?=
 =?us-ascii?Q?NEhFuP4oG1iQWxUHFPtl0ykBLthWlKNSHZX77cAeIcT30LwZuzeqUvti3OEz?=
 =?us-ascii?Q?YFpD011jaNCEKYJclEJJt7Tg1nhzu4gtOPZKlMnuQA0/7EoSiWAb3lqGtFNY?=
 =?us-ascii?Q?GlnabTjpfRttsknyy2MuYFPdo2Mp6Mxi1Rzm/G6RZfu6HPrRGTrnK0BpdaPL?=
 =?us-ascii?Q?TzFOnm8ReE7UZs4CAR6y4x3N0M3gZ/nCjxULKC4jTM1hN6N6A+vCXcIS5kNC?=
 =?us-ascii?Q?0eymh1CiQwXcTdYkIRidSixH/Hbb8cGEzdYMLrKLGHBM4dO7cY/8NnCBs+lW?=
 =?us-ascii?Q?VIl/4ukVooaTUHde5LOWhhHwppj49RaozsXABxh9cvCOzrf+0BNmsIEhtPty?=
 =?us-ascii?Q?hhpTViIITqsVPzBZDvWR0BQvrhJkaGw5/xcRoHJSctF6lziry0p59wMfz885?=
 =?us-ascii?Q?2V+hGviqhlu31bx82T8aJmAjRNEMxoogv7x+iQXSl1SkulGw8RVEgz/6j5Gg?=
 =?us-ascii?Q?wx1zU+h5S9PNNSOtM1c1jwFtMT6mNXJfy2X1ozURwPWun/YJxYqGriw+0zq+?=
 =?us-ascii?Q?pALQt7t5ZGTLCyrdpXoSL2GmDOwaE/Fpmzr2Wusz?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9721441f-265c-4f47-7ab9-08da7ff4a0af
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 02:03:07.4073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rwzqa40692GVIY4z82kbIYGo4d/X7cajiDWc+x7gUGqq7CVZogmSUVy9SUMbTKlZTBWpXf1iP5dkTNd+r7INIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The patches add the ability to disable the hibernation mode of AR803x
PHYs. Hibernation mode defaults to enabled after hardware reset on
these PHYs. If the AR803x PHYs enter hibernation mode, they will not
provide any clock. For some MACs, they might need the clocks which
provided by the PHYs to support their own hardware logic.
So, the patches add the support to disable hibernation mode by adding
a boolean:
	qca,disable-hibernation-mode
If one wished to disable hibernation mode to better match with the
specifical MAC, just add this property in the phy node of DT.

Wei Fang (2):
  dt-bindings: net: ar803x: add disable-hibernation-mode propetry
  net: phy: at803x: add disable hibernation mode support

 .../devicetree/bindings/net/qca,ar803x.yaml   |  7 ++++++
 drivers/net/phy/at803x.c                      | 25 +++++++++++++++++++
 2 files changed, 32 insertions(+)

-- 
2.25.1

