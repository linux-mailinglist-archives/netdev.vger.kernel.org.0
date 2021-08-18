Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E783F018F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbhHRKYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:24:18 -0400
Received: from mail-eopbgr1410102.outbound.protection.outlook.com ([40.107.141.102]:59659
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231741AbhHRKYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:24:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxjQol8qKHL2B2KHfazyMZJzY80EzvdJchfMJnbFtt4wz8GhgWfP9G0GZkXU56q76DSvACEiAZa6yMnMJIzx0WuOXV3L012Duk/CSTIdnTz6uT7tnQNk/eIdysFAgEbO6QX6ctHRZjAJ5kZjXfV6DVszskDSyAtrdJVqm4eRhpjfP+z7qSYYdYSXgMeWImpOvs0LJW5r7BI+mgGW+wqRNk9gautnrJL/QHAGZEhNjna55vAXDAelEHS8LznjdhW5oIFNRVCXYIY4vVvhfOlq+gGOGSB5mZ2w6NnnDdvFoJBeROwVsqJ5ln10l/pLQNKeUT943O9zr17miKtf2LIijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdxvUdNJ/xmAjzC/zYGxmy8ayIInSAxYUiS2LulI1W8=;
 b=MGJKkO1pCaxe/LRfFGLUa1hj2TnZCpTqeLp1AmjJeH6CcvJfbqB9j7wNf5tsvJ7prW8EjD6DjkYOKu7igzHd4Keby847x2ghKxo8ECGzHThkstVqxYrTWbukkPL1sdSkYBRGz1Y2cTfaUslerK1ij2QrE/0NDk9ZJpkYFZolWqhcPV9fMsj/RM4U+4yH5cVzaYBH5tRg5Baueh7U4BbLBrKQGeKSp2qcumgJ1X3+CZFF7iDPM+fiyYJmLr0oE6154mnxtj0vkGvMvX6mlZMiQJ8onmfSQ/FuILy/dLYGi6Ui3ftSaodKJiTEVauEHc8/tRDJdQvddemIEfXrFfcqnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdxvUdNJ/xmAjzC/zYGxmy8ayIInSAxYUiS2LulI1W8=;
 b=hJ/4M1Il+G3TEA08nLBhBL8k6QLaWzcA3OjrMVT40qBvShplo5O0Oqrog76nAUdWtrXBGDV6hokjXxfaUQHU3OWjhjk1mznPZOhtoj0ms9B40oN2+w/0jWs1r9TrgLIR8TiPBCE4QP/k32veWc658Fz2xbnRW11Jr7OYEPFPg+s=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB1879.jpnprd01.prod.outlook.com (2603:1096:603:6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Wed, 18 Aug
 2021 10:23:40 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%9]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 10:23:40 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
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
Thread-Index: AQHXh4j0+2cGRDLtLUyHm25tLRdYvKtrHuUAgARm9NCAAArSgIAAA4CAgAgRGKCAAJOwAIAAqShAgABBtwCAAAL/IA==
Date:   Wed, 18 Aug 2021 10:23:40 +0000
Message-ID: <OS0PR01MB59228540B0F69FA3FE13501886FF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210802102654.5996-1-biju.das.jz@bp.renesas.com>
 <20210802102654.5996-2-biju.das.jz@bp.renesas.com>
 <CAMuHMdWuoLFDRbJZqpvT48q1zbH05tqerWMs50aFDa6pR+ecAg@mail.gmail.com>
 <OS0PR01MB5922BF48F95DD5576A79994F86F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <CAMuHMdVCyMD6u2KxKb_c2LR8DGAY86F69=TSRDK0C5GPwrO7Eg@mail.gmail.com>
 <OS0PR01MB5922C336CBB008F9D7DA36B786F99@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <OS0PR01MB5922A841D2C8E38D93A8E95086FE9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <071f3fd9-7280-f518-3e38-6456632cc11e@omp.ru>
 <OS0PR01MB59225D98CEA7E2E0FD959B3186FF9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <dcbf2171-080c-d743-6aeb-6936b498d1fd@omp.ru>
In-Reply-To: <dcbf2171-080c-d743-6aeb-6936b498d1fd@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30f53549-2d30-4a5f-ad5a-08d962323f97
x-ms-traffictypediagnostic: OSBPR01MB1879:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB1879FBFCF62B02C9F1DBEABC86FF9@OSBPR01MB1879.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OnEaS0C2IrccrNvZu7Xd3dwawAM8k6nLlp53djlqsygYVt423LMzbS9M/Y7GqktuuQkCLlWOVOsSTIp8NVdeINa5UsynVjUSj9nV+5fn4WZ0hDnr1jd4Y8Nm0RWgAOiwwgzJXAHQbrfcIh4tDc5EF6VSQD5O5xHkb85XlN69lg9KME6Il5hyGigv8MveycPDSKVt+vPEWPNYXiGkKUaIjvChRoRxeQBMtq2C1qimae4MoBSLEO0K1rvitz/UfEV3isL7/fkcWyYiDWUR3iVY3EvGOrfc5s3PVAyJsyvfaq440/I0nKIazgBeeYHAKlUwR8kQyOwAB547PWJfthE2ltRg1cPyq9H/CSXc5KwmeAuHenkA/X+1IbyiER37Z/do+wd+6AzwQtNNqwQ8UZjf1kFRN5PX/obm/05VV3YcP9SmVA9Df0N7ZnFrDIAN3ja0cDudHGQKQKvFlMoorDRudeqtvFqdI5pFuUMvHnCxvDqxmdbH+g49ODgTTiFqHNG5vYwTQAZcPgDXF0LPACn4tsPveXnlwubR/PYvoaPVX3PSSILqybt5SgkGzV9gpt5j6yYOU/GkfIYdsKUT4ouOWlF98l3mk2zypLQqP81vikEtDG7yNUSgPrlKnQSp73EJa3Ydf9AGVrilVdSg3jMTDLPuB5ZnVeGLbqjAFTHTzjmbIruSRBTNKM0iiEQEPyjA9ioYT9P3tWj1U1DSrw/BHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(9686003)(71200400001)(107886003)(66476007)(2906002)(66556008)(86362001)(7416002)(122000001)(316002)(110136005)(4326008)(54906003)(7696005)(33656002)(76116006)(6506007)(53546011)(186003)(5660300002)(38100700002)(478600001)(66946007)(26005)(38070700005)(55016002)(8676002)(8936002)(66446008)(52536014)(64756008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TENsUTAvUkJBQVMxK0M1VkNEYkJyamV1RERnR0Joc1NwVldRYURsRTlvN0hC?=
 =?utf-8?B?OWp6QVNoclVCL2JGQ2tiQ3hmWm5ubzNsT1Y1Ym92YlBrbWt3QWJBU0FZQVlR?=
 =?utf-8?B?UnBsbEpTK3JSY1FuaG1oNXVBSjFHWW4rZEJvUEtlaHhCOVdBMlRhVzR2NXZp?=
 =?utf-8?B?SGZ5RHJ5VENWb0dQUXVNaUQ5TXZhbEh2SXBDV0hKU21VRUk2MDB5Ni9zMGlm?=
 =?utf-8?B?cHBhckUwZG9WSElZb1lrb2NoWlFQeFdCbnRvbkduYUkxdG9wbkx2MUVkOW01?=
 =?utf-8?B?VkN4WWU0eEZZNWRJSFZJTm4xamNEOGNFOUJhVkdxT0tTMW84NWFQQ0IzTmJi?=
 =?utf-8?B?Uzh5S3poODdtdWxoeUVPMVk5V2xBTXd6ck5LcEVJYVJ5QlJ0cE5PZEFLRVdM?=
 =?utf-8?B?Zmo5dkE3TzJ2c2RjTlNOYVFDck9xYVhFT2F6Y1k3YmYwNTA4VEwzUGlRY09q?=
 =?utf-8?B?QVJBdmJNd3Yydnd2M0l1dnZDYk4xMHVISUx2ZmF5SlZveVo2RHhJSlJxRTRG?=
 =?utf-8?B?emh5VllweVpyQm1lc3hScWxvN0lCYjJvbzVRd2pkbXlYVWdxTklnZkJCMkR3?=
 =?utf-8?B?Vk05cU1oRUp6QkFmaVRuNEdoNUtLdHRzOThTNmF3emxyTDRiZVo4RHJ0U2F1?=
 =?utf-8?B?QWd0dENEaXJvdFpvcnhIemdxdGNObFQvclNIR1h1YmtWYitoU0todDVaSGV5?=
 =?utf-8?B?ODdZSjNjeEdoQzVlcU13WlFJU3d6RjRaTmVic3F6NFN0VC83Z3RNTDN5d3px?=
 =?utf-8?B?RkJ1SVNTZHNaUGk2Q25RZUY4dFNHaEErWUlJaGI3TzNCYStaUXZXb3RIUEgy?=
 =?utf-8?B?eGJBc0JkQ0g0OGZZaUlSNFFuWDliS3g1L1lHRVd4Z3oyREkvSWZDd1c2ZGtJ?=
 =?utf-8?B?MGV4R2owWk1raTJEbWl2UEhnQjVMdFZkMXNuckdJbG9Dek8vNzh2M3NCQnFa?=
 =?utf-8?B?L3lDMFRDaEtFOGhPbnZTYk1TUXNGVnAxUjQveUZFWEE2VHB2WVJUakFSTUtw?=
 =?utf-8?B?VkR1SnllNVFKMEpxOTUyVjRMYm5pTm4wZ3c5Y2tMVTB6NXZwZmxFV0FTZksw?=
 =?utf-8?B?MWpERllINHBuTTN0SFJvQXQyRlN1SXVRZTEvK1FweGJOVGtJWTQzZzA4QXkv?=
 =?utf-8?B?ZmVFdEpiV2lzZCtqb1RpMVExbGhYeG1qRnZEZFMrenhzUERZMGd6Z0VaOWVX?=
 =?utf-8?B?emZwTVg3T3p5anlwMzdsd3JpdXNDZHdDcDZ3RUNPSlJqK3NvbE42dDVQUmNO?=
 =?utf-8?B?VTA4UWp6QmVPQ09KWTVMblZLNG1oVmlJcGVpdzZsdnF0SFpRclQ3M1RVM3Ro?=
 =?utf-8?B?aWcveGlsbDBqcWczRVJ3TXNVc1ZMRHZpdks1aTU4N0RxblQ2TkpCY3RrRXhp?=
 =?utf-8?B?R2NlL1pPdjJRaFN1VUFTZEV1OWZEdFFXNVR1U01kU1luZ0Jydk9RVXU3dml6?=
 =?utf-8?B?V0IxazdiWk9BblJCZDJkYkltaTUxU1h0VmVldDRFU0F4dlJJd0MxbzJoZ29o?=
 =?utf-8?B?WFJjNW0ycmFRWnRTYXUxUDRxRG1zUjcvQjFkNWRVdzhYTDE5UG1kZTc2Q1hS?=
 =?utf-8?B?SmZpL1VRcGhSclRXL1g4Z1F4QlQrbUVUVHpVaFBUU0lMSTNKaFUyclFhcFY0?=
 =?utf-8?B?YjJMeTRidFFHQXlKNUNyVlFxMDZ2bmdLalNRL082eHpMQ1ErODBRcmZtdmZS?=
 =?utf-8?B?cGYzRkkyVEsxWThuLzJXR0xUTm5FRVlwQ2gyM2s0UlRlTzFERkN1WHh1SVhM?=
 =?utf-8?Q?jJoqrXCq+TPobSeMA+jMP5YeoUDBuIM8fJDwKNf?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f53549-2d30-4a5f-ad5a-08d962323f97
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 10:23:40.2416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U1WZ3rI5Zgn/GeN9Hz+PFItgKogfLOYlXeUYqb86CuWSB37dO7ptrZtagvFxjkoshvvQLSY9Y9KuZCzYZQ+xX0KTEI3v+O3ka1Efpmesx8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1879
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0LW5leHQgdjIgMS84XSByYXZiOiBBZGQgc3RydWN0IHJhdmJfaHdfaW5mbyB0
bw0KPiBkcml2ZXIgZGF0YQ0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiAxOC4wOC4yMDIxIDk6Mjks
IEJpanUgRGFzIHdyb3RlOg0KPiANCj4gWy4uLl0NCj4gPj4+Pj4+PiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+Pj4+Pj4+IE9uIE1vbiwgQXVnIDIsIDIwMjEgYXQgMTI6MjcgUE0gQmlq
dSBEYXMNCj4gPj4+Pj4+PiA8YmlqdS5kYXMuanpAYnAucmVuZXNhcy5jb20+DQo+ID4+Pj4+Pj4g
d3JvdGU6DQo+ID4+Pj4+Pj4+IFRoZSBETUFDIGFuZCBFTUFDIGJsb2NrcyBvZiBHaWdhYml0IEV0
aGVybmV0IElQIGZvdW5kIG9uIFJaL0cyTA0KPiA+Pj4+Pj4+PiBTb0MgYXJlIHNpbWlsYXIgdG8g
dGhlIFItQ2FyIEV0aGVybmV0IEFWQiBJUC4gV2l0aCBhIGZldw0KPiA+Pj4+Pj4+PiBjaGFuZ2Vz
IGluIHRoZSBkcml2ZXIgd2UgY2FuIHN1cHBvcnQgYm90aCBJUHMuDQo+ID4+Pj4+Pj4+DQo+ID4+
Pj4+Pj4+IEN1cnJlbnRseSBhIHJ1bnRpbWUgZGVjaXNpb24gYmFzZWQgb24gdGhlIGNoaXAgdHlw
ZSBpcyB1c2VkIHRvDQo+ID4+Pj4+Pj4+IGRpc3Rpbmd1aXNoIHRoZSBIVyBkaWZmZXJlbmNlcyBi
ZXR3ZWVuIHRoZSBTb0MgZmFtaWxpZXMuDQo+ID4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+IFRoZSBudW1i
ZXIgb2YgVFggZGVzY3JpcHRvcnMgZm9yIFItQ2FyIEdlbjMgaXMgMSB3aGVyZWFzIG9uDQo+ID4+
Pj4+Pj4+IFItQ2FyDQo+ID4+Pj4+Pj4+IEdlbjIgYW5kIFJaL0cyTCBpdCBpcyAyLiBGb3IgY2Fz
ZXMgbGlrZSB0aGlzIGl0IGlzIGJldHRlciB0bw0KPiA+Pj4+Pj4+PiBzZWxlY3QgdGhlIG51bWJl
ciBvZiBUWCBkZXNjcmlwdG9ycyBieSB1c2luZyBhIHN0cnVjdHVyZSB3aXRoIGENCj4gPj4+Pj4+
Pj4gdmFsdWUsIHJhdGhlciB0aGFuIGEgcnVudGltZSBkZWNpc2lvbiBiYXNlZCBvbiB0aGUgY2hp
cCB0eXBlLg0KPiA+Pj4+Pj4+Pg0KPiA+Pj4+Pj4+PiBUaGlzIHBhdGNoIGFkZHMgdGhlIG51bV90
eF9kZXNjIHZhcmlhYmxlIHRvIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gPj4+Pj4+Pj4gYW5kIGFs
c28gcmVwbGFjZXMgdGhlIGRyaXZlciBkYXRhIGNoaXAgdHlwZSB3aXRoIHN0cnVjdA0KPiA+Pj4+
Pj4+PiByYXZiX2h3X2luZm8gYnkgbW92aW5nIGNoaXAgdHlwZSB0byBpdC4NCj4gPj4+Pj4+Pj4N
Cj4gPj4+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVz
YXMuY29tPg0KPiA+Pj4+Pj4+PiBSZXZpZXdlZC1ieTogTGFkIFByYWJoYWthcg0KPiA+Pj4+Pj4+
PiA8cHJhYmhha2FyLm1haGFkZXYtbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+Pj4+Pj4+DQo+
ID4+Pj4+Pj4gVGhhbmtzIGZvciB5b3VyIHBhdGNoIQ0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+Pj4+Pj4+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4+Pj4+Pj4+IEBAIC05ODgs
NiArOTg4LDExIEBAIGVudW0gcmF2Yl9jaGlwX2lkIHsNCj4gPj4+Pj4+Pj4gICAgICAgICAgUkNB
Ul9HRU4zLA0KPiA+Pj4+Pj4+PiAgIH07DQo+ID4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+ICtzdHJ1Y3Qg
cmF2Yl9od19pbmZvIHsNCj4gPj4+Pj4+Pj4gKyAgICAgICBlbnVtIHJhdmJfY2hpcF9pZCBjaGlw
X2lkOw0KPiA+Pj4+Pj4+PiArICAgICAgIGludCBudW1fdHhfZGVzYzsNCj4gPj4+Pj4+Pg0KPiA+
Pj4+Pj4+IFdoeSBub3QgInVuc2lnbmVkIGludCI/IC4uLg0KPiA+Pj4+Pj4+IFRoaXMgY29tbWVu
dCBhcHBsaWVzIHRvIGEgZmV3IG1vcmUgc3Vic2VxdWVudCBwYXRjaGVzLg0KPiA+Pj4+Pj4NCj4g
Pj4+Pj4+IFRvIGF2b2lkIHNpZ25lZCBhbmQgdW5zaWduZWQgY29tcGFyaXNvbiB3YXJuaW5ncy4N
Cj4gPj4+Pj4+DQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+Pj4gK307DQo+ID4+Pj4+Pj4+ICsNCj4gPj4+
Pj4+Pj4gICBzdHJ1Y3QgcmF2Yl9wcml2YXRlIHsNCj4gPj4+Pj4+Pj4gICAgICAgICAgc3RydWN0
IG5ldF9kZXZpY2UgKm5kZXY7DQo+ID4+Pj4+Pj4+ICAgICAgICAgIHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKnBkZXY7IEBAIC0xMDQwLDYgKzEwNDUsOCBAQA0KPiA+Pj4+Pj4+PiBzdHJ1Y3QgcmF2
Yl9wcml2YXRlIHsNCj4gPj4+Pj4+Pj4gICAgICAgICAgdW5zaWduZWQgdHhjaWRtOjE7ICAgICAg
ICAgICAgICAvKiBUWCBDbG9jayBJbnRlcm5hbA0KPiBEZWxheQ0KPiA+Pj4+PiBNb2RlDQo+ID4+
Pj4+Pj4gKi8NCj4gPj4+Pj4+Pj4gICAgICAgICAgdW5zaWduZWQgcmdtaWlfb3ZlcnJpZGU6MTsg
ICAgICAvKiBEZXByZWNhdGVkIHJnbWlpLSppZA0KPiA+Pj4+PiBiZWhhdmlvcg0KPiA+Pj4+Pj4+
ICovDQo+ID4+Pj4+Pj4+ICAgICAgICAgIGludCBudW1fdHhfZGVzYzsgICAgICAgICAgICAgICAg
LyogVFggZGVzY3JpcHRvcnMgcGVyDQo+ID4+Pj4gcGFja2V0DQo+ID4+Pj4+ICovDQo+ID4+Pj4+
Pj4NCj4gPj4+Pj4+PiAuLi4gb2gsIGhlcmUncyB0aGUgb3JpZ2luYWwgY3VscHJpdC4NCj4gPj4+
Pj4+DQo+ID4+Pj4+PiBFeGFjdGx5LCB0aGlzIHRoZSByZWFzb24uDQo+ID4+Pj4+Pg0KPiA+Pj4+
Pj4gRG8geW91IHdhbnQgbWUgdG8gY2hhbmdlIHRoaXMgaW50byB1bnNpZ25lZCBpbnQ/IFBsZWFz
ZSBsZXQgbWUNCj4ga25vdy4NCj4gPj4+Pj4NCj4gPj4+Pj4gVXAgdG8geW91IChvciB0aGUgbWFp
bnRhaW5lcj8gOy0pDQo+ID4+Pj4+DQo+ID4+Pj4+IEZvciBuZXcgZmllbGRzIChpbiB0aGUgb3Ro
ZXIgcGF0Y2hlcyksIEkgd291bGQgdXNlIHVuc2lnbmVkIGZvcg0KPiA+Pj4+PiBhbGwgdW5zaWdu
ZWQgdmFsdWVzLiAgU2lnbmVkIHZhbHVlcyBoYXZlIG1vcmUgcGl0ZmFsbHMgcmVsYXRlZCB0bw0K
PiA+Pj4+PiB1bmRlZmluZWQgYmVoYXZpb3IuDQo+ID4+Pj4NCj4gPj4+PiBTZXJnZWksIFdoYXQg
aXMgeW91ciB0aG91Z2h0cyBoZXJlPyBQbGVhc2UgbGV0IG1lIGtub3cuDQo+ID4+Pg0KPiA+Pj4g
SGVyZSBpcyBteSBwbGFuLg0KPiA+Pj4NCj4gPj4+IEkgd2lsbCBzcGxpdCB0aGlzIHBhdGNoIGlu
dG8gdHdvIGFzIEFuZHJldyBzdWdnZXN0ZWQgYW5kDQo+ID4+DQo+ID4+ICAgICBJZiB5b3UgbXJh
biBjaGFuZ2luZyB0aGUgcmF2Yl9wcml2YXRlOjpudW1fdHhfZGVzYyB0byAqdW5zaWduZWQqLA0K
PiA+PiBpdCdsbCBiZSBhIGdvb2QgY2xlYW51cC4gV2hhdCdzIHdvdWxkIGJlIHRoZSAybmQgcGFy
dCB0aG8/DQo+ID4NCj4gPiBPSyBpbiB0aGF0IGNhc2UsIEkgd2lsbCBzcGxpdCB0aGlzIHBhdGNo
IGludG8gMy4NCj4gPg0KPiA+IEZpcnN0IHBhdGNoIGZvciBhZGRpbmcgc3RydWN0IHJhdmJfaHdf
aW5mbyB0byBkcml2ZXIgZGF0YSBhbmQgcmVwbGFjZQ0KPiA+IGRyaXZlciBkYXRhIGNoaXAgdHlw
ZSB3aXRoIHN0cnVjdCByYXZiX2h3X2luZm8NCj4gDQo+ICAgICBDb3VsZG4ndCB0aGlzIGJlIGEg
Mm5kIHBhdGNoPy4uDQo+IA0KPiA+IFNlY29uZCBwYXRjaCBmb3IgY2hhbmdpbmcgcmF2Yl9wcml2
YXRlOjpudW1fdHhfZGVzYyBmcm9tIGludCB0byB1bnNpZ25lZA0KPiBpbnQuDQo+IA0KPiAgICAg
Li4uIGFuZCB0aGlzIG9uZSB0aGUgMXN0Pw0KPiANCj4gPiBUaGlyZCBwYXRjaCBmb3IgYWRkaW5n
IGFsaWduZWRfdHggdG8gc3RydWN0IHJhdmJfaHdfaW5mby4NCg0KU3VyZS4gV2lsbCBkby4NCg0K
Q2hlZXJzLA0KQmlqdQ0K
