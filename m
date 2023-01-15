Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C7866B0D7
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 13:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjAOMEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 07:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjAOMEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 07:04:20 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA41959D5
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 04:04:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXPGDXid0n1PKbhfgP3SqHKPBibjLgsCz4aIfCIQQWc7TjOt3WXzuh1zWiOQURZJ64OVF2NdxAOYSnQehHO+kVuhsXViEi6Z2sxFt1SGLeuya5vHaRl2C1vgP4Vj5TBkkPcHW7FRiUKSHZ55CzuGWuNYBekMGmNaWiBVa94X5pySWGyF7LmUeSQYPK0ncLHj3HealCSlnl8RkmdqIMB6ozHut8eq1h0vq6uFH6FXgyxjXVeoAZegkvUIpz4X/2+ud9adpqvmt+A+btI58TUScrdZhvR9loQ9+qsTop/3oMDb2zlFvxcv2lNj0gNulDiVyMaezJl6JJ7Vf1UVKBdAdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LvCNRrynRZgRyK5wKnAxGQ2EdoGvIxtMy4q/C6mZfpc=;
 b=WHbHnvCWHnOSysDQBDy/7BuwRn9uH57zfVcZfDLe2Q3Eoy4HE+TVh3q0RXE6Tj5feb0QEzH/qR8J/0fqt3PmNzFBMnnC6SWcZAyARO7BaIsntoh2y4SjKEgqVv83edGLg1M/FbgpA7kSoey/DCTIaNubqiLgPpNpY+r7mI2rNoyuZCQMEHxuxsD+pFS6M6czDpo2mI0jQrm/abEZL14ltRyv7965uPylE+KVelLj4/IxDaYUV4qdTkHeusYBoQlhfyuL2Sb6j1LewAocvyd4dGRDCCDspPSB6A+eDego89dRD0nriAD6xbv6vH6ybCzyzLmtmMIsy4EjZxGE7imsYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvCNRrynRZgRyK5wKnAxGQ2EdoGvIxtMy4q/C6mZfpc=;
 b=Yp/mol+IlTANeEGNd8/lmJxKopfUaoKUbdY9auAwVD0Z2ObPnFfYWothkZPfYugsVZSgrwPVjnerqEDdASClMgc43ZuK0q48k1EzFCGAtiwxJ1N6PYSxlDeTC+BUU/ug3TTaNKObk75R2iotw1ZHvDuo9aRO3u9Dos66msvcpjmbVnAjGAHVEjRdFPt9t2jp342IBIj7Tz7ANlQPnNXUSOlnBmD3EinVuAgme/tK/owk1BQdFJ4mpmUFzDaPGBKbir5+/v1Ep3YLK3YwVkfJa1QwbErs9VB7mHfP3cFG+FVZ/JejgUKst4vGEXN+vcONDjYMDXsCK0FHF41AEcO1ZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Sun, 15 Jan
 2023 12:04:16 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::5e6:6b81:fa63:c367%9]) with mapi id 15.20.6002.013; Sun, 15 Jan 2023
 12:04:16 +0000
Message-ID: <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
Date:   Sun, 15 Jan 2023 14:04:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
Content-Language: en-US
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
 <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0015.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::20) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: 22aaba78-d42f-4c25-7340-08daf6f09feb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56wtv5DTSas8mt522kVxAGgoztZyeSxExMuQsfoQ7wcGTcA/ptEu1dkUeg6yqvOBMuUnOYoB2WzResjasUq8YRkEqGcRhVh2T8dfNhTpFan8/D2MaQVg7LSc5ukkJIqkuOBgHXwe4lD1/nOjvLvfOyGNBvsAhRWnA/subXGDOImOcTe0caQ8OeleMA0lJfSL6JR2z+TtMcDzXujFohfQq934hwj1rcy2tDsEZ2ZssTJWGidvHgIZyvUilvjjHLvF7g/Zyn3wlqPZlHKkun5WjBScDvOmJmOmA7tkv57KmmpQqbHVd2AS7zzrFuA9t87630o4mO6T2KNYLUgt3LjnOcYJY/x+jCy/BuA6StTKiifU8ARsfWQjMUys4TRR/g+QTW9vqXjde2/N6VHi+MQ4KI4BKMFwgAM12ZqcLLc8Cqb07yRmU/aB6r/EPoZYNKFW9518bMVksvqZB6F9dFsy2X7oYCKDxK+df3vBaN+bDVLKF1p7eWwMbueuqcjdBl90ZGUFycO2ErB8QqpOnkoC7b0Qhg0Da4hhh5NSvSO67PYMnsZI6LBQcw2xCm7O8FLRUsAHn2R4nl7oXTjit+lPmaT4hy2pjhhMC0UsZgJzLgUsOWR6HHChY4mfBLBwjT10x68ALogMqaWnRQYJvIb6K7J1AVcPfsqOqKUB7CHAwPLWiao/ZSC9v0m2NT3PTwMezRQbH6tzM9PvIlNFj4HhHg33We3oXDUX1WSxpPLLfNo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(83380400001)(38100700002)(86362001)(8676002)(31696002)(2906002)(5660300002)(6916009)(4326008)(8936002)(66946007)(66476007)(66556008)(41300700001)(6512007)(186003)(6506007)(26005)(53546011)(2616005)(107886003)(6666004)(316002)(54906003)(478600001)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmFQd2Y5VUpkVWk3MWxBYmViQ3c3dUNEQmRrQmluWFNueW9QSkhVWkpOWXB3?=
 =?utf-8?B?NzJiZExVdGlYenRuV3NRSW5nRWFwQkdxOTB4SXdsazE3dzhpb2pONkVIUloz?=
 =?utf-8?B?VS9CSmVidzFlYzBQeGNydzN4akx0TGU2K1oyL3QxSGxmNjkrdlVjclFHeVY2?=
 =?utf-8?B?QkllSk84blFVdUVCaksrVXhPMjBPUGZRaUF6ZC9KN040ZWgvSjRlMGdBNm1w?=
 =?utf-8?B?TkFvdUl0Vmd4ZHBEM1ZsSnppRTVnaHhqaVhlQUFwcW56dXFubmcwSXZHRlBt?=
 =?utf-8?B?UEYrTFo4R3JuM1ZVVk0rek1pRmlmWjFrRkg1NndBcFhrdk9rR0czUUV6ejRm?=
 =?utf-8?B?Y0hsZy81SVk2UXJEbnpQTTNnb3JLTU1UenNDa2t2cEVvZXp1Y0UwQWMrNFdo?=
 =?utf-8?B?R0J3U293a1M5a0doVTlYQlBSM1hXQWlxT08waVc2ZTZ2UVFtYUdOU29aMmQz?=
 =?utf-8?B?eXpXeU9PdzNQblhrYU1YRHRMdys3a2lZaTZSU1FhWFkyektzU0lVRVdnZzFh?=
 =?utf-8?B?T043OWtqVWljQkFJSUZPeGtqTmxIVVIwMEVIa3dZaDJvS0xzelFuUVZtM3VP?=
 =?utf-8?B?c2l1UXJoVGRDMTZiaERDK1lEWE4vRkdvRUNSY096bVdGSkNObFF3dWFLamxO?=
 =?utf-8?B?Rkh4aVFja0xEcThRdDJTTUZmM1NUa1VHZkNodjNVaTlWeWFvNDMxZmVnblZW?=
 =?utf-8?B?c0g0UmVLdndHMmRDY3dYV1A5Qlc3bVREejlpUXNzSmhoOUtuaVpaak1acGVD?=
 =?utf-8?B?c3h2UXB6Y1licTZjRWlRMGlKcEt6cmRrQnoyVXRpYU9kRzRCenN2NVVqVlhI?=
 =?utf-8?B?M3pIVSsyK1kwNEp5dlhUaHQ2Z0Q0QlNIRlZQQjJKZ2RHVk80bzZzME5Kcytl?=
 =?utf-8?B?bWtyWktlaHU3ZUkvR2VmdkltVW83V29nS0I0eHEwSEt1QU4xQWZQV1o1L0NH?=
 =?utf-8?B?WkxCL1JWeGdyV2xUVTdaUmV3VEVhVGFGeTZINkNZYjJUWmxRT250UitBd1pN?=
 =?utf-8?B?b2t1TUh2YkdEUVRJaitXSjdneDdWaXJqOUNWd3lYNDdrNE56aUc0NVRubUlp?=
 =?utf-8?B?ZU02YnRTRnAwMFVidWRMZm85dFVEenBBSFhpQUgvWkUvTkpIRENmV25McFVz?=
 =?utf-8?B?RHNTVzQrcTVJbWpPTHBMVzNWMkZsOUxUVVkyNDRSY0hRSmJ5L21aZWZKQVR6?=
 =?utf-8?B?REh2NEpJSW9NbWNyQm56d3NGRTZrSjY1dnYxUGJpS0dSMkF1cWpLaGNyVERQ?=
 =?utf-8?B?YklFVHdYMmt2dUFiTTlIQTF6cEJLYi9qb05SVytzbjVNZVpEOUI4U3dEYkdZ?=
 =?utf-8?B?ZVErRE4rUlZpaU0va1QyVjF3QjRZRUtyUVVVcVFRZGxkeC81OHRKVVhqd3VV?=
 =?utf-8?B?V1VOM0gvdzFhaC9Xb3FTOXF1eUU1RVVCMUZiajl4eXpPK2NNRmlrdXB3ejNq?=
 =?utf-8?B?Tm5OY2hyN25EL0p0dEFjSndxWjV1YmdNc0cxZkgxd1pPbjM5RHMwemthSWFX?=
 =?utf-8?B?ZDc5aTdKZ05EdDhrZGMrTHd2OWE5UW42dmx6djJKd2lISzl6Tk5iZ1V6Q2Q4?=
 =?utf-8?B?bUNaSktUUzEzWGlLMURNUWlnMDlsL3VjZDBtaXdWbE1haVN6VUFFNTBhc1BV?=
 =?utf-8?B?MDN0YnJhM2ZIUlAxSU1RNmJOODE3RWR2WXZRRFJmLzZzOCtSWXROem5GYW1z?=
 =?utf-8?B?R3NZZ01JQmF4dGNDSE9QZFp2U2ZEVXFLN1JPOWhNOVIwOFRHUWpnUnJ5bGR5?=
 =?utf-8?B?R1p2V2Vaa1NGSk9hMnIwTDlzM01hVlQ4RFduMDdoVjdUYytwVjM1U3Q5WUVs?=
 =?utf-8?B?ZzZKQ0Jwd3RwVWQ0VGh1clhuT1pMaVlDb0FGWmlEV1NXdmxCNUhCVnA5SGN0?=
 =?utf-8?B?QWZTUm5pL29kcFFCTTlKN295MkxTc0F5K1lFZkIyRFh6bkdrRS9JR3BVdGFW?=
 =?utf-8?B?VDU2SjZGVUpzdldtMTVyWHlDVkJ4dVNsWjMvUCtucmx1NlhmdUVMdTRVcXg0?=
 =?utf-8?B?NEhIMUFkY3F3R0tFb0Zsd3JFb3BRYlFtOHBEYURDUTF6U3g1azBkYVp4K3ZZ?=
 =?utf-8?B?ZXNZd0tVV1d5WXF6ckJtbG5MN05LQXZDZFVDbGxSYW9VYWxvckhKVDluSnBB?=
 =?utf-8?Q?KqeA1M8vBXG6EV943SvYinuNq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22aaba78-d42f-4c25-7340-08daf6f09feb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 12:04:16.4906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5me3ZhpqINBGbyv0JbCuQ8WCW+bsE67ul8t7Oq1vAhdxM2C8QwiMlON2ghigCCEODJFEuTliEbU/G+0zTu6M5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2023 14:24, Jamal Hadi Salim wrote:
> On Thu, Jan 12, 2023 at 5:59 AM Paul Blakey <paulb@nvidia.com> wrote:
>>
>> Hi,
>>
>> This series adds support for hardware miss to a specific tc action
>> instance on a filter's action list. The mlx5 driver patch (besides
>> the refactors) shows its usage instead of using just chain restore.
>>
>> This miss to action supports partial offload of a filter's action list,
>> and and let software continue processing where hardware left off.
>>
>> Example is the CT action, where new connections need to be handled in
>> software. And if there is a packet modifying action before the CT action,
>> then restoring only the chain on misses might cause the rule to not
>> re-execute the relevant filter in software.
>>
>> Consider the following scenario:
>>
>> $ tc filter add dev dev1 ingress chain 0 proto ip flower \
>>    ct_state -trk dst_mac fe:50:56:26:13:7d \
>>    action pedit ex munge eth dst aa:bb:cc:dd:ee:01 \
>>    action ct \
>>    action goto chain 1
>> $ tc filter add dev dev1 ingress chain 1 proto ip flower \
>>    ct_state +trk+est \
>>    action mirred egress redirect dev ...
>> $ tc filter add dev dev1 ingress chain 1 proto ip flower \
>>    ct_state +trk+new \
>>    action ct commit \
>>    action mirred egress redirect dev dev2
>>
>> $ tc filter add dev dev2 ingress chain 0 proto ip flower \
>>    action ct \
>>    action mirred egress redirect dev dev1
>>
>> A packet doing the pedit in hardware (setting dst_mac to aa:bb:cc:dd:ee:01),
>> missing in the ct action, and restarting in chain 0 in software will fail
>> matching the original dst_mac in the flower filter on chain 0.
> 
> 
> I had to read that a couple of times and didnt get it until i went and
> started looking at the patches and i am not 100% sure still.. IIUC, you have
> something like:
> match X action A action B action C
> You do action A in HW and then you want to continue with B and C in SW.
> If that is correct then the cover letter would be an easier read if it
> is laid out as
> follows:
> 
> -"consider the following scenario" (with examples you had above)....
> Actually those example were not clear, i think the reader is meant to
> assume lack of skip_sw means they are available both in hw and sw.
> 
> -Explain your goals and why it wont work (I think you did that well above)
> 
> -"and now with the changes in this patchset, the issue can be resolved
> with rearranging the policy setup as follows"...

Sure I can work on that for v2.

> 
> Having said that: Would this have been equally achieved with using skbmark?
> The advantage is removing the need to change the cls sw datapath.
> The HW doesnt have to support skb mark setting, just driver transform.
> i.e the driver can keep track of the action mapping and set the mark when
> it receives the packet from hw.
> You rearrange your rules to use cls fw and have action B and C  match
> an skb mark.
> 

The user would then need to be familiar with how it works for this 
specific vendor, of which actions are supported, and do so for all the 
rules that have such actions. He will also need to add a
skb mark action after each such successful execution that the driver 
should ignore.

Also with this patchset we actually support tc action continue, where 
with cls_fw it wont' be possible.



>> The above scenario is supported in mlx5 driver by reordering the actions
>> so ct will be done in hardware before the pedit action, but some packet
>> modifications can't be reordered in regards to the ct action. An example
>> of that is a modification to the tuple fields (e.g action pedit ex munge ip
>> dst 1.1.1.1) since it affects the ct action's result (as it does lookup based
>> on ip).
> 
> Also above text wasnt clear. It sounded like the driver would magically
> know that it has to continue action B and C in s/w because it knows the
> hardware wont be able to exec them?

It means that if MLX5 driver gets "action A, action CT, action B",
where action CT is only possible in hardware for offloaded established 
connections (offloaded via flow table).

We reorder the actions and parse it as if the action list was: "action 
CT, action A, action B" and then if we miss in action CT we didn't do 
any modifications (actions A/B, and counters) in hardware.

We can only do this if the actions are independent, and so to support
dependent actions (pedit for src ip followed by action CT), we have this 
patchset.



> 
> cheers,
> jamal
