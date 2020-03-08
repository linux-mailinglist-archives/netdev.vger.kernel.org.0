Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBFB317D132
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 04:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgCHDuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 22:50:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64270 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgCHDuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 22:50:15 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0283kiT2016084;
        Sat, 7 Mar 2020 19:49:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=4c8Apfmk2kumwoQaqUicAng6ThoU4i/OF2i1qdPGql8=;
 b=MLnoaCZyw5YGL7gy+FPGL0t0hge3+joOq0MTXkz+S7l+U//qZ7SmTHBB0MWVI5JWX8R9
 pAvi9ny3in8kZBy1qZJPeXm5/cVwDvNMJzJ1UTZeJVcn8oEGj4rutHHEhzmR9MjBsGwi
 fbnIt6GYOnq282DHOgOcE7E+FSo/dFkZVSAVaVI7fmW/wf4K5k7fO7l+mwETZ57kWKKB
 5x99lngIveysfTNfSOUz+GMrC6LeBkJKTzWjuCrgwqCpW9am94mJZ+0gboeUeajVtolj
 Af/hanMkqikqwIc8/T1tPoV7urNbzgdzctJ8SxrPkksaJCZErvVLh0twwaMogP8GW325 bg== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ymc0sj1qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 07 Mar 2020 19:49:18 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 7 Mar
 2020 19:49:16 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 7 Mar 2020 19:49:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHGQFuCrDmpE0RqgOSpYj2tPVuFiaLyiEknHakwU/HLPSNBj97th05iQFZuvEPu9C+ArLaEV6zkyQU/Upa3w6tOLlojagp16jBegW4oqB2NwOH3DZFjeJBXty3Rk+5FayaffsN5XlkUugyeUgCvwV73s/9mr1o1dHILywDWHer82xwwU6abZs6MCsIc70l+w8qd065t0Bm5Ajafzr+G3SfNDqanguo0c1TPCKbg3iIgScIrWQXcLOxcOkWGX0dyuHS2BOHszDPorQSB/8Pw2IBKVdTsDzfGh1gK/BMqAUVDR8khtEnfCRKTCFZMyFOCxYdGEYXQaEaeuWHBA3IRXjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c8Apfmk2kumwoQaqUicAng6ThoU4i/OF2i1qdPGql8=;
 b=A24ZPFzb989w8WlWzZsMgSkWJcqFhEu2NhNKy/wMpsEdZ9BE7tX6+j5Edd5005tEGkiV79Yyfo/JeXJ2BuNIQ/pADpCocruKHjkmXnjQh0nHbKgyfGfaftADjzfF6+C35sG0N4sT2HVtVA/02GBJn49FQaQamHafBWdubvgfBDwgGYX/CxmfP/p1NMMzQEUqowso5gsMi9O1lER7nGk7p1hYfeOygFOXEJLULttsyvnIkwAmhP2nKV+KCrrANrcBhzsWAD/oG5zMYmwR/f9t5rQyN1eRRPdzCy42o9px8vn3bj8k6O2r+6RsQgNIODOtP3KXe5KF/Lc30uQ1nFV68Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4c8Apfmk2kumwoQaqUicAng6ThoU4i/OF2i1qdPGql8=;
 b=SpiFOsbbfGEIxCoTceXlf1BdTBkbbuMpP7Ao1j92Zl7oZ61Lin7Jv3ayhU764EPfLwWi6wu8grPwvn3I+/w7XQqYEbWtH1vfM2Y3ZtXj/k3kxS/cLx6zRBuJVIdRaD7ELaJIfQOL0CaEnSLYlqXU4rv9GnIgrVdP2O/J5pi8fhI=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2920.namprd18.prod.outlook.com (2603:10b6:a03:10b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14; Sun, 8 Mar
 2020 03:49:15 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::8cd1:1741:8d2d:1c23%7]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 03:49:15 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "will@kernel.org" <will@kernel.org>
Subject: [PATCH v2 05/12] task_isolation: arch/x86: enable task isolation
 functionality
Thread-Topic: [PATCH v2 05/12] task_isolation: arch/x86: enable task isolation
 functionality
Thread-Index: AQHV9PyJVxq1ibIggkG2K9HIzhIQ0A==
Date:   Sun, 8 Mar 2020 03:49:15 +0000
Message-ID: <1ddd1aeb9798a85e25debd8cc57a3059eda512d9.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
In-Reply-To: <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.233.58.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55476e7c-4eef-4f52-c27f-08d7c313ac40
x-ms-traffictypediagnostic: BYAPR18MB2920:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2920874F51712BB197DA2437BCE10@BYAPR18MB2920.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39850400004)(376002)(346002)(366004)(199004)(189003)(316002)(66946007)(5660300002)(6512007)(478600001)(8936002)(71200400001)(2906002)(6486002)(66556008)(66476007)(76116006)(6506007)(91956017)(64756008)(66446008)(36756003)(54906003)(4326008)(2616005)(186003)(110136005)(8676002)(26005)(81166006)(81156014)(86362001)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2920;H:BYAPR18MB2535.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cAw28saCt0D1kbdqlz1HVT7xcZeGIivdovrKrPxPfLwR/hI8Duf8JNCOQBxKYKUR9KdcLdrumBmgWkLlp7eCI1UyIzFb9y43NP/e88MAp3vfu+clT1HWVkYzGCC9CvNIApUX4nzj3vIRL7aNUdqrNJpSbDmepqyw3ek1l2eQv0YZ6SM4m7RXMWmys9CeOC9zOxEZ3072J2Sk5pbRacbhysYX5bdodAY0g0AkqnoKBRMD45Zv6FqqVyWlmZiPlWS40JgTBmsjpgmLH9CJxbwOQgLIyxI6xoQENd5Miqir1U+jKIrhfkSV+SqTe2RAY3WN+CGLX6vB99Hy5Es/3AKe5F1eeBaBVBazXDsovcuG06Dp0eGp+RzMdghTz03zE2xZxnEfqTUmSzYuNK3MiQ+aTKPpSd/jrHAZgG1X+pvm/ePZCEa2C4eBTlFFSlwNUTnZ
x-ms-exchange-antispam-messagedata: fgy8Sy4MfzfdIFXb7bNVbM5TE0/R/V5h9jwkpNpENhCQDVmCDrzTp95rU1Y+OL00Lu+hQNyia910sx5lI88Gs3ei0AcQHo9tJm2J+yPkIseB7qrNK2DS2Xe+Hn+Cs0ew+L6f9f0VEy30GgfQ5NP5kA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <24669D11BC4CA740BBBEB5BC8FC0A3CD@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 55476e7c-4eef-4f52-c27f-08d7c313ac40
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 03:49:15.3647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4Wv0uc2TzA32BQVJri1tg9A+qR4a8w5BDh340GJKNyQV3AJWYdOPmc7Qi1huqhVZZtE3VMnUhVq1zfnM/NTIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2920
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-07_09:2020-03-06,2020-03-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpJbiBwcmVwYXJl
X2V4aXRfdG9fdXNlcm1vZGUoKSwgcnVuIGNsZWFudXAgZm9yIHRhc2tzIGV4aXRlZCBmcm9tDQpp
c29sYXRpb24gYW5kIGNhbGwgdGFza19pc29sYXRpb25fc3RhcnQoKSBmb3IgdGFza3Mgd2l0aA0K
VElGX1RBU0tfSVNPTEFUSU9OLg0KDQpJbiBzeXNjYWxsX3RyYWNlX2VudGVyX3BoYXNlMSgpLCBh
ZGQgdGhlIG5lY2Vzc2FyeSBzdXBwb3J0IGZvcg0KcmVwb3J0aW5nIHN5c2NhbGxzIGZvciB0YXNr
LWlzb2xhdGlvbiBwcm9jZXNzZXMuDQoNCkFkZCB0YXNrX2lzb2xhdGlvbl9yZW1vdGUoKSBjYWxs
cyBmb3IgdGhlIGtlcm5lbCBleGNlcHRpb24gdHlwZXMNCnRoYXQgZG8gbm90IHJlc3VsdCBpbiBz
aWduYWxzLCBuYW1lbHkgbm9uLXNpZ25hbGxpbmcgcGFnZSBmYXVsdHMuDQoNClNpZ25lZC1vZmYt
Ynk6IENocmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClthYmVsaXRzQG1hcnZl
bGwuY29tOiBhZGFwdGVkIGZvciBrZXJuZWwgNS42XQ0KU2lnbmVkLW9mZi1ieTogQWxleCBCZWxp
dHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBhcmNoL3g4Ni9LY29uZmlnICAgICAgICAg
ICAgICAgICAgIHwgIDEgKw0KIGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jICAgICAgICAgICAgfCAx
NSArKysrKysrKysrKysrKysNCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9hcGljLmggICAgICAgIHwg
IDMgKysrDQogYXJjaC94ODYvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaCB8ICA0ICsrKy0NCiBh
cmNoL3g4Ni9rZXJuZWwvYXBpYy9pcGkuYyAgICAgICAgIHwgIDIgKysNCiBhcmNoL3g4Ni9tbS9m
YXVsdC5jICAgICAgICAgICAgICAgIHwgIDQgKysrKw0KIDYgZmlsZXMgY2hhbmdlZCwgMjggaW5z
ZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvS2NvbmZp
ZyBiL2FyY2gveDg2L0tjb25maWcNCmluZGV4IGJlZWE3NzA0NmY5Yi4uOWVhNmQzZTZlNzdkIDEw
MDY0NA0KLS0tIGEvYXJjaC94ODYvS2NvbmZpZw0KKysrIGIvYXJjaC94ODYvS2NvbmZpZw0KQEAg
LTE0NCw2ICsxNDQsNyBAQCBjb25maWcgWDg2DQogCXNlbGVjdCBIQVZFX0FSQ0hfQ09NUEFUX01N
QVBfQkFTRVMJaWYgTU1VICYmIENPTVBBVA0KIAlzZWxlY3QgSEFWRV9BUkNIX1BSRUwzMl9SRUxP
Q0FUSU9OUw0KIAlzZWxlY3QgSEFWRV9BUkNIX1NFQ0NPTVBfRklMVEVSDQorCXNlbGVjdCBIQVZF
X0FSQ0hfVEFTS19JU09MQVRJT04NCiAJc2VsZWN0IEhBVkVfQVJDSF9USFJFQURfU1RSVUNUX1dI
SVRFTElTVA0KIAlzZWxlY3QgSEFWRV9BUkNIX1NUQUNLTEVBSw0KIAlzZWxlY3QgSEFWRV9BUkNI
X1RSQUNFSE9PSw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2VudHJ5L2NvbW1vbi5jIGIvYXJjaC94
ODYvZW50cnkvY29tbW9uLmMNCmluZGV4IDk3NDc4NzY5ODBiNS4uYmE4Y2Q3NWRjN2NmIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYvZW50cnkvY29tbW9uLmMNCisrKyBiL2FyY2gveDg2L2VudHJ5L2Nv
bW1vbi5jDQpAQCAtMjYsNiArMjYsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9saXZlcGF0Y2guaD4N
CiAjaW5jbHVkZSA8bGludXgvc3lzY2FsbHMuaD4NCiAjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5o
Pg0KKyNpbmNsdWRlIDxsaW51eC9pc29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSA8YXNtL2Rlc2Mu
aD4NCiAjaW5jbHVkZSA8YXNtL3RyYXBzLmg+DQpAQCAtODYsNiArODcsMTUgQEAgc3RhdGljIGxv
bmcgc3lzY2FsbF90cmFjZV9lbnRlcihzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJCQlyZXR1cm4g
LTFMOw0KIAl9DQogDQorCS8qDQorCSAqIEluIHRhc2sgaXNvbGF0aW9uIG1vZGUsIHdlIG1heSBw
cmV2ZW50IHRoZSBzeXNjYWxsIGZyb20NCisJICogcnVubmluZywgYW5kIGlmIHNvIHdlIGFsc28g
ZGVsaXZlciBhIHNpZ25hbCB0byB0aGUgcHJvY2Vzcy4NCisJICovDQorCWlmICh3b3JrICYgX1RJ
Rl9UQVNLX0lTT0xBVElPTikgew0KKwkJaWYgKHRhc2tfaXNvbGF0aW9uX3N5c2NhbGwocmVncy0+
b3JpZ19heCkgPT0gLTEpDQorCQkJcmV0dXJuIC0xTDsNCisJCXdvcmsgJj0gfl9USUZfVEFTS19J
U09MQVRJT047DQorCX0NCiAjaWZkZWYgQ09ORklHX1NFQ0NPTVANCiAJLyoNCiAJICogRG8gc2Vj
Y29tcCBhZnRlciBwdHJhY2UsIHRvIGNhdGNoIGFueSB0cmFjZXIgY2hhbmdlcy4NCkBAIC0xODks
NiArMTk5LDggQEAgX192aXNpYmxlIGlubGluZSB2b2lkIHByZXBhcmVfZXhpdF90b191c2VybW9k
ZShzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJbG9ja2RlcF9hc3NlcnRfaXJxc19kaXNhYmxlZCgp
Ow0KIAlsb2NrZGVwX3N5c19leGl0KCk7DQogDQorCXRhc2tfaXNvbGF0aW9uX2NoZWNrX3J1bl9j
bGVhbnVwKCk7DQorDQogCWNhY2hlZF9mbGFncyA9IFJFQURfT05DRSh0aS0+ZmxhZ3MpOw0KIA0K
IAlpZiAodW5saWtlbHkoY2FjaGVkX2ZsYWdzICYgRVhJVF9UT19VU0VSTU9ERV9MT09QX0ZMQUdT
KSkNCkBAIC0yMDQsNiArMjE2LDkgQEAgX192aXNpYmxlIGlubGluZSB2b2lkIHByZXBhcmVfZXhp
dF90b191c2VybW9kZShzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJaWYgKHVubGlrZWx5KGNhY2hl
ZF9mbGFncyAmIF9USUZfTkVFRF9GUFVfTE9BRCkpDQogCQlzd2l0Y2hfZnB1X3JldHVybigpOw0K
IA0KKwlpZiAoY2FjaGVkX2ZsYWdzICYgX1RJRl9UQVNLX0lTT0xBVElPTikNCisJCXRhc2tfaXNv
bGF0aW9uX3N0YXJ0KCk7DQorDQogI2lmZGVmIENPTkZJR19DT01QQVQNCiAJLyoNCiAJICogQ29t
cGF0IHN5c2NhbGxzIHNldCBUU19DT01QQVQuICBNYWtlIHN1cmUgd2UgY2xlYXIgaXQgYmVmb3Jl
DQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYXBpYy5oIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vYXBpYy5oDQppbmRleCAxOWU5NGFmOWNjNWQuLjcxMTQ5YWJiYjBhMCAxMDA2NDQN
Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FwaWMuaA0KKysrIGIvYXJjaC94ODYvaW5jbHVk
ZS9hc20vYXBpYy5oDQpAQCAtMyw2ICszLDcgQEANCiAjZGVmaW5lIF9BU01fWDg2X0FQSUNfSA0K
IA0KICNpbmNsdWRlIDxsaW51eC9jcHVtYXNrLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlv
bi5oPg0KIA0KICNpbmNsdWRlIDxhc20vYWx0ZXJuYXRpdmUuaD4NCiAjaW5jbHVkZSA8YXNtL2Nw
dWZlYXR1cmUuaD4NCkBAIC01MjQsNiArNTI1LDcgQEAgZXh0ZXJuIHZvaWQgaXJxX2V4aXQodm9p
ZCk7DQogDQogc3RhdGljIGlubGluZSB2b2lkIGVudGVyaW5nX2lycSh2b2lkKQ0KIHsNCisJdGFz
a19pc29sYXRpb25faW50ZXJydXB0KCJpcnEiKTsNCiAJaXJxX2VudGVyKCk7DQogCWt2bV9zZXRf
Y3B1X2wxdGZfZmx1c2hfbDFkKCk7DQogfQ0KQEAgLTUzNiw2ICs1MzgsNyBAQCBzdGF0aWMgaW5s
aW5lIHZvaWQgZW50ZXJpbmdfYWNrX2lycSh2b2lkKQ0KIA0KIHN0YXRpYyBpbmxpbmUgdm9pZCBp
cGlfZW50ZXJpbmdfYWNrX2lycSh2b2lkKQ0KIHsNCisJdGFza19pc29sYXRpb25faW50ZXJydXB0
KCJhY2sgaXJxIik7DQogCWlycV9lbnRlcigpOw0KIAlhY2tfQVBJQ19pcnEoKTsNCiAJa3ZtX3Nl
dF9jcHVfbDF0Zl9mbHVzaF9sMWQoKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90aHJlYWRfaW5mby5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaA0KaW5k
ZXggY2Y0MzI3OTg2ZTk4Li42MGQxMDdmNzg0ZWUgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS90aHJlYWRfaW5mby5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90aHJlYWRf
aW5mby5oDQpAQCAtOTIsNiArOTIsNyBAQCBzdHJ1Y3QgdGhyZWFkX2luZm8gew0KICNkZWZpbmUg
VElGX05PQ1BVSUQJCTE1CS8qIENQVUlEIGlzIG5vdCBhY2Nlc3NpYmxlIGluIHVzZXJsYW5kICov
DQogI2RlZmluZSBUSUZfTk9UU0MJCTE2CS8qIFRTQyBpcyBub3QgYWNjZXNzaWJsZSBpbiB1c2Vy
bGFuZCAqLw0KICNkZWZpbmUgVElGX0lBMzIJCTE3CS8qIElBMzIgY29tcGF0aWJpbGl0eSBwcm9j
ZXNzICovDQorI2RlZmluZSBUSUZfVEFTS19JU09MQVRJT04JMTgJLyogdGFzayBpc29sYXRpb24g
ZW5hYmxlZCBmb3IgdGFzayAqLw0KICNkZWZpbmUgVElGX05PSFoJCTE5CS8qIGluIGFkYXB0aXZl
IG5vaHogbW9kZSAqLw0KICNkZWZpbmUgVElGX01FTURJRQkJMjAJLyogaXMgdGVybWluYXRpbmcg
ZHVlIHRvIE9PTSBraWxsZXIgKi8NCiAjZGVmaW5lIFRJRl9QT0xMSU5HX05SRkxBRwkyMQkvKiBp
ZGxlIGlzIHBvbGxpbmcgZm9yIFRJRl9ORUVEX1JFU0NIRUQgKi8NCkBAIC0xMjIsNiArMTIzLDcg
QEAgc3RydWN0IHRocmVhZF9pbmZvIHsNCiAjZGVmaW5lIF9USUZfTk9DUFVJRAkJKDEgPDwgVElG
X05PQ1BVSUQpDQogI2RlZmluZSBfVElGX05PVFNDCQkoMSA8PCBUSUZfTk9UU0MpDQogI2RlZmlu
ZSBfVElGX0lBMzIJCSgxIDw8IFRJRl9JQTMyKQ0KKyNkZWZpbmUgX1RJRl9UQVNLX0lTT0xBVElP
TgkoMSA8PCBUSUZfVEFTS19JU09MQVRJT04pDQogI2RlZmluZSBfVElGX05PSFoJCSgxIDw8IFRJ
Rl9OT0haKQ0KICNkZWZpbmUgX1RJRl9QT0xMSU5HX05SRkxBRwkoMSA8PCBUSUZfUE9MTElOR19O
UkZMQUcpDQogI2RlZmluZSBfVElGX0lPX0JJVE1BUAkJKDEgPDwgVElGX0lPX0JJVE1BUCkNCkBA
IC0xNDAsNyArMTQyLDcgQEAgc3RydWN0IHRocmVhZF9pbmZvIHsNCiAjZGVmaW5lIF9USUZfV09S
S19TWVNDQUxMX0VOVFJZCVwNCiAJKF9USUZfU1lTQ0FMTF9UUkFDRSB8IF9USUZfU1lTQ0FMTF9F
TVUgfCBfVElGX1NZU0NBTExfQVVESVQgfAlcDQogCSBfVElGX1NFQ0NPTVAgfCBfVElGX1NZU0NB
TExfVFJBQ0VQT0lOVCB8CVwNCi0JIF9USUZfTk9IWikNCisJIF9USUZfTk9IWiB8IF9USUZfVEFT
S19JU09MQVRJT04pDQogDQogLyogZmxhZ3MgdG8gY2hlY2sgaW4gX19zd2l0Y2hfdG8oKSAqLw0K
ICNkZWZpbmUgX1RJRl9XT1JLX0NUWFNXX0JBU0UJCQkJCVwNCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rZXJuZWwvYXBpYy9pcGkuYyBiL2FyY2gveDg2L2tlcm5lbC9hcGljL2lwaS5jDQppbmRleCA2
Y2EwZjkxMzcyZmQuLmI0ZGZhYWQ2YTQ0MCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2tlcm5lbC9h
cGljL2lwaS5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwvYXBpYy9pcGkuYw0KQEAgLTIsNiArMiw3
IEBADQogDQogI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4NCiAjaW5jbHVkZSA8bGludXgvc21w
Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KIA0KICNpbmNsdWRlICJsb2NhbC5o
Ig0KIA0KQEAgLTY3LDYgKzY4LDcgQEAgdm9pZCBuYXRpdmVfc21wX3NlbmRfcmVzY2hlZHVsZShp
bnQgY3B1KQ0KIAkJV0FSTigxLCAic2NoZWQ6IFVuZXhwZWN0ZWQgcmVzY2hlZHVsZSBvZiBvZmZs
aW5lIENQVSMlZCFcbiIsIGNwdSk7DQogCQlyZXR1cm47DQogCX0NCisJdGFza19pc29sYXRpb25f
cmVtb3RlKGNwdSwgInJlc2NoZWR1bGUgSVBJIik7DQogCWFwaWMtPnNlbmRfSVBJKGNwdSwgUkVT
Q0hFRFVMRV9WRUNUT1IpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9tbS9mYXVsdC5j
IGIvYXJjaC94ODYvbW0vZmF1bHQuYw0KaW5kZXggZmE0ZWEwOTU5M2FiLi4yMTc1YTg2NTVhN2Qg
MTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9tbS9mYXVsdC5jDQorKysgYi9hcmNoL3g4Ni9tbS9mYXVs
dC5jDQpAQCAtMTgsNiArMTgsNyBAQA0KICNpbmNsdWRlIDxsaW51eC91YWNjZXNzLmg+CQkvKiBm
YXVsdGhhbmRsZXJfZGlzYWJsZWQoKQkqLw0KICNpbmNsdWRlIDxsaW51eC9lZmkuaD4JCQkvKiBl
ZmlfcmVjb3Zlcl9mcm9tX3BhZ2VfZmF1bHQoKSovDQogI2luY2x1ZGUgPGxpbnV4L21tX3R5cGVz
Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPgkJLyogdGFza19pc29sYXRpb25faW50
ZXJydXB0ICAgICAqLw0KIA0KICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5oPgkJLyogYm9vdF9j
cHVfaGFzLCAuLi4JCSovDQogI2luY2x1ZGUgPGFzbS90cmFwcy5oPgkJCS8qIGRvdHJhcGxpbmth
Z2UsIC4uLgkJKi8NCkBAIC0xNDgzLDYgKzE0ODQsOSBAQCB2b2lkIGRvX3VzZXJfYWRkcl9mYXVs
dChzdHJ1Y3QgcHRfcmVncyAqcmVncywNCiAJCXBlcmZfc3dfZXZlbnQoUEVSRl9DT1VOVF9TV19Q
QUdFX0ZBVUxUU19NSU4sIDEsIHJlZ3MsIGFkZHJlc3MpOw0KIAl9DQogDQorCS8qIE5vIHNpZ25h
bCB3YXMgZ2VuZXJhdGVkLCBidXQgbm90aWZ5IHRhc2staXNvbGF0aW9uIHRhc2tzLiAqLw0KKwl0
YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoInBhZ2UgZmF1bHQgYXQgJSNseCIsIGFkZHJlc3MpOw0K
Kw0KIAljaGVja192ODA4Nl9tb2RlKHJlZ3MsIGFkZHJlc3MsIHRzayk7DQogfQ0KIE5PS1BST0JF
X1NZTUJPTChkb191c2VyX2FkZHJfZmF1bHQpOw0KLS0gDQoyLjIwLjENCg0K
