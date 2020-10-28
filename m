Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2074629D3C0
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgJ1Vqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:46:39 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:34217
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726495AbgJ1Vqg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 17:46:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8kY0as2PmXgJYSoBeHYrLSbFZaT2tTLB5iNE0KZMXp/DgMhEAOVjgFw0hSff9fU/OZIASy48C84dXx5SfY6FjKw7CsOagdFzT6uq0/g1AnCDQV86EtkT79TG2FX7cxKP5BcGjaAoMad+hIja+pHz+ck2EJkgFfuaIqyS5HO8ZGUVeEXTLVvdk/xLunDwT3EeyuFqDYLigoLRtAeZYb+xp8SBMxxyp5I0vw6m3OScQ6VQ/0qvvqoINMP08Ch6nN798pseKnRv2mCLh3bELFhwp+X4U3SzJnnJJ/qv/ZOchFg3t4GHmtd4Z4XY83vaOTH/R6yE1RORClXWbfIQ3klqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtiszIqYYS2JyDAMiHyC8koeCoAtxWRlFjvtWJInNuM=;
 b=m43x6K1/OsomO4ofMrBBHkKcNngjhNMoa4mNbgpEKSzhna++a3wcFTOPJDTVDoQvdkIZfbkWMCxPFY/aUV3gwkdVn2qdgWLe4KEg5WBtJc+IiUBxzdsKM4JIqpeh10XFD6d23tZ4lf84d4QF1iCjEHtrNdRIn6Sd+c6A8xqxPN3Adp0UQFrLj/Nnjvv+WbwYsKgev8G+uYN76OZR7G/goc7isH6NpNnQJGIs2TvdACW/HHikwpV8AwlxlX1h8y/A0WI/qcNSg2JFGOpuXN/44+ri1msqfzifmozQbNo19CzBn+srck1t+TNlTLzsSJ7kt+uuBijGvNf0jm4B7bgoFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtiszIqYYS2JyDAMiHyC8koeCoAtxWRlFjvtWJInNuM=;
 b=DIDSyWmAZSvIfny0NfHYVLR1WPOiwCBR++90iIIr4WYcXcca20nmnZGbf9ZyCVK71ojHHg+66zqKeQmts/QOo3M/WU/ov3dI+DMFGf4UMnt9NgtKR6xlv0Fb9F2kVMunuJVf4EjjZ7t2eD6nkkUi/ksqMmKSdp96fp5rWmZ0cH4=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2656.eurprd04.prod.outlook.com (2603:10a6:800:56::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.22; Wed, 28 Oct
 2020 15:57:55 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51%6]) with mapi id 15.20.3499.018; Wed, 28 Oct 2020
 15:57:55 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: RE: [PATCH net 2/2] dpaa_eth: fix the RX headroom size alignment
Thread-Topic: [PATCH net 2/2] dpaa_eth: fix the RX headroom size alignment
Thread-Index: AQHWrHFymDxVYcEE1E67vvzgB52IZamr+B8AgAEtxaA=
Date:   Wed, 28 Oct 2020 15:57:55 +0000
Message-ID: <VI1PR04MB5807A1501D629B4AD0F7B3B7F2170@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1603804282.git.camelia.groza@nxp.com>
 <434895b93ba0039abc94d5fdfcd91a27f2d867cb.1603804282.git.camelia.groza@nxp.com>
 <CA+FuTSftPvRLjkU-efkDkqhUdS0hSCtSEwufzbAPKnSSjTNcKg@mail.gmail.com>
In-Reply-To: <CA+FuTSftPvRLjkU-efkDkqhUdS0hSCtSEwufzbAPKnSSjTNcKg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e246ff7f-b25e-4e84-129b-08d87b5a3bda
x-ms-traffictypediagnostic: VI1PR0401MB2656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB2656AE2F8E69017F4D8830A0F2170@VI1PR0401MB2656.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hokxe26Micbk7Hy1p99hBreorGmQkkudVkYb74pP5RgX9VyCZDkw/InY5trI06npjS1FAIWhxYYLT1iZjzra2+dTtlmQR931WDBBKG9DdL7UoU58nyhdxurKqd5+yBCrEdTSomKWRsMLjM+HOrse9FvcbJbwO0qoULp3maZgg6Jg6/pNnrPVYiO8IUftAf5gwVoaO9JwOqug6WW29mxOE0BA8lVPlCwvcMaXzHN2qe4namePq1ijY98Xtc1pDOlsvuSbD61J12G7B6JQY32JEOyAu7QTmZ0AYikQS2ifUYyHuEOKIHN15YFGMOR6WNy/dhVNmv8A013Q4WxbU80T8g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(136003)(396003)(346002)(7696005)(54906003)(478600001)(53546011)(64756008)(66446008)(5660300002)(6506007)(316002)(6916009)(83380400001)(66556008)(8676002)(66476007)(186003)(8936002)(2906002)(33656002)(4326008)(86362001)(26005)(55016002)(52536014)(71200400001)(76116006)(66946007)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YdMOm3ZGx6CQmArVB3yRAl5yxxKsVmUHUBi2wVZpeh22SLE5sl6Rg2kFZwQh+LJ/NXvH5yHx1MJ8Rlx5F1rd32zwy07m1OxzJkQptB0ZEcG7DzoSX6XIUe7DuJenpySDOOiWAZvx3R5WLCg68kGYKzmyPQFZU4YYVbMhiyPKrn08n//EBjWGue7vjSpp2VMQG8DZ6qjU7cM6aYZjr7kjLwOjX+pYTRMuqiU3XUl5xNkFzlCHBJ+Wwn2QuGtij922mf79e2wPltgS0Zv70MG1Tps5pd9Izt/yH3KgYKXIU76qQcy0zTy77779hf+zFTQ/LHhTuonUKPAGzVDlSwqAt9yNs3uYiIqI4uPP69QKTxgg45qbHjlqQHQAGmaRYsl1yrkp9Oka4uTrWGIP/BYIxQ3xBPDkRTOcZCF93Ant2ZHxd/q7bhAF3+O3lukXK11+3/D0AU+n+ICdB838HKkLyChwVr0k1Dgw3w7UBnIHPIMUSk3UCiRoyDRBIoRBKr1iym/fUNvHUguhkTLSAt8fFF6GkfhgJh/TvKeWpSKfO/L07S/4Y6bMHmzzziEz+BkEXkpj6jOHCbn2IwIOeEe1PL/pnzTZgcC8ZfKp00vk0mcMzv326suekC4vIqhAPbAK21VdKjTmCDX0xY0ZxUbVag==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e246ff7f-b25e-4e84-129b-08d87b5a3bda
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 15:57:55.3506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2W2EkrFUdENLAPaUObWElkNbjgu2Gw9MzB7W0kRJeDYLyyEFDR4oSCHRiutGPj6tPFpYzwmBbyBIBa2pffRxVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2656
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBXaWxsZW0gZGUgQnJ1aWpuIDx3
aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBPY3RvYmVy
IDI3LCAyMDIwIDIzOjMxDQo+IFRvOiBDYW1lbGlhIEFsZXhhbmRyYSBHcm96YSA8Y2FtZWxpYS5n
cm96YUBueHAuY29tPg0KPiBDYzogTWFkYWxpbiBCdWN1ciAoT1NTKSA8bWFkYWxpbi5idWN1ckBv
c3MubnhwLmNvbT47IERhdmlkIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3Vi
IEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBOZXR3b3JrDQo+IERldmVsb3BtZW50IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldCAyLzJdIGRwYWFf
ZXRoOiBmaXggdGhlIFJYIGhlYWRyb29tIHNpemUgYWxpZ25tZW50DQo+IA0KPiBPbiBUdWUsIE9j
dCAyNywgMjAyMCBhdCAxMTowNCBBTSBDYW1lbGlhIEdyb3phIDxjYW1lbGlhLmdyb3phQG54cC5j
b20+DQo+IHdyb3RlOg0KPiA+DQo+ID4gVGhlIGhlYWRyb29tIHJlc2VydmVkIGZvciByZWNlaXZl
ZCBmcmFtZXMgbmVlZHMgdG8gYmUgYWxpZ25lZCB0byBhbg0KPiA+IFJYIHNwZWNpZmljIHZhbHVl
LiBUaGVyZSBpcyBjdXJyZW50bHkgYSBkaXNjcmVwYW5jeSBiZXR3ZWVuIHRoZSB2YWx1ZXMNCj4g
PiB1c2VkIGluIHRoZSBFdGhlcm5ldCBkcml2ZXIgYW5kIHRoZSB2YWx1ZXMgcGFzc2VkIHRvIHRo
ZSBGTWFuLg0KPiA+IENvaW5jaWRlbnRhbGx5LCB0aGUgcmVzdWx0aW5nIGFsaWduZWQgdmFsdWVz
IGFyZSBpZGVudGljYWwuDQo+ID4NCj4gPiBGaXhlczogM2M2OGI4ZmZmYjQ4ICgiZHBhYV9ldGg6
IEZNYW4gZXJyYXR1bSBBMDUwMzg1IHdvcmthcm91bmQiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IENh
bWVsaWEgR3JvemEgPGNhbWVsaWEuZ3JvemFAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYyB8IDEyICsrKysrKysrLS0t
LQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0K
PiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9kcGFh
L2RwYWFfZXRoLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFh
X2V0aC5jDQo+ID4gaW5kZXggMWFhYzBiNi4uNjdhZTU2MSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZHBhYS9kcGFhX2V0aC5jDQo+ID4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2RwYWEvZHBhYV9ldGguYw0KPiA+IEBAIC0yODQy
LDcgKzI4NDIsOCBAQCBzdGF0aWMgaW50IGRwYWFfaW5ncmVzc19jZ3JfaW5pdChzdHJ1Y3QgZHBh
YV9wcml2DQo+ICpwcml2KQ0KPiA+ICAgICAgICAgcmV0dXJuIGVycjsNCj4gPiAgfQ0KPiA+DQo+
ID4gLXN0YXRpYyBpbmxpbmUgdTE2IGRwYWFfZ2V0X2hlYWRyb29tKHN0cnVjdCBkcGFhX2J1ZmZl
cl9sYXlvdXQgKmJsKQ0KPiA+ICtzdGF0aWMgaW5saW5lIHUxNiBkcGFhX2dldF9oZWFkcm9vbShz
dHJ1Y3QgZHBhYV9idWZmZXJfbGF5b3V0ICpibCwNCj4gPiArICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBlbnVtIHBvcnRfdHlwZSBwb3J0KQ0KPiA+ICB7DQo+ID4gICAgICAgICB1
MTYgaGVhZHJvb207DQo+ID4NCj4gPiBAQCAtMjg1Niw5ICsyODU3LDEyIEBAIHN0YXRpYyBpbmxp
bmUgdTE2IGRwYWFfZ2V0X2hlYWRyb29tKHN0cnVjdA0KPiBkcGFhX2J1ZmZlcl9sYXlvdXQgKmJs
KQ0KPiA+ICAgICAgICAgICoNCj4gPiAgICAgICAgICAqIEFsc28gbWFrZSBzdXJlIHRoZSBoZWFk
cm9vbSBpcyBhIG11bHRpcGxlIG9mIGRhdGFfYWxpZ24gYnl0ZXMNCj4gPiAgICAgICAgICAqLw0K
PiA+IC0gICAgICAgaGVhZHJvb20gPSAodTE2KShibC0+cHJpdl9kYXRhX3NpemUgKyBEUEFBX1BB
UlNFX1JFU1VMVFNfU0laRSArDQo+ID4gKyAgICAgICBoZWFkcm9vbSA9ICh1MTYpKGJsW3BvcnRd
LnByaXZfZGF0YV9zaXplICsNCj4gRFBBQV9QQVJTRV9SRVNVTFRTX1NJWkUgKw0KPiA+ICAgICAg
ICAgICAgICAgICBEUEFBX1RJTUVfU1RBTVBfU0laRSArIERQQUFfSEFTSF9SRVNVTFRTX1NJWkUp
Ow0KPiA+DQo+ID4gKyAgICAgICBpZiAocG9ydCA9PSBSWCkNCj4gPiArICAgICAgICAgICAgICAg
cmV0dXJuIEFMSUdOKGhlYWRyb29tLCBEUEFBX0ZEX1JYX0RBVEFfQUxJR05NRU5UKTsNCj4gPiAr
DQo+IGVsc2U/DQoNCkl0IGZhbGxzIHRocm91Z2guIEknbGwgbWFrZSBpdCBleHBsaWNpdC4NCg0K
PiA+ICAgICAgICAgcmV0dXJuIEFMSUdOKGhlYWRyb29tLCBEUEFBX0ZEX0RBVEFfQUxJR05NRU5U
KTsNCj4gPiAgfQ0KPiA+DQo+ID4gQEAgLTMwMjcsOCArMzAzMSw4IEBAIHN0YXRpYyBpbnQgZHBh
YV9ldGhfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZQ0KPiAqcGRldikNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICBnb3RvIGZyZWVfZHBhYV9mcXM7DQo+ID4gICAgICAgICB9DQo+ID4N
Cj4gPiAtICAgICAgIHByaXYtPnR4X2hlYWRyb29tID0gZHBhYV9nZXRfaGVhZHJvb20oJnByaXYt
PmJ1Zl9sYXlvdXRbVFhdKTsNCj4gPiAtICAgICAgIHByaXYtPnJ4X2hlYWRyb29tID0gZHBhYV9n
ZXRfaGVhZHJvb20oJnByaXYtPmJ1Zl9sYXlvdXRbUlhdKTsNCj4gPiArICAgICAgIHByaXYtPnR4
X2hlYWRyb29tID0gZHBhYV9nZXRfaGVhZHJvb20oJnByaXYtPmJ1Zl9sYXlvdXRbMF0sIFRYKTsN
Cj4gPiArICAgICAgIHByaXYtPnJ4X2hlYWRyb29tID0gZHBhYV9nZXRfaGVhZHJvb20oJnByaXYt
PmJ1Zl9sYXlvdXRbMF0sDQo+IFJYKTsNCj4gDQo+IFRoaXMgY2FuIGJlIGp1c3QgcHJpdi0+YnVm
X2xheW91dA0KDQpJJ2xsIGNoYW5nZSBpdC4gVGhhbmtzLg0KDQo+ID4gICAgICAgICAvKiBBbGwg
cmVhbCBpbnRlcmZhY2VzIG5lZWQgdGhlaXIgcG9ydHMgaW5pdGlhbGl6ZWQgKi8NCj4gPiAgICAg
ICAgIGVyciA9IGRwYWFfZXRoX2luaXRfcG9ydHMobWFjX2RldiwgZHBhYV9icCwgJnBvcnRfZnFz
LA0KPiA+IC0tDQo+ID4gMS45LjENCj4gPg0K
