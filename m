Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05AC119197
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 21:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfLJULa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 15:11:30 -0500
Received: from mail-eopbgr1400130.outbound.protection.outlook.com ([40.107.140.130]:2513
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbfLJULa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 15:11:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TENl+fk5ps4GBjrb7J4Ksn6hAyjTO87eVTOoy8gRy8YuKncvDCSSOPfMBCpT9whYQ+ihaDWu5bcEofkOjwKn4elKYI34q1Rgk4UrufpV/HH6No5E1XFPq0O9d/JlYtBdqyrC6XQrCqq3+7MlDranKfkW0Z3XV8OI9UmJ3vGwYkaS4vkuQ+ayhGbqK64c2bCZgdLq9u2H4GEUSWs0MAcSeGmCVgXHb7c6wZCJbY6fAgep97TLZX79ouJUir+x40uSTx1rLeFmJW0Lb8zGqSFiNaWpDmeRJivtF5SfEbInKNqHOVXyY1wA4soZfeQfvnjVNyVkm2sW3Yofg+ed5c8BfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xtkc3FFrT8Ge0fFYbXzKM91r3Fb4uYCErErWY2NKvIQ=;
 b=IS9iLhtwP4vvqYrrxrrDWOrmfNY2jF2vohyMuxrWKWRyfrabgjhDcZLiakp27kX34inw3ILGfK/ympT4zWRhRnzhul8z+qQ1szM28jjIxXr0OVFK3s40VFV9ILglvp7zQoaDgIkAAn8H7gLsZdaTElPWxVkwbyNZEFjO8T4Obe0CbzsXjwiqzIbxhrBcGUzwKC78nLx5umd6M0Hfo+uTJnflJegaahDNoQ3bSsq8SY++M05QSRpvU+ZvRLLUpjkwD/JSAhaDIIrbbc6WfkQkZJi6qo4p6syNawhVomTLKI3gLL90kQ8JGZu1X+2XDZLrDbX3253G1/BXKscPP33mVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xtkc3FFrT8Ge0fFYbXzKM91r3Fb4uYCErErWY2NKvIQ=;
 b=ZdBShLQ7v7bKozHxIlC8FqZxUHPum0dxJY1HN1+SYAmJ1Wqu5dDkh21FYQKGuD5TNkVJmsE+7/pse83dnBbMpmoyY+2/FQfaT+Ygusk4fe84crmgmFiQbJEPmNjW634wJbXWtWf9zyO+8xR7ZzC7jptKJm9Wg+N+S32b7xPV85w=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB3105.jpnprd01.prod.outlook.com (52.134.248.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Tue, 10 Dec 2019 20:11:25 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::52c:1c46:6bf0:f01f]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::52c:1c46:6bf0:f01f%4]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 20:11:25 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Antonio Borneo <antonio.borneo@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        YueHaibing <yuehaibing@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptp: clockmatrix: add I2C dependency
Thread-Topic: [PATCH] ptp: clockmatrix: add I2C dependency
Thread-Index: AQHVr5QAx2lSMFz0fk6orfzUzEVPlqezzMcA
Date:   Tue, 10 Dec 2019 20:11:25 +0000
Message-ID: <20191210201111.GA20611@renesas.com>
References: <20191210195648.811120-1-arnd@arndb.de>
In-Reply-To: <20191210195648.811120-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::19) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec537052-0f92-4956-68b3-08d77dad2209
x-ms-traffictypediagnostic: OSAPR01MB3105:
x-microsoft-antispam-prvs: <OSAPR01MB3105557C481FCA4363CB9AABD25B0@OSAPR01MB3105.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(199004)(189003)(2616005)(5660300002)(8936002)(52116002)(1076003)(6512007)(2906002)(66476007)(6506007)(33656002)(6486002)(71200400001)(66556008)(8676002)(316002)(6916009)(54906003)(64756008)(4326008)(186003)(66446008)(26005)(86362001)(81156014)(81166006)(66946007)(478600001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB3105;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ErJ7pia/t9FKIa2qws7WflJ5X3ONLOCJHWWGHxpBnJm2dPLBgl4mDtU2Y/rAWVN+AEMBo5bHdlGDe7mPXUEwzfa6A4QtEo1wm9KBOrUPdYzUzk2awL1nBrQtH2j+IKWds9pwDY3Opnrqu9904IdoYXVC1IHr0ycwbkCsgjIVphHDZNH2+CkKBjyKCMJr9kf4J5cw90zzpLcHl6KRzZiOIl1/vXoAEiKI4xayT/j9ZbXgmhGxAg/dho/T71bIBZseIDNZaLOaMVffkvc3KwvmHndY0i/tkJHBMpKIQsLQFEeiLMC9YwcJfRu0hVk4QjTFpEkc2HE3cDO5xrA9or1VwUglKNUK/6kCX4IaO+dhI3Wee+eUxXj84TvkxfG0R80/rrKshug7HMHlXDnkul15TDaZyVAvQ2cvilw2Nuh5TLVsDcSPP3+C1Cz+ki2vjz9T
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <861C0A262AFA624491479A97B5F79F13@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec537052-0f92-4956-68b3-08d77dad2209
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 20:11:25.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QXn98qYNjiGbhRfvzaSMEIBLf2o1SuKyq2TLyR9DddNGPHPzZ3wy2WROXcEZFznrofue+jpE/ic54viOteIe1sM/uDUMsnlgoXYTHxI+6AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB3105
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBEZWMgMTAsIDIwMTkgYXQgMDI6NTY6MzRQTSBFU1QsIEFybmQgQmVyZ21hbm4gd3Jv
dGU6DQo+V2l0aG91dCBJMkMsIHdlIGdldCBhIGxpbmsgZmFpbHVyZToNCj4NCj5kcml2ZXJzL3B0
cC9wdHBfY2xvY2ttYXRyaXgubzogSW4gZnVuY3Rpb24gYGlkdGNtX3hmZXIuaXNyYS4zJzoNCj5w
dHBfY2xvY2ttYXRyaXguYzooLnRleHQrMHhjYyk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYGky
Y190cmFuc2ZlcicNCj5kcml2ZXJzL3B0cC9wdHBfY2xvY2ttYXRyaXgubzogSW4gZnVuY3Rpb24g
YGlkdGNtX2RyaXZlcl9pbml0JzoNCj5wdHBfY2xvY2ttYXRyaXguYzooLmluaXQudGV4dCsweDE0
KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0byBgaTJjX3JlZ2lzdGVyX2RyaXZlcicNCj5kcml2ZXJz
L3B0cC9wdHBfY2xvY2ttYXRyaXgubzogSW4gZnVuY3Rpb24gYGlkdGNtX2RyaXZlcl9leGl0JzoN
Cj5wdHBfY2xvY2ttYXRyaXguYzooLmV4aXQudGV4dCsweDEwKTogdW5kZWZpbmVkIHJlZmVyZW5j
ZSB0byBgaTJjX2RlbF9kcml2ZXInDQo+DQo+Rml4ZXM6IDNhNmJhN2RjNzc5OSAoInB0cDogQWRk
IGEgcHRwIGNsb2NrIGRyaXZlciBmb3IgSURUIENsb2NrTWF0cml4LiIpDQo+U2lnbmVkLW9mZi1i
eTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4tLS0NCj4gZHJpdmVycy9wdHAvS2Nv
bmZpZyB8IDIgKy0NCj4gMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pDQo+DQo+ZGlmZiAtLWdpdCBhL2RyaXZlcnMvcHRwL0tjb25maWcgYi9kcml2ZXJzL3B0cC9L
Y29uZmlnDQo+aW5kZXggZGMzZDhlY2I0MjMxLi5lMzc3OTdjMGE4NWMgMTAwNjQ0DQo+LS0tIGEv
ZHJpdmVycy9wdHAvS2NvbmZpZw0KPisrKyBiL2RyaXZlcnMvcHRwL0tjb25maWcNCj5AQCAtMTA3
LDcgKzEwNyw3IEBAIGNvbmZpZyBQVFBfMTU4OF9DTE9DS19LVk0NCj4gDQo+IGNvbmZpZyBQVFBf
MTU4OF9DTE9DS19JRFRDTQ0KPiAJdHJpc3RhdGUgIklEVCBDTE9DS01BVFJJWCBhcyBQVFAgY2xv
Y2siDQo+LQlkZXBlbmRzIG9uIFBUUF8xNTg4X0NMT0NLDQo+KwlkZXBlbmRzIG9uIFBUUF8xNTg4
X0NMT0NLICYmIEkyQw0KPiAJZGVmYXVsdCBuDQo+IAloZWxwDQo+IAkgIFRoaXMgZHJpdmVyIGFk
ZHMgc3VwcG9ydCBmb3IgdXNpbmcgSURUIENMT0NLTUFUUklYKFRNKSBhcyBhIFBUUA0KPi0tIA0K
DQpTb3JyeSwgdGhhdCB3YXMgZmxhZ2dlZCBieSAia2J1aWxkIHRlc3Qgcm9ib3QiIE5vdiAyNS4N
Cg0KSSB3YXMgaW4gdGhlIHByb2Nlc3Mgb2YgY3JlYXRpbmcgYSBwYXRjaCBzZXJpZXMgd2l0aCBv
dGhlciB1cGRhdGVzLA0KYnV0IHlvdSBiZWF0IG1lIHRvIHRoZSBwdW5jaC4gIFRoYW5rLXlvdS4N
Cg0KUmV2aWV3ZWQtYnk6IFZpbmNlbnQgQ2hlbmcgIDx2aW5jZW50LmNoZW5nLnhoQHJlbmVzYXMu
Y29tPg0KDQpSZWdhcmRzLA0KVmluY2VudA0K
