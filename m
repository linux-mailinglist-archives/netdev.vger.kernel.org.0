Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5D063150
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 09:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfGIHAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 03:00:40 -0400
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:56289
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbfGIHAk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 03:00:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pB1QTtFivH2XQmtfxsk5Y20VfKFcLHWHYAXYkH4dQVI=;
 b=fuGYEhVGkEn2QHRMtXhnXD3rGY4zH4hAttxFkSB+uvKr3JMTKss46k3B9hx2sXsbT4le2d5YQZWA79yg2cKVk822fKmpId7JMCwIyRXlRUf7x+bmxlBTB02ezMPNrHd49edP9LhsIS2hviSr5nNjDz9GhvkPTyA0DxadLbBsvKA=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3297.eurprd05.prod.outlook.com (10.170.125.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 07:00:03 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 07:00:03 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v5 1/4] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next v5 1/4] net/sched: Introduce action ct
Thread-Index: AQHVNWp/pvqia+9NpkK7WF2EIKBvMKbAuwoAgAAdmoCAAQRgAA==
Date:   Tue, 9 Jul 2019 07:00:03 +0000
Message-ID: <a4c5ea6a-2d77-8b2d-9d11-4e801e1c7779@mellanox.com>
References: <1562575880-30891-1-git-send-email-paulb@mellanox.com>
 <1562575880-30891-2-git-send-email-paulb@mellanox.com>
 <20190708134208.GD3390@localhost.localdomain>
 <20190708152805.dul3kgu4csr64fqk@breakpoint.cc>
In-Reply-To: <20190708152805.dul3kgu4csr64fqk@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR0701CA0005.eurprd07.prod.outlook.com
 (2603:10a6:203:51::15) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f69c2f03-b184-41dd-36e1-08d7043b1149
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3297;
x-ms-traffictypediagnostic: AM4PR05MB3297:
x-microsoft-antispam-prvs: <AM4PR05MB3297F7AA12EB3368A4687FC2CFF10@AM4PR05MB3297.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(229853002)(256004)(6512007)(6436002)(110136005)(2906002)(186003)(305945005)(11346002)(25786009)(36756003)(6246003)(54906003)(3846002)(7736002)(6486002)(31696002)(486006)(71200400001)(71190400001)(316002)(6116002)(53936002)(26005)(4326008)(31686004)(446003)(102836004)(86362001)(66446008)(81166006)(4744005)(7416002)(5660300002)(76176011)(66476007)(386003)(64756008)(53546011)(66946007)(478600001)(52116002)(73956011)(6506007)(66556008)(68736007)(99286004)(14454004)(2616005)(476003)(66066001)(8676002)(8936002)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3297;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pq+SRMnECNHKBtQudjL1NzXpRscbi5Gkz3KT0IHmOOxX5vzf5JwvY96orO43FbgBVuEjszRdmNyY8y9WGafUQ7WCRtWvtFW86f4brY0oejKSz78OW+VsnjjXEU6OWB/6rFK4TQd86NOlg0UV7+UZZpY2imW9xKYIkkGi7sDyPyJdnbp3MBuV6WFk1zUEbzMGB2rmS4NZxsjwBYJK0ftB7pqA4qzV5g4kfiWnf7hktIRu+ycKFsp3R8EUVtAlJJE63ySk1Tl0pr9XiQ6I21RxtpIpU+CoUJZxfCGOz/o474iCFZQEUIeWlJONgJonyKKTudAfUHTsBRsAjoD059sbTMLP+tpDqV3wT05WEr7XEkL7QoMu/kr09dl/me2G3OBOw1T1m+RU4q8VSio654pQ2PiiydEC2d+KtcOvjMfkrLM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C2CE37CB45F91478967B2802FA9A1A8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f69c2f03-b184-41dd-36e1-08d7043b1149
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 07:00:03.7426
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3297
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA3LzgvMjAxOSA2OjI4IFBNLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3RlOg0KPiBNYXJjZWxv
IFJpY2FyZG8gTGVpdG5lciA8bWFyY2Vsby5sZWl0bmVyQGdtYWlsLmNvbT4gd3JvdGU6DQo+Pj4g
Kwl9IGVsc2UgeyAvKiBORlBST1RPX0lQVjYgKi8NCj4+PiArCQllbnVtIGlwNl9kZWZyYWdfdXNl
cnMgdXNlciA9IElQNl9ERUZSQUdfQ09OTlRSQUNLX0lOICsgem9uZTsNCj4+PiArDQo+Pj4gKwkJ
bWVtc2V0KElQNkNCKHNrYiksIDAsIHNpemVvZihzdHJ1Y3QgaW5ldDZfc2tiX3Bhcm0pKTsNCj4+
PiArCQllcnIgPSBuZl9jdF9mcmFnNl9nYXRoZXIobmV0LCBza2IsIHVzZXIpOw0KPj4gVGhpcyBk
b2Vzbid0IGJ1aWxkIHdpdGhvdXQgSVB2NiBlbmFibGVkLg0KPj4gRVJST1I6ICJuZl9jdF9mcmFn
Nl9nYXRoZXIiIFtuZXQvc2NoZWQvYWN0X2N0LmtvXSB1bmRlZmluZWQhDQo+Pg0KPj4gV2UgbmVl
ZCB0byAoY29weSBhbmQgcGFzdGVkKToNCj4+DQo+PiBAQCAtMTc5LDcgKzE3OSw5IEBAIHN0YXRp
YyBpbnQgdGNmX2N0X2hhbmRsZV9mcmFnbWVudHMoc3RydWN0IG5ldCAqbmV0LCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLA0KPj4gICAgICAgICAgICAgICAgICBsb2NhbF9iaF9lbmFibGUoKTsNCj4+ICAg
ICAgICAgICAgICAgICAgaWYgKGVyciAmJiBlcnIgIT0gLUVJTlBST0dSRVNTKQ0KPj4gICAgICAg
ICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0X2ZyZWU7DQo+PiAtICAgICAgIH0gZWxzZSB7IC8q
IE5GUFJPVE9fSVBWNiAqLw0KPj4gKyAgICAgICB9DQo+PiArI2lmIElTX0VOQUJMRUQoSVBWNikN
Cj4+ICsgICAgICAgZWxzZSB7IC8qIE5GUFJPVE9fSVBWNiAqLw0KPj4gICAgICAgICAgICAgICAg
ICBlbnVtIGlwNl9kZWZyYWdfdXNlcnMgdXNlciA9IElQNl9ERUZSQUdfQ09OTlRSQUNLX0lOICsg
em9uZTsNCj4gR29vZCBjYXRjaCwgYnV0IGl0IHNob3VsZCBiZQ0KPiAjaWYgSVNfRU5BQkxFRChD
T05GSUdfTkZfREVGUkFHX0lQVjYpDQo+IGp1c3QgbGlrZSBvdnMgY29ubnRyYWNrLmMgLA0KDQoN
Cg0KVGhhbmtzIGd1eXMuDQoNCg==
