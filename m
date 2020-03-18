Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7A0318A13A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 18:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCRRKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 13:10:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43894 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726776AbgCRRKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 13:10:48 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02IGhvuG002134;
        Wed, 18 Mar 2020 10:10:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=lsikV0D5kGE0JaInRCNF3SJwUl60wilp6eQ7umi5DQk=;
 b=SUZBnPlMpB1Y3KUsDbN3QNzZ7gXTyZKV/O/PKXbA9wMmX/mrega5E8Pv4Zu6L2+LJWPW
 jeeEEfAOws6Z+4vvwIQ6kJk4lQ8X8tt7FlaginWde92ILvRxv9ZQYPDmOrCBusPbbpQ1
 Tqbw8rUxAknYeH8b3a7OevIUh7GXSCCSKro= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yu9avkmsb-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Mar 2020 10:10:33 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 18 Mar 2020 10:10:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZWHx91Wu8DS12riOhUCkEN3Womc8f/cV9gFAgo5q2diOZm/1aSTHVh7rwSxiXSnse5M9ZKnNJx0xdZKgoDvAwlSOqC+an+9MiybavO91MFF3Ng/4cnN6owAsRmEvytL8XL1XIflO9NgUmtBY/NcyTkq/h9HkuIhAqKHNuk5R/ufM6GzzAiiIKzGKISHAR3mW/vAeM7QUTfNTdjwjBElViJ7LGDhKX1G4SS4JyQUC1f36O9hlIKhY+SqNI8wVrMY8ZXMpeePtdupdEDUp09S/RmYomNTv1zpQy9Pw6v+lHYTyTpAvi3zSWH/kFROB7xwEesNCAgk2aH7freBg5rB3NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsikV0D5kGE0JaInRCNF3SJwUl60wilp6eQ7umi5DQk=;
 b=BGN3MLXXp7LrTY4wInD/vs+tOsuxAE7paS/M24IsEnTLG/L+QwGeoMgtI/Al+u+Xb1qa4ofrlnwks3McsgULj1Osm8tRxX0IqkwQ8Rdeqtjgq3YLWSdc6GpEwHcr9ErJqw58sP0wfknGtL2ssiIM03fteioXTRD3ZNzjIA2tfmNswfT6ysR7q8irD56Tf0+o9PBRi7rx1a/csHPYu5pi7KI2ww4OFNiHhVuc8mCTHy55v9d/EUWw3Zvv4cQE2klISQaMj+Tnwk3ZZ5KvvhJi0a+u+hIRjbYPHNHuszZUpyS/mcDjGHfywc3DiaqUOlhMBzsE/4Rw68n5k9yVqsPeLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lsikV0D5kGE0JaInRCNF3SJwUl60wilp6eQ7umi5DQk=;
 b=Wrt3bIVcMHY70w5BqvC1I1cBK33V+R7TDYgDgBN1viUJmx2V5OETodVyYTa9iWByR5Lh+xHUBd8uk4bNYxZlkvH3ApvZzyDATFfhmXkik9pySIjSgVVtMlycWdxzLYOBt7qb34ouCm91wjitSyo7J2e1V1S2ellCuQOCBGm2kKE=
Received: from BYAPR15MB2278.namprd15.prod.outlook.com (2603:10b6:a02:8e::17)
 by BYAPR15MB2549.namprd15.prod.outlook.com (2603:10b6:a03:15c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15; Wed, 18 Mar
 2020 17:10:31 +0000
Received: from BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47]) by BYAPR15MB2278.namprd15.prod.outlook.com
 ([fe80::4d5a:6517:802b:5f47%4]) with mapi id 15.20.2814.021; Wed, 18 Mar 2020
 17:10:31 +0000
Date:   Wed, 18 Mar 2020 10:10:28 -0700
From:   Martin KaFai Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 1/4] bpftool: Print the enum's name instead
 of value
Message-ID: <20200318171028.yttynowwqrfbmie2@kafai-mbp>
References: <20200318031431.1256036-1-kafai@fb.com>
 <20200318031437.1256423-1-kafai@fb.com>
 <CAEf4BzbghUkbAjQcDAUGGoTpT-RszbHRYegbFsDLSjRqGvcVDA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbghUkbAjQcDAUGGoTpT-RszbHRYegbFsDLSjRqGvcVDA@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-ClientProxiedBy: CO1PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:101:1f::30) To BYAPR15MB2278.namprd15.prod.outlook.com
 (2603:10b6:a02:8e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp (2620:10d:c090:400::5:9ce5) by CO1PR15CA0062.namprd15.prod.outlook.com (2603:10b6:101:1f::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21 via Frontend Transport; Wed, 18 Mar 2020 17:10:30 +0000
X-Originating-IP: [2620:10d:c090:400::5:9ce5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f788980c-2a4d-4861-61fd-08d7cb5f4340
X-MS-TrafficTypeDiagnostic: BYAPR15MB2549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25498242AA9D06648AC516CBD5F70@BYAPR15MB2549.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 03468CBA43
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(396003)(136003)(376002)(199004)(8936002)(8676002)(81156014)(54906003)(81166006)(66946007)(52116002)(6496006)(66556008)(86362001)(66476007)(4326008)(53546011)(55016002)(6916009)(2906002)(33716001)(9686003)(1076003)(316002)(478600001)(5660300002)(186003)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2549;H:BYAPR15MB2278.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Krpr4AkijERLxBrIQ9IXOCEDQKAGqECqX5EarS2Mr//mLe0OZxWBOTlu4DJVLdoNtDXgLerSBK//kt8zr5PAO9N5kWPDu2QoZ/F2qVucaFvKQFblNZwLHQFaiH+NX5cHQxlYYLAzgdZhVHg6ow2qfK8yjkrPaN/zH33RFIibHLXDRB9lLsAoGuJ3AFRMQUSGcjF/ZIKzlU/186LAhK2Ge1xJmUlS2I8qjKiqVsafa7xSmww4H21Fk3AOt1QBJYHaNpPhZMNMv8/1tufPbUnplkQLtxrZfZYYP6nXwIIFlFn5VQKn3NYzjiPsoEWImqFz9bE+zn3cFSF/XhDF5smjEpeQjlnE/2f9fJIRj1nzfRUY13FwWwLh9+ilFaOXtyaCi210jBbZfVm8cb/2r03hKEy9ymdwh2eXcvHVGBW0hXgAUOa4E3KymnsdJivKHvLD
X-MS-Exchange-AntiSpam-MessageData: wC0BHFHMgLfyGbq54s+JNwoCJtFUiNMGE+4C64KR9N8x40CUrvrOifErbu4yitlNMESGwm3SyoTHdUCfxJTri6tTZm8jY0hnZ3ISy8xErWju88q9WniS0VDugJhX9I1pSfyNfcLpBhTTrBX463xiiaSfykIg56BDz4l2KF3at0n+dT+s5PQZ+tQliF+g3E8O
X-MS-Exchange-CrossTenant-Network-Message-Id: f788980c-2a4d-4861-61fd-08d7cb5f4340
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2020 17:10:30.9737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UIns93V0t76EAQ5xMdEijQitzG5qSEZ1tVQSuUQ8qTnfl50+35FwZ7s1oqIvPwE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2549
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-18_07:2020-03-18,2020-03-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 clxscore=1015 adultscore=0
 suspectscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003180076
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 11:09:24PM -0700, Andrii Nakryiko wrote:
> On Tue, Mar 17, 2020 at 8:15 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch prints the enum's name if there is one found in
> > the array of btf_enum.
> >
> > The commit 9eea98497951 ("bpf: fix BTF verification of enums")
> > has details about an enum could have any power-of-2 size (up to 8 bytes).
> > This patch also takes this chance to accommodate these non 4 byte
> > enums.
> >
> > Acked-by: Quentin Monnet <quentin@isovalent.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/bpf/bpftool/btf_dumper.c | 39 +++++++++++++++++++++++++++++++---
> >  1 file changed, 36 insertions(+), 3 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> > index 01cc52b834fa..079f9171b1a3 100644
> > --- a/tools/bpf/bpftool/btf_dumper.c
> > +++ b/tools/bpf/bpftool/btf_dumper.c
> > @@ -43,9 +43,42 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
> >         return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
> >  }
> >
> > -static void btf_dumper_enum(const void *data, json_writer_t *jw)
> > +static void btf_dumper_enum(const struct btf_dumper *d,
> > +                           const struct btf_type *t,
> > +                           const void *data)
> >  {
> > -       jsonw_printf(jw, "%d", *(int *)data);
> > +       const struct btf_enum *enums = btf_enum(t);
> > +       __s64 value;
> > +       __u16 i;
> > +
> > +       switch (t->size) {
> > +       case 8:
> > +               value = *(__s64 *)data;
> > +               break;
> > +       case 4:
> > +               value = *(__s32 *)data;
> > +               break;
> > +       case 2:
> > +               value = *(__s16 *)data;
> > +               break;
> > +       case 1:
> > +               value = *(__s8 *)data;
> > +               break;
> > +       default:
> > +               jsonw_string(d->jw, "<invalid_enum_size>");
> 
> Why not return error and let it propagate, similar to how
> btf_dumper_array() can return an error? BTF is malformed if this
> happened, so there is no point in continuing dumping, it's most
> probably going to be a garbage.
I can send v4 to return -EINVAL here.

However, the caller of btf_dump*() is pretty loose on checking it.
It won't be difficult to find other existing codes that will
continue on btf_type's related error cases.  I also don't
think fixing all these error checking/returning is the
right answer here

The proper place to check malformed BTF is in btf__new().
Check it once there like how the kernel does.
[ btw, the data and btf here are obtained from the kernel
  which has verified it ].

> 
> > +               return;
> > +       }
> > +
> > +       for (i = 0; i < btf_vlen(t); i++) {
> > +               if (value == enums[i].val) {
> > +                       jsonw_string(d->jw,
> > +                                    btf__name_by_offset(d->btf,
> > +                                                        enums[i].name_off));
> 
> nit: local variable will make it cleaner
I prefer to keep it as is.  There are many other uses like this.

> 
> > +                       return;
> > +               }
> > +       }
> > +
> > +       jsonw_int(d->jw, value);
> >  }
> >
> >  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> > @@ -366,7 +399,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
> >         case BTF_KIND_ARRAY:
> >                 return btf_dumper_array(d, type_id, data);
> >         case BTF_KIND_ENUM:
> > -               btf_dumper_enum(data, d->jw);
> > +               btf_dumper_enum(d, t, data);
> >                 return 0;
> >         case BTF_KIND_PTR:
> >                 btf_dumper_ptr(data, d->jw, d->is_plain_text);
> > --
> > 2.17.1
> >
