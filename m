Return-Path: <netdev+bounces-9874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 944CE72B055
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 07:10:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D82361C20A76
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 05:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B417B17C1;
	Sun, 11 Jun 2023 05:10:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A259215CA
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 05:10:28 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C7230E3
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 22:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686460226; x=1717996226;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GnXHWNFS4yzxJVO7VAhjh4mu/+Lzlin1D0H3aBvk/Qo=;
  b=b5+d8OMK95WNG9riECcBUKgUt6+Rp9Fa6b3Lg4zc68fK+06D8xqEXEOf
   rOkBgCRmQFcPJTdYbTLTiSo+IYFpglsrJC8s7WCTbgPMwm/4hXIRiBCgd
   yGqNCYRtYl/20YAN9eFhP3Y/CewD0UPwugpi4Qb5X0+S4NLTn/Gq+eUSr
   zvI4Si/JdRz6zZuFyZBWCSySXWg9Fb5xaj4Vw3uFq5xv6W1WGB4rCmiFH
   fPU9ZcvUizBzAIZdXDc2JEVmQfySsJpvmuDqITUSiGq7/HCeyaAlIMhGG
   PKuxa7uGnZhwmitWRIa+Wg8fUm+Anq7/+HgXrKe+AsweMSpfQdWAf6b2n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="386209189"
X-IronPort-AV: E=Sophos;i="6.00,233,1681196400"; 
   d="scan'208";a="386209189"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2023 22:10:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10737"; a="1040932750"
X-IronPort-AV: E=Sophos;i="6.00,233,1681196400"; 
   d="scan'208";a="1040932750"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 10 Jun 2023 22:10:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 10 Jun 2023 22:10:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Sat, 10 Jun 2023 22:10:26 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Sat, 10 Jun 2023 22:10:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbH6xKvkr7XZMcWKhKdGXXVG9EJaxOpcMJDCuyMjzdOzeK8yE8/jFIU1gqfeX01Tf/ogaXLgx8K/cvlQMfFY0I/01FUZ9VMJw6WGqiIVCo7H+SuAjTK0VjVBcLmc+q5b6MHpWbCVDJFNx3wKiSO+DdcYs6W9jLuQT1AJZyu5G5WgDvoPWDdcw+4UiS/6+bKWLZBE++9p8+iOxq7aFS5MVG1ughii/orR4hIgZqg2VvZmQ1/gUKZyqAiS3ddQn1wTMzqEWZn4M5wKzgL8/PmQ1LIRpvOA4bwtzFgEPPxHMvNuVJNgOPc1NB4G9QSatVPfd4BO/aJspNh7rsu8cMJcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJko26y/MgQy9L8IDNR0r2bgOHopRHnZckEmyE11bmg=;
 b=lAhG9UVlr/zIdmTRb5hKawvDEnEgnd5SYDAtqFmsW8eFW9VHm2IiHVrsXN7siWYkTxIOHroK8LDQNgPBLloKhfF20o2U9osvMdfTfhXfux91lEhOdqx+AhAiwFMa3lFA1Yu73mAVcK4V2FZZhN0MSjfuB+HNmzwk3j1WISSWujBB1n+c329kymuF6QT+JxC01GL0dl2jXNZ8UVIshlUR+bj1IRTkVTbe68kCkdRjI7Cdp+IoF+e8iudK4RNMVO8dA/z26Fvm09FK/lepZ+RrExw7E5XaPxk/Dx5zNNSKVR10MeglDP/lKq8mOS0sgKj0o40GbpjSyg+OGsJjDYFVYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by MN0PR11MB6057.namprd11.prod.outlook.com (2603:10b6:208:375::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Sun, 11 Jun
 2023 05:10:23 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6477.028; Sun, 11 Jun 2023
 05:10:23 +0000
Message-ID: <c8ac5a24-3ade-d8a8-5135-c3aac57a5f54@intel.com>
Date: Sat, 10 Jun 2023 22:10:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [net-next 14/15] net/mlx5: Light probe local SFs
To: Saeed Mahameed <saeedm@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC: Saeed Mahameed <saeed@kernel.org>, "David S. Miller"
	<davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
	<edumazet@google.com>, <netdev@vger.kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Shay Drory <shayd@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>
References: <20230610014254.343576-1-saeed@kernel.org>
 <20230610014254.343576-15-saeed@kernel.org>
 <20230610000123.04c3a32f@kernel.org> <ZIVKfT97Ua0Xo93M@x130>
Content-Language: en-US
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <ZIVKfT97Ua0Xo93M@x130>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|MN0PR11MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ecd34c7-31cf-44ff-2f03-08db6a3a28d3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xI46p0NslE+XBp+jj2Jke+PLgzkcTmUcogWYpo+9bxNgqeg54Gvqme5hni+QUea0W76vorHxdzZFWwCeNGF10sfr9JE75fQfaPVYunjkV9NoTnxyMIEO6t9TZsXTqtjQNqCSAhkjQvDOPYqQQRPLOFkfSgV6D1R5MWxgQxZvllECODC5VN3JENolQndkZP4zyujkd1m9pXmmqcYjWdYlYi/65y4IQpzIRD48SxU8K2TX4l50Ct7hGMmdOQkDgTj0evgk44oY4NxSeRsFxhKH4ijwgDfJU+kTGIJlf1VFsTKCyK4Clh7SC0V+b3kt+TctTzucPakypHwiJEHfi+TH8ElB7WymMZt479h8OAY4HhvgX7/5XBlFoDv+ntEbzEofKIOpnWDPj6Y5JgGzjl80Swup8xjgHZaqWITWT6rMby65ddVQj7jGRAimzj2QRvuNIIWi6GCPX3Pc1/YenBHwFpLxxC7Z+A2f90pWz/zqMehCE1HVlST3SckYnsweSubAAN4B0UXjoiRsznm2KZkvck+diGVZSxACQgrn1liA0nwfuTdC2t+KhT33PNG32zsuMv6QlsDlkKnq7nWatCMlBcytqo9RdWv/G0/S0IhVRVO9HUMWbh0cHsQUrJPknL6OJINuvQFekqjBMEAYtv0tIg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(2616005)(6506007)(26005)(6512007)(41300700001)(53546011)(38100700002)(83380400001)(31686004)(6486002)(6666004)(186003)(478600001)(110136005)(66556008)(66946007)(54906003)(82960400001)(66476007)(316002)(4326008)(7416002)(8936002)(5660300002)(2906002)(86362001)(31696002)(36756003)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGdrRzdVVEtwakI3ZGVCUDh0bEo2cnJmTytSUGdScnU5VGhkTTl2TWt2OHla?=
 =?utf-8?B?NDNSclpjeFdXMWNDZkRqZllKczZEc3QybndrSTJmUlN0SDEwNnhRY0diNEdw?=
 =?utf-8?B?clc5ckdIN0M3emI3Yit1bTRORGU4OTFia0wwSHNKdG12MUJORHFGcENiZEQw?=
 =?utf-8?B?ZTFzK0l3VVcyRlBCUUxha3BIOG1hZUtsWmpqR0FwUGhnY2crTy9hOFhxVzQy?=
 =?utf-8?B?ZVA5eEpkT3V3RWtxM1Q3QU41TC9JZHRYeG1aWlkyTnBuTWRscXFrelFyNVVw?=
 =?utf-8?B?TzQ4UnFRYS9KNnBQVENrdjRwWFoxOEtDcVpUdUIvUURnZ08rVVRWRytUV21T?=
 =?utf-8?B?Rjd0TlVPVEJUZm1oWGgyazU5NnR4YW41cVgwSExDcS9USEdBN1l2ajhJVkxQ?=
 =?utf-8?B?WkVlTzl3L2MwYlIvTkVGZUtlNys4MFBJT0ZzZjVLdlAxV1grb2JWenRtT3RU?=
 =?utf-8?B?MEJuYitYSW55YTNrVGRINW9qN1lWQVBnczVXTjhFOFJ4U2hXempGaWJzZWps?=
 =?utf-8?B?N2dwVjZhYjZVQXdBN1VqbU1pZ1JUeXJia2VFZDAxd01ReDI5MndWci9TUEZ1?=
 =?utf-8?B?Vk8vOTFUdEhVeSthK3YzTmx1V1hnV0VLdUIwQzYwVDdkWXdpL0hxM2ExeHh0?=
 =?utf-8?B?bWNneExqTXBFT3Q3d2FMUDQ0Si91dG45dFc5RlliQloyTTllVkVVNnNrLzU2?=
 =?utf-8?B?TGRxYVNmYnA0RlZXYVpLZ1lPdU42TTFOSHQ2UWZHRytGYUtaMldYYmdoZ3Ey?=
 =?utf-8?B?VVAzVkVzTzk5cXJ3YUYwUDFHT3d5SVBMMG54NlBvMzFNKzlzV0diVTMvSW5M?=
 =?utf-8?B?MjNRYy9tMnFHajFvRWRBUk9VN0xLM2daN1hBa2htenBxYjRwbUM0VDVRTjJD?=
 =?utf-8?B?WE4zWitraHlKdVdLb1V6ZVpWaWNlOXBOSjhQVXc2K3FIcy91a3dSV2VUYTFP?=
 =?utf-8?B?Tjh1anRTNXg4NWFIcHU2S2hjTVhUOE5nMW9UYkVPZlVRR1BSQjY0RlJNajlj?=
 =?utf-8?B?VmRYVytIZHhTRzdVMlFyczVOajhtdXRuanQ1dXdkaitueUM1NUQ2UDQvRlVo?=
 =?utf-8?B?NVRTM0JEZW9BVzg2UTMvaW16TC9qelFHRHU5d0xOb1A3cjJVS0VzTjRDODZX?=
 =?utf-8?B?OEZ2RHdjcFpmbDdneTF1cUpBdFhIU21lL2FkM2UydDNYSC9kOUlQcXJRVGVU?=
 =?utf-8?B?RTEwb0lab3M2bkxjU2g3N3FMWE9jY3RZd05nZFBoRU85V0V2TjIvRTNUVk4r?=
 =?utf-8?B?ZkJIajdhRWVzdG5ERmhRUStKYmlQdnZEWm8xWUJZWEtqMHlBV1paZnMyMG9q?=
 =?utf-8?B?d2J1S3FWRE9YWmNkRDJqOFpHZHRkakxUdThxUDYvSTBhbjZybUZVa05makdn?=
 =?utf-8?B?RXhUVm93eU1LRXFMaHRjdElJbjNQMlA1ZU1EK2xUaXVoM1pPVnFhVTR2M2hJ?=
 =?utf-8?B?S3ZUQUVDT2VlSjZ1VklUZUpLVnZwSi8wK2YwYW1xQmhIQVBxTkxDZEtHZ2tw?=
 =?utf-8?B?eG1wMVhTQjlieU1vcHNwdmZXeUEvRnE1d0UrYzRIVHl6S2VnVkV0djJUTnNG?=
 =?utf-8?B?RmQrNy9OUUdOQ1RKeWtxZUZrN2lzWjFpMTkvUk1rOVZFdHVyeUc1dlRBWWpN?=
 =?utf-8?B?NW1kV2NzUHlDdnl3ZDB2SXE0RVFlU3lxMVBZeGdyOW8rZm1zZGFxcVRMMHBW?=
 =?utf-8?B?QmhpRXliTjlkSTFIeGIwVEVVZUxWb0NHbGtaaGlBQVBWWkZWSEVJdSszaUwv?=
 =?utf-8?B?QXRTYTdZakRyazU3M1l6R010MDdmYkwwcFVyME9vNnMvLzNRWXVzcmxITVZN?=
 =?utf-8?B?RWVISTBNcWZpaFRpc2dXTWNNaS82S0RHTEdaeTNNVnV4cnk4OHZnUGdEMEFa?=
 =?utf-8?B?TDlDYlp1aHN2SjNjV3Q4V3k0c25XS3kzYU9WTm1sNzlJNE5jRGI4TzE5MWVy?=
 =?utf-8?B?M0orUTR0a05XK21Ib0Q5VnNVN1Nwai9XcjhOY3d1SldUU2F3R1JNaDEwQlQ5?=
 =?utf-8?B?SFlvUU5QMUplRmFPSmdweGtad0JueTVBallqRXMxcFdQMit6ekw0R1NEQks2?=
 =?utf-8?B?eVEyb2lJVW9VblVjdE01RHROZGNlb2UycGFCYUgydGI5YXFCTTJTMktycXk4?=
 =?utf-8?B?eXQzTXh0Uk96cGpJbGNlU0xERGtxZ1ZPK215YzBlTkNNb2hod0I3QVllZ2pY?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ecd34c7-31cf-44ff-2f03-08db6a3a28d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2023 05:10:23.1530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CbO5I3MJ99Hjs43hubtA7/Whr2J2MZL6VIMjHiKWybzA1FcSm8QvXFbZ4vq38RlgzwXTPstSHerL30M2k1JOuoA5iDj9651blX2qOC2qxT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6057
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/10/2023 9:15 PM, Saeed Mahameed wrote:
> On 10 Jun 00:01, Jakub Kicinski wrote:
>> On Fri,  9 Jun 2023 18:42:53 -0700 Saeed Mahameed wrote:
>>> In case user wants to configure the SFs, for example: to use only vdpa
>>> functionality, he needs to fully probe a SF, configure what he wants,
>>> and afterward reload the SF.
>>>
>>> In order to save the time of the reload, local SFs will probe without
>>> any auxiliary sub-device, so that the SFs can be configured prior to
>>> its full probe.
>>
>> I feel like we talked about this at least twice already, and I keep
>> saying that the features should be specified when the device is
>> spawned. Am I misremembering?
>>
> 
> I think we did talk about this, but after internal research we prefer to
> avoid adding additional knobs, unless you insist :) .. I think we 
> already did a research and we feel that all of our users are
> going to re-configure the SF anyway, so why not make all SFs start with
> "blank state" ?

Shouldn't this be a devlink port param to enable/disable a specific 
feature on the SF before it is activated rather than making it a dev 
param on the SF aux device and requiring a devlink reload?

> 
>> Will this patch not surprise existing users? You're changing the
> 
> I think we already checked, the feature is still not widely known.
> Let me double check.
> 
>> defaults. Does "local" mean on the IPU? Also "lightweight" feels
>> uncomfortably close to marketing language.
>>
> 
> That wasn't out intention, poor choice of words, will reword to "blank SF"
> 
>>> The defaults of the enable_* devlink params of these SFs are set to
>>> false.
>>>
>>> Usage example:
>>
>> Is this a real example? Because we have..
>>
>>> Create SF:
>>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>>
>> sfnum 11 here
>>
> 
> This an arbitrary user index.
> 
>>> $ devlink port function set pci/0000:08:00.0/32768 \
>>
>> then port is 32768
>>
> 
> This is the actual HW port index, our SFs indexing start with an offset.
> 
>>>                hw_addr 00:00:00:00:00:11 state active
>>>
>>> Enable ETH auxiliary device:
>>> $ devlink dev param set auxiliary/mlx5_core.sf.1 \
>>
>> and instance is sf.1
>>
> 
> This was the first SF aux dev to be created on the system. :/
> 
> It's a mess ha...
> 
> Maybe we need to set the SF aux device index the same as the user index.
> But the HW/port index will always be different, otherwise we will need a 
> map
> inside the driver.

Yes. Associating sfnum passed by user when creating a SF with the aux 
device would make it easier for orchestration tools to identify the aux 
device corresponding to a SF.

