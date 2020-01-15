Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061B513B959
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:05:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgAOGEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:04:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51050 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgAOGEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:04:30 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F619oq032411;
        Tue, 14 Jan 2020 22:04:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0MlmdaNrYJNlwnWjJ84+2k/Hs5KQgeSfL1bmuIg04vo=;
 b=L4BVXZbS7c3j52ixcSRB1CFFoVvi4oEr+2GtjPmJtoXoFT0ycflVlOmuRKuqL2m6gsax
 6HUYXezW0i/rOrWqLTCuzi+05KYPVk2TAzbNVUGyGeTHdcWA4sip3H+1eprkvzfAUPT2
 CtcSTWv0YGm6+RJOcimntl14CqxrDuEg8xw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhahpn8y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 22:04:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 22:04:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bqn2o8PHGwGWXgJj3iQDMuxHe1O1lnRHBub1SKMNHSkMXpRcRo4j5UwYIYBxtiskeBukIaQbdK6Rkl7tIu30LqnY8LV/dw8/zJImtX4NnBQwZ80g9wdRhu+6EX+6pIJ2VL7p671I2leuBozm/smJ+xFQz+pVaORAkkWw5Y66i0ts39M9uDVeB+FgIvuXuMOB3G/hXMgDjHOn5IEI+QVn6v7FZMH90UCbtJh8VnDkh0/qdwWU35iR5b5G9NjJzEKZlrb+tXqeMMK/KhKcS3FIsgiDTR9UBm476o91P6qHRIZdjoWG3WTcRAAdreZA6G/JgV6FZujlWyQeWoqmNGxQ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MlmdaNrYJNlwnWjJ84+2k/Hs5KQgeSfL1bmuIg04vo=;
 b=Bn+husdaVhwLMRKYCmYZqiE17T++sprRwXl/iUUBthQMuI5mwtzmJq/yWcckLG5INOhiJv4EsSFYNyvZVilrMP9GXCshFT06pMaVMvb1yAWXXu/mjUOjh6W4SrbOUar2UfaVhCdIccnFh2m2HLeb3c5wdX/1IBvAJnzD/vSPdN2gbhV2tQfTx8qFXm/ErHEQ29o3NzCR2Vz4FcTVnEAf0EwlrsI+qGTHuj98WWzCm5VWZKh6FJK0fOq7nmnCJKD/vsUK/gyPxG//mveSOvONfgL2wMRXrR6n/bd0CfAMYgHTbNqrB+OzXpopwcnAXkehkWAOWKToZkDayqolH4J17w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MlmdaNrYJNlwnWjJ84+2k/Hs5KQgeSfL1bmuIg04vo=;
 b=au7tANXIx4nc9IPWzW/mwAfGla0xXjd34pimcv3DVc9RQFFX/ql5auTkSDfL5kBqAmTayjbp+ssg6xTHbHre5eHhRe+JUEp2v+eh+BvtdYyGuup8/ATPH31lmRI/pJEHbIyzXRPFDqZlbKSLvaD/NjfJvrW5+1fEq3MrI3wdKxA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 06:04:10 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 06:04:10 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::55) by MWHPR14CA0029.namprd14.prod.outlook.com (2603:10b6:300:12b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 06:04:08 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Topic: [PATCH bpf-next 5/5] bpftool: Support dumping a map with
 btf_vmlinux_value_type_id
Thread-Index: AQHVy0YGNs+YezgD2kWLKS3JnpDZRafrPKQA
Date:   Wed, 15 Jan 2020 06:04:10 +0000
Message-ID: <20200115060406.ze7kwkljkytmodq7@kafai-mbp.dhcp.thefacebook.com>
References: <20200114224358.3027079-1-kafai@fb.com>
 <20200114224426.3028966-1-kafai@fb.com>
 <CAEf4BzYgvq+s09d7eKhf_dd-Goh-V3DRHWmMM+=k0=Ce=zQ2ug@mail.gmail.com>
In-Reply-To: <CAEf4BzYgvq+s09d7eKhf_dd-Goh-V3DRHWmMM+=k0=Ce=zQ2ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:300:12b::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83198c28-8e66-4e7f-b759-08d79980bcd7
x-ms-traffictypediagnostic: MN2PR15MB3581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35814CFCA269F695C1332EEBD5370@MN2PR15MB3581.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(376002)(39860400002)(396003)(136003)(189003)(199004)(4326008)(81166006)(8676002)(6666004)(86362001)(55016002)(9686003)(8936002)(1076003)(478600001)(2906002)(52116002)(6506007)(316002)(53546011)(186003)(64756008)(6916009)(16526019)(54906003)(81156014)(66476007)(71200400001)(5660300002)(66946007)(66556008)(7696005)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3581;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pe3BA+HZqI2b2dkdxc0orOpW1ecw96/lD9kYqB6HPmox5Cqw1PoxlLTEXSt2sklyxHnWlcDCs9sTyosN186nlduQuIPO7wIEmXx7k0q3+oVbxwHz8/22ue7iyGTQdn/2xLiB4nd42qAz8iiuN76td6d9sl4KW1heG2SQtXKU00dG6Q8joAzasJ4rRhb1HxdblAUNNVIHve85jlTZ5d9Ub3KbuHnq9jnBBEGiSTFMTVkf35nLeWGGHnUYBDwND9TWBRDgxRhFa7DaxMVvTMY9/fFu/rkEf41klTN68sNHLFoXe8+pxg2w6p1Vqo7CfndfvGkyrXLYa21hq8ZO7VH02vtmd/iprdtso8WcILuPswaQSFFztYbI7vGLptcse/st1M1J9mfmcdx4S/JW6KRYRRZzJxsy+eeYOnT6B4UiWlYyOft5Kc+2KtdiBwu/RDtW
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F8E95C2A57C6644AAFB01E8DA6760635@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 83198c28-8e66-4e7f-b759-08d79980bcd7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 06:04:10.1950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P/6dr13Tn9FkYqSsZJZYB5CXdZAlLFf8hZo20rYqx2YIv3iTiIuk8D7oskDSI4pH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3581
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=806 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001150048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:49:00PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 14, 2020 at 2:46 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch makes bpftool support dumping a map's value properly
> > when the map's value type is a type of the running kernel's btf.
> > (i.e. map_info.btf_vmlinux_value_type_id is set instead of
> > map_info.btf_value_type_id).  The first usecase is for the
> > BPF_MAP_TYPE_STRUCT_OPS.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  tools/bpf/bpftool/map.c | 43 +++++++++++++++++++++++++++++++----------
> >  1 file changed, 33 insertions(+), 10 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > index 4c5b15d736b6..d25f3b2355ad 100644
> > --- a/tools/bpf/bpftool/map.c
> > +++ b/tools/bpf/bpftool/map.c
> > @@ -20,6 +20,7 @@
> >  #include "btf.h"
> >  #include "json_writer.h"
> >  #include "main.h"
> > +#include "libbpf_internal.h"
> >
> >  const char * const map_type_name[] =3D {
> >         [BPF_MAP_TYPE_UNSPEC]                   =3D "unspec",
> > @@ -252,6 +253,7 @@ static int do_dump_btf(const struct btf_dumper *d,
> >                        struct bpf_map_info *map_info, void *key,
> >                        void *value)
> >  {
> > +       __u32 value_id;
> >         int ret;
> >
> >         /* start of key-value pair */
> > @@ -265,9 +267,12 @@ static int do_dump_btf(const struct btf_dumper *d,
> >                         goto err_end_obj;
> >         }
> >
> > +       value_id =3D map_info->btf_vmlinux_value_type_id ?
> > +               : map_info->btf_value_type_id;
> > +
> >         if (!map_is_per_cpu(map_info->type)) {
> >                 jsonw_name(d->jw, "value");
> > -               ret =3D btf_dumper_type(d, map_info->btf_value_type_id,=
 value);
> > +               ret =3D btf_dumper_type(d, value_id, value);
> >         } else {
> >                 unsigned int i, n, step;
> >
> > @@ -279,8 +284,7 @@ static int do_dump_btf(const struct btf_dumper *d,
> >                         jsonw_start_object(d->jw);
> >                         jsonw_int_field(d->jw, "cpu", i);
> >                         jsonw_name(d->jw, "value");
> > -                       ret =3D btf_dumper_type(d, map_info->btf_value_=
type_id,
> > -                                             value + i * step);
> > +                       ret =3D btf_dumper_type(d, value_id, value + i =
* step);
> >                         jsonw_end_object(d->jw);
> >                         if (ret)
> >                                 break;
> > @@ -932,6 +936,27 @@ static int maps_have_btf(int *fds, int nb_fds)
> >         return 1;
> >  }
> >
> > +static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
> > +{
> > +       struct btf *btf =3D NULL;
> > +
> > +       if (info->btf_vmlinux_value_type_id) {
> > +               btf =3D bpf_find_kernel_btf();
>=20
> If there are multiple maps we are dumping, it might become quite
> costly to re-read and re-parse kernel BTF all the time. Can we lazily
> load it, when required,
It is loaded lazily.

> and cache instead?
Cache it in bpftool/map.c? Sure.

>=20
> > +               if (IS_ERR(btf))
> > +                       p_err("failed to get kernel btf");
> > +       } else if (info->btf_value_type_id) {
> > +               int err;
> > +
> > +               err =3D btf__get_from_id(info->btf_id, &btf);
> > +               if (err || !btf) {
> > +                       p_err("failed to get btf");
> > +                       btf =3D err ? ERR_PTR(err) : ERR_PTR(-ESRCH);
> > +               }
> > +       }
> > +
> > +       return btf;
> > +}
> > +
> >  static int
> >  map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> >          bool show_header)
> > @@ -952,13 +977,11 @@ map_dump(int fd, struct bpf_map_info *info, json_=
writer_t *wtr,
> >         prev_key =3D NULL;
> >
> >         if (wtr) {
> > -               if (info->btf_id) {
> > -                       err =3D btf__get_from_id(info->btf_id, &btf);
> > -                       if (err || !btf) {
> > -                               err =3D err ? : -ESRCH;
> > -                               p_err("failed to get btf");
> > -                               goto exit_free;
> > -                       }
> > +               btf =3D get_map_kv_btf(info);
> > +               if (IS_ERR(btf)) {
> > +                       err =3D PTR_ERR(btf);
> > +                       btf =3D NULL;
> > +                       goto exit_free;
> >                 }
> >
> >                 if (show_header) {
> > --
> > 2.17.1
> >
