Return-Path: <netdev+bounces-10176-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E307672CA62
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 17:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D3E6281179
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 15:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD9251DDEE;
	Mon, 12 Jun 2023 15:38:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F81DDE1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 15:38:07 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E54619C
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686584282; x=1718120282;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8Lwm14Dc9gjC7UITtJoWTNU5d3Am9WODA4Cyz+JjmhU=;
  b=eTzbVcPlMTW0xVgfySJRiKJKhI3Tiw//WNJgwf3S9DsqhNm9mS36p1GL
   msOKg90qQCOeZOkfiezf8gaTJ06PPuXUP70h0Ay0WnS9ZUH5IIPVRcSd8
   aeKOj4VFPGUrWxgnb7aLguFX04Q6Gam0WkLk8h1y12Qx7PVbqm88S8RKY
   Mn9OzMZRVBFqzBXHLCEgPc8Uf0/zm/YafiCOZPyq9CmTithQ1oVV16LRd
   qBnb+la1F4o1g0LpfV8EfzGXKbOALhdAqF9KPMY0cAfi6jKy8w6lEUr9x
   bTVOBIbEjNMkA/8y/ydNlCWj0GUb6O+WXK596/Tr71rxexbrjuF91P6XP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="444458573"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="444458573"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 08:38:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="1041396353"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="1041396353"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 12 Jun 2023 08:38:01 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 08:38:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 08:38:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 08:38:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h/w240Sl7Aa4UKCwoyt5TC+8Z9wxoYn+DtkVR2lCbQnrlaf1DiaCantS1xfd7vJwcSSPIJjaGglefwf+hh2flAMigBAqx9Jfib/10rS2fNlS4FLNQrwOejM6pc6P99wZueJ7Ag9MEW29A+Z4xTnKuCqXnLpE7V7CW86r9va3Ld6symDpcSoAacSSsOgcRIVQPmtdwFkcmVr2Kk7g2WFWpjvVQ7oQFCS4tZ0evXZhgATUicjm8i0WMsKJJY240XNE5JpZrCAjEr78ErHBGap+lx8R9xPNPrnoHB5TAH9XqwX8Xr9vheG3t+Bw8/fODWhgDPAlglIur5/cA6zRmBBJrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/RMugDV+eaIuY7vWG2iVsqXqxy97lkyn0T2UhySYy9M=;
 b=ZAs9fJVmhADyeKXOJ1/SXUi8ZiK5Bhz7KDIeopb2UCNFprtRca7fYwcOk4jQ+aHTbhX4cZ+gONqPlY7K4aL8Sc2NNzTgZZYpktNFBVLProV1LgsgPkwcBtj0MolE/P36+99KTKysNg9XHyv6mguPM3aHTHEmVWuHt0Ex4o1jsGGNBVnAOs7PLJHmAuGWCm8zSCMvYnxApXMfzOvnmUH5TZ20fTHvmLG+qGdFuR4V/YO/7BVKPQwX1iVTZ8L2zj1K/aL0jHRaJXz3LrnKpaXH42nupFM/uvU8EQuNUys0kS07uAABb1ymiLo+GoU5zrHV9EjHjoQHrohYlUXKCpTuxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.38; Mon, 12 Jun 2023 15:37:59 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 15:37:59 +0000
Date: Mon, 12 Jun 2023 17:37:47 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
Message-ID: <ZIc7y9PdEdyCBb9r@boxer>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
 <20230609234439.3f415cd0@kernel.org>
 <b4242291-3476-03cc-523f-a09307dd0d08@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b4242291-3476-03cc-523f-a09307dd0d08@intel.com>
X-ClientProxiedBy: FR3P281CA0064.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 8676193c-fb28-4f13-fb8b-08db6b5afffc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jCA9PXAXuiaE3Nq167ufA4mhXArxTb9Jl7svKM/2zy/SBTsqR78pOtz4J6U5dFo7z6/nMo36sGGjVwTtXNm7wa5XjnoXDxVnKczc7fgjkGZA3IxnNEKAGqX+ywjGOKNucH4eR0qci4yCrOE4eLxja/FI3XrNvCGgBevv3gZ0lCGlrrQLqgMEMk/nQ75OJgX0oMaiWH0CCG1xoZ5AyWl+l/AST6p+7JPssLWF6Fm6uKr2t5l1Lgmw8KTi285cR+RLI2sJurQLgxpMlz7EthaHQ28tfIQpTyqK3XZ1cs58dDWe3ekxq5418mXfrJlcHadz+tswJCXqhK+uRGzjE4FxWrVGviQqt+Eje6jN5dUw1OLfxnqau+VbhA4MpmZM4CDXRPAvZqrBT80ato/hj8hwpWP+w6XuNf3vCHHfgpcw1hWjVFRSAZPqmUiC0LAcOJ323DkIxKJH/vKKcMpL/vcfljAKJbOKUpjH8aANi958aymhqIe8c5bHbV1DIeaFgjsImopR2kp6gvBBFMdlZRXDVXfjzn5jUC9m/VyxPEvT+rGDP7UFQ6sdVeDbLU0Cyflx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199021)(82960400001)(8676002)(478600001)(6862004)(4326008)(86362001)(5660300002)(316002)(66556008)(66946007)(6636002)(8936002)(38100700002)(41300700001)(66476007)(6486002)(4744005)(6666004)(2906002)(44832011)(186003)(33716001)(26005)(6512007)(9686003)(6506007)(53546011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t+lUvSDrl+9HeJEqEbtLr3duuCjmF4Xw0DiHrY9nItJy9KvGtfukjcW3WjQW?=
 =?us-ascii?Q?Cjh2NisY/+m1BNufzClFdCzpitN/M/bl3xHJQBUzobmvvCcEvRuIgqD8DLWf?=
 =?us-ascii?Q?gwMAnHUbW7QFIYtYDDi3+MQbMtjV2bZtoxdGGD1ATgMRIHRxzDW1DSCBOIyr?=
 =?us-ascii?Q?EfUSmr88fjBFfnvt9uvTzl27KuIix7u16dEirIu0NF7O2om0KxozY919oKwP?=
 =?us-ascii?Q?cevlUkSMQTJMzSTywlkUPHHhSAbCcVfOerR/rP+2TMINNagyat9VplKAgS47?=
 =?us-ascii?Q?l8+GNlSpeckDBZ4Z2m6xQ/QZA2pN+Jspd2/s1wkqmY+/s0+7B5uhhFMfoiBT?=
 =?us-ascii?Q?96loE3L4ZOhdwgS5L1whJpREDZ+TUBtKFK3EvLKnjkJjPTtZxF2OuNOcPL0r?=
 =?us-ascii?Q?QPomkqU6QLW70TjJu3+4ne/wwI86aV9f6yJlEVrB30RBdRI9kGIChbERuLjF?=
 =?us-ascii?Q?Cmtj5vX7hMmec7vosS2D6ZJR6bOBZXfnV2wnn+tYVi/nJ5eOki5FfjPdZn0/?=
 =?us-ascii?Q?hjZ4fjbxLHBhRETda+PLmoeQuo9PTVMHbrHPN+K0VBzz91phcy1yrj3UlgPr?=
 =?us-ascii?Q?wzTxEeteN1nKuy3Ty2qiw+Kn8Bw86OiMISbBLiFlw1UXgYr3v2YRsetvejRZ?=
 =?us-ascii?Q?G7heXGJIAHPrYRno4x3vspN/6tjQWfQXseKrHWLbiR4OJqSJ17yoPXbEZLEq?=
 =?us-ascii?Q?GpppW4TFrdCJ+pjEf3yu352IOXVMCNWlxaUV1Pd70C0Tb9yDprOv5crBpx1e?=
 =?us-ascii?Q?BFXvg1j+KcWvgTGxsu0pnyQPomrBJYZztG9mAeG988mnvVpxcvTkKFD8FCar?=
 =?us-ascii?Q?JoIPJtrJWcNtASb6meJBfsC9U9frF9IkiDLq7PMuFpIRcbx0NbdkeelctgKt?=
 =?us-ascii?Q?NXKnSE8/tytBsdH9YuL66gxaI1JIau7mytT4F4vNIai6zUNNCoEG6KdgTG8j?=
 =?us-ascii?Q?Bn5dBVeZ4LvYdprGkbpTpXwztmVcrtMpLBAEGeFpH2FRrwturOcyIu9qSIoQ?=
 =?us-ascii?Q?Y7wlq65appEPOWbH5TrKZ3YPlTKS63nwiWsfV2VeKRnudkiH/mLQI8mRkXLP?=
 =?us-ascii?Q?bUy5vC+l2k+UWrJXn4m8IJFb6dh5pU8zf2zCwhC7OI6A9NSmO/Y4o30hrBn/?=
 =?us-ascii?Q?SuJegH/Y7msi2M0WHQMLXudOSIw0lPfVb0PIM58UekKJL1tRTwjoAtEOjuHn?=
 =?us-ascii?Q?ASBcPj+9KBR/o2e36j7McfHktXlSvjhCesaefoYWTiZgoEk4xWeEZXHOIFip?=
 =?us-ascii?Q?2MCsZsHT1GCj0nL8MPXLX5yUA1mMUtEY0npCgNKqaI3q9df5AjYszT3HGC2k?=
 =?us-ascii?Q?zlKxGhBqHhaM5q5zIQ7EmEjYJ6KzlYfXLAmqM8/CskU+S+1bh8j79Wjc0EZX?=
 =?us-ascii?Q?dxzPSwboptkVzVSFb40jhAzl/K/oU3PXV65GV30jRHpN1WX468OkCg+V4DOo?=
 =?us-ascii?Q?PRsfYU8gmw7AjBsOVYRmABRHocLeXy+ck+6vR5SM+3cavcaQKfE9/J7sOQjl?=
 =?us-ascii?Q?V5TzQYD1+Fg2A+UI9Nr3Pl7Z1h/ttRXU0xgxYdvk2pMQHUCK8cwDOfTmRT9B?=
 =?us-ascii?Q?EQ+2sPCmszpS+GZP16jT9pORoyUvK3/fkYzn5PN+zAATxdOt5QyOw3Rr4wIu?=
 =?us-ascii?Q?CA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8676193c-fb28-4f13-fb8b-08db6b5afffc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 15:37:59.0745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csm0vsQPcGaBnryXt+dz5jSVtUSjYpB3DMu4yjbAQnXvY4bcWUECAku5LiKcJch6oeKWu9jUaNMAPjY/qmlH38vQGdPf2IJASEdij35PZDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 04:49:47PM +0200, Piotr Gardocki wrote:
> On 10.06.2023 08:44, Jakub Kicinski wrote:
> > On Fri,  9 Jun 2023 18:52:41 +0200 Piotr Gardocki wrote:
> >> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
> >> +		return 0;
> > 
> > not every device is ethernet, you need to use dev->addr_len for
> > the comparison.
> 
> Before re-sending I just want to double check.
> Did you mean checking if sa->sa_family == AF_LOCAL ?
> There's no length in sockaddr.
> 
> It would like this:
> 	if (sa->sa_family == AF_LOCAL &&
> 	    ether_addr_equal(dev->dev_addr, sa->sa_data))
> 		return 0;

I believe Jakub just wanted this:

	if (dev->addr_len)
		if (ether_addr_equal(dev->dev_addr, sa->sa_data))
			return 0;

so no clue why you want anything from sockaddr?

