Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A790923B584
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 09:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgHDHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 03:24:12 -0400
Received: from mail-eopbgr30050.outbound.protection.outlook.com ([40.107.3.50]:16981
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726974AbgHDHYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 03:24:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzWt1n+pJb0K2JSXCJ3vCmOpXM5tvj1SnQ7zisVwNRuFnr4Swt3J0EYAfn62YVWP8i6xJ+O5S59ODyenB61iTyUBopEniGsWKi1jYVrElvlApY/Ufbd6UQ/7UJcCb2WVRx581YH3rVKfKq2pJRVsMkHxJoFZeSJTb2LHP6jmJir4lhA/ygOVxeC1YFwJVR8UMPOpnQiM65NXYZQVpGkVpHy2lZTLvYtc6uoVmyVdQUaxpnRJY16/sQ6IDEnj4zqP7sLRuMFbOTONTIH2Q1jk3il/j56pkY8ucwaZYLGPd54iyH0jaNNsuC0yNRevp0H0T2sVgBCEPMfdlEXbeWgACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6UNBEy2XSfvz0lrYoqJhsrNUYSgKGFHlfXO84QXToc=;
 b=AKSDCkyKSyvouSpQsf3z8yTP/R78OIMp3DUaD5MpXLzJ6zBPJyaabOhHfgJ96pgwAKhqzr7faxqoe8ALIDlOjJZKHs00eNKTPde1k6igKgxwueQfqy83CnQcD2Dmgp8xVeh+BnHgpZVH1aZB25tgdpf2sYn3ZWLutO/JJo0IRtxuGE2ECNed4OK6wuHgnJMgXoLU9sPAAj6jmXvm7mrmBPGz7DgoMjehnA3zmGBfMslIgioYuId2gIvzvO5+OHhGEBs6bvaoHjk67B4cJLOjTIZWYJgLBGkNhaWO/wBlG3CguMf+q5SDzGAE3XMhzazLa1J2qUjiItjxxWFcM5nmLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6UNBEy2XSfvz0lrYoqJhsrNUYSgKGFHlfXO84QXToc=;
 b=QVkWS5F+jVCtI4F6NmdqwDRHPK4I7EEh/p2lH3XsP8Zbsi89oW8daUxMv2CjBnEYvmdxtF+NjlX7KI8Oq/aCsS0PpLzYKo+Xtthwn4LDGQMkJRtPZkP2li/4KzexASJ8hROOYbfbRon2S2ICakuKyZnU5oblklH4Ky+qL78jcWU=
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5408.eurprd04.prod.outlook.com (2603:10a6:803:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Tue, 4 Aug
 2020 07:24:07 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 07:24:07 +0000
From:   Hongbo Wang <hongbo.wang@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivecera@redhat.com" <ivecera@redhat.com>
Subject: RE: [EXT] Re: [PATCH v4 1/2] net: dsa: Add protocol support for
 802.1AD when adding or deleting vlan for dsa switch port
Thread-Topic: [EXT] Re: [PATCH v4 1/2] net: dsa: Add protocol support for
 802.1AD when adding or deleting vlan for dsa switch port
Thread-Index: AQHWaebZKp4c4rtjzUeenZF+rgT5zaknf1sg
Date:   Tue, 4 Aug 2020 07:24:07 +0000
Message-ID: <VI1PR04MB51034BDB57C9DA0A346FBF0DE14A0@VI1PR04MB5103.eurprd04.prod.outlook.com>
References: <20200730102505.27039-1-hongbo.wang@nxp.com>
 <20200730102505.27039-2-hongbo.wang@nxp.com>
 <effcb1fe-79ed-ed79-ffe3-977ed9aa006e@gmail.com>
In-Reply-To: <effcb1fe-79ed-ed79-ffe3-977ed9aa006e@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 663482a6-a84a-4baa-5aa1-08d838475fb9
x-ms-traffictypediagnostic: VI1PR04MB5408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB540818EB54E9B92DF2AABDD3E14A0@VI1PR04MB5408.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WoeUkTWeidXUnsVG5ixed2EwOgnW9ylcC/nl1yQeem0i11hpzyT7CB3aowRKZwx5R8bz5kG5rBSvKn/94/G/UL+LezceuP949omzB1wFbJN524fKV7TM1JqrcxV6JTJWKoGbfui3i2eZfC3gNEL5Hdb0Phzf6rfHigEEHCet/EalNKsMKpNbRztyKDjBPHcikhjgq0sqiUJbksiLSFV3Bp82e5EGbeem6wwV5vAewYUYH2b5h4BZgFgAYVXNnAwWLBLR/2VIQsUKZSJS0fFeLCFx9Sp1FZp6HPzGZNIpZVOsLSyA/7C6C8B+5RX4Max7fQu0PA7eCbOq0gWq2oiGFA9MVbOk4O15EWMbCZAcsOrAw8pKe/IcG/c5oj1PkBLM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(26005)(64756008)(66476007)(83380400001)(316002)(66946007)(7696005)(44832011)(76116006)(66446008)(8936002)(186003)(8676002)(66556008)(2906002)(6506007)(5660300002)(52536014)(7416002)(55016002)(86362001)(71200400001)(110136005)(9686003)(33656002)(478600001)(921003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: V9tFPGe+GoHIcXCPKx8+W/ehh9ib8uTbGpgyC+JG3kmWcJklDU1s7WRdiFIiAkN2DJbdNiMMmEGLK4uz4m/xcubPD+o1QfAq44PAhE9gxxQ1Wh0PYqstcs1VbEO6A9nqmowaLvuS2EoTinGg2/X1E1b02Mw22LXmKBlfwRaccDSXFfjMwjBRFzDdTqeGeSGCtjBwT3RjORtLtRbA3Ql3XxeGxmgZDo6J8AmBOYqafsQZV4pNlOFUZ/EmRbVDBmKA7So4NfilNVVTvHqFBwXWf72KflBo/D6mVctrrarFqA+Cxod2dPXWpFL/QDnlt7wfdtqQzwaCXzwCmRDcxVsusIpBWFyXb0LlXFnyDrCgr9vy24NALZrCnSp/kr5MO/UMvMW1KoF0+HHFDQeCuVWotr7gb/QtC45F0+dAdON4B2YXCNpgUTJACbrLEWTvt/o7E6iSa5BlFqsSewArsrW8nrE4hJIcaYJFHLyMbvJRzEx3Riq3OSme/V/0d4IWJvZk/ldS6edX5P+z1IuaIxWTEs0jZXsIZMncgWj4rzmc905A/EfjjqPnM7c4+ilov2/lH1l6BEbYLw+BfU+2LdNyuIU5CEQkD8Wej1xzh8Fpw8fr+aNLcfXEd3xN5QTMSuysdnSLC1edq+ULCYLA/9Pccw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663482a6-a84a-4baa-5aa1-08d838475fb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 07:24:07.0852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KuF7UoqcUUI9Qc9dhzG/5wkZ8CSdptP5dtePUj77fFXPXNwpw1crpa1A6K8Z1KbOiFR5t8+FyW/Zeemrwxl0Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBZb3UgYXJlIGFkZGluZyBhIG5ldyBtZW1iZXIgdG8gdGhlIHN3aXRjaGRldiBWTEFOIG9iamVj
dCwgc28geW91IHNob3VsZA0KPiBtYWtlIHN1cmUgdGhhdCBhbGwgY2FsbCBwYXRocyBjcmVhdGlu
ZyBhbmQgcGFyc2luZyB0aGF0IG9iamVjdCBnZXQgdXBkYXRlZCBhcw0KPiB3ZWxsLCBmb3Igbm93
LCB5b3UgYXJlIGRvaW5nIHRoaXMgc29sZWx5IHdpdGhpbiBEU0Egd2hpY2ggaXMgcHJvYmFibHkN
Cj4gcmVhc29uYWJsZSBpZiB3ZSBhc3N1bWUgcHJvdG8gaXMgdW5pbml0aWFsaXplZCBhbmQgdW51
c2VkIGVsc2V3aGVyZSwgdGhlcmUgaXMNCj4gbm8gY2hhbmdlIG9mIGZ1bmN0aW9uYWxpdHkuDQoN
Ckkgd2lsbCByZXZpZXcgdGhlIHJlbGF0ZWQgY29kZSwgYW5kIGNvbmZpcm0gaXQuDQoNCj4gW3Nu
aXBdDQo+ID4gKyAgICAgICAgICAgICByZXQgPSBicl92bGFuX2dldF9wcm90byhkcC0+YnJpZGdl
X2RldiwgJmJyX3Byb3RvKTsNCj4gPiArICAgICAgICAgICAgIGlmIChyZXQgPT0gMCAmJiBicl9w
cm90byAhPSB2bGFuX3Byb3RvKQ0KPiA+ICsgICAgICAgICAgICAgICAgICAgICBjaGFuZ2VfcHJv
dG8gPSB0cnVlOw0KPiANCj4gDQo+IFRoaXMgZGVzZXJ2ZXMgYSBjb21tZW50LCBiZWNhdXNlIHRo
ZSBjaGFuZ2VfcHJvdG8gdmFyaWFibGUgaXMgbm90IHJlYWxseQ0KPiBleHBsYWluaW5nIHdoYXQg
dGhpcyBpcyBhYm91dCwgbWF5YmUgbW9yZSBsaWtlICJpbmNvbXBhdGlibGVfcHJvdG8iIHdvdWxk
Pw0KPiANCj4gRmlyc3QgeW91IHF1ZXJ5IHRoZSBWTEFOIHByb3RvY29sIGN1cnJlbnRseSBjb25m
aWd1cmVkIG9uIHRoZSBicmlkZ2UgbWFzdGVyDQo+IGRldmljZSwgYW5kIGlmIHRoaXMgVkxBTiBw
cm90b2NvbCBpcyBkaWZmZXJlbnQgdGhhbiB0aGUgb25lIGJlaW5nIHJlcXVlc3RlZCwNCj4gdGhl
biB5b3UgdHJlYXQgdGhpcyBhcyBhbiBlcnJvci4gSXQgbWlnaHQgbWFrZSBzZW5zZSB0byBhbHNv
IHByaW50IGEgbWVzc2FnZQ0KPiB0b3dhcmRzIHRoZSB1c2VyIHRoYXQgdGhlIGJyaWRnZSBkZXZp
Y2UgcHJvdG9jb2wgc2hvdWxkIGJlIGNoYW5nZWQsIG9yIHRoYXQNCj4gdGhlIGJyaWRnZSBkZXZp
Y2Ugc2hvdWxkIGJlIHJlbW92ZWQgYW5kIHJlLWNyZWF0ZWQgYWNjb3JkaW5nbHkuDQo+IA0KPiBE
b2VzIGl0IG5vdCB3b3JrIGlmIHdlIGhhdmUgYSBicmlkZ2UgY3VycmVudGx5IGNvbmZpZ3VyZWQg
d2l0aCA4MDIuMWFkIGFuZCBhDQo+IDgwMi4xcSBWTEFOIHByb2dyYW1taW5nIHJlcXVlc3QgY29t
ZXMgaW4/IEluIHByZW1pc2UgaXQgc2hvdWxkLCByaWdodD8NCj4gTGlrZXdpc2UsIGlmIHdlIGhh
ZCBhIDgwMi4xYWQgYnJpZGdlIGNvbmZpZ3VyZWQgYWxyZWFkeSBhbmQgd2Ugd2FudCB0bw0KPiBj
b25maWd1cmUgYSA4MDIuMVEgVkxBTiBvbiBhIGJyaWRnZWQgcG9ydCwgdGhlcmUgc2hvdWxkIGJl
IGEgd2F5IGZvciB0aGlzDQo+IGNvbmZpZ3VyYXRpb24gdG8gd29yay4NCj4gDQo+IEFuZCBib3Ro
IGNhc2VzLCBpdCBvdWdodCB0byBiZSBwb3NzaWJsZSB0byBjb25maWd1cmUgdGhlIHN3aXRjaCBp
biBkb3VibGUNCj4gdGFnZ2VkIG1vZGUgYW5kIGp1c3QgbWFrZSBzdXJlIHRoYXQgdGhlcmUgaXMg
bm8gUy10YWcgYmVpbmcgYWRkZWQgdW5sZXNzDQo+IHJlcXVlc3RlZC4NCg0KVGhhbmtzIGZvciBs
b25nIHJlcGx5Lg0KDQpXaGVuIGNyZWF0ZSBhIGJyaWRnZSBicjAsIGl0J3MgZGVmYXVsdCBwcm90
b2NvbCBpcyA4MDIuMVEsIHRoZW4gYWRkIGEgcG9ydCBzd3AxIHRvIGJyaWRnZSwgdGhlIGJyaWRn
ZSB3aWxsIGNhbGwgYWRkX3ZsYW4gYWRkIGEgZGVmYXVsdCBWTEFOIHRvIHN3cDEsIGl0cyB2aWQg
aXMgcHZpZCAxLCB0aGUgdmxhbidzIHByb3RvY29sIGlzIDgwMi4xUS4gdGhlIHJlbGF0ZWQgY29t
bWFuZCBpczoNCiMgaXAgbGluayBhZGQgZGV2IGJyMCB0eXBlIGJyaWRnZQ0KIyBpcCBsaW5rIHNl
dCBkZXYgc3dwMSBtYXN0ZXIgYnIwDQoNCkFmdGVyIHRlc3RpbmcgcG9ydCdzIDgwMi4xUSBtb2Rl
LCBJZiB3YW50IHRvIHRlc3QgODAyLjFBRCBtb2RlLCB3ZSBjYW4gdXNlIHRoZSBmb2xsb3dpbmcg
Y29tbWFuZCB0byBzZXQgc3dpdGNoIGFuZCBpdHMgIHBvcnRzIGludG8gUWluUSBtb2RlLCANCiMg
aXAgbGluayBzZXQgYnIwIHR5cGUgYnJpZGdlIHZsYW5fcHJvdG9jb2wgODAyLjFhZA0KaXQgd2ls
bCBjYWxsIHZsYW5fdmlkX2FkZChkZXYsIHByb3RvLCB2aWQpIGZvciBldmVyeSBwb3J0LCB0aGUg
cGFyYW1ldGVyIHByb3RvIGlzIDgwMi4xQUQgYW5kIHRoZSB2aWQgaXMgYWxzbyAxLCBhZnRlciB0
aGF0LCBpdCB3aWxsIHNldCBici0+dmxhbl9wcm90byB0byA4MDIuMUFELCB0aGUgcmVsYXRlZCBj
b2RlIGlzIF9fYnJfdmxhbl9zZXRfcHJvdG8gaW4gYnJfdmxhbi5jDQoNCnZsYW5fdmlkX2FkZCB3
aWxsIGNhbGwgZHNhX3NsYXZlX3ZsYW5fcnhfYWRkX3ZpZC4NCkJ1dCBpbiBkc2Ffc2xhdmVfdmxh
bl9yeF9hZGRfdmlkLCBiZWNhdXNlIHdlIGhhZCBhZGRlZCB2bGFuIDEgYmVmb3JlLCBzbyBicl92
bGFuX2dldF9pbmZvIHdpbGwgcmV0dXJuIDAsIHRoZW4gdGhlIGZ1bmN0aW9uIHJldHVybiAtRUJV
U1ksIGl0IGNhbid0IGNhbGwgZHNhX3BvcnRfdmlkX2FkZCwgc28gSSBhZGQgdGhlIGNvZGUgdG8g
Y2hlY2sgcHJvdG9jb2wgY2hhbmdpbmcuDQoNCkkgd2lsbCBhZGQgY29kZSB0byBwcmludCB0aGUg
bWVzc2FnZSBmb3IgcHJvdG9jb2wgY2hhbmdpbmcuDQoNCj4gPiArICAgICAgICAgICAgIHJldCA9
IGJyX3ZsYW5fZ2V0X3Byb3RvKGRwLT5icmlkZ2VfZGV2LCAmYnJfcHJvdG8pOw0KPiA+ICsgICAg
ICAgICAgICAgaWYgKHJldCA9PSAwICYmIGJyX3Byb3RvICE9IHZsYW5fcHJvdG8pDQo+ID4gKyAg
ICAgICAgICAgICAgICAgICAgIGNoYW5nZV9wcm90byA9IHRydWU7DQo+ID4gKw0KPiA+ICAgICAg
ICAgICAgICAgLyogYnJfdmxhbl9nZXRfaW5mbygpIHJldHVybnMgLUVJTlZBTCBvciAtRU5PRU5U
IGlmIHRoZQ0KPiA+ICAgICAgICAgICAgICAgICogZGV2aWNlLCByZXNwZWN0aXZlbHkgdGhlIFZJ
RCBpcyBub3QgZm91bmQsIHJldHVybmluZw0KPiA+ICAgICAgICAgICAgICAgICogMCBtZWFucyBz
dWNjZXNzLCB3aGljaCBpcyBhIGZhaWx1cmUgZm9yIHVzIGhlcmUuDQo+ID4gICAgICAgICAgICAg
ICAgKi8NCj4gPiAgICAgICAgICAgICAgIHJldCA9IGJyX3ZsYW5fZ2V0X2luZm8oZHAtPmJyaWRn
ZV9kZXYsIHZpZCwgJmluZm8pOw0KPiA+IC0gICAgICAgICAgICAgaWYgKHJldCA9PSAwKQ0KPiA+
ICsgICAgICAgICAgICAgaWYgKHJldCA9PSAwICYmICFjaGFuZ2VfcHJvdG8pDQo+ID4gICAgICAg
ICAgICAgICAgICAgICAgIHJldHVybiAtRUJVU1k7DQo+IA0KPiBTaW5jZSB3ZSBhcmUgY29weWlu
ZyB0aGUgc2FtZSBjb2RlIHRoYW4gaW4gdGhlIGFkZF92aWQgcGF0aCwgaXQgbWlnaHQgbWFrZQ0K
PiBzZW5zZSB0byBleHRyYWN0IHRoaXMgdG8gYSBoZWxwZXIgZnVuY3Rpb24gZXZlbnR1YWxseS4N
Cg0KSSB3aWxsIGV4dHJhY3QgdGhlIGNvZGUgdG8gaGVscGVyIGZ1bmN0aW9uLg0KDQo+ID4gICAg
ICAgc2xhdmVfZGV2LT5mZWF0dXJlcyA9IG1hc3Rlci0+dmxhbl9mZWF0dXJlcyB8IE5FVElGX0Zf
SFdfVEM7DQo+ID4gICAgICAgaWYgKGRzLT5vcHMtPnBvcnRfdmxhbl9hZGQgJiYgZHMtPm9wcy0+
cG9ydF92bGFuX2RlbCkNCj4gPiAtICAgICAgICAgICAgIHNsYXZlX2Rldi0+ZmVhdHVyZXMgfD0g
TkVUSUZfRl9IV19WTEFOX0NUQUdfRklMVEVSOw0KPiA+ICsgICAgICAgICAgICAgc2xhdmVfZGV2
LT5mZWF0dXJlcyB8PSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19GSUxURVIgfA0KPiA+ICsNCj4gTkVU
SUZfRl9IV19WTEFOX1NUQUdfRklMVEVSOw0KPiANCj4gWW91IGNhbm5vdCBhZHZlcnRpc2UgdGhp
cyBuZXRkZXYgZmVhdHVyZSBmb3IgKmFsbCogRFNBIHN3aXRjaCBkcml2ZXIgdW5sZXNzIHlvdQ0K
PiBoYXZlIHZlcmlmaWVkIHRoYXQgZWFjaCBEU0EgZHJpdmVyIGltcGxlbWVudGluZw0KPiBwb3J0
X3ZsYW5fYWRkKCkgd2lsbCB3b3JrIGNvcnJlY3RseS4gUGxlYXNlIGFzc2lnbiB0aGlzIGZsYWcg
ZnJvbSB3aXRoaW4gdGhlDQo+IG9jZWxvdCBkcml2ZXIgZm9yIG5vdy4NCg0KSSB3aWxsIGNoYW5n
ZSBpdCBpbiBuZXh0IHZlcnNpb24uDQoNCj4gDQo+ID4NCj4gPiAgICAgICBpZiAoZW5hYmxlZCkN
Cj4gPiAtICAgICAgICAgICAgIHJldHVybiBkc2FfcG9ydF92aWRfYWRkKGRwLCB2aWQsIGZsYWdz
KTsNCj4gPiArICAgICAgICAgICAgIHJldHVybiBkc2FfcG9ydF92aWRfYWRkKGRwLCB2aWQsIDAs
IGZsYWdzKTsNCj4gDQo+IFdoeSBub3QgcGFzcyBFVEhfUF84MDIxUSBoZXJlIHRvIGluZGljYXRl
IHdlIHdhbnQgYSA4MDIuMVEsIG5vdCAuQUQNCj4gY29uZmlndXJhdGlvbiByZXF1ZXN0Pw0KPiAt
LQ0KSSB3aWxsIGNoYW5nZSBpdCBpbiBuZXh0IHZlcnNpb24uDQoNCg0K
