Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77E85E7EDC
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbiIWPrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiIWPqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBF288DE2
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 08:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663948005; x=1695484005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rKtro+68zjOH4wRbjMLqcbNpCmJs1HE3s/OjiIL16fs=;
  b=E4S7xz1iQTnD49S/opjypgKVhpp2vC7MkBzBwPCcChbxShN24gwVhuit
   wBuTIAbPkhsK/IoaH8FfA4U8FNmC0vc4IQeMEiv1m64WpW+QvIFyWsMwc
   HdkcS6T6g8GOFn3de5DfpV4wUPLZGXGhrWDYtLXdJvNodkyYc/5ylXmim
   vY0rVTswSKxXuOf5XqdGIzqpLDHN1Ggim+sUzv3635rBnGiU7tENioCXb
   xUQ/2Wyd0kHTbQiDZCt1tT/Qy5jPXGLjhifeL+RAozE5boK5x0KT/E1nP
   KGsTJ5T19bTTZio+lm3WxKMXGG4hAsv4bFjpMeiF4jpPhitqj6P35xubR
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10479"; a="280340836"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="280340836"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 08:46:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="571413932"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 23 Sep 2022 08:46:44 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 08:46:44 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 23 Sep 2022 08:46:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 23 Sep 2022 08:46:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 23 Sep 2022 08:46:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeVzwFoiVoD7sTadyf4Tn/HTt03mE3ddsbA8pQAMCujWvW2yTLYkNssguqdH3hizWORxrWCnQnU1jDWn/B1FR+J4Bel1aI2cTiu+44+ec1slhrP8+yryXeln9vwYuW9zg6ALZs9zYDaEWyiYg+0tPAPZA6EyrFK2J0RhajVzsGnutY0MeIeg9kTTaw9CR6ATvHoOZd03IrwB7Zo8wQVY7O3iKCxMFByJR8eDr2hGxaPoxurCO74omrb08V+m88GjVjRBKyl+JxdQ/5yGtd61AstWBd6h3Ru7ekD8lm+MiLBRYJBiP7cloMNqu/e1fxPlDzQljtUC2XQh7xCV+LR7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qIQxmlYqlTEtIRQGoFNut7Q17fVMRZ79uUSzKQ02vRo=;
 b=Ui9v+BLlProg6E4U/nAiWn267NKJKRDnWHs+x9lDAOXcYFtlRc8U7BTAV/2l3XaIHX/YwJ1iMPrvAPXR8uCj25eyRvxA6s7TzG/opHbDyRb5jljENQsWlcLBrd9uQCHRYW1mYzYPDfHgyESgQgQa/bmq78CuboxISHyLuW6EFaxIh4HH5a0itKWZg9Ka69zx2g6FKFO7yY4znU+68vT/X/EiLMS5yQp1UUFVBsKR3pFFKB+3u2wLP7cHsPtiEJmPUtA0+hPT2jUuabl0TRuqffi7GJGV7/eRhMwq+D6rC0EDEs1MqxNmUTB86u4feQxZKXJV84IBfYxJKccY7BMpEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 15:46:42 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::6c59:792:6379:8f9%4]) with mapi id 15.20.5654.020; Fri, 23 Sep 2022
 15:46:42 +0000
Message-ID: <7003673d-3267-60d0-9340-b08e73f481fd@intel.com>
Date:   Fri, 23 Sep 2022 17:46:35 +0200
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
 <732253d6-69a4-e7ab-99a2-f310c0f22b12@intel.com>
 <20220923061640.595db7ef@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20220923061640.595db7ef@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::7) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MW4PR11MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: de9f55b2-a802-4932-809e-08da9d7acfd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ioRaHKp6+BTn9+9BrfiUb6wgRDdg0Im/m4WH8Vi1IWPqFc+4IeIeesj8K2zSOHt8FuT3w1IFSBj38Ccv5+NfDTzYQ+nfS57xslW+uz+LhPMwPLoxR+EWdr/yYYVVPh+iBypBN52ydIyyDQj2q4wveDCt7b10y+XcM4/HO1/wtus2eLlh3C6aNqSUKvZvA64wBSS9O/lPfDl7uiOi45mAenJn2XIZqanc9N588ir4WcZZhoHNxRu57fOcXZIn5LkjINxEarWH0u02yjVyScoXzxeO9ff9+i8Ru6HWid9QUMphNplzssbH0H7dwnLil0L/9H3TQOQCA3tVF7M0RJh+m3U/7pUszIHJ1bNmtvdTbJAwc1e6aga1pQhsT1weAiKykqMluwjB1HjQ6rJ3AWBva4L1xV2BZjBgtrztzjZ7mlshyQa5j0IXHt0mFZd9Sa7utL2fOxrso+G2lbhMC00GZ0jIojWEpa1VQQ8H9iI1PWE/yGd6gLUtNvQQG9jLc1CbSEAe9pZTLnEwKx7+eVi2GF9KFc9xJYi8sq1YCnfRNiQpowE/BpPFTSo93PgHURuEXxuwwJ20l91fkMn46Chtzqj/l1a1IuT/We6fNQl157nnLKkVtEh86AUkn/BBHG6BuH+0m242AwmujtpqNDKbnlzGirkvVkqZcf4wmLLdpDyjcLk8uSLywMjkV8VnTHmJDrg39QbkAL9n+rPD+CbPccfDiZFbSG9ke9sFrjlYhkxLOx9FwPTFONmWb0aDDqpAFLdI6c9KED8wMEdMs61/eX5C1zwSC1lJdO91WeFcw5LJVX0uf7+JkTgKT1CldZU6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199015)(186003)(83380400001)(31696002)(86362001)(2616005)(38100700002)(82960400001)(8936002)(6506007)(66946007)(5660300002)(66556008)(4326008)(2906002)(66476007)(107886003)(26005)(41300700001)(6666004)(53546011)(6512007)(478600001)(6916009)(316002)(966005)(6486002)(31686004)(8676002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0ViUTdMT0srR0FWVkZ0UGRTU21BeWU0bnFubWpWTzJVUUx5NmFxU2wzVk1K?=
 =?utf-8?B?NDJBNVVFZFd0Q2JVY0d6bmRZbTMyK1ZDT2c5S0RkNzdKR1JkUlN5Ri9WQWEz?=
 =?utf-8?B?RFM2NVNXUmxaUk1kanRnY1h3aGtpMjV0YmNWZFRMQnhNcisvTndMSk9qN2Fh?=
 =?utf-8?B?S21qRFJrV2UrR0lwNWZnUTVFUjVEd3dhT3ZERWdFSFVyVFMyNUlvOGpRS2dB?=
 =?utf-8?B?QkxxT2lhSzhqVGFEcXNCcm1GNU1FTG1neXFianRlWVUrelQ2OE1UR01mSE5J?=
 =?utf-8?B?aE1EQ2ZYUENlMmdiVkN4NFNPcW0xMnE1ejRySmRUcHUwMGhuQzFsaXBsWndl?=
 =?utf-8?B?VUNHczNPYS9mTDNOOUo5QmFyeVRGRnVsQlRiRDJ1S1FQSldaUEo2QW44YmUv?=
 =?utf-8?B?NWpCbXVpQ3lHdngvU1N0VmxVQUZSWEw2WmhoWXhnNmxOS0hiUjRXYTVqT2tE?=
 =?utf-8?B?ZGJoZW9jZkFYbGhqSXduRWZ1a1liNjROdWxFWFErMVU0TElSemRHMkhST29I?=
 =?utf-8?B?UDAvZFUvcUlZdjZldmsrbG55QzJXMFdUSkZwYTJsR1c1SlhkanA2L3VZZUZW?=
 =?utf-8?B?V3RJdVMzbVNNMDkva0hSb0xPc2dSSWNYcW5YcVh0T0NrRjVrY1NOYmh5bjlZ?=
 =?utf-8?B?UTNMQU5xUUdOMFd2by95Sm54dHk3T0Uzazh5QThlRnlmUzdVY2RHNy9KT0JT?=
 =?utf-8?B?WFlCdHB6aWtPZEY3T0xsUGJmL3VKQkNheExsOVpQSyt2bDBBVUxJMmxoaVRM?=
 =?utf-8?B?QWZWeDkyNC8yY2RlSURhZnZrK0lrTE5JV0xHMlNGL1ZaM2hVNjlML21nZzR4?=
 =?utf-8?B?U2xRYWQycGpkN3hIVC9DdEVHTzZXRHl5QjR2Q3IrZS8yU2ljQUJlMmlwdHR0?=
 =?utf-8?B?cHJDVmFIZGV4L3BhSzNYT1B3cEFtQlJPL21lVFk2ZU1nOUNqRWttNlg2YWtn?=
 =?utf-8?B?NlZqZSswQSt2c2ZrV0JMci9OWmtvbmF6MXliS3UzN3pBUDhIdVB0WjZTR1Z1?=
 =?utf-8?B?SmY5dnFOcEhtQVo0TVVOVXI3MDBWYnh2a1RUcFcrMGU0OExiWmkvemEzckNL?=
 =?utf-8?B?U2hMOUlwRmNxVWExU0F2elM4N1JIM1RvZHhPck9FNjhNZVo0YnFXZHBieitz?=
 =?utf-8?B?MjI4bFZ6eERMWGhYNE5rdFZiVW1leXk5YTQvOXc0eEhmV0JQSUdqdGZyU2NH?=
 =?utf-8?B?cDhOZ09wOU0wdnRLSmlIUy9BaXZzdjNrVnRyYUdjY0JDTmlyMEU3dnZJN0V3?=
 =?utf-8?B?RS8vcE0xdVhTZ0NRcG9NRm9WT0xXSnVNejRyeGNKYTUxelhGemlXT1JGZnNU?=
 =?utf-8?B?OGcweTRaUDFHT0NteE1YWWJRWVJvekJQb3kwUUViZDV1UklWTndiRE1FTGxX?=
 =?utf-8?B?TzFBRHVmd080WlJQRVZ1d0RSTUVuN3dacDdqWGR5ZmxLbTB3dWcvaExpOFdS?=
 =?utf-8?B?TldvVWxtaGZ3ckUzd1RZMzZuU1NYQjN4Zys2bU9XRHV4Q21tRlpEbXBFWTVU?=
 =?utf-8?B?QW9OcVoyVXNMNG9FYklsMGJQOFlEbjUxcjEzdVdlMGZVdms4RndRUUNsMkNY?=
 =?utf-8?B?cDJoWG9nSHI4K2k5UWZyUlNIL1pKaW1rK2NrcWxTTE9CQU9Xbkk0cWQ2dU41?=
 =?utf-8?B?WHBRMlBnWGhraWw1ZE1pZ3F0R0xxM05PSm4rVkFxY0RpbFJQbTlCemtaVUdU?=
 =?utf-8?B?ckhPNFJBVU94S0wzSnpSa0pWdWhKamJJS0NaN1A1dWFnTEU0OENQQ1hUaUdL?=
 =?utf-8?B?eFMxYlRxcWZTb2JjR3dqRjl4eFNVZGRhNmVtSUtjV3M0ZGQ2ODRvellCZFlM?=
 =?utf-8?B?OW1CeVVLSHc3QWdqWWZFbnRHV0Z2UEd4VzhOT29PTkE2b1k5Y3VjMm9jQy8z?=
 =?utf-8?B?OGpvdEx6S25uRDUzOWlnQy94dFdOSUswUDBXeVdWZzRhRXVmUnI5QXNtRVdZ?=
 =?utf-8?B?WWlaay9XdzNBazZnQjc0RS9kMTB1N0VSc0FGT3VSeTNnQjdUdTVaRzUya3FT?=
 =?utf-8?B?bTdzWDZYSUhNQXFDcHpiL1VxdzFXNWMwTU1DcmRWRjVNV1dBOWl3b1BmUzBK?=
 =?utf-8?B?VlZwUVVpYmRRK3d0eElYVTlkMDE3SXJGY1g5RWgxejdVMzBlbVRFcGRYeTQ4?=
 =?utf-8?B?eXB1S1FTcWFlQmpXZlJqKzBUcnRNcHl2bUlLQW5EckRPWjM2aHBLRW9TRGcy?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de9f55b2-a802-4932-809e-08da9d7acfd6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:42.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YaT8NtoI+wiTM4QkHwmeH/LZrpnQNQyAe3cDSuHfroMKFi0yNYU5QehLqeks/oycH6iW091OC7/Yx3wHoIlPCfEkfVHNE78zagB43RdBZ+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5822
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/23/2022 3:16 PM, Jakub Kicinski wrote:
> On Fri, 23 Sep 2022 14:11:08 +0200 Wilczynski, Michal wrote:
>> On 9/22/2022 10:29 PM, Jakub Kicinski wrote:
>>> On Thu, 22 Sep 2022 15:45:55 +0200 Wilczynski, Michal wrote:
>>>> On 9/22/2022 2:50 PM, Jakub Kicinski wrote:
>> I'm not sure whether this is allowed on mailing list, but I'm attaching
>> a text file  with an ASCII drawing representing a tree I've send
>> previously as linear. Hope you'll find this easier to read.
> That helps, thanks! So what I was saying was anything under the vport
> layer should be configured by the policy local to the owner of the
> function.

My main concern is that there are no interfaces to do so. tc-htb in it's 
current state just doesn't
work for us, as I noted before their whole implementation is about 
creating new queues.
https://legacy.netdevconf.info/0x14/pub/papers/44/0x14-paper44-talk-paper.pdf

Also reconfiguration from the VM, would need to be handled by the VF 
driver i.e iavf.
So the solution would get much more complex I guess, since we would need 
to implement
communication between ice-iavf, through virtchnl I guess.


>
>>>> We tried already tc-htb, and it doesn't work for a couple of reasons,
>>>> even in this potential hybrid with devlink-rate. One of the problems
>>>> with tc-htb offload is that it forces you to allocate a new
>>>> queue, it doesn't allow for reassigning an existing queue to another
>>>> scheduling node. This is our main use case.
>>>>
>>>> Here's a discussion about tc-htb:
>>>> https://lore.kernel.org/netdev/20220704114513.2958937-1-michal.wilczynski@intel.com/
>>> This is a problem only for "SR-IOV case" or also for just the PF?
>> The way tc-htb is coded it's NOT possible to reassign queues from one
>> scheduling node to the other, this is a generic problem with this
>> implementation, regardless of SR-IOV or PF. So even if we
>> wanted to reassign queues only for PF's this wouldn't be possible.
>> I feel like an example would help. So let's say I do this:
>>
>> tc qdisc replace dev ens785 root handle 1: htb offload
>> tc class add dev ens785 parent 1: classid 1:2 htb rate 1000 ceil 2000
>> tc class add dev ens785 parent 1:2 classid 1:3 htb rate 1000 ceil 2000
>> tc class add dev ens785 parent 1:2 classid 1:4 htb rate 1000 ceil 2000
>> tc class add dev ens785 parent 1:3 classid 1:5 htb rate 1000 ceil 2000
>> tc class add dev ens785 parent 1:4 classid 1:6 htb rate 1000 ceil 2000
>>
>>                     1:    <-- root qdisc
>>                     |
>>                    1:2
>>                    / \
>>                   /   \
>>                 1:3   1:4
>>                  |     |
>>                  |     |
>>                 1:5   1:6
>>                  |     |
>>                 QID   QID   <---- here we'll have PFIFO qdiscs
>>
>>
>> At this point I would have two additional queues in the system, and
>> the kernel would enqueue packets to those new queues according to 'tc
>> flower' configuration.
> TBH I don't know what you mean by "reassign queues from one
> scheduling node to the other", sorry I don't know this code well.
> Neither the offload nor HTB itself.

So using as an example parts of the drawing I made:
Imagine you have a queue like this:
pci/0000:4b:00.0/queue/103: type queue parent node_200
It has txq_id 103, that is assigned by hardware - it's uniquely id'd by it.


Then I run commands like this:
devlink port function rate add pci/0000:4b:00.0/node_custom_1 parent 
vport_2 tx_share 100Mbps tx_max 500Mbps priority 5
devlink port function rate add pci/0000:4b:00.0/node_custom_2 parent 
node_custom_1
devlink port function rate add pci/0000:4b:00.0/node_custom_3 parent 
node_custom_3

And here I reassign the queue:
devlink port function rate set pci/0000:4b:00.0/queue/103 parent 
node_custom_3

So now queue has completely different parent and the packets from that 
queue are scheduled
using completely different parameters.


>
> My uneducated anticipation of how HTB offload would work is that
> queue 0 of the NIC is a catch all for leftovers and all other queues
> get assigned leaf nodes.

So enabling an htb offload leaves all the existing queues in place, and 
in case the
kernel can't classify a packet to one of the newly created queues, the 
driver is supposed
to select one of the 'older' queues to do the job. (driver receives 
TC_HTB_LEAF_QUERY_QUEUE
event)
So basically after running
tc qdisc replace dev ens785 root handle 1: htb offload
you don't get any new queues yet, but if you create new classes:
tc class add dev ens785 parent 1: classid 1:2 htb rate 1000 ceil 2000
you'll get an TC_HTB_LEAF_ALLOC_QUEUE event in the driver,
that means you're supposed to allocate new queue in the driver.

This just doesn't work for our case. Also our scheduling tree is rather 
rigid. I can't just remove the whole
subtree just because user decided to enable htb-offload. So as you can 
see in current ultimate
devlink-rate implementation I'm exporting the whole tree, and just allow 
user to modify it. There
are some constraints, like inability to remove nodes with queues, or any 
children really.



>
>> So theoretically we should create a new queue
>> in a hardware and put it in a privileged position in the scheduling
>> tree. And I would happily write it this
>> way, but this is NOT what our customer want. He doesn't want any
>> extra queues in the system, he just
>> wants to make existing queues more privileged. And not just PF queues
>> - he's mostly interested in VF queues.
>> I'm not sure how to state use case more clearly.
> The VF means controlling queue scheduling of another function
> via the PF, right? Let's leave that out of the picture for now
> so we don't have to worry about "architectural" concerns.

Devlink works more on pci devices, but I guess you can call it PF still.

>>>> So either I would have to invent a new offload type (?) for tc, or
>>>> completely rewrite and
>>>> probably break tc-htb that mellanox implemented.
>>>> Also in our use case it's possible to create completely new
>>>> branches from the root and
>>>> reassigning queues there. This wouldn't be possible with the method
>>>> you're proposing.
>>>>
>>>> So existing interface doesn't allow us to do what is required.
>>> For some definition of "what is required" which was not really
>>> disclosed clearly. Or I'm to slow to grasp.
>> In most basic variant what we want is a way to make hardware queues
>> more privileged, and modify hierarchy of nodes/queues freely. We
>> don't want to create new queues, as required by tc-htb
>> implementation. This is main reason why tc-htb and devlink-rate
>> hybrid doesn't work for us.
> Hm, when you say "privileged" do you mean higher quota or priority?

Maybe the meaning wasn't clear, so queue privilegeness is determined by 
everything really:
it's position in the tree, it's ancestors assigned parameters (tx_share, 
tx_max, priority, weight).
And it's own assigned parameters.

BR,
Michał

