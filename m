Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB5863B65C
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiK2AHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:07:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbiK2AGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:06:52 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D597D3F052;
        Mon, 28 Nov 2022 16:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669680404; x=1701216404;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=22ZfhrM1h8QZiouM2ga1ogr5r0LTyNyL9sg/BLEx1FM=;
  b=RzuFvusyrSFQn/AT5yO/xE/DlruMBgTQ372k1sTJveNlq3I1emKAjxXx
   KFFQHV4bL/6jve79oYeC9odlArXpFmMA+Uk1D9kCFNs3HQ6/H3lTG8PVk
   0GrhSmPg6jeOUrpeVJE4pqyWe+j8cW4oC7g12Hp5vRNOvBRvWMyEwmDKC
   hCBePAtzQv1o7bG5GNOs6NH49s/V2ALBbFLLMunb+qqaca5D3uj8t9KvK
   czMGJ+Dhf6d8Is3fZ7HvoIX925f++lTzBtv/m55mvKgaT+LGKQStSDT0s
   6Hyz+cNWXSzT8yLAUgljC1Z1eJxy96Bknxw6Drsm9uu3dZsn6cXaCOr/c
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="295356525"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="295356525"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:06:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="818015840"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="818015840"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 28 Nov 2022 16:06:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:06:42 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:06:42 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:06:42 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:06:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCmwOTYTUmZBIDLje1Abl2RapuZcuhjjJAGf3nh+vmlxQjdy0SCqpoFO5yvSJ1BUAiKND4LeI9H8mi99n8Pbc98pTHHdMDoRVqnqpc9953jemLSYuFCr2hK6jRzcnjQeixJvts+QgesSD8xkk/iDB/b3UcgfGdV+I8hl1lFp3lRdVVEHgNnj9Vj2MMbCSTRRiXDIpJ9h6xgbcbtV0uv5VKgYzAvodpseU7vSXv+rs4qsggkQYPwpo3xTSVkem9OBNmxldAUnk+ufNVELx2kbQTIY5qgn2kH0ekKNN8Dg7h0eQuJBQSHdZDzS3Er2O4NI2osjdY4WBoSbrCwc692omQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qrgvvC24W0ZleATmnyhL/JjTW7ffoKr8STekCU+zQTE=;
 b=hgfjI5XtTlC4pacJSc28w7qv+8eTl1M8asgChuJ/efUO1iDIsnXU2PvYsI7OuJEkkTLrsyJjF/txYaT21j3H8DvDNFjMbslIp4utWOrjKEhWqQ0s5mhi+AWkB1fAVB8qgxvHMzvfFApF3zi5oCH1bFswlpo0FtXHrXnckTt/Qie/7Vvesi/kMfer6ffJOU4RrI8JV60SfJrML6dh6pQQnueBeUxzOBbEBRRhjH8WVIHTsJp2tyEsyUjuOAzCQtQRLprFO0yyd5l14MmJ+PfEx5siZDu4Iz7kCjtVGmsfdnHl19kN9YTVY1nBcegfpSLujievYmYg5BKbdEKaxbqQdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4947.namprd11.prod.outlook.com (2603:10b6:303:99::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Tue, 29 Nov
 2022 00:06:40 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:06:40 +0000
Message-ID: <477f3642-608f-f710-9eed-6312a6e3f2d8@intel.com>
Date:   Mon, 28 Nov 2022 16:06:37 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v3] epoll: use refcount to reduce ep_mutex contention
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, <linux-fsdevel@vger.kernel.org>
CC:     Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Baron <jbaron@akamai.com>, <netdev@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>
References: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <1aedd7e87097bc4352ba658ac948c585a655785a.1669657846.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0356.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::31) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 86740074-c8b5-49c8-1d66-08dad19d9753
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zXI+CTq+QUyDwvf930z96fH6oFos9Yc3QFJ56ovTJDPkkLj+1acve6tNgFo9ncYRxDN6cBCZ7sjRfC67astaL+Zvq3EH2UCmi1t9B4MxG8ZuWSYA5+XGd41jAQmqYAzLdw0WsnXaE1+erFMQOSHxM1Sj/8WNQcq9+96shVbPh0QAYwnySJn9iYnNNA8RkyPsbUCs9C8+EhwKSfknuJlSGXNH4vAm/TqDKNxjcZnHKSGPkPHXrkOcQSTsoSlabKhTIrFyHRsJ36CjggakGZ/DHvJ2UKkq/18w30MZwy4Ne3ewsa8UXSUV9N+xesJ6aCEhh/UUwkyxISBwya6x3TcG2srec6HlR6zfszgCfdRHQLa6JLEB6am7scXqmfkum/Iv4ooJc5iBoajvGx3m8pW/JwKpUAXpel8UhYCgYR4HUhNNhD0XVvP3LleVrYgTvQmTgRQTlno0Sm3idvFfxAtCKaqibMiBauggsTBF/q7oAtfNYEIHkILmTomGSRk72/ZtTBtmh8ya9wmCyC2vefmSobZlsIwqxu0dFh9kVeXvVZCjSv7wo0wAYcSxUrcoviayXKfli5mE3l/VJ0lzkxhrMawtrA+WnfbGbp1H8z1ofHuLhXrVkeF9j8OcKhG5lo5FbOef5x9S9LlsDvRqZN+tErwPuYrB4MwNQDMM6hJxvSCzw2rbzOGEGHvmBc7HpU9SqQUNhAL77Uf6NlBCYmFcSu25A9wt1oqTdY3w6WTMe7dgvHTsZIrsMhgkidSOpmW5xW4ets5acq3dAJA9SElaZUQAYVSk+qWtHbyX/B3Acw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(316002)(54906003)(36756003)(53546011)(6506007)(38100700002)(41300700001)(4326008)(31696002)(8936002)(5660300002)(2616005)(186003)(86362001)(30864003)(6512007)(66556008)(26005)(6666004)(8676002)(82960400001)(66946007)(66476007)(83380400001)(2906002)(31686004)(966005)(6486002)(478600001)(66899015)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0dGZ20xc1ZUZDBqNDR5a1VzWWdabnFrS1ErcTBrR09aYXY3Q0tUU0pveGh4?=
 =?utf-8?B?MjlRUGRiZXIwcXB0RkJ6WUJzLzdqV3k5UU5abTErMm1XYjU1MnFST09SR1Er?=
 =?utf-8?B?WUMwMHY2WExKdkFWNUQwTituVTZkbWZyL1c5SHc3ZElxa3l6SkhVUy91ZlNE?=
 =?utf-8?B?VGFMRks3NEtxOGVMUHZUcHJWRldyUXZISWdxa3BPYVlWY3dXT2Y5dmplYWc5?=
 =?utf-8?B?UktQQXJ3K1FsMkV5NWNzd2hHeGlTV21IWU5yRjJPUnN6UkgxNFp1NUtQRTBJ?=
 =?utf-8?B?alE4ZythRW1BRUpycVFEOGNhMUR5QmwrSEVITTVWTHVTK3l1Q1h3NnV3a2NR?=
 =?utf-8?B?UUFzL0hSbm1jK2xVWjEreFJ1RUtyWUM3OEZqLzRYSDJXMGJubzk0RGtsS2xS?=
 =?utf-8?B?RzRIUk9ibWY1Yk84dmNXWE9pbnNyR0JUc0ovYS91NHJSRTJVNVJPWi9iOHRD?=
 =?utf-8?B?TUd4eW9rUXdTcm00TWVlWEZvSmZwWUlRZkQrLzRFYjlqaFd6M0MzWjB5Ynhj?=
 =?utf-8?B?K0JpVUtJblVscWgrM0FpMGEwdzZTNmM5bGxqUGF1NG9OVXZmNVBuRVNxQ1g2?=
 =?utf-8?B?WGt6M2hvSy9wNVBGVVY0YjIxd3VNU00xekMxcngxanROVGxEVlFEMDIrMUpo?=
 =?utf-8?B?bThjK3JNNVEzVWZ0eHdHTUgvWUJQV2Q2aG9lMDhBVDRSSW54WkZZck5TaFpY?=
 =?utf-8?B?OHVUanhhWDFHUEZBaGtxbDZYZEdpK293b0dTZU01c2drcmtCZFBhYWFoNGFG?=
 =?utf-8?B?L05JYnJmZ0QrK0huKzhvVzBGSk44bUtYRy9ZM2ZTOXdxc043aFRsYUFQMTJY?=
 =?utf-8?B?Y3VGa05ZYmlTM1ZhMFozek9IaDJhQmZzcWlsR2ZlMUhCYWdvRk1RNkdUWlo0?=
 =?utf-8?B?Y3BlOXZCV1c0bHlsTkZFZlc5RDM5ZXdaU0pSUTdGc3BvWTBvbXBYSTBtclBx?=
 =?utf-8?B?TDEzZ1lSeEFmOXJiNHNxUW1pcjM1OTRRT1JYT0oya3BDTC9ZVmI5OUxxWjRD?=
 =?utf-8?B?QkJNMmNJVHREZHN4d2J0d3d2bVJxWDFYNWppUzZ4Y0ttL2hUSVVxdlZHOGF4?=
 =?utf-8?B?eDdsRXhvNHJIMVFmS1dMTjBmRTRzZ1ZDcCtIaEt3MkJoWmdqWWxkVHVuUWtJ?=
 =?utf-8?B?WHMzdGozMnluekZEQ3lWT1ZnY3N2WTIvN01pL3ZOMVR2N01oUjcrR2MwVUxr?=
 =?utf-8?B?MGJoWWdpTUE3Tng4ZFk5L1p5MlVRU2lBcDU0SURDY3VRWEFNVjQ1R2QvWFhJ?=
 =?utf-8?B?STRscHRPZExGNnhYWGc3UFptQ2VpOU90NzJUWTBsK1lIUUhpTm5RYkhMaTRo?=
 =?utf-8?B?aEgyaWZyWUErMmJLMzJPcGw2UlZiMFdJSFRVeWU0ckRCK1FMNExIV1hVV3o5?=
 =?utf-8?B?SjZmZnVPOUNBUjJMQkdtYU9MTGdaSnArMnRkTWtTay9DUHQrTXh1L3dxQjQz?=
 =?utf-8?B?cXhGVkVXUU1VYXZLZVViN0Y3Ni92TnZoby9uV3NHV0lSQ2RHc1lqVG0xa09o?=
 =?utf-8?B?TVBEV0RjcnVYR25QK0ozb0lWclZ6Sk9IMnYvNk0wbUZQVEQ0VVd4c1FNWVZp?=
 =?utf-8?B?OEo4ZFRYbmYzOVFWT2NMdHdPKzVzcHhrUmtiWXY5ZDBnSVlxMkNRL1pwdk1I?=
 =?utf-8?B?anhJU3RqUVE2ZHNwZEQxd0kwVXg2Wi9jQ3RaUmdCNzI4a2lZSncrYk1NblVy?=
 =?utf-8?B?eFkxTnlhc1hkclJYa01PcDhkK05PUWlsdFovNEdzNjg5VnoxYUR3QjZjUlFz?=
 =?utf-8?B?TzBJdkJrL3FMajhYcjlRb0ZaeWdGNS9VRElyRDg5ckI3cmxHODIydW9JNlVX?=
 =?utf-8?B?THdweHFueC9DSWFpUmkyRE1EUTV2dmJhU2FDL2pBYUQxeGhyVjJYeXluM0tE?=
 =?utf-8?B?cEZQYUwxNWFsYllUZ2JMYWgwa0VkVUZoTnZSbE1uRVZMQXJUTHZ6TlZPVWpO?=
 =?utf-8?B?S1JUT1ltY1NRc29pWjFPWFdaVnErVXJsOHNsMmx2L29aWTJtV3BSRFppYUV0?=
 =?utf-8?B?WU1Od1dHdFQyVktYVW03UGI5OExyWkM0eVRwTXRoMzlCb0NSVFB5QklySTFP?=
 =?utf-8?B?WC9OLy9zNXpScmxidTB0ZGpuOEtmSlpOVHNNTXBTU1E5VlJOWHhUZGp5TnJY?=
 =?utf-8?B?L2RYUnByK1NtVkRpbEZpOGtjRE92Ym96RlIzZW5LVUxFT2VNVEhyWktBdjlz?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 86740074-c8b5-49c8-1d66-08dad19d9753
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 00:06:40.7112
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymHvUjqFmXKtSAqNqdcw0Gm+si+rbkt1omP7mrvfirqGe9AjIHNvcf+QIfU5BUcI8xO4Qi8fXCagUdbgHs6BGu2WQaX3V4yZXXNGshUVPyo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 10:00 AM, Paolo Abeni wrote:
> We are observing huge contention on the epmutex during an http
> connection/rate test:
> 
>   83.17% 0.25%  nginx            [kernel.kallsyms]         [k] entry_SYSCALL_64_after_hwframe
> [...]
>             |--66.96%--__fput
>                        |--60.04%--eventpoll_release_file
>                                   |--58.41%--__mutex_lock.isra.6
>                                             |--56.56%--osq_lock
> 
> The application is multi-threaded, creates a new epoll entry for
> each incoming connection, and does not delete it before the
> connection shutdown - that is, before the connection's fd close().
> 
> Many different threads compete frequently for the epmutex lock,
> affecting the overall performance.
> 
> To reduce the contention this patch introduces explicit reference counting
> for the eventpoll struct. Each registered event acquires a reference,
> and references are released at ep_remove() time.
> 
> Additionally, this introduces a new 'dying' flag to prevent races between
> ep_free() and eventpoll_release_file(): the latter marks, under f_lock
> spinlock, each epitem as before removing it, while ep_free() does not
> touch dying epitems.
> 
> The eventpoll struct is released by whoever - among ep_free() and
> eventpoll_release_file() drops its last reference.
> 
> With all the above in place, we can drop the epmutex usage at disposal time.
> 
> Overall this produces a significant performance improvement in the
> mentioned connection/rate scenario: the mutex operations disappear from
> the topmost offenders in the perf report, and the measured connections/rate
> grows by ~60%.
> 
> Tested-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
> v3: (addresses comments from Eric Biggers)
> - introduce the 'dying' flag, use it to dispose immediately struct eventpoll
>    at ep_free() time
> - update a leftover comments still referring to old epmutex usage
> 
> v2 at:
> https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/
> 
> v1 at:
> https://lore.kernel.org/linux-fsdevel/f35e58ed5af8131f0f402c3dc6c3033fa96d1843.1669312208.git.pabeni@redhat.com/
> 
> Previous related effort at:
> https://lore.kernel.org/linux-fsdevel/20190727113542.162213-1-cj.chengjian@huawei.com/
> https://lkml.org/lkml/2017/10/28/81
> ---
>   fs/eventpoll.c | 171 +++++++++++++++++++++++++++++++------------------
>   1 file changed, 109 insertions(+), 62 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 52954d4637b5..af22e5e6f683 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -57,13 +57,7 @@
>    * we need a lock that will allow us to sleep. This lock is a
>    * mutex (ep->mtx). It is acquired during the event transfer loop,
>    * during epoll_ctl(EPOLL_CTL_DEL) and during eventpoll_release_file().
> - * Then we also need a global mutex to serialize eventpoll_release_file()
> - * and ep_free().
> - * This mutex is acquired by ep_free() during the epoll file
> - * cleanup path and it is also acquired by eventpoll_release_file()
> - * if a file has been pushed inside an epoll set and it is then
> - * close()d without a previous call to epoll_ctl(EPOLL_CTL_DEL).
> - * It is also acquired when inserting an epoll fd onto another epoll
> + * The epmutex is acquired when inserting an epoll fd onto another epoll
>    * fd. We do this so that we walk the epoll tree and ensure that this
>    * insertion does not create a cycle of epoll file descriptors, which
>    * could lead to deadlock. We need a global mutex to prevent two
> @@ -153,6 +147,13 @@ struct epitem {
>   	/* The file descriptor information this item refers to */
>   	struct epoll_filefd ffd;
>   
> +	/*
> +	 * Protected by file->f_lock, true for to-be-released epitem already
> +	 * removed from the "struct file" items list; together with
> +	 * eventpoll->refcount orchestrates "struct eventpoll" disposal
> +	 */
> +	bool dying;
> +
>   	/* List containing poll wait queues */
>   	struct eppoll_entry *pwqlist;
>   
> @@ -217,6 +218,12 @@ struct eventpoll {
>   	u64 gen;
>   	struct hlist_head refs;
>   
> +	/*
> +	 * usage count, protected by mtx, used together with epitem->dying to
> +	 * orchestrate the disposal of this struct
> +	 */
> +	unsigned int refcount;
> +

Why not use a kref (or at least struct refcount?) those provide some 
guarantees like guaranteeing atomic operations and saturation when the 
refcount value would overflow.

>   #ifdef CONFIG_NET_RX_BUSY_POLL
>   	/* used to track busy poll napi_id */
>   	unsigned int napi_id;
> @@ -240,9 +247,7 @@ struct ep_pqueue {
>   /* Maximum number of epoll watched descriptors, per user */
>   static long max_user_watches __read_mostly;
>   
> -/*
> - * This mutex is used to serialize ep_free() and eventpoll_release_file().
> - */
> +/* Used for cycles detection */
>   static DEFINE_MUTEX(epmutex);
>   
>   static u64 loop_check_gen = 0;
> @@ -555,8 +560,7 @@ static void ep_remove_wait_queue(struct eppoll_entry *pwq)
>   
>   /*
>    * This function unregisters poll callbacks from the associated file
> - * descriptor.  Must be called with "mtx" held (or "epmutex" if called from
> - * ep_free).
> + * descriptor.  Must be called with "mtx" held.
>    */
>   static void ep_unregister_pollwait(struct eventpoll *ep, struct epitem *epi)
>   {
> @@ -679,11 +683,38 @@ static void epi_rcu_free(struct rcu_head *head)
>   	kmem_cache_free(epi_cache, epi);
>   }
>   
> +static void ep_get(struct eventpoll *ep)
> +{
> +	ep->refcount++;
> +}
This would become something like "kref_get(&ep->kref)" or maybe even 
something like "kref_get_unless_zero" or some other form depending on 
exactly how you acquire a pointer to an eventpoll structure.

> +
> +/*
> + * Returns true if the event poll can be disposed
> + */
> +static bool ep_put(struct eventpoll *ep)
> +{
> +	if (--ep->refcount)
> +		return false;
> +
> +	WARN_ON_ONCE(!RB_EMPTY_ROOT(&ep->rbr.rb_root));
> +	return true;
> +}

This could become kref_put(&ep->kref, ep_dispose).

> +
> +static void ep_dispose(struct eventpoll *ep)
> +{
> +	mutex_destroy(&ep->mtx);
> +	free_uid(ep->user);
> +	wakeup_source_unregister(ep->ws);
> +	kfree(ep);
> +}
This would takea  kref pointer, use container_of to get to the eventpoll 
structure, and then perform necessary cleanup once all references drop.

The exact specific steps here and whether it would still be safe to call 
mutex_destroy is a bit unclear since you typically would only call 
mutex_destroy when its absolutely sure that no one has locked the mutex.

If you're careful about how kref_get is used you can avoid needing to be 
holding mutex_destroy when ep_dispose is called. Since krefs are struct 
refcount and thus atomic you don't need the lock to protect access or 
ordering guaruantees.

See Documentation/core-api/kref.rst for a better overview of the API and 
how to use it safely. I suspect that with just kref you could also 
safely avoid the "dying" flag as well, but I am not 100% sure.

> +
>   /*
>    * Removes a "struct epitem" from the eventpoll RB tree and deallocates
>    * all the associated resources. Must be called with "mtx" held.
> + * If the dying flag is set, do the removal only if force is true.
> + * Returns true if the eventpoll can be disposed.
>    */
> -static int ep_remove(struct eventpoll *ep, struct epitem *epi)
> +static bool __ep_remove(struct eventpoll *ep, struct epitem *epi, bool force)
>   {
>   	struct file *file = epi->ffd.file;
>   	struct epitems_head *to_free;
> @@ -698,6 +729,11 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>   
>   	/* Remove the current item from the list of epoll hooks */
>   	spin_lock(&file->f_lock);
> +	if (epi->dying && !force) {
> +		spin_unlock(&file->f_lock);
> +		return false;
> +	}
> +
>   	to_free = NULL;
>   	head = file->f_ep;
>   	if (head->first == &epi->fllink && !epi->fllink.next) {
> @@ -731,28 +767,28 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
>   	call_rcu(&epi->rcu, epi_rcu_free);
>   
>   	percpu_counter_dec(&ep->user->epoll_watches);
> +	return ep_put(ep);
> +}
>   
> -	return 0;
> +/*
> + * ep_remove variant for callers owing an additional reference to the ep
> + */
> +static void ep_remove_safe(struct eventpoll *ep, struct epitem *epi)
> +{
> +	WARN_ON_ONCE(__ep_remove(ep, epi, false));
>   }
>   
>   static void ep_free(struct eventpoll *ep)
>   {
>   	struct rb_node *rbp;
>   	struct epitem *epi;
> +	bool dispose;
>   
>   	/* We need to release all tasks waiting for these file */
>   	if (waitqueue_active(&ep->poll_wait))
>   		ep_poll_safewake(ep, NULL);
>   
> -	/*
> -	 * We need to lock this because we could be hit by
> -	 * eventpoll_release_file() while we're freeing the "struct eventpoll".
> -	 * We do not need to hold "ep->mtx" here because the epoll file
> -	 * is on the way to be removed and no one has references to it
> -	 * anymore. The only hit might come from eventpoll_release_file() but
> -	 * holding "epmutex" is sufficient here.
> -	 */
> -	mutex_lock(&epmutex);
> +	mutex_lock(&ep->mtx);
>   
>   	/*
>   	 * Walks through the whole tree by unregistering poll callbacks.
> @@ -766,25 +802,21 @@ static void ep_free(struct eventpoll *ep)
>   
>   	/*
>   	 * Walks through the whole tree by freeing each "struct epitem". At this
> -	 * point we are sure no poll callbacks will be lingering around, and also by
> -	 * holding "epmutex" we can be sure that no file cleanup code will hit
> -	 * us during this operation. So we can avoid the lock on "ep->lock".
> -	 * We do not need to lock ep->mtx, either, we only do it to prevent
> -	 * a lockdep warning.
> +	 * point we are sure no poll callbacks will be lingering around.
> +	 * Since we still own a reference to the eventpoll struct, the loop can't
> +	 * dispose it.
>   	 */
> -	mutex_lock(&ep->mtx);
>   	while ((rbp = rb_first_cached(&ep->rbr)) != NULL) {
>   		epi = rb_entry(rbp, struct epitem, rbn);
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>   		cond_resched();
>   	}
> + > +	dispose = ep_put(ep);
>   	mutex_unlock(&ep->mtx);
>   
> -	mutex_unlock(&epmutex);
> -	mutex_destroy(&ep->mtx);
> -	free_uid(ep->user);
> -	wakeup_source_unregister(ep->ws);
> -	kfree(ep);
> +	if (dispose)
> +		ep_dispose(ep);
>   }
>   
>   static int ep_eventpoll_release(struct inode *inode, struct file *file)
> @@ -904,33 +936,35 @@ void eventpoll_release_file(struct file *file)
>   {
>   	struct eventpoll *ep;
>   	struct epitem *epi;
> -	struct hlist_node *next;
> +	bool dispose;
>   
>   	/*
> -	 * We don't want to get "file->f_lock" because it is not
> -	 * necessary. It is not necessary because we're in the "struct file"
> -	 * cleanup path, and this means that no one is using this file anymore.
> -	 * So, for example, epoll_ctl() cannot hit here since if we reach this
> -	 * point, the file counter already went to zero and fget() would fail.
> -	 * The only hit might come from ep_free() but by holding the mutex
> -	 * will correctly serialize the operation. We do need to acquire
> -	 * "ep->mtx" after "epmutex" because ep_remove() requires it when called
> -	 * from anywhere but ep_free().
> -	 *
> -	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
> +	 * Use the 'dying' flag to prevent a concurrent ep_free() from touching
> +	 * the epitems list before eventpoll_release_file() can access the
> +	 * ep->mtx.
>   	 */
> -	mutex_lock(&epmutex);
> -	if (unlikely(!file->f_ep)) {
> -		mutex_unlock(&epmutex);
> -		return;
> -	}
> -	hlist_for_each_entry_safe(epi, next, file->f_ep, fllink) {
> +again:
> +	spin_lock(&file->f_lock);
> +	if (file->f_ep && file->f_ep->first) {
> +		/* detach from ep tree */
> +		epi = hlist_entry(file->f_ep->first, struct epitem, fllink);
> +		epi->dying = true;
> +		spin_unlock(&file->f_lock);
> +
> +		/*
> +		 * ep access is safe as we still own a reference to the ep
> +		 * struct
> +		 */
>   		ep = epi->ep;
> -		mutex_lock_nested(&ep->mtx, 0);
> -		ep_remove(ep, epi);
> +		mutex_lock(&ep->mtx);
> +		dispose = __ep_remove(ep, epi, true);
>   		mutex_unlock(&ep->mtx);
> +
> +		if (dispose)
> +			ep_dispose(ep);
> +		goto again;
>   	}
> -	mutex_unlock(&epmutex);
> +	spin_unlock(&file->f_lock);
>   }
>   
>   static int ep_alloc(struct eventpoll **pep)
> @@ -953,6 +987,7 @@ static int ep_alloc(struct eventpoll **pep)
>   	ep->rbr = RB_ROOT_CACHED;
>   	ep->ovflist = EP_UNACTIVE_PTR;
>   	ep->user = user;
> +	ep->refcount = 1;
>   
>   	*pep = ep;
>   
> @@ -1494,16 +1529,22 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
>   	if (tep)
>   		mutex_unlock(&tep->mtx);
>   
> +	/*
> +	 * ep_remove() calls in the later error paths can't lead to ep_dispose()
> +	 * as overall will lead to no refcount changes
> +	 */
> +	ep_get(ep); > +
>   	/* now check if we've created too many backpaths */
>   	if (unlikely(full_check && reverse_path_check())) {
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>   		return -EINVAL;
>   	}
>   
>   	if (epi->event.events & EPOLLWAKEUP) {
>   		error = ep_create_wakeup_source(epi);
>   		if (error) {
> -			ep_remove(ep, epi);
> +			ep_remove_safe(ep, epi);
>   			return error;
>   		}
>   	}
> @@ -1527,7 +1568,7 @@ static int ep_insert(struct eventpoll *ep, const struct epoll_event *event,
>   	 * high memory pressure.
>   	 */
>   	if (unlikely(!epq.epi)) {
> -		ep_remove(ep, epi);
> +		ep_remove_safe(ep, epi);
>   		return -ENOMEM;
>   	}
>   
> @@ -2165,10 +2206,16 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
>   			error = -EEXIST;
>   		break;
>   	case EPOLL_CTL_DEL:
> -		if (epi)
> -			error = ep_remove(ep, epi);
> -		else
> +		if (epi) {
> +			/*
> +			 * The eventpoll itself is still alive: the refcount
> +			 * can't go to zero here.
> +			 */
> +			ep_remove_safe(ep, epi);
> +			error = 0;
> +		} else {
>   			error = -ENOENT;
> +		}
>   		break;
>   	case EPOLL_CTL_MOD:
>   		if (epi) {
