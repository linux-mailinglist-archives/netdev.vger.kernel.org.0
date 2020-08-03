Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CDB239E60
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 06:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgHCEea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 00:34:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40606 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgHCEea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 00:34:30 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0734V4aJ001469;
        Sun, 2 Aug 2020 21:34:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=gMH0HTZK7CF6y1/RkOCuhETqTHqxOy7TnZzjdJv1MGU=;
 b=EqBEjP9y4NCC9KaG6BoOWmgtagphn+OAyBzJaQJKLjDbvGvb1dgNz5smoNjBFt9PmCIZ
 kC7MJ/vEnh6E2pWTeXKiV07M3MREwgH+lKbd6iYjsh6zLuK6A0c30+sBfBx4zV7R5dFl
 677dcBXIfxo+IVMzWe/amnYOZ4skliJqWX8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32n81y55hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 02 Aug 2020 21:34:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 2 Aug 2020 21:34:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7nZCyyEZzHp23JYWJ0pSExAycYa8CTH7R6BRrm13RbYnzYZmRDA7kq+Jb6baN7nqWIpNe4Mi1Ly0lHx73jCY+sVv9W9qvurddmhagVEE9IcVnt7CuFXfUHHxFWBRRvqtTbPqBzJpRAKKUXUd0gMBu7djmDzA6eqXJetG3Djm1VYkEsmyphy4uEKSb1ozdeYgL1rPigtKJ2obW4iSZ68nZE7olevq1TTDUT0WdohbIDoFWJFnZoF9AEKzb5wP2eNrhqX70f3zaZWuq2ckxinT8bwOMPwFefPhhjF4AMmx4SsMl0GI1E/V5bo3Eg1siqz4tF9f0j4CDl26qOMOy5wuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMH0HTZK7CF6y1/RkOCuhETqTHqxOy7TnZzjdJv1MGU=;
 b=FDwuyLfjAi4GiKf0DfqZte0Wygit9BjE9guBJynKxVjG5SoORmzlR0d3mtXYFMDIrLTwVeclfv1pknsr0gr8eBYzPQgZ+w7uCqAmGALq1VnO3Meo5mpSvuUhrqoY5YZYa35mAkS62BuhkYsd7vQK9uosmv12yGDIagybV+hWI9IolplspKtKf3FFn0tRApZo7eE4kwbfN8ikrwVpz7ddgsBZAsfwdPpCV+cWf+w3E3Rol9ZoRaF6iP6duTf33MVGBNRfbeWYV4cb5jm9L5leTF500TGwGiKUrA03MV8vuhEnecoE+nyfqkwSqxjSTTbgQ3ys4UJ4Sk/hDjw9mYYPwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMH0HTZK7CF6y1/RkOCuhETqTHqxOy7TnZzjdJv1MGU=;
 b=MmQgYjSiACCyPWiz9n2Jcg2ZFptTTzobkWjQ4kTKIJb9qraD+MneacehWP/iAYdiJLuYya4VeZ5ERpr9lTkO9CpexR9Edmt5Yn1IXo6NyXDhi7ROgVl/32YVexFaD9CG6Ii6ZkJr1cXlfmgx6tT5T4Jk1SyoUJYDYg/oF3JTXSM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3095.namprd15.prod.outlook.com (2603:10b6:a03:fe::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 04:34:13 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 04:34:13 +0000
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
Subject: Re: [PATCH bpf-next 4/5] selftests/bpf: move two functions to
 test_progs.c
Thread-Topic: [PATCH bpf-next 4/5] selftests/bpf: move two functions to
 test_progs.c
Thread-Index: AQHWZ+DA9CvaBNz/QUmycqRUCCCr7akloBeAgAAu0wA=
Date:   Mon, 3 Aug 2020 04:34:13 +0000
Message-ID: <BDD6B621-0161-4261-B375-EC39EFA42435@fb.com>
References: <20200801084721.1812607-1-songliubraving@fb.com>
 <20200801084721.1812607-5-songliubraving@fb.com>
 <CAEf4BzY44oYFXRPeG1y3W96xrCR2muGpeKJ7XHQ-3EpaZ__Veg@mail.gmail.com>
In-Reply-To: <CAEf4BzY44oYFXRPeG1y3W96xrCR2muGpeKJ7XHQ-3EpaZ__Veg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4c37604-e24a-4d2e-f422-08d83766795e
x-ms-traffictypediagnostic: BYAPR15MB3095:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB309560B4C7E9AAB87934C53BB34D0@BYAPR15MB3095.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zqebBv6eUROgCVGAfbVenCs0GS4tdYqzwIvtOn84podKiB/brB7su/kvh2Xw3Qzr2YH+4oAfUX2BV+6TbSiBCv6BUXc84oKsOXMlrsxjQPWaMOxau7YP/PZARZN3/nqz6vPi8WBYSqL3BuOvGSwRpbCiZuBSxEhQ5E5iS2E8gyMmK7ffEImx6yMwhT237+27lczMvPKd/YLXCLipg3+RcV4romPtVpejemBHZh5+tzul4Nhe1GJ3uQFHmUogrBR8lK6LkQ7zP6/9pnropMZ3kZT0Mmmr0WeXU0Tyh04CPOD1NuizAStkw+dUdAdYqiXaLMkUdjSE1SFZRAt/WvJyYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(346002)(366004)(376002)(396003)(6506007)(2906002)(53546011)(86362001)(36756003)(6486002)(6916009)(64756008)(8936002)(54906003)(66476007)(66946007)(66446008)(4326008)(76116006)(71200400001)(5660300002)(2616005)(83380400001)(6512007)(33656002)(8676002)(316002)(478600001)(186003)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 8zKohMmMYa5ftWxqfLWr8ld6ZqLFJYZkWoqoWQtmv+P7wJ+GroYeDKUNT9ha9ltuJGqwM/belR+EhZ5SniPDx7XM1v3LbzTJHDZhQtOj3gyM8q/kXTmzyYzsl/HM2wBdyBT9Kw7xAqn3Ub35xEDOwBxYj790hQm1hzbiQX4xK0LH8KQcuUhLAMVg4YrqdbmNIw/eMh2Jj1FAAt7vUak/v8j54fd80qs0OoCWqIteNyXklbAuAP2Xmac8UynYX9JmjnJX+aDPg2U4sE60UDEZ/n7TgPz/ko3WFgeSIz1Bgzns3mJikiBW6zNDx8DPv6yvwWve0/9CDITjiCpHIvYwFFwyBQJc6GxbXbYqSVcUtG2RlmEDY24EwOhsADUEXKTYQiC1GZDZUALsT8saEjILggzgMamQauJxG6DS3bPp8laQJB3ft0v2Gzuz9QRBEfR7J5GBG6kiySsMAR+sfgrWwGlz1YSl5LYfwIjKoKsH10yHu1aaDW64WI1YocsEM1xZZLpmSkOz3jJlPGXXT4d5QbuQkos3IMdED1g9icUlA8hX8iKBEkqID4fMz47LuMfHBXlomcWzOsBDYC1yjrv995NL49lWt7rl1zxatsVFqL89Qx7NTW7vMR4e/kdkEyBrP5trBDbo9WnmOTP6FEHBiuam9T4g1djtBrpdQZhBZMs=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C0090B8563662B458AF8598C04A138E4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c37604-e24a-4d2e-f422-08d83766795e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 04:34:13.4003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G+Xn6Ik6drbD46p7CtYyMiJ6ez59RQC3kW0nTsUem6/CaHEYvAxH8FrL+WCKEwoJOg85cFzuZRb3CtWhX/YsHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3095
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-03_01:2020-07-31,2020-08-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0 suspectscore=0
 impostorscore=0 adultscore=0 clxscore=1015 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008030032
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 2, 2020, at 6:46 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>=20
> On Sat, Aug 1, 2020 at 1:50 AM Song Liu <songliubraving@fb.com> wrote:
>>=20
>> Move time_get_ns() and get_base_addr() to test_progs.c, so they can be
>> used in other tests.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>> .../selftests/bpf/prog_tests/attach_probe.c   | 21 -------------
>> .../selftests/bpf/prog_tests/test_overhead.c  |  8 -----
>> tools/testing/selftests/bpf/test_progs.c      | 30 +++++++++++++++++++
>> tools/testing/selftests/bpf/test_progs.h      |  2 ++
>> 4 files changed, 32 insertions(+), 29 deletions(-)
>>=20
>=20
> [...]
>=20
>> static int test_task_rename(const char *prog)
>> {
>>        int i, fd, duration =3D 0, err;
>> diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/se=
lftests/bpf/test_progs.c
>> index b1e4dadacd9b4..c9e6a5ad5b9a4 100644
>> --- a/tools/testing/selftests/bpf/test_progs.c
>> +++ b/tools/testing/selftests/bpf/test_progs.c
>> @@ -622,6 +622,36 @@ int cd_flavor_subdir(const char *exec_name)
>>        return chdir(flavor);
>> }
>>=20
>> +__u64 time_get_ns(void)
>> +{
>=20
> I'd try to avoid adding stuff to test_progs.c. There is generic
> testing_helpers.c, maybe let's put this there?
>=20
>> +       struct timespec ts;
>> +
>> +       clock_gettime(CLOCK_MONOTONIC, &ts);
>> +       return ts.tv_sec * 1000000000ull + ts.tv_nsec;
>> +}
>> +
>> +ssize_t get_base_addr(void)
>> +{
>=20
> This would definitely be better in trace_helpers.c, though.

Will update.=20

Thanks,
Song=
