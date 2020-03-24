Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EED19053F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgCXFgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:36:15 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:7233
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgCXFgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 01:36:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqUx9f/ZiHv/nDy5INREMHwt2IoJhu3tEZwU7IV1AGVV0qSec68I//PlZkovYUhOl0y6kGbkdrW783jl7LXftKBraEhUsCZ6A2WAI3AZ8EhJuz1k3Vb9sGcilMxwZfmkmFQWc1HVAKWRqH3uGKqKvBgKOQENY5rzMXEvknSnOAmVi5MNaBlxKE/hwOh6Hmui5MAJ2pyoUjQXvGcASYOED5GPUpF3YCzzlCQaaJKqWfjxqWsBfp4z7bfYC/gNRRD+YMChoTzoFIDw8helvZMILslhYSNxKHcue1sUH1CDGpZt6cx5Y+CDp6N5QKxDs5yI9qxZTXzZIXWuxUGUjfADQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NoRtW+b/vCSzX9MKbXNA7mPcO/6TbNhdXqQ2A8QwPM=;
 b=VVV0UqqJv3nDvCo0F+8EvkA2rTA5HUlalJHWrQ2J/rk3IEWg+9PthKTBp+F8Htyw6GpydJCYkXUvuSu5vFp3NBhBBqg70F4Ojl0vjx09XITSAqdR/0tHbsOeNOQ6ee6yvYRQhXH4xNzv99AU3Aa/ZoDmQXwVwvVqlHCsHIrIjTeDnXv0aBBCeoZar3vVegKIKuGkf075sc3fxQKida00xscD6fx6fN3QlFahNlhpJwS2wsNaAND/6bp97TyDgsC6CWN9l/0HgsyyAr6Z2dg7j17rIbnCPe/x0WCfe9/1Fx5LVMRxF2PlsI0j1ixkhIU5EFkYh5XTHieCPIWO29kQGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NoRtW+b/vCSzX9MKbXNA7mPcO/6TbNhdXqQ2A8QwPM=;
 b=Cl65tRd4q9+TcDKparY7YnWV9Cez48OdcPjxq3BiJaq8zVSGF+9yFOMabZudEsTSC2AqXlJCYpPDekOgrqK3JWOsDJ3TaAq5OyttZuFGF2uE9S4YWBBDuNmLJTfzzy761E9uv1I8K63ylHDfT9JjqN7X36PRH9cWDUBrlEkuX4M=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5650.eurprd05.prod.outlook.com (20.178.115.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.22; Tue, 24 Mar 2020 05:36:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 05:36:08 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAxDyAgAPS8gCAAKj+gA==
Date:   Tue, 24 Mar 2020 05:36:08 +0000
Message-ID: <de01d429-6740-51a9-62e9-10ec54074041@mellanox.com>
References: <20200319192719.GD11304@nanopsycho.orion>
 <20200319203253.73cca739@kicinski-fedora-PC1C0HJN>
 <20200320073555.GE11304@nanopsycho.orion>
 <20200320142508.31ff70f3@kicinski-fedora-PC1C0HJN>
 <997dbf25-a3e1-168c-c756-b33e79e7c51e@mellanox.com>
 <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200323123116.769e50e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.58.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38b9af26-d32c-4082-a94f-08d7cfb5413d
x-ms-traffictypediagnostic: AM0PR05MB5650:|AM0PR05MB5650:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5650D3A7E3DC7646CECE2208D1F10@AM0PR05MB5650.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 03524FBD26
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(8936002)(81156014)(81166006)(91956017)(36756003)(76116006)(5660300002)(66946007)(54906003)(66556008)(66476007)(8676002)(2616005)(2906002)(66446008)(64756008)(71200400001)(186003)(316002)(31696002)(26005)(6916009)(86362001)(6512007)(6486002)(7416002)(53546011)(4326008)(6506007)(55236004)(478600001)(31686004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5650;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jRWYGjeluT2Ve/IyBSXscCN2j6ONatg9l9EV0uCYE1F7kv/vvx8Q534aEBZyuP47olZJE2I2WfsiRGs9JK9ZLDhJ3uRDUk2rFg+3rs5V5c8drO2qP1O5yRFVHwcCsQcxHa8PMRY+s0p0V4qeNqqTKb5XZIY/c9gZ7QJGmX4zjOCT58AyM9bDeSgFDcoZDQUo0d4zE3UZtoJnszpTbyxt90WcUAW/KgXdGig9xUIBBH8FBmpKmOY5+uSS1JkRvSce6ZFQRVK2mfhbsTbve/oyVowHvguhkRb1EN3RxMHxhoLfgKqbjKER8KEffvUvQSo+FrhxhRRNciaKRWJ1Jld6OlGNnClXozanXnuZdaIvrbja1n4vOu6kT3jP0ufxIzZxyBNQB2Nm0nY4uJPtMsjc3YMrijhUT9Z1UWXL+q32so2vzyFlzidwJmwcr/SD6S8q
x-ms-exchange-antispam-messagedata: 6ZURT/cR5N/B03OGtQbmVfubrfaMcGK9tsTZvxKEdnklGvnTzl/4Z3/+y9hBYwNuO6R5mWKZnWMptmH3YnCRFanjzkvvKzpZxsxcrCNOPx3Vg0gbOErfUJgEHWQwXqpoM4pjEt7NXSxoFVwutLBM5g==
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DBD0D8FB1169A449752ED820F8C2AE7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38b9af26-d32c-4082-a94f-08d7cfb5413d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2020 05:36:08.4993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mUtbfrhksbzx5DgergFk4CQYjgBO4xY08Uo6cHe+Fi08SR+7RR+oTWTtmJVneKgm0OzhJ8aGfxPWoKL+nNM+Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy8yNC8yMDIwIDE6MDEgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBTYXQsIDIx
IE1hciAyMDIwIDA5OjA3OjMwICswMDAwIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4+PiBJIHNlZSBz
byB5b3Ugd2FudCB0aGUgY3JlYXRpb24gdG8gYmUgY29udHJvbGxlZCBieSB0aGUgc2FtZSBlbnRp
dHkgdGhhdA0KPj4+IGNvbnRyb2xzIHRoZSBlc3dpdGNoLi4NCj4+Pg0KPj4+IFRvIG1lIHRoZSBj
cmVhdGlvbiBzaG91bGQgYmUgb24gdGhlIHNpZGUgdGhhdCBhY3R1YWxseSBuZWVkcy93aWxsIHVz
ZQ0KPj4+IHRoZSBuZXcgcG9ydC4gQW5kIGlmIGl0J3Mgbm90IGVzd2l0Y2ggbWFuYWdlciB0aGVu
IGVzd2l0Y2ggbWFuYWdlcg0KPj4+IG5lZWRzIHRvIGFjayBpdC4NCj4+PiAgDQo+Pg0KPj4gVGhl
cmUgYXJlIGZldyByZWFzb25zIHRvIGNyZWF0ZSB0aGVtIG9uIGVzd2l0Y2ggbWFuYWdlciBzeXN0
ZW0gYXMgYmVsb3cuDQo+Pg0KPj4gMS4gQ3JlYXRpb24gYW5kIGRlbGV0aW9uIG9uIG9uZSBzeXN0
ZW0gYW5kIHN5bmNocm9uaXppbmcgaXQgd2l0aCBlc3dpdGNoDQo+PiBzeXN0ZW0gcmVxdWlyZXMg
bXVsdGlwbGUgYmFjay1uLWZvcnRoIGNhbGxzIGJldHdlZW4gdHdvIHN5c3RlbXMuDQo+Pg0KPj4g
Mi4gV2hlbiB0aGlzIGhhcHBlbnMsIHN5c3RlbSB3aGVyZSBpdHMgY3JlYXRlZCwgZG9lc24ndCBr
bm93IHdoZW4gaXMgdGhlDQo+PiByaWdodCB0aW1lIHRvIHByb3Zpc2lvbiB0byBhIFZNIG9yIHRv
IGEgYXBwbGljYXRpb24uDQo+PiB1ZGV2L3N5c3RlbWQvTmV0d29yayBNYW5hZ2VyIGFuZCBvdGhl
cnMgc3VjaCBzb2Z0d2FyZSBtaWdodCBhbHJlYWR5DQo+PiBzdGFydCBpbml0aWFsaXppbmcgaXQg
ZG9pbmcgREhDUCBidXQgaXRzIHN3aXRjaCBzaWRlIGlzIG5vdCB5ZXQgcmVhZHkuDQo+IA0KPiBO
ZXR3b3JraW5nIHNvZnR3YXJlIGNhbiBkZWFsIHdpdGggbGluayBkb3duLi4NCj4gDQpTZXJ2aW5n
IGEgaGFsZiBjb29rZWQgZGV2aWNlIHRvIGFuIGFwcGxpY2F0aW9uIGlzIGp1c3Qgbm90IGdvaW5n
IHRvDQp3b3JrLiBJdCBpcyBub3QganVzdCBsaW5rIHN0YXR1cy4NCkEgdHlwaWNhbCBkZXNpcmVk
IGZsb3cgaXM6DQoNCjEuIGNyZWF0ZSBkZXZpY2UNCjIuIGNvbmZpZ3VyZSBtYWMgYWRkcmVzcw0K
My4gY29uZmlndXJlIGl0cyByYXRlIGxpbWl0cw0KNC4gc2V0dXAgcG9saWN5LCBlbmNhcC9kZWNh
cCBzZXR0aW5ncyB2aWEgdGMgb2ZmbG9hZHMgZXRjDQo1LiBicmluZyB1cCB0aGUgbGluayB2aWEg
cmVwDQo2LiBhY3RpdmF0ZSB0aGUgZGV2aWNlIGFuZCBhdHRhY2ggaXQgdG8gYXBwbGljYXRpb24N
Cg0KT2Z0ZW4gYWRtaW5pc3RyYXRvciB3YW50cyB0byBhc3NpZ24vZG8gKDIpLCBldmVuIHRob3Vn
aCB1c2VyIGlzIGZyZWUgdG8NCmNoYW5nZSBpdCBsYXRlciBvbi4NCg0KVGhpcyBjYW4gb25seSB3
b3JrIGlmIHVzZXIgc3lzdGVtIGFuZCBlc3dpdGNoIGhhcyBzZWN1cmUgY2hhbm5lbA0KZXN0YWJs
aXNoZWQgd2hpY2ggb2Z0ZW4gaXMganVzdCBub3QgYXZhaWxhYmxlLg0KDQpJbiBvdGhlciB1c2Ug
Y2FzZSB1c2VyIHN5c3RlbSB0byBkZWZpbmUgbmV0d29ya0lkIGlzIG5vdCB0cnVzdGVkLg0KSW4g
dGhpcyBjYXNlIHRoZXJlIGlzIHNvbWUgYXJiaXRyYXJ5L3VuZGVmaW5lZCBvbiB3YWl0IHRpbWUg
YXQgdXNlciBob3N0DQp0byBrbm93IHRoYXQgMiB0byA2IGFyZSBkb25lLg0KDQp2cyBkb2luZyBz
dGVwLTEgdG8gNiBvbiBlc3dpdGNoIHNpZGUgYnkgdHJ1c3RlZCBlbnRpdHkgYW5kIGF0dGFjaGlu
ZyBpdA0KdG8gc3lzdGVtIHdoZXJlIGl0IGlzIGRlc2lyZWQgdG8gdXNlIGlzIGVsZWdhbnQsIHNl
Y3VyZS4NCg0KbmV0d29ya0lEIGlzIHJlYWQgb25seSBmb3IgdGhlIHN5c3RlbSB3aGVyZSB0aGlz
IGlzIGRlcGxveWVkLg0KDQpBIGFwcGxpY2F0aW9uL3ZtL2NvbnRhaW5lciBtYXkgaGF2ZSBvbmUg
b3IgbW9yZSBzdWNoIGRldmljZXMgdGhhdCBuZWVkcw0KdG8gYmUgcHJlc2VudCBmb3IgdGhlIGxp
ZmUgb2YgaXQgcmVnYXJkbGVzcyBvZiBpdHMgbGluayBzdGF0dXMuDQoNCmxpbmsgZG93biA9PiBk
ZXRhY2ggZGV2aWNlIGZyb20gY29udGFpbmVyL3ZtDQpsaW5rIHVwID0+IGF0dGFjaCBkZXZpY2Ug
ZnJvbSBjb250YWluZXIvdm0gaXMgbm90IHJpZ2h0Lg0KSGVuY2UgcG9ydCBsaW5rIHN0YXR1cyBk
b2Vzbid0IGRyaXZlIGRldmljZSBzdGF0dXMuDQoNCj4+IFNvIGl0IGlzIGRlc2lyZWQgdG8gbWFr
ZSBzdXJlIHRoYXQgb25jZSBkZXZpY2UgaXMgZnVsbHkNCj4+IHJlYWR5L2NvbmZpZ3VyZWQsIGl0
cyBhY3RpdmF0ZWQuDQo+Pg0KPj4gMy4gQWRkaXRpb25hbGx5IGl0IGRvZXNuJ3QgZm9sbG93IG1p
cnJvciBzZXF1ZW5jZSBkdXJpbmcgZGVsZXRpb24gd2hlbg0KPj4gY3JlYXRlZCBvbiBob3N0Lg0K
PiANCj4gV2h5IHNvPyBTdXJlbHkgaG9zdCBuZWVkcyB0byByZXF1ZXN0IGRlbGV0aW9uLCBvdGhl
cndpc2UgY29udGFpbmVyDQo+IGdpdmVuIG9ubHkgYW4gU0YgY291bGQgYmUgY3V0IG9mZj8NCj4g
DQpjcmVhdGlvbiBmcm9tIHVzZXIgc3lzdGVtLA0KKGEpIGNyZWF0ZSBkZXZpY2UNCihiKSBjb25m
aWd1cmUgZGV2aWNlDQooYykgc3luY2hyb25vdXMga2ljayB0byBjcmVhdGUgcmVwIG9uIG90aGVy
IHN5c3RlbSAoaW52b2x2aW5nIHN3KQ0KDQpkZWxldGlvbiBmcm9tIHVzZXIgc3lzdGVtIHNob3Vs
ZCBiZSwNCihkKSBzeW5jaHJvbm91cyBraWNrIHRvIGRlbGV0ZSByZXAgb24gb3RoZXIgc3lzdGVt
IChpbnZvbHZpbmcgc3cpDQooZSkgdW5jb25maWcgdGhlIGRldmljZQ0KKGYpIGRlbGV0ZSB0aGUg
ZGV2aWNlDQoNClRvIGFjaGlldmUgdGhpcyBtaXJyb3IgYSBzdyBzeW5jaHJvbml6YXRpb24gaXMg
bmVlZGVkLCBub3QganVzdCB3aXRoIGRldmljZS4NCg0KRXZlbiBpZiB0aGlzIGlzIGFjaGlldmVk
IHNvbWVob3csIGl0IGRvZXNuJ3QgYWRkcmVzcyB0aGUgaXNzdWUgb2YNCnVudHJ1c3RlZCB1c2Vy
IHN5c3RlbSBub3QgaGF2aW5nIHByaXZpbGVnZSB0byBjcmVhdGUgdGhlIGRldmljZSB3aXRoDQpn
aXZlbiBOZXR3b3JrSUQuDQoNCj4+IDQuIGVzd2l0Y2ggYWRtaW5pc3RyYXRvciBzaW1wbHkgZG9l
c24ndCBoYXZlIGRpcmVjdCBhY2Nlc3MgdG8gdGhlIHN5c3RlbQ0KPj4gd2hlcmUgdGhpcyBkZXZp
Y2UgaXMgdXNlZC4gU28gaXQganVzdCBjYW5ub3QgYmUgY3JlYXRlZCB0aGVyZSBieSBlc3dpdGNo
DQo+PiBhZG1pbmlzdHJhdG9yLg0KPiANCj4gUmlnaHQsIHRoYXQgaXMgdGhlIHBvaW50LiBJdCdz
IHRoZSBob3N0IGFkbWluIHRoYXQgd2FudHMgdGhlIG5ldw0KPiBlbnRpdHksIHNvIGlmIHBvc3Np
YmxlIGl0J2QgYmUgYmV0dGVyIGlmIHRoZXkgY291bGQganVzdCBhc2sgZm9yIGl0IA0KPiB2aWEg
ZGV2bGluayByYXRoZXIgdGhhbiBzb21lIGNsb3VkIEFQSS4gTm90IHRoYXQgSSdtIGNvbXBsZXRl
bHkgb3Bwb3NlZA0KPiB0byBhIGNsb3VkIEFQSSAtIGp1c3Qgc2VlbXMgdW5uZWNlc3NhcnkgaGVy
ZS4NCj4gDQoNCkZsb3cgaXM6DQp0cnVzdGVkX2FkbWluaXN0YXRvci0+Y2xvdWRfYXBpLT5zbWFy
dG5pYy0+ZGV2bGlua19jcmVhdGUsY29uZmlnLGRlcGxveS0+Z2V0X2RldmljZV9vbl91c2VyX3N5
c3RlbS4NCg0KdW50cnVzdGVkX3VzZXJfc3lzdGVtLT5xdWVyeV9uZXR3b3JrX2lkLT5hdHRhY2hf
dG9fY29udGFpbmVyL3ZtL2FwcGxpY2F0aW9uLg0K
