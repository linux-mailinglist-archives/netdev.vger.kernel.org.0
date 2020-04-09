Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61FB61A36F2
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgDIPXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:23:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:57562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728194AbgDIPXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:23:14 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FH05I019710;
        Thu, 9 Apr 2020 08:22:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=kwxvA2O/rF7rha8lL0t+pYwH6gP7wrFqWvOKNvTqAHU=;
 b=G/hM8g5CXcJmofghL2ynG9NmuKYTDDDFF/gPsJrx6zSiJt0kee3kSxiO1OoLcr242c2l
 uqdiTg54C4OKAN9JPOK9n2aWSAqD0ftBT3RqQ1aPnIDngorRxQwEWQNmQJBV01pOsrOM
 nMtrglerG/lghLzqnrNmnmgtTWp23K0EwBz1Xo4pdRCLucrQkRIFPU8MwtMGnk4KwRFT
 HYwdIC4nlqzWZ63/aFqRsmTylhKx2yCK+YlIBrpRe6OUDvYtqKdPh3V2waJv0l/5aKLl
 RpLbnBbNqe9eJrGVvoeGk1jtWWNl/qmqZywNDuuhRgHB8Ux6qReBDsTwxJlUIk5sp0Ia bw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me8ytv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:22:36 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:22:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:22:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naWlaGF5wrP6vEysSinjqyyrYs+W+pRpQapvE08JmlvFTKkBE10RX3u3Ndq9je0QAqfIeNQTiA/WO/dG4K6kwKUBhYjvX9J/h2fGoG7CwgYkOTy1SuBRzsqJlZsI4Y8u8ksi2FNBjW7w9ZfcS4ymZKNQDWwYyNd2x795mUuJorlefedRkci6VBtb8ELa9Fq90UiwWYtehGQTyBRtJiUqSo8fgUc2KwxSSS0t+rl9udmVi4Jns+ReUN4R/vXOVNFUikqaVOT9PCj2kjTJOKXYMCSkj+a96Gfvd0bQ2rxCGv0td8wpAOo/n1gZDAUmLdG6jl8byC4tWdcXJHpRbQVZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwxvA2O/rF7rha8lL0t+pYwH6gP7wrFqWvOKNvTqAHU=;
 b=nyT8A+fPxVOcCm5Zo5dbmYno9LIcT8QqZU/7jlh9+0E7PNVnQhYmgLYY7zpNWXZ1PINAz26N9LejtoTd3R/IWvTx7oEbod++BSu1flIAnYjlT1w9j13tuwS9DBE0f6NW26Oz2ZsrzSnUJ+eXamgC0A5xC7CF2ynGufoO5isW51mJccAb7rno5JjC7J2fUY6JYD4JZvp6qJnfj8y0SpQPjQ31P71TxZ2gRaY+pHODN/thlvPPg83wrnDz/XKSJj2bkniP+eKcCXARdGDdjy4zoTionQTQIWomrcvA1Gl+sAKRxLtmJlJ9/3FCfgF0LOlc7Zl15Qp9qUSMYxpixdD7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwxvA2O/rF7rha8lL0t+pYwH6gP7wrFqWvOKNvTqAHU=;
 b=KlkqZ2AzyzRkOvpQ8uwotvADEUGmEvcxrXfiF6E/CGG/rSWP05hd4WBuVKMiYGgwRGedPSLbkyNwTBl88HJ6kiMQgkgqC2VW+obZORQ5IKBohD7zBewIETkMQModeRYpg6SwZgfzgqjV7M5Mrv7L5Yn/IIEcgbVfA/knorWYzTY=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB3749.namprd18.prod.outlook.com (2603:10b6:a03:96::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Thu, 9 Apr
 2020 15:22:33 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:22:33 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "frederic@kernel.org" <frederic@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "will@kernel.org" <will@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH 06/13] task_isolation: arch/x86: enable task isolation
 functionality
Thread-Topic: [PATCH 06/13] task_isolation: arch/x86: enable task isolation
 functionality
Thread-Index: AQHWDoKw4bp+D2jMMEiGr32357BkEA==
Date:   Thu, 9 Apr 2020 15:22:32 +0000
Message-ID: <a4435d728e7231515a2cd96b01e22076559d8e25.camel@marvell.com>
References: <4473787e1b6bc3cc226067e8d122092a678b63de.camel@marvell.com>
         <aed12dd15ea2981bc9554cfa8b5e273c1342c756.camel@marvell.com>
         <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
In-Reply-To: <07c25c246c55012981ec0296eee23e68c719333a.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 239b59e9-a910-4867-7fcf-08d7dc99d365
x-ms-traffictypediagnostic: BYAPR18MB3749:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB3749705B6B1EB2894809AF91BCC10@BYAPR18MB3749.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(64756008)(316002)(186003)(26005)(66446008)(81156014)(2616005)(8936002)(66476007)(4326008)(7416002)(54906003)(478600001)(81166007)(6506007)(66946007)(71200400001)(110136005)(86362001)(6486002)(76116006)(8676002)(2906002)(36756003)(66556008)(5660300002)(6512007);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xhlciNWQF+aPuGaIoo+DlISTLSd21btZTffx76IU+nCvMJuci0FBQyN/btEXCxobgJyxBzuhYYErT4FuaHOzeqVTcFwJIteiU2p3pQU6lCQCzd8hynyzl8dmvi/0soRKCZUjQKQJsHZHK8X6rzfDwJjwHfbQE4+UL0WhRxptYciTDXdNxT+l4AhwymE2fFqlvVXaKewNv9aLk6KIPG09sL+/lD3cQ2m97gaJC69Ge5Nj3+2WBKX3KEDRr/LoxcmlMJzN/pIatqPHal8LvyiwvAAS7QZzRRaoqHgtq89NVKRZuztIBWfH4O+Xov0IwW6DsZ9Fv8bvtlZPCTME6kACk+cArhPeEDtDo9YhtL3dPkezkHxDKRLGlzwL3x6P1/edHmdtvAqY9Fo44SOCJKXTA/2h1pYevViubQtgrTzr6JdXZ2Cy0ziQxWmmtaJRU7Qu
x-ms-exchange-antispam-messagedata: uIDDJwJFr6TzjaO57IM+cI5maOuIZnX12TVLNRYzneJlNg+7l7h309c28l3ZLZGiUdVmusiJvwgiqdTGqvuIvDkoFYu3S26qEUafhisg9zsMOk8ZBAcebqQSqTfNhrLDuFl3OnRlm9D3DXulJeA3Mw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1B68DDB1EE495418E432705A09E5C79@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 239b59e9-a910-4867-7fcf-08d7dc99d365
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:22:32.9027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ppy5GV520riWx3TBAFv3zS2YWPb4vzuDFP8IBjCw34nmaaldvXN4mc2mgT5J/VvVVHdHHc1chas7gT+zvCn2Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB3749
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQ2hyaXMgTWV0Y2FsZiA8Y21ldGNhbGZAbWVsbGFub3guY29tPg0KDQpJbiBwcmVwYXJl
X2V4aXRfdG9fdXNlcm1vZGUoKSwgcnVuIGNsZWFudXAgZm9yIHRhc2tzIGV4aXRlZCBmcm9taQ0K
aXNvbGF0aW9uIGFuZCBjYWxsIHRhc2tfaXNvbGF0aW9uX3N0YXJ0KCkgZm9yIHRhc2tzIHRoYXQg
ZW50ZXJlZA0KVElGX1RBU0tfSVNPTEFUSU9OLg0KDQpJbiBzeXNjYWxsX3RyYWNlX2VudGVyX3Bo
YXNlMSgpLCBhZGQgdGhlIG5lY2Vzc2FyeSBzdXBwb3J0IGZvcg0KcmVwb3J0aW5nIHN5c2NhbGxz
IGZvciB0YXNrLWlzb2xhdGlvbiBwcm9jZXNzZXMuDQoNCkFkZCB0YXNrX2lzb2xhdGlvbl9yZW1v
dGUoKSBjYWxscyBmb3IgdGhlIGtlcm5lbCBleGNlcHRpb24gdHlwZXMNCnRoYXQgZG8gbm90IHJl
c3VsdCBpbiBzaWduYWxzLCBuYW1lbHkgbm9uLXNpZ25hbGxpbmcgcGFnZSBmYXVsdHMuDQoNClNp
Z25lZC1vZmYtYnk6IENocmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4NClthYmVs
aXRzQG1hcnZlbGwuY29tOiBhZGFwdGVkIGZvciBrZXJuZWwgNS42XQ0KU2lnbmVkLW9mZi1ieTog
QWxleCBCZWxpdHMgPGFiZWxpdHNAbWFydmVsbC5jb20+DQotLS0NCiBhcmNoL3g4Ni9LY29uZmln
ICAgICAgICAgICAgICAgICAgIHwgIDEgKw0KIGFyY2gveDg2L2VudHJ5L2NvbW1vbi5jICAgICAg
ICAgICAgfCAxNSArKysrKysrKysrKysrKysNCiBhcmNoL3g4Ni9pbmNsdWRlL2FzbS9hcGljLmgg
ICAgICAgIHwgIDMgKysrDQogYXJjaC94ODYvaW5jbHVkZS9hc20vdGhyZWFkX2luZm8uaCB8ICA0
ICsrKy0NCiBhcmNoL3g4Ni9rZXJuZWwvYXBpYy9pcGkuYyAgICAgICAgIHwgIDIgKysNCiBhcmNo
L3g4Ni9tbS9mYXVsdC5jICAgICAgICAgICAgICAgIHwgIDQgKysrKw0KIDYgZmlsZXMgY2hhbmdl
ZCwgMjggaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYvS2NvbmZpZyBiL2FyY2gveDg2L0tjb25maWcNCmluZGV4IGJlZWE3NzA0NmY5Yi4uOWVhNmQz
ZTZlNzdkIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvS2NvbmZpZw0KKysrIGIvYXJjaC94ODYvS2Nv
bmZpZw0KQEAgLTE0NCw2ICsxNDQsNyBAQCBjb25maWcgWDg2DQogCXNlbGVjdCBIQVZFX0FSQ0hf
Q09NUEFUX01NQVBfQkFTRVMJaWYgTU1VICYmIENPTVBBVA0KIAlzZWxlY3QgSEFWRV9BUkNIX1BS
RUwzMl9SRUxPQ0FUSU9OUw0KIAlzZWxlY3QgSEFWRV9BUkNIX1NFQ0NPTVBfRklMVEVSDQorCXNl
bGVjdCBIQVZFX0FSQ0hfVEFTS19JU09MQVRJT04NCiAJc2VsZWN0IEhBVkVfQVJDSF9USFJFQURf
U1RSVUNUX1dISVRFTElTVA0KIAlzZWxlY3QgSEFWRV9BUkNIX1NUQUNLTEVBSw0KIAlzZWxlY3Qg
SEFWRV9BUkNIX1RSQUNFSE9PSw0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2VudHJ5L2NvbW1vbi5j
IGIvYXJjaC94ODYvZW50cnkvY29tbW9uLmMNCmluZGV4IDk3NDc4NzY5ODBiNS4uYmE4Y2Q3NWRj
N2NmIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYvZW50cnkvY29tbW9uLmMNCisrKyBiL2FyY2gveDg2
L2VudHJ5L2NvbW1vbi5jDQpAQCAtMjYsNiArMjYsNyBAQA0KICNpbmNsdWRlIDxsaW51eC9saXZl
cGF0Y2guaD4NCiAjaW5jbHVkZSA8bGludXgvc3lzY2FsbHMuaD4NCiAjaW5jbHVkZSA8bGludXgv
dWFjY2Vzcy5oPg0KKyNpbmNsdWRlIDxsaW51eC9pc29sYXRpb24uaD4NCiANCiAjaW5jbHVkZSA8
YXNtL2Rlc2MuaD4NCiAjaW5jbHVkZSA8YXNtL3RyYXBzLmg+DQpAQCAtODYsNiArODcsMTUgQEAg
c3RhdGljIGxvbmcgc3lzY2FsbF90cmFjZV9lbnRlcihzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJ
CQlyZXR1cm4gLTFMOw0KIAl9DQogDQorCS8qDQorCSAqIEluIHRhc2sgaXNvbGF0aW9uIG1vZGUs
IHdlIG1heSBwcmV2ZW50IHRoZSBzeXNjYWxsIGZyb20NCisJICogcnVubmluZywgYW5kIGlmIHNv
IHdlIGFsc28gZGVsaXZlciBhIHNpZ25hbCB0byB0aGUgcHJvY2Vzcy4NCisJICovDQorCWlmICh3
b3JrICYgX1RJRl9UQVNLX0lTT0xBVElPTikgew0KKwkJaWYgKHRhc2tfaXNvbGF0aW9uX3N5c2Nh
bGwocmVncy0+b3JpZ19heCkgPT0gLTEpDQorCQkJcmV0dXJuIC0xTDsNCisJCXdvcmsgJj0gfl9U
SUZfVEFTS19JU09MQVRJT047DQorCX0NCiAjaWZkZWYgQ09ORklHX1NFQ0NPTVANCiAJLyoNCiAJ
ICogRG8gc2VjY29tcCBhZnRlciBwdHJhY2UsIHRvIGNhdGNoIGFueSB0cmFjZXIgY2hhbmdlcy4N
CkBAIC0xODksNiArMTk5LDggQEAgX192aXNpYmxlIGlubGluZSB2b2lkIHByZXBhcmVfZXhpdF90
b191c2VybW9kZShzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJbG9ja2RlcF9hc3NlcnRfaXJxc19k
aXNhYmxlZCgpOw0KIAlsb2NrZGVwX3N5c19leGl0KCk7DQogDQorCXRhc2tfaXNvbGF0aW9uX2No
ZWNrX3J1bl9jbGVhbnVwKCk7DQorDQogCWNhY2hlZF9mbGFncyA9IFJFQURfT05DRSh0aS0+Zmxh
Z3MpOw0KIA0KIAlpZiAodW5saWtlbHkoY2FjaGVkX2ZsYWdzICYgRVhJVF9UT19VU0VSTU9ERV9M
T09QX0ZMQUdTKSkNCkBAIC0yMDQsNiArMjE2LDkgQEAgX192aXNpYmxlIGlubGluZSB2b2lkIHBy
ZXBhcmVfZXhpdF90b191c2VybW9kZShzdHJ1Y3QgcHRfcmVncyAqcmVncykNCiAJaWYgKHVubGlr
ZWx5KGNhY2hlZF9mbGFncyAmIF9USUZfTkVFRF9GUFVfTE9BRCkpDQogCQlzd2l0Y2hfZnB1X3Jl
dHVybigpOw0KIA0KKwlpZiAoY2FjaGVkX2ZsYWdzICYgX1RJRl9UQVNLX0lTT0xBVElPTikNCisJ
CXRhc2tfaXNvbGF0aW9uX3N0YXJ0KCk7DQorDQogI2lmZGVmIENPTkZJR19DT01QQVQNCiAJLyoN
CiAJICogQ29tcGF0IHN5c2NhbGxzIHNldCBUU19DT01QQVQuICBNYWtlIHN1cmUgd2UgY2xlYXIg
aXQgYmVmb3JlDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vYXBpYy5oIGIvYXJj
aC94ODYvaW5jbHVkZS9hc20vYXBpYy5oDQppbmRleCAxOWU5NGFmOWNjNWQuLjcxMTQ5YWJiYjBh
MCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2FwaWMuaA0KKysrIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vYXBpYy5oDQpAQCAtMyw2ICszLDcgQEANCiAjZGVmaW5lIF9BU01fWDg2
X0FQSUNfSA0KIA0KICNpbmNsdWRlIDxsaW51eC9jcHVtYXNrLmg+DQorI2luY2x1ZGUgPGxpbnV4
L2lzb2xhdGlvbi5oPg0KIA0KICNpbmNsdWRlIDxhc20vYWx0ZXJuYXRpdmUuaD4NCiAjaW5jbHVk
ZSA8YXNtL2NwdWZlYXR1cmUuaD4NCkBAIC01MjQsNiArNTI1LDcgQEAgZXh0ZXJuIHZvaWQgaXJx
X2V4aXQodm9pZCk7DQogDQogc3RhdGljIGlubGluZSB2b2lkIGVudGVyaW5nX2lycSh2b2lkKQ0K
IHsNCisJdGFza19pc29sYXRpb25faW50ZXJydXB0KCJpcnEiKTsNCiAJaXJxX2VudGVyKCk7DQog
CWt2bV9zZXRfY3B1X2wxdGZfZmx1c2hfbDFkKCk7DQogfQ0KQEAgLTUzNiw2ICs1MzgsNyBAQCBz
dGF0aWMgaW5saW5lIHZvaWQgZW50ZXJpbmdfYWNrX2lycSh2b2lkKQ0KIA0KIHN0YXRpYyBpbmxp
bmUgdm9pZCBpcGlfZW50ZXJpbmdfYWNrX2lycSh2b2lkKQ0KIHsNCisJdGFza19pc29sYXRpb25f
aW50ZXJydXB0KCJhY2sgaXJxIik7DQogCWlycV9lbnRlcigpOw0KIAlhY2tfQVBJQ19pcnEoKTsN
CiAJa3ZtX3NldF9jcHVfbDF0Zl9mbHVzaF9sMWQoKTsNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90aHJlYWRfaW5mby5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGhyZWFkX2lu
Zm8uaA0KaW5kZXggY2Y0MzI3OTg2ZTk4Li42MGQxMDdmNzg0ZWUgMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90aHJlYWRfaW5mby5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90aHJlYWRfaW5mby5oDQpAQCAtOTIsNiArOTIsNyBAQCBzdHJ1Y3QgdGhyZWFkX2luZm8gew0K
ICNkZWZpbmUgVElGX05PQ1BVSUQJCTE1CS8qIENQVUlEIGlzIG5vdCBhY2Nlc3NpYmxlIGluIHVz
ZXJsYW5kICovDQogI2RlZmluZSBUSUZfTk9UU0MJCTE2CS8qIFRTQyBpcyBub3QgYWNjZXNzaWJs
ZSBpbiB1c2VybGFuZCAqLw0KICNkZWZpbmUgVElGX0lBMzIJCTE3CS8qIElBMzIgY29tcGF0aWJp
bGl0eSBwcm9jZXNzICovDQorI2RlZmluZSBUSUZfVEFTS19JU09MQVRJT04JMTgJLyogdGFzayBp
c29sYXRpb24gZW5hYmxlZCBmb3IgdGFzayAqLw0KICNkZWZpbmUgVElGX05PSFoJCTE5CS8qIGlu
IGFkYXB0aXZlIG5vaHogbW9kZSAqLw0KICNkZWZpbmUgVElGX01FTURJRQkJMjAJLyogaXMgdGVy
bWluYXRpbmcgZHVlIHRvIE9PTSBraWxsZXIgKi8NCiAjZGVmaW5lIFRJRl9QT0xMSU5HX05SRkxB
RwkyMQkvKiBpZGxlIGlzIHBvbGxpbmcgZm9yIFRJRl9ORUVEX1JFU0NIRUQgKi8NCkBAIC0xMjIs
NiArMTIzLDcgQEAgc3RydWN0IHRocmVhZF9pbmZvIHsNCiAjZGVmaW5lIF9USUZfTk9DUFVJRAkJ
KDEgPDwgVElGX05PQ1BVSUQpDQogI2RlZmluZSBfVElGX05PVFNDCQkoMSA8PCBUSUZfTk9UU0Mp
DQogI2RlZmluZSBfVElGX0lBMzIJCSgxIDw8IFRJRl9JQTMyKQ0KKyNkZWZpbmUgX1RJRl9UQVNL
X0lTT0xBVElPTgkoMSA8PCBUSUZfVEFTS19JU09MQVRJT04pDQogI2RlZmluZSBfVElGX05PSFoJ
CSgxIDw8IFRJRl9OT0haKQ0KICNkZWZpbmUgX1RJRl9QT0xMSU5HX05SRkxBRwkoMSA8PCBUSUZf
UE9MTElOR19OUkZMQUcpDQogI2RlZmluZSBfVElGX0lPX0JJVE1BUAkJKDEgPDwgVElGX0lPX0JJ
VE1BUCkNCkBAIC0xNDAsNyArMTQyLDcgQEAgc3RydWN0IHRocmVhZF9pbmZvIHsNCiAjZGVmaW5l
IF9USUZfV09SS19TWVNDQUxMX0VOVFJZCVwNCiAJKF9USUZfU1lTQ0FMTF9UUkFDRSB8IF9USUZf
U1lTQ0FMTF9FTVUgfCBfVElGX1NZU0NBTExfQVVESVQgfAlcDQogCSBfVElGX1NFQ0NPTVAgfCBf
VElGX1NZU0NBTExfVFJBQ0VQT0lOVCB8CVwNCi0JIF9USUZfTk9IWikNCisJIF9USUZfTk9IWiB8
IF9USUZfVEFTS19JU09MQVRJT04pDQogDQogLyogZmxhZ3MgdG8gY2hlY2sgaW4gX19zd2l0Y2hf
dG8oKSAqLw0KICNkZWZpbmUgX1RJRl9XT1JLX0NUWFNXX0JBU0UJCQkJCVwNCmRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rZXJuZWwvYXBpYy9pcGkuYyBiL2FyY2gveDg2L2tlcm5lbC9hcGljL2lwaS5j
DQppbmRleCA2Y2EwZjkxMzcyZmQuLmI0ZGZhYWQ2YTQ0MCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2
L2tlcm5lbC9hcGljL2lwaS5jDQorKysgYi9hcmNoL3g4Ni9rZXJuZWwvYXBpYy9pcGkuYw0KQEAg
LTIsNiArMiw3IEBADQogDQogI2luY2x1ZGUgPGxpbnV4L2NwdW1hc2suaD4NCiAjaW5jbHVkZSA8
bGludXgvc21wLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0KIA0KICNpbmNsdWRl
ICJsb2NhbC5oIg0KIA0KQEAgLTY3LDYgKzY4LDcgQEAgdm9pZCBuYXRpdmVfc21wX3NlbmRfcmVz
Y2hlZHVsZShpbnQgY3B1KQ0KIAkJV0FSTigxLCAic2NoZWQ6IFVuZXhwZWN0ZWQgcmVzY2hlZHVs
ZSBvZiBvZmZsaW5lIENQVSMlZCFcbiIsIGNwdSk7DQogCQlyZXR1cm47DQogCX0NCisJdGFza19p
c29sYXRpb25fcmVtb3RlKGNwdSwgInJlc2NoZWR1bGUgSVBJIik7DQogCWFwaWMtPnNlbmRfSVBJ
KGNwdSwgUkVTQ0hFRFVMRV9WRUNUT1IpOw0KIH0NCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9t
bS9mYXVsdC5jIGIvYXJjaC94ODYvbW0vZmF1bHQuYw0KaW5kZXggZmE0ZWEwOTU5M2FiLi4yMTc1
YTg2NTVhN2QgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9tbS9mYXVsdC5jDQorKysgYi9hcmNoL3g4
Ni9tbS9mYXVsdC5jDQpAQCAtMTgsNiArMTgsNyBAQA0KICNpbmNsdWRlIDxsaW51eC91YWNjZXNz
Lmg+CQkvKiBmYXVsdGhhbmRsZXJfZGlzYWJsZWQoKQkqLw0KICNpbmNsdWRlIDxsaW51eC9lZmku
aD4JCQkvKiBlZmlfcmVjb3Zlcl9mcm9tX3BhZ2VfZmF1bHQoKSovDQogI2luY2x1ZGUgPGxpbnV4
L21tX3R5cGVzLmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPgkJLyogdGFza19pc29s
YXRpb25faW50ZXJydXB0ICAgICAqLw0KIA0KICNpbmNsdWRlIDxhc20vY3B1ZmVhdHVyZS5oPgkJ
LyogYm9vdF9jcHVfaGFzLCAuLi4JCSovDQogI2luY2x1ZGUgPGFzbS90cmFwcy5oPgkJCS8qIGRv
dHJhcGxpbmthZ2UsIC4uLgkJKi8NCkBAIC0xNDgzLDYgKzE0ODQsOSBAQCB2b2lkIGRvX3VzZXJf
YWRkcl9mYXVsdChzdHJ1Y3QgcHRfcmVncyAqcmVncywNCiAJCXBlcmZfc3dfZXZlbnQoUEVSRl9D
T1VOVF9TV19QQUdFX0ZBVUxUU19NSU4sIDEsIHJlZ3MsIGFkZHJlc3MpOw0KIAl9DQogDQorCS8q
IE5vIHNpZ25hbCB3YXMgZ2VuZXJhdGVkLCBidXQgbm90aWZ5IHRhc2staXNvbGF0aW9uIHRhc2tz
LiAqLw0KKwl0YXNrX2lzb2xhdGlvbl9pbnRlcnJ1cHQoInBhZ2UgZmF1bHQgYXQgJSNseCIsIGFk
ZHJlc3MpOw0KKw0KIAljaGVja192ODA4Nl9tb2RlKHJlZ3MsIGFkZHJlc3MsIHRzayk7DQogfQ0K
IE5PS1BST0JFX1NZTUJPTChkb191c2VyX2FkZHJfZmF1bHQpOw0KLS0gDQoyLjIwLjENCg0K
