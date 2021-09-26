Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65187418A40
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 18:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhIZQxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 12:53:43 -0400
Received: from mail-eopbgr1410114.outbound.protection.outlook.com ([40.107.141.114]:13325
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229457AbhIZQxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 12:53:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDUIZaXmpb6Q/Des1HhXPlKTNH9ndUf7saj885Tft7WG6FJD/MernKr+aZ8qLn+qG08zmw2iGZ6gD/xKSJ04EqjKsrbCFdCuskYO9KtaUdSQ8lk55IfLRBeSsyG4t1LDcAs/OAWBxwIPQw+s9Jc8QPsWFhx6FFRPJi9HePTbIByMRPmhXQjCtcee6srQL+Od5mDJyUQjtQf84wCuNn1MCpEzzIjSKnWndslrKVx69KkOrflrNEsBmERnt26P73MWXy2PECTyvzDdQTGPEgyuxPHOhAEVKiUumpmF2A+nsj5jVX3MTMj8KsWC+GSJCCi9QF6pD+kTE7cgfLAm2XkSiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iBnsJzkTasOnjQcYu/wN5f32VtP/FbsVfkcg4Q5pHwg=;
 b=RUcSXSHIe4F5PlbqASHI+xdhu2BSj74dSy0oWAErkpS4h40Rs6hh6SgUI9FJfoYq1uFcv8nXdOgwi4kBR0efq4V86ncBc1WYmnyM4THCVDR0Nup7HNHaaWnm/kDOXMOMG8bCLwM3zWsSxA8iGvVy+B9zBfslgJ9IBX88VUCt5pGWRg70QT7G1PvKsHXqE/Y/4gL3p0t10wjR+7uyvScXI5UdbIOFi0eWYVXkEVqAzit8Y0vTVVIduSzMWu8Sgo9sAWAklell/G2jsbu8rKbE3TmXr/QwpcR/SqTvWTpMKityZGachGD36mj3c0Fd3wBfH4zDZW2X0upDpQNABQshlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iBnsJzkTasOnjQcYu/wN5f32VtP/FbsVfkcg4Q5pHwg=;
 b=rxVoVVoOF4rByX5L2PDMGWrFpJ1BNzkQs8B/ZJwoGf5vQJ40kUzdX5I3UMfoDjoKdDTru0EE/UFTZMyNN4HiEEjjaQlQtuX+v8NaKcwFH417Ly4Jv+UTIdHLQmIpNMR3MS3ypDjazTKHU6PqVLIjxUJMO+cVcecYoettK3yU5ks=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2936.jpnprd01.prod.outlook.com (2603:1096:604:18::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Sun, 26 Sep
 2021 16:52:01 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 16:52:00 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Topic: [RFC/PATCH 12/18] ravb: Add timestamp to struct ravb_hw_info
Thread-Index: AQHXsISOUUpjeBVcoEe6exCe5Ob9S6u1PXqAgACeaaCAALAcwA==
Date:   Sun, 26 Sep 2021 16:52:00 +0000
Message-ID: <OS0PR01MB59228A66BAF0620DF7293D6086A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-13-biju.das.jz@bp.renesas.com>
 <ef7c0a4c-cd4d-817a-d5af-3af1c058964f@omp.ru>
 <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB5922426AACFBDF176125A9AF86A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6a90b3ef-2498-4af5-86f1-08d9810df5e6
x-ms-traffictypediagnostic: OSBPR01MB2936:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2936F4359CD53AE0842F902086A69@OSBPR01MB2936.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Aumy5G9UhpHMu+CiVBK/4iAjtv8fDDnIwXiXjXG3zOXLoWQwXQwS8RDZ9fHPbBVeUR+YqsHeGll/E9W12AsY5rdfaNQxRETfGkkuocE22/AFfF5cZHOIZ1GsygmGFx/0xv83euHsK3JXSYCgq3VZbpEgFWrg0N7IQf7BVvudWwTttASh7gG2YJAyp34NAkc/FTjwLdCQt8Mxv6eD2De8gZQL/m2W0m4JcarcRcFNKKl50J8tVI8Dbp9Acaf53y/32U2nxfY5YvOxK8CjUq3G3i4JOakoXdTXs19atsVuNTORxMlOOER5+B2j/wiLCs5XYOr0FNXmYwqD3Q3U+q8A4Skv+ryufrb0iSidr/N2vXtNYNfv0qgbTsA+mURIo45uFu9iqhirF2Sb44biCoNOvgN9T1UMUVNbjj6I6aHzZaOBdmHk0ZIiMKLB7MOj3VRHQa4HnHm33QGlsCF3ESdXusivWeLwCO3G5Xg/2UWLE5GT81zHCv+OEZ9+3h6FmTVcq4ijo+DglZu0EJ0Q2eXEDkKrX9iZ5MP7GB0NOTwfVyY61l1YNgz+Oqmap8D3Vz8nFWXWp5bk6vOyX9WaMZJqTaoUJNm1Nl87MsFhoshhVpFJZ/S0WUauv/x2yQavOaJPWHSF44p939wmJybxE7P4+zW5WAfTfQ4fm8WzZRLdxCDYGKJ1hdBLFdFhvMK5k7ij9ITodbE00LW9Z1PSWX++pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(9686003)(54906003)(38070700005)(26005)(110136005)(508600001)(8936002)(107886003)(2906002)(186003)(122000001)(38100700002)(52536014)(4326008)(86362001)(316002)(7696005)(83380400001)(2940100002)(33656002)(66556008)(64756008)(66476007)(66446008)(5660300002)(66946007)(71200400001)(76116006)(8676002)(53546011)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3ZNNWN4SloyZGJES1FCRE5wUkt2WVNDMHpzb3kwRDk4WW0wZllLc2dWVDhF?=
 =?utf-8?B?ZXVsSjFXaDYxQ2RYRkpWeEFaVjBHYzVMcTZuTFFsNmQydzhUNnl0UU02YUEw?=
 =?utf-8?B?eGxCMkQzUFpLZ2ZMc0FjSy9nMjJoRmdTMG14STUvVWtwT0NuY3Y5ZExKbzI4?=
 =?utf-8?B?NkNidysxeE9IM3dmcjF1SWs4UFFyTjdDcGRjeno4R1QyNFVESzcvdjRPMVlR?=
 =?utf-8?B?UFYyZkpNQlFCaVhkWU5hWll6emNoRU05MmY5Um9jTTFnRjJjdzN5dnJEZUV4?=
 =?utf-8?B?ZUpYQlh1UGtYUXI2SzNoUW1lZ0lTV0J0dTBVUmk2cys3NEpwV1MzQ3RTQjZV?=
 =?utf-8?B?Y0lnb3I0SVdxdlhicnE2YUlsWnBETmRvbXZ0aUZhekFndFFQU1BqMURtVXVr?=
 =?utf-8?B?Z1pkRlRwVjg3T3ViL0JFWTN0VGhUaUgxcDlySlhzUHRSaW9iYXNsUW40eUtL?=
 =?utf-8?B?cUJVa2Q1aWpRcXNoVXg3NUl4aU9UTFdZdUxTZXNZMURNNW16Wlk3dUtqT2gy?=
 =?utf-8?B?elVjNUtLOTVaTXlQLzA1VWE1amt0UEVLSC85WkFDSHJaL0o5WS9LTG9BdEhZ?=
 =?utf-8?B?QjRnMDBzT3gxYXVQQlJrMGhqSVJqVWVpVy8vUFI4WXd4T2RLM0xWUkhINjlj?=
 =?utf-8?B?TmVsUmdVQXNYQVIrdDZSOU1Cb25FMllkTi9NcjdFb1RKbHphY0I0NFc5S21o?=
 =?utf-8?B?ZHNnSkJBaXBIc3ZTL3dkckIwQnlpQzNEU1E0N3VYWVdGd0xva2JScWYvVDR0?=
 =?utf-8?B?SStGNGs2eW9hYjFxc2FTSElDVDNDQjNJSW02ZFlHeXMrZXZaUXUvV2RJeHpB?=
 =?utf-8?B?enlPRWpXbXVWbXVudmdnamxncnkyNzV5UWtjVnkwUFIreW1iTUJLQVNJSzZP?=
 =?utf-8?B?WmYvbFJxYTJkN2dLWm41bFY2YUYzZHJFaUhwcDhtZndjTUJpVVY3bWxlV2VK?=
 =?utf-8?B?K2F6OXBvOTFmSngyQ0kvL1JYSkRteFhtTnM2MVNCZnFZdit2UGlJcktWdWdD?=
 =?utf-8?B?ekRESURjbzZGeCtOQy8zQndSQkxHbm1IMTBaenRCaGpBZERmUUtjRWIvV0J5?=
 =?utf-8?B?cnFmbG1yeXhWY1RxdVpsYzlEVGRrY3FSVjNCYmxjMVR2TmY5Slp4UGtnZTJr?=
 =?utf-8?B?WFVWQkFQM1oxRmt6ZXlvOVBISlFZN3pyNkJWb2hKSVl2ci96bm1GN3haa25U?=
 =?utf-8?B?bzFTd3Jod1o1SlRiTG5hb2pWeGhiZG5YNWFyM3pjVUFIWElmYlZCK0ZabGY5?=
 =?utf-8?B?TmxsNmxhY3oydGRoaXFSeVJ0TE5QYmlEMUJMZ2MxdFIxZ0lHQVM3WXpFb0xn?=
 =?utf-8?B?VWVOV2x5WHpQdnpQRnVjUzlZMmIxYVVlMm5Paks5Vnc4MXVPczJlVlROMFdI?=
 =?utf-8?B?RXBFRmFrVkRCV2Q4eXl4UVJXSW14NzY2MjR1Q1p2N0w2cVpRMEdldjQvakg5?=
 =?utf-8?B?WnUxM0ZDUUVFL2hYS05GVHRVZE1tQ3cwQVFHYXBmTkllMkhkejlTeks0Y2F2?=
 =?utf-8?B?VENNVndMN0pPdEU5K3diallxcWJkejFocUhIcmxhaDNTaWU3SjA0anR6RktE?=
 =?utf-8?B?UUc3YnFkQnhib0lQUFhBemhUSmdOejRzLzltRGRkS3kxdlZPY2pxenowOWFz?=
 =?utf-8?B?dlVPb0xpVnVrN1dXblltMm5iY1lya2I2YXlJcDVJaVNVKzhjcWRuYnBFdW55?=
 =?utf-8?B?aUdBb2FXZTFRNDMyWXp6TUw4UWgzNU8vRFhZV0dtTnhUTlZncGlDY3h0UUVu?=
 =?utf-8?Q?LFQWsT+meZalBLdDbIwGYZP7mX2GBPKpGLnpQoZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a90b3ef-2498-4af5-86f1-08d9810df5e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 16:52:00.7588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hLtLGJgqF3RXvxyY2+5z0cAYunIoQwJQMm+AZWxTpFYi+J2xQSrOZrAJz//34oCESQf3qnxUgqbe/4f7KA8rVjE274vOGR4kLtiWCnWooow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDEyLzE4XSByYXZiOiBBZGQg
dGltZXN0YW1wIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+IEhJIFNlcmdlaSwNCj4gDQo+
IFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDEyLzE4XSByYXZiOiBBZGQgdGltZXN0
YW1wIHRvIHN0cnVjdA0KPiA+IHJhdmJfaHdfaW5mbw0KPiA+DQo+ID4gT24gOS8yMy8yMSA1OjA4
IFBNLCBCaWp1IERhcyB3cm90ZToNCj4gPg0KPiA+ID4gUi1DYXIgQVZCLURNQUMgc3VwcG9ydHMg
dGltZXN0YW1wIGZlYXR1cmUuDQo+ID4gPiBBZGQgYSB0aW1lc3RhbXAgaHcgZmVhdHVyZSBiaXQg
dG8gc3RydWN0IHJhdmJfaHdfaW5mbyB0byBhZGQgdGhpcw0KPiA+ID4gZmVhdHVyZSBvbmx5IGZv
ciBSLUNhci4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMu
anpAYnAucmVuZXNhcy5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmIuaCAgICAgIHwgIDIgKw0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCA2OA0KPiA+ID4gKysrKysrKysrKysrKysrLS0tLS0tLS0t
DQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCA0NSBpbnNlcnRpb25zKCspLCAyNSBkZWxldGlvbnMo
LSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNh
cy9yYXZiLmgNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4g
PiA+IGluZGV4IGFiNDkwOTI0NDI3Ni4uMjUwNWRlNWQ0YTI4IDEwMDY0NA0KPiA+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBAQCAtMTAzNCw2ICsxMDM0LDcgQEAg
c3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gPiAgCXVuc2lnbmVkIG1paV9yZ21paV9zZWxlY3Rp
b246MTsJLyogRS1NQUMgc3VwcG9ydHMgbWlpL3JnbWlpDQo+ID4gc2VsZWN0aW9uICovDQo+ID4g
PiAgCXVuc2lnbmVkIGhhbGZfZHVwbGV4OjE7CQkvKiBFLU1BQyBzdXBwb3J0cyBoYWxmIGR1cGxl
eCBtb2RlICovDQo+ID4gPiAgCXVuc2lnbmVkIHJ4XzJrX2J1ZmZlcnM6MTsJLyogQVZCLURNQUMg
aGFzIE1heCAySyBidWYgc2l6ZSBvbiBSWA0KPiA+ICovDQo+ID4gPiArCXVuc2lnbmVkIHRpbWVz
dGFtcDoxOwkJLyogQVZCLURNQUMgaGFzIHRpbWVzdGFtcCAqLw0KPiA+DQo+ID4gICAgSXNuJ3Qg
dGhpcyBhIG1hdHRlciBvZiB0aGUgZ1BUUCBzdXBwb3J0IGFzIHdlbGwsIGkuZS4gbm8gc2VwYXJh
dGUNCj4gPiBmbGFnIG5lZWRlZD8NCj4gDQo+IEFncmVlZC4gUHJldmlvdXNseSBpdCBpcyBzdWdn
ZXN0ZWQgdG8gdXNlIHRpbWVzdGFtcC4gSSB3aWxsIGNoYW5nZSBpdCB0bw0KPiBhcyBwYXJ0IG9m
IGdQVFAgc3VwcG9ydCBjYXNlcy4NCj4gDQo+ID4NCj4gPiBbLi4uXQ0KPiA+ID4gQEAgLTEwODks
NiArMTA5MCw3IEBAIHN0cnVjdCByYXZiX3ByaXZhdGUgew0KPiA+ID4gIAl1bnNpZ25lZCBpbnQg
bnVtX3R4X2Rlc2M7CS8qIFRYIGRlc2NyaXB0b3JzIHBlciBwYWNrZXQgKi8NCj4gPiA+DQo+ID4g
PiAgCWludCBkdXBsZXg7DQo+ID4gPiArCXN0cnVjdCByYXZiX3J4X2Rlc2MgKnJnZXRoX3J4X3Jp
bmdbTlVNX1JYX1FVRVVFXTsNCj4gPg0KPiA+ICAgIFN0cmFuZ2UgcGxhY2UgdG8gZGVjbGFyZSB0
aGlzLi4uDQo+IA0KPiBBZ3JlZWQuIFRoaXMgaGFzIHRvIGJlIG9uIGxhdGVyIHBhdGNoLiBXaWxs
IG1vdmUgaXQuDQo+IA0KPiA+DQo+ID4gPg0KPiA+ID4gIAljb25zdCBzdHJ1Y3QgcmF2Yl9od19p
bmZvICppbmZvOw0KPiA+ID4gIAlzdHJ1Y3QgcmVzZXRfY29udHJvbCAqcnN0YzsNCj4gPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4g
PiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+IGluZGV4
IDljMGQzNWY0YjIyMS4uMmMzNzUwMDJlYmNiIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gKysrIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ID4gQEAgLTk0OSwxMSArOTQ5LDE0IEBA
IHN0YXRpYyBib29sIHJhdmJfcXVldWVfaW50ZXJydXB0KHN0cnVjdA0KPiA+ID4gbmV0X2Rldmlj
ZSAqbmRldiwgaW50IHEpDQo+ID4gPg0KPiA+ID4gIHN0YXRpYyBib29sIHJhdmJfdGltZXN0YW1w
X2ludGVycnVwdChzdHJ1Y3QgbmV0X2RldmljZSAqbmRldikgIHsNCj4gPiA+ICsJc3RydWN0IHJh
dmJfcHJpdmF0ZSAqcHJpdiA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ID4gKwljb25zdCBzdHJ1
Y3QgcmF2Yl9od19pbmZvICppbmZvID0gcHJpdi0+aW5mbzsNCj4gPiA+ICAJdTMyIHRpcyA9IHJh
dmJfcmVhZChuZGV2LCBUSVMpOw0KPiA+ID4NCj4gPiA+ICAJaWYgKHRpcyAmIFRJU19URlVGKSB7
DQo+ID4gPiAgCQlyYXZiX3dyaXRlKG5kZXYsIH4oVElTX1RGVUYgfCBUSVNfUkVTRVJWRUQpLCBU
SVMpOw0KPiA+ID4gLQkJcmF2Yl9nZXRfdHhfdHN0YW1wKG5kZXYpOw0KPiA+ID4gKwkJaWYgKGlu
Zm8tPnRpbWVzdGFtcCkNCj4gPiA+ICsJCQlyYXZiX2dldF90eF90c3RhbXAobmRldik7DQo+ID4N
Cj4gPiAgICBTaG91bGRuJ3Qgd2UganVzdCBkaXNhYmxlIFRJUy5URlVGIHBlcm1hbmVudGx5IGlu
c3RlYWQgZm9yIHRoZQ0KPiA+IG5vbi1nUFRQIGNhc2U/DQo+IA0KPiBHb29kIGNhdGNoLiBBcyBy
YXZiX2RtYWNfaW5pdF9yZ2V0aCh3aWxsIGJlIHJlbmFtZWQgdG8NCj4gInJhdmJfZG1hY19pbml0
X2diZXRoIikgaXMgbm90IGVuYWJsaW5nIHRoaXMgaW50ZXJydXB0IGFzIGl0IGlzIG5vdA0KPiBk
b2N1bWVudGVkIGluIFJaL0cyTCBoYXJkd2FyZSBtYW51YWwuDQo+IFNvIHRoaXMgZnVuY3Rpb24g
bmV2ZXIgZ2V0cyBjYWxsZWQgZm9yIG5vbi1nUFRQIGNhc2UuDQo+IA0KPiBJIHdpbGwgcmVtb3Zl
IHRoaXMgY2hlY2suDQoNCg0KQXMgZGlzY3Vzc2VkLCBJIHdpbGwgZHJvcCB0aGlzIHBhdGNoIGlu
IHRoZSBuZXh0IHZlcnNpb24gYW5kIGNvbnRlbnRzIG9mIHRoaXMgcGF0Y2ggd2lsbCBiZSBhZGRl
ZCB0byBnUFRQIHN1cHBvcnQgY2FzZXMuDQoNClJlZ2FyZHMsDQpCaWp1DQo=
