Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B33E366E746
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 20:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233949AbjAQTwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 14:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjAQTtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 14:49:15 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF62A55291;
        Tue, 17 Jan 2023 10:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673981206; x=1705517206;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ls3utqdePmedXQsNwy7CWvLBf9r8A1itLeZDOm1uJ0M=;
  b=eP43qD9mlMu6Q6zXb5qngDXW06XpgUTTK4TBnXbhbUQo4VTkQaggclWv
   UT37BTJRdkCWl91wYstlDlTMrHL8J1FgxCAfYeuATbb7dQiO+TsTG0wdt
   7BchnhjsSfpyhPDd00NVD8E+lpsM6vCTai2FOtScs0Wbjhocd3e3aOkGI
   706UazAnqFLncHW7PiJH0jrWPjr9oYiSiDLRPskZUhTMcwVkDKjGNiv4B
   eL8V+byi88de1gxvvGuBFa7agT26fF2IlcZv7YwQXrGVlIo6pgjLm+/JN
   HafUemQdHc8bE6d9mbljqbKKyRPOtOQjYqhj3c/5cUmzbEKvAsa29ZsDR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="304466552"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="304466552"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 10:46:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="783344642"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="783344642"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 17 Jan 2023 10:46:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 10:46:26 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 10:46:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 10:46:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 17 Jan 2023 10:46:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MoaDdneTyYr3QQEC37s01lCZCSOaQnPidFL/V9IB0j6u54R6SQNmYzniQosG5uvLkbcw4vmLGPWgysrmElgaqRli3+iVxtBwUvMBC66HvCc6CFb1fy+rvbSmkbdJhjvDNU+lpJr4z+OSfO3r9kn5F/oTY0t/nIPDSrGd/Et+LwSTc3xaCbU2EnReCPJcnNkFVe7TA920wGjGTWOboIE+RjVFJMaASpLLhoptXNCxzm7SaaNWn5/QbvT7NtzgqTuEO0NIZJ8vw+a8E8Wxz3/XWZWCyBCNS4P2HWMm1rNlx3LfIUWL9Ru2s7mx1lUo3vzi3LOGulYdn9B5tQm6BQjQ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrcAuQLTpMv75antCuvy06Atgq+8QYBVt/u3VfhqO8w=;
 b=XGCl8/ha52zKThWylnTGkbEpezssQY8c1yfc0oQdg7oKqQA/o3I813YX3f8aHawB3zefPjzp49B6Ytk78peOhVb2ntYtQtLqc+axEt2V5iS7V4HqIgU2H0DEfWthGF9GB2oHsa97oSnfI9l9g102LBYdSjyMVMXxVvHq1Uy1lC9HfxWFqpobyNkwT4c0uO15OscareLybS0K6NAlIg+4l27Vf+ONafvfn7hIFvGhy6XcYJMaMTBF9C05o2T8nNa4kUQFOXgZgu7TZ1h963GOKs7o/vE5coV5xfdUzk9mRcV0ZEOhv2RhcCWWV2/Q2H8UNqLxkTYyro4fF5VQGVYcQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH7PR11MB6521.namprd11.prod.outlook.com (2603:10b6:510:213::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 17 Jan
 2023 18:46:23 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 18:46:22 +0000
Message-ID: <2bdeb975-6d45-67bb-3017-f19df62fe7af@intel.com>
Date:   Tue, 17 Jan 2023 10:46:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [Intel-wired-lan] [PATCH] ice/ptp: fix the PTP worker retrying
 indefinitely if the link went down
Content-Language: en-US
To:     Daniel Vacek <neelx@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        Siddaraju <siddaraju.dh@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>
CC:     <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-kernel@vger.kernel.org>
References: <20230117181533.2350335-1-neelx@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230117181533.2350335-1-neelx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH7PR11MB6521:EE_
X-MS-Office365-Filtering-Correlation-Id: b1798855-4c74-47e2-abf4-08daf8bb2143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: noZ0b4wrnQkJdikuWF9mykQQD6WL/rOssr4kcj286WFggecteShfB5Qd2jKIaqSgCRJfme3NSdud1FOHRX3OZvy+bQPAgQyq3eqmy/4Oa2DjR5bbwTzKvvNASeHjZbPKhVS74TgsW6L4lPz6cm6Ar0aj0byEkQrkYezt1+aEvLWy1RIH7kKxDYtTV8aotV3g4BpZ92qNg00eyOF1chgsDSzgEmoNTHo1RiTdcrTzVtFIddCUyI16+1zzOLaat83J6PgyJNqDV/YMiAolu68ldJglBk7ah5qIVpLz7VJEVlLRDedfU/KXSrpi05CjE3oQ/L+Qy1DnqDRoTSg6oFhXZg8+4aJOiAp0vJVRjDCIpywWYbY5qxto5/JokIDTyT7uFeFRFkZrr2X7mEg71MRdieOilHdkN1JWNxOIHhBt+84IKrQPaHpZnUQtdct2OfbTlnIDo77n2nxLfr8uwWBm6rYpF46Tf+lVjMJlGO5KI4bervOYA4U0KzUx7M/PkAsc6D3QoES07984PsuuwLBmGqaAwtXQxDJ+5GKaW4E6dSCxajo+szQOK4GAl+4/RavZxyYLPuc5TmCCip7u7dkboItdYvukgQHknGW+iq2yrAaxasjURxpQ/xfsTT4gsP43PyaN3rLCvJ6HdCqgQTQD4tt+BKIySOMl+MKN47gk+sqbe6DQ3cnNddj7p454RRXrUISDvi97Wd9t620d8njBbjrrGZkNHU7mXIx2UPNVuJS3/4xdnTTSM7GViJVCluWO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(39860400002)(346002)(376002)(451199015)(86362001)(316002)(26005)(6512007)(186003)(6486002)(5660300002)(478600001)(2616005)(8676002)(41300700001)(31696002)(66476007)(4326008)(66946007)(66556008)(110136005)(6636002)(36756003)(8936002)(83380400001)(31686004)(53546011)(6506007)(38100700002)(82960400001)(2906002)(921005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzhyZklwdlB2Ym1YTzdoVS9jbCtJa3N5WG81SmVjWkZUcnY1Y1RURWtPT1dU?=
 =?utf-8?B?VWZ0SGZKaU9PQ29XKzI2TDV0dGREakJEZVRZYTJHUEpNbnJUWDBEdStKYzZE?=
 =?utf-8?B?ZGxMcStvSmJjUUF3SHNtamxUMEtPQnpkeWU4dnQySVpwNVhEeEVxQWZoM1Ew?=
 =?utf-8?B?Q0tHc2JlZlNWMWVuTWlhTTdKM2dpcWJLaXZtbDZjc24xZDNJdXhEM3V1M1A3?=
 =?utf-8?B?R1VNZmdYWDVsaXJudFNqVHVBdWFkdFJYQzFhS25HQmdDcnQ3ZmhTV1pmVWx3?=
 =?utf-8?B?K1J3cFRMSFpEMDNDTmR4SjhyU21VM2pCT0pMemZFQ2U0UjJ2NmZiczJnZDla?=
 =?utf-8?B?MG1POUVOcm4raWRScnJvay9jU1ZLUDlLOCtpSjNBUTNGd0dOblFkZ0ZVVEdS?=
 =?utf-8?B?RXgzU0dVSXAwL2xOZDhxQUtnT3gwY041V3hJMGMxL0pOTWhlQS80TFFna3kz?=
 =?utf-8?B?cUdQbnZmTFF1aXljMHNjM2hoM25EMnB1ZDdFNkVWMDc5TTV0UHBtS0NkdmVS?=
 =?utf-8?B?VmQyNWh4THBCQm1pYXlFV05uRVZGNTV4RXp0d0FNZm5VWFg0a3h2cUxiV2h0?=
 =?utf-8?B?RTNIK2J2S1RpVVVnSTdVeWVrR1lob0ZhT0VSM3kvblRJdUkxSldFcUViOGhq?=
 =?utf-8?B?cWl5cW56UVBGK0hiZGxHL2hiWDFtRXVSYnAwVkRvNVZZVGRDNFhIRWRXZUZl?=
 =?utf-8?B?R0NWUU5SZkNqQlM3Q3dBK1BMV05YaHFGMnljYmhUTGJMYkZUZ1Q0OTlQK1Vn?=
 =?utf-8?B?QlZkYUIrQTNyTzNXZlRYUWhHK0Z1WU9ON2ZXSFRyZW5zTmZxSmJMV1pFOGtC?=
 =?utf-8?B?OWdnenF4VnBJdFpCNS9iNUFQNlo4VysrSTBRTlc0Yzg2bjQ2R1RTdHRhU0dJ?=
 =?utf-8?B?RWtyaVo2M25hMEN1OU81QnFZZVhSQmJyOTFDNDlvRk5mdWh6T3ErcU5scitU?=
 =?utf-8?B?cHFsWlYrZU53b2xkbTJTb2M1a3RWdlNJQmQ5cXRqeURqNXpSTlBYNXJHSTlk?=
 =?utf-8?B?MklWQ0hjb3RXOWJIZmpxV0dhem5COExNWmVyN2JDZ25NZ0JzMm5MMjNmcGhu?=
 =?utf-8?B?S0hwdThzdVlnKzRZUFVSMzNjUS9MTmtBaitFOUNRTG5jdGNHMmZwNGlCK09w?=
 =?utf-8?B?b3d2OGFmUHhRYkpSYW4xa0lJOWMvcGo3cE5nYzRlWkQxTmpVdHVxWjFwOG9S?=
 =?utf-8?B?WGF2Z2gza0VKRTJTYlAxbGVjaVVseG9VSzNxdW9acXlSNTBHbEtIZENidXhh?=
 =?utf-8?B?ZmlMdXU2K29ZbU16QlJMdDBCeFRTRE41ZzltT3l6WHhuZ0w4YkNnQ1FzcUFN?=
 =?utf-8?B?SS9QVVNYYXFKRHptbGNnWmM0bFRudVpJVGhUcUZ3TnpLUUM0MmZOb05SbUhx?=
 =?utf-8?B?dHM4bTNXMmR2MkhGUXdNZHdPUGpMRE9QQlYveGRjUEozMHpJVXlRdTJ3SXY2?=
 =?utf-8?B?K0JZbEJYWjZ0bWs4bGpaQmwrVU0vMmZEbnlhSVpGMlQ4SlFBWG1wRHZ1TzUx?=
 =?utf-8?B?S2FSand4RHZad2U3Um9jaVk2VzFOMFpyUmM4SnVZSGtrdkppTm5vcDFEa1FP?=
 =?utf-8?B?b01xaEVzWWo4alZ3L1pwcW1oVEcyUklOMDRzcWlWa1RLY0xiMUt4M21PMHpl?=
 =?utf-8?B?MGRQUnBsS0RKMVpBZmFJMnUxSUkvbFlaK0NiNC9mbG1rWW91SDhuckoyZHYx?=
 =?utf-8?B?clVJVGFEWFJMencxNCtSTWEreFlzYVFzWGNZc2piaHlUeWpyK0JTa253Yjlz?=
 =?utf-8?B?akRZQngzb2V6RGIvc20rYkoxU21lM21hTkxOWkk2ZmFHRGdHT3J1TkV1bHI2?=
 =?utf-8?B?SklnS1Vwb1NrditvZGtaOVdmZ0tRc3UzNTNLVGJFeFpHUm5SalJ0dWhqcDMz?=
 =?utf-8?B?WXNBU0J4cHh5VnZ5ZkdmTTZYOFo0dks0ak14UWR0NnhOaWRiYkdBeFBkLy9v?=
 =?utf-8?B?dVNhQmdqc2szS3hpVlZXN1RkNllFMkdtOGhFbmNwTXVGeCs1MDlqT1hYRDM3?=
 =?utf-8?B?TW02VlZ2MGJFcHdrZlhIZHVUYXFXVVZjeTBYQ1NpT2F1VmNIZ0V6SnQ4dUE0?=
 =?utf-8?B?QW1MV0xwSTlEVlpMK3c0UDNscHBkN0dPRUJ3eE5uMjNZNkFHNTFpMW96SnNS?=
 =?utf-8?B?UTUwV0hXMCt1b3VxS1U5UUliQnV6TTczSkxYalRSNDFHSnlGTkl0VmFDZ2x2?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b1798855-4c74-47e2-abf4-08daf8bb2143
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 18:46:22.8564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tTD0n+8NwSYa6eyOd7SAw3IgkFBXgo0aIKtfpECnLO52xvfuciyVpMPmHHFFMZKp0dhTSzu9h0WoTrAvQOlaAQsHCd9kjdoJmUpoSq7D57E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6521
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/2023 10:15 AM, Daniel Vacek wrote:
> When the link goes down the ice_ptp_tx_tstamp_work() may loop forever trying
> to process the packets. In this case it makes sense to just drop them.
> 

Hi,

Do you have some more details on what situation caused this state? Or is
this just based on code review?

It won't loop forever because if link is down for more than 2 seconds
we'll discard the old timestamps which we assume are not going to arrive.

The trouble is that if a timestamp *does* arrive late, we need to ensure
that we never assign the captured time to the wrong packet, and that for
E822 devices we always read the correct number of timestamps (otherwise
we can get the logic for timestamp interrupt generation broken).

Consider for example this flow for e810:

1) a tx packet with a timestamp request is scheduled to hw
2) the packet begins being transmitted
3) link goes down
4) interrupt triggers, ice_ptp_tx_tstamp is run
5) link is down, so we skip reading this timestamp. Since we don't read
the timestamp, we just discard the skb and we don't update the cached tx
timestamp value
6) link goes up
7) 2 tx packets with a timestamp request are sent and one of them is on
the same index as the packet in (1)
8) the other tx packet completes and we get an interrupt
9) the loop reads both timestamps. Since the tx packet in slot (1)
doesn't match its cached value it looks "new" so the function reports
the old timestamp to the wrong packet.

Consider this flow for e822:

1) 2 tx packets with a timestamp request are scheduled to hw
2) the packets begin being transmitted
3) link goes down
4) an interrupt for the Tx timestamp is triggered, but we don't read the
timestamps because we have link down and we skipped the ts_read.
5) the internal e822 hardware counter is not decremented due to no reads
6) no more timestamp interrupts will be triggered by hardware until we
read the appropriate number of timestamps

I am not sure if link going up will properly reset and re-initialize the
Tx timestamp block but I suspect it does not. @Karol, @Siddaraju,
@Michal, do you recall more details on this?

I understand the desire to avoid polling when unnecessary, but I am
worried because the hardware and firmware interactions here are pretty
complex and its easy to get this wrong. (see: all of the previous
patches and bug fixes we've been working on... we got this wrong a LOT
already...)

Without a more concrete explanation of what this fixes I'm worried about
this change :(

At a minimum I think I would only set drop_ts but not not goto skip_ts_read.

That way if we happen to have a ready timestamp (for E822) we'll still
read it and avoid the miscounting from not reading a completed timestamp.

This also ensures that on e810 the cached timestamp value is updated and
that we avoid the other situation.

I'd still prefer if you have a bug report or more details on the failure
case. I believe even if we poll it should be no more than 2 seconds for
an old timestamp that never got sent to be discarded.

> Signed-off-by: Daniel Vacek <neelx@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_ptp.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
> index d63161d73eb16..c313177ba6676 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ptp.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
> @@ -680,6 +680,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>  	struct ice_pf *pf;
>  	struct ice_hw *hw;
>  	u64 tstamp_ready;
> +	bool link_up;
>  	int err;
>  	u8 idx;
>  
> @@ -695,6 +696,8 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>  	if (err)
>  		return false;
>  
> +	link_up = hw->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP;
> +
>  	for_each_set_bit(idx, tx->in_use, tx->len) {
>  		struct skb_shared_hwtstamps shhwtstamps = {};
>  		u8 phy_idx = idx + tx->offset;
> @@ -702,6 +705,12 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
>  		bool drop_ts = false;
>  		struct sk_buff *skb;
>  
> +		/* Drop packets if the link went down */
> +		if (!link_up) {
> +			drop_ts = true;
> +			goto skip_ts_read;
> +		}
> +
>  		/* Drop packets which have waited for more than 2 seconds */
>  		if (time_is_before_jiffies(tx->tstamps[idx].start + 2 * HZ)) {
>  			drop_ts = true;
