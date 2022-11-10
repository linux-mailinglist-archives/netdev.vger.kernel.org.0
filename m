Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75893624D75
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 23:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiKJWIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 17:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiKJWIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 17:08:10 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C045802A
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 14:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668118089; x=1699654089;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FKnrTjbw6/ve6QT5BC9Yte9YIsXd2XZD9CXK7bN6huA=;
  b=E5wlNPq6tTwsywyrLCvREpTwRpviTs3dn033z3gTcATyZMWm02LF8gTM
   fUlDr8nu6POnhZpXD+EPq85bCIItJUaViFKpbkNsG3VDHloiqdFdDlyvE
   Uq21SWO9hSb1N4+JncmFyyHoRjvzRX8ZiaDzdYrdB65lm6ryCIyon5JCl
   74j3HB9oyHgyd6HnWneFYYAtJQvAgG+LzziKBDdytiActbpuPNnEfuWa7
   baay6oaKFO48v+kZRupowuJdrvE1bAjOh7XySetyhW2lvMBU0nKu5fD/J
   Kmjq2V7ib1a39GcnnaJDMhiJTqds/e79lEvhDxKDrZn926g2zbVpJdXEd
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="373580052"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="373580052"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2022 14:08:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10527"; a="726558615"
X-IronPort-AV: E=Sophos;i="5.96,154,1665471600"; 
   d="scan'208";a="726558615"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Nov 2022 14:08:08 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 10 Nov 2022 14:08:08 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 10 Nov 2022 14:08:08 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 10 Nov 2022 14:08:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WpX19gIDmNTKyLOHA+qkcroOKpbn/JZ+jdJoS68N+aj5HgAuFh2XHkaHydbzt+1eiZdtPCJKPhfuhzR92/yyGLky3XIg6I5cRkFaKlDGV1/0OKA4WaBWvf0c2ArL6LgZJ3mo0rUb1JWQT0ZmCZfwUig8WviOwwKTM28cELshbbOvOZVlYlfSqo380dIc7YAPOztlHl9YZXWiS0p8swt9TH3Ai6hGHHpiytnf2xen7AN0ckkgH6AqAuAXXnT7MmEWth3c1pMOvHuCrdhHpMtKMKiW9N9h1aVnhLxzsfnp9VfRkjf9ZVdI7Hc9kuOc8KF0pvGW4TNG9rxY+sbdgTzoDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ONcdDUUOfmA8Xjhbq7Qf/LcI+DMoIXKcaO1nd5aFuYk=;
 b=B/gIuqJEBaSh/63A+YDy53a24C7LtGRKZbTOQlJ7slHObltUtj7aQCl3gKxVmu6mrCC2iz/0TXxvaykOWHLLan1SF9NKTOMQ3rOZOQYcRTQBvgRYmpy7sKE89l/f3+LcHI6Z8GGZt6rBbkrN259YHD2oLcyWBmwPq0Q57As2X+Njv4KxuK8WP/5Hg3IpqgU6sU+7FUkOUUyA/VEgwNGn+pltV1kTWrGvE1Nr/YjGoeW27B8JvydHobgSuwhgHKiYv/vXVHio7uQg6WdzHG90j9NOGRv5YB4K3u8I8+5mgywpyd0E/4mpBsFSRJy4Uxfksp2Zyn6Yd2krPtwK3PYIpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by SN7PR11MB7137.namprd11.prod.outlook.com (2603:10b6:806:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 22:08:06 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::f09b:dc76:ce14:2d2e%7]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 22:08:06 +0000
Message-ID: <eba940d8-a2da-9a7e-2802-fbac680b7df6@intel.com>
Date:   Thu, 10 Nov 2022 16:08:04 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2] ethtool: add netlink based get rxfh support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20221104234244.242527-1-sudheer.mogilappagari@intel.com>
 <20221107182549.278e0d7a@kernel.org>
 <IA1PR11MB626686775A30F79E8AE85905E4019@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20221109164603.1fd508ca@kernel.org>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20221109164603.1fd508ca@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:a03:54::15) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|SN7PR11MB7137:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d9334b3-0412-446e-a308-08dac3680b97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iu5f60PrFOmDhe1MROmhMnfXF6vvYjpQ6qq6/pfHpMoan760p1fo365roDHw96wA9C4K5P3xtO+NBstT9o4399h1m3V1HSzm3c9bMlaGtRKhnWRMs0UiOx/IcJ6r7bf3IXChtKSB1tXzgJoFMnz2izH/iVsEb8uan/B6G3Hsnb3hrkjP2DPIePvBuAKLvMz+b6LtKqVd3FQwQzUmntYCBqIyxV9ln0X2XJWjmRT9Pot5VLMr67e401VAWUYEYsgf0z8EvndBeXVPCiGjUey067UV0zgfl1HsgQaJ7vLy8EkRxYLgOv5FM5fg+3uqHsGRnKpdNw9bsGFZ91be0t7/32r27yWIYUxAjWFCi731+6RDBEK86N5Ec6Se5bTwZEa0ClZ0vj+YUk9SclkgALNT2a0lIGQtnGgqJdpdS0DsEXXweYPknqtQGJ/K0xrKtt2/YYdoxMP+FRsP+FhaISCn66jVsknpHqYwXmRA3x+7P9ytjB0jwR02Ze6jBu3uae+/1OCtJqWFeHBbs6W8OvuQHbefNl3dQvo76OWeYWUhzK7Hx4C4k49KqyIBq9VF1JYFLt4MjRsCjO8HTMSc3K4DdEmRf1ktWF1FKYx0qTDAKNTZeRexM5mJQsMWmAcmCokITitXZ0chEAZMveg5xyJzKXhe1DsIyOrot92PdXdPcPYi0ZoOn4cg99VvQa6IjL+TK4EZ7SE99aQJciRRLfIUfd8ozSWcDFd/agNe94J4iQoGmhIVJLWIKnorsz7qIjwooyeVk5NO9ABzew2JnIGeWEc7q8FRGTBdCg+tvZbiMwM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(6506007)(110136005)(53546011)(86362001)(6636002)(478600001)(31686004)(107886003)(316002)(54906003)(36756003)(186003)(4744005)(41300700001)(8936002)(2616005)(5660300002)(6486002)(4326008)(8676002)(26005)(6512007)(66476007)(66946007)(66556008)(2906002)(31696002)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bXgwZ3BOM3VEQnVNZkJxc0ZmRnZYRVNmNGQyZ1U3T3Ivc0dEeWExc0U3V2Nj?=
 =?utf-8?B?WEtoVmE5UUU3QnFtVEJ5d3VaT3pLOEp1NGJ5MnpNRCtuZFN4dkRWR2t1eDh3?=
 =?utf-8?B?cTQ1OXE3Z05ZRkU4bFBPQUVkeDA0Y1N5YStsVS9vZ21lV3o4V0NpQmYwYS9k?=
 =?utf-8?B?Z0Z5UzdtZjdRNkYxdDIydFA2blZMS3pCeU50M2RxcFdMRmwvKzRIREUyNm1E?=
 =?utf-8?B?bEkzR0t1MmVLeTFIVUM1R3d6ZTQ4U1R1TWQ1Yjk5MTE0K29QcDZkZXRFRWRL?=
 =?utf-8?B?d1Z5OVhmY2ZqaDZIQlNCTEdOelZUa0p5SmduRklOVWNpdnJJZDN0OGUyYk5C?=
 =?utf-8?B?enRFMElKWE9UTXdVRjErWUM1b1JHUkd4MnhQV3g4U0VBRlRJZVhZbUxzNnVz?=
 =?utf-8?B?eVBCd0NGRHdQRGhZU1F2QzZhNnlqaVNKTFViVVZyNVdPV2NJREtuZFlxOHBM?=
 =?utf-8?B?M0FKWGhTUHQzVUoweE9zWUNHN3JBTXJvclB4WlVXVDhzd2lPeWU0TXFmYWRV?=
 =?utf-8?B?Mm43dmJ4Q3NQSVh0M3BCcjV4d01IWnFaMUJ0aDYreHZGNWRZaUEvWHEwanlL?=
 =?utf-8?B?MW1nQysxRE9abnZXbWoyRHRQSzc3SkRSb2VrU1duOE55LzJPYlk4UWZ1ekVu?=
 =?utf-8?B?VzBodVduRmYvL3MrL3RjYm5qakc1QzJ6aDV4bitCODZjUnRWcHhqdEhvZ2xz?=
 =?utf-8?B?YTdsSlRhWXZORDh1NGtyNkIzbzBoNW1MRURsYnRHZGs3cHhKbXRILzhUWm9B?=
 =?utf-8?B?aFg4alBuU1FSb1lDaWVkWEs1RXd1OGc4NjJsYzNkWEpudEIwNWxGV0w0QjE0?=
 =?utf-8?B?UmxGcUJKOVI2Y1BGb2VyMkJ2MEkxWUo2RW9FYkttK2k5UjJQc1pkUmI5TzJV?=
 =?utf-8?B?eUppSlYrcmVTN01YbVlDbEtCWWlKeHdIRFlhM2gzZXRBc2U5UEFwUXNoTnRa?=
 =?utf-8?B?OW5TUDlJMkUyUExzUEdzUWRMQjVCcFNzYzczNmRkaFAzWXBTazFrY3VZUkRW?=
 =?utf-8?B?R0NyVldLM2pKZmRHcDB4UXdHVDJ6cmE0dkRuQWdxaVdYUTRIVWhMeXN2NEhl?=
 =?utf-8?B?djEzZXhvZWJhV1NjcVE1UTlYZnMxekY4azV6d1piQzAyM3NDRmozeWYrWWhQ?=
 =?utf-8?B?d1VzVU5UZnZ2Qy85N21BZDYxZGJjcnY5aE1pOVd6YW80VnFnR0VTTTdzRXpi?=
 =?utf-8?B?c0VVblprNWsxZ0RWQmZ2ZlF3NitnYTgzLy9TNE1OOGMxTlFxSDlIM1VCbzZp?=
 =?utf-8?B?bTBYVEo4Mmp5aThQa1p0RFRmSnJEQStiQmJNQ2Jkd3JsTS80MENCclBQaU1D?=
 =?utf-8?B?S3hiRTlyOExZZnR3dER1R2U1UHY4WVJPdXFZajhoTGIzK3h4Q0g0a3BCdWxN?=
 =?utf-8?B?MGpxL0MvSVlkK2ZYUTNyOXZPRzR0dGZPZThubWhoZkorU2pwM1dONjhLekVw?=
 =?utf-8?B?djVMeGY3eWoxYVlCckFHR2ttNFpOUzA3eTNiaWo5Qm9vcWQxSXFkc2JjdjJH?=
 =?utf-8?B?UUp6YjErOStLZzJXdmxybnJXdXkrdDF1cFFzYTJSWU9FT3Vjc01NaEFUcEU0?=
 =?utf-8?B?Ym5paHdZMzhtbVRKS3RtanFpYlBhTThHNERuT0ZHYzVDTnQxRGxhM213aXlD?=
 =?utf-8?B?U3lwTVdaTzEzR3ZIbkdrb21JVDlMOWdZSjZnd1NnUXNJbTIrSEk5bkVjZXNT?=
 =?utf-8?B?b0hydy9jQk8rZG5LUVl3TDRIZTJ5TGkxOVNkRjhQS0d4eWEyZis1TlA5bG4z?=
 =?utf-8?B?Rnp1R2dJazgycSt0dzVlNlZERFk1R0tzdEdWSlZvSkRELzdYejBlNGpVRTRi?=
 =?utf-8?B?dVl2UjliR09ZaStrOHJPUUNScUp4dGpodnpNdGZldHZUcWJySHBiRXBSbWtL?=
 =?utf-8?B?clFCakZ4b2E4bnVkN1JuMXljT3d5M013RDZwMDN3YkJ5WkZKS1NvWlBGR01K?=
 =?utf-8?B?U2FnNjdMMEZDcFVSZGVCMmVqZTlNTFZHWW4vR0tvQjVFMzRzK0xPWmRDT1E1?=
 =?utf-8?B?eWVydnQxbWl1alM3cFNONkFXNGpBSU5sczQ0NDY3WldQZjVIWCtYdlhZVTUw?=
 =?utf-8?B?ZFVTb3pyMDBTcEU4Mmx0RnA0WDdKVE5yanFnZ3Y4eWxXU01WNXdkcTdBUU1u?=
 =?utf-8?B?bzZwZlJjcFA3NmtXZ1p3cFRmak84VHI4L2U4ZkRTYUdLQUlzNDJIQTNrUnR5?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9334b3-0412-446e-a308-08dac3680b97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 22:08:06.5942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tjJY5LNnVLctrLb6QmeFa1+slpqpAU1CtcRKERlQXZhBFAX37k0lH9fRzwvLBNCY46Kd16GvAx08aQEqrW+zdmSoaLt7cYDjIIJGiT6AtYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7137
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/2022 6:46 PM, Jakub Kicinski wrote:
> On Thu, 10 Nov 2022 00:26:23 +0000 Mogilappagari, Sudheer wrote:
>>> Can we describe in more detail which commands are reimplemented?
>>> Otherwise calling the command RXFH makes little sense.
>>> We may be better of using RSS in the name in the first place.
>> This is the ethtool command being reimplemented.
>> ethtool -x|--show-rxfh-indir DEVNAME   Show Rx flow hash indirection table and/or RSS hash key
>>          [ context %d ]
>>
>> Picked RXFH based on existing function names and ethtool_rxfh
>> structure. If it needs to change, how about RSS_CTX or just RSS ?
> I vote for just RSS.

Can we use QGRP as a prefix to indicate that these are per-queue group parameters
and not restricted to RSS related parameters?

   QGRP_CONTEXT
   QGRP_RSS_HFUNC
   QGRP_RSS_KEY
   QGRP_RSS_INDIR_TABLE

In future, we would like to add per-queue group parameters like
   QGRP_INLINE_FLOW_STEERING (Round robin flow steering of TCP flows)

Thanks
Sridhar

