Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF9B3E9F6D
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhHLH1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:27:15 -0400
Received: from mail-eopbgr1410127.outbound.protection.outlook.com ([40.107.141.127]:19379
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234586AbhHLH1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 03:27:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aoIjI/mpefOog6rc4so5sV/0k+RSq8iKoeVAaL1SaCjQKF7pvd+sdvWH2IvS0a+3UoqKKKdS0CpTNBK275PXgFV3HIUFIXQ0B69kBfI1GibIFkXEtOkGA6BM7buAOai7d0USQa9afrtvO6EKFmVCt8DWr52SOkUm8xC2v21kdkaoCdMPZ2VRguXRQZaqjp7NT1bu2ingwUBAdvYalK6p6Nn1TkqnVyAS/KH//HmbL01pxi39XMsjRCHFNNAXXybqgqBBCyEgTSGuvZ75sxQn7bZVtmybb9c7A7PXeJ2x3CQe2M8f1kKs6o7exPBJB4Odrzg6VIHhAoxb5c1cZk2r/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDWbSjiGzERK+hoB4tO3+XEFKE3HC+8bWSqiO3MxW/s=;
 b=IlfaiL0pn6QxWqEoGfdg9JE9uQ6dE1SDBB0gfWNFrNFzPZaCNEn4uSaRv2ERJdPtlJevkwyBJmHaLTp+fWUQW6zCcFeL28bN85U3g8O8Hru8Rkltf7uNV+84y2UjZMJdoU6SEllTNSrgcDxorOaMqXAzGkmvyqEbKTzQoFsqJ7yF58XRvAdKZoHeGmPw9HrVCKdN231Y6X8DZPicRYpJXazaCLJSJe1QKV8Uv1Ng56jPC6vvsRsvMtfeq2Fq5w02Z3eOWC6kn8yVQm+7GLo42ivN6LsoW0dBUUDWeUoQKXeOjW6mpAyl+RZYJ8QIhzvfThbwJjEPfARj9fA3DcGpfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDWbSjiGzERK+hoB4tO3+XEFKE3HC+8bWSqiO3MxW/s=;
 b=p8SNLjHy0bcc/EXAcnKb5GjPOSzS35km/HMGY17fzQnEGmdEu/FKO+hIuo8EziWroZ986seZeOTmWq8ED/8FqyhpNbBPuyzfMfps0fZqC/NtnjIIzusLiWTDiB8+usNfNYh3Hh6/DUB5dv4scEO+/k7KLsP/ZzxvJ+rTp1uT6Fg=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB5047.jpnprd01.prod.outlook.com (2603:1096:604:7f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Thu, 12 Aug
 2021 07:26:46 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 07:26:46 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Topic: [PATCH net-next v2 1/8] ravb: Add struct ravb_hw_info to driver
 data
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtrHuUAgARm9NA=
Date:   Thu, 12 Aug 2021 07:26:46 +0000
Message-ID: <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
In-Reply-To: <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux-m68k.org; dkim=none (message not signed)
 header.d=none;linux-m68k.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1467fc57-3d49-4f4d-5b48-08d95d628a87
x-ms-traffictypediagnostic: OSBPR01MB5047:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB50475E44024904D185C4092486F99@OSBPR01MB5047.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f3UFJ8sfCZCnUDcKUE52AOmWQP6N0EEPbMLWbDy39umI4Fk+mS4lpY4J/AVVULvp/QDZUMMfK19txj5NZMLhQ33MtQfB+ggCRVyezebMWUgxvS4dHvZTT59JaQFXJkH39SEe7omdfpsfUkjIMH6E0OUmK0jFejtiHLWqT1M+LWeHWRAPdsn2uKHlMkEWSQ/B/fYonJRBUv6FlvZ8Ts/yx7wcvIRXJI1udAoj65RmvGTGB/qzK5Sd9RV0/B5891k3AL+vlSgVWhIuZNK/hVHRqcBCCOalVih/rrsk0wMlGF+0B+MWQhkKXv7LWB9dN06+XU37S9Ss2RVDXVN60mb84BUF1NF6nXJTT3I1hOcUZtO4kwFdgmsb3VdTwTBRSakzm7oIUCpGgjkB5AbPfXtsF71C8gh6fxsEcqOw8axkku8wIeBmTYSQGt+vSwreNq95hUcai7KmleUkvSBYvr42VAL9TO8hwNFfPwv7qlvWqiTGxOhRblhxy5KygfGiS68nr8+sb1oxH8YpPJXbxMkGHGbf/8v5Cex2+DAZ5VESrfbZiWvXzRB/yPQGrOznNy7GzJ5O7wew2LY+HznlMk4g3pTSUD2gI0W+WzCNOf7Tc83FTgIpZsQk+zNxxRInRLPrBYB48ucm3YDdo4iLFfBAAYxv0dgdgFbuqK37oYlbPF/0L0yZO3eDWpAv5JElSKnNx3RhGD1sH2wBeENkyjXUcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(33656002)(55016002)(5660300002)(6506007)(122000001)(71200400001)(107886003)(86362001)(38100700002)(53546011)(7416002)(8676002)(8936002)(4326008)(9686003)(2906002)(52536014)(186003)(38070700005)(54906003)(478600001)(26005)(83380400001)(66556008)(76116006)(7696005)(64756008)(66446008)(66946007)(6916009)(316002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUExUVA3SkxOM0RoWWsyY291T2g2K09ZMGw4aHhmRFg2dlVmd2Z6VUM2UzVh?=
 =?utf-8?B?WWl1TXF6M1BtU2MxQmtGNHNtN2FmWCtTTDBKYnA2L05sYUErQ3plNmRQUVFV?=
 =?utf-8?B?QzE3cHlESWplQ3ovRWFjc1lKZThIZ3BObVZsNW02NzNLUFExYWNSRTJGUmp3?=
 =?utf-8?B?NEIxUUZPUGNCV1RKZkt6QXNhTis4Vm9JTjk5dExTV25oNlhMazV3bG1XS2xD?=
 =?utf-8?B?T01rVkdPWkNBdTBlZTZ6SDNEUVhRQnZtMWtmM09ic2ZWQk9SK3VBMDVkQ2tx?=
 =?utf-8?B?UEdDWHkwQzdVbnhZVEVoSjlYejZENkFJUmRZWlprekgrVDEzQXVwUEhicnhE?=
 =?utf-8?B?bUc2b2tNZ2hkbGxQVlZaMVk0eTdlS014YktpRTl0UG10TzhHcEpwR0kzemRH?=
 =?utf-8?B?SithNzlxK3FKTlY3aHlFaXZhVFhTeHM3NExoNzd5M2pmNjVra0pzZGRJS1Yz?=
 =?utf-8?B?N3lzQzVVQmNxWWVrbmRVbnFSalUyam5nakl6Z2pHRFdCb3dwQThoN3pYckJ0?=
 =?utf-8?B?YWRiVjlaLzJFdFVaaFRaN08xb3hXcUNWM0pramZXbmg4UTVpUTFWbFVWOUJy?=
 =?utf-8?B?c3BMeXlEMVFoRjJRS2hIMWR2eHlENkN5dGhuaVFhMmdRRG1WVmpaNExrSk43?=
 =?utf-8?B?UUg2YXZLY2hmejNNTnhyWkpSZGNYMGk5RE1IZncxb1c5REcvSnl4WnIwbzRm?=
 =?utf-8?B?MHRHKzVLSjFIZUhkTml2c3hCRlczYkJ3cHdvbmdsc2hmWVc0djFkZEJXSm1T?=
 =?utf-8?B?WjZKNnZ1K1RGVytJWVpDQkpFMjVYYkZScWt2NGhKVlRMU005UktnOWVCUDdW?=
 =?utf-8?B?bTZnT29xemhodWlsRUxJMEJtaUJTZ1owMHR4dFduczBRNDJ2TDBYVk5uU3Nu?=
 =?utf-8?B?VExaa1NFU1pkUXo2Yi91NWFiSURLWDFWaTJ2S2tiS0FsK0xRSmxrZTU3WXV3?=
 =?utf-8?B?dGxSYlZucGZ3NEpIbWRIRFFrTU1vd1RXbzlmZlk5Sm1tMFlqelVHVko0ODl5?=
 =?utf-8?B?eFllRUx5OWhpK0pCZC9RcVI3SkQwRmVwdGVPVDhBeHF2cUpvY2o5ekhyS3Ew?=
 =?utf-8?B?QUdDL1FpdGhVd3NhQXlXY0crYm12MzhxU1ZUcFlFbjZQVmNiUjI0ZHF2ZzBJ?=
 =?utf-8?B?a0JjSUI4aU9lOWQzY0FFcXJLUkVjUFlZbHJiZUF1SDdCV2dNMmhIU3FQVkRI?=
 =?utf-8?B?RnJSNk5jVE5COEtNMUhYOUpRS2E3VUxYM3VMQ3dtQSt5Y083TFNWT01nZ1ZU?=
 =?utf-8?B?aDBUM2ljRDZOMi80YWtKUHpLM0xYaXoyejZOVWtuSklWbEsyc25XUkFLVWdu?=
 =?utf-8?B?YytEN292cGlyZU84Tlk2N3BEY1d5dU1JYk5PZXRmSnBqOGtnWGxTQ2RuWlAw?=
 =?utf-8?B?OHB0dDFTNnJ6NlUvUXhpMytJMW41K2owVlhaN1BubG5EQVJLOUFFZFE5QTJj?=
 =?utf-8?B?WDJsZ0VEYldPU2hPMDNFemxLa0dqdkVmUmdnSWN1U2c1SUhzVjR6Y0todk8z?=
 =?utf-8?B?cVVmMjVqdmd3dWtuaWVrSG9vTmJqZjRKOUNrREg0MGxFMWdkaGhuRU85U09i?=
 =?utf-8?B?anU1RkFNdk5qZDBDVjF2UTFvQXUyYWNWNi95Y0VFeFJ6Y0U5R2hnMVdHWTUx?=
 =?utf-8?B?TVROeVNBLzFpUUJGaTIwOHB4YTVhU1RhMEkrL0dKOU0wSVg3U2dnL3NldnBT?=
 =?utf-8?B?c1lFaWlnVzhqbHNWSmxWZkc5bjNhSG5BMEJDMWlsYldlcy93bk44U3RSL0k2?=
 =?utf-8?Q?6Ptq8XReYYxDifgFz9l9IKbR+TVZws8bfJ9QmmS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1467fc57-3d49-4f4d-5b48-08d95d628a87
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 07:26:46.0651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sEWyGhdNCAmHSntmdiCiSxOPGw0eaG9Yd21FrwGh4gT8u+ndUKjQZVttOoo/MFEDGpp9LSUKvbS061AC7G2H7e+Q2RpLw3uh3aXcR/eIEiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5047
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgR2VlcnQsDQoNClRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrLg0KDQo+IC0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZi
OiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0bw0KPiBkcml2ZXIgZGF0YQ0KPiANCj4gSGkgQmlq
dSwNCj4gDQo+IE9uIE1vbiwgQXVnIDIsIDIwMjEgYXQgMTI6MjcgUE0gQmlqdSBEYXMgPGJpanUu
ZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiB3cm90ZToNCj4gPiBUaGUgRE1BQyBhbmQgRU1BQyBi
bG9ja3Mgb2YgR2lnYWJpdCBFdGhlcm5ldCBJUCBmb3VuZCBvbiBSWi9HMkwgU29DDQo+ID4gYXJl
IHNpbWlsYXIgdG8gdGhlIFItQ2FyIEV0aGVybmV0IEFWQiBJUC4gV2l0aCBhIGZldyBjaGFuZ2Vz
IGluIHRoZQ0KPiA+IGRyaXZlciB3ZSBjYW4gc3VwcG9ydCBib3RoIElQcy4NCj4gPg0KPiA+IEN1
cnJlbnRseSBhIHJ1bnRpbWUgZGVjaXNpb24gYmFzZWQgb24gdGhlIGNoaXAgdHlwZSBpcyB1c2Vk
IHRvDQo+ID4gZGlzdGluZ3Vpc2ggdGhlIEhXIGRpZmZlcmVuY2VzIGJldHdlZW4gdGhlIFNvQyBm
YW1pbGllcy4NCj4gPg0KPiA+IFRoZSBudW1iZXIgb2YgVFggZGVzY3JpcHRvcnMgZm9yIFItQ2Fy
IEdlbjMgaXMgMSB3aGVyZWFzIG9uIFItQ2FyIEdlbjINCj4gPiBhbmQgUlovRzJMIGl0IGlzIDIu
IEZvciBjYXNlcyBsaWtlIHRoaXMgaXQgaXMgYmV0dGVyIHRvIHNlbGVjdCB0aGUNCj4gPiBudW1i
ZXIgb2YgVFggZGVzY3JpcHRvcnMgYnkgdXNpbmcgYSBzdHJ1Y3R1cmUgd2l0aCBhIHZhbHVlLCBy
YXRoZXINCj4gPiB0aGFuIGEgcnVudGltZSBkZWNpc2lvbiBiYXNlZCBvbiB0aGUgY2hpcCB0eXBl
Lg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhZGRzIHRoZSBudW1fdHhfZGVzYyB2YXJpYWJsZSB0byBz
dHJ1Y3QgcmF2Yl9od19pbmZvIGFuZA0KPiA+IGFsc28gcmVwbGFjZXMgdGhlIGRyaXZlciBkYXRh
IGNoaXAgdHlwZSB3aXRoIHN0cnVjdCByYXZiX2h3X2luZm8gYnkNCj4gPiBtb3ZpbmcgY2hpcCB0
eXBlIHRvIGl0Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6
QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBMYWQgUHJhYmhha2FyIDxwcmFiaGFr
YXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+IA0KPiBUaGFua3MgZm9yIHlvdXIg
cGF0Y2ghDQo+IA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5o
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAt
OTg4LDYgKzk4OCwxMSBAQCBlbnVtIHJhdmJfY2hpcF9pZCB7DQo+ID4gICAgICAgICBSQ0FSX0dF
TjMsDQo+ID4gIH07DQo+ID4NCj4gPiArc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gKyAgICAg
ICBlbnVtIHJhdmJfY2hpcF9pZCBjaGlwX2lkOw0KPiA+ICsgICAgICAgaW50IG51bV90eF9kZXNj
Ow0KPiANCj4gV2h5IG5vdCAidW5zaWduZWQgaW50Ij8gLi4uDQo+IFRoaXMgY29tbWVudCBhcHBs
aWVzIHRvIGEgZmV3IG1vcmUgc3Vic2VxdWVudCBwYXRjaGVzLg0KDQpUbyBhdm9pZCBzaWduZWQg
YW5kIHVuc2lnbmVkIGNvbXBhcmlzb24gd2FybmluZ3MuDQoNCj4gDQo+ID4gK307DQo+ID4gKw0K
PiA+ICBzdHJ1Y3QgcmF2Yl9wcml2YXRlIHsNCj4gPiAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2Ow0KPiA+ICAgICAgICAgc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldjsNCj4gPiBA
QCAtMTA0MCw2ICsxMDQ1LDggQEAgc3RydWN0IHJhdmJfcHJpdmF0ZSB7DQo+ID4gICAgICAgICB1
bnNpZ25lZCB0eGNpZG06MTsgICAgICAgICAgICAgIC8qIFRYIENsb2NrIEludGVybmFsIERlbGF5
IE1vZGUNCj4gKi8NCj4gPiAgICAgICAgIHVuc2lnbmVkIHJnbWlpX292ZXJyaWRlOjE7ICAgICAg
LyogRGVwcmVjYXRlZCByZ21paS0qaWQgYmVoYXZpb3INCj4gKi8NCj4gPiAgICAgICAgIGludCBu
dW1fdHhfZGVzYzsgICAgICAgICAgICAgICAgLyogVFggZGVzY3JpcHRvcnMgcGVyIHBhY2tldCAq
Lw0KPiANCj4gLi4uIG9oLCBoZXJlJ3MgdGhlIG9yaWdpbmFsIGN1bHByaXQuDQoNCkV4YWN0bHks
IHRoaXMgdGhlIHJlYXNvbi4gDQoNCkRvIHlvdSB3YW50IG1lIHRvIGNoYW5nZSB0aGlzIGludG8g
dW5zaWduZWQgaW50PyBQbGVhc2UgbGV0IG1lIGtub3cuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4g
DQo+ID4gKw0KPiA+ICsgICAgICAgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyAqaW5mbzsNCj4g
PiAgfTsNCj4gPg0KPiANCj4gR3J7b2V0amUsZWV0aW5nfXMsDQo+IA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICBHZWVydA0KPiANCj4gLS0NCj4gR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJl
J3MgbG90cyBvZiBMaW51eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC0NCj4gbTY4ay5vcmcN
Cj4gDQo+IEluIHBlcnNvbmFsIGNvbnZlcnNhdGlvbnMgd2l0aCB0ZWNobmljYWwgcGVvcGxlLCBJ
IGNhbGwgbXlzZWxmIGEgaGFja2VyLg0KPiBCdXQgd2hlbiBJJ20gdGFsa2luZyB0byBqb3VybmFs
aXN0cyBJIGp1c3Qgc2F5ICJwcm9ncmFtbWVyIiBvciBzb21ldGhpbmcNCj4gbGlrZSB0aGF0Lg0K
PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
