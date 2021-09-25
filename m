Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C543418009
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 08:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343748AbhIYGki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 02:40:38 -0400
Received: from mail-eopbgr1400101.outbound.protection.outlook.com ([40.107.140.101]:23104
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231635AbhIYGke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 02:40:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n24Q7dEvrD5uH+q8sBQPTKSeuaQ0uLHL3N61MFVgbnenitYgGV5qSsrjPkrosYAjMYn2mfC7V2M3jaYJiTQ0MusfL+f7MVaocgw3X7eKkvsNnFIknqIhSncPSgljSy2jL9QZMGTHIH1fZhAiJK16NpD5wJAwFsH9z3+48ZzDJyhBnX6goy1nUPMXbiIk0jArSaEo4ZVu2FuNQrCCbsDHq5tBFGCvoNTLd//nu33ips80VQ1q/ig5rceepN+hI7D3S8wymH/SrpjqxtL6obzChy5jPmpVEV4G8d5L7qNrhKJSWBPPBXGesTFRRJ22ogtSNwU+d5V9vnum93DUx+lhjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bRt3B2Jrflfla1ZIIcXr16bOofaBVT18s5NE8aFsEbo=;
 b=N8Zow+8+AMuY33w4zutFXUlrCDNhks74QMDNRO856K9iSEiEjqDjc7OjY6F4DXXIEnbCSiNMj5XIiipzakZ/h8y5Q4Tu/iNCMeJ1Wx4bq913Izbo7i2i3O89BXoBgd9vpwzDA4yU33JKJVF2/cBNLwa3cOFfS/4haoKDEQJwTzSnmxf7Ks2j9ehjT7Fey0RJoVba5ETrCZNd0RFpxzZqo3XBBXJWzlqlB5Nidc8JYf2OuXrOwstXuokoRTkoTVXmZxJrnrtZ7Lsxd6oEGp+59QVhQlXGpe/OMsUTHSso7RIX6C0MmbXvno6L4WmgU6exf9oOooroJMqp7fOdF/RY5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bRt3B2Jrflfla1ZIIcXr16bOofaBVT18s5NE8aFsEbo=;
 b=ZhQV3ptFzpyUJOEfpgwhhPQJXOX2wkQJ77GLDC6bNOooC3K95DhEeFTVqrK0mD7fhAy2twAyD660jJPp6/n1XZNJmwPpD0G63l5yNjcCF79rGxTJH3yWkzO5gukGyBLKwTldqNGqp+1W+4Q8RkDwcBDbB0mj4RdGOjhIDQ/UlmQ=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OSBPR01MB2519.jpnprd01.prod.outlook.com (2603:1096:604:22::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.18; Sat, 25 Sep
 2021 06:38:58 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.019; Sat, 25 Sep 2021
 06:38:58 +0000
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
Subject: RE: [RFC/PATCH 10/18] ravb: Initialize GbEthernet E-MAC
Thread-Topic: [RFC/PATCH 10/18] ravb: Initialize GbEthernet E-MAC
Thread-Index: AQHXsISLHhBSw3d5oka3dzUvuO7+/auzqNSAgACl1pA=
Date:   Sat, 25 Sep 2021 06:38:58 +0000
Message-ID: <OS0PR01MB5922A7A37579E4FC91ED0CC886A59@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-11-biju.das.jz@bp.renesas.com>
 <98225e6e-54e2-f3fe-d2df-50f173ff2fd8@omp.ru>
In-Reply-To: <98225e6e-54e2-f3fe-d2df-50f173ff2fd8@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 460bacf5-e18c-42aa-35d3-08d97fef2760
x-ms-traffictypediagnostic: OSBPR01MB2519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB251975399FA41E12E2185EFB86A59@OSBPR01MB2519.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mmkBkRBj5x7VIXbV3WUr649w0xK8X93GELB40A95Y/9YtAADqntwDzGJlZ24sttOPhSdxnDX0gn9xPrj5lfFPWo7otA0uRr6JOohv3OqjafbSLFHgRbckM2YVExkGflPWI/o6FEKAzsXCu+XPVyIqFvCu3Lw5d39Ib1m/8Jma/zXnfOjcKsau9S+uMSJ99HupaEDS9Q0k7NePu92Dke/hd5ut5W0PyfIm9HENIRZS8XFlFhn0b2C/RLLKbiiC3Q64cyJIBmhTgoA8LLAIdHSGOq9A6bJ12gvYJG9IZmKOrXTe0bEnsF/wqLdUtwzVbNVT7z7thE8XGNNSiY00fzCz1mrA0d/Z4qhs5f3RGNfKHt5mTm5CFI4e0MZCOTIzNUmBENeGsp9apIpL51p9iHw8MwlTvO7fVjfc1hBVRs+75H9K/Ld3pSMUZpjejrtZ6LsD9IyI1HjFnx/zX/YaR4d0iN9zh5oThZ6zu7HHkXCslTxB4K8l+TOYCNf+hbECNSuxqXGv6zdT7hsIQvW4MEMmghkFe5KE/+0RKATKHEEQ0Ojt7ZePXLUtSnCpdO2evGqHiMEsFtyIemu/Gf1rg+cCcs8s3aYzRpd2In0eKa1IiM5RkgqpemFmwCFp656aMx2u2lvdXQbpVfwj7/W6JSGB7UJQb3q2pDq3KfMriMJaTg4qnaIqvhKjS2BXeWjQgLrRA1CgCjkTW/rV0GcgEh1fA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(2906002)(316002)(38070700005)(4326008)(122000001)(55016002)(9686003)(54906003)(508600001)(38100700002)(110136005)(53546011)(83380400001)(107886003)(7696005)(52536014)(76116006)(71200400001)(33656002)(26005)(86362001)(5660300002)(8676002)(186003)(6506007)(8936002)(64756008)(66476007)(66446008)(66556008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MENvVTliR1pzRkpQTnRMbWxLMEx2Y2VUYVF2S2dydkVmOUVVTEE2NlB4WDl5?=
 =?utf-8?B?aVJBOG5wTGl2U1dCQUJIV2hpZUlmeUoyZmtHQ3FhY1BPNTI1M1EzbE5sVklY?=
 =?utf-8?B?ZU12QWR1d2ZRMFJ3N2g3MEhCTmVOZEFNeTcyTU1GRy9WKzBvT05NdjRVdWg0?=
 =?utf-8?B?NG1aQVpEUEpDMWNjNXIxNGNMeWl0cE4zekJFNXRoaHlXTTNVcU85L0RadG1x?=
 =?utf-8?B?UW5nak1hRUxFNDNieDArMGFadm9sQ2REMmhHdFhRNUFDVWJQWGdKRDUyNHdu?=
 =?utf-8?B?UmxVZWp3U1V3MFdhd0ZhMG1QdUdGZDdqNHJkcDE1QXczZXFzQlQrMmNHY2x1?=
 =?utf-8?B?WUg4ZjRzb2hiTDFweGliSko4dkFRanErS0FwQTRIMnJwbnNLd1lYUTlzQ0dn?=
 =?utf-8?B?a1ByN3BxeXVaaTMvQkpxZzZSUWNzWmNpUDFoRTRVQTQvZ1BiOFRseFNMaTNR?=
 =?utf-8?B?S3MwVi8ySnpVMENNc1lWU0pSUk9ucTRhejNZMDJsYXlwNmhaRkYxd3JvSWlZ?=
 =?utf-8?B?V3RaNENpdVlWM2Q4ejRpQzByNTJEN0lYcjMzNERVS0pzeVV0M215eWlzR2V4?=
 =?utf-8?B?M05VOFVRSVE1YnBUQ3VwR1J4SEdPYUpLa1Z3WGtzVzIyTXZ5RU1JNnVuZEtS?=
 =?utf-8?B?cGh1Ky9OWmp4eGdCL0pWTVF0M1YvakZObEFFOW5sTGxpWllSR1ZDTWlkbnBM?=
 =?utf-8?B?UXQ4M0cxbWc2czI4YXRCdjVyTndWekF6SjE3V3Z2ZU5ZL0F5SjlQYk93dVM2?=
 =?utf-8?B?L2g2a0lLem1rMHExQXRabmRVQ3V3S1p5anhlanY1eFVSd3lNdExhWnVoT0Nj?=
 =?utf-8?B?d2pxSnVvVDUyMW1TWGNxam5hNm8yQ0lnbkFFU2NjSmFTbC94RG1LelpPblk0?=
 =?utf-8?B?RHkxS0RENWFKNWJtV1NFSEt3VFhFckN5ek94THc2d01TWHpRKzJLTERmNEwr?=
 =?utf-8?B?VllIdjl4TUJaU0VIbmYyMXI1ajdMbVBQaGdHZERDSW9YTTFrNVhZc3Q2N1kr?=
 =?utf-8?B?MkRFOGpyUVVqK0RBemsyQk00dFQ0cFl1eFozUWZxc2xSUlpFRXhkY2ZWcHBS?=
 =?utf-8?B?L3RvdkQyTm02UWdFVVpkckRrU0pnb2JkdnVVVkdWaVlvOWJuRHZzM05iR3F5?=
 =?utf-8?B?eG9haVdadzhRSDEvbUVLTWh3NjhSVEphMHUwMmt5Z2d6cGQwK0pmbVh2bFhV?=
 =?utf-8?B?MmwxTkRhTW0xamJUTzR5YlVPZ1RaWGRldGRwMzVkZ2lwWTY2TFJXQ3ZjV29X?=
 =?utf-8?B?YXRrZ3hldW5KVFZJOStLdm5XQ2I2anJTaTJkVzVQWnN1SHZ1V2NLUEpMbkZI?=
 =?utf-8?B?dWIyM3EyWEpSblcyUTNKVTZTWVl3b2Zya3U5ZXNyRVpUU2NVaHBjMFJ0Q1l0?=
 =?utf-8?B?d3ZKRHk2NUIvRTNEV0QyUThzYzFlMUtHVS92NXRwdFVieWx1MTR5MlIyNHM2?=
 =?utf-8?B?cGhmV2FGMHlmYjhSMVh2U1FUbldEZ2x3dThINmtLWjJraWNiK1NvV3BKenBR?=
 =?utf-8?B?UEZMQU5lNjIwOHpETDRNNmNrSEZGTUtNYmFneWdickdDT1c0ZWd3NittVUph?=
 =?utf-8?B?Y2c5U2ZObklqWXpTbllyK1loMnMyaGFSZWZJUDhCcXJpT2JRaWRGSUFHam9C?=
 =?utf-8?B?TmJEWTJtOCtBOGxGdTdFb01OeEVmcmRhOVdiK3M5WHF3QU1QSW43d0ZrWW0y?=
 =?utf-8?B?WnoyRGFGYXFsTVJkNEI3Rk9QdnhZaGhvUUhucVhWZzN3cElHRlh3VEd2a043?=
 =?utf-8?Q?KVih9PYggQZlvGU4cF2YiK4mIUfd2tvuLOUJcfm?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460bacf5-e18c-42aa-35d3-08d97fef2760
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 06:38:58.2610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8uv/w3mDYaO4AHfTjVN6uHpnnPaZ1qWcGx4QAjL7JIqkhM2SJFLhgOC8DhPBFFlgsUqkq4miJnMNb7ExMUBAL1USqnU2BjwqwofUIB7jWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2519
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4NCg0KPiBTdWJqZWN0OiBSZTog
W1JGQy9QQVRDSCAxMC8xOF0gcmF2YjogSW5pdGlhbGl6ZSBHYkV0aGVybmV0IEUtTUFDDQo+IA0K
PiBPbiA5LzIzLzIxIDU6MDggUE0sIEJpanUgRGFzIHdyb3RlOg0KPiANCj4gPiBJbml0aWFsaXpl
IEdiRXRoZXJuZXQgRS1NQUMgZm91bmQgb24gUlovRzJMIFNvQy4NCj4gPiBUaGlzIHBhdGNoIGFs
c28gcmVuYW1lcyByYXZiX3NldF9yYXRlIHRvIHJhdmJfc2V0X3JhdGVfcmNhciBhbmQNCj4gPiBy
YXZiX3JjYXJfZW1hY19pbml0IHRvIHJhdmJfZW1hY19pbml0X3JjYXIgdG8gYmUgY29uc2lzdGVu
dCB3aXRoIHRoZQ0KPiA+IG5hbWluZyBjb252ZW50aW9uIHVzZWQgaW4gc2hfZXRoIGRyaXZlci4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgg
ICAgICB8IDE1ICsrKystLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJf
bWFpbi5jIHwgNjQNCj4gPiArKysrKysrKysrKysrKysrKysrLS0tLS0NCj4gPiAgMiBmaWxlcyBj
aGFuZ2VkLCA2MiBpbnNlcnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmIuaA0KPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiLmgNCj4gPiBpbmRleCA3ZjY4ZjliODM0OWMuLjc1
MzJjYjUxZDdiOCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2Fz
L3JhdmIuaA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yi5oDQo+
ID4gQEAgLTIwNCw2ICsyMDQsNyBAQCBlbnVtIHJhdmJfcmVnIHsNCj4gPiAgCVRMRlJDUgk9IDB4
MDc1OCwNCj4gPiAgCVJGQ1IJPSAweDA3NjAsDQo+ID4gIAlNQUZDUgk9IDB4MDc3OCwNCj4gPiAr
CUNTUjAgICAgID0gMHgwODAwLAkvKiBEb2N1bWVudGVkIGZvciBSWi9HMkwgb25seSAqLw0KPiAN
Cj4gICAgQWgsIHRoZSBDU1IwIGJpdCAqZW51bSogYmVsb25ncyBoZXJlISA6LSkNCg0KWWVzLCB3
aWxsIG1vdmUgZW51bSBiaXRzIGZyb20gcHJldmlvdXMgcGF0Y2gNCg0KPiANCj4gWy4uLl0NCj4g
PiBAQCAtODI3LDYgKzgyOSw3IEBAIGVudW0gRUNTUl9CSVQgew0KPiA+ICAJRUNTUl9NUEQJPSAw
eDAwMDAwMDAyLA0KPiA+ICAJRUNTUl9MQ0hORwk9IDB4MDAwMDAwMDQsDQo+ID4gIAlFQ1NSX1BI
WUkJPSAweDAwMDAwMDA4LA0KPiA+ICsJRUNTUl9QRlJJCT0gMHgwMDAwMDAxMCwNCj4gDQo+ICAg
IEl0J3Mgbm90IGRvY3VtZW50ZWQgb24gZ2VuMiwgcGVyaGFwcyBpdCBqdXN0IGRvZXNuJ3QgZXhp
c3QgdGhlcmUuLi4NCj4gDQo+IFsuLi5dDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Jl
bmVzYXMvcmF2Yl9tYWluLmMNCj4gPiBpbmRleCAwNGJmZjQ0Yjc2NjAuLjdmMDZhZGJkMDBlMSAx
MDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfbWFpbi5j
DQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiBb
Li4uXQ0KPiA+IEBAIC00NDcsMTIgKzQ1OSwzOCBAQCBzdGF0aWMgaW50IHJhdmJfcmluZ19pbml0
KHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2LA0KPiBpbnQgcSkNCj4gPiAgCXJldHVybiAtRU5PTUVN
Ow0KPiA+ICB9DQo+ID4NCj4gPiAtc3RhdGljIHZvaWQgcmF2Yl9yZ2V0aF9lbWFjX2luaXQoc3Ry
dWN0IG5ldF9kZXZpY2UgKm5kZXYpDQo+ID4gK3N0YXRpYyB2b2lkIHJhdmJfZW1hY19pbml0X3Jn
ZXRoKHN0cnVjdCBuZXRfZGV2aWNlICpuZGV2KQ0KPiA+ICB7DQo+ID4gLQkvKiBQbGFjZSBob2xk
ZXIgKi8NCj4gPiArCXN0cnVjdCByYXZiX3ByaXZhdGUgKnByaXYgPSBuZXRkZXZfcHJpdihuZGV2
KTsNCj4gPiArDQo+ID4gKwkvKiBSZWNlaXZlIGZyYW1lIGxpbWl0IHNldCByZWdpc3RlciAqLw0K
PiA+ICsJcmF2Yl93cml0ZShuZGV2LCBSR0VUSF9SWF9CVUZGX01BWCArIEVUSF9GQ1NfTEVOLCBS
RkxSKTsNCj4gPiArDQo+ID4gKwkvKiBQQVVTRSBwcm9oaWJpdGlvbiAqLw0KPiA+ICsJcmF2Yl93
cml0ZShuZGV2LCBFQ01SX1pQRiB8ICgocHJpdi0+ZHVwbGV4ID4gMCkgPyBFQ01SX0RNIDogMCkg
fA0KPiA+ICsJCQkgRUNNUl9URSB8IEVDTVJfUkUgfCBFQ01SX1JDUFQgfA0KPiA+ICsJCQkgRUNN
Ul9UWEYgfCBFQ01SX1JYRiB8IEVDTVJfUFJNLCBFQ01SKTsNCj4gPiArDQo+ID4gKwlyYXZiX3Nl
dF9yYXRlX3JnZXRoKG5kZXYpOw0KPiA+ICsNCj4gPiArCS8qIFNldCBNQUMgYWRkcmVzcyAqLw0K
PiA+ICsJcmF2Yl93cml0ZShuZGV2LA0KPiA+ICsJCSAgIChuZGV2LT5kZXZfYWRkclswXSA8PCAy
NCkgfCAobmRldi0+ZGV2X2FkZHJbMV0gPDwgMTYpIHwNCj4gPiArCQkgICAobmRldi0+ZGV2X2Fk
ZHJbMl0gPDwgOCkgIHwgKG5kZXYtPmRldl9hZGRyWzNdKSwgTUFIUik7DQo+ID4gKwlyYXZiX3dy
aXRlKG5kZXYsIChuZGV2LT5kZXZfYWRkcls0XSA8PCA4KSAgfCAobmRldi0+ZGV2X2FkZHJbNV0p
LA0KPiA+ICtNQUxSKTsNCj4gPiArDQo+ID4gKwkvKiBFLU1BQyBzdGF0dXMgcmVnaXN0ZXIgY2xl
YXIgKi8NCj4gPiArCXJhdmJfd3JpdGUobmRldiwgRUNTUl9JQ0QgfCBFQ1NSX0xDSE5HIHwgRUNT
Ul9QRlJJLCBFQ1NSKTsNCj4gPiArCXJhdmJfd3JpdGUobmRldiwgQ1NSMF9UUEUgfCBDU1IwX1JQ
RSwgQ1NSMCk7DQo+ID4gKw0KPiA+ICsJLyogRS1NQUMgaW50ZXJydXB0IGVuYWJsZSByZWdpc3Rl
ciAqLw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCBFQ1NJUFJfSUNESVAsIEVDU0lQUik7DQo+ID4g
Kw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCByYXZiX3JlYWQobmRldiwgQ1hSMzEpICYgfkNYUjMx
X1NFTF9MSU5LMSwgQ1hSMzEpOw0KPiA+ICsJcmF2Yl93cml0ZShuZGV2LCByYXZiX3JlYWQobmRl
diwgQ1hSMzEpIHwgQ1hSMzFfU0VMX0xJTkswLCBDWFIzMSk7DQo+IA0KPiAgICBXZSBoYXZlIHJh
dmJfbW9kaWZ5KCkgZm9yIHRoYXQsIGl0J2xsIGhlbHAgdG8gYXZvaWQgdGhlIGRvdWJsZQ0KPiBy
ZWFkL3dyaXRlLi4uDQoNCk9LDQoNClJlZ2FyZHMsDQpCaWp1DQoNCj4gDQo+IFsuLi5dDQo+IA0K
PiBNQlIsIFNlcmdleQ0K
