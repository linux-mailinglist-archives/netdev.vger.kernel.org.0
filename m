Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA342803B
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 11:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhJJJjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 05:39:15 -0400
Received: from mail-eopbgr1410114.outbound.protection.outlook.com ([40.107.141.114]:56130
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230370AbhJJJjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 05:39:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h8ojZjPceb1lKWiECG2Sav8dRjlcoo9Yw06r/B6mxvfgvI1nRrMkn9FI9PHoB1EnpJntd8xK35BX3dTapYaEAqyo1D63w2qjukKv4rwEtbcen3unVtf+daCZJsIuOqjO2XC6p7SwSYpkYfA/DylnZelN1FcZ0UqIe7G+RghpGaA/cWIOTkZGrma+OhBcIevQaaFDVNBrl9Ej81R2ZXENz0UR82ngRtNITy1lC/uY98HZp8WRWTkusBBbkfvE4ZMxFS5Hn5oXsS2/T3cJW9Bn8oYihcsjjrYq+Cvd+pDQCUg++/+gD7rufWIAFm3JKOo2qWFjaQi1oD5SIEjiFSkanw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77XwZSNbhtk5TSS0cHI3rTjLoWC2Z3bfgC+yFUmaZFU=;
 b=VhpmTi2p+8rc+sAFm+Xgl5zbSBOfu1GLizvIE+G4yELPgJObuTQz9mN0p7AnlnsnafN98r4uwDb3SgUtSZoSgn44BX85TpwrXS1qxNSYuXyt8e+90Ln+ZXkkUdLTGyiNAcsZLZ5sNIrLddcqUn8GMZxmgGeNwgW2QP5nkeB+JLr7Qw1q98wdnxW/Nd/oG2b/neZ/oVsOLO+vNSY0TH3q/GdhVdjNdSfMiJ/1X2MxyJiAgYbnAWH0sTMlgiv8D0ftvkRHph/7n6WmIWBRcyfs9j0LH58J2ZdYjiZnXNPK6ZzWmDoiiswDwW1eX5LsEJkvLW1ysxZ5woVhXRbzzqlBsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77XwZSNbhtk5TSS0cHI3rTjLoWC2Z3bfgC+yFUmaZFU=;
 b=gz9CQy+LnsNP0OhOc3ffh0tDgQCJ94HmrfxErAbB5gohgqf9JnDSLj4NcS/+++fP0R8Qb/JjbFFXkOIeHRpquoHvSZ6nrMvSQDL/QGr9Pe8dd92BzrZN6ag/ZewIPc+WW6k8T9oetZs4zkwx9Z4FvwjXqiaTw860fFAl961wryc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB6998.jpnprd01.prod.outlook.com (2603:1096:604:12b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.24; Sun, 10 Oct
 2021 09:37:08 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 09:37:08 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
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
Subject: RE: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Topic: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Index: AQHXvaixd8lMzh4St0+QfQ9kX6MhhKvL9taAgAABWOA=
Date:   Sun, 10 Oct 2021 09:37:08 +0000
Message-ID: <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
In-Reply-To: <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce40a466-fab2-48c7-618c-08d98bd18736
x-ms-traffictypediagnostic: OS3PR01MB6998:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB69989F4E720F6D67726A7F6886B49@OS3PR01MB6998.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +CgYcvTXxh2LCwaznbL4Ev8TthptyHXsfKbzCv8H0PUGAY3GMzdSw6tsGSJTpYgtRjIzV4utiqxwMdaPLff1GrVqclaZsuEdDmU4N4Rqi8JumshPFGpBHL4iKighfkw4w/qAgfqBUarAuJJD9fEZmWew2KV91HcyuX7DqKkUqgE8BEpy/Pp5kQYM0R3SXgeCB4UGwyb+0Jm27tXQNFdiC7mDLprAGOJ8iw/YBDpmOeWV7LCJFDZkb79e5RaE7Q3MRCr93qpm7izff38QMC3Id+vFqeXGzYLpMK6KCKHa6Bg7M7SqWl/EBA6F6NBKwiD+U3IT6SWtzzvsrEUClNaeWc1OAxcnDNfuBS8eLbncg8rY00ekQx1/AkiyS5Ae2Y+x5pWZMtL5G4fRJr8kIDxNu31YkCLY7mU72Z46ybHOR8g31Dcu4/tmraniSkGYNU1zIj7Pv0ySc/z7gPRuU1a1TIOyGZH3UNsUM4ueYx8OQnJyy/spsMO3MYGOE6mma8g+YcSUPjwtlZDbeSfV6veXGqY8LT2pe5oEZxESOtbVj6tVsMfrjcTXFao2znAM0QQYUhweQ0Ypb5+sLFUGTJMtrJz6Rc1P0EL2veZMe5+j+bTbUgFdnuvX5q0BdTk9D5X8yWDWN7OrdzzbQN8/cfcUGFv3PJoqzrUJiOCUXRL4NBclkuw6ufq8+rMyoZJjhYZgiCYnFaDE/a/FjDMWN+wDpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(8936002)(38070700005)(52536014)(8676002)(4326008)(66476007)(5660300002)(7696005)(76116006)(66946007)(15650500001)(53546011)(6506007)(86362001)(66446008)(64756008)(66556008)(7416002)(9686003)(55016002)(71200400001)(107886003)(508600001)(54906003)(110136005)(26005)(122000001)(186003)(2906002)(316002)(83380400001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzB4aU0xN2VnNE0yQjUvMG83UzZTcS9kakhtL1N1cC83eFdMNVhybnl4Um9w?=
 =?utf-8?B?N1JveHU5a2lHM1VReU44SllvdUF4bDVKOVczSEZ0QWdLSDJvb2FKSFkwZm9o?=
 =?utf-8?B?NDBRUlZ4TkxNai9CS2Z1UHVReWUwbUxrd0cwV25nZWhITnZFbXBxK2lPdDlS?=
 =?utf-8?B?UkN5cDZsUHptaC9Ddk1jTlBvelM5cm12aGtXTVVVVVFHRUlRcjFVRUVzc1ZK?=
 =?utf-8?B?d3VNSmZ5ek5Id2psSGpKMlhVMGR4d3RtTlZWNFlLSFIxeEZtKzRwb3FNRWtv?=
 =?utf-8?B?SE1CckpodnNzNi9HZFNPV2ZIMFhBWlZQUHdrckR1YzdMT3JzeEo2SzI1eEpv?=
 =?utf-8?B?VWE3MmI3RHR4eU1xdUZsb2JsR2xvS0taR3dYRlRkM3dHTFJzb0JjWWJWb0JN?=
 =?utf-8?B?eWZhMnB1d2dxaWhRbWhEVFBycXJxZ0MwVDJmaEM3allLaWYyV3l2Rkc1STlt?=
 =?utf-8?B?Q0ZjaUl2cnFVTW9rUUwyK094Ym94NkhHMTZoMlpRVjZ0bEFMRUtJdGJ4dTND?=
 =?utf-8?B?clZMNHo3MEFzbWU1OHMzbDE4ZG5TaUk2VEJIazdkblFwQnNlNmx5SXhDWVVP?=
 =?utf-8?B?b0ZRVENxVytEUENBQ2ZzVys5WFI2MWZRS1hiRXVFaHFRR1J2TFhjRm1vSE53?=
 =?utf-8?B?UlhLU044SzRUTHpHRENrSFZTSklGOGUxbFBnSVFZNWp2bnhsTmFscGJicVZs?=
 =?utf-8?B?UmJXNkFBQjVGNFlRS3RZZkFzTEVNNzlDSlQ1bE1rVDZoZ2JCVEdQRnhZVW5p?=
 =?utf-8?B?djJwRW1hSWNYbldadWhEc0czMndySzU4a0E1eHZSQzJCN3ZJTTVWWFVrVktT?=
 =?utf-8?B?NERzdDJSM2hyZnMvVkxRLzM4UXBXd2xETWhHS0RHamQxRGJZQ2tlOEQ1QlJK?=
 =?utf-8?B?ZVdrUG9ySU5tUjNMYVZIZkpzRzhGdlkzb0hvV0x3U1lVSGwrMndicXpZR3o0?=
 =?utf-8?B?VmNoT2Q0MkljSWNjbUQ3eTVUQzg0cEhQYWd5aXU5N3hxN1BFVWNET2tJSWNZ?=
 =?utf-8?B?RktZaEdUWVpMWWN4NDRnS2gzaUlwakkzSXh5UGV3S0ovT01UdHFjZTZZcDdq?=
 =?utf-8?B?MVZWbXBrUFlvcGJOcTNFK1gyNkdDZTQxd2xnRnA4Y3JSVVo3VTRvdm4xbURD?=
 =?utf-8?B?VitiSW5ad3hMbXAwQVdJWHdtREM1b2VoZTZ1UStwczZHV1B5eTloWENYUTFr?=
 =?utf-8?B?UVJUS3Z5NDFrMW9lSXQ0aTFhWDBuS2tiNXhqNEJNYzdnU3Vhb2Rab1YrR3Rq?=
 =?utf-8?B?UVN2dHc2c3ZVMFBtZkV6L3FQVnlHbXFZTHFjY3Z2Rkt0d3R4RW1sZStiTXFL?=
 =?utf-8?B?Ukxqa2lMbDZTL3ZGbjM2YUNMMGtsSTZRVTIxSEE3OHhwQVZyVm50ekkwelBt?=
 =?utf-8?B?L1VqVlkrSEJVa3BYMFBOK2lFN1FjMm8xNGVna2JsUjNlZERpRFQ4dzMwRmNk?=
 =?utf-8?B?eGM1ZUtNbVgrS1Nyb2pHbHF5dlJnY2tkb1lHeWtGNDVtTTlrK2M1dE1pME5a?=
 =?utf-8?B?K3EyMDZvSnJkV0Q1bFJwVXV2Y1daMHZCYzRRNWE4U016Mlh5SS9xSTdNV3FZ?=
 =?utf-8?B?enZtV2ptbDRSMHgvejlmOWFFSWN2blliQlkySXE3NG9FaHU1Qm5YM05GTEJD?=
 =?utf-8?B?cVAyUkYxK3E4bWZNY2EyRWcvQ0s5U0dLZHExQm9yQ1Vpa25vWE5XQm9QZDZS?=
 =?utf-8?B?c1RuTHgxVGJ5UzR3Y2JHU0pzRHFBUXY3OVZra2hvWWc2OHZQVFBSN1ZXTHg1?=
 =?utf-8?Q?Rft7bMWHWHa7koyFrk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce40a466-fab2-48c7-618c-08d98bd18736
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 09:37:08.0468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5qN/CqCm1WZt/066ekwWoMJ26f+cXh8AbRgcl8B5+2kHwbzO0oQAZOLJRSIiOUOSJPGo5XiZG2nca2Xjl3xUMuAEDu7wVGlq3bLAZQ23t/c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6998
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2V5LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFNlcmdl
aSBTaHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT4NCj4gU2VudDogMTAgT2N0b2Jl
ciAyMDIxIDEwOjI4DQo+IFRvOiBCaWp1IERhcyA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+
OyBEYXZpZCBTLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPg0KPiBDYzogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9t
cC5ydT47IEdlZXJ0IFV5dHRlcmhvZXZlbg0KPiA8Z2VlcnQrcmVuZXNhc0BnbGlkZXIuYmU+OyBT
ZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wcnVzc2lhLnJ1PjsgQWRhbQ0KPiBGb3JkIDxh
Zm9yZDE3M0BnbWFpbC5jb20+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+OyBZdXVzdWtl
IEFzaGl6dWthDQo+IDxhc2hpZHVrYUBmdWppdHN1LmNvbT47IFlvc2hpaGlybyBTaGltb2RhDQo+
IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGxpbnV4LXJlbmVzYXMtDQo+IHNvY0B2Z2VyLmtlcm5lbC5vcmc7IENocmlzIFBhdGVyc29u
IDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+OyBCaWp1DQo+IERhcyA8YmlqdS5kYXNAYnAu
cmVuZXNhcy5jb20+OyBQcmFiaGFrYXIgTWFoYWRldiBMYWQgPHByYWJoYWthci5tYWhhZGV2LQ0K
PiBsYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQg
djIgMTMvMTRdIHJhdmI6IFVwZGF0ZSBFTUFDIGNvbmZpZ3VyYXRpb24NCj4gbW9kZSBjb21tZW50
DQo+IA0KPiBPbiAxMC4xMC4yMDIxIDEwOjI5LCBCaWp1IERhcyB3cm90ZToNCj4gDQo+ID4gVXBk
YXRlIEVNQUMgY29uZmlndXJhdGlvbiBtb2RlIGNvbW1lbnQgZnJvbSAiUEFVU0UgcHJvaGliaXRp
b24iDQo+ID4gdG8gIkVNQUMgTW9kZTogUEFVU0UgcHJvaGliaXRpb247IER1cGxleDsgVFg7IFJY
OyBDUkMgUGFzcyBUaHJvdWdoOw0KPiA+IFByb21pc2N1b3VzIi4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBTdWdnZXN0
ZWQtYnk6IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlvdkBvbXAucnU+DQo+ID4gLS0tDQo+ID4g
djEtPnYyOg0KPiA+ICAgKiBObyBjaGFuZ2UNCj4gPiBWMToNCj4gPiAgICogTmV3IHBhdGNoLg0K
PiA+IC0tLQ0KPiA+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8
IDIgKy0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMN
Cj4gPiBpbmRleCA5YTc3MGEwNWMwMTcuLmI3OGFjYTIzNWMzNyAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+IEBAIC01MTksNyArNTE5LDcg
QEAgc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXRfZ2JldGgoc3RydWN0IG5ldF9kZXZpY2UNCj4g
Km5kZXYpDQo+ID4gICAJLyogUmVjZWl2ZSBmcmFtZSBsaW1pdCBzZXQgcmVnaXN0ZXIgKi8NCj4g
PiAgIAlyYXZiX3dyaXRlKG5kZXYsIEdCRVRIX1JYX0JVRkZfTUFYICsgRVRIX0ZDU19MRU4sIFJG
TFIpOw0KPiA+DQo+ID4gLQkvKiBQQVVTRSBwcm9oaWJpdGlvbiAqLw0KPiA+ICsJLyogRU1BQyBN
b2RlOiBQQVVTRSBwcm9oaWJpdGlvbjsgRHVwbGV4OyBUWDsgUlg7IENSQyBQYXNzIFRocm91Z2g7
DQo+ID4gK1Byb21pc2N1b3VzICovDQo+IA0KPiAgICAgUHJvbWlzY3VvdXMgbW9kZSwgcmVhbGx5
PyBXaHk/IQ0KDQpUaGlzIGlzIFRPRSByZWxhdGVkIGFuZCBpcyByZWNvbW1lbmRhdGlvbiBmcm9t
IEJTUC9IVyB0ZWFtLiBJZiB5b3UgdGhpbmsgaXQgaXMgd3JvbmcuDQpJIGNhbiB0YWtlIHRoaXMg
b3V0LiBQbGVhc2UgbGV0IG1lIGtub3cuIEN1cnJlbnRseSB0aGUgYm9hcmQgaXMgYm9vdGluZyBh
bmQgZXZlcnl0aGluZyB3b3JrcyB3aXRob3V0IGlzc3Vlcy4NCg0KVGhlIG1lYW5pbmcgb2YgcHJv
bWlzY3VvdXMgaW4gSC9XIG1hbnVhbCBhcyBmb2xsb3dzLg0KDQpQcm9taXNjdW91cyBNb2RlDQox
OiBBbGwgdGhlIGZyYW1lcyBleGNlcHQgZm9yIFBBVVNFIGZyYW1lIGFyZSByZWNlaXZlZC4gU2Vs
Zi1hZGRyZXNzZWQgdW5pY2FzdCwNCmRpZmZlcmVudCBhZGRyZXNzIHVuaWNhc3QsIG11bHRpY2Fz
dCwgYW5kIGJyb2FkY2FzdCBmcmFtZXMgYXJlIGFsbCB0cmFuc2ZlcnJlZCB0bw0KVE9FLiBQQVVT
RSBmcmFtZSByZWNlcHRpb24gaXMgY29udHJvbGxlZCBieSBQRlIgYml0Lg0KMDogU2VsZi1hZGRy
ZXNzZWQgdW5pY2FzdCwgbXVsdGljYXN0LCBhbmQgYnJvYWRjYXN0IGZyYW1lcyBhcmUgcmVjZWl2
ZWQsIHRoZW4NCnRyYW5zZmVycmVkIHRvIFRPRS4NCg0KUmVnYXJkcywNCkJpanUNCg0KPiANCj4g
PiAgIAlyYXZiX3dyaXRlKG5kZXYsIEVDTVJfWlBGIHwgKChwcml2LT5kdXBsZXggPiAwKSA/IEVD
TVJfRE0gOiAwKSB8DQo+ID4gICAJCQkgRUNNUl9URSB8IEVDTVJfUkUgfCBFQ01SX1JDUFQgfA0K
PiA+ICAgCQkJIEVDTVJfVFhGIHwgRUNNUl9SWEYgfCBFQ01SX1BSTSwgRUNNUik7DQo+IA0KPiBN
QlIsIFNlcmdleQ0K
