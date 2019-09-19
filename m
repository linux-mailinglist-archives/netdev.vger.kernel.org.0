Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 414C2B8260
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404625AbfISUYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:24:37 -0400
Received: from mail-eopbgr1400097.outbound.protection.outlook.com ([40.107.140.97]:9248
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404462AbfISUYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 16:24:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UdHhETTFe4pRDCUGoCS43hfAFkV8s3/fnflx6FhOtDDy0RWHOYBzRPxMA3R61BqMCnAwmoKOxGNb+ZNahc8uZ0VHO7C49TtTDF+M/Mr8qjyt1uiHBJCFcW+WVKH/gdIikeg5dAYxkPKThwFyhX/TPdqSuiFjf3n67ySMNoR9sPnW1cCRvbjOdwfS3mgz0xakDi/U0ktWubVfwduZYonPqPHxi9tgqGZEZ7FDpfblj2GKTz87JMbphjY1OtW0kAJokRgySQFowFO8JmhIHMmr74LejQSwBdO8FTLBi20wN8SMBKuvD/dapSzI4HuCJryurFMlxV+l5OAHc072TVJQHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXdz3xzIWt82e3QhHbZcyKmxJQkAAdlS183dhLIKdek=;
 b=X8qUtyzRwD20QdCEmOjz2wz1/dSV9d1lP5I1QO+Nq5sFDDe2gik09U1HgiGW3fK51VWB0/bhQbmKQpTOGvcA+1pBLkt81Jyh8UHnT7YiuBHmBWB529TgwKV5jzq2Bx32XvPpe5mfvCMEv1Llb3Wchng8tn0GBoA3P90kh4PVD0OuTxsmwZrB2YtpkNtvN4A3OyJLI0pO45B78ghNeP8jzgR/Ez0kfuKlQ/q3QR2rVLo54vevk//+6oNS3qCnKBZCDcTHjhvEXi/qkrerKbnUkl0o7VBvCnxhL1F9WGEpYuhDFWJTVuZ792zG1fHSuKdyvBubDK2SnKudYwpSJxCX+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXdz3xzIWt82e3QhHbZcyKmxJQkAAdlS183dhLIKdek=;
 b=PEuKo3sKZ6L1kkU46EfIPe1YWwY0xJCvMWoSo3ZFS+juJ5Z2MJKqpnJO6NSsqsDdSf3rR5GredKkB3H6dzAZ1cYFc/KgWxAqkyxrLLrkZDT0Dn/0JT3E846pURZKZiCLowSuJ31I2g9cYkX+hj5kpytDSqV44Exl5XmGFyy2d14=
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com (52.134.248.22) by
 OSAPR01MB1811.jpnprd01.prod.outlook.com (52.134.233.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.20; Thu, 19 Sep 2019 20:24:33 +0000
Received: from OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::b993:ed23:2838:426d]) by OSAPR01MB3025.jpnprd01.prod.outlook.com
 ([fe80::b993:ed23:2838:426d%4]) with mapi id 15.20.2284.009; Thu, 19 Sep 2019
 20:24:33 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Thread-Topic: [PATCH 2/2] ptp: Add a ptp clock driver for IDT ClockMatrix.
Thread-Index: AQHVbly/HaJPZBuyuk2OH3o5+pIhJqcx8GOAgAGDVQA=
Date:   Thu, 19 Sep 2019 20:24:33 +0000
Message-ID: <20190919202420.GA523@renesas.com>
References: <1568837198-27211-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1568837198-27211-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20190918211803.GO9591@lunn.ch>
In-Reply-To: <20190918211803.GO9591@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To OSAPR01MB3025.jpnprd01.prod.outlook.com
 (2603:1096:604:2::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bba2ea4-000b-47de-ce65-08d73d3f61b7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:OSAPR01MB1811;
x-ms-traffictypediagnostic: OSAPR01MB1811:
x-microsoft-antispam-prvs: <OSAPR01MB181188B087B20344E2F2C175D2890@OSAPR01MB1811.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(199004)(102836004)(86362001)(76176011)(26005)(446003)(11346002)(6916009)(476003)(2616005)(14454004)(6506007)(478600001)(54906003)(186003)(386003)(52116002)(25786009)(99286004)(8936002)(486006)(81156014)(81166006)(14444005)(6246003)(2906002)(66556008)(66066001)(64756008)(1076003)(6116002)(3846002)(71190400001)(71200400001)(4326008)(6512007)(316002)(305945005)(8676002)(7736002)(33656002)(66946007)(6486002)(256004)(6436002)(229853002)(66446008)(36756003)(5660300002)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:OSAPR01MB1811;H:OSAPR01MB3025.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4RGFQ7rtP6Mg1NP1mxvJAoe3wUJQ/T9bw2LEOvwwgW49LvFtSHWEd0cxsITwGAqOs3S1KI94j8dODrWb4C22Y186T8KtuhBmAJEth8xeSJ5Lg9Fhetx8vTxO5e8W0M4Rl0hYAZ4s3GGLmGraoUIz3B1xnGcSb7IFvYyJOp5fk49LYiE0S1CV8yHp6yOFw6LNzdP03ffnz+kbnYfsajRFWI2Wpud0BmK52zqRWtwbs2MDf2Hc+oLvC5+mXlBZWBtuFn4SeGVaM3oUZDeyXK7MOLGTItEblM81UFrt/WIiCy+T8nNyUWNtXYrcqXkrgPngBg21z8pIIrT6iZKhGeMZuW3EqE5QCVihpS8iqcXp5y3f50M0LBTlTjoSOwvjRG+PMjzb4+oPtceEWFplrUAmyRptiMc4rAIuBFbz+1w664A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9E69184D96F5444C9E7334F3A28A364E@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bba2ea4-000b-47de-ce65-08d73d3f61b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 20:24:33.1112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MJVOU0Uhm62LwI8xPAhUKSn3qYG3QKvHrjkm6zdvADw8SwEsQMIhhrKCE3Wk+DoFM3Gzfw4GB8hEncVegMjvX4xFU+6Flr97HIl9fp2XAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1811
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiBXZWQsIFNlcCAxOCwgMjAxOSBhdCAwNToxODowM1BNIEVEVCwgQW5k
cmV3IEx1bm4gd3JvdGU6DQo+T24gV2VkLCBTZXAgMTgsIDIwMTkgYXQgMDQ6MDY6MzhQTSAtMDQw
MCwgdmluY2VudC5jaGVuZy54aEByZW5lc2FzLmNvbSB3cm90ZToNCj4NCj4+ICtzdGF0aWMgczMy
IGlkdGNtX3hmZXIoc3RydWN0IGlkdGNtICppZHRjbSwNCj4+ICsJCSAgICAgIHU4IHJlZ2FkZHIs
DQo+PiArCQkgICAgICB1OCAqYnVmLA0KPj4gKwkJICAgICAgdTE2IGNvdW50LA0KPj4gKwkJICAg
ICAgYm9vbCB3cml0ZSkNCj4+ICt7DQo+PiArCXN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQgPSBp
ZHRjbS0+Y2xpZW50Ow0KPj4gKwlzdHJ1Y3QgaTJjX21zZyBtc2dbMl07DQo+PiArCXMzMiBjbnQ7
DQo+PiArDQo+PiArCW1zZ1swXS5hZGRyID0gY2xpZW50LT5hZGRyOw0KPj4gKwltc2dbMF0uZmxh
Z3MgPSAwOw0KPj4gKwltc2dbMF0ubGVuID0gMTsNCj4+ICsJbXNnWzBdLmJ1ZiA9ICZyZWdhZGRy
Ow0KPj4gKw0KPj4gKwltc2dbMV0uYWRkciA9IGNsaWVudC0+YWRkcjsNCj4+ICsJbXNnWzFdLmZs
YWdzID0gd3JpdGUgPyAwIDogSTJDX01fUkQ7DQo+PiArCW1zZ1sxXS5sZW4gPSBjb3VudDsNCj4+
ICsJbXNnWzFdLmJ1ZiA9IGJ1ZjsNCj4+ICsNCj4+ICsJY250ID0gaTJjX3RyYW5zZmVyKGNsaWVu
dC0+YWRhcHRlciwgbXNnLCAyKTsNCj4+ICsNCj4+ICsJaWYgKGNudCA8IDApIHsNCj4+ICsJCXBy
X2VycigiaTJjX3RyYW5zZmVyIHJldHVybmVkICVkXG4iLCBjbnQpOw0KPg0KPmRldl9lcnIoY2xp
ZW50LT5kZXYsICJpMmNfdHJhbnNmZXIgcmV0dXJuZWQgJWRcbiIsIGNudCk7DQo+DQo+V2UgdGhl
biBoYXZlIGFuIGlkZWEgd2hpY2ggZGV2aWNlIGhhcyBhIHRyYW5zZmVyIGVycm9yLg0KPg0KPlBs
ZWFzZSB0cnkgdG8gbm90IHVzZSBwcl9lcnIoKSB3aGVuIHlvdSBoYXZlIHNvbWUgc29ydCBvZiBk
ZXZpY2UuDQoNClN1cmUgdGhpbmcsIHdpbGwgcmVwbGFjZSBwcl9lcnIoKSB3aXRoIGRldl9lcnIo
KS4NCg0KPj4gK3N0YXRpYyBzMzIgaWR0Y21fc3RhdGVfbWFjaGluZV9yZXNldChzdHJ1Y3QgaWR0
Y20gKmlkdGNtKQ0KPj4gK3sNCj4+ICsJczMyIGVycjsNCj4+ICsJdTggYnl0ZSA9IFNNX1JFU0VU
X0NNRDsNCj4+ICsNCj4+ICsJZXJyID0gaWR0Y21fd3JpdGUoaWR0Y20sIFJFU0VUX0NUUkwsIFNN
X1JFU0VULCAmYnl0ZSwgc2l6ZW9mKGJ5dGUpKTsNCj4+ICsNCj4+ICsJaWYgKCFlcnIpIHsNCj4+
ICsJCS8qIGRlbGF5ICovDQo+PiArCQlzZXRfY3VycmVudF9zdGF0ZShUQVNLX0lOVEVSUlVQVElC
TEUpOw0KPj4gKwkJc2NoZWR1bGVfdGltZW91dChfbXNlY3NfdG9famlmZmllcyhQT1NUX1NNX1JF
U0VUX0RFTEFZX01TKSk7DQo+DQo+TWF5YmUgdXNlIG1zbGVlcF9pbnRlcnJ1cHRhYmxlKCk/IA0K
DQpZZXMsIHdpbGwgdHJ5IHVzaW5nIG1zbGVlcF9pbnRlcnJ1cHRhYmxlKCkgYW5kIHdpbGwgcmVw
bGFjZSBpZiBpdCB3b3Jrcy4NCg0KPj4gK3N0YXRpYyBzMzIgaWR0Y21fbG9hZF9maXJtd2FyZShz
dHJ1Y3QgaWR0Y20gKmlkdGNtLA0KPj4gKwkJCSAgICAgICBzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+
PiArew0KPj4gKwljb25zdCBzdHJ1Y3QgZmlybXdhcmUgKmZ3Ow0KPj4gKwlzdHJ1Y3QgaWR0Y21f
ZndyYyAqcmVjOw0KPj4gKwl1MzIgcmVnYWRkcjsNCj4+ICsJczMyIGVycjsNCj4+ICsJczMyIGxl
bjsNCj4+ICsJdTggdmFsOw0KPj4gKwl1OCBsb2FkZHI7DQo+PiArDQo+PiArCXByX2luZm8oInJl
cXVlc3RpbmcgZmlybXdhcmUgJyVzJ1xuIiwgRldfRklMRU5BTUUpOw0KPg0KPmRldl9kZWJ1Zygp
DQoNClRoYW5rcywgd2lsbCBtYWtlIHRoZSBjaGFuZ2UuDQoNCj4+ICsNCj4+ICsJZXJyID0gcmVx
dWVzdF9maXJtd2FyZSgmZncsIEZXX0ZJTEVOQU1FLCBkZXYpOw0KPj4gKw0KPj4gKwlpZiAoZXJy
KQ0KPj4gKwkJcmV0dXJuIGVycjsNCj4+ICsNCj4+ICsJcHJfaW5mbygiZmlybXdhcmUgc2l6ZSAl
enUgYnl0ZXNcbiIsIGZ3LT5zaXplKTsNCj4NCj5kZXZfZGVidWcoKQ0KPg0KPk1heWJlIGxvb2sg
dGhyb3VnaCBhbGwgeW91ciBwcl9pbmZvIGFuZCBkb3duZ3JhZGUgbW9zdCBvZiB0aGVtIHRvDQo+
ZGV2X2RlYnVnKCkNCg0KWWVzLCB3aWxsIGdvIHRocm91Z2ggYW5kIGRvd25ncmFkZSB0byBkZXZf
ZGVidWcoKSBhY2NvcmRpbmdseS4NCg0KVGhhbmtzLA0KVmluY2VudA0K
