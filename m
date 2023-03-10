Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6156B4BD3
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 16:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbjCJP7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 10:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbjCJP65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 10:58:57 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AF0E8CFB;
        Fri, 10 Mar 2023 07:53:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678463633; x=1709999633;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k1n7adRSWRaeWkHjxP35U+ZAu1ZwiHFr7Lgl450Y98M=;
  b=gyXFc8mnO56HnUisWTkgEvF+baN2iK+KTRSmXZQjhZBGbfrFJ7IrMq1b
   9QFBeGYNmdEWkGcK1O+2W4su981NL6t66Rd/4s7NaOKyq3VyD7jswH8P5
   SM8OEg4uPeBAN44msgeL1dwmUpnxcxwUG6A+T51fjQWVhQQO4sb+seOSF
   TiDqbQJtLcpneI7FEmL+BG3IhBat1lzswBu3ZMaPCy19JMrKXBRCZK6ls
   h3r6oVFJb+QQ4EV25AyMpqHX7Z8xUupUG1u6nMEFg4hqO9X7225vhWgQJ
   TEKNaTjBXXgI4pT6hE1Ae4Rq0DFAYoqZn5W2Mcs2/Wo644NWqvsJ8xISU
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="423024661"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="423024661"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 07:53:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="766868988"
X-IronPort-AV: E=Sophos;i="5.98,250,1673942400"; 
   d="scan'208";a="766868988"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Mar 2023 07:53:53 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 10 Mar 2023 07:53:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Fri, 10 Mar 2023 07:53:52 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Fri, 10 Mar 2023 07:53:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lS0Ce0zGdSDW7jcux7jYh1+3ZLbR1upTHKdCNXZY2XJYIzbjiIdYD24Zb+Av4Z18FIel4KEpOfCfJMrl0tkjVyniPkOiWFATzkRssm7IyblbAzZVjTOC7Q0DGo6ZgEat5nv0cUu7hwdyefhobKTv01UHVfS2J5HBK7PUy8ZCUCXV0nA8Jc9iE4BYm/6i6hKQ5Q5UBqc2Ea/lzGqxXzqxfkTQg51BMDCQKQ0BriV52yqH1q3q3u0oxKsnnijjv5k18DN5n630MMHdd7YQtf+kns5/rw/FhPm15i5y6/OIDDOtVyFHVD64um71OX+nvMOKv60Cs5lJWiEBiRZtlzl6vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=awv2TYvsWfud0i523/uVFBYpHpw4KjaNNjk2O/4fdE4=;
 b=IpIEl+wy9/603C+l03S7otpxj5rxaCLlS2mbUB7/42cd3S7zO2VVbbzMcwNGpcN8qn2aETJ1JbzjnMahyUrno99OMgyNMG74BWRiNFN5aPTMooQtQHHxGjh5DpwjmhaJ+p+kE9xHEcwvdDD3BeMk+G9nWQQyZz7Pnr2q9Svu8Jdh0Z0oGAlHNRvfpVGkkwzWnl+/E2jT+emh5D/Xfn9XDoxLpYBMWnrEYYldIr7ZEywNTZLC4XV6/apSexEcvBm/gNLHlgece22hasDP2+a882FqmeKCpEeIXS7x4kyg0alxW7IS1DbKD9U2HU3M0IY527ITD61YP4pcDHp8KQmq+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.20; Fri, 10 Mar
 2023 15:53:48 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 15:53:47 +0000
Message-ID: <ae69c05b-7f7d-ccd2-fb52-f89b74eae2d4@intel.com>
Date:   Fri, 10 Mar 2023 16:52:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v2 0/3] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>, <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Menglong Dong <imagedong@tencent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230303133232.2546004-1-aleksander.lobakin@intel.com>
 <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <73b5076c-335b-c746-b227-0edd40435ef5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR2P281CA0136.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9e::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA2PR11MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: 98cac9c1-728a-40be-2b7d-08db217fa2a1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLjYVIncwXpA05o8fkHWPsSL0TNIWaxJNtAygZ06GNR3vlXVubY/vF65D3kjQwfObfDvIsgPtT9Kn+c+Gi2jaR7diNj2X+HYU3yPtmYKlcbN9QgQF/jeGE8vynrrNRfQPKwWkx54PJPaewWTAPVPRcMb/DeBR+xEACkVt2xodW9f216iz57DXCbrjX9dGb97n2uGWpgKelV6r+r/cCtUlHqJfCg/cMl37GguVRJW1vnjZGs8JaPAd1LgBW55JeMM3kNgDCnuZYGTPlDsCnrEnuQ+pZuvLfXA+iV2ogE2zSXJJJuSm3CTRhr7jdroL9np3DRgMNhDkGH2txi7juY8wWgBGabIYLJ+bVpZPznwzeT5XpG+qaWdQLqae57B+P2Sf+PJQickefaXnSRqeyfAnK909OPy/0uOxxWfilurPplYzaaM5g3zepvYUtrZ6/gWHbWKlIYSnS8OwxlPrsVFOt2M7pDDX0gButw+hvLXAsd3XfIZ90fCs838f7DndGRHcZ07Qr9IBvi2zS8qhkKpNTEanT0/WWAlu53mx/aFQS0RmLfJdRw+Ru8t9q12h3jBDqRQxr0uNbFwk0DL5atUYyYf63G6AUlthWY699Kr8QTn+b1q6rOCkpMu1Z4FgftrIRlQw37Dsp7+Qn848wMEg97SSd5eq7cIqPGO6SOZaiDpeCjjoLhCIyTwSFK962SKYvVDdGjqZg51mNTeYmXqbYdIllzRDri4Yb5AVKNQtdM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199018)(2906002)(6486002)(966005)(6666004)(38100700002)(82960400001)(31686004)(6512007)(6506007)(8936002)(7416002)(5660300002)(4326008)(6916009)(8676002)(31696002)(2616005)(86362001)(478600001)(41300700001)(316002)(186003)(36756003)(26005)(54906003)(66556008)(66476007)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFJTbloyV1lEUDlRVno3RUl5TmptZVl2TVErR3FUY0JFNFk5MVFiaVY5NUZQ?=
 =?utf-8?B?YTBhT3NrZHNSTHBmaVdUTG5CNGFMTTgyWlhKdG1qc0Q5NlBVVEo5NkxoWGlu?=
 =?utf-8?B?Qks1UmZIY1RhREhhM3JaT3NxU2VwS2s5cktvb0ZGTzg0Q0laMlkvRW5sQng2?=
 =?utf-8?B?ejZyOHNhaGNRNzJKekRGZ0NZRFY5K2tqa2hvTkY2VDI1TVVoR3lFS1VVbDds?=
 =?utf-8?B?dXA3bGM3ZjRKT1ZDMDBEQ2VQMjNHS3E1WXB6b3ZxMzhZejVNb0grWStoTmsr?=
 =?utf-8?B?RkJ3RXJCTnBRK3VPaUxoaEp1dW9Oc25LRnZjVDE4NlRVeUlVQjJWcmhyVlV0?=
 =?utf-8?B?Y3Eyay9SUi95Y3NSWjI0SHBlZlBDdVFlM1YyLzVCcjBBYjRTaUNDUDZURkxX?=
 =?utf-8?B?VnFuUGh6R1ZuOXRRcFpDQzBuUktIWk91TndLYU41dFVzRElkZS9VNkxxRENE?=
 =?utf-8?B?TUdRSzFJTk5nT1RRWDY2bWlRWlAwWHlTcyt2WjRPcXFxRDRNSzNzN3gvQ1hY?=
 =?utf-8?B?TERzalFsdTErN2tMR1JsbUdQK2pycXNsb3RqU1l1SmxtQWZHVmh3a2FlbW5Q?=
 =?utf-8?B?bWtWTElxVW5iUUVRQ3hHdUduMXRJR3RXN3lnUXdtdzVWc1FOS3lneGx0NGZl?=
 =?utf-8?B?ekhuQzVrUllQOXNrdXNzZVVwWlFKNEp5dHlveFpTTk1QZzUwVDcwbldYSHlj?=
 =?utf-8?B?RFZJYzd3Y1V1K2pPZWpNZHBOcEJ6eUNoQlBGUmp0K2pYbmpnbjA1NWhmZWhU?=
 =?utf-8?B?ckpFM0x3NzZKalZBcW9YYjB1b3BvTjNjZmY5eU8vRVpFLytGZElLb3RQZmNi?=
 =?utf-8?B?YWRQZjFxbnc1eDVacVgrRC9zL0NpSDZMZUZVcEJXWVluSWZxNDJIaSt4Qk9Q?=
 =?utf-8?B?NmRJR3RkcTJ5d0w1cTBqMnJyVlNvMlJmdk1EblZKVGkvVEoxRTBUa0ZUWUhF?=
 =?utf-8?B?RGZCT0FLaVJSbVJhSi84R1Y2eERwT0hKS2tUN3U2Yk5pZlE3R09QNDFjaERx?=
 =?utf-8?B?UithMTNiMzVzUk1uWEhmcDE4eHlaOUtDSVBSdU5WU2lnd0pvc0RTTldCNm5G?=
 =?utf-8?B?QzZrVENlVW9SeUl5THM2NjlFZ2IwZGttMTVsOTZSSFBXYi80OVpGSmVHbElt?=
 =?utf-8?B?RGIvZ3NqTTRxaVhGM09reEk5NUJLRjlhK1lONnp2MFlEQjhwb2ZKUStpVG5B?=
 =?utf-8?B?bnFMZWFIeTV0ZlpMdW9tQzBWUjFKYW5kK1MrZEgzTWZ3WGxiVVE0Y0JFYUgw?=
 =?utf-8?B?Q21wOE52OEttL2xUNDNxeUxEbkFFWnMyb28xYTFZZllGa0Y1NyticXZFMXR2?=
 =?utf-8?B?U2N0Y1JndytXbDFxN3dMZjB4Z3RLYjVRL1UwL2xiU0xVTmhKUDAzemVkS0VF?=
 =?utf-8?B?ZWZyNWc1MlRUaDkvNU1rWnBuNnA4aU9iZ3gzUDgzT0RLNU1JTDZsaWtHaUN5?=
 =?utf-8?B?SkhQSFdwL1lvZlRFN05aZWpmZmVVTnZGdUNjcTFkSnJiRkxXM3B2dkZocENL?=
 =?utf-8?B?YmNlK05hUDZTNW1iUEg0d1hicTFQUDZZbzQvN1IrZmFtK2hHa1FiakRHOUlQ?=
 =?utf-8?B?ZzNFMUVsU1B1MmxBTjVybHdoWDNRV0MxQzdMb3plTnBWd0RqMjJiSHpVWnNz?=
 =?utf-8?B?bENaelVncjNDMEhsV2IyZXllRmgvTGVuSWZqRkFTaUgzMXl5ZWcxWHF1anRW?=
 =?utf-8?B?aENCR3loMWFHRi8zQkhBK0NmeUJxNXJ1Q2hwZDgrRnl0NHRzd3VpejVJTHhw?=
 =?utf-8?B?NWFZL3hscHoyNG9Ib3Q3ZGxPWDAralVtZDJGMlRiK0ZkYlJvVmpmVmpINGVh?=
 =?utf-8?B?TzVaNEJlRTZnakt6dk5waVZML0N2WDRaeU1PTmNkNmU0ZExRL0VOQlNzZnJ3?=
 =?utf-8?B?RmRiU1ZrRnc4WHV1d0l5aFRGcFIxTkZRbFJGZGVGNXBhWlk3MDdiTmNhdWIy?=
 =?utf-8?B?SS9YaTZXTTZvcTlLUWh3cCt1QmF2bkxKZ0Y4QTg0S1Nid2VncmQrNDRNdFBn?=
 =?utf-8?B?MDZVLzcyWGt3elgzZUI0SHJ3ekRwdmVKbEJub01acDRBTHFqQ1R5WDBsYmhR?=
 =?utf-8?B?UFVEM0RYSGJKcnlteHZHRDRGRHFydWdTMGVyL2dvR0xHMzhYZWhsZUJMcERQ?=
 =?utf-8?B?OHYxRHRrS1pKbGtPTDN6ZHFkdFJUYm5SWW50VDljYkpVdmV2VHBuTjE4clYr?=
 =?utf-8?Q?4IYH5ZgJYb5r4SX+hLeHBnI=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98cac9c1-728a-40be-2b7d-08db217fa2a1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 15:53:47.8279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKn6g+ZiL6vNBDjAE2HoGJ7Q9Ca4h03Z3jKBX3diiQWPMTRCz1E+rdKfGwcjg/zMNMxbwn2nkouCsuKCbeXT+GNYtAkgD9XdVtp+ssmhLSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <jbrouer@redhat.com>
Date: Thu, 9 Mar 2023 17:43:51 +0100

[...]

>> Some numbers on 1 Xeon Platinum core bombed with 27 Mpps of 64-byte
>> IPv6 UDP, iavf w/XDP[0] (CONFIG_PAGE_POOL_STATS is enabled):
>>
>> Plain %XDP_PASS on baseline, Page Pool driver:
>>
>> src cpu Rx     drops  dst cpu Rx
>>    2.1 Mpps       N/A    2.1 Mpps
>>
>> cpumap redirect (w/o leaving its node) on baseline:
> 
> What does it mean "without leaving its node" ?
> I interpret this means BPF program CPU redirect to "same" CPU ?
> Or does the "node" reference a NUMA node?

Yes, NUMA node. It's a two-socket system. I redirect to a different
physical core, but within one NUMA node. When crossing nodes, results
usually are likely worse.

> 
>>
>>    6.8 Mpps  5.0 Mpps    1.8 Mpps
>>
>> cpumap redirect with skb PP recycling:
> 
> Does this test use two CPUs?

Yes, one serves interrupt / NAPI polling function and then redirects all
packets to a different core, which passes them up the stack.

These drops come from that the "source" CPU handles the queue much
faster than the "dest" one is able to process (no GRO on cpumap yet* +
software checksum computation + ...). Still faster than XDP_PASS when
one CPU does everything.

* well, there is cpumap GRO implementation in my repo, but without
hardware checksum status it's pretty useless and currently there's no
hints support in cpumap. So I didn't send it standalone (for now).

> 
>>
>>    7.9 Mpps  5.7 Mpps    2.2 Mpps
>>                         +22% (from cpumap redir on baseline)
>> [0] https://github.com/alobakin/linux/commits/iavf-xdp

[...]

Thanks,
Olek
