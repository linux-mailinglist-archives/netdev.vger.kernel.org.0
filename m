Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F85229ADF
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 16:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732827AbgGVO7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 10:59:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41176 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730465AbgGVO7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 10:59:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06MEmwsv012225;
        Wed, 22 Jul 2020 07:59:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=10AT4bIlylh+LqvjNLjxzqlnqqFrfd3Q9NSD6y1rGNs=;
 b=eYV0jDsBzQD1G4kxZm1E5pOeTkJ1S8Ad2j7gN9NaW5DlODE0N2O9x3fn2JdCVVLRX59j
 0WZLZWn3t+h1yPe0sZK6bxRm7dl5Knihp28FLty81WKbUt9KhOtwBKPdAnZGODR7fprW
 mp8iNp3GeYOY47y7Y+lGBD8InVRIseLvCni5V72uNlTm7LcroYUL0jjMX+OeUI5Y7/Uf
 yLSrvqWKNrYtgYWW4sxTk2POoFur7KAnnftb7v6//nFxDAMW3bmNwx9rHL8ABZHxkHCS
 QAduYybfEWCOVf5WVAIecCqA0hMOuWH+sMN0uwhxGljIgGBkjrch6xpXYW9GAlZvFOMo KA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 32c0kkrbvy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 Jul 2020 07:59:19 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 22 Jul
 2020 07:59:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 22 Jul 2020 07:59:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bBbnrt582VYmuzGJgEvICo8x3wDdb/XXYXEAjzFKtPi/aVt2gZC84jKEisvzahuClypRv1oNA1EppYdW8sWvNNXxvMLKeuY03QR8TpHkTOcml/cntcd3u/ny93JqLf1eVKF5vh3KEIjmFvdflX6RKdmSWciG025ka2QK/TP7GuGCT6ED/IOsDq4fsfdu2V4TuGtC7wjqvCryczxlVmxAERyHRHFPgV5CAdcG8+p1dH0i+7E8Ihy9XyUWSF7PDOS7Nse2sYJrJIITOPdZnVHiS0I6stLiQkwluq5IuHB9GuNOSdNpbABI29vRWg5D2IlrfZujleo0IA/guUZK8Kr+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10AT4bIlylh+LqvjNLjxzqlnqqFrfd3Q9NSD6y1rGNs=;
 b=eZ88cXtHsk0vtqbayk6nCmn4pzetG/Lj/Q+UzxXWeZ6qXYocQBvdQtBZjTdT3C1+gc8dWJP8G3ytCBWGPpzv5KQ65ceOmA+P17p/ddW2jTtkHOxVuoMIwGl2fPUT+7fRD5PaOUMYcbjQWkWFofQ6VPRvxZ3EQcUOtgec7x/zb96N0CmlmWO+GcvGghQ73eXl+sQ2MY+Fmuae57FuoDyhg3FZKXPIq6AbT8pob7EzYvliEiO0ve3yMs/FgmRdR9cU4lvFL6zhFN0z/qpS3EdSF/lhDEiaOmGbnXkaoJdu1WdLMoAe7NCaG32TyFerslTGmlXQpSoF5DX7UCpeAvxzdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10AT4bIlylh+LqvjNLjxzqlnqqFrfd3Q9NSD6y1rGNs=;
 b=cBfbVZ97VkaCNO+e+b8JebOG6R9xvwzne32IGmQ4Tupld/dmYsoOcU2wv3o49ozCk5kbGqgrshyc8spV3xrzSsr4VwBctBBx5huNJoWQMtctHCXJfVDmDn8GYdMdtj7aIjr8LJ69Uq6Bw8eW3d69NhCpOYSX4oqyA5WTI+GUbyE=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MW2PR18MB2156.namprd18.prod.outlook.com (2603:10b6:907:a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Wed, 22 Jul
 2020 14:59:13 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::b9a6:a3f2:2263:dc32%4]) with mapi id 15.20.3195.026; Wed, 22 Jul 2020
 14:59:13 +0000
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
Subject: [PATCH v4 12/13] task_isolation: ringbuffer: don't interrupt CPUs
 running isolated tasks on buffer resize
Thread-Topic: [PATCH v4 12/13] task_isolation: ringbuffer: don't interrupt
 CPUs running isolated tasks on buffer resize
Thread-Index: AQHWYDipehJFQ80zLEqG2+MBm9Fm7A==
Date:   Wed, 22 Jul 2020 14:59:13 +0000
Message-ID: <041a4c844b4a0f69aba6df4686e1952dd0f91931.camel@marvell.com>
References: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
In-Reply-To: <04be044c1bcd76b7438b7563edc35383417f12c8.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 586cab22-9cf0-4e35-07d5-08d82e4fcc0e
x-ms-traffictypediagnostic: MW2PR18MB2156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB21566BAA75713E361F82E62FBC790@MW2PR18MB2156.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g/rG6B3bl1C8XptqxTm69bNTncIU8+KFD1NqsYEpBnh+lGDeWHJ5HkSgXL8t1DRY8Hq/We4e1CGeiz58g+TPvq12t+tEyZOoPNnY1zq4QCkD77bcuKUsg4LtMXwkituEhDrpJTVFOd1OP+S6PglUb5USnRQLbCpEzPMIcdRzBx7VWuAiD+gQrwpxkbnq6lgZrtXLvLr9cDab0nD+jiKqdnz7K17rv9dyhUND6BVr583hV7cxZRvwOVqgMU/+5EqxIf6w/5mB0JC0tcl8xddNCGdqaW0nR8R4QWpvPea4dXuKi/wL0hgwo00ew6pIWh4HkLW0sCmvB0Txfx139NWehw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(110136005)(6486002)(2906002)(6506007)(54906003)(66476007)(478600001)(6512007)(8936002)(2616005)(8676002)(316002)(4326008)(66946007)(186003)(64756008)(86362001)(83380400001)(76116006)(91956017)(5660300002)(66446008)(36756003)(66556008)(26005)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6x3a8HY0WvuASH2wmVrBcT7rU/tL/KLtA9sNgal6lPTJ6+CVdmFXwcpsn3gFUyVrEcX/YTvq2NUAt1swKCwiF5qCjxVWFDVV85ncBJ9iPH53ebx53KRBZLdgX7u+p3pujBaSnaEKKdXbFi8xb5xnVADedmiIJsvTU7tNezC7vozNuBB10Z3eyVtQBGWg1SuUb+e9m8FwuJewXTZDCczIyJ4xeNrWkqcsRT+a6DMIUgrjYw/2B/gp2aUfDU0w7Hva6WTKGx1Kr81dmQfk07zxYaxAdIYGVMrmj/1SD0QMxkiimv+xH+aNSu8D9zGoheS9hnYxAeW83oXwo8LVAHMTMCu7MUadQcd+XqtsAoBFn/nQBUwUV7xtOL6lLrYQpvN3WmsBwRnkuJAezcPVT/XLWxw+acyarfTEo+j1bnHpir3y+BciVCGDWiwkPFC48Hhwr1lBDH+J2+e+FoHr/8Gwq0DeW52RgMD7VcaZ8uq/c69oWQppmbcyDIOVTnNkjzYg
Content-Type: text/plain; charset="utf-8"
Content-ID: <5763AE40EEE4674CB00A185A60CF3731@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 586cab22-9cf0-4e35-07d5-08d82e4fcc0e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2020 14:59:13.2631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38yJa+FR9/bJKRNd1klcRODFvVOX0EeSawGWXD2mWwDNzpi6t1WgrU5M7lw8f/1D0f6zo6bU8lOh8LmDs9+HAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2156
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-22_08:2020-07-22,2020-07-22 signatures=0
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
Y2UvcmluZ19idWZmZXIuYyBiL2tlcm5lbC90cmFjZS9yaW5nX2J1ZmZlci5jDQppbmRleCAwMDg2
N2ZmODI0MTIuLjIyZDQ3MzFmMGRlZiAxMDA2NDQNCi0tLSBhL2tlcm5lbC90cmFjZS9yaW5nX2J1
ZmZlci5jDQorKysgYi9rZXJuZWwvdHJhY2UvcmluZ19idWZmZXIuYw0KQEAgLTIxLDYgKzIxLDcg
QEANCiAjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCiAjaW5jbHVkZSA8bGludXgvc2xhYi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9pbml0Lmg+DQorI2luY2x1ZGUgPGxpbnV4L2lzb2xhdGlvbi5oPg0K
ICNpbmNsdWRlIDxsaW51eC9oYXNoLmg+DQogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4NCiAjaW5j
bHVkZSA8bGludXgvY3B1Lmg+DQpAQCAtMTcwNSw2ICsxNzA2LDM4IEBAIHN0YXRpYyB2b2lkIHVw
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
cjogdGhlIGJ1ZmZlciB0byByZXNpemUuDQpAQCAtMTc5NCwxMyArMTgyNywyMiBAQCBpbnQgcmlu
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
CiANCkBAIC0xODQ5LDEzICsxODkxLDIyIEBAIGludCByaW5nX2J1ZmZlcl9yZXNpemUoc3RydWN0
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
IA0KMi4yNi4yDQoNCg==
