Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEEA562753A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 05:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbiKNEXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 23:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiKNEXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 23:23:34 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EABF23A
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 20:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668399813; x=1699935813;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d63hQ3IfocnvucwFLKmW07cqLH+msJe0gRCrfGrvcjo=;
  b=ZCaNL8zDNYZzEYGin45ln+BiVDQHCQ9IHa2v6LXcG8lupcGIJ09B9isn
   P+AfABFnNh54INmRGGRz9DvZr9sIkuLn0oXXNdwIxVjQWwlRKytKT75Sr
   q+vkwf5q48bC+wBIFUw5ym49+wFSyN1TqIQ6dQCXBy9nGHcPlsAyrwDmx
   5+Zl0X1ERtD6SQPGcez+j7/Cx4WxEBh4T4L3jGnsaHpwZTbYEcsmU+47X
   I5wx6H/TRpq/qsLY/YCV01o2cHohoC4+rPfFy4C+jGUN4L1W4LQCjwZsG
   zZdzpfVV5ZcmvEqQGB3c10HMLJr5QX3acatQJ/5NkmfWKMA8ISwlmYsoH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="299396178"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="299396178"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2022 20:23:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10530"; a="701852265"
X-IronPort-AV: E=Sophos;i="5.96,161,1665471600"; 
   d="scan'208";a="701852265"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 13 Nov 2022 20:23:32 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 13 Nov 2022 20:23:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 13 Nov 2022 20:23:31 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 13 Nov 2022 20:23:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k69EdB8Lt9MyBk+c7oEa8CRz+oPmlk6BZ0GKbITKIa/QgDDPYgQ65jKCVwWMsQicsJ1K8OJlmXoz9y3bUjhW1W5mTdZ77Gv6GOQ7ar1qwIieezDu4AF3/FpuQBj+nZ8Sa9IxLcmRZqsp3SwzeqvXaJyhu4fHGyRgI4EYplLMUpD5T2WVOXzhauPjdg4CFDhX84GZc9XxDyxvYdKKsIb14q18AORp1MMQvoq/EwH5tVDZuGGyx/iI0vrf528htVP6NAN2VlucN3JZU6srhdvRj/uB6pTaDi+9qi8ZZCNeZpYu0gV+DV4wTWvh06ESpjldcBikqukz4fIy9nU8ZjFAKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cim3lD6UF94fUdHazSsiOkb6rVzHqqqNEgufytb+aDE=;
 b=kMFn61LKIDUgSXNlAlhx6Jc7iwJlGyJX9YeFJm5PxD3F/ZPMCpRPmeCHKSYEWCKR/3ZAnvhNMJBCiU9EDWEakkK5d7hHQsXjC7gtEnSeg/btC3XOqqykKU+eAuHMXuznFpbXkeeHhT/aXioS7y2bsJ6VwaIhsRCiUnRFQBoMzmYKkUMG1PpRNpFpwd1EgPmgwcqfe/auhP+tbYqzA4cx0ppd9m4D1NzaEtxJyHjA78dZnFVEGC9XVaxYcPav/WD8NZyFKnhBqyGumirC+zKbnNg7iEZ7HMrSpTHLXMfORSl0N8NohqXyRePZx20CQv5qmRY5I8He6Fr+FN8ETKqkPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by BN9PR11MB5371.namprd11.prod.outlook.com (2603:10b6:408:11c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 04:23:29 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e%9]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 04:23:29 +0000
Message-ID: <c40e7ed0-1118-168b-7fdc-a833b461b918@intel.com>
Date:   Sun, 13 Nov 2022 22:23:25 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
 <20221107182549.278e0d7a@kernel.org>
 <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221109164603.1fd508ca@kernel.org>
 <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
 <20221110143413.58f107c2@kernel.org>
 <0402fc4f-21c9-eded-bed7-fd82a069ca70@intel.com>
 <20221110161257.35d37983@kernel.org>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20221110161257.35d37983@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0069.namprd17.prod.outlook.com
 (2603:10b6:a03:167::46) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|BN9PR11MB5371:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c65d5a1-9582-4415-972c-08dac5f7face
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpxOd3NuGFumZ1OigmlGWgRQUEd03JTxaGunFjSsjbAYQzWAQPL3yDob1qcUIQmXd3MQr2lii+yk5+oghkoWvTlUoJZmWgUWMpDpyicUb36uhZezICSy2yna/huds8tmWzeAdfcVQfmCxp4GJ1aLW2rMVKe/T0kVBDMD72mME1TnDi3SHBCeh+Dc2+eBnF/ktGyioJgImxo4OOegMtYl1Ps3sI0jVjZ0HYRJ21JXCV9SJI+1l2Oohd7jEVxD/jfRLSfe6vZAD1XRLKGA/LnKgksd4MFFAOEL/bmYFGVpeuGylBNZz8WC1DxwOWgujUZBKs6MR4WFSfNvcoQBSSdXa8YXGz4l9sjatGqvKjL/vKsjR8kRn7a7Urz5IxZjqKOYNMM8lMQQ9F85pN3Hshunkh8yaXQLUxK7DaCuYakZZ8Y5nOCXP539CBK02H1pc1RYkKCxokIWQTb0HKB5Za109lSowXgTT9b8FmgQqeS2Ck2gd0hU4R9tUM+4gH5H8Z6BzSdZGblUpU5m/FSt6V3keWm9gqtHEwP0fbXfLa4qSnu9pUyyZIcKdvX5CNbwGtghNTEUQfTY1BEb5atSV00Q5GB6EEI2TEu75YSxz7mjaNylVXMGoKOy33uNaFq9Skya7F9yPgFPa3vcjXNrY+PRbBXq8o6ZRz85JmsDQ69o9xBw92wzM9rtxJRLstYABHAcTi1TXcFnwK3AtJDiTK+6g4Y9WVx0w1xYJDzVzLwFGQLqtITGnuH1Z2B87z415aPryKNTs9Pg8LHsUk0hjzpFxe1B+Kpn0cM/hkV+34qS4GSIsuRX/pvyLJv7mgXRN+S7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199015)(31686004)(82960400001)(2906002)(36756003)(2616005)(8936002)(31696002)(186003)(86362001)(316002)(41300700001)(66476007)(66946007)(66556008)(5660300002)(6916009)(4326008)(8676002)(54906003)(83380400001)(53546011)(107886003)(38100700002)(966005)(6486002)(478600001)(6666004)(6506007)(6512007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjRmRmlqZmlENVREZlBrbHdxZUhFWVRaUzdaV1R3aFp0aU9EWERCWFFzSWlM?=
 =?utf-8?B?bWtKVit4VHFiZlVzdG9MSk81SmZERlYxbFVHa3prdlc4Z2did3cxVk9KSjNH?=
 =?utf-8?B?cWNFemdWZ21TTlZoQjluaXR5WS94WWV1UjRkSTJMaUhFVjY5bU1MZ09VSW9p?=
 =?utf-8?B?SFRmekZTS0xKSDJkZFExNFBiTHdIL2J5NmhtK2xNZm5lcGRScDRXVklxVzhY?=
 =?utf-8?B?WldKRllSdW1JRHFSR3NJWDU3d09iYk5jY1UyL2lYN0ZoY0c4ZGdpbGh6cmsr?=
 =?utf-8?B?eFdmQWJsWGErT0JaMy9NMTVzaEZ0TzhRRUhKd0dhWWk5d3VsVXFQZjBnM052?=
 =?utf-8?B?WHA1ZGxnV2IyQ2dmZ3I5UStzTHhJdDAwNFZjSlMweTREdkhJOTBacUJlMXlm?=
 =?utf-8?B?dHd4c29udGZsNUpIYlRzSzB1Vkx1TUUxdU9iMnJrY1BQNjkvSUl4OUhDc2J0?=
 =?utf-8?B?NU80UUpibGRhZGN3SVBuRjMyQVpLTXNvL2RvMXNDaXNPaGVad2M5SXpyTHFu?=
 =?utf-8?B?Y3BZK2hwSnV5Z1hTaWVFS1JRRmdSalMrcTRyR1NrWStwcGJlVWxKV1Y5UDhT?=
 =?utf-8?B?T21QWnVEcDRMa0dWY1I5WlFKUnJyQno0MWMwQWFPbk9zZm1XQTZKTHJ4ZzFF?=
 =?utf-8?B?d0toYThlYnUxSTFqWEVqeU15YWZKTUFic1VqYUVnTHU2cGMyVm8xMHlvTEJP?=
 =?utf-8?B?RnVxa1RNY1UrNmhJQ2Zjd2JqT2xMdU54WC9iUHJsV2tkS2k0dUpKeUFYYVFK?=
 =?utf-8?B?Z2l3dkFhOFo5K1dnUEZpcEN1elZOeTdPQ3VRVWp4RlZyOFZqcEFLVzVMUnZh?=
 =?utf-8?B?R1dxamt2ZUMveUFRbEhzTU1jbHJLREZlbjI4R0pIRG9qQ1M4eG5LazI5U0x3?=
 =?utf-8?B?SzVndG53NUg1K3ZUSDg3WTNFZVhjNm5ZbEFCN1g1U0hQcTBkNHlZSllNTzVx?=
 =?utf-8?B?WXFaNEp0V2kyMzB1aENxa3Y4cXN1NGlnb2JlaGIvSXNWbkxpWWdiMlJOYW5D?=
 =?utf-8?B?YVNUYk1FZHVRUVovZzA1b2FxK1R3NlRwVjhGWmExZ21ZRTFQclNXMkNXMUdj?=
 =?utf-8?B?R3RXb0VzeG1NSFNHdktOUnpveGs2VkQrSnRyeDRBZEp4YlJwSXRiVitkV0NC?=
 =?utf-8?B?UzBNT0ltRDVZVHBWQy9YSEhiUHJVMWwzNG1BK0tRRTB3TlI0U2FSY2FWRHlU?=
 =?utf-8?B?cFlpaVI4MHE1amljZlhzZzAySjJ3RnVST2hMZGY0bDdOUStUN0l3OG9VcXhK?=
 =?utf-8?B?dUFnRHBUSGxWbmJNdDFqY2VoUzEzL1NMYzRBaWJNbnhxRTFUdmFZcWY4Ymdu?=
 =?utf-8?B?SWdLMkpvY1A2d2d6NTRMTTZkcU93ZGMxd3FidzR1VTBESmhCQk5YYm80WEYy?=
 =?utf-8?B?TmxQcnRJSzNHNStqSk9jVDBmcTFRT1NQKzF6Rkthd0FSR1daK2VKZlVkK0Zv?=
 =?utf-8?B?Vk9TSXhndWZKQ1RqemdvYmlCUlJaUis4RDAwclhCc0JsVWpKcUpPYkMxc0dz?=
 =?utf-8?B?SEJoWklNZ2d0UTRFZ2FEK0JxUXZEQWFWQmtpSlR3anNpZWdUZEJyeEFrKzlw?=
 =?utf-8?B?dFROQUZheSsrWGtacWdhYUFyQUd4aG9LcnN4UEVtbUp2R2VJckp5L2ZXdFQ4?=
 =?utf-8?B?ZVQzUm9BNHdNQ25aYXYzWk5IMjFNYXp2T0RmTFc5bWVXVFc4c21KWm1kTjRh?=
 =?utf-8?B?b2tWQ1VzVGJrVE9NaGRGRHdQZU15K0Z0dlBDV1QyMm90NExhMGlISTNRNks4?=
 =?utf-8?B?anFqbzAza2t1c0NJVngyVDF0MlE1WWhpdGtYcHVDdU5TWktyZm1FSFVyNm9l?=
 =?utf-8?B?dmVPaG9HSExIS2tOd3dxK0xFRHo4b3hHY1dhclplNTd5MGE5VW5UYW9oU2Rk?=
 =?utf-8?B?Z2Z2Y3NqQ0pqTXI3WVRkUHFjMXdFaEFnL2xvbEdDdGtKRGo0dlpMZ1VFU05p?=
 =?utf-8?B?eEo3UUxtOE5yZlZFZjhyclhhY2pRbzgzbmVyalQ4ckI2cmxBaFVhQmJTeUhM?=
 =?utf-8?B?YThTc1FjOXY2d3JnWElJUG12bnZkbVdzQUp1OFZKVkk4N2hDemM3Q0FjZlY5?=
 =?utf-8?B?ODFGam1VTU5aWGdKUGo3Q3RuM0VZZHJCbS81Qk45MXpjOXpmQmo0ZWJVTWVh?=
 =?utf-8?B?TVdtQU5QTGRweE1LTjJMWXo5cDlpV2xBbS9rRWM1eThDMUtMY1hsZEl1bkJP?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c65d5a1-9582-4415-972c-08dac5f7face
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 04:23:29.3660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBzCJTR4hwRhlCIC2uWZitw/Rr2qJEdbPWBlaaNktgYdHjWnCbVS5ARfHztGT9VwVK+vAwQKEzuycHmro4SbOJlj8HAaMsmt0jy+KCE7GYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5371
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/2022 6:12 PM, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 17:24:15 -0600 Samudrala, Sridhar wrote:
>>> The RSS context thing is a pretty shallow abstraction, I don't think we
>>> should be extending it into "queue groups" or whatnot. We'll probably
>>> need some devlink objects at some point (rate configuration?) and
>>> locking order is devlink > rtnl, so spawning things from within ethtool
>>> will be a pain :S
>> We are going this path of extending ethtool rss context interface to support
>> per queue-group parameters based on this feedback.
>>     https://lore.kernel.org/netdev/20220314131114.635d5acb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/
>>
>> Per queue-group rate can already be configured when creating queue groups via
>> tc-mpqrio interface using bw_rlimit parameters.
> Right, but that's still just flow-director-y/hash-y thing?

Yes. The initial per queue-group parameter we want to add is to make incoming
TCP connections to be distributed in a round-robin manner by over-riding RSS
hash based queue when a SYN is received and let a flow director rule added
when a SYN-ACK is sent out.


> Does the name RSS imply purely hash based distribution?

The name Receive Side Scaling doesn't explicitly say that the distribution
is hash based, but I think it is a general assumption that it is based on hash.
But if you are OK to use RSS prefix for flow-director based distributions,
we will use ethtool rss-context interface for this parameter.

>
> My worry is that if we go with a more broad name like
> "queue group" someone may be mislead to adding controls
> unrelated to flow <> queue assignment here.

Later we would like to add a per queue-group parameter that would allow
reducing/changing the number of napi pollers for a queue group from the default
value equal to the number of queues in the queue group. Are you suggesting
creating a queue-group object and use devlink API to configure such parameters
for a queue-group?

