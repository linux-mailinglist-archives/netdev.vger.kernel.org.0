Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC7347E637
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 17:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349071AbhLWQN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 11:13:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50648 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244576AbhLWQN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 11:13:56 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BN7TIvo028989;
        Thu, 23 Dec 2021 08:13:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VH6alLOCz3QOk5a6rjSvgU5Kh1n8b0JZ7qMsjR4PlKQ=;
 b=BmD7JKEKwjkw91HVo9pJ9tkn1JCAVnEYw2ma+guPL/vgor9JmxuSHdYEJHLNLLJ83nn9
 uO62stE8YMkv+uKpppzZ/CSOqPdToZO6E2tvMbn6q63qMdvfH3p8y/S5QVIq0IquRAg5
 as7/SGU+VarN6ye8DQSkYeEgDY4XB35mTeg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d4dewd7e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 08:13:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 08:13:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dk83/BWiT0w+icPyjkOXqzvCZ3LsAOzuJ2gc0swEYH0xnwQqF/nemtKAkUIxPgWsEiaj0VOwFpqTREpEfnSz1Q/DWWGKzwkYcV0sxySr2CSJDKqjk0dgeBgNE/XUK0YCtuBnFNNb0SSZJb4JlIQ3AJttUiI/mujn+0F+zyrDoJn/nJaOJUdvtmYDcR7Ueao/11BXzZjPd7JKeAzMdempYEUrLdz0TsxgLB/5YEMbVo6FUbiwR76NDNldsXHjJwzbEIfursli9zdsqwFv5EzPUwlJrCwe6bw2jIbZxCqIOCEs1fzdbYYqu+cwoDjydz3GDiRRA0Xgsd2n9A383uMbSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VH6alLOCz3QOk5a6rjSvgU5Kh1n8b0JZ7qMsjR4PlKQ=;
 b=FjjcZ1lO8WJuvC1NfWZ5qydF5pxrMFDH6QObx2BcqItvfBe++gmFX1+LKTgK7R3yxzSsC8lqeMFKKU9gl/SozPlFrFEEDbfnHte0iQez6soPhgxbfPr+7P8SO64tJR+NxmDWt2RH0zVLS19YNRajc33xk5cd+hiebq54CUp4YQw4v/cDUWMIPUCV+NBwRfp1Xck5g5OCqxn/x5H1OGyMlvcP0Gy8LlQ7aFe5fqhlg38sNu62VFLg0aYf4mMeeznvAxzchk1GobexJS2ApyCAMGZRHEDucpeU6gsanfbJDqYidKQCLLTcEikOq52rMd5hRF1JhBPA+dTcHUkCbBpufA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SN7PR15MB4159.namprd15.prod.outlook.com (2603:10b6:806:f6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 16:13:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::b4ef:3f1:c561:fc26%5]) with mapi id 15.20.4801.024; Thu, 23 Dec 2021
 16:13:37 +0000
Message-ID: <48c1e6bf-ee4b-bf49-ec85-2cec98ab9dcb@fb.com>
Date:   Thu, 23 Dec 2021 08:13:01 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH bpf-next 1/2] libbpf: Do not use btf_dump__new macro for
 c++ objects
Content-Language: en-US
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20211223131736.483956-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20211223131736.483956-1-jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: MWHPR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:300:ad::18) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e84b6f-b3b6-4941-2857-08d9c62f2d1d
X-MS-TrafficTypeDiagnostic: SN7PR15MB4159:EE_
X-Microsoft-Antispam-PRVS: <SN7PR15MB4159DC4ADAEE1B08C88A7C16D37E9@SN7PR15MB4159.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ye2UbmMfWC+5Ug2WznZRNCKAgZ8t6+f3qxMtq5PA/y/ENno9fUg3PDzmBflV8onB8XFE7m0Z04anfLVkWzSWVXAC7QkNoLGuR3cxhHV7jXy+/olXoc7nUJqgdjWMjcty4AVPaHcpNPdJG0HW9sKHT7OzFHGD4BcGJwMseffJRYT7Tglzl7LufV8tWDj7xO6c2z1cdF+6kiZ7ol0de8kaep5s8K7CP4PS42/ptQ35nvPTrAIMpP1uR+vPxTh+SH2uO3uQhQIHtiqGgEIRwDjBfdhCmoY08IRuEc7AYoP7mJE/jidCYMKhMga6b3gLQX73Q6SlPpTcUKirp1RyviQ3SsIPy9hyg10wFu7yvTNXlJIaZviv6LGz5PUw5JvRDj5vsss9Qpoh/O1E6Egi/9bcSN9PRQEh+ZVq8RMZQRx7C9cEIQbFqtjiKl4WnsagyB/BY/LVNLHWOMZGada50Qjk++fmcAV4kEf0VrD/qCfzueDE+EXvPJR0o7KcVINxn4e0vIMB3poS0KLZFq8feWrqKuxcEDROIyUKeODauegH4DzSDJ5j+oUNCNqokIs+FLSSwCcD71UERjKdqmTs5/2IYjkRlNg4cFZr8+nCSPj41J6/rt4s1WEPwpsfuiGxaOe0sVo/Q54WYm4y1V+eUwvzW1vkoodEjawFfxTcG3JhfU09d/NXoKa3NRAre/LI2Lehfkp7QpVnZMHK3ETSl3dL8LX9CpuVBWvfvLmzoHzTtfYQEuIZOh32T6O7sDlGmXg+MMexRIVgBoOdEvKbdWTO/NjMaAXrz44NTOjaZMOoflR57H9sgLysudqoPm5uRTMfIVGQxRFSpIgA+iN58rhztQyJ8A+PnzDgxY+Hw1R+8T4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(31696002)(54906003)(316002)(110136005)(66946007)(6506007)(2906002)(66556008)(4744005)(4326008)(86362001)(6666004)(52116002)(966005)(36756003)(31686004)(6512007)(5660300002)(8676002)(2616005)(508600001)(186003)(53546011)(66476007)(8936002)(6486002)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDRaRGp0M2pBc1EwY1NQRFZVcXJkTjl0UTVIOUlVcHkzVXdoNU9mb2w3SVgr?=
 =?utf-8?B?b1RrVVh0Z0FyVmlDUkVPNko1UXd2TUVZcHpNS0dyRld1WjluWDhVTzEzL09M?=
 =?utf-8?B?MEsrbzRpSVVNSG9OS0lpUWc4ZW1QUHNVbnB5THFDbTVHdmh5Qndld0JhU0lT?=
 =?utf-8?B?TjVsYjhMaTM4eTV6QXc2THV5bHZHRGZrYXB4MEdMKzFWQ0I5WkEveXJudUVh?=
 =?utf-8?B?cWJGSXk0WUhLOWJnSG5xbVlHM1I5RGV0M3JKZ1U3aldOT0QvV2QyOVlTQU1Z?=
 =?utf-8?B?dFVZR1VEd2c5YmE1NWxmd1oxUE1lOWQwbmNYV1YzTUVCTDA1ZVg0bno3ZDZv?=
 =?utf-8?B?alJ2cWFOZUFETk5Yb2RrV09xWW82WTJwK0pJTm9iZkxydXhndzJ3UU9jRUZG?=
 =?utf-8?B?Tm1PVnpRbjBVZ2E0NlVTMURiQkV6Z1pWcEkwTE4wTXVhV3BSOTROb29LYlVj?=
 =?utf-8?B?bkdDZzRmMCtSbytIOXk1bU9BVUN4TlRrazJ4Wi9QVWMyc1VTMHozZE9UYUlx?=
 =?utf-8?B?eFh6dUZFaWJaRzdMZkt3K0M4YXlEN09IbkhhK0t3M3pKR2pva2xkUnJFZGVM?=
 =?utf-8?B?MXIwVVIrVzVPMlJvVEtMbnB4ckg2TzNPU01veHd2TVUwUEdmd2dGTkNRcUNP?=
 =?utf-8?B?cXhvY01xM0FrQTFJQXB0MmtTQVN6Z0xpR01zdGdMT0Z1YmxtVzc3czREVG5p?=
 =?utf-8?B?RzhyV2ZtcENjem91RVJCY0p6SFRkbGtaYmFEZU1GaXl3QWZMemRyc1hQanA1?=
 =?utf-8?B?dzRGYzJvY0FnSVE2eGdabG9BcmFKYmFJZUo0VmNTNE15V2R4czI5VHJKakRD?=
 =?utf-8?B?V3JId3Q3eHEvVHBRNlNndkZlYXlhOWdlS1oyU2tTM0ZFN3l3V0QyNDQramRl?=
 =?utf-8?B?K1cwLzZOU3I2ZCtickkvdFZlQTduUlZmNjU0WE9xTmY5eVlVWW96SmFodlpU?=
 =?utf-8?B?MDFTMzNyMkE2ckU1cHJzWlo0NnIrL0JlZ1doL0dtWVV5azc0SVpGc1o5TEM4?=
 =?utf-8?B?QVRLZ050SXhBanZhV3V2cStXYUtFSi80Q2QxbFd1eWtYbWxPZGFYMmF2Q01m?=
 =?utf-8?B?clNtRTBsbGo5QzdPamdjaEJDcUlOa3o2NFpjYkF3cmhPOHd2UWlxc1JscXFj?=
 =?utf-8?B?Z0xWYTUrblFYQUNVVUFNMW9jV3BQMFBYV3dKcnc5c2gzUXdFM3pGUG5wUDhn?=
 =?utf-8?B?Y24yR2w3WE1qZm92cjdVZFJLK2NjbUt5em9KQ2NZbmlQdVdYM3VhSTVVc0h0?=
 =?utf-8?B?Ymx4TjZhYkc4UFc3b1oySW9jdGpLUTFDQnNldWNpU0JNV0Mzc1lZcU5ITVBY?=
 =?utf-8?B?Y2RDZXhRN0JGd29yVHNTMmF6TVhib2R1WmRUSDc0YzN6R0IvTGJwZjJ0Rjcv?=
 =?utf-8?B?b1oyc0NmeXlzb3pOdUFGaVBGVk56TnVRYm9DS3YwZkFLNWpReHZqczRDVTJj?=
 =?utf-8?B?bzJyRlNoT082dmpKY1dsZyt1eDlGY3FMSDJ3NEk2NXhyWnFCamx2OGtRVkRL?=
 =?utf-8?B?QllDUGdVL2RxL296cjlaeFVsZ3V5VGZlVTlGT2VtNWdCQWIyOHlWcG1uRjUv?=
 =?utf-8?B?SXQvZ1VseUwvck1VelFnNEJuNmVCQWkxejRMU25ISUVkdFNJdU9wWTNBZnRi?=
 =?utf-8?B?OXZmc0pvQ2dZZmJTOTNsUUFIVW9WMEN4MjlmQm95cHNxSUtTRFdWU1VCQUE5?=
 =?utf-8?B?TzNMb0lvUWg3WmpxVWNRMTdGWENrM2oyc0ZYeUpRVm1sVnNzRnYxUVVjc0dQ?=
 =?utf-8?B?b0QwNlNrREFhODRMS3h3c1ExWTdoMEk5cCswWWUxekswa3RycDM3RVQyYXJt?=
 =?utf-8?B?TVFiblVkZ2xlNHR1MU1GK1piQVpCRWMxN0hSOHJsbmZMNmQyS2o2ckxDalll?=
 =?utf-8?B?QkJVdnNPd2JxdGMzV0pHNWRCMVhBZWxDNkUvOFN2ZkNIUlhXWGFWbmhXdnZG?=
 =?utf-8?B?QVhXc3Y2TE1hMUxQYk43RWwrRkdqZzRTanl5dlpkZ0craVBuNmNRZWxnaVNN?=
 =?utf-8?B?YUZPeDBMQ2laWHdVQlRjaFhNVDNSa21xbDlyZGlxL05ReDRPakRBeEZDVXlZ?=
 =?utf-8?B?Vm1jWFROTlFDK3h4RnB1cWtjdUtWY1dWaElGTXZLeUZ1SWZodkpJSlBrZGZL?=
 =?utf-8?Q?OIp/lqXIZptrqvJ46QjgSQTci?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e84b6f-b3b6-4941-2857-08d9c62f2d1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 16:13:37.4158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HPiwK6hbhhqcYQaT+fBGUa/IwXDmjAsLLiW+U4cd6plaKZw6xR6BCNpNqP++aFEI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR15MB4159
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 7vwCB_K1v2hAVFJn9NeE42sTGfzv0TRH
X-Proofpoint-GUID: 7vwCB_K1v2hAVFJn9NeE42sTGfzv0TRH
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-23_04,2021-12-22_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 phishscore=0 impostorscore=0 mlxlogscore=401
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230087
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/21 5:17 AM, Jiri Olsa wrote:
> As reported in here [0], C++ compilers don't support __builtin_types_compatible_p(),
> so at least don't screw up compilation for them and let C++ users
> pick btf_dump__new vs btf_dump__new_deprecated explicitly.
> 
> [0] https://github.com/libbpf/libbpf/issues/283#issuecomment-986100727
> Fixes: 6084f5dc928f ("libbpf: Ensure btf_dump__new() and btf_dump_opts are future-proof")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
