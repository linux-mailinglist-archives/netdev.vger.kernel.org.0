Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A9A3DB37F
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 08:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbhG3GYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 02:24:20 -0400
Received: from mail-eopbgr1410135.outbound.protection.outlook.com ([40.107.141.135]:24933
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237403AbhG3GYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 02:24:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/wL3MPcwG8usUUy4B8R4ysHz5ac/7pNGAtPe3oyIEDpzkqDcF5WLb5SVykjhGaWMrocG2ye99Z++P4sbXPaBr1g8lMFcmMccYH7XQn+jhkhhXRJbFhXcrrVtTB0ZnY+VZoh/Mzeywc9kFg4U23ttzSMFp0Ja92c0CYFarbnRkW4uS/ssWAmJBJe3aKmBbKUkNoB68hDPrsH2VstnPZgrZaC5yA/QPJVuiOn5xeIoYHLJRmC4BtwZos12Mwh4mXtBseBjEIjJ8I0sBpBfkO1buwRLj2HXQPKi26G+4msNoCM3qMSYx2KPf6jHSGHdcFK0lCSPO+tK8zM/HnkQtlmyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOVtCEzVAYgu3wlqgT/AqXHe17isyGYmJmDbLv5H2mU=;
 b=oSSPihmfUNTfM9E9jGNwS0k59hY4Mnv7TdZw/Hg8upK19f13gJElPEoMxhlSkcnBsALY6KHREcATyyW9aBgj8dcKSX+wFiMnqHYV08BM61+tk4zZ3lMcw0wqjnMeA1nho89DvBcD5qWQf6DdkeiEjbFAU9IsG2GLvQFZkpkocqtK4+bwAkdmww60mPxqDnq1oODJuarNnEKxlfQ1AfrFGHgQRKyuo0L+vJAKZ79hYygtasReRJjsu/lkAqxAXA4qOurl5S48rGeguBsvSaEwc+/TNF3VuELoECXE9DgQTlLwYHpmbO+h6MzKVEonGCXpnu0n4X3IMFfhlSP29oB9xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOVtCEzVAYgu3wlqgT/AqXHe17isyGYmJmDbLv5H2mU=;
 b=ZUC/WpBaIuZoBRgeJKfq+YUktLGsvuzmZBMG9JQ+A1YCRkX48pK4jvaS0qbqX1ed5LM+8Q/ci17Na2RE+58chcCNNuaSSnPK+Wwopc3dAvsEi0kOIveI3dThQXkMFXVt5gUoGSVkrxCrDO1RibAbFGH0aK5mBOIZHT5je1H9Cv4=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5736.jpnprd01.prod.outlook.com (2603:1096:604:c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.22; Fri, 30 Jul
 2021 06:24:04 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::c6f:e31f:eaa9:60fe%8]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 06:24:04 +0000
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
Subject: RE: [PATCH net-next 10/18] ravb: Factorise ravb_ring_format function
Thread-Topic: [PATCH net-next 10/18] ravb: Factorise ravb_ring_format function
Thread-Index: AQHXfwPlqr0pn5HAi0+IkSRv+JoCRqtaUYSAgADG2kA=
Date:   Fri, 30 Jul 2021 06:24:03 +0000
Message-ID: <OS0PR01MB5922F76695507D1B6DFA8C3886EC9@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210722141351.13668-1-biju.das.jz@bp.renesas.com>
 <20210722141351.13668-11-biju.das.jz@bp.renesas.com>
 <a3f637b9-2e65-909c-01a3-d5275007866c@gmail.com>
In-Reply-To: <a3f637b9-2e65-909c-01a3-d5275007866c@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ec9d8f9-dba1-42aa-d808-08d95322a0bb
x-ms-traffictypediagnostic: OS3PR01MB5736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB5736DA72D5536013F0FBBBD986EC9@OS3PR01MB5736.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G4yOj3WDRVwXActllatjWCN4v/CSkSW/CcdyRFxqN+leEx1Rz4/3E3tV7Fys+JebwxkY3g0KhUxe2jXJyBylfXJ+rWrq2NyTksJwfWEhsgXNyVJr07FbOVg4goK9NYQ1xH1E8K4BR9cbUbZ19VhnBY20Rr4aNc4d8JSyNIpjrp4jA+cwzzeDmdR0JYw4RNtVjuJ40Vh6SQ4P7+yk9S1fTnKSGD98UTWxsWudyPHyQzZyYKymvivizO0SDui47QgNJ49+IgHWymSoOPR9+Jz4q2ZfW+KcMRNQDYFVh6Xl3Nv/3ZvauQJ8sJGfeI0/TlPc6VwfRUHUvGrIlpX2mbxlge5kK7c+KbXpCEh08ieW1O6FSnlRH2isYqKQsDaCwM6H5Nu3fWj/BuTuwJS/qIpjlD2XBbBBTe+UwILD79sVXnxBlpahBEUBAxs7JrwTL6Gw8QCfaZIV+LPw890NZ+FhYC7sONGzQE6xbSVpqle84+xPozaiRhgvIwnK/AZJ6KHWiR1CGUM93yKOM3gAmbUAp3/PfyC+8SjYoDCiPYAejwW56ErCv2TuKfuLhGFJ3zZNj0sVONeeEOC0IJFm5sYEjo87+cAzvACrAgXul/zwJuCrUd5mgdlEa3kXzhkOym+kxcMz2K3iPMLDA0cgDlYQbK6HFfaqyg/7E0uQIdKr9JU57sn26ZLzuq/nJEk+IqJtMibw5N2T9OdzaRJS8d2hzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(7696005)(83380400001)(33656002)(4326008)(8936002)(26005)(53546011)(6506007)(55016002)(54906003)(316002)(9686003)(71200400001)(107886003)(110136005)(52536014)(8676002)(7416002)(64756008)(66556008)(38100700002)(86362001)(122000001)(5660300002)(478600001)(66446008)(38070700005)(66476007)(2906002)(186003)(66946007)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHdaQnRmYUtIYUhnTWZ4U0x2bG10dTh1ZHNDN2Q0M2xVN2RjM092ZWI3R0hI?=
 =?utf-8?B?WUdmTDJ4ekltMS9Od3JVditQcFd1VGIvUVUzTVU0SzQrdndtQjBpMjA5VFBD?=
 =?utf-8?B?NlIvRE0yZTVZUWJuWU9xTmxpZFhZR2dtRXpSTUIzQUYrYTNXei90QzhldlJr?=
 =?utf-8?B?NVBTWmxsbU1seUw3NEhJVy9QaWs2R3U3eFF6dWFDVStxWEtqd1ZSNE1JWlNI?=
 =?utf-8?B?RVVHMko1WGV6K2hzREJJdUpiQlhjUEx6M3hva0tocEc3MzhRS0VKWnZWUTZx?=
 =?utf-8?B?bVBDc2pOUHBDWk1iTnZRN0RBa1lVbWNEMTVlQ1E3YkhxUlQ3YzB3eVZBdS82?=
 =?utf-8?B?MFkveTR1Z0JWZ3B2Qm5WeWxwWGJhbDhiNnVVZUNpMXlMeWZoT2tMcnJIaisv?=
 =?utf-8?B?YjZFVndGMENPTWZ0ZmFGcFYzdUllUU02UksyaXZGY1F4ZlNVU2d5Qkh5N0Vv?=
 =?utf-8?B?YW55cHVwc1RTVldVM0xEZHkyOGI2VkE1dG10ODE5YVh5L0NuMXdJWWVIaS9D?=
 =?utf-8?B?QmZab2s4M3BsQzJ0VXhwZHpvNHYvZHBRdXU2YkhqNVY3dkc3MWt3TUhaMHNS?=
 =?utf-8?B?MDd2UXN1eGlGOUJYVW1QbUFkeUZZc1lWNkp2YzczaVhiakR0L2laVm1pckpO?=
 =?utf-8?B?WURzWlpLZTN4RUVYNDlZRGZmOTRGNTFjWGdsR3hGRjNXMFBFM3c0Z2EwMjJS?=
 =?utf-8?B?M28zWGpMbFRaTm8vWFR4VWFHaGx3TmpRSHR4RHRKY2FGWE9wOFJDb1lyNkZV?=
 =?utf-8?B?MlBwQmFkTmFmS1dSb0w2OWExSHg5QmNiK0RoUVUyKzhSQjFxcjZ3a3hndUE4?=
 =?utf-8?B?U0JlMFBQZ2d2eERKUm5vNzhweUxMQTdqbGJNaE5UbzZzTVBWMU5yZ0VSaWJn?=
 =?utf-8?B?SEx3TjhFV3NnRVg2SXhPWXpKbHI4dldwd0l1UGtBOUdGWDJ3Wkt2a2RGM0Jy?=
 =?utf-8?B?RHh5QUx1ZUdqLzlhcE1rVk05RXUzd3cxYkI2ckJNcGdacEljYm0vQWNCbkNw?=
 =?utf-8?B?bVhqYnZ3ZkY5UjBVMXo4dllYajAydGV2YTV6VVJrNXVRZ05OUFBHQ2o1Wm9B?=
 =?utf-8?B?OVFIa3pydjFrVVpuTTZWTzRVdVhPTXZvd3J6MitzeXM3eHhmaDg4cVlib01h?=
 =?utf-8?B?dEFXSC93YUhHemVsbEtRUUVwejlPVitXdmNvMDk1WGpzOXVSYlI4U0lkNGJO?=
 =?utf-8?B?SXNCd2lIUTV1MjQyS1UxZmxoMjlHaHhvUTNJMityT0pSc1VWaWFzdVVsNVd2?=
 =?utf-8?B?OUcwUzhXanV3OUJSbmJtNjFSb0cySXlSUWI0Z3VMcUZSMVdxeUtkTWtTNWRL?=
 =?utf-8?B?Z0o0OWlnRTVkZkdYMFM5K01xbFBKQ3NZb2NMbDE3d01UcHpkQmJZQm8zT1Vl?=
 =?utf-8?B?N3oyS3VIVHY2TUZDN0RVTElzSVJnVjRDbytRQndKSWV2TkcwQmdOVXdsWTE4?=
 =?utf-8?B?bGFRR1ViWm14aEppbTVmVEhFaU14aTVDd1JtU2lsREFZYk5XQStuSk5UZTFa?=
 =?utf-8?B?bG5MeFdJYlRuZjd2ZGx5VHZ6c3RWVzNpdFZuWVR0REFaa1VVZ0xYU1dNSWx4?=
 =?utf-8?B?b2lCdmJ4S2IveW5pL1B4WmJ1Y2R0WTkyOFpOeW5Gdk5OTUpIenhSNS9oNzVu?=
 =?utf-8?B?dzVyUnpMbG9IVVNFYTNyRS9VdjVJZ0VBZXFnNlcrK2J4TUIyM0lTcW9rYldz?=
 =?utf-8?B?T2s3NWtaUjZBc2RBMURiVktmY1lFc1BiaXpiVlpSaDZrMmU1L2ZHSWhGK3VD?=
 =?utf-8?Q?YluzQ9meUT3woy7nljbfL46rtEddBdwqzJA/o6l?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec9d8f9-dba1-42aa-d808-08d95322a0bb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2021 06:24:03.8810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A4Ux6Gf/TwXFC/eaHXxizB7+obhjj/CQKU9ofrT0X3ZhPJ43CBedduHn2a73MWqSTR6MX8cKYP2LucMxhE7ghq8W62YndVq8Tm0qc//ZW4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5736
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIG5ldC1uZXh0IDEwLzE4XSByYXZiOiBGYWN0b3Jpc2UgcmF2Yl9yaW5nX2Zvcm1hdA0K
PiBmdW5jdGlvbg0KPiANCj4gT24gNy8yMi8yMSA1OjEzIFBNLCBCaWp1IERhcyB3cm90ZToNCj4g
DQo+ID4gVGhlIHJhdmJfcmluZ19mb3JtYXQgZnVuY3Rpb24gdXNlcyBleHRlbmRlZCBkZXNjcmlw
dG9yIGluIHJ4IGZvciBSLUNhcg0KPiA+IHdoZXJlIGFzIGl0IHVzZSBub3JtYWwgZGVzY3JpcHRv
ciBmb3IgUlovRzJMLiBGYWN0b3Jpc2UgcnggcmluZyBidWZmZXINCj4gPiBidWlsZHVwIHRvIGV4
dGVuZCB0aGUgc3VwcG9ydCBmb3IgbGF0ZXIgU29DLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTog
QmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBM
YWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+
ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oICAgICAgfCAg
MSArDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCAzNA0K
PiA+ICsrKysrKysrKysrKysrKy0tLS0tLS0tLQ0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDIzIGlu
c2VydGlvbnMoKyksIDEyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9yZW5lc2FzL3JhdmIuaA0KPiA+IGluZGV4IDNhOWNmNmU4NjcxYS4uYTMyNThjNWQwYzNkIDEw
MDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBAQCAtOTkwLDYg
Kzk5MCw3IEBAIGVudW0gcmF2Yl9jaGlwX2lkIHsNCj4gPg0KPiA+ICBzdHJ1Y3QgcmF2Yl9vcHMg
ew0KPiA+ICAJdm9pZCAoKnJpbmdfZnJlZSkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGludCBx
KTsNCj4gPiArCXZvaWQgKCpyaW5nX2Zvcm1hdCkoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIGlu
dCBxKTsNCj4gDQo+ICAgIExpa2UgSSBzYWlkLCB3ZSBkb24ndCBuZWVkIGFub3RoZXIgaW5kaXJl
Y3Rpb24uLi4uIGFsc28gYm90aCBvcHMgYXJlDQo+IGZvciBSWC4NCg0KT0suIFdpbGwgYWRkIHRo
aXMgYXMgcGFydCBvZiByYXZiX2Rydl9kYXRhLg0KDQo+IA0KPiBbLi4uXQ0KPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gaW5kZXggYTNiOGIyNDNm
ZDU0Li5jMjNmMGQ0MjBjNzAgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVz
YXMvcmF2Yl9tYWluLmMNCj4gPiBAQCAtMzExLDI2ICszMTEsMTUgQEAgc3RhdGljIHZvaWQgcmF2
Yl9yaW5nX2ZyZWUoc3RydWN0IG5ldF9kZXZpY2UNCj4gPiAqbmRldiwgaW50IHEpICB9DQo+ID4N
Cj4gPiAgLyogRm9ybWF0IHNrYiBhbmQgZGVzY3JpcHRvciBidWZmZXIgZm9yIEV0aGVybmV0IEFW
QiAqLyAtc3RhdGljIHZvaWQNCj4gPiByYXZiX3JpbmdfZm9ybWF0KHN0cnVjdCBuZXRfZGV2aWNl
ICpuZGV2LCBpbnQgcSkNCj4gPiArc3RhdGljIHZvaWQgcmF2Yl9yaW5nX2Zvcm1hdF9yeChzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiwgaW50IHJ4cSkNCj4gDQo+ICAgIEhvdyBhYm91dCByYXZiX3J4
X3JpbmdfZm9ybWF0KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LCBpbnQgcSk/DQoNCkFncmVlZC4N
Cg0KQ2hlZXJzLA0KQmlqdQ0KDQo+IA0KPiBbLi4uXQ0KPiANCj4gTUJSLCBTZXJnZWkNCg==
