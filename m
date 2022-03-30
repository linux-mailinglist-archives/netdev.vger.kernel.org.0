Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA34EB8B2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242248AbiC3DSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbiC3DSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:18:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF0C181B2E;
        Tue, 29 Mar 2022 20:16:30 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22U0cNr3015825;
        Tue, 29 Mar 2022 20:16:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=rQIiUTXtSOo4u0wCFjn4/dvBH6GL9gkTM6KzJ+ccmSY=;
 b=p4gfoSZRE5BVoBHcBCXGmNPGWJ1p1FB/3FIzDyRYsBnVn6ORXRICgLQ9Je32Q2+BcwPQ
 sqLgGnN1zCIcIkGxtZhu+xdBTUVhiXAsLNiqcEPlhLu+0GawND2aGo7qPshIr0XgsW1y
 imUrCy0ti/YXHrzg34jY+S/Fu6e5mIkvxMQ= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f3rab092x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Mar 2022 20:16:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPr1pQm9D/OfY2DrPct/kZYAo15nhRXnOfzYH1KmbvIuWYdej4bBQzxf1U6Af3dtp3rxXDiT4c8rFGFLuikZe5RB+9nZk06ghlWIto78LjYD+XS2Pn57T+FWq2r/Gbe4LrdwdtMQRByRMxjpX6JKmt5G2kgeKWdQMedzBk99WJLw9vYPuCvkCTW4Jg7czluvW2AtWvYqQ3Ys7W11gcMI9iZjd3pmsP4UL2EPkU9M3ucW2fxwvHxqpwYixcWTbt+EOLbpEM7o6ripty8pPBBhJyVsKyaIX3trYdl53Zq3l2R3UB4cNUQDRKJm+17y3NBWkw4L8EYfl8/6yowvYeo7RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rQIiUTXtSOo4u0wCFjn4/dvBH6GL9gkTM6KzJ+ccmSY=;
 b=YZdWtS70lbR85CgSY2Z8DpYVIRmqaf12bThGvo3A2Sn+tRB1/FH47MdesjslrkY6VIyzLiXpXmiMswPCpBS+sZx8yf8I8CkUd3bPTxUagNayzJ1hJUUAlMYho1XtOQlRook4JOEUOa0iGi7PZ+8MonTz2V/68CrRaZHdivYiJiGT8C+hfYDFGWd8hIPoCqCfQ6bdBLJAHfOKjseh94+COv/BdCclmpsNRwRPPKVVEJdIqPZI0XOHw2Rl3gIuso3iwYP5/5fc6YNkIveXR4u9vqFp0Hz9H58vZ5o3SVNmQdOX1DpcK60MHDOm4EsUOTUkbtmblMhgXnMaGep41zEMDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4425.namprd15.prod.outlook.com (2603:10b6:303:102::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.18; Wed, 30 Mar
 2022 03:16:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::4da5:c3b4:371e:28c2%7]) with mapi id 15.20.5123.016; Wed, 30 Mar 2022
 03:16:11 +0000
Message-ID: <11f618a9-7710-d235-bbec-5554b27512e2@fb.com>
Date:   Tue, 29 Mar 2022 20:16:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH V2] selftests/bpf: Fix warning comparing pointer to 0
Content-Language: en-US
To:     Haowen Bai <baihaowen@meizu.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <29503ac1-69ab-a0b7-53bc-5a7522baa289@linuxfoundation.org>
 <1648605588-19269-1-git-send-email-baihaowen@meizu.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <1648605588-19269-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0245.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96e49d06-11ca-46b1-d8aa-08da11fba417
X-MS-TrafficTypeDiagnostic: MW4PR15MB4425:EE_
X-Microsoft-Antispam-PRVS: <MW4PR15MB44254D608CD8C5C36D1FBC0FD31F9@MW4PR15MB4425.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSZ1hNEfEh7KSYuE4MMITDsu2M6EUF7fYPpp5w27ZfkaedoEpn0A76Yj6qYpV0yy8BzMvIQHg6Oht72yNv+GAEQdlDJqFwegN4yvCf5N1L0eA/qPIYcNsQwCvTZAIUt6o9zil8Z1LbAt+HFhACyuwsJUM4aJqk4knhFph8dfajV2b0/sm74bvdh8vvB7ty6JB33pG+l0zrLkjavo74CBo4zs5aWRw0GtLdKzrnTvTB1TajDXvQhkaxdwM9++mzcHW0zKlI0VMQNtXZeTq3/vA9L9guhhybPPVsW6cg0F4PdYev6h4ewYyR8Z0k2hmO6BRYu+8FrNIQHEQspzj+Zb5q4C3vqMoIL+HoUwT6I9UhqE1GPLuICo88zbH3Y9W0gvV2DURlI8RaviYQpsD6NdTRe3jquw89pa0rR1B7riwVyPCR4tEzW251Pf6PI0CjSMwrLMt/n0cxRIeQUSQw/Mr4joS4zlGsxoanIn8j/Zweb6IMpoHceFgfYQrQmUrbqrL8uWQkdJtAw65Uz1scaKRQsHlr/ouZYi9yV4mlL2lC7cXJoKfE7H142loANDfVeZN/Fp1yDGZm8MmUVZ0cAlcSQH1ALLQQXrqlg9P+33OWOImdGgltJpHvYFlXy2roe0/QIxgUgkITXqjcuMpJeRjkASIqmpbBQrG1b063Rc6lR0W+WHYDLeXUhYKDAth0lTxMFprYJYQxdDt1s1112LsYS2Hkk12EubqWvT9/q6hfE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(66556008)(66476007)(31696002)(5660300002)(86362001)(7416002)(31686004)(4744005)(66946007)(2906002)(8936002)(4326008)(8676002)(36756003)(110136005)(316002)(38100700002)(53546011)(2616005)(6512007)(6666004)(6506007)(52116002)(83380400001)(508600001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0owM1JTbHlHTk96b0xrM1VyM3A4YkFnMVR6YzUranZLYnZpdXVwMU0wWDlq?=
 =?utf-8?B?U3F2a2k2TyswUnVCK3AxTjBKOWFFU0tIdXYxT2owQ2NOREJGaWZHb3RpbHVN?=
 =?utf-8?B?ZTZaTERJNytPNC9qWGtiVlZLRFZwcjJ4M2tmQWZpa2FmTk5vU2JBYmJadHZo?=
 =?utf-8?B?S3FuUlAvQ1cxK2FSTThWNS9vOEpNdTRPWUNvbTc1ZGR5SGhkd1dKM3FXSUoy?=
 =?utf-8?B?RnNzNFdrZDlTbzI5UkdkaGRvNXcwZWFzVGhpN1hkbGtHTHdZWEJDK0tzQ3li?=
 =?utf-8?B?K3M5OGhkNFFaaWxLR3V3Qis0S2JOU0lWSTBqakZlQTE3UWdFQVkzeTRqajN4?=
 =?utf-8?B?OUFxUGpZN21yNVZxd2pCQjJWajFmL012QkFHUjZndGJ3SzFkQ2JueU1MWnZx?=
 =?utf-8?B?cEVuOFFuMmtDVVhOTEorZEhLS0FXbkRjYnlHamszMFVlbVQ3NVNyempTWEhv?=
 =?utf-8?B?Q3VDS3Vvc09uYXlQS3FXeEQvSFRPYit4K3lMSzB6dlExNnpHVnlBdFEyN05Y?=
 =?utf-8?B?aUJlQ2s1UVJtS256c1pQdm1RMTNGZEorNkxjbXVGeWdiUzRtV3dPelY4WUhF?=
 =?utf-8?B?UEcra2dyTzVTd3BBQi9kNmVKcGVOWkZIM0xNeVFPd3VUZ0ZSNTBNY1ptSVB5?=
 =?utf-8?B?YmlIdmNoL2w3QWFobkdmYUhRVytsZ3BwUWZGSi9CUU10ZjBpNkRPaVVVWk5E?=
 =?utf-8?B?SXA0NndDRk8rRjdVSWlsdHZYcWd4QkgzWWRDOWJHbHByMEZIeXpVdEFZbXUx?=
 =?utf-8?B?ZGx1eXh6NzdqUmIwWnpVMzlwd1N4cENiVGJReHdvaXRFZnVVbUsxbzh4bFBh?=
 =?utf-8?B?NEpuSUdyeXJnTEtIWXA3L1Z1N0VKQXhSS0VXRjJLdzFtUThFL0kzaFkrSTlu?=
 =?utf-8?B?YzlaMnUzTWxSNEMvYzZ6NEtqMDRrOFBDMnRqWEg0YS8yenU4WVlVZXJHMEJY?=
 =?utf-8?B?SHNNQmp0d3FFMm50VjlpUUY0VUJUZklwSWVudWVhK3hhWko3cldua254NTVp?=
 =?utf-8?B?eTIzUTNCSFNvSm5wUjMySFZnMmttNmIzRHNJUmxVZVpETkdoSnVkMUtNeTNl?=
 =?utf-8?B?N3FNN01IcE1RRzFCbXNMd3RqcUhEUkI3V2VTMEJoVzA0WnhUeDZFTmhYQTVR?=
 =?utf-8?B?MW1Mc3pWTE15M01VaE8xWDZwaXVaOXVydk9OU1liM1RVTmErVkk2S1ZrYVQz?=
 =?utf-8?B?UTRjelMyYUVBZnZMVUFram5WVUpNdVcrRTFXSkhYcHA0eU9oUzQ2ZlU5dXJC?=
 =?utf-8?B?aXRLeEZoQ2gyRnordGt6QW9QcUZ4OE91akZEMHhJTFR6eE5oL0kzdkl4QkJz?=
 =?utf-8?B?MWk2WjJWUjJiUDhzOU5ZM3dQeUVNUlJ0VkV1dElDUlZXUkRwK2hSTmI5cFdr?=
 =?utf-8?B?ZWNoQ1RCUUZDSTdUQkZiNVcwZjhGRWlJK3N5Nm1QbjVNUElQWVZCNk9FOU14?=
 =?utf-8?B?eHJHU2tpOElXSkpuSUZnVnFURE83NTlXekNCYjFjbzBKQmdodEZIOUsvd0c0?=
 =?utf-8?B?T0x5VkxsY3NuM1JOUi8xZUErWHNFV0hQbEQ3bkhXVDljZjJNVllnK1Q3RmZn?=
 =?utf-8?B?aDBnVEFReXVQaGk2dmovMWZQMFpZUnVRbk9ORFY1d215dGhQTzN1REROZUVs?=
 =?utf-8?B?UE9WY1RvZmV6Qi9WMFBHS2pkejlQODZuQlJUQktubnJnMGhNRExDSnpucDJm?=
 =?utf-8?B?Ni9KMmwwVWVsVDlYMWM1Zjlrd1FVeEJPOStvRDcvdHVOdE1nUTJDR0ZLNjJt?=
 =?utf-8?B?YnpkRklFUFFrRnpNaVVraUFZOEJHUS80eEhLT3dheU1OUFRxeWJ2TUF0SEMv?=
 =?utf-8?B?V2dRblFLZWxobDNEOVJTVmhwUFJCUHFXUXN6anZVNHRmU0NKSkFRc1JKMklh?=
 =?utf-8?B?Q0h5c3R1MUJqR09rVTM4UWh6dEtqWGRrVkx2aS9qZXFpNEpTU3pHTzhyOVoy?=
 =?utf-8?B?U202aDRwWHpZT3BTcGZWRmp3OXY4SE1zVFI3bTFUdjNadnlhWTBCR0tHYlRV?=
 =?utf-8?B?aTRjNVVQQXhEZGpwbi9wTU1FWmc5NkE4ditLWTBGNEEvUG9RZktuWnJCc2l6?=
 =?utf-8?B?bnpJNnFNeW1DT3U3bUxkR05tRnNmMHREenlrUllnMFlNVGlnNDI2N0JCZzJv?=
 =?utf-8?B?T2lPejh2bGhaQVhXVUh5MWxVc2lxUHd2OXFWbnhackpMcjFmTEJHZldvaVg4?=
 =?utf-8?B?eVlwUlFLYWJ1QzNGS25wVFFWMVhPanA3dnFQOEJmdTJXQXFVeG03aURuczg1?=
 =?utf-8?B?cSt6OHRRcGt0bmlZWDh6UkNaOUwzcDBlazJpWDFCSDVoTUUvMEt5RytYT0Vj?=
 =?utf-8?B?a0lWTUxFcVEwM1RRQmF4cVhpSTlIcCtNb3YrNUVxRUl1R3NieklTNHF6d2Nr?=
 =?utf-8?Q?vC8RPGf38TEs1YEI=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e49d06-11ca-46b1-d8aa-08da11fba417
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2022 03:16:11.5398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ctqgw5rEIoE6B6pDVx8z7eCtLnLJ23jWfpXStLcwbE3G6AkFaCof9EPAzow0CnqP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4425
X-Proofpoint-ORIG-GUID: 4u7DCTIO45tQ-A-NJHp7q3Th6O1iliFL
X-Proofpoint-GUID: 4u7DCTIO45tQ-A-NJHp7q3Th6O1iliFL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-29_10,2022-03-29_01,2022-02-23_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/29/22 6:59 PM, Haowen Bai wrote:
> Avoid pointer type value compared with 0 to make code clear.
> 
> reported by coccicheck:
> tools/testing/selftests/bpf/progs/map_ptr_kern.c:370:21-22:
> WARNING comparing pointer to 0
> tools/testing/selftests/bpf/progs/map_ptr_kern.c:397:21-22:
> WARNING comparing pointer to 0
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>

Acked-by: Yonghong Song <yhs@fb.com>
