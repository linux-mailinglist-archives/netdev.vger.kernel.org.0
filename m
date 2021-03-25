Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216AC349957
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhCYSQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:16:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57590 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229616AbhCYSQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:16:38 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 12PI9Kcg001625;
        Thu, 25 Mar 2021 11:15:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=d47smt3EaVI0AzCbU+LllMRLrXqVdxjNfI5YdsQvmk0=;
 b=IYj2Rh6hWGLdwb880/rQlMKLaWuMSo8sNzM0Ud8IG1AU8qGD4mclLhAgjIn8qVzAfmO7
 2iDqkVSP4SqFxP+cs+dZN9+2OoUsjugx9bkzimhd99ITGJCTQ2FTdUVX7aAcxG0HWZrh
 g0qqOz0Owu8tc1AtaEQ+PLZNnoDWgvJJy+0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37gt01tcau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 25 Mar 2021 11:15:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 11:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MORg1BeOVxVjpwfFZ06r+9lQfUYxhcGyk9HJCf7Uo/Nte+keT1b4+Gi/QbHeF6aAQCiJWl2jgjTr8l0Vqx1Ao5yW/i70H/v0E5IcxorYpuN8YqGBr4Qf4sppxbRXxUIkIq37ACZEl03AykvBX02nojSmRzyl7APFY6fxhYYTTdeuGY1gHSjFVKcAPL8qhdM2F5B1e5hCFoHNf0L8zq5yYQ0AoIwNRP5O5bWJXxcytwwueyccNJQ0xL6V8pm21KF2XjXYTbFTri6kdSiN6JD9J9OrdHWUYweCs3Br2ituiG2COcfGOCQwbryOf7haesy+TXQQBaSe2NuJSGw9yKQsUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OmO0cOJTBOvqIT98T2yuACrxQk9CR9eQnTQeSXthxtQ=;
 b=l8SrutBEvx3NZNOtb+Nvu/oKBi0RZRn2mRnWT5ZcHRZ9GmmDVYiVnFk769Uu0789Jn5qMe0ux+gZXRN+eVIE0OayoDH4pTE1+wSHCiq0vXyxtBkDG6fJTM0nXaSDv80AEdmOZhzDEds/nfGYKBWXXJI4WO1aRzoUoqYf3Xp8aWz6JOmPeYwGkC8ZfS/FJVClwCzkL5ZAQnRKtxZYy5awIDe5vp+uUYQugA9d5R/fsKyFwv4m3NmN4kR2WG2bCe8VfKCWDJH27AKyMLJhGk0qDgisq7idMAoL3jNYNl6EG2Jy+w2dGpEiM5zXpvXUXEU4R0XbBE1AHnzK/rlYSRvOrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2695.namprd15.prod.outlook.com (2603:10b6:a03:150::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 18:15:55 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::2975:c9d8:3f7f:dbd0%5]) with mapi id 15.20.3977.024; Thu, 25 Mar 2021
 18:15:55 +0000
Date:   Thu, 25 Mar 2021 11:15:52 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Clark Williams <williams@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf 1/2] bpf: enforce that struct_ops programs be GPL-only
Message-ID: <20210325181552.ottuv7shqgfwxlsg@kafai-mbp.dhcp.thefacebook.com>
References: <20210325154034.85346-1-toke@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325154034.85346-1-toke@redhat.com>
X-Originating-IP: [2620:10d:c090:400::5:daf1]
X-ClientProxiedBy: MWHPR11CA0034.namprd11.prod.outlook.com
 (2603:10b6:300:115::20) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:daf1) by MWHPR11CA0034.namprd11.prod.outlook.com (2603:10b6:300:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29 via Frontend Transport; Thu, 25 Mar 2021 18:15:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd521eb3-7720-457a-5ec8-08d8efba081f
X-MS-TrafficTypeDiagnostic: BYAPR15MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB269542682F2ADAC1CDD5EED7D5629@BYAPR15MB2695.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTyd8r7NboTZLlCzHZFLb5/e014Py0Y0Hv58skEwvQ3I+5n60o405Vu6sFqorTORh+bZvtfrRFJAktzBe1b0pKt/f1AhEodEprBz4PMoBDmimZcrhic2rYyZULgmd5tzUTYBwwHOo7GF6rST5mRyz64cOXAOwlThqy339nDD66qBI4WR2tBzhNCcZFlPCasp4MfcKN1jXPHpgrlk6coBn5hvWWtw9KYxwfxDCH4+KTR+rGRUJ9qw/Yfa604HLV+LDc6VbiIfBwV186Z3zO/y8ZYXXwl0WluuX9IN8nX2tB7mFMQA3QkAXBmBaeYbHdB1q5O7CrlLOJu+KhkUYuuAOquqXboophvuGtn4I29hIXdSOXToDRyI/rfmdU5VuRkQUHHmTzWPmyIkzCOLvjz3c9yySN0j0iTU8+zORIZrF9lxoavZjAuC1fUacjy00325l2X3WEmz5wJFu31r1GRJARAs8bB7teuYs2i0UmBLLi46G9gPVzqTN4O+WedXacQEEUfPl8eFy79sJySgjjE3Di80j4NVC7kbFXsF8wFiT65smjUgWiCj+0s7SL7yrUGUh2NvAI8dcHvILNZr6oODQx0FQphgf99BlWdis+h/+RUrQMQVnbDMPkhZzNl3nM/dPcMdwqBSqByYu+/2Ch7TSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(376002)(39860400002)(346002)(5660300002)(52116002)(4326008)(186003)(6916009)(8676002)(8936002)(7696005)(316002)(66574015)(66476007)(66946007)(7416002)(66556008)(1076003)(86362001)(16526019)(6506007)(55016002)(54906003)(9686003)(478600001)(38100700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?mUdH77JAVWMpVe1TI29IaS3z9KFJY/6u9X1+kdd1LoOz5mrx/HuBuEG1WH?=
 =?iso-8859-1?Q?k00QMw4K3guEuhdq1/d8PLzdRaD4GM7Rk+U8XuIl+HrJOT94yEWeNVnW83?=
 =?iso-8859-1?Q?TGNhGc6GWA7TkH384/ZrCetYnsR3LcsLYXwG0oaZw/pS0qfFhIM/BgXm8j?=
 =?iso-8859-1?Q?QWWTzkB8rEEnM5WuLO7dmiNUIFT/DPUzIpbyY4vy+jxW+1BDln/jriFh0h?=
 =?iso-8859-1?Q?WawogUWPTb3zcIyOAt/NkaotyQd+IULvoMvUPm1pCZNIJvbB0dCy3QrygA?=
 =?iso-8859-1?Q?jIwbDEQhZDKJtxpMSFUT/4ajDHhLO3TSOJWIYTTW4N5m1llEtRHnRKb0hP?=
 =?iso-8859-1?Q?hvNj0LBC0FXahrmkGN8fVfE6Y9bNDbHEMmVOliszoCOQdjLH3FsEmma0ka?=
 =?iso-8859-1?Q?AGj7Py4ZsEa346YQ1oy+jIn1TTwpNFLtPD0CGG5OGLw3gvMsY63VmxfVXv?=
 =?iso-8859-1?Q?SkoWAyyo+B3uis/bWw9gNze7LJhqexbIdXHH3nPlX7ZvGGCb85sfh2Wp02?=
 =?iso-8859-1?Q?aznVSGG5Zb+Gr85d2/l7sLbvIO9ohlIRndPcl3tC6lZNRcuzu4A1Yw+AGS?=
 =?iso-8859-1?Q?jaYPuxquaEv1bUax0l6I4FGPoWobsbmDl2sP54JZwRftETi7KJa1EADQ3i?=
 =?iso-8859-1?Q?hpkAT3xWxWZ0j5OSRZFupbXY1Rvhd/z7rdzSCXoxllduZmeguPE4J5pO/6?=
 =?iso-8859-1?Q?U25HfPC5/KhO266f2j/O/3IVy2bj5QINP/+Ehxe+SVM52lePWY4n/zQaBe?=
 =?iso-8859-1?Q?pc35vHf0aD0mArTOfbdJJu7P8U9h52s600WoWaadHkkbo7P96xS/mX3XT9?=
 =?iso-8859-1?Q?HrH+f7ev7qF3GjzG3bTxnTZV68QU/P3SdX08pCS7o6U7yf6LlbZIxexuN4?=
 =?iso-8859-1?Q?PejbvHLBVuYQPQhtTT87bbdaU68yJV7snJnJ4z8dsKWNHcO3cFP0p2XE81?=
 =?iso-8859-1?Q?g9/YTcbEgVtPhu5QCLrbejDtAZQ1dud6DOrYw9KXydXZPF58qwDJyMTgUa?=
 =?iso-8859-1?Q?k5GOz9azdB6Ft2gOPRzPtOasOgUhCwmYdfaDr9xSzvnWSW8rYLlzwS531x?=
 =?iso-8859-1?Q?DmplqIp48MRkPLa56+EfCkHVIlbEewitsJ/cw0r/L9QIN1VMuParbfA1lG?=
 =?iso-8859-1?Q?nuU3a7plYA0zUqD03gVmog4B9mkJ7w041YuS08sc1hI02EZtHoaGORYd9d?=
 =?iso-8859-1?Q?xYk2xd8iq7OcIIwHikrNogGrM9JxMVhPOsAW0r8+oXcHRs1J7myqyAWned?=
 =?iso-8859-1?Q?P4B+ejR+Ey/HWkCTZD8fUBnBnOJC16053nQwmWy94M4X7S6FPRsA2z1MGl?=
 =?iso-8859-1?Q?/+Llip9e1z8yylUD5OD+158w6NOPUD8KpNulscFNy74QwjzeP5YI/APhkD?=
 =?iso-8859-1?Q?XdbF9Tti5RomuDssLHk9uas4znj3XKbw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd521eb3-7720-457a-5ec8-08d8efba081f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 18:15:55.5042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pJLLDOjaeVPP7Up/R+9EZ0k2HIyoIBfJH2WboGL+ogs6vNwfUXzmmziRQ0frPqbn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_05:2021-03-25,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250134
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 04:40:33PM +0100, Toke Høiland-Jørgensen wrote:
> With the introduction of the struct_ops program type, it became possible to
> implement kernel functionality in BPF, making it viable to use BPF in place
> of a regular kernel module for these particular operations.
> 
> Thus far, the only user of this mechanism is for implementing TCP
> congestion control algorithms. These are clearly marked as GPL-only when
> implemented as modules (as seen by the use of EXPORT_SYMBOL_GPL for
> tcp_register_congestion_control()), so it seems like an oversight that this
> was not carried over to BPF implementations. And sine this is the only user
> of the struct_ops mechanism, just enforcing GPL-only for the struct_ops
> program type seems like the simplest way to fix this.
> 
> Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  kernel/bpf/verifier.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 44e4ec1640f1..48dd0c0f087c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -12166,6 +12166,11 @@ static int check_struct_ops_btf_id(struct bpf_verifier_env *env)
>  		return -ENOTSUPP;
>  	}
>  
> +	if (!prog->gpl_compatible) {
> +		verbose(env, "struct ops programs must have a GPL compatible license\n");
> +		return -EINVAL;
> +	}
> +
Thanks for the patch.

A nit.  Instead of sitting in between of the attach_btf_id check
and expected_attach_type check, how about moving it to the beginning
of this function.  Checking attach_btf_id and expected_attach_type
would make more sense to be done next to each other as in the current
code.

Acked-by: Martin KaFai Lau <kafai@fb.com>
