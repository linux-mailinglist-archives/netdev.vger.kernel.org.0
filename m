Return-Path: <netdev+bounces-2263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A62A7700F53
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 21:36:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40A4B281D02
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 19:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 507DA23D6A;
	Fri, 12 May 2023 19:36:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9AD23D64
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 19:36:26 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2090.outbound.protection.outlook.com [40.107.220.90])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92278A60
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 12:36:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFiETbZLoPjJ4kn6kuSLOBfpULAAdrKgr64tb8t0CbGX0BBTU5cEnDYVDHrjXYrUKjAiqiwrgPVGbS0Jrg25yl/qOkGlkApksK9QMZy88FHiDD1UEyi68JLi9furASh+Xyajo15Rm+EiBqWEdduJmhbFi3Ok2C4ZPb4pmQ3lFjyJH65kx/ic0AsNliwdnE/oxh1hEPFsdVqS/lILXq3SWZsxGsZhhXIJN3LszvokF49/2+Koh5oZq7ADdF4EUy7w3Ix3sS/maDKV3WHyCln1AYlUBvADbbMeSuvC2cI6yvpTvlcc6uyE3kJlHUwjrekQEG4QpUysw9tujY8EV+tFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFjIlHhhi9k5DwzdSfWAZl3Xj6Dg9m+C8GcCp0rBP8w=;
 b=Bc1aI4DfkcEzEYFGjdTdAV9UgzCSk2rbjcADsMvoT0Wu1BkYKpxDUYlftTna8OU8FwEky/PwIV3uLnttVPkIC93+7NB5J8araU2qxdOfEQYeiqq4NNxZhpep7xV28xpn+IxdpHBFPSGW1m90tgyRlXmUZIWYK3AFMfEwP6MokRoQRfYqiqJWJ4FJzTUtPmWXdpGWU0KKX34YcI7iqACPmv5664pAwkTrjsWJxUTjPzmVAt+JcjqUZ2s4L+Ms8uvxCGjvTcf+M3g8hPfsB91UQZtHhJ2Kf//blkKtD9gFm0pXRHnuI+zyEXRVPJGdSe64rnzvTZeCw/A+PLFQf7/tPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFjIlHhhi9k5DwzdSfWAZl3Xj6Dg9m+C8GcCp0rBP8w=;
 b=PtDF1ViHo0wuVGfkT9h5M86RwI0lwRUO0arsgSTayIGsE9brfzzxUeXvXuIkHbmeF2JD6326TMUThsKQAEA3/nEsu03JvVcDq1ntFVmft6MB4LL8dFJ6DJU66+xCgvjYIufjLhkpm2YTvJCtjv7kfd63+ScIinKOUZRCZBo8XSE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4735.namprd13.prod.outlook.com (2603:10b6:5:3a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Fri, 12 May
 2023 19:36:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.024; Fri, 12 May 2023
 19:36:20 +0000
Date: Fri, 12 May 2023 21:36:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 9/9] net: pcs: xpcs: avoid reading STAT1
 more than once
Message-ID: <ZF6VLIMWG4paonAi@corigine.com>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWYT-002Qsg-Rg@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pxWYT-002Qsg-Rg@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM3PR05CA0100.eurprd05.prod.outlook.com
 (2603:10a6:207:1::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4735:EE_
X-MS-Office365-Filtering-Correlation-Id: d08e0112-f8f3-4867-728d-08db53202965
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qq4+YYyj4nIUGZsFlm4Gsf4Lw6kHtfNBShzrGLY4QPHCrx1BQGMoRpS9BDcaxF272gs6gksCzZVfaniySI8fHftSRpBAajXaTLglkiXXBNzRB6ENv93kZdgaIIkxU3WNOA2SM4AbBThcvKyfKCnk57hLIgVRM5PQ6kj3L6m7SnMFooVPRLGDI1bf+LzDRt5RBu47atn/n4fktwy4uDsfs6W24JDGnlBMImHYXKuKIkqCULfMoMwCLOIkdBFgwdS4uQ9Hx5KDx+QzNaSg8JTP2jf/l5bk3kw3ojIGzsrEg6RISPrbCjNLcQFxRiJiXAWR26BOilqZtNDkw2aOtLliFhWp9XiQmpI2oXUA3BB8HM57oXobrT/PGwa0H/TQtOd46AwPmtYoeTIxsZzrpTjhfgLMOdKTX4zBIfjWlnEfZ+JtdQMgugJ2ogdq82gBAk9LTtev5PI/6X+TiK1RYmDjqHXNQQIoBp6gZXm+6IqBHpcIThr9su07MgQj7h10JRk+WfWyDwE1vyApC/EZeOkn2QEHQt0+vO+qL2pnu7xHVMpKsIEezT3aUe5kwTjur5OC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(396003)(39840400004)(366004)(451199021)(8936002)(54906003)(478600001)(44832011)(5660300002)(86362001)(8676002)(316002)(36756003)(4744005)(2906002)(66556008)(66476007)(4326008)(66946007)(38100700002)(41300700001)(186003)(6506007)(6512007)(6666004)(6486002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ypyK+bDnR/4PBPE5uBLe3k7tMWlCmyi8b84Z0mg6ZNZ9munFoyQ7h72XhvBT?=
 =?us-ascii?Q?jp58AsaVJ1t0jgJ6Ti/OgbVb8AiZpjZ5eDM1FOYVZwQ3+vlwZ7kOFXrH5Lnc?=
 =?us-ascii?Q?bU3Y7SdcInU+kvgaviZ0Svak2VJsI8sYEmVAEjjwHPAMi377fIbvgKL/1SHo?=
 =?us-ascii?Q?zdPNMYG9QigDjGq1BLNYGbJGMiGSKIethxBrxiVJJbFCu4ShESUg4ExiYQwM?=
 =?us-ascii?Q?Vd8y0zA/Ab2uKqt3VtOJ36GEZSnGi1HX9H/8KIhA+BCpWoWUV8+fBIVcU7fr?=
 =?us-ascii?Q?CEULv3TdCyKXX9omyIrgapUK3v8JZpFd4fHUJpHPLK7J8B3UllAOz3T1pbZJ?=
 =?us-ascii?Q?3ekVB2j86peHWlM75bEfBMzdZIxeIEf93g4vgBIEeU80tNj4OTmny4vK1+dY?=
 =?us-ascii?Q?i9WsUn4K4HwwTg/EKo0o9639nPoeZwPVKOO3SLLzFczJi6MM0y0CyG15z4Al?=
 =?us-ascii?Q?9PvReJvS5JIvwJal9VpoW/pqSA5bm2WaPGTjozPR+yWZ7Ezq2AyNz+YjGzos?=
 =?us-ascii?Q?rPANpHtoAdZnMbIxOqQN0mmxhyj51MR4fl1EHBNV7J4CXj2E0TY7RDci9p8A?=
 =?us-ascii?Q?ui8IO/f3cn9n5Iz0tIw/e+ccR0TkH7RPQ41ANfi31EXMmo+fHnYfgcl4FpL4?=
 =?us-ascii?Q?/XUExNWK0T66QZ+2o/2ZkGrYATyd+Khi437Qwf5gf17glQnubqsdC7hI5zXJ?=
 =?us-ascii?Q?0ubiz2pLyEyVTTJIdFuVsFot/5yetioEc5yYmN6Vf0+28s9ffl2BCA3gfwC2?=
 =?us-ascii?Q?893iMakEHyoZO37e26HTbSeZP148FMNPlEiHU1Klynx190TRjfVqOq6Geolh?=
 =?us-ascii?Q?CYzgrvPJ/6dXBpl1SPoVsSxvIvt4YoIqEA/mkFljMyZlQnmMf3McoVakATCX?=
 =?us-ascii?Q?kEtqeJOEa35PjIJpRxVLJgzGHVi8L/GBx2WoXLVwkt0v0ukOJZgeJm7Oi0Fn?=
 =?us-ascii?Q?kcFq5ILh7Im0rI4C/Qtdl+mpm8vGUX9+VLR8SU3gIql5a4TnSj67jHYQtduv?=
 =?us-ascii?Q?utN+c6ujHzTEaRpxLtPGfoUw1m6ZUC3pO2XgXGbTXgrdb08FelS8+q2vC0id?=
 =?us-ascii?Q?1H4k+lW+5OR0u+a9lJ+3y59XMATf1fBOOIrCEvNImbXKoiZph3nsXcr2FiO/?=
 =?us-ascii?Q?uddPkLQ5HkccIuO+iDHpxpxdEfrRNeDDV4n/HJlcu5Ahcc3bnjt1qbdjXPQX?=
 =?us-ascii?Q?4FpIiqE5JWQget/QLQztfbIUNDEqOcGZBz/TzjxsjZa9hZC9YU/32y2dSh4B?=
 =?us-ascii?Q?njWLbM2l08DOtmG2QVMTTQqVG6fwa9HcA1ADFOAoFskj1pGSw0aefDiZCex8?=
 =?us-ascii?Q?RH25Rle2VoZZzYm+3Vg9lcBRE21ixMy+wIjpyLJPZfCVXpSqlYNb/NdyGH5p?=
 =?us-ascii?Q?BjBk4mkVfPZCDSCYCK4Rd7ajmd34Uq42GhAgn/5NPCcSTK0TVheS5x35OiV0?=
 =?us-ascii?Q?PZILjlTLtRJ1NDm0iAyYO/6JzgeUUMBJV4QRFuidDS2+5uXi+CvmksJ1UYRZ?=
 =?us-ascii?Q?s0Y4SmaUVB9dQj0qqSjJ2dlqJ1VlgMQlS3UamweUQaIdMmwr/Jv07KkMYRK2?=
 =?us-ascii?Q?1P0ytWHW5NeIGjM68Jx9p2n7ZVl/MTZnuSsY+Aol7gxrpejiRKlY7GSsfbBr?=
 =?us-ascii?Q?C9gEqngapUJqEz03Vn84HO5XfvJCAW8dWMfQNm/Loxh7kFtmpr/M0HvAprP2?=
 =?us-ascii?Q?CR50GQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08e0112-f8f3-4867-728d-08db53202965
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 19:36:20.4764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwruDuGtkddvxZ4CvHrGQiYcp4XvKIDIFyf9j7FU52ZHo2Ty/al6MLfbnnOpeTt2vRcpGB6olq0ue8IuYlJgOzJOuncSu5s/qL9o+tGnRAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4735
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 06:27:45PM +0100, Russell King (Oracle) wrote:
> Avoid reading the STAT1 registers more than once while getting the PCS
> state, as this register contains latching-low bits that are lost after
> the first read.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

...

> @@ -880,13 +854,25 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
>  			      const struct xpcs_compat *compat)
>  {
>  	bool an_enabled;
> +	int pcs_stat1;
> +	int an_stat1;
>  	int ret;
>  
> +	/* The link status bit is latching-low, so it is important to
> +	 * avoid unnecessary re-reads of this register to avoid missing
> +	 * a link-down event.
> +	 */
> +	pcs_stat1 = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
> +	if (pcs_stat1 < 0) {
> +		state->link = false;
> +		return stat1;

Hi Russell,

stat1 doesn't seem to exist in this scope.


> +	}

