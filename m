Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B17A5E59E7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiIVEDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiIVECn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:43 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4190DAE857;
        Wed, 21 Sep 2022 21:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qf0OsrHOdvoss8dZvQZ65uw6DAIdsffnpbhZStmYb4dJz91HQ5JIkhP7ENDNqenZtFYGjkHqEiauReWP9KhpqGL/rVF1pZXoRDlcdZXXvfxVyGSJTeE6U/woIbr2OrlQ83rnsf05aO5js5NEhCrWW/GFiwKjlaWWmAuuhXePDZQ9fG/cMr1weKdBEdxxHZN+Ey8XmNNvm7mfZ/XPLJGLZmWlxAqR5iFMSTA/wNZ/X8gNBqUbY7ZbDzsgg/0so3oTxBtamhkvP+8Gb7D4Kxy04+9xrX2pWBaH7Ct1RCyD1D+bqlQgKQpugXG3JkFkUqr0JdtuR5QAgY2HzDR/OuuP7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2St/wnhFy3eCvX39K5BODxMvf/1cHD8HMPYGL2JVFw=;
 b=icQABE4Ppd74/5vYskb/xdg7/CJXV28LMOqVK3MtmwDsMS1yxkBx4Il3B0wPBW/iYz7i61E94rcSQKHNKvT8d5JlgKmbg75wyCo/Oj1Ze/HYwqfBPQD8o6hpl2LtrFA/Wtv1yCF+A2P0GqTo+zCM9PqpqAk1Xh9F7zip5vh3TzFFlTjNeHSQFeRe745SBtQvj/y4wBD99vd4QdoAu39eXl2LhQzJpGQ9Pvt5m2yl5m/AicAN/Os8PEypn3LmYn8SPL84pnTxWUJlyc5KlWoXJgEoSfQGsJ9jUo5hsfimkAiZj++/HI+U4FNLFgyZkM/DDxrpRbTHOpVeJ7FojWJycQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y2St/wnhFy3eCvX39K5BODxMvf/1cHD8HMPYGL2JVFw=;
 b=nkHQEd8x7LeOkEjZ9+tIF56oNaGd0sVbsXO8WyRVRXGV4qn61cEqLB7XJnR/bQrtQG//ZRaSg5AuJWY8v/Yvg9OrErq8Q7lxmsACJq5jI/hmZMgJBUnnx3BldDCVhAocdNB7MLqS8P/jmtoEhrVjOxO9ux51wn10jIqeXMcMwdY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:29 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 07/14] net: dsa: felix: populate mac_capabilities for all ports
Date:   Wed, 21 Sep 2022 21:00:55 -0700
Message-Id: <20220922040102.1554459-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: e7d63a46-9bc6-49d4-a30f-08da9c4f208b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 09GcxhPr5grRb5rnF0hp+USYes9n0LVwK5JwU7iTEGyEXn2NQVmmhRw3KD7wlDBvvLKY8EVpLjaa+NrzC/ThvAgSLtNxstr66agGz2COchMKQ1vISDfK9h/iO6gr+4kbZO+PiPd7Yw4/H5jzxCxUgtLQQ/QgUItYg/aHI+fKdPMopuxTF/tHzVpyYcx+dNxb9MTg/w2ekp83DV76d7h2RHIslv+FXR+0MWlJ0Sgxfl35R4GHHjtmpHwe6PxxHLi6/PHp1CdYX1V2D5nTtXG0N+pRtbbA6lAoXUfZgFNEsKVbOiKdgJ0KdFRP50wazRQ4sTLwifzlVDkxoHdVb9L5eY22wkTkwoGCvLJRLUANdc2z7OPdefkYd1RswFZG7jTOTvwVnvg9DPk/T0n+LzSxj4A6qE1YjOg7dS08weZifV37TRUk5syJA7k3SWOmSdtM+42l7UXrv6fVerz7vS23/REti5CKxkfxUPJ0qpNpbIeetvYz/N4KiUxwxU1PWXU4CKqIq34c9uWNA8b9wB06sL00Ufh6aDTEUYCXx/GoMVf5cn+ujrcpEmDWRBtCcklQ7cER8IyHAr9Jyzf5f+7OXvVP6bb325BXreZ9d5+zPLnwFTlaDrBli/fmRyizeUH32wFIBvGTczAwmQXDfsMULmUbhttj38gopR0H8RaiEQ64/Uq4QLt7/jBwYAojjjLcgv+i6coqcQiNpxHLOOUOeiYyu/+4jpR4BgU0984DukiviFpgsENONOXusmTjlzo90d5LBesmlmsFPxMFD4X10g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KzzdkszRb/tM68/dS0/ZjdvXQzU05+cQJ8ODMnQ5v3bQsPY7Vc6oU43b2xjo?=
 =?us-ascii?Q?f0ZA1OhooXbPfWasKj3CbILwRaWV5Q84rGTS2x5uutCZ3qWM+hinS+Jnt8on?=
 =?us-ascii?Q?+mHVeogycywxijOp6c8C2Snshr0i8qBVJPs0S0k+hxTh8+yCjMLFBnDpQi0j?=
 =?us-ascii?Q?NM79lJEP6ztfnF0A9IoC/MCtGpayYb5mePptnkkVxT64fDIe2aQzWXt9KW+Z?=
 =?us-ascii?Q?Kg8q1boEvVvWxpYJiYvHqBjbRQ1zGdSk+98JW954iQ8lyuCMYUZNekFpX1v8?=
 =?us-ascii?Q?vDfwnyWmx3FTPVAgmf+UZ+83NhYuYvrnI9DDfxLXh+BuuBmWl+9ZGCMB9QOZ?=
 =?us-ascii?Q?mQhWW3swC43ukjKmyhgCYNmiNXbnQv4+pQtjX1GOFwdLGDKc9gvcQ0s2KRHc?=
 =?us-ascii?Q?aPi8PA8ZKIrnAZAmyoSDJc2KA68dfjivPdCfkKACufaw+CSZbEV0RgbqP3q9?=
 =?us-ascii?Q?QBcRcqdGIUCMzll+teXteHCL9tpsQ6PRw5Hx3VnOU4IdH3gNPz8nalUQS5yE?=
 =?us-ascii?Q?dwPpu1/c8uQ1krZUSpoUjH2M0JLYeJDiSYgmQ4khXMZ0MxPR0I5u/l92sR+q?=
 =?us-ascii?Q?LTK5KfxwhTRYGwFsCAXmS/DNLwT7c1sYK9lTpiQdE3izLxoG5bbxEazzfVkd?=
 =?us-ascii?Q?vmGn6ZYHEx7SPEcTx8MCUVM1vWB7BDZ9omR+BPd17DKBsZNcPgbxJyV0pT5v?=
 =?us-ascii?Q?/KSqsernNkejOiHQBiqjga/FSViXtv6jS62SeF5sllUEUyKNxVK60NKlmDss?=
 =?us-ascii?Q?+6Mxs88iNfE6SiteaNdxTd5AUD2fDTvMaS7S254k5QS8A88z20J0Zm47D3ha?=
 =?us-ascii?Q?B3rFL4R72GzzfCVEZnGcxsLA2RnzDIBrELRVARYH3FzJOA+VpqwtTaTs6Kpe?=
 =?us-ascii?Q?/nV7e0vOBHx4rR8c6J9i9ReQ8/A09UrAATrYVZT5r65J8lTtyAq2nWyj6aq1?=
 =?us-ascii?Q?Mw9RtD//xYJXP9myyK2EdtsCR01ZbJ6rO1lfB+RiWVthnFGged2QcF+4hEJ+?=
 =?us-ascii?Q?qmJvaPBfcu1Eq4LybjEiVEZxlzjoh3RfuT3Efj/oJviwf2+mFy/0IYFf5Sgd?=
 =?us-ascii?Q?4fzTJGli7d0yWjGn2ZLGcHG0heEwOFCjtdA973EI2HqlJj180WCR2HX70q59?=
 =?us-ascii?Q?LhVDhbiMCIzVIVV3W0VGeLS3VIUp9T4o2TsUDe75yUdd1tLShHtEUUXiKXDP?=
 =?us-ascii?Q?hZm/Oa8K1Z2HRGWo8XBmBMHnRB8lknT2+BOVsK6OL3xzVJT3zasE6NCXVxcC?=
 =?us-ascii?Q?LMWkf+XkgLp+FSwopfjNz5jrU67ukLUDrF2+akzYtneeVzASDgfPRSx/ntEq?=
 =?us-ascii?Q?nfyF52pO2lNZ/3+0bvaGJeVdPbIMMFgD8a1g30oCmmG053V/8bN03AfGkvmR?=
 =?us-ascii?Q?kZS3joPhxyEOZdRxI/HKITpZN/O8s4CEnmapwuRdwLD6KBO/cqoZ/qTusVup?=
 =?us-ascii?Q?q4oUo5JRWLGo8kYOomwrDwK4epVbQ4F1+oKUI9M5EBpA5/eCi95AcNQ+qcN2?=
 =?us-ascii?Q?1ltsVQALEuSmw6UF3lZbHMZnnvT58qOEP1+UrB7NVmdUTtdZPFMRVEOCVu3Q?=
 =?us-ascii?Q?TPNnR2dCJ7wToH535kKIyrMg+F9OB7S0/jPtTPpoZX1gIO4Ptoug50tL/6j6?=
 =?us-ascii?Q?dA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7d63a46-9bc6-49d4-a30f-08da9c4f208b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:29.0592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMpe1oCSv6B5CUL5pIMGxPCo3K7cnz6uOIVvh+cFDfye08M8Py7rZmFVt0vLQecjB1aPzclTImETQeZoPh0U1H/73tFF9tt8KX1wEW4o1Yo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phylink_generic_validate() requires that mac_capabilities is correctly
populated. While no existing felix drivers have used
phylink_generic_validate(), the ocelot_ext.c driver will. Populate this
element so the use of existing functions is possible.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * Updated commit message to indicate "no existing felix drivers"
      instead of "no existing drivers"

v1 from previous RFC:
    * New patch

---
 drivers/net/dsa/ocelot/felix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 07c2f1b6913d..a8196cdedcc5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1050,6 +1050,9 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 
 	__set_bit(ocelot->ports[port]->phy_mode,
 		  config->supported_interfaces);
+
+	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE | MAC_10 |
+				   MAC_100 | MAC_1000FD | MAC_2500FD;
 }
 
 static void felix_phylink_validate(struct dsa_switch *ds, int port,
-- 
2.25.1

