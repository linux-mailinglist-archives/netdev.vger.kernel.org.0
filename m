Return-Path: <netdev+bounces-5302-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46E5D710A79
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B374F1C20EAD
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 11:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294D9FBEA;
	Thu, 25 May 2023 11:02:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D83D303
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:02:55 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2131.outbound.protection.outlook.com [40.107.220.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA3C5;
	Thu, 25 May 2023 04:02:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dxq17ZybKaHYCvb0aWq1JL3/PJNDxy5I0UswFL7zkEJo7B/cvQmVETrJEwCwL/iExoVBFW1xk7ofONVr+ShLF7qU7GNgmOEteRy2mu5ru9nnjAueAmWflNnQdc+BX9Egf8lBWB3y7/o3BPPQGJbKDZhkc6RjJYQ2jtXQKA26XyMZWHmFADDEN666vsbGw5hlSZxFJj0tZ37Q5MAX3SvlTYEiog4EG4L0DZ+bMk+Hrp+ynrw7pLmTOBLDuvgEo1DlEkhpX4pH1qS4/6npxmpu0a0SWOYCiQFZnTQTMVm/eSpaf4M3ucVsD0wJddmLOMHuR+fqwCQ1Zs2PttsdmdMh6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGPUARBYdY0hi6FpaisPefnJW+Ybufo6DUR65e7s3T4=;
 b=HuHbaudmsxepafwy+17/Tx+ap5kF+XgGXiRJThYe9jWv4FJjGRzY2JUjakmgAwy5GxpvZnzYmtFgyYq43qUE2JsXlIySayjT77C6syYCvMi4PEUAe6G7dUXRzLMv1OOOHIX7s2TNTdFALRhNBfUk+pQo9GSH0UtYG5Ho6Yd8aIfIbJXUAOGnmidINSu18pwAB0asPYIUA1Wwp4PsvV6PLDTClg71Ypbc5TevnZOvoS0bAqadZNRBjknRSjCYJ9WwW96HxPZ68Bg+dCnrvx8zQ3qE9gGaWsw88zmfcUuCFXUhSgnrW2xgolPcP5Y0sibzZLtLHj4whT56XG9jdDhk4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HGPUARBYdY0hi6FpaisPefnJW+Ybufo6DUR65e7s3T4=;
 b=h/IY37LvztwXC7A9lLNF10MTA3k8uZFL5uLkAWq3+d3oAP85dxfffaoX4QiEy4dHS5n8oIW6YPhqDX8g6cnc4dwvMRNR4OSYMyC010klCxrB8QrgcrQ4KxO2q8l2l0QdWeoPMEEnXaZ5uXa5wbkH7JC2uDhpSOWLrcFYXyi0Lkw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SJ0PR13MB5676.namprd13.prod.outlook.com (2603:10b6:a03:403::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.16; Thu, 25 May
 2023 11:02:49 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::d98b:da1b:b1f0:d4d7%7]) with mapi id 15.20.6411.029; Thu, 25 May 2023
 11:02:49 +0000
Date: Thu, 25 May 2023 13:02:39 +0200
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
Subject: Re: [PATCH net-next v2 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <ZG9AT4EeCmoyN5N2@corigine.com>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
 <20230525101126.370108-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525101126.370108-2-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM4PR05CA0001.eurprd05.prod.outlook.com (2603:10a6:205::14)
 To BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SJ0PR13MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: cc028bfa-0873-4937-b56d-08db5d0f93c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1xPiAVa36J/DXO/Z/ehzhyWRNg/MP7iZutIT8rvvVJxZialuRLMSFCiJgKx8UHaogB6kLsf21J84sv5uAV6oeurbdL0rsjuqDDF+QuU6pp0Yn/rd7EGrDNCwN1olLE9u/2y8fp/6kxdaoN35RDwGzz+OJlp46Dd1CZnGC07dn/UaGxLA52QKshgWb4W4dr/W49Md7tNoMJfAjlhyL0cf6XHRxWMQwbnSm/QrjGtOC4AeetI+yqTcMdwQgwgqTwEptb3GV9DDI0qukZ962IJSWH7hoUdksvvAET9X05Q2H8Tl3G6mR0PG+raHeArGkmCMTTbvpsgC6V14mvtfQ6m3yQePDZSE0Hb3zOB1mq+DKu5nQ+t3zYNru433A/nYA3sFFGHJi6qLtj3czlnrRg0cIkBq4lvQ/xtTS9QEihu1hG7NMgorNQb4QIMw2DiJA6qLfSo6B2W9VHKaX9+aCfIWjePhVuUpJuE/J6HTTfufcGSZdkMiQwQU8KzUtsrKjn7Hgf4dhCTTK4E2Qz53u1HMUxhPSdi62br5geK/vpck1k5sCoMZDIcV/xougUfRDX+VUy2LEXRoivKlTeYpL5bjoJWrncEARrnXTAXE9SG/50o=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(346002)(376002)(396003)(451199021)(86362001)(38100700002)(36756003)(6512007)(6506007)(44832011)(7416002)(186003)(83380400001)(5660300002)(2906002)(2616005)(66946007)(478600001)(54906003)(8676002)(8936002)(4326008)(6916009)(66556008)(66476007)(41300700001)(6486002)(6666004)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7k0U+NOcAmt7eWaNziT5OtAFz6pChoFHzGjBQQuLQphHyXpO1L7MDLgf0sma?=
 =?us-ascii?Q?ogZL4Blr0jEKvcUzqvAweFw1TV/xtitVBDulRmHB6JEpC4O+YgebHpkEbSW8?=
 =?us-ascii?Q?+9LMd6TEenRvn13t5QO91LSDX1nj4lTzKXVkRcGcxyhmSLa25Oe9XtjvXJRW?=
 =?us-ascii?Q?fHJj8aiGO18OqKUJ5j9n3YjatDYKLcVGVgbEhnGXIzIpuuBtwWVeY58fYzak?=
 =?us-ascii?Q?QxLJJLjTmeEi2gm+FMgxXgiFuioT6E64atnHwMlxhxijkki0PV/DXqBcKVl8?=
 =?us-ascii?Q?L9cNYDl+IUe5WZrrCv73hhcDLqiKWGZ1cL/U/TyO8z+MnS6qn3/1BvSLl2NV?=
 =?us-ascii?Q?5JiJ45FYIx7KyVrmFggcYGW4gXBaZNtLvgcyuU3dNtl9ulX6QFWulCOc7u7C?=
 =?us-ascii?Q?ye1tXCKQZh6l4QzyteQ+rqWgrtg+g0UoaWTL6jRT9nd60NqyW6aotaG0j+0s?=
 =?us-ascii?Q?Mm0gzSlDXPD1FBRl1OHJpoVgAGGrInsoisTU8Eu54oeharCzfH40jjRBI6rl?=
 =?us-ascii?Q?L6gFqBSNLq2gq4El3HUyFP6xen+zJNqLT9kXrmhGB9MYOzkP04E0RkBL3SbO?=
 =?us-ascii?Q?AwAdTY9ANfOQF7axrPCyA4V/Y4mnNz7RpzgLdMwrUnTTyDwaHOEaOO/ZH3kN?=
 =?us-ascii?Q?7z6TaofbMWcj7SoF00RpKSv/epTkAxIfcyTJR0s+/rxv7RhNvXwV92TeZCsW?=
 =?us-ascii?Q?EjrfLmprnTWIkJtdJExyKWNnmfR0BI6YsFnAwcHrBq4thss/U//MIUpF1Rn4?=
 =?us-ascii?Q?QAhrfkb42j3zEcPzca5t+0QsnxTgWzpBQRCompkdEFrzEUPCzIOGm5iSx0g7?=
 =?us-ascii?Q?Hos6hTVu0IAYGfVx7OgvTMrfpyO+1aC7nPg2iHO5mgGzXZmtM94VNwlBH7eR?=
 =?us-ascii?Q?yYYvezuVmi4PjFTP/1MMcRToiJPu74TlXcD3gclZUay0l9Yx5I3jTI/jphA/?=
 =?us-ascii?Q?V6K4dNnVB5pgUm1v/LgpDDm3AInu+uKWVwFht4LmZgIYoXSa++C4OibdKeTE?=
 =?us-ascii?Q?QhrBXIxifaLgULk0nt69tTcA2RM3cJzQQfE6a3um7TT+rb7bUR+ypy+CM4tB?=
 =?us-ascii?Q?LRqNA3EV2Indn0LTrRr9f9gnCgGb3Oy/xuqDZFtqrKgoC+CODyrKfX8xNfs7?=
 =?us-ascii?Q?6EbU3asXtj75yVlm9Ze+Rl/ujEtc8Z2rbWg5bChCm7iblHEbVYxEaEUwFC+r?=
 =?us-ascii?Q?um6lYsXwY+aDPq8ww/y4khtp/eqtdEVunD6kVo27HIDiM8FRmh0/M9jjaP8e?=
 =?us-ascii?Q?8foSycTrdLo3Jg6S1jhgQ8lx3EXZQyApJze+tRbYzVGtdAgyPKt0IQcqNqTd?=
 =?us-ascii?Q?lrFAnBPRm7xW+AIhPjxgsB1y1egarxofHNlUPfBoLod0rxJl9ZbdmGh7Jfqh?=
 =?us-ascii?Q?VCp8tVfWDiMkWDvwB9j1P+hr7Vf5YJv7FrYGPRXP93LY/eyCT/VgfN+tEqRs?=
 =?us-ascii?Q?8yfFNj2B47dpvIvvYnmlWAThcLrUVx1AA446KkpE5UZt5LPu5OG2eD8fZUmX?=
 =?us-ascii?Q?6J9+RtSgkvA5TYRmSgOj5wNKgMFWBbnZemLxj4bBeqd/GvwJ5hKt5WqbuOMx?=
 =?us-ascii?Q?cVbkfk+hZCRUTm+xg+pH7mRivtIyhrkprG7PZ9222IRLiO3N5ZIoro4NIcxx?=
 =?us-ascii?Q?FaIV35uSvZ/4CcX1kU27Sa9JRZ66lu9xOirtSvfCbEwOxPqYtjBb89n1HCy8?=
 =?us-ascii?Q?hMc+dw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc028bfa-0873-4937-b56d-08db5d0f93c0
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 11:02:49.1663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjRYaZypxr5c9JSYFkBYPdcwErarxYROuBit13nunTVOBrlPRoKrQrxcThTyTjn5/BueMLEJeqMWvWYg6Ic4NFVY2F68bj89Fb/n4G7iBmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5676
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 12:11:23PM +0200, Maxime Chevallier wrote:
> There exists several examples today of devices that embed an ethernet
> PHY or PCS directly inside an SoC. In this situation, either the device
> is controlled through a vendor-specific register set, or sometimes
> exposes the standard 802.3 registers that are typically accessed over
> MDIO.
> 
> As phylib and phylink are designed to use mdiodevices, this driver
> allows creating a virtual MDIO bus, that translates mdiodev register
> accesses to regmap accesses.
> 
> The reason we use regmap is because there are at least 3 such devices
> known today, 2 of them are Altera TSE PCS's, memory-mapped, exposed
> with a 4-byte stride in stmmac's dwmac-socfpga variant, and a 2-byte
> stride in altera-tse. The other one (nxp,sja1110-base-tx-mdio) is
> exposed over SPI.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

...

> +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> +					  const struct mdio_regmap_config *config)
> +{
> +	struct mdio_regmap_config *mrc;
> +	struct mii_bus *mii;
> +	int rc;
> +
> +	if (!config->parent)
> +		return ERR_PTR(-EINVAL);
> +
> +	mii = devm_mdiobus_alloc_size(config->parent, sizeof(*mrc));
> +	if (!mii)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mrc = mii->priv;
> +	memcpy(mrc, config, sizeof(*mrc));
> +
> +	mrc->regmap = config->regmap;
> +	mrc->valid_addr = config->valid_addr;
> +
> +	mii->name = DRV_NAME;
> +	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
> +	mii->parent = config->parent;
> +	mii->read = mdio_regmap_read_c22;
> +	mii->write = mdio_regmap_write_c22;
> +
> +	if (config->autoscan)
> +		mii->phy_mask = ~BIT(config->valid_addr);
> +	else
> +		mii->phy_mask = ~0UL;

Hi Maxime,

phy_mask is a u32.
But 0UL may be either 32 or 64 bits wide.

I think a better approach would be to use U32_MAX.

> +
> +	rc = devm_mdiobus_register(dev, mii);
> +	if (rc) {
> +		dev_err(config->parent, "Cannot register MDIO bus![%s] (%d)\n", mii->id, rc);
> +		return ERR_PTR(rc);
> +	}
> +
> +	return mii;
> +}
> +EXPORT_SYMBOL_GPL(devm_mdio_regmap_register);
> +
> +MODULE_DESCRIPTION("MDIO API over regmap");
> +MODULE_AUTHOR("Maxime Chevallier <maxime.chevallier@bootlin.com>");
> +MODULE_LICENSE("GPL");

