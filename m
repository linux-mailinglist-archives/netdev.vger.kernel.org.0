Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C5446D75A
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 16:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbhLHPwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 10:52:54 -0500
Received: from mail-am6eur05on2135.outbound.protection.outlook.com ([40.107.22.135]:43936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233893AbhLHPwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 10:52:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ktj2Q0RiHH1wKsBHRKQpl3LD4Sd1phVD4CdtYcKf4rJy7Hyy+ExLFWfF6tweAS4tOjzr/Q/82J8MKw7GhJ7+ykuKrNUKP/d2aAKYDXgIptRiUIdRm+kAiaNaBMyfbjdXANerLD3mOgTrajqRmz1VVzNhi87UgYRVO2rjwKaYmPV1In3CAS1pFrlhqBtGFykXw0AprvPWEdDRCgkZWi6Ooc6zmlni/vZWMAri4A2EyvZGQEdy330TL/98R1viPDe2Cr0hMtnnSzUf6QeegLVx4Ux+LbSOtCE400g2oxTGUEx0uEUjd8R3oSNwvkKtjlQgEYn/gfyZkedxeRrxqAeBLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZDQxfg15tuAtUrQKydSH19muoCv0sA3Wdrpxoex/UM=;
 b=kmph3Oc/ylVcRZ2Cp7X7C39/dGnRVQicb6NTsHi8JSqutnQqQs1uJLYN5XV1bZbXoKfK8xJqcYXq7ayhvOIWA1U48C2Glz9tcGZ0KWTTPQ6WZIThKJ29BVwDgKwDd87aVdfTOh8C5gOaHopezRgPJBkXDM1xYg9j/14y/UkELTTjUyNa4sQ6bYGcCLpao/irHlH+Spt9wjLeS3SHM9PuisHv+Y3yvP5OY0cyjCZ+/5Hb5gO15HHQx/bZa+8OoME+zFvQBy49bXqobOJIML45fB0Uz56mxKkKsti2tPYiAg9gMaS6SCy/BKf/i4X0VfB7CSINuWEJw21IySfzqoW4Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hitachienergy.com; dmarc=pass action=none
 header.from=hitachienergy.com; dkim=pass header.d=hitachienergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hitachienergy.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZDQxfg15tuAtUrQKydSH19muoCv0sA3Wdrpxoex/UM=;
 b=2ouV5CdR2E1NLAjIbvkEX52GG2EiSm6vNdIuE+M2P2nFmtzEh0dLsS0uaRq8yVKCPebZn1WCSt+Xx4BtOa0Lnjt1sENMGZV1adPt/X77Zf9pZl3ml1KKm+mPXoKZ43XJ+PTIXgOmONnVtb0gr7WQu/LQ0rTlIJMWQ8txfgtyVG/7VGMbmzrFUvs5FnMCEmyCna3kgxmCCkH7lYJ5JqQnqjo6yNBSZzU6f9VVwXmbeJxdhuREtfCRWawvVWOuPZH/xq4jg3ujM0dhuqAgQAybt1zcHvnfz/co+9K6lNbVMt5OJIG92OyJFDv7SG63gZkTunfljoiB6LamJuFXue60xw==
Received: from AM6PR0602MB3671.eurprd06.prod.outlook.com
 (2603:10a6:209:20::29) by AM6PR06MB6166.eurprd06.prod.outlook.com
 (2603:10a6:20b:da::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 8 Dec
 2021 15:49:19 +0000
Received: from AM6PR0602MB3671.eurprd06.prod.outlook.com
 ([fe80::605f:9ed6:73fb:235a]) by AM6PR0602MB3671.eurprd06.prod.outlook.com
 ([fe80::605f:9ed6:73fb:235a%7]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 15:49:19 +0000
From:   Holger Brunck <holger.brunck@hitachienergy.com>
To:     =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output amplitude
 configurable
Thread-Topic: [v3 2/2] dsa: mv88e6xxx: make serdes SGMII/Fiber output
 amplitude configurable
Thread-Index: AQHX6525E9BoIskIRkqx58mIW7K4x6wnabuAgAEYVdCAADdQAIAAAK4w
Date:   Wed, 8 Dec 2021 15:49:19 +0000
Message-ID: <AM6PR0602MB36717361A85C1B0CA8FE94D0F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
References: <20211207190730.3076-1-holger.brunck@hitachienergy.com>
        <20211207190730.3076-2-holger.brunck@hitachienergy.com>
        <20211207202733.56a0cf15@thinkpad>
        <AM6PR0602MB3671CC1FE1D6685FE2A503A6F76F9@AM6PR0602MB3671.eurprd06.prod.outlook.com>
 <20211208162852.4d7361af@thinkpad>
In-Reply-To: <20211208162852.4d7361af@thinkpad>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-processedbytemplafy: true
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hitachienergy.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8589aefb-034f-4601-3559-08d9ba624c16
x-ms-traffictypediagnostic: AM6PR06MB6166:EE_
x-microsoft-antispam-prvs: <AM6PR06MB6166E5E620A8931D385DC5D9F76F9@AM6PR06MB6166.eurprd06.prod.outlook.com>
x-he-o365-outbound: HEO365Out
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I+7uXnREjT0F2LGBnYymzurcAx6EdzH5p3UCGnaYXkjoysDkC+hFsD1RmMVXTcZns/rBKdwpRkhclXbOQ9IGUYpNdk0i4FHQdLxsFtWxKDoKWIHDEFl25ymyxWiNyH6epNbAq+y9cTZxYCVI+e5EEhX8QsBXMcJGz3VCHe6Pg7b0EUY6ROdBGZs5140S0GPJAQYSQFw7vpgBMNjG9OExavcBWsUZgPXj4vv5tRXt59eGTWQV7LLaoN7yXhR+JHQLNBkE8TgPjkEXWMas9ouWICDxnyOmQWIjc7HUxu3LVziR8oCeh1yBa2eM0TecdRMToZPv9jhKrnmWlGcV9d+rauZktadah5FpUcE5nFtD/2o9PeTr3jBxoDrvw3m3J97fPR2qWVjfCyUpEmEY5eTsjFuwDewNEdsX3TunP9Ffh1uD9V19XHR71SSML6SeKCZFfbNMk6lhD81oFGW+Bgwg4dlTS/Yw1rLJjzuYF5V9AhgO7ZMTTspv66ntCK3Qog/EfCPSPrGUO60tU3Eg3pXDdsFVMf2VGzXqpWiLyE9HCb0xVt2LtUnSiB9l2iF/mQPp8rPSkQG0WyMjbfW930/VNYqC0Zew2SCATB3gG2oGA5AtY7HdDXsZaRrk4OH84OUK/YlM4TXP/28bRwtvP6pRw+fphjrPx5lxiuQNtPAbTgqOHM5ofSipZnajNTa0vVE90JDOVrzuqKrX1vdPliNhRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0602MB3671.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(44832011)(6916009)(66446008)(66946007)(66476007)(7696005)(55016003)(9686003)(33656002)(54906003)(38070700005)(76116006)(66556008)(64756008)(316002)(122000001)(186003)(82960400001)(2906002)(8936002)(4326008)(86362001)(6506007)(38100700002)(52536014)(71200400001)(508600001)(26005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFQ3Y0J1akZQWld4alhXYXdrOC9rcDEzSkhVeU4xSTBlN3dKSllzOG5vaTZI?=
 =?utf-8?B?WWhqWi9UVWFpcUJhUk9CUVZIWkpOY0lXVU5NVUYxcFNCdVoxeU91d08yQU5N?=
 =?utf-8?B?eWhYQnpVQy9EZnpKQ0xYVkROUGtKYW1RcVIwOWlzVFpjSFo0bGJhV0h4L3Vm?=
 =?utf-8?B?T1R3QTBwd3VjQW5NOU5hNnI0aWYzcDc4TGZLMTBZTm40dFJDOVZDUitFTVZp?=
 =?utf-8?B?ZWRZaHpsWEFaTVhJbDBQMWFrS0VSVk9YWEJINHd1cHl4ZnlNYlJPMEt4Yllh?=
 =?utf-8?B?OC9GM0ZJSHdNNHZLRHVmVnI4UmgranZ0UytTcU4yK2UxcmVVV2V0WWlaenR6?=
 =?utf-8?B?NS85aTcrK1QycHd3SFZwZTU3NGRFU0VCL09LbzI3NkFUeVY0Zkt3UGFiOTBO?=
 =?utf-8?B?dkRKWVdxMGdJQkFhdFpZQktpS2ZqVUVCcW1tdTJuTmNIVTZHTklFKzFROEk4?=
 =?utf-8?B?Q3lhUEFEUFZ4RW84VE5xNHViOUFsT0phNW9iVTRIanRkMWdkeVBwcmY2bEQx?=
 =?utf-8?B?RGtQWXFJVVR0VmwwWS9mQW5pYkxRQS9wODQ0YTU4RFhiOS9CM05WWUs1ell3?=
 =?utf-8?B?M2NyVlZtTllvVXE0S3BETzBYSWN1cS9mV0gwYmdUamV3cnNURjZLa1JpK2xI?=
 =?utf-8?B?ZWI2VWMrQzV1S0lMRXNzaE85d25FRTJsSVNxdW1GZmZ6MjI3aURJK1N6TThP?=
 =?utf-8?B?dEVqdExadDNndWQvbFdNMW9iajlPMkdHVTBjUmpzVVkrK1RSZ0FCVTZGdEgw?=
 =?utf-8?B?dy9BSm9Lcjc2cXY5UGFLY0dJbGRHdDhWaXBacE9teEF3aDBjWnFSalZnU1Rt?=
 =?utf-8?B?S2JiQ1FPVGxQdUpYTERsNmtxUDAvaGwwZE12Z0ViM241WEhtSFZrWFVLeVFO?=
 =?utf-8?B?QkZveEVuMHpUajBPT1RlcDI0M0xCd0Q0cFU4T2k3VGx1WkFVTlJ6a2ZoNWpN?=
 =?utf-8?B?Z1lFQXJPZEdSU2htd0VzQ3dYR0VubCtxa1hMdFNBaUwrNUZqSzVidXhsM2lk?=
 =?utf-8?B?Mk02bG1HWlVndHJUWEVUK2R2TW50NnhvVTYyMG1VdXo3SWlKbEZaVkp2SmV3?=
 =?utf-8?B?QlVKVE9KNDV4QjFnbTJUWTl2TTh3V3FqMzkwMVcxSGdOQXJXM01IQkdhZmxw?=
 =?utf-8?B?Mi85UTN2UFBWU3hHZHNnVENCZFk0UnNhRTdqamhMcDBwd2pXaWVVSzhEWjRs?=
 =?utf-8?B?MlhNSi9CYUFjRW1BaUlQZjhjdEdzNWNiTlhPUFM0dU5QU0NLYVFZcDc5WGVi?=
 =?utf-8?B?Q0UycTZ1ZklNUEZVdmR2eU9UK3BjMW5JR0dlVGpQbkpFMGtWY05PUlZrRURQ?=
 =?utf-8?B?ZmhGN2VaRm9uZGN2c1U1WWgwRkh1RUx4dExlb2tMVmNNWEJYdEEwdFM5WXJZ?=
 =?utf-8?B?MlZNY0psZnVQOStLRVdOUU5oUDB3OXorU0U5UUhmVkhTYjluQjkxaXk0ZmMy?=
 =?utf-8?B?a0wxSFlTUVoxWUQ1NTdoWDFYcmZjTmt3d2kxbTdaZjN3azYvZStoUXkwNVRI?=
 =?utf-8?B?M3ZkMkdkS1BsZzV5MitGK3dWelU3cXFCU2pQYTkyMWlRMEJCL2dnK2FKNSt0?=
 =?utf-8?B?b3VZdERWUW1kbWlnZEFPczVWUFRIVmtvc2JTVVZjdjRSMWFsNGJFSDFGR05i?=
 =?utf-8?B?UCtwV21jbVloL2Y3QytMbVorZHJqRFdMZUU4NUpLVWw5MWZoSFBidFVQOFMw?=
 =?utf-8?B?cWRDUGJEY0hjTS9kbFRmVnk0ZmgwMEVCdkJnaWU3cGNCb2lzM3VuZlBPWDZZ?=
 =?utf-8?B?TllIRUZ3Q29hS2tXc1pqMmczU2FrVGc2VmRySEFJRi9MQnBBY3NzWnR2eU5u?=
 =?utf-8?B?VmE0Q0srNUJVeUJBeEVLeUs0MGQ3S2ZBRitRUWx1My9DTGN4UHJ4L0FMb3RZ?=
 =?utf-8?B?Y1pTM2FiU1ZNQ2F2QnNtbTUrTE5Xc0paUXNLSS9MMnh2TEJXTVpYSzRoVFdl?=
 =?utf-8?B?Q2ZZTkFMOXZ5dG9xQnQ5d01WLyswZzZ3U0drcDJRN1hpR0E2QTJFc3dFTTFs?=
 =?utf-8?B?ZmI1c2pHa0FmYmJSQmk1emlyQS9UcVB1cjJPL1FHY3BhaXNiZ3U0SnorNmJI?=
 =?utf-8?B?V0Y4cHhPWHc0U1FxQXlTR3U0emwxVWVoSFp5V2JzZ3p2RE1YRG11cER6eDQx?=
 =?utf-8?B?NEpieFR5ODJYdXFZbGlMS2tOamtOR25kNWx0cVphSm1NZWV2VG8vcGRqMjQ3?=
 =?utf-8?B?UUVyekxRakdIbUJ6dERvVy9ISFlEemVsd001K2dWRXhGK3ZtQjlBbHVpYjRp?=
 =?utf-8?B?TDVQMTVaQWsza3YvL285N3RpTWVnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hitachienergy.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0602MB3671.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8589aefb-034f-4601-3559-08d9ba624c16
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 15:49:19.4721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7831e6d9-dc6c-4cd1-9ec6-1dc2b4133195
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CliemBGWOnsUTH1h3UAU7cGl1EFtZZhEN4jY115bS9rzPxo9jnDebZ2iW5xPxHf4dy/Ki4B/Vow7QG6C2MkmtfiydLKyGNvlQbtcXqJNlRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR06MB6166
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiA+DQo+ID4gPiA+IFRoZSBtdjg4ZTYzNTIsIG12ODhlNjI0MCBhbmQgbXY4OGU2MTc2ICBoYXZl
IGEgc2VyZGVzIGludGVyZmFjZS4NCj4gPiA+ID4gVGhpcyBwYXRjaCBhbGxvd3MgdG8gY29uZmln
dXJlIHRoZSBvdXRwdXQgc3dpbmcgdG8gYSBkZXNpcmVkIHZhbHVlDQo+ID4gPiA+IGluIHRoZSBk
ZXZpY2V0cmVlIG5vZGUgb2YgdGhlIHBvcnQuIEFzIHRoZSBjaGlwcyBvbmx5IHN1cHBvcnRzDQo+
ID4gPiA+IGVpZ2h0IGRlZGljYXRlZCB2YWx1ZXMgd2UgcmV0dXJuIEVJTlZBTCBpZiB0aGUgdmFs
dWUgaW4gdGhlIERUUyBkb2VzIG5vdA0KPiBtYXRjaC4NCj4gPiA+ID4NCj4gPiA+ID4gQ0M6IEFu
ZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gPiA+ID4gQ0M6IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+ID4gPiA+IENDOiBNYXJlayBCZWjDum4gPGthYmVsQGtlcm5lbC5v
cmc+DQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEhvbGdlciBCcnVuY2sgPGhvbGdlci5icnVuY2tA
aGl0YWNoaWVuZXJneS5jb20+DQo+ID4gPg0KPiA+ID4gSG9sZ2VyLCBBbmRyZXcsDQo+ID4gPg0K
PiA+ID4gdGhlcmUgaXMgYW5vdGhlciBpc3N1ZSB3aXRoIHRoaXMsIHdoaWNoIEkgb25seSByZWFs
aXplZCB5ZXN0ZXJkYXkuDQo+ID4gPiBXaGF0IGlmIHRoZSBkaWZmZXJlbnQgYW1wbGl0dWRlIG5l
ZWRzIHRvIGJlIHNldCBvbmx5IGZvciBjZXJ0YWluIFNlckRlcw0KPiBtb2Rlcz8NCj4gPiA+DQo+
ID4gPiBJIGFtIGJyaW5naW5nIHRoaXMgdXAgYmVjYXVzZSBJIGRpc2NvdmVyZWQgdGhhdCBvbiBU
dXJyaXMgTW94IHdlDQo+ID4gPiBuZWVkIHRvIGluY3JlYXNlIFNlckRlcyBvdXRwdXQgYW1wbGl0
dWRlIHdoZW4gQTM3MjAgU09DIGlzIGNvbm5lY3RlZA0KPiA+ID4gZGlyZWN0bHkgdG8NCj4gPiA+
IDg4RTYxNDEgc3dpdGNoLCBidXQgb25seSBmb3IgMjUwMGJhc2UteCBtb2RlLiBGb3IgMTAwMGJh
c2UteCwgdGhlDQo+ID4gPiBkZWZhdWx0IGFtcGxpdHVkZSBpcyBva2F5LiAoQWxzbyB3aGVuIHRo
ZSBTT0MgaXMgY29ubmVjdGVkIHRvDQo+ID4gPiA4OEU2MTkwLCB0aGUgYW1wbGl0dWRlIGRvZXMg
bm90IG5lZWQgdG8gYmUgY2hhbmdlZCBhdCBhbGwuKQ0KPiA+ID4NCj4gPg0KPiA+IG9uIG15IGJv
YXJkIEkgaGF2ZSBhIGZpeGVkIGxpbmsgY29ubmVjdGVkIHdpdGggU0dNSUkgYW5kIHRoZXJlIGlz
IG5vDQo+ID4gZGVkaWNhdGVkIHZhbHVlIGdpdmVuIGluIHRoZSBtYW51YWwuDQo+ID4NCj4gPiA+
IEkgcGxhbiB0byBzb2x2ZSB0aGlzIGluIHRoZSBjb21waHkgZHJpdmVyLCBub3QgaW4gZGV2aWNl
LXRyZWUuDQo+ID4gPg0KPiA+ID4gQnV0IGlmIHRoZSBzb2x1dGlvbiBpcyB0byBiZSBkb25lIGlu
IERUUywgc2hvdWxkbid0IHRoZXJlIGJlIGENCj4gPiA+IHBvc3NpYmlsaXR5IHRvIGRlZmluZSB0
aGUgYW1wbGl0dWRlIGZvciBhIHNwZWNpZmljIHNlcmRlcyBtb2RlIG9ubHk/DQo+ID4gPg0KPiA+
ID4gRm9yIGV4YW1wbGUNCj4gPiA+ICAgc2VyZGVzLTI1MDBiYXNlLXgtdHgtYW1wbGl0dWRlLW1p
bGxpdm9sdA0KPiA+ID4gb3INCj4gPiA+ICAgc2VyZGVzLXR4LWFtcGxpdHVkZS1taWxsaXZvbHQt
MjUwMGJhc2UteA0KPiA+ID4gb3INCj4gPiA+ICAgc2VyZGVzLXR4LWFtcGxpdHVkZS1taWxsaXZv
bHQsMjUwMGJhc2UteA0KPiA+ID4gPw0KPiA+ID4NCj4gPiA+IFdoYXQgZG8geW91IHRoaW5rPw0K
PiA+ID4NCj4gPg0KPiA+IGluIHRoZSBkYXRhIHNoZWV0IGZvciB0aGUgTVY2MzUyIEkgYW0gdXNp
bmcgdGhlcmUgYXJlIG5vIGRlZGljYXRlZA0KPiA+IHZhbHVlcyBzdGF0ZWQgZm9yIGRpZmZlcmVu
dCBtb2RlcyBhdCBhbGwsIHRoZXkgY2FuIGJlIGNob3Nlbg0KPiA+IGFyYml0cmFyeS4gU28gaW4g
bXkgY2FzZSBJIHRoaW5rIGl0IG1ha2VzIHNlbnNlIHRvIGtlZXAgaXQgYXMgaXQgaXMNCj4gPiBm
b3Igbm93LiBPdGhlciBkcml2ZXIgbWF5IGhhdmUgb3RoZXIgbmVlZHMgYW5kIG1heSBlbmhhbmNl
IHRoaXMgbGF0ZXIgb24uDQo+IA0KPiBIaSBIb2xnZXIsDQo+IA0KPiBidXQgdGhlIG12ODhlNnh4
eCBkcml2ZXIgYWxzbyBkcml2ZXMgc3dpdGNoZXMgdGhhdCBhbGxvdyBjaGFuZ2luZyBzZXJkZXMN
Cj4gbW9kZXMuIFRoZXJlIGRvZXMgbm90IG5lZWQgYmUgZGVkaWNhdGVkIFRYIGFtcGxpdHVkZSBy
ZWdpc3RlciBmb3IgZWFjaCBzZXJkZXMNCj4gbW9kZSwgdGhlIHBvaW50IGlzIHRoYXQgd2UgbWF5
IHdhbnQgdG8gZGVjbGFyZSBkaWZmZXJlbnQgYW1wbGl0dWRlcyBmb3INCj4gZGlmZmVyZW50IG1v
ZGVzLg0KPiANCj4gU28gdGhlIHF1ZXN0aW9uIGlzOiBpZiB3ZSBnbyB3aXRoIHlvdXIgYmluZGlu
ZyBwcm9wb3NhbCBmb3IgdGhlIHdob2xlIG12ODhlNnh4eA0KPiBkcml2ZXIsIGFuZCBpbiB0aGUg
ZnV0dXJlIHNvbWVvbmUgd2lsbCB3YW50IHRvIGRlY2xhcmUgZGlmZmVyZW50IGFtcGxpdHVkZXMg
Zm9yDQo+IGRpZmZlcmVudCBtb2RlcyBvbiBhbm90aGVyIG1vZGVsLCB3b3VsZCBoZSBuZWVkIHRv
IGRlcHJlY2F0ZSB5b3VyIGJpbmRpbmcgb3INCj4gd291bGQgaXQgYmUgZWFzeSB0byBleHRlbmQ/
DQo+IA0KDQpvayBJIHNlZS4gU28gaWYgSSBmb2xsb3cgeW91ciBwcm9wb3NhbCBpbiBteSBjYXNl
IGl0IHdvdWxkIGJlIHNvbWV0aGluZyBsaWtlOg0Kc2VyZGVzLXNnbWlpLXR4LWFtcGxpdHVkZS1t
aWxsaXZvbHQgdG8gc3RhcnQgd2l0aCA/IA0KDQpJIGNhbiBkbyB0aGF0LiBBbmRyZXcgd2hhdCBk
byB5b3UgdGhpbms/DQoNCkJlc3QgcmVnYXJkcw0KSG9sZ2VyDQoNCg==
