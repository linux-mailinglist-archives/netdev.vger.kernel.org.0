Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB84A1470DC
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 19:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728925AbgAWSet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 13:34:49 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgAWSet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 13:34:49 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NINBik019481;
        Thu, 23 Jan 2020 10:34:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=75NiwwAgjJV6DnGBoawC1dxUbB7h1PrzcaUsJagFBMs=;
 b=IS1prM98FQYVSOdd3EHfXpgbJFxDADx28l3XRAVCKBppAY41x1emEFodqh8aZmfPNRx9
 FAgHQnoU4RtNC1TEw3SR6CV90AqsH9bVU9LG00TCMvCvEV1CdIbVCDgJtfcwpjBu5uic
 dA93EaGiD5U51x/Lva7xc9Eflm4HjBz5TTo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xqgc5r5rq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Jan 2020 10:34:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 23 Jan 2020 10:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZW2u7XdT5SycilaiUupMUYOGFFJwqP1JKwXUyBW00433L8s07c2EEjOMoHil23UTnHdtojUAEx0p3zSER1oZBoDEtfUmwIB5sdR4SC8p6pl3gDKvy0O28AS+yHzjLlkmd0OdfMdnb4XK26hkGuWFA3QyhtfiDusBf33ibMrr88HSjMsTGYVB+UrKRsRhtWXqkfhS8VD/nT1cCggg1Ues2qINplo0imfURlZiiPr0PP4kQEZZULKtTwEDVJ6F0ybvz7SqzLsSt7LGwsXx+GGsq55HFLu7gN8oF72jIGJw6gezvjMpPvo8xD2Bqr3uhPcFjSKLyMhGPGexIVyO5Q3ziw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75NiwwAgjJV6DnGBoawC1dxUbB7h1PrzcaUsJagFBMs=;
 b=DQUer0ZqhM/8DaC0RCOHHPcQwpBq44sHmY0xx7VNJnNhldlIVTYWjMOWI65knz6QjrGBayicZNMXaEGfqGsSco+oF25Nrk8d8GeZ3ADJbQtVCCFsv75C52SihFwgs1ei92Dm+4Y6PldkS/bkPixPUFYqNPXy0IC+uu0/Sxhw6tJ9oPz8NXnsBL2gS6vf+qzyZMkUyk9Wx+zhs2LkevmCMmL50NViMgDoS9MW/MyBZAe9RsaK1Yryq7baIvF4aF3nLoKu5xtVG4+yplSkntYsT5cgOnFE65oPgWrl2CfaRA/ijgGqjzL3w0dyzs2Kdjrhj1jwGcAVfMjF+3GY1kmUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=75NiwwAgjJV6DnGBoawC1dxUbB7h1PrzcaUsJagFBMs=;
 b=gAwbPOtULKaTOjsvQjaEJ4welcKhDpf2GJ/ItOC2sZjMTLOEvVUQ0XO9d/GYtFoZMSxiRFV4AlbKkKyRAitq9hbk1s4qfI1uuxbMvKglyTrBLjh+QPZztGN1LEmk9yX1+mlpycKyqJR4CYrpXaud7wv+VaKleKToBeH/eX3Po+U=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3182.namprd15.prod.outlook.com (20.179.22.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Thu, 23 Jan 2020 18:34:32 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Thu, 23 Jan 2020
 18:34:32 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::2:d66d) by MWHPR17CA0094.namprd17.prod.outlook.com (2603:10b6:300:c2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.20 via Frontend Transport; Thu, 23 Jan 2020 18:34:30 +0000
From:   Martin Lau <kafai@fb.com>
To:     Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
CC:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf 1/4] selftests: bpf: use a temporary file in
 test_sockmap
Thread-Topic: [PATCH bpf 1/4] selftests: bpf: use a temporary file in
 test_sockmap
Thread-Index: AQHV0g6PlHOQTD0hFEGeoXBT3XL7Yqf4k16A
Date:   Thu, 23 Jan 2020 18:34:31 +0000
Message-ID: <20200123183427.wsmwuheq3wcw3usm@kafai-mbp.dhcp.thefacebook.com>
References: <20200123165934.9584-1-lmb@cloudflare.com>
 <20200123165934.9584-2-lmb@cloudflare.com>
In-Reply-To: <20200123165934.9584-2-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR17CA0094.namprd17.prod.outlook.com
 (2603:10b6:300:c2::32) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d66d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69fe9c6e-b9b5-4290-fa95-08d7a032e337
x-ms-traffictypediagnostic: MN2PR15MB3182:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB31829E9A5377B00464B4A802D50F0@MN2PR15MB3182.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 029174C036
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(39860400002)(396003)(366004)(346002)(189003)(199004)(8936002)(81166006)(71200400001)(81156014)(316002)(8676002)(110136005)(54906003)(478600001)(6506007)(186003)(16526019)(4326008)(86362001)(2906002)(5660300002)(7696005)(52116002)(55016002)(9686003)(66946007)(66556008)(66446008)(64756008)(1076003)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3182;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PAV7rMMcJEShM3DTorvQ8H/LPrYL4fCWHpU02gS44c/NC/bQlYMqiVC5d5CaugLjKlFWjImqys8NXxSzwf4zRGCaOtnYDXFMaQWdxId4QdtVeXt0rhjr1UdRa2IDswZiwOzwSvgM8JFTya+MFCgndwSaK1dYmKsvesPo1KZ9h9VF+XmVkOFrmD8Gt9cu5bH/Gk7/ziltfcMIDdry0CbvxS7tFfw9Z4PyYpq4xEJkQjCzPQkNT0IwR9V9qlWO3Xkdg8WWAnEJ5rRkFL371jKroHaEtbfT2unA/szYdGSv+gx/Z+YVsdBly48/P6vhpj9ex3/2bKhPDd/k3KtVwxebAa56qTFHlocj0e9/2lBhMGt8Bm7awQ5y1D8KCVhhvDNft0jwFaj8ZCffVF54maIS5aE1/15hzssW5zSMRi79J2AD+M6A3rDQbI4RD4FA0cLj
x-ms-exchange-antispam-messagedata: Kt/Z1PzJ0aBMi4uT5KL2wWg07oCMugFSq+JqPA5cnnYMvOlMwMVfLmP/+kuwUtBw0Y+65v9pQvdQ/T09ISbQyJlhBC0oDWv266/ToJdk3rKzC6UzEffJ2ElYXH0bNHTmVyAqMTpm/uLwFNWtH1946OR2NL3VKKC6MmlEzjHyET/DQehALGpEB5q8cIb09Wzf
Content-Type: text/plain; charset="us-ascii"
Content-ID: <406A8A76E111A84FAC876779309A2CE2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 69fe9c6e-b9b5-4290-fa95-08d7a032e337
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2020 18:34:32.0728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VRRmyLcsM5qF5ClnTC/vIPL5D5plzkVj+5vR4CO5G7H0Ri6E1wGhRpwTFxRMAfSh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3182
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_11:2020-01-23,2020-01-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001230141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 04:59:30PM +0000, Lorenz Bauer wrote:
> Use a proper temporary file for sendpage tests. This means that running
> the tests doesn't clutter the working directory, and allows running the
> test on read-only filesystems.
>=20
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  tools/testing/selftests/bpf/test_sockmap.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/s=
elftests/bpf/test_sockmap.c
> index 4a851513c842..779e11da979c 100644
> --- a/tools/testing/selftests/bpf/test_sockmap.c
> +++ b/tools/testing/selftests/bpf/test_sockmap.c
> @@ -331,7 +331,7 @@ static int msg_loop_sendpage(int fd, int iov_length, =
int cnt,
>  	FILE *file;
>  	int i, fp;
> =20
> -	file =3D fopen(".sendpage_tst.tmp", "w+");
> +	file =3D tmpfile();
>  	if (!file) {
>  		perror("create file for sendpage");
>  		return 1;
> @@ -340,13 +340,8 @@ static int msg_loop_sendpage(int fd, int iov_length,=
 int cnt,
>  		fwrite(&k, sizeof(char), 1, file);
>  	fflush(file);
>  	fseek(file, 0, SEEK_SET);
> -	fclose(file);
> =20
> -	fp =3D open(".sendpage_tst.tmp", O_RDONLY);
> -	if (fp < 0) {
> -		perror("reopen file for sendpage");
> -		return 1;
> -	}
> +	fp =3D fileno(file);
It may be better to keep fp =3D=3D -1 check here.
It is not clear to me the original intention of reopen.
I would defer to John for comment.

> =20
>  	clock_gettime(CLOCK_MONOTONIC, &s->start);
>  	for (i =3D 0; i < cnt; i++) {
