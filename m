Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC423566232
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 06:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234365AbiGEEX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 00:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiGEEXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 00:23:24 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC66388C
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 21:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656995002; x=1688531002;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rneZG3zkdD5PIKDxiGJcUZD+v33go7QD89RqTxlWSu8=;
  b=d/6xdS+jDg/OROgUk8QpS4dPrqkLnRbgjOu4G9O7J4en0FMxcRQg1zeY
   pWhWEL2hTDqKKWHDWcEHNYnNfE9pnNmhHV1SMHeyuZ0nI+26Cw+STx2UI
   Rn2O7+abjr/6HnvvrD7tlvf9DQtLN4vfrvOM8sRoq1S0f/GQYbYNyYdBX
   bCW1jdW9TKFO9TD/tLvCEVwfykcUC2gwI758J1TnuhYL9T0+NH9seY8Vl
   xGkSp0tqzM0hvR6R/z4MzPGlTPLqhCQO/iM7CDZ7eBA2n84hkuOoFaZce
   56qjCU1wqtb16uE2PIxsTYNzQGosoQaBy4KkcZxu5fOCvdMeAVd6lme2a
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="283274274"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="283274274"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 21:23:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="660397144"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 04 Jul 2022 21:23:21 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 4 Jul 2022 21:23:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 4 Jul 2022 21:23:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 4 Jul 2022 21:23:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lbv6CatAK9vZ4LtzwwU7py9RLW6kAQwh7miNyuNPy2KzpTSN/vh+fXcznVEOUMqN6ZAJrjhQkJVCIaeD/oGq8EqFfrtLYQpnql99aUa0tafB9ZgJUPeGNDNW2HNfDONrBpG3Vn07ZWFA0nbLvio0m48F/NudrLJVRr9Z2K+WkTvDfmfSoSJoBjF9e5XC0EoOwVNNJ9IDrFemhPqJz3Ni8CZrM/q08YzrcaXnLtSYNm5MVBTrR6n3uI2xWTx4MUFibwR5g70x08t3GvSdEvUNfLUrOFTIL0oxrS4CmnGCA3XH7u0NZAyy0PBKREhJX6l/QF+TW3JpAEMj+XleWINxOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H91QRy0OWnHoT+XGEysQDb2b4vwYJqgl3bdbBIzg0gw=;
 b=ib4Hxl5CYlhn4yOSX5kX13xZcJC//YGi65B/NE/285XBFjuaDrm/fkEjG4b9TTT3uxbZ+m8iA0FrtyQAL8wjcm8lsE91Hh7gwPYTN6yedIVB/2QOR02wLNBF9+z5pm+Jdo3Xu2KcYBnr1k+RW9iQV7RLq+E3ck0/jz6/mKgrkJ4o2wdYmuT+ZokhILnoAbMowRiUQmZeom9kESbQ8G5ZqRWK4z95ZoVnEzWCGQWxQKejfR14MPvPUxeNO0vfvlWJC7CKv9Qyl/qYMZxliHHXkcsblispBjPY6JlEqWEzdzYmUWSNYPlcWwoNJVgIQoQ0Nq0XZPUakdxJCJAlieYKKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM5PR1101MB2235.namprd11.prod.outlook.com (2603:10b6:4:52::15)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 5 Jul
 2022 04:23:19 +0000
Received: from DM5PR1101MB2235.namprd11.prod.outlook.com
 ([fe80::39c6:7b40:e013:1086]) by DM5PR1101MB2235.namprd11.prod.outlook.com
 ([fe80::39c6:7b40:e013:1086%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 04:23:19 +0000
Message-ID: <5da47a2f-cb4c-cb18-496f-6899f9d0d5e4@intel.com>
Date:   Tue, 5 Jul 2022 07:23:10 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v1] igc: Reinstate IGC_REMOVED logic and implement it
 properly
Content-Language: en-US
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        <intel-wired-lan@lists.osuosl.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <YpjeEyMxobCIRfTx@wantstofly.org>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <YpjeEyMxobCIRfTx@wantstofly.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0060.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::37) To DM5PR1101MB2235.namprd11.prod.outlook.com
 (2603:10b6:4:52::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f72f13d2-6317-40c4-5071-08da5e3e16d8
X-MS-TrafficTypeDiagnostic: DM4PR11MB6287:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SdrRVrv4U69YTFg2OCBCp9uaSnEaNkHyz6DQALcPIzABp7c0Eq4y91JIe6sZhByrGuv4Y+bsTMk3NN5H+P2fB26ey1zQqKXXrNA9T/+7gDwi4PFpb1X6/e25BWn4XnHIl97ggKcmJv/rUGWnvkOyjfdJ2oywfRK1iYmKrdgNA/qHS3Lbs2x9DLIWxQ/5PDP1hK84rVJ8Mw0Tk6dOJhHlqLzDRdOE5ijSFLkW1j2TPyl5abD4J+XYslsFtBowuXrGFIwdcf6IzZ9FVyZ5bchgxV+s3gU28GozkdneE52d2MQ7DsQ6KOCZsL4xWyBBlmRMl//jVgRNqYxaSe8tg99zOHuJjvKTyc5nh+7MFCjOCP3c+gRffLax+/MfasSZBSpSgZ2bb1laxYcGLDVujboQ9MtwFKgwoaAfHcvfkrfTXTgmi4g427MpyHP9zIzhKfmsD90SLODCUrZ7l3d+tFAv6MiJONZ5Pj/nDMFmskMJOuAh+rzxdSgxSj0bo8lz+lJBw7/8YLft5I+bymlVN6uIaP6xBNKZ2pkFEH5GhVs5LOKcPj+Q+3RlltMAkZq4hKR7dR2l/fk337KEKlpzkiZXjfhZWLHYChAV1r4/csJ5bRM7fZx9/ByLe1qAFkEOFqNBseynmxYzJjDrdHxCMOTdWG4jkLYl9NfZBd+Ssrs4ecg1vW3dYAackqny+nBkX+wAMGhyPJqL7jlBAMJMoryl7ADuWJ7Ekd11z1ogKonAUSt2dPZFCVZK5LJOenVAWppCbvNTCk1A+u/sjEXCZp/7WFuN4dOV4Vl6Xm1EIdr+OK+/VGZA4sTK0qFtyr8Ph+wNtPgJrqYBfylMllYg8o/lcqBjAk1/yGeT0kogdeu7vtBlO5+vuHf8Ld5ZeRV4SzZ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2235.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(136003)(346002)(39860400002)(53546011)(6506007)(66946007)(66476007)(8936002)(4326008)(8676002)(2616005)(41300700001)(186003)(82960400001)(5660300002)(107886003)(966005)(86362001)(66556008)(31696002)(6486002)(478600001)(110136005)(316002)(54906003)(6512007)(6636002)(6666004)(26005)(83380400001)(38100700002)(31686004)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WE1Qek9laUkvLzRaOHBvaDQzUm0wa2RIQnpyVmRyblpvNnRSdDh5Q1N5ZjVk?=
 =?utf-8?B?cVgyenRSMUdBNEl2NkhBZlQxRzhqalk2M1IrV0N6Q2ttSjJ1QjlKSUczS1Rx?=
 =?utf-8?B?RTQ1Z25pZ1p6TGVTOFVOK3JjU201VEpIRVNQVDY3SDV2Sk9sUzVnZDYzaVRP?=
 =?utf-8?B?dkt4QkxlUldMeFVQZEZYMnJmcW1FekdMelJ3eHdrSUlEdlJuOWNWc2RzNjdl?=
 =?utf-8?B?RXVOWW9MaHRhOFM0NzlsQzBiVkJlRlJ3QnIxWU0xQ3BGT0Rnbjk1M3lwNGdu?=
 =?utf-8?B?UFZDWTZTejZHdE5UckJ0bkpBTWpDTjdIWW1EYW5LRFNpMWZBcUEybGFpRXlt?=
 =?utf-8?B?cC9HSGlQbXg1REVVVmx1bUlNeUx5a2VWa1dEaDdXTFZPQXpab2p1cHRJaXhQ?=
 =?utf-8?B?YzN3Rjg2NXdyQk8vL0JkUUIzMmwrNkVaNFJLRUFnYVV3RThCL0dNc3VEcFZD?=
 =?utf-8?B?OG11bzhBSU1Zd1FGdk5pdzVmVmtHMUo0WUVzcHVqMFVScjFRY1VkekdYNFVS?=
 =?utf-8?B?K21PcElPVi9adlc4TU1ySHRYeFpIWUJNc2dmZnBUUTA4UHRPWnF5bm1QYVJT?=
 =?utf-8?B?K3pLY0dWTmFaYlhBK0JVaEYrWVRNemtvVG5ENGNKQldSRWlhN0tSaUFHVDFv?=
 =?utf-8?B?OFQ2VGZYRUVXR3YwME14d3ljQUFIU2t0dHdRNXdUOTVpQkFmUURSdlhualRP?=
 =?utf-8?B?STJIUE1GbmtySEUzaWxJTWJ6S1dZRGdlUHFwSm1LQXh2M29pVndtcnQ2TmRM?=
 =?utf-8?B?a0tqMnZIQzhZcjFiTnRncDVSU0lrVERYMTNaOWNMcVhLdFFZNXVDVVR1UG1i?=
 =?utf-8?B?VElVcVZCdloxNGx0RTZzOTFlOUFXNUdDYmFoNXpqcm9BTDAxQjdITHREdmxH?=
 =?utf-8?B?NXlMZXVOQVRXbmpUWHJFMmZGcWQwSFZqRWsvZU1rdzMzOCtsT2ZxZjQ0SDRD?=
 =?utf-8?B?TENTM1NiMHJZZjhDS0lEa01iZ3FxSUp3cHVzU0JMcG5rdDBVZENzb3IzOFNl?=
 =?utf-8?B?aGpzN01jL2hvNlpLQm9xYzl6d0JpY1N1NmlXZVltc2cvUUFncDJjRjY5Y0NX?=
 =?utf-8?B?Z2xpYnZ2MGpJRTZTbG9QakNhRGxFV3dwN3lseHJPV21UM29ROHFsVEYxV1Zq?=
 =?utf-8?B?SlhnSGFLckJ2YWw3Y3ZabU43a2NXU1k1bGdCaGxiaWV1MFdDU1Z1V1VjZGUz?=
 =?utf-8?B?S2k0MEFDdSt3STU3VHRuc0g1dEdsbnBRakFSZ2xRYTEyU245OUZtZ3hhZ2RX?=
 =?utf-8?B?ZkFHUGh6WXlGVktKc3VNSjN2Q3NPTjBmay83dlNZTU0zandtUkZYWUFlTVF6?=
 =?utf-8?B?Ty96Skx4Z2hEZ1J1bHdZUTN5NG4rRmJMeEpNWisva0FocXlhSnpGWWgwMUcr?=
 =?utf-8?B?MUNYay9uQjNyK0pEWkVRZEthRS9OSEwvVUVDMHczejYxQXdtVXliUEJBc005?=
 =?utf-8?B?bEYvOWhLT01oY1hDaDl1cThWRHRxMjNRUDRoT1ZzR0kzbGpxUWlRSzRPMDI0?=
 =?utf-8?B?cDBDczI3ZVA2VU9kdG41bUo4VjJUWjE4VjA2WW41U2RyMnZwUzZ5QzROdXVI?=
 =?utf-8?B?STFhZHVuUUlnLzg2eDBlUTJ5VWtaa1RoM3Z2SmZ4bk1YaU0xbWt2a1lPa0RE?=
 =?utf-8?B?MElkSWI1N1cvcUZPWGN2UHI2eVNzNU1UMnZvejhWcEZNL29FVHMvc1VFV1Rr?=
 =?utf-8?B?U1Blb25YcXFDaVhUL2JVVmRzOUczbDhjS2dDTEs1emQwYzdiL1FOa245amVV?=
 =?utf-8?B?dWRMaDltYVh1TDdNV2x6QjZMNTIyek1KdlpkaW03M3VPaEM5RkptM2hkWTBh?=
 =?utf-8?B?ZHdXQUVCTVphOE5iZEs4L1VXNWI1VVR3U3NhbmNRa2ZyNXM2bWoyVCtjRXNs?=
 =?utf-8?B?cytrbFR3di9JZHhERW9aOXgxUDlqQjhzQVFWOW1FS0VYVW9abU9PTnRkSU1N?=
 =?utf-8?B?RWR0MGtIWEJ5ZGhuRFhLQTZMRDVmNHdIT0wybDBYczVHcVFyZ2RjeVFOdmtu?=
 =?utf-8?B?K3FaMzNpczZXQkRzbmpleDFwVGxwYy9BSTJJR3dUdnZPQXF6WFFDSjIzRkRB?=
 =?utf-8?B?Q1NiL2kyTlBLQmZESHBLdnU0TmhPNmRrRGdqZGxQdE1vMlZ2ZkZ3S3V1cU5J?=
 =?utf-8?B?Q1d6K1dPNkZWV1RucldDM3hIMndTemZZNTQvM2VxVGsrRU51UWp5QTh2M25G?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f72f13d2-6317-40c4-5071-08da5e3e16d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2235.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 04:23:19.3729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGhz61kEiWfMP9q0um6CXVlfWtksjkeKXUeo7JS5WyC2ryZNrSy+jUkbpPgir9GELGsspWiDbZ4ma7Dm53zfjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/2/2022 18:58, Lennert Buytenhek wrote:
> The initially merged version of the igc driver code (via commit
> 146740f9abc4, "igc: Add support for PF") contained the following
> IGC_REMOVED checks in the igc_rd32/wr32() MMIO accessors:
> 
> 	u32 igc_rd32(struct igc_hw *hw, u32 reg)
> 	{
> 		u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
> 		u32 value = 0;
> 
> 		if (IGC_REMOVED(hw_addr))
> 			return ~value;
> 
> 		value = readl(&hw_addr[reg]);
> 
> 		/* reads should not return all F's */
> 		if (!(~value) && (!reg || !(~readl(hw_addr))))
> 			hw->hw_addr = NULL;
> 
> 		return value;
> 	}
> 
> And:
> 
> 	#define wr32(reg, val) \
> 	do { \
> 		u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> 		if (!IGC_REMOVED(hw_addr)) \
> 			writel((val), &hw_addr[(reg)]); \
> 	} while (0)
> 
> E.g. igb has similar checks in its MMIO accessors, and has a similar
> macro E1000_REMOVED, which is implemented as follows:
> 
> 	#define E1000_REMOVED(h) unlikely(!(h))
> 
> These checks serve to detect and take note of an 0xffffffff MMIO read
> return from the device, which can be caused by a PCIe link flap or some
> other kind of PCI bus error, and to avoid performing MMIO reads and
> writes from that point onwards.
> 
> However, the IGC_REMOVED macro was not originally implemented:
> 
> 	#ifndef IGC_REMOVED
> 	#define IGC_REMOVED(a) (0)
> 	#endif /* IGC_REMOVED */
> 
> This led to the IGC_REMOVED logic to be removed entirely in a
> subsequent commit (commit 3c215fb18e70, "igc: remove IGC_REMOVED
> function"), with the rationale that such checks matter only for
> virtualization and that igc does not support virtualization -- but a
> PCIe device can become detached even without virtualization being in
> use, and without proper checks, a PCIe bus error affecting an igc
> adapter will lead to various NULL pointer dereferences, as the first
> access after the error will set hw->hw_addr to NULL, and subsequent
> accesses will blindly dereference this now-NULL pointer.
> 
> This patch reinstates the IGC_REMOVED checks in igc_rd32/wr32(), and
> implements IGC_REMOVED the way it is done for igb, by checking for the
> unlikely() case of hw_addr being NULL.  This change prevents the oopses
> seen when a PCIe link flap occurs on an igc adapter.
> 
> Fixes: 146740f9abc4 ("igc: Add support for PF")
> Signed-off-by: Lennert Buytenhek <buytenh@arista.com>
> ---
> As initially reported on intel-wired-lan@ in February:
> 
> 	https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20220214/027787.html
> 
> We're seeing these NULL pointer dereferences hit fairly reproducibly
> when rebooting, presumably due to the particularities of reset
> sequencing on the boards we see this hit on.
> 
> A link flap can be caused by toggling the Secondary Bus Reset bit
> in the upstream PCIe bridge's Bridge Control register and can reliably
> reproduce this problem.
> 
>   drivers/net/ethernet/intel/igc/igc_main.c | 3 +++
>   drivers/net/ethernet/intel/igc/igc_regs.h | 5 ++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 74b2c590ed5d..38e46e9ba8bb 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -6171,6 +6171,9 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
>   	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
>   	u32 value = 0;
>   
> +	if (IGC_REMOVED(hw_addr))
> +		return ~value;
> +
>   	value = readl(&hw_addr[reg]);
>   
>   	/* reads should not return all F's */
> diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
> index e197a33d93a0..026c3b65fc37 100644
> --- a/drivers/net/ethernet/intel/igc/igc_regs.h
> +++ b/drivers/net/ethernet/intel/igc/igc_regs.h
> @@ -306,7 +306,8 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg);
>   #define wr32(reg, val) \
>   do { \
>   	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
> -	writel((val), &hw_addr[(reg)]); \
> +	if (!IGC_REMOVED(hw_addr)) \
> +		writel((val), &hw_addr[(reg)]); \
>   } while (0)
>   
>   #define rd32(reg) (igc_rd32(hw, reg))
> @@ -318,4 +319,6 @@ do { \
>   
>   #define array_rd32(reg, offset) (igc_rd32(hw, (reg) + ((offset) << 2)))
>   
> +#define IGC_REMOVED(h) unlikely(!(h))
> +
>   #endif
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
