Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDF0671FA1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:32:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjAROcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjAROc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:32:29 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FC63C29D;
        Wed, 18 Jan 2023 06:20:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGMCFC6QF50qnq+l8jTr8PsTpM1qsM/7x9aS1E7FJ4E52Ep72h7MpKQCECfaNDFPkEtk95CO7EWDxxza4+Em0nYQplgD6B8CmltTfyU8LQNgde4+xb6ojoetE5dxLONViMHymQKNxl+Ef+bE0FOXHos5CJRbU4ktP+r6nkAFS4qmU/gFnOH0PKW7lJ6DMDUgq8HE9CRCHuv+1NmZiCEhbItf9tp5tMaTZDwUdW6feeTI9+kNKtq8B9CZ/coDKXlIbQNOki0HLoX2bAWBx8cauArwP7ZBL85MA/sLw9yW1z5xbNqsQNga7yplthp9U54qUSqTL7g0Mme6M2NPoakE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DImGXTFklUh486i6aV6dtFC1amhb4zg5fM5iwiDMA0=;
 b=aljgRJ4qCx3Yr/rxVmpBwpufqBrd49ijweeNoupyJuSwrRBVXGZsVwB9H1yo3DaGP7+/Qqk8VyyaJCAKbbo4skG3ESRm/hiyKZyGMiWqfa6LHCMhalaYF2ur2i4OjvR988EJkWBtmZh0TRL6RXJyDsT0sF87TT8cveGXZYkH55PhvryZNlpjbJ5k3cidihnRIsnn8ANi7qMdsY3Swsj2y8YASrH9PrWu2EWO8ER1S9tE8w7Rws9E6tbwQET56/YTQGsNCjjJ4u2s9kyEaYEdlHXsCFie0AydDtOcT2Zf8EYk1HWXStD0FJsvkEdUF8bFOrRKfL29p4UnBjoo9XI26g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DImGXTFklUh486i6aV6dtFC1amhb4zg5fM5iwiDMA0=;
 b=QjPhqJGjH4ji/TTGI2OwrJw7oY+jhPDJg6MnuMy2JP5opqintck47jTHnFw0otnwTMpC1+3pCa+YauRPqf9m68i/q69iL8qyjY3+9u6zkOaq5tMz3I4JdRdxO6k96MvvdGQjbb6ao1l0LE0htNMtvu4t1GtkwOo3j17zjEyrorNTA4f3nra+KzTEh/RnoeLeRmaeR9qFrCKHRrF3KlCKNIXSU4rP/Br8LMyX56ckHyliCEWLCCAXluSilPYvGrU3HFEng9/vIco3ZDtI4GYggVhANVzhzUreN9YhL231eLw9rHUYaBZvnOSUQHZ92gk8Ac/sgKEdvzaCUYULF/FCdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5040.namprd12.prod.outlook.com (2603:10b6:5:38b::19)
 by LV2PR12MB5846.namprd12.prod.outlook.com (2603:10b6:408:175::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 14:20:38 +0000
Received: from DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::9444:21e0:2a65:da95]) by DM4PR12MB5040.namprd12.prod.outlook.com
 ([fe80::9444:21e0:2a65:da95%6]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 14:20:37 +0000
Message-ID: <ac48766a-b861-4fc0-3171-7b23f175c672@nvidia.com>
Date:   Wed, 18 Jan 2023 16:20:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Bryan Tan <bryantan@vmware.com>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <cover.1673873422.git.leon@kernel.org>
 <20230118073654.GC27048@lst.de>
From:   Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20230118073654.GC27048@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0194.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a4::19) To DM4PR12MB5040.namprd12.prod.outlook.com
 (2603:10b6:5:38b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5040:EE_|LV2PR12MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 0465538a-5bc5-4ef5-5468-08daf95f2b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KKmDwBeIxjOPrHXbGh/82f+ScXfqiLzsFzMjXaEUNuJZgMdsCNRpehqmx3TVt5O+6pZqiOUqSc7GjCqmUDK7J4uwxTscHJtBkD5yoREX/662KgvbkQOEDEJn7/wfpsQEDjqYrEidDiNdUcE/mGyeFq1Q2ni95+gLQyMKj+4lR5mi6FIsUKqfOJT7pLaPuXxtBRm7VVTxo55PVMrtAKggq5mTDr9BE1rLXFID/MVmYUGEYHCM3rVZMeIn76r/izP4lzH8IexaHm1xJ6LyWdwk9xVBdf6od/GiRPYn6rpCGiMvy/K+KErX+JMgLHkCB3ZWNS/sVWbXbgJ/g27DuTzlj4aM8qB8tQGwDBBQWMiOa6dx3XQasAtK2z4wAR9W0KFpHsiW2hSFAwH968oJoRrZki1blgL28IZ4nlVG7YxCbmh7F1NYVr3ZV/oZys1GjSxbsV8OPY4EbwIb7u6B/IIDQHC6shJ3iKKCPmad1BV2/GSwZHbDoHuYuaW8hf/v5hnpnDhJGTO1Y8gyHHmvyv8AAq4KO5a5rZMXfZq+ZDgQofy5yP09ADNP2hvuWy+tKm9rwRoSB06iiDKVy0mOa1GJOFpuKdjaEaQ0QlSeao24ayQ6Q/fAvAwY8PmQk0owkX7hdyh5TDpddhAjym2wggdiTqauUvdzNEJtaL/uyYVbxxKZYcuMRYFWmt4NKDuUVsBq8m3R0XqKgddn4K1Gt90Y8exOV6XeCHf+gpYHKNvwN7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5040.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(346002)(396003)(136003)(376002)(451199015)(83380400001)(38100700002)(5660300002)(2906002)(86362001)(4326008)(66476007)(66946007)(8676002)(66556008)(7416002)(8936002)(31696002)(2616005)(478600001)(26005)(53546011)(186003)(6506007)(6512007)(107886003)(316002)(54906003)(6486002)(110136005)(6666004)(41300700001)(31686004)(66899015)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFR5bFVSNUxvbHBMSU1ac3IrNVYwQmNDUTZjOUFVNE82bUsyYVJiNWZUVHF5?=
 =?utf-8?B?OEpkNnRYUmNtRitjWlBianlrU2kyTnFMNlNaR0VhZkhZY2NFRndHUzZTYjFh?=
 =?utf-8?B?NDFOVTdiWmZDVUhUc1BYS2hHQjlOWllSS09IQWxOVlpMUG54VlNZYVh6VXY3?=
 =?utf-8?B?UFNqR1JpeWVzRDRST29ENlR4blR0WmZvMTNzY1h5ajRpTmlkNk0xMTFFOUNQ?=
 =?utf-8?B?MjByRDFTZDZmRzVPanltaVlLSUtIN0Z4T3B2dnJXbFkzUzR0Nm9lNmFQcTZU?=
 =?utf-8?B?OFZWcjJ1OU9QWVRGRE81UEd4NVRnQWZpRTduQ0F6b3A1VWliMmNXYmx0S04v?=
 =?utf-8?B?SkZTOWVsK0VlaWRHWlcrdWRCdHF4eG9zNGpNVEZvbXFFWllOL3hIL09SU1Ft?=
 =?utf-8?B?N2VNTmVpbTM3cnBRM2s5bHhQb1pHRDVZaTdwSEpUT092aHlGODZFMXRHRWVZ?=
 =?utf-8?B?RlpzMTZheFN4UWhwTHJpcHgxdTNxK3ZZWVpuTkZodkgzZk5vZm9Rbmg1aEVE?=
 =?utf-8?B?N3Z4VXFPak9pZytudElMRmhMaTVTbzlvRmlFckFrL2RZRkhmdGpiUmpJdFhu?=
 =?utf-8?B?dnBCVmtQQlo1YkNsdFI3M3gzM3NBamEvQkNuU0J4Zk5iMEdJbHQxMjU5SVAr?=
 =?utf-8?B?dUZOaFZjMkRCdE8rOHkyR0ZDcmN1bWk0Y1Y4NU9DcklHTjdsT2lubVlocXFZ?=
 =?utf-8?B?dUU1MDk0N3lZYzZtMVI4cmgyYWpsdmRkektvZE5JK3orSXBraE9GeXg0bGhE?=
 =?utf-8?B?TVgrc0dXNWc2UlhhRVBOcjNFQnFqbUlTR2Z4WHJFMzVqWHRXb0ZIUWVVTU9B?=
 =?utf-8?B?NkplSkxKRGJSNmxuRisvRU5UMlg5VlNybXVpU3VuZnQrY3BYamMxWExoRXdC?=
 =?utf-8?B?OS9uWlQ3dDB2MVhWSElWdVNpSEZSU1VrV3NxNEJUUHBGU3dMYTl3dmlNNFNF?=
 =?utf-8?B?K0ROZEZRUmF2aWh3ckNOU2loUDhOSUpsL0R3UzNTRVBza2RYaFJyMDkxVHpK?=
 =?utf-8?B?Zm0yRXU0R2ozR2RlOXpMWlBpaWVrZTRSMG9KZzU1Tjd3bnBTOWhVb2YwOCtY?=
 =?utf-8?B?M0hyT29PR2hQN1FmT3NWTGQyYkVLMWptT0xuZ0N0eHpoQzNhdDVBYnlIVERC?=
 =?utf-8?B?blVOOVN3RDBpVGdyZy9kTytnQVJEd2p4ZmVPT1RCdTI4eGZWU2xJOW1QdlZl?=
 =?utf-8?B?YkRwcWdHdG1BeW8wN3FKend6WTg3MlF2Mys3VnJXOXFnYWVNdHpmSFl6Rndp?=
 =?utf-8?B?ZDlLZ1Y2WUU3YXRqS0hBZXpRelQzRDhwQmIvZlhWVVRVdkxCcTg2dUV5SXVu?=
 =?utf-8?B?cnVPMjd3TnluNUJWdGVUSUNkSmFXbEk4R2k4c1RrdFNlZnlONzVZN084VkpC?=
 =?utf-8?B?RHYwUHVZVlZURnB3VXJXSUtiMjBXbXRYVW15RURXc0ZUdWxZWHR3MlVSNThE?=
 =?utf-8?B?dUFTUDJpT3ZVZWJoYzgxUVFpV1Mvcmlqd204MU9zUnkyQmpBanBzQzlsSUZz?=
 =?utf-8?B?ZjB4U0V3VmsxVUJvWHlUZ2JDcHI5UUM0ZnRtbUNCdTF3U2tCaUNNejBja21M?=
 =?utf-8?B?VGpoWU02TW9BeHhrMnJreHpkeEJFRWFYNjNoVnBmT3lRZ3NOSHBzSklxZEdx?=
 =?utf-8?B?V3pQaHBlbFZlRjIzTWlNdkV1amZZckZJS2RCRS9yNmVycWZ0S1A3cWlqbTlw?=
 =?utf-8?B?L0E3d2pqdEVXblYvME55bmFWSmdSSTJFb3llbUNLbEcveDYrd3Z3aTlsM2lI?=
 =?utf-8?B?K2FpanlRL2Q1RTAxUzIxMWdUb25JaWVRNzV4cTVHQitJMDlIb24xYXE4R0gz?=
 =?utf-8?B?a0JPb3NjeTltSDB4b0ZDaWNxckNCbzJ3SUUwSWduMXJMM0ZQYzhrcmRQRWxi?=
 =?utf-8?B?cTJJSzN0RzBVaEoweHp0WlU0NFlxV3RhdzVNditYSit5QlhlZHlTUkFhbTgr?=
 =?utf-8?B?Wmk2T3VUUy9UM3lmejAyZVhEL21ydk1Kb1pZV0FpbzBSMWJpZVNQUzdaOC9i?=
 =?utf-8?B?dVJoR0F3VzNBOEVSODFvbE10MHpycTl4SXBXOGpsWEtlSEwwTzZReTJiMHFP?=
 =?utf-8?B?ZUNGKys5aklaR2NNTHJBanJXN1dUcmI5b1NNZ0VQais5U3pFbTdRcE5nRDIr?=
 =?utf-8?B?V1E2VkxGdzVRdVB6WTZjVi9LZ3pQSUZaZWpiMy9VK2FaVnZqUWpZMkE5R3VL?=
 =?utf-8?B?eUE9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0465538a-5bc5-4ef5-5468-08daf95f2b56
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5040.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 14:20:37.4519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mON4edscv0JRPJmX8BQSu/hP3sHmPbUQLbMY5tQb1I64bA0DTlRFy0lZehOWKQNHgyRCfDEtxm4ftCn+ofsoaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5846
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/01/2023 9:36, Christoph Hellwig wrote:
> On Mon, Jan 16, 2023 at 03:05:47PM +0200, Leon Romanovsky wrote:
>> >From Israel,
>>
>> The purpose of this patchset is to add support for inline
>> encryption/decryption of the data at storage protocols like nvmf over
>> RDMA (at a similar way like integrity is used via unique mkey).
>>
>> This patchset adds support for plaintext keys. The patches were tested
>> on BF-3 HW with fscrypt tool to test this feature, which showed reduce
>> in CPU utilization when comparing at 64k or more IO size. The CPU utilization
>> was improved by more than 50% comparing to the SW only solution at this case.
> One thing that needs to be solved before we can look into this is the
> interaction with protection information (or integrity data in Linux
> terms).  Currently inline encryption and protection information are
> mutally incompatible.

Well, for sure this should be solved. Not sure that it should be done 
before this series.

This patch set doesn't break/change existing behavior of PI and 
Encryption offloads so the above can be done incrementally.
It's already big enough series and 2 subsystems are involved.

Today, if one would like to run both features using a capable device 
then the PI will be offloaded (no SW fallback) and the Encryption will 
be using SW fallback.
There should be a serious instrumentation in the block layer to make 
both operations offloaded.
We'll start looking into it. Any suggestions and designs are welcomed.

We also prepared patches to extend the blk lavel encryption (in addition 
to fscrypt exist today).

