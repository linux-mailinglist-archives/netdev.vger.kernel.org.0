Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A693C518116
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 11:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbiECJiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 05:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbiECJiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 05:38:01 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60078.outbound.protection.outlook.com [40.107.6.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2222A289B7
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 02:34:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjSdi0kSl9cqgsebKAO/zIvhOyaZMs5es0Yls0hHb44Ue5bvvg5GfkPBzbp+P0E83/lTHZgBog0VQwL1HvBiHu54Aih3dyI3FtuUVTUEkcokDSbgBcGDuCEOzRPJXOkxd/kpeeEfdUPYQPw+6R//jPYYfN5WidvxZQybcF/b361VBY4fdHD0p1TLFk+bfbO3m4Rn4VCA1RtSC2RGhMWyyZABk5Vu8KQ5bW35L4L1pNQUSMZ9ytDYCsn8p0RAg4V3TsRAmyUJUE/oifdcq36norIyjt47J7DO9wMuxZVIJa8VAgbFhAndWijfbowWVuH82oioxK90OaSpRYfSkXMhgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osxAFlF0Pp2+W5MGKA2sDwDI70SmBgc01/EhTVlVEyg=;
 b=VOrXNxdI9yi7Ra5fcmIRJjZXCn2kx5wq+gi6jITbI6eG3oC8vVa/C3gTzIcL4gSJ6C1M8CEdN02RWa8RjvyuN+2n8La6YmbvZAm8dedY1h0KQN3bxy7HXS4G4hofspZA1U47nfwzR7kGZ3bsmCugJesWJESvAlw1VFGM4fa40seHwDm473lQFvTcs1hT5ODh8lPgpGlTEdlkSPYGycqt5mp+KINmW7YLqVY0WfVboGfZxII1IZkwhD4V9j1ooqRGxL2VXBlxG6Ans2bMkbwmvdGZdzLE3KaAK21b2rFbJHm7MxJGQrFCuHow5TWdGyyFSaALBrnMXv+1022e64ffRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osxAFlF0Pp2+W5MGKA2sDwDI70SmBgc01/EhTVlVEyg=;
 b=CGJNRjc/hpKYk2xUMCJLv46RQEpBmjwhgLTOQivItNPE3Zl/iyfLZxBbWTFyosB8UowsR/cP2zsk8rOFMegCHj5l8NOg1G88zj0m26Qr3en0HRIWbowVftJXH7b923ZUjbr8lmZDMxBfCOMZ0AptL42ADy+w69b9MmrFl9WwqDJQyjtNS8vFDDHUIO/R2x7cD1jaND5qZa8XuxZ1qFahrk5BV9MbYzLyt3HyRaRYg5JENr2BGPmeMYw4xTXyEj0FQ+Fo3FZgh3boxeQLsb5nQWaR4CIUt6UiDNPw6vGt3CrYTQC2o7FfnVXTjtwiAq4L+NC2YATKMLEVkgMQbkvS4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM6PR06MB5431.eurprd06.prod.outlook.com (2603:10a6:20b:87::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 09:34:24 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::5872:9ec6:429c:9de7]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::5872:9ec6:429c:9de7%4]) with mapi id 15.20.5206.012; Tue, 3 May 2022
 09:34:24 +0000
Message-ID: <7b84cace-778b-2a73-a718-94af1147698a@vaisala.com>
Date:   Tue, 3 May 2022 12:34:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 2/2] net: macb: use NAPI for TX completion path
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
 <20220429223122.3642255-3-robert.hancock@calian.com>
 <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <555eee6a7f6661b12de7bd5373e7835a0dc43b65.camel@calian.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GV3P280CA0031.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:9::22) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55e91b9b-e493-4fb9-e559-08da2ce81c27
X-MS-TrafficTypeDiagnostic: AM6PR06MB5431:EE_
X-Microsoft-Antispam-PRVS: <AM6PR06MB5431C533A94D232BF7B37D85FDC09@AM6PR06MB5431.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vy3in0QCwQKLes5GAwkQt0n0ZVXeBIDzFjS16RdNeZIlO7D0efcPpuRQwPKW//kJ7L4ezAvRpmE+FumZNp7p2cPKY3VCOFNtPEQFTT8heXMhOBSeu6p9VNSyEmA1gbIpHJ9KDsKTlNdgDNxXqzC5IBwSGMqIftsI905dKCaqy3Wa/TpwQIgKz2KFgLHHFR2ntXSHsG6KtqsBj8b67vy1uFhPV686nnaTPZRkCsbgA6it6leUQf4zIpvT4/PsIFZzTbPOAVAqQS3FL69vEm+sqvtab6G8N3jUBbPT+3uFQXGkBqJrYJLxPM5Rhp+pmtGiXWLK673VRdX7cY3Foh9InVSTQDHmHx2Rk+WYhy7bgFhURl5K1savSDkxSBzlM1U3K7B5ZlagYeqaw5B5eY/d2pPfxgka+KWlxQVOP0c5DmIbpappTA59jM5Ba2SM+ggZ5bnMAw+5Icbp/jYIP4B+vnbGGwNEJpG/TXTw6RQOLzEjE5z8XT3H2kGQx1nCeSBgccYAN1KfnQyz03uTk4izhG7IHs/i6QqWN8kTsxUFYJMiN4K/j90fHH0YyZHxZz3Mz63+R8Q71ob8YCu9M4VoueEkJUXxG4p1/Mex4oQ/xODHKw+A2IWpGOKrm5JG3f6Y8BZKPRC4CF/25zi/uDqEPEO/ZF2GqfAPM1+51C8ObiPYukI7RefqFrnxtu9XQqjbREg+N8uVwKlBgX57BG5Ss+Ywgez5N1tqTecOtTQKiCDBk2nOZBvPiW/2GxWE6RZC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(6506007)(53546011)(31696002)(6512007)(26005)(2906002)(6486002)(8936002)(38100700002)(508600001)(6666004)(30864003)(36756003)(44832011)(5660300002)(4326008)(83380400001)(8676002)(66556008)(66476007)(66946007)(31686004)(316002)(186003)(54906003)(110136005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVhaN2xvdUdGUFlIaXN2TEV3UUd6ZVRUSGRRaEZVQkdSR0JqS2pyMHdNWmhp?=
 =?utf-8?B?MEwwSEtCNm5laFVvUER4OCtzZFhjaWVQSnNFZTNEZ2dNbGJ1alVjUXN1czVi?=
 =?utf-8?B?L2hFYWRoeDhNNlpSQVB2WlBEMHF5OHRvSjZUbC9NNHBLZHQ5Z1hoWDRWMmdD?=
 =?utf-8?B?OEZ2UGxYTnFya3A4NVFTL0g0OTJObFZlWFJSRVZoY2xZVzNlRktURytNTUpG?=
 =?utf-8?B?SGNnVlpuRnE1ZTN4R2VrKzRZOXRsejlZZmVOMVBnUHF6QTY4ZE0wSkJObExw?=
 =?utf-8?B?cUh4RlNKUW1ENURVbTlkTWhTNXJuTEVZcjMwallZejdnTHlyRE5IdGNERGJB?=
 =?utf-8?B?MFB1K1EzLzlkSkhBZGlmUURCdGpCeEttRU5CZXdXMisvQmdvOElLVWlZLzI2?=
 =?utf-8?B?YVBQTXo1QUs0TEttU0RocDIvbjlBZ3grOXhvWXFHdE5jMTZRLzhKTXhKbEd3?=
 =?utf-8?B?eHUzcFJYUUp3MGcyend4b3htNWRaR2NXT1pDL0tmaHAzMzRwL3RwL3NhZ29z?=
 =?utf-8?B?dzBtZC80WGFrTENqcmRwTnRZSW5pZXlCaVpHMDNZMFd5amZEQlVkNFAyV29n?=
 =?utf-8?B?Vk1LYkk5MHZvN0NKUHRNbXFIWDIwOStIZ21iZms3UDBQV3RtVkJ0Slk0aWhr?=
 =?utf-8?B?elU2VWhwMVcyUDI1UlBCQ1QwcUZza3czRVM2U1ZQZ0toaHFhMGU0MjBhODE5?=
 =?utf-8?B?c2RmNUREbVVrRGlxR1ZrcFltVDlpM0RpdUxZVU1ZalJUREJsU3hDbjFVMm9M?=
 =?utf-8?B?N1hDbjAzV3FDcE91YWV6RWhkL0RlS3ZOQS9NZC95dTNmQ3h1UTBFdk56eFJI?=
 =?utf-8?B?dHN2UGlVS05MdE10cDFSOGZjUGw0c042ajVmdTZJT1FPczdMQ1FsbkF5NGs3?=
 =?utf-8?B?SkZESmxYbVR4QnlhNlljNkpuSEQvQytOZEtkV1dtU1A3eDFuRG11NUJERkw2?=
 =?utf-8?B?eml3NUlKckZkL2JoRzFvaDBKM1hSMzhGbThzdXhYNTd5VEJkVmNQTGFIV1d1?=
 =?utf-8?B?MjVld1RRMmhabmtUWDc3d0dpS1diZ216YkcxNy9DK1JZKzRGS2NJSzRnTlVF?=
 =?utf-8?B?azNHZ244UXBKTzZrZzUzOENNRmpVR29QcnU3eHliQ2FMWEFVRmk1U201YnBi?=
 =?utf-8?B?VDVpR2VEN0dwb2w4Qk1uNlUvRUM0THl2dHV3U3BvTEFvNzc0emgzU1NtMlhk?=
 =?utf-8?B?bHJQclBXa3VBY3Z1TmwrNUM0MVE2Mm1YNjJGRWErZnNXclY4aHVHdzhDWG8x?=
 =?utf-8?B?Y0l3WVlBWVlQaTJpZnV2Tm8xS21saUpSSlJ4bFlSRG9CTnhqWUtYbDRxYzla?=
 =?utf-8?B?RHFxaGxSUEFRSkFSU2YrZmFjb252NERET3pzQjkzSjU4OG9Nc1N6NXRoTDc2?=
 =?utf-8?B?U0xMNUp1Zkl3VG5USzJIQjhkczZ2dUNUb1FIeTdPVVF1emJUZW9hWTRXVS9C?=
 =?utf-8?B?dEpwMFJYOTBRNzBMSG9QSVJIMW53eThObHFHS2svWkkvc1kyRG56RXZJVnA4?=
 =?utf-8?B?NkZIQi91dlh3RTFrZ3EveWZkZXFxSHZZcGszbXh4ODJQdWZFSzBrNWR5Ykhj?=
 =?utf-8?B?T0hGbjNYZy8yS2dCTWFsUDIrbTVHbFFMVzJ4ZkVTaS9ja0ZuRGRRZXp3bUlw?=
 =?utf-8?B?SW50QUFEQitOOTIxak00TVIzVEVDYmZjOFVqZEcvZ3ZpR1RwSlE2WjNZTGdi?=
 =?utf-8?B?UUZDRGg2bGZ3Q1RBTUxqZGx2aDBYbGtyOWtYVnk5MlJPSnFUeUQzSkllREcv?=
 =?utf-8?B?eGJhZ05JVjBlN056c1VlWFl0Nktzcjh2VWV1M1U4WFVKSFJaQWZxS0laS2g2?=
 =?utf-8?B?K2ozdXFDakN6eit6ZnR2TXhPOHRIaGFUdjBOY2tVUWxTblJyZnRGZS9PWWoy?=
 =?utf-8?B?ZWF1WnZVOXM4bEtHQVIxSloxT29XWDA3dllsSWU3VDhGaVJRSGYvRU55MmVs?=
 =?utf-8?B?NkFJUzlBUkdZeEtDRUdMbGdtS0hnck9VcVpYeTdVRDUva3cwVU0vZllsZm1C?=
 =?utf-8?B?bm02cldpVlhjcjRlSkd4amlXaTlUUEIyZWIxVHNWeXJPQnRZNUwvV1dURU5S?=
 =?utf-8?B?MFJqVERYcVVneEhZMTFjZGI5LzVXcStlY0RwWnZvQWdOb2x1OEJSQ09Eekw1?=
 =?utf-8?B?dFdkU2JMTXpiVGVWejcrMVpSQkIwRU1FMlRLL3luSHl0TkxUZGIwS2xBZW9k?=
 =?utf-8?B?ZDdRTVVGa0VqRzVBeTJhclZqRW02R0VaQkw3Y0ZsbzUySzdXZGdDb2NQaTdj?=
 =?utf-8?B?YkdNQ2M5RVY5a041ZW9CaWNzdVhzSnN4bW04U1p6aG15YlkvTHFNWmFhc2ZP?=
 =?utf-8?B?ZE5lU1ZHeHJxQ2src3lONHpweXZickV1NWdnbEJsekMvZ2lob3UxdVNmaXBJ?=
 =?utf-8?Q?Jp0NwxSMTkz9tNzg=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55e91b9b-e493-4fb9-e559-08da2ce81c27
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 09:34:24.5726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yrBhM7kzsjuyymgJY2rHLCZmXg54a83gNDUNqn88f0Nrdf31FCdaGaPxaCjdhXoOV1Lsvj5/18+IJjKHcuUyNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR06MB5431
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 30/04/2022 02:09, Robert Hancock wrote:
> On Fri, 2022-04-29 at 16:31 -0600, Robert Hancock wrote:
>> This driver was using the TX IRQ handler to perform all TX completion
>> tasks. Under heavy TX network load, this can cause significant irqs-off
>> latencies (found to be in the hundreds of microseconds using ftrace).
>> This can cause other issues, such as overrunning serial UART FIFOs when
>> using high baud rates with limited UART FIFO sizes.
>>
>> Switch to using the NAPI poll handler to perform the TX completion work
>> to get this out of hard IRQ context and avoid the IRQ latency impact.
>>
>> The TX Used Bit Read interrupt (TXUBR) handling also needs to be moved
>> into the NAPI poll handler to maintain the proper order of operations. A
>> flag is used to notify the poll handler that a UBR condition needs to be
>> handled. The macb_tx_restart handler has had some locking added for global
>> register access, since this could now potentially happen concurrently on
>> different queues.
>>
>> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
>> ---
>>  drivers/net/ethernet/cadence/macb.h      |   1 +
>>  drivers/net/ethernet/cadence/macb_main.c | 138 +++++++++++++----------
>>  2 files changed, 80 insertions(+), 59 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.h
>> b/drivers/net/ethernet/cadence/macb.h
>> index f0a7d8396a4a..5355cef95a9b 100644
>> --- a/drivers/net/ethernet/cadence/macb.h
>> +++ b/drivers/net/ethernet/cadence/macb.h
>> @@ -1209,6 +1209,7 @@ struct macb_queue {
>>  	struct macb_tx_skb	*tx_skb;
>>  	dma_addr_t		tx_ring_dma;
>>  	struct work_struct	tx_error_task;
>> +	bool			txubr_pending;
>>  
>>  	dma_addr_t		rx_ring_dma;
>>  	dma_addr_t		rx_buffers_dma;
>> diff --git a/drivers/net/ethernet/cadence/macb_main.c
>> b/drivers/net/ethernet/cadence/macb_main.c
>> index 160dc5ad84ae..1cb8afb8ef0d 100644
>> --- a/drivers/net/ethernet/cadence/macb_main.c
>> +++ b/drivers/net/ethernet/cadence/macb_main.c
>> @@ -959,7 +959,7 @@ static int macb_halt_tx(struct macb *bp)
>>  	return -ETIMEDOUT;
>>  }
>>  
>> -static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb)
>> +static void macb_tx_unmap(struct macb *bp, struct macb_tx_skb *tx_skb, int
>> budget)
>>  {
>>  	if (tx_skb->mapping) {
>>  		if (tx_skb->mapped_as_page)
>> @@ -972,7 +972,7 @@ static void macb_tx_unmap(struct macb *bp, struct
>> macb_tx_skb *tx_skb)
>>  	}
>>  
>>  	if (tx_skb->skb) {
>> -		dev_kfree_skb_any(tx_skb->skb);
>> +		napi_consume_skb(tx_skb->skb, budget);
>>  		tx_skb->skb = NULL;
>>  	}
>>  }
>> @@ -1025,12 +1025,13 @@ static void macb_tx_error_task(struct work_struct
>> *work)
>>  		    (unsigned int)(queue - bp->queues),
>>  		    queue->tx_tail, queue->tx_head);
>>  
>> -	/* Prevent the queue IRQ handlers from running: each of them may call
>> -	 * macb_tx_interrupt(), which in turn may call netif_wake_subqueue().
>> +	/* Prevent the queue NAPI poll from running, as it calls
>> +	 * macb_tx_complete(), which in turn may call netif_wake_subqueue().
>>  	 * As explained below, we have to halt the transmission before updating
>>  	 * TBQP registers so we call netif_tx_stop_all_queues() to notify the
>>  	 * network engine about the macb/gem being halted.
>>  	 */
>> +	napi_disable(&queue->napi);
>>  	spin_lock_irqsave(&bp->lock, flags);
>>  
>>  	/* Make sure nobody is trying to queue up new packets */
>> @@ -1058,7 +1059,7 @@ static void macb_tx_error_task(struct work_struct
>> *work)
>>  		if (ctrl & MACB_BIT(TX_USED)) {
>>  			/* skb is set for the last buffer of the frame */
>>  			while (!skb) {
>> -				macb_tx_unmap(bp, tx_skb);
>> +				macb_tx_unmap(bp, tx_skb, 0);
>>  				tail++;
>>  				tx_skb = macb_tx_skb(queue, tail);
>>  				skb = tx_skb->skb;
>> @@ -1088,7 +1089,7 @@ static void macb_tx_error_task(struct work_struct
>> *work)
>>  			desc->ctrl = ctrl | MACB_BIT(TX_USED);
>>  		}
>>  
>> -		macb_tx_unmap(bp, tx_skb);
>> +		macb_tx_unmap(bp, tx_skb, 0);
>>  	}
>>  
>>  	/* Set end of TX queue */
>> @@ -1118,25 +1119,28 @@ static void macb_tx_error_task(struct work_struct
>> *work)
>>  	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>>  
>>  	spin_unlock_irqrestore(&bp->lock, flags);
>> +	napi_enable(&queue->napi);
>>  }
>>  
>> -static void macb_tx_interrupt(struct macb_queue *queue)
>> +static bool macb_tx_complete_pending(struct macb_queue *queue)
>> +{
>> +	if (queue->tx_head != queue->tx_tail) {
>> +		/* Make hw descriptor updates visible to CPU */
>> +		rmb();
>> +
>> +		if (macb_tx_desc(queue, queue->tx_tail)->ctrl &
>> MACB_BIT(TX_USED))
>> +			return true;
>> +	}
>> +	return false;
>> +}
>> +
>> +static void macb_tx_complete(struct macb_queue *queue, int budget)
>>  {
>>  	unsigned int tail;
>>  	unsigned int head;
>> -	u32 status;
>>  	struct macb *bp = queue->bp;
>>  	u16 queue_index = queue - bp->queues;
>>  
>> -	status = macb_readl(bp, TSR);
>> -	macb_writel(bp, TSR, status);
>> -
>> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>> -		queue_writel(queue, ISR, MACB_BIT(TCOMP));
>> -
>> -	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
>> -		    (unsigned long)status);
>> -
>>  	head = queue->tx_head;
>>  	for (tail = queue->tx_tail; tail != head; tail++) {
>>  		struct macb_tx_skb	*tx_skb;
>> @@ -1182,7 +1186,7 @@ static void macb_tx_interrupt(struct macb_queue *queue)
>>  			}
>>  
>>  			/* Now we can safely release resources */
>> -			macb_tx_unmap(bp, tx_skb);
>> +			macb_tx_unmap(bp, tx_skb, budget);
>>  
>>  			/* skb is set only for the last buffer of the frame.
>>  			 * WARNING: at this point skb has been freed by
>> @@ -1569,23 +1573,55 @@ static bool macb_rx_pending(struct macb_queue *queue)
>>  	return (desc->addr & MACB_BIT(RX_USED)) != 0;
>>  }
>>  
>> +static void macb_tx_restart(struct macb_queue *queue)
>> +{
>> +	unsigned int head = queue->tx_head;
>> +	unsigned int tail = queue->tx_tail;
>> +	struct macb *bp = queue->bp;
>> +	unsigned int head_idx, tbqp;
>> +
>> +	if (head == tail)
>> +		return;
>> +
>> +	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>> +	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>> +	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>> +
>> +	if (tbqp == head_idx)
>> +		return;
>> +
>> +	spin_lock_irq(&bp->lock);
>> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>> +	spin_unlock_irq(&bp->lock);
>> +}
>> +
>>  static int macb_poll(struct napi_struct *napi, int budget)
>>  {
>>  	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
>>  	struct macb *bp = queue->bp;
>>  	int work_done;
>>  
>> +	macb_tx_complete(queue, budget);
>> +
>> +	rmb(); // ensure txubr_pending is up to date
>> +	if (queue->txubr_pending) {
>> +		queue->txubr_pending = false;
>> +		netdev_vdbg(bp->dev, "poll: tx restart\n");
>> +		macb_tx_restart(queue);
>> +	}
>> +
> 
> Thinking about this a bit more, I wonder if we could just do this tx_restart
> call unconditionally here? Then we wouldn't need this txubr_pending flag at
> all. CCing Tomas Melin who worked on this tx_restart code recently.

Not sure could this cause some semantic change on how this restarting
gets handled by the hardware. Only looking at the patch it looks like it
might be possible to call it unconditionally.

But should there anyways be some condition for the tx side handling, as
I suppose macb_poll() runs when there is rx interrupt even if tx side
has nothing to process?

Thanks,
Tomas


> 
>>  	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
>>  
>>  	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
>>  		    (unsigned int)(queue - bp->queues), work_done, budget);
>>  
>>  	if (work_done < budget && napi_complete_done(napi, work_done)) {
>> -		queue_writel(queue, IER, bp->rx_intr_mask);
>> +		queue_writel(queue, IER, bp->rx_intr_mask |
>> +					 MACB_BIT(TCOMP));
>>  
>>  		/* Packet completions only seem to propagate to raise
>>  		 * interrupts when interrupts are enabled at the time, so if
>> -		 * packets were received while interrupts were disabled,
>> +		 * packets were sent/received while interrupts were disabled,
>>  		 * they will not cause another interrupt to be generated when
>>  		 * interrupts are re-enabled.
>>  		 * Check for this case here to avoid losing a wakeup. This can
>> @@ -1593,10 +1629,13 @@ static int macb_poll(struct napi_struct *napi, int
>> budget)
>>  		 * actions if an interrupt is raised just after enabling them,
>>  		 * but this should be harmless.
>>  		 */
>> -		if (macb_rx_pending(queue)) {
>> -			queue_writel(queue, IDR, bp->rx_intr_mask);
>> +		if (macb_rx_pending(queue) ||
>> +		    macb_tx_complete_pending(queue)) {
>> +			queue_writel(queue, IDR, bp->rx_intr_mask |
>> +						 MACB_BIT(TCOMP));
>>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
>> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
>> +							 MACB_BIT(TCOMP));
>>  			netdev_vdbg(bp->dev, "poll: packets pending,
>> reschedule\n");
>>  			napi_schedule(napi);
>>  		}
>> @@ -1646,29 +1685,6 @@ static void macb_hresp_error_task(struct
>> tasklet_struct *t)
>>  	netif_tx_start_all_queues(dev);
>>  }
>>  
>> -static void macb_tx_restart(struct macb_queue *queue)
>> -{
>> -	unsigned int head = queue->tx_head;
>> -	unsigned int tail = queue->tx_tail;
>> -	struct macb *bp = queue->bp;
>> -	unsigned int head_idx, tbqp;
>> -
>> -	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>> -		queue_writel(queue, ISR, MACB_BIT(TXUBR));
>> -
>> -	if (head == tail)
>> -		return;
>> -
>> -	tbqp = queue_readl(queue, TBQP) / macb_dma_desc_get_size(bp);
>> -	tbqp = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, tbqp));
>> -	head_idx = macb_adj_dma_desc_idx(bp, macb_tx_ring_wrap(bp, head));
>> -
>> -	if (tbqp == head_idx)
>> -		return;
>> -
>> -	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
>> -}
>> -
>>  static irqreturn_t macb_wol_interrupt(int irq, void *dev_id)
>>  {
>>  	struct macb_queue *queue = dev_id;
>> @@ -1754,19 +1770,29 @@ static irqreturn_t macb_interrupt(int irq, void
>> *dev_id)
>>  			    (unsigned int)(queue - bp->queues),
>>  			    (unsigned long)status);
>>  
>> -		if (status & bp->rx_intr_mask) {
>> -			/* There's no point taking any more interrupts
>> -			 * until we have processed the buffers. The
>> +		if (status & (bp->rx_intr_mask |
>> +			      MACB_BIT(TCOMP) |
>> +			      MACB_BIT(TXUBR))) {
>> +			/* There's no point taking any more RX/TX completion
>> +			 * interrupts until we have processed the buffers. The
>>  			 * scheduling call may fail if the poll routine
>>  			 * is already scheduled, so disable interrupts
>>  			 * now.
>>  			 */
>> -			queue_writel(queue, IDR, bp->rx_intr_mask);
>> +			queue_writel(queue, IDR, bp->rx_intr_mask |
>> +						 MACB_BIT(TCOMP));
>>  			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
>> -				queue_writel(queue, ISR, MACB_BIT(RCOMP));
>> +				queue_writel(queue, ISR, MACB_BIT(RCOMP) |
>> +							 MACB_BIT(TCOMP) |
>> +							 MACB_BIT(TXUBR));
>> +
>> +			if (status & MACB_BIT(TXUBR)) {
>> +				queue->txubr_pending = true;
>> +				wmb(); // ensure softirq can see update
>> +			}
>>  
>>  			if (napi_schedule_prep(&queue->napi)) {
>> -				netdev_vdbg(bp->dev, "scheduling RX
>> softirq\n");
>> +				netdev_vdbg(bp->dev, "scheduling NAPI
>> softirq\n");
>>  				__napi_schedule(&queue->napi);
>>  			}
>>  		}
>> @@ -1781,12 +1807,6 @@ static irqreturn_t macb_interrupt(int irq, void
>> *dev_id)
>>  			break;
>>  		}
>>  
>> -		if (status & MACB_BIT(TCOMP))
>> -			macb_tx_interrupt(queue);
>> -
>> -		if (status & MACB_BIT(TXUBR))
>> -			macb_tx_restart(queue);
>> -
>>  		/* Link change detection isn't possible with RMII, so we'll
>>  		 * add that if/when we get our hands on a full-blown MII PHY.
>>  		 */
>> @@ -2019,7 +2039,7 @@ static unsigned int macb_tx_map(struct macb *bp,
>>  	for (i = queue->tx_head; i != tx_head; i++) {
>>  		tx_skb = macb_tx_skb(queue, i);
>>  
>> -		macb_tx_unmap(bp, tx_skb);
>> +		macb_tx_unmap(bp, tx_skb, 0);
>>  	}
>>  
>>  	return 0;
