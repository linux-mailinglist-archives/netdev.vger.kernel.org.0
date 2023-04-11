Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFDF6DDEEF
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjDKPHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbjDKPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:07:06 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636404C0E;
        Tue, 11 Apr 2023 08:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681225616; x=1712761616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7b8mkBjjO/AozHNXu3XaeBBHTUtFntYdYFML2Xn+OaE=;
  b=K3agB9Rjx3qUKnzdExut9Zhnm0Lx7eIYec0UNrj63kEUarzKQpq9hxmu
   wKmsacgeO5XBfkr+ZILMOVD06fiIUoQkwb7rfBMxhe3kN1rJwwbyq5+yL
   yzbJQDwf7XyBi/jzha251FyeCPtOcSB9UU2Qa9Jlt1L2lciIYMRY4PvO7
   mszd3bolWy29YpRqdBgA7/hwtiJhXSpR59orfQ5hDL3yBcWMaL0ZQ7R76
   8nr4VQRDbDiEEEkvKEhGwwn0ixc0UygXBveCgO3obHJsmnM/aMGiIIGxP
   Q8+ya4ocW+an99OvQ61pHDIgYcLb9kdLdsPVsZJYasZImPNSo59W8nWi6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="343646995"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="343646995"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:06:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="777943266"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="777943266"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Apr 2023 08:06:33 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:33 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:32 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:06:32 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRyDmiKhDN9KSAbgcdhfc8etvRhANmDqfS2quwdwNfk6sjdmHkvR5ORHp5NmYMW+898BYXvwCwEAaQI8x0ks6SmvAVefhNCr2tGSKO/MrZwHYrEPFnRSxeq/FBYIEWEB143FUnB3OIPnk9rBRVcZKY3baEDtpH5TvflBmvCubHKCAa4bIFWpzSKNl+pAawc7j847e9JcMbdgloRufnsaTyID9hlBwQIIJLA0tdWcQjiYIwRjf9NzzJ6WQTT3FnSbThUKq+XKI26C0xXKIrs5tcx3j4T5AKVd+5zrTtWKkDeRTQEeGOWVRH3W18bsFhevMQrIwQfc/tZti3Kq+v8CAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BShUwTYiGu7daQvHRjGDV1pGRJDlDWTwH21Um0I9t0s=;
 b=irxwJ+rJeGqd12EwRQXQC24fH6fdP3BPcaGRP/GtZdlVPz7CQCbrbpYZhvHyKJRUNB1/ZSBTGVeZIWmMRvsVSyiyqX1Oln9WKgFmvW3HiRoXFJc76IRrtAgKmpuTHDaezqwvre221viURURH/BbBMvli+ErHESJpsfd+RDlTd3CYqlU+IJPlIOxXb2e8ibvq0FL8Gd6EL3awNYDggrTlIIHZk2ZJenu+qD3J8zoUN7tT56Kpjcu9aH3y67e4R5WrtAUOgkF8VwIKHo5gR9GQaNfSq61iQmT1GDOV7BH/J3Y6e5Js1g0tpLaJy3xe/PpfomPaxF1OU6NXZqvvhpmqFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4601.namprd11.prod.outlook.com (2603:10b6:303:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:06:28 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:06:26 +0000
Message-ID: <4ccf5199-b8d8-c6d2-ae9f-e3591c688c65@intel.com>
Date:   Tue, 11 Apr 2023 08:06:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2,net-next, 1/3] net: mana: Use napi_build_skb in RX path
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-2-git-send-email-haiyangz@microsoft.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <1680901196-20643-2-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW3PR11MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 59b7e6ec-a443-4ace-3955-08db3a9e5202
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZo6Fkb+BGpJuv6vWLwzIcy1NYYcoN4rtRqJbMHh6n5Bpg4bOXIqNRcGGnZjv4pzpuCho4Qmj8QtLlixlFFbPcTMwLHArRTSzz8z2mnwLg4/bzk+EpG/sn+kDNZyimeCFQuVSsH+N+tnl5pehITunt+36EtI3O+V4KZ8G4P53vqeYCLlpKiKo5UHVp/lUCB4XhRkJRhjKMM22WszzogXqR5dIBccY8LoH8JXazF3OhuqkgK/cfxr0hYN8um0dq7t7SmGxwZDy3epkm8+tWRBva+WOl9GUvGfN8LA0pRWBDMjN4yLrYZphcKhdA72urAqvdn9eGdBJyHIjJldWQSED4Ln7AGaWjYn0McVm/yNvVfDVaIc8ZHRzipyhVL0FUiDKIdCNNvsely7iHWTCu517SVx89ZJ1Y+EPWPqz1pI7IqyCynxhGmopUx2s/q/4XpEU8w1ELbiIK9a2Md/T/2gEvNvrEw9QGXazqXUFTq8RSTOG4c3FHJDVQsoJ0jCGGBLzSSjviVPFrtI1zek3YLJ1zXbA/ZfmwLrrzQSyjL6BSqlKiz3QVjERiE0I4kXlqeDdop5ZuHTu1HtXQSY2GGTM1ZOXsFndNt02J44HMuT7NXQ1HzUNq7tGrJDIic5BHPjfjRKJNUpbjYiPkm2e614kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199021)(31686004)(478600001)(45080400002)(86362001)(31696002)(558084003)(82960400001)(36756003)(2616005)(38100700002)(6486002)(2906002)(53546011)(6512007)(316002)(26005)(6506007)(186003)(44832011)(66476007)(41300700001)(8676002)(6666004)(66556008)(8936002)(7416002)(4326008)(5660300002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SmtqOHZXbmNDRWR0OHVqaWxOSkt5dFFFcUMrTGdNSFdoaW45L1J6empwb09q?=
 =?utf-8?B?M3JreFFsS2d1THhBZERudUViZGlZUVpoZE1ORndHSFBDSUdEYnpSbUxaZTh4?=
 =?utf-8?B?Mkc4U2Q4K0RJcUxqUWtGZFJIU3ZQUEZ0S0I1WXZqdXhsSCtLcGpMbWpXbW9J?=
 =?utf-8?B?VEJQalhGbGNJSnhyMzVoWkFGbWd4elN3WWVBd1ROSDdvQ3VnbFBzWTVFNkRj?=
 =?utf-8?B?dHlGbDV6VkJGQ0swc25ESTJEUmxQeEJheGlZd3NnVlNCZ0FFa3h1SzNpdVVF?=
 =?utf-8?B?ZUh4bFp2ZDYvNllnUXJ2TnFXMW5hRFhkbkY3N2pSTys1eUphMHVzTG9nUHNX?=
 =?utf-8?B?QmN2VjV4QVJ3QnNXUUxwdXpDWHlHNERmSU9RM0FIQlhtK2czd2srT3BFMVJq?=
 =?utf-8?B?WUc3U2Q2TUNId2NSQ0dnUDZ5aGRPWWVla1k1SytUWkFnUURUSGkxU3hwVEFk?=
 =?utf-8?B?NXJjenE5MXQvMG1Tekt2Yzl1QjlPRG02TXRaU0wrdm1xUVdnQlNHWnFKcUNX?=
 =?utf-8?B?TWx0Z3l6cWZHbFlVSWhES2g5bzZLdC9VYVpseGpyOGJmdVRGTXlrcmQ5cUZz?=
 =?utf-8?B?ejFURzRLSGxwaTJhZ1QrTzdINi9YaFhwem50N1ZhM2JYU3hRQ0ZCMUZuV0tX?=
 =?utf-8?B?bklpSEJZc1hTTVNYQ01qWGtpUGJqZXhybkhtYndkTzAwYk5SSWswejR4a2I3?=
 =?utf-8?B?d2NwUnpjSXhLTGdPMmhZTXVlcTVyc3NlZFhxRjhORFZlekpvb0YvUEczUXJW?=
 =?utf-8?B?K0xybHZUZ1hweXk4bDZGUmpsOEVGYXhOTWMyN3F2czJWYTlhY1cxQkZuZEo2?=
 =?utf-8?B?RzhocjJXaTM3RnhGTjRaVSs1UENIQytjWW5MZERyOGsrakdMQVBTMThnYXZM?=
 =?utf-8?B?T3dwaU83dmVmSjlaNXpiYUwxRGNmeFRaTENvaEpQRlhzdEdmN1NSM0RFVmpS?=
 =?utf-8?B?RmVJSmdoUERqNjliTHFydlp5S0R6ZXVNaExGM1hodnFOTEw1eDE3U0FBWVl2?=
 =?utf-8?B?RHEzcHFKSFdydGZvaGQ5eHRqOFluS2RMbktZc2tURTZNdXR6RitlMVBnTWVP?=
 =?utf-8?B?QngxaEcyNVoyWnQ1WE14aDdpc3d2SFFwbzMxTHo1ZkpYT3VBNnUzZnVwMHIv?=
 =?utf-8?B?aXFoMXJHdHFqS2Z2L1NKN3lOTU5XTTBMeU1FbnM5U3RFQXFsdVhVa3NPYkdh?=
 =?utf-8?B?UDkvMktId3VISmhVVU01N2d0bHFVbndrNGI4Ny9rL3JOM3ArcWJNU1RHQUFi?=
 =?utf-8?B?WHhidDZPYjA4dytKWXM2bDhxZ3VBRU1iVVJyaXJiSENSbW56djVLYTN1R3N0?=
 =?utf-8?B?SWRoajByZmVqVENSQzl4OXlpMm9zckViOEVVL3B0c21wVGVicjFvZkVoSmRx?=
 =?utf-8?B?Slpob2xXU0ZnSWpEOFNyV2FhNFBsQmJ0RWxPdklHMmtFNSs2VFRMSXZsTDBq?=
 =?utf-8?B?TmwyOHNPek9iRW5mM1UyNUx3ZmZFdVB4N3lmeDZrSnluelVFQUxPYlVLZXp4?=
 =?utf-8?B?RlRUZDdsMlBNa1VEQWN2RC9WNmpQUnRNVGJvRmMvT1NVWkRYTzhXNzRhMWFs?=
 =?utf-8?B?MmRCc1NDNWxKQTNRY1kvcEhJMlRpVDBUS1BEZ3hJTkl2VjByUm9jTFQ5SnZq?=
 =?utf-8?B?WU1rTmp1ZjhBOFEzVFkzMlVlMGo2SmlTbkJlT2hpSURSV3JUQ3p6d2J0NzNa?=
 =?utf-8?B?bnVZR0ZkTEJSYjVUL0VkZU94d3lBNU51L1RTaTV2bGp3WTAvaGxtcFYxWWx2?=
 =?utf-8?B?RnljeG9CaHRGUkFuc1Y1Nm4zUWdEYnVtMEZQQWpZZHpIK2hnWGZ5LzREZk1H?=
 =?utf-8?B?bXpPU0xCYWJBVVh0alZLU1h2NWU4S0dNREJhWithVE83cW1MampMRUdXRXlM?=
 =?utf-8?B?V1RmSGJudm9wNDZhV2tydDFISENhaG16V1MyNno1eTdxQ0oydmpaSC84dkZB?=
 =?utf-8?B?NTdvRDQ2d3pWREM0VHB4TGlhSWF3bEJpb2pLdVRreElyMkFZVVF3SVpzUTBw?=
 =?utf-8?B?K0c4S3k1REcwN2pINGxUY3RsWWZRa1p1N1FuUDdRNk5CalF0Y25ucDBINUFS?=
 =?utf-8?B?dVNCNHUrNFdQNllmbkdaNEJPOHJGcXA5cmRXZ0JMb2lrU21XbHBGWkY3Ry9o?=
 =?utf-8?B?R0g0NTNwWm5xRW5WMGw2YS9nb0xZUWJ5eFp3MGtnWE1oSTJNcDVJdHBlMlZn?=
 =?utf-8?B?ZUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59b7e6ec-a443-4ace-3955-08db3a9e5202
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:06:26.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bJADGOYvcZAnVUrB46hAkDAi5yxr3fbZGkYXqwpDiXEWhz+ANZzuR+kxe6llY9cDUzqqoRjlbbghjcqH0hmTGWv+6cBIh1PBTStprwiGGg4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/2023 1:59 PM, Haiyang Zhang wrote:
> Use napi_build_skb() instead of build_skb() to take advantage of the
> NAPI percpu caches to obtain skbuff_head.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

