Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B88634DD69
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhC3BXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:23:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2334 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhC3BXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:23:33 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12U1JOoi013594;
        Mon, 29 Mar 2021 18:23:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tIRGXuEHWUDpaSW28KT9LG2kGaPO3E2qngQnKlIaRsg=;
 b=WW/waA9TQn+n9EUYu43CFZobkxuM1r02WlW2v7Fy+/wcGVbmmuu5c3gd5G2pBmy5joC7
 cmMzMq9WbhuIQVuB6iPLd1sxBdvcbBls5PlxprVC8xyVoJQ+z3f3xV4EPpBi5IYaoE0E
 VpREZ476jGD/LOdsnVERHaiTSxFi5/LDA44= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37kdyt4hy2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 29 Mar 2021 18:23:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 18:23:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m3mn6trVPUuxEoTpHhGXe848pdwWN06W3P4NL6DhyDsSj5Q1dQ2/dR32AZVGyGlPI+CxNT6OfexwfEFUbuAOuFU9fxb3DVDcjFOdtKplpE0qPi4HfZkV8u7ygdP4vZ7SI8eScV7gnJYIr+DqUFzj1UgrFVGWHywMUAHqtHrYD/OmmAp8/z9q/fDB46kSxq8UsK2V8zXqj2Tnmzq4LDE+q5mFBrweddeSFQ/oIIkTlqO6X83IcLm3FUlg/WFkULnhTsgNvMgUnMcibeEi50ELf6XyzdjeiXzYRD1V8pdqJ8eAgMOSY9/XOk0641ANyJKm3VzzHTlNeUy4JhtzbfXjPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tIRGXuEHWUDpaSW28KT9LG2kGaPO3E2qngQnKlIaRsg=;
 b=geMwSFuZEkfD/pFTaWMyAuy1QyIDjNJD/8c0OTSW48hQgDLWzutsKrep3+OK2QnNq+CpjCf/z55xlUuyYb+StD861u3r7VBgwzTWnUwnrdHaj8hrmcNQ1j13AZWKsvU2uNuV8qSIw0K84xFVplE/XDRQAAOfEcjFlRU1qpNcXQxHxzZVsZGlZ3y5PXua6OSQAPe1EPXpbvWlh+fiXfnT+MZj0fv2GiNhmnCQP7stEeAUXJ+68bRxAhmEY5xTewBzLo8fNwL/5qh1SDb/FgwqINuNkOKXZplGDfC8xYvLKG5ybKdmiPhKhny0d89gc3Tr2r/xxgZlSQvUWqM/le++vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3509.namprd15.prod.outlook.com (2603:10b6:a03:108::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 01:23:15 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 01:23:15 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [RFC PATCH bpf-next 2/4] selftests/bpf: Add re-attach test to
 fentry_test
Thread-Topic: [RFC PATCH bpf-next 2/4] selftests/bpf: Add re-attach test to
 fentry_test
Thread-Index: AQHXI8VBnFAABYj2JUusjjOShGD3lqqbvvaA
Date:   Tue, 30 Mar 2021 01:23:15 +0000
Message-ID: <A0B730F5-758F-4F28-9543-4ED08F0BDECB@fb.com>
References: <20210328112629.339266-1-jolsa@kernel.org>
 <20210328112629.339266-3-jolsa@kernel.org>
In-Reply-To: <20210328112629.339266-3-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:876e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92822cb6-a84f-460a-b785-08d8f31a6484
x-ms-traffictypediagnostic: BYAPR15MB3509:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB35093F026C902B93098771B2B37D9@BYAPR15MB3509.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7KK/zXkmiMmc0b3kfb9qZF+7MQdTNhuLe3rG8/8LxxniM1reA85EyU5/hIQEg0bGrh+ye6AK4ECOjZDg39Cx/JmKj3HhTa8POgi/fEiKZei5loBEyTacQt5Bvu45X6c7EhF5bSWe+2M1SPXR2oA4+gIQleCTVDcWsyBH/9dMGyaVrf5R8WcILj9xAocRsdqZKKScGegpVBAIGWZMDhGNsz/dWqVsQ9vFZ+wsZ/eoPuSyykEKNckp51bslUUFkdrd7tcyM3+Pkb6b0mxaLNW8sxHYUE36xxrpJYf49OAv9H7WU6pTZMu4brn/YqiRym5LH/ZKKiaLNCF43+53rJVnKakXjdZO7rhk/LSNDTbBCuviJAeHo2Hy0o854g53isOiOb27xY+q68i9IDgvQWieHPTql3Ubijh6GJf689OvjtYoGVrseCw5MTFs+L7jelfT2gIf3VTFzlEWPDENhHDlgnLIFrWyE6+AV1xhH1cMr0bWsVfLRBZfct9DbwbMc3T07V46P9+uAPmjYeosM9GvyuB9PmKQIOgkcAOxAgWs9iLQyhEOfejiUE4SoAN5HbZzNSbKlY0NNXrgxS35zS0avu0coZc2ENay4HDNse1InaaceWxtbZgxxhL2XUSjlyHetpkgMNLA3NhGC48vGP5Uq80OqYY+6E1Z37oNFLVGHVdJeUlqGjC+S1IeC7J0SwyZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(33656002)(38100700001)(86362001)(4326008)(66476007)(71200400001)(36756003)(8676002)(6916009)(6512007)(2906002)(478600001)(5660300002)(53546011)(8936002)(186003)(6506007)(316002)(76116006)(54906003)(91956017)(2616005)(6486002)(66946007)(66556008)(64756008)(66446008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?/qmDUQjA574Aq4dqQ4QdPdCskam54jyK7uAulbJOj8QkbvVGNOzij/xfbW?=
 =?iso-8859-1?Q?tnlO1DrwKU4MPDIRNN6Nx9Owu5e1DXqRFYyIe/F09jQJuol7gp4u+pNzt6?=
 =?iso-8859-1?Q?NISQmGpQPsKZsuvjpc4nLoAE9I2iK9AOV99u7H+7ub30Rx4O5fpW01c7dU?=
 =?iso-8859-1?Q?jKDnLQWg23MPj7hzQb7AU3E/DqNkCqaSexJd+N01r2v9Ea5bkzVJe87mgR?=
 =?iso-8859-1?Q?YWggXhOs10iqj74oGbXdsZqCTR3EAH3JMC2yVYPEqK9uR0s5b8NjMBV1Ui?=
 =?iso-8859-1?Q?K0qLyCYhUCnzoO5D33b94GijD2ij7dKTew4pqk9glG2vJiga9sFLaF+ZZt?=
 =?iso-8859-1?Q?pb5MWx5xeEc/vMr6Wn7EgUR3BFtn2VtJZjALiQgY6TMcfRqmwFCjcRa5YF?=
 =?iso-8859-1?Q?k3Dc/AYT0/g+ut1oilNNPnUr1jGKREdCNpl4RVN49jbmE+f8QB5O/6aLPy?=
 =?iso-8859-1?Q?cq+JIEE7PfAlySmmv+2FH8zLmyn3ErIeCWY5Io2j64NQOQ49AXNFRG96oP?=
 =?iso-8859-1?Q?Q+cPmclxAnuRTPblALJzbRdu6jsJCYbQ6kUrNLUM2JwLJ6W19sb7DzrLtV?=
 =?iso-8859-1?Q?evulrnOyJQbcI98SWPhzRK3ur3zV5a+20zkJI3hsU09O6/YvuoAxBWJo8P?=
 =?iso-8859-1?Q?K+AUbR8JpDjaCD1pKQWT632cjR60J2xHZvQH84yWzQ7jMibfCdd6Y0WN1z?=
 =?iso-8859-1?Q?Eqz0zbUQMMe3YYNLWJiTSxiEScfLwxz41Rw4ucsFNvdBf2VwFaLG/yjaHF?=
 =?iso-8859-1?Q?4oLDq8zTY7/nT4RAPiS4A7ctOHd3xQQM0KwRjbBEqhNvN+UNVGvpBy7GyU?=
 =?iso-8859-1?Q?E0txLegGjHBVVNdZOu9ikTx3YLu5QCKECUq+zJmMAnb55IUuxZf8fEO8Xp?=
 =?iso-8859-1?Q?aTL7OIeXyX1WMnRLn110b1UPUQiFIXzBZar29ZiFQ4XWkfv+yBqGPJAd2e?=
 =?iso-8859-1?Q?1SF3DZB0STlNOWO0j7uWbGggz1dK6zPEA7V3G8lh0w1iSg23vOxUE8VQ18?=
 =?iso-8859-1?Q?Ho3N3d6KqQoCGbDGssDzEDiTFB9m/Xe8R5cQoamcwTWmE80nx8aeyZMOTH?=
 =?iso-8859-1?Q?kNHTC5C24TV+HuQnmV9BWCqFXrW2RP8RUyiZiOFWu6kfEmutQcekGjd46P?=
 =?iso-8859-1?Q?VF0WLP/YDVBLiA8jAFSelIR7X29IvfZHrBwvpUOxvdKoasjqf5bXDc1fk0?=
 =?iso-8859-1?Q?Krwd2uEcrfU9Z8QGJZkonNMuoe3KxZx9p5tlSSi61QDeK6KrnUjeyV3kwp?=
 =?iso-8859-1?Q?AwlyOXdc+mq7DaXwhj89nqhMtJeAfF51ZQqc4O6oGnsz/h27KbLCwhUZwy?=
 =?iso-8859-1?Q?ilWHJOMI5/4uxfb6lRQpAhGkfTkvCmxHT1vSi+ASMtr0eFJtFhc3145jy1?=
 =?iso-8859-1?Q?cvqIQffoEYxfXDb2ECDzPicWT0U59Bl0amLoBKlrjZ1RLelaJe0GY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4545A7D995E42A46A80484AE1042353A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92822cb6-a84f-460a-b785-08d8f31a6484
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2021 01:23:15.3614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HMUXjAqtVAWVrTrLrlBHVWtrRNKO4yjjEKOJnsEAvYHBTGvk2zMzAy43RDUuQtYtD7h6bJfB0TbTjmvoF3sv7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3509
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: 8XNGAGAeDlaBLd4KI3CpcDRcRT4f-dWL
X-Proofpoint-ORIG-GUID: 8XNGAGAeDlaBLd4KI3CpcDRcRT4f-dWL
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_16:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 bulkscore=0 clxscore=1015 phishscore=0
 mlxlogscore=879 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2103250000 definitions=main-2103300007
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 28, 2021, at 4:26 AM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> Adding the test to re-attach (detach/attach again) tracing
> fentry programs, plus check that already linked program can't
> be attached again.
>=20
> Fixing the number of check-ed results, which should be 8.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>=20
[...]
> +
> +void test_fentry_test(void)
> +{
> +	struct fentry_test *fentry_skel =3D NULL;
> +	struct bpf_link *link;
> +	int err;
> +
> +	fentry_skel =3D fentry_test__open_and_load();
> +	if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n")=
)
> +		goto cleanup;
> +
> +	err =3D fentry_test__attach(fentry_skel);
> +	if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	err =3D fentry_test(fentry_skel);
> +	if (CHECK(err, "fentry_test", "fentry test failed: %d\n", err))
> +		goto cleanup;
> +
> +	fentry_test__detach(fentry_skel);
> +
> +	/* Re-attach and test again */
> +	err =3D fentry_test__attach(fentry_skel);
> +	if (CHECK(err, "fentry_attach", "fentry re-attach failed: %d\n", err))
> +		goto cleanup;
> +
> +	link =3D bpf_program__attach(fentry_skel->progs.test1);
> +	if (CHECK(!IS_ERR(link), "attach_fentry re-attach without detach",
> +		  "err: %ld\n", PTR_ERR(link)))

nit: I guess we shouldn't print PTR_ERR(link) when link is not an error cod=
e?
This shouldn't break though.=20

Thanks,
Song

> +		goto cleanup;
> +
> +	err =3D fentry_test(fentry_skel);
> +	CHECK(err, "fentry_test", "fentry test failed: %d\n", err);
> +
> cleanup:
> 	fentry_test__destroy(fentry_skel);
> }
> --=20
> 2.30.2
>=20

