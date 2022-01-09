Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C9C488906
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 12:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbiAILty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 06:49:54 -0500
Received: from mail-mw2nam08on2074.outbound.protection.outlook.com ([40.107.101.74]:20128
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235354AbiAILtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jan 2022 06:49:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KuualUm9WCj55V3TBpCltiJzScnJeWvmNI+W4HMBt8VT3DAXfTacz4X2meYvNyPltr1woO5Lq+5IXWXJtgqIXfPlPllftQFWWzpSrPklciSEvQl8gG9sF8FxLyTat9KDJq/X3o+bmp1ZWxvJZA0apChgevdVZuBEJ6/tytdJ1O4PHR6jtziNgaXppoJQ4XE5VtZPoWGA8dIWKDlGtVWZYmspFzUaqdz0XPB7paULBU753/xcm12FrCJ3wDqbjuJuGwHeon/tAhKpLE06IyTVIMC7lHw21ZbPiZND+UoQ0niwW+Q4Eu0yTpUs5wVsPsbzWFuHE7Y73yCATOvSeuURoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQpZ+fJceXo10j6qCw81w5N4mty5dg410Ct8dHfgjYw=;
 b=jGHjxo9yc9drrdrR4s/vlQjBJw6MpE4wWJ8bTIq+4R4S7TVhzHUwIZITB2/c0uOTkzUImmYwdWZasBdjsYXBoSVH9064KwFwptHSrec37+MAWKdNxMNYAXWXfTkcWtNqHS35ed7CdxM84XvJ20Bq0yq6ygwRE81HNluTWrWHFmL0RWY2rLS0TyPxHFLO5/kdzNaIEydJjgUuWEEZZUUZ+ZXr0Cidb1OEt7Qfy7ErRYWbY0WAW98jDbA0hT5IbOkeHvwQu+MXF7RT3P4QZJo5A6eyX0BIDhfE8x4obAFeN6Agyj9xVuPJyFNa4xR1F7EINatghwDvIWq6Dq/xSjhgaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQpZ+fJceXo10j6qCw81w5N4mty5dg410Ct8dHfgjYw=;
 b=n4ozP9VmdL6l/1jmB6YXXtF3YMhPLbLYVA0lcfpCn6GiXNUmeDWoyUiDPchGiOUQbG4Z+9Kyc2/Vs4Veb/3B8iXXAr5Ac2qvgs7UMfMbhHVOUJgU02AzZddx3RsaxrwmG/z3YPoXIe6ZkPfarbQgV8MnMp5UTKh7IbzTjMEheQsE/kGSJVtPV6lP0ABlzlEHtC7oCFYnUIYVTIhkSRiTFtjSY4odAjdvsBfwWGLMSggzoc0avsFr7pBx7yxaEZpfrKa2QI2S0AYk+DLTUkdYUyr8UWNeDPQNfdHBttrGpnXlCZlCQsmpHAvJrqW6Bpw1wlpHHK2Os+8JJVygsSc03Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BYAPR12MB3495.namprd12.prod.outlook.com (2603:10b6:a03:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Sun, 9 Jan
 2022 11:49:51 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::8161:d1b3:cc90:1123]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::8161:d1b3:cc90:1123%3]) with mapi id 15.20.4867.011; Sun, 9 Jan 2022
 11:49:51 +0000
Message-ID: <e632a338-e4f1-cc27-7c18-b3642a27b57b@nvidia.com>
Date:   Sun, 9 Jan 2022 13:49:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH] net/tls: Fix skb memory leak when running kTLS
 traffic
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220102081253.9123-1-gal@nvidia.com>
 <20220107105106.680cd28f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJqgJjpFEaYPLuVAAzwwC_y3O6se2pChj40=zTAyWN=6w@mail.gmail.com>
 <20220107184436.758e15c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220107184436.758e15c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:206:1::49) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 223de0d2-7fc3-4c31-aa6e-08d9d366252d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3495:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3495A8B0EDFD0E8AF965BEE9C24F9@BYAPR12MB3495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8D+qCp6JP1UsoxsAjRnsoDv+p2yD9MX4vdFV7tw6ILyhlHBcWCLwSS5saYTvap9exEOpV1sY28fn6bq5lzOaXVo5DBp3dClQjlKtTyMi3m5d+gJrKMTT3FyCoItM4aQskTCKnu1QMw2IOVbn4Btm4NyhkkO+4v9CcgZdv5gT96mrpAjIaKJIdx8h8XXWRw71nTiCISeV9bNrEut2WTksy4LbzL6aU4+e5gQFoAikxXceq8JThNmEpcrS+xDor4VCUB7Sumju6SqxQBLvaSBubldXiVwtNcd1GSqZj6I7M3ga8x4SPHTEACJVObw7UL10rWxu64zXU0tx5Q1OyNf0GfkCE+itYeXMCeYjJKg5QVRDPuSKfOfkJ7MjQ5eDuFsaDE943qj4rd/GJ4pfyd1Ub3I+KI3Oz1tdVqhvdBZjM7nxWB7pB9ghlrSpJY7s7+OoEV+ZcHKuHnt0cg7XyCtisY7F25hxnWJpcm3Cztq6uqCfCgFKWLFQ3VsQGWCK7ftKSwTRat7GnddsdIBQXBhG2xnAAEGNSNyTwOyUyU8ys3z1ggfS8mURNt94nZwzW61xaO9/7woMPDaY5APmhCCWXIz1edk1PzWRB6VlZPwKcL+kAMtNoPXX/fuqEDwQguh7iaKs2YeJwPz7F6XYcptlHcL9f1MqVLS+UQbOSwWr0M6jwMSdP/0K/9Kjv9EKN5jousORHFhvJH4I3fjkBfnHT4OQ9KOiRkJTJ6J7roAVLcRvik4PdzEn5aFsIxQUy3bniO1QbZ1OWMgBEPS7WYOvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(316002)(38100700002)(4326008)(110136005)(8936002)(54906003)(36756003)(26005)(83380400001)(6512007)(6666004)(6506007)(31686004)(66946007)(66556008)(5660300002)(2616005)(66476007)(86362001)(107886003)(31696002)(508600001)(2906002)(6486002)(53546011)(8676002)(43740500002)(45980500001)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?STBaM1RrWnZ1YmlOMnBBMkdCSzZaUUFSWlFBaHQ4TXFGMjlOT2RuTFlIOWp5?=
 =?utf-8?B?MjE3aDNmQ2t3eW5ueUxNY1g4RzU4Y0NLbkdjWWloaEpnaTA4VEJKZEF1ZU5h?=
 =?utf-8?B?TVFjS2pyRzdwZlNFYXBPMkcwSTZOSktNMjd6SjhZby9zOTk2QUpFT2JNbVpE?=
 =?utf-8?B?U05ydlE3cVQrdnAyRXYrdFRhRGZCanNCUXhwYlh4dSsreVpyaHRaV0xlM1p3?=
 =?utf-8?B?NkRENEFPQXpsVk9RYmZnQ3dtcVl0dmZJdHg4UUY3Y0hTTGJKV21HVlUzUXl2?=
 =?utf-8?B?eXZCdjdyV0V3S0VpRERXYk5uY1pSckVwa1hWVnN6dzF0dnVlcG5ONldrdndp?=
 =?utf-8?B?ME1ZQ2hWVGtXMmZSdzFHSGFWVUdna0RsZ2JVaTdtLzhvTDNnY0o5Vm1tOHJz?=
 =?utf-8?B?ZVUyOHJoQ24wVzBmeEQ3OXRSZUo3aS9iQmYvSnprZ0FzTExLVzh4WDlHanY3?=
 =?utf-8?B?WVNrMjNOSkpoL3JISWgwYXJLSjlvYzdyclVTVlFjYThvS256VjlPR1B5akov?=
 =?utf-8?B?Mjg0UmhBemxCV09NMVRwc3llNE5RNjJZUWM5cXVNYzRYcGJOQkszSmZHbUNZ?=
 =?utf-8?B?ZUNvSEp0L0hnT0FuTHZRaVc1ckxYQ2ptKzU0Yk9TMW9vc0ZEQ21LMmN1VGxQ?=
 =?utf-8?B?cW0xeHprZmlESGphQzYvNzBjVVoyRXJqMS84YVpEMkp3WjYvSzNYTmFYMlc4?=
 =?utf-8?B?M2UwcGw0K0QwelZEN0ErN0tROTNMa2ZqQllOYURBamhudnhXYjBjbFpGNmZk?=
 =?utf-8?B?dWNHWk9mRktsRzFkUlhaMDNPNzBDbGdzMUpmVDhIeXl0bFhNYzNiYXdJUGZS?=
 =?utf-8?B?WFhZT0ZXSTdLVjhwRzBhYlZNRlVKSmJLTGVJbzMwZ095S0R1R1hxK3prc1Iv?=
 =?utf-8?B?MU5RcTZ1TEliaU5hUU1GY3FnMkx1VWtnM2kvZjBYSXNCR05SMzNZaXBiWFg4?=
 =?utf-8?B?RG5PcnBHWFc0S2JBN1l6ajhZTkE2R3lFY2dnM1phU3d0WndXamkvOTl3dGww?=
 =?utf-8?B?SWZtSXVNa3NjYUJqM1JRZ3RYem1CTmNmV2xkZDA4N1BzVVp6VHppRHBnK3VT?=
 =?utf-8?B?NnNSa0JyeG1VMXZORU51aU5XM21IR05MRDdqaHBjRjREc0JaSGFPc3p4OEJa?=
 =?utf-8?B?bmMzVTJYbUhYY1ppMy9qVUZPVnlGOE9TMHUxVVdUcWsrWkY4eko2ekxPOUtT?=
 =?utf-8?B?MUN3MHI5a09OcWtHdm9IQTd4SE5ZeHduUm5JL1YrQWJiendHZ3d6Zy92d2lG?=
 =?utf-8?B?WlkyM244ZmZJb05IRncrdDFHdS9MME1ZMkkrdTRGVjZzQ2VIMkpzdlJyZXJX?=
 =?utf-8?B?SmEyQlh2aEdMbFhnMDJwWWZFdHNHa00zVnFMaTNnMEl3MW5zN2pXVHpPNXJh?=
 =?utf-8?B?Z3VPVG9CVmE5VnQxWDh4Z1JiMThJYXowRkpvSEErMUJmZWZWUC9YLzdyMHVJ?=
 =?utf-8?B?TkhTNUNWUTRyMGlXNTBSekZldEdTQ3EzSWNVRVBWMTFhTG1NeEJmcXdVTzZz?=
 =?utf-8?B?bU4yQjZPcUlPUGtCcjBKcEwvbVZad09LSzJCb0ZBOXp4UmYydjJEOS82ekd3?=
 =?utf-8?B?c0JEWTJmYkE3RjBZeFd1NmJVZlFGai9SS1RyelJFelV3MXEwZ0ZyZHJjQ09S?=
 =?utf-8?B?TnJhbGhPRHIyT1A4VVJUSTdORXY3LzRHWkh5TFNGWU9TYmJ2Q0xyL0NMMWU0?=
 =?utf-8?B?UXBBK0ZDWmpVT2gwYU42M2dWRjFuTDJLdUtha21nSnBSVUxXN2JvQ3RweFNi?=
 =?utf-8?B?YkEweWdTTm5IancyeUprZmc1bS9sQ1RpSGFSVzczOTNhZkNDSUxzKzN4aUw4?=
 =?utf-8?B?K3E3b2UxT0kyd2I2MW9RaEdzVWc1dll0amNSRkxwN242MTBUZ2srRDFkbXFs?=
 =?utf-8?B?c1dlSFZsWU1ydlV0NklKSTZsTlFHdHA3N3pRenBmOTl3SHMxcEZGbE9ycjRS?=
 =?utf-8?B?VGttNXl3c3RqUm9SdFdkS0ZpUXhmY3BmQ3U0ME01amJSZlA0R3RwdTZUV3BE?=
 =?utf-8?B?OFJpRnpYZ1gxZ1A2R2NWMTB4M2c3ckFjVC85TGVrUVNWbG05OU1LZUVZYklp?=
 =?utf-8?B?NkNVV21FSFNuQVJVYkU1MGJ1bStpemYxZUg4MytoSE9zVS84bmRGVHAyODY5?=
 =?utf-8?Q?X858=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 223de0d2-7fc3-4c31-aa6e-08d9d366252d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2022 11:49:51.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TjGILXFQXEVlkDYR7Wid1YecjK+6d0Bx1Hs4GRJvt5qkBttCV24Cg8ru3YmE859C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3495
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/01/2022 04:44, Jakub Kicinski wrote:
> On Fri, 7 Jan 2022 11:12:28 -0800 Eric Dumazet wrote:
>> On Fri, Jan 7, 2022 at 10:51 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>> On Sun, 2 Jan 2022 10:12:53 +0200 Gal Pressman wrote:  
>>>> The cited Fixes commit introduced a memory leak when running kTLS
>>>> traffic (with/without hardware offloads).
>>>> I'm running nginx on the server side and wrk on the client side and get
>>>> the following:
>>>>
>>>>   unreferenced object 0xffff8881935e9b80 (size 224):
>>>>   comm "softirq", pid 0, jiffies 4294903611 (age 43.204s)
>>>>   hex dump (first 32 bytes):
>>>>     80 9b d0 36 81 88 ff ff 00 00 00 00 00 00 00 00  ...6............
>>>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>   backtrace:
>>>>     [<00000000efe2a999>] build_skb+0x1f/0x170
>>>>     [<00000000ef521785>] mlx5e_skb_from_cqe_mpwrq_linear+0x2bc/0x610 [mlx5_core]
>>>>     [<00000000945d0ffe>] mlx5e_handle_rx_cqe_mpwrq+0x264/0x9e0 [mlx5_core]
>>>>     [<00000000cb675b06>] mlx5e_poll_rx_cq+0x3ad/0x17a0 [mlx5_core]
>>>>     [<0000000018aac6a9>] mlx5e_napi_poll+0x28c/0x1b60 [mlx5_core]
>>>>     [<000000001f3369d1>] __napi_poll+0x9f/0x560
>>>>     [<00000000cfa11f72>] net_rx_action+0x357/0xa60
>>>>     [<000000008653b8d7>] __do_softirq+0x282/0x94e
>>>>     [<00000000644923c6>] __irq_exit_rcu+0x11f/0x170
>>>>     [<00000000d4085f8f>] irq_exit_rcu+0xa/0x20
>>>>     [<00000000d412fef4>] common_interrupt+0x7d/0xa0
>>>>     [<00000000bfb0cebc>] asm_common_interrupt+0x1e/0x40
>>>>     [<00000000d80d0890>] default_idle+0x53/0x70
>>>>     [<00000000f2b9780e>] default_idle_call+0x8c/0xd0
>>>>     [<00000000c7659e15>] do_idle+0x394/0x450
>>>>
>>>> I'm not familiar with these areas of the code, but I've added this
>>>> sk_defer_free_flush() to tls_sw_recvmsg() based on a hunch and it
>>>> resolved the issue.
>>>>
>>>> Eric, do you think this is the correct fix? Maybe we're missing a call
>>>> to sk_defer_free_flush() in other places as well?  
>>> Any thoughts, Eric? Since the merge window is coming soon should
>>> we purge the defer free queue when socket is destroyed at least?
>>> All the .read_sock callers will otherwise risk the leaks, it seems.  
>> It seems I missed this patch.
>>
>> We might merge it, and eventually add another
>>
>> WARN_ON_ONCE(!llist_empty(sk->defer_list))
>> sk_defer_free_flush(sk);
>>
>> at socket destroy as you suggested ?
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Thanks, applied!
>
> Gal please follow up as suggested, for TLS similar treatment to what
> you have done here will be necessary in the splice_read handler.


Thanks Eric and Jakub!

So you want one patch that adds a sk_defer_free_flush() call in
tls_sw_splice_read(), and a second one that adds the WARN_ON_ONCE to
sk_free()?

