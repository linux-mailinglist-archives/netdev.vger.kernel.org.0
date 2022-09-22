Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C72B5E640C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiIVNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 09:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231837AbiIVNqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 09:46:35 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68D55EA596
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 06:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663854367; x=1695390367;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S0bw60vxchoP6Im7XqEI2C0sDgObdBEClxIQAwCXg2g=;
  b=cFhHF3R0CcWlAK64NPpiPN3tNTIggunRCVE2EZLCg4oPeLVzFLOjY9Wc
   OdvOF9+acOMi9OrtRtG+/KJbeSM3RumHRN5YMsqUwaGxj0qJ1NeQDuFTW
   EkxxHoWDOkZpVopMByehPN8ovM36TyjX8UqZLFQwfoAilJD7wsMcpO66f
   EVcGCn8N+J8rIGQoFpBn9lMAsqUKl511H/kqJFG2/A/RWafobPmZA+wiE
   lpctvUifmD1T5WyGSEhj05u/7pHLOKSRIq0YzIiB2O5An3LfJKIF3VQj3
   4jqEt6+hFYmh9o1vqXWuh3Dz3OR6Qhw7gKP+qLDETAOfQ/3iFBpSWOTzc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="300282320"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="300282320"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 06:46:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="795095686"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 22 Sep 2022 06:46:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 06:46:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 06:46:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 06:46:04 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 06:46:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JGNS7cCkTR6SFc+Yy+kGg/NxV/H4vqD0ME2805ha/uOX+MHXOIbNdymyTKIe/NeyX9IOuTNnbq7aVbcOxxfPY/kxal1l0zVQBuPJX9h2bSb7ig7mo7nZ7MYJZD27egNkgzFOHH/WRbu8JuL+sS9RqCm2HHjjI9Acf4d6pUmC2gVFL/Qkn6p8ugdFO8jBkv7gn9r8sh3cDbzR5uktbEsnmjB7aAaUMj+D6OVKkvYtrGrc7wo0KqzaeNym02ZcEuUJ0PDOom2UQYd2pMk+MKf+EgPlPbvMGBn1KTg20dxJUPdbCwuGzAC0PTznnlKH9bGXWdsPWovfgamorvD2C1J5tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jYKwPOK53+RtYNr05c8Pmfjk1G4cDBCM7fQMaCTofg=;
 b=LCw1fIjqQRw4xBw2eF6Vuu781EEHGrkVrIjG35l9XxqSueEeccLTbPUtui4OtbjdZJlsmzVysZd1uXSOmIlKGaW/gWi/yWFBrtTFjXs0SetRWaop5RHIIglUPi2LYcl7T+hslHGJWwj0t0T/E/T62jxSCSMmDkLJrUoBZwOmBUOxobRqNPDT+TkYoscvp80iHPHdQZ9IJi9W2U2FpCaoRfblh85E2xZyBQqLIW1d50+IAJPozEFd9K9OOtBldQkrgyqRDYPyozlI+IasZ/+zzbb/JGchwL9bXqDnuRYGGwCgXRUyTqKHWImzqWlWrVsJHy+20ILsMXVXWKfV7BTfYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.19; Thu, 22 Sep
 2022 13:46:02 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%4]) with mapi id 15.20.5654.018; Thu, 22 Sep 2022
 13:46:02 +0000
Message-ID: <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
Date:   Thu, 22 Sep 2022 15:45:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH net-next v4 2/6] devlink: Extend devlink-rate api with
 queues and new parameters
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <alexandr.lobakin@intel.com>, <dchumak@nvidia.com>,
        <maximmi@nvidia.com>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>, <jacob.e.keller@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>
References: <20220915134239.1935604-1-michal.wilczynski@intel.com>
 <20220915134239.1935604-3-michal.wilczynski@intel.com>
 <f17166c7-312d-ac13-989e-b064cddcb49e@gmail.com>
 <401d70a9-5f6d-ed46-117b-de0b82a5f52c@intel.com>
 <20220921163354.47ca3c64@kernel.org>
 <477ea14d-118a-759f-e847-3ba93ae96ea8@intel.com>
 <20220922055040.7c869e9c@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220922055040.7c869e9c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::12) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|DM4PR11MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fce3ac0-6693-4f81-7480-08da9ca0c9c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YmRXOl4MYizc5bFlGdQduBk2xESQ3Wuf/ENoGofTkI9alnHil7CNoQj4yX8pK/LF21sl4wumw6e7XQ/tmz8rQDBfAvtVhMcuftX3ysrT2GH7bLfTN7L4a2T6GzxgImWVIt0iUWkhLf9WuczeUfRL2atXRe2Gfc6aJsuG8vlDs/ubDssfOFI9d7t+i4a0AevTV+yBda179kFZ8TT5QGZM28ezwkL4R1Tcr3lljIouEunjLQSu9NxLtYOJVuhb/hycwxAE4oVjiDE75npvDTQi8rXLI5HRINJNKh8Xt3o1UOT9ty1Iz4hVZEUemXntsOsvdIlhLCEb4iIXrznvHZ8Koj3+a+FSjiBi2tffQ4DxACpxaFvZrvG99pbgBR36F14noSPjCuEYWMhSKJ3XHAG0OrxaRWetmqdqsE7HuR0el2p2KkXXpHnk7Y0y3eTHeYBKfT/cno/9lTLOB9g4jA4DFzDDodYXjfX+deTatZt2K6ovUvlygX5iTt+4YlTMQ2e+0eEyIvHwDVmgF65Uo1rZ8+c0rbpun27iB0BNOnb9iPFBq+UwlvpRa600C38DK+JKhumRIwPe0AkEcGOwlCaDNtqva6dnKOkZ92nMAn14r7G3h9ER23uAy223hWR+WOeKDSQi2/guYIhsReN3d+zRfA3/v1kkOH0a5Jdg9EDFM1Wm8CL/42V/8uY6QI+hf5JRYeMLswu88DSDpCJIodknwfy2ZIy5wvM/7rQhcp5GOd7mU8swuANWcQvm52q7hBfozrYzdEzDlH1aJ/2dOjsDpQ/luBT8RhWuiD6glWfrYubB61TliINXHOzC0HxcLlcA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(38100700002)(26005)(31686004)(6512007)(82960400001)(107886003)(6506007)(6666004)(36756003)(4326008)(8676002)(966005)(478600001)(66556008)(2906002)(2616005)(53546011)(41300700001)(186003)(5660300002)(86362001)(8936002)(66476007)(66946007)(83380400001)(31696002)(6916009)(316002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M25NZE5WV1BkdjRwUk9XOWxvWVVaS1ZsbmI3Tk1uUWQxcmh2L3JPUnVhYlE2?=
 =?utf-8?B?ZUdQOTRoY3VmazVrVW1ybjZaVDhqcnZKc0lTdml4Y2hIWnlCN3ZNYlFmZEg5?=
 =?utf-8?B?WFdjT3JiSFp3T084RGVCOWRYdEJzYWxoQTE1Uk1vS0QzMkJYV3hjdVlCQk03?=
 =?utf-8?B?TFVIeGo3MnUycTFFT2NSb1pzK016UkI4VVhWMzMvSjE4cXk0RzZEK1VNWUJx?=
 =?utf-8?B?eWlPcGMrK3hVdTN0TW5vMjJTdmhjZEFZaVNraWNKWVNRZEVVZ2V0VnJpQ0dC?=
 =?utf-8?B?ZlZCalVrb0pxQmtGODNnWUNEdVJKbC9yV3J0bm8vSVFFdmxGWXRRL3oySDZJ?=
 =?utf-8?B?dWwrZWpJOWw5aEtpVWorUmQ2OXNrWjAyRTY4RjFIWERxT0I3bU8zK2FybUh5?=
 =?utf-8?B?WGx5NGg3czkyam91NEZxVDBpbXJibDZWVC9pTEVQeUUzc3JHNVdFTS9HeUt1?=
 =?utf-8?B?UHFBSElnTkU3RlpHaVNaVW5jclhRTFBlRng3UTJCdWlDcUducU5VY2kxWHB0?=
 =?utf-8?B?NlIwTmdUNys2QmpiNDM0dW15NkR0dUVSZ2dqa1RrVDdlMEVsZWNCczNHRmF4?=
 =?utf-8?B?bWxYNXRubEowL3NMd2QwRzRTemVpc3FPWEdnaHE2OFFyb3MwV21GdndhaSsr?=
 =?utf-8?B?M0FXcWVmTjlsSXE0K011cENSZ2VnUFpOcWZCWkJoQUlDUy8xcU1GaDBzQmti?=
 =?utf-8?B?WENXN2JWb3hoak9Qb3V3aG1vemFwTy9SQ3Vpclg0Y2pTbFJrcDNTNnQwdWVW?=
 =?utf-8?B?eUNpdHFHN1QxSy9BdSthTlNGOE01V203TGFLN2gvNnl1eEpvblpUcW41Q2ZQ?=
 =?utf-8?B?YzZIRVNlNjh0M1JseHV2VklnQXdCZWJNcmVVZEhzcmZPT3BDZEVCeTIxdHc1?=
 =?utf-8?B?aHhJNnJocmM2UldNWWNNNG04Q1k3NE9rVEU3Rm5jWVBqellxT0VGZFQva2xh?=
 =?utf-8?B?ZDJwbklTV0tOalU0ZnlZSzdQTzJSM2UyOU0vQTRnQWlLMUU2dlJWZ3RLVVpM?=
 =?utf-8?B?amZaMitWRytUTWtOQ0ZWZldQYjJyMXlXZDFuQ3JZa0R0azhyZlFpRkc5NHF4?=
 =?utf-8?B?VERzam9maW9VQ3ZEaUYyN0RFLzk3bUFveklTWmJ1blNZbzZ0UTNRT0RRS1RY?=
 =?utf-8?B?RE1PZkJtdzNUdmM2NWdMSnR5SmZpWVE1RzloUjVGMWNwYWJWelRnZjlJOHU1?=
 =?utf-8?B?bzNtdWFvZjRVZnBjWDNybytPSFRnK1dKVWMyNEVPWlJ2cTgzUFFkMG83M0hV?=
 =?utf-8?B?cXBMQjduNXA0Q3VYbVZvRVRPK0lqeWRmYktFWGQrb1RzRXYzdjBPWUhXeEtQ?=
 =?utf-8?B?aFpSUC9Rb2ovVDkwTU9Bbk1VRm9ocGhrYk1SN3YwZkwvSEs2TUdYTHR1aE5M?=
 =?utf-8?B?bG5ibUtZdnVZOEgreWpIYTlTNXJHV000VUZJZjZyRmlXZDhpdE9VMHFrNmFS?=
 =?utf-8?B?ZG00UHRPbzhBZ3E1ZDJiRi9neng0dENzRHdjSmFqeHRWNXM5ckgxUjZaekhK?=
 =?utf-8?B?ckFFNk5rZFhlR0Y5aW5wQXBSLzRsN1dGRk9MWHJnWE9iaVE3Um0rVDYvNjhP?=
 =?utf-8?B?M1VmRVRLbmZVS0FLZ0wybTc5VmlBSXJxc1gwQ3N4SFFyTGQ2VzNjTUQwMXA2?=
 =?utf-8?B?Q0Fnd3JLY3prQ01hemM0QVp3RHZySkpiRE9Hb2Zqa0FWVUlMWmY4YjZ2bDJu?=
 =?utf-8?B?S2Npdm11OHZBVUEwY2I4YkR1aGJqaitYWWtHR0xVU0ZFcTA3VUVEWVBNZjFz?=
 =?utf-8?B?RWY3a3U4Mnd4R05jNHJQbkZ5TWJkZHVMLzY5bG1VSmRMcmNORmhPcHpyb0JX?=
 =?utf-8?B?M2pnM0h5ckVocU5vUlI5RVdGWUUrVlhSMEUwVWh2aWthNUNaRytiN09BT1hS?=
 =?utf-8?B?TmpLVWlzN044ZGdybUdqYi9wY1prOThXaDJuZVlKOCtlckRMLzk5RFZHM1BS?=
 =?utf-8?B?MDIvZXpKbmFjTmcxUFB1a3RNWHFJWTBHY2xiQlREQlZ2eW9QVzRtNGRDNjUz?=
 =?utf-8?B?d1hKUnFyL0VNR1VXalBjRXpwK2IrQWZSODdNMWhRYVJrOE1sZyt5VFpYN2lx?=
 =?utf-8?B?N0tJTGNtVDlRNHNvd1B0SGk3dk54RTQwY0hkNVQ2Q3NSZEIxNkFIWEpYY3Fh?=
 =?utf-8?B?Sjk0bFNoNEV3VFlpbkpXMEJWTGFzRTllUExYcmhnYmVqZ3JzNEZLYmNMSk0y?=
 =?utf-8?B?bUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fce3ac0-6693-4f81-7480-08da9ca0c9c5
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 13:46:02.3019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EIRvPBAN/M/Q3IICN45QNLJQLWBllsIe6EoUHzV9A89gjLoJ0Jv8gZKlB1jOhPGg8/au8d6g6jqIcP6N+6HDwVSz/Bc1ChjwtVRe7XrxaoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2022 2:50 PM, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 13:44:14 +0200 Wilczynski, Michal wrote:
>> Below I'll paste the output of how initially the topology looks like for our
>> hardware.
>> If the devlink_port objects are present (as in switchdev mode), there
>> should also be vport nodes represented. It is NOT a requirement for
>> a queue to have a vport as it's ancestor.
> Thanks! How did you know that my preferred method of reading
> hierarchies is looking at a linear output!? 😕

Haha :D, sorry about that, that's the real output from the devlink tool 
that I
modified, so it's already like that for devlink-rate. At least I don't 
know about
any way to represent this better, besides drawing the hierarchy by hand. And
it's quite big of a hierarchy.

>
> Anyway. My gut feeling is that this is cutting a corner. Seems
> most natural for the VF/PF level to be controlled by the admin
> and the queue level by whoever owns the queue. The hypervisor
> driver/FW should reconcile the two and compile the full hierarchy.

We tried already tc-htb, and it doesn't work for a couple of reasons, 
even in this potential
hybrid with devlink-rate. One of the problems with tc-htb offload is 
that it forces you to allocate a new
queue, it doesn't allow for reassigning an existing queue to another 
scheduling node. This
is our main use case.

Here's a discussion about tc-htb: 
https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/

So either I would have to invent a new offload type (?) for tc, or 
completely rewrite and
probably break tc-htb that mellanox implemented.
Also in our use case it's possible to create completely new branches 
from the root and
reassigning queues there. This wouldn't be possible with the method 
you're proposing.

So existing interface doesn't allow us to do what is required.

BR,
Michał


