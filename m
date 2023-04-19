Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E16E7A6D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjDSNQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbjDSNQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:16:03 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17E9146F1;
        Wed, 19 Apr 2023 06:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681910161; x=1713446161;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=c0Lwj9yzszjKsHWBNQF6y0LFzSuPWZATi653tqh49/M=;
  b=BmLxUOzHaQo4C7CoKusH1Y4/uujbbPm9yf7NKRphR4oqy1K0H5AeXLU/
   2z51gMuyhvD5Sfq2Un319gY8yP9LFGIPa6PHs8zcjQQvH/dtnmn94ShJA
   g5fUuGzuOdszWqEeJK7W61dIc964KpcA3B1qHRl9BaSfuz33R/4Ao/b/q
   YzqJd6H0MkSpmOKCvqKpmRZlgQ0aEiIiflNVMSeQzy6sjg9zFEyYgiLE2
   atlajUjH3IEpJWgg+5qZukhPFfRaTN5cp9ueS9wQr2v8hJ30Rdl0k5Tz5
   HXeMU7Ebw+Y67B452Nx/MepwCjQlAF0DuJvmGmGTL7Ys2OczIIGlCg0ZC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="345444005"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="345444005"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 06:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="721926633"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="721926633"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 19 Apr 2023 06:15:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 06:15:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 19 Apr 2023 06:15:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 19 Apr 2023 06:15:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 19 Apr 2023 06:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+9d2GXwLkqr+cFMy8Bb1uX7efSgRSkxeMwHA3U9sFUoCsJYryN8/ONDzoHOgioYG0xt9mteyrNPAOjvN2dxMGlAV85X0LURhCS3m1G0vrGOOMYDawha0xsb8gP7Bs0wDA6DuyAW0gosgd8nQ766K2RDoUxknAjqyn0i/odXBPTJoEe6Q0UTsVLh2R2YiYjGzl1Ja06S4k5JB+55niqw965gljM6wC36+oJXhXYrDsyh2L9t1JPus/DNLh7ipzVL7jCt5e1W0zWQr1oFJDOLkgJ6DDry8R0uBUpxY7yK8PxTplwjjgE3O4A22AySPhE8BXdEssiskjZhlJFIe2YVbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qEJI/qfVKzhHcZ28iP6Q3nPHgwjDfNgnawnjUStZ62Y=;
 b=Ww4dVCDRlbfbK7pS7ftzRXEsixnOhGXTdhYm5iiJ997LiTB7fdizWKA9/HF2Kjsm6FhSHgJEtnXL50Fy0KIvlE6eIedeTUYdggM2UFh+qvZ40WH1AJBQUf5ECgDMltdteBRgHhOwMIoMQ2LNV4b1L/3j4q5nDRa1ISPFruJUlmKq4OzGFZufo+gNTynWenmkm4NfJ1lnkPw1HdvwxozsEzghdFWb4le9E89y7NOCm/TA5s0fCgV6jOxUcfwp+ejVHMQRnzaBdeJQ7kDYC9ejzRjJJHrrfUnGIzxJtMp0q09LPwDZ1udatzykt3Y/yLUyDJn7OoUoq1/PP0GxZ7RtWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB5411.namprd11.prod.outlook.com (2603:10b6:610:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 13:15:54 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 13:15:54 +0000
Message-ID: <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
Date:   Wed, 19 Apr 2023 15:14:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <bpf@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org> <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org> <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org> <ZD95RY9PjVRi7qz3@infradead.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZD95RY9PjVRi7qz3@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0433.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB5411:EE_
X-MS-Office365-Filtering-Correlation-Id: b7f577fb-bdb2-45d3-2c6b-08db40d83475
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BEs6J6N826pbCaezS6fzBwj/qM0tl8fnqDYrxraMf1tUBNA2W25WEJJFH38aP7+LVVYnNDuoNCxlZ/x8He1U+q36BxLXFCqwh5EYBIfpXZwXWxwfWCvMgIoTUlBw+rbmpsAO4vxjWUF7EGSSGyRXIJft4O2Ef/05/ReV5t/9LK7TXpO8zv0V38EhmVsx13gc1EitsANPeVQw6zSDK9D6go2h84psyv+nX0sjIMKl8rWmmuYIBPCed5hVePgrEKAyIDNoweVS/4Qi9EV9bOaayzRwVNaYDfBzORXIyaZk3rHlLXhPw1txPLsK0yCqJPrnxNN4yYhMLGiSsoW0bElPbFBbwZEQ+6WlXFDz8SFWbHjsnjPRXuPNf0EVlHm68fqEDZgwYqbu+IQoDRoL33FqUhObN6twPirLU4h70KW7JPjbMrU43sKH2F1fDi7cjlIC6QyyebCsJ6ED+GOI4gLyJUlkPGsaZY4qNy7jEvu8LDe+JQGvzQk/mVZLGpG39yJq4DPGJ58wD/gW1QRgexz+3I7xOd2GDHYuZeCtFnPD20bvDyDdjAv/fgoMtfAikXMCt7PYn6S+FwR3VEAm3PWZzWuMbi1r8FU2/KPsxFo0MKi6//PMuoxYmlAK3LYTpw5k+sjVaawYBN/ViA3PP7GAlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(39860400002)(346002)(136003)(376002)(451199021)(110136005)(54906003)(36756003)(31696002)(86362001)(478600001)(82960400001)(41300700001)(8936002)(8676002)(38100700002)(7416002)(5660300002)(2906002)(66476007)(66556008)(66946007)(4326008)(316002)(6506007)(6512007)(26005)(186003)(6666004)(6486002)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RktFTnQvelJ1ZmpuUlZhRlpsTk02V1I4MzdBMkd0UHlWV3lWQzN0SXBnblJX?=
 =?utf-8?B?blI5S2p1Ym5uSXJOdDV6UzJRSjJTblphdGV6NXdiYVlkSDMwS09yaERSSGh0?=
 =?utf-8?B?N3d3UHc0SUZoN0hXai81UDdzbEVYRVhSeFRkbUZ6d2lBSUhGdlhUUjF5aWRv?=
 =?utf-8?B?ZHE5dExQc3RaK3pJbHpYbVZTKzhUdWNKMXBjZE1QNU1ZU3NSYW0zT3hZSUlF?=
 =?utf-8?B?dzE3bFV1RE9KK0hOVXJKa3Rla1hKM2todTRKanBWL0k5TFJ4NHJHYTUva1JO?=
 =?utf-8?B?UERkbE9BNkJtaEVOWmVMSzZLdDZRcG53YVFpMUJTL0pkc0xHMWsrVU1ORHNM?=
 =?utf-8?B?ejlSaEFHaFZINkxoU3M2NE1TdXAzM20yMCtIVmV4RE1McGsvSXpVNVdJYWdn?=
 =?utf-8?B?TXQ0Y2kzV0lDNmo0Wk56M1Yyc3lrdmZSUmU3alB3cFErQkNSbWVGMll2QzdT?=
 =?utf-8?B?cUhab3o5b2NWU0xTdkl3N0hpRnhiSVJiQXE0ajFVelNjemE0T1gxRHI3VTBJ?=
 =?utf-8?B?SkI5OURSeWNjK0lCKzVRSUg1WlQ5MENEeHRmUFZVN2RjcCtKbkdaUTJvNmwv?=
 =?utf-8?B?WlJzV2RqMUV3c0VMcHo0TjY0cDZXR0ZiZU5SK3ZYLzJaS2JzUUZQeTU3MWpv?=
 =?utf-8?B?dmZqZXY5L1FKU0g1MnVDZCtTNFVSVFhBazlJdzM0b2FVZmF3dHByaWNtN3o4?=
 =?utf-8?B?dFZ1Qzl0Znh4aG1HSVhNYzEwcVhpMk5TS1JZWHRiajB0Q1dRd2ZQWm4ySVBI?=
 =?utf-8?B?Z1Vrdmw5eWJJUWVVVldUc0FjOVg2SFFNWXJ4ZVFOUHpmajdkdE02dWZFUjUr?=
 =?utf-8?B?Q3QrY0xnTzdjU3piNnBqb01mWE9UL2hiRHZEaVpuOFNJa1Q3ZjVJMnFsY3Y5?=
 =?utf-8?B?RW5OS3RMaEFXUDc5d0VCTTdUTHI0WWtnbk5WUmtkbVVNcTluU1JJQnVtUXZp?=
 =?utf-8?B?MU1TYXIwTHYyT2xZb0EvazE1V0UwSlhUV1QzNm5DT2NuZ0dud2pwU3VXc0Jp?=
 =?utf-8?B?bVV2WkIyREZEVC9Ldno2clpuM3dVZmZYTzlocEcwbGREaDBVcGpKWVVBNml6?=
 =?utf-8?B?NzFJT3dpaEdYbGJZeENQZldLMFBadndXTjVIdU5NVUt0c3ZmV05WcWJtOHc3?=
 =?utf-8?B?VGVvQVVGSG40Z3NjRC9OdHFrOTQwYy9JWEZ3TkMvT1dTejB5T1BKb3dNa3FP?=
 =?utf-8?B?M1FzOThjcFg0eDBLSDUySTNGZSt5Q0t4Z3dIYUh5ck5hZzAvT0lIbUhnQ1Ro?=
 =?utf-8?B?Tm4veFRycDdWTGxIZFcwd205WmMwWHB2RmNNNi9CV0cvOGg2SmR6a20rT2gr?=
 =?utf-8?B?NnBEZWV4a0pML1lrOXRKeWlNVWM1VVAyK3lTUFdkdDdOb2NjUHRyUkM1WTFE?=
 =?utf-8?B?VFNIT0VidHlYV0ZidDJMc3lTSlFpVkpBLzNHZ29EK2lVTjlwQVpua0ZuYmFL?=
 =?utf-8?B?Y3pNaTI0cWxTVDA2RUJYTlFXQjhBeXg0TGl0VkdXNTlmcUdnSVI1NTNHOHFq?=
 =?utf-8?B?WkhsM25XQVBta3hYV2phN281S3Yyc0JUTmxDMGlET0cyYksvcmFoMFNZYm9v?=
 =?utf-8?B?T3ZSK2E3eUpoLzk1N093Qm5SdkpQNTNxRFM3Zi9xMkc3Nm5QYTdEcFZSRi9R?=
 =?utf-8?B?cHp3aHJLQlgvdXNrMWpLeGIxdnJOdjVmelhVYnFySWlNc1kwZ0V3Z3JjdFhB?=
 =?utf-8?B?RzZkRVhYRVA3TDc4WG0vOTltM25YRU91dUZLWHNpZXlYZ05VT2xUUGthM0Jl?=
 =?utf-8?B?Y3ovMnQ2Nkxxbzl5SWpNUytvcjhLOHFobHVlU0dBM2l5WTd1K1hibGpWVjA0?=
 =?utf-8?B?M3B2QTZMdmJOS1lPZkMveUFDSGtibnl3SzA5OXVWYUJzcXpKUVBRV29oWVl5?=
 =?utf-8?B?dzdOQldpWVV0Vjg1QkJKbGxyVVRYd2MyL25henZLMWRVMlIrS2RRTS9iK3Yr?=
 =?utf-8?B?NVovQmpRWUJMeWM3M3c2U2VHS2g1OG56bzJ3VEpaSnAxWjFzZFVXQS80N2FM?=
 =?utf-8?B?K3l3UndFVlNsQ2xwWlNGWEw3N284T3BxVGdQNG5TUFJkY25CYjJYZkFlYjJH?=
 =?utf-8?B?VDM3dTQ3Y0VsbmxudzRuV0djMVgwQmhyQjdobmV6Z0FVK0lLc0tTS0ZodjdG?=
 =?utf-8?B?VCt3c2lYYW95VTlzYXh1TG9GRzZ5OWI1WTA4NlFwZVdKYldTdXAyMGNsV05U?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f577fb-bdb2-45d3-2c6b-08db40d83475
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 13:15:54.3621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rrTgsk2uvJf5vyXOmclnjYgFnIiaDXL6VSicNbxJ4WM4MK6Is7ajAVZ56deolGvfNrKD3SilLIdWgkFhL7V4ZZIWE4oedLicaPgRy8oCMw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5411
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 18 Apr 2023 22:16:53 -0700

> On Mon, Apr 17, 2023 at 11:19:47PM -0700, Jakub Kicinski wrote:
>>> You can't just do dma mapping outside the driver, because there are
>>> drivers that do not require DMA mapping at all.  virtio is an example,
>>> but all the classic s390 drivers and some other odd virtualization
>>> ones are others.
>>
>> What bus are the classic s390 on (in terms of the device model)?
> 
> I think most of them are based on struct ccw_device, but I'll let the
> s390 maintainers fill in.
> 
> Another interesting case that isn't really relevant for your networking
> guys, but that caused as problems is RDMA.  For hardware RDMA devices
> it wants the ULPs to DMA map, but it turns out we have various software
> drivers that map to network drivers that do their own DMA mapping
> at a much lower layer and after potentially splitting packets or
> even mangling them.
> 
>>
>>>> I don't think it's reasonable to be bubbling up custom per-subsystem
>>>> DMA ops into all of them for the sake of virtio.  
>>>
>>> dma addresses and thus dma mappings are completely driver specific.
>>> Upper layers have no business looking at them.

Here it's not an "upper layer". XSk core doesn't look at them or pass
them between several drivers. It maps DMA solely via the struct device
passed from the driver and then just gets-sets addresses for this driver
only. Just like Page Pool does for regular Rx buffers. This got moved to
the XSk core to not repeat the same code pattern in each driver.

>>
>> Damn, that's unfortunate. Thinking aloud -- that means that if we want 
>> to continue to pull memory management out of networking drivers to
>> improve it for all, cross-optimize with the rest of the stack and
>> allow various upcoming forms of zero copy -- then we need to add an
>> equivalent of dma_ops and DMA API locally in networking?

Managing DMA addresses is totally fine as long as you don't try to pass
mapped addresses between different drivers :D Page Pool already does
that and I don't see a problem in that in general.

> 
> Can you explain what the actual use case is?
> 
>>From the original patchset I suspect it is dma mapping something very
> long term and then maybe doing syncs on it as needed?

As I mentioned, XSk provides some handy wrappers to map DMA for drivers.
Previously, XSk was supported by real hardware drivers only, but here
the developer tries to add support to virtio-net. I suspect he needs to
use DMA mapping functions different from which the regular driver use.
So this is far from dma_map_ops, the author picked wrong name :D
And correct, for XSk we map one big piece of memory only once and then
reuse it for buffers, no inflight map/unmap on hotpath (only syncs when
needed). So this mapping is longterm and is stored in XSk core structure
assigned to the driver which this mapping was done for.
I think Jakub thinks of something similar, but for the "regular" Rx/Tx,
not only XDP sockets :)

Thanks,
Olek
