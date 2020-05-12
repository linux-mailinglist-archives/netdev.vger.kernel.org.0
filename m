Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38E61CF979
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 17:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgELPli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 11:41:38 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10264 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727099AbgELPlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 11:41:37 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04CFag7a000913;
        Tue, 12 May 2020 08:41:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=I9TSMUfGBQx+3Km6MOQ1g1bWobm65aN7RIa3fzVjUkc=;
 b=JF1fUUQl24MIDJwEvBXri0bZwbidNq/6GIV5OlOGRjGb+c10TlRI8GYkKDWUW3oQ/TZk
 X69wdw1fxthu80fFZ9RJKU/YziKn8AuI3i+tKYUM7TWLW/gwfIR4g//it/h6AbxJM/gm
 64JuIMt9FA6TnrCrnKAI8GmuZrOHhyUmXwM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30xcspw1fv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 12 May 2020 08:41:23 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 12 May 2020 08:41:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXSwTjkuMN8LhCGT9JOMxBklPKSpgfgsXcUuPtnOtYS9yRvMei+PqvkIuWnTLvvmJFLxl/h1MmUvLq/+gLwdh2fm3KT00h74gWvW68JjBfzZcTB5rW9akD27JaSoZmCi71KpxjJf+Ytq1FJRCUYRWtTTAexy9MoMzZzCLjl/x1wduXwxDRSAvPihe9LXa+GVT94NxMAp46UOFCZ06hDEFa3CWNd+v7M5C+qSsyNA1RVg/nT4dhT4KZIQA0DgiNoABqMnN4JQkSQ1G3VUhjQeQEgkmDdygWcI0q+2//dMAunEJg5L7lqt0WBZsncrvlcxoiauua4ME8y/GqrBWdUQnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9TSMUfGBQx+3Km6MOQ1g1bWobm65aN7RIa3fzVjUkc=;
 b=OXyq64uLBX8HPvgTabgSqxLm3DC36eQZE8foByYBT3AQEwe0thFm7f2SrFdMxt/s3u9xJDbAH7Ar7vAGUA9L5M5+YsISt27pVuyTxa6GshEYAMiAG7GAHTR+dfcGaYgZCV0NpgGHa0esmdshujU2gkHqyzkJghnqy5V2fXEl3IacmYwY3HAKDFTt0IlGGSk8pWoL1PAe+HL2DdAZ9GD5vOlyER4pehn26RFnBzGZkqHJ2hgeMZdSmbNYhhwDlK6sJRpEAdQoPcOOCnBTyrFHzfz7X+xP5JLyWgMb/q5Mf3sOqbUizfWGA+zcw4pb9vmLrK5iYLeWzWpzyAqqgXMMLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9TSMUfGBQx+3Km6MOQ1g1bWobm65aN7RIa3fzVjUkc=;
 b=O1mZ6AuJLzY+ys7VJfo29lNUirTJd5zBUqfi2Yc/O0OazU7LCOYau84JBz60QLj3r6iC8sRlzcGl09uH8y7PL7JkViKmAdevfjaiVcHyzQV+S59TWwfYg+wUDlZcVnBogJjyvR0NzxwVfydHGE+gpzK5dksLB7Os+vNj8WyKzCo=
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2968.namprd15.prod.outlook.com (2603:10b6:a03:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Tue, 12 May
 2020 15:41:21 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 15:41:21 +0000
Subject: Re: [PATCH bpf-next v4 02/21] bpf: allow loading of a bpf_iter
 program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175900.2474947-1-yhs@fb.com>
 <20200510004139.tjlll6wqq7zevb73@ast-mbp>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <c128a30f-af40-99c9-706e-4afe268ed38f@fb.com>
Date:   Tue, 12 May 2020 08:41:19 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <20200510004139.tjlll6wqq7zevb73@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0037.prod.exchangelabs.com (2603:10b6:a03:94::14)
 To BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d0f0) by BYAPR01CA0037.prod.exchangelabs.com (2603:10b6:a03:94::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Tue, 12 May 2020 15:41:20 +0000
X-Originating-IP: [2620:10d:c090:400::5:d0f0]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d550903b-ce91-47a9-a4ae-08d7f68aeb22
X-MS-TrafficTypeDiagnostic: BYAPR15MB2968:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2968A1D4459B33A31E38AF9BD3BE0@BYAPR15MB2968.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0401647B7F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aCI1kQk34UmY/VAskpAC9oTiWzk3GPBY1oYafg6N+Pv2FGZBQHIbxzD82JRtSA+C2Equ2p7gJy0JPrFNYBPKW5bKzUyCSOaaHFXjN7MOinJGdm/K0IoHl+82Lz8YAVGY29SW8b6fby+hgajGMeR1hDkDCuoGV748OBR9bl5lUv7GSC/X048kOy8ZT6MD0MeKB/n6jE3AqDKgBmteUDXgUFJnI0g7WbO5JPwPhAD7qBtTKYdTKj3TnYKzIQjAtz2AR9vP2z/jk9NARbgD0TKFdyOLZimB+0soHqsU0Kn3259XjQsUS45MIfPk1u7fsDZ/mjv4pKhUQkRJp5lf/DPpvI6KLsxUJZBbBFaQVG1Vj0fAxQGN97/mLGu5zjgOzqe8WDWvvwxdKVAnkiFzfsl3gqvIxA5bgaOqnRyVlBaRAjcgBSfzRIyhMyzNqcdqLTvkBtlPKIP7QZHWZ3/Igg9uKuQi7n9se7w1qszRqQ6erhwMMFgsX2J00XGzmdyPLmQ5vnwHO8oQ5/lr3iGJ21J5jc/tv2Uli88qI3++7dzoEoiP+Nj+J7PeFENRMKEZMyJb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(346002)(366004)(396003)(136003)(376002)(33430700001)(2616005)(54906003)(316002)(66946007)(478600001)(66476007)(4326008)(33440700001)(6916009)(6506007)(66556008)(16526019)(31686004)(5660300002)(2906002)(31696002)(53546011)(36756003)(86362001)(52116002)(6486002)(6512007)(8676002)(186003)(8936002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: vy/x/dNZy+3wyHdMivPRlk9C0+CeP81mB0EpE/cMnGz20QQFhI/G5/8X5DVz3JPfFZhcP/UjxOUZ/g+ABq0ON5+GuKQmNA1Z17RzlhQm6LKHHuRGARqK2UBEP2psBw5LT2hre+KfL/dS8hDSJDxok/R3/qt3b1Ruy42AcntZf2tB6/le8X7k24TUPQnh8t3nbFd2+DA3Lhglb8A2JLLMj7i39r0NWXN1obzfG0BW4r4NrQrfq1wdL5HwkfF0R7u0XYFprIFLx+0JNiG2kwsQYeGM6W0Vw3L3cC6ql2PDqVvLUjkVRfuZwuUx2gISqfI5oPqR77VkrKfql5vQJ3hNvc/HwJMKN602Bm1sq+EOCpDk2t2/lXJChg5nwSjQPU08ctXN3UslyD5D/IdfxRLN8Rk01RK/2Lwwd0BHlo//MzxeEYhzx742j5lF/0JCMDQMlLHUFIjk/rxfx2YuUVtB5+VImVtTRvMGEa+bBQLqjjpLhUcNIZ2IFbOooyWuC8pb7+T14f7zBacmoGBfwtMeJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: d550903b-ce91-47a9-a4ae-08d7f68aeb22
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2020 15:41:21.0258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tp3LWQplq4bQjjZd44LqJebXsm+vTwPhVvAkhAvhNjVjT78UumZ8uzjIVfWbo54a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2968
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-12_04:2020-05-11,2020-05-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 bulkscore=0 phishscore=0 impostorscore=0
 spamscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120118
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/20 5:41 PM, Alexei Starovoitov wrote:
> On Sat, May 09, 2020 at 10:59:00AM -0700, Yonghong Song wrote:
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 70ad009577f8..d725ff7d11db 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -7101,6 +7101,10 @@ static int check_return_code(struct bpf_verifier_env *env)
>>   			return 0;
>>   		range = tnum_const(0);
>>   		break;
>> +	case BPF_PROG_TYPE_TRACING:
>> +		if (env->prog->expected_attach_type != BPF_TRACE_ITER)
>> +			return 0;
>> +		break;
> 
> Not related to this set, but I just noticed that I managed to forget to
> add this check for fentry/fexit/freplace.
> While it's not too late let's enforce return 0 for them ?
> Could you follow up with a patch for bpf tree?

Just want to double check. In selftests, we have

SEC("fentry/__set_task_comm")
int BPF_PROG(prog4, struct task_struct *tsk, const char *buf, bool exec)
{
         return !tsk;
}

SEC("fexit/__set_task_comm")
int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
{
         return !tsk;
}

fentry/fexit may returrn 1. What is the intention here? Does this mean
we should allow [0, 1] instead of [0, 0]?

For freplace, we have

__u64 test_get_skb_len = 0;
SEC("freplace/get_skb_len")
int new_get_skb_len(struct __sk_buff *skb)
{
         int len = skb->len;

         if (len != 74)
                 return 0;
         test_get_skb_len = 1;
         return 74; /* original get_skb_len() returns skb->len */
}

That means freplace may return arbitrary values depending on what
to replace?
