Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 609CC3A193A
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 17:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235021AbhFIPXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 11:23:13 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15636 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232952AbhFIPXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 11:23:03 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 159FA3io012223;
        Wed, 9 Jun 2021 08:20:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=8SbciJtJ8ouZo0i4YAKbAZfBYtp3t0otJEtlIzy6wAI=;
 b=WURazFYtJ8pZM39EdgfIkOmF7H7oe8wnqwJl8ulRg51T4hRxX2T2aQh59KqkjvD1F5RA
 0SUt8mU9fQsKh1xL0f53LLwBOwEoBxcxBJ9CMFJotZkjOrCBSMuG7/C63dw3FLyzhnfP
 GyT+9dIbGJ4ySCgXauvgPsT3DqI6o3Q2yOo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 392qx62w0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Jun 2021 08:20:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 08:20:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+JU2zkvZhiV1pmwTdbvh5KjkN6qw6zVY+gUIzgrZnhLwYo9omIhDzN/enua8OsLRGcigi8dvPoqJ7vHjQMHEadyad1Vltlt8VTyu5qngAzXBo94Ynk3eFAjsB7Iq1Ccpygt5U9NCyagv51dXT2kpXFrhwxZxJB/rMLrM5zsUL5kcV/FzQFxsjCZYbXC75Odv7oe/zxlFaEYe7bnNm+/XOycmCIQXTQl4ns8Zlfxu0ErbmwVyaD4gOVW9n2cTymf58xryOMWa8wYdw6XmSLiPRZ8iUSkJb2OYtHkjhAlpSqaS02osDA/9E94ev25YDfNt1daiRx7oM4LMb62Tk87Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SbciJtJ8ouZo0i4YAKbAZfBYtp3t0otJEtlIzy6wAI=;
 b=mIkI5cQldTPb5+cxHGJFodAJJdwLLj7tuP9QAEI28W3t8iOEJ7n5Kyfoy2SXeqNaLD/Mbh+1FJkX1vYyWtjKTkwleKQGbysK3wlLg+K72W6O/WQ9vdqjcoDjrJsFhuhr1FAHBPH1pSk+YZ1WZfgSuaIiF5IVSpoaC2ZpWLFo7OH+eyWOTPi6RG2oQ56nNf0tKoAAiPSXdqaw13BQ9u+Qv4/xuhqk5BeEd9G7uNgRjVH9iX/1iLlp4LJx3z9plsLymVWXVZoPlHCtaSf0F8HMWcyeS+Ty0/UYbV4TMZXKX5Qz93faNyXTIQ0Wj+zbrfRvA336ofUpIOdYxed6sinFsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4658.namprd15.prod.outlook.com (2603:10b6:806:19d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Wed, 9 Jun
 2021 15:20:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d886:b658:e2eb:a906%5]) with mapi id 15.20.4219.022; Wed, 9 Jun 2021
 15:20:37 +0000
Subject: Re: [PATCH bpf-next] libbpf: simplify the return expression of
 bpf_object__init_maps function
To:     Wang Hai <wanghai38@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210609115651.3392580-1-wanghai38@huawei.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <34bd6047-2b4c-1218-7822-57aea059deb1@fb.com>
Date:   Wed, 9 Jun 2021 08:20:34 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
In-Reply-To: <20210609115651.3392580-1-wanghai38@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:8ea5]
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c8::11dd] (2620:10d:c090:400::5:8ea5) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Wed, 9 Jun 2021 15:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1774deee-17c4-4803-9a9e-08d92b5a2224
X-MS-TrafficTypeDiagnostic: SA1PR15MB4658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB4658B6CE6B143062896D5B6AD3369@SA1PR15MB4658.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQ1SjAEHpY6mQSdOJTEwtwFue0jYl6DQl2dwYbcCEXipI1iyOD0GzETjNUhAamOo11UbBGv9m/W6qn/FLvXnr3naKPKsjHDGTzc+jhJ7ZfJL82vCRdbMIfOi6imPak1orflicsF1+GamPmsqeyOQpQ94E+/5+3MdwCS3v+7lSVTyK1id0LW1XWOY6570bfY8qft0ysW5/ZmhoVZxcMN8U2Zlplt9pq+ZEWIQZLzYzWO+/1HuXXrBZcjLA8O4yeF3PPsO1jSbdP0riCAvIaHodUsYQ7GNC4gD+2bXVtU2Eu2d3xFRGvpP6QKulf8uPUUNyTYdYGIyUBmRFwmREtEw0Hh5WUFaD9T7snx7iK2FmBn6VU2v6a+kdtC6bCgIYIYzcxjg9nMiIStxD99SJCqtwLQip3u4YMYylyn35sAxplyVP6NknHABPYXC8fkzy+8mSf0ze700PcNGy/keiHrjpSwU1CH+lFC1nPJ+/+KrzEPTOrwiZjw4skpmcrLFGcg/9cpiQ03UQU+vKxXUig8Iy6jD3Dzr9eebw8eSFZ+78hd6HzTRHC++pidWmGDauRg0Uhsnsh283jfGn0Mwkib52sByHkemzD24urVUCeG30QsfymTMy9/SyQBlNYiHCbubNNlqgoVseaC+m8ixwM3T3Ktbk5teWjX0WMeCsWR4LwBqXNfRToB9cjb1Wln72/nkAKQOajkLCeEPEfssF9wx7EKuwe83sD3I2JeK0aK/4uE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(86362001)(2906002)(2616005)(6486002)(36756003)(558084003)(52116002)(16526019)(921005)(4326008)(31696002)(478600001)(66556008)(53546011)(66476007)(66946007)(8676002)(8936002)(5660300002)(38100700002)(7416002)(316002)(186003)(31686004)(101420200003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K00zS0Y2UDBGM0VvTTVVcGhzOGxIZTBKVmlrd1VleW5JbkU5R3dpWmNvR3FX?=
 =?utf-8?B?WUZCdEhzRWc3VW5ZL0Y3dWlzSmdiRmJpN0c5ejlFSFNxSU1Wc3JtQW9lS3Vn?=
 =?utf-8?B?Tmt4QnJyeU9wM3U4OEVMODNwdzlQRHVwelpyY3h4YW5VWDY3Z0txaFNmN1pk?=
 =?utf-8?B?dzZYYjFyWGtZR3RGMFJTVjRTZVlsNTYwR1BST1B5NkpIamRlZXNRWkVSRlNv?=
 =?utf-8?B?WEp6dkpsWFdvSmphemtOY2RkeUpCWUhDNXdPRWo0dFZ2QUhwM3FvUVpUdFl4?=
 =?utf-8?B?cWU4b2ZnRHZSY3M4d2IzcHVKWGJJNjh1OFFQTGxVV0tGY0JWNXM2TDI3YVFz?=
 =?utf-8?B?N08wNHExTG9xNUE0TzFHS2c3b2hWWDVVWm5GZFNYam1IU1J6R3J1cys0OXY0?=
 =?utf-8?B?a1g3NFN1dUxiUTUza1Vna21sY0FsWUhrV1BwMVlidDl5RGh6b3Y3S0UrT2E0?=
 =?utf-8?B?ZEs2dWlnTEEvWWQwOEpRU29CYVlicTlMSnE4bVZFRnZLcUplMnVRWFg5WHVu?=
 =?utf-8?B?WUpua2xEM3g2dCtWbmNTMWkyNG9CdVM5c1BNeE9MZjRHRW5BK3IwNTMrRVNF?=
 =?utf-8?B?UVQwMysvRk96dXBpY0oveDJ3VHpVMEdXb2xML3BqcG1LYXdhbUlwdTRjNnBt?=
 =?utf-8?B?dkUvaFkyZHVacFpiTGo4eDFZVnNQeWxnejl4eWNmenAvcklIV0d2QWl1eWpN?=
 =?utf-8?B?M1ZLaktFeHdyOHdjZ1hhOTBNUTB6UmpMdWs0SHNrNGhuR0N2dGVSTzdLc2hT?=
 =?utf-8?B?QXorL2podGY1NTNaU0tLeFNVTExqWU52R21OdUNldVVXaHV4a0trN2NKZko0?=
 =?utf-8?B?VTZ5eTdETFl4M3dqYmZRTTNqekZlMUlncmM0WjJGVlEzV2RsUXlTUlQ0dDBH?=
 =?utf-8?B?RjF5aFdzNFhpa2Q3OEUxY3FxWHJ6aHJoSGdjcGRpSC92VWU2VHNPUE1ncWd1?=
 =?utf-8?B?WkhEUFFmVmJiaStmT092bWZrWXJCZWY5aEpJQXQ4SnJEdkg4cU9WTkhwczY2?=
 =?utf-8?B?dTZTUkNsQWtObUMzS0hoc1kvWng4T2RUWWZUbWhvTm5jdVhDZXZrN2dXR2NR?=
 =?utf-8?B?MGJEeWJCeFF5aGpvTXVIaDZJcGt2OFoxWHdCY0F3RDFURGJuKzVFWVhCS0Fj?=
 =?utf-8?B?a3RSSWpvNE5ycWJYbzNyY1N5OGZwRWpTWjBaNVNVQTFjdEVDN3hUOERTQzdT?=
 =?utf-8?B?ZWc5NE16eGJHYWU4WnBZQ3NKM1dWV3NlZVdtSUVsZXRwUUJKTFJWZ3FYdlA2?=
 =?utf-8?B?TEtSV1g5TytlRzVuVHpRZVJZZFZYTzBvbVhpcnhoc3ZHRzlxN2lHczhzOTJX?=
 =?utf-8?B?cWh5V0ZTU3pVMUxNbHA2b2E4TnlEdlEyRi9wQ1V2QzlpcWV3S3Y2bFZUaWsr?=
 =?utf-8?B?MDA1ZUdlTVpzWG9BTURvYkk3WjBvRis3bUhLMDNBZTdNdDRvcmd5TVVKYWg1?=
 =?utf-8?B?bHl0bHo1Qmd2QVV1SzFqK2ZhTEowazJERTVvYXJvd0FYalZ6L216ZlRZekJP?=
 =?utf-8?B?cmpIcnBTMXRmdlo0cmNteGlwb1ViV2MxSmRuVWs3MDNTc3ZjN21mdnJBMFhk?=
 =?utf-8?B?WlFra2tlM0dLUW0vMkgvdnpGRW14azVMWTh0OFRYNEE5d0NXd1RlSlRJbXJr?=
 =?utf-8?B?NVI0MVdUdGRLZ0wzeFI2dlZEZFdKMlJFSlEyVUI4cVdhNktnRmNCU211WS8x?=
 =?utf-8?B?NE1PTFRIT1hCaHJZV00wZHBmOVJBeVFkNnZ6YWJyZVUvTXFtQ09nSFNQL2Uy?=
 =?utf-8?B?QU5rcThWUXBUK0ZmQkVaWXJjcUg3c3dMRTNYUFRvVHkvL1lKNWIvTXB2VDVx?=
 =?utf-8?B?SGx1cTFibnpDZ3U4dk1yZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1774deee-17c4-4803-9a9e-08d92b5a2224
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 15:20:37.1959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYs3FHwdxF8kn/VNwqFfvFXpzpHhMr0LMpmliMvixdRM7mKrBE41u11g7UK+CsZv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4658
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: jmV1aS0WY_Q062WpDv9JxI7sAo7Iol16
X-Proofpoint-GUID: jmV1aS0WY_Q062WpDv9JxI7sAo7Iol16
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-09_04:2021-06-04,2021-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 mlxscore=0 clxscore=1011
 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090074
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 4:56 AM, Wang Hai wrote:
> There is no need for special treatment of the 'ret == 0' case.
> This patch simplifies the return expression.
> 
> Signed-off-by: Wang Hai <wanghai38@huawei.com>

Acked-by: Yonghong Song <yhs@fb.com>
