Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB4F6ABEEC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjCFMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCFMA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:00:27 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4AF26CF1;
        Mon,  6 Mar 2023 04:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678104026; x=1709640026;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7fiwWM+2bYQ00vtGEmFNmKFbzUj63GxcsGDx4EnLLyg=;
  b=eZlUClUxpcpOfTdRaiDYGzZLjsJO85UqfnJHIHygcFmGM856yTpYRnUO
   X90een25x1Tt03BQPO9nP0037/9xrx6u6lsGFICWxxLNdBeA0bSD91u0Q
   x008b+s7QGFm8wKWIoBNROkCCZ7ieqBe72ACH2Zn3ryIq3Bu72e5fyuWe
   1m5ilLGC2qB/2rnvwBs9MZeeHj7N0jIEyf0syX3+IFz67+8Bg8OVULhYP
   rk2ozTFqo01uGfIvyxpPD1am7rIcc13FhMj+Hz/1mYB/BR5m63jMG/ggv
   ckKTCwKWviRheLoAl8kTdbqDAtMsAWvJX7lDL98mt4LBgPQito2QQF9sD
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="398117437"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="398117437"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 04:00:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10640"; a="740300078"
X-IronPort-AV: E=Sophos;i="5.98,236,1673942400"; 
   d="scan'208";a="740300078"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 06 Mar 2023 04:00:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 04:00:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 04:00:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 04:00:24 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 04:00:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUuEroYpU+auezE3u2qyj9qy8CHDwSCUX8+lgzmEnPuY7iY+HgOWwT55St33R9r5R5xL6u4xALvOXTvZlPKtloSxYMndJyxY6LB3xAP4Fte/4wndDkB4HirJY+fVT5lTilNJNB/GB+uLSsuT4coKBqOCc4Y8l+jeEp1Fy11tnafWRebx1lg5h29sHKyBtc0qMkahUZLRtgGvvL5u7PDnz/zKbTIGN2VHWG2peFysprJdbeI4HOT1XJ0bDRd2SImVBBwChG6mHgZJDCZwx6Tzra+CyQVaT2ZD4u7gDvAKcv3m8wa7U/aSawIQZyvMF3iyuAlxevV89rcp2VcWmcLvkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+8IvBu7/ARAwmS2pcAYbWBbdyKuLO126VVWnuaO+Ow=;
 b=U/0/t70Zq9jomPQQ+sh7gN0JKTkZ69tuBqQYIvdHzr+o2Y4FgomIdLc+xLmheq5M1beQO+M3WqIbmnHQ2VWBRaCKbgxMq5RBqsN0QxsgTZwS8HV7TT5leKw4BlTVQ3YiGLzKngEKRmxVddlEStq45EXr5LuBSJzxzrLxbS5CfR//bNHNLDXRd+I4rWLsohBTEagYwR7BeNLTZNLW4XpVikcI4PgBYYOHQoyWXM4OxP2q8b/D/Ld8MLBrvB0utYH8QGJTqIX5pJWdgll20/nC5YBg/ybytBgyz+uTYSZEknK0UlctdzUbCe8oI/6WZNqOC6THEWiaGaPqtQbeXOsctQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB4775.namprd11.prod.outlook.com (2603:10b6:510:34::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 12:00:17 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 12:00:17 +0000
Message-ID: <0bc28bea-78f5-bcce-2d45-e6f6d1a7ed40@intel.com>
Date:   Mon, 6 Mar 2023 12:58:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
 <dd811304-44ed-0372-8fe7-00c425a453dd@intel.com>
 <7ffbcac4-f4f2-5579-fd55-35813fbd792c@huawei.com>
 <9b5b88da-0d2d-d3f3-6ee1-7e4afc2e329a@intel.com>
 <98aa093a-e772-8882-b0e3-5895fd747e59@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <98aa093a-e772-8882-b0e3-5895fd747e59@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR1PR80CA0206.lamprd80.prod.outlook.com
 (2603:10d6:202:2d::26) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB4775:EE_
X-MS-Office365-Filtering-Correlation-Id: bb016fa1-7336-4270-d2e1-08db1e3a59c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dJVlEXeiIiq85Vj6UkTawr6dvdRt/+tei/m4bTWEB8fNVYg6vMNJxJAnC2H8UwIMmU1LDIk8cytd5oMIaScHc34l2qWzEsVULqBD0AGTcfLi/5qp8aCtJwW/8scdF5wnvI3kBEeNMZZC7vQW4tzte/X8GEVnslxGl2iKJGp/IDfQkngB0+NMaj1t6x4WimCMIahQuvP45KRNMiED8jQhntMp6RuunQ3j5T4XhlJuSEuRjJyT7uAD8gTR27xvr1Qcj0h4jZKLXVhJMOakojkajdUsOtLP+V/tyis+v4EdXppy944J6GCk6muV0M2L6RcrbV052WXc1irkwT5P6xydscRgKJH93SJL+KjjC5e51CBgbsTTcyDnh7YEJZmafQ8QStL3lE8sDZjncdDIJHrbwy7JYG+VcRfQ35PmrXBYldJR//NY7mO5dwqwE010C2m335ypPmNpdBn63+IRX1zVrCh6w84ichBvGo7bSLo2udj7N1bnDFrw1P1GPwTsTzajNKcVI3p2Vu3MzmRKH+Mdgrw4awhEE7YoKQ06oLssfVV23UJtnxv+y2ghtMnvtl6XD7j86v+7g2NTAJd061+ghO6vNjvM/hTl7fh5XYQs57Zyqk6odQ+q5Cszr+oUy8ArFQy8o8svQFG9JD4ctNhAbEewO+dhYBdHKdK88CzHlgbuw/jvXewuOgrSB5DdIlwADzV1bwuWY6874VbJ6cPa9d8qVcsvS1zQ1HaoIpOkEndCwh4oNBfmblTYIPxoSLgS+J6k9yB60oIkQERaoW2dSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(6506007)(53546011)(6486002)(966005)(6666004)(36756003)(86362001)(31696002)(82960400001)(38100700002)(6512007)(186003)(26005)(2616005)(41300700001)(66946007)(66476007)(66556008)(4326008)(8676002)(6916009)(2906002)(8936002)(31686004)(5660300002)(7416002)(316002)(54906003)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUxDUk5GTitmaVRFbXJFaFlzc2J3cnMxUkpqSjhPSm1Yd1NDSjhra0RPdkZP?=
 =?utf-8?B?RjhQMGw3d3lKd3lwWS9hUmdwcm1kZk9jS3NEa0hHVGVBOHZXL3RPMUtPdXRl?=
 =?utf-8?B?YzdpaVhNdktrSUpZOWpZNnhoUnB2WUd5OE1ic1BNUGRmWVlBcytGNXdGTWNO?=
 =?utf-8?B?a05DRU1UYVFQOXBaUEJGS0MyZ3Zha0lnYk40SFVkTzRKSnA3K250SXhDTDZM?=
 =?utf-8?B?V1NtZHNLSEdmRWFmK2JTdHRsS0MxTWRaVGJ0QVVjRzlqWkN6eUpFaldHN255?=
 =?utf-8?B?MHN3dk4zNVU5cE1mVGVvQk5UVDk3Yi9WM1Y5TzRrektHN0lVZmd6SS9aQTNU?=
 =?utf-8?B?QVBYa0tDSDM3WVF2eE5ob3RlSGl3MXhDemdvM2Y3bHpnL1E0L3hwd1lVYWFq?=
 =?utf-8?B?QklPUHBKYkY2NFJ4M1BYSTBlTGtDUE5wdUFKbEIvSVZlSDY0WVMrZW8yR21N?=
 =?utf-8?B?aDZGVnBFTVVuZWNxd29RRzNKR1dCY1RWSkJORzRTMEJIZ0IwVTNGUnNQczBJ?=
 =?utf-8?B?OGZaaDlqWUllck1JYUxQSGIzbXdlTkxYM3dXMHF1MEtYOFVhQWtHMGV5SjVy?=
 =?utf-8?B?YVp5RnJsN3RvR21YNG1VaFJXTU5RcDVKTGpvVU5FY3U2amdpbk9yTGFSVVpY?=
 =?utf-8?B?d0JOWTFIVWZybGNWSVdNM295VEtQS29QRFRxbnEwQnU1bldLeVdJQkYxS3RM?=
 =?utf-8?B?ZEpGWSt2d3ZnL2pNS0h4Yll4Z2F3YVN5Rm1nT0pvelowZEp3M0E5QkZhcFkr?=
 =?utf-8?B?RWx0eXRhN3pVRnprNUZpMm1LUnArc3h5Ky9KSTRsYVo3Y3dsZXFRQXFUTDJC?=
 =?utf-8?B?LzNObEEvYXI4aHFoK3lQMEd3NXk4RnMwWEdlTUJLcGlXMEtnOEMyQWlmb2Va?=
 =?utf-8?B?a0kvdVppd3lJczlObVNQQ0VwZENGcUhIbjNWNDI2SHVPL0pLbVg4WmZ3dWkw?=
 =?utf-8?B?K0w4TkR0SWt3N0RZbFE2V01SRXNqK1pwM3o2NVdiNHBnUXRkc3BYaTczMlU5?=
 =?utf-8?B?RkJ2cnNUd2d1Y0x0ZnhtL0RiM1ZkNU5aanZteFV4cnp1VXdGUktSM3lwME5B?=
 =?utf-8?B?a25IYTdQdXRKRG9mN0ZNWHZuemV3Y1ZodFFzdWFNM1dSeGRoa0tDRkprekRo?=
 =?utf-8?B?V0Rrek5zVDBNM3pESG1UT0xub1M2TGxlL05mTFVJRmlEdkhyZlcwMDJiQUNL?=
 =?utf-8?B?S0x5Q1E0RTdOcjAvVXBtVTNmVXROUE9vek8xWVR5WXN5WVZ1bGNtN3J0aVls?=
 =?utf-8?B?ZnNRdmo1czBGUW5zeTVuU3MyMHdqNmpNdTdMVENMMnZwczl0L0hKUXI2a2Rv?=
 =?utf-8?B?QmxXODdSenJUU29vUGJrdkx3YVZITFdva3QwbkFlb1UxdGxMOFBZSUwzeVNH?=
 =?utf-8?B?SVVxSmFoQ1MxSWcvTCtjcy9NRDZUUCtNYUtrVTdvQzA0YjlDRldzMFdrM3Fl?=
 =?utf-8?B?aEJiWWhWOHBkZ0NDRnNQY1VLbDFtaVdMWkppTXlkYmtWZWZaUFppaDBTY1Zl?=
 =?utf-8?B?T1hWSkN0RE9wcmt6UStiNkwzdDZnazQ1SVBtV3BDdVoyUVpMQ2h4Z3ExbTEv?=
 =?utf-8?B?R0xYZ01XejdNTlU1eDBLVndMc1hSanVscUt0YnRDSXp3cldGTUpSNlpoRWJz?=
 =?utf-8?B?WVpQSHpEMTl2WFdKTXdtNjVFOUMxRy9qeUxOZFZORTV0UUoyZWZkZVI4cVVM?=
 =?utf-8?B?aVlKOURZcXROZ2ozRVdiemlnVnZodGUwMlY3ZmVzWFNta3RiWVYrLzM2UzFB?=
 =?utf-8?B?cTVCcEJYREhSQnFjbWp3TjI1eU80VlEvNGcza0gzOFNoVDc4dkpxV0lrVzVi?=
 =?utf-8?B?WnVvaEk0ZWxUNkF0TmVhRjhGaXlOVVRXTUFPYmdvYy9tMnNQZ1BMV2pHOHA2?=
 =?utf-8?B?YUt5aCtxaXlRRytyMUZkQmhzNWZQQ1VlL2VYQzZONXpMdVVQQjNwVy9lbmNw?=
 =?utf-8?B?NGcrdEx4ZTZuQ3JJbFNVaDgyemwzZzVvUFMvR3p3RkJKU25reWZQN3ZwZE9K?=
 =?utf-8?B?WHd6dk1JMGJza1FzM2JQS1UvNjByaEFhTEVOcHpmV3VHVmg2MVhFR1FtS0Iz?=
 =?utf-8?B?U3hNT1NjazAvZWxST01iWjdyb2VJT0txVEY3Zi9NMERBazdHR2pGMzBKeG9r?=
 =?utf-8?B?SmdpbmNjcm1ldUd0MXE0OVVITHVJMEt2NUNoRnNBcXB4QUxBaXVNRkZDSTFO?=
 =?utf-8?Q?PwjNf9kRNVue4yyGxq+aGjA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb016fa1-7336-4270-d2e1-08db1e3a59c5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 12:00:16.8630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMbO52cbVNSqNUevCgi/lhT24onFpPVaKCaPGFBvVG9PDi215ufD3Hcv4OT8JGs0tpaaICwlIwj88a2duoVfHV8DMzOq7QwFeZ2o92WXjKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4775
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Mon, 6 Mar 2023 09:09:31 +0800

> On 2023/3/3 21:26, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Fri, 3 Mar 2023 20:44:24 +0800
>>
>>> On 2023/3/3 19:22, Alexander Lobakin wrote:
>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Date: Thu, 2 Mar 2023 10:30:13 +0800
>>
>> [...]
>>
>>>> And they are fixed :D
>>>> No drivers currently which use Page Pool mix PP pages with non-PP. And
>>>
>>> The wireless adapter which use Page Pool *does* mix PP pages with
>>> non-PP, see below discussion:
>>>
>>> https://lore.kernel.org/netdev/156f3e120bd0757133cb6bc11b76889637b5e0a6.camel@gmail.com/
>>
>> Ah right, I remember that (also was fixed).
>> Not that I think it is correct to mix them -- for my PoV, a driver
>> shoule either give *all* its Rx buffers as PP-backed or not use PP at all.
>>
>> [...]
>>
>>>> As Jesper already pointed out, not having a quick way to check whether
>>>> we have to check ::pp_magic at all can decrease performance. So it's
>>>> rather a shortcut.
>>>
>>> When we are freeing a page by updating the _refcount, I think
>>> we are already touching the cache of ::pp_magic.
>>
>> But no page freeing happens before checking for skb->pp_recycle, neither
>> in skb_pp_recycle() (skb_free_head() etc.)[0] nor in skb_frag_unref()[1].
> 
> If we move to per page marker, we probably do not need checking
> skb->pp_recycle.
> 
> Note both page_pool_return_skb_page() and skb_free_frag() can
> reuse the cache line triggered by per page marker checking if
> the per page marker is in the 'struct page'.

Ah, from that perspective. Yes, you're probably right, but would need to
be tested anyway. I don't see any open problems with the PP recycling
right now on the lists, but someone may try to change it one day.
Anyway, this flag is only to do a quick test. We do have
sk_buff::pfmemalloc, but this flag doesn't mean every page from this skb
was pfmemalloced.

> 
>>
>>>
>>> Anyway, I am not sure checking ::pp_magic is correct when a
>>> page will be passing between different subsystem and back to
>>> the network stack eventually, checking ::pp_magic may not be
>>> correct if this happens.
>>>
>>> Another way is to use the bottom two bits in bv_page, see:
>>> https://www.spinics.net/lists/netdev/msg874099.html
>>>
>>>>
>>>>>
>>>>>>  
>>>>>>  	/* Allow SKB to reuse area used by xdp_frame */
>>>>>>  	xdp_scrub_frame(xdpf);
>>>>>>
>>>>
>>>> Thanks,
>>>> Olek
>>>> .
>>>>
>>
>> [0] https://elixir.bootlin.com/linux/latest/source/net/core/skbuff.c#L808
>> [1]
>> https://elixir.bootlin.com/linux/latest/source/include/linux/skbuff.h#L3385
>>
>> Thanks,
>> Olek
>> .
>>

Thanks,
Olek
