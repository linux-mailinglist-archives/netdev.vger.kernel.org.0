Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EAA11C594
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 06:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLLFpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 00:45:24 -0500
Received: from mail-mw2nam12on2087.outbound.protection.outlook.com ([40.107.244.87]:55104
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbfLLFpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 00:45:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls3BWT2JZiMF1quQjuW2S15TCuOw5zaqfW9UMp5+cvzya7BxjfU74GoDqUL2DJTrnAx+fjLKdAbomdSn5Fx/m72igko0+A/n6ztqQNoegncHpDvr54Bd5WoF6QGRO2HpikosAsGNl8e3jCV0krI3R8vQLtB8fLJLO89Ib3nhXswYhv1dsgFYjiXKAuOfyeNU9A8f/QYo6ppB+wglcOl74xMwbuROdoXVo2FeLPbLXJ4z0S/buRnbAb7e5n5R5Z2nnJ/2xBeipiGCpyhbtd5SrqdZZWlwKn+XQm//eEYGhTzDHN2vpgUB4a1/Pv1dXh02mEebwBDVbjgDcl4yYTKBfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6a0Tis2G2v9de9CINqeKkPu/zvCMbwC7NJdlkWUaG8=;
 b=eV/aKQy4/0wP1xhcE3sGrnKPyha8bqv+fqEb55YD+2oP7SpNie+Q0h7LIYWrdbKtolJGrdVMS0zqPWfi3GAOt/+hIYVyDliMx1wH+wsw89BX+70M3ZxvbYUgJoYDgiyS/6o3gQCsByqVntW6BQ40neFF25Q2QLZciZy6LDgEJAvZJOpWKaTW+YRSDMaVPa8QwewQknXecSUh0lm6O20Hoa0uQKsfAE6BLFuhJG6VfSLiMmSBY+AU1ixphIvL6TWlJjLv/S/WYEc3lP402kWKi3jkiO2SS0GYgna6V0AiimJ6dbjqTjFs7ckJvUzlIDEm122+PsABBG6UknZFMCOaOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6a0Tis2G2v9de9CINqeKkPu/zvCMbwC7NJdlkWUaG8=;
 b=mmvLvDM8nAWVILtSfZh238d9XxZzfllSCu8k/lQ5MW7kKE7HUBGytftme1HhcwrJZRf/JCvgXkw4e9v9YUPPflLhCcqef4M11Ns83aYDbpfBMD7sQTsqrLOUU7467sJMicpJI9Y+w5YaYdCM/mtUHieDF1wU6KX4RPEG8VGoCQk=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6245.namprd02.prod.outlook.com (52.132.230.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.14; Thu, 12 Dec 2019 05:45:20 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::5d66:1c32:4c41:b087%3]) with mapi id 15.20.2516.018; Thu, 12 Dec 2019
 05:45:20 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Brendan Higgins <brendanhiggins@google.com>,
        "jdike@addtoit.com" <jdike@addtoit.com>,
        "richard@nod.at" <richard@nod.at>,
        "anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
CC:     "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davidgow@google.com" <davidgow@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 3/7] net: axienet: add unspecified HAS_IOMEM dependency
Thread-Topic: [PATCH v1 3/7] net: axienet: add unspecified HAS_IOMEM
 dependency
Thread-Index: AQHVsFkiqR8nSduRnUG1Mm2Zwj3HCqe1/amA
Date:   Thu, 12 Dec 2019 05:45:20 +0000
Message-ID: <CH2PR02MB7000A8C27E849A6B81251AFEC7550@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20191211192742.95699-1-brendanhiggins@google.com>
 <20191211192742.95699-4-brendanhiggins@google.com>
In-Reply-To: <20191211192742.95699-4-brendanhiggins@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c65c8d5-7781-406b-2a30-08d77ec6796f
x-ms-traffictypediagnostic: CH2PR02MB6245:|CH2PR02MB6245:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB62457B07B6E59B127FE8C450C7550@CH2PR02MB6245.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(13464003)(189003)(199004)(66946007)(76116006)(52536014)(478600001)(5660300002)(33656002)(9686003)(66476007)(26005)(2906002)(6636002)(4326008)(86362001)(186003)(66556008)(8936002)(66446008)(8676002)(316002)(7696005)(6506007)(53546011)(54906003)(71200400001)(81166006)(81156014)(64756008)(110136005)(55016002)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6245;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wbdqpDUm6dDxHM6Yvm8GkKgvuhOVZSxhUtBsfZflN18AxhVoVk7/VXD6EAKeDeS1y2Sw+dm6fuCyRblTV31iVAGsDtIUchHUw1rsd++YE0bZ5oarS/QW6M+reEpGTBcEWXC2x3Q6PuKHP8EUeRBxQGPwJQLeM2aAAeI/qKOVv91Q9JVhTTL3extGojM9HvFQFpgz02uk5sYjXDskSYGKAzaO2t42mc9Fo+dEojE6C9qBSwYnnK9yg46rN3Jieih2vOOzLOR7mM7z8CEAZz7kzuk158QLG2S+vvvJAD5AMBcxgdVW3LmQJ8mlHw2WMGEVb5Pcy7pJf3zIOuU1YU/N/C8Cjfg/UdZC1Q8QziAI/Tp0Nnp+0phMjmQQBP6wrckK+8MlQtTJxKkz+Yfd/beaH4m1cQF12wkEOCcyGNn1rUZXL3bDP/7Wyv1u39XSKKH5muzcjrpgBT8tdO02DIjB0pWaR7fqe0QXXLatNQkselBeyoSodigOO5vaBFQqroR3
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c65c8d5-7781-406b-2a30-08d77ec6796f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 05:45:20.1141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3vu+7lUBSOYsSLoPc2QJVeXj42dT7tBNwx8k4EpdsOZX7dK5n+akLfOMwqT+jG4Oi8TkJTpnrmZ5favEIMyRzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCcmVuZGFuIEhpZ2dpbnMgPGJy
ZW5kYW5oaWdnaW5zQGdvb2dsZS5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBEZWNlbWJlciAxMiwg
MjAxOSAxMjo1OCBBTQ0KPiBUbzogamRpa2VAYWRkdG9pdC5jb207IHJpY2hhcmRAbm9kLmF0Ow0K
PiBhbnRvbi5pdmFub3ZAY2FtYnJpZGdlZ3JleXMuY29tOyBEYXZpZCBTLiBNaWxsZXINCj4gPGRh
dmVtQGRhdmVtbG9mdC5uZXQ+OyBNaWNoYWwgU2ltZWsgPG1pY2hhbHNAeGlsaW54LmNvbT47IFJh
ZGhleQ0KPiBTaHlhbSBQYW5kZXkgPHJhZGhleXNAeGlsaW54LmNvbT4NCj4gQ2M6IGxpbnV4LXVt
QGxpc3RzLmluZnJhZGVhZC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRh
dmlkZ293QGdvb2dsZS5jb207IEJyZW5kYW4gSGlnZ2lucyA8YnJlbmRhbmhpZ2dpbnNAZ29vZ2xl
LmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggdjEgMy83XSBuZXQ6IGF4aWVuZXQ6IGFk
ZCB1bnNwZWNpZmllZCBIQVNfSU9NRU0NCj4gZGVwZW5kZW5jeQ0KPiANCj4gQ3VycmVudGx5IENP
TkZJR19YSUxJTlhfQVhJX0VNQUM9eSBpbXBsaWNpdGx5IGRlcGVuZHMgb24NCj4gQ09ORklHX0hB
U19JT01FTT15OyBjb25zZXF1ZW50bHksIG9uIGFyY2hpdGVjdHVyZXMgd2l0aG91dCBJT01FTSB3
ZQ0KPiBnZXQNCj4gdGhlIGZvbGxvd2luZyBidWlsZCBlcnJvcjoNCj4gDQo+IGxkOiBkcml2ZXJz
L25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5vOiBpbiBmdW5jdGlvbg0K
PiBgYXhpZW5ldF9wcm9iZSc6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhf
YXhpZW5ldF9tYWluLmM6MTY4MDogdW5kZWZpbmVkIHJlZmVyZW5jZQ0KPiB0byBgZGV2bV9pb3Jl
bWFwX3Jlc291cmNlJw0KPiBsZDogZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9h
eGllbmV0X21haW4uYzoxNzc5OiB1bmRlZmluZWQNCj4gcmVmZXJlbmNlIHRvIGBkZXZtX2lvcmVt
YXBfcmVzb3VyY2UnDQo+IGxkOiBkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4
aWVuZXRfbWFpbi5jOjE3ODk6IHVuZGVmaW5lZA0KPiByZWZlcmVuY2UgdG8gYGRldm1faW9yZW1h
cF9yZXNvdXJjZScNCj4gDQo+IEZpeCB0aGUgYnVpbGQgZXJyb3IgYnkgYWRkaW5nIHRoZSB1bnNw
ZWNpZmllZCBkZXBlbmRlbmN5Lg0KPiANCj4gUmVwb3J0ZWQtYnk6IEJyZW5kYW4gSGlnZ2lucyA8
YnJlbmRhbmhpZ2dpbnNAZ29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQnJlbmRhbiBIaWdn
aW5zIDxicmVuZGFuaGlnZ2luc0Bnb29nbGUuY29tPg0KUmV2aWV3ZWQtYnk6IFJhZGhleSBTaHlh
bSBQYW5kZXkgPHJhZGhleS5zaHlhbS5wYW5kZXlAeGlsaW54LmNvbT4NClRoYW5rcyENCg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC9LY29uZmlnIHwgMSArDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC94aWxpbngvS2NvbmZpZw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlu
eC9LY29uZmlnDQo+IGluZGV4IDYzMDRlYmQ4YjVjNjkuLmIxYTI4NWU2OTM3NTYgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3hpbGlueC9LY29uZmlnDQo+ICsrKyBiL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3hpbGlueC9LY29uZmlnDQo+IEBAIC0yNSw2ICsyNSw3IEBAIGNvbmZp
ZyBYSUxJTlhfRU1BQ0xJVEUNCj4gDQo+ICBjb25maWcgWElMSU5YX0FYSV9FTUFDDQo+ICAJdHJp
c3RhdGUgIlhpbGlueCAxMC8xMDAvMTAwMCBBWEkgRXRoZXJuZXQgc3VwcG9ydCINCj4gKwlkZXBl
bmRzIG9uIEhBU19JT01FTQ0KPiAgCXNlbGVjdCBQSFlMSU5LDQo+ICAJLS0taGVscC0tLQ0KPiAg
CSAgVGhpcyBkcml2ZXIgc3VwcG9ydHMgdGhlIDEwLzEwMC8xMDAwIEV0aGVybmV0IGZyb20gWGls
aW54IGZvciB0aGUNCj4gLS0NCj4gMi4yNC4wLjUyNS5nOGYzNmEzNTRhZS1nb29nDQoNCg==
