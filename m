Return-Path: <netdev+bounces-1290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE5536FD320
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 01:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB1CA1C20C60
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 23:49:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8C5168A6;
	Tue,  9 May 2023 23:49:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADEC19937
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:49:54 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDCC4EE8;
	Tue,  9 May 2023 16:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683676193; x=1715212193;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=f3tOs5+BZel4qlTWm2j265Zk2GE8IHXHf8Qs9jBZyXY=;
  b=Il6mUAwUGDN324Y+DjAVIXSfiBDu4vEeun98LKoVMTaA33Fs3YuF1YpC
   PsD+M5CMsLejckp1b+3wz9SpmH+nBH1btFkR3X4NZUcY63u5HU3tkj/oz
   1qwALQ8J/G1VuY2wm/lajY/XEdPs5O418dt2ofiaWLlRuKdMgRduKAY7q
   8+hGS5hBGIwq1HKqT0fI8NQVEMC26bl5upcR9Lear5yyrj6JGM22xaJgd
   vXb9X6zAWIJ5rVKwLjtjske75OeJEBZg1NSr0pIucn4FCiK5TRELZ+fpb
   QOMbA9okprnMfkvuz0ncHYj73keIun37egZuui9BMgNQ1H2Gu2XFIkrvb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="348919397"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="348919397"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 16:49:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="788713665"
X-IronPort-AV: E=Sophos;i="5.99,263,1677571200"; 
   d="scan'208";a="788713665"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2023 16:49:52 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 9 May 2023 16:49:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 9 May 2023 16:49:51 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 9 May 2023 16:49:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnMxcrliJnZp5ru218bneSsSf/qf2hTXwwtKDKoNbDR4uG1dXAkuRvfAYuE1JAfFt+0d6NVinyr8V7yYDK9ecu6BgScss0dcyQon6yXigB1ZXSkN3a+ONejwyNevfWjvU0gDqjC0lbALiEPl8IdRAQf3HVcPznKyjXiNefLroKIg8rXHNg+feFkcgrH0CZuM/VTFy/nUf42qfyASwRxzjjSd4YbV5HhH0njLvQQZVDsPxns52ijbZz7jJ6abwPIN7z0n/AIkx4/CnWfdUElu5XN+Ss2pxFEfETRdwX/CuV2BUgWDQimvDmTVuI8oA0bqyyTyWWFQcPWErQmETpFJfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Iu/i7DZXWbiytteUqjt91lixlM+WC7MLaCioOGO+rQ=;
 b=ZSLutFP261QNdG8SsWnP7avv05hBbyCuIY128PLkJw+tD9wlOiJRAbgy66SIvK9iphWFhDtzPyM4EbCKO+xhz90UIE1+lqX+Ljz3piQB+T1frATI8lCRLTa0iYcD5y5krj8M+oDn2jvPq2Mq7J61T3C99b15T3Cr0UwTy0JAPrlWDMDPvX0SHleRjHbJciXMThu1P1cTHH4QXaC/hygLzt7oRDjPV3U8M1Qkb4LKI6xQDcfkADbKQwfgMTPXgXUdV+kQgdtxWGshYeI+/m58MHOXL8a3ZQp4b+FIWH4L4DI/Mt+6neLBmgYXHq7U/1zcxlTARN8EputIwYUy6bfxSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH7PR11MB7515.namprd11.prod.outlook.com (2603:10b6:510:278::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Tue, 9 May
 2023 23:49:48 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00%4]) with mapi id 15.20.6387.018; Tue, 9 May 2023
 23:49:48 +0000
Message-ID: <2345b39d-366d-cd37-1026-2663679b4bed@intel.com>
Date: Tue, 9 May 2023 16:49:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH net-next v1 2/2] net: remove __skb_frag_set_page()
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Simon Horman
	<simon.horman@corigine.com>
References: <20230509114634.21079-1-linyunsheng@huawei.com>
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230509114634.21079-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::22) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|PH7PR11MB7515:EE_
X-MS-Office365-Filtering-Correlation-Id: b02e4c65-2aad-478d-a8df-08db50e812d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHxmWZjYMEE3eVOt5LGrH6iE6WzkaJAATUnvtHNSYoWVMgPLL2AR5iQknBqxEp/9jdXK1lUvwPxDEFaybAygPEQopmmdcGmuuARNBVgpug91NOafecTvbA8sL4W/RocAGVAnpTJWdvEOAajlcFGkaEIeDkXIF4ZBy9yLEK1jqjhyMMAHUzzO6hJk0SFDqldm9EbVx3UFBSQX5KqO3wMhpwKjYthD+k/ldFnAlv2ZTcjK/y83UNYUFRHphnm0Rv0NPfiV8kwSlCOqI704WAcVI7h6mJVzVAA9SyxRaguHMN0ci2NBb7A5OF5Wu5UwKhEi1dK59jpBZtv00n6qF6T1H/On0PZV4r0BIVnvnsdNsxL1cHpyRNcbfBwC0+sUyWzNnlLSh8q7R2WbxTVp+PQGHR0vMFAW8eQrgxboZSCQixfgYeOFpwPYMm5eDYkWqtaZDBBzQqaScRNKwTf3CoVISUwDs1nCe2iLeKbjqcdrHaV4u/BoUSvJLK7R1PxH6mizI/V6Kk4MXvgm8A7jdMiJ6YuqmsitvSYMp3zO/W41tLfd8UJZ85XnA9Cw0LvSsgvJmIbGXEqTxBOclkPpaGNEPOpnqhVs7t/pi1Vg+wkhMLWT9CwpT++WurHIut0WFZRWc6nFeJj7OEYszvD0ZLQvWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(366004)(346002)(451199021)(66556008)(31686004)(86362001)(478600001)(66476007)(41300700001)(66946007)(31696002)(36756003)(6486002)(316002)(4326008)(8936002)(8676002)(44832011)(38100700002)(82960400001)(5660300002)(2906002)(4744005)(186003)(26005)(6512007)(53546011)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlhNRnlhdmdqYVlHVXR5OHFkcjIwYnBQSHJpRHNid1VZL1kxbVExelQ1Szhu?=
 =?utf-8?B?UUtSU1U3NjE4dXNVbElGZlFNUFZCNDhFVm5Pa1hPSytLQi9IdHpiQlA2L2Fj?=
 =?utf-8?B?TGFYeUNDSDl4cDNVMXgzaC9DZmo4SEdUWVRGQXh6ZEhNVzJYQnJyZ05iVVNX?=
 =?utf-8?B?cFZUL2lia0xNaWF1Z3daQUVLbHI5YnVLVnk5RU1kNDJpcXBKS0NrZVdZdzBU?=
 =?utf-8?B?YTZjbmJCeFdmN0hsTThXWGdMT0FoMnM5WVI0MFNobVhDTzUxRHYwa2FDWUti?=
 =?utf-8?B?OEM0dHBmRTJHRnNJSlE5MndoQWFlRzcwVDdPc0RsclFMQ2lKSXA0aGE2UVdF?=
 =?utf-8?B?em5Rb244WDRyS3RRbk9HclVVZDhzVWYzdUNuWEJUc2RhK2FaSEhDQmxaNk9L?=
 =?utf-8?B?Z3pUZVIvNXRLcFpxZS9neXBZdFpGa2lZTjMvRFdad1FxeG9qeUUxRlRVSnRt?=
 =?utf-8?B?eUw1MXExN0Q0SzRiUmJFalRoV0lKVXRxeE1ubGhuR0xVMURIUmV3M3lWRWFp?=
 =?utf-8?B?R3ZlNndTQ2cwZWZJMzJ5UWw4bWR2aG1tNkFkOEl2TDJaR1U5eGhhVUhFenpw?=
 =?utf-8?B?dGlaRURHZnNOVUxZZ2picFlQbzlPbzhodzFnN2tEeTJscHpOaklETXdrdjBz?=
 =?utf-8?B?dmFLa2F2NXRWbG5oSldtNS9UMVlEc2dKV1NqY0ZhMFRTbXZHa2V3Zlk5djcy?=
 =?utf-8?B?alR5RXhIcWVLc0hPYVM4WTFtZkJCNkFFTnFQYll0MEowMUZJRjI2b1hjRzRo?=
 =?utf-8?B?ckNtcDlMWmI1N2lYTGd0eXNoQ1FVTmx2dnVIT2UxZU5XWSszWmcveG9KaEFG?=
 =?utf-8?B?VW5ka0VrVW4rMzNmZGpxOXdlSEgyUEE5ZWFjeVdhYVpGMW5JbWt4NDl2ZVBB?=
 =?utf-8?B?RU1EZ2JmMjNlN2tHL1N0bHN1L09peUZ3TFRPS2dkcjg0VG1SbkNjNlI0MHNZ?=
 =?utf-8?B?blpNSkdmYlVTdUFhSzA4cGZDTFNCVmdjcGxlSzA4MlhRMFg0WUp0eEJLamZ0?=
 =?utf-8?B?NkZ5SUtHdTBBYVE1R0ErUDEzd3NVNHRYa3hndlB1UjFrcWtGMXU3SUpZWkdt?=
 =?utf-8?B?eHROeFFFdXA1eElPb0IrekQ2ZisraTIrSXlVTTVyTGVYcGhKOWNNaXR0blpP?=
 =?utf-8?B?cHA0UlkrRGI5NG11UVhXeUNNRUc3V2xPQklkdGR5YmgzZHpQZ05qZm1iNnNk?=
 =?utf-8?B?MW0wWklXS3JQK05WSlkzakVqK3cvY0ErN2dscHoyMy9PMXYya1Z0SVBzMjEr?=
 =?utf-8?B?NUMwV29uNVgwVTRLZytITlhySGdRSVhMNVJRNDVXVXNxSkh5ZWEvamFHcVRB?=
 =?utf-8?B?d3dJQWtJcVltWEc4MlplcjJWcDVzQTZ3bjVwK3lINTVNaWNtcU55OUNNUjRm?=
 =?utf-8?B?ZzVJU1JBR3QwaU9sK28zSHRpWlVDR0l6OEp1bjBGQzlhS24yVm5xM0RVbUVp?=
 =?utf-8?B?MkZqWERHeW1kMmRCZGYzN3haVVNDNnR4WThwYmJLNGlZdGdsRmV2NllFeWFY?=
 =?utf-8?B?RnloVTRrcXdEQmN3YmxiZWY0eHVUNnY0cENKb0J0TmFyOFN0MzNyQkNHSWtW?=
 =?utf-8?B?aEhpcFZJQ0w3WjVoYVlDc2R3QW84dFh6bDBUM2gydXhkKzl5OVl0eXc0UGhw?=
 =?utf-8?B?czJyNmI3TnZkRzV0SnBId1p1cUpqNEkydGtlQkRDZlpRTCtNck1kY1FwZzdU?=
 =?utf-8?B?WXloNzVQeWYxLzJHVVQ4aWtWWVYvdkhQN3M4bDVGQ0lKNzF1NFdDWmJOMW9T?=
 =?utf-8?B?RkpXeHo0RWo0eEVoWkt4WXVlVWtOYXF6ZFZZMU1ZVGkwVUJBODFMYnhjclpp?=
 =?utf-8?B?MU9WUC8xa0VRY1hLcVNNMHluc0Q3bmVHTXdFdk5MdlZ0SFBDNGptbGVIMUF5?=
 =?utf-8?B?NEJuOWhrcEF2NmE4RVFmWE0vYWtQQmdHZXhTVjI3U3VvQWhwK2xremEzeUQ0?=
 =?utf-8?B?QTdEb01IaWZ4U25zYk83ZFphbmVIOWhEcHZuaFFtdVZOcEFxL1lHVzBWbHox?=
 =?utf-8?B?aitpb2t2RFBkanRhQ2JRcHhLbWdSTEF2aHlFaVNHcjBFQjY4M3k3SW00VERm?=
 =?utf-8?B?U3FVek1TRTVWOENBN0luWnQxUENhNkEzaXYxanNrRXBPak0yRXR2cDNCWitt?=
 =?utf-8?B?K1E4cGZZN2NkY0w0V3lpWmpSSW5iRmd0TytVOGdvZ1JUNmhFMm9OcDBubE9w?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b02e4c65-2aad-478d-a8df-08db50e812d0
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 23:49:48.2755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BN450nzJ9DQtWExjmJjAM8KdRjPiA22o4ndtx5kKQTlj+SuZgF1VGMFLwVlQq1WURxefxnSbNFyklNeiitPp1fbkI+o4/HRYqwFvzVo8vkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7515
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/9/2023 4:46 AM, Yunsheng Lin wrote:
> The remaining users calling __skb_frag_set_page() with
> page being NULL seems to be doing defensive programming,
> as shinfo->nr_frags is already decremented, so remove
> them.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> RFC: remove a local variable as pointed out by Simon.

Makes sense.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

CC: Simon




