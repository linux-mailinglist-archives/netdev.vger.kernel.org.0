Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE72B2AE585
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 02:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbgKKBQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 20:16:20 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15800 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730894AbgKKBPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 20:15:53 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AB1FI0b003360;
        Tue, 10 Nov 2020 17:15:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=4yv3hH6v+zgIgwItZGGEHuTOGby+KjeZPA8fQuSbjSA=;
 b=cs4fnF3pDP+OJqBi+TPe6FoJ2izhy3WKYMrZOXHcPTCcJI4OJ/zJm0fuHl6IBqvf0xsA
 3hCk50+9SppkUaxfbwJ6JQO+i8j1WqBTElK0lOFJQB0ZKPXXwBBvQrNLAz/o3t1/ptmj
 7SlG+ArzLxAFwKuWKUTzLccA09kWxPe9oGw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34qye8j8cn-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Nov 2020 17:15:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 10 Nov 2020 17:15:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6s1B/aiPV+pndelt8RSfxVkacw2fH8jcZkM8UgyGeHLXB+PRcKbRCQHO6KmfUwMjzqT6CwansqEhJdlyjbWMgmxEUrWoAfct3fMtS5OFktoNS/Aj2tHAaoNEQ15GG8tGeOHZ7mNeXt/ZyZWpCYW1XawndCgIL+yP0rBjUtfcig3RVJ8Y/vefsCvM9vF2I626JtGmawcJ8Sex0aIF7ljJTbb98TqC5tuDiMLj13cPsQszOdkovAIGS2dcIRAHoSLpLAuy9E3VSvAb4m9OZdr1ftyEnv4NtWPGSpgSkkkqdQj8DJlzArFtEwuQsrkNI6/Cl3C5Y93CxolPgU4fnAkJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yv3hH6v+zgIgwItZGGEHuTOGby+KjeZPA8fQuSbjSA=;
 b=Bi0yoXpwaQaHHUEoaTD6J0WpwidtefI5DXHEOpXI8vv01+dC5Ndob3YNvTU39BCktY+/o+vBM9ogBkdCB7TSQFQeSQXjSGHPx7N3fEpccof80LCvqdIePio4IoTHJ362XNQUsLB4Rq0mctWNJ3qeCOV1fD87cb7Lmk7BD+J6pv/7yw8z15rZJN0xl6MlRyIWR1mV9GeGAdCto/Q07Y9LCYpK428D0bn3XuK3uNPBAv9c42XBvzNjggazA5yo7qafQoFvmDhXxBUh8AnvJ8nTHhY2yp6z2/AE1iRcp0/t8AaFGQ4yb41t+8AL5Hqs7dQ9kHWNIyX13Vw9tmprSP/XOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yv3hH6v+zgIgwItZGGEHuTOGby+KjeZPA8fQuSbjSA=;
 b=d36/RIfyyjsp2xMfOaBdnRsGaAo169wyRrZBrD2sT7cbab4pcjq0A8nGkJ2Dw/3BuA2h0dNal60eXCGbbH7OrHBAW5THOKpsiVJi0a9nl05YMSxBgasPluhTcggBQVvx5dTjTx3UI6FGNZAOeoJ25nNPsuCpcuvnDQ3o19RbuuQ=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2567.namprd15.prod.outlook.com (2603:10b6:a03:151::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25; Wed, 11 Nov
 2020 01:15:29 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::f49e:bdbb:8cd7:bf6b%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 01:15:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andrii Nakryiko <andrii@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Alan Maguire" <alan.maguire@oracle.com>
Subject: Re: [PATCH v4 bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
Thread-Topic: [PATCH v4 bpf-next 5/5] tools/bpftool: add support for in-kernel
 and named BTF in `btf show`
Thread-Index: AQHWtwBlZiwFu4lmdkSb7Pyhw/89SanCIkiA
Date:   Wed, 11 Nov 2020 01:15:29 +0000
Message-ID: <8A2A9182-F22C-4A3B-AF52-6FC56D3057AA@fb.com>
References: <20201110011932.3201430-1-andrii@kernel.org>
 <20201110011932.3201430-6-andrii@kernel.org>
In-Reply-To: <20201110011932.3201430-6-andrii@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1f7d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ed01e9d-6ab5-43da-3bca-08d885df479d
x-ms-traffictypediagnostic: BYAPR15MB2567:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2567D485DC6B6E433188232BB3E80@BYAPR15MB2567.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:127;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BpNjihxERtTWL3NYcl4UtEWppfmmIc2+JLfvuznDdDLNCloXo++doqXr/9VD/+4312WV6qroDrU0/JEydscvsF0eyMb1O/Ps3Pr+wNQrnDW32wDzW4gh6VGLP3/hYPWqmxDC/Ecpynhnsd4sJHaJJ26vBTCulZrSHTT8YQGFlFRe/sXyprM7GfPQx0rXiyADY1k5H/o5+I0X7FmZIdMjGfDwlqhUo5r7H5QgJ7PeaZbYLansYfxww0vgb6DZE616nYHxZ78xIamdQ+NLvBbjr363mDrOrKiPJwMlQ4j5V8Yy9InBPrrBJJmanQJDbYXqyBLRFEKxMmnR6VwUKPyLKMdR/GLBcNyFeR173s0TUBB1rR7s3Qkcj15zk5/OLJnS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(376002)(39860400002)(8936002)(8676002)(5660300002)(4326008)(6916009)(91956017)(76116006)(71200400001)(66556008)(64756008)(66446008)(66476007)(66946007)(316002)(33656002)(36756003)(86362001)(83380400001)(186003)(6486002)(2906002)(6512007)(54906003)(53546011)(6506007)(7416002)(4744005)(2616005)(478600001)(81973001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zujtU+5Izk+IZS2eKK/dk6s15oAmbaxOdDFb7iJq3Isph+coj4jH+BalV8AFYuVijgus8j9yBCCfhG6aQrzgVHTkawcifp7gGeY1obp6Pmtk6e6Ht16yizFeOvZptNtphpnqoaaJVMo8QNooHZOT/+tuUeEvzukgAq8OOu2N4eG/9De/Mt0KrOUfjlcpD0ufwsA4LLW8AuQlXL+c3HDnPPqxqa8ktJ3PVFf+FVjluFZB1rU8ic7eCLpx03cdVDRohhhj1hSN0wW2b4fMPr4mI+wXGMNjCSJL8D1NAgDFaRdik02Pa8vO+l6T3rT1Cs52VztZGrmmMoNKAYm+Judpsn7mZltqbV+IMEg2gnr2PB2wcbhlMZSoS3H+fndpn0gQFQCQ+MALOXhWojMuHSNdgOeTYA/biM7YhyrqPRp8EQGT0XRowK1yCTpzarF68cdCl73gJ9r/YNY/bDgVKYDM3sIIyOLSS31FxEGaZa0RZ9LIEtovwhvSPyy5ORxaBzyQ7l3MtZHVV8UOdW7SHfCIvNeIQLOyyu7j1xpawerpOy1Exca/x0HKF2cGKVRd18fYNoOw9hw4nwmAbRkKZVxHCHAX7otGNA1UlWb68OmapINdf7SRZq57ytzY05gDhn9ln+DKi5ODpFn1DlJEMyglUR28qIYqV5QaN8chGomGjKWj8UkCU4sZapRFoQThP/5o8GG4lGpP756p5PVt1gu8kjDqibCatqe/6NBikZWOaloDHQzrv+hGEZGpnML/SpQSCRqJ7nzkUK/syRvFx37lOnS4Anngmqb17pPobmZ+/ttuETIx5t25drqkhqAY8jkvxiBkhHvsD9eXqw/pIU21gDW5Xwzi17VpiUjn4LMTAs8krCWbhwA5cYFcoxGLbWAh8m0iKgXHxf4ziDWW9Hy41SIQYRpJUKils9iE1jLoLO8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B4A2EB0F9F7A54D81DEA5EA8FE8AECF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed01e9d-6ab5-43da-3bca-08d885df479d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2020 01:15:29.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Y0UPVuUDj7YRNqsJbV3UlxRJ+EQmYO6kB8RwbmvAHB2I2RcInnKuzAQ1N8rPUPiEGCI53Ph8/UR01/5Zer4zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2567
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-10_09:2020-11-10,2020-11-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 clxscore=1011 priorityscore=1501 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011110003
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 9, 2020, at 5:19 PM, Andrii Nakryiko <andrii@kernel.org> wrote:

[...]

> ...
>=20
> Tested-by: Alan Maguire <alan.maguire@oracle.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

With one nit:

> ---
> tools/bpf/bpftool/btf.c | 28 +++++++++++++++++++++++++++-
> 1 file changed, 27 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index c96b56e8e3a4..ed5e97157241 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -742,9 +742,14 @@ show_btf_plain(struct bpf_btf_info *info, int fd,
> 	       struct btf_attach_table *btf_map_table)
> {
> 	struct btf_attach_point *obj;
> +	const char *name =3D u64_to_ptr(info->name);
> 	int n;
>=20
> 	printf("%u: ", info->id);
> +	if (info->kernel_btf)
> +		printf("name [%s]  ", name);
> +	else if (name && name[0])
> +		printf("name %s  ", name);

Maybe explicitly say "name <anonymous>" for btf without a name? I think=20
it will benefit plain output. =20

> 	printf("size %uB", info->btf_size);
>=20
> 	n =3D 0;

[...]
