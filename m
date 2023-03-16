Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AA56BDAEB
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjCPV11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbjCPV1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:27:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAD4E41CD;
        Thu, 16 Mar 2023 14:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679002044; x=1710538044;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7VKSZAsDHlVq9hhExDys+P0uiopBGUxh5yxZ95icWDg=;
  b=cjqlv6VJ8FLMfuo/UQmzNCmi/MRaCm+kbI995yUKtOgOx1CXr8+FM1L0
   AisLl7Keq+YvwwiTRfSx+QHH7djtXaxACsC51ZD0TboXShCTN68SlgVyy
   mrbW1nWul76YldCN3Wum5E9X7jKb7g0n9q2CBelRvcz8dbae0/+Zk1RS7
   jLbB4OiXxxNS57YXG2OQUioLiIVuVM/7QHBVK0FOYel25V/Cr5ObZzdXu
   NqPIKUjn3SDpxWqcKzDI8MQSGH//2qgBWg2PnquleuWRxwtJQ50O4VDcd
   9TT1u1jDIIXbYQ8iqiPeRJBbKCf5WQk/uAgmvF/fKUhBdKX1wcN9OdFZ3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="318511996"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="318511996"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:27:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="710287736"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710287736"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 14:27:23 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 14:27:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 14:27:22 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 14:27:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2/fiNanoLhjZQ72PR3heGQsD1Ed6gFqoC9kFA7iE7wraOUppr+bcvg/fWpgmqvqdE2ek50w6IefVLm723y5db5OjaEuIsXNw6b/L4CQltSf4aTe8maoGnknkazYpuivQaf0eXo0sRyB1+VQNuhS5cSXGtYVXlk0b6EVbS3DwfId9K6ZnplZuK1RwMWjeE7S7Nrb17GiAKYQDDIDc8M+FHJoZKw40xCVQHiORyJHU8X1GRSzfNs4UT6h32bPCx7lhhKJjqPyWoO3S5hHHzh9NAL1SzgvZDYlor0sdV8RQpPyvfGfSUp/oXdcx8ebP7M963JO2FBPTPK8U4ZLjfO3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2Yx6Zp1d8rNb+yR5uRT7mNhSqKn4+/1/mTAQB0Ty3o=;
 b=CFGMbv7X9D7Bvs/lwOw1ao9zOU+LXJnkC1jSKdfqG6Z1bbkGfKvcoIx76xKsLwfhfzO+DNDi/+kg3qyyWl1tow7jraA6+RslHuyiBfQG0F6MwfVqujlePF9oSzEaFzel7U+mdaFIuLm+kXVDoLUUShdmq9mh5mKFGlxdkNdP9XzPbuZE8bXRjxrLoTsye2IF75BYrCGCLSmyQsfe7iUKDsLa4I8h5yrlrRr5/lWZRG/uDr3kT8r5CMgMuNNtXwiK0qe49LJkiaIRUiVcJFoh0dSwIcHTi/LpG7UWB3KuhAzlwFU9pG/XyyNOB0m3Ub7mCcOCVOPlm/c9/gFSa2VRKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33; Thu, 16 Mar
 2023 21:27:20 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 21:27:19 +0000
Message-ID: <46b782ae-9d71-1b49-f684-885f241058e4@intel.com>
Date:   Thu, 16 Mar 2023 14:27:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] docs: networking: document NAPI
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <jesse.brandeburg@intel.com>, <corbet@lwn.net>,
        <linux-doc@vger.kernel.org>
References: <20230315223044.471002-1-kuba@kernel.org>
 <e7640f5c-654c-d195-23de-f0ca476242f1@intel.com>
 <20230315161706.2b4b83a9@kernel.org> <20230315161941.477c50ef@kernel.org>
 <71ee8b08-b1d4-cc42-62c6-4104849a8cf6@intel.com>
Content-Language: en-US
In-Reply-To: <71ee8b08-b1d4-cc42-62c6-4104849a8cf6@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::25) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CH0PR11MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: 823f2877-6722-4a63-9af5-08db266538f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G4M+gerT+aAPeNiGlGipZ3jPZfKxDUU+7FQ1bNr9+h96dyyCc6MFessPoPzzdmimx29m3Jo6B0rwPSUSepeZwLMo8wqJAXffn3682UwGQnZQB0VU5K8fIpjtonO1RUgTMri5CBXDE1OC68tzd2dNrCXhtn2TTgIuOfMebkch2tCw0+myLFopIbWuI40fqqCp3E6UOErA5kYfc6bExaOkeFHMndhZpNql44iIPTsTK/08uftGwbFcDVFuGJlz+MNaOC2ubarggf1Aos2+LJXcrvuLrMWaxtwMKRqtKnxS0UASIa/HiZnpNtEj4eE82jzNFuxZMiL6zfsBZs9QOdrHDguZaDnPVleFuicLys8SbOkpPY3/wFy+BhIwvEnxSVPuNt6cjxmjS/CxGF27RoHSRdjblYrEQpGxEhDx38igHDxsD7TZ9eidjuVy/XMDd+qrVPgxuOOnoMsyjsatRvnEbbR35Xux3a3wDmD6xTEfAP5PPQr1VUZJv5kTaptqCaRAYY+ltid6uK+a537xCi9GXZowpqlUh3TMN1a07IVD472MoBmTrREECb/aGgZBVB8Qa1PC71OmRfvPtEhzL667C1AMYn+uwFHQSrT+M3aUntyFjA5fS6xJ6m+qqONshenK2KNKaEAKppUjnuUT+71+LtPvpVBFzCqhK8zZTWI06/6kX/nIV9fWf++vmI/9l7vcaiXf4PKngcnTNnK1C1z9bSgk2k2b3uJ8x81KPL2Xchk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199018)(2616005)(478600001)(316002)(6512007)(6666004)(6506007)(6916009)(4326008)(53546011)(31686004)(186003)(6486002)(26005)(66556008)(66476007)(66946007)(8676002)(41300700001)(83380400001)(8936002)(5660300002)(4744005)(2906002)(82960400001)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUlhNzFjOWtkWW9CVFFha3JGdXhHaHZCeW01Yk9PNHRZQldFT0FUYk9WR1M2?=
 =?utf-8?B?SFZIbjNkVUV2SFRVT0ZkSGVFMHZCcW5IT0s0THAzNUtTRTUxNVBaR29teFdk?=
 =?utf-8?B?SnFRVk8rOXpmMU5OVEc2ZVpFVmxnM3REQnZjaWVGUEoyWENjcFY2SDNhVWJJ?=
 =?utf-8?B?SXZOVWw1Q3lXNUFYUXZzZ1NqQm12UFFZNmhCdzlRdmFqamM3cnQ2S3Jid1Vi?=
 =?utf-8?B?Z3E4NEU1YUtzTm12NDM0Y0M3OXpSV212ZUtYK3RYNURWNHpFbjB3VHowTllX?=
 =?utf-8?B?cTRUaXd6VTlPMGUwcDBQTTBSbFZ5bEJMeUVrYlNrT25tR0xHOUpWc1VkVm1a?=
 =?utf-8?B?WWF4eXdlTG9WNFhmYURhSFo1VUFkK1R4c2lDV3RORVFyaXpCNnhNbjI5Q1N6?=
 =?utf-8?B?VUJ5VklZVGtqcTF2cWhaN0pGcnd6TnBxN25Eb0xKOTJHQ2U3N2RlanNOVGw4?=
 =?utf-8?B?WU5vUGVoclc3cXFUNWNqdGhSRzlUbzBtaXpaVDZKbTg1RExGRnNyY3VrSjFK?=
 =?utf-8?B?VWNRWGJ4UE1UeGFRdTNobzRMRGpBT2Z6c3JScGg5ZERpMUpiYlB5b0J1Rmp5?=
 =?utf-8?B?cUtubExnZ3Ftb3Y3cGpzR1kyLzhDM0taOE1Ra3pIZGlRT3JWR1Z0YS9SVWZB?=
 =?utf-8?B?elg0Q0M3N3kwNUlGKzlnVktSNEpZTy9PZ3RrS3lPNHRGQkk2UVhyaWtSQVQ5?=
 =?utf-8?B?Y3ppdTZaRll2SFBpSWdXYTJDdVU4WUdGYnJ6Z01BM1Z2Ymp4T3p3Wk9FeDdE?=
 =?utf-8?B?QkVHU3ZqL2pTREM0STl2OWlxQllTTHRjTGdSVHNRVFByVVZxTEdGcmJvSTAx?=
 =?utf-8?B?UWIzd0NRT2NxNlpvbUNHSUUxM2l5UERnQndhZUtZRGVJZUc1SmN1T3hCWVA2?=
 =?utf-8?B?blptNVp5TnFVWTFTYTgxTUlqa0RUb3VlWGxjcmdFUFNJWTdWRzgraFl2dXBK?=
 =?utf-8?B?eFV6RXF1djhEaFE3RHVVRmtESVhUQ2daWi9lMTNDTlgyR281bVc2RWlCYlYy?=
 =?utf-8?B?cnRBd0RjWnJxaE5LWFBqNStYRlFNa2JOTXE3dWx1c3FJWkwvUDhQV3N3ZGU0?=
 =?utf-8?B?bEg4ZDJzeHhBRXdmbnJ2c0ExV0RzcWlSQjkybHk4QVBSVkVKTnRMVFlUYnpx?=
 =?utf-8?B?SHZkcjkvMGs0eSthTjlKQW1VK2pKWGxTZjVXQTJ6R0c1YUxRczFacC9ITWw2?=
 =?utf-8?B?OE1SVHJuVCtiV1g3TGpRRGZ2dkRjTDJSY2pBNmwxS3ByWGlzZTg1RVVuMmxN?=
 =?utf-8?B?ZHViajB1OUZwY2VYa3M1c29jd0t4QnJjUnlhT2I5SklkNlpORC9qVlo0T3RX?=
 =?utf-8?B?cEhGaUx3czFjbGZXeWxtSzdZT2toOFh3Q3lLenNBcXp6UmRXL2U3SkFtU2Zy?=
 =?utf-8?B?ZVZmSncxN3F0cGFvNVJ5SFhQOXRmRkJKRTlWRnEwYjZib0Z0S2pCbkM5THRL?=
 =?utf-8?B?RTFJTzJ0NFhudXVNRFlPbUkwWHcveGIzcGs1RlN1RjlQSEEzZEQ5Y0NCMzZ4?=
 =?utf-8?B?VzNHS25UaFJhYjlDNnJGeUNJK0picFJUUUZ6UzVDc015c2Z2akdVQXdkWlBJ?=
 =?utf-8?B?dC9ycHlGZTNNTGk2YnhsWjNWMExtTHU3Q2E5bWdTRERwNGRTVERjVTlDMEFQ?=
 =?utf-8?B?akdGVHV5enBjcExlSlpNZDRFcW5MS213ekFLZTJTd0FTNHlzaHA5azZsZ2hL?=
 =?utf-8?B?aklyMkxqWTdaMm5Ca2xBR0hUcVJQVHFyUGdJUVlWdUlQZUVqd1VHWSs0eU92?=
 =?utf-8?B?OFhZdjI1aWMvVVJVWktrWis4dGxiaXo5b0NZOEJUVGtuMFJvSWI4SHltbCtF?=
 =?utf-8?B?ekd2MG52WG1lWENuc25XS0tKTC9KQVZhVzdnNTNWSGVmNm9YRW94VzhBMk45?=
 =?utf-8?B?d0xsaEdoUDE5MkpVREhwNnVWdTM2bUFoQ24xcXBJa0RMOXRDWExJaVg0bkJq?=
 =?utf-8?B?MHZqQ05rcnBtcGRwd0JHQjFGRi9zUDBqekJIR0VEZDVxU1JUYUhsQWVYNTV5?=
 =?utf-8?B?clo1QXNMM2Nwc0w3L241dHJDYkNqYkxSSVVIWUdmY2JSWHBhQ3hRRWM0MWI1?=
 =?utf-8?B?VXp6K1prRzh6ajZQUzFtdGlEeHpEajdWQ0thaDlrMlRSdmhkV1VRcDVhR0Zs?=
 =?utf-8?B?R3VTS05haVlzODdwSU1lZmpPMkdJK3hnQWZVOHBTcXdzYVdIMzZjUzRTRzhK?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 823f2877-6722-4a63-9af5-08db266538f1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 21:27:19.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ODw+2jNibWecS6SSwTjkKRBdYEP0faoVNyAQ1V+aIXvwE16dVelqUDdVuCINeYK2nZydk3I/TDyYo4zPvGGU3He6b4fjRNBgTg+EpuuacM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
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

On 3/15/2023 5:20 PM, Tony Nguyen wrote:
> On 3/15/2023 4:19 PM, Jakub Kicinski wrote:
>> On Wed, 15 Mar 2023 16:17:06 -0700 Jakub Kicinski wrote:
>>> On Wed, 15 Mar 2023 16:12:42 -0700 Tony Nguyen wrote:
>>>>>    .../device_drivers/ethernet/intel/e100.rst    |   3 +-
>>>>>    .../device_drivers/ethernet/intel/i40e.rst    |   4 +-
>>>>>    .../device_drivers/ethernet/intel/ixgb.rst    |   4 +-
>>>>
>>>> ice has an entry as well; we recently updated the (more?) ancient link
>>>> to the ancient one :P
>>>
>>> Sweet Baby J. I'll fix that in v2, and there seems to be another
>>> link in CAN.. should have grepped harder :)
>>
>> BTW are there any ixgb parts still in use. The driver doesn't seem
>> like much of a burden, but IIRC it was a bit of an oddball design
>> so maybe we can axe it?
> 
> Let me ask around.

It seems like we're ok to remove it; I'll work up a patch for it.

Thanks,
Tony
