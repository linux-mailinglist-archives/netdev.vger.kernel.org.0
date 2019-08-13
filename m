Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A398B271
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 10:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfHMI3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 04:29:51 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:45130
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727784AbfHMI3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 04:29:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PxA0f9uDt28a9Fu1cutpWucMS+VG6L6wARDX/YClA33RKRW+En3dFeMfBuGSfdFx0Y/2VsGwg2ulV7cY8/n+b7m+noASr/gqIZGCatV0faKAOcohdT/C0eucFKg7wx7f9fsrVV+VrSjoeNrzfsUS5yPgxNZq+6b7AW6asJ4+MMcaxmYCOA95ZC4BkFkN5gCUMR+OrYyjSFChEWyNMvV8eCTRM9PmuLMeunu0jreNioSIZ9qgU366svz1MVdVSc4rEXyd+UWPif7VEgi9GC3ldvCdHMD2Lt1MSAzM0zYJT47OwDU0dKHaXjX6DVz67+hMVU6soawlwv4TO4HRH2Y/ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGahPGd95wrcGU02Ny+Q/giF3ZqO0hCG7I5+NHINY30=;
 b=hgVhIYqtkKjvyHs3s4mgdETqINmRfe42+2FdRAmpFn///WWpDrZSar2AymkpKh/LIuvC+nbpTz8Bb+bx9rWzbKufTQLtyB/RovtK0WXPX4bqVLJNSyTAwJvRIMq+mogEB0F2nfbk6Eu0Xm3xS7L0Wt/1SvEoJVoBrnNemi2BwHLjLm2F8wW5v0zw7QnRXVQiIjoHBRSlNTdb6RYpvbILnaT1pN8+hflpWXdMXOqLkzvTG7fZv5USxj/bgGuhfcha2xS4rL85BsZLIHRzWNckEr0hEULCrBzuTvundop/dyOUXNXeVwJbIuhiNlKsOUEdyxZ/KTuoKoBv1lM4L2jmBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGahPGd95wrcGU02Ny+Q/giF3ZqO0hCG7I5+NHINY30=;
 b=kSEeNpv8xXcmKs4TxRwMZIkVlS88JBfi9/UKcLlFTn32chnBiU/TLd/HXxRQfCWh7RQWEBQHbURvun+uH07EyBxjzHrAVCTZfIwQXJ5viEhJPqZqIrS2EWhOJamBHdwbzxB0GdfyZwih5LJGucJaPbM7y9/4L87EEVh6L1rCEA0=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3314.eurprd05.prod.outlook.com (10.171.191.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 13 Aug 2019 08:29:40 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::d027:14a2:95db:6f1f%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 08:29:40 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Pravin Shelar <pshelar@ovn.org>
CC:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Justin Pettit <jpettit@nicira.com>,
        Simon Horman <simon.horman@netronome.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>
Subject: Re: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Topic: [PATCH net-next] net: openvswitch: Set OvS recirc_id from tc
 chain index
Thread-Index: AQHVTRjlJ4rvN3xFsU2F7hr1t29bFqbxvIIAgAQNcACAAe8HAIABD1GA
Date:   Tue, 13 Aug 2019 08:29:39 +0000
Message-ID: <68e7a65c-162a-8bc5-4d80-f4f245944b9c@mellanox.com>
References: <1565179722-22488-1-git-send-email-paulb@mellanox.com>
 <CAOrHB_DhfiQy8RwTiwgn9ZXgsd5j2f0ynZPUP4wf-xzhjwo8kg@mail.gmail.com>
 <b5342e56-4baa-97ab-8694-2f48d012afca@mellanox.com>
 <CAOrHB_CDrau-jLycRYxRkn1tEXVrRhoSYSd8sAcGPiZ-bp+FEg@mail.gmail.com>
In-Reply-To: <CAOrHB_CDrau-jLycRYxRkn1tEXVrRhoSYSd8sAcGPiZ-bp+FEg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9729e257-f6ff-48d7-1ac1-08d71fc86244
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3314;
x-ms-traffictypediagnostic: AM4PR05MB3314:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3314448C5B6C39706EDFD47FCFD20@AM4PR05MB3314.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(199004)(51914003)(189003)(6116002)(102836004)(6512007)(36756003)(99286004)(86362001)(53546011)(6306002)(52116002)(25786009)(256004)(6506007)(6916009)(3846002)(386003)(26005)(7736002)(76176011)(71190400001)(305945005)(186003)(53936002)(71200400001)(31696002)(14444005)(5660300002)(2616005)(966005)(446003)(81166006)(6246003)(81156014)(11346002)(478600001)(6486002)(8676002)(66066001)(6436002)(486006)(31686004)(64756008)(66946007)(66446008)(476003)(107886003)(229853002)(8936002)(316002)(14454004)(2906002)(54906003)(66476007)(66556008)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3314;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cffuCgFXK7aiUWC/AXTH/ab3N1YF25O9IOdJfp2tzX9wdk+BM25v1sPKMlbxBLW74PB2uP64KYgvQw/IBAl94yOvgJPbPDWf/i6KFc+nDtrmbanrjaD+E2Ul024vPG1+dUzcoFsAsSR4xi9MbutpGlfd3n5QRfnsUcrDxMzIv0NdOay999IKFuscGH1+h/PY4It9YWzcH6JIVhClWAT4o29Ysq6cM4bsmhrgllmFDoEVl0lqdJvFaDRVDE890kpp0AauJV5r6KEVfnRDeyceTEWWFP7KdleKv1U90sl5CCYBuaMrmX/Lbw6btW24AUjSicZo0KzJyr+MmFdxuUkaIZs5xJX06o5Jumt1UDenmHl7BQxUm6pnwd08MzzArB/WH3lDbS5fzfMp6uHff/oTVHYSt4f4seq2GFg6UoiMjLg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01668CD323C10A48901B8E81D14FB832@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9729e257-f6ff-48d7-1ac1-08d71fc86244
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 08:29:40.0194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tGueeh0Xcg4XUaGfrlc1eJS+hA8OWeSSLXnUMnqDA/mRf6lWm5HEuW7KNuaji1gmQZnBbaMm8BxwtzUBi/kehg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3314
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzEyLzIwMTkgNzoxOCBQTSwgUHJhdmluIFNoZWxhciB3cm90ZToNCj4gT24gU3VuLCBB
dWcgMTEsIDIwMTkgYXQgMzo0NiBBTSBQYXVsIEJsYWtleSA8cGF1bGJAbWVsbGFub3guY29tPiB3
cm90ZToNCj4+DQo+PiBPbiA4LzgvMjAxOSAxMTo1MyBQTSwgUHJhdmluIFNoZWxhciB3cm90ZToN
Cj4+PiBPbiBXZWQsIEF1ZyA3LCAyMDE5IGF0IDU6MDggQU0gUGF1bCBCbGFrZXkgPHBhdWxiQG1l
bGxhbm94LmNvbT4gd3JvdGU6DQo+Pj4+IE9mZmxvYWRlZCBPdlMgZGF0YXBhdGggcnVsZXMgYXJl
IHRyYW5zbGF0ZWQgb25lIHRvIG9uZSB0byB0YyBydWxlcywNCj4+Pj4gZm9yIGV4YW1wbGUgdGhl
IGZvbGxvd2luZyBzaW1wbGlmaWVkIE92UyBydWxlOg0KPj4+Pg0KPj4+PiByZWNpcmNfaWQoMCks
aW5fcG9ydChkZXYxKSxldGhfdHlwZSgweDA4MDApLGN0X3N0YXRlKC10cmspIGFjdGlvbnM6Y3Qo
KSxyZWNpcmMoMikNCj4+Pj4NCj4+Pj4gV2lsbCBiZSB0cmFuc2xhdGVkIHRvIHRoZSBmb2xsb3dp
bmcgdGMgcnVsZToNCj4+Pj4NCj4+Pj4gJCB0YyBmaWx0ZXIgYWRkIGRldiBkZXYxIGluZ3Jlc3Mg
XA0KPj4+PiAgICAgICAgICAgICAgIHByaW8gMSBjaGFpbiAwIHByb3RvIGlwIFwNCj4+Pj4gICAg
ICAgICAgICAgICAgICAgZmxvd2VyIHRjcCBjdF9zdGF0ZSAtdHJrIFwNCj4+Pj4gICAgICAgICAg
ICAgICAgICAgYWN0aW9uIGN0IHBpcGUgXA0KPj4+PiAgICAgICAgICAgICAgICAgICBhY3Rpb24g
Z290byBjaGFpbiAyDQo+Pj4+DQo+Pj4+IFJlY2VpdmVkIHBhY2tldHMgd2lsbCBmaXJzdCB0cmF2
ZWwgdGhvdWdoIHRjLCBhbmQgaWYgdGhleSBhcmVuJ3Qgc3RvbGVuDQo+Pj4+IGJ5IGl0LCBsaWtl
IGluIHRoZSBhYm92ZSBydWxlLCB0aGV5IHdpbGwgY29udGludWUgdG8gT3ZTIGRhdGFwYXRoLg0K
Pj4+PiBTaW5jZSB3ZSBhbHJlYWR5IGRpZCBzb21lIGFjdGlvbnMgKGFjdGlvbiBjdCBpbiB0aGlz
IGNhc2UpIHdoaWNoIG1pZ2h0DQo+Pj4+IG1vZGlmeSB0aGUgcGFja2V0cywgYW5kIHVwZGF0ZWQg
YWN0aW9uIHN0YXRzLCB3ZSB3b3VsZCBsaWtlIHRvIGNvbnRpbnVlDQo+Pj4+IHRoZSBwcm9jY2Vz
c2luZyB3aXRoIHRoZSBjb3JyZWN0IHJlY2lyY19pZCBpbiBPdlMgKGhlcmUgcmVjaXJjX2lkKDIp
KQ0KPj4+PiB3aGVyZSB3ZSBsZWZ0IG9mZi4NCj4+Pj4NCj4+Pj4gVG8gc3VwcG9ydCB0aGlzLCBp
bnRyb2R1Y2UgYSBuZXcgc2tiIGV4dGVuc2lvbiBmb3IgdGMsIHdoaWNoDQo+Pj4+IHdpbGwgYmUg
dXNlZCBmb3IgdHJhbnNsYXRpbmcgdGMgY2hhaW4gdG8gb3ZzIHJlY2lyY19pZCB0bw0KPj4+PiBo
YW5kbGUgdGhlc2UgbWlzcyBjYXNlcy4gTGFzdCB0YyBjaGFpbiBpbmRleCB3aWxsIGJlIHNldA0K
Pj4+PiBieSB0YyBnb3RvIGNoYWluIGFjdGlvbiBhbmQgcmVhZCBieSBPdlMgZGF0YXBhdGguDQo+
Pj4+DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+
DQo+Pj4+IFNpZ25lZC1vZmYtYnk6IFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFub3guY29tPg0K
Pj4+PiBBY2tlZC1ieTogSmlyaSBQaXJrbyA8amlyaUBtZWxsYW5veC5jb20+DQo+Pj4+IC0tLQ0K
Pj4+PiAgICBpbmNsdWRlL2xpbnV4L3NrYnVmZi5oICAgIHwgMTMgKysrKysrKysrKysrKw0KPj4+
PiAgICBpbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oIHwgIDUgKysrKy0NCj4+Pj4gICAgbmV0L2Nv
cmUvc2tidWZmLmMgICAgICAgICB8ICA2ICsrKysrKw0KPj4+PiAgICBuZXQvb3BlbnZzd2l0Y2gv
Zmxvdy5jICAgIHwgIDkgKysrKysrKysrDQo+Pj4+ICAgIG5ldC9zY2hlZC9LY29uZmlnICAgICAg
ICAgfCAxMyArKysrKysrKysrKysrDQo+Pj4+ICAgIG5ldC9zY2hlZC9hY3RfYXBpLmMgICAgICAg
fCAgMSArDQo+Pj4+ICAgIG5ldC9zY2hlZC9jbHNfYXBpLmMgICAgICAgfCAxMiArKysrKysrKysr
KysNCj4+Pj4gICAgNyBmaWxlcyBjaGFuZ2VkLCA1OCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9u
KC0pDQo+Pj4+DQo+Pj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oIGIvaW5j
bHVkZS9saW51eC9za2J1ZmYuaA0KPj4+PiBpbmRleCAzYWVmOGQ4Li5mYjJhNzkyIDEwMDY0NA0K
Pj4+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L3NrYnVmZi5oDQo+Pj4+ICsrKyBiL2luY2x1ZGUvbGlu
dXgvc2tidWZmLmgNCj4+Pj4gQEAgLTI3OSw2ICsyNzksMTYgQEAgc3RydWN0IG5mX2JyaWRnZV9p
bmZvIHsNCj4+Pj4gICAgfTsNCj4+Pj4gICAgI2VuZGlmDQo+Pj4+DQo+Pj4+ICsjaWYgSVNfRU5B
QkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+Pj4+ICsvKiBDaGFpbiBpbiB0Y19za2JfZXh0
IHdpbGwgYmUgdXNlZCB0byBzaGFyZSB0aGUgdGMgY2hhaW4gd2l0aA0KPj4+PiArICogb3ZzIHJl
Y2lyY19pZC4gSXQgd2lsbCBiZSBzZXQgdG8gdGhlIGN1cnJlbnQgY2hhaW4gYnkgdGMNCj4+Pj4g
KyAqIGFuZCByZWFkIGJ5IG92cyB0byByZWNpcmNfaWQuDQo+Pj4+ICsgKi8NCj4+Pj4gK3N0cnVj
dCB0Y19za2JfZXh0IHsNCj4+Pj4gKyAgICAgICBfX3UzMiBjaGFpbjsNCj4+Pj4gK307DQo+Pj4+
ICsjZW5kaWYNCj4+Pj4gKw0KPj4+PiAgICBzdHJ1Y3Qgc2tfYnVmZl9oZWFkIHsNCj4+Pj4gICAg
ICAgICAgIC8qIFRoZXNlIHR3byBtZW1iZXJzIG11c3QgYmUgZmlyc3QuICovDQo+Pj4+ICAgICAg
ICAgICBzdHJ1Y3Qgc2tfYnVmZiAgKm5leHQ7DQo+Pj4+IEBAIC00MDUwLDYgKzQwNjAsOSBAQCBl
bnVtIHNrYl9leHRfaWQgew0KPj4+PiAgICAjaWZkZWYgQ09ORklHX1hGUk0NCj4+Pj4gICAgICAg
ICAgIFNLQl9FWFRfU0VDX1BBVEgsDQo+Pj4+ICAgICNlbmRpZg0KPj4+PiArI2lmIElTX0VOQUJM
RUQoQ09ORklHX05FVF9UQ19TS0JfRVhUKQ0KPj4+PiArICAgICAgIFRDX1NLQl9FWFQsDQo+Pj4+
ICsjZW5kaWYNCj4+Pj4gICAgICAgICAgIFNLQl9FWFRfTlVNLCAvKiBtdXN0IGJlIGxhc3QgKi8N
Cj4+Pj4gICAgfTsNCj4+Pj4NCj4+Pj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3NjaF9nZW5l
cmljLmggYi9pbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oDQo+Pj4+IGluZGV4IDZiNmIwMTIuLjg3
MWZlZWEgMTAwNjQ0DQo+Pj4+IC0tLSBhL2luY2x1ZGUvbmV0L3NjaF9nZW5lcmljLmgNCj4+Pj4g
KysrIGIvaW5jbHVkZS9uZXQvc2NoX2dlbmVyaWMuaA0KPj4+PiBAQCAtMjc1LDcgKzI3NSwxMCBA
QCBzdHJ1Y3QgdGNmX3Jlc3VsdCB7DQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5z
aWduZWQgbG9uZyAgIGNsYXNzOw0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgIHUzMiAg
ICAgICAgICAgICBjbGFzc2lkOw0KPj4+PiAgICAgICAgICAgICAgICAgICB9Ow0KPj4+PiAtICAg
ICAgICAgICAgICAgY29uc3Qgc3RydWN0IHRjZl9wcm90byAqZ290b190cDsNCj4+Pj4gKyAgICAg
ICAgICAgICAgIHN0cnVjdCB7DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIGNvbnN0IHN0
cnVjdCB0Y2ZfcHJvdG8gKmdvdG9fdHA7DQo+Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgIHUz
MiBnb3RvX2luZGV4Ow0KPj4+PiArICAgICAgICAgICAgICAgfTsNCj4+Pj4NCj4+Pj4gICAgICAg
ICAgICAgICAgICAgLyogdXNlZCBpbiB0aGUgc2tiX3RjX3JlaW5zZXJ0IGZ1bmN0aW9uICovDQo+
Pj4+ICAgICAgICAgICAgICAgICAgIHN0cnVjdCB7DQo+Pj4+IGRpZmYgLS1naXQgYS9uZXQvY29y
ZS9za2J1ZmYuYyBiL25ldC9jb3JlL3NrYnVmZi5jDQo+Pj4+IGluZGV4IGVhOGU4ZDMuLjJiNDBi
NWEgMTAwNjQ0DQo+Pj4+IC0tLSBhL25ldC9jb3JlL3NrYnVmZi5jDQo+Pj4+ICsrKyBiL25ldC9j
b3JlL3NrYnVmZi5jDQo+Pj4+IEBAIC00MDg3LDYgKzQwODcsOSBAQCBpbnQgc2tiX2dyb19yZWNl
aXZlKHN0cnVjdCBza19idWZmICpwLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4+PiAgICAjaWZk
ZWYgQ09ORklHX1hGUk0NCj4+Pj4gICAgICAgICAgIFtTS0JfRVhUX1NFQ19QQVRIXSA9IFNLQl9F
WFRfQ0hVTktTSVpFT0Yoc3RydWN0IHNlY19wYXRoKSwNCj4+Pj4gICAgI2VuZGlmDQo+Pj4+ICsj
aWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+Pj4+ICsgICAgICAgW1RDX1NL
Ql9FWFRdID0gU0tCX0VYVF9DSFVOS1NJWkVPRihzdHJ1Y3QgdGNfc2tiX2V4dCksDQo+Pj4+ICsj
ZW5kaWYNCj4+Pj4gICAgfTsNCj4+Pj4NCj4+Pj4gICAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB1
bnNpZ25lZCBpbnQgc2tiX2V4dF90b3RhbF9sZW5ndGgodm9pZCkNCj4+Pj4gQEAgLTQwOTgsNiAr
NDEwMSw5IEBAIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdW5zaWduZWQgaW50IHNrYl9leHRfdG90
YWxfbGVuZ3RoKHZvaWQpDQo+Pj4+ICAgICNpZmRlZiBDT05GSUdfWEZSTQ0KPj4+PiAgICAgICAg
ICAgICAgICAgICBza2JfZXh0X3R5cGVfbGVuW1NLQl9FWFRfU0VDX1BBVEhdICsNCj4+Pj4gICAg
I2VuZGlmDQo+Pj4+ICsjaWYgSVNfRU5BQkxFRChDT05GSUdfTkVUX1RDX1NLQl9FWFQpDQo+Pj4+
ICsgICAgICAgICAgICAgICBza2JfZXh0X3R5cGVfbGVuW1RDX1NLQl9FWFRdICsNCj4+Pj4gKyNl
bmRpZg0KPj4+PiAgICAgICAgICAgICAgICAgICAwOw0KPj4+PiAgICB9DQo+Pj4+DQo+Pj4+IGRp
ZmYgLS1naXQgYS9uZXQvb3BlbnZzd2l0Y2gvZmxvdy5jIGIvbmV0L29wZW52c3dpdGNoL2Zsb3cu
Yw0KPj4+PiBpbmRleCBiYzg5ZTE2Li4wMjg3ZWFkIDEwMDY0NA0KPj4+PiAtLS0gYS9uZXQvb3Bl
bnZzd2l0Y2gvZmxvdy5jDQo+Pj4+ICsrKyBiL25ldC9vcGVudnN3aXRjaC9mbG93LmMNCj4+Pj4g
QEAgLTgxNiw2ICs4MTYsOSBAQCBzdGF0aWMgaW50IGtleV9leHRyYWN0X21hY19wcm90byhzdHJ1
Y3Qgc2tfYnVmZiAqc2tiKQ0KPj4+PiAgICBpbnQgb3ZzX2Zsb3dfa2V5X2V4dHJhY3QoY29uc3Qg
c3RydWN0IGlwX3R1bm5lbF9pbmZvICp0dW5faW5mbywNCj4+Pj4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IHN3X2Zsb3dfa2V5ICprZXkpDQo+
Pj4+ICAgIHsNCj4+Pj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19ORVRfVENfU0tCX0VYVCkNCj4+
Pj4gKyAgICAgICBzdHJ1Y3QgdGNfc2tiX2V4dCAqdGNfZXh0Ow0KPj4+PiArI2VuZGlmDQo+Pj4+
ICAgICAgICAgICBpbnQgcmVzLCBlcnI7DQo+Pj4+DQo+Pj4+ICAgICAgICAgICAvKiBFeHRyYWN0
IG1ldGFkYXRhIGZyb20gcGFja2V0LiAqLw0KPj4+PiBAQCAtODQ4LDcgKzg1MSwxMyBAQCBpbnQg
b3ZzX2Zsb3dfa2V5X2V4dHJhY3QoY29uc3Qgc3RydWN0IGlwX3R1bm5lbF9pbmZvICp0dW5faW5m
bywNCj4+Pj4gICAgICAgICAgIGlmIChyZXMgPCAwKQ0KPj4+PiAgICAgICAgICAgICAgICAgICBy
ZXR1cm4gcmVzOw0KPj4+PiAgICAgICAgICAga2V5LT5tYWNfcHJvdG8gPSByZXM7DQo+Pj4+ICsN
Cj4+Pj4gKyNpZiBJU19FTkFCTEVEKENPTkZJR19ORVRfVENfU0tCX0VYVCkNCj4+Pj4gKyAgICAg
ICB0Y19leHQgPSBza2JfZXh0X2ZpbmQoc2tiLCBUQ19TS0JfRVhUKTsNCj4+Pj4gKyAgICAgICBr
ZXktPnJlY2lyY19pZCA9IHRjX2V4dCA/IHRjX2V4dC0+Y2hhaW4gOiAwOw0KPj4+PiArI2Vsc2UN
Cj4+Pj4gICAgICAgICAgIGtleS0+cmVjaXJjX2lkID0gMDsNCj4+Pj4gKyNlbmRpZg0KPj4+Pg0K
Pj4+IE1vc3Qgb2YgY2FzZXMgdGhlIGNvbmZpZyB3b3VsZCBiZSB0dXJuZWQgb24sIHNvIHRoZSBp
ZmRlZiBpcyBub3QgdGhhdA0KPj4+IHVzZWZ1bC4gQ2FuIHlvdSBhZGQgc3RhdGljIGtleSB0byBh
dm9pZCBzZWFyY2hpbmcgdGhlIHNrYi1leHQgaW4gbm9uDQo+Pj4gb2ZmbG9hZCBjYXNlcy4NCj4+
IEhpLA0KPj4NCj4+IFdoYXQgZG8geW91IG1lYW4gYnkgYSBzdGF0aWMga2V5Pw0KPj4NCj4gaHR0
cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvRG9jdW1lbnRhdGlvbi9zdGF0aWMta2V5cy50eHQNCj4N
Cj4gU3RhdGljIGtleSBjYW4gYmUgZW5hYmxlZCB3aGVuIGEgZmxvdyBpcyBhZGRlZCB0byB0aGUg
dGMgZmlsdGVyLg0KDQpIaSBhbmQgdGhhbmtzIGZvciB0aGUgZmVlZGJhY2ssDQoNClRoZSBza2Jf
ZXh0X2ZpbmQoKSBqdXN0IGNoZWNrcyBhIHNpbmdsZSBiaXQgb24gdGhlIA0Kc2tiLT5hY3RpdmVf
ZXh0ZW5zaW9ucywgYW5kIGlmIHNvIHJldHVybnMgYW4gb2Zmc2V0LiBEbyB5b3UgdGhpbmsgaXQg
DQp3aWxsIGltcGFjdCBwZXJmb3JtYW5jZSBtdWNoPw0KDQoNCkJ1dCB0byB5b3VyIHN1Z2dlc3Rp
b24sIGRvIHlvdSBtZWFuIHRoYXQgdGhlIGZpcnN0IHRjIGdvdG8gYWN0aW9uIA0KaW5zdGFuY2Ug
d2l0aCB0aGUgcmVsZXZhbnQgaWZkZWYgKENPTkZJR19ORVRfVENfU0tCX0VYVCkgaXQgd2lsbCBl
bmFibGUgDQp0aGUgT3ZTIHN0YXRpYyBrZXkgdGhhdCBndWFyZHMgdGhpcyBza2JfZXh0X2ZpbmQo
KT8NCg0KSSBndWVzcyBjYWxsaW5nIGl0IGluIHRjZl9hY3Rpb25fc2V0X2N0cmxhY3QoKSBpZiBn
b3RvX2NoYWluICE9IDAuDQoNClRoaXMgd2lsbCBleHBvc2Ugc29tZSBPdlMgaGVscGVyIGZ1bmN0
aW9uIChvciBzdGF0aWMga2V5KSB0byANCm5ldC9zY2hlZC9hY3RfYXBpLmMgcmlnaHQ/DQoNCg0K
VGhhbmtzLA0KDQpQYXVsLg0KDQoNCg0KDQo=
