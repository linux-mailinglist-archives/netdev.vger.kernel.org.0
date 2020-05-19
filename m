Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771B01D8F1B
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgESFRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:17:34 -0400
Received: from mail-vi1eur05on2049.outbound.protection.outlook.com ([40.107.21.49]:34049
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726323AbgESFRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 01:17:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TF81s9cCKQZ3Vij8QvFuUO0yhfLZRWEe3gH74p6I3lEEwpm2KNqaXLDVm1vKhTnYuVMgaFyPUmqrylBvR0icntnL+o/tDv82cRCQI0MqN5E+VE23gwtlqx+fwfnMDwALN+JyaGrt9FYbf+rTzjGHwLVdo8L5ucjGl582LgpzcKPT9uEVUkusAjwrBRakgAaETKtS93HiGFLVlT/z94a9nPVLV19OsXi6o2X0+NlB4dxzREDBwPnJUWUPhBWVE2PpxPwSiANt4gejQ/XsfpCzraZrJCMEfzKiuDjM1d8dECcbSNqkYRv2KaN3iuabR0vKfEyX6N8QOqLY9Bm6wkXbBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umNTEQ3QOi+1GTe2AtCgLtbGRSWIbWTFd2nEFEqCU7g=;
 b=AT/C444KIZHGKW4DkkzBefKPpvBmqoJzXRefAxtH86dQLfIpY6n8d5Jij1XclL2EMrNgPyZb5oqLRFnEMd9d8JBHOR038k6hwq9lfhOzvM52BhXbx0BNjUxCjUqxvkzPMIMt6ptEfQwZvq1GwI+BV6KGYF+WCJzUo1RpkneBuUa1vQx/KcDyY3lQM3WIrcHu1YU+Qy+32svuzvSWP01pZb6eq7824oXlRi1ZgE0JDVPMF5X1+XnsPDFAXNAMWEK1VFQkEaHnUroG4sAdwW0DuZZZwIpsWtgDE2OhWcLgvWSJgDoWWCOTmoVD0aRZt4axt9VFcFGqf/4r4sPDywjNeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umNTEQ3QOi+1GTe2AtCgLtbGRSWIbWTFd2nEFEqCU7g=;
 b=eWyCsFytDcQK3zkfwmepQMxAfKS4uh9ooMZtUQme6/8tMO8QNfvcYPDx1zVr5cz5R7kbZ/PJR0JGalUHkUO/wQdm3jZODWCH0ZVS5w/qHNGUBe65+nrUhcghnEpGjopIDl6mntxfVXnP3upFCHPoYUnhuTj+rLIClb+jjLKWRB4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6482.eurprd05.prod.outlook.com (2603:10a6:208:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.27; Tue, 19 May
 2020 05:17:28 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5dd6:fa09:c5d1:b387%7]) with mapi id 15.20.3000.034; Tue, 19 May 2020
 05:17:27 +0000
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
Thread-Index: AQHWH5j86VY8EpKiG0SvO1qzzv+snaioVl8AgAChUQCAAMrbgIADv/OAgADugYCAAIUywA==
Date:   Tue, 19 May 2020 05:17:27 +0000
Message-ID: <AM0PR05MB4866687F67EE56BEBB0D9B3AD1B90@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200501091449.GA25211@nanopsycho.orion>
 <b0f75e76-e6cb-a069-b863-d09f77bc67f6@intel.com>
 <20200515093016.GE2676@nanopsycho>
 <e3aa20ec-a47e-0b91-d6d5-1ad2020eca28@intel.com>
 <20200518065207.GA2193@nanopsycho>
 <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
In-Reply-To: <17405a27-cd38-03c6-5ee3-0c9f8b643bfc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [106.51.29.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: eca047a7-7455-4f72-2bd4-08d7fbb3ec63
x-ms-traffictypediagnostic: AM0PR05MB6482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6482EA876954A604C1D756FDD1B90@AM0PR05MB6482.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 040866B734
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 48Pv7ZmIfaveC0d8KXGwEiJYkgpH1qgqzdtlJPPQmp/qkpssDxkEGHTKP62lINQBr28to3sGHFix/sGKmRD074RokEIEV9UYmtOqofajHEsW+QOt0iRyYDXonwiQhNE8UJSOUs6l1Lh2lfc5rvSxzkaRzhSBfeQNH7z15/xmImf/IRXG+QqTVAnbdRC+H3X/FsaLcrtOi84v4vXrjpOYko8BW/dOXmNEqnIjsDp6/0KsDOkmyZSiH+xWVK7Nn7eQRzYZqsvShF//w6LXIsBwaQpXlllwicXcj4rAz31MK3zq/eTPjvJIP/CCkYPya1mMsGZSwzo2RNsosc6WQog/zWNY5PHMTLh7trCgXrGiXLrHGtvLKjuqoitWoqDTHXBLExeyPG84l2tp0KHvZx3JLuU29RqcFaCNzvcA7WDsCVwWjD7T/7apoDcKhwG1ECkWj65JT3kcO1/PPy+kdxNc5hXRbzmI0hdc46K5dJCsk97yqpfj3usl+gEHJrdFziPP37jG4HLfSxfgrHvKkm2QODeWHiM65eZ1rOnzGQWeT8/FBuTFUS0IXO6OlZLSS2rA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(4326008)(9686003)(52536014)(26005)(186003)(966005)(71200400001)(478600001)(33656002)(55016002)(5660300002)(2906002)(53546011)(8936002)(8676002)(55236004)(66446008)(64756008)(66476007)(66556008)(66946007)(76116006)(110136005)(7416002)(7696005)(316002)(6506007)(86362001)(54906003)(6606295002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YjP3lWGwKOsM7UYfMWANnfDbQY2g8dzqEcvWd1y70AmHuwB+Ygi4x88hQn/sK+WTlwO3iQG255AR3gWBUNAUuLqVFksQ4uHl9/LGHt9E/nDkZngVdYUzVD/37FPpvWviFRq0ilKn5ocZnpuBLeHtSenEz/dYgAWHgA30MgAHYv2jivVFUHOXI5Cu20mCpd1decrSnnX4TDGXPSTWMGB5+TlxfLrrB69gTwCJQfs2uMq7FrQudnFRo0bC1QAFv98nzix+/PintNXHa2JIoQed1B6wjBPIh4wskbqgWiE3K+P8SRQhtlAMvD7MxgQJLtFaOg5J9K73mgfGgTy27o72r3qvS7ArSTbJYz+ByW4wRq+DKqJUCFZmaH7ZQ5AxA4SVmMqEUPNA9kVvb0onwjQNume7yHFMvbgqzzXYevCe9QSpoQinlfle9xVhhR0AVzRkoXE9haQzO5OVK4dNr770r6/ZX6sNLMpVToYJIjH3gMNqE3nA4HucR0N/nKH7Q65+
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca047a7-7455-4f72-2bd4-08d7fbb3ec63
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2020 05:17:27.8215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: glozakZsdgzkYRF6wkAZtyA564lcRM90eWEQbpUSTp1hhGTswb+yQf3DBzb5CtnofgBHRB3IV3XBVhPlDB2/Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6482
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrZSwNCg0KPiBGcm9tOiBuZXRkZXYtb3duZXJAdmdlci5rZXJuZWwub3JnIDxuZXRkZXYt
b3duZXJAdmdlci5rZXJuZWwub3JnPiBPbg0KPiBCZWhhbGYgT2YgSmFjb2IgS2VsbGVyDQo+IA0K
PiANCj4gT24gNS8xNy8yMDIwIDExOjUyIFBNLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiA+IEZyaSwg
TWF5IDE1LCAyMDIwIGF0IDExOjM2OjE5UE0gQ0VTVCwgamFjb2IuZS5rZWxsZXJAaW50ZWwuY29t
IHdyb3RlOg0KPiA+Pg0KPiA+Pg0KPiA+PiBPbiA1LzE1LzIwMjAgMjozMCBBTSwgSmlyaSBQaXJr
byB3cm90ZToNCj4gPj4+IEZyaSwgTWF5IDE1LCAyMDIwIGF0IDAxOjUyOjU0QU0gQ0VTVCwgamFj
b2IuZS5rZWxsZXJAaW50ZWwuY29tIHdyb3RlOg0KPiA+Pj4+PiAkIGRldmxpbmsgcG9ydCBhZGQg
cGNpLzAwMDAuMDYuMDAuMC8xMDAgZmxhdm91ciBwY2lzZiBwZm51bSAxDQo+ID4+Pj4+IHNmbnVt
IDEwDQo+ID4+Pj4+DQo+ID4+Pj4NCj4gPj4+PiBDYW4geW91IGNsYXJpZnkgd2hhdCBzZm51bSBt
ZWFucyBoZXJlPyBhbmQgd2h5IGlzIGl0IGRpZmZlcmVudCBmcm9tDQo+ID4+Pj4gdGhlIGluZGV4
PyBJIGdldCB0aGF0IHRoZSBpbmRleCBpcyBhIHVuaXF1ZSBudW1iZXIgdGhhdCBpZGVudGlmaWVz
DQo+ID4+Pj4gdGhlIHBvcnQgcmVnYXJkbGVzcyBvZiB0eXBlLCBzbyBzZm51bSBtdXN0IGJlIHNv
bWUgc29ydCBvZiBoYXJkd2FyZQ0KPiA+Pj4+IGludGVybmFsIGlkZW50aWZpZXI/DQo+ID4+Pg0K
PiA+Pj4gQmFzaWNhbGx5IHBmbnVtLCBzZm51bSBhbmQgdmZudW0gY291bGQgb3ZlcmxhcC4gSW5k
ZXggaXMgdW5pcXVlDQo+ID4+PiB3aXRoaW4gYWxsIGdyb3VwcyB0b2dldGhlci4NCj4gPj4+DQo+
ID4+DQo+ID4+IFJpZ2h0LiBJbmRleCBpcyBqdXN0IGFuIGlkZW50aWZpZXIgZm9yIHdoaWNoIHBv
cnQgdGhpcyBpcy4NCj4gPj4NCj4gDQo+IE9rLCBzbyB3aGV0aGVyIG9yIG5vdCBhIGRyaXZlciB1
c2VzIHRoaXMgaW50ZXJuYWxseSBpcyBhbiBpbXBsZW1lbnRhdGlvbg0KPiBkZXRhaWwgdGhhdCBk
b2Vzbid0IG1hdHRlciB0byB0aGUgaW50ZXJmYWNlLg0KPiANCj4gDQo+ID4+Pg0KPiA+Pj4+DQo+
ID4+Pj4gV2hlbiBsb29raW5nIGF0IHRoaXMgd2l0aCBjb2xsZWFndWVzLCB0aGVyZSB3YXMgYSBs
b3Qgb2YgY29uZnVzaW9uDQo+ID4+Pj4gYWJvdXQgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGUg
aW5kZXggYW5kIHRoZSBzZm51bS4NCj4gPj4+DQo+ID4+PiBObyBjb25mdXNpb24gYWJvdXQgaW5k
ZXggYW5kIHBmbnVtL3ZmbnVtPyBUaGV5IGJlaGF2ZSB0aGUgc2FtZS4NCj4gPj4+IEluZGV4IGlz
IGp1c3QgYSBwb3J0IGhhbmRsZS4NCj4gPj4+DQo+ID4+DQo+ID4+IEknbSBsZXNzIGNvbmZ1c2Vk
IGFib3V0IHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gaW5kZXggYW5kIHRoZXNlDQo+ID4+ICJudW1z
IiwgYW5kIG1vcmUgc28gcXVlc3Rpb25pbmcgd2hhdCBwZm51bS92Zm51bS9zZm51bSByZXByZXNl
bnQ/DQo+IEFyZQ0KPiA+PiB0aGV5IHNpbWlsYXIgdG8gdGhlIHZmIElEIHRoYXQgd2UgaGF2ZSBp
biB0aGUgbGVnYWN5IFNSSU9WIGZ1bmN0aW9ucz8NCj4gPj4gSS5lLiBhIGhhcmR3YXJlIGluZGV4
Pw0KPiA+Pg0KPiA+PiBJIGRvbid0IHRoaW5rIGluIGdlbmVyYWwgdXNlcnMgbmVjZXNzYXJpbHkg
Y2FyZSB3aGljaCAiaW5kZXgiIHRoZXkNCj4gPj4gZ2V0IHVwZnJvbnQuIFRoZXkgb2J2aW91c2x5
IHZlcnkgbXVjaCBjYXJlIGFib3V0IHRoZSBpbmRleCBvbmNlIGl0J3MNCj4gPj4gc2VsZWN0ZWQu
IEkgZG8gYmVsaWV2ZSB0aGUgaW50ZXJmYWNlcyBzaG91bGQgc3RhcnQgd2l0aCB0aGUNCj4gPj4g
Y2FwYWJpbGl0eSBmb3IgdGhlIGluZGV4IHRvIGJlIHNlbGVjdGVkIGF1dG9tYXRpY2FsbHkgYXQg
Y3JlYXRpb24NCj4gPj4gKHdpdGggdGhlIG9wdGlvbmFsIGNhcGFiaWxpdHkgdG8gc2VsZWN0IGEg
c3BlY2lmaWMgaW5kZXggaWYgZGVzaXJlZCwgYXMgc2hvd24NCj4gaGVyZSkuDQo+ID4+DQo+ID4+
IEkgZG8gbm90IHRoaW5rIG1vc3QgdXNlcnMgd2FudCB0byBjYXJlIGFib3V0IHdoYXQgdG8gcGlj
ayBmb3IgdGhpcw0KPiA+PiBudW1iZXIuIChKdXN0IGFzIHRoZXkgd291bGQgbm90IHdhbnQgdG8g
cGljayBhIG51bWJlciBmb3IgdGhlIHBvcnQNCj4gPj4gaW5kZXggZWl0aGVyKS4NCj4gPg0KPiA+
IEkgc2VlIHlvdXIgcG9pbnQuIEhvd2V2ZXIgSSBkb24ndCB0aGluayBpdCBpcyBhbHdheXMgdGhl
IHJpZ2h0DQo+ID4gc2NlbmFyaW8uIFRoZSAibnVtcyIgYXJlIHVzZWQgZm9yIG5hbWluZyBvZiB0
aGUgbmV0ZGV2aWNlcywgYm90aCB0aGUNCj4gPiBlc3dpdGNoIHBvcnQgcmVwcmVzZW50b3IgYW5k
IHRoZSBhY3R1YWwgU0YgKGluIGNhc2Ugb2YgU0YpLg0KPiA+DQo+ID4gSSB0aGluayB0aGF0IGlu
IGxvdCBvZiB1c2VjYXNlcyBpcyBtb3JlIGNvbnZlbmllbnQgZm9yIHVzZXIgdG8gc2VsZWN0DQo+
ID4gdGhlICJudW0iIG9uIHRoZSBjbWRsaW5lLg0KPiA+DQo+IA0KPiBBZ3JlZWQsIGJhc2VkIG9u
IHRoZSBiZWxvdyBzdGF0ZW1lbnRzLiBCYXNpY2FsbHkgImxldCB1c2VycyBzcGVjaWZ5IG9yIGdl
dCBpdA0KPiBhdXRvbWF0aWNhbGx5IGNob3NlbiIsIGp1c3QgbGlrZSB3aXRoIHRoZSBwb3J0IGlk
ZW50aWZpZXIgYW5kIHdpdGggdGhlIHJlZ2lvbg0KPiBudW1iZXJzIG5vdy4NCj4gDQo+IA0KPiBU
aGFua3MgZm9yIHRoZSBleHBsYW5hdGlvbnMhDQo+IA0KPiA+Pg0KPiA+Pj4+IE9idmlvdXNseSB0
aGlzIGlzIGEgVE9ETywgYnV0IGhvdyBkb2VzIHRoaXMgZGlmZmVyIGZyb20gdGhlIGN1cnJlbnQN
Cj4gPj4+PiBwb3J0X3NwbGl0IGFuZCBwb3J0X3Vuc3BsaXQ/DQo+ID4+Pg0KPiA+Pj4gRG9lcyBu
b3QgaGF2ZSBhbnl0aGluZyB0byBkbyB3aXRoIHBvcnQgc3BsaXR0aW5nLiBUaGlzIGlzIGFib3V0
DQo+ID4+PiBjcmVhdGluZyBhICJjaGlsZCBQRiIgZnJvbSB0aGUgc2VjdGlvbiBhYm92ZS4NCj4g
Pj4+DQo+ID4+DQo+ID4+IEhtbS4gT2sgc28gdGhpcyBpcyBhYm91dCBpbnRlcm5hbCBjb25uZWN0
aW9ucyBpbiB0aGUgc3dpdGNoLCB0aGVuPw0KPiA+DQo+ID4gWWVzLiBUYWtlIHRoZSBzbWFydG5p
YyBhcyBhbiBleGFtcGxlLiBPbiB0aGUgc21hcnRuaWMgY3B1LCB0aGUgZXN3aXRjaA0KPiA+IG1h
bmFnZW1lbnQgaXMgYmVpbmcgZG9uZS4gVGhlcmUncyBkZXZsaW5rIGluc3RhbmNlIHdpdGggYWxs
IGVzd2l0Y2gNCj4gPiBwb3J0IHZpc2libGUgYXMgZGV2bGluayBwb3J0cy4gT25lIFBGLXR5cGUg
ZGV2bGluayBwb3J0IHBlciBob3N0LiBUaGF0DQo+ID4gYXJlIHRoZSAiY2hpbGQgUEZzIi4NCj4g
Pg0KPiA+IE5vdyBmcm9tIHBlcnNwZWN0aXZlIG9mIHRoZSBob3N0LCB0aGVyZSBhcmUgMiBzY2Vu
YXJpb3M6DQo+ID4gMSkgaGF2ZSB0aGUgInNpbXBsZSBkdW1iIiBQRiwgd2hpY2gganVzdCBleHBv
c2VzIDEgbmV0ZGV2IGZvciBob3N0IHRvDQo+ID4gICAgcnVuIHRyYWZmaWMgb3Zlci4gc21hcnRu
aWMgY3B1IG1hbmFnZXMgdGhlIFZGcy9TRnMgYW5kIHNlZXMgdGhlDQo+ID4gICAgZGV2bGluayBw
b3J0cyBmb3IgdGhlbS4gVGhpcyBpcyAxIGxldmVsIHN3aXRjaCAtIG1lcmdlZCBzd2l0Y2gNCj4g
Pg0KPiA+IDIpIFBGIG1hbmFnZXMgYSBzdWItc3dpdGNoL25lc3RlZC1zd2l0Y2guIFRoZSBkZXZs
aW5rL2RldmxpbmsgcG9ydHMgYXJlDQo+ID4gICAgY3JlYXRlZCBvbiB0aGUgaG9zdCBhbmQgdGhl
IGRldmxpbmsgcG9ydHMgZm9yIFNGcy9WRnMgYXJlIGNyZWF0ZWQNCj4gPiAgICB0aGVyZS4gVGhp
cyBpcyBtdWx0aS1sZXZlbCBlc3dpdGNoLiBFYWNoICJjaGlsZCBQRiIgb24gYSBwYXJlbnQNCj4g
PiAgICBtYW5hZ2VzIGEgbmVzdGVkIHN3aXRjaC4gQW5kIGNvdWxkIGluIHRoZW9yeSBoYXZlIG90
aGVyIFBGIGNoaWxkIHdpdGgNCj4gPiAgICBhbm90aGVyIG5lc3RlZCBzd2l0Y2guDQo+ID4NCj4g
DQo+IE9rLiBTbyBpbiB0aGUgc21hcnQgTklDIENQVSwgd2UnZCBzZWUgdGhlIHByaW1hcnkgUEYg
YW5kIHNvbWUgY2hpbGQgUEZzLA0KPiBhbmQgaW4gdGhlIGhvc3Qgc3lzdGVtIHdlJ2Qgc2VlIGEg
InByaW1hcnkgUEYiIHRoYXQgaXMgdGhlIG90aGVyIGVuZCBvZiB0aGUNCj4gYXNzb2NpYXRlZCBD
aGlsZCBQRiwgYW5kIG1pZ2h0IGJlIGFibGUgdG8gbWFuYWdlIGl0cyBvd24gc3Vic3dpdGNoLg0K
PiANCj4gT2sgdGhpcyBpcyBtYWtpbmcgbW9yZSBzZW5zZSBub3cuDQo+IA0KPiBJIHRoaW5rIEkg
aGFkIGltYWdpbmVkIHRoYXQgd2FzIHdoYXQgc3ViZnVudGlvbnMgd2VyZS4gQnV0IHJlYWxseQ0K
PiBzdWJmdW5jdGlvbnMgYXJlIGEgYml0IGRpZmZlcmVudCwgdGhleSdyZSBtb3JlIHNpbWlsYXIg
dG8gZXhwYW5kZWQgVkZzPw0KPg0KIA0KMS4gU3ViIGZ1bmN0aW9ucyBhcmUgbW9yZSBsaWdodCB3
ZWlnaHQgdGhhbiBWRnMgYmVjYXVzZSwNCjIuIFRoZXkgc2hhcmUgdGhlIHNhbWUgUENJIGRldmlj
ZSAoQkFSLCBJUlFzKSBhcyB0aGF0IG9mIFBGL1ZGIG9uIHdoaWNoIGl0IGlzIGRlcGxveWVkLg0K
My4gVW5saWtlIFZGcyB3aGljaCBhcmUgZW5hYmxlZC9kaXNhYmxlZCBpbiBidWxrLCBzdWJmdW5j
dGlvbnMgYXJlIGNyZWF0ZWQsIGRlcGxveWVkIGluIHVuaXQgb2YgMS4NCg0KU2luY2UgdGhpcyBS
RkMgY29udGVudCBpcyBvdmVyd2hlbG1pbmcsIEkgZXhwYW5kZWQgdGhlIFNGIHBsdW1iaW5nIGRl
dGFpbHMgbW9yZSBpbiBbMV0gaW4gcHJldmlvdXMgUkZDIHZlcnNpb24uDQpZb3UgY2FuIHJlcGxh
Y2UgJ2Rldmxpbmsgc2xpY2UnIHdpdGggJ2RldmxpbmsgcG9ydCBmdW5jJyBpbiBbMV0uDQoNClsx
XSBodHRwczovL21hcmMuaW5mby8/bD1saW51eC1uZXRkZXYmbT0xNTg1NTU5Mjg1MTc3Nzcmdz0y
DQo=
