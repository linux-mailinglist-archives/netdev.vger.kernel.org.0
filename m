Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F5B699174
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 11:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjBPKf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 05:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjBPKfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 05:35:55 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6331EBD9
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 02:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676543733; x=1708079733;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/RHBfucJnjZhZrRKymffQoleAWasXy+QPQUMQNY2tTI=;
  b=HYd9uTWmWdsSalWk+ASBUlG5CMqVYHg+wvVVuG5ZO9Qga5phkuuDGXwt
   5OTYuVRHZvJED4FrJyF2p73RdejeuAUWC5I15hPXjm4YM6xJwjGKSrwHf
   dhFSWKGX1yc+zkIi9Tvm+yfOL+jYrV50e1K33xLt8NChcLYoc0I/y+PSQ
   FV4NIiMJDdKnbjKuny3uygC/hJvRIDEyDA4PR/0Pkn/m6WmbJa584R/NC
   qy5Oxf0raK4yCp9XtdmuWv0HeZTyzwJzagNMBpeSzJ0WMWS5CZSZ39fxO
   zmts/Hm9kLPx8CKDfrofTLNNaDSYpXTQuhW5fEAAlxJIJymnY6mP57Yr2
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="330322982"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="330322982"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 02:34:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="793981787"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="793981787"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 16 Feb 2023 02:34:43 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 02:34:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 02:34:42 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 02:34:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvTRoPT7TMn/k8Xgut/J4l08fq045QcUeat4AhEEkYc6ei5P9XxE6LdMNvc3PBrbEvi9NA4mRKIhsXuLcQJBtS36OWnU27GsEn+Pbl/PVUdDKd/J00vSggOi/P/fE/EX+KVUuvwNbNx8e+NqbHylxyNjL1IPWBFHvA//Igun/oczEdaAc47KuqK3PNE7wG+/t63gk3zwimj9LbSGfNnKHZPG81xvsiWqEGvmngEBBOdzppTsivpQSlyV3vbCCYRmGEWORPWKN31FUjbn6JTRhjJQWyE73SHS1gcXwnApSRP+K8EBqdfYMLeod3M9M+wQ+oBorVGwDxOcwg4s7Ugqxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVMy0/wpJXIiFs44uc8mu49PsRERDgdYiVGTWahe/8I=;
 b=fl8yH93jBtutbssuAqy/FUIjuYUFUVoDWcmHkVCBwC1vGjVJ+qjJKWfUtkytYoujieyEYj9cp0xgirJy/tI5iu3aJur8SIHYBrCOf3rWP6AJPzPdQ/XYoXotfFMN1HFSIVFQOi5D/Z8Gr2BlS23sP5IsjgF53aPUzmRuPodbIUJJ8TgA3lL2D+Hd6ms4Chqh1i4Ptx1Q0PMskGqjD+aYS3FxGtTi+YpMqKesQYL2qx7nTJ4ggVRZ5TD+w4CKiFAGykr43XyRyrJYgHDZg6jMbn/9fce/Es8y9jYTkJmsHKZ3AV+hs7PITnKuVNx0oufe4jJ4KpOvg0QSt9RdQwrsNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by CY8PR11MB6818.namprd11.prod.outlook.com (2603:10b6:930:62::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 16 Feb
 2023 10:34:41 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::bcfd:de61:e82d:a51f%12]) with mapi id 15.20.6111.013; Thu, 16 Feb
 2023 10:34:41 +0000
Message-ID: <4493521f-a241-ef1f-75d4-cd65e1576089@intel.com>
Date:   Thu, 16 Feb 2023 02:34:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.7.1
Subject: Re: Kernel interface to configure queue-group parameters
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alexander H Duyck <alexander.duyck@gmail.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
 <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
 <20230208163634.51ee1fa8@kernel.org>
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
In-Reply-To: <20230208163634.51ee1fa8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0029.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::42) To MWHPR11MB1293.namprd11.prod.outlook.com
 (2603:10b6:300:1e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR11MB1293:EE_|CY8PR11MB6818:EE_
X-MS-Office365-Filtering-Correlation-Id: 22a67e73-e7f3-4e85-6f23-08db100968da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXk2TuOEDSqeDfKhA8xAtHSRbKzE4WvW3M6hzv/A0ieDxgAHy4wnnb+EA10Hs8N+Lcngow898TOdZmvEuOA/iDh5KpADMmiVOioOAxAQpIMMAQbwARc9+JgG7Ho2pr8cb17eGQE0ErRM1yttDlUnVhQ1hZzyV3p1jdNMfwQ1V22ixjLuoYzfm427vYuGt2d8sVbuc7Cv4LQ5CijFqmGXkQ62qpZz3LoG+8aXU4iTmmmc9f8chYmSVF57R30rqX42pXsXBudVVdsBt5Yl6eQxorjgB+oBODziALJijLiBcSF6XzRuaHIcQvkcyxaKHmVl1xNHFR28J7xsQOeNasT6h0cf3Tvdhfkau+8q30EXEi636zQkuyoKvWMTIq11xPCSLrH7zTIFqn3E6W54u0jZSafI08Fldhk1CqiH5KIhkSg1G7lp0r/g9p5Z7F/MNVGCx2ouKovAHTzMaAWlPhR+bMgDSTwBIYMBz0sO4U2R9fVWrKNAXzsUhxGeNWpiYp+ESOjWojqeFeSN87uUQtVkv2O9riDEmeYJ7+1CkwwuEhrERiTPdXrxRy3VoGTJPPOYiUEYxI0hcHODOcolG+Ha1Hy0As/+a9hgWtljR3Tb4154ytE8PuzDvYKSps706jZ0a9SRm1+tVo/9FsJolrJZVEx7GoU5yFs5qNzIRH8YoA5qiVEvC+raILjx7vn9afGJuzn7lpFWZZKyf7bm1C8oMs0HWBDDCZkscuppiNhKVuY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(396003)(346002)(136003)(39860400002)(451199018)(36756003)(107886003)(6666004)(478600001)(6486002)(86362001)(2616005)(53546011)(6506007)(186003)(6512007)(26005)(31696002)(4326008)(66476007)(66556008)(66946007)(41300700001)(8676002)(8936002)(316002)(54906003)(2906002)(110136005)(5660300002)(38100700002)(31686004)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjFJQSszYlVidmdFZnF1WVVVNE8vRWppODNGVE9pWnN4d1R0ck1kdTFxQ0NC?=
 =?utf-8?B?L0Zyc1M5dnZabnlWSVlPQ2NMem9OcUJ5ZnhwQS9YTXNXNGhEcEhkUURiV1Zh?=
 =?utf-8?B?NnRFWitwaktubWpFWFZIb2tlVExqNEhjNXluQzEySGRjdDNyOUpHZUJCQlN4?=
 =?utf-8?B?dTdKa2tLdVF4Y3ZESGwzcUpWTUxFakl6R0NMME1xa3NNQ1ZPZjRxTGtKVk9q?=
 =?utf-8?B?STk5dHYwNTBoemtnTHAzdHkyeWZTdW9SV1Ixd2owTGphd2syK0RoMlFDYldm?=
 =?utf-8?B?NmE3OFhrZHZySkcxZU1Tdmg0cFZzMnc3b0YwcWVNbFRLUG1RMVBBb1FuQkRB?=
 =?utf-8?B?TjdIRjNoaVoxeUlHYUh6d1ZCdFBvdllCM1cxY1k3UVBNZUhodnczTzhVd3dD?=
 =?utf-8?B?TVNrQ2E2bSs0RzhYOWl6Y0tVYm1FYm5HU3dJSnRlSHNmU0Vyd2hIaEd2bERL?=
 =?utf-8?B?cElkVUI2QTNZVXVWNlM2RkZ5am44eUkvWmZTZmRJUVdocWZXaG52Y2R5QjZ1?=
 =?utf-8?B?ZEt4emJpTFdCWWlvVFZXNTdTZWlaSG1OU1JtN29OMjNUVnBnTUNuUU16S0w4?=
 =?utf-8?B?UnFEeG4vNGdrbWZKYlQva3dRaWxPcnRVSTlCdll2Z0Q5MTdzR2tocjkwSk9u?=
 =?utf-8?B?MnhlUWlmMG5YdWVYWlM3Skp0cVF6aTFMWE5wYmtSYmErZUtUMHVSazZTU04r?=
 =?utf-8?B?NWFpSTZHcHdEcnhtS1hZWi9TZlpRQlFram9oTXBod1JVSm03RW1GRWVNR21K?=
 =?utf-8?B?ZllQcC8xVzU0aHRJQkVkS0dydWZvOWJ6NnNhb0FyMmxNakRBWEZlejd6T2N5?=
 =?utf-8?B?WE1abTlXTWZaUDEvYmtOdGIvVkpCaUdSZ1BmOElOQWN5Rk1yZ3RFcytjUW1L?=
 =?utf-8?B?Y2lUYks5QThXMUtnL2o4MWViSjlLYnhKQ2doYXY3blBLWWk2TW42NFNrSXhQ?=
 =?utf-8?B?emY3YS80ZWpVeXltMG9jTkpmT1A1S0g2QzMrRGcrU1FCZldlN3BqNW9EdDJn?=
 =?utf-8?B?aVp1RmVFWFZSWm5CRlFSbHp1aDdBWDZMQzBGMFhnRzZCZjBYcGJoMWpkMFRJ?=
 =?utf-8?B?Qk9aeVBHeVdPbXlpVzF6ZGtTTHFzVVhpN1BLSmdCN3hLanNFdmVuelRGQ1Jz?=
 =?utf-8?B?cUJoQW50MldZcUxNY2M3M2tBQXdtc1pGK2ZXMGdTRUtsT2V6bXorVE9aYytU?=
 =?utf-8?B?TGZUamQ0c0xPRGs1WXlkSW9PTEVDUFA1YklPYXdkc3pJQU5CMWZWRjJYZmN2?=
 =?utf-8?B?dXZMYU5OUXhuQThLZWdEVWZvd1NTMjlTY3FFbEpGWWZxMXJ6TUhZUGIvRDRl?=
 =?utf-8?B?cjJYU3pBVWtGd3c4Skt5eFV3ZUVlakxRS2lnRkRTdlpBcUhTZWVrNVYzZ1NM?=
 =?utf-8?B?Q3lUa0V5amZTYzVjYUFFcC9EQUtYbGkzQWRZOWdwSEVENHRMODZFUWRBNUxu?=
 =?utf-8?B?VWRNcVRjdTFzbDZXdW9UOGF0YTFXZ2RrS3R4K3phc05lZkUyZHRIazZLUlJL?=
 =?utf-8?B?STA5ak9YWjZPZHUzMXFETmpJRk8zcy9RNSs0TmcybW9OWlprU09FYWExQU9t?=
 =?utf-8?B?c3I5Y1hkRkpXV1ZORWNQUWhaejVNNldDN2Z3dEFEYUJmREdDcnA2Qkp5dnBQ?=
 =?utf-8?B?R0IraWlZMm9odXpUa2tMWk4yakFHZ1ZmR2wvR2w1dkgxZ2hTVE01R0VCWVFW?=
 =?utf-8?B?UkgyTlNGRE5ubzFkemlJTFJTVkNmbHNKV0N2dElGR2V4K25leXlPbm5BeFdV?=
 =?utf-8?B?NVNMTzVPRkU3YXhmaVBhc1lYclhpUEhCejNvSDNkQW82UXFKcVc5eitWemwv?=
 =?utf-8?B?UXg1TGl6aEIyL0xUV3E0QUMrWmhyeGg0bWYzWittRmZKRG5QcVZsVTFDY2dU?=
 =?utf-8?B?NGlweEtzRVBZL0dlODZYVVNyZTl2MUNRZHlLQ2RjS01Za2NwMkV6M09XaTVP?=
 =?utf-8?B?aTVKQVN4ZnZMOWtUbG4zQVRYaGZ4QmtraXNEWUx5UjE0LzltM3V0bnV2dS85?=
 =?utf-8?B?OHpuUFprVEYwUElFOGhqMzJmRzk2cGNOeUdsSnhsL2xidzNtNHdyUXNnWC9w?=
 =?utf-8?B?eFRIMWJ4dGpHOXBYekRRZVpQR3pucFpuM2JNMDRvTXVTNFF3MDN1WW5SdWhN?=
 =?utf-8?B?clcwV3FlTVNmNlE4Yy9rRmhsMU9RNUR4eUZuNmt3ZWFUQnl3cTJxNGRKNGgw?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a67e73-e7f3-4e85-6f23-08db100968da
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:34:40.5609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Job7Ydw7b4NIo++6z5Fvg6HkvAV3f+LBHweV50hHJQjEvyn7WB8I2hGvTEz7e1e9IAbz12nK/ekJ9uRp6eSaP9AyMYaD3/MWUSbqjhBWfnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/2023 4:36 PM, Jakub Kicinski wrote:
> On Tue, 07 Feb 2023 08:28:56 -0800 Alexander H Duyck wrote:
>> I think much of this depends on exactly what functionality we are
>> talking about.
> 
> Right, maybe we need to take a page out of the container's book and
> concede that best we can do is provide targeted APIs for slices of
> the problem. Which someone in user space would have to combine.
> 

Agree, a common interface for various parameters for the queue-group 
does not seem like a practical approach and the interface to use is 
largely driven by the functionality itself.

>>> 4. Devlink:
>>>      Pros:
>>>      - New parameters can be added without any changes to the kernel or
>>> userspace.
>>>
>>>      Cons:
>>>      - Queue/Queue_group is a function-wide entity, Devlink is for
>>> device-wide stuff. Devlink being device centric is not suitable for
>>> queue parameters such as rates, NAPI etc.
>>
>> Yeah, I wouldn't expect something like this to be a good fit.
> 
> Devlink has the hierarchical rate API for example.
> Maybe we should (re)consider adding top level nodes for RSS contexts
> there?
