Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DB5185355
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 01:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgCNAbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 20:31:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27380 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727636AbgCNAbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 20:31:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02E0Ut5p020487;
        Fri, 13 Mar 2020 17:31:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=yKjSoI0/XF9vWhv4H2qvYi4nfoHPIbpYjonCnxUbOpk=;
 b=byOELQ3Ul0oZ36BLRE1uVnZRIE3ZRcmp8fhYCtW+ZLXkjHf2iM7WgGHO8x4KvW9bidqG
 527tVi9uAdK7Rhn+KcPeSfLqaY9rh9ABJxLsqRm5hYsdUBMDEc0khebyzDbK7qFNY1wP
 2WP7v+oxmeqp4LGz7o5F7w+PbIVLOmQsvlY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80y3p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 17:31:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 17:31:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khuJNl7hotANIL+8xk4uNaq0nEtQJqcAUk7vFPpiYuJwYp56rVitj0V/M/QGIpQmnHsykUbQrgkSz1A0cG0ObNcpumLAG39716SbzelcQ/GMzr5sXtn6zfPes4mkwYWx7+YUG5c2J+a4BnD/P3m7POyUczs/VXnvfbsKdxYlC9bMMYWW6dKIfkrfZ8s1lIyNK8MDt1j2JdXL2k+zmKmOWJvRjZ1OGyZUyjpQE8q0sbm8WgEyKVMoLdU7cg9BBBvEJDMRRW0k+l/pFB7Yu1PvR608EDLZE+yZBH4HORtv6zVU7ZU4Tv2RTTll5I2od8iWbxXO2WdXQzo4Z8GN11X3GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKjSoI0/XF9vWhv4H2qvYi4nfoHPIbpYjonCnxUbOpk=;
 b=oXMz2YoAfXE55+VWGnja5CpUWyPJ57M8hQpXOTHlmmePpf0w+WgUytC0FxX+qxsZb/Oyby12URZoy6mSHHM1GTs/AqxXw8lJvmIsS/CCKEtf+b7/XnIBtvfRJOC2S+bWUNd7SIcLMRl4NZyiQ2b9cOiZUY4M0CF2zGukxaYUHX76qcsV2s4bIJIZHBA+7VAZifAm/EbSwvDxRctZAnVxwSxpgKJKewxAXgem/Ygn1Y5sgYVPuOnTZHCt6YKNpEbgPNtrO5gNk73iVV8xTZt/AOOkyCV5dMUp82SQhIY8u5hwRUcMsnbtTcHPdE2pfsVpjxnHTGfQY0lhkiL5yZO3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKjSoI0/XF9vWhv4H2qvYi4nfoHPIbpYjonCnxUbOpk=;
 b=HlF1EIF5wGNBag3GWLhT1/LYOUuaMi8IU1sxVzwezbcAkdc3hlmhRCatZ1ZRUqBFIuASz3D1ibs4hqMwuK28YI/tKf0ODaHOXscYLEly7tChyrBcUsLgTLPCupqFdGzQ8vcby4nQ67AJ8plAeJp6l3YzrBDShLM9W8lIlmztNqk=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2807.namprd15.prod.outlook.com (2603:10b6:a03:15a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.19; Sat, 14 Mar
 2020 00:31:26 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 00:31:26 +0000
Date:   Fri, 13 Mar 2020 17:31:23 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: Sanitize the bpf_struct_ops tcp-cc name
Message-ID: <20200314003123.eohnbqdjjajb7ldl@kafai-mbp>
References: <20200313233649.654954-1-kafai@fb.com>
 <CAEf4BzZOrYkmXixTdgyisRw8JaNmApHJ=_vmDJ5ryHovzj5e0g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZOrYkmXixTdgyisRw8JaNmApHJ=_vmDJ5ryHovzj5e0g@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO2PR18CA0066.namprd18.prod.outlook.com
 (2603:10b6:104:2::34) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:ad28) by CO2PR18CA0066.namprd18.prod.outlook.com (2603:10b6:104:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Sat, 14 Mar 2020 00:31:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:ad28]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9343a5fa-2f6e-4d31-44b1-08d7c7af07d4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2807:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB28077C06649EF1EE318E01B9D5FB0@BYAPR15MB2807.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(376002)(396003)(366004)(136003)(39860400002)(199004)(5660300002)(55016002)(478600001)(86362001)(2906002)(66946007)(66476007)(66556008)(4326008)(81166006)(81156014)(8676002)(186003)(16526019)(8936002)(9686003)(53546011)(54906003)(6496006)(1076003)(316002)(52116002)(6916009)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2807;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: usrdJlISgJ1cJn+0fb15/hj59QcXjvQKS5rH02RYC97nZBovq+KTvArW/qoYHRwuM8FoZhinYBwPySxGE5IwC3OoLJME3YOv2NWshrY4Fqis0g9BaIjB8dWaVMGWSgfhwkKZsavNfvV/WerKJecG8mnxrvEz0AL/fsR4w1hY5EIaBe6bdMOyiEJjJSXIyjvRAzfCpprnSZ8y+4JOeqVFEQ3rBVL4U1vburib/6SWEuJ1uDR55smXmxgBivYTXSWUAUVK6AMHqWd8OMqevCqsgrcQpCwiEKc3BBnAWfnvyZSijDioSQlcpKhc6yBlFMlQfopaGW0YfeitVRqmy+u7rZGOpYIzmTHlgDKbdX6i9r0GbJn2br/tk2pejjBjE1RBssfp+ks/h7JFP6fXevtJpt04qtOynAO32oLK/gBV6ZFDFVxHiyZBJP8usB2VXj/I
X-MS-Exchange-AntiSpam-MessageData: fl1UrfSIfjl0gVXs7dnWh4vyfd8fdcQ3qmcagExFQYKxc89Vj195qeWv76ODJIikxE1WX9Z8oLmWntIQV52q/NXAv7gwIzZAbFGfUZunTDxvQJc5Hpm+wvxY6xqVxhkjViAcPZiYVJiKRalFbP/KxooeIx5CZoX/d+NsnvCOiW1sjs3WcA6xx1qhnUAmtTht
X-MS-Exchange-CrossTenant-Network-Message-Id: 9343a5fa-2f6e-4d31-44b1-08d7c7af07d4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 00:31:26.1899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXMgbb5+lr7QwLaT7IA4W2lUZ/PvLfYHiYUOlQSoF7m9f3ur4OCDGhjU+Qmeik8+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2807
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_12:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=820 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003140000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 05:16:55PM -0700, Andrii Nakryiko wrote:
> On Fri, Mar 13, 2020 at 4:37 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The bpf_struct_ops tcp-cc name should be sanitized in order to
> > avoid problematic chars (e.g. whitespaces).
> >
> > This patch reuses the bpf_obj_name_cpy() for accepting the same set
> > of characters in order to keep a consistent bpf programming experience.
> > A "size" param is added.  Also, the strlen is returned on success so
> > that the caller (like the bpf_tcp_ca here) can error out on empty name.
> > The existing callers of the bpf_obj_name_cpy() only need to change the
> > testing statement to "if (err < 0)".  For all these existing callers,
> > the err will be overwritten later, so no extra change is needed
> > for the new strlen return value.
> >
> > Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  include/linux/bpf.h   |  1 +
> >  kernel/bpf/syscall.c  | 24 +++++++++++++-----------
> >  net/ipv4/bpf_tcp_ca.c |  7 ++-----
> >  3 files changed, 16 insertions(+), 16 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 49b1a70e12c8..212991f6f2a5 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -160,6 +160,7 @@ static inline void copy_map_value(struct bpf_map *map, void *dst, void *src)
> >  }
> >  void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
> >                            bool lock_src);
> > +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size);
> >
> >  struct bpf_offload_dev;
> >  struct bpf_offloaded_map;
> > diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> > index 0c7fb0d4836d..d2984bf362c2 100644
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -696,14 +696,14 @@ int bpf_get_file_flag(int flags)
> >                    offsetof(union bpf_attr, CMD##_LAST_FIELD) - \
> >                    sizeof(attr->CMD##_LAST_FIELD)) != NULL
> >
> > -/* dst and src must have at least BPF_OBJ_NAME_LEN number of bytes.
> > - * Return 0 on success and < 0 on error.
> > +/* dst and src must have at least "size" number of bytes.
> > + * Return strlen on success and < 0 on error.
> >   */
> > -static int bpf_obj_name_cpy(char *dst, const char *src)
> > +int bpf_obj_name_cpy(char *dst, const char *src, unsigned int size)
> >  {
> > -       const char *end = src + BPF_OBJ_NAME_LEN;
> > +       const char *end = src + size;
> >
> > -       memset(dst, 0, BPF_OBJ_NAME_LEN);
> > +       memset(dst, 0, size);
> >         /* Copy all isalnum(), '_' and '.' chars. */
> >         while (src < end && *src) {
> >                 if (!isalnum(*src) &&
> > @@ -712,11 +712,11 @@ static int bpf_obj_name_cpy(char *dst, const char *src)
> >                 *dst++ = *src++;
> >         }
> >
> > -       /* No '\0' found in BPF_OBJ_NAME_LEN number of bytes */
> > +       /* No '\0' found in "size" number of bytes */
> >         if (src == end)
> >                 return -EINVAL;
> >
> > -       return 0;
> > +       return src - (end - size);
> 
> it's a rather convoluted way of writing (src - orig_src), maybe just
> remember original src?
Sure. I can send v2.  Thanks for the review!

> 
> Either way not a big deal:
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  }
> >
> 
> [...]
