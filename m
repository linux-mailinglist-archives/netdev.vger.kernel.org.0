Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5454E753C
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359418AbiCYOnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359397AbiCYOnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:43:03 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140084.outbound.protection.outlook.com [40.107.14.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAE7D8F70
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 07:41:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eya5DvJ/mH9vrZPZWDJCd6HvZsrzqFP13GV93eQT1UXuG3bibDpWEkVDsfPdbOpRUmxtfi5D2C4qhBGp0jMfosCjnz8d/GZxRMoR3znvPTsm7DrPBb75wQ0hdQHqd5Ct7yc6ZjTbWus4Ge5pzVPAqZt3Jys19BhJDcccgBhju7j/5QwCKWRT6sj5Gr/NnoAWXSzyM/OJOIxSW5qqMrWebXEjCcozU37C10KlzsWR579qNtlWTLt4sIz0C9+OofXorezow/G8rVq/vkCsjFxV3Wr4D4ThGRxs+gw0n6IyduY0vbEJjUVqbGUkI8qFxDOJ6xFZa3YPn3ayZj/wJjsNvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joF9z4kvGchCVOmIKoIlET7+YI6H8/IRA7pkaQTTBSY=;
 b=Y6cWg+gHEk4lFAvrx95FRcsIrZE8T+ka4UVX/j6Ats/MW4Qvu7iqwruGXtxBQZc6TpYVXR9/YNPHqim9lo7oEPxEpWu/Tu4N1iH59ISc2ZcgYV3hbwgccoyPj7lh2vSlm12Auqhp6qrGBUjo6XBw+XV5ijtxIXajZ5mzRsDE92jOMctIxxovH+X8hnjoa+P6QQLbWoM02bAK6nycIQ+tl+wcWjXb44X7BIObqjEUfsRpx6ozjgjGiXSEmotVjK/ymvOSKayrCeKp4Q93sAX6Drjsd/bIkSWY2L/9n6a+ImyA/xrPH29P2xLV/Gs+oIea5XVVXpkFpGgiwXEGdGa9+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joF9z4kvGchCVOmIKoIlET7+YI6H8/IRA7pkaQTTBSY=;
 b=qgitBQpjHq8JVKz4lYHVgifzAwKtaIc4IVdURY7DWRzp8h3Wk8xcyd0/DzXjbPuraLb7XavnHeXpqgxyMVlJe3Z4JL8mT0t11jJFnZDMgg34Tj5pgASRMBHIgufx9pY+ChsvNqI9dWZq9CQkoO3k8Ae+lYBcksekQ04D2VmhCpF6hAY7OJYULdXdtrnA5nPkGdvMFt6VrOIMC4lJaFH+zijp+kNfcZV5vW2tTaM6ULr2BaE4aYilrghXfWo0JOSkW+2VeK8fYrBvPy0WeqEzGT68FY8+1vE9ASMz7UivnZqP46GgUhqSldmhvqOU8ZALny+TfNu9MxFUwOGByREMgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM0PR06MB6241.eurprd06.prod.outlook.com (2603:10a6:208:175::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Fri, 25 Mar
 2022 14:41:22 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.025; Fri, 25 Mar 2022
 14:41:22 +0000
Message-ID: <9aa5766c-c94d-e468-d790-51712c6697df@vaisala.com>
Date:   Fri, 25 Mar 2022 16:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Content-Language: en-US
To:     Claudiu.Beznea@microchip.com, netdev@vger.kernel.org
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
 <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
 <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
 <b643b825-e68a-875e-f4ac-edddae613705@microchip.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <b643b825-e68a-875e-f4ac-edddae613705@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: GV3P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:a::18) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae1bbb52-9145-45b4-786e-08da0e6d8842
X-MS-TrafficTypeDiagnostic: AM0PR06MB6241:EE_
X-Microsoft-Antispam-PRVS: <AM0PR06MB6241CDECF8C0105BD2883C44FD1A9@AM0PR06MB6241.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GfljWQ3S/M+5GbAGt3B7wX177xajopyMjIw5Jb14gVslVE9VJ5BHdVpsjVmS/nJOMnZnfRgC48xcOsePWJygFNXg2sWftC+AXWuc23o95wlhHVZBaMkQlHiSq6oQu6E35VIh7kXiUjTUOe4ms3v/JJS2KV0/WyJuedczl7dz0pjSjw9s60JIvXN2sl6CTJE8uVhPHio3G1iIwNKvkw8Wso+YtmgnB4fxqISiR8MOzRctWOKh0b5M85C0dCqUjLTGbl27lpUhpciOFous3hqbjyRXOXCLMbAmZvdSBObT3yhAxmJ/qv+5n/wAS6aRU1c03xCpq/6jgEpIee3I6uZ+9DwVEeXRmWCl16cWd8WQ58r2ge1E3NxSPR6xEwBLhrXzuEsxemvQtYb7mjYMdq/ZY9ZdMVo4IapyymiPZmuoCv5kGjWJjYF1pxuvI1hHA+I7frnhgX1xdsmiQugrrCbQarr5SkFikrbw0cJ7jU3M3eWiWz+Tro7aUQtKMG+INi1qvZ784GwpZm4I+q6x6DZ70scg6vYhnhMKUQ48mxWCxfQ+37/o86IQXZQ3kiJGG8eaR+pD0ErD/CQYtyaMapXQXReQlaqN62l8Q1+ZxSYFSb22UYDht07aCQWqEO7Y05hVIx7D+LzZFh6ElPlpL+ds1kcCn+LkjbmAnltfBx4U0svYGvDRDrpo7Ys2byW+p/eOIxdrRCswyf4s7a1dn8wTzBKaybkk5i71tXm/ZgSROlqglbUY18cQPrj+dwi5GKqJbl6fgVupIVkpwt1X5BEYzJkNUuF9fqzYZsdgyj/sAqudn8pDOxXXZqaed7jVj6c71Hmncy8PHKNR02qqyd4f4qxekpUnhZH/Q5J+4D0wNCjG+e2PNjzvEkbdSBRR5T6w
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(44832011)(31686004)(31696002)(2906002)(38100700002)(38350700002)(316002)(5660300002)(508600001)(6486002)(83380400001)(966005)(86362001)(45080400002)(26005)(2616005)(66946007)(186003)(66476007)(36756003)(4326008)(66556008)(8676002)(6506007)(52116002)(53546011)(6512007)(43740500002)(45980500001)(10090945011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEV1WlNhazBKRjRsbmh4Z25LZnVyS01CNGQrTlh0cXJsY2NWWjBQcUp5ZktU?=
 =?utf-8?B?Z1I5NmNkbkh6Z1BVVDI4Vk5LYVRxYVFoOGVhQmNxZXBMV0g1N3FXeTRCRzl2?=
 =?utf-8?B?Z0ZPTHJhT0ZpZE42Y0syRnVmdnYwa2F1Tm1DME1PMXZDdVp6SXppeDk4T3o3?=
 =?utf-8?B?bkxPREREQTROT0ExVFZHRDRJbWNGbTdSK2dpN3hMc0VPUlYxTjR4d0RYS0JK?=
 =?utf-8?B?eE1ZVDNUSXphejBMbGJSZXlDRFdXeFZZT3dORk1xSXIxUUFVaEcvYjVxWUxU?=
 =?utf-8?B?ODN6b3NRUnlVQXVYR3kwd0V1M2w1ekJrSWRIV05ZNThtUzVBMzkrVVF1WHlm?=
 =?utf-8?B?VHFXdm5OWlhrMndTa1JQZkdJbmZ0N2h1WGVqUGlxQXdTK0VKOTR4ZklTTXlG?=
 =?utf-8?B?SXZnTUJjemZvREZlREhielBjL2ZNRGNOelBZVlEwOW1uSlQzT0JtMEk2UEpL?=
 =?utf-8?B?bmYvVUttSmFPbU1Ec3ljZWF5MWM2cHJuVEZ2RjZMa0lkZjdhL2d4SjZlRVlI?=
 =?utf-8?B?c3pBK255UGVRdEtDbDlVN3I0THFhZ24yMDQ4VThUTXdRTFVTMXQySFhrdWJu?=
 =?utf-8?B?d1dGblJHVWlBZnR2byszakQ3UnZqNXE3ZllyYVNmcnJ1TGRndndlUUJJcWdq?=
 =?utf-8?B?TmFBYitXK1o1OG1Ob25nQzBrbDRyN1JQZFhvUC9PWmVZM3c5NjVLUUdRZEZX?=
 =?utf-8?B?dmdWRzFiYWNzV21Sc0RqTGk0OURzaWRXTFp6elk3REZIYk5VNGg4bG51WUhj?=
 =?utf-8?B?bldMY09WNUZlN3FiQSswcCtwSlJUTWxPa0tEeXF4RzFMWGE5Z3ZEVE13ek9v?=
 =?utf-8?B?dFFiRy92bVZ6MkFYdnlKNytXZU0zRVJ0Z2hLWXFEa3gwamRBU2d1cDBoR1pl?=
 =?utf-8?B?MWh2Y0VBMlpMbUpxNDYxa255S1V0dmRxTTYzeW90cjVnYW1abzRjN3Y5dWM1?=
 =?utf-8?B?eVFMamNFME5IT1hQQTJ5b3pOcGF6YzNUZVZWdjQ1eFJ4VEdMNVIwQU1ERlFL?=
 =?utf-8?B?U1ZzYjBJd2djV1RJZlh0OTE0ODg0U0U5Qitibm05SWM3U2M1VWVjQklYVkFQ?=
 =?utf-8?B?cGw0a3JkSmtnTkV0eXRwd0dlMmhiaEkraWVaT0trQXZCeDRoKzhRUTRnSDFh?=
 =?utf-8?B?T2Y2NHIxeEN4SC8xMTdGV2J5T25UODBvS3NaZmg3d1hlQUd1a2FwbUtMcHBr?=
 =?utf-8?B?TUFDQmh1bUd4VWdUUUlkSnFIdzN5ZHhaekVXd09zcGYrZjd2WUlXNFNZMDF4?=
 =?utf-8?B?cWljN1FKY1h5Q1NnZjFFSmJSb203U2JKUlBFTEw0cUFVNGlvVEhkNDQySEtB?=
 =?utf-8?B?VkNWTXJGOEQ2Z0FhaXBOZTMrNkpJb1FNV1duSXY1Umw5TkFRN01oZVl0OEQv?=
 =?utf-8?B?aWJsZzQ1RW9yMVlTZFhSTGNnM2h4Wi81VFBtU1pONW5MLzhmUEJZTUhUaDg5?=
 =?utf-8?B?M0hNWTBFRWZyZVQ3aDBmRjJpWWhBMnhBUjFSSTBPUy9NZFlmUHVpV0NVMEJ1?=
 =?utf-8?B?akNjT0NFYUUxSjdwZzlhcGlxUm9oSTExc09mNU5kSkx4d04zSHZscklwcFpV?=
 =?utf-8?B?QUV5WUkwejh6OXNqMElsMVh3Y0VQZURBM2lIOVdJWkJMZVh1cnNic0RQOEZa?=
 =?utf-8?B?cHNPT3F4cVhUdTNlWUZHK2JpMTlEVXYzQ1pPYWdsYlU0SXBnams1T1BGWEY5?=
 =?utf-8?B?clpwTDA1L2JZK3U1UVhQVU5XdGFmNFVlRTdmUGNBMDZXZkk1Ri90WnEvaWdl?=
 =?utf-8?B?VWNsK0JnRmoxQnpLUjFQWlVaRTJaNFd5Tkh5NWpDZThGYWNudE5uazMvRmd0?=
 =?utf-8?B?V2dJY0hFTFBzUzFIMVJRbk0vdXdYM2tQbGVocWdDcXh3cXpITGN5TzROcVlN?=
 =?utf-8?B?VWhsV0pCWXo5TWhqRGZURExqS05VbFN5UUdqbE1neGRSa0NTMk41czFCeit0?=
 =?utf-8?B?Mk9oMHVLQU9wSXZsU3NDRk1ma3l4UlBQWUpaay90WE5OZ0hIV3dRTWV2SGNr?=
 =?utf-8?B?Q0NxbmtNeUd0Z256aDNQekJpbjNReUs4aldZdXBXVnFxTVd1ZXk3Sm9RV2E3?=
 =?utf-8?B?NnZHVks1ZGZrME9hazlvY2xIelNNcTRIZG9yRk15TXhDUE9UZkVEbDN0NmRo?=
 =?utf-8?B?VHhSdjVGWkhrRVdLcjRBc1hHK0hNT1JySFdYZHFhdSt6N1dVdjZpdFkzR3Nq?=
 =?utf-8?B?aWc2L3l3S0ZYbzhxcDh1UlRmUXVhUGdPNllZWm9WUjRRY0lKTktoUmU2SUFQ?=
 =?utf-8?B?b0xDVFVhb1JqREM1eHhyVlNhenBDMk8zQTdERWRFcTBpVkRyTnFpaG8zRDc4?=
 =?utf-8?B?M1prczFScXdEcVJNSzVDbTNwOTk0bHBxQnRHdGo3SGk4bnM1Q3AzcEtCc3dF?=
 =?utf-8?Q?7WIeD2RydiaRylso=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae1bbb52-9145-45b4-786e-08da0e6d8842
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 14:41:22.8190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ldis/BMa3WUTgIfSrsdUaquBUViZrHHPOQa6LqhXZBgpFfTPgawBv1QtagF8E2J5pPxNfP9d6iidE/zqlra3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR06MB6241
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 25/03/2022 15:41, Claudiu.Beznea@microchip.com wrote:
> On 25.03.2022 11:35, Tomas Melin wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>> content is safe
>>
>> Hi,
>>
>> On 25/03/2022 10:57, Claudiu.Beznea@microchip.com wrote:
>>> On 25.03.2022 08:50, Tomas Melin wrote:
>>>> [Some people who received this message don't often get email from
>>>> tomas.melin@vaisala.com. Learn why this is important at
>>>> http://aka.ms/LearnAboutSenderIdentification.]
>>>>
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>>>> the content is safe
>>>>
>>>> commit 5ea9c08a8692 ("net: macb: restart tx after tx used bit read")
>>>> added support for restarting transmission. Restarting tx does not work
>>>> in case controller asserts TXUBR interrupt and TQBP is already at the end
>>>> of the tx queue. In that situation, restarting tx will immediately cause
>>>> assertion of another TXUBR interrupt. The driver will end up in an infinite
>>>> interrupt loop which it cannot break out of.
>>>>
>>>> For cases where TQBP is at the end of the tx queue, instead
>>>> only clear TXUBR interrupt. As more data gets pushed to the queue,
>>>> transmission will resume.
>>>>
>>>> This issue was observed on a Xilinx Zynq based board. During stress test of
>>>> the network interface, driver would get stuck on interrupt loop
>>>> within seconds or minutes causing CPU to stall.
>>>>
>>>> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
>>>> ---
>>>>    drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>>>> b/drivers/net/ethernet/cadence/macb_main.c
>>>> index 800d5ced5800..e475be29845c 100644
>>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>>> @@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue *queue)
>>>>           unsigned int head = queue->tx_head;
>>>>           unsigned int tail = queue->tx_tail;
>>>>           struct macb *bp = queue->bp;
>>>> +       unsigned int head_idx, tbqp;
>>>>
>>>>           if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>>>                   queue_writel(queue, ISR, MACB_BIT(TXUBR));
>>>> @@ -1665,6 +1666,13 @@ static void macb_tx_restart(struct macb_queue
>>>> *queue)
>>>>           if (head == tail)
>>>>                   return;
>>>>
>>>> +       tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>>>> +       tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>>>> +       head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>>>> +
>>>> +       if (tbqp == head_idx)
>>>> +               return;
>>>> +
>>>
>>> This looks like TBQP is not advancing though there are packets in the
>>> software queues (head != tail). Packets are added in the software queues on
>>> TX path and removed when TX was done for them.
>>
>> TBQP is at the end of the queue, and that matches with tx_head
>> maintained by driver. So seems controller is happily at end marker,
>> and when restarted immediately sees that end marker used tag and
>> triggers an interrupt again.
>>
>> Also when looking at the buffer descriptor memory it shows that all
>> frames between tx_tail and tx_head have been marked as used.
> 
> I see. Controller sets TX_USED on the 1st descriptor of the transmitted
> frame. If there were packets with one descriptor enqueued that should mean
> controller did its job >
> head != tail on software data structures when receiving TXUBR interrupt and
> all descriptors in queue have TX_USED bit set might signal that  a
> descriptor is not updated to CPU on TCOMP interrupt when CPU uses it and
> thus driver doesn't treat a TCOMP interrupt. See the above code on

Both TX_USED and last buffer (bit 15) indicator looks ok from
memory, so controller seems to be up to date. If we were to get a TCOMP
interrupt things would be rolling again.
Ofcourse this is speculation, but perhaps there could also be some
corner cases where the controller fails to generate TCOMP as expected?

> macb_tx_interrupt():
> 
> desc = macb_tx_desc(queue, tail);
> 
> /* Make hw descriptor updates visible to CPU */
> rmb();
> 
> ctrl = desc->ctrl;
> 
> /* TX_USED bit is only set by hardware on the very first buffer
> * descriptor of the transmitted frame.
> */
> 
> if (!(ctrl & MACB_BIT(TX_USED)))
> 	break;
> 
> 
>>
>> GEM documentation says "transmission is restarted from
>> the first buffer descriptor of the frame being transmitted when the
>> transmit start bit is rewritten" but since all frames are already marked
>> as transmitted, restarting wont help. Adding this additional check will
>> help for the issue we have.
>>
> 
> I see but according to your description (all descriptors treated by
> controller) if no packets are enqueued for TX after:
> 
> +       if (tbqp == head_idx)
> +               return;
> +
> 
> there are some SKBs that were correctly treated by controller but not freed
> by software (they are freed on macb_tx_unmap() called from
> macb_tx_interrupt()). They will be freed on next TCOMP interrupt for other
> packets being transmitted.
Yes, that is idea. We cannot restart since it triggers new irq,
but instead need to break out. When more data arrives, the controller
continues operation again.


> 
>>
>>>
>>> Maybe TX_WRAP is missing on one TX descriptor? Few months ago while
>>> investigating some other issues on this I found that this might be missed
>>> on one descriptor [1] but haven't managed to make it break at that point
>>> anyhow.
>>>
>>> Could you check on your side if this is solving your issue?
>>
>> I have seen that we can get stuck at any location in the ring buffer, so
>> this does not seem to be the case here. I can try though if it would
>> have any effect.
> 
> I was thinking that having small packets there is high chance that TBQP to
> not reach a descriptor with wrap bit set due to the code pointed in my
> previous email.

I tested with the additions suggested below, but with no change.

Thanks,
Tomas


> 
> Thank you,
> Claudiu Beznea
> 
>>
>> thanks,
>> Tomas
>>
>>
>>>
>>>        /* Set 'TX_USED' bit in buffer descriptor at tx_head position
>>>         * to set the end of TX queue
>>>         */
>>>        i = tx_head;
>>>        entry = macb_tx_ring_wrap(bp, i);
>>>        ctrl = MACB_BIT(TX_USED);
>>> +     if (entry == bp->tx_ring_size - 1)
>>> +             ctrl |= MACB_BIT(TX_WRAP);
>>>        desc = macb_tx_desc(queue, entry);
>>>        desc->ctrl = ctrl;
>>>
>>> [1]
>>> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Ftree%2Fdrivers%2Fnet%2Fethernet%2Fcadence%2Fmacb_main.c%23n1958&amp;data=04%7C01%7Ctomas.melin%40vaisala.com%7C4d5ef5a2a27247697b0b08da0e6539ff%7C6d7393e041f54c2e9b124c2be5da5c57%7C0%7C0%7C637838125183624670%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=v%2F%2FdE1Y8BxHWsmtn3nX70OFN5oCb%2Bzlb881UXuYtoMs%3D&amp;reserved=0
>>>
>>>
>>>>           macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>>>    }
>>>>
>>>> -- 
>>>> 2.35.1
>>>>
>>>
> 
