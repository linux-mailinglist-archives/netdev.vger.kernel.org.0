Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAC31722C4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 17:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgB0QEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 11:04:30 -0500
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:6109
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729134AbgB0QEa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 11:04:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivvgPZR40+9KcPvab0kF+R/j13V7nv0Pk6jqvCmltAPRTrXjbPtHz7yVOXNUkzZSkzNUa3G/OgyfzdtV89fB3VvK7qqCsURcw7mLtj8IlkHj5/TmrSGGsSCQhpTFwUdjIQbpaymG6pudOLtLwgNH751oQmFhFq1ZG4XXYL6C3yrBIdgyfOEXQxx86qV6ngw4koiptmeGCruHc25WypkRs+iq8LhjJa2gwVey9AznCWs3s5mxiELGW9lPkmFpS9LWuS+4QbMP7vvLtQpQE+yOa8zAVLuiFZWAjyprEgZklZhU/y8IeLQEh1vtBhH7gkY4mQL5CToFhz5XaucqhxQOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KidajWIxG2HEmq1y0luaBMWmsJWy/rbBQNKM7sycwnM=;
 b=LOxX1xOuOLqRUfNP9kVfnvAGlbeUECUIexNimPVIXqKzZHdu/kRLvOg+EwTFy378UBHqOg43wICR0Q3HeUEWB1Yfa8e6B5B07LwDAik+vl+bQPzNmId65ZUCDgUNXd4eXv7AJgBsOV+Xqo8oA0KFh+AifZM7OPNIdH/Fpk4KTDeedZxYz8cM0Fh0Ia/60jOJJQ0qsDC0BCMMjjJEKU0FOpnOFphmXQ8mEG41h/nz0SVAGR8ijXzbshatfDmA9Q/cAaTP1tfGxtIqhjnAZHDXzx8jQ404tb50HXllwc4BuOdSkrC5jNGSfh6deo+utf9o2fyUwTIq9Xdi7ZDrz7DP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KidajWIxG2HEmq1y0luaBMWmsJWy/rbBQNKM7sycwnM=;
 b=ZzHC1bm8dBs6+BF6CxWFQcVjRknFB3KmK9VHAui/EtEv0M0IY+ZK9Rg+bs6l6pyTRxRk2caZfr0YUaJz1zT3tgk66QdDGG45tq5afmGFmkQ2vmH1Ck7esB09OuCHLYBcOOxivqROeUP+fGk/DzAqh2GRVeEcgMrEWNJ+yan7Bl4=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (52.133.240.149) by
 DB8PR04MB5659.eurprd04.prod.outlook.com (20.179.10.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Thu, 27 Feb 2020 16:04:27 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::9484:81c6:c73b:2697%6]) with mapi id 15.20.2750.024; Thu, 27 Feb 2020
 16:04:27 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] dpaa2-eth: add support for nway reset
Thread-Topic: [PATCH] dpaa2-eth: add support for nway reset
Thread-Index: AQHV7WW303qKsCoYhkWtFZt7MSNwq6gvNEEQ
Date:   Thu, 27 Feb 2020 16:04:26 +0000
Message-ID: <DB8PR04MB682862D5DE237600B42A0A1BE0EB0@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <E1j7HrW-0004HW-Pz@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1j7HrW-0004HW-Pz@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: be679b28-5a86-4229-136d-08d7bb9eb879
x-ms-traffictypediagnostic: DB8PR04MB5659:
x-microsoft-antispam-prvs: <DB8PR04MB5659195A9645D34ED5CE99C2E0EB0@DB8PR04MB5659.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 03264AEA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(39860400002)(346002)(376002)(199004)(189003)(55016002)(71200400001)(9686003)(54906003)(316002)(86362001)(2906002)(66446008)(66476007)(7696005)(4326008)(66946007)(33656002)(81156014)(5660300002)(8676002)(52536014)(81166006)(66556008)(8936002)(478600001)(76116006)(26005)(6506007)(44832011)(186003)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB5659;H:DB8PR04MB6828.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KWQymXfeCd7ZW9G4BDPRKWdVKEUepMnGUJ+VNv7+LNu/eBYGFNcfp8QGNyKVoh/FvWYbdAU2PI4zLsapyA5L7B8BTMM23Nerl9586BuwxtCYWnnf689sAphrlULwiciUAOXYBQUVe3/QxqbxOeAvHk7K8VPflXWuki+etry4jNrUFJ1+Q9H5ULegW1IP9Nd3FoRImaYtGkzRmgZKKxPt5Y+jm02B7c7GVVh66hcKz0kkFyGPlXfUrP7WcJb4+GwbVm8UrI9G/z94dqRZAC36ijXpxKFCn+CUitHPVBd8RuG7RFTYaWFvzufHyc350PBmcoOf9kocWTllPW2S/aPfDYWIcQV29lLgW+eP5hh5WRZN0LhU7uj6eUQtk1UHZaUlUwqBdfdCCbjjtzPgdXcvXE7n9LqewfFsHgnkXnRUXKwKkLy5+k1xiohuNx50c9bu
x-ms-exchange-antispam-messagedata: mMdQHD/Ke15m4bMsbRINYFqsdn98cUqi+J1rYIHDhOcAMATSt/sSPPmkzkw2p66qvJx4xdg6sceKuk1aCJPnx+LDU/EnlekAEmFDjbSGgsxe6HIqvbrFLIC6pl8vmne4kowT1/mydq4nhgy4OAUFMw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be679b28-5a86-4229-136d-08d7bb9eb879
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2020 16:04:26.9527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WU6cJeb+PgLxermp5rxFvHCeZ+4/5gwrWQIpzeMX4Zzh7/RLpTlbdlK64ll521yXzdY//VV7KYGJqHaUsqyulw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBTdWJqZWN0OiBbUEFUQ0hdIGRwYWEyLWV0aDogYWRkIHN1cHBvcnQgZm9yIG53YXkgcmVzZXQN
Cj4gDQo+IEFkZCBzdXBwb3J0IGZvciBldGh0b29sIC1yIHNvIHRoYXQgUEhZIG5lZ290aWF0aW9u
IGNhbiBiZSByZXN0YXJ0ZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgPHJt
aytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KDQpBY2tlZC1ieTogSW9hbmEgQ2lvcm5laSA8aW9h
bmEuY2lvcm5laUBueHAuY29tPg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJl
ZXNjYWxlL2RwYWEyL2RwYWEyLWV0aHRvb2wuYyB8IDExICsrKysrKysrKysrDQo+ICAxIGZpbGUg
Y2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFhMi1ldGh0b29sLmMNCj4gYi9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRodG9vbC5jDQo+IGluZGV4IDk2Njc2
YWJjZWJkNS4uOTQzNDdjNjk1MjMzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZHBhYTIvZHBhYTItZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9kcGFhMi9kcGFhMi1ldGh0b29sLmMNCj4gQEAgLTc5LDYgKzc5LDE2
IEBAIHN0YXRpYyB2b2lkIGRwYWEyX2V0aF9nZXRfZHJ2aW5mbyhzdHJ1Y3QgbmV0X2RldmljZQ0K
PiAqbmV0X2RldiwNCj4gIAkJc2l6ZW9mKGRydmluZm8tPmJ1c19pbmZvKSk7DQo+ICB9DQo+IA0K
PiArc3RhdGljIGludCBkcGFhMl9ldGhfbndheV9yZXNldChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
X2Rldikgew0KPiArCXN0cnVjdCBkcGFhMl9ldGhfcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KG5l
dF9kZXYpOw0KPiArDQo+ICsJaWYgKHByaXYtPm1hYykNCj4gKwkJcmV0dXJuIHBoeWxpbmtfZXRo
dG9vbF9ud2F5X3Jlc2V0KHByaXYtPm1hYy0+cGh5bGluayk7DQo+ICsNCj4gKwlyZXR1cm4gLUVP
UE5PVFNVUFA7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbnQNCj4gIGRwYWEyX2V0aF9nZXRfbGlu
a19rc2V0dGluZ3Moc3RydWN0IG5ldF9kZXZpY2UgKm5ldF9kZXYsDQo+ICAJCQkgICAgIHN0cnVj
dCBldGh0b29sX2xpbmtfa3NldHRpbmdzICpsaW5rX3NldHRpbmdzKSBAQCAtDQo+IDc2MSw2ICs3
NzEsNyBAQCBzdGF0aWMgaW50IGRwYWEyX2V0aF9nZXRfdHNfaW5mbyhzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2LA0KPiANCj4gIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcyBkcGFhMl9ldGh0b29sX29w
cyA9IHsNCj4gIAkuZ2V0X2RydmluZm8gPSBkcGFhMl9ldGhfZ2V0X2RydmluZm8sDQo+ICsJLm53
YXlfcmVzZXQgPSBkcGFhMl9ldGhfbndheV9yZXNldCwNCj4gIAkuZ2V0X2xpbmsgPSBldGh0b29s
X29wX2dldF9saW5rLA0KPiAgCS5nZXRfbGlua19rc2V0dGluZ3MgPSBkcGFhMl9ldGhfZ2V0X2xp
bmtfa3NldHRpbmdzLA0KPiAgCS5zZXRfbGlua19rc2V0dGluZ3MgPSBkcGFhMl9ldGhfc2V0X2xp
bmtfa3NldHRpbmdzLA0KPiAtLQ0KPiAyLjIwLjENCg0K
