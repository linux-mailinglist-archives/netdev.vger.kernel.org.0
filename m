Return-Path: <netdev+bounces-1887-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32AFB6FF678
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2E302818B4
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:50:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3C4654;
	Thu, 11 May 2023 15:50:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC85650
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:50:20 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6510565B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683820218; x=1715356218;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ftSAJNPZS1yUgroWl54PzA3DdUEfjPJjVqGSEEObMmE=;
  b=YdT47hg2aEHgD6jApxmt1oeu4Fq4mQ117nxMyEmG1QPt/5bv6oGxSQjo
   LcpODd2b4tNW9tpSeMESu3mQ2uAhX/WrE9p7ZTlsuPdeJpkgHEvSJ8w9m
   /lNbnVaO5UbM1S1ppu4X9jb3vBuGbxzXYcWRxJksPoRlRsqrzqYs2mlKU
   2IO1Zbt5V5/Hvjh2OUHFGCSPMRwZWnI23+DcYlfj5R2mD/XSfoIC6ujDy
   QSFQ7T12vSWLuaWdOXYKVHi5Phd/H25OPBdXla2ROmMWfDsYr6Xi8mVbA
   ftDF00V5bLEk3c43/yHjTiSTPEG7KydSpfrkvX9mSCBhz7wX3Bzh/UUg7
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="335048145"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="335048145"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 08:50:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699778189"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699778189"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 11 May 2023 08:50:17 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 08:50:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 08:50:17 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 08:50:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMpkijJ4rIV3gNY3svi8zDL0tlrbeGmcVQmeSrmOyky9dniAd40nFEv8d2v55lbHVg2oze2gEM7tYtr8c+tKsoUb8qufNOe9eVxwn9fNxHWAWhJhFjyYlXhGR8H0oFTCk2EAAy7M0734SzXMMcOtlD6hDbA2wk43WLDqPV9H8b7JDDiJ3tuB4bnufRa4Jjf79nD3OmVybBwzPIzoIRSO9v7t+QV0s3G9j3/Xb5K7Ct+gE9YMgJt0tDBbEorTR2pklfojo7XlIgUU3oUOzM1NL00d2qNAZeke8p9rwlOsXvjvstav0SQS7skOwtgl0SEQ9BT83G/X3JEUt6XAtQRXow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Mr+9IASGW3IKczLqu2/r8FMqmmuImsXFxDxMfDvZKE=;
 b=FkUSV8VNRVgvX1Ebp38KWH/HRMXSjzpCm5CB7XJrHl9hHdxkPj9eGMFtRARFue60cswR8RETciPSNzKw8rOmm86Nu/7x0xMbKyj+cuaue5up9d3fQvmcuhUQoYrapi00VJKDGeSY4E9MEKWJ4YNUocr90btFLjO1kpVKI1y5xKQKhOcMYNXxci2jUrq/KPG016KuUiO9UetfFNONBGPHhBW5Xr8jUYZgk9mHDA+VO5KcocgXBxw3P76quHapypGnmMML14nbOXUNxnjPsso9Zoc+CBfOxrUQcWegqTQ+vBNTsaBVy1Nbd1xtjzlau2kODi7XG5ViIJsKridkU/Nc7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3882.namprd11.prod.outlook.com (2603:10b6:5:4::24) by
 CY8PR11MB7361.namprd11.prod.outlook.com (2603:10b6:930:84::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Thu, 11 May 2023 15:50:11 +0000
Received: from DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::8961:99f:96b1:8a1a]) by DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::8961:99f:96b1:8a1a%3]) with mapi id 15.20.6387.021; Thu, 11 May 2023
 15:50:10 +0000
Date: Thu, 11 May 2023 17:38:07 +0200
From: Pawel Chmielewski <pawel.chmielewski@intel.com>
To: zhaoshuang <izhaoshuang@163.com>
CC: <netdev@vger.kernel.org>
Subject: Re: [PATCH] iproute2: optimize code and fix some mem-leak risk
Message-ID: <ZF0L37MBUbkD8ytz@baltimore>
References: <20230510133616.7717-1-izhaoshuang@163.com>
 <20230511003726.32443-2-izhaoshuang@163.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511003726.32443-2-izhaoshuang@163.com>
X-ClientProxiedBy: FR3P281CA0199.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::16) To DM6PR11MB3882.namprd11.prod.outlook.com
 (2603:10b6:5:4::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3882:EE_|CY8PR11MB7361:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c1326fa-8c63-4bee-f706-08db523766c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t+FMvQZc8+UbLdMc4HTNJcWxILas6CEWRoJrRBQNHDr4gTiQQSO/DBChnz3tfhaD//oltBKhmgOx9Jm8QoRr6xrIIC41ia7/7RnUKQdwBFRfdfNWi9Msm0HgNOCedQ+65gqWLKB6nS4EbJEBrXJLEW9WQFrZLNTCKw95zixUK9M4jPUHKTocxLL3IYVmuKOPU0kNyp3jsaGokxVLCg7FEc2FXXnryrWUC704LMgOcpH/gwR8T1jzlsNY5YNMDGvujQQuCUAYik/fk/XycRBl7wIz4ATJb+BNE3V3R5067di2A5hLBZxNIevOQtW5AeOW8s35Ft+96Sjzc33eFWY7atdynT7SRNa3aTCp0Dc7bIV701N3bJdxcXGg33S1G0BMLu8tP3WNuIVUcU4AOricy5gK8Pp5GEXUADEPLM5Jccbf4PzJPSbtRhkqOg/3yN4EcbmdzdyZcDc6EIz9n0nm44jgD+n2ELZopRRKe/2K9bpAacN69Vngs0Di3QW0QSk1Oa/MyC3+//iYFFS/L4J2KPEo/1iQ7O1AG2nFb7Ed1RRoAWWggNru3jKaRy9oORem
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3882.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(366004)(136003)(376002)(396003)(451199021)(478600001)(6486002)(41300700001)(82960400001)(9686003)(38100700002)(4326008)(5660300002)(6506007)(66556008)(6512007)(66946007)(66476007)(26005)(86362001)(44832011)(6916009)(6666004)(33716001)(316002)(8936002)(8676002)(558084003)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?69SsBN96ZHVG/EEbFU8u48o0jZinMX+48LYdQRb7mCR3Tf0VJavalrbxTNxw?=
 =?us-ascii?Q?ZP5bMbbGEMGCoSl68gxVYZGJvDxjYTLWUFvQYOjcqwTQy/TlT5aTel52vYsA?=
 =?us-ascii?Q?mYzSECRKlncFFZGg1ETekZjZcUcItu6uJT/WGt5+tI6c8HrATnbXqbahFh3B?=
 =?us-ascii?Q?5i+893F+iOW8kbu+mOifJjQyPC4/5DOGqhPVoGdb9B4mfmKqg3IZYRJzfGU3?=
 =?us-ascii?Q?B8rQwrkQd6fiCGZp/jI34A/pGzmCVZu4o8mdSRhSapqWs46JhTO+q6Sm7EAV?=
 =?us-ascii?Q?awes00ycUzA1Lol95J4AF0v9zss2oycxPI4uFmMhKCDFSs7jTwAJtfO6Qv5K?=
 =?us-ascii?Q?kp0ClBHCaPsVAHjmU2h+OU//mcC89z8b9NWvTUXwlawzIgXWK9hVNxz8/A/T?=
 =?us-ascii?Q?e1mgql3sJqmtN/4IDbN/+395FHu97L3eyI2xXdolRrggODHr6rwqybGKcgHS?=
 =?us-ascii?Q?Q5XU8lyPWa0impN1NSF8A00SSImgDGHsxvY3QDH5qCLfXgVU4j+rzMfWzE1S?=
 =?us-ascii?Q?dO2ATlpNssyoe2DMWhpulXOfZUfVTeJV6QZSAb+TFxNb1ydhEvN2pWY1YR1Z?=
 =?us-ascii?Q?stoCs4g9bnd2yvt/vEqWUwnM+gURTEs2bflCAtvnLWzQ3og1Af7VNjCn1ZtZ?=
 =?us-ascii?Q?0CBUXq6p61zkk41DSn0T+/ZhTNGYFJIPsCYS4TN0B3x2f3mAMln8uH7HhEqu?=
 =?us-ascii?Q?IZ0cETrtGQChBFx8ONWfUdMS0EdoN02vvRMwCRJHLrnTcZlEoQsIdHpV9m+f?=
 =?us-ascii?Q?hs7e5lepG7O4fbj8vtrCrvbXy/x2YWjDnqjPebPTQzoeqMzfGQOYe4Gaup/R?=
 =?us-ascii?Q?zByhl9VyO2w+8jhSZS0qfaNrn2QlOkn3Rjycz9LDOBvl/iXli4P1piEPf2j1?=
 =?us-ascii?Q?DhPnP5cpoI60DQNqRfDKZ+7X6b3LXG7PndKKE3psoZKON1AvGQAQbl43qETa?=
 =?us-ascii?Q?6hbjvdH0tPb6VPg9Z71mcO9V4JZzs9CmOBpGaI+Pn/xIg8SJGQPC7V6mVUKK?=
 =?us-ascii?Q?Z9dDy3QOePmOEGqfCG7P25pLK6LP6MivpifoBVwjIgb44rF/PjDUDyMQ+Eec?=
 =?us-ascii?Q?UNl2+XbCpZiL4qrcNdEOKPQuNjWAL9oDIBy/o74Y1CpEWZd2zsCJ0K/sGi8w?=
 =?us-ascii?Q?O4qbhbpbpGC9OsLM5eT4VHFP6JkVxobGcrUgPzD4uFwZQuV2sTRywhH6WE62?=
 =?us-ascii?Q?RluRsSfmco7OqoYyfgR7I/zRkOd/1Ash7RNbGI17rN/9nVJYU3aG2222ZOSz?=
 =?us-ascii?Q?n/wt/MXWkR7XSFtVCpaDQ0zZQ7obTR+LrBW9HG2fSA8x3d+6cGrb7ryz7SMf?=
 =?us-ascii?Q?sA3qwYDzAC5gfSmXXUYljTbjJAnEHnZl31qHlRP2WQcm71K1VV1shMlBSYtD?=
 =?us-ascii?Q?MTCoiU0X8iwhndrbYqTEzTYirkgNdCSyhee8V3kMIPtqiRXSXAgJ6IZkeEhx?=
 =?us-ascii?Q?gG9vN7wUcLgW7YpDx9pLcaVU2r9zEkih4BAhhwYsj/GFPf2tJppu7vBnuQ2q?=
 =?us-ascii?Q?pEe1rygPaJWUNgvyBloQ7MJzRZ/LBqs4xPDTlWWd5rggKwSl/2Ii3w+AVc+u?=
 =?us-ascii?Q?TZZWsNwa5nl5L8ono0LXthd84DMWBlKNcm1mZy92iGr71yNgVqcFZOpDy3G0?=
 =?us-ascii?Q?Wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c1326fa-8c63-4bee-f706-08db523766c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3882.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 15:50:10.5152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkCDLpIqJNC+JeWZuhh9z/BzPyJsimIZ58LwxZB/OhjvgClf5MpW8pbzkdITefLCA6gGpQT4ffLu+MtlaEgle3qOZcznt5wYy0byklGElFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7361
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 08:37:26AM +0800, zhaoshuang wrote:
> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>
> ---

Thank you for fixing the typo

Reviewed-by: Pawel Chmielewski <pawel.chmielewski@intel.com>

