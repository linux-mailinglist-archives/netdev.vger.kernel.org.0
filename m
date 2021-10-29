Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9FF4402AD
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 21:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhJ2TDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 15:03:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230126AbhJ2TDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 15:03:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with SMTP id 19THwV6T004094;
        Fri, 29 Oct 2021 12:00:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EEtEYMwyD7cyAex4sJMiuMT7ys/QtyUl8TtBsUanvow=;
 b=pb5s4a/BLOMxemm866AVAPsJ5pLiGYwh1hQ+c6/chIsyVCdR261ft7QVk/CFL4gIRhMN
 tVv3lKc5v886pE/UZbzproQvLF4uY2lzSg5Ue6TB78UX2P2w8uYK7ASWYzDhzNzFioWf
 Umw+4g2e3fxl03vwYQpLQz9K1HFNyU2IHVk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3c0b94p4by-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 29 Oct 2021 12:00:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Fri, 29 Oct 2021 12:00:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aalfJ60ghlE3LCttRw7i6i/4NCJhUmsc0MzQBWdx5FoHF8dS6yP8AAPKtkqb8vPxu6cgJ68bHxqxyg+ubGbZRhmoxjqyIo+TMURNt7BnEKOsZMCGMo/chkg0jlJNSRdO9wCdBrFnmT45DQRmI820z+x5d+/93F4Q8dRemIIqijGwx59sH1RBuGgIp9WbhUuR0LUXokmTtdoPEGIVZn5fipMH2FiBvB5PGTG4e5OSgRxFVUZryZMtZEKutRDoVQUPvGEaXVIOHsMY9+r0qz7Ppkq2tppnv3YQRD2ONS53W1eK2hzOTac4cOGoes8ae9P/tp2g/ZRVY0KGeTcgV4KTaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EEtEYMwyD7cyAex4sJMiuMT7ys/QtyUl8TtBsUanvow=;
 b=bqRLUaoju90HZzwmyvx0d7dsr2vheiaKb+Q75VIOrm0s2G2ROsU6uR2dI8TMYr3zorKgNHeZKddlyiDgB9n06ssl3RawPQsyOo+7UGMgFvDB4mPpkFukatLNkqjifLQB7kFLiE4wZoxdR4IyKkS3XFTle3gU0dzvoBNSprfXnsmmBqof7DUdZY09mZe1AbwOjUVgqTl8q1VUAx1hk1pmgPjWzP6OaA60edGLuCXsQ1Ew0fpysx06XVr+BUFrsbJXhUYnUIPhesN0wOj1pfuzaGZkuyUq8/23pxWZa2UiImnYpv83/mgIYZhLIfThxVibw7P9CGwDk8IL09L/TjyZRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4500.namprd15.prod.outlook.com (2603:10b6:806:19b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Fri, 29 Oct
 2021 19:00:36 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::51ef:4b41:5aea:3f75%6]) with mapi id 15.20.4628.023; Fri, 29 Oct 2021
 19:00:36 +0000
Message-ID: <c26c0f63-0ae3-a2d9-6c9c-05705152ae28@fb.com>
Date:   Fri, 29 Oct 2021 12:00:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a testcase for 64-bit bounds
 propagation issue.
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <andrii@kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
References: <20211029172216.88408-1-alexei.starovoitov@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211029172216.88408-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR2201CA0054.namprd22.prod.outlook.com
 (2603:10b6:301:16::28) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Received: from [IPV6:2620:10d:c085:21c1::17cb] (2620:10d:c090:400::5:47d6) by MWHPR2201CA0054.namprd22.prod.outlook.com (2603:10b6:301:16::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 19:00:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3056ebc6-8d67-4390-b93a-08d99b0e6426
X-MS-TrafficTypeDiagnostic: SA1PR15MB4500:
X-Microsoft-Antispam-PRVS: <SA1PR15MB450019150A64BDCFDF5BE9FBD3879@SA1PR15MB4500.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKm56tzXA6q8kHYYA6QnM5QBqNy28REmiF+dHR2Z+Itef5vp5p28vlber+3TbSgY2aXFKxpiCg62Befmig/Ztkwp+Rd1XI/mrA6I4VR/iRkHWF//ZzxrJQy6nkxWEx9Frnlqwew3rbY5FMAWFTDQpE7aapJGlJ+PMq9csGpb2c0r3cH7Fi9csUZU7GZIBiuzfEK51B0HeXcDTsfavwJvpjVDsgtScSZF2Qlgri63AA3UjR++WYLKtIV4k+qelLJpB9NfKykKDTgwINJBv00w/ME/iWSRCUhOlM5bxAWwpK7ASUn9Nje41PvT2kFpm0C65zVLG4V4W4gHMX01uhbED3S+DWFIKUrwv+1FJSZTEXjN5f/dE1AUvlXyBejCNM32KGj2QjzZHsKVH9NehNHaV5Vf+6UKuk6iv87NxzJj8VBLQJA6jYKQtY1UR/pM55Z2LEcKa/z+kjLW6zHE+DcOaxdQRWVM/1NYrqMj5K2Fxh+HE/rw/gJb6RU7AUXWPpeS14wP6pAcy70puq4jPrN0gL6WmFLLSlvyP27CoD+6c9t+0ZJg+YMlMSHXJIRWHluvVjU41rFUZTdSfvUWQ0mF5VFzLu02Dg72QGK+4zS9oVZquT9U1bt+3gC4VHI0Fde8XdGMPQK0MYci2LM/nZ5Pws3nEdhMh2wgz9Kip9kb/z3yCPubSJc6lDw6S9AEcazw6W3TuNd52IiWR7+zXr+1iSRwz/OG5HU5r5qsnxdluJb/YDqhyaoW+LCEJkZDuJJECU/WyqY+JW1aOtmTj651qMpwKvnBJItoCuJCKYvrjtnUOVYGlb0rqEXhegUGPikyIguPKo68rxHFio+m334sdw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(316002)(53546011)(66476007)(36756003)(31696002)(66556008)(83380400001)(2906002)(2616005)(66946007)(86362001)(6486002)(186003)(52116002)(4744005)(5660300002)(8676002)(31686004)(4326008)(966005)(508600001)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVZHSURFdDAyVTQ1Ni9MWUwvSDJqZ00vUk02V0kzdWQrMkNhd05MN2dtRFJi?=
 =?utf-8?B?aGtNd1JETTk3eWxSd3FWZStrUm5nN2RKTEMwbTliM2pCdnFiZFl3R1ZJVDFN?=
 =?utf-8?B?R3BObG8yRjZqZlJtenVpbDJVenNoWlhaMmpWT0Q0bVlxTVMvYk5sMlVWcG9Q?=
 =?utf-8?B?MkZReCtiRWFydTRkenRBaHZaL3lnUkVHamFsVTRYM0hzR09QTDZuOFcvNFFy?=
 =?utf-8?B?RDZXQ3RNWi9Vckh2bkR6c2tacWVWS0hXZzRqMHpwVkdPUE9QTXhoWnN1QWVO?=
 =?utf-8?B?ejY5c2gwREs3N0QwT2dQa2xiNWY1anJEQlZzcTRuUmc4SHlOaTFYUU9UU3hD?=
 =?utf-8?B?K0RjbVVHZ2NXOG5Dc1JuQjhLV3VlZVRoNFcxM0VVUStHRmFzSkREQjY1Sm9n?=
 =?utf-8?B?SXpwdmcreVNxNHVCS2hqTGlKVEhPT3ZxekpucTlxSlJVb0ZIeUNYaElYdytS?=
 =?utf-8?B?V2d3bzRsM2Z0UzVRQ1AvNmpMeHlIdEpwZkxnaDI3djZLSE1uUWRHOHVpMStz?=
 =?utf-8?B?eU51Y1VHWDR6NDkrUnVKeGptdDJFZ2hBTVhXWlFhQXloU210a3M1UEQrL0Rp?=
 =?utf-8?B?VS9QT1RJU3hyYUtWNWtMbHBnczlROW95cXdySXZBY3Nmb052Y29FbUJWZ1hI?=
 =?utf-8?B?Q1hldVlmSkU5bVg4UFdkTE5xN29vVGx1bG5kMzZwZnd6d2pTZ3BvM0phdThQ?=
 =?utf-8?B?Rk9JMnRDTVhlZEpxQ3ovbWRqVkk3NjEwRy8yb2p5YkFKMldvZVFoTUkzY2hw?=
 =?utf-8?B?LzNTdU5VMG9vU094aFV3RW05a2V0UnRwYzBLQ1Y4dUVQa1ZPNjBOZ01Xb3JV?=
 =?utf-8?B?VTZwVmxLS3VKWWFranlTNnJIbHZkSXhJOXErTkF1RElDb2R4WDlueVA5TFEw?=
 =?utf-8?B?NWlsbTJHY1lYQkp1N3BuK3dROUdsN1ovTXZSZ3J1UjlXaStVdW1zTlg5SlRm?=
 =?utf-8?B?Umdnd3Z6TGRCMzVqRWJqWUNVQVZFdEFCTXR6QktHVnQ3dTJBYnhYWU1ub0pj?=
 =?utf-8?B?ditEczRDZzZWemFZTnNIOGd5eVIvMldUVkE0Q2pZUUt3M1RWYWMrbWxESHB0?=
 =?utf-8?B?RFFPalhkZ3RKa1V6M3Rvb0xCN0hUNldDSE94ODlhQUREbXV2dytOaXFQaE8r?=
 =?utf-8?B?OVN5cXkwS0Nlb3FlNkdOeDI3VXBkVUszdDMzOG5LRGg4dzZuMXlueDh0ZUxJ?=
 =?utf-8?B?a0xhUnkySGtiQ05kYmh2R0pxTFMydFFpc0xrUXdOdXU2ajQxS00yS2ZNUHZq?=
 =?utf-8?B?ZWowK3VMNWtSM1ZBSkRYNlM5OENXeW9jeFZsWlZmR0lKK1JyNTZhdEN4V240?=
 =?utf-8?B?aHpIdldaanFJN2huQVQ3M2laY3V4VXdYV29uTzA0eTNzRnExdG1wa0N0Y2Ev?=
 =?utf-8?B?VVZWNC9JRFhESXQwSnRPSXJUZVp5dmlLTStqYWV3QTY5UnVqblZMZkl2cjlF?=
 =?utf-8?B?c28zcnZmd2F0V2hUTE1KTVl1MDl2dk81VTdoMExmMXJRazBPb3BXRTVRcXlv?=
 =?utf-8?B?Sm9EMmxRWDVyWHN2akxWVGplQXNGV01ibDZXOXY3LzMwT3hxTGVyT0Q4a3VS?=
 =?utf-8?B?Vk95MEJPdFRUd3dtSDBLQk9oQVh2cHVnZ2VCUVhSSVhXYUtPVXpDc29VMy93?=
 =?utf-8?B?VzNOeGFXVVdnYzZHd0JyWURkSHNvaUJYbDVVKzBXYXc3cmR0WVNxRjQwNm1L?=
 =?utf-8?B?SkdSUEgwUTNLMVVQNlFicjVDVUFyRDU0NVNZN0NMSW9QaE9CcVlFdHpHRU4y?=
 =?utf-8?B?VVB4NFAvVjlHektxM21jc3IyYWdBQW1qOW1IeVFLTXk3Zm5yK3VlY1Y3R0Vm?=
 =?utf-8?B?VmR5WGViZG5SU2wwYitDTlhlRFVBbWFVTnhOUnJVWHJtZGZaOFVVREVac09N?=
 =?utf-8?B?VHFtdDhhTFVhNHJzcHROTzRiV1o4NmZiZlJ2ZkNPZkVwZGY4UTY0VGNRcHE4?=
 =?utf-8?B?VUJLczlxc1Z4RC8rK1RJOHRXb0dOc1pvK01WOEFieXpjME9kdktDT2VqcjhO?=
 =?utf-8?B?RE14Nk5HaDFmVEIzcDN4eC9aQTl2QUlkWmRTenFmOTVva25nZ2NGaEJuRGk3?=
 =?utf-8?B?cml0WFVxMmFNbExMalUrQ0lueVBtb3plU3lZZnNaOXI1bjl4SkRhQ05kMjlz?=
 =?utf-8?B?RlpvajN6b2w3bmpWTnMzRzJvZDhoQklUak5yTTRjd3lDZkUxcGs2MjkrS3dl?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3056ebc6-8d67-4390-b93a-08d99b0e6426
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 19:00:36.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvAB1CdNzH4x7mUDa+cY5XSLvKrGaztvevFg7+359QrJKwZ7MmszHZj0o3+SGcM4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4500
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 8NabJsawpPOesg0b53_9K5R-kjuopX2O
X-Proofpoint-ORIG-GUID: 8NabJsawpPOesg0b53_9K5R-kjuopX2O
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_04,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 priorityscore=1501 mlxlogscore=747 phishscore=0 bulkscore=0 clxscore=1015
 spamscore=0 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2110290104
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/29/21 10:22 AM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> ./test_progs-no_alu32 -vv -t twfw
> 
> Before the fix:

It is not clear which "fix" it is. I believe the fix is this one:
 
https://lore.kernel.org/bpf/20211029163102.80290-1-alexei.starovoitov@gmail.com/
Put this patch and the "fix" patch in the series will make it
clear which kernel patch fixed the issue.

> 19: (25) if r1 > 0x3f goto pc+6
>   R1_w=inv(id=0,umax_value=63,var_off=(0x0; 0xff),s32_max_value=255,u32_max_value=255)
> 
> and eventually:
> 
> invalid access to map value, value_size=8 off=7 size=8
> R6 max value is outside of the allowed memory range
> libbpf: failed to load object 'no_alu32/twfw.o'
> 
> After the fix:
> 19: (25) if r1 > 0x3f goto pc+6
>   R1_w=inv(id=0,umax_value=63,var_off=(0x0; 0x3f))
> 
> verif_twfw:OK
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
