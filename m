Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3C61E75F7
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 08:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgE2Gde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 02:33:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725308AbgE2Gdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 02:33:33 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 04T6OS0d010883;
        Thu, 28 May 2020 23:33:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=azp09Dmpx3NFSnRd/MC+jfocHB5TLwPnF4Cq5XtSI70=;
 b=X/xg+1mLaRvFiBpzNkBm68Sbc0Vul9GyreKvm37l5SHKLEgHAZ9kcqE2MUs+j8qXPdBS
 Nghi7VZ9LUOIz2YqPQJmS4ZuTdopMzqfsK70dWCvD4cojCeTEK9ROc334ZqTAZl6obwZ
 gWwyU4yek/7fw2BUO3t6/i/X6al7Js9bIYs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 31a24ueb42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 28 May 2020 23:33:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 28 May 2020 23:33:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgOu4CZubEIBsPl09lJjaY6iisArE4fZ8D1m0COIFNYGvxLOlBVQRUcWaD3pQE1CBhpOxPC/zjcPliMYw7jjgPExJOJxnfnRv0CSeo7h4zgxv+tc7vlTSOENvDfaVlj5WV8YTXKi1Jz1JQpJeLUz3WDtfQpB4LIF3aRwgnnX4ERu7uCnHgURvxYwqlFprKXggdRz2zHNVCCk+alsTpseSweKsGjphMh9ifoAll1NZ6fAKgLVW+omKaNTS9uryCPxncDBbjVLcIP42Cz18n+bBs8ZMi9zDUQ8sPBKVSTSwkSwT3Sfi9cy5wRE4sbye/6VRux/ihZoYXp6nuyiPVCZ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azp09Dmpx3NFSnRd/MC+jfocHB5TLwPnF4Cq5XtSI70=;
 b=nmMmJsD4iMy/DeMTFgMQiL/sD3TCYBoiMft5CQ1TsafKP4j/2KUsUr3mGmX4oGop2eskLjnKAHIV+BifUBca4EV8JNpTDLti9Msi4kT3KcGOYf2BYnAApiFUNf1uN7NQen8q3op7EPSQtbKHRZrHg8HVFoLrh7cNHFKArLhzPFxf2Od0oAgPux693Et1onCI17+0zSJ+DL2Eb1lcGIMOGWe4XKSv0/cXpo6Rm/jPjEDHQ/6fv/XvsIApfYUeJBQ1zJIy3hNBWTKasNoPum0zYjgA3bPjecudaD5hZ4Plm/93HDg3NVAEMSWPz/A27dzlybTdFhXPV83w0la/9awSqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azp09Dmpx3NFSnRd/MC+jfocHB5TLwPnF4Cq5XtSI70=;
 b=KTj0VQSwfcwzv76ux69hfLWHK3XFRdgxbg96PPglETMibnlahro9HoMV71BCdimyoDtQNuGJMo6s21MV7NgO4dmz1Ob2RGjZXZCgcP9xobvdpQN/1i4EKuGaqnadm7+xqSbTYR4EUDSsccHjCW6oE9IqHxv+C1K4OGCp49jxPOg=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
 by MW3PR15MB3996.namprd15.prod.outlook.com (2603:10b6:303:41::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 06:32:59 +0000
Received: from MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219]) by MW3PR15MB3980.namprd15.prod.outlook.com
 ([fe80::998d:1003:4c7c:2219%9]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 06:32:59 +0000
Subject: Re: general protection fault in inet_unhash
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, <guro@fb.com>,
        <kuba@kernel.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <00000000000018e1d305a6b80a73@google.com>
 <d65c8424-e78c-63f9-3711-532494619dc6@fb.com>
 <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
From:   Andrii Nakryiko <andriin@fb.com>
Message-ID: <da6dd6d1-8ed9-605c-887f-a956780fc48d@fb.com>
Date:   Thu, 28 May 2020 23:32:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <CACT4Y+aNBkhxuMOk4_eqEmLjHkjbw4wt0nBvtFCw2ssn3m2NTA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To MW3PR15MB3980.namprd15.prod.outlook.com (2603:10b6:303:48::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:51:fde8:f2bb:1332] (2620:10d:c090:400::5:657d) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 06:32:58 +0000
X-Originating-IP: [2620:10d:c090:400::5:657d]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b76e114-7cdd-4bb1-5a58-08d8039a217d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3996:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3996B3F7340CD49C99D9ED04C68F0@MW3PR15MB3996.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:366;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hy+F8GMta+Ma1XLAzwNam4rFogEW//OkRKgPIt101SAaC5IP/3ktAWX2mPiZjZbvvcRw+FFuEHSzDmTz2jlDQOB9LZFOQLgcYCigW0Nh/POm3t3WwGjdGjvX2b5mXQ8yFZbNuH5/R4pOu2xCZ2LepjaoWlAtUJ3SDg/19I5m40z8V4/QOgP6X8wA337nGkskXuxsfAUg/9E2TScKohIwDpBECQktiyf6VwT0EQ6rBf34gVHCi7scIuiZnvd5vhxF0iiSNsnJByl2cy9LYCv8Cz2waK8c0y+huXRtqlQcB7Xvkj8wencVeqCTme7P0OcZaKbS9/+yGTXo3yazKaE4A4wdsr92KN2JjrXLKdtHUlfgQ/S9yQtKlnr/PQHjzPqfLtvmYz5DsnUDJswnw0brWZ3yBuxH6FNjVKVTtlVmrJ0lnF8pVgqkvkJtlfEuKFQ3ycyE2i2nRKuFpLp5DXvz2H2sAQ7lyQkpqOpJiW8IGyg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3980.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(5660300002)(36756003)(66556008)(66946007)(8676002)(4326008)(53546011)(6916009)(316002)(7416002)(31696002)(31686004)(966005)(66476007)(54906003)(6486002)(45080400002)(478600001)(2616005)(52116002)(2906002)(8936002)(186003)(83080400001)(86362001)(16526019)(83380400001)(99710200001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9EbGM3jePVLLdSfwoNvtskToJm4ueQnX9Fgze5FwrT8EPwMIXeRxW+RxDYDDkQVrv5pTzW0MRAbM4/nnq/uXvgqzXZhpPBEXILcOWR9x+OzROsXWoehA45UPXRwRlxSlfVzQLS4GL0/0Pd9YCC8H3In+bJU4C23qEco0MsI/PVUmsKbLVcNn74dZaEBTCNV60qg/yRuWKQJTZnrmgmN8aidO255/bl75MMWqjHrqL9yJiRft/qvKJme1tSRIWhKxMB+O830d7/GOOdvNpfz1Vr3PGbaIl8EqWc4bF2eGDyLBEOMog8xp7Id/LGVHZpxvj5M7cCFo0c+QCQLyxGMMrEhFPk6yGgADK5CFjyiBqIssNjOrUyFoPbxxnQSpt2DyHpsLm4WYKkCkgUJAYhGvRs+RyASwv68p+N0mZmZMfN2W6DoVDLk0nNQMR1CF0IaDAluPi41poS22GfSjS7Czr63+6Gh9Ps1FLW03m31xkgAi3jLiJOPbzawOUjBqMmbstZ6j/eCWHBigkSX5XfxuxQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b76e114-7cdd-4bb1-5a58-08d8039a217d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 06:32:59.6218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iMvYQIGuRLFKERSbvvFDT+hKfuu6E0lTYpKfsZJJaWiLB9OYHeoWBojbVjBp/5GJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3996
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 phishscore=0 spamscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 cotscore=-2147483648
 adultscore=0 mlxscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/28/20 11:23 PM, Dmitry Vyukov wrote:
> On Thu, May 28, 2020 at 11:01 PM 'Andrii Nakryiko' via syzkaller-bugs
> <syzkaller-bugs@googlegroups.com> wrote:
>>
>> On 5/28/20 9:44 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following crash on:
>>>
>>> HEAD commit:    dc0f3ed1 net: phy: at803x: add cable diagnostics support f..
>>> git tree:       net-next
>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D17289cd2100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=t1v5ZakZM9Aw_9u_I6FbFZ28U0GFs0e9dMMUOyiDxO4&e=
>>> kernel config:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_.config-3Fx-3D7e1bc97341edbea6&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=yeXCTODuJF6ExmCJ-ppqMHsfvMCbCQ9zkmZi3W6NGHo&e=
>>> dashboard link: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_bug-3Fextid-3D3610d489778b57cc8031&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=8fAJHh81yojiinnGJzTw6hN4w4A6XRZST4463CWL9Y8&e=
>>> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>>> syz repro:      https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.syz-3Fx-3D15f237aa100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=cPv-hQsGYs0CVz3I26BmauS0hQ8_YTWHeH5p-U5ElWY&e=
>>> C reproducer:   https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_repro.c-3Fx-3D1553834a100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=r6sGJDOgosZDE9sRxqFnVibDNJFt_6IteSWeqEQLbNE&e=
>>>
>>> The bug was bisected to:
>>>
>>> commit af6eea57437a830293eab56246b6025cc7d46ee7
>>> Author: Andrii Nakryiko <andriin@fb.com>
>>> Date:   Mon Mar 30 02:59:58 2020 +0000
>>>
>>>       bpf: Implement bpf_link-based cgroup BPF program attachment
>>>
>>> bisection log:  https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_bisect.txt-3Fx-3D1173cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=rJIpYFSAMRfea3349dd7PhmLD_hriVwq8ZtTHcSagBA&e=
>>> final crash:    https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_report.txt-3Fx-3D1373cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=TWpx5JNdxKiKPABUScn8WB7u3fXueCp7BXwQHg4Unz0&e=
>>> console output: https://urldefense.proofpoint.com/v2/url?u=https-3A__syzkaller.appspot.com_x_log.txt-3Fx-3D1573cd7e100000&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=-SMhn-dVZI4W51EZQ8Im0sdThgwt9M6fxUt3_bcYvk8&e=
>>>
>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>>> Reported-by: syzbot+3610d489778b57cc8031@syzkaller.appspotmail.com
>>> Fixes: af6eea57437a ("bpf: Implement bpf_link-based cgroup BPF program attachment")
>>>
>>> general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
>>> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>>> CPU: 0 PID: 7063 Comm: syz-executor654 Not tainted 5.7.0-rc6-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>
>> No idea why it was bisected to bpf_link change. It seems completely
>> struct sock-related. Seems like
> 
> Hi Andrii,
> 
> You can always find a detailed explanation of syzbot bisections under
> the "bisection log" link.

Right. Sorry, I didn't mean that bisect went wrong or anything like 
that. I just don't see how my change has anything to do with invalid 
socket state. As I just replied in another email, this particular repro 
is using bpf_link_create() for cgroup attachment, which was added in my 
patch. So running repro before my patch would always fail to attach BPF 
program, and thus won't be able to repro the issue (because the bug is 
somewhere in the interaction between BPF program attachment and socket 
itself). So it will always bisect to my patch :)

> 
>> struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
>>
>> ends up being NULL.
>>
>> Can some more networking-savvy people help with investigating this, please?
>>
>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>> Call Trace:
>>>    sk_common_release+0xba/0x370 net/core/sock.c:3210
>>>    inet_create net/ipv4/af_inet.c:390 [inline]
>>>    inet_create+0x966/0xe00 net/ipv4/af_inet.c:248
>>>    __sock_create+0x3cb/0x730 net/socket.c:1428
>>>    sock_create net/socket.c:1479 [inline]
>>>    __sys_socket+0xef/0x200 net/socket.c:1521
>>>    __do_sys_socket net/socket.c:1530 [inline]
>>>    __se_sys_socket net/socket.c:1528 [inline]
>>>    __x64_sys_socket+0x6f/0xb0 net/socket.c:1528
>>>    do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>>>    entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>> RIP: 0033:0x441e29
>>> Code: e8 fc b3 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 eb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>>> RSP: 002b:00007ffdce184148 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
>>> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441e29
>>> RDX: 0000000000000073 RSI: 0000000000000002 RDI: 0000000000000002
>>> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>> R13: 0000000000402c30 R14: 0000000000000000 R15: 0000000000000000
>>> Modules linked in:
>>> ---[ end trace 23b6578228ce553e ]---
>>> RIP: 0010:inet_unhash+0x11f/0x770 net/ipv4/inet_hashtables.c:600
>>> Code: 03 0f b6 04 02 84 c0 74 08 3c 03 0f 8e dd 04 00 00 48 8d 7d 08 44 8b 73 08 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 55 05 00 00 48 8d 7d 14 4c 8b 6d 08 48 b8 00 00
>>> RSP: 0018:ffffc90001777d30 EFLAGS: 00010202
>>> RAX: dffffc0000000000 RBX: ffff88809a6df940 RCX: ffffffff8697c242
>>> RDX: 0000000000000001 RSI: ffffffff8697c251 RDI: 0000000000000008
>>> RBP: 0000000000000000 R08: ffff88809f3ae1c0 R09: fffffbfff1514cc1
>>> R10: ffffffff8a8a6607 R11: fffffbfff1514cc0 R12: ffff88809a6df9b0
>>> R13: 0000000000000007 R14: 0000000000000000 R15: ffffffff873a4d00
>>> FS:  0000000001d2b880(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00000000006cd090 CR3: 000000009403a000 CR4: 00000000001406f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>
>>>
>>> ---
>>> This bug is generated by a bot. It may contain errors.
>>> See https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=NELwknC4AyuWSJIHbwt_O_c0jfPc_6D9RuKHh_adQ_Y&e=  for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this bug report. See:
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23status&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=YfV-e6A04EIqHwezxYop7CpJyhXD8DVzwTPUT0xckaM&e=  for how to communicate with syzbot.
>>> For information about bisection process see: https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23bisection&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=xOFzqI48uvECf4XFjlhNl4LBOT02lz1HlCL6MT1uMrI&e=
>>> syzbot can test patches for this bug, for details see:
>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__goo.gl_tpsmEJ-23testing-2Dpatches&d=DwIBaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=sMAtpavBBjBzFzT0V8c6FcH8cu2M9da3ZozO5Lc8do0&s=_cj6MOAz3yNlXgjMuyRu6ZOEjRvYWEvtTd7kE46wVfo&e=
>>>
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://urldefense.proofpoint.com/v2/url?u=https-3A__groups.google.com_d_msgid_syzkaller-2Dbugs_d65c8424-2De78c-2D63f9-2D3711-2D532494619dc6-2540fb.com&d=DwIFaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=vxqvl81C2rT6GOGdPyz8iQ&m=b2VQiGg0nrxk96tqrmflMQ24DJk-MOxx4uyOs7wSUJ0&s=TYFus0Dh0-ZHiL510kJIyPOWCyX34UzLWR4QvS3r_iY&e= .

