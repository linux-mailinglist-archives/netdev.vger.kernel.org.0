Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C20D2310C8
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 19:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731911AbgG1RXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 13:23:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8540 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731684AbgG1RXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 13:23:45 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SHACeW002618;
        Tue, 28 Jul 2020 10:23:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=n/JIJZ+pMvzsS6ihiQLkzTTV5K2SihOI8mBMSDLAXN8=;
 b=A/UXsW5NjEFhQaZ7WwLpBAuvGHc6WjGGLV0acxL898QZzOaJ2rOeMVGUlLKVWhQXXC/W
 vWiJPET6GciPZgbIoG/rrfcVjDyai3Ky6KwZZXxpcb/qrdbo76cDXwkZj7FE0rI/lkEc
 Nwq+bV04GLbvyjIbJCn4Kv0Tp+KF35rN6vE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32j13yny05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 Jul 2020 10:23:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 10:23:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZlcNcqwDRaqWSOyhcEQo8gkQHFXCNNfYdyVdiK0pYWwHatqAge+8dMdmBFbCwndlILl5tI0LeHNcjbd2Py2wgaC5h56vTbaa6F7NdvMmh4gBdH5ckzAOZwer+no5h9dryyJuAt1LtdXjCWfmyRbt8UHITqKSTOeEJGYhkFgSDpzFgI5+hbsUVE6NCHPfMBZMyTI+QDpQNjOgwxgPTSP1LHm4C00tndMIsaucjG4i20Z7ttclixtzaK63Fec19hO4qh7fHNMS3fg5cyxzf+w+Wquu1C6/G/GbY/p0De64EnVJ/zM05T6HBDXJ7rBL72LlUchptQ8QtZt8iRPGRofqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/JIJZ+pMvzsS6ihiQLkzTTV5K2SihOI8mBMSDLAXN8=;
 b=SVY7EqivIfnLZ39JyfwbIlr7i6jf8zIKxHJJ6QONTKZx2lzVvtLurVJB3ubAYwxd/w3pDmsq4X3hSwy0iEqUNSSmQ5jWlHZEXk1BBfqJc6bDnYCwEbpd9eWrgQLkjI6RDbVhgN1bqUAraIeuRoM4li3I2BFEcrGm4FTNnA7EMJZqIoyhJKRhcTqu3s0GhL+7tToBZcwiHW2eZgAGzINSrzdDrm+n+IZskBbAaLH5fobNfqHAxL+GlnJQFsOI/VE2k5cM331++Sx9mDZVrt/2aWXdcchL/jjKsZwvSHG8f1NpUdnou9WwQhaUWinZabCGvVVAk3fJVM9a1gTMesnbmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/JIJZ+pMvzsS6ihiQLkzTTV5K2SihOI8mBMSDLAXN8=;
 b=aeeuw7vnMXENPRELBQNXA1y51gkIlq4ORgbBo2LjPoCiJwnduWT+5Cw8uPu+XRpk7ujifgXGmbKlVHBTOd8fh+01ymz8+0ySNMYVZPhDyMCEnGotjvMKuQ5658OkB/r1VL2Qe/kgjLXcsAPz0opK+VVUcdmW3hMZKzOKhm4SNag=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from CH2PR15MB3573.namprd15.prod.outlook.com (2603:10b6:610:e::28)
 by CH2PR15MB3653.namprd15.prod.outlook.com (2603:10b6:610:4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 17:23:26 +0000
Received: from CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107]) by CH2PR15MB3573.namprd15.prod.outlook.com
 ([fe80::b0ab:989:1165:107%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 17:23:26 +0000
Date:   Tue, 28 Jul 2020 10:23:17 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     <daniel@iogearbox.net>, <ast@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [bpf PATCH 1/3] bpf: sock_ops ctx access may stomp registers in
 corner case
Message-ID: <20200728172317.zdgkzfrones6pa54@kafai-mbp>
References: <159595098028.30613.5464662473747133856.stgit@john-Precision-5820-Tower>
 <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159595102637.30613.6373296730696919300.stgit@john-Precision-5820-Tower>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: BY5PR16CA0028.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::41) To CH2PR15MB3573.namprd15.prod.outlook.com
 (2603:10b6:610:e::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:bbc) by BY5PR16CA0028.namprd16.prod.outlook.com (2603:10b6:a03:1a0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 17:23:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:bbc]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4f2d271-0bd4-45bc-f8ce-08d8331aeff1
X-MS-TrafficTypeDiagnostic: CH2PR15MB3653:
X-Microsoft-Antispam-PRVS: <CH2PR15MB36536CB830D6F28C453C422BD5730@CH2PR15MB3653.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J4+kB8O70F1kzD6WWzCQAY23999oxx8PmpmGiuZXZrqWkBE7x2/zPin0sGyUkKepOOTZDkQWDQ/ay3okLn0CHZSq4gNXYwbS/FQZ/F6KY2kinPWcsOhTYN2oWXaM27n24wEqRfbnzX9qedK6zIXL7WpaDPdYLxwb0t09wH1CFKU4d6/t98JH1VEqxW7rCvJ3RVcKo493hiJIUEqPN51NVPMxYb7WFNwcgd6/sPby8qLdc7nNLTB8yi54F3RIXvt8eAt7F5LSOQX0XafZ5RnkzzY0SdIKJz4jaSig3tE9VNyDddFWwLz0VosqxSGioPGZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR15MB3573.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(376002)(396003)(366004)(5660300002)(55016002)(316002)(9686003)(4326008)(6916009)(8676002)(8936002)(83380400001)(6496006)(6666004)(66946007)(52116002)(86362001)(16526019)(1076003)(2906002)(66556008)(33716001)(66476007)(478600001)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: HXaiWhf1TbNHiUGuVlxM2Bk83z0CjRdiOqr/ilxid5goEMrRrQj8XfGCPfEEl3w/SX+LiZPWYsqZjGij0v5EK28DGJVvDoPDiBQke3EtlJkYkfqUUmJdubnpxBXr6MLTp6/92ugUFnxWxpe2bbT4xxyHBy0dOIbTnuysIt6nQ+DON2WRt8E1Wk4dsu63ELDqoC46h2TPPDxaoBdZaSyxku2xFq1yMR4aLmDleZMYEjGd28H0ltJNKwPNphaFb8acCiRrSaa6wsZ6YAw5ar32xuu0MiUMSMvGbE+O8CP1GEp9bYuZ9hcMqcnIra6soPFXXXeMyzYxW2fuouYY+IkqYzgpIEyMZ4i2USo+pFBEkTmjTCwdNZbJCjTeQM1XsZYChLM5QYpZqnf/HGotzEIrqCxEYGNbbEcrM21rmUoSuSF0j+CjBrfS9N3FTNhz2QzxoLlpyY7KbC7tYzRbuwmudvviw1hWnpALwdOUYKppWiopEsgSBcdiFvgse37Aoa4jWM/mwX6aMMa7Er7cc5eYTQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: d4f2d271-0bd4-45bc-f8ce-08d8331aeff1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR15MB3573.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 17:23:26.2992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hd8HfekPqFWo+F3Xnteq2NKc4PkRLPPdmLgACFQ7Tr+QyYuQKFPgqN6TIv/PcNO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB3653
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_15:2020-07-28,2020-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0 clxscore=1015
 impostorscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007280127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 08:43:46AM -0700, John Fastabend wrote:
> I had a sockmap program that after doing some refactoring started spewing
> this splat at me:
> 
> [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> [...]
> [18610.807359] Call Trace:
> [18610.807370]  ? 0xffffffffc114d0d5
> [18610.807382]  __cgroup_bpf_run_filter_sock_ops+0x7d/0xb0
> [18610.807391]  tcp_connect+0x895/0xd50
> [18610.807400]  tcp_v4_connect+0x465/0x4e0
> [18610.807407]  __inet_stream_connect+0xd6/0x3a0
> [18610.807412]  ? __inet_stream_connect+0x5/0x3a0
> [18610.807417]  inet_stream_connect+0x3b/0x60
> [18610.807425]  __sys_connect+0xed/0x120
> 
> After some debugging I was able to build this simple reproducer,
> 
>  __section("sockops/reproducer_bad")
>  int bpf_reproducer_bad(struct bpf_sock_ops *skops)
>  {
>         volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>         return 0;
>  }
> 
> And along the way noticed that below program ran without splat,
> 
> __section("sockops/reproducer_good")
> int bpf_reproducer_good(struct bpf_sock_ops *skops)
> {
>         volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>         volatile __maybe_unused __u32 family;
> 
>         compiler_barrier();
> 
>         family = skops->family;
>         return 0;
> }
> 
> So I decided to check out the code we generate for the above two
> programs and noticed each generates the BPF code you would expect,
> 
> 0000000000000000 <bpf_reproducer_bad>:
> ;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>        0:       r1 = *(u32 *)(r1 + 96)
>        1:       *(u32 *)(r10 - 4) = r1
> ;       return 0;
>        2:       r0 = 0
>        3:       exit
> 
> 0000000000000000 <bpf_reproducer_good>:
> ;       volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>        0:       r2 = *(u32 *)(r1 + 96)
>        1:       *(u32 *)(r10 - 4) = r2
> ;       family = skops->family;
>        2:       r1 = *(u32 *)(r1 + 20)
>        3:       *(u32 *)(r10 - 8) = r1
> ;       return 0;
>        4:       r0 = 0
>        5:       exit
> 
> So we get reasonable assembly, but still something was causing the null
> pointer dereference. So, we load the programs and dump the xlated version
> observing that line 0 above 'r* = *(u32 *)(r1 +96)' is going to be
> translated by the skops access helpers.
> 
> int bpf_reproducer_bad(struct bpf_sock_ops * skops):
> ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>    0: (61) r1 = *(u32 *)(r1 +28)
>    1: (15) if r1 == 0x0 goto pc+2
>    2: (79) r1 = *(u64 *)(r1 +0)
>    3: (61) r1 = *(u32 *)(r1 +2340)
> ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>    4: (63) *(u32 *)(r10 -4) = r1
> ; return 0;
>    5: (b7) r0 = 0
>    6: (95) exit
> 
> int bpf_reproducer_good(struct bpf_sock_ops * skops):
> ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>    0: (61) r2 = *(u32 *)(r1 +28)
>    1: (15) if r2 == 0x0 goto pc+2
>    2: (79) r2 = *(u64 *)(r1 +0)
>    3: (61) r2 = *(u32 *)(r2 +2340)
> ; volatile __maybe_unused __u32 i = skops->snd_ssthresh;
>    4: (63) *(u32 *)(r10 -4) = r2
> ; family = skops->family;
>    5: (79) r1 = *(u64 *)(r1 +0)
>    6: (69) r1 = *(u16 *)(r1 +16)
> ; family = skops->family;
>    7: (63) *(u32 *)(r10 -8) = r1
> ; return 0;
>    8: (b7) r0 = 0
>    9: (95) exit
> 
> Then we look at lines 0 and 2 above. In the good case we do the zero
> check in r2 and then load 'r1 + 0' at line 2. Do a quick cross-check
> into the bpf_sock_ops check and we can confirm that is the 'struct
> sock *sk' pointer field. But, in the bad case,
> 
>    0: (61) r1 = *(u32 *)(r1 +28)
>    1: (15) if r1 == 0x0 goto pc+2
>    2: (79) r1 = *(u64 *)(r1 +0)
> 
> Oh no, we read 'r1 +28' into r1, this is skops->fullsock and then in
> line 2 we read the 'r1 +0' as a pointer. Now jumping back to our spat,
> 
> [18610.807284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
> 
> The 0x01 makes sense because that is exactly the fullsock value. And
> its not a valid dereference so we splat.
Great debugging!  Thanks for the details explanation.

> 
> To fix we need to guard the case when a program is doing a sock_ops field
> access with src_reg == dst_reg. This is already handled in the load case
> where the ctx_access handler uses a tmp register being careful to
> store the old value and restore it. To fix the get case test if
> src_reg == dst_reg and in this case do the is_fullsock test in the
> temporary register. Remembering to restore the temporary register before
> writing to either dst_reg or src_reg to avoid smashing the pointer into
> the struct holding the tmp variable.
> 
> Adding this inline code to test_tcpbpf_kern will now be generated
> correctly from,
> 
>   9: r2 = *(u32 *)(r2 + 96)
> 
> to xlated code,
> 
>   13: (61) r9 = *(u32 *)(r2 +28)
>   14: (15) if r9 == 0x0 goto pc+4
>   15: (79) r9 = *(u64 *)(r2 +32)
>   16: (79) r2 = *(u64 *)(r2 +0)
>   17: (61) r2 = *(u32 *)(r2 +2348)
>   18: (05) goto pc+1
>   19: (79) r9 = *(u64 *)(r2 +32)
> 
> And in the normal case we keep the original code, because really this
> is an edge case. From this,
> 
>   9: r2 = *(u32 *)(r6 + 96)
> 
> to xlated code,
> 
>   22: (61) r2 = *(u32 *)(r6 +28)
>   23: (15) if r2 == 0x0 goto pc+2
>   24: (79) r2 = *(u64 *)(r6 +0)
>   25: (61) r2 = *(u32 *)(r2 +2348)
> 
> So three additional instructions if dst == src register, but I scanned
> my current code base and did not see this pattern anywhere so should
> not be a big deal. Further, it seems no one else has hit this or at
> least reported it so it must a fairly rare pattern.
> 
> Fixes: 9b1f3d6e5af29 ("bpf: Refactor sock_ops_convert_ctx_access")
I think this issue dated at least back from
commit 34d367c59233 ("bpf: Make SOCK_OPS_GET_TCP struct independent")
There are a few refactoring since then, so fixing in much older
code may not worth it since it is rare?

> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/filter.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 29e34551..c50cb80 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -8314,15 +8314,31 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>  /* Helper macro for adding read access to tcp_sock or sock fields. */
>  #define SOCK_OPS_GET_FIELD(BPF_FIELD, OBJ_FIELD, OBJ)			      \
>  	do {								      \
> +		int fullsock_reg = si->dst_reg, reg = BPF_REG_9, jmp = 2;     \
>  		BUILD_BUG_ON(sizeof_field(OBJ, OBJ_FIELD) >		      \
>  			     sizeof_field(struct bpf_sock_ops, BPF_FIELD));   \
> +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> +			reg--;						      \
> +		if (si->dst_reg == reg || si->src_reg == reg)		      \
> +			reg--;						      \
> +		if (si->dst_reg == si->src_reg) {			      \
> +			*insn++ = BPF_STX_MEM(BPF_DW, si->src_reg, reg,	      \
> +					  offsetof(struct bpf_sock_ops_kern,  \
> +				          temp));			      \
Instead of sock_ops->temp, can BPF_REG_AX be used here as a temp?
e.g. bpf_convert_shinfo_access() has already used it as a temp also.

Also, it seems the "sk" access in sock_ops_convert_ctx_access() suffers
a similar issue.

> +			fullsock_reg = reg;				      \
> +			jmp+=2;						      \
> +		}							      \
>  		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
>  						struct bpf_sock_ops_kern,     \
>  						is_fullsock),		      \
> -				      si->dst_reg, si->src_reg,		      \
> +				      fullsock_reg, si->src_reg,	      \
>  				      offsetof(struct bpf_sock_ops_kern,      \
>  					       is_fullsock));		      \
> -		*insn++ = BPF_JMP_IMM(BPF_JEQ, si->dst_reg, 0, 2);	      \
> +		*insn++ = BPF_JMP_IMM(BPF_JEQ, fullsock_reg, 0, jmp);	      \
> +		if (si->dst_reg == si->src_reg)				      \
> +			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
> +				      offsetof(struct bpf_sock_ops_kern,      \
> +				      temp));				      \
>  		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(			      \
>  						struct bpf_sock_ops_kern, sk),\
>  				      si->dst_reg, si->src_reg,		      \
> @@ -8331,6 +8347,12 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
>  						       OBJ_FIELD),	      \
>  				      si->dst_reg, si->dst_reg,		      \
>  				      offsetof(OBJ, OBJ_FIELD));	      \
> +		if (si->dst_reg == si->src_reg)	{			      \
> +			*insn++ = BPF_JMP_A(1);				      \
> +			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
> +				      offsetof(struct bpf_sock_ops_kern,      \
> +				      temp));				      \
> +		}							      \
>  	} while (0)
>  
>  #define SOCK_OPS_GET_TCP_SOCK_FIELD(FIELD) \
> 
