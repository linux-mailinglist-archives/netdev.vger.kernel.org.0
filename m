Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405283F20A7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 21:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhHSTdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 15:33:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:63342 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230504AbhHSTdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 15:33:18 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="213508624"
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="213508624"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 12:32:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,335,1620716400"; 
   d="scan'208";a="641828785"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 19 Aug 2021 12:32:41 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 12:32:41 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 12:32:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 12:32:40 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 12:32:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBnGks4FT4Hl4kux+Xa7I4jLNzzp6s5b6IXknb8xpHRvNRN22gZ7FDEzI4gvkuf30ZDtNr85JV5Hw5Imlcq3ImziTaFuA6s5ZyuPdNRQPUlDCXmzSAE3KW2BU8Agwv+uzlbz83PVR3LAGeQlmGfBqOKWAP++HCBVBvfqgiRBRNNQmpSSL8y/bZ1G96DAtLlZganhUW7W4JZPulUuEQr4HRHw3XC2yuiC8/rxL5F6JJU0rsOIKPed5c83luy9bRMED7gc4nVJlZ1VIh9UsB5J1c53085Ahq+WShWVYa3Xq48B0NoLSJ4O7EcwC7giiDM/ETo0aO4tmim/QsXiMBvtag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69GTT3Bz+joQUAkn9D14+2cPvPkvPm8phKR+dL5RQt8=;
 b=gm206Oq26RZQk21B4KTZn7uPcN4B6S8w1tkaU6GGo/OzDHejudb3UcmLS86F3PGhOeVsK+cNZ64o1GKIrrDsNdS5d94saPTq8YlXSPYr/Y4DB61NBsXWH+0EinmhCOOz8DUNLmOf3WwwlJRA5H4UiNwYhG+LEPgAPHIqoCHgDykwan7MP8BP1edltjcllO2WrL6kQx69uNpMQ+v1JWnbtCd0qrXt+EjEquXvF/XmuZ+jmmSIClmotYZzoLuZNa8NibthKLgCDc10A/4J0ZAGl+sGrduwgHglGqkNXg7TYHz9MBKyWNViNdI+k1teXnlvTicVS+dBwh/X+TLCms/cyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69GTT3Bz+joQUAkn9D14+2cPvPkvPm8phKR+dL5RQt8=;
 b=Abb0tS7qQaTSMMnKVPV2Zp0XcOvoBw1IF8ATM6lZaPw1p119CNH04wJs9B7Di5qcjqb4OKK+yWbT+xRUJre9x3I4/PxrNaMzWlH0TOTDqu5ITl1SjkrqRv6DMvCo9xSF/gwHEypKOKwe3ApQLPtSV/DJ3j10d9JwcQG+MzjnRaE=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:95::6)
 by MWHPR1101MB2365.namprd11.prod.outlook.com (2603:10b6:300:74::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 19:32:39 +0000
Received: from CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::1968:cbde:518e:2acb]) by CO1PR11MB5140.namprd11.prod.outlook.com
 ([fe80::1968:cbde:518e:2acb%9]) with mapi id 15.20.4415.025; Thu, 19 Aug 2021
 19:32:39 +0000
Subject: Re: [RFC bpf-next 5/5] samples/bpf/xdpsock_user.c: Launchtime/TXTIME
 API usage
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hawk@kernel.org>,
        <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
CC:     <brouer@redhat.com>, Jithu Joseph <jithu.joseph@intel.com>
References: <20210803171006.13915-1-kishen.maloor@intel.com>
 <20210803171006.13915-6-kishen.maloor@intel.com>
 <4ea898db-563c-851b-c3da-9389abcb83ac@redhat.com>
From:   Kishen Maloor <kishen.maloor@intel.com>
Message-ID: <d15fdcb4-9b5f-ebf4-f5fe-5b16f06f2afc@intel.com>
Date:   Thu, 19 Aug 2021 15:32:35 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
In-Reply-To: <4ea898db-563c-851b-c3da-9389abcb83ac@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR04CA0122.namprd04.prod.outlook.com
 (2603:10b6:104:7::24) To CO1PR11MB5140.namprd11.prod.outlook.com
 (2603:10b6:303:95::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jhatkins-mobl1.amr.corp.intel.com (96.250.176.213) by CO2PR04CA0122.namprd04.prod.outlook.com (2603:10b6:104:7::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 19:32:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf3351cd-bd62-46e2-a87f-08d963481b44
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1101MB23656C396B8766725B6C20F5E1C09@MWHPR1101MB2365.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Xg/sM/14M1bE88TS3/KefNmPV59NqGo/Szuj2BNI7ElcoK3Gh8blmTVjhCLlQ3M5N7FI3f+qR895P3eGISQ69CglUFv93ATLYko3eXfn+QnbZBR6gCmfWk7OhuVg79QCuq3G0cZrpWIrC/mvNymXbHZuVvA9iRSXDqWNhTrzm+IAd2vGgMTBr4Ya5yN2fW7rvd1BWWGfWac4FHv+bVj7/BJKlxt1+epcBquan56M3+Pm047jmScTzxviKFObQ18zdud1VIXVP0nO4s1X+5arx6BTggNE3M5ZBZvEaCxhD+NOZlXQ2LnpLikru73u8YSWgSyU3D8MGta9dx8E4nnr0d/odTM9l1z1/FaR9RSYGKNF0y+kZ8Fv6Fr7VWzAjQmsOtzOsb50oHZ2xAGZKDsTokX4R3XToKDX9kKMdicP+KB03tFzNRjKuNjRrCMSM3HqfgO2xNMM+dyd8UZrux5K4lD9SQ8PqN7XlilSEbrtIoti4Y+YZHUPfQKkz1NtWXCAAmKqD+k1WPwPZ818UDAY7PuSE44xAM1mgI7nv7qOrycmpPZrIliLQcVGkXbpQnrMyfZ2inwkI9fb1yP9NA97IUwx0tTI+yWaT5qiU2Sw+m0uT0omp9zg4pYpQfRRhpU71N+Wwz3mWlxTzFwvM+jbDmI7e59YW+Rt1z6BTzs0lIhL51VX6eRsRkIgkq+UCRu1OZaM1loasobfcFPfKVAG3cRA469/yzy5UuCTo58Dgs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5140.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(86362001)(31696002)(8936002)(316002)(110136005)(38100700002)(478600001)(36756003)(8676002)(4326008)(31686004)(6666004)(107886003)(53546011)(6486002)(956004)(66946007)(2906002)(66556008)(66574015)(66476007)(44832011)(83380400001)(5660300002)(26005)(2616005)(7696005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHRQUitBLzB6d2JYUXRqU1NSUC9qNDZkbTBKbEYxSDllc2JNd1pDYnVqUEtq?=
 =?utf-8?B?VTEvUEJhcWJhR01BU0VvVzlINjZCNk5SZU15OXRZMlIyRCtia2ZuSWNwS0Uy?=
 =?utf-8?B?OXBKZE5ub0tIbFlZVGJvY0xlOEEyUGhNOE1yMElZOEdDb09kcHpBRmZGcFdH?=
 =?utf-8?B?bzlya2ppVzBSc2VmUlp4Y3ZJQ1hmSGk1MWE4Uk5NbDZKN0dHRjQ1STcySURu?=
 =?utf-8?B?TTZxYkhIK3lUdDhDRm5GSFlqNWxxZGFoNXhVeExqYzdVeE55WVhBbFhEU2hC?=
 =?utf-8?B?bjlxYkxSNm5FeHlvVmJTbkowYk84MUUyckVjS1p1MEVIb0doMktyMHpXN1NY?=
 =?utf-8?B?V1hVMXA2NllYKzg3NVdrSWlMR1VvS2gwMTZaVDU3VDlEcmZSSzJBeHFUTDcy?=
 =?utf-8?B?empEdWc5aExJMldTRWMxRnZBUDNVLzZqSWxyUmU1eUVDck1HRkdrTVIwQVBL?=
 =?utf-8?B?L2lJaGRTL3B4T3lqc2cyVkZqaWQwQ25PZlRuZ0ZOaFBEV2dzazY1NUVCWUNJ?=
 =?utf-8?B?SnNhMVdQZVhlMGpQMlVsejBUMEZOcnZKM2xNVTU1U2N1YmlESGFvcndBclV1?=
 =?utf-8?B?Mm92c00vUURvRjltWVllbS9zc3l4WnZLNHNXejJFZE5pZW1TemlXN01jcGlk?=
 =?utf-8?B?Vk95UEY2MVBBeVJrb2VmRnBMYVJrVlpueitUQzJ1dFFQOW9YUXZMM3JGcEls?=
 =?utf-8?B?ZE14UmNGMTljV3pRTFpLTW5aSEFSSGZrVVc4ZkFDVHZ0SlNKak90Y0lqNHN6?=
 =?utf-8?B?dDVzRHYyMGw1dzdKYVhNa1VhSEY4VnZoUTFzUVoyZm52QXNQSyt4Rmw2eHV3?=
 =?utf-8?B?eTE3TzBvZmhyMFBPd0hibWc1VmN1RGZ0OWMxN2Q3WmpFLzJhdFhkQWppNngx?=
 =?utf-8?B?ek9tbVdXWVJhZWJmNHdWY29LQW1RLy9DaklBN254Sk1obnlwOFNZdUhMY29Q?=
 =?utf-8?B?d2Q3UW1iWG1VT0szRUsrVklOWjE4UnJ0VEIrWHoxekdGZXFWdlpoRlZnRHg5?=
 =?utf-8?B?NVJZVkRiTmlVWGFoVUUzRCtYc2VZRCs2eXZVR2NXWXFOaGNwSHlWdVZadXNK?=
 =?utf-8?B?WXp2K3h6d2cvRVFOWCtjTDgxWHNGd0dZSVNOc3E5emtuL2lJci82Z2lVRTdN?=
 =?utf-8?B?M2oxZm5aL0tKM1FEUGhaK3hkc0NLeUprc3MxeGhoaGFUc0t2MVVYYzZVLzFs?=
 =?utf-8?B?RmVJZmUvOUZPbkxRNG9iczBXS00rS0p1QSt1RFFrbnFIaGNZTUoxRm5HM3BK?=
 =?utf-8?B?bzJMdU9UYmtQK1ErZGZJazVuSWNaUVFVdHY0WENHVHBSWWtnOE5OUlhMK2RJ?=
 =?utf-8?B?ay9uWjYwUFpsL2x2SjQ5S0hzWUZwSm9VaXFzcjZhUkI1bDVWSWRRUHBCRjFG?=
 =?utf-8?B?bGhKVWZmY0ptbTZ4SUJ3ODk4a29lSFNlU0xraUV3dzF4ZGtLSFYxNnJWL0xj?=
 =?utf-8?B?aFBJUzIwNmZyR0JSWEhHc05ZakxQMEtyaWMwaXB0T05lbnUvcDhRWUUyc1I3?=
 =?utf-8?B?dkpWSDh6UW1QNTk4Tmt4aE1XNm1mS2UwK0hqd2QxWXBzTHNwZU5OeEtSeUx0?=
 =?utf-8?B?bjkxU1hWTGxXNUdlczVvZkF6dE5Qclk3MStKbzk2MEQyQzVoeXY5UDRUTW90?=
 =?utf-8?B?RkRtbjJ4cHVhR1QxSXZxR3ZobHdTMlRSNE5wV0lLSlJSaHR3OEc1ZnRsNG9G?=
 =?utf-8?B?VjZkU09QSCtqaEhvSy8xYTFFSk5Kc1V2a3h4dTIzdGtmbFY3SXV4cEtHUHYx?=
 =?utf-8?Q?7sXl3TXMs+tDtANvS5ug0LgP+5tzoiw2qCsr5Oa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3351cd-bd62-46e2-a87f-08d963481b44
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5140.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 19:32:39.7787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBQ+drRU34DJU/m0XMIgWGOJjtayIu9n2iG3c8GTKcg3oqIb/YIDewgZfNVzMIXEbQ/LA5MtKMsZzBvcr7yC9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2365
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 4:54 AM, Jesper Dangaard Brouer wrote:
> 
> On 03/08/2021 19.10, Kishen Maloor wrote:
>> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
>> index 3fd2f6a0d1eb..a0fd3d5414ba 100644
>> --- a/samples/bpf/xdpsock_user.c
>> +++ b/samples/bpf/xdpsock_user.c
> [...]
>> @@ -741,6 +745,8 @@ static inline u16 udp_csum(u32 saddr, u32 daddr, u32 len,
>>     #define ETH_FCS_SIZE 4
>>   +#define MD_SIZE (sizeof(struct xdp_user_tx_metadata))
>> +
>>   #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
>>                 sizeof(struct udphdr))
>>   @@ -798,8 +804,10 @@ static void gen_eth_hdr_data(void)
>>     static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
>>   {
>> -    memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data,
>> -           PKT_SIZE);
>> +    if (opt_launch_time)
>> +        memcpy(xsk_umem__get_data(umem->buffer, addr) + MD_SIZE, pkt_data, PKT_SIZE);
>> +    else
>> +        memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
>>   }
>>   
> 
> I imagined that AF_XDP 'addr' would still point to the start of the packet data, and that metadata area was access via a negative offset from 'addr'.
> 

There is currently no kernel "infrastructure" on the TX path which factors in the concept of XDP metadata, so the application needs to make place for it. (For e.g., XDP_PACKET_HEADROOM has no de facto role on the TX path AFAIK).

xsk_umem__get_data() just returns the UMEM chunk at the user supplied 'addr' and applications need to write both the XDP packet and any accompanying metadata into this (raw) buffer.

In doing so, it places that metadata right ahead of the XDP packet (much like how that's structured in the RX path), and further plugs (addr + offset_to_XDP_packet (the metadata size, in other words)) into the TX descriptor 'addr' so that lower layers (e.g. the driver) can access the XDP packet as always.
(Note also that the TX descriptor 'len' would exclude the md size)

> Maybe I misunderstood the code, but it looks like 'addr' (xsk_umem__get_data(umem->buffer, addr)) points to metadata area, is this correct?
> 

No, more specifically, it is the user supplied UMEM chunk 'addr'. 

> (and to skip this the code does + MD_SIZE, before memcpy)

Since the packet is written (by the application) to immediately follow the metadata (both stored on the chunk), the code does that (+ MD_SIZE).

> 
> One problem/challenge with AF_XDP is that we don't have room in struct xdp_desc to store info on the size of the metadata area.  Bjørn came up with the idea of having btf_id as last member (access able via minus 4 bytes), as this tells the kernel the size of metadata area.

Yes, the RFC follows this idea and hence btf_id is the last member of struct xdp_user_tx_metadata.

> 
> Maybe you have come up with a better solution?
> (of making the metadata area size dynamic)
> 
> --Jesper
> 

