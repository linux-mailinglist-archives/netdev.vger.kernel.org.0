Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3CB4CA1AC
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240172AbiCBKEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236513AbiCBKEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:04:43 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2079.outbound.protection.outlook.com [40.107.223.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9D45FF0A;
        Wed,  2 Mar 2022 02:04:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MRswd6ZptCacQjK6/XLe2KVxiUQWB0BQf/Pn9+5/4s2xNSPU9zayAACTRGWTS2g5FsJyk8BbjX9IRqSdkpH5hHEn0R7WsO4bJ7H0YXezkuoahpIHHaYL+mETYaO/OSixAltyzMuuxKV27Y/GH3CLH0o5y2QE3sescfZG5act1UUk5UpnVLw4tm37WbhG5RyFi4KrG7NJjiL+PoZtBXMAaOa3DZUub6+NrC9B2EmAN7p3lLlXBkmaqHaa02+62e/aoLT53iq+P3e5u7mxsXoCPX0SBJlVaPOQLBC626Bh2LEpPDrQamb2+gliZmBtXoiCSgCEurepgaIMBLB4b0WZ6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLm0v6IQqjdX2BsCLWA4UheZtoyS8dSurL5MuqKiRbs=;
 b=APUaNGJFAzGiI5KImMnlNkJv2QShU6BEwNk4mRd1JhU89jDpyfw+PTXf+JbXUC1w3brkFSeK1P0r8fNDDDw6lDRJMtKsDR3EUqCuSenEumx0JjUmOOtpdyBFyDQqX15um1wDJwJtizpCx8Pu5NEPmVhT6c0a+aH5a0X2DEWplQRdy8eS4REyN2Hc2KGU9zmIrclE1a0WxBgLDT1vhEwUAQsnuwOO2Hgv1q5fdIbbm5aJcj9mvd6sbdfsbBMlW2PQNAckmH74luuwhs2CT7BpQftbX+GwXF/EoSnZDtayVaM6OSDFcyyegGMYOCG/M6muxN0M2/H0u1kW7+ebb+rC3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLm0v6IQqjdX2BsCLWA4UheZtoyS8dSurL5MuqKiRbs=;
 b=IhRDOElnyLYJgCSOHOLu9VSCdh9GfMeFGAEoFGBWgwbkfvHnCTTs3NmN3mGPTQxPyV4Jh0hSDI9MRoHf8wsgkbCmJ9/L39CKNeIqC+h1kM8CLZtIeCknV6UJbtV/NE7FS0ia7L+ZwlMpBAlJ6ZW0MtqSevT9Ts2l/Mk0jlneKEEeGs69VYR2pEt9qVejidntYVcdle6d1Fmz3fz85WmKaTS7qMWQhgzhMOIlV4NM3ahLL+VyXqdaLtv9e18/7VEChU2CwnEhjkPg5C4Y574H7tzobVg+J/Vj9eq8YoSA005DFJUFxDXvBUCTjSh/kUZTRF86RIKi1ptKCPDQWuYVBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by BL0PR12MB4723.namprd12.prod.outlook.com (2603:10b6:208:8a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 10:03:58 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 10:03:58 +0000
Message-ID: <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
Date:   Wed, 2 Mar 2022 12:03:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0067.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::44) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74c36340-b6ff-4860-ff56-08d9fc33f7ca
X-MS-TrafficTypeDiagnostic: BL0PR12MB4723:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB4723FE7994E638C3BB1131DEB8039@BL0PR12MB4723.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ooa3KRehJAJR5INBG/KTKfL51vlw9aIuagDEFFeBd/YoTg7k69YrEzwca/3AW3+SWF/R+x6G1rMr21QFu9y+p6ag5m3W+f/fuAOOOD14328+qpTBAglJdlWvQFRLhZFdByOL6YdEZCc5hD2pFCgN4BtvEf3pQ8DmhBgr3z5stZk3gsMKuWeTjTHzvdETM1iFbPhINipHkouKEC45UJ3me0WLRIAiKlykrSf5xqaYeVCC5sCibFj+ifs0zZb4Vl2FW1DkobA/LYN4YiRSg+g6YdI2u/gCShPqcXmcZU8wj4O4xmQQ75m8YTzKfbterbU0j8IiCwzmVy6auUFgf43BmOlClcV5EVSK49R+0b5o6JjHEQtbOkESsCpdh7RTNmodvMF3VjzntK9BkXhjz2Z4ETNY8q2XpWngJqe4GzN7l4qwxDgJS05VJ7FxpHm6A6s40MeTCQE4vWwSJOvmxz+ZSWgOwjAwrNW8Q2lKhzi6Veg/nmfQilT6CDAdM6EbC1DlUjJ5XZzejpZLGJQiK4H9ftugllqWXOuJ5svj1UMjJAvRRtwOLOUkiHEIBehwvmy8sNm1Bl/Ou8k6imBqU91PDAirc9FCajluVd6xOfQu6GaNalWPt+y9ReKQbFFXn8GaqX+ubEHOsoG5lKNjJu9pbFsG6cIX5ybkavRMoOeo7gaztxZoF7tfCSohTjEeSXxiQLieasJfdXZK2h0KFw/F/EBd4k0RYiJH2OkhY8EgAkFc9n63OonofBy1SSo6Jia5/BxH24HOdvrn8/G1aStSChg+fnS2S2mKWsrP1RvJmX2XFxpfIJaGmhKb07MU/FG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(6506007)(6666004)(966005)(6486002)(36756003)(53546011)(508600001)(6916009)(8676002)(31686004)(316002)(83380400001)(66476007)(66556008)(66946007)(4326008)(5660300002)(31696002)(8936002)(2906002)(86362001)(26005)(186003)(2616005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFhjSW5KQXQwem9NVlFEL0cyc2VCYkZqQXJoOFd0SmNMTkd5aHlWTU54cy9J?=
 =?utf-8?B?ejRNRVNCcVdRalA3RlNzeG5zdVRMc09SenE3a2M2MUdDV05kczdWRXovSEkw?=
 =?utf-8?B?b0RSbkZiZ3VGUElCZnhlczYwdlVqb05kbG9TcEZGRWdWb1hSUlZ2bUN2Mzlw?=
 =?utf-8?B?QmRkMFFTZEFKQm1hQlVYaURwMmhra0Y3THNmRnBDUW82VFNleHJNZmJORXF6?=
 =?utf-8?B?T2ZtaWthNlNvSXdyYVVMdGtEa2NMUkExZXBvbndGU1d5UEdyQjdmY2kxeDk5?=
 =?utf-8?B?d3RVcFA2NjZld0hEUGdlRmljU0s1d1VXOXF3OFY4Q2p2RCtFMGM4UDFkcDAz?=
 =?utf-8?B?QkpIT1hqYkd3cjFGMk80cWtWdS9kUXlRaVJQKzR6OWpIOG1BQ1AvdVRpMHA2?=
 =?utf-8?B?VTM2Zi91VElDVXpCRlYrSWpmdi9rblEzMUZUWDVpamRKWGNrVGlqWDhpTUs5?=
 =?utf-8?B?ZGZaclhxUU5ubXpzdWtsUUlzYU0zMlNEMllwYWVtcnloVWZkSlQ1RVlqNi9t?=
 =?utf-8?B?SnA5cTdUSzdCL3FqY3oyWHltcWJjTG1Da3gyMGQ3eFVGcU5XUHZsbXZhdllj?=
 =?utf-8?B?VFgvSWg4cEsvV2tQdUtkNWpIRjBUbDhHRXNtTlpycm5qbXZtNUt1RVM2UXBY?=
 =?utf-8?B?VkYrMTZIK1hwamhFbVRXVmF2UUhqMTA5UTZrbTJ4M2xtUnNQck5ablBkVU5m?=
 =?utf-8?B?MHhCdjVTQWFteWdxR3hyZDhDcmEvYVhrVEhJenE3T05YZWxBcllSaDVxdVox?=
 =?utf-8?B?d29FV1Y2T3JFQlFsWE5tMDRGNEY2T1o1S0xTT284K1dEL0RRVFFXMTc0VjVa?=
 =?utf-8?B?elhyT1plam4rdWFCQy9GcFF0VFJGSEZadU53M251dlMxYk12WTF3NjJSOU90?=
 =?utf-8?B?cnoyUWFwQ3I0bjYzWFFscFhuOHBTSG14WkhSSnhadUJTV2Vza0lYWE9yc3dH?=
 =?utf-8?B?Zzd3UEZoMUJXd3NleTZYby9hblA4b2d5M2JVZFNaTThDZE1FdmdQb0F3Zmtu?=
 =?utf-8?B?c2hJcSsrT09JNnRrSFZjUE82K3VTb3JrblhNUVN0Y1d0S1BtZk9FckJMTmJ6?=
 =?utf-8?B?L29JWW5TcEtKNGpJSVc4TVNXV2VyMkgvaW9HK3Z2bGJtSnJwOUp3R2VwenVj?=
 =?utf-8?B?QVo0Q3pxTUVTem1paWJMYm0wM1JMZEdZSGtGTkIyMXNFSkFTbU1IQVBKSVNp?=
 =?utf-8?B?SDRFTE5WNUlyWnFvMGVqMDFvUnB2bHh6emYrUGNuNEtJbkdJMkVsa0wzZGxW?=
 =?utf-8?B?UStrd200VDFYVmxzQWlVMmhDTVlLQzIxVmxIMkpDclpzdWpVZFUzbmRXb01L?=
 =?utf-8?B?WGJzN2hlaC9BOFBEd2lMd1dXdXlkSXN3d280MjVmMlpPWlZLb3JVaDdiN1M5?=
 =?utf-8?B?V2dLOFhwRnBIMnk2NGJPZjJKSTVERnZWRXRONGR0NHdDd2ljcE5FSG5lSTU4?=
 =?utf-8?B?T2N1OWh3d2lNQkcwYXpZUFdYMFVCM0dQSGwyUWp0NWdmRjR4c2duZmg5Y2hC?=
 =?utf-8?B?LzU4QklnUEQveUZ5c1BvazBhQ05YaUVscENkejNDS2ZvNFI0WThRaW1TbUlu?=
 =?utf-8?B?SXNXT1o4MkJOcDcyRkJBcGxJajVDRllPWkJxTUdBUDVJOVg4Q3ltZVFEcDBY?=
 =?utf-8?B?VzJiVm0wWFlFTFNYQk5wMGk0UDVTTlJTNGU2b1J3RzN6NVRZR0g4Mk5HOVlK?=
 =?utf-8?B?Sk11SWt6eXgyNSs2N0J4RXNSb0dDNXdFQnMycWdsZVJoSWVtcUYwL0EvNWhP?=
 =?utf-8?B?WktXU2pQS2locnhzVWpUaEcrTTAwNHdNSy9ZWlJsUFdzcEdSRktPOWFVSGFG?=
 =?utf-8?B?KzJnZ1FYL3pDeFdjSm5jUTRPa1JTMWlPek0vK253eGRLN1dBQVpNUDBCS3d1?=
 =?utf-8?B?Ujk1WXowRlBhbWpTWmJDN293ckdRbFFDNDkrRk4yMHdlWnpUMW5Ibnp0Sjlz?=
 =?utf-8?B?M2JucmV6ZTR2eE1WZmhhZHJBMFZMZ3JiOEs3ekNNR3BuR2dCSlBJSStOY1Bh?=
 =?utf-8?B?cVR2cWlHdk41K0E1cnhHT1VQbGxsbGRHSnRyaXZNR1hTQnM3endiUHZKTWo1?=
 =?utf-8?B?NDFzQ2dFcTZRSEptR20yODdKVkJTWGZ1LzdueEtCZWZiS1pnRHJ3ZC9kc1kz?=
 =?utf-8?Q?9uro=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c36340-b6ff-4860-ff56-08d9fc33f7ca
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 10:03:58.4049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BVFaH2Q4tMUZUWO2CByBox+H4xbkYk1H+RZiYZuDJRiUoR0QGpidHgUDc1VkWF/S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4723
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



On 2022-02-25 12:40 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Wed, 23 Feb 2022 16:54:09 -0800 you wrote:
>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>> packets can be filtered using ipv6_ext flag.
>>
>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>> ---
>>   include/uapi/linux/openvswitch.h |   6 ++
>>   net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>>   net/openvswitch/flow.h           |  14 ++++
>>   net/openvswitch/flow_netlink.c   |  26 +++++-
>>   4 files changed, 184 insertions(+), 2 deletions(-)
> 
> Here is the summary with links:
>    - [net-next,v8] net: openvswitch: IPv6: Add IPv6 extension header support
>      https://git.kernel.org/netdev/net-next/c/28a3f0601727
> 
> You are awesome, thank you!

Hi,

After the merge of this patch I fail to do ipv6 traffic in ovs.
Am I missing something?

ovs-vswitchd.log has this msg

2022-03-02T09:52:26.604Z|00013|odp_util(handler1)|WARN|attribute 
packet_type has length 2 but should have length 4

Thanks,
Roi
