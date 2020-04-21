Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB24C1B2CB0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgDUQae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 12:30:34 -0400
Received: from mail-vi1eur05on2087.outbound.protection.outlook.com ([40.107.21.87]:61440
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725963AbgDUQae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 12:30:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DsRYLERH2ZBYMkEOBkhbUMDBgQuLQQbppTKRm9qhzHYFr4Hr2XRL/MCOLvCoFLfmYFWXkCY5MjKVIO2V6vA5ecx3GW7aPim4tF8bVjHgrpza4pskLpVs4AYJmsKaTvhIQMuFWWUVWo3ceJfh81vuX2yrYJP/8ZVYhTvT3NmsvJXox6SstwbFFmfLeSmJBC7mObfac32cidgEWYVRMhi6fPPJEkWQqu46LSJIRcgsW702Ie+cyoMXiH5xEt7z/eH6uvOLWKa81tPYRkb5SttgY1ArizFS3oojKTQCC9WgQQ9x9sBlQJGrZmednIgoM0VsdXbtXqrPo1gvbeLb9/X4qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3R+NtedkYMjs537X1FcOPdblGDbkk8ygYNX1tHcM+M=;
 b=aXVHK6mPpgpgzu7i6c2TP742mCADBDZZR6NdlUY6J9QzjqDPiay0cNFCme+37SOOtFSwjaxAUt+lmCwo/12jiuV8KWDE2ite8wLWhO78GmumdEvsD8n8MVvLNTHRrQv7vXMkSct6nryYjgWASrU6eZv3zqAhz2Iq70j7dO2Smr4oqXkyco9EriLJdf9MS1QmotXssq10wWM1FQbzo7/pYXaSNJSO9EAkPjMsW62t2q/Hc0AV7GO5E6Q/b+gu+PKDdIoWXemA+yA+DNlnvB3fhZ8GePoG4jQhsFcU7Wr/aa3w6E04ApIVXZ1VvqHAaKdT7lNASnDe5w/LseKP2CHgFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X3R+NtedkYMjs537X1FcOPdblGDbkk8ygYNX1tHcM+M=;
 b=mXRWXhg5Tv1Onzzq54yKSbkjM/Mkw306a+eNoAciiGAM5t/+f2SI3qteS/cUTRug9XhTJ+i5AztaQd4lj0JXPYOHR/7vIhkP7p32fll5b7h+MoIAn6r3I3HHWOtrVTJ3lZhGZzt3U+KOy0NCE4cIfK/BSCHlN1+3Au4ndAd+mQs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6286.eurprd05.prod.outlook.com (2603:10a6:803:f1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Tue, 21 Apr
 2020 16:30:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 16:30:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "nico@fluxnic.net" <nico@fluxnic.net>
CC:     "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "jani.nikula@linux.intel.com" <jani.nikula@linux.intel.com>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Topic: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
Thread-Index: AQHWFFU+GtgmZSAXzkWfdBAfhtrsbqh/PqeAgAAC8YCAAA/HgIACZWqAgAFJ8gCAAKBmgIAAKieA
Date:   Tue, 21 Apr 2020 16:30:29 +0000
Message-ID: <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com>
References: <20200417011146.83973-1-saeedm@mellanox.com>
         <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com>
         <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr>
         <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
         <87v9lu1ra6.fsf@intel.com>
         <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com>
         <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr>
In-Reply-To: <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ec50a91a-3543-4dcd-132c-08d7e6114e10
x-ms-traffictypediagnostic: VI1PR05MB6286:
x-microsoft-antispam-prvs: <VI1PR05MB62866CF4E5CF1EBC88FDD779BED50@VI1PR05MB6286.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(71200400001)(5660300002)(66556008)(91956017)(2906002)(4326008)(66476007)(76116006)(64756008)(66946007)(6486002)(66446008)(8936002)(86362001)(186003)(498600001)(6916009)(26005)(6506007)(8676002)(54906003)(7416002)(36756003)(81156014)(6512007)(2616005);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9i/9XfEI1QJ1UGTjP3MNeIuutmKPi0ClZMahovtvsqfXqrhu7DrRLI6WGaamM0+wvhU+BqO3jCoCg+S64pGnuI3uFgldgG/nGEuuWzP7PkRWqB7r9qNYhcLfhJMT08sviqB1rM2Jo39HJ+0gcupJmqAgDVN57eKiNJ5TTekXReH0uiLStqb7DpXXDzuFzBcbXF+9tUz5kRD7lad2MH4WoJ7Nht5m1YRJ5INsrfXRmEEw5NburbWWatBuLPVmJh8AAbxsBdMnCw/jY8CWEngWbmR8pCnqQULKcznYq80RHoxIq2fQQMoiKuCJBqLkwfgxISNIgHMwaYon/sCD1rBJsue1JZ4E04y9lcWHK/F9uO1LjK1wIajvDVfq7j4y59Is4pZUzUMcUTMswaQpzqPdasMhmoeghzViHyPUTerzgzrLgtWJ+O22ivVjZzsZgjHt
x-ms-exchange-antispam-messagedata: lc/oY5K63MxRgtj5Z1O6r/lwHmW9ki9RZ+fjmH+3DfUIWZVS+1Yo1fELzjIDftkV8mxJSGSPszPaqAC2xczoeamfQfsV10ZvJc4KZtt4wyq3YKypSnAtBUlaG9TVgQBYl3LXByfDZ3kOBQhqSfzbDg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <37A07B5FDC630A49B0CE3525C8B569F4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec50a91a-3543-4dcd-132c-08d7e6114e10
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 16:30:29.3414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uIsLCc75q5L4sDTwS8JjvLgOoKTShZROzMYYD/GOHzxTlZnoDUji9PBgwJDeJwtlvy7GtGzd04r1BEq18nBNQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6286
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA0LTIxIGF0IDA5OjU4IC0wNDAwLCBOaWNvbGFzIFBpdHJlIHdyb3RlOg0K
PiBPbiBUdWUsIDIxIEFwciAyMDIwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gDQo+ID4gSSB3
b25kZXIgaG93IG1hbnkgb2YgdGhvc2UgODg4OSBjYXNlcyB3YW50ZWQgYSB3ZWFrIGRlcGVuZGVu
Y3kgYnV0DQo+ID4gY291bGRuJ3QgZmlndXJlIG91dCBob3cgdG8gZG8gaXQgPyANCj4gPiANCj4g
PiBVc2VycyBvZiBkZXBlbmRzIG9uIEZPTyB8fCAhRk9PDQo+ID4gDQo+ID4gJCBnaXQgbHMtZmls
ZXMgfCBncmVwIEtjb25maWcgfCB4YXJncyBncmVwIC1FIFwNCj4gPiAgICJkZXBlbmRzXHMrb25c
cysoW0EtWmEtejAtOV9dKylccypcfFx8XHMqKFwhXHMqXDF8XDFccyo9XHMqbikiIFwNCj4gPiAg
fCB3YyAtbA0KPiA+IA0KPiA+IDE1Ng0KPiA+IA0KPiA+IGEgbmV3IGtleXdvcmQgaXMgcmVxdWly
ZWQgOikgLi4gDQo+ID4gDQo+ID4gDQo+ID4gPiBJbiBhbm90aGVyIG1haWwgSSBzdWdnZXN0ZWQN
Cj4gPiA+IA0KPiA+ID4gCW9wdGlvbmFsbHkgZGVwZW5kcyBvbiBGT08NCj4gPiA+IA0KPiA+ID4g
bWlnaHQgYmUgYSBiZXR0ZXIgYWx0ZXJuYXRpdmUgdGhhbiAidXNlcyIuDQo+ID4gPiANCj4gPiA+
IA0KPiA+IA0KPiA+IGhvdyBhYm91dCBqdXN0Og0KPiA+ICAgICAgIG9wdGlvbmFsIEZPTw0KPiA+
IA0KPiA+IEl0IGlzIGNsZWFyIGFuZCBlYXN5IHRvIGRvY3VtZW50IC4uIA0KPiANCj4gSSBkb24n
dCBkaXNwdXRlIHlvdXIgYXJndW1lbnQgZm9yIGhhdmluZyBhIG5ldyBrZXl3b3JkLiBCdXQgdGhl
IG1vc3QgDQo+IGRpZmZpY3VsdCBwYXJ0IGFzIEFybmQgc2FpZCBpcyB0byBmaW5kIGl0LiBZb3Ug
Y2Fubm90IHByZXRlbmQgdGhhdCANCg0Ka2NvbmZpZy1sYW5ndWFnZS5yc3QgID8NCg0KPiAib3B0
aW9uYWwgRk9PIiBpcyBjbGVhciB3aGVuIGl0IGFjdHVhbGx5IGltcG9zZXMgYSByZXN0cmljdGlv
biB3aGVuIA0KPiBGT089bS4gVHJ5IHRvIGp1c3RpZnkgdG8gcGVvcGxlIHdoeSB0aGV5IGNhbm5v
dCBzZWxlY3QgeSBiZWNhdXNlIG9mDQo+IHRoaXMgDQo+ICJvcHRpb25hbCIgdGhpbmcuDQo+IA0K
DQpUaGVuIGxldCdzIHVzZSAidXNlcyIgaXQgaXMgbW9yZSBhc3NlcnRpdmUuIERvY3VtZW50YXRp
b24gd2lsbCBjb3Zlcg0KYW55IHZhZ3VlIGFueXRoaW5nIGFib3V0IGl0IC4uIA0KDQo+IA0KPiBO
aWNvbGFzDQo=
