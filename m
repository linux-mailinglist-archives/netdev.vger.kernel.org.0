Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4C113B93D
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 06:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgAOFzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 00:55:02 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4652 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725962AbgAOFzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 00:55:02 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F5rFoA004450;
        Tue, 14 Jan 2020 21:54:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Ij/W9DYkJUSTSB9MLCAizmBwd0hL39uU3HtxIrjMt1E=;
 b=X7cZeXU8dyVpAP+CmGe8V4HpMFBVtAX3UUI6uo8m+59QWbbwpyTStbl1SklSe9EZ+pLO
 omTvfa86nS0OqeLexFgfa+blLIO6NgOqtcMLj5aU4myV+cg080VIL85SXvVP7GJDr7Lk
 f7H/UAs1/0gQuvBczSzanfJbhmwl/ggFqx8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhaj2dafc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 21:54:45 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 21:54:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nA6eNONXfNCeTdEJ4rFxuqx9gENrpPUVOAFYkpjddRWPzZ1/srwv8PARn5LYhoG8io3sclAAflBs79ZK4LUoStlCjV0v+l3o/8fHonGZZYuxXBwV4gYZA2hf+sHBIK/vilGnmQ3vTzKatmy5cZ8jX7PjZKwuOU0QyMw/rL/ZPmNoBWkAKTPfkWBZ2ABCvxIPkd1xNP2McN0UegqKv9366YVfTne5+f735gECiR00vUAVs4gDYFfygwRhc420FKaiwuPwTSyo8Z2SH0NqBJzgmHS3gb8kVYuvp7rcxRirYf96Yj2WRssUVwNJdQnzpT4CHA/3fClWrgh2Geb6lnYduA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij/W9DYkJUSTSB9MLCAizmBwd0hL39uU3HtxIrjMt1E=;
 b=XwZXgexdnn9WDZLV9itJ33Bo/wfQJHE47QWMPjGxbOKW6gLWvNFeGYcplAYMDLHFMyDFw5KIIOEDdghUP/X195mip9QxOJ0i2HuFmlibBvmxyIZxHFbT6tyje/m5HOwLu+eIwYY9hAYvjfJ3XYBn0yld2tnK4TeDGH5xlaEVtVjoQb7uMQWyLRctXSIRLbNcwBGkZqC1z9yuZazM7mMtlfiNyzGYAkY+SOU9p9xbrKUBJAMg/oNEInQ1HR2Kh8JD13BhMrUvOsb35KsbUA4VYsk5pV5t+D05sYEAmQ65W6mKTuotSpQr/2767kCLvvIp4ATIl639c2bL0LmBReq0Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ij/W9DYkJUSTSB9MLCAizmBwd0hL39uU3HtxIrjMt1E=;
 b=XiEMRXrKKzfzC3djfY31TYOQHiMM5kEW9yn1/QKOzaIlP3/7WcbAWinX8XnVAtIuGt4s1m4R5ZRi8H9YepI9pFprlf36QVTcKjuY4T0KUG0lyQUxwVGH2YqiCFWbO9c4BlokwVkciY6FPXJ9SqM9E+1VHExjGiLJE/2r0NTSX5I=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2848.namprd15.prod.outlook.com (20.178.252.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 05:54:11 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 05:54:11 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::55) by MWHPR1601CA0003.namprd16.prod.outlook.com (2603:10b6:300:da::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Wed, 15 Jan 2020 05:54:09 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul.chaignon@orange.com>
Subject: Re: [PATCH bpf-next 2/5] bpftool: Fix missing BTF output for json
 during map dump
Thread-Topic: [PATCH bpf-next 2/5] bpftool: Fix missing BTF output for json
 during map dump
Thread-Index: AQHVy0P5xF36K3hBaUidJRp0rwj8+KfrOdwA
Date:   Wed, 15 Jan 2020 05:54:11 +0000
Message-ID: <20200115055406.gsouajufdzussm6e@kafai-mbp.dhcp.thefacebook.com>
References: <20200114224358.3027079-1-kafai@fb.com>
 <20200114224406.3027562-1-kafai@fb.com>
 <CAEf4BzbrcKLKvgKY+nSxV22T2nHgucmB2N01bEQiXS+g7npQfw@mail.gmail.com>
In-Reply-To: <CAEf4BzbrcKLKvgKY+nSxV22T2nHgucmB2N01bEQiXS+g7npQfw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1601CA0003.namprd16.prod.outlook.com
 (2603:10b6:300:da::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2e34f9a-e3c9-4d21-6823-08d7997f57c4
x-ms-traffictypediagnostic: MN2PR15MB2848:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2848578959D3951D1D7F227AD5370@MN2PR15MB2848.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(81156014)(8676002)(81166006)(1076003)(66446008)(8936002)(16526019)(66476007)(66556008)(64756008)(54906003)(186003)(66946007)(4326008)(5660300002)(6506007)(86362001)(6666004)(6916009)(2906002)(71200400001)(478600001)(9686003)(7696005)(52116002)(55016002)(53546011)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2848;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J23I6CC0+ugn//zF1rwt3txoE11zw7ODKRh3NMUpm8HneQmYMyoBLxbLtjq7RBMPrdm27gQxCv3bzG+V+FeZGdjwvIAC7iNX8o7iMS4qx3TYSXgPuZwbCfUFHF/IKrKze+Ej+2gViJ0r6kWnivGV9GP3x6vHsxoQEZc2GVheGaixyPUavVHlmUwCK5wFmSy15QNwHNEf1pb39BrxUDiXXHSKyllI5QaXbgi0yUiWkBUdmX4wxOJrK9uDbaohGj8Bo1Kfl7/l54c3w+gk/bMtgwPNeXjK3cy5++30F4wQqR7hxH45T7LAML8bcFB26HhxkXZkwifpIgIAf+kcSlQhikXryfoGmxKPzk5e2Wat0sJ7inPQIIr6Cqqr2CNGy7mJ9XLF9Ijwk8WjK+ddIPSirzz6flu8Cgo01JhzSMRSsg67QS+mykwekf7ENLSLTLsV
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AD00A787DEF52347A8C3170DBDC06E4F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e34f9a-e3c9-4d21-6823-08d7997f57c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 05:54:11.1348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tlAVKegAd8jtXtA/L8SYLABpFuQe3UsH+0XlDzbM3cBosamdw145EBJ/zBreRK26
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2848
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 mlxlogscore=721 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:34:33PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 14, 2020 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > The btf availability check is only done for plain text output.
> > It causes the whole BTF output went missing when json_output
> > is used.
> >
> > This patch simplifies the logic a little by avoiding passing "int btf" =
to
> > map_dump().
> >
> > For plain text output, the btf_wtr is only created when the map has
> > BTF (i.e. info->btf_id !=3D 0).  The nullness of "json_writer_t *wtr"
> > in map_dump() alone can decide if dumping BTF output is needed.
> > As long as wtr is not NULL, map_dump() will print out the BTF-described
> > data whenever a map has BTF available (i.e. info->btf_id !=3D 0)
> > regardless of json or plain-text output.
> >
> > In do_dump(), the "int btf" is also renamed to "int do_plain_btf".
> >
> > Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> > Cc: Paul Chaignon <paul.chaignon@orange.com>
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> just one nit below
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
> >  tools/bpf/bpftool/map.c | 42 ++++++++++++++++++++---------------------
> >  1 file changed, 20 insertions(+), 22 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > index e00e9e19d6b7..45c1eda6512c 100644
> > --- a/tools/bpf/bpftool/map.c
> > +++ b/tools/bpf/bpftool/map.c
> > @@ -933,7 +933,7 @@ static int maps_have_btf(int *fds, int nb_fds)
> >
> >  static int
> >  map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> > -        bool enable_btf, bool show_header)
> > +        bool show_header)
> >  {
> >         void *key, *value, *prev_key;
> >         unsigned int num_elems =3D 0;
> > @@ -950,18 +950,16 @@ map_dump(int fd, struct bpf_map_info *info, json_=
writer_t *wtr,
> >
> >         prev_key =3D NULL;
> >
> > -       if (enable_btf) {
> > -               err =3D btf__get_from_id(info->btf_id, &btf);
> > -               if (err || !btf) {
> > -                       /* enable_btf is true only if we've already che=
cked
> > -                        * that all maps have BTF information.
> > -                        */
> > -                       p_err("failed to get btf");
> > -                       goto exit_free;
> > +       if (wtr) {
> > +               if (info->btf_id) {
>=20
> combine into if (wtr && info->btf_id) and reduce nestedness?
There is other logic under the same "if (wtr)".
Thus, it is better to leave it as is.
and this indentation will be gone in patch 5.

>=20
>=20
> > +                       err =3D btf__get_from_id(info->btf_id, &btf);
> > +                       if (err || !btf) {
> > +                               err =3D err ? : -ESRCH;
> > +                               p_err("failed to get btf");
> > +                               goto exit_free;
> > +                       }
>=20
> [...]
