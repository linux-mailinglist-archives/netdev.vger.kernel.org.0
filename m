Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC05A418912
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 15:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhIZNmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 09:42:31 -0400
Received: from mail-eopbgr1400128.outbound.protection.outlook.com ([40.107.140.128]:9829
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231723AbhIZNm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Sep 2021 09:42:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBohocLVEvaRsgr5AzH6cM0hmNjPyCh5DpWBdFyBvRjad9DNVANEAmR/SF77IIh4+dVoKF0nBzWFw30caWXNbPkm0KhBlG3jnlIr++B/n64kGA8qXTZyYuaNjt63ddM7ohGMups+dVb2PRC/E5Pif/nBNgFPGLik+w2wPwtukBmSlfmASk9vcwmEbD1JPs4MbIRbzbPxx5qVI0aO+cCAelPXqjgIYh/iOIENLbDMHuRK/ojTrd1Y60weA6D4/fq2YhDN8oJeZ2Knfr7bOcaoSVuSVUHeGGR4zsQKTIcU1iRC0muanclFQojXUnRAECegZwmHiMRbE5411w1C+1KNbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=d6F/jXRRMeiuT/6k5zMwpuutsY2p4bFhUFPYZpI8u5A=;
 b=dukIKU5CvrgzY3SrBggi1228jo0Q7C1Un8VRar1zXLGUoyxFzzikiuHJ690ujsl9wntKCMWHOT4FS2oRHhc+lF5f8JPwFw6ugcauyEctP5QnSlPNRVCFxbcz1CC1cOX+C8i6iGXSQP1P+KeaoH9CP/xLXMWVkprFl8XKmOSPIhHXhFGGbtCQhkNehjDChwE7HWdb440HzlQrvtRXOIN3Zsw3C9yvBHnWeQBXf9v7HGt5CdCYXX6XmGOB8mbpVCVh8p/mLaxK6q3lj5nn8D/N3VXU5cv7qeAupoJPmkInQuxnAgEhH8BfV6juG1N8vkGB8OTA+B3DKsXFgdwRziLXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6F/jXRRMeiuT/6k5zMwpuutsY2p4bFhUFPYZpI8u5A=;
 b=nNsYEFStwRlMJ5EQkRYI1LSCqbtuFL+4ymA/U9+gUkMBGpnvcAeJ/TfYtRqxRKw0CsIZhrTf7AHO7ktFHV+pVnhTaoPvb5COgDy2eD9VZXwOeXP6CAurelY50aVXQPrHCCStGW1FXA3VH2iRWJaz+l8TChioRyDLuXZzmdMA67U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB5154.jpnprd01.prod.outlook.com (2603:1096:604:65::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Sun, 26 Sep
 2021 13:40:51 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::8f9:8388:6090:4262%7]) with mapi id 15.20.4544.021; Sun, 26 Sep 2021
 13:40:51 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Biju Das <biju.das.jz@bp.renesas.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: RE: [RFC/PATCH 04/18] ravb: Enable aligned_tx and tx_counters for
 RZ/G2L
Thread-Topic: [RFC/PATCH 04/18] ravb: Enable aligned_tx and tx_counters for
 RZ/G2L
Thread-Index: AQHXsIR/rI9qtDBWJEutPtc4C318GKux6kYAgAABRFCABGtD8A==
Date:   Sun, 26 Sep 2021 13:40:51 +0000
Message-ID: <OS0PR01MB592231650D386B25DAD1AB1586A69@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-5-biju.das.jz@bp.renesas.com>
 <61e541a7-338c-a9d1-0504-f2f7baf0ffed@omp.ru>
 <OS0PR01MB59225ECD831AFBAB4427441F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
In-Reply-To: <OS0PR01MB59225ECD831AFBAB4427441F86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bp.renesas.com; dkim=none (message not signed)
 header.d=none;bp.renesas.com; dmarc=none action=none
 header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fd2d60b-ba8a-406d-5da5-08d980f34175
x-ms-traffictypediagnostic: OSAPR01MB5154:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB515443BFD8BF1711636435E686A69@OSAPR01MB5154.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VACeAAqOw1LLeZ8uzsjrIGKS4BZdCwYdbQyTORhkEMUWX1hLXsqHn0fU3lYFPgplKHhWlVOtzpkWObI+Ijokb+lmpdpj1KvGHgJ6Ym3NuCp2ClE8r4T6RwDbOFG+A477BZOG9eAAfFv99/O5Ln7cRhwbRZh/OUXSStOC/wSroCU8wnMkJR7P6cd1IYQGdwEec+2zBYd0JQvUT6opXQU5IuRnbbvGNrNOoInBM9uBChDPsqZMk/dY6RlT5jwey0bxYPaUBwVaDy3m3cmMW9KS8v0IvP7zNUnxGySHnm3f0i/XAnoQR+NY9PsLhkXdtfug49qGn6Nxi+oMztcG6Bt5VTnH9xjDH996XkhALTfgEFcWrfFN3kAgnAwMqt4a0JohrmGaqID8BMRu1dG40EDpwBrUrlX3xIVC9KltOXChekQySxzBVtOErIOpH3+3AzetNWm5zccshoMaMkfLP4sdfHRTRndX9jPBR+S+fVSn7MmOntq0EDaPTXTXFZFaMUy+IEyv6ds3sZd9WsKDEGCuAIRSUlkO38qxpsImLElz18KhA0nxnai4mqBqSgN1O3XqkXtB3HLVVPvObBLj5Ic/Q388Kb5CdATXvqRliQBVTFwhssp7V7LQPLC2lbBUDorlqRI0Jqtekt3hTlT+np8icT6OTLnmSteV1HFTN9Q82c4IhUwSIgw6FXaipbTCQr2kTWqA6Ii+QfkewJQev+DxrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(316002)(71200400001)(53546011)(5660300002)(110136005)(52536014)(2906002)(4326008)(26005)(66946007)(9686003)(122000001)(8936002)(66476007)(6506007)(55016002)(86362001)(508600001)(38100700002)(186003)(38070700005)(66446008)(64756008)(66556008)(54906003)(83380400001)(8676002)(76116006)(107886003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TVdRTlpobHd6cWU4ZnRRcFhlUkpEZ29ncUV6YWxjbTVQMmFoWld0UGt2L29p?=
 =?utf-8?B?K3lNOENQVHZzSnVlMS9SZVpsRDdXN0w1KytSVENMekt0R0N3UlhZWEUycUF0?=
 =?utf-8?B?eXVobURST3I4eUNPMUNBMlFvTElhT0dXVFlwRWpmQ3ZxQXhpa3ZuOFhBQlNZ?=
 =?utf-8?B?Z2Z3emRQNlJ6M09aTEdqTm9sd044VHpkVjVkUWRXbXE5bXJvWG1HSEJxUEIr?=
 =?utf-8?B?UmhHV0FnN2NaMjl1blk0c0wvY3k1SFZqdTI0NGgrcEI3RHFYSTlJaS9mbFg5?=
 =?utf-8?B?cVlrOTVsN3piNmw3bjJlSFdIQjV4NVVlenBXYytud0VFZVBLU0JMT0VsM0tO?=
 =?utf-8?B?NUkvZTFBV2lyTTNPZ0NjQUs5SlFnQ0pHdGtBZU9DZXRiMFpRdXVHczZMVjJO?=
 =?utf-8?B?VDVOVks2ZXcyNEV6VkIrOHZ5elhLT2Fxb212ZUl3VlNuT1NMcUNYYjY3WWd0?=
 =?utf-8?B?d1Jqait2N3BzV1FRU0dialAvZlhtam52WWUyS2dNbHpibUJ1VkNFS2FnTnhl?=
 =?utf-8?B?VWVEeWZySE11cUdWY3VneDcrOElRR0l4bGpXZEQ2bEo2anZTZnRObVkwR2lu?=
 =?utf-8?B?dE9EQ2dwNFAzTmRCQ2dVTzhQRGg5cTZSRXNnbUo3Mmp3bmFSd3UrKzV2Z0Nx?=
 =?utf-8?B?bVoybG5hTUxQT2dnaXB5aG5vaitGbDlnZWlJSXpDdXhMK0YzeHB1cU9HOWxv?=
 =?utf-8?B?WGNPSHlyQ1AyeFpzM2Y4eGtVK3NBUjhadnpGRlZKdnBZc0h3N2F0YVduWFls?=
 =?utf-8?B?MTZYK2lOdFZQc3hKbExzeVhqQzM2L2NmRjFTS0l2Y3RxdjB2YStLTGtMMEdR?=
 =?utf-8?B?Q1F1cUZzKzlsRjJYUzFvNWhRM0Fvd2tvZlBxS2svVHdqdVJMR1NYQTE0bmlN?=
 =?utf-8?B?VXNoUHRHTU0rVFJrSnJQK1ZvcXRycW5xdmN5amxnWExJSEFkQUhyQmU3Nnc3?=
 =?utf-8?B?K0pjVzBlaGNYMk4vUEdaeGswVkVvUzZrWGFqNXcrRVJwTXkwOGp3eG5CM1l3?=
 =?utf-8?B?L2NzSGhkQXFua0pFVnRmclltc0J1RmNTdW5nV2EvRTJSVmROUjZGN2RGOU9S?=
 =?utf-8?B?TE8xd2x0RTA1aU5HbGR3aHZDSXJJQjJ3cTJaWUpFSGpkeTFQVmNaZzJkREdX?=
 =?utf-8?B?a1lzUTlqMVZ5Rlp3YVFsVTNsLzNnS255M2JmVmZFbkZuRysweGRlbWFxRVNi?=
 =?utf-8?B?K0xMdTVqY1JpZ2tZM1R3V0lxdUNXeG40dVlYRkJBUWxac3JBdlZ1ZVFaU21k?=
 =?utf-8?B?dHNxalBkeW1DcEJ5eW1iamt6U0hyTE1hUUdmRWdkazdJanFkQXRUYW1pdGk3?=
 =?utf-8?B?K1U5bmJndEFQcy9iZE8yd1gzNERUaUtGOUU4QklLUlA3TkZlUmZMZldpaHp4?=
 =?utf-8?B?d0hxaXhvNlV5SFdwS2crQVZ0VFpCTERlS05wdjAxcm1Cd1lIK2dSQy90VStv?=
 =?utf-8?B?R0tpR0lBZVlQRzFFRGZmKytSVTM5NlhwdndxZkFsZEh0dS9KRXR3VW1LUkYw?=
 =?utf-8?B?L3YyZ3NIWDdERmNzWS9sZXRjYkw5N1QzZ0ZTdVFrWVNRK3lvWGJPSjFQWkVH?=
 =?utf-8?B?RVNWUFBYUjdJNTlEZjdwU1J4cFpPRnpDaUpzVC9hbVhKTVI3OXZGVVNFYnZk?=
 =?utf-8?B?eW9xRVZOckVaWUF3bEhkVE9iaHVZK0tVLzJJd0NuUFQrdjZkbndySDUzWFhI?=
 =?utf-8?B?QXVCNzM1MUVYd1BVbms3ZVlNOGR5L1ZOMzQ4T3dJekQ1VzBFWFloZjhta3VO?=
 =?utf-8?Q?+H5agTVTD48g0BwwCNoTSaWo2WrrBkS21nKAsp6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd2d60b-ba8a-406d-5da5-08d980f34175
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2021 13:40:51.1970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvWbQEXDmtE2T9l4ohLVk35x7I9R1gLHUQ8+vLVBVLRSeOzZuyCkfzExMckakdZhbfdVKoDB0Ko5vMgPFODLqfheSS/WbJLmMZJ7lfeg4k4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5154
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IFN1YmplY3Q6IFJFOiBbUkZDL1BBVENIIDA0LzE4XSByYXZiOiBFbmFi
bGUgYWxpZ25lZF90eCBhbmQgdHhfY291bnRlcnMgZm9yDQo+IFJaL0cyTA0KPiANCj4gSGkgU2Vy
Z2VpLA0KPiANCj4gVGhhbmtzIGZvciB0aGUgcmV2aWV3Lg0KPiANCj4gPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAwNC8xOF0gcmF2YjogRW5hYmxlIGFsaWduZWRfdHggYW5kIHR4X2NvdW50ZXJz
DQo+ID4gZm9yIFJaL0cyTA0KPiA+DQo+ID4gT24gOS8yMy8yMSA1OjA3IFBNLCBCaWp1IERhcyB3
cm90ZToNCj4gPg0KPiA+ICAgIFNvbWVob3cgdGhpcyBwYXRjaCBoYXZlbid0IHJlYWNoZWQgbXkg
T01QIGVtYWlsIC0tIEkgZ290IGl0IG9ubHkNCj4gPiB0aHJ1IHRoZSBsaW51eC1yZW5lc2FzLXNv
YyBsaXN0Li4uIDotLw0KPiA+DQo+ID4gPiBSWi9HMkwgbmVlZCA0Ynl0ZSBhZGRyZXNzIGFsaWdu
bWVudCBsaWtlIFItQ2FyIEdlbjIgYW5kIGl0IGhhcw0KPiA+ID4gdHhfY291bnRlcnMgbGlrZSBS
LUNhciBHZW4zLiBUaGlzIHBhdGNoIGVuYWJsZSB0aGVzZSBmZWF0dXJlcyBmb3INCj4gPiA+IFJa
L0cyTC4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBCaWp1IERhcyA8YmlqdS5kYXMuanpA
YnAucmVuZXNhcy5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmIuaCAgICAgIHwgMiArLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMgfCAyICsrDQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2Vy
dGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiA+IGluZGV4IGJlZTA1ZTZmYjgxNS4uYmI5MjQ2OWQ3NzBl
IDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgN
Cj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gPiBA
QCAtMTk1LDcgKzE5NSw3IEBAIGVudW0gcmF2Yl9yZWcgew0KPiA+ID4gIAlHRUNNUgk9IDB4MDVi
MCwNCj4gPiA+ICAJTUFIUgk9IDB4MDVjMCwNCj4gPiA+ICAJTUFMUgk9IDB4MDVjOCwNCj4gPiA+
IC0JVFJPQ1IJPSAweDA3MDAsCS8qIFItQ2FyIEdlbjMgb25seSAqLw0KPiA+ID4gKwlUUk9DUgk9
IDB4MDcwMCwJLyogUi1DYXIgR2VuMyBhbmQgUlovRzJMIG9ubHkgKi8NCj4gPiA+ICAJQ0VGQ1IJ
PSAweDA3NDAsDQo+ID4gPiAgCUZSRUNSCT0gMHgwNzQ4LA0KPiA+ID4gIAlUU0ZSQ1IJPSAweDA3
NTAsDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZi
X21haW4uYw0KPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
DQo+ID4gPiBpbmRleCA1NGM0ZDMxYTY5NTAuLmQzOGZjMzNhOGU5MyAxMDA2NDQNCj4gPiA+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+ICsrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiA+IEBAIC0yMTE0
LDYgKzIxMTQsOCBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IHJhdmJfaHdfaW5mbyByZ2V0aF9od19p
bmZvID0NCj4gew0KPiA+ID4gIAkuc2V0X2ZlYXR1cmUgPSByYXZiX3NldF9mZWF0dXJlc19yZ2V0
aCwNCj4gPiA+ICAJLmRtYWNfaW5pdCA9IHJhdmJfZG1hY19pbml0X3JnZXRoLA0KPiA+ID4gIAku
ZW1hY19pbml0ID0gcmF2Yl9yZ2V0aF9lbWFjX2luaXQsDQo+ID4gPiArCS5hbGlnbmVkX3R4ID0g
MSwNCj4gPiA+ICsJLnR4X2NvdW50ZXJzID0gMSwNCj4gPg0KPiA+ICAgIE1obSwgSSBkb24ndCBz
ZWUgYSBjb25uZWN0aW9uIGJldHdlZW4gdGhvc2UgMiAob3RoZXIgdGhhbiB0aGV5J3JlDQo+ID4g
Ym90aCBmb3IgUlgpLiBBbmQgYW55d2F5LCB0aGlzIHByb2xseSBzaG91bGQgYmUgYSBwYXJ0IG9m
IHRoZSBwcmV2aW91cw0KPiBwYXRjaC4uLg0KPiANCj4gVGhlcmUgd2FzIGEgZGlzY3Vzc2lvbiB0
byBtYWtlIHNtYWxsZXIgcGF0Y2hlcy4gSWYgdGhlcmUgaXMgbm8gb2JqZWN0aW9uLA0KPiBvbiB0
aGUgbmV4dCByZXZpc2lvbiBJIHdpbGwgYWRkIHRoaXMgYXMgcGFydCBvZiBwcmV2aW91cyBwYXRj
aC4NCj4gDQoNClRoYW5rcywgQXMgZGlzY3Vzc2VkLCBJIGhhdmUgbWVyZ2VkIHRoaXMgd2l0aCBw
cmV2aW91cyBwYXRjaCwgYXMgaXQgaXMgdHJpdmlhbCBjaGFuZ2UuDQoNClJlZ2FyZHMsDQpCaWp1
DQo=
