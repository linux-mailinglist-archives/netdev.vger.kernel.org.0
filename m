Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 962CBA970F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 01:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfIDXXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 19:23:47 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:49125
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727789AbfIDXXr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 19:23:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLN9PpcZO0xezbtogVnoqBjE39yjcQIIzY3CMU8AJtHufAgy4HUOXEfRd9z4bihDP2Ta6Yuaoy1WCwzFOJKTrq6naSF0kOpi0/u/eidTC2hMU+Y88rq9ko9oRkIkD+GOrx3wJ/55gPwtsepvUJP7m0jy8JtbbkrmFPmv1mE5sBmLMxnDnNZR81YxyCZVcEKm54Yc16bX9Q4hTORcJ45drSQi88BJgYnRrf+oDwxOmyeH6NXu6uUm7IpTkT8Qz5vCIzUXTt82StCqaEQ9OGbhESy+mR9lOlOX62OVnhmdR8JPz4VAANd5vnu18pDOaRelSw+bMxDJqDWY6ODRMRDvSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9QNM5WkB8zcAjC2KNWWmb4K00cvyRNA525U5VlvuqM=;
 b=NLnurmMalyBg+ezCa3cBY99Zv8qB8Bq/jDBuXchNvKRZ/YEgjXgDwWgPD7Ej8tIC7cuUKfaGNdFRaGyssQvIMFBY1D0t290Gkov6AC533f75JIaPfpaTymgFCVMq6h/sRkHUU+8wkGqJ1LwsSoqwCRx4o1X5sIfRbYncnb5bX3/NKY0uVePEWI9yp9gAntZMG6f3p/TcFmh8BL9yiIrDfiMGZSxanhDS8367mVoHNsv6I+iVOr/0Ev1Dlh7cG59VnoMfk/EJ0AAGYs1ikp05SYcMLh4PbJTrRyr/IsIdNNeR5HgmheXsXW7RhYGS203sdQYZKYXn0eFnc88JXrk92A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9QNM5WkB8zcAjC2KNWWmb4K00cvyRNA525U5VlvuqM=;
 b=K1Ca1dsPbTW2SwXiR9LLnKnRLq5LhTfZtoq1C1WEdq64/OD2dTeJBxJjBDUbU95OTsSuIB5FaPlBc9Jlm4siIaASF5ShcTKUXgPhh9u26ZkeN8RCkft6vHvKojguJAFsk6sIqa1+V+fKqboi2MqY/Lwroi0P4NxOfWE5Lue48gs=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Wed, 4 Sep 2019 23:23:44 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 23:23:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: rtnl_lock() question
Thread-Topic: rtnl_lock() question
Thread-Index: AQHVYqJKumC1NCDikkGcxbq8StzvE6cbImWAgACWmgCAAHFPgA==
Date:   Wed, 4 Sep 2019 23:23:43 +0000
Message-ID: <867cf373f204715aec3b2e04ef9f65454cf25a2e.camel@mellanox.com>
References: <29EC5179-D939-42CD-8577-682BE4B05916@gmail.com>
         <3164f8de-de20-44f7-03fb-8bc39ca8449e@gmail.com>
         <C46053D2-6BF5-4CFE-BF76-32DDCAD7BC10@gmail.com>
In-Reply-To: <C46053D2-6BF5-4CFE-BF76-32DDCAD7BC10@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 142efbd7-fb7b-4492-c127-08d7318eed96
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2765;
x-ms-traffictypediagnostic: VI1PR0501MB2765:
x-microsoft-antispam-prvs: <VI1PR0501MB2765D2BF7D1FCAE00A780B7CBEB80@VI1PR0501MB2765.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(43544003)(199004)(189003)(186003)(26005)(53936002)(2906002)(102836004)(25786009)(6246003)(4326008)(7736002)(446003)(305945005)(6512007)(8936002)(6436002)(11346002)(86362001)(76176011)(36756003)(3846002)(6116002)(99286004)(14454004)(64756008)(66946007)(66556008)(66446008)(478600001)(81156014)(81166006)(316002)(6506007)(53546011)(110136005)(58126008)(66476007)(2501003)(71190400001)(486006)(6486002)(91956017)(76116006)(71200400001)(8676002)(256004)(66066001)(14444005)(229853002)(2616005)(476003)(5660300002)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2765;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: s7GyMol9Bg5ZCo8bWh3Ta9kzjAgui7gQ8KozCrRx2+H3XduWw1EDVoycxYzzTwf4OYpwSXig0lC0QXhpquoDI4e5P2FR0IJblMI8DKxrGqwUkMFirMEDeelYZO46Evx2b7BnSodVeU5N1cQslNdcsO1NXdHTbWWvBNqdAZ3QyekFgIG88zLbGdqQt6VA/rNUtqAe50Jd/KqBspQZR63duS8Ay011cdf6clsDNpdMQmmkQTkxO6BWeUpzK9xuDkDmGB87XmyS2RQlVCwNC+LuVICQ/fntbSK8KnQ4jUQxen0t2qXuS0pbmiJiHiIAVV5flc4yaNTtNEBoGzMDxmjnZB35nyqncGOoqMVonpaJanLAZ4bNHWTQ7E56oef4+kFEoaXTmGhMVuYJz1M7MLUYEg7lTgkR3ma1JR6lH+g1EuI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1423C52FA2B7347B2876F498AEA4104@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142efbd7-fb7b-4492-c127-08d7318eed96
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 23:23:43.5557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ya1AleieyV83NS8Be2nKb368ahGI6m/9WwtZJpa4gcroeUZfH9tguxzrazqwFjvHjLmq2M+PDJGDPcOV3BorAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA5LTA0IGF0IDA5OjM4IC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gT24gNCBTZXAgMjAxOSwgYXQgMDozOSwgRXJpYyBEdW1hemV0IHdyb3RlOg0KPiANCj4gPiBP
biA5LzMvMTkgMTE6NTUgUE0sIEpvbmF0aGFuIExlbW9uIHdyb3RlOg0KPiA+ID4gSG93IGFwcHJv
cHJpYXRlIGlzIGl0IHRvIGhvbGQgdGhlIHJ0bmxfbG9jaygpIGFjcm9zcyBhIHNsZWVwYWJsZQ0K
PiA+ID4gbWVtb3J5IGFsbG9jYXRpb24/ICBPbiBvbmUgaGFuZCBpdCdzIGp1c3QgYSBtdXRleCwg
YnV0IGl0IHdvdWxkDQo+ID4gPiBzZWVtIGxpa2UgaXQgY291bGQgYmxvY2sgcXVpdGUgYSBmZXcg
dGhpbmdzLg0KPiA+ID4gDQo+ID4gDQo+ID4gU3VyZSwgYWxsIEdGUF9LRVJORUwgYWxsb2NhdGlv
bnMgY2FuIHNsZWVwIGZvciBxdWl0ZSBhIHdoaWxlLg0KPiA+IA0KPiA+IE9uIHRoZSBvdGhlciBo
YW5kLCB3ZSBtYXkgd2FudCB0byBkZWxheSBzdHVmZiBpZiBtZW1vcnkgaXMgdW5kZXIgDQo+ID4g
cHJlc3N1cmUsDQo+ID4gb3IgY29tcGxleCBvcGVyYXRpb25zIGxpa2UgTkVXTElOSyB3b3VsZCBm
YWlsLg0KPiA+IA0KPiA+IFJUTkwgaXMgbW9zdGx5IHRha2VuIGZvciBjb250cm9sIHBhdGggb3Bl
cmF0aW9ucywgd2UgcHJlZmVyIHRoZW0gdG8NCj4gPiBiZQ0KPiA+IG1vc3RseSByZWxpYWJsZSwg
b3RoZXJ3aXNlIGFkbWlucyBqb2Igd291bGQgYmUgYSBuaWdodG1hcmUuDQo+ID4gDQo+ID4gSW4g
c29tZSBjYXNlcywgaXQgaXMgcmVsYXRpdmVseSBlYXN5IHRvIHByZS1hbGxvY2F0ZSBtZW1vcnkg
YmVmb3JlIA0KPiA+IHJ0bmwgaXMgdGFrZW4sDQo+ID4gYnV0IHRoYXQgd2lsbCBvbmx5IHRha2Ug
Y2FyZSBvZiBzb21lIHNlbGVjdGVkIHBhdGhzLg0KPiANCj4gVGhlIHBhcnRpY3VsYXIgY29kZSBw
YXRoIHRoYXQgSSdtIGxvb2tpbmcgYXQgaXMNCj4gbWx4NWVfdHhfdGltZW91dF93b3JrKCkuDQo+
IA0KPiBUaGlzIGlzIGNhbGxlZCBvbiBUWCB0aW1lb3V0LCBhbmQgbWx4NSB3YW50cyB0byBtb3Zl
IGFuIGVudGlyZQ0KPiBjaGFubmVsDQo+IGFuZCBhbGwgdGhlIHN1cHBvcnRpbmcgc3RydWN0dXJl
cyBlbHNld2hlcmUuICBVbmRlciB0aGUgcnRubF9sb2NrKCksDQo+IGl0DQo+IGNhbGxzIGt2em1h
bGxvYygpIGluIG9yZGVyIHRvIGdyYWIgYSBsYXJnZSBjaHVuayBvZiBjb250aWcgbWVtb3J5LA0K
PiB3aGljaA0KPiBlbmRzIHVwIHN0YWxsaW5nIHRoZSBzeXN0ZW0uDQo+IA0KPiBJIHN1c3BlY3Qg
dGhlc2UgbGFyZ2UgYWxsb2NhdGlvbiBzaG91bGQgcmVhbGx5IGJlIGRvbmUgb3V0c2lkZSB0aGUN
Cj4gbG9jay4NCg0KSSBhbSBhZnJhaWQgdGhhdCBpcyBpbXBvc3NpYmxlLCBhdCBsZWFzdCBub3Qg
Zm9yIGFsbCBhbGxvY2F0aW9ucw0KDQpzb21lIGFsbG9jYXRpb25zIHJlcXVpcmUgcGFyYW1ldGVy
cyB0aGF0IHNob3VsZCByZW1haW4gdmFsaWQgYW5kDQpjb25zdGFudCBhY3Jvc3MgdGhlIHdob2xl
IHJlY29uZmlndXJhdGlvbiBwcm9jZWR1cmUgc3VjaA0KcGFyYW1zLm51bV9jaGFubmVscywgc28g
dGhleSBtdXN0IGJlIGRvbmUgaW5zaWRlIHRoZSBsb2NrLiANCg0Kb3RoZXIgYWxsb2NhdGlvbnMg
YXJlIGJ1cmllZCBkZWVwIGluc2lkZSBtbHg1IHRoYXQgYnkgZG9pbmcgcHJlDQphbGxvY2F0aW9u
cyBpcyBnb2luZyB0byByZXF1aXJlIGEgbG90IG9mIHJlZmFjdG9yaW5nLiANCg0KT25lIGlkZWEg
aXMgdG8gdXNlIHNvbWUgc29ydCBvZiBtZW0gY2FjaGUgc3BlY2lmaWNhbGx5IGZvciBtbHg1DQpy
ZWNvbmZpZ3VyYXRpb24gdGhhdCBpcyBjaGVhcGVyIHRvIGNhbGwgdGhhbiByYXcga3Z6YWxsb2Mg
PyBidXQNCmRpZmZlcmVudCBvYmplY3RzICBpbiB0aGUgbWx4NSByZWNvbmZpZ3VyYXRpb24gcGF0
aCByZXF1aXJlcyBkaWZmZXJudA0KbWVtb3J5IHR5cGVzLCBudW1hIGFmZmluaXR5IGV0Yy4uIHdo
aWNoIG1pZ2h0IG1ha2UgdGhlIGNhY2hlIGhhcmRlciB0bw0Kc2F0aXNmeSBhbGwgcmVxdWlyZW1l
bnRzLg0K
