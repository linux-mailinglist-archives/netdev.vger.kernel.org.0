Return-Path: <netdev+bounces-4934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C91170F42A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 12:28:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 346C528121D
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 10:28:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78CB13AC4;
	Wed, 24 May 2023 10:27:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8880C8FE;
	Wed, 24 May 2023 10:27:56 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529CBE4F;
	Wed, 24 May 2023 03:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684924075; x=1716460075;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=yDit09XIUtgrqkeED05SOBiGNXkIpVWSLHWJ82xiZgM=;
  b=SZHcXiWmYhs34WR++sc2cT4SyKnHlz7I5+6FPP3A/HODqPhhSwjjpjBo
   hP+KMHuuLlNnzcrimMpVvT6qJF19k9I1+iCOVFeCjEGCeQntAerlRsgNX
   5uTXMtIKXaGpBCKz3mIZlX9KSzjUVQSSmb8MVIlZ3HDW5XxVbDFdHqMV8
   xBduKHoVcSdElqIwwmia99UoEqeYvTzdOv68GQh/GEhmUVzfBYCXUpUdp
   wJHp3bEntbdW8NELVmRR+hRVCTNsmfXRSryDNLAa6Q1Pi9jH5I+7GSxns
   33ErEf4d7EZ3pokoPA/HV1Jn+h8RFmv5UrFv/pcijE3yZ9HtkRx3OOBgJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="351035351"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="351035351"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 03:27:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="735154593"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="735154593"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 24 May 2023 03:27:40 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 03:27:40 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 03:27:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 03:27:40 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 03:27:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN5lOQpmSnrBKFOEXv8sADs8QhEVmG4FvS5pkOj9B57eDntlC9fVSDuXSF0qRIFmm0+XJytW46gHayNHnjER6caW4/njrKGP5JhFZbzIoj4kOgWQpgjGuhfYVPmeME9L0X+yCae/0mEM9tgufz4SYdoUOxV3WAL/zl3DWpREHL+7AAKG6zPISrIe5tjGaxjeoK9hst7brtXGsyYczti9NCiVsZE74aN+L6KA33cEEWTgIkKW3GiUqG+38REjVYs2+Gft7caPPr4TXUpw2M5Sy+iOD262WOa5OgRswJ/8vQRJfVOYqTIHIC7X7J0JopXiv+o0XEj9+39H+xOYdQsa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ABUFCQnUU0Xmjbess1onYFjMIUP/sg/XfGYJz5GRAto=;
 b=XM+BqF+mjP932wiNcVAqJCi8WHRQzzwHYrAf4a7L+g1fvSUQDML0R/z2IXSRtMdu9KEis4UwEUw6e3EZTr6bs0RLjATixAIDvxsUWI1aYrWJVC1OCOMqa7JfmNaHGwwYEGh9Or9ogmOVc9iOoPfnDIt+X5YJIIOhKzXIBt3X8mwNryO5O+QEvuVOaJ7gsAMudBMQEq4lqWoCrn1t2pv6eDnHDbEG3AKH5qk2Wv2JzxE14X4uhALz8lmSdm5YnBD+/IdDrxZDPcn9wEx/5/1OK55wBjOr+mgpuix96jjrlgV1+8lksHcDy7kPLBCUWE0t/NMpn965oplokvCfsAFnhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5314.namprd11.prod.outlook.com (2603:10b6:610:bd::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.15; Wed, 24 May 2023 10:27:38 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 10:27:37 +0000
Date: Wed, 24 May 2023 12:27:30 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>
CC: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Stanislav Fomichev
	<sdf@google.com>, bpf <bpf@vger.kernel.org>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
	<andrii@kernel.org>, Network Development <netdev@vger.kernel.org>, "Karlsson,
 Magnus" <magnus.karlsson@intel.com>, =?iso-8859-1?Q?Bj=F6rn_T=F6pel?=
	<bjorn@kernel.org>
Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
 multi-buffer use
Message-ID: <ZG3mkn3gvLmXDUZE@boxer>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-2-maciej.fijalkowski@intel.com>
 <ZGZ66D8x5Nbp2iYO@google.com>
 <CAADnVQJN6Wt2uiNu+wbmh-MPjxnYneA5gcRXF7Jg+3siACA9aA@mail.gmail.com>
 <SN7PR11MB66554BA6BE57F4CBB407B88290419@SN7PR11MB6655.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SN7PR11MB66554BA6BE57F4CBB407B88290419@SN7PR11MB6655.namprd11.prod.outlook.com>
X-ClientProxiedBy: LO4P123CA0225.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5314:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c583bc-b7d0-4de8-7d3b-08db5c417e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YO9g1LEF1vusBKSn32Cv+GnH98TwGOnYAsUiGrl3AAFcxFtHrEyy4AtxPBxlwBbHuVzzZvoH2c3qpgDeEYFtXUAvdqkTomlw4KgYheenMMXzZuWh87uc4hTnaTKyONKTUmOWSw6jEq1qxuYlrE32JBylIPIZB4eR5U4l/dP1Ic5qz0y9rNeYDEQwsvmdSYfgST+Kcqo/Aqlr1sJGlrATMhgsxDxTmaxWy+9W/OUNYXRWapNxVBIcs8b7+K0bn7LBUyWJVoSroKVLZtEfNkzPb+kUQK6isf97jWmTmK0ooFWbQasfgzDipn3OmNEv9Oel9x/v6bagzRnVZHgM129TB4ajAfrRs+cQq/eLUYu5lp0TJU3746Roi9iEg14TYdebAtiVez3snu3Lv8JDVsVHEF8y7eJuzGa4vsnMVP1Wcif8a5IXQJUo9oULGH4AUZFe5cr8QT/rC2DmwurbKXo4f1gXWKMUvZKhR88DshBWSj0K3pYtxSeLxqgo7L4OV4owf2CwkQscw/J9JDntCwYvEwIrZDRF2PM3GHwyfRD9QHGxk9H/03fd9GYy6m4vLRaQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199021)(6862004)(8936002)(8676002)(44832011)(5660300002)(66574015)(83380400001)(9686003)(6512007)(6506007)(33716001)(53546011)(186003)(26005)(86362001)(38100700002)(82960400001)(41300700001)(6486002)(6666004)(66946007)(66556008)(66476007)(316002)(6636002)(4326008)(478600001)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWh1Z29EZE1hQjRYTG15VlpHTGVEd0NEWjZiVzhZQlhPa1VjSWtGMnlLdmFm?=
 =?utf-8?B?N1VGWW9wR283MnlYMGRQTmdXSllKZGlkbTR2K3pVcFQzQjdUWWFPaTdES1Rj?=
 =?utf-8?B?cGw5ZjFMWEkvMnNKYkNXaEdjRjBBUVMvQUtwY01EMlJmcGV2RjdkbWt1RkNj?=
 =?utf-8?B?UUluQ0pDcWZzMGo5VkY4WkFMVU94ZzIvNWdESzBVcTFKcThIeDZHWGdGUm8v?=
 =?utf-8?B?VDljbllVazJnQytIaVhHSVpQMXZuSFJPbTJWQ29WdEVxQVNYclRuNzVLMGgr?=
 =?utf-8?B?eWovRmZoeU5PWTl3Z3lrRDVBTGZUSVNjRGtTTVE3ZXZnWGI5T1B3WGpSY29v?=
 =?utf-8?B?ZzFjVEZwblBwYjhNb0paZjY2QjRwUTN2UVFyaEUvU0EyM3ZVc3UzQ0RUOE13?=
 =?utf-8?B?QjE3ZDdGV1BLM1o0V3J3LzRHZWhpMXJ3d2Z6ajdMbjFnRE5EM01mVGtKaTZ2?=
 =?utf-8?B?YUdQQWtaZXRDcHNzc0QzN0J0c2t0SFV6b3VienZEcDZOMVh5OG1CRUNOWEpn?=
 =?utf-8?B?d2VUV3lWbTFERWZOMDFySDdJdWxXSHFXdFFGV2R2cTU5NnJPQUNVUmhvT05F?=
 =?utf-8?B?UmloV0NINlNsenc0MlY3QW9FQzNicjluVGtJZzNnVWE2THBpOHlzY3UzeXIw?=
 =?utf-8?B?dVF3Q3ZOOHhtNFZ0TXBncUV6ck00VVVlUWc3NnBhWHcvTFFKdGU4b2dNdDBp?=
 =?utf-8?B?RU54ejN0NWxRV2ZoNzd4eDJzRFd0VS9WbHhtUFRzc2JlNlppVjRuL2FlNEt2?=
 =?utf-8?B?QWppZlYvVXArc0lnRFhqVUoydzBHeStGcVVDWkROUFhmUlBXaGl0MXgzdkkv?=
 =?utf-8?B?VW53dDN5am9IZDJOeDhkWkxFWmk4YnJHQVY5a21tWERpQTZ3WTd3TDBNWEo0?=
 =?utf-8?B?cC83SGJlb1pvWkxDQnBzOWZGRDF1cVB0bGFNSUlrTzVkK1NzRklYU2gvYVY0?=
 =?utf-8?B?VWhOODkzV2YrbzJicXoyN2tRUy8xUUc0ZHMwS2VGN1VGVXk4cTVhMHp0c0th?=
 =?utf-8?B?dS90V25TTkJPN3VyS3lqM3R5L3FNMmNwRWx5bjR3WVA3WEpvMUErMUd5V2d4?=
 =?utf-8?B?V1BKL21YcHg1VzZmdlA5ZnlGOFRiT0VnS3l3OFRhS0F5WGwzenRGTWYzclNy?=
 =?utf-8?B?ZjI2cjc5eGlaRkJsQWZFdTNSYXh6RVU4YUtNQ3M2NTZZVmJGQ1lRRjFsRGRs?=
 =?utf-8?B?UXJJR1RHR3RwWjUvTXcxVDZnN3hjVTdsdWFVcGtXbDJNQzR2Ny8ydzFNSEtF?=
 =?utf-8?B?TDM5RFY3d21uV0UxZ2oweUxwRUR4NFFjUHpVQXV3a2lVVGowcGcwelBTZzll?=
 =?utf-8?B?ZFJxdXNJNFNFYnBZeHRCdHRTL2ZjaG9WbFlmTlR3ZThtUmRpT2ZEamY5MldE?=
 =?utf-8?B?L1pBQWJtZS9lbHFXM3hJZ2xBYkVoVzRJK2wxZTFaWkdVbktqVHpBZXdHZlVX?=
 =?utf-8?B?L01tRUdLNzE1SkQvbTF4NDNNdXB6ZDdTTjBFTzl6N1d5OWNlWVlTM1ZQZGFX?=
 =?utf-8?B?VUd3QktuL0JzUFhOWE5XTkx3MDZmbFRMdEZ5OWFURnB2VmtzVnhPNXJBOTV5?=
 =?utf-8?B?RStkQW5MdEk3SVBNejEzc2dKdE5UZThqOGJFU2ROem1jQkRnMFZoZW04SXU3?=
 =?utf-8?B?Wk85ZU55dzBUN253VUJqT2l6QmUxTUhaNDdKeDlCSWpzZytvelkzM0F3bDVB?=
 =?utf-8?B?bUxXV1ZMMThvRmcwN0w2MkovQTJqQk5tS0phRnNXQjVTUTF4NHJmbUFOOUMr?=
 =?utf-8?B?UjBQTk92N0ZQWi9xUTZlZmFKWHN0OEVGZTBvQ1hXRWFYN2JsOEhINUs4cnAy?=
 =?utf-8?B?OVNwZTZuQ0o5R01WZGx1RXZ3NnZ4SjlJTzlNdWVGYXVTL1pta0IyYWxqajFp?=
 =?utf-8?B?UjNGVzZabTd4QWdxLzBTbmFrOWovSDZkaEt2U2RSWlF2YVhNSDV0aCt1QWFp?=
 =?utf-8?B?clkxdXB6TXNjVWJvUklOWUJaQnJ5MXFyRGc3SCtEYkRRZTJGbldtVHM5anZR?=
 =?utf-8?B?aWc2VkF4dDNzeXU3M0JSUmhkUWhUcFJmMjdEdW5PMUtVU2dNbUkzMFJBd09D?=
 =?utf-8?B?SkdPRFNJOUk4Mk85YTg1ZGtUT2loNW1HRGtxYkdKY1p6dExIZzdCLzJYYUQ4?=
 =?utf-8?B?Z1hHQS9Mbm95SnAzWGFoeWo3RG5ERmpnM0EwcU1PQWlXOUdqMXdrZjl6d1Vy?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c583bc-b7d0-4de8-7d3b-08db5c417e9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 10:27:37.1723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Eu6TJi0Aw5HYQw3V0pKxPO3UFd4prbUuXmXDo4JJ9bNFzSrqb5yzCu/En0IELe/HquGl/KNFk2Q4zGSptJdasLY3OQKDbf/fJsNYfhOGbiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5314
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 10:56:21AM +0200, Sarkar, Tirthendu wrote:
> > -----Original Message-----
> > From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > Sent: Friday, May 19, 2023 10:44 PM
> > To: Stanislav Fomichev <sdf@google.com>
> > Cc: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>; bpf
> > <bpf@vger.kernel.org>; Alexei Starovoitov <ast@kernel.org>; Daniel
> > Borkmann <daniel@iogearbox.net>; Andrii Nakryiko <andrii@kernel.org>;
> > Network Development <netdev@vger.kernel.org>; Karlsson, Magnus
> > <magnus.karlsson@intel.com>; Sarkar, Tirthendu
> > <tirthendu.sarkar@intel.com>; Björn Töpel <bjorn@kernel.org>
> > Subject: Re: [PATCH bpf-next 01/21] xsk: prepare 'options' in xdp_desc for
> > multi-buffer use
> > 
> > On Thu, May 18, 2023 at 12:22 PM Stanislav Fomichev <sdf@google.com>
> > wrote:
> > >
> > > On 05/18, Maciej Fijalkowski wrote:
> > > > From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > >
> > > > Use the 'options' field in xdp_desc as a packet continuity marker. Since
> > > > 'options' field was unused till now and was expected to be set to 0, the
> > > > 'eop' descriptor will have it set to 0, while the non-eop descriptors
> > > > will have to set it to 1. This ensures legacy applications continue to
> > > > work without needing any change for single-buffer packets.
> > > >
> > > > Add helper functions and extend xskq_prod_reserve_desc() to use the
> > > > 'options' field.
> > > >
> > > > Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> > > > ---
> > > >  include/uapi/linux/if_xdp.h | 16 ++++++++++++++++
> > > >  net/xdp/xsk.c               |  8 ++++----
> > > >  net/xdp/xsk_queue.h         | 12 +++++++++---
> > > >  3 files changed, 29 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/include/uapi/linux/if_xdp.h b/include/uapi/linux/if_xdp.h
> > > > index a78a8096f4ce..4acc3a9430f3 100644
> > > > --- a/include/uapi/linux/if_xdp.h
> > > > +++ b/include/uapi/linux/if_xdp.h
> > > > @@ -108,4 +108,20 @@ struct xdp_desc {
> > > >
> > > >  /* UMEM descriptor is __u64 */
> > > >
> > > > +/* Flag indicating that the packet continues with the buffer pointed out
> > by the
> > > > + * next frame in the ring. The end of the packet is signalled by setting
> > this
> > > > + * bit to zero. For single buffer packets, every descriptor has 'options'
> > set
> > > > + * to 0 and this maintains backward compatibility.
> > > > + */
> > > > +#define XDP_PKT_CONTD (1 << 0)
> > > > +
> > > > +/* Maximum number of descriptors supported as frags for a packet. So
> > the total
> > > > + * number of descriptors supported for a packet is
> > XSK_DESC_MAX_FRAGS + 1. The
> > > > + * max frags supported by skb is 16 for page sizes greater than 4K and 17
> > or
> > >
> > > This is now a config option CONFIG_MAX_SKB_FRAGS. Can we use it
> > > directly?
> > 
> > Also it doesn't look right to expose kernel internal config in uapi
> > especially since XSK_DESC_MAX_FRAGS is not guaranteed to be 16.
> 
> Ok, we have couple of options here:
> 
> Option 1:  We will define XSK_DESC_MAX_FRAGS to 17 now. This will ensure AF_XDP
>  applications will work on any system without any change since the MAX_SKB_FRAGS
>  is guaranteed to be at least 17.
> 
> Option 2: Instead of defining a new macro, we say max frags supported is same as
>  MAX_SKB_FRAGS as configured in your system. So use 17 or less frags if you want 
>  your app to work everywhere but you can go larger if you control the system.
> 
> Any suggestions ?
> 
> Also Alexei could you please clarify what you meant by ".. since XSK_DESC_MAX_FRAGS
>  is not guaranteed to be 16." ?

Maybe it would be better to put this define onto patch 08 so people would
see how it is used and get a feeling of it? Although it has a description
nothing says about it in commit message.

FWIW i'm voting for option 2, but also Alexei's comment is a bit unclear
to me, would be nice to hear more about it.

