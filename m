Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2818378233
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhEJKdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:33:11 -0400
Received: from mail-eopbgr1410127.outbound.protection.outlook.com ([40.107.141.127]:62368
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231420AbhEJKbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 06:31:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1rOvcpcEnmGW2ad62PJsL90r8gs0d9A90V1QIQz5/vjKJjhmexUgGoMQnqxPCaO4V9QjwMTgnrHAEV/Yy/gpl8YhPGZVwpC3I9PXNAau+e0+W0xRM12rYronshZG2eQeyAHCPv2li4LkJEsNWZL3hvRaKbMPmXnZyEG98RaktrQ+ll7NjzP3eCKU7bpSajYHyY4HZ1JKj/PRLBFzpkGPBbaf5cbA1b3Q1oT2ez3szEcVrjMbWgKXRh5ccq+u5YNgfHTr9ifC511jpaJYlQ/rbESEHCgAKvOLXyvTBQ13Zgf0xHdpN0d6klNs+OUjL8XU+DnE7SftTMZOpVjN78Zeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I5GfY0sCOvOJMipGowcFtEj2TvkluOWrnoTdgVPguU=;
 b=T1IgaqSqgQ+bLbEuN8IdjNLNj1EbxsvzbHEGsGBaMFtBSfNE/SxvD0yS0Z3JaFgM6OsNHiBqgcEXQ12ciuNyEl9cwWEyijt9petitAIulPZbutHNoXJ9hS1fnjfjT6/kulqWgLFaNBVAi59Y39h207xnZXz+EslJeDUGYe0PLgtom1oopEZdcR6v+CC7IJE7eveJ818hvKTqHCSJNRpWwYKJQVy5EXfa+5nNv5mkJBOIhC3wDVlW1HT/zbaAxUg7xB/mlupRNg8/KAugW+njqUNHo6ZvTwHEvH2NHQViQwwz4pgOqxZwkQVPfLsFcmxZGT80UYjAE3bk03VC8bP9tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3I5GfY0sCOvOJMipGowcFtEj2TvkluOWrnoTdgVPguU=;
 b=Fumo5qylduX+T3j0jbNs7RlI/eF1ZLKniZCdD+88Bbpx0hVV2E7MDh24Ced2U3fqqU7b7qos1eCsk9fEjSWNA77oFFsDmtyLTDanyXGfJMhHPVSNgTjnJK6p0xoACMi/KNQLGGUSRq7YYRVYSk0OKMVO0DPlgKvaV7cwONqd6e8=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TY1PR01MB1817.jpnprd01.prod.outlook.com (2603:1096:403:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Mon, 10 May
 2021 10:29:59 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::e413:c5f8:a40a:a349%4]) with mapi id 15.20.4108.031; Mon, 10 May 2021
 10:29:59 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Topic: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
Thread-Index: AQHXNmo4snkvFkzf+kiCjGV8r1I+Z6raKfAAgADjaICAAZGPAA==
Date:   Mon, 10 May 2021 10:29:59 +0000
Message-ID: <TY2PR01MB369211466F9F6DB5EDC41183D8549@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
 <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
In-Reply-To: <04c93015-5fe2-8471-3da5-ee85585d9e6c@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:e1f8:917e:7447:693d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75d36a98-f754-4518-0f14-08d9139e902b
x-ms-traffictypediagnostic: TY1PR01MB1817:
x-microsoft-antispam-prvs: <TY1PR01MB1817D7D28438270724267DE6D8549@TY1PR01MB1817.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A3+kmlp9c3FceMbMq3r8BXdGfgBY1zP3qdMqNSI26u10lNNyLAwEAD1z4ntgMkgi2SGFLyF8WX2pvGTSjiPm7qwMK4IUvdER6a+lJyGewnSy7Et87jplqfdY9GtphzUm5rz+vJ1Syhd67isFr1omVnYPGqKFZfOV9dZmexUok4KpcJeDcwiveNe2W5qm5hROf9ABWfVuoNKYMMMNrqZjBgOANIkB/I2dyeGShxYekVHCXsRB4fSSPh0w7cCKvav/hZuSkoJo62sPXCGuAiOQCnB5RtLW3H2CMAZqFykuX78/9o5U8xQUPGiM5v86XTcp1GNmrb+gvmzdCuKQvPvJ/bsTS82PDLsiokatSr8+K8UcdDvC4rkztqYpTZWx/lSma7e4HiqWM4cpWeSbtFEXwWdSWxd24XX0I3WHuGcgCrnjpSWHdiZd76cPDvtJCTtORem1nhetJbkHFuWSoBl7fM/J7YSlVyHqEYXWkMg3CuzBJkr7CU4TigoAyBGVYfXuTEMbOa6RLWgNKDPY9jkdPSOgg7Ga6SmXi/i+2LnYYUM42tXIJMzGmD3KJ5iwL9AW2AxH8EOfFZ5BjawlWBdPZWwmQlw5wv6tKVf10vlVdHXlt0/HCphOnFZt7yEkUUCEcWE/1pxMbT6eV4V+q0UAyDD3wYcA5OVGDT6sFQ46U5CIP8icOTsfqrHtwzGNlohO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(122000001)(6916009)(54906003)(55016002)(53546011)(71200400001)(966005)(478600001)(83380400001)(7696005)(9686003)(33656002)(86362001)(38100700002)(8936002)(2906002)(5660300002)(8676002)(52536014)(66556008)(66946007)(316002)(6506007)(64756008)(186003)(66476007)(76116006)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QWhJMllDZWxORUZYZzN3MjN1QitXU1dHY1Ruc3loWXVBNHVnT2c0SGdXV2Fm?=
 =?utf-8?B?TS9CbFJIQXNkZmJIcjF4S2FKWXhHVUNDSld4TGh2NFZndWEwUEdNcVNmYWJ3?=
 =?utf-8?B?NVArbkV0WW52VTFwcGNJMGF2alQ2RzNBM2NhNE1OUDRCYTlYYnZQcXp5Rk53?=
 =?utf-8?B?MEMrR0JkSXdvSXppWDd5YUNOWnVxejVaOE9aNDRmSHVCUWNHTjVpdVFJdW5k?=
 =?utf-8?B?cUczVFB2YWpDb0tQM2JibmF2VzYxVjhNV3JSTkd1a0xITnY2LzNBRlJsK1NQ?=
 =?utf-8?B?ZlJtMENQQjdXblRheXRYZ2MveGZuUHM4LzR5Y2h5UW95NW5RU1Y1dUFkVk0v?=
 =?utf-8?B?SVRhUDYyME91N0RYOU05SFFZYUJJWXJFSis1ZFdKOWZCYUx2MzhKLzJmSlJV?=
 =?utf-8?B?MzBJaTdRS0ZUTDZkbXZrN056NXQyY29CRFBwZ0F0VlFMZ2p1MlMzRXFpVmM1?=
 =?utf-8?B?NHkvT1NTM2Rsck04SFhEbEwxU1lCdVVIZm8rY1JtbmthTGtoRXhscG1zaWNo?=
 =?utf-8?B?Zm8zbzhwNWp4V2N0ZU4xOTBtb2RFSTVjUWNqcGwwdUtIOThPVlVZK0xGRkhr?=
 =?utf-8?B?ZzVtZ2J0eFcweVFOT25tVkNUcndSczQ5eUtvYVA2MGFBR2R1K1l1NDZObGVx?=
 =?utf-8?B?VnlIQ09xVFdnL25iU1VCSWUxQm11ek1iYjNLOVZlbkxxUU9uTWtVRmxJUVJn?=
 =?utf-8?B?R1lrZDNnQ1ZyV2hWYXRjNmJCSXlwNDZ6dW1HbTk0TEh0Y2U4VXBvT1Yvamda?=
 =?utf-8?B?Y1c4WFFzbzRubWNpdDR0MUFTb0JuODBVYy80bFBrME9CSTBRU3hrdGkwMlBK?=
 =?utf-8?B?Q3B2VGFxaVB2b0h5ZTJRdXQzejI3RTE5dGFxSVYyM0F4QkVaUy9WUm0zQ2k2?=
 =?utf-8?B?Q1JrUU1oT05FalBkUHExYUVzQlc1UE1ETlI2QVlCWHJoQTI5ZEZ2Q1dpS2Vw?=
 =?utf-8?B?bnp3ZjBnY3IrYUpRd29LVExlUFJEbmdJeW82OGlGN01OREtyZG50R2JLWDRm?=
 =?utf-8?B?L1RTYTk3VDZ5bTQwbUpKNW1rV2VlR3NTZHBzM29oRGtvMEUybG8wek43UVha?=
 =?utf-8?B?Y2FlNTVWUWZERHBrSi81SVpyVlpvWUVwekxmY0NTV0ZGTW9PK1VOZDN5blpo?=
 =?utf-8?B?WkE1dFg1YnBpcW1pbzYrditDNkd2NDcwUjlKWWRNSTlqZVZtaStIZTlvTjJ1?=
 =?utf-8?B?eDh4T3R6WnRvaXlxQy8zZ3h4K216R0ZVL1l1MHFOenQvOU5LZTRXSnFpMktZ?=
 =?utf-8?B?S0ZIRVdzOXlVbG5HWTMwa0QxRm1ienJYOVNsbXhIeVRYaVhMUGNkdmY4K2VZ?=
 =?utf-8?B?UU1mNnJQcGNLM045Yld1a2lqRGpXbFNNZDc0MlJIVzRva2ZpV1ZDYk1sZVpw?=
 =?utf-8?B?UXNCNFZLTFVmRTJNQ2lpS29URTczSWVKUW0rbk5Sbms1NG1NNDk4Y0dYS1Jr?=
 =?utf-8?B?cDRzZlFKbjFJUlNxMHBMMFN0ZXUrVSsxS0VMUEJ3RHA3YXU5KzZpS0ZBNTZV?=
 =?utf-8?B?SnhFSUR1aU8rQlRsam5MUVlra3gzZ3Qyb0c2VThKR0x5c3pucEdNZTBMbDFP?=
 =?utf-8?B?RVFaY2x4S2Q1U2N4MDJoOGhab3NBQzN0SEpqb004Nk1nZlN0OFNwUU5XYStq?=
 =?utf-8?B?UjhHQmpOYWZwUWxVZmNFa2ZGS1RGY0tkbWM4VjEyMHphOWNrQUd6TXkwRThK?=
 =?utf-8?B?amlma2FjK04wUnBNTkU3M29JTzVSa0lUUytlc3pZbWZHWGNLb0lQeUZSYWg3?=
 =?utf-8?B?Ykl2aUdORE12U0JFaW94UFFKbm5YU25XR0lIbHdPVHMzbGZNdWVoZURyeDRv?=
 =?utf-8?Q?QNkit8xb9Snq7x4clw/MgLPS3Be1q5f2gaeV0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75d36a98-f754-4518-0f14-08d9139e902b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2021 10:29:59.3027
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uy+9ERsJdONxl3PeW9GvSh8jNFpmxlRuCUDi9By45hrvtys4AQJNtCASXH/BsrvFzdtZ3ZwwQjb8IKeO00dslekbMwda5EGFbcVj+aGUJ1V5llJ1YsUWUdaV1CvZHSoT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1817
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU2VyZ2VpLA0KDQo+IEZyb206IFNlcmdlaSBTaHR5bHlvdiwgU2VudDogU3VuZGF5LCBNYXkg
OSwgMjAyMSA3OjIyIFBNDQo+IA0KPiBPbiAwOC4wNS4yMDIxIDIzOjQ3LCBTZXJnZWkgU2h0eWx5
b3Ygd3JvdGU6DQo+IA0KPiA+ICAgICBQb3N0aW5nIGEgcmV2aWV3IG9mIHRoZSBhbHJlYWR5IGNv
bW1pdGVkIChvdmVyIG15IGhlYWQpIHBhdGNoLiBJdCB3b3VsZCBoYXZlDQo+ID4gYmVlbiBhcHBy
b3ByaWF0ZSBpZiB0aGUgcGF0Y2ggbG9va2VkIE9LIGJ1dCBpdCdzIG5vdC4gOi0vDQo+ID4NCj4g
Pj4gV2hlbiBhIGxvdCBvZiBmcmFtZXMgd2VyZSByZWNlaXZlZCBpbiB0aGUgc2hvcnQgdGVybSwg
dGhlIGRyaXZlcg0KPiA+PiBjYXVzZWQgYSBzdHVjayBvZiByZWNlaXZpbmcgdW50aWwgYSBuZXcg
ZnJhbWUgd2FzIHJlY2VpdmVkLiBGb3IgZXhhbXBsZSwNCj4gPj4gdGhlIGZvbGxvd2luZyBjb21t
YW5kIGZyb20gb3RoZXIgZGV2aWNlIGNvdWxkIGNhdXNlIHRoaXMgaXNzdWUuDQo+ID4+DQo+ID4+
ICAgICAgJCBzdWRvIHBpbmcgLWYgLWwgMTAwMCAtYyAxMDAwIDx0aGlzIGRyaXZlcidzIGlwYWRk
cmVzcz4NCj4gPg0KPiA+ICAgICAtbCBpcyBlc3NlbnRpYWwgaGVyZSwgcmlnaHQ/DQoNClllcy4N
Cg0KPiA+ICAgICBIYXZlIHlvdSB0cmllZCB0ZXN0aW5nIHNoX2V0aCBzcml2ZXIgbGlrZSB0aGF0
LCBCVFc/DQo+IA0KPiAgICAgSXQncyBkcml2ZXIhIDotKQ0KDQpJIGhhdmUgbm90IHRyaWVkIHRl
c3Rpbmcgc2hfZXRoIGRyaXZlciB5ZXQuIEknbGwgdGVzdCBpdCBhZnRlciBJIGdvdCBhbiBhY3R1
YWwgYm9hcmQuDQoNCj4gPj4gVGhlIHByZXZpb3VzIGNvZGUgYWx3YXlzIGNsZWFyZWQgdGhlIGlu
dGVycnVwdCBmbGFnIG9mIFJYIGJ1dCBjaGVja3MNCj4gPj4gdGhlIGludGVycnVwdCBmbGFncyBp
biByYXZiX3BvbGwoKS4gU28sIHJhdmJfcG9sbCgpIGNvdWxkIG5vdCBjYWxsDQo+ID4+IHJhdmJf
cngoKSBpbiB0aGUgbmV4dCB0aW1lIHVudGlsIGEgbmV3IFJYIGZyYW1lIHdhcyByZWNlaXZlZCBp
Zg0KPiA+PiByYXZiX3J4KCkgcmV0dXJuZWQgdHJ1ZS4gVG8gZml4IHRoZSBpc3N1ZSwgYWx3YXlz
IGNhbGxzIHJhdmJfcngoKQ0KPiA+PiByZWdhcmRsZXNzIHRoZSBpbnRlcnJ1cHQgZmxhZ3MgY29u
ZGl0aW9uLg0KPiA+DQo+ID4gICAgIFRoYXQgYmFjaWFsbHkgZGVmZWF0cyB0aGUgcHVycG9zZSBv
ZiBJSVVDLi4uDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
IE5BUEksDQo+IA0KPiAgICAgSSB3YXMgc3VyZSBJIHR5cGVkIE5BUEkgaGVyZSwgeWV0IGl0IGdv
dCBsb3N0IGluIHRoZSBlZGl0cy4gOi0pDQoNCkkgY291bGQgbm90IHVuZGVyc3RhbmQgInRoYXQi
IChjYWxsaW5nIHJhdmJfcngoKSByZWdhcmRsZXNzIHRoZSBpbnRlcnJ1cHQNCmZsYWdzIGNvbmRp
dGlvbikgZGVmZWF0cyB0aGUgcHVycG9zZSBvZiBOQVBJLiBBY2NvcmRpbmcgdG8gYW4gYXJ0aWNs
ZSBvbg0KdGhlIExpbnV4IEZvdW5kYXRpb24gd2lraSBbMV0sIG9uZSBvZiB0aGUgcHVycG9zZSBv
ZiBOQVBJIGlzICJJbnRlcnJ1cHQgbWl0aWdhdGlvbiIuDQpJbiBwb2xsKCksIHRoZSBpbnRlcnJ1
cHRzIGFyZSBhbHJlYWR5IGRpc2FibGVkLCBhbmQgcmF2Yl9yeCgpIHdpbGwgY2hlY2sgdGhlDQpk
ZXNjcmlwdG9yJ3Mgc3RhdHVzLiBTbywgdGhpcyBwYXRjaCBrZWVwcyB0aGUgIkludGVycnVwdCBt
aXRpZ2F0aW9uIiBJSVVDLg0KDQpbMV0NCmh0dHBzOi8vd2lraS5saW51eGZvdW5kYXRpb24ub3Jn
L25ldHdvcmtpbmcvbmFwaQ0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo=
