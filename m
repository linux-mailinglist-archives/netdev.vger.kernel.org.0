Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530D9275180
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgIWG3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:29:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2826 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbgIWG3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 02:29:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08N6NEBq016367;
        Tue, 22 Sep 2020 23:29:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+mY1bvweafgngjpduz07R5KyEyubQVu/fj7mpawv3rc=;
 b=gwj4xdJn2CjT4f1Omz9OJXB8qqXs7XT7QwIkATQ/z+2RXL17BgU2U+5CfH8OzSXzEr1p
 IcxuXkHCHEldORcpN8vJi26cEOA33cXbDKIeIjhZfa+guI+ww5hAPdnnC10laqX4ssns
 L5XYE5p1zazvdRs5PI6vgY2+DZAUsv6bP/4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp4svhh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 22 Sep 2020 23:29:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 23:29:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dqYzdGUHHPcq5pAnv1uhknS7Uhtu52B9F4YbdZtNirNiccV/js2VsNytF1wpEDUf5LkQO7MppIUH7tTY6mNSWabz7NOXYyvNXmtpD8tKustrWQvx1ssWNXjRjkHdAEzs+9FNgr0kIxSgBsEpZDrLwxLl8x4gFpkMRrDS8Oe3W7VaalDDEJKzoyPoIyorI/f5+DLasVDoDj7zyCsWkOxbxpHiw0PCQEce1Cs+jmATMZIDLf2qOz6GxrKnth02e/POConEm8i38tKEwaiSlEBrNNpM0xbIYfHwARswfrt0qO0zwOindArmD7qXiN5B+JhttPi/V0NNAWVs8uglfrLoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mY1bvweafgngjpduz07R5KyEyubQVu/fj7mpawv3rc=;
 b=GFoJ0OiU5EDCDqXsKpu81V5WkwjMlwmOcHlClk49jTZajpGHNRKqQjvp/Cr4awEP2b8NehcWrx8w65xrRBg9dW1bafIFHwwcxeh4KAU1e9z5I0Jxs4/rDFbKMMWvtkyHwHoBH+7eeXkuA61zekqJDyqN+15rT6eDcW2PuRBaSiIcSHpK2viOXglSQIaTlvTVp73A8O4yYel24oIyExvCWxziPlj8Nulf6mgLfgrMESapOm0ZBr0sLDOuTbvZL+Yz+CQiTW/ajOog5Xw4sRIKq94CPhJVXIykKegXfHid8ihgC7bQIirnmNCKwoT4LnDP1sqkCE5qjvVj78TnAueY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mY1bvweafgngjpduz07R5KyEyubQVu/fj7mpawv3rc=;
 b=HRWW2qOEsXDVloRIbVRpLTxEGcrL9e9vHg3FZmPNKT3ZgxF+Rox/NQPp/CuCsKD4w0guz5No/NPK2vVgMPIzY1vhYfjOxTJL7aKf6AGCqzh8v4KsXcteHx7gpoyDaxErERatNu+eKNBd4zwJZfipj10qlSGuB5SqtI6TwG9Q+Ek=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 06:29:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 06:29:05 +0000
From:   Song Liu <songliubraving@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Topic: [PATCH bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Index: AQHWkUjpxT75mOp7JkeDAgbuFa2FtKl1py4AgAAb6gA=
Date:   Wed, 23 Sep 2020 06:29:05 +0000
Message-ID: <B97F9BC9-7A6F-4E7A-AE78-140B13D6EF81@fb.com>
References: <20200923012841.2701378-1-songliubraving@fb.com>
 <20200923012841.2701378-4-songliubraving@fb.com>
 <5f6ad3c63a2de_36578208a2@john-XPS-13-9370.notmuch>
In-Reply-To: <5f6ad3c63a2de_36578208a2@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:af83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33e3d321-8d7c-495b-2e96-08d85f89f8a9
x-ms-traffictypediagnostic: BYAPR15MB2197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB21977BC4873F7895447B3812B3380@BYAPR15MB2197.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YYx4Ae740CBj/T+pNWRF0yGF9L99jY+dH5i6OzObbeMqTA21rdF42haHv1N0p+7QCkNJUjHvyegnRUitikFoRsl/bexJsmMG2vdvLu55ob1ICRfZp+JVKZ5aK89fs7n64AvFKbV/6kyY5rpNymovPmf1dyjPwbZW3jQ1ZNYNYyQAf/RxcabF5w+onhJm8cP+07x9c7G4reVWczue9CKMj+eeTSkPoNI7GyUd1lrM/rxZ8AdodnIVx1U9vPhq3K56bFsALtLptUIZTvwWlLhQJPkkaSA/8bmMjYaM+oeuboR7nnEIQM8bBE98dZi50BmePeHo97L8jNjBpcPkdETxmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39860400002)(8936002)(66446008)(66556008)(76116006)(64756008)(2906002)(91956017)(6512007)(86362001)(66946007)(53546011)(6506007)(6916009)(83380400001)(71200400001)(316002)(66476007)(2616005)(186003)(478600001)(6486002)(8676002)(33656002)(4326008)(54906003)(5660300002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YRX6fHFUtNgKfIF95FIICD7+CYd8pKRhf71Yj+YgjZmcihq1FHVX2+TcBsh09Yobb3knTkH8cCxmbbu0dW7nejMtNZx/1UW2firUOz15w3gDYVXI7I0GfogcMheqiLCGJh0ge8f8AhZE2OKxWbf42Etr+/rv+bMt/yAfMxdQYKpkwlhnrk/ZdYOFt8jY/0P5qXahmWwRI9l0iz4UuR5mHMSN4CAoHtaRaBLIxzQeR6pBF8DaXQYwBNhvRIitY9nCGjfcZKtzFglYxD2V3hKE1VkwznBWxIFcT5pu4xSAaBSPl292eWZ4G5wRDHgJr3SgPxIwN1bdWbkI8RZmcNHz+ApLQNRbt04QSLSWSUWQ32IOKK8ra44Kq5gq3N63IWvbzZV0f2CTGo6D2FncEH2uVu8h+JncytzGTlrFuQ7u/jy160oyOrOQnyrIQaflHjX1qYl4Nw7eFjSdvuwgvmxYdE6n/uAxyIebsqszYTyIfvvEc+qpCqdiFrnorQDf1nZ+1XXHoLRqOnbyVDlyJ+QA59CzszcYDwCkvtde0wupGyfkIpSvu1nD7aG8FuG7CCQTsXr6ZAOwK1rHxAszzwhjlhXYHMsosWeNUMwJah3bSYQ6eNeSWit6TlDkvwVC8HSs0RA9geLASuGDkCp7fwMc+ySjFBHPDTafo0TrnrfXmi2cyXZRLMx7pFh0jEASk5Zq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <44949CBDB1309348867D6990EF7077BF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e3d321-8d7c-495b-2e96-08d85f89f8a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 06:29:05.8131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxJrc2/hbaCqTAt452oTT9Dno9RB1pa86+XfdyQac7TnUTe5H0ywxF2MQUJKfAa7NxP4+/zBGOtAlraz1a0rcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-23_03:2020-09-23,2020-09-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=770 suspectscore=0 bulkscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009230051
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the quick review!

> On Sep 22, 2020, at 9:49 PM, John Fastabend <john.fastabend@gmail.com> wr=
ote:
>=20
> Song Liu wrote:
>> This test runs test_run for raw_tracepoint program. The test covers ctx
>> input, retval output, and proper handling of cpu_plus field.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>=20
> [...]
>=20
>> +
>> +	test_attr.ctx_size_in =3D sizeof(args);
>> +	err =3D bpf_prog_test_run_xattr(&test_attr);
>> +	CHECK(err < 0, "test_run", "err %d\n", errno);
>> +	CHECK(test_attr.retval !=3D expected_retval, "check_retval",
>> +	      "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
>> +
>> +	for (i =3D 0; i < nr_online; i++)
>> +		if (online[i]) {
>> +			DECLARE_LIBBPF_OPTS(bpf_prog_test_run_opts, opts,
>> +				.cpu_plus =3D i + 1,
>> +			);
>> +			err =3D bpf_prog_test_run_xattr_opts(&test_attr, &opts);
>> +			CHECK(err < 0, "test_run_with_opts", "err %d\n", errno);
>> +			CHECK(skel->data->on_cpu !=3D i, "check_on_cpu",
>> +			      "got wrong value\n");
>=20
> Should we also check retval here just to be thorough?

Good point! As we do use a different code path here. Added the check=20
and removed goto in 1/3.=20

I will send v2 tomorrow.=20

Thanks,
Song=
