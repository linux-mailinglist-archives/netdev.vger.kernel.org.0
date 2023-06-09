Return-Path: <netdev+bounces-9681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E9072A2D0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:06:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C7A01C20A1F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09238408FE;
	Fri,  9 Jun 2023 19:06:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F49408D9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:06:23 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2129.outbound.protection.outlook.com [40.107.223.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8128C35BE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 12:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp42qi/XWSvdJuN/Zc/kTQV7djDBPt66JihtO4AhMOtppij1dgUpceFggLhMehU5PLJeTmYM2wYgYI2IP8uCX+TNI4g6O/nolqwuk1ax8TlZR0kRhS/Lw+tvewHzRwgjwhVGOlr2b6IFuUXHUU50RedToJnszf9ac31AB6FiNNT+mRWvuSPc0E1fphMZLFn/zesDzgdlAF+FsMVJYQDHyPRki9P3G7sS92MPIHxfFHQF6TcwCpgKWjGYwkI6wqGMnvPdJB3aaRV+C9Htw+lTuAVJ5DjHFQ5zc7+Yy7310dA/lM+Fq/xTIpRD1IxPhmlCfzrnx2PgUp9yarSguXqWCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l2bQV3qJrxrNpGKI00B0I0CvZrXhmL/qO4pxHDFL2o4=;
 b=R3zpm/GDYjn3nCxbRnx/rwtU0urd2yPkWrOelIZViRZ/m9IvcdtwOUHWC5zehYAc1n2tpnIlk74+n6S4hzIbP1/jbdf4t6pqNXJs67XqZPKBFhHcd527QkXwhmo7CXfCxfMH5RY+Y05VUCIUiyDnuuh37t7bCfPsJTAQ8WsNbiV53vxX7tDq4CuRHw7ExPHKRkw1RvF0XesILVu+EWLDkk+FNFZl/ud6bhp4AK7YMIumidjVOxNqdDWNGW1LzL8Q05Zt9Kvda1Klj+RLz8vMor8DH9GHKr9XOe+Ds6p6TmRXnd376AojZHVBzhDSPhQQeP8iVxdGIM0D+V+yamHTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2bQV3qJrxrNpGKI00B0I0CvZrXhmL/qO4pxHDFL2o4=;
 b=Ns4qDP9VuJAOrhjZ3HaJ13ON3gHd5394wc4mhLIgX+P4ov8eYPhvAMirSW6DiJ6cI3vRLnDL2Rwzdf/EteiNTu3qx9Y+HFz1hpw/y1TeDt34MfBh43Jgxz49pgUKSi855V+V5hDc4E/G043PbzZvwrg333U20Q5gsT06giW+WcU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6336.namprd13.prod.outlook.com (2603:10b6:408:198::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.17; Fri, 9 Jun
 2023 19:06:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 19:06:20 +0000
Date: Fri, 9 Jun 2023 21:06:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Amit Cohen <amcohen@nvidia.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 4/8] mlxsw: spectrum_router: Use the available
 router pointer for netevent handling
Message-ID: <ZIN4J9J0KuPARJCA@corigine.com>
References: <cover.1686330238.git.petrm@nvidia.com>
 <ce43bcc7dd96b7d1db2d55ee47ea14023f873698.1686330239.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce43bcc7dd96b7d1db2d55ee47ea14023f873698.1686330239.git.petrm@nvidia.com>
X-ClientProxiedBy: AM4PR0902CA0012.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 610b1ef4-57a1-48d5-18c7-08db691c9c4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N3aSvkblwsyJOkR39DKk6+zVs4C1QZQHQEbLPBittED42W0Etl+QVmqQqfZ/YSWnNYtTAcimI6BZfBiqmWksUtp7vVbFhKUN+pAD6klHJOvgOd8hWnpJNv1x2i81zExdsMloGvE4SzOLnSGQOBvGAVEfV2Fi6UnxWZ0sXc7D05DKncYsW4MyTBt+yYiHdPfRYsUi0LD9tuHtPL9MCeB4Zq2LB8YdpRG57ZAil1Favb0o9wB4DGgOSBVBbicTrx/px/RNF1ceB/J/dyl+oM7/46xWYvuEMo3ghYkkI84n/zxc6VdmuMtRJPX+qDQaf6qMkudCZk4YW/PwOHwafcHqB8iQ69IMSzvzzzShWQ8ANp5mgvOlV4iUS1XdI+J3aUSC4dNSeNUHHqIABi7IgRO92pbMTCVzztMn+EAEn4cKoLG0SvdCqmlj4zG6902f5U6tBAktwsPA5zwtaqRWjv7Ht/nGtgDKuyBmeOcCX3sQUlESBSeRpc7LSLoJ1fXyqDQVCJcrvGfdWlBBfZZk3FSMXI8IQFN3jho3Ijxq5QVfqf7Bj5pTd5fggRou6Eqd1Uk7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(136003)(366004)(376002)(396003)(451199021)(66574015)(83380400001)(2906002)(8676002)(8936002)(5660300002)(6486002)(316002)(41300700001)(44832011)(86362001)(6666004)(478600001)(66946007)(66556008)(66476007)(38100700002)(4326008)(6916009)(54906003)(2616005)(6506007)(6512007)(36756003)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aS7xPNcHP3A1Fq/evdkAIxWzUYbYhst5u2fBgBINzi8BrR90+dZ7CriNXEW2?=
 =?us-ascii?Q?Twsp78cxq/eVNVD/scb9DGOIvMjWrW3U1ayOhdR1mEaqQHv/Rb1f3Q8jAM3K?=
 =?us-ascii?Q?cHBv2GJaiu1e1xOybRIMJL7zv2nLjfhnSlI2c3l+WUW15574Y+jMLWmtc36C?=
 =?us-ascii?Q?tWmrgpE10s/mxZyN8DPEiOvIo+5VlERkbhRkAIHNbbfhW98GS7QDrKlgttM7?=
 =?us-ascii?Q?pwKw0xfbOGTg4dr80VeVgM3j1AD7ZQkqnLgvSepbBP+nY13lmSulxERP56vD?=
 =?us-ascii?Q?hTuyiUDZqUjZsBYr5ioytNmsVWLC5vsrBic1sOqFaxGTlHVOB36cVRzdV9PU?=
 =?us-ascii?Q?p8K9Knb5wRkIhmZrwgx7fQFgvA1aNTxjAiGGKtghbxj4S8z2eNvgHZNfNaj0?=
 =?us-ascii?Q?ABEedUHtgRdsUbp/v+t8Iszdai9jgbrS15mwwnyHJz3ZiiRpEMzORAPUEhQ7?=
 =?us-ascii?Q?a3DdfjPSs9P0wZ33sfhBUlqkBFfL0w6jFkSuPfZCxLa8cDuJ87u4Q2JH6u5x?=
 =?us-ascii?Q?C3Lw1X/2NDbPyIhxT5P2UnCsdbT2NWzztvoeQz4/+7kzeUYZOmWNfRAUBpPL?=
 =?us-ascii?Q?RqnHqVmx9qjodstbMRCR7/+f9jXIkqDGxiJAqw5Y0QF7ucG22nW/ERmOtLm3?=
 =?us-ascii?Q?Q3lkLMdTiD+Q3Am5x4I0915ppZagTvNVC2mYyBbqFdmwZyoIXbjp1frkbhfm?=
 =?us-ascii?Q?RuCpLbosPk6MyiA8LArVNJ2nClW8wAf2YVOXBvgAlc4ubkSW/CieD70wOGR2?=
 =?us-ascii?Q?pBs7bzNx7zzNSUa+fbmCHrw7sQQ7ymtkRNQtq7eUz8wKypTxmRnUa5bMogO8?=
 =?us-ascii?Q?2rz3fV6E0PM9wY+9bfx5KmEMPm6TMkKa0maOjbkMzsPn2o1wAJHD/Forlt3l?=
 =?us-ascii?Q?/yD9yW0UQ97CzxumDvxzVr4STcswOjRIIeTJtgZlO0NRNZctip5A/m57SwBN?=
 =?us-ascii?Q?JVN++uERJ2aX7mTz89tZ+5eos2Bq3ev96WZ+u8Xy/iGt7sMG47p2Vt3ungCz?=
 =?us-ascii?Q?2VPJoTnS6apLAnXrHPMu8wWDoorLR3xBWnGwYY+KsBqsWDYUi8jMDanxJK8S?=
 =?us-ascii?Q?5FwQp+5gscAkkaBEa6vkc1kFQjCuLOPpsyy9RRU18PBgnob36KvjnNpG2LEC?=
 =?us-ascii?Q?TzXbPGDdGniOcQgaN38Pyz7UritFcz6xuT86r6ac+NYwosVRSWuEmpQ0qs4E?=
 =?us-ascii?Q?4lRSII2eXjtNeRLDQnkFFnVif9h7MR8diXtdDhve4SqYwXds4c+8qnCvzcJn?=
 =?us-ascii?Q?lmq/eyaVrdAxyQThEkYGZx8Y1P4yd7Fl/fCm6NmS66SyszadWGlx9FHwEH9a?=
 =?us-ascii?Q?j7gPs6565R8ag/94vP9g+nAbObwNysMce/j0b5HlWM3MkBbFKcyIMVjmN+Ed?=
 =?us-ascii?Q?f6LMaJ4u7zN9lO8ffD3eQyPc4ElmNCAXtNGknvlTsQmEqY3l3gOEo/k1mFBY?=
 =?us-ascii?Q?+RcrAWEnlQd4C29drU+YMRzjoKkF224efuxT0trW3La8b9MPdWMxaitYxf1Y?=
 =?us-ascii?Q?0DejH0olF+zY3YI5YEoFblcViTfOwS7mFUGO2m45aIAMtSfgIL82rjPjJ10T?=
 =?us-ascii?Q?ekfoBR1bJPDdGtIQ1L7CVs+jOrgkIQosTAo+vESMvYSFddHj872ucaK0mbnz?=
 =?us-ascii?Q?Bhl4hkRHBs7L79N4uc6T47hRGcNsZ88Fj9Rq41p0jtkk3e6cDAb412jMdlXd?=
 =?us-ascii?Q?+5UQgA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610b1ef4-57a1-48d5-18c7-08db691c9c4c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 19:06:20.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +h2X7cWWOsrBXNoaoZm1pUBZ3B7EaktKpsOyhp5fxlwuv+dxNgDNIzwUpQphyfLXOv1bhS2zX0j4S5Q5AKD21KDH/sx00gDzxTJBBlBivpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6336
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 07:32:09PM +0200, Petr Machata wrote:
> This code handles NETEVENT_DELAY_PROBE_TIME_UPDATE, which is invoked every
> time the delay_probe_time changes. mlxsw router currently only maintains
> one timer, so the last delay_probe_time set wins.
> 
> Currently, mlxsw uses mlxsw_sp_port_lower_dev_hold() to find a reference to
> the router. This is no longer necessary. But as a side effect, this makes
> sure that only updates to "interesting netdevices" (ones that have a
> physical netdevice lower) are projected.
> 
> Retain that side effect by calling mlxsw_sp_port_dev_lower_find_rcu() and
> punting if there is none. Then just proceed using the router pointer that's
> already at hand in the helper.
> 
> Note that previously, the code took and put a reference of the netdevice.
> Because the mlxsw_sp pointer is now obtained from the notifier block, the
> port pointer (non-) NULL-ness is all that's relevant, and the reference
> does not need to be taken anymore.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Amit Cohen <amcohen@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


