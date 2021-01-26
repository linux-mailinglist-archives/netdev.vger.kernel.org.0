Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9C4303C6E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405376AbhAZMDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:03:37 -0500
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:17793
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405216AbhAZMAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 07:00:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MW9H+bzvlDQvutu3FNGFK8o/Iq897K3nGr6ZdSJqDQbovP//mucEfBEBawkZxJlW537u50BtLhtZm+jv35I8h9kgL0cfPZtyEo5tya0TIE9xhpaHr50IbRqXJ0z7JSq3drd/BbtZxQpIKz1lFxr9cqejlWTjG6TSkV30JptdbH6yukvOQ4lHAJuMYlRqsbW6/Eeq0XJBXZpLxI2j/BBH4ndM5WEe1hoNyPmiFrWnVEM2W6UM3YgAJAsAv6yxcerrDPLZNZEmEskBwviaJbL17M2fLHQEmOyXY5T8rmHT1ztxK3pqJpypmv3WZcLwdPLTxXL8c9FbTcZ2yP9TNwGQQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/qjr95ywD6aT6YKK7l7NAXnm9evGN1OCR4P5EZRYC8=;
 b=MOaKuwW0BLWL1Bm/yF/Xw0WyiHEmmkQZUvHVuYzlTclMAEYoPAkVho5x+ckkRM+Yw4kcAivUShxr5arK0gYO/pwr+fs+2AFujNdoJnTMxR6CSazxHLUP9W7ENATjKzb5P5J0hhplrbVJJ5YnR1dpt4C+KpFDwIeUg8fxmkHg9O58dquIK8SgLfS0XZixjl52SqnnGkO4L394LeQjHllXeUcpFXe+jXlSeHFhbh0O9rnQSLPAtkwEUmw/SsgoE+4IXvIdkh8DgkK5UtzFsBDn2EuAW4odAjN4L9CrMGJ23z+9M9aeiaFUCZnIHehcS0zWLheSu0pDuLfVVYxgfSCNAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1/qjr95ywD6aT6YKK7l7NAXnm9evGN1OCR4P5EZRYC8=;
 b=jLDSW8WEMm26nQmpy+x5KgwWubayxiRvr0pbzJo/BdRjaIGnqufrTrd1+DWdFPeRsW83WrM9/ElVXKGzNoaKxuFmXB7XRk03smHo5K0wv4Auk7ilI9rocLrJom0M7CgKeh/nYyBGjX3DDSYCcBTrvzTGpJtNKUDlHT1pDkRQuec=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6971.eurprd04.prod.outlook.com (2603:10a6:10:113::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Tue, 26 Jan
 2021 11:59:37 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 11:59:37 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com
Subject: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp clock
Date:   Tue, 26 Jan 2021 19:58:49 +0800
Message-Id: <20210126115854.2530-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Tue, 26 Jan 2021 11:59:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df1e2ee7-4395-4b1f-a339-08d8c1f1dacd
X-MS-TrafficTypeDiagnostic: DB8PR04MB6971:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6971389E8F4F4C112E4BF322E6BC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdBqxhvokVmDU2nPyG/B8SiERopbIjQqVNGTex6vwAvZv18CdOom4keQNX5XobUsyoN+mtqDtMMZWjblUoXzhaHkft3eRTGeUjOuUkwwgjGf1U95DrcuKdBPP2RjIw29RtdxErRoiaFE90lYQ+2ayvosLmlhU3X25meMZ20DsJ5mTvoGymv22P5EeOdeW2uQUeGvxU9aaIqRmVHGIU0MlT37Yqy1jmqFWo/Jf3YRAffLPTTZGdN9XeBABKAa4GFi9BoWFcv+r/Bl6dg02kM8oSnVfrHOvaDfH2fITdiYlD5traW0roOolv6mWnWPOnJte9W03FudXKPo8nVIe8+wjS+IahpZhJDDNF0QMpP/DxfRQ1uir3pP0dhWVwbR+ksPiJJM6Zx74peZIMVW/rCOQgdvO2Wc0KIQck4z0ct0DeqvSTCmCf44HpWjfVLJSZeikgp/ysR7qiQ1ckKZHD/L7tzj1nbK6EZLPfTrvZF97/WVOmyBZXDZLCbmQo6BeaO5I8SYL9TGH7cRXO8STM/V1REDuNewj6dJhIB1NlcrmQCSc3UZWDsCOMlNYB9YhElIiUowH7hAEIXOavHiH2st6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(396003)(366004)(136003)(52116002)(6512007)(66556008)(86362001)(6666004)(66476007)(478600001)(2616005)(6486002)(956004)(66946007)(186003)(2906002)(16526019)(1076003)(26005)(4326008)(6506007)(8936002)(316002)(69590400011)(83380400001)(8676002)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4i5jTdBEk/yTha0+IXaAomlwFpFeiutdeVxB3aaPhuST12xWDnLQOR7YS181?=
 =?us-ascii?Q?sNgJ29R9229bS0E/Huse7gu4ni1Gwpnw7Iv9nVz99YKYxf1mYAQQevrtVckh?=
 =?us-ascii?Q?L9WS46rDhD2hXQ1GV3lqSs0SWyVJr7aUc82S3mZ1AgHm8ofnyJ6DvtVZhhFL?=
 =?us-ascii?Q?Zu1+DqrjHoxzpwdy1MMTec3QZgcer0kPjSVcfza+TfVg664DqMHXda2zV8gD?=
 =?us-ascii?Q?cqfqfwyJ/dHhvezF/msULPNhP2BISQKKwYe4UY5zCyC/cnJmH4STmyKkYQrq?=
 =?us-ascii?Q?w/dEHt7fzZq4h2TWoWnNITVRws12AaSgOCgzFI9It/54GRmTg/PSh01GDWwY?=
 =?us-ascii?Q?gnw+ynteOf4xSqgR2RtTx/bjwIbolm7XRpYJ24jq8L7UCUJ9QJTMASzykeK1?=
 =?us-ascii?Q?AZA0c+NRfhckxDGIxGI5X16wEq0UBjvkKigzExvcMslmcodyeljPzg/urvyU?=
 =?us-ascii?Q?Q57KUytR43oTfq3/UGWet8mlrfZAZKoXJvOYgW1bGhkfMzM7Vdjuo20CKFR2?=
 =?us-ascii?Q?ko5qy0Hdp9bAUpBcxEu0wFZubBqzSCwo9hulM2rDQJyaZle7u078M4A+f7Gb?=
 =?us-ascii?Q?MZhpbzcAjx2xyZCVWunfzpMxRWKajy28tLIWO6fr9RKTjOdK0u41f0BZo3cC?=
 =?us-ascii?Q?permAA1HDT6zifShZXx1NznhRamF2sLwDWCIuaz75/lhMvNXyKmNOiLMDf+/?=
 =?us-ascii?Q?HqWdy6dBvOYqNrOmAiQbmg1lK1MHaiN1BqA8M8FiKEFoJSDQUS0gVJpenDSc?=
 =?us-ascii?Q?3rnK7UnV+aKS1Jy/XmEwOaa0WVVJjWeLFswrVPDqbHlQRwYLscp+vGvovgBU?=
 =?us-ascii?Q?DVk+Kjl3Bie8L9nPpJbF/cnSBLEH7NZji0OlZnzeaelh46tV557UUmDTtmS8?=
 =?us-ascii?Q?yYwxfmy7k1/lFCVrDZKVW/dE97pE4tjuz+2LjrTCLvTY9jgwa1B05z4MleAs?=
 =?us-ascii?Q?dE2YEkYfwDPErF2h0Jt95klhC67MfRP3V3ukSqE2INgInf+6+cM5HzP/6e2c?=
 =?us-ascii?Q?thKu8dI2Dqs9SFre7+Z5i2AFXcz5uDgRhdh4fv/lRX3IIh8PcitUe+EBW1+B?=
 =?us-ascii?Q?sKTqGoGc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df1e2ee7-4395-4b1f-a339-08d8c1f1dacd
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 11:59:37.8220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: khys/5ORiyAC1C0OyLCkRElWu/IYiU1BWEHuXcY2Ef4TQoXHCR51fLvoGnT4g95e+4pQQsT4cW75q7kgRlnugA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove redundant null check for ptp clock.

Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..11e0b30b2e01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5291,8 +5291,7 @@ int stmmac_resume(struct device *dev)
 		/* enable the clk previously disabled */
 		clk_prepare_enable(priv->plat->stmmac_clk);
 		clk_prepare_enable(priv->plat->pclk);
-		if (priv->plat->clk_ptp_ref)
-			clk_prepare_enable(priv->plat->clk_ptp_ref);
+		clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
 		if (priv->mii)
 			stmmac_mdio_reset(priv->mii);
-- 
2.17.1

