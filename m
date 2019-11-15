Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FADEFE4EA
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbfKOSXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:23:10 -0500
Received: from mail-eopbgr80041.outbound.protection.outlook.com ([40.107.8.41]:13191
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726131AbfKOSXK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Nov 2019 13:23:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx/z2XxJ3tlrGyiGMp5AMCrA6NMBKwkI2MQPFRMBY7PvYr0FPt0QZ9Bsv8Wu9YJcfoJTINHlXxqujNsIWVDmzNHPvL1nZ2VtLVg+D0AYOQp8rFv1eaJfgLuXmphim9eRhSQtUNAd1gllTfwxuCS5h/gd+uJ1BPEbgBva5j0HiECV2Ky+gUjLeQefaUM30RdtIHpATFpK9xPQqX3Zb+2loA8kDXlkXMzSQuzZJ1BZaM0L6BuAFeD9kCw5zX6olalxNHVXnXaFfUIVAAl4pez/pZy3+FYEtT6Rz0j7YYtCgBjMfQgH6MrTdMcqPY5L+zm+E8Ii/gBSKsFoH4dDifIykw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCuFB1NlSETFlQt0aAJ/S+qQ9YJrEnm3XGfUhR80rxU=;
 b=Tk0Om+eOffXxO2PnWvA//Rm9F6brocid48duaiYEgLAgRKw/ubX3n4CsjIrx8LKQMukQC5iltUhHC3u+fH/FuqK7t2DsW1ImEeKM1QFcmu8OA/5XhRnk59i3jVzPjJijICeMl7AN3fH26Zwmq6o3DsRIZe2Byp45mRpZ7oQ+QJ3SxbHw4mxGTlHdVH9l3AvcrfXXFSPWP0UpvzfekWZAye5s55Nxy5+rYpEFNPBVMgB6V/BJTdVvjQu1c6c+9G/QzfQVic0tFiiSqkJoMzBp69bsW2szbfoJf88D9w6t645ClS/c/ZpdS4ZQucGawkucl08qqS4fyXnpvwafzee6Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCuFB1NlSETFlQt0aAJ/S+qQ9YJrEnm3XGfUhR80rxU=;
 b=c/M1Pkzm32GGIDwVKdooQKQIeQgjnYejy5e+KlwKUrZKMzKAxNs2naGuo0etoNiOVIuZIH0ezXC8ltMR6Y3QOQ+hOs6ikso7V861PYQVIxyqZefANj767nB1vbFwl3jQUpci54VyQ8ls1n/BtQcsms0P/w866jPkYAOkPtPF2EM=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3298.eurprd05.prod.outlook.com (10.171.187.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Fri, 15 Nov 2019 18:23:06 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2451.023; Fri, 15 Nov 2019
 18:23:06 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "stefan.sorensen@spectralink.com" <stefan.sorensen@spectralink.com>,
        "brandon.streiff@ni.com" <brandon.streiff@ni.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>
Subject: Re: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Topic: [PATCH net 06/13] mlx5: reject unsupported external timestamp
 flags
Thread-Index: AQHVmxuuaGhUBoj4KkqsB9Kgi1dgk6eLWewAgAAUMICAAR8egA==
Date:   Fri, 15 Nov 2019 18:23:06 +0000
Message-ID: <fd597b44-1d5b-f79f-63b9-3dcc2e58b05f@mellanox.com>
References: <20191114184507.18937-7-richardcochran@gmail.com>
 <c90050bd6a63ef3a6f0c7ea999f44ec51c07e917.camel@mellanox.com>
 <02874ECE860811409154E81DA85FBB5896990AC2@ORSMSX121.amr.corp.intel.com>
In-Reply-To: <02874ECE860811409154E81DA85FBB5896990AC2@ORSMSX121.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-originating-ip: [2604:2000:1342:488:cc27:8e0e:9eda:f697]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 412767f5-5a56-474a-6d6d-08d769f8dc48
x-ms-traffictypediagnostic: AM4PR05MB3298:|AM4PR05MB3298:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB329886C5330B51C577D3E2F8BA700@AM4PR05MB3298.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(13464003)(199004)(189003)(66446008)(64756008)(6436002)(446003)(6116002)(11346002)(66476007)(6486002)(110136005)(76176011)(54906003)(71190400001)(71200400001)(476003)(2616005)(4001150100001)(186003)(229853002)(2201001)(305945005)(14454004)(7416002)(99286004)(7736002)(46003)(102836004)(6506007)(53546011)(478600001)(2906002)(66556008)(66946007)(6246003)(5660300002)(8676002)(4326008)(6512007)(91956017)(86362001)(36756003)(31686004)(8936002)(76116006)(256004)(81156014)(81166006)(316002)(486006)(31696002)(14444005)(25786009)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3298;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VZ7faVEQ7VxRb09G7LsaAanTx2UamyQfBzQ6x/nET7URKQXwjHKi9qSGnCQNefflLZmNTucRtUfq8mTnq3ttj/AhhEvYLQ15BMCQ4RNLdbF9PiUH9R8V08J/s++6V721tOuaKX33I30hSEoMuzJWqSxvLUS9/DzS/++hBmzevPcn1C1qcWir5acWCPIAm27U4vs79wvhd+p/U2QuJ7fWhOP7G+LLv3OnjZlkYnQjQxjnnkgHCTS+0i1Z4JoPnzUtRre6PCSNZogYOT8Y+8k2XK0mt/Sg+p7+BvOVtw3sV6LUDGtKQpa8f0i95B3EJFe2xGnkx/F7rRGZT8aILvBGfoeemkU8fXYuco1LL2siIcQS1lF+XhHckk//hR9lAq6ffKW1xXDVFIoNDuMQli6Q4mgN2di6ANc8xgUYbXWyb9iMlqT2x4CLh18WXoAHjHgu
Content-Type: text/plain; charset="utf-8"
Content-ID: <B8A696B78274B3409A549E6A010DC009@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 412767f5-5a56-474a-6d6d-08d769f8dc48
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 18:23:06.3315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y/bQyA1HN3/2UCHTWckk6VODJfYHjp6PgTN3bjAY/6BkPOvhF/fQStdKCtLXHhPVv+QguNV6Qh1ozokE6wF1aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3298
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTQvMTkgODoxNSBQTSwgS2VsbGVyLCBKYWNvYiBFIHdyb3RlOg0KPj4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4+IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KPj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE0LCAyMDE5IDQ6MDMgUE0NCj4+
IFRvOiBBcmllbCBMZXZrb3ZpY2ggPGxhcmllbEBtZWxsYW5veC5jb20+OyByaWNoYXJkY29jaHJh
bkBnbWFpbC5jb207DQo+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+PiBDYzogSGFsbCwgQ2hy
aXN0b3BoZXIgUyA8Y2hyaXN0b3BoZXIucy5oYWxsQGludGVsLmNvbT47IEV1Z2VuaWEgRW1hbnRh
eWV2DQo+PiA8ZXVnZW5pYUBtZWxsYW5veC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPj4g
c2VyZ2VpLnNodHlseW92QGNvZ2VudGVtYmVkZGVkLmNvbTsgRmVyYXMgRGFvdWQgPGZlcmFzZGFA
bWVsbGFub3guY29tPjsNCj4+IHN0ZWZhbi5zb3JlbnNlbkBzcGVjdHJhbGluay5jb207IGJyYW5k
b24uc3RyZWlmZkBuaS5jb207IEtlbGxlciwgSmFjb2IgRQ0KPj4gPGphY29iLmUua2VsbGVyQGlu
dGVsLmNvbT47IEtpcnNoZXIsIEplZmZyZXkgVCA8amVmZnJleS50LmtpcnNoZXJAaW50ZWwuY29t
PjsNCj4+IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBmZWxpcGUuYmFsYmlAbGlu
dXguaW50ZWwuY29tDQo+PiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCAwNi8xM10gbWx4NTogcmVq
ZWN0IHVuc3VwcG9ydGVkIGV4dGVybmFsIHRpbWVzdGFtcA0KPj4gZmxhZ3MNCj4+DQo+PiBPbiBU
aHUsIDIwMTktMTEtMTQgYXQgMTA6NDUgLTA4MDAsIFJpY2hhcmQgQ29jaHJhbiB3cm90ZToNCj4+
PiBGcm9tOiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4+Pg0KPj4+
IEZpeCB0aGUgbWx4NSBjb3JlIFBUUCBzdXBwb3J0IHRvIGV4cGxpY2l0bHkgcmVqZWN0IGFueSBm
dXR1cmUgZmxhZ3MNCj4+PiB0aGF0DQo+Pj4gZ2V0IGFkZGVkIHRvIHRoZSBleHRlcm5hbCB0aW1l
c3RhbXAgcmVxdWVzdCBpb2N0bC4NCj4+Pg0KPj4+IEluIG9yZGVyIHRvIG1haW50YWluIGN1cnJl
bnRseSBmdW5jdGlvbmluZyBjb2RlLCB0aGlzIHBhdGNoIGFjY2VwdHMNCj4+PiBhbGwNCj4+PiB0
aHJlZSBjdXJyZW50IGZsYWdzLiBUaGlzIGlzIGJlY2F1c2UgdGhlIFBUUF9SSVNJTkdfRURHRSBh
bmQNCj4+PiBQVFBfRkFMTElOR19FREdFIGZsYWdzIGhhdmUgdW5jbGVhciBzZW1hbnRpY3MgYW5k
IGVhY2ggZHJpdmVyIHNlZW1zDQo+Pj4gdG8NCj4+PiBoYXZlIGludGVycHJldGVkIHRoZW0gc2xp
Z2h0bHkgZGlmZmVyZW50bHkuDQo+Pj4NCj4+PiBbIFJDOiBJJ20gbm90IDEwMCUgc3VyZSB3aGF0
IHRoaXMgZHJpdmVyIGRvZXMsIGJ1dCBpZiBJJ20gbm90IHdyb25nDQo+Pj4gaXQNCj4+PiAgICAg
ICAgZm9sbG93cyB0aGUgZHA4MzY0MDoNCj4+Pg0KPj4gVGhlIGRyaXZlciB3aWxsIGNoZWNrIGlm
IHRoZSBQVFBfRkFMTElOR19FREdFIGZsYWcgd2FzIHNldCB0aGVuIGl0IHdpbGwNCj4+IHNldCBp
dCBpbiBIVywgaWYgbm90IHRoZW4gaXQgaXMgZ29pbmcgdG8gZGVmYXVsdCB0byBQVFBfUklTSU5H
X0VER0UsIHNvDQo+PiBMR1RNLg0KPj4NCj4+IFJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8
c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBCdXQgc2FtZSBzdG9yeSBoZXJlLCBvbGQgdG9v
bHMgdGhhdCBsYXppbHkgc2V0IDB4ZmZmZiBvciAweDAwMDAgYW5kDQo+PiBleHBlY3RlZCBldmVy
eSB0aGluZyB0byB3b3JrLi4gYWdhaW4gbm90IHN1cmUgaWYgdGhleSBkbyBleGlzdC4NCj4+DQo+
PiBBcmllbCBwbGVhc2UgaGF2ZSBhIGxvb2sgYXQgdGhpcyBwYXRjaC4NCj4+DQo+IEFzIGxvbmcg
YXMgdGhleSBzdGljayB0byB0aGUgb3JpZ2luYWwgaW9jdGxzIHRoaXMgd29uJ3QgYmUgYSBwcm9i
bGVtLCBiZWNhdXNlIHRoZSB2MSBpb2N0bCBub3cgZXhwbGljaXRseSBjbGVhcnMgdW5zdXBwb3J0
ZWQgYml0cyBiZWZvcmUgY2FsbGluZyBkcml2ZXIsIHNvIHRoaXMgY2hlY2sgd2lsbCBwYXNzLiBP
YnZpb3VzbHksIHRoaXMgY2hhbmdlIHNob3VsZCBub3QgYmUgYmFja3BvcnRlZCB0byBlYXJsaWVy
IHRoYW4gNS40IHdpdGhvdXQgYWxzbyBiYWNrcG9ydGluZyB0aGF0IG1hc2tpbmcgaW4gdGhlIG9y
aWdpbmFsIGlvY3RsIGZ1bmN0aW9ucy4NCj4NCj4gVGhhbmtzLA0KPiBKYWtlDQo+DQpBZ3JlZS4N
Cg0KSnVzdCBhIHNtYWxsIHN1Z2dlc3Rpb24sIHlvdSBjYW4gcGVyZm9ybSB0aGUgY2hlY2sgd2l0
aCBzaW1wbHkgDQpQVFBfRVhUVFNfVjFfVkFMSURfRkxBR1MuIEl0YWxyZWFkeSBjb21iaW5lcyBh
bGwgdGhlIGJpdHMgd2UgbmVlZCB0byBjaGVjay4NCg0K
