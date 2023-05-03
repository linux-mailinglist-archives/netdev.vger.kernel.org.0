Return-Path: <netdev+bounces-214-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AABC6F5F0C
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:22:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01BB1C2100E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536CBDF68;
	Wed,  3 May 2023 19:22:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFFADF44
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:22:11 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4EF59FC;
	Wed,  3 May 2023 12:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683141727; x=1714677727;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mbxUNr/amwtYWWtVyYEILwu4sQI8UEyL8hSebdQbCo0=;
  b=PY6K8vzK9SD0g0X8vVJnLHQARUCz86+x0b+Lw6Ne2QkdosS8hNCGwanL
   iY884LRYlHMDKxUdcsgBb88BRK3zAPIy7Gc4NvZPcRpZNOMrdRrwA1BtH
   XyzX7r882hPyut4o+X3WEBqU2DHgEM1D2ePVircoGzIpUPHKFJYnt1YH4
   558uTsm1qemCbTwAP17F/IGP+rfLU10B1g1WJiUZlnfOeXg7jK1H8FT9v
   vC5An8Uqp5TEppWBgLi5Ad41ONFnMNXCt2+Wtz1vdEyHzvzoADFpJV8uO
   jkxN3qoX1vcMRX936ecd3xPGSbtw/MrfsRq7/W4JADARQ+QNSE6ZFiWfP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="347569478"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="347569478"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 12:22:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="820875359"
X-IronPort-AV: E=Sophos;i="5.99,248,1677571200"; 
   d="scan'208";a="820875359"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 03 May 2023 12:22:06 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 12:22:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 12:22:06 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 12:22:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HInDUdhAdRIU+vEZyQDz0qJqZ3k1SI6djkyy9fHGMXyet3MBGACA7NdJ4E5/9l8/xqZCRJi70FK3oXMinenad/nJFPevJPr5k3D+bWD0TcUU2uS4sjCL5vZi9aK8/0fJrLl63MFbk1Q3Ymw2EoM3uPc3J4v195HFxgEhwaz+8koKjfmaTx+WaXGk2TZiFR7LjHWgp4RAkJjuGsFD4FIHyMl8X9u3023EoAj3LNq3OojogpsDcE8YNFt58janU0ie/R37H2kmkgxTYjEfZi+XQhf8DsI7oeC77muvkDAaOzU6VVFb6RE7ibzdzH5G27YNnSjr4b0KsxGvZMIiP/f4uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oayL738y9JjTeM+U+aoM8eN0HSDBlUhGTPeqnYkAU1I=;
 b=YAS8XwD0N6xH7ntgzuQxGP6Z5b0t6RMTzpRw4dqZPK8wXfBp+ybTBCGlIZXKGS/qBXHxz88MczfqmQMP0PD8txpH+b8rzZq0y5BLzHo4EZ4wVspxZpWQa5lwtK+KqmBsAikf/C1pCa5btjA8jUDuqLas0hqsypRbXbjFZZSWdH6YyDz+91RfdrfJMWJ8fdeB4kgBKv9bu+6/Ook7vpvA6I2HSmJDzChN6C2dX8dY41IN2TQ2NIOsAPJQplFkqOrp9S85Cfr0JU32LqYwo0fW51r3XONzSIzhNPlF/o1cgvcC8QBbJ1i+Naughib9QVs6/2pmMppcCQ+9/OJK1+9niQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5042.namprd11.prod.outlook.com (2603:10b6:303:99::14)
 by DS7PR11MB6197.namprd11.prod.outlook.com (2603:10b6:8:9b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 19:22:04 +0000
Received: from CO1PR11MB5042.namprd11.prod.outlook.com
 ([fe80::503:fbbc:de8b:476d]) by CO1PR11MB5042.namprd11.prod.outlook.com
 ([fe80::503:fbbc:de8b:476d%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 19:22:04 +0000
Message-ID: <941ad3cc-22d6-3459-dfbc-36bc47a8a22a@intel.com>
Date: Wed, 3 May 2023 12:22:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v4 2/2] iavf: Fix out-of-bounds when setting channels
 on remove
Content-Language: en-US
To: Leon Romanovsky <leon@kernel.org>, Ding Hui <dinghui@sangfor.com.cn>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <intel-wired-lan@lists.osuosl.org>,
	<jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
	<keescook@chromium.org>, <grzegorzx.szczurek@intel.com>,
	<mateusz.palczewski@intel.com>, <mitch.a.williams@intel.com>,
	<gregory.v.rose@intel.com>, <jeffrey.t.kirsher@intel.com>,
	<michal.kubiak@intel.com>, <simon.horman@corigine.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-hardening@vger.kernel.org>, <pengdonglin@sangfor.com.cn>,
	<huangcun@sangfor.com.cn>
References: <20230503031541.27855-1-dinghui@sangfor.com.cn>
 <20230503031541.27855-3-dinghui@sangfor.com.cn>
 <20230503082458.GH525452@unreal>
 <d2351c0f-0bfe-9422-f6f3-f0a0db58c729@sangfor.com.cn>
 <20230503162932.GN525452@unreal>
From: "Chittim, Madhu" <madhu.chittim@intel.com>
In-Reply-To: <20230503162932.GN525452@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0031.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::44) To CO1PR11MB5042.namprd11.prod.outlook.com
 (2603:10b6:303:99::14)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5042:EE_|DS7PR11MB6197:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8a49b8-c6c7-4b14-a224-08db4c0bad3e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /T0tarBsBZVYFx8vYrWHrQU5zAa6d77aEawID3eDtYlz5h0pUWImLMKrS135jenfEMPJTGy8qIfK9Lflr8+QZt64RnXAl95eLz8TYsy9YDZdZvX9xoIRdd2TK/8o/Q6oa+W0Ot32tCYBYEy076XKwDVY9KdWH/u8zh5DHt6oeO8ss5CLOUnxTNzRIVES5912fNl+RhiEzewD+SabidN41m7AkcJfAntkkV1TtGhiMkqyHwwkJ+iv8zj4TanhDMQC7UdkMXUpW6k1lzTqP4P8ddBY8gq4ejdYqIB1vP4xK3qxdwMeXfkhgVO3sd9VxITtCO7yBjyow4WTFO2lL3nE/wwgUB0V8MiI2n+m1SzvyoZh83jZegjBFrjgcz2jBYqX/dAgJoX8NLxhRy8q7brx5PAWBzPU1Qqh8YOL2IkG7fAZXluSQuE/12ilBrx6VAKODBdNnTdGgnBxKgBPEQZgVdBOjBYJeiFYgFHNiqy30r9unfPQIFGhYgwUhefRirMkDgWiTRmszG/uMBMc3BUM+OXJyu/uUEVUQLqHbnuzY68qErnkG/nmyyONpP4vKea9QlwRMJPDdqNvgJYNm2wCv3Nvf/TENvtLA7yVvmhUaC/BpVlnnYm/MaI7JUOzayfynhTaQRcV3v7H1NocV0BtMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5042.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(346002)(396003)(39860400002)(451199021)(31686004)(2906002)(5660300002)(7416002)(36756003)(8676002)(8936002)(66476007)(41300700001)(66556008)(66946007)(478600001)(6666004)(110136005)(86362001)(31696002)(316002)(4326008)(6486002)(38100700002)(82960400001)(186003)(53546011)(2616005)(83380400001)(6506007)(6512007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnZzMkFlRU5mM1Y4RUhPbEJ5eDEyWExXeUJ2V2RDR29UQlo5Nlk5NUp4Rkdn?=
 =?utf-8?B?bC9MVng5SnVNWTM3cDlmRERUUjRoZE1sT1YxY1hHVGlDdlRIV2g2SnZrak5I?=
 =?utf-8?B?SFl4NTBXb25lSGtmMlR5eEpDYStibUZGOGk5VUNQQittVGNDN0hHMVArS25G?=
 =?utf-8?B?d2J4cjdTRXdVWTlDTm0vQjRkVXpFRk4zQUhQOWZ0cTNVeTBTeG80VVliamNs?=
 =?utf-8?B?S1BFMFZmdTJpNDBYU0NCaU5PRWsrTXlQeUpjRTgwZFptM3pYQjN6dFI3RXFl?=
 =?utf-8?B?MVcvTitIVUk5U3RqY3RpeStsZTNzTCs2anNqa3NtNkxJNnpPd1JFOElUOTNN?=
 =?utf-8?B?a1hycys2c3FEbmtuTTVWL3U0VDU3T1VmYkdlLzlwcllrRVBFTndxUC9wOGgz?=
 =?utf-8?B?dWRkL2FKVDdwUFRwMDRreUpHSXVSdnRwMktucnJZdTZFYlhRaU9RTEpXRUZp?=
 =?utf-8?B?bUNOMkF5YUVMRzN4bnpqUjhGd3lMcHZPZDNtMytjc2NYemFSb0srM1QzS00z?=
 =?utf-8?B?R0tsVitUbHFoSENYUnFSQ2ovQWR1cGdXaUV6SzFEUy9oS2FwQmE0c0FxVUEr?=
 =?utf-8?B?eERjeHRrYy8yTkc0STg3eGhLRjIvNEVzdUVCdGxXMGI4UFF1c053Wk1xTndM?=
 =?utf-8?B?Z3VKTXFocWpNdDhMY2RVM2RIUWQ2N3VoT3gwcnBQNGRxb2dpOVZaZnNXUTAy?=
 =?utf-8?B?WTR6THJ5c1pMRlZOamtHL01rNDVkM2NINEx6WDJqZzVGNksrbG90QTkwVytk?=
 =?utf-8?B?MEVqTC9leW5lN0RFTThDS3Y0dlVQQzV1eGNiOXZmSndyR1czSm90RzlHazh6?=
 =?utf-8?B?Lyt2SVdTUk8xaG9VRDhObmhtM3I2eXRRTTlIdDVHdG1JUzAxOEhYUCs0bXQz?=
 =?utf-8?B?a1AxNWhhS29VcVo5eno5NUFIdkxwd01nQzhJbTJuY3RGbHl5ZG9lVDJVNE1E?=
 =?utf-8?B?dFlSMGVEZC92aVg4Ynh1R1lUN1FYK3RqaUt6S3dUdEt3cEZJTXJzRlZqOFZ4?=
 =?utf-8?B?ZXp0TFM3UlZESDRtUTdNTkZHNWo0bndtMTh1MW9TTjkvU0Iwa2V5MExuNlU3?=
 =?utf-8?B?Y2hPRzlzOG9saGRvaHg4VVhEN2NzcTdoWk5sRzBLSlF6VGpkeXF2SGRvcjNL?=
 =?utf-8?B?STk4b3V5cHZmRXlrUWhuQURoMlo3YWpEWHNuWmlGZzFaeHF4UnhNN1NILzJW?=
 =?utf-8?B?aTF6bXgvR29WdHc0dUFuWGk2T08xOHE1MmdIYkFEL2JOUEZwZFc5eStzZWIz?=
 =?utf-8?B?OWlPbFFsVDQzNzdmcTEzQy9KZE12RFBaeVJwQk1GNjFzSEg1RVg2V0gzS2pT?=
 =?utf-8?B?V2xGaG1zNlp3cGU0dlVISUdUakZ0d1BpdHNJTGNMT2hwbXJqNlpXUEltemky?=
 =?utf-8?B?dDZjcVR4NlZ2WmVKVGNFS20vR0xGS3ZJRFBjRG9FaWVmcmRmQnppTTJ4d1ov?=
 =?utf-8?B?MVdhRGRvbjRIMmJSSHI4WmlCUG4rRDlyaXZBVkd4c3BzM1lsNlBLVGdtZkQ0?=
 =?utf-8?B?ZlJQQXU2bEZsSmRGaUJzZ0lOWU40NmQxRDR6L1QwVThtRG1QTHIyb0JYSlN6?=
 =?utf-8?B?ckJnbHJac1d4VG5aS1F1QVlLTUFwVWszeFJmVWFpRDZURmgyekxhMXM5bXpu?=
 =?utf-8?B?L1VnQmU1TStaOUdYNnphbUxRY2JkS1dRMGRydDRuS0lSQkNYc0wwaDVCT1hG?=
 =?utf-8?B?ZWdXaHJJSW1FUXpyc1FTZEhhUnNDdFh1djBkOFAycmtXQXVKR01Zc3Bhc3Y1?=
 =?utf-8?B?UDJFWTljcHJrQ0NiUXFLVW5iUW5EZWVQSXpuSEZMNlhvY0NLRHpYeWJUY0NR?=
 =?utf-8?B?RDZST3c5WFBBa0ZsVjJ6LzdmR3JDUjFZWVlxZENtcWdadXY2ZTQ5NFR3ZCtj?=
 =?utf-8?B?MUp6TGZ2ZUxPQ0xWQmwwOElzVjljUWo2QVN0SVcxWTdIOXEwdTV5WTA1V0Yv?=
 =?utf-8?B?NHN2SU1nY3EyZG1vbWkyVkVPNGhrTmh3ZzROcDJtOGNNTFhMZWF5aTZ5NVFm?=
 =?utf-8?B?YTY5UC9Tcyt1ZHNXTUl4ZVh0dUdLSXBDSVNnUzI5aS8wUUN3bjM3cVNXNG5n?=
 =?utf-8?B?RFRQMHRXdlE0SGZORXhNNU1OSlBDbkh3czRwWVd2bkRpUEpUbG5YR3VpUWtP?=
 =?utf-8?B?U2NYTnlEK2Z0Tmt0VlpMdEJzSDdPUllvemdWRWx4Rkw1R1Y3d3VqRFM1WFFl?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8a49b8-c6c7-4b14-a224-08db4c0bad3e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5042.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 19:22:03.9940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtZ9Va7/Kr9X0g0yD8XiLKdi7+z6YhuYsQlKY1cRiN3C/BRteb6+7Ul78QJL+t7OU5CJRpu6D0c64+sEi4/HdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6197
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/3/2023 9:29 AM, Leon Romanovsky wrote:
> On Wed, May 03, 2023 at 10:00:49PM +0800, Ding Hui wrote:
>> On 2023/5/3 4:24 下午, Leon Romanovsky wrote:
>>> On Wed, May 03, 2023 at 11:15:41AM +0800, Ding Hui wrote:
>>
>>>>
>>>> If we detected removing is in processing, we can avoid unnecessary
>>>> waiting and return error faster.
>>>>
>>>> On the other hand in timeout handling, we should keep the original
>>>> num_active_queues and reset num_req_queues to 0.
>>>>
>>>> Fixes: 4e5e6b5d9d13 ("iavf: Fix return of set the new channel count")
>>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>>> Cc: Donglin Peng <pengdonglin@sangfor.com.cn>
>>>> Cc: Huang Cun <huangcun@sangfor.com.cn>
>>>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>>>> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
>>>> ---
>>>> v3 to v4:
>>>>     - nothing changed
>>>>
>>>> v2 to v3:
>>>>     - fix review tag
>>>>
>>>> v1 to v2:
>>>>     - add reproduction script
>>>>
>>>> ---
>>>>    drivers/net/ethernet/intel/iavf/iavf_ethtool.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>> index 6f171d1d85b7..d8a3c0cfedd0 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
>>>> @@ -1857,13 +1857,15 @@ static int iavf_set_channels(struct net_device *netdev,
>>>>    	/* wait for the reset is done */
>>>>    	for (i = 0; i < IAVF_RESET_WAIT_COMPLETE_COUNT; i++) {
>>>>    		msleep(IAVF_RESET_WAIT_MS);
>>>> +		if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
>>>> +			return -EOPNOTSUPP;
>>>
>>> This makes no sense without locking as change to __IAVF_IN_REMOVE_TASK
>>> can happen any time.
>>>
>>
>> The state doesn't need to be that precise here, it is optimized only for
>> the fast path. During the lifecycle of the adapter, the __IAVF_IN_REMOVE_TASK
>> state will only be set and not cleared.
>>
>> If we didn't detect the "removing" state, we also can fallback to timeout
>> handling.
>>
>> So I don't think the locking is necessary here, what do the maintainers
>> at Intel think?
> 
> I'm not Intel maintainer, but your change, explanation and the following
> line from your commit message aren't really aligned.
> 
> [ 3510.400799] ==================================================================
> [ 3510.400820] BUG: KASAN: slab-out-of-bounds in iavf_free_all_tx_resources+0x156/0x160 [iavf]
> 
> 

__IAVF_IN_REMOVE_TASK is being set only in iavf_remove() and the above 
change is ok in terms of coming out of setting channels early enough 
while remove is in progress.

Reviewed-by: madhu.chittim@intel.com

>>
>>> Thanks
>>>
>>>>    		if (adapter->flags & IAVF_FLAG_RESET_PENDING)
>>>>    			continue;
>>>>    		break;
>>>>    	}
>>>>    	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
>>>>    		adapter->flags &= ~IAVF_FLAG_REINIT_ITR_NEEDED;
>>>> -		adapter->num_active_queues = num_req;
>>>> +		adapter->num_req_queues = 0;
>>>>    		return -EOPNOTSUPP;
>>>>    	}
>>>> -- 
>>>> 2.17.1
>>>>
>>>>
>>>
>>
>> -- 
>> Thanks,
>> -dinghui
>>
>>

