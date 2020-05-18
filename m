Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DD51D7F07
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgERQrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:47:10 -0400
Received: from mail-am6eur05on2066.outbound.protection.outlook.com ([40.107.22.66]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726958AbgERQrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:47:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BAl4cAp2Hzntd+HY3PZmIkP7K2mhgQkcOyaPen/RVXC9N8fMyYQ8MRvPiX0Ko53wpLrqw/bM5o5eT/ig34vOIrOedckWweidwpLGN9nPUy3Ixp88TySN+ptvJU8dS0J0XfB3C+ECNhWTlFKne2SxOK2+6EhP6WsvmouRG1DS/O5ucNQdzDtIAUjgZEhyU2V6tZ4mDlJ7r8FE7Fxy6eZDhm4vffbIeSf2vjiv5OU8lJm2vndAIL/R9hoKlIK1ztU9efRM1Po2oqDWRTS7MDvl76lJHPZCc1Kaq9AWnSs+8VNcqr/w59MPDza6uu1CVr9ZPJyS3+ptB2CtQkVvbMI/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xR/GGX2ifz0BmCaPRHQikPFuda1+rBPE5Ul2d28dqTo=;
 b=mRm297XNK6NRZehAG1ar8POoJGvw7ZGBFjP53fvXPwx9J9LQp0nPdH7NA6T3jyytRAzTh4QpQeRQ4B++HaYZQcdvw1YjCAoOapD0mfhvrCuXsIeI72kmHp2KkQ1l++VDM4Z6okiZPRKGXKVCJkB3xmJbtrweBNDEMFsmE26Ftd+IVx00BPt7uSjRQDar3DXyuajaCc2QySSS21M1klFiDuaYncO0ZwdR8tOdft4r6mzPBF+o5VonxALZiOEubcDXb1/6vw/EEFub/xE5Lj9v75xjJgYlsr68E/BBshNu3CkabDvM4tL8Lif12Bn1GSK0A1tkDKENFkvJ3NbDK7gvtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xR/GGX2ifz0BmCaPRHQikPFuda1+rBPE5Ul2d28dqTo=;
 b=bHWlucJV31VA+mGYH0fPqXTtCChP/EX0clBveJ44rJAL7VI2Fal7coEhOK6ZGzCGDwdgtqvW7TeyD2TC/qFPrZ68GX6Kyjp5GP7YIUB/EbB5o+gIAQA5W8rJ3R4tEob8Bgy90xcrbQ9zH1Fq58IReUvofPV82mP/G8mbMBLndno=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5150.eurprd05.prod.outlook.com (2603:10a6:803:ab::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.31; Mon, 18 May
 2020 16:47:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 16:47:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "ben@decadent.org.uk" <ben@decadent.org.uk>,
        Tariq Toukan <tariqt@mellanox.com>
CC:     "960702@bugs.debian.org" <960702@bugs.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] mlx4: Fix information leak on failure to read module
 EEPROM
Thread-Topic: [PATCH net] mlx4: Fix information leak on failure to read module
 EEPROM
Thread-Index: AQHWLG+L3L2pAOOQ9EKhsxl2nMPhD6iuDwiA
Date:   Mon, 18 May 2020 16:47:05 +0000
Message-ID: <40aaf07aa7463c0fc6ca89aab36c622bfb789ba4.camel@mellanox.com>
References: <20200517172053.GA734488@decadent.org.uk>
In-Reply-To: <20200517172053.GA734488@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: decadent.org.uk; dkim=none (message not signed)
 header.d=none;decadent.org.uk; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0d1c9a63-7bd8-41c7-2db5-08d7fb4b18d8
x-ms-traffictypediagnostic: VI1PR05MB5150:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB51503A50A0DDE65E81CED354BEB80@VI1PR05MB5150.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kO3f34mg4D81yI9D09jEvpJMFVHh1v0UdBk+VW7u1yP1L/jfHlCi//IQHVja4WXBD9XMt30fA8L6gBz0h9R5Q9Ps9Rs12eEkIDA4gBWzR3kAmkEpyMvbB2jeTOGHwp7c+9C7tfq9TwVvdxr/GRaZkdlcApM3B3XyWQCzNqGuafSFpFRk5LN+NetJKnXU22CEUBrNaNlcgjbxiCgT2mokkxc1QGFZ8zSBcA66pcTZVmKi8pP2TPkXPcWBMDmWEhoAdt2LS/qLFKVpktvLbR6tMsscE/vxAeShlWbLSaUQPj2+eMGgRO9yflHcoflQgjSwQE2Y54pRClAnqH7R6JbwFQp08kgF3B7T/cORVG+oM1cPxPup0j6Q+VVaWslKvIss9VQxLhVRX09Di6nPWyMfoqE9R8DOhlYv+eLFnlLpgt9PjffrWYy9eajV1lHZxj9ojK7pEctX1mKrQXcIh+J3/+AFrjRX8aLlSMy9wSY8Sy1bMgBqmqRB2z7WkPn0jjQODhmLuLpMSsUlDjuWInxCMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(39860400002)(396003)(136003)(91956017)(71200400001)(186003)(26005)(54906003)(2616005)(110136005)(6486002)(316002)(66476007)(966005)(478600001)(4326008)(2906002)(66946007)(36756003)(66446008)(64756008)(6512007)(66556008)(76116006)(5660300002)(86362001)(6636002)(6506007)(8936002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: wbaqEhS6HqhOCjxbBhNLFgIa9LtuPOJtBcLmhWc3z6unZfIZcyMPjBLiLRaNUmgjxykwyMH+Te8p2XcYJYjDdApTNP15HebjADVXb4Q+mv37iV1jhAAsk+eQjUfh/Q2q++0K/U0aLcJnspMDcu5oNL6GLjYHw5E5rSzNpcqY1uXje7tsJ7atCyHVS5jbj0Li7MkctK8/lo1KtXkeirnh11V+iYo+BL5Tpp0/AuBLcNXynY42k0VvuLLdCd5CACQjytsZAaOrXIN8TA4pBPShcDIn21ee5IBogBi4rUjfOKEI/s3dDmfVMKQStLGGCFkrtAXANtonmqmYtV5box2oZMDGsC4myTmdPmCOuq6HW6xA9ZlBo/+G5q3AoogWsXTKynqpetpt5JgygOCYx05v8n18g8lo6bUfW07/7ZLvHaaaj7zM86spGzJzNZYptKrbn0IAL8qA5VLP7MImrST1H62Jk2P6h5zQwH94CjsYr8k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B3DEE7612821B47961D0C96270B0F0C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d1c9a63-7bd8-41c7-2db5-08d7fb4b18d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 16:47:05.3164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6nWhORd5QSmuMRqv1hxuVEKlqktQ8lLOSEz+8a9jwblxNdGa++Uf6E/z3kYurKHfYnUois8m3hqEd25NPaJaiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5150
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTA1LTE3IGF0IDE4OjIwICswMTAwLCBCZW4gSHV0Y2hpbmdzIHdyb3RlOg0K
PiBtbHg0X2VuX2dldF9tb2R1bGVfZWVwcm9tKCkgcmV0dXJucyAwIGV2ZW4gaWYgaXQgZmFpbHMu
ICBUaGlzIHJlc3VsdHMNCj4gaW4gY29weWluZyBhbiB1bmluaXRpYWxpc2VkIChvciBwYXJ0bHkg
aW5pdGlhbGlzZWQpIGJ1ZmZlciBiYWNrIHRvDQo+IHVzZXItc3BhY2UuDQo+IA0KPiBDaGFuZ2Ug
aXQgc28gdGhhdDoNCj4gDQo+ICogSW4gdGhlIHNwZWNpYWwgY2FzZSB0aGF0IHRoZSBET00gdHVy
bnMgb3V0IG5vdCB0byBiZSByZWFkYWJsZSwgdGhlDQo+ICAgcmVtYWluaW5nIHBhcnQgb2YgdGhl
IGJ1ZmZlciBpcyBjbGVhcmVkLiAgVGhpcyBzaG91bGQgYXZvaWQgYQ0KPiAgIHJlZ3Jlc3Npb24g
d2hlbiByZWFkaW5nIG1vZHVsZXMgd2l0aCB0aGlzIHByb2JsZW0uDQo+IA0KPiAqIEluIG90aGVy
IGVycm9yIGNhc2VzLCB0aGUgZXJyb3IgY29kZSBpcyBwcm9wYWdhdGVkLg0KPiANCj4gUmVwb3J0
ZWQtYnk6IFlhbm5pcyBBcmliYXVkIDxidWdzQGQ2YmVsbC5uZXQ+DQo+IFJlZmVyZW5jZXM6IGh0
dHBzOi8vYnVncy5kZWJpYW4ub3JnLzk2MDcwMg0KPiBGaXhlczogNzIwMmRhOGI3ZjcxICgiZXRo
dG9vbCwgbmV0L21seDRfZW46IENhYmxlIGluZm8sDQo+IGdldF9tb2R1bGVfaW5mby8uLi4iKQ0K
PiBTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hpbmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPg0KPiAt
LS0NCj4gVGhpcyBpcyBjb21waWxlLXRlc3RlZCBvbmx5LiAgSXQgc2hvdWxkIGdvIHRvIHN0YWJs
ZSwgaWYgaXQgaXMgYQ0KPiBjb3JyZWN0IGZpeC4NCj4gDQo+IEJlbi4NCj4gDQo+ICBkcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX2V0aHRvb2wuYyB8IDcgKysrKystLQ0KPiAg
MSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX2V0aHRvb2wu
Yw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDQvZW5fZXRodG9vbC5jDQo+
IGluZGV4IDhhNWVhMjU0MzY3MC4uNmVkYzMxNzdhZjFjIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX2V0aHRvb2wuYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VuX2V0aHRvb2wuYw0KPiBAQCAtMjA3OCwxNCAr
MjA3OCwxNyBAQCBzdGF0aWMgaW50IG1seDRfZW5fZ2V0X21vZHVsZV9lZXByb20oc3RydWN0DQo+
IG5ldF9kZXZpY2UgKmRldiwNCj4gIAkJcmV0ID0gbWx4NF9nZXRfbW9kdWxlX2luZm8obWRldi0+
ZGV2LCBwcml2LT5wb3J0LA0KPiAgCQkJCQkgICBvZmZzZXQsIGVlLT5sZW4gLSBpLCBkYXRhICsN
Cj4gaSk7DQo+ICANCg0KSSBhbSBub3Qgc3VyZSBpIHNlZSB0aGUgaXNzdWUgaW4gaGVyZSwgYW5k
IHdoeSB3ZSBuZWVkIHRoZSBwYXJ0aWFsDQptZW1zZXQgPw0KZmlyc3QgdGhpbmcgaW4gdGhpcyBm
dW5jdGlvbiB3ZSBkbzoNCm1lbXNldChkYXRhLCAwLCBlZS0+bGVuKTsNCg0KYW5kIHRoZW4gbWx4
NF9nZXRfbW9kdWxlX2luZm8oKSB3aWxsIG9ubHkgY29weSB2YWxpZCBkYXRhIG9ubHkgb24NCnN1
Y2Nlc3MuDQoNCg0KPiAtCQlpZiAoIXJldCkgLyogRG9uZSByZWFkaW5nICovDQo+ICsJCWlmICgh
cmV0KSB7DQo+ICsJCQkvKiBET00gd2FzIG5vdCByZWFkYWJsZSBhZnRlciBhbGwgKi8NCg0KYWN0
dWFsbHkgaWYgbWx4NF9nZXRfbW9kdWxlX2luZm8oKSAgcmV0dXJucyBhbnkgbm9uLW5lZ2F0aXZl
IHZhbHVlIGl0DQptZWFucyBob3cgbXVjaCBkYXRhIHdhcyByZWFkLCBzbyBpZiBpdCByZXR1cm5z
IDAsIGl0IG1lYW5zIHRoYXQgdGhpcw0Kd2FzIHRoZSBsYXN0IGl0ZXJhdGlvbiBhbmQgd2UgYXJl
IGRvbmUgcmVhZGluZyB0aGUgZWVwcm9tLi4gDQoNCnNvIGkgd291bGQgcmVtb3ZlIHRoZSBhYm92
ZSBjb21tZW50IGFuZCB0aGUgbWVtc2V0IGJlbG93IGlzIHJlZHVuZGFudA0Kc2luY2Ugd2UgYWxy
ZWFkeSBtZW1zZXQgdGhlIHdob2xlIGJ1ZmZlciBiZWZvcmUgdGhlIHdoaWxlIGxvb3AuDQoNCj4g
KwkJCW1lbXNldChkYXRhICsgaSwgMCwgZWUtPmxlbiAtIGkpOw0KPiAgCQkJcmV0dXJuIDA7DQo+
ICsJCX0NCj4gIA0KPiAgCQlpZiAocmV0IDwgMCkgew0KPiAgCQkJZW5fZXJyKHByaXYsDQo+ICAJ
CQkgICAgICAgIm1seDRfZ2V0X21vZHVsZV9pbmZvIGkoJWQpIG9mZnNldCglZCkNCj4gYnl0ZXNf
dG9fcmVhZCglZCkgLSBGQUlMRUQgKDB4JXgpXG4iLA0KPiAgCQkJICAgICAgIGksIG9mZnNldCwg
ZWUtPmxlbiAtIGksIHJldCk7DQo+IC0JCQlyZXR1cm4gMDsNCj4gKwkJCXJldHVybiByZXQ7DQoN
CkkgdGhpbmsgcmV0dXJuaW5nIGVycm9yIGluIGhlcmUgd2FzIHRoZSBhY3R1YWwgc29sdXRpb24g
Zm9yIHlvdXINCnByb2JsZW0uIHlvdSBjYW4gdmVyaWZ5IGJ5IGxvb2tpbmcgaW4gdGhlIGtlcm5l
bCBsb2cgYW5kIHZlcmlmeSB5b3Ugc2VlDQp0aGUgbG9nIG1lc3NhZ2UuDQoNCj4gIAkJfQ0KPiAg
DQo+ICAJCWkgKz0gcmV0Ow0K
