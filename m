Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938291A3715
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgDIP1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 11:27:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62058 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728061AbgDIP1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 11:27:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039FOjeH028177;
        Thu, 9 Apr 2020 08:27:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=brVcye4g04z58XKP8Hd8aUsDk8ICA4yESbMdJf0mZFE=;
 b=mcdLy69a6xzyd7ZvUooO4izwoUjjUp0y9Nb0vnaUpsScF29LhRbn2sGY0O6dDlCSRFXd
 i+2M0OOEDh6hVAyqthz8eKSrXqBgk+KbDem7xyOSUWJky13Rlq3098NWn0z8djqTq2az
 YjIxAX3aQmiA5vKHc09fC4zEqhGXa1dcII6Y+Z52+/0fvhTP2tggE34bubToULI6CMb4
 n0qVZq9laJeIWMnbta5U6n00H/3uFFlx93D2SGjbPOxfS9poTXD7mzvrfRLDFo7mzjmC
 XO78lT3IZup7NU3Dk/ZJNaIyaYAQ695WS6lSEM4/xs2faHT7+1T3fSIRKDZ/Hy4kTsp3 iQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 3091me90bj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 08:27:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:27:10 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 9 Apr
 2020 08:27:09 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 9 Apr 2020 08:27:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQsBpe1CkqBQduYIR7oQhBLQvkL+1D+6NWZOI9lLcTx0AVCEx6KatkgDM7mJy+l7EsZ0VvpmBsE1nU5W9gK8IbVj9e6d2yYsjlKPuhUMwfrvGRqfGE6Ci93KoW2fEnVHlOLN+nBxYDTNalfmQ88mNbjevJYbzPLoy6BTxhFxNPYTF9EGg27zTRXUlxUD4/x7E6lxlIoFx/+PdkTmq52Tc594nK3Xgg1hFHKXPwFm6TTwLy/e+5pAf+bk3j2a1VOaJwZBm7aKQF6Ji0Tu0hE67dtNV4MCMO+QRwQ1ohI/eyaJw4YOMrRGbP1fN7ciwwqgJUTvY/7840bzmqwBs2+PxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brVcye4g04z58XKP8Hd8aUsDk8ICA4yESbMdJf0mZFE=;
 b=DmTsiEEoh5QokBuA+NEXOydGMbRXBdfJVMTTiZDYz4OcQWx0p9Qimzx5ig5WtisyXseLv4LzKv3zF79diTtw0K/GpdDoY+GTA4354lzYBkxPOM6UCOAeRiualeQYUNeAmyvLLzELyLmyU08wTd7Q0wvu1qfcCjrFNOqnijbxGw4+MuU9pRAbpjWVzhAONXTA2B2qBcfldKqwNoJW9rTmlPQj1tse90n1lj0rxtVpwVFR9Nteqjm8IXKpUNZPu12UasfT1L3itZWyBiFNnSiFRCwRtjUloSO2oQSM62Pfedt3Mh7HvBiXrnbTVNMyezs6xVC1dRQFz4Czu9qKITJgXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=brVcye4g04z58XKP8Hd8aUsDk8ICA4yESbMdJf0mZFE=;
 b=Rg4YjOjaRacrl7tM9z9ja0uYGN4gc/yGscvS5O3ShXHJlUed/sA7oZg5gD3jJZbKc8rhY5bekQM9Wfq47EXC+kM0h3CseGoCQXelCLgkOC8+N6sRHXrNocj/wjUkbevmla/rsly3fk+uhucIRoxkDZ+x5dJcN44pUEInDuZABp4=
Received: from BYAPR18MB2535.namprd18.prod.outlook.com (2603:10b6:a03:137::17)
 by BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.17; Thu, 9 Apr
 2020 15:27:07 +0000
Received: from BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280]) by BYAPR18MB2535.namprd18.prod.outlook.com
 ([fe80::65f8:9bfe:5fa5:1280%3]) with mapi id 15.20.2878.022; Thu, 9 Apr 2020
 15:27:07 +0000
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
Subject: [PATCH v3 11/13] task_isolation: ringbuffer: don't interrupt CPUs
 running isolated tasks on buffer resize
Thread-Topic: [PATCH v3 11/13] task_isolation: ringbuffer: don't interrupt
 CPUs running isolated tasks on buffer resize
Thread-Index: AQHWDoNUNKRaaRYWTk+1Q1LXrvxHOg==
Date:   Thu, 9 Apr 2020 15:27:07 +0000
Message-ID: <8f4a0e780c7443d44d7af29fd29ed541ca506bad.camel@marvell.com>
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
x-ms-office365-filtering-correlation-id: 5b16547a-afd6-4c36-0692-08d7dc9a772d
x-ms-traffictypediagnostic: BYAPR18MB2423:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB24233DCEFD0207293DFA6C4ABCC10@BYAPR18MB2423.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0368E78B5B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2535.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(86362001)(26005)(186003)(5660300002)(316002)(2616005)(81166007)(36756003)(7416002)(71200400001)(2906002)(76116006)(6486002)(478600001)(6506007)(6512007)(66556008)(64756008)(66446008)(8676002)(81156014)(66476007)(8936002)(66946007)(54906003)(4326008)(110136005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OyJOQlB2lAIYNGF/ofoKa2QH1PRjXAq/vrfgcvPpq6vhbWUT60ddktpgMADmlGhhB9ZgCRzWTfIiwQyt/H+S70cQvvhKylsOHYjevMaWXTjPOpGqKr12ROP0u8E65WKG+iFnlHg9qUEi1SsDEm20vSR1pYHFj1Wqp58CUVTJW/QHet3l1GAL3lQGVLyPbxwqFl/V1c0oKfnQPijEtjMlJs/IdSDBqRAPT4kw7poQ2LlHelQvEt44x8hNYU7AcALyKEHfT4tDKCrTmfMEq1wa5Cbe4SvhJWkLyWPnLN5aJYYEEq3741ZjnRH+NoY8P+8B6umMl0GvPavnWBcOJu3Kh39UHGq3XGZoe9ryBQTOIMS4Qen6W6YFEsDHaCSkTNwOSLwq8uyD0WrWBbvMY6lEzkkKsuuJs45aoKfPLV5Yy/y2QbYLBIiUd+B+XcnW3ON0
x-ms-exchange-antispam-messagedata: MIbUoW2IddncEajEN6GeWc6RN3IicNYtum/iOASTjlRuPhSu3j3yYKuETI4u0WCzEWDkfKjN7CIbTaYMxU96AxoMM2etUwO+CoyO3CW1+awZX7f3Mo1XEQBEyeZwbSY05zxBhiyeUqwkFe/66dxvXQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <50242532F44D2745B5D6A9FFCD5D8962@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b16547a-afd6-4c36-0692-08d7dc9a772d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2020 15:27:07.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Jjm02+PxVACCzcuZO0yWAK6tKoXjCaSZ5j3VOPxs2Vsch40ht1swEPIDzWQH2lOcw9IaL2YxXTDFY130ZoGjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2423
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_05:2020-04-07,2020-04-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPg0KDQpDUFVzIHJ1bm5pbmcgaXNv
bGF0ZWQgdGFza3MgYXJlIGluIHVzZXJzcGFjZSwgc28gdGhleSBkb24ndCBoYXZlIHRvDQpwZXJm
b3JtIHJpbmcgYnVmZmVyIHVwZGF0ZXMgaW1tZWRpYXRlbHkuIElmIHJpbmdfYnVmZmVyX3Jlc2l6
ZSgpDQpzY2hlZHVsZXMgdGhlIHVwZGF0ZSBvbiB0aG9zZSBDUFVzLCBpc29sYXRpb24gaXMgYnJv
a2VuLiBUbyBwcmV2ZW50DQp0aGF0LCB1cGRhdGVzIGZvciBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQg
dGFza3MgYXJlIHBlcmZvcm1lZCBsb2NhbGx5LA0KbGlrZSBmb3Igb2ZmbGluZSBDUFVzLg0KDQpB
IHJhY2UgY29uZGl0aW9uIGJldHdlZW4gdGhpcyB1cGRhdGUgYW5kIGlzb2xhdGlvbiBicmVha2lu
ZyBpcyBhdm9pZGVkDQphdCB0aGUgY29zdCBvZiBkaXNhYmxpbmcgcGVyX2NwdSBidWZmZXIgd3Jp
dGluZyBmb3IgdGhlIHRpbWUgb2YgdXBkYXRlDQp3aGVuIGl0IGNvaW5jaWRlcyB3aXRoIGlzb2xh
dGlvbiBicmVha2luZy4NCg0KU2lnbmVkLW9mZi1ieTogWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZl
bGwuY29tPg0KW2FiZWxpdHNAbWFydmVsbC5jb206IHVwZGF0ZWQgdG8gcHJldmVudCByYWNlIHdp
dGggaXNvbGF0aW9uIGJyZWFraW5nXQ0KU2lnbmVkLW9mZi1ieTogQWxleCBCZWxpdHMgPGFiZWxp
dHNAbWFydmVsbC5jb20+DQotLS0NCiBrZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYyB8IDYzICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDU3
IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9rZXJuZWwvdHJh
Y2UvcmluZ19idWZmZXIuYyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jDQppbmRleCA2MWYw
ZTkyYWNlOTkuLjk3MmYyNmZjMzU0MCAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9yaW5nX2J1
ZmZlci5jDQorKysgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYw0KQEAgLTIxLDYgKzIxLDcg
QEANCiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+DQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5j
bHVkZSA8bGludXgvY3B1Lmg+DQpAQCAtMTcwMSw2ICsxNzAyLDM4IEBAIHN0YXRpYyB2b2lkIHVw
ZGF0ZV9wYWdlc19oYW5kbGVyKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCiAJY29tcGxldGUo
JmNwdV9idWZmZXItPnVwZGF0ZV9kb25lKTsNCiB9DQogDQorc3RhdGljIGJvb2wgdXBkYXRlX2lm
X2lzb2xhdGVkKHN0cnVjdCByaW5nX2J1ZmZlcl9wZXJfY3B1ICpjcHVfYnVmZmVyLA0KKwkJCSAg
ICAgICBpbnQgY3B1KQ0KK3sNCisJYm9vbCBydiA9IGZhbHNlOw0KKw0KKwlzbXBfcm1iKCk7DQor
CWlmICh0YXNrX2lzb2xhdGlvbl9vbl9jcHUoY3B1KSkgew0KKwkJLyoNCisJCSAqIENQVSBpcyBy
dW5uaW5nIGlzb2xhdGVkIHRhc2suIFNpbmNlIGl0IG1heSBsb3NlDQorCQkgKiBpc29sYXRpb24g
YW5kIHJlLWVudGVyIGtlcm5lbCBzaW11bHRhbmVvdXNseSB3aXRoDQorCQkgKiB0aGlzIHVwZGF0
ZSwgZGlzYWJsZSByZWNvcmRpbmcgdW50aWwgaXQncyBkb25lLg0KKwkJICovDQorCQlhdG9taWNf
aW5jKCZjcHVfYnVmZmVyLT5yZWNvcmRfZGlzYWJsZWQpOw0KKwkJLyogTWFrZSBzdXJlLCB1cGRh
dGUgaXMgZG9uZSwgYW5kIGlzb2xhdGlvbiBzdGF0ZSBpcyBjdXJyZW50ICovDQorCQlzbXBfbWIo
KTsNCisJCWlmICh0YXNrX2lzb2xhdGlvbl9vbl9jcHUoY3B1KSkgew0KKwkJCS8qDQorCQkJICog
SWYgQ1BVIGlzIHN0aWxsIHJ1bm5pbmcgaXNvbGF0ZWQgdGFzaywgd2UNCisJCQkgKiBjYW4gYmUg
c3VyZSB0aGF0IGJyZWFraW5nIGlzb2xhdGlvbiB3aWxsDQorCQkJICogaGFwcGVuIHdoaWxlIHJl
Y29yZGluZyBpcyBkaXNhYmxlZCwgYW5kIENQVQ0KKwkJCSAqIHdpbGwgbm90IHRvdWNoIHRoaXMg
YnVmZmVyIHVudGlsIHRoZSB1cGRhdGUNCisJCQkgKiBpcyBkb25lLg0KKwkJCSAqLw0KKwkJCXJi
X3VwZGF0ZV9wYWdlcyhjcHVfYnVmZmVyKTsNCisJCQljcHVfYnVmZmVyLT5ucl9wYWdlc190b191
cGRhdGUgPSAwOw0KKwkJCXJ2ID0gdHJ1ZTsNCisJCX0NCisJCWF0b21pY19kZWMoJmNwdV9idWZm
ZXItPnJlY29yZF9kaXNhYmxlZCk7DQorCX0NCisJcmV0dXJuIHJ2Ow0KK30NCisNCiAvKioNCiAg
KiByaW5nX2J1ZmZlcl9yZXNpemUgLSByZXNpemUgdGhlIHJpbmcgYnVmZmVyDQogICogQGJ1ZmZl
cjogdGhlIGJ1ZmZlciB0byByZXNpemUuDQpAQCAtMTc4NCwxMyArMTgxNywyMiBAQCBpbnQgcmlu
Z19idWZmZXJfcmVzaXplKHN0cnVjdCB0cmFjZV9idWZmZXIgKmJ1ZmZlciwgdW5zaWduZWQgbG9u
ZyBzaXplLA0KIAkJCWlmICghY3B1X2J1ZmZlci0+bnJfcGFnZXNfdG9fdXBkYXRlKQ0KIAkJCQlj
b250aW51ZTsNCiANCi0JCQkvKiBDYW4ndCBydW4gc29tZXRoaW5nIG9uIGFuIG9mZmxpbmUgQ1BV
LiAqLw0KKwkJCS8qDQorCQkJICogQ2FuJ3QgcnVuIHNvbWV0aGluZyBvbiBhbiBvZmZsaW5lIENQ
VS4NCisJCQkgKg0KKwkJCSAqIENQVXMgcnVubmluZyBpc29sYXRlZCB0YXNrcyBkb24ndCBoYXZl
IHRvDQorCQkJICogdXBkYXRlIHJpbmcgYnVmZmVycyB1bnRpbCB0aGV5IGV4aXQNCisJCQkgKiBp
c29sYXRpb24gYmVjYXVzZSB0aGV5IGFyZSBpbg0KKwkJCSAqIHVzZXJzcGFjZS4gVXNlIHRoZSBw
cm9jZWR1cmUgdGhhdCBwcmV2ZW50cw0KKwkJCSAqIHJhY2UgY29uZGl0aW9uIHdpdGggaXNvbGF0
aW9uIGJyZWFraW5nLg0KKwkJCSAqLw0KIAkJCWlmICghY3B1X29ubGluZShjcHUpKSB7DQogCQkJ
CXJiX3VwZGF0ZV9wYWdlcyhjcHVfYnVmZmVyKTsNCiAJCQkJY3B1X2J1ZmZlci0+bnJfcGFnZXNf
dG9fdXBkYXRlID0gMDsNCiAJCQl9IGVsc2Ugew0KLQkJCQlzY2hlZHVsZV93b3JrX29uKGNwdSwN
Ci0JCQkJCQkmY3B1X2J1ZmZlci0+dXBkYXRlX3BhZ2VzX3dvcmspOw0KKwkJCQlpZiAoIXVwZGF0
ZV9pZl9pc29sYXRlZChjcHVfYnVmZmVyLCBjcHUpKQ0KKwkJCQkJc2NoZWR1bGVfd29ya19vbihj
cHUsDQorCQkJCQkmY3B1X2J1ZmZlci0+dXBkYXRlX3BhZ2VzX3dvcmspOw0KIAkJCX0NCiAJCX0N
CiANCkBAIC0xODI5LDEzICsxODcxLDIyIEBAIGludCByaW5nX2J1ZmZlcl9yZXNpemUoc3RydWN0
IHRyYWNlX2J1ZmZlciAqYnVmZmVyLCB1bnNpZ25lZCBsb25nIHNpemUsDQogDQogCQlnZXRfb25s
aW5lX2NwdXMoKTsNCiANCi0JCS8qIENhbid0IHJ1biBzb21ldGhpbmcgb24gYW4gb2ZmbGluZSBD
UFUuICovDQorCQkvKg0KKwkJICogQ2FuJ3QgcnVuIHNvbWV0aGluZyBvbiBhbiBvZmZsaW5lIENQ
VS4NCisJCSAqDQorCQkgKiBDUFVzIHJ1bm5pbmcgaXNvbGF0ZWQgdGFza3MgZG9uJ3QgaGF2ZSB0
byB1cGRhdGUNCisJCSAqIHJpbmcgYnVmZmVycyB1bnRpbCB0aGV5IGV4aXQgaXNvbGF0aW9uIGJl
Y2F1c2UgdGhleQ0KKwkJICogYXJlIGluIHVzZXJzcGFjZS4gVXNlIHRoZSBwcm9jZWR1cmUgdGhh
dCBwcmV2ZW50cw0KKwkJICogcmFjZSBjb25kaXRpb24gd2l0aCBpc29sYXRpb24gYnJlYWtpbmcu
DQorCQkgKi8NCiAJCWlmICghY3B1X29ubGluZShjcHVfaWQpKQ0KIAkJCXJiX3VwZGF0ZV9wYWdl
cyhjcHVfYnVmZmVyKTsNCiAJCWVsc2Ugew0KLQkJCXNjaGVkdWxlX3dvcmtfb24oY3B1X2lkLA0K
KwkJCWlmICghdXBkYXRlX2lmX2lzb2xhdGVkKGNwdV9idWZmZXIsIGNwdV9pZCkpDQorCQkJCXNj
aGVkdWxlX3dvcmtfb24oY3B1X2lkLA0KIAkJCQkJICZjcHVfYnVmZmVyLT51cGRhdGVfcGFnZXNf
d29yayk7DQotCQkJd2FpdF9mb3JfY29tcGxldGlvbigmY3B1X2J1ZmZlci0+dXBkYXRlX2RvbmUp
Ow0KKwkJCQl3YWl0X2Zvcl9jb21wbGV0aW9uKCZjcHVfYnVmZmVyLT51cGRhdGVfZG9uZSk7DQor
CQkJfQ0KIAkJfQ0KIA0KIAkJY3B1X2J1ZmZlci0+bnJfcGFnZXNfdG9fdXBkYXRlID0gMDsNCi0t
IA0KMi4yMC4xDQoNCg==
