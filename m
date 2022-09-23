Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667295E7A74
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiIWMWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiIWMUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:20:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E3614018E
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663935081; x=1695471081;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:mime-version;
  bh=axY2sv99ppHgNTiQZBxcSXWUanqIr1JU+BN0SloSwjU=;
  b=YGaaMyLaB184r26wC7BjxynVlTE1bxTtNqhh21nsg50zj1wVmQjtMgfA
   tuLEmKSQ+3UHSHNnhKpN4C6ZcBx/o/IsmIHrnLm6jlVhbE3zJUunG5nlo
   qRV9RmH2y2xeOj/MPVux1LgESHGH6JgVWAIL7D30EgVxMafHa9pOIkHRB
   UVeuYSvy3pmysWajNvw6HCHY/NqayPi8bTwIfO5SUXaNKnga5pc3SDZcX
   emn79UEOzuhxRYIikCia9ef7T5ZdnE/vQiGtyVxnrCwavP1Z7RLOK6ZOX
   jhGYp9PELX2s7a/da8M49VvHxV3zxfIET0dj5aLAR/30vGa5H5KUzG7dG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="299297757"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="txt'?scan'208";a="299297757"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 05:11:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="txt'?scan'208";a="571355925"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 23 Sep 2022 05:11:18 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 05:11:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 23 Sep 2022 05:11:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 23 Sep 2022 05:11:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TI21zjg7tSuMOdhEEoku1LDURrf1i77u5sgCgc6fXC+fECFQCZpTqPCSqzX/3mijFCJu1OH+Z7zgehUyxYgEYT04dlo1JxkaOAukBCI4WaCIgk23c497KvTeaDv1G3Iv6mZhVKy+bWvUL6uS8s3oSm/A812wRYvDdhgQYHHasetg4VPighTZUWUbJ6FaCjH02k4fbUSYuW5SM5bSLcEz5/eryiplW2+BXL2dVY3AEv3JEsny0KMK+5rrAzeQTMYOdrJ53I+ZjJ/gK4Lmf6ffD9gcL3hV+Bpfu3JU9Ij6FcHE7gUBAvH2nASoRzH/4ENDWh0440ToCYXq2AFTIRkM+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5gu9AT+OfFJE50l8v8aiWAE4bZiPtmHQ4VhGOLevVU=;
 b=c6PkYceXqdnNHNbsxmfkselLt+wmdx4hpG642DHKRQ1YXwHgcJ2HnmyuhazpHWevAlCkE4gNAqkDYgXI6h8SQV1Jt930t2MrblYpDQ9xgDwDc6+uNkWvyWI8qlRRJUcP9MWZ3XAcZx6FmgSx/DCcDU1UtZ+RwbPILG3qxrhbTJlVuXJcoPB/sChlhyjWvBLNrXosW829GcHsBQH3CyI75zKeerKDF2ZektBq1lCEjgdW5Mf6rvpY4b3iX4ZWyLurPircQl5Oq18JbGqr05GvS9aLEvxOI5c5EHG5C8LR/TuNgO+Er3Z5bUSDvSOviamS5NAGBP8sYWMhYqi4dxxhsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by PH0PR11MB5013.namprd11.prod.outlook.com (2603:10b6:510:30::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 12:11:15 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%4]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 12:11:15 +0000
Content-Type: multipart/mixed;
        boundary="------------kEfqMP0JS8VKwLmNE54tuGT5"
Message-ID: <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
Date:   Fri, 23 Sep 2022 14:11:08 +0200
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
 <9656fcda-0d63-06dc-0803-bc5f90ee44fd@intel.com>
 <20220922132945.7b449d9b@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220922132945.7b449d9b@kernel.org>
X-ClientProxiedBy: FR3P281CA0155.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::16) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|PH0PR11MB5013:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d00a553-1a34-4c78-fcc5-08da9d5cb649
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 34PsjyrQm4XP0Djkb0ygHo8FbXnpBnp2Pe1w2LGJPRlifswsLxkGeOAyC0B9zTjIFzexaqBZH9wYoCJB3m//rBUMXVZvYzHbpJzs+VfUauSCJTBPLgV0xbs/SBcTf9g4cbGquQ+ITp3r67V0PK6NJgAycH4u0NTrI3HLu0sBzA90riS3oZsWQ6vw4zxSoSi7FKaS4Ks4CFX0H5lAA2Fw2hM6ndtw1mZ53/hN3zPmpcC6ipJmuq8k3+PMiPYFpcBd2QFAfMEFwvkYWb8Bw8Pi7glbE/i/eOiw7buM8Opsn63BtWSnOK/5Pdd7YH0vXCF03EkAYD70Nl5AwjUMgAXzSlmTjYTjKDaluz+ZJ1y96GXi032ETAtYwRTmeA7YXTM40YgBY6EGt0mRyIPTcIMmQsqpQKlaFPYk5iAtUdK1Rc2ZhtRWY/J2RICQl7YTKRPLvpfuqq9SVM5c0PJSYpGK7mkQt2M5VUrM6EkVrEWn6Ma0dwjEEbGergLj1mXmFOfP/vhI2mGHq7O/rNibiorepMDxElZ/PYcu019Lwv2rovzzYS83aHoLieFnSjV8xiuTn3v6X91hTqtp/FzS5gg1q0q1IxcCx0MoUfxqryyZnc3/9f9adD+0rl9/vgmeCsjwMy0DPvcWvDQzR6767uF01UESOfZfJF4+QUa2QrvOec0Bok0LHpXzhlnsJRn1CUNRg7mB+MpJcYwzFdgEy0iGdXVncqKJFphzO66qf6U1pjuDfjyDKko3Jd3Fi3NjiTS9O3361yjDmpGMpdAEXS83Wd3DaIFoE13RRCmMQdcf9o33Ys9bRVrkVKleofUa8uHoSAFITzKpUCygFUiW2/Q9GA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(396003)(376002)(346002)(366004)(451199015)(6916009)(41300700001)(31686004)(83380400001)(21480400003)(235185007)(6506007)(33964004)(38100700002)(5660300002)(53546011)(316002)(186003)(82960400001)(2906002)(26005)(66946007)(6512007)(66556008)(2616005)(6486002)(66476007)(966005)(107886003)(6666004)(8676002)(4326008)(36756003)(8936002)(478600001)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0RkRXVudHNzNVd3bjFEdWUwMkF3NjJuaFBWZER2dksxWm92c0lHclRldkha?=
 =?utf-8?B?SnFTQnRXSlFpenBvdDlpd25adUVOYkxwTEVzNlRlWEZQbFdVMDRKcHJOdTM0?=
 =?utf-8?B?bVBaYURwVVB5VDdtQzkyV3VLKy8yRGhCQWtOU2pXTUp3WUJLVzJ0aTRMZGVS?=
 =?utf-8?B?UjZRTDhFMmp4b0grZVdmVlpxRmFTdmRXNXBLckpBd1cyS3l6TXNobElEVkZT?=
 =?utf-8?B?RUFxVFYvOWlHZXVlTmhiZ0RVTFV3UGt2MURRNzR6cHlaK2lGczhQbGVFQy8v?=
 =?utf-8?B?dnltOEgzT1lBbjdOaW5Ma2RMaWFtUVdybFB5dlljY3lVeHpWQWFzWm4zZGpW?=
 =?utf-8?B?Zm9TamxsQU9RU1EwaXJVaVQzd1VveTQyUVVYQVhkZnNZbmNBZXl6c0ZKYWtu?=
 =?utf-8?B?KzBiVlJ2ZkpWckRnWXE4L1d3UnJrUTg4Q1NUZE9NMHhxOXZQWUxmVG1ldDhY?=
 =?utf-8?B?ZkkrZnhrOXNxYmx2ZWxoSVl1bnZsOHY3STduWXdDVlhjbW5XenA3TzYrUXZm?=
 =?utf-8?B?ZG9OVUF4Y0RnZFM2UkpST1M5Y0JLTzRPTTF6SjRrakRJQUVoeFBKcmptVHlP?=
 =?utf-8?B?SW1UVisyR1FCYTZQajJMaWRDWkJ3OGsyTkxjUVA3eG9ZSGdVYmJIK2hETEhW?=
 =?utf-8?B?OHdaSTFqZTVmU2d4WkhsVEg3TzJCajY3TS8xZVkyMUJ6dTVqbnRqNnFyN3Z6?=
 =?utf-8?B?Ung5NUx6VDN0TVR3eUZtNnZHTTY0S0hhTnZhVW9CT200UmpoRG0wUlFTZmJm?=
 =?utf-8?B?WExuU0JXMlE1VmdQVUJuVnVpZ2Q5ckMxd0VydW5LSVZzaXFZQ3dkMjJVaWd5?=
 =?utf-8?B?UnFKWVVkcWpxT0hjamdmeEVMdHA2bnphNHkrU1dFU1cyemllVGNaSVp0ZnFZ?=
 =?utf-8?B?Y0xlS3ZHNWpCNUUxNVlya2pKWm5UV2hvazdYaldKWW1NTXhVeW9zbkNvS3lM?=
 =?utf-8?B?NTRlY1RuYjVDeE9McGZhY1Bia2RUVUFCUDJNcUczWmZIak9vTE4wS0RaYWtn?=
 =?utf-8?B?cGhzRHZZMm5NSk5mVDNweHNZN0tXUXA2c1ZsKzV0MHYwNGQ0Qk00dlpIT0hK?=
 =?utf-8?B?dytTem9RNEFlb0FzNFg4T21SU3pCQXkrc1dnN00xdHgvUitSQ2JtRVBhdmhm?=
 =?utf-8?B?RTVzei9XejdLOVZ6ckhoWnNmYnRQNHhRQUZaU1VwMVViTzMwejM2WnlPV3Nw?=
 =?utf-8?B?MzBvZERyRXE0MHNOdEFpYlZsdWxBbmEwbjRhVVUyeVZmY3dmRjZJQ3NUMTdK?=
 =?utf-8?B?YzJiR0syVEFHcFBtWVdjZFIxWGwzZ3gwOEw1RHhVRklMU0lKZHRLM3d4UXND?=
 =?utf-8?B?WVBzd0tUZC84VHphM1pNdisrU0M5U2duWGR6VXJwWVhwdTdrNERpc1FEYTZw?=
 =?utf-8?B?K2xkdG5haEUvdjhsRHJySDdIeTk4eCttTXF2SU15ZFc2L29IZFl3Tzd5dnhx?=
 =?utf-8?B?SGRHSjBFV1ZtdStja3pFcXFtOXd3cnFEQ0RmSmZ3NzR6MlhQK0Z4UURXNkNq?=
 =?utf-8?B?SkxuMVpHRHlOQ1BodEswQjNydGZmTXlwL3RYQmZpSXNHZkEvYWdyQjBQVXVP?=
 =?utf-8?B?c01tOXAvakNRdDNBZ0xEY3p0MTV6Vmw5aUZWU0l5ZmJYWittdFhuY3VaM25N?=
 =?utf-8?B?Nnp6dEpiK0FZSGpmZktqYVFkNmFqZjVVZHJkUk4rM2Q3eWJHL3lOK0x3TXlO?=
 =?utf-8?B?b0xSbXhvRkRmeU83cGhZU1NCNGVZMFJHdVBPQTBEVlVCdjBQNmlxcGVFakQv?=
 =?utf-8?B?dnlHNHEzT00zR1hUTjR1WDJ5NVpkRWllM1dEZlRBWHNoeHZ4RUV2RGhMdElK?=
 =?utf-8?B?QVE1d1I1T25NTXJkSVd4Rmh0L0tqOEwrRVpqMmd4ZHg3R2FJMGNKV3dSdE1m?=
 =?utf-8?B?bFdQRXIyTm9EZGg3OVNrR1M1cysyMy82b1NMM3AzbCticmVUVEw0cFZFc1JN?=
 =?utf-8?B?V0o4WWNsamJ3TjllaHNheE0rUFNaa3VDK0RkaEkrai9ZWmI5VXNnejB4MW1v?=
 =?utf-8?B?U1lSY2FyME1zZlE3SUlzcG9BZ2ZuTHBPT0hzai9qNzdXV09tQllTcU8vNFg1?=
 =?utf-8?B?eHFVME5ERW8zc01DM1V3QmZ0RWhhOW5qNFFuQ2dueFdpYnhnemprZmpvVjB1?=
 =?utf-8?B?cG53NjlzQTJqU2JJRitHNi9UL1hCNG5hR08zQzVPL281VXpUOUpGRU43dGg1?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d00a553-1a34-4c78-fcc5-08da9d5cb649
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 12:11:15.0168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XyvXwRPVLWAW5YuKYMjcmKL3t106PcXIUtHqXDJhMgpMyOk5MxufSUEcZPGQR36VFuiXFi8trH2JbkmFIDLMKcczLeIFTxHv/ZIN3a6nfYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5013
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

--------------kEfqMP0JS8VKwLmNE54tuGT5
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit



On 9/22/2022 10:29 PM, Jakub Kicinski wrote:
> On Thu, 22 Sep 2022 15:45:55 +0200 Wilczynski, Michal wrote:
>> On 9/22/2022 2:50 PM, Jakub Kicinski wrote:
>>> Anyway. My gut feeling is that this is cutting a corner. Seems
>>> most natural for the VF/PF level to be controlled by the admin
>>> and the queue level by whoever owns the queue. The hypervisor
>>> driver/FW should reconcile the two and compile the full hierarchy.

I'm not sure whether this is allowed on mailing list, but I'm attaching 
a text file
with an ASCII drawing representing a tree I've send previously as 
linear. Hope
you'll find this easier to read.

>> We tried already tc-htb, and it doesn't work for a couple of reasons,
>> even in this potential hybrid with devlink-rate. One of the problems
>> with tc-htb offload is that it forces you to allocate a new
>> queue, it doesn't allow for reassigning an existing queue to another
>> scheduling node. This is our main use case.
>>
>> Here's a discussion about tc-htb:
>> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/
> This is a problem only for "SR-IOV case" or also for just the PF?

The way tc-htb is coded it's NOT possible to reassign queues from one 
scheduling node to the
other, this is a generic problem with this implementation, regardless of 
SR-IOV or PF. So even if we
wanted to reassign queues only for PF's this wouldn't be possible.
I feel like an example would help. So let's say I do this:

tc qdisc replace dev ens785 root handle 1: htb offload
tc class add dev ens785 parent 1: classid 1:2 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:2 classid 1:3 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:2 classid 1:4 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:3 classid 1:5 htb rate 1000 ceil 2000
tc class add dev ens785 parent 1:4 classid 1:6 htb rate 1000 ceil 2000

                   1:    <-- root qdisc
                   |
                  1:2
                  / \
                 /   \
               1:3   1:4
                |     |
                |     |
               1:5   1:6
                |     |
               QID   QID   <---- here we'll have PFIFO qdiscs


At this point I would have two additional queues in the system, and the 
kernel would enqueue packets
to those new queues according to 'tc flower' configuration. So 
theoretically we should create a new queue
in a hardware and put it in a privileged position in the scheduling 
tree. And I would happily write it this
way, but this is NOT what our customer want. He doesn't want any extra 
queues in the system, he just
wants to make existing queues more privileged. And not just PF queues - 
he's mostly interested in VF queues.
I'm not sure how to state use case more clearly.


>
>> So either I would have to invent a new offload type (?) for tc, or
>> completely rewrite and
>> probably break tc-htb that mellanox implemented.
>> Also in our use case it's possible to create completely new branches
>> from the root and
>> reassigning queues there. This wouldn't be possible with the method
>> you're proposing.
>>
>> So existing interface doesn't allow us to do what is required.
> For some definition of "what is required" which was not really
> disclosed clearly. Or I'm to slow to grasp.

In most basic variant what we want is a way to make hardware queues more 
privileged, and modify
hierarchy of nodes/queues freely. We don't want to create new queues, as 
required by tc-htb
implementation. This is main reason why tc-htb and devlink-rate hybrid 
doesn't work for us.

BR,
Michał


--------------kEfqMP0JS8VKwLmNE54tuGT5
Content-Type: text/plain; charset="UTF-8"; name="tx_tree.txt"
Content-Disposition: attachment; filename="tx_tree.txt"
Content-Transfer-Encoding: base64

ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKy0t
LS0tLS0tKwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8IG5vZGVfMCB8CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICArLS0tLS0tLSstLS0tLSstLSstLS0tLS0tLS0tLS0tLS0tLS0tLSsKICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgfCAgICAgICAg
ICAgICAgICAgICAgICAgfAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgKy0tdi0tLSsgICAgICstLS12LS0tKyAgICAgICAgICAgICAgKy0tLS12LS0tKwogICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfG5vZGVfMXwgICAgIHxub2RlXzE1
fCAgICAgICAgICAgICAgfG5vZGVfMTg0fAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKy0tLS0tKy0tLS0tLSsgICAgICstLS0tLS0tKyAgICAgICAgICAgICAgKy0tLS0rLS0t
KwogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAg
IHwgICAgICAgICAgICAgICAgICAgICAgICAgICB8CiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICstLS12LS0rICAgICAgICAgICArLS0tdi0tLSsgICAgICAgICAgICAgICAgICArLS0t
LXYtLS0rCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHxub2RlXzJ8ICAgICstLS0t
LS0rbm9kZV8xNnwgICAgICAgICAgICAgICAgICB8bm9kZV8xODV8CiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICstLS0tLS0rICAgIHwgICAgICArLS0tKy0tLSsgICAgICAgICAgICAg
Ky0tLS0rLS0tLS0tLS0rLS0rCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHwgICAgICAgICAgfCAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8CiAg
ICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSsgICAgICAgICAgfCAg
ICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICB8CiAgICAgICAgICB8ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAgfCAgICAg
ICAgICAgICAgICB8CiAgICAgKy0tLS12LS0tKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICArLS0tdi0tKyAgICAgICAgICArLS0tdi0tLSsgICAgICAgICstLS12LS0tKwogICAg
IHxub2RlXzE5MHwgICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tK25vZGVfM3wg
ICAgICAgICAgfHZwb3J0XzF8ICAgICAgICB8dnBvcnRfMistLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0rCiAgICAgKy0rLS0tLS0tKyAgfCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICArLS0tKy0tKyAgICAgICAgICArLS0tKy0tLSsgICAgICAgICstLS0tLS0tKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwKICAgICAgIHwgICAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICstLS0tLS0tLSsgICAgICAgICAgICstLS0tdi0tLSsKICArLS0t
LXYtLS0rICArLS12LS0tKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICstLS12LS0rICAg
ICAgICAgICAgICArLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLT5ub2RlXzE5NCstLS0tLS0t
KyAgIHxub2RlXzE5OHwKICB8bm9kZV8xOTF8ICB8bm9kZV81fCAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHxub2RlXzR8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICstLS0tLS0tKysgICAgICAgfCAgICstLS0tLS0tLSsrCiAgKy0tKy0tLS0tKyAgKy0rLS0t
LSsgICAgKy0tLS0tLS0tLS0rLS0tLS0tLS0tKy0tLS0rLS0tLSstKy0tLS0tLS0tKy0tLS0tLS0t
LSstLS0tLS0tLS0tKy0tLS0tLS0tLS0rICAgICAgICAgIHwgICAgICAgIHwgICAgICAgICAgICAg
Ky0tLS0tLS0tLS0tLS0rCiAgICAgfCAgICAgICAgICB8ICAgICAgICAgfCAgICAgICAgICB8ICAg
ICAgICAgfCAgICAgICAgIHwgICAgICAgICAgfCAgICAgICAgIHwgICAgICAgICAgfCAgICAgICAg
ICB8ICAgICAgICAgIHwgICAgICAgIHwgICAgICAgICAgICAgfCAgICAgICAgICAgICB8CistLS0t
di0tLSsgICstLS12LS0tKyArLS0tdi0tKyAgICstLS12LS0rICArLS0tdi0tKyAgICstLXYtLS0r
ICArLS0tdi0tLSsgKy0tLXYtLS0rICArLS0tdi0tLSsgICstLS12LS0tKyAgKy0tLXYtLS0tKyAg
K3YtLS0tLS0tKyAgKy0tdi0tLS0tKyAgICstLS12LS0tLSsKfG5vZGVfMTkyfCAgfG5vZGVfMTR8
IHxub2RlXzZ8ICAgfG5vZGVfN3wgIHxub2RlXzh8ICAgfG5vZGVfOXwgIHxub2RlXzEwfCB8bm9k
ZV8xMXwgIHxub2RlXzEyfCAgfG5vZGVfMTN8ICB8bm9kZV8xOTV8ICB8bm9kZV8xOTZ8ICB8bm9k
ZV8xOTl8ICAgfG5vZGVfMjAwfAorLS0tLSstLS0rICArLS0tKy0tLSsgKy0tLSstLSsgICArLS0t
Ky0tKyAgKy0tLSstLSsgICArLS0rLS0tKyAgKy0tLSstLS0rICstLS0rLS0tKyAgKy0tLSstLS0r
ICArLS0tKy0tLSsgICstLS0rLS0tLSsgICstLS0tKy0tLSsgICstLS0tKy0tLSsgICArLS0tLSst
LS0rCiAgICAgfCAgICAgICAgICB8ICAgICAgICAgfCAgICAgICAgICB8ICAgICAgICAgfCAgICAg
ICAgIHwgICAgICAgICAgfCAgICAgICAgIHwgICAgICAgICAgfCAgICAgICAgICB8ICAgICAgICAg
IHwgICAgICAgICAgICB8ICAgICAgICAgICB8ICAgICAgICAgICAgfAogKy0tLXYtLSsgICArLS0t
di0tKyAgKy0tLXYtLSsgICArLS0tdi0tKyAgKy0tLXYtLSsgICArLS12LS0tKyAgKy0tLXYtLSsg
ICstLS12LS0rICAgICstLXYtLS0rICAgKy0tdi0tLSsgICArLS12LS0tKyAgICArLS0tdi0tKyAg
ICArLS0tdi0tKyAgICAgKy0tLXYtLSsKIHxRdWV1ZXN8ICAgfFF1ZXVlc3wgIHxRdWV1ZXN8ICAg
fFF1ZXVlc3wgIHxRdWV1ZXN8ICAgfFF1ZXVlc3wgIHxRdWV1ZXN8ICB8UXVldWVzfCAgICB8UXVl
dWVzfCAgIHxRdWV1ZXN8ICAgfFF1ZXVlc3wgICAgfFF1ZXVlc3wgICAgfFF1ZXVlc3wgICAgIHxR
dWV1ZXN8CiArLS0tLS0tKyAgICstLS0tLS0rICArLS0tLS0tKyAgICstLS0tLS0rICArLS0tLS0t
KyAgICstLS0tLS0rICArLS0tLS0tKyAgKy0tLS0tLSsgICAgKy0tLS0tLSsgICArLS0tLS0tKyAg
ICstLS0tLS0rICAgICstLS0tLS0rICAgICstLS0tLS0rICAgICArLS0tLS0tKwo=

--------------kEfqMP0JS8VKwLmNE54tuGT5--
