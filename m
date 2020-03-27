Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA139195F01
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgC0TqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:46:02 -0400
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:59582
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727666AbgC0TqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 15:46:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR7dTUmXJULrrOGhvgdIDDUmrbtm5bbdcyxjpGS3ii47tT08YH72vFXP5P1IfgQulXZgIhA9Mad2MeBFCNTQ2I9nSPuXXCuex7BifbyNMnzF4FVeowVErx15nraEbRMLq4Mz5rCMCS7onzK1RtsDz5yP2mHcRPH3sbI9YXwP8fUsxGbdlGwHys9U9+HTNJ4QWVv5gZcYAgSEgX/reaccWV4vAaZ6Sb1Io/kNrwog32JkGRXeTqkhIxCq+7ZJC5oWtQVkc8vtjKYDSxD7+cFRwtHtFDe4kqCpKS3QX3NivgEGVVdPzSCD7Udg5O+H+YPrWFj5A80VHFLD92OD2Oy+8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXAMAcmfoGReXNcSYu4gGwpz30kmnOWRq/aIKMLeY4U=;
 b=eu1rcOXQ0IVVNTEbcdVRs3Mj84h2C1qTaOZI2bEntiGVIAADOzhdrN5SUzaSW7qXpZqO26wdE/0r8O1BrQVv6nMAmC4nw4fqqnJAcuMFxGBtUyapkXmZAztL3hbQ/mWX/YZVUCCONdzdKzKP3BDd5nbRty6cuPd9KKTAxFwHD25R6QAdGE09DA/AhJJwaJABs/w31SBYA/1vcEQ/RESKklKENS4f08n+hWw/DI+ZHZwc1+5ak9W270SAMMKbxECuDoiF4Ya/E7t3V6m3EMfdkJOZ5SbuGdaOjlzhSKZ50+6nebOgCis6ClBnrcGtzH3O7coOtTWN0dbQ/1BXD3+QQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXAMAcmfoGReXNcSYu4gGwpz30kmnOWRq/aIKMLeY4U=;
 b=r7feU5OmOekPpVrNWUfa/ytCeVRWdL8JoObpTxo+KDrFdV4ZkvFUPIbaxIDzorR+pB0juNsI3tsphhR2OReSajnUzW82ylgL2BJgJYhoZwT67dBal0Zz24N8t6qeyoTxXqfY6zzouICfDFleLYk6VS+ITG0iQwCCJa/PGHgG+1w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0382.eurprd05.prod.outlook.com (20.178.81.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 19:45:54 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 19:45:53 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Aya Levin <ayal@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "sburla@marvell.com" <sburla@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        Tariq Toukan <tariqt@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "fmanlunas@marvell.com" <fmanlunas@marvell.com>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Alex Vesker <valex@mellanox.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "dchickles@marvell.com" <dchickles@marvell.com>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        "aelior@marvell.com" <aelior@marvell.com>,
        Yuval Avnery <yuvalav@mellanox.com>,
        "drivers@pensando.io" <drivers@pensando.io>,
        mlxsw <mlxsw@mellanox.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [RFC] current devlink extension plan for NICs
Thread-Topic: [RFC] current devlink extension plan for NICs
Thread-Index: AQHV/iRsNnIFGClfDEemm9M/cscIZqhQ1DGAgABD54CAAOeuAIAAzAqAgAPIYYCABGpggIAAAUoAgABegoCAAL1QAIAAlFSAgAAkgwCAAAXeAIAACeyA
Date:   Fri, 27 Mar 2020 19:45:53 +0000
Message-ID: <ea8a8434b1db2b692489edfd4abbc2274a77228c.camel@mellanox.com>
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
         <a02cf0e6-98ad-65c4-0363-8fb9d67d2c9c@intel.com>
         <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200327121010.3e987488@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: c401d560-ebee-469e-53b4-08d7d287760e
x-ms-traffictypediagnostic: VI1SPR01MB0382:|VI1SPR01MB0382:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0382A7534358B2E710F8C302BECC0@VI1SPR01MB0382.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(39860400002)(376002)(396003)(366004)(346002)(91956017)(76116006)(66946007)(66476007)(66556008)(64756008)(66446008)(5660300002)(478600001)(6486002)(71200400001)(110136005)(4326008)(54906003)(107886003)(316002)(2616005)(8676002)(6512007)(86362001)(81166006)(2906002)(81156014)(186003)(26005)(8936002)(36756003)(7416002)(6506007)(53546011);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2QKZ9o9w+O+Yz+1CL44JgLNL+Qdl+oz0Suq0dPesqbxwe+TsMTKWw086OCJYRdxcm21goCBvVrDWGmS2luDJJDnpPh3QMlPR46DVeckMWUU+5s0yxRHkopxeQPbFPie0rzRJxH2PQZr3rd1NyGSX77vPl1bURmXnwe2ZG+QpNSgpvKaHqBLQyvUnRyJj8arDytR9xPmtQuD3umwpMxH87fvyc71oqwvtIIiMkN/7ZYtR0+LNnaPy2nayju9inDpm2nTG1eq//LqZyMXz+HL7CLQZ11vNXsb2qPJ+6sqmJ2mDnuETUD7yrM5sk3Fd56QTpxD3HzRankM9Wh3ui285nBBSu53wqBAmjXQ/qzrrrKBnpJ8bY4xI8geHHq8tB3txyD0q8nk+5HyokAT4ZiaUYAXdPYVgONYiCxSKxe9aNFSnxDcjVUu/jBxplZxoKtsy
x-ms-exchange-antispam-messagedata: IoQ7WNyxb/YA25IABmFFcrJXvlILcyaJi5TsqHsMnh67h4Ms/8+ecfPp03v1tbkG/X90k3UD3LxPm2UzwVF81+hYiIapgNtz6DAEancIbuS79yecUofzz4cmvDyf09TcJb9Hxaan8Jng7fjiFaNX3Q==
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A6CE0ACF755104A8951EB5CC0C208E0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c401d560-ebee-469e-53b4-08d7d287760e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 19:45:53.5445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ewgPrcPEya4IzVgXLbYV+vAUkdSsqHyeNvssVk1n9wznlzjhSZJyOfJliINpprboZgmMiiMrdFVbosz1oVqxTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTI3IGF0IDEyOjEwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyNyBNYXIgMjAyMCAxMTo0OToxMCAtMDcwMCBTYW11ZHJhbGEsIFNyaWRoYXIg
d3JvdGU6DQo+ID4gT24gMy8yNy8yMDIwIDk6MzggQU0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0K
PiA+ID4gT24gRnJpLCAyNyBNYXIgMjAyMCAwODo0NzozNiArMDEwMCBKaXJpIFBpcmtvIHdyb3Rl
OiAgDQo+ID4gPiA+ID4gU28gdGhlIHF1ZXVlcywgaW50ZXJydXB0cywgYW5kIG90aGVyIHJlc291
cmNlcyBhcmUgYWxzbyBwYXJ0DQo+ID4gPiA+ID4gb2YgdGhlIHNsaWNlIHRoZW4/ICANCj4gPiA+
ID4gDQo+ID4gPiA+IFllcCwgdGhhdCBzZWVtcyB0byBtYWtlIHNlbnNlLg0KPiA+ID4gPiAgDQo+
ID4gPiA+ID4gSG93IGRvIHNsaWNlIHBhcmFtZXRlcnMgbGlrZSByYXRlIGFwcGx5IHRvIE5WTWU/
ICANCj4gPiA+ID4gDQo+ID4gPiA+IE5vdCByZWFsbHkuDQo+ID4gPiA+ICANCj4gPiA+ID4gPiBB
cmUgcG9ydHMgYWx3YXlzIGV0aGVybmV0PyBhbmQgc2xpY2VzIGFsc28gY292ZXIgZW5kcG9pbnRz
DQo+ID4gPiA+ID4gd2l0aA0KPiA+ID4gPiA+IHRyYW5zcG9ydCBzdGFjayBvZmZsb2FkZWQgdG8g
dGhlIE5JQz8gIA0KPiA+ID4gPiANCj4gPiA+ID4gZGV2bGlua19wb3J0IG5vdyBjYW4gYmUgZWl0
aGVyICJldGhlcm5ldCIgb3IgImluZmluaWJhbmQiLg0KPiA+ID4gPiBQZXJoYXBzLA0KPiA+ID4g
PiB0aGVyZSBjYW4gYmUgcG9ydCB0eXBlICJudmUiIHdoaWNoIHdvdWxkIGNvbnRhaW4gb25seSBz
b21lIG9mDQo+ID4gPiA+IHRoZQ0KPiA+ID4gPiBjb25maWcgb3B0aW9ucyBhbmQgd291bGQgbm90
IGhhdmUgYSByZXByZXNlbnRvciAibmV0ZGV2L2liZGV2Ig0KPiA+ID4gPiBsaW5rZWQuDQo+ID4g
PiA+IEkgZG9uJ3Qga25vdy4gIA0KPiA+ID4gDQo+ID4gPiBJIGhvbmVzdGx5IGZpbmQgaXQgaGFy
ZCB0byB1bmRlcnN0YW5kIHdoYXQgdGhhdCBzbGljZSBhYnN0cmFjdGlvbg0KPiA+ID4gaXMsDQo+
ID4gPiBhbmQgd2hpY2ggdGhpbmdzIGJlbG9uZyB0byBzbGljZXMgYW5kIHdoaWNoIHRvIFBDSSBw
b3J0cyAob3Igd2h5DQo+ID4gPiB3ZSBldmVuDQo+ID4gPiBoYXZlIHRoZW0pLiAgDQo+ID4gDQo+
ID4gTG9va3MgbGlrZSBzbGljZSBpcyBhIG5ldyB0ZXJtIGZvciBzdWIgZnVuY3Rpb24gYW5kIHdl
IGNhbiBjb25zaWRlcg0KPiA+IHRoaXMNCj4gPiBhcyBhIFZNRFEgVlNJKGludGVsIHRlcm1pbm9s
b2d5KSBvciBldmVuIGEgUXVldWUgZ3JvdXAgb2YgYSBWU0kuDQo+ID4gDQo+ID4gVG9kYXkgd2Ug
ZXhwb3NlIFZNRFEgVlNJIHZpYSBvZmZsb2FkZWQgTUFDVkxBTi4gVGhpcyBtZWNoYW5pc20NCj4g
PiBzaG91bGQgDQo+ID4gYWxsb3cgdXMgdG8gZXhwb3NlIGl0IGFzIGEgc2VwYXJhdGUgbmV0ZGV2
Lg0KPiANCj4gS2luZGEuIExvb2tzIGxpa2Ugd2l0aCB0aGUgbmV3IEFQSXMgeW91IGd1eXMgd2ls
bCBkZWZpbml0ZWx5IGJlIGFibGUNCj4gdG8NCj4gZXhwb3NlIFZNRFEgYXMgYSBmdWxsKGVyKSBk
ZXZpY2UsIGFuZCBpZiBtZW1vcnkgc2VydmVzIG1lIHdlbGwgdGhhdCdzDQo+IHdoYXQgeW91IHdh
bnRlZCBpbml0aWFsbHkuDQo+IA0KDQpWTURRIGlzIGp1c3QgYSBzdGVlcmluZyBiYXNlZCBpc29s
YXRlZCBzZXQgb2YgcnggdHggcmluZ3MgcG9pbnRlZCBhdCBieQ0KYSBkdW1iIHN0ZWVyaW5nIHJ1
bGUgaW4gdGhlIEhXIC4uIGkgYW0gbm90IHN1cmUgd2UgY2FuIGp1c3Qgd3JhcCB0aGVtDQppbiB0
aGVpciBvd24gdmVuZG9yIHNwZWNpZmljIG5ldGRldiBhbmQganVzdCBjYWxsIGl0IGEgc2xpY2Uu
Lg0KDQpmcm9tIHdoYXQgaSB1bmRlcnN0YW5kLCBhIHJlYWwgc2xpY2UgaXMgYSBmdWxsIGlzb2xh
dGVkIEhXIHBpcGVsaW5lDQp3aXRoIGl0cyBvd24gSFcgcmVzb3VyY2VzIGFuZCBIVyBiYXNlZCBp
c29sYXRpb24sIGEgc2xpY2UgcmluZ3MvaHcNCnJlc291cmNlcyBjYW4gbmV2ZXIgYmUgc2hhcmVk
IGJldHdlZW4gZGlmZmVyZW50IHNsaWNlcywganVzdCBsaWtlIGEgdmYsDQpidXQgd2l0aG91dCB0
aGUgcGNpZSB2aXJ0dWFsIGZ1bmN0aW9uIGJhY2stZW5kLi4NCg0KV2h5IHdvdWxkIHlvdSBuZWVk
IGEgZGV2bGluayBzbGljZSBpbnN0YW5jZSBmb3Igc29tZXRoaW5nIHRoYXQgaGFzIG9ubHkNCnJ4
L3R4IHJpbmdzIGF0dHJpYnV0ZXMgPyBpZiB3ZSBhcmUgZ29pbmcgd2l0aCBzdWNoIGRlc2lnbiwg
dGhlbiBpIGd1ZXNzDQphIHNpbXBsZSByZG1hIGFwcCB3aXRoIGEgcGFpciBvZiBRUHMgY2FuIGNh
bGwgaXRzZWxmIGEgc2xpY2UgLi4gDQoNCldlIG5lZWQgYSBjbGVhci1jdXQgZGVmaW5pdGlvbiBv
ZiB3aGF0IGEgU3ViLWZ1bmN0aW9uIHNsaWNlIGlzLi4gdGhpcw0KUkZDIGRvZXNuJ3Qgc2VlbSB0
byBhZGRyZXNzIHRoYXQgY2xlYXJseS4NCg0KPiBCdXQgdGhlIHN1Yi1mdW5jdGlvbnMgYXJlIGp1
c3QgYSBzdWJzZXQgb2Ygc2xpY2VzLCBQRiBhbmQgVkZzIGFsc28NCj4gaGF2ZSBhIHNsaWNlIGFz
c29jaWF0ZWQgd2l0aCB0aGVtLi4gQW5kIGFsbCB0aG9zZSB0aGluZ3MgaGF2ZSBhIHBvcnQsDQo+
IHRvby4NCj4gDQoNClBGcy9WRnMsIG1pZ2h0IGhhdmUgbW9yZSB0aGFuIG9uZSBwb3J0IHNvbWV0
aW1lcyAuLiANCg0KPiA+ID4gV2l0aCBkZXZpY2VzIGxpa2UgTkZQIGFuZCBNZWxsYW5veCBDWDMg
d2hpY2ggaGF2ZSBvbmUgUENJIFBGDQo+ID4gPiBtYXliZSBpdA0KPiA+ID4gd291bGQgaGF2ZSBt
YWRlIHNlbnNlIHRvIGhhdmUgYSBzbGljZSB0aGF0IGNvdmVycyBtdWx0aXBsZSBwb3J0cywNCj4g
PiA+IGJ1dA0KPiA+ID4gaXQgc2VlbXMgdGhlIHByb3Bvc2FsIGlzIHRvIGhhdmUgcG9ydCB0byBz
bGljZSBtYXBwaW5nIGJlIDE6MS4NCj4gPiA+IEFuZCByYXRlDQo+ID4gPiBpbiB0aG9zZSBkZXZp
Y2VzIHNob3VsZCBzdGlsbCBiZSBwZXIgcG9ydCBub3QgcGVyIHNsaWNlLg0KPiA+ID4gDQo+ID4g
PiBCdXQgdGhpcyBrZWVwcyBjb21pbmcgYmFjaywgYW5kIHNpbmNlIHlvdSBndXlzIGFyZSBkb2lu
ZyBhbGwgdGhlDQo+ID4gPiB3b3JrLA0KPiA+ID4gaWYgeW91IHJlYWxseSByZWFsbHkgbmVlZCBp
dC4uICANCg==
