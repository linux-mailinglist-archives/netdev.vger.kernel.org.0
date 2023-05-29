Return-Path: <netdev+bounces-6157-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D47DA714EC4
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 19:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 621A41C20A4C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2760BE48;
	Mon, 29 May 2023 17:09:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FC833ED
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 17:09:29 +0000 (UTC)
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2084.outbound.protection.outlook.com [40.107.105.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5219BE
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 10:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHOCJ0ZuimybtZyYEU9n3vkiAsvJVi105Mu7fmgYZ/MER03ZcEJmHEJO7/BTw4qwYqtSbd4jsDBlF/Uj1SZ2SbGR/WVIFuzBC4saYqdKHM8bUaylP7Rru20kXwomQRJzE87JNMPzYVmZ9ip4xrjT8g4edoSbXEAt06BBo4lqSoOgTjdwHPcXMReY5iCNpY0JdhSmpY3CDTXCb69ia5v1gf2rYQPvhCwXnhbicqMPx+9b1XRpNCwww0UjOJBCV6Qa5FLWimBh6PDbMOxBq1jpf5jev1lIXJ842yPXFUSNLfY77upVlLPzgajkgH+1KxSsvXcetlaFXIFKH37DoKGHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RocG27c9ysGM/nKsD0FLe2sZSAPFS+kx/JCDISmp+eU=;
 b=f2/4qtjae6Jv79OLsMCmH+PgJfPbdF0jzrXh6L6+mUG7BCbRWzH9wXmCUUx26P6uGPPuS/1i2aO6MYAelkmI4Zv7GF+LRBcw/g2Mn0QLzH4Qhk5sh2y4NCojNBh0IFT7rR4JfPgRAZyd6Dapl/y1dfzMoviFzRLNySIG1DNfPx0cvVpJv/Fk7o0IxpbHyLPNQS/+RI71DH+iUiolLvCaIklxEW/SrFUP7V81y3LYy06KCAfX0nD5sLj5YdC5pdwJmq+paFMQtY7Zv7x+YpEZj+6mj4smZaNGUNGU3Hgtntq10q+67bizyUcYOeO+dkajwQGPU5xqgWTJyZ3swbWsSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RocG27c9ysGM/nKsD0FLe2sZSAPFS+kx/JCDISmp+eU=;
 b=orMMcGwrz2nQ0yKNfkpVVX38cTMfksGjB7waeMmpDfwI9KK+8jeiwxi72C3BVKDOIa6DWhJ4nZl2NxTsTMYly9hkt81CDnU52Ko4nRuBsG1EzWHQXsUY7LUrg4PtcRImKy6AZ2ibHkYeRgq/azQMQuhXJWpTVoK4nWYVC9CNXMM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com (2603:10a6:150:21::14)
 by VI1PR04MB9763.eurprd04.prod.outlook.com (2603:10a6:800:1d3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Mon, 29 May
 2023 17:09:25 +0000
Received: from GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91]) by GV1PR04MB9070.eurprd04.prod.outlook.com
 ([fe80::bba5:4ebb:2614:a91%7]) with mapi id 15.20.6433.022; Mon, 29 May 2023
 17:09:25 +0000
Date: Mon, 29 May 2023 20:09:22 +0300
From: Ioana Ciornei <ioana.ciornei@nxp.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dpaa2-mac: use correct interface to free
 mdiodev
Message-ID: <20230529170922.uwr2bggwte4xanac@LXL00007.wbi.nxp.com>
References: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q2VsB-008QlZ-El@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: VI1PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:802:2::35) To GV1PR04MB9070.eurprd04.prod.outlook.com
 (2603:10a6:150:21::14)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9070:EE_|VI1PR04MB9763:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d14d610-89d1-478b-9c09-08db60677481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B/MWqEGYn39iGlGJZjQAcRjvTlJJN2xUqA7yF8DhwrQx6H/yKzWLkITuGE5Y42EemN8UqIhEgQFoi65fNq9q/sSmzNQe30qFomCgVKGcM1gbgABoMGWy616Dkz5fcbmLxsIQ/jwnSXkruF8WpgU31oYXxi5arTYHPtM9XB9UJL5v28ZxuomRbT50LF3/Y7tPDvxgHqGuJGy2jDgbmOOYvzCKGZPvFOvTNBWpnUsrPAGmMkxyAJpDVFTJiw4QG7UZCw7DrEd3+kEOWAQMCaGxz5NkZ1wBA2pdI7HSXGrwF0pD7otHqIjxz/pAKsKV2PSPTJKJ9KEslcvUg2DWdT1A1Q42YREfRMbXS8fHrgtu/Sd+q5PQ3SZApA8ghlGq+RPb9NwXBh7OJ2vaIjBRJtvyLju1xUkkOrn3Pzg6s86ldaK5vS4EIi2RsMdiFqi/w7qduKsfc+LAlDGbijy5xLIe/pu9FMRjNmZ3RcLqWaexzRZYvHBx2dPb7Utf6rQpr4vl7PqytC5lKYlGCQHesj41lQHqpkxvxYIbDIYn0JgoxziJIXLaVIyvqwRVL22g6MqX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9070.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(451199021)(6486002)(86362001)(41300700001)(4326008)(6666004)(316002)(66476007)(66556008)(66946007)(44832011)(5660300002)(2906002)(186003)(4744005)(478600001)(6506007)(1076003)(6512007)(26005)(54906003)(8936002)(8676002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?garaCkO6JG10uQW/TA9AxviNG5GJQOHz9p/3hofu1/NBpytokVs8b0QKgsCF?=
 =?us-ascii?Q?VEKfPsmd/Fi+oLF7uJHBrTq/9ZcgpEt3oyo5vu8uTM4wqhKcymS2T4AWGI8y?=
 =?us-ascii?Q?8PFIxbHkU11RIJcNbq5IbpzO6ju5Xis8/EOnOPxiu737Vx85VIwESWJSjRz8?=
 =?us-ascii?Q?T2okYBZPIxGkdHVz+kjNJlDHxf0z0B7VnHpHh6z1OcxKN03FlX6uhDOUtaiO?=
 =?us-ascii?Q?68t1kp+diI/tumDmy70/L717FO5Yf7b9ZOFaVaT0PI3e6L7q21Q7xI6PAIcN?=
 =?us-ascii?Q?/BvlsyBLgT+25KFm1m/gsZ2VyXBsNtw6jlFXoXutkYRAl5Njo7W5KOFNISQW?=
 =?us-ascii?Q?bdc/7yBjrUHurJvCeCPpKtn/ddmAkxHGSMkvLXaME08qzk1ansp8OUOummsH?=
 =?us-ascii?Q?ASbsvJWY6L6stzi7j0tc7MmA4e+N2Fz93O8h0/3S4VSd+xBO24M5NLVK7azd?=
 =?us-ascii?Q?kN+HtDj18I1cZIyhPikXdb3GDv/Ydf5MoEDGJ8o1b5wvPgBl1ardjMQIOF86?=
 =?us-ascii?Q?2+Yslcn30fyf7dlzpLU1hGNhk6P+nh6Ledp4E5ROINqF43tbUHMT08gksa6e?=
 =?us-ascii?Q?IESC90F1jhQx3puytUXGbFV5Q25ug8G6G5keQEY9gVCIVXNfFPfFy5WqtN0h?=
 =?us-ascii?Q?cu9eysuUPImQ2sMA6jAjeimo8bsC+eET/SqLzypPL2Xo6D2oZ8VCfJMEY+YQ?=
 =?us-ascii?Q?ywO4aHKiYQ8pCAWlfgU7VsyV6OKaaMzsP6fIqP89qXjlre3E3oRgU6WLx66q?=
 =?us-ascii?Q?9XBm6oZx5lw3c8TAoozwNzYOkBBRESYjn5n/iEEZBajOa/etjXRjVjlg+iZN?=
 =?us-ascii?Q?YPXJUIr2j0mbMWxYb3SESs3JDXXeNqFE7pzOKKm9zJzcXepP4A4clOXtYvHN?=
 =?us-ascii?Q?ZhYPgM5cREwmSI6IzYTjoQIyIm8nA+clWMg3tgk6zk2Zy4731xYE+aLX1XwO?=
 =?us-ascii?Q?1xL8CR6636QgsKf+ZFn1ZpQRZyznZzD6G6C6kWL5vrU7vkItZs8ehCc7cukx?=
 =?us-ascii?Q?dlIPU0kW/edA/nt54E/NfnGwnTx+nPu1Tsb3ms192fBvFMu52hxW7Ehx0Mku?=
 =?us-ascii?Q?EykPlxQmqVZ249eRmZLhetG5WN2Pl2x1V1P8ZrarxxP+0arpeFe71rV98A/J?=
 =?us-ascii?Q?5j5EzrMBhklH2laywsZgIS15RoyhI6BKL6c3BamxHdQ2i2mKhI+WIuGTyedZ?=
 =?us-ascii?Q?OY4Rl7CEUg2+eCeUQGkwien78t29qBLO44wOPmePRx+CsH+9bvQQQef+XaFg?=
 =?us-ascii?Q?0t6DFatl5vEkJeNegx+8Doa9ockuiisZzo9OevZRI0/T/uv6ztgAekTMebbr?=
 =?us-ascii?Q?YRjXHOCmiA9cpSy5vS4u9vZkuqWherAm0bX1+BkykO6sAaNGLYHsh3DXt+1P?=
 =?us-ascii?Q?0p7lVOR/sEtROsfH0Hg0v93IHrhd0HYPFOY0BTVzaRo444M0Jyk1Z+3S9KUi?=
 =?us-ascii?Q?HuetTFNc1uFjKo0jldSndtXi66tQgUDJrf43u0ukhGGUOK01Jh0jbNdRbGTu?=
 =?us-ascii?Q?GqHRs+jwsKFoM0ASEOp4lYAv7ZbQcjJEyKRgmMZGInJhGBKqiDivJx+mEBrt?=
 =?us-ascii?Q?BzPfm1ZOdySb7BMDjWteJ+g2sAuNTotDjnBX5E4u?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d14d610-89d1-478b-9c09-08db60677481
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9070.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2023 17:09:25.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3gtTC6j298wjTSqn+hB5r6a8fpK29stUKJiIeufjVwx+GjacaEhvchjm4zRSMJdrPNLOP3/gK2OwADxic1Gwbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB9763
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 12:44:43PM +0100, Russell King (Oracle) wrote:
> Rather than using put_device(&mdiodev->dev), use the proper interface
> provided to dispose of the mdiodev - that being mdio_device_free().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com
Tested-by: Ioana Ciornei <ioana.ciornei@nxp.com


