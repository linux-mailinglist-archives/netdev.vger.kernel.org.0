Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62161E0C5
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 09:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiKFIIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 03:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiKFIIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 03:08:39 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2082.outbound.protection.outlook.com [40.107.223.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7831A616F
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 01:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgKR+S5eTDpk+sDqWikNqw6qAeF4hBlUU6AfbdGO1zYfQFRC0dV3PqZbWijOvp6qdEd7TH6IW5hWIYBPc4bPs1gh3RmbhecZj0kK3Cjxi/WGetG/NfDc5x55JACB/4vbnuRzHzwf9TUQj6W82anPJcP2npE96HxHJzDpOulH+wjbW98QZbFqG8N/Wnf/mAaRWNaATH2DI4OKf0+nLITQlzgXYO593uCtNj44KcZfJurpnjUIetey5XL+3QMa8lu9hXaphgh2herak/yqgMuaPsDwcZvgaN4lu1Z18t7yFOcpwy8XwDhe73SRvnjWEIw9UsMpmTt8OEzXzKR/gDLdkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GomAo5RAhHYoTjjXqJhBgNNUYT2bvsY4mfl6NE5Fusg=;
 b=V+BBtsaxzmsUhMWchXQHHYt7u616yrYSR7bFJWcyaPuLmI77Ow2P/ZOQNbqwYky6kWnKDGZqRSZFYWxxz9gFzHZep3Iv/fT2uvV8nImlUGz3uhboRdj4Zt0M8fRJTj3BsTB8J5dxHkADx2+pNDO6YI9OieGb+iexJIuQkjZ+1s9vhMbCLbtKfhAoKpFi4erpd8Q/afOmMAFb3o2KkH4Fye/M4wXcv5XaPB7wD5EnpTnrdRnmmsvytSfNXNGkWRyLQm/UOm1BaPsQBAPtB7KYhXS4o0sP4W0GEi/BS4mq4UzYGFTc5qbIiIA6tYhwduNYN/jnrAQoowyNmJOvZ7uo3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GomAo5RAhHYoTjjXqJhBgNNUYT2bvsY4mfl6NE5Fusg=;
 b=oY1AckfFGvDqbpGculcDZfdBQpZtx70hG8j2aNHn12Zmzt98yZwnAIwK3t/tQmi6d7BocIxIvOOzMRuR8pSl5rUTNgHHoilfoXV9+jA1lqANtoSxLjG7ItOAlOsSPucccU1HDVQpJlYWFDHfnWJzh5yIUr8wdzvBINnAUhuAfkCx8SILwy9/gfGQ7NxugABGcLI0BD0NREafGoYyhJ2Rt9rkKASP9oEhBwkUfxoua8L6yE8E35k3MPHnrC7mlARfVhJJXyrDCf9oKRi6gVAh8/drO1RVFaLaaDzZCQ7fVZ9zdlsluB3ojMPFwSdmT80xSIq0/LJB8B0oiC1FwT09dw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 BL1PR12MB5921.namprd12.prod.outlook.com (2603:10b6:208:398::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.16; Sun, 6 Nov 2022 08:08:33 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 08:08:33 +0000
Message-ID: <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
Date:   Sun, 6 Nov 2022 10:07:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
To:     Eric Dumazet <edumazet@google.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
References: <20221018203258.2793282-1-edumazet@google.com>
 <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org>
 <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0148.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::7) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|BL1PR12MB5921:EE_
X-MS-Office365-Filtering-Correlation-Id: 68d3d2e7-8fcc-41bd-ca1a-08dabfce1946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cOT6rEQHloUPEtTAzZBN5Tsv1f6cCIvEMoV6ePWUmhXYhlCsqUYk2kJg0D50bxg/jl2Kvb4RV/WYI/2M8zsT88wMATSBWu/j3suWWTrO7/l4tPupg8y5i0xEA6tUPVZpk84H6l/EDl0ZoTTra2N2XtPbakp1gWUYM3u6iWdbCJdFhERDI4my9dzEo3WX+lTypc7gHmj/SgR4KafoAVDh4ijrECxcwFktdhTGSjuhaI17+a4xSt0XKh0lk2gAhsHXyoZMESOof/NXYLIS7/pg2DXsVtcMtzJFoDnnWoAM/5OhIMVcO/iR4extjwaXfi7vsszt82a1xxKIMtOckD8pHaaqd2nAcDzNryFLvMFYsKSG9b9kLnNsA+ZRJprbbON7ko2HlPlsnQlwVZj+BQ+rLD7WjltUJ9HtJD+UT5B6TD7YlKeFuNb90GvjfXllaIcSigXiNFJKC93W/mpTZJtnbP+SPbVCxP4Hv8DKP/1V4vV+nzY2BGJOCd/jSWLhP/e3ONQ6w8n+tSc7Rp2pGeyCswAPhpuY5TPhYTcmyhutJo4SGuCmNni+YfsJeJfeexBQBfVGGs/11h/IVbxn+rp8zrRBBjH+FBqIQHBOUt81sUEwP+WqXxLmc997ilfE1yScCYJvKQWcAQQ/xFbdOTzsvZoTn5DRh0DRehjGwOk34q3q+ZUmzvgxY+FAygjr+IASVm+9OBh8euOzv0GdF/sARo8KMUw07gYYDIktAkoyTetO6BSQZbJgQUEa3w9hngAr+uCaF5ohWX766Bw/gwhPGlESa0Av8dz6foz+ftxiXmjFOrVg4FEw/wyA/iDWi4WWQ/1KX8Hnm3ts6wkwhfWnBoPC5SzvIfMHAb2RNRUG0pr8+PZl+qboOGdJEsOMQfG4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199015)(31696002)(4326008)(66476007)(36756003)(86362001)(66946007)(41300700001)(6512007)(66556008)(8676002)(26005)(30864003)(2616005)(6506007)(6486002)(966005)(7416002)(5660300002)(478600001)(53546011)(8936002)(186003)(6666004)(110136005)(316002)(107886003)(54906003)(38100700002)(2906002)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVVKcVFkdjFVNHR3STYwV1kxQVFLZU01azh4U2tMVHFwN2NtYTlwdlUwejN4?=
 =?utf-8?B?ZjdWcjljcmJ1ZlM5TXJqQTMyZUg0YTNuT0FsWGQ2aVpBeUlTZmhZaU4yUlk1?=
 =?utf-8?B?NVdwVUFDTFlxQTZJeW1TSEl6a21uUjRPcld4QnVDTUNWQTJBYW0yM0VsN2Z3?=
 =?utf-8?B?RGUvaDVYeVpMVzhyTUhMcWVwSDhpS2dEQlNoQWtYOE1VK3FkSDBBZHhNZ3hx?=
 =?utf-8?B?Q2dHTGVEVWVzaU9Zem5FNDVVME8zY0h1LzRsUGlXVE5IT3BTUDg5QVFYcG9a?=
 =?utf-8?B?NUhwY3gvTzFGUlRFUmw5MmRRR1c4NE54K3grc2NwWmNTdkN6OXB3VkRVWG8y?=
 =?utf-8?B?MnJvNEVhVWxCVFVoUkU4MUJGTm9JWk1pcUFFSk9wMnI5Y2xzWUNndm5SSElR?=
 =?utf-8?B?aHRYeG92M1hmQ2lmM3NGaGVHcWxOQjBRaXdmd05hVDJyNGx3VlRUTFFHUFVk?=
 =?utf-8?B?cXdHd2xlWnNhZFBnOXhiVjVXQlhoTHBxSGx0RjhUK0RKRjZTQ0NYWEJlVlBa?=
 =?utf-8?B?UUQyUzVIS3pZNVZjYkxoUVlrUU9FWTZ2SG9RTUh6bVNaMWt6SHRRaGMxQ3Fy?=
 =?utf-8?B?cXd3SjhMWDh6Z05BNVgvUW1WakxJT05LdXhLcU0yUWR6bE9ERWcyZmpYWi9t?=
 =?utf-8?B?VjdZSEFveXdPR0ozcUE0V0xoU3RWL3FjTjBYZEFRWXpLUjdOUjFDQ2grTTFy?=
 =?utf-8?B?K1h0MG82K3hkelREUU54Q1owbW9pSXordFNNbkxFMVlRM1RsMU50YU5XUlVq?=
 =?utf-8?B?dmZkak1xTHpEKzhhMk5aTnRLNDFMVGxKdUwyNmQ4alJVWnFKVkJxZ3pJbXVa?=
 =?utf-8?B?TDE3Zksrb3N5N2NFK0RyMVIwYnQyMFlPYUFKdUpjV1BhYStxR29aam5VQW5n?=
 =?utf-8?B?enZFaVRTNHpWWGM4N25yVzdaaURYdUY5OUgvTjZuMldSR2NtemFYLzc4MEpn?=
 =?utf-8?B?bWR6VENreDAwWEY4SzRXSmw2S0w0S1l2T3pKaFlkUVNrdDZndmRncFhjRW4x?=
 =?utf-8?B?c1Yva2xnOHBabjNPTUtnV01LamQ4T1BNN1Zia0NLdkRjdmFYbS96eDlpdWRq?=
 =?utf-8?B?c2h6VEN0MTFjUTdPQnFiN1B3T3lhYmVYUmdhMWNUa0lKeFdIOEMwWkQrMm9U?=
 =?utf-8?B?WGFJWVFFMEpwTFM4VExzR01NVzhWSlBYMGJGbS84SFVpcld6Z210NTczRFVM?=
 =?utf-8?B?NkxXbkNqdGhURTlXb3d6LzhsWnMvVmRITXFLYWRiTGRmdWUvM29RUk5PbUFl?=
 =?utf-8?B?RzZVWTVhSnE1RmVuQ3NYdE1UTnh3TGdPdXBzN2FmOVg1cU1FU3FNZGJHWGdR?=
 =?utf-8?B?eFNxdG50WVROYnd5bzQ5aENVNTRHdk1uY2VuL28zYmNDWC9qWDFLY2ZqajF2?=
 =?utf-8?B?bHBMVUFkTDVvVzRVWWg0M0pzQjZBRHB0Q0p6T2N6RjBVR1BRSlBhcm0wZkFw?=
 =?utf-8?B?aVRsaEdyL04yZGRHZWl4Y0FnTmVveW11cm5aUGlNcitDbTk5R0FIait2SkJG?=
 =?utf-8?B?K3Z1cDYrM0NJeWNESmhQUk4rVkI0TVdkZldTdjhPT0padEYvSVl1c2F4UC9Z?=
 =?utf-8?B?UXdHT0ZNT2h2VmJtVGQ2MlFDVkd5ZzU2UlUxOHphQXJPNUtEZ3BDTGlDd2N3?=
 =?utf-8?B?K3lwY2RFSGdhbzl3MjBPRWhaaExHNjdSbk5GOVV4bVE1b3Y1bjRoRE9rUkRL?=
 =?utf-8?B?T3N3QnZrV2FnUzhoSXZkdTRuME1ESEhWMjl4VTVBT2g4NHkyK2Qxa0k2Z0hy?=
 =?utf-8?B?TmxKbEVJc3l1dDZKY2xXclliMXZ6UU03dVM0RnVGZXFPc3ZvVnplUG9xODZN?=
 =?utf-8?B?TWN0d1ZhVmJOTVRnb2pDODc2azRXWk9zeU9qMkNyYXhzaTNuelpobDRPWlpz?=
 =?utf-8?B?VDR4Q21taTVldm5sczdOSGFoV0NLZEFOaEVyaGtNNkhCU0hjZVhsdm4zUW5s?=
 =?utf-8?B?M1MzQ0tWTmtWcUdzZUg2VzR6RG5UZFJVYUdTb0VoUVdMRUtKc2F4YmNmbFF4?=
 =?utf-8?B?bFVzN1Vkd3BFTzFsRkwzSmE2OVIwdEVDZ2pGZlhUTFhSVEhNWDYwVnFrZ1JV?=
 =?utf-8?B?K3FJV2NTNGRIMmkzSTZ2VlhPRUZwN1NNTmk5dVkzU2JQZjUwWEJFZ3Raekkx?=
 =?utf-8?Q?0DaC1he1wHcOyaEC9nzIym6pt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d3d2e7-8fcc-41bd-ca1a-08dabfce1946
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 08:08:33.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: huiyWVRzL0V/KbYNv4BsBuIZSXsN3SKL/2AvIrZKEOprd2D/SsiTHiUtW9kS1+kS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5921
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/11/2022 18:33, Eric Dumazet wrote:
> On Thu, Nov 3, 2022 at 9:31 AM Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>> On Thu, 3 Nov 2022 at 17:30, Eric Dumazet <edumazet@google.com> wrote:
>>> On Thu, Nov 3, 2022 at 8:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>> On Thu, 3 Nov 2022 08:17:06 -0700 Eric Dumazet wrote:
>>>>> On Thu, Nov 3, 2022 at 6:34 AM Gal Pressman <gal@nvidia.com> wrote:
>>>>>> On 18/10/2022 23:32, Eric Dumazet wrote:
>>>>>>> We had one syzbot report [1] in syzbot queue for a while.
>>>>>>> I was waiting for more occurrences and/or a repro but
>>>>>>> Dmitry Vyukov spotted the issue right away.
>>>>>>>
>>>>>>> <quoting Dmitry>
>>>>>>> qdisc_graft() drops reference to qdisc in notify_and_destroy
>>>>>>> while it's still assigned to dev->qdisc
>>>>>>> </quoting>
>>>>>>>
>>>>>>> Indeed, RCU rules are clear when replacing a data structure.
>>>>>>> The visible pointer (dev->qdisc in this case) must be updated
>>>>>>> to the new object _before_ RCU grace period is started
>>>>>>> (qdisc_put(old) in this case).
>>>>>>>
>>>>>>> [1]
>>>>>>> BUG: KASAN: use-after-free in __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>> Read of size 4 at addr ffff88802065e038 by task syz-executor.4/21027
>>>>>>>
>>>>>>> CPU: 0 PID: 21027 Comm: syz-executor.4 Not tainted 6.0.0-rc3-syzkaller-00363-g7726d4c3e60b #0
>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
>>>>>>> Call Trace:
>>>>>>> <TASK>
>>>>>>> __dump_stack lib/dump_stack.c:88 [inline]
>>>>>>> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>>>>>> print_address_description mm/kasan/report.c:317 [inline]
>>>>>>> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
>>>>>>> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
>>>>>>> __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>> __tcf_qdisc_find net/sched/cls_api.c:1051 [inline]
>>>>>>> tc_new_tfilter+0x34f/0x2200 net/sched/cls_api.c:2018
>>>>>>> rtnetlink_rcv_msg+0x955/0xca0 net/core/rtnetlink.c:6081
>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>> RIP: 0033:0x7f5efaa89279
>>>>>>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>>>>>> RSP: 002b:00007f5efbc31168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>>>>>> RAX: ffffffffffffffda RBX: 00007f5efab9bf80 RCX: 00007f5efaa89279
>>>>>>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
>>>>>>> RBP: 00007f5efaae32e9 R08: 0000000000000000 R09: 0000000000000000
>>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>>>>> R13: 00007f5efb0cfb1f R14: 00007f5efbc31300 R15: 0000000000022000
>>>>>>> </TASK>
>>>>>>>
>>>>>>> Allocated by task 21027:
>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>> kasan_set_track mm/kasan/common.c:45 [inline]
>>>>>>> set_alloc_info mm/kasan/common.c:437 [inline]
>>>>>>> ____kasan_kmalloc mm/kasan/common.c:516 [inline]
>>>>>>> ____kasan_kmalloc mm/kasan/common.c:475 [inline]
>>>>>>> __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
>>>>>>> kmalloc_node include/linux/slab.h:623 [inline]
>>>>>>> kzalloc_node include/linux/slab.h:744 [inline]
>>>>>>> qdisc_alloc+0xb0/0xc50 net/sched/sch_generic.c:938
>>>>>>> qdisc_create_dflt+0x71/0x4a0 net/sched/sch_generic.c:997
>>>>>>> attach_one_default_qdisc net/sched/sch_generic.c:1152 [inline]
>>>>>>> netdev_for_each_tx_queue include/linux/netdevice.h:2437 [inline]
>>>>>>> attach_default_qdiscs net/sched/sch_generic.c:1170 [inline]
>>>>>>> dev_activate+0x760/0xcd0 net/sched/sch_generic.c:1229
>>>>>>> __dev_open+0x393/0x4d0 net/core/dev.c:1441
>>>>>>> __dev_change_flags+0x583/0x750 net/core/dev.c:8556
>>>>>>> rtnl_configure_link+0xee/0x240 net/core/rtnetlink.c:3189
>>>>>>> rtnl_newlink_create net/core/rtnetlink.c:3371 [inline]
>>>>>>> __rtnl_newlink+0x10b8/0x17e0 net/core/rtnetlink.c:3580
>>>>>>> rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>
>>>>>>> Freed by task 21020:
>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>> kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>>>>>>> kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>>>>>>> ____kasan_slab_free mm/kasan/common.c:367 [inline]
>>>>>>> ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
>>>>>>> kasan_slab_free include/linux/kasan.h:200 [inline]
>>>>>>> slab_free_hook mm/slub.c:1754 [inline]
>>>>>>> slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
>>>>>>> slab_free mm/slub.c:3534 [inline]
>>>>>>> kfree+0xe2/0x580 mm/slub.c:4562
>>>>>>> rcu_do_batch kernel/rcu/tree.c:2245 [inline]
>>>>>>> rcu_core+0x7b5/0x1890 kernel/rcu/tree.c:2505
>>>>>>> __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
>>>>>>>
>>>>>>> Last potentially related work creation:
>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>> call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
>>>>>>> qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1083
>>>>>>> notify_and_destroy net/sched/sch_api.c:1012 [inline]
>>>>>>> qdisc_graft+0xeb1/0x1270 net/sched/sch_api.c:1084
>>>>>>> tc_modify_qdisc+0xbb7/0x1a00 net/sched/sch_api.c:1671
>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>
>>>>>>> Second to last potentially related work creation:
>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>> kvfree_call_rcu+0x74/0x940 kernel/rcu/tree.c:3322
>>>>>>> neigh_destroy+0x431/0x630 net/core/neighbour.c:912
>>>>>>> neigh_release include/net/neighbour.h:454 [inline]
>>>>>>> neigh_cleanup_and_release+0x1f8/0x330 net/core/neighbour.c:103
>>>>>>> neigh_del net/core/neighbour.c:225 [inline]
>>>>>>> neigh_remove_one+0x37d/0x460 net/core/neighbour.c:246
>>>>>>> neigh_forced_gc net/core/neighbour.c:276 [inline]
>>>>>>> neigh_alloc net/core/neighbour.c:447 [inline]
>>>>>>> ___neigh_create+0x18b5/0x29a0 net/core/neighbour.c:642
>>>>>>> ip6_finish_output2+0xfb8/0x1520 net/ipv6/ip6_output.c:125
>>>>>>> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
>>>>>>> ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
>>>>>>> NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>>>>>>> ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
>>>>>>> dst_output include/net/dst.h:451 [inline]
>>>>>>> NF_HOOK include/linux/netfilter.h:307 [inline]
>>>>>>> NF_HOOK include/linux/netfilter.h:301 [inline]
>>>>>>> mld_sendpack+0xa09/0xe70 net/ipv6/mcast.c:1820
>>>>>>> mld_send_cr net/ipv6/mcast.c:2121 [inline]
>>>>>>> mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2653
>>>>>>> process_one_work+0x991/0x1610 kernel/workqueue.c:2289
>>>>>>> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>>>>>>> kthread+0x2e4/0x3a0 kernel/kthread.c:376
>>>>>>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>>>>>>>
>>>>>>> The buggy address belongs to the object at ffff88802065e000
>>>>>>> which belongs to the cache kmalloc-1k of size 1024
>>>>>>> The buggy address is located 56 bytes inside of
>>>>>>> 1024-byte region [ffff88802065e000, ffff88802065e400)
>>>>>>>
>>>>>>> The buggy address belongs to the physical page:
>>>>>>> page:ffffea0000819600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20658
>>>>>>> head:ffffea0000819600 order:3 compound_mapcount:0 compound_pincount:0
>>>>>>> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
>>>>>>> raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888011841dc0
>>>>>>> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
>>>>>>> page dumped because: kasan: bad access detected
>>>>>>> page_owner tracks the page as allocated
>>>>>>> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3523, tgid 3523 (sshd), ts 41495190986, free_ts 41417713212
>>>>>>> prep_new_page mm/page_alloc.c:2532 [inline]
>>>>>>> get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
>>>>>>> __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
>>>>>>> alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
>>>>>>> alloc_slab_page mm/slub.c:1824 [inline]
>>>>>>> allocate_slab+0x27e/0x3d0 mm/slub.c:1969
>>>>>>> new_slab mm/slub.c:2029 [inline]
>>>>>>> ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
>>>>>>> __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
>>>>>>> slab_alloc_node mm/slub.c:3209 [inline]
>>>>>>> __kmalloc_node_track_caller+0x2f2/0x380 mm/slub.c:4955
>>>>>>> kmalloc_reserve net/core/skbuff.c:358 [inline]
>>>>>>> __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:430
>>>>>>> alloc_skb_fclone include/linux/skbuff.h:1307 [inline]
>>>>>>> tcp_stream_alloc_skb+0x38/0x580 net/ipv4/tcp.c:861
>>>>>>> tcp_sendmsg_locked+0xc36/0x2f80 net/ipv4/tcp.c:1325
>>>>>>> tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1483
>>>>>>> inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>> sock_write_iter+0x291/0x3d0 net/socket.c:1108
>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>> ksys_write+0x1e8/0x250 fs/read_write.c:631
>>>>>>> page last free stack trace:
>>>>>>> reset_page_owner include/linux/page_owner.h:24 [inline]
>>>>>>> free_pages_prepare mm/page_alloc.c:1449 [inline]
>>>>>>> free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
>>>>>>> free_unref_page_prepare mm/page_alloc.c:3380 [inline]
>>>>>>> free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
>>>>>>> __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2548
>>>>>>> qlink_free mm/kasan/quarantine.c:168 [inline]
>>>>>>> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>>>>>>> kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
>>>>>>> __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
>>>>>>> kasan_slab_alloc include/linux/kasan.h:224 [inline]
>>>>>>> slab_post_alloc_hook mm/slab.h:727 [inline]
>>>>>>> slab_alloc_node mm/slub.c:3243 [inline]
>>>>>>> slab_alloc mm/slub.c:3251 [inline]
>>>>>>> __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>>>>>>> kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3268
>>>>>>> kmem_cache_zalloc include/linux/slab.h:723 [inline]
>>>>>>> alloc_buffer_head+0x20/0x140 fs/buffer.c:2974
>>>>>>> alloc_page_buffers+0x280/0x790 fs/buffer.c:829
>>>>>>> create_empty_buffers+0x2c/0xee0 fs/buffer.c:1558
>>>>>>> ext4_block_write_begin+0x1004/0x1530 fs/ext4/inode.c:1074
>>>>>>> ext4_da_write_begin+0x422/0xae0 fs/ext4/inode.c:2996
>>>>>>> generic_perform_write+0x246/0x560 mm/filemap.c:3738
>>>>>>> ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:270
>>>>>>> ext4_file_write_iter+0x44a/0x1660 fs/ext4/file.c:679
>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>>
>>>>>>> Fixes: af356afa010f ("net_sched: reintroduce dev->qdisc for use by sch_api")
>>>>>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>>>>>> Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
>>>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>>>> ---
>>>>>>>  net/sched/sch_api.c | 5 +++--
>>>>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>>>>>>> index c98af0ada706efee202a20a6bfb6f2b984106f45..4a27dfb1ba0faab3692a82969fb8b78768742779 100644
>>>>>>> --- a/net/sched/sch_api.c
>>>>>>> +++ b/net/sched/sch_api.c
>>>>>>> @@ -1099,12 +1099,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>>>>>>>
>>>>>>>  skip:
>>>>>>>               if (!ingress) {
>>>>>>> -                     notify_and_destroy(net, skb, n, classid,
>>>>>>> -                                        rtnl_dereference(dev->qdisc), new);
>>>>>>> +                     old = rtnl_dereference(dev->qdisc);
>>>>>>>                       if (new && !new->ops->attach)
>>>>>>>                               qdisc_refcount_inc(new);
>>>>>>>                       rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
>>>>>>>
>>>>>>> +                     notify_and_destroy(net, skb, n, classid, old, new);
>>>>>>> +
>>>>>>>                       if (new && new->ops->attach)
>>>>>>>                               new->ops->attach(new);
>>>>>>>               } else {
>>>>>> Hi Eric,
>>>>>> We started seeing the following WARN_ON happening on htb destroy
>>>>>> following your patch:
>>>>>> https://elixir.bootlin.com/linux/v6.1-rc3/source/net/sched/sch_htb.c#L1561
>>>>>>
>>>>>> Anything comes to mind?
>>>>> Not really. Let's ask Maxim Mikityanskiy <maximmi@nvidia.com>
>>>> CC: Maxim on non-nvidia address
>>>>
>>>
>>> Wild guess is that we need this fix:
>>>
>>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>>> index e5b4bbf3ce3d5f36edb512d4017ebd97209bb377..f82c07bd3d60e26e5a1fe2b335dbec29aebb602e
>>> 100644
>>> --- a/net/sched/sch_htb.c
>>> +++ b/net/sched/sch_htb.c
>>> @@ -1558,7 +1558,7 @@ static int htb_destroy_class_offload(struct
>>> Qdisc *sch, struct htb_class *cl,
>>>                 /* Before HTB is destroyed, the kernel grafts noop_qdisc to
>>>                  * all queues.
>>>                  */
>>> -               WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>>> +               WARN_ON(old && !(old->flags & TCQ_F_BUILTIN));
>> I don't think it's the right fix. If the WARN_ON happens and doesn't
>> complain about old == NULL, it's not NULL, so this extra check won't
>> help. In any case, old comes from dev_graft_qdisc, which should never
>> return NULL.
>>
>> Maybe something changed after Eric's patch, so that the statement
>> above is no longer true? I.e. I expect a noop_qdisc here, but there is
>> some other qdisc attached to the queue. I need to recall what was the
>> destroy flow and what code assigned noop_qdisc there...
> Gal please provide a repro. It is not clear if you get a WARN or a NULL deref.

The WARN_ON is triggering, old is not NULL and old->flags is equal to 0x174.

It reproduces consistently:
ip link set dev eth2 up
ip addr add 194.237.173.123/16 dev eth2
tc qdisc add dev eth2 clsact
tc qdisc add dev eth2 root handle 1: htb default 1 offload
tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
22500.0mbit burst 450000kbit cburst 450000kbit
tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
89900kbit cburst 89900kbit
tc qdisc delete dev eth2 clsact
tc qdisc delete dev eth2 root handle 1: htb default 1

Please let me know if there's anything else you want me to check.
