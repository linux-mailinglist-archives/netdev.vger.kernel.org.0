Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65ED92764C6
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 01:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgIWXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 19:54:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60818 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgIWXyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 19:54:16 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08NNnFSN016749;
        Wed, 23 Sep 2020 16:54:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=etkqvivN7GeiQswelnclqWnXeEL3G4gW/5wGMHRNQmw=;
 b=HLXf1kO7dk0+k42zwAmewG/lOEg/0usrlAuIOIQbSvLJVoNUlHElU8vcAlHwTC6xSBAk
 LY8yn15BHwu/j6JhR2noVYxaHlQ/NYU/t/4tlCUNif3DiAOcgQCjs7/antoEgY51aNTo
 KfjqGY/OWu76xnQqUy5KnFo6GehEyght+DE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4xq64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 16:54:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 16:54:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmiO5fDIfLXtXnVMuWub46U4U5jsodYmTY5DIHOV611I94qTZqs302BqJoOemENKVcu8hgj3g/JlxVO9DqZ+zLWvU+VEnRW0ThluAxxeUICaYMIYiZAz+9Dfowi22CQvGOOLjI6476jRsqyTrzDN3WFby5wxwqwbjhMtHT7sbefxA8LKcXvIFj8Ci8hFoHr8lvJHUUc8/B1o6oxsLah1cx0awBlKgBybFiAGdcdtewvn2ZoKnfnATIDtQxu8pyy8U2G4+mCkrX1WZp0+s3S/BM/1Wp6m4ukvDp5d7hVJPc2dE8pS/gfn/wWojqSFJjHg/Lqf1F7Rz2mQXfbQzbEh9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etkqvivN7GeiQswelnclqWnXeEL3G4gW/5wGMHRNQmw=;
 b=RiJZIZ1afFvNmgrwj5p0jHqQ404JemLMWuQk8CzwTkTCgfi1l6Mc+a/0K7IqoMyik4H5z1XNe4GygdOXV2IlKs2/soBxeCCHKP652pyUzqo5eOjARtE4sns5bL2z4y4JifIdJLmA1HhcsRK/rPD4VtVs/YhBFUmtqEewN4A8vodgHXInPp17sFMh3uq1Ixja/i11yJ+Cag0nN9hejmwbgFOhkUdQxMlBC7olOieFNQdOOlXUAghfAJe8iVgvYYpBN/x0IMwS8NR2SgsiQkgX7nYGytCjM7zq4WMYZNFz/YQIyqW0Zs0Wx3SfV2at40zSG+Rb/vJwmgwcfl12+r7N1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etkqvivN7GeiQswelnclqWnXeEL3G4gW/5wGMHRNQmw=;
 b=Ks0WL5SgM//PDfrpTIl5yvuKwTqv96M1EQ8rpI4IxDcIgwHtytNJ1LsPh2E+u1/kpCcOmun9ov66rDuv0RP0lHM8GIFP02ZVELe0b3xCy6WvTclHBLMXcNYwxWs4jIeFuizdinDytw1tdHlX1jqkMdIBtf+QsqMUxfZwixiEABw=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2950.namprd15.prod.outlook.com (2603:10b6:a03:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Wed, 23 Sep
 2020 23:53:57 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 23:53:57 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: introduce
 bpf_prog_test_run_xattr_opts
Thread-Topic: [PATCH v2 bpf-next 2/3] libbpf: introduce
 bpf_prog_test_run_xattr_opts
Thread-Index: AQHWkco0dkq2Yhl5xU64KxjjZzD8DKl2nMkAgABJOwA=
Date:   Wed, 23 Sep 2020 23:53:57 +0000
Message-ID: <540DD049-B544-4967-8300-E743940FD6FC@fb.com>
References: <20200923165401.2284447-1-songliubraving@fb.com>
 <20200923165401.2284447-3-songliubraving@fb.com>
 <CAEf4BzZ-qPNjDEvviJKHfLD7t7YJ97PdGixGQ_f70AJEg5oVEg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ-qPNjDEvviJKHfLD7t7YJ97PdGixGQ_f70AJEg5oVEg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3d9facd9-9b07-4ad7-078a-08d8601befe4
x-ms-traffictypediagnostic: BYAPR15MB2950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2950DDA24CF538DC30FA80DFB3380@BYAPR15MB2950.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxe73H8hhFco5lGvNpuR8js4kvOvZkpeaE+vF1lKgtDyQaSS8J8Q/mqF6ezqRv5f3nrG4Jg2BoPS1sA3W14hZJ3yDgFIPAR6ceWPS0ow7nguRFglS0i1pnRAuCvfjysMApL0f2ASiaCR0wiZ1xp6mVQ3UXgM8cijWMTjbxcp4wgHhPkEAj2+9STiV+cMooKGK/GAhBxrOqBjybpMmkmpXmo7poU0gJTQYMCXi9Rv3+d3E91R6Sp256I/n7alvNgh1wo7K+f+ci9L7ywMBaokAy95sg7Ynk07mDHzwOT6Q9aOL4/NCW9xYMlSmX7GUrDeRF6+NmKxBxjsT3fv7IKfmqQTdOLBpoyHC3/S+lqKiWS83hgMT+uxyFFBIMMBiQNT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(366004)(39860400002)(66556008)(6512007)(6916009)(36756003)(83380400001)(53546011)(186003)(6506007)(2906002)(33656002)(64756008)(66446008)(66476007)(5660300002)(91956017)(76116006)(54906003)(66946007)(2616005)(8936002)(316002)(478600001)(71200400001)(8676002)(4326008)(6486002)(86362001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Vtp+TzlN+U3jFIFc6fOOIW/B38ewEkPsL9CsTmzfYnRhaYpLLRC02voJbbv3aB1Cn80suf0B6sUdA7WjjUw5KyEPrgZJ8gZXzylRrpiGZpC9kDaqCoU9j1h/Is8PonwLVJJtiM7grG3s6k8JXHZqmnWSyX/UB0udZr5l2FTUmcts4uenRMdyI7oAJ18JIBlTFd7mKnRn67W2NSb9AlfZq00sArSSu8Ryf/oeS3DP/daocCjlsvJ/2T9BPRFDoieWw1Q+0rxqQcYuFLpQP6lEHO+UIq9iYzen4S71S2FxruzaOQE2utlx6WCDgX1xu8alXPADD8SA/fq+1dK4Pf0J783SNQ3gtAay4CT9mjrHABdeEruym+Yw+/CL4ThE9TUYxGMvUki8WZ7Tgu6HLh40J8QngMtWwMJa816lzZqnmnlzp2Io/ZQ45zpoYBgySziBkuF0oaQS+FEUpkL524VtpSRw/5zJ3QsdYgpZiWtDnWBr3vWQhd3xbSi1ABEUtTcdBeWC/HZfI2doN37d8uFEdIuFwld6zvg6C6OnB7Ui+QSFyZEVln24yqteIhZIQlR3Bjyzz0Wq1dupJQXYf32kmyKRUqbWELKBzxcFaQWQhzbbsYRDpjbW8sVaNVgGmiFyQog2owA7cC9+pX9rrwQotOWYvHVOHX1gKkzTxgBWAq2JoAQWMZweHkOzujawisp5
Content-Type: text/plain; charset="us-ascii"
Content-ID: <163D3AD45C097E498EDA3E7B4C1B01F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d9facd9-9b07-4ad7-078a-08d8601befe4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 23:53:57.6598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xr+9oz4z0EakeZGwtgj7HeJDvjr22bgG8Opi8KMohkNNY93JFl+I1bo1yD5R3wnfNCBbt6ehoJB2EJ25mSmLCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2950
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230181
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 23, 2020, at 12:31 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com>=
 wrote:
>=20
> On Wed, Sep 23, 2020 at 9:55 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> This API supports new field cpu_plus in bpf_attr.test.
>>=20
>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> tools/lib/bpf/bpf.c      | 13 ++++++++++++-
>> tools/lib/bpf/bpf.h      | 11 +++++++++++
>> tools/lib/bpf/libbpf.map |  1 +
>> 3 files changed, 24 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
>> index 2baa1308737c8..3228dd60fa32f 100644
>> --- a/tools/lib/bpf/bpf.c
>> +++ b/tools/lib/bpf/bpf.c
>> @@ -684,7 +684,8 @@ int bpf_prog_test_run(int prog_fd, int repeat, void =
*data, __u32 size,
>>        return ret;
>> }
>>=20
>> -int bpf_prog_test_run_xattr(struct bpf_prog_test_run_attr *test_attr)
>> +int bpf_prog_test_run_xattr_opts(struct bpf_prog_test_run_attr *test_at=
tr,
>> +                                const struct bpf_prog_test_run_opts *op=
ts)
>=20
> opts are replacement for test_attr, not an addition to it. We chose to
> use _xattr suffix for low-level APIs previously, but it's already
> "taken". So I'd suggest to go with just  bpf_prog_test_run_ops and
> have prog_fd as a first argument and then put all the rest of
> test_run_attr into opts.

One question on this: from the code, most (if not all) of these xxx_opts
are used as input only. For example:

LIBBPF_API int bpf_prog_bind_map(int prog_fd, int map_fd,
                                 const struct bpf_prog_bind_opts *opts);

However, bpf_prog_test_run_attr contains both input and output. Do you
have any concern we use bpf_prog_test_run_opts for both input and output?

Thanks,
Song


> BTW, it's also probably overdue to have a higher-level
> bpf_program__test_run(), which can re-use the same
> bpf_prog_test_run_opts options struct. It would be more convenient to
> use it with libbpf bpf_object/bpf_program APIs.
>=20
>> {
>>        union bpf_attr attr;
>>        int ret;
>> @@ -693,6 +694,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_ru=
n_attr *test_attr)
>>                return -EINVAL;
>>=20
>>        memset(&attr, 0, sizeof(attr));
>> +       if (opts) {
>=20
> you don't need to check opts for being not NULL, OPTS_VALID handle that a=
lready.
>=20
>> +               if (!OPTS_VALID(opts, bpf_prog_test_run_opts))
>> +                       return -EINVAL;
>> +               attr.test.cpu_plus =3D opts->cpu_plus;
>=20
> And here you should use OPTS_GET(), please see other examples in
> libbpf for proper usage.
>=20
>=20
>> +       }
>>        attr.test.prog_fd =3D test_attr->prog_fd;
>>        attr.test.data_in =3D ptr_to_u64(test_attr->data_in);
>>        attr.test.data_out =3D ptr_to_u64(test_attr->data_out);
>> @@ -712,6 +718,11 @@ int bpf_prog_test_run_xattr(struct bpf_prog_test_ru=
n_attr *test_attr)
>>        return ret;
>> }
>>=20
>=20
> [...]

