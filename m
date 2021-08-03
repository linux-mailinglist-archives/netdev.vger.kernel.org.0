Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1A23DF5FA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 21:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbhHCTrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 15:47:40 -0400
Received: from mail-eopbgr1410137.outbound.protection.outlook.com ([40.107.141.137]:50144
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239635AbhHCTrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 15:47:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QD/RtN2DEbaJCdbvTSy95U+Y0IbswuXIayBxmx4J8I0Y2VM44EssM7lH2jHq+V0d+tmMGXRK/YXEB8suxB33gCQK7IK+Bwr+4+/jz5ZKrE4bygfzepYRoYZEMNla0Vtm/G8hpvRCAV75w8Dk7zQslsWMmXccGcGpVD44ICOnhxg6wyd+uv3Ps9XqboV4/D8EJRti/WshIHS0FgJphPWfILhiVm3ceINJ+xwLmaYVNEL+Nto2j4LwQOxyuRrNBFNZzEvgv9YBvKTlgH0hd2NG7je6bTEIAr7CjRzG8q+28hGvW1UApQW1IXUtu1MNaM4Hs94oZhjbCJ+gTBdiDTpUDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aGoAHNqVcpczT+Ws9YFBZO/sbX++uttDihdaPCn6us=;
 b=CYi3H7s6Kz3NFHsvHxC/cgsZyiIzHDo6EgRb62TPY1gXJT0B124WY0JWCxw/6nZmoVP+BUfnQoJsW9JrGiwQHIGIggCOilRVnoL1+bJU5JI9pj2TwGxywSb3P56Ep8iJ+oeSdKqE+WWByPLUiWFKQnacrqldo6T3LLP0jSrTbuOxykXW9KuWHOJ5dQvmE9X0GQhzFO4bCbi7RSztnP79gfOTX9XJ01WHpAo8LSOfb1mJNakoJnjrzseHWID8MjgEtooA1U/KygNlVqTTdw82bnp4tozdkiTY1Xi0sle/h8XvGazMoat7zhJtCmJ4uRngbvjQYvIGh/dHUptQGzgcEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7aGoAHNqVcpczT+Ws9YFBZO/sbX++uttDihdaPCn6us=;
 b=o2ght7tFGzzNQvYJs3IWx6OX5gnkVG7JS5JcTy7VuSqfkxXYliPFQHYf1jNcmzdrZ3CqQACyIyUk0aifwdH4s+/SqKihLV/hQXWyrbz06qL8z+xeOCZ4Bou9NYMQW145y9vpLRHsGBbHhmYHCCiy5FL/XYgsIK/89mXvjoOxuLQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS0PR01MB5953.jpnprd01.prod.outlook.com (2603:1096:604:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Tue, 3 Aug
 2021 19:47:23 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 19:47:23 +0000
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
Subject: RE: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Topic: [PATCH net-next v2 3/8] ravb: Add num_gstat_queue to struct
 ravb_hw_info
Thread-Index: AQHXh4j6N5nNIwH/Qk677Je5gv3Cy6tiGcmAgAANlPCAAAN1gIAABJeQ
Date:   Tue, 3 Aug 2021 19:47:23 +0000
Message-ID: <OS0PR01MB59220F188237ADB3BBFDBD5186F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-4-biju.das.jz@bp.renesas.com>
 <dab78c92-8ee0-f170-89db-ee276d670a1b@gmail.com>
 <OS0PR01MB5922F86AB0FDB179B789B6DD86F09@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <f5695fbd-f365-c86e-3ca2-41cf59ad8354@gmail.com>
In-Reply-To: <f5695fbd-f365-c86e-3ca2-41cf59ad8354@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96e9bf5a-06a1-4fe1-4c2b-08d956b7836c
x-ms-traffictypediagnostic: OS0PR01MB5953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS0PR01MB59538E0C304006E3083F830586F09@OS0PR01MB5953.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WkSCkeyac0zwLAxOU03NEdiAfH9PuHtJqRAWBFPkWdE05y1LztlJcUS4fpNRYhmuQHcSK59nmAJYfK06b/SD1YlnhQ+1DXPWxsGZiO9cNPJd8TgJ+rbZGYyRhhNn7hUXZ4WPPqCij5g20Pw7kAoAtTnBpmhLwZ/ydq8Zn0RsyxCtLWMmMGdl6BFKQfQUfp8nTcx6hnnTm44sTRlT/SIbboIKKdlr+E70p/jrNwLDgiBNePMnqscn2/PkSTRluUgdXAl48jO2Md86jXrmBYjYOveJgDALenEq/9hl1CF/O1veEG6/Ai5GUffBIT5a32Ognm2+KytpPVhnePWmYsGf2bycLHSqka/IFdIrYwJhhp/RFtDOW7wl5A5hRiCs+pkyLkz5e7n+XwuDwpPRis3R65tLgMwz8ZNJYzjwFyGLkgRc8n09HVtyifvw8cwUBJ1OfQaOe/lSFS45esw/apY3z/I17c56wWozijazUMnuqc6tbXZGZu72pWCnge6Lvevws+D5yTOGpced1+pXk8YbD8FCejcMPsUbivNZo4O1MxTGUwai4N+bpzy+DgBNI+zkXXg0KGoB0kPLh9858X0rS9TZKgFdA+k3jTP+ql+ByOv9rdvMEUEltlh5uWBwdggZ4LAxoY27+fc47DcH8nPj7IXMpDNnqvO4yJtc6MUkn0d8BaZHdPtLJS5+/fhv0vKYGLhasCiLF9+L2NqarNTTkQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(346002)(136003)(366004)(316002)(54906003)(107886003)(110136005)(33656002)(76116006)(186003)(66446008)(64756008)(66556008)(66946007)(71200400001)(5660300002)(52536014)(8936002)(66476007)(9686003)(7416002)(8676002)(4326008)(55016002)(2906002)(478600001)(53546011)(6506007)(26005)(86362001)(122000001)(38100700002)(7696005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmVGbHkxclpzbXM4UzdlODhmd29UTWtweHBSZVVwTWFOWDZUcU56OUdlemlz?=
 =?utf-8?B?Ylp6RWpEOHdMMDRSMXF1NElDTlFVSzVtcVIvTklGaVRQUk1tNEpkZVNwK0JF?=
 =?utf-8?B?NGR4dCtrWjhIa3VTWmFsLzNlbm5JVkZmS3AxVEhEYU9SV3hHMXRCWUJZQytY?=
 =?utf-8?B?a2JnZUtJT3VHNVJQaWlHME56ZkRqd3pqS3g3WDlGM0JCbldxbEM4ZUNMdERk?=
 =?utf-8?B?S1VoWWdRVC9TeWVSQU9VZFhlOFR0SFdMOUZwZzRNUU1PcUI2b0pVQW81NVNs?=
 =?utf-8?B?N3R5VWxOblhmRzFTSmJTV0RiTTErcUMyWjcwQ1czNHNROElCRysvLy85R3NG?=
 =?utf-8?B?K2Z3ZDc5bk1rN2VWNWlTY0YraDBmVzNyWFBubngrN3hVSGJ5cGQrRWJNUHJm?=
 =?utf-8?B?Zkk2NSswMWNSWm9JSXpZUVpod3RRTnYzNVBmMjREM0gwWWNxOTcybTR2d3Ex?=
 =?utf-8?B?MmZZZktIZmFGcTdYeGtEY3NXVHFWa3lRTldVS0VuRVdFR2RhMGRBRHdGZHl6?=
 =?utf-8?B?QmZraWNSZ0c2b0hVcHVubG5FZkhqNVlydXgvRlFRMmxTRWxFTWVEUnR3ZzdR?=
 =?utf-8?B?eGtadXBkZDR4L0lpQXZ2MnBEODNFbS93aWRLMkcxQUIvbVh1aTBSVEtybFRV?=
 =?utf-8?B?S3lzYjlFN1BnWVlQdkREZStCSU9LWVBlQ2dKbHJWU0JXeXBLUnk2QlgxRUlq?=
 =?utf-8?B?NlJBVnRRQ28xM0tkVmdMK1M5dGZsQ3luZk9xd1F2K1hVNkZwaTZwN1VtZ1JL?=
 =?utf-8?B?aTdxV2s0Nkc3bTc3ZTJtTGxobXhxTDRaNFM2RWNEUXQ3R1dxMy9OSzhCMVFO?=
 =?utf-8?B?OXovaVNOMG1WWkRnNWxGT0J4L3JEZmJGVUZ6K2NseUUwUmlYOHUyejNjOVF0?=
 =?utf-8?B?YkhCZ1ROQ0FJSis3M1RuUTJXSzVXQW1uYm01VEMyRHR2TTY1Z3lEbE51NEVa?=
 =?utf-8?B?eHRQY2NsRzhnS0VkRzQvSVZOQ2FtdnV6RGFlUmVZcnY4ekRIMEhoUVlpYjJM?=
 =?utf-8?B?d285MUdFQkpaaGhVMkxEWmhRZE9ROXlsMDJvNEdFeU1WZ3NXaTFNRmRjT2Qv?=
 =?utf-8?B?c2FMZGN0Z1RJa2pLSmZ2NXRhTU1EQlZ1WUZybWFaazdiNk1KU3FQYlJqL1BI?=
 =?utf-8?B?cjdlM2FwZ0F3eHNJT2VoV0xIK20wQkE4TktrakpKYzJudkVEQkN2d2NFR251?=
 =?utf-8?B?a3d3ZS81bUhSN25haklIYUd2UFZMT0ZZaVYwQmJhMnBjZTRJakZ6aTgyd1FO?=
 =?utf-8?B?SjN1NEs3MWI2MlpLbS9aMlNoU1RMc2dBdUZ4Ty9GNGtJNHd5L2pPYnA4aGZU?=
 =?utf-8?B?OEJ3NFZnSmI1Zy9TRmpBRWN0RUFJcmt0bWpRNGZvVkNGMFVoSjU3NmxBT05o?=
 =?utf-8?B?bHZBRzNvYzhMMWRPcGNBa1BQTXZMNTFGT2ZWQ1MyZlVqOStHeFlkVlpia0g4?=
 =?utf-8?B?TWc5TmRTL2xJVzI4c2NaMml4Rk53R05oR25USHI1WUlqV0lNRTM5R3NQcEc2?=
 =?utf-8?B?d2tEMDFIWFZ5VHZUaUtxa3R5eVNEVUlIVzVnUGhUN2hSVGkyUUNOS2U4czgw?=
 =?utf-8?B?ZzhEUldaMkt0ekRRM1RPTU5QQ3pna0RPQzFqTmJRVi8wSXAzajVKQnlYSlZU?=
 =?utf-8?B?cS9EdXk5TllUejN4VkVTOWhBSnh0ZnVtUGJnMXY0T3o5bllkODJVekpYYTV6?=
 =?utf-8?B?QUJINEgzOC8vckJOdSt0a0xDUjRhN09rcThFQ0RKY2lUeXp6Zmxwa21ldmRv?=
 =?utf-8?Q?MQiNUZ/GYjz5DRs8tYGPwZjPpxl+JcGbye1DwYd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96e9bf5a-06a1-4fe1-4c2b-08d956b7836c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2021 19:47:23.1591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VFEMxHh8cZllrT8w8LKbtdODUvKNnKjiHGiVUDWxNuqDZeUZi022e3sltG6jp4auTemHVm2Vj1EoIYRGvdQkL2tENQWGWNnZM8M7KDMadGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS0PR01MB5953
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgMy84XSByYXZi
OiBBZGQgbnVtX2dzdGF0X3F1ZXVlIHRvIHN0cnVjdA0KPiByYXZiX2h3X2luZm8NCj4gDQo+IE9u
IDgvMy8yMSAxMDoxMyBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiBbLi4uXQ0KPiA+Pj4gVGhl
IG51bWJlciBvZiBxdWV1ZXMgdXNlZCBpbiByZXRyaWV2aW5nIGRldmljZSBzdGF0cyBmb3IgUi1D
YXIgaXMgMiwNCj4gPj4+IHdoZXJlYXMgZm9yIFJaL0cyTCBpdCBpcyAxLg0KPiA+DQo+ID4+DQo+
ID4+ICAgIE1obSwgaG93IG1hbnkgUlggcXVldWVzIGFyZSBvbiB5b3VyIHBsYXRmb3JtLCAxPyBU
aGVuIHdlIGRvbid0DQo+ID4+IG5lZWQgc28gc3BlY2lmaWMgbmFtZSwganVzdCBudW1fcnhfcXVl
dWUuDQo+ID4NCj4gPiBUaGVyZSBhcmUgMiBSWCBxdWV1ZXMsIGJ1dCB3ZSBwcm92aWRlIG9ubHkg
ZGV2aWNlIHN0YXRzIGluZm9ybWF0aW9uIGZyb20NCj4gZmlyc3QgcXVldWUuDQo+ID4NCj4gPiBS
LUNhciA9IDJ4MTUgPSAzMCBkZXZpY2Ugc3RhdHMNCj4gPiBSWi9HMkwgPSAxeDE1ID0gMTUgZGV2
aWNlIHN0YXRzLg0KPiANCj4gICAgIFRoYXQncyBwcmV0dHkgc3RyYW5nZS4uLiBob3cgdGhlIFJY
IHF1ZXVlICMxIGlzIGNhbGxlZD8gSG93IG1hbnkgUlgNCj4gcXVldWVzIGFyZSwgYXQgYWxsPw0K
DQpGb3IgYm90aCBSLUNhciBhbmQgUlovRzJMLA0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSAN
CiNkZWZpbmUgTlVNX1JYX1FVRVVFICAgIDINCiNkZWZpbmUgTlVNX1RYX1FVRVVFICAgIDINCg0K
VGFyZ2V0IGRldmljZSBzdGF0IG91dHB1dCBmb3IgUlovRzJMOi0NCi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0Kcm9vdEBzbWFyYy1yemcybDp+IyBldGh0b29sIC1TIGV0aDAN
Ck5JQyBzdGF0aXN0aWNzOg0KICAgICByeF9xdWV1ZV8wX2N1cnJlbnQ6IDIxODUyDQogICAgIHR4
X3F1ZXVlXzBfY3VycmVudDogMTg4NTQNCiAgICAgcnhfcXVldWVfMF9kaXJ0eTogMjE4NTINCiAg
ICAgdHhfcXVldWVfMF9kaXJ0eTogMTg4NTQNCiAgICAgcnhfcXVldWVfMF9wYWNrZXRzOiAyMTg1
Mg0KICAgICB0eF9xdWV1ZV8wX3BhY2tldHM6IDk0MjcNCiAgICAgcnhfcXVldWVfMF9ieXRlczog
MjgyMjQwOTMNCiAgICAgdHhfcXVldWVfMF9ieXRlczogMTY1OTQzOA0KICAgICByeF9xdWV1ZV8w
X21jYXN0X3BhY2tldHM6IDQ5OA0KICAgICByeF9xdWV1ZV8wX2Vycm9yczogMA0KICAgICByeF9x
dWV1ZV8wX2NyY19lcnJvcnM6IDANCiAgICAgcnhfcXVldWVfMF9mcmFtZV9lcnJvcnM6IDANCiAg
ICAgcnhfcXVldWVfMF9sZW5ndGhfZXJyb3JzOiAwDQogICAgIHJ4X3F1ZXVlXzBfY3N1bV9vZmZs
b2FkX2Vycm9yczogMA0KICAgICByeF9xdWV1ZV8wX292ZXJfZXJyb3JzOiAwDQpyb290QHNtYXJj
LXJ6ZzJsOn4jDQoNCg0KVGFyZ2V0IGRldmljZSBzdGF0IG91dHB1dCBmb3IgUi1DYXIgR2VuMzot
DQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpyb290QGhpaG9wZS1y
emcybTp+IyAgZXRodG9vbCAtUyBldGgwDQpOSUMgc3RhdGlzdGljczoNCiAgICAgcnhfcXVldWVf
MF9jdXJyZW50OiAzNDIxNQ0KICAgICB0eF9xdWV1ZV8wX2N1cnJlbnQ6IDE0MTU4DQogICAgIHJ4
X3F1ZXVlXzBfZGlydHk6IDM0MjE1DQogICAgIHR4X3F1ZXVlXzBfZGlydHk6IDE0MTU4DQogICAg
IHJ4X3F1ZXVlXzBfcGFja2V0czogMzQyMTUNCiAgICAgdHhfcXVldWVfMF9wYWNrZXRzOiAxNDE1
OA0KICAgICByeF9xdWV1ZV8wX2J5dGVzOiAzODMxMzU4Ng0KICAgICB0eF9xdWV1ZV8wX2J5dGVz
OiAzMjIyMTgyDQogICAgIHJ4X3F1ZXVlXzBfbWNhc3RfcGFja2V0czogNDk5DQogICAgIHJ4X3F1
ZXVlXzBfZXJyb3JzOiAwDQogICAgIHJ4X3F1ZXVlXzBfY3JjX2Vycm9yczogMA0KICAgICByeF9x
dWV1ZV8wX2ZyYW1lX2Vycm9yczogMA0KICAgICByeF9xdWV1ZV8wX2xlbmd0aF9lcnJvcnM6IDAN
CiAgICAgcnhfcXVldWVfMF9taXNzZWRfZXJyb3JzOiAwDQogICAgIHJ4X3F1ZXVlXzBfb3Zlcl9l
cnJvcnM6IDANCiAgICAgcnhfcXVldWVfMV9jdXJyZW50OiAwDQogICAgIHR4X3F1ZXVlXzFfY3Vy
cmVudDogMA0KICAgICByeF9xdWV1ZV8xX2RpcnR5OiAwDQogICAgIHR4X3F1ZXVlXzFfZGlydHk6
IDANCiAgICAgcnhfcXVldWVfMV9wYWNrZXRzOiAwDQogICAgIHR4X3F1ZXVlXzFfcGFja2V0czog
MA0KICAgICByeF9xdWV1ZV8xX2J5dGVzOiAwDQogICAgIHR4X3F1ZXVlXzFfYnl0ZXM6IDANCiAg
ICAgcnhfcXVldWVfMV9tY2FzdF9wYWNrZXRzOiAwDQogICAgIHJ4X3F1ZXVlXzFfZXJyb3JzOiAw
DQogICAgIHJ4X3F1ZXVlXzFfY3JjX2Vycm9yczogMA0KICAgICByeF9xdWV1ZV8xX2ZyYW1lX2Vy
cm9yczogMA0KICAgICByeF9xdWV1ZV8xX2xlbmd0aF9lcnJvcnM6IDANCiAgICAgcnhfcXVldWVf
MV9taXNzZWRfZXJyb3JzOiAwDQogICAgIHJ4X3F1ZXVlXzFfb3Zlcl9lcnJvcnM6IDANCg0KQ2hl
ZXJzLA0KQmlqdQ0KDQo=
