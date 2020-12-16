Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 751592DC4E9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 18:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgLPRBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 12:01:14 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726745AbgLPRBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 12:01:13 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BGGnDK5010077;
        Wed, 16 Dec 2020 09:00:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=BQN71zfq//H7X3tr2fzPDBgEUtELfWj9/V6swgtbz6w=;
 b=lTB/d9ksfaM3kXKBxvOl2MBbcQruIDD3SixKobXPsnGCZth8kFfkhVZUCuZeAqnzcx8V
 1SQ1WNwAxhJYEZ1zrMwysulf7ntxZPgT0sCqSr6zA1dP1ztODJqycvtDrp56mRFql29o
 E8+46mWVPaxDssrxZ5YkTDlurqcYikMSpaM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35f54ncjym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 16 Dec 2020 09:00:18 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Dec 2020 09:00:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LX6FkP9Mb1eOVQ92Cg3HPEU+DBlgOpNTQune2b9FsL/b5bL8hpR551CCJp70LhnsAAABA1AuJYgntlLee56BJ6YGLsnM5HR0PvIxCD3KWGpFAx9Qn8wARVLsctw3yXZYI4Q7nHrZC+9ucGBXrq+yrDPBtpKd3Woa1GTdMatOmYV1HDQhcKXUWKiBjLxhJLqNi4yD+EPnxXFEBUgya7355tEaVlfFVUnUx5kbONPHO+S3vFlTLcuD//Q3ma4CDWe/ab0IHHcofKPqu6iBIcgfrmNezxQWBYdyAh2kDNqWZ+u5zqxDD7bBsmKoYNMcZ74r46kOOu/we3r+B3Nx8PEfOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQN71zfq//H7X3tr2fzPDBgEUtELfWj9/V6swgtbz6w=;
 b=cl7TShsHrhje8dJvzeX+jWfVUzrgE9rAi4hUxKIVrQdYv8Q2wvFnaX19i1LVzRI/ZjntecSK4Bet3laRwMiQddK07IlL61huaXdj67RVIfvfQ+auiFvh3GnW6UgzjvX3gh8buZEWo/QaJgVWd9Qj6C+K0CLyUUezX4vE+7FsWdglZZxFWSLQcQWwBx2jSAZ6M0hTKHn0zeED2QoB6sLn4Bvsfz/PuprfKvQn9a9/svmzDpuPBZMi8E8KuScNX/PrHvlVHIRwowIOqrzY0S7PNFiuOxeZVZUG7DZ98G4tvAjJSI6XDckN+XagAq/GoGaS8JyGGE2tL9JZTovaMJePfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQN71zfq//H7X3tr2fzPDBgEUtELfWj9/V6swgtbz6w=;
 b=Ch0zcCfzln5oyPugLQdx/eMVQzzuYIXu1ydpnhvCL6Q39fF51rd5Qox/AV83fYE3VsFyqzAD4eS8r2HSG3Z/0sRFLhkYfqUe274L8JopPKrGyhkepMQZ5UnjvrjjxbLOLPa2+W5yb1MzFo1dnVbsuC+f2FO4hf+EAqnNrXaEIpo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB4087.namprd15.prod.outlook.com (2603:10b6:a02:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Wed, 16 Dec
 2020 17:00:09 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 17:00:09 +0000
Subject: Re: [PATCH v2 bpf-next 0/4] introduce bpf_iter for task_vma
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>
References: <20201215233702.3301881-1-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7032f6a9-ec51-51b0-8981-bdfda1aad5b6@fb.com>
Date:   Wed, 16 Dec 2020 09:00:06 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
In-Reply-To: <20201215233702.3301881-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:4fea]
X-ClientProxiedBy: MW4PR04CA0272.namprd04.prod.outlook.com
 (2603:10b6:303:89::7) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21cf::12e6] (2620:10d:c090:400::5:4fea) by MW4PR04CA0272.namprd04.prod.outlook.com (2603:10b6:303:89::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 16 Dec 2020 17:00:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f86a403d-02b1-4e3a-23d8-08d8a1e40bc0
X-MS-TrafficTypeDiagnostic: BYAPR15MB4087:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB408737AE38321B4EB90F97B6D3C50@BYAPR15MB4087.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rSJeLAX20U6kavWt6icmxnGgfbMxP0eT2ZuEE8i6vWZu90aiExnLBzl6Llg6DkZPxiwqI98/CkMKwC+9tBW7HGsKhUEIEW8RSwsZzDGjJg2LOfYD23CoBu/BSCrZPuPfyyBp0tQvosAXyY40NIZ5/CmMngOoVokbCRjWWYrEq9rrGlKSx/O391n2DYQyO4J9HVOhNLaDCgtl/J4YWAuLiM4o0a6xwuhORuJJ0alzZUJe0b2J2D5ndbb0E04DzAKNHIc4cvBky37N9Af2jRIpiFfM5vphSOwhE8L2/6EBYx77XBKrY/DBbdIkCVbsejdtuAoByaV5OpBGfQn73ulFzkEyaFMr9x61BFSp8yS++c8+DELF7uPR8dcaGVFGINEbu0qet7vTGT5MLfcfZxqxg3OgWxzvzrR76k2RCsRWH2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(4326008)(31696002)(478600001)(16526019)(52116002)(8936002)(186003)(8676002)(53546011)(66556008)(66476007)(6486002)(66946007)(31686004)(5660300002)(2906002)(316002)(83380400001)(86362001)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: MtEQJCoH8XhPp3TSz7Y4ak6jmTgvfHnzfeezljZLoyEwPGHfMU5/D9b/OyVbq5O+ivnEi/mHtyL2e0DecgL/TYaD0Sp4rMfGFg8fV+1itdBPQ96lUPxFSlNLBbCNB6YNH3tJefVfFMH9/1S+woKhDvsNfgEmrWjiWnxDt8wPaBvDMYAfOSzHM5AJLgclVYVzFAp7Xdn5LHOLQb72mDiS+lZPMm2YI+43cMDYCk9x8HZqwaCYHOrGxQeEcVOOmspAdmNiG1uVUNPDjoFdNMe07PD4y/42Un0izuAQ7rRuNsVMWTf/U3GLaAuWJb5cCHi1vaSNUAm/v85+S5wgWaLjw0bj+tORQ9a2LtCRVnRWo3qzkH3tsbd33RqeERT5sf82NdiX3ykj3lTdQutK2ExGlqeK8Pu0ROloYf5HR9N5boDSaZMN8p5MidlNEvKnbdUcNeYcpM8gAtpCB0fWxo+5s92Bu3+823X3vquAQtb6beBk1Lb+k/bLLbIFgOdN5b5s9W4bhekQsJSMNAjILCnEniUIkzUlzAiuL/qspaHNial6R9mP8JNbWwn0LWnKnmvL0MCGEIrZcrQfUwtRK52rXobCAgPqYqxmuiVzPEurQagTgeGaqh3WNYNOjO0VSoKKQnBeN/AAGpUUOhDE0lerWNnKQhgyiz3NIq20Y72GnkocVcZ0+01kO8EDLvyyCcbXG5N6Me1M7It3pncefenTOruc+z8EAy8iWu7ZGKrzvIGHFRLDUnRGMri3RLXeCik4eiHvWeo79SXN4evhDTOZB5e1fVro34zGVt7GH0lqt2Y=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2020 17:00:09.3552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: f86a403d-02b1-4e3a-23d8-08d8a1e40bc0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +3XZpVWscRMXdX6D01kFnfG+qsbn7mgjBcJu16YyUFFz7bsAs7jves7buEKq1KB0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4087
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-16_07:2020-12-15,2020-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxlogscore=977 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/20 3:36 PM, Song Liu wrote:
> This set introduces bpf_iter for task_vma, which can be used to generate
> information similar to /proc/pid/maps or /proc/pid/smaps. Patch 4/4 adds

I did not see an example for /proc/pid/smaps. It would be good if you 
can cover smaps as well since it is used by a lot of people.

> an example that mimics /proc/pid/maps.
> 
> Changes v1 => v2:
>    1. Small fixes in task_iter.c and the selftests. (Yonghong)
> 
> Song Liu (4):
>    bpf: introduce task_vma bpf_iter
>    bpf: allow bpf_d_path in sleepable bpf_iter program
>    libbpf: introduce section "iter.s/" for sleepable bpf_iter program
>    selftests/bpf: add test for bpf_iter_task_vma
> 
>   include/linux/bpf.h                           |   2 +-
>   kernel/bpf/task_iter.c                        | 205 +++++++++++++++++-
>   kernel/trace/bpf_trace.c                      |   5 +
>   tools/lib/bpf/libbpf.c                        |   5 +
>   .../selftests/bpf/prog_tests/bpf_iter.c       | 106 ++++++++-
>   tools/testing/selftests/bpf/progs/bpf_iter.h  |   9 +
>   .../selftests/bpf/progs/bpf_iter_task_vma.c   |  55 +++++
>   7 files changed, 375 insertions(+), 12 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_vma.c
> 
> --
> 2.24.1
> 
