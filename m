Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57B66AEFBA
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 19:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232829AbjCGS0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 13:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232819AbjCGSYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 13:24:49 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3775A1004;
        Tue,  7 Mar 2023 10:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678213212; x=1709749212;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gqY5qaJoEeaSClU6/6dbKhkZIGiLwnsvFGjGwY1utUQ=;
  b=JV+vYYJ/XSTBKDkWlQzxTu7XQYCNyPE9DHtGK5znSlmAVjhW01Ig31OD
   hC/RhXCQXtfRK3Kb+TmkyLBxWTmX3MTUxYXqE/WnP4Vd5c80pkIUBhoHu
   qOegUu57wEOxHgRbCsWu7b/8ROwvrlJUwPzW2hgQ3vx3Y5RZLvtcWwRGh
   /yOWtZ/Ef6dkt2OtDm2Pi7yyjfKXeHVUOclpcsXw2RukuhvCOmowefHu1
   3sCQcWhYLSDZUDx1V0YC4QLd0XDbgW2sC1/6LTJgAjR7y6dGQixIfS3v4
   yDIi/Zra9MsLQTRTIQFixuamoMxauy/mUmsDX8UhftqKcg+omdnCKf1cL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="333402273"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="333402273"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 10:20:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626630646"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="626630646"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 10:20:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 10:20:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 10:20:07 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 10:20:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6TIoO4vRRPMTsQDMshl46NdJeVvlnZsUXkOqOrxLsOmrqpnS7knKks2igiyq4gZu1zCNpIpJqUIBNkIBE2PENVy33AMJTb5lA840ByJ9jO30XM4asm5WmGpwjhsKjuYrKaqKbZLhG7K41YFzyOQgwTk+MVCFKHjSF3lJV1UvR1UObk5RZNdfSSCabDQdmTPG19wPWr2Z+PFdrGSEpqsClGJpE7wlC22Xj5jqMGMlM4n87cuuQBqEGyGhZzgRiybA5dTtIPyB0FCmTGMfyRdqrLdo4S7a1e5hH+npWb2IY46MxTiikW/ZadpETSbGiNdOQEGxQnFhj4GEn9mYQHfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZERvHZW/0zKvoSJGNxPi9MKdvCRrgthc/cEL9SohpE=;
 b=ColIMpW0yklJ/6GuVczQGx11Hrrr6eQLy4Aozq2daLwDfYCgVl2DaDjpB047BlO/pOAtOZuXLFNZsPdgFHDWoohUE5y8Hv2jTq2lOyisenLYCNrzQlVIKPEB35H2gN3C0UsaoVIxVCbZeKg/1+k15sFrhCQ3vAsjw/o9sipZpIby2hGny7YGthbUYw9a8Ef3P8NMwZ0TqPuItIzHACqEpk7mflY3jQG4F+SKjqkNPKEi3eWvc4qlgOFjJVdHkyKillcCrlU7h0EzXDOfOte5WvKOCIiNf5e+vwQoupJsOrxCBLLvrGiLwMjQTe7md64TgE1dYm2pAGvTkc/TMQuKlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CY8PR11MB7171.namprd11.prod.outlook.com (2603:10b6:930:92::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 18:20:05 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 18:20:05 +0000
Message-ID: <9e8a9346-37f4-7c5d-f1d0-cbba3de805db@intel.com>
Date:   Tue, 7 Mar 2023 19:14:01 +0100
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
 <0bc28bea-78f5-bcce-2d45-e6f6d1a7ed40@intel.com>
 <605cad27-2bf3-7913-877e-d2870892ecd5@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <605cad27-2bf3-7913-877e-d2870892ecd5@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::7) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CY8PR11MB7171:EE_
X-MS-Office365-Filtering-Correlation-Id: db6fba0f-c994-4351-0c54-08db1f38930d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0LkDa5iD7m+lje7r1DRFSHVYyE9ss0BhgV1AWFizpTKNyuNXCgZNcEKfpY0wIb/JgQEa/+omGWN4AJ8HOYXczk60NMMOoQgM9oD4SUhk5ficH0domnfh2/7KGl8dPon5AXb1W+ml1Pwb8266UegNNs1S6gwd536lFGR3s/dwNSGEdTk2Br7dbMWQV35wPTe8g7TUCZJQlq+CxvD/T/tkR9qjrrZhHw9Uss6fYb/2OXToNhk2yk0hWGTWq5BrADE/f6dSsMTrecjVbUAjJ5bqs36iq3qgxuZybamMnod/78PAilI9eKw+ggBrtNNR4WOeiff/tFSwskkNSKCMbAfS7bUBadQyhJkGUaxo+9fg+G+AfhTcFxV2P4CXO6ULoNDSdEMc6AUpg595dH7g2wsyu1bxyLQekJ3x7+KDNg7kJzVKiyw2ZWRDrfkIcMUE0h3WdyEdLR3RPLoWrHO1YpGqsOgWU24nEdApud0tsfRegfRy7Rl+G9tF7ZeeUWtwXhrHQaLHEgOBDSdwKmas1ufII7/qFRFVAqwg30g0saiW5h8ri6rtfEZv/rWkGNNiYnvp7tQ0G8F5wZaK4kh8LW9RucTWu+BUxk3AEE7g9uldZxRHG3NRsafNS5D9koKAo0iOGi3w3rRNlrFqDhvt1eoUvM2uquddm9/6U1PKEAWI24ORxhl5t/oyuJ0jeAUrgcC71dsCUSszOLEOMizXYjkG9AS6YsMGyr++agXvd+B8w4c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199018)(31686004)(2616005)(66899018)(66556008)(8676002)(7416002)(5660300002)(186003)(66946007)(6916009)(66476007)(41300700001)(53546011)(26005)(2906002)(82960400001)(6666004)(36756003)(8936002)(38100700002)(966005)(6486002)(4326008)(54906003)(478600001)(31696002)(6506007)(6512007)(86362001)(316002)(7744002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmpCZm1SbTRpV1d0Vmd1d2lXTEdyZHllaFpUeWFsazR0STNWUHhueWJxMjVS?=
 =?utf-8?B?SVREMmVsRkR6SDBERGlIaldSbEVhaVRzUi9sd1BTaU5lUk9BK2UyM0kxY3Jh?=
 =?utf-8?B?T0RhNXViRFhaWXlFaTRXZHdlcTdRVFI2UGZnZTYxWmxYU0F3eUJ6cDU2eU1R?=
 =?utf-8?B?Vm5GRGVFUGtYaXppa2tRb0RIbFdXbHNtbXkzTDlLM3FzOVl5Mzc1dm1pNnpL?=
 =?utf-8?B?ZW5ZZkpKTWkySERZNlRuQXc4T3FVRFRqbGlFbGU0RFBxK0dWMCtjN0Q1dTNB?=
 =?utf-8?B?M3k3QlBPOFcwRG1ueE9ObmN1U3drZ3doTjJCUVpwTDdXMFpMN08yTXBOT0tW?=
 =?utf-8?B?bEFadmhSTlEyQ1lLMnZqd2tRVExwTmNiL1FyN3J1aUNkMGMxdW5LOU1taERi?=
 =?utf-8?B?d1BQMmlUeDBVc0ZQakR5WHFVdkttSTBxTkUvSk4zeWY3RzZrcG9EWVNoSnQw?=
 =?utf-8?B?bzJzKzVld1lRYzdTMzFSc2JqS3VyeHVZeUs5QW93WkVqL3NaM3Y3cU9zL1NH?=
 =?utf-8?B?aFpoK0NOVlUrR0J4RHIwOUlrM1Nwa2ZLNGtDaFBSNXF3QWF2cUh5MnBWUC85?=
 =?utf-8?B?ZGx3R2dpRHFDMnhvdnJGR0JxeHkrOEpmZUpuVjJ4cWlHb3lrNFVDVUVUWTFs?=
 =?utf-8?B?bEdRbnc4ZnpxajZpREdIMmFUQlJlaFFNSTNzUjVzQlFJcWxxdTc0VDVTQ2lr?=
 =?utf-8?B?YzZ5TVp1WWROUkNseC8zUlJrT3FnblRWOEZxMTJDK0k3MlZNVUhvSXBmanRD?=
 =?utf-8?B?amloc2pLdndPTXdwZUtGdk1ESUJaM3oxOWhvK3lMa1duRDlUdXZLbExxTEFB?=
 =?utf-8?B?bWlFQUVFNjExalB4QjZRUmR3Q0Zua1dGUDB5cXowbWtaQXdzb2R2ZjFjOEpz?=
 =?utf-8?B?OU1MeVV0b0dybVVaRXgvdllPc2ZYdStBNEg3WXB4K29sd2NQa2doSkFmei9Q?=
 =?utf-8?B?UXRHN3liRUNTRTI4dDNPRDBrQW9GR3Q4bjJaWXJ6N0RSR0cxczJuK2lxUEpa?=
 =?utf-8?B?Umdldngrem5CMjhNbE5FVlRTcXo2Z1VRbnBkVzdkZFJDblk3UnZQOWpqSElm?=
 =?utf-8?B?SlVyN1hwajdBK2s0M0xPUDhJZTV6bk13TXJQdFJnYk5FZEtXbGYwZmJVWHpn?=
 =?utf-8?B?d1FSNXZIY1J6eHdFS2VxYWNJTkNQamFJU3NMb2N4bUtzc2MwaU1ZR2lDZytP?=
 =?utf-8?B?NUZGOTVGV3V4eG8zSHhZc3ZEUHc3VXZhTVd4dmljcDhpUjFlUU9CNDRjbTFO?=
 =?utf-8?B?bVJiVnBGME5uUm5leFFaZzcyUVNOVk5lWW9mTXlxTFRUcWpWR29odEJyTnVZ?=
 =?utf-8?B?Um5iTGhCRGo5Qk43VVFabU5pK3U0RHVoYXJsaEFCOWRuTERMUERFZFhJZ3ZO?=
 =?utf-8?B?THRxalRCMXhhR2hoSEE4TWtvVTBYKytyb1RNZVJQOUwySjF5cDIxbGJ2VXB5?=
 =?utf-8?B?bXpONDh3WTFtNlAwNlF4eVFWTlNmVVlrOEJDQXJrcnhMcVEzalJFM0NEWVpS?=
 =?utf-8?B?QXYwS2RvNjM4alJISmkxZ1AxSEFDTStlWHdpckRVQlY1YnpDZVVDSlBuamRx?=
 =?utf-8?B?dGVOYkV0cy94NHNxR2VXdE5xZm9DR2ViWWxLZTJ0TmI5YmczR3l1WU9tY09l?=
 =?utf-8?B?c2dVUW15NUdYamtmeEphYzNJdVlYUU42QlEyeE9OVDhXbmxnZzJDRlRXV01s?=
 =?utf-8?B?M0xDbFhmSStDbVNmNGlMbUlxTUNTRjRYeDNMaExDM2N4YW0xc2tla29xaUVm?=
 =?utf-8?B?cXZ0aU5mV1AzVEo0YlQwbE85NzRuYWhpSGhVMGE5NEJmVXB5UlJYN3R0UjdH?=
 =?utf-8?B?Y2tiYXFSMFpDb2IycUxDOU1sblJhV3dCelFqNTJtUGZoTUZYUTBYWVZuVjdl?=
 =?utf-8?B?M0tJTjBsQk1VTzFKcmplUksydlJvSW9BTU95eTZNTm5tVVVMRUtDb1Fjb3BU?=
 =?utf-8?B?ZHlVYnQrQktsWFkxVElVWUlSOUhNeTU3QTVJYllJbTF0YWVxN3JLSTlZYS9U?=
 =?utf-8?B?eTk3Wk12UFZFUVVLeDViRWdpRUdKUjBrRlpuUzhnNzA1K2pTSUgxYUFmRWRT?=
 =?utf-8?B?QUhXd2t3SEtjMGhQamptZnMrbUc1SlRFWkJVU0w0WXNkSnBBZUlTYVNwYWJV?=
 =?utf-8?B?ZnVxQTdTREV2L0hRVTJCRFBvSmc5NGpOeE5RNlNEUSt1cnBjWXVMd1V0UXFY?=
 =?utf-8?Q?OsdmdZvtpeZGMFmkIBPcALU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: db6fba0f-c994-4351-0c54-08db1f38930d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 18:20:05.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vCKp0WpVGHJexTTG/snL6GW0sQX2vWMsl3iEEisvDrsaqYMGvRuafo5C52pVlJWcL7g+42ldr7jjB/HdCqWjoxRYJZNYAdE6EFQqk24WXFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7171
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

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Tue, 7 Mar 2023 10:50:34 +0800

> On 2023/3/6 19:58, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Mon, 6 Mar 2023 09:09:31 +0800

[...]

>> Ah, from that perspective. Yes, you're probably right, but would need to
>> be tested anyway. I don't see any open problems with the PP recycling
>> right now on the lists, but someone may try to change it one day.
>> Anyway, this flag is only to do a quick test. We do have
>> sk_buff::pfmemalloc, but this flag doesn't mean every page from this skb
>> was pfmemalloced.
> 
> The point seems to be that sk_buff::pfmemalloc allow false positive, which
> means skb->pfmemalloc can be set to true while every page from this skb is
> not pfmemalloced as you mentioned.
> 
> While skb->pp_recycle can't allow false positive, if that happens, reference
> counting of the page will not be handled properly if pp and non-pp skb shares
> the page as the wireless adapter does.

You mean false-positives in both directions? Because if ->pp_recycle is
set, the stack can still free non-PP pages. In the opposite case, I mean
when ->pp_recycle is false and an skb page belongs to a page_pool, yes,
there'll be issues.
But I think the deal is to propagate the flag when you want to attach a
PP-backed page to the skb? I mean, if someone decides to mix pages with
different memory models, it's his responsibility to make sure everything
is fine, because it's not a common/intended way. Isn't it?

> 
>>
>>>
>>>>
>>>>>
>>>>> Anyway, I am not sure checking ::pp_magic is correct when a
>>>>> page will be passing between different subsystem and back to
>>>>> the network stack eventually, checking ::pp_magic may not be
>>>>> correct if this happens.
>>>>>
>>>>> Another way is to use the bottom two bits in bv_page, see:
>>>>> https://www.spinics.net/lists/netdev/msg874099.html

This one is interesting actually. We'd only need one bit -- which is
100% free and available in case of page pointers.

>>>>>
>>>>>>
>>>>>>>
>>>>>>>>  
>>>>>>>>  	/* Allow SKB to reuse area used by xdp_frame */
>>>>>>>>  	xdp_scrub_frame(xdpf);

[...]

Thanks,
Olek
