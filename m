Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AB915AFC8
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728820AbgBLSaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:30:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52250 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgBLSaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:30:00 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CIPjvi007611;
        Wed, 12 Feb 2020 10:28:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hfU2seugpqgAGND7gy7k6A+IpXbS2rl7QVhjSJg8GhU=;
 b=cUws2lnwiSC1oVRzTw0oiCu3/teRZAu1k5lTbpILDAkH3gR0jFBZLvLS7b3Wc9BblskL
 pHImxW+gc4lVQr6kXFMkJ7IGfEKfmU7YRj7M+P4wa1wXwtG5fjAoJJidEC1dvVUSo4dy
 bxthkhE4Qycb0D/5DmqhbVvGOtjnAuWhkCM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y3y6uy1g7-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Feb 2020 10:28:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 12 Feb 2020 10:28:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ne9eNZpSA8OHBPBKa6FUCi/89rXbipWu/JksJ70h9F5qqSc6nJM1+TRPl1iZlNIhbjY1kO3a+CBoLBAtcjUOvuCeL87aOEGMqkdpaByBe7WZ7eI/mBVTduzOSSL/QP5NY41GPypMfIvXjifZxCLiaqAKL84Cgx5O5jee3zNIQE5l7OyLZv3uxkWlZ6J7XJW58WZ8tN0a6n5BogEjXiTKQQDdClyAJmQkiYuJlRVMSJu3pBQC+jtjEtUGVkNJjYnsJH3XvXLF4+2liubW9lnzGqFcI3xiaChbUgFvLgxfmYoRJ0xU6dq2Y/US7sihgHIMTz2qih+WIH0LNVKVImryMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfU2seugpqgAGND7gy7k6A+IpXbS2rl7QVhjSJg8GhU=;
 b=NOfqcRZD1B8mKLe5skgnG3YfLYD0ajMC6BJffTJq2FTDOsoWyCq9d2ptWDAIktVRfA9udYkviVmrgW0lzstdAdCgNvxzDyEnvLe8Tbon2jdFFG7Ro+Bs5/rmp1ycRKOt7J7B8ZeQVcufUrwiquBc2zEXffUVJmMB+CPYMIHnc7sEmH5F/DZ3AlAzc1eZ7/BbLo6iPzoUQaCvCvaes6isea+RDFOjmXk4CvHQj7b1XwyAvwW1Ifc4L6znRoKAQED1BdK/7pGrbtYaVcfIftw9le/gVZhWpGMjLRhFIyHKnaPIu1EEdk241oGBKSRAWU+n6GSMuXTuz2WggPxOuRx/Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfU2seugpqgAGND7gy7k6A+IpXbS2rl7QVhjSJg8GhU=;
 b=HSjfcWP94JhVen3CsrjIJ24+UtUAQxoc1udPJdiqdeybfMuGAPisM67I4LPv+MfIbS6qtdmlCItD/Jjdbr7if6WGSY0/2DKAL4TX2qyebmkfEJzpiFEpwhhjUpgUvXcwyNBT2en7eEXQ6l/EbdMWrQWdOKKmRPu3LVX90gNzrjE=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2187.namprd15.prod.outlook.com (52.132.148.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.26; Wed, 12 Feb 2020 18:28:43 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 18:28:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach
 target
Thread-Topic: [PATCH bpf-next] libbpf: Add support for dynamic program attach
 target
Thread-Index: AQHV4aBmkuDy8vU+NUWdt8DKhmBCX6gX0g0AgAAGM4CAAAUIAIAAA/gA
Date:   Wed, 12 Feb 2020 18:28:43 +0000
Message-ID: <F37F13F4-DAFE-4431-804F-BF7940D9970D@fb.com>
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
 <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com>
 <CAEf4BzYFVtgW4Zyz09vuppAJA3oQ-UAT4yALeFJk2JQ70+mE2g@mail.gmail.com>
In-Reply-To: <CAEf4BzYFVtgW4Zyz09vuppAJA3oQ-UAT4yALeFJk2JQ70+mE2g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f48e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68062b3d-beab-4ad7-1397-08d7afe963e0
x-ms-traffictypediagnostic: MW2PR1501MB2187:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB21871743C80F5FF453D0A59BB31B0@MW2PR1501MB2187.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(376002)(366004)(199004)(189003)(6486002)(71200400001)(316002)(6512007)(81156014)(36756003)(33656002)(8676002)(4326008)(81166006)(64756008)(186003)(8936002)(53546011)(6506007)(2906002)(66476007)(66446008)(86362001)(5660300002)(54906003)(478600001)(6916009)(66556008)(2616005)(76116006)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2187;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:3;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 16mNB0zJKwSF3ylxDh0y+vNisuDbO/DELzbKK53G6u4Xx5kLsEU1M348UBWfWti+P7qUxihVHyK9ym0lcKmOb353MV98qdskuS414k5dw+IP78l2YqTOIxyg+LA5iR6yEJrw64x9RlJVUkiZQNVyWdg7uEl6RByV57/lUyLvf+TS2R/1YkF4PxpqKmUKCITdr2yprlHCk/AQzi7VXh7fS+hZewL4wdpNkMIS87CThbkogu70I7wA/mtxS79R+LCB0tw8KMjS6sJHFlXm+nGtozcocahV0COZJM+8CgPpXAQvsrYpTonpBNeHZPeTyoJi0kXyDOb6GlvjiW4WjHXZGRWBs6AJfnU+erDnTApZHvJpSpu9bScy0jP2ktnQ/O4jVX442bwcetQZ5O0TML4fpWZoqiN7XRhtVPp8NJ0Q4SfjNxZiAtHIxD6QEERO6+mX
x-ms-exchange-antispam-messagedata: UmKLI7Yhwmni5IsK+9ma+OOUPGlroVcdjzw6Wtgtgbijr9Tow2gI+HzHPsjx8pOLu5SumC8PkH+RhLalHMfkbqJ9dRh6mfICSdesju1qOBQCCzjeuYno+VVKlMKlS6jk/DEtXvHw6JrRV5iCBVTGJ9UZ9XneRUPsopzC1ba69s7s0fRkX2AIZoDTgEABzHwW
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9DE9BA6927F71D489EB77B1B1B003BAD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68062b3d-beab-4ad7-1397-08d7afe963e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 18:28:43.3075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /xEw8LKzrpL6XGkQZrtkAAbH+m41pNy4iPUBkubUg0ehNv7e9MI5tAg9npU0CZNg4Kd66DOAbgyN0LMtx+N/zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2187
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_08:2020-02-12,2020-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 adultscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002120132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 12, 2020, at 10:14 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Feb 12, 2020 at 10:07 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Feb 12, 2020, at 9:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com=
> wrote:
>>>=20
>>> On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> wr=
ote:
>>>>=20
>>>> Currently when you want to attach a trace program to a bpf program
>>>> the section name needs to match the tracepoint/function semantics.
>>>>=20
>>>> However the addition of the bpf_program__set_attach_target() API
>>>> allows you to specify the tracepoint/function dynamically.
>>>>=20
>>>> The call flow would look something like this:
>>>>=20
>>>> xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>>> trace_obj =3D bpf_object__open_file("func.o", NULL);
>>>> prog =3D bpf_object__find_program_by_title(trace_obj,
>>>>                                          "fentry/myfunc");
>>>> bpf_program__set_attach_target(prog, xdp_fd,
>>>>                                "fentry/xdpfilt_blk_all");
>>>> bpf_object__load(trace_obj)
>>>>=20
>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>=20
>>=20
>> I am trying to solve the same problem with slightly different approach.
>>=20
>> It works as the following (with skeleton):
>>=20
>>        obj =3D myobject_bpf__open_opts(&opts);
>>        bpf_object__for_each_program(prog, obj->obj)
>>                bpf_program__overwrite_section_name(prog, new_names[id++]=
);
>>        err =3D myobject_bpf__load(obj);
>>=20
>> I don't have very strong preference. But I think my approach is simpler?
>=20
> I prefer bpf_program__set_attach_target() approach. Section name is a
> program identifier and a *hint* for libbpf to determine program type,
> attach type, and whatever else makes sense. But there still should be
> an API to set all that manually at runtime, thus
> bpf_program__set_attach_target(). Doing same by overriding section
> name feels like a hack, plus it doesn't handle overriding
> attach_program_fd at all.

We already have bpf_object_open_opts to handle different attach_program_fd.=
=20
Can we depreciate bpf_object_open_opts.attach_prog_fd with the=20
bpf_program__set_attach_target() approach?

Thanks,
Song

