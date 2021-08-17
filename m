Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6293EEEEF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 17:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238086AbhHQPJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 11:09:28 -0400
Received: from mail-eopbgr1400135.outbound.protection.outlook.com ([40.107.140.135]:12443
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237052AbhHQPJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 11:09:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HQ9NPdB219TqmEsXhbFu4aDnPkz9BotIYNtbifqEoP/vwNtEMTZTG23rsqfaD+aeE5m9uS6E6nTJPEB41ceCbOn2V46QHaZhetQ/MCFxjFR7HBPJckBstTa5X3ASeo4NZfHIQhaJK9qluHJIjw2fMZmTuuyXE834xek5Cgurpa0XC6MZx/c0LpmDEZg5Y3NqvfnpUVD4UBYbuFdHD1uKW2RnWQpkwqpVT+h5v16yuv2TB5SLjHmhEUn9vm+WgiFrZdERKG84aM5D3lq0/lBW+hcgxMNBos2pUlLdJQH58fk9Mjwk2oClhs44Ry8Y9oFQcpH0kj0C07LJ6eC926yZBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaZeaKMVTUhIgZnSUmkxsgkyJ5VCJiUmP+LbDxYxKfQ=;
 b=aPFKsOPTW4a0EqL0/MXhS7fSQwm6UikiUuIRgykbnU1jHx1QaJEtayt0m4NKXQ2yr1LJQpfhsaV1iz+P/Lj3hqYNs23PkmwNAqYMPbs8qydvcg75cDgA2rpyQ8uunjnvaixbCzAl68FpsaDHleBjY82PpQm/lmTQvNQ1odjQMzZ1UmDWcJD74r57hkYgk6AvW2X+jNO1ev9L5ypenaglQdCghEpUOjw1ZUNN7Qaga9uS2hGFKZtTSlbmUzqvrYaLi+kG2udcxIC88lYV+bWkaup/JNF8eTV9K+f1c7ZOmWKPuCxKXt6UcF79BCNfjpPACWt3HctEB4zp5Ub0eJ5Jmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LaZeaKMVTUhIgZnSUmkxsgkyJ5VCJiUmP+LbDxYxKfQ=;
 b=V+KhoLSieJLdwQks0Pj9xzPBrHlOypJl9bi3DSBFRMCqdT2SkrtfzRVGBSe9P+/Pz4GrIGIAgMEEBoFiRX4T5R2vThYRZJD8CbwENfQ0wnlm64w1p48zXiOTksQ1LLJIhou39WyW830ol53vZU00OtK/IRRHsRXres9v/MoHBSM=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5958.jpnprd01.prod.outlook.com (2603:1096:604:d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Tue, 17 Aug
 2021 15:08:48 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 15:08:48 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Index: AQHXh4j6N5nNIwH/Qk677Je5gv3Cy6tiGcmAgAANlPCAAAN1gIAABJeQgBW0YfA=
Date:   Tue, 17 Aug 2021 15:08:48 +0000
Message-ID: <OS0PR01MB5922747E9134F21AF2D4F5E986FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
 <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
 <OS0PR01MB5922F86AB0FDB179B789B6DD86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <f5695fbd-f365-c86e-3ca2-41cf59ad8354@gmail.com>
 <OS0PR01MB59220F188237ADB3BBFDBD5186F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59220F188237ADB3BBFDBD5186F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b11a0fc8-702d-4e50-eb7f-08d96190ea4c
x-ms-traffictypediagnostic: OS3PR01MB5958:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB595843AB3D2BD26408F01A3286FE9@OS3PR01MB5958.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4vKSNaO+TMjzWdDBf7pIRrF516VGw71jH7OuWfg+bMmC0g2w0pXsmNblZVIODSBdiJFtUEghAzHT7sK3LPN2gVxXIXomqvDHCmSobKXGrA6+qxEHah/6wYRibuQ2JQycwxyA2ItMgK8RgNwuiDNHpTSldanZ2zHZ35iQ5vfMDJ2IVIGB2D0dKqYw4I6VnpbKJKhNUkqHDT7Pa3O4FjqhA1ruR3vvoOL5omO1QhZ1xBg1hR28ue+KRDQtbDskjqRLdt9tSdjM9EkXOFYLp19XfGsGi7TEeZeQkzpR1g4ZmWmeZNFAEkJGI9agB1BSPMqCHC0ZBXQf2SgF/ioTBkcrtRqrwK3/qRRxniSx6TzKulPzavuge5YL1DVFdwR3QYQ3fx7EPar2D4DCTat4RD7Hf6gCiQEZJKdQ4OcfTAOk5oqfKh8nCijUCAxMjcI50sUhWNyWeCw+/c4bn4PyOzg+ElBUTw6wbqPt92sygf0cLbIQ94bp5k/H9omGmdxqD2JUe9sEEwdAVPhQiuuM8mL4C98FlxGmsy6WVLCKBv4gnczYfLxqdCQpmfbR0rBe6rklRH/Dj49MBHyeW33D1D3qTdcRAL4L6brzyUOBe+Gq/6pFUWZE+G00YYnTeSrF6Pyu4z1oW7A0P+k0NG8yMCYcZrVTnNcvG/Bk6zcWaoMFEt3PIhecMtFsAnU2SyJzxa0tyEHA6MKAp8Vqjy0G+FwuLg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(2906002)(8936002)(122000001)(38100700002)(107886003)(478600001)(86362001)(5660300002)(55016002)(71200400001)(52536014)(33656002)(4326008)(7416002)(8676002)(7696005)(316002)(76116006)(66946007)(38070700005)(66556008)(66476007)(54906003)(66446008)(64756008)(110136005)(186003)(9686003)(26005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGQ5MGtJaWVwRS83YjlyaXpiV0tPRGdjUng1dnIxWGZ1Q29ManVpVEZKd240?=
 =?utf-8?B?RGFEMkE3Zlpvc2VFOWgzR1VhSnRXRkVPR1I5UmljczhOOU5vVHQzdGd0cGVL?=
 =?utf-8?B?WGRvd1R4bmV5S3pkNm11bDJTYStDZDF4V3Z2QjY4dTZaSHNGZkJSRXRGVmk4?=
 =?utf-8?B?aVZ5L0I0RUt1RTNmS3U3dFJDcnJvZ0pYMFBqS2N3WFhVRUlyQ0pjL1RjSTl6?=
 =?utf-8?B?MFB1ZlAvcDZOcVVFaHZETnZKUjlaZjAxa21aUE81c3VlR25UdVFQZzFBd1V1?=
 =?utf-8?B?U1RHaDdsTWNoS2dtT1FmSy9YSDRNTEJnUGxRZkllM1lKdnMvUnZ3MzNRa2Fk?=
 =?utf-8?B?c2JyVGk3VDhMUjA2bGpDV0Y3VUNReHRTbU1QVE9meXBiclNXcDJOVmpiaSsx?=
 =?utf-8?B?aDJ2VFV3MHBSOS9rWk5HMnNtZDJ3UXIrUHhOL0ZtQ1JOWlBzcHpiVG93cFdr?=
 =?utf-8?B?YnJlQ1FCOTVjUFB0WGNxaVUrcFhMWXMreStLQzZFdnh3SkVaSndHTUtaMnFF?=
 =?utf-8?B?MysvVURGUVhDRnhTYkY3Tlloem9lY0VrRGdoTFloSkJKb2RybTBNb1R5VDVz?=
 =?utf-8?B?NzBDMkZxay9KRUJJdEVpTnI3VXdiSGdhck4veG5pTE5uS1JoUlRoamluQXlE?=
 =?utf-8?B?QXhteHQ5TmlBQzhJV2VqSHY5Ull5Q3pEM0VVREJBSFJ3ZXJCdE1CNDFuM0Jh?=
 =?utf-8?B?TjVoR1dGeFNLcDJBTUpKcEdpVitHWkVYUUQwaXFXQ3pQL0ZQYWxIb1AvK3VB?=
 =?utf-8?B?RnFLSXNGRGJPd3h2TnBwd0ZjdnhGSlptQklFSWhzSzRZOFY2ZEJwK0ovb1Z5?=
 =?utf-8?B?WndlZFd6YVp0dDhqOVlEZmxQS09GM1pZeXN5UzlHNHMwZmQvYnk0RXZFNDBN?=
 =?utf-8?B?czRVR0FEWkVobStUdjZmVVQ5L05EL2J0SzJBdnVsV1JueXJ4L1QxTXVqcFoy?=
 =?utf-8?B?blIwWWZSb2RXVHNGNHRkZ2VvSXZaeU5oK2F4emVtOGVtY0VrM2szNVBBRzh6?=
 =?utf-8?B?NHlZV0JIY2phZkxEbTE4OHBDWmFqeXBlSFV6cFlUUGJkcFZLbG42NUdHeDNS?=
 =?utf-8?B?K1pyUzE2ZjN4MFBHR1ZJbDgwVHp1Z29WME5WYlpXT0hzQTdVMTkrbUs0aEhP?=
 =?utf-8?B?a0tySVZlcy9YQUNtMUpTdVIydmRZekVWdFk0SXhIMnEvdG5UN0tlUTNSU3FU?=
 =?utf-8?B?d1JKZXZwNjVGajB2RCtXZ0dxSW9nNEk1RG5UN1g2czRaTUs0TC9aWDlkSlVz?=
 =?utf-8?B?eFRseFFtaC84cFVURjAzaGdkRUpUZk40ZUgvZmVxRHdCSWNaWXBCdnlQYUFM?=
 =?utf-8?B?bUEyWXBkNnhqbmZCWmxRMFRXM21JcTRWVE5XcDlDS1JQbmxtdm1hL1YzUGJ0?=
 =?utf-8?B?b2ZwS01ZRElKOG1FeUtEUWlXNEZEMHdBZCtCV3d4K1lSZDFJWmlLQmoxbHAr?=
 =?utf-8?B?ZmxIWDF1S1VCYzVwNzVINmJVWGVxMEk1SWUrSmpoR042eHhVTnpqWFJFOW5x?=
 =?utf-8?B?N0NYdFJoTFdDYTAvS2pyQmlGV3F2WTk4NGVHVC9lR0VIQTB6c3hlbWNCSmpR?=
 =?utf-8?B?WGVVekFkb2FPd2xxZjlhanUrK0NZbXFFT3pieXd0NVNHMUo4YWJoLy9lczNB?=
 =?utf-8?B?NzFmNWlPTzVLWUtiREJSOFdRY3BOTTlxYXRIalUxUzZsZXpjNW00Zzg5cmZk?=
 =?utf-8?B?VnNXZnUzUWlJK0wzTDFRTm83eHh1YzdVc3QxV2grd1NQd3BPcStFOFd6Uy83?=
 =?utf-8?Q?2T/MhQdkFCt9IuBybWJ/ZcUCcxnCww3KgPJ6VyI?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11a0fc8-702d-4e50-eb7f-08d96190ea4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 15:08:48.1405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: THRJocEkfLnDTvkg1l/+P+R0OBRURlzx8rrBlYf3Q7TvMMQ5L7p0X+goqXLRZpujvtWIkvso6bETCbQEPNT+Wt0tJ92oTNfIv14RgxEOgR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5958
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsLA0KDQpJIGhhdmUgdGVzdGVkIHdpdGhvdXQgdGhpcyBwYXRjaCBhbmQgZ290IGV4cGVj
dGVkIHJlc3VsdHMuIFNvIEkgYW0gZHJvcHBpbmcgdGhpcyBwYXRjaCBpbiB0aGUgbmV4dCB2ZXJz
aW9uLg0KDQpDaGVlcnMsDQpCaWp1DQoNCj4gU3ViamVjdDogUkU6IFtQQVRDSCBuZXQtbmV4dCB2
MiAzLzhdIHJhdmI6IEFkZCBudW1fZ3N0YXRfcXVldWUgdG8gc3RydWN0DQo+IHJhdmJfaHdfaW5m
bw0KPiANCj4gSGkgU2VyZ2VpLA0KPiANCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IHYyIDMvOF0gcmF2YjogQWRkIG51bV9nc3RhdF9xdWV1ZSB0bw0KPiA+IHN0cnVjdCByYXZiX2h3
X2luZm8NCj4gPg0KPiA+IE9uIDgvMy8yMSAxMDoxMyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+ID4N
Cj4gPiBbLi4uXQ0KPiA+ID4+PiBUaGUgbnVtYmVyIG9mIHF1ZXVlcyB1c2VkIGluIHJldHJpZXZp
bmcgZGV2aWNlIHN0YXRzIGZvciBSLUNhciBpcw0KPiA+ID4+PiAyLCB3aGVyZWFzIGZvciBSWi9H
MkwgaXQgaXMgMS4NCj4gPiA+DQo+ID4gPj4NCj4gPiA+PiAgICBNaG0sIGhvdyBtYW55IFJYIHF1
ZXVlcyBhcmUgb24geW91ciBwbGF0Zm9ybSwgMT8gVGhlbiB3ZSBkb24ndA0KPiA+ID4+IG5lZWQg
c28gc3BlY2lmaWMgbmFtZSwganVzdCBudW1fcnhfcXVldWUuDQo+ID4gPg0KPiA+ID4gVGhlcmUg
YXJlIDIgUlggcXVldWVzLCBidXQgd2UgcHJvdmlkZSBvbmx5IGRldmljZSBzdGF0cyBpbmZvcm1h
dGlvbg0KPiA+ID4gZnJvbQ0KPiA+IGZpcnN0IHF1ZXVlLg0KPiA+ID4NCj4gPiA+IFItQ2FyID0g
MngxNSA9IDMwIGRldmljZSBzdGF0cw0KPiA+ID4gUlovRzJMID0gMXgxNSA9IDE1IGRldmljZSBz
dGF0cy4NCj4gPg0KPiA+ICAgICBUaGF0J3MgcHJldHR5IHN0cmFuZ2UuLi4gaG93IHRoZSBSWCBx
dWV1ZSAjMSBpcyBjYWxsZWQ/IEhvdyBtYW55DQo+ID4gUlggcXVldWVzIGFyZSwgYXQgYWxsPw0K
PiANCj4gRm9yIGJvdGggUi1DYXIgYW5kIFJaL0cyTCwNCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAjZGVmaW5lIE5VTV9SWF9RVUVVRSAgICAyDQo+ICNkZWZpbmUgTlVNX1RYX1FVRVVF
ICAgIDINCj4gDQo+IFRhcmdldCBkZXZpY2Ugc3RhdCBvdXRwdXQgZm9yIFJaL0cyTDotDQo+IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiByb290QHNtYXJjLXJ6ZzJsOn4j
IGV0aHRvb2wgLVMgZXRoMA0KPiBOSUMgc3RhdGlzdGljczoNCj4gICAgICByeF9xdWV1ZV8wX2N1
cnJlbnQ6IDIxODUyDQo+ICAgICAgdHhfcXVldWVfMF9jdXJyZW50OiAxODg1NA0KPiAgICAgIHJ4
X3F1ZXVlXzBfZGlydHk6IDIxODUyDQo+ICAgICAgdHhfcXVldWVfMF9kaXJ0eTogMTg4NTQNCj4g
ICAgICByeF9xdWV1ZV8wX3BhY2tldHM6IDIxODUyDQo+ICAgICAgdHhfcXVldWVfMF9wYWNrZXRz
OiA5NDI3DQo+ICAgICAgcnhfcXVldWVfMF9ieXRlczogMjgyMjQwOTMNCj4gICAgICB0eF9xdWV1
ZV8wX2J5dGVzOiAxNjU5NDM4DQo+ICAgICAgcnhfcXVldWVfMF9tY2FzdF9wYWNrZXRzOiA0OTgN
Cj4gICAgICByeF9xdWV1ZV8wX2Vycm9yczogMA0KPiAgICAgIHJ4X3F1ZXVlXzBfY3JjX2Vycm9y
czogMA0KPiAgICAgIHJ4X3F1ZXVlXzBfZnJhbWVfZXJyb3JzOiAwDQo+ICAgICAgcnhfcXVldWVf
MF9sZW5ndGhfZXJyb3JzOiAwDQo+ICAgICAgcnhfcXVldWVfMF9jc3VtX29mZmxvYWRfZXJyb3Jz
OiAwDQo+ICAgICAgcnhfcXVldWVfMF9vdmVyX2Vycm9yczogMA0KPiByb290QHNtYXJjLXJ6ZzJs
On4jDQo+IA0KPiANCj4gVGFyZ2V0IGRldmljZSBzdGF0IG91dHB1dCBmb3IgUi1DYXIgR2VuMzot
DQo+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gcm9vdEBoaWhv
cGUtcnpnMm06fiMgIGV0aHRvb2wgLVMgZXRoMA0KPiBOSUMgc3RhdGlzdGljczoNCj4gICAgICBy
eF9xdWV1ZV8wX2N1cnJlbnQ6IDM0MjE1DQo+ICAgICAgdHhfcXVldWVfMF9jdXJyZW50OiAxNDE1
OA0KPiAgICAgIHJ4X3F1ZXVlXzBfZGlydHk6IDM0MjE1DQo+ICAgICAgdHhfcXVldWVfMF9kaXJ0
eTogMTQxNTgNCj4gICAgICByeF9xdWV1ZV8wX3BhY2tldHM6IDM0MjE1DQo+ICAgICAgdHhfcXVl
dWVfMF9wYWNrZXRzOiAxNDE1OA0KPiAgICAgIHJ4X3F1ZXVlXzBfYnl0ZXM6IDM4MzEzNTg2DQo+
ICAgICAgdHhfcXVldWVfMF9ieXRlczogMzIyMjE4Mg0KPiAgICAgIHJ4X3F1ZXVlXzBfbWNhc3Rf
cGFja2V0czogNDk5DQo+ICAgICAgcnhfcXVldWVfMF9lcnJvcnM6IDANCj4gICAgICByeF9xdWV1
ZV8wX2NyY19lcnJvcnM6IDANCj4gICAgICByeF9xdWV1ZV8wX2ZyYW1lX2Vycm9yczogMA0KPiAg
ICAgIHJ4X3F1ZXVlXzBfbGVuZ3RoX2Vycm9yczogMA0KPiAgICAgIHJ4X3F1ZXVlXzBfbWlzc2Vk
X2Vycm9yczogMA0KPiAgICAgIHJ4X3F1ZXVlXzBfb3Zlcl9lcnJvcnM6IDANCj4gICAgICByeF9x
dWV1ZV8xX2N1cnJlbnQ6IDANCj4gICAgICB0eF9xdWV1ZV8xX2N1cnJlbnQ6IDANCj4gICAgICBy
eF9xdWV1ZV8xX2RpcnR5OiAwDQo+ICAgICAgdHhfcXVldWVfMV9kaXJ0eTogMA0KPiAgICAgIHJ4
X3F1ZXVlXzFfcGFja2V0czogMA0KPiAgICAgIHR4X3F1ZXVlXzFfcGFja2V0czogMA0KPiAgICAg
IHJ4X3F1ZXVlXzFfYnl0ZXM6IDANCj4gICAgICB0eF9xdWV1ZV8xX2J5dGVzOiAwDQo+ICAgICAg
cnhfcXVldWVfMV9tY2FzdF9wYWNrZXRzOiAwDQo+ICAgICAgcnhfcXVldWVfMV9lcnJvcnM6IDAN
Cj4gICAgICByeF9xdWV1ZV8xX2NyY19lcnJvcnM6IDANCj4gICAgICByeF9xdWV1ZV8xX2ZyYW1l
X2Vycm9yczogMA0KPiAgICAgIHJ4X3F1ZXVlXzFfbGVuZ3RoX2Vycm9yczogMA0KPiAgICAgIHJ4
X3F1ZXVlXzFfbWlzc2VkX2Vycm9yczogMA0KPiAgICAgIHJ4X3F1ZXVlXzFfb3Zlcl9lcnJvcnM6
IDANCj4gDQo+IENoZWVycywNCj4gQmlqdQ0KDQo=
