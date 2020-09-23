Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C16276382
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgIWWFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:05:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726476AbgIWWFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:05:16 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08NM4vmx013735;
        Wed, 23 Sep 2020 15:05:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=etQrMRXOz/8bJHashY2FIrv6TAHdtXAfXVFFeKvguWI=;
 b=L3FkZ89KjFu/6/rNcUncPvCG2WQm7MKOLU9c2HzOk6Z3ID4oETJ/k/nJIm0kCDKNE91o
 sAtSgkOCVXi9uQJvCvkfW/O641w7MWXk69lHYUJaXQ8SyoaE3vCfiGoFzSaZM52kVLGn
 CqymgpGQH1gv7Lcmakgi7PYiB0cxBpqmD5E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33qsp4xa6j-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Sep 2020 15:05:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Sep 2020 15:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/1b3Xt///Cw3XDNJwIswHNPxVkqRAsdO3VU8P5vaZ+WbK+Tryzxmf//9yTOcNspRW8txBDhcqBfFJgHO+OSzFX7uOIDVfqxU5zhLB1xQTGhZg9EQJ8SredmGfxzk/GF0jpB6WifnnijIoAz4Ht7jLrdgfAAqxNRA4faifJNW7c53SlXjwt4MJEr6kocU3pTcAvYto/pHiBco6XAvSnj7v+cveCQ5ZU+CyODW/xJUulFzKRfgZ1x/j2ohxsG/x1R/0Vx9pMjboJWimzMKTeFARjWlSsHYujISA6zJMjfGL9WH59QlMlgnj9d/Cdo+wgcawFnfnA1prGVaM1i7K4qZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etQrMRXOz/8bJHashY2FIrv6TAHdtXAfXVFFeKvguWI=;
 b=YH7R5sNAXKW6t5J+rmOb5UVXpT6yaQjPe/cjQBKC+v7ptVBPiLnUxFF0DQ+TzdmAx+j0Blqbqc8XgWXaMz4aoysZPZqPuHYz0ZPDnAHwcVVxQvP+1enpG8KzNuFUtgAMm6KAAKk4wtUnwNccIhfkDbaJlwBxdhWID7wJSWWYtVF8FNY29Z4yYJR9Kh2Xys+z8bwsWdNGqlnuzP0cSIS8Vm+Uqb448I3mxMTm3NW3D5qH25JEJ/vDH55+aawgSZFcOZy3pOOlGd/83kCWIykOejLlVfGtvFYNYIssXV0B1PkWPpHp43S2ak7LGty+Xy6+17fMNqGqVYaB5gIgMPqD3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etQrMRXOz/8bJHashY2FIrv6TAHdtXAfXVFFeKvguWI=;
 b=P0CcDMUA1AOkLEIHkFBLi7KEEtPIXITgn+BLvlC+tUEcC9JITVuOCkr78BX8QQTUXe8Mh2wgZpikvNP3XA0j4MXjiT/PSeOWy/RWLp3MjqTwznK8pWt9mT5kErfw3kSb5nKfLaZSOQrOHwBuJSJFZkU/uSeGWce0OgUuSo/pXIA=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2455.namprd15.prod.outlook.com (2603:10b6:a02:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Wed, 23 Sep
 2020 22:04:37 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 22:04:37 +0000
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
Thread-Index: AQHWkco0dkq2Yhl5xU64KxjjZzD8DKl2nMkAgAAqrwA=
Date:   Wed, 23 Sep 2020 22:04:37 +0000
Message-ID: <3448307D-81E0-42F4-860A-DFD21736DC59@fb.com>
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
x-ms-office365-filtering-correlation-id: de072733-ebb3-49db-ea07-08d8600ca97c
x-ms-traffictypediagnostic: BYAPR15MB2455:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2455DBFE67B81C95877F0FC6B3380@BYAPR15MB2455.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eYJNWZI7e+4WqZ9pVwHMekwikEtcGnPYKRvfEEYJlBrbYrzXRO4ywRX/rZZ2HPKUX5SNGPQu3dDYIFipTSi+WUerabmi+qSHCfIb84FEm4TkUxqG1GJYXZnc0WtpEZugi3wRj4Md5TF3/8UvRug3YHHZTrEsmoA7nCSMk2WLKkiGavjuzwa/7G0i9FTMxDh9vCOukUOLNC6ClMyAyKL8AdQIAZ7zSWYvEL19l0vPIUKFeSkYhH/6FT53OfITORH9uf5VCUH0PFlvFdfwfgA9IzgguloGl8ZIcQnjFSKERE681q3eOmXhRD2CpRFeOPIS9ul/SBCl1gB+eNjv6/yZvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(86362001)(66446008)(186003)(316002)(64756008)(66476007)(53546011)(8936002)(71200400001)(2616005)(6506007)(66556008)(6916009)(54906003)(478600001)(2906002)(83380400001)(91956017)(33656002)(36756003)(76116006)(8676002)(4326008)(5660300002)(6512007)(66946007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LIKhnIglfoEtzhSrvsbpxYw6cdrQ0tthBnPc6C6BAAPObl6+3EZU/z38ZbqJv3JfO0CEZgLq+GigfGsdvVYfo9VvnE4JYP8EZzTEOOcOhzRGlYdfcPyefWWeo4wIDjQjc+d5XZJ2FHOab07ipjhxydc0HtvZ0/HME2b38L0jaXVqlm9FvGqxb9HL1B7cIodudbh8eOPFdxwx1wF5ThpKlZxHK+AoWGlR0cJTbaMmOkF+7GurcEZ1FrsFn7VEHFogmVrL8MIJYplLzhqC5P89opYy1mB3z61Y3U5PwUiBusxbx1p5wXtTQ4gc6w2nLoitKjic0GtyyfL3hikgWlzNeze9pYf1uVUURfauoLDLL7ZddqYYZDCJS0UyAF5KiOIw7gkMArypJEdOE6LR9WWFbxvpZOR1365sGE/C+VgbAjUGeiLh4R7MJtt6LbXQIM5qsOLr1kQFcJX/0D8f8BlJudgUGv9H6JpU3YbgRRjqHnm+rAlgzbSzZfUZ1D/sR8Qz/Jh+F8uuhWHgn/NN2Z5Y6dkcVcyJFSPqWEi1hHWNx0J+Fmx76s0BTI4/h3eqUupZmpqev/SHQ3qt5LVNO63uGl2PMRfzyyf/hCDVkJfD0eJ08/H1O+9uJJAxTEiloBMVvP3tMu3pDsCpo3w7E9NfYKaaEv1iZ4BGqqmSdRk3bDl0EDosc6nPQHq8zZOGnYyq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <614ECF2E0FF668468447AA756F6B1521@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de072733-ebb3-49db-ea07-08d8600ca97c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 22:04:37.0476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jh2dfbR7Xo66sx11Ti9JffD3635ps6dJ6jeLjlRJAvvnuVPMRNM/o2U8GxHw4iit3qm4DOOxxSXMcgs1b+zZqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2455
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_19:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009230166
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

Sounds good. I will update it this way.=20

[...]=
