Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3065E4CF3F1
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 09:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbiCGIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 03:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232338AbiCGIuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 03:50:32 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2049.outbound.protection.outlook.com [40.107.102.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7483BC3E;
        Mon,  7 Mar 2022 00:49:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReuQavUsX9cHDe67vTO2DcZcm8Vyzm+1Jyd4TUYcrJg1NKpz17I5eN+/gM23Qsoa1/b2gGjNe+7/7W8Gaq0UqFdXiszlpmlLwWVQQpU1lTEJIY9IpzwbIFV6r+MrWtYvghNCE0I3fDWZvj+nY6EW7InSmya8esMiBH3Gn/rDFdx/yToqmhBF6VQuNr5rRW3p5buZ65/Y/17yZfQ8F9EVduGWO7hbGzqxuR2plXPJFHoPNgRwqTtbFg8MAWYfmLjjYH1jNisJlABklxGy9wtsoZ7PQXWOfc6QMbQW5XEINH6pDttRni158LBS5JLuob5Sv1RSb1Iherf1zMlqQLVWuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VKH19G6gwgYQJa3riMwimZXQir0Nhci4wcsjDONJa3A=;
 b=nsV7YwlAE/Ck/AzLUGthZdDZ9ZZCA3vvT4o1rESbIPWvM7moeMuJPsmPW6BtonE5qq8DAbuXMFVLbLDA0VVT25ZrSJ0leZTep5laoRD4Lc4mps5O4txXKPoOTYWIef73FiAE5KAUippIJMc4FSUybQ0Q6Kuqt270KoGuWMZBB10KGjUxlsJ8OWxNONlRoIubeLIrSv+sMVKh+gwQpVA7RyuftHFFQQ1rOAdp1aFpxA388lQno23JUxqBe3t14IUZgDZQtABX6D6ruclSasCcIhZvQ0x7TVmmNzp2xAOzDe2VrS8iL69I7U15VM6loIxkfmFr8EIu9VePk6/rc8HHGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VKH19G6gwgYQJa3riMwimZXQir0Nhci4wcsjDONJa3A=;
 b=UiByS8NJqSCrS4B13QDs9+Tj1rjW8KW2YpM8jrlk2/37H67SAwvYD4BTsQfzdprxuTb4MDq5HkJXm9APhgUxYx6ZfQjtRVO2J9SzixSpYXc7JJp0poiceKndXjxJk8AVXpealRsHiPE82u53nocRI7PAThkyhj198gI5qWnW7375DOlyBe6T8VqQe+2LgkXcv3F1mymIkxtCw87fiItkBS1wVr20bGv9q5+FRIDO0kBa+XOSrbEpxLyMjP7/0vjusiwuQxSj3+u6gjRNSIs01uppDS57jiH3Grs5MZ0mie7JMiTe5JcT/qGkKEg2w/FPtW+gNKgOHBXGIWf3Q3a1lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by DM4PR12MB5842.namprd12.prod.outlook.com (2603:10b6:8:65::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Mon, 7 Mar
 2022 08:49:37 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::dd23:4505:7f5b:9e86%5]) with mapi id 15.20.5038.027; Mon, 7 Mar 2022
 08:49:37 +0000
Message-ID: <26b924fb-ed26-bb3f-8c6b-48edac825f73@nvidia.com>
Date:   Mon, 7 Mar 2022 10:49:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:98.0) Gecko/20100101
 Thunderbird/98.0
Subject: Re: [ovs-dev] [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6
 extension header support
Content-Language: en-US
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Toms Atteka <cpp.code.lv@gmail.com>, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
References: <20220224005409.411626-1-cpp.code.lv@gmail.com>
 <164578561098.13834.14017896440355101001.git-patchwork-notify@kernel.org>
 <3adf00c7-fe65-3ef4-b6d7-6d8a0cad8a5f@nvidia.com>
 <50d6ce3d-14bb-205e-55da-5828b10224e8@nvidia.com>
 <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <57996C97-5845-425B-9B13-7F33EE05D704@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::13) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6d14be5-02a1-4c28-8e67-08da001768be
X-MS-TrafficTypeDiagnostic: DM4PR12MB5842:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5842BB54CC93BDB0033D839EB8089@DM4PR12MB5842.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6LqkYxYEeUKbQ2jBJUwMB8I1FV5BDwf747kqHxQJVc5py+VftTTH2lQkr+ynnHnsvmCMv9g4gaHzKgEnPL+rpeJVm+FmGVKUGizwV2EbAQkfYL71VV+bPGb1r6vunibh3yHOH9RvwkSZdkBHpd3xhZ2T/emZDF8+R8GQVuTeBVC+AOVhDGXXi0Cd2vPAtVRSPqIqQ7KCCJUjpWm+Qg2Gew3nQtMLTd18iHi1UE0pVv/xV7PKntCYrkA/L8L7VIoibMvPMuQzBr5YHYcFBONkISKBVtOfzlCxIMHRWlK4JjiDwzWIIGyAq+ZQR5kkGkKfYzNNh+IPXpsm320sdhCfsfqc1OwrfA4yZ78pr8WkBQ28LSP3+P98jolm4bB1vQeqJ7ALDY63XvyWRpTRt23l66LDwlWp9huw8r1+/02GKS/dP1ETpPz63u9w5JxJnDNXwWcTo7KY3/jC/YH7Z1tHzLFTlMPeKrr5cXVV9KB2TRS9KGM04dAPr4vbxfR8HaS9Xlkb8A0KjOFX71p7/2xxq7NBDeSm3f/VXTgKYreaKgbdlTB0IxC5CbrDsF95MQr5pRNPqsl05ARr+SC9/PO0GoRyn6JmNrj8QYSU3eQ4fflaLX91MZKwludkNqr/3DUudpiLEJLQvXM6S0+i8hBkZRj84mUxcw98eIHqwxE5vJbPN1xioj9LJ2uIbTQCOFId25gpHlSwTUq5zaIHtQjFrCHO0tIkz1xvtezFlG6TWqg2Ma0S4wbG+IFhXAM/aUyxFCdZK0+bpPm7JEbAOrrB3X7I6P9gfcMCzJ0NMZ0+b8BB1rN7Ug5kx0Hg+UT9aFgX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(4326008)(8936002)(26005)(53546011)(66946007)(6666004)(66476007)(8676002)(45080400002)(6916009)(5660300002)(186003)(83380400001)(36756003)(31696002)(31686004)(966005)(6486002)(2906002)(86362001)(2616005)(6506007)(6512007)(508600001)(316002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R3BGVXZDMkNyNGE0OHA2Rlc0OGNLWFdKNW01SElFVTcvU0x4V0JGdUUrTXl4?=
 =?utf-8?B?c2VzZkJMdUgyUENmRzRJTVZTbkJsSHFybUkvY1dTcE1RMmlUSHo1ck5SSFVj?=
 =?utf-8?B?ZHVBTXljcHpWODNldndZR1A1Rlh4WnhvRjFGNjBRTEFBcXg4UURvYk12UDM3?=
 =?utf-8?B?K0dhS1dmM2RlbTM4dDl2cDVra3FzaW4yb2h4TVNCMCtId1JVeWVUbEs4ZDA0?=
 =?utf-8?B?Yy9aU2tDL2xibmlOaXNpOXlPemt3RTd0MWExMDZ0aGdOWVh6ZUx5b1JqM2pR?=
 =?utf-8?B?NHNmRnVPQmVDbzRuZitUeUZqMlJWK0tEZFFBTi9yQ1BrdExEaURJTmxVQUJF?=
 =?utf-8?B?SUdaRGJvUVp4V3hQNk9VaTVjbWswcCs0c2R5ZTM4MTNsWnRzUTRsMTdzdWRy?=
 =?utf-8?B?RWptNmVuSjNzMlFBL2E2SGtpdFMvZUVlTWx4SUxoR3lyUWhjZW5QWXRtTitC?=
 =?utf-8?B?VERmNkVoOVlvK3ZidkVUTGdMQlVjL1NTQ2MwbmNrK2tsYzJIdXRRdzhzd2No?=
 =?utf-8?B?ZmZaZithenBqSzlVREhmU0FycFFPbXJqM0NzMkFTTkllZHFCeHV6MThyNllO?=
 =?utf-8?B?OUVXRDVRSTNVNEpHbjhsQlJSa0pxTitzS1pFbFIvbWtUTHUzQyszTlpvNXZC?=
 =?utf-8?B?VFlxTklmME4rcFE1SzBqb1FoZUFaMVVYSjEzU2cveDZDQVgrTFVJVWdPWndC?=
 =?utf-8?B?V01GQTJ6NDhBZ2FsWTJhMHJncWY1TVZBLzd0c3VQWlVUV2FWeE9jWld0c3p5?=
 =?utf-8?B?VXp6TlBRaWJubXI0eFlvWERCb2Z1Wjd0OGJSQi92Q0d3T3gybjVqR2NWdExt?=
 =?utf-8?B?QU9odFNOQUdES3JVc1lLUU1BeVJ3b3ZZR0hWYWpwVmhMQ1JnQnFlNmxmbUY5?=
 =?utf-8?B?TGVML3pRMTBpWUsrQ2xqOTVWcjdMRlppSHdIOWRmdGcxanlkaEdkRVFzWUZJ?=
 =?utf-8?B?NndUR2h5WVdER056bi9uRWdWTUtiaEpzellON0M5QThKeE96RlZGTHhqQ2tU?=
 =?utf-8?B?T0VBQURjK2NQRVFhQ2gvSy9qc2xPTmdHaFVuZXZPYmNIZGU0My93Vjd1Qit2?=
 =?utf-8?B?TndiOWhJYVcvNHpjdHMvT3k1RGZWUHhuaitWWVpRTG93K3ltY2cvQVNWRVZ1?=
 =?utf-8?B?MSt2a0c5UExPQjVQNDl5OVBJVHBEVE5USVArMWduT0NDdEZjUHJ2cExESWts?=
 =?utf-8?B?L3FuQy92U1VGK3daU25weTJRZGVDYVJ6Z3lkMWtJMzUzQjdXQlhOY0N5UGZp?=
 =?utf-8?B?M0pzOGFKc3FXRkNsOHdLWm1lQlJqd1FMRmFlcHNjS3o0dEJuYVVGL3dLMmJE?=
 =?utf-8?B?VVJENVdGL1lIdUhzbEVCbXg1OFlFRjVXMFo1SFl1OEY5QTBUQjc5UlF6MWRP?=
 =?utf-8?B?b3MwVXcyNkQ3MUlIYng5d1ZJWXFhemNZYmhMRkxZOFQ5MDg4ekJxbzlqOHZR?=
 =?utf-8?B?WXdVOUJqRCtmL1QyMnBtRkJNMjQ3Z3dXVGFXOThqTkdNWEgzSDZLZ1V5a0ti?=
 =?utf-8?B?ZWFaUmx4aHVTa09sK3UrM2NpK3ZIYWVNUFlvSGUyaGNNYy9QcDFmWjFPU09x?=
 =?utf-8?B?OW9yeGROUk15eWoxVFplWEVROGVFTHZUdHM3S2laQ0hZVVE3eW1vQWxTdjVS?=
 =?utf-8?B?am8xQXBPMDVURkxCYzdPT0s5RTBvd04xTDlQQjRYM2FYV1RxcUdETTdreElB?=
 =?utf-8?B?QmV1azB6OE5sZDVQR1JYRlBCa2gxWncwWi9pQWl2NkphaFZVUDlDdW52MnpZ?=
 =?utf-8?B?dGM1TUQzL1NkZkx5Tng5blR5alZsWTYvdG5DaHlWUDhoSmpTYkpBR2d5bGRp?=
 =?utf-8?B?SjdMZ1NzUlVleXo5V0h1bFJtOGFjRUNjY3BrbktZY3cyUFlKRG1VU0hUWFZL?=
 =?utf-8?B?ZUJSV0tBNnNpUW5yczJFZXorVGZxODRrWlVWTkdjK1g0OUFCdURQc3ZoZXh1?=
 =?utf-8?B?cXdSOXM2TUN1WmJOTkFFdGZ4RlhXYUJQblQzbFlMcnJRcS9MTTJWczR2aUJs?=
 =?utf-8?B?MnV4d0JKM1lGaDBkQXNRYVc3enVXUkxvWnRiZWwvbFRsWms2cXZGR0oxa1Fz?=
 =?utf-8?B?QUhEWDlCci9Lak9haEZMNkpsQUZ2K0FtdmdtVmFLNUQzMUQ3Z0MxY25vajRY?=
 =?utf-8?Q?tLPI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d14be5-02a1-4c28-8e67-08da001768be
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2022 08:49:37.0725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdNREpw2yPVcrCGCd0OTLIFljDdI9YP7SUnjpjcrIHcIYrP6szUWaUIMDinS/6A3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5842
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



On 2022-03-02 3:59 PM, Eelco Chaudron wrote:
> 
> 
> On 2 Mar 2022, at 11:50, Roi Dayan wrote:
> 
>> On 2022-03-02 12:03 PM, Roi Dayan wrote:
>>>
>>>
>>> On 2022-02-25 12:40 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>>>> Hello:
>>>>
>>>> This patch was applied to netdev/net-next.git (master)
>>>> by David S. Miller <davem@davemloft.net>:
>>>>
>>>> On Wed, 23 Feb 2022 16:54:09 -0800 you wrote:
>>>>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
>>>>> packets can be filtered using ipv6_ext flag.
>>>>>
>>>>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
>>>>> Acked-by: Pravin B Shelar <pshelar@ovn.org>
>>>>> ---
>>>>>    include/uapi/linux/openvswitch.h |   6 ++
>>>>>    net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
>>>>>    net/openvswitch/flow.h           |  14 ++++
>>>>>    net/openvswitch/flow_netlink.c   |  26 +++++-
>>>>>    4 files changed, 184 insertions(+), 2 deletions(-)
>>>>
>>>> Here is the summary with links:
>>>>     - [net-next,v8] net: openvswitch: IPv6: Add IPv6 extension header support
>>>>       https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fnetdev%2Fnet-next%2Fc%2F28a3f0601727&amp;data=04%7C01%7Croid%40nvidia.com%7C41e35b6733e34dcf628708d9fc54dc9b%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637818263683241778%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=iaysgYLANYFQo87ELcK9KMesF6u7pWF3cGAHiKB%2FM1E%3D&amp;reserved=0
>>>>
>>>> You are awesome, thank you!
>>>
>>> Hi,
>>>
>>> After the merge of this patch I fail to do ipv6 traffic in ovs.
>>> Am I missing something?
>>>
>>> ovs-vswitchd.log has this msg
>>>
>>> 2022-03-02T09:52:26.604Z|00013|odp_util(handler1)|WARN|attribute packet_type has length 2 but should have length 4
>>>
>>> Thanks,
>>> Roi
>>
>>
>> I think there is a missing userspace fix. didnt verify yet.
>> but in ovs userspace odp-netlink.h created from datapath/linux/compat/include/linux/openvswitch.h
>> and that file is not synced the change here.
>> So the new enum OVS_KEY_ATTR_IPV6_EXTHDRS is missing and also struct
>> ovs_key_ipv6_exthdrs which is needed in lib/udp-util.c
>> in struct ovs_flow_key_attr_lens to add expected len for
>> OVS_KEY_ATTR_IPV6_EXTHDR.
> 
> I guess if this is creating backward compatibility issues, this patch should be reverted/fixed. As a kmod upgrade should not break existing deployments.
> 

it looks like it does. we can't work with ovs without reverting this.
can we continue with reverting this commit please?
