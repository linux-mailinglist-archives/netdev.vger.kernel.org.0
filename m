Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C7C4C9ABF
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiCBByk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:54:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiCBByj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:54:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2075.outbound.protection.outlook.com [40.107.236.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5645E77D;
        Tue,  1 Mar 2022 17:53:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJLc7ME7jZKah9GQvf5zhXGPSbJb+fEf43Fdzd1xCIzy1hsOFt9vYWNENn0gllJWSTZ30lDKQ5alJqsJvxwCejKG8vg85Sb573gDgOUDXiKr7/1aXS8J7eH18an8GTOgcNpzCMeLp1XNzUa77TXz9XhQJDqCkS5TbQnkb8egsQM0GMp1XnauLUJ2FIdOA1i9vVpCR/Lxcq/NNsooSsnv1xyRal9+bPZO7WIZrM97oOePNR5Q0gOnfKhj6KXKu3afV9J3ikk/gZYcYb+qWq7CZRgyR7270ZpuXebGEAhWr4QfephjJiJUYIZW6x7R0zLAXnTkGBqh2WWtC0lbGifufg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IWvkH/KmjPgVLg0gyyO1Ak9e/IitLB+RMhrWKev85I8=;
 b=c+cjVuhdQFM41hacKL/TVCjY545pZxB7Gd4kkVfbjs/66t4kCgxdEAiarx9uX9Y+LVo26oRhf0yn+CP8jLAj3nn+YVi3l/crIi/oErscK1BcrzUJPYW+UMYK7tjKtmn8Qnu0QJO6osGeFGt8rfWoCKpjSSRx1EnZ0Vwemr5d0vgBFRALmwN9ncisHoACeNBWm4csLsYmZbypCN+Qcu73y59qBM/+YjN5XPSCFZedNWOwVBxiyze32FkX2PAeClUKzwVfp/YfF8rjeoPK1PS/2vtWjd4sxzpJcYp1ELOEnvG7vI1EL4DsrpTZL07s4FJ1KCFhQzmoHKCknRyefKhUig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IWvkH/KmjPgVLg0gyyO1Ak9e/IitLB+RMhrWKev85I8=;
 b=UYBVuQQf0e3ZKDxmHvgVPASNtfIZ6K4JKAeUmHo8v8fK+D1qtgeHRer8O5bm317Gh1oGZXhGljXsrd5WuZIYOJYphcj5r8AXiPrH2TaWCi+bUUs95/tzfrlHj0Gvqw5tSGipaVBdwRrMrzkPgNAwaGYnyjka/4Sb4ZigQWDh0Lvu4ssUmwdo32Ri88nKgShWl6rjBs6IynOvZeJQHlxbFOz1yf/LyaCfz7gRpV1ZXCGrqsG14qWzzUxLbHbbgusu/eCeAIei1ys4Z8V2WFqQAdyRnbp8fwqcwim8PJnHh6AMHDNWvn4XaIry33PdsCCr5oTPmCoVdV04bF+ubiVGcQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by MN2PR12MB4061.namprd12.prod.outlook.com (2603:10b6:208:19a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 2 Mar
 2022 01:53:51 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::9cc:9f51:a623:30c6%7]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 01:53:51 +0000
Message-ID: <5d3acf32-9875-de6d-7495-5e4860fb88f1@nvidia.com>
Date:   Tue, 1 Mar 2022 17:53:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 03/10] net: bridge: mst: Support setting and
 reporting MST port states
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220301100321.951175-1-tobias@waldekranz.com>
 <20220301100321.951175-4-tobias@waldekranz.com>
 <53EED92D-FEAC-4CC6-AF2A-52E73F839AB5@blackwall.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <53EED92D-FEAC-4CC6-AF2A-52E73F839AB5@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:332::26) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7315bb90-98b5-4ac2-2363-08d9fbef7fb8
X-MS-TrafficTypeDiagnostic: MN2PR12MB4061:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB40611632B9787F198BFB2E04CB039@MN2PR12MB4061.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2EmpTBn+YtdNuEqsxXaPRP3ED+zIcJOKG5JaonBQTwWyIlFrWsUQ74zSRh3of8JRQvfbIKyGRImz/XPx7a78isU+lf2Tn4glTv9q2m15fyDxTit+GB45Cp4b3qsa1j2/gVlaUpwD4sjcE+dQMcGpU+O/Y1r+biqkupioZ4URBe8f7iWZmzRxbX1ZBmHID6rmQzc/6yJ6A0wTKKldVoo8exEK7rYv8OSFzkZzCmMNqiHwJ9JRnYCakBsg+FD4/jdyIsdflR36ZhpGbW229AU6GGTRKZ+oI+Vy3qwF57yLm6T22dqjWTZthttjKYccyDzPFgH9QxyNSgt/iVOODT67jhVKxkfRYmmR1/mw8bTBEQJ74JduRt7bmpjc9RqEhbKrc9AXHxSDPMsIWoIas0Va77YjBtAL5tSM+eh254iiBLGGfuasNolqgpJrAifcByGu/8YL5AuDxq1TJG1WWdyRbXqYTYn1wPwJusRPRMmVT73cd9ZjypTrKTbFyd8mTjlbkQMinHmKXKGYatEP5gcb8AEeXJW2hBc0aYwDCDKob8nMD0crJIOyfhH3EEKsX0tDR1LlVH+I135KC9KJ0/Yqg5H39D46VpzAe/cBlhTtay1SFZGEj4mrZSbIT6ATP1rjGDkWicPyXEG8l/FCcrVfSY8qXPt73LVuUEMLot3i9EKSLRrmjMUblzRX8gN2EnwdxPUC9RQdP5+l8vWOHBcC5S/8YvSV/nSMgngyVUX3mI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(316002)(86362001)(5660300002)(2616005)(38100700002)(6506007)(66946007)(66476007)(66556008)(31696002)(7416002)(8676002)(2906002)(186003)(26005)(53546011)(4326008)(36756003)(66574015)(6486002)(83380400001)(508600001)(54906003)(110136005)(6512007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDB5U3BJTDJLUDVSbCszQ0loaU95MUlOeW5pTmx3d1dyRjVSb0EyWVV5Ti95?=
 =?utf-8?B?YmxnK3hQaUVDb3MyU1R2T0NzaWJoU1hjVENxMzNMUVE3WUsyc0xyajdELzlW?=
 =?utf-8?B?UkgwT2t2eTd4bXY1d2ZaSFFhZDZNdnFsU0hOTjQxZEdsRUZxSGwwVFJMc0gr?=
 =?utf-8?B?UTUxUFhJa1ppVHA0QmVjTnZ1RlM2V1BxeVNPd1RBVG5YQUxtWnNBeWV6NExX?=
 =?utf-8?B?THdTYUFtRHphTFJmeFFvNTFIR2xqVlMxdlU4SS9vZXpWTlNQUUdjelhySXNa?=
 =?utf-8?B?dkkySTJKZ3AvcXpka3ZpUFFQWk5kbmVid25XbHRycTZMSGZhNGxIbW9Ja2Zl?=
 =?utf-8?B?Qmt2SWJVSUxtNUUzeThFakN0N0xUZXZFR1ozdEpER3FwSnJWOUpxMEJZVysw?=
 =?utf-8?B?MDFVZklxVzdlWnoyTmJVTDd5VzR6cG9LeC9ndnVLYTR1WXptbGlLMTlweTRj?=
 =?utf-8?B?cTlqZGthOWJINWFScEZHTkZrSTlKZ1JTUnF1QzJDZXlUL08yUDJWNXZpUnZB?=
 =?utf-8?B?bmdQcVZZc1o1NVp0eUl0OWRnbGJsYWdkY3ZIYXJXWm8xdFdNR0tyVUxtc2lX?=
 =?utf-8?B?ZytvczJOYjYyemVERlNnNkl6ZVF3dzYydnc4WlFjNjlKUWs1VGk5YWcvU20v?=
 =?utf-8?B?cnZSU2FlRWI3T2pLTXZkTmVBY2w0WUVNWFYrSjJWVVZNYWY5ZzFFSzFMZWlG?=
 =?utf-8?B?YURwdmVpL2ZyMU1uQUVPUnZPYzQ0UUtsVGFxNTRFSlFCUkhabU5WdEN2YUtU?=
 =?utf-8?B?QTl4dXBPSDA3NzdvKzAzMnNWdUQ5T1JEblY3bER2Y3VZc0plNkYxN2lBZUFY?=
 =?utf-8?B?d1hVWW45VS95Y0lBaU1kSmdwSGpleEd5OCtuMFFDUmxuN0U5YzlPTGsvTTh6?=
 =?utf-8?B?cXIvbUtxK2dWdkNYUFFZSnlnenp4U2ltQXBjYXBVajNNc1ozRUxLaE0rOW9t?=
 =?utf-8?B?aUxRSTB0aWViVzgzTUU3QmZhSXZ1OENLeHg4M3VPczlhTm9WK01NbW1rd0ZK?=
 =?utf-8?B?c0lsK3M1K3lGaGRLbXczcmlsd2xhK0NRQ204czZuNkFKTzd1cVY2eXA1VGEv?=
 =?utf-8?B?MjVVVkl5NzFpaHJUQjIvTXdCRzFZS3BLQnAyOHdWcmdwTWpXY0ZLR0gzekhI?=
 =?utf-8?B?UkxiK1kya3BXM3Q3Vk1tWEI2VDFaTnFndjFQQUhsTS9pem0ySDlSSGRGSHlI?=
 =?utf-8?B?RkkvZnlMUC9sZTM2bXpBaHFuU21VUVUxVHQ0dVVUOHBTWnloTEVUeUZ0ME1s?=
 =?utf-8?B?MnVSZGpwVmRydHNZUDhoSUpMazdnMzNGZVhScUVYSitYbld2RmxSMEtYMDJ5?=
 =?utf-8?B?aDZ1N3pYR2ltVis3WVJqS2Z2c0V0b0VaTjlrS011NWFIME5WU2pCLzU1eGVJ?=
 =?utf-8?B?cW1CSmMvMTlPMXh6YnIwbUk0VVozclFVa0dPanRHbzRlR3VYZFdDUjBQYjRI?=
 =?utf-8?B?N0tKMHkyMjdYUGVtVkkveDFkbTREeUZDdHplNnBhWmVydTliM25aZHJYd3Yz?=
 =?utf-8?B?bjFOUDFodXMvZEJFWU80bDErcTVwUTBVZ2pDMTdNb2o4c0hxVzk5UzdHYlBu?=
 =?utf-8?B?VStHdmx1cW1qLys5UUFlZkliRkhZM1VyVHd3VW1mUEZMejJpZXlQT3RmemRT?=
 =?utf-8?B?WktIOXZna0NVSDArRlk2N2pMYnpiT0FJM1JDK3BUWmxGVCtkYTN1ZUdITnVi?=
 =?utf-8?B?OWVNczYwcDZ2WmpjcXo2ZlZLckdjclo5V2VWbjJBdVpudjR5cUJPSmpXL3ZU?=
 =?utf-8?B?dWYxQU9XbWh6RjdOR2F5Q09WK2Mwb2NjdzdsbDZPRjNOU2lJZmF4MWpXYUo1?=
 =?utf-8?B?ejBMRzYweDBaUDdnVm9rNEJEZjN4QUJYb2JIeHRVcVROTVpFRWdRVlQxVEV4?=
 =?utf-8?B?dVJwbFUyak5uSjl0ZkxHeTB0T2tuekViaC9wT3FIdzZjakliMit4MWwwdnlH?=
 =?utf-8?B?d01BbTFobXhrd1o5dFA5bUhCMUtraW5FUk5rVW5HS1ZmcXpvU2NrUm5RQVBx?=
 =?utf-8?B?bWNTdmxwdDJOSEJ3SXlIczBSbGFtOFY2YWxvLzdEZG9wLy9UMVFBSXFrajBp?=
 =?utf-8?B?TW9LNXJ2Z2VXbE9VU051Vms5bE1BYUZZbVRPWERvbHN5ZUg0WlcyajlzQTNv?=
 =?utf-8?B?WWZIZDFFQmhEbVZMR1QrYkgrRlorV2pkUnd1RVIvODVoUTROc0FIV0FJd2hl?=
 =?utf-8?Q?Szi3CivIQOKyYfF/uXNq3ro=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7315bb90-98b5-4ac2-2363-08d9fbef7fb8
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 01:53:51.0352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YqJCfvUibkpMBVnkJmPiAxjrjUzxHRE1L/oVbxQ9LxrukLei+uvIgeR/zpDBDU+6qGewINSxlqp0DAURRz3xXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4061
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/1/22 15:19, Nikolay Aleksandrov wrote:
> On 1 March 2022 11:03:14 CET, Tobias Waldekranz <tobias@waldekranz.com> wrote:
>> Make it possible to change the port state in a given MSTI. This is
>> done through a new netlink interface, since the MSTIs are objects in
>> their own right. The proposed iproute2 interface would be:
>>
>>     bridge mst set dev <PORT> msti <MSTI> state <STATE>
>>
>> Current states in all applicable MSTIs can also be dumped. The
>> proposed iproute interface looks like this:
>>
>> $ bridge mst
>> port              msti
>> vb1               0
>> 		    state forwarding
>> 		  100
>> 		    state disabled
>> vb2               0
>> 		    state forwarding
>> 		  100
>> 		    state forwarding
>>
>> The preexisting per-VLAN states are still valid in the MST
>> mode (although they are read-only), and can be queried as usual if one
>> is interested in knowing a particular VLAN's state without having to
>> care about the VID to MSTI mapping (in this example VLAN 20 and 30 are
>> bound to MSTI 100):
>>
>> $ bridge -d vlan
>> port              vlan-id
>> vb1               10
>> 		    state forwarding mcast_router 1
>> 		  20
>> 		    state disabled mcast_router 1
>> 		  30
>> 		    state disabled mcast_router 1
>> 		  40
>> 		    state forwarding mcast_router 1
>> vb2               10
>> 		    state forwarding mcast_router 1
>> 		  20
>> 		    state forwarding mcast_router 1
>> 		  30
>> 		    state forwarding mcast_router 1
>> 		  40
>> 		    state forwarding mcast_router 1
>>
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>> include/uapi/linux/if_bridge.h |  16 +++
>> include/uapi/linux/rtnetlink.h |   5 +
>> net/bridge/br_mst.c            | 244 +++++++++++++++++++++++++++++++++
>> net/bridge/br_netlink.c        |   3 +
>> net/bridge/br_private.h        |   4 +
>> 5 files changed, 272 insertions(+)
>>
>> diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
>> index b68016f625b7..784482527861 100644
>> --- a/include/uapi/linux/if_bridge.h
>> +++ b/include/uapi/linux/if_bridge.h
>> @@ -785,4 +785,20 @@ enum {
>> 	__BRIDGE_QUERIER_MAX
>> };
>> #define BRIDGE_QUERIER_MAX (__BRIDGE_QUERIER_MAX - 1)
>> +
>> +enum {
>> +	BRIDGE_MST_UNSPEC,
>> +	BRIDGE_MST_ENTRY,
>> +	__BRIDGE_MST_MAX,
>> +};
>> +#define BRIDGE_MST_MAX (__BRIDGE_MST_MAX - 1)
>> +
>> +enum {
>> +	BRIDGE_MST_ENTRY_UNSPEC,
>> +	BRIDGE_MST_ENTRY_MSTI,
>> +	BRIDGE_MST_ENTRY_STATE,
>> +	__BRIDGE_MST_ENTRY_MAX,
>> +};
>> +#define BRIDGE_MST_ENTRY_MAX (__BRIDGE_MST_ENTRY_MAX - 1)
>> +
>> #endif /* _UAPI_LINUX_IF_BRIDGE_H */
>> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
>> index 0970cb4b1b88..4a48f3ce862c 100644
>> --- a/include/uapi/linux/rtnetlink.h
>> +++ b/include/uapi/linux/rtnetlink.h
>> @@ -192,6 +192,11 @@ enum {
>> 	RTM_GETTUNNEL,
>> #define RTM_GETTUNNEL	RTM_GETTUNNEL
>>
>> +	RTM_GETMST = 124 + 2,
>> +#define RTM_GETMST	RTM_GETMST
>> +	RTM_SETMST,
>> +#define RTM_SETMST	RTM_SETMST
>> +
> I think you should also update selinux  (see nlmsgtab.c)
> I'll think about this one, if there is some nice way to avoid the new rtm types.

yes, since these are all port attributes, seems like 'bridge link set' 
should work

Tobias, can you pls check if extending RTM_SETLINK (with AF_BRIDGE) is 
an option here ?

ie via br_setlink

