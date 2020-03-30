Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 857361973DD
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgC3FaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:30:23 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:43419
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726772AbgC3FaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 01:30:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1bNeeAkp2LYcmBMyiOvdjHmIN3XZ5arr5auIC0GWIN2ukf1eRcjZgrcSuCzbU4YhlHvzWpS40hUy1jxAfq4YbTXyb3fjY8SvB4Feg8SF54Xoz3slb6uxmOXZr8UTM8NveKQVCeEl+2d2Bqlig0qSXr5ibyPqU2MOMMZe/vZIntLJh30MPq1lfZQWNtfQs4GVacNX/ojqlcahSnefvnHLzXx+5cKqOAAeZaVRTiT2W8P6NW93inI0LHvEt2ADs+jf1auTLRCUyPCi4O+X+FrU+rHu2nFKGiIADtpqRVhu+/0IZ865sGP9JqPtOxydSgcPipaG2/O8OaGgTofzQWhwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+00cx94xx7DKSDcGaRxL3RM1WWQSL+r5TYzF23CdAA=;
 b=LPl3ZeFd8UcNp1XnO5iCnv3HNaWWYWBmTto9/z3jqe6c16KXcL/dco8nZtFADnWqwuIAd5/Au9D8x2c82sKC54fy6uqt8wtli0xmSqBejbiXwfG5UiEOWeuhzg5TBy6RhF+vMb6dCBYAeTuAwmenIFqJrIhvRDxJDQV73LKB2u+P6HVfWEqrGXfoJq9hnp5IknHmwxIQCcbHPXwGTXmkN3VVvkLm5vYea+gmjxJSQQthkw/yOSPfJv+C7nEIEdAeXnWJ/pa6kFq4caRZC+pEVWUhnvQ2RLLGDsHLHe146cMHBsDtLeTan2tFdP7EX6sYlAZzJG32BiOp8jaoNo4IMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+00cx94xx7DKSDcGaRxL3RM1WWQSL+r5TYzF23CdAA=;
 b=tvLGEv5w2Jt/mFuZwdWCSGiWn3D503aZmPRvknLztXviTosu+th3ScSGZWyeFlirZMcYYXBDGEuPEe26Go0NxyEzhqwDmA98D7JN8wDhfwr+naPM8eIo+ITr9glgLGdhaswegrmFRSkfyk2goPlfRBD9yqOA97krCk7E4uflfw8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4292.eurprd05.prod.outlook.com (52.134.91.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 05:30:18 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 05:30:18 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "aelior@marvell.com" <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        mlxsw <mlxsw@mellanox.com>, Ido Schimmel <idosch@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAEkKGA
Date:   Mon, 30 Mar 2020 05:30:18 +0000
Message-ID: <c8185887-36a0-6287-5776-d17a0c7b8d53@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <20200321093525.GJ11304@nanopsycho.orion>
 <20200323122123.2a3ff20f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200326144709.GW11304@nanopsycho.orion>
 <20200326145146.GX11304@nanopsycho.orion>
 <20200326133001.1b2694c9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200327074736.GJ11304@nanopsycho.orion>
In-Reply-To: <20200327074736.GJ11304@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.58.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3fabedc3-910c-4a2b-7e4b-08d7d46b6ed1
x-ms-traffictypediagnostic: AM0PR05MB4292:|AM0PR05MB4292:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB42923F8C73AAC01B7D342F4AD1CB0@AM0PR05MB4292.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(36756003)(81156014)(8676002)(478600001)(6506007)(7416002)(71200400001)(81166006)(86362001)(6512007)(31696002)(55236004)(4326008)(53546011)(5660300002)(91956017)(76116006)(66946007)(66446008)(64756008)(66556008)(66476007)(110136005)(186003)(54906003)(8936002)(31686004)(2906002)(2616005)(26005)(6486002)(316002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDAESWca7C93oNoNUtSPOXHTc/PU8FZNygoVnOby+29QUTcItVvk6PySe6AF1VaffdlgSjb45Fowx5ITGzAQAh/P7ajAuE9BbvCtGroQ7+AS/JgRvwuKNSzEK9R0nwGfUrXAByAU0k5KFvWVk3HTN+PPABDdRNVGZnVtb7XBjttLgAI4+JOHNryT/n2JDgXUS5i6kJ0tLgU4of1j9zMnOwEuP2PdDLqQVJ9D3EKx0dKXAfoVkfj/gBXD8hjmvbHaK/NNKcUtTFPsXnRgIV8wUS79RgJCJReL4eE49FL02pMMb+Hq+ZtnprTPQOywhqEH36aAFZmZ9F7wnh5ds5ujmfVH2MtEA7dGA1WhpofZF5ApseGdHFOU6Agx2Ggb6cwVm4HEvpwAEO38RPPcT7Y4KzacZdIm31cnKmf9xN3RRQ2jtlS+qYs+siynQdj/Ad2V
x-ms-exchange-antispam-messagedata: 2+K750pPvXosgRxPwbMu58oOgHwoEETtf5lkWIC+Wl88yhdZu8xfd6uJHuFykzDSgewaScZr6KHGu6+XYUVJWaFUoeIUZZh2wr9IYRjgiP/M/MGJM8NX+YiEIuk+ji62Zp4mZSMlI7IkLh6F6/Yc9A==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA3C29EB615959468C78AF3FD6229173@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fabedc3-910c-4a2b-7e4b-08d7d46b6ed1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 05:30:18.1117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dSFnX8rDONx6h1Qq+6mynaqNwPoSkHJA6nE9cw1x4UcKe/MFDn2eCuC+3OxEm5IJ5mCjWYE9TBRaw6seA9FDbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4292
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy8yNy8yMDIwIDE6MTcgUE0sIEppcmkgUGlya28gd3JvdGU6DQo+IFRodSwgTWFyIDI2LCAy
MDIwIGF0IDA5OjMwOjAxUE0gQ0VULCBrdWJhQGtlcm5lbC5vcmcgd3JvdGU6DQo+PiBPbiBUaHUs
IDI2IE1hciAyMDIwIDE1OjUxOjQ2ICswMTAwIEppcmkgUGlya28gd3JvdGU6DQo+Pj4gVGh1LCBN
YXIgMjYsIDIwMjAgYXQgMDM6NDc6MDlQTSBDRVQsIGppcmlAcmVzbnVsbGkudXMgd3JvdGU6DQo+
Pj4+Pj4+Pj4+ICQgZGV2bGluayBzbGljZSBzaG93DQo+Pj4+Pj4+Pj4+IHBjaS8wMDAwOjA2OjAw
LjAvMDogZmxhdm91ciBwaHlzaWNhbCBwZm51bSAwIHBvcnQgMCBzdGF0ZSBhY3RpdmUNCj4+Pj4+
Pj4+Pj4gcGNpLzAwMDA6MDY6MDAuMC8xOiBmbGF2b3VyIHBoeXNpY2FsIHBmbnVtIDEgcG9ydCAx
IHN0YXRlIGFjdGl2ZQ0KPj4+Pj4+Pj4+PiBwY2kvMDAwMDowNjowMC4wLzI6IGZsYXZvdXIgcGNp
dmYgcGZudW0gMCB2Zm51bSAwIHBvcnQgMiBod19hZGRyIDEwOjIyOjMzOjQ0OjU1OjY2IHN0YXRl
IGFjdGl2ZQ0KPj4+Pj4+Pj4+PiBwY2kvMDAwMDowNjowMC4wLzM6IGZsYXZvdXIgcGNpdmYgcGZu
dW0gMCB2Zm51bSAxIHBvcnQgMyBod19hZGRyIGFhOmJiOmNjOmRkOmVlOmZmIHN0YXRlIGFjdGl2
ZQ0KPj4+Pj4+Pj4+PiBwY2kvMDAwMDowNjowMC4wLzQ6IGZsYXZvdXIgcGNpdmYgcGZudW0gMSB2
Zm51bSAwIHBvcnQgNCBod19hZGRyIDEwOjIyOjMzOjQ0OjU1Ojg4IHN0YXRlIGFjdGl2ZQ0KPj4+
Pj4+Pj4+PiBwY2kvMDAwMDowNjowMC4wLzU6IGZsYXZvdXIgcGNpdmYgcGZudW0gMSB2Zm51bSAx
IHBvcnQgNSBod19hZGRyIDEwOjIyOjMzOjQ0OjU1Ojk5IHN0YXRlIGFjdGl2ZQ0KPj4+Pj4+Pj4+
PiBwY2kvMDAwMDowNjowMC4wLzY6IGZsYXZvdXIgcGNpdmYgcGZudW0gMSB2Zm51bSAyICAgICAg
DQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBXaGF0IGFyZSBzbGljZXM/ICAgICAgDQo+Pj4+Pj4+Pg0K
Pj4+Pj4+Pj4gU2xpY2UgaXMgYmFzaWNhbGx5IGEgcGllY2Ugb2YgQVNJQy4gcGYvdmYvc2YuIFRo
ZXkgc2VydmUgZm9yDQo+Pj4+Pj4+PiBjb25maWd1cmF0aW9uIG9mIHRoZSAib3RoZXIgc2lkZSBv
ZiB0aGUgd2lyZSIuIExpa2UgdGhlIG1hYy4gSHlwZXJ2aXpvcg0KPj4+Pj4+Pj4gYWRtaW4gY2Fu
IHVzZSB0aGUgc2xpdGUgdG8gc2V0IHRoZSBtYWMgYWRkcmVzcyBvZiBhIFZGIHdoaWNoIGlzIGlu
IHRoZQ0KPj4+Pj4+Pj4gdmlydHVhbCBtYWNoaW5lLiBCYXNpY2FsbHkgdGhpcyBzaG91bGQgYmUg
YSByZXBsYWNlbWVudCBvZiAiaXAgdmYiDQo+Pj4+Pj4+PiBjb21tYW5kLiAgICANCj4+Pj4+Pj4N
Cj4+Pj4+Pj4gSSBsb3N0IG15IG1haWwgYXJjaGl2ZSBidXQgZGlkbid0IHdlIGFscmVhZHkgaGF2
ZSBhIGxvbmcgdGhyZWFkIHdpdGgNCj4+Pj4+Pj4gUGFyYXYgYWJvdXQgdGhpcz8gICAgDQo+Pj4+
Pj4NCj4+Pj4+PiBJIGJlbGlldmUgc28uICANCj4+Pj4+DQo+Pj4+PiBPaCwgd2VsbC4gSSBzdGls
bCBkb24ndCBzZWUgdGhlIG5lZWQgZm9yIGl0IDooIElmIGl0J3Mgb25lIHRvIG9uZSB3aXRoDQo+
Pj4+PiBwb3J0cyB3aHkgYWRkIGFub3RoZXIgQVBJLCBhbmQgaGF2ZSB0byBkbyBzb21lIGNyb3Nz
IGxpbmtpbmcgdG8gZ2V0DQo+Pj4+ID5mcm9tIG9uZSB0byB0aGUgb3RoZXI/DQo+Pj4+Pg0KPj4+
Pj4gSSdkIG11Y2ggcmF0aGVyIHJlc291cmNlcyBoYW5naW5nIG9mZiB0aGUgcG9ydC4gIA0KPj4+
Pg0KPj4+PiBZZWFoLCBJIHdhcyBvcmlnaW5hbGx5IHNheWluZyBleGFjdGx5IHRoZSBzYW1lIGFz
IHlvdSBkby4gSG93ZXZlciwgdGhlcmUNCj4+Pj4gbWlnaHQgYmUgc2xpY2VzIHRoYXQgYXJlIG5v
dCByZWxhdGVkIHRvIGFueSBwb3J0LiBMaWtlIE5WRS4gUG9ydCBkb2VzDQo+Pj4+IG5vdCBtYWtl
IHNlbnNlIGluIHRoYXQgd29ybGQuIEl0IGlzIGp1c3QgYSBzbGljZSBvZiBkZXZpY2UuDQo+Pj4+
IERvIHdlIHdhbnQgdG8gbW9kZWwgdGhvc2UgYXMgInBvcnRzIiB0b28/IE1heWJlLiBXaGF0IGRv
IHlvdSB0aGluaz8gIA0KPj4+DQo+Pj4gQWxzbywgdGhlIHNsaWNlIGlzIHRvIG1vZGVsICJ0aGUg
b3RoZXIgc2lkZSBvZiB0aGUgd2lyZSI6DQo+Pj4NCj4+PiBlc3dpdGNoIC0gZGV2bGlua19wb3J0
IC4uLi4uLiBzbGljZQ0KPj4+DQo+Pj4gSWYgd2UgaGF2ZSBpdCB1bmRlciBkZXZsaW5rIHBvcnQs
IGl0IHdvdWxkIHByb2JhYmx5DQo+Pj4gaGF2ZSB0byBiZSBuZXN0ZWQgb2JqZWN0IHRvIGhhdmUg
dGhlIGNsZWFuIGN1dC4NCj4+DQo+PiBTbyB0aGUgcXVldWVzLCBpbnRlcnJ1cHRzLCBhbmQgb3Ro
ZXIgcmVzb3VyY2VzIGFyZSBhbHNvIHBhcnQgDQo+PiBvZiB0aGUgc2xpY2UgdGhlbj8NCj4gDQo+
IFllcCwgdGhhdCBzZWVtcyB0byBtYWtlIHNlbnNlLg0KPiANCj4+DQo+PiBIb3cgZG8gc2xpY2Ug
cGFyYW1ldGVycyBsaWtlIHJhdGUgYXBwbHkgdG8gTlZNZT8NCj4gDQo+IE5vdCByZWFsbHkuDQo+
IA0KPj4NCj4+IEFyZSBwb3J0cyBhbHdheXMgZXRoZXJuZXQ/IGFuZCBzbGljZXMgYWxzbyBjb3Zl
ciBlbmRwb2ludHMgd2l0aA0KPj4gdHJhbnNwb3J0IHN0YWNrIG9mZmxvYWRlZCB0byB0aGUgTklD
Pw0KPiANCj4gZGV2bGlua19wb3J0IG5vdyBjYW4gYmUgZWl0aGVyICJldGhlcm5ldCIgb3IgImlu
ZmluaWJhbmQiLiBQZXJoYXBzLA0KPiB0aGVyZSBjYW4gYmUgcG9ydCB0eXBlICJudmUiIHdoaWNo
IHdvdWxkIGNvbnRhaW4gb25seSBzb21lIG9mIHRoZQ0KPiBjb25maWcgb3B0aW9ucyBhbmQgd291
bGQgbm90IGhhdmUgYSByZXByZXNlbnRvciAibmV0ZGV2L2liZGV2IiBsaW5rZWQuDQo+IEkgZG9u
J3Qga25vdy4NCj4gDQpkZXZsaW5rIHNsaWNlIHJlcHJlc2VudHMgYSBQRi9WRi9TRi4gVGhpcyBt
ZWFucyB0aGF0IGEgZ2l2ZW4gZnVuY3Rpb24NCmNhbiBoYXZlIGFuIHJkbWEsIGV0aCBhbmQgbW9y
ZSBjbGFzcyBvZiBkZXZpY2UuDQpTbyBwb3J0IG9mIGEgc2xpY2UgaXMgYm90aCBldGgrcmRtYSAo
bm90IGVpdGhlciBvcikuDQoNCg==
