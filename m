Return-Path: <netdev+bounces-7267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 488D771F6BF
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 01:40:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88B8D28193E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B342648244;
	Thu,  1 Jun 2023 23:40:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00DB10FA
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 23:40:55 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871B519D;
	Thu,  1 Jun 2023 16:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685662841; x=1717198841;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=foWua2gm62IwSVUDmV57+uOHg7hdRdOL3mOoxscejo0=;
  b=cQq0e/kOrVWvFPS8JDPzg/BrYpNRJITX54fqTwBqHT7JsIlSiQZOYJMH
   d8WLOhMlr/JMT7nzYvJRzPkXNqfc1DnXHc5zyVyfE3ePEHQK6/ZVxS4kx
   kovlrHyPPrCNSPUeHF+sTl0e9O3BFZ7ODKb0K37YzHIJ62KRNAqwUpJAy
   ITvrbrCB/GKBTurku3BQty+I0NgsIKgQmgfEuW77zgHce/XOcVkZFiobv
   6LMHXvImLO8naCJ2o/hkbUmziF1K6bNnXr7kbfgn872uuIj3AZ/Zdaiew
   bwyRthaNq/oUk8UGtRXuy5YNSP1LJULIXIreGSKFhFOwY2WGM4Ylq8el1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="353211306"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="353211306"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 16:40:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="831748670"
X-IronPort-AV: E=Sophos;i="6.00,211,1681196400"; 
   d="scan'208";a="831748670"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga004.jf.intel.com with ESMTP; 01 Jun 2023 16:40:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 16:40:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 16:40:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 16:40:39 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 16:40:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX3YE79cyN4O+kl9aqFkOtybiowolUYgKo15GGC8crDGOD/Dp5bEBwBNsLIsHUWNcOvkfUhx0JQGjfoNKqUJ3TyPmGsD577QbqNqIesVk7c5ksYu+ngG0qUtMaFwXOpkNj6xahmc1FMCt9irwFX07lJ5j0yU5ORbkruxyLKtegBOAW4O4ZV1nrSpzJvW8uw2RIDvZ0PbLD7CIqHaMCUSxlltiEdZl31diODqlZY0xOAM87cvFHiIuWUhxV+AsvU9c+b2BtFJuFZULjWPefAKqmRn+LjuhQcc7JF8W6QQVjy5jYEimQ2LZenxqxThUNa76UCmbgi3OTmLJUhsJRTqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kt+N7z2twIl+yCuBHNCcI7s4iXWeeCtvh31lSsrlwyk=;
 b=hQeJcVNvZny0dEhXPJyhFHX0aEqnvd7KjMef4GLXf7EthRIgRfDpJLNa3SOERHpU0poEeFc1czOeeqIErrdG0oxQdp0VcFHp7T5hjUDj6FazY9KZ8zvOjK06vwrRjenuq+j3gpEnmNvnO4HlneXHacAfUXqWVPua6Nfz0aAsF/mwArr3rmE6OP+GN5BfcsZej2ulEqTPfjGkop3VAEejTpPFWtXclnzru4TDgkupUnGfDrHMS8LUq7jxM6TpCX5VqNPCrpa6dT9q3Lb/MZtT9GfIqe2q1cj9asFb4SfZJjBLR7MjS6HtRPHE8U7f94OxG/xF1jo4z2M4ytykOQUGHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2599.namprd11.prod.outlook.com (2603:10b6:a02:c6::20)
 by IA1PR11MB7342.namprd11.prod.outlook.com (2603:10b6:208:425::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Thu, 1 Jun
 2023 23:40:37 +0000
Received: from BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::cab7:84ac:bee4:f96]) by BYAPR11MB2599.namprd11.prod.outlook.com
 ([fe80::cab7:84ac:bee4:f96%6]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 23:40:37 +0000
Message-ID: <e4f80b89-7804-4832-280e-3bd0c9501a3f@intel.com>
Date: Thu, 1 Jun 2023 16:40:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 15/15] idpf: configure SRIOV and add other
 ndo_ops
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Joshua Hay <joshua.a.hay@intel.com>,
	<emil.s.tantilov@intel.com>, <jesse.brandeburg@intel.com>,
	<sridhar.samudrala@intel.com>, <shiraz.saleem@intel.com>,
	<sindhu.devale@intel.com>, <willemb@google.com>, <decot@google.com>,
	<andrew@lunn.ch>, <leon@kernel.org>, <mst@redhat.com>,
	<simon.horman@corigine.com>, <shannon.nelson@amd.com>,
	<stephen@networkplumber.org>, <linux-doc@vger.kernel.org>, Alan Brady
	<alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Phani Burra
	<phani.r.burra@intel.com>, Krishneil Singh <krishneil.k.singh@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-16-anthony.l.nguyen@intel.com>
 <20230531232336.3dffb14b@kernel.org>
From: "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>
In-Reply-To: <20230531232336.3dffb14b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::15) To BYAPR11MB2599.namprd11.prod.outlook.com
 (2603:10b6:a02:c6::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2599:EE_|IA1PR11MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf5e981-0076-4ae7-1b24-08db62f999ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZIn1KhHSJ3fQAG6ZMz5QVsQC/2nmuRQMsnxDXPc9urB6XI9HMAW1Xp9T1K7xHKSpWlDhZOXThIVDd5z9z9M8HBoGussIV6MEDa7NO2xvL0CZiKOSQf5efQLkUVAjCvvpJvJWmu0Cuas5vGu4RhpCMcA+VBr5VDEKby0FegUkyfwKcFkeLk0KQihR9mgtnvkrp1ks+tfCISAS4BCZnbl74yUv34RAoTUv8CQbbYMCLLoPgZplE0yq+jfQJFq4ZKlUsEqrqOM03gz3cpzV7coJOVXhTv1cGvZ+tlJ9PMvyJI2GfWjMaq2DlSN5r2Kc+a1yFUS61qZSXMhR+9qelcmDOuyFv7OnttfQLGoybxGcANiLKoj85Ypk6RPolGmdVF8PJbhYN2CXD7LYZ+WarJv4aRGK2hDorQ9dyetXTH8YQqaOac6HRAsl54LwmqppwvUNjUFF9YG30oei1b/mhm/cdu7V3aG5KhImFIqYLrw6Is5432noNn9VXFaHuljcnX264BrwMlDAu4U8rO6OOd5f2nN+lt1Hv7ivIXRlY1q6PQfXOX8XI8qBZMjvprTDIXOwfXxBUfrwt7OlYV3jqnOun7XTW9BIc0ZXd7YRkUdKtn8KrZlRq2kj1atYefNZCJnCb/hZ5+QgJSAJC4NlvLiHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2599.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199021)(31686004)(83380400001)(82960400001)(6636002)(36756003)(41300700001)(4326008)(38100700002)(316002)(6486002)(53546011)(26005)(6666004)(6506007)(107886003)(6512007)(66476007)(66556008)(7416002)(4744005)(66946007)(2906002)(8936002)(478600001)(8676002)(5660300002)(31696002)(2616005)(54906003)(110136005)(86362001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Njgyayswd1ZZVjU4WC9mcmtXVzVLR21LS3I4M3BvVXdPT2JvZ3R0cDVjalhG?=
 =?utf-8?B?NUsxVjQ3UWRwOVFrc2hFTjRIK0djekNBVityMTM0SWJ3VkRjSC9DeW1CSDY0?=
 =?utf-8?B?dVdyT0pNakMwdjVFMXFOZSt5T3VOeUp0UysxY3hMRVR5TXc2UGF1eFcvQ3cv?=
 =?utf-8?B?Y3lyMHBpZXVkcUhYSjdNMjFSTnpBdUJ0S2JMWXVOeXo1Y0xpbFFvRnI2dDE1?=
 =?utf-8?B?QWs3eFA1bHNCRWRuWk93dDJlVFh2K0lLV2QxNVFIM1drVFRvSkp2SW9YQit1?=
 =?utf-8?B?WCtsMDM5Um9vR1YvUzlGQTU0eHhId0dPU1lJRG5Tci91YzRXclhEUDZ4OSs1?=
 =?utf-8?B?c3hvT1Z0dzcrQUUwQWtwZUxRa1IzWHZoSHRYYjJZcDNHOFM4aC9BdWJXUDBI?=
 =?utf-8?B?Q3lqRW1sQWVXL0ppUFplc0x2S3FHTGx0cVRVY1k0bXJMMy9qTW0rUWhzR01t?=
 =?utf-8?B?NVJ3d0ZHcm9SVTNicExkSlY3VUppUWM3Z3pvaERRVHBkQUFKQ1Z2c3BGL0NG?=
 =?utf-8?B?ZVNXdklIYU02ZmZBZkE3ZUtkMEY5SFRSb1M2WnYrd1NXSm8zSDNiZDFxeDE5?=
 =?utf-8?B?bXpieFNjOXNIeHNkUnFneHo1OWZQT0phanF6VE1ySnRpUlBBVjNzZk9hdWMy?=
 =?utf-8?B?Vi9CMEdWVEhQSVZzK2Y0aEF5Q1ZkUklmMzVNTVRqRnNKWFZ2K1c1YzMvMXJD?=
 =?utf-8?B?NEhNbGdNS3c3dFBRdnJtQlQ1NnlWTmszS0NkWWp6VW1QZDE2dU1XeUpOSC85?=
 =?utf-8?B?cjBSVktVSzZIbUl3NGJoRGlxNmZ1cnJlelg4aWwzR0JIMVFnQU11RHNlYmth?=
 =?utf-8?B?L1Z6NTdvSHgvbzNWTm1RQTZ3aU5Lek5pTWVzZ25vVTR0TjRpMEl4dUFGdVNT?=
 =?utf-8?B?ZU1vWXVJbmFnUU1iaitORDlsMFNjT1NxUFhhb0o2Nmc0OTdlWDhxelRQZ0tD?=
 =?utf-8?B?V3VFMmZJUlJCTkovVFB3eCs5MU9SZmRzaUZIaVRCZTNWcDEyNWhtYWZHbEhW?=
 =?utf-8?B?WVlyVk9xczdXVzNoYzM2cytHRG1Ka2RyK3NQRzlOMmJzTERTZTZ5TXVXSWFY?=
 =?utf-8?B?V0FOWkl1aFRPNXZLczF4czNqbjNjRVpoTUJGTjhsSnZoTUFoNmx5S1o0TmVQ?=
 =?utf-8?B?VG9ackE1YlAxQnZZeXdaRFllL1JiWk95OFVCcnBjTnZnMXRBRzJSVjI2VXJ6?=
 =?utf-8?B?dlRWdWllZC9pdWlueWxnNU9DZUU1TitVRkFreHlzZXQrVHkzZE5adDd2Vm9z?=
 =?utf-8?B?cXFBaDFiZ2hqYUF3dWJXSkVWZEluRjhwcjFNVWg1ZFRwWkxYK2xzWUhzMDZz?=
 =?utf-8?B?c3FTMmdGZlU2UkxkZHBwTHlUeDV0WDhsaUJMSkY3Y1VoQzREZUpUS3ptWFdF?=
 =?utf-8?B?Nk9LTGJsbEc4bHJtN2syZHhtTzZtZVJmbGpBd0VFdXorNnU3RlR3aHRYZGpK?=
 =?utf-8?B?ZS9lUHorb3pPU1NybURnbFJWTk1QN2Iwc3hXWmJEdGp4T3EzajVOdHRCTnY5?=
 =?utf-8?B?NWpteXVpZmE4QlRXSFBmdjJCQmhEczhMSlRnRUVaYk81bWpsbk9HUk8rQ25Y?=
 =?utf-8?B?Z0VuVEZPWWZKZS8zV1l1QjRYM3pkblRDdUVwRlZTbHE3TnY1WW9JZnBPSVVn?=
 =?utf-8?B?VUk4OVNSNGxpVFJsMTByQWxQMmRJdThPQU9DNzNDOFUySkRQQkJPV3BWc1Vt?=
 =?utf-8?B?eEtGUzlxRWx2cmVha2h4YTNYZGJFN3hWSWt4ZUxzRUhkK0JEN1ZNQllIamY2?=
 =?utf-8?B?djNFVWdsZFVCL2hCOUxjcVdobVI5NUNUa3RQWnFGaE9pb0xhUll3dGJqMGcy?=
 =?utf-8?B?bzgvZTBzMnpsbWV5U1hPL0l1SWdIVlNrckdRRTRRVnJqQ3ZIeVNRR3ZOejhu?=
 =?utf-8?B?R2ovRnl4YTlBUlhYam4vdXRuUWlrWmN4dm5WMDhwNWs2emI0QnU4SnlqVDNm?=
 =?utf-8?B?ZnhGck1TMEVjbm5OVFdXanA0cTlRdEZYNC84ZGdHYzVrNzJzQjU3N0tjK2hO?=
 =?utf-8?B?bEpySzlhOUEwaXhlZXFHcWV5cnhwdFMxdnBJalJoajJFWDJYVHJBWm0xNXVY?=
 =?utf-8?B?UGhjdHYvcW53eXZVZUxKY3hwdHZQbmxKRFFoUkFNaHBhUWV2V0FhYkY2VTI1?=
 =?utf-8?B?L3hhck1sT3FzOXFIMlByRWIzTFgvblRmNXlBa0VXYXlUZmk0VkpvRWd6ZjZ0?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf5e981-0076-4ae7-1b24-08db62f999ef
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2599.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 23:40:37.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AnDXNXl2O+c/aO7z2fDD9Drqgo1Ley4WrLLUapcGmj7KSG8eanGbXZUR7xD9UaZJMK+7udmT9/hsGdS8JScREFIycK6Cd+YDJVe/djw+1cY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/31/2023 11:23 PM, Jakub Kicinski wrote:
> On Tue, 30 May 2023 16:45:01 -0700 Tony Nguyen wrote:
>> +	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
>> +
>> +	if (!vport)
>> +		return;
>> +
>> +	*stats = vport->netstats;
> 
> How is this atomic vs the update path.

I see your point. 'vport->netstats' can go out of sync if the statistics 
task updates the 'netstats' concurrently. Will guard the stats update 
with a lock. Thanks for the review.

Regards,
Pavan

