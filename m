Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D2A38BAFA
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 02:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235416AbhEUAr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 20:47:29 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44112 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235372AbhEUAr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 20:47:28 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 14L0hV2q000386;
        Thu, 20 May 2021 17:45:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=WPKkj4VhM6z3k5W77IHcPn0n1l3v1xapBzHOdxkKrCs=;
 b=fJTZ6HRAH4mFHIpAyleJV32Bzv5zbNfU6bjcTYOEyv4vRORXf/Jppo0qLqYsl8xPHaam
 k/+G0Fmg7+/nCbkphfs6WrYcwrE99tmKyWxY6a1qp4gZhb4Adeu2sRf8F/iajNImt/YN
 /tplB7tAsKWSGs2BX4ERZbNZ9+fIH+ATe7A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 38p0nvrmeu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 May 2021 17:45:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 17:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uc2Y4wgpqVtl8thqDFluIMrhFMUVO3cVtOtWvS9o4+vBQLlpcIPWQ9Et56OgsjktH0eLVi3x+Am8tUlG4JGLbtUtd6nRto0nCpzewaVUFpEAazNduSym2J/UmLKFbmCYLEAChbBfIAK+ou4EizHrbbAuGRRfm6PhD4DUFgfH3zKwqxi7QWu4G8YxK0wagI1IwNriGV9tqppKGplmnytE42demmvUYzY7s6cG34wp6odhYHrVs7jQZI4ZQtreoux5Fkt5pSQ1RDQ9zg/WG3VnnLgCZcYJj6SwEt+47shnehmNhPi7tpj2LVDZTLGs8OmUaE8VbTklwLRpIS4MPiuqZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPKkj4VhM6z3k5W77IHcPn0n1l3v1xapBzHOdxkKrCs=;
 b=H/qEgb+C/BFf8+k1byBsR0JA77wc99v5Pfxc5Q8ubBXJPBf2XJ7haeUxWZZqyk9jD4hrnLKvvs3mz6XaGT0dbIbH+avNTNLBDR2uGtml+FNVEdFbShyjF5cCKC3yxG5KXJmAlr9jirlKaDZUoQl+x5ymG/4JJi20TcsPicioBd+gsW/jLaVtb8t+c2Xde2pvooRWjgk05ubEo3KOKUz9k74LR1wX+n/CgJm9NQ9zkDBZdQFNZ2TmP5+SuO8ejjc5PQ0LKseBCoVXtIOM71trQwTVXDCOlkg5+6AV+G6ZmSaLjguRDwYOxPuALKWr/VF3Wca2vJqccOmBj1scmNmqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BN8PR15MB2995.namprd15.prod.outlook.com (2603:10b6:408:8a::16)
 by BN6PR15MB1348.namprd15.prod.outlook.com (2603:10b6:404:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 00:35:41 +0000
Received: from BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::8980:107b:cbfb:55f4]) by BN8PR15MB2995.namprd15.prod.outlook.com
 ([fe80::8980:107b:cbfb:55f4%4]) with mapi id 15.20.4129.034; Fri, 21 May 2021
 00:35:40 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
Subject: Re: [RFC v2 00/23] io_uring BPF requests
Thread-Topic: [RFC v2 00/23] io_uring BPF requests
Thread-Index: AQHXTLk0PY0K4B6IqEqB44IqdJi08qrtGQAA
Date:   Fri, 21 May 2021 00:35:40 +0000
Message-ID: <0A3E3601-76CC-4196-8246-CCAEB8C8AED3@fb.com>
References: <cover.1621424513.git.asml.silence@gmail.com>
In-Reply-To: <cover.1621424513.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.80.0.2.43)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:fa93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bbc3533-0221-4c28-1d65-08d91bf05ca1
x-ms-traffictypediagnostic: BN6PR15MB1348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR15MB1348808ECE8C5999C2712D0AB3299@BN6PR15MB1348.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cyc/rOjuoV3B/AKz0HMdS+u1FzMg4r/W8/2hUBa9OJObYzVMR7uF44SUnwlwahMFPMCHo1mFDC5Z+IjHZLUJA4S+cs0Q74inOuzWUnXZRXkuKvJ6KjqvtSHB76cSNYxyzHn6+qunxfjmEBRvgWNUn75EQOAg0RwqIzCSiWg2V8U29rCGyrJWvHZ5XZ+E06uve/Sbnq1+IsPIL8n79j4JWs/OJP7EQL4P6kti0mhjxwaL35GJJhS7kz7d7tksn91Im11Zy2ei6G8pd/uWe2fQK86fIn9+Yqgx2klNfZRdwBMnOzgoPijN8So+kGLvS+ZsqhhJrlAhvqBiQMyOYosSSFZD/pZkaP+t/xeKpv6NcG+nAey//+Js3GOvVkJtKNdGe8RXkiA5qAAYqdVtGNiXrKRDuJTow/+n2Rx2J/Jk0hTAeoJSx3pSWoWR0UeGLsjKLUOEmBGlPLjXK5dGfBgXv8xzjDNL9uawydadAsAp0bNjQaGTY2iHvHK+VKN+4jSsAlUnM/iwmetzrEE+PPWx5gT6AmUrs4IKIZ7sB9blxvsFC7fPVhnAjMDiMPgIdBHEZrmRsd6dZubxjUWPCjeBXND3W6iJZWxFpLEKKe5qTUycKjCILI3mdzYl+C/LzcdQQhQ5i6Dh/1MVSj4R8GIfpFEugTZxRFeewKkdHh4/tJU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR15MB2995.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39850400004)(366004)(396003)(83380400001)(86362001)(38100700002)(122000001)(71200400001)(33656002)(36756003)(8676002)(8936002)(4326008)(66446008)(6486002)(186003)(2616005)(7416002)(53546011)(2906002)(5660300002)(66476007)(64756008)(6512007)(54906003)(316002)(66556008)(66946007)(91956017)(6506007)(478600001)(76116006)(6916009)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1RIkdPL9hF1lJdvAwaNUXYdKgbtSju/16ub/QzT7DefxBDHTU6LaTKcslbEc?=
 =?us-ascii?Q?D/00jYBx7EaJXBsq4CA+0of8EOf1YhAwDCvVIBEIId5ebQG0CF/LmR7XaBXI?=
 =?us-ascii?Q?vmIYgnmMKgSmCPrBvSsyxwWk+7n+idnWgm3ewp4fpMTHgE9KJCszuom5wzeo?=
 =?us-ascii?Q?dhtZZH/yoPx+v9r6uULI4AO2Mv+FU5jV+kvbqK3veGWN6o5AWgqRF+lvhIw0?=
 =?us-ascii?Q?qhTWEcAmpF0k6yeqjFfdxvvHTxZB9O/FsgsTNtiEptDVY5AmFWF8X6XL1oS2?=
 =?us-ascii?Q?87i+X/aARkX+FdK4QUdYckUHx/JoyqjRZ7Hg7L+cY0KbeXWKvpVob6MmzCI9?=
 =?us-ascii?Q?Vev2PZ1q2MGAL63Fp3m6d3rKcz0IH2IA4bJ517D4bS3w03HWLPzP/TeXmzSY?=
 =?us-ascii?Q?vkAQjUge8ZoSlo3BFB0onvZaunlxKMNHo40Y73tr8TermizN/r9fWZdsxshn?=
 =?us-ascii?Q?H20f1qN5i9V7pcbKQBQXmHUAtSnUaVKFJLznbvo5w2fTiPUllWoC9YPTB0m6?=
 =?us-ascii?Q?7WOFjkgNmbeZGr/7tJksUbH3GuEX6tJEFow7iQnp3BVfYaENtcKEzW0eCY05?=
 =?us-ascii?Q?ImL1RY4woJZ4dmk1xD5LOaQJBCRCH0DRDrWx9wprlATa+DIn4zH1TzfvPMlQ?=
 =?us-ascii?Q?Ggom+LSqIgbGf9V7S8R/fnAZmHfMQD4rC5nwZ04vmLz91SwPzLAfN0eSy68i?=
 =?us-ascii?Q?W0van4GrY19HFvEhhz437vMkN4y2JXKKjhqSKPjyiOZaQFHuUmx8HW6weR9M?=
 =?us-ascii?Q?L1+ZLVP2syvkx2EGj9QnZ360c3kHdyHf6xlts8AUsofm+oeAbCVe8SmK7f3v?=
 =?us-ascii?Q?QnJcR8EW7RdUD8pBUYsUNMOHZmDi81wgFTazYcZNHsagsKymRlOOJLXzdNHe?=
 =?us-ascii?Q?JG+OkQUYxamu48v9/PTbwEJ6ZqJet3Evtu9gcQ89y4Fu18Naf5ankabgKZFq?=
 =?us-ascii?Q?E4xbUGedXMzIcFioC9lMgvDH7rRlWIvthN80hVx4ILzpxEC4xOyXFBpUbsaJ?=
 =?us-ascii?Q?S5sZsS5e7A1UIR6w2AiHVdTyazl2OwOvucVA5aI1Ux+3YmESDZT5Sp3SRRy6?=
 =?us-ascii?Q?drUKxmpw6F3SkphEVRi86rL4UPjJ29qVlcHPK6IIJ8AKzVH8h0xM1o+C3r0n?=
 =?us-ascii?Q?ReNF7SmGlCCTkoWoqvzkLb4lcQbt7bg0dQbpo8T6xnsqvEEnMPlhmxRGj1gO?=
 =?us-ascii?Q?3thmEjZ7bA2KXr2e+upZ5h6swAzxgr3vvr5KyQYti5Rnyn9j6aRFrLjoOkrz?=
 =?us-ascii?Q?IvJeCrREC3QMOP2hgjbpfuFX9CNNTPAVQcuggwk+0SXPjaX6UPvN7J/46CBZ?=
 =?us-ascii?Q?TFXnolPuC9B2ymG7E2lywJRXyzt8ODC1O6pOoHxLSRjHt3Of/4ntCdb3bSJx?=
 =?us-ascii?Q?RZCrZX4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71F1770653941A43B98C3FA8B1085457@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR15MB2995.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbc3533-0221-4c28-1d65-08d91bf05ca1
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2021 00:35:40.4882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8BnZjXaZLkXaKu9s88O+ydNacoRo8pcswiCj9r0UIdDDQgf5/4wcnnCPrQHJBa1UKOvFA3xum3BJC1kFPNr2MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1348
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: mX-fTWnmRSS__5p38I9KlH6dZ10aw8RB
X-Proofpoint-GUID: mX-fTWnmRSS__5p38I9KlH6dZ10aw8RB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-20_07:2021-05-20,2021-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 phishscore=0 spamscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On May 19, 2021, at 7:13 AM, Pavel Begunkov <asml.silence@gmail.com> wrot=
e:
>=20
> The main problem solved is feeding completion information of other
> requests in a form of CQEs back into BPF. I decided to wire up support
> for multiple completion queues (aka CQs) and give BPF programs access to
> them, so leaving userspace in control over synchronisation that should
> be much more flexible that the link-based approach.
>=20
> For instance, there can be a separate CQ for each BPF program, so no
> extra sync is needed, and communication can be done by submitting a
> request targeting a neighboring CQ or submitting a CQE there directly
> (see test3 below). CQ is choosen by sqe->cq_idx, so everyone can
> cross-fire if willing.
>=20

[...]

>  bpf: add IOURING program type
>  io_uring: implement bpf prog registration
>  io_uring: add support for bpf requests
>  io_uring: enable BPF to submit SQEs
>  io_uring: enable bpf to submit CQEs
>  io_uring: enable bpf to reap CQEs
>  libbpf: support io_uring
>  io_uring: pass user_data to bpf executor
>  bpf: Add bpf_copy_to_user() helper
>  io_uring: wire bpf copy to user
>  io_uring: don't wait on CQ exclusively
>  io_uring: enable bpf reqs to wait for CQs

Besides the a few comments, these BPF related patches look sane to me.=20
Please consider add some selftests (tools/testing/selftests/bpf).=20

Thanks,
Song=20

