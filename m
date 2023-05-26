Return-Path: <netdev+bounces-5569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7FB17122B3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:52:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74BC81C20FF3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E345D101CB;
	Fri, 26 May 2023 08:52:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12E3D507
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:52:43 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2100.outbound.protection.outlook.com [40.107.94.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABEA12A;
	Fri, 26 May 2023 01:52:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6m2MHA9FG9YxXlVh1Oowqbnzvw6XtEpezjkVg4QksCHwQeC/KdrW9dM9Hv8Lj0xWkmvRtguhoHC2fQB5AqYsQd3UTZ09Wn2RVCjmUIWJ1mTOdP2Q/HOa3EqeISRqKzASKV7v0y7D1/nqby0wY3W4NITb8Y1xnJ2DmdHZCqahW21PEXCx2LTgfofKnHxgzYV06KxkZ3iV0xtybzlDBC2msRXzawVe1Zu44/BxgyTrK2HtOoI7ZGXrh4zQOuQa2rrPX2qlflzJ3oAViblUWsRq7EcIWcrA1CRr8s3o2yph0f1WZubA4X+3YCAExl3P7ExsAXyT2jLl3SLWBT6thFKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMQuDtDqYpSzHXM4fx/7xpuy58MBJ5bWGAyujrJwIn8=;
 b=adxEi1X8py/CEsQIk+7MpeXQ9ZHH433VXM5KdOUzoCakOxQr5MiAJA4dBkYsTVWpx5eiEunnFB3UAOQAnapGAMUnO+lBkIPBp3ZYXUhXrzZv+YaTVxcAmOqx+5ERlxA90Bmvtq8DDsg1+E4/ceHPfYOA14wQw47ixAfXD5kHssBHVqkdYNamXhOWCA1HyKyNTDt3Q9oCW47UPpCs3Od170txlwFUd0njrslfFkH9hQ/6raMOdgtW4ra7rw+fGKwnJXDcyuKlhbndKcXsCFYr2z8OjejXTUlC2rjIW+JUBTht+lQEAUZIpYYYWFyOrn3CUpzuG0DkjkWcwWmSo85ZBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMQuDtDqYpSzHXM4fx/7xpuy58MBJ5bWGAyujrJwIn8=;
 b=rZBEbCYgl1uHFntWgDgdeByQPr6bwedWIEka2u3/ueSUIfV0SC8JSJuR+YuTXAuX1gDrOrRwOMrMMZhUGAkgVMOaCVw93LwJGzrb+xZbypCwpOm/aaNZOYA4HtYkujWbvZztEEoE2LU4t7b+9O9Jz/F9hNMcG1Ll7nFy1s4Bz80=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4808.namprd13.prod.outlook.com (2603:10b6:303:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.17; Fri, 26 May
 2023 08:52:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 08:52:37 +0000
Date: Fri, 26 May 2023 10:52:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next v3 4/4] net: stmmac: dwmac-sogfpga: use the lynx
 pcs driver
Message-ID: <ZHBzQaWi5oskThI2@corigine.com>
References: <20230526074252.480200-1-maxime.chevallier@bootlin.com>
 <20230526074252.480200-5-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230526074252.480200-5-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: f829a2c1-a407-430a-3543-08db5dc68df1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w82s1LEN1uj/K/1drRPsSgl1tv5aNRBHV9gDNt33gEq19iqOAeBr0X6KL4nfuY4LKBsJZ9lXdzOq2KqdPoh3lJ34DixUQ/62v8gh1tILzbdJFPLVyTq2ceD5nmvOCEZTgVo+3lc9Rd+Fisk/6N0tVwNZp3UUCFASxAPGgffBgKVsjky+qf3/PkaLrad80MLNSlam1nAk9dhaLTxFnBBqagtiFxQh00z2ovgywbdQ3qIdvE7DREGSEVXg8BliLdtEQIRtcdHKJrYtlbWODaxM9EctmlYsSjRBsZ8X+nYlAek57kv7Dbc8xt6UTr3NjU2z/SfyXcQVlIF71UK8Sp1f9quKznIfSuDwsCRCbhuaBXwKYyuIbo4/Hhw5q9V/i//i/zTKx/7WDJaVXZLZldX3TSu79Re3Q+qxqeu5mjNr26YNrfFl8hk7qg7/gcuhQE5OyOcsYIaUOd/HejVP5OaWpwfsRh8MVFGwhOz+HyLwUP6EIV2E3US8Gear1hwW/41+Xf6l4MJJILNstEt5bhYTpigqBv/4Vka53nsR4FgYC1cCLiAoxDjOfcEsZsjGE44B52uqwffqyN5K93V6fl+qzQt0VpCb6gPnzV9KmVtqkyQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(39840400004)(376002)(451199021)(44832011)(7416002)(2616005)(6486002)(83380400001)(38100700002)(54906003)(478600001)(36756003)(2906002)(86362001)(6512007)(6506007)(6666004)(186003)(8676002)(8936002)(66946007)(4326008)(66476007)(66556008)(6916009)(41300700001)(316002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6hsvvPuNnA26Z26uHGLUIVrTbnjlsYcnHiWMp7qeODOMaDkRk4vg6MH5HDbL?=
 =?us-ascii?Q?ozPuvzsBGWVNlGOjSW+YXICl7MtjBqnmrsf4silYTJsgcVVKylz0MaUyOImO?=
 =?us-ascii?Q?L8b8xKic0WMMSvf1jErPOj96gZubOSOSdNdy6Jnj5WwfosFEYr3l3AUa544e?=
 =?us-ascii?Q?u5qnXhi28ypVccBzXW3K4mSy4Ll0gRInEo+kK3aRkplb9NgWVDbDeL0cz/30?=
 =?us-ascii?Q?8q3pGw0nDzy5aDywC4Ey0V4V96LZWbTUBYwYfWPuSxkMf3UAMyVzvRm1d+H+?=
 =?us-ascii?Q?hHMO8s2AShIms/Qiqf+C3/1byIibiiXgwlqf3gMvnP3t3s6F8wrohu0u5PqX?=
 =?us-ascii?Q?OhyrWy5wWcgEabzEES+WV3XU23dtUesAf+1rqzgEvpIf+oP1n+MyLZFLZ891?=
 =?us-ascii?Q?73nhw0lFVNrdHCTeBhUMVlQ6eCWGQpwnAIRpLSbN1rKU3OHVrzXrrIWfKUdd?=
 =?us-ascii?Q?EkYYIKG5mWT1ixXRxqRAaAu+X4DKw4Ngay1XhkyCfWh/36aZU1R9E6+ssy1d?=
 =?us-ascii?Q?DYGJKzwA1y7TYnScYgTGEEmwgW1apyf0GtXnMRPao90zZUqhONpWUiqf0zOE?=
 =?us-ascii?Q?iM4WTwIP7lTKGtOPVo/7rVVKl9ky+CpKNwYL9eIlCwxnL/ECRrwaU1mWMQWh?=
 =?us-ascii?Q?/oTTLXkIU7sxylJqKeWxwb3HpFU7drIlzTFxZ7tn98lBolBLjqwThjz3+nhc?=
 =?us-ascii?Q?bCUn09PT+wVuHah/EaIxM5VckmzAlcIz2q0C/ekzSvBepaLOJoCPAYy3wT3n?=
 =?us-ascii?Q?O8GAJwBSiqeV/qBN1aE9hQ3V1rEysMQOQzONA19aA5zTTXmPLgNtDREI12EQ?=
 =?us-ascii?Q?FMqco9EBSpYWjp9cyM7iK+Yrxl0PlLbGNVCFHoSRO4/MIZtD1GMlPeUgS8Yq?=
 =?us-ascii?Q?5qpsQ2JFkTgBLakPvNYS3qK0MOul2Rei4XZxO2Is5k78m4dJ7S1p8cbR16gt?=
 =?us-ascii?Q?+1xmtQU/T0XsBQ5K35sqLQ/kbiemNExX9y/+xxbgleCTIIEbYjSjZ3X7Mn+0?=
 =?us-ascii?Q?CUFVY8iVXT1mFnxds0e5rnnEzOJ1TWyCT5HDT/73h38iT+BK/7AatKh+To4k?=
 =?us-ascii?Q?tVkYs+aa+IE7HsQ3psLWgIbmN9b+N6zK3dMa17+QkgoQHkKdJLZQNhEC1b23?=
 =?us-ascii?Q?U/T8CWoRlfSbKwG7p6IRZxKZvIdasoFVwId0z33gq9SwJBgY2A2uAJKtqQAN?=
 =?us-ascii?Q?ALVbd5BBmIHBOjpcaOWvG5izzH/9Tm6c4oDXMi0YvVr7QfH0qXhBRhOWuYdv?=
 =?us-ascii?Q?4M2SxLS/1CBWGVbfbCU80Jfsqh6ivME8pzH4jw656F2iLCBD4ZB9VRb2yG6v?=
 =?us-ascii?Q?X5FGn/hHTR4k2lFc8Xz2zxyhhGou78q22YeqKVSsx6jOCFJEygI0lNognL+S?=
 =?us-ascii?Q?rK+cQ9CK/sC9A8nfmyZCdlWQCqhlNfbm+ILjyLqAeXOlwE7VLOy+on3iSFvw?=
 =?us-ascii?Q?uSN93sb4/iGftmG7hiuKcVoIjlvckGp9jVTkSq3Lcc+c2q7OEeV9ubYp5GSN?=
 =?us-ascii?Q?tbaWNpnRhpwiKhmoC3aPbde7FCMifUHS0kv5TinyQ1/ENXIhTnjRmY5iztrP?=
 =?us-ascii?Q?Qhfv+APaVnjTEQEVjcVKLb2fxyJtvYxgfNTxV4iLfwFY4OgCCN++XkRH9a2l?=
 =?us-ascii?Q?Qd6G73L9XT8OlnRBemUo3mN/R8MZvkYlob3YISxeLC2k148xr6AI4aNp7iIx?=
 =?us-ascii?Q?n2iykg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f829a2c1-a407-430a-3543-08db5dc68df1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 08:52:37.0620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: klRf8QjjLfvsNzqr2A+NS8PhMTtbQUeuoqU6xA/VqiHMtkz6dVNi41q/J2E8hO83FPA6YzkzczC+HruJ6sEjfs6QHy+9Nyf7jtZyc2xjK+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4808
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 09:42:52AM +0200, Maxime Chevallier wrote:
> dwmac_socfpga re-implements support for the TSE PCS, which is identical
> to the already existing TSE PCS, which in turn is the same as the Lynx
> PCS. Drop the existing TSE re-implemenation and use the Lynx PCS
> instead, relying on the regmap-mdio driver to translate MDIO accesses
> into mmio accesses.
> 
> Instead of extending xpcs, allow using a generic phylink_pcs, populated
> by lynx_pcs_create(), and use .mac_select_pcs() to return the relevant
> PCS to be used.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2->V3 : No changes
> V1->V2 : No changes
> 
>  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   1 +
>  drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
>  .../ethernet/stmicro/stmmac/altr_tse_pcs.c    | 257 ------------------
>  .../ethernet/stmicro/stmmac/altr_tse_pcs.h    |  29 --
>  drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
>  .../ethernet/stmicro/stmmac/dwmac-socfpga.c   |  90 ++++--
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c |  12 +-
>  7 files changed, 76 insertions(+), 316 deletions(-)

Another nice diffstat :)

...

> @@ -443,6 +454,35 @@ static int socfpga_dwmac_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto err_dvr_remove;
>  
> +	memset(&pcs_regmap_cfg, 0, sizeof(pcs_regmap_cfg));
> +	pcs_regmap_cfg.reg_bits = 16;
> +	pcs_regmap_cfg.val_bits = 16;
> +	pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
> +
> +	/* Create a regmap for the PCS so that it can be used by the PCS driver,
> +	 * if we have such a PCS
> +	 */
> +	if (dwmac->tse_pcs_base) {

nit: perhaps the scope of pcs_regmap and pcs_bus could be reduced to
     this block.

> +		pcs_regmap = devm_regmap_init_mmio(&pdev->dev, dwmac->tse_pcs_base,
> +						   &pcs_regmap_cfg);
> +		if (IS_ERR(pcs_regmap)) {
> +			ret = PTR_ERR(pcs_regmap);
> +			goto err_dvr_remove;
> +		}
> +
> +		mrc.regmap = pcs_regmap;
> +
> +		snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
> +		pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
> +		if (IS_ERR(pcs_bus)) {
> +			ret = PTR_ERR(pcs_bus);
> +			goto err_dvr_remove;
> +		}
> +
> +		dwmac->pcs_mdiodev = mdio_device_create(pcs_bus, 0);
> +		stpriv->hw->phylink_pcs = lynx_pcs_create(dwmac->pcs_mdiodev);
> +	}
> +
>  	return 0;
>  
>  err_dvr_remove:

...

