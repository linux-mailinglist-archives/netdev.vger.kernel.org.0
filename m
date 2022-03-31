Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8DB4ED793
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbiCaKKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiCaKKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:10:42 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60071.outbound.protection.outlook.com [40.107.6.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A59202172
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GuNVt7G9Cn3RAVBKcfxdjkvxnqeLECCNAbayMWvfut0zeP8aQR/jp02MSeZ6/ujBHJps0ZIApN5d/ttMs6Sykns+uFRe6myZKqqsvUMtpr1ecbmbmXT2PlkRD0/E5TpyZwIJyAhpZYaGHJj5WVEw0Hv9EY7vtPY0aioY7BTIGW3BHD046aoqApmp61hhH71IYfSajHor6u+rYJmJYoUbgnJtNG8vAlRE7yQiTOs+mJ5PBEq6lBdZ2zHygh8QTBAgtb1Qh2tts3gOqQrCn458+fe0sgY9pSuJR61cRYk39iDFB8jGCbLwKkyV7LOCpC4TkP8b3YgB6io9TINIejuYkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uNjRKPwm+kv3zOsxvd8NgsNoKVZuOBYX7oMl05G3rbs=;
 b=UwGS6AmvscR5K5AvVYxvWnxAqobVwYC7NO/vuODZOk6iU9YKQMnfZDJ0rc3xxuOZglZdYhGo4AsQEpdgHIa7ZGSXJBvE/5oKL/4okikL+DkG+e5PhYYypUDhjb4bZBUQYMd1dLwWwldUU6sHuNxc2UJsW3C+OXwgFGS00iqVLt8k3mjxySkXl6VbqOumGvabbm0EqGsyIO2n7YgNqlKKTc+7JSTKsKWQASfuYibL3qORlPgyOINDFIG9XJYn5VLQVU5M8I/GxYwgjsGTwlR5PXouGaamgbPuXMN/ziDwHOoeUDH5u33IxbeD8uTQ6twi0iHwpxMkdNG1F5NAspJ7+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNjRKPwm+kv3zOsxvd8NgsNoKVZuOBYX7oMl05G3rbs=;
 b=1ksKArV1FTl9bOphfQEqlSBQG2UK/waPYudgJyOYVv/HRcYf1BryitSKNQB7FEF/mxluQzG+Up2+JAVAfCWQ0rww6ATosorwH1OQ8dTqFz6fAHoZCFWuoU6VZVq/2aL8YLcKqwUw0o63EaWwmzD9amRCIw6fcH96ek7KAEVukUq3kZFgPYBF7uBRvePpXW9sBFYLELIICkQePjhGcu7iSph4gsplfSny/Kp6C4/8wU/6qTBz1Wj0+bvxIZ6cR6/QSiwrgYuwF3APOtxgpjrFJ8VNyZcnOkyFuIgP5+CwS8r1peWTDFcl54IrhTuytr8YmEfcX71ULgQ0URiBWfs9oA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by VI1PR06MB5407.eurprd06.prod.outlook.com (2603:10a6:803:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Thu, 31 Mar
 2022 10:08:51 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::d4fa:1226:1eef:f8bf]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::d4fa:1226:1eef:f8bf%5]) with mapi id 15.20.5123.017; Thu, 31 Mar 2022
 10:08:51 +0000
Message-ID: <c3758946-79c8-c53e-b7e0-f745568bfa6c@vaisala.com>
Date:   Thu, 31 Mar 2022 13:08:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Content-Language: en-US
To:     Claudiu.Beznea@microchip.com, netdev@vger.kernel.org,
        harini.katakam@xilinx.com
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
 <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
 <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
 <b643b825-e68a-875e-f4ac-edddae613705@microchip.com>
 <9aa5766c-c94d-e468-d790-51712c6697df@vaisala.com>
 <82276bf7-72a5-6a2e-ff33-f8fe0c5e4a90@microchip.com>
 <HE1PR0602MB3625242F846B81AE086A62E5FD1D9@HE1PR0602MB3625.eurprd06.prod.outlook.com>
 <d049879e-4e98-e17d-d28b-2a2c973c4ec7@microchip.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <d049879e-4e98-e17d-d28b-2a2c973c4ec7@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0043.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:9::7)
 To HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1503a4a5-7acb-4638-e4f1-08da12fe744a
X-MS-TrafficTypeDiagnostic: VI1PR06MB5407:EE_
X-Microsoft-Antispam-PRVS: <VI1PR06MB5407AF2E6EF07C8688AC1D81FDE19@VI1PR06MB5407.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JqZ5+f3nf1DP6abu3e/mB9WtBPceBarFGBsNlfJILkYIgjJ/87rglG2OZuLWEi9vqtQSS6xKRLTVkv/cZDjC4Fmt6/9uSrMTZiVNWWDYE2aq8Pm27Rytog5bbpuTXB1+UF1u8O34079Qf4oxtRd5nhagXPPaZKUkBkHY6fq4X30qZwssaG/LBNq5WDjLYdTdPdqu1Ts/PhY4WgpKyY2DrBBOS5AFvt87u1mttBi8HjOd4ga4xX2nNkLn3vc7/Gh1ry6yE5B2/EUAoqmaPnKMyHcckc+ALZwy40Y0+K6AIzeFQ6sB5Pi6h4A94/oKne6X5sMVPsZ1ObqpE7IjpEuXM0nJcFB3fhcdvjt7e851PraqBZuLe5tIzJZz4gB7g98CufBz1exfHHj2PujJwGG2Zjxsis0lAw44LpUoBUTXi2FBpdLk6GZMrGilhyaH818fefydJhqXY5naT3Ao2ym2AAlgWD1foivSXGm+q5x/hK557mG5L1YdmyT5YV7vlX3GY4EHcK72rxIOYq/CfXVmIBnO37JoZNQPMZKe1QksGiMOBt1VogxKSBEIhSzX0rQ+mVXKxQFyMh+uS1l97M9g3Qs+5VPN8ne1/4XF+ofocopm+i+ytZHOreqvJZaGn5QMZ4msm397HX1wek1nkTVFF2789ubbvXo3PyFnb6hON9j1+fHimbjkZLI9EhvYZXCjXCB+FCv6Mq7iWLDTsvncHPIw/I80NEuhx0mJ30b4in66bML4pirjtalSk1QUNAOWDmOMN0kS9DpXafQLPXMCSezSBNla8E0QK0TFpwbSIGSqZDL9gijMfQxMW6csG1gtxFNFLrKFGZ8ksePYUaj4YWXAJLQbq2EZpbTvYrGeWZVQtMs0aneU/UQsSAUV8NB5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(31686004)(44832011)(36756003)(45080400002)(52116002)(53546011)(8936002)(31696002)(6512007)(30864003)(316002)(6666004)(6506007)(66556008)(66476007)(66946007)(4326008)(5660300002)(186003)(6486002)(966005)(508600001)(2906002)(38100700002)(38350700002)(8676002)(2616005)(26005)(83380400001)(43740500002)(45980500001)(10090945011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STYzTUNhdU5RYlJMMW5vK1ZaVmE1d2NiSlNKVTFEd3R2SlBSSS93SFRKbGNh?=
 =?utf-8?B?UWJzMm5sdE1rYmw2aWlJbVdYMklXUHVzbDZyTlVQa2ZTekwzK0s4dVg0bWhx?=
 =?utf-8?B?SEtVWlpGbEQ4eER3cXVTRjZsSmczMkRlek9jWXBHNTdVZEE3UThXNjQ2Q2pp?=
 =?utf-8?B?QUJjS0ZrSkhLeUFaNk1WUzdTNW5hSWp6SGFaMUVMbVZGcEtBT1ZLeEhCVEJw?=
 =?utf-8?B?a00zWEh5U096SXd6QjZ2UExER0plT3l6OGY4bDk2OThxUE1zVUdCMG81RHNq?=
 =?utf-8?B?RnVQdmt4NW9lc05ISWRpOGFuYU04ZkNKSXJRc0p0S0hJb1J0WkFvTjhUYVZY?=
 =?utf-8?B?ZVZFemdJYlZGTGlxRDcvS3B3eFErc2NROEpyRkd2ZDhOZmpBVnJQUjZCZlVE?=
 =?utf-8?B?d0w0M00xZGhrbWlWNGg1VGxmd2pzU21vTVlaODFMZDQ5RERCa2E4anl4TDJz?=
 =?utf-8?B?RnVZYUZ2RlVTd3k1cG4zS2ZkdXg3dWE3dUw2aGVOUHYvTWNBZ0lRK0JmSkh0?=
 =?utf-8?B?d0J5cnkzMVdTU2puYjd3VWk5VG5JSTFuYW9MQTAyY3BDL1VEcWtrVUFlWHJQ?=
 =?utf-8?B?ZVV0YTZLZCt2b2NvaHJ1aHdCdlIxL2pYQ3NSb0NwQitnWVVUcUlwdnQveEhm?=
 =?utf-8?B?YzhSK1BDQjJWS1Evb3pRQUNmVzRGL0xrV0szQWYyVEtsT0FGWFNvTnpzN2pE?=
 =?utf-8?B?ZlhZYmZEcXlQcGpVWURIZW9xRlkyL0ZrVFpUVEFUQkJBOFFPNjRxOUZaRTY0?=
 =?utf-8?B?M25HNGd2NktkV0VkanM5K0VSdHVhbDkwRzBDbTNWZ1NvYW5pWFhOQ2d2OGEr?=
 =?utf-8?B?WHk5SlJUcXd1eWxUOXhQT2J2RmNrbnh2N2RveEJFSnUrOHpNUGJpTW5DdnRW?=
 =?utf-8?B?R3FWOTdNbFlBZmZWSVgvTFRGMG5kMWQ4M1JiYVAyaWtQMlFaQ1ZwU0t5U0ZY?=
 =?utf-8?B?dnp6cFNIQ3c0elRuMWtkdVFWaTl4VXZVd2g5cURGUDE2dmhZZ0t3VkZQSDhG?=
 =?utf-8?B?TCt0eGJhN2c5Y2pKMnhzTUVXaFR2TVhGaXJNRVZaQ2x1a3R5SUlNR3dsVXpG?=
 =?utf-8?B?VnUxOVZlSC9XeFhlY1Zzc3hPQVNZR1hBWG5UVHdJWktOYWtKTjFORTJUcTVO?=
 =?utf-8?B?VWdhZmVDZm5lVmg5ck1odk5ubHo3ajR1T3hFUDBTYjJhSWQyeFIrZkx1ZDB1?=
 =?utf-8?B?OFF2Y2Y4TnNiTldocmE5V2hnRW56MDN6VlNQRlVuY0VJdmY5TGlFWHdBTjBL?=
 =?utf-8?B?UGpFdmtFQXBGV0lTc3hJMVNNUnc5bG9qRS9jWkgvTnBYQm1hNGRXNUNVMHJz?=
 =?utf-8?B?UGt0YlY0SHo1WTZpaGw4NndJT3FrUXNLSUFtN05DWkFzdzVQcEIwK1BBTW5J?=
 =?utf-8?B?NjdIQ0dDR3dhVGpWUEo2RWJ0QnI4amFkM1dpWWF0RnN5d1p5NjlkZVFTRncy?=
 =?utf-8?B?U2h5S0lMLzJUY3Fqa01ZeG9FcnpMTkF5YVhqL3htZ0R6VktjM1AvaE1uR2Zq?=
 =?utf-8?B?cVlNYkx3OXN4Mnk1TlhiSEhWOEYrMzlhVFJ3WVJiUmR2dkp4RkxBNEl3ejM1?=
 =?utf-8?B?THJvOUI0SGg4WFhDaW1oSjlxL0RjQTkxV1Z3QXhFcHhySExxUHB1ODNrQ05j?=
 =?utf-8?B?SE5VU2tLUlhWUDRlbHlDbXNwRUNFL1g1cTc3S0Z0bTJTZUh5Tks1Ukl5WCt5?=
 =?utf-8?B?ZHpqUnRwSWFVZDdIQ251WE1MSWR6anlIZTZFMWNhWklZWHdFWlF1eGl1bzg5?=
 =?utf-8?B?MStJSXgxRG9qZWZIOVN5QmkvUVZiS1FId2RQOWJiY2Jja0FKYXJVNHZZb1Vo?=
 =?utf-8?B?TWIxRTFleUZMZjlxVU5IOENzc1Rrek9uVnBqTFlTWjY1RVo3UnJ5NGJBMlVP?=
 =?utf-8?B?V0ExeHdnM05oRGtZelYrN0Q4OHdCdEYya2JKSkZHNUxPa2EwajZJcTlqcWNq?=
 =?utf-8?B?Z3hUUXE1SU9oZFdzUjJHTnkxd2V4RFMyU3V2dVZrWkRGaGRQL2p6WkUyUXpI?=
 =?utf-8?B?dmI1UG5kMGFTU1d3NmFEdWkwL0FEQXpEdUFWemVvaEwySTNVeTcrTUpVUFRz?=
 =?utf-8?B?U2VxVTVTYnZFMVhMTWMyaU9TWUVGZzd2RSt5Q0Rnb011ckVTU3VlQXhhZXpE?=
 =?utf-8?B?UVRsK0lqMFh6YXFTNnNvTGFncEp0YmQ0NERSblpZVnJVSm5NTjFPTmRZMUFL?=
 =?utf-8?B?eW04SEFIVDQrYzJXREZvRUxxV054UlZ2YjEwaWdaQ0Ewcm11OFBSYXMzVkw0?=
 =?utf-8?B?c3pQak8wUHhRK1NFZU9iVFpiTWo2SU9GMk5BSC9KbFhKUHN2TWpqUjZjMUY1?=
 =?utf-8?B?YUZwUi9zZGh5UHpLcW5yQVJpQml3RDZwWTM0WjJGck0yQzFrcjNWbDhZYktz?=
 =?utf-8?Q?Dm7Gc49BdxLBMNhk=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1503a4a5-7acb-4638-e4f1-08da12fe744a
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 10:08:51.1061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PIthchlXp0vLpUI10K6GZqcdSLRO2SSTFmTDP6y36jWtxk0qz1Zm3dIJ1TiBc3c9vD3ecukL72//EY8z22L2Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB5407
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 30/03/2022 17:27, Claudiu.Beznea@microchip.com wrote:
> On 28.03.2022 07:16, Melin Tomas wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> Hi,
>>
>> On 25/03/2022 17:19, Claudiu.Beznea@microchip.com wrote:
>>> Hi,
>>>
>>> On 25.03.2022 16:41, Tomas Melin wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>>>> content is safe
>>>>
>>>> Hi,
>>>>
>>>> On 25/03/2022 15:41, Claudiu.Beznea@microchip.com wrote:
>>>>> On 25.03.2022 11:35, Tomas Melin wrote:
>>>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>>>>>> content is safe
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> On 25/03/2022 10:57, Claudiu.Beznea@microchip.com wrote:
>>>>>>> On 25.03.2022 08:50, Tomas Melin wrote:
>>>>>>>> [Some people who received this message don't often get email from
>>>>>>>> tomas.melin@vaisala.com. Learn why this is important at
>>>>>>>> http://aka.ms/LearnAboutSenderIdentification.]
>>>>>>>>
>>>>>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know
>>>>>>>> the content is safe
>>>>>>>>
>>>>>>>> commit 5ea9c08a8692 ("net: macb: restart tx after tx used bit read")
>>>>>>>> added support for restarting transmission. Restarting tx does not work
>>>>>>>> in case controller asserts TXUBR interrupt and TQBP is already at the end
>>>>>>>> of the tx queue. In that situation, restarting tx will immediately cause
>>>>>>>> assertion of another TXUBR interrupt. The driver will end up in an
>>>>>>>> infinite
>>>>>>>> interrupt loop which it cannot break out of.
>>>>>>>>
>>>>>>>> For cases where TQBP is at the end of the tx queue, instead
>>>>>>>> only clear TXUBR interrupt. As more data gets pushed to the queue,
>>>>>>>> transmission will resume.
>>>>>>>>
>>>>>>>> This issue was observed on a Xilinx Zynq based board. During stress
>>>>>>>> test of
>>>>>>>> the network interface, driver would get stuck on interrupt loop
>>>>>>>> within seconds or minutes causing CPU to stall.
>>>>>>>>
>>>>>>>> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
>>>>>>>> ---
>>>>>>>>      drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
>>>>>>>>      1 file changed, 8 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>>>>>>>> b/drivers/net/ethernet/cadence/macb_main.c
>>>>>>>> index 800d5ced5800..e475be29845c 100644
>>>>>>>> --- a/drivers/net/ethernet/cadence/macb_main.c
>>>>>>>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>>>>>>>> @@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue
>>>>>>>> *queue)
>>>>>>>>             unsigned int head = queue->tx_head;
>>>>>>>>             unsigned int tail = queue->tx_tail;
>>>>>>>>             struct macb *bp = queue->bp;
>>>>>>>> +       unsigned int head_idx, tbqp;
>>>>>>>>
>>>>>>>>             if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>>>>>>>                     queue_writel(queue, ISR, MACB_BIT(TXUBR));
>>>>>>>> @@ -1665,6 +1666,13 @@ static void macb_tx_restart(struct macb_queue
>>>>>>>> *queue)
>>>>>>>>             if (head == tail)
>>>>>>>>                     return;
>>>>>>>>
>>>>>>>> +       tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>>>>>>>> +       tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>>>>>>>> +       head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp,
>>>>>>>> head));
>>>>>>>> +
>>>>>>>> +       if (tbqp == head_idx)
>>>>>>>> +               return;
>>>>>>>> +
>>>>>>>
>>>>>>> This looks like TBQP is not advancing though there are packets in the
>>>>>>> software queues (head != tail). Packets are added in the software
>>>>>>> queues on
>>>>>>> TX path and removed when TX was done for them.
>>>>>>
>>>>>> TBQP is at the end of the queue, and that matches with tx_head
>>>>>> maintained by driver. So seems controller is happily at end marker,
>>>>>> and when restarted immediately sees that end marker used tag and
>>>>>> triggers an interrupt again.
>>>>>>
>>>>>> Also when looking at the buffer descriptor memory it shows that all
>>>>>> frames between tx_tail and tx_head have been marked as used.
>>>>>
>>>>> I see. Controller sets TX_USED on the 1st descriptor of the transmitted
>>>>> frame. If there were packets with one descriptor enqueued that should mean
>>>>> controller did its job >
>>>>> head != tail on software data structures when receiving TXUBR interrupt and
>>>>> all descriptors in queue have TX_USED bit set might signal that  a
>>>>> descriptor is not updated to CPU on TCOMP interrupt when CPU uses it and
>>>>> thus driver doesn't treat a TCOMP interrupt. See the above code on
>>>>
>>>> Both TX_USED and last buffer (bit 15) indicator looks ok from
>>>> memory, so controller seems to be up to date. If we were to get a TCOMP
>>>> interrupt things would be rolling again.
>>>
>>> My current supposition is that controller fires TCOMP but the descriptor is
>>> not updated to CPU when it uses. Of course is just supposition. Maybe check
>>> that rmb() expand to your system needs, maybe use dma_rmb(), or check the
>>> ctrl part of the descriptor when head and tail points to the values that
>>> makes the driver fail. Just wanted to be sure the concurrency is not from here.
>>
>> Thank you for the suggestion. I have tried dma_rmb(), and the behaviour
>> is the same. AFAIU dma_rmb() is a somewhat more relaxed version of rmb()
>> (atleast on ARM),
>> so I guess using those should be ok in the first
>> place. Or do you see differently?
> 
> Yes, should be good. Reviewing the thread I see you are talking about Zynq
> which is also ARM based.
> 
>>
>> Ctrl part bits of descriptor looks normal also for the case when this
>> happens.>
>> Basically how I understand this is that if we get a TX_USED interrupt
>> without eventually receiving a TXCOMP that indicates some kind of error
>> situation for the controller.
> 
> Yes, that should be the case. What I asked you in the previous email was to
> be sure that TCOMP interrupt has been received and CPU didn't miss updating
> software data structure due to descriptor not updated to CPU due to
> improper usage of the barrier, as follows:
> 
> IRQ handler
>       |
>       |  TCOMP
>       +----------->macb_tx_interrupt()
>       |                     |
>       |                     v
>       |               read descriptor
>       |                     |
>       |                     |
>       |                     v
>       |<------------!(desc->ctrl & TX_USED) // make sure at this point
>       |                     |               // reflects HW state
>       |                     v
>       |                 advance tail and
>       |                 tail = head
>       |                     |
>       |                     |
>       |<--------------------+
>       |
>       |
> 
> If the desc update is not done when a TCOMP is received then head != tail
> in macb_tx_restart() and TSTART is issued again but since HW did its job
> and TBQP points to a descriptor with TX_USED set it will fire TX_USED irq
> in a loop >
> Now, if you verified this and all good with the descriptor then it may mean
> HW does something buggy.

I believe we see this the same way and you have a good hypothesis.
That location in the code is potentially a place where things *could* go 
wrong.

As mentioned, ctrl part has correct bits.
Also to me, there is no obvious problem in the code around that point as 
such. And dma and normal version of memory barriers have both been tested.


> 
>> This patch builds on the same approach
>> that added tx_restart() in the first place, adding support for case
>> where driver will otherwise loop indefinitely on interrupt.
> 
> The assumption on macb_tx_restart() was that TX stopped due to concurrency
> b/w software updating a descriptor and HW reading the same descriptor, thus
> TBQP didn't advance. On your situation the TX didn't stopped but it seems
> it succeeded.
> 
> One thing I fear about this patch is that freeing data structures
> associated with a skb relies on sending another packet and that being
> successfully transmitted (w/o the issue being reproduced again). If issue
> is reproduced in a loop then in the end system will eventually stuck again.

I understand, but that does not seem to be the case with this particular 
issue.
The problem unrolls as soon as new packets are pushed to queue.
If we encounter that kind of situation you describe,
that would need to be handled separately.

I propose now to concentrate on a solution for the actual behaviour we 
have seen. The addition of tx_restart() exposed the issue we have seen,
because if we ignore TX_USED interrupts this is never visible.

This is why I believe adding these additional checks to tx_restart is
the correct approach.


> 
>>
>> Claudiu, would it be possible for you to test this patch on the system
>> that you originally had TX_USED issues with on your side?
> 
> I don't have one with me but I'll go to the office and grab it. I need to
> look further for emails to see the proper setup (the initial issue
> reproduces only with a particular web server and a particular setup for
> it). It might be difficult to replicate it.
> 
> MACB support for Zynq is enabled for quite some time and you said that you
> reproduce it pretty easy without anything fancy. Maybe Xilinx people know
> something about this behavior. Harini, do you have an idea about this
> behavior on Zynq?

My comment on this is that I was also surprised not to find other 
reports about this. But also for us, this issue was not visible for long 
time even with identical kernel version. As load and other parameters 
have changed, the situation has become more easy to trigger. So it's 
likely the conditions need to be correct.

Thanks,
Tomas


> 
> Thank you,
> Claudiu Beznea
> 
>>
>> Thanks,
>> Tomas
>>
>>>
>>>> Ofcourse this is speculation, but perhaps there could also be some
>>>> corner cases where the controller fails to generate TCOMP as expected?
>>>
>>> I suppose this has to be checked with Cadence.
>>>
>>> Thank you,
>>> Claudiu Beznea
>>>
>>>>
>>>>> macb_tx_interrupt():
>>>>>
>>>>> desc = macb_tx_desc(queue, tail);
>>>>>
>>>>> /* Make hw descriptor updates visible to CPU */
>>>>> rmb();
>>>>>
>>>>> ctrl = desc->ctrl;
>>>>>
>>>>> /* TX_USED bit is only set by hardware on the very first buffer
>>>>> * descriptor of the transmitted frame.
>>>>> */
>>>>>
>>>>> if (!(ctrl & MACB_BIT(TX_USED)))
>>>>>         break;
>>>>>
>>>>>
>>>>>>
>>>>>> GEM documentation says "transmission is restarted from
>>>>>> the first buffer descriptor of the frame being transmitted when the
>>>>>> transmit start bit is rewritten" but since all frames are already marked
>>>>>> as transmitted, restarting wont help. Adding this additional check will
>>>>>> help for the issue we have.
>>>>>>
>>>>>
>>>>> I see but according to your description (all descriptors treated by
>>>>> controller) if no packets are enqueued for TX after:
>>>>>
>>>>> +       if (tbqp == head_idx)
>>>>> +               return;
>>>>> +
>>>>>
>>>>> there are some SKBs that were correctly treated by controller but not freed
>>>>> by software (they are freed on macb_tx_unmap() called from
>>>>> macb_tx_interrupt()). They will be freed on next TCOMP interrupt for other
>>>>> packets being transmitted.
>>>> Yes, that is idea. We cannot restart since it triggers new irq,
>>>> but instead need to break out. When more data arrives, the controller
>>>> continues operation again.
>>>>
>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>> Maybe TX_WRAP is missing on one TX descriptor? Few months ago while
>>>>>>> investigating some other issues on this I found that this might be missed
>>>>>>> on one descriptor [1] but haven't managed to make it break at that point
>>>>>>> anyhow.
>>>>>>>
>>>>>>> Could you check on your side if this is solving your issue?
>>>>>>
>>>>>> I have seen that we can get stuck at any location in the ring buffer, so
>>>>>> this does not seem to be the case here. I can try though if it would
>>>>>> have any effect.
>>>>>
>>>>> I was thinking that having small packets there is high chance that TBQP to
>>>>> not reach a descriptor with wrap bit set due to the code pointed in my
>>>>> previous email.
>>>>
>>>> I tested with the additions suggested below, but with no change.
>>>>
>>>> Thanks,
>>>> Tomas
>>>>
>>>>
>>>>>
>>>>> Thank you,
>>>>> Claudiu Beznea
>>>>>
>>>>>>
>>>>>> thanks,
>>>>>> Tomas
>>>>>>
>>>>>>
>>>>>>>
>>>>>>>          /* Set 'TX_USED' bit in buffer descriptor at tx_head position
>>>>>>>           * to set the end of TX queue
>>>>>>>           */
>>>>>>>          i = tx_head;
>>>>>>>          entry = macb_tx_ring_wrap(bp, i);
>>>>>>>          ctrl = MACB_BIT(TX_USED);
>>>>>>> +     if (entry == bp->tx_ring_size - 1)
>>>>>>> +             ctrl |= MACB_BIT(TX_WRAP);
>>>>>>>          desc = macb_tx_desc(queue, entry);
>>>>>>>          desc->ctrl = ctrl;
>>>>>>>
>>>>>>> [1]
>>>>>>> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Ftree%2Fdrivers%2Fnet%2Fethernet%2Fcadence%2Fmacb_main.c%23n1958&amp;data=04%7C01%7Ctomas.melin%40vaisala.com%7C6033e443aec34049f9c308da125966c2%7C6d7393e041f54c2e9b124c2be5da5c57%7C0%7C0%7C637842472480310420%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=UEVT3ToG3UOogZDjHbdTG5BTj9PRztUY8%2Ft9HkADS2k%3D&amp;reserved=0
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>             macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>>>>>>>      }
>>>>>>>>
>>>>>>>> --
>>>>>>>> 2.35.1
>>>>>>>>
>>>>>>>
>>>>>
>>>
> 
