Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF1029F9BC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 01:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgJ3AdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 20:33:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14872 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725372AbgJ3AdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 20:33:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09U0UvQ6014241;
        Thu, 29 Oct 2020 17:33:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2yl2wnNgwspLRaGSKNSgRrSwRfPNk8AJDvzbGQY47rI=;
 b=mM3lhcP3rQsxAkHkldXjlv9UBfcFea3XZIQpK3jqdHdA6riuYJlOkMIHDOfQ/tXXDGFM
 yhU0VJU3OEBQ4olBuFqkFaDOYaluo6ZfhvAkQY7KJ47gByNj0Yu/ETVZ/kBTw3RSSZB2
 Oh+hdDMp81DMSNA4HSEHsiMdV+/hAGerQmM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34f0qc47tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 17:33:07 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 17:33:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emLRRtFhCC04GAIyHogVWUI3SHVq2O5chNiQqhVDZ/NaudgP+mFi/lOR/jz22xc/jLDk67J2SQfpT29FCBB9BSYOJdoxSNlpK8Hwerips6GL1UHBXhawE5vlyKIWwphsBf2yuzANhUmmV3y9w3hP33mYrQyhMQsRyRalhwwpp7RYRh4+tZmDwRUSoQPe8B4RDRPiFWZXto08NFkAvrXUpejzyJcrdC6RT4q0+H4OlMAQqgeRu83H/ZaGGLXhRzlJRvXaedQN0O1/n9u/w2NEv6yoFK0dfI2f7zVzuDGlDXDEXjoAaoTGX4kHaC/i/Bl1NNdGTC+ISx3xMKXevLP03w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yl2wnNgwspLRaGSKNSgRrSwRfPNk8AJDvzbGQY47rI=;
 b=ccc/71/zjKr/okGmHoRPuQi/3uDiTwm1Zd3SkAtBRnW6XHFlRU1972uebhPA9Zevc3+kVmgqDYvI9Y02ugigLJbyMW2PRhFWFTc44o1OhiqxdtkVeRJ9KZs4RkXAyDk7S8oOIesBvihnklSgcWhsMnPYfvs6rpmvgAfFr+l582vSEvJHxFRgqmlA5QEMR2WvTsZxEAbcQ9dcrDFRglMxvGkvEP/BGbg4qHtKrh15LZB3tQPFY9welJ0gzXjWOG9z6i75cTDZmwyVu/M9LS1MFpGOEJxnm5o8oyk3DV1vU3BbavV3SXKg7ZGxV8D6aiTeo6SG5m1JWmKVkxNv+UPBGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yl2wnNgwspLRaGSKNSgRrSwRfPNk8AJDvzbGQY47rI=;
 b=YMTceB2h1EgifSftdY61rIkL6zvff/5th5CpjEwdiGd0SZfV1GDHjxQ7NmjFChW9ee1ysewc6/1Ut1BN6v8FOdYsZDyBr9hvHnvrTJ/9yaNfYxIXbkJpzUoDAQI/xQMO0+NacMsT9xCi038CeWav7XEIQQhA0fc0BxW7RkNyA6I=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3365.namprd15.prod.outlook.com (2603:10b6:a03:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 00:33:04 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 00:33:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/11] libbpf: split BTF support
Thread-Topic: [PATCH bpf-next 00/11] libbpf: split BTF support
Thread-Index: AQHWrY63qsgg2/wxykCIQcx/7B6lQKmvTVaA
Date:   Fri, 30 Oct 2020 00:33:04 +0000
Message-ID: <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
In-Reply-To: <20201029005902.1706310-1-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 784dab01-66e5-494f-a5ac-08d87c6b5d51
x-ms-traffictypediagnostic: BYAPR15MB3365:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB336521C38AD69E5BBD43A5A6B3150@BYAPR15MB3365.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hQlC98LGp0VxmcWSr1rE4InwMb5mC91upcGGHpVsMCsAuuyy+3RsXvdxZlbQ7u+tjfYgxJqDbS0bY0LCgHlB/m9ppkUjXiK5ClWjK1u8T96u9xB3wMzG3ZQr782ae40omBbpPieyG+9PvTe0F8t08EJX6ODNKWj3TqClX3eubRVc99+9VA2Evu9EceScFd0BNa0w5G68hK4Ys6t4mFR+hVj5/kAb8qhrLK/7dPf6LRsVcqYYE3sH3oaoQvZp8WCZjmG8ELFhFhHUjvVwnFl12ilFbv28TQcKo1AohwdssNSs4wZFQw41TSLI/QRH2YskyapOtCr++Gu65pfHc1VEggm6Ac4fLoklw1102k+vJLZ0sC/zwH8cpUB4BLEp2By
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(39860400002)(136003)(54906003)(5660300002)(66446008)(86362001)(316002)(478600001)(66476007)(6486002)(8676002)(2906002)(6512007)(8936002)(53546011)(64756008)(36756003)(66556008)(33656002)(6916009)(91956017)(4326008)(71200400001)(186003)(66946007)(76116006)(2616005)(6506007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: T5nfII+w7V5JeUjRS2khTilaRjCOFnmyEd659I9nmskpv7w0QaZ1PWPcal6OcbJUa3HW4KCo+BkZmjrmkHQrrUgv7KZE9ukX8SpgL8pjKPS22UdaWFY4J/QhPMreGPBXYFwYiisIzyrJWq5G/Zo2klPSVQXDZlbBiWPuJoh1SnK+bd1YAAB0Fg7H3DUAbtz2JHZMzFqPf3G73RVrcvinvXiDomvt86z+inTrYrT95jahkVrTQwDeCq/EsDpyqUp/1lUI+YzkSrj0expY+RthXfD56DAXFLngdsXdz9Nw9uH7RGU/zVbhmTYEzjdWvHZcFgz/0NDrJ6QophcatyOWCri84dTIrwTAe5ZNKTUaAsIaLfyWfZnlG5pEMocFJXVkrEE5Ft3Caed4hXFxNywgTviIADA2lELl76un6qEXvGXJ41k7zIhlY6/w/iKIp5WXmYGqzoAjTT7mkYdOlMRZgWKZdMtf+F+HncSGn5E9jEtyreNT6H/CcH99mmY6znBybyfP7L4cqdN75IzwynRebQoLnOT0ffLHAN4/lbVOTwuQNK9Kx+dM1VO6+i1rmkR5vgLzG47+xUUSySAlBNdAqQ133fFbekOEd0PzTSUulB+YiwowBm5mlyzySPMKiabcdOHmfwIP5992yzQEMbiVlCw4Grma3kx6jgjt2pNbU+RVGva0ecGBcK1K9+vpHmkB
Content-Type: text/plain; charset="us-ascii"
Content-ID: <82B5DE0C39D2AA48878445DCD0367DBA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 784dab01-66e5-494f-a5ac-08d87c6b5d51
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 00:33:04.1152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X16+Wr3H66/tTwFca38bwn3WKgpoaAK77u0Me3eEJALbK0zi2xDYg/9tOjOklpHW9pH8GhWkaaeGUyO7RBUC9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3365
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 clxscore=1015 lowpriorityscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010300001
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>=20
> This patch set adds support for generating and deduplicating split BTF. T=
his
> is an enhancement to the BTF, which allows to designate one BTF as the "b=
ase
> BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.g.=
,
> kernel module BTF), which are building upon and extending base BTF with e=
xtra
> types and strings.
>=20
> Once loaded, split BTF appears as a single unified BTF superset of base B=
TF,
> with continuous and transparent numbering scheme. This allows all the exi=
sting
> users of BTF to work correctly and stay agnostic to the base/split BTFs
> composition.  The only difference is in how to instantiate split BTF: it
> requires base BTF to be alread instantiated and passed to btf__new_xxx_sp=
lit()
> or btf__parse_xxx_split() "constructors" explicitly.
>=20
> This split approach is necessary if we are to have a reasonably-sized ker=
nel
> module BTFs. By deduping each kernel module's BTF individually, resulting
> module BTFs contain copies of a lot of kernel types that are already pres=
ent
> in vmlinux BTF. Even those single copies result in a big BTF size bloat. =
On my
> kernel configuration with 700 modules built, non-split BTF approach resul=
ts in
> 115MBs of BTFs across all modules. With split BTF deduplication approach,
> total size is down to 5.2MBs total, which is on part with vmlinux BTF (at
> around 4MBs). This seems reasonable and practical. As to why we'd need ke=
rnel
> module BTFs, that should be pretty obvious to anyone using BPF at this po=
int,
> as it allows all the BTF-powered features to be used with kernel modules:
> tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.

Some high level questions. Do we plan to use split BTF for in-tree modules
(those built together with the kernel) or out-of-tree modules (those built=
=20
separately)? If it is for in-tree modules, is it possible to build split BT=
F
into vmlinux BTF?=20

Thanks,
Song

[...]=
