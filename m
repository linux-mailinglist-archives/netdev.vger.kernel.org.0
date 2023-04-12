Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E266DEBCA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 08:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjDLG1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 02:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDLG13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 02:27:29 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FAD3129
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 23:27:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=occJo7Z/xLZpmYl9VD4xdvtIXcxLSCBsyue3qHPQH8j8lw3Ls8lsX956x21R55aDTFtxp7PdGc4IbNRxibHZfA13FtB6SlTmODxFb2zqCiFyDTZE6PtzIJHadYmdLfckxU/C1/f+XqUkfgk/Z5jR87zjg4Q4pkIdTOOqIomvozBeTzWjjnHgTy9FTnxJMnZlYEjcpN5gkHz++D2HqKuA2QRzYmks62ulSitFlKNkKa3m0630sFkXz5WAjJDlV7rgvjKQkpIZ+/77q4fg5r0qc8LNsByOBtxSqZWGWQ1dXguFzdh9et3n2Ukc7wn8vUGYJw1khBjhQokBEmq1ISLd+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0lHztzUchpjAEhtlZHDRf2JYQVXf5b5jShD3WLgGBJE=;
 b=lEaws+ALGVsjsgN2qpNzZXNNq5pA3liRMMYyn2AaZ3bCO6oONgW5M6mocUMnxYIeSn3jhUTIHywPElNoLz1ZBHkuZoC6gpN7+mCy/Y8vBhN2E6k3XA82hVUL2MEtObkZn5EZn7hcmHxeNRPxt5QaC0/5Wi2iO+yKH2DlW+NNpOZ9RTaVXRvW3+0N1n7qovFnoI+ZfeAWD8BUKLcJXZuW5FtPtUikXBtidxQyBTquPblVMD+RkIxHbz1xk/mgLy+nW0WOGdH4hoDJ+HwXsW+95FbsLs+aT4Pkd/YaFqfUBrB908VTrweS8HV6bB2SZlNgaVvcm0w32Z9DuO2U66u40w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lHztzUchpjAEhtlZHDRf2JYQVXf5b5jShD3WLgGBJE=;
 b=Vk/CLjsUDWbuZidpgogpvwld0ybAs1YSZBxjdsuCyUDZ28nu6uAUHciHTNAkMoSmmtygPJfWYknSutLAgK8Sh1qXp1lAZ3X85FggWoX3fDudwqOWeTIrCX8IOQ9Kf/x5023jT5cGAGsBgixzVYGFvCwBjDHzlshh1SKUBczEuj56bGirZakuN1FlOUE1+T2v4QhW6nHBpLHPnGd/sVwBWuaOLxJIM1NFZr4LWlJR4PjGXOUNQ9eK4WEOXQwCu030fiexoFFYZO4PxPyhuEL1aVcS34pagEteCmz+Udt5riOWmwiMmryYWx3khd0cqBrE0sf5ZP6XngWBpc1pqClosQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AM5PR06MB3187.eurprd06.prod.outlook.com (2603:10a6:206:d::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Wed, 12 Apr
 2023 06:27:23 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::93cd:ffa2:6974:3039]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::93cd:ffa2:6974:3039%6]) with mapi id 15.20.6277.036; Wed, 12 Apr 2023
 06:27:23 +0000
Message-ID: <9bd964bd-8f2f-c97e-dd52-74b9d7051500@vaisala.com>
Date:   Wed, 12 Apr 2023 09:27:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
To:     Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        robert.hancock@calian.com
Cc:     Nicolas.Ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
Content-Language: en-US
From:   Tomas Melin <tomas.melin@vaisala.com>
In-Reply-To: <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: GVYP280CA0033.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:150:f9::24) To HE1PR0602MB3625.eurprd06.prod.outlook.com
 (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0602MB3625:EE_|AM5PR06MB3187:EE_
X-MS-Office365-Filtering-Correlation-Id: 5718aafc-92c8-4686-8c2f-08db3b1ef98b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BlZVAs//leIhuRFjPj0UG6U/hYavJQG7IvpxPjwMGcMlo5UBtPRxstZHxD/MHX07EWmgNgxw8rby9E8/xAQFA0K0XUoqhRN2Ss0Ak/v93Qp5gYW3HUVMVJV6ss2j766PzbZkLUPsXd9/JTpmUWbHt9Z3+B3oLaYMZMjD1/C26NBFsUVQnraxzn47O2DXy3bDeuh9WsthZupn6S+7SuIr27lVqX+GybkqsJzR2i5UUMSZu47Jo0sI1dOsWIJN4Iigquhq0wNArkvvOzZKKFeRMItmtnoAjCQrJSPRXgMrZukYD7p/HddC9VCbimbYI/F0jMANkEp0AIFXG3MbGUim2ELyehtmF1HswcRD2LUmgHI2t7wFpby9W51lO5JyUx/bVTBlolAUYzbwvErCBD4EmQ2EhIPQQng1waJLw++jOQ7Tjs/nhzjUio0ReoFAVxKiGxYSJ+HS3uD9afyVjn+Z8EcIVqm1W/7y3j+28TxWJgq6lkOlQACsxnzwE1Huu1ehjoQOkk9IIBmdSKxK9jxFdk5GOOJCY1pe9qFH6BxVQye6YR3FIInNocxJcq8cZ+LFbjw7F2hKUssczN+Ui9MR1Qxax6khd+6DV9b8l63/wNX/XKl3JnXZV7KuCx69n+KFjH5TZW0VzwKWR7CxdXnmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199021)(2906002)(41300700001)(5660300002)(38100700002)(8936002)(44832011)(8676002)(36756003)(86362001)(31696002)(6486002)(966005)(6666004)(53546011)(6506007)(6512007)(26005)(2616005)(31686004)(83380400001)(478600001)(186003)(316002)(66476007)(66556008)(66946007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUh1ZktLM050YlpTWWFOWk9WWXQxRXVuUWJHdUJ6Qjl3OG83VitHRmhOYkpI?=
 =?utf-8?B?Zm0xZVNhaWtiREJRZ0hBRXNxMHFyRjBnamhhVDhYQnpOakFOUUJBcFhoS2l2?=
 =?utf-8?B?Nm5zcFRqM3E4eUYzeDRIV2pMc0ZWYklVZEdWOEJkS0dhN3FYcHpyWjNBMmFv?=
 =?utf-8?B?VEZhSm5CUDcxUi80UFFIN1Q0UFN5NjlhUllnYTVsUmlaWTA3dHYzY2RIcWZu?=
 =?utf-8?B?cUoxWGdRdlVEUmRkSGl5cmpJcTFNZXJMalMyZlJBcTRydldNeWoyUi9VdW9o?=
 =?utf-8?B?c1pzcUFDazFnckRFQ2NCcnpacFlzdUZ3Z3hOWGlkV25FZldGWlVGeFFkMWZN?=
 =?utf-8?B?OXBQOTJ3ckVuVmZwelltdWpQRmVzT3h0dEt6YjhLK05LM1RHekw3ak4xOHI5?=
 =?utf-8?B?RVpnOUxNc25PbnloZDFhVStOdXp5ckY1MktNZkRaRmwzVlF0MmRnUEtENDNi?=
 =?utf-8?B?RUlPT3p1SXRyTTFiNXNuaHhlaldPNFBSMXY0MHAyNmZiak1relFaRUo1ZzBF?=
 =?utf-8?B?ZG4yajAvVUhreHlvNmtLQ0hUcER6R0NVcXR0TENiclhzMnh6SldCWTFGdU5M?=
 =?utf-8?B?MCs0Q0RsaGR1NE53UmVHVk1zZWIzaFdvbEV2NHQ4SHUxcDZ0Y21QeGQyV2ty?=
 =?utf-8?B?NXBLRVN2amJVRldRcThQNzhKK1lBNy9VUHdBYkNSRld6MlpaN3c0ajJjVmRs?=
 =?utf-8?B?a3JEZUVXTndWSHNHRDM1MUxtNGhmYTZaTEY1Uk5UTE1IdFFIRDlIZlRhZjd5?=
 =?utf-8?B?Q3dCR01ISUJ1RDRrWGZKdG9pQzA2QUJIVzU3NUdYNHBHZldjYXVVU0QzU0dF?=
 =?utf-8?B?UGtVamhhV3lKZmYzQU9YMWJ4ck1FRmNZRXlsb0wyQ0svd2xZZmIzcGl4elVn?=
 =?utf-8?B?ZUk1K25Hb0x1amVJM3VQYWhZNjVRdTcxN0IxK3NhZXh5VEpnRVpwYU9QY01w?=
 =?utf-8?B?UTgzcmpaOEc0bVh1a1RCbGdxdFBpWjZjQnhNR20wK0lFc0t1ZzN6emhpVXlZ?=
 =?utf-8?B?SEpHK0Z5M0M5M08xYnV6dnBkS2NnUERTa1dDTDN2SUt2S3ZUNEh2eXpOYWZJ?=
 =?utf-8?B?cTBSN3pZcVJSOEo3REgvakxudE01MzIrYVNzcVJxQmo2cTZHbmJwWTE4VVcr?=
 =?utf-8?B?aGg1WEN5bHpUdE8xb09abTN4K1JtU1ZHY05qZ29OOHVJeU5RcDVuOGtKbGNi?=
 =?utf-8?B?Q1JlVVJPV1hPYTJzRkgveG1SN3BPays3SmtHdlExUHFvMzI0djRxaTJROW16?=
 =?utf-8?B?WTV3Um5Vc3l1TmRoZGdQK1k3a0hvOTYyRlNBd0paaVBjdE1MSExJdEdyY0JP?=
 =?utf-8?B?U1I4Q2VyaWVGbWkvNVdYbitlckRtOEhRZnFmd1hMWVk1TmFVSUFFVS8rR1Y1?=
 =?utf-8?B?ajFMQzIwSHFEa3RqWmgyUEx2eml4RnhjSEhNc1NLSklMd0d0eVc0S05mWGlD?=
 =?utf-8?B?dXEzOVRaM3haeGFVek5CdnFnMWxPQWg1L2xjY1VFeWNHRTdRb09rNEpoaFYx?=
 =?utf-8?B?b0RMUTBKNytrdUNPL0FZdk5xYmtCelhoSGVycWFDd0JtcHZ1U0FXWVdJVVBF?=
 =?utf-8?B?UmVORlo1TEREM2dDY1I1Q1lCUjIxd29lVmxXbVJ1UlA4emRqSGlJaU96aklh?=
 =?utf-8?B?SFhMTXJXSmFrV2YyYlFOZENqWmdTVGxsRG90WHJvUzVXTE9heDFlOUxvbGtW?=
 =?utf-8?B?ek5JS1M0Ryt1Z1hqc0Z0aEpHUkpBRElnVG5tdXp5eS9sdkFRMHcyUDd4dUF0?=
 =?utf-8?B?VjdTU2dJMWhYYnhONXNqNzVrcUFxcFJmUXZYQTVJZ3l5ajEwaXBvVUxXSEJn?=
 =?utf-8?B?Y3dWWnBEa2Rnei9OeE9VbUxEMjhkL0U5NEl2aWEzelJJOUZhbHdHLzlFTm8z?=
 =?utf-8?B?M3lid1BVYlNpQmNlVnQ0d21UUzNDRWVpSG5pdHJwUW85R3Z3aEcwYXlJVTZ4?=
 =?utf-8?B?b1NpQzVjWkFZQm1MeGFIZ3IzNjNUeUVWdW0zRVlFZExNR3hBTVFqRVh3OFhS?=
 =?utf-8?B?UU05Ky92ektpNUNreHJpcFYvUk01enorbldzWUVBbGVoZXQ0ckF3N1BubTFo?=
 =?utf-8?B?ZzhJbUlseWw4ak9VQU90SVAwSTFnQlJzaWFnRHYrTmRlc0hyN3JDVmE2QlVm?=
 =?utf-8?Q?ut8qOo7PTMMhNgeD3pFUsCvgD?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5718aafc-92c8-4686-8c2f-08db3b1ef98b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 06:27:22.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDdjesANqaqdF3M5nNR5jceYa1NV5MS2Qi3CM/yQCKDBc0UWIuIpE9Mt0ZYYV1w+bWowCgqp4LW40mXOmioIdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR06MB3187
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
On 08/04/2023 00:33, Ingo Rohloff wrote:
> [You don't often get email from ingo.rohloff@lauterbach.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> I am sorry; this is a long E-Mail.
> 
> I am referring to this problem:
> 
> Robert Hancock wrote:
>> On Wed, 2022-03-23 at 08:43 -0700, Jakub Kicinski wrote:
>>> On Wed, 23 Mar 2022 10:08:20 +0200 Tomas Melin wrote:
>>>>> From: Claudiu Beznea <claudiu.beznea@microchip.com>
>>>>>
>>>>> On some platforms (currently detected only on SAMA5D4) TX might stuck
>>>>> even the pachets are still present in DMA memories and TX start was
>>>>> issued for them.
>>>>> ...
>>>> On Xilinx Zynq the above change can cause infinite interrupt loop
>>>> leading to CPU stall.  Seems timing/load needs to be appropriate for
>>>> this to happen, and currently with 1G ethernet this can be triggered
>>>> normally within minutes when running stress tests on the network
>>>> interface.
>>>> ...
>>> Which kernel version are you using?  Robert has been working on macb +
>>> Zynq recently, adding him to CC.
>> ...
>> I haven't looked at the TX ring descriptor and register setup on this core
>> in that much detail, but the fact the controller gets into this "TX used
>> bit read" state in the first place seems unusual.  I'm wondering if
>> something is being done in the wrong order or if we are missing a memory
>> barrier etc?
> 
> I am developing on a ZynqMP (Ultrascale+) SoC from AMD/Xilinx.
> I have seen the same issue before commit 4298388574dae6168 ("net: macb:
> restart tx after tx used bit read")

Since you mention before that commit this triggered, have you been able
to reproduce the problem with that commit applied?

> 
> The scenario which sometimes triggers it for me:
> 
> I have an application running on the PC.
> The application sends a short command (via TCP) to the ZynqMP.
> The ZynqMP answers with a long stream of bytes via TCP
> (around 230KiB).
> The PC knows the amount of data and waits to receive the data completely.
> The PC gets stuck, because the last TCP segment of the transfer gets
> stuck in the ZynqMP and is not transmitted.
> You can re-trigger the TX Ring by pinging the ZynqMP:
> The Ping answer will re-trigger the TX ring, which in turn will also
> then send the stuck IP/TCP packet.
> 
> Unfortunately triggering this problem seems to be hard; at least I am
> not able to reproduce it easily.
> 
> So: If anyone has a more reliable way to trigger the problem,
> please tell me.
> This is to check if my proposed alternative works under all circumstances.
> 
> I have an alternate implementation, which does not require to turn on
> the "TX USED BIT READ" (TUBR) interrupt.
> The reason why I think this alternative might be better is, because I
> believe the TUBR interrupt happens at the wrong time; so I am not sure
> that the current implementation works reliably.
> 
> Analysis:
> Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
> prefetch") mentions:
> 
>     GEM version in ZynqMP and most versions greater than r1p07 supports
>     TX and RX BD prefetch. The number of BDs that can be prefetched is a
>     HW configurable parameter. For ZynqMP, this parameter is 4.
> 
> I think what happens is this:
> Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
> 1) SW has written TX descriptors 0..7
> 2) HW is currently transmitting TX descriptor 6.
>    HW has already prefetched TX descriptors 6,7,8,9.
> 3) SW writes TX descriptor 8 (clearing TX_USED)
> 4) SW writes the TSTART bit.
>    HW ignores this, because it is still transmitting.
> 5) HW transmits TX descriptor 7.
> 6) HW reaches descriptor 8; because this descriptor
>    has already been prefetched, HW sees a non-active
>    descriptor (TX_USED set) and stops transmitting.
> 
> From debugging the code it seems that the TUBR interrupt happens, when
> a descriptor is prefetched, which has a TX_USED bit set, which is before
> it is processed by the rest of the hardware:
> When looking at the end of a transfer it seems I get a TUBR interrupt,
> followed by some more TX COMPLETE interrupts.
> 
I recall that the documentation for the TUBR is rather sparse, so to be
sure about the semantics how this is supposed to work, internal
documentation would indeed be valuable.

Thanks,
Tomas


> Additionally that means at the time the TUBR interrupt happens, it
> is too early to write the TSTART bit again, because the hardware is
> still actively transmitting.
> 
> The alternative I implemented is to check in macb_tx_complete() if
> 
> 1) The TX Queue is non-empty (there are pending TX descriptors)
> 2) The hardware indicates that it is not transmitting any more
> 
> If this situation is detected, the TSTART bit will be written to
> restart the TX ring.
> 
> I know for sure, that I hit the code path, which restarts the
> transmission in macb_tx_complete(); that's why I believe the
> "Example Scenario" I described above is correct.
> 
> I am still not sure if what I implemented is enough:
> macb_tx_complete() should at least see all completed TX descriptors.
> I still believe there is a (very short) time window in which there
> might be a race:
> 1) HW completes TX descriptor 7 and sets the TX_USED bit
>    in TX descriptor 7.
>    TX descriptor 8 was prefetched with a set TX_USED bit.
> 2) SW sees that TX descriptor 7 is completed
>    (TX_USED bit now is set).
> 3) SW sees that there still is a pending TX descriptor 8.
> 4) SW checks if the TGO bit is still set, which it is.
>    So the SW does nothing at this point.
> 5) HW processes the prefetched,set TX_USED bit in
>    TX descriptor 8 and stops transmission (clearing the TGO bit).
> 
> I am not sure if it is guaranteed that 5) cannot happen after 4).  If 5)
> happens after 4) as described above, then the controller still gets stuck.
> The only idea I can come up with, is to re-check the TGO bit
> a second time a little bit later, but I am not sure how to
> implement this.
> 
> Is there anyone who has access to hardware documentation, which
> sheds some light onto the way the descriptor prefetching works?
> 
> so long
>   Ingo
> 
> 
> Ingo Rohloff (1):
>   net: macb: A different way to restart a stuck TX descriptor ring.
> 
>  drivers/net/ethernet/cadence/macb.h      |  1 -
>  drivers/net/ethernet/cadence/macb_main.c | 67 +++++++++---------------
>  2 files changed, 24 insertions(+), 44 deletions(-)
> 
> --
> 2.17.1
> 
