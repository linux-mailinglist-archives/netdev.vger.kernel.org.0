Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2F598321
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244641AbiHRM0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 08:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244304AbiHRM0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 08:26:42 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2104.outbound.protection.outlook.com [40.107.105.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589B757245
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:26:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz+UyHC6dDJ9w48RPz44k3VCGIdGPx0S+V5x9XzTNCqXjaOSauvm1ie4V4IXLffBaxsIXf0eNn9t7ERkG5xJqh0h6eQO90RgLYab87PCKLOwHHIYGK8fkYqtjxCwAFGKqcX9QX6cjSGxTi7MinT1xCpmHkGwmuWpzoUlUkCva5NNo8+ANoA537ZNi5U3hopQvgmib1NOeHZFIKzViIlrl2Oqka7v2IX45/qbfYG7xpdxfagXPci2G4PRfoDiGsyLcE2CEC5fwgl5+t4vxeNI20rkXNFMK1A/HnD6lhYl/Ha0d8htVdzPMc9Nz6EedeVgmeqk0t6WROHdrWHuHvBPoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVszvlmT+Vt7wcPmvCVAKby8uzmmB8/laSON2zR2uUg=;
 b=gpmi76ZM3uTCPw0l5uk3gmuybeDGgT3wv47js2GQ/MQICnAe+QJDNk0txPtWm1zm1N3rOeV02omVbzvIRP4ySsJsoeCP0tEOhiGyc+6YhLvpNAI5u7iBJ76Ya2h4V2nXXzgZm2y94iQJX9eko4Oh72Zu5SVxOfKFR9gbD+11sYYxah8syiMxYOMijrCEZkf3uwn2Fx6E1z5ySGdPDE3t/Bc4FzAUQyVUC6jlYnsICATEUS2A07WKgC1KHctDGWRFEakxhg8O4bTZfDsCMRX9eRcPrW5Wfbxsx50zkLXvvWOUm9Yhk9jjQlV1fkmPfrR3RGMX8zb68RJWlGrbcMW6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVszvlmT+Vt7wcPmvCVAKby8uzmmB8/laSON2zR2uUg=;
 b=Y8SOPDW1vptyFs8jwl0irw8WpzxOsEIWhhlu540QgGK8XHkcu9C7GGRFXjNr7+SAODDhPoiHyUpY2E2ByopGPC1706Sa1nCobgzWhXbjJ8U8TkKOKmhK9Ur1AAOlIFkpirPal61km5YMbudJFtt7HxXbRMxoqKlYDQIpmk6Yx1cNttkOKensjDd4Wg9sATx3N6Zb0BXHaOeQ4STsjOsz5X9UT0btYApC/sYohBk/L8JndGQOOrEw447znjhm1ZOxOZaDOeoMpxUqNO0PUyD49tsh7UZPPqsfwciJZNeswCapuqA4FKlqIQVbMFrAmV2+c0M09hJrnXVjHfH9aEPf+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by VI1PR08MB3325.eurprd08.prod.outlook.com (2603:10a6:803:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Thu, 18 Aug
 2022 12:26:37 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::a53b:5ee:e62f:c7a4%6]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 12:26:37 +0000
Message-ID: <659b7215-88e6-df66-8d38-aab1eac4f531@virtuozzo.com>
Date:   Thu, 18 Aug 2022 15:26:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [ovs-dev] [PATCH net-next 0/1] openvswitch: allow specifying
 ifindex of new interfaces
To:     Ilya Maximets <i.maximets@ovn.org>, netdev@vger.kernel.org
Cc:     dev@openvswitch.org, brauner@kernel.org, edumazet@google.com,
        avagin@google.com, alexander.mikhalitsyn@virtuozzo.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        ptikhomirov@virtuozzo.com, Aaron Conole <aconole@redhat.com>
References: <20220817124909.83373-1-andrey.zhadchenko@virtuozzo.com>
 <38c9c698-6304-dfa8-7b79-a1cb1e00860b@ovn.org>
 <bc6f197b-37a5-89ea-1311-16f93b5cefed@virtuozzo.com>
 <495de273-9679-5186-3d6c-41f44e9280e4@ovn.org>
 <7365e0a6-a82b-c92a-137e-f28111a9c148@virtuozzo.com>
 <f18e2734-ddf6-fbbc-d2ac-a2acb65fd073@ovn.org>
Content-Language: en-US
From:   Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
In-Reply-To: <f18e2734-ddf6-fbbc-d2ac-a2acb65fd073@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS8PR04CA0124.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::9) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16ea43da-9b19-4155-34be-08da8114e547
X-MS-TrafficTypeDiagnostic: VI1PR08MB3325:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zw46z9LzDhZeukFOuE5z3gJyqf6xW/gQPzd8RBw263D7JUzZMQlxzjgtmlJJL7gX+ulGdeLeUuWnpZQPDYbAjP+eqs0YHEzdsbiy+zqjgyAqUZp4on90xsE0aqjovNsuGEuXcJZovShiAi6j952z2uchITuk2pRJl4OCI4vSojvBfpZIRJHgsYrU3Ukfdyv+SUMziG+5h6NGl04f0z0aOHtqmcMphRlCqJB5Z5S+BniEF0h99osCaEAaPqGL6NltHTIKEvsyRmDNoUtPLdNwjD4FbZ6uB/STB6YBBNRyQ4pG8w+YSIAndIQi9oHwP2Job8otf6M4Rji0R5mBVRBsPTZx5E0ZCkLOjMKcsCpLXf/oxrh8pb8fTquXmo628M8/gAIQWECaoE5++nkR4wVaNoTYWG0FpALph3uqYju8xGtYo9HnwykOWTX7vq9Bl2a1ALbgVl5wbcTfiRM+MhMpIq7hMpBJZodjHfp1uJzXODrGRh250WyRjVhNZVaQShD1ZXgu1ZYtqMO0Mt7OH9pg4EavNDowtO0mZQJ8aTZM09w0AKvXe1kcB27WBIc03MEPND8fpySh261lAMcCKfRW3b6Nvr/hK8CD8iHhZx+32lNeTNetXzs81IabpZyCmIqV+s85qx53kL0BWEUb3V6ed8G+UhYMaNJ2N5cF6SvOFh4Lnyeh5fNf4SaG2nDI3MvIClXychOfo3xoPzDWQipicpbKanA4mkffkFDGXSr1H9G+uGhCfaZSEYZDYES8NxVB1ZwUoWtCJJSExS5S/GrTFtTwls2tCICfydBUvn5SgK961N9OgVlkrqxZmuoFI9Ow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39850400004)(376002)(366004)(136003)(396003)(346002)(26005)(8676002)(66946007)(2616005)(7416002)(83380400001)(66556008)(6512007)(4326008)(44832011)(41300700001)(186003)(478600001)(53546011)(8936002)(86362001)(31696002)(5660300002)(66476007)(6486002)(966005)(2906002)(6506007)(316002)(6666004)(31686004)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzVVbU9BZ2JIRU9DMmdpc0lWSGhOQ2htcG1yME5yeTl2enUxZXpNc2VFMWFr?=
 =?utf-8?B?cnZ2dWxLazk1UmEzZ1lQMDJpWnFqUExwQThENDdmS2VYS1FLSTE1V3FlS2NE?=
 =?utf-8?B?TnkxaGcrMkhCc3RPbnJIWmh3azJqbndteGl3TDVnY3E5RmwxbnRMSVhOREpQ?=
 =?utf-8?B?eHY5ckJWMlpLVGRMa3FIVGtJNnE1NGk1U0UvNmJUaFVNNHI4Y3FLTXhoa2Vx?=
 =?utf-8?B?RVc4aTVWMmJiSXZRNTVPaEJtVmgrNGl0TmVxOU1OMWZKbmxORHlZSnFOamNa?=
 =?utf-8?B?Nm40T1gzblJsM3FUcEpDbHpsWVhmdC9ka2o0cTdMbW9EcmtHV2xYRjB3TjBa?=
 =?utf-8?B?VUpJOVFVa0ZKeUhiNmRJcUNkczh2S21qYVdMTnZFNk1oanpycC81VElGL1Ay?=
 =?utf-8?B?NlBGQmFlZVR4bU5KSnpNQ1ZKcmExMkcrL1ZsVTE3MVREVHFIck5SemUvbFVu?=
 =?utf-8?B?cnV0a1JOZVN0UUdjcHZPTHhOc2pkUFF6U3ZOZU1PKzFGWVlzbXp1UGdLVTJD?=
 =?utf-8?B?ZzRrTUxhTno0dmljdml5TzMxeVZRVlcxOS9RT0pRcUpRSk5mTzBFaHRGS1Rk?=
 =?utf-8?B?KzBaUXVLelBVMTlra1hmZ1JJbzdIeTBCNEs2K0g4L1NESjlPQUdOSnRldmRY?=
 =?utf-8?B?Yi80VVRsL0JnYzZHMGJaeXVab2dMTlRJM0FOb0JJN3NTcDJiQ25GamZ5eHV5?=
 =?utf-8?B?NjhTRXRuL0NQS21hZ0ozdTVjWXpqdmRHZldyaEhTazRtRkJ4TUJhK1djdXov?=
 =?utf-8?B?a201V1hyVWhhc1M4OHhMbUdtTkpXMkhsN2hMa0owMGR6cEZVNkZnOGJmaS9U?=
 =?utf-8?B?Ry9JblFJZGhldld2ZVk5cWQ3czVPMzhNTmlxdXo0eDBGVWZTQVJoNGFTZ3Bo?=
 =?utf-8?B?V04xbzlHUTJ3N2d4c2pIUUY2Rzc2ekkzMHhPZkMxTno5Q0dKK1hGN2RJSGZo?=
 =?utf-8?B?Tmhqdmt4WkJuWU92ZHZZMDVRRTVXL25yRHFKWHJkOVZTZ0orUVk4dXAyVHpV?=
 =?utf-8?B?Y0hsS0NWMUUxbC80bXRxMUdJNXoxNnNFYVFPNk44WkE1akVKODJBY2RoYkMv?=
 =?utf-8?B?c1c3WTljVHViVFFKZFlsRXJhUDA1TWRIUjZGbi9PQ2tYMzUvTDBadms4bWlF?=
 =?utf-8?B?Tk9ORUZTTE5SbmUrTnhWcFZMWFEyVEJCWGxIUDliL3BpZWozYmR1S1pzK1Zu?=
 =?utf-8?B?R09DNGo4RmVjbWlaUVhobFBRek9CbGh6bURIcmlLMFpSbTlHSTJaK3UxUXp1?=
 =?utf-8?B?MWJmdG5OaTN4Z3dxK1dxRjVSK2s5UGhDVzg4c2tJRHFDTkIyTnJINWVacFNT?=
 =?utf-8?B?UWpJM21sSTZ1Ymd5UTJKT0lwR3RhT0pMeUYxOEJqYXJlZnRxclVVRERPcEZI?=
 =?utf-8?B?WVY2NHZzWW9WZmNOdGJINGNNQy92aUhHWGlTSU1sYVlaRWdvU0hiVHdJcFZ2?=
 =?utf-8?B?WmdLYkJNZnljVURjY1QzazgrY0xEbjJvR05MUUpmTGQ0T2V4M3NFbnBTL3JL?=
 =?utf-8?B?UWlrYXJyZnhRSEIxUW5PZk5nSVBJZTBmUk9mcFVrcFBmeXNUS1pkOTVOR2hu?=
 =?utf-8?B?QzVncVMzb003RWQ4UjVrTmpsRmlYMzFPTnFCRm94b1U5RkJEZWZsbzNZeW1y?=
 =?utf-8?B?VXdYNkx4RWZ1Y0M5VEJSQmJJQlJSS3g0TWZGNkRFaGIzbTU1N2srUEptQnZ5?=
 =?utf-8?B?TkNtUCtNRURuV2RGeHJUaUhMNVJuWnAxQzRBZUU1N0dhTVpWOExBY1U5bUow?=
 =?utf-8?B?eksxRWxwMFdPTGRQZVlWUXUyd1ZZdjNXbVNQVVlyMnhlSWoyODhnUXRtN0Ji?=
 =?utf-8?B?TjVqRG1DTXhjSmt3K01xcUE3L2d5T1U2aThlRHNFYWhhZHhHb21ZL1RoZ0JH?=
 =?utf-8?B?bzM1UjZFQjZnWkRFNDdZRWNqOVZsNXNnNmxGOVBibHVOcjRLQkpzNFgrSlJo?=
 =?utf-8?B?NjZwVFpVb1N0dkV6ZllhV0V4VkNGL296bjE1ZFhONUFqZ3FLV2VkUUdXRU42?=
 =?utf-8?B?OGVRUGpFTDVHWE1aWkxlZGZWS0RLOGlmT2J6bXRnaWFDUXh4bnJuU0dhaVVX?=
 =?utf-8?B?VXdXdklpY1NZTExwTWhmNnZyaVQ2VFpmUGNidTJMeE9Rbkc2eXN6NzhvZ21K?=
 =?utf-8?B?UFAveHZqelFQR0VqdUNIN25WTllxZFpEREtML05FY1Vnb3B0ZStJTlFYeUxu?=
 =?utf-8?B?MWc9PQ==?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ea43da-9b19-4155-34be-08da8114e547
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 12:26:37.3730
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQ7yuPEzKdV4AiqH5iDkOTwMWk+qbO2jXf6hRkNyO5LizkSXZfpGIKm2AVaAfSgMkrtHTGlzuqjmXWywKKtIZyCed0aDGNDrJ+iAPNDB3uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3325
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/22 14:06, Ilya Maximets wrote:
> On 8/18/22 01:11, Andrey Zhadchenko wrote:
>>
>>
>> On 8/18/22 01:15, Ilya Maximets wrote:
>>> On 8/17/22 22:35, Andrey Zhadchenko wrote:
>>>>
>>>>
>>>> On 8/17/22 21:19, Ilya Maximets wrote:
>>>>> On 8/17/22 14:49, Andrey Zhadchenko via dev wrote:
>>>>>> Hi!
>>>>>>
>>>>>> CRIU currently do not support checkpoint/restore of OVS configurations, but
>>>>>> there was several requests for it. For example,
>>>>>> https://github.com/lxc/lxc/issues/2909
>>>>>>
>>>>>> The main problem is ifindexes of newly created interfaces. We realy need to
>>>>>> preserve them after restore. Current openvswitch API does not allow to
>>>>>> specify ifindex. Most of the time we can just create an interface via
>>>>>> generic netlink requests and plug it into ovs but datapaths (generally any
>>>>>> OVS_VPORT_TYPE_INTERNAL) can only be created via openvswitch requests which
>>>>>> do not support selecting ifindex.
>>>>>
>>>>> Hmm.  Assuming you restored network interfaces by re-creating them
>>>>> on a target system, but I'm curious how do you restore the upcall PID?
>>>>> Are you somehow re-creating the netlink socket with the same PID?
>>>>> If that will not be done, no traffic will be able to flow through OVS
>>>>> anyway until you remove/re-add the port in userspace or re-start OVS.
>>>>> Or am I missing something?
>>>>>
>>>>> Best regards, Ilya Maximets.
>>>>
>>>> Yes, CRIU is able to restore socket nl_pid. We get it via NDIAG_PROTO_ALL
>>>> netlink protocol requests (see net/netlink/diag.c)  Upcall pid is exported
>>>> by get requests via OVS_VPORT_ATTR_UPCALL_PID.
>>>> So everything is fine here.
>>>
>>> I didn't dig deep into how that works, but sounds interesting.
>>> Thanks for the pointers!
>>>
>>>>
>>>> I should note that I did not test *complicated* setups with ovs-vswitchd,
>>>> mostly basic ones like veth plugging and several containers in network. We
>>>> mainly supported Weave Net k8s SDN  which is based on ovs but do not use its
>>>> daemon.
>>>>
>>>> Maybe if this is merged and people start use this we will find more problems
>>>> with checkpoint/restore, but for now the only problem is volatile ifindex.
>>>
>>> Current implementation even with ifindexes sorted out will not work for
>>> at least one reason for recent versions of OVS.  Since last year OVS doesn't
>>> use OVS_VPORT_ATTR_UPCALL_PID if kernel supports OVS_DP_ATTR_PER_CPU_PIDS
>>> instead.  It's a datapath-wide CPU ID to PID mapping for per-CPU upcall
>>> dispatch mode.  It is used by default starting with OVS 2.16. >
>>> So, you need to make sure you're correctly restoring 'user_features' and
>>> the OVS_DP_ATTR_PER_CPU_PIDS.  Problem here is that OVS_DP_ATTR_PER_CPU_PIDS
>>> currently not dumped to userpsace via GET request, simply because ovs-vswitchd
>>> has no use for it.  So, you'll need to add that as well.
>> Thanks, this is very important! I will make v2 soon.
>>
>>>
>>> And there could be some issues when starting OVS from a checkpoint created
>>> on a system with different number of CPU cores.  Traffic will not be broken,
>>> but performance may be affected, and there might be some kernel warnings.
>> Migrating to another type of CPU is a challenge usually due to different CPUID
>> and some other problems (do we handle cpu cgroup values if ncpus changed? no
>> idea honestly). Anyway thanks for pointing that out.
> 
> TBH, it is a challenge to just figure out CPU IDs on a system you're running at,
> migration to a different CPU topology will be indeed a major pain if you want to
> preserve performance characteristics on a new setup.  It's probably much easier
> to re-start ovs-vswitchd after you migrated the kernel bits.  Though it doesn't
> seem like something that CRIU would like to do and I understand that.  Current
> ovs-vswitchd will not react to sudden changes in CPU topology/affinity.  Reacting
> to changes in CPU affinity though is something we're exploring, because it can
> happen in k8s-like environments with different performance monitoring/tweaking
> tools involved.
> 
> Regarding more "complex" scenarios, I should also mention qdisc's that OVS creates
> and attaches to interfaces it manages.  These could be for the purpose of QoS,
> ingress policing or offloading to TC flower.  OVS may be confused if these
> qdisc's will suddenly disappear.  This may cause some traffic to stop flowing
> or be directed to where it shouldn't be.  Don't know if CRIU covers that part. >
> There are also basic XDP programs that could be attached to interfaces along with
> registered umem blocks if users are running userspace datapath with AF_XDP ports.
> Is AF_XDP sockets or io_uring something that CRIU is able to migrate?  Just curious.

CRIU poorly handles traffic shaping. I assume all custom qdiscs are gone 
after migration. Probably we should refuse to checkpoint any non-default 
values to prevent unexpected results.

XDP (and eBPF in general) are not supported by CRIU. We can 
checkpoint/restore only simple classical BPF attached via SO_ATTACH_FILTER.

As far as I know io_uring support have some working PoC made in GSoC 
2021 but not yet merged.


> 
>>> If you won't restore OVS_DP_ATTR_PER_CPU_PIDS, traffic will not work on
>>> recent versions of OVS, including 2.17 LTS, on more or less recent kernels.
>>>
>>> Another fairly recent addition is OVS_DP_ATTR_MASKS_CACHE_SIZE, which is
>>> not critical, but would be nice to restore as well, if you're not doing
>>> that already.
>> Looks like ovs_dp_cmd_fill_info() already fills it so no need to additionally
>> patch kernel part. Current CRIU implementation does not care about it, but it
>> is not hard to include.
>>
>>>
>>>>
>>>> Best regards, Andrey Zhadchenko
>>>>>
>>>>>>
>>>>>> This patch allows to do so.
>>>>>> For new datapaths I decided to use dp_infindex in header as infindex
>>>>>> because it control ifindex for other requests too.
>>>>>> For internal vports I reused OVS_VPORT_ATTR_IFINDEX.
>>>>>>
>>>>>> The only concern I have is that previously dp_ifindex was not used for
>>>>>> OVS_DP_VMD_NEW requests and some software may not set it to zero. However
>>>>>> we have been running this patch at Virtuozzo for 2 years and have not
>>>>>> encountered this problem. Not sure if it is worth to add new
>>>>>> ovs_datapath_attr instead.
>>>>>>
>>>>>>
>>>>>> As a broader solution, another generic approach is possible: modify
>>>>>> __dev_change_net_namespace() to allow changing ifindexes within the same
>>>>>> netns. Yet we will still need to ignore NETIF_F_NETNS_LOCAL and I am not
>>>>>> sure that all its users are ready for ifindex change.
>>>>>> This will be indeed better for CRIU so we won't need to change every SDN
>>>>>> module to be able to checkpoint/restore it. And probably avoid some bloat.
>>>>>> What do you think of this?
>>>>>>
>>>>>> Andrey Zhadchenko (1):
>>>>>>      openvswitch: allow specifying ifindex of new interfaces
>>>>>>
>>>>>>     include/uapi/linux/openvswitch.h     |  4 ++++
>>>>>>     net/openvswitch/datapath.c           | 16 ++++++++++++++--
>>>>>>     net/openvswitch/vport-internal_dev.c |  1 +
>>>>>>     net/openvswitch/vport.h              |  2 ++
>>>>>>     4 files changed, 21 insertions(+), 2 deletions(-)
>>>>>>
>>>>>
>>>
> 
