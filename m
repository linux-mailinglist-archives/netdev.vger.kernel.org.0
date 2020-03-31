Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B876198D4D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 09:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgCaHqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 03:46:04 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:28868
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726636AbgCaHqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 03:46:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kT1mvXmbRVwKnZOfV9VB8m5AyKZYOCNnzm2wPdsUz4ppOPZ/EQlhWo0iHHiNA9yrv+X8qDVZFLwesRjtfHoCn5kA17RsmZT4bjy9B9qGWJoEtxlwqT0b+2JCfyFk/SddJNFdlb7KvngF3PYAIBVgtdfHdUgJRqkHReBvXLjY1WA1DsD3fQussr780SUbjYoZCCbBvmLwnJgjDYQ/FhMpII7AqPth21gYbHGgYKPoXcmrRpzhMGuhHUpPuLZZ1gLjcQR0ZQqX/JtLciuV27gml2VXWqbDCV58+sx4qWlvxSjcIvAxu/r4HObUrdEMxkZaq8erApmVqqJEQz8DZ95zNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GIXUy2c7TMnC/t1Ea8Sb4+5heaACREBXyNtzUKi1cY=;
 b=ewuZ+/n85ZWRQfE95eTPK1uOOS+DpvlLwm32u0P0dloBYynPQY2VsMTfnWWQHq4bx3uDuCZKPBLBjI8nSWg6G1x9IxId6m852tdsI2gPoFyIBm2RI63oA0YR1wlQaCnk7u8lBVEfXJ4G7k2g9Um5+bSgVHM3KJyvR0viVKxoWNKKHJvpwK6totfUJ/9T/oNjDqBxzYZHmQyzmIEh68kKuoptYA8wznF4aJgsUgawzvOk8mGGw8vJjnmeSAWQs/dpTjtOOY31zKDJ3X6d0+W6qI9s1ZiLo9PeDGRTWtUBoyuPkI+S7Ag18PCbVF5B6n7vYD/9oS1wRNtG7Hc+8961hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1GIXUy2c7TMnC/t1Ea8Sb4+5heaACREBXyNtzUKi1cY=;
 b=sHkmqubfkTPcu+mpGg9wzwfvMbET3yeM3Quq/fpQOs/WC3SGyZ0q4VutCZKvmZKheYk73atehvFjke9tMLnrhXRVZWr+xchqFQSwmfz9GqGyFCtzyC+XvHG8w4DuWolKPYd4+3dHEkOHmIvsGSWoQl4z2Z0486PCrvjS5Fmn+Zc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5747.eurprd05.prod.outlook.com (20.178.113.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Tue, 31 Mar 2020 07:45:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 07:45:51 +0000
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
Thread-Index: AQHV/iRsiKU58im38Um7T8fyNtLerKhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAQi9ACAAMW/gIAAy84A
Date:   Tue, 31 Mar 2020 07:45:51 +0000
Message-ID: <50c0f739-592e-77a4-4872-878f99cc8b93@mellanox.com>
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
 <20200327093829.76140a98@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <35e8353f-2bfc-5685-a60e-030cd2d2dd24@mellanox.com>
 <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330123623.634739de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 50640aa3-4996-4d2d-4cae-08d7d5478959
x-ms-traffictypediagnostic: AM0PR05MB5747:|AM0PR05MB5747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5747C9E53153E902E7EF2708D1C80@AM0PR05MB5747.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(186003)(54906003)(71200400001)(55236004)(81166006)(316002)(53546011)(2906002)(31696002)(36756003)(7416002)(2616005)(6506007)(26005)(66446008)(8676002)(6916009)(478600001)(8936002)(6512007)(5660300002)(31686004)(81156014)(66556008)(76116006)(4326008)(91956017)(66946007)(64756008)(6486002)(66476007)(86362001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ELiBsovKZ8v2dg/sJj8/a180za/Aa91dLWp5h+3d46TL12MYnFg86MkhPNycYERUmgUDf5tc5X0XnVDGBynwWIN83ZdEBCuG2FT7zL9dT2yPxRjnmoojvFtxIGuoyh0huJ27fgctFPE4j0WqcSxoCnoP6duTEs3sTK11a6CQL5NcccQr0tPDonH2kA5fqkmRi/b5XylvitSfu4RlgY3PYPqoO7dOCWrhteY0f7S53xTMdma+jQPnD47nd0sJWkhNEAoWFwlZhKfpVh5W3gHer8+8ULNrzdQlYvON2u83Cd/oJgIlXqxETQx/9FVITOsCqZkxYo7YEhjPXFM9hTsojJit7RB9Sjtc69l6c3CwG3bBW+7EtJ6X2wDFfmQkp8txalWphamxHAe04OcEdVNc82/4nhGoGg4ooxzWQCD+0Yuq9Tgt3LL/MilMTq30+8de
x-ms-exchange-antispam-messagedata: PyFGu82jHAquAOa1NQznw/9Q5XbVihTkjdlRjHctUpgOOjcJUIlTSF72pNUyNMwBzLAJJCarf3OPSSuhbDnNYtL5K0HXJ0hVJt+tM4JL1nMKbMPcct1qp2mJXtaf57T6H8cXyN++oasFmsxCu3vk5Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <9820DB712E7F944499895CC2C3E7C484@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50640aa3-4996-4d2d-4cae-08d7d5478959
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 07:45:51.8670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELOsB+kR3iu3Zc0NdtTs2Oqbayj9srXxFr2ILYgFTLEfoANVfrNeov697YdczoawOahpbxP1N+xHD6EaDrLIGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5747
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMy8zMS8yMDIwIDE6MDYgQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiBPbiBNb24sIDMw
IE1hciAyMDIwIDA3OjQ4OjM5ICswMDAwIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4+IE9uIDMvMjcv
MjAyMCAxMDowOCBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+Pj4gT24gRnJpLCAyNyBNYXIg
MjAyMCAwODo0NzozNiArMDEwMCBKaXJpIFBpcmtvIHdyb3RlOiAgDQo+Pj4+PiBTbyB0aGUgcXVl
dWVzLCBpbnRlcnJ1cHRzLCBhbmQgb3RoZXIgcmVzb3VyY2VzIGFyZSBhbHNvIHBhcnQgDQo+Pj4+
PiBvZiB0aGUgc2xpY2UgdGhlbj8gICAgDQo+Pj4+DQo+Pj4+IFllcCwgdGhhdCBzZWVtcyB0byBt
YWtlIHNlbnNlLg0KPj4+PiAgDQo+Pj4+PiBIb3cgZG8gc2xpY2UgcGFyYW1ldGVycyBsaWtlIHJh
dGUgYXBwbHkgdG8gTlZNZT8gICAgDQo+Pj4+DQo+Pj4+IE5vdCByZWFsbHkuDQo+Pj4+ICANCj4+
Pj4+IEFyZSBwb3J0cyBhbHdheXMgZXRoZXJuZXQ/IGFuZCBzbGljZXMgYWxzbyBjb3ZlciBlbmRw
b2ludHMgd2l0aA0KPj4+Pj4gdHJhbnNwb3J0IHN0YWNrIG9mZmxvYWRlZCB0byB0aGUgTklDPyAg
ICANCj4+Pj4NCj4+Pj4gZGV2bGlua19wb3J0IG5vdyBjYW4gYmUgZWl0aGVyICJldGhlcm5ldCIg
b3IgImluZmluaWJhbmQiLiBQZXJoYXBzLA0KPj4+PiB0aGVyZSBjYW4gYmUgcG9ydCB0eXBlICJu
dmUiIHdoaWNoIHdvdWxkIGNvbnRhaW4gb25seSBzb21lIG9mIHRoZQ0KPj4+PiBjb25maWcgb3B0
aW9ucyBhbmQgd291bGQgbm90IGhhdmUgYSByZXByZXNlbnRvciAibmV0ZGV2L2liZGV2IiBsaW5r
ZWQuDQo+Pj4+IEkgZG9uJ3Qga25vdy4gIA0KPj4+DQo+Pj4gSSBob25lc3RseSBmaW5kIGl0IGhh
cmQgdG8gdW5kZXJzdGFuZCB3aGF0IHRoYXQgc2xpY2UgYWJzdHJhY3Rpb24gaXMsDQo+Pj4gYW5k
IHdoaWNoIHRoaW5ncyBiZWxvbmcgdG8gc2xpY2VzIGFuZCB3aGljaCB0byBQQ0kgcG9ydHMgKG9y
IHdoeSB3ZSBldmVuDQo+Pj4gaGF2ZSB0aGVtKS4NCj4+PiAgIA0KPj4gSW4gYW4gYWx0ZXJuYXRp
dmUsIGRldmxpbmsgcG9ydCBjYW4gYmUgb3ZlcmxvYWRlZC9yZXRyb2ZpdCB0byBkbyBhbGwNCj4+
IHRoaW5ncyB0aGF0IHNsaWNlIGRlc2lyZXMgdG8gZG8uDQo+IA0KPiBJIHdvdWxkbid0IHNheSBy
ZXRyb2ZpdHRlZCwgaW4gbXkgbWluZCBwb3J0IGhhcyBhbHdheXMgYmVlbiBhIHBvcnQgb2YgDQo+
IGEgZGV2aWNlLg0KPiANCkJ1dCBoZXJlIGEgbmV0d29ya2luZyBkZXZpY2UgaXMgZ2V0dGluZyBj
cmVhdGVkIG9uIGhvc3Qgc3lzdGVtIHRoYXQgaGFzDQpjb25uZWN0aW9uIHRvIGFuIGVzd2l0Y2gg
cG9ydC4NCg0KPiBKaXJpIGV4cGxhaW5lZCB0byBtZSB0aGF0IHRvIE1lbGxhbm94IHBvcnQgaXMg
cG9ydCBvZiBhIGVzd2l0Y2gsIG5vdA0KPiBwb3J0IG9mIGEgZGV2aWNlLiBXaGlsZSB0byBtZSAo
L05ldHJvbm9tZSkgaXQgd2FzIGFueSB3YXkgdG8gc2VuZCBvcg0KPiByZWNlaXZlIGRhdGEgdG8v
ZnJvbSB0aGUgZGV2aWNlLg0KPiANCj4gTm93IEkgdW5kZXJzdGFuZCB3aHkgdG8geW91IG52bWUg
ZG9lc24ndCBmaXQgdGhlIHBvcnQgYWJzdHJhY3Rpb24uDQo+IA0Kb2suIEdyZWF0Lg0KDQo+PiBG
b3IgdGhhdCBtYXR0ZXIgcmVwcmVzZW50b3IgbmV0ZGV2IGNhbiBiZSBvdmVybG9hZGVkL2V4dGVu
ZGVkIHRvIGRvIHdoYXQNCj4+IHNsaWNlIGRlc2lyZSB0byBkbyAoaW5zdGVhZCBvZiBkZXZsaW5r
IHBvcnQpLg0KPiANCj4gUmlnaHQsIGluIG15IG1lbnRhbCBtb2RlbCByZXByZXNlbnRvciBfaXNf
IGEgcG9ydCBvZiB0aGUgZXN3aXRjaCwgc28NCj4gcmVwciB3b3VsZCBub3QgbWFrZSBzZW5zZSB0
byBtZS4NCj4NClJpZ2h0LiBTbyBlc3dpdGNoIGRldmxpbmsgcG9ydCAocGNpcGYsIHBjaXZmKSBm
bGF2b3VycyBhcmUgYWxzbyBub3QgdGhlDQpyaWdodCBvYmplY3QgdG8gdXNlIGFzIGl0IHJlcHJl
c2VudHMgZXN3aXRjaCBzaWRlLg0KDQpTbyBlaXRoZXIgd2UgY3JlYXRlIGEgbmV3IGRldmxpbmsg
cG9ydCBmbGF2b3VyIHdoaWNoIGlzIGZhY2luZyB0aGUgaG9zdA0KYW5kIHJ1biB0aGUgc3RhdGUg
bWFjaGluZSBmb3IgdGhvc2UgZGV2bGluayBwb3J0cyBvciB3ZSBjcmVhdGUgYSBtb3JlDQpyZWZp
bmVkIG9iamVjdCBhcyBzbGljZSBhbmQgYW5jaG9yIHRoaW5ncyB0aGVyZS4NCg0KPj4gQ2FuIHlv
dSBwbGVhc2UgZXhwbGFpbiB3aHkgeW91IHRoaW5rIGRldmxpbmsgcG9ydCBzaG91bGQgYmUgb3Zl
cmxvYWRlZA0KPj4gaW5zdGVhZCBvZiBuZXRkZXYgb3IgYW55IG90aGVyIGtlcm5lbCBvYmplY3Q/
DQo+PiBEbyB5b3UgaGF2ZSBhbiBleGFtcGxlIG9mIHN1Y2ggb3ZlcmxvYWRlZCBmdW5jdGlvbmFs
aXR5IG9mIGEga2VybmVsIG9iamVjdD8NCj4+IExpa2Ugd2h5IG1hY3ZsYW4gYW5kIHZsYW4gZHJp
dmVycyBhcmUgbm90IGNvbWJpbmVkIHRvIGluIHNpbmdsZSBkcml2ZXINCj4+IG9iamVjdD8gV2h5
IHRlYW1pbmcgYW5kIGJvbmRpbmcgZHJpdmVyIGFyZSBjb21iaW5lZCBpbiBzaW5nbGUgZHJpdmVy
DQo+PiBvYmplY3Q/Li4uDQo+IA0KPiBJIHRoaW5rIGl0J3Mgbm90IG92ZXJsb2FkaW5nLCBidXQg
dGhlIGZhY3QgdGhhdCB3ZSBzdGFydGVkIHdpdGgNCj4gZGlmZmVyZW50IGRlZmluaXRpb25zLiBX
ZSAobWUgYW5kIHlvdSkgdHJpZWQgYWRkaW5nIHRoZSBQQ0llIHBvcnRzDQo+IGFyb3VuZCB0aGUg
c2FtZSB0aW1lLCBJIGd1ZXNzIHdlIHNob3VsZCBoYXZlIGR1ZyBpbnRvIHRoZSBkZXRhaWxzDQo+
IHJpZ2h0IGF3YXkuDQo+DQpZZXMuIDotKQ0KDQo+PiBVc2VyIHNob3VsZCBiZSBhYmxlIHRvIGNy
ZWF0ZSwgY29uZmlndXJlLCBkZXBsb3ksIGRlbGV0ZSBhICdwb3J0aW9uIG9mDQo+PiB0aGUgZGV2
aWNlJyB3aXRoL3dpdGhvdXQgZXN3aXRjaC4NCj4gDQo+IFJpZ2h0LCB0byBtZSBwb3J0cyBhcmUg
b2YgdGhlIGRldmljZSwgbm90IGVzd2l0Y2guDQo+IA0KVHJ1ZS4gV2UgYXJlIGFsaWduZWQgaGVy
ZS4NCg0KPj4gV2Ugc2hvdWxkbid0IGJlIHN0YXJ0aW5nIHdpdGggcmVzdHJpY3RpdmUvbmFycm93
IHZpZXcgb2YgZGV2bGluayBwb3J0Lg0KPj4NCj4+IEludGVybmFsbHkgd2l0aCBKaXJpIGFuZCBv
dGhlcnMsIHdlIGFsc28gZXhwbG9yZWQgdGhlIHBvc3NpYmlsaXR5IHRvDQo+PiBoYXZlICdtZ210
dmYnLCAnbWdtdHBmJywgICdtZ210c2YnIHBvcnQgZmxhdm91cnMgYnkgb3ZlcmxvYWRpbmcgcG9y
dCB0bw0KPj4gZG8gYWxsIHRoaW5ncyBhcyB0aGF0IG9mIHNsaWNlLg0KPj4gSXQgd2Fzbid0IGVs
ZWdhbnQgZW5vdWdoLiBXaHkgbm90IGNyZWF0ZSByaWdodCBvYmplY3Q/DQo+IA0KPiBXZSBqdXN0
IG5lZWQgY2xlYXIgZGVmaW5pdGlvbnMgb2Ygd2hhdCBnb2VzIHdoZXJlLiANClllcy4NClRoZSBw
cm9wb3NhbCBpcyBzdHJhaWdodCBmb3J3YXJkIGhlcmUuDQp0aGF0IGlzLA0KKGEpIGlmIGEgdXNl
ciB3YW50cyB0byBjb250cm9sL21vbml0b3IgcGFyYW1zIG9mIHRoZSBQRi9WRi9TRiB3aGljaCBp
cw0KZmFjaW5nIHRoZSBwYXJ0aWN1bGFyIGZ1bmN0aW9uIChQRi9WRi9TRiksIHN1Y2ggYXMgbWFj
LCBpcnEsIG51bV9xcywNCnN0YXRlIG1hY2hpbmUgZXRjLA0KVGhvc2UgYXJlIGFuY2hvcmVkIGF0
IHRoZSBzbGljZSAocG9ydGlvbiBvZiB0aGUgZGV2aWNlKSBsZXZlbC4NCkkgZGV0YWlsIGhvdyB0
aGUgd2hvbGUgcGx1bWJpbmcgaW4gdGhlIGV4dGVuZGVkIFJGQyBjb250ZW50IGluIHRoZQ0KdGhy
ZWFkIHlkYXkuDQoNCihiKSBpZiBhIHVzZXIgd2FudHMgdG8gY29udHJvbC9tb25pdG9yIHBhcmFt
cyB3aGljaCBhcmUgdG93YXJkcyB0aGUNCmVzd2l0Y2ggbGV2ZWwsIHRoZXkgYXJlIGVpdGhlciBk
b25lIHRocm91Z2ggcmVwcmVzZW50b3IgbmV0ZGV2IG9yDQpkZXZsaW5rIGVzd2l0Y2ggc2lkZSBw
b3J0Lg0KRm9yIGV4YW1wbGUsIGVzd2l0Y2ggcGNpIHZmJ3MgaW50ZXJuYWwgZmxvdyB0YWJsZSBz
aG91bGQgYmUgZXhwb3NlZCB2aWENCmRwaXBlIGxpbmtlZCB0byBlc3dpdGNoIGRldmxpbmsgcG9y
dC4NCg0KDQo+IFdlIGFscmVhZHkgaGF2ZQ0KPiBwYXJhbXMgZXRjLiBoYW5naW5nIG9mZiB0aGUg
cG9ydHMsIGluY2x1ZGluZyBpcnEvc3Jpb3Ygc3R1ZmYuIEJ1dCBpbg0KPiBzbGljZSBtb2RlbCB0
aG9zZSBkb24ndCBiZWxvbmcgdGhlcmUgOlMNCj4gDQpJIGxvb2tlZCBhdCB0aGUgRGF2ZU0gbmV0
LW5leHQgdHJlZSB0b2RheS4NCk9ubHkgZHJpdmVyIHRoYXQgdXNlcyBkZXZsaW5rIHBvcnQgcGFy
YW1zIGlzIGJueHQuIEV2ZW4gdGhpcyBkcml2ZXINCnJlZ2lzdGVycyBlbXB0eSBhcnJheSBvZiBw
b3J0IHBhcmFtZXRlcnMuDQpzcmlvdi9pcnEgc3R1ZmYgY3VycmVudGx5IGhhbmdpbmcgb2ZmIGF0
IHRoZSBkZXZsaW5rIGRldmljZSBsZXZlbCBmb3INCml0cyBvd24gZGV2aWNlLg0KQ2FuIHlvdSBw
bGVhc2UgcHJvdmlkZSBsaW5rIHRvIGNvZGUgdGhhdCB1c2VzIGRldmxpbmsgcG9ydCBwYXJhbXM/
DQoNCj4gSW4gZmFjdCB2ZXJ5IGxpdHRsZSBiZWxvbmdzIHRvIHRoZSBwb3J0IGluIHRoYXQgbW9k
ZWwuIFNvIHdoeSBoYXZlDQo+IFBDSSBwb3J0cyBpbiB0aGUgZmlyc3QgcGxhY2U/DQo+DQpmb3Ig
ZmV3IHJlYXNvbnMuDQoxLiBQQ0kgcG9ydHMgYXJlIGVzdGFibGlzaGluZyB0aGUgcmVsYXRpb25z
aGlwIGJldHdlZW4gZXN3aXRjaCBwb3J0IGFuZA0KaXRzIHJlcHJlc2VudG9yIG5ldGRldmljZS4N
ClJlbHlpbmcgb24gcGxhaW4gbmV0ZGV2IG5hbWUgZG9lc24ndCB3b3JrIGluIGNlcnRhaW4gcGNp
IHRvcG9sb2d5IHdoZXJlDQpuZXRkZXYgbmFtZSBleGNlZWRzIDE1IGNoYXJhY3RlcnMuDQoyLiBo
ZWFsdGggcmVwb3J0ZXJzIGNhbiBiZSBhdCBwb3J0IGxldmVsLg0KMy4gSW4gZnV0dXJlIGF0IGVz
d2l0Y2ggcGNpIHBvcnQsIEkgd2lsbCBiZSBhZGRpbmcgZHBpcGUgc3VwcG9ydCBmb3IgdGhlDQpp
bnRlcm5hbCBmbG93IHRhYmxlcyBkb25lIGJ5IHRoZSBkcml2ZXIuDQo0LiBUaGVyZSB3ZXJlIGlu
Y29uc2lzdGVuY3kgYW1vbmcgdmVuZG9yIGRyaXZlcnMgaW4gdXNpbmcvYWJ1c2luZw0KcGh5c19w
b3J0X25hbWUgb2YgdGhlIGVzd2l0Y2ggcG9ydHMuIFRoaXMgaXMgY29uc29saWRhdGVkIHZpYSBk
ZXZsaW5rDQpwb3J0IGluIGNvcmUuIFRoaXMgcHJvdmlkZXMgY29uc2lzdGVudCB2aWV3IGFtb25n
IGFsbCB2ZW5kb3IgZHJpdmVycy4NCg0KU28gUENJIGVzd2l0Y2ggc2lkZSBwb3J0cyBhcmUgdXNl
ZnVsIHJlZ2FyZGxlc3Mgb2Ygc2xpY2UuDQoNCj4+IEFkZGl0aW9uYWxseSBkZXZsaW5rIHBvcnQg
b2JqZWN0IGRvZXNuJ3QgZ28gdGhyb3VnaCB0aGUgc2FtZSBzdGF0ZQ0KPj4gbWFjaGluZSBhcyB0
aGF0IHdoYXQgc2xpY2UgaGFzIHRvIGdvIHRocm91Z2guDQo+PiBTbyBpdHMgd2VpcmQgdGhhdCBz
b21lIGRldmxpbmsgcG9ydCBoYXMgc3RhdGUgbWFjaGluZSBhbmQgc29tZSBkb2Vzbid0Lg0KPiAN
Cj4gWW91IG1lYW4gZm9yIFZGcz8gSSB0aGluayB5b3UgY2FuIGFkZCB0aGUgc3RhdGVzIHRvIHRo
ZSBBUEkuDQo+IA0KQXMgd2UgYWdyZWVkIGFib3ZlIHRoYXQgZXN3aXRjaCBzaWRlIG9iamVjdHMg
KGRldmxpbmsgcG9ydCBhbmQNCnJlcHJlc2VudG9yIG5ldGRldikgc2hvdWxkIG5vdCBiZSB1c2Vk
IGZvciAncG9ydGlvbiBvZiBkZXZpY2UnLA0KDQp3ZSBjZXJ0YWlubHkgbmVlZCB0byBjcmVhdGUg
ZWl0aGVyDQooYSkgbmV3IGRldmxpbmsgcG9ydHMgYW5kIHRoZWlyIGhvc3QgZmFjaW5nIGZsYXZv
dXIocykgYW5kIHJ1biBzdGF0ZQ0KbWFjaGluZSBmb3IgaXQNCm9yDQooYikgbmV3IGRldmxpbmsg
c2xpY2Ugb2JqZWN0IHRoYXQgcmVwcmVzZW50cyB0aGUgJ3BvcnRpb24gb2YgdGhlIGRldmljZScu
DQoNCldlIGNhbiBhZGQgdGhlIHN0YXRlIG1hY2hpbmUgdG8gdGhlIHBvcnQuIEhvd2V2ZXIgaXQg
c3VmZmVycyBmcm9tIGlzc3VlDQp0aGF0IGNlcnRhaW4gZmxhdm91ciBhcyBwaHlzaWNhbCwgZHNh
LCBlc3dpdGNoIHBvcnRzIGV0YyBkb2Vzbid0IGhhdmUNCm5vdGlvbiBvZiBzdGF0ZSBtYWNoaW5l
LCBhdHRhY2htZW50IHRvIGRyaXZlciBldGMuDQoNClRoaXMgaXMgd2hlcmUgSSBmaW5kIGl0IHRo
YXQgd2UgYXJlIG92ZXJsb2FkaW5nIHRoZSBwb3J0IGJleW9uZCBpdHMNCmN1cnJlbnQgZGVmaW5p
dGlvbi4gQW5kIGV4dGVuc2lvbnMgZG9lc24ndCBzZWVtIHRvIGJlY29tZSBhcHBsaWNhYmxlIGlu
DQpmdXR1cmUgb24gdGhvc2UgcG9ydHMuDQoNCkEgJ3BvcnRpb24gb2YgdGhlIGRldmljZScgYXMg
aW5kaXZpZHVhbCBvYmplY3QgdGhhdCBvcHRpb25hbGx5IGNhbiBiZQ0KbGlua2VkIHRvIGVzd2l0
Y2ggcG9ydCBtYWRlIG1vcmUgc2Vuc2UuIChsaWtlIGhvdyBhIGRldmxpbmsgcG9ydA0Kb3B0aW9u
YWxseSBsaW5rcyB0byByZXByZXNlbnRvcikuDQoNCj4+PiBXaXRoIGRldmljZXMgbGlrZSBORlAg
YW5kIE1lbGxhbm94IENYMyB3aGljaCBoYXZlIG9uZSBQQ0kgUEYgbWF5YmUgaXQNCj4+PiB3b3Vs
ZCBoYXZlIG1hZGUgc2Vuc2UgdG8gaGF2ZSBhIHNsaWNlIHRoYXQgY292ZXJzIG11bHRpcGxlIHBv
cnRzLCBidXQNCj4+PiBpdCBzZWVtcyB0aGUgcHJvcG9zYWwgaXMgdG8gaGF2ZSBwb3J0IHRvIHNs
aWNlIG1hcHBpbmcgYmUgMToxLiBBbmQgcmF0ZQ0KPj4+IGluIHRob3NlIGRldmljZXMgc2hvdWxk
IHN0aWxsIGJlIHBlciBwb3J0IG5vdCBwZXIgc2xpY2UuDQo+Pj4gICANCj4+IFNsaWNlIGNhbiBo
YXZlIG11bHRpcGxlIHBvcnRzLiBzbGljZSBvYmplY3QgZG9lc24ndCByZXN0cmljdCBpdC4gVXNl
cg0KPj4gY2FuIGFsd2F5cyBzcGxpdCB0aGUgcG9ydCBmb3IgYSBkZXZpY2UsIGlmIGRldmljZSBz
dXBwb3J0IGl0Lg0KPiANCj4gT2theSwgc28gc2xpY2VzIGFyZSBub3QgMToxIHdpdGggcG9ydHMs
IHRoZW4/ICBJcyBpdCBhbnk6YW55Pw0KPiANCkEgc2xpY2UgY2FuIGF0dGFjaCB0byBvbmUgb3Ig
bW9yZSBlc3dpdGNoIHBvcnQsIGlmIHNsaWNlIHdhbnRzIHRvDQpzdXBwb3J0IGVzd2l0Y2ggb2Zm
bG9hZHMgZXRjLg0KDQpBIHNsaWNlIHdpdGhvdXQgZXN3aXRjaCwgY2FuIGhhdmUgemVybyBlc3dp
dGNoIHBvcnRzIGxpbmtlZCB0byBpdC4NCg==
