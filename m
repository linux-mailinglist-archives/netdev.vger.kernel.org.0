Return-Path: <netdev+bounces-1404-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 540AC6FDB0E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE13E2813B3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36DBC6AB3;
	Wed, 10 May 2023 09:51:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D3C20B51
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:51:55 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4A65587;
	Wed, 10 May 2023 02:51:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmxZTWLAaMP/x5O5pDAgBxmRu6CJ/P5dfl94wHfpRwUQSOwWO/x2Xmjb5hNz6Wz1qeDRNwFMuuoTXzXIxDqotA370iqDHraAW3RIrSbS/IXPiaBQ4hPpml9Ffsls/qDM15VzxYziPUDLkt0SgOyv5XCd82GGX2yo80lQ/Ir6ibNCgNh+YQRMlqepLGWYgNZi+uFIunKH+242y4BSlyEj8dRq0JyIiQEvhYfhJ9Ukl6fJYuDpETfAYQQt+WaUu8wzT/h5dQVAdbqHspKSQPvlzk31x/FB216NVBnNylC0LVQ1kylfoYXs8wUY28Uz/V1ITeGLRB+TGdBUbbtHqW+gDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpsBP/3PQX99Lvpx7tXcvU+9r/A78N2O94dG4uhFEWg=;
 b=eJu8XLpW4fyRUGS6QK0RW1KBPLdc2jY+6mQlUveN7UE0G+kqk4PozoShwVvCK+QsAGyluR6KLh3awbftMqAqVeyjcBRCSV5/0q+doFPLqGo17w0Ig/XI9hHRRAh/7BeJVq6+7kAuZWcuNsLi4mVsKbrIF6NTHrfZ/ePtqL1gctyAZnUeAQU0cp3IkbeeAy3fwu7CHbFNxXQ5ZugM/k1zgv8e5TJuNHA5dfWyHQpucEk+Phua6C6/HXYPthYzQEYDw+Dr7szm9HR68/D/kW6KFY/DiXu0wFXZ8fERlmbzaaljqCMBWeEgQSKGTOlKW49jUAqbn29Mh4RhpGMzm7dJDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpsBP/3PQX99Lvpx7tXcvU+9r/A78N2O94dG4uhFEWg=;
 b=rpwDR7zMBePpIfDKJcGXZSlzUsy7RRioYbk/X/MavVUBKGxyJW+X3OLbwQnxbrH9fcZqq72wF5TYp4dzJxGEhG/ePbN84S0qK/YW4PJdDbE0NRnmNnysDh+X5gO8v5Oe3Vk6Xlm2yc/Il7fInwyuZKoWybNlBOARnkqBDAO8yoM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5148.namprd13.prod.outlook.com (2603:10b6:208:33b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Wed, 10 May
 2023 09:51:49 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:51:49 +0000
Date: Wed, 10 May 2023 11:51:40 +0200
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
Subject: Re: [PATCH net v2 4/4] Documentation: net/mlx5: Wrap notes in
 admonition blocks
Message-ID: <ZFtpLCrVYbTf1CSg@corigine.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-5-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510035415.16956-5-bagasdotme@gmail.com>
X-ClientProxiedBy: AM9P250CA0001.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5148:EE_
X-MS-Office365-Filtering-Correlation-Id: d67b4599-ea2d-4fe5-94c8-08db513c2cb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6x6NXriOU/fZx3fktYKHoD/95DS1fD5J4NiRllHv/NaYdeqv1t0bvxwo+nVbTjAdX1BY7yPT8p4WpPpoCou3y+OIDXkYgjydn1uDRqC3iragQExl5vMvDwglOeTIk8oCNwGxO3mFkP8Yhcy/4RgxOYbN545LW4Jt/ncvlbUDnjEt7FnV1hDf4jEHc6gc/DunK54TkAbJ7NJFg9LuWYtPmbWhZ7UghxsIUmLdppYORnpBoltcLXr5zZOrsECy84QkW0dWzd+nY9MHtf2gqZ/BuPCkkMFLdCVey0/KR42M7OIpIxK+AR+jcazwe8CY3q3wGaiuum10OYVh/i2nV1iOyueNy/zJcBDy6sIiT2li22wc8iFQTNay5u1KF7NaPJc7zQyFgTc3dc7PbnawiFXH8YthG0YfePLIESPb2uwla3Sq88yzful6fd+CDd6sBue8Gvrr3wFAAuP+VbOJ+LqnSXk9PbCQadUhaMuSLJE2zkJT1KgqzfnQaeojG0bNhqi859yWRJTMF4rDnc66SvhMMEA968/cT/TtY94g5KuooUB6zsPSDgoR7CHKEYxydCdL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(346002)(39840400004)(451199021)(186003)(6506007)(4744005)(6512007)(2906002)(41300700001)(6916009)(66556008)(66476007)(316002)(4326008)(38100700002)(7416002)(8676002)(86362001)(8936002)(44832011)(36756003)(5660300002)(2616005)(54906003)(478600001)(6666004)(6486002)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qZVWvzJMbRct4J8uUfHuSsq2UAWoyXmXXgzXSET3/it4IWmPfZGrPdFflkJu?=
 =?us-ascii?Q?IF+LIyo5ZYrYTlveToitir/wvmyweIUhHtRYXAKmqt+qQgCGCZJqMUVnP82P?=
 =?us-ascii?Q?eQ6HZO9JRAugilMXnWoW/2ZkAmPgNRrSaaiBwOIB2uAhK6aFRCzVzDPVZEKW?=
 =?us-ascii?Q?xmi0CtYlwRnmO7iKTZQREXcyJOwY+e1/9i4OnpWJ2609Gj4WT7Zonk7sFNg3?=
 =?us-ascii?Q?bL/NE/DqKzP/6C1rJ9T25A/+1Vjy5s78YAmRsnXdbrNJmzhbUoAO2CV8rBl1?=
 =?us-ascii?Q?+CWJAetQnSaC0b6nAjAKpi4BI1Dn+ra/hCYmYADTEDHb7LuilR68ZLRhjKL3?=
 =?us-ascii?Q?OsULO2sw0hulYGM74KLzZe1VAptF7rpR2eNxePtVKXsG0/I/z+lLVbXT4rXj?=
 =?us-ascii?Q?FyebLyYv267rN/IE7x/qt1x4nfqaa1Es9dupBukKEVWY1A7wjtuHR9HfrfU+?=
 =?us-ascii?Q?Ac9tvQ3lGX3JoohcMLMTVrx9HAh+gyiXMB/pVHuVtSHE60OsWDpJ5xLhJj3j?=
 =?us-ascii?Q?T1fisBarlw4p9SrxRJnZ3sgcFr097K0jvR7kjg2GC66EyB/4pRh22CM6WXDX?=
 =?us-ascii?Q?Jhieaz0sb4tp3IQRVTcRdPYPs3lJ6fiNCvy8JPYzFmzW6KjHl/iJK9HQxnCf?=
 =?us-ascii?Q?CMNEerqDoCkNnsdqGkh66wvEzlfCLAgDJ5pUcJFT3BenMpMOVKx2UAVF4CqK?=
 =?us-ascii?Q?w8lWDfWuId3cYGatF6mapyRFwKErLfpSDn1fSKygLbo7vWvHq5VULO5qQagy?=
 =?us-ascii?Q?3AnI4xZXATNcNEQXEr/fGMvgkL+pjWdGIuAtWac10daY1a2bZADdZ5SNOeIX?=
 =?us-ascii?Q?NuDvMbNsDDGklsCt1sNca5pwU179kFueZ4VeaN98pIfz+18sq9EE/2HxaqbK?=
 =?us-ascii?Q?EJGDImRp7QMvuYTZ51byL0A1DSDLwuegJWQDCDuPPeLIrTkjyRT1sahoF7w6?=
 =?us-ascii?Q?dAXSfOFD+B6LSBohg2nSh4mvZokin6aOy0gvsce0BRit7rCNtp5MVosxmfL2?=
 =?us-ascii?Q?n/hr3VMiPagObGgrXIFrdT8PH3dGgFbjQ9qt104kNhgpEh0ayBzTMMAXeYLW?=
 =?us-ascii?Q?6zezEhQ6ItbEbQ7Sbp1L4Spy597fuaMhkYsz/nOACX2w1Ees6TosA0NgSxZC?=
 =?us-ascii?Q?nxM5Zeyx2tA8ihxzBm8KsGp97um3/qJi9mPvBa9YNz6oqTgp4LtZEJJXBsG7?=
 =?us-ascii?Q?2qMmyiKgUJ6d3Ude2eoU7opebpGkTmjTMuiFm30C3fYYKu8dXwmd1sbyYAsl?=
 =?us-ascii?Q?VFtWoQLyMM2iVdSfKrJaiFDu0EwLoiakdM93HjbolvAQHy3fJK1+CxVWVpt2?=
 =?us-ascii?Q?EM7X+F5d6ElOqqKJ+Ccwf3QuE3WPfFB4OWryeQVSUtmD+vrg/IkSFlwG31o8?=
 =?us-ascii?Q?1cCvGYyt0UbDlHtJHibxgnRvaSx237glnc4oV1o1NnTjYjmQhlxzkCgaWAE9?=
 =?us-ascii?Q?aunBYy1xD4leX16QPd9kBCC48HL7TDrr2D1TW1pzRwicOmmt3b4/SW191BfR?=
 =?us-ascii?Q?vHwfytHyu6wHOmojtITXhsYyKACmYZZh0J+uuC09pUHxQ8rQISuVISWk8iky?=
 =?us-ascii?Q?OGfJNotrkU9aiwuftrTjur2sSWlqnHaMJqaExqoOf+/0eOgFHl2JtkElXxif?=
 =?us-ascii?Q?xjyMoF8AM042YHz6XNevvaj3nrKDEernk1ErneDASi1C5+PWMHY8U6bakAEO?=
 =?us-ascii?Q?tCyn2A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d67b4599-ea2d-4fe5-94c8-08db513c2cb4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:51:49.4812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DX2EXsIWlZ9Tlt0SIFpJK0c1i78eF9bdh2dcWm2pq9u1uMXXu+ISOxWFuUSREeJ4TttiRXXgpK9HZGtrH7D2o+WeAJhmBbbMq5Icefhdy8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5148
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:54:15AM +0700, Bagas Sanjaya wrote:
> Wrap note paragraphs in note:: directive as it better fit for the
> purpose of noting devlink commands.
> 
> Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
> Fixes: cf14af140a5ad0 ("net/mlx5e: Add vnic devlink health reporter to representors")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Hi,

I think you may have missed one 'NOTE:' around line 213.
Is that intentional?

