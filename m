Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4F469090F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 13:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbjBIMku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 07:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjBIMkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 07:40:49 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B0A15AB24
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 04:40:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJnFKExPzVXvOYSSudUI5ixxdQfiN6zhbbBzAXSdyiInAFZIRDWdtSpvBtWSB7czZuV1cl9O+BPpDKKQWzcJ3ny7V+Gcj07jWNaWE6EZmnFRWUF38mjtxipC84jEpirXbudpsOS0ABZICUXkv+ER5e1HOZLNwz0ELPGoP8OuW4VdY3yompOwRMMyZLqCvE2T/+lP6PFmZIJ02T5uF3hPaBbIkbI9RLAV67WKzmmfYLOy6k4A9/oHZr0vBqxq4A84giUWJBgyaIKMjLz2JA9wotPZ4F8Oow737sHfoBBL5Kmq4Y3IVJjTP8R9jgc4W4qqvHdk6rvjgR6Q+WT5oW4rYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CjeT7mgmIRTe+tWiDMkAis/ASF58zFOelpqCT8T4Hlc=;
 b=FFRjT4f3BgRursvwIlUwyokghnocR3lNUQLi03JdoloO/z5gA0Q41KvIsDZe95aytikyo0O3zMnHaUfEautIPMBLDCjO1snj8kuSxwQy21sB9//E6DD4LXeJOJcvun1aXH653/sOxIjMIlQ8F3Eg3hhddXbZD3ZIxvLHtTVoC1Wg39yezuC2vetfiZdQERvrewsUCRjSa41Vp92EEbIR3VpY9hj5DhcXeb8SFiPK0/UvY1aTHuc/y0onrwiKXifTDAZSxq3eywkAdOcSktdKz/7L+NQXCF0VbO7l3OvqHeNT0v9Xruu2CUrrSib2Jcj8jgAgkKTJ+/KahVEWiORQuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjeT7mgmIRTe+tWiDMkAis/ASF58zFOelpqCT8T4Hlc=;
 b=tf+BSPduLFB4bDymv9xkysJjaFonOY96Dm50nEi1vB3H22SsgT4c0UyZ2pYTVF1NW4qFOTvFyMWKnSeynp0rqmaCX014uVggfkVQ95IjmfIgzZf8Rcb4Ggevu9bgaJvM1IiR5Qbku0Q5f7K+JuyNOZBQ9kZ65cpD/ZanoqCfiA4bYX9fySQQpojPyEd2ga6ePM1SmBwq5dNQxpXMlxBdSsQpeNgy4IKA9DT6obmcBm9BOknBwhpUfT4F5NOEhXNBMdUfGKEJg2gebpxkrJZwYO9XCjHwywD473vM9nXtbdjvmDtzKy90cCHB1knsdsL9DPMZDJUHDH+r1vKDNZn8Tg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by CY8PR12MB7363.namprd12.prod.outlook.com (2603:10b6:930:51::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 12:40:42 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6064.027; Thu, 9 Feb 2023
 12:40:42 +0000
Message-ID: <bc7080d9-93d1-4005-5099-f28341475d40@nvidia.com>
Date:   Thu, 9 Feb 2023 14:40:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v8 0/7] net/sched: cls_api: Support hardware miss
 to tc action
Content-Language: en-US
To:     Ilya Maximets <i.maximets@ovn.org>,
        Marcelo Leitner <mleitner@redhat.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
 <e1e94c51-403a-ebed-28bb-06c5f2d518bc@ovn.org>
 <9d58f6dc-3508-6c10-d5ba-71b768ad2432@nvidia.com>
 <35e2378f-1a9b-9b32-796d-cb1c8c777118@ovn.org>
 <CALnP8ZaEFnd=N_oFar+8hBF=XukRis92cnW4KBtywxnO4u9=zQ@mail.gmail.com>
 <a2f19534-9752-845c-9b8a-3aa75b5f3706@nvidia.com>
 <CALnP8ZbQtyRx-s9GWvTVyBVU3SoGTDA9r9u+eEj39ZVq8LotHA@mail.gmail.com>
 <363f85d5-73bf-0b8e-dd60-5fc234d1d177@ovn.org>
 <CALnP8ZaXQAC8SDcRh3ZW4oTpgfhSnNYfqJ941pH3BByENmaQzw@mail.gmail.com>
 <ac24fe71-aca6-ea6c-bbbb-a54a58a52bd1@ovn.org>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <ac24fe71-aca6-ea6c-bbbb-a54a58a52bd1@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0430.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::34) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|CY8PR12MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: d7ff427b-443f-4a44-7231-08db0a9adb0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SuimClNj5oU6GZ6DfwuqeZsUlLInHStvHNcP8l8hCaMbpAhHiz/qkGdWO6Ywbe3F492bfkIeVCUuKwA8lymcKwhAFQtY4BuocPHr1KNF3yYfu9crTMUfQkl+daGfp/ungUICSraqd+Y83cthDC0k4b4MvmBmcPSurmtHkDp/VthkuIKRVieKpi4GtMMYifGdb5TkvXPFwrZH+G9dpZgKi8J5wBqPF9e3A9Xq3fSlviA8VEERHlDO0v+4FU3E9w62FDgLAKjgUC1/NgmIM7FXOqa5NpSKvEYI+CgEdV0/lNMebDrrZBOXbOUXn9B7o/izHIPMgqalYME1d0dzzIt/d/m1gZ5xbskFobV3q0nenHrvoZNWbPctqkSLDDb0jHQIi0N03Y97A53Nt+L4h6zQSgI5QGCHNwr4gX6vmInLSKN8VlEQbIkKNX3Fxi9DdzD6gBAWOOFzaK26In1x5zw0T+ZI0858PnRcVVaIybYsloKNTPwokjRU67Qg5dqZ+jICs/yxP09e0mhqFEWr3O4u8TD9jbrpnkDE/cB2gwg2/5WoDFgSkVeI4f/NhFq7vCSCK9Cae12dbXu8BxuNfz8FRjjJR2WkQ3lEqGeIjTkpJVPndsnkfsj/U1BHwzRBMVKwvJvnF+v57VDAgPi5Ts4GuV+Z+4eoJPQVULTA99Ob24+wPattdYSM9oj+JYEBbUUlLzroBVE1llv9esFHoAVSOXk8fwrltbqNMabjYsfllQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(451199018)(54906003)(110136005)(36756003)(316002)(5660300002)(38100700002)(8936002)(41300700001)(2906002)(30864003)(8676002)(66476007)(66556008)(4326008)(66946007)(83380400001)(31696002)(107886003)(6666004)(186003)(6512007)(2616005)(6486002)(478600001)(53546011)(31686004)(86362001)(26005)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVpScDJLRWsrWE5XS2ZoQXpZMWthUzI2eFZiV2JPMk5FNkxqRUJTd01ySG1l?=
 =?utf-8?B?aVJiN1ovU1l3K1Rrd0lyT3l4bU9OeGNmYllITXJsUDVhWVJOS0RBeHc4SFBD?=
 =?utf-8?B?OE40K2k4c2UrS2gwWld6Qkx0MWk2TWc5UkRjeWluRmgyLys5NWZjTnp6TWRQ?=
 =?utf-8?B?b1R5NFFXRTJqbUN3b1NMejc4RHJDbTlyNFh2Nm9USnBTa0U0TUM2Um1FYTEz?=
 =?utf-8?B?L3QxMWlUMHZqRXhKellpSmZTNXlMTjJrVjNpUVFncWgzekhHTThEc1NQSmww?=
 =?utf-8?B?alRUSnZieWtvcFZTcHBmdzJQNGdXV08xanhiN0hBbjlOVUdma245U0o2RU4z?=
 =?utf-8?B?V1VoUy8xeld3ellWMlVYNGdDT3h0N0hjVG54NHc0QS9HRDljTGxZS09NWktY?=
 =?utf-8?B?elNtaEVZZnFPMnhBZjBveFBXNlVQc2JtYjdaUTFFa3lITzlmZGsyTFlyaHBW?=
 =?utf-8?B?T1dBNjRGSWV5WTU1OVpEU1haTDFzRkI4bDRlM0hrb0lIOEtrRHozbUJHNGU5?=
 =?utf-8?B?a3ZFNFkwZU5MbjdBVTBScnZqZVVuczNjRElwclA4U1c4WXJXSm1OUWQzZHdO?=
 =?utf-8?B?ZVVsWFowekV6QVIrWUxzbmFQalN3TFp1K1lPcU5IQi9tc1hVeVlRWVFkZlJs?=
 =?utf-8?B?MEVsSS8zSERvSjVzOFZ5VCtsYmIzckNtdUlTbmJvMWFBcXhRa2k2MjdIM3VS?=
 =?utf-8?B?K3lueTZiOU1qNVRXTXZUVmduVzNQNlNQUnQveFMyY2pTTjAxMFdrYzFUcTEw?=
 =?utf-8?B?RHpnczA3UzF0MGUzVXdkY0U5M0xZOWEzd2hVV3pwMjUyby9mK2hJdXcwUVI4?=
 =?utf-8?B?ZzNpQnVNNEtIZzVkQnFtZVpDREZVR0RUSEdoRmQxMXlrZENKYndjUFpFREpU?=
 =?utf-8?B?Q2ZnWUR1Z0lZZ2pRcnluTk4wN2kzdStrdGdwQllkMzdYT1d6WW1QNXlVR1gv?=
 =?utf-8?B?bThHUkJaVWthaXkyVUN6WElrZmlpRTVJSDc0d2ttTUtTMlNYWURQbjEwaUJs?=
 =?utf-8?B?bk1RejdkYWZWYis4R2YyVDlZdGYvQWwyUnovaWh3ek1aZnZQeEx3aERkT3hK?=
 =?utf-8?B?WjgxY1FXYU04MkxYaFJQNG9PTkg3U2M1dk9hdWtRVHBUVkUrOVVVdU9CMjZE?=
 =?utf-8?B?b09vUzc4dEFsTzR4WS9vNmd2Sm44ZTJLSkkvSzJqTEpudEd2UEk4eHVWWEtQ?=
 =?utf-8?B?eGR5aGFBODFlUHNTNmFEYXZVVVBFSUQvM1ZPcjNzd3F6TDlYZmVMM0FMUXN0?=
 =?utf-8?B?eDVEcTNHTkVOTituY05MVm1IOTdoR3J1RzNheGpZOWw2V3kvaCs4L2FTTk8v?=
 =?utf-8?B?T2w2dHZKWDUyRkZlMFh3U1VydGFmWXBMeWVwZUs0di9uN2NXMU1yMFQyNTVI?=
 =?utf-8?B?V0xsMzVGWnZYSVB3SDdMdHVaRDU1NGM4VUtLc0FtbDVJNzVKMStzSUZMV3dI?=
 =?utf-8?B?dnNPOGZoTGN3QTBSay9iOFV5MGt0dkNoZzJYL0N2a2JmazhCaWFsNGZ1MC9F?=
 =?utf-8?B?aTBjalE0TXJUTms3T3ZtcDFnNklxRFlnV0tvZklnakFFUzNZZk1KOGoxNDJr?=
 =?utf-8?B?eVcyd2VzQzdSYjlxWUN5V0ROY2E5R01CMHVqbm9LL1MzZDF0WmN5QXoyTzBI?=
 =?utf-8?B?TVJNSnNURHdBVThueHlzQy93TFNJeFpxWWR2NllCdXhXUzVOV3FsTUxZRzRL?=
 =?utf-8?B?UmdzaXdJdUUrNjJoaUk0dTYzd2VMUXl5OG5GS1hDazlPa0lXSGt1VWpsMkYy?=
 =?utf-8?B?NjdBMWFjUmgrdU1jNXNsU1RzT3lPR1F0ZDhGUCtjSGZnMENOOUZWanJOaGQv?=
 =?utf-8?B?c2taTkxiRFBOWE0rTWpsZkE5aWxESjZFU3hEeG1PTnUwTnc4QnNCTS9ENUJ2?=
 =?utf-8?B?ZGlHYVVwNjRWM1J0anloYjF1bkZPM0ltMjNQU3EzaHdmbGpuRzBDMytKUUl2?=
 =?utf-8?B?THpPUHdCQ0RzbW9BZEFjaTh0Mi9ocStKem5ORDMxT2dFUHduZDdnSkdWbi9i?=
 =?utf-8?B?cU15N2ZvdXBDYXV2Q013ZWczMnZneHdWdFQwRy81R25HbkxxcWJibzBzTWw4?=
 =?utf-8?B?YXd4dG5BVWE0citXR29Ba01kelV0MzVJbi9ib0JZdzM3MmRiVWpIQW5HNjJJ?=
 =?utf-8?Q?dcUyLN7SsIhazH3UzN35VLDpU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7ff427b-443f-4a44-7231-08db0a9adb0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 12:40:42.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6XyBxwVLw5vbMvXNVRGmVfMB0l1Tpr9s/I3RnGNWFctJeP2XsTKMC6g645VJxul0XC/MDl4Ncy7ltz8DtuY9YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7363
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/02/2023 14:07, Ilya Maximets wrote:
> On 2/9/23 02:09, Marcelo Leitner wrote:
>> On Thu, Feb 09, 2023 at 01:09:21AM +0100, Ilya Maximets wrote:
>>> On 2/8/23 19:01, Marcelo Leitner wrote:
>>>> On Wed, Feb 08, 2023 at 10:41:39AM +0200, Paul Blakey wrote:
>>>>>
>>>>>
>>>>> On 07/02/2023 07:03, Marcelo Leitner wrote:
>>>>>> On Tue, Feb 07, 2023 at 01:20:55AM +0100, Ilya Maximets wrote:
>>>>>>> On 2/6/23 18:14, Paul Blakey wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 06/02/2023 14:34, Ilya Maximets wrote:
>>>>>>>>> On 2/5/23 16:49, Paul Blakey wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>
>>>>>>>>>> This series adds support for hardware miss to instruct tc to continue execution
>>>>>>>>>> in a specific tc action instance on a filter's action list. The mlx5 driver patch
>>>>>>>>>> (besides the refactors) shows its usage instead of using just chain restore.
>>>>>>>>>>
>>>>>>>>>> Currently a filter's action list must be executed all together or
>>>>>>>>>> not at all as driver are only able to tell tc to continue executing from a
>>>>>>>>>> specific tc chain, and not a specific filter/action.
>>>>>>>>>>
>>>>>>>>>> This is troublesome with regards to action CT, where new connections should
>>>>>>>>>> be sent to software (via tc chain restore), and established connections can
>>>>>>>>>> be handled in hardware.
>>>>>>>>>>
>>>>>>>>>> Checking for new connections is done when executing the ct action in hardware
>>>>>>>>>> (by checking the packet's tuple against known established tuples).
>>>>>>>>>> But if there is a packet modification (pedit) action before action CT and the
>>>>>>>>>> checked tuple is a new connection, hardware will need to revert the previous
>>>>>>>>>> packet modifications before sending it back to software so it can
>>>>>>>>>> re-match the same tc filter in software and re-execute its CT action.
>>>>>>>>>>
>>>>>>>>>> The following is an example configuration of stateless nat
>>>>>>>>>> on mlx5 driver that isn't supported before this patchet:
>>>>>>>>>>
>>>>>>>>>>     #Setup corrosponding mlx5 VFs in namespaces
>>>>>>>>>>     $ ip netns add ns0
>>>>>>>>>>     $ ip netns add ns1
>>>>>>>>>>     $ ip link set dev enp8s0f0v0 netns ns0
>>>>>>>>>>     $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
>>>>>>>>>>     $ ip link set dev enp8s0f0v1 netns ns1
>>>>>>>>>>     $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up
>>>>>>>>>>
>>>>>>>>>>     #Setup tc arp and ct rules on mxl5 VF representors
>>>>>>>>>>     $ tc qdisc add dev enp8s0f0_0 ingress
>>>>>>>>>>     $ tc qdisc add dev enp8s0f0_1 ingress
>>>>>>>>>>     $ ifconfig enp8s0f0_0 up
>>>>>>>>>>     $ ifconfig enp8s0f0_1 up
>>>>>>>>>>
>>>>>>>>>>     #Original side
>>>>>>>>>>     $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
>>>>>>>>>>        ct_state -trk ip_proto tcp dst_port 8888 \
>>>>>>>>>>          action pedit ex munge tcp dport set 5001 pipe \
>>>>>>>>>>          action csum ip tcp pipe \
>>>>>>>>>>          action ct pipe \
>>>>>>>>>>          action goto chain 1
>>>>>>>>>>     $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>>>>>>>>        ct_state +trk+est \
>>>>>>>>>>          action mirred egress redirect dev enp8s0f0_1
>>>>>>>>>>     $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
>>>>>>>>>>        ct_state +trk+new \
>>>>>>>>>>          action ct commit pipe \
>>>>>>>>>>          action mirred egress redirect dev enp8s0f0_1
>>>>>>>>>>     $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
>>>>>>>>>>          action mirred egress redirect dev enp8s0f0_1
>>>>>>>>>>
>>>>>>>>>>     #Reply side
>>>>>>>>>>     $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
>>>>>>>>>>          action mirred egress redirect dev enp8s0f0_0
>>>>>>>>>>     $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
>>>>>>>>>>        ct_state -trk ip_proto tcp \
>>>>>>>>>>          action ct pipe \
>>>>>>>>>>          action pedit ex munge tcp sport set 8888 pipe \
>>>>>>>>>>          action csum ip tcp pipe \
>>>>>>>>>>          action mirred egress redirect dev enp8s0f0_0
>>>>>>>>>>
>>>>>>>>>>     #Run traffic
>>>>>>>>>>     $ ip netns exec ns1 iperf -s -p 5001&
>>>>>>>>>>     $ sleep 2 #wait for iperf to fully open
>>>>>>>>>>     $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888
>>>>>>>>>>
>>>>>>>>>>     #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
>>>>>>>>>>     $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
>>>>>>>>>>            Sent hardware 9310116832 bytes 6149672 pkt
>>>>>>>>>>            Sent hardware 9310116832 bytes 6149672 pkt
>>>>>>>>>>            Sent hardware 9310116832 bytes 6149672 pkt
>>>>>>>>>>
>>>>>>>>>> A new connection executing the first filter in hardware will first rewrite
>>>>>>>>>> the dst port to the new port, and then the ct action is executed,
>>>>>>>>>> because this is a new connection, hardware will need to be send this back
>>>>>>>>>> to software, on chain 0, to execute the first filter again in software.
>>>>>>>>>> The dst port needs to be reverted otherwise it won't re-match the old
>>>>>>>>>> dst port in the first filter. Because of that, currently mlx5 driver will
>>>>>>>>>> reject offloading the above action ct rule.
>>>>>>>>>>
>>>>>>>>>> This series adds supports partial offload of a filter's action list,
>>>>>>>>>> and letting tc software continue processing in the specific action instance
>>>>>>>>>> where hardware left off (in the above case after the "action pedit ex munge tcp
>>>>>>>>>> dport... of the first rule") allowing support for scenarios such as the above.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Hi, Paul.  Not sure if this was discussed before, but don't we also need
>>>>>>>>> a new TCA_CLS_FLAGS_IN_HW_PARTIAL flag or something like this?
>>>>>>>>>
>>>>>>>>> Currently the in_hw/not_in_hw flags are reported per filter, i.e. these
>>>>>>>>> flags are not per-action.  This may cause confusion among users, if flows
>>>>>>>>> are reported as in_hw, while they are actually partially or even mostly
>>>>>>>>> processed in SW.
>>>>>>>>>
>>>>>>>>> What do you think?
>>>>>>>>>
>>>>>>>>> Best regards, Ilya Maximets.
>>>>>>>>
>>>>>>>> I think its a good idea, and I'm fine with proposing something like this in a
>>>>>>>> different series, as this isn't a new problem from this series and existed before
>>>>>>>> it, at least with CT rules.
>>>>>>>
>>>>>>> Hmm, I didn't realize the issue already exists.
>>>>>>
>>>>>> Maintainers: please give me up to Friday to review this patchset.
>>>>>>
>>>>>> Disclaimer: I had missed this patchset, and I didn't even read it yet.
>>>>>>
>>>>>> I don't follow. Can someone please rephase the issue please?
>>>>>> AFAICT, it is not that the NIC is offloading half of the action list
>>>>>> and never executing a part of it. Instead, for established connections
>>>>>> the rule will work fully offloaded. While for misses in the CT action,
>>>>>> it will simply trigger a miss, like it already does today.
>>>>>
>>>>> You got it right, and like you said it was like this before so its not
>>>>> strictly related by this series and could be in a different patchset. And I
>>>>> thought that (extra) flag would mean that it can miss, compared to other
>>>>> rules/actions combination that will never miss because they
>>>>> don't need sw support.
>>>>
>>>> This is different from what I understood from Ilya's comment. Maybe I
>>>> got his comment wrong, but I have the impression that he meant it in
>>>> the sense of having some actions offloaded and some not.
>>>> Which I thinkit is not the goal here.
>>>
>>> I don't really know the code around this patch set well enough, so my
>>> thoughts might be a bit irrelevant.  But after reading the cover letter
>>> and commit messages in this patch set I imagined that if we have some
>>> kind of miss on the N-th action in a list in HW, we could go to software
>>> tc, find that action and continue execution from it.  In this case some
>>> actions are executed in HW and some are in SW.
>>
>> Precisely. :)
>>
>>>
>>>  From the user's perspective, if such tc filter reports an 'in_hw' flag,
>>> that would be a bit misleading, IMO.
>>
>> I may be tainted or perhaps even biased here, but I don't see how it
>> can be misleading. Since we came up with skip_hw/sw I think it is
>> expected that packets can be handled in both datapaths. The flag is
>> just saying that hw has this flow. (btw, in_sw is simplified, as sw
>> always accepts the flow if skip_sw is not used)
>>
>>>
>>> If that is not what is happening here, then please ignore my comments,
>>> as I'm not sure what this code is about then. :)
>>>
>>>>
>>>> But anyway, flows can have some packets matching in sw while also
>>>> being in hw. That's expected. For example, in more complex flow sets,
>>>> if a packet hit a flow with ct action and triggered a miss, all
>>>> subsequent flows will handle this packet in sw. Or if we have queued
>>>> packets in rx ring already and ovs just updated the datapath, these
>>>> will match in tc sw instead of going to upcall. The latter will have
>>>> only a few hits, yes, but the former will be increasing over time.
>>>> I'm not sure how a new flag, which is probably more informative than
>>>> an actual state indication, would help here.
>>>
>>> These cases are related to just one or a very few packets, so for them
>>> it's generally fine to report 'in_hw', I think.  The vast majority of
>>> traffic will be handled in HW.
>>>
>>> My thoughts were about a case where we have a lot of traffic handled
>>> partially in HW and in SW.  Let's say we have N actions and HW doesn't
>>> support action M.  In this case, driver may offload actions [0, M - 1]
>>> inserting some kind of forced "HW miss" at the end, so actions [M, N]
>>> can be executed in TC software.
>>
>> Right. Please lets consider this other scenario then. Consider that we
>> have these flows:
>> chain 0,ip,match ip X actions=ct,goto chain 1
>> chain 1,proto_Y_specific_match actions=ct(nat),goto chain 2
>> chain 2 actions=output:3
>>
>> The idea here is that on chain 1, the HW doesn't support that particular
>> match on proto Y. That flow will never be in_hw, and that's okay. But
>> the flow on chain 2, though, will be tagged as in_hw, and for packets
>> following these specific sequence, they will get handled in sw on
>> chain 2.
>>
>> But if we have another flow there:
>> chain 1,proto tcp actions=ct(nat),set_ttl,goto chain 2
>> which is supported by the hw, such packets would be handled by hw in
>> chain 2.
>>
>> The flow on chain 2 has no idea on what was done before it. It can't
>> be tagged with _PARTIAL as the actions in there are not expected to
>> trigger misses, yet, with this flow set, it is expected to handle
>> packets in both datapaths, despite being 'in_hw'.
>>
>> I guess what I'm trying so say is that it is not because a flow is
>> tagged with in_hw that sw processing is unexpected straight away.
>>
>> Hopefully this makes sense?
> 
> Yep.  I see your point.  In this case I agree that we can't really tell
> if the traffic will be handled in HW or SW and the chain 2 will be
> always handled in both.  So, the fact that it is 'in_hw' only means that
> the chain is actually in HW as that HW actually has it.
> 
> Summarizing: having something doesn't mean using it. :)  So, thinking
> that in_hw flows are actually fully processed in HW is a user's fault. :/
> 
> However, going back to my example where HW supports half of actions
> in the chain ([0, M - 1]) and doesn't support the other half ([M, N])...
> If the actions M to N are actually not installed into HW, marking the
> chain as in_hw is a bit misleading, because unlike your example, not all
> the actions are actually in HW and driver knows that.  For that case,
> something like _PARTIAL suffix might still be useful.


Right, and for now at least, no one does that :)

> 
>>
>>>
>>> But now I'm not sure if that is possible with the current implementation.
>>
>> AFAICT you got all right. It is me that had misunderstood you. :)
>>
>>>
>>>>
>>>>>
>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> So how about I'll propose it in a different series and we continue with this first?
>>>>>>
>>>>>> So I'm not sure either on what's the idea here.
>>>>>>
>>>>>> Thanks,
>>>>>> Marcelo
>>>>>>
>>>>>>>
>>>>>>> Sounds fine to me.  Thanks!
>>>>>>>
>>>>>>> Best regards, Ilya Maximets.
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 
