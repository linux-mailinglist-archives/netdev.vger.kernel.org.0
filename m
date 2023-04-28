Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87796F2111
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 01:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjD1XFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 19:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjD1XFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 19:05:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A36A49D5
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 16:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682723143; x=1714259143;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=phgjbTWuKULpVfwtePhAS9DKaicTZLhWDXDC3q9ZCs4=;
  b=ImdQ2fWUg6JaKhTFzCVjZwXcfDWtFxElnfM9wWvwH/cQxgXCqqQs90SX
   emBEruNLcdL6ANkHw/CAmEXzbWq3xjGQiVZ3dQoUUQaNLSMn0BlutDb4T
   kacMrI9zni3aT58QIWZ5bv8IrcVvBsa64JDejGtDID36UxjrsSJTtnN6r
   jyo9o3o2k2UQdzCoX9Muu0Z81Q3YBdemKN4OMOt2dbPmiERXK7wieVFNX
   p6Cnc+G+xlX+jtmPGtkReK4YMcQONh2B3rAl+XARsEeXPwku87jKDH7IM
   GCqGlxOuAHNJIzuQI2kYJWNBkPWUDFJFbHYZkU+mvOGEAGxz4jHNvwWpk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="336962346"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="336962346"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 16:05:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="672365898"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="672365898"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 28 Apr 2023 16:05:42 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 28 Apr 2023 16:05:42 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 28 Apr 2023 16:05:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 28 Apr 2023 16:05:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1aFmeeCn+cysU56MX5sicKRUThQNEF+TTbrGFEDNJh5iDxxKNsNK1kqS8+a8woJFgHgzaEFLkQaIG7z+qYcD0oKVpqo+UjpO/hg6q9zj6SjJXZnzpo62PmErMdKmf7iK71q8HebVtPb/trVFB7QeE9kIWCjZscilRQdzzMSNhX1rcNroYA33lniVl7HdRO0yz5JC4qxBFkb68ePrmQakP9imdgbsiMeRzSCQRiJGLFDIQgb8CmjNdPzSy4+jLkKKyZ0hHkVaJv+DCoV36/Boo5OQQ5zDrwkkIQZ3MTUxMh/wYJjjk9asNjiumClo6wSEH5TX2f/aDABsXzvhmr3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YrQX6KOso0OISv0QZcz7WU4PjVPnLsn/7FRhzrlotCM=;
 b=krnTIRCoMFvXKdrOG1wUosGaDEAcCxdhOoRgt6PSBZK8UbG5S0q6PefVqGm69CyQheZDDNCBtB7pdwpqRkg/7SVnkXgWrvI7cTDagFywt7rav9M+TP13YhyGSCpiWCQCywJ5MK5i/gEYSGhLjFIlkVPq0VB8B+YDr3IhkHVdMg7rABtdHwlzUM+VXqxNki9ci2gEl8oGfRo5D0Aue9QogFOm0uY/5VBQ9HGEbRRZ6YQG17aeWkTSjyGcWe+ayRV505ufT2TgDXM4P2MhHR6FyRDmeBvpm3oTAM64fy900HaefkfLnBSqiKHD1IQ0mrCqLMJ/p5a3PjCN+wPtyavoDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5661.namprd11.prod.outlook.com (2603:10b6:a03:3b9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.23; Fri, 28 Apr
 2023 23:05:37 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::aae6:d608:6b8d:977e%7]) with mapi id 15.20.6340.021; Fri, 28 Apr 2023
 23:05:37 +0000
Message-ID: <9110854d-7bdc-db02-068e-3cc75800092d@intel.com>
Date:   Fri, 28 Apr 2023 16:05:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [net-next v3 02/15] idpf: add module register and probe
 functionality
To:     Shannon Nelson <shannon.nelson@amd.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <willemb@google.com>,
        <decot@google.com>, <pabeni@redhat.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <davem@davemloft.net>,
        <alan.brady@intel.com>, <madhu.chittim@intel.com>,
        <phani.r.burra@intel.com>, <shailendra.bhatnagar@intel.com>,
        <pavan.kumar.linga@intel.com>, <simon.horman@corigine.com>,
        <leon@kernel.org>
References: <20230427020917.12029-1-emil.s.tantilov@intel.com>
 <20230427020917.12029-3-emil.s.tantilov@intel.com>
 <616c557a-16d3-7be3-b0c8-5fa07cbf293e@amd.com>
Content-Language: en-US
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <616c557a-16d3-7be3-b0c8-5fa07cbf293e@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::31) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 36ef325f-6f4d-4e7e-0ec6-08db483d1437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dfNJ0PKdd1jm4BTBhlxAK7Io5YWTbACqVm0c4iHil+OkgVtAEFrbHsMXCz/vEeLyqUCnv+RjDKLfxlg9v/ulZs+jNSno226Rk/JJ7cTpB/SB1RYiW6kZDt0DxFagT4nVZCaeqzP5cM/vKul5uGk2/HxdOntrNasWYyx1lFbFlQQS7IjQa7CHFbWpr2ncoZqyhSFnm62rcnZWPZJ2sdw3DxxoxKuIajqnwe2lysgdvJRJJNht6S+uNbuM5BSYbeEASh+CE01C9tuBi+B+i/9qQ243QpbKd0X3tOBU+VO8GKQFNs6BFvLjZNL2AC0Vol7fC4IZ36YwU9P6A5+Je5kml/b/O7LErT4fBukTAf8+SzUCCnAnB+v2ZOh1Vz44ilmQEHLJqgXfUfU29PEk1vvp4v5tPvjNrwTEahQKP7ibG0D4cYrhF7PTUjFHjcV0azHH3rw2hCfHGliH6TF+KhokyN4EOuCsz3aMJEyp6vdMVSewCC2T6q3ZbzQT8vH10jMvyox22XeOU8dYgJOcnpRhNcj+PufMEEawjgdp8XKR1qpUt4B9Cw0CYr6zEpsUD/bjRctlwzUvBf/cHM86mFSTueY4s+AetYiCbmWDbJP0iq9ejYFCXR3xc4Mjbyi7MqNbPeW3vGKevjx4/u9gPVn/4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(316002)(66476007)(66946007)(66556008)(6486002)(6666004)(2906002)(4744005)(26005)(6506007)(6512007)(53546011)(82960400001)(41300700001)(186003)(4326008)(36756003)(5660300002)(8936002)(8676002)(38100700002)(86362001)(83380400001)(7416002)(2616005)(31686004)(478600001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0VzUDNKQkI2WTdXalhaaHlSbUdUMjM0cFJwbkp1OG8veXNzY2FLcGtBMnlS?=
 =?utf-8?B?eEJZQlUvMGxjQnRISkJHTW96Z2RSS2MyV2xxQUR5ZWdwMTQ5bE9DSWZ3V1oz?=
 =?utf-8?B?SXlLUjRnTStXMFNvcFRNYlVHbWxUQ1dqSW9JS3FoYTRwdkM1Qmp2UmNTVFRz?=
 =?utf-8?B?cTlCL3N0U05HOXM4N09KbzRGZnBHcnk3ZjBPcnBjb0JXRFlhSHhDZEdEQ1Br?=
 =?utf-8?B?ZUQzNlJKVDJ4Mlo5TjhQTk5NeXJjeTc4TFF1UmJ5SVNFVis5V3pHV1FTN3ZJ?=
 =?utf-8?B?ejEyU0ZDWVNjNFA4OEdsNTVvU1RJYUd0b3JveXYwK2hIdVFBNmpVL2VNY0pN?=
 =?utf-8?B?aTJTT0xvVjc3bTJrVUtvMjJ4MWw0bFlXTWdxRDAvZEpDbm5tQ2NXTGVjZDRL?=
 =?utf-8?B?aWVrRzYzUndBOERkTU5RZURQZGRXa3FUc0s1NVNPMi9rd2tRYkpucjJCM1Rp?=
 =?utf-8?B?MFprcTgxYVRKSlFzMTFlOG9QSThiYzAvNkR2OVZCVnIwZ2Q3Y0pVY2xWa3JC?=
 =?utf-8?B?VktVcGtWcVdpV1FkOVpkS1U2SlV3b09RemVtblBjeXlJUkE4S00zOVZxUWx3?=
 =?utf-8?B?NUFlVXZlQXNTRk0wcmV6V29uTGdueUhnV3Rnd2ZxQXZpTTBYOHYxMXA1a0Z5?=
 =?utf-8?B?NWFYTUE2MXRiMzZqanREODVzSVAwaFBwRVg5aHJRamtOWXdrVHVNMGkzV0RD?=
 =?utf-8?B?VVhjaHVEWjhyNldaU0xUNXdSNGNnY3BDSzNrSG5BSFV6cWRXVFlYeXBXbW42?=
 =?utf-8?B?UFpJSjViRlNPb1lEZ0czUzhDWWpLQ1gvR2hlb3BaZmJ0UVE5S2gxcGJQVk1Q?=
 =?utf-8?B?VG5CS1NzVzZaQjNZby95LzZwQlhqcFBtWnBndkx3Z0dBR2ovTEZaZnNrdCtv?=
 =?utf-8?B?NXJnMXphTUNDc21WYnFXNnI4eUpvRHoxQkpsQnpBL25GVWZkWHRicldIemxt?=
 =?utf-8?B?WFZjd2FjKzloWmJzVmxSdmsyS2JGNHE2N1R1SnhTQTI0azQreEd1T0Y4clBa?=
 =?utf-8?B?VlNFL0FaZTZ4UFp3ZmttK0pvZGJlRkJoSkF5S243cHBQRXYvWXVOWG1JU0kx?=
 =?utf-8?B?UEVLNklPOHVvNFpyT3RVa0x5ZTNUajdxc1lkOVBRcm1JeHFoNWYzdTVGSDNP?=
 =?utf-8?B?bmI2NnI0SDAzSVJUODhWdjRUTHdLb0ZMNGdLWHljMHYweGhzSWdGenYwVnM3?=
 =?utf-8?B?dmx1bkV4Y0JveHhjV05zaEhhZWlCem1SaTFKbDFVTm5SSUJtM2JOUFFkQ2VM?=
 =?utf-8?B?NGsrMCtrTHN5TmI3dWZQQTN6TXpkTXZQcnNxUVBBWTAxcVo3WTVKemdsdlkz?=
 =?utf-8?B?ekE4MjkrSUR6ajhmQnRxaFFISGhhUDZ2NHJhU1JHdjdFSE53RGhkNXRyV2gr?=
 =?utf-8?B?UUF3NU51SFN5WTV0OU1OSDFIc3d4MGphMUExNjY5S3dDMlNaUjUyNUtIYXJo?=
 =?utf-8?B?Q2RaUzFEVk5FbUZESnhMeU9FTHNPTmVKMTBnY1pZZmpTRW5ZK0trYkhHU3h1?=
 =?utf-8?B?OGVVRmlVMzArYjIySER3TGxQMEc4cjJ4OFdGdTNlMHNEVkdGeHFJT1FPU0dW?=
 =?utf-8?B?amVwTk1RakZFeHYzOUJlaXI1WWpqcTRndUpuYUE1WUdhUDQ0eTc1QVVCeTBH?=
 =?utf-8?B?WVhBVzQ3VHplNUFKZkgrTy9PZUdNYWt2bEdGUGMxTTVKQWx0SmlwVFRDU2V0?=
 =?utf-8?B?RG85M1FOOFU4b2FGTm4yVjBKaXlYbytabEd4UUtzbFFzOGZjbCs2M1F4emxF?=
 =?utf-8?B?SiswUUMxTHZtNXB6bVJSL1R0RnNodFFaNzdIenF0VkxQZk85cUNpNTJmMjJu?=
 =?utf-8?B?VEVEcUdvNE5jSFYybElwaGlxV2JEejFvUkZDaFlneFZLL2loa0tvK0p2Y2Q2?=
 =?utf-8?B?azQ1TXlaSklOdjRySnpPTXJCeTNoTTNUT2ltaTA5b09xY0U4OHhkL0xSSFJz?=
 =?utf-8?B?MHFLVnNHbmYzdnQ1a0tiaGlqU2d3YVlKZWp3RVRLbUR0cU1NSGZkdmEyK2Zv?=
 =?utf-8?B?VE05eG8xQU9CYUxxZmNGdHJqYkE1aDhJMVpmYm5lVU14bTNmRXM2NnRWcVcw?=
 =?utf-8?B?dTlQaUVsemtmUUt3czlkdUdDckw5aDQwTG9kMDVqWVJGNTFLWDZETm5wcmlY?=
 =?utf-8?B?K3djNUZnSzRNbC92aFZCcHVZYWdFNW43eGFTVmJNZWU2T3U2bjRRSG5IaWs2?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36ef325f-6f4d-4e7e-0ec6-08db483d1437
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 23:05:37.4989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0rcUSkxZHVCDQMocPV37Da9gky1/QgEjVTTvIgbm7U3HFOXfVbMAYmEEQo9bmTW2aixguRwHz8Z+BPw2giuYP4NPrQnXJpst1CwcVxZFfQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5661
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2023 4:24 PM, Shannon Nelson wrote:
> On 4/26/23 7:09 PM, Emil Tantilov wrote:
>>
>> From: Phani Burra <phani.r.burra@intel.com>
>>
> 
> [...]
> 
>> +static int idpf_probe(struct pci_dev *pdev, const struct 
>> pci_device_id *ent)
>> +{
>> +       struct device *dev = &pdev->dev;
>> +       struct idpf_adapter *adapter;
>> +       int err;
>> +
>> +       adapter = kzalloc(sizeof(*adapter), GFP_KERNEL);
>> +       if (!adapter)
>> +               return -ENOMEM;
>> +       adapter->pdev = pdev;
> 
> The custom more recently has been to allocate the devlink struct early 
> on and build the device struct from that allocation.  You likely will 
> want to follow along and play in the devlink world.
> 
> sln
> 

Good point, we'll keep that in mind for future development.

Thanks,
Emil
