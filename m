Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E2A585CD6
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 03:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232779AbiGaBy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jul 2022 21:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiGaBy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jul 2022 21:54:58 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D850513D2C;
        Sat, 30 Jul 2022 18:54:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U7ru27KnmbVSL21D/vxUuMv/ubswHmt4QEb4rwurfWauUoWGNXQod4b9lCJRsJfhE32YHqj8p97qGq7RPf5R0JCY+g+clYFlUMRzKehyHukkthZ7Jh48RxciIrqCOqdqlbj73y9aiVidP4fSdRhYsgigMWtEWI9O1zxXlvkiEO/Y7tNdA755YECDySh2JJF77UqBAg5hsYrlZYy69qwFvU5lrnlclmiU4SwCG9/t/7j0BE1HDpQfn/6thj8P+3shUuDN+3ugFVAjBoe1XbhnpX5Q7W4uDsPL9F6xhIwyAA1zcMulm6LKOpXM8I9kAOG63+9Paw45IBz7Exh4Zj8A5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2YgmbH5KE5e9qKEnqQ30NYf3rYr8hEa0TLzm7/pBtKo=;
 b=EspcQYAk5hKjQxXoMgbNitVwNILacj0plnlBYt7ISqLEA+/xGQIlUm0RyhEb4ajQgTYCS/VmVWxBy79WzO0PHIKfVeZxFkT6ZdJ8tF54xg3pjAijeHujw1PnkxGJaDGDs9RBc7YTRoEIYEf8VgftqSJfMRHLYza+RqVf/5q4/FAR23rCRffAIjKeZYLsDh9qv8zSCFl1OzB99sISUyzgh5QY974dpo0OdMMXu/LhyhUJOntZn0WxQ+z2J6Dv9Z8AatTOB77arTBeTPpIrfkV368QeuflDXVwdzDj6RBgeFLMsGe2H8m0aDYJ7GZ/uMLEVMpdvzQW6CNu41YQqx0C6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2YgmbH5KE5e9qKEnqQ30NYf3rYr8hEa0TLzm7/pBtKo=;
 b=pvTmxd79caN2M3SXXrbHsZmyR1SEvg56OWspn3m4arEPeTTqmXJbfofrjVC9g97tN6eDCW4woEAiHzhs7p1m1403stvGNpMevlBQSWzxY3FI+yb2lJY2pVvXboPyJ+e3uRFPuYdwgLRDLILmcDJ61PVtEz3YjM/wF0FnMxO7p4GMfu8y55ZUylkuiIevHjMbDljN5td2i0iNl9YIM/RLJ+LNpsLtB+BGgNIgJAq+TCpvK53RK2JU+K4DwZ/Tve3/YWJI0rInkC87TSXg23EeVTa0McWi/UbG+4qk/mtGsvXU7yq8aeJiemrFgK5bfp8cmAFwOB6lfyI8w8ka3rZMMQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by BN6PR12MB1716.namprd12.prod.outlook.com (2603:10b6:404:104::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14; Sun, 31 Jul
 2022 01:54:54 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::c92d:eecd:812b:b40c]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::c92d:eecd:812b:b40c%3]) with mapi id 15.20.5482.014; Sun, 31 Jul 2022
 01:54:53 +0000
Message-ID: <8e0a0ceb-5816-60a6-6219-7306e75ce006@nvidia.com>
Date:   Sat, 30 Jul 2022 18:54:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 0/3] net: vlan: fix bridge binding behavior and
 add selftests
Content-Language: en-US
To:     Sevinj Aghayeva <sevinj.aghayeva@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     aroulin@nvidia.com, sbrivio@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <cover.1659195179.git.sevinj.aghayeva@gmail.com>
 <f7ede054-f0b3-558a-091f-04b4f7139564@blackwall.org>
 <CAMWRUK5j4UAwjw4UGN=SVbbDbut0zWg5e03wupAXCPwT8K8zzQ@mail.gmail.com>
 <CAMWRUK5TZ5iZWZJO7Bbn-b43ZbT7mRzUDr4LdseLCne8qvG6pw@mail.gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <CAMWRUK5TZ5iZWZJO7Bbn-b43ZbT7mRzUDr4LdseLCne8qvG6pw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::15) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 265bfab0-9b6b-4ddf-2365-08da7297a998
X-MS-TrafficTypeDiagnostic: BN6PR12MB1716:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GcI1WHxbBobb81EQEiK7xXtF3bYxFf06vsMFssjqInOIMKEDh9kQc4zwUv29aARd82Jk5fBvUTFQW4/USCF2nCB2gbr0ggB7UUjut4S8KnmCNRstF7sBK9yubPm+3QKK51OK68uVLDOD57Xu70iyzXDaOFjYGpJKwghZTQHs0MyXhAavKQzM73YfI7KXy5r/xzVlFLEuIkQSMo6CGvLdaP4+aHCSwP2qWgU/xU2W3RQvVrTB9BX8//Yo/+Ih414Wjtz07/cHAYU3bYkJx/3SeshDzHpnUtTCJgf513ChpPPPi6kvQ+/ejIvL8e1h9iZQNPyAyFaTdlMItTiQ5eUfRxyuLfbvOV2q96hZPO+ilSwTPNqBKhNp92exR0OZMjRlb60TsRY9QsbToiZdSaiUl3U6mMRqaHnfdxchjPA/w6UeNCBS5ie+2F3CMilt0UDP736kaTrbLytgArryOnCd/ydnqo2d3lzCqBGnIK5p2ZXo8A11LTe9tcmZCUDp1D5wFfCMLUyQKM7oWgC+/BX7jRUWKgpAw18kC9OL+eBGcK58aPfbaeHv+IxGKdCuvGGe7d9GEVsUZ1RKMrwpzf0aP9CZ2hCc2m9RDNnpwJadO3CXluesg3psId0x4vfjeqAo/ziHCl0Sml0MKCDsytslWtDExLtiCM1AGb1sbIPYRGkbsPZKnYXTOvqz1GAaup4Xg0+VFt6m0WkEeiBBzn6aZfCCLmDdVQNDQl4h9TrpdyjWZ60EH6KrvDFKNKjwVbihAmLGFtIZ2AmpdE+74uBaec1lMNGMvVnEJpfV95ElNXMcuYB1Xk4DUCNKWgx6C7+Row8ekZ4J0Wpj4CXDvFhomA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(2616005)(186003)(53546011)(38100700002)(83380400001)(66556008)(6512007)(5660300002)(8936002)(7416002)(66946007)(66476007)(8676002)(4326008)(2906002)(6486002)(6506007)(478600001)(41300700001)(316002)(54906003)(110136005)(31696002)(36756003)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0tYTGIzL1c3VG9FVzF5dlNlVldzcDNGdENaYlNJKzA5ZlZmaTNRMG5xRnNO?=
 =?utf-8?B?ak5KREN0MC9MTjNWZmpSNkw1NzJGZlljS1NIK2xQeTFWbC9MTTFrT1daNUVp?=
 =?utf-8?B?VXhWcGlML2g5VWVkcE9IVnZoZ3lBd3RNQUNGazB6NVdSVkJrWUczZVpUSFpH?=
 =?utf-8?B?WDVDRVU4MEwxM3ptYW5TOWcvK25MRDhQVTJxaGgwWlczRE85WitnNkNNQ213?=
 =?utf-8?B?VWR3RSttWGFDVWFWUmRCUDlLaktBeVErdDFsYWE0N3VnUmZCV3kvaTNVcGQv?=
 =?utf-8?B?SGRPRGNyMnF6NDd5alJsbEk3K3p4Z2d0SWJWTERPOGd6RGwwSlU5eExCVVFM?=
 =?utf-8?B?WmQwcHNSV3VPWXc1UzdvRm5XLzltN3JQQnpBcUdsRVBuM0orMDlGY0l6YXkr?=
 =?utf-8?B?UGo3amhDTkRVNnZDb2lHc0ZRVjJOcmpwcjZaQkVZeERyYUJSRjFGSGxXSmJ5?=
 =?utf-8?B?dm12TC9ObW5wYlo5SmtUYmYzSWhFSGNZRDVvWWpDcjBMU1VBV3ExR2xVdXJh?=
 =?utf-8?B?OXVkYzQwOXUxb0Y5UW5oWE05MThMSjFBWFU1ZGVFTFM2cTlYSW1zbzg3Y1da?=
 =?utf-8?B?aUI5M3d1NDVlenBMcXpINmRmcUtVY2lIVVdtTHVpeTF4L3JZaEJkdWpIZ2Vh?=
 =?utf-8?B?RDBxc29ZaDdVaVlwV3hmWkJiQjhEMGJ4Umx0SGo0cmlUVXpoY1U2RXd4WE9I?=
 =?utf-8?B?T0o3cVQ1M0hDWkdja21nWmhRckFHeWtrc0xCTEZHalNoeDhYTUk1Zk9YVGF3?=
 =?utf-8?B?K0c3WXUwMUFGRU1ydnl1b1hLV3A2TlZEMHp4bEdJeEFrcHBZNmpVbVBkMVNZ?=
 =?utf-8?B?ZnJNN3g1aDFPZElsTTQ2anh6cE9SeVpLS1hPWTB5M1Jtd3lDZTV4RTZPOW4r?=
 =?utf-8?B?NHNBWk11b3ovY2ZOaWIyZmNmc2d4QlluRXVIcG11Z1YzSXVtVzN1OENOdDNv?=
 =?utf-8?B?dFJ3VzRQSEhvTTFaVXhQY1FiN0FLZ1k4cElVYkJoZGtWYktJZ0R5aVBHc2E3?=
 =?utf-8?B?cDRkVTR3cWVib2svMUFVd3hlb0tpQVFnRjE1OVVZZGljWU5lTEg4bEJoWWtV?=
 =?utf-8?B?QjNwaXNZL1FDN1o4UHVpU3JrOTIrZWpKRkhaVHpkZDBQOGZiUnVjLzQvdTJK?=
 =?utf-8?B?SFZkRWtIK2hFS0dFeGdZL3A5MWVvSlNZajhLVVhLWXVoTDl2UVNRWEl5VEUw?=
 =?utf-8?B?cUJvckQ1cVdPRy9tOFpiVVVzc2ZaemkrZ3g2YUJtZ2U4ZEhVR3E3d2tKamRk?=
 =?utf-8?B?VU5DcW9OY0NMUlliSm1uK1hkZyszTmxITFNtUXN6aUFFUGNoNTVvTHRIWkIr?=
 =?utf-8?B?RC9lUWNUbmwzRkM5R0JLU25EdmdBYzlLVWxlaUNONHR5Y0wvbDl1YXFqVjQz?=
 =?utf-8?B?SkovZUJHRjE5SG1PT3l5MFYrNjlnK0MvV3gvdVhlWEpJT01tcXdmWHBMQ3Y3?=
 =?utf-8?B?Zk5sSFBuZkpKUnFibkYvaThmY08zMENRYTI2akpTTml5WDhFbFhVbzRHMTFN?=
 =?utf-8?B?VFFVZUdBOGQ2MG55MHdmZGlZSm5PWXhSb0Rlak1IYVhFNCtKbmxkK1RCV2c4?=
 =?utf-8?B?QnFiRUtkQTJHeHlsRDQ2ak1wTy9td21aNUdEQ2FCQXRRb3BQU2VOUlJZTXBZ?=
 =?utf-8?B?TVNlNXo0YWR0OVVCTFUrQWRTTlgxQW9xRFA3K1FLQm1xZkdPZ1JLUGwzdnRY?=
 =?utf-8?B?RjZUY0k0UnBsVG1vMUc3Zm9sMk1sQnRzOGdkdk5kZVBXZ0QwMU9EUjZEdmNq?=
 =?utf-8?B?blowVjdPa0JoaWRPd05TbDNSNFA3emNwV3drM0prcjVma3NUUTNDbGMrQ1J4?=
 =?utf-8?B?cC9za2x1bWNmVDR3dHBjdFFXSll2UkFOcjZkVSsxdGJzZDhIaUJDSWIyY1JT?=
 =?utf-8?B?QzJJZFlkcWZOc0lOV1ZlMzFJRkNCTkZRM0VEd0hPenAyR0M2VTh2VG9xZkVW?=
 =?utf-8?B?VGladXhzeWlUcEF4RE81WnVIOGlPbGdicEFXTXlCOXAwZzVqYkhxWXphSDEv?=
 =?utf-8?B?YWhvNFc3UStlRDc1cTlibTJwOTBTZ3c1R0RRaXRFVVBiNW1oQjZkdTNBbVRy?=
 =?utf-8?B?RWQ1RUh0NFlvNHZnKysrUm55c3hiblF0TnlGS25YZkxvS2RVOHRBeThxU0ZX?=
 =?utf-8?B?OWxEMDVZaWpWR21mS3Bqa2xPNkN2QngvTmx1MTVUZkIvdzhSZ2RlcXFrcnBW?=
 =?utf-8?Q?+rJJaa0b0FfPiEEarJ4jL4qLgt/NmOJo24euaPiSTj1B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 265bfab0-9b6b-4ddf-2365-08da7297a998
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 01:54:53.8700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bu3JVZsj2zU/xuNxPMaNq/DRpiSUjDo8a/sqecUEP7ZlpTSPg89CaiMx5wlKpzb2ED1hkAt5Y1t7Jb2cq+XAKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1716
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/30/22 09:48, Sevinj Aghayeva wrote:
> (Resending this because the first email was rejected due to being in HTML.)
>
>
> On Sat, Jul 30, 2022 at 12:46 PM Sevinj Aghayeva
> <sevinj.aghayeva@gmail.com> wrote:
>>
>>
>> On Sat, Jul 30, 2022 at 12:22 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> On 7/30/22 19:03, Sevinj Aghayeva wrote:
>>>> When bridge binding is enabled for a vlan interface, it is expected
>>>> that the link state of the vlan interface will track the subset of the
>>>> ports that are also members of the corresponding vlan, rather than
>>>> that of all ports.
>>>>
>>>> Currently, this feature works as expected when a vlan interface is
>>>> created with bridge binding enabled:
>>>>
>>>>     ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>>>>           bridge_binding on
>>>>
>>>> However, the feature does not work when a vlan interface is created
>>>> with bridge binding disabled, and then enabled later:
>>>>
>>>>     ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
>>>>           bridge_binding off
>>>>     ip link set vlan10 type vlan bridge_binding on
>>>>
>>>> After these two commands, the link state of the vlan interface
>>>> continues to track that of all ports, which is inconsistent and
>>>> confusing to users. This series fixes this bug and introduces two
>>>> tests for the valid behavior.
>>>>
>>>> Sevinj Aghayeva (3):
>>>>     net: bridge: export br_vlan_upper_change
>>>>     net: 8021q: fix bridge binding behavior for vlan interfaces
>>>>     selftests: net: tests for bridge binding behavior
>>>>
>>>>    include/linux/if_bridge.h                     |   9 ++
>>>>    net/8021q/vlan.h                              |   2 +-
>>>>    net/8021q/vlan_dev.c                          |  21 ++-
>>>>    net/bridge/br_vlan.c                          |   7 +-
>>>>    tools/testing/selftests/net/Makefile          |   1 +
>>>>    .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
>>>>    6 files changed, 176 insertions(+), 7 deletions(-)
>>>>    create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh
>>>>
>>> Hmm.. I don't like this and don't think this bridge function should be
>>> exported at all.
>>>
>>> Calling bridge state changing functions from 8021q module is not the
>>> proper way to solve this. The problem is that the bridge doesn't know
>>> that the state has changed, so you can process NETDEV_CHANGE events and
>>> check for the bridge vlan which got its state changed and react based on
>>> it. I haven't checked in detail, but I think it should be doable. So all
>>> the logic is kept inside the bridge.
>>
>> Hi Nik,
>>
>> Can please elaborate on where I should process NETDEV_CHANGE events? I'm doing this as part of outreachy project and this is my first kernel task, so I don't know the bridging code that well.
>>
>> Thanks!

good point Nikolay.

Sevinj, see br_vlan_bridge_event and __vlan_device_event  for how both 
drivers react to netdev change events.

I have not looked at it in detail yet, but lets explore and discuss if 
we can make use of events to achieve same results.

