Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1415A736
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgBLK7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:59:51 -0500
Received: from mail-am6eur05on2053.outbound.protection.outlook.com ([40.107.22.53]:6134
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725821AbgBLK7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 05:59:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BrmysYrb33qeWWZ475utT9gBbaRDelm733pDP8nDEQLmFa6lP8/hhjyqAqDYiArUs17/U7SvLUmyXAIxSq/WOTp4ApGUM+/rUcAjANUSXaMM47YBTM3plBUNFwF5gtXRaTUbmsn+xZ79pcVO2lKI+Fyva9esABck+QbN2+6xwJ/PknwLD4ZRC4k8kRFhnQ7XGMf5HhBp6v2ilzewiCsUtuLzvqkggZl5qpSBAt/lHz2APSDYATNEnUp/pzqD1RIfV0LIiN7o+uDL2J0cLzmJxnvdxo1eTVzWL1C2eGDZmnnCKqPNxiq9/5/5kWb4Wi5H7ak6Ea8PYKTSFzysfiaSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HS8Fx0Wu8JL+XUwtwk2sCAOH5ffXSGz67AEb4QYShg=;
 b=RpqYpmlKlQnGgiMdM34d4d3LZK1OjjKmvYEFJSldTvNNqgdZUn/T9j31uXI2h7Xr4NnZIPAZDTsj+80J/HbxZtfxjM49+N2XJeNDp4GyT2rwj4WCzsZW21/tnjiwiKCFRbSLfVXYNIKUlukoNhiGaSkAm2qDA10cab7DsKRDHzJWz/4IL1FtwnQXSvOZy5yu1Zfbv0Jq8VN8IItEn3jHqtIIAxQfceBQ5q1rltWj68o+ew8lyvS5ForsSXFPwEWC8FqQkAmilCiGHvb+ivsY2Wn+KihDA9PYgGXx0De/f53Up7WqHJ1fcrQJbkF7/9Xn3kTHbxmhqeIIU5A+uM+ZqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HS8Fx0Wu8JL+XUwtwk2sCAOH5ffXSGz67AEb4QYShg=;
 b=KuLucmZdnBJOnjODP4GgWOHwv2aYN0ll28XHFrgbbo8i9WgUIsm1Oo5Lq8T0368kpbJIn1obi2jUEajUOZsl9YJszCjcWKkB71xHs9TBXu5M8Yz6pVb0HVxUVNH9/EqNm7xGvnOkjZl5y2i/GQQ95vb5gM03U3Naa3EK81qUgL4=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (10.141.174.88) by
 AM7PR04MB7192.eurprd04.prod.outlook.com (52.135.58.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 10:59:46 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::8a5:3800:3341:c064%7]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 10:59:46 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: RE: [PATCH] ptp_qoriq: add initialization message
Thread-Topic: [PATCH] ptp_qoriq: add initialization message
Thread-Index: AQHV4Jcxgewx58wIn0aNZKEUqjecgagWwCiAgACbX4CAAAM0AIAAAK6AgAACmoCAAACc0A==
Date:   Wed, 12 Feb 2020 10:59:45 +0000
Message-ID: <AM7PR04MB6885AE832812D5F494B7D256F81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200211045053.8088-1-yangbo.lu@nxp.com>
 <20200211.170635.1835700541257020515.davem@davemloft.net>
 <AM7PR04MB68852520F30921405A717B6CF81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <CA+h21hr+dE1owiF-e81psj3uKgCRdeS+C_LbFdd_ta91TS+CUA@mail.gmail.com>
 <AM7PR04MB688559DED451E057CBFE46E5F81B0@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <CA+h21hpfAhFFJUwhguRbgF8KK0cSYicSn6fW+ocZZgoPycvE0A@mail.gmail.com>
In-Reply-To: <CA+h21hpfAhFFJUwhguRbgF8KK0cSYicSn6fW+ocZZgoPycvE0A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [223.72.61.127]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 06742c2d-7a16-4d24-ccbf-08d7afaaabf9
x-ms-traffictypediagnostic: AM7PR04MB7192:
x-microsoft-antispam-prvs: <AM7PR04MB7192B337A26C7F0B98CA668AF81B0@AM7PR04MB7192.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(199004)(189003)(54906003)(86362001)(55016002)(316002)(2906002)(26005)(186003)(6506007)(7696005)(53546011)(478600001)(6916009)(15650500001)(66946007)(8936002)(5660300002)(66476007)(33656002)(4326008)(66446008)(66556008)(64756008)(76116006)(71200400001)(81156014)(52536014)(8676002)(81166006)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM7PR04MB7192;H:AM7PR04MB6885.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z+x5V1JbU9EHUZE4xtM6/cO3NtRoAZ6zDy9SguV10R6trPil9zy7BHaX+PQmcwXCk9R1cpEXfjT65E3c3CgDk/urGr/z62uYmVUOqtZn6loV4JOj0osGPpRcZM9ybHwdIhfrjIgNkRd0TWxbQWqsF/+Tl+MIkMLWbO7ACEGwucG9My56arAvq4hvGvGeAJIxHlJpF2Rg5Z3TmbXm+zKbRUVmtBgN/JfK7skFgiKhjzPcloAmmse6R929gR6zTvCBBBPWcGtacTOrgqagzdxCWpELovTp4che66447gL2/txgl4h9/SDbY44094ZNo+JnlGz+hXPZ+czxt3wquEGG6bkuC4kjDg1IuZXp2LwnicXcSUVOCoxXAvqmmFlcLy6NxZ2gU6m6/uuDUrA1hnvx620iMxH1vwAyI9192ekSeRr8wWCJh4UuX2WxdPJ+p/3n
x-ms-exchange-antispam-messagedata: v/9JJmmY8J+lnNo4d9722ET3Gl/lx72NwcuuJxbO27CD+jVCxKeVS3LeZDwyXfP6asSAMm6LRwz6pxOTXTQMCHgEl8E4ePmWZo7NPX9iN+Hpy23kW/qC+JXolQ2Ti+MfZrqvZ2dDGK0tfs1Mzu0zGw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06742c2d-7a16-4d24-ccbf-08d7afaaabf9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 10:59:45.9326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fC3yvKRofsLXZEdq3ptrdL/uCwx2BImaZ2rTEy6+ZzFZECW9BvyYhm60ziWBx+ihLx0sLLL9p4qa4iS8D4GUlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7192
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPG9s
dGVhbnZAZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDEyLCAyMDIwIDY6
NDYgUE0NCj4gVG86IFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPg0KPiBDYzogRGF2aWQgTWls
bGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gcmlj
aGFyZGNvY2hyYW5AZ21haWwuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHB0cF9xb3JpcTog
YWRkIGluaXRpYWxpemF0aW9uIG1lc3NhZ2UNCj4gDQo+IEhpIFlhbmdibywNCj4gDQo+IE9uIFdl
ZCwgMTIgRmViIDIwMjAgYXQgMTI6MzksIFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPiB3cm90
ZToNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IFZs
YWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+ID4gPiBTZW50OiBXZWRuZXNkYXks
IEZlYnJ1YXJ5IDEyLCAyMDIwIDY6MzQgUE0NCj4gPiA+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVA
bnhwLmNvbT4NCj4gPiA+IENjOiBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4gcmljaGFyZGNvY2hyYW5AZ21haWwuY29tDQo+
ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIXSBwdHBfcW9yaXE6IGFkZCBpbml0aWFsaXphdGlvbiBt
ZXNzYWdlDQo+ID4gPg0KPiA+ID4gSGkgWWFuZ2JvLA0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgMTIg
RmViIDIwMjAgYXQgMTI6MjUsIFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPiB3cm90ZToNCj4g
PiA+ID4NCj4gPiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiA+IEZy
b206IG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgPG5ldGRldi1vd25lckB2Z2VyLmtlcm5l
bC5vcmc+DQo+IE9uDQo+ID4gPiA+ID4gQmVoYWxmIE9mIERhdmlkIE1pbGxlcg0KPiA+ID4gPiA+
IFNlbnQ6IFdlZG5lc2RheSwgRmVicnVhcnkgMTIsIDIwMjAgOTowNyBBTQ0KPiA+ID4gPiA+IFRv
OiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiA+ID4gPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgcmljaGFyZGNvY2hyYW5AZ21haWwuY29tDQo+ID4gPiA+ID4gU3ViamVjdDog
UmU6IFtQQVRDSF0gcHRwX3FvcmlxOiBhZGQgaW5pdGlhbGl6YXRpb24gbWVzc2FnZQ0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gRnJvbTogWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiA+
ID4gPiBEYXRlOiBUdWUsIDExIEZlYiAyMDIwIDEyOjUwOjUzICswODAwDQo+ID4gPiA+ID4NCj4g
PiA+ID4gPiA+IEl0IGlzIG5lY2Vzc2FyeSB0byBwcmludCB0aGUgaW5pdGlhbGl6YXRpb24gcmVz
dWx0Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gTm8sIGl0IGlzIG5vdC4NCj4gPiA+ID4NCj4gPiA+
ID4gU29ycnksIEkgc2hvdWxkIGhhdmUgYWRkZWQgbXkgcmVhc29ucyBpbnRvIGNvbW1pdCBtZXNz
YWdlLg0KPiA+ID4gPiBJIHNlbnQgb3V0IHYyLiBEbyB5b3UgdGhpbmsgaWYgaXQgbWFrZXMgc2Vu
c2U/DQo+ID4gPiA+DQo+ID4gPiA+ICIgQ3VycmVudCBwdHBfcW9yaXEgZHJpdmVyIHByaW50cyBv
bmx5IHdhcm5pbmcgb3IgZXJyb3IgbWVzc2FnZXMuDQo+ID4gPiA+IEl0IG1heSBiZSBsb2FkZWQg
c3VjY2Vzc2Z1bGx5IHdpdGhvdXQgYW55IG1lc3NhZ2VzLg0KPiA+ID4gPiBBbHRob3VnaCB0aGlz
IGlzIGZpbmUsIGl0IHdvdWxkIGJlIGNvbnZlbmllbnQgdG8gaGF2ZSBhbiBvbmVsaW5lDQo+ID4g
PiA+IGluaXRpYWxpemF0aW9uIGxvZyBzaG93aW5nIHN1Y2Nlc3MgYW5kIFBUUCBjbG9jayBpbmRl
eC4NCj4gPiA+ID4gVGhlIGdvb2RzIGFyZSwNCj4gPiA+ID4gLSBUaGUgcHRwX3FvcmlxIGRyaXZl
ciB1c2VycyBtYXkga25vdyB3aGV0aGVyIHRoaXMgZHJpdmVyIGlzIGxvYWRlZA0KPiA+ID4gPiAg
IHN1Y2Nlc3NmdWxseSwgb3Igbm90LCBvciBub3QgbG9hZGVkIGZyb20gdGhlIGJvb3RpbmcgbG9n
Lg0KPiA+ID4gPiAtIFRoZSBwdHBfcW9yaXEgZHJpdmVyIHVzZXJzIGRvbid0IGhhdmUgdG8gaW5z
dGFsbCBhbiBldGh0b29sIHRvDQo+ID4gPiA+ICAgY2hlY2sgdGhlIFBUUCBjbG9jayBpbmRleCBm
b3IgdXNpbmcuIE9yIGRvbid0IGhhdmUgdG8gY2hlY2sgd2hpY2gNCj4gPiA+ID4gICAvc3lzL2Ns
YXNzL3B0cC9wdHBYIGlzIFBUUCBRb3JJUSBjbG9jay4iDQo+ID4gPiA+DQo+ID4gPiA+IFRoYW5r
cy4NCj4gPiA+DQo+ID4gPiBIb3cgYWJvdXQgdGhpcyBtZXNzYWdlIHdoaWNoIGlzIGFscmVhZHkg
dGhlcmU/DQo+ID4gPiBbICAgIDIuNjAzMTYzXSBwcHMgcHBzMDogbmV3IFBQUyBzb3VyY2UgcHRw
MA0KPiA+DQo+ID4gVGhpcyBtZXNzYWdlIGlzIGZyb20gcHBzIHN1YnN5c3RlbS4gV2UgZG9uJ3Qg
a25vdyB3aGF0IFBUUCBjbG9jayBpcw0KPiByZWdpc3RlcmVkIGFzIHB0cDAuDQo+ID4gQW5kIGlm
IHRoZSBQVFAgY2xvY2sgZG9lc24ndCBzdXBwb3J0IHBwcyBjYXBhYmlsaXR5LCBldmVuIHRoaXMg
bG9nIHdvbid0IGJlDQo+IHNob3dlZC4NCj4gPg0KPiA+IFRoYW5rcy4NCj4gPg0KPiA+ID4NCj4g
PiA+IFRoYW5rcywNCj4gPiA+IC1WbGFkaW1pcg0KPiANCj4gWWVzIGJ1dCB0aGlzIGlzIHB0cF9x
b3JpcSwgd2hpY2ggc3BlY2lmaWNhbGx5IF9kb2VzXyBzdXBwb3J0IFBQUywgc28NCj4gdGhlIG1l
c3NhZ2Ugd2lsbCBiZSBwcmludGVkLiBBbSBJIG1pc3Npbmcgc29tZXRoaW5nPw0KDQpUaGUgcHRw
X3FvcmlxIGRyaXZlciBpcyBhIGNvbW1vbiBkcml2ZXIuIEl0IGNvdWxkIGJlIHJldXNlZCBmb3Ig
YW55IEV0aGVybmV0IGNvbnRyb2xsZXIncyB3aXRoIHN1Y2ggUFRQIHRpbWVyLCBzdWNoIGFzIGVu
ZXRjX3B0cC5jLCBkcGFhMl9wdHAuYy4NCkl0IGhhcyBwb3NzaWJpbGl0eSB0aGF0IHRoZXkgaGFk
IGRpZmZlcmVudCBjYXBhYmlsaXRpZXMuIEFuZCB0aGVyZSBtYXkgYmUgc3VjaCBjYXNlIHRoYXQg
YSBuZXcgZHJpdmVyIHJldXNlZCBwdHBfcW9yaXEgbWF5IHdhbnQgdG8gc3VwcG9ydCBwYXJ0IGZl
YXR1cmVzIG5vdCBpbmNsdWRpbmcgcHBzIGZpcnN0Lg0KDQpTbyB0aGlzIG1lc3NhZ2UgeW91IG1l
bnRpb25lZCBjb3VsZG7igJl0IGJyaW5nIHRoZSB0d28gZ29vZHMgSSBkZXNjcmliZWQuDQpUaGFu
a3MuDQoNCj4gDQo+IFJlZ2FyZHMsDQo+IC1WbGFkaW1pcg0K
