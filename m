Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BD3FF9EA
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 14:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbfKQNxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 08:53:05 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:34222
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfKQNxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Nov 2019 08:53:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfZqXMBD6MpPcuEHKt7SYAIxCviJ42zNicVaDD2sALAAoeiWcAGlmcdrNVPFfZDBDZQGsaHnL/KKOPy9j5y+0kgMxMFJoomy3439QfhR7HmNnBrbJEPdPkDwS1fRQJ0l6XRDqa3zb4LEYaUvmCwSSzYiget3xWuZFwrqpCw/XNrf4IlT1Sojmwx7gczexOKVGolaG1qCv7pNlYueB3pc0w/3N+ct5zQoO+r4gUOo31DLyi0CvNvy8n8FsrHi4L4diPzY4T8Bm5eHhkpmzUy++LUVFUq4oFQoUvhP18fRyptfk6TBqr1jlDy9BCOBShrTDw80OUCSc8HfcjmcKfUeNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJS5vJaJOZyM6R4UE+Utgxfd9yAGQgD7sNgc6GotUbw=;
 b=lXL3iI1tDREOFtiv0ccdKTDu/xPjVKFhKoP7i25565i5cJQTClz8346Bn4uJuSuiUfkITAR2z3WaEwWq2Kdr/x4YfqcSjCqcJwh/P3QBpSX5qP6WmyEoE9YCeYES4ibqOF2fum8x1/azA/cXyN69UzRga02VU33ibeC2o3EJiZOQysxW7p8ZsIq4x/LGx6wIT1LRIzy7mLY8iBb0D4nniAP27ze4TzTxQ8Ig8XCiNvprh+GsB+4KVPE1RvCZgDb2N/iVlJGkemnKvLshyKb4LWkhXqk3GhkTx3zRH+u0IJIHlN3KX4pwlhHxTpH+E9DXHPS09HzFy5ZrYLh4+rT6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WJS5vJaJOZyM6R4UE+Utgxfd9yAGQgD7sNgc6GotUbw=;
 b=snj7a4hU0Uzva3Yf6R4T/6hDEbsMUHjdxgITA2biVBVAQyoe0pPnPqIxq6oTHPZcB7wgvnu6RWKxORZqP6yHO+E7KmCoB6ko7BiO3LkgbAJlGtDCwUvlaTQJucgxMT2qcvRstuk1tMMCr4ikhFfcJGgGTf07NiqyN+0Cd0FLSEI=
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com (20.178.124.149) by
 VI1PR05MB5472.eurprd05.prod.outlook.com (20.177.63.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Sun, 17 Nov 2019 13:52:49 +0000
Received: from VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461]) by VI1PR05MB5680.eurprd05.prod.outlook.com
 ([fe80::b5cf:e640:40d3:b461%4]) with mapi id 15.20.2451.029; Sun, 17 Nov 2019
 13:52:49 +0000
From:   Shay Drory <shayd@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Maor Gottlieb <maorg@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "lennart@poettering.net" <lennart@poettering.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>
Subject: Re: Send SFP event from kernel driver to user space (UDEV)
Thread-Topic: Send SFP event from kernel driver to user space (UDEV)
Thread-Index: AQHVnTyemIrPi2KC+0KxDlDyt5FLmqePYhyA
Date:   Sun, 17 Nov 2019 13:52:48 +0000
Message-ID: <3b83c628-50f2-754e-5618-e1e14c7035ba@mellanox.com>
References: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
In-Reply-To: <a041bba0-83d1-331f-d263-c8cbb0509220@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shayd@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 770da4bb-462d-46c6-4de7-08d76b656ec0
x-ms-traffictypediagnostic: VI1PR05MB5472:|VI1PR05MB5472:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB54721A37B492D9A34B9A5AE0C2720@VI1PR05MB5472.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02243C58C6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(366004)(376002)(136003)(39860400002)(199004)(189003)(186003)(3846002)(446003)(5660300002)(2906002)(486006)(966005)(11346002)(476003)(71200400001)(71190400001)(6306002)(305945005)(229853002)(36756003)(6506007)(53546011)(7736002)(478600001)(316002)(6512007)(5640700003)(66066001)(6436002)(54906003)(31686004)(86362001)(66946007)(4326008)(66446008)(64756008)(1730700003)(81156014)(81166006)(26005)(8676002)(6246003)(2351001)(2616005)(76176011)(2501003)(102836004)(25786009)(6486002)(31696002)(8936002)(14454004)(99286004)(6116002)(256004)(76116006)(66476007)(66556008)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5472;H:VI1PR05MB5680.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DYGHs6CfoNO+EQYvIMN9YwF8Lc26AmrM/Rg7qEJEktoq24kjoptuK4WCpK7nGBAVJkicU2ccbkFPPwPti+EkFOA9jtRggQ1HJ4SaWbtqc7w4MSoAU2OoLk1P9/iFKNvHkLOh8tyhWkgMfAElfgMIDLR7uLQW/YuReeQ+Zl6rhAZRoysWQJYaSYz09c6c8dUJ0jNL+7oAzWXafK4lLMqFlDsm/c6qLG8/lHDXlNdnknw5o0d3ZulchX8rbYuWY7dG4NcVNTOxQ0fbwpZ0ND2LR4FJEV1IkBAdffPcBUH4PL8LVDM64WXcY6CZYf279h9te8Em5kyKCq6gaTOcMhchtHwJHiQt/WqS00/jeOcVhdefShm3fsIUXBwEY5OCkFSRnyV5AlH1FLADbBebNvwtriEi9ofRhWXJCm6KAJ7fQodAyAfsxGtT2+SB0HL3tHW1
Content-Type: text/plain; charset="utf-8"
Content-ID: <C88650D68B4FFB46A3974397CFD0BFB8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 770da4bb-462d-46c6-4de7-08d76b656ec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2019 13:52:48.8870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4bPJVivnijXG6J5BwQHcberomeNuBTyCMO5GHxuwKpUGDJZMfd86dQ//LQyQHHQHDn6mhUTRprg5QJrk6seeeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5472
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

K3JlbGV2YW50IHBlb3BsZQ0KDQpPbiAxMS8xNy8yMDE5IDEzOjQ2LCBTaGF5IERyb3J5IHdyb3Rl
Og0KPiBUb2RheSwgU0ZQIGluc2VydGVkIC8gcmVtb3ZhbCBldmVudCBpbXBhY3RzIG9ubHkgdGhl
IGtlcm5lbCBzcGFjZSBkcml2ZXJzLg0KPiBUaGVyZSBhcmUgdXNlcnMgd2hvIHdpc2hlcyB0byBn
ZXQgU0ZQIGluc2VydCAvIHJlbW92YWwgaW4gYSB1ZGV2LWV2ZW50DQo+IGZvcm1hdCBmb3IgdGhl
aXIgYXBwbGljYXRpb24gLyBkYWVtb25zIC8gbW9uaXRvcnMuDQo+IFRoZSBuYWl2ZSB3YXkgdG8g
aW1wbGVtZW50IHRoaXMgZmVhdHVyZSB3b3VsZCBiZSB0byBjcmVhdGUgYSBzeXNmcyBmaWxlDQo+
IHRoYXQgcmVwcmVzZW50cyBkZXZpY2UgU0ZQLCB0byBleHBvc2UgaXQgdW5kZXIgdGhlIG5ldGRl
diBzeXNmcywgYW5kDQo+IHRvIHJhaXNlIGEgdWRldiBldmVudCBvdmVyIGl0Lg0KPiBIb3dldmVy
LCBpdCBpcyBub3QgcmVhc29uYWJsZSB0byBjcmVhdGUgYSBzeXNmcyBmb3IgZWFjaCBuZXQtZGV2
aWNlLg0KPiBJbiB0aGlzIGxldHRlciwgSSB3b3VsZCBsaWtlIHRvIG9mZmVyIGEgbmV3IG1lY2hh
bmlzbSB0aGF0IHdpbGwgYWRkIGENCj4gc3VwcG9ydCB0byBzZW5kIFNGUCBldmVudHMgZnJvbSB0
aGUga2VybmVsIGRyaXZlciB0byB1c2VyIHNwYWNlLg0KPiBUaGlzIHN1Z2dlc3Rpb24gaXMgYnVp
bHQgdXBvbiBhIG5ldyBuZXRsaW5rIGluZnJhc3RydWN0dXJlIGZvciBldGh0b29sDQo+IGN1cnJl
bnRseSBiZWluZyB3cml0dGVuIGJ5IE1pY2hhbCBLdWJlY2t3aGljaCBjYWxsZWQg4oCcZXRodG9v
bC1uZXRsaW5r4oCdWzFdLg0KPiBNeSBzdWdnZXN0aW9uIGlzIHRvIGRvIGl0IGJ5IGFkZGluZyBh
IGZ1bmN0aW9uDQo+IChldGh0b29sX3NmcF9pbnN0ZXJ0ZWQvcmVtb3ZlZCguLi4pKSB0byBldGh0
b29sIEFQSSwgVGhpcyBmdW5jdGlvbiB3aWxsDQo+IHJhaXNlIGEgbmV0bGluayBldmVudCB0byBi
ZSBjYXVnaHQgaW4gdXNlciBzcGFjZS4NCj4gVGhlIGRlc2lnbjoNCj4NCj4gLSBTRlAgZXZlbnQg
ZnJvbSBOSUMgY2F1Z2h0IGJ5IHRoZSBkcml2ZXINCj4gLSBEcml2ZXIgY2FsbCBldGh0b29sX3Nm
cF9pbnNlcnRlZC9yZW1vdmVkKCkNCj4gLSBFdGh0b29sIGdlbmVyYXRlZCBuZXRsaW5rIGV2ZW50
IHdpdGggcmVsZXZhbnQgZGF0YQ0KPiAtIFRoaXMgZXZlbnQtbWVzc2FnZSB3aWxsIGJlIGhhbmRs
ZWQgaW4gdGhlIHVzZXItc3BhY2UgbGlicmFyeSBvZiBVREVWDQo+IChmb3IgdGhpcyBwdXJwb3Nl
IHdlIHdvdWxkIGxpa2UgdG8gYWRkIGEgbmV0bGluayBpbmZyYXN0cnVjdHVyZSB0byBVREVWDQo+
IHVzZXItc3BhY2UgbGlicmFyeSkuDQo+DQo+IHRoZSBmbG93IGluIHNjaGVtZToNCj4NCj4gVURF
ViAoaW4gc3lzdGVtZCkNCj4gICAgICAgICAgICAgICAgICAg4oaRDQo+IGV0aHRvb2xfbmV0bGlu
ayAoaW4gZXRodG9vbCkNCj4gICAgICAgICAgICAgICAgICAg4oaRDQo+IGRyaXZlciAobWx4NV9j
b3JlIGZvciBleGFtcGxlKQ0KPiAgICAgICAgICAgICAgICAgICDihpENCj4gTklDIChTRlAgZXZl
bnQpDQo+DQo+IFdvdWxkIGxpa2UgdG8gaGVhciB5b3VyIG9waW5pb24gb24gdGhpcyBzdWdnZXN0
aW9uLCBvciBvbiBhbHRlcm5hdGl2ZQ0KPiBkZXNpZ25zLg0KPg0KPiBUaGFua3MNCj4gU2hheSBE
cm9yeQ0KPg0KPiBbMV0NCj4gaHR0cHM6Ly9wYXRjaHdvcmsub3psYWJzLm9yZy9wcm9qZWN0L25l
dGRldi9saXN0Lz9zZXJpZXM9JnN1Ym1pdHRlcj0xMTg5MiZzdGF0ZT0qJnE9JmFyY2hpdmU9JmRl
bGVnYXRlPQ0KPg0KDQo=
