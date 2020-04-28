Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5021C1BC4E1
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 18:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgD1QQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 12:16:14 -0400
Received: from mail-eopbgr70115.outbound.protection.outlook.com ([40.107.7.115]:16449
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728340AbgD1QQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 12:16:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BJMR4F0UxAOs3jqSx8ocDEQyePQyRDM8jgUbvxmLpE2VAK6/uo027vpgt3UcOuaIZKGvgOyyusDs6cojsz3BvqGSH/jf4XkkQ9BBH/IMfOqNHDPSMQliv1tvVQxPfTrYYa67j9C0osq5J57baK/J82DQrHl5ZookHehO/gF4jVheCw47uFeWMSAwdcluZ0MVoVkHaLzfXI8HeM3o/bBSvR11t0YDJK1gTjRy/Xcze6xAUJh2dtoFMR6qrETqXD2XoQd8iL5Ju+D6CdQR9cs6XzcqHIF2PYr28z7b35D3o1jZuQpawEZCxPXN0Gd5uo1GVJCU7UZGL+fHWCBcSeztVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfEjYsL6xqCOVjg+IF/PpJUXCXaYgFGp27AjRaBeVxs=;
 b=Wxmkdmm1WuQ4YzbOy8mcV6QxG0jz8QQcVzkQvsEyUwO6zXNZmnukVw1b/5xSgRzH5ejJ0TUipmAj7iD9GUbhFMJV8/cILdxSOjUou1AY3QWUUhxtePjTsENmxVCcoaGNMVSEriAa6DsXhW8euIuoVvLbaYe8SfiSYWcVvFkAV3zOyeQCR+VZQwLY0ngto0uWlu3meXzKFBXMb2DYV+ofZwbUuTTKFivmMR5GQDlH9LI7jZi5Dyg83XNykrngQU09wHwO3ZvYSDosyjuaopZzTNEuFIvsRXLgaOIDFg82oyuJ7VOL+p+qva7FU8nXst1EW0KKRy9v2x2GnPi22Kf8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfEjYsL6xqCOVjg+IF/PpJUXCXaYgFGp27AjRaBeVxs=;
 b=TyrxwbS61AQmrKc3lQqkOKC99uAzi8qWddi0RdGnRiewLGuY7GfY62Ym4sVyqlf57teYn5hWYAj2aywY8/CT4Ox5jB8BhtOzKHbwXg4hlIXD3wrhhrtnBK5SxJZZXEPdXkdDbewYCwLsX0uoR7AykPdF6/kH/n7FptIECTfsttA=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (2603:10a6:20b:a8::25)
 by AM6PR05MB4855.eurprd05.prod.outlook.com (2603:10a6:20b:12::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 16:16:07 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::d8d3:ead7:9f42:4289%6]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 16:16:07 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>
CC:     "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Topic: [PATCH net-next v3] net: phy: micrel: add phy-mode support for
 the KSZ9031 PHY
Thread-Index: AQHWGHaxUA6NfMbeRU2VdAoOfe//rKiOsmkAgAAFQQCAAAgNgA==
Date:   Tue, 28 Apr 2020 16:16:07 +0000
Message-ID: <6791722391359fce92b39e3a21eef89495ccf156.camel@toradex.com>
References: <20200422072137.8517-1-o.rempel@pengutronix.de>
         <CAMuHMdU1ZmSm_tjtWxoFNako2fzmranGVz5qqD2YRNEFRjX0Sw@mail.gmail.com>
         <20200428154718.GA24923@lunn.ch>
In-Reply-To: <20200428154718.GA24923@lunn.ch>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=toradex.com;
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a037bc43-cc73-4c15-94c2-08d7eb8f756c
x-ms-traffictypediagnostic: AM6PR05MB4855:
x-microsoft-antispam-prvs: <AM6PR05MB48558A9A646375FE6265D611F4AC0@AM6PR05MB4855.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(366004)(376002)(39850400004)(26005)(76116006)(5660300002)(66446008)(64756008)(4326008)(66556008)(186003)(66946007)(66476007)(478600001)(7416002)(91956017)(8936002)(44832011)(110136005)(71200400001)(6486002)(6512007)(2906002)(54906003)(2616005)(6506007)(36756003)(316002)(86362001)(8676002)(81156014);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ea2IRg+MBM5h46PLkosEfcO/X3dcaCUOnXLitqSH95nfhj/21laNcN9XNT59e0d7ne2d08RFGo2E5UsDTxZbzZbkTdZWTY5DRB2JZokkTcC5jxhXc6+ksKnsw44msFZ3DYWQYKxaNfJWF4qGZpqJE4SPrNCNy3hUj4mXimeyRoN1awv9epVm6WwSvudbOFw781/tCZ7+Sr3vCfdgtZQIA6FayQfjhZ5CnXSzYzeLVwDl7SgDXZZ4O0MnIXO/8HbKyEXCeyNVG6Cjh7xizAQteIwopcecMFq00MeZcRr6ghfc7pujci9ADlf2GgI2rlj+jahm//fFZuWU8K2SW9RqwkDmGVhRNBfHaDPdKvoZtaaT4NuZXFjieR5O+JxjvBwOyF7F5nnk5CKu0Ujti3vVuwZ9nBP8Ll9FhKMlxeuVR3kw2thpxdUqtFT8FdjSTLWx
x-ms-exchange-antispam-messagedata: o0KsPMLudjernFMi0gIiSTggLZ6PoK2pIK4MBg7lHow3/0hMdSSQgM6Jynf2ZGm0NsfI5gOKqOOzS0a6R6O9x9FjeNR0c4wbv4Kypy2yCiVjeMLjg38LByiHM1njkoXhn6q1R9iyEcLwQwfWtrfmRQdeyhrq56bXjE0V5f51KkTO3MOckgBVQL16QL1eN5bdMANZmNjltZlEh5VlWlXP7qqx3ehsFm9ojocGq403at5iN2mmyMEhmoX3t4jBg6hfxfXzxY4+iC4l+fgkE2s4JvYADT+shjRcnJW6HN4JRyF9byr/vc5d1HNldThUWkCek9ss92r99Tv9zUAXeaPcmLz+qlV0+FceUnmLXgBtehgSTH+b5Tt5N5HvbAH1YtHJNngL9LVJHM1uFgc/DAxFVQEkSbo0uxXjxMEdlrncWKC7epg3r1DghuaMYV2K7TQFmlQF2aP2/IKEwFsTibg/JxtNSQTy2io0C/JnniC0rsh3EDGXBot+bjFZrhbZyIgLKBfPuQ7EeiFLu7t2U8kM4yWSoowtHLrdPiqrO9Bdz7PGmtZrjIKKf2kSNm5o76vHf82tgeOyenNSSwPd5z7zNJg06x7U54ZtSyE2onWZ4eeG7+vhoxLdbc045w9pr2k6yL+ddalpiOsJSuA51T8OqRKgUSWOeg8mNniIUzIGG5MaNzWybctcIA+BWPZrv6HeV7Kn0wSiephoQdppPM7v5Gd6o76Q3S+yqM81sDSVMs/vvA5oV4rH9Pro32wqrJkhtgxgqAcFHzmnOibwqdiSS+bHJeaXgNrKuU58xGnAVhc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <57324B0CA3CACA408175F6F1C82A247F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a037bc43-cc73-4c15-94c2-08d7eb8f756c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 16:16:07.7996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rPIBhpn0QzjfUTTRdhpujR4NWxr3JXJsL79jcoLg9FdLxQsQIQsv+SUmreYNgCbZntMd0bD9SBNtN5ubD4PeWit+N18W0odGnXxtcLlU0b8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4855
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTI4IGF0IDE3OjQ3ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gVHVlLCBBcHIgMjgsIDIwMjAgYXQgMDU6Mjg6MzBQTSArMDIwMCwgR2VlcnQgVXl0dGVyaG9l
dmVuIHdyb3RlOg0KPiA+IFRoaXMgdHJpZ2dlcnMgb24gUmVuZXNhcyBTYWx2YXRvci1YKFMpOg0K
PiA+IA0KPiA+ICAgICBNaWNyZWwgS1NaOTAzMSBHaWdhYml0IFBIWSBlNjgwMDAwMC5ldGhlcm5l
dC1mZmZmZmZmZjowMDoNCj4gPiAqLXNrZXctcHMgdmFsdWVzIHNob3VsZCBiZSB1c2VkIG9ubHkg
d2l0aCBwaHktbW9kZSA9ICJyZ21paSINCj4gPiANCj4gPiB3aGljaCB1c2VzOg0KPiA+IA0KPiA+
ICAgICAgICAgcGh5LW1vZGUgPSAicmdtaWktdHhpZCI7DQo+ID4gDQo+ID4gYW5kOg0KPiA+IA0K
PiA+ICAgICAgICAgcnhjLXNrZXctcHMgPSA8MTUwMD47DQo+ID4gDQo+ID4gSWYgSSB1bmRlcnN0
YW5kIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZXRoZXJuZXQtDQo+ID4g
Y29udHJvbGxlci55YW1sDQo+ID4gY29ycmVjdGx5Og0KPiANCj4gSGkgR2VlcnQNCj4gDQo+IENo
ZWNraW5nIGZvciBza2V3cyB3aGljaCBtaWdodCBjb250cmFkaWN0IHRoZSBQSFktbW9kZSBpcyBu
ZXcuIEkgdGhpbmsNCj4gdGhpcyBpcyB0aGUgZmlyc3QgUEhZIGRyaXZlciB0byBkbyBpdC4gU28g
aSdtIG5vdCB0b28gc3VycHJpc2VkIGl0IGhhcw0KPiB0cmlnZ2VyZWQgYSB3YXJuaW5nLCBvciB0
aGVyZSBpcyBjb250cmFkaWN0b3J5IGRvY3VtZW50YXRpb24uDQo+IA0KPiBZb3VyIHVzZSBjYXNl
cyBpcyByZWFzb25hYmxlLiBIYXZlIHRoZSBub3JtYWwgdHJhbnNtaXQgZGVsYXksIGFuZCBhDQo+
IGJpdCBzaG9ydGVkIHJlY2VpdmUgZGVsYXkuIFNvIHdlIHNob3VsZCBhbGxvdyBpdC4gSXQganVz
dCBtYWtlcyB0aGUNCj4gdmFsaWRhdGlvbiBjb2RlIG1vcmUgY29tcGxleCA6LSgNCj4gDQo+IAkg
ICBBbmRyZXcNCg0KSGVsbG8gR2VlcnQgYW5kIEFuZHJldw0KDQpJIHJldmlld2VkIE9sZWtzaWon
cyBwYXRjaCB0aGF0IGludHJvZHVjZWQgdGhpcyB3YXJuaW5nLiBJIGp1c3Qgd2FudCB0bw0KZXhw
bGFpbiBvdXIgdGhpbmtpbmcgd2h5IHRoaXMgaXMgYSBnb29kIHRoaW5nLCBidXQgeWVzIG1heWJl
IHdlIGNoYW5nZQ0KdGhhdCB3YXJuaW5nIGEgbGl0dGxlIGJpdCB1bnRpbCBpdCBsYW5kcyBpbiBt
YWlubGluZS4NCg0KVGhlIEtTWjkwMzEgZHJpdmVyIGRpZG4ndCBzdXBwb3J0IGZvciBwcm9wZXIg
cGh5LW1vZGVzIHVudGlsIG5vdyBhcyBpdA0KZG9uJ3QgaGF2ZSBkZWRpY2F0ZWQgcmVnaXN0ZXJz
IHRvIGNvbnRyb2wgdHggYW5kIHJ4IGRlbGF5cy4gV2l0aA0KT2xla3NpaidzIHBhdGNoIHRoaXMg
ZGVsYXkgaXMgbm93IGRvbmUgYWNjb3JkaW5nbHkgaW4gc2tldyByZWdpc3RlcnMgYXMNCmJlc3Qg
YXMgcG9zc2libGUuIElmIHlvdSBub3cgYWxzbyBzZXQgdGhlIHJ4Yy1za2V3LXBzIHJlZ2lzdGVy
cyB0aG9zZQ0KdmFsdWVzIHlvdSBwcmV2aW91c2x5IHNldCB3aXRoIHJnbWlpLXR4aWQgb3Igcnhp
ZCBnZXQgb3ZlcndyaXR0ZW4uDQoNCldlIGNob3NlIHRoZSB3YXJuaW5nIHRvIG9jY3VyIG9uIHBo
eS1tb2RlcyAncmdtaWktaWQnLCAncmdtaWktcnhpZCcgYW5kDQoncmdtaWktdHhpZCcgYXMgb24g
dGhvc2UsIHdpdGggdGhlICdyeGMtc2tldy1wcycgdmFsdWUgcHJlc2VudCwNCm92ZXJ3cml0aW5n
IHNrZXcgdmFsdWVzIGNvdWxkIG9jY3VyIGFuZCB5b3UgZW5kIHVwIHdpdGggdmFsdWVzIHlvdSBk
bw0Kbm90IHdhbnRlZC4gV2UgdGhvdWdodCwgdGhhdCBtb3N0IG9mIHRoZSBib2FyZHMgaGF2ZSBq
dXN0ICdyZ21paScgc2V0IGluDQpwaHktbW9kZSB3aXRoIHNwZWNpZmljIHNrZXctdmFsdWVzIHBy
ZXNlbnQuDQoNCkBHZWVydCBpZiB5b3UgYWN0dWFsbHkgd2FudCB0aGUgUEhZIHRvIGFwcGx5IFJY
QyBhbmQgVFhDIGRlbGF5cyBqdXN0DQppbnNlcnQgJ3JnbWlpLWlkJyBpbiB5b3VyIERUIGFuZCBy
ZW1vdmUgdGhvc2UgKi1za2V3LXBzIHZhbHVlcy4gSWYgeW91DQpuZWVkIGN1c3RvbSB0aW1pbmcg
ZHVlIHRvIFBDQiByb3V0aW5nIGl0IHdhcyB0aG91Z2h0IG91dCB0byB1c2UgdGhlIHBoeS0NCm1v
ZGUgJ3JnbWlpJyBhbmQgZG8gdGhlIHdob2xlIHJlcXVpcmVkIHRpbWluZyB3aXRoIHRoZSAqLXNr
ZXctcHMgdmFsdWVzLg0KDQpAQW5kcmV3IFRoaXMgd2FybmluZyBtaWdodCBiZSBub3QgdGhlIGJl
c3Qgc29sdXRpb24gYnV0IHdlIHNob3VsZA0KZGVmaW5pdGVseSB3YXJuIHRoYXQgdmFsdWVzIG1p
Z2h0IGdldCBvdmVyd3JpdHRlbiBmcm9tIHdoYXQgd2FzIGludGVuZGVkDQp3aXRoIGUuZy4gJ3Jn
bWlpLXR4aWQnLiBUaGUgb3V0LW9mLXJlc2V0IGJlaGF2aW91ciBvZiB0aGUgUEhZIGFjdHVhbGx5
DQppcyAncmdtaWktdHhpZCcgc28gd2UgbWF5IGFsc28gdGhyb3cgbm93IHdhcm5pbmcgaWYgdGhp
cyBtb2RlIGlzIHNldC4NCldoYXQgaXMgeW91ciBvcHBpbmlvbj8NCg0KUmVnYXJkcywNClBoaWxp
cHBlDQo=
