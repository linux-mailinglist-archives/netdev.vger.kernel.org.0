Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D005239E10
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 06:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHCEVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 00:21:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22502 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725924AbgHCEVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 00:21:44 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0734JusQ021436;
        Sun, 2 Aug 2020 21:21:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=7QUfUHrRnEX2fFMQ6xPNgPgl31rTM/0GAHLap6TuO0g=;
 b=RvgZE495z9k+knAtMLrJ1IQfWFbNXSSvtijkhCOS2pIMhtxQt/NPuGNIylBbiURJHJIV
 WyJ7XJyeSHDhTAO7eUdrBr13S4dezFru6LWi90vTiwrq8FWbHaURurH1rHmgkfMQHYlr
 J+y43p7Dtrt8SgvZzQzs7UgpIRvY/dzXg8c= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32nrc92qrw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 21:21:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 21:21:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqFlWORK97W/3V6qlrMKhyzNpPHGc67LmstsuxvVK5M7T4pzdCmD7VmznhAXXVS8R2MB1zZc1plN4Rk3tHyycLB+qrD8VwGdXGhuwqXdhZigSYbm5/e+ClIrwrG+hThmqNqlAGQX+1Q/vUL/up6hNlUNa8P1uQEC3kmFc+V7Qr1i/+fJ3fDBHDZ1h3QirhfNefVgMoTXz4AVMSgz738ZxZd93BvBNGzja+48r69YTv0EDcchm8QPnkJMqtc1GU2Ng9FTKKX1bgqqYm4drcXEP943/LjfXCcGUf2kioa23Vrn/lPGk7gg/N5HnLggG1rV8Zs8pqeeWFQCk2scFVW6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QUfUHrRnEX2fFMQ6xPNgPgl31rTM/0GAHLap6TuO0g=;
 b=nMS6a+liycjWVk2huU1xMLMUnMgBvVB5EpT2dQooo0m+uVziAncChV3tuiskqkC/PXjAQOs5OAU9nttqlMhfYQlpn+82+YX8apb4c5AyQnxK/qN1T40poGqH771i8yvNzL9HzSSWTZj4tkEHXFPJEYietwill2A4RoVpZ6FIaPPO+jG9t/L5sDUHqfoHUmY++3fMG2BJKKIWLRavDxSgQfuVPrQdqRLgtu6dftz5EUI8QOVP6BnbVKQ0ZtKYxx5PqpzX7pLieEJur1qyKhTkhiKK4/WQxLBcPMTl99hsSU0Ku62dqG92RHkM7kmtqD7pQaD1Y960WQXAB28n+Sajuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7QUfUHrRnEX2fFMQ6xPNgPgl31rTM/0GAHLap6TuO0g=;
 b=TqdnU0nF7EkJIn8E8etEKw8oy9zMGRr1sIFhV65I8HUffbk1VKQAjM1SvHJh9EbuqylhC6ynatw6rzGttEaWqNSPJu6KMIBQZ7WkOYZKsrIoXpzAH8prc3eKIXvqSIYB4LXCm+AwtSSyh9g1yuEL6H4LITLZCf0CvGAMOy7cnCc=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2886.namprd15.prod.outlook.com (2603:10b6:a03:f7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 04:21:20 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 04:21:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Xu <dlxu@fb.com>
Subject: Re: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Topic: [PATCH bpf-next 2/5] libbpf: support BPF_PROG_TYPE_USER programs
Thread-Index: AQHWZ+C4tQwFkmvi20aNhPcONSrEz6klnl6AgAAs84A=
Date:   Mon, 3 Aug 2020 04:21:20 +0000
Message-ID: <3B31DE6E-B128-48D7-91A9-84D51BDF205B@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-3-songliubraving@fb.com>
 <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYp4gO1P+OrY7hGyQjdia3BuSu4DX2_z=UF6RfGNa+gkQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35aac618-03c4-49b0-2192-08d83764ac9c
x-ms-traffictypediagnostic: BYAPR15MB2886:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2886344173B7AF4EB888FE7DB34D0@BYAPR15MB2886.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tj6I15YFlKMYuKWBXmaCUkkk6chR7JXCOw7V0TDhWraFy/bFUe8LsEHPZuGoxzT+qVORglkgqaRR2S4ekTtA+zZNa/wt76Mli3y9ftKWtyasL723CAsf7yVEZEj2BMsacb+jJWKDCAff9Hu7cCBgwjhYSH9tGIwRrtvoL35JeD8BYJtwxZYjCT2IOxvklo+KlBhm1t66Uz1XTtJMcafZ1hzCef+h0sMoS24/TQ4Wj84RXNXZv9RgAvvjkDOSj4ZgXkIkrx/Urc91iij7P7HGkpmE794Zwc+88oCYyDzh+Q5AKMthUbkGelRizVU3AkBDneD5y6gd8GZng3Kg9w1l7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(376002)(366004)(346002)(136003)(6916009)(86362001)(316002)(6506007)(83380400001)(5660300002)(36756003)(8936002)(53546011)(186003)(2616005)(8676002)(478600001)(6486002)(71200400001)(2906002)(66446008)(4326008)(64756008)(66556008)(54906003)(76116006)(66946007)(33656002)(66476007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Da9ER17DUEWUzAP9du4A1vkTZQbUw0CsOSw0ZEIoO8SE7pHIUvwK64393DITIj+FyQwj+dAwhM5AfGf1U+uEIkYCadg7nwqItqtEUMpeqMobsUBUYtCkUXPJsAEBE0ZFObuXKpB+P0q9VUaQl0wkkw+5jJRGSUCRLsrYbhZrToiqxwar30Q7qn1EndyLs03BQf0LxPfkzeiLcQwfVra5J8RBVfN59oOuXOk1MU7mKr4mZScn1kLDJFjG12a+ppk8FDt9YtKLuW/XFfJwXeHFbXAmibIC51hqHS91kbWzwoUGcDRyd5Yxbcj9VexYqPGx5pliR6aZ3qJnqEQuh5GGkvkDvBNtRJIFdxmuApYE866xDt5p9Ir3gZIzqdD1wnTdXIGilRYRvUkW+sseBV5VtjBGMJL5m5IQUZWsLGUHce2YKAkOVeIsJitgJhl+/z3xFpB8Y+ylZrS//tt57ZpyyuoWybluSdXXJaPMvF6K1F40TkGUKgnWighKw4e6XFuaULrDFAsW1AJi7Bxc3QdVjPNRm63PybScYGf5FM1wZk70pd73bkl9JJRcHMePtUfUlTgCrup6EibLBBYJhOinP9HTV6UFbb1U9Zf+kGpR/LnBKv2HZZFvk3OZNsGGYkyty6rNlTSVWkJkro5pU3Yow0mRIJHP2b2Q+bfSAcEJOR4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5D99805D5A305641B7219277B214B5A3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35aac618-03c4-49b0-2192-08d83764ac9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 04:21:20.4096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X1xU+Fo+YWT/uf7AzQ6eRNEbRiSTglh366JcSQ1lqPX/tgpEPuO+Hjbr7mE1Yt4yJ/gPtg40REuZhjWoRb887g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2886
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 impostorscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 2, 2020, at 6:40 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Add cpu_plus to bpf_prog_test_run_attr. Add BPF_PROG_SEC "user" for
>> BPF_PROG_TYPE_USER programs.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> tools/lib/bpf/bpf.c           | 1 +
>> tools/lib/bpf/bpf.h           | 3 +++
>> tools/lib/bpf/libbpf.c        | 1 +
>> tools/lib/bpf/libbpf_probes.c | 1 +
>> 4 files changed, 6 insertions(+)
>>=20
>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> index e1bdf214f75fe..b28c3daa9c270 100644
>> --- a/tools/lib/bpf/bpf.c
>> +++ b/tools/lib/bpf/bpf.c
>> @@ -693,6 +693,7 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_run=
_attr *test_attr)
>>        attr.test.ctx_size_in =3D test_attr->ctx_size_in;
>>        attr.test.ctx_size_out =3D test_attr->ctx_size_out;
>>        attr.test.repeat =3D test_attr->repeat;
>> +       attr.test.cpu_plus =3D test_attr->cpu_plus;
>>=20
>>        ret =3D sys_bpf(BPF_PROG_TEST_RUN, &attr, sizeof(attr));
>>        test_attr->data_size_out =3D attr.test.data_size_out;
>> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
>> index 6d367e01d05e9..0c799740df566 100644
>> --- a/tools/lib/bpf/bpf.h
>> +++ b/tools/lib/bpf/bpf.h
>> @@ -205,6 +205,9 @@ struct bpf_prog_test_run_attr {
>>        void *ctx_out;      /* optional */
>>        __u32 ctx_size_out; /* in: max length of ctx_out
>>                             * out: length of cxt_out */
>> +       __u32 cpu_plus;     /* specify which cpu to run the test with
>> +                            * cpu_plus =3D cpu_id + 1.
>> +                            * If cpu_plus =3D 0, run on current cpu */
>=20
> We can't do this due to ABI guarantees. We'll have to add a new API
> using OPTS arguments.

To make sure I understand this correctly, the concern is when we compile
the binary with one version of libbpf and run it with libbpf.so of a=20
different version, right?=20

Thanks,
Song

>=20
>> };
>>=20
>> LIBBPF_API int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *te=
st_attr);
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index b9f11f854985b..9ce175a486214 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6922,6 +6922,7 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
>>        BPF_PROG_SEC("lwt_out",                 BPF_PROG_TYPE_LWT_OUT),
>>        BPF_PROG_SEC("lwt_xmit",                BPF_PROG_TYPE_LWT_XMIT),
>>        BPF_PROG_SEC("lwt_seg6local",           BPF_PROG_TYPE_LWT_SEG6LOC=
AL),
>> +       BPF_PROG_SEC("user",                    BPF_PROG_TYPE_USER),
>=20
> let's do "user/" for consistency with most other prog types (and nice
> separation between prog type and custom user name)

Will update.=20

