Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74E3DFB61
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 08:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbhHDGUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 02:20:15 -0400
Received: from mail-eopbgr1400120.outbound.protection.outlook.com ([40.107.140.120]:54464
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235530AbhHDGUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 02:20:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeTUGUYWvkGBi5AGMR0bYgFbM9f8ADu7a/y3UIHcnnXaxMQRJDo7CMvwsU0PI08W2Gw8Qy+oMdomXPmarfNxF++yKDfhyOyVQEhHlpT8rFWpn1eXClxE6C1XJD4vR72bg/KrVKHy+QaV/J5ri3e4Y5dOZEWbnLlvDtltCLq9t5S9UKbSBBcagYt299eczRmjcfL9OM1eM2yXMOVZuErkwbNaXhHg9iJEi2fpMloNc8GjqcJ0qLHWiP2cY0Xp/XXHmGad0MBpx2EE0D+FSeSN0MB2bwjktf0wX9SrDsCGbcu6QIMQ/6fvZVb5S2MeXUUp1iyv9LNDJFPJbAEbnXd0Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJV2U6x/LyKQv3vCdnLeSaI9XahIS6iBIgt8MjbErMU=;
 b=frNKwRE+z8vUxyN127Hz31TNp+iRrLJiBrdmCCqCOTsgzVKQzpDh1WXYJGwwEtDXMfCUBZfswXobV4iXcD4FZ5sNRCedDNzNqEu/s7p/JWR+MAUEh+NFw4mSOYyvMobDz0qp71EoYPHpIbhZhoSHaVcuwN1RpGEPQNNwdXnZ2IzRv1ppQVYgt4MmVwdRNTbEeBXaaN9kEevOCliAC4CuLRvUv0ftq0RuTJknnh9ty0rSZZ1ilgb4Ia/37xrPUq4r8apSASg+org5OQEbue/SC2+Brh5NrBjnEOLAZUNkmmdTPYs/0OW4oAMeMVduLWpVJcW8QHHHz5te0ChgwqKeeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJV2U6x/LyKQv3vCdnLeSaI9XahIS6iBIgt8MjbErMU=;
 b=lLCh5fTth4w7N9Oa4c81+C7QmVoNkbNDeKDdSmETuS8teTcnjffufucbSyeAsr1CZ9fRiX0puDGBGubs0ydRprN/irJjWRHv3UqwS3Iz8+g0G8tOz9LYY689r6c/VYd993aBMIisKS68vQw/sGB4kv6cr5l/e8ghESxyGF3kdvs=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB4804.jpnprd01.prod.outlook.com (2603:1096:604:69::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.23; Wed, 4 Aug
 2021 06:19:57 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Wed, 4 Aug 2021
 06:19:57 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Subject: RE: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Topic: [PATCH net-next v2 7/8] ravb: Add internal delay hw feature to
 struct ravb_hw_info
Thread-Index: AQHXh4kJVg2tFXlcHEytJvY9Z7FsDqtiR+qAgACUTiA=
Date:   Wed, 4 Aug 2021 06:19:56 +0000
Message-ID: <OS0PR01MB5922ECE16E206B66F6E8CFF086F19@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-8-biju.das.jz@bp.renesas.com>
 <ca7f38af-8ba7-877b-e76e-d30537f54fed@gmail.com>
In-Reply-To: <ca7f38af-8ba7-877b-e76e-d30537f54fed@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5ba2af36-a979-4c04-15c0-08d9570fe197
x-ms-traffictypediagnostic: OSAPR01MB4804:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB48043F3B48DEC126FA519DC186F19@OSAPR01MB4804.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WHHWMXi5+9SWEBkDh7MvHuoEKnGjtHQkvkbwr9gqPraLodEyN2tm+RNE1TRsqx2sA3gNRCbO30+2pzGcQI1N9vRmp8ysxaBSJfX/Pu/HDdmBU/MwEfWACacL7VhLMLuxFsTZ9GRW3hgNDNMXkbSBNDcRpOIACTOwGiqTLrJapXh/KSRj4/JX3uncT7a3VHriXLEr0RZiGwL6Xep6hoIbIlihZrPRQvXNgMvImOS3fCkdHu+zvDzrXaR9dFrMfXHU4e4Rv+aUIE74nncDZL+V0/RjW4aJnUa10bLDnkmr1cMJMWJ2hA0ZNZAEFvbtkwLROexlj9BMSewQugImh2YipcMDgF9rIOyTYcBy0KyhS108BTZ9Ljqj4X2Wbk45GnbJqTyiV+0pE7bnctetSptbEvVGsb0aDIHZ6taFfJD4HwC/NQLSAKQA9MRHFyiiDDWqoS9oBQnHep+rvtV5L/GcEwuD2vbKoixEtnuHnQ2zz67eAI+WVuOhSFd9lNkdujsQM0x6RoqALvrWmm+Juv7w/EXB/GaBbMUKDUH4ZWy762LLj7E04oX3u7AuNzxePcslX+vsb/VmqVXgTIGb2EwvFVXCUls/sal6sz8/z90Ly+hk6d+jmanhElsyYfo1yoMnQ/uJK/RMvtPntTKdp/gxQg1RA3ic83dNPycGbE7c+AH56xJ/BAgqPhTFrBJ3YmJV4/xXzz61rxSeoNWESUGY+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(66946007)(66556008)(52536014)(66446008)(107886003)(55016002)(66476007)(4326008)(83380400001)(5660300002)(64756008)(86362001)(76116006)(33656002)(7416002)(9686003)(6506007)(316002)(53546011)(38100700002)(8936002)(8676002)(26005)(186003)(38070700005)(478600001)(54906003)(110136005)(71200400001)(2906002)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aC8yNEl4TEU3UDV3emhCb3VQOHlFc3ZhSGJOU0xLOE5mV2NiWThaR2VkOFl5?=
 =?utf-8?B?cHAxUmlmTTU2OEhmeE1GUGxsNTZNdVZwcy9LR2FwYUNYUHlrSlFWSmpVNXV2?=
 =?utf-8?B?RlVDMWVsMnFoL1plZEZGeHQ2NmdiRE1GakRQSFEzOFNvMU0yNmtpRUJDNHVx?=
 =?utf-8?B?aU5OVDRJSkpaaVN1VFJoTVhTVTN2dHdwWDlJUElCOWh0YnVtVXRaaHBMeXd1?=
 =?utf-8?B?eFNSSHR3eG5yQmhhbStBU3NsNk1IZzVTZkJwR2hic1BoaGRkck9kRExSa3dO?=
 =?utf-8?B?VmJ6VG4yM3dPRlpmLzZPeHorWHJhd2pLd3RZb2RXeFhIMElpbGtuSjNKREpY?=
 =?utf-8?B?N2F0OVBsaDhGazc2Z2NvL2RtcFRWMUdsaUFJdnQxeUdTbmVWR0w2OFZZbzFJ?=
 =?utf-8?B?SGdHR1B5NTI2TUhqNkpnS3dvVlo0NE9MNjh2UHM3MkF6cU0wTkxnaGszSXow?=
 =?utf-8?B?ejE3UXFCY3RpVHY4SWQ2VUloZFhsTURFelhzWWJOeTVkQkxGL2FaaVRwbi9R?=
 =?utf-8?B?NTFXUHFSQmZoclhaQWppcDBvT3RqR29JblBJQkJmaHJNK1hOY29FdlQvN2la?=
 =?utf-8?B?Z3krd2dqMXhRM084UzhRN0owZDYyNHZQQUdMQW51NFZ4dE5zNnZYVG9ZRi85?=
 =?utf-8?B?VUNJeXk2K0dhQjFSSnhUbjdiZlB4UjZHMVJHZkV4VVhmeTFVcHlZbG82dXRE?=
 =?utf-8?B?RkdDT3g0Y2pGYlNPNGN6VmxSTXVnNjFKWHVnRnZUMkcrd2xoTXNodTl2MDY1?=
 =?utf-8?B?cDZ6UlN3NGdVdFZyWGRBZlAxSDRBT2pQQTd5ci9ZL0dUbm1URHpXU09QYnBM?=
 =?utf-8?B?Mmh3WmlVY2ZKdUwvVjEzYm1PamxoWDNpL2ZMQjBBRlRFVEVwbnlSeE5QbUVt?=
 =?utf-8?B?WVAzai9IWWJvdm9pYXBnWmJUa3JzVVA5NWJWK1hTZWd0ZlVZY2h2N3FrbWlX?=
 =?utf-8?B?MTZhMVRSNVkzY2dLRzVhVzFSWk8yNjBuM1BvRGtEVFNhd3pMemQwU05PWm9n?=
 =?utf-8?B?Nkp2d1paVDJrbHordHRkS3hCN3kwVHNmTXpqcU45OVMvUWp0RzZBckF4SWFE?=
 =?utf-8?B?Y3lKWVRxUXNQSHdLVHdqMnloNytRS2lzTElKenl1bWxDcFUwd1ZXS3NaZllt?=
 =?utf-8?B?OStiZXNPci9RNWpjRmhIbFhMRGxoV2JMNnNaeGJ6bnFJR0RBaUE0NjAwQ2Vo?=
 =?utf-8?B?MnA4YXVQQUNkZlZmcy80N0xvb1U0cm9iWUFsWDVweTVwUTQ5SXFqSXlnK1hy?=
 =?utf-8?B?VUNGaEJLaklUaVlQRHE5NEdVTlQwSVg1TU5zeGFnY1VFOTR4clNZeC9TT0Vx?=
 =?utf-8?B?Zzh2SzFpWEg3T2c3TXBlRlZ4TUtuTzBkZ3FjbU1pR3dobm02NVdiamlNbXBD?=
 =?utf-8?B?U1ptZXRmRW1MeDdjdjZhMUVTcDJXTmVCMkwwdWIwVFVTSTBGVEtxRjJYczFD?=
 =?utf-8?B?a3lPMDl5U3N4d3ZLNVBLQjRhYi9sbGQvZjRJTEhWb2dVcU9jQXpITTRoOUl3?=
 =?utf-8?B?SWpLNUU2dmxqVXNKRDQ2bFduTkJLc1pOeE1hb01vYmxnRFVJSGQvKzhETXFi?=
 =?utf-8?B?YWZyTzJKaWpNSmdJbmhhbzhCTEdnWDExekNxbDlYQzlMUlh6SFhwUmE2ME1D?=
 =?utf-8?B?SkNnTXhHckQ3QVdCZURPRHIyQzFQbmJGT0VKd2pIdGVoUkJOTlNEK1Fobytn?=
 =?utf-8?B?UlhCMDFqZVQ5bXhLQ080WUZHQTRValY0VytVbGk3L01WYmRvRUo5SHUzdHJ5?=
 =?utf-8?Q?GknHQ+vJ4qAcZA6gbu4F8KJxS2v/WpP/qzu5Yg2?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ba2af36-a979-4c04-15c0-08d9570fe197
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 06:19:56.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: na5ThPeS12Vy2h4Sce6Q5f9mvKpt4QJ9npp6o8cXNnS8PMx7pWwA/fkYxp/VNHFI0YMfLqRvWuMUGFUscYB++0ojHv1IB50Y60TzYeUSZZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB4804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IHYyIDcvOF0gcmF2YjogQWRkIGludGVybmFsIGRlbGF5IGh3IGZlYXR1
cmUNCj4gdG8gc3RydWN0IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOC8yLzIxIDE6MjYgUE0sIEJp
anUgRGFzIHdyb3RlOg0KPiANCj4gPiBSLUNhciBHZW4zIHN1cHBvcnRzIFRYIGFuZCBSWCBjbG9j
ayBpbnRlcm5hbCBkZWxheSBtb2Rlcywgd2hlcmVhcw0KPiA+IFItQ2FyDQo+ID4gR2VuMiBhbmQg
UlovRzJMIGRvIG5vdCBzdXBwb3J0IGl0Lg0KPiA+IEFkZCBhbiBpbnRlcm5hbF9kZWxheSBodyBm
ZWF0dXJlIGJpdCB0byBzdHJ1Y3QgcmF2Yl9od19pbmZvIHRvIGVuYWJsZQ0KPiA+IHRoaXMgb25s
eSBmb3IgUi1DYXIgR2VuMy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1
LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthciA8
cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiBbLi4uXQ0KPiANCj4g
ICAgT0ssIHRoaXMgb25lIGFsc28gc2VlbXMgdW5jb250cm92ZXJzaWFsOg0KDQpTbyBmYXIgdGhl
IGNvbW1lbnRzIEkgcmVjZWl2ZWQNCg0KMSkgSSBoYXZlIHJlcGxhY2VkIE5VTV9UWF9ERVNDIHRv
IG51bV90eF9kZXNjLiBCdXQgeW91IGFyZSByZWNvbW1lbmRpbmcgdG8gcmVuYW1lIGl0LA0KICAg
ICAgICBpcyByYXZiX251bV90eF9kZXNjIGdvb2QgY2hvaWNlPw0KDQoyKSBza2Jfc3ogdG8gbWF4
X3J4X2xlbiwgSSBhbSBvayBmb3IgaXQsIGlmIHRoZXJlIGlzIG5vIG9iamVjdGlvbiBmcm9tIG90
aGVycy4NCg0KMykgcGF0Y2hlcyByZWxhdGVkIHRvIGRldmljZSBzdGF0cy4NCg0KSSBhbHJlYWR5
IHByb3ZpZGVkIHRoZSBvdXRwdXQgb2YgZXRodG9vbCAtUyBldGgwIGZvciBib3RoIFItQ2FyIGFu
ZCBSWi9HMkwuIA0KDQpGb3IgUlovRzJMIHRoZXJlIGlzIGFuICJyeF9xdWV1ZV8wX2NzdW1fb2Zm
bG9hZF9lcnJvcnM6IDAiLCBpbnN0ZWFkIG9mDQoicnhfcXVldWVfMF9taXNzZWRfZXJyb3JzOiAw
IiwgQm90aCB1c2VzIE1TQyBiaXQgNiBmb3IgY29sbGVjdGluZyB0aGlzIGluZm8uDQoNClRvIHBy
b3ZpZGUgY29ycmVjdCBvdXRwdXQgdG8gdGhlIHVzZXIgdXNpbmcgY29tbWFuZCAiZXRodG9vbCAt
UyBldGgwIiwNClJaL0cyTCBuZWVkIHRvIGhhdmUgYSBkaWZmZXJlbnQgc3RyaW5nIExVVC4NCg0K
UTEpIERvIHlvdSBhZ3JlZSB3aXRoIHRoaXM/DQoNCkNoZWVycywNCkJpanUNCg0KPiANCj4gUmV2
aWV3ZWQtYnk6IFNlcmdlaSBTaHR5bHlvdiA8c2VyZ2VpLnNodHlseW92QGdtYWlsLmNvbT4NCj4g
DQo+IE1CUiwgU2VyZ2VpDQo=
