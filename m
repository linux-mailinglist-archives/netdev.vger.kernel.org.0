Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1356B93D4
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCNMdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCNMdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:33:05 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A17312CD5;
        Tue, 14 Mar 2023 05:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678797145; x=1710333145;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=slAZmoOpQlsjiAJ6lj5I3FNervuixa45Xl95mqs4eEE=;
  b=IFFiJ17OazOeyHWHqVnxnitTrCUMzK6EyhZM6+FCgfsrgSBg/CjIAfGe
   2GnhZs0nlu9deRbA4V/Fgj196Nwdo8ebr6AFIdsAyYN0SWLsz9vau7GeG
   9brzL7ml/63XENNO9t/ac2jm1N3Np+zjtZj5jwS7W9Oa6iKJVXBLjce38
   P9v9vrvHRqFQqCjyex44BAuWqaelqMt5KFK92LYtPLM4FpsHL9oi8B9SN
   2laeXcrcR3J6oXLIj6jqlyz4UvXURS0IkCjRh2JQflAmbGlZP5U3C4r1Y
   lwdphVDxWaE2zl4M+A0Xc2FvkHEja+ES6FUo3zvZCRYlkdNozdNnTCqiZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="334889191"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="334889191"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 05:29:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="748000985"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="748000985"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2023 05:29:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 05:28:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 05:28:59 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 05:28:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJdzHLXr0EysMzst62Xm68qrFfOd5NhpCj5tnUdNp1pOLRzsKvlOkIiBIULeZynwlgKzQWp2OGubu/7+So5h4hsh/Y3E2GleLBdM/X5KPVDtZDnW4jbgNjgZtRXXqh65xeWJ/7VNMPas1cxOLzdqEd5Kr4cbbAY9oHsP7M5oFyZwlFUqfaFj131bf19fPiph+zmuX1hlqC0nW8I3UIl9fVNiqOtj2Xx1mC0NKJkigzzMC6FlJ/4AkJdirvpCHG/VUKA42CC4XQLvXAhudP4cmiHfoO0lC3152MvO1wNkAIPcke1UriEM/enxn/mifWks3n0hBZRwYw4SVZFpS/vYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5DQj3hzUk0BL+z9T9I7R+hkclv0z75sNpI3z9f6w4U=;
 b=NXH3jz2ak/+aWfcTLV2i+wC4au258Ibgt1hhXOWRg/dNIrLHAEpEZcqsYgvz4cIIxkU5Ne7I7wb2W2MIz9ksa9MIQ0OBDHR1KN3mn3xQs0FZWFyjkE+WQs11dRjdc2EOr5LDfPniZkqzhRp7cndRcWWs0GIlS6c1LH3RExV5/8loGW0/62woqwiuE17wY5YN/2CyTLYRqjgB4wUZ5zJeSXLMPgUdkOLbpzGCFkxIP4q1+29JYtZtd6xe73g+wp+NTanbcV+SjNwsH5hF1f8vmk0ukiHfG8A5M6nGKYrOVScTLbpAgQY6LccYhJTknyXOuZ2PXZAtPfzaL4lctBbqXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA3PR11MB8046.namprd11.prod.outlook.com (2603:10b6:806:2fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 12:28:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 12:28:58 +0000
Message-ID: <4f65c860-9f0f-11ea-6e91-c35a62f084b3@intel.com>
Date:   Tue, 14 Mar 2023 13:27:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 4/4] xdp: remove unused
 {__,}xdp_release_frame()
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
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        "Mykola Lysenko" <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <20230313215553.1045175-5-aleksander.lobakin@intel.com>
 <42712a3f-544f-6e45-1468-9f9fae7922e8@huawei.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <42712a3f-544f-6e45-1468-9f9fae7922e8@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0014.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA3PR11MB8046:EE_
X-MS-Office365-Filtering-Correlation-Id: ed561250-0051-4f85-afe9-08db2487aef5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /loskJPmECWUbPsQxLVbAp7G0QpqXSaeVDY+92jw3y0Qw5wySDyCixryrlwWRIdfi95J1TziAwD04FHa/lA4ZRb0qFH6I9X9xAeWpRU4A7hb6GLmEhy+0Nnd49S/ZXa+Tw65lEISH9mpZzfXXSu6XnUaZMo9jMF73M0GnKyKRHjaUUoTWgdej4npf4Lu/e763bSMXsmc9LLUpw7orbjy/mUrbXqyEb/zqxrTWyOSxQL4UR6ueglIq+jMCYnU7wHnGOfXXx4CrsrKbcy/mOcygyb1RPVckx/xfi72/1k7kCWUqyK5qIN6+fdOp1LPR+pl7lzE9325TPdfSWdt/pt8MMvSiQvTIQhBhHbh+S/3+ZGtdAeAYh1276j8JekdAN1OMUe9OVz3gxq3d5/t23Vq+JZkDO44lO9HAzXFdnAk4effyI7khjhUjt2OwVZWuL9Q1TK+UJ4E9cSZB34Dt5mKbuqwvGsSMiwbO+Ls59U8KcCTHPucjMCGJc2afZ6aMyiTGXo+xSEeDXwlFgK+MgyASm2+6puKxBI/kCv2faX4V05v3Z0VUx+jgo+0WVxpEcGoulU8KM6Q34SfuVCdijT21CYIu0nHA/DvDrhzLHNjvARHvB3F6bJBsIIKTeW8goKUeZ/zG/SZ5fN43waPaXzRjc0HwoXHrGUq9QmtQrDGAclTt2vBYpNaeXKNDWgoC4A2kQmQbj6RaSF3ZNPFlN0CgeywyUahYpVBvpcDxfjzrZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199018)(31686004)(5660300002)(2616005)(8936002)(6512007)(4326008)(7416002)(26005)(186003)(41300700001)(6916009)(86362001)(36756003)(31696002)(83380400001)(316002)(2906002)(6506007)(53546011)(8676002)(6486002)(66946007)(54906003)(66476007)(66556008)(478600001)(82960400001)(38100700002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y25aTFBRdEkvRGdTSmc0ZFU3cm5uUTFzOXNHNEFzbFlXanVOZTBUd092ME9L?=
 =?utf-8?B?c2xIS2d1WTB4UHVWUmM0Rk9IT3JtTVUzOFliZ0VtZlVBRkN4NDJySW91OGVk?=
 =?utf-8?B?cDE2UWFNelpyVnNyaUNRd1MxVk1wL245UG52SGx4WEFBdmRkVE5VTkE5Q0R4?=
 =?utf-8?B?TWVpbmhjcmxhT1VKS1hveFY1dWtKV0pkLzNTL292MEJJc1NkOVpibkZKOFBK?=
 =?utf-8?B?SldFTXloNktIaFo1dWdiRHFHbmdQTnZNMEFRT2dpOUc4WFhsbk5tUzdsVUV1?=
 =?utf-8?B?OEFMZmRGOTNUcDQvMUNwTEJNMzhKRzdXZ3crVHNVTFhtZGM0SmV6bklSMWdF?=
 =?utf-8?B?KzBIUmNqUEtwZFcwZExEZUNNNk1yY0dHamRkeko2QURFakJVeFdMcFNCZkxh?=
 =?utf-8?B?ejdPWkttY2IrOUpVSncrR1JoUFRkTDIvVXpBLzR3dWZQQnF5TEYyeUlVMEhF?=
 =?utf-8?B?aEZtM1ZNWHhJMVFiOTNTcWdQNE1wU1hPQVRmbm5FMXNsc3UyejhBbWh0Ujc0?=
 =?utf-8?B?N1RiR2d1dzdyMXJKSGFQMmc1K01LU0d2V0srb0V5Q2FKbCthOEtSVWQ1Snh6?=
 =?utf-8?B?V2U4c0VyeEZ1Z2dqMUtYWUVwTE9remlORDlqN3lEWlpGeXBHaHR4ZkIzbGZ5?=
 =?utf-8?B?VEhQZXhkRldoZWtjWDBWWXBRdVVPZzBpSjF0ZHdVVld5eVpPeEhnaFM4QkQ4?=
 =?utf-8?B?T1hsTzZ3MDZCVEZJald3SFZSWTgzTWs1ZTNmaGFlV1ZyZ2ptekhzU0pyWEtN?=
 =?utf-8?B?TDYwSlA1Zk1HVG5uSzk0NjFVYVA5ZnVmQkJTNEUwcXF6cW1tS0FIT20xM0ov?=
 =?utf-8?B?cXNHSW54aVczZ0dWT1VBUjZuQ3RZbWx6M2ZqN0RqeENQYjQyZVFyTXlURk9a?=
 =?utf-8?B?NGwrckFpSnVCMGtCeUNOR0FFakhmNk80ZVd2QnBETmZDV2RzRlNaWGR2SFJU?=
 =?utf-8?B?Z0VEekFZMkdoVWZhc3FoZ3hXMkIrWlVDS3N4VXV5alJSR2dKRkVkUjh1bDJS?=
 =?utf-8?B?Yk00S0ZzQkVOanEwYi83aE4xVi9SaWVuVmMzcU5XYjZzREdlaHd0YjQrM3pB?=
 =?utf-8?B?aXhZMlA1Wk4vRk5ON25XK0hBWWZ5V0dxMFU1LzN3NDBqWkNGL3VMVzlXbER0?=
 =?utf-8?B?L0U4ZVVHOHhMdEhuV0xNdk5Majd6clZoblZYcG1HUmhVZDVxbTNiNHhvdjFa?=
 =?utf-8?B?NUZ1bTYrdzIrVENIRy82YXBQSjdnV3F2SlhxY3A1NGIyWjg2dThXUTZFeCtm?=
 =?utf-8?B?SzY5S3habTdvdlVlZk1QcnhOZmVtcFQyZzZGN1F4T2xoL3NYMVVkRTlUMWhs?=
 =?utf-8?B?RjkxMkJuUzZBQkVTQWxVUHFMeXk4bGVyQ1JOeXBxSEFXLy9sRVgzS0RBRTFz?=
 =?utf-8?B?Tkh3SFl6cC83K2ExYnU3cEc3RzF3T1o5U205eUk1UEtSWTVIYVMvOXVyWTZB?=
 =?utf-8?B?MTB0TmtZczlWU0h0dWF1ck1PU2NxWmdTYXlvTTBaQ2o4YklkUzZwSytyRWoz?=
 =?utf-8?B?eU1CN21uUWRab2Fhc2JuaUJZSmhNNTVnTXpHclROSXpwQWZhcTVxc2YvcGU5?=
 =?utf-8?B?OHVjekR2NXVENkRpQXBod3l3TlJ5RDlPWmtUMlp6K01TQmRwNW1nV2hjREl6?=
 =?utf-8?B?aGhQUFZVc0hsamc3ckJ0ZXZMbDhlazB5REtxSjY5V1NBMWprczRhWHhzNEFB?=
 =?utf-8?B?VExJazlqMHcxV1JXWWFRYW1hSEw4eWVkMEVFOUcyZ3UvVjI2cmtlOVBaN044?=
 =?utf-8?B?SXBTTkJVQ00ycDVia2xTZ3pIUHpnTWZURVNJZ1gzd1ZYbTY4czBUUm50WjEr?=
 =?utf-8?B?N09SZHZBZEZjRC82c0NnZVpTTTJKYStCQnpLeDZYS0MrbEZXQjVLdTFpdEVt?=
 =?utf-8?B?VzJSNUtwT1Znd3V1SmRSWis3UGtZNHp1Z3VXM1RXam1USWJBSXU3aUh0RHU4?=
 =?utf-8?B?UzZ2VlkrVmZpOXpKWUNiaFNCUVFveE1VVS9qZjJheGc2d0JJYTlWYTBmcDZT?=
 =?utf-8?B?cWUvNEZzQVVEdTlFNlR2UHJCTnV4SGtZWjQyQngzZFlMbUllTWNzNXJxSUNx?=
 =?utf-8?B?U3VqaFoxS3h1VldSVXVyYytpUFVqUm9HK2FNZjVQaXd2YWVJWFJ2VmFxZ3dN?=
 =?utf-8?B?cGU4MmxZNGF5SGgybFZEU2VGTnRhSXFlUEVRU0g2dEk2TWwvVUJSeGh5a0ZT?=
 =?utf-8?Q?qWEuwDTcDiBTG4QutH40DI8=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed561250-0051-4f85-afe9-08db2487aef5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 12:28:57.9141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSeqIJ39+x9CUw5gS/WPwDCHDTmzZ3tatcmGtX0dJIyoBCjoWcAkXKqSa+V+zJ57ge1XQGE7+P6PJ2gEB7p23Ffj69inAXlpFVMBwUfQTc4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8046
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
Date: Tue, 14 Mar 2023 19:37:23 +0800

> On 2023/3/14 5:55, Alexander Lobakin wrote:
>> __xdp_build_skb_from_frame() was the last user of
>> {__,}xdp_release_frame(), which detaches pages from the page_pool.

[...]

>> -/* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
>> -void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
>> -{
>> -	struct xdp_mem_allocator *xa;
>> -	struct page *page;
>> -
>> -	rcu_read_lock();
>> -	xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
>> -	page = virt_to_head_page(data);
>> -	if (xa)
>> -		page_pool_release_page(xa->page_pool, page);
> 
> page_pool_release_page() is only call here when xa is not NULL
> and mem->type == MEM_TYPE_PAGE_POOL.
> 
> But skb_mark_for_recycle() is call when mem->type == MEM_TYPE_PAGE_POOL
> without checking xa, it does not seems symmetric to patch 3, if this is
> intended?

Intended. page_pool_return_skb_page() checks for %PP_SIGNATURE and if
a page doesn't belong to any PP, it will be returned to the MM layer.
Moreover, cases `mem->type == MEM_TYPE_PAGE_POOL && xa == NULL` are more
of an exception rather than regular -- this means the page was released
from its PP before reaching the function and IIRC it's even impossible
with our current drivers. Adding a hashtable lookup to
{__,}xdp_build_skb_from_frame() would only add hotpath overhead with no
positive impact.

> 
>> -	rcu_read_unlock();
>> -}
>> -EXPORT_SYMBOL_GPL(__xdp_release_frame);
>> -
>>  void xdp_attachment_setup(struct xdp_attachment_info *info,
>>  			  struct netdev_bpf *bpf)
>>  {
>>

Thanks,
Olek
