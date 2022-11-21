Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DBC631AFC
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 09:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKUIIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 03:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKUIIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 03:08:47 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2058.outbound.protection.outlook.com [40.107.101.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DDD165B2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 00:08:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZewK78Lo86YLWDdNR8lcns458IJxKT91KGFjvWZiM4p04PY9g3o56Xn9lW8GR744FdmaONYp8RA44+gU5iRr29pAqa/bD1ZXy2bpNBQW6SysOo3oacogWBkSM+ercAU9nnLnds+8OqTETl3ahri6l9aVWxrJvvIogkVBTVdrlPDxjjIueIHuFhUPpIRPNLmcxtQ7QksQbGLrxS216Xs5IE44QgxtuLlA4qg5KQAAk0uh6HBmqvvbvC9Z6kdpAc/1TmwZ+Z/r2gUwbiPPVENHTvM/xV0PWrQOIN3Y68GScj+tiHsefm1Mk8vqt6lLhW6nJve7RKfg2gyJ/OWrl/jWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01qZ87aga6buqgVOrycgp8jsG0Xu4D8nZb8USAy/ONc=;
 b=CUnEU9+aOcESXV/HTBSfb0N1YdUyQdR14TRu4O5d9DltrxujQvfHtkbxWpxwMy9SiQFjOJga3lVu9wfkQL98Nw8DBhzGyT0ljhcERsvHL/tYuFr6cR0+hQA2BxfTpWuw2ZX0Jn6aAK4eIfSAjk0XZfBUHo3Ql2tBa7JbRrCJcnA7K83yOC71WKBGAX9JislhBRRJxzJz+w1ypk+Y94i/I1HKr1hIFHXLyTSdvXfPfc4y8V3DyZSoHxkO8g4kvMvmQHmz6WYvWxXq8YkLFxbgTpjS4AgBCiEA+rxG1o6qxaod9IQCc0S0HIBgbSY09sd3yg92+zlhIeksIUi5xCyABw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01qZ87aga6buqgVOrycgp8jsG0Xu4D8nZb8USAy/ONc=;
 b=LhWtzeDf4SkPLzkJ/YKboJ74b5F+js/fs8z+3QhYj54SDeOSHfE1unAmgnJgfRKd/mQqNAIdcMFCe14sDDGSHgH7KS7w8QXbx6F5RFzxxSNH5NtJwQA1bLnbQmQhoRSPaK/zWIclxMKgN4WV901VlObdkVYC1tv6R9A8/sIHddsdfQLaPR8TrINybGP7zluN20tkRoH3/d2VwDGMIGmVqTbwI8EWhkGk4GBGZeIiSTBBlNIKOP5p24es0NDO42qZdwbXwR0s2oXngBh0aKjHAPWa3M7lVPOLZ4Yec1GvUAbcU7BYFyf2xrJr2ieQPVxRQfVZOxEfsiFIueB9zn5kmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 CH0PR12MB5252.namprd12.prod.outlook.com (2603:10b6:610:d3::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Mon, 21 Nov 2022 08:08:43 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 08:08:43 +0000
Message-ID: <a369ed0b-943e-8de5-10f3-3f820a3f8225@nvidia.com>
Date:   Mon, 21 Nov 2022 10:08:34 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
Content-Language: en-US
To:     =?UTF-8?B?0JzQsNC60YHQuNC8?= <maxtram95@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
 <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
 <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com>
 <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
 <e1ccfefa-7910-ca96-9c7f-042df2265db6@nvidia.com>
 <CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com>
 <CAKErNvo1h1Lm_g=-V_=rCjzh1B-L_yqoBQo3wp73pVjSM8x96Q@mail.gmail.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <CAKErNvo1h1Lm_g=-V_=rCjzh1B-L_yqoBQo3wp73pVjSM8x96Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0227.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::23) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|CH0PR12MB5252:EE_
X-MS-Office365-Filtering-Correlation-Id: f63b6ff9-2d5c-4808-a0be-08dacb979b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1A2uLGeR5ZucDhY541rv6L26eHZ2DtBfcta9NP2VaDvJ/jNvtG9QixJfUugyMTP1LEW5FJPZCXKMdzUzOh6QpaI3pO/kno0clyN/CtXSwDaNf6S82PvzRdpRsqUur4dhQWhueYmYQ8MOJkIREYiEk4F8jaW9oko8g5N7IbaZzPexyh1sB9HhOzwm5zEtg1c5iVZn1/yC4xwgDKl/WICAl+rzYD6Dur1bMTAlhQqGkoPEOrDyl9arYMXfHoksFhjQNVr0Uz7Aksz+vqWvQ5bTHfaF7OFqIvVcOjqfbMi78wYEKfEFAS/19s9ICuibmu0zrjVS9zArx9WoqSFsVt2N0x/IMMvk+hoIUbtYCDdFpDISwvihMTDEzdDX63COVJf8plRu3dtsnaV7dkiKWF06tKlsCDmIKo6MKVqekqvFhefPCrGhkCdMd85a3lQlk/G2NbFv1MGB7WZ41CmjvGd5oluRmv4tnrbWLhOZdg0YPDy4B0crkSlAB/5TbP4uTlTzhZcxbUNOSo5uLQwOFRp8K/Zyg8e4Uv0Zj05Ovw8T0AawdgC3OcqbuubIF2/yz1GS2oT/2sODfoYQZVNq9mZL9lMA8qnOnMaHcVi+0ME/OloJubnrv1opEhaQRA5T4P2UCKXS1bBqQZeTMTlfn7hwJ9EKgQCxiT8g7knWmvJ3CLcD+Qm0EJIP1+U35p7MII85GBry1EsIPW5JDjv84+R13hpq7hCWM3J+Uva8qZ3lX98=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199015)(38100700002)(66946007)(83380400001)(2906002)(86362001)(8676002)(31696002)(4326008)(8936002)(7416002)(66476007)(66556008)(41300700001)(5660300002)(6512007)(53546011)(6666004)(107886003)(26005)(6506007)(186003)(2616005)(54906003)(6916009)(316002)(478600001)(6486002)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnN0dzhhN3grWXFHak1mVDIvRHhDaEZTSjVEaXZzaHVIcGRrczY3ZkhmYmRk?=
 =?utf-8?B?aTBqVEd3K1dyR1Z3SkNNOVlRUFRLY3A0ZFhsZzRRVUhvemlERkFsRFlpL0pP?=
 =?utf-8?B?WEZON0RqZHZYYzc2WS9Td2xaS200dGpNQWM2SFdqUkNXYlNTSEh2U2dWSDdp?=
 =?utf-8?B?cFM0SVFBaHdiL3NTRmIvN1NJMHJzOFhGWGVQdDBucGpoczBzOUZEQWc4ZGhX?=
 =?utf-8?B?U3FnU3VkNEZaUXg1U0dVZnJFdEpjZkxXMWNTbEExZmZjSDFSdlpyTUVzOW1U?=
 =?utf-8?B?NWpWRE92KzIrWEJBOThhQWpmaDY3NjdPcjBuS1hjMmtNanZEdXh1aEQzbEJJ?=
 =?utf-8?B?SWhIUTdmL2x6NnRnc1NnOUZQaTh5WUh5dDB1NmpVRlV0MkVrZW5yN0NhOFBK?=
 =?utf-8?B?YWdONDdMcFQ3elJIVjZJWFVnNGU3SFJ4dll6TWlaaFVNRlRSTmxuUmxka242?=
 =?utf-8?B?MkNpNThXOXo1bEtvR0RRbTE4QjAzZndyWnVDOXRYODgvekFIQXk5WHExSjdO?=
 =?utf-8?B?WldYeFhQZ0JnMWJaZEcxVmIwdUlYVy9DbGtqYTFFK1VCQ2NuL29xSGVqZzJB?=
 =?utf-8?B?Ukhwc2dVeUtyNU1oUWxjU3FCRTU5bjljeDVKNi9mSlU2bmx1cnRCWEU5SVJz?=
 =?utf-8?B?cnNxazJGZU1ZbUtVU3ZtUXl5TjZ3MkxWVGdma2RGZFc0TTlIMHdla1lBQWZs?=
 =?utf-8?B?SHlWa1RicFI4K09NQU01NkE1YlowRHMyMVMrVUYxRWRRRmNzWFZMNURoQ1NL?=
 =?utf-8?B?RDI5eVBkZGFyQnhWMUpjNlhSb0dwaitESUxOVG40NHRuam51RW9pcE9paEZC?=
 =?utf-8?B?MFBYMTVvdkZmR1RyVCt3OHg2dDJ0RlRzWUxPeEFjVHVRajVqbDg1bEMvejA4?=
 =?utf-8?B?RXpTVDEyNUt5czBGd2tQN2VQV2lYcVAyVUtkbmFxZTY0R1kwYWxjVWMzb2NZ?=
 =?utf-8?B?Zi94TCs2b3BLeVd0UHVCTStrZDhLWlBoclNseFNrSlBxRE91b1Q1YVlvQk1U?=
 =?utf-8?B?b1QzcUtGN1lUNjc0RzlrNTI3azF3akwrYXFDa1hjY0JFTndiVHBNcFkvOVVl?=
 =?utf-8?B?ZWhLZFlpWi9jUWkxUk1IU0VJTnNMQjNnRURjem5ZNUpMM3pUL0UzaWRucW5v?=
 =?utf-8?B?MU50VFNOWHVwV05paXllSmw4VHlPNTl1MVU5NFhETU53NnBONUNIb25yY3lP?=
 =?utf-8?B?WHFlWnk1ZjBoU3pDVnN4dUJUbWttT1lQVDVSalV0T3dTTWtOQUZpaVh6bmh3?=
 =?utf-8?B?SnVvci94TzFCNW1aVDhmS29iampSVUoyeFdCUW8vZloxdVJ4Y3J2VW51L1Nk?=
 =?utf-8?B?dmhUTm9KSS9Td1h4bmVSWUVWWVh3ZmJhSW55NVFxa0F6bDZIdm93M0haSzJs?=
 =?utf-8?B?L0NBWEZzTVZvUGNnaC9vcFJOcTRBbVJ5NEZRSDNvTE9LTnJ6a3RVZ3JjZ2xB?=
 =?utf-8?B?RTRGTDBha1QvV0E5RXV0NjFWRlB1UlBrNXB2ZnFHR1l2SEVHbW5Pd1VVZWFr?=
 =?utf-8?B?Z3UyN0dzUUpxUDgwT1ovQzA2U2U5dkZVdWJJN3NxWXNKNTVGK2ozQnludCtD?=
 =?utf-8?B?dTE5TTNQQUtUcjhlR0JqdHU4VWZrencrVmRyZmkrV0J5VTNvZkF6MHpjTlZY?=
 =?utf-8?B?VGJENUF4a20xWDJuUnVsSEZ6R0VvdklEbUVrRWVxeVR2eHRCQ3UvOTREanU2?=
 =?utf-8?B?ODJKYzV1cFg5NEdmdG9MdGZ2VlRzM1YwSGQ2MDdCZlM0cnNwdEFKa3ZxMERp?=
 =?utf-8?B?VDU3SXFGc2hldXJFRk42Z1NwMGlyQ0Nhbno5T3NnYlBXZGJJU2hGdkJack1n?=
 =?utf-8?B?WW0yRUsrWldkOWw4RllYZ2k2SGR1QmQwN2duMm5qdHdrNzF1QU5WcUxiWWsy?=
 =?utf-8?B?aUo2WEI3ZVpVZVhDU2ZxNDhTVWluUFFNMUR6RFA0bjdPVk5IWENRSU44RkYy?=
 =?utf-8?B?bU1YeXZDb3RxUEhsNy9GeXJYK2p3SGJIbWdxY0RUUGxFTUppemE4UldCY2py?=
 =?utf-8?B?STZzd2YzKytpT3M2UzkrMW82S3haODNsNUxjN2JUNU0xRGhhZzlRWW11czdL?=
 =?utf-8?B?ekNXVmhUalV0ZmE1QzZLQ29NY1o0OUNBZXdmcWQrMTAzby96OFFmM3lVamlP?=
 =?utf-8?Q?3ZedC5TipMqPyI/zJm49JlVl8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f63b6ff9-2d5c-4808-a0be-08dacb979b95
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 08:08:43.8214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sxh6OGwk/yPLxeU2XnSYC37OPn9AXTaYoREDwrt7m0QEM0369C3AW50ONLkmyoMe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5252
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/11/2022 23:39, Максим wrote:
> On Sun, 20 Nov 2022 at 19:01, Eric Dumazet <edumazet@google.com> wrote:
>> On Sun, Nov 20, 2022 at 8:43 AM Gal Pressman <gal@nvidia.com> wrote:
>>> On 20/11/2022 18:09, Eric Dumazet wrote:
>>>> On Sat, Nov 19, 2022 at 11:42 PM Gal Pressman <gal@nvidia.com> wrote:
>>>>> On 10/11/2022 11:08, Gal Pressman wrote:
>>>>>> On 06/11/2022 10:07, Gal Pressman wrote:
>>>>>>> It reproduces consistently:
>>>>>>> ip link set dev eth2 up
>>>>>>> ip addr add 194.237.173.123/16 dev eth2
>>>>>>> tc qdisc add dev eth2 clsact
>>>>>>> tc qdisc add dev eth2 root handle 1: htb default 1 offload
>>>>>>> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
>>>>>>> 22500.0mbit burst 450000kbit cburst 450000kbit
>>>>>>> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
>>>>>>> 89900kbit cburst 89900kbit
>>>>>>> tc qdisc delete dev eth2 clsact
>>>>>>> tc qdisc delete dev eth2 root handle 1: htb default 1
>>>>>>>
>>>>>>> Please let me know if there's anything else you want me to check.
>>>>>> Hi Eric, did you get a chance to take a look?
>>>>> No response for quite a long time, Jakub, should I submit a revert?
>>>> Sorry, I won't have time to look at this before maybe two weeks.
>>> Thanks for the response, Eric.
>>>
>>>> If you want to revert a patch which is correct, because some code
>>>> assumes something wrong,
>>> I am not convinced about the "code assumes something wrong" part, and
>>> not sure what are the consequences of this WARN being triggered, are you?
>>>
>>>> I will simply say this seems not good.
>>> Arguable, it is not that clear that a fix that introduces another issue
>>> is a good thing, particularly when we don't understand the severity of
>>> the thing that got broken.
>> The offload part has been put while assuming a certain (clearly wrong) behavior.
>>
>> RCU rules are quite the first thing we need to respect in the kernel.
>>
>> Simply put, when KASAN detects a bug, you can be pretty damn sure it
>> is a real one.
>>
>>> Two weeks gets us to the end of -rc7, a bit too dangerous to my personal
>>> taste, but I'm not the one making the calls.
>> Agreed, please try to find someone at nvidia able to understand what Maxim
>> was doing in commit ca49bfd90a9dde175d2929dc1544b54841e33804
> The check for TCQ_F_BUILTIN basically means checking for noop_qdisc.
> As the comment above the WARN_ON says, my code expects that before the
> root HTB qdisc is destroyed (the notify_and_destroy line from Eric's
> patch, in qdisc_graft), the kernel assigns &noop_qdisc to all of
> dev_queue->qdisc-s (i.e. qdiscs of HTB classes). IIRC, it should
> happen in dev_deactivate in qdisc_graft (and if IFF_UP is unset at
> this point, that means dev_deactivate has been called before, from
> __dev_close_many). That said, I don't see how Eric's patch could
> affect this logic. What has changed in Eric's patch is that the old
> root qdisc (HTB) is now destroyed after assigning the new qdisc to
> dev->qdisc, but it has nothing to do with dev_queue->qdisc-s.
>
> Gal, are you sure the WARN_ON only happens after Eric's patch? If yes,
> could you do some tracing and find out whether all the qdiscs of the
> netdev queues are noop_qdisc after the dev_deactivate line in
> qdisc_graft — before and after Eric's patch?
>
> for (i = 0; i < num_q; i++) {
>         struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, i);
>         if (dev_queue->qdisc == &noop_qdisc)
>                 ...
> }

Hey Maxim, thanks for taking a look into this.
Yes, the WARN_ON is not triggered before Eric's patch.

The behavior of the code you mentioned is the same before and after his
patch though.
In qdisc_graft():
* Before dev_deactivate(), qdiscs 0-5 are != noop_qdisc, qdiscs 6-303
are == noop_qdisc
* After dev_deactivate(), all qdiscs are == noop_qdisc.
