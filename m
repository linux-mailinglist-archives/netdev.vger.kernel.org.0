Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4C421124F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 20:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732784AbgGASEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 14:04:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29314 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbgGASEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 14:04:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 061I41ci026087;
        Wed, 1 Jul 2020 11:04:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=6LXUzLJurRwr+FOPo13jP7kTsJVM+YjntIBgTOAZIYw=;
 b=AFmflDHItFgBp/TnsW9Wt43uxSnTGibBaoVsA0ZOn2SudOxqk4CE/v7z77y0Yzw423/x
 Uqk6b0HcWyCCo+vtsG5M7vselKxMFBlaitG30yGiJCuoUYZaqX5cVEQPbUxCELH3Uy3C
 /yqU+YxY4An0pgIbN5oZt1Sn8LTNSJxgoKo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31xp3rrqpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 01 Jul 2020 11:04:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 1 Jul 2020 11:04:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzubM6vEKCtajmgAFEx10xGeN/2VVTUoNWjQt4UHxOjYBmqUPkzNfp4ZIGmwp4FsWsPfmE/G40HQnctpBj2dp7DZZVkS2fta3ESTZPi3hraK/Or+DYyKddsLjmb/Jcw88iBwbiKwsUmIIo6Fi6ROAHynSfX5EZclb56IQ/C2nzViyYlkB0KHHtoa00GjowmxUZ0U62atZmIHOq6srLiPnTysIpTywFW6EM+CXuaykXKv4ySLigc25zRwqWVzPVXQtsNNv0FK5+C0YQ6k5TrGVG6GVF0ZegC4upDkUNzTzzKVO2QiKKGRXekluTkvis5wzmmgaaZ/z5H3v1E8reZJ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LXUzLJurRwr+FOPo13jP7kTsJVM+YjntIBgTOAZIYw=;
 b=WZgrp34asfVx7MmHXDiY75VpeW8T94hnuiP6qqWovNwINpZtxuyKlDNdsllIc5rhB6C25Pp0UAkDryu0Apj0e/aZaQVjyFdWmYjGQcFyblcuU27MigkSFQMpdgpjwekP9iCNBaZWrcnO5tb3dKqCZbaK2oSm8fK3AukqY6MQmJTeVGI02/tr+sWTSA/VdqOVZS7w+8A58tGshOsHNunrP/2eLlUQZa8KXLiqa5bb5XI7MNvjpDBgamGCbH995qv1PWXew5SOIMq08v4/2Dlnfs0pi41FLMzqmL6wD91bOlC89fy/33mEmAB8pHTIG0iF1Xqiop6+2FTdLn2kEtrFyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LXUzLJurRwr+FOPo13jP7kTsJVM+YjntIBgTOAZIYw=;
 b=aGJ6NjmjfIWW8NxtOwRuo2qVPw9f06yv7jOHYEQx5fFjDjwFQg5QDmlL/NFq1tvcKADfVNhs6AShz85sOLp9PBeDCD8XQIRFfQHmPLWREXUtLWGMm/1CzW35Q5SLLZQDQgXSWxXtMkc8ueazOVMbse2ZiIDLtcT+AUvj9R6xxuA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB3045.namprd15.prod.outlook.com (2603:10b6:a03:f9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Wed, 1 Jul
 2020 18:04:14 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Wed, 1 Jul 2020
 18:04:14 +0000
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Switch test_vmlinux to use
 hrtimer_range_start_ns.
To:     Hao Luo <haoluo@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>
CC:     <sdf@google.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        <linux-kselftest@vger.kernel.org>
References: <20200701175315.1161242-1-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <aab03e4b-2779-3b71-44ea-735a7b92a70f@fb.com>
Date:   Wed, 1 Jul 2020 11:04:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200701175315.1161242-1-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR21CA0015.namprd21.prod.outlook.com
 (2603:10b6:a03:114::25) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:3953) by BYAPR21CA0015.namprd21.prod.outlook.com (2603:10b6:a03:114::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.1 via Frontend Transport; Wed, 1 Jul 2020 18:04:13 +0000
X-Originating-IP: [2620:10d:c090:400::5:3953]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c08f14d-f1de-4733-2683-08d81de929fb
X-MS-TrafficTypeDiagnostic: BYAPR15MB3045:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB3045848847851C9C3D45FBF7D36C0@BYAPR15MB3045.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NCjBXFQQRscZOptB/yu4D+30RYjgP63GiRgBVX09mkBE0NSVmOXnbErXAfIV7zY9sip8CuwTKyTxOoTi0qHoc+NFR6GY332MEsBjY9/PKtLVnHezh/p+f/RBkdBtUhLVsXhFbz5Aaa0Pq+Cl74YrHOHRdZ/jXPku4VWukMipoz5P2wreXGzvIgruPPEYYr6UVW0vKNa/EYo8jwikfIGShXRKbKYYIP2PGP2HNizv3AUjRKeRG5iJUGswAPAdl02CDHqfmvpyqllij/dn9YPWlDQjAHrgd/azVfxHe007CJxOhwuokVCHGjUx3HBGwYzZRzSvBcduxGSMcFv5JVeuAH6SVoKx4rdHVpm3D19qJVwNp6wkN0pcUvTG1KbXOgHm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(396003)(136003)(376002)(366004)(346002)(7416002)(31686004)(2616005)(36756003)(5660300002)(6486002)(4326008)(53546011)(66946007)(8936002)(83380400001)(52116002)(31696002)(54906003)(16526019)(8676002)(66476007)(186003)(2906002)(66556008)(316002)(86362001)(478600001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 54EfXZSgT0aC2vBmvzqIEcq+9ULGliM9PXtxhjH7gMfE11BHCYt8A91xzpZWV6m4HkQl4ci5ZbUxkJbdXzcgPsqSA4inexIWUTmZU46rcR4fc8ddDCSXicbtgYGFwdCcW35XA2fUSrgpnwmRFpoBAkkCw5n2emCyuZW5OvcB3nqpMqPTDYT/3lQlSaiEXYZbdMx1gOpSIktMCnmeCiasQwMzhbmQpIz3A1gCAANYYLhe2//kvRneNWjF6FsdPnek3bLKTAAe6hyqNiE5Vd5QsrMXP3in5GH6zGAiwhkP1uGX/9UDsxzJ7jsI2JoYDMfpOl9gBAWN8ePa9N/ta9697fH0l85+jnOHRAY2SMzf28I6slF/LMWFqZUopnBSadOv16QZlCAlKal6njyBLiAa3gWkJX5FE5QHxX9tIj3d/faygBPHzsX4Y58spP6UrNTGoXqG3AeFwY2E6KJSy4fPF1QED5oEwfZGRY8wWlmXbzYnOWSKHaxxwODoT1Y8MLmv+Dqq6q2B8sdAjZEEaXpuDQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c08f14d-f1de-4733-2683-08d81de929fb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 18:04:14.4414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j6PfvP7ipTstu2h8+W1cPfwG7izugmqW7YsZJK/vvdxuQXnbeLlY78qNbQ++qFth
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3045
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_09:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 adultscore=0 lowpriorityscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 cotscore=-2147483648 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007010127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/20 10:53 AM, Hao Luo wrote:
> The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> programs. But in a kernel built by clang, which performs more aggresive
> inlining, that function gets inlined into its caller SyS_nanosleep.
> Therefore, even though fentry and kprobe do hook on the function,
> they aren't triggered by the call to nanosleep in the test.
> 
> A possible fix is switching to use a function that is less likely to
> be inlined, such as hrtimer_range_start_ns. The EXPORT_SYMBOL functions
> shouldn't be inlined based on the description of [1], therefore safe
> to use for this test. Also the arguments of this function include the
> duration of sleep, therefore suitable for test verification.
> 
> [1] af3b56289be1 time: don't inline EXPORT_SYMBOL functions
> 
> Tested:
>   In a clang build kernel, before this change, the test fails:
> 
>   test_vmlinux:PASS:skel_open 0 nsec
>   test_vmlinux:PASS:skel_attach 0 nsec
>   test_vmlinux:PASS:tp 0 nsec
>   test_vmlinux:PASS:raw_tp 0 nsec
>   test_vmlinux:PASS:tp_btf 0 nsec
>   test_vmlinux:FAIL:kprobe not called
>   test_vmlinux:FAIL:fentry not called
> 
>   After switching to hrtimer_range_start_ns, the test passes:
> 
>   test_vmlinux:PASS:skel_open 0 nsec
>   test_vmlinux:PASS:skel_attach 0 nsec
>   test_vmlinux:PASS:tp 0 nsec
>   test_vmlinux:PASS:raw_tp 0 nsec
>   test_vmlinux:PASS:tp_btf 0 nsec
>   test_vmlinux:PASS:kprobe 0 nsec
>   test_vmlinux:PASS:fentry 0 nsec
> 
> Signed-off-by: Hao Luo <haoluo@google.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Thanks!
Acked-by: Yonghong Song <yhs@fb.com>
