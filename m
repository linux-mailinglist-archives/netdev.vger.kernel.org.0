Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3807C680A53
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235707AbjA3KDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbjA3KDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:03:39 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 915DF1717A
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675073018; x=1706609018;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IdENAHw161wQynRhNKrL/7DUIG5NQd6Q8PDF+Q+kXZ0=;
  b=N7jUK8Ff++MCMuvU/gV/thxDuvgCUdQ6mVoaHX2adaClpTP1GxfPnTvQ
   SH2PwWW5eIv3Me2K4DO7cvPGHA+EPP9qNiETSWLrErBibygZHA0WVMRtb
   P/KM4kGnaDRBkWY7lwQG02c8bPbG5X5IsisaRvVSArTLSDlVpYkeDeSjd
   DKCj3xqIh86BqZjBzJ5U1RmGsvQWOQ5j/RziyKgizfT6Hs2kHz+MCTTUO
   nfpYQshxo0QxdbZtfb+Af6WtH10DDcPbIISWyGS2b5CgTOjsYZkrUtnx8
   uDf/4ubCrDxc4FJvI/z+UCNLeeDRRXhgi6xvysOw3HtuAIGXW+Du+V4df
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="413739942"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="413739942"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 02:03:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="641473457"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="641473457"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 30 Jan 2023 02:03:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 02:03:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 02:03:25 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 02:03:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXwJ57UK7zcMc6I324MueqKLDdIP0zgxQQIHTApfoT6chX9U4SG/kP3qyTv5SkzUnGxAtxLjdh92fkUmKID1ltqxr9v5AXJ0hc6cCCzFl5mlNZAQ9LQJi8SiK+sDTfvgAsMPhZIOeXCEEFJa7/tE2qZlmTQCbacuFRyPsPtLvrZW3igo1J3JtTCW7nV7wneqOfMcpDZ0t1NgvnqG5eVua+TeO+i0es7I8hY6oyv8FGPNSODwWgQqkrddFJRicrLwAR5GcMuji9fnx5UM5K20DS/7K/koN5P9+KLaQkDp2uUAfObd0eFAd8UqlWpSoM6dGa9wAPUdxYWy8drGZQVxXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pYMInz0gIbD6hQb3BPFNlXl9XV+IBLVdOGsmy6MCJE=;
 b=PPXCzf2LuDa1VFWinYb8FWvwXYPZ9e6p89+JlnnWrn2exY8IvayjGZpDBQ5tTVifn9C0b8YDmzcYb4Rm4u1ZagBYi47grxHVmpVCYY/3LMKxO5k8PyLvrrTiMACryOkBI5HSoszniMemIcxed0ufGGjChV1VAaAvQ5rCOJNw4Wt/Y4uUBGP/+d3ZeCeHxWNQO/a8B3+67Jr2KC1dPnKZ+cb+MzehHD9vdndV22dGzMb44fd/k2BywdotKJEsYhfcArXVR/9DZ14gPrDkM/1e+ENa5lI6jgZUzFOlqVs6LqEjVwok7ZG9hdzn/1rrO5zImN77a3mPtho4rUk+8ERfSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5517.namprd11.prod.outlook.com (2603:10b6:5:388::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 10:03:24 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%3]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 10:03:24 +0000
Message-ID: <83d3f5c1-1f3f-a08e-1632-df8bc7b8ab7b@intel.com>
Date:   Mon, 30 Jan 2023 11:03:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 05/13] ice: Fix RDMA latency
 issue by allowing write-combining
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>
CC:     Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Anthony Nguyen <anthony.l.nguyen@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        <netdev@vger.kernel.org>
References: <20230119011653.311675-1-jacob.e.keller@intel.com>
 <20230119011653.311675-6-jacob.e.keller@intel.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230119011653.311675-6-jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0190.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5517:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9b192d-272b-4fd7-f787-08db02a93975
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E1COPxNquNCh+CVazX6GDPeW21Uofc+waxPN1SvxTGqIJjUHWxYFFqutNDLPX3ap2lGDBaMhg4hYeXtwpzQvx9zfJNWEaJM0DEEUnSwROeh/PzEsthDe3u8NQSh8Nmhw9M+sPqzfl4gu3An5YDe8QIE5te3k1EP+fukJdV3ZcaHuGCb8i6U7truIH6NuAGBHTZE6SJeBmrZ3CAzIUBQYlfBtcPWk1NvY3u0T77cxh9kyS5Hm73lV8NpSvr7U6CJcy07dCCJkb+vZmimUbefcL5DoZ2Ih62W1Rm0Ups3mVF0Vs5sjjeBwlWCo6KKJl3ksHYtA/3ISFFXieQv3xrBfhqYq72N79BIhqlL5tsdxO1eMflWRxec6FSAi/Izj/oWMzHi7fFEDYIvc8JtHhl42ZFTldJaq3iAyJIKkR34R06bkZGVgF4f1+F++iOadQzM+ltGdHN8IZ1GQngzbFhSrIeEiK2SXFC2jHMqBZOZcYCobe8ovDKFfXMA+VB8ItxtpcNl9G3d5AEYJQpvP8cWov+L8/BV7tVo2UWo70n6BkLz9LzUTHcuPEE8Ze5Zd1qV8fyPLPmS5e5SJGMN0MRXiXKpHVZZkWIuPeULcG3w62l/oSlnIc9vOwYlOCXeSGn8lW+ILpgEXgPOO5NLN6W2jkKHXju14MoE3FlX6nkkiys+IoQozDoludewG4v962OCWbvSKgttBRECJJ2gvHlkBpy1eZpCmV9y9iOIpiRfWht1CoEXy6k1qmrYQD5gYMBZwVrdb+JQ3iVBgrb7WX+7I0Zn3gpfIZ5QzjYc9HK+F1Y9zU6szTA5qxyy24mcwJ8cj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199018)(66556008)(66476007)(66946007)(38100700002)(82960400001)(8676002)(2616005)(4326008)(31686004)(83380400001)(41300700001)(8936002)(6862004)(86362001)(316002)(37006003)(6512007)(31696002)(5660300002)(6636002)(54906003)(26005)(186003)(6666004)(966005)(6486002)(478600001)(36756003)(2906002)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGZXbHI1bEVhazk5T3pvdDlUMC9tb0RlMkZqbUorNU12UE95LzFtNk85bWpW?=
 =?utf-8?B?L05LeUNVTFFkOTBSWjN6akxWTXVjaDBkVWRwaFVVb0MyQ213blFPNnJQNERl?=
 =?utf-8?B?VzdpTVI3cVY2dUVUYm1xS0tyMEdzeXl6K3pnMys5dHEyNVNLVThzNURjYnBG?=
 =?utf-8?B?UktrWEw1SGM0emp6UytNTXovNjJQTTdsV3phY0Q4MVBKU0UyK1FoVzZWM2tT?=
 =?utf-8?B?UWRiTWJVcWdub0JpenhHbXplQkp4U0VxT2pnSUZMdG5aanZ6RzBlbGorS2Fv?=
 =?utf-8?B?NDFlOWN0NTd4b2VxdXpMRUFlZ1ZjWW9lQm9OWTJMcFppNW92akU5SDNVTW82?=
 =?utf-8?B?L1BOdHFNSHgwYkorb2JlcUlOZGErOHkxSElES3A0OHVVU1ZlOVA3cGJ3UUxV?=
 =?utf-8?B?NVZsUmw0WHlQaXdCMUp4eTViNjIvSHVGUzl5K3hnZjFsd3dLV092b29RUE9H?=
 =?utf-8?B?cEMzeFEyV2ZIdzlFWlo5UHZMak5QMlBhV3NQT2FhV0pBZjhsbit3ZDgxQm1S?=
 =?utf-8?B?L3NFdGhJVlF4VW9EVVhraVl2SzVBc0IvTmFMYkRPRzFlR01lWnNsRCt0dHR3?=
 =?utf-8?B?QXFXRXFuaGF2NnY3STdOWHA2Z1h1T2NYTG5DaE9nbkZIb1hDK3Y0R1c0M1Ja?=
 =?utf-8?B?bEpwbW0xWTBockpLTWMvVDFDSFdkZklrK2NFSnAyb0hIV2Z2OUtSd1NBK2Z4?=
 =?utf-8?B?Z0pBRnVEblE4K2N1dXJOc2MwcG8vZkxQMzdJZ21HVE1sbXZRTWRpdHpNc0Zz?=
 =?utf-8?B?ZHI1Z1IyWlJ4YVd1MDc0YVEwd1o5dmZlTjN5M1RQRzN6RWk5UXErT0xPd3Fh?=
 =?utf-8?B?Q1l6OFVyUmVQWE9lM3ZNOUpqTTlJS1dPTVRHVDJJS3BWWGNSSmQ4cjNiY2RM?=
 =?utf-8?B?cVdVUWJmUTRkckNKNlRjcXhJQ3JLZjFOVlZzaHE3VHVSMytsVENzNFVxcVZT?=
 =?utf-8?B?SWRMd3ZiVW9mN2MxTUxlYTUwa1M0TTVyS044RmtqK3FHQUxhbkd4eWJlRHdi?=
 =?utf-8?B?Z0hYalFpUzJ2WSs3WEZLU0pzanVnM1dMZnpmTmlHTFRBM3VRUHZhNGZkK1dU?=
 =?utf-8?B?Y053UE5STC9kdGNDV2JwR2VKRnR3SUNUZTl4TWczQkJ1UlVhV3ZqOEp2RFFv?=
 =?utf-8?B?Z21qeHp5OWdWNW9ZQXdUWGQ0UldMWUpObCtyVkVob3lYekErYXpjaVBpV3Z1?=
 =?utf-8?B?WE1zY3BBK2JaYjNaWHlSN0lnQzlJMC9CWnNzd1owM3A1ejJRaU50RlBDdkpH?=
 =?utf-8?B?eEJ4MFBNYS8yQjViS1BETjVyUFBCVExIY2RUaXRXZWJKczFMRktVR2hYWTBG?=
 =?utf-8?B?UWxqSVFsWklyNDlFMVhkWkVtNDNmclNXRlFsTHhlcDUwNmtnZFk0d2JtOGdn?=
 =?utf-8?B?RlJuVVVNc0RlMnZjbzJLdVdjR05IVENpa3BPL2FNa0VxRkl4d0lEN2Y4alIy?=
 =?utf-8?B?TExPY0RIemlDK2UwUnk4c3hrUUEwRTBjTVdodXlTRitVV3V3NTJPc0FWa1lo?=
 =?utf-8?B?WlJEcDQ3ZjlGZlhEaFBxZVZML2JSdVdZM2tJMUtadkRDSUVtYUpMRVRuWkxS?=
 =?utf-8?B?NHB6OXBIcDZNKzVKczltYjQyNGRualpNQ1ZrVTdMdGgzUmErL2pmcXA0cGZ2?=
 =?utf-8?B?UXdXZGNvb09XbGRRcmgyT016K3Q3OXpYRG16THhkbHhuOW9VQ25TS09BZ2th?=
 =?utf-8?B?OC9qTVpvZUFGWEJFd3dXQVZaQXRFd1B6UUlnU283bVpQakhtcDNZMlZLZzRG?=
 =?utf-8?B?Y3dsRVlidWgxYzd1STNjNG5lWEtNVkREWU93aHY2YUJBdnhkZkg5NDZvV2dM?=
 =?utf-8?B?Z3pXQVpqUVc5bEtFOUhBTUZxbit6RDZKbnV0QnQ3MU8yUlh1UTY3V21PaEha?=
 =?utf-8?B?bXUrMkI2Mll0ZE9Cc0I3OURkUWJ5QW11R0F2MzJvdTJkV1dSTEMwUTQ0K3h5?=
 =?utf-8?B?a0FGTDZGTWh1ZU5sMmZwSmZab2NtcjNoakR5cXRhSlBwVURFV09wS3ZLcFRV?=
 =?utf-8?B?Q3l1TlZ6c21sdTBoYVNUNFhNY0FkdFlIMzd3SEswa0c5ak4zVmliZVN5QjU3?=
 =?utf-8?B?UWhRVjBLY2x3Y1FQbFZhQW5PQ3RRRVlPUDMyRmhPajZ2T1RreXFUdDF2OThZ?=
 =?utf-8?B?eG9RVkNNODdkcjZRNjFiUS8yTldXVWlhMitOL3BHZzhIbFZteGlqUnl0dVBk?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9b192d-272b-4fd7-f787-08db02a93975
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 10:03:24.1692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zKNUJbv9IruoySgw4nF4aqxF5ixg54MjgdwdRDYftZZc725Ma1oSXmi8Wvj+hrT1aYGG3OPdBz88UChbxNunQvLdosD02c4X0TB945xMXHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5517
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Wed, 18 Jan 2023 17:16:45 -0800

> The current method of mapping the entire BAR region as a single uncacheable
> region does not allow RDMA to use write combining (WC). This results in
> increased latency with RDMA.
> 
> To fix this, we initially planned to reduce the size of the map made by the
> PF driver to include only up to the beginning of the RDMA space.
> Unfortunately this will not work in the future as there are some hardware
> features which use registers beyond the RDMA area. This includes Scalable
> IOV, a virtualization feature being worked on currently.
> 
> Instead of simply reducing the size of the map, we need a solution which
> will allow access to all areas of the address space while leaving the RDMA
> area open to be mapped with write combining.
> 
> To allow for this, and fix the RMDA latency issue without blocking the
> higher areas of the BAR, we need to create multiple separate memory maps.
> Doing so will create a sparse mapping rather than a contiguous single area.
> 
> Replace the void *hw_addr with a special ice_hw_addr structure which
> represents the multiple mappings as a flexible array.
> 
> Based on the available BAR size, map up to 3 regions:
> 
>  * The space before the RDMA section
>  * The RDMA section which wants write combining behavior
>  * The space after the RDMA section

Please don't.

You have[0]:

* io_mapping_init_wc() (+ io_mapping_fini());
* io_mapping_create_wc() (+ io_mapping_free());

^ they do the same (the second just allocates a struct ad-hoc, but it
  can be allocated manually or embedded into a driver structure),

* arch_phys_wc_add() (+ arch_phys_wc_del())[1];

^ optional to make MTRR happy

-- precisely for the case when you need to remap *a part* of BAR in a
different mode.

Splitting BARs, dropping pcim_iomap_regions() and so on, is very wrong.
Not speaking of that it's PCI driver which must own and map all the
memory the device advertises in its PCI config space, and in case of
ice, PCI driver is combined with Ethernet, so it's ice which must own
and map all the memory.
Not speaking of that using a structure with a flex array and creating a
static inline to calculate the pointer each time you need to read/write
a register, hurts performance and looks properly ugly.

The interfaces above must be used by the RDMA driver, right before
mapping its part in WC mode. PCI driver has no idea that someone else
wants to remap its memory differently, so the code doesn't belong here.
I'd drop the patch and let the RDMA team fix/improve their driver.

> 
> Add an ice_get_hw_addr function which converts a register offset into the
> appropriate kernel address based on which chunk it falls into. This does
> cost us slightly more computation overhead for register access as we now
> must check the table each access. However, we can pre-compute the addresses
> where this would most be a problem.
> 
> With this change, the RDMA driver is now free to map the RDMA register
> section as write-combined without impacting access to other device
> registers used by the main PF driver.
> 
> Reported-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> ---
> Changes since v1:
> * Export ice_get_hw_addr
> * Use ice_get_hw_addr in iRDMA driver
> * Fix the WARN_ON to use %pa instead of %llx for printing a resource_size_t
> 
>  drivers/infiniband/hw/irdma/main.c           |   2 +-
>  drivers/net/ethernet/intel/ice/ice.h         |   4 +-
>  drivers/net/ethernet/intel/ice/ice_base.c    |   5 +-
>  drivers/net/ethernet/intel/ice/ice_ethtool.c |   3 +-
>  drivers/net/ethernet/intel/ice/ice_main.c    | 177 +++++++++++++++++--
>  drivers/net/ethernet/intel/ice/ice_osdep.h   |  48 ++++-
>  drivers/net/ethernet/intel/ice/ice_txrx.h    |   2 +-
>  drivers/net/ethernet/intel/ice/ice_type.h    |   2 +-
>  8 files changed, 219 insertions(+), 24 deletions(-)
[0]
https://elixir.bootlin.com/linux/v6.2-rc6/source/include/linux/io-mapping.h#L42
[1]
https://elixir.bootlin.com/linux/v6.2-rc6/source/arch/x86/include/asm/io.h#L339

Thanks,
Olek
