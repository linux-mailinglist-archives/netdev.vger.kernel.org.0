Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA66B927C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCNMAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbjCNMAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:00:38 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F46BA0288;
        Tue, 14 Mar 2023 05:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678795212; x=1710331212;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9Zes6Zs4FSYoUYnpz4xSDaGeuTP4HzuQZMV1RzGqzI8=;
  b=QmBwR8mWPu/scyK9tvjQKiBWx+veTloNLO2HuSXumk0ApTQxnOaA6Uxn
   b1mFiL1Yp8Nm/wv1KCxt+E7oGyxlTmQUwPo/0W4LuOVqCPEM8Ox5gddDK
   3zIRhYJcaiQljMp4bNjV1v8cQklQt2iCWM2eOHsW1yGLtD6f4/vVXJMmZ
   nxU96NG0gdGr8kJdvUnictr6JeygNWyb6Ynl3Xbnr3XMIL6YFHh0OpK4m
   I2Qqlb2S9uURwF2LiU6vyLcJMVVufAyywvrFQooD+nfLlIRlvY0sBWuQ+
   Z71NPgV9TYnIMTs/rJAqTdnUqRkv9+G5EUCqcfIhB7e65KztM/tHGC/ZM
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="317789116"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="317789116"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 04:58:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="629025015"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="629025015"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 14 Mar 2023 04:58:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 04:58:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 04:58:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 04:58:09 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 04:58:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1XZGjRyfRol7JI9teWiibn+0E81TNwATqKFhkQVB5cdiqYC/JIr8s4+KHkJ58+ZsvJD9GIH4VI2haI1mXfqptfnMqBP3POzIx05ER8IKgTdF60Ixjf8XRe7NMP4QlXXlslZS0k2JDCY0wS/uCZ6akbtV8LWiC44L/gHd5HtIxCcZy06WSYwy/ZMxUIzElrSpLwld4LaqG0wucBBPS4k52JozLEu/3Jih930Aux7AooHbEY/+Ua8Sv9ERAZqBKSEGAui+eX4zfsPwu05drpV3tyqicE5mdol8bIbNwkinstp00mgU898q0I28fBbCk9bl1qc4lflAceP+sP3nY2Okg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sG2r8LTzNPRUAVErD56fCV3NPSYo0EEBz0UfnxIQOV8=;
 b=c4AiFZWQr2DORL7XekELk7IqjHET7Le9SZwunByhqvqyd/5nDXRD8YCiKeVIxqBWc+L8DKpLv+hSHIH3q7mnec+1X/s1bRxXQbIi379C1opB5Ltum0PonlITe5tK+ajZye4FsHT8oqfuDhDvwrg3OfwoV9REabjBKpqEKACOHCXb2HSsW4VPRv1B9jRj6NjPVRfKsgEJjxLhLIyCbPfzcH+lyDZD263GQ8ZfueQZmHDLhG4j7j0W/2xNIPF2mwfA9/bxCqzHWXAPCNNFb1aRwOMZXWk+mYvcPLOxJm9hsxtEllGH+Qqlm4ZAxBovzn0O2Aq69MJPho0FZtADsJ+y4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ2PR11MB7455.namprd11.prod.outlook.com (2603:10b6:a03:4cd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 11:58:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 11:58:08 +0000
Message-ID: <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
Date:   Tue, 14 Mar 2023 12:57:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
Content-Language: en-US
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0175.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ2PR11MB7455:EE_
X-MS-Office365-Filtering-Correlation-Id: a87e3c18-1dcd-434f-6700-08db24836011
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A09w0CRZh755DFmD2UlgN0OFbj/PVtBj09c4C8aquHxoqK8yR8+G31FbYziOJfwiMvjzXGtQPSjii32gjyKJlZus6achWjS0WBO2y6oxuGTmdBTR2nid75lT6z1qRu68+ux6v+TQQEmf4w7/7/cRGFDHNAiHAoXGqph8Xqz/Tm2CmfwuK/Sb4KF1Z1KyzKabcTRKrlJakaYsDcVnIlLqaBCu5dumwSvNa+X53dF0NMoN/eIzMOf1a0p4LtI5wc3DbZ7oCH7i9vTUoNy960QtIMmx+h2LkXHHGg71rQFTJN+OSudkdLezhIiOKQYI+bWhDX+NuOkG+QjzSbPplFWSQ1TjrCWVgbKGUqzdi1rv1tEbXkQuw6RNXUW0RwzsIpZNh15KvZPbOfsfzcHwqELS2bdWh6My4n7+cTMKg6BAqe3w4mb6Pz1bIrTwS7XMRVIyEfpWZjqx26/84UIgbZGWfwrLoe9xJL6V2gneZKbn+t2jISkYfRdJWBoIquNSYq8vNAGvqMdQOBhYs7K/pB+xImH+XQwKs22pukt7mEyyFU0NujI65ZdbgKRLfYoOuKIgBFtRcei8PbwiB4NjWLpyNxFNzEhwNa6JMhKwhGfguZFlO3oGCV00IBj+iG9ciN6Y6HRS6dOkgLvkdy3U/8JSa+M4PER8KEwuuBMDUQlP/LdOfpPaLDcY9B2FkJO8iAFTEemR4M+BQSpEGF+7QvZRKM1rVNhTNhP86U9hqWQHYMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(396003)(366004)(39860400002)(136003)(451199018)(31686004)(4326008)(5660300002)(2616005)(7416002)(8936002)(186003)(41300700001)(26005)(6506007)(86362001)(31696002)(36756003)(2906002)(83380400001)(38100700002)(6512007)(66476007)(66556008)(6666004)(8676002)(6486002)(316002)(54906003)(478600001)(110136005)(82960400001)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmlHSGIyR3ROT0htU3lSbWFWNVVWalFZRU02RjlkR1ppZ014YUFIZzNBQ1Vm?=
 =?utf-8?B?Y1IvQTZyclJHMVh2SWwrR3cvYkMxNVZVcjFLcUF5a2c1TnVGY3dqVFl2ZjJz?=
 =?utf-8?B?T1VJQzRsSTE1cUs3eFREWDRTZFFsM1c1R2ZwbVNKdnpGMGQ3MUNnNkRXamtm?=
 =?utf-8?B?b2dKL1BxR21lN0Q2M29IMWlRdkdvY2dRYXZXTkRiMjVRNHdyUUdhSGNwY05F?=
 =?utf-8?B?OU82WWNDK21FTGtITUFwM2xUdHBFcmhqM0JlbUNCbDZ4UktKWWhHemFjSml2?=
 =?utf-8?B?N2ZoZ2Y3MTBETWNnQ2M5ZnFUTWZrYW8rS2hMOVFQNVhDRTdSN21tbUgwM3JI?=
 =?utf-8?B?L2FMSDNIaVc5ZDJXZEZYQWlIMmI3eWp0YXJScm8xdElLUk1SVmEvdFFpbnlq?=
 =?utf-8?B?Q0RlRHJVZlI0eUNoY3NPSXlSQi9CdTk4c0Q1YUU5UTFSOHNXRG5leWxZZHIx?=
 =?utf-8?B?NUhPbDBtTEI0YStEUjFJb1JJL0lrR29tRDRtZDlZQ0trR2JjT3pVVDZBRmd2?=
 =?utf-8?B?a1lBZEg0OXcyVXNXeXpCS2F4U283VTJZZUpNWVdsc3FORkZLakphZzl6Ymlv?=
 =?utf-8?B?NlRGUEJWNzVlbGx5Q0JLR1RHRzhyU0t5cmhUOFBRcUM0MEZNa04rTEdOdHQv?=
 =?utf-8?B?T0tpZGlvUVhwVldCUVhMTDhQYmEvNG9EWDRqV2NzTmFpRFJZZWZPakpTSmU2?=
 =?utf-8?B?RkJ2d1lUa0NycTdpM1FBRjM2Z21HMzI1OUNmOFJzSkFucFlidVJOSmxtaldk?=
 =?utf-8?B?TTltUEtCaGI0cUNHUlVjd05iazRsK0l2TDlvUnJmcFNma0hyRmlrYXRKM2lw?=
 =?utf-8?B?QkFEanYyS0NjUFJPOXdGN0VpcTFOS1NEZEtnVitRWDVHY2plOUtMYXFCRmc2?=
 =?utf-8?B?WUlZaXA4bmpHTGRRRTMvV2Z6T0t0UVdKUFJIbnI5QVozM0VEMzdWOHBIK3hT?=
 =?utf-8?B?cDFKWkYzMEsxbFdJR1Q0MFBFSHVtWlJnMzVWV0NrUnRGZnFyaUNkcmwrbkRG?=
 =?utf-8?B?NjFJbERucVEvMXk3R1ZMS0NVdGk4RGtkRGFTa3I2SWwvZDdSZGhFV0F5VnpF?=
 =?utf-8?B?dlFENC9WYVZDektwbTd1VC9aUTQ0Y0JzSXRWZWlha0xtcDcvNktEK1JQU0hF?=
 =?utf-8?B?eDc0Y0dLR1BvYUdaYUVaaUVDeTJkWWxFV2NVeE1rb0RwSUdNaGMzc3FtMnJp?=
 =?utf-8?B?Sk1GTmxTWUpKMytaR3A2Yno2NkFMVW5Nc21oQkxrQVpNRWJ1OVZ0Qi9KQUow?=
 =?utf-8?B?UEJyc1hudk9NZnI1SkRUVzVFZWpVd1M5NkNSNndMQmllcnhHMzdXb0tsN0li?=
 =?utf-8?B?a1Fib0dTTlNHN3J0SHk1OVNaTGpUU25RbG9xUFhEbWl6QmVhQXRyenc2VEw0?=
 =?utf-8?B?bzUyeFp5aDBqU0JQd0VVMUFoOWdUeXAzRVk1NkdRYXlGK1pZaFdaemlnUHN1?=
 =?utf-8?B?R3pkcm9xNVNPaXhyMlVzc1I2bE8zZEhzYlFaTmJlUGE2YmpCQW9lVzlLVVQ5?=
 =?utf-8?B?ZmtOaXFwUm1ON2NXa0dwb282bTQyQVNELzNsdGtuY1l1Q2Ivalkra1Ywa09p?=
 =?utf-8?B?S0ZGNHhJbXJYSlBXUmY2RE5CdHJpUVBsa3pkaXZpNlJUV3FkNzJXMkJMb2F2?=
 =?utf-8?B?RUlvam9CaVlZSi9QNExpRFl3Vk4zbHdMcmRRN3pqanU2Y1hYUlFzcVVoeHBw?=
 =?utf-8?B?YzA4dHZNcTRHaHlWd2Nrb0VnYTN4Y3U3WWlsT0M4MkpzY1JHdkJ5SVpJY0Yw?=
 =?utf-8?B?MlFOc3ZlV1IxS2tVVzR3Q2h4ZGpqR2ZFNUh5YXpZZmxXOTlRdU5rWVhZTG1K?=
 =?utf-8?B?VG9MU3lKR2cxencrV0tub2xlNjIzSzVWUDRMOHBlUnY1d3BrVVRQaVZVSldB?=
 =?utf-8?B?Yms4L2NVREg4YjhyS1RZTkp2SURIeDZWNTlkbyt2ajk0bGFnQ2xVRDQ0VERT?=
 =?utf-8?B?UnA1a0hYY0RybVNkUzVXL1pHTTBvaThydEZQYURQRTFYZ0ZoSEtBRElUK0k0?=
 =?utf-8?B?VDU3RDFWUXhEcU5PS2lXOHlzV0NsTUFvU3A2YitKN1M5WnI5Q2JoTEF5QzRD?=
 =?utf-8?B?enpCdE1SRjA5Qk1HWldISFZCR1Y0M3pzcmwzMFRySE9nNTAyT1hIUUdjWTNT?=
 =?utf-8?B?UTJIdUVVamhzSCtTdklaNzNyTUs1Uzdab1hQK0xRY3BJazVuVUlOMTJOY0E1?=
 =?utf-8?Q?0wN7n8P517ZRlFnK3ZEAOQY=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a87e3c18-1dcd-434f-6700-08db24836011
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 11:58:07.7094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HqmxcJ12r6Gam0rWXimksiw51RfDm+uLY6u5Y733t5PNSzP6VnA5j116mq3NF75LRM2nZw6n0XsnhlcedjW7BepXWIk8j1RdC0mQeboc+jA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7455
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>
Date: Mon, 13 Mar 2023 22:55:49 +0100

> Yeah, I still remember that "Who needs cpumap nowadays" (c), but anyway.
> 
> __xdp_build_skb_from_frame() missed the moment when the networking stack
> became able to recycle skb pages backed by a page_pool. This was making
> e.g. cpumap redirect even less effective than simple %XDP_PASS. veth was
> also affected in some scenarios.
[...]

Regarding failing tests, here's a piece of logs:

  #288     xdp_devmap_attach:OK
  [  156.324473] IPv6: ADDRCONF(NETDEV_CHANGE): veth_src: link becomes ready
  [  156.362859] bond2 (unregistering): Released all slaves
  #289     xdp_do_redirect:OK
  #290     xdp_info:OK

[...]

  #297/1   xfrm_info/xfrm_info:OK
  #297     xfrm_info:OK

  All error logs:
  libbpf: prog 'trace_virtqueue_add_sgs': BPF program load failed: Bad
address
  libbpf: prog 'trace_virtqueue_add_sgs': -- BEGIN PROG LOAD LOG --
  The sequence of 8193 jumps is too complex.
  verification time 77808 usec
  stack depth 64
  processed 156616 insns (limit 1000000) max_states_per_insn 8
total_states 1754 peak_states 1712 mark_read 12
  -- END PROG LOAD LOG --
  libbpf: prog 'trace_virtqueue_add_sgs': failed to load: -14
  libbpf: failed to load object 'loop6.bpf.o'
  scale_test:FAIL:expect_success unexpected error: -14 (errno 14)
  #257     verif_scale_loop6:FAIL
  Summary: 288/1766 PASSED, 21 SKIPPED, 1 FAILED

So, xdp_do_redirect, which was previously failing, now works fine. OTOH,
"verif_scale_loop6" now fails, but from what I understand from the log,
it has nothing with the series ("8193 jumps is too complex" -- I don't
even touch program-related stuff). I don't know what's the reason of it
failing, can it be some CI issues or maybe some recent commits?

Thanks,
Olek
