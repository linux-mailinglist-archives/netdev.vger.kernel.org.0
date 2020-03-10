Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12E2E180CA1
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 00:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgCJXyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 19:54:16 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:36051
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726380AbgCJXyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 19:54:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBuCxbFpjBHUoOhZQZip5Jjx3fe26gEseTF7rg7A2r99AUEyWsF7bbJl5Eg2UGVcQHzXz83k2kMLlIGhXW1sPBbz4cGrBtrh4EbZNJFxGd0600sIFqZZQH80cfrnpNy9+avxwE7D7YeVrqymIZGOH9LSp9FFqh4YYQC+7K9gaPKMP/U/zgraQ65eBlfOs2f+zmbNAncGG/79ZtEwlPO0/UaJ+LECKi6oPZIj3UXkQZ11UabkfatFvItdn8MEpukuAmDyU5wKmSxge3Del+tfSQjDRsw5zrGJPur6nQsKRaeHODhezQBop/0YIH7C482HVGUB28E590/K1Tg8cKWTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jc6eOumFZA8AZlvywpCFkCZsvC22GCSCDoNqUDa+dc=;
 b=e4gNovCZTxdaziAeITm+wCVDeCdL+ba4l8I+nRjo+wtLuHjxo6y2VdIP/TG09Mr1ean234Moyl1X3PE4I3GJVuKq3BucTJ89JnOC4THim6aNPqgABcExr0sVPYOFKosBX+VigkkyTCL+d0SLmNE9qMRXXeiGjB+hRwFK5bEofuzZmcn6fdv1H6pumknGu7crmOm0zCpZrLE/DIQKb1RhP0UeC74gpERUJ7vctulBcEib7UyRDooVUoqPj3WblOkwthtssplwITFv5NjMnHb0yVJNdiRiM+8xrikxaKMo6xDgutfENT5oNC92mSfih8FZqs1tvYMhiX+jjzjY7VYbrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jc6eOumFZA8AZlvywpCFkCZsvC22GCSCDoNqUDa+dc=;
 b=ZH7/Ygx04BC8qN6EHTrowyB02Lk9qCUdjYMaQSEzul51CPUxTBOvHglnPCHQ4dUZvHrUtm72PfacRkMN2jtvqyjEEzSzZkhiFVwlB2UL8xg1/YPVPMKemV30pjwoeWRM4cAQvnU1/dvnBZUU6O0+C5SQfeUL1UWy1m9xaB1uH/s=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6560.eurprd05.prod.outlook.com (20.179.26.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 23:53:29 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 23:53:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        Li Rongqing <lirongqing@baidu.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH] page_pool: use irqsave/irqrestore to protect ring access.
Thread-Topic: [PATCH] page_pool: use irqsave/irqrestore to protect ring
 access.
Thread-Index: AQHV9kvf9xbvvfqL9UebbKngICNOR6hBAJ0AgAAaiICAAH7CAIAAufuAgAAttAA=
Date:   Tue, 10 Mar 2020 23:53:28 +0000
Message-ID: <fb256e1ec90dc72893a76e6b85fb2ef340829aff.camel@mellanox.com>
References: <20200309194929.3889255-1-jonathan.lemon@gmail.com>
         <20200309.175534.1029399234531592179.davem@davemloft.net>
         <9b09170da05fb59bde7b003be282dfa63edd969e.camel@mellanox.com>
         <20200310110412.66b60677@carbon>
         <20200310140951.64a3a7dc@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200310140951.64a3a7dc@kicinski-fedora-PC1C0HJN>
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
x-ms-office365-filtering-correlation-id: 59e6b4c8-8bf4-4936-eaf6-08d7c54e3b58
x-ms-traffictypediagnostic: VI1PR05MB6560:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-microsoft-antispam-prvs: <VI1PR05MB656026C78F086E61B1BB2E17BEFF0@VI1PR05MB6560.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(66476007)(26005)(54906003)(478600001)(316002)(6512007)(91956017)(76116006)(64756008)(186003)(110136005)(6506007)(66946007)(71200400001)(4326008)(66446008)(5660300002)(66556008)(2906002)(81166006)(86362001)(36756003)(6486002)(8936002)(2616005)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6560;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lxI0VtW17M5d3XXqdqCrHfZ7E3+ftAN+NwUycH4e8mhRxb6nMB/pYVSPEIcSbPhOwsKrTuJbNOtPVbsm8qKjaxn87dKO2cRzI7wPvgW4HIdzAzVC71Kyxf8NhF1i+MfX7jfNKnhyMLWG/3JHoG7d/121E7K+sqmAA+T1iyLE1vmYIcHIMqs3RfchSIbYnKUuUOHLYKQJ1VpsdDBj68b68KznQeIERN3JI8J+VJMUPRBQGKZo8znT6my3KVml+39qb9YzOjfT4jcW5pOWkVqJJBATcSxy19tJDRm7zNUNgN9tKVqC/RFW//TqlzC6Ts2kHQZA1j1Xmh9n/iC33RSa7GrKDQ2cKI0z8Md100qX188QYf2c6BZjVxCmfYyI4T4c4KcTX8S92jWRdQEdSD8vEB3fDGvGH5UvjlxTleV247EsNqektIOwCkR8gBHBiMyl
x-ms-exchange-antispam-messagedata: Z6syrECieza/QzpxIp+n/hm5BqcwEEvP81G/zJTFYNfmKO/X1vyac6lVv3kQCHNwNlHqm6gM/unVjbOj3A+kZESvpNkAg5kIwOUadB0KPL5r2shLVoCiP8WYytG0O05mGO2H29OzydlZ7xrtZVeYag==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFA169E7FA8DAF45B6ACF6159F0897FA@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59e6b4c8-8bf4-4936-eaf6-08d7c54e3b58
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 23:53:28.8959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YbwnQJzxpbF5pNKbLAVVuVt3aJD+ouOw+PdFRGObaYsSOLbn0oLbhv3RIpWqgHkN/ZnYlgPfTWUxCzFtCsu20Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6560
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTEwIGF0IDE0OjA5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMCBNYXIgMjAyMCAxMTowNDoxMiArMDEwMCBKZXNwZXIgRGFuZ2FhcmQgQnJv
dWVyIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMTAgTWFyIDIwMjAgMDI6MzA6MzQgKzAwMDANCj4gPiBT
YWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4gd3JvdGU6DQo+ID4gPiBPbiBNb24s
IDIwMjAtMDMtMDkgYXQgMTc6NTUgLTA3MDAsIERhdmlkIE1pbGxlciB3cm90ZTogIA0KPiA+ID4g
PiBGcm9tOiBKb25hdGhhbiBMZW1vbiA8am9uYXRoYW4ubGVtb25AZ21haWwuY29tPg0KPiA+ID4g
PiBEYXRlOiBNb24sIDkgTWFyIDIwMjAgMTI6NDk6MjkgLTA3MDANCj4gPiA+ID4gICAgIA0KPiA+
ID4gPiA+IG5ldHBvbGwgbWF5IGJlIGNhbGxlZCBmcm9tIElSUSBjb250ZXh0LCB3aGljaCBtYXkg
YWNjZXNzIHRoZQ0KPiA+ID4gPiA+IHBhZ2UgcG9vbCByaW5nLiAgVGhlIGN1cnJlbnQgX2JoIHZh
cmlhbnRzIGRvIG5vdCBwcm92aWRlDQo+ID4gPiA+ID4gc3VmZmljaWVudA0KPiA+ID4gPiA+IHBy
b3RlY3Rpb24sIHNvIHVzZSBpcnFzYXZlL3Jlc3RvcmUgaW5zdGVhZC4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBFcnJvciBvYnNlcnZlZCBvbiBhIG1vZGlmaWVkIG1seDQgZHJpdmVyLCBidXQgdGhl
IGNvZGUgcGF0aA0KPiA+ID4gPiA+IGV4aXN0cw0KPiA+ID4gPiA+IGZvciBhbnkgZHJpdmVyIHdo
aWNoIGNhbGxzIHBhZ2VfcG9vbF9yZWN5Y2xlIGZyb20gbmFwaQ0KPiA+ID4gPiA+IHBvbGwuICAN
Cj4gPiANCj4gPiBOZXRwb2xsIGNhbGxzIGludG8gZHJpdmVycyBhcmUgcHJvYmxlbWF0aWMsIG5h
c3R5IGFuZCBhbm5veWluZy4NCj4gPiBEcml2ZXJzDQo+ID4gdXN1YWxseSBjYXRjaCBuZXRwb2xs
IGNhbGxzIHZpYSBzZWVpbmcgTkFQSSBidWRnZXQgaXMgemVybywgYW5kDQo+ID4gaGFuZGxlDQo+
ID4gdGhlIHNpdHVhdGlvbiBpbnNpZGUgdGhlIGRyaXZlciBlLmcuWzFdWzJdLiAoZXZlbiBuYXBp
X2NvbnN1bWVfc2tiDQo+ID4gY2F0Y2ggaXQgdGhpcyB3YXkpLg0KPiANCj4gSSdtIHByb2JhYmx5
IGp1c3QgcmVwZWF0aW5nIHdoYXQgeW91IHNhaWQsIGJ1dCB3b3VsZCBpdCBiZSByZWFzb25hYmxl
DQo+IHRvIGV4cGVjdCBwYWdlX3Bvb2wgdXNlcnMgdG8gc3BlY2lhbC1jYXNlIFhEUCByaW5ncyB0
byBub3QgYmUNCj4gY2xlYW5lZD8NCj4gbmV0cG9sbCBoYXMgbm8gdXNlIGZvciB0aGVtLg0KPiAN
Cg0Kc291bmRzIGxpa2UgYSBiZXR0ZXIgYmFuZC1haWQNCg0KPiBQZXJoYXBzIHRoYXQgd291bGQg
bm90IHNvbHZlIHRoZSBpc3N1ZSBmb3IgdGhvc2UgZnVua3kgZHJpdmVycyB3aGljaA0KPiB1c2Ug
dGhlIHNhbWUgcmluZ3MgZm9yIGJvdGggWERQIGFuZCB0aGUgc3RhY2suIFNpZ2guIERvIHdlIGNh
cmUgYWJvdXQNCj4gdGhlbT8NCg0KVGhleSBjYW4gc3BlY2lhbCBjYXNlIHBlci1wYWdlLCBpZiBp
dCBpcyBhbiBYRFAgdHggcGFnZSwgZG9uJ3QgcmVjeWNsZQ0KdG8gcHRyIHJpbmcgLi4gDQo=
