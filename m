Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1F602E54
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJROXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbiJROXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:23:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10C01D645
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 07:23:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsDHIv6+x6JrhIUKRqL/no5aEXzMNXT43OiAbfsqNQ9gWQ4GrYfpVl/Z1eK6/uFelPzKvqkpBimfI1UFU2XP/89rcn+0Y+tejIIkiZiGsaY1HxGdgDQJt5SR7G+kHYBbRCyH5gKNL8m+1RUdUKIxA3ltv/9/lUk26XqakYZG65AXyjtoSNLAQhirlxHTzDoXPbqKlYnX0xN7uOr+bf5Xkq5DkIUAvFZ9+1cyFbLzegCyBTyOVzEBRl17dDkahtjGO20SRhpnBnOhY+kCDmdCjFaV8ME8x6RHSEz0s3wwcvLS1qEwmqgYo/7Okeere1eg8FOBYJfk2iTHyXcp3Vptbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3IhdDM9e3UMsRT1P57oLHXQf9+w3fqZuPYGu3jymEGM=;
 b=AJTcjk4EGZ48uaytm9+RM5c5BRqSVJRc7Ztg0qsYlzwUUJ6mrCbHHxReZkpQUMeMDRMPyrwGwg+zLjsQXMl1bSPp8gbUk2u3uokrVXAnABZX8j0wCelfSHSES1JSHy602FxdxvrwK7Usxpbio/JvUbgTg955ZtV6fQ+1gJ93XwLQlQ/TmnnHKnpyYUdBRtXQ5arzc8qlx/z00wbNDfzPoeaz/lfvs0GYOaoB0ez5PzzKZ8PXackm4wEnCnYvhMzampgsRZzn802iSQk/2r7ZJPuutbiHu4GTbYEaqoIqZOU2H8klJsj+95lx8EdGgrPvxr6GJ51q6niWedJ+4v/4fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3IhdDM9e3UMsRT1P57oLHXQf9+w3fqZuPYGu3jymEGM=;
 b=p1DrvV5tFJaSEwX98TtK1RequSGWS33QP8fIByAPKFyRHt1GTUBcZkCme3z4R8TD9zLQEQdhWj0T9nhE/NsFfkJsGg2LPzf8/bx2koJMpe9TCtk4tIz5Oo4TXcy8pTUiG6a3bLxTRwSkQ193bB3EYbe43ZuORazHZQPl8d+lzUOKwwefXPkieb8+OHSplaxUEJY9A2R00IjyQPio+j+ofoSF5oPhHU2ltyY9JhjweMl2lhdyyfWFqRJupMjIwQw5qCN7w6tAgqlu+o4TFaXGrH7+UTWON69hkJv6e53qYsh7xYFWTp46iDZ6hx8og4r5x5Vz5P9nh0/45CtLzxMt6A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 14:23:14 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6%3]) with mapi id 15.20.5723.032; Tue, 18 Oct 2022
 14:23:14 +0000
Message-ID: <44132260-2eba-1b92-af75-883a3c4e908c@nvidia.com>
Date:   Tue, 18 Oct 2022 17:23:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Content-Language: en-US
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, saeed@kernel.org, leon@kernel.org,
        michael.chan@broadcom.com, andy@greyhouse.net,
        vinicius.gomes@intel.com
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0137.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c4::15) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a89d3ca-7360-4094-b051-08dab1144b3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fmxzdFW3bNVDaa+LP+XiYT3OQGxYx32M9yRsFiMHZFZuwbvpVMr1r4Smrr0MKbB71LjbbOzA8veEQhcd4+Frpbzyvu4z/hOM3IgTVPZ5TdPqmJ25XhTc8RS/dqOyP8vFK4hlJwv90aeJ5hRqrqpZG7sHLli9rXAEPBiu0vU5klsnxpl3KQ5BEeLx50yNfUtQ9U1lJtrzkKRJtt5YhjVmjiXocCZa2WbwM3n+bSJab+NL51ewqjkXSre0QtKqdonsL5gzWQiuIwD45RVXxSGQxcXQIaV6zZc6fOq4IAU84LJgf1L1XKGtVMmE426EqOP/2btbTKE8miOYWohIbbg9Geh51dSWONJDX3tL/OfwITwzfqAg6B9Ssmi8QQaKxvDt2agFRxcCvbWJgPFJe343JC1oGT7ZXUzJ/Kb9PTCTck3GwbW3ATChhyyHTgwmLstcurrq0xPgi7k60t/szKnT2TnfsVu9chlg/Jf7aGFEoGyb8nHBZ3ci1xHYjersu36HWju3pEVGOMj6SMxlt1foNqMp3+UCZid4TlPcSCZNmM8VGDoApiSRxFu0CKRsklhb+z1u57X37paejJMPaYLtwUPcW6NV8RShuPVLQ6v4sU4eTCf7WrCB2SbXgMp9hlMY6FW5QwiJrnz5IJfyCOjz9r/b+gjPEWirGKDtD+jgP0nn/PR7S0O3q1osk6RypFFjK6vlDbHLGsisBWTUjz+jazBj545DUkQrTdlIxSlrPeLSzSoShbnRSZaHvG1lfnmGK30DZ/IfTHEYx8znrzs7eZ+/ssStN41RcwSUTUNSrdg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(8936002)(7416002)(5660300002)(66556008)(8676002)(4326008)(66946007)(41300700001)(66476007)(31696002)(86362001)(2906002)(6666004)(2616005)(38100700002)(36756003)(6506007)(478600001)(26005)(6512007)(6486002)(316002)(186003)(53546011)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFVwSjdPZW5tRWo4cEl3a09sS0xkdDZPMXFzeGJYZnIzdzUrM0hRUjdSVFlq?=
 =?utf-8?B?UkZ2cjdySUczWU9TMnFIbVhXK2NZcUxvb0ZEUVd1WFJaeUd1d1luVGgrais0?=
 =?utf-8?B?aXpCZG85aUg1dDVYc0oyMUx5LzJvaGFpTlJHRTR6RGU0MVNyRENGYzFIQlV5?=
 =?utf-8?B?dmJYa3g1U3pQbS9JT1FYOUJBR3lBOS91bEptYkJtNzBqRmZMeW1QbEFSaUdF?=
 =?utf-8?B?RFcydlFxTWFsUHN6Wi81LzB2RjkvOFUrMTR2ZUgvQ00wc01zdmJEY1doangw?=
 =?utf-8?B?UkNyUUZJV1pwNFhOWlUwajdNSGp3dy9DMHFhNDZtbXRUSGhCSFdOZzRpRjIx?=
 =?utf-8?B?OGdZOUFvUUI5MGxTYjVUZ28vK0J1dmNYZzJaZ2d2UTk2cGxvdlI1TkxkMjJy?=
 =?utf-8?B?Y2VKZkE1TU9BREhWVzZwTklkckNIYWpnamZFbHZnMi9IMW1DQ3VxNVJDZ3o0?=
 =?utf-8?B?aXhuZ3o3cnNYbmY3TVM4ZTAyeUlJKzRwTmEwNTVlY0Y3NXFRbGVCNXpNY0ZG?=
 =?utf-8?B?VklRVXNqUkR0d2ZVVml6OTN3Z2FWVUp4VkEvZXh5bUI5WGN1bm9uNi91dnd0?=
 =?utf-8?B?WFBZK1ZnQVptQVg0MlVJSjFOZ2gxNmpiK2RhUlJUREVURzlrZktwVU5PWm1W?=
 =?utf-8?B?YVg5Wi9Ob0RwVEp1b2RsRDB2RDF5QzFyclpNcWZMbWdLaW15N1NmU3JxVGR1?=
 =?utf-8?B?OG5qZy9ZWGJYaHZ2L05UMUJPd2FkYlErNFNVd2FpTjJNUWt2MitLTGNaSHVi?=
 =?utf-8?B?Wi9aSlhWWXZXWnF4Mk5qSFJYTjMzSmxtUWc1cGQrV290K2U5QzJhYWtTV1B6?=
 =?utf-8?B?VlBiRHpLVzNsazFiZGxUMzVnS0o1b2VwcDVJU0R1N1hDOER1VlloNDZEVXpS?=
 =?utf-8?B?Ly9YK0R2YUt2RWNnL0JVcWJaSWZrdDNxWGhBNWh4MHdpbHBTRE5aWWlKWnho?=
 =?utf-8?B?MW8ycjRobGgzdmh4QzZsczV2UmVVZC9vU2NhWHNOaVdMSTczd0ZWbWUwdytI?=
 =?utf-8?B?bkg4WDVUWk5rUk52dFZRNXo5Wm1pSWhIVW8vT3ExeTBNcXcvU0N5ODVidThs?=
 =?utf-8?B?WHVudC9YMER4a1BxRVJydHZRWXFqZlg0b3hzOEsrTXl0NG96VHhYRW1oZmdR?=
 =?utf-8?B?ZkV2Z2J1WUl6RlNGVVp0MStab3Q5S2I0QVZ0YlM1VENtWVZkb2ZNcUVqOHJV?=
 =?utf-8?B?NzQzYkVwRm5ERmdnUE1iV2JkN3pYQy9tOGhRdWs4Z1pxOXdSenpPcEhyK090?=
 =?utf-8?B?RmpLbi9WR1Z1NVZpMUxhUDNVczdZKzdkVXc1eTRpaGZ6REM2ZnJkbkI1bTNN?=
 =?utf-8?B?SzRRRVhHbmxrTlZCekJTdTJKUUUwaDZSR3R5dzNEQWltbjgxcFVReVh3QzFL?=
 =?utf-8?B?K3A1WnNxQkxQRTNTcEtPU0o3MFVaNE5WM0tUdVcyUmpEUW1DMW1lSE4vYzdL?=
 =?utf-8?B?RWlDZllQZDVoZkxxWXZsVkFXVnptdk1VNmNrOEF4YzNkem9JNmxvRkVMaW5i?=
 =?utf-8?B?VE1jVFk1bWo2alFDbXNCR1E4TUcwcDA0WlJlOUF1bXBxVklDdTRtZGhaMWla?=
 =?utf-8?B?elJFQS9neDBpdFVyM2E2TW9ud0swdTR1Yi84VUx0cGd6MG5KYjZreVQvSmlD?=
 =?utf-8?B?TkxhTXVKUDFwaktxZzh3K2ttUUszbWhaR2tCNUMxQ2J6R3FVL1h5cnB6dFRy?=
 =?utf-8?B?elZwMDJGVXZTcmdlNlZqcEtzOGxzcmVjQkszOWRoTWR3N2hmYm5vQlRDNGk4?=
 =?utf-8?B?V1pnM083Z09GcjNOTFk5MmJhdlV1SWpscWQ3WVRvYTQ4RDg2cVpyNkhlNktJ?=
 =?utf-8?B?NEtXUGh2VTBkVU05Q0l1bG1ubnlIWUgyU1ZUNDdOcktUdENQa3JuZTFqT0gv?=
 =?utf-8?B?dDhRN3ZEeU5uVFdUUmRPUE1lbGd1ZnFVcGhQQmUvWDBYMG5LRXhQVjM2NVg4?=
 =?utf-8?B?NE5wcmdrSHk2alM2UHJCaEdzOXlVS3hEYzkwc1h2bFNYVnFnZWMyU3J1eWhP?=
 =?utf-8?B?djRBSFdUdWxPVzBIdkdkVlZYdlBzelk5TjljdXVoZDgzSk45VS9XN0tQRnh5?=
 =?utf-8?B?M1Q0ZmVMQkplTTE2VlhkNzYwMGR4eVB1ZERwM2NEd1QyamF0a3hLVXZVWm9I?=
 =?utf-8?Q?XlvTzCTubg/JOgKLzVfcaoVxD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a89d3ca-7360-4094-b051-08dab1144b3c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:23:14.8264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UGMKvP2w/JDIa4W97jm1rXTxbyVOI4lqqd/1P31gckBABHe5xR7iNu0NbnorihMp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Muhammad,

On 18/10/2022 04:07, Muhammad Husaini Zulkifli wrote:
> The problem is that, when there is a lot of traffic, there is a high chance
> that the timestamps for a PTP packet will be lost if both PTP and Non-PTP
> packets use the same SOF TIMESTAMPING TX HARDWARE causing the tx timeout.

Why would the timestamp be affected by the amount of traffic?
What tx timeout?

> DMA timestamps through socket options are not currently available to
> the user. Because if the user wants to, they can configure the hwtstamp
> config option to use the new introduced DMA Time Stamp flag through the
> setsockopt().
>
> With these additional socket options, users can continue to utilise
> HW timestamps for PTP while specifying non-PTP packets to use DMA
> timestamps if the NIC can support them.

Is it per socket?
Will there be a way to know which types of timestamps are going to be
used on queues setup time?

> This patch series also add a new HWTSTAMP_FILTER_DMA_TIMESTAMP receive
> filters. This filter can be configured for devices that support/allow the
> DMA timestamp retrieval on receive side.

So if I understand correctly, to solve the problem you described at the
beginning, you'll disable port timestamp for all incoming packets? ptp
included?

