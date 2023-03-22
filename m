Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FD06C575B
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjCVUTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbjCVUTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:19:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A2F97B40
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 13:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679515744; x=1711051744;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BVTHR3VL5J6R0pyN8qzoAVYyMtrhursmwITMNnmqSrQ=;
  b=I5cqfytxA3dvajF2t/+iirajArH9DHqVwIwa3G+zju+tQmH4Rhffi3hm
   DD5ORaqb0i0AjTlh5RldfUBCSm29fxi7Mw47vAl+kuboRGzc8KCxbvfLh
   +uS3qx/gsy+do8JpF7OD2w1qGXsJCxl5YygoEuCrN9vHdK8US6/rF+Qw6
   gDVWIEuO207AYNWDHr7B/IDc0GguTUvfTmpoi8QPFvzK+++qazhIQMqcX
   2gR+A/k0rHoblEiGDB7AIXgoXuukmNUsw0QpMf8jp4EPTtEOSk2EYjUuM
   kCUS2JqumllMGBtPJMy/d95GST073jWsQwMumVaf2PqJxc9erT62piCvI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="340860033"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="340860033"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 13:05:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="856237392"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="856237392"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 22 Mar 2023 13:05:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 13:05:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 13:05:52 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 13:05:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCye+yPjqL+cbCZufZiBA3zooDua74jfSrj+bXCwCWvy8uuOr+6ut+/7QjEXpyK83WLxUgqIn8FsqrJBuLwBoUN3XYed2diGhdQl+E1wjX9aa9kBOctElAfoXdMh3khItICuYEdSI0YGqoOvnsvZzlJhUi8XWHoAbvdd56+33+5EVkmRE9jdkxz4T62z0LZAO4y1kVip27Dz8f51EAaEIqrfHVQ8QyhXSnU1j8iMuI5546HZYV1LvtZhCNG2lwVEBA3oYSlc9LMVeTRbVtukSijpbYJNvTYN6GoL2jjS07YsCj7ZHXi/FVWHhaxlrFZ8QRZuJNGHsjRfohHL2A/GWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eGE8QsVTFGxkZ7H+nE2KFviHSyGS+rUnBeBryHhwJNM=;
 b=YT7DdOx5dzl7qC73tlyafSVK9fZe8BCa+PyraJ8JrDvy3FehzTGOH/BTQX2aBlbRdMzU5UiQHTHf5/ahx6hHKFncgg/BG0TJHeg6OEK7ZbMyxg1dK9X1DtcLReRdX6F+9d7LOiScvRTVnFQ+b8/kXByq3IYo4w1tqpnY/p2/YJIiydEQSRnHC2MBukI/ie/HadY0kUnrXX684kjXJXlILsLLJZo6dqiJmfv7vgCl1PzXfgdDvfOup02zNucx5D8l264tzP2BBeUaKI/EvjHVK2Wi5AdrW366uIUGuc6WI9dCagO5otZulPJIfmhRXaEHmdFJ97ZlTGnqH9RhRxkyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by CY8PR11MB7364.namprd11.prod.outlook.com (2603:10b6:930:87::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 20:05:48 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 20:05:48 +0000
Message-ID: <b8e7a0ba-af07-08a8-b987-f82b17f8c69d@intel.com>
Date:   Wed, 22 Mar 2023 13:05:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 0/8] ice: support dynamic interrupt allocation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Piotr Raczynski <piotr.raczynski@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <michal.swiatkowski@intel.com>, <shiraz.saleem@intel.com>,
        <sridhar.samudrala@intel.com>, <jesse.brandeburg@intel.com>,
        <aleksander.lobakin@intel.com>, <lukasz.czapnik@intel.com>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
 <20230322123706.4a787946@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230322123706.4a787946@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::14) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|CY8PR11MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: fe852cc6-0a3c-433e-4e62-08db2b10d3cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThkOxgnncKhnHSYX46IJ6Q78PzWD++lruMSPb+MYz7V7wy4mVtK46urNKk4kBW9ZCCeapbnmKyPLC1wd1Woin7oBNEL9gvND07f39/E/LXkJsJUI48iCQTUf+03L0aw2s2IyZ1arci0lgQTJ3C2lia2nyvkjU/xs65H6oCJPIdgp8kDUgD1+BHqu2ZMcJ+qOjN1ALy64lb+pR6bi4LAecJ09VemJTDRFBGqoecdwP1+0K6h5CVy05rMUconYGDJUE8zQK1IBtTDC5xK7e91oaM+izQXCZI2rKUYiKiDzFCzRDG1IrQ1tKBkkfRUwEyh4w4JXYl9l7YZDbLcKbKwekC/lWXzI/pdWERoqY0KXjoXcCbrdMkp/8rFdXZkzcTX1NVmrOYDXqgf1oCIJBC/fmhl8UaAX+CzASg+2e3KjZkYMgD45LASQmjWhsV55Wgo8lmhl7hzUfH7D0NpGTA9pVSckJ/SotO70/s20ozu0WqU2LqrHEt3Epexi8WPQ6x2kBEfTn5nITXw1O/JZmlaXn31P6fGJka4LVDRcyzQzSf1Zi3tHDuxXqdwpSLJ01fpLMZTCptusYF9wxqd45Ln9RlUf9R7SAM6CIxax4JtfJmWtGNTH+XzGzcMgppSBjPZNt7dqYfF5hzHT6w6g9IaflykWr/whk32zgm+gj60qZSYzXC67JCC6fJTX5XararkAz4aPj7AuwoGsiuEoW82peZoW7lIwyVyKzBV6QM4U3Eg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(31696002)(86362001)(36756003)(38100700002)(5660300002)(8936002)(2906002)(82960400001)(41300700001)(8676002)(2616005)(83380400001)(316002)(6512007)(6506007)(26005)(53546011)(107886003)(186003)(6666004)(6636002)(110136005)(966005)(6486002)(66946007)(66556008)(478600001)(66899018)(66476007)(4326008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXdYUzhPc0s1Y3gwREUyZE01c3ZNWXZzMU1uWDIrTUNwSkRycGdveStzUElj?=
 =?utf-8?B?eFdEcG45T2VucEVqeXBPaTh2VlVtck43NlF5MkMrVmVVRURGRDFiMU5vRzkv?=
 =?utf-8?B?ekw5aUlNRDFOVjM2L0J5V0M3alJYTlAvOXdjU2IvNWFmTUpkR2JQa3ZOYWtq?=
 =?utf-8?B?ZzRkMnNiNWU2NGkxNUVkZCtOZFoydDcxYUpnOVQ5RHBlcWZacVREUk9KZDFp?=
 =?utf-8?B?R0kwWWg1OEQvQjBFMm43ZWJCYlQrL1NIbVVMZk9WRmtYSG9sQ2ptaWo4cjFR?=
 =?utf-8?B?MjhEaHBJeGhZY3NqSVZLY2RuY1FQdi9vRm4rRnROWTZSYm9nUmc3N2h4aFQy?=
 =?utf-8?B?TDc3ckt2STdSV1pvY054MTN5Rms4YnZmTm90QlgvU2RZYVVuUWRZM3UycndN?=
 =?utf-8?B?bXVsVkNBZEFkeDR1blFxdU93RXpDVzZTejZTSExCbWZSbUd3SEU1YXN0ZlRC?=
 =?utf-8?B?QUFBQ0NQb3NuWXdsYmZNV1JDK0hKUjhRQTU0anVwQ04vbWZZbHIxSVBXQUY3?=
 =?utf-8?B?TjY2blRQbVVmOXBpOFdSRElWRXVmUWJob29VYXhENjBneXFUaHpYQlVyN2Nz?=
 =?utf-8?B?cmhQYWlTQ2l2OElPRU9PMVl1QW5pNmtpUGFXcHVzMmNpNWoxdEsxYmx1VU56?=
 =?utf-8?B?L2JhMFQ5bWNCMlRyQmtqaGFoR0ZMUmV4YVVEVmVzY1FLUmdGWVI4VHVjLzFm?=
 =?utf-8?B?UzdqREY3V1VEQ0IyeVNhY3dtMkpQdWZ2UGhXWXVQd1ZWMzl0T05waUVSUDlh?=
 =?utf-8?B?aEFrWjdQaWlPWWtOOUdsNHpoTkNOenNYUHE5ZlpSOFlsdlgrRGRkeXQxQW1t?=
 =?utf-8?B?RFpjQkkwb2tFYjNocTgyckd6Y1oyU0ZiRm5IRlBDQTB2WHkvSm1iemNyeFZi?=
 =?utf-8?B?OUpXUm9naHB2VnVWTjNTT2JSM0d6Q1hqbmhEZzRJYnFmaGxXemdJSExjWi9j?=
 =?utf-8?B?b21Lb3ZiKzB5TERYSkFSTGlOcUlpWTcyMHpVNVJFaHJzUEt6RjM2SjlWUktW?=
 =?utf-8?B?RzdSeUVTeS9iMFdseS9ObHdFdzdaVExuNzMxbFNTQ1ZmZnd1Qno3czRDQnUx?=
 =?utf-8?B?S2JNMXF5b2VTd3NzWmIvbndLeTY1bi9ENHRmSE5Gai9ZZEtLN1BHRytob0hr?=
 =?utf-8?B?Z3ZoYytPN0xBRnpVU1VFcWFYQUNwSFFGQktiTVNTQVVaR0xQd3A4U1VEVGJH?=
 =?utf-8?B?ektkZkRUREdERWdJdTRvU2VaZnZ2YmhyeDlNVzRtVE5EZFNxNzZpaHhKRHlQ?=
 =?utf-8?B?c0E5R2VFVXJCVVhPYThoWm1iQlJrZnUzUzNuTWJGRlZwamcvbnErZkRmSEFL?=
 =?utf-8?B?d01mOVczN2xUU2dVQndFNm5rZ3Rpa0cwb3p0RUxseGhNYy9RdHlYNmdHcVpa?=
 =?utf-8?B?U0NudnlZMmcraFU0RUpNWjZTNi9IYmVPSEF0M2R3THMzWlNhWEFtUHJiQ0xu?=
 =?utf-8?B?bk5IZnEyT0pmdDBxSW5odTJoSDk5ZWZwSFFnZDdldVc4OGVLNVFudUxFRU5w?=
 =?utf-8?B?elpuN0QrVHMxemgvNkcvUllmS3dIdjltaE9Mb2svSUo3V042WUtmWEk0UjNW?=
 =?utf-8?B?VUlGQUhxVU9TOXUxalhPUXRELzUzdjVUYnMzYTliVEozeGZYbzkzeEdWYzc1?=
 =?utf-8?B?VGRwNVJjSk9jaXZFWjNrZm5JSWcxWHlucWZCWjJnSDRybHIrdWR1NDNtWjF3?=
 =?utf-8?B?S2xnYi9OczlidktSa2xPQTBIQklDT2gxM0pEZ09ESThMeitjVjhvT0RmQlVk?=
 =?utf-8?B?SlJzd2NGN045MUw5aEd6ZDFiWlhIbnA1akNIekFGbnhScU9qM1ZGRFEydXVn?=
 =?utf-8?B?MncxTjRIQWhFNTFjSkpBcXJzUCtzYUhXZ2JUbm43aEZUcVN5SEk4bjd1cGVt?=
 =?utf-8?B?U3hLa1FITDB5RzR3c3FzcXVZaU5jWDJ4cWZKajk1SHB6bDVVUCttUXlrc0lI?=
 =?utf-8?B?dHYrS1QvSjh0Z3EzSzJHd2ViNXRLc1dIU3BBdURRazk4U3RoOHN4dk9MN3N5?=
 =?utf-8?B?bTUyYk45WitEWmMySjQ4RkFGQlU1WnF2c2Z2U0gvaGRYVXhDM1A5SVhCMjJS?=
 =?utf-8?B?S1VsRWc3STlEMlVyUXJJVmRKSXEydFpQR05VS2JRRVRmelJCeUt6WllTQmlM?=
 =?utf-8?B?ck54V3V1RzBPRTNkeklOTUt5N1l5S2EzVUE1ZXhJNnNLNmpLRGZFK2ZuWncr?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fe852cc6-0a3c-433e-4e62-08db2b10d3cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 20:05:47.8137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aCoVD64oJA8HPCOxWlkgk3YJdt1wYZeNrY+soMbExlIggHKiPeyFMdaChr3aQyerftWPe1bExU0R2SFZNcLjC1wdf5qf+SHnYkXM2+tqdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7364
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/2023 12:37 PM, Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 17:25:22 +0100 Piotr Raczynski wrote:
>> This patchset reimplements MSIX interrupt allocation logic to allow dynamic
>> interrupt allocation after MSIX has been initially enabled. This allows
>> current and future features to allocate and free interrupts as needed and
>> will help to drastically decrease number of initially preallocated
>> interrupts (even down to the API hard limit of 1). Although this patchset
>> does not change behavior in terms of actual number of allocated interrupts
>> during probe, it will be subject to change.
> 
> Have you seen the mlx5 patch set? I haven't read in detail but seems
> like you're working on the same stuff so could be worth cross-checking
> each other's work:
> 
> https://lore.kernel.org/all/20230320175144.153187-1-saeed@kernel.org/

Thanks for the pointer. I read through that series just now, and it
looks good.

We are doing similar work, though a big difference is that MLX has
converted *all* allocations to be dynamic. This, I think, works for them
because they already have a pool allocation scheme and basically treated
the available vectors as a resource across the function. We didn't
really do that before (we reserved total based on feature and tried to
ensure we don't starve some features), and so converting everything to
dynamic in one-go wasn't done here. Instead, we open the way to allow
dynamic, with a plan to look at refactoring and removing the initial
allocations at a later stage.

In addition the MLX code already has good data structure for tracking
vectors, where as we had the mess that was our res_tracker which was
poorly implemented.

Overall I think the end goal is going to be similar: use dynamic
allocation when possible.

For ice, we need to complete this work, then follow up with some work to
make handling of vector allocation failure better in the case of things
such as vectors for default PF queues. The current code basically
determines the number of queues we create based on the number of vectors
we got. That won't work with dynamic, and we need to instead pick number
of queues, and be able to handle vector exhaustion if we happen to have
limited number of vectors available. We also need to make sure other
uses of vectors can handle failure appropriately, and deal with the
iRDMA<->ice interfaces which currently assume static allocation as well.

My long term goal would be that the driver only allocates one vector at
load which is for the control vector used for miscellaneous interrupts,
and everything else is allocated and released dynamically based on
feature use. But we have a bit of a ways to get there due to the above
limitations in current design. We need to make sure every path has a
suitable path to report failure on vector exhaustion, and that every
consumer has available knobs or parameters to allow the system to be
reconfigured to prevent exhaustion.
