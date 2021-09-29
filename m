Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD8441C3A4
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 13:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245744AbhI2LqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 07:46:23 -0400
Received: from mail-eopbgr90085.outbound.protection.outlook.com ([40.107.9.85]:25184
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244345AbhI2LqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 07:46:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtIP/iL3B1yD01/GRCwYaYIXEAAlBkWxx5bkfurDswCYR8Kx11SBH4B+8269846b9aYDcZ6ZG2Yx4gpc5ap7PAddbhATqAis/F3Xyb1lYnkBnyjuLnnB0VIj6pYVDa5X6ayftkRVrpG1FiwyYWQkTPF5xws+BArMLLmAfakJV1gGdtkzcJjUmoo9RS7W3mlNDx+YgQTR9PxR0ihnU+vZNi7/UkGF7K9TDLCjgxhZqPzn2rNe2A9EL/VgIQ4YK7U39//impfthH3inpSbrNx1fINYcaOFgpU63eu2bzVP8Bj70tHRJc5Uhkh2VBvw9WwWRUoDCS7DO+kbGFXeslDKqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ONwuCxmj2XjRxKdrSMiR2WiGDrvbsViUWg6OGVnuDVs=;
 b=Vso2MzaWfZB/07oYCcWjaMchn5cJ2S0ArUnkKG+9F2kglOnLQCVO9m876GXhQx1RVKxZbG5P0ICj3wKgJmRcObbMKX1G7FNpBTnG0smCUyvf1ps5+sLY28y+SQSZ1HaKndzYjROcWf1axjx26MXYDZUKVStNhrzE/T52LqaCFekN449IT4vJ/BcZphMvGKOZuXgIFGiRFzgbiqBRJ9zUSvoJ+uSy9a1MhYDq4IySU1XRTctuUmMcmxpIRFF+4b8SjMjCB04KPlWsAvLdf0xsZBNbslNQOzagvrta1B8b863YHK8OZq2yXu6VSfPAkLHiOrpGVzjlBXUkpvtHLhrR4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRXP264MB0279.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 11:44:37 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cf5:e748:1407:1f58]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cf5:e748:1407:1f58%7]) with mapi id 15.20.4566.015; Wed, 29 Sep 2021
 11:44:37 +0000
From:   LEROY Christophe <christophe.leroy@csgroup.eu>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "paulus@samba.org" <paulus@samba.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Subject: Re: [PATCH v4 6/8] bpf ppc64: Access only if addr is kernel address
Thread-Topic: [PATCH v4 6/8] bpf ppc64: Access only if addr is kernel address
Thread-Index: AQHXtSPoiKf5GNj+00GWo03hX/ZgUqu65HkA
Date:   Wed, 29 Sep 2021 11:44:37 +0000
Message-ID: <dac0a043-51f0-24ba-b9fb-6cf53e4ce15f@csgroup.eu>
References: <20210929111855.50254-1-hbathini@linux.ibm.com>
 <20210929111855.50254-7-hbathini@linux.ibm.com>
In-Reply-To: <20210929111855.50254-7-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c6e61ab-6461-4b14-304f-08d9833e83e8
x-ms-traffictypediagnostic: MRXP264MB0279:
x-microsoft-antispam-prvs: <MRXP264MB02793695A6C7F38E568AC01DEDA99@MRXP264MB0279.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DEteGcCwQ2uN2AG3PTWGtCQ+wOIIIWfYxLDjWDn9HBPIqnaPFWlyswHcqf1JA8GJqIc+sn1DoxrwNgERrrgkBSIHsMoBj6ANgpCnqDpHezwaxcFYV+sM/2HrxHxHmGM7K+ebZhr2smx/TJGYXbNibSZ3rPpHh9q0K4fWsdlc22fXTKNQD+wRg9kIFVFZx+CrCCgcVovP6DFh1+Asks0zV5yurmzZDp3IySGjOpW/IoUhMeTLdh5apKLjq86qjvQHwHFwH+300ezXvZDQYQnzLhH0sYfOHNaitwAvw4hToYFxNfK++PqAtZEC06ORivWHrNR0SZcpeGkfR2z6abvHKqBpWEDT71NKnXoTGku3fvwWufe0lpE7s6Tpo2h7sZuqR7zOWXrI9ZuwLI2zw251Mqm5VcwN7JgmlVBaDngqdd9MlkVd03a8TTpg7mjuEwVnrx24DOAi3UY7R4npUm9xR9jqMCYrOheUtwvrhPUS9BTHAYw1wgD8UgjCNtJiaGxGmL0liBC3+nFA3xoWSACsR5JwOJy5CHFqGnHI0xtP/a7u76QK92A3UqP6GpJjXjI+J+Mf6D7VQvwqAQuvvaKc73xrQBG1riojgsFgabh8acQgQ5zOheN8NE5DNZY3+PKZdr1jcEnRHiw+8Tw+eY765oRhWqIKNoadIuCtFj9vJUwbzhUur7bT1+QIkcwvAJkKvgQ5iKjbe1GePoqyVvJWLFxI1Dmzj+ROyxO7icXg+cLJQw/E0I7S45rJmjN/+NvD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(8936002)(38070700005)(2906002)(83380400001)(508600001)(64756008)(66446008)(66476007)(66946007)(54906003)(66556008)(6506007)(26005)(38100700002)(91956017)(76116006)(66574015)(86362001)(6512007)(31686004)(71200400001)(316002)(36756003)(122000001)(31696002)(6486002)(4326008)(186003)(110136005)(7416002)(8676002)(2616005)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVU1YWVlak15aEJ4NUdMc091TjBkUlNqb1cvQnVtcUtsdUlxamdiMHJoZ0s1?=
 =?utf-8?B?RDEvTEJNTWl1bWlFM2V1dTRyVnVOUGRpeGs2czhZZGdlZ09VSTUveVVFMXlQ?=
 =?utf-8?B?d1oxOTYxbjlEQmN3ekxicmx3VDRMK2pleE9RTmttNlNpb1VzMDV3ZEM1UDFQ?=
 =?utf-8?B?M3ZUUXFBVFN3M1h6c2dzQkd2S0tyQmtTcUJJbGtrRlI5V29Gd0dIRFQ5M0lF?=
 =?utf-8?B?TGV1b21ONWtVTDNhdWZnK04yTUtacWFIeitYOHBBUWxXdkF5bk1rOXpkREtU?=
 =?utf-8?B?Nm9RQ0ZOYUlDc0JvdkMzMzNlV3VKaG5JN3o5bjBUUXpCeE1pcEd0UDJVZ2kv?=
 =?utf-8?B?VEpRZUY1ZFlMd0s0WkljM011UjFjQVZLejUzcHRLOXgzQjA5VE5vZFRYOEs3?=
 =?utf-8?B?QXdFWkxZaWsvZUgxY041NUg0dGtDQkJEN3grM2FUeUVzdE1UWTlLOGtyWmdj?=
 =?utf-8?B?Wm80RWJlSXM4MTBjdVphb2RNN2JzTXZ5c3EwaStsbmFZb2l0ZUtqc3BobVZO?=
 =?utf-8?B?czRpTG8xTXFQelMxUGtNcHFia2FnSHBsQmdWUkF2S2lwODZ6bG95TjA0bnRJ?=
 =?utf-8?B?WDhjRHQ2Mzg1WWxUL2gyeEo2aFl5dEpqaFBRbTV4M2pxU0NDZk81eGtOMzJW?=
 =?utf-8?B?cFl5dVkzeFRCQVkxVzdlcDN5UFJpWDRpeXJOQUxiMnNRb3h5SGg2MzhJRnBx?=
 =?utf-8?B?dU9yY3EwRzBwSzhobnBUR3AraEpaTWNTejB5Yy9FZjJsVXR6Q0RJVXJmU0tV?=
 =?utf-8?B?TzE0YlhDWEt2aEhnTzVmYWcwdDU4MEhrRzRCU2Rhc3IycEQ3NE95Z1ZYTVkx?=
 =?utf-8?B?b29FRFVrL1JtTVFtMXhxQ0lrMk0xcmhSaXQ1TDVEK3ZUU1FNRnNvNlc2eUFS?=
 =?utf-8?B?clh5MlcyOE5kc2FOVlBjQ1RnMEZMeUVjcEI1M2NkTXQwOHJWYXJoY2lReHM1?=
 =?utf-8?B?NXFXcjJxMExha1krVVAxYTV2emtKZ1FGTkFjVFR6QllYZURpZkVPbnh3WEd3?=
 =?utf-8?B?VjZQRWgvRU90TEdOVGYwazhwZFAyd0tSSXR0amtzbkZ0ZEU0SFdGSDhRaDBK?=
 =?utf-8?B?ZlZhRXZOcXNhajhySFV2KzkxNzRQUDQwZ29adkFycnVuN1FKWUludStwVDU5?=
 =?utf-8?B?V2dxd2ZLcFRJS1FkTGhLcEpQa2JOd2s2dnJ1OUlhbFBRRlVJdVdWQnphS1Jt?=
 =?utf-8?B?K0NwdDVSdnZrQ2lpZG5tNm1JMXNvMi9DU0dmSTd3RGdDeE9Xa2twZG9Ia2Ja?=
 =?utf-8?B?b3dDSnNtSFVpK29uZSsxYzdvOWJBM1RuMS9KWCtTQmNIZklXQWRiTHJHTFFY?=
 =?utf-8?B?eHBUT1hVL3Q2ZjZCV3JzblR4UGR3WDJ1aWt5TkQ4b0J5ZEEzM0tpZG9mMlli?=
 =?utf-8?B?bkFVRWQvUmhWSDE5Vm5zdlB5bDhHVkpGdXpkTEtxU00zNzd2cmtyUXpla2lP?=
 =?utf-8?B?SWFDMllJM1p0SUQ1b2pRcDJMemVaT0UwbDlFRUI4QWJjeUlDV0xJT0tnUFNM?=
 =?utf-8?B?c2M3dnJwTFdza2s4eGZBdDBud2kyUS9LSkJiM0JoYVJHck5TZU9CeXEveVdr?=
 =?utf-8?B?T2hqVnZKQm1XaFA4WlVkajJ3M01ORmxVYndmWWxLVk5PR3JFV2VLOC9nWHdK?=
 =?utf-8?B?WlhlV09JLzA0SmZtdzFUMHI2YXA1SWNNTWhTQkRBRkpsZEMrckhkL3MvZDYz?=
 =?utf-8?B?cHZmb0E1b1hqSE5QU3RSejhSYVhEZWxUQWdDK0I2VXZrVUJJZVNuR2VkWGUw?=
 =?utf-8?Q?5++PUYqMTeHhOXJ9hwXerfNGt5uaLkT7yNCKjnS?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BBDF83D77FA29745B8155D0F4449F2F8@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6e61ab-6461-4b14-304f-08d9833e83e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 11:44:37.2544
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XSJ+/lQ4yeOIOMo521qylvehy/3TDm6BuUiJ/Lp7qMRUye/pSd7ZzeFST7QP+HP6DTVGZ0cxt8cN16TY928yVMVmRUOksHdvwcHtFck8eYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRXP264MB0279
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDI5LzA5LzIwMjEgw6AgMTM6MTgsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBG
cm9tOiBSYXZpIEJhbmdvcmlhIDxyYXZpLmJhbmdvcmlhQGxpbnV4LmlibS5jb20+DQo+IA0KPiBP
biBQUEM2NCB3aXRoIEtVQVAgZW5hYmxlZCwgYW55IGtlcm5lbCBjb2RlIHdoaWNoIHdhbnRzIHRv
DQo+IGFjY2VzcyB1c2Vyc3BhY2UgbmVlZHMgdG8gYmUgc3Vycm91bmRlZCBieSBkaXNhYmxlLWVu
YWJsZSBLVUFQLg0KPiBCdXQgdGhhdCBpcyBub3QgaGFwcGVuaW5nIGZvciBCUEZfUFJPQkVfTUVN
IGxvYWQgaW5zdHJ1Y3Rpb24uDQo+IFNvLCB3aGVuIEJQRiBwcm9ncmFtIHRyaWVzIHRvIGFjY2Vz
cyBpbnZhbGlkIHVzZXJzcGFjZSBhZGRyZXNzLA0KPiBwYWdlLWZhdWx0IGhhbmRsZXIgY29uc2lk
ZXJzIGl0IGFzIGJhZCBLVUFQIGZhdWx0Og0KPiANCj4gICAgS2VybmVsIGF0dGVtcHRlZCB0byBy
ZWFkIHVzZXIgcGFnZSAoZDAwMDAwMDApIC0gZXhwbG9pdCBhdHRlbXB0PyAodWlkOiAwKQ0KPiAN
Cj4gQ29uc2lkZXJpbmcgdGhlIGZhY3QgdGhhdCBQVFJfVE9fQlRGX0lEICh3aGljaCB1c2VzIEJQ
Rl9QUk9CRV9NRU0NCj4gbW9kZSkgY291bGQgZWl0aGVyIGJlIGEgdmFsaWQga2VybmVsIHBvaW50
ZXIgb3IgTlVMTCBidXQgc2hvdWxkDQo+IG5ldmVyIGJlIGEgcG9pbnRlciB0byB1c2Vyc3BhY2Ug
YWRkcmVzcywgZXhlY3V0ZSBCUEZfUFJPQkVfTUVNIGxvYWQNCj4gb25seSBpZiBhZGRyIGlzIGtl
cm5lbCBhZGRyZXNzLCBvdGhlcndpc2Ugc2V0IGRzdF9yZWc9MCBhbmQgbW92ZSBvbi4NCj4gDQo+
IFRoaXMgd2lsbCBjYXRjaCBOVUxMLCB2YWxpZCBvciBpbnZhbGlkIHVzZXJzcGFjZSBwb2ludGVy
cy4gT25seSBiYWQNCj4ga2VybmVsIHBvaW50ZXIgd2lsbCBiZSBoYW5kbGVkIGJ5IEJQRiBleGNl
cHRpb24gdGFibGUuDQo+IA0KPiBbQWxleGVpIHN1Z2dlc3RlZCBmb3IgeDg2XQ0KPiBTdWdnZXN0
ZWQtYnk6IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YXN0QGtlcm5lbC5vcmc+DQo+IFNpZ25lZC1vZmYt
Ynk6IFJhdmkgQmFuZ29yaWEgPHJhdmkuYmFuZ29yaWFAbGludXguaWJtLmNvbT4NCj4gU2lnbmVk
LW9mZi1ieTogSGFyaSBCYXRoaW5pIDxoYmF0aGluaUBsaW51eC5pYm0uY29tPg0KDQpSZXZpZXdl
ZC1ieTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KDQo+
IC0tLQ0KPiANCj4gQ2hhbmdlcyBpbiB2NDoNCj4gKiBVc2VkIElTX0VOQUJMRUQoKSBpbnN0ZWFk
IG9mICNpZmRlZi4NCj4gKiBEcm9wcGVkIHRoZSBlbHNlIGNhc2UgdGhhdCBpcyBub3QgYXBwbGlj
YWJsZSBmb3IgUFBDNjQuDQo+IA0KPiANCj4gICBhcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29t
cDY0LmMgfCAyNiArKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2Vk
LCAyNiBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL25ldC9i
cGZfaml0X2NvbXA2NC5jIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXA2NC5jDQo+IGlu
ZGV4IDQxNzA5OTkzNzFlZS4uZTFlYTY0MDgxYWUxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2Vy
cGMvbmV0L2JwZl9qaXRfY29tcDY0LmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0
X2NvbXA2NC5jDQo+IEBAIC03MjcsNiArNzI3LDMyIEBAIGludCBicGZfaml0X2J1aWxkX2JvZHko
c3RydWN0IGJwZl9wcm9nICpmcCwgdTMyICppbWFnZSwgc3RydWN0IGNvZGVnZW5fY29udGV4dCAq
DQo+ICAgCQkvKiBkc3QgPSAqKHU2NCAqKSh1bCkgKHNyYyArIG9mZikgKi8NCj4gICAJCWNhc2Ug
QlBGX0xEWCB8IEJQRl9NRU0gfCBCUEZfRFc6DQo+ICAgCQljYXNlIEJQRl9MRFggfCBCUEZfUFJP
QkVfTUVNIHwgQlBGX0RXOg0KPiArCQkJLyoNCj4gKwkJCSAqIEFzIFBUUl9UT19CVEZfSUQgdGhh
dCB1c2VzIEJQRl9QUk9CRV9NRU0gbW9kZSBjb3VsZCBlaXRoZXIgYmUgYSB2YWxpZA0KPiArCQkJ
ICoga2VybmVsIHBvaW50ZXIgb3IgTlVMTCBidXQgbm90IGEgdXNlcnNwYWNlIGFkZHJlc3MsIGV4
ZWN1dGUgQlBGX1BST0JFX01FTQ0KPiArCQkJICogbG9hZCBvbmx5IGlmIGFkZHIgaXMga2VybmVs
IGFkZHJlc3MgKHNlZSBpc19rZXJuZWxfYWRkcigpKSwgb3RoZXJ3aXNlDQo+ICsJCQkgKiBzZXQg
ZHN0X3JlZz0wIGFuZCBtb3ZlIG9uLg0KPiArCQkJICovDQo+ICsJCQlpZiAoQlBGX01PREUoY29k
ZSkgPT0gQlBGX1BST0JFX01FTSkgew0KPiArCQkJCUVNSVQoUFBDX1JBV19BRERJKGIycFtUTVBf
UkVHXzFdLCBzcmNfcmVnLCBvZmYpKTsNCj4gKwkJCQlpZiAoSVNfRU5BQkxFRChDT05GSUdfUFBD
X0JPT0szRV82NCkpDQo+ICsJCQkJCVBQQ19MSTY0KGIycFtUTVBfUkVHXzJdLCAweDgwMDAwMDAw
MDAwMDAwMDB1bCk7DQo+ICsJCQkJZWxzZSAvKiBCT09LM1NfNjQgKi8NCj4gKwkJCQkJUFBDX0xJ
NjQoYjJwW1RNUF9SRUdfMl0sIFBBR0VfT0ZGU0VUKTsNCj4gKwkJCQlFTUlUKFBQQ19SQVdfQ01Q
TEQoYjJwW1RNUF9SRUdfMV0sIGIycFtUTVBfUkVHXzJdKSk7DQo+ICsJCQkJUFBDX0JDQyhDT05E
X0dULCAoY3R4LT5pZHggKyA0KSAqIDQpOw0KPiArCQkJCUVNSVQoUFBDX1JBV19MSShkc3RfcmVn
LCAwKSk7DQo+ICsJCQkJLyoNCj4gKwkJCQkgKiBDaGVjayBpZiAnb2ZmJyBpcyB3b3JkIGFsaWdu
ZWQgYmVjYXVzZSBQUENfQlBGX0xMKCkNCj4gKwkJCQkgKiAoQlBGX0RXIGNhc2UpIGdlbmVyYXRl
cyB0d28gaW5zdHJ1Y3Rpb25zIGlmICdvZmYnIGlzIG5vdA0KPiArCQkJCSAqIHdvcmQtYWxpZ25l
ZCBhbmQgb25lIGluc3RydWN0aW9uIG90aGVyd2lzZS4NCj4gKwkJCQkgKi8NCj4gKwkJCQlpZiAo
QlBGX1NJWkUoY29kZSkgPT0gQlBGX0RXICYmIChvZmYgJiAzKSkNCj4gKwkJCQkJUFBDX0pNUCgo
Y3R4LT5pZHggKyAzKSAqIDQpOw0KPiArCQkJCWVsc2UNCj4gKwkJCQkJUFBDX0pNUCgoY3R4LT5p
ZHggKyAyKSAqIDQpOw0KPiArCQkJfQ0KPiArDQo+ICAgCQkJc3dpdGNoIChzaXplKSB7DQo+ICAg
CQkJY2FzZSBCUEZfQjoNCj4gICAJCQkJRU1JVChQUENfUkFXX0xCWihkc3RfcmVnLCBzcmNfcmVn
LCBvZmYpKTsNCj4g
