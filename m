Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025DB1DB456
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 14:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgETM67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 08:58:59 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:26395
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbgETM66 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 08:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fnuz8Lkr0w28hLTvZm1vq5eJ3Rs05+HzI/WfasLPDCP2m6EKf3J2r13RUPS6FbRc2qzpgEpxHNp3fxXHrUDgn7QPBzybtPthC2M3MacReL/anhWKF1yzEkwsa5p0rjt307Q5hUFXZT8lGjxlMwRPr2C0KmOF6/hjzQJB/rKQds+pfJFdsZHjxf487jGq61uxIdLB8Qa7A6R0C10NfqyGOSL1gHwQDeMFeaSDWw1uhzE/hSjH1yNwiX3RQmg7obGQaHfVqC84PQ0gi9i1VTGg0umT6MqHt29gIA0JXaX/Q+GOWujfttRp7l7sl/jAJAefGDuWmt4FxCs+JlXc1srC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsVK525oRs+UrXDkjXajfmwEuBbaPKGRF6S9seT5Or4=;
 b=MJzyDBAtPrTNgCN4gJIPBEMM3B9yheqGMTHYM+4QUFPd4kycj0QGGZxSCdFW7DfzwFPfc/WPivIsjX8bxoiPyIkmTHFDt43DUnYH17QIR7UdPQe49q5bm3As/6G+W4ucseMxznWnPbFvwG6J4Hjug507dahOtuwTmyFHPPOrbWKzvOKqhnWvdGRJsLtUdIxnfx2GeVZ0oyRpT14Fhtwahe972rvDv1iM9zShIQBDdWScpas2ihNZWo0LH1+0L5IGWjcoXDYPrLliwlXYq8h/BQW2hoGnZT1rZrqvWGq4WC2bx0eQ2F2qWbGmWNcgj6rin/FjATWLi7JAneFOFYpCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tsVK525oRs+UrXDkjXajfmwEuBbaPKGRF6S9seT5Or4=;
 b=lcZuiE1SfkR5X2/DTDaH1TYPMmLOgpDBrkPKVBF2+/k6x0tViDt6ovAsVcrBlTCMNXhr3PKGlpzZ9o2/qS9I6DCsqv3J9DxYlIJDoarSu2Wow5e1+R1wR+ZyvsxxpHWsUpoGUB0StXwkH3aX9ZB7ReJ38E4F5316Y7Y2Yu8FULc=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4356.eurprd05.prod.outlook.com (2603:10a6:208:58::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Wed, 20 May
 2020 12:58:52 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 12:58:52 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
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
        Alex Vesker <valex@mellanox.com>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "lihong.yang@intel.com" <lihong.yang@intel.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>
Subject: RE: [RFC v2] current devlink extension plan for NICs
Thread-Topic: [RFC v2] current devlink extension plan for NICs
Thread-Index: AQHWH5j86VY8EpKiG0SvO1qzzv+snaioVl8AgAChUQCAAMrbgIADv/OAgADugYCAAIUywIAA9qIAgAEgnnA=
Date:   Wed, 20 May 2020 12:58:52 +0000
Message-ID: <AM0PR05MB4866653E5683E3822ED22037D1B60@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
 <20200518065207.GA2193@nanopsycho>
 <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
 <AM0PR05MB4866687F67EE56BEBB0D9B3AD1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <82e82079-44fe-8de2-5aa4-65755b21a9cb@intel.com>
In-Reply-To: <82e82079-44fe-8de2-5aa4-65755b21a9cb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 49654fa7-8c09-45cc-3ca2-08d7fcbd8c24
x-ms-traffictypediagnostic: AM0PR05MB4356:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB43569B64ED2F4C08E18CD181D1B60@AM0PR05MB4356.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nLBzrpUUbUt+bmDOb4I0JCTgAXMHcjToQNxfdnnT2PvYUXNtXFjw7mOhS+ZfmRAG0aKprAQ5jt+aXTXj+05QYg26pnFV8ByqO5F4f2/uqTbr8vFyf/CcZiWsEIBNGiLEZzRPoutP6c2WNuXSDfJ5UtkK43Hu8PDomclPIEzcHoV0+TvN2F+LaIIF5bmzspxD8Au3HHT+MQnZBP0KYgEkZOkzKXadq4B/StzoL7zYpaDQQC5eyBNXNjGgox9yIw9ZOF2iJbdb0Sucrdm69/uUiAqaYeHOVbxApTT5bO1u2T1FqPJTd22roWW3fcNqisDjnqx8oEq/qquQjG0NOSnsb0glyyBKVmW5nNeCyCcPW1au3JHm9LwfyXaAtSLDMB5Ph/NKEFCcEx9KIG0Eooa0XzMwGYXQUXssx5IjsNHRz/QkCnG4cJGzUHRibLgIzNBfG8dONBjUIimIkpanoScLy3FACQ6KWzPZAGGMPNZiTqfEIFbAYXuXmXuaLxXd4Trn0d5nthUgrPbf4d6EY/0HvftScb7rhbwwhFKoIZNZarvSy+6YjxUJi2fdedJlNQ2go0WbEv+na/qaAXEgNU0Sfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(376002)(136003)(346002)(66446008)(5660300002)(55016002)(52536014)(53546011)(76116006)(8676002)(186003)(4326008)(64756008)(6506007)(66476007)(7696005)(66946007)(66556008)(8936002)(9686003)(2906002)(54906003)(71200400001)(110136005)(316002)(7416002)(478600001)(33656002)(86362001)(55236004)(26005)(966005)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nDB3f9UvAjzsMUwKWb1NJKYVVSM1rIPqxsGhmeKXZQ+WtyKcfOns89h/Heq/VzRzMJxMjF7l0vAj6sVgghzYzAFuSYmKnNhqlektZ46FK2CJUfpM1zL132GrM/coshYvJIuW6FUVrU5LvyqR/AKpKj1DJH2y15sKop0ePP3fbD67Dxmnpw90xEZvRVwkedx43Ldq+LLkQsGJJT6mYKuxzumfxN9Knw7KGajb/m7P7Fh9h3VPGKrmwx3TyMhhSru0xBT5YPEt0sVXcUFcBGUA00Tk6c3EpPo1754KiZaS+pNzEzqxu8moqK2+O6FVnC2rESyV8dIupEfhOPDo7e9OkY2agmIcwwBkX2jKD7lwhfzIMNerfkwiT4bMiEWfXAPcjRmL8U4tuaXYX4abHlCuRk+mZSSI8zL1brS6kOksoKD/zKEsLFhqZfY0cWfukXUAfsPjhBd9f2VjMM0WXX6WvMfG0kV9cwN/lOTzvSm75ipIBpOh60V6wJbrU9NCsSvV
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49654fa7-8c09-45cc-3ca2-08d7fcbd8c24
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 12:58:52.4469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nVlMkRoDkM+Pw67lECHmo6OCTEVXMLaNkYk0fT7RhJbi82HiRMAvEq1hnMj2y0C7f+zITEgZN8brNVvin+Y51g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIE1heSAyMCwgMjAyMCAxOjE1IEFNDQo+IA0KPiBPbiA1LzE4LzIwMjAgMTA6
MTcgUE0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiBIaSBKYWtlLA0KPiA+DQo+IA0KPiA+PiBP
ay4gU28gaW4gdGhlIHNtYXJ0IE5JQyBDUFUsIHdlJ2Qgc2VlIHRoZSBwcmltYXJ5IFBGIGFuZCBz
b21lIGNoaWxkDQo+ID4+IFBGcywgYW5kIGluIHRoZSBob3N0IHN5c3RlbSB3ZSdkIHNlZSBhICJw
cmltYXJ5IFBGIiB0aGF0IGlzIHRoZSBvdGhlcg0KPiA+PiBlbmQgb2YgdGhlIGFzc29jaWF0ZWQg
Q2hpbGQgUEYsIGFuZCBtaWdodCBiZSBhYmxlIHRvIG1hbmFnZSBpdHMgb3duDQo+IHN1YnN3aXRj
aC4NCj4gPj4NCj4gPj4gT2sgdGhpcyBpcyBtYWtpbmcgbW9yZSBzZW5zZSBub3cuDQo+ID4+DQo+
ID4+IEkgdGhpbmsgSSBoYWQgaW1hZ2luZWQgdGhhdCB3YXMgd2hhdCBzdWJmdW50aW9ucyB3ZXJl
LiBCdXQgcmVhbGx5DQo+ID4+IHN1YmZ1bmN0aW9ucyBhcmUgYSBiaXQgZGlmZmVyZW50LCB0aGV5
J3JlIG1vcmUgc2ltaWxhciB0byBleHBhbmRlZCBWRnM/DQo+ID4+DQo+ID4NCj4gPiAxLiBTdWIg
ZnVuY3Rpb25zIGFyZSBtb3JlIGxpZ2h0IHdlaWdodCB0aGFuIFZGcyBiZWNhdXNlLCAyLiBUaGV5
IHNoYXJlDQo+ID4gdGhlIHNhbWUgUENJIGRldmljZSAoQkFSLCBJUlFzKSBhcyB0aGF0IG9mIFBG
L1ZGIG9uIHdoaWNoIGl0IGlzIGRlcGxveWVkLg0KPiA+IDMuIFVubGlrZSBWRnMgd2hpY2ggYXJl
IGVuYWJsZWQvZGlzYWJsZWQgaW4gYnVsaywgc3ViZnVuY3Rpb25zIGFyZSBjcmVhdGVkLA0KPiBk
ZXBsb3llZCBpbiB1bml0IG9mIDEuDQo+ID4NCj4gPiBTaW5jZSB0aGlzIFJGQyBjb250ZW50IGlz
IG92ZXJ3aGVsbWluZywgSSBleHBhbmRlZCB0aGUgU0YgcGx1bWJpbmcgZGV0YWlscw0KPiBtb3Jl
IGluIFsxXSBpbiBwcmV2aW91cyBSRkMgdmVyc2lvbi4NCj4gPiBZb3UgY2FuIHJlcGxhY2UgJ2Rl
dmxpbmsgc2xpY2UnIHdpdGggJ2RldmxpbmsgcG9ydCBmdW5jJyBpbiBbMV0uDQo+ID4NCj4gPiBb
MV0gaHR0cHM6Ly9tYXJjLmluZm8vP2w9bGludXgtbmV0ZGV2Jm09MTU4NTU1OTI4NTE3Nzc3Jnc9
Mg0KPiA+DQo+IA0KPiBUaGFua3MhIEluZGVlZCwgdGhpcyBtYWtlcyB0aGluZ3MgYSBsb3QgbW9y
ZSBjbGVhciB0byBtZSBub3cuDQo+IA0KVGhhbmtzIGZvciB0aGUgcmV2aWV3IEpha2UuDQoNCj4g
UmVnYXJkcywNCj4gSmFrZQ0K
