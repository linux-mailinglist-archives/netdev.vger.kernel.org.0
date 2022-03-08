Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBA74D1AC0
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 15:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347531AbiCHOkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 09:40:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245743AbiCHOkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 09:40:06 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B72838D86;
        Tue,  8 Mar 2022 06:39:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bjxrr5awaBWfpStD8AqtSsIbur9hMLbi6tzDflgqcUvGPblPbxH9uVdeN6dK9hqtMkm2UcgCzCjpwKgQyWXbPx4rL35pQb+oYYKgarT2vBIHJcilWLTSL/le1ODlfiB0QlgmOnykGjR68yCRD4zkAjjboHBoeRdzBuQqQ1VoL2CXvyFKf8HZBoSBD0P6P2fCV0al0VhBMuwyccryACztFCCMXi97KXaRtPfKSzGvUztvu2BUboCeKyIUJZ8l8veO97Y7hGtiD1cow1C+Qyh4Uo5zC2lwIFTmzuOFRNrdRKBDOmYVPXF3dBcTPbRT7UB2VsY0zCo/l2GYIJUTvMgbOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fepF9bZJihjFJt2+tBlWyx330mVK6mBCPB7z/FGI6Y4=;
 b=J9eYI3RZS7k4dAkUGLoiCI0Xhx6kRARQeXSLWfJVKEeSkq2+xqqVYXxuJR0QluTWGfXF+XUjK9xRqp+7ifRtnXoQV6aksGQPTScJOZlqfrHT40t2v535ew5Tugmz+nAU7AW/HLBb78j1O4MR6YdnmAHC1MWbKCfttYEkndO+3ecTqo2uSP5XnvP+mD6IHj6RhYgNeXzyJQ4r5oA+EzBNHZ9dHoikZpLeuNbBTkloV8F0edQe3e+2lXbOItii4rYVE/MxTpChymZBXfFdldEhiIS3/dXDF0Vnd8LNkLz9tqyx1ANoBniB1SWgFga8DKXgOzevJvjynZ8OEoxCFzfqYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fepF9bZJihjFJt2+tBlWyx330mVK6mBCPB7z/FGI6Y4=;
 b=OdBQZsCzBqnqCAfjVniMXwhblwum+JTTjPS8KqDRn76i/yLmy5+15qqsIZOWd8eAlJGr5UNEou0v7DMEva57zKKfh6vFlJ2yeT8mhxuzmh8gvf84sDDZfTWrejomOxsO6ZqXc9x+l0KusJhs2u6dJ8dL2BOQrVw7FYskqzmSPc0JflvKWyYDkbfVKAUvdkOvMlCG8InMFl6I9zF7hQcNeqvVBjojzQL6Q6VI65nKDSM3kHdEvAQ94qUHNn9nrI3YS9xgnhhHl0pjXLyUHZoampfN0iZmRDrqmKCvHnrA/Qb+ByD7nF88sk9TlEpQkgUmPHPoTH4KSmJmn9AKXNtrtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by CH2PR12MB4117.namprd12.prod.outlook.com (2603:10b6:610:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 14:39:07 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 14:39:07 +0000
Message-ID: <c9f43e92-8a32-cf0e-78d7-1ab36950021c@nvidia.com>
Date:   Tue, 8 Mar 2022 16:39:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
To:     Ilya Maximets <i.maximets@ovn.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     dev@openvswitch.org, Toms Atteka <cpp.code.lv@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
 <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
 <20220307122638.215427b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3a96b606-c3aa-c39b-645e-a3af0c82e44b@ovn.org>
 <20220307144616.05317297@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <45aed9cd-ba65-e2e7-27d7-97e3f9de1fb8@ovn.org>
 <20220307214550.2d2c26a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5bec02cb6a640cafd65c946e10ee4eda99eb4d9c.camel@sipsolutions.net>
 <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <e55b1963-14d8-63af-de8e-1b1a8f569a6e@ovn.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0072.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::9) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 569037fc-716b-4b2c-dcc4-08da0111668d
X-MS-TrafficTypeDiagnostic: CH2PR12MB4117:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB41174FC81EF93D3BC46A3053B8099@CH2PR12MB4117.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jnnucvby5KqnF906f1QjP6JInM3dk5902+7B8whQYyDO0XMzbEpoxZY6fT7TIGjJIpc/cqDKSHmDqd1POvWlz7MlbXbmYCxEi3VCeidwuhCq1L1reh9eMvJ1RfGw5fptJ3fIWqAgZh34Xx3dpAjxRJttJySJ+/34hc2jqzwIa0+alk29wKM/LOE3gCmqRnUrP8VNbUT1HAL42Fsp1ZWzf06MbDgsE8SmnuaGcmyLJ46xyyrL9QO5Wehyzv5PonpYHOLlWf0SqYO2bygTowgNK9loUWPdUuV9FgqUslL+8jx/jcxd9SWEgZTZcrW9i9fdaSGEfTCDPXtzqua50mcdOUreJVYMQ/QAbxmt1pt41r1T7WzuQJs7gOtE0ntYmDjD78LaZJ/kT4AxxdsSfRUnmqg9bHq82Zqdm9lgtDiVh9LZDMEdDOzUc0jkcSieOO0q+0eHVpJxJXmv/3Pr7cYb1uRI7rdmsOwjkvsJ0O78IXNWetnD2VCDG1jmnIq99Ow3ix+vFH89cQC74EcWIkbmF1uDepdOZ2bl4FodHqctOscXOlDji3RPrfZXaKi620M+hD9HOAyoZWA7KLfmRxm5eAs6PCy0Okg/MFG8xIdiMU19g/9w7HfaWoYEWa/wLeeyoN8i6ouTUp+xnNYD7IO8Wq3ndlGsUyx8NIOjymXOV+29HpPsTnUhAVUjFqkcvAuRqgQjsaUKi/L9NZUYe2BTxHfhEliABh42bt2AVpUcirs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66946007)(4326008)(508600001)(66556008)(66476007)(8676002)(7416002)(31696002)(8936002)(5660300002)(6506007)(6666004)(36756003)(53546011)(31686004)(2906002)(6486002)(26005)(86362001)(316002)(186003)(38100700002)(6512007)(110136005)(54906003)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGxnaFFyZjQyN3J0aGF6bjI3QXJDRUJPUU5ETFRBbmZUN0xJa2ZiTnkvL0dm?=
 =?utf-8?B?cjl1b0wyTE1ESklrbGpPUmwydmdyRUpaQlRCOHlUS0g5RjBTY0dkcFZzTVR3?=
 =?utf-8?B?TlBSOGpUejRYblJtSjNoMG1qZzYvNlRtSW9EdjVnN3VoSHJrZXBwRWlmdEhF?=
 =?utf-8?B?elN1OTU2MytHYmxYYkFweVQzQXdmdm1RUmd3WVZXMytGU2p0UVBRYXdwVXdk?=
 =?utf-8?B?MFlTM0p3dzE1eGZadEZDYjVKSFl2UnBCVVNLL1A2bUNqNDNHaUExSWZzUS9j?=
 =?utf-8?B?Z2dMZFF4cExyMVF3bG9KZjhRMTREcHdZaStHZjJlbGM5anRGanA0ZUZHQ1NZ?=
 =?utf-8?B?R09RbTZGdHlVQm9jcHdGT1Rpd3M1Zlc4VVp6eCt1dWJWTzhLNWxwYk01eXBa?=
 =?utf-8?B?b0k3UExKSjZ2TDFCVU45MnlIS0hTd2Q1T01JMDlQMndsUFp0ZmowZkJHNGcw?=
 =?utf-8?B?bWlpL1FMSlZBaDdWd1dTREVtaURjdWxadEgzUlZnMzhmZGN5OEQvN1ZjcFE1?=
 =?utf-8?B?V3JRMkF2REYrMlBRU2NqS29hZTJYYlNqTEljdUhqUnkybmV2NnBUTmJEYnUx?=
 =?utf-8?B?UVRiOGZPVFhmSmF3MWNnUFNMYUd6WEFLNXRBZEx6SlUrWk13Y0pTTGtydXRO?=
 =?utf-8?B?TEQwaC9rNzY2dXBvdFcvbTJOY1JPbFVGMnRzaTlWYkZza1hEcVFXb3VRSmhr?=
 =?utf-8?B?VUhoNGt4MnpVeFVBR1YxUkg5eWs3ejU4bkF0MWx6emV0U1c4WE9HSUF6bHU3?=
 =?utf-8?B?RWgyV1BKZGZhQjFaZ2dQbXRONUxGdUw2aWN2SlRzdnV3cFRaNkJpZkJyblZR?=
 =?utf-8?B?bDl1QlNiVmhQc3RjL210dDJtMjNzOWRMMlZSaUQ1emxlVXpMU2FUdXBtSGw2?=
 =?utf-8?B?bFlRbDg4S21sVHJoaGpoMGpabUlldGt6R2lsZUN5UUhwdTRzK2FPZjJReFNo?=
 =?utf-8?B?Q2oyZHVVRVB1Sk1WbGJkRVJMcEkybWRmMUwrZWtGcmZycHJ3d3pwQnZ1NEl4?=
 =?utf-8?B?eE1HV2p3UXErUUdwS2ZDdTZLeXZEVmt5Y1dDL1BWUmhNRmVuMTV2cUFZejNa?=
 =?utf-8?B?T1FmR1A0bzVyaWNhVTFna05keHZRRGwrRFRNaFBuRWVnQVNLQ0RWc3U1MEY3?=
 =?utf-8?B?L1RtMzJObW9Mb25OTVdvT21WajRIUDZzRHYwWGt2R1RKbFNscHFxa3hXQitu?=
 =?utf-8?B?TVNsbmgyOGZFZW5Ub3p3WkZtdytuTEJGMmJwZ3dTa0xDZyszb1FTVzBSU3JN?=
 =?utf-8?B?V1VscEZNRFBnRkxBVTNOemxvRkx1MHJzam5VNDdtZU1kdThHQzdOUEh0T0pj?=
 =?utf-8?B?N3ZjNVZyeUV5WDF3bnkwOFZLblpINDlId1JnMVBncFJlQWdyd3pGbERnR0pV?=
 =?utf-8?B?WlJIcWJOQmRIUVdnSzNWc1lOa3o5YWtMRkh3M05kb3orWUhNQWdMU3UrWDNH?=
 =?utf-8?B?SlozMjgyWEFFdnR3aUdid0ZJMkhOdmZwb1VuSDhEYkp2eXhpWStHYzFCNWRh?=
 =?utf-8?B?N1pySXpzWjFkNmJqZSs4Nm9IZmk0c2JFYnFZelpscGFiQmQrTTJ2OSs1SzBq?=
 =?utf-8?B?eUMwRGYxblREQ3dpa3Rjb0hud2RoK3VUcjBYcnVQR2ZzdzhwNG11d3NWclQv?=
 =?utf-8?B?SEdKZTNpMVZxd2FNUG93UndnaFdUM1A5bEJ0d1AvcE5VVk9SN0p6dUgwZ1Fq?=
 =?utf-8?B?d3JnN0pCYVZZS1Iwa3JFQ0RFNEMvVGFnWWZVS2ZtWkdzeWxEamxmYnVaT1pX?=
 =?utf-8?B?MjdYTFpUaGdBTzd1bldqRDE1eVpialpwOURFVjJ5WE5QTERFejBqQ2g0WlZG?=
 =?utf-8?B?Wk1YQk4zWFh1L1NvRHdZZ1N6UlplSDQ5VWV4aUl2MGc2d2o1Q3RvdjlWSmNY?=
 =?utf-8?B?Uk9tcFg5Rm80WkM1aWJ2WGdSZzlwL3NVMFlHN0JDVEl6eEhaUHRrNzh4Zmsw?=
 =?utf-8?B?NTcwNUdMaEZvNWRtZFljR1pQR3RMR3VZaU9mR3ZjVzVkOXhjQmIzQTRCaEJ6?=
 =?utf-8?B?c2dXZXUzUDZJRzlHalhVOGhLZmFZNFVQQVVEaFd0amNXY0R0MHluSW1TVU92?=
 =?utf-8?B?RnRncUZlenhCUnpOdzAxVzBuUU5jK080WGtwbUdWNno3Z0JCYjVzaFVlNlM4?=
 =?utf-8?Q?roOI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569037fc-716b-4b2c-dcc4-08da0111668d
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 14:39:07.5647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJYiHDYX4qX2QKgG/f4c9GVg6UKGHtz8VXxmeqbsBkvh+upVuOrkdR2+XSWf6Hxv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4117
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022-03-08 4:12 PM, Ilya Maximets wrote:
> On 3/8/22 09:21, Johannes Berg wrote:
>> On Mon, 2022-03-07 at 21:45 -0800, Jakub Kicinski wrote:
>>>
>>> Let me add some people I associate with genetlink work in my head
>>> (fairly or not) to keep me fair here.
>>
>> :)
>>
>>> It's highly unacceptable for user space to straight up rewrite kernel
>>> uAPI types
>>>
>>
>> Agree.
> 
> I 100% agree with that and will work on the userspace part to make sure
> we're not adding anything to the kernel uAPI types.
> 
> FWIW, the quick grep over usespace code shows similar problem with a few
> other types, but they are less severe, because they are provided as part
> of OVS actions and kernel doesn't send anything that wasn't previously
> set by userspace in that case.  There still might be a problem during the
> downgrade of the userspace while kernel configuration remains intact,
> but that is not a common scenario.  Will work on fixing that in userspace.
> No need to change the kernel uAPI for these, IMO.
> 

since its rc7 we end up with kernel and ovs broken with each other.
can we revert the kernel patches anyway and introduce them again later
when ovs userspace is also updated?

>>
>>> but if it already happened the only fix is something like:
>>>
>>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
>>> index 9d1710f20505..ab6755621e02 100644
>>> --- a/include/uapi/linux/openvswitch.h
>>> +++ b/include/uapi/linux/openvswitch.h
>>> @@ -351,11 +351,16 @@ enum ovs_key_attr {
>>>          OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
>>>          OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
>>>          OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
>>> -       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
>>>   
>>>   #ifdef __KERNEL__
>>>          OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
>>>   #endif
>>> +       /* User space decided to squat on types 30 and 31 */
>>> +       OVS_KEY_ATTR_IPV6_EXTHDRS = 32, /* struct ovs_key_ipv6_exthdr */
>>> +       /* WARNING: <scary warning to avoid the problem coming back> */
> 
> Yes, that is something that I had in mind too.  The only thing that makes
> me uncomfortable is OVS_KEY_ATTR_TUNNEL_INFO = 30 here.  Even though it
> doesn't make a lot of difference, I'd better keep the kernel-only attributes
> at the end of the enumeration.  Is there a better way to handle kernel-only
> attribute?
> 
> Also, the OVS_KEY_ATTR_ND_EXTENSIONS (31) attribute used to store IPv6 Neighbor
> Discovery extensions is currently implemented only for userspace, but nothing
> actually prevents us having the kernel implementation.  So, we need a way to
> make it usable by the kernel in the future.
> 
>>
>> It might be nicer to actually document here in what's at least supposed
>> to be the canonical documentation of the API what those types were used
>> for.
> 
> I agree with that.
> 
>> Note that with strict validation at least they're rejected by the
>> kernel, but of course I have no idea what kind of contortions userspace
>> does to make it even think about defining its own types (netlink
>> normally sits at the kernel/userspace boundary, so where does it make
>> sense for userspace to have its own types?)
>>
>> (Though note that technically netlink supports userspace<->userspace
>> communication, but that's not used much)
> 
> OVS has a common high-level interface+logic and several different
> implementations of a "datapath".  One of datapaths is inside the Linux
> kernel which we're discussing here, another is completely in userspace
> (to make use of DPDK or AF_XDP), there is also an implementation for the
> Windows kernel.  Since the way to talk with the Linux kernel is netlink,
> OVS is using netlink-based communication to communicate between high-level
> parts and all types of datapaths.  Some features might be supported by
> one datapath and not supported by others, hence some way to extend the
> communication is needed.  E.g. kernel currently doesn't parse ND extensions,
> but userspace datapath does.
> 
> But yes, the current implementation is awful and OVS need to have a
> different way of managing datapath-specific attributes and not touch
> kernel-defined types.  We'll work on that.
> 
>>
>>>>> Since ovs uses genetlink you should be able to dump the policy from
>>>>> the kernel and at least validate that it doesn't overlap.
>>>>
>>>> That is interesting.  Indeed, this functionality can be used to detect
>>>> problems or to define userspace-only attributes in runtime based on the
>>>> kernel reply.  Thanks for the pointer!
>>
>> As you note, you'd have to do that at runtime since it can change, even
>> the policy. And things not in the policy probably should never be sent
>> to the kernel even if strict validation isn't used.
> 
> Agree.  AFAICT, OVS currently doesn't send to the kernel things that kernel
> doesn't support.
> 
>>
>> johannes
> 
