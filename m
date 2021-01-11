Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4E02F1CA3
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbhAKRjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:39:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51574 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728222AbhAKRjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:39:02 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BHNGBW013055;
        Mon, 11 Jan 2021 09:38:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=aJar5OssyX25rI8Q1LyGPVqjkcrYqi1OlQgrAFeB+C4=;
 b=fNBfG8sXmzOuZu0w0V1XTAzA1tp5aPwuI8V2JhH4DHTst2KjC7A/I4vHsqMjqpS4Etnx
 6OYoxv/2mngpYLp5jDwLaDaSH+J+pO/o924Nn0ZIJYZUeIR1xuESjSZ41/I23mgwzG8K
 6Rt60JV27RB9tN4X/KBjshjejgKNQ5TeqWs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw875tv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 11 Jan 2021 09:38:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:38:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I7QEqT5qBPjR/oysCAn5KNbMxq8x7XJLZRiURW5eqfneaPqzFegocpx5oCG1Vt/Db9a6L7q5egv5Xh2438mk7kFGXeElD87l5AT3Nb8MoRNCNIXeM1Mz0bXPLAcI0PuhJOpJKo3LdDHiV8xTuSm7RV+2AOL0EKMJdvXDG0UMG6mTNw7gyCaFArtlDMZdrLCGAoMmnx7VG9n3VKFUxyUeyZ0xvcT34R00C+KlwJGiwaRHj5uPqSh2PRGTiPW2IIL3vWgUeF4Ez9JrVBCMHNwIkKfcQ4RaqcAiTal6AyVbCq21f4c1I3N65eGOyzbMVeWj8BHveYSKNpDbqya6wwlrBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJar5OssyX25rI8Q1LyGPVqjkcrYqi1OlQgrAFeB+C4=;
 b=HWM7IUVFqpopb2DbrMtWVqFOrDjewxC6//6uQpzZbvf6gKG+jNDZnlLtDaPqs8vZ572h1DqifoK4PHZeM1ghCPF49BUW+WgkmQJorKPuGTy6puyMsUMCAESWx38ql5vQsUjQzbD7mF3rX7XSNCuEBlDI5QH0L3ST7eEuXrkt1knD4r1mxPYstcK0q8TVorjrmVbaKLlmSYyXrG0vNGo/rCELWa1QUrxDG0LwYXuEMw76v6f+wKOnPMvMxRAok7bb11HCI472Az2Yo7RjisbNO/Te9VuCRb5wh3QB4tt4u5TuXXQXdES6sHaigJ8L7HMcyRTnGlVYE/W5NOPgh03yPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJar5OssyX25rI8Q1LyGPVqjkcrYqi1OlQgrAFeB+C4=;
 b=LnRmHib5wwBHyhE8Si3A0xfrjHSvr4g7iBRcYYzqvBBDkt765f3RQDWDKXWB/KvUhKS0iWhYPn3+Lzuwpd4z7Ki3RV3ATIfV9zUylGy6l5CCL3rFegNaVCzY3mxTXJyRzNxYJ+PXM4Hn6uSk60TEKK1mxitD//HwB5UBizjm3qc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2775.namprd15.prod.outlook.com (2603:10b6:a03:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Mon, 11 Jan
 2021 17:38:00 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::9ae:1628:daf9:4b03%7]) with mapi id 15.20.3742.012; Mon, 11 Jan 2021
 17:38:00 +0000
Subject: Re: [PATCH bpf-next 3/4] bpf: runqslower: prefer use local vmlinux
To:     Song Liu <songliubraving@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <mingo@redhat.com>, <peterz@infradead.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kernel-team@fb.com>, <haoluo@google.com>
References: <20210108231950.3844417-1-songliubraving@fb.com>
 <20210108231950.3844417-4-songliubraving@fb.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <7d999824-eed5-6923-7f4c-236af266e542@fb.com>
Date:   Mon, 11 Jan 2021 09:37:57 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
In-Reply-To: <20210108231950.3844417-4-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:6450]
X-ClientProxiedBy: MW4PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:303:8d::7) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::1158] (2620:10d:c090:400::5:6450) by MW4PR03CA0152.namprd03.prod.outlook.com (2603:10b6:303:8d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Mon, 11 Jan 2021 17:37:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a10d2a19-0e83-405f-4215-08d8b657a452
X-MS-TrafficTypeDiagnostic: BYAPR15MB2775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB27756D25BEB5B068FCD014ADD3AB0@BYAPR15MB2775.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ByrljkmjY82OxaAolGhzxBLJeaAy2eI8GUR1p3zr0euw5AjdopmtdWW8pUfxulz4lqbMO/o4fpEKyKkiPGvDItg1CZYM/sryVYsuolGkkZ/2o9sPwEZD4CD1baerj43NgMW81/TrqmA/YwjIuDzAwYg+GfN1xlVTbDh2kSCQ+jDhxQly0tafU+OWH0rIKFYBNuEqQY9KrmCHjAE7A08McbewSjf5/+CVFrrBfS5kMuEQe8PmpBSt9i/Vrf1OHl7if46i9ngiloXBV8JthoJI6RmEaZSDRseRAL1j9MQAfq3v8mpykxteRHb1SXNrYHYKkJJhNU1jP7AbWQvuZ4ljiNWyc3j2wlEZ4uoPJ6RGsxwhTbDZiCaJKiE9YZldHTkf/mQD6DLLjMhHEw9u5ITapqmS+kn5i6LzdiU2OYvp/mTa0o4CVHv/MCm/NG+JER1pxiMRzi6AsiggeAAF/f65W48WeSQeDyuOH72kQjeSOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(39860400002)(346002)(396003)(52116002)(31686004)(5660300002)(6486002)(31696002)(2616005)(36756003)(478600001)(8936002)(83380400001)(86362001)(66946007)(66476007)(2906002)(16526019)(66556008)(316002)(53546011)(7416002)(8676002)(186003)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YWc1VWVPbHFGTkNPZUNaTXlOd290eVRvdWZET2FMUjVDZTQwZ2E2UCtKK2Ni?=
 =?utf-8?B?SE1WWnpRRUEyejc5LzBIVUtJNUJQRHpKK2FDQjMvd24zNzdUTXBHYXd0elA0?=
 =?utf-8?B?U01sd1JEdkJzT0JFU2ZFWThrU3AyYzJLaWRFMGRUMldjSFFTYmJzR1NpS3hp?=
 =?utf-8?B?Znh4bVlNemk5S1ljREVQM2dIR0ZjYkJ1S29HSXc0YzRsWUsxRk9ubnU1eU5F?=
 =?utf-8?B?bHBhQTZHWC9rVEc3cW8zNlNueFZMVVBPbHkwcUR2NkpmYkZ5QTVqOVpqc2FT?=
 =?utf-8?B?R2E3UFlEdXZNZ1VEWFFjQWlVaFdORER5NktTclNsNnVtNlB3VjNPekZsbUlq?=
 =?utf-8?B?OGJQUDdVa3hOSW9ybzQzZTg5QzlWTmlsakRvc0dVUWZuNk40NlI1TmZHTWVM?=
 =?utf-8?B?bjkyZ1R2YXp4M25oa2NQenZZOERpWEhadzRyZFFzT3JGN3A5Uis4Zy85aWpj?=
 =?utf-8?B?SnY2VUtuNDlBaXp5bmtKOXFVaVAwNUVoanNPb1llTHBKYjdQSDRKL09XNSt0?=
 =?utf-8?B?OHpXaDVEdis0Wk5hSUtjTVpMTFVOeHF4aGF6V2dpQmppUE1nVmFLZjJaeHEr?=
 =?utf-8?B?TUxjVUw0M3RGaXRGdEJVVERoM3V2eXBTa0RkczczY2NESllKUnk3Y3orNWdZ?=
 =?utf-8?B?U0dwWFM3eDZLb21Vc0lGY2Q1d21QNGZSV3FONkRzYTN5UnVSODVpVTNZSUJh?=
 =?utf-8?B?L0trTmZFNWI4ZXdDbENCNFdrNUFubEFQNDA3OVN4b3Rteld6Z3Y2ck0xejFy?=
 =?utf-8?B?b2liL2ZuZ1EvZTBndmd6d1dsMTFOSEdVVWR6QkZ4UVI3QjRIeVgxaDI1RGVu?=
 =?utf-8?B?WlQ3ZTQzWXBpNUduemFPWHdkbUdMZzB1aDJuZDBGakhzTWtYMDhGdWJObUgw?=
 =?utf-8?B?M3g2N20rMmRua200Z21oU0huRGYwK3M5cGsyOGRSYnNNbldTY1pvZ1gxazBo?=
 =?utf-8?B?SjJadjZNQnk0cExBREV1S3REUklvWmpTRTI3Uml4empEYzAxMUJEQnNrTWxY?=
 =?utf-8?B?MEtmenFMWGRTV1JGT29PMkkyRHZXS25sdWt2NE5YODJQRTRoVkxEQnhqOHJV?=
 =?utf-8?B?c2tRbmJ0bHFEYzlQUDhzODRhM2gzc0JTUUduUUtTSVI2Z3VHZTlIb2RnaFFo?=
 =?utf-8?B?M09NNTV4OElJdWZtVm5SUzBqOXB2YzFvdjlRWlV0SGlPdFl0eWVuSEc5OG1m?=
 =?utf-8?B?QXhSNS8yU0Y0RW9NWmF3cys4RDh5OXZxSE1sQ2loN0ltRXh1TE1XQUZIYUpN?=
 =?utf-8?B?WUJWT2xUSXZNd0lyWGN6UWlSd1NxN2k3UktTbHplaXhDQ2JlT1BlUkhKVjd5?=
 =?utf-8?B?RWQ2VGp1Q21wUG4rSnpXRWNBdHhaVTFmVVlpWmRFaTh5UmhTaTdRUENHT29I?=
 =?utf-8?B?WElHNm1aOHdCV3c9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4088.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2021 17:38:00.7649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: a10d2a19-0e83-405f-4215-08d8b657a452
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sEysO6IoFvQeDFWboL9IHe7T3+fJoMrI6e09IeGWwr1zhHkviE5y88U/22nLQeu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2775
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_29:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=929 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101110100
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/21 3:19 PM, Song Liu wrote:
> Update the Makefile to prefer using ../../../vmlinux, which has latest
> definitions for vmlinux.h
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   tools/bpf/runqslower/Makefile | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Makefile
> index 4d5ca54fcd4c8..306f1ce5a97b2 100644
> --- a/tools/bpf/runqslower/Makefile
> +++ b/tools/bpf/runqslower/Makefile
> @@ -19,7 +19,8 @@ CFLAGS := -g -Wall
>   
>   # Try to detect best kernel BTF source
>   KERNEL_REL := $(shell uname -r)
> -VMLINUX_BTF_PATHS := /sys/kernel/btf/vmlinux /boot/vmlinux-$(KERNEL_REL)
> +VMLINUX_BTF_PATHS := ../../../vmlinux /sys/kernel/btf/vmlinux \
> +	/boot/vmlinux-$(KERNEL_REL)

selftests/bpf Makefile has:

VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                            \
                      $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)    \
                      ../../../../vmlinux                                \
                      /sys/kernel/btf/vmlinux                            \
                      /boot/vmlinux-$(shell uname -r)

If you intend to add ../../../vmlinux, I think we should also
add $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux).

>   VMLINUX_BTF_PATH := $(or $(VMLINUX_BTF),$(firstword			       \
>   					  $(wildcard $(VMLINUX_BTF_PATHS))))
>   
> 
