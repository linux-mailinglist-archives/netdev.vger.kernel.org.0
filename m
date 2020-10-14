Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920FE28E3DA
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 18:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730146AbgJNQBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 12:01:31 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8924 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgJNQB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 12:01:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09EFs3Bm029740;
        Wed, 14 Oct 2020 09:01:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-id : mime-version
 : content-type : content-transfer-encoding; s=facebook;
 bh=WV/fdhazu52+SCfv8fN3vTfzZ1p7wxtq2vmZmJ32q3s=;
 b=TBUUkjaaS7heKEbrRkmOVjo7P2ygpK9Qf+5Fl1qYARXdTiVKb9klV9dPhSG77G63d85o
 Essc+/UFm1mmCqrQlFMgtWxnncwPp/xUpUWhyPj10X5y5KPKTmaPqTEUCx4QCBawNK7q
 MYZrkH07h3q9HERY6+cfjw4QVCyzs5Zc0cc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 345p2cuxme-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 14 Oct 2020 09:01:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 14 Oct 2020 09:01:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RfGahOIqd2GzF53zQ8zjQOHmXft1ObieZO5w9+O+0HUUC/109c5HdyC8CmxxKjU+AIYMEeeUAijA5gEdqEwfBh3VtNp5J5qbxdUaUVVedSMPgvvE3r/1Wzp47tl5a87Ay7nw1EESOllumYWEesQ/vEYXTt6O0ZLWg+1/A2sL+RjDctw7WzdwD9sLoIVgrTBblE7VG0twmNtc9noLxWkvJc1Qe1rBgHGr358YnePlT7+a3SQInaAQBiiwOBwDl8BTP6Yoo4Frp+GxO/L1qhzXp1BNTksmd0ybSl2pkOMSgGimbLg0m0KaiFhGgiPvef2IthT1UZIm8si5167m2Pclhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV/fdhazu52+SCfv8fN3vTfzZ1p7wxtq2vmZmJ32q3s=;
 b=Z3Waf/0ELwpxD5xBPtfhmBfd0p7cdEZ62GOVO1Av/y88wrYeTtx0CEGiYFHrDk96K95f4hf7o/o/SP+OWBnMhtcT9qYm7fkDb3Ba7ONDkr6ntwt8oHGbUMVP60+XjP269JdeDRSKedR7ahNTDqliyVY144NrWzpu9XofEPrQmtw+gBqXlMviJu4F1WeDXyO9WELfpQ10pKpOUWaZr3q0VM3NphdCjp7FiiFDZSAFZ2IthdYBETB+v4TUaDC146IftSAkpzVykb7T0smBPBmcss7T9+Ju3Ydpxi14iirPHg6aArj5bjFCgQlaK4PGH3Geq7CYbjOs24OpruJo49yTmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WV/fdhazu52+SCfv8fN3vTfzZ1p7wxtq2vmZmJ32q3s=;
 b=IIIEb4FAfMRm6B1XpLreaj3VZ/PXWbGxCWMW7ABkleiVSWQwapvQQw8r/8dCIq24vkwCcmVXOGHiORAXq/+WO5RBJS8Q8m7Ig481agZM1mXBc4duNc9UC941NIetUMTJfEMng000cUBToeyqSo12IXv52/tupAkpJEPays81bgs=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3000.namprd15.prod.outlook.com (2603:10b6:a03:b1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Wed, 14 Oct
 2020 16:01:07 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::5448:b1c1:eb05:b08a%7]) with mapi id 15.20.3455.031; Wed, 14 Oct 2020
 16:01:07 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix compilation error in
 progs/profiler.inc.h
Thread-Index: AQHWoeOm3LXpZuI85EKOjjpbainxQ6mXQqmA
Date:   Wed, 14 Oct 2020 16:01:06 +0000
Message-ID: <96F50C6A-1A46-441D-AAEE-A67D7D5A903D@fb.com>
References: <20201014043638.3770558-1-songliubraving@fb.com>
In-Reply-To: <20201014043638.3770558-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:b7c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa5be46e-5cfe-4d19-d7f7-08d8705a5c4e
x-ms-traffictypediagnostic: BYAPR15MB3000:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3000CB6ADBAE3C98A076A32CB3050@BYAPR15MB3000.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AKZ0iuznbkD6wtPM7g4KsVTCSmh4PpfaPWVsIDG8LpENTGXR14JL8Gmf2Wyd7rL67m1FqYfcT6n3XcjmKPL+FkttbHFGuhRRXrBD5JrGi3122AuTBwOqLk+bR4XWWSyVV+XzsEbW3iDBGRI9+g+Osf/fk6RUmtC0NJkheU79S2tzTnzmlB09W/8ItrmUuvKtr2jh8Tb7lelGwVtYG8KlCpVG1+OVASgdKYoXxuet/OF9Ljj/xfJAU4Y36ZdtR1c9nUY1bxRdKgl1Gtz1QeH0bS25FvQ8kSdqNEKd2r9FkJinoQryh88UGagGCJsAUVQmATqqPLawpQ2uryu+/3mTvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(366004)(346002)(136003)(5660300002)(66556008)(478600001)(66476007)(8936002)(64756008)(8676002)(66946007)(91956017)(76116006)(66446008)(83380400001)(2616005)(53546011)(54906003)(86362001)(186003)(316002)(4326008)(6486002)(2906002)(6506007)(6512007)(110136005)(33656002)(36756003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vdoEUI5/zF77o/KJ9MRwJJqHBlsQhW+Rrk6hCH07ebe6YCsOMb2K+ezMb2w7RjJFr0iU2BVaPudL6qYpS/0iOgpSKDheat296xS++RNo3nQrozSVpbBIsYjy6zf8WLfQj2o/JC4xCwkcEtZqzxm178VDWnpq6FwzhogWhenAzj7lwl2JnejQlt2Oei9QH/07z9ICc/ZZYrWFHugyMzpN1NDXjxBbzwkpp4fJXkrNTQZDgcEanwniyHbC+ypBslhToKKY4zzRgzDtHgpQWgWL/uLlvqcaIW6XZYx622rEkAvPc1md4Ww+apTl70F7lpbk8QdHq+n/JUfPO8c3z/azwnFYUSnXWAbrsOG8M7JSp8XqaXW6wECl+Bwmv+AZ60M+lnfFx4upjTz2kk6y+XZRAcYwe36apWZ4jB5H80y701fmqS52e4XumKPxoV3hXVi06yGynzBQtnqm0CTC0HkDsDlPrqKuWH3L7Qj121EMeM82pHCx49s1HcQS2T7AqhiwqbOFbPAYQTThsPhjvtINNEEEw1XCwp3jqbkmpTcoRbQi4kTbep7m6Als47zIHSPnRVvxhJpUfCmk+V0HVDdgPl6vp5Wi37GPqTza2JXoJBa1GJJToxUYWv1nj8shLO3l6HUcs5H72m/jG2+fR8x4KgizDQEmHVlvycIlKpsfVT4=
Content-ID: <4AF0199DA67F7942A0458D9DE6FFD0FE@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5be46e-5cfe-4d19-d7f7-08d8705a5c4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2020 16:01:06.8555
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OXE2NCmAgSWONveWIltSVZVJAbmID8hM6VO5lfDROvo3cXdhknFKKdiCVY569VxW6CFTHJ2ElXq8MyHXIvHdww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3000
X-OriginatorOrg: fb.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-14_09:2020-10-14,2020-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1011 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 phishscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010140114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 13, 2020, at 9:36 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Fix the following error when compiling selftests/bpf
>=20
> progs/profiler.inc.h:246:5: error: redefinition of 'pids_cgrp_id' as diff=
erent kind of symbol
>=20
> pids_cgrp_id is used in cgroup code, and included in vmlinux.h. Fix the
> error by renaming pids_cgrp_id as pids_cgroup_id.
>=20
> Fixes: 03d4d13fab3f ("selftests/bpf: Add profiler test")
> Signed-off-by: Song Liu <songliubraving@fb.com>

I forgot to mention

Reported-by: Jiri Olsa <jolsa@kernel.org>

> ---
> tools/testing/selftests/bpf/progs/profiler.inc.h | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/progs/profiler.inc.h b/tools/tes=
ting/selftests/bpf/progs/profiler.inc.h
> index 00578311a4233..b554c1e40b9fb 100644
> --- a/tools/testing/selftests/bpf/progs/profiler.inc.h
> +++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
> @@ -243,7 +243,7 @@ static ino_t get_inode_from_kernfs(struct kernfs_node=
* node)
> 	}
> }
>=20
> -int pids_cgrp_id =3D 1;
> +int pids_cgroup_id =3D 1;
>=20
> static INLINE void* populate_cgroup_info(struct cgroup_data_t* cgroup_dat=
a,
> 					 struct task_struct* task,
> @@ -262,7 +262,7 @@ static INLINE void* populate_cgroup_info(struct cgrou=
p_data_t* cgroup_data,
> 				BPF_CORE_READ(task, cgroups, subsys[i]);
> 			if (subsys !=3D NULL) {
> 				int subsys_id =3D BPF_CORE_READ(subsys, ss, id);
> -				if (subsys_id =3D=3D pids_cgrp_id) {
> +				if (subsys_id =3D=3D pids_cgroup_id) {
> 					proc_kernfs =3D BPF_CORE_READ(subsys, cgroup, kn);
> 					root_kernfs =3D BPF_CORE_READ(subsys, ss, root, kf_root, kn);
> 					break;
> --=20
> 2.24.1
>=20

