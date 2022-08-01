Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C849586DFB
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbiHAPo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiHAPoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:44:24 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80108.outbound.protection.outlook.com [40.107.8.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89133C8D4;
        Mon,  1 Aug 2022 08:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e4fL5ax0SvwKcSxhFyy49YiO2I/eAS4P6UX6FlbdPzRs0kBc6nsedgLM87TrTCYbDzSCWMoWm+7jkSfK6p6ZbymcB56WOAGIyWy5QbtkGlaURLtTK4IMJ9wS9YQhJ3BrHTlHS4JcpucBtTWsBLRMmRDCf/cMaOBLGHofHLuKqPQjMQ4gzlMXcNGe6cb/hoVXrLXNXBu/uYWsFBMKdUq9rqdJtuPnOnBEfT9fYFO9Qz2Nw3qG/LT4dTtKYPk1ICrFiGo5/Ue8k3xxOqmX1Pqo/RqTHastFdc4hfSTV/qZh7rUf2qbb3VibHRFl7e35vseVr3IivLXmiR0WErBGE04jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Wn9aReZ+Q1JScByMeMWwoJ+7ryXQfgTL0ib8s9DvqQ=;
 b=g/ap2AcFRLxskxpoqmTyGbbm8jBZu+m7KK4NHrGEiEZ8WFCyDHBId7udHrxr9W6cuPs4+oeYX+6hWrB3T06jwjHaXoWQYufy9BD1ii7Z/hqofso4JJE/dABUl2NgHSkM8KzOK35qUPz45iIe0Hk9/Hxw0DybQx2Lg+UXufV+/aykpyO+aNSbub4HzqHdriqxsal+iOWY0G67wfFOmho5TnkxyXtbzr7XZzGECMgmOpEg3jN0Gdn7kWRhbav4kQwsecnXExzwOHluGvIOxoXsSwUGdxcW6BAb8yqbisyDjxnl9RZX/JFxrrTdHZRzXhfP22Y/JiyDMNk6pawxFGO8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Wn9aReZ+Q1JScByMeMWwoJ+7ryXQfgTL0ib8s9DvqQ=;
 b=AZ6bfAeIO3gWj+mLl8nHyA73lBUNTsUVlff20k+Mh5tLvzKNgkvc5ELPW/BJtiLsDydTKmQMeL+P9ytZTb8Oq7hqC5zfJxNle9CacsI49moQcsR2Oe9bzmndOGNIP3yLldBzLCxa5zwO51LyzrcqR3u9HYOOrOS/DS8SV7O9Fqw8+wiVd4N3GGiVwP1/PyvJxYm1KpkCxpOA340T7nIc/uToV0fUFhBQp/rG2Cfs/1WbCk2eodztBzEPWy1CvqJKoNnOh/x4MuGsCoKoQ5AgoF4GArP3/VraiCYvh5wpJxVlQW7riZgF/3DkqdX/eeRVBCeFlFTlvB8qJk9+/M5vkg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com (2603:10a6:102:1db::9)
 by HE1PR0802MB2249.eurprd08.prod.outlook.com (2603:10a6:3:c2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Mon, 1 Aug
 2022 15:44:19 +0000
Received: from PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d]) by PAXPR08MB6956.eurprd08.prod.outlook.com
 ([fe80::813d:902d:17e5:499d%3]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 15:44:19 +0000
Message-ID: <eb1a9b6d-8e43-8d0a-70a5-578af0c0bbfe@virtuozzo.com>
Date:   Mon, 1 Aug 2022 17:44:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/2] neigh: fix possible DoS due to net iface start/stop
 loop
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yajun Deng <yajun.deng@linux.dev>,
        Roopa Prabhu <roopa@nvidia.com>, linux-kernel@vger.kernel.org,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Konstantin Khorenko <khorenko@virtuozzo.com>, kernel@openvz.org
References: <20220729103559.215140-1-alexander.mikhalitsyn@virtuozzo.com>
 <20220729103559.215140-2-alexander.mikhalitsyn@virtuozzo.com>
 <09ac06d6-4373-0953-5ed0-ed85ef25c999@kernel.org>
From:   "Denis V. Lunev" <den@virtuozzo.com>
In-Reply-To: <09ac06d6-4373-0953-5ed0-ed85ef25c999@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0224.eurprd07.prod.outlook.com
 (2603:10a6:802:58::27) To PAXPR08MB6956.eurprd08.prod.outlook.com
 (2603:10a6:102:1db::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 942f442b-7bf7-40ce-8498-08da73d4b278
X-MS-TrafficTypeDiagnostic: HE1PR0802MB2249:EE_
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0kaHbUhcuXmnK0lxgA2rair7dXg/NOWun6uEUjxIjV9nQVS6970jS28BV3Rcuiy7xdjNM8qF0ae76OFrzOSH1WBtiNno009mzXZCOXT3MtcCxaFNKe2Bmi2UWzkHM8blY749ioeu+WhtoAVWzt+eGaUeqiJOVthPimm+JVC1IPTGmxW6Uklif4S8/mYYbie9B6PYk8BmXPPQ/7NitBXUu5klljWfayfuCAytGW165NTycljROIbvfn5daoqVzWB1rx7CjICL8z/5FTLzcwmzDNGoXh5M+nSpZVifjNxSThz4YguKBq2xGaxRhdZ/KYydSEqz0eteSoUGEWXVP3EM5HrWzdjckRYeW13byw7Ce9qcdjweCy/6AwBfQ9FJpEiBz43mrDVDqTr5zZjwAIWU5ND2ie970sHwDTo9epQYTf5Q8IAhXv6yKm4BkWwifSR/StRuQWQYL63jYFoogiNjXHsc4yG0M/cmsOj/qcGP+/drP5X/R20fyYwceTE8PIyTKerjS9Y4JbpxsjMaOakXUii0i3iBGLl8ZSfw16XfUPk2lskoc8oNGOXzG5saZXXrU6Br0IzoJ7vc6oEhe7SeoGnxIU/P4a+GpANcz4QR0jLIZB6R+MgSi0RJNE2NYe8IdUT9nXmNyRsgppjP5GfnBgaR48uyPbw8EGG9fFr9+qBtQwmfH2S075ig1OkGYem+jwP3h4zFHEdk2Af2IO0H1f/F8acjh3FVom7p+56s/9+4tzDS5dKG6s1ujz50R2cXO/cYfpWmuQD0oRBjSV8ProdaoYe40tz8w6z2wRFFX1ArSLoay1Z5J0lrTWnU68K8LhirRD+zSPrEgmnqiDJI2qW92JNi0OMV/GdPIZ3tsE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR08MB6956.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39850400004)(396003)(366004)(376002)(38100700002)(38350700002)(36756003)(31686004)(5660300002)(31696002)(86362001)(7416002)(2906002)(52116002)(6666004)(41300700001)(8936002)(6506007)(66946007)(478600001)(53546011)(66476007)(316002)(66556008)(26005)(6512007)(83380400001)(54906003)(6486002)(4326008)(110136005)(8676002)(2616005)(107886003)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzhsMDF4YUs2WVQzaHh3NVBLZzNQb29KNVkraUR0bytKbldtNTN4K096ZnVu?=
 =?utf-8?B?Q1JGaS9ITE4wVitkL1gwcHpYM0xwQ3dnZmFHTTNkbmJDR3RCaUFtaWQxeXVD?=
 =?utf-8?B?MG9KZkVrN3BXUFZ5YmZoQzZ4cDR4Y0N5VVRxTGs4VnNzVGhQTklGUEdldyth?=
 =?utf-8?B?THhFVlUyZ09zVkJ5K3pJVzVxb010MlgxMHU2VWFHWXpFUmlxcWpVZ0tUdVVX?=
 =?utf-8?B?MVFmVElud0RSYUt5Q0tKK1p3NytVbytmMTJVTFJCUElqV1M4dks2U0syWFBm?=
 =?utf-8?B?VldvSzVFb1lIMy96dHlwYWVUMmR1dHoyQTlvK3R2Z2dIUWdRa3FsQWlBMVpt?=
 =?utf-8?B?cjFzT2dKOFBWeG95bGY2b1JmeWVvZnFmaEhHU01iTndGVWI5b1lxdnUrRWJY?=
 =?utf-8?B?cm5SQU1IWmdGcDNObGpNVzVJeWs0OElzU1RnaysrVXNlMU5HKzlJOFI2MUlI?=
 =?utf-8?B?c1Ard0ZCSnJvcmdmMXN6WFZSSnJIVDNRUDFuRnUrL09VZE5ybjRrdXEvMjFa?=
 =?utf-8?B?RkZvaGV0c1hOdEtFdkp6dXk2bjNscnlycUdWbEYrMkJCYWNWTVlBVDFYZVBN?=
 =?utf-8?B?ZUQ5R0VtYmR6dHFocnZ6NGk4bTRzVGdoMjJxTTJIWWFDaUc0N0dGcHFiMjBF?=
 =?utf-8?B?ZGZkLzdsU2JQa1NmQ2YwRkJMWHFTWXFpUklNOE9xYVlHd3NycUlQcXBEUG96?=
 =?utf-8?B?dS9nbForQkxlRWxaNjFrOVAzRHRiSGxSZEE1R2JNd1Avbk94dlFiTWxleURa?=
 =?utf-8?B?SFQ5SzNaUzJXRFl3bng3UHh1VlZSc2RIcEJhWnd2MnRlUU9jaFAwL1JGTTBL?=
 =?utf-8?B?dXI4bWEzT09XcDJxMmFmay83a2lNOEt1L3BUMEtyL2htcFlCLzhzNXh3QWsy?=
 =?utf-8?B?bFRNblF2UUg0elpjdzF1dzNRUHAzcFNpY3VtZ2N4b1pJQkdSQzFsczE0NDc3?=
 =?utf-8?B?QmFRQUtIT1ZSNFoyc0RHRHJudmZjNUh6cXl4eTVIb2lYS1hXbmRVMy9VZkJq?=
 =?utf-8?B?Y0NUb0NXVEdkTGF3anl1MGMvQVhMWFNYRHpFMUEySy8wOHBBaWZNOWRabE9q?=
 =?utf-8?B?L2VYRG83akcwR3hubzlJYnQzNVFCWTI3QWIxVTJYMmxScU56eDdYWnhKNmIw?=
 =?utf-8?B?OGdsS2wrZUNkc1l5UFJJSlByWWg3c0praGNiWldKcWZmM1BpNDBuaWVxRFBp?=
 =?utf-8?B?azJ2ZXhSclBPVnVkZDN5Uzc1TWptaWozUmVDYXN5L1JGQnBKTW8zemJRSzkz?=
 =?utf-8?B?bFdWQWlqRktRcHkwWGEyQlpNUG9ndSs3bHFpeGwxQTl1MFZDcTNQK2FXV3B0?=
 =?utf-8?B?OTREQmpVSlQ4MTB3QWw4ZktHTGdRK1FyQWw0MmM4MFFEUkE4ODR0YlJPOGNw?=
 =?utf-8?B?MmppU2dkRi9lWWVlR1pLSjNaak04YlVqTER5d3dTa3FaMWs5UXJna0RaUHRt?=
 =?utf-8?B?U2dQbXMyNFkvZTJmeXNod0ZncnJ3SFd4UnJMY2NUV2dNNzFURlhrNjhzcTRY?=
 =?utf-8?B?R3Iva1pIbkZVZ056blNaTlpDeUQ2RXN1U2NrcjRocm8yd2dCVjVTNE5tUnlu?=
 =?utf-8?B?STdQM0d5OUxiQ1U4blhTT2ZTYStkbldZclhCaDNSMVdURWtkZmg3M1hZRlAx?=
 =?utf-8?B?czY2TXJkd01adGdMUTRzT1ROSXFQWm9JcUJwbS9oSDZzTFRnckJQYzVzRTVs?=
 =?utf-8?B?RlVRd21iUUZCc21MQ0h6Ny9NeFZNTitWVWxGckJQZFd4YWFGNWFwQ3VTYnpD?=
 =?utf-8?B?Q1JtMVN1OUxOUU1ld3dpUkQ3QURka0hjZ2VLbDkxcDNJQVNONnpkS21kYnI1?=
 =?utf-8?B?R25OdGVJWUVtYTdkVkpaUU1MTGVGa1VacVhuc3pERGR6N3BHMDdDVmd0S3dp?=
 =?utf-8?B?OVJRWW9qYXVDZVBVUVFERmx3dFlRTjBVNldUSVk0azZrRkY3RHlCNTgrRkI4?=
 =?utf-8?B?Rk1PSVQ5Ym9XTVRmSnRRa2xGSm04QkI2d3ZFSGFqRWlxN1c5V3UvYTlWL3U0?=
 =?utf-8?B?R3hoSHcvZ3FTTElhR1Myai9BTXhTNFJJUE1lVVVXSzBjZndDa1pmdjFGcUJJ?=
 =?utf-8?B?NGNyZFZ6MHFFOVBRSFUxaWtycHM4M21rN2cxbjJ6MGt4aHI0OVRlTTA5cU5r?=
 =?utf-8?Q?uAL7vZYQFilcxQCTfJ4CKdON5?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 942f442b-7bf7-40ce-8498-08da73d4b278
X-MS-Exchange-CrossTenant-AuthSource: PAXPR08MB6956.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 15:44:19.3037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0as2+AyW50DJbuXYefxgVK8V2RT+cZsYLPIM6xAeL7oVlQF6qppgOneIiKGdVRVbnY7xNXfWiUorAXXCptQzsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0802MB2249
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2022 17:08, David Ahern wrote:
> On 7/29/22 4:35 AM, Alexander Mikhalitsyn wrote:
>> The patch proposed doing very simple thing. It drops only packets from
> it does 2 things - adds a namespace check and a performance based change
> with the way the list is walked.
I believe no. All items are removed before the patch and
all items are walked after the patch, similar O(n) operation.


>> the same namespace in the pneigh_queue_purge() where network interface
>> state change is detected. This is enough to prevent the problem for the
>> whole node preserving original semantics of the code.
>>
>
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index 54625287ee5b..213ec0be800b 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -386,8 +396,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
>>   	neigh_flush_dev(tbl, dev, skip_perm);
>>   	pneigh_ifdown_and_unlock(tbl, dev);
>>   
>> -	del_timer_sync(&tbl->proxy_timer);
> why are you removing this line too?

Because we have packets in the queue after the purge and they have to be 
processed.
May be we should better do

if (skb_queue_empty(&tbl->proxy_queue))
    del_timer_sync(&tbl->proxy_timer);

after the purge. That could be more correct.

>> -	pneigh_queue_purge(&tbl->proxy_queue);
>> +	pneigh_queue_purge(&tbl->proxy_queue, dev_net(dev));
>>   	return 0;
>>   }
>>   

