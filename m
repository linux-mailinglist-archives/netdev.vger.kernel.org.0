Return-Path: <netdev+bounces-1490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B3D6FDFA6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 16:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30310281531
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5921414A87;
	Wed, 10 May 2023 14:07:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADF920B54
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 14:07:30 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF6030D4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 07:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683727625; x=1715263625;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oKdNFQgbLx38kM89JhgmzX8CHGOFmceepP/tOZRcD2U=;
  b=iKDfiYpyjlSHw1qqFNPrfxnVxjgzBF4EczVgt1zb4yy8qpZ24cQbTBnn
   vNdBvhxaFj5UN9TCXb7PKDOjv7I5FTu/qw32dFnNd6mbsXw3grOcj+xd+
   vvpO9u3Hi2ynSNLuWCoI6aCLzdDQp2wm5ryNf6hMPjt+0bFVsd0BEOCYd
   d2dM9egG9t/oOZdi0pTOeOhtbolHBJmENtVVwDmGlwmxO1NuaTC/9/M41
   x/+tyfqZiY8AlePQ7GWW1Pya9kzTDDdJqgkCmbkenweRXxLnmGX+lFe1d
   PNsbWxBszDx2hrezvtMPyGJl2JBBl99UUqwDDBYw2tH7qlf0rTBC5Bq91
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="349053720"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="349053720"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 07:07:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="676861360"
X-IronPort-AV: E=Sophos;i="5.99,264,1677571200"; 
   d="scan'208";a="676861360"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 10 May 2023 07:07:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 07:07:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 07:07:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 07:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFmpL2HDr2Dq2Uq7VFPL9db5NrT+wJuuHitzL+LhCsueocIb5SeCunpfAlHYmytr6KKBbhPJvcJL2Baawh/EOnMgtkOMaPTBBEWW4VBLtQjBF1m5CPJiHlHXWE/tKOOlJc9ckpLqyH97ZnWpU9UAgyHREaZCFoZSkZgHSsg0RYWfnpUuzCAV6/6+i4oIQJ9qqu8HxMAb3PW23w9Vf8D0KUJ/2vSlXIkwAWgE9+0vw+qRJpl/xQI1SkIRfPm6TmjoflBJwVQD+5ItV1NeTlHy0j4MQUlUxGkOj9sutCC4AK3nmVMGau36pu36sw5Z1Q2/F9RZwecaQ4xMFbNWlrD/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5T7U03DLxZn0urfBx7OWr/HYsVc+1U1GuDVAqwaVWY=;
 b=bMR5z9MaCBEwx2He/rLq1nFhmG84XYaIvFMNPDyiKOqEViYtPIN7CbEKwC5SEf3CCbJSC0NmLg+yBwz16vUet2zsPscIYM+Xjmn1dzJMlzW64et8W2/u+ZFK8ir44+oupJ1OFttJzQOOLb1INKJp70tlMgJYQ7ue97K6yTNSlCIOFM29Ffx5Q+jc2tW7qlvD4URgcrBtm8odWrpO+BoIkveqegRy9rDSirH6NnSmid3OSyPkQC8/3fRj/3P7/+hCYwNbfdQmh4HV0kq5Ijb6N9YyJYUA0at3d4lPqY4nKUt4EiZb3Q+I03FV9UnJsjURgbNrHcxtau5iNv1K7JeHoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3882.namprd11.prod.outlook.com (2603:10b6:5:4::24) by
 IA1PR11MB6196.namprd11.prod.outlook.com (2603:10b6:208:3e8::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.32; Wed, 10 May 2023 14:07:02 +0000
Received: from DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::f99:9d80:fe32:f458]) by DM6PR11MB3882.namprd11.prod.outlook.com
 ([fe80::f99:9d80:fe32:f458%6]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 14:07:02 +0000
Date: Wed, 10 May 2023 15:55:02 +0200
From: Pawel Chmielewski <pawel.chmielewski@intel.com>
To: zhaoshuang <izhaoshuang@163.com>
CC: <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipruote2: optimize code and fix some mem-leak risk
Message-ID: <ZFuiNol22xxd9Ig7@baltimore>
References: <20230510133616.7717-1-izhaoshuang@163.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510133616.7717-1-izhaoshuang@163.com>
X-ClientProxiedBy: LO4P265CA0169.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::6) To DM6PR11MB3882.namprd11.prod.outlook.com
 (2603:10b6:5:4::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3882:EE_|IA1PR11MB6196:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5a935b-403c-42a2-a442-08db515fd3cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BXXiGUbwpEgZJkPUnedsPlAnVreQMSeNl5lRZryAX/sx7JV54gqFkGhlzuaChGYuiQCx6rm8e6gOKMruqBqEL23pGbOozgvrH1QlFAdH0tAkydxSbMY2nORTICSW9bvLQmaHpckfNqpQmMO8ECTIlmILhAZlDcQ2dUz8Pc9Q9qOE/raEJBWZ4VAm/Mm56ebJHdD8VKIJGf2TqPqlboC7RFCtIri8N3FTtrxPUe3LFfWeWWzpCz2b6sN9AT431+2C62CiId9Gnyf1Cm6u9TVSPmvTiNPjTaBcgtCQcjF3lXhlKfSkkSrc1ZPhd4CukS2A6dlbYx35k66TwOO/j2D+DXlYp7E2aA0fYF8JCcxl2I/HvYJwA6r4ReHUNYjandSZbXRAONtmLA5rMffYorvURkjCU3+BNa3MyqAXf4glEplB4a9xC2hCDX1mfc9sp9p6RILiECJYLL/V7p7FqFFvBHXhUZthD7Q0F7HpEep5zkJTPaMjdoXN1zeSCIGDAABjSFQc63b4OCzhNdjb0bzX4xV8hGFplV/mseKD1I75SchiZSSkSoz5cII/3w1noefp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3882.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199021)(6916009)(4326008)(316002)(478600001)(6486002)(66946007)(66476007)(66556008)(86362001)(558084003)(6512007)(26005)(6506007)(9686003)(5660300002)(82960400001)(41300700001)(8936002)(8676002)(33716001)(44832011)(2906002)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4rUxn9N9r11i4vPYGMdL8OQw5X2S+DgEFTh8L8dApnRmbYUt4C5Jo3Nh3caH?=
 =?us-ascii?Q?iUoFMUJ+axLwKvGPqAfKnfNFdUxPgYRr3ZxIeSruOVyQLdWOGBh/TNu2ZWxr?=
 =?us-ascii?Q?m2gfjmi4qSWW9FXcLHkgQAhzS3irHCEWuJy74iOwpdycTU0YBT4wnQUnXeEV?=
 =?us-ascii?Q?ovyKbd8/n1hqRLifJsc6F93RtgO4eF66k0EmAnA4w7ZH0pLpurlN1UQiFALB?=
 =?us-ascii?Q?Rdp334B8FwKZSx6vC7kkmo6b7t7Unk+MtJOYK3bnesVyz2eX74tHKh45CMrR?=
 =?us-ascii?Q?2wdLt6kJtNRkYGxQ29DJZmnwTQCPd82nl1XexedBbpYS/RiMWfudDv50zqYm?=
 =?us-ascii?Q?ZeuH3St/+9rZM5zj/hd14xMLc+rsmC7tRcI+zWN3FYg4lkOMksXwe+YRIsmB?=
 =?us-ascii?Q?c4cXcvYrTj/Ws/nmgE5aqepiynhFgTRBpl1UzuubS8cC1xrVou6bOhKsDv1z?=
 =?us-ascii?Q?YAxh4fvJ6rqci13PLzop77iQER97lD4OsrqgT82K30XsnHD1PqvWqq0kAZu9?=
 =?us-ascii?Q?lUTLZgvDp/zKR7eLOqxPxHjuBLIldMjVJnbn6wRkmBNcW8QTSO3G5K0vOBWH?=
 =?us-ascii?Q?pZ9HuCTeBU2COlWhlwOwvA3SsoHbvh8mo+ePysSip6u6KiaGcvkM6xkgGgCu?=
 =?us-ascii?Q?mWcQtdhC68hK941LhswStNC2qjZuqVBrPgDjJA4zpTrzopW6ZdmtADmsbk5Q?=
 =?us-ascii?Q?NK1su9+MgQZVQOdBjVQG07J+UzGGjtD2SzpO67DyCWT/+po3DwAOutaQ/8hr?=
 =?us-ascii?Q?3YHNXBJD+uj9pQ4TfCIXq8r5r6lFcMiW9Y6pYDn+6OhTxAAfqaIb+TwkNcRB?=
 =?us-ascii?Q?CBBIXPiFO0vhPmTjxkjWIkduzerkyTwYWB+B0QGVEy7m9xmsnsQLtdvtMr8V?=
 =?us-ascii?Q?rcksHVYK/oGPkWK0qjXx+dYyrjK4eHX4+tQETwtQxxNpAC2i0w7LZ/3HkXIu?=
 =?us-ascii?Q?YZbOVZ7NmVKF6r/TImsWxmQp2KtZ9tdhANHjbTLzf12ZqxAWikbj1aH1ER3f?=
 =?us-ascii?Q?o45RfI39AJHyJ2qBoDIFPdjHAbUy5bhdUpk+FGWHOH1QYNPJW5SblBkYHLYm?=
 =?us-ascii?Q?8G2HQWERNfcoNX/QmiGKOj1lEUU7AsGdtazgfWcRe5R9ZBrBQTUUAmr5ETZp?=
 =?us-ascii?Q?E5ZMK8pMA5fO3X+aRfaAgnYlqGWR2h1cAhC0JwqPBzNtG4rAJUjfPaWhavYh?=
 =?us-ascii?Q?joDTbYQjAubCJw9YeGiO/zuUnio8rM3Mv7kd+2+f3HJjWJB9KM5aFWjIgFfY?=
 =?us-ascii?Q?ioFL+t67OEja9SCBt9NJMbM9XVI0tmY8o7tMZylOgAjf9wxH8ucOlzzAGm3C?=
 =?us-ascii?Q?OeN89BF0uMNwM0evUpHF6UnSZkNbtSy+ZyFjeboEHlPlWZaQ8NhaD0TVIsRR?=
 =?us-ascii?Q?/z0XEyahAp9IB46mfpicj0uH9oOwjZoHVTGkaWcjbKK3r/8B+tTMuzge2vei?=
 =?us-ascii?Q?vTxfkkuSUuJ03AbaGkBhVMzuoWpMCelMp10ncZ4UEVr/rwmcJNd6UGiZMHE1?=
 =?us-ascii?Q?5ZWsFmizbUHHbanecdD/yvo5o0zqYKA0UKtzoGpxMXPu1h5kWMuE12lmpM6/?=
 =?us-ascii?Q?s+elipvi7cJmMi/pZlPMpq0l+DarTcyZOW7IMWfo+kPah3qYNqVUnMS2TazZ?=
 =?us-ascii?Q?3A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5a935b-403c-42a2-a442-08db515fd3cd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3882.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 14:07:02.1537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4k4xQlD75RhEN08mVFUWS+W2tPt+suzrKErMkYu4lCEgPG5IBQazTDg7l7CLSFkc5uHNZZ8awNdx61A39z62S6LknY4GbwXOcgCZVpKAAbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6196
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 09:36:16PM +0800, zhaoshuang wrote:
> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <zhaoshuang@uniontech.com>
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>
> ---

Looks good to me

Reviewed-by: Pawel Chmielewski <pawel.chmielewski@intel.com>

