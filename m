Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E842AA0E0
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 00:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728879AbgKFXTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 18:19:04 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727315AbgKFXTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 18:19:03 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A6NIm0L016355;
        Fri, 6 Nov 2020 15:18:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=bqGIVoHoV6VTKX6jgTFQMXeC/Rs7JbBWxiQ3q+kUeR8=;
 b=bApV8+bIqOMSzb8RHAG7/4z3L4M1Sa9VK1GEjqvgm2sOi5sW+bTfFCSlpVlIwiCyMJEL
 h1J+ZcrcpdlZM4qJTE3lztp+7ivfXUbmYEjf2dKs5Whd23DxyrHGo/zkS7E1TrwpKU49
 DN9bVudGO5BL81qbWwMrcBbi+CjVd0TWD0s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34mr9beyqr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 06 Nov 2020 15:18:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 6 Nov 2020 15:18:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQPm1ZeVS0M42fVWirGgSGJ9qK6TCKrphMq9aAsvgW7Y285g8YTdVwK28rldixsoiVX8fcJfSRwaUGq+cLhUrKkx7lmZmfYgzw73IgDsVjhYwT6FFFpdMlBsSNg07jGmzDLgNHPe6t4PJ+xPiwUsdKSz5owE6epeXoO5XPRnPfy0xkR/Bv7x+eUj0LzmVOkLNyuconvGDpEDFFKrusov3AabIndJrruqMeBZEniUTVO+uZieNixlxYIvDdCftLiUu6XXgnejQaLK8LA/4bPptORFg+/VP1h8N4zn2/KEFtY9dQ7ApIT4XxXP1dXmXx0AquYoDlEOW46QwfhL7zJ54Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqGIVoHoV6VTKX6jgTFQMXeC/Rs7JbBWxiQ3q+kUeR8=;
 b=JzC8R25ID/GIrAqkoCrp4NJnd4BPmiezpQ6XZP64Yu0SdYio9Vn/W04X/TQ0zyhcNobNqOVacJclWEpJu4ARsCgsRK/Hy4X+MV8kVnfFn6i0G+BaxduhJy1KDa2g1bDtezlQuB+fRzNLGchPe/cy74Wq3CSnoeBZypriU88XCnShpnLPr/cnqSQ/cJMYqlKNo2wwEjpb/gRbeNamJLZcBCKweOWiLj8shWC97GjNx4Vw6CNRfe+rm/kiw/rpufuUk5rWuPB9KdZHWSaBcSCBNYr2gsRZnJ13B+y59RhP63bdE55IgCXD1G26j/JrBn2v6FUIbXbDIJFZHZlwAhS/PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bqGIVoHoV6VTKX6jgTFQMXeC/Rs7JbBWxiQ3q+kUeR8=;
 b=cjl+gCnVkvXRE2Qklw5YQpA5yvi1488c5E+qNG3qo3HBy1PMv9PeZpPDgoapKtYoeDIDoBZwFbdhrOvss37Kejd8GRxMADXb1mYml7JUORfT1PYGUkNrE0BoW2kT2QszRGiw9ouecXZb7mwwRgaA6EKxZ4S+9Z+tlsgG029aXCo=
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2453.namprd15.prod.outlook.com (2603:10b6:a02:8d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Fri, 6 Nov
 2020 23:18:35 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::bc1d:484f:cb1f:78ee%4]) with mapi id 15.20.3499.032; Fri, 6 Nov 2020
 23:18:35 +0000
Date:   Fri, 6 Nov 2020 15:18:27 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in
 FENTRY/FEXIT/RAW_TP
Message-ID: <20201106231639.ipyrsxjj3jduw7f6@kafai-mbp.dhcp.thefacebook.com>
References: <20201106220750.3949423-1-kafai@fb.com>
 <20201106220803.3950648-1-kafai@fb.com>
 <8FA16B3B-DC01-4FAB-B5F6-1871C5151D67@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8FA16B3B-DC01-4FAB-B5F6-1871C5151D67@fb.com>
X-Originating-IP: [2620:10d:c090:400::5:3041]
X-ClientProxiedBy: CO2PR04CA0106.namprd04.prod.outlook.com
 (2603:10b6:104:6::32) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:3041) by CO2PR04CA0106.namprd04.prod.outlook.com (2603:10b6:104:6::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Fri, 6 Nov 2020 23:18:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3edf3f2-f941-4a5f-8e94-08d882aa48a7
X-MS-TrafficTypeDiagnostic: BYAPR15MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB245305E11DA3B6CEBA4A2448D5ED0@BYAPR15MB2453.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: edrgV45mSq2rKF3NpljUgfwzNeuXqBpt7x+GCbbnhkEzeM/fuGAIfv8831jKhqaHQybtd6RpIIcDZzlgQsR3uZ3p/EX4bCc5d+lMQMQD3l1uhLvPD7DiW4iGea80CptRFycmhZrfgrTUU85QvpPQqTtgA8QVqFG8tkJlnDHpEUA3GKk98qjdhQ9OKqYbMUNEYzjsHxlNmx4QOl3UxQwT024R4eOmiqI1ZLKeLPTp5n/MdCw0rTw0g1sRNLIehbTAwYei+NhK0JjJLj3r1AyFHuafu8aQfDxLNuG/W9DJSFUe9cQkzuqIa1G0LJJAL1eG+cjqS9noYCJ7ixTV/MWZFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(396003)(39860400002)(66946007)(66476007)(478600001)(8676002)(9686003)(8936002)(7696005)(5660300002)(2906002)(6666004)(83380400001)(86362001)(52116002)(1076003)(66556008)(55016002)(53546011)(6506007)(54906003)(6636002)(6862004)(316002)(186003)(16526019)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 6tI4y+bg+lk+MlFILOoLvGiDOP7btj5A42IXmtDpnswIAfDavRSVLKWvhj0TQ6SWbBzAOhh7a2Tp8nv/sllgS4E3kb9m84LRTlRT62glwQXyOYlNdxQJ8gPvCWcIqaE6fyla4DmxEtm/qPnY97k/vVyam6J/lXgEHJUZPJ3FogD/hPZY3iJ1RYNOOO8ZHwCBo/G0bgUnbX/ihNRRikQ1RTsn84vNm5EO//vRask/ckqAj0Qcwta0882L7F0F/o5TLx67ixwP+NwNDlAZ5xId2SQl8XCCCDrZPvbUmDJOtyw3fzDO6Wpd10DU3Gv1+J1VYlqo6SSOmcYIMWwXTtfVnc3lTnb0nSuIVqvBJSsX/kErVR2z2PxkJBw8+veV91/3ZEMiVvsO0axfAzWBmkuw3fsP6H+JKU73hsLEpXgTQsxM8hLxYSI8VmBHWG5mRQHsvL+wm70PI0XCol7P28cNmsJwoYgS75Siv/+CZQkT/6FSQYW8YiMsTChHPTQM1autX2onga57NaKquQ60vk5987cOkW6OfOM+0xl2bpGTkFF5IQ86QvmeKSauwqfV//iLiZVnwVbT78ep4iVqh2Vka5Ws9ZedrMDQk0t2xOGl1fMMi4YSG/ozvh/iB1+s0/Y/LuIkiThxhR1o6tWidO1u0Oez/i5jRhVO1vNARbea8UBLAV4Xxrbk6SiymGTMLvUm
X-MS-Exchange-CrossTenant-Network-Message-Id: f3edf3f2-f941-4a5f-8e94-08d882aa48a7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 23:18:35.1045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5GFrrbtPYKraYf+yBRkFbX/DtHh4rwQakrY6qtOL7aNsMs4EsX6MPD0UaP7e6iGC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-06_06:2020-11-05,2020-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 suspectscore=5 mlxscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011060156
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 02:59:14PM -0800, Song Liu wrote:
> 
> 
> > On Nov 6, 2020, at 2:08 PM, Martin KaFai Lau <kafai@fb.com> wrote:
> > 
> > This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> > the bpf_sk_storage_(get|delete) helper, so those tracing programs
> > can access the sk's bpf_local_storage and the later selftest
> > will show some examples.
> > 
> > The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> > cg sockops...etc which is running either in softirq or
> > task context.
> > 
> > This patch adds bpf_sk_storage_get_tracing_proto and
> > bpf_sk_storage_delete_tracing_proto.  They will check
> > in runtime that the helpers can only be called when serving
> > softirq or running in a task context.  That should enable
> > most common tracing use cases on sk.
> > 
> > During the load time, the new tracing_allowed() function
> > will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> > helper is not tracing any *sk_storage*() function itself.
> > The sk is passed as "void *" when calling into bpf_local_storage.
> > 
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> > include/net/bpf_sk_storage.h |  2 +
> > kernel/trace/bpf_trace.c     |  5 +++
> > net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
> > 3 files changed, 80 insertions(+)
> > 
> > diff --git a/include/net/bpf_sk_storage.h b/include/net/bpf_sk_storage.h
> > index 3c516dd07caf..0e85713f56df 100644
> > --- a/include/net/bpf_sk_storage.h
> > +++ b/include/net/bpf_sk_storage.h
> > @@ -20,6 +20,8 @@ void bpf_sk_storage_free(struct sock *sk);
> > 
> > extern const struct bpf_func_proto bpf_sk_storage_get_proto;
> > extern const struct bpf_func_proto bpf_sk_storage_delete_proto;
> > +extern const struct bpf_func_proto bpf_sk_storage_get_tracing_proto;
> > +extern const struct bpf_func_proto bpf_sk_storage_delete_tracing_proto;
> > 
> > struct bpf_local_storage_elem;
> > struct bpf_sk_storage_diag;
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index e4515b0f62a8..cfce60ad1cb5 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -16,6 +16,7 @@
> > #include <linux/syscalls.h>
> > #include <linux/error-injection.h>
> > #include <linux/btf_ids.h>
> > +#include <net/bpf_sk_storage.h>
> > 
> > #include <uapi/linux/bpf.h>
> > #include <uapi/linux/btf.h>
> > @@ -1735,6 +1736,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > 		return &bpf_skc_to_tcp_request_sock_proto;
> > 	case BPF_FUNC_skc_to_udp6_sock:
> > 		return &bpf_skc_to_udp6_sock_proto;
> > +	case BPF_FUNC_sk_storage_get:
> > +		return &bpf_sk_storage_get_tracing_proto;
> > +	case BPF_FUNC_sk_storage_delete:
> > +		return &bpf_sk_storage_delete_tracing_proto;
> > #endif
> > 	case BPF_FUNC_seq_printf:
> > 		return prog->expected_attach_type == BPF_TRACE_ITER ?
> > diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> > index 001eac65e40f..1a41c917e08d 100644
> > --- a/net/core/bpf_sk_storage.c
> > +++ b/net/core/bpf_sk_storage.c
> > @@ -6,6 +6,7 @@
> > #include <linux/types.h>
> > #include <linux/spinlock.h>
> > #include <linux/bpf.h>
> > +#include <linux/btf.h>
> > #include <linux/btf_ids.h>
> > #include <linux/bpf_local_storage.h>
> > #include <net/bpf_sk_storage.h>
> > @@ -378,6 +379,78 @@ const struct bpf_func_proto bpf_sk_storage_delete_proto = {
> > 	.arg2_type	= ARG_PTR_TO_BTF_ID_SOCK_COMMON,
> > };
> > 
> > +static bool bpf_sk_storage_tracing_allowed(const struct bpf_prog *prog)
> > +{
> > +	const struct btf *btf_vmlinux;
> > +	const struct btf_type *t;
> > +	const char *tname;
> > +	u32 btf_id;
> > +
> > +	if (prog->aux->dst_prog)
> > +		return false;
> > +
> > +	/* Ensure the tracing program is not tracing
> > +	 * any *sk_storage*() function and also
> > +	 * use the bpf_sk_storage_(get|delete) helper.
> > +	 */
> > +	switch (prog->expected_attach_type) {
> > +	case BPF_TRACE_RAW_TP:
> > +		/* bpf_sk_storage has no trace point */
> > +		return true;
> > +	case BPF_TRACE_FENTRY:
> > +	case BPF_TRACE_FEXIT:
> > +		btf_vmlinux = bpf_get_btf_vmlinux();
> > +		btf_id = prog->aux->attach_btf_id;
> > +		t = btf_type_by_id(btf_vmlinux, btf_id);
> 
> What happens to fentry/fexit attach to other BPF programs? I guess
> we should check for t == NULL?
It does not support tracing BPF program and using bpf_sk_storage
at the same time for now, so there is a "if (prog->aux->dst_prog)" test earlier.
It could be extended to do it later as a follow up.
I missed to mention that in the commit message.  

"t" should not be NULL here when tracing a kernel function.
The verifier should have already checked it and ensured "t" is a FUNC.

> > +		tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> > +		return !strstr(tname, "sk_storage");
> > +	default:
> > +		return false;
> > +	}
> > +
> > +	return false;
> > +}
> 
> [...]
> 
> 
