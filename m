Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B3D623E46
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiKJJI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiKJJI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:08:57 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C960C659D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 01:08:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdVxcm0AvjtsM+oqDSlxs0XFp2fTW8lt8+Uiyq+TEiIJ0arbs0ypbDyEq6wyoh4aplVoW0ZmnfHSQQ4Gkwj5ZMAWy3McpWAX8H5MCq6umdhE6PnYO3O/YF6H3meFDzT9FAJbZAgLCfhFAtUKdgofv12uV1rpTcFGY6CTemYXNtljXoXKE9s+3E4OebOtrbJ3qhUN/8lYYxKoCPk5R6GAf+ioTa8Y8x5fQMCShZyznjw1ssIviA/KASet+5TneJh4MBcNMPbqgXLd5RV+L5SLkiQzZFzI2tKpaNL6L0MnUDZzb9DDK14D0BTpiwcNb6+d/5HaR7rpfzNrx/hrJe9oXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/+biABVqal2H4180pM3lIQR+G/s86S3C93qa1zdVSY=;
 b=KMWmTZ+2afreImAnI2EOH5wvI3veMhEejFVbM/4QrcOu/Qn8SiILYLq3bP0FA/buxnTpMuxDOj08ds0j+FFumTfIzIx1cgQjNOuf4iYeCRX3c3g2UCHbImKrO0kw6SPDqeZYMgTGho+nlGc5LkQFL/QVYISZWlgA2kxUT2LAyEsf/ORBe9IDs35puZEP7PKwDfNA0gBxeTH74j94NAVwGu1OC5r1629hQ/GwLxPeMiO38X1jYOhKcc3zeWQWKBeRMzr/UOxE5QE5XkYbqvRE2G7yH+twnfgLfWvT4OmDNrOsN2PYki5uzdoS50y4jtyLVgzTTwSq3XhXX4eBFuhO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/+biABVqal2H4180pM3lIQR+G/s86S3C93qa1zdVSY=;
 b=mrerCIRfBqPxD7UVBOHzJ+/liXweyx1LKJw88UlO2eIrvPiEUZMDOCEgg0bDVNz/iDKaOFBEVzrwis20b6iQ9oSKB/YkN4rQ9rdz5JKArSZnO0uCKxDCE7qOjRLmg8FYJkZs/8Obp2P9FXC4aWIIqWndm4OKJQLGi7J53Y6mlQ1jrPZqGm3DCp8oAtrNn4zax/sLm6SWJEcltisjiVHFUrLhU9XPl1lNrRn1p8S/7JBamoYvyfGsbKK4veb8qpKGpxffgYDK68QFpiEVlJEf3cfQ3dJOA6gBhcUutjY9xVC45ZLQzauaurLYvCPcq0lAzkvTFZINSqyhtOxyYKQlqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MW4PR12MB6707.namprd12.prod.outlook.com (2603:10b6:303:1ee::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Thu, 10 Nov 2022 09:08:54 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::fe97:fe7a:9ed0:137c%3]) with mapi id 15.20.5791.025; Thu, 10 Nov 2022
 09:08:54 +0000
Message-ID: <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
Date:   Thu, 10 Nov 2022 11:08:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
Content-Language: en-US
From:   Gal Pressman <gal@nvidia.com>
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
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
In-Reply-To: <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0640.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::21) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|MW4PR12MB6707:EE_
X-MS-Office365-Filtering-Correlation-Id: ef06a0f8-56f3-4ac7-4cf7-08dac2fb30e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoRCLDEKI5Xf47kSP4BRVt7v43rSMMri+ftUa9lhR7ACvx2yUQ6akW6KUErfeeya5Xet4yAz0gVSoUTAyxzXJQ/unxmGuk17wA55DUo1FfKApVlwWSgbDRa2zsveyb/Ejuhc+f73A/qMl5yFQkpGFiXwhieM6G9NbUPXzOPAGof3VsFw3aM3fBL1IRKNulZJvDVJj1ZRhIXGpqeEe0hj1h8JiPtfgooujoszrJNSGqDNlPvib2BYYccE6XhY5hetqaSuW6sqF7+Q9/PhRl7srIznjJOcG6z/+znVDp+u3D80VcTLY9NiyTWZtZ0c7fkONDPG3jYJ6AB2MPnedrZA0F4e0KvL8B7oStiitNaD3R8ajAXIa6aWYQVx5UIoKgufx9RmRUwVthZFH6FSMVohJRAJb30NEYWwAv0Yau1FVLIN52LL0dJqx4PN9Ypupm1g/YOgCdV0Ucjy+MfsagdoMy9eda8sj8mtvz62dehNgezhslhlsSp4xdCfqdwm1vETIYeI+6omR0+CRVoj8bpYMLGYD9SmoUphe2hr3vmI87dIwjUIgyGQsO2SjDIbqxbQzWJ7dCEkUv3r3UQaYGxyV0TQePXtAp9oITiL0ehKD9ipljKaJ+xFghzOZCOaKQzLTEDPDVBZuPnTOJFNJGqkkNIrgzs5muGFaT3LsuzMHETKSdSD352sOzDqyXdOx4atYJ/AA7Nhns9YXstTffHWuGAw+eFPojsVtaxKdOnS9UcxMToDCfB5rqgPiwIJw+EeNLzWbli3ohNc6xLYVJHBjUt5QE6XMBDmuytld1nt4b8SF/7PWnXDZh5QTkokGni2ZTy0A3M8jJKd3vsv+FM9SoG38yoj1Hii3fBx/sL6N5hcXQDZyHy8/tG0vsbvPTNn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(451199015)(966005)(2906002)(6666004)(186003)(66476007)(478600001)(6486002)(38100700002)(2616005)(36756003)(54906003)(26005)(53546011)(6506007)(316002)(110136005)(6512007)(31696002)(83380400001)(66946007)(66556008)(107886003)(86362001)(8676002)(4326008)(31686004)(41300700001)(8936002)(7416002)(5660300002)(30864003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R21sRHRpVG55VmJvazRwcW8rS3VwRmFaenJSV1JCakZuODlBUnFSQU5iRDI1?=
 =?utf-8?B?U2l2MjIycE0xU0drQVNRSWIwdHFWb0xtUkhtbVBBY3JiY2JZSGxmTkE3M1Y3?=
 =?utf-8?B?RHdESzNmSlA1dElTczdaYjJVMzlFSmkwbURxOUh1ZlBBb3hmQVlzcWpvN09n?=
 =?utf-8?B?aEJ3Q1dLcDEzSkx4Mm1acXFkS2NGL2x6SGtYODRQS3p1akptanE5ZGh0bi80?=
 =?utf-8?B?OGJqWTg0ZzQyYy9DdkFlZG1hRkZkU0tSTS9abEREbVVHS1hVenBlK3B0VGpT?=
 =?utf-8?B?OC9RMU5NYlE3RjlUMmlaeFR5dE1NeC9Ra01DZ1NMZ3EvR1BQN0NyMkN4N0dN?=
 =?utf-8?B?NWxUMEYwcThPZ1J6NXZPR0NQT1AxZ3Z4ZmtNY0RsWE1wcDZ4NWpMYWpsMDBp?=
 =?utf-8?B?eFJWSitaVXc0VzNVYVpaYko4QlIxQ0hUTG9sOFJGZ1pBNmNLNEMzcWxVOC9u?=
 =?utf-8?B?djkrZ0VVSzEwc3pCTlp5UldWcy80MWNXV3VOLzlnclE5NU44UmxEL25qbkc4?=
 =?utf-8?B?NTJHclhwZlpqazJYdkFDRlBsWXRkT3pwanRUZGVRbFZJdXIrUFByK01mVWlD?=
 =?utf-8?B?a3hOc0ZaMTRKSFJZL2duZi9Ka3VMVURvUGkwNm9DeUF4ZHRoZE5SSkRuMzNS?=
 =?utf-8?B?YWVjbm9wL2xTdU00MDRnTkQwM09jMnoyc3ZaanpPSnNlZ25aL3lUT3R5MHp6?=
 =?utf-8?B?enJoQ2VyaWlOK011V0JJN0kzOWpHek40UnhCZEloYTJsSWZoOFhHVkI2MXFi?=
 =?utf-8?B?a2lkdklxN3o2bjNudWY5UkEzZDZHRnZmODRxMXdTbXF6ZDVnbGFGTDZOZTV2?=
 =?utf-8?B?ZlpRbzJwaVJKcmJFUHZqTDZvQnF0M2lxQkZXSE5UUzRTK3Q5dnNrV1VvSmZv?=
 =?utf-8?B?RDcwMGxhamJFT1FVaHIyVHhBbVUvcVpvQzluUUJYWW9aNXF5dmdTUEI0eVF4?=
 =?utf-8?B?L25XOFBETEVtdCtjYlUrWkNJN002OVdmRnQ2cURYWkRpdmNUaUhXNTVYN3ZC?=
 =?utf-8?B?Rml3d0lSa1JVQmpYVkwvM0l1UWhQL2VDSU1FNUFVMjlWeXBYa2hQeCtmYTlM?=
 =?utf-8?B?YXhweWlrNEtRWWpjcUxRSW9Ieml6bk04cXN4NVJEdGgybFdRWURxeE1vSUlU?=
 =?utf-8?B?a0FsNXRoZkNTeTBhUEJVUGpITEx2NGpxOWphZnVrdE1ibHU5aHBhd1dINXJP?=
 =?utf-8?B?MXlVWnlHWjg0aWRDRFhuV1NwLzc0UFZvMWhrdWl1bjNaRnk1dFFVTDFlMk9V?=
 =?utf-8?B?QjhVUFNIeHNXTm5kbkJGcnVkMytFK2xnZFJDUHpQbkNQYll3RktYWXZybnc2?=
 =?utf-8?B?eGYwYkN0T1BCcmhHb002V0pZdnM3RW1MU3c3OEVBOWVzWlkzRkhCNWw2cFR3?=
 =?utf-8?B?V1g5MHBaVk9ORy92MlR6N0ZvN2xzeGdxK0FKc1JuTzZBUnphdFV3MXplM3dW?=
 =?utf-8?B?a3FydUNLeC9CQmNvVWlzTnNjTzJXS1dGR0tBUEs3RkgydVBaSHE5Rk5hVmlC?=
 =?utf-8?B?RjNVRFlvd0ZhdUdWVFZmenZpOUxIamhiVll5eUx2d3RWZ1ZYZlRQTjM4ZU1z?=
 =?utf-8?B?YjZQQVdmWCtXU29qMUxEVHYxRnNyNEhCMGJqS0I4SDJVbzd0ZUc3MHQ4cW9O?=
 =?utf-8?B?Zjh6ZDl6QXNPS3FkbVIvdXY0Q01RdWs2cGlha3BYN0VqcXNFS21iN3k3WVJN?=
 =?utf-8?B?ZlJobUhKY1ZRNVJIWlBvczVKUHEwOWRJWXlOVzNhN2x6T1Q0RHVuN0lyMHpU?=
 =?utf-8?B?UkFLb1Y5V3NPSy92bXFzYnp3MHJBSEJLY0FraUFjTVk1d2hBTitaUWJNZlBJ?=
 =?utf-8?B?SHZ1VC9LQk8wK3lMbXBXZTZ3R2hOemRUbEZOdGl2cEpVVjlRcFpqbzZ4SG9h?=
 =?utf-8?B?aEhMcjl0MTNUNEhJTktiWXpQOGpJVU9GOENYckVNVnJWaG4rTkFVWWdwQ3V4?=
 =?utf-8?B?d0w0M3BRZnBSaG5KSDRjcDBTZ2FrOEJjNjJubE0rU0UxekJ1NmRlRzB3aGJs?=
 =?utf-8?B?S0k3VUZKMWNVMVh5YzhCTUZTQm9Xam51bFNlTEdpaGVSb3FuWFFpVlJweHJV?=
 =?utf-8?B?MzdHcFFuV1BZd2ZKRnFZelV1MkxMb29KRm1KRWo2cDdZYlFjRmtCOEpUcDhF?=
 =?utf-8?Q?1gqwIeEIcciQ4v2K/KgwKa9ju?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef06a0f8-56f3-4ac7-4cf7-08dac2fb30e0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 09:08:54.1275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qzmTuCCsxTGw2LQg89M3S1adVFzLj3gSwDZjjTrrF2pPQJpylFuHJc/CfWG6TeCj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6707
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/11/2022 10:07, Gal Pressman wrote:
> On 03/11/2022 18:33, Eric Dumazet wrote:
>> On Thu, Nov 3, 2022 at 9:31 AM Maxim Mikityanskiy <maxtram95@gmail.com> wrote:
>>> On Thu, 3 Nov 2022 at 17:30, Eric Dumazet <edumazet@google.com> wrote:
>>>> On Thu, Nov 3, 2022 at 8:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>>>> On Thu, 3 Nov 2022 08:17:06 -0700 Eric Dumazet wrote:
>>>>>> On Thu, Nov 3, 2022 at 6:34 AM Gal Pressman <gal@nvidia.com> wrote:
>>>>>>> On 18/10/2022 23:32, Eric Dumazet wrote:
>>>>>>>> We had one syzbot report [1] in syzbot queue for a while.
>>>>>>>> I was waiting for more occurrences and/or a repro but
>>>>>>>> Dmitry Vyukov spotted the issue right away.
>>>>>>>>
>>>>>>>> <quoting Dmitry>
>>>>>>>> qdisc_graft() drops reference to qdisc in notify_and_destroy
>>>>>>>> while it's still assigned to dev->qdisc
>>>>>>>> </quoting>
>>>>>>>>
>>>>>>>> Indeed, RCU rules are clear when replacing a data structure.
>>>>>>>> The visible pointer (dev->qdisc in this case) must be updated
>>>>>>>> to the new object _before_ RCU grace period is started
>>>>>>>> (qdisc_put(old) in this case).
>>>>>>>>
>>>>>>>> [1]
>>>>>>>> BUG: KASAN: use-after-free in __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>>> Read of size 4 at addr ffff88802065e038 by task syz-executor.4/21027
>>>>>>>>
>>>>>>>> CPU: 0 PID: 21027 Comm: syz-executor.4 Not tainted 6.0.0-rc3-syzkaller-00363-g7726d4c3e60b #0
>>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
>>>>>>>> Call Trace:
>>>>>>>> <TASK>
>>>>>>>> __dump_stack lib/dump_stack.c:88 [inline]
>>>>>>>> dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>>>>>>>> print_address_description mm/kasan/report.c:317 [inline]
>>>>>>>> print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
>>>>>>>> kasan_report+0xb1/0x1e0 mm/kasan/report.c:495
>>>>>>>> __tcf_qdisc_find.part.0+0xa3a/0xac0 net/sched/cls_api.c:1066
>>>>>>>> __tcf_qdisc_find net/sched/cls_api.c:1051 [inline]
>>>>>>>> tc_new_tfilter+0x34f/0x2200 net/sched/cls_api.c:2018
>>>>>>>> rtnetlink_rcv_msg+0x955/0xca0 net/core/rtnetlink.c:6081
>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>> RIP: 0033:0x7f5efaa89279
>>>>>>>> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>>>>>>>> RSP: 002b:00007f5efbc31168 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>>>>>>>> RAX: ffffffffffffffda RBX: 00007f5efab9bf80 RCX: 00007f5efaa89279
>>>>>>>> RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000000000005
>>>>>>>> RBP: 00007f5efaae32e9 R08: 0000000000000000 R09: 0000000000000000
>>>>>>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>>>>>>> R13: 00007f5efb0cfb1f R14: 00007f5efbc31300 R15: 0000000000022000
>>>>>>>> </TASK>
>>>>>>>>
>>>>>>>> Allocated by task 21027:
>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>> kasan_set_track mm/kasan/common.c:45 [inline]
>>>>>>>> set_alloc_info mm/kasan/common.c:437 [inline]
>>>>>>>> ____kasan_kmalloc mm/kasan/common.c:516 [inline]
>>>>>>>> ____kasan_kmalloc mm/kasan/common.c:475 [inline]
>>>>>>>> __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
>>>>>>>> kmalloc_node include/linux/slab.h:623 [inline]
>>>>>>>> kzalloc_node include/linux/slab.h:744 [inline]
>>>>>>>> qdisc_alloc+0xb0/0xc50 net/sched/sch_generic.c:938
>>>>>>>> qdisc_create_dflt+0x71/0x4a0 net/sched/sch_generic.c:997
>>>>>>>> attach_one_default_qdisc net/sched/sch_generic.c:1152 [inline]
>>>>>>>> netdev_for_each_tx_queue include/linux/netdevice.h:2437 [inline]
>>>>>>>> attach_default_qdiscs net/sched/sch_generic.c:1170 [inline]
>>>>>>>> dev_activate+0x760/0xcd0 net/sched/sch_generic.c:1229
>>>>>>>> __dev_open+0x393/0x4d0 net/core/dev.c:1441
>>>>>>>> __dev_change_flags+0x583/0x750 net/core/dev.c:8556
>>>>>>>> rtnl_configure_link+0xee/0x240 net/core/rtnetlink.c:3189
>>>>>>>> rtnl_newlink_create net/core/rtnetlink.c:3371 [inline]
>>>>>>>> __rtnl_newlink+0x10b8/0x17e0 net/core/rtnetlink.c:3580
>>>>>>>> rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3593
>>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>>
>>>>>>>> Freed by task 21020:
>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>> kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>>>>>>>> kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>>>>>>>> ____kasan_slab_free mm/kasan/common.c:367 [inline]
>>>>>>>> ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:329
>>>>>>>> kasan_slab_free include/linux/kasan.h:200 [inline]
>>>>>>>> slab_free_hook mm/slub.c:1754 [inline]
>>>>>>>> slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
>>>>>>>> slab_free mm/slub.c:3534 [inline]
>>>>>>>> kfree+0xe2/0x580 mm/slub.c:4562
>>>>>>>> rcu_do_batch kernel/rcu/tree.c:2245 [inline]
>>>>>>>> rcu_core+0x7b5/0x1890 kernel/rcu/tree.c:2505
>>>>>>>> __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
>>>>>>>>
>>>>>>>> Last potentially related work creation:
>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>>> call_rcu+0x99/0x790 kernel/rcu/tree.c:2793
>>>>>>>> qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1083
>>>>>>>> notify_and_destroy net/sched/sch_api.c:1012 [inline]
>>>>>>>> qdisc_graft+0xeb1/0x1270 net/sched/sch_api.c:1084
>>>>>>>> tc_modify_qdisc+0xbb7/0x1a00 net/sched/sch_api.c:1671
>>>>>>>> rtnetlink_rcv_msg+0x43a/0xca0 net/core/rtnetlink.c:6090
>>>>>>>> netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2501
>>>>>>>> netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>>>>>>>> netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
>>>>>>>> netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>> ____sys_sendmsg+0x6eb/0x810 net/socket.c:2482
>>>>>>>> ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
>>>>>>>> __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
>>>>>>>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>> do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>>>>>>>
>>>>>>>> Second to last potentially related work creation:
>>>>>>>> kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>>>>>>>> __kasan_record_aux_stack+0xbe/0xd0 mm/kasan/generic.c:348
>>>>>>>> kvfree_call_rcu+0x74/0x940 kernel/rcu/tree.c:3322
>>>>>>>> neigh_destroy+0x431/0x630 net/core/neighbour.c:912
>>>>>>>> neigh_release include/net/neighbour.h:454 [inline]
>>>>>>>> neigh_cleanup_and_release+0x1f8/0x330 net/core/neighbour.c:103
>>>>>>>> neigh_del net/core/neighbour.c:225 [inline]
>>>>>>>> neigh_remove_one+0x37d/0x460 net/core/neighbour.c:246
>>>>>>>> neigh_forced_gc net/core/neighbour.c:276 [inline]
>>>>>>>> neigh_alloc net/core/neighbour.c:447 [inline]
>>>>>>>> ___neigh_create+0x18b5/0x29a0 net/core/neighbour.c:642
>>>>>>>> ip6_finish_output2+0xfb8/0x1520 net/ipv6/ip6_output.c:125
>>>>>>>> __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
>>>>>>>> ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
>>>>>>>> NF_HOOK_COND include/linux/netfilter.h:296 [inline]
>>>>>>>> ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
>>>>>>>> dst_output include/net/dst.h:451 [inline]
>>>>>>>> NF_HOOK include/linux/netfilter.h:307 [inline]
>>>>>>>> NF_HOOK include/linux/netfilter.h:301 [inline]
>>>>>>>> mld_sendpack+0xa09/0xe70 net/ipv6/mcast.c:1820
>>>>>>>> mld_send_cr net/ipv6/mcast.c:2121 [inline]
>>>>>>>> mld_ifc_work+0x71c/0xdc0 net/ipv6/mcast.c:2653
>>>>>>>> process_one_work+0x991/0x1610 kernel/workqueue.c:2289
>>>>>>>> worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>>>>>>>> kthread+0x2e4/0x3a0 kernel/kthread.c:376
>>>>>>>> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>>>>>>>>
>>>>>>>> The buggy address belongs to the object at ffff88802065e000
>>>>>>>> which belongs to the cache kmalloc-1k of size 1024
>>>>>>>> The buggy address is located 56 bytes inside of
>>>>>>>> 1024-byte region [ffff88802065e000, ffff88802065e400)
>>>>>>>>
>>>>>>>> The buggy address belongs to the physical page:
>>>>>>>> page:ffffea0000819600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20658
>>>>>>>> head:ffffea0000819600 order:3 compound_mapcount:0 compound_pincount:0
>>>>>>>> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
>>>>>>>> raw: 00fff00000010200 0000000000000000 dead000000000001 ffff888011841dc0
>>>>>>>> raw: 0000000000000000 0000000000100010 00000001ffffffff 0000000000000000
>>>>>>>> page dumped because: kasan: bad access detected
>>>>>>>> page_owner tracks the page as allocated
>>>>>>>> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3523, tgid 3523 (sshd), ts 41495190986, free_ts 41417713212
>>>>>>>> prep_new_page mm/page_alloc.c:2532 [inline]
>>>>>>>> get_page_from_freelist+0x109b/0x2ce0 mm/page_alloc.c:4283
>>>>>>>> __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5515
>>>>>>>> alloc_pages+0x1a6/0x270 mm/mempolicy.c:2270
>>>>>>>> alloc_slab_page mm/slub.c:1824 [inline]
>>>>>>>> allocate_slab+0x27e/0x3d0 mm/slub.c:1969
>>>>>>>> new_slab mm/slub.c:2029 [inline]
>>>>>>>> ___slab_alloc+0x7f1/0xe10 mm/slub.c:3031
>>>>>>>> __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
>>>>>>>> slab_alloc_node mm/slub.c:3209 [inline]
>>>>>>>> __kmalloc_node_track_caller+0x2f2/0x380 mm/slub.c:4955
>>>>>>>> kmalloc_reserve net/core/skbuff.c:358 [inline]
>>>>>>>> __alloc_skb+0xd9/0x2f0 net/core/skbuff.c:430
>>>>>>>> alloc_skb_fclone include/linux/skbuff.h:1307 [inline]
>>>>>>>> tcp_stream_alloc_skb+0x38/0x580 net/ipv4/tcp.c:861
>>>>>>>> tcp_sendmsg_locked+0xc36/0x2f80 net/ipv4/tcp.c:1325
>>>>>>>> tcp_sendmsg+0x2b/0x40 net/ipv4/tcp.c:1483
>>>>>>>> inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>>>>>>>> sock_sendmsg_nosec net/socket.c:714 [inline]
>>>>>>>> sock_sendmsg+0xcf/0x120 net/socket.c:734
>>>>>>>> sock_write_iter+0x291/0x3d0 net/socket.c:1108
>>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>>> ksys_write+0x1e8/0x250 fs/read_write.c:631
>>>>>>>> page last free stack trace:
>>>>>>>> reset_page_owner include/linux/page_owner.h:24 [inline]
>>>>>>>> free_pages_prepare mm/page_alloc.c:1449 [inline]
>>>>>>>> free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1499
>>>>>>>> free_unref_page_prepare mm/page_alloc.c:3380 [inline]
>>>>>>>> free_unref_page+0x19/0x4d0 mm/page_alloc.c:3476
>>>>>>>> __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2548
>>>>>>>> qlink_free mm/kasan/quarantine.c:168 [inline]
>>>>>>>> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>>>>>>>> kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
>>>>>>>> __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
>>>>>>>> kasan_slab_alloc include/linux/kasan.h:224 [inline]
>>>>>>>> slab_post_alloc_hook mm/slab.h:727 [inline]
>>>>>>>> slab_alloc_node mm/slub.c:3243 [inline]
>>>>>>>> slab_alloc mm/slub.c:3251 [inline]
>>>>>>>> __kmem_cache_alloc_lru mm/slub.c:3258 [inline]
>>>>>>>> kmem_cache_alloc+0x267/0x3b0 mm/slub.c:3268
>>>>>>>> kmem_cache_zalloc include/linux/slab.h:723 [inline]
>>>>>>>> alloc_buffer_head+0x20/0x140 fs/buffer.c:2974
>>>>>>>> alloc_page_buffers+0x280/0x790 fs/buffer.c:829
>>>>>>>> create_empty_buffers+0x2c/0xee0 fs/buffer.c:1558
>>>>>>>> ext4_block_write_begin+0x1004/0x1530 fs/ext4/inode.c:1074
>>>>>>>> ext4_da_write_begin+0x422/0xae0 fs/ext4/inode.c:2996
>>>>>>>> generic_perform_write+0x246/0x560 mm/filemap.c:3738
>>>>>>>> ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:270
>>>>>>>> ext4_file_write_iter+0x44a/0x1660 fs/ext4/file.c:679
>>>>>>>> call_write_iter include/linux/fs.h:2187 [inline]
>>>>>>>> new_sync_write fs/read_write.c:491 [inline]
>>>>>>>> vfs_write+0x9e9/0xdd0 fs/read_write.c:578
>>>>>>>>
>>>>>>>> Fixes: af356afa010f ("net_sched: reintroduce dev->qdisc for use by sch_api")
>>>>>>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>>>>>>> Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
>>>>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>>>>> ---
>>>>>>>>  net/sched/sch_api.c | 5 +++--
>>>>>>>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
>>>>>>>> index c98af0ada706efee202a20a6bfb6f2b984106f45..4a27dfb1ba0faab3692a82969fb8b78768742779 100644
>>>>>>>> --- a/net/sched/sch_api.c
>>>>>>>> +++ b/net/sched/sch_api.c
>>>>>>>> @@ -1099,12 +1099,13 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
>>>>>>>>
>>>>>>>>  skip:
>>>>>>>>               if (!ingress) {
>>>>>>>> -                     notify_and_destroy(net, skb, n, classid,
>>>>>>>> -                                        rtnl_dereference(dev->qdisc), new);
>>>>>>>> +                     old = rtnl_dereference(dev->qdisc);
>>>>>>>>                       if (new && !new->ops->attach)
>>>>>>>>                               qdisc_refcount_inc(new);
>>>>>>>>                       rcu_assign_pointer(dev->qdisc, new ? : &noop_qdisc);
>>>>>>>>
>>>>>>>> +                     notify_and_destroy(net, skb, n, classid, old, new);
>>>>>>>> +
>>>>>>>>                       if (new && new->ops->attach)
>>>>>>>>                               new->ops->attach(new);
>>>>>>>>               } else {
>>>>>>> Hi Eric,
>>>>>>> We started seeing the following WARN_ON happening on htb destroy
>>>>>>> following your patch:
>>>>>>> https://elixir.bootlin.com/linux/v6.1-rc3/source/net/sched/sch_htb.c#L1561
>>>>>>>
>>>>>>> Anything comes to mind?
>>>>>> Not really. Let's ask Maxim Mikityanskiy <maximmi@nvidia.com>
>>>>> CC: Maxim on non-nvidia address
>>>>>
>>>> Wild guess is that we need this fix:
>>>>
>>>> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
>>>> index e5b4bbf3ce3d5f36edb512d4017ebd97209bb377..f82c07bd3d60e26e5a1fe2b335dbec29aebb602e
>>>> 100644
>>>> --- a/net/sched/sch_htb.c
>>>> +++ b/net/sched/sch_htb.c
>>>> @@ -1558,7 +1558,7 @@ static int htb_destroy_class_offload(struct
>>>> Qdisc *sch, struct htb_class *cl,
>>>>                 /* Before HTB is destroyed, the kernel grafts noop_qdisc to
>>>>                  * all queues.
>>>>                  */
>>>> -               WARN_ON(!(old->flags & TCQ_F_BUILTIN));
>>>> +               WARN_ON(old && !(old->flags & TCQ_F_BUILTIN));
>>> I don't think it's the right fix. If the WARN_ON happens and doesn't
>>> complain about old == NULL, it's not NULL, so this extra check won't
>>> help. In any case, old comes from dev_graft_qdisc, which should never
>>> return NULL.
>>>
>>> Maybe something changed after Eric's patch, so that the statement
>>> above is no longer true? I.e. I expect a noop_qdisc here, but there is
>>> some other qdisc attached to the queue. I need to recall what was the
>>> destroy flow and what code assigned noop_qdisc there...
>> Gal please provide a repro. It is not clear if you get a WARN or a NULL deref.
> The WARN_ON is triggering, old is not NULL and old->flags is equal to 0x174.
>
> It reproduces consistently:
> ip link set dev eth2 up
> ip addr add 194.237.173.123/16 dev eth2
> tc qdisc add dev eth2 clsact
> tc qdisc add dev eth2 root handle 1: htb default 1 offload
> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ceil
> 22500.0mbit burst 450000kbit cburst 450000kbit
> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burst
> 89900kbit cburst 89900kbit
> tc qdisc delete dev eth2 clsact
> tc qdisc delete dev eth2 root handle 1: htb default 1
>
> Please let me know if there's anything else you want me to check.

Hi Eric, did you get a chance to take a look?
