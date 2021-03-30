Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA4334F4DD
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 01:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbhC3XIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 19:08:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1932 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233161AbhC3XHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 19:07:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12UMmdPL019914;
        Tue, 30 Mar 2021 16:07:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+jh77BZf2oIBEfSfat9BLkDJ6NXyih7rUmJPZ4y0JCE=;
 b=eD2fa095gm16zDhTqjG5j6EvCSl+ZZtYBMtX8R7XSlsBRav5otetXvTj1r6l721RBtvT
 subc0Ap5TIAOmIgkiEHt3Xqoizx9+i1OBRTVi3VTU/oFeStzwTex/b+vMnWQxoA19ps1
 RCh4la3fZ0snkF+n3odoo1vR8wmyWTmb4XI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 37mabmgyjc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Mar 2021 16:07:12 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 16:07:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I59ER+EsKOKZdCQ8bfkQwyBz+HXfh4JkGiV7R+kz/ShbWmEkG0TYumWw9dWJ+p74T2bqpKLmbpxg9+bmLv2jMkzrYSyPCD0LAPj2zNU4IBu6yZ5eTWSFGihRef78Cabap7HFdTCaS5eUlK59Rhnsu6lFCN3nkedf+pz8ZNOvcnn01C9KlW5FHNL2P1nGwmKh/pf8X4rQcxx5vmTx8XABrpXfGwqYDGGosKLL1/5iV9X5/TtJcPf+t6/zLqKgsyj5EZntmTY/txCHC913aBayo5OCZCokFRcbvo5igTWAk4VXo1DM0mP2DCBVllY/dC48dkTfDhksFjqU8ghb9DoNGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+jh77BZf2oIBEfSfat9BLkDJ6NXyih7rUmJPZ4y0JCE=;
 b=AAyA1mC6PXyUXtD3QpkJLK0z0N+VG3LnOt0QSBW2W56VrfwhuA3EuOpuSULYbjGWRuggXQ6rDOaNT3hNEdVcq5Oc6HAf15P6heh7kw94kCrmZh/fQWeRd+AuX4hS4xr+dvuhNLIGingG+VlqQw1q3jO4/vbtok5om+vIqAkTYtp3Yt6WhgOBb2bLp3ZkeM1yER7Z5cG1Twfw9BpxwV5dIIK0DwXpvyqzO1ihyKFDBJdkAfcxT3LbuRPBUvNphi9deQDemve+yMqLE40gWmeL7CDTiuXg7CCqxQPE7ot5Z9KZYxhz2zQA9kW4lcPWi+XO/f6aLX5g0clQVIA2540Qzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4679.namprd15.prod.outlook.com (2603:10b6:a03:37c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 30 Mar
 2021 23:07:08 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 23:07:08 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pedro Tammela <pctammela@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
Thread-Topic: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
Thread-Index: AQHXJbeswZNiOuENdU+13TQgNOpZ46qdJ2CA
Date:   Tue, 30 Mar 2021 23:07:08 +0000
Message-ID: <08CB9917-449C-4657-A771-18C3E10208BB@fb.com>
References: <20210330223748.399563-1-pctammela@mojatatu.com>
In-Reply-To: <20210330223748.399563-1-pctammela@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8dbe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af7377b4-7324-4b6d-a5d0-08d8f3d08b3b
x-ms-traffictypediagnostic: SJ0PR15MB4679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR15MB4679520CE374237219145BD4B37D9@SJ0PR15MB4679.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lA0Bk11TItpc573lczdZCSbr3r96ZTP5nyXhzF7F5k9gXNmAV+kD+Ewn4RYoqMueUSUD6DS/USyKiO6PiUlj16GGqZs8uInyY3opP5L8tIhSquQPCxElTkZo2De+WzuFiLb8zLkOMLd3Hn6coJgPHW07VwmrqFw+IrXs14ODKUXW/gTL/XxGP76HOmSiIhDOd+alQ1nLMVX8GLUadBh/9XLYz1xroTDgOq7QPuH5D0L1on9V/GVuWE7VmFDPiytDPV5u6cE8yBGVdEyhXkhctE0j+Riuy5hAdBwPWMiKHL3lQEilbEQciGPJaQVAiacNnJBt0FS5H4SAZ8bDPzCjR1NYx97q2x97Vvz4QgVQAolWuxGuJWkR1liSuB8YM365bmBgBLfZ5NEUWmy6bgdnN0KxzwCxZhPUNb8sYFC3CDfJVNcDdnCa5vnw2R1OWgt2IlEO+SVWZPieodgjxdfM+Qgd4nT9gUucKrsFsAv1ZZfXPZMq/P/PBoZqWy5qkydFVymDaanSwYRPp82tA6Zx5Gs2SNiNOyflhHWhzQbEDDU4PKtRQrP+l4daS2PBTUUgw9+F8YrTIvuTAyJB2NmLmb5CD6YSgBLzBDzJbd9fgemwTZORtaSQn6SaxyThOK95T7UrCTyhn9uwcQatVoLsAc3/9OZYS4zhh2Ryq/NIFXJJvwMtlEgkqD1vLpRQGus4
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(136003)(366004)(346002)(186003)(36756003)(38100700001)(2906002)(64756008)(6916009)(6512007)(66446008)(4326008)(478600001)(5660300002)(33656002)(316002)(8936002)(7416002)(8676002)(6486002)(54906003)(558084003)(66556008)(66476007)(76116006)(71200400001)(2616005)(66946007)(53546011)(91956017)(86362001)(6506007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?QKCMUW3mEohadpRtfkACRmO4J0NOgug27PdALoS9PTsE+WbW35YyjzS4QVNf?=
 =?us-ascii?Q?QfiQvSimF1VhjsYi0tVN7GwxXU4w9d9+ki59jI4ry3jRELITlnNK47FyPWwh?=
 =?us-ascii?Q?8/v8OEM56j/XesadMm4vpOJmv2tyVYdzp32EesCUGTBWY+Nzkt44VDos2cey?=
 =?us-ascii?Q?5pbHtu44NzBAMTYZnysOONPpzRi8foE7pyXsWbU5Lh4okrKq7QyUA8K1tgQH?=
 =?us-ascii?Q?C6rkrz92qGf4mD3sBl/8tnfYHiiARyFQYmWv1HJmd3cPbWEF+cza9V0PzlK/?=
 =?us-ascii?Q?mZNdcebXllYfx3MeEXSXaVSx0KoAAyrM5708klST+xxB/I0LAJ6zGz6676p0?=
 =?us-ascii?Q?2LJZmgjLPvIO+AfDkP1hSUhBoAdPIDOb84NqMwu2tOGKVEkUQrE8l9+nCGVi?=
 =?us-ascii?Q?H7JWCuiZK7MoSf1nqIp2DF9hXexBbNjuFe1yv+qOuSpCde1Y36g6ebTGpS0Q?=
 =?us-ascii?Q?vQeYoRSiOrO2ebZLJcgPYYNWs6Bp3BXftk5uhirZ5CzLh2gARwskorEVXvv5?=
 =?us-ascii?Q?EVwsZ30MP2U7bgtPz4Rv4Y14cVmTXIcMIF24gnEH8iiYcOhOshOzLvxLG5c4?=
 =?us-ascii?Q?6SC/UZ1ePtvBk920PwkauJKLj0ThW3OMiEI2ebwT/x4R5nGVdFeWEm/+VS9e?=
 =?us-ascii?Q?sh6kVAPQjtgVTVBeH0Z8gHII8OObSb2jIJVVy2sNjqEQoGWej6I/L7ZcLIRQ?=
 =?us-ascii?Q?EWOyh8GNZxSJVOpJp1XVOQk8VBfXBYKy0sh6qUq4Taqp9QY+7Dqrgu9pLVMq?=
 =?us-ascii?Q?40MpfYoWoYiYpN4lexkigErVFe2JckF/3iunhn2/6rQVdKt14Mb9mcA6cqBA?=
 =?us-ascii?Q?9DmnfWkDmf+BvXqaBx09Of62p3Ro4coyofWJDw6AsicTke8J8Y0XBDbl5bFV?=
 =?us-ascii?Q?xY2j1nIXuE2n3gfWk7e6cDJZbfqt7F7AUVrcO05+o4Gz/Ytds64I0p7h/CuM?=
 =?us-ascii?Q?aqaCF6bSRY2v/Hee81FKbZGYHqLNDh1EsHIT/wn8c2sVB+x1AZhG9J9S1ml5?=
 =?us-ascii?Q?4VbJakJ3SrptSFTHqhtk2W4BzYQw04gQRRszz7W0DvMBEx7A9Yy0S7/O5Lgk?=
 =?us-ascii?Q?15b7lggpePQ0GriLnShrph2HoxVPYHAeR8gJYJiZyxhCQABdiDLXipkLS9BG?=
 =?us-ascii?Q?+B33K7FdQXZi91q2RQNH4vNjscqNs+b9xT/JdZaFYpoE6vL2hkJfAyg+78FE?=
 =?us-ascii?Q?/5UFoRVJ+clr5FpoEKE1IsTwplUpr+l99YxcIcmhv6OuB6FBGd5B53HPJNLx?=
 =?us-ascii?Q?ROc5yQ4Yrps4LuXo7dLCxlDTu9B1oAwwBX5Wx7cCV1WV+NbNgjqNXQNeSoS+?=
 =?us-ascii?Q?VLL8GeWTlmilXknvaYFI8j9k9pHuIJyvsOjcgvuech4Rfwp91kxvcA1ANhxK?=
 =?us-ascii?Q?/QcS78Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7EB160B593911148826602F411D32213@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af7377b4-7324-4b6d-a5d0-08d8f3d08b3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 23:07:08.5815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQ1MN5pXQJSK/l/Wwgl6xiVL9EOoYZpznpfdbUTbkrDRw1f8K3ZMfr8OoiwlDdzPuF5biOZYzkmqQ++ye7hyIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4679
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: h4BmRtvqxV7Sp_pooOCwgbbsnxDdOFeL
X-Proofpoint-ORIG-GUID: h4BmRtvqxV7Sp_pooOCwgbbsnxDdOFeL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-30_13:2021-03-30,2021-03-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 mlxlogscore=830 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103300000 definitions=main-2103300167
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2021, at 3:37 PM, Pedro Tammela <pctammela@gmail.com> wrote:
>=20
> The current code only checks flags in 'bpf_ringbuf_output()'.
>=20
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Acked-by: Song Liu <songliubraving@fb.com>

