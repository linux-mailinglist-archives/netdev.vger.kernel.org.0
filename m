Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF99313B942
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 06:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgAOF42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 00:56:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17234 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgAOF42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 00:56:28 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00F5rGg5004499;
        Tue, 14 Jan 2020 21:56:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=zJ0oOBf9uLQbHKC4/0it0OjJL7n+Y079cwhFFUnlZ/U=;
 b=dusOYn/VueZsO9gPa+B7fSqJ2nHM2tVwt7+s/bCiJfq/s+k1n0OJYeoG1DJMNpU+rzzf
 dM+yzur7yCNUBFnwDVwclF7j/clBj7EcANtwcoZiraSgAE0Afuse/wWH3vPJujxkCMSK
 he0DeLWoYkwFIbo7/sSiNnp9DNbzO5oLCVc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhaj2damd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 21:56:14 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 21:56:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnTmG7Bx5I4rMM2clNCY4PUnAx4ir7aOQn8S7NUXMJFKTD8UKpNL9F2zZfQrPtM0Nzzm8o67aZVfqETTrL7opFf3wBep52zy8g3m183gzjjQz/8kfqf2HWzPZ6HBlI899Ut2wZSV9xebBcKF06ARLzQdVkUfEWuF9Juh0lo1i8fNuwO8SiQRoeh00PoZ3BRZajYIde3S5OTK/SMKjRTRrPgybpSws+UNz/ILypFE3Q8DD3IN8P7NrUiG9NSBXhL5PRqvwZ5POc1rF5rW4V4dNPF02unImjwpXApIxWh5LRZ17qLz6tZglB4B9n56oph1/7WpdECFNz+hJIzsAWGSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ0oOBf9uLQbHKC4/0it0OjJL7n+Y079cwhFFUnlZ/U=;
 b=cj8esaiZfguzBDPtYetJAfLXBhIr0riea1W7gysPm55Nv03swwzfCUFiW+t1HW/IoZWDQJb6DU/e5HOpsWX6mIVAkBirkWntzGhyva+teWR5e/HMY7kxOyeJ6MSJl+EIkWx7Vr8aIS2PpBlQqbYJunHqUmiDfjzq28ZIPNkMhKyF0Ein62Z8eLmbFI7dzlgu5Gufsa5119atIYHpMx1SYrGgsg2w6t2gmeLWtbzsQz3DCAvNWnIOclTeqv2U1Sxr3udsVL17iitAJh0N/Dw1Sz/6KTVx0Tdr56zWQcbWlabVBHY4Jumt/I6OTDvBM02xXiarDOchy6KJkasoMxW5pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJ0oOBf9uLQbHKC4/0it0OjJL7n+Y079cwhFFUnlZ/U=;
 b=hwBVFgdMuWOhhB7wUoiNGFW7L/ML7wUV98vXMFzQMxGMO7QQzu0P3ZCTMkIpdjpve8t9S3ojkl6n1u61wa+Ke7CcZ6iA7E6Jxze0r6F2vOBBLTS1aQdUY4jSXqJX9G3ZvE/d+V9TcDdOycXvks6wTwfXASe7Dv8Njruh6GTSh74=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2848.namprd15.prod.outlook.com (20.178.252.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Wed, 15 Jan 2020 05:56:12 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.017; Wed, 15 Jan 2020
 05:56:12 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::55) by MWHPR11CA0021.namprd11.prod.outlook.com (2603:10b6:301:1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Wed, 15 Jan 2020 05:56:10 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Kernel Team" <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] libbpf: Expose bpf_find_kernel_btf to
 libbpf_internal.h
Thread-Topic: [PATCH bpf-next 3/5] libbpf: Expose bpf_find_kernel_btf to
 libbpf_internal.h
Thread-Index: AQHVy0VKApD4lsQFrEyp1aVQzbhgSafrOmqA
Date:   Wed, 15 Jan 2020 05:56:12 +0000
Message-ID: <20200115055607.x54orahytzq5siuk@kafai-mbp.dhcp.thefacebook.com>
References: <20200114224358.3027079-1-kafai@fb.com>
 <20200114224412.3028054-1-kafai@fb.com>
 <CAEf4BzYOjgCbbr_zofZcGMiJj=fpH5JMBbL=jZqD5KXzYjmahA@mail.gmail.com>
In-Reply-To: <CAEf4BzYOjgCbbr_zofZcGMiJj=fpH5JMBbL=jZqD5KXzYjmahA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0021.namprd11.prod.outlook.com
 (2603:10b6:301:1::31) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff826070-436e-46e0-47eb-08d7997fa023
x-ms-traffictypediagnostic: MN2PR15MB2848:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB28485CADBA562995EFEFAB2BD5370@MN2PR15MB2848.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(81156014)(8676002)(81166006)(1076003)(66446008)(8936002)(16526019)(66476007)(66556008)(64756008)(54906003)(186003)(66946007)(4326008)(5660300002)(6506007)(86362001)(6916009)(2906002)(71200400001)(478600001)(9686003)(7696005)(52116002)(55016002)(53546011)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2848;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vm8dOvrFmll0m1BKF3WQas0Qp7kH3P0PvHb83dMnOwWH3Ommhn240WTz0KK43c74twiBYkGyf+Y9kxz8juefQDy5vetDciSjvPVWYj9ap2eZDkDGBchawoz0JE0YomX5+ki19BrJ8zPBu2DsWpsNSRB0+NX3w5gsIOzSwqErj+6SOUC73sL2FKoxzs9yxqNv0vWeNNSVPEvUacVZEfbNysi0r0XFIQWj5WpM7VrmevJrHQ1jDpo2eZd9LypdgI2oQTD1x6T+tRGpwQqUGclK4OIniHsNREHW4EkS7AvOJ2R4tpCDWxD3Pu8ob0Lwj9b6MfdFt+4MuyEySuQ6qSE4kYJOfArZXGbGJpq+633xCs4OpQaO/xyb1sut6dSQuB4YHkdITxBFcrg8Aw7w8oggbob+E1TvN4pLClBVfEM6Bkv/YRGGpO3/S3t6ZgMW3rnb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <43E01CBE45AC8A4882563133C90206EA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff826070-436e-46e0-47eb-08d7997fa023
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 05:56:12.6265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nSVtrCypge0m6+ZA/Xmjqx3GO0x/GlNIpQIkYWl2yvYLyPewUvgghKPkU/D/Rli2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2848
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 phishscore=0 clxscore=1015
 mlxlogscore=504 priorityscore=1501 lowpriorityscore=0 spamscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001150047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 05:43:58PM -0800, Andrii Nakryiko wrote:
> On Tue, Jan 14, 2020 at 2:44 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This patch exposes bpf_find_kernel_btf() to libbpf_internal.h.
> > It will be used in 'bpftool map dump' in a following patch
> > to dump a map with btf_vmlinux_value_type_id set.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> This function comes up not a first time, I guess it makes sense to
> finally make it a public API. We should also try to minimize number of
> internal APIs used by bpftool.
>=20
> So if no one objects to expose it, should we call it a bit more
> precisely and according to libbpf naming guidelines:
> libbpf_load_kernel_btf? libbpf_find_kernel_btf is acceptable, but it
> does more than just finding, thus "load". It should also probably live
> in btf.c+btf.h? WDYT?
Sure, I will add it as LIBBPF_API in btf.h

>=20
>=20
> >  tools/lib/bpf/libbpf.c          | 3 +--
> >  tools/lib/bpf/libbpf_internal.h | 1 +
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
>=20
> [...]
