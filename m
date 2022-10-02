Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5DA5F2256
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 11:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiJBJag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJBJae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 05:30:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2087.outbound.protection.outlook.com [40.107.244.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD963E775
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 02:30:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWA+2BGS7ihpfsINPtUmUS7TjpHmeuDX7HfC/U/mjC9KziRtoz2H+CcR+cDwYocExidVLNVLqYstzuwwJhqpswjwVbo3Uy5dPp0wTGdNF11SkRQUjw90sOWrn6J/yNPyMuBOD71RXciIu+Xn5a6AmnvDnvTr0BqZwMdPIw3YXrLlscku0rugSHenQ28mFh1cGrfE+qsyW09szbFewLhdsyvahTSjrE641xH4QH/P3eKt+23ZDps5HmygiZs30TueSEo23vXomrTIkhU/5UIAzQ6uplGGeYChQ82hBsaMsU3jKVDLzUFLsaj9FsGZyhhVtEHR/Zm+YL7djF85iXkM5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6nx0OaRafMTOnZId42/QBVGo2zFPhtn6IpBOcgQ45Y=;
 b=jGlPoNa4WrrMjFHJp8ZvSALaRbfdzHaAK0n1u20RCyf+oxX95buPe7n75LFzNVDmzQaBMVIwxEKj+0WazSE8CGtcj8pg/VWLxKX2RxDatx1PHzCECbtve2wUNZljyiaeGeSX8Pa5yryY7FOBNAhUHfKHBckNzgwinqgUJL0vwT5JgAuem8fuLWENyVd1t/lJ4PyCKU/dfvxCmtD20c36pOaghvJ3ztapQ3BLa99wZRNatscQxk0uRED0Cas52CMXV9GYHdFE5maYLE9ECDmnYtzYC2UFqE8HOTlLu7g8B8fcttg+1E7yrHfQ2GabdHf6KQBDyn/tM5BXprNdG+OUXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6nx0OaRafMTOnZId42/QBVGo2zFPhtn6IpBOcgQ45Y=;
 b=QkR0C9sSo4tlatTpM4RUz3Y9/oPPvsRdPxYMH3Uh+B1DgpdBr8S8pDF7YFcAknUkP+ZeYOmHMYnaksCRMTqSRP3wx5kvICtxzb86y3+5Awk53fy5YGRAE/a9pfRrcN/WQIbKegEFtJS6OoQSFtIkhkCMj345KarctM9sxRYljfn4kPHZLdgOAeDSSKY4kj9prkY1z9uOmLv2qbyREL5UavE3oY/cjGQ3YedALqb1QzDtETW3A6uzRXUkhSXBTe7HtvavRxmvafnCSYDzkadgdrO4rWXmSqgHKHTNwDTtuUubssEtffHEbsoawmm86fokk2LdoYeiqqQHL1LAid0gqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5629.namprd12.prod.outlook.com (2603:10b6:510:141::10)
 by MW4PR12MB7029.namprd12.prod.outlook.com (2603:10b6:303:1ef::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Sun, 2 Oct
 2022 09:30:28 +0000
Received: from PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c405:5d03:7aac:a7aa]) by PH0PR12MB5629.namprd12.prod.outlook.com
 ([fe80::c405:5d03:7aac:a7aa%4]) with mapi id 15.20.5676.028; Sun, 2 Oct 2022
 09:30:28 +0000
Message-ID: <d0ae6e4b-5392-704a-5c87-2939bc2d9c44@nvidia.com>
Date:   Sun, 2 Oct 2022 12:30:18 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net v2 1/2] net: Fix return value of qdisc ingress
 handling on success
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Vlad Buslov <vladbu@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <1664093662-32069-1-git-send-email-paulb@nvidia.com>
 <1664093662-32069-2-git-send-email-paulb@nvidia.com>
 <YzCXUN6bKSb762Pn@pop-os.localdomain>
 <5a9d0e6a-2916-e791-a123-c8a957a3e3e5@nvidia.com>
 <Yzig5mvDDFqqieDl@pop-os.localdomain>
From:   Paul Blakey <paulb@nvidia.com>
In-Reply-To: <Yzig5mvDDFqqieDl@pop-os.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0301CA0028.eurprd03.prod.outlook.com
 (2603:10a6:206:14::41) To PH0PR12MB5629.namprd12.prod.outlook.com
 (2603:10b6:510:141::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB5629:EE_|MW4PR12MB7029:EE_
X-MS-Office365-Filtering-Correlation-Id: 3544c17b-50ee-4268-b96b-08daa458be2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RY1T1pWj5GLkowo6xo35iiG5eBUG6Xk8J9i+2xS1EgJSe3K5YhRiPkIyM7TArTvgPekGVo2Ey7gWQT0IoQpvMorbcpNYtjRbWH86eSIVCEbC53+UHMLjsu/IQeYMEmjnGDm3Zb861hKgGijnjZHUovIoxbUJtTCUzQ7GdvD/ImMA873/Dww1vv9sKERBL6mECW2YhPdABcDfc8FD5XOmpItkFrtjEYyoBoEvPxPrDPSqMdrPURvWxBv/oY4FxNbMg3+hlgmrsD7FSrEe+j8BsOoZCKTYZ9j9IlpNZTq4wcsmZTdq8XQcMEYbYlntbf33IebWKsZdrGDFsb2gGiESRPgPiD+6d/FLfB7JrLdyHotJcDQUShrkft99e6aNUdFUlNABVMwS+AncE7qVdv+7mdvZRH0jxDfeBmj7JXQt5/YBPRaKNYS4uonZFv0eC2Io7qHCqIAdrn67mCp/sVrqQNJPIl4N34NqW+5+wntyF7gfrJz8iwEGQiv9+JioQLtP/ZPA71eLZnwHHLVDvW6e6T0UdUY6yLNMidU0LXDGMahKoenSI2MIOSjZsp7SgdEyWupSkkNYuCZ2R4fs/9tHw3gverW1bzvuW/DhqNe55Nvz6lItobaVfaIMJw7sXSE4zxqbA+vi0YHZrLVLQh7U3VyrqC/iHhNcrDqui6/9yqZa1WpXrPoCZjzkhrlwfpING64wxQVpQbeM6hxUeOXGEWbrwTnn8cnSOf+/S77IKbVMrNC4lkOna2c5F2SN6z8tgKqkKxA8fkaU18WW+Kfh0ClOxIPb7tCiSI/6rec8/dg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5629.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(451199015)(4326008)(6666004)(8936002)(6506007)(53546011)(26005)(6512007)(2906002)(41300700001)(5660300002)(36756003)(2616005)(38100700002)(8676002)(66946007)(66556008)(66476007)(83380400001)(186003)(31696002)(31686004)(86362001)(478600001)(6486002)(54906003)(316002)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmdCVmJEQmhRNmw3T0dlNWlTQ0NPbXJra3dza3BiN0MrVnZzZ0hFTmRDaVdG?=
 =?utf-8?B?RmJ1RlRvRGg3T0RzNjRYeHJFdUlnQXI3SjV4VExGZkhLV0hnaDBrMERtK2o2?=
 =?utf-8?B?VE5ZSzA3cHdXWEtWaDliRExURGtlRHdwbHBxTDRjMDd5TmlVMExVMHhaTlFl?=
 =?utf-8?B?TzBrQUozbnlkUGlLSGJEYk50R01mNElsbzdpc0k1M0NkZUVwYzBLSllNYnlB?=
 =?utf-8?B?Rm1ma05FajRVa2x3M3ZUUm1PczZhTTcxaFFPK0IzWmpxWE55T0RiTjBFWTA2?=
 =?utf-8?B?aTB1ZFB0SS83ZmhlSzg5cEVGdmVZMjY1N3dmWHhxd284WTBsZEVpQVg5OEdD?=
 =?utf-8?B?K0tVem45c2N3NzR4aThwZjBJRms2aVVmMVNyaFVWU0k3N1Vpb2MrOVZBa3Nl?=
 =?utf-8?B?MXBqNHh3VnpYRGFONTUwbnhpWWpvME9Zb2xzdjVlV2IzQUJSZW1raStlZzlC?=
 =?utf-8?B?K1ZEeGtXT3NsaVdwWm5oODcrV2NqeFYyempxcFBQZXd5djIvUDJzTS9ZeFVV?=
 =?utf-8?B?YWFkMnJPbTRYUlV5NDFKakFUQ1NVS0pXMU9rWnYwVTdPb2szOTVwemk5bm9i?=
 =?utf-8?B?dVgreWJYWnJLblBSWXF0QUM5bW5Jei9yTW9ROUU1VGR5RWtuK29UV2FMVXpr?=
 =?utf-8?B?K0M2NEtrVk9YbW5NSzBESzFlOHpja05lSVZ3a1hTSVZFRVVydExBVEdvdUhQ?=
 =?utf-8?B?QVluRmxLTkFqcWYyaVpoY0FsRVcxMGxlUFVrbWo2eUYwRU1Id2xLMTdNazdz?=
 =?utf-8?B?SkNITHdSMFlQeWNLckExdEhjZDJEem5ZdWFEQWdKS24vbHFLdzFhQ2oyUGhP?=
 =?utf-8?B?a0FRM0xGRnR0V0t1bnpocnZPWFhQWDdGNm5HZGpLN1duNFlFaWxhb0tMQ3BE?=
 =?utf-8?B?R3RQTjMxRjh6UlgwbmxOK0ppUFlHNk1DMEdRdlB4aFR0VTZudVI1bmdKQ3Zw?=
 =?utf-8?B?Y254dGNmNVBXeklzMzgwL0Q1bFNrVGNiR3dDZFIwUjdDZzNHcTdCMWpMb1ZH?=
 =?utf-8?B?VWNsRGN4eStHVFJsdWVCU3RYdTRya0RyYjRwODg5b2dZZkRxNlV5QTZqcVJR?=
 =?utf-8?B?eWxxWWxDcGVjTVJCUTVGT296dzBkL1o3ejFSS1c4d25IbEw5ZHZ0SGtyUG9q?=
 =?utf-8?B?a0lsZjJaOWJISmk0Yll5UUZ2NWtPNE9Gc1RkczdWQ1V0cWhlQzhnQ2JBQzhu?=
 =?utf-8?B?UkZRaXhnNjVSVU9LVzNpUm9vZGpzYUhvWHhuQWtoeStMTWF1cHdFbW5xV2s5?=
 =?utf-8?B?eU5rUlpid2RQZ3U5Z3hYUGV4bWN1OE40NVBQcXc5MmQ5ME1Jdmlqc1paUjBW?=
 =?utf-8?B?SGpDL3VjQVcydG5GcEJtUUdwcmorOVZhbTA1Y0ZZV2ZIT1hyRk9iTmZlOFJJ?=
 =?utf-8?B?S3hEb09jNnBiUGM1MDdiZmRiY0VDaFc1ZG9MZWhKa0RDSHpuZUZvQmRkdGhP?=
 =?utf-8?B?YkMxZkg0eDJtZFlwenZtQW13WmJBL29UQVUrbHBvMFgxbzlTK3JGZzhQRGVE?=
 =?utf-8?B?Q0lJa0RvaEJpTzZkK0JWcWNLWkpHOFprYS9ldzl4eUpmVG5kQlJxdlVnVERl?=
 =?utf-8?B?dEFmdXZFMUNOWjYxVnc0Nlo0Y0lydW0rdU5uUlNvNjlCS2wvbDhnTGh1UytS?=
 =?utf-8?B?bEY0c05NZUdOWjRQT2x1VTBab051MjVJS0hBbnZzbjU3dUN3VlhHZGNGNWoz?=
 =?utf-8?B?ZkxhaUpBTjFHOU1xWjJQd2NmdVJhbW52dGZxVkI5OUNmSmhPb0tCem1DZmNu?=
 =?utf-8?B?NW9WdE5FVzVVQ3JrMFM0WmQ4c293QVlpakxwUjA3bktPWkx6a0d4ZTQ5UDVm?=
 =?utf-8?B?c1ExZmF0b2xrMWo5dnBmUzN4TlMxMlFod3hBK25udlFkWVRxVnJNZzBZM0N4?=
 =?utf-8?B?a1RYK0dUdEljZklIcGFtY2hQY2VxOU8wdEsyakN0MFJUVnhCb2pkMnFRQUk2?=
 =?utf-8?B?Vm9PblFSL2Y5cFdtMFpDT3BMQmhPaVlhVmFpelM1eVo3dGl5bGdvZmMrQzlH?=
 =?utf-8?B?ZmpBWnNPRjR3czdhcGlockdLMkdYVUJGSDNJQ0NTL2RLdHhVakFnVVpRS2c2?=
 =?utf-8?B?UTdZcFR4dnhmbWhjZ2lzZUVkeFlEcWxQL2pnRFZjekZPYUl0U2RWZmJnbnlk?=
 =?utf-8?Q?oBIrURXvtOfGe3753EmY5vaXM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3544c17b-50ee-4268-b96b-08daa458be2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5629.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 09:30:28.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5FIAlEopPwiwe+Ufp3YXOTtZl/Uf60uCgbl23zKLsktJei0ToQircFKyfjNSfRSkbkdq7dKCql9eHDwrnlTsDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7029
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/10/2022 23:19, Cong Wang wrote:
> On Wed, Sep 28, 2022 at 10:55:49AM +0300, Paul Blakey wrote:
>>
>>
>> On 25/09/2022 21:00, Cong Wang wrote:
>>> On Sun, Sep 25, 2022 at 11:14:21AM +0300, Paul Blakey wrote:
>>>> Currently qdisc ingress handling (sch_handle_ingress()) doesn't
>>>> set a return value and it is left to the old return value of
>>>> the caller (__netif_receive_skb_core()) which is RX drop, so if
>>>> the packet is consumed, caller will stop and return this value
>>>> as if the packet was dropped.
>>>>
>>>> This causes a problem in the kernel tcp stack when having a
>>>> egress tc rule forwarding to a ingress tc rule.
>>>> The tcp stack sending packets on the device having the egress rule
>>>> will see the packets as not successfully transmitted (although they
>>>> actually were), will not advance it's internal state of sent data,
>>>> and packets returning on such tcp stream will be dropped by the tcp
>>>> stack with reason ack-of-unsent-data. See reproduction in [0] below.
>>>>
>>>
>>> Hm, but how is this return value propagated to egress? I checked
>>> tcf_mirred_act() code, but don't see how it is even used there.
>>>
>>> 318         err = tcf_mirred_forward(want_ingress, skb2);
>>> 319         if (err) {
>>> 320 out:
>>> 321                 tcf_action_inc_overlimit_qstats(&m->common);
>>> 322                 if (tcf_mirred_is_act_redirect(m_eaction))
>>> 323                         retval = TC_ACT_SHOT;
>>> 324         }
>>> 325         __this_cpu_dec(mirred_rec_level);
>>> 326
>>> 327         return retval;
>>>
>>>
>>> What am I missing?
>>
>> for the ingress acting act_mirred it will return TC_ACT_CONSUMED above
>> the code you mentioned (since redirect=1, use_reinsert=1. Although
>> TC_ACT_STOLEN which is the retval set for this action, will also act the
>> same)
>>
>>
>> It is propagated as such (TX stack starting from tcp):
>>
> 
> Sorry for my misunderstanding.
> 
> I meant to say those TC_ACT_* return value, not NET_RX_*, but I worried
> too much here, as mirred lets user specify the return value

Yes TC_ACT_* start at the action mirred case, and end in 
tcf_handle_ingress/egresss switch cases, which then should be converted 
to NET_RX and NET_XMIT if done.

> 
> BTW, it seems you at least miss the drop case, which is NET_RX_DROP for
> TC_ACT_SHOT at least? Possibly other code paths in sch_handle_ingress()
> too.

I'll add the SHOT for v3 as the packet was handled in this case, but I 
should only update ret where the packet/skb was handled, which is where 
we also return NULL, as otherwise rx pipeline should continue and will 
update ret once handled (say in running the rx_handler).

For example, if there are not tc filters (tcf_classify returns 
TC_ACT_UNSPEC) I should not update *ret, and it will continue to the rx 
handler, and if there isn't any, it would return the default ret RX_DROP 
value.


> 
> Thanks.
