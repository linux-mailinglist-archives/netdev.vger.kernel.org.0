Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D01F53E63C
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbiFFL3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 07:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235337AbiFFL3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 07:29:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2065.outbound.protection.outlook.com [40.107.92.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2299A25A818
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 04:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNBU3KmikOTwuvrpQ3UizcyTWTwN7heatwewZoqha5zWs3YBnORlxXAUQ50QWFOiGG95TRbRxxcoS4fXZSngjAnu20HLsuTdePHRd3Qnxn1nanJk/IihX1gO66PRouVJuBCgDkvRZXjfVyBMNx/Ms7l+po9eyCLDgiZooV9B0nHfcderbLbSjbuxPslEgcD6qFqcqABliiU0iQC4pgD58mVG7TJqIVgiY+PPcuHDEcnt/EmXabsfQ5T6qHiQvDwCJZi9PT4GMPGSIfg7NVdGZ19GdH2dttbLnnelW0SQMeAX5jzlmxfv2TOn25VML94gmcOiUv2clRCoHNN9M1r7Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UaSiRFWXp7/XfddMZ6YJud3HFnyZKj6uYLJ3PRmq/dk=;
 b=lamfw+NB65RVptwKycTT3ID9onLhGhB0Mq08GYApl7tPgfSYtVlbiKg8qJThZAd0/kiutkaIM2fec4CGcxi1RiG1fyPgk1oQ3f5+USawuOds3t+bxgAXILgvN/8HH5JsGrCkPXR9cJolc/3TYRV6aICzae42PU8RqMcmLfoVWx2M2WHhZjaDLRZh7ciVOPYdv8v4bWkLxmInpem3YACDlPw7zyw7JrrN9VX4LO974hPmhsU8odHQIHY6eBQzcc6FgcbF8QzdN8hTQckV1SUC0HgMTGixi5kkZmNYV4q+lhUZJMBErEOGuWm/gN+YGj8EN1LBIhR7WWxKOWmVSTz/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UaSiRFWXp7/XfddMZ6YJud3HFnyZKj6uYLJ3PRmq/dk=;
 b=o18g9wqMckOPCqybDu7ZGfMGS+IacoM13Zezyf230TIfhxuMzkHiSsVqrFVzvNPJ5yZNX3FyktGCan2AY+SpF6ouUyZ0DQDg57vJXUoXANGZixcyv9MDF4ATBmezYNhckJlho+EvMoW77lBvYhYsxcmxJxg4GdBsmdxjF9g0IyGlfZRKgBSw/9mbmvVs9ZudnNLynQoNKPr+9KrzkJgfXvTR30SwBt8mtUi3NwFmhrx796Ciq5CoHpW/Q+fuO4dVJQc8yhNgEprWrxqoJCBq4jcq3af4Ue9wmUH+4N/6FD54JazUB9z/ndQVTp0NfYVrl7FTfc7uhw30mOsFT98DGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by CH2PR12MB3687.namprd12.prod.outlook.com (2603:10b6:610:2b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.17; Mon, 6 Jun
 2022 11:29:10 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5314.019; Mon, 6 Jun 2022
 11:29:10 +0000
Message-ID: <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
Date:   Mon, 6 Jun 2022 14:29:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next v2] ss: Shorter display format for TLS
 zerocopy sendfile
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org,
        stephen@networkplumber.org, tariqt@nvidia.com
References: <20220601122343.2451706-1-maximmi@nvidia.com>
 <20220601234249.244701-1-kuba@kernel.org>
 <bf8c357e-6a1d-4c42-e6f8-f259879b67c6@nvidia.com>
 <20220602094428.4464c58a@kernel.org>
 <779eeee9-efae-56c2-5dd6-dea1a027f65d@nvidia.com>
 <20220603085140.26f29d80@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220603085140.26f29d80@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0088.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::7) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8ad915c-ea60-45af-aae2-08da47afc685
X-MS-TrafficTypeDiagnostic: CH2PR12MB3687:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3687FCEF92EFE2BDC9A2FFE9DCA29@CH2PR12MB3687.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fZZe7b/shOWLgIE3xDEJnf4bw9PuX8Si6w6a5ejZ5tWaI5ashT6w1k2WlrWjy2oHF3W7tajN8Gn5pWWr3XHOjQSmez9tuUZsQZ+Rm3jcukg1Ao4togdewGo4qGnurrl0Tde/EvecJfQW/Sgz7w2EnOMYF6XZlU341YmM6RLhc2nD5l2SJ742GFFZHnDazwyCpwUIODZLxNYUy9T9l/SMsgS+vVUIEi5XkvN2HzbZxCI10N1u8fD5bbEfCFcb0392UOxIkO03AoDB0G9MSbYvT8kMTQDx8URUC2Bxb0YK6sPkrjX5VA5NqteMqGfgEtcVIYO+/SJvUmOfFi7A+SyOLWpPdaUCPkRKfSbHIReNZGcbFewf7SOL1PZ/1U1N4NYyOFMTpDSvAMTMWLe9An/IlNzX7+Jo5UsFBs29H+HScaG4amn0yBZzdHvVFbVo/tX13fpPSTc5wqwg3CNnEs2FU+P2IaFNUfcPUrwHdxh7+7pk/y8WHbWSNULqdI71zSGXtt11EKvynsnH7lzmEZdVVswPLlCA2EwlJvk/tBxh3tsxeml0TNm8V5VQyVJ2cTfGYouBdeJ0GN/0k/qc677P9Rt8DvorrHFjgAJCqsr4erQQEdjn4I8gaef/518ThlVAMBtel9R3lfCGP13yS0vBkuMQayN99FDiAchQPaYOmviLeRwZNJyBDuqLdqRj47AaeZSLOAEAIbfqyLXBgOAMkx9ob+nf6Ce1MKCQtkN5KWR/xE/41enrco/L0awoF3TEMiHd/LH5qam1dYSd25ZdN/rqwtVaz7etaOeRHAOVVIhtYZqPxQIYn+dX5yvJVqy8FWtxeyXQaH0mg5N3QE5pW26ckGg6E5Hph7+3mml1dY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(83380400001)(6916009)(186003)(6486002)(6506007)(31696002)(31686004)(66476007)(4326008)(66556008)(6666004)(316002)(66946007)(8676002)(38100700002)(2906002)(26005)(86362001)(6512007)(508600001)(53546011)(5660300002)(8936002)(107886003)(966005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YUlSb1pZU05YbHBnYlIrZU5KSHdzNkRLSUw2OVo5TmRSM21rM2lvdmVQUWpK?=
 =?utf-8?B?VHhoYmF4djBiUVFoQlc1TUhFc1M5T1BCNnI3THpSUDlWRDFEdXI2RGpnV1Bo?=
 =?utf-8?B?WHc5aUNqVC9XT0s0RkNtZHdTNkxzdHdRMHdrVHZUa2tFTlVVMllzSjBiYUpO?=
 =?utf-8?B?QXI3djFSOUxxdU10NThYaFhnTUJQZEM2SWpqWU04SDFUNkt4UFhha2JKTFJZ?=
 =?utf-8?B?TDBwdDY5RVIzcVdsNGYzV0xpamx4MTM3MDNCaEFDeVZ3OVA5MjNUSzN5TUhL?=
 =?utf-8?B?TFdWOUUvb0IvMjFzd2VyZVFmaTJHd3JCZ3ZybS93MkFrTnZnbXlhZDBOc2NH?=
 =?utf-8?B?MmJ1alIrSGxYblB2S2QxRmo1emtxTDJUNXBYMms1eEJIQTBUR1FYQ2tQekgx?=
 =?utf-8?B?eVRQblBNaytUcGV3TlY2VHo4T0FLZEx6eHdMT0hZUkFNYXZZMzJOMVE2SzJl?=
 =?utf-8?B?OWNkTGRIQnlMa2ZpWGwyeEREbWowS25iQVFWL1prWC9SS2xibVBCTDBKUXRV?=
 =?utf-8?B?R0tPK2g3Z1JmTjk3aG1FZjJSS1NOcDFOQzM1ODVITmpCbmNQS3l6c3lPWmtL?=
 =?utf-8?B?VTd6UEp4dXVid3VSYVpoNlZic1Z1ZVU2N2NwUGZXWllsd1NEMWlqWmZGdFFk?=
 =?utf-8?B?Y0c5K1ZkRGp6bUFlTlZkSmt2VUhmZ2N1aXJwQllZSEU3MFNiSHJMU1hka1Vh?=
 =?utf-8?B?SUxvcDl5aVB5NFM0MEUvQXViR0tWS0I1KzFTUjlhQ1JZOFZYM09ySjFrN3Mv?=
 =?utf-8?B?aG1aRmgweEdSUURjV21oZzh0NkcrN05DL1hjbFdyYVVVOFRVeVhsdENURy95?=
 =?utf-8?B?aUNBQnpUa2d3dGhDSFBtWlQyVHpOdThQQVRmU3hvTE8vTEh6S1lmS0hnaUJn?=
 =?utf-8?B?T2lRYms4dkZyeCtPVEFIekJiaWgrWm1HMjRoNjFKQWZXT0t5NVBwczBsbU8w?=
 =?utf-8?B?enlhNE5PRmpWYVIvK21tSE02L2txd3lzUnNPSWNjYTJ3Z1crcFlvTEs1Yk9o?=
 =?utf-8?B?STRlRm02LzFsQTdNOHpsQW1SdUpSb3hsZ2hsTlFVQ3V5MFl1aTF1S2Z1QkxJ?=
 =?utf-8?B?QWhzd0pUdHlVRWdXL2oxUTRFeU8rMmdjMFQwZnJTYkpyRFJ4QmhEeWRWNGMr?=
 =?utf-8?B?VThTY2VDQ3gybHRRWVRmNFgvb3ZXaXJpazhaSnh6Q3FIU29YaGc3N2V6SFNk?=
 =?utf-8?B?MVBjWkt5bzlwTk5YUmJ5cHpIdGtHNU1hSXVVT0dGQnVDT01GRi92RmFNL25E?=
 =?utf-8?B?NytteDNQdkxHd09aOHVnYkUvRFcyQjFZc3dnVVpJMWl4SWVLbCs3ckpYamtm?=
 =?utf-8?B?UWNHWGZhV21aNElLUG5oNGhRZm5VMFJzWFNYd2VreXFoM2NCaGZUdFpoOCt3?=
 =?utf-8?B?RDFTRUF1am9FR1FMQUxQRW1GVzhNYndEVnpkQUxFYTFiMTdTWVM0ZGVUZzMr?=
 =?utf-8?B?SnFITmxGRC9iVm1GSEw4aWoyU2VPeHZIc2dXZEpiSVNUSHNRVEVyWlNwRTlh?=
 =?utf-8?B?eTVxWlRSNk9LNTZkeVIzRWhBOEFDVStLb051ODRIdlJIVGVLZHQ0ZHJYeGNx?=
 =?utf-8?B?K09XL0ZnVGRlelZXYUpjcWhsQVFFbXJ4bURPR2RPVVNod1hJSlROZUNiaWtB?=
 =?utf-8?B?UHlZajVsblZsSDBZdGcxQkVTclBLT0p1T0p0bWxBbFpkVWJVdlZZQ1hoK0d2?=
 =?utf-8?B?bWRXUG00aTk4SG1xa0tyWjZiZTdvUEl0WU52bnpwM0tyQi9VaG9WcmxLUjBT?=
 =?utf-8?B?TmRESWU2bkpObkFORVNIZjZKRktJOG92WEJOQmdQWUZvaDVVTHRhSHZYTk4x?=
 =?utf-8?B?QU9Wak5FVmtJemkyeUZ3OHpLMUFaVmtMUEpIdTdtNmp0dHJCSzFiRXVEaVY4?=
 =?utf-8?B?bEdKN1BGKzNJaXZXNStQQzA3LzI2SmZsbEJGbUR2MHNqTFlESHJGZjhtRG5r?=
 =?utf-8?B?aWZHWGFJUjBKdS9jRjQ5VXAxWDRrcGQxVkdhcHR3NStkZHZHWHlETDlrU2pM?=
 =?utf-8?B?TCtyYndwTU03VEx3Nk9JYUNxUzM0T0xGczc1aFU2VEdibFlLT2I3ZzdHNWZz?=
 =?utf-8?B?L2xuR25Ud3dZeSs0akc2Q0xvMnN5bzdTM0RGdmdwZTNkaHc3K2NEaVo1bGhS?=
 =?utf-8?B?S1k3aHMxWU5SVk5takNyT2ZOV2g3V0VQdERLVjJCcU5jTWRKVVJ1dlZYd3hv?=
 =?utf-8?B?d3lpYXpvV2tHbWR5N3FuY2V4ZWNpMEFGa1ErSkk5QUI0YzdVWUdkODlCSGFC?=
 =?utf-8?B?NzZrUUZiTWlkUHRLWEZNSk43TTdkRGttdHd2UTZpZXVKODFMQTNGcWZXMVF4?=
 =?utf-8?B?VHluK1RKbzBJek5STEYzaEc5dEcwazBVOGRBR1FuZXZUNkh2d2NhZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8ad915c-ea60-45af-aae2-08da47afc685
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2022 11:29:10.4030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNFnL2reABhNeC2M7LEoeLw16lByMnyx3ezc1MkA8UMmpWk/mTBMMjMP2WjEEPqoxZbQPvH8NOi9CRp9/NOsqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3687
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-03 18:51, Jakub Kicinski wrote:
> On Fri, 3 Jun 2022 16:47:43 +0300 Maxim Mikityanskiy wrote:
>>>> The kernel feature is exposed to the userspace as "zerocopy sendfile",
>>>> see the constants for setsockopt and sock_diag.
>>>> ss should just print  whatever is exposed via sock_diag as is. IMO,
>>>> inventing new names for it would cause confusion. Calling the feature
>>>> by the same name everywhere looks clearer to me.
>>>
>>> Sure, there discrepancy is a little annoying. Do you want to send
>>> the kernel rename patch, or should I?
>>
>> You reviewed the kernel patch and were fine with the naming. Could you
>> tell me what happened after merging the patch, what changed your mind
>> and made you unhappy about it?
> 
> Ah, I had the explanation but I cut it to keep the email shorter :S
> 
> The difference is that the person writing the code (who will interact
> with kernel defines) is likely to have a deeper understanding of the
> technology and have read the doc. My concern is that an ss user will
> have much more superficial understanding of the internals so we need
> to be more careful to present the information in the most meaningful
> way.
> 
> E.g. see the patch for changing dev->operstate to UP from UNKNOWN
> because users are "confused". If you just call the thing "zc is enabled"
> I'm afraid users will start reporting that the "go fast mode" is not
> engaged as a bug, without appreciation for the possible side effects.

That makes some sense to me. What about calling the ss flag 
"zc_sendfile_ro" or "zc_ro_sendfile"? It will still be clear it's 
zerocopy, but with some nuance.

>>> I spent the last 8 months in meetings
>>> about TLS and I had to explain over and over that TLS zero-copy is not
>>> zero-copy. Granted that's the SW path that's to blame as it moves data
>>> from one place to another and still calls that zero-copy. But the term
>>> zero-copy is tainted for all of kernel TLS at this point.
>>
>> That sounds like a good reason to rename the "zero-copy which is not
>> actually zero-copy" feature. On the other hand, zerocopy sendfile is
>> truly zerocopy, it doesn't have this issue.
> 
> Well, maybe, or maybe the SW path does not make a copy either just
> *crypts to a different buffer. IDK if that's a copy.

I consider that a copy, but I understand why someone could have another 
vision on it.

>>> Unless we report a matrix with the number of copies per syscall I'd
>>> prefer to avoid calling random ones zero-copy again.
> 
> This was a serious suggestion BTW. More legwork, but I believe it'd be
> quite useful. If we could express the "number of data movements" in a
> more comprehensive manner it'd be helpful for all the cases, and you'd
> get the "0" for the sendfile.

Sounds like a good idea for a future plan, as long as this matrix is 
maintained properly when new optimizations are added.

> Hopefully such a matrix would be complicated enough to make people look
> at the docs for an explanation of the details.
> 
>>>> What is confusing is calling a feature not by its name, but by one of
>>>> its implications, and picking a name that doesn't have any references
>>>> elsewhere.
>>>
>>> The sockopt is a promise from the user space to the kernel that it will
>>> not modify the data in the file. So I'd prefer to call it sendfile_ro.
>>
>> That's another way of thinking about it. So, one way is to request
>> specific effects and deal with the limitations. Another way is to
>> declare the limitations and let the supported optimizations kick in
>> automatically. Both approaches look valid, but I have to think about it.
>> It's hard to figure out which is better when we have only one
>> optimization and one limitation.
> 
> Dunno if it's useful but FWIW I pushed my WIP branch out:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=d923f1049a1ae1c2bdc1d8f0081fd9f3a35d4155
> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=b814ee782eef62d6e2602ab3ba7b31ca03cfe44c

I took a glance, and I agree zerocopy isn't the best name for your 
feature. If I wanted to indicate it saves one copy, I would call it 
"direct decrypt". "Expect no pad" also works from the point of view of 
declaring limitations.

Another topic to consider is whether TLS 1.3 should be part of the name, 
and should "TlsDecryptRetry" be more specific (if a future feature also 
retries decryption as a fallback, do we want to count these retries in 
the same counter or in a new counter?)

>>>> However, in the context of this patch, you call "zerocopy" a
>>>> "salesman speak". What is different in this context that "zerocopy"
>>>> became an unwanted term?
>>>
>>> I put that sentence in there because I thought you'd appreciate it.
>>> I can remove it if it makes my opinion look inconsistent.
>>> Trying to be nice always backfires for me, eh.
>>
>> I'm sorry if I didn't read your intention right, but I felt the opposite
>> of nice when I started receiving derogatory nicknames for my feature in
>> a passive-aggressive manner.
>>
>> We could have prevented all the miscommunication if you had sent me a
>> note at the point when you felt we need to rename the whole feature.
>> Instead, I was under impression that you suddenly started hating my
>> feature, and I couldn't really get why.
> 
> Not at all, sorry. In fact I hope you / someone implements a similar
> thing for sendmsg. At which point I may be involved in people using
> it. Therefore I started to care about user reports / complaints coming
> in and me having to explain the context over and over :(

