Return-Path: <netdev+bounces-2165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8825970096F
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 15:49:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DF181C21209
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 13:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141A41E531;
	Fri, 12 May 2023 13:49:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001FF12B74
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 13:49:03 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F422412EA9;
	Fri, 12 May 2023 06:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683899340; x=1715435340;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qSjpEMsouAACNyZ4KRnTsOPir87vnzAuNPua7LPTxiQ=;
  b=eveRIO/b0N2165HHyvUuakyAlFXFB2GDKiBKifoorZBD7jHkGsij0OWt
   ZoVrNDq9D1eXPTYQFY730QxmpfYd6GOUCnLgjM6sbHkUAw9HlUE+mLKYp
   6R4Kyw/Jb+80mF2u2V5FceCGHHifolND/n2dQshsMYOLcWupxAFrdHuMs
   Lq4rHtmLbic7LJNu6pkRSpzI16k8Eq1s3dG/mkIhcwlB+2P9QCwXohHh/
   S2peGsdvuSD2oT1GjXOmQRc+ea0XPOqZ3YdOASpFjZwcT0HAg+z/xPmLw
   Q1s11+EoxqzJLYZTk6PIh9+YEc+MEpRzVyJyT8jqfl/mfOigrtPqXTa9U
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="348284641"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="348284641"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2023 06:49:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="812087707"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="812087707"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 12 May 2023 06:49:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 12 May 2023 06:48:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 12 May 2023 06:48:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 12 May 2023 06:48:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2W3tVVLZ0VXmoTyfQuONK0wY33DDN7ozITGJRWVWttNx/GZ6uw9/Ava6D7ZmvBXINOwaRXu8udlO7+F8Heg2W1jhaGbLoCrIMHWRYGzXMld7JZzHBs40U/68qNSMtSQYcpqtraM6XjdFeEuhkMnBud8XoWtQN8UG28MzCFaZMrLmSYLtQsZXA+cyDU4+WfipIQyqLjBiqq7rxqD/zNj2oA+ZjGIVOxIF8j5URhbo339wfC34mowqK59Q4t4v3GsIHlhxU6gloay+S7jvu6s4vMxdGMIQ1jeU79oSWwyZegkHHBuBshd8qhh+IEtzidlLr6hp0cK5SZqkiwbGS2Ixg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/W3KXTFtRA3zX/97q4Bdl8m8X4j1MHkT2+iwGqoBNU=;
 b=WICbOCdjV9ENJpXdVaXCcMCCpY+8M9SAmt1t+uKAbd5QQIPdXsXNgT0EKox87wsFaSRpkbLQAMc2XFwcpx8LVOcRYIUutZt0IBxuhQDLCbAXDUUqMYBTjkIFk1XjZmLt/kLTPpZR0Sg4poM3Q2fQUisgcb9pw1ftG1CkAf/s5DEL/rEG466+VbL/ZPD7cQi97Qy+q+7d0BTAvz1OU502RnwENKcDxiOr46HiqAJR5Rp7JyqRXowuNxwL5GFSHpVOnufZJGIICWb0RMwrtBE7vx+qrh2Oq7CIwuN35Z14HMBWcVBOn7WlLnWib9Nxsoca8Jd9whslnyG3DnCNPFHjSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Fri, 12 May
 2023 13:48:56 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::903f:e910:5bb8:a346]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::903f:e910:5bb8:a346%6]) with mapi id 15.20.6387.020; Fri, 12 May 2023
 13:48:56 +0000
Message-ID: <440cc14f-a257-e367-b699-77db7aa98e9b@intel.com>
Date: Fri, 12 May 2023 06:48:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH iwl-next v4 15/15] idpf: configure SRIOV and add other
 ndo_ops
To: Bagas Sanjaya <bagasdotme@gmail.com>, <intel-wired-lan@lists.osuosl.org>
CC: <shannon.nelson@amd.com>, <simon.horman@corigine.com>, <leon@kernel.org>,
	<decot@google.com>, <willemb@google.com>, Joshua Hay
	<joshua.a.hay@intel.com>, <jesse.brandeburg@intel.com>,
	<anthony.l.nguyen@intel.com>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
	<corbet@lwn.net>, <linux-doc@vger.kernel.org>, Alan Brady
	<alan.brady@intel.com>, Madhu Chittim <madhu.chittim@intel.com>, Phani Burra
	<phani.r.burra@intel.com>, Pavan Kumar Linga <pavan.kumar.linga@intel.com>
References: <20230508194326.482-1-emil.s.tantilov@intel.com>
 <20230508194326.482-16-emil.s.tantilov@intel.com>
 <ZFnQEXCm0upQ1LSo@debian.me>
Content-Language: en-US
From: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ZFnQEXCm0upQ1LSo@debian.me>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0131.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::16) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|DM4PR11MB5536:EE_
X-MS-Office365-Filtering-Correlation-Id: 814f9d7f-7295-4b48-00e6-08db52efa160
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgUwHFFvhgBI5fEMd0riwte53PzpP8JF9kEghOSzcq0OA6RIvwWKovA5zCPmiy0VkL1hMLl1mheYdQBhDHb3ADutJi+q1z6KRpiV14/SSqnDRIj1ItqA+Vjn2p70Dk6MZ3mgnZRBLopgKBPu9gxfDymrkFx5Afxsid90zpCYJlwbnzJP2nl7h/qPmDZ62w67HQi+TNIwoKjlgWb0b73xdaFXgOJuSBWHZFmCNvjpmopTibIdTRnoIyzVckhWC1Pvp9RcML3CXcm1n2uePpYjR8T6Lphv+eVKuqacC6Iw0Hu7QzXjviqaC/JbMQqEkQhgjw/LRYdmWER7JCUlWhZRQZXXXsl2UVlSp9L4D+obq5Lw0gFL0/VzkHXmmuOTBGDehWCtjq6PmXIptFjn9pqLY2O5xpThmWX5h9mmL9Jq9KsWbQhLlnBeuO8pTXP24RqSsexrOb2aCHqMoULS+lpc1YH/T8o/Q2pmzAMlVNjefQ/cAer1iZFu8PqlIJHuIi49d1oRkwnRDzPdCNjMKXGbhX715pk5zIKciN8MvrMJnUPD+Gm8ycHt6A5IYzPxJXbHwK4XIuefDz5ZoPxJ7OC9+lmNiA0+xJ8JIrqqB5ir7VQ2xJk8GbSyVovV8/1Q8eCOqqD4d1dqUx1a+jLO9Pj4KtwIefI/KA1SMhqrd9DYqMJEKiuReioXxR52joT2urDE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(366004)(376002)(136003)(451199021)(7416002)(8676002)(86362001)(2616005)(5660300002)(8936002)(36756003)(83380400001)(6666004)(6486002)(66946007)(54906003)(107886003)(478600001)(316002)(41300700001)(53546011)(4326008)(66476007)(6506007)(66556008)(26005)(30864003)(2906002)(186003)(6512007)(82960400001)(38100700002)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akRKMkRvOGxTSW5NdWpqNzFLTHUvR3pDbDJkUzllQXd5SXE0WEliSWRRa08x?=
 =?utf-8?B?Y0hrTXZpUWpFeEc5UHQ1bU5wZlpTRXhyOWozTW52dTBUUGMxK3JVazVKSG8w?=
 =?utf-8?B?M2E1em5PZEhtRVIrcEhSRjR4ZXdtVWdZSWg2N0lIRnVkc2pxR01URTZVeVhD?=
 =?utf-8?B?WTRJcHlIazJ6cW1HVHp3ejBJeW9CcG1OSmhoeFNuN25URzQyRklDZHB3ZVR3?=
 =?utf-8?B?WXlxTmhLeSt5UjM1MUVLUWxCMWpMWkxsNzJrOVpNM1A1UDFCRUU2R0tKajNP?=
 =?utf-8?B?MFNvTnowaGpwOTdrd29TYWoxNDBOa29HVCtHUGZlWmxaV0Z5MGVFdXpmRFBV?=
 =?utf-8?B?elBKdGN2QlZuVjRTWml0bWNOQTBVdityUHg1Z2lSbmptYWd1dGw3ZkxFWlUw?=
 =?utf-8?B?UUpFZlVCaFZrTzV0SHdKV0dnUkxTWFliQzVQZE45VStacElicWRWTUVMNHR1?=
 =?utf-8?B?MGh4cGxFb0sxeTJyWEhidnFIZTZLY3FDT1dUQjdCSDl1K0ErejUwOTFLWTdp?=
 =?utf-8?B?b3I0SmQxbHJxR245MGw4UHltY3BneC9PelAyRTB5Qm9pVzcrTmpGUHpWSVpQ?=
 =?utf-8?B?V3J4R2QzTjdleG1OS1h4ZjJmK3V1WjhVZkpwQ1pMUk53ZzU0bUpxYStKekYz?=
 =?utf-8?B?NnhnVUFaYkN1Z3MrK3FvQlkzQVNhRGVuR3F6SXF4UmVxZHpJUjFXaWN5a25J?=
 =?utf-8?B?TnJhNDFJeEs1TTU5RUpJZjhiWnA5SHptZWtmWVptVS8xQkhRcFc5WUZzUmZm?=
 =?utf-8?B?aTh1ajBHTDQvamRjdGhzUnk4OHRvVmpKNi92SlhQTUNtUlFOaDRHZmdsR0Fm?=
 =?utf-8?B?TGtqU2YyMEdLSE5vUnYrS1JXK1IyMVRVeWhlRys5dUU0ZFVkdHgyMmhQdmVY?=
 =?utf-8?B?Q2M4OHRYUDA5ZkEwekNZS2FRdk92d2d5YTRFaEJYUnlxN05UcnJnVjUvcDI1?=
 =?utf-8?B?NGRDRXhXRHVIa2x1b0VNbWIvY1pTdndWQUI2MFJ1UHdIL0hudVQydU1HQ2M0?=
 =?utf-8?B?ZHJXc1BHY0JQb3hBTXJYa0dTSG9TMllPcm5BbFVPaVQ2c3A5SHJhanYvQVkw?=
 =?utf-8?B?bG5pOUZUUm9yMlRkNjF2NFV2cVNES0x2a250YVNNR1BBTFhkcHBGYlQ0TTdZ?=
 =?utf-8?B?RnJuKzJsUzBoQThqbkRjV1NDcWk5R052a0REQ1lidUhFTkJkTEFQT0FZWDBw?=
 =?utf-8?B?MTJxMURlbUJDU2xwZGdJRE85WWN3WTNoR2hXVW5KdStyYWh3S1E4SEYvSCtj?=
 =?utf-8?B?UlhyRFJsRzRTR0c3OTFnMkNxdHZETmFIenk2UUdmRTJWWWxweVNIVGFYcVZO?=
 =?utf-8?B?bi9ZSjhBNXlIcHI4bFUySlRKL2paK3IvbWJUZFhZWEJrOVBWZUw4YjA5RTh5?=
 =?utf-8?B?dzZHcXFieWVTTFhxRXVjS0ZidW1yYXpzdWRCY0tEeDIzQ3BTQ1NVamNjdjI5?=
 =?utf-8?B?bVBNdHQ4RVNQM2NjOHBiQm4wQnZPbEp5bVNtZjdxVTdwL2VVamlYbG1LZGZn?=
 =?utf-8?B?ajVhL0U3ZE9USTFTSlJXd0ZSVUxuZWFSYjNnWjU3aUp4UGVDd3R4alRNcmxY?=
 =?utf-8?B?VGswZzJ5YmlCQkRucE4xR2tmRXljK0Z2M3BYazVYMzZLbHNKQXlWdUxRRll5?=
 =?utf-8?B?ZEFJVnFUTGljdWhNZzNNZ1BXaXR1aWhlUlJ3bE1zTWQwNTlUTVVDaUJUU09l?=
 =?utf-8?B?TlNvZUJmQkFiUEJjd2hTL1p1K09mbjhzSGk4MDExUW5XMHdVYmlCT3kwamJM?=
 =?utf-8?B?b3ZyQmwvTUNiTldDK2RLTXhxQUtlRkRZMy9PUGQ2dGR6ajRwTVBEVUZhT290?=
 =?utf-8?B?elYzSW03cmdZQ2FwMFI1TFFHc1N5eUpycjVhODZ1ejBlYmgvcDg4MnBpZS9F?=
 =?utf-8?B?THAvQWJEVDlpZEhUMjFqWVNTdWh6dnVVU2NmQjJtdzZ6ekZXKzAydEZheXZX?=
 =?utf-8?B?OXc3UUZOL2JKSjE2RTFPK3M1VUZ2M3pRYXNyNUI2NmVmMk1oTDB0Um5WTnRG?=
 =?utf-8?B?dGxVcGxRSndtWFhHbkh0TzA1OTJqcmMydWphem1zSVhYSDFMYUVoS2pHaTdW?=
 =?utf-8?B?WitlV0hMbHlwNUhOd0s0NnhtUGk3RUxwL2lYZVRvNFZDaGpGKzVNY1RrK1hH?=
 =?utf-8?B?SlhFZy9MTXZjUDEzQndGdDFodHlEUkZWek5MeTZ3UWV4VjM5WFZyd2pyKzJp?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 814f9d7f-7295-4b48-00e6-08db52efa160
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2023 13:48:56.3023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pQlW5A3z9nM1Cv3Ggq+yLi5KcFU9XYbxoiv7b/mWfPhc2jqXLt7hngW7G1oNlubElHc1dKdKqLiQPNG/s3SmR/6Uxl3W7gnkZMa3Qflc/34=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/8/2023 9:46 PM, Bagas Sanjaya wrote:
> On Mon, May 08, 2023 at 12:43:26PM -0700, Emil Tantilov wrote:
>> From: Joshua Hay <joshua.a.hay@intel.com>
>>
>> Add PCI callback to configure SRIOV and add the necessary support
>> to initialize the requested number of VFs by sending the virtchnl
>> message to the device Control Plane.
>>
>> Add other ndo ops supported by the driver such as features_check,
>> set_rx_mode, validate_addr, set_mac_address, change_mtu, get_stats64,
>> set_features, and tx_timeout. Initialize the statistics task which
>>   requests the queue related statistics to the CP. Add loopback
>> and promiscuous mode support and the respective virtchnl messages.
>>
>> Finally, add documentation and build support for the driver.
>>
>> Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
>> Co-developed-by: Alan Brady <alan.brady@intel.com>
>> Signed-off-by: Alan Brady <alan.brady@intel.com>
>> Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
>> Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
>> Co-developed-by: Phani Burra <phani.r.burra@intel.com>
>> Signed-off-by: Phani Burra <phani.r.burra@intel.com>
>> Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
>> Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
>> Reviewed-by: Willem de Bruijn <willemb@google.com>
>> ---
>>   .../device_drivers/ethernet/intel/idpf.rst    | 162 +++++
>>   drivers/net/ethernet/intel/Kconfig            |  10 +
>>   drivers/net/ethernet/intel/Makefile           |   1 +
>>   drivers/net/ethernet/intel/idpf/idpf.h        |  40 ++
>>   drivers/net/ethernet/intel/idpf/idpf_lib.c    | 642 +++++++++++++++++-
>>   drivers/net/ethernet/intel/idpf/idpf_main.c   |  17 +
>>   drivers/net/ethernet/intel/idpf/idpf_txrx.c   |  26 +
>>   drivers/net/ethernet/intel/idpf/idpf_txrx.h   |   2 +
>>   .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 193 ++++++
> 
> You forget to add toctree entry for the doc:
> 
> ---- >8 ----
> diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
> index 417ca514a4d057..5a7e377ae2b7f5 100644
> --- a/Documentation/networking/device_drivers/ethernet/index.rst
> +++ b/Documentation/networking/device_drivers/ethernet/index.rst
> @@ -30,6 +30,7 @@ Contents:
>      intel/e1000
>      intel/e1000e
>      intel/fm10k
> +   intel/idpf
>      intel/igb
>      intel/igbvf
>      intel/ixgbe
> 
>> +Contents
>> +========
>> +
>> +- Overview
>> +- Identifying Your Adapter
>> +- Additional Features & Configurations
>> +- Performance Optimization
> 
> Automatically generate table of contents instead:
> 
> ---- >8 ----
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> index ae5e6430d0e636..6f7c8e15fa20df 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> @@ -7,14 +7,7 @@ idpf Linux* Base Driver for the Intel(R) Infrastructure Data Path Function
>   Intel idpf Linux driver.
>   Copyright(C) 2023 Intel Corporation.
>   
> -Contents
> -========
> -
> -- Overview
> -- Identifying Your Adapter
> -- Additional Features & Configurations
> -- Performance Optimization
> -
> +.. contents::
>   
>   The idpf driver serves as both the Physical Function (PF) and Virtual Function
>   (VF) driver for the Intel(R) Infrastructure Data Path Function.
> 
>> +Identifying Your Adapter
>> +========================
>> +For information on how to identify your adapter, and for the latest Intel
>> +network drivers, refer to the Intel Support website:
>> +http://www.intel.com/support
> 
> What support article(s) do you mean on identifying the adapter?

This is the Intel support site, where you can search for info. I don't 
know if there is a specific page, or if such a page would persist over 
time. This paragraph is used in the documentation for all other Intel 
drivers as a starting point.

> 
>> +
>> +
>> +Additional Features and Configurations
>> +======================================
>> +
>> +ethtool
>> +-------
>> +The driver utilizes the ethtool interface for driver configuration and
>> +diagnostics, as well as displaying statistical information. The latest ethtool
>> +version is required for this functionality. Download it at:
>> +https://kernel.org/pub/software/network/ethtool/
> 
> "... If you don't have one yet, you can obtain it at ..."
> 
Thanks I will correct it.

>> +
>> +
>> +Viewing Link Messages
>> +---------------------
>> +Link messages will not be displayed to the console if the distribution is
>> +restricting system messages. In order to see network driver link messages on
>> +your console, set dmesg to eight by entering the following:
>> +
>> +# dmesg -n 8
>> +
>> +NOTE: This setting is not saved across reboots.
> 
> How can I permanently save above dmesg setting?
> 
This note following the command is generic and exists in all other Intel 
driver docs. I think it is beyond the scope of this document to give 
advice on setting up the environment. I can remove it if is deemed to be 
unnecessary.

>> +
>> +
>> +Jumbo Frames
>> +------------
>> +Jumbo Frames support is enabled by changing the Maximum Transmission Unit (MTU)
>> +to a value larger than the default value of 1500.
>> +
>> +Use the ip command to increase the MTU size. For example, enter the following
>> +where <ethX> is the interface number:
>> +
>> +# ip link set mtu 9000 dev <ethX>
>> +# ip link set up dev <ethX>
> 
> For command line snippets, use literal code blocks:
> 
> ---- >8 ----
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> index 0a2982fb6f0045..30148d8cf34b14 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> @@ -48,9 +48,9 @@ Viewing Link Messages
>   ---------------------
>   Link messages will not be displayed to the console if the distribution is
>   restricting system messages. In order to see network driver link messages on
> -your console, set dmesg to eight by entering the following:
> +your console, set dmesg to eight by entering the following::
>   
> -# dmesg -n 8
> +    # dmesg -n 8
>   
>   NOTE: This setting is not saved across reboots.
>   
> @@ -61,10 +61,10 @@ Jumbo Frames support is enabled by changing the Maximum Transmission Unit (MTU)
>   to a value larger than the default value of 1500.
>   
>   Use the ip command to increase the MTU size. For example, enter the following
> -where <ethX> is the interface number:
> +where <ethX> is the interface number::
>   
> -# ip link set mtu 9000 dev <ethX>
> -# ip link set up dev <ethX>
> +    # ip link set mtu 9000 dev <ethX>
> +    # ip link set up dev <ethX>
>   
>   NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds to the
>   maximum jumbo frame size of 9728 bytes.
> @@ -92,40 +92,40 @@ is tuned for general workloads. The user can customize the interrupt rate
>   control for specific workloads, via ethtool, adjusting the number of
>   microseconds between interrupts.
>   
> -To set the interrupt rate manually, you must disable adaptive mode:
> +To set the interrupt rate manually, you must disable adaptive mode::
>   
> -# ethtool -C <ethX> adaptive-rx off adaptive-tx off
> +    # ethtool -C <ethX> adaptive-rx off adaptive-tx off
>   
>   For lower CPU utilization:
>    - Disable adaptive ITR and lower Rx and Tx interrupts. The examples below
>      affect every queue of the specified interface.
>   
>    - Setting rx-usecs and tx-usecs to 80 will limit interrupts to about
> -   12,500 interrupts per second per queue:
> +   12,500 interrupts per second per queue::
>   
> -   # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 80
> -   tx-usecs 80
> +       # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 80
> +       tx-usecs 80
>   
>   For reduced latency:
>    - Disable adaptive ITR and ITR by setting rx-usecs and tx-usecs to 0
> -   using ethtool:
> +   using ethtool::
>   
> -   # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 0
> -   tx-usecs 0
> +       # ethtool -C <ethX> adaptive-rx off adaptive-tx off rx-usecs 0
> +       tx-usecs 0
>   
>   Per-queue interrupt rate settings:
>    - The following examples are for queues 1 and 3, but you can adjust other
>      queues.
>   
>    - To disable Rx adaptive ITR and set static Rx ITR to 10 microseconds or
> -   about 100,000 interrupts/second, for queues 1 and 3:
> +   about 100,000 interrupts/second, for queues 1 and 3::
>   
> -   # ethtool --per-queue <ethX> queue_mask 0xa --coalesce adaptive-rx off
> -   rx-usecs 10
> +       # ethtool --per-queue <ethX> queue_mask 0xa --coalesce adaptive-rx off
> +       rx-usecs 10
>   
> - - To show the current coalesce settings for queues 1 and 3:
> + - To show the current coalesce settings for queues 1 and 3::
>   
> -   # ethtool --per-queue <ethX> queue_mask 0xa --show-coalesce
> +       # ethtool --per-queue <ethX> queue_mask 0xa --show-coalesce
>   
>   
>   
> @@ -139,9 +139,9 @@ helpful to optimize performance in VMs.
>      device's local_cpulist: /sys/class/net/<ethX>/device/local_cpulist.
>   
>    - Configure as many Rx/Tx queues in the VM as available. (See the idpf driver
> -   documentation for the number of queues supported.) For example:
> +   documentation for the number of queues supported.) For example::
>   
> -   # ethtool -L <virt_interface> rx <max> tx <max>
> +       # ethtool -L <virt_interface> rx <max> tx <max>
>   
>   
>   Support
> 
>> +
>> +NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds to the
>> +maximum jumbo frame size of 9728 bytes.
>> +
>> +NOTE: This driver will attempt to use multiple page sized buffers to receive
>> +each jumbo packet. This should help to avoid buffer starvation issues when
>> +allocating receive packets.
>> +
>> +NOTE: Packet loss may have a greater impact on throughput when you use jumbo
>> +frames. If you observe a drop in performance after enabling jumbo frames,
>> +enabling flow control may mitigate the issue.
> 
> Sphinx has admonition directive facility to style above notes:
> 
> ---- >8 ----
> diff --git a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> index 30148d8cf34b14..ae5e6430d0e636 100644
> --- a/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> +++ b/Documentation/networking/device_drivers/ethernet/intel/idpf.rst
> @@ -52,7 +52,8 @@ your console, set dmesg to eight by entering the following::
>   
>       # dmesg -n 8
>   
> -NOTE: This setting is not saved across reboots.
> +.. note::
> +   This setting is not saved across reboots.
>   
>   
>   Jumbo Frames
> @@ -66,16 +67,19 @@ where <ethX> is the interface number::
>       # ip link set mtu 9000 dev <ethX>
>       # ip link set up dev <ethX>
>   
> -NOTE: The maximum MTU setting for jumbo frames is 9706. This corresponds to the
> -maximum jumbo frame size of 9728 bytes.
> +.. note::
> +   The maximum MTU setting for jumbo frames is 9706. This corresponds to the
> +   maximum jumbo frame size of 9728 bytes.
>   
> -NOTE: This driver will attempt to use multiple page sized buffers to receive
> -each jumbo packet. This should help to avoid buffer starvation issues when
> -allocating receive packets.
> +.. note::
> +   This driver will attempt to use multiple page sized buffers to receive
> +   each jumbo packet. This should help to avoid buffer starvation issues when
> +   allocating receive packets.
>   
> -NOTE: Packet loss may have a greater impact on throughput when you use jumbo
> -frames. If you observe a drop in performance after enabling jumbo frames,
> -enabling flow control may mitigate the issue.
> +.. note::
> +   Packet loss may have a greater impact on throughput when you use jumbo
> +   frames. If you observe a drop in performance after enabling jumbo frames,
> +   enabling flow control may mitigate the issue.
>   
>   
>   Performance Optimization
> 
> 
> Thanks.
> 

Thanks for your feedback and the patches! I will include them in the 
next revision of the series.

Emil

