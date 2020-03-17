Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8C188FFE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgCQVDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:03:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3480 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726549AbgCQVDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 17:03:24 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02HKsNC6029950;
        Tue, 17 Mar 2020 14:03:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=O1a69fiWL8MngMDyvcoNZHnxlHp4jBpSUs77KFkjy+w=;
 b=O3AHxJxjxAyZVUHWle9/2Qx2+R4OoRt25jF33numWHm2vaaz7On9tQkvECfctdWonUbO
 +Zkx47yZuGnwZ+HdvlffM//XTrTNcYCwOPzCs2x+K2tScVb6nbbXt0TiGUvI6J5BBYdP
 9KeG6SzoMNab7AGBiQze7iIM4YEa/onTMLc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysexx4c3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 17 Mar 2020 14:03:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 17 Mar 2020 14:03:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GsHDNSccajJElNT5o1K2rlrNeAAGs6iK4fjP2U9GPOypH4QQJgsD6CFg1sBy0NFp80z4laDsyydXaLx3+ve8uMD7n5fFevdSv0huNhnNquFhrACbnaAaHDbpExYnC0RGFBmAWtIHrLhdrX22u+poj+ONfxj3Nfx9c2U/QT7SEBWWPIaaVF1Klq12bC1ypx7yrP7suQSgh0kNrnGchvNu11Y6kcBfn05kXoBbPBfGjXXrxU3MHbnYZ+NmxYhoq3SKReRJl3MYRkcLaiy2P/Vhhqk7hJFXgdw7fml8pgr24rgR5n9tCdEieZ1xtPKYY3cU70UyKVS1R/Sz4BCJ0Uxf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1a69fiWL8MngMDyvcoNZHnxlHp4jBpSUs77KFkjy+w=;
 b=JZRSABBrxl4rm8l9m/X/jUdD7RMtjVYLaCf8T4smXDhEhgdOHEmswqvwgSKNwYUIVOAHnhW98WpO7Bz1q8PcJZ6njiM1ifIg/kZzYHh7EyUs0/Q9U+sCpk7qVXHMG/nlxcZkNufbJqmzrl6G/gsLqrri36IipTpjg73XehzkxYjySH/xAI7KkBbxSJA4GhbWxppVXsv1Bxistql3t71A2i8Nt4uU4JUEp65X839EQF1Xh12UchujFF6cqpYiJ6nzUbrtpw+aYHJ7NVCkAqYWGdQopzdHwHwtCeusRQW8RUkC57GlI24msgWmyg/XAanBsf0FAQvuXquFb5UJiFJD4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1a69fiWL8MngMDyvcoNZHnxlHp4jBpSUs77KFkjy+w=;
 b=Ughtwhub7pFwxDI5QOged5RADfIgV9D+KKnx4ci0l4hKomcQbLUv5NzEgTjVY59VySkHvDmLJui3foPk3VWGZHK/9JDrU2/oBJY3jDasQDbHuo3lYkaXj2qSP/J7PyiTVhzwi40WAIv97Bsvhdo2TYswH/DJBG9/zaXuxY4aRRs=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2408.namprd15.prod.outlook.com (2603:10b6:a02:85::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Tue, 17 Mar
 2020 21:03:09 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Tue, 17 Mar 2020
 21:03:09 +0000
Date:   Tue, 17 Mar 2020 14:03:00 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/4] bpftool: Print as a string for char array
Message-ID: <20200317210300.huj6aks7sqrotxjj@kafai-mbp>
References: <20200316005559.2952646-1-kafai@fb.com>
 <20200316005612.2953413-1-kafai@fb.com>
 <CAEf4BzZmoH=nhrWCotbTT2XS8gvoh0P2HoFym7R0dbBGPK92ug@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZmoH=nhrWCotbTT2XS8gvoh0P2HoFym7R0dbBGPK92ug@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: MWHPR02CA0002.namprd02.prod.outlook.com
 (2603:10b6:300:4b::12) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:9ce5) by MWHPR02CA0002.namprd02.prod.outlook.com (2603:10b6:300:4b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18 via Frontend Transport; Tue, 17 Mar 2020 21:03:08 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ce5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 182b8032-fbb3-4ef6-4a88-08d7cab6988c
X-MS-TrafficTypeDiagnostic: BYAPR15MB2408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB2408F4FA8C21EB800A2175A5D5F60@BYAPR15MB2408.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-Forefront-PRVS: 0345CFD558
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(55016002)(66556008)(66946007)(66476007)(316002)(9686003)(54906003)(4326008)(52116002)(53546011)(6496006)(478600001)(5660300002)(86362001)(6666004)(33716001)(186003)(6916009)(2906002)(8936002)(81166006)(81156014)(16526019)(8676002)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2408;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Nmnyu3FZsS7kPu/FI6AjLI4p1dBByCBRL+ImXzTpcyjwROj+u9DGKj2dXJPNwHmYSWrVGSVkghgRQkQ6s46x3u2dN+Nuyz2UN0WajrLsQGYOC7fhEM1McE88zw6zTdPjhcW4LW17jKCCAXjKND8T/GZf0OB28cIbPNdRaR2VX2iD4NsXl/skL1cJqjPGH0Q7wAEN+189OYsPGtByqDckD9bptNS4IMa5BUbfvxSwCP74Aip3WJ+4XKZVVDp/LsXg8vPeDYp5GhFJ9S3abaqA58y8b/ohw0Dv7bQrQN1xz6lKuutOppqWjaXqs37QbCBwYjCHDNGIhyLaJ/ujt1F12206lyOOVugJ2QyOop7/RtIyX4ZdkzHmYhyO1J5zsweUDSLkJMHccXSsDbU8+cvRgdMFQKnhMVr92P7lqJutCS672rdcj+sdmLIw7lzOwLx
X-MS-Exchange-AntiSpam-MessageData: 4CrC0RhOzV6Hr//KX0x9cQb6bmUpzOPy85TgANRqxyhe6hG9Msa3UXzhSWyt5Lc0XVUmOPVQS/ASwm3g5nyXaIyICRO8w7tAJ7V1gTQJ8gfPck2EAfwH6uzkrTq2T8ApCM0AQFpfy1ko9+o1Y4azSbl31W4Hm90WIBaNO+nsBGOF0+Q3TqnqTIF+SMGqzJnv
X-MS-Exchange-CrossTenant-Network-Message-Id: 182b8032-fbb3-4ef6-4a88-08d7cab6988c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2020 21:03:08.9783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2zhE49vnjoC+4j4/fDEhcoNz9EvNhll5L6fCUvVL6s0YFWg0lEZ5fIKy5iPH/m2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-17_09:2020-03-17,2020-03-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0
 spamscore=0 malwarescore=0 impostorscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170079
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 01:08:01PM -0700, Andrii Nakryiko wrote:
> On Sun, Mar 15, 2020 at 5:57 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > A char[] is currently printed as an integer array.
> > This patch will print it as a string when
> > 1) The array element type is an one byte int
> > 2) The array element type has a BTF_INT_CHAR encoding or
> >    the array element type's name is "char"
> > 3) All characters is between (0x1f, 0x7f) and it is terminated
> >    by a null character.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/bpf/bpftool/btf_dumper.c | 41 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> > index 57bd6c0fafc9..1d2d8d2cedea 100644
> > --- a/tools/bpf/bpftool/btf_dumper.c
> > +++ b/tools/bpf/bpftool/btf_dumper.c
> > @@ -77,6 +77,42 @@ static void btf_dumper_enum(const struct btf_dumper *d,
> >         jsonw_int(d->jw, value);
> >  }
> >
> > +static bool is_str_array(const struct btf *btf, const struct btf_array *arr,
> > +                        const char *s)
> > +{
> > +       const struct btf_type *elem_type;
> > +       const char *end_s;
> > +
> > +       if (!arr->nelems)
> > +               return false;
> > +
> > +       elem_type = btf__type_by_id(btf, arr->type);
> > +       /* Not skipping typedef.  typedef to char does not count as
> > +        * a string now.
> > +        */
> > +       while (elem_type && btf_is_mod(elem_type))
> > +               elem_type = btf__type_by_id(btf, elem_type->type);
> > +
> > +       if (!elem_type || !btf_is_int(elem_type) || elem_type->size != 1)
> > +               return false;
> > +
> > +       if (btf_int_encoding(elem_type) != BTF_INT_CHAR &&
> > +           strcmp("char", btf__name_by_offset(btf, elem_type->name_off)))
> > +               return false;
> > +
> > +       end_s = s + arr->nelems;
> > +       while (s < end_s) {
> > +               if (!*s)
> > +                       return true;
> > +               if (*s <= 0x1f || *s >= 0x7f)
> > +                       return false;
> > +               s++;
> > +       }
> > +
> > +       /* '\0' is not found */
> > +       return false;
> > +}
> > +
> >  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> >                             const void *data)
> >  {
> > @@ -86,6 +122,11 @@ static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> >         int ret = 0;
> >         __u32 i;
> >
> > +       if (is_str_array(d->btf, arr, data)) {
> > +               jsonw_string(d->jw, data);
> > +               return 0;
> > +       }
> > +
> 
> Looks good, but curious how the string that contains ' or " will be
> output in json? Will it be escaped properly or will result in
> malformed JSON?
They will be escaped.
