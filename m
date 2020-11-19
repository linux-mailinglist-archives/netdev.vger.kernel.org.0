Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2596F2B9394
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 14:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgKSNWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 08:22:30 -0500
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:11751
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726830AbgKSNW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 08:22:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EP8KkK3+80kktBKueBv+LOs+9TSu6SOB/d2LzsBPyzK72I3o7YNGKrvX6uuXBuJBZE0y3g6XciqzLCd4o12YxhLbrNJAcLBD0DqVhOS0iS5kSHClJ5W0OihHVQP0X5Rp2KGCXowa3BKN69yPB1J882vJjux1fYmM9XaNFJn8xksoSn5q0uJ7Y3Anqax7dEfZraZAPrg5KsHFL6FJPxnZIbz6mUxb3zrsNd7B65xapQQmuM6zzJa00817AaXh8CJQeTIeAH/YT38bhPdUcOXkccH1Th0x3Y/qn/xXdrImv1EdpAD2xdDmTREdrmRvcy3uJTJxR2I2FHsKzFtB/aUlAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anqxp0k084wWsA7imbJgTlTJ5g2Id7X4VQfR9cjP2Jk=;
 b=bzZtbeJ7t8KdvDxTRwDcXoF8Odl5izZpC2BzUCXJgEM9pBmtJu4CEhpDYvW5pny7hNJlGQ2n/9KAEog35sJE0GZrJVG7HIGjlw3JwoHQmQoXTUn8pDc8b2vtPuebEcv1v8z0r91Y5iEvJ4rSvWGGFs0CJx6y1qeoBWeUZdvTb3UJWa5+/4sDBAj4ogJsmJX3tqBN8DrLF+FlrOAftxW5vYNrG4Zxi8pTpJ3lYIJzSSiGfKo7T35fPVNOp+bhEbJOe1KMUZBXAHs1RoBOICmtz9v/KAe+mXrRd/SK62RKB1w1W6EjTXReBdLQcJIzLau+rPh4G4cY3QpkEQRs57TW9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=anqxp0k084wWsA7imbJgTlTJ5g2Id7X4VQfR9cjP2Jk=;
 b=p1wOITKtAc2Vfj6IccnLApXBzKmEupDpd2+8TbkD3717HSW24T+1WvbYBgE0FFimUQq/lG05mmbSjq/Krxag+XTt3i7RgfJfC6UQs1bvJrMNJB/jzNjNpVtgIz8UwM2F3hcEXxHY7hfrhd9Ja6p5vVUzHczks+y5z4HrB0GB1I4=
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com (2603:10a6:10:10d::31)
 by DBBPR04MB7865.eurprd04.prod.outlook.com (2603:10a6:10:1e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.21; Thu, 19 Nov
 2020 13:22:25 +0000
Received: from DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90]) by DB8PR04MB6764.eurprd04.prod.outlook.com
 ([fe80::a1ea:a638:c568:5a90%6]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 13:22:25 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [PATCH net-next resend 1/2] enetc: Fix endianness issues for
 enetc_ethtool
Thread-Topic: [PATCH net-next resend 1/2] enetc: Fix endianness issues for
 enetc_ethtool
Thread-Index: AQHWvlx+qX2Lo5UtjkeuUTYw/HBd36nPQzKAgAAtGpA=
Date:   Thu, 19 Nov 2020 13:22:25 +0000
Message-ID: <DB8PR04MB6764B3743D835FAC5298705996E00@DB8PR04MB6764.eurprd04.prod.outlook.com>
References: <20201119101215.19223-1-claudiu.manoil@nxp.com>
 <20201119101215.19223-2-claudiu.manoil@nxp.com>
 <CAOJe8K1ccPn8fJc1bfNwt2O7Z2cYmCXiUmytgp-O4RUO5GhC3Q@mail.gmail.com>
In-Reply-To: <CAOJe8K1ccPn8fJc1bfNwt2O7Z2cYmCXiUmytgp-O4RUO5GhC3Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-powerpc.org; dkim=none (message not signed)
 header.d=none;linux-powerpc.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e4e8c8fe-c1d8-4140-ed5e-08d88c8e27d5
x-ms-traffictypediagnostic: DBBPR04MB7865:
x-microsoft-antispam-prvs: <DBBPR04MB78656D251E9DC0E40373FEA196E00@DBBPR04MB7865.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2e/2YtmOLl/ihtoaNufmzKVBIVuW4bE63fydfFkUpa8esWdZUy2p4c3kQsCnwo079Wfvd0XHTblOEr0fSGCPRXyFQRmvX6LB3b3/ak+bkPobFY4B3ZaO8cAiQMqRwY3b/skN1oW44NN1YYmP67CgZ5AZsewznhJyw3Hse4sNWLaR09OvnkpHQyFhQZjTrURwAGheDcJxM26VfSC40zDgFR14PS2poFBkYtydl9zI/fLhOr94pOQ+bIzSVtY3QwwGcKpnJPgu/mQsQop7aeCVUlQrvtdh6kg4dL+ZCR6lr8SGR9nazdPbAksPQSHNCLo4rzDKWiZRCLJpdp/udojyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6764.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(52536014)(26005)(83380400001)(186003)(316002)(66446008)(44832011)(6506007)(7696005)(8676002)(5660300002)(64756008)(8936002)(478600001)(86362001)(76116006)(66556008)(9686003)(4326008)(66946007)(66476007)(33656002)(6916009)(71200400001)(2906002)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: c/H4gnRXMxm+C89I4QrNRURiSpLNvQ3ueYGf8P+vvQr4BrHT43cRxN5xkbGVpKJrWRLBXhG1TOlGILcw6kVk0K3hFuP5ug3bby13gObq2T1SFYK0kXJvhXXNbw98qgG8vzq5euRs/UUsjxWj7B/nvBj1Z6sqtCvpLY0ZZm75zVWNwteqM5c4+r0XonOPZJhulASSos8DNU9oPO7MHSIbSCHlXnwVx6EYmsqyULbnDkT9Qm4zo3alUwJIr2Kwx8WhbQ8NOXiAFOxcH0yWMIP5lgf+W1zLBOdDbkpPOOguyo4kCGfKTVgH4uUMh4VHQq5nIqDerBt38cCsOdRrtSTgZ9Ayr4Qoo+0BaLV+yj/wL6+0YMfTaTPT9NE8OqS8KIyNqMsai3YLWvuWrVe5kjN8FrJ1CYTfI3d+UEOsy11jrSG1B7ZJUtfgwDnJYjHGP2zhS2C+vqZM1PS0kFW8slPCwcBQfC8xNHJHSLzyCoYX1Yejf5m/p7/Nsti31DVShtgrcqgd4Wuxt9ItbjlyVcyJuaHKQS/09fpeCr2FftdFjwyC4DqNprwSdyIDPH7os5s19uL8Xy24FnTkaFWUEEEV94Y68T7eqpkwEfOGXyoSDDOnd0PJG7XapUJsAZuwdgd2SmNqe+J4vOPOQTZKGD9j4w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6764.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e8c8fe-c1d8-4140-ed5e-08d88c8e27d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 13:22:25.2922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Z0ay5p13y4lSjTaCTAMtwJbGApdjBYdLHqLIdW7CVXowZ+qxd7BH5EmEzrYnSDdDIPw9Iv3e7CP1AaAn9Y9eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7865
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4tLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPkZyb206IERlbmlzIEtpcmphbm92IDxr
ZGFAbGludXgtcG93ZXJwYy5vcmc+DQo+U2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE5LCAyMDIw
IDEyOjM3IFBNDQo+VG86IENsYXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0K
PkNjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwu
b3JnPjsgRGF2aWQgUyAuDQo+TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPlN1YmplY3Q6
IFJlOiBbUEFUQ0ggbmV0LW5leHQgcmVzZW5kIDEvMl0gZW5ldGM6IEZpeCBlbmRpYW5uZXNzIGlz
c3VlcyBmb3INCj5lbmV0Y19ldGh0b29sDQo+DQo+T24gMTEvMTkvMjAsIENsYXVkaXUgTWFub2ls
IDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPiB3cm90ZToNCj4+IFRoZXNlIHBhcnRpY3VsYXIgZmll
bGRzIGFyZSBzcGVjaWZpZWQgaW4gdGhlIEgvVyByZWZlcmVuY2UNCj4+IG1hbnVhbCBhcyBoYXZp
bmcgbmV0d29yayBieXRlIG9yZGVyIGZvcm1hdCwgc28gZW5mb3JjZSBiaWcNCj4+IGVuZGlhbiBh
bm5vdGF0aW9uIGZvciB0aGVtIGFuZCBjbGVhciB0aGUgcmVsYXRlZCBzcGFyc2UNCj4+IHdhcm5p
bmdzIGluIHRoZSBwcm9jZXNzLg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6IENsYXVkaXUgTWFub2ls
IDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2h3LmggfCA4ICsrKystLS0tDQo+PiAgMSBmaWxlIGNo
YW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4+DQo+PiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2h3LmgNCj4+IGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2h3LmgNCj4+IGluZGV4
IDY4ZWY0Zjk1OTk4Mi4uMDRlZmNjZDExMTYyIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjX2h3LmgNCj4+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Y19ody5oDQo+PiBAQCAtNDcyLDEwICs0NzIs
MTAgQEAgc3RydWN0IGVuZXRjX2NtZF9yZnNlIHsNCj4+ICAJdTggc21hY19tWzZdOw0KPj4gIAl1
OCBkbWFjX2hbNl07DQo+PiAgCXU4IGRtYWNfbVs2XTsNCj4+IC0JdTMyIHNpcF9oWzRdOw0KPj4g
LQl1MzIgc2lwX21bNF07DQo+PiAtCXUzMiBkaXBfaFs0XTsNCj4+IC0JdTMyIGRpcF9tWzRdOw0K
Pj4gKwlfX2JlMzIgc2lwX2hbNF07DQo+PiArCV9fYmUzMiBzaXBfbVs0XTsNCj4+ICsJX19iZTMy
IGRpcF9oWzRdOw0KPj4gKwlfX2JlMzIgZGlwX21bNF07DQo+PiAgCXUxNiBldGh0eXBlX2g7DQo+
PiAgCXUxNiBldGh0eXBlX207DQo+PiAgCXUxNiBldGh0eXBlNF9oOw0KPg0KPkhpIENsYXVkaXUs
DQo+DQo+V2h5IHRoZSBzdHJ1Y3QgaXMgZGVjbGFyZWQgd2l0aG91dCBwYWNrZWQ/DQo+SSdtIHNl
ZWluZyB0aGF0IHRoZSBzdHJ1Y3R1cmUgaXMgdXNlZCBpbiBkbWEgdHJhbnNmZXJzIGluIHRoZSBk
cml2ZXINCj4NCg0KUHJvYmFibHkgaXQgc2hvdWxkLCBmb3IgZXh0cmEgbWVhc3VyZSwgYnV0IGFz
IGl0IGlzIHJpZ2h0IG5vdyB0aGUgc3RydWN0dXJlIGlzDQpwYWNrZWQsIGFjY29yZGluZyB0byBw
YWhvbGU6DQoNCnN0cnVjdCBlbmV0Y19jbWRfcmZzZSB7DQogICAgICAgIHU4ICAgICAgICAgICAg
ICAgICAgICAgICAgIHNtYWNfaFs2XTsgICAgICAgICAgICAvKiAgICAgMCAgICAgNiAqLw0KICAg
ICAgICB1OCAgICAgICAgICAgICAgICAgICAgICAgICBzbWFjX21bNl07ICAgICAgICAgICAgLyog
ICAgIDYgICAgIDYgKi8NCiAgICAgICAgdTggICAgICAgICAgICAgICAgICAgICAgICAgZG1hY19o
WzZdOyAgICAgICAgICAgIC8qICAgIDEyICAgICA2ICovDQogICAgICAgIHU4ICAgICAgICAgICAg
ICAgICAgICAgICAgIGRtYWNfbVs2XTsgICAgICAgICAgICAvKiAgICAxOCAgICAgNiAqLw0KICAg
ICAgICBfX2JlMzIgICAgICAgICAgICAgICAgICAgICBzaXBfaFs0XTsgICAgICAgICAgICAgLyog
ICAgMjQgICAgMTYgKi8NCiAgICAgICAgX19iZTMyICAgICAgICAgICAgICAgICAgICAgc2lwX21b
NF07ICAgICAgICAgICAgIC8qICAgIDQwICAgIDE2ICovDQogICAgICAgIF9fYmUzMiAgICAgICAg
ICAgICAgICAgICAgIGRpcF9oWzRdOyAgICAgICAgICAgICAvKiAgICA1NiAgICAxNiAqLw0KICAg
ICAgICAvKiAtLS0gY2FjaGVsaW5lIDEgYm91bmRhcnkgKDY0IGJ5dGVzKSB3YXMgOCBieXRlcyBh
Z28gLS0tICovDQogICAgICAgIF9fYmUzMiAgICAgICAgICAgICAgICAgICAgIGRpcF9tWzRdOyAg
ICAgICAgICAgICAvKiAgICA3MiAgICAxNiAqLw0KICAgICAgICB1MTYgICAgICAgICAgICAgICAg
ICAgICAgICBldGh0eXBlX2g7ICAgICAgICAgICAgLyogICAgODggICAgIDIgKi8NCiAgICAgICAg
dTE2ICAgICAgICAgICAgICAgICAgICAgICAgZXRodHlwZV9tOyAgICAgICAgICAgIC8qICAgIDkw
ICAgICAyICovDQogICAgICAgIHUxNiAgICAgICAgICAgICAgICAgICAgICAgIGV0aHR5cGU0X2g7
ICAgICAgICAgICAvKiAgICA5MiAgICAgMiAqLw0KICAgICAgICB1MTYgICAgICAgICAgICAgICAg
ICAgICAgICBldGh0eXBlNF9tOyAgICAgICAgICAgLyogICAgOTQgICAgIDIgKi8NCiAgICAgICAg
dTE2ICAgICAgICAgICAgICAgICAgICAgICAgc3BvcnRfaDsgICAgICAgICAgICAgIC8qICAgIDk2
ICAgICAyICovDQogICAgICAgIHUxNiAgICAgICAgICAgICAgICAgICAgICAgIHNwb3J0X207ICAg
ICAgICAgICAgICAvKiAgICA5OCAgICAgMiAqLw0KICAgICAgICB1MTYgICAgICAgICAgICAgICAg
ICAgICAgICBkcG9ydF9oOyAgICAgICAgICAgICAgLyogICAxMDAgICAgIDIgKi8NCiAgICAgICAg
dTE2ICAgICAgICAgICAgICAgICAgICAgICAgZHBvcnRfbTsgICAgICAgICAgICAgIC8qICAgMTAy
ICAgICAyICovDQogICAgICAgIHUxNiAgICAgICAgICAgICAgICAgICAgICAgIHZsYW5faDsgICAg
ICAgICAgICAgICAvKiAgIDEwNCAgICAgMiAqLw0KICAgICAgICB1MTYgICAgICAgICAgICAgICAg
ICAgICAgICB2bGFuX207ICAgICAgICAgICAgICAgLyogICAxMDYgICAgIDIgKi8NCiAgICAgICAg
dTggICAgICAgICAgICAgICAgICAgICAgICAgcHJvdG9faDsgICAgICAgICAgICAgIC8qICAgMTA4
ICAgICAxICovDQogICAgICAgIHU4ICAgICAgICAgICAgICAgICAgICAgICAgIHByb3RvX207ICAg
ICAgICAgICAgICAvKiAgIDEwOSAgICAgMSAqLw0KICAgICAgICB1MTYgICAgICAgICAgICAgICAg
ICAgICAgICBmbGFnczsgICAgICAgICAgICAgICAgLyogICAxMTAgICAgIDIgKi8NCiAgICAgICAg
dTE2ICAgICAgICAgICAgICAgICAgICAgICAgcmVzdWx0OyAgICAgICAgICAgICAgIC8qICAgMTEy
ICAgICAyICovDQogICAgICAgIHUxNiAgICAgICAgICAgICAgICAgICAgICAgIG1vZGU7ICAgICAg
ICAgICAgICAgICAvKiAgIDExNCAgICAgMiAqLw0KDQogICAgICAgIC8qIHNpemU6IDExNiwgY2Fj
aGVsaW5lczogMiwgbWVtYmVyczogMjMgKi8NCiAgICAgICAgLyogbGFzdCBjYWNoZWxpbmU6IDUy
IGJ5dGVzICovDQp9Ow0K
