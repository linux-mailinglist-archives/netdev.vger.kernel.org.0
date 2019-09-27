Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB95C0713
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 16:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfI0OMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 10:12:36 -0400
Received: from mail-eopbgr1400120.outbound.protection.outlook.com ([40.107.140.120]:33728
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726540AbfI0OMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 10:12:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOerX3gxgZ+394dazaX7vOhTFaN8oI6rOrgjEGYw+Q+vs+MbcgI17wcg6pw+AKD8TPO9RD5UFiJSqVGKnZMvZoNjnEYj53GQmamL2nU5DsaRXMVVhGmGHxOkrd23jTJTsKfTyU4Iw7uajYfycz8ASv8/8Xmfs/hgW14laW7y0LLM1MnAc5o4xeDfSf3aPEjnfv3sy8jV6hWqIwkTJWPKw/LjyZch6ET3aw9fTLsnWmdCXjYVogCSgKIIqojmFG5allnpq45kaCW5hzXXbTncmOj00I80madBTnovXPw0BXN4mD0QqRZ8gT5TQM9cest3tebUyAK6iIx7wSFhZui1Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nggTYu3GDTe2Rfniv1IYQtfowb6huEM6XtQpaAxdoIY=;
 b=k6yDWUcwY+iELrD4e80AmFP8sBjh8UGrpGHsRqqMjRY5NfMPj5zlt9lCCHI38oS2XjHdgfGYuFke1vwROnbDx8tZk4JZoEoNN6aNSm8ciMqMCDoTVd0hOJZURoVtxgcC3q/99Wzq+/q9ZE10sBJPcATwl45LfxfevEg0xcWU0PjC7koEAQRC8izU7+rGN2M4WCQfEBPhpaTJe3HfONFx9Tdc5t5FvRl+4Az7G/6PIlAlzt/+Goqz+rI7ALF0CbaiQOlozYh70XZw+8bMCjCYuBjsEKxhOm0a94hg4L1sQ+09G4jRwlzdz9FAUHl84uhOSHNa2q3PFNVtLeR8JQ2zQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nggTYu3GDTe2Rfniv1IYQtfowb6huEM6XtQpaAxdoIY=;
 b=UEhz/weCBnafwXAbLTrAf2uA1qtKVyK99EXv2mGaC1HMukrRn6WX1pgpmfXtPu3gzvw/1o8fIux9Tr71N2bJ1iriZI3aA4cC8nucgQ5rzhujZf/nmdyRwgnapq6mTybKPdarSNVN8ibvDtja4Z0l2hG/kKeJJYRwAzvdlqJNLbc=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB4804.jpnprd01.prod.outlook.com (20.179.178.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Fri, 27 Sep 2019 14:12:30 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::b993:ed23:2838:426d]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::b993:ed23:2838:426d%4]) with mapi id 15.20.2284.028; Fri, 27 Sep 2019
 14:12:30 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Thread-Topic: [PATCH v2 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Thread-Index: AQHVdOaUGQW79lTjH0S8HdFcGJicBKc/c3EAgAAd5IA=
Date:   Fri, 27 Sep 2019 14:12:30 +0000
Message-ID: <20190927141215.GA24424@renesas.com>
References: <1569556128-22212-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1569556128-22212-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20190927122518.GA25474@lunn.ch>
In-Reply-To: <20190927122518.GA25474@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::25) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 589f8e70-dce1-473e-2dc7-08d74354bb89
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: OSAPR01MB4804:
x-microsoft-antispam-prvs: <OSAPR01MB4804A9E3BDC3B03A5B45A0CBD2810@OSAPR01MB4804.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(199004)(189003)(99286004)(76176011)(6486002)(81156014)(8676002)(81166006)(229853002)(33656002)(8936002)(25786009)(6512007)(64756008)(66446008)(6246003)(5660300002)(14454004)(478600001)(66556008)(4326008)(2906002)(1076003)(66946007)(66476007)(86362001)(2616005)(11346002)(486006)(476003)(386003)(6506007)(102836004)(7736002)(6436002)(3846002)(305945005)(6916009)(446003)(54906003)(26005)(66066001)(316002)(52116002)(71190400001)(256004)(71200400001)(36756003)(186003)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB4804;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bwyqspw9FyXoOKKIJo5FyPn7jmeGKBjmvtzo3zFpWfpOsk1t6AbvdWymp8Mp/OAZqw6hlIe1tKB770xvHgbI8YNsZQZRElV9BzpEfH027F2ZwX73KznIsvQ+mydJx6E7geSocig7qSLbwNHI5AxELqxmQO1LkrFiR3qSFwFj5245zXMSNAIR/wfG+ibu2cqBStp1KLgzvsqUCokw6CmzDChtFF0dCerXHCorlVlTX/GBcwmP1R+mgSx9SDF/MgVn0VEQ/x6Ds/FDD1leGE4mBAFJfUj87BCgm7K+LbqgXBxFXcI7pzk5R835FN72Daz3UC+IRi+3OyDlaNujM01RwwIsbeweTMv7eGm6rJ4Yo7eQ8k2402ffEBOQN9+btBAaxiwMbUr1KsHKMKmm+iH+Ht9y+ASKQ4SYlkj0coQw3dY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E637F3650C0904CA0867BC8DA56FB57@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 589f8e70-dce1-473e-2dc7-08d74354bb89
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 14:12:30.1486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qIu7eIO/oumB1vZe1fygRtBRXuIhj12CyenV4lrjT/+btemBY2B1pkMKJBl4DBFvZjYxTK4B1i8UeC7Rlx2ipWbsXIxRENBvrmSlGMXrw5c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBTZXAgMjcsIDIwMTkgYXQgMDg6MjU6MThBTSBFRFQsIEFuZHJldyBMdW5uIHdyb3Rl
Og0KPj4gK3N0YXRpYyBzMzIgaWR0Y21feGZlcihzdHJ1Y3QgaWR0Y20gKmlkdGNtLA0KPj4gKwkJ
ICAgICAgdTggcmVnYWRkciwNCj4+ICsJCSAgICAgIHU4ICpidWYsDQo+PiArCQkgICAgICB1MTYg
Y291bnQsDQo+PiArCQkgICAgICBib29sIHdyaXRlKQ0KPj4gK3sNCj4+ICsJc3RydWN0IGkyY19j
bGllbnQgKmNsaWVudCA9IGlkdGNtLT5jbGllbnQ7DQo+PiArCXN0cnVjdCBpMmNfbXNnIG1zZ1sy
XTsNCj4+ICsJczMyIGNudDsNCj4+ICsNCj4+ICsJbXNnWzBdLmFkZHIgPSBjbGllbnQtPmFkZHI7
DQo+PiArCW1zZ1swXS5mbGFncyA9IDA7DQo+PiArCW1zZ1swXS5sZW4gPSAxOw0KPj4gKwltc2db
MF0uYnVmID0gJnJlZ2FkZHI7DQo+PiArDQo+PiArCW1zZ1sxXS5hZGRyID0gY2xpZW50LT5hZGRy
Ow0KPj4gKwltc2dbMV0uZmxhZ3MgPSB3cml0ZSA/IDAgOiBJMkNfTV9SRDsNCj4+ICsJbXNnWzFd
LmxlbiA9IGNvdW50Ow0KPj4gKwltc2dbMV0uYnVmID0gYnVmOw0KPj4gKw0KPj4gKwljbnQgPSBp
MmNfdHJhbnNmZXIoY2xpZW50LT5hZGFwdGVyLCBtc2csIDIpOw0KPj4gKw0KPj4gKwlpZiAoY250
IDwgMCkgew0KPj4gKwkJZGV2X2VycigmY2xpZW50LT5kZXYsICJpMmNfdHJhbnNmZXIgcmV0dXJu
ZWQgJWRcbiIsIGNudCk7DQo+PiArCQlyZXR1cm4gY250Ow0KPj4gKwl9IGVsc2UgaWYgKGNudCAh
PSAyKSB7DQo+PiArCQlkZXZfZXJyKCZjbGllbnQtPmRldiwNCj4+ICsJCQkiaTJjX3RyYW5zZmVy
IHNlbnQgb25seSAlZCBvZiAlZCBtZXNzYWdlc1xuIiwgY250LCAyKTsNCj4+ICsJCXJldHVybiAt
RUlPOw0KPj4gKwl9DQo+PiArDQo+PiArCXJldHVybiAwOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0
aWMgczMyIGlkdGNtX3BhZ2Vfb2Zmc2V0KHN0cnVjdCBpZHRjbSAqaWR0Y20sIHU4IHZhbCkNCj4+
ICt7DQo+PiArCXU4IGJ1Zls0XTsNCj4+ICsJczMyIGVycjsNCj4NCj5IaSBWaW5jZW50DQoNCkhp
IEFuZHJldywNCg0KVGhhbmsteW91IGZvciBsb29raW5nIGF0IHRoZSBwYXRjaC4NCg0KPkFsbCB5
b3VyIGZ1bmN0aW9ucyByZXR1cm4gczMyLCByYXRoZXIgdGhhbiB0aGUgdXN1YWwgaW50LiBlcnIg
aXMgYW4NCj5zMzIuICBpMmNfdHJhbnNmZXIoKSB3aWxsIHJldHVybiBhbiBpbnQsIHdoaWNoIHlv
dSB0aGVuIGFzc2lnbiB0byBhbg0KPnMzMi4gIEkndmUgbm8gaWRlYSwgYnV0IG1heWJlIHRoZSBz
dGF0aWMgY29kZSBjaGVja2VycyBsaWtlIHNtYXRjaA0KPndpbGwgY29tcGxhaW4gYWJvdXQgdGhp
cywgZXNwZWNpYWxseSBvbiA2NCBiaXQgc3lzdGVtcz8gSSBzdXNwZWN0IG9uDQo+NjQgYml0IG1h
Y2hpbmVzLCB0aGUgY29tcGlsZXIgd2lsbCBiZSBnZW5lcmF0aW5nIHdvcnNlIGNvZGUsIG1hc2tp
bmcNCj5yZWdpc3RlcnM/IE1heWJlIHVzZSBpbnQsIG5vdCBzMzI/DQoNCk9vcHMuICBZb3UgYXJl
IGNvcnJlY3QsIEkgbWVzc2VkIHVwIHdoZW4gdHJ5aW5nIHRvIHN0YW5kYXJkaXplDQpvbiBsaW51
eCB0eXBlcy5oLiAgSSB3aWxsIGdvIHRocm91Z2ggdGhlIGNvZGUgdG8gZW5zdXJlIGludCBpcyB1
c2VkDQpmb3IgZXJyb3IgY29kZXMgYW5kIHJldHVybiB2YWx1ZXMuDQoNCj4+ICsJY2FzZSBPVVRQ
VVRfTUFTS19QTEwyX0FERFIgKyAxOg0KPj4gKwkJU0VUX1UxNl9NU0IoaWR0Y20tPmNoYW5uZWxb
Ml0ub3V0cHV0X21hc2ssIHZhbCk7DQo+PiArCQlicmVhazsNCj4+ICsJY2FzZSBPVVRQVVRfTUFT
S19QTEwzX0FERFI6DQo+PiArCQlTRVRfVTE2X0xTQihpZHRjbS0+Y2hhbm5lbFszXS5vdXRwdXRf
bWFzaywgdmFsKTsNCj4+ICsJCWJyZWFrOw0KPj4gKwljYXNlIE9VVFBVVF9NQVNLX1BMTDNfQURE
UiArIDE6DQo+PiArCQlTRVRfVTE2X01TQihpZHRjbS0+Y2hhbm5lbFszXS5vdXRwdXRfbWFzaywg
dmFsKTsNCj4+ICsJCWJyZWFrOw0KPj4gKwlkZWZhdWx0Og0KPj4gKwkJZXJyID0gLTE7DQo+DQo+
RUlOVkFMPw0KDQpZZXMsIHdpbGwgcmVwbGFjZSB3aXRoIC1FSU5WQUwuICBUaGFua3MuDQoNCj4+
ICtzdGF0aWMgdm9pZCBzZXRfZGVmYXVsdF9mdW5jdGlvbl9wb2ludGVycyhzdHJ1Y3QgaWR0Y20g
KmlkdGNtKQ0KPj4gK3sNCj4+ICsJaWR0Y20tPl9pZHRjbV9nZXR0aW1lID0gX2lkdGNtX2dldHRp
bWU7DQo+PiArCWlkdGNtLT5faWR0Y21fc2V0dGltZSA9IF9pZHRjbV9zZXR0aW1lOw0KPj4gKwlp
ZHRjbS0+X2lkdGNtX3Jkd3IgPSBpZHRjbV9yZHdyOw0KPj4gKwlpZHRjbS0+X3N5bmNfcGxsX291
dHB1dCA9IHN5bmNfcGxsX291dHB1dDsNCj4+ICt9DQo+DQo+V2h5IGRvZXMgdGhpcyBpbmRpcmVj
dGlvbj8gQXJlIHRoZSBTUEkgdmVyc2lvbnMgb2YgdGhlIHNpbGljb24/DQoNClRoZSBpbmRpcmVj
dGlvbiBpcyB0byBlbmFibGUgdXMgdG8gcmVwbGFjZSB0aG9zZSBmdW5jdGlvbnMgaW4NCm91ciB1
bml0IHRlc3RzIHdpdGggbW9ja2VkIGZ1bmN0aW9ucy4NCg0KSSByZWFkIHNvbWV3aGVyZSB0aGF0
IEkgc2hvdWxkIGxlYXZlIGEgd2VlayBiZXR3ZWVuIHNlbmRpbmcgYQ0KcmV2aXNlZCBwYXRjaCBz
ZXJpZXMuICBJcyB0aGlzIGEgZ29vZCBydWxlIHRvIGZvbGxvdz8NCg0KUmVnYXJkcywNClZpbmNl
bnQNCg==
