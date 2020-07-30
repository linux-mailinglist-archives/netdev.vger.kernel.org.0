Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085D6233A40
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730452AbgG3VDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:03:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58630 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728630AbgG3VDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:03:06 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06UKxSKv018168;
        Thu, 30 Jul 2020 14:02:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=QOLxo0nE+gMW6HqUYHLSLIgOFh1JRwBNv76MDhGmiss=;
 b=bq6hrDgQH/li3C9cri6XYq4BZjDpgvOaxuZvyR7kvOzPfilAaEib0RaWn2srSZznES9z
 bbeacW8uQ7VswRbry6zEM3YsoEE8LMQsuXEiF7hiRxlOLrIS27hdS6oM+yuH2flP/OZc
 zRCX7+An4v685XhrX7jtN5x2TqE8RxWjy4w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kxekapxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Jul 2020 14:02:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:02:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhA2lQghtAQ/ahQrY0XvGYn6w68BzMVRk1J7j1pobT5T5mm/nQ1h1l+CYbeePz7Ru9kj686hDr+VnI9ccgu5VYGaHsYP2TFKR2pJAm9n9my1AVqTTWp6oSqMdz7eQ1ZeTXXOeLXy1UnD1z3JHJS5Qz1HvjV/7UwwYWLuMZTGDMm7UlTPgwBcCiwx2d8WLTcZKgPDKCLH4NgvMd5H62K02l+g5wqAXCb6thq/K1OZ9XuhSTiqyhbmYW3Yb78fs334Mtn1x1mbDkIBh+8SLMiHuS2X354D37Pmf8PPSc18y7DnBpNYjatdlqdxQAs5HzoJaxTfM2wFHU242T8OacwhVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOLxo0nE+gMW6HqUYHLSLIgOFh1JRwBNv76MDhGmiss=;
 b=ZFtBcLEK72y9gwBlkfB4aGRem67Dw6LkQKsWUVvMrqXXQ3IDI6UaXx3jVXCQckVTvHRxj/t5N0wXxC09ZWB7/ByOvWCNSj4HgwS7LJO7F/T85i/sx2UoPH6sT/jIQHDAt3RpehShT3goNxeGjRXSuO7Mf3NcSCk5/uSEcji+122iaYk+pYdGEO6gi57b42kuoBp0CCb7enOviWH+qrbuut8F+XebTZJ3XkSsj/3WhbnuP/oynWVQLIcTSpckpwKTYDkbC1xZ2zu4shs59xY0VuKuwIkHj5D94DuoGMgsEsmEV8UFN4G1ruZ541IUFqzKoX1Gw1i1wYI11qYFny6t3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QOLxo0nE+gMW6HqUYHLSLIgOFh1JRwBNv76MDhGmiss=;
 b=dp/EGjt2IXDOWn+AODuW9gekqOhwjiS1DpXI8o//7elAKo8ccwRoZ+frPu/3Sa66ZiowXsdhrb7QtcYjDEpxcXL6+pj3v+IeENMyUnkZbTWxS2Ri+OZFHChjHnqaEuS11qe3Fw2bWNzwozdmGl7Wn4v/LhWEbdVP90EjsbWQ/38=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2821.namprd15.prod.outlook.com (2603:10b6:a03:15d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Thu, 30 Jul
 2020 21:02:48 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::543:b185:ef4a:7e8%5]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 21:02:48 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>,
        =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next 4/5] tools/bpftool: add `link detach` subcommand
Thread-Topic: [PATCH bpf-next 4/5] tools/bpftool: add `link detach` subcommand
Thread-Index: AQHWZfzaKHfqpyeDM0mjulvs0Tn2v6kgnZOA
Date:   Thu, 30 Jul 2020 21:02:48 +0000
Message-ID: <A6F4E1BE-ECFD-4382-9C67-5345431DD90E@fb.com>
References: <20200729230520.693207-1-andriin@fb.com>
 <20200729230520.693207-5-andriin@fb.com>
In-Reply-To: <20200729230520.693207-5-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
x-originating-ip: [2620:10d:c090:400::5:395d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc9f2f7a-52a2-4438-4db2-08d834cbea04
x-ms-traffictypediagnostic: BYAPR15MB2821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB282103B0F5D9B52506179FD1B3710@BYAPR15MB2821.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l7Uy0dG/MRbCfVh19TANe3sErT57QYmmivV6Q7sQ2Tq2WXsxzQcR3xqiIpZfhu3v2Q7juhnuEXE/Vhf7824o4sm0HyYXuQmHW3j21PJ3DRuAj70nDaLW6kZTr6ywziMVC4EhgrwSlISCLJuhZg9oI/xo5BaPWdeMQCshqSavEWrREKKdD+KVIoefzlMDLj85DuLSMc7u/4AuyqgkA2yNhYnAFtIpQ+C8+sdlVRaWKkXgXWfLkYtTN0/LhDGctsGnB0aTCahBqbNe9Ge7oCBDOcgg+A+AMWKErvz6j4vLAPxHuVbVXNNvgUEVFLx1e853QkG82M7sSrgxu5PlzjJK0c8GwZSkLHpJSoFM8Wn8nwqs/N/ryMsy9yxVudI+E/5v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(83380400001)(66476007)(66446008)(64756008)(66556008)(2906002)(33656002)(76116006)(66946007)(4326008)(8936002)(478600001)(6862004)(8676002)(316002)(36756003)(6636002)(71200400001)(37006003)(6486002)(54906003)(186003)(86362001)(53546011)(2616005)(5660300002)(6506007)(6512007)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YxKFUbsJjPkPSqN5gTJV62yU6p6zAN98LRrE+w97pwcDhGhk+wCwGGPvbeSAMzIyjOHolAn3rh1m+uQasuFKFMmBdjEhrT6v+JEEKW0t4/m5i/5PCFaMK30YApwBwIDRwDBS4vH4GI2dIS4eC68Ngm/TF1tutxB5gddwkaEtmNrUJQWfeffLEjMN70GkZYvA/8rKsTtRPJ8Fv78a0WQRp+DQUl4xhFr2BtTpqi6AOTFwWmrENSyHbhJmSUZJwnWRbym2DR8n9HV9VBJ4QsvT4DQE1xwx/dkJd8Di6FbGBNDlA+EPP3Um6JD4cVOo0WzApnjqIJS1gorW3SByRAzaAuDht60cfxdtkjFzW673WyUdHlf4ICFc64zqya4WVtZJoJhBnkIlm8zZ+08/xNTHd8rKLR2EVv0EU5eX3QXje5UWdbr7U4kV6vdovG2WQfDvvt+YI40QczWNASjgeVzRT9QQ8ft4rTnBc7jOfAZc9TGiKD7DHoqV2oSJQboPtVyJnR3DaM6R+cdpdA4ky5dFtxDALVHfLk2NqZMN7hR2IQ1ovOvOgL1/3gBdFYb3SMX9pd8BoI60PBV0Kt1A823EB5CAW4yz1eogAfTn6fTGS/3511/gloPy1eM2R0n8Hv8E8lAAKe0FGfl5KDPKQvN5rz2izTo5/ERHK7imxSrCXI3vBZ2n3uw3pLiWhXwFfEHH
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <1B40C61714247748B7D59E851E0E72B5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9f2f7a-52a2-4438-4db2-08d834cbea04
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2020 21:02:48.0741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8s2C8olCZMxuKQuT1VKxMVDTPWUzLf0yOQr1dAU6M9b89tdTSsKRq/cCzpVg2Py/eXpKpsCgwg+z9AJiihb0Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=946 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300148
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 29, 2020, at 4:05 PM, Andrii Nakryiko <andriin@fb.com> wrote:
>=20
> Add ability to force-detach BPF link. Also add missing error message, if
> specified link ID is wrong.
>=20
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

With two nitpicks below.=20

[...]

> static int link_parse_fd(int *argc, char ***argv)
> {
> +	int fd;
> +
> 	if (is_prefix(**argv, "id")) {
> 		unsigned int id;
> 		char *endptr;
> @@ -35,7 +37,10 @@ static int link_parse_fd(int *argc, char ***argv)
> 		}
> 		NEXT_ARGP();
>=20
> -		return bpf_link_get_fd_by_id(id);
> +		fd =3D bpf_link_get_fd_by_id(id);
> +		if (fd < 0)
> +			p_err("failed to get link with ID %d: %d", id, -errno);

How about we print strerror(errno) to match the rest of link.c?

[...]

> +static int do_detach(int argc, char **argv)
> +{
> +	int err, fd;
> +
> +	if (argc !=3D 2)
> +		return BAD_ARG();
> +
> +	fd =3D link_parse_fd(&argc, &argv);
> +	if (fd < 0)
> +		return 1;
> +
> +	err =3D bpf_link_detach(fd);
> +	if (err)
> +		err =3D -errno;
> +	close(fd);
> +	if (err) {
> +		p_err("failed link detach: %d", err);

And strerror(err) here.=20


