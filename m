Return-Path: <netdev+bounces-5366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7723710EE6
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 17:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EEF62813CA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:00:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3168168A4;
	Thu, 25 May 2023 15:00:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D664FC1B
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 15:00:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2113.outbound.protection.outlook.com [40.107.244.113])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFD4A3;
	Thu, 25 May 2023 08:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jwro4jZXykahkN5cb46VNLiPI1VJmVP1Uh/BYFTopbYJuZSI/NaxtSuPtyKpcCP15gctMtIlNXBpjLP3dTDOvX+ClNkVI09jHKK+/xFfZGoTujxrIqkhOSucLKXNpWxlGACUbhgaJNSH5qr5WkxpK58QmKicNKLg1fSwJ8m/KuRHvtuljGtt/6cu9OKi6D/Qg/8xRPA8Nfxcsel2kfnAnUk6QeMw7ApmJHNrPSqeLYdlUtcGOCSzHKmLDZhEV6Ths9MmGltmPB3DA9jJROe/GlFVC4Ike0188jnDTo8gRoY3uoB9UWV0kb0qII+iZ1s6ZicvhxhgbLYEpLcIgwM4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Afi5G8Q2daUk42/ANWx3ohh9fykAEEAoMPyrUMYorjQ=;
 b=kVTB+0InOqqsLHCo1IDd53/9WsFNGt3uPum5WTEHqufCg8k412ijft246+g0pLWqu5F2P07E970ke0nlhi58oyuowqWYr50InskHi1L7/4Ozp+Kuj/XVps6WWTRrVbvWAwA4XUbJbbr9wqw7OJVzVyHVHAoUjFVEx7biEyYHVK4WMfSydeqiVLjYijBW4kL3dUwoMTatwNptMAavP4XM8OepHtRhC94fs9jMkBmaVBjNtsLf4WtHGwlyudMvwReu2CogoD5LUR0eijhi15pIm4h7z4NdX7UGZmqXeooH0aHOzl0LMpDAZLKLwD+E5TsDXjLvW4MKwaNctluPjPwBQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Afi5G8Q2daUk42/ANWx3ohh9fykAEEAoMPyrUMYorjQ=;
 b=UAyCcJIMkFublK5kMMxnwm7EsToWeL9xWljp9mapoXScudY8o3w34sNJiGDz60Ml6M3sf/mUw7/wRI04kRwCLv9Dd4uz3aULj/6SXgDai2UoQsmgPSp7s+znCDMyy5yCybauuvUQbYjD2VgTvTCTFbBVb5ruVGmiiOj2VcqNWWA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BLAPR13MB4673.namprd13.prod.outlook.com (2603:10b6:208:307::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.25; Thu, 25 May
 2023 15:00:12 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 15:00:12 +0000
Date: Thu, 25 May 2023 17:00:04 +0200
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
Message-ID: <ZG939BnbaRP4GiI4@corigine.com>
References: <20230525101126.370108-1-maxime.chevallier@bootlin.com>
 <20230525101126.370108-2-maxime.chevallier@bootlin.com>
 <ZG9AT4EeCmoyN5N2@corigine.com>
 <20230525144359.0cb16996@pc-7.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230525144359.0cb16996@pc-7.home>
X-ClientProxiedBy: AM0PR03CA0093.eurprd03.prod.outlook.com
 (2603:10a6:208:69::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BLAPR13MB4673:EE_
X-MS-Office365-Filtering-Correlation-Id: cc6c601a-d5b2-47c3-1d7a-08db5d30bd32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cLCKEOEIVyBaxhIztQWoHWVDU7Y07jtOJ+wacEqmIqF/DgFjiDCUlyToM6qa0/27oXDBTVT3xXhbQX5VtVr+bxLTZpjVij9SqYBMf0PhsJ1PbUHklx8ni4oruDV1u+b7negDjIBU7GgBGLIyQr1mu7IJfgEFEdsTHHDLJU4BtR6TayqgzehPz7e3nMHevh7zv+h5rv+WULdYYeFecFd3aPi6rXzVM8eMUxbe+zO+Ik07Ys3pN+o9E23VMhsvhiKNCg13WIN9GlJd7U4NGR/0JIDWTD0JnGXbDOCdXibr/5+D2oGyz+3D14caQdKbx2hRNRrBhxKkMgvBnONOIzFABBC5lY/daE62nsb0uzTfwCp2pcqIxhkUckf78zTgYCcMpaz6CRu7XTY+2+eJy2cBGmpRQJFIRr/X24vTcO7DMBti9A2rw8hD1DvBT0TsavMzxIY0IYpJ/XshLbUQo2thNYDDtQXiRWQYY09rHbodRdcVE6aym9jRWveTy6L+iEMjzzmFlHgw7246jxSE7X8C59UAx5SAgsRXAkfNadbzrPDiKBFUFlDXPRfX+bnM9/+s
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(346002)(136003)(376002)(366004)(451199021)(86362001)(36756003)(186003)(2906002)(83380400001)(478600001)(38100700002)(316002)(2616005)(54906003)(4326008)(6916009)(66946007)(6506007)(44832011)(5660300002)(7416002)(8676002)(6512007)(41300700001)(6486002)(6666004)(66476007)(66556008)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nV8isRmATYhMxQjQvpoFY8J8RrPYvwoKw+dAuGxIr9mrL5zIO/aqEmEYgwdR?=
 =?us-ascii?Q?11ulS+JNGdlRK2xY8So9DgH7+KWS6T1pqPxxrlZOKJ8GXHS1rpV0Wxwz0RFa?=
 =?us-ascii?Q?4GAaLEl443c0SwxhEjegfzWizwguM6kJUPhoFfo/kUVr2PAKzxN8VqnULmJS?=
 =?us-ascii?Q?zvnf3r9AhXeZWWB7jOHvYU9WnrhRhJq2uTBDLf0TD1uloYRswcujztLhNXUZ?=
 =?us-ascii?Q?r0eKGcjQBMWbfoKarVxAm1AF9jCtMZ3l6cEyEId9e03aa67v4FaxTm+oWSFL?=
 =?us-ascii?Q?jciVP95KnO57WJd+W3iRVuCqfqF0nLdOaZIjqi5arRDY4ep0Vd7IN/a2+2Uf?=
 =?us-ascii?Q?M64Bs3nvZ1+gVfeIEdzLfvhO9kMI5H6pOMUeoS0wuVz6rSkiNfPARcPfl0P/?=
 =?us-ascii?Q?XaslpZ4fRUPH9tW2dY1lL/CWtaPLuT/vY8K1zfanoS4No/m5n3LwgPEO1MQJ?=
 =?us-ascii?Q?bSRc8aIxiAOzjp8wq3+7jGEXMJXgi58GgVyNfR/+tY/7148VM2vqtgL4JSoX?=
 =?us-ascii?Q?a6g5KLA4Cs/dyIY9L68I0pcaYcwf7xzYabtNEmrwCKcgSCOJ4uktvsr+o+hj?=
 =?us-ascii?Q?iGI+xJPL8zp+y91jEeEickz3I/FCrImJnZ/cOSQyXv1MW4egzlBr6Q2J+/Hi?=
 =?us-ascii?Q?kUFJk2TRzKTkRHnTMRnIcfpju+JAiiq40Rp1R1qa65rpqIB1xSoNeHytY1Tm?=
 =?us-ascii?Q?N1l+dUSd99SOBQMcfujAj+qt6a29kQtShyvxSlWTiSfdtAb5C5WXvr3RaG6Q?=
 =?us-ascii?Q?OPi1jRS+/0Yqqa/oBh1qfTxJlnOOxFymQUNBbuLp9wC0uC8C9AGPgwWbOvC1?=
 =?us-ascii?Q?aczDWIJNy0nphOVL5KagAsM2X3Ktt5VfV8l3f2FdzdHC4I7jHvoGpZGnU6XW?=
 =?us-ascii?Q?4jiTaVueTBRzfu3Sy2dwqWigzIPbiInr80wpaz8fYo2ASdrE1Dyjh/jpT2wm?=
 =?us-ascii?Q?kQ6tgJGti3fZik/s9ibL/GDTsCxiIU8NQeATlKa+yL65FFsepb+pN4BNK2ph?=
 =?us-ascii?Q?Y6NHXtmyVoeQ2HAPV6Wnc/uXtIfNFgV8KkckjoLVfN7ScbXIJiLFkfotzxEd?=
 =?us-ascii?Q?dimRcy4ACl27sQMbdu2AXeupm31L5QbYV31j14N+y6yaCMA0zUv3FZFOscOP?=
 =?us-ascii?Q?/dgdgqOCk8Ujxh6qBneuFqu0TFJLvY5QJfkWzTnBSGo/CGCuSoRByTz9Yu43?=
 =?us-ascii?Q?f403IF1MqqpU3w/aN1Zb0XrSkJSo7JxpCBw3BcX53+28wyZDlQVbN2zRe12U?=
 =?us-ascii?Q?xByjp5CzHsaDp1Yb9yntWyPrHQp/+vQDYP+XRR7etVnpBTx4UZlAHHFNX7+o?=
 =?us-ascii?Q?1lG19dxoSBWpyQBD3EjN783GjRu3DFQNdghQercrMKrG0Umigqu+fXBqlK8A?=
 =?us-ascii?Q?fX1oh+hrztasQPs6jqHz1VcRHR4ntDoNBoQJUsQk3x6Zeo1mioIt6wHTaqVC?=
 =?us-ascii?Q?sYTUgE/Jy4P9hwDl/+3eief80aIvGx5KMfuldJK0hwivJzG5a4af2aUenI3r?=
 =?us-ascii?Q?QRClDv438tm2JDLqj/Fdns/a52XwUtZyrj56ryTZePgwTUnXjhSZKgRLFVZN?=
 =?us-ascii?Q?HdCYUeOUslLc1OOxjYwX+TPkYvL72x8UUhGPEAjESuAACQmJLbNI6lu4EYfb?=
 =?us-ascii?Q?x//QtjiqQCpCFfuYXArd8yXevvHL4ZNi26Atdi8dZ28QFa8LBR4V9Y9gqWmV?=
 =?us-ascii?Q?SKDm+Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc6c601a-d5b2-47c3-1d7a-08db5d30bd32
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 15:00:12.3675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lyiQFVrx0szKERgHHm0Xhc3Ncem2nmr2UnJFGxMn/VSuU7oj2EhKVN+2Iuoae9oHYzKLx9sHpbSbmYrkTVgyPYAUvf7sTVSlCxCmXk9ZDGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR13MB4673
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 02:43:59PM +0200, Maxime Chevallier wrote:
> Hello Simon,
> 
> On Thu, 25 May 2023 13:02:39 +0200
> Simon Horman <simon.horman@corigine.com> wrote:
> 
> > On Thu, May 25, 2023 at 12:11:23PM +0200, Maxime Chevallier wrote:
> > > There exists several examples today of devices that embed an
> > > ethernet PHY or PCS directly inside an SoC. In this situation,
> > > either the device is controlled through a vendor-specific register
> > > set, or sometimes exposes the standard 802.3 registers that are
> > > typically accessed over MDIO.
> > > 
> > > As phylib and phylink are designed to use mdiodevices, this driver
> > > allows creating a virtual MDIO bus, that translates mdiodev register
> > > accesses to regmap accesses.
> > > 
> > > The reason we use regmap is because there are at least 3 such
> > > devices known today, 2 of them are Altera TSE PCS's, memory-mapped,
> > > exposed with a 4-byte stride in stmmac's dwmac-socfpga variant, and
> > > a 2-byte stride in altera-tse. The other one
> > > (nxp,sja1110-base-tx-mdio) is exposed over SPI.
> > > 
> > > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> > 
> > ...
> > 
> > > +struct mii_bus *devm_mdio_regmap_register(struct device *dev,
> > > +					  const struct
> > > mdio_regmap_config *config) +{
> > > +	struct mdio_regmap_config *mrc;
> > > +	struct mii_bus *mii;
> > > +	int rc;
> > > +
> > > +	if (!config->parent)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	mii = devm_mdiobus_alloc_size(config->parent,
> > > sizeof(*mrc));
> > > +	if (!mii)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	mrc = mii->priv;
> > > +	memcpy(mrc, config, sizeof(*mrc));
> > > +
> > > +	mrc->regmap = config->regmap;
> > > +	mrc->valid_addr = config->valid_addr;
> > > +
> > > +	mii->name = DRV_NAME;
> > > +	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
> > > +	mii->parent = config->parent;
> > > +	mii->read = mdio_regmap_read_c22;
> > > +	mii->write = mdio_regmap_write_c22;
> > > +
> > > +	if (config->autoscan)
> > > +		mii->phy_mask = ~BIT(config->valid_addr);
> > > +	else
> > > +		mii->phy_mask = ~0UL;  
> > 
> > Hi Maxime,
> > 
> > phy_mask is a u32.
> > But 0UL may be either 32 or 64 bits wide.
> 
> Right
> 
> > I think a better approach would be to use U32_MAX.
> 
> I guess ~0 would also work, and this would also align with what
> fixed-phy and sfp do for their internal MDIO bus.

Yes, I guess so too.

> I'll fix that for next revision

Thanks!

