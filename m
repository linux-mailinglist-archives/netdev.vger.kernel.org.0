Return-Path: <netdev+bounces-5147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E6A70FCDD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAD511C20C33
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:41:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAAC1D2C5;
	Wed, 24 May 2023 17:41:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92C538B
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:41:56 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2057.outbound.protection.outlook.com [40.107.8.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52161186;
	Wed, 24 May 2023 10:41:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEv9iwP9mQMq3ZVouPRVNoJIyqwfXl3nI/fh5MgY4YZ042udbAKtBbWT9fXucxwRs1PW53rxNA5VVqT736p45gmSai4OdRVZuNjIfIoEv37cD6Lj7iO603zrjwVfwEn0Twsq3EtzZ4br5zaUoFz6Tsqxp/HQYyK1Fov8VjbZRZ6FaLgPKHAHjiCC129WNvFe5TfrWJBbrLhgSMW+Y0QFIOutFsf6QqZ+HiHnBeVQm0x042Ch2JHjTlUtykakf01DO6xJfYcF7Ga3i4hCJNdOwbx00RdwoC7ZLMrccxq2859vRMJhrqX0roPlNuLOgF+nhabBZI2RVN3hUmC+9ApZEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO3r5/vabGTJDkPD31j0/egzfOAkHFEjpUqIsoYPRp8=;
 b=BRwise9i/EyKVq+aX6vp7rytPpMLaQYAV74Zf3+yWThZBJzhaiKlwDJPN+S2z7ychEXLxvEjAcDNjQj5RwpFElg30xcRDAvCLh4/GQw4BkIQO+9JEZbE2Wg7xPxN1mht57kuXlmaKUEyb7LL2W84e943tAxNfFASopK5rHXCMBI1UA2PUNYhMMO8a2xLaeSF5IypM89YAXgOdTt6YBcIV9Sh7XZ0+vUKriJmrx/HMwHLHIPs4gMmBQKd6u+JoLiYvKEM5VMgCGeO1rZTvxGXhElL67JEpY2w/JLbZkbOYK0x9TBaJAkG/nGu5uzxwwyG2UchkenTyzq5S0DbROf5wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO3r5/vabGTJDkPD31j0/egzfOAkHFEjpUqIsoYPRp8=;
 b=fcZuEOs672PQhZd7xrFEe0u2A+a2n79S263pS8OPgzsiUd7g/00RvXTA53p5e5/W0KwIxoOllT27TtHXFk2N7/bl1e4o0p9qzDNljhVYvMwLAyI9vDI0lGCeha+vzIN4rLDy/6AfV469wQ6QzkAmR/qEUM3WVwGhgRlgyyTzvYg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by PA4PR04MB7693.eurprd04.prod.outlook.com (2603:10a6:102:e0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 17:41:50 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::b027:17aa:e5f5:4fea%6]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 17:41:49 +0000
Date: Wed, 24 May 2023 20:41:45 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Mark Brown <broonie@kernel.org>, davem@davemloft.net,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexis.lothore@bootlin.com, thomas.petazzoni@bootlin.com,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH net-next 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <20230524174145.hhurl4olnzmfadww@skbuf>
References: <20230524130807.310089-1-maxime.chevallier@bootlin.com>
 <20230524130807.310089-2-maxime.chevallier@bootlin.com>
 <8f779d98-d437-4d8b-914d-8e315b4aca17@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f779d98-d437-4d8b-914d-8e315b4aca17@lunn.ch>
X-ClientProxiedBy: FR2P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::12) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|PA4PR04MB7693:EE_
X-MS-Office365-Filtering-Correlation-Id: 549ce354-8bfa-4604-eb50-08db5c7e270d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UCj8em0Ad6jE6ghNCQm65l9JH7h6OIi4f3GAbRz4lTB+scDtm+73bZxEPxo81YnKjPMwAdP/8NQ0qhKo2uHzndp4GSnWIv4XSdEgiDGR8mSs7cruVW+rETsh/IbxV3XU11d90e4ii5wtOq1a3082C8AcfFaCiEwLbWyUbiibZU31UgSBTxafgg3ADEEZ/EW/zAWyn3Z7OvkYHSZFoZQ/54uXN6zrvBNope/WbkwJHeKZN3AcVcbGQ8hze6bZBo0XvuHjrV5agNraYyMWsoCQooyvY3sE9L6+bYVzOOuK/Uy+JAc6gcwHa0r/LsZQd6IFmcO4Wsh+Rd6QPmkPQfj56Sv/70Ot25bFwT0eDGpBvYMunw7145zi2q3a2PR9s4NmWY0dH3zJNschPjhqCB4hKjbak3pLN360jOkLgGeuEL/zMlZlmkCG4YUsVdUZE7et3WYd/soEnnZg+YC9RHxpJC2OWNgfZfp17Ice4JmDSM6S5J2QEbuCKCo418mTvZJMB7CwAbX0K9XN1bVYDCUOzb3cwN7ax+8a0KmVlKvPJ9i+DKbXae+Hy5y/pDM55YK3
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(451199021)(186003)(9686003)(26005)(6506007)(1076003)(6512007)(7416002)(38100700002)(44832011)(4744005)(2906002)(54906003)(316002)(6486002)(41300700001)(6666004)(4326008)(478600001)(86362001)(33716001)(6916009)(66946007)(66476007)(66556008)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1tn7cgTzUxik1VbrcmBKl9brn5rIJwXCVL3tOtdBYSgUx8qNRUevzIX5MYbw?=
 =?us-ascii?Q?fUprLunGhGrWc4WJhd/KHWve8eqxAfMh8dY5euS8JubmW5wRb5VPWnBD++Ns?=
 =?us-ascii?Q?x3Vzw3w0sN0phjjEdMaF2Hh3ZZ78d6YBAauIdKxbt6r47a6IuSkG3aQJnQak?=
 =?us-ascii?Q?H67I6CGJvqvfmkztn+WeXsx+TJXxgN+VZ41EucZBh/Xq2fURx/bMl0RS+hXn?=
 =?us-ascii?Q?AkQD6k5g+HZSAK03kDJtFy9W+PYEZNBpk5EdghiV5tYZMx8Biq7o/ae5D/ue?=
 =?us-ascii?Q?U++qhl4p2TgDoZgZs7xb9ir5X5gOC3kX4xKckok8i8mLu2rvT67vz3dbUtH1?=
 =?us-ascii?Q?ApxKDuEXfZHTWClNlVxXzDYwI7mEArZUGIxTlR53yX0G6yuhvqwMiZjAVZET?=
 =?us-ascii?Q?nuULdvZd+puRwiyqyivEzhJ+7xFnZY6pnLR/57eqMAYpLBxjKoMxBsHT2I3i?=
 =?us-ascii?Q?Bu3oIo9vS7F9x8ePjKlvVm2/76b6nxR+mIDqXKDwGbZB9pYevuY19Lfz/aOu?=
 =?us-ascii?Q?8cHRWmTTyAWgGtuEg4VM8uaStkThAbnwGwVWwummonNvO4N5tqZIjZtDOhl4?=
 =?us-ascii?Q?RMlZNq9h8RyetpJGDA75KjGcW14JY1Zuowh3OZ18/09V3EVrwfO0iqLs73Gx?=
 =?us-ascii?Q?jveY981n55X2b00i1Har6u8EGcTlroSXPQdfJ+uGbmNEIBI/CWRmlXVeMjNe?=
 =?us-ascii?Q?fJSGPSyBMi8S3kwSNuF2vnN4JJxxmVzQoQDcseW/Q7w2e7ZV3E2W16Gy0+86?=
 =?us-ascii?Q?LrldjUYH0Ru4i8UOCvDHChUqm+N0CGUW6yL57ZGvngOTMdRl6sAcCYosqD6Y?=
 =?us-ascii?Q?I2rmWIh8UqKN1Quw6mZo/krSU5kY2xLXp/W4FaAsdYJJW34lfhBejZ9jenpA?=
 =?us-ascii?Q?uN/CzULVRe7ddBLjEo+kuDC0LvNfOWGGolBu9yFefT2JUT0JsFfpbidtQbSW?=
 =?us-ascii?Q?N1B/VuZkk9TngHthYK3A0dw0tCULk/O9QogKeV56ldh6jSG7aelKsn+GD08o?=
 =?us-ascii?Q?OQej8KDx749hj2WxZYnO9w7/5zaKzs1ReZbMMiUs0SuWIB0/agHmTNTrDV9y?=
 =?us-ascii?Q?RbDFqoOubzN96qp/PhBJ9Dx+O4TL25NxO82Z8Xnwa/irihQrFkAm1yxV6MVa?=
 =?us-ascii?Q?ZCSObBWHRrKaGb1F3LJ+bjya7HJ4+559Rpe7e/SiEHvIZZrpJwz4qg8BgYnt?=
 =?us-ascii?Q?KUXTqfaFhftCfMH5yel/Xf4WuEvFmeFL+b5T/6aV421U6UwEHwxYkeEwZwhZ?=
 =?us-ascii?Q?Kbq9js67ieUV0jZyOBmtlrhZIMFS0i/Sy1Ua7MlGOnrCubdlE6lO9y7/zuH6?=
 =?us-ascii?Q?iT7bX8cQTTQ4P+krwb0IbA1F6b+aPRdvS6sKjWYnRKoGgGHL/JTznggcwOXu?=
 =?us-ascii?Q?rTwOk1YYLTGZpgLXF4aIx+jMAkZDLUmK8Vn3Wbp90FDexuKTu+yMdobae6yx?=
 =?us-ascii?Q?cFs80s9nUV6xhMtj5Pg8JxySpxhEhYSZXWLh/SYAWgkWGSTcMROtsrKcGHbE?=
 =?us-ascii?Q?k8Kmf+Nz290dttpzs+vB85j6ZLln+lvTTYe7rDfhq0SvfGLPpGCndSWbRRQp?=
 =?us-ascii?Q?xCBSwQZINfZugWPkzz43UqckfGbc29DJu+3ZEik0Vnw3Ked1cVt25Swtaqe/?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549ce354-8bfa-4604-eb50-08db5c7e270d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:41:49.5968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n5/iuawBkst9NsUgwWxRgd6XRyfVNkNTejVrbrkAD16zczqNjnVqWNnJzy8LasRIe58jJS3voNf0zVR9geUdog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7693
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 07:30:51PM +0200, Andrew Lunn wrote:
> > +	mii->name = DRV_NAME;
> > +	strscpy(mii->id, config->name, MII_BUS_ID_SIZE);
> > +	mii->parent = config->parent;
> > +	mii->read = mdio_regmap_read_c22;
> > +	mii->write = mdio_regmap_write_c22;
> 
> Since there is only one valid address on the bus, you can set
> mii->phy_mask to make the scanning of the bus a little faster.

Sorry, I didn't reach this thread yet, I don't have the full context.
Just wanted to add: if the caller knows that there's only a PCS and not
a PHY on this bus, you don't want auto-scanning at all, since that will
create an unconnected phy_device. It would be good if the caller provided
the phy_mask.

