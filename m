Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14CF6B6603
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 13:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCLMmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 08:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCLMmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 08:42:12 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03914FF13
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 05:41:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEoRqYcM6e/+kgnor5cOAfgIy7n2psSYRYf4L1FXnRXY1hQPFGfTdXX5GeoOIhSw4e1SFiZMcbeughT09TbjuR67NUj0aPUqqO8GnL3dkNSYGjs6kRFjmyGxuu6/Evro2viFcf0fgvSNtk0A2p/7Nu05cZXBZ+G4NBwcAAMKvr8XoFG/AvCY1QIcwKAY6cFvNEQy2MRRCJYqIeqtwDPChZBCTX97d4PL4aNjTJ7SApPIJMLu8wXRhKo2j/h6JJyF6j5e8jHzH0hjHvsq2WeYirq+yeIvDYLejA48maitz4g2ysZM5eoHDAAHFBsqUUp5id/s4V5X1fRrxFohApMGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eFGpIkrKKaREupdnJIhCKWnvFdtc8fo//3RVLHwRh8=;
 b=BBNeQayb7z7CyqsbQnmubHMffWYO2Pa5GtwfLN6p3PzZuHBBjfBYqyrx7bk1RjqIi4U4l1SO1wfQgIdqSoqaynwukkrDw5Htoc4xvxsgVe6EkEr+YYin30YZ/m+7XGk59HKSMyJGsfuOwVJ/iub/LnvqfnBJqJTwKw5HptFM3yDeh3SzmkkrgmDOudoY0mDXfPWrPPTalUm2pKpyTxnrIJMEL4kBTG/oxcDnpnX1D5g+NGFsKGNjHjdFOfxPFbh6eEbfhwfsKKlMQFIHLqhOi8msX0WxG2DoC/ssVeR7fOBgBkTMyJemsWP5v/1whieSID+IZyGHB2yWn0b2peSidg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eFGpIkrKKaREupdnJIhCKWnvFdtc8fo//3RVLHwRh8=;
 b=dNgmwl7Loke1MxT4FV9ZvuchUNO8FYmfkwJE7qPw8oJKJbKgE6HnUkNr08RwWOdfPpTWEdqRUVpsfQVgtE3MSwp+8WJtdzDbExa+SxxczIUA3FIBuRjx27wbuzVxNnHaQvFeouAI0NcACp6+usuuXE8pFXuQ+nvVRMhSo8MU3ajvzLmJzE1J/uu9jEob1e6EuTxwt1iUOtpdzcpuCh0E1KPcSwcBtW/y9R3p6HgY/adp6RjLBa7DEABaG38Hlolc0xrgtMPa3osQtRrBIHIqffmyGW1DEht6TXkBtkzEhTgiXfLC17doBXinjSIxv7X0GKPG0dnHlVdLZSEeMYiY3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.22; Sun, 12 Mar 2023 12:41:50 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c707:d96c:a864:28a2%5]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 12:41:50 +0000
Message-ID: <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
Date:   Sun, 12 Mar 2023 14:41:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shay Agroskin <shayagr@amazon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
 <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
 <20230309225326.2976d514@kernel.org>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20230309225326.2976d514@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0244.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:350::10) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e032d8-1721-42a4-aec4-08db22f72605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: etpH20D7oJYmn8gJXDLz3hVjqN2+57V1BXXu29hHIgGzz7RYHnqOMNpneiaAc0jdII7r0g49HvadL13khKqNM9cHwIo1EjEOqKCsue8oUAkoPqw2JsZiszmTUhMpgqWGgI4B4kSJg9ZxqTntKJxAtHu3IujwUI8LVettRUU04j+R6TarrfPpFlh5YfcJiM8VUTWqZcpdGk9oQlZ/mfLrirgfzR6B6DXds0hQ/hQ4I/rywgwl9IYYBoRyMdQrtpHIbRzbrh9EW12F8csExTnTjzk1FojfZJ2QMw0O/GTbCb2MqlBLGgBzWbpg7r5r0hcfD1plssH3kmCUKJwtLlR84dds+HjTVOCUwtdvy6zBQiTmVLU5I/HsHorw0TFh0mWFt5JyST1mNHHThTG3qOYA0qfT+8eR98GLQdbo/YYQyAhK28bfTuiDdHqnvJu1IBqtqp0OKL9A9xAIZWsFladpshGX/95C+SK3dm84ySd5Aonf/Zb+NFZX9h3grGGnFdDdYSvp0aXBGyhaFR9EEL430aFd1e354/EALYL6pDuNKxBmHoqDXRrW9/Sbuzbf8xm4vWWz4Zf5mB19fCQRns+6T6rjEPG9UYaLgIqLOJgvAx59cFpGppCqDB9kTVf6g+DpU/LqJ8MBVQv+cdgSJz2ltOyaCnrPpUY9dWy9HudOTlvho+XeIeoLw6pQP9PxItoU9zfnpUmZxdwSTn4OeVAWEUpfF4P/XJLuVtc1SWLMtBI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199018)(6486002)(31686004)(2906002)(6666004)(478600001)(36756003)(186003)(26005)(6506007)(6512007)(53546011)(2616005)(8936002)(31696002)(86362001)(41300700001)(66476007)(66946007)(4326008)(66556008)(6916009)(8676002)(7416002)(54906003)(316002)(5660300002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmtzN1p2WlFsRE13L21nZmdJR1JHK3d4WXlmWkpCdGRJUHJBQVB6dGhHVHps?=
 =?utf-8?B?eU0wRlNyenpsdG5oSXVRaFlUSWg5Rk5hbUdIenJRRkE2TGFTeFRocHdUelpq?=
 =?utf-8?B?UXFEWjB2OFpKMWVXS0lXdmlVdTRPU3RlQ2F3OURqMUlmeXdMMHdXY3NjNXdH?=
 =?utf-8?B?MEpVRmNsSHVrZHVKcmlORW1wOWFmMTB3Q0Q1RVZ4TEJ2bi9JQ1NjTVh3N3BT?=
 =?utf-8?B?Q3BHNzQwbHJqZTFManBWNkJWSFVOMEhobmdDTit3QkY2VmlTVDAvRVU1T21t?=
 =?utf-8?B?T3VaVzNOaDgxeFZVYllCZnpCVW5lVmJBTzI2a283MXhtZEJ0UnJadnI0eFZs?=
 =?utf-8?B?NG1iWEJ1WjNhMy9yNmdDZFE2Q3diTzhNVWVua3JiOWNqUVdSUXlSa3lUbnpp?=
 =?utf-8?B?UWJkT3pvdkNmSjczdlZQUjFiV29NMkY3M3NqcGZBRjdNL2dScWFta3dpZWJI?=
 =?utf-8?B?UzhRZlZtTncxR2FGSW1LNkpQbkJITzhWakZXU3RDalhtOWJ2THFvd0xzcU9Z?=
 =?utf-8?B?MjYrZmtoV0FUcGNHMUc3MG8zTWdxMWJSQXd3TjJCa1EvaUVFWkpGWUxubTlV?=
 =?utf-8?B?bGtvUGpRdEJZbHhvcFpwaHErUS9oU1hTYUJpbnVrdGMvRjBTMkpHMVZPZTN5?=
 =?utf-8?B?Y09PMzFlQ2k3YmZMbitLZWFrVnB1eEhtMmg4RzIwOGF3OUZXS1pVZFJLbnhU?=
 =?utf-8?B?bXRvcTk2b2hPUUV1d3VvK1JsRUlLL3B1MmVoZkhYVFNEOUN1dEZDNjMyMm1O?=
 =?utf-8?B?RjdmQkhEaTcvREgwb1JIMVIrTVhGaGhkT1lmeGVGZmpOQ3M0dUp3YmNPaGpu?=
 =?utf-8?B?cWhJbkNFZFBkK0E3WkNIWHEzK3RGZTRRZUVYNGZTYnRFUHd4THNUaCs5NGZW?=
 =?utf-8?B?UGpFcEJmZjNYK0xheWxrTDhoYnZ5TE4vT3VqdFo0QU0xMVBGT1J4bTNRQ3By?=
 =?utf-8?B?M2lHd2x2eUw4SDd3ZmNsR1ZXbGZ3SERWOFZqTTg2VVM5OTJuQjRPUzl3SzhZ?=
 =?utf-8?B?S2ZURHJzc0l2OTZZVDNRcjBoQnFzNXFDUDlqSGxkS21nOWhhNUxKSFYwS3FU?=
 =?utf-8?B?clY0WEYvTklySWpLTUZ6R0RWVlY2eWw2Q1l0ZWlkWlBzK1c4VXIyRi9jYllL?=
 =?utf-8?B?T09tOWpHdEhpNk52YlJLMHNQY2ZzTS8wVnJ4VXlWSUUraUpQNmhVaEFLSjJW?=
 =?utf-8?B?NldMRGtnSmhPb2dDOUt3VW5tMzNzUml4N3F0ZjhaUVFMU3FjNXlKbUM2MzVv?=
 =?utf-8?B?TWc5bFhUVUM4RDZsRzFqQlVwRkNLa1RTQzd6RmIwUnlFS2VWbks2cTliNzdK?=
 =?utf-8?B?Yngvb0s5YndqNW84bzkwRm1TMVMwTnJvQlNiU0phZUVEUEQ4dGdqNzVRM3BX?=
 =?utf-8?B?SGxGTkJua1I3Mk5GU3cyRU43VFdUVE95ZFhyU1d0SmFYdDIwQjVXUE9FM2lI?=
 =?utf-8?B?MlRjOENZdTlXQ0ZPOFl2SlJlNTlkWC9NMWdsWWdnWVJJMXl2aFdDbllrTzhW?=
 =?utf-8?B?TzNEa0dQUmFsYWdOQnBmWG5JRkl0ZTQzQ3NwdHBtUjVmZ2cvQy9SeWc3dGtX?=
 =?utf-8?B?UlZLMGlXUVc4aTY0Ty9Ib1VHWS95LzIvTWVRelVMRjZHcnR2MGQzY21yR1o3?=
 =?utf-8?B?clNnOEdpQjBlbjlnaDZVSldtOG1LMDVBNUllcCtOdUhBazRBUDYxUnRkWFNx?=
 =?utf-8?B?dDE5SXFldFYrVmx5Qmorb1Z2WFFrNlE0TTd0L2ptMmJlOWl4NG9xVHhBR0U4?=
 =?utf-8?B?YUxiYUdmMVJPRVltTG05eDlGREJqMHBPUDRhL1Y5U0ZVcU1nU1ZEbjlLME9k?=
 =?utf-8?B?cU0wcnZRbm8vTEVqZEwxSjF3dEgzS1pkNVowdkhOSTVoVHZwVUNkeUNjRncx?=
 =?utf-8?B?eHEyYVZSQXNzMndsVGdtNjF4M1pOUkJiREQ1VzY0Rk9IYkw0aG1ZM0ZZQVBp?=
 =?utf-8?B?MFk0Y2xLb0dsLzVZaU16UWdSSjAxZWQxNkNWME0xOGZScnFNQWdCbkU3NWVt?=
 =?utf-8?B?VmNmbU1zdmVQRHBLQU9BVEtubFo2c0VFa0FyYnVvZTBBZjRQZXlaU1BIcUI3?=
 =?utf-8?B?dit2YVhBT01TMnVmNlVWZmJ6ZGNzMnFpUTlOZFRucU8xNnp5QjVMOTdCdDlT?=
 =?utf-8?Q?nDJOHXOnrAppGG3Iq1+z6ymk2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e032d8-1721-42a4-aec4-08db22f72605
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 12:41:49.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hEI4NT6q1eWi1B1I5zNMPeXFCDBapi8DbSr5oLgk9TX80OOuwhZcLeuvD7sbzNqD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2023 8:53, Jakub Kicinski wrote:
> On Thu, 9 Mar 2023 19:15:43 +0200 Gal Pressman wrote:
>> I know Jakub prefers the new parameter, but the description of this
>> still sounds extremely similar to TX copybreak to me..
>> TX copybreak was traditionally used to copy packets to preallocated DMA
>> buffers, but this could be implemented as copying the packet to the
>> (preallocated) WQE's inline part. That usually means DMA memory, but
>> could also be device memory in this ENA LLQ case.
>>
>> Are we drawing a line that TX copybreak is the threshold for DMA memory
>> and tx_push_buf_len is the threshold for device memory?
> 
> Pretty much, yes. Not an amazing distinction but since TX copybreak can
> already mean two different things (inline or DMA buf) I'd err on 
> the side of not overloading it with another one. 

Can we document that please?

> And Pensando needed a similar knob? Maybe I'm misremembering now.
> 
>> Are they mutually exclusive?
> 
> Not sure.

Me neither, but it's not clear who takes precedent when both are set.
