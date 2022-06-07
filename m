Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C54353FB69
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 12:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240680AbiFGKfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 06:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiFGKfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 06:35:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB824CBD6A
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 03:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYqQv/JRQegMVzoWa3/1+hA8Ad3AM1TuYvthyklOO9ULe4fXqCr1LlwdsP6l0iWO5YdmclrPqQkSFTGjc760rWWzUDtNQOQAztkUNet0lcBwuXBuMQYPXyYJeISI4B7ahSbpeQLAMVnf+2U4wvP1NJsZ2js5Q8/0KQgSMmRXuIEds6YPqua0fbBKrnKnU5PPgOLIvTxvfD243Yglo8sbRcErtFTbe+O55E9USTHYylAhCJNGcitqqmkrYs123b0YOMNkcJARYQa/corff4fZt3oWDrZT9VlCHgPqBQJp+65othV2yHikLuWQ0t2F9VQkMz2pjMue0Iz5Eaxivw/Rvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ggW8MLYw59EoLtApKbYxAHFxZp0PLkGu7CnccKn17+U=;
 b=T0o1W4H3fA9EW4x1jq5jdZw7ciT+MYWXA4ZMPfbeJZ2PC/MWaNYWHh9Y6DAohyqgwisHsSIXwR0nibApzFkmMLfD/Xe+bcYWmRD96x2yRHSHf68tpyaztKPckOXBZ5aHkLcj92serQd/a9/WSFVuBMAf6LlVCJO3/fxjP4VXLsz9/rxfPGcHjqIBRWWRuK7Y4rQOO5ahXFeuUNNvdAzz7dIr+tduM3p2MZ4Aa49FUTldYGgsrw+Iao8/zOTLw8nRmIDBWH7f9txdPKeiAIwgbkoBaAs5adb1nTMX3LhKR0U9T5FlJ6doI/R0JKXRb/JN7InqwxM3GifukRn/Vlhvmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ggW8MLYw59EoLtApKbYxAHFxZp0PLkGu7CnccKn17+U=;
 b=gab4LQVO84rtbaEP7h3NnT44lt8XCi+s4h7MjR24MN95pG4mSLf1JVBNpIwpwTgFvE2k2kJYPU3WhLjU+qofrap1nOSODiNbyjtoSK4WqQ1ibqfQOHgDlJj+wXz2FQrGiOiMMdvqqNn3LXmWhR8ALf6KilLz/ncYIPybq2S8SxywwZqIgxLeCP/1RJUh+kcOHqh42m3y81HlEQfNbeRkShwRzuswpcT3AuJJk+56CXkCWYfE+WGQ0RyvTKnlfzT8PQwvhH5bEXfUE5ry66oTvxqYOHII5ZKSInoJdiRy3y5T57bLtR/QBT8hRLvO1MXY7N8SKG1DoWPDXC/mQO4PSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN7PR12MB2610.namprd12.prod.outlook.com (2603:10b6:408:22::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Tue, 7 Jun
 2022 10:35:28 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 10:35:28 +0000
Message-ID: <21b34b86-d43b-e86a-57ec-0689a9931824@nvidia.com>
Date:   Tue, 7 Jun 2022 13:35:19 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
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
 <2a1d3514-5c6a-62b6-05b7-b344e0ba3e47@nvidia.com>
 <20220606105936.4162fe65@kernel.org>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220606105936.4162fe65@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0172.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::15) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae9beeae-da64-4ba4-b311-08da48717098
X-MS-TrafficTypeDiagnostic: BN7PR12MB2610:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB26100E7C01B58627C8911C6CDCA59@BN7PR12MB2610.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0fFZjfqVhK9rARWXkLRSr0zKCKhOFQhDSiIdG6+MKiZOoADR0oK82CICWowVZ9s/zHXIheSOcRT2W1rAFM/Y8/QLQUSS59gL/ceH4vw/0tjq7FVBGHE7kbVy3H60hLQUk+RlpZy368ZJw81UThfQzAP2qxECZu2RTODSw+pQbU6DMJUJKsyUor/Hf6ysSZR19ms2C4tjJwpDJbrDnz1Srv4vwrJeDuvKjShfij+4Sav1LDYm/3xC6iDw5ue+sTuUQC4yo0lbr0Lp2ZNwSSxr4ISkFMbtVZzxVnwCcpa8JTyr6iPDsuJOHS8c12tXtl3oXqop7HEpFBdvhLB/9tK+NT9u8d8QKRESd/L0Com2MFXG/LaG2rlkG3dvQkGoBLt5EJJXGc5Rrqg0MLDx0+UYNduO7fsmtNPh9wsXo/1MJPr6+ZOrUBTEYkAj+Z/BvDkJl8QNs//ohX9eTMHMowsElGSAGDTxxtfuA8VVTteTny6X0GDq25ic2wa+rLrpgzrKfHPhkmZF681K3E7uhaifREu2xKgABligG5ZGuP/NKqnGZ3bQnSD5/4Ncd8Us3NlA2EjX8SXGRlAcgN8qi+uSGDmn+Lgj8IxWhOJz7+6TXIJ6X1hTXG2hMJD8cxzyReZK/lPsvQh5EMX++dBw5mMel+54UdiwtR5LI/KtdqzE+yxOYxDMmAxHeKJNpRIjK/7DiX/Rl297GqzcuyelR1H9t1B9JVrtPHJA6yLaQt3dlfQ276xLPU2+e2Yj5QSTFFvEYBbtuxz7NKzh1g0PvDBoPg+Z67ESmGLG7FTfPKv4NrEarD+ixecIpcek5rSo9kgm2IFEmuJH3D199K0IK7S2ZU4YtYeAURYzc9Tg2t2KohE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(66556008)(66946007)(4326008)(316002)(2616005)(6916009)(31696002)(66476007)(186003)(107886003)(6666004)(6512007)(2906002)(6506007)(508600001)(26005)(36756003)(53546011)(8936002)(8676002)(966005)(6486002)(5660300002)(38100700002)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFpsMVRDYjVCSmFCZTh1NWR2bm9ueTdpeHBXeFRnZXNlU2ZzWk5GN2dDbitV?=
 =?utf-8?B?RDlybW9ZMDV1dDZmTUcvM1lmaXVpV2FscnlFK1JHNS9sMDhsbitjdVZ6WVdo?=
 =?utf-8?B?Z3BQMkxZRFFQSDhDTE5zOU5OWndsY0tzMEZmdS92N01qMHhVTVd3RVBKZzlr?=
 =?utf-8?B?MHMvNHVkRS9UeUp1TXhQbXBVRWFtcVZ4NG9pajRONEZ2WFVjV0lYa292WlJk?=
 =?utf-8?B?bmFrbkQ3ZE1lQTJMS2xTYVdVVG9pVTBqdUczNTdHa1RPdnBDV2RlQUQ1QlBo?=
 =?utf-8?B?U1dLRVJ0QmZzdHZTYldSNC9SUWZHVUZPWUdoWStKYWxteTd4c1V5VVVDaTQv?=
 =?utf-8?B?c2g4MmduKzQyL3BnZTlWK0YybkhYa085T2tqa3hlbFNWRHlqZWJuWk1DU0Ew?=
 =?utf-8?B?R1QzWG1SYWxpRXNWVTdkeDYwcjR1bXRoa2dpUTJWSEZ6YTUzYXZwWlJDN1NX?=
 =?utf-8?B?RFdESWkzbW14RUd0UENBVzRiOTNTYktyS0lvaDBISkVka3pETHJSWnRXTlhO?=
 =?utf-8?B?amN2aVJvOVpwVmk3UUNLL0Q3U2NXankwdEpiR3VUS0VRM0lLUnZQTUd3VjBo?=
 =?utf-8?B?cEFkQXVlamxYRzlrUGl5ZE5QUzdmMkV2S25ZM2JxTEdpNHNQNURPb3lmdDJa?=
 =?utf-8?B?N0llOWtGWjM5c0t4L3pSK3kzdlpWakdCdk5SMkNXQlFCQ1RxaGFvZnlwaTFm?=
 =?utf-8?B?ZDE2WnN2VWpDYStMOXEzTldBY05LMm44NHovcEZ0dTVvaWluMHluOFR0MWNp?=
 =?utf-8?B?OVp1YlNLZmZWTEVwQXYyWGVGWEtWVWdBb1BjQ1FvZDJQYTlSQ0x4U3NIanJE?=
 =?utf-8?B?V1dITWdiY0FrSGtiakZscExyRDN0MlV2MllLSmpSamh1ZHJZWExOQXExcjhW?=
 =?utf-8?B?MG9OaWlwVFJwQVE2YUtxV3NBMUdBUEV1cm45UEFENDZPVXl0dGVMNnlZNkE4?=
 =?utf-8?B?a2ZlSXpvbzk0WjlFWkJXdXVzKzYzT3NlU200U1FHYWM4VnhReGtUUVZOTWww?=
 =?utf-8?B?TEZ6WCthakxHTTVETkhBNVE4L1hTamdmOWhNN2lhekQ2SWo5ekFkOEh4cWhv?=
 =?utf-8?B?YVpYMTdJalhIbFl0cFdCbDVZRmo2WmRxVjBSa0ErYlpLVlkzYU93amNLVmx4?=
 =?utf-8?B?bnN3Ni8rQ0hEcGh0dEtRSU56SHVhall2Z0VlbmdOclAyU3hFK0FXSTZqOUlj?=
 =?utf-8?B?RzNBNVlRVmVCQUZNQ0czQmtyMnNlU21vY1BtTGExelNwcjNKYmZqbWZ2ZVRq?=
 =?utf-8?B?YUdsWFRrTnhHbnhIOUF6NHdGRzVZRDI5OExDdllEdkZsMWRCMVZneFdXSlZQ?=
 =?utf-8?B?ODdaYzhpdDdsR2gzV1MxaTJiaSs5V3JXaHNBdDM4MGZJb1JWVkpRdk1tVEZt?=
 =?utf-8?B?ZmN3SHRvWDNDUDlyNmZvakZzd3pKUHBFREF6L3FjV0VVems2RjdWcWYvUE4v?=
 =?utf-8?B?TjF0aVdSUXV6NEFBNDl1alRxTWVINHZVU0hNWGZielkyUHBTOHBaamx6QWM5?=
 =?utf-8?B?SUg0OTgrRFJMakZROTFpUmFtUjdlNmk4SElTZStLOS9Uc1BBVGdaRGFLRHEx?=
 =?utf-8?B?SzFPUHhHYWlxSktaeCtYZDlZNkhVekV3eUc1c0orSEdsM01WSmQweUorVUhr?=
 =?utf-8?B?WXlYVjhiZ1lGVjZwQmVGOWVZZjhSSUpwYU5iZlpSZExWejRvbk5UeGZVeTM3?=
 =?utf-8?B?YmdJL3EvVXp5T2g4TFpmMGpBWWQrajduN3hZODBRWFRuYkdqNkhOWkJwVnB1?=
 =?utf-8?B?UVNabitSS3g0SDc4Ykx0bHErNVErV3BCSWNLWU56OW1iVTJzOWxEQkJSdnpp?=
 =?utf-8?B?Vi8rM09Td2N6cWVTd2F6OXM3ZXpVQVhVWEd3SEtMZlhXVjRLTTdraENuelV2?=
 =?utf-8?B?M0JjcG00ZmFFU3d5azlOcHM3RGJvYVdYMElveWxjWDd2RWNwZExDM21sQ3Rq?=
 =?utf-8?B?M214S3YzZnBFTmtDb3lrNnlNaFg0K1JjWWhxMzV4NGRLaHBKY0NqWnFNam1q?=
 =?utf-8?B?ZERBcEtkYmZzSm9Gdnh4UndSemw2RWNVUnpyL2dZcFlGVWRXWWhlV2VnRkNh?=
 =?utf-8?B?eU80d2ZvL2xwTXhJN2xzY2x1a0ZqRUczcEZvc3pyTC9iR2VOWXYrai9WYjZz?=
 =?utf-8?B?anoxdGN3cnc3SHBEZFA5RUp0MDliaHZ3M2h4ZG9rclU2MTNic1YybEJ0VFU3?=
 =?utf-8?B?MXg3K1hVOXBtMWEreXNPaExLWXJyelJQK1B0eFY5L1AvcnU4dWRtamZqY00v?=
 =?utf-8?B?RXgwWDVuSVhwWmpyNG9rNlNOc1owOVRuOFlnOVIzRHdaWk1IVnYveHJYd1ln?=
 =?utf-8?B?dlByNEZoTUx4U1hYc2Fvd3l4WTlyZ0dPVCs3WE1LbjFBL0c2TmdSdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9beeae-da64-4ba4-b311-08da48717098
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 10:35:28.6249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uHptTzn23oHf/fNCXKSSEVDc2bPrWsqOOjRr08l0h92m2CEygjV9qRxaq49m2qnfHTLcbJP7SypDZGckyXjGKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2610
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-06-06 20:59, Jakub Kicinski wrote:
> On Mon, 6 Jun 2022 14:29:02 +0300 Maxim Mikityanskiy wrote:
>>> The difference is that the person writing the code (who will interact
>>> with kernel defines) is likely to have a deeper understanding of the
>>> technology and have read the doc. My concern is that an ss user will
>>> have much more superficial understanding of the internals so we need
>>> to be more careful to present the information in the most meaningful
>>> way.
>>>
>>> E.g. see the patch for changing dev->operstate to UP from UNKNOWN
>>> because users are "confused". If you just call the thing "zc is enabled"
>>> I'm afraid users will start reporting that the "go fast mode" is not
>>> engaged as a bug, without appreciation for the possible side effects.
>>
>> That makes some sense to me. What about calling the ss flag
>> "zc_sendfile_ro" or "zc_ro_sendfile"? It will still be clear it's
>> zerocopy, but with some nuance.
> 
> That'd be an acceptable compromise. Hopefully sufficiently forewarned
> users will mentally remove the zc_ part and still have a meaningful
> amount of info about what the flag does.
> 
> Any reason why we wouldn't reuse the same knob for zc sendmsg()? If we
> plan to reuse it we can s/sendfile/send/ to shorten the name, perhaps.

We can even make it as short as zc_ro_tx in that case.

Regarding sendmsg, I can't anticipate what knob will be used. There is 
MSG_ZEROCOPY which is also a candidate.

Note that the constant in the header file has "SENDFILE" in its name, so 
if you want to reuse it for the future sendmsg zerocopy, we should think 
about renaming it in advance, before anyone starts using it. 
Alternatively, an alias for this constant can be added in the future.

>>> Dunno if it's useful but FWIW I pushed my WIP branch out:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=d923f1049a1ae1c2bdc1d8f0081fd9f3a35d4155
>>> https://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux.git/commit/?h=tls-wip&id=b814ee782eef62d6e2602ab3ba7b31ca03cfe44c
>>
>> I took a glance, and I agree zerocopy isn't the best name for your
>> feature. If I wanted to indicate it saves one copy, I would call it
>> "direct decrypt". "Expect no pad" also works from the point of view of
>> declaring limitations.
>>
>> Another topic to consider is whether TLS 1.3 should be part of the name,
>> and should "TlsDecryptRetry" be more specific (if a future feature also
>> retries decryption as a fallback, do we want to count these retries in
>> the same counter or in a new counter?)
> 
> I wanted to avoid the versions because TLS 1.4 may need the same
> optimization.
> 
> You have a point about the more specific counter, let me add a counter
> for NoPad being violated (tail == 0) as well as the overall "decryption
> happened twice" counter.
