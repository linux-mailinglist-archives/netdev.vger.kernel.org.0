Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A370502FE6
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 22:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352081AbiDOU4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 16:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbiDOU4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 16:56:02 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05A345072;
        Fri, 15 Apr 2022 13:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650056013; x=1681592013;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kRyACiKrHun2FM5vMlIhxeLV1FMBKEJ96JdZBDqwwE4=;
  b=UK84IlweP02QSWmsVsI/YtLEPkZp4mIzSjxZV0M5YiQ23WVgZzxBssJM
   /MskXIHD9MwGi9ouvnEXIPApBUxyraqBVTtcAsbjXRqrzHYvRXkDwdyH+
   yUuvYX5FR56o6x2eq9m3etQO5ntZx7CmSeFOWuCvfuVF8OESX9A6u0x6f
   q+7orogIIKEEQ92MFmUYU2AHdmnhqhLsUGYJqGyK8khkfyy75afGiEl2j
   shug1M59GrRlCydUC8VZHpmIGV+AG9v9m0GJH0mhFEpGBV47sHlm9PD1J
   8HCjsq7oFZBoCc5FriIrzcpSxJs6vHf+SIx0aQ+W0kwLd6DPe6dNqBq8U
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="243159452"
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="243159452"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 13:53:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,263,1643702400"; 
   d="scan'208";a="656548163"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 15 Apr 2022 13:53:27 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 13:53:27 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 13:53:26 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 13:53:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 13:53:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXw1scFH1ifOqSXFbH1kdO0GkM98AMPj8MgBPy9lQLQnqw6wI3UgcuqnS9/ks/x/jN81kQBYiL3Nf22cYaxPw+rO+YxHkhfHtYD4fAVb/W7vwO0H/HLv1eluhXnyTzh4+lGY9eDED4U2jWvFYt8wDiELJWOli/yN0Dher2BpI0zEcsuobJ6ywmpqYDZgwL+eoZBnX/8FuTjJGL05hZkYpBpce+eXFCNYubIKuwfOdASLoA4BYB3n8ShKBLd8b6wr99xkyghaipFeDxrCj+OsI1XCx9w/7LaFt2/mANz+VjWI1Fc9rdPLay2owIGXYc2PfCUGsh+OJUovK0EGrWG7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HUv7NGVELgvLJ+0R1GXbXLiXTBLjxK7yru6XZXg0z8s=;
 b=FgnluCmzz9kfGbne6QYW1ueBaiYT+i7nHDHwyzTfXEDdAi5YlOHLuktU9udrOArVPaTl1KqmQjwO64I8/cOxpMrJ+lsfhYuzSUGLtBxnFedwY0dL/fQw/xRJVrvAv0zv1Pwzba4+3Oayboc4QYMs5m/WR+tsJbtn9xN0nKY4PV5TmrhQWuSL70k+A858cM5ZmPvlcg+a7gcjfWl8TVyc+mJJ/hXWJpZOjcGpcIPcY5jkXG/1oY975DGzwnRhDHUdavDOQahdkVQ/EuBmevCEGsthK1HWhr+QwnQoVPYjc2ESYdvO2ggocowG/0qk3QtAKfmDCucZFBq/XwkG65VYOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by BN9PR11MB5337.namprd11.prod.outlook.com (2603:10b6:408:136::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 20:53:23 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acf9:f012:22dc:c354%7]) with mapi id 15.20.5164.019; Fri, 15 Apr 2022
 20:53:23 +0000
Message-ID: <9dfffc57-4733-37c9-5668-97b06a40a202@intel.com>
Date:   Fri, 15 Apr 2022 13:53:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by
 cfg_lock in ice_vc_process_vf_msg()
Content-Language: en-US
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        ivecera <ivecera@redhat.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     Fei Liu <feliu@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        mschmidt <mschmidt@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20220413072259.3189386-1-ivecera@redhat.com>
 <YlldFriBVkKEgbBs@boxer> <20220415183845.51a326fe@ceranb>
 <CO1PR11MB5089695CB3733F4B1284E3CED6EE9@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CO1PR11MB5089695CB3733F4B1284E3CED6EE9@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0072.namprd11.prod.outlook.com
 (2603:10b6:a03:80::49) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9dbe087-0454-4315-2e78-08da1f21fb31
X-MS-TrafficTypeDiagnostic: BN9PR11MB5337:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BN9PR11MB5337BF75D7C2D73B935D8A18C6EE9@BN9PR11MB5337.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RBozKyhwBBxnxeD/MyPY8aLu0BAEFGloqCetkMskN6uBbHpMKCYlJw7gsUh3gLnKAA2/b0GkxOUQ6YEMBB66mgYtqk3SaIY1XFYUsUp4qGadpx9vXUS5X8K5HvcqhAenBM45XuDscRF8fJWPZIb891VKUNn+q2kokZyYw1leycbWd/5qw+4W9J3APRZ3Tc6KCIUogigqYXuxtG0RUBqtilyRVq4lj38KVZ5k9zXCbAR+vWKAikad3ugXFBSCT7uVXu0K1EVtmN3aiZj8RK9es8Dq24XAIe9nTkEK7kIqYbhxVW+4gHpHrui/FAQPVyOmT93bniYK0MZ44S7vfiOPsAc5/Xk9fnu69/IzGXxBRoL2OBwHnJQ9bXZ9I9Bm/he9EcA/4As91JPP/5MPbfw9AkwYi/oM7HSxiIjs05SLmRTsCxbml04A2zp+2kAhsjJjw9f69pzbK5YAr4OhS1+qTFiNhgf//HNi+Y6ncykBEgmnF67KoQq/oJmSkws8Y+RTAF+pIG9cij4xOBjfh5iXvwDEo4IPyAlhQ9aCqK0D7S0m+y52TOA0rzf4wJWKldkVyWFrz/XVIvxobJTiLW2k9PphN+v5xKnfoIsi7lZ0ZzGeIrAY9bgD0jkdMRsvBUSD7vSVX4HZYSnWVZVV87iwDEVdmXxhSTbqIP8lDGEA6tW8cbN6YnuUAtriAo09mzCW8RtYwZ2j9MeBjCLXmZlkxD1p8cOHOn3fEPOBUlB15T4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(36756003)(66476007)(31686004)(5660300002)(66556008)(53546011)(66946007)(6636002)(8936002)(186003)(110136005)(4326008)(31696002)(2906002)(316002)(8676002)(54906003)(26005)(508600001)(38100700002)(6486002)(82960400001)(6506007)(6512007)(86362001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEg1MHNLNWg2STlwdjN5d1hOZW5LaVpKSkpyNVJ4bXlSd2F1aUIwVkFROUhP?=
 =?utf-8?B?RHpxOGZyTzFZbkw2TUJKRHdxcEVDOGpQSk1QL0FqQThUV01uNUl4dCt3bklT?=
 =?utf-8?B?enNhaUtyWHRIb0RlWG9VUjlyTER5WkkvdWdsQm5RbGFUSS9VUjhzS2NiR3k2?=
 =?utf-8?B?MElWejdVUHBDUFU1L0ZKWUtJdlQ3YUJsTm0wbTB0KzBNTGtDanp3QVBNRlly?=
 =?utf-8?B?T2huVVdHWE1hdEdSd3E4aVNGMHRLRUN3MkwyS0xseWdxdVVRM3hTYm5zZm1q?=
 =?utf-8?B?MkJFNkRsdE5kK2wxYllEMW1tWlN6aklwdy9qUFhWdUhJd0dvMU5MU05QTzJK?=
 =?utf-8?B?b05SdHk0bWU2OGM5S2NQY3dDeW9kWUs2OERqb1k4WjIzOHJtYkVUMWJqVEt6?=
 =?utf-8?B?SnZLNmRVcWdabWpuMllvSHNVTEtaZ3g1MnRFMHczdDdNakRwVC9xK3ZpT2pP?=
 =?utf-8?B?am1sK2FRN0V2L0hsS2VHTkNvMzhQQWkwRmVsVlBmK0YwV2JEMnhxdHVRK25F?=
 =?utf-8?B?SnphSWhjZEx1emMvK1RKUUpiU2Y2dTBCMmdvTkdKc2ZGcHRTbUtUY0Z4UWdZ?=
 =?utf-8?B?SWdCNllvUHNFdXloRGhoUGJXNlFmR1lWRHo2dmtBbEFZa0cxYTNFaG1ucjNH?=
 =?utf-8?B?Mng2TnpRNWtOQmNTdDhqWitkM2Q1VEFxQnhCOXM3KzhydXUvdXJsa0Y2eDc4?=
 =?utf-8?B?eUYrcGZ3Z1cvVGpwRFEzQ21Xb1RqMFBUdUJmdzNTbURQY0FNVXk3RXJwMG1r?=
 =?utf-8?B?UjVKTWpZa0ltSXVzSTNLSHRqS1RmTUdicGpyeVRYTW13OWdVQXMvU21XczdB?=
 =?utf-8?B?Tjk3dDVIQXZYTnJpdjBJWjVUTk5TYUpPRDhLbS9VNHl6blZCR1NpdUNKU2Yz?=
 =?utf-8?B?Q0wvaHRLOXpHSjZlSE5QUEZxS0hYREwrODhISkpLUEQzc25idFRicXVFcVRs?=
 =?utf-8?B?MForSjAwTmRDUDErUjNocHliOHQ5ZWk3TFpIMFJUMHNOWjhBQVl4R0R4eWFz?=
 =?utf-8?B?WUNPY0N1Njk4ZFU2b2NyRGRmMUE2VkxJYjN2VitzeEpVSVRGb0hXMytCMU5O?=
 =?utf-8?B?a0gzNHVLci9qQmNoNTRSZlZuNFJwbHZuQ2o1MEk5L0ZXSmxzSm5iMzdUZUZi?=
 =?utf-8?B?UmJqOUJtYnh4a0VzMVd6alR6KytwMjRzZGc2ZlhsRjRsSDV0Qk1CclpVN3lz?=
 =?utf-8?B?eEFBUjVTdUZPM0JwN0lYNFIxSytVdjB0ZXBzZnZtdEI0bDNReW1BamZ0Umpw?=
 =?utf-8?B?S0syZFdtTHpIVktDQm96NHdqVUJ3QXBSYkc4djFFdUtIMkFYaHZ3bHVIcG1n?=
 =?utf-8?B?TW00a3RoeGhvT0NuejhqdkdEN1l1OVhXVzQ5UkRBb2t0R2NDZ3NscVQ1OE83?=
 =?utf-8?B?ZEJsZGZGVDV5dTMrdWhoR3RWaUdoMEhnWDlseW1aTnJ1RzBBTkd6UExjZVZp?=
 =?utf-8?B?bVVIVE5HL05aUVEvMWt0QmJOTmw5RFNvMkpJWHl4Slg2Z3dNQTgrSDZKcEVZ?=
 =?utf-8?B?M0dWcUZJMk54YmxzN3g1b2hDdHkrSWhyS2pka2JaWmJCSUs4OVhLOUV0eHBK?=
 =?utf-8?B?emdpUGs5NEhGVFlidmRzVWNwdER3OEpvZS9CWjhudk9sU2txN1UwMkoxS2Ft?=
 =?utf-8?B?cXF0U0p3cjlyUHlBY3cvK3dMRjVHVEpvODVDSGNscGFkNXFmekEwSUdUd0ky?=
 =?utf-8?B?dUVrYjZEcjJnNXRNN0lUSmxkVnZ3cE5oYXl5UUFoRHk3dDFGN3FLdjZUbVBa?=
 =?utf-8?B?V3RCSUtLQTIyTmZhajNCWjVjQnpBSFQwQ1k2VnNiVGF3TXQvekxCN1h2NlEx?=
 =?utf-8?B?N0ZBWFN1SFFqK0ZLRGhna25tQTI4TzNqNEZHem1zZ1Zmd3ZEaGM5c0swRjRD?=
 =?utf-8?B?L1ZxTVU4aEpQMXpqL1JqMW5Ja25oUTBBdDFRREhCNEZUQmFTOUZmN2lWU2RB?=
 =?utf-8?B?S3R0SVlXY2V6ZHJkZ0Q5N1JESjJOSVVVc0NYV0R0Zzl5V3Jsc29MQ0RBbjRs?=
 =?utf-8?B?RWZNSnh4Y3Q5a0NocWhMSXZzZTUvUHMvQW5kbFFmcHFNanNnb3gvVkEyMFpm?=
 =?utf-8?B?VVZxL1p0SFk2WjRqUlNjdVkrb04veUlMNHRJdU0yeWJwc3dxZE4vbnFxdkFR?=
 =?utf-8?B?ZGtrbGdqdkNMNjNrelNKWjZNTk5Jd0ZCRkNIUkRMSmc4MmhUK2xyYXhlQkg2?=
 =?utf-8?B?UDdVa1lVL1ZPRnh0MEFvQVFjQTA1eFpOWG4zcU1NOXJ2SXA3RHZrMU1kc2V0?=
 =?utf-8?B?dFZFSWJhTjJUNlBSUWpFTkFzTlA2aE5XWmFxbDJmVHBEUHJsc2Fnc0xESHNB?=
 =?utf-8?B?M1FtWDcxSTgxamdhdHFWNG84TTFKNGxOWThlWTNkWDZkQjdFSFJaYmRtN3lN?=
 =?utf-8?Q?0RMEGg8qnZuQGHUo=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e9dbe087-0454-4315-2e78-08da1f21fb31
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 20:53:23.7220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrsyFdKE4jX4R65/Dyzy8CQYv8y4KOU+nr3rAGDpVQGHV43DvLi8y4AejlrPowyf246a9+ucNecyselSpyeDuRGfddISvMxM99OPOmyt1FU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5337
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/15/2022 11:31 AM, Keller, Jacob E wrote:
>
>> -----Original Message-----
>> From: Ivan Vecera <ivecera@redhat.com>
>> Sent: Friday, April 15, 2022 9:39 AM
>> To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
>> Cc: netdev@vger.kernel.org; Fei Liu <feliu@redhat.com>; moderated list:INTEL
>> ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.org>; mschmidt
>> <mschmidt@redhat.com>; Brett Creeley <brett.creeley@intel.com>; open list
>> <linux-kernel@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
>> Subject: Re: [Intel-wired-lan] [PATCH net] ice: Protect vf_state check by cfg_lock in
>> ice_vc_process_vf_msg()
>>
>> On Fri, 15 Apr 2022 13:55:02 +0200
>> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
>>
>>> On Wed, Apr 13, 2022 at 09:22:59AM +0200, Ivan Vecera wrote:
>>>> Previous patch labelled "ice: Fix incorrect locking in
>>>> ice_vc_process_vf_msg()"  fixed an issue with ignored messages
>>> tiny tiny nit: double space after "
>>> Also, has mentioned patch landed onto some tree so that we could provide
>>> SHA-1 of it? If not, then maybe squashing this one with the mentioned one
>>> would make sense?
>> Well, that commit were already tested and now it is present in Tony's queue
>> but not in upstream yet. It is not problem to squash together but the first
>> was about ignored VF messages and this one is about race and I didn't want
>> to make single patch with huge description that cover both issues.
>> But as I said, no problem to squash if needed.
>>
>> Thx,
>> Ivan
> I'm fine with either squashing or keeping them as separate changes.

Either way sounds ok to me as they are different types of changes.

Thanks,

Tony

