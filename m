Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D4BC2AD0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 01:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732018AbfI3XZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 19:25:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731127AbfI3XZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 19:25:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8UNODUn032289;
        Mon, 30 Sep 2019 16:25:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fNz++M4nGA7F4VOnuIpVkZvzrixwleFDeqmRIkv5QGU=;
 b=OX3to+iXgfMvW5MVq3CjYW4pNI63zZvCs1SqblA4I/khSPt+fI0GLUBX8opxuCRqcRL0
 T4YhyoIaUisbndL3AbAttc+sFkixDM/cARWTixOA2PTY2q3HMKNCSw+J7NFL4R64gYbU
 t0qhzeMjs0yHfY4+rAm3lnoUdcABxmsJ4MU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2vbq6g943n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 30 Sep 2019 16:25:36 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 30 Sep 2019 16:25:35 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 30 Sep 2019 16:25:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y9+qG7QGftNUTAgjc5t0iBewTDdR534mDvO0FqXVTOgLsf/QZqjebmqa8NGdJDqf5Za1j/o0lVGhSiuqO4dmkUmW96KuGiN5Y8XqHMoXUKhKdhmBuB8z1Jo3Hx/zdLDmPvavb3lhDhhTqCIrFx6LcYWbBTR9FF2YwqA/pfmX9G2/jnSCAdgg/eWgkucVZjqjoB6oBCaW1Jsj3lE6V968hb1KZ7Nqcn01e0Twpucm0/SiToYKWBm1DQzylIh/guDoPQvlmSGwffwKPtEBQWuDfjbbQ9zMR3ucjt4CDX0vTGtbv90Dci/Sj3esA1FR/tZOuOUw0v1L+/uRqIHYtXvn1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNz++M4nGA7F4VOnuIpVkZvzrixwleFDeqmRIkv5QGU=;
 b=OmBrwN4aECXFJtixBp65RdE6TLRVlc36gQxlJGyrjMEfjJD3qJV3e5asD4zJGNeh1dBZK764kMWyWuMkZOSz1mUhod6N/mg2iMSYzh4xTySEPF9OJ72V2sSAP2JlZ3oY2uEW/hzhWzZ6Lqh8seeu8qmkARmDIT9sJsfQi36k8isCWaK2LgMckaBI7tZl+6eBc5f0EEMjdmSPyDnMgJz/HcWOjXKG7iqAc6AKUgkBrqaF7A2UETiAF+nXI87BCju2J8J2E2zmWQ+YpTgxgGMgODP8BSOKeyPA6auCrTeIqtg66uGGI8mBzA7zHfgHhdWtV79o7NFnjIZhEkY0kBC6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fNz++M4nGA7F4VOnuIpVkZvzrixwleFDeqmRIkv5QGU=;
 b=CZkkHJ6BJN8UU6wEO2JwvOmvdsVy6ir0neefiDpz3fS35sBdh28mdFAMsDk2hCFTS12QquVsh1use2sWcFeDXRLncVF6Bi6JkAdTWzNX3tkzPIngj8XKsKeg3YMPoqJP4Cymp6yS9+O8h8g4f8cNlvvnPmtdUyzCz1bRAQ58pgI=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1150.namprd15.prod.outlook.com (10.175.8.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Mon, 30 Sep 2019 23:25:34 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Mon, 30 Sep 2019
 23:25:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Topic: [PATCH bpf-next 2/6] libbpf: move bpf_helpers.h, bpf_endian.h
 into libbpf
Thread-Index: AQHVd8Ew888g3vk8vkOHuZyXroWL6adE1LeAgAAA84CAAAV+AIAAAguA
Date:   Mon, 30 Sep 2019 23:25:33 +0000
Message-ID: <DC8634C7-C69D-48DA-A958-B6E7AC4F1374@fb.com>
References: <20190930185855.4115372-1-andriin@fb.com>
 <20190930185855.4115372-3-andriin@fb.com>
 <CAPhsuW6RHaPceOWdqmL1w_rwz8dqq4CrfY43Gg7qVK0w1rA29w@mail.gmail.com>
 <CAEf4BzaPdA+egnSKveZ_dE=hTU5ZAsOFSRpkBjmEpPsZLM=Y=Q@mail.gmail.com>
 <20190930161814.381c9bb0@cakuba.netronome.com>
In-Reply-To: <20190930161814.381c9bb0@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:c67b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 214e557a-7966-41c7-8308-08d745fd7e14
x-ms-traffictypediagnostic: MWHPR15MB1150:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB115054DF171DB6731E30682FB3820@MWHPR15MB1150.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01762B0D64
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(366004)(346002)(396003)(189003)(199004)(6506007)(6916009)(316002)(186003)(53546011)(486006)(66476007)(64756008)(476003)(6486002)(2616005)(76116006)(305945005)(229853002)(6436002)(46003)(66446008)(25786009)(66556008)(102836004)(446003)(54906003)(5660300002)(66946007)(256004)(11346002)(71190400001)(7736002)(71200400001)(36756003)(6246003)(86362001)(4326008)(33656002)(6512007)(4744005)(14454004)(50226002)(8936002)(81166006)(81156014)(6116002)(8676002)(478600001)(2906002)(99286004)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1150;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +F8LfyG5esV+VxzBO6lfvS13ZUNg18nS5V2zZXEDadSLXbbL6rf7bYkwwUSJBHvKoUBqXYIcmf3GlLmF84XfslVlOkDcCXJyxASEKrL25pEdONjntAOX5zE2OIYVOCN4syTmD76qwe2Vcu6/Ru+Q8S5G+KWZmFDwEIUGJ99QWTiZl7mBLdshxQTav0nfWoXBl4wlC2rz6OS5GPmJejpJ3dxyen4ajWb+t5FzxJG1i5EtiaIYG3Q/WVfIEXk+kv6HVOAYj/c+XAhBQTwyxMcnI7mgAfR+3MNMfMww6pkWlQzuH9+yEh5wQ/dzc93n/THt+sH1PsJazTgF3Jgp0fjx9o9PHnFk+JoLlf9Dxy4OVmqaHpsZAvkMVZhLG9bvypGu8pHd8EtqZHSafxvkmhX6MhK/Xb4Y3Q3YeAnHkEtF6pw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7402EDF3275465439F6BB02DD7AAE212@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 214e557a-7966-41c7-8308-08d745fd7e14
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2019 23:25:33.8941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6PL+37pCinFgVJUIZu29uGydeLt5IZsKg0noR+/nzf3rFi7cpz0K88fUH2jbg1nq0Kkawxok3xkO/idPtGptg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1150
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-30_13:2019-09-30,2019-09-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 spamscore=0
 clxscore=1011 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909300193
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 30, 2019, at 4:18 PM, Jakub Kicinski <jakub.kicinski@netronome.com=
> wrote:
>=20
> On Mon, 30 Sep 2019 15:58:35 -0700, Andrii Nakryiko wrote:
>> On Mon, Sep 30, 2019 at 3:55 PM Song Liu <liu.song.a23@gmail.com> wrote:
>>>=20
>>> On Mon, Sep 30, 2019 at 1:43 PM Andrii Nakryiko <andriin@fb.com> wrote:=
 =20
>>>>=20
>>>> Make bpf_helpers.h and bpf_endian.h official part of libbpf. Ensure th=
ey
>>>> are installed along the other libbpf headers.
>>>>=20
>>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com> =20
>>>=20
>>> Can we merge/rearrange 2/6 and 3/6, so they is a git-rename instead of
>>> many +++ and ---? =20
>>=20
>> I arranged them that way because of Github sync. We don't sync
>> selftests/bpf changes to Github, and it causes more churn if commits
>> have a mix of libbpf and selftests changes.
>>=20
>> I didn't modify bpf_helpers.h/bpf_endian.h between those patches, so
>> don't worry about reviewing contents ;)
>=20
> I thought we were over this :/ Please merge the patches.

Andrii changed syntax for BPF_CORE_READ(). I guess that is new?

Thanks,=20
Song=
