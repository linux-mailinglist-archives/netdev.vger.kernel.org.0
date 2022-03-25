Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2431D4E700D
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 10:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357469AbiCYJhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 05:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344774AbiCYJhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 05:37:23 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19DB694A3
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 02:35:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLxQPPJXRV66eKB+KjGu3A5VxBdSFbroKoymjA8mvXTrT3ltFLGBeqqUEDnM3yp+oMr2AigvQ05PrRhqdb08tvr2VPC0ed2lNOWEx7YE4u2+PJigc6WiJeMOP0lyHK4hCa6a3zrwF5HnsT3PTjWk79xEF4VNGex68d2lyrAtTQ2T6fuiK7yvQEh6Jo3S2nSASorlM1f20OJsH20VMvwiPyowV8vBKV9hA9zqSuWhoq0UW1K8dL6/6wmddQXciQdL/itkgh7/1iNQlOOpX6HT4E6BpTCegVwH8ZoeY12dxdbZ6jG/5W3vZkyfXOU0WwgNg83gpww5AHxZoHIdebRmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3Y9IiKpESrz31c7EaNlYkNxZkVcSVQ7AR03yYtQFPc=;
 b=jd14qawBX4B5xB71QJZ6YFaYvgGjz112AknrLuiT84d+7wO8KA1vlsYt/rFNC/BMDXUzdNZ+WCGQK9RfcDrl+5U5F++iCFt6KHiyfcdy36KBRTFN87AB9BwLlPHg/dwMBMC0rN+Rjay2k+U0eo2m6C/e9Ihlb69+7zg/h34ryT2OrCK0MdKTagEvKEI9pbRYlNNtGCLQFNOkj8DMnZpV+sjafn9FeDzcfVA9aszpe52et6cV04rpwRZwP6j8fqBvSPwYo667GiIjWyNvbTodExDEpT9GVG54eagRoxCMbk+c2S90jRQ+XFdlgKD/7ChW48PsHZOTOToQI7iPfqqVFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3Y9IiKpESrz31c7EaNlYkNxZkVcSVQ7AR03yYtQFPc=;
 b=fYXwmgsXsCmHsJ6MCgPqfUX1Q85VmxHtDY8sQM4ymVswIMu1E9+7qZY7RhFcGh5lig1S10jTl4gh17Dhx/8j6cc8PC5VuNMLogsinyxKYiVrY85h9bFrOiMMlF8jqP5TB6/ISMxyweeAb1TsrWRYsqdNtYfh3dmbCaoI5uQA46W1sM9gmYWrwqT0l2cZvxblnfPJB2RrX6fqY4a19xF85IXpKRUGQ7HPt+7TTHXrxtWCnJ6Zuqa4XORkedMmAlkkqzb8sabToUEG2Gn+wixxkkYBtMqOI3L9nqf4jvzABZ2WjHM07eqQxKHPsRRAdDLtLjmZLiD2QwZs1W3/Vx2j7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by PA4PR06MB8450.eurprd06.prod.outlook.com (2603:10a6:102:2a2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.19; Fri, 25 Mar
 2022 09:35:46 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.025; Fri, 25 Mar 2022
 09:35:46 +0000
Message-ID: <7310fea8-8f55-a198-5317-a7ad95980beb@vaisala.com>
Date:   Fri, 25 Mar 2022 11:35:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] net: macb: Restart tx only if queue pointer is lagging
Content-Language: en-US
To:     Claudiu.Beznea@microchip.com, netdev@vger.kernel.org
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
References: <20220325065012.279642-1-tomas.melin@vaisala.com>
 <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <64feeb9e-0e28-0441-4d42-20e3f5ec7a7a@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0072.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::7)
 To HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5174ba0f-e1b9-4fa3-668a-08da0e42d6b2
X-MS-TrafficTypeDiagnostic: PA4PR06MB8450:EE_
X-Microsoft-Antispam-PRVS: <PA4PR06MB8450A4C7F238006B53B05718FD1A9@PA4PR06MB8450.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xOkSszyThgSd4c/uVRwfyj35pQAxzecbdn2yRkqCHVDnj+ZRMyBXwjK0tdbCfL8xh73pr5g185rg/8jQUZeSZzHxvit0ut1YXvfILlVBOp67dgBEBchCPI2AeVtEgRX2VlbjJVKDiKSGMhXDdwYyNqwr1b/2nAwrPT3zOxmep2gdV89fvpetFKV1ssX7fumW4WwMbsX87o4xpp6DQ2R8NwGyjPSXfFIic4irRDTc7cy8toiESiwWr7L0eZwUxIYEnTa0TdE0pk5QJo/BaHUKhDhu2A+EZPWjDNMJzrfJT7VBgQVV+vGXk0KtAGYWW+QIp/N8VLCopWBv0fb/Axn02yM50i6IndeaWwKORsorkW/2STAnTdQ4Dy0lWO+pfbHO7MXT2SIdULjNjGfVYCMZsOGR7jafV0UhiOVBtoOJP18BnMweNi6rpM+wydxmokGaB+7Tj6FZ5clvZB6aUA19SBFg9Kz//Hw9wqcQB7Srrmvey78Pmct2Ij3HW/9ZPO6ziO0viiEX8+irwbQubZ1NaTcqVcEEkYXc2BOqhdIByugSRmHc1urQBx+w/vS6Rbf48/N7uZVXMrEVUVeV+mU8RXDxDOFNmvGKoJFgdWgz39MkMCvvQ5s5T095zk5SVARtHG5bta0q7c/Al9RP2luK0k9HCXG17eJHGM59CL+/911yolBmP94vpAO/lVtXPL7cNY68PKHyKvOfkj0zbFQKDvsbb6EpKpaA2AEZkc5qdm0P4wjjBun5ofTgFnLIXmpBifAd7n8BRMfrZu/Bz4HfCgvOk28Qg3xsufyTbXYBoETxj1luT+YMEtqtWbqAxqWfDrxfxAo1ZlM0P7opmq1Tce7igfn1f5scTrpnJKvgoGxlJZR9zXPqq/E+6jow/O89
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(6506007)(508600001)(53546011)(52116002)(6486002)(4326008)(36756003)(6512007)(966005)(38100700002)(44832011)(31686004)(8676002)(31696002)(38350700002)(186003)(45080400002)(8936002)(66476007)(86362001)(2616005)(26005)(316002)(66556008)(2906002)(83380400001)(5660300002)(43740500002)(45980500001)(10090945011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NlEveHBQSWZlR245N2JLVFJvT2VNUkVCOHRYQ1p3bVRhWHNpOXhIYW9rSmc0?=
 =?utf-8?B?Q2tvS0tBZVB4WTdtS1BHakF4b1ZHTTU3cWFIaFpZazh2QXp2WXBhL0tmMlhm?=
 =?utf-8?B?WFcwUHUxcTIrYVFLYTYxQTl0bFhYVnVDNXhaVy91eWUzSVBzaHJzbTBOZ1Bt?=
 =?utf-8?B?bkEwOUJIZlVPZzNUdC9xb2tyRVJwcittcXdKRTE2ajBOalVLWmhhc1FCVmp5?=
 =?utf-8?B?OXJlbmFvRzJMSnpsbXZFRFlEdnJWQWFwRVlaL0JQaHFsdDhHWm40WE9HZnc2?=
 =?utf-8?B?SDFoQTVFSjNMdWR3MDNqWGZnSmRYOGI3ZG9OdnhKNldLOXV5NytnVlJqVjk1?=
 =?utf-8?B?UGlDdDFVc0JwMEcxTVZIM2V2bkMxV3hiMGtBSzdTYXNDb1g2aHZBaHZJRzFu?=
 =?utf-8?B?c2pCSGhxVjVjU0hSckNJT3M3dTBsRU11bEd6ODY5NjRlYUI1ZlVBNmJ6dUpn?=
 =?utf-8?B?dGhieWthb3hodnFGL2EzT05Ob1ZTR3Q2Wkg3TGFmYkFpc0k4Wmg2UVRlYmZj?=
 =?utf-8?B?Umd6ZEdIaGdrQzBUTnNSUE5ycGw5SThXZXRJbkpkZ1h2eHd2cjFMcWZOSGhM?=
 =?utf-8?B?RmJSazdQTXhCeU5NWitVdWNSOTdjRDBBb0ZKT2djc0xqalRoT2szVGF6N3NJ?=
 =?utf-8?B?TFYvdWIrd1h2Z3FnRnJiVkhMclJxUFRuUzdaRzlNemVIZVVXaFJmUnEvMXFk?=
 =?utf-8?B?M29zSmlsT2pJSnNNeExycEd4OUtkak9YTlZvRmJaOEN0emFPN2UvbVNhZ0dS?=
 =?utf-8?B?ZDJ0UDBETWx3UDdkZHkvM0RuQ3ZHNk44Vnc3S1BkeUVHK1c4S3JNNlF4elhr?=
 =?utf-8?B?RnFFWitVK0VwUnNSbjdocGFhTEExbUI2LytVQWFxWURtcnNpeFhLYm5rNEJW?=
 =?utf-8?B?L1VxSXpDd1YvaE84ODBIempodk42WThES0svSW5ZUGg4SVV6Y3FIVThKQ3Q3?=
 =?utf-8?B?TG40NFg1VVJJOGNlZGxUeHVKNUlEeFIvT0YrbVpEOEoxM20yTkpmV0J0NkhK?=
 =?utf-8?B?eGhKdWN6MjNPVUE0eVFJNDlzcU14TDVBM0V1T1Nxc1QrM0JqZ1FLMFlvU05z?=
 =?utf-8?B?VGtySlBoejA1blNwcHpSVnAvUUdlcjNKL2ZHSkZIWElEOXJZQUJtM2szUS9n?=
 =?utf-8?B?c2Z1Q1ViNG9EL2RpQkkxRS93SG9SYnFwRk9PaFRpWjZhZmUvQWpQZ1lWMFh0?=
 =?utf-8?B?Njd1aFozcTNiSzFVWXg3Q3RHZkgrbmU0Qjl3QVFvbm41Q3NhV3oyMGx2ZmxY?=
 =?utf-8?B?K0NQemRERGVmcEdOQVR5eldrNG9jbi8rU2lJY1NFbkJ4Y1ZPRkpua2ovbzYx?=
 =?utf-8?B?N2RySVF5NTUrVUZXNkFkNUJhWDNrQ2NZd2ZQKzJZNk5MNzdTeGJMSWF0d05T?=
 =?utf-8?B?cDk0QmZFU3pmYkk1OEtzczhtRVY2Vk5jQmY0OWR2VzZXTC9KdlBKVWZaZlFs?=
 =?utf-8?B?NEdSYlg1SXBPNkRUa2g1bjd5N2xCOTFPTjNVQlhodkdjeVJGWGdrTTU0djEx?=
 =?utf-8?B?aXZVVHFQZ3hGOC9qM3hqcE5OWU1vdWNTSnFLVzlqL091YklMbWRBci9rc3VU?=
 =?utf-8?B?eXc0OVc4dTRVTm5KMy80SGFpdmVJclFma3pyaGlGdG45YkE2U28yQkxwM2xp?=
 =?utf-8?B?ME16eXpsYU4yalpXck8wQ094cE5XYTMydlUvekswRnFmMmg1NXV5bFRPQXVh?=
 =?utf-8?B?N3hEZjF6eEtjWGhvUEFaVXhPTTZmUGdSNlRCcEpnOUpZMTloRStZS2t4TFUr?=
 =?utf-8?B?V0tvVmdxYnAxLzlXUWhIN1VWWFY0azV3SjlyNC9VZTRmQkQ4dlhidTRaSmw3?=
 =?utf-8?B?QnJjaittc3NEOG5mRWhWRmtRVWpodHFuSGtLUHRHZmhmekg1eWUvUHJZUVZG?=
 =?utf-8?B?SjgzNU1JcWx2bFFTTmxrczlwaEE5ZTBzUXhlQ0prZ08xMTNlckhlU2xqUXVL?=
 =?utf-8?B?TCtXWWl6S291TTNhaisremt0RUJFd3d6VDdUNGw2L3hSdGNjeldETHpEeHJs?=
 =?utf-8?B?QkwzMFpoY3V3PT0=?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5174ba0f-e1b9-4fa3-668a-08da0e42d6b2
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 09:35:46.0242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IPaZn6IM5I6uvzyiaq1B238YMPqjUiNLJ1OcJAdpPwBOjT3cwxgspWmk6OUNR5DU87PL/bzaFiZpyZgcr1rLVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR06MB8450
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

On 25/03/2022 10:57, Claudiu.Beznea@microchip.com wrote:
> On 25.03.2022 08:50, Tomas Melin wrote:
>> [Some people who received this message don't often get email from tomas.melin@vaisala.com. Learn why this is important at http://aka.ms/LearnAboutSenderIdentification.]
>>
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> commit 5ea9c08a8692 ("net: macb: restart tx after tx used bit read")
>> added support for restarting transmission. Restarting tx does not work
>> in case controller asserts TXUBR interrupt and TQBP is already at the end
>> of the tx queue. In that situation, restarting tx will immediately cause
>> assertion of another TXUBR interrupt. The driver will end up in an infinite
>> interrupt loop which it cannot break out of.
>>
>> For cases where TQBP is at the end of the tx queue, instead
>> only clear TXUBR interrupt. As more data gets pushed to the queue,
>> transmission will resume.
>>
>> This issue was observed on a Xilinx Zynq based board. During stress test of
>> the network interface, driver would get stuck on interrupt loop
>> within seconds or minutes causing CPU to stall.
>>
>> Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
>> ---
>>   drivers/net/ethernet/cadence/macb_main.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
>> index 800d5ced5800..e475be29845c 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -1658,6 +1658,7 @@ static void macb_tx_restart(struct macb_queue *queue)
>>          unsigned int head = queue->tx_head;
>>          unsigned int tail = queue->tx_tail;
>>          struct macb *bp = queue->bp;
>> +       unsigned int head_idx, tbqp;
>>
>>          if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>>                  queue_writel(queue, ISR, MACB_BIT(TXUBR));
>> @@ -1665,6 +1666,13 @@ static void macb_tx_restart(struct macb_queue *queue)
>>          if (head == tail)
>>                  return;
>>
>> +       tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>> +       tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>> +       head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>> +
>> +       if (tbqp == head_idx)
>> +               return;
>> +
> 
> This looks like TBQP is not advancing though there are packets in the
> software queues (head != tail). Packets are added in the software queues on
> TX path and removed when TX was done for them.

TBQP is at the end of the queue, and that matches with tx_head 
maintained by driver. So seems controller is happily at end marker,
and when restarted immediately sees that end marker used tag and 
triggers an interrupt again.

Also when looking at the buffer descriptor memory it shows that all 
frames between tx_tail and tx_head have been marked as used.

GEM documentation says "transmission is restarted from
the first buffer descriptor of the frame being transmitted when the 
transmit start bit is rewritten" but since all frames are already marked
as transmitted, restarting wont help. Adding this additional check will 
help for the issue we have.


> 
> Maybe TX_WRAP is missing on one TX descriptor? Few months ago while
> investigating some other issues on this I found that this might be missed
> on one descriptor [1] but haven't managed to make it break at that point
> anyhow.
> 
> Could you check on your side if this is solving your issue?

I have seen that we can get stuck at any location in the ring buffer, so 
this does not seem to be the case here. I can try though if it would 
have any effect.

thanks,
Tomas


> 
> 	/* Set 'TX_USED' bit in buffer descriptor at tx_head position
> 	 * to set the end of TX queue
> 	 */
> 	i = tx_head;
> 	entry = macb_tx_ring_wrap(bp, i);
> 	ctrl = MACB_BIT(TX_USED);
> +	if (entry == bp->tx_ring_size - 1)
> +		ctrl |= MACB_BIT(TX_WRAP);
> 	desc = macb_tx_desc(queue, entry);
> 	desc->ctrl = ctrl;
> 
> [1]
> https://eur03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%2Ftree%2Fdrivers%2Fnet%2Fethernet%2Fcadence%2Fmacb_main.c%23n1958&amp;data=04%7C01%7Ctomas.melin%40vaisala.com%7C2fe72e2a6a874b5279a708da0e3d7852%7C6d7393e041f54c2e9b124c2be5da5c57%7C0%7C0%7C637837954434714462%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=hijcfj3TnOxj12dhG0Q8d0AJNFNBJSxtEjOTkCoZThI%3D&amp;reserved=0
> 
>>          macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>   }
>>
>> --
>> 2.35.1
>>
> 
