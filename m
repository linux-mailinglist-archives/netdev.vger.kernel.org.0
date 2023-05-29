Return-Path: <netdev+bounces-6156-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D41714EC3
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:08:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A04280F10
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E573CBA27;
	Mon, 29 May 2023 17:08:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA23F8C13
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:08:40 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2050.outbound.protection.outlook.com [40.107.105.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21734B5
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:08:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZdFgcbvuxsNeK57q+orMizpMYHXnHMxs8oGoWHYtsaYdH3mYsvCzU0HZiG+I8gmnJRKsaleZ4YEakhTEANeB6885JuQ8sglU1aEk+Y7qERHV9eFfbytJQCvil0y9r1WiHZRBL8xzUWHouVnVSWySNzorlDW+m3dYavfWwxe2kSsMyFoJFRQCKRnZ5rhj8SunBWZcHC2VF1l0ywq2YXYsmtl6hyMJx/OMnMweHWqOkhr1QPviuJAGrQAxnZClhcJpswXnLoNKsGnfBL3rR8pEXLBVu3Wb/AFpDViCTA3HhN9oTt8KvW0W8SjmpxbdHY+qjY9P0nk5LQrt0rbx+Ttyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVpF+IJdQjFtY9YG3+OWWgQWBVElIubppjomxDDg0ZU=;
 b=Xtxb260d4FHKPhlfrYXZnMAiSIZwwtzVM84XA8vdEd2eC0I2gslCbOvr6+Rb6nvNCG5HFja919o3kfrU8qKd2NvFrSNaN8SGYgMNTKubjWqVknrU+f8PrRa8BN8XayDChgOy4Gmoa4U0MZF5vOP260/SsabIpu5bdpg8Lqzf1L4k7/uvfPDd71gkMwwMpCJPJ0NU2e1e6EF6GXWB06kVi70GIjjB7OB42klWgdrHEgIX/UKtpQkxkeJ6OY9LmHW/1bwjsr0kWx5QAkIJzmeT9icdRy5TfI3XkyMAWvN5AdKmP7jBMmRgj5CNKVnT6XkLlokU8FxVaS6a/azlYCLboQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVpF+IJdQjFtY9YG3+OWWgQWBVElIubppjomxDDg0ZU=;
 b=Nkq2Qma8n8H2EQ89tFhfx3CwL3Y6L4+TEIXB8PPs0Y7HkrEImgawDEnJyUNc2CqsdGLYpOdFLIrQ7ySsRe2OcAxOtc1rWSJXaO0LYiQqmJlqbge+bJbBIvi48XdkFpkn/8wLS5BYYJoudTnEO0bOnMNWZgK+70Lt3L/wEeFR+kY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com (2603:10a6:150:21::14)
 by VI1PR04MB9763.eurprd04.prod.outlook.com (2603:10a6:800:1d3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 17:08:36 +0000
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91]) by GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91%7]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 17:08:36 +0000
Date: Mon, 29 May 2023 20:08:31 +0300
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: pcs: lynx: add
 lynx_pcs_create_mdiodev()
Message-ID: <20230529170831.w5vpgukemor2cbbl@LXL00007.wbi.nxp.com>
References: <ZHCGZ8IgAAwr8bla@shell.armlinux.org.uk>
 <E1q2UT1-008PAg-RS@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2UT1-008PAg-RS@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To GV1PR04MB9070.eurprd04.prod.outlook.com
 (2603:10a6:150:21::14)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9070:EE_|VI1PR04MB9763:EE_
X-MS-Office365-Filtering-Correlation-Id: cf7bd18f-84e1-459c-16f4-08db606756ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TVkkSrUVYDms4CAqFIczYBBcWHkh3vH58Opb6I/o9YFNz1xtr5LnNuA4yIGqaLYv1M52HJPLmKnmWNtFLPOzuMSEWxtLwDB/awEwPFbsFXky2W7BaKrNi4mZD2A5k322aGv4/ecsoFSS8ih2kki9IAA+EgRPAgPd7us/8VPSXY0NaO8Vz578MbWlL0G+KER0psDRA/6ru3/mO37ArONSbSnQcYwNvMXVWz4im8GDQts6xB6wzQuW6KYOLqkE+ox0kGZRlkwVk93FGFvU4o5dNtUIHS+F6ewgWjNNE+p9/LgG0+6udv2PAqC8m5xzn/OyzUfmBT6Y7QsbgVAgOCiAWVeebiVq+tlfwg9QswI2VjOVMqSmCRZfnW7/rreNM1rc/fN1YU16OV9o/dAMan+8XaH9iK99U8x33XSqx7u5AZvx/iFRfkzBanzNMju2FoQX5nA6zLGvITlNMYSy9C9QDKNFXbthNAW0QLjxT2yBososwQgRVxSUwezFZDZ4ez7a6pEwwDCzhGB4GMO2G/SThnt/GBY6Lhslst231d8jiZuoIO4E2M+7JslraaaV+tdV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9070.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199021)(6486002)(86362001)(41300700001)(4326008)(6666004)(316002)(66476007)(66556008)(66946007)(7416002)(44832011)(5660300002)(2906002)(186003)(4744005)(478600001)(6506007)(1076003)(6512007)(26005)(83380400001)(54906003)(8936002)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TKLyCkiDjHT1RQAYToopbMvy1kYYYeJNLzxrS7GB3Nuj3NDGicf9ZBdftpPp?=
 =?us-ascii?Q?41ZsLUvDdmM9vqh/NsPXnIpy9zld8MsSX7ePXhjMdF1ZBGdd9/fLh8kwGIGX?=
 =?us-ascii?Q?8nF53+bLrrAK1WUoo55t0LtsfiFk1HDcL7HoGDO9qI/mw3yt5+MnXjCFTvQs?=
 =?us-ascii?Q?T/eDPk6o6hfvXzDjYyA0zTzNL2Gs8lvVpLOZ3tx/xMP2tIA3jpr31EULJ0jQ?=
 =?us-ascii?Q?SHBxbgdWhxqgS5E5ZAZ6Vwhw88EqpRAx1PqcYrLn2/dvHM6eXCxj+zcfA8bP?=
 =?us-ascii?Q?dn7xkURKJ7S6HZE9RytM6iJ+GN8Ug7R6aKJOxeT2Bl9ofo6qjVM1yEcwvIZx?=
 =?us-ascii?Q?XznSEjDK0l2lgDP8Hvdwf6htiCQJuouGMzK+OIeaVve78xOo9OtMcaAw72Oq?=
 =?us-ascii?Q?lE07x6TxfsXl7GjOD8PiVxtmht775qlHvia4Y7wkSx8plJEBSx9LdiyaqG5v?=
 =?us-ascii?Q?A/oJ0nFzbXwgfujSE/zgYNjLLoS8cCvGdreFaXn6y7/zJrHVrag8NAak0g5k?=
 =?us-ascii?Q?LTHdPVptivoVY1h9JsSAWo35AB3PODbLMsFb3T0KSiiAJOn5OkUgfjFaw3dl?=
 =?us-ascii?Q?xb4W6elMYEvEkWIIbtPAWrYOnpgcxmK3qr1Hz60OElAOxcsHAtUP7YpVhj2U?=
 =?us-ascii?Q?IpBcsjbF1GSICrLvadzZXFWa+cF84JPHSE7YL1sxZJkYUlF0mBRCAFQ9Q5k6?=
 =?us-ascii?Q?luCNAnRpWZ33okNXtV9V+v6Hn2CsOLdAAZekB30Z+vwzjSn/0Axf0xtoAQXA?=
 =?us-ascii?Q?WMeyZ/Haw9PDZyJktjKcwEBQ0/BTm6m4D2RDF9195ICLnmJyZU0Oi3jjzaK1?=
 =?us-ascii?Q?NRs8h92yGXJoNqWDOtjKGumV6+upMiLLqFHxlk62YC7TBmWWtVHiMnZGpKld?=
 =?us-ascii?Q?R72M6B+MHnIc9MMheMJp7gDP7TlHcHLgYkOCzuxn86LHdWx9aUwhYyYhmbeH?=
 =?us-ascii?Q?U6KHxR3V8n9aOrxRSqEH/TsCD2NO5F08zqkGaTVob2gYrvsApr9cWB8/bgxT?=
 =?us-ascii?Q?k4uRNQJNYUnp9itOOeKTAlpq8IyBskSxWYNVYbBXzAPcpr0kpi5PxTDjUn+5?=
 =?us-ascii?Q?Zre4WZ/JdhfJ5GMahn4lPkEqpSa7eMvqddijm72gXfG1drQtiIaSUuZe0MSo?=
 =?us-ascii?Q?MM1teU+AxgrF3wrSlFFfm/6EHzmVezXviUZh1UcN9ghoTGPNYTHVvPf4A7Js?=
 =?us-ascii?Q?vDjbNflxgZZVSAcYCjUb6EsuDA1L4wH8Pc2jxoQ/XcAtEKRI5itqMrMh9+A/?=
 =?us-ascii?Q?fU1+SpoC33G2gGQZ2O4Jji6nJKZx0MqT9CF3QAuBFiFjDXs8qGLxhOCxyQOI?=
 =?us-ascii?Q?vsdv2w9p5d3HkxJBGV/MBFrZ3sWMYbwC2WI2XUSwFjQQWexE4qXEDtRm7Yra?=
 =?us-ascii?Q?cb9pL6GMTZ9xqYIcMe20bv4S2ZAtFJUuMHkxhlpkZvBGGsMtB4ssvD72oSLB?=
 =?us-ascii?Q?KRJ+hs6K8Iy1rGrpE4GymeAhg+9fWdUUClJJTGOhaNhrBzXhfOwNgcIsMC3k?=
 =?us-ascii?Q?Z7TWRICwlQzB/uMDfKijPCw19ZLepgxQ/iOiaTi6a8V8P1JN02WW0JugOa++?=
 =?us-ascii?Q?Gi5tdr6bNko4w4+YTp5FCSVkhmM+hXlfrnTLMMQo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf7bd18f-84e1-459c-16f4-08db606756ac
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9070.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:08:35.8818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RicHpQq3MVc/7xtIrHBtLLSCtSbLwCR6PPKYJbYZLZW+siH+navSEUliidmY99b73MGMpb2PI4QANKUYkdd5gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 11:14:39AM +0100, Russell King (Oracle) wrote:
> Add lynx_pcs_create_mdiodev() to simplify the creation of the mdio
> device associated with lynx PCS. In order to allow lynx_pcs_destroy()
> to clean this up, we need to arrange for lynx_pcs_create() to take a
> refcount on the mdiodev, and lynx_pcs_destroy() to put it.
> 
> Adding the refcounting to lynx_pcs_create()..lynx_pcs_destroy() will
> be transparent to existing users of these interfaces.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com>


