Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D006312DE
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 08:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiKTHms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 02:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKTHmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 02:42:36 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34DED9
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 23:42:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2gnACNcezxlgGrI9nO8jXfQwsZ9kv842PCRj5eDo+Vf/LW93Xgq86vcuYSX7SRdd1UBaZR+BDkEXdz+nGw3DDzUAc/hrRfWIEQBLS27CvOsqcss7V25aZEWAKhe3oTUOaGUitcOY+z56OWycktNL925Mdhcu+28CFoNjASJi0qhF1OMjpTXv42PDjQ2ZhIA3XxvKKFArPT9gzGUytnyPSd25YhP2sa69LcowMwkM1aHFkACUe/wqoFALtPoBwwahOb3qdYM+5m7TVsUAn7bLhuECUy7O1hCEeQRsXjSDX2+SLAcRAKmgmxd3Cte2Vx/2w2aATuqdzb4hHh3JMtBOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qovvELxBFAkt9qPXJnz+69pXYZqxoYwIg+ZpcNmdU4U=;
 b=GBU0elD+SitvSUE7sP+etHxu9ceaP5Ttoe041sknRZ9cFsQv57YFR36rp1kU3+tYPf5MAOBpefrEWQ1B9vm0BwD4Y1KD5Xib7sNw168v98tkXO/E1hQZPDfkZidrA2s5il0EmJYmP1i2XOSIJyco5wt9gCWw12IL/jEQytz6Mfhq1rg9F9e7FzyLxcKPAh8WA5ydqRiTAKHs0YfI9ADckl53DVV7iDlMpoOZgTG/j9LPvuDY+hwdfb/7QWt8sWv+M2issez1L+Dg5jOO8cGgcAPG6aPfPXa7SrXkB6rre1AX/J/Xt5aVEhk7CNdZ6FmtIOfhZGzUmyVBwpaxdsmQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qovvELxBFAkt9qPXJnz+69pXYZqxoYwIg+ZpcNmdU4U=;
 b=PZ7hXcr2NvgenEC75VeVqbpWaQebvOMHoA2ofqVe2xqGE6MvK6ekPkKpSx0MlZiOtQ+k7E7NvnzM+meves30qjEWshoHRfkssT9xhE1C7QZn0Ay8kND/ZDEsiCu8Q/uP8zcQgVpHmVmShvsRTl1j5VI6YQZ5AIm5D3eBKYhdVNWd4NRCOH1CTWaIywb31Gt7/rVDiHdPv5zl+fypjzQMw2zVht9n/+HQuqyBU+bZGDL3i0Wbo7yYyca1SvIyAKKi1VgQzahw+HvvyeCdDtMlgCzB8w33LcCsTfKHlx2hRcd86JmdBKLVGiNBYNffWrZ1T/VjPPGsloAORyuQMqEzqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sun, 20 Nov
 2022 07:42:24 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::d01c:4567:fb90:72b9%4]) with mapi id 15.20.5834.015; Sun, 20 Nov 2022
 07:42:24 +0000
Message-ID: <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com>
Date:   Sun, 20 Nov 2022 09:42:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
From:   Gal Pressman <gal@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <20221018203258.2793282-1-edumazet@google.com>
 <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org>
 <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
 <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
Content-Language: en-US
In-Reply-To: <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::15) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 73c43dbd-4e2a-4d6d-42e6-08dacacac2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0n39u8yQBU7qW9Y/QSW2uOVJxgUMxtkphpobIaHEgTChlomy4/NFBEArzwRKMGSmZu1d/DiiUI3hv3Bcr1dRJu/HmTUapkdA0UQqjrSafttRlpUZAwru5qVQLBrkz4r8Xi8XPuPXZxYe2mBbfxYhKswhGSPh9JS97aFhayvDW8bGra3a1qWKSB/22vKD/BNmeGJ4KrWma8G8vnYrvTs0COi7fiWodUI6pz2iesU2yYxVTCoReXA3w4OY2QVJO7tdH8a0Mv4TArsc4uqnIwZxKuDOZ2kxOkSRbLvouW20WifDnjv/pM5xON/DFCD2rshppqvfDrYuDlS2bUufsh6swooiFzfpQSpebTHJc6N2q0m9v6ptIzSpqpO/msBYUk3MStPkC+o0VhThJksySTjgsw899BcD0bfvs4P9aHaGwQ7xy5jV8ZAAJ/ZIedLoUnNAByHNsSVMg9M6p5JeqxrW7zIpkreUqn5yp8KIY0qih31k/gbExLWvAN7Ti4ulk+eJt7D/GdzsNNSeKzsjdNxkvTduGcG4fqAb3DLZlnqJlUJai1bJV0mnnE6WC3nnPalz/yDW10urZCsTUv+zfkMjbp10EM3wXXdqsRh9IeRRVH9QDqFVB4HOIvbaJkeuijg/O8yGx4dDgkGPBPtwTqVDWLpVlmHR75EwWDblUECbAN+ArD4hvOdVgZK+1dapqYZTF+HeMuFclyTNKRH7Zsvvx8YZW91YcFRsHFN4AMvwhV/pyw5ZMxQiqJmaI8gVEZ4p8pv4Ad2rfQhSYfZNGn1icEVNLEyEPXY0GNk44DzTTjkMat5QF60uBJbUOEJXlUvr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(478600001)(31686004)(54906003)(6666004)(6506007)(6486002)(966005)(66556008)(4326008)(38100700002)(66476007)(66946007)(31696002)(86362001)(8676002)(316002)(26005)(30864003)(6512007)(83380400001)(6916009)(53546011)(7416002)(41300700001)(186003)(5660300002)(8936002)(2906002)(2616005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkMvU3ZzRTJBUDJ3T3dSbGJjUGhyTHhGSXZ1MUtDZjErTzQvT1FVREVFc2RQ?=
 =?utf-8?B?WUpaY0pDbDh6K0ZZaWZJSVRoNzdRUmx1RUgvSDJ2NEZoSTRHbU1BNmRvNUYz?=
 =?utf-8?B?TWpVcWgvUHpTRytIaVVRRWtGdWFIWnJUVHFRVHduVkltbi83Z0hza1hCN3VC?=
 =?utf-8?B?dFRBYWZqbGd6TSt3WFVUOU1xc2c1Yy9uS3RyN1VKcEROVGhnYTBIV1RLOWVk?=
 =?utf-8?B?WlRKckw5TklOeEcyTkV6aFNZTC91WGRpUGNaVFJKbEFmN05rVmxNeENsRTlV?=
 =?utf-8?B?SElQT1h4K1Z6VmRLK0NueEJIclJEWmV6U0gxV2R6eXpaWnlCdFVZTlFRQ0l2?=
 =?utf-8?B?SCtIdGVCMm5uUmxGNkZ4R0NXS0lSTUsyNWs0V0JNUUltek8zb1JLVVpxV09z?=
 =?utf-8?B?c21MSDhaTzBFZExIRVJVek8vdGRDamtqM0hjYkJuT2kzbnI0bUpKK1hoZjFQ?=
 =?utf-8?B?UnBDYTNWNW5tdExaMnpOOGR0cVozOENjbzZubllsZGFpQnN4cFRRWlM3bjFl?=
 =?utf-8?B?SElkM2xXNHN1TVVGQW5nRGtjY3lBUjZjbkNGdDVmanZyUGlrdG9tYy81Nzd6?=
 =?utf-8?B?czloRFhDbE9jNXR3TFRlZEV4Nng3UjRQQTZwTHk3ZVFBeWFLMEFmWUtteXla?=
 =?utf-8?B?K0svZGxkVXlGSUhScHBmSGtxTmpsYzRzU3MzRjdJbklaYkNIQjhYU1JxV0lX?=
 =?utf-8?B?OTdTTlVxUnNDSjhmOXIrNzdIZUR0ODEvUnpIUitPUENIY0hhSTBBVVc0Nldu?=
 =?utf-8?B?ZXZYZjRYUkdpd3hsNzZyTzhZRGNud3dFdWtmTnJLV0hURmFsMVJiS0dwWlFw?=
 =?utf-8?B?clFjWWtyTE92SS9HaXA5eTVJeEQyaWRtODk0TExvZUtoakIwUEo5OG0vWlRK?=
 =?utf-8?B?Q0x6RDlXY1VXckN4MHJ1aXNTV2xiOGlEVmZwTnA4Y2kvL3JvTGVXejhIU3Jm?=
 =?utf-8?B?R0FaSmlCVllmYzM3bVpFVTU5bERYaXB6N3R5eS8rdnFWWlRxeHVDeHYrczhN?=
 =?utf-8?B?djdZQVpEM3pIekUzMVYvR0VBTWQxTklMZlNOT3puT01wU05nUXlBNE1kYjUy?=
 =?utf-8?B?Q09hMWtvZWU4d3dkbC9LclkvR1FyZnpzbzFHaDM5K3ZlNWwrV2JTQmdBQ1JO?=
 =?utf-8?B?NlY2K0x6Y2I5OXNkSm9YcEV5U0Y0OU5rRG5QblJNTnVIREZvL2lmQ2FHbGdq?=
 =?utf-8?B?YlFOZUVMYWV5Y3hGcnVvbEhmWit2Wk1pdWF3VTdoMkVpbGhCaGtKWWM1RXhE?=
 =?utf-8?B?SjRBS1RUVG9HT2N6d0J2N25MVTdhcExQc3BERHJZaFdTNldGdFFYQWFyQStX?=
 =?utf-8?B?MHFtMk9ZenJvbVRqd2ZrZ0dnZTgvWkUvVWpsZFE3emJTank3d3lxQllSY1Q2?=
 =?utf-8?B?ZUM5dmhWUTlyTjBhMGV5ek5TSmhVd0VsaHF0em8rNWdjb05HQzdQeENGRnpa?=
 =?utf-8?B?VnJPR3ZsUm02WW5NVkxhZkFMeVdQSHdwbDMxeDFVNTR1bWhyTHhnY3pBRGFK?=
 =?utf-8?B?d0JmYi84eklIU3VKR3NQUyt6aWZEdDVrKzE4U0dMYVRXaWFsVjhqeVZhTjBT?=
 =?utf-8?B?SDRKWWN2R3JQRnpTcXI5RDBTS29yUUVLRjl0eGJMekRyUDlpRENYQmg0dXJB?=
 =?utf-8?B?aGxnbjA4aDY5K0libFZmWXdidUhjRjg5VlhSc1MxMWd6WitIcDZ5U0NxNEV4?=
 =?utf-8?B?dHJpWHBZUVFqS1E2VHlPOThaL2dSS3pwU0ZpbW9uZzhoZFI0K3RZVDk5ekg5?=
 =?utf-8?B?R3B5RjBObGJ2U2cwV0xWNDk4aWVBV0FlVVJVT2R6V2RpMXE5LzByU1M3U0hS?=
 =?utf-8?B?TVU5VGY4eUtKTVhBcXlEWDAvRmNqVjU5WHVZY01CTFFTNVNyRkF0Q29zSUM3?=
 =?utf-8?B?QTBzN0hyOVl4dzBjVmowWEpUd3hvK0o3N0lOL2FKYUh4TzExZzlVRVo4SjJC?=
 =?utf-8?B?bkpBand4Sk9uUWk1bUxFTVFZSld1Um03WGNGb1FFdCtCZEFYNm1CL0J2SnZG?=
 =?utf-8?B?ZU5EVTRteFJvS3V2L0xBWGQ5bmE5UFJHTkFLazVFeSsrYVFLcThST0JCT2Q3?=
 =?utf-8?B?SEpNUlp5cXF0YllkVVpUZWs4ZmorTWh1aUxTYk9obHN6TTkrWHRuU2xTWWFC?=
 =?utf-8?Q?8ylQelADLt4sFOxvwQH3HBHaC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73c43dbd-4e2a-4d6d-42e6-08dacacac2ac
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2022 07:42:23.8993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Pqhd20+Cmfyn/u8vT/ubLg9tRyajRkH+qqKYHaRdwLDcarri5cbMGHg6gvU3I0Fk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 11:08, Gal Pressman wrote:
> On 06/11/2022 10:07, Gal Pressman wrote:
>> On 03/11/2022 18:33, Eric Dumazet wrote:
>>> On Thu, Nov 3, 2022 at 9:31 AM Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>>>> On Thu, 3 Nov 2022 at 17:30, Eric Dumazet <edumazet@google.com> wrote:
>>>>> On Thu, Nov 3, 2022 at 8:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>> On Thu, 3 Nov 2022 08:17:06 -0700 Eric Dumazet wrote:
>>>>>>> On Thu, Nov 3, 2022 at 6:34 AM Gal Pressman <gal@nvidia.com> wrote:
>>>>>>>> On 18/10/2022 23:32, Eric Dumazet wrote:
>>>>>>>>> We had one syzbot report [1] in syzbot queue for a while.
>>>>>>>>> I was waiting for more occurrences and/or a repro but
>>>>>>>>> Dmitry Vyukov spotted the issue right away.
>>>>>>>>>
>>>>>>>>> <quoting Dmitry>
>>>>>>>>> qdisc_graft() drops reference to qdisc in notify_and_destroy
>>>>>>>>> while it's still assigned to dev->qdisc
>>>>>>>>> </quoting>
>>>>>>>>>
>>>>>>>>> Indeed, RCU rules are clear when replacing a data structure.
>>>>>>>>> The visible pointer (dev->qdisc in this case) must be updated
>>>>>>>>> to the new object _before_ RCU grace period is started
>>>>>>>>> (qdisc_put(old) in this case).
>>>>>>>>>
>>>>>>>>> [1]
>>>>>>>>> BUG: KASAN: use-after-free in __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>>>> Read of size 4 at addr ffff88802065e038 by task syz-executor.4/21027
>>>>>>>>>
>>>>>>>>> CPU: 0 PID: 21027 Comm: syz-executor.4 Not tainted 6.0.0-rc3-syzkaller-00363-g7726d4c3e60b #0
>>>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
>>>>>>>>> Call Trace:
>>>>>>>>> <TASK>
>>>>>>>>> __dump_stack lib/dump_stack.c:88 [inline]
>>>>>>>>> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>>>>>>>> print_address_description mm/kasan/report.c:317 [inline]
>>>>>>>>> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
>>>>>>>>> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
>>>>>>>>> __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>>>> __tcf_qdisc_find net/sched/cls_api.c:1051 [inline]
>>>>>>>>> tc_new_tfilter+0x34f/0x2200 net/sched/cls_api.c:2018
>>>>>>>>> rtnetlink_rcv_msg+0x955/0xca0 net/core/rtnetlink.c:6081
>>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>>> RIP: 0033:0x7f5efaa89279
>>>>>>>>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>>>>>>>> RSP: 002b:00007f5efbc31168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>>>>>>>> RAX: ffffffffffffffda RBX: 00007f5efab9bf80 RCX: 00007f5efaa89279
>>>>>>>>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
>>>>>>>>> RBP: 00007f5efaae32e9 R08: 0000000000000000 R09: 0000000000000000
>>>>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>>>>>>> R13: 00007f5efb0cfb1f R14: 00007f5efbc31300 R15: 0000000000022000
>>>>>>>>> </TASK>
>>>>>>>>>
>>>>>>>>> Allocated by task 21027:
>>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>>> kasan_set_track mm/kasan/common.c:45 [inline]
>>>>>>>>> set_alloc_info mm/kasan/common.c:437 [inline]
>>>>>>>>> ____kasan_kmalloc mm/kasan/common.c:516 [inline]
>>>>>>>>> ____kasan_kmalloc mm/kasan/common.c:475 [inline]
>>>>>>>>> __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
>>>>>>>>> kmalloc_node include/linux/slab.h:623 [inline]
>>>>>>>>> kzalloc_node include/linux/slab.h:744 [inline]
>>>>>>>>> qdisc_alloc+0xb0/0xc50 net/sched/sch_generic.c:938
>>>>>>>>> qdisc_create_dflt+0x71/0x4a0 net/sched/sch_generic.c:997
>>>>>>>>> attach_one_default_qdisc net/sched/sch_generic.c:1152 [inline]
>>>>>>>>> netdev_for_each_tx_queue include/linux/netdevice.h:2437 [inline]
>>>>>>>>> attach_default_qdiscs net/sched/sch_generic.c:1170 [inline]
>>>>>>>>> dev_activate+0x760/0xcd0 net/sched/sch_generic.c:1229
>>>>>>>>> __dev_open+0x393/0x4d0 net/core/dev.c:1441
>>>>>>>>> __dev_change_flags+0x583/0x750 net/core/dev.c:8556
>>>>>>>>> rtnl_configure_link+0xee/0x240 net/core/rtnetlink.c:3189
>>>>>>>>> rtnl_newlink_create net/core/rtnetlink.c:3371 [inline]
>>>>>>>>> __rtnl_newlink+0x10b8/0x17e0 net/core/rtnetlink.c:3580
>>>>>>>>> rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
>>>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>>>
>>>>>>>>> Freed by task 21020:
>>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>>> kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>>>>>>>>> kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>>>>>>>>> ____kasan_slab_free mm/kasan/common.c:367 [inline]
>>>>>>>>> ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
>>>>>>>>> kasan_slab_free include/linux/kasan.h:200 [inline]
>>>>>>>>> slab_free_hook mm/slub.c:1754 [inline]
>>>>>>>>> slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
>>>>>>>>> slab_free mm/slub.c:3534 [inline]
>>>>>>>>> kfree+0xe2/0x580 mm/slub.c:4562
>>>>>>>>> rcu_do_batch kernel/rcu/tree.c:2245 [inline]
>>>>>>>>> rcu_core+0x7b5/0x1890 kernel/rcu/tree.c:2505
>>>>>>>>> __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
>>>>>>>>>
>>>>>>>>> Last potentially related work creation:
>>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>>>> call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
>>>>>>>>> qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1083
>>>>>>>>> notify_and_destroy net/sched/sch_api.c:1012 [inline]
>>>>>>>>> qdisc_graft+0xeb1/0x1270 net/sched/sch_api.c:1084
>>>>>>>>> tc_modify_qdisc+0xbb7/0x1a00 net/sched/sch_api.c:1671
>>>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>>>
>>>>>>>>> Second to last potentially related work creation:
>>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>>>> kvfree_call_rcu+0x74/0x940 kernel/rcu/tree.c:3322
>>>>>>>>> neigh_destroy+0x431/0x630 net/core/neighbour.c:912
>>>>>>>>> neigh_release include/net/neighbour.h:454 [inline]
>>>>>>>>> neigh_cleanup_and_release+0x1f8/0x330 net/core/neighbour.c:103
>>>>>>>>> neigh_del net/core/neighbour.c:225 [inline]
>>>>>>>>> neigh_remove_one+0x37d/0x460 net/core/neighbour.c:246
>>>>>>>>> neigh_forced_gc net/core/neighbour.c:276 [inline]
>>>>>>>>> neigh_alloc net/core/neighbour.c:447 [inline]
>>>>>>>>> ___neigh_create+0x18b5/0x29a0 net/core/neighbour.c:642
>>>>>>>>> ip6_finish_output2+0xfb8/0x1520 net/ipv6/ip6_output.c:125
>>>>>>>>> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
>>>>>>>>> ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
>>>>>>>>> NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>>>>>>>>> ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
>>>>>>>>> dst_output include/net/dst.h:451 [inline]
>>>>>>>>> NF_HOOK include/linux/netfilter.h:307 [inline]
>>>>>>>>> NF_HOOK include/linux/netfilter.h:301 [inline]
>>>>>>>>> mld_sendpack+0xa09/0xe70 net/ipv6/mcast.c:1820
>>>>>>>>> mld_send_cr net/ipv6/mcast.c:2121 [inline]
>>>>>>>>> mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2653
>>>>>>>>> process_one_work+0x991/0x1610 kernel/workqueue.c:2289
>>>>>>>>> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>>>>>>>>> kthread+0x2e4/0x3a0 kernel/kthread.c:376
>>>>>>>>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>>>>>>>>>
>>>>>>>>> The buggy address belongs to the object at ffff88802065e000
>>>>>>>>> which belongs to the cache kmalloc-1k of size 1024
>>>>>>>>> The buggy address is located 56 bytes inside of
>>>>>>>>> 1024-byte region [ffff88802065e000, ffff88802065e400)
>>>>>>>>>
>>>>>>>>> The buggy address belongs to the physical page:
>>>>>>>>> page:ffffea0000819600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20658
>>>>>>>>> head:ffffea0000819600 order:3 compound_mapcount:0 compound_pincount:0
>>>>>>>>> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
>>>>>>>>> raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888011841dc0
>>>>>>>>> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
>>>>>>>>> page dumped because: kasan: bad access detected
>>>>>>>>> page_owner tracks the page as allocated
>>>>>>>>> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3523, tgid 3523 (sshd), ts 41495190986, free_ts 41417713212
>>>>>>>>> prep_new_page mm/page_alloc.c:2532 [inline]
>>>>>>>>> get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
>>>>>>>>> __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
>>>>>>>>> alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
>>>>>>>>> alloc_slab_page mm/slub.c:1824 [inline]
>>>>>>>>> allocate_slab+0x27e/0x3d0 mm/slub.c:1969
>>>>>>>>> new_slab mm/slub.c:2029 [inline]
>>>>>>>>> ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
>>>>>>>>> __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
>>>>>>>>> slab_alloc_node mm/slub.c:3209 [inline]
>>>>>>>>> __kmalloc_node_track_caller+0x2f2/0x380 mm/slub.c:4955
>>>>>>>>> kmalloc_reserve net/core/skbuff.c:358 [inline]
>>>>>>>>> __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:430
>>>>>>>>> alloc_skb_fclone include/linux/skbuff.h:1307 [inline]
>>>>>>>>> tcp_stream_alloc_skb+0x38/0x580 net/ipv4/tcp.c:861
>>>>>>>>> tcp_sendmsg_locked+0xc36/0x2f80 net/ipv4/tcp.c:1325
>>>>>>>>> tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1483
>>>>>>>>> inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>>> sock_write_iter+0x291/0x3d0 net/socket.c:1108
>>>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>>>> ksys_write+0x1e8/0x250 fs/read_write.c:631
>>>>>>>>> page last free stack trace:
>>>>>>>>> reset_page_owner include/linux/page_owner.h:24 [inline]
>>>>>>>>> free_pages_prepare mm/page_alloc.c:1449 [inline]
>>>>>>>>> free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
>>>>>>>>> free_unref_page_prepare mm/page_alloc.c:3380 [inline]
>>>>>>>>> free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
>>>>>>>>> __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2548
>>>>>>>>> qlink_free mm/kasan/quarantine.c:168 [inline]
>>>>>>>>> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>>>>>>>>> kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
>>>>>>>>> __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
>>>>>>>>> kasan_slab_alloc include/linux/kasan.h:224 [inline]
>>>>>>>>> slab_post_alloc_hook mm/slab.h:727 [inline]
>>>>>>>>> slab_alloc_node mm/slub.c:3243 [inline]
>>>>>>>>> slab_alloc mm/slub.c:3251 [inline]
>>>>>>>>> __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>>>>>>>>> kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3268
>>>>>>>>> kmem_cache_zalloc include/linux/slab.h:723 [inline]
>>>>>>>>> alloc_buffer_head+0x20/0x140 fs/buffer.c:2974
>>>>>>>>> alloc_page_buffers+0x280/0x790 fs/buffer.c:829
>>>>>>>>> create_empty_buffers+0x2c/0xee0 fs/buffer.c:1558
>>>>>>>>> ext4_block_write_begin+0x1004/0x1530 fs/ext4/inode.c:1074
>>>>>>>>> ext4_da_write_begin+0x422/0xae0 fs/ext4/inode.c:2996
>>>>>>>>> generic_perform_write+0x246/0x560 mm/filemap.c:3738
>>>>>>>>> ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:270
>>>>>>>>> ext4_file_write_iter+0x44a/0x1660 fs/ext4/file.c:679
>>>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>>>>
>>>>>>>>> Fixes: af356afa010f ("net_sched: reintroduce dev->qdisc for use by sch_api")
>>>>>>>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>>>>>>>> Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
>>>>>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>>>>>> ---
>>>>>>>>>  net/sched/sch_api.c | 5 +++--
>>>>>>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>>>>>>>>> index c98af0ada706efee202a20a6bfb6f2b984106f45..4a27dfb1ba0faab3692a82969fb8b78768742779 100644
>>>>>>>>> --- a/net/sched/sch_api.c
>>>>>>>>> +++ b/net/sched/sch_api.c
>>>>>>>>> @@ -1099,12 +1099,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>>>>>>>>>
>>>>>>>>>  skip:
>>>>>>>>>               if (!ingress) {
>>>>>>>>> -                     notify_and_destroy(net, skb, n, classid,
>>>>>>>>> -                                        rtnl_dereference(dev->qdisc), new);
>>>>>>>>> +                     old = rtnl_dereference(dev->qdisc);
>>>>>>>>>                       if (new && !new->ops->attach)
>>>>>>>>>                               qdisc_refcount_inc(new);
>>>>>>>>>                       rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
>>>>>>>>>
>>>>>>>>> +                     notify_and_destroy(net, skb, n, classid, old, new);
>>>>>>>>> +
>>>>>>>>>                       if (new && new->ops->attach)
>>>>>>>>>                               new->ops->attach(new);
>>>>>>>>>               } else {
>>>>>>>> Hi Eric,
>>>>>>>> We started seeing the following WARN_ON happening on htb destroy
>>>>>>>> following your patch:
>>>>>>>> https://elixir.bootlin.com/linux/v6.1-rc3/source/net/sched/sch_htb.c#L1561
>>>>>>>>
>>>>>>>> Anything comes to mind?
>>>>>>> Not really. Let's ask Maxim Mikityanskiy <maximmi@nvidia.com>
>>>>>> CC: Maxim on non-nvidia address
>>>>>>
>>>>> Wild guess is that we need this fix:
>>>>>
>>>>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>>>>> index e5b4bbf3ce3d5f36edb512d4017ebd97209bb377..f82c07bd3d60e26e5a1fe2b335dbec29aebb602e
>>>>> 100644
>>>>> --- a/net/sched/sch_htb.c
>>>>> +++ b/net/sched/sch_htb.c
>>>>> @@ -1558,7 +1558,7 @@ static int htb_destroy_class_offload(struct
>>>>> Qdisc *sch, struct htb_class *cl,
>>>>>                 /* Before HTB is destroyed, the kernel grafts noop_qdisc to
>>>>>                  * all queues.
>>>>>                  */
>>>>> -               WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>>>>> +               WARN_ON(old && !(old->flags & TCQ_F_BUILTIN));
>>>> I don't think it's the right fix. If the WARN_ON happens and doesn't
>>>> complain about old == NULL, it's not NULL, so this extra check won't
>>>> help. In any case, old comes from dev_graft_qdisc, which should never
>>>> return NULL.
>>>>
>>>> Maybe something changed after Eric's patch, so that the statement
>>>> above is no longer true? I.e. I expect a noop_qdisc here, but there is
>>>> some other qdisc attached to the queue. I need to recall what was the
>>>> destroy flow and what code assigned noop_qdisc there...
>>> Gal please provide a repro. It is not clear if you get a WARN or a NULL deref.
>> The WARN_ON is triggering, old is not NULL and old->flags is equal to 0x174.
>>
>> It reproduces consistently:
>> ip link set dev eth2 up
>> ip addr add 194.237.173.123/16 dev eth2
>> tc qdisc add dev eth2 clsact
>> tc qdisc add dev eth2 root handle 1: htb default 1 offload
>> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
>> 22500.0mbit burst 450000kbit cburst 450000kbit
>> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
>> 89900kbit cburst 89900kbit
>> tc qdisc delete dev eth2 clsact
>> tc qdisc delete dev eth2 root handle 1: htb default 1
>>
>> Please let me know if there's anything else you want me to check.
> Hi Eric, did you get a chance to take a look?

No response for quite a long time, Jakub, should I submit a revert?
