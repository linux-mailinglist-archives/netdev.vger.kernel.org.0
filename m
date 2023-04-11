Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3FE6DE7F8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjDKXVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 19:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDKXVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 19:21:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B842D63;
        Tue, 11 Apr 2023 16:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681255278; x=1712791278;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4Cdw1xAsho/KMggcciOQsdJSFyc50zdIMW9kznH5r4s=;
  b=gYcDA0azwEuPchVNox9rSdwlLzXK24JKJTmU10wHzFdJt/ihB8ztANsQ
   oDzvZm4ipA9KtHZbp7tFW6HSK1lLXRCIkrlpGKHci5LZwC0EONrNRSHj4
   eFSslRTP80e+dlqBGPiwe+OdeNQqOhufVUNPGTbzKXYFQq4mjn4p3nSwQ
   MBb7ilVWLRHmbRH0uP2Zfd6b9nQ7gf9R0jr5ggr5b7sAODIPtdEVpRfvF
   pCOQzIb+yu6lpjlxa7TnfHLe6Lz6kq+QONZvxaAk1QDNnnEb2ED5Dk7jN
   JQfqPN6tuofE8lcC48YnD4e3TDmAWJ8YrKHo9ycnD4OSzd6yr8EQX72bG
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343762121"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343762121"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 16:21:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="753312168"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="753312168"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 11 Apr 2023 16:21:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 16:21:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 16:21:13 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 16:21:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flTUm6lpQIvbnGM3FZDEqvzYIosoGgsQ7IWmWQyMTKPftg7vhinWftoc8EzAOgtSYj4dAnhhkiw0QA1fnODPsogBoVamPgn5jQr7iVmxbs7cFt/ukAeMDw6DHHsQZ/ApyQWjMh1wSz4DFoqs9a3fvCjAwMe30sopTCnMOjFaxTUFARexbPOjNUBI2kTAS8gRdIxStWydWwosa/Ir9S+QHJTCPquTpKiPsRCRed1UF8di4pTtqDiNMtdZBkcqehJze+VtTujchebLEh4gJz1K/aAQpZbKL+CJUIEt4idjnm4D/gKnUaKgqF7L7sP6+RDuHQmYhilMGSlktkrN/umbvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Edo6q+E35VjnY3Cnf64yMUAZu6UWZ2fvsSejv9KEHrs=;
 b=Ts7KaZ+JknH6sSQS6LyA5kuQkPnpTB+reX6ardOjYBC9X+HLD2B4ePog/s3CBedo1HaLInTEg34jWPSA8OyKdP9nuCToY03ov1Y5AycRq/vcs4LCZGkM7lMk0XZYJRBUuJsvc6IuUK7LN5mi6ayycPMcW4fRRawmx9fzo+NOca/YILgHXHfjaEiQ5jE7h4lkL2kpN01F3nqv/GxgTNhvr4EqqPwp5c9mI95gWR/rvcixae0eLVR20NNw5hnzP8XCGpNdVGP0idyXvTGFhRBgoldCs0RkZltmrrKU/f+Cs/JKx1Y6cUwcL5KxhDSbgcqgOLKpE0ZIrKVyheS9M27PZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.30; Tue, 11 Apr
 2023 23:21:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6ebd:374d:1176:368%5]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 23:21:04 +0000
Message-ID: <7c5eb785-0fe7-e0e5-8232-403e1d3538ac@intel.com>
Date:   Tue, 11 Apr 2023 16:21:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH rdma-next 0/4] Allow relaxed ordering read in VFs and VMs
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, Meir Lichtinger <meirl@mellanox.com>,
        "Michael Guralnik" <michaelgur@mellanox.com>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
References: <cover.1681131553.git.leon@kernel.org>
 <ZDVoH0W27xo6mAbW@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ZDVoH0W27xo6mAbW@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6984:EE_
X-MS-Office365-Filtering-Correlation-Id: 07fec917-2a82-49e8-36f5-08db3ae36b94
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPMJIekEkPUEEIMBSoK5BGRdt64j6xxd8FHotTaYcXm3iH8d6K6coTX5oIJTORpF5zowXaBRBf7DGPYH3EzbNCBzupk1omNY1QgHY6NyU4S+VVt5gjPWYtBQby1KKaGCswXxEuFY7bd0Is72K/TdMUyeBTVX9SaLDtl2oD6sDe+pOk3h+wGKPrxVn4wBSIuvAdhN5hJ285xrerHy9omt6pQ+oJ2lAWd04Bmyj7Xghx4p+dKdtRDIJdHGjPaNHI91FF1OpmcdowOqM5obCtY+bz3+74X5Y0pafw/G/Or8CnpUde29LDsmT1qMIitRjpuR4a6Q/jjAaitllAuKV5Sirklmq6GzIJyv7OmbcCStqZ5+RrDHOTcCsW1d88PDo7yLoD+s9vSb1wS9PCGVgJG1ID6BNogzqEGdk5Uo3nW9ToOGymycEsy4u+ZfE3Rb6cJgUly/7tsWsnGA9TqCGqGsJTCltdgamZk6wid8alpgmYIQCyu1mz0PNNHgvFzuy7DC3wgERPtYxjwqV3uTIi5xM6Z5bYlos8ctMPbqptYppT9g6gjibuK/Ugx9HZTkL1dh99+Qlp9JJ+mByHNghLC57vAPuykSYSNvNvlLC5qfx0RYB59wMXbwWFGkvT3+z48hln3Ha31adOzAGugqqt4fXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199021)(478600001)(6486002)(2616005)(6506007)(26005)(53546011)(8676002)(6512007)(2906002)(110136005)(54906003)(186003)(66946007)(66556008)(66476007)(41300700001)(4326008)(5660300002)(7416002)(8936002)(82960400001)(83380400001)(36756003)(31696002)(86362001)(38100700002)(316002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bGI1V3Q1ejB4T1lrdEVKTWM0QXVBSWM0UE5ZRitDL1dvMHliNTVRMCt1c0N1?=
 =?utf-8?B?cGEzVXFiVWJyU1pSMzV6QW5lUmowayt6SHRFdXpqRHU2U0YzeTBRTzJieTB4?=
 =?utf-8?B?djBqTUhFYTdpclh2d3ZiM0hhZm9nbWs4RUduSmJKSjZKajd6VHRPYW1GY2xW?=
 =?utf-8?B?d0lIcFM4Qi9XTTUzcG1YSDNCeGEwNDAxMlYrd2JaSFdrT2lqSm0wU3kzS3FQ?=
 =?utf-8?B?L2JleXVyTGpNbURDUTJodnN0bTRRR1AyYjJicXpML2R6MXVaTWZZLzByVzJR?=
 =?utf-8?B?VFhROWswYzNZaVRyS2d0Zk13cHR1RElTV0orOEo0QTRxOWxTS0xkdW9OaG5N?=
 =?utf-8?B?b3VvZFNNRzcrQzlsb21RaWdZUDJWc3I0b1ZLQTV5aHFFckNoSWhrYW5JRlVC?=
 =?utf-8?B?U2d5Q3UzaW1Ma2FwS2E0bjU5U0wva3FSNThERVJ1K2V2bTc5Q1BieDF2NDcv?=
 =?utf-8?B?WXZqemV2bkpPY2dlN3JacUxlbWJCUVl5aHQ1L0NuODNpa2NnVDZSb01MR0FW?=
 =?utf-8?B?MHMyYjRBME9FZGRzZ2VpaEQ3dk9YZjllS3VwS2Fna0hGZElXNEF2dXdJZkFj?=
 =?utf-8?B?aHVFU0JBN2hQWUo4MWZxYlRrYUFTSE1wSHBYcHRtaUZZcW9sNVRRakdxQXBl?=
 =?utf-8?B?VEdzVWJ0Y3Z0bytWWXR5Vm1RZ0JqdjBJZ0hyY3c0VjBuL0dHN1h3NGwyVStT?=
 =?utf-8?B?UGlkKzhqdnFXWFpPS3lNdHNDTnlONS93NnAwWTYraWhpc1JOd09EcW81UUFJ?=
 =?utf-8?B?MlA2NnBKTDZlc3hQSUVFRExkWWEwV0dyYjBkd3pSaHg0MXl4aE1YdEFhaGlD?=
 =?utf-8?B?cW5sU2FXTm51TVY5a1BYSGdoOUxqNFVUeGlZVVFJeVRTdUswazhOL2VqUWcx?=
 =?utf-8?B?RkVYcHNtdnFqcmwrdkVSdDd6aUdISjNyZWxXa1RyTzdPcTJHUFZXelE2R0U0?=
 =?utf-8?B?djZnL3Q3QXBHZVFlNDZ5ZUlReWFkTGNKenZmOWhRMkZpYWhnK3NVd3kyZkFJ?=
 =?utf-8?B?ZlBIWGI4Y2lScm5oTXkxUTgyNkprSXFuOGtnUVUrZWJUUXpUS0h0SGVCZzZl?=
 =?utf-8?B?ODVmWVprQjNNSHhEc1VSTXdLWEVQVVZrc2ZMSWc5OUhYQzdRS0xjR3Z1VW1V?=
 =?utf-8?B?ay83T1NTUWJZajNsUXRlY3BKWFB3NlU3aEhMMnhlcGNuNmZlNnBhc0JRbXUr?=
 =?utf-8?B?b2pLYy83UldHUnZSZTFLOHdzN0dvSDBvYU80UHpuNk1wRC9lc3VlVDVYSW1B?=
 =?utf-8?B?c1VhME9CTW12bHRmeTc5SjhGK0g0cEl1dXZrZ0VhZGJ1T3RVUE9tT3lwak5r?=
 =?utf-8?B?S0FMdzR3ZU5wZTY3ZWNoWEpESEMwaVNUdm9uVWtDTWZmSjh5RnpBbWtGUHFB?=
 =?utf-8?B?c0VCeUtMaE5OSmJnVVd0czY2ZS9OS2llSHNiOWN3U0pqWHNjTXdVUGxTNjAz?=
 =?utf-8?B?eG5NcGxuaGtsZnIvSWpXVzBhZmtSRlpzemZwdlZTMkxnemJjdXZBNklHckpX?=
 =?utf-8?B?bms3U0RoYzc5ditNUENEL3ByeVlnU1JnYmxmTElvb3ppaFN1L04wVzdzbDJm?=
 =?utf-8?B?MGpCSzVjN1U1TjI3VytPNmg5U1V1SjVRMnZDMUoxR0dOK0o0bGRRSUxFQisr?=
 =?utf-8?B?KzJsc0JTZW51elZqeUlnOVhxc01lakdyS3c1WFh5dytMRm1nUXFxL3R3M3ZG?=
 =?utf-8?B?THVJc3F1bDQ0RkxyZS9BbTNSMTFVZGZhU2dXeHZRUHN6OEZ3VWVkeVlsaStZ?=
 =?utf-8?B?WlpqZStYYUxaMnZiR1BWY1F1SjUxanVzN0c2NkRxbmZFeFlickw2eE1UQTJj?=
 =?utf-8?B?QnpnT3oxajIzenFvYW4ranV0czRnUFZrcTBycnlGTkNMdlBDalZhcld5QTJU?=
 =?utf-8?B?bmgyMUJRVzVlMmFrTkdneG51SVZOUkFJcU4xb245VVBjbGVuM0ZSMGs5ZWJQ?=
 =?utf-8?B?enF4cWM3SUZYSTRmUHR4c0dzMk9nejJBSDYzT2hiNVdKb0JnTEQwa2ZkWkwy?=
 =?utf-8?B?VVR4R1pzcFpzejRnaS85QlJCaWpYOVZGcmtPV0Jzeng2WGQ1WXJvWTcvdUhF?=
 =?utf-8?B?R3FNb0lMcEQ4WjJjZVhockk1UkxpMDNMdkZFUVBsN1NCUUppZ2drRUZHQy95?=
 =?utf-8?B?K1VxYzcxZjRCMWlFK2htczc0aTJDOGlJT3lyWmM5TDVVVFdpT0V1VnFJc3I0?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fec917-2a82-49e8-36f5-08db3ae36b94
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 23:21:04.2355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xudt4SmDBLbJWsv5A/raMcnsVd2VFyeMmS2qG0eaAgHkbQrKy2A2HnyKqp8PHHJQtr92rg41Ul/nIv9UkGkRCmqY8osSp9WotiS1ulXbpf4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/11/2023 7:01 AM, Jason Gunthorpe wrote:
> On Mon, Apr 10, 2023 at 04:07:49PM +0300, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro@nvidia.com>
>>
>> From Avihai,
>>
>> Currently, Relaxed Ordering (RO) can't be used in VFs directly and in
>> VFs assigned to QEMU, even if the PF supports RO. This is due to issues
>> in reporting/emulation of PCI config space RO bit and due to current
>> HCA capability behavior.
>>
>> This series fixes it by using a new HCA capability and by relying on FW
>> to do the "right thing" according to the PF's PCI config space RO value.
>>
>> Allowing RO in VFs and VMs is valuable since it can greatly improve
>> performance on some setups. For example, testing throughput of a VF on
>> an AMD EPYC 7763 and ConnectX-6 Dx setup showed roughly 60% performance
>> improvement.
>>
>> Thanks
>>
>> Avihai Horon (4):
>>   RDMA/mlx5: Remove pcie_relaxed_ordering_enabled() check for RO write
>>   RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
>>   net/mlx5: Update relaxed ordering read HCA capabilities
>>   RDMA/mlx5: Allow relaxed ordering read in VFs and VMs
> 
> This looks OK, but the patch structure is pretty confusing.
> 
> It seems to me there are really only two patches here, the first is to
> add some static inline
> 
> 'mlx5 supports read ro'
> 
> which supports both the cap bits described in
> the PRM, with a little comment to explain that old devices only set
> the old cap.
> 
> And a second patch to call it in all the places we need to check before
> setting the mkc ro read bit.
> 
> Maybe a final third patch to sort out that mistake in the write side.
> 
> But this really doesn't have anything to do with VFs and VMs, this is
> adjusting the code to follow the current PRM because the old one was
> mis-desgined.
> 
> Jason

FWIW I think Jason's outline here makes sense too and might be slightly
better. However, reading through the series I was reasonably able to
understand things enough that I think its fine as-is.

In some sense its not about VF or VM, but fixing this has the result
that it fixes a setup with VF and VM, so I think thats an ok thing to
call out as the goal.
