Return-Path: <netdev+bounces-4368-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBE6270C3B7
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 18:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E5051C20B6C
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 16:48:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D22414293;
	Mon, 22 May 2023 16:48:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256BE12B71;
	Mon, 22 May 2023 16:48:25 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C900E9;
	Mon, 22 May 2023 09:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684774103; x=1716310103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g1HwClg9coJmqwTqsk5f8jPeuDbfENO9lJkNh2oZnp0=;
  b=VWQws3WEDk+tLQ/VI7cusJom9k+PpM1Z/LWxwagna6ZLiRgGQ+uzTONk
   OWatc8M8Xt4yjCbNkE9QiFQjgiOHo0o/gTn5bRYSd09zaKKUYlr1dHaoT
   6BEN35yXhJg5E4oJlri00ldr5Lax7qrQsXK4G4qEA/FPdFyYDDRXh6xEI
   tqfRcGIlXJAvUV+Z2jE0+JLZFeq12cdTFR7zje3wvVSv//qKUAWE4mKYT
   StH1kyosshe7FWbayPbqDbtl1+k8SoDvMgivpvnxzuNmmjGoHsAJud6nz
   ew3ffgXQ0OWjmqtgQb14QTqVC+ytVyEb9EoQm8xaVsCTV8nAlQysgeAZL
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="381212319"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="381212319"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 09:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10718"; a="703607027"
X-IronPort-AV: E=Sophos;i="6.00,184,1681196400"; 
   d="scan'208";a="703607027"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 22 May 2023 09:48:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 09:48:21 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 22 May 2023 09:48:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 22 May 2023 09:48:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 22 May 2023 09:48:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frvjusKrHQSf3EkECUVKf74qPXncfqBavHmuZTPEs7azca20XB+9rrMDb3kga3UuGHicGi7k0R0JrxIBMmLach1OHQ3qlr3XD+JUZppXGLmDbF0B4CbtsMJtCDuQw9TGxnfbjjZhs3QjpEY8KMjGfoCnhtt+GyxGd6vwO3sgXg+onJDzsGKZVH33Hpk/0MAFCdsB+Du2gAa1NCML+hC1XmllylsLorc2WrfGLaEarsV+T737OinZzINcq3JrEXPM1s3TK+x34VqVUj/a64ajGEQjVXr1/dHuuEAIS2RA0WkPpppyJYePDTmUpyXScKyOO1i6R0XPcng/6PPsfZXY2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8D4sAI988xs1sZP5TX644Q1E1Elhd1rKouWg5l2SQ4=;
 b=jAp0VB2DdlGOFBfLxoexVggAOIM/HtR4CUCiOv0KXGJFSsLM6kJXdPv5LzCfzeqfhXPWqkqljkbl+I/fMKE2ofxV8v4Wsw/tGG3LqviZNq4/+46wEypSwDlnRSMcPcv81AqUGGGtPPIpkoRILFWIvoDGbP6jZklAIyecrz0++g3yZBZgxWvE3CXD35wJCWcJE2cyJnSwejKKTEp6b6pmoQnd5rrAUzHTGPoJOxxZCzmnmCivTmSgn0Rf6wwjio3mejxervDSlmunUmXQV8CfVYJ9jIJxVd9sPYpa5kSm/hZlzDWuTDU5rIMw5b1FzO3KP60xOSRXc0Ho/HkyMENqEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB8490.namprd11.prod.outlook.com (2603:10b6:806:3a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Mon, 22 May
 2023 16:48:14 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.028; Mon, 22 May 2023
 16:48:14 +0000
Message-ID: <7a1716ca-365f-c869-3a57-94413234fb32@intel.com>
Date: Mon, 22 May 2023 18:46:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RESEND bpf-next 05/15] ice: Introduce ice_xdp_buff
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>
CC: <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>, "Alexei
 Starovoitov" <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii
 Nakryiko <andrii@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
	<yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, "KP Singh"
	<kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>, Jesse Brandeburg
	<jesse.brandeburg@intel.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
	Anatoly Burakov <anatoly.burakov@intel.com>, Jesper Dangaard Brouer
	<brouer@redhat.com>, Alexander Lobakin <alexandr.lobakin@intel.com>, "Magnus
 Karlsson" <magnus.karlsson@gmail.com>, Maryam Tahhan <mtahhan@redhat.com>,
	<xdp-hints@xdp-project.net>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230512152607.992209-1-larysa.zaremba@intel.com>
 <20230512152607.992209-6-larysa.zaremba@intel.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230512152607.992209-6-larysa.zaremba@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0185.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9f::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB8490:EE_
X-MS-Office365-Filtering-Correlation-Id: ec9c62f2-3ba0-4b7e-c87b-08db5ae455d0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WondcRRWeoUN9MM8ooxF/qy7Iwr8jlwMzggRA1H5A7CdmIkk9WQK98a2vnr7LSfTK2IxQmQgqkAYB1vSBnbklQ80ewbfxBeWEDxn/2B4yMO4aUhO4bFE39k/lfduio/97/IR+8CnDyXXgK7bvC0t9qTDT43suDLjmh6M1zLemnoEZYbRfYruYr1/YxTQozHmySMohKbIGmEXdm2Lazk1VTd+knehlg8czQSK3ZFMcTpIw9p7ON2WVhfWwc4wvrDDSxjxePg7FtqcaOPoxkEgfzbHVKLvjV+tSsc1Bsi1MEasV2Gyh1Qpn4+DnmDlA5hT9pvhIzzIcVQBpIwM4tNjaZ+EPDemnRqMEtz9QaMcjCfsprWPunWi2ZJl9Np0D9AiuBMbq0mZ/hhDBpMqIE2opPZYsIDpCv2o15c44HtJMg8mjLHHo8EwPR2LM1zZq0JLSNU2o7Xa8phnYwAEkn2dFgE8M3OEW5gqbxrbobfdpDH8RM167hNdvlrWMu6teUw+WqZsexXrKbktb+XdYBZ6krHkvi/o5oOO3QhgnZioYw738KYZVY4TR6wNb5NCAzvCI0ZV8CiZrvWJj2c83W62wTMEEgr5ndYtMfCkVHTuygtlA8/WomJCcQJS9Ms05JwlF/uzlljmdkdpZm9aK9k/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199021)(38100700002)(82960400001)(86362001)(31696002)(36756003)(31686004)(6862004)(8676002)(8936002)(7416002)(5660300002)(6506007)(6512007)(26005)(2616005)(186003)(2906002)(83380400001)(41300700001)(6486002)(316002)(6666004)(66946007)(66556008)(54906003)(478600001)(37006003)(66476007)(4326008)(6636002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlNqK1VIRllveWNKTHh3dUdGNDRQSEJyU2IxNGNIMmljb3RNTWFENlFraC94?=
 =?utf-8?B?WkNSa09iSCswNEZCOVZJNE45blpOQnBIcXVKaHFjendGSnlzRjlVYStYRHhy?=
 =?utf-8?B?RWgxMVZiWU81UjRDYS8rckw5VE93alpBWWNWSDJVSkNWSzYvRHFxMVFIOVBZ?=
 =?utf-8?B?QTdvTnV3S1pRWHRIYkxJdk1zbE1oUXQ3MXI3NnhxcE1sRkJMZVRvT21tNWZQ?=
 =?utf-8?B?YTlMcDc4anBnWWx1dzJPRzhSM0lsV1lESVl0aVhWdHlSWnYxbjgzaWhRa2NH?=
 =?utf-8?B?aEJpT2dFL2YrUFNWMDVXcSs5cjMwMFFwWmhudlVCQ2d4MkgwREZFNU5IaWtL?=
 =?utf-8?B?amRzeWNjRGJtU0R6dGFXdElSRUx3NXgySjJiNWt0cXpOeW1jSVFBOUR2NHV1?=
 =?utf-8?B?SUVzZjlZM0NBYWUvSFJ5bk5IaWgzLzlIVjZtaGpERjd2WkVDb094UXhaT1BB?=
 =?utf-8?B?bytEK1ZLb01UbmNkN2hIQmNrdStKVHZQdWNNbTREMjViSHNUSEx4L0sreHM5?=
 =?utf-8?B?dU5tMUZub2lNT0k1TU5wMktHOVFFZUt1ZDBUK1hqNkJzTUdGVExUT0NvWHlB?=
 =?utf-8?B?QkFXV00yOUN1dUxGRzJPZlh6YmpzSmUwVjJCN2RkdDVGOElvQmI5ak1TdnZt?=
 =?utf-8?B?bGRuZlNTRzc2VGtEbFp6dEJsQ1IwNzNkQjlNV3F4aExsdytGM0V2eS9kNUR4?=
 =?utf-8?B?QndMeTkxbGJLTlVyUXRMTkVvdXlRMWJkYTR4aEV0Tm5ZM0FmR1pWNFlIVi9k?=
 =?utf-8?B?ZzljMGFUNkMxZlJ2OVlsRlh3SWtLdGhnYUFJSHg3TERtQnkrM29ndXlTdHNV?=
 =?utf-8?B?T0ZYVjNZcjEzVUx0RDJKQ3BjeTUyRFZzVmpXekw4YytWZGNwTXVURTZjdkZ1?=
 =?utf-8?B?am52SGtwYksrTWI5U1pCbHB4VnBuRnY4ZHRXZEtvV1FpTDJJeFBlUlV0cTF1?=
 =?utf-8?B?NkZPMEdvcmo0WGFPclN5cWlMTFNDOTlxcmNsOW5jcUNiQkhqNE1DeCtxZmNj?=
 =?utf-8?B?ZFZpVGhiUFBRbkVnK05kR3ZnYWFhZzNXTzBQMzJCREs1ZnV1UWZ0VnlxK0d0?=
 =?utf-8?B?MGV3NVV5a0s2QWtOVXRKaW9ScHhyZTVla1RXQzROdzMxeGx0YThSQUsxSHdx?=
 =?utf-8?B?VHhsNTdMamcvQXVqQ3YxaUtxMWt1aC9HSUpCV0hRWmJiZEJpTHUxUWVOeU1v?=
 =?utf-8?B?M1RFRG9WOVIxeE9wMmcwWnB3RklLRHFpUDQveWU2TjcvUzlWWjVaRm9HUTEv?=
 =?utf-8?B?WGUwODBKYmNMNCtjM0w5c2lxeE1HL1M4UUh0MzNBYVV0SUx0MFV5K0NCclNZ?=
 =?utf-8?B?d241ZlVkUVV6UkEvWVgzbCs2c2VkWFJvVFRya0k5MDVkcGhsajl2ZHFyY3Y2?=
 =?utf-8?B?Qi9MeGhxOWt5U0V5d0crSlVWSGtocVYyMG83SDZtSUFpWEZUd1crN2JiWFhO?=
 =?utf-8?B?cUI4NWNHbWY3WXI0RldyNlVOb0xLL0hONnRvK1pxbWRUdmVCWTdRdk5wRkhh?=
 =?utf-8?B?NDJneEliL3ZhRi9iU3RIMGVqRFl1V245QTdVTXJpTDVJYU44WTlqaGw5RHNs?=
 =?utf-8?B?YkIyZVNNdHEyeXh6WUcyZVU1MTBqVGtIb1pFcG5rdDlucG15bGo0TWIzRCtJ?=
 =?utf-8?B?V081dTNncms0Z2RGdnByNFBTcUY3UXhDVEFyQTlEOXJHbXZ6WVlPbkZ5ZE9S?=
 =?utf-8?B?Z3liNVpUR0RvcStQQmZqbERINDZ0NmlXSSs4bVlhdHhhNUVUTGdiRTUrRVBx?=
 =?utf-8?B?TmZnRlBwRlV6NDh6U1VBb214WWIxWjJ0TDFHRURueEI0bFlCcHpwYzM3U1ZF?=
 =?utf-8?B?bXlpNE10TytOb2xNc2hRTU1DMGszTHVNdUNtL3didEI2WExoa0d5M3JhV2wx?=
 =?utf-8?B?YkNVampjYjhqNjl3NEQ0Z0tCSFIyRVdXQXIrUkdZMDhna0k4Mm15RFB3QXNp?=
 =?utf-8?B?bzMrZWtMdHlxY2RLUURNU0FNbzVPd3hta2p4bklCMVRJUzhsMEFONEg2ajI0?=
 =?utf-8?B?T2hGbmcxQ1ZwL0FDa0VST2FrSmwycmNzRnRwa0RralpXUXQvakhQQzlGSjlz?=
 =?utf-8?B?NUtsZyswUGErMmpCVlhpVFMybnR6L2ZlUGRkWWJpWGhDSkJ6SG1FMUhPZ1Fk?=
 =?utf-8?B?NllMTE1iUE1oTnFYMVAvdzZyaXpwbVVuZkVkQzRITzZvSUpFR0JuSFFrc2hJ?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9c62f2-3ba0-4b7e-c87b-08db5ae455d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2023 16:48:14.5669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snk4bo5t+pfJFfR4d4/Uikb4/xwhA3xg+QdM0qzRYpzG2M7KIQzDeeRkM0KPFZOekbUG4MunC4buM6oLYDPFzy79xVPKJC0sP/xq8HZt/FY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8490
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Larysa Zaremba <larysa.zaremba@intel.com>
Date: Fri, 12 May 2023 17:25:57 +0200

> In order to use XDP hints via kfuncs we need to put
> RX descriptor and ring pointers just next to xdp_buff.
> Same as in hints implementations in other drivers, we archieve
> this through putting xdp_buff into a child structure.
> 
> Currently, xdp_buff is stored in the ring structure,
> so replace it with union that includes child structure.
> This way enough memory is available while existing XDP code
> remains isolated from hints.
> 
> Size of the new child structure (ice_xdp_buff) is 72 bytes,
> therefore it does not fit into a single cache line.
> To at least place union at the start of cache line, move 'next'
> field from CL3 to CL1, as it isn't used often.
> 
> Placing union at the start of cache line makes at least xdp_buff
> and descriptor fit into a single CL,
> ring pointer is used less often, so it can spill into the next CL.

Spill or span?

> 
> Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_txrx.c     |  7 ++++--
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 23 ++++++++++++++++---
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.h | 11 +++++++++
>  3 files changed, 36 insertions(+), 5 deletions(-)

[...]

> --- a/drivers/net/ethernet/intel/ice/ice_txrx.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
> @@ -260,6 +260,15 @@ enum ice_rx_dtype {
>  	ICE_RX_DTYPE_SPLIT_ALWAYS	= 2,
>  };
>  
> +struct ice_xdp_buff {
> +	struct xdp_buff xdp_buff;
> +	union ice_32b_rx_flex_desc *eop_desc;	/* Required for all metadata */

Probably can be const here as well after changing all the places
appropriately -- I don't think you write to it anywhere.

> +	/* End of the 1st cache line */
> +	struct ice_rx_ring *rx_ring;

Can't we get rid of ring dependency? Maybe there's only a couple fields
that could be copied here instead of referencing the ring? I just find
it weird that our drivers often look for something in the ring structure
to parse a descriptor ._.
If not, can't it be const?

> +};
> +
> +static_assert(offsetof(struct ice_xdp_buff, xdp_buff) == 0);
> +
>  /* indices into GLINT_ITR registers */
>  #define ICE_RX_ITR	ICE_IDX_ITR0
>  #define ICE_TX_ITR	ICE_IDX_ITR1
> @@ -301,7 +310,6 @@ enum ice_dynamic_itr {
>  /* descriptor ring, associated with a VSI */
>  struct ice_rx_ring {
>  	/* CL1 - 1st cacheline starts here */
> -	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */
>  	void *desc;			/* Descriptor ring memory */
>  	struct device *dev;		/* Used for DMA mapping */
>  	struct net_device *netdev;	/* netdev ring maps to */
> @@ -313,12 +321,19 @@ struct ice_rx_ring {
>  	u16 count;			/* Number of descriptors */
>  	u16 reg_idx;			/* HW register index of the ring */
>  	u16 next_to_alloc;
> -	/* CL2 - 2nd cacheline starts here */
> +
>  	union {
>  		struct ice_rx_buf *rx_buf;
>  		struct xdp_buff **xdp_buf;
>  	};
> -	struct xdp_buff xdp;
> +	/* CL2 - 2nd cacheline starts here
> +	 * Size of ice_xdp_buff is 72 bytes,
> +	 * so it spills into CL3
> +	 */
> +	union {
> +		struct ice_xdp_buff xdp_ext;
> +		struct xdp_buff xdp;
> +	};

...or you can leave just one xdp_ext (naming it just "xdp") -- for now,
this union does literally nothing, as xdp_ext contains xdp at its very
beginning.

>  	/* CL3 - 3rd cacheline starts here */
>  	struct bpf_prog *xdp_prog;
>  	u16 rx_offset;
> @@ -328,6 +343,8 @@ struct ice_rx_ring {
>  	u16 next_to_clean;
>  	u16 first_desc;
>  
> +	struct ice_rx_ring *next;	/* pointer to next ring in q_vector */

It can be placed even farther, somewhere near rcu_head -- IIRC it's not
used anywhere on hotpath. Even ::ring_stats below is hotter.

> +
>  	/* stats structs */
>  	struct ice_ring_stats *ring_stats;
>  
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
> index e1d49e1235b3..2835a8348237 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx_lib.h
> @@ -151,4 +151,15 @@ ice_process_skb_fields(struct ice_rx_ring *rx_ring,
>  		       struct sk_buff *skb);
>  void
>  ice_receive_skb(struct ice_rx_ring *rx_ring, struct sk_buff *skb, u16 vlan_tag);
> +
> +static inline void
> +ice_xdp_set_meta_srcs(struct xdp_buff *xdp,

Not sure about the naming... But can't propose anything :clownface:
ice_xdp_init_buff()? Like xdp_init_buff(), but ice_xdp_buff :D

> +		      union ice_32b_rx_flex_desc *eop_desc,
> +		      struct ice_rx_ring *rx_ring)
> +{
> +	struct ice_xdp_buff *xdp_ext = (struct ice_xdp_buff *)xdp;

I'd use container_of(), even though it will do the same thing here.
BTW, is having &xdp_buff at offset 0 still a requirement?

> +
> +	xdp_ext->eop_desc = eop_desc;
> +	xdp_ext->rx_ring = rx_ring;
> +}
>  #endif /* !_ICE_TXRX_LIB_H_ */

Thanks,
Olek

