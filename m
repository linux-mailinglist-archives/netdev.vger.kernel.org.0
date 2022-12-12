Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEA64A674
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiLLSFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:05:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiLLSE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:04:58 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1929513E36
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670868298; x=1702404298;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YLdStROJbLvtjqBPMWwjRJ6g5kwujmCwu7P7mpZ8MXo=;
  b=FPWuNxbCoDdzw3h5QOUa8hAk7wSi/EJPLBkc5J+4/S7FKgZanYOiyPge
   GkcqQmpZnZ1op5mUIyFrjPWGjEw7wcUmuJWc6XgU992uN53Q4FD/PvVD1
   BvLcGF2RoK3CmCFNgxr6+1oKho2EO+swzIwfv0VQgV1WWEfAp6CPzBHY9
   1Kcjpn/3FbYBaGe/7J6iUyDFHSxT4WDEv8PyvTg2uS2djUNA8bAVUkXn8
   3al5F1ZALQm2hQZHKwJuGW0FNfxPWlMor1sy/qO9Gql8+6TdzIezrKUNc
   E6de2hLZ2W2Ka/urdn+xFkm6NLnhD3IZQIIVvhAg3LK7nvOgzhmwB7Twe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="298268897"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="298268897"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 10:04:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="755041170"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="755041170"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 12 Dec 2022 10:04:42 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 10:04:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 10:04:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 10:04:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt8lPQC56flwGEPo1z7eFasrOQk98b61g5xZS/xPa+2V0o+jn/xmMlMtGJHulyyYVyKTFUZY7ySsoFxCDOmPC+brCObplQQ4ToOxVd4HWpkuqq2d5hp/D8f7ZHJKHOM3hLIb6wD1KESr0SWizXi+aKWVAEDT+eJ7+S3IuM+owRSVOWbEb14sH7HnLbA2bBNj/CBLAEnvglUg3WsETrkWqy5+T/eIYy4uvLCt3mOmaonbUKuw1DM00PsSXnIWDiG6UHR2sUTpVp45PwpcGcnSFH+bkNBCaQOkVpavrlhn9f9LWrAf7+PZS/AfNxVHMzOpeZy3J9JgkyzoKAwXL0qRLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h4SmTFJJbCDllwwxtygCY3z+Rq11UbESmQfHWctMkSE=;
 b=cwpvHegBhW4GNQfb3f/S1OGIbh2syWC5ey5AtwYOymwKbA+jMx/JlBX4scKXqGGUM1AxvL05BSSAe4FCe6lEEmO/PdXzVRRZqpEJ4ZWbOuvdV8gAlSnvs36aXgt3oLkNUfKLa3TDHzLor1D+pPEpLI3JwXE8qU4F63dJv9kvDdChdECrlpuoWhp5EyFJT0RVtg8v07fNZZXiRZgtpXeaqPhdkjY2I4qMHz/K9pSDhmzorcrcoeasHzJbHkR3YSxxzWt3H/wIwbiLToM0YHQZcx7/et84pSvy8lkJZAcqDicVqpLJ7ocqHukmFA3Vg0iWCvvjquYslPslhP0/kPTwrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7442.namprd11.prod.outlook.com (2603:10b6:8:14d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:04:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:04:40 +0000
Message-ID: <b5fb8890-2df8-fe21-0615-a2d3fa9a6a86@intel.com>
Date:   Mon, 12 Dec 2022 10:04:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <shannon.nelson@amd.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <jiri@nvidia.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
 <20221205172627.44943-2-shannon.nelson@amd.com>
 <20221206174136.19af0e7e@kernel.org>
 <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
 <20221207163651.37ff316a@kernel.org>
 <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
 <d194be5e-886b-d69b-7d8d-3894354abe7f@intel.com>
 <20221208172422.37423144@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221208172422.37423144@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0174.namprd03.prod.outlook.com
 (2603:10b6:a03:338::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: f6294225-ba07-4d5d-9523-08dadc6b56bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PutlaitdFNt3oAcCA6IhatMSkWmMEDPXa8eer7UQgWW1j3dhL4eaVsJuiyJ3MeTj1AvNC7Wj5ryzExB+c//8DZMxlk5kYtcfdisnI427sJT6ulD6fVvUONjaEG/eG1olIpvGdpIxUTfh9MCecJEr7q0siHcD59sE3PynjhXCSErlUVN1+LyZm8sH7GGB7hvtjzzQ85C72BkOo768UFNtGIJD88JoC/hu3u18QunPjNOPkh52QG1jLrdbyuHPRTFqIGjvqPsZVoKMW/6kbl/P+FB61HjnTB31ZBzM1mV6QpLx7/iMT/ZyyjFuNLYIg/M3u7ec86cT699ybdoYyxNBdpwV8iKa49z6ZMfLK3ZPa5AN93L/LHZua7PufWkVfIJgX0C9vTS4dZ4T1NqI2IOxPz2Evo6xLA192E0iVFga3k/A6ytAtlNHb+bxeRc2D9C8O4OmjKoSiE3nHcAdFTJQlt/2nqLVC514ymgZJ9LMQI86qofwQnPH2YfC+VzQYwO1GsKYVMEz8zSQR2hnLeo63prLLXzAhW8srM7cONds/A6rYUTRCqUPIbMdxdcmbWVayrQCMxThmFcV1ph09ZO5BOyJzR0Y6U2+chIj4c/LFzslMTxJ+wGLWCo4m/kTXJmSotw8eI+sP29+ewiFxmz+rX7HutNLG4CKHpY7HWJvnu1J6K93tc0N6oZlsA0thjeHN6F66mSzams8UDz9QvS34aSSSMJem5IDyrhWsxhIGDI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(346002)(136003)(366004)(39860400002)(451199015)(38100700002)(82960400001)(31696002)(86362001)(6486002)(8936002)(478600001)(6666004)(41300700001)(66946007)(66476007)(8676002)(66556008)(4326008)(316002)(6916009)(6512007)(15650500001)(2906002)(83380400001)(186003)(26005)(6506007)(53546011)(2616005)(5660300002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUEyK055WFIwUHAwUDcySk51MEdOelEvTGhTYkNQWitwbUp5TVVzQVE3c3Zh?=
 =?utf-8?B?b2x2NUNxdExZZ1pROEVXMSt1Q1NqUzZvR0JtM3RhUCs4TGwvZnNadzgyUndW?=
 =?utf-8?B?NlJEVFAzT0hYbzBzVGVTTG5lQWxCNlNFUFNLZW5uMy9pMlNreXE4K21yNmxv?=
 =?utf-8?B?clJhY280MHh5U2poRnBjQXN4a3NGNHZhekhjZWlNOTIxVy9aK05lTTE2cjVR?=
 =?utf-8?B?YzJ6QWE4STBVWVluejJYc3ozLzg1bzJBajlBTG00OUVwcDFYaUhHNkx0VklT?=
 =?utf-8?B?OTZwMDJ1c0hZYzJOUGIzM1JKd1V4dGJGUFE2dmg4WHhLYTEyK0pKWm1GMzND?=
 =?utf-8?B?Kzc1ZWZqbFl5S3NMNHdZZnNrSkNJMnptZE15UjlZeGJqOW16dk0wQytlT0VT?=
 =?utf-8?B?MmF5OWtOMldGS3JmUG5jd3d0T1VuRzFiNW5Uc1NFVElDMk9ZRG0wMWs3NmFF?=
 =?utf-8?B?Q2hhM1E5cVlPSjBGRjlUWUFaMXgvaEhHSk5nTEtZdVQ5MU83OC9VUVZZR0J2?=
 =?utf-8?B?cmNEMll5UEJyUjVaZ0NrejA4eDdWR1NYNlNobTlPVlRuTXRaRmpwaGNERE56?=
 =?utf-8?B?MWtPSU44YmNkbzVQc2NENG9OQXkrRVhpNDVKQTBTaU94M1l1U3VVWUJ6M2dl?=
 =?utf-8?B?MkpjYkd6dHBoMGxGMVJzRXZYNEFqSXVGV215UHo5eE55dmZ2UE0wemRwTjlo?=
 =?utf-8?B?bGNJeGdycTdmTkRSdENEc3NCM3lvOXV0d25mblByOTgvZWl3dzAyZkhyUXNv?=
 =?utf-8?B?eTc1cm1IV0ZTWDM2V1ZVN2U2RGtiQktsYklFWG4wNGxtcTNuYzhMbGVIUmM5?=
 =?utf-8?B?aWFoY0ptcjVWRUwwMXNiNHVja0ZKRVZzTFBOYzdlSWwvUFAwTWZOS2J6NkxH?=
 =?utf-8?B?OUN0ajdlRWdpZlhiYVBlNWtUcERqelQyTktNZFRFUEJTekcxL04yZUZrSFNU?=
 =?utf-8?B?Uk9lT2cwSGpQd1NqZUp2ajdVNDltVFVkVzJteGZEbFNlcG9kTmxsZmdZRUtT?=
 =?utf-8?B?SUxJSWdaZ2VUaSt6TmNyV2dVOHIzMkg3aFRyNElvS1YxMTVrZmt5OVlKd3NS?=
 =?utf-8?B?Mi9nYW93U1paMlRxZTlFUFloalAxL05rQmxsNXBtNVVKRFA2M1V5cjM2MGI2?=
 =?utf-8?B?dE5tZ1U4RUZJbHFrcm1va0VHdEEvMDZVZEZjMjRIWGt6dm11aDMyVU9QQlY2?=
 =?utf-8?B?U3lmeFJydWRXSDlBdFJ3MEFwRlNpeUgraFJRZ1h5WUdtU2FLMDArdVFxalZ4?=
 =?utf-8?B?cHc0TS9YNmR6WWNFMXBaRnZjMHNSMjdBaTVUc0ZaZGZYZXdRN0MxT1RUMXFK?=
 =?utf-8?B?NkJ3MWMvcVhnbWpXR2xnOUJhek5UNGVYYU9LWDNINnJkMlkxOWpnNzNKc0RH?=
 =?utf-8?B?Qmo3Y2RSTlBkZEJucDZvNktuRm5EaURIeUkxYk5jVFJVamdydmIwY1o0QWZ2?=
 =?utf-8?B?NnVMNWNEM2FXTlpHcVRlTks4YmkvVnd4bE1VUkQ2TWxDL1N3UzdPdms1NEpQ?=
 =?utf-8?B?L1o2R0J0djd0b3AzV3pQS2R6T3RPc01GMDNpSlp6KzU5U0FmZWVxMkVZN3hu?=
 =?utf-8?B?RHVGVm1iMHpGUmg0MTRKMHVQN1ZYV1pNcnJjeU1JYjBieHhmZTZ2WEVCcUV6?=
 =?utf-8?B?LzYyUTZrUUEyaGozZUJCb1RsUlZzREtUWDU1dlJDTFZMSGh0RnNhNUwxLzlm?=
 =?utf-8?B?bVZFQjl6RnQxQlNNZ1c4Z3NYTVJFK0xVcVkrL0FCM2R4YW11VWRpZy9PRFAr?=
 =?utf-8?B?TmdLUkdXUHhMT0krQzl5eGNoS05FU1F2SzNRMDFSRVNRNm5Rb1FUZ2ZsTHJ0?=
 =?utf-8?B?K0RNMzlrdXAyVTJQN2hOZ2l2czR4QlFlNkloL2ppR2FpUG52bkpyeTRSZFNk?=
 =?utf-8?B?cjh0bnk3VnJFUzl3T2RBSzRDUHl6SitIREhpdE9OQmtJREtzbzIxblBleDlo?=
 =?utf-8?B?RFRleE5sOHI3ZXBaYmFhWGtmSjJFdXZGdzlrRm1BYWl3ZTBkYk44L2RGUVds?=
 =?utf-8?B?VHcyWEx0cjZiQXM3RmhhdkkzcHZib1Q5TTgvWFhIcHpDemdmZ3k4WFgvRVJ2?=
 =?utf-8?B?aE5ON2VKK3lmK3BaWkhhcDhwWHgvdEpYVXozV0h3MDBzb2lhdHdLMUtxZnVM?=
 =?utf-8?B?WE9ud0pyeEZBTGQ3MlpsU0s4Qi9ybFE5alEwT1QvR3JaalBJQ2VkN0RSY0JZ?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f6294225-ba07-4d5d-9523-08dadc6b56bf
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:04:40.2759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yepFQAndUOiUbYPXVpJKSGSYlFTtmQX20XIXCM/Io+1hVsFa1WRN/ATEiXS0s7Nc7t3JhFUEr7zeICff80EuqhIRVSrVUzPUlFL5uxlUP7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7442
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



On 12/8/2022 5:24 PM, Jakub Kicinski wrote:
> On Thu, 8 Dec 2022 16:47:31 -0800 Jacob Keller wrote:
>> This is what I was thinking of and looks good to me. As for how to add
>> attributes to get us from the current netlink API to this, I'm not 100%
>> sure.
>>
>> I think we can mostly just add the bank ID and flags to indicate which
>> one is active and which one will be programmed next.
> 
> Why flags, tho?
> 
> The current nesting is:
> 
>    DEVLINK_ATTR_INFO_DRIVER_NAME		[str]
>    DEVLINK_ATTR_INFO_SERIAL_NUMBER	[str]
>    DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER	[str]
> 
>    DEVLINK_ATTR_INFO_VERSION_FIXED	[nest] // multiple VERSION_* nests follow
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_FIXED	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
> 
> 
> Now we'd throw the bank into the nests, and add root attrs for the
> current / flash / active as top level attrs:
> 
>    DEVLINK_ATTR_INFO_DRIVER_NAME		[str]
>    DEVLINK_ATTR_INFO_SERIAL_NUMBER	[str]
>    DEVLINK_ATTR_INFO_BOARD_SERIAL_NUMBER	[str]
>    DEVLINK_ATTR_INFO_BANK_ACTIVE		[u32] // << optional
>    DEVLINK_ATTR_INFO_BANK_UPDATE_TGT	[u32] // << optional
> 
>    DEVLINK_ATTR_INFO_VERSION_FIXED	[nest] // multiple VERSION_* nests follow
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_FIXED	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_RUNNING	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>    DEVLINK_ATTR_INFO_VERSION_STORED	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE	[str]
>      DEVLINK_ATTR_INFO_VERSION_BANK	[u32] // << optional
>    DEVLINK_ATTR_INFO_VERSION_STORED	[nest]
>      DEVLINK_ATTR_INFO_VERSION_NAME	[str]
>      DEVLINK_ATTR_INFO_VERSION_VALUE     [str]
>      DEVLINK_ATTR_INFO_VERSION_BANK	[u32] // << optional
> 


Yea this is what I was thinking. With this change we have:

old kernel, old devlink - behaves as today
old kernel, new devlink - prints "unknown bank"
new kernel, old devlink - old devlink should ignore the attribute
new kernel, new devlink - prints bank info along with version

So I don't see any issue with adding these attributes getting confused 
when working with old or new userspace.

>> I think we could also add a new attribute to both reload and flash which
>> specify which bank to use. For flash, this would be which bank to
>> program, and for update this would be which bank to load the firmware
>> from when doing a "fw_activate".
> 
> SG!
> 
>> Is that reasonable? Do you still need a permanent "use this bank by
>> default" parameter as well?
> 
> I hope we cover all cases, so no param needed?

The only reason one might want a parameter is if we want to change some 
default. For example I think I saw some devices load firmware during 
resets or initialization.

But I think that is something we can cross if the extra attributes for 
reload and flash are not sufficient. We can always add a parameter 
later. We can't easily take them away once added.
