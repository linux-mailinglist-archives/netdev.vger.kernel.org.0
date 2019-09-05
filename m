Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484DDA97A8
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 02:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730290AbfIEAfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 20:35:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27496 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725965AbfIEAfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 20:35:34 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x850Z0XM001127;
        Wed, 4 Sep 2019 17:35:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=qgFywdgXUMT7dG2neEXVf+UGKOx+1eo4eKme8x0LrhQ=;
 b=NHp+T/gjERvCMO6bkPdihmbBjuMxCYHOZq1S2qTNy/naqrRmDiI4I3i/C6lOxoxTl6qR
 syrygIUaDgF12O+QSuTLUWbKIpy4ZKRKy4xLoZcZSgpz/C2lQQPt48ghsLXJBbE0EtXD
 Gnn9MsAiHh8sj3ICFBaqkdGCWH1T07Fm+xA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2utknmh4kc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Sep 2019 17:35:01 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 17:34:37 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 4 Sep 2019 17:34:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eN1KgJP1pn0wvQY78pyjDoXvtB07VQHPvaRJuJ01yCaxeWcKGD+kI921tfkPD2pBL7dPRsnd7g1eUUVmMm0aVWBtSyjunZGiqd5Ms/1ocbzJ+ybc9exGwMLuzKwITLqqse1cPA0k8V4dT5tA6YEpDKz3lfCO+Qz12Ee6pN6jenaSbtTzaf1tsZhJeze3FY3w5tAaB2kn2GBNP2PAgxcwkWU/QY5wZRcrQ5jVg3FFnGyhW2pFTwbDk9q9MsR0obSM1iFIcRnblsuvTXADNi+vyDnDda2aHsVnAdIpxY7jhNInQea5s3msU1LMZz5L9PNwfmdB/0+THfRDvyyIAV13ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgFywdgXUMT7dG2neEXVf+UGKOx+1eo4eKme8x0LrhQ=;
 b=FxGl4RZUvsHzSr6TzIwuc1pl2NpzoEaPt7Jv92vG24mmbEKonrKl/ENj7JU+dWhCkHPUN7t/SYoZowoTotKt+io8Ri/MscUrrtw0VsCiHuU87IThxzNlbotQIyoeWXydV/OQ3TiwE4WOkgGhTNeCI0jBk9nfNSwODh1tz//APIOs0e5cuOmSTIkHjO375YlzRGCklXnJi4dDydVRjXUfwFbBf7V419Btj2rBvEckzJ4FXNQ2x3ZA18JzTETHjjAM+YaXlDbvxAR+3wPa9lGTCKVWx0lkHJtA6VaKEJLg6hqo2jPsUVeGoJ6y5TLszjdLUy2AnI6nlyroIw4IlgYzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgFywdgXUMT7dG2neEXVf+UGKOx+1eo4eKme8x0LrhQ=;
 b=JfUMEOIQZhKdSitBhZnnJts8WTFqJVaZ58PKuk9wR2oT5rLHH5E/566Zc+r4krGQqaPW8jsy4Tx6Upx7Ylwpi9Lz92GssArKFbOjbd70yeEVU5IuZPmW4ldVAuLW/qdOny1xfR2OiIt3dz88XMVsifrYV5+Xh3CGcv4YzhAFpkU=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1821.namprd15.prod.outlook.com (10.174.255.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Thu, 5 Sep 2019 00:34:36 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 00:34:36 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>,
        "Andy Lutomirski" <luto@amacapital.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Topic: [PATCH v3 bpf-next 2/3] bpf: implement CAP_BPF
Thread-Index: AQHVY1Cvn0QzeDIQmEifJi8CsD4pqaccPMEA
Date:   Thu, 5 Sep 2019 00:34:36 +0000
Message-ID: <CE3B644F-D1A5-49F7-96B6-FD663C5F8961@fb.com>
References: <20190904184335.360074-1-ast@kernel.org>
 <20190904184335.360074-2-ast@kernel.org>
In-Reply-To: <20190904184335.360074-2-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::f079]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98c4bd67-ea86-4ea5-0aff-08d73198d490
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1821;
x-ms-traffictypediagnostic: MWHPR15MB1821:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB182180EAB3316536B7DCFFF1B3BB0@MWHPR15MB1821.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(366004)(346002)(136003)(39860400002)(199004)(189003)(476003)(99286004)(8936002)(6916009)(6116002)(71190400001)(2616005)(71200400001)(25786009)(64756008)(81166006)(50226002)(229853002)(6486002)(36756003)(57306001)(53936002)(486006)(81156014)(2906002)(5660300002)(76176011)(6436002)(66556008)(305945005)(66476007)(66946007)(102836004)(4326008)(66446008)(6512007)(256004)(14444005)(53546011)(6506007)(6246003)(446003)(33656002)(54906003)(86362001)(478600001)(186003)(8676002)(11346002)(4744005)(316002)(76116006)(46003)(14454004)(7736002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1821;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P6/E5/OwzrLtM5obZSTPUITAzgQ0hx582WUIZTCDW2d0KrNZWKPrVra51w3BSMhMEYUqF8x0d3jEpLlcrIAOv6dFaoYenN8u4ymIlxe3PmaKOek816U1EmirFjuc+z3+VgBSRXvW6FyFACEipKnI2Nr18wK33QLU3XxqTkuVOy9Mtz92YxU0eoUyxxUSfHbh2ptmWV518JxeMTN7SKPFAx/Ih4cBl+NgyF43iopaeXjsOZQGggJKgmkTtaLEggKTtgHHz60v9k9Rhni6f913cIHrXnBwRUUmM/1/kOKy0VUd4QMeYH2Q9Ena1YAXzNDTHimaPHuGbskBN4sVC+TBWazuKvsFQTT9qo/ufXxl/YdwLsnTbhpZ97jJs+b7aO3+aIM88U5xH3kFFe4mgCrJpWHqRClRlsKMO0xVGXxoiv0=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4EBF0FA92799CA46BFE7231B56ECE867@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c4bd67-ea86-4ea5-0aff-08d73198d490
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 00:34:36.5025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OA1+kw8S3SlxbDayh/GDl58vcRqOKcEpXvH9Ssz7bdaaF11Dt/qkRdycKkPz6XRuvPKJkMAwitH3HGFdCFF4Tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1821
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-04_06:2019-09-04,2019-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909050003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 4, 2019, at 11:43 AM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Implement permissions as stated in uapi/linux/capability.h
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20

[...]

> @@ -1648,11 +1648,11 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
> 	is_gpl =3D license_is_gpl_compatible(license);
>=20
> 	if (attr->insn_cnt =3D=3D 0 ||
> -	    attr->insn_cnt > (capable(CAP_SYS_ADMIN) ? BPF_COMPLEXITY_LIMIT_INS=
NS : BPF_MAXINSNS))
> +	    attr->insn_cnt > (capable_bpf() ? BPF_COMPLEXITY_LIMIT_INSNS : BPF_=
MAXINSNS))
> 		return -E2BIG;
> 	if (type !=3D BPF_PROG_TYPE_SOCKET_FILTER &&
> 	    type !=3D BPF_PROG_TYPE_CGROUP_SKB &&
> -	    !capable(CAP_SYS_ADMIN))
> +	    !capable_bpf())
> 		return -EPERM;

Do we allow load BPF_PROG_TYPE_SOCKET_FILTER and BPF_PROG_TYPE_CGROUP_SKB
without CAP_BPF? If so, maybe highlight in the header?

Thanks,
Song

