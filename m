Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94CB6BD0BD
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCPNYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCPNYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:24:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE18193D6;
        Thu, 16 Mar 2023 06:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678973054; x=1710509054;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/XL6fr1GqrnNwNjpLwXCe6reQDtKe/VOIwOi96Do9KI=;
  b=l6tSDV/T668Q7dTU+3gBMpQTF+54D/K1LZIrO6ggLxCUP9XCylAyfxmg
   LfwBhz7T4YyrROd2H3oRZQjHoS8a4iTxBCrR0cw8kpsgXvk2I77YNZfP5
   SW9GY6fZTuIPboseVwvtB43VWqne+7KWZCNscZl2ItkvgQ4rMxAgfFQJL
   og4cEmQIzoc9uphekrNAk90hiydJ7YOeX2iahMREu1KXjzqs1Dho5TIbN
   YjbhHqMYUXihUzfDilAcEeSfZI493mYXlIcKM/ZCQmFmq7uhwISXmoFQ5
   YnvQc+2OeS/VpLiHxfG2X4B10oliVRCwlu3OdNden974rwohV6BEs17Pn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="338003053"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="338003053"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 06:24:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10650"; a="710108301"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="710108301"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 16 Mar 2023 06:24:12 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 06:24:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 06:24:12 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 06:24:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsE8LwAYvbJYS2ABv6eLdo4Oct30fRksVTm/OkxnDg0GYUS01A+ub/tx7qEKLqQRfI8l3gouKAPc/9NFpdCvrWQvilmNhY7FDrDDlRQTTw1W2fZgQGPdjZd/5xKahw2k4q0EDWLHRn5VFJE20FWsUVq91bscrVQRDnCMZOUBUDEZqGkysQ7+OsPNli3mqzPzWI+bQc/5Dgopl6lBiiivWBsu4AgmP6f4FMJ02wdWQJRbTmLaHjGt3sSIRkeuVstXN2NhSRWUtOBqsN+dpRy0fcbVMbgdFvj6VEG3K9VP0hJ2LqUbJeEAeekIF/fC/UnOruEkNfD1IeDuRh1gz38TXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fI+bWE9/in4eC1IAu/iGPn0dhCD9sq45Bn9VCnW8pBI=;
 b=mtmCYN+QgX6i9zvQoqPkQrQouzXH6c2gX2CwTzUmNciT1jxYt/iSxJLjfxS3f2bjB/D9v+3/j1YyCcYhPw7TyT9TQSCKnYxJLt+8I3H3mMqr/8OhuFn2oh9UrBD7jL7cmjBzxDmAQtsshrbOAlqXRZLrjfpLmZvL5iK/Qs/NCPVokIAWxCQiCQp1mNjUPw8/+KyQ1kPildWs4g/PAHcff40l3ka9xLtT0VyN29mZxUJrBasReeFdf/DuxhEIczJwmdphsWi2C7K9jUPSn/Yfowf5+tZeDnerfEppi3VzHnBvlpXM0qlzw8SJ907XRu2iL4IfBk0Bp0JCk4QOXl5VEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW3PR11MB4572.namprd11.prod.outlook.com (2603:10b6:303:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 13:24:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.029; Thu, 16 Mar 2023
 13:24:08 +0000
Message-ID: <7b7ec89a-2a3a-421f-88a4-42c93dcb8b47@intel.com>
Date:   Thu, 16 Mar 2023 14:22:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH bpf-next v3 0/4] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        Paolo Abeni <pabeni@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <ca1385b5-b3f8-73f3-276c-a2a08ec09aa0@intel.com>
 <CAADnVQJDz3hBEJ7kohXJ4HUZWZdbRRamfJbrZ6KUaRubBKQmfA@mail.gmail.com>
 <CAADnVQ+B_JOU+EpP=DKhbY9yXdN6GiRPnpTTXfEZ9sNkUeb-yQ@mail.gmail.com>
 <5b360c35-1671-c0b8-78ca-517c7cd535ae@intel.com>
 <2bda95d8-6238-f9ef-7dce-aa9320013a13@intel.com>
 <de59c0fca26400305ab34cc89e468e395b6256ac.camel@linux.ibm.com>
 <e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com>
 <62f8f903-4eaf-1b82-a2e9-43179bcd10a1@intel.com>
 <8341c1d9f935f410438e79d3bd8a9cc50aefe105.camel@linux.ibm.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <8341c1d9f935f410438e79d3bd8a9cc50aefe105.camel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0203.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::11) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW3PR11MB4572:EE_
X-MS-Office365-Filtering-Correlation-Id: c49899b7-87a6-43dc-6318-08db2621b8c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xL9FgMhDlu7Y04m5WeV5dZsEu4Mt1tz20u8HrQwjql/lAAiY9500YpQ0uMsJgiyxBMrb5chc+KX8SnEwO+EcbJce4dB+Hbg4wQn4VKIO85Uzn4zcW3W8vAtTscTTIVPGUh2r8n0ICLsspGQYAY61RgYpN8knF6O1sIgt3dkEW+BgCJcDIXcQPO4TiKDcQiiOlo1NB3Use2Ggb+TP+saMvXjcouWfZkbO5JqUdEkFp8AOuySFZvcf682ur3moE443QF99yyzG6uf1d4pVLNeeYibA1MigEixvxQxollgibGt1kSsL/B9IyePhuR7iFpmxLJEYcpSn8Vr2fryP6IdIvh4+wojmTFV8m6rBh61qUo7nGFAYVAlmyM1JZiQkGWpp2wCpEh7hhSBroJstchE2rxm8EwsNDow+bm4pJVMTbVf80yGpuitYYaajtSTlue8Hvq51XBpQqc4hx1B6rsfITuYvNGwouecQWKMI255YxsMrXeUSEXlX9W/cs1J2uPD/v79G2YArPakdFFAHNX6uBQ8mviUOgF5D/4VlCO1VXBbnlAviRcZJfgRNpcny6u9BYpiUpzjpXaCJ5eC4LyMsIJthgL0VFQ5zC0EI9+I2MQstSvfIZ4JqV3Vt0sR2hGAJR099krSl8qQ9qesKxh6m7AH0s+k5K45/AyN94ajeVCGQDjjah5MaIE0xJgQdtRPYeOtXjDmy8C8JMdzwVo4m/8nNQqo5RkqUGm70cX3XOPI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(366004)(396003)(39860400002)(451199018)(4326008)(8676002)(66476007)(41300700001)(66556008)(66946007)(2906002)(82960400001)(38100700002)(5660300002)(8936002)(7416002)(6666004)(26005)(6486002)(66899018)(6506007)(86362001)(53546011)(31696002)(31686004)(2616005)(186003)(6512007)(36756003)(316002)(54906003)(110136005)(83380400001)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGdiK3c5UlBvZUZSY1lXRkpDTmcvVFQ0aU5mRHY0S21qcTRRVEFBWnpiYjZq?=
 =?utf-8?B?WXFxak5jb09zRU51TkxIR3ZyZXhxdlQzNjRwOGYrUTlXcHZrOFpnZlBkY2ds?=
 =?utf-8?B?bzNxMFpJWWtudnJtWHZ2Wk0yWEhQUUc1M1NtaU9TS002V2NtRitKWjRuMk11?=
 =?utf-8?B?VGE1bGtDdTBYV1cwaE1FZmdYL2JwbTFjZGlRQ0VGZEVleEJISGNKSTdoSElE?=
 =?utf-8?B?S0pPekt5cEZlWHYxSmJEZVJ5MjJxd2RiaUxBdHRwaVQxWE5ZR1JZQ3FZK2oz?=
 =?utf-8?B?TERvanlKQzNTUSt3SG5vSmZQYVZLd2V6dXpyY2NaTDYwTXp0UDFpeFJoVy9a?=
 =?utf-8?B?T2ZTVmRNY3R6T2djdWRoN0pwTWE3dFF3L2hiUWlDeXdrS1F2djZYc2NHazVX?=
 =?utf-8?B?TDFOWUllRzRoemlicVZVTjVlYXdKVEUzc2lIVEErMXRiSWhVSVBneis0NjhN?=
 =?utf-8?B?UFBSZGQwK1RWQlQ0ekhaaFpLbER3alI2dU5kbm5UU3FpZWZJRyt0dURzaFBE?=
 =?utf-8?B?NlZCRDhyVSs0MjV0SXY4WDErSm4wZisxQVRQN0p5blVFK2tHSEZocldLQU0v?=
 =?utf-8?B?ZGtHenFJZXpNM1EzamhpQXVlTXlEWjMyZWw2TVpYbE1kTjhtMVdRRU5wUWZu?=
 =?utf-8?B?QWFhTGpwQ1ErRk1acWEwM0FQb20vVUpJVUVSS1V4U25EU04zMlpRZWNBdUJz?=
 =?utf-8?B?eURSTFVnMysvS1ZUY1MxZExWV3piblI1WXUwZGFvVHBOV3VaK2VzVTI4TURY?=
 =?utf-8?B?UEhndnB1NDg1VkpNRjFDQ3ZhMGJXaVd3SzZtNFdmN1hLQnRVVDdQb2NvQjFa?=
 =?utf-8?B?alN6QnFCdHhCQkJ5RWFkcHEwV1ltWllMdHM4bERLeWJMU2pacFpkWFpIRFFE?=
 =?utf-8?B?eFg5bUdYV3FBZzFmbWlKN0cycGlpaUxjdVdBTEdaNnlrOUR2b2w5Z3dXSG1h?=
 =?utf-8?B?WXJ6ZGNXQjJoZy81eElTNHZJeldZY3V0cTN1aXZQVVlwUC9NY1Ivc3V0SjNC?=
 =?utf-8?B?SjEwU0xIN01xa1ZJUEFUMmRRRFltZWZPdmw1TVE5UWt1UCtSdG5Bb1lDVFFC?=
 =?utf-8?B?eUw4dXBtRGh5MWdidXIvcmZCKytScStzS0dPWkhyek95S0ZGY281N2NWcnlz?=
 =?utf-8?B?ck1QMFpHamg3SjVoSG5WRFR6bHZnMC9wQm5FTmFxK3Z5V1BEa24yODJPdXJK?=
 =?utf-8?B?SDEveUMrWXNPWW5PdzZmUXJPU0s1VC9NNi9HSUtoM1B3TVlzaGJzYlJ3cVdM?=
 =?utf-8?B?eCtTRFVpUVBXR2x1SUtwVU40eEVFenRSSHZUbEVxQ09nczJhWFRqbkFiWDIz?=
 =?utf-8?B?eXVNcFNURy9xZCtUZDVUTklqMHBIREFiNzh2bTRJbzV5b1l2OUh2aGlyOUUv?=
 =?utf-8?B?bjY2VmpxVXBJY3dManVzRk42Ny9XcUNKNGxrUVRGN1BXc0dyTFc4aU9YRFI0?=
 =?utf-8?B?RVdPR2NYemc3OWR2eWcyakZtK09jUHNOQW1oYVFhOW95eCsxRXFKNjBOU0dv?=
 =?utf-8?B?amppRkttdm9seHBBOEdzdEJlWGFxdG94NmlEblhtS2Y4STBzL2FjZDdVUmFC?=
 =?utf-8?B?V2FQalB4ZjF3emZ6cTg2bGJrSkxSM2pqa1NIT2xJaHdEb0h3UjJGQUtVbnNF?=
 =?utf-8?B?bldEd1hkRW1BeUgrdnhQK3QvSlhmaWFhZTg1ODcyaEhNdDJyd0xoTlE5dmVY?=
 =?utf-8?B?VTJZMFVWa3RwRXFiQVJVRFJoUXk1QzRORGFsaXRQd1M1Z0V1RWdHSm1MM1Y2?=
 =?utf-8?B?QWNpQkhMMFBkQ2JnOHJWbHdvTUpKcTN4M1FNV0JvTEg1UnYvaG92akoxcVdV?=
 =?utf-8?B?SVpwZTBZbDNla0ZpL3dhckJmd3hSNDk1a3FOTHZORXMyK3ptSjJHaWJseGJB?=
 =?utf-8?B?bUpYRDVER0Y2QjdxZVB4di9IZGxmb0pZZS85czlxSklsM01HL1gwVFY2ODFK?=
 =?utf-8?B?M2J4ZlU4T2dpcm1EVDd6OUEzTE1xNkhNUjZRKytSSU9Cc0FNVTNkS0dQVXdI?=
 =?utf-8?B?VElLKytiT2VveFpKaFprVElueVYrUXN3QzVybjdaQjhqNEViSE9xRGRueWlS?=
 =?utf-8?B?cStqcmhqTHJmc09UaVVETXFjZ2xhc1NjSzRvNHk4dExMV0dWSTN5SE96NGg2?=
 =?utf-8?B?Mi9QN0tPZTlzVC9sblNwRlA1QUg0ayt2SXdaRGlBT0VxUUhkVFZtU3Jja051?=
 =?utf-8?Q?mH/lHJ8Z1z4Kz2BzzjMExUQ=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c49899b7-87a6-43dc-6318-08db2621b8c0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 13:24:08.1886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aYeIwUmgNj+QV8pTRQ8/m1SUQAoBXf6WIxW7/CMUTVG2WF1hQb2hsaIxSA5mHzLJFCYDyiMVVuQSAC9YeWwnHbyRtSaMUvTdZlceHpETM88=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4572
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

From: Ilya Leoshkevich <iii@linux.ibm.com>
Date: Wed, 15 Mar 2023 19:26:00 +0100

> On Wed, 2023-03-15 at 19:12 +0100, Alexander Lobakin wrote:
>> From: Ilya Leoshkevich <iii@linux.ibm.com>
>> Date: Wed, 15 Mar 2023 19:00:47 +0100
>>
>>> On Wed, 2023-03-15 at 15:54 +0100, Ilya Leoshkevich wrote:
>>>> On Wed, 2023-03-15 at 11:54 +0100, Alexander Lobakin wrote:
>>>>> From: Alexander Lobakin <aleksander.lobakin@intel.com>
>>>>> Date: Wed, 15 Mar 2023 10:56:25 +0100
>>>>>
>>>>>> From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
>>>>>> Date: Tue, 14 Mar 2023 16:54:25 -0700
>>>>>>
>>>>>>> On Tue, Mar 14, 2023 at 11:52 AM Alexei Starovoitov
>>>>>>> <alexei.starovoitov@gmail.com> wrote:
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>> test_xdp_do_redirect:PASS:prog_run 0 nsec
>>>>>>> test_xdp_do_redirect:PASS:pkt_count_xdp 0 nsec
>>>>>>> test_xdp_do_redirect:PASS:pkt_count_zero 0 nsec
>>>>>>> test_xdp_do_redirect:FAIL:pkt_count_tc unexpected
>>>>>>> pkt_count_tc:
>>>>>>> actual
>>>>>>> 220 != expected 9998
>>>>>>> test_max_pkt_size:PASS:prog_run_max_size 0 nsec
>>>>>>> test_max_pkt_size:PASS:prog_run_too_big 0 nsec
>>>>>>> close_netns:PASS:setns 0 nsec
>>>>>>> #289 xdp_do_redirect:FAIL
>>>>>>> Summary: 270/1674 PASSED, 30 SKIPPED, 1 FAILED
>>>>>>>
>>>>>>> Alex,
>>>>>>> could you please take a look at why it's happening?
>>>>>>>
>>>>>>> I suspect it's an endianness issue in:
>>>>>>>         if (*metadata != 0x42)
>>>>>>>                 return XDP_ABORTED;
>>>>>>> but your patch didn't change that,
>>>>>>> so I'm not sure why it worked before.
>>>>>>
>>>>>> Sure, lemme fix it real quick.
>>>>>
>>>>> Hi Ilya,
>>>>>
>>>>> Do you have s390 testing setups? Maybe you could take a look,
>>>>> since
>>>>> I
>>>>> don't have one and can't debug it? Doesn't seem to be
>>>>> Endianness
>>>>> issue.
>>>>> I mean, I have this (the below patch), but not sure it will fix
>>>>> anything -- IIRC eBPF arch always matches the host arch ._.
>>>>> I can't figure out from the code what does happen wrongly :s
>>>>> And it
>>>>> happens only on s390.
>>>>>
>>>>> Thanks,
>>>>> Olek
>>>>> ---
>>>>> diff --git
>>>>> a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>>>> b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>>>> index 662b6c6c5ed7..b21371668447 100644
>>>>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>>>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
>>>>> @@ -107,7 +107,7 @@ void test_xdp_do_redirect(void)
>>>>>                             .attach_point = BPF_TC_INGRESS);
>>>>>  
>>>>>         memcpy(&data[sizeof(__u32)], &pkt_udp,
>>>>> sizeof(pkt_udp));
>>>>> -       *((__u32 *)data) = 0x42; /* metadata test value */
>>>>> +       *((__u32 *)data) = htonl(0x42); /* metadata test value
>>>>> */
>>>>>  
>>>>>         skel = test_xdp_do_redirect__open();
>>>>>         if (!ASSERT_OK_PTR(skel, "skel"))
>>>>> diff --git
>>>>> a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>>>> b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>>>> index cd2d4e3258b8..2475bc30ced2 100644
>>>>> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>>>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>>>> @@ -1,5 +1,6 @@
>>>>>  // SPDX-License-Identifier: GPL-2.0
>>>>>  #include <vmlinux.h>
>>>>> +#include <bpf/bpf_endian.h>
>>>>>  #include <bpf/bpf_helpers.h>
>>>>>  
>>>>>  #define ETH_ALEN 6
>>>>> @@ -28,7 +29,7 @@ volatile int retcode = XDP_REDIRECT;
>>>>>  SEC("xdp")
>>>>>  int xdp_redirect(struct xdp_md *xdp)
>>>>>  {
>>>>> -       __u32 *metadata = (void *)(long)xdp->data_meta;
>>>>> +       __be32 *metadata = (void *)(long)xdp->data_meta;
>>>>>         void *data_end = (void *)(long)xdp->data_end;
>>>>>         void *data = (void *)(long)xdp->data;
>>>>>  
>>>>> @@ -44,7 +45,7 @@ int xdp_redirect(struct xdp_md *xdp)
>>>>>         if (metadata + 1 > data)
>>>>>                 return XDP_ABORTED;
>>>>>  
>>>>> -       if (*metadata != 0x42)
>>>>> +       if (*metadata != __bpf_htonl(0x42))
>>>>>                 return XDP_ABORTED;
>>>>>  
>>>>>         if (*payload == MARK_XMIT)
>>>>
>>>> Okay, I'll take a look. Two quick observations for now:
>>>>
>>>> - Unfortunately the above patch does not help.
>>>>
>>>> - In dmesg I see:
>>>>
>>>>     Driver unsupported XDP return value 0 on prog xdp_redirect
>>>> (id
>>>> 23)
>>>>     dev N/A, expect packet loss!
>>>
>>> I haven't identified the issue yet, but I have found a couple more
>>> things that might be helpful:
>>>
>>> - In problematic cases metadata contains 0, so this is not an
>>>   endianness issue. data is still reasonable though. I'm trying to
>>>   understand what is causing this.
>>>
>>> - Applying the following diff:
>>>
>>> --- a/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
>>> @@ -52,7 +52,7 @@ int xdp_redirect(struct xdp_md *xdp)
>>>  
>>>         *payload = MARK_IN;
>>>  
>>> -       if (bpf_xdp_adjust_meta(xdp, 4))
>>> +       if (false && bpf_xdp_adjust_meta(xdp, 4))
>>>                 return XDP_ABORTED;
>>>  
>>>         if (retcode > XDP_PASS)
>>>
>>> causes a kernel panic even on x86_64:
>>>
>>> BUG: kernel NULL pointer dereference, address:
>>> 0000000000000d28       
>>> ...
>>> Call Trace:            
>>>  <TASK>                                                            
>>>    
>>>  build_skb_around+0x22/0xb0
>>>  __xdp_build_skb_from_frame+0x4e/0x130
>>>  bpf_test_run_xdp_live+0x65f/0x7c0
>>>  ? __pfx_xdp_test_run_init_page+0x10/0x10
>>>  bpf_prog_test_run_xdp+0x2ba/0x480
>>>  bpf_prog_test_run+0xeb/0x110
>>>  __sys_bpf+0x2b9/0x570
>>>  __x64_sys_bpf+0x1c/0x30
>>>  do_syscall_64+0x48/0xa0
>>>  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>>
>>> I haven't looked into this at all, but I believe this needs to be
>>> fixed - BPF should never cause kernel panics.
>>
>> This one is basically the same issue as syzbot mentioned today
>> (separate
>> subthread). I'm waiting for a feedback from Toke on which way of
>> fixing
>> he'd prefer (I proposed 2). If those zeroed metadata magics that you
>> observe have the same roots with the panic, one fix will smash 2
>> issues.
>>
>> Thanks,
>> Olek
> 
> Sounds good, I will wait for an update then.
> 
> In the meantime, I found the code that overwrites the metadata:
> 
> #0  0x0000000000aaeee6 in neigh_hh_output (hh=0x83258df0,
> skb=0x88142200) at linux/include/net/neighbour.h:503
> #1  0x0000000000ab2cda in neigh_output (skip_cache=false,
> skb=0x88142200, n=<optimized out>) at linux/include/net/neighbour.h:544
> #2  ip6_finish_output2 (net=net@entry=0x88edba00, sk=sk@entry=0x0,
> skb=skb@entry=0x88142200) at linux/net/ipv6/ip6_output.c:134
> #3  0x0000000000ab4cbc in __ip6_finish_output (skb=0x88142200, sk=0x0,
> net=0x88edba00) at linux/net/ipv6/ip6_output.c:195
> #4  ip6_finish_output (net=0x88edba00, sk=0x0, skb=0x88142200) at
> linux/net/ipv6/ip6_output.c:206
> #5  0x0000000000ab5cbc in dst_input (skb=<optimized out>) at
> linux/include/net/dst.h:454
> #6  ip6_sublist_rcv_finish (head=head@entry=0x38000dbf520) at
> linux/net/ipv6/ip6_input.c:88
> #7  0x0000000000ab6104 in ip6_list_rcv_finish (net=<optimized out>,
> head=<optimized out>, sk=0x0) at linux/net/ipv6/ip6_input.c:145
> #8  0x0000000000ab72bc in ipv6_list_rcv (head=0x38000dbf638,
> pt=<optimized out>, orig_dev=<optimized out>) at
> linux/net/ipv6/ip6_input.c:354
> #9  0x00000000008b3710 in __netif_receive_skb_list_ptype
> (orig_dev=0x880b8000, pt_prev=0x176b7f8 <ipv6_packet_type>,
> head=0x38000dbf638) at linux/net/core/dev.c:5520
> #10 __netif_receive_skb_list_core (head=head@entry=0x38000dbf7b8,
> pfmemalloc=pfmemalloc@entry=false) at linux/net/core/dev.c:5568
> #11 0x00000000008b4390 in __netif_receive_skb_list (head=0x38000dbf7b8)
> at linux/net/core/dev.c:5620
> #12 netif_receive_skb_list_internal (head=head@entry=0x38000dbf7b8) at
> linux/net/core/dev.c:5711
> #13 0x00000000008b45ce in netif_receive_skb_list
> (head=head@entry=0x38000dbf7b8) at linux/net/core/dev.c:5763
> #14 0x0000000000950782 in xdp_recv_frames (dev=<optimized out>,
> skbs=<optimized out>, nframes=62, frames=0x8587c600) at
> linux/net/bpf/test_run.c:256
> #15 xdp_test_run_batch (xdp=xdp@entry=0x38000dbf900,
> prog=prog@entry=0x37fffe75000, repeat=<optimized out>) at
> linux/net/bpf/test_run.c:334
> 
> namely:
> 
> static inline int neigh_hh_output(const struct hh_cache *hh, struct
> sk_buff *skb)
>    ...
>    memcpy(skb->data - HH_DATA_MOD, hh->hh_data, HH_DATA_MOD);
> 
> It's hard for me to see what is going on here, since I'm not familiar
> with the networking code - since XDP metadata is located at the end of
> headroom, should not there be something that prevents the network stack
> from overwriting it? Or can it be that netif_receive_skb_list() is

Ok I got it. Much thanks for the debugging! It gets overwritten when
neigh puts the MAC addr back when xmitting. It works on LE, because 0x42
fits into one bit and it's stored in `mac_addr - 4`. On BE this byte is
`mac_addr - 1`. Neigh rounds 14 bytes of Ethernet header to 16, so two
bytes of metadata get wiped.

This is not the same bug as the one that syzbot reported, but they are
provoked by the same: assumptions that %XDP_PASS guarantees the page
won't come back to the pool.
So there are two ways: the first one is to fix those two bugs (two
oneliners basically), the second one is to turn off the recycling for
bpf_test_run at all. I like the first more as it theoretically keeps the
perf boost for bpf_test_run gained from enabling the recycling, but it
can't guarantee similar stuff won't happen soon :D Something else might
get overwritten somewhere else and so on. The second one will
effectively revert the logics for bpf_test_run to the pre-recycling state.
I'll submit the first way today, it will be a series of two. Will see
then how it goes, I'm fine with both ways.

> free to do whatever it wants with that memory and we cannot expect to
> receive it back intact?
Ideally, yes, after a frame is passed outside the driver, you can't
assume anything on its page won't be changed. But that's one of the
bpf_test_run's "features" that gives it nice perf :D So as long as
assumptions don't get broken by some change, like this one with the
recycling, it just works.

Thanks,
Olek
