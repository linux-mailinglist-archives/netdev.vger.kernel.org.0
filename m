Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE93F1D244F
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 02:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732399AbgENAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 20:54:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28760 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727033AbgENAyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 20:54:08 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04E0jIhr015659;
        Wed, 13 May 2020 17:53:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=lQVzE2g6e8U94x3Pz4L2SOl1lFQMeVwRN94gqCqWfnE=;
 b=GAh06vgyZgokvAuSDPVEVJT4OvQTfp6/5LXChrAMRrXnwe01Fyf7sqMaaCrZQZAWKaP3
 KGAZpzTHA6N/5wOiswGEooF/OV4qeJoUcB237hdKOKJjwYE472QAEkm3u1DCVDrrX0jQ
 RhpQg9Lp6xhrE5NI+4yi6lXgzwFvLWe8Yyk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3100x70csp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 13 May 2020 17:53:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 13 May 2020 17:53:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OFmMaseGS8RHr8ylyxu6aXqQQCpSQ+SFPws0++MBTG3QD1pNT1S7ZRXlPoj2fos7brI7WL00lbgEgNMiLF70oz8LCXPBE3OKyNRbzw4U5gSdLf2XtaqrE2lrM5zsQ8lij+H5h8nWpeOwHoAG//DWEZBJ1w8veSBgtpIInlft0IScAmTSFkY3ORjA3MVBOwFXxskLUYVw8TPqOC0U0tEWnxODjOw8eitnpOgAUKbwdblawk9r+mkxcE/T8nEpivsFfJ5SRyxfWpLcIL58g6ZtxsnPt57cHzGL10a+0iAutp75cXTwJw3SEg5H8K9sQmhz5MRA+OTtCn+xBnUL34G4LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQVzE2g6e8U94x3Pz4L2SOl1lFQMeVwRN94gqCqWfnE=;
 b=I42Lc2mXyxgMZ8N4DExnVWmWlP3965VY4Q5s9PUQCwIjnvXlMDNltpPqymAoalbsUBTGLxFknibyTRjBXey9jw5/ytIqAz9BbyF1KtrADF+dJUOmjXUyvW2Oxct7KNcrv9Clx0QV2lmTLgv5sJt4+0C5XjrF2n+geve+2kThAaW7pjsIUcPLZkGqbdVyInD/QEp1wB8an1kxCoi1SSuHAmtFF9IhM/Vkti87WQDKuX1z6KLZe9wwJiA4ANKeJZc83+HaYkr05XrI788akWgNh9Y1T4xjOSrIVFAZgmfkkOQuTu/i/tgQTw9irSCLh0qOg9JNeUpsOsnns6rcRBFlhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQVzE2g6e8U94x3Pz4L2SOl1lFQMeVwRN94gqCqWfnE=;
 b=Ctpgh7SQ6sN7BWA/GVf/ADzMrklfbeO/7HiCB7uMCUy0LWaiuXHaYMnAoPIawOgTnsWQzYuphpBKV8Ah6LvtsKXCFP+K6DRoW7mbkQE8gk754DvYvtXZTyCyRagICZoBqwbkH/jeadZydVvguYoA4yi4K5PQQzTH5/iwIrrQ1pk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4088.namprd15.prod.outlook.com (2603:10b6:a02:c3::18)
 by BYAPR15MB2853.namprd15.prod.outlook.com (2603:10b6:a03:fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Thu, 14 May
 2020 00:53:45 +0000
Received: from BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301]) by BYAPR15MB4088.namprd15.prod.outlook.com
 ([fe80::4922:9927:5d6c:5301%7]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 00:53:44 +0000
Subject: Re: [PATCH v2 bpf-next 6/7] bpf: add support for %pT format specifier
 for bpf_trace_printk() helper
To:     Alan Maguire <alan.maguire@oracle.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <bpf@vger.kernel.org>
CC:     <joe@perches.com>, <linux@rasmusvillemoes.dk>,
        <arnaldo.melo@gmail.com>, <kafai@fb.com>, <songliubraving@fb.com>,
        <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-7-git-send-email-alan.maguire@oracle.com>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <040b71a1-9bbf-9a55-6f1a-e7b8c36f8c6e@fb.com>
Date:   Wed, 13 May 2020 17:53:42 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
In-Reply-To: <1589263005-7887-7-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:a03:74::41) To BYAPR15MB4088.namprd15.prod.outlook.com
 (2603:10b6:a02:c3::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from macbook-pro-52.local.dhcp.thefacebook.com (2620:10d:c090:400::5:d8fa) by BYAPR05CA0064.namprd05.prod.outlook.com (2603:10b6:a03:74::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Thu, 14 May 2020 00:53:43 +0000
X-Originating-IP: [2620:10d:c090:400::5:d8fa]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd3a2fa7-5c34-4925-6e4d-08d7f7a140d8
X-MS-TrafficTypeDiagnostic: BYAPR15MB2853:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28535B414C1EEC2969ABD461D3BC0@BYAPR15MB2853.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uV2tu2u6qFMy5e1vbg2A1xjjEhWFxhe4QPAyKnHSxIayzSuBuDAjraBkUBqoa406ZQbyHFnHDLiyMhcbbR+NMWQXrvDlzgrHlylUyFEmzt1YSQSiczWzAxhuaD5Iwps4SzGkv8nxC5lhxiJeMeSBOhMF6+NJAfKPdL3bh/dBN2Hsy1ESnPpV3HK06N3eFmnIgeoQns2PQ91qQa6UtJ1SHH5gSeuBZ0B4mlhXEJn+1lYPVu5l9eCjGAwjVzHg0tCQvj1BoXud9n15wioJWEWLDxoYZPk7S5nVClH2H2olfwUwQZUoW/JPiK9HSdm9Hd4i+TCAS/J5xi81ZJJ27xTpM5XO/hGPJ3wXvpcWGLEkwJMlJGGgPwaBiz0f5g23fwGXoPPC1bwOkt/vYBO6FpKyEN6CnwNcgBi28UeDlxgZ2QwaOUxFGAJksIJbjLYjeSTuUAvlpDaR2RM1q83cpTZH+yIVban9Qr+Mp0OGZv2flLZJ6bj4tZHiiLC8OavoeGC1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4088.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(316002)(2616005)(66946007)(86362001)(31686004)(66476007)(36756003)(16526019)(4326008)(186003)(66556008)(6506007)(5660300002)(478600001)(6512007)(6486002)(2906002)(7416002)(8936002)(52116002)(8676002)(31696002)(53546011)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: Y47q2rfiHCJNiP4VvCoE+viIyS5YFSsliHscrEdV92hA0rGxdI3ufzMAds0Hn62gx+qFAkLCVbSjoq+Cqh+YVNUsE/qqvqtgRxOlNt3oeJZUcmr3OVCYbvKr6So9SVmWZIXSH7oE1cywiT/cu+bw4NyLoMgVIIgaPFncXwPVPyI9gbKqdAPh9d5Frmkzss1SP17uB9ZjmuFRBEcar5hy2RiT+vJRiA25nqZpbPpX4O/hrYxjp3Sz2YinM/5AIpP858E4o4Yv81/3p/Fuib6gH/7TZDPO5IDMRP2M+8w0pj8iv/DHVSkoMESDW45cC8F0nAOFr6mMgB8++EpUzoltdQn+QI1pf2e1midN3puiVRgzwVFWN80lKqE7uABE+y2ASNOqVo+jc6Fhujf8N8rFz/gAtC/Fut3gqvWQ9qbAkFMCxPr41IriSTSurvsar4igaX2+EUD0gkKdGGFc1K/huEq0j/a5REnP54tmNEd66n6+ogrOoz3pyfGQs22u1EWlcbhBX2+blzlZVwqOdOn9yQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: dd3a2fa7-5c34-4925-6e4d-08d7f7a140d8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 00:53:44.7634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JUI2Bdt0rNCD4Ef1rYz8vE3nJ0uV2FmSe3NxtuvIznJhyBUUmaoAZMnG7lh+Mi/e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2853
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-13_09:2020-05-13,2020-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 cotscore=-2147483648 lowpriorityscore=0 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005140005
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/20 10:56 PM, Alan Maguire wrote:
> Allow %pT[cNx0] format specifier for BTF-based display of data associated
> with pointer.
> 
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>   include/uapi/linux/bpf.h       | 27 ++++++++++++++++++++++-----
>   kernel/trace/bpf_trace.c       | 21 ++++++++++++++++++---
>   tools/include/uapi/linux/bpf.h | 27 ++++++++++++++++++++++-----
>   3 files changed, 62 insertions(+), 13 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 9d1932e..ab3c86c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -695,7 +695,12 @@ struct bpf_stack_build_id {
>    * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
>    * 		available. It can take up to three additional **u64**
>    * 		arguments (as an eBPF helpers, the total number of arguments is
> - * 		limited to five).
> + *		limited to five), and also supports %pT (BTF-based type
> + *		printing), as long as BPF_READ lockdown is not active.
> + *		"%pT" takes a "struct __btf_ptr *" as an argument; it
> + *		consists of a pointer value and specified BTF type string or id
> + *		used to select the type for display.  For more details, see
> + *		Documentation/core-api/printk-formats.rst.
>    *
>    * 		Each time the helper is called, it appends a line to the trace.
>    * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
> @@ -731,10 +736,10 @@ struct bpf_stack_build_id {
>    * 		The conversion specifiers supported by *fmt* are similar, but
>    * 		more limited than for printk(). They are **%d**, **%i**,
>    * 		**%u**, **%x**, **%ld**, **%li**, **%lu**, **%lx**, **%lld**,
> - * 		**%lli**, **%llu**, **%llx**, **%p**, **%s**. No modifier (size
> - * 		of field, padding with zeroes, etc.) is available, and the
> - * 		helper will return **-EINVAL** (but print nothing) if it
> - * 		encounters an unknown specifier.
> + *		**%lli**, **%llu**, **%llx**, **%p**, **%pT[cNx0], **%s**.
> + *		Only %pT supports modifiers, and the helper will return
> + *		**-EINVAL** (but print nothing) if it encouters an unknown
> + *		specifier.
>    *
>    * 		Also, note that **bpf_trace_printk**\ () is slow, and should
>    * 		only be used for debugging purposes. For this reason, a notice
> @@ -4058,4 +4063,16 @@ struct bpf_pidns_info {
>   	__u32 pid;
>   	__u32 tgid;
>   };
> +
> +/*
> + * struct __btf_ptr is used for %pT (typed pointer) display; the
> + * additional type string/BTF id are used to render the pointer
> + * data as the appropriate type.
> + */
> +struct __btf_ptr {
> +	void *ptr;
> +	const char *type;
> +	__u32 id;
> +};
> +
>   #endif /* _UAPI__LINUX_BPF_H__ */
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index d961428..c032c58 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -321,9 +321,12 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
>   	return &bpf_probe_write_user_proto;
>   }
>   
> +#define isbtffmt(c)	\
> +	(c == 'T' || c == 'c' || c == 'N' || c == 'x' || c == '0')
> +
>   /*
>    * Only limited trace_printk() conversion specifiers allowed:
> - * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %s
> + * %d %i %u %x %ld %li %lu %lx %lld %lli %llu %llx %p %pT %s
>    */
>   BPF_CALL_5(bpf_trace_printk, char *, fmt, u32, fmt_size, u64, arg1,
>   	   u64, arg2, u64, arg3)
> @@ -361,8 +364,20 @@ static const struct bpf_func_proto *bpf_get_probe_write_proto(void)
>   			i++;
>   		} else if (fmt[i] == 'p' || fmt[i] == 's') {
>   			mod[fmt_cnt]++;
> -			/* disallow any further format extensions */
> -			if (fmt[i + 1] != 0 &&
> +			/*
> +			 * allow BTF type-based printing, and disallow any
> +			 * further format extensions.
> +			 */
> +			if (fmt[i] == 'p' && fmt[i + 1] == 'T') {
> +				int ret;
> +
> +				ret = security_locked_down(LOCKDOWN_BPF_READ);
> +				if (unlikely(ret < 0))
> +					return ret;
> +				i++;
> +				while (isbtffmt(fmt[i]))
> +					i++;

The pointer passed to the helper may not be valid pointer. I think you
need to do a probe_read_kernel() here. Do an atomic memory allocation
here should be okay as this is mostly for debugging only.


> +			} else if (fmt[i + 1] != 0 &&
>   			    !isspace(fmt[i + 1]) &&
>   			    !ispunct(fmt[i + 1]))
>   				return -EINVAL;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 9d1932e..ab3c86c 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -695,7 +695,12 @@ struct bpf_stack_build_id {
>    * 		to file *\/sys/kernel/debug/tracing/trace* from DebugFS, if
>    * 		available. It can take up to three additional **u64**
>    * 		arguments (as an eBPF helpers, the total number of arguments is
> - * 		limited to five).
> + *		limited to five), and also supports %pT (BTF-based type
> + *		printing), as long as BPF_READ lockdown is not active.
> + *		"%pT" takes a "struct __btf_ptr *" as an argument; it
> + *		consists of a pointer value and specified BTF type string or id
> + *		used to select the type for display.  For more details, see
> + *		Documentation/core-api/printk-formats.rst.
>    *
>    * 		Each time the helper is called, it appends a line to the trace.
>    * 		Lines are discarded while *\/sys/kernel/debug/tracing/trace* is
> @@ -731,10 +736,10 @@ struct bpf_stack_build_id {
>    * 		The conversion specifiers supported by *fmt* are similar, but
>    * 		more limited than for printk(). They are **%d**, **%i**,
>    * 		**%u**, **%x**, **%ld**, **%li**, **%lu**, **%lx**, **%lld**,
> - * 		**%lli**, **%llu**, **%llx**, **%p**, **%s**. No modifier (size
> - * 		of field, padding with zeroes, etc.) is available, and the
> - * 		helper will return **-EINVAL** (but print nothing) if it
> - * 		encounters an unknown specifier.
> + *		**%lli**, **%llu**, **%llx**, **%p**, **%pT[cNx0], **%s**.
> + *		Only %pT supports modifiers, and the helper will return
> + *		**-EINVAL** (but print nothing) if it encouters an unknown
> + *		specifier.
>    *
>    * 		Also, note that **bpf_trace_printk**\ () is slow, and should
>    * 		only be used for debugging purposes. For this reason, a notice
> @@ -4058,4 +4063,16 @@ struct bpf_pidns_info {
>   	__u32 pid;
>   	__u32 tgid;
>   };
> +
> +/*
> + * struct __btf_ptr is used for %pT (typed pointer) display; the
> + * additional type string/BTF id are used to render the pointer
> + * data as the appropriate type.
> + */
> +struct __btf_ptr {
> +	void *ptr;
> +	const char *type;
> +	__u32 id;
> +};
> +
>   #endif /* _UAPI__LINUX_BPF_H__ */
> 
