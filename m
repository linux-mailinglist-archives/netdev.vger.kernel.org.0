Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1974A20E05D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389570AbgF2Upi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731574AbgF2TN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:57 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on20619.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1a::619])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782F3C08ED7F
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 23:57:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DynGssGpGiJ7oxcuhNNRkwEoaRgFJU0u93wVeIlGPJInuiLV7eJDKWDEpqv4sVyPO+JFOeZujkAQOX/q1FOG4YNwNLVIOOpw8JUonnwE/WGh8UdwENM5SJ6Zm/ErJ5yn9bzM4I+b+ofbcunSHezgWE7DtSYphp+6wXkRr5WiZ8GpmfqODe/gmc2Pc7ESPX967sXpX5E7bscrpCX4jI6xQ/1JASa3ynetQ2H0G/JwjejfN45H4OzIc2bSQGiAk9sPQ1cNBf2Iuf3CcPBpWdsIwPVnkAT8+myjQsN1AmTgfqBscgcyAg97VGOKuf+nOFWs35cJuEb3Labvpmj+T6Igtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbuRl3Zky++ZyopSHu+jiaOBtUMyKdf8pdPKyMs1pNk=;
 b=P7O4mnfrvFhxtpnvhqjX4Hv2+v/F+Wdo63JvwTedZNt38Tq9PJwI4pJnq8n2WCq9Sk1SZoA8GnDme7B6TaziCV4uIlbAlkDHapw4aTXvQDPyDT5EYj/EHcXuNbeq9cTiye/xr073hMlBm11XEf0sh4uZfv8oJ43RbFZkb8S6mBHQlXrC7mAlDlIu/acC4LqGdyvNO2ONmUMeYmVBzEnXV75/vNV84NuEVRCWFXEcIiq5zjrC0ScWHrtp11V+tFxjgQOEo3FwtVonf4IowZ9mSjce9H9MX5dftYR/tQUN0MwJmc5Oh19MwkaohejkZ1jpesF3Hkxb8cja/J7hSOwgvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbuRl3Zky++ZyopSHu+jiaOBtUMyKdf8pdPKyMs1pNk=;
 b=eIAx9S3+Ex/BbeJNSZkTdyPM5Mg9lxW80hZzm2TADhfMR3h64Wwj2+QfXjA9HAbKv4BSEa1jhu542/fNaDGD8/GLQEEcgaFaPasgrt2ZwSk4RWDW7G+sEaOjuFzvmfkyr1Rj6c9yAGBmFj2OT04vbDD5JRM4ZTuDWmyoNsq1xC8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5533.eurprd05.prod.outlook.com (2603:10a6:803:96::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Mon, 29 Jun
 2020 06:57:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Mon, 29 Jun 2020
 06:57:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tom@herbertland.com" <tom@herbertland.com>
CC:     Boris Pismenny <borisp@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 04/15] net/mlx5e: Receive flow steering framework for
 accelerated TCP flows
Thread-Topic: [net-next 04/15] net/mlx5e: Receive flow steering framework for
 accelerated TCP flows
Thread-Index: AQHWTMiJt4V07rqGgkerTmfLrT/Xf6jtDM2AgAIepYA=
Date:   Mon, 29 Jun 2020 06:57:11 +0000
Message-ID: <90af87c36100323d8a28c70c0223c865a2bab266.camel@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
         <20200627211727.259569-5-saeedm@mellanox.com>
         <CALx6S37gn4mQx97xXUPpjW4Fm9NxOwfagunhygHrvaGS5Uxs4w@mail.gmail.com>
In-Reply-To: <CALx6S37gn4mQx97xXUPpjW4Fm9NxOwfagunhygHrvaGS5Uxs4w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: herbertland.com; dkim=none (message not signed)
 header.d=none;herbertland.com; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b50da900-9453-4ae0-6802-08d81bf9a600
x-ms-traffictypediagnostic: VI1PR05MB5533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5533918B17160F0D1665DC11BE6E0@VI1PR05MB5533.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ctiKIGlUBUluyt2r3iSEuobQ0DyFOqPgVVhuuM+oiRhmVfK5cxLOBUmDd0G38N3qpU8JMXz4KCy6ykj4j4taGfKcEPQj3B863O9XtuihBLWTCBRm321GsaLot6AK0IXjbZvqMr9Wp+ddNfhRx/Xn6ezQFbLa7tfmS78WmCOiapKFkNBLYD5ltL+Mvrc0FamnXnGw3V5jlhNHSv4xdQF9GDjGYhjfwdkgwkbck0p8jFmWZKAYqECq64/A7sNukGTgTRgwj2dJd9JqKPVPSG+OJ6SoVkNy/+I653Va/OUg5O3UA4KTHLkSeJ1xrf41qE0DQZpLUD44LdVadjDewjPZuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(6512007)(4326008)(36756003)(5660300002)(76116006)(91956017)(66946007)(71200400001)(66446008)(64756008)(66556008)(66476007)(316002)(6916009)(53546011)(6506007)(186003)(6486002)(86362001)(478600001)(54906003)(8936002)(8676002)(2906002)(26005)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0Ru7Kg6g6yKcY6meHv1EeWu02nVdx6KPqiyJJqVk/zrHllsHyb2Fq/apC3KsUKX6EmpIfupEZQQxcbL35HU9LBJe+rvNawNeZswWgfgH+nKm/RnvL4PVdiL3kNbRKm3zts4MvzXmdkEvbVMjF6CScg87ZjKPrWgP3MzXjB+QQMcibzMgZkM2r3HHP8TXrJDWha8WZC5RmnZrr8qQuvoak1jchXd0tJgWBIwLarS9Ax8zP6YrDgiuNIH8kiKSOQAkNIh5CrPwNKCq7SItgg6HLAseQlZSpJxsh7MgyJ/WnnRZv9nlLC+nvAn9hao2+ukk+tuKGSx/GZpIQQs9JUbaTR+KILu8NXLtBWWn+XNVmT0v7xqY1zKrRywYOK3ay0J68QZGkMBOI8lnPk1FWL15QujQNUEvcXPVQDR77LdEs2k0EHGjArshxqSsXzbfXkhHa6XoCW9fdJSfTWvHY+YQzlK6/hXGm320QK2IgyUD+N4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F70A46F215A5734BA193908F4AAB84E3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b50da900-9453-4ae0-6802-08d81bf9a600
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 06:57:11.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Vj73Bwb9KIBYJNls4ln4sRw8zivPCFyi//Xh5NsoC2DuVwwTmR9OzRm2/xnEott+FQsRSwmPGfQL1lHUh8rdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTA2LTI3IGF0IDE1OjM0IC0wNzAwLCBUb20gSGVyYmVydCB3cm90ZToNCj4g
T24gU2F0LCBKdW4gMjcsIDIwMjAgYXQgMjoxOSBQTSBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1l
bGxhbm94LmNvbT4NCj4gd3JvdGU6DQo+ID4gRnJvbTogQm9yaXMgUGlzbWVubnkgPGJvcmlzcEBt
ZWxsYW5veC5jb20+DQo+ID4gDQo+ID4gVGhlIGZyYW1ld29yayBhbGxvd3MgY3JlYXRpbmcgZmxv
dyB0YWJsZXMgdG8gc3RlZXIgaW5jb21pbmcgdHJhZmZpYw0KPiA+IG9mDQo+ID4gVENQIHNvY2tl
dHMgdG8gdGhlIGFjY2VsZXJhdGlvbiBUSVJzLg0KPiA+IFRoaXMgaXMgdXNlZCBpbiBkb3duc3Ry
ZWFtIHBhdGNoZXMgZm9yIFRMUywgYW5kIHdpbGwgYmUgdXNlZCBpbiB0aGUNCj4gPiBmdXR1cmUg
Zm9yIG90aGVyIG9mZmxvYWRzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEJvcmlzIFBpc21l
bm55IDxib3Jpc3BAbWVsbGFub3guY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRhcmlxIFRvdWth
biA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYWVlZCBNYWhhbWVl
ZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvTWFrZWZpbGUgIHwgICAyICstDQo+ID4gIC4uLi9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL2ZzLmggICB8ICAxMCArDQo+ID4gIC4uLi9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fYWNjZWwvZnNfdGNwLmMgICAgICB8IDI4MA0KPiA+ICsrKysrKysrKysr
KysrKysrKw0KPiA+ICAuLi4vbWVsbGFub3gvbWx4NS9jb3JlL2VuX2FjY2VsL2ZzX3RjcC5oICAg
ICAgfCAgMTggKysNCj4gPiAgLi4uL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZnNf
Y29yZS5jIHwgICA0ICstDQo+IA0KPiBTYWVlZCwNCj4gDQo+IFdoYXQgaXMgdGhlIHJlbGF0aW9u
c2hpcCBiZXR3ZWVuIHRoaXMgYW5kIFJGUywgYWNjZWxlcmF0ZWQgUkZTLCBhbmQNCj4gbm93IFBU
UT8gSXMgdGhpcyBzb21ldGhpbmcgdGhhdCB3ZSBjYW4gZ2VuZXJhbGl6ZSBpbiB0aGUgc3RhY2sg
YW5kDQoNCkhpIFRvbSwNCg0KVGhpcyBpcyB2ZXJ5IHNpbWlsYXIgdG8gb3VyIGludGVybmFsIGFS
RlMgSFcgdGFibGVzIGltcGxlbWVudGF0aW9uIGJ1dA0KaXMgb25seSBtZWFudCBmb3IgVENQIHN0
YXRlLWZ1bGwgYWNjZWxlcmF0aW9uIGZpbHRlcmluZyBhbmQgcHJvY2Vzc2luZywNCm1haW5seSBm
b3IgVExTIGVjcnlwdC9kZWNyeXB0IGluIGRvd25zdHJlYW0gcGF0Y2hlcyBhbmQgbnZtZSBhY2Nl
bCBpbiBhDQpmdXR1cmUgc3VibWlzc2lvbi4NCg0Kd2hhdCB0aGlzIG1seDUgZnJhbWV3b3JrIGRv
ZXMgZm9yIG5vdyBpcyBhZGQgYSBUQ1Agc3RlZXJpbmcgZmlsdGVyIGluDQp0aGUgSFcgYW5kIGF0
dGFjaCBhbiBhY3Rpb24gdG8gaXQgIChmb3Igbm93IFJYIFRMUyBkZWNyeXB0KSBhbmQgdGhlbg0K
Zm9yd2FyZCB0byByZWd1bGFyIFJTUyByeCBxdWV1ZS4gc2ltaWxhciB0byBhUkZTIHdoZXJlIHdl
IGFkZCA1IHR1cGxlDQpmaWx0ZXIgaW4gdGhlIEhXIGFuZCB0aGUgYWN0aW9uIHdpbGwgYmUgZm9y
d2FyZCB0byBzcGVjaWZpYyBDUFUgUlgNCnF1ZXVlIGluc3RlYWQgb2YgdGhlIGRlZmF1bHQgUlNT
IHRhYmxlLg0KDQpGb3IgUFRRIGkgYW0gbm90IHJlYWxseSBzdXJlLCBzaW5jZSBpIGZlbHQgYSBi
aXQgY29uZnVzZWQgd2hlbiBJIHJlYWQNCnRoZSBkb2MgYW5kIGkgY291bGRuJ3QgcmVhbGx5IHNl
ZSBob3cgUFRRIGNyZWF0ZXMvYXNrcyBmb3IgZGVkaWNhdGVkDQpod2FyZHdhcmUgcXVldWVzL2Zp
bHRlcnMsIGkgd2lsbCB0cnkgdG8gZ28gdGhyb3VnaCB0aGUgcGF0Y2hlcw0KdG9tb3Jyb3cuIA0K
DQo+IHN1cHBvcnQgaW4gdGhlIGRyaXZlci9kZXZpY2Ugd2l0aCBhIHNpbXBsZSBpbnRlcmZhY2Ug
bGlrZSB3ZSBkbyB3aXRoDQo+IGFSRlMgYW5kIG5kb19yeF9mbG93X3N0ZWVyPw0KPiANCg0KQ3Vy
cmVudGx5IGp1c3QgbGlrZSB0aGUgYVJGUyBIVyB0YWJsZXMgd2hpY2ggYXJlIHByb2dyYW1tZWQg
dmlhDQpuZG9fcnhfZmxvd19zdGVlciB0aGlzIFRDUCBGbG93IHRhYmxlIGlzIHByb2dyYW1tZWQg
dmlhIA0KbmV0ZGV2LT50bHNkZXZfb3BzLT50bHNfZGV2X2FkZC9kZWwoKSwgZm9yIFRMUyBzb2Nr
ZXRzIHRvIGJlIG9mZmxvYWRlZA0KdG8gSFcuDQoNCmFzIGltcGxlbWVudGVkIGluOg0KW25ldC1u
ZXh0IDA4LzE1XSBuZXQvbWx4NWU6IGtUTFMsIEFkZCBrVExTIFJYIEhXIG9mZmxvYWQgc3VwcG9y
dA0KDQpCdXQgeWVzIHRoZSBIVyBmaWx0ZXIgaXMgaXMgYWx3YXlzIHNpbWlsYXIsIG9ubHkgdGhl
IGFjdGlvbnMgYXJlDQpkaWZmZXJlbnQgKGVuY3J5cHQgb3IgRm9yd2FyZCB0byBzcGVjaWZpYyBD
UFUpLCANCg0KU28gbWF5YmUgYSB1bmlmaWVkIGdlbmVyaWMgbmRvIGNhbiB3b3JrIGZvciBUTFMs
IGFSRlMsIFBUUSwgWFNLLA0KaW50ZWwncyBBRFEsIGFuZCBtYXliZSBtb3JlLiBBbHNvIG1ha2Ug
aXQgZWFzaWVyIHRvIGludHJvZHVjZSBtb3JlIGZsb3cNCmJhc2VkIG9mZmxvYWRzIChmbG93cyB0
aGF0IGRvIG5vdCBiZWxvbmcgdG8gdGhlIFRDIGxheWVyKSBzdWNoIGFzIG52bWUNCnplcm8gY29w
eS4NCg0KVGhlcmUgd2VyZSBsb3RzIG9mIHRhbGtzIGFuZCBkaXNjdXNzaW9ucyBieSBNYWdudXMs
IEplc3BlciwgQmpvcm4sDQpNYXhpbSBhbmQgbWFueSBvdGhlcnMgdG8gaW1wcm92ZSBuZXRkZXYg
cXVldWUgbWFuYWdlbWVudCBhbmQgbWFrZQ0KbmV0d29ya2luZyBxdWV1ZXMgYSAiZmlyc3QgY2xh
c3Mga2VybmVsIGNpdGl6ZW4iIEkgYmVsaWV2ZSBmbG93IGJhc2VkDQpmaWx0ZXJzIHNob3VsZCBi
ZSBwYXJ0IG9mIHRoYXQgZWZmb3J0LCBhbmQgaSB0aGluayB5b3UgYWxyZWFkeSBhZGRyZXNzDQpz
b21lIG9mIHRoaXMgaW4geW91ciBQVFEgc2VyaWVzLg0KDQotIFNhZWVkLg0KDQo=
