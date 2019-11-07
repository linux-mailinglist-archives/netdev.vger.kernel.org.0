Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C04FF35B3
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730319AbfKGR3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:29:34 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728847AbfKGR3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:29:34 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA7HRsWl030554;
        Thu, 7 Nov 2019 09:29:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BGnCVVsQuHj0/FscC5r/DPxHi3s0ojkDU8AnkELhpv8=;
 b=NHb+crM2nA33AILVzkHhIzXzQm6XLxzJCQ7okzCX0ifs4yeLnKpHSK9XxyHOe0ktev6/
 6+1EENYG2zWS2G8GVMzP8v5J6A5f2rASSDAn1IYPJj2I5fGwtlQipr6ZOgdcrMAL6mvq
 RhVPORxlqcdVU5rCbqqQYHoewco23f3jV6I= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2w41vcecxw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 09:29:18 -0800
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:29:17 -0800
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:29:17 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 09:29:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kF9TlERTm7bC4T8wPq9YbcKE5URUTO71HW6NJRXbCmeVhx9tXAwDseH3eoifTZ37cG9ObNwIc33rtsRcYTMZGE94l0RwTS6xP32mWU66qZ2ibTAtEep3kIsQRDxgAMPdMeGUyJUllHtlNiep9pulVCZGKeo9ePkYvm1YqJxGUi3MqbhSWHLh8Wd0LR5QZWKwZKJJyMnafn6N7UbM8sNaX8R4HzyBOkJUp+bdgbFKwDExOmcDPGFIuEIFHxtxY+QHeNw0GUjRv7Fzf5TzeUO3MCD5IdhplO+M9NI/l7endymK5ISiT+Miy3k/MaGA5hK5uPFbsOYwDQ0aLeSCYl3WKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGnCVVsQuHj0/FscC5r/DPxHi3s0ojkDU8AnkELhpv8=;
 b=mbuMPAi5oGYPly4D+WTxftmDa3fER8OnbTkNS3wt0NDHw/oZghzdpBEtXr9BcnOSkQ85DBN1AVF893+rPP35DgBh2/89Eaxr2zGsOPTk21aoIPUBnXTint5xlEd1hlNZQR4+R30yUocOZ/oy7vSAkF3pNwELcz9CxvlgK09HNjPahLc7yf7ITCwByovG50SpDmxAd7wCINPF71fuprhLWvGh551hQCfVkoxgBSrRNSFeyruwujRW5imttCj1B1w5zXItxCOt5/u3Zye9Qz08piU3CJEP1fotVb3d+TqIF+TUX92r6bJr/PFPEkohGpHY9bLdLHX0NZaVkopv2Gkr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGnCVVsQuHj0/FscC5r/DPxHi3s0ojkDU8AnkELhpv8=;
 b=cBB9iR3hLzsbO7ycx2n/HHP4DONHTi/D3Vt7ErIHr3KgvpGOckHiv/tAFNOXJfF41IZRCG57CjIG0ykuHe3Ns7hY8/vAPxf4Tq5ONfhvK9FgNL7HPBvr293tZtgyIJ77l5DvMRDwNT9od5IDUccvFsyUinxEhzebTiW5Lep0ewA=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2991.namprd15.prod.outlook.com (20.178.252.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 17:29:14 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::ec0d:4e55:4da9:904c%7]) with mapi id 15.20.2408.028; Thu, 7 Nov 2019
 17:29:14 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 3/3] bpf: Add cb access in kfree_skb test
Thread-Topic: [PATCH v3 bpf-next 3/3] bpf: Add cb access in kfree_skb test
Thread-Index: AQHVlRYdBKKa3FASQ0Wprwu+we4bYKd/94+A
Date:   Thu, 7 Nov 2019 17:29:14 +0000
Message-ID: <20191107172911.7sg3xpezln6hoq3n@kafai-mbp>
References: <20191107014639.384014-1-kafai@fb.com>
 <20191107014645.384662-1-kafai@fb.com>
 <CAEf4BzY6aDYKUGv2D-xy2bQKuH6zeMGvqA5p74xjcUXKq5KDZA@mail.gmail.com>
In-Reply-To: <CAEf4BzY6aDYKUGv2D-xy2bQKuH6zeMGvqA5p74xjcUXKq5KDZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0046.namprd02.prod.outlook.com
 (2603:10b6:301:73::23) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f7b8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e3575e1-4164-4a5d-ea1a-08d763a8024d
x-ms-traffictypediagnostic: MN2PR15MB2991:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB2991AEDF7CF79B813B799634D5780@MN2PR15MB2991.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(346002)(376002)(396003)(136003)(39860400002)(199004)(189003)(6246003)(229853002)(5660300002)(86362001)(64756008)(53546011)(76176011)(486006)(52116002)(81166006)(81156014)(305945005)(6512007)(386003)(66946007)(7736002)(66556008)(2906002)(66446008)(33716001)(476003)(66476007)(46003)(6506007)(8936002)(11346002)(54906003)(71200400001)(316002)(14444005)(256004)(8676002)(99286004)(446003)(9686003)(102836004)(4326008)(14454004)(1076003)(71190400001)(478600001)(25786009)(6116002)(6486002)(6436002)(186003)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2991;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pYDn0onOpM2dgeJgApqSbqppEY1p6zFAdYfoft8bpF/rEKYIYcf569DWqmpmp6dFKk1f7GDl8GtnmNpKWjgqGeEeC+5PXExlFAd04Z+reXsmuWQl44YYPow8HmzUxyWEVqXc6XKef/XHkVOofBqZoLP3688jWSnyZuc3orvZL7SzisNoj6yMsaOEgyUF9VYg9wP8uH4+zK+mrIR+HnU7QNbCvb+CJFpuUUTK2pKgWDDyQjUyRPM/ySE2pCAGAx2OyMxGsaFQMOr43Kc0fQcKkCxS/zr3xQ0sq/e+0EEZhdEqKKhraagSPE6FW6JMO4Pzq4mm6RyrEFKi9bLO5ld/at9niy2rdobyhz7hooZv48CPGFLDnhkwGYJlhOsfiG/zjhPoxD/wPXJDrChg1Tifm6vDGKxZiX3nt+dfAzbymyxDweWU9FXqus5x8M2z7151
Content-Type: text/plain; charset="us-ascii"
Content-ID: <46809490EE79F54DB017D6E367B762B8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e3575e1-4164-4a5d-ea1a-08d763a8024d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:29:14.2709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZct8zYiYq0c8yNJ1Dz8KTR4I+SAOpN/5D+1wspBU7FRW+HINntKiF1b1gIwEo8M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2991
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911070163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 06, 2019 at 06:50:02PM -0800, Andrii Nakryiko wrote:
> On Wed, Nov 6, 2019 at 5:47 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > Access the skb->cb[] in the kfree_skb test.
> >
> > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > ---
>=20
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>=20
> >  .../selftests/bpf/prog_tests/kfree_skb.c      | 54 +++++++++++++++----
> >  tools/testing/selftests/bpf/progs/kfree_skb.c | 25 +++++++--
> >  2 files changed, 63 insertions(+), 16 deletions(-)
> >
>=20
> [...]
>=20
> >
> > +       meta.ifindex =3D _(dev->ifindex);
I hit this when I put "meta.ifindex =3D dev->ifindex;" inside
__builtin_preserve_access_index:
libbpf: prog 'tp_btf/kfree_skb': relo #0: no matching targets found for [13=
] meta + 0:0
libbpf: prog 'tp_btf/kfree_skb': relo #0: failed to relocate: -3
libbpf: failed to perform CO-RE relocations: -3

My blind guess was it thought meta has to be relocated too.  Hence, I moved=
 it
out such that I can put __builtin_preserve_access_index only to "dev->ifind=
ex".

> > +       meta.cb8_0 =3D cb8[8];
> > +       meta.cb32_0 =3D cb32[2];
These two do not need relo.

>=20
> Have you tried doing it inside __builtin_preserve_access_index region?
> Does it fail because of extra allocations against meta?
>=20
> > +
> >         bpf_probe_read_kernel(&pkt_type, sizeof(pkt_type), _(&skb->__pk=
t_type_offset));
> >         pkt_type &=3D 7;
> >
>=20
> [...]
