Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6082CF570B
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390839AbfKHTQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:16:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61278 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390820AbfKHTDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:03:40 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8ItGIg028030;
        Fri, 8 Nov 2019 11:03:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=EHio6oNmtkZVOl1mRKulaGsfjlNdaXZ4iuCOePk2qAU=;
 b=LYU1tvaVjl74Ulm4s+0CQYSKgDPDoc2KBKmhazNQTJhMESkGm7ePmzPlkXplEOB5xxF5
 mFWVOy1odRHrp2dp04Uu9v/9l8qbz0pputbPa7Ca5Im3Ylbtod3jreXBkkKBtv4nBOh/
 5JcuLBx2L0IkjHNkJTu4Z+AIKW0/PdMwMLQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5brygvk4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 11:03:25 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 11:03:18 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:03:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjq9kiouvhvhlbSYzZJz6nZnUeF+l2D+5tG0QI/KfKpXKLqc0vxN77zE0jZpGJ1EQyvjN9yPu1wZeUac7f95gDm8yRBdiuwtdq8EyLL1iM704JiBAfGk5bP9dUllCG74z/PKUmkdgyp5fgVhT3O8EhEK3TJYvGcSYJmI5eQ9fUMN2HH71rQBMzD6OiwTlyb62EjpXaVoiMioYTrNMsYFBq12nuZln174/3bo07X2iPhkAHj4zqrbb3VfFRuYvdYkRBnL0XGZ/61IuZPvYwaUofk9+AxkN7rZ2sx3jErhEhP1RrRuEEruRmMmFgla29xfi97IcYppuwuXi7d9kvpF+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHio6oNmtkZVOl1mRKulaGsfjlNdaXZ4iuCOePk2qAU=;
 b=IX9kmOrOMT3CFr14c2KqhLeYJ+KI0gASqb6xs2AJ7xlrbIIy9nkdP5IaZtZSj4B/qJsHR9mMSoNim2r44X7VEn6oZMbhYcQZq/6vpI24xQCqxxvruw6kX1qWBoHS7b1eSetzMn8+6wgV7kjabXsbLxxoQ6wPEBJ1GZCwsDtkozPV3QQdKTT9baT18vRBYPnyqK+Q5umxico66o0ubb615F3XFfUBUaoBEyosNeR2EXCjsVbhwmWDLZLOfWzeEC75huUkzuYBk+rC9yr7Wu3TsDpW3NHSbF0++IafqxfHEzcWxAR0dLbaPAMXYx/Ef3jwOhfvcUxZOaJe/EmtioZr1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHio6oNmtkZVOl1mRKulaGsfjlNdaXZ4iuCOePk2qAU=;
 b=PQ7DL0OiGeil4C3gf6dw1GgcxFF6l4N5fw+7rmYSwLmklSBgDUflaUvHFFOzTB7UmOh6n+s4fJAlw1ipnKDjg/2z3y/nRGgzssMitPh+WCaRSuXdShc6uHcPBvEYSF5zy3xULOWasTvVVF66U3xSjCvPANyOzsFz/jPxpgw45dw=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1711.namprd15.prod.outlook.com (10.174.254.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 19:03:17 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:03:17 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 17/18] selftests/bpf: Extend test_pkt_access
 test
Thread-Topic: [PATCH v3 bpf-next 17/18] selftests/bpf: Extend test_pkt_access
 test
Thread-Index: AQHVlf+Yu86FroKmhUuAZh1018dUrKeBolsA
Date:   Fri, 8 Nov 2019 19:03:16 +0000
Message-ID: <CC4F692C-1245-4199-9BDD-4C64C035590B@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-18-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-18-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8404e7b-cb5b-4cad-7106-08d7647e504f
x-ms-traffictypediagnostic: MWHPR15MB1711:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB171187D34BE61ACDC5D168C6B37B0@MWHPR15MB1711.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(54906003)(86362001)(53546011)(6506007)(7736002)(102836004)(478600001)(6916009)(14454004)(2616005)(11346002)(476003)(229853002)(25786009)(76176011)(66556008)(6436002)(46003)(6512007)(305945005)(6246003)(316002)(186003)(99286004)(76116006)(66946007)(36756003)(4326008)(50226002)(486006)(6116002)(446003)(14444005)(256004)(33656002)(66476007)(2906002)(71190400001)(71200400001)(5660300002)(64756008)(8676002)(8936002)(66446008)(81156014)(6486002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1711;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcC7Yo0eYlnJldqtiSU3A36nMDUJBxQwY0WZZd9yxtrVuM1QAE4gAjI7Pkvs/5GPvkZnpHZueDaXu/8Ge3dunBjbjLQ6kVe6bf4vCJuwXyFRZ5nvmkAOM5C49MaaZHC8U5ajLkFE5v1nweXgOZT7XemwyzwqCaBwTdsTaoG4nTTwBBkIBfQWaATxyJR8Zshvvcul+HWQrjRktk8R7Gy/pQaYa6ZCx11u25SZa03iJRxWClyYn829oh3nHOHujDBf76AFmDTYnbBDtpnbohYps9CXRIS3W7wFZKW1KvFHYlgtXduIzgINkL8fQjSxGLilkVnEvGJ1jJ28kc62NSE5hRZ+PdGvmZOT4bkLfrEH9+wu+lxReG2e0sedRaGRVQR/0z7lN6pwmi/Ww7Y1CBQb51xtgk8QuR/u4L3CfUogQPEair1QgKKm88sOFHlTBBE0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08E1AE770E26F14E9DAF2EFCDCF72AB4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a8404e7b-cb5b-4cad-7106-08d7647e504f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:03:16.9956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FN1jrxDSLVoYgb27Bxsk0CPG8e7QVycbp3mPOvKM6YgqYW3jKbf8rKa4URripV9P6qNaIcO4JjyKX4S4nDr9ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1711
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> The test_pkt_access.o is used by multiple tests. Fix its section name so =
that
> program type can be automatically detected by libbpf and make it call oth=
er
> subprograms with skb argument.
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
> .../selftests/bpf/progs/test_pkt_access.c     | 38 ++++++++++++++++++-
> 1 file changed, 36 insertions(+), 2 deletions(-)
>=20
> diff --git a/tools/testing/selftests/bpf/progs/test_pkt_access.c b/tools/=
testing/selftests/bpf/progs/test_pkt_access.c
> index 7cf42d14103f..3a7b4b607ed3 100644
> --- a/tools/testing/selftests/bpf/progs/test_pkt_access.c
> +++ b/tools/testing/selftests/bpf/progs/test_pkt_access.c
> @@ -17,8 +17,38 @@
> #define barrier() __asm__ __volatile__("": : :"memory")
> int _version SEC("version") =3D 1;
>=20
> -SEC("test1")
> -int process(struct __sk_buff *skb)
> +/* llvm will optimize both subprograms into exactly the same BPF assembl=
y
> + *
> + * Disassembly of section .text:
> + *
> + * 0000000000000000 test_pkt_access_subprog1:
> + * ; 	return skb->len * 2;
> + *        0:	61 10 00 00 00 00 00 00	r0 =3D *(u32 *)(r1 + 0)
> + *        1:	64 00 00 00 01 00 00 00	w0 <<=3D 1
> + *        2:	95 00 00 00 00 00 00 00	exit
> + *
> + * 0000000000000018 test_pkt_access_subprog2:
> + * ; 	return skb->len * val;
> + *        3:	61 10 00 00 00 00 00 00	r0 =3D *(u32 *)(r1 + 0)
> + *        4:	64 00 00 00 01 00 00 00	w0 <<=3D 1
> + *        5:	95 00 00 00 00 00 00 00	exit
> + *
> + * Which makes it an interesting test for BTF-enabled verifier.

This is interesting!

