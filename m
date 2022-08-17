Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B00A6597A01
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 01:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239327AbiHQXLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 19:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiHQXLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 19:11:48 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2139.outbound.protection.outlook.com [40.107.20.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3264ACA02
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 16:11:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YnUevxJyOVOYiAxn8dsHdC+be4vjNQQBtgx3ZjTpm2eEeWNj8hiQtZTfUlEQyJPHFE1/tJtcA3lRMfYN7IDHPex8b2sR7IDBDV2j/B8yWVUyK3acINWfGEbuI9ynnnANIc17ddPV6kvfRlErhkz8qKStJCk6zWr6/4c5CJIUyjXJ8PnwJkItKCF8anZzNAc7JMtFPSwT2WP1Q6KDRuDI+cj8mB8F3wGE1SlS3jN+zft6YRUSwSZhTtcevlH1OcBKKw1y9cf0GjGPan/eq46d1SuoEhigxhf+7qQ4f/RTN1/ZSd6PtRXr3+msSPMW30ueuA9bDDBulfCvOv8fw4m1vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UC06HUhWx6Xk4Z53MhT6L+FjxaOzvrtqaKm4ADlRlpM=;
 b=VYzbpgATk6kD6XwpmxI1e2S6Q7ESf3cy380HL75DeuT7tFMFx8P9OvqPOXkdKlVlS5xEkOWpdxY5C3nxiaiwQax2GjyOESWEx7ibiozLuWND9WGt/qvHDcj/kgeAhRvoBvynxwUBkUZcf9tF9FW3FYeuUUFUqadLYl66DWqK6ByLA4SzIlLXAgcEoRROlX5IagordMd4VkMe+zW2jb4XJdCXNhVy1xUk5h9wNomZdTM+6TM4xARve71JeXewIdpGUORbWKfz8PX30XkYI/MRU94LT7vd8s0IhkRG0nf8XssZ4nuF1A6g57KOXoP2P/WQXXC28qdOY5bWQ0O37GlkrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UC06HUhWx6Xk4Z53MhT6L+FjxaOzvrtqaKm4ADlRlpM=;
 b=X46Cza551IhjglOIBTLvI+lAs25ij2q+5LkBhEu5XPHv68kw9ywDciOUIUPIe0aXCTjyk2jjBuRVJlYLFTv+jZKBx96uUb+qDVWt9ugprB7RxKMKMGnG5cDgoWJv5jeB5C3pzgVKRJnge7oUC12E/sZpETrLj5gqxynhPwCqIyjJJNo0cWG7wne/nriNysbZtTwiMzSCm17wSao4byE3VKL10ezoWjYO9au10LfA1YN9WhTP1SW++nAjIqLlj74KSakQUe+wEFIuKM9ZNaVbhTlpWnz0wxf/EVCoFdoTOQySeLyWusZmX7ZIQF8e8Y7+8CbpmDRrl7fnq2N5D7SrLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by AS8PR08MB9044.eurprd08.prod.outlook.com (2603:10a6:20b:5c0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 23:11:39 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4%6]) with mapi id 15.20.5525.011; Wed, 17 Aug 2022
 23:11:39 +0000
Message-ID: <7365e0a6-a82b-c92a-137e-f28111a9c148@virtuozzo.com>
Date:   Thu, 18 Aug 2022 02:11:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [ovs-dev] [PATCH net-next 0/1] openvswitch: allow specifying
 ifindex of new interfaces
Content-Language: en-US
To:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Cc:     dev@openvswitch.org, brauner@kernel.org, edumazet@google.com,
        avagin@google.com, alexander.mikhalitsyn@virtuozzo.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        ptikhomirov@virtuozzo.com, Aaron Conole <aconole@redhat.com>
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
 <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
 <bc6f197b-37a5-89ea-1311-16f93b5cefed@virtuozzo.com>
 <495de273-9679-5186-3d6c-41f44e9280e4@ovn.org>
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <495de273-9679-5186-3d6c-41f44e9280e4@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::15) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1c35dbb-d219-4da6-cdde-08da80a5d708
X-MS-TrafficTypeDiagnostic: AS8PR08MB9044:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6wYhw8hlHGlDN4GFZusfh3Wl2rvPeD4roSMUrBJUNHjh9kxoYpUlKeAzHn8DJ0aNDkEb5sDziPEVwFkGpfo4H/sqBz5+lgD3fFrPvoGN4ufaMvFSzaEPYEnzMztJqrIKjhZOFQ/SaLoC+ciAkKZk9JPlRb0RLZqi43JVem39s1GXMI3cr0L8Y6fSyERhmEZM5el8lSZ8iXyHxnJmU7oDjZtX3S+BQbGRzDCEUWJBojPIqFoKdQ5qlWKD+pjJQ11s1Jrk7KbWz696XpscyS796AVAH0PNHA3hMSSRT5Q9xJp+42NrR1FrQVGEmRbfjDcKsE5xPRiyh/Pso/avlD6F5pyGTRZZZUvCBN5ytGKIFplLM4cU73hTEOEpxY6fmYzO2pVLSu3fPjVZccF7On1qQoEPxUHE3Q2KHdu+aa6Jr2P0ZGhKE7r5GSQpYxd2lSvk1Gzfqg8EQeyQEGeYoAk4UVtomwITcYUyxHUgeiHRQBccs42FhAnB53QW9BROCeOZWSQqCMxtwKhLVlgqKAywOhlOHrRCGbMCmzWXrat6yNJS87BP07NPMcJtwpEUnGMprSlcwGv4hQl5t4ulPh0ldcMkEZGK/OUrF2xDujLAtPk3mO/QqKSKDiUu1fYwbF1v9MreZOIejnZTFxBTCvxRR6us39vr31t9AnEaYaisyXE79i5wnPCbMU287DKlXuKfifhtYdZCL18nGeK7CZbqpp9zpduTv6/ouKLwTQdp1NJWWadbi/fn/1CVKn5Hm+0kvyn503OPDuQ1ufJiqpxp9z9XPAjo2AaEJp2MynctnYzVpclkBq8hoate2D5ANlMb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(396003)(39850400004)(366004)(136003)(36756003)(41300700001)(186003)(26005)(6512007)(31686004)(2906002)(8676002)(316002)(4326008)(66476007)(66946007)(31696002)(2616005)(86362001)(44832011)(66556008)(38100700002)(53546011)(478600001)(6486002)(8936002)(5660300002)(83380400001)(6666004)(7416002)(6506007)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akF2SGZXRS9xejJtSU9BeDkyMUtpWUx6RlZYY3pXSFRucFEyNTZ1ODB5UDJT?=
 =?utf-8?B?L05aRjJNd0ZYVVVrajN0MVV0S1UybFVaWjU5MFJUL2x2aC9YaGtRdGx2ZXJL?=
 =?utf-8?B?TVZwUlB1aVlEdHFuUk16aE83M2lVOWRqTTZCcWFHTC9DTjlUMWNTb3Z3RDV6?=
 =?utf-8?B?SzFjRERoVHZXNlJPc2RadVV0d0lKZUtWVWdlSUIrWSsxTklLTlhPWU5ZVGM4?=
 =?utf-8?B?QllaT21sajN0TktBa3ZnaGREam1nNlRQb1BYMjFuMkQxRzlLOXhVV2cxK2JD?=
 =?utf-8?B?cDVuRHdWTTlmbUJvL2prM1JuR3JRaWZGSWMvYTJPbktESmNlZWlBUS9EUHB5?=
 =?utf-8?B?Um4zTW1Eb1NHaVE4UEJDNWxRTU9PSjVnTXJiYzRldFlqc0NGSlB2QkVyL29w?=
 =?utf-8?B?QkVEUCtkWWowREV2a3RxMzcvV3U2ejgyQlFOY0hnYXlrYm9qdTVqWDdJQkhL?=
 =?utf-8?B?UFNERStyNWJXS0dHT29WWHhKeTFzV2hIOURGS0xFT2hHUFRWbjBsSG9NMkVD?=
 =?utf-8?B?WnJDcE0vTUs4azBJTFFWLzRzZjRheWt3V3liQzlmZy9rWFZZeEM4Z2h5UnM4?=
 =?utf-8?B?dUJCMkZnTFNlN2VkK1ZTL0lNbm8wdDV3WXNXRHBtcllLdm9yOXNQUjRUbW1J?=
 =?utf-8?B?UWczTU16RytNVWVGN1N5K1dwRXF0VzcxZTFkS29JQWhGYkxUWW9RbTBXWmtQ?=
 =?utf-8?B?R3NqV1RITFU0QW1pS004MG9oKyt5KzNGQlRhR0FwSjM1U1I5L0FEa0pURVhH?=
 =?utf-8?B?TnZ1RWlnekJNY3Y2M2lReWhEMStKSm1mY0Z3djZhRi9WRVpFRnBjZE44V0ZO?=
 =?utf-8?B?ZHNEam9xZ2U4aVdmS1lEODQrL093SEt6MGlmcnRSUzZOTGNoWWZQTk1tYmdT?=
 =?utf-8?B?WGZ3cmM3TytKZlBDblUydkJ6KzlPVUdLT3JRQk9rTFliaVMvcnQ2N3dGZUc1?=
 =?utf-8?B?SXB1am1BT0RCNVVIN0c1SGlRcHR3MmNyTEUzWVhBYUQ0RHNuSW80QUZYQ0hF?=
 =?utf-8?B?NndpYXZZY2JMK2t6bXNQRUhJYXo0ZXZtYWFjb3poQ3dSdi9kRjUweUJwNHlO?=
 =?utf-8?B?KzY4cmNOeFRlbEJIc2pQTGhuVWlBcHp6OGIrSDhEMnhubHU4NzNMV0tMaTZR?=
 =?utf-8?B?S2lueDlXRHN5SWxQM0Y0RVNydy9RbXllQzRXdk5RNjRmWGxPWjdhbGo2djdD?=
 =?utf-8?B?alM4eXZLbE9wWUtVdnFFdXJsd2l4M0VuQTI4WTc1NFlUdWViaEJzWWRLYmsr?=
 =?utf-8?B?cHVja3M3dnRndE01UGI0QzBkOHVFcmxMWnZjbDVLZzJZS05CeUVrdEg0UDRs?=
 =?utf-8?B?Q3VDWnBwWm5xUzNaMkVMV0xmdlB5aXRCdForMm5sdnl4ZVMxbi9XQk9HTEdw?=
 =?utf-8?B?SWZkckMzaXo1Q0E5N0lzMHRqR3JLbCtmb1ZRckRDK1VLSTBUQ1Q3bFFmVHJl?=
 =?utf-8?B?NStCdHg4YUxsNHh5T09CbXA4Tm4ySzVPNGZxclZocHlUSmN1cFBaOXdrYURX?=
 =?utf-8?B?WmxQS3RHMzI2dnEvWlhHVFIxa2JTd3NDcDlkcFY4OVh6T3ExRkxHSWYwZTFV?=
 =?utf-8?B?anBnakFIa0JoakdyVE5NWGo0dDJ0L09yay9KT2xWN1JGV3duMmhXdUVMYlo0?=
 =?utf-8?B?VUNrakJ0SzU4YWVxSTNpeGRiQ1RPRm9udnJjMGhFOG5tQXBOY25layt6dU0w?=
 =?utf-8?B?MTNXOFNDY25kLy9kY1lwSG5GQnFqRElzL2ZCWnZkYTljTkhDdTE1VUE0VUl0?=
 =?utf-8?B?bjBuWGp6MU1UbG9TWVVLY0NpTUNtMy8zTVJTOTRYS1h5ZnVFTWdpNENqSGVN?=
 =?utf-8?B?MWwrdWhJWFIxa3RiKzBBbWdkUnhzdjBCS2FXdUw3SEREclE1cFFqSlF6OUVi?=
 =?utf-8?B?NUF3UXQrSG9uV0c0QkJ1SVRvTXBzRUl5ZGlsYWFIK0VhcmdLejVWQVI2bkhw?=
 =?utf-8?B?VGtvQktjS0djalI5YTh0bkI3aGcwU0IrcjRuQ1hKWkh4QUZ5aXk2RWY0SFQ3?=
 =?utf-8?B?M280OE1LWWx6dmtwSXo5Yk5PVk5yTThUTUZlRTJhTE9yTkUxQjRCMUI0TXNY?=
 =?utf-8?B?T1cxMjRzUTFIQmZkdzhEUjVhd0tOcDhyZUxyQTRWNTdZOXdJS1RQaDUvZEU5?=
 =?utf-8?B?THUrN3JhZnVrM3p4OEFENkxDYjN1YlFoblQ4RG5uOCt0M3lqYjY3YVFnQjkr?=
 =?utf-8?B?M3c9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c35dbb-d219-4da6-cdde-08da80a5d708
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 23:11:39.3090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /faj0rVnFLEbfytoMdDMVzfRRMRKVfGFqsn/oF5NSTp/971AcLBABMlX2NuxSxl03WckEngaIIK6/WmR7g60DHuaKsAcp6zqw49Imbg4UII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB9044
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 01:15, Ilya Maximets wrote:
> On 8/17/22 22:35, Andrey Zhadchenko wrote:
>>
>>
>> On 8/17/22 21:19, Ilya Maximets wrote:
>>> On 8/17/22 14:49, Andrey Zhadchenko via dev wrote:
>>>> Hi!
>>>>
>>>> CRIU currently do not support checkpoint/restore of OVS configurations, but
>>>> there was several requests for it. For example,
>>>> https://github.com/lxc/lxc/issues/2909
>>>>
>>>> The main problem is ifindexes of newly created interfaces. We realy need to
>>>> preserve them after restore. Current openvswitch API does not allow to
>>>> specify ifindex. Most of the time we can just create an interface via
>>>> generic netlink requests and plug it into ovs but datapaths (generally any
>>>> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
>>>> do not support selecting ifindex.
>>>
>>> Hmm.  Assuming you restored network interfaces by re-creating them
>>> on a target system, but I'm curious how do you restore the upcall PID?
>>> Are you somehow re-creating the netlink socket with the same PID?
>>> If that will not be done, no traffic will be able to flow through OVS
>>> anyway until you remove/re-add the port in userspace or re-start OVS.
>>> Or am I missing something?
>>>
>>> Best regards, Ilya Maximets.
>>
>> Yes, CRIU is able to restore socket nl_pid. We get it via NDIAG_PROTO_ALL
>> netlink protocol requests (see net/netlink/diag.c)  Upcall pid is exported
>> by get requests via OVS_VPORT_ATTR_UPCALL_PID.
>> So everything is fine here.
> 
> I didn't dig deep into how that works, but sounds interesting.
> Thanks for the pointers!
> 
>>
>> I should note that I did not test *complicated* setups with ovs-vswitchd,
>> mostly basic ones like veth plugging and several containers in network. We
>> mainly supported Weave Net k8s SDN  which is based on ovs but do not use its
>> daemon.
>>
>> Maybe if this is merged and people start use this we will find more problems
>> with checkpoint/restore, but for now the only problem is volatile ifindex.
> 
> Current implementation even with ifindexes sorted out will not work for
> at least one reason for recent versions of OVS.  Since last year OVS doesn't
> use OVS_VPORT_ATTR_UPCALL_PID if kernel supports OVS_DP_ATTR_PER_CPU_PIDS
> instead.  It's a datapath-wide CPU ID to PID mapping for per-CPU upcall
> dispatch mode.  It is used by default starting with OVS 2.16. >
> So, you need to make sure you're correctly restoring 'user_features' and
> the OVS_DP_ATTR_PER_CPU_PIDS.  Problem here is that OVS_DP_ATTR_PER_CPU_PIDS
> currently not dumped to userpsace via GET request, simply because ovs-vswitchd
> has no use for it.  So, you'll need to add that as well.
Thanks, this is very important! I will make v2 soon.

> 
> And there could be some issues when starting OVS from a checkpoint created
> on a system with different number of CPU cores.  Traffic will not be broken,
> but performance may be affected, and there might be some kernel warnings.
Migrating to another type of CPU is a challenge usually due to different 
CPUID and some other problems (do we handle cpu cgroup values if ncpus 
changed? no idea honestly). Anyway thanks for pointing that out.

> 
> If you won't restore OVS_DP_ATTR_PER_CPU_PIDS, traffic will not work on
> recent versions of OVS, including 2.17 LTS, on more or less recent kernels.
> 
> Another fairly recent addition is OVS_DP_ATTR_MASKS_CACHE_SIZE, which is
> not critical, but would be nice to restore as well, if you're not doing
> that already.
Looks like ovs_dp_cmd_fill_info() already fills it so no need to 
additionally patch kernel part. Current CRIU implementation does not 
care about it, but it is not hard to include.

> 
>>
>> Best regards, Andrey Zhadchenko
>>>
>>>>
>>>> This patch allows to do so.
>>>> For new datapaths I decided to use dp_infindex in header as infindex
>>>> because it control ifindex for other requests too.
>>>> For internal vports I reused OVS_VPORT_ATTR_IFINDEX.
>>>>
>>>> The only concern I have is that previously dp_ifindex was not used for
>>>> OVS_DP_VMD_NEW requests and some software may not set it to zero. However
>>>> we have been running this patch at Virtuozzo for 2 years and have not
>>>> encountered this problem. Not sure if it is worth to add new
>>>> ovs_datapath_attr instead.
>>>>
>>>>
>>>> As a broader solution, another generic approach is possible: modify
>>>> __dev_change_net_namespace() to allow changing ifindexes within the same
>>>> netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
>>>> sure that all its users are ready for ifindex change.
>>>> This will be indeed better for CRIU so we won't need to change every SDN
>>>> module to be able to checkpoint/restore it. And probably avoid some bloat.
>>>> What do you think of this?
>>>>
>>>> Andrey Zhadchenko (1):
>>>>     openvswitch: allow specifying ifindex of new interfaces
>>>>
>>>>    include/uapi/linux/openvswitch.h     |  4 ++++
>>>>    net/openvswitch/datapath.c           | 16 ++++++++++++++--
>>>>    net/openvswitch/vport-internal_dev.c |  1 +
>>>>    net/openvswitch/vport.h              |  2 ++
>>>>    4 files changed, 21 insertions(+), 2 deletions(-)
>>>>
>>>
> 
