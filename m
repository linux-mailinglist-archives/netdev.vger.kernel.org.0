Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6B2FB245
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbhASHA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 02:00:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12934 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729385AbhASG4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 01:56:11 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10J6aGwN008883;
        Mon, 18 Jan 2021 22:54:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aXJhClDqk8aEf0D1HNVb+ViAGpPTtMMkemNa9BY9zDA=;
 b=SoTeiq9psRbyL8ZGSdgUvDLWBrMKdHdJMgGJvBH/OLiwbmY2xAhf85Ab8e3UjLJqqtec
 b1hz1E706pCrd+qNLxX+LTnWRnZnEXkZlHyBDSzu7uCqpBvK5u5xsCEc+M6zHimxXzTv
 XaEbwrAIlx6Ax2lskcnM4pxKdO7hqWVxw/Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 364gpp7met-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 18 Jan 2021 22:54:57 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 18 Jan 2021 22:54:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/CDfIvodKECVPs1jKi3MPJIxML/MD/6KRzJegDI/NBGIcorvtyb4t+RR1y8acOb9NeuMIAeknmdrwosdaHU7UPT5+vq48Hw9d27eSHnBOH2UWx3j3HAuqSxQmM1h/Ciy0utu+3cDOtKQEdlZmrvCKFnaqTU5bU0VXWfXJxJiz9yAnBj2OdwBFNs4tBSbGGj6erNmiX6lDxeL0yeMVj444HfDjvxlDYkpkKiQ4blCqbcQnfe+P3P1WpzOWMGtJBSPhztl46VKV2Xd+011K0pPkU4Kh+HIJYpIX4+pWo0nApTwY11armUuC7yPK7XoqSX6QSgmEeldU63fcszz9JaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KznYQYj1/mCPjk9k1LE94TUlDLMve8TEJ7tdxmV6lwY=;
 b=P537ERhnhUo+h4tSqZmvbm8rHbK64B2UZP4aMqkPifFsjPYjRooCBUsK/XPxB3LjR5+H9nPRYTGqt6NgfYe16V0yKK7utNAHObg8khCAjxCp0FW5/oHIWJBaEDkdKMZPDQJef7WL3mzQoG5Q7Nir1TgZ5gX8CBsH3NfFPsdlPw7v5AkmBtcRAKb2uE/jlnDTOGgsbYzzIV7b5033jdxdWL96KOyFfjKaLz71vXMVsQrOXFevgA6OTMrnpmAWhd9bji7w8pAGrzuLz61OOnFocMJE4xJfan76RzzO3r+BH3Xlb9ScBFfMvztf+ZA7k0Y+j9/p07VWN0V7nSqYi/kN8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KznYQYj1/mCPjk9k1LE94TUlDLMve8TEJ7tdxmV6lwY=;
 b=c/sY99/B+bKj7q3hNEa6HTYGWqGaa1m02niwSKoj4M8LND4hTQ2E9Z2fwxUOdJBHU+GK5S8AHOKfMzOxG00cmvUjzlg0bmLF8jFD5PFkAiaBGauRz0UMFfNVqp1x9bpoeeoSFDmOjgCMRZ4MNsXzrkAzzoLJTO1bM/umiU8wdE4=
Authentication-Results: loongson.cn; dkim=none (message not signed)
 header.d=none;loongson.cn; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 19 Jan
 2021 06:54:55 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 06:54:55 +0000
Subject: Re: [PATCH bpf] samples/bpf: Update README.rst and Makefile for
 manually compiling LLVM and clang
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>, Xuefeng Li <lixuefeng@loongson.cn>
References: <1611028385-32702-1-git-send-email-yangtiezhu@loongson.cn>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7eb76915-43cb-d096-5efb-0c39c0950419@fb.com>
Date:   Mon, 18 Jan 2021 22:54:50 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
In-Reply-To: <1611028385-32702-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Originating-IP: [2620:10d:c090:400::5:e789]
X-ClientProxiedBy: MW4PR04CA0254.namprd04.prod.outlook.com
 (2603:10b6:303:88::19) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::126d] (2620:10d:c090:400::5:e789) by MW4PR04CA0254.namprd04.prod.outlook.com (2603:10b6:303:88::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Tue, 19 Jan 2021 06:54:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: daf15cb3-5b17-4626-d23c-08d8bc4720d7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2696:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2696DFE141D26C66EDBF768CD3A30@BYAPR15MB2696.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TTlhgCQMfbaTurFmT/cG2Vsz4lCmdidc2WK6+FPm60+kGEqLbTwD1nT1zNo3xM15ayKNIKlEOYgzhud+Kvv60iDD0mSAqBpR2K3C8GHFlBSW6hidfi9cuaonbrX7qkx8demx9BWI3WEy6LK7yCeaHqMIvS9YLZ1ONz5q3jYwKKCvzPkgN5iHtDeKP+iEikwz0QI23t3L+pKKVMNsdvEvWwbBxvgnwLIieNKBWN/H0aPSMvvkOHjTny8uPmQI5nkuCcB57EZLm393tVoFL3BIfztFsChUa17XZKmatt/rq8eVkVyYruRxfMIDs3Kl/+D3093qAs/WePHD2Avm7j1akcugVGMOpLwEOcl2djPodfQDd4mtiIayq0yiF93kx3LJznbKF6xxgzAvjclRBBb6YVktJ89wAvausKQ2nhWJWrYFTvk3i/6aPHPtK6hVywW349N+4k1w+/eVZ2hTFOVW2TAVgDQ/JKh9TsGAS8IPd7itdO91ZN4jaRBEa3oNFxSPv9851Mj9IB5UVa/6ne10gbCemMcJd1hn7FI1dDtmjbQMxhjMZ64mJamFHGK4y/YZKPeVVJj+VVD1Ze95XU+5VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(346002)(396003)(921005)(7416002)(31696002)(2906002)(316002)(8676002)(66946007)(2616005)(5660300002)(186003)(966005)(86362001)(83380400001)(110136005)(31686004)(53546011)(6486002)(52116002)(16526019)(36756003)(478600001)(15650500001)(66476007)(4326008)(8936002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MERiRVJLTnc5MHVvR3FpYVk2V1hrZ0Y4ejQzaktlU1N1cnU1ckszRllhTmV4?=
 =?utf-8?B?aTZjVWsxZUpSN1VkelNxczh4THUyd3FhM1R0TnhoMGN4NFR1ZkRjcEtEK21Z?=
 =?utf-8?B?Ym9XcnNpUERPWFR6bGdIZ0h0ZDJwYnBPRkE0RC9qZGlGSjNEWnJTOXoxcWZX?=
 =?utf-8?B?SHdyUTBJZEQ5eHRtT1EyVUQ3TGhMRDRVOGtmTlJzWUxEYXNVaE5tcnp4czRZ?=
 =?utf-8?B?UzlySkEzSGJhdTJOY0pnZ0VLNlJrd1BGVjBDbTE2STVLa3owT1dyd2pFSzF5?=
 =?utf-8?B?N3lkMzVDaFEwR04xSkZZbytBQ1Rnbk52emZDTmZOMTlWc2VsWUpsRnJVaU13?=
 =?utf-8?B?K3lMZ3pmaVJKZUxjK3ZZK05waEJyL1hVNTl0SEYzeXVUQUtIVndqZmh6UUM5?=
 =?utf-8?B?RHV2QnpMK2NRb0tKTlZiTDZ5bUhJNGlnQXpXVFF2dEtsMzc5RTdvUXVVNzN3?=
 =?utf-8?B?bWwyOEM0R09ud1pMSDhJU2twbnYvYzQ2MnJEcGxaa1hhWXpudFhvd2dDTVJ3?=
 =?utf-8?B?ZUdIWlYwa2N3bTJjRWRFbndHaXNyZm51R04reG1GeXFQK1dnTWFxMXFiWHhQ?=
 =?utf-8?B?RmY0OWI0OFp4SXpVaFA4L1R4eHRPUE5IQkw2NnNBVUV1cnRsemErZTZmWS9o?=
 =?utf-8?B?K09vTGNTV2NvQXQwZnB3WVkwTko5aXZYU0ZRWHZSNkFnK05vSnNSVHIrQVlU?=
 =?utf-8?B?ZmpRbkt6RjV1bDMwa3RzdFNMUnNuQ3JUZHlJV3pJVDZTd3JzVmNxSHphWkdE?=
 =?utf-8?B?NUY4K21UUlJYM2hRY1NGOWRPQzM4NWVqb3BaS21pZHZ0cmxqT1ZHT1dCTG9W?=
 =?utf-8?B?Q1JmdFFiUzgzUitTaHduVEJsRGxwVkFXRFVoRFhQdnVhLzdZY1FKSDc1Zncx?=
 =?utf-8?B?bFF2TjBsQXhISVBTNXNFY2hPQmVEdUNqMkFTRWVUM2hKMHdWN3BaTUdmRkZm?=
 =?utf-8?B?Rmt0UWZabmZBcGdRWkQ0djNEaTgxQkE3d0VwUE9IbXBKcU1ERjdzajNWamZT?=
 =?utf-8?B?NkNiQ1luOUZMWnMrem5XQ1FZNFlzaW1NYjBPYTBLUlZOOHIwdEFTeEZhVjMz?=
 =?utf-8?B?cDVDYWdTWHFmRHpndTdCWlh2UWxUeUFBL1Frc2ZGRVZSQnlveXNiNjhCOEd3?=
 =?utf-8?B?NVB3MW5tSG9mL2JBem9jNHA4dDlPUFlLK3h0dVIxQkREU1crOW9SNFp1Z2N2?=
 =?utf-8?B?bjAyZTBKWkpkTXdBZjl0UmpzanpZVGJ0MStXeVlzbkxTZTFxRHZhL01rTVpH?=
 =?utf-8?B?c29aWkEvVjFReFZmTXllNmc0WEVRa2pOMDV0cTZVVzR5RnNFcnArc2hxVXhY?=
 =?utf-8?B?NkRKL0ZpQUYzR3MvS05wclhvRG13NkZ1Q1hIOSsyMWdzdGRzRk93amNZR0tI?=
 =?utf-8?B?Vkx5S2NYSzNVZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: daf15cb3-5b17-4626-d23c-08d8bc4720d7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2021 06:54:55.6018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YUzug5AobWsgAzod9cdVjaSixp+d4ZYCtBfj2K21H+q0XZzEPAioABbnPYlPj2vf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_01:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 phishscore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/21 7:53 PM, Tiezhu Yang wrote:
> In the current samples/bpf/README.rst, the url of llvm and clang git
> may be out of date, they are unable to access:

Let us just rephrase the above more clearly, something like below.

The current clang/llvm build procedure in samples/bpf/README.rst is
out of date. See below that the links are not accessible any more.

> 
> $ git clone http://llvm.org/git/llvm.git
> Cloning into 'llvm'...
> fatal: unable to access 'http://llvm.org/git/llvm.git/ ': Maximum (20) redirects followed
> $ git clone --depth 1 http://llvm.org/git/clang.git
> Cloning into 'clang'...
> fatal: unable to access 'http://llvm.org/git/clang.git/ ': Maximum (20) redirects followed
>

The llvm community has adopted new ways to build the compiler.
[followed by your descriptions below]

> There are different ways to build llvm/clang, I find the Clang Getting
> Started page [1] has one way, as Yonghong said, it is better to just
> copy the build procedure in Documentation/bpf/bpf_devel_QA.rst to keep
> consistent.
> 
> I verified the procedure and it is proved to be feasible, so we should
> update README.rst to reflect the reality. At the same time, update the
> related comment in Makefile.
> 
> [1] https://clang.llvm.org/get_started.html
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Ack with minor nits in the above. Also, this is a documentation update.
I think it is okay to target the patch to bpf-next instead of bpf.

Acked-by: Yonghong Song <yhs@fb.com>
