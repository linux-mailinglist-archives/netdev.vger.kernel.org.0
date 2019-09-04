Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42857A840A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729919AbfIDNBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:01:16 -0400
Received: from mail-eopbgr140054.outbound.protection.outlook.com ([40.107.14.54]:19076
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727741AbfIDNBP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 09:01:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=na7AKkv5dAwIU1bmVZBLjHechiiOnOCXIPqJjNz8LBFQoUr8XXsgw5ODvs9kyygMkqI2LV8SejUWQf+51OfLrZsuH5LOta0KO7ow/j73zXjOrRcC1o0e5ZR0dZ8vqZLyldzJP4iHOkm+55zd7KOxLJlEHXtjQwNUVew+H2JFYKMuxDfFWFJTdE+t1rh4DkpU+hC+amQSg0CxS8gr4FtywJgZ8QFhS0wVsJ1B89tUjyV6M0Y/9TAv8Rbrstkd1LMfd0W+Fv8qOMLQ5TOEcpo5VnZdbHorF1k0LHBq+A4JNowD1/o2o6tAj0bXCF+ZgE/foTrZjuQ6NnvnOzAynmfxXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXYpvXQpPipJfG+Ilrho0CxdI9GNwGSP02X7xdC2Zfw=;
 b=IDgPdpbChMJ0xFEVp/uFC7Yp4bP42A6axSZCPRLwIskS9e6viui8t3YURjP0cnNzCFk9V1H9ox87JD2TcVHChKStTNVvHD21OflkniGRaelpvXlcjOwa8rUovP9FnG8552W8IjfQhRQF3Nc+MvadFgVLb9rqiIM1N0N6UOKdYBRI47U5nR+ikwcl5YZK4z1D9C0xKZHAPslhXh3Q5Z68fbEUaPdXc+WTmuO/SkaX4sYLYKwXEPvRRYjBnaZKFqK4RU3w7TgQ1C6Zgii39tXKtGIBZdYfmgky2GaYfHv5/BsQVFsO8JVMNCsW/tegraeh2M5352UvIibt7VoomObV3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXYpvXQpPipJfG+Ilrho0CxdI9GNwGSP02X7xdC2Zfw=;
 b=i7hOkezR4MnO3F4IN95bDgpTzmsj0GjOkBR8FN/g3guwuvaJvuzk8QQ0Bjka6A3qhA0sE8PCMSeVa3vUG6YHsrSbVWP/ZUAEty5GH9JlDeuN36Kwr/94aabt/5r6KNrWunIaKmzAvg4VwRMY/E6Ybu5LF0kTpJA30ddzJKXCWKU=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3156.eurprd05.prod.outlook.com (10.171.186.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 13:01:11 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::bd07:1f1a:7d30:7a5b%7]) with mapi id 15.20.2220.020; Wed, 4 Sep 2019
 13:01:11 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Davide Caratti <dcaratti@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next v3] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVYlrbUKqndwhXAEqU3e07e25doqcbRryAgAA2L4A=
Date:   Wed, 4 Sep 2019 13:01:10 +0000
Message-ID: <1ee4b82c-34d7-7cbb-e445-945f0e52bc31@mellanox.com>
References: <1567517015-10778-1-git-send-email-paulb@mellanox.com>
 <1567517015-10778-2-git-send-email-paulb@mellanox.com>
 <6b56001da1c3795ff9bb18a2aded62dea360faf9.camel@redhat.com>
In-Reply-To: <6b56001da1c3795ff9bb18a2aded62dea360faf9.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0041.eurprd05.prod.outlook.com
 (2603:10a6:208:be::18) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 280adc26-57da-4544-8ff3-08d73137f557
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3156;
x-ms-traffictypediagnostic: AM4PR05MB3156:|AM4PR05MB3156:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB315693D3B0E0DABA8805A378CFB80@AM4PR05MB3156.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(81166006)(6636002)(3846002)(6116002)(8936002)(2906002)(229853002)(81156014)(8676002)(66946007)(66476007)(66556008)(99286004)(6486002)(64756008)(66446008)(5660300002)(2501003)(14444005)(256004)(53936002)(478600001)(316002)(11346002)(2616005)(476003)(486006)(107886003)(446003)(14454004)(102836004)(31696002)(52116002)(6246003)(76176011)(6506007)(53546011)(386003)(71200400001)(86362001)(71190400001)(7736002)(6512007)(25786009)(305945005)(31686004)(4326008)(26005)(66066001)(110136005)(54906003)(36756003)(186003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3156;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2yOHugHWnW3Wy89MJ4ZqUbFZLj3JXEFtGAQXA3+58znZq6a7/Fq1SNDnLtpj8sQHdu9t+DGEG8cPXu+HlOJgiIHDopMfUVVI6LDYt+Mi8/qjCvK92v7NzVw8HK/zmSFfLJB1NhdYZiwZtppC3K2B8iJiPLCjbgNTWuvLwvsSF6VVJmsvo4CGGsF/nPeZ3PmMRHakArMWPRWOc7S88hN6AK7TCWCkWfSAu/Yex8OOK6ss14TbSqPBBoU8tp12Dm0fqnTR54ZzB/GeSkXz4KxPhIXTO3cPggaJzoRuYMEEcVUe0zSgOfSQTWoWBwLX3qxBmT5mMoRRH9i3juWJdZRkjxPQc74nDNZiaDXzeN2sZHMEBVmVcGvHv8VpJtz2sD445iDrbkw+xpEYk7qko8WH0kzpVtDYmSMgz9Z/g3S4cmA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFF7FCF039CD4C40B4351B4ABB1EDCD6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 280adc26-57da-4544-8ff3-08d73137f557
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 13:01:10.9201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZvhGBybmrD60QvBZkpXVhPIeDlyXFe76e5mXraagNWGS8TrJDToQGy4ki991yVDV+HKGXNozmoe/y30OSxvcLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA5LzQvMjAxOSAxMjo0NyBQTSwgRGF2aWRlIENhcmF0dGkgd3JvdGU6DQo+IE9uIFR1ZSwg
MjAxOS0wOS0wMyBhdCAxNjoyMyArMDMwMCwgUGF1bCBCbGFrZXkgd3JvdGU6DQo+PiBPZmZsb2Fk
ZWQgT3ZTIGRhdGFwYXRoIHJ1bGVzIGFyZSB0cmFuc2xhdGVkIG9uZSB0byBvbmUgdG8gdGMgcnVs
ZXMsDQo+PiBmb3IgZXhhbXBsZSB0aGUgZm9sbG93aW5nIHNpbXBsaWZpZWQgT3ZTIHJ1bGU6DQo+
Pg0KPj4gcmVjaXJjX2lkKDApLGluX3BvcnQoZGV2MSksZXRoX3R5cGUoMHgwODAwKSxjdF9zdGF0
ZSgtdHJrKSBhY3Rpb25zOmN0KCkscmVjaXJjKDIpDQo+Pg0KPj4gV2lsbCBiZSB0cmFuc2xhdGVk
IHRvIHRoZSBmb2xsb3dpbmcgdGMgcnVsZToNCj4+DQo+PiAkIHRjIGZpbHRlciBhZGQgZGV2IGRl
djEgaW5ncmVzcyBcDQo+PiAJICAgIHByaW8gMSBjaGFpbiAwIHByb3RvIGlwIFwNCj4+IAkJZmxv
d2VyIHRjcCBjdF9zdGF0ZSAtdHJrIFwNCj4+IAkJYWN0aW9uIGN0IHBpcGUgXA0KPj4gCQlhY3Rp
b24gZ290byBjaGFpbiAyDQo+IGhlbGxvIFBhdWwhDQo+DQo+IG9uZSBzbWFsbCBxdWVzdGlvbjoN
Cj4NCj4gWy4uLiBdDQo+DQo+PiBpbmRleCA0M2Y1YjdlLi4yZmRjNzQ2IDEwMDY0NA0KPj4gLS0t
IGEvaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMuaA0KPj4gKysrIGIvaW5jbHVkZS9uZXQvc2NoX2dl
bmVyaWMuaA0KPj4gQEAgLTI3NCw3ICsyNzQsMTAgQEAgc3RydWN0IHRjZl9yZXN1bHQgew0KPj4g
ICAJCQl1bnNpZ25lZCBsb25nCWNsYXNzOw0KPj4gICAJCQl1MzIJCWNsYXNzaWQ7DQo+PiAgIAkJ
fTsNCj4+IC0JCWNvbnN0IHN0cnVjdCB0Y2ZfcHJvdG8gKmdvdG9fdHA7DQo+PiArCQlzdHJ1Y3Qg
ew0KPj4gKwkJCWNvbnN0IHN0cnVjdCB0Y2ZfcHJvdG8gKmdvdG9fdHA7DQo+PiArCQkJdTMyIGdv
dG9faW5kZXg7DQo+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aHkgd2UgbmVlZCB0byBzdG9yZSBhbm90
aGVyIGNvcHkgb2YgdGhlIGNoYWluIGluZGV4IGluDQo+ICdyZXMuZ290b19pbmRleCcuDQo+IChz
ZWUgYmVsb3cpDQo+DQo+IFsuLi5dDQo+DQo+PiBpbmRleCAzMzk3MTIyLi5jMzkzNjA0IDEwMDY0
NA0KPj4gLS0tIGEvbmV0L3NjaGVkL2FjdF9hcGkuYw0KPj4gKysrIGIvbmV0L3NjaGVkL2FjdF9h
cGkuYw0KPj4gQEAgLTI3LDYgKzI3LDcgQEAgc3RhdGljIHZvaWQgdGNmX2FjdGlvbl9nb3RvX2No
YWluX2V4ZWMoY29uc3Qgc3RydWN0IHRjX2FjdGlvbiAqYSwNCj4+ICAgew0KPj4gICAJY29uc3Qg
c3RydWN0IHRjZl9jaGFpbiAqY2hhaW4gPSByY3VfZGVyZWZlcmVuY2VfYmgoYS0+Z290b19jaGFp
bik7DQo+PiAgIA0KPj4gKwlyZXMtPmdvdG9faW5kZXggPSBjaGFpbi0+aW5kZXg7DQo+IEkgc2Vl
ICJhLT5nb3RvX2NoYWluIiBpcyB1c2VkIHRvIHJlYWQgdGhlIGNoYWluIGluZGV4LCBidXQgSSB0
aGluayBpdCdzDQo+IG5vdCBuZWVkZWQgXyBiZWNhdXNlIHRoZSBjaGFpbiBpbmRleCBpcyBlbmNv
ZGVkIHRvZ2V0aGVyIHdpdGggdGhlICJnb3RvDQo+IGNoYWluIiBjb250cm9sIGFjdGlvbi4NCj4N
Cj4+ICAgCXJlcy0+Z290b190cCA9IHJjdV9kZXJlZmVyZW5jZV9iaChjaGFpbi0+ZmlsdGVyX2No
YWluKTsNCj4+ICAgfQ0KPj4gICANCj4+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQvY2xzX2FwaS5j
IGIvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPj4gaW5kZXggNjcxY2E5MC4uZGQxNDdiZSAxMDA2NDQN
Cj4+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4+ICsrKyBiL25ldC9zY2hlZC9jbHNfYXBp
LmMNCj4+IEBAIC0xNTE0LDYgKzE1MTQsMTggQEAgaW50IHRjZl9jbGFzc2lmeShzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCBjb25zdCBzdHJ1Y3QgdGNmX3Byb3RvICp0cCwNCj4+ICAgCQkJZ290byByZXNl
dDsNCj4+ICAgCQl9IGVsc2UgaWYgKHVubGlrZWx5KFRDX0FDVF9FWFRfQ01QKGVyciwgVENfQUNU
X0dPVE9fQ0hBSU4pKSkgew0KPj4gICAJCQlmaXJzdF90cCA9IHJlcy0+Z290b190cDsNCj4+ICsN
Cj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+PiArCQkJew0KPj4g
KwkJCQlzdHJ1Y3QgdGNfc2tiX2V4dCAqZXh0Ow0KPj4gKw0KPj4gKwkJCQlleHQgPSBza2JfZXh0
X2FkZChza2IsIFRDX1NLQl9FWFQpOw0KPj4gKwkJCQlpZiAoV0FSTl9PTl9PTkNFKCFleHQpKQ0K
Pj4gKwkJCQkJcmV0dXJuIFRDX0FDVF9TSE9UOw0KPj4gKw0KPj4gKwkJCQlleHQtPmNoYWluID0g
cmVzLT5nb3RvX2luZGV4Ow0KPiB0aGUgdmFsdWUgb2YgJ3Jlcy0+Z290b19pbmRleCcgaXMgYWxy
ZWFkeSBlbmNvZGVkIGluIHRoZSBjb250cm9sIGFjdGlvbg0KPiAnZXJyJyAobWFza2VkIHdpdGgg
VENfQUNUX0VYVF9WQUxfTUFTSyksIHNpbmNlIFRDX0FDVF9HT1RPX0NIQUlOIGJpdHMgYXJlDQo+
IG5vdCB6ZXJvLg0KPg0KPiB5b3UgY2FuIGp1c3QgZ2V0IHJpZCBvZiByZXMtPmdvdG9faW5kZXgs
IGFuZCBqdXN0IGRvOg0KPg0KPiAJZXh0LT5jaGFpbiA9IGVyciAmIFRDX0FDVF9FWFRfVkFMX01B
U0s7DQo+DQo+IGFtIEkgbWlzc2luZyBzb21ldGhpbmc/DQo+DQo+IHRoYW5rcyENCg0KTm8sIGdv
b2QgY2F0Y2ggOikgVGhhbmtzLg0KDQp0Y2ZfYWN0aW9uX3NldF9jdHJsYWN0IHNldHMgdGhlIGFj
dGlvbiB3aXRoIHRoZSBjaGFpbiBpbmRleCBvbiB0YyBhY3Rpb24gDQppbnN0YW5jZSAodGNmX2Fj
dGlvbiksIHNvIHllcyB3ZSBjYW4gYWNjZXNzIGl0IGp1c3QgbGlrZSB5b3Ugc2F5Lg0KDQpJJ2xs
IHNlbmQgYSBmaXguDQoNCg0K
