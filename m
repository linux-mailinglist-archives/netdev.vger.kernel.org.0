Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7817E4165C3
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 21:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242855AbhIWTPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 15:15:06 -0400
Received: from mail-eopbgr1410125.outbound.protection.outlook.com ([40.107.141.125]:60672
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237009AbhIWTPF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 15:15:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MylH2eHrFGLNfRdSDpM7thbu40zN48/8V4MPTym7r01RxYLzultUKE2yudIdmLQwDJD47s4Jxt8r0VLbH/v1wejkqF8e+avUEsH/cRuJsl4DTUf+ArBF3RvS0AYPaR5b1hEH6yCr+I3Zob3jHlmPKl6gILA35Pn9eagtzXz7at26w0bp/RWEINEKbNDOy4C63i3Wb5SwPc3+XNpnr4FeQ86TS/OQmOBPqw4lVkyG5faVKPA36esUY4DKeFp2xNZOyG0Gv9z72qvYlbLlP9qYJCYYuAAiMnUIH0LIAUo2IBf+EHH4MwsUBqXXKaG9YVh6JO+p1Zx+0a8rKscXTfrBCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Cf3kNzL91Y3CmiMotIvtO+Ro4MopUO++YVQ1GAkhzeE=;
 b=VL1DglZ/iKjU2q2wYayMktdrOKaOGgpDXS7vA0b3inwgJ67gzpH3Rx2Xuis0M8VhfE2Zg7uisoCdtvE88A3+YPqIJmmg7SbMyrjjosp8Oy9V9ecqLkbsWfLuZmoCXtq5VfbpsC3ucUBp4XCVmoD8BxlCVqX2/jCq2rGTBpo9H8J0BOwl8qFbyyPsE5ePxmbDL5SJZs2vD+una2G2BUxFoWUdGE5PvYJYl8zGUzlvQebmo4pe25EmZBiR1qa9jt+OiGFafrYwKaPO4vOGOAbw7rAZO2eesWJepSVXaDnJF43u+c2Gl4mcpdpiNIm/9QbXEMWpPeiL7Ewj4z9LWvIVgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cf3kNzL91Y3CmiMotIvtO+Ro4MopUO++YVQ1GAkhzeE=;
 b=fvgHzRHf1CV5u3AbeD96mp+ZKi3eBUvAZFkKA+fYncMuHart3YkbYndtxJdrbkoc9DqwNtKFdeE0lcIX9el+Ap++KVatLiFef/VTuFZVuLfV6DhVtPnSXyuieUYpY2qDHerGT8r6UWW2kn+k6CH7/z4ey3CJf4Om8Uv9n+nhxLc=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5736.jpnprd01.prod.outlook.com (2603:1096:604:c7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Thu, 23 Sep
 2021 19:13:29 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::6532:19dd:dfa1:4097%9]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 19:13:28 +0000
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
Subject: RE: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Topic: [RFC/PATCH 05/18] ravb: Exclude gPTP feature support for RZ/G2L
Thread-Index: AQHXsISAOfY/2JLZEkuO1R4Mf2Gbvaux+WeAgAABF/A=
Date:   Thu, 23 Sep 2021 19:13:28 +0000
Message-ID: <OS0PR01MB5922F3EE90E79FDB0703BCEC86A39@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20210923140813.13541-1-biju.das.jz@bp.renesas.com>
 <20210923140813.13541-6-biju.das.jz@bp.renesas.com>
 <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
In-Reply-To: <2b4acd15-4b46-4f63-d9e7-ba1b86311def@omp.ru>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd7e59a3-bbd7-44a1-55a7-08d97ec639e3
x-ms-traffictypediagnostic: OS3PR01MB5736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB573687573F3C5E779B9CDFF786A39@OS3PR01MB5736.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xrv+93gAsViCsWAzn3chqy8/kYrFWUv1zDxev6+i6G5YIPVJ5qjbyCg9MFUHfpTKz44vxxwGFpBbyje2vPmC1E6AvuWHeskbkbdXY7qnE0WkRspfv8/Gk/RvHo90EZd/rlY4uo5wo+JIMaJXK5TVanoMi4h2T1aVtcSDWYXkz4OBdTv6dLzN9E7jHj2fYE5tuQT+ed5Nanv97crLAOXelcvlws3khtuIHsF9A/EDJAEOtGxMiAh3hC4+tKWkLLpf1IN8ez1ANVTYFDi1VjpSi9y5msK+nhcT/8zLS3WyiQiMTW+xJXoSz5FQ5ynvUMrbAMzYdtpdsOUNBzf2pnvItpruDD/AVWcJh1VUVKxEL0l5dGea3g+qyNqB3N0r7NdQ+crd5tMQopurNM6lBbjpvYVuhLhwOlTvAb18Ykc9xBjFFffjA7mriMRGVIZc5Cu/DKRKhiTaRui/+IA93ZVCiEp6jzhjy9RUAwBZzbID8BaQ8H+VPth7sxCQMU0oKY58ff+9W+BBlnX8I393vt0hBZgkmltooALFDntySSILrqroPB3QWXXZ8whA/O4jQ9ti4Cgp8RWMImQINB74o6Z7sJD9k/kTp7w1VqH6+LaU1myvOBZlvrLkvJOec+N67/yYtBu/2NM5FLPmvw7F28nXrjfWoybrCO/wjDVdDPoG0aVODye02mvq9yNgW2sLzvgY2cUBKuR1apaWSU3aipV9Fg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(53546011)(54906003)(5660300002)(55016002)(110136005)(66446008)(66476007)(66946007)(9686003)(66556008)(107886003)(64756008)(26005)(8676002)(76116006)(8936002)(186003)(316002)(2906002)(122000001)(71200400001)(52536014)(86362001)(7696005)(508600001)(33656002)(6506007)(38070700005)(38100700002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2pPVEVQRldHdUVGc1lNUTBZbE9KTmdSdGdzdEsyTjJkdlpqN0JnMTFOOW9p?=
 =?utf-8?B?ei9hMGZuVWdOdXRDNWhyZ2FRMFduNFlWbmEveTR3Zm12dm1zSEtlSUtSaTFM?=
 =?utf-8?B?T0FHWmNZaDVqVlpISHNDU1VyUWxwL1JkdDk2QytqUWwzZDNwc1Vqczk4SitO?=
 =?utf-8?B?T0hNVUtpcVJzRDNoL1YwdnlPU0Z0U0RYMklzbEgwZFo2YUJxOGw2MEJjdXo0?=
 =?utf-8?B?WWRWQkszZHJzalhPOU1XNER1c1poMFhBaXBwQWFqb1F1MkF1WVUrbTBDUXVz?=
 =?utf-8?B?Y0RaRFNEOHRHa1hsYUxUQkM1QnNxRXVKdUVDQWl1MURYVXI0RmlOUjdrL055?=
 =?utf-8?B?ZFZ4Q2k2TkhzZEVLakt2aEtLVjZ1TVgvYzFqbHhWNnhKMU80NldJMm9mWnNG?=
 =?utf-8?B?YkkxbFYwc203c3dhN2UzOTlTUjVtc08zL0kvdDR6dkVNZlk1SVduaHJWNXJ1?=
 =?utf-8?B?dWtnaWcxdWJSa1RWL1FxMDE4VlM0eGJPdEhIYm9Dek15b0JNOVpBN000Q2cr?=
 =?utf-8?B?Rjkzelh5OWtKOE5CK1IrcjlMMXRCbXEyaldGWTlCSlVXbzF6THpUQkxRNVFx?=
 =?utf-8?B?S3pFWitFZjFFVjVQTk5VR2E4aGl3dWwyZ3I3dUJFQ3A2WEZ4c3c1MS9aZTNK?=
 =?utf-8?B?L01LRnN1Z0lqVmdCc3V4dldKZytrNDk1djloNkltRG1QaG5vdURCdlBiOGg4?=
 =?utf-8?B?Q0lJQjJPSnErZXowWGp6Snp5UTU3UFd6Nm9VaThQaGtDSmd1Z2toclZsaEpr?=
 =?utf-8?B?VCtDdEQrVXUvUlhYZHBLMCtpV09LZW5NeGJjTE9COXRjNTcvV0VvVDRuNVh1?=
 =?utf-8?B?Mm9uclBRRHVzQmNLRGpWNUFZeStGUjNwdm5QR0s2OXc2Vm1mQS9HQktCbmUr?=
 =?utf-8?B?WEdJVVE5R0RQNjNQelp3YWw4RXN5Z2dCdjh6bDl4Y3dJVnk3aTEzcnRSWHJX?=
 =?utf-8?B?R3k4ejloa3hJQnREdzl5M3VMY2oxcSs0MzRsSHB1amJKM2doSUV4dlZsdEoz?=
 =?utf-8?B?NG1VOU16SDVYa09EN04rMjFtWDBaaGJNaVZuVEJobUFYM1gwYkZvcDEzQ0dG?=
 =?utf-8?B?cWJJZFh3aG9McmorUWFWWHk2RnZYeVlHQjYzdGtKMXk0NG1FNHVlc2VmaG9j?=
 =?utf-8?B?K2dzS296ZG1EUVdZWndLdU5XbFNHakViSEcyLzc4TTVGRWhaTmZQSWlYcnBa?=
 =?utf-8?B?L3d6K2ZwZm5sZjJyK04zWnZPMDNUWFFRREFWR29GWlcvV1JzaWh1RGtoVzhY?=
 =?utf-8?B?a015K2UyaVltZG15K1RHVnlhN3JaWkFoS1JVZzMwVTlEOUNhWDRZV2w1bElj?=
 =?utf-8?B?dTd6ZG5ueENYajFoVG0rYzVpL2J4KzNZdHdZY2haQU1FWDFvV3h4cVdBQkZk?=
 =?utf-8?B?NVhoOVJNNWY3K1RXd3ZocHh1ZzMrcHIvQmxmQ1ZnckdJZXFjeXl1M2h4bVEw?=
 =?utf-8?B?cUhCdHhjbFBQOU9DbEFvaDRWQWFMcGxVODFUdzd5Zk9XUmRLVWVubjlHdklH?=
 =?utf-8?B?K0pkb3U2SW9mQlJNbWZMMnRnWVV0SnFiNlFKUFZPdWUvRXl0WE5YeFBQNHh4?=
 =?utf-8?B?ckYwR3JmelgwUW85ZDQvS0l3U1hwSDI3SlBuOW9vK2p0c0VKTHVhcVhCdHhZ?=
 =?utf-8?B?dFI5MDhrbVVHMXRQTXJhdGZKY1IyVnF1Wld6VlI0S1Bub2RoeGQvY284NEIv?=
 =?utf-8?B?VUF6T2VpbzUyYVhYL1RTVzV3TUtGbXFDKzF2RzJNZEpYejNqWkVVZTkvNmdF?=
 =?utf-8?Q?KvRx7Oa0s6CqHb198ZgHdL75yrbljbk10O27qKT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7e59a3-bbd7-44a1-55a7-08d97ec639e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2021 19:13:28.8006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7C2ixxzqR01YBQOgzLMcFUByktEUo5SFB5/68oey7kWHfFrafwzjzxUcV9LONaccv8+QhvzMDYbAxNxjEwe/fmKCUReRCTSE05Vb2H0MsWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5736
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCj4gLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4N
Cj4gU2VudDogMjMgU2VwdGVtYmVyIDIwMjEgMjA6MDANCj4gVG86IEJpanUgRGFzIDxiaWp1LmRh
cy5qekBicC5yZW5lc2FzLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IENjOiBQcmFiaGFrYXIg
TWFoYWRldiBMYWQgPHByYWJoYWthci5tYWhhZGV2LWxhZC5yakBicC5yZW5lc2FzLmNvbT47DQo+
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFNlcmdlaSBTaHR5bHlvdiA8c2VyZ2VpLnNo
dHlseW92QGdtYWlsLmNvbT47DQo+IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnQrcmVuZXNhc0Bn
bGlkZXIuYmU+OyBBZGFtIEZvcmQNCj4gPGFmb3JkMTczQGdtYWlsLmNvbT47IFlvc2hpaGlybyBT
aGltb2RhDQo+IDx5b3NoaWhpcm8uc2hpbW9kYS51aEByZW5lc2FzLmNvbT47IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LXJlbmVzYXMtDQo+IHNvY0B2Z2VyLmtlcm5lbC5vcmc7IENocmlz
IFBhdGVyc29uIDxDaHJpcy5QYXRlcnNvbjJAcmVuZXNhcy5jb20+OyBCaWp1DQo+IERhcyA8Ymlq
dS5kYXNAYnAucmVuZXNhcy5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUkZDL1BBVENIIDA1LzE4XSBy
YXZiOiBFeGNsdWRlIGdQVFAgZmVhdHVyZSBzdXBwb3J0IGZvcg0KPiBSWi9HMkwNCj4gDQo+IE9u
IDkvMjMvMjEgNTowOCBQTSwgQmlqdSBEYXMgd3JvdGU6DQo+IA0KPiA+IFItQ2FyIHN1cHBvcnRz
IGdQVFAgZmVhdHVyZSB3aGVyZWFzIFJaL0cyTCBkb2VzIG5vdCBzdXBwb3J0IGl0Lg0KPiA+IFRo
aXMgcGF0Y2ggZXhjbHVkZXMgZ3RwIGZlYXR1cmUgc3VwcG9ydCBmb3IgUlovRzJMIGJ5IGVuYWJs
aW5nIG5vX2dwdHANCj4gPiBmZWF0dXJlIGJpdC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYyB8IDQ2DQo+ID4gKysrKysrKysrKysr
KystLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyOCBpbnNlcnRpb25zKCspLCAxOCBk
ZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3Jh
dmJfbWFpbi5jDQo+ID4gaW5kZXggZDM4ZmMzM2E4ZTkzLi44NjYzZDgzNTA3YTAgMTAwNjQ0DQo+
ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWluLmMNCj4gWy4uLl0NCj4g
PiBAQCAtOTUzLDcgKzk1NCw3IEBAIHN0YXRpYyBpcnFyZXR1cm5fdCByYXZiX2ludGVycnVwdChp
bnQgaXJxLCB2b2lkDQo+ICpkZXZfaWQpDQo+ID4gIAl9DQo+ID4NCj4gPiAgCS8qIGdQVFAgaW50
ZXJydXB0IHN0YXR1cyBzdW1tYXJ5ICovDQo+ID4gLQlpZiAoaXNzICYgSVNTX0NHSVMpIHsNCj4g
DQo+ICAgIElzbid0IHRoaXMgYml0IGFsd2F5cyAwIG9uIFJaL0cyTD8NCg0KVGhpcyBDR0lNIGJp
dChCSVQxMykgd2hpY2ggaXMgcHJlc2VudCBvbiBSLUNhciBHZW4zIGlzIG5vdCBwcmVzZW50IGlu
IFJaL0cyTC4gQXMgcGVyIHRoZSBIVyBtYW51YWwNCkJJVDEzIGlzIHJlc2VydmVkIGJpdCBhbmQg
cmVhZCBpcyBhbHdheXMgMC4NCg0KPiANCj4gPiArCWlmICghaW5mby0+bm9fZ3B0cCAmJiAoaXNz
ICYgSVNTX0NHSVMpKSB7DQo+ID4gIAkJcmF2Yl9wdHBfaW50ZXJydXB0KG5kZXYpOw0KPiA+ICAJ
CXJlc3VsdCA9IElSUV9IQU5ETEVEOw0KPiA+ICAJfQ0KPiA+IEBAIC0xMzc4LDYgKzEzNzksNyBA
QCBzdGF0aWMgaW50IHJhdmJfZ2V0X3RzX2luZm8oc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYs
DQo+ID4gIAkJCSAgICBzdHJ1Y3QgZXRodG9vbF90c19pbmZvICppbmZvKQ0KPiA+ICB7DQo+ID4g
IAlzdHJ1Y3QgcmF2Yl9wcml2YXRlICpwcml2ID0gbmV0ZGV2X3ByaXYobmRldik7DQo+ID4gKwlj
b25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvICpod19pbmZvID0gcHJpdi0+aW5mbzsNCj4gPg0KPiA+
ICAJaW5mby0+c29fdGltZXN0YW1waW5nID0NCj4gPiAgCQlTT0ZfVElNRVNUQU1QSU5HX1RYX1NP
RlRXQVJFIHwNCj4gPiBAQCAtMTM5MSw3ICsxMzkzLDggQEAgc3RhdGljIGludCByYXZiX2dldF90
c19pbmZvKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZGV2LA0KPiA+ICAJCSgxIDw8IEhXVFNUQU1Q
X0ZJTFRFUl9OT05FKSB8DQo+ID4gIAkJKDEgPDwgSFdUU1RBTVBfRklMVEVSX1BUUF9WMl9MMl9F
VkVOVCkgfA0KPiA+ICAJCSgxIDw8IEhXVFNUQU1QX0ZJTFRFUl9BTEwpOw0KPiA+IC0JaW5mby0+
cGhjX2luZGV4ID0gcHRwX2Nsb2NrX2luZGV4KHByaXYtPnB0cC5jbG9jayk7DQo+ID4gKwlpZiAo
IWh3X2luZm8tPm5vX2dwdHApDQo+ID4gKwkJaW5mby0+cGhjX2luZGV4ID0gcHRwX2Nsb2NrX2lu
ZGV4KHByaXYtPnB0cC5jbG9jayk7DQo+ID4NCj4gPiAgCXJldHVybiAwOw0KPiA+ICB9DQo+ID4g
QEAgLTIxMTYsNiArMjExOSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcmF2Yl9od19pbmZvIHJn
ZXRoX2h3X2luZm8gPSB7DQo+ID4gIAkuZW1hY19pbml0ID0gcmF2Yl9yZ2V0aF9lbWFjX2luaXQs
DQo+ID4gIAkuYWxpZ25lZF90eCA9IDEsDQo+ID4gIAkudHhfY291bnRlcnMgPSAxLA0KPiA+ICsJ
Lm5vX2dwdHAgPSAxLA0KPiANCj4gICAgTWhtLCBJIGRlZmluaXRlbHkgZG9uJ3QgbGlrZSB0aGUg
d2F5IHlvdSAiZXh0ZW5kIiB0aGUgR2JFdGhlcm5ldCBpbmZvDQo+IHN0cnVjdHVyZS4gQWxsIHRo
ZSBhcHBsaWNhYmxlIGZsYWdzIHNob3VsZCBiZSBzZXQgaW4gdGhlIGxhc3QgcGF0Y2ggb2YgdGhl
DQo+IHNlcmllcywgbm90IGFtaWRzdCBvZiBpdC4NCg0KQWNjb3JkaW5nIHRvIG1lLCBJdCBpcyBj
bGVhcmVyIHdpdGggc21hbGxlciBwYXRjaGVzIGxpa2UsIHdoYXQgd2UgaGF2ZSBkb25lIHdpdGgg
cHJldmlvdXMgMiBwYXRjaCBzZXRzIGZvciBmYWN0b3Jpc2F0aW9uLg0KUGxlYXNlIGNvcnJlY3Qg
bWUsIGlmIGFueSBvbmUgaGF2ZSBkaWZmZXJlbnQgb3Bpbmlvbi4NCg0KUmVnYXJkcywNCkJpanUN
Cg0KPiANCj4gWy4uLl0NCj4gDQo+IE1CUiwgU2VyZ2V5DQo=
