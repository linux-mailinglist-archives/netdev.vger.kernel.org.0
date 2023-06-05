Return-Path: <netdev+bounces-7891-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0EE721FB7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 09:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC3DE1C20B19
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 07:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC554111A8;
	Mon,  5 Jun 2023 07:37:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98244194
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 07:37:34 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2107.outbound.protection.outlook.com [40.107.92.107])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D60B7;
	Mon,  5 Jun 2023 00:37:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfVufm2Un6DDapxiDJH+xyvqN7RihWr5VzisZTcDLodMGEXYB2tw8EHQzvjoMc+l0KZXVKVkhX4+l5btRrsR/wekOkvZcckLbzAVOiFqjjR+V0UhW2xTjzTzUj3uPW+FeaIPupiYgQbzaSqV9qUFdbFxd6YnknzNB//tu0AsVsIqz7jj37nBB+wq/ilFqpjI4IRRptjgv5l7MO6IYd5Et+Ep4gJS4po58tMRL3FpJ5aMPWxvllzVr7ZS9sC7xmqq9taOcv0ekdmcfT7KP6CxVNN7FF8aczVe28aFr4IUYAMYJUH2rhmtoXhcoutVu9X+HYjb4xuEDOw30o/A5Cazbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RwRhV8Iim2NryPnlibdmXO3oxy3hczfxWqCQNy6HJIA=;
 b=G//Qh+e02qixuE8WgIMg0nvTieXaWNEMJ+uMw2aIU7ugx4gPtiEXEeL+574j6BufObQCk5J9JMTiz0CKe5LpfprJZqyYNBNrxgYBYRBDFWrSNquaOyiPQ105EZSuty40xK0GE7uaEv4YUdBBJtpLsmBRDFk7gue+oiPthC+Gn7aHo1q4Es/i1WuIVBcNlbxuRYhPVxMx/4K6yMuY8i7r5bo9mvR5t2uy4MmNYJFqzCEe7L3k8IZ4xI/COIP0afoFCyk8lc7URbEHF+KmOKufOvqdc6RYLaEMfWHKlbSU7q4sctWwK38gssz7l6dwuQDBWIfhcoHcyUmGcvwtX6avow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RwRhV8Iim2NryPnlibdmXO3oxy3hczfxWqCQNy6HJIA=;
 b=mO87F/A0uJIQej5tPisT2gH6NaW5lnsWqjk1Ld4m3ZtlbOEs/FFk7MHZGOrazQ3WmpR2Bk6cImspZKtP19rt91OUgd//c9dl6QOwKIXnGWHHrVpz66s3zsV4Ql6jBEHbVVBuUwZiHYY4y75FTLranjlpbkCsVE/wmLDIs5/Hb6M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5761.namprd13.prod.outlook.com (2603:10b6:510:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 07:37:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 07:37:29 +0000
Date: Mon, 5 Jun 2023 09:37:21 +0200
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
Subject: Re: [PATCH net-next v4 1/4] net: mdio: Introduce a regmap-based mdio
 driver
Message-ID: <ZH2QsY1bNAVhY1Jp@corigine.com>
References: <20230601141454.67858-1-maxime.chevallier@bootlin.com>
 <20230601141454.67858-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601141454.67858-2-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 1299758c-27e7-4f43-e5e0-08db6597b75a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	bPGlO2Gsb+IFbIzdtcMDZGLmW+b3CMWxokWzHCA2Ypf2V/z5l3mSXV4D0+lNINOKtqDZxqb1ifDJpdBgpDxF207VenLl0Ee5W+8M5d3eGybLxziysKesXaBnzujFYUyJeSgvbUmD7KJVseHH+Nj0br0G4H+ZsDQdIJcCqZ9a6VqWqnvkDyl2ltUbCki0H5d/sV5Qge5lZVzXHFjXmV1jFgpMGEzOK5TRG8wp3EmFO5WX5D7yDmJMU4lWJKZJ1P2Y5IONccXS3CW4Wh4i+0d0AG1Gjbv8v21uG7lqmxR7lnXHsiBj8PzB/nwRDyocOiDW7esuhsCM0F/2V8mIbJrB2cDSm3lOcJYnqjxfjips4Hu0ly39le2AEiu5O4Zn7gULnhO12jmIuUqoSbSHRwOHgVjjK8ovNnlQpdv4fqtLGTvpGTU9+gcVNX/foy9B9NCuTTBlva5sSZUn0z3sAS3gCrHrjpOUIwBbVAoPTSWMLjZWm25CoD1H/Wp+hEFhCiUOzzEmy6iBcHxonDbK5p5EcyX99yCr2fOWCXEt+E/1cUzPuOj8gtgCLy8PrhvKunVImhZYzOkBIj/9jzoMTZAib6WxsP1eEvIQK46rvrORjqo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(366004)(39840400004)(346002)(396003)(451199021)(478600001)(4744005)(2906002)(36756003)(6486002)(6666004)(2616005)(83380400001)(6512007)(6506007)(86362001)(38100700002)(186003)(316002)(7416002)(8676002)(8936002)(66946007)(6916009)(4326008)(66556008)(66476007)(5660300002)(44832011)(54906003)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hSDf70eiFjjL2cu9FFbThTgVw+dxPZ5FdohqFgQIfGDw1idO3GxfENz+CTYN?=
 =?us-ascii?Q?eqXEA6dhUbnqyzQCUCDv6aqdFlx/4vbs1EwhWm1zAVCbRkxl0RuswgGyxlM2?=
 =?us-ascii?Q?DO+WbZECao8SpdjCHa+HuueFTSDgRq1jXGG9b/qhpPnfPceMtTf9qJf4+L2l?=
 =?us-ascii?Q?8TOvrx8KD/+7bSbqpbrqIZ05bu1fH134cM2nrFemcMpxZufT9ikiwnP7EpU5?=
 =?us-ascii?Q?RQoNXdotSkhko/56rMLExsK8EhgWLOlG3GhD+gEOt92GmJwiaIYLybKVPm4X?=
 =?us-ascii?Q?F1Hy1uKxNaa8WErQGkHqcPKv8CSstvGGZsmPoqs9pm5/ipDGpjVUG+5yZRaz?=
 =?us-ascii?Q?lPP3PIRiTrHy5YhKflnGpoVFUJ+9ftrXz5czrvRHJ4ezJAc0yAGU6Uvf67ey?=
 =?us-ascii?Q?xyVbGm+AKRAHDVBMxuh9rZk7Jzs65Bg0QSkcCxETw/i1aT/anHQTE2l9cBkK?=
 =?us-ascii?Q?GZxhRsJ784nS32WOBBbJnMQNpToIhUy3DpV3Y3/F5Oi2kxx3rnpkLpCbghTO?=
 =?us-ascii?Q?8w5eNAKRutlC2aPeERwgOuM5h3uV+2GTaMRmQrjXtlf4gpazsjN7UPKCIOtc?=
 =?us-ascii?Q?YT0bPFXvITZaFJtM+oO+LARSSQV4ZEo0GjujZm56npYFU4OQfcoK2a++TRlo?=
 =?us-ascii?Q?X4uXOQP6xGYIp/QReRMLPAmwHtt92CSitrvgojBt2xO8F46aDOQ17PQkWrQd?=
 =?us-ascii?Q?heq0s2EbLGZrASRqZSkJPl4UtgQyAgJb0X5bn8ott7wa0QEy/w7g0R7pdZNA?=
 =?us-ascii?Q?wqahlmPzHUi/jZ3pzEwEtsavzQ5ooeAuzYlvYi1zVyd8UNqaFY6BJh+M2Cbh?=
 =?us-ascii?Q?XHFFGFdhWbUNh2IMDCOb6xLy9cZz6/FeIgf/Ls2DwFhK14VnjiiHnqbeQQm7?=
 =?us-ascii?Q?skVqWSGQooGzuAg++n1jk3algM+H+8wAXj6RewBSV16zaZUkE2BunyWzAEeR?=
 =?us-ascii?Q?8QHh86bbvOKFVJlyPSKdjdy6t+9av4gfGuV2ponljd6eiiEbkxksk35Oaday?=
 =?us-ascii?Q?19QTbCSP79tnaeuRQjsWl/uA3gUkyzUjPAT1hnc2dLMqhDCUqP7rX5B4CgWW?=
 =?us-ascii?Q?Czz/YDUAiYkVNxrgOsZX17oLFaKL4SoIn3JZnQ2mT+rz0DMAnbjGDm4Y6NVv?=
 =?us-ascii?Q?M51Iyxuni7nqbdZNCeMRzksR0c1JbI9x3U/sOJYHR4eLdmbP1JB5GdPqKdDM?=
 =?us-ascii?Q?jSe9RVoRmoxRq8EC4umZm548R3XXYG0tBa3ndod4rtrQ21qvpGndHx1B01zg?=
 =?us-ascii?Q?KPIQaamKn8J4uvPshaB88dqBkvkUtKe9wblGlWGea9xpnhQDyN5P/UykuohS?=
 =?us-ascii?Q?coAWLHVQNazZkL85US8C5B+HIgGr/si+e8ERJVbJDtWzQ2DhdUQcZR6oTcLa?=
 =?us-ascii?Q?zvrEPfrCV42CTaBX7yqdIKRqiCMUKpzAf3nZIzOwGqrOBKcj5r0lxqfeogYY?=
 =?us-ascii?Q?sA4/dlDYYJcgq+sFlBT3HiT0I9D/6/z+DoQqwX/boCQLiNuB2nscVklApOG4?=
 =?us-ascii?Q?OSz+im5pDuDgPS/Yp8Y+YZ0zH6CQA0hDJ+epBYG7X+E0HU+RytDwMB5lrwZb?=
 =?us-ascii?Q?EZ1SkTpfDiL5xDxmqwt4PD9ZqfnlVDfKoqnwpwtICk7+DShFHERDwdj5fv01?=
 =?us-ascii?Q?pCa+5UJG0Syb7bfRTYWQY23fu4wHag5iyl1Wm821ZFGbZDsthE7hEgRkaxks?=
 =?us-ascii?Q?cH48nQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1299758c-27e7-4f43-e5e0-08db6597b75a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 07:37:29.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOGPtHrxUfjKuEFX4EOUnZkUUr7gQPyAXK5sSyXMI6yEY4xMIdjFRmWir4iA/pYrf32tZJX3ekGntZKiBsOB5NMuceXg5OXYzn2Z11/fVBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5761
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 04:14:51PM +0200, Maxime Chevallier wrote:
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>


