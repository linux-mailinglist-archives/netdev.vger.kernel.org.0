Return-Path: <netdev+bounces-8486-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91129724432
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC15A281737
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFCED17FEF;
	Tue,  6 Jun 2023 13:19:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07C517723
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:19:43 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5FFC126
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686057581; x=1717593581;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GzbqxNpx0bIV1wPTKa4cqB6NvZQqBKmZ8GAKWnQLTbg=;
  b=CMnmKSm0g7t7e5xRYbbZrTOUMTcyYv5P8QCU1sQazIeiUZR1cMgmcQLL
   KUZGG9AN7q9csjEgA7Vv8xu5KjsA3gQYLMe9CXiMEcZM8R0aBYmP9WJtT
   HomIwfN5N742yAbe10qmoKA2maxk63AWX50fimTlzMw1EmMhfeEiY9Hq4
   C8Wp7jgVHjK14YZCnMIvP28EobHM1oLZ3Dw/1TEMuzn3Psxf8vG0GR85/
   c76f2zQABtuAdTrh0BmCyGRvCk6uuZzszmVRvZ2NEOiDNMD0T47iuskyH
   YIHtbHaCAEZ99GGRsVwHBqvSE3LHBPZ188e8j30JCiTpSvwSvIopr1f1Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="355521802"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="355521802"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="712208355"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="712208355"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 06 Jun 2023 06:19:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:19:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 06:19:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 06:19:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTPbU6Cb9jh9iN5iSDUBxVRjCeFs/h22hHCG1gZ5lvicnIMJ4AcqVNmeiJk9CvkTLTjrAIJHfCemp5hAp/fPY1ZTj4iUqwFzJ5ZmwJwOLKP8L0cugJ86Zveu0cE8g1EbQVu2W4TIyeMDE039BzjUR2s36a3CzINqpeDyj9gC4Od970NxBCgxNN+wdypwW1uXnYXykzBj2NryGW3MFwDzvbDa/QzufkI4oIAKOYMQ4ex4fJYnItVUJvUS8p0ICaBPJdjBYj7JVFosr/LyCftCkrxPYiEkrw0BkrWoRl25h0zH9537F9bJ1RT6HmBZioeusJPqOYLtdjqEXxJPOvqxhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7QpmqTQSoFi/YU0o2FWyyefkAoUKTssSL7Do6UMakM=;
 b=WKB+tGSjsmtWpf4J5m9W81Xm9DbL3X9a7XJWUZOjwYIVIMRPUmkOue7WsieP3SvXK4os5HfVBGtR9Nip67f0gbwddrQslazbXA+5V9y1oM7gEvTA97NoAeoFaYfhv/D+4paf6jKUs0rpPgK/F3+/ynJHVa3gkmtJjdDGYN/GegvryC1PiXqU82WdihAShGjDh9UOZFCCpv2ubxXaHii7BaB4fou4Xdk6QZSfylELTRt/dp7yjjxe0++mlet0ra64nkINzhPfUbchH3kR6ccuuvH03BdRWvO3R9LJ2fTWoXHiXWxz4DrcHeFIkcUTOrZF8bzw2cYBJm4g9aodLNuu5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DM4PR11MB5342.namprd11.prod.outlook.com (2603:10b6:5:391::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 13:19:37 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:19:37 +0000
Message-ID: <63ccadd7-316d-cb1f-b1d6-4f2911120959@intel.com>
Date: Tue, 6 Jun 2023 15:17:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH iwl-next 2/6] ip_tunnel: convert __be16 tunnel flags
 to bitmaps
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>
CC: Marcin Szycik <marcin.szycik@linux.intel.com>,
	<intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<wojciech.drewek@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<alexandr.lobakin@intel.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<jiri@resnulli.us>, <pabeni@redhat.com>, <jesse.brandeburg@intel.com>,
	<idosch@nvidia.com>
References: <20230601131929.294667-1-marcin.szycik@linux.intel.com>
 <20230601131929.294667-3-marcin.szycik@linux.intel.com>
 <ZH2plrPDtUdmjL7w@corigine.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZH2plrPDtUdmjL7w@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DM4PR11MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 3428f252-3348-4092-84ba-08db6690ad12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VH302P8kNiTn5GKvASyhKY779BmWw9HEAUN6XV3FQOmOUEleTvRqqcVVzt3GfvVLXPUxuFVU4o0a+wzzBqG4XKmNTh49RSejfcbqFZ83E6hPmsf5F0nWbbvuSF4WGIiOLWu0zunFgAuMRewHwduUsspBkCMsS6t2zyFjU08pPQ7a/tYPpeJjBz3LWIYbP9bHdkSeIb6wNZBLy7EamTIBbzQtDaCAxzaontXa2Gl7gBxZ1dOgq5I0iAhlimOHhcZwQCu39I/Xc9XOQgqG0H0pM5y5ZxlWqkRDhI1s1hsjxW1NlbJTrYD0EsqN8tS4Yxa122E9kM30k1R5K2QHt8aVLb2RxD2NOHiNxrjU9UMsVWnthq9ROGBC1hFKhFjXPNlMIQMJ6SZjz3UqzBl3W3hL2QMOy0pOhi+jp2rnhNR7jGCdnwLZEaaThic4Mnb073IgRaiR/UO6WjFOOg5g6XVW71CnmeuwrVFF1+lnWQxMbb74ftiCr3/PP0YN9n9xSzK7/G5NKpy7jBxx1/EjqRxpRNIiQmO9DbdN7FFkDl1AJaMygzV7GGk3CuO2W5wgLvvIaKQW85n7YjwPov2nDp7gc/RXzGrxYbDP2PGTuEG389Fh2sc1Iner+W6/zrziBv7RmqkjMdlBgRObYMgAiAAifQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199021)(36756003)(478600001)(5660300002)(6666004)(8936002)(8676002)(316002)(6916009)(4326008)(66946007)(66556008)(66476007)(41300700001)(38100700002)(2906002)(31686004)(7416002)(82960400001)(26005)(6506007)(6512007)(31696002)(86362001)(186003)(2616005)(83380400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2U5U1ZUdVpudWdYK3dxalZEdUlDUUkvakkyU0FyenI0VkJSTGVzaFdKbjdV?=
 =?utf-8?B?UmhzTzVSN2lrdkNaVDUwNis1VWdMUk1mTVpDZzc3V0o0UFROcjFLSGhSWEN4?=
 =?utf-8?B?cElraFhYWkdhbjVieEIzMUtXUm1sdG9LZy8rOUxhaEVKaWhoOC81RWZVYjVs?=
 =?utf-8?B?KzVjWGdGNmtOaForS1VRenlnMG92OXN0T1NzdWdGc1FENThOc2l6bWRMcisv?=
 =?utf-8?B?UTRlcXVLQnJOdC80N2JIemU3WTVTQ21SWEZaUTdWcmtoRTBHQzcyOHRQUGZL?=
 =?utf-8?B?WEQ5Rm5YdDc5TUtkQzN3VVVOaXJoZUFrczA0azRvbTBlMzhETTBNTUpFclhI?=
 =?utf-8?B?c3JKWU9aM3ZvbXpHQXBRU1FxRmNUOFdjaDkwcmtmZVlGZlZVUXViS2JXTGNX?=
 =?utf-8?B?dWZGM2EzdXBwR0xBQ3dkRlMxQXB1UnM0TlpNZk9tdFY2RFB4RDFDNlpBeEh2?=
 =?utf-8?B?enM0ZFV1L0NSWWovMGYrdVdzckdRbExBeFZ2WjV6T2dDVWhnUUhaMll3aHhx?=
 =?utf-8?B?TkMxTk1hYnFiKytxdmtEU2lnYU5RN05Uckpjc3IrcTlnM3J0RUxibFFlR0NK?=
 =?utf-8?B?TlRyWmovTi9xd0pUSjZHaUNDYlJsNkNIelFmYmlvbVhQWnBoUkw1VDBkSW8z?=
 =?utf-8?B?dEsxQ2tzVlJzNU8wVCtBS05IaVA1YWZEdzFvVmJSdzZZQ1g4NVI4b1JXNW44?=
 =?utf-8?B?UkpVNzhhVFc5Ynk0MUFkMDgxWmdxeWdhZFdsTHVrMnhQak43ZjBpaE02aHpw?=
 =?utf-8?B?TGl1c0pxbFJabVV0YVR6YjZJUWFSWGNmemVWSUNLY0QvME9PQnk2UE1paGNx?=
 =?utf-8?B?TUl3NDVJYTdvcGYyQTYrS3RZQXZ4S1Q5c3RRTWo1dEdOdWlKVEEvaHVhbmxt?=
 =?utf-8?B?cDVPL3E5cUxKNU5CenR4VVFDV2ZjRmJ4SzFJR1ZnM2ErbW5qb3hqSXpsRits?=
 =?utf-8?B?NFh2ZFZDb3lDb1FTZS9BN3RtOWVwNkovRVlRcVUyWjZ0T1ppNFdxZUJoV2hp?=
 =?utf-8?B?aU9admJxUU1MLzUrMEhwRndJQm5Cek5CRFhGNitjK1VHVE92Z1BVSFVaeFhO?=
 =?utf-8?B?dy9vZzNnQndhWVNjWVVTd1dnZEJ3dmVLL3ZiZ1d2TSsrMHN4djQ1YUZuZVpJ?=
 =?utf-8?B?YWJhbkpjTzdNclRocmx5dWtna2pDcGFHS3pGRFF4VHpldWVOREJ1eE9nRU9C?=
 =?utf-8?B?eUhBRlhtREFUNUJ3eEljcXlEaFdNTEZ3M3NJYlJsOGI5b01aQXkzM203d2VQ?=
 =?utf-8?B?N2VxRHJKTWI4cjNjeGkwaTJ0bGRhdXJ1aEFZQnYxL0hRb3VNTit4V2s0dXZX?=
 =?utf-8?B?NVVHaDFBNTBmUnBOdFhrbkd6bmhFQ0I1Smt5TGkxNlR2NU5mWUpoM2pIbVho?=
 =?utf-8?B?UUVEcEVRUUQwU0p1R0hhb21KYngzdlJwc2RGcjlVUXBIU2dBbGl1cU4ycVE0?=
 =?utf-8?B?S0dHY05NQktxRFJMODZ2VTAwTG5nV3B5UTczbFcrRHU2V21zMmwrbm8vNm12?=
 =?utf-8?B?cnRUanU0QWtQYis1UHhVaXMzM0ZrM0RYVlAyU1FEQ0ZKNEg4YmsyU09jdEdV?=
 =?utf-8?B?NEdQN2FZTGkrZVUxaGp6a2twQ2psT0ZzMnQyZXVVOTVyWUFyMkFvendhWE5i?=
 =?utf-8?B?U0JPMnUybzhmK3ZCeTJ4eFg4V1RhWi83UkpaTlQ4cGRYK0YrL0p3M2JQN0ZK?=
 =?utf-8?B?YW5OdkxqZm9USWpEdWlWdDJ6cFRsMDZQS01STWtKVElVR01BZm1NRmtUNmdj?=
 =?utf-8?B?S1l2QUFKQis1U1AxZWwzUVU1bEsyWFBnOEw3VjMwK2c0U2RESzUrT3Y5SVFn?=
 =?utf-8?B?VFlmZ1hId3liQVhLaWhRYkl6Ylg0NkpGWWExZHIydmNyUTdJNyt4OVFrdWNy?=
 =?utf-8?B?NHM1a0VGbm5UTUpvS1hEMFVZR2s3KzBRUHJBRGRZN25DUHpscHNKTnRBb0hi?=
 =?utf-8?B?WkNRSDVCeVJEQmlIV0dyMHp2M3lSU2VSYVNxczB6L3ZnRDNtS3Z0dExYNUVY?=
 =?utf-8?B?aC84VEJwRmI2bUhFN25SWVBGVUtjUXc2TGUrSUZyRjFCYWtVT2J3cXc5L096?=
 =?utf-8?B?bDQ5NXFPRXYxdWpKLzMvaW43WmdLQWwzNDZyd05SdWR3b0o4M0xVWjU3b1Mw?=
 =?utf-8?B?dDRWZCtOeEwvbklBQVRMTkpFOExqQTlnNDVWeUdmSGtyZ3JhUzg2N2VlbzFT?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3428f252-3348-4092-84ba-08db6690ad12
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:19:37.0309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUdu02YDnlDsJ7FBucmVwpkLlSptrX7fGwio7WPLmPhP/YOrEk+alNLHKmswggETqVjfHIFTE2nKQRH0MAlcqwZ4P+BYmjOjFOUsS9j+RLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5342
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Simon Horman <simon.horman@corigine.com>
Date: Mon, 5 Jun 2023 11:23:34 +0200

> On Thu, Jun 01, 2023 at 03:19:25PM +0200, Marcin Szycik wrote:
>> From: Alexander Lobakin <alexandr.lobakin@intel.com>

[...]

>>  net/ipv4/fou_bpf.c                            |   2 +-
>>  net/ipv4/gre_demux.c                          |   2 +-
>>  net/ipv4/ip_gre.c                             | 131 +++++++++++-------
>>  net/ipv4/ip_tunnel.c                          |  51 ++++---
>>  net/ipv4/ip_tunnel_core.c                     |  81 +++++++----
>>  net/ipv4/ip_vti.c                             |  31 +++--
>>  net/ipv4/ipip.c                               |  21 ++-
>>  net/ipv4/udp_tunnel_core.c                    |   5 +-
>>  net/ipv6/ip6_gre.c                            |  87 +++++++-----
>>  net/ipv6/ip6_tunnel.c                         |  14 +-
>>  net/ipv6/sit.c                                |   9 +-
>>  net/netfilter/ipvs/ip_vs_core.c               |   6 +-
>>  net/netfilter/ipvs/ip_vs_xmit.c               |  20 +--
>>  net/netfilter/nft_tunnel.c                    |  45 +++---
>>  net/openvswitch/flow_netlink.c                |  55 ++++----
>>  net/psample/psample.c                         |  26 ++--
>>  net/sched/act_tunnel_key.c                    |  39 +++---
>>  net/sched/cls_flower.c                        |  27 ++--
>>  40 files changed, 695 insertions(+), 392 deletions(-)
> 
> nit: this is a rather long patch
I know, but you can't do anything with it. I'm changing the type of the
fields from `__be16` to `unsigned long *` and they're accessed in a good
ton of places around the kernel. This patch is atomic despite being
huge, any separation would break compilation ¯\_(ツ)_/¯

Thanks,
Olek

