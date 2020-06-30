Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC3EB20FDC5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbgF3Uhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:37:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22624 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725872AbgF3Uhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:37:41 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05UKXfBw004334;
        Tue, 30 Jun 2020 13:37:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=L6lbj+8ZVRfUhgjnLEyZjTBKJEt8lULKwnRK53ecsDE=;
 b=q827KWECPhoObHqVg64pGzCLUJY7GNKjZN4+vQ4a5jc6kM5OI7I29z7O0if6p1CI2W3U
 2gx2Kg0uXqBkfCmvfqK779gpipHqUNBgy0WexC3I+RMdRuF5b2ZOIrYRgn4puULqsDHk
 bXl7AuZ5WxGRLUiC5sviGivMsWrvEa1FAzw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31x3xgxdgx-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jun 2020 13:37:24 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 13:37:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maBRSOf5hOB+cjWfez/gWPAPR9Nxrd4fbp0Nom1Ylfq5BbmqIisVLQq6w4s/Lqs3l0omDYSBKG4rStso8KZhO/JH4fvGihTuEw94afhYRKTBkEUmHQWVAM7NHdBNBr/mdAulF+H8bL0NnK4zxGwPOBkrBxPK3XsfIZuST7twBGPoc081DhudRqq88mko1853JEED/ROSs8fEriOOc3MHfR2V95V3SPDwswuPhrMC7aLCwEfg/l9EUGkCyGEidy/5Xv7U3BARgKQ5XZsN0HFO4Rpg1l1AuamTZ9Ia3Esdsou824LRC2d9fx9Wnmx+ed6tWvgRWzpIJcVzlYG4vy+lwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6lbj+8ZVRfUhgjnLEyZjTBKJEt8lULKwnRK53ecsDE=;
 b=WP/ZL3Aamnm2e5lf4xdZPCI0pNlL9gX44KEfXoj6tVtMHnjtYBK8IIQ9dJWbr44QHxqLDke2eZNjOqYvDNsMc4F/XK61GOk1iGFp+XdJHc0dkU6EqP9KyG7DKjqRwS4Vz08M5pOa8tKksdoEK5RVu5Z7ofChb4g7KU52Zk5rNsgD+vzXEDpjIYvO8Uy2Ch9suW6VbUn8nfesergMzq5pRF+ATJSrr4Oea9+wELBezF3708wH5KTFVcfT99JgmRVZKEQ+TW8hdSlo+nqzqTFNLfTgVrGWpqUaXeEtMH8ch+Za6FVxY/+12NdDgqiZ/Ku/oELhn3dTLPLWg7fNVsWFcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6lbj+8ZVRfUhgjnLEyZjTBKJEt8lULKwnRK53ecsDE=;
 b=Ay/GKmIjRpRgASz1C6I9Bj0/XTYDHHiiz2MPT+rf5Hds7PwUunakw2eQbao39BBWvKS0i8wofqyZ3O2PaWaYCcx4s9Ku+jKZZgjfE54n3PEfmAb0U0IlDUTwvRqjqOqVqzgYDPZ/+EaQNiWl2oQVCaquWp5QJGzoMu7TLUjxUCA=
Authentication-Results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.26; Tue, 30 Jun
 2020 20:37:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 20:37:00 +0000
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use
 hrtimer_range_start_ns.
To:     Hao Luo <haoluo@google.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <clang-built-linux@googlegroups.com>,
        <linux-kselftest@vger.kernel.org>
CC:     <sdf@google.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20200630184922.455439-1-haoluo@google.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <49df8306-ecc7-b979-d887-b023275e4842@fb.com>
Date:   Tue, 30 Jun 2020 13:36:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
In-Reply-To: <20200630184922.455439-1-haoluo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:a03:60::43) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::15c2] (2620:10d:c090:400::5:d269) by BYAPR07CA0066.namprd07.prod.outlook.com (2603:10b6:a03:60::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Tue, 30 Jun 2020 20:36:59 +0000
X-Originating-IP: [2620:10d:c090:400::5:d269]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71922cea-7fcb-486e-dc9b-08d81d355704
X-MS-TrafficTypeDiagnostic: BYAPR15MB2455:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB24559D25935EE71F2C2B898FD36F0@BYAPR15MB2455.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oAC4+qBqMttmidb+b9HXxqsZIngJo1KJNYrtzsfarh5c2z4/gb/lnB4CTxjWlyCqehpbIRmfTVy3ET8aLp1pk1hkdH+IAcW/CygQiUIsVJ3dj1mv+cbjJRzysdrUeCkQQxnwGjeyrZ57miSky8vo/5yWWmu/C1IGBxV9cbXSwUROoyr1/U0LsAPGOjUPD+veSxycoN+052bxR8a/HugO323SD0yPKkZDj0tTTUEv04l8Nfd6v0y1OcZlcGo8qzjVEK+ySwEFUkSvVaSMODBugyq2eTUVMr2PTQA3zu/qoEe48g0hIXwQpPzoJywIGpntoqASnHGJtA+Mn9R2NeIlOE3RO1PXFenWNTyLziv0I19NgH3wYHbno413oe1gKr85
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(39860400002)(396003)(136003)(6486002)(478600001)(7416002)(8936002)(186003)(4326008)(2616005)(16526019)(2906002)(31696002)(316002)(86362001)(83380400001)(36756003)(66556008)(66476007)(8676002)(66946007)(54906003)(31686004)(53546011)(52116002)(5660300002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 0BUA+l+tirTZaBZh1gbEz0auJQBkDrh1N1OtFPXnOtMeN1PkpbgSU33fS1QH/703bmbUuo6jdToBqoKrzRiQ8ks6IlinRf5RGncG8HD1cyvUUFWrI4ArpCj8/sWmXCP18I8xkl6Bm22V/2fd5buzT2ba+vc8H4KWzVAdQ7/BOng0HpsBBxoIUK6QcaUoIG2XCqvvJZka/Pg27vBhGdCk3AEfDBwMZ3Yp/ojNtj2wj4/9wUhaVpyOy6nSolYsdIeRBs3ozPRDxQCqZikwKOofFWVQOrwjydd+8a3Rg129W9atqYG3fG8fFkGj04Z1Ea5GQBTMmKkbPPwN/y/TCiE0uuaXF+566DYvVU3BQSVomLFoMn2sCUkvlCTXOILqWLEGtd8BSwJKox9Na3OXr3Pxnyg+i6K4q/xhoxrW6JcdT2qoJy2qIspXNZ6R2UUpAvORw8rrBcqAUQ9U7kqChWxpFLIXGdv5401RSwEbL22C/69l5qYw53nHZclzJX4mFXY+fgz1/Bv2UnwV6Msh/XAjsA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 71922cea-7fcb-486e-dc9b-08d81d355704
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 20:37:00.5392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7adu5mtmCX9KfqLp8Yci/YO7fN1EgCNeuKWWj13aU3OsjhdOvozjWuGESfXRpRD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-06-30_06:2020-06-30,2020-06-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 priorityscore=1501 mlxscore=0 impostorscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006300141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/20 11:49 AM, Hao Luo wrote:
> The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> programs. But it seems Clang may have done an aggressive optimization,
> causing fentry and kprobe to not hook on this function properly on a
> Clang build kernel.

Could you explain why it does not on clang built kernel? How did you
build the kernel? Did you use [thin]lto?

hrtimer_nanosleep is a global function who is called in several
different files. I am curious how clang optimization can make
function disappear, or make its function signature change, or
rename the function?

> 
> A possible fix is switching to use a more reliable function, e.g. the
> ones exported to kernel modules such as hrtimer_range_start_ns. After
> we switch to using hrtimer_range_start_ns, the test passes again even
> on a clang build kernel.
> 
> Tested:
>   In a clang build kernel, the test fail even when the flags
>   {fentry, kprobe}_called are set unconditionally in handle__kprobe()
>   and handle__fentry(), which implies the programs do not hook on
>   hrtimer_nanosleep() properly. This could be because clang's code
>   transformation is too aggressive.
> 
>   test_vmlinux:PASS:skel_open 0 nsec
>   test_vmlinux:PASS:skel_attach 0 nsec
>   test_vmlinux:PASS:tp 0 nsec
>   test_vmlinux:PASS:raw_tp 0 nsec
>   test_vmlinux:PASS:tp_btf 0 nsec
>   test_vmlinux:FAIL:kprobe not called
>   test_vmlinux:FAIL:fentry not called
> 
>   After we switch to hrtimer_range_start_ns, the test passes.
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
> ---
>   tools/testing/selftests/bpf/progs/test_vmlinux.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/bpf/progs/test_vmlinux.c b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> index 5611b564d3b1..29fa09d6a6c6 100644
> --- a/tools/testing/selftests/bpf/progs/test_vmlinux.c
> +++ b/tools/testing/selftests/bpf/progs/test_vmlinux.c
> @@ -63,20 +63,20 @@ int BPF_PROG(handle__tp_btf, struct pt_regs *regs, long id)
>   	return 0;
>   }
>   
> -SEC("kprobe/hrtimer_nanosleep")
> -int BPF_KPROBE(handle__kprobe,
> -	       ktime_t rqtp, enum hrtimer_mode mode, clockid_t clockid)
> +SEC("kprobe/hrtimer_start_range_ns")
> +int BPF_KPROBE(handle__kprobe, struct hrtimer *timer, ktime_t tim, u64 delta_ns,
> +	       const enum hrtimer_mode mode)
>   {
> -	if (rqtp == MY_TV_NSEC)
> +	if (tim == MY_TV_NSEC)
>   		kprobe_called = true;
>   	return 0;
>   }
>   
> -SEC("fentry/hrtimer_nanosleep")
> -int BPF_PROG(handle__fentry,
> -	     ktime_t rqtp, enum hrtimer_mode mode, clockid_t clockid)
> +SEC("fentry/hrtimer_start_range_ns")
> +int BPF_PROG(handle__fentry, struct hrtimer *timer, ktime_t tim, u64 delta_ns,
> +	     const enum hrtimer_mode mode)
>   {
> -	if (rqtp == MY_TV_NSEC)
> +	if (tim == MY_TV_NSEC)
>   		fentry_called = true;
>   	return 0;
>   }
> 
