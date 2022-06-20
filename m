Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BF3552434
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343577AbiFTSsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343621AbiFTSse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:48:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5231063F9;
        Mon, 20 Jun 2022 11:48:33 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 25KFIJZp010800;
        Mon, 20 Jun 2022 11:48:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ILl9jNqradX78KiS55v+M1Sf8SHefP9G5qWvhFuuqsQ=;
 b=bfpDquyBDf5cVK8hc7m56me+nXfyl5D2yb0m8E+8oweQ10xuenhfSxgpFQb8ZoAelK0F
 8kaqJyZqBfmmkFQemcvYwWOCosB9ZD0pO2DeuaOmaxSrSvmDaRec15zxSra4RyzRq56h
 0mJtsBjr/a80EbsEUN6V/EiWApzCEykmEfU= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by m0001303.ppops.net (PPS) with ESMTPS id 3gsacvu2sf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jun 2022 11:48:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JlQwlqMj7PZMhvhK8upWWyUtuLhFd2zhLmoq3EKTgeQscX9arr/RLdJwKk6976ANZuV+5NCGcy95tQcoQZQjyxEql4H7veTKTLK0leA26axRSXAcZiRHIQgSd5e9HoxpbpKtxvCw4A0An2fGJ9dBMHtgUBROuJ09LLCHO5O2Omtb/fAsLNuF+QfyWqR5Sdj2XHUJVP6Fr+bW+tngedHkMqnKCHodE0kTbYif3D8c6nN4cAYomwgndeiVkRcKocRqw6Rdy9og1FaxjR/owjTkHqqOA2Y0zJi9EBH/eF0InPHs44vtha/xt17TMzJSMmdnTFrpmRkVGMntppE0TnmA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILl9jNqradX78KiS55v+M1Sf8SHefP9G5qWvhFuuqsQ=;
 b=I7rJAhNaMWy8Lw7g87oTQ4RhjQYgY/3zNpiNLs8lCEu2OeG6vnR0INUByHIoHtiQ30RXvtxzSbwwkFldInVzS9FzI6oWqHL76EGpb86t/XJYxhuGVcbEib6cvwyXIjRtPvIi244h7C+zR3H3KCF+Ml0fv2wUp9ZlyGVK62QP8Z7vSfPwWlEQLAEkf8EFX2AR/jykNm/UrH+mn32VhGWQlB3Ye5DSaE7hzudEvQaJgXbB1wL0Ai2fXaBdY4qsPLhTpj5kQTCWKwJMbVjsR3k0Xmg3OQMCjAo97DZkItihV28J4mioJqvUtzOtmEBFN4LpHcSzthuu5122m7g9ZjRo5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB3219.namprd15.prod.outlook.com (2603:10b6:408:77::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 18:48:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::482a:2ab1:26f8:3268]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::482a:2ab1:26f8:3268%5]) with mapi id 15.20.5353.021; Mon, 20 Jun 2022
 18:48:11 +0000
Message-ID: <ee47c4af-aa4f-3ede-74b9-5d952df2fb1e@fb.com>
Date:   Mon, 20 Jun 2022 11:48:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH bpf-next v2 3/8] bpf, iter: Fix the condition on p when
 calling stop.
Content-Language: en-US
To:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>, Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220610194435.2268290-1-yosryahmed@google.com>
 <20220610194435.2268290-4-yosryahmed@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220610194435.2268290-4-yosryahmed@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::6) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a79b0aa5-5017-4128-1fa9-08da52ed6ce4
X-MS-TrafficTypeDiagnostic: BN8PR15MB3219:EE_
X-Microsoft-Antispam-PRVS: <BN8PR15MB3219489C9D90A960C66C305ED3B09@BN8PR15MB3219.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SNVCVrU6ZCi298rpFYaux7R6DK+hWY0ryVFG3y/qUKHSIHPzF6C+sVhJ+3OUspAEw/fpf7/xhPoh3Kzf/Y2MeTU53Vlvi/YOqDMs0nv3VqltH8HbHoU0JOZLt7BzYS3NHfA7OTbR1jhOJlGxKjoHq2OFQslg5/GSNx5RL32jmYGsy4OUyGyA5JC0QDM+lngSb5wsHW4ng/ZLxYF76g4R2JLr7JNITRL1vEJ6TNpjIj28tz39g0KTb6vir4dTGjARa9JwhDZ78D4bJA8D8a+iXFqUYzsxcwJnn2i5Fa4/1XzvUzDHUEQ8iERwWU0SArlZPDzfpM5dOX2mRFlh/gu7QQUyKTpb45Ik9Qgv20Gbu7PaykLauuqTC9B9cOqAh5JwSUXTHXSFiDomvrGOecam4p/Qr28t1TQ3F3mswlFNZBbgCOdblU63yaiMDC9s+UaneE7ZVotpvP+KdGPDbFwZGmy88Qhj7eOaBlE15LLXTxfZE92NHnWPbhhE8FrIe7IKcpD2mATpSkBygla6M4tkVTMlptK5+VT2O/q2JDf80dmP3Wif1k+Qe2vKfR61gRFSHMJBIY3f6MVADWYYK/FZof2tBTDl7PgsSL5OaJQBCz+buP3KH9XT657QFrPnehhzknat0r47S2k8sp4MFYZD0XYPd9P3Gd79h1rBqMaMJBSMW8QclglBcnXLSSFOJQOuA3PagLF8+8m/Ns2RcfmFobEtkgtk2JgTiiXEFv7z1qEyYQBmS/V20tpY1ZhQzFRu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(186003)(921005)(5660300002)(6666004)(38100700002)(6506007)(31686004)(53546011)(4326008)(2906002)(316002)(6486002)(478600001)(54906003)(110136005)(4744005)(66476007)(2616005)(41300700001)(6512007)(66556008)(66946007)(8676002)(8936002)(86362001)(7416002)(36756003)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTFiamkwL2VETlJaZ1cxSEtvRERUQzAzai9FL2pLRFRFNHNjbUlvQmNtaDJa?=
 =?utf-8?B?dzhETW1TVFFuV2VBaXkxUGpPbkc5b1JiaUZDMEhyMk9LL3RXT3RmMnd6aUsz?=
 =?utf-8?B?UllDNXQxZVc3R04rQXd0VDN5VFhldHZ3dEVTNHM0UWRhbjlQbFFQRDF6aU5Q?=
 =?utf-8?B?aURIbFV2VVRBOWdXalh3N25HRW5zQXU0NDFHR1VOQVFvZWVCMmt1Umk5Zk05?=
 =?utf-8?B?eEtlT3VUWmZja3dKV01nZjFwN2lDVXVXV2JKM0Z1TkI5d1hHSkQ2RXRNVE80?=
 =?utf-8?B?a09YbEc2QXpsUXg0VXhSeXNLdHRHRTE0M1FRc25FNXI1VTdyZjZUSkRTZnVD?=
 =?utf-8?B?RXM2cUlIenNmOEpJenJDRkk3emhDa1RPanZxNldXTVJJbm1iSUlsN3p4ZHFT?=
 =?utf-8?B?bU1iSnkxa3FhU2ZsYnVSNGJ2SktMNXkxclRjVExnTWI0K0o0SjR0NkR3amVq?=
 =?utf-8?B?NXFBOGJUT2cwempnM04ycmxjVHhCeHc3WVZwK3BaQmRvYXkvdjFiTlZUMk9Z?=
 =?utf-8?B?bHFwQkNWYllLRUNUMnA5clJ6dTJJZSttenB6dUd6T3M2MDRnYnpwbGcxam1m?=
 =?utf-8?B?MkxjejNDU3lyKzlhZ3dLTGtoM05Mc1RPK3BocGlGaE0rOENvQ25oenpPaWZB?=
 =?utf-8?B?YXpYWmR2K3J1U3dlTy9oa1o1QzRKOGR6WHZ3VStPSEEyWmMycmMrWUZreHlG?=
 =?utf-8?B?Y25DdTEyM2NmMGhWS1pPS1NQVWJUckN1MXh2T2lXYU5jYk83YXlYTkdCTVRv?=
 =?utf-8?B?b3VyY0crd3FHdHlEc01QMDJWWFN1V3l6ZVYva2c5a1VaUnpvNGc4NndlKy96?=
 =?utf-8?B?a3JZNk9aTmxPTEdseTErVGhMVzBXTWZBd3lzLzZXUTV1SWUvTTUxQlN3Z3l3?=
 =?utf-8?B?MDJKMXpQK1hmdFBKa0w5SGJZWk0xcHNZUmtab29yTWd1ZU9sNURheEt5SjJZ?=
 =?utf-8?B?WWIzTFVaMDB4RUozNlFUMGdxaFhKSWtzMFVLTDNoSGlUa093RkFkdG5MaHJj?=
 =?utf-8?B?WG0rOUt2SWhDVnN3WUFBLytBYVFlc09kL242NDFXU21VZ3U4RWVyK2ZZZ3V3?=
 =?utf-8?B?TjFmSzU5aHEva2c1eUllRVp0MjY5R2JZaGZ1bFBzMFpBcnowc1ZHbklxMzJO?=
 =?utf-8?B?eUNjYmlxejV3bWp1eTEwWGtCZ05lWWxZNzFFN01GdUhJV1ZxcnNtSlZTWElN?=
 =?utf-8?B?V1EwQXFFNVhsQnBWS0RJWkN3eHlYOTVteC8xVjV5SVBZQXBhWG1EZ1dYM09w?=
 =?utf-8?B?TlNneVBBVHROUDFwcEhJd1VlUklwK2FiK201U3d0Y0tTRGpnZms4dDR0NEYx?=
 =?utf-8?B?Qjl0R1YwQk9PR00yUmMzV010V0dKajlzN2FMMk13NER6dXd2SHdOMGk5MEJq?=
 =?utf-8?B?RGZxRXFsQUtLeEtHNnZvUitYTy9KYjFQcDVtS243a21pblRmOElwSFVCaXJF?=
 =?utf-8?B?cjZoczBqWXhrMW9UQUFIZGd4YUV6M1U4TUh1UzBFbkdwcEpTbjZLTWZVMzl4?=
 =?utf-8?B?bWNqaXhhOXRiVUdqcVI4STF6VnplOXFLTCtnUkJFMWc1MlhKeUZaN1hRczhZ?=
 =?utf-8?B?cGQwQXJ2cUpzcjJLY0I3VkJ4U3FRY0FiT0l1ZkwwWVRYQ1IwTXhwWEZSbzNY?=
 =?utf-8?B?ajA1VmFGMnRCdmYvTnB2TENUeVNod1NTTWxXOHozSlgrR050Zmc3MGFGSEls?=
 =?utf-8?B?YUZXangrUWZxeThTMUh2WWNyaDFIVUptdzcwMGlzaXd1d0dNcHAzdHZPdHNz?=
 =?utf-8?B?MStlSnNjczFzS05qbWxxejlmMWRqbnJ2RFBDLzI0eVhZTnNJOE1pOW1aYzRY?=
 =?utf-8?B?dG5BZGoyNHNoOHBWbGozYjBteGIyR2xyNWFoamdZNWRTT0s3SG9rWFpraEVv?=
 =?utf-8?B?NUh6VUVrZHJFZCsrY3dJTTZFUG9ZMXduS0FpVjEzMU5EMFlEakVHNDV3U1Zu?=
 =?utf-8?B?Q3NtNVFlN010Tkt2cVV6NTdsTHMzMXpyYWFVeUovNDVjdEtpQlRMNWFqT21u?=
 =?utf-8?B?WVFjcFN2U0pST29wbHFoZkNUekJicTE5TnJ3R2pNZ1N4T1Jwd2NLZjlzZWVP?=
 =?utf-8?B?RitKMjJJb3dXVGxHNFF0RC8xMjFpZ1k2dUpiWjJWaXRZbGdDWW45Q09jSjg0?=
 =?utf-8?B?N1FDZXJoR0pFaXRHZFNjNUxPdU5tb2VQODlpanEvS3lMVURvNGZFeFVodm9M?=
 =?utf-8?B?ZnNuQzEzU3ZOVVh0SHB1QlFwMUhtck81NVBWS0JVRnFuZy9LMStzK0UrNjBC?=
 =?utf-8?B?Z2RNZUpFMWFrZGZ3dkppVkNHTlA3VzkvR1lPL3V2TEdnc3Z0UFRCcys5L0hj?=
 =?utf-8?B?Z0JKMnNXRzE5NlEzZ1RRdGZwWFAra1FOYisrVVlTSWo4RjcvVlcyYURHSzVi?=
 =?utf-8?Q?lfnpXEXs72iPNU4o=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79b0aa5-5017-4128-1fa9-08da52ed6ce4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 18:48:11.6306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DpM/N1RB/EAwXXc3Ai0Rv34E9nmXAPNwRR5jeskzNR78XNxdRqtDv0JZB5cJiD1Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3219
X-Proofpoint-ORIG-GUID: AML8HPF_l7IzOXJ24pIpgA2mL1tBw92m
X-Proofpoint-GUID: AML8HPF_l7IzOXJ24pIpgA2mL1tBw92m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-20_05,2022-06-17_01,2022-02-23_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/22 12:44 PM, Yosry Ahmed wrote:
> From: Hao Luo <haoluo@google.com>
> 
> In bpf_seq_read, seq->op->next() could return an ERR and jump to
> the label stop. However, the existing code in stop does not handle
> the case when p (returned from next()) is an ERR. Adds the handling
> of ERR of p by converting p into an error and jumping to done.
> 
> Because all the current implementations do not have a case that
> returns ERR from next(), so this patch doesn't have behavior changes
> right now.
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>

Acked-by: Yonghong Song <yhs@fb.com>
