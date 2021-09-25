Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3650C417FF6
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345021AbhIYGZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:25:19 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:6069
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231919AbhIYGZT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 02:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+Mtg1DvN/ac3g7cimV8VP6wzdpgxf9tOv8wGryNUr8A95IWsM7VR3sBOxQp5EHcHWNGQ0WMyYQlrUxO/SJtupDRXXilwX7hpqHKbz6h15jQbC+SplRB9ZVHMWjRUwTwfCOTQdpqBjV7T9W4dSI5BJ9zd4Y/bv7/fSVON/qQiZlPvjb3EoH1GNxHMy9H8w7XYOze603gWiiRtGPvpTdkb79+we8vFiK11dtNVybNINVN7E3yMum0KtaaTt0yF59C6IBo2EqSR0DtOBCfNGbYUymi4ZqDE7JGGTTEFRqAfVI8WUWDHD1YQ+0ugpUwij+/bjGF7jJTA89b3xLAeS8dEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kCU/IZ5umpYMWMTf3Rei+Yg2nOWvgccFS7FPOiOOzoI=;
 b=jglSHwmw3MC2I9gWa13Fogf7jTDiOCqjloAwHG6lwz1YJlUMUYI2FApkGYKvGKwp09i8l1LAWYNZcFOOqJV/+rfz6s4DNZ7oCILvCb7+qKLwKLW0PDc/ndny/5m3tzyhNgUh8on8+qkcKpaTVwIxY6SnUqei1u5NuIDz6NigewlG9uiEgy270S040OdjCchkxKcfQHfMN13PyR3e2uXw2CkAfyVNmbqoYfJklTUwj8cIl1pj7j2TD8I45Kl+ND95O7icMTIw05zShA64rex1cO+QXFaJzz+cu56avwMYwt4t150hT+STd+Hqc1HAk1ZBfDrUopzZmOEyKbOarRkjzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCU/IZ5umpYMWMTf3Rei+Yg2nOWvgccFS7FPOiOOzoI=;
 b=DyfWLqCvOhX2GKUcZfENO1oY1+Rp4xsTqSR3Y8f0kr/lzjuRF3ZW5pBK1okwdteSB3+7+GH6ZaiZZQdv0zFxqPwyhJgDC9cVGDQF02TKoQgVmWod1xw5bZmSg1yc4F/5ieU9C6ad5AvRrMLOJ6jlwAIy2fHOKfwjE1yrnLjntyA=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSAPR01MB2738.jpnprd01.prod.outlook.com (2603:1096:604:4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 06:23:39 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.019; Sat, 25 Sep 2021
 06:23:37 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
Subject: RE: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct
 ravb_hw_info
Thread-Topic: [RFC/PATCH 08/18] ravb: Add mii_rgmii_selection to struct
 ravb_hw_info
Thread-Index: AQHXsISIl1AnQ6pYVE2T9rLaXIqMK6uzmXAAgACvnGA=
Date:   Sat, 25 Sep 2021 06:23:37 +0000
Message-ID: <OS0PR01MB5922C9EDAE62B0750D84354A86A59@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-9-biju.das.jz@bp.renesas.com>
 <8b92e5f8-2f78-b64c-8356-1e43034ba622@omp.ru>
In-Reply-To: <8b92e5f8-2f78-b64c-8356-1e43034ba622@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23605b5e-3def-40cd-61af-08d97fed02bc
x-ms-traffictypediagnostic: OSAPR01MB2738:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB273862724BD796B895233D0186A59@OSAPR01MB2738.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 04fh6FVPwiPeDKBYRBZ8PIi+bCyoKg/xTTPVanPA9IOLN5JzJKIQ/srfwuPOg6czNTfSNrWVTe6p9Nw1Uj44tzIvEJd/qbUQJUE5oAc/P3zcuVZ0ApyObZuRLq2H91Quii0Yr/oDFd6fLNjrxFNn9WQDDF90bwRZrm7zw0oylycVatrbTswf0vgUNwwL+ssrKrxouEVS8Np3sUN7oxrFa5mvuFWnBTwnJFUIa7/z4xL5cfS49LwuKUIPa/dyqiCcs4+ya85x2vLdHW/C5Tfv4Ej37IjpRh2yOpF2sTn/pVkm+uXHSG3W3IidaXo1AkvkJM9J3T4C4xD5/V6pqD0u/bgIRkioR6r92/Ui8LkZmUR8dR38MITAH72oihiSNzqECg4y02hxdk83pCaniRED6QcTAcFqFm73AwWTNvspcZNPilw/fW9MkjqiU0bbQA8ujZC392XU+d7WO5O4JTNEkQD/leP7W/L8lJ6CwpQP/2/n7aC3F+pLA/wq2MQIWAQUX5kn4G0h6/qZSamqjZdAyVKxEElrITzSmP0QtKg/mzr+X/8qEJxkuFechL9MQp/kJiX8+1yGHvNOjtfauZmZcaJaFhU7ZQpyrZ0otdyoGcAk8awD3FDzZwAV5MHGK8cq+h0eWeG0xms1Q1LSbWAW6h6WHlhhCsQ6v0MFMX02P0PuqxTokC295LAuFuoByWMMS2IlYhIvIyvlVeVbpTgiIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(53546011)(26005)(508600001)(7696005)(66556008)(66946007)(107886003)(71200400001)(6506007)(83380400001)(52536014)(86362001)(2906002)(66476007)(64756008)(66446008)(9686003)(4326008)(38070700005)(8936002)(186003)(33656002)(54906003)(5660300002)(316002)(55016002)(38100700002)(110136005)(122000001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmRLQVhIcFgwOUlKOExIekJhNXlOT1hsemRNb0dUMXQwcG5pVU9GWU1RRGlM?=
 =?utf-8?B?ZnlUazRDZCtBZVlSRlNlalVjcTNWc3J2Qkt5U3pOalpXQXNJeHE0Vm4xai9E?=
 =?utf-8?B?cm5nUCt0QUk3ZjZrZllnNjdxUzFJdE1uSmxscFBTRU9EWGFNblNkTEIzVld1?=
 =?utf-8?B?ZnhDU2lRb09yS2l0QmlxRGQwRUJaZ1ZxUGVHU0IyQlRPR0p4WmgxbWxuWW1F?=
 =?utf-8?B?bUY1Y001Sm5jek1zRVAzK2NRaHZreGRRVXdmSUhZbUFnZEtCL21tSm9ZQ1V5?=
 =?utf-8?B?bVdqQ2JyT0l3OU5Sc1JUS3FjdWgwN2paSnptUGIzVlRyNnExRHFRcjBTOGdj?=
 =?utf-8?B?bGFKRjBHLzZVamExc21OMHk1TzRMK0U2L1VXREhmTEZON0ZrNldvNmg2Mm5L?=
 =?utf-8?B?alpaZU9CYW1ma2RyK2psS3hZYUxPRnhJL2tpajREdGdUSnZNcWQzbnFwTnFY?=
 =?utf-8?B?SU1SMUVhR3JaYXZNeGw5NGxzV1ZEdjUyQ24yVmpzYStaRDJ0eVQ3Q1dzWVpw?=
 =?utf-8?B?ZGhhbkdKVjRzeklZY1NkSUpVSW1HZUlQcnFhajhBVGFFNmpWK0lxblhBeGc1?=
 =?utf-8?B?ZlVuTHNTOUtTL3JlaDA0OFRiaHlIeDMxY1pSRjlGUkplVFlxcFo3Rkw0TGp1?=
 =?utf-8?B?ZkNrOERWYThwRDVtYnRtWllEM0hMRXNYZXhudFNwbFIxMmJHRGpqR2l5RDNy?=
 =?utf-8?B?SHY3WEk0akJZQlhwMjY3VHZpYjFQZmpWbC9OeldBOEhYbGZ2dTZTZGs1cG1M?=
 =?utf-8?B?ZFpqbEpha3gwQU9pRHRQVnVFVSswd3NCQXczdTd0SG9IemhlRW5xQlZGbmRh?=
 =?utf-8?B?eGlKMDF0SEVYdGkyNlhIU2lqaGh5S2I0OUtrL1lCSElSejJsWmZYdW13UGxQ?=
 =?utf-8?B?dDB0eHQ5aExXa0dQVytHNG5LWC9Hb3VTTTJrS3JqWmR2SUdNbDFlOE42Y3JP?=
 =?utf-8?B?VnZVVjdsQXg1L3g0OEU2L3NtSWZoY29nbGNVSjN6OTdaeHFjQ0xpdDJMajhY?=
 =?utf-8?B?OE5RNmZBOTBHZDV0bHZINE52aHBXY1pNNEhGRmpsdUxCZmdnTHcrTXhYdDc3?=
 =?utf-8?B?TUxybkczQk1Melg4T1ZHeEk4LzBCbGY5emE1UGVxZWE0N25JaU5PTHA2aVBU?=
 =?utf-8?B?SU0zY216UWxsWXhaNlg1Umx6YXhQUk1hbmNEVlFWd3NZYXBiZG9mWlVXZXB4?=
 =?utf-8?B?MStKRFRjckhjYTlVR2xacmViT0YzRVpVRkhBT29FV3JxMFB6dWp1dmFzY1Qw?=
 =?utf-8?B?SXNiTTIyN21Nd0NXRDZlM1VqTUpFSWpKSTM1QnFvVVQ3Y3NVNjU0dlRidHF2?=
 =?utf-8?B?ZmJ1NFA1SUNWM2VCdHhSNFhLRGhmbk4xZnpITER4ZlQzRDk3eU5KeGpadHhk?=
 =?utf-8?B?eHd5VCszdWFrUzFhUVliL0liMGNSVVJ0WE1wZ3pnbTMvTzF1ZFc0TGNheWt5?=
 =?utf-8?B?a3djUlV2d0UveEdKU0ZLNVhZQmhuZlVleHp6dHdIdjJMMytTRWhCbG5GQXRz?=
 =?utf-8?B?Qnk4VGFKTStZVC9FQlBGZ2c3dmc1S2RQSVRJYnJCWGhwL2pYanp6OCtwMkZB?=
 =?utf-8?B?elRRQk1ja0p5cVJmV2tVSmZ6ZFVzNStOMmRwaW5qNGtqMXltbjhoSk5ONE1z?=
 =?utf-8?B?dEJvMnEzNjB3UDNlcE90Z1VHbVMrTlpPczFvVFlJQnY3WDlhb0xpeTlhMnFq?=
 =?utf-8?B?TDlKTGVJNmRFYytweUMwY3Q1Qy84NUZxbE5vZWlmRnRabWl4cGJIbi9nMXZF?=
 =?utf-8?Q?JoiweczCi7LwQ/qwBo1rlSZL88hcSB+NirnJWkU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23605b5e-3def-40cd-61af-08d97fed02bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 06:23:37.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dAIDTMCsy1wJG55tLg4AdxjNNAnjlc7kh8hcvooQKiFey8tLM38whCZ320nOaWHrANQTQWJcXcvLcbRs8Gs3jLCiV3wLxQGg9smkNmSEUgc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2738
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAwOC8xOF0gcmF2YjogQWRkIG1paV9yZ21paV9zZWxlY3Rpb24gdG8gc3RydWN0
DQo+IHJhdmJfaHdfaW5mbw0KPiANCj4gT24gOS8yMy8yMSA1OjA4IFBNLCBCaWp1IERhcyB3cm90
ZToNCj4gDQo+ID4gRS1NQUMgb24gUlovRzJMIHN1cHBvcnRzIE1JSS9SR01JSSBzZWxlY3Rpb24u
IEFkZCBhDQo+ID4gbWlpX3JnbWlpX3NlbGVjdGlvbiBmZWF0dXJlIGJpdCB0byBzdHJ1Y3QgcmF2
Yl9od19pbmZvIHRvIHN1cHBvcnQgdGhpcw0KPiA+IGZvciBSWi9HMkwuDQo+ID4gQ3VycmVudGx5
IG9ubHkgc2VsZWN0aW5nIFJHTUlJIGlzIHN1cHBvcnRlZC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmggICAgICB8IDE3ICsrKysrKysrKysr
KysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMgfCAg
NiArKysrKysNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+ID4gaW5kZXggYmNlNDgwZmFk
YjkxLi5kZmFmMzEyMWRhNDQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
cmVuZXNhcy9yYXZiLmgNCj4gPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmIuaA0KPiBbLi4uXQ0KPiA+IEBAIC05NTEsNiArOTUzLDIwIEBAIGVudW0gUkFWQl9RVUVVRSB7
DQo+ID4gIAlSQVZCX05DLAkvKiBOZXR3b3JrIENvbnRyb2wgUXVldWUgKi8NCj4gPiAgfTsNCj4g
Pg0KPiA+ICtlbnVtIENYUjMxX0JJVCB7DQo+ID4gKwlDWFIzMV9TRUxfTElOSzAJPSAweDAwMDAw
MDAxLA0KPiA+ICsJQ1hSMzFfU0VMX0xJTksxCT0gMHgwMDAwMDAwOCwNCj4gPiArfTsNCj4gPiAr
DQo+ID4gK2VudW0gQ1hSMzVfQklUIHsNCj4gPiArCUNYUjM1X1NFTF9NT0RJTgk9IDB4MDAwMDAx
MDAsDQo+ID4gK307DQo+ID4gKw0KPiA+ICtlbnVtIENTUjBfQklUIHsNCj4gPiArCUNTUjBfVFBF
CT0gMHgwMDAwMDAxMCwNCj4gPiArCUNTUjBfUlBFCT0gMHgwMDAwMDAyMCwNCj4gPiArfTsNCj4g
DQo+ICAgIEkgZG9uJ3Qgc2VlIHRob3NlIHVzZWQ/IFdoYXQgaXMgQ1NSMD8NCg0KT0ssIFRoaXMg
aGFzIHRvIGJlIHBhcnQgb2YgbGF0ZXIgcGF0Y2ggZm9yIGVtYWNfaW5pdC4gQ1NSIGlzIGNoZWNr
c3VtIG9wZXJhdGluZyBtb2RlIHJlZ2lzdGVyIGluIFRPRS4NCg0KPiANCj4gWy4uLl0NCj4gPiBA
QCAtMTAwOCw2ICsxMDI0LDcgQEAgc3RydWN0IHJhdmJfaHdfaW5mbyB7DQo+ID4gIAl1bnNpZ25l
ZCBjY2NfZ2FjOjE7CQkvKiBBVkItRE1BQyBoYXMgZ1BUUCBzdXBwb3J0IGFjdGl2ZSBpbg0KPiBj
b25maWcgbW9kZSAqLw0KPiA+ICAJdW5zaWduZWQgbXVsdGlfdHNycToxOwkJLyogQVZCLURNQUMg
aGFzIE1VTFRJIFRTUlEgKi8NCj4gPiAgCXVuc2lnbmVkIG1hZ2ljX3BrdDoxOwkJLyogRS1NQUMg
c3VwcG9ydHMgbWFnaWMgcGFja2V0DQo+IGRldGVjdGlvbiAqLw0KPiA+ICsJdW5zaWduZWQgbWlp
X3JnbWlpX3NlbGVjdGlvbjoxOwkvKiBFLU1BQyBzdXBwb3J0cyBtaWkvcmdtaWkNCj4gc2VsZWN0
aW9uICovDQo+IA0KPiAgICBQZXJoYXBzIGp1c3QgJ21paV9yZ21paV9zZWwnPw0KT0suDQoNCj4g
DQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMv
cmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPiBpbmRleCA1MjkzNjRkOGY3ZmIuLjVkMTg2ODE1ODJiOSAxMDA2NDQNCj4gPiAtLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiBbLi4uXQ0KPiA+IEBAIC0x
MTczLDYgKzExNzQsMTAgQEAgc3RhdGljIGludCByYXZiX3BoeV9pbml0KHN0cnVjdCBuZXRfZGV2
aWNlICpuZGV2KQ0KPiA+ICAJCW5ldGRldl9pbmZvKG5kZXYsICJsaW1pdGVkIFBIWSB0byAxMDBN
Yml0L3NcbiIpOw0KPiA+ICAJfQ0KPiA+DQo+ID4gKwlpZiAoaW5mby0+bWlpX3JnbWlpX3NlbGVj
dGlvbiAmJg0KPiA+ICsJICAgIHByaXYtPnBoeV9pbnRlcmZhY2UgPT0gUEhZX0lOVEVSRkFDRV9N
T0RFX1JHTUlJX0lEKQ0KPiANCj4gICAgTm90IE1JST8NCg0KQ3VycmVudGx5IG9ubHkgUkdNSUkg
c3VwcG9ydGVkLCBzZWUgdGhlIGNvbW1pdCBtZXNzYWdlLg0KPiANCj4gPiArCQlyYXZiX3dyaXRl
KG5kZXYsIHJhdmJfcmVhZChuZGV2LCBDWFIzNSkgfCBDWFIzNV9TRUxfTU9ESU4sDQo+IENYUjM1
KTsNCj4gDQo+ICAgIFdlIGhhdmUgcmF2Yl9tbm9kaWZ5KCkgZm9yIHRoYXQuLi4NCj4gDQo+ID4g
Kw0KPiA+ICAJLyogMTBCQVNFLCBQYXVzZSBhbmQgQXN5bSBQYXVzZSBpcyBub3Qgc3VwcG9ydGVk
ICovDQo+ID4gIAlwaHlfcmVtb3ZlX2xpbmtfbW9kZShwaHlkZXYsIEVUSFRPT0xfTElOS19NT0RF
XzEwYmFzZVRfSGFsZl9CSVQpOw0KPiA+ICAJcGh5X3JlbW92ZV9saW5rX21vZGUocGh5ZGV2LCBF
VEhUT09MX0xJTktfTU9ERV8xMGJhc2VUX0Z1bGxfQklUKTsNCj4gPiBAQCAtMjEzMiw2ICsyMTM3
LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCByYXZiX2h3X2luZm8gcmdldGhfaHdfaW5mbyA9IHsN
Cj4gPiAgCS5hbGlnbmVkX3R4ID0gMSwNCj4gPiAgCS50eF9jb3VudGVycyA9IDEsDQo+ID4gIAku
bm9fZ3B0cCA9IDEsDQo+ID4gKwkubWlpX3JnbWlpX3NlbGVjdGlvbiA9IDEsDQo+IA0KPiAgICBJ
IGRvbid0IHNlZSB3aGVyZSB3ZSBoYW5kbGUgTUlJPw0KDQpTZWUgdGhlIGNvbW1pdCBtZXNzYWdl
LiAiQ3VycmVudGx5IG9ubHkgc2VsZWN0aW5nIFJHTUlJIGlzIHN1cHBvcnRlZC4iDQpXZSBoYXZl
IGEgcGxhbiB0byBzdXBwb3J0IHRoaXMgYXQgbGF0ZXIuDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4g
DQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
