Return-Path: <netdev+bounces-1406-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D2436FDB15
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E4ECA2813E1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 455776ABC;
	Wed, 10 May 2023 09:52:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5E420B51
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:52:34 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2122.outbound.protection.outlook.com [40.107.237.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E117685;
	Wed, 10 May 2023 02:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jV6r4hY+i+Lf0XyQjLCseNo+sypjwWeO2SEIv/M8bkPiJyryNpy5GPvohuW92/GBtjlsXkpNYy9MNMkbnrFK7oHqKswmW9k+pflvJ4xqgSQOzOTLP45GAPkECWizOQ4J7vspPipDhCoU02g3RMnLVp6KqWhZ5Xa0YAlNIcYvDQDFGRAtsCyZ89Gj8I5ZchqEPunLJu3Us6NMqtSeIeu+E7j1GVtKf+PMsCQPLexDjz7HsBCsiTeUsRDdx+2PybYvYwQcaa8za/+bvewKKgI3JWFf+OpM72S9gIpVoFeOKBjSn8ifNqJ/ApTg7QSzhBhDl4Ky+dnRd0V1ajYaRccYyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xr3vCOxB8hI83t4HZYcLTIJwEXiAkgD9KcbFTWcprRM=;
 b=CCH8cuVR192IDWjsMQUB52TO+Pab4cOLTCQY+cFUul2vv9B9hxJ6haAqsRKKti10vRrKblv1iJIm647PycHJ1BFqf8QKLI4XHNMaeUbuMzYWpyNxCWhukws5rUvBV7Wa+nCanXniMq1Su58mp1Veb9W1Cx8tY56XqzcT4wkRjT4rG2hzDFNrU5gYQl81zOChYqBmg1RklItzWfumzpPSUSNHnHdRI0J66vSEHh2Ib9EF/aQsr38C1CVBa7wqeMMCocjv00pAaWQjFnet0y5lUr+idfmo9KOCAxQo0mF1DI3FCTx0PfmtHZ2qiU3ezXSKxyytBXBap+S1RRg5dxGskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xr3vCOxB8hI83t4HZYcLTIJwEXiAkgD9KcbFTWcprRM=;
 b=Fq5OSf5D89IZ6jlaobFJwdwC4sJpfnX2K3uTD8VOTAMr2dz1d+aUEtPQ8mPn7956n5nMtg4S+H1mRd60TtfuF4qv4LOtxpI2y5d3OTcSuJNgeUnfdDoGDCqW+yRGMWLUKjdx1657E1faQUnvHhp1uL2M9q0kY+pD+8EBpjFipwA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4647.namprd13.prod.outlook.com (2603:10b6:408:129::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 09:52:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:52:30 +0000
Date: Wed, 10 May 2023 11:52:23 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Networking <netdev@vger.kernel.org>,
	Remote Direct Memory Access Kernel Subsystem <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Gal Pressman <gal@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net v2 1/4] Documentation: net/mlx5: Wrap vnic reporter
 devlink commands in code blocks
Message-ID: <ZFtpV+WOTc8s0BjO@corigine.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510035415.16956-2-bagasdotme@gmail.com>
X-ClientProxiedBy: AS4P191CA0025.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: b08a338f-25e7-4f89-cca8-08db513c44f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	l5DGneUv5Swe2klP++y1ZoVwdDPtWkz9+noPjRguSkN/1g5zctN8fb/AOWgDohA+y3E7BPI9UXUA5ZVVh4FgG/6khI/hMrNFWp6iUqfEmvOkqikfBQKuNlN7XaNnEslw9pu0PI6XetIKPzQQfmnI9XtOJEwTkANKtWdDbt8pM2wF1xGkNwNs8HJXIi448IRUg5mNVuNE6Ccx7GpocpXbr8WhJMjaMj0wwbVJp9xA0SP7QTy1oGCGt0NQ2KzosF8gtpw5+hWBfGFt0FjP1MKj6sj8QoRknBIoHqcTI9+xpVzH5jEuZTRcgoxRn7A/w4PcRPtv2cmygoBDzsYQrDdoYuC4gVNyYCrCJQ/TZ7kDcoFhtQzLGmJ4p1Ep0NU0+tID5TpFRXV1OrF/AYLf1m3UUnxamNwbYyS7isB+pAD9StQZAIxtZu69C5s0zWTcAzOP7lbSMOYZV30KMZbINwHUzYiaX2zSIdvSkAdfKp3EFmCqew7Txz+dpPSXBHVkOXkoB/M1l0B8qQHIshCfBMz7gPm3UjUieZZZHz9QReDWvcmWHQB9jMNkGvyzSLhXmJYtsbdKKBhYteYkwlxE2bD3B+e0qs1uSTiIn0GY1XZuHjU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39840400004)(136003)(396003)(451199021)(4744005)(7416002)(2616005)(2906002)(186003)(44832011)(478600001)(36756003)(6486002)(6666004)(316002)(6506007)(41300700001)(6512007)(38100700002)(83380400001)(54906003)(66946007)(66476007)(6916009)(66556008)(4326008)(5660300002)(8936002)(86362001)(8676002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CGbGCQHwFiItuF14S1/gGb7zDD0OF8ds+r003ijJWZMsu9fjTLAZ3CqI95gk?=
 =?us-ascii?Q?/3JZb8dV3eYAFCQJYebwFnRKc6LlwsBvyF5VLHxXqliTjEryoTZKA+iKjWuC?=
 =?us-ascii?Q?/RsGPK48LBR11oysSr1RcNwNImwVSSRDgH2H7I9H4AUIhSWgIAYwbrMqGRkC?=
 =?us-ascii?Q?H9KEV4kWap3vQeonrCfBx0v2k7bEZBk7dw6+Gd8G5UXl/d5V4BigTMugmVlb?=
 =?us-ascii?Q?DQDQ0DC6Z8vZcWwcPJ+VWMcNcnaKT8PfhTax9W8ZpnH3jIjDYuo4QG4Eupie?=
 =?us-ascii?Q?sFNv2LEHuYSEKQKcpg6rRpDj7B39zlsEowgo00ZY1dLmm/QJnKcLEyccYYyy?=
 =?us-ascii?Q?gvHQKRDiLzbpQTzHOBQuOA7d5RdvMG4g18NyxUat/IK8tbrkiHOOlgtHREVG?=
 =?us-ascii?Q?E5lvwtANNJ+olTaSGsRp8RCIH4TGNotVu56N5lzvfYNv76BIFZnJJH3s7lEK?=
 =?us-ascii?Q?7+evVJJF//pw2lzqihsDJBECMNcXwsw6hiQyjW4egebzlJ5MlrCAtdBzUM++?=
 =?us-ascii?Q?XSgOBvLwVOXRuS8A0RpjvMvKjigAkr/qE2ZlGeXzZGdZvQCoNOr3liKu2XnO?=
 =?us-ascii?Q?O9KiYdAEYPoxMhI11/x5sUhQwKBKoW0Ji6FRESmsCtNSY6R8/xbeKWJyhWB2?=
 =?us-ascii?Q?7uXEF70iiKOQuJZIfVqXuZfyKlDkyESzqV2TIEOaWl/8p3PVfWR90dWPKX/Q?=
 =?us-ascii?Q?kzjn8FCUXEVN8k/AVd47ou0BV9JOK1qrf45QRqtmvOEkKWOmmhtEdI/c4FcE?=
 =?us-ascii?Q?8T8GadOt/RRIgsDprRR2OXMDihs011tVW2RE50fdzyBivlBKv1EysXjn//BM?=
 =?us-ascii?Q?tHagwQbE2rCR4SwMf1Deddzrz+7Z3OQltzFjHc+IcHR3xBXr2PYiaSEvvwB1?=
 =?us-ascii?Q?yhlk4u+pNsODOf6RUVgYfslqPyC5ZcxpROJrjswgNL8TgTx9y3iZ5TLBxIDG?=
 =?us-ascii?Q?6MZOwNmjA6KtN6Pqj14TkYp19XaJpKukFNB5+6ZTfisRrAzwafl1Q5UZkfbu?=
 =?us-ascii?Q?8P9xu6Xq0QGlta2V4WP3dTyzi6gy1LHOQKvQNrWYe+5DWif4ri3fEqY6kBjb?=
 =?us-ascii?Q?32mZh4Whvnfv9URhV2ZAfxXnHszCcxynaLQ7cfOzecgYEU1Sm9JwaASG/tpE?=
 =?us-ascii?Q?SxIfQ9cXNAmfFBNsRyPPTiDnJLNmQm0BvMdNwnRnB4rPCOINzhm2HGlxln3Y?=
 =?us-ascii?Q?k60bUdzuDfbq35GpP53SqBT/ludd6Yrp+WV7IJFuWhj9psibDNS6fveMzK3j?=
 =?us-ascii?Q?qMmgbE86tzdze5QEe0YfzuEyhnGasC+nI5xglDV6jmkgYc5jM2KpC/FzWseV?=
 =?us-ascii?Q?wmzn+Cqhrh5+NH8mkzHaglzTEg/4+/InCboJKmX688VQidK6CU1/KDTFX0Ez?=
 =?us-ascii?Q?yTy7PXMvLIijXOQD+mjcBd32qIgAGZhBUh3RdB+oimZxqKgFJswf12ovOJ2z?=
 =?us-ascii?Q?9uUHUeTNcq/YMRMSGi28QFdI3MV7tB/PKVb7j529RCFsVkJvNMgx9C0Cj7VW?=
 =?us-ascii?Q?HOcCJ7rZum3x/vWimfBH5IRLZkm3TLZF20BAQe7+4T3rAf3xpm/gF3CgEcXZ?=
 =?us-ascii?Q?HtgD2HvUe4Ygy1CxBqaQ9HjQunynsMgith1XjUPv6IwSu6kCU7l4DlyoP1d6?=
 =?us-ascii?Q?2C2rW+9UJgtjc0khkwCdS4bjts99K8d3d+qCz0/9HUb0/CF1qkEjhheYcHQs?=
 =?us-ascii?Q?nst4Cg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b08a338f-25e7-4f89-cca8-08db513c44f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:52:30.1298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +AqjTaT6cL7sqywZBT67EbFTU1pV91gZ+hVNem+iRsW6uVeLaO45uH1P4H5RWti9kZv96MVPanyurzBlzAb6kvsSQe10SHl+IsS93qIx20w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4647
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:54:12AM +0700, Bagas Sanjaya wrote:
> Sphinx reports htmldocs warnings:
> 
> Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:287: WARNING: Unexpected indentation.
> Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:288: WARNING: Block quote ends without a blank line; unexpected unindent.
> Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst:290: WARNING: Unexpected indentation.
> 
> Fix above warnings by wrapping diagnostic devlink commands in "vnic
> reporter" section in code blocks to be consistent with other devlink
> command snippets.
> 
> Fixes: b0bc615df488ab ("net/mlx5: Add vnic devlink health reporter to PFs/VFs")
> Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


