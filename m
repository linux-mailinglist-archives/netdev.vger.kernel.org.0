Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF5BB15B008
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728930AbgBLSmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:42:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727054AbgBLSmH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:42:07 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01CIY8Mb014512;
        Wed, 12 Feb 2020 10:40:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Pfm4Ins0onsbySSV3DIQ7I4/jrcIZZtmUHPZuWknubc=;
 b=SFbbq2jaqCJ4AL4M1B1afysTvABJPaCqg+fthJXlyF3uJK7H8W6HmhZlVGvAKj+Rk6To
 1ShGkNrHKEEfqLiIh/TmMfqEXDjy6KKglDIaALTmeEA/LGShsPvhHWxEqD1EAO0CE1tH
 S6+TMkRLyYMQUYuiH/whK0hQvIip+2FuU8E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2y4607mqph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Feb 2020 10:40:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 12 Feb 2020 10:40:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfEGi+55sWBdBuUtWE9OkT2jUO/LLZKcvD2WhpBTtoxKhFhEa1xId/x/6vANIsm+Ma9NaLL5zKmS8B3oH1Pvz48HworcHMhxn6wFo4L5UNVBntLOjWaPrEUN8fZRIamcoutqkRTF6mRZL8R/BKwrVv4+cdiZ9UnGIP0G8RsA52IPoZVAXzrNEQTXfOK0odr9nkYHG+a2pipaJr/9yCdEGA7HN4dCk1SfqS9Nw5YPsa5bmMU480SxGt20paie+sylXioF22HMMeiXbwRQxlWHAKw3QQP1vsaMi9m6IZDyTSegRfKl1kFRkUT0cIxkP5LMAzxSdI4zlxQeVkWlf20g+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pfm4Ins0onsbySSV3DIQ7I4/jrcIZZtmUHPZuWknubc=;
 b=khRsyslNKhd6L+zqhzjiByGW13KUL9H1C6ANi9X4kvaHE97y5UkxIxKr7g3Z2bvDXINDJCUScXtX1ZZ1L/gQOwsXCjnGtNAyHO8XHxeIir9kq67jz/jC32kp1rrRrmjG8UYQCG9fmI5AGEBOpuhLg4tBEake7CxZvuAZxY7Sc65/cz4rXfH0GxGvqVq4w93lLMyndgF7JJy/s6f4iY4tVOHMyeD/W/qf3tKVpCnhkLlXlBHIaKJ3Xoz2ifBxYU+e1B6Vv+70QUZ4Ph8icAa2IXI+h5W4Wj2eu2yWqZHaflnyjUobqOXi4+L40+Vhp0QG3BWDzimGyVxpSV5YVKPn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pfm4Ins0onsbySSV3DIQ7I4/jrcIZZtmUHPZuWknubc=;
 b=kh1TXYqOPF45bTjmB61KDucMYauR87W1FfSa08z2HSeIfJxGUEVmhN9O+51DF1sT8hAjKJr5f3xBBkaPOjtRO9fJKTDAIQBD7Ynd6RmgliDgtbw7fDA3+EXNIA8XHvZKTX5ID6eFr22kl1SiDZUSjU5PpZxEDuoCPcHmSHWO5bw=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2044.namprd15.prod.outlook.com (52.132.147.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.28; Wed, 12 Feb 2020 18:40:54 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 18:40:54 +0000
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
Thread-Index: AQHV4aBmkuDy8vU+NUWdt8DKhmBCX6gX0g0AgAAGM4CAAAUIAIAAA/gAgAABgYCAAAHmgA==
Date:   Wed, 12 Feb 2020 18:40:54 +0000
Message-ID: <04B1C476-5ABC-4F98-A5A3-5A2E124B516F@fb.com>
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <CAEf4BzZqxQxWe5qawBOuDzvDpCHsmgfyqxWnackHd=hUQpz6bA@mail.gmail.com>
 <628E972C-1156-46F8-AC61-DB0D38C34C81@fb.com>
 <CAEf4BzYFVtgW4Zyz09vuppAJA3oQ-UAT4yALeFJk2JQ70+mE2g@mail.gmail.com>
 <F37F13F4-DAFE-4431-804F-BF7940D9970D@fb.com>
 <CAEf4Bza4MQW6QEg7_VdWJwMJPKP8nPSD-ErkUFhVtxyA=jLkHw@mail.gmail.com>
In-Reply-To: <CAEf4Bza4MQW6QEg7_VdWJwMJPKP8nPSD-ErkUFhVtxyA=jLkHw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f48e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b6ed840-c640-4e31-3e4c-08d7afeb178c
x-ms-traffictypediagnostic: MW2PR1501MB2044:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2044C4F4F5337363B33B678EB31B0@MW2PR1501MB2044.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(346002)(366004)(376002)(189003)(199004)(36756003)(54906003)(6506007)(8936002)(66556008)(5660300002)(4326008)(66446008)(76116006)(71200400001)(66946007)(316002)(8676002)(64756008)(53546011)(6486002)(81166006)(81156014)(6916009)(33656002)(66476007)(478600001)(6512007)(2616005)(186003)(86362001)(2906002)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2044;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QRdXAcdlg1I8HZsbjfLjQJmjmTYwH6HTwNKB9vzPvVRT65XgCEw7oC1jWHCj4y8zOGJ+sfzNuNdV1iOIfVy+LBcIp52QoF8jWcuH6MtymCIX2Fi1J+ne0J6KjR89NmVOeEOQgdyh6VZnTx3CBnk1MLaAKp/9AUJuAl4LJUXOW/LjIqpP1RD/OiTET1//3YAQvsRp0bBVO1luHioAPXd6I75ghQ21WEGsyOcdjulNsHYnHf0QPiQ69T94oENEHY35AzW0n+/NSgbWKiY9kkGCTMTezQxIJhAS7F85rZZ76AkSEW6NrD5X6CzRMZloO71UII/ZeZgz6P0qhkjH9rIPYTiErCXlABed2UObx2JV6qkVoDFdWOC4dGJestsgJUX5aVZhLYH4pWLCRhRVPbQYqKTA7QXiD6ZzD1xdnrg9BE/iq4qARK9Fho7aTbUenB80j/BegJAWTCn78J1f1Zrc+wnjXKpiCtQ/0U1j3SxpQt944+QtIFgWf0cEkNHWj+2U
x-ms-exchange-antispam-messagedata: nPFqG5sXd0iHRRU8tnKXEtpxe8bWWiGXNhSzlXuoxn1IQP2b1BPQzCpvCuz1h4knlKl3Yih1cDJGSXOxSL+oUWUxNMwRvlUInMtWhAa/dIMDGNpWvVUiUmXvGLrvnZT7T5O1WKUOvg+2ttzpGdh3o41KxrYEQMe6bqFDxIldfsZZkHZDaHPZGiQ5/WpOKspz
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <93C484F6E903FC4CB103FDE0B6FDB4CC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b6ed840-c640-4e31-3e4c-08d7afeb178c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 18:40:54.2337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /jBaAJFZDDx7jGUT2G9kmkOoyNaGMLuiYiUEXLZJ/feB+bTKYCY1wf1xEt8YMsKf3zDG4rEn6AQhax4aq0k+OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2044
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-12_08:2020-02-12,2020-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 adultscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002120133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 12, 2020, at 10:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Feb 12, 2020 at 10:29 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>>=20
>>=20
>>> On Feb 12, 2020, at 10:14 AM, Andrii Nakryiko <andrii.nakryiko@gmail.co=
m> wrote:
>>>=20
>>> On Wed, Feb 12, 2020 at 10:07 AM Song Liu <songliubraving@fb.com> wrote=
:
>>>>=20
>>>>=20
>>>>=20
>>>>> On Feb 12, 2020, at 9:34 AM, Andrii Nakryiko <andrii.nakryiko@gmail.c=
om> wrote:
>>>>>=20
>>>>> On Wed, Feb 12, 2020 at 4:32 AM Eelco Chaudron <echaudro@redhat.com> =
wrote:
>>>>>>=20
>>>>>> Currently when you want to attach a trace program to a bpf program
>>>>>> the section name needs to match the tracepoint/function semantics.
>>>>>>=20
>>>>>> However the addition of the bpf_program__set_attach_target() API
>>>>>> allows you to specify the tracepoint/function dynamically.
>>>>>>=20
>>>>>> The call flow would look something like this:
>>>>>>=20
>>>>>> xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>>>>> trace_obj =3D bpf_object__open_file("func.o", NULL);
>>>>>> prog =3D bpf_object__find_program_by_title(trace_obj,
>>>>>>                                         "fentry/myfunc");
>>>>>> bpf_program__set_attach_target(prog, xdp_fd,
>>>>>>                               "fentry/xdpfilt_blk_all");
>>>>>> bpf_object__load(trace_obj)
>>>>>>=20
>>>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>>=20
>>>>=20
>>>> I am trying to solve the same problem with slightly different approach=
.
>>>>=20
>>>> It works as the following (with skeleton):
>>>>=20
>>>>       obj =3D myobject_bpf__open_opts(&opts);
>>>>       bpf_object__for_each_program(prog, obj->obj)
>>>>               bpf_program__overwrite_section_name(prog, new_names[id++=
]);
>>>>       err =3D myobject_bpf__load(obj);
>>>>=20
>>>> I don't have very strong preference. But I think my approach is simple=
r?
>>>=20
>>> I prefer bpf_program__set_attach_target() approach. Section name is a
>>> program identifier and a *hint* for libbpf to determine program type,
>>> attach type, and whatever else makes sense. But there still should be
>>> an API to set all that manually at runtime, thus
>>> bpf_program__set_attach_target(). Doing same by overriding section
>>> name feels like a hack, plus it doesn't handle overriding
>>> attach_program_fd at all.
>>=20
>> We already have bpf_object_open_opts to handle different attach_program_=
fd.
>=20
> Not really, because open_opts apply to bpf_object and all its
> bpf_programs, not to individual bpf_program. So it works only if BPF
> application has only one BPF program. If you have many, you can only
> set the same attach_program_fd for all of them. Basically, open_opts'
> attach_prog_fd should be treated as a default or fallback
> attach_prog_fd.

Fair enough. I will use set_attach_target in my code.=20

>=20
>> Can we depreciate bpf_object_open_opts.attach_prog_fd with the
>> bpf_program__set_attach_target() approach?
>=20
> bpf_program__set_attach_target() overrides attach_prog_fd, yes. But we
> can't just deprecate that option because it's part of an API already,
> even though adding it to open opts was probably a mistake. But for
> simple BPF apps with single BPF program it does work fine, so...

Maybe add a warning saying "attach_prog_fd is deprecated, xxx"?

Thanks,
Song=
