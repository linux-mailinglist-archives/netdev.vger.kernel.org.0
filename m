Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500AC166E8F
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 05:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbgBUEcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 23:32:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60452 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729547AbgBUEcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 23:32:03 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01L4SkQN002012;
        Thu, 20 Feb 2020 20:31:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=VCU80cMnu4NBguPmpl3gVmyHvchoNfmxigi/QuCjG24=;
 b=TXQtwAXu5BBpV0h9IXt4sQiTqatqEko8s3dbIU2kxvSr9DFojC6SU2A/rl55aKarsASs
 uhn/ih+WQXpYIsIsMoNp8QRQD0vJGD3iLHR0NG2NfNQcKIFnMRU2onf745D1nFDwHeez
 Va2dJFIF2loaA3jhl8xRn9XwKXqfOIXDtiQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y9dm377jf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 20 Feb 2020 20:31:49 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 20 Feb 2020 20:31:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnqAZWPpeBotmT6wMW9qZPOApAE7LwUrOdRj59k07Fyj5eS8L+1Uks+hj+CZr8oYK8m9lzoth033pWqibc95CSueaV6gFRYsz1Ja+LRx/TXBB9vJxqOyVhdaKtom3511uk1SKTZmDch4NhHFpionqH+WmChcrZecnm3EiTA4KkTVHRfrsCKcs29YoDPJhXV98l4smR+NSyMRU5SOV2o0VlxxvzH8tDjZ8DFPzFWiH0T4AxaxAoH3Fn+eQVOdSMgMaR8zpFQkg5Ff89NGrrttuaZQFt0bqZSRV6U2KkFs466JusTdCtwRPgL8RI2Y41H3If5zf6Rry1AbSq/ktu3mSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCU80cMnu4NBguPmpl3gVmyHvchoNfmxigi/QuCjG24=;
 b=MFgJGgBpkndpW+GOD0EEsxFaPaAeJ7T+WBvelorHjtaR5nVSrxmL8iypEvnoGAVpjd3GS/xfQRv22bFydQkH5KLzGPulFjiTk0MHOV13whJXplIF+dGdpN0ZpigQLxjFeCrgnf7fHVLcc6khMtosrvGpUwRp2hukIR8ALRmXdPJEq87nVbSzXT5z+IpByqjkcAqWA8AgctOzvMdys75x3AyQUT//hmhZpww3bVDVAj0IfRct1thwbBf59XRu/EAz5nnNlcPKLoHBBwDDIJFhyhq3ZEMXRiTas0XBxm2RfcVoi/8Bu2N8WypZyIboSlYscYIoEiU/iiH5E2UukEx2dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VCU80cMnu4NBguPmpl3gVmyHvchoNfmxigi/QuCjG24=;
 b=B520LWnzr880w9Vc+Q3+CwVcrlolErCiRhhC7UzzJM+J8+SSd08UQFFSwa9h45AUBnZPzzs9WdDQSWL79PJEwyFW68ZBAgH5v5S6cc33kRaG8IIQ38gNX8YX42DkszATEbJSc5tyoKhk1CrCX2XRPh1u9spx3yQtLbFxs7hrhUk=
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com (52.132.153.155) by
 MW2PR1501MB2041.namprd15.prod.outlook.com (52.132.152.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Fri, 21 Feb 2020 04:31:47 +0000
Received: from MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30]) by MW2PR1501MB2171.namprd15.prod.outlook.com
 ([fe80::492d:3e00:17dc:6b30%7]) with mapi id 15.20.2729.032; Fri, 21 Feb 2020
 04:31:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Kernel Team" <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up
 logic
Thread-Topic: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up
 logic
Thread-Index: AQHV6EJeBdbYanYghUmfMfeqLY6PiKgk5oeAgAAlVICAAANGAA==
Date:   Fri, 21 Feb 2020 04:31:46 +0000
Message-ID: <51BC422F-DEC7-4CCC-974C-48A6B50022FB@fb.com>
References: <20200220230546.769250-1-andriin@fb.com>
 <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
 <c7df7db0-0c47-37a5-0764-ee45864f7e55@fb.com>
In-Reply-To: <c7df7db0-0c47-37a5-0764-ee45864f7e55@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:f273]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c126d9f-8f34-4b59-3574-08d7b686f658
x-ms-traffictypediagnostic: MW2PR1501MB2041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB2041A2B36BCD3CCC86F7EB0BB3120@MW2PR1501MB2041.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(396003)(136003)(376002)(39860400002)(199004)(189003)(53546011)(2906002)(6512007)(6486002)(81166006)(4326008)(186003)(71200400001)(6506007)(86362001)(316002)(8936002)(76116006)(66946007)(6862004)(33656002)(54906003)(66476007)(8676002)(36756003)(66556008)(64756008)(66446008)(37006003)(6636002)(478600001)(81156014)(5660300002)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2041;H:MW2PR1501MB2171.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fy7QQafe80MulrrBMLWvejgOuHImyG0FPXX8ebGWEjyYheUNjK5TnrWza4w+5sBzOtWFeiG7sYPqHzKu77+8Qz5uYeullHkx87/12o0lK2wixKvSOigc71wIw56QlFztEyMTrXkO8m+3ypIhaEV6iwh0Iu5Ioz9LbV6ZlPwIOMmBnTBLPZ0QJtoLg1fiSHX/Os8BDlKaxhUUhaKXxMBVvd0lF3u12oHXy9XkI7f92/2iw2mW0H/+GXgTPTb9rKkS69WjPCt4lFmew7FDNzjRaifq9qw1ZevSQ2pB5+Ae648bYZ7GwqlJSS1yXO/eXwAdG0Br0yT2jhUFOd0GKbu0TGqgUYYa7dQyA5n4TgSHSFyP5dDUoLArTLIuXvUs6WuCiX+Xps7pWojVd1CYjvU4kfT2XcSLlLqNek0KcsTtwmI5l7+uDoOGyvFTx8OYL6ko
x-ms-exchange-antispam-messagedata: AGF3v0w90eAMxAYcG1xU9TH39s02jwiz4EPSaRk6srZtmpW4Ht2XJ/H/U55osjGHXftYYZuzc+eIl2kSNYGNbXDw80os+iR7sKGOFJTPaU3eerdmgJJXpS1CoTSaC7Zy1S6hkXbm6+ouzBn1QFzeziLfVDvcYFwICPgvYr2q9yxJ/UW0+5sVUY58rdmrH+Kz
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4333C918C40FB443B92D29E45D08E20E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c126d9f-8f34-4b59-3574-08d7b686f658
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 04:31:46.9464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upcJAyte6Rt5SZq5IFGP5F5/2WErevY3WjzBW67YZ6rM36P5XL2wB0JkEwJbp4i4ZKpIiYKcRuWvAWZCrQEm5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2041
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_19:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002210030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 20, 2020, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> On 2/20/20 6:06 PM, Song Liu wrote:
>> On Thu, Feb 20, 2020 at 3:07 PM Andrii Nakryiko <andriin@fb.com> wrote:
>>>=20
>>> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_obj=
ect
>>> clean up is performed correctly.
>>>=20
>>> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines co=
unt")
>>> Cc: Jiri Olsa <jolsa@kernel.org>
>>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>>> ---
>>>  .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
>>>  1 file changed, 18 insertions(+), 7 deletions(-)
>>>=20
>>> diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c =
b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>>> index 1f6ccdaed1ac..781c8d11604b 100644
>>> --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>>> +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
>>> @@ -55,31 +55,40 @@ void test_trampoline_count(void)
>>>         /* attach 'allowed' 40 trampoline programs */
>>>         for (i =3D 0; i < MAX_TRAMP_PROGS; i++) {
>>>                 obj =3D bpf_object__open_file(object, NULL);
>>> -               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PT=
R_ERR(obj)))
>>> +               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PT=
R_ERR(obj))) {
>>> +                       obj =3D NULL;
>> I think we don't need obj and link in cleanup? Did I miss anything?
>=20
> We do set obj below (line 87) after this loop, so need to clean it up as =
well. As for link, yeah, technically link doesn't have to be set to NULL, b=
ut I kind of did it for completeness without thinking too much.

I meant "obj =3D NULL;" before "goto cleanup;", as we don't use obj in the=
=20
cleanup path.=20

Anyway, this is not a real issue.=20

Thanks,
Song

