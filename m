Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F4023123C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 21:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732597AbgG1TNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 15:13:06 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54272 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728561AbgG1TNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 15:13:05 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SJCNnm014113;
        Tue, 28 Jul 2020 12:12:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=0wWeh7pIvQO+ky2yX5Mczw6ymU7Zw0Vo06E9mbhiBfA=;
 b=kTOeJaysCWHdBVAs7YBQS3rK5/pa4jnlnry5WxPvKRufT0iPx7bA3oGO6XY+fppwxCFN
 FIi4HOHGSPjglpf6tq4KnK1UN8HkWhbEF2kvYXqqveTfASFrxllK2F4jVTpso3C1pj+W
 XWfoLo1VEtjfL/xbvG/AVNfIlouRzLvPfNk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4edb6u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 12:12:50 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 12:12:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfUF9cOi3/AmYROlgJODGf3AFZaDtp4DM9knzMpuw8Tb4OX20GzI5XYL0kdT51q3q6/L4vnNJUm19ymJVnFX1cp4KTrgJOJa66JS0DQ4hes0iRwUD/+1nvAYfE5RRuXehvRhKBF6n9TlN38SvHcFAZ7fAusYabHrPWcSW7tNW2RGQyEj9lzvXZlMrLw2pL5ZdPhGlobau8khqSCYwUzB1wJplnOBT6C5TRJEdsxJWCWpDoHYQ2Fgpr7nOSkY2ZzamUaSHSKpHYM5lxayuowDTqeCZRsaJ3BCvP0IHRmqVnnFwSAb+x9WVuXn1JAbJi0cXx+RlLhoDpJQQkfmtJ3QAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wWeh7pIvQO+ky2yX5Mczw6ymU7Zw0Vo06E9mbhiBfA=;
 b=S0ln9tLk/jdA7YhIDHKqZ0stp9D0RNEjbX3aBW/XR4bFcO8aQG75pDMKOQkIn/RjsqbnHbsJGWSy/sSDKhXHnqj1P5e1HGwRhByxCAyZFwYDAUKbdIeL2FTXuntGJ2Ee5ipmJz8VEo+rgy0JW4v6wGmrnPwU+0kPbvNLt8ZUakandq4B/Pfc4GEzci1hl4xQx4kDXbh5+aHmvlDpZ4IfvEpB5H58+UswqYoCOWs1fJlHFx3hZwmRqwtOrlBjazGkv5Ik7bhhFLiNUDHACMJUZgGAzHNlgFslGortnAOXZiGa0OSew4hrN6Ym82WwNPnOJIU20YUBB+VLot2NVsIb/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0wWeh7pIvQO+ky2yX5Mczw6ymU7Zw0Vo06E9mbhiBfA=;
 b=agac0icJhTbOUzTwgzmX21q+6hli+5A+ExXqFppeN/QCBMsJ7HOZlZ2gQ1cySrtzyX631y+UCma0Ee3DtifwIT/DpQE3RciPa3TlQQfb3xVMYc9LmGg/PNvkBUZkwKGyZJV/NE1UXrOzPpT/TmS1E3/RCV9m1owmVEnILt9687o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3207.namprd15.prod.outlook.com (2603:10b6:a03:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 19:12:48 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::56b:2925:8762:2d80%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 19:12:48 +0000
Subject: Re: [PATCH][next] bpf: fix swapped arguments in calls to
 check_buffer_access
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Colin King <colin.king@canonical.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200727175411.155179-1-colin.king@canonical.com>
 <c9ea156a-20fa-5415-0d35-0521e8740ddc@fb.com>
 <882cd37d-0af2-3412-6bd7-73aa466df23c@iogearbox.net>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7a0b563a-9853-9d6f-9d3a-0595e701c1b0@fb.com>
Date:   Tue, 28 Jul 2020 12:12:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
In-Reply-To: <882cd37d-0af2-3412-6bd7-73aa466df23c@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0036.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::49) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1215] (2620:10d:c090:400::5:112f) by BYAPR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:c0::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.10 via Frontend Transport; Tue, 28 Jul 2020 19:12:48 +0000
X-Originating-IP: [2620:10d:c090:400::5:112f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e479f3d-678e-4aae-0169-08d8332a374b
X-MS-TrafficTypeDiagnostic: BYAPR15MB3207:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB32078FCFB78008AA05C3D9BFD3730@BYAPR15MB3207.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:175;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2KFETicV3fDPILiKbdr3b8QSIdilHCCpa7qib1DTW69R0OWJkyiJSWDOtUcEY2Ph9HQJfk1Dg4U+HlQookP3Oii7FJwbdKshFlmjwFE1GC7/OLbn13UyIfr1kj5No2os9X/IaU/Zg1Gau7epPFgFFYXwNDB2R2lwruDyHnarSecD7IAwxJw4P+LgL6sR6s+Z5z5z5qaDXTnIjGw1GnFxyhaHsHns25T4PkxHBJ2+RragoGEAkHyT8Kp/zzXZZJd4f8q89H4vuHZsYNOyrOKSyytsGwH0dF0L6zQIwMVZGKy7laIxWazNvuybCf/LK/73HIUU/jErseZlWP5Y1fIIPEXQJl6h0t2vpl7mLbgu8G8kqbVVDMf6JOTLxrQR0amv/TZmvemA3tmJxaTyF61tlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(8936002)(53546011)(316002)(478600001)(2906002)(8676002)(52116002)(6486002)(36756003)(31696002)(4326008)(83380400001)(110136005)(31686004)(86362001)(5660300002)(2616005)(66556008)(66476007)(66946007)(16526019)(186003)(921003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jPfVfqg41pxnfqwCyZNSdkaTtz8VBcQvE6Sdzy7siW3chZI0y3dCX2ELwfsZJ5xRbWCipuVIVJLUfRnfikF74W9Rn8V2VFBqu6ok00h2Yk0UgOaaE94NzsInoUr2JsPY0o0xgRiqVXr1rOa6+QNAJsX/hn/GioNhquZigxxhGTro7KotvdhGifGvdy6NvpUH/4N/Y4di9Aans9PV8oKEKwb/sTqjuh+vlcR4jxLXEgC1qg1RFOWN4j8YtmA4gHOCaDFPN+9IzKFRVsynGnXji++HUcLZgAHSnKztrqnTR+lf+GewlGUqvNw9ymMaoiZaX0LkuQSvlgVZqW6jTkD7XoBjqWFgM5kXegpU1cMEJ5Tbeepl96WF7U0SielBkt/CxwBRvc09DpBn4ET0cnK/Mf9YGJlzlwwD4KS00oMlNXude/FNi+QyrUjmFivenDCim70An5UrluUFQD1U41GKh/nja0B8LHQbqnvUgTyP7wm3b89Ey83lH3mDQ2c6syS8zmy1RbBTiB5dUR2dq7FHpA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e479f3d-678e-4aae-0169-08d8332a374b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 19:12:48.4479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Aob97dLsPqDlzGZQbL3Ngpr2XtOUdMg1zWkoTQSvOuWI3EM3kz0XpTmRD+ykHJAg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_16:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0 clxscore=1015
 suspectscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/20 3:43 AM, Daniel Borkmann wrote:
> On 7/27/20 11:39 PM, Yonghong Song wrote:
>> On 7/27/20 10:54 AM, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> There are a couple of arguments of the boolean flag zero_size_allowed
>>> and the char pointer buf_info when calling to function 
>>> check_buffer_access
>>> that are swapped by mistake. Fix these by swapping them to correct
>>> the argument ordering.
>>>
>>> Addresses-Coverity: ("Array compared to 0")
>>> Fixes: afbf21dce668 ("bpf: Support readonly/readwrite buffers in 
>>> verifier")
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>
>> Thanks for the fix!
>> Acked-by: Yonghong Song <yhs@fb.com>
> 
> Sigh, thanks for the fix Colin, applied! Yonghong, could you follow-up with
> BPF selftest test cases that exercise these paths? Thx

This will be triggered with a verifier rejection path, e.g., negative 
offset from the base. I will send a follow-up patch soon.

BTW, using llvm to build the kernel (without this change), the compiler
actually issues a warning:

-bash-4.4$ make -j100 LLVM=1 && make LLVM=1 vmlinux
   GEN     Makefile
...
   CC      kernel/bpf/verifier.o
/data/users/yhs/work/net-next/kernel/bpf/verifier.c:3481:18: warning: 
expression which evaluates to zero treate$
  as a null pointer constant of type 'const char *' 
[-Wnon-literal-null-conversion]
                                           "rdonly", false,
                                                     ^~~~~
/data/users/yhs/work/net-next/kernel/bpf/verifier.c:3487:16: warning: 
expression which evaluates to zero treate$
  as a null pointer constant of type 'const char *' 
[-Wnon-literal-null-conversion]
                                           "rdwr", false,
                                                   ^~~~~
2 warnings generated.
   AR      kernel/bpf/built-in.a

Looks like I need to use LLVM compiler more often...

