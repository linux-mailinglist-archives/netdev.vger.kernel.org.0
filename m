Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB3D8134CD
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 23:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfECVUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 17:20:09 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:58087
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726041AbfECVUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 17:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LzgIR2H5bAz0qhx87Gf9fJTfXuc0cojdqQhjPMcK1CE=;
 b=LEzpZb1oqk1plI0gGBC0LiaAgyZI27FPRcxWTWs+jPhsdI13EbD5bsTKUMXIAQfOF4wSnV3GXGtKIWZIGQ+sj6bD7jqGnPdIO17Z6ozj+iGlqY1pCo8ZOs/vcdC/PXUotE0qSNh1qtSL7D6uQYL4wv3uutjNVczDBfQ+tWKpY8M=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.105.143) by
 VI1PR0302MB3328.eurprd03.prod.outlook.com (52.134.13.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.14; Fri, 3 May 2019 21:20:03 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::b584:8ced:9d52:d88e%6]) with mapi id 15.20.1835.018; Fri, 3 May 2019
 21:20:03 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH net-next] net: sched: Introduce act_ctinfo action
Thread-Topic: [PATCH net-next] net: sched: Introduce act_ctinfo action
Thread-Index: AQHU/PpFKlFqg3WFM0Ghoph4kvG8KqZVQqwAgASvTwA=
Date:   Fri, 3 May 2019 21:20:03 +0000
Message-ID: <9FB6B9CF-1767-4598-8859-C5D8A47DEC85@darbyshire-bryant.me.uk>
References: <20190427130739.44614-1-ldir@darbyshire-bryant.me.uk>
 <CAM_iQpXnXyfLZ2+gjDufbdMrZLgtf9uKbzbUf50Xm-2Go7maVw@mail.gmail.com>
In-Reply-To: <CAM_iQpXnXyfLZ2+gjDufbdMrZLgtf9uKbzbUf50Xm-2Go7maVw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.240.142.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d19309a2-092a-4f16-2b3a-08d6d00d1bbe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR0302MB3328;
x-ms-traffictypediagnostic: VI1PR0302MB3328:
x-microsoft-antispam-prvs: <VI1PR0302MB3328708E2ACDF27131C8A2D1C9350@VI1PR0302MB3328.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39830400003)(366004)(376002)(396003)(346002)(136003)(51914003)(199004)(189003)(6512007)(82746002)(54906003)(229853002)(26005)(68736007)(186003)(33656002)(102836004)(14454004)(74482002)(53936002)(81156014)(66946007)(76116006)(446003)(508600001)(99286004)(316002)(91956017)(81166006)(11346002)(2616005)(64756008)(66446008)(66066001)(53546011)(305945005)(66556008)(7736002)(73956011)(8936002)(6506007)(3846002)(6116002)(66476007)(486006)(83716004)(476003)(5660300002)(2906002)(4326008)(71200400001)(71190400001)(8676002)(6916009)(86362001)(76176011)(25786009)(14444005)(256004)(36756003)(6436002)(6246003)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3328;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OijpYnPO9kgYBx4tOH2MdmlC+m3k0GqyvEQc+sIQVnqFnGL/Q1HfHlRL+RyRdJ/3mx/Y49flevFcpQ5PAZXgWZVMJEJzCASpBj0EtzqBMn+WnLRnP3eI6w9OSW7qiW3nxiwGbiLcAk7s6kFIxM15u0qss5cngIZJiBdmdUzovyVZqp9h/jmU/kD3mjI87GmoBpIXdbAejbLh/+lC5iQoiaSnC7DA1C+sTUhOXpf7zInqGUiysBL7wdhEGE/9TR00QLfE+Ebe10j0R1PvMbiJeuNa2TIpRlQKH7ELO9PRDbPpF9qTeI7YNZMa0UG6LLpg4hdZH4YPuj4/rApRlnLLgY20GdV85ik2q0pWZHdVIcAYU8zjpQjdBrdhXARy2DMtHZv07ejt1lbnA+cl9OxJTiNn2qHd5/8zBJCNjxtF+co=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF3125F0747CC64C86496FC152B1B705@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: d19309a2-092a-4f16-2b3a-08d6d00d1bbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 21:20:03.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3328
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMzAgQXByIDIwMTksIGF0IDIyOjQ3LCBDb25nIFdhbmcgPHhpeW91Lndhbmdjb25n
QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiBTYXQsIEFwciAyNywgMjAxOSBhdCA2OjA4IEFN
IEtldmluICdsZGlyJyBEYXJieXNoaXJlLUJyeWFudA0KPiA8bGRpckBkYXJieXNoaXJlLWJyeWFu
dC5tZS51az4gd3JvdGU6DQo+PiANCj4+IGN0aW5mbyBpcyBhIG5ldyB0YyBmaWx0ZXIgYWN0aW9u
IG1vZHVsZS4gIEl0IGlzIGRlc2lnbmVkIHRvIHJlc3RvcmUgRFNDUHMNCj4+IHN0b3JlZCBpbiBj
b25udHJhY2sgbWFya3MgaW50byB0aGUgaXB2NC92NiBkaWZmc2VydiBmaWVsZC4NCj4gDQo+IEkg
dGhpbmsgd2UgY2FuIHJldHJpZXZlIGFueSBpbmZvcm1hdGlvbiBmcm9tIGNvbm50cmFjayB3aXRo
IHN1Y2gNCj4gYSBnZW5lcmFsIG5hbWUsIGluY2x1ZGluZyBza2IgbWFyay4gU28sIGFzIHlvdSBh
bHJlYWR5IHBpY2sgdGhlDQo+IG5hbWUgY3RpbmZvLCBwbGVhc2UgbWFrZSBpdCBnZW5lcmFsIHJh
dGhlciB0aGFuIGp1c3QgRFNDUC4NCj4gWW91IGNhbiBhZGQgc2tiIG1hcmsgaW50byB5b3VyIGN0
aW5mbyB0b28gc28gdGhhdCBhY3RfY29ubm1hcmsNCj4gY2FuIGJlIGp1c3QgcmVwbGFjZWQuDQoN
CkhpIENvbmcsDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldywgSSBoYXZlIGEgdjIgaW4gcHJvZ3Jl
c3MgYWRkcmVzc2luZyB0aGF0IGFsb25nDQp3aXRoIGFub3RoZXIgc2lsbHkgdGhhdCBnb3QgdGhy
b3VnaC4gIEnigJltIGFsc28gcmUtd29ya2luZyB0aGUgc3RhdHMNCnJlcG9ydGluZyB0byByZXR1
cm4gYWN0X2N0aW5mbyBzdGF0cyBpbnN0ZWFkIG9mIHVzdXJwaW5nIHRoZSBkcm9wcGVkLA0Kb3Zl
cmxpbWl0cyAmIGRyb3BwZWQgZmlndXJlcy4NCg0KPiANCj4gWW91ciBwYXRjaCBsb29rcyBmaW5l
IGZyb20gYSBxdWljayBnYWxhbmNlLCBwbGVhc2UgbWFrZSBzdXJlDQo+IHlvdSBydW4gY2hlY2tw
YXRjaC5wbCB0byBrZWVwIHlvdXIgY29kaW5nIHN0eWxlIGFsaWduZWQgdG8gTGludXgNCj4ga2Vy
bmVsJ3MsIGF0IGxlYXN0IEkgZG9uJ3QgdGhpbmsgd2UgYWNjZXB0IEMrKyBzdHlsZSBjb21tZW50
cy4NCg0KVGhpcyB0aW1lIEnigJlsbCByZW1lbWJlciB0byBydW4gY2hlY2twYXRjaCBiZWZvcmUg
SSBzdWJtaXQgaW5zdGVhZCBvZg0KYWZ0ZXIgOi0pDQoNCj4gDQo+IFRoYW5rcy4NCg0KDQpDaGVl
cnMsDQoNCktldmluIEQtQg0KDQpncGc6IDAxMkMgQUNCMiAyOEM2IEM1M0UgOTc3NSAgOTEyMyBC
M0EyIDM4OUIgOURFMiAzMzRBDQoNCg==
