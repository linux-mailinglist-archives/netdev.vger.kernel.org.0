Return-Path: <netdev+bounces-7435-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A06B720447
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 16:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E6F281546
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 14:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57A519BA2;
	Fri,  2 Jun 2023 14:23:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A9991951F
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 14:23:43 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCDB719A;
	Fri,  2 Jun 2023 07:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685715820; x=1717251820;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sfdG3qRmvSz0Ghz8wujMZVfKxmAwIEB7IvtgN1/gSUU=;
  b=DWuDCyXBQ4ByG8I4tqzUMbhKK9wFxieA3m+CeFGxFZk2IU/QA/em6x4/
   p3NIoGMYnpmsNsUEgKnXt4pcU1/NKOTB/9tJpwPiT7m3Q/XU/cSqGkmng
   8oVLvGAbrcfUmXUhyn1DMFVq3TlsJ8MfujgsvvbQ5HUsrD8njrIHTgV3W
   QyHDNrxAorgky3UjGXiOpyUCb9WFjvt8HSl3//D8gfn+kD0ojul0fPYKg
   MQpe5SMYvVzjatiqKaG+yIaSRnVmGAB7eIV/VtNz0Tg3NKegd4lo9a567
   vh4BQYqFXsQ9GZ/Xi4JgxBIPbKvAqXebzHGYdhDCu6Gylx8qVQ+egrpBp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="345455010"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="345455010"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 07:23:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="737555336"
X-IronPort-AV: E=Sophos;i="6.00,213,1681196400"; 
   d="scan'208";a="737555336"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 02 Jun 2023 07:23:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 07:23:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 2 Jun 2023 07:23:39 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 2 Jun 2023 07:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zu4vkvspust3u78DqEcTypQ3Mejt67U1aZ0f2jSi2G+lT7Hqh9439pp2NTVcB5cmYF6IM/zftu9/SW+ztztkOlWq1e+uii1p5/uVildwsDq0ieuySyQjdZhEeH6r3v2i/kiP45vYj+W4Fv4hI84W/DDlDyx/bOLZ3MBhsu7XelfK/wQlqMuQYyxvWWFXPvE+Agnl24/g9AOFILBVGd5YUt1QTIHWi9OzS++9qqOZCQaMxXiH1y/AhEI3daNxk89KHnNasp+OPX3fOo6d7vRbKfpD7d3/dPd5Cg6U2v/DcDB9QP2/rEuX39DV4vlBjcOtNMDBryicEYYEC4B1/23tgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eoOASFs6JHiXWoZI8Rtt6UwC2i9ZzLozSdqZaqyOaZc=;
 b=kUh7lCTwGraduRtlDQrKQpPYdjtTAgivRXUxQPfGo990bm2wz/lWnmfN8tvT2Bq0bPQ+j2vYPh6F9Iw+7P+wh3UMQAkvvX3lYSl4e9pWugI+TfgM6QFqsncYOPf1T7Z4FI0KyucRGNc/APjJ2pklCgkixE6iciSeDjzgvGdLlahhHw/+FXPjM48mdx4UVbkkP65yc0zjFU/iVMyzGIpUSZ7GMn98wBqwtIEeXYJHhPfrmx0FUYdxdchlvUca+3PASv4+J87WWLBZV5fnjxiPUHuLFCnJc7YuP35jA5t+r/FYIEwS/sQesrM9n2b0Lxwd4oRivDLnQlQMTW6q3QDQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB7413.namprd11.prod.outlook.com (2603:10b6:806:31a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 14:23:37 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.024; Fri, 2 Jun 2023
 14:23:37 +0000
Message-ID: <3f6cd784-767e-02e3-0c30-c0dda12e51ab@intel.com>
Date: Fri, 2 Jun 2023 16:22:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 0/1] gro: decrease size of CB
Content-Language: en-US
To: Richard Gobert <richardbgobert@gmail.com>
References: <20230601160924.GA9194@debian>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lixiaoyan@google.com>, <lucien.xin@gmail.com>,
	<alexanderduyck@fb.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230601160924.GA9194@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::14)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB7413:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a07b393-9dc6-4886-b3b3-08db6374f435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L8c8zs7O7FHAB8PoN3ZfloWdiVEsVTkAbRmhrkNk9smtJAS5tuQDKV6pYkgwEm7IRBlNn/eSq5yUmwB/eK4aAgrqQ8wbG0ORBuckdKyLfAKC/34Qv0EDH7MrWv0rtw0VsxqyGLViiiDcmy5PyZvvCg64GRlG7cMj8xrVJ+fBZw38Rspuo9DWVnaoE4btZmxMo0xxtAI7rnPSDCdqIHV+00/4EGv0XV+X9UkoK4B2ilzwEBaLiZ9goqDjyCYkQxToI9ftb3tupUDSptjbJdni+L0SP5hSY0Kf3SIFpoyztWbY8GB3qud8/jteVEX0nyKfG0CplnzdBN64DB9UPAnSpJJ0hmMuTE1s0WUI0CzpFMCweiYe0LdBxx3qFqo8CYILyuvXXI79QCfD4HgUHlHtyNdFR7hw9IohgfM1NvhB7E/VQNnYqDQVQhpvdqQPpk+ckZmvkpgSOOSvMhTgMFI23pHnRK8xmqYOGXls9scXdCoX2bq2u5edwUZPb8e3VjjJoDlmNh3WEVUiX6JdvkGqY+C6wazeKIL7jDYnEGyl9SvWRdzCXL/lF2ISbZvsqqCAWVo0JF0N+0xKy8/R799/4r0ZEvoXpZ1GgGxWf0+US9RQYatuBUB3vbm+nD81VjPS2FZhxIimf+fB92m0jkzTlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(478600001)(5660300002)(8676002)(8936002)(7416002)(4744005)(36756003)(2906002)(86362001)(31696002)(6916009)(4326008)(66946007)(66556008)(66476007)(316002)(82960400001)(38100700002)(41300700001)(6512007)(6506007)(26005)(186003)(83380400001)(31686004)(2616005)(6666004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnB1ekMxV2I2c25laWw2TTJJTjlQdENmUjJKdkhJTzlablBXeW81R2tEcWxz?=
 =?utf-8?B?cHVQVW85bHA1dzZIVmtTQWZzYWxUYTFIOHdLQm83UmlLeWg1RHdKdTJ6ZmVy?=
 =?utf-8?B?RFRNK1BsMitEVW15bndWK0lWM3V2VlpsbkJLVEtqeU9XNk9kV2c2d3NKZERF?=
 =?utf-8?B?Y2o4c2VLTUFFRTJkMnlROW1tRXlQaUcwajJiMmZ3WVMrTFdXQk9ET2lndzcv?=
 =?utf-8?B?TDhyNktMS1RVQ25sQUU2RmRkRURtR0RQdVdHVUE2NXBVUHN3YzdkT1pDbUZJ?=
 =?utf-8?B?RXVNYU93dm4yam4vckVkTlJYZE10VWxTTmt2VlJQVTZteno3N2xNcUNnRGFr?=
 =?utf-8?B?RkFjVmdmS3VCemN5WVlaNER5ZjRuc21ncElubkk1Nnh3Yk8yMVRNRDV1dnRE?=
 =?utf-8?B?dUg5WFBQbi9sWTdDNXRhcm54WkI4ZEZuRW9jNk9zR1RSRUUzUXRMaXdBeWE2?=
 =?utf-8?B?NzFseTU3dlBNU0lHbGprU2RMcFR1L0FhWWZxN25pdmg0L0RJYzFsSEtWWXR6?=
 =?utf-8?B?RHpONGNHdUlmaVJLL2hlb2w0T0MvRmd4dldGYTVuZzVnRU0wNEVGejhiTDNp?=
 =?utf-8?B?SVJMM2dRbW9uQUNFRGtiTitSMnNHYkw5b0pPbzVYRUJhdllHZy9JTmcrdEpS?=
 =?utf-8?B?bGJ3MGZranBOcURPZTM2SmxidzNqN3Rhc21ROTBQZkFVaHE0TzhiYm1mbFdj?=
 =?utf-8?B?Tm90K24rVjJ5Z3BaQThuNitMSmc3Sk41Z2d2Slk5VXlnV3hBZkpweGdwSlcz?=
 =?utf-8?B?VU1GbFZFNk1mN244Y3RpQjRISjM1TWtPMjRIRWxwbHFJS2czR2tvMjlVMzEx?=
 =?utf-8?B?TjRqckZ3QWRwV2JEYWdWUlZBTUhTSEhKS2I5eXNwOVJHV3p0MWNVVlpVSmJU?=
 =?utf-8?B?dW1Db2t2YlRPaFFMT0F4b00rQ2YvTWt3NzJPUldxazZRenltNEQ5ZkJPd3Fx?=
 =?utf-8?B?QmhxY2xxbXd1SXJlT051c2hvQmNMOVJ3YXAyMHNQZSt1MXVQaXo0alcvK3Fq?=
 =?utf-8?B?d0M5OGNPaE1ocEhSdUEyOXk1YVhWdW1RbkpHM3BSTjRPRkQ2UjJVQ0o3anVx?=
 =?utf-8?B?V0dwM1NoQWVBRjFEUVdtNXp0aHhSUytqREVVUTNBWHpyQTdvWnU1MVRJUlZE?=
 =?utf-8?B?NmR3ZE5vTGhHL2RoYW5PTDNxN3lqWmRmZDV3aE5reXhXZlZOaWRVbjI1bjBz?=
 =?utf-8?B?b3h5Qm93bTdIWWkvZWEzeHlvMUNBRVZOT2V4RzFudER4dE9HN0tFYUhaOTZ3?=
 =?utf-8?B?UytxU25obk5xUm8rS3dCVGVVQVdld3VFZElDSU5ib0t5YzhYZHRzZXQrNjhl?=
 =?utf-8?B?WmdWUUtkd2hvQjBFMGVNM0dZWEowd1JIbTlBQnMrOGxIWnorQ2laYU9iSkFk?=
 =?utf-8?B?M3h6dDVUQnFsb1ZDUVhhYW9tOE9reGNyaUs2VElyVk1LcWZZSm9VaFR3SDls?=
 =?utf-8?B?bzNrUWVha0JsRVc0R0RIWHhPNmJJR2NScFhTdkxOYlJ1UzJ5eDcvVWtZNHND?=
 =?utf-8?B?TldVNGpFbFFTRU5yVXNYT21oVkJUcGh1cDBEd2p5elNHZmlVSHovY0Q3d285?=
 =?utf-8?B?YjRLT3dPalVuTVpVWDF5a1laL3lNamlWY1ZBNkxOYit1OTFSRnZpNkNiakZE?=
 =?utf-8?B?YUtwRDFwc2p5bm8rVlEvVE1NNk96RVFaQkZWQXNJSzBZY3RMVEFvd3grc3Fw?=
 =?utf-8?B?S09xWFRaSmdKK2xiak9ka1IvM3B0MDQ5RmkyUER1bjVXYVN2S3lWNUdvMldK?=
 =?utf-8?B?VHRDSG1CeUh1L0xyRmE5U1J1VlFsNzZVMkNJYmIvOERvRUxCaWJHUjdRaUwr?=
 =?utf-8?B?V3pDc1ZDa0Z5eTFOYXhpVEwvbWRWNE1Ua05rUjN1UXQyTTFIdWdnNktZaXRH?=
 =?utf-8?B?QVBRN29YNFpDd2laMjFUYml3NEVyOWVXZGtUTGpmYTh3OEZ5RTdvNTlla3Bv?=
 =?utf-8?B?VHJqWFJTYUpqZVpZaG9kczE2SUIxNEFUQzZPTSt3K2FBdG5pRnJQb3E0c3FT?=
 =?utf-8?B?K2RBU0F4ODlxODN3TXROZ3ZoUTd4eG5aeCtQcTU5U1Nqc1hGR0NiNmd0V0Zz?=
 =?utf-8?B?TGFsMWVHTytmSSt6eUN1Uzg2YnJqdWJjcFVxejVZY3ZHVlpHQW9WaTVPWlBY?=
 =?utf-8?B?QTluY1N2dzJyRzBRZWd0N1FsYUpocXQ5SFBqTHlPQUNnODFtQ0Myam01REgv?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a07b393-9dc6-4886-b3b3-08db6374f435
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 14:23:37.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hT9J6v6gFhW9G7CfiPJzlrae+M9PN8o4mU+sA39kbqLKLbBfz7V70SccTTLZpijN47QPk5+RTxmvCKzPa4zu2lOg+0sNSBn0Aw4s6gGnVn0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7413
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Richard Gobert <richardbgobert@gmail.com>
Date: Thu, 1 Jun 2023 18:09:28 +0200

> This patch frees up space in the GRO CB, which is currently at its maximum
> size. This patch was submitted and reviewed previously in a patch series,
> but is now reposted as a standalone patch, as suggested by Paolo.
> (https://lore.kernel.org/netdev/889f2dc5e646992033e0d9b0951d5a42f1907e07.camel@redhat.com/)
> 
> Changelog:
> 
> v2 -> v3:
>   * add comment
> 
> v1 -> v2:
>   * remove inline keyword

I hope you've checked that there's no difference in object code with and
w/o `inline`? Sometimes the compilers do weird things and stop inlining
oneliners if they're used more than once. skb_gro_reset_offset() is
marked `inline` exactly due to that =\

> 
> Richard Gobert (1):
>   gro: decrease size of CB
> 
>  include/net/gro.h | 26 ++++++++++++++++----------
>  net/core/gro.c    | 19 ++++++++++++-------
>  2 files changed, 28 insertions(+), 17 deletions(-)
Thanks,
Olek

