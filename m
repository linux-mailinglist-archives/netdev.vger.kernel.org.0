Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5240F277E4D
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgIYDCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:02:20 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726704AbgIYDCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:02:20 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P2wGsD020283;
        Thu, 24 Sep 2020 20:02:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f/vXSUUtIRde0L+YNz2ZQuhqhacuyFJICbhT6f1gg5o=;
 b=FmbUuZxS72RG58VxjMA2qWgKhKKwJTOOmzA2yoWfotyYoWi/InX3jSKJ8ku8x45nL+oB
 bk2fY7iNkbFUS+iwR5oQGkwFRe623YYCiNdR7jjQtWcFb4pSsBbHwDBs4u0vMqQl+V0U
 juCop8sZAqpjOc/8xD3pey5eMxz4vw56xUo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp65fkr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 24 Sep 2020 20:02:04 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 20:02:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sejd0m8bd+8QgMRcraRxaRBpVL7+TScT8sd4t79zs8XbL7sNMeSq0zPOcu3AH0GexTDkKgGz3VWbtWNcmtygDzm5rGfAy8iN61fvUq0OyAkmTlMtbFTK6/3Veq5Cmnv6PbjsebRsFq7FPxOOjKqmQFEMfxZ4YtS884hwtdsyxArEmMxLatrQZ3dvP60CyZw35cCewTB8/QhFlfSuH6R7qxuUdAOfkoy1fhZLkgtV+q2aBjSId5tRoyFHGdU6b0cRjJnYE7a3JCkk7l0of8J3VAf6Efc9Pg8cGqivPSYpIcNMxMNLxWs1Nka78eYlPC4KUml08z7T7g2mTCeW7VdWCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/vXSUUtIRde0L+YNz2ZQuhqhacuyFJICbhT6f1gg5o=;
 b=oYmNot1rkkmoaK0gGuYtnLoSm5rS0YZe/sEXP7e/sUHr/AhPOH5R6AMu3a1S56/GnN+5M2mWyVk2accAKI+wxSPxFR47yLaPvM2tHVZ/wzCIQbjJnLjPQritlNt3EPiUIW5LC7Qga6m8AEZorJcDQPeiU7iKy4L7TV9349qPOgCRha7cxd9Y/Bfs3h9aNIu7gMsmjZIDgvgDkSgU+YpwbYmayUB6N05j6Rfh7Tt6DuEDav2ye5ByKQimrIjqKiXe1Ywb7fPOGocAxL1rn0ujBKVcFToOymXekZk2U9Xukg3QhuQTckLo3q5nVgR+PMMasYL2A5H2O8cZXYAtFlPrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f/vXSUUtIRde0L+YNz2ZQuhqhacuyFJICbhT6f1gg5o=;
 b=lVSBZpSlwgEtMmb4W1oOFF08slyhXj9CpAx2IpdXnXY/9guTPd04pjDoLIm6jkmbxTU2E/79/j7AUaWd+sunj6aNeYPU5MIm0IpsNRq5Rfyau6xqEgvNn7zHlRzuk8suAnbzXqCpD+CMOWaC1CR2XBbeOdFU1vOHF/WUzVFK4cg=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2327.namprd15.prod.outlook.com (2603:10b6:a02:8e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.19; Fri, 25 Sep
 2020 03:01:43 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3412.024; Fri, 25 Sep 2020
 03:01:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     John Fastabend <john.fastabend@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>
Subject: Re: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Topic: [PATCH v5 bpf-next 3/3] selftests/bpf: add raw_tp_test_run
Thread-Index: AQHWksbKGhOXDee81UOLFQzQJhghE6l4iUSAgAAhkgA=
Date:   Fri, 25 Sep 2020 03:01:43 +0000
Message-ID: <EADD25B3-73E3-47E1-B6CC-CFC4A849622B@fb.com>
References: <20200924230209.2561658-1-songliubraving@fb.com>
 <20200924230209.2561658-4-songliubraving@fb.com>
 <5f6d416d1b396_634ab20836@john-XPS-13-9370.notmuch>
In-Reply-To: <5f6d416d1b396_634ab20836@john-XPS-13-9370.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:cb37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 409d4506-25e0-4ff7-6b41-08d860ff5541
x-ms-traffictypediagnostic: BYAPR15MB2327:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2327F846D452A9AC180D7C9FB3360@BYAPR15MB2327.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vlmh2oUfv2czF0P+LmVuGGRi/FFcMOgswC+Pm1R8lwf7EIL5lv7Jw4qGRWxNV89ZPuh9bFOldXm+kghd/ogpKE1spyyk6Z9sLqfTZcJd3KoCprxMzBb+SxIhoo6nz4uP3q6zS79824rXFMeTUh9pgNAQILOQaeUOkoHWfqFKjqpqk2Hvvlgcy0PtU5X80l1CUNv+pxPcwNy9hAdz8i2qIeBJVwAVjEqV04M2DYeoio9ef4J/FQ2Xwyh3EKu4gCxgte3qTkFjXUPJg2BK3y9vX7aqFU3umFycrXDSt0CtCPl0C/upHr7EsM7WJRXDJ8wXmwH+PPxOXWS33YTZNoa6w2IBc9oqvKgKtpvHAXP8Scwg0zJikC1PIwh/oYat2krP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(86362001)(33656002)(6512007)(53546011)(5660300002)(91956017)(66946007)(2616005)(71200400001)(83380400001)(54906003)(66446008)(64756008)(66556008)(66476007)(76116006)(186003)(4326008)(316002)(478600001)(36756003)(6486002)(6916009)(6506007)(8936002)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wjeWGvq9DTbzLTpRETsFNoXoe8LG9K5EmsqNTQkEBNKxeEet/twCp4wUd1fIptVIk4Bg9vyKVODuKqaPEa+Tl96P8GTIEZfDRqEsJ3ehSyXI9F2/CyFI/fEnvdjNCIUR5V8xpV3YYu4v7OSFSqimwVRc/kigVR4zWnKHFUDov9e9CRs5XCAc997eBev2PQezBl48mItt5sOxEGdzRb3VzUAZzVrAhJ5RAmP5//4eYZBpaKNzQkWt51D0UvaJ7jGgXOK8zfH2cy12/eDTf5Nxz/FLHaPJQqikjV0Ffa4A3RGrF41oHAUaSeJxtAWn3UEM+Tf5WiVfgnVIpjhwX9skw0YOLDKEhwZx8oh4xtsRzc4h1NTg9MO7If39nMo3XOPDBjeYXputoDNd+dl1Lo6Gb9ZbhpYx0PBMktIoYnZrvZ/OEsG9F8xXXhyeknXbB5eSaW7nsFO7rPiXXXtdGxDzkhoBY/C9qbtnQE06npjhM9iew4oXAf2FtBXcHF6XSfIcB+g6VdiNv0sxd9loQgMiMgiVcOSxzuPBYp5D6CWF3lzSLtsHzL2S1Sdo/4sWiUEcnBKJEiS93pU5slY0eI5Zgv6AUTiHtwHJg97NaD8OdWgqmByVjSZTenVHY0xfiNMvTtjEg6xk7VbDjlD6wDyVwTcEAwqRnOZJ0sfeqvcfqD/woA3ZqfmPk0uz0vfrtUrh
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C787FB7ACF311E4C950403E710EDEC5B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409d4506-25e0-4ff7-6b41-08d860ff5541
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 03:01:43.4813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UIid/BDqJD1E5olhsjLRgi4AWWp+cZf05h9GGa2VBn6IsWazGTFcsfT1KmoYOoYoJ2keTxY0s5Fe4nv+XGUosw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2327
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_01:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 suspectscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 phishscore=0 spamscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250019
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 24, 2020, at 6:01 PM, John Fastabend <john.fastabend@gmail.com> wr=
ote:
>=20
> Song Liu wrote:
>> This test runs test_run for raw_tracepoint program. The test covers ctx
>> input, retval output, and running on correct cpu.
>>=20
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>=20
> [...]
>=20
>> +void test_raw_tp_test_run(void)
>> +{
>> +	struct bpf_prog_test_run_attr test_attr =3D {};
>> +	int comm_fd =3D -1, err, nr_online, i, prog_fd;
>> +	__u64 args[2] =3D {0x1234ULL, 0x5678ULL};
>> +	int expected_retval =3D 0x1234 + 0x5678;
>> +	struct test_raw_tp_test_run *skel;
>> +	char buf[] =3D "new_name";
>> +	bool *online =3D NULL;
>> +
>> +	err =3D parse_cpu_mask_file("/sys/devices/system/cpu/online", &online,
>> +				  &nr_online);
>> +	if (CHECK(err, "parse_cpu_mask_file", "err %d\n", err))
>> +		return;
>> +
>> +	skel =3D test_raw_tp_test_run__open_and_load();
>> +	if (CHECK(!skel, "skel_open", "failed to open skeleton\n"))
>> +		goto cleanup;
>> +
>> +	err =3D test_raw_tp_test_run__attach(skel);
>> +	if (CHECK(err, "skel_attach", "skeleton attach failed: %d\n", err))
>> +		goto cleanup;
>> +
>> +	comm_fd =3D open("/proc/self/comm", O_WRONLY|O_TRUNC);
>> +	if (CHECK(comm_fd < 0, "open /proc/self/comm", "err %d\n", errno))
>> +		goto cleanup;
>> +
>> +	err =3D write(comm_fd, buf, sizeof(buf));
>> +	CHECK(err < 0, "task rename", "err %d", errno);
>> +
>> +	CHECK(skel->bss->count =3D=3D 0, "check_count", "didn't increase\n");
>> +	CHECK(skel->data->on_cpu !=3D 0xffffffff, "check_on_cpu", "got wrong v=
alue\n");
>> +
>> +	prog_fd =3D bpf_program__fd(skel->progs.rename);
>> +	test_attr.prog_fd =3D prog_fd;
>> +	test_attr.ctx_in =3D args;
>> +	test_attr.ctx_size_in =3D sizeof(__u64);
>> +
>> +	err =3D bpf_prog_test_run_xattr(&test_attr);
>> +	CHECK(err =3D=3D 0, "test_run", "should fail for too small ctx\n");
>> +
>> +	test_attr.ctx_size_in =3D sizeof(args);
>> +	err =3D bpf_prog_test_run_xattr(&test_attr);
>> +	CHECK(err < 0, "test_run", "err %d\n", errno);
>> +	CHECK(test_attr.retval !=3D expected_retval, "check_retval",
>> +	      "expect 0x%x, got 0x%x\n", expected_retval, test_attr.retval);
>> +
>> +	for (i =3D 0; i < nr_online; i++) {
>> +		if (online[i]) {
>> +			DECLARE_LIBBPF_OPTS(bpf_test_run_opts, opts,
>> +				.ctx_in =3D args,
>> +				.ctx_size_in =3D sizeof(args),
>> +				.flags =3D BPF_F_TEST_RUN_ON_CPU,
>> +				.retval =3D 0,
>> +				.cpu =3D i,
>> +			);
>> +
>> +			err =3D bpf_prog_test_run_opts(prog_fd, &opts);
>> +			CHECK(err < 0, "test_run_opts", "err %d\n", errno);
>> +			CHECK(skel->data->on_cpu !=3D i, "check_on_cpu",
>> +			      "expect %d got %d\n", i, skel->data->on_cpu);
>> +			CHECK(opts.retval !=3D expected_retval,
>> +			      "check_retval", "expect 0x%x, got 0x%x\n",
>> +			      expected_retval, opts.retval);
>> +
>> +			if (i =3D=3D 0) {
>> +				/* invalid cpu ID should fail with ENXIO */
>> +				opts.cpu =3D 0xffffffff;
>> +				err =3D bpf_prog_test_run_opts(prog_fd, &opts);
>> +				CHECK(err !=3D -1 || errno !=3D ENXIO,
>> +				      "test_run_opts_fail",
>> +				      "should failed with ENXIO\n");
>> +			} else {
>=20
> One more request...
>=20
> How about pull this if/else branch out of the for loop here? It feels a b=
it
> clumsy as-is imo. Also is it worthwhile to bang on the else branch for ev=
ey
> cpu I would think testing for any non-zero value should be sufficient.

I thought about both these two directions. The biggest benefit of current
version is that we can reuse the DECLARE_LIBBPF_OPTS() in this loop. Moving
it to the beginning of the function bothers me a little bit..=20

Thanks,
Song

