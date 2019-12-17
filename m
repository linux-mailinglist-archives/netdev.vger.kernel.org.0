Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B7123233
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbfLQQUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:54 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:52522
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728527AbfLQQUw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:20:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnmwTkkPdMXq4qmuns+z0QRn0EimT/siyQIzO0EgMwWCTo/0sFySx/H/kYDTOY+ynqVNCzwVY76/jKwqv2z17VCR3Iz9HAFKg2pG+NO+j2b9FA6n6C2vwzrKeoGDrM+U6lIzKZ/a++qn/N/wqDgGdSqtDNM60mniJtC+YSMWy0zALHfbtr/fJEEZWFjmjhsQ/J1JDVMX2DLQVIt7rC/c6AR0R+vVKrF6eeyWredhAdvkNkBEL5Pd6OD0o5ZBhixaWY0gu0wbMBtiUs29lMpDIbWWNWIyhEcE5Gf/WEBljm2SvNOXmT1QVbFtKuhyJyKlA3mWG9aCAosB8U5k/kA+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxCkWBSS9ERmXz2+SQhzVIbnCx811MoNC5e/TdqjHYU=;
 b=HoQGZnlwGBrD3B6tgYShTCj7Nqzm7KHdlAEiqSxe35hc6UfQLAWRgWAMAI0sNIe9Z1b0uL4XL+2+zNOMhHZ4/DVFXDD1dorvdetC3vu9x6lNvlLL0C/STx/con31UqT7bHQIB8D4aQG/tFeKuCmpKyz5NtV+0qlnseZ+ODv1bwmmce2KdwUIPRhqbDYnEVzmmxOseBMna7yl5z/m0jIdx+IVyIxX3whe/i7JVw8bVcoBE2u9gyUeWzJaDDLQm8dysIXKEa15Fj1UPHbFibRF75OmH+2ND8R/HHueSVhR/cEuv8kMAn+hgZfOtvU7ftCyrqfIs0F8+4YznevJrygFWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxCkWBSS9ERmXz2+SQhzVIbnCx811MoNC5e/TdqjHYU=;
 b=CqesdECiQq1iFwCUiV4L3r5rFNlmFh4FR+77UzUoiQNPUZ8wbnZQb0YlTJX5eqb9cIzcvBObfc8kwkVNYrontTZMPLlkJIvhkC5GzRevtwmWsgOvLWaRUKrwJkTaKCvpKmA+5jp0cCt7mPjDF+p0CtlaaZwTbbLpXSU/CoOB9yE=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4259.eurprd05.prod.outlook.com (52.134.126.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:20:47 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::259f:70b4:dab1:8f2%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:20:47 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf v2 4/4] net/ixgbe: Fix concurrency issues between config
 flow and XSK
Thread-Topic: [PATCH bpf v2 4/4] net/ixgbe: Fix concurrency issues between
 config flow and XSK
Thread-Index: AQHVtPXw51X2BxHsYEiQil4hifDEQw==
Date:   Tue, 17 Dec 2019 16:20:47 +0000
Message-ID: <20191217162023.16011-5-maximmi@mellanox.com>
References: <20191217162023.16011-1-maximmi@mellanox.com>
In-Reply-To: <20191217162023.16011-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR02CA0106.eurprd02.prod.outlook.com
 (2603:10a6:208:154::47) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [94.188.199.18]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a25a66de-3e86-41fd-5169-08d7830d12c6
x-ms-traffictypediagnostic: AM0PR05MB4259:|AM0PR05MB4259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB425972E7B55E66F300A11388D1500@AM0PR05MB4259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(54906003)(26005)(66556008)(6506007)(110136005)(66476007)(2906002)(7416002)(64756008)(186003)(5660300002)(66446008)(36756003)(52116002)(1076003)(8676002)(81166006)(71200400001)(86362001)(81156014)(6486002)(107886003)(2616005)(478600001)(316002)(66946007)(6512007)(66574012)(8936002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4259;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: keh7RuEFwRVuXpmogXbkiob6E7axQFPPr0YQ1tpkTmKChD3Cr5+2VLAK8JH4XzyTXQGDlAKPV9InPQ33wddy/0Xo9e64feQ/WWg8pGYVzW+84YWQkUCd2wuDP537YWvLfD0rYWJklTgM5WtZisOdBcmXgrpSUKH/mjvEFOp+LQSlUt9/CzGEqlCjqPUcA1yjGXUAhL21Hrmk+SYQS9qsg0h6ao2FkveTbvqvIWL4FHjalP00TsfdxnIZJv6krUCtNTo6jYHo20acbHIYuzQRkFWDHPBto60OIc4k8Gft83OkV+UK9k8QLKbhUm2NoDZVym4m2Q9AGFZ6MxqR80RS443ZfjJfkckbVyz+pJ6S4v2CnF6A6c9P59sAHBR8ltJVyiaVW9d5n9Q2/jOIL1DdrdJZ0Ig84oGW1CqNgwmJF6EFBrzRZG3CloO1Aa45R9+4
Content-Type: text/plain; charset="utf-8"
Content-ID: <B44FA52414F4E04C8B6638B0D7453DE2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a25a66de-3e86-41fd-5169-08d7830d12c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:20:47.1063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Glq5VOsYcXNC7vu4/jv6NXo/zvWRNIbXDUOtlElY50oC2Nlb+1sD0BXVv5BlqInBp7txhitP7kdEzkbxM9/ftg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VXNlIHN5bmNocm9uaXplX3JjdSB0byB3YWl0IHVudGlsIHRoZSBYU0sgd2FrZXVwIGZ1bmN0aW9u
IGZpbmlzaGVzDQpiZWZvcmUgZGVzdHJveWluZyB0aGUgcmVzb3VyY2VzIGl0IHVzZXM6DQoNCjEu
IGl4Z2JlX2Rvd24gYWxyZWFkeSBjYWxscyBzeW5jaHJvbml6ZV9yY3UgYWZ0ZXIgc2V0dGluZyBf
X0lYR0JFX0RPV04uDQoNCjIuIEFmdGVyIHN3aXRjaGluZyB0aGUgWERQIHByb2dyYW0sIGNhbGwg
c3luY2hyb25pemVfcmN1IHRvIGxldA0KaXhnYmVfeHNrX3dha2V1cCBleGl0IGJlZm9yZSB0aGUg
WERQIHByb2dyYW0gaXMgZnJlZWQuDQoNCjMuIENoYW5naW5nIHRoZSBudW1iZXIgb2YgY2hhbm5l
bHMgYnJpbmdzIHRoZSBpbnRlcmZhY2UgZG93bi4NCg0KNC4gRGlzYWJsaW5nIFVNRU0gc2V0cyBf
X0lYR0JFX1RYX0RJU0FCTEVEIGJlZm9yZSBjbG9zaW5nIGhhcmR3YXJlDQpyZXNvdXJjZXMgYW5k
IHJlc2V0dGluZyB4c2tfdW1lbS4gQ2hlY2sgdGhhdCBiaXQgaW4gaXhnYmVfeHNrX3dha2V1cCB0
bw0KYXZvaWQgdXNpbmcgdGhlIFhEUCByaW5nIHdoZW4gaXQncyBhbHJlYWR5IGRlc3Ryb3llZC4g
c3luY2hyb25pemVfcmN1IGlzDQpjYWxsZWQgZnJvbSBpeGdiZV90eHJ4X3JpbmdfZGlzYWJsZS4N
Cg0KU2lnbmVkLW9mZi1ieTogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNv
bT4NClNpZ25lZC1vZmYtYnk6IEJqw7ZybiBUw7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNvbT4N
Ci0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX21haW4uYyB8IDcg
KysrKysrLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jICB8
IDggKysrKysrLS0NCiAyIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9p
eGdiZV9tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9tYWlu
LmMNCmluZGV4IDI1YzA5N2NkODEwMC4uODJhMzBiNTk3Y2Y5IDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfbWFpbi5jDQorKysgYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV9tYWluLmMNCkBAIC0xMDI2MSw3ICsxMDI2MSwx
MiBAQCBzdGF0aWMgaW50IGl4Z2JlX3hkcF9zZXR1cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBz
dHJ1Y3QgYnBmX3Byb2cgKnByb2cpDQogDQogCS8qIElmIHRyYW5zaXRpb25pbmcgWERQIG1vZGVz
IHJlY29uZmlndXJlIHJpbmdzICovDQogCWlmIChuZWVkX3Jlc2V0KSB7DQotCQlpbnQgZXJyID0g
aXhnYmVfc2V0dXBfdGMoZGV2LCBhZGFwdGVyLT5od190Y3MpOw0KKwkJaW50IGVycjsNCisNCisJ
CWlmICghcHJvZykNCisJCQkvKiBXYWl0IHVudGlsIG5kb194c2tfd2FrZXVwIGNvbXBsZXRlcy4g
Ki8NCisJCQlzeW5jaHJvbml6ZV9yY3UoKTsNCisJCWVyciA9IGl4Z2JlX3NldHVwX3RjKGRldiwg
YWRhcHRlci0+aHdfdGNzKTsNCiANCiAJCWlmIChlcnIpIHsNCiAJCQlyY3VfYXNzaWduX3BvaW50
ZXIoYWRhcHRlci0+eGRwX3Byb2csIG9sZF9wcm9nKTsNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV94c2suYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2l4Z2JlL2l4Z2JlX3hzay5jDQppbmRleCBkNmZlYWFjZmJmODkuLmI0M2JlOWYxNDEw
NSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2l4Z2JlL2l4Z2JlX3hz
ay5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZS9peGdiZV94c2suYw0K
QEAgLTcwOSwxMCArNzA5LDE0IEBAIGludCBpeGdiZV94c2tfd2FrZXVwKHN0cnVjdCBuZXRfZGV2
aWNlICpkZXYsIHUzMiBxaWQsIHUzMiBmbGFncykNCiAJaWYgKHFpZCA+PSBhZGFwdGVyLT5udW1f
eGRwX3F1ZXVlcykNCiAJCXJldHVybiAtRU5YSU87DQogDQotCWlmICghYWRhcHRlci0+eGRwX3Jp
bmdbcWlkXS0+eHNrX3VtZW0pDQorCXJpbmcgPSBhZGFwdGVyLT54ZHBfcmluZ1txaWRdOw0KKw0K
KwlpZiAodGVzdF9iaXQoX19JWEdCRV9UWF9ESVNBQkxFRCwgJnJpbmctPnN0YXRlKSkNCisJCXJl
dHVybiAtRU5FVERPV047DQorDQorCWlmICghcmluZy0+eHNrX3VtZW0pDQogCQlyZXR1cm4gLUVO
WElPOw0KIA0KLQlyaW5nID0gYWRhcHRlci0+eGRwX3JpbmdbcWlkXTsNCiAJaWYgKCFuYXBpX2lm
X3NjaGVkdWxlZF9tYXJrX21pc3NlZCgmcmluZy0+cV92ZWN0b3ItPm5hcGkpKSB7DQogCQl1NjQg
ZWljcyA9IEJJVF9VTEwocmluZy0+cV92ZWN0b3ItPnZfaWR4KTsNCiANCi0tIA0KMi4yMC4xDQoN
Cg==
