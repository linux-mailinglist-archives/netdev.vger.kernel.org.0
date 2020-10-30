Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8853B29FDF4
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 07:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgJ3Gpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 02:45:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34074 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgJ3Gpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 02:45:44 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09U6dO3k007370;
        Thu, 29 Oct 2020 23:45:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=TRgM3dDpCz8PqB5++jSLNe0WyvgsPs2tmPIw3PjB4I8=;
 b=pOnYCp72IYS4jT+Xtusie1UHt51EFiS3vos92tqTRxLFyZm4pN2+ZJDATxHKTUhIg1pU
 QGWnJqXgnTlhxMAmPAUmVFklElG20lo8glMDU7Y4VG7IBRfEETVVjWW88k/cM2nKFWPx
 JbdoL5hFfyUv/LdzttQ5jFQ4G7wRGhPl460= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34fuvbwqqd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 29 Oct 2020 23:45:29 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 29 Oct 2020 23:45:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XmHeqrQgLpeK/4YpOYaHRqMPfq83jjSAoCZ7didc99oHDZ9+Jpkf0SlByCrxkIkSDmQX4ltj0eoeNvRQkEF5Wx8/wnceuz1FqzosN0LBdzKsq6djVUZgfOgnO5sCwvs16ZmgMkf7jOmjHtEaQeVt4dZg94ymJ4U471w/XCtQfk6W+PIScHKOhvlDJxSaOM7qydv4xFQ9QCy967ku5q5NrG3KK7zmL6etCR3FtdJLeIspk+XaFNH5oGWVuhhNG4ahmtijKJoz7RZ8qJs6voSneln6F7N2+n/XV2GsiFM/jE+41cQdaTQF6Q/Vo0JwrV6m0LyK91tWk/2t4GZ7ncSYuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRgM3dDpCz8PqB5++jSLNe0WyvgsPs2tmPIw3PjB4I8=;
 b=SFYU56hHTOdfWj4wTJ0fIEkEKNlyri9kcSiudrDMpClaIujxcVDJ5GFH/I3w5U1hH4kUJx9KaL8jkKbXvUYgUyCJznqg55aIvagmQCLj/rcMr2kNsrop8Wcu5azxFBn6GS0R3yzyiI5wBad7yvTaSXDIy6+RK1CRrNoBGp/4qHzSnanc1PAxKQ7GE3Utd/8uuZBM/gfg2VHpwi5P2aMrmDg/dG1mOHry/RD3zV2R1wcmKdYYK7VybXvGlXqes/R3vkDEoiZz5/p8HeaDzeEh8b5mIhf3z+OlXobtycF6Scox1d+SNt9hrILNlHT2GoPWd39wNVzIMem9QyGeGY1FFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRgM3dDpCz8PqB5++jSLNe0WyvgsPs2tmPIw3PjB4I8=;
 b=Lg8dfgjFxUE1xQYCrMLnsireHzGxZnaCp5BcHSsGjxin83MR9rw9NXU7x92Ig6I3CLOwV/eIwCljSgI9VjQKaK9vVN3XC1E/OWing9EEX9eFiqT0mrd7gBNxkOTyuDCLDSy2VU8qkVHjxHPdtdCZ8Oh3W3dtXTJ3sBFmuirV9DE=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3192.namprd15.prod.outlook.com (2603:10b6:a03:10f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 30 Oct
 2020 06:45:12 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.027; Fri, 30 Oct 2020
 06:45:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/11] libbpf: split BTF support
Thread-Topic: [PATCH bpf-next 00/11] libbpf: split BTF support
Thread-Index: AQHWrY63qsgg2/wxykCIQcx/7B6lQKmvTVaAgAAhloCAAEZiAA==
Date:   Fri, 30 Oct 2020 06:45:11 +0000
Message-ID: <FA608BAA-B75D-4F56-B8E8-529468C89034@fb.com>
References: <20201029005902.1706310-1-andrii@kernel.org>
 <4427E5BD-5EBF-47E8-B7F6-9255BEAE2D53@fb.com>
 <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com>
In-Reply-To: <CAEf4BzbtiByaU_-pEV8gVZH1N9_xCTWJBxb6DYPXF5p9b9+_kg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d253be97-f253-46f4-5779-08d87c9f59b7
x-ms-traffictypediagnostic: BYAPR15MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB31929B8C9D8F58A1727A9F6EB3150@BYAPR15MB3192.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z9dVgjJuwQJf90TH2NKguv2RJbf00/QdXtxr+B2al6BDqnYemB1LfUsLF91RNdRuhTYD7WuF+u1M8V95GEI/YdSGthrj8Luo3R1hdiy9NDmpaV7z6GuNkSIRHU+dM1BTNxPLKFu15OUbXVKR07OUigjcJGiYMQ38dV+350QCbr3Aqh58zcLQL7GTVmwDQ9Yp9zCw2qoeIfZAJrtWxmULqzpg2TuthSjaQPg4n8kiR7AyUKvFX9c9L5VWcUCbA0x9YH/PKM8xA2KGCp8o+tEg3G2X/sJ9zA3GwlRxnZ+WL2WC3NSsNW5HSs/STq/7L0o8eBnHdoL0d78q2fplV4+ivuQk0j3gCnzjYwQaA/8rIIFklJVRsw68ybl86BV9B8oz
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(346002)(136003)(366004)(36756003)(6506007)(5660300002)(2906002)(71200400001)(6486002)(66446008)(53546011)(91956017)(76116006)(6512007)(33656002)(6916009)(8936002)(86362001)(4326008)(66476007)(64756008)(8676002)(478600001)(316002)(66556008)(66946007)(186003)(54906003)(2616005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: nZ/701/WvCLiGwhVbngx+3Zw5lPmDrqgtA219TpO70So9YHXLhGo9XBLBDs6y60JOC+jU4HJyXvL9b0arMoMWY9Is7knWhZmIH+zvdjeEGVBlzZexF9Hf6jaj1IojW3rQntVl7KDCtnFW2AqFY+xP8RAxkYU7X6F91bQ5RMw522kg/7bmKLIYfpqkgcrv+m0Rzlg1axUP9LFMJZnQoeIuPmL0h0hHZ2XrBuEYxW++VEwblm7VvhHBKDvv7osk6B+/tS7/YJYCUg2Glf1UkVRZ67ONYVkG4JGfossWXjaSjO4TV1f9WsTTU8ykkimj61WmbuWaMrrZh60ssEf6P4PGUQ16FlZSJoLnY1mTtVsu7hrJJsGHXPUugzxe3Th8xS5lwMGGS9npgX87vlaUemo0H+cQeCaD8OPk0GqFBiUietzZu8G1F+714Zwmjxb4+eC4gUFRWc9xKAQe9jp6h8iF9gwVNz1tscMSUnWQUIJk+str5FF/l+xK4YBwboHF4fWXzv+MYwNMg6IpYT+Q2PB9r5N1V6Z8edij1dBCMNd227ee/+UubpllMXlfWe3CuQ/vKN6ZLlTVBATXFCzeeTxcsy0dYKNaLlQHHxZnDZlI9Y9mfrJjF44rYGgvlDCj7nFKsMcOAoYG8E3E86Ovqm3usMAS3j+CyIEpnNsnK6dGWKJVh63uUWDhWWn6IOi88x+
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FACB2DFC36FCD84697FE3DDE85E18F49@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d253be97-f253-46f4-5779-08d87c9f59b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 06:45:11.8278
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RFFf72C7v3Xm1B1vZTrP3Q++wmdlA3q9U0tZQglzlIiF1goSbyc9QdEeNrk9wS7lOURF8doOqgMVoPNUPSKtSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3192
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-29_12:2020-10-29,2020-10-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 suspectscore=0 bulkscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300049
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Oct 29, 2020, at 7:33 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> =
wrote:
>=20
> On Thu, Oct 29, 2020 at 5:33 PM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Oct 28, 2020, at 5:58 PM, Andrii Nakryiko <andrii@kernel.org> wrote:
>>>=20
>>> This patch set adds support for generating and deduplicating split BTF.=
 This
>>> is an enhancement to the BTF, which allows to designate one BTF as the =
"base
>>> BTF" (e.g., vmlinux BTF), and one or more other BTFs as "split BTF" (e.=
g.,
>>> kernel module BTF), which are building upon and extending base BTF with=
 extra
>>> types and strings.
>>>=20
>>> Once loaded, split BTF appears as a single unified BTF superset of base=
 BTF,
>>> with continuous and transparent numbering scheme. This allows all the e=
xisting
>>> users of BTF to work correctly and stay agnostic to the base/split BTFs
>>> composition.  The only difference is in how to instantiate split BTF: i=
t
>>> requires base BTF to be alread instantiated and passed to btf__new_xxx_=
split()
>>> or btf__parse_xxx_split() "constructors" explicitly.
>>>=20
>>> This split approach is necessary if we are to have a reasonably-sized k=
ernel
>>> module BTFs. By deduping each kernel module's BTF individually, resulti=
ng
>>> module BTFs contain copies of a lot of kernel types that are already pr=
esent
>>> in vmlinux BTF. Even those single copies result in a big BTF size bloat=
. On my
>>> kernel configuration with 700 modules built, non-split BTF approach res=
ults in
>>> 115MBs of BTFs across all modules. With split BTF deduplication approac=
h,
>>> total size is down to 5.2MBs total, which is on part with vmlinux BTF (=
at
>>> around 4MBs). This seems reasonable and practical. As to why we'd need =
kernel
>>> module BTFs, that should be pretty obvious to anyone using BPF at this =
point,
>>> as it allows all the BTF-powered features to be used with kernel module=
s:
>>> tp_btf, fentry/fexit/fmod_ret, lsm, bpf_iter, etc.
>>=20
>> Some high level questions. Do we plan to use split BTF for in-tree modul=
es
>> (those built together with the kernel) or out-of-tree modules (those bui=
lt
>> separately)? If it is for in-tree modules, is it possible to build split=
 BTF
>> into vmlinux BTF?
>=20
> It will be possible to use for both in-tree and out-of-tree. For
> in-tree, this will be integrated into the kernel build process. For
> out-of-tree, whoever builds their kernel module will need to invoke
> pahole -J with an extra flag pointing to the right vmlinux image (I
> haven't looked into the exact details of this integration, maybe there
> are already scripts in Linux repo that out-of-tree modules have to
> use, in such case we can add this integration there).

Thanks for the explanation.=20

>=20
> Merging all in-tree modules' BTFs into vmlinux's BTF defeats the
> purpose of the split BTF and will just increase the size of vmlinux
> BTF unnecessarily.

Is the purpose of split BTF to save memory used by module BTF? In the=20
example above, I guess part of those 5.2MB will be loaded at run time,=20
so the actual saving is less than 5.2MB. 5.2MB is really small for a=20
decent system, e.g. ~0.03% of my laptop's main memory.=20

Did I miss anything here?=20

Song=
