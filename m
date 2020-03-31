Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C789C198DE9
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgCaIGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:06:11 -0400
Received: from mail-am6eur05on2111.outbound.protection.outlook.com ([40.107.22.111]:55264
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgCaIGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 04:06:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G+telTbKqllpyrgoCI4OMEAhccJMZ4axD/+zpqfSUObWOlzDGkWhC/8hDVeOs4E4ZfdsdY2r/0aMdrZlN0oo8p+/2e8Pd24/vp83CMhy56DGAKCbX1GHDh1CqvxYLhj3UVYDt9vP7KLZRtWZjNgieDOgNEkWn+oZ3ORbOIysqdKskVuX+HcO3u2yuWYpUTOij7Y4+0VG65Hu1SX7tjqgQTlm2PsBl8lCuooJkMeZBnibtXeNg4JJjrGtDcy39hZj4LL8gtlATE/zM8YHiJZaVb19sVINnqD+SbmkwrFVISLNzvBsn4j/lTfuJWJDvVeOe345fZwkVg9jTZai2RPKiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVPoFZXqlypcWl3kUsmEWYRrtohiVVJ5clzuQ44ZtyQ=;
 b=oe9qADdlqkdIQ9loEHt7LNBo6kZRLvqnAJyv5TZalPFSWsc9ldRelOah8DykNTzkfTAF6ObVlRj60GxYXP4jGCF4291l+IE5ztH39amHWoEmtlupTyHnCTwOSEGxbuYXWwAbZFiSR0zAyPSxxYI8o5fWNY2+kK3Lc6z6zL7gP70tgwDe8aptJeZH1b7VBm8W6bnPpAtT3aANSZz6o3yIUeyOy+c0kGMB3WMp4g7qqzjGeua0CdQm7MLwJB1En4b8X7QQGzOorugn9tkuxCdOLvxIi1s3rRtrKlaZON8flXZRaDQl651EcVykwrQBPKBoKunZXwliDR5XqqMSLt5wpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wVPoFZXqlypcWl3kUsmEWYRrtohiVVJ5clzuQ44ZtyQ=;
 b=U6qvL4Gfk/9iROlL3ZPtQgLdUlTh2wINxBntf9Pr/T02OkDOpe4GbRuqrWqRqq3w+Xb1bJ3ZDKh+d/CTA0YsE+yB9FNBnQ+4Hi21KzRyNxs/fKmzAJEs44bkA8kJCfwXwVm6gXwYgTIrlp3mFS7VfSIhJD2f+rSeRh4U8G/kF2M=
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com (20.179.1.217) by
 AM6PR05MB4984.eurprd05.prod.outlook.com (20.177.33.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Tue, 31 Mar 2020 08:06:06 +0000
Received: from AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::44ad:bee7:b765:b9c7]) by AM6PR05MB6120.eurprd05.prod.outlook.com
 ([fe80::44ad:bee7:b765:b9c7%7]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 08:06:06 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-imx@nxp.com" <linux-imx@nxp.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@protonic.nl" <david@protonic.nl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Thread-Topic: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Thread-Index: AQHWBbntSLyiDNa7b0653TZgcLvty6hfrHgAgADvhoCAAMsVgIAAAkoAgADxpAA=
Date:   Tue, 31 Mar 2020 08:06:06 +0000
Message-ID: <159af8d57eff3ed93adff62b88adebd2a17c95b0.camel@toradex.com>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
         <20200329150854.GA31812@lunn.ch>
         <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
         <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
         <20200330174114.GG25745@shell.armlinux.org.uk>
In-Reply-To: <20200330174114.GG25745@shell.armlinux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.0 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=philippe.schenker@toradex.com; 
x-originating-ip: [51.154.7.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59962960-8ca4-4b8c-986b-08d7d54a5d7f
x-ms-traffictypediagnostic: AM6PR05MB4984:
x-microsoft-antispam-prvs: <AM6PR05MB49845E6057CBC01903254FF7F4C80@AM6PR05MB4984.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6120.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(396003)(346002)(376002)(366004)(39850400004)(26005)(6506007)(186003)(53546011)(81156014)(71200400001)(91956017)(66946007)(66446008)(66556008)(66476007)(76116006)(86362001)(64756008)(110136005)(54906003)(4326008)(5660300002)(316002)(6486002)(36756003)(44832011)(478600001)(2906002)(2616005)(8936002)(81166006)(6512007)(7416002)(8676002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WbXcuiH6f3dvQVcQErr6gZ/VEt+qu8eqkVLOwvrOFGcDBaQp7fNP7TRyY0atp/mIBfRVy0M7SX8jgK9yHWgv14mKQWUMeKE00GV0teZC3fr14x5vUAgkABRn+40R17K1Pj4neakUxc3R5Okervv3qBHQCY4stL4uD3R2+EBoERqzn/NmsJspM0OyW7pzpmo3zJwJBqUO8EIhrDr6waltkKlExKt1U4JcVBCUOd6SQy8/EX5YS9IxdB0sjchu+HfXSAXsvzEggSYGuW87G6t1iffvENhqKWdlAtkGYFST6CiCi9dGp2xJMVc+FzWAQcZ+l1AcK7NvqTB2xJ9iJ+a7N03aytcZk5c2k4XbfHgMUxnUDybWkqCJMySYkU/mGkkBGXlPYnQoDW7LRsUIkP3qU37kuuTDO+co6/7QqsS9ySe6Z5MJPjZQ9BeB0Jv3exiP
x-ms-exchange-antispam-messagedata: m5Z08HAgPB9tdCY2kpjealqL3vHU6oLluGms09qM3MCXGSWVpva4xdBN2NQhZ0VA+5zvdn5LFlgCxrkHwvQDrSffQH+0+CcgxVDgik1rsI39uIW5vGGMieGb8Wfh+kfFoyy0dM02bjU2K8GinfNqRw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <877492ABA595604784012E97A128F92C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59962960-8ca4-4b8c-986b-08d7d54a5d7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 08:06:06.8644
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 67FCEtB0LtFnJCdFWi6Prn0FJxN/kK+TF44Pa5pcFCrEjQIR1WmmQbe8aZksfiQHC+TYlHvhS18HfLxY7zYWOwiqpXYEmEbneBZVoRynKMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4984
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTMwIGF0IDE4OjQxICswMTAwLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGlu
dXggYWRtaW4gd3JvdGU6DQo+IE9uIE1vbiwgTWFyIDMwLCAyMDIwIGF0IDEwOjMzOjAzQU0gLTA3
MDAsIEZsb3JpYW4gRmFpbmVsbGkgd3JvdGU6DQo+ID4gDQo+ID4gT24gMy8yOS8yMDIwIDEwOjI2
IFBNLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToNCj4gPiA+IEhpIEFuZHJldywNCj4gPiA+IA0KPiA+
ID4gT24gU3VuLCBNYXIgMjksIDIwMjAgYXQgMDU6MDg6NTRQTSArMDIwMCwgQW5kcmV3IEx1bm4g
d3JvdGU6DQo+ID4gPiA+IE9uIFN1biwgTWFyIDI5LCAyMDIwIGF0IDAxOjA0OjU3UE0gKzAyMDAs
IE9sZWtzaWogUmVtcGVsIHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gSGkgT2xla3Npag0KPiA+
ID4gPiANCj4gPiA+ID4gPiArY29uZmlnIERFUFJFQ0FURURfUEhZX0ZJWFVQUw0KPiA+ID4gPiA+
ICsJYm9vbCAiRW5hYmxlIGRlcHJlY2F0ZWQgUEhZIGZpeHVwcyINCj4gPiA+ID4gPiArCWRlZmF1
bHQgeQ0KPiA+ID4gPiA+ICsJLS0taGVscC0tLQ0KPiA+ID4gPiA+ICsJICBJbiB0aGUgZWFybHkg
ZGF5cyBpdCB3YXMgY29tbW9uIHByYWN0aWNlIHRvIGNvbmZpZ3VyZQ0KPiA+ID4gPiA+IFBIWXMg
YnkgYWRkaW5nIGENCj4gPiA+ID4gPiArCSAgcGh5X3JlZ2lzdGVyX2ZpeHVwKigpIGluIHRoZSBt
YWNoaW5lIGNvZGUuIFRoaXMNCj4gPiA+ID4gPiBwcmFjdGljZSB0dXJuZWQgb3V0IHRvDQo+ID4g
PiA+ID4gKwkgIGJlIHBvdGVudGlhbGx5IGRhbmdlcm91cywgYmVjYXVzZToNCj4gPiA+ID4gPiAr
CSAgLSBpdCBhZmZlY3RzIGFsbCBQSFlzIGluIHRoZSBzeXN0ZW0NCj4gPiA+ID4gPiArCSAgLSB0
aGVzZSByZWdpc3RlciBjaGFuZ2VzIGFyZSB1c3VhbGx5IG5vdCBwcmVzZXJ2ZWQNCj4gPiA+ID4g
PiBkdXJpbmcgUEhZIHJlc2V0DQo+ID4gPiA+ID4gKwkgICAgb3Igc3VzcGVuZC9yZXN1bWUgY3lj
bGUuDQo+ID4gPiA+ID4gKwkgIC0gaXQgY29tcGxpY2F0ZXMgZGVidWdnaW5nLCBzaW5jZSB0aGVz
ZSBjb25maWd1cmF0aW9uDQo+ID4gPiA+ID4gY2hhbmdlcyB3ZXJlIG5vdA0KPiA+ID4gPiA+ICsJ
ICAgIGRvbmUgYnkgdGhlIGFjdHVhbCBQSFkgZHJpdmVyLg0KPiA+ID4gPiA+ICsJICBUaGlzIG9w
dGlvbiBhbGxvd3MgdG8gZGlzYWJsZSBhbGwgZml4dXBzIHdoaWNoIGFyZQ0KPiA+ID4gPiA+IGlk
ZW50aWZpZWQgYXMNCj4gPiA+ID4gPiArCSAgcG90ZW50aWFsbHkgaGFybWZ1bCBhbmQgZ2l2ZSB0
aGUgZGV2ZWxvcGVycyBhIGNoYW5jZQ0KPiA+ID4gPiA+IHRvIGltcGxlbWVudCB0aGUNCj4gPiA+
ID4gPiArCSAgcHJvcGVyIGNvbmZpZ3VyYXRpb24gdmlhIHRoZSBkZXZpY2UgdHJlZSAoZS5nLjog
cGh5LQ0KPiA+ID4gPiA+IG1vZGUpIGFuZC9vciB0aGUNCj4gPiA+ID4gPiArCSAgcmVsYXRlZCBQ
SFkgZHJpdmVycy4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoaXMgYXBwZWFycyB0byBiZSBhbiBJTVgg
b25seSBwcm9ibGVtLiBFdmVyeWJvZHkgZWxzZSBzZWVtcyB0bw0KPiA+ID4gPiBvZiBnb3QNCj4g
PiA+ID4gdGhpcyByaWdodC4gVGhlcmUgaXMgbm8gbmVlZCB0byBib3RoZXIgZXZlcnlib2R5IHdp
dGggdGhpcyBuZXcNCj4gPiA+ID4gb3B0aW9uLiBQbGVhc2UgcHV0IHRoaXMgaW4gYXJjaC9hcm0v
bWFjaC1teHMvS2NvbmZpZyBhbmQgaGF2ZQ0KPiA+ID4gPiBJTVggaW4NCj4gPiA+ID4gdGhlIG5h
bWUuDQo+ID4gPiANCj4gPiA+IEFjdHVhbGx5LCBhbGwgZml4dXBzIHNlZW1zIHRvIGRvIHdyaW5n
IHRoaW5nOg0KPiA+ID4gYXJjaC9hcm0vbWFjaC1kYXZpbmNpL2JvYXJkLWRtNjQ0eC1ldm0uYzo5
MTU6CQlwaHlfcmVnaQ0KPiA+ID4gc3Rlcl9maXh1cF9mb3JfdWlkKExYVDk3MV9QSFlfSUQsIExY
VDk3MV9QSFlfTUFTSywNCj4gPiA+IA0KPiA+ID4gSW5jcmVhc2VkIE1JSSBkcml2ZSBzdHJlbmd0
aC4gU2hvdWxkIGJlIHByb2JhYmx5IGVuYWJsZWQgYnkgdGhlDQo+ID4gPiBQSFkNCj4gPiA+IGRy
aXZlci4NCj4gPiA+IA0KPiA+ID4gYXJjaC9hcm0vbWFjaC1pbXgvbWFjaC1pbXg2cS5jOjE2NzoJ
CXBoeV9yZWdpc3Rlcl9maXgNCj4gPiA+IHVwX2Zvcl91aWQoUEhZX0lEX0tTWjkwMjEsIE1JQ1JF
TF9QSFlfSURfTUFTSywNCj4gPiA+IGFyY2gvYXJtL21hY2gtaW14L21hY2gtaW14NnEuYzoxNjk6
CQlwaHlfcmVnaXN0ZXJfZml4DQo+ID4gPiB1cF9mb3JfdWlkKFBIWV9JRF9LU1o5MDMxLCBNSUNS
RUxfUEhZX0lEX01BU0ssDQo+ID4gPiBhcmNoL2FybS9tYWNoLWlteC9tYWNoLWlteDZxLmM6MTcx
OgkJcGh5X3JlZ2lzdGVyX2ZpeA0KPiA+ID4gdXBfZm9yX3VpZChQSFlfSURfQVI4MDMxLCAweGZm
ZmZmZmVmLA0KPiA+ID4gYXJjaC9hcm0vbWFjaC1pbXgvbWFjaC1pbXg2cS5jOjE3MzoJCXBoeV9y
ZWdpc3Rlcl9maXgNCj4gPiA+IHVwX2Zvcl91aWQoUEhZX0lEX0FSODAzNSwgMHhmZmZmZmZlZiwN
Cj4gDQo+IEFzIGZhciBhcyBJJ20gY29uY2VybmVkLCB0aGUgQVI4MDM1IGZpeHVwIGlzIHRoZXJl
IHdpdGggZ29vZCByZWFzb24uDQo+IEl0J3Mgbm90IGp1c3QgInJhbmRvbSIgYnV0IGlzIHJlcXVp
cmVkIHRvIG1ha2UgdGhlIEFSODAzNSB1c2FibGUgd2l0aA0KPiB0aGUgaU1YNiBTb0NzLiAgTm90
IGJlY2F1c2Ugb2YgYSBib2FyZCBsZXZlbCB0aGluZywgYnV0IGJlY2F1c2UgaXQncw0KPiByZXF1
aXJlZCBmb3IgdGhlIEFSODAzNSB0byBiZSB1c2FibGUgd2l0aCBhbiBpTVg2IFNvQy4NCj4gDQo+
IFNvLCBoYXZpbmcgaXQgcmVnaXN0ZXJlZCBieSB0aGUgaU1YNiBTb0MgY29kZSBpcyBlbnRpcmVs
eSBsb2dpY2FsIGFuZA0KPiBjb3JyZWN0Lg0KPiANCj4gVGhhdCdzIGxpa2VseSB0cnVlIG9mIHRo
ZSBBUjgwMzEgc2l0dWF0aW9uIGFzIHdlbGwuDQo+IA0KPiBJIGNhbid0IHNwZWFrIGZvciBhbnkg
b2YgdGhlIG90aGVycy4NCg0KSSBjYW4gc3BlYWsgZm9yIHRoZSBLU1o5MDMxL0tTWjkwMjEgZm9y
IHRob3NlIFBIWXMgdGhlIGZpeHVwIGlzIHNvbGVseQ0KdG8gYWRkIHRoZSBUWEMgZGVsYXkgdGhh
dCwgYWNjb3JkaW5nIHRvIFJHTUlJIHYxLjMgc3BlYyBzaG91bGQgaGF2ZSBiZWVuDQpkb25lIGJ5
IGhhcmR3YXJlLCBhbmQgYXMgaS5NWDYgYXMgd2VsbCBhcyB0aG9zZSBQSFlzIGRvIG5vdCBoYXZl
IGENCnNwZWNpZmljIHJlZ2lzdGVyIHRvIGFkZCB0aGF0IGRlbGF5LCB0aGUgc2tldyBnZXQgc2V0
IHNvIHRoZSB0aW1pbmcgaXMNCndvcmtpbmcgc29tZWhvdyB3aXRoIHRoZSBpLk1YNiBwcm9jZXNz
b3IuDQoNCkknbSBmaW5lIHdoZW4geW91IHdhbnQgdG8gcmVtb3ZlIHRob3NlIGZpeHVwcy4gUGxl
YXNlIENDIG1lIGJlY2F1c2UNCndlJ3JlIHJlbHlpbmcgb24gdGhvc2UgYXQgdGhlIG1vbWVudC4g
SSB3b3VsZCBqdXN0IHB1dCB0aGVtIGludG8NCmRldmljZXRyZWUuDQoNClBoaWxpcHBlDQo=
