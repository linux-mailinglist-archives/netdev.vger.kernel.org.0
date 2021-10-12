Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEFD342A68E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236994AbhJLN73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:59:29 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:51808
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236847AbhJLN73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 09:59:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FMOaVq+kTZUXIUvj8DqAlvePHhG0N2cnRbeMEV9ARqYmMhGR8bsl5JrPR3XNScZxUS0+DEnJoW4reP5Qer726pwASmuIMFmXSO+/px/ejJ/XkkJ5CjMIVKDXd1gASgom+l4EzzyTdFhV8BJLRo+OYxWhZP6rYvtKghMdjlELCT9TyW4Z7lYJsewuCwj2po8ou6zpjFB6c+u9olJ6Y3uyyeAQwgbpppkgzTj6PHV2rP9yj93frf8VAvSDkpVvBeCgGXQcwPi/7HczQseSRdYaOg3w9EgeJxEfZOmbZDQNHpWbaN6RYocDu6ARMXHIhQdJXrgIrZ9heizNWgf/570hmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDAF1y8+Y4T8LUb6FhEU6Oq/0/8eqgLyaYDUo9/D4zQ=;
 b=lehcqZdL+BBR/Ce9HnJaoPAVuzquqtlAZzioTCW6u34Zrd1VNSADJ0p4XnpwLRxg42hKKQ/1MAk3+n5rha1l/bM3HofS0AOdBUAd/jt12PASOEpnI441EoHnmo3aDBUdJuGL8er4ZYMpC9sJLPFtkQZw3QfI73XJq0XZvzVUq5kU4ypKlS7jgRM2XLH3hiZ0Zem31yhnOoeEoGMmMbSO3fBpZlpYJEdHweizrbubB6MVYpnT0QTpUi0oHLbsWTByfK+WotAnOXXHrUBYeypyeemc4tkWDYreK6FEgofrqFQGagq3mxDsJXYmR4OgoKMlxu22y6l1LzEHcNiVHnoamQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NDAF1y8+Y4T8LUb6FhEU6Oq/0/8eqgLyaYDUo9/D4zQ=;
 b=T8V4TvF5V/L+nyGqE5uWtoaFWjywK5SbhJNboDFP8gRoxFdKIjecJwVmbitPQgoVW2muRU5EcQgwUK2lM6OnnVKUuUYMlgLvyRgZxR36NpAdMF+Iv06zoF2oevXrVeh06pVzyVgY1UML3CxzhT4CE540i0f9uLd5mFmI2SlRx7GE89sDJ/JP6mlMaA/TSl9tv+WX4Ndp5tAvngpeMdKrmKrxZlvm2LCJCbfhMKZbl55zgGeVd4bbNsafcCmi4I5s8IDTmbxYSU/xPwu9drJ2fXUBv5MeUBlEd1qPwhfFHLQxcPPtTZmCXtb/NFTeJkJ5W/TgRSGbQpAiowFBn/IVRA==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3258.namprd12.prod.outlook.com (2603:10b6:5:187::22)
 by DM5PR12MB1193.namprd12.prod.outlook.com (2603:10b6:3:70::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Tue, 12 Oct 2021 13:57:25 +0000
Received: from DM6PR12MB3258.namprd12.prod.outlook.com
 ([fe80::9c1f:38f9:783a:d05]) by DM6PR12MB3258.namprd12.prod.outlook.com
 ([fe80::9c1f:38f9:783a:d05%2]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 13:57:25 +0000
Message-ID: <fdae8091-337d-a21d-d31d-5270e5029bb8@nvidia.com>
Date:   Tue, 12 Oct 2021 16:57:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH mlx5-next 1/7] RDMA/mlx5: Don't set esc_size in user mr
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org
References: <cover.1634033956.git.leonro@nvidia.com>
 <f60a002566ae19014659afe94d7fcb7a10cfb353.1634033956.git.leonro@nvidia.com>
 <20211012125234.GU2744544@nvidia.com>
From:   Aharon Landau <aharonl@nvidia.com>
In-Reply-To: <20211012125234.GU2744544@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:20b:313::18) To DM6PR12MB3258.namprd12.prod.outlook.com
 (2603:10b6:5:187::22)
MIME-Version: 1.0
Received: from [172.27.15.6] (193.47.165.251) by AS8PR04CA0073.eurprd04.prod.outlook.com (2603:10a6:20b:313::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 13:57:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ea0bf9f-e8a9-416a-b044-08d98d883866
X-MS-TrafficTypeDiagnostic: DM5PR12MB1193:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11931ED3450F2C3FB622B330DFB69@DM5PR12MB1193.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ZdsV5oRSjxrhaRWt8zDUxG8DCtJmakBHeoFIrybka80vTfyWElppLej81jMHW20QaxVQ6npRfRMR5R9JcDqGa/R8ca8uPKAFG8q2a+oOilLEV9FXDlcQ0hwph9NhQtzx+yevJ5Z9XvwRQmAIBI6GFk3M6FJiu7bDVWMlAE7cOAt+hOfDZLsJhzGpOQH2ktXyw4UAVJmW4pqrqxB/CYOzZKfzLpYq3s0+BzbDyr0shEQ4GHAWmUGHwbkdqhqp8/veIo4E5QEVtG6Tai4WE5XG7OXXWwS8+OYVd+JCkP4k+OoTH0JiOXEpsKZKt/OsfOf87RG/gk0opYCvNbCln7w/sDO5+F3TIy+BEJt6yVNCDmGic9Vb0YknhACe/oaMlxocv+F70MYqrzKMUnr0AukN1y2oFPI+9OP7by0cWV12TERtzF1gdV5RlS0hgXqOe6nxaoiwyLSoflb2t9p6VXR9pNYmnbSL8ZfT7GgugLDfi4W4E24uBf8AWTKPl6ANgf649Frh09HyB2q2MmDqtaDfGAqOkYuTKlNHCUPzk8DC3gKHjiR7el1heva6CRuw0htI/HR3fH01psnbXAT6QGq9MNszP/PEzpHdL+xuJ+EihU4Nl3FOR+ymdiorrru8LKVmWYfj+CeJ7sDkgbihOjRwaT9qJCtcLKBlhPfcYwN4m4jOBe51o4KdKBHL+9DHOqjsvjhUIahXaQP96PbeexhXTzVFTNU4ImImhdvjJH7ZqLRgjT4kixb6Zf11yxVv7HZF5oBeqwWvXftiWs1xNa+qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3258.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(8676002)(31686004)(7416002)(2906002)(52116002)(316002)(16576012)(186003)(38100700002)(54906003)(110136005)(6486002)(5660300002)(2616005)(956004)(26005)(86362001)(66946007)(6666004)(8936002)(36756003)(508600001)(66556008)(31696002)(66476007)(4326008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDQ0SXhNM0w0ZGNOZGZPaVNLSmdOOXFBMWZIazZ0QmVKSDBwVlE2bUJyWTFz?=
 =?utf-8?B?YXNBckZtSCtOb1U3am1NY0lSMHMzN2hPWFpwOVczZCtXczBLQmtmNFh2cjVj?=
 =?utf-8?B?QUo1Z2Qxby9uUzA5M2hyYWtocEJMaXlQQkpqMkdzZkwzUmtKaVpBZ2pwNkts?=
 =?utf-8?B?VTd5ZStDcXVUL3VCditRdXJEN2hlcUxkS0JsSFQ1MFE2S0VwTGRNc3JETksw?=
 =?utf-8?B?ODRIakFPWUw4QUhNdDc0L0hmOGdxS1Z4OXJCaXVTdGorcERMUmNEWHB0Z2FU?=
 =?utf-8?B?Rm1IM2ordmNwTEZVQ1RkQUgyaUVQYlkyRVlPOHl0S0xVTFk3MmRLMWV6VE5k?=
 =?utf-8?B?YXo5MU5TRzFGY2FnSEI0NjYxNnlZK3BTbmlXbjVyNkZ4UkxJUTVGZjdIek85?=
 =?utf-8?B?NXptbTkvZEFWTjFtaVFqVWhyNnFrMnMwdmNIUlN3ZWdVd0VGeDRlcU5BRkFS?=
 =?utf-8?B?d1Z0OTUyUnRFVjhPQXNWWkxybU5xVmVZZlppcE04UTlvSEdxYVF4cEJVQTBE?=
 =?utf-8?B?d3NWN1g1aG8zekV2SDhwUU50bDVZemtuSlRzcnJBQXYzSVJ3QnpyWlQ3MnlP?=
 =?utf-8?B?YXlWQlJkMUlyamI3UlM5SGVRTTFKUFlyQXQvVGozeWhVY241Qld3UkdEd0RV?=
 =?utf-8?B?UzRYSU9DUE9uSytqSnhzUTBNNHZCRHRORFU3WjBkT3NwVHphUXpUay9TMzg4?=
 =?utf-8?B?RHU5OFF2Z0VudmsyMXRObVlhejUxQ2h4ZlRWR3dBU1luRzVGRlgxKzhDUXdS?=
 =?utf-8?B?QmlNeW9QRkVUZGQ3akIwVWp3UUR2TXBndEd2WjFLa01MdWJPRy9NUElIOGRU?=
 =?utf-8?B?ZlV3VTE4Y2lzb05ud0FyN2h1UjQ4MEs2Z2MrY3M1WTFIa3N1cS9UdUZETzh1?=
 =?utf-8?B?YjlRMm5tREY1c1dqbUJ0clpnaG1BRDBNbkhZZGd4UXJneTh3aENHSGQ4WDBO?=
 =?utf-8?B?NHRzK3Rrb3pnSmk0RkxOQ0Q1RzhaS3lpcjJRTEZaMVBOL1V3ckwvWEpJaTVC?=
 =?utf-8?B?cXNYOHd5dE12SXRhUWVkOTd0VjVaZk5JNDNaQ0p3ajh0SjFMNWh2S3oxRS9D?=
 =?utf-8?B?UkRlaWJJaGRBdXhKYkMxZWtYL2ZJRDhydVIxcWhnSHdiK1cxZk5wb0VnMFFv?=
 =?utf-8?B?RXlMM1NFVWRQSnVONU5ERFVWV0wvRDBQWTYvYWYyNURFN1QwYkZKckRYcDZy?=
 =?utf-8?B?NzlEa3RnaXBvK05EY0NJbHBtS3JieWV6VFRaMmtmZWt6TTdnOEcrdThWY2FP?=
 =?utf-8?B?M0t0VlJQeXBaQjMxYWhJTisvTFg1TkxIRkpyWjh3TjVpenlyMlYxNGU5YXFO?=
 =?utf-8?B?SGdTWjdyOXAxR081NzhGdThLSG9CYmZ6U0N5YkRtd2FZUDlJT1Q1a3VVMGhs?=
 =?utf-8?B?aXV6anNiSm5lUG1TMDh5SU92QXJScTAxcGg5S1V6VHVzcVUwRHBiM3JiVk9Z?=
 =?utf-8?B?eUp2TC90QzhwVEZqVWE2aDhZeENIMllySmtJemdwNHAxM2k0b0ZpRlJLVFA2?=
 =?utf-8?B?VnhmNFJkdlZVRXBvUnhKVDFOTzZBaUVkZHhsVDZURzZtVDM2QjZoLzVxZmZw?=
 =?utf-8?B?R3BScmNjT1M1N3NYbUtBOWwwclQ4dVA4ZUxudlZ2K2ZUSVNldWgxaFdpcGla?=
 =?utf-8?B?QUJ6SWVlT3JLdlB5bkxuTGkzblNsdUFiWTNTTE5OR2dNQ1k3SC9FeUNyeWQ4?=
 =?utf-8?B?N3U1enFiUFZoRjJsQTFNcHYyNTN4MGdkRUxDZERWMDhzWjVNdEUyK1ozeFox?=
 =?utf-8?Q?jHIzh3NbKw0cmVyVww9DsbHINOypbLK+XHioz9e?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea0bf9f-e8a9-416a-b044-08d98d883866
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3258.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 13:57:25.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nqf6cP0YBzK/Jckvay7d1vP77g354W3i6U1WIbyDJtrGY7kPI7Czw66rI9UjL8xiZxqz8zhyQDSwNHUioFlcfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1193
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/2021 3:52 PM, Jason Gunthorpe wrote:
> On Tue, Oct 12, 2021 at 01:26:29PM +0300, Leon Romanovsky wrote:
>> From: Aharon Landau <aharonl@nvidia.com>
>>
>> reg_create() is used for user MRs only and should not set desc_size at
>> all. Attempt to set it causes to the following trace:
>>
>> BUG: unable to handle page fault for address: 0000000800000000
>> PGD 0 P4D 0
>> Oops: 0000 [#1] SMP PTI
>> CPU: 5 PID: 890 Comm: ib_write_bw Not tainted 5.15.0-rc4+ #47
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>> RIP: 0010:mlx5_ib_dereg_mr+0x14/0x3b0 [mlx5_ib]
>> Code: 48 63 cd 4c 89 f7 48 89 0c 24 e8 37 30 03 e1 48 8b 0c 24 eb a0 90 0f 1f 44 00 00 41 56 41 55 41 54 55 53 48 89 fb 48 83 ec 30 <48> 8b 2f 65 48 8b 04 25 28 00 00 00 48 89 44 24 28 31 c0 8b 87 c8
>> RSP: 0018:ffff88811afa3a60 EFLAGS: 00010286
>> RAX: 000000000000001c RBX: 0000000800000000 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000800000000
>> RBP: 0000000800000000 R08: 0000000000000000 R09: c0000000fffff7ff
>> R10: ffff88811afa38f8 R11: ffff88811afa38f0 R12: ffffffffa02c7ac0
>> R13: 0000000000000000 R14: ffff88811afa3cd8 R15: ffff88810772fa00
>> FS:  00007f47b9080740(0000) GS:ffff88852cd40000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 0000000800000000 CR3: 000000010761e003 CR4: 0000000000370ea0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>> Call Trace:
>>   mlx5_ib_free_odp_mr+0x95/0xc0 [mlx5_ib]
>>   mlx5_ib_dereg_mr+0x128/0x3b0 [mlx5_ib]
>>   ib_dereg_mr_user+0x45/0xb0 [ib_core]
>>   ? xas_load+0x8/0x80
>>   destroy_hw_idr_uobject+0x1a/0x50 [ib_uverbs]
>>   uverbs_destroy_uobject+0x2f/0x150 [ib_uverbs]
>>   uobj_destroy+0x3c/0x70 [ib_uverbs]
>>   ib_uverbs_cmd_verbs+0x467/0xb00 [ib_uverbs]
>>   ? uverbs_finalize_object+0x60/0x60 [ib_uverbs]
>>   ? ttwu_queue_wakelist+0xa9/0xe0
>>   ? pty_write+0x85/0x90
>>   ? file_tty_write.isra.33+0x214/0x330
>>   ? process_echoes+0x60/0x60
>>   ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
>>   __x64_sys_ioctl+0x10d/0x8e0
>>   ? vfs_write+0x17f/0x260
>>   do_syscall_64+0x3c/0x80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Fixes: a639e66703ee ("RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr")
> Can you explain why this is crashing?
>
> reg_create isn't used on the ODP implicit children path.
>
> Jason
It is not implicit ODP flow, therefore, mr->implicit_children shouldn't 
be set.

desc_size shares the same union with implicit_children, and setting it 
leads to a wrong iteration.

Aharon

