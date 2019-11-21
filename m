Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5502104CC1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 08:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfKUHmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 02:42:55 -0500
Received: from mail-eopbgr140059.outbound.protection.outlook.com ([40.107.14.59]:47777
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726265AbfKUHmy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 02:42:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GXh1CO8AnCIztuHOLPk2BL1efze4NPzT/mBEnnszp66aTwYTTmXpJijtTQ1LdGeyun59VIjHUIZxsAy5dOmeoPrQh/tmDNxQfkw0LCDlFS9fLNfy+QyfpKtmUBX4nD4x5vBSVEf84dJryoXm8UyNponlWZEtnxKSkXAYeTUU8/2EmQtqJg8uW4GgsIvMK8ugHmkL1qmxHZhHIVrXgYrqWVMvRHiNAA75cBcXbsRqZp3NDqYQDIzm2tu2VIScJBnvPxDHu/57QVcKozmD1Hsl5g7xaUsX41KmRFnzLq3JZot3blo4zVOJ64IHOCdplVHc6gG5GTrYoX59uiXgBzhzrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhKQYhrF/qTrkOt7jrI9J6w41tVhNcNTCpvCl33ry3o=;
 b=LF5VXWGB49n/ZgtuLJq1DNcuv68KaMh4sFR7SQXbnrXzbFrNQAwTXx59dZVRn6ccPO6e7xf3FAIn1FSe3xa7M0rV/Qt++Y59aYIPIDFeE8fqkpDQi8/3pfSNyrntBQBbxwWV96d8jKtEsYPB/fs9NrUuRj3igOMoVQOhXXnPBV6Dyu8ZMAHw7Np08zYaWY8qrgigwFW3hoiSNzk9LrzDWxy8IKcxbZNDKpG3sW9o5IGlt+YN0SuKTlaaEjHu36RV2vGKr4gSSDzw0dxuW/ymmSOWETmoPT8uLfXEGFuQVtYRFckJIsaEUJv8giazRPSRXBSoK5JMC2TfNDXuZ11r1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NhKQYhrF/qTrkOt7jrI9J6w41tVhNcNTCpvCl33ry3o=;
 b=ZQqu3mojJkP3xDv6p7hbqfMbrSwsXtdmVQELW7dXdREvUGDoum6dkhZZJHTy/Yo+B98idInImLqvMJXohlkmcnjEx0YkDrLdHQqrG+MKtKw3/Yx0rP7x5YtXcPuFIpJiN2mttRvxCoLkn85jHU4xbv2oAPjis9f5huc6DujoRgQ=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3233.eurprd05.prod.outlook.com (10.171.188.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.16; Thu, 21 Nov 2019 07:42:47 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::2cc0:1303:718d:2e9c%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 07:42:47 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>
CC:     "pablo@netfilter.org" <pablo@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mark Bloch <markb@mellanox.com>
Subject: RE: Question about flow table offload in mlx5e
Thread-Topic: Question about flow table offload in mlx5e
Thread-Index: AQHVoD2I/ci1XqDAS0+ihzjR81tg26eVO/4g
Date:   Thu, 21 Nov 2019 07:42:46 +0000
Message-ID: <AM4PR05MB3411591D31D7B22EE96BC6C3CF4E0@AM4PR05MB3411.eurprd05.prod.outlook.com>
References: <1574147331-31096-1-git-send-email-wenxu@ucloud.cn>
 <20191119.163923.660983355933809356.davem@davemloft.net>
 <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
In-Reply-To: <2a08a1aa-6aa8-c361-f825-458d234d975f@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e994ac46-6e1d-4fca-660f-08d76e566716
x-ms-traffictypediagnostic: AM4PR05MB3233:|AM4PR05MB3233:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3233AC17F841DF0D70A78F50CF4E0@AM4PR05MB3233.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39850400004)(346002)(376002)(366004)(136003)(189003)(199004)(13464003)(26005)(54906003)(478600001)(33656002)(3846002)(2906002)(71190400001)(66066001)(11346002)(71200400001)(6116002)(446003)(14454004)(25786009)(66556008)(66946007)(66476007)(64756008)(66446008)(8676002)(76116006)(81166006)(8936002)(81156014)(7736002)(229853002)(7696005)(305945005)(76176011)(86362001)(4326008)(6436002)(55016002)(102836004)(9686003)(99286004)(5660300002)(256004)(107886003)(6246003)(14444005)(6916009)(6506007)(53546011)(52536014)(186003)(316002)(74316002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3233;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nPiZo+wTwOp4i1KvnMn/0sPPJH4vzo4zrJOWQd63uOczWbTQ1oGi8nTOP1lDod47EEx19Wz6YCYdWzZvnleFtBdEnbI+ox1Cs/ImR0RvhXYKmCZDDuvf0GvP+XPbLoKuuDo0+kD8ewkFAF2FDwzG1Q5EZX+lm59fDolmAEP3mBTte355jja0N/rui3TljmNr0xAs0pWpMHr/d2QFEoPvziFKeVlvnPvJcpaJCaqmbKSpctw6OT5rzSteAQFHIodOnxtfNOGHPRil2hGFGjmSbT4nCNXyKdAkRamgmXzo310gLQH5It3cgIPkJKdvFqpE0taY+OVUVHaV2Bn8sJtDzSK3W6bPihEVJ3/WVFlNyNpqxOIBfE6fYicrF0bak0OKYZph0cxyeTafeLDfiVAYjqCqypjlQTkB36/CHOWNFxtGZFLBJu3DhOgf5ggehaMI
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e994ac46-6e1d-4fca-660f-08d76e566716
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 07:42:46.9300
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaMS6BZgW9aOYl/FU9F54UqzdyP93w0rHisDmb6eJ+4T43IiP/WOuRHGtEV6rCxbGKda5aFdH6G03kW3/pA0hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3233
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRoZSBvcmlnaW5hbCBkZXNpZ24gd2FzIHRoZSBibG9jayBzZXR1cCB0byB1c2UgVENf
U0VUVVBfRlQgdHlwZSwgYW5kIHRoZSB0YyBldmVudCB0eXBlIHRvIGJlIGNhc2UgVENfU0VUVVBf
Q0xTRkxPV0VSLg0KV2Ugd2lsbCBwb3N0IGEgcGF0Y2ggdG8gY2hhbmdlIHRoYXQuIEkgd291bGQg
YWR2aXNlIHRvIHdhaXQgdGlsbCB3ZSBmaXggdGhhdCDwn5iKDQpJJ20gbm90IHN1cmUgaG93IHlv
dSBnZXQgdG8gdGhpcyBmdW5jdGlvbiBtbHg1ZV9yZXBfc2V0dXBfZnRfY2IoKSBpZiBpdCB0aGUg
bmZfZmxvd190YWJsZV9vZmZsb2FkIG5kb19zZXR1cF90YyBldmVudCB3YXMgVENfU0VUVVBfQkxP
Q0ssIGFuZCBub3QgVENfU0VUVVBfRlQuDQoNCkluIG91ciBkcml2ZXIgZW5fcmVwLmMgd2UgaGF2
ZToNCj4tLS0tLS0tc3dpdGNoICh0eXBlKSB7DQo+LS0tLS0tLWNhc2UgVENfU0VUVVBfQkxPQ0s6
DQo+LS0tLS0tLT4tLS0tLS0tcmV0dXJuIGZsb3dfYmxvY2tfY2Jfc2V0dXBfc2ltcGxlKHR5cGVf
ZGF0YSwNCj4tLS0tLS0tPi0tLS0tLS0+LS0tLS0tLT4tLS0tLS0tPi0tLS0tLS0+LS0tLS0tLSAg
Jm1seDVlX3JlcF9ibG9ja190Y19jYl9saXN0LA0KPi0tLS0tLS0+LS0tLS0tLT4tLS0tLS0tPi0t
LS0tLS0+LS0tLS0tLT4tLS0tLS0tICBtbHg1ZV9yZXBfc2V0dXBfdGNfY2IsDQo+LS0tLS0tLT4t
LS0tLS0tPi0tLS0tLS0+LS0tLS0tLT4tLS0tLS0tPi0tLS0tLS0gIHByaXYsIHByaXYsIHRydWUp
Ow0KPi0tLS0tLS1jYXNlIFRDX1NFVFVQX0ZUOg0KPi0tLS0tLS0+LS0tLS0tLXJldHVybiBmbG93
X2Jsb2NrX2NiX3NldHVwX3NpbXBsZSh0eXBlX2RhdGEsDQo+LS0tLS0tLT4tLS0tLS0tPi0tLS0t
LS0+LS0tLS0tLT4tLS0tLS0tPi0tLS0tLS0gICZtbHg1ZV9yZXBfYmxvY2tfZnRfY2JfbGlzdCwN
Cj4tLS0tLS0tPi0tLS0tLS0+LS0tLS0tLT4tLS0tLS0tPi0tLS0tLS0+LS0tLS0tLSAgbWx4NWVf
cmVwX3NldHVwX2Z0X2NiLA0KPi0tLS0tLS0+LS0tLS0tLT4tLS0tLS0tPi0tLS0tLS0+LS0tLS0t
LT4tLS0tLS0tICBwcml2LCBwcml2LCB0cnVlKTsNCj4tLS0tLS0tZGVmYXVsdDoNCj4tLS0tLS0t
Pi0tLS0tLS1yZXR1cm4gLUVPUE5PVFNVUFA7DQo+LS0tLS0tLX0NCg0KSW4gbmZfZmxvd190YWJs
ZV9vZmZsb2FkLmM6DQo+LS0tLS0tLWJvLmJpbmRlcl90eXBlPi09IEZMT1dfQkxPQ0tfQklOREVS
X1RZUEVfQ0xTQUNUX0lOR1JFU1M7DQo+LS0tLS0tLWJvLmV4dGFjaz4tLS0tLS09ICZleHRhY2s7
DQo+LS0tLS0tLUlOSVRfTElTVF9IRUFEKCZiby5jYl9saXN0KTsNCg0KPi0tLS0tLS1lcnIgPSBk
ZXYtPm5ldGRldl9vcHMtPm5kb19zZXR1cF90YyhkZXYsIFRDX1NFVFVQX0JMT0NLLCAmYm8pOw0K
Pi0tLS0tLS1pZiAoZXJyIDwgMCkNCj4tLS0tLS0tPi0tLS0tLS1yZXR1cm4gZXJyOw0KDQo+LS0t
LS0tLXJldHVybiBuZl9mbG93X3RhYmxlX2Jsb2NrX3NldHVwKGZsb3d0YWJsZSwgJmJvLCBjbWQp
Ow0KfQ0KRVhQT1JUX1NZTUJPTF9HUEwobmZfZmxvd190YWJsZV9vZmZsb2FkX3NldHVwKTsNCg0K
DQpTbyB1bmxlc3MgeW91IGNoYW5nZWQgdGhhdCBhcyB3ZWxsLCB5b3Ugc2hvdWxkIGhhdmUgZ290
dGVuIHRvIG1seDVlX3JlcF9zZXR1cF90Y19jYiBhbmQgbm90IG1seDVlX3JlcF9zZXR1cF90Y19m
dC4NCg0KUmVnYXJkaW5nIHRoZSBlbmNhcCBhY3Rpb24sIHRoZXJlIHNob3VsZCBiZSBubyBkaWZm
ZXJlbmNlIG9uIHdoaWNoIGNoYWluIHRoZSBydWxlIGlzIG9uLg0KDQoNCj4gLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogd2VueHUgPHdlbnh1QHVjbG91ZC5jbj4NCj4gU2VudDog
VGh1cnNkYXksIE5vdmVtYmVyIDIxLCAyMDE5IDk6MzAgQU0NCj4gVG86IFBhdWwgQmxha2V5IDxw
YXVsYkBtZWxsYW5veC5jb20+DQo+IENjOiBwYWJsb0BuZXRmaWx0ZXIub3JnOyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBNYXJrIEJsb2NoDQo+IDxtYXJrYkBtZWxsYW5veC5jb20+DQo+IFN1Ympl
Y3Q6IFF1ZXN0aW9uIGFib3V0IGZsb3cgdGFibGUgb2ZmbG9hZCBpbiBtbHg1ZQ0KPiANCj4gSGnC
oCBwYXVsLA0KPiANCj4gVGhlIGZsb3cgdGFibGUgb2ZmbG9hZCBpbiB0aGUgbWx4NWUgaXMgYmFz
ZWQgb24gVENfU0VUVVBfRlQuDQo+IA0KPiANCj4gSXQgaXMgYWxtb3N0IHRoZSBzYW1lIGFzIFRD
X1NFVFVQX0JMT0NLLg0KPiANCj4gSXQganVzdCBzZXQgTUxYNV9UQ19GTEFHKEZUX09GRkxPQUQp
IGZsYWdzIGFuZCBjaGFuZ2UNCj4gY2xzX2Zsb3dlci5jb21tb24uY2hhaW5faW5kZXggPSBGREJf
RlRfQ0hBSU47DQo+IA0KPiBJbiBmb2xsb3dpbmcgY29kZXMgbGluZSAxMzgwIGFuZCAxMzkyDQo+
IA0KPiAxMzY4IHN0YXRpYyBpbnQgbWx4NWVfcmVwX3NldHVwX2Z0X2NiKGVudW0gdGNfc2V0dXBf
dHlwZSB0eXBlLCB2b2lkDQo+ICp0eXBlX2RhdGEsDQo+IDEzNjnCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdm9pZCAqY2Jf
cHJpdikNCj4gMTM3MCB7DQo+IDEzNzHCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBmbG93X2Nsc19v
ZmZsb2FkICpmID0gdHlwZV9kYXRhOw0KPiAxMzcywqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgZmxv
d19jbHNfb2ZmbG9hZCBjbHNfZmxvd2VyOw0KPiAxMzczwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qg
bWx4NWVfcHJpdiAqcHJpdiA9IGNiX3ByaXY7DQo+IDEzNzTCoMKgwqDCoMKgwqDCoMKgIHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdzsNCj4gMTM3NcKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9u
ZyBmbGFnczsNCj4gMTM3NsKgwqDCoMKgwqDCoMKgwqAgaW50IGVycjsNCj4gMTM3Nw0KPiAxMzc4
wqDCoMKgwqDCoMKgwqDCoCBmbGFncyA9IE1MWDVfVENfRkxBRyhJTkdSRVNTKSB8DQo+IDEzNznC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNTFg1X1RDX0ZMQUcoRVNXX09GRkxPQUQp
IHwNCj4gMTM4MMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE1MWDVfVENfRkxBRyhG
VF9PRkZMT0FEKTsNCj4gMTM4McKgwqDCoMKgwqDCoMKgwqAgZXN3ID0gcHJpdi0+bWRldi0+cHJp
di5lc3dpdGNoOw0KPiAxMzgyDQo+IDEzODPCoMKgwqDCoMKgwqDCoMKgIHN3aXRjaCAodHlwZSkg
ew0KPiAxMzg0wqDCoMKgwqDCoMKgwqDCoCBjYXNlIFRDX1NFVFVQX0NMU0ZMT1dFUjoNCj4gMTM4
NcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghbWx4NV9lc3dpdGNoX3ByaW9z
X3N1cHBvcnRlZChlc3cpIHx8IGYtDQo+ID5jb21tb24uY2hhaW5faW5kZXgpDQo+IDEzODbCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FT1BO
T1RTVVBQOw0KPiAxMzg3DQo+IDEzODjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAv
KiBSZS11c2UgdGMgb2ZmbG9hZCBwYXRoIGJ5IG1vdmluZyB0aGUgZnQgZmxvdyB0byB0aGUNCj4g
MTM4OcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiByZXNlcnZlZCBmdCBjaGFp
bi4NCj4gMTM5MMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8NCj4gMTM5McKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1lbWNweSgmY2xzX2Zsb3dlciwgZiwgc2l6
ZW9mKCpmKSk7DQo+IDEzOTLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY2xzX2Zsb3dl
ci5jb21tb24uY2hhaW5faW5kZXggPSBGREJfRlRfQ0hBSU47DQo+IDEzOTPCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBlcnIgPSBtbHg1ZV9yZXBfc2V0dXBfdGNfY2xzX2Zsb3dlcihw
cml2LCAmY2xzX2Zsb3dlciwgZmxhZ3MpOw0KPiAxMzk0wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgbWVtY3B5KCZmLT5zdGF0cywgJmNsc19mbG93ZXIuc3RhdHMsIHNpemVvZihmLT5z
dGF0cykpOw0KPiANCj4gDQo+IEkgd2FudCB0byBhZGQgdHVubmVsIG9mZmxvYWQgc3VwcG9ydCBp
biB0aGUgZmxvdyB0YWJsZSwgScKgIGFkZCBzb21lIHBhdGNoZXMgaW4NCj4gbmZfZmxvd190YWJs
ZV9vZmZsb2FkLg0KPiANCj4gQWxzbyBhZGQgdGhlIGluZHIgc2V0dXAgc3VwcG9ydCBpbiB0aGUg
bWx4IGRyaXZlci4gQW5kIE5vdyBJIGNhbsKgIGZsb3cgdGFibGUNCj4gb2ZmbG9hZCB3aXRoIGRl
Y2FwLg0KPiANCj4gDQo+IEJ1dCBJIG1lZXQgYSBwcm9ibGVtIHdpdGggdGhlIGVuY2FwLsKgIFRo
ZSBlbmNhcCBydWxlIGNhbiBiZSBhZGRlZCBpbg0KPiBoYXJkd2FyZcKgIHN1Y2Nlc3NmdWxseSBC
dXQgaXQgY2FuJ3QgYmUgb2ZmbG9hZGVkLg0KPiANCj4gQnV0IEkgdGhpbmsgdGhlIHJ1bGUgSSBh
ZGRlZCBpcyBjb3JyZWN0LsKgIElmIEkgbWFzayB0aGUgbGluZSAxMzkyLiBUaGUgcnVsZSBhbHNv
IGNhbg0KPiBiZSBhZGQgc3VjY2VzcyBhbmQgY2FuIGJlIG9mZmxvYWRlZC4NCj4gDQo+IFNvIHRo
ZXJlIGFyZSBzb21lIGxpbWl0IGZvciBlbmNhcCBvcGVyYXRpb24gZm9yIEZUX09GRkxPQUQgaW4N
Cj4gRkRCX0ZUX0NIQUlOPw0KPiANCj4gDQo+IEJSDQo+IA0KPiB3ZW54dQ0KPiANCg0K
