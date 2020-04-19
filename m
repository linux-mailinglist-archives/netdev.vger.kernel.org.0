Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FC41AF72D
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 07:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSFaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 01:30:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31846 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgDSFaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 01:30:46 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03J5OkfH027816;
        Sat, 18 Apr 2020 22:30:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=WBm2tDGxLaLul3ZrIPa0MbysJdoLVIAbCTCkCTuEFQo=;
 b=Kf2ysipW8XuUrfKlRWu51q5J5zWy/bd0dzQux8QWOOLbwpCKZBNJPomFZeln0Esizs3e
 R6Vq7mVrPvnuaYlAvY6q9dlt8KpmLE9kHmz3jBsM2h8IQXEmInPMo4qqFSnWq/6lCh92
 nLdz+Atg1U7k2KLMSzKY4SmeakJnwaoBeq0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30fxng3j3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 18 Apr 2020 22:30:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sat, 18 Apr 2020 22:30:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3h64uN0/eN81aKE6yDDA948LYoGCyJJBUYQvnFct1EjkAbgy4gUuLLRr1rkDg67X5OeSxYSr2qllLgr1yYJkHOKzwkpXaRC4WUYha5MpZPW3zBvslHJPGcKpUSISBYui3yyY5pYLHX/YzF+QRetRs0iZYJaUSmN4FGdTiDYLo39aH5TRKY0AjdOWRdkk2RjhxsGqRelC+3gkf6FqZpb4N+EOIJrQ135aaMKWYXhWA1DDf7H2NJzXUr+TCtR1YHs7zRAT+5viP6PItDI3BsJXyBz6GqD6r8e9y/HZ+eC6PUTVCnLtbijDWINBp24M8BnPevCh+ZeFyirRHHny282Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBm2tDGxLaLul3ZrIPa0MbysJdoLVIAbCTCkCTuEFQo=;
 b=Yf+3lJ0Nr9v8cfygyIeR13/t0e0OQgdHtI+Dpj96VlNKr2ErOz9A1s9p7WKKo6izVnqfdy+uKtnoXC0gvp1msKyLDG8O/M7TZN0lHpPjLHV6HNGLGUUaV8WrK5xPLjDYVfcIRbv/x+7r9d8ie25EOsolAU51Wtnmc1blvk/wIavTnWiKJpEtOIwZwDi7aU5NCRKijTKwH+cRCboJk2WXUvhQjffdPmgL5qmFdpX71Y7Buv4rVyBu1JlxjZTuNILe4NUuZq1By1yL6EKLvGDeWQdiv2zhAv67Ma0UL34hbB/5m2L9Yc/iYiJwnVt9djC63aV89QrvOl8mWXIZ353U1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WBm2tDGxLaLul3ZrIPa0MbysJdoLVIAbCTCkCTuEFQo=;
 b=MKHX8rnkHiEejjz3bA5zQJhqD0YoBZLgLmf7Q7TT5sdaFbsHRMVW8SAmkvaNzjGdZGAQoaTOrFBNoe74RCyB6PyTqJho18BX52aCFk8T2Lz5T5zBd0b/21zJlhC/HSldWWBMBwqbi4+tHNgvB5TnKQRLP/1/pJvqmVGqXiJ9KTE=
Received: from MW3PR15MB3883.namprd15.prod.outlook.com (2603:10b6:303:51::22)
 by MW3PR15MB3929.namprd15.prod.outlook.com (2603:10b6:303:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sun, 19 Apr
 2020 05:30:27 +0000
Received: from MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075]) by MW3PR15MB3883.namprd15.prod.outlook.com
 ([fe80::7d15:e3c5:d815:a075%7]) with mapi id 15.20.2921.027; Sun, 19 Apr 2020
 05:30:27 +0000
Subject: Re: [RFC PATCH bpf-next v2 00/17] bpf: implement bpf based dumping of
 kernel data structures
To:     Alan Maguire <alan.maguire@oracle.com>,
        David Ahern <dsahern@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
 <40e427e2-5b15-e9aa-e2cb-42dc1b53d047@gmail.com>
 <alpine.LRH.2.21.2004171106580.32559@localhost>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <08d95e5f-9b14-4e61-8b71-f7be3b5cc30f@fb.com>
Date:   Sat, 18 Apr 2020 22:30:24 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <alpine.LRH.2.21.2004171106580.32559@localhost>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CO2PR04CA0170.namprd04.prod.outlook.com
 (2603:10b6:104:4::24) To MW3PR15MB3883.namprd15.prod.outlook.com
 (2603:10b6:303:51::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wongal-imac.dhcp.thefacebook.com (2620:10d:c090:400::5:7ab3) by CO2PR04CA0170.namprd04.prod.outlook.com (2603:10b6:104:4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Sun, 19 Apr 2020 05:30:26 +0000
X-Originating-IP: [2620:10d:c090:400::5:7ab3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c2c7ad3-b11d-4319-dc07-08d7e422c462
X-MS-TrafficTypeDiagnostic: MW3PR15MB3929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB3929F8F90A53B4B61B2F981CD3D70@MW3PR15MB3929.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3883.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(136003)(346002)(366004)(39860400002)(376002)(396003)(31696002)(4326008)(54906003)(52116002)(31686004)(316002)(2616005)(110136005)(186003)(6486002)(53546011)(6506007)(6512007)(16526019)(86362001)(8676002)(478600001)(66476007)(8936002)(36756003)(66556008)(5660300002)(66946007)(81156014)(966005)(2906002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwAqUTqGbDeA8XcgnGRmfqPFQpMoyA+FsYNx8HxfKspIujCEUxHOvvN7cYWYM5ZdZl5ihrW7sPThOlG9sRftAYBCvZXFNS6TIlWVUFLudC63fg1QDMFmoZWOPwyyePbqn4h3T8vGaHyf+VNdxai/hAKqJEvRMPb22OPDJE9GiozTDPByk4D8aenrpuja/HoKoWfkxoY6JBdg6RhIWFcxbo0VvXB0XLmpqsZTyCHStXQvLCKef4p2DFF7c+12Iw/IC9UQO4UU+h2lf9QEmDypmeFPReyvLXpFsEX2YA6Lw5+ixFK5UrNL2heozf56vxGO0Si4zS/h4NV3slki5oh8raAoFh1fkXCyuE40t30Sby/MBL5g5fraCR85RU5isDcj2zZDPruGANhlB8cNWBslmFJEqZBU0q0IlnUo3vETUfydyJ785J0kssOmPuAL43z+cC2u+nLXxB5/aKl5eAgiyiQqh5D2LVtFuSrJpRFmPKQX+hvHl4bkivWBSBSp+YHs0DQaKNN0mj80YMZwcwKFHQ==
X-MS-Exchange-AntiSpam-MessageData: L4gjs/4oPkIMyBuQY5NH0PuDX5pVJ/q0ck3FqyTKjW2weTyedI82ci7aiz6r5gR2vpg5iFdnc/dgGQqW0lSOtAYqtEO8To4nuBW/lPhiNr5z1BAHlte/KUumvnMRiocp1Ddd745AoQ8sU3AGuhG/0D0V8cipCLdOHGRw31C2MQfi8Ngp0dSVbhF10UmoTWRKZE3rKNJeKXFUNqAK8ErJdBzplyi6UpvNa4t1IrVRmxLxuWMLJkv1gO1LxQ/LE+YkKEgpNo2iTXypTEXD/G7qSZ+t34EaxB7p3oXzBooqXth2ZGQtVMTFYQUu+SBAYN7Xf4EjPp3mo5yw/+SVvFw7rwq1FfcgHFOLGpMunLYgVTpRIFLmKCUAytoVqfEUEmd22yo9AMGOXxfRCXQYyKSodYM+ePWLN7k9xTJUB7rpvBZjYFOpOz/YEF6zfALteYpllyH8yvuEDRKBqqlSjugkb4Tfboq6J3UC+LHlIzExdiFZz+0hN3G07M8LVePlgoUblPyeuECOEfBiGWB28JpxYyly9Gb4qq4FBbEiVoEDgR4HsL7LlnpDnVSdMB3rgKxtrQ4cYvhCGX2eqf/DLDUA6ml2QZD0DQyUEfSDJOjeWQVDIzyAXIKC8spEqhoEDkxbl6SG+wznmDE+MhVD1brvsgrskcBJnNvsiq+N8NSxjpDU8ZYxP3Jj6F/F95Ky/8+vRh/5iXhow15b5Lm7DaqJEyX+gB+UPtosD3v3IE1PBDdUZh9q6pmG2B4QGc/yFFTmEXt0NyG1ChLH2vaEMdORaoPVTqjkiE8t7E5548cbvO8v7k6JLI3QFd8u9jV9+Y43kiANFKxmBct5iRFbRbJ2ZA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c2c7ad3-b11d-4319-dc07-08d7e422c462
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2020 05:30:27.3139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLdPIrMp0+cCn2o45pUDuq3hDw9+u8pItsyMxllOuahnUAMoAk7FmIsJkGdiR+KS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3929
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_10:2020-04-17,2020-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 clxscore=1011 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004190048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/20 3:54 AM, Alan Maguire wrote:
> On Wed, 15 Apr 2020, David Ahern wrote:
> 
>> On 4/15/20 1:27 PM, Yonghong Song wrote:
>>>
>>> As there are some discussions regarding to the kernel interface/steps to
>>> create file/anonymous dumpers, I think it will be beneficial for
>>> discussion with this work in progress.
>>>
>>> Motivation:
>>>    The current way to dump kernel data structures mostly:
>>>      1. /proc system
>>>      2. various specific tools like "ss" which requires kernel support.
>>>      3. drgn
>>>    The dropback for the first two is that whenever you want to dump more, you
>>>    need change the kernel. For example, Martin wants to dump socket local
>>
>> If kernel support is needed for bpfdump of kernel data structures, you
>> are not really solving the kernel support problem. i.e., to dump
>> ipv4_route's you need to modify the relevant proc show function.
>>
> 
> I need to dig into this patchset a bit more, but if there is
> a need for in-kernel BTF-based structure dumping I've got a
> work-in-progress patchset that does this by generalizing the code
> that  deals with seq output in the verifier. I've posted it
> as an RFC in case it has anything useful to offer here:
> 
> https://lore.kernel.org/bpf/1587120160-3030-1-git-send-email-alan.maguire@oracle.com/T/#t
> 
> The idea is that by using different callback function we can achieve
> seq, snprintf or other output in-kernel using the kernel BTF data.
> I created one consumer as a proof-of-concept; it's a printk pointer
> format specifier.  Since the dump format is determined in kernel
> it's a bit constrained format-wise, but may be good enough for
> some cases.

The bpfdump work and here in-kernel btf dumping are different.
The bpfdump BPF programs are triggered with a user syscall, e.g.,
    cat /sys/kernel/bpfdump/task/my_dumper (also calling open())
or when user open() an anonymous dumper.

The BPF program can "print" some data through bpf_seq_printf()
helper. These printed data will be received by user space
through read() syscall.

Your work is greater as it makes kernel print more readable.
There is no overlap between your work and bpfdump.
