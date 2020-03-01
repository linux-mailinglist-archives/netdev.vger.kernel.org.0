Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55AE1174AFD
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 05:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCAEPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 23:15:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726063AbgCAEPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 23:15:05 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0214EZ31000649;
        Sat, 29 Feb 2020 20:14:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=d+WMcW5HliRQHAQFY4GXzRyW8/tZoGXAP+t1kqxccbE=;
 b=nG76+Mrsvk2bhu4pa4tnnvO7vVvfnVn8+fHXqsRPkFl9J5QPdqeYM3vdt+G5JjyCInp+
 A3f+82EgsCC2v6V13nx0Jp5gK2e8ootD2c3UqFD1fLAkp654T0xAilbPmskSHiIykQtW
 aEvaIJN/EJppADFgUP0e5JoMjVxDoL7lBag= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 2yfmb6jxxw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 29 Feb 2020 20:14:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 20:14:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dvtlypYqCW1vH0TIrpHk1hnfHGb8kYyTahhKR2EsaiupCOkJncJGSdrWseJssOKshhMfJMDipQ8AxRb8Zs6WG+0j+9ElBzutNDJVclpmjPK1TmKTjt267hw6XhLA+RU8K31yGOASy4VtT7CC8nJS8LamqDLj/K1rgCGF4vs3e6bVMj8r6NmaUGUYlFUq63Yc7B9S6hvI+NSDwQ0Yq3o9L4nYmKVClqpRnzo6pk0JnDXB98qOTNU1HOQxklP1clIMgH0y2xOlwtvhEKQgL8J+6GrhLWnt9fxK3MssjB/8ISQfKCIP4RgictZTbMjpneeJEpIHkQzZetlJgpnHqfVLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+WMcW5HliRQHAQFY4GXzRyW8/tZoGXAP+t1kqxccbE=;
 b=C8AkMM344+iBi57q5lwhbQ+ymUVkRYqsGfZjX391XUT3jsSp0KrKcrvrEIG32bnH8XlvrUh4OoOi1hIYdss7PCAabF6DxzJDYNjX96OlAuyd4WymNYTm5KBs2T7x+5kfHImesj2ZJ2mPf69XYjZ5S7LZ3wxqcDfu3JL49ooxcTRy56TsBgvOYG6miR3g62Wy8GqFvp1rF8yiy7TOp7R6VDklngR9JJEE77eDz9CKZB/VB2JXvKhB/t7N7Q4Sh9k4SF5f8aPLDRMmt+H0M6zK9+gwlMeDDlGPGgEWbiNUpMVKLxnc12C+qnmF4PbxQY0U1DHLJMm6VYqb8/tgJy08sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+WMcW5HliRQHAQFY4GXzRyW8/tZoGXAP+t1kqxccbE=;
 b=kAKu8KoaifwP3WmqNuod0p2qZJByJS/g7bKcDO2JK+UILsW09mOfo9b9l0+uspa1zlNq74aqjgNTimtXilzUHVTvvCTy0hRtAQa0SdcvMG1N3TQ4vEG/KgutaDrJIs6Y5yi3quyuLM6CRKH6lMCt3aB+MsYiXhA0vnFA2GzWrWA=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (2603:10b6:5:13c::16)
 by DM6PR15MB3514.namprd15.prod.outlook.com (2603:10b6:5:171::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18; Sun, 1 Mar
 2020 04:14:34 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::294e:884:76fd:743c%4]) with mapi id 15.20.2772.019; Sun, 1 Mar 2020
 04:14:34 +0000
Subject: Re: [PATCH v2 bpf-next 1/2] bpftool: introduce "prog profile" command
To:     Song Liu <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>
References: <20200228234058.634044-1-songliubraving@fb.com>
 <20200228234058.634044-2-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <72fc922e-68be-e63d-0488-b8bd35e7213b@fb.com>
Date:   Sat, 29 Feb 2020 20:14:29 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
In-Reply-To: <20200228234058.634044-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR17CA0089.namprd17.prod.outlook.com
 (2603:10b6:300:c2::27) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from MacBook-Pro-52.local (2620:10d:c090:400::5:9248) by MWHPR17CA0089.namprd17.prod.outlook.com (2603:10b6:300:c2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Sun, 1 Mar 2020 04:14:32 +0000
X-Originating-IP: [2620:10d:c090:400::5:9248]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a51f80b-f7fa-4f44-37a2-08d7bd970c6d
X-MS-TrafficTypeDiagnostic: DM6PR15MB3514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB3514EB6F5D8FB2671BA3BC71D3E60@DM6PR15MB3514.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0329B15C8A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(6512007)(31686004)(81156014)(81166006)(52116002)(8676002)(6486002)(6666004)(316002)(31696002)(6506007)(86362001)(8936002)(53546011)(186003)(36756003)(4326008)(2906002)(66556008)(66476007)(478600001)(5660300002)(2616005)(16526019)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB3514;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Sy+RgoAICU4TTjJ6ga/PnB9hIZZea4asUVhNcPwD6A1Ejb1VljzyLj+i/K200zYx5VZFVd8bKsvqwCCkCW6AOa+UAR4jZ4JU6N1z7Odrb2lPJPkpcH3O3E17rPum7UyP6tAca/2v1ZSrt1izmqp+3rq+1m1aEYywQ2ULJTaqnHwj294JXsJzgTJxLk3kOo/T718tqhqpQaP6x6drt53D0MBfqavP1lLTjHXBKI8xXGV+6I8p6sT9cm9SUc5y/PxzECDGs0WGHCeX8bpr5HKJ1p6X7Kcxkxo/rfd5gadw6QApNE1w71EfPfNAVs4NacSciKA1mM2FXXUO1vjjFMJPYG/EC7DTlj3d0mwettxfZSrhirfeyG9lTmGNXcz2K7kIId3wiMsnGxklriMseFw+8c3L8S5JEJwr1OpblD1RX5aLfepJOuZX59nGOo5qZI8D
X-MS-Exchange-AntiSpam-MessageData: InhwtE+Bn18AQqDj66JbsT8smufM/oAbioawo4ldqVJ5Xuv/VUbt5B/yDqA4Uy+tT5/K0hOekjRWAm/cQPJ1JLu8YgvQDnIUptv36JrRrDQ9JBmJ34I0kIAJf4Kjh+Jtyb8f2Iq1+rMOBphslIB18+Nz3P33CUZO8pgI93pgpX8MOBP5BYzCB0MHqEZLtG5G
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a51f80b-f7fa-4f44-37a2-08d7bd970c6d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2020 04:14:34.3949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mjQpqOxtXxf73GZznyJFEt7Ld2FMal+4gpfnSOq5L+WVB0WXdCZrG0R5U4gv8mMd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3514
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 phishscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/28/20 3:40 PM, Song Liu wrote:
> With fentry/fexit programs, it is possible to profile BPF program with
> hardware counters. Introduce bpftool "prog profile", which measures key
> metrics of a BPF program.
> 
> bpftool prog profile command creates per-cpu perf events. Then it attaches
> fentry/fexit programs to the target BPF program. The fentry program saves
> perf event value to a map. The fexit program reads the perf event again,
> and calculates the difference, which is the instructions/cycles used by
> the target program.
> 
> Example input and output:
> 
>    ./bpftool prog profile 3 id 337 cycles instructions llc_misses
> 
>          4228 run_cnt
>       3403698 cycles                                              (84.08%)
>       3525294 instructions   #  1.04 insn per cycle               (84.05%)
>            13 llc_misses     #  3.69 LLC misses per million isns  (83.50%)

if run_cnt is 0, the following is the result:

-bash-4.4$ sudo ./bpftool prog profile 3 id 52 cycles instructions 
llc_misses

                  0 run_cnt
                  0 cycles 

                  0 instructions        #     -nan insn per cycle 

                  0 llc_misses          #     -nan LLC misses per 
million isns

-nan is a little bit crypto for user output. maybe just says
   unknown insns per cycle
in the comment?

We can still display "0 cycles" etc. just to make output uniform.

> 
> This command measures cycles and instructions for BPF program with id
> 337 for 3 seconds. The program has triggered 4228 times. The rest of the
> output is similar to perf-stat. In this example, the counters were only
> counting ~84% of the time because of time multiplexing of perf counters.
> 
> Note that, this approach measures cycles and instructions in very small
> increments. So the fentry/fexit programs introduce noticeable errors to
> the measurement results.
> 
> The fentry/fexit programs are generated with BPF skeletons. Therefore, we
> build bpftool twice. The first time _bpftool is built without skeletons.
> Then, _bpftool is used to generate the skeletons. The second time, bpftool
> is built with skeletons.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   tools/bpf/bpftool/Makefile                |  18 +
>   tools/bpf/bpftool/prog.c                  | 428 +++++++++++++++++++++-
>   tools/bpf/bpftool/skeleton/profiler.bpf.c | 171 +++++++++
>   tools/bpf/bpftool/skeleton/profiler.h     |  47 +++
>   tools/scripts/Makefile.include            |   1 +
>   5 files changed, 664 insertions(+), 1 deletion(-)
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.bpf.c
>   create mode 100644 tools/bpf/bpftool/skeleton/profiler.h
[.....]
