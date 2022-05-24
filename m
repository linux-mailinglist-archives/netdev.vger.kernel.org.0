Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E62531F96
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 02:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbiEXAKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 20:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiEXAKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 20:10:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B429BADA;
        Mon, 23 May 2022 17:10:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMypU1Lp/rQTkZukoRlpShpLnNAqYwUakenWv2gjrkrflHlYWeW/juFbMOtDr/KcUDOfDuMY3GeTACImG7qHzegdguJC/ZzvQNTWc8mo26li1Y0jG7tjc2aCFMMPTesaGtu3yff00Zw7oVgyhrbvX7ySewLFsrp6RcupJyCp6bjcqVPMBrfOKo0yOsjc736x4++VZxmxgO7NU3J5F824PuXuD4dbfVJvhzNy50eVvFVJuc/ArmPumoGjHDu/PcSURPCcqePi4q4yknI6i6fX84CCDO57+tnsKARmcrpq9deBjHeKuaWrv/SqR4dS8854m3SnwcdooYOY7Dp8IS2TkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWpjzRCuebLmtgJaFdxWT2aiWBxKxtji4CLbYtYPG7w=;
 b=QoUQWNwvBqwkdCbFqC2ydCbI6GY1btNz1dSInyMti78o6npemZMGKLiWWZNhmZNFrTjvnNP++9r4lR2AZsBvhgEGzvGaxgTm/I25GAVdTQs0JfKwKzX4BhWkXNDFKXEiQI6lttGP0l+JcWgk3YvRDQu/p7/ukxpTVjl7iR+KcqXMcH5cxRA96aURuz/1QDSw4eiyY7ynkye7MwzNtpGBA4ufj/ETzfHQRqCTtCvDTbdngMw2vcw4lQu4yU2+a8/ZmZhDoQdzG8+sgyrRxc0JK1avI3MKskMQ5A3mUWJGjiQE07sbEXbHwFQVlVky1Q2Grfo162hVxDObZCgmKISM2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWpjzRCuebLmtgJaFdxWT2aiWBxKxtji4CLbYtYPG7w=;
 b=mNvlcoLEv1eXBcr8jfQlsTkHIfAuuiVNG/MOJZvjlFHwUlFa9truBLTKHH68kDbbJgm1P5+fA1jE3wVVYXAji7oGiBKklAkzxIrl0ygARlxwvDqnSN/SacHazhupAiBzF64sDrCwqX9/lD4LMcsQK58MpeXbbZcjBO+n3Wq6udPnKzXZvkHUzLd5zQA0quy+Zr4PhUnsYpF0IdrH2qfqBb44CsOgDS8Egc/RfkSNWBnbPgFjLSeaar7p/BJa1T9iEkLtLVETKY5tr9ifihUkuzlhTxeK+uPz6WgYSr1QjhKvnZFGfaNp74Dc86Ws0vTooUj0MSmzDuExgDHCC6no4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24)
 by CY4PR12MB1318.namprd12.prod.outlook.com (2603:10b6:903:38::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Tue, 24 May
 2022 00:10:09 +0000
Received: from SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0]) by SJ0PR12MB5504.namprd12.prod.outlook.com
 ([fe80::ede1:a4f9:5bf5:c3a0%4]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 00:10:09 +0000
Message-ID: <237b793b-ab52-4ff8-a2a5-44923f79da40@nvidia.com>
Date:   Mon, 23 May 2022 17:10:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org, outreachy@lists.linux.dev,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
References: <20220520003614.6073-1-eng.alaamohamedsoliman.am@gmail.com>
 <7dbf218e-1a9a-13a4-6b6f-0e23899fb1cb@nvidia.com>
 <20220520174020.3cffce01@kernel.org>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <20220520174020.3cffce01@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::11) To SJ0PR12MB5504.namprd12.prod.outlook.com
 (2603:10b6:a03:3ad::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6937854-4211-4c7b-c6b9-08da3d19c3c0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1318:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB131807A686BC7CBC301D7413CBD79@CY4PR12MB1318.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oj0LIvNjsV8R7d8AuO6cH6BgEOe8xl6mmIyYib2a6AImYbL3FW+ocxbeORB/QvLLTOrX4JVAa27JXwfaL8UQj0EJK4BzYf2wb0RL1NEWYqy+QSTyUoD5ARsbnPNxjWunY6elhHG0/ciFRLrTit1AxWYV7zUZER7I/A71QDGhW52b3qAsDPNqxZL1TEEyBTrQgOz+dShqjT/6LYUx5s+HQl/yHiL7EipubPuq+P2FQxfT7YF2S9CCTbZdk+lWZEitPObnNZ+TCtmleNs9WADUfgOIDvJyROZRKWq0x89Nce+O+bpyPUuNqixzYKAfroREr4/02bbR84hmeMCFL1H8jcFhaigiUwLrqiLcmEt4r24uAfWhU5MvuxMbOyBlmQgTr+c4WADAvwTETjbygh7QLFvBdpU1uiS5Kaq34ThPjjiFkv8jddUieSif8utS8v9+e6Uo53VMa+XvyTt1KeOtjXNj4/ZC1SXjzd4H8j3QVdjATklHY4T38CVLCjlsfyHW6tiX9/AeG7Fas8e5CC9yorJmcDW/5lt3nryQT2Wh5ztVncJdkKH4c0f/IOV1GvNx0dM+SaZzlmQxmJnZr6PbSomys/IQ5areXJK1+TgyG/k47kuYK864XcIpext++xIqF8BCdWLwj0NAYLR3oH9J62BA8jYDTtYUZSJPQsGbd7wVwZG4+5FsrmkMIUHkt0NE1O33NQ3mv4zHuz9XaJdkIwVlPDbzZ+i22kLUtuSk0gmS2OU4fsIWCkXSzG2ohdC9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR12MB5504.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(8936002)(4744005)(2906002)(31686004)(5660300002)(186003)(6486002)(508600001)(6506007)(53546011)(31696002)(66476007)(66556008)(2616005)(6916009)(66946007)(4326008)(86362001)(6512007)(26005)(8676002)(38100700002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGRCOXFqa0JYSDgxdWt3UzVpTEJaZVF4T0dqMWlsMWI3U0JXMWZkSFh5M3Fj?=
 =?utf-8?B?eUM1Y2NJaXF0bXRRTE5SZWFvTVQ0SXJJakhuV08rUkc4dld5LzR3TUZ5a2lj?=
 =?utf-8?B?MzhhQTJ0TXFpWnNrZUpCYmFzTmV6VjVKeDNycHFPOHhSTkNHMXJHbGRVbHZ6?=
 =?utf-8?B?cDZlZ25oVEJ1dnBNZ2J3NjI3eXVaZ3J4L0FpeXZVVldwZXJWaWw1ckxRK2d2?=
 =?utf-8?B?V01xb2c0Ymh3b0w4SWZqSW0yVkdzRHdmQk5yM1dzNDNrRHZURnVKdmJUSzFh?=
 =?utf-8?B?ZGFYL205SmdodkVuZzhiSGJMUDhsTnJ2NGxrZUQveTlsQVdKaHg4K2RSNGZa?=
 =?utf-8?B?MDQ0aWNIUTd6NGwrMy9hQnZucUtsaFBNd2JLUjlDS204K1ZjTWFwbk9SWUdo?=
 =?utf-8?B?K1FjMEJKcWhYUUxJdWZIdS8rY2pObDFCUVI2Q0JxSHlLZ3NSNWlVbVhYZzgx?=
 =?utf-8?B?b0NwcUhkbS9lY0NUdjlnSCtQMUMrbGJjQlNDOXJHdmU4ell0b25Nb0QwSzgw?=
 =?utf-8?B?TWxqOVJXSnh3T0tJODlhS014MW1ZK1dsa1RBL1Z3ZjcyeU1iNGdMZXUzcDdn?=
 =?utf-8?B?c3p2Ulowdjl6T241bUkzUjBUTFJNUi9MRXdqM21DOUZvQklKR2hhNWRRZkd0?=
 =?utf-8?B?cHo2UC9wcFJ0czlVTmdYaFp3V1NHeGtFWFlXWTNuQVg1WTZlV2psaGc0WnZP?=
 =?utf-8?B?ZmZxQytvQlYrRDBPcGFlTXdpMEYrMnoxc3lheDRaQnRLVll6bU9PN2xsczRs?=
 =?utf-8?B?eElzQzgyNFBVTlJObUMwaFZxNk03aUhsblliSGVjOG5wbU5oeWN5elB3Vk9z?=
 =?utf-8?B?VGlBNmhCay9Va2ZjVFJMZ1FyTERiOVF2aTlqdUVtaW5zQ3pNdnNSclpadXcv?=
 =?utf-8?B?U3JCbEZhZ25PZThKdUd0QkRER1N1WnRVVGY5SDVkckxCa1ZoN3VzbGIwbHY1?=
 =?utf-8?B?UG5GM0JrR3d1eDYvNGdVaFlJb3gxQ1ZpMUxXTUJWVXc4VExmcDJDZStCekhZ?=
 =?utf-8?B?SCtRdnIvaWVSQy9Rd2dITDRnRXc0T1BEOVY5RG1uSEZzOEowQitUNFRWMlQ5?=
 =?utf-8?B?ZkpJKzhyZTc4Z2RMcWZVc1BJS3REZG9ReGdWbDBrd1NzNjBBQURabzJjUlUr?=
 =?utf-8?B?WE0vS3BONW5zd1piYkx0RkVKc3hMZVJvZzBsL0RlT2V2TWVYMDFYUHlDYVRu?=
 =?utf-8?B?MFlMcDF1Y2xWeXB4TXBwVmJuK3VxYnh5dlJscDBQTVlyZWFLVGhLY1VnZTVB?=
 =?utf-8?B?TGd1MmxCNGFVeGpSUEpOYU9mN1hKc2J1ZGl2K0VtSm5WMUxtZ0grOWZFblJn?=
 =?utf-8?B?dDNrNFYxd3dncmpWeEtMYWlsOFBqVHhhdUVKSUQraTZmWTFFOUdlOEdkTGtQ?=
 =?utf-8?B?b1RQM1lZN09IcnpHZUJiL3dXbVdOY1FDcDlnbHl3aVI0bkZpL0FsRFZReVk2?=
 =?utf-8?B?Z1V3VjFSWU1nRnpaV0tBUVBiZm5yK0NFMVRGUWYvb3VZc09TL21OUVlLM0Fw?=
 =?utf-8?B?emxid3FlZWNRSnU1a3BFR3J1UVI3VnVIeVNMZ2tMTWtKNzF1RzEwQzJSWUNJ?=
 =?utf-8?B?VWx4eGUrdmRGWWN2MEdGZTNsTkY2dXZIUEFBN2d1MWQzL3J1T3BMaktXYWtK?=
 =?utf-8?B?d2NEaEszWTZaOUQvWUJzc096WWpMZUV2WDczekorK0wvcWx3R1l5WGNia3Rr?=
 =?utf-8?B?SzkyTlJ4VENhby84SzlmTWwxWXFqa04vVlhVV0Rqb2lEcTR6MWI1R0d1cmZB?=
 =?utf-8?B?ZWV2YlBzWDVwU0x3c24zRUhpZUlkeDZ0YktjT3QzNWRra1VPNmFlMzlrRFNX?=
 =?utf-8?B?bVFtaUY0MVJkU1JOZmUveHlPWDVKUzdFMk1iNlAwcjRVYSt0R0Z6K1psQmtY?=
 =?utf-8?B?TFBGZGd1dlErOGRTU2ZaTC9nL0NPRU1VTm5yU09jb09jOUMzLy8zRG9JN1hl?=
 =?utf-8?B?UE1yTVBNWTJ4RDc5VkpaN2tSdyt2Q0ZSTEtGOGZaUzNMdlc5SndVMnFkaXlq?=
 =?utf-8?B?dk5mYjMyU2NlMExnaTN3bUN0emowaUpKQzMyazB1U1ZYKzdsQ090Q3dKNUYy?=
 =?utf-8?B?N3lOWjZDZldqbThZem9MRU5haUNTRVhzUmROME5aL3hYQlpMaGlVREFIZEZQ?=
 =?utf-8?B?Mmx3SnJqL0F5NmRKeWRJZFFkVkVWeTN0VnBJcFpZNGVrZ0l5UU5xWmhxNGk3?=
 =?utf-8?B?MEwvUVpWbEVCb1JCS2NaekpZcGRqNjVHL0VrSDRIZHZSODJNZlp1T0tKMXRY?=
 =?utf-8?B?L1BNQnhhTExMTDR1WXVlelZaWS91UVJtQ3NSNjNiUHlwQnZXamcxNzViTHpS?=
 =?utf-8?B?RFdSWkZxMjVzbnR4SmZJaG9FMFdiSnFHeGZoYmZuN1hDdWZsVFUwdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6937854-4211-4c7b-c6b9-08da3d19c3c0
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR12MB5504.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 00:10:09.4951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBsg5kpIPjzbCObN0UtMxz3UpYUDD/JE3wJAyuwUheg757/nDxHXtgtO16Djq4qfOvXIG1fJnqmlOHz5STweBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1318
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/20/22 17:40, Jakub Kicinski wrote:
> On Thu, 19 May 2022 22:06:53 -0700 Roopa Prabhu wrote:
>>> @@ -1138,7 +1138,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
>>>    	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
>>>    	    tb[NDA_PORT])) {
>>>    			NL_SET_ERR_MSG(extack,
>>> -						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
>>> +					"DST, VNI, ifindex and port are mutually exclusive with NH_ID");
>> it looks still off by a space.
>>
>>>    			return -EINVAL;
>>>    		}
>>
>> this closing brace should line up with the if
> Let me just fix this myself when applying... There were 3 separate
> postings of v2, and they weren't even identical :(


thanks Jakub,


Alaa, when you accidentally send the same patch multiple times, you can 
reply on the list and leave a note to the maintainer on which ones to 
ignore (lets add this to the outreachy kernel patch submission 
instructions if not already there)


