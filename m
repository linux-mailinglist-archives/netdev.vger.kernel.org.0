Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41B7D14ABDA
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 22:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgA0V40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 16:56:26 -0500
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:57314
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgA0V40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 16:56:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SEUhROTpC3K0MEYpcDM9T2c0DPbngnDpA+Pe6PUVFxYc92dkdAbYK08qHgUYL5WSwzxYLMV75dAWVpLunaFCTTccHpE6t5ji/QsB0e4bUDUSMajROniXKGGub8A0qCrlX4uHDYJ+0oRqNiH5dTC2oa7newdLQm/TrTneEaTY5UU+iMt29Gxa6A0l1b08MCxZDC6GywS5fwF7DDTJz+JK0LcCSa4lNG5ug9cU47yF4H/Mvx14E6Kowyzv+BLYW8Axmcicu0nBDPdWo5jaTFb8IkpuOxQRivIs5AlBa7nZmsTT0EviXPyc5p/FyVv8bum8M3WvRL/WkDM5eOdgcb+R1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sAcOnsa/Bt/EteLxuSeg1RaiDdZIY0pOIoSmCHlkIY=;
 b=KI0wzs3y8pCuLq4UXBqPHdqh65a5EcMd6zZkh7WZAC3t948LAECFEolmYa5oujNoyESMEL0ri5EMMJIGVbEScH+iJnDsoUIIc7AGZBzt0n/Fri9pZV7S+TIWkECRHXLEUGxIMaIz0B4NFaY/T3ALD8UBk+HWXjUHQMkUYyqRMCTEXuV7gtQIWCT1toSH/aR7UVd9IiWjB0nU3BGiUMYHg4BTLkckB7c2Iw0eHJcocD3//12QAMxeihPcio7S9b7v8CYpuprIXHgnLogeEe/ehYz5UdGZxwjgiuhRff2CcoAK9UlyNQG+fM5kHB3KeUQbhHD5Y/nmfuRy1/ayPJvCXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2sAcOnsa/Bt/EteLxuSeg1RaiDdZIY0pOIoSmCHlkIY=;
 b=t2t1qYRUG7TiOcvP6St03wAB4orBPuIWRPhFP4A0qbMth0h3ylNhRrJJiNnTsr+sCLWjn8risnMhQdoFg1FhQhi+R6ic/ahZRTk/ixb74N5OEOyCzkZW4NDX3RpXHlFVd88bYwIm4tP2RA1ARMiFFYnMp5hru7fy9E8EEpmS5NY=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5412.eurprd05.prod.outlook.com (20.177.118.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Mon, 27 Jan 2020 21:56:23 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::d9f3:f3b8:86b2:a40a%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 21:56:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     Aya Levin <ayal@mellanox.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Topic: [net-next V2 11/14] ethtool: Add support for low latency RS FEC
Thread-Index: AQHV0z30mWH9Qamk9kSgrdqkMYV+GKf7yCaAgAAXzwCAAzLGAA==
Date:   Mon, 27 Jan 2020 21:56:22 +0000
Message-ID: <fedd89528dfa9a3716b07731e4439d6b1ffe6329.camel@mellanox.com>
References: <20200125051039.59165-1-saeedm@mellanox.com>
         <20200125051039.59165-12-saeedm@mellanox.com>
         <20200125114037.203e63ca@cakuba> <20200125210550.GH18311@lunn.ch>
In-Reply-To: <20200125210550.GH18311@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9a60a23f-1ec0-46ab-a46b-08d7a373bfc3
x-ms-traffictypediagnostic: AM6PR05MB5412:|AM6PR05MB5412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5412722EA2B8F5D47426A44EBE0B0@AM6PR05MB5412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(366004)(346002)(396003)(199004)(189003)(86362001)(316002)(2906002)(110136005)(4326008)(54906003)(478600001)(6512007)(71200400001)(6506007)(4744005)(6486002)(5660300002)(66476007)(91956017)(76116006)(186003)(8936002)(81166006)(36756003)(26005)(8676002)(81156014)(64756008)(66446008)(2616005)(66556008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5412;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dheATxFlVfr71bOOVXf+v9cPI9hw65Xo6+HuPZ+1IjZIrG1KLuhTvn9yiYrxqIHYmP3nk5oRiWVBBaCLsb9V45X/vGDjEfquGMiw5NQuzj1bOKgi3apiVaD2UWTZx4ccJg9T0mqLPt8IXvKehFABj2+w4p2iRJTMq21mOgiSg+mXgMmVS5thbYLuFoDKkoXsSmd2bCwA+5XypKo6Fk9hiRC7rOKADvMLgtugHN0dHN8yLDpVLvMcM3f8od7KHAw8i/7smeQopFTOCT4IBZ0SIvNVjZG84Kx8l4B074tSDX4cdamnA3ycTjFvAIWEJCfZzIdPu+MNc0oqXydcks1KyQ9wd9H3TnuAkqKi9DmS2cN3dNO8FWIc1WgrlEEZ8GQCVEIVsX+gv80POmY3nG8+D76sk633eHbIIbPuE/8wmJPZ5IxkwbnCWSQNjJVSKkJZ
x-ms-exchange-antispam-messagedata: 6wKNTVf6vJDEHb1tIC58P2wzrcUWymMNSO0r5eiAs6keNpANEXJbB3S8LoOnGvSinhGavQENh0BzWvW/YIG6NWuoaUfrVSlfnoQ4efc6FTpYXqOjFTxZiLtRzTbBTTFHLHlea8CIvYkPBbUA8C704w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7E7775DC498DF459C329AACA10E77AD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a60a23f-1ec0-46ab-a46b-08d7a373bfc3
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 21:56:22.8291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QoACVNLWVMLIaaV3ooZ+PsbYxj9tdkIi1EzgYTYBIYuOXRB9dnFahquPj2ezVLXpo+I2jrwWiICzzOVL+LvYQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTAxLTI1IGF0IDIyOjA1ICswMTAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gU2F0LCBKYW4gMjUsIDIwMjAgYXQgMTE6NDA6MzdBTSAtMDgwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+ID4gT24gU2F0LCAyNSBKYW4gMjAyMCAwNToxMTo1MiArMDAwMCwgU2FlZWQgTWFo
YW1lZWQgd3JvdGU6DQo+ID4gPiBGcm9tOiBBeWEgTGV2aW4gPGF5YWxAbWVsbGFub3guY29tPg0K
PiA+ID4gDQo+ID4gPiBBZGQgc3VwcG9ydCBmb3IgbG93IGxhdGVuY3kgUmVlZCBTb2xvbW9uIEZF
QyBhcyBMTFJTLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBBeWEgTGV2aW4gPGF5YWxA
bWVsbGFub3guY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJl
QG1lbGxhbm94LmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVl
ZG1AbWVsbGFub3guY29tPg0KPiA+IA0KPiA+IFRoaXMgaXMga2luZCBvZiBidXJpZWQgaW4gdGhl
IG1pZHN0IG9mIHRoZSBkcml2ZXIgcGF0Y2hlcy4NCj4gPiBJdCdkIHByZWZlcmFibHkgYmUgYSBz
bWFsbCBzZXJpZXMgb2YgaXRzIG93bi4gDQo+ID4gTGV0J3MgYXQgbGVhc3QgdHJ5IHRvIENDIFBI
WSBmb2xrIG5vdy4NCj4gDQo+IFRoYW5rcyBKYWt1dg0KPiANCg0KSSBhY3R1YWxseSBDQ2VkIFBI
WSBvbiBWMSAuLiBidXQgZm9yZ290IG9uIFYyIDooLg0KDQpBbnl3YXkgdGhlIEJJVCBpcyB2ZXJ5
IGNsZWFyIGFuZCBzdGFuZGFyZCBhcyBBeWEgcG9pbnRlZCBvdXQuLiANCg0KU2hhbGwgSSByZXN1
Ym1pdCB3aXRoIHRoZSB1cGRhdGUgY29tbWl0IG1lc3NhZ2UgPw0KDQpJIHNlZSB0aGUgc2VyaWVz
IGlzIG1hcmtlZCBhcyAiTm90IEFwcGxpY2FibGUiIGkgZG9uJ3Qga25vdyB3aHkgdGhvdWdoDQou
LiANCg0KPiA+IElzIHRoaXMgZnJvbSBzb21lIHN0YW5kYXJkPw0KPiANCj4gQSByZWZlcmVuY2Ug
d291bGQgYmUgZ29vZC4NCj4gDQo+IEkgYXNzdW1lIHRoZSBleGlzdGluZyBFVEhUT09MX0xJTktf
TU9ERV9GRUNfUlNfQklUIGlzIGZvciBDbGF1c2UgOTEuDQo+IFdoYXQgY2xhdXNlIGRvZXMgdGhp
cyBMTFJTIHJlZmVyIHRvPw0KPiANCj4gVGhhbmtzDQo+IAlBbmRyZXcNCg==
