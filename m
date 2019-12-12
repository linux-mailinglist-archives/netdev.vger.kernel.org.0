Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6466A11D598
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfLLSbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:31:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36494 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730034AbfLLSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:31:06 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCISJMK018738;
        Thu, 12 Dec 2019 10:30:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=GS0789pbAF6LtEIu3B3dWMJgFEREkUq6vACdWQRl7B0=;
 b=UYh3cdu5/Gg6PsPhdgpBvRMK1meYKXZ92xNfZxjpZIPJx9+37p3RaC8098MBqo7tPahd
 8HFo6U2QsX2arhjkxvKOEqMm0H4d2OSv7nhi18ffRNP79BlRMxlOLJS6eaZqlm2pyjAr
 HK2uePd8+7zCcqSKo9ugaYr2CBwBZ8+QbwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wub46bvt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 12 Dec 2019 10:30:53 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Dec 2019 10:30:51 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Dec 2019 10:30:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMdy1O7vXeaoY+0P8x4AtwUEkchE0dHa3c1oEECGv9xVxDKB+n5JBj9T9I58fBDtol3+3Is13U2NoCB0+tvCMCukFpZoHxJdAZaoNW+jqJ7bf3xNGb0lD8j51Ja8BEyD4Pm9k3ygPiuG3hCAA+gOCp2YFjrhEu4rCX8dGFhjS4okzrlONPiuWGorSW5lUOqgFoPMORWfRMElFE54Wz/fUvAIkIbzr0LKx8SPjBDkiWX0DA7nsauC/lPnCkkF7w+Gg3w/Wdcumat2c66omB8auAt2NO0CShp+cM64H2TZDfZo+/5Kaxe4WIyJl9btq87UzGclX0g+z6JYHOKk9F1ZOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS0789pbAF6LtEIu3B3dWMJgFEREkUq6vACdWQRl7B0=;
 b=FRsC0JQsJTg/Yl1sZt0aWBvEXYMMDF5y43EDBau8wKFOtGKrEFenYXdEIWRHYAhdJgIAo/qJKkkR+ImkNQZcbmCvoEQ/wqutVjthJjjavoVz/fS5RFEkPIk+CMtRrSmSxyY9NGDJuViyXDRreLW28vz3XM48TxtNe4SJJKpMoczJW+Pm19JYhTEE76a3uRKFLSnWBtsJx1SJ+mkSvvp/rfTomrGSrnNsD0hYS/ZeG8Tsc9UEF0w4f7G2upoX/cHb1gP6JCIO7R5lVerlqepXrTWZ/G/tu4nkDlxpIv3QlRGqB5NV4TwETg/1qy3X2mA2rsdTPzEs4jGT1UUeg/UNaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GS0789pbAF6LtEIu3B3dWMJgFEREkUq6vACdWQRl7B0=;
 b=h4/lUHX2QAKyMqalNLbgQClXdkns5sS+Il0Ph/gTE5FrmoxgeYbopYigiIlB9ngc79BH5UY6NFMIa9tGlQX+76FrwZgAXpdRG9TtX9VEx27Py+znTqMy8qBZ2OFfQhmc5j5glysQLY7AeLBsJ47crrHcaTNjAY2wsp74KOwPFdg=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3597.namprd15.prod.outlook.com (52.132.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Thu, 12 Dec 2019 18:30:50 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 18:30:50 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Topic: [PATCH v2 bpf-next] libbpf: fix printf compilation warnings on
 ppc64le arch
Thread-Index: AQHVsRBQNM/jsU+ZtU6WmSyUu/Ydt6e20mkA
Date:   Thu, 12 Dec 2019 18:30:50 +0000
Message-ID: <20191212183046.7h4kcuvmayafzztg@kafai-mbp>
References: <20191212171918.638010-1-andriin@fb.com>
In-Reply-To: <20191212171918.638010-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0085.namprd05.prod.outlook.com
 (2603:10b6:104:1::11) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::97ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b674c2-06d7-4602-178e-08d77f3169de
x-ms-traffictypediagnostic: MN2PR15MB3597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB35970C89DC2C98BDFEF6C3B1D5550@MN2PR15MB3597.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(136003)(366004)(39860400002)(376002)(346002)(396003)(189003)(199004)(81156014)(54906003)(81166006)(66556008)(6506007)(64756008)(4326008)(66946007)(66446008)(316002)(66476007)(6636002)(478600001)(8676002)(71200400001)(186003)(6862004)(1076003)(4744005)(6486002)(6512007)(9686003)(86362001)(5660300002)(2906002)(8936002)(52116002)(33716001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3597;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sm7N40idxhdWnkiWtN89rWQVavCpq7znYkr4Cmxsbdi7bcyjs47vlG8BQXiZytad6tjgxKe+2Jx0193tS+5gI9UwTJEezUXtN0jpaHo828jMF2WfsXW45m83egDp4PAGsi6+xQ+ZTUjxOABppZgbOvUXE+ogEUsbe4K+QAxWv/xXBohd9iFH5DAXuuCpA4gUqH0ykyQqNWsOqJ5hxOy0HAeV7oAQwz4D3ffcekSnWjUwyikNQRoTc58PzyZ1NqNcK5QwbW4Myc5TFOCdowqBhw6a3TgeCxPF7gEw7p/3M1fOeszJyuAE4qeRZ+1rCrxkG3+ns+9K0hlQDpDCq364nCAbik/4TOW7CBcHHfFh8Tn2pc8R9M9vTFkAzAZYTlrdjC7N8S0J283ug4jJWfFmYsOXuIdz9gBXIICBmtpvRNKs16BOUcBtwsAe6jg0eAxo
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B09A384F47A7E143B576B653314A73F3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b674c2-06d7-4602-178e-08d77f3169de
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 18:30:50.4191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+ScWyl3sUTMGW8hI/w+2Sz49/bX1owadyA+AKLSWO2FHC2rnAFthZUjFeO6BuA6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3597
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_06:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=508
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120141
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 09:19:18AM -0800, Andrii Nakryiko wrote:
> On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
> respectively. This causes compiler to emit warning when %lld/%llu are use=
d to
> printf 64-bit numbers. Fix this by casting to size_t/ssize_t with %zu and=
 %zd
> format specifiers, respectively.
Acked-by: Martin KaFai Lau <kafai@fb.com>
