Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E55E0444DA
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730876AbfFMQj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:39:58 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:29558
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730587AbfFMHGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:06:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBjyWyo2FoEu/5Sce6oAA7WOadG/3AoQCXBsXMJu7Xw=;
 b=rS+kWsCR6naKxUMQl1ZozxwCyayBM1idFDXc48eLMh7lSdtOlc2uUn6bm//JF0HRgEYhBftz+2Zf/b/UwqP6MlNHpBWou0GbKEddWvlRzBdc6ltu3wUoAQftiR/W9PssuKhlh0k7b7GGA5u0haj33k4IR7556ntwGkYCuPwxVBM=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB4685.eurprd05.prod.outlook.com (20.176.3.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 07:06:38 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3021:5bae:ebbe:701f]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::3021:5bae:ebbe:701f%6]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 07:06:38 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 Qdisc ops
Thread-Topic: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 Qdisc ops
Thread-Index: AQHVIO6FEqeVh055u0aWQnsdk+poUqaYNzGAgAD0AoA=
Date:   Thu, 13 Jun 2019 07:06:38 +0000
Message-ID: <vbf4l4u7yme.fsf@mellanox.com>
References: <20190612071435.7367-1-vladbu@mellanox.com>
 <52082ab2-7db8-b047-f42f-a5c69ba9c303@iogearbox.net>
In-Reply-To: <52082ab2-7db8-b047-f42f-a5c69ba9c303@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0107.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::23) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: beeed3dd-a0c3-4f05-9860-08d6efcdad44
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB4685;
x-ms-traffictypediagnostic: VI1PR05MB4685:
x-microsoft-antispam-prvs: <VI1PR05MB4685C4859D2BD8CCF960B316ADEF0@VI1PR05MB4685.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(39860400002)(396003)(346002)(366004)(199004)(189003)(316002)(102836004)(6506007)(54906003)(386003)(99286004)(76176011)(52116002)(53546011)(6486002)(66066001)(68736007)(6916009)(478600001)(26005)(186003)(14454004)(81156014)(8676002)(73956011)(66556008)(14444005)(66476007)(66446008)(256004)(81166006)(53936002)(66946007)(64756008)(8936002)(36756003)(86362001)(5660300002)(6512007)(71190400001)(7736002)(305945005)(229853002)(6436002)(2616005)(486006)(476003)(11346002)(2906002)(446003)(4326008)(71200400001)(25786009)(6116002)(3846002)(6246003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4685;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JTTns4eiNF5IozB/OzAnlNZ0InnvCnAd0oCEuwiWXfJ44kOHZH1Ws+V3e1RBIYVtDRRz0Q4qJj9hndK6WVHI8p/ILlSVsBJNLvJ6LRSySGysNU4duZfBPBj8/ADoL/rDgRSV0FzFhHWHj6mDcEJ6Ommwo8QxLl8XofMtEbueKspPh4uDejx69ycSHMlXKRhEfboAP1sM7FCL1Yyjko1tDFsHccvEsHeffKhAQP3tsgykAKza8JJFvQjPnyGxGdgoY1Xtfup7zHngVbVIsgQix3lvgDiQrwoid9r7L9sEMIAHyRr8fDIXdJKNHkWYzRjcLzRQsoa2t1rjSEnaeWRT+adsfU1vTZ+5n2OIlld3UCZ0h1yqIhKJ+HVQXRGVfJpGZYxntd28qVnrWNxW3rR7tdXx0baKfHA1c3BHsykVvZk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beeed3dd-a0c3-4f05-9860-08d6efcdad44
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 07:06:38.2736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vladbu@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4685
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiBXZWQgMTIgSnVuIDIwMTkgYXQgMTk6MzMsIERhbmllbCBCb3JrbWFubiA8ZGFuaWVsQGlv
Z2VhcmJveC5uZXQ+IHdyb3RlOg0KPiBPbiAwNi8xMi8yMDE5IDA5OjE0IEFNLCBWbGFkIEJ1c2xv
diB3cm90ZToNCj4+IFRvIHJlbW92ZSBydG5sIGxvY2sgZGVwZW5kZW5jeSBpbiB0YyBmaWx0ZXIg
dXBkYXRlIEFQSSB3aGVuIHVzaW5nIGluZ3Jlc3MNCj4+IFFkaXNjLCBzZXQgUURJU0NfQ0xBU1Nf
T1BTX0RPSVRfVU5MT0NLRUQgZmxhZyBpbiBpbmdyZXNzIFFkaXNjX2NsYXNzX29wcy4NCj4+DQo+
PiBJbmdyZXNzIFFkaXNjIG9wcyBkb24ndCByZXF1aXJlIGFueSBtb2RpZmljYXRpb25zIHRvIGJl
IHVzZWQgd2l0aG91dCBydG5sDQo+PiBsb2NrIG9uIHRjIGZpbHRlciB1cGRhdGUgcGF0aC4gSW5n
cmVzcyBpbXBsZW1lbnRhdGlvbiBuZXZlciBjaGFuZ2VzIGl0cw0KPj4gcS0+YmxvY2sgYW5kIG9u
bHkgcmVsZWFzZXMgaXQgd2hlbiBRZGlzYyBpcyBiZWluZyBkZXN0cm95ZWQuIFRoaXMgbWVhbnMg
aXQNCj4+IGlzIGVub3VnaCBmb3IgUlRNX3tORVdURklMVEVSfERFTFRGSUxURVJ8R0VUVEZJTFRF
Un0gbWVzc2FnZSBoYW5kbGVycyB0bw0KPj4gaG9sZCBpbmdyZXNzIFFkaXNjIHJlZmVyZW5jZSB3
aGlsZSB1c2luZyBpdCB3aXRob3V0IHJlbHlpbmcgb24gcnRubCBsb2NrDQo+PiBwcm90ZWN0aW9u
LiBVbmxvY2tlZCBRZGlzYyBvcHMgc3VwcG9ydCBpcyBhbHJlYWR5IGltcGxlbWVudGVkIGluIGZp
bHRlcg0KPj4gdXBkYXRlIHBhdGggYnkgdW5sb2NrZWQgY2xzIEFQSSBwYXRjaCBzZXQuDQo+Pg0K
Pj4gU2lnbmVkLW9mZi1ieTogVmxhZCBCdXNsb3YgPHZsYWRidUBtZWxsYW5veC5jb20+DQo+PiAt
LS0NCj4+ICBuZXQvc2NoZWQvc2NoX2luZ3Jlc3MuYyB8IDEgKw0KPj4gIDEgZmlsZSBjaGFuZ2Vk
LCAxIGluc2VydGlvbigrKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQvc2NoX2luZ3Jl
c3MuYyBiL25ldC9zY2hlZC9zY2hfaW5ncmVzcy5jDQo+PiBpbmRleCAwZjY1ZjYxNzc1NmIuLmQ1
MzgyNTU0ZTI4MSAxMDA2NDQNCj4+IC0tLSBhL25ldC9zY2hlZC9zY2hfaW5ncmVzcy5jDQo+PiAr
KysgYi9uZXQvc2NoZWQvc2NoX2luZ3Jlc3MuYw0KPj4gQEAgLTExNCw2ICsxMTQsNyBAQCBzdGF0
aWMgaW50IGluZ3Jlc3NfZHVtcChzdHJ1Y3QgUWRpc2MgKnNjaCwgc3RydWN0IHNrX2J1ZmYgKnNr
YikNCj4+ICB9DQo+Pg0KPj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgUWRpc2NfY2xhc3Nfb3BzIGlu
Z3Jlc3NfY2xhc3Nfb3BzID0gew0KPj4gKwkuZmxhZ3MJCT0JUURJU0NfQ0xBU1NfT1BTX0RPSVRf
VU5MT0NLRUQsDQo+PiAgCS5sZWFmCQk9CWluZ3Jlc3NfbGVhZiwNCj4+ICAJLmZpbmQJCT0JaW5n
cmVzc19maW5kLA0KPj4gIAkud2FsawkJPQlpbmdyZXNzX3dhbGssDQo+Pg0KPg0KPiBWbGFkLCB3
aHkgaXMgY2xzYWN0X2NsYXNzX29wcyBub3QgdXBkYXRlZCBoZXJlPyBQbGVhc2UgZWxhYm9yYXRl
IQ0KDQpEYW5pZWwsIG5vIHBhcnRpY3VsYXIgcmVhc29uIHRvIG5vdCBlbmFibGUgdW5sb2NrZWQg
ZXhlY3V0aW9uIGZvcg0KY2xzYWN0LiBJIHNldCB0aGUgdW5sb2NrZWQgZmxhZyBmb3IgaW5ncmVz
cyBiZWNhdXNlIHRoYXQgd2FzIHRoZSBRZGlzYw0KdGhhdCBJIHRlc3RlZCBhbGwgbXkgcGFyYWxs
ZWwgdGMgY2hhbmdlcyBvbi4gSG93ZXZlciwgaW5ncmVzcyBhbmQgY2xzYWN0DQppbXBsZW1lbnRh
dGlvbnMgYXJlIHF1aXRlIHNpbWlsYXIsIHNvIEkgY2FuIHNlbmQgYSBmb2xsb3d1cCBwYXRjaCB0
aGF0DQp1cGRhdGVzIGNsc2FjdF9jbGFzc19vcHMsIGlmIHlvdSB3YW50Lg0K
