Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FEF125304
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 21:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfLRURr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 15:17:47 -0500
Received: from mail-eopbgr70043.outbound.protection.outlook.com ([40.107.7.43]:35626
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725818AbfLRURq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 15:17:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke7DjGmm1dyeYvVvodiJIThXAgxYbFXrTfEflbUZnpDZ8Ag5FwKha6muKvooXUtP8p8VuPIA+5MlrSHwwneRYMYKdXo4R8uoVhutCZb8Qt4cJhA8pzQRnHS6D7ACKLhxozfny2i+xKqAPgPij1Y+8VC+9NLIGJH2rqRul3+7iCdaZ4jeiIOCHZnKUMGfX5sz4L6OiEonmbgOkQomElZsfEZjsZ9g20cv6/uvQaPSVhBILQ3ZRqrf69p74wN3HU5ihS/+P3C9OJUNaVbX6OsB43ygRYkbnK6Nrvq6AyIMCtBnXfAiuqcPIIQGL5g+E4+3FrF5eayiUWaXLmY3V2Rn0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn+G8UafDUgs2qBjIWBkoYF+8FMelRsscwHisN/e7uM=;
 b=IcTKikhm+lZYNiLTDIVJNvahIG6WgEn97BYGpFSfgirbrSfSv8UVoMZsqan8nFOWEIqpSd00ISSvvz1KiouZkHQzA8VNH7l79w/hYUWw0dUmFlxDiwbk185nH1orswWraUF1JwNQ7P/hAg5GqmQjHgioRt33vk/r9UCfMPIouucJg+WcDsxdxZMpXZxnWWisgOvfJ9tCJUEi3C05WqsG39TuiGoL1ZH3q+0bNcuSzQhw/E+FKsdmrVGTPkkBU6wJwLQZ00YNlNs3MVO2MG2SvZBkex7rbyVVYZcCmq/gltTjtJ+xR5tTZvhA8AOJQ08TEeeP4UPlc3O3EKF9axGr5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xn+G8UafDUgs2qBjIWBkoYF+8FMelRsscwHisN/e7uM=;
 b=o09Mjk/g8H2uIUFd2x3lqyWPBd9CNWowSMOh7LL0hMXCmI11SNr8+DxWE48rLE6qzcdSL1KfmEh9Bsb4w8DBpZi3FsTl92bKV3XGXjlFytA9rXkxfCL1q79NgPhGDFP0yhN9Vlfn+1z6VxvalMMBZrFh0jV7C72eAZ0kVBrTS0o=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5776.eurprd04.prod.outlook.com (20.178.127.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 20:15:59 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::f099:4735:430c:ef1d%2]) with mapi id 15.20.2559.012; Wed, 18 Dec 2019
 20:15:59 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Thread-Topic: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Thread-Index: AQHVtSgTRi8iIbz3OE2hW9M9gxOOf6e/tLgAgAAs9ACAAAJsAIAAGWsAgAAnpwCAADBygA==
Date:   Wed, 18 Dec 2019 20:15:59 +0000
Message-ID: <7fd147c9-7531-663a-923f-cdfb0a290fe8@nxp.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191218104008.GT25745@shell.armlinux.org.uk>
 <CA+h21hrbqggYxzd6SGhBmy3fUbmG2EFqbOHAnkDu8xPYRP7ewg@mail.gmail.com>
 <20191218132942.GU25745@shell.armlinux.org.uk>
 <e199162b-9b90-0a90-e74e-3b19e542f710@nxp.com>
 <20191218172236.GV25745@shell.armlinux.org.uk>
In-Reply-To: <20191218172236.GV25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.189.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c95ada3-1306-4c43-6274-08d783f718ff
x-ms-traffictypediagnostic: VI1PR04MB5776:|VI1PR04MB5776:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5776BC9D5F40CFBA310457A5F5530@VI1PR04MB5776.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(396003)(39840400004)(136003)(189003)(199004)(55674003)(8676002)(186003)(66476007)(6486002)(53546011)(8936002)(6506007)(26005)(81156014)(76116006)(7416002)(6916009)(71200400001)(66556008)(66946007)(91956017)(31686004)(2616005)(36756003)(2906002)(5660300002)(64756008)(66446008)(44832011)(86362001)(31696002)(81166006)(478600001)(54906003)(6512007)(316002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5776;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kHB87zbdgaiqeww515Zbjvc6pgDxVU8qnzBp2Td4X4lyk+Vj6VvH1Au0CinHDVxqgsSl//UM8RWO4GcG8erwb+HV8qiFwp298JBZ+G7PQdfG1P6pYS6y8FwhO0cdYHnMaCk0LoI7GeTgHfq7XUnvDSzOnq61GJdheAKOGxpjZEUNYWSDf3M0IRB5O4xJVD+TP/2DBp1mD8sh+IK3PWXaABUKD1x7w7PjrgU2FIwUCjP93hpSN9/lIHp1dLBVdO/fv7AnTHyU5RpUXeRcoOarXdzDfG4pFOvzohnsZZDsvX2TVzQdQO0SsfXrZ5mPvEYHQQEW8Bq0sBWc7UgOe5aCQCi17uIxvejtxSoMdFQTxLldfdOlgBPwcqbFpRzpj1EOq5bRwX+H5sAssIMkF/Lf5yJsCDMyfSfkUgMJos3fc2oevP6vjrXbGhP9w4fCxUa01HY/xM25ZLDlUVPPzgRDneJiJwcAwRDyV9V5eMByK52PrMk0JjWkTrF+GrvGjffs
Content-Type: text/plain; charset="utf-8"
Content-ID: <50B7FF78020C84488989391A754AB024@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c95ada3-1306-4c43-6274-08d783f718ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 20:15:59.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QcLH0AqOQZr7mEJnoSg+Jl+Kfi8sWz7HEz123w93y07IJfRFwvNmbDkliU60wFnn1JEyLINHbX4PyOchtKx6t+XmsUZsYQHuLuJv+Z4HkmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5776
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTgvMjAxOSA2OjIyIFBNLCBSdXNzZWxsIEtpbmcgLSBBUk0gTGludXggYWRtaW4gd3Jv
dGU6DQo+IE9uIFdlZCwgRGVjIDE4LCAyMDE5IGF0IDAzOjAwOjQxUE0gKzAwMDAsIEFsZXhhbmRy
dSBNYXJnaW5lYW4gd3JvdGU6DQo+PiBPbiAxMi8xOC8yMDE5IDI6MjkgUE0sIFJ1c3NlbGwgS2lu
ZyAtIEFSTSBMaW51eCBhZG1pbiB3cm90ZToNCj4+PiBPbiBXZWQsIERlYyAxOCwgMjAxOSBhdCAw
MzoyMTowMlBNICswMjAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+Pj4+IC0gVGhlIGF0ODAz
eC5jIGRyaXZlciBleHBsaWNpdGx5IGNoZWNrcyBmb3IgdGhlIEFDSyBmcm9tIHRoZSBNQUMgUENT
LA0KPj4+PiBhbmQgcHJpbnRzICJTR01JSSBsaW5rIGlzIG5vdCBvayIgb3RoZXJ3aXNlLCBhbmQg
cmVmdXNlcyB0byBicmluZyB0aGUNCj4+Pj4gbGluayB1cC4gVGhpcyBodXJ0cyB1cyBpbiA0LjE5
IGJlY2F1c2UgSSB0aGluayB0aGUgY2hlY2sgaXMgYSBiaXQNCj4+Pj4gbWlzcGxhY2VkIGluIHRo
ZSAuYW5lZ19kb25lIGNhbGxiYWNrLiBUbyBiZSBwcmVjaXNlLCB3aGF0IHdlIG9ic2VydmUNCj4+
Pj4gaXMgdGhhdCB0aGlzIGZ1bmN0aW9uIGlzIG5vdCBjYWxsZWQgYnkgdGhlIHN0YXRlIG1hY2hp
bmUgYSBzZWNvbmQsDQo+Pj4+IHRoaXJkIHRpbWUgZXRjIHRvIHJlY2hlY2sgaWYgdGhlIEFOIGhh
cyBjb21wbGV0ZWQgaW4gdGhlIG1lYW50aW1lLiBJbg0KPj4+PiBjdXJyZW50IG5ldC1uZXh0LCBh
cyBmYXIgYXMgSSBjb3VsZCBmaWd1cmUgb3V0LCBhdDgwM3hfYW5lZ19kb25lIGlzDQo+Pj4+IGRl
YWQgY29kZS4gV2hhdCBpcyBpcm9uaWMgYWJvdXQgdGhlIGNvbW1pdCBmNjIyNjViNTNlZjMgKCJh
dDgwM3g6DQo+Pj4+IGRvdWJsZSBjaGVjayBTR01JSSBzaWRlIGF1dG9uZWciKSB0aGF0IGludHJv
ZHVjZWQgdGhpcyBmdW5jdGlvbiBpcw0KPj4+PiB0aGF0IGl0J3MgZm9yIHRoZSBnaWFuZmFyIGRy
aXZlciAoRnJlZXNjYWxlIGVUU0VDKSwgYSBNQUMgdGhhdCBoYXMNCj4+Pj4gbmV2ZXIgc3VwcG9y
dGVkIHJlcHJvZ3JhbW1pbmcgaXRzZWxmIGJhc2VkIG9uIHRoZSBpbi1iYW5kIGNvbmZpZyB3b3Jk
Lg0KPj4+PiBJbiBmYWN0LCBpZiB5b3UgbG9vayBhdCBnZmFyX2NvbmZpZ3VyZV9zZXJkZXMsIGl0
IGV2ZW4gY29uZmlndXJlcyBpdHMNCj4+Pj4gcmVnaXN0ZXIgMHg0IHdpdGggYW4gYWR2ZXJ0aXNl
bWVudCBmb3IgMTAwMEJhc2UtWCwgbm90IFNHTUlJICgweDQwMDEpLg0KPj4+PiBTbyBJIHJlYWxs
eSB3b25kZXIgaWYgdGhlcmUgaXMgYW55IHJlYWwgcHVycG9zZSB0byB0aGlzIGNoZWNrIGluDQo+
Pj4+IGF0ODAzeF9hbmVnX2RvbmUsIGFuZCBpZiBub3QsIEkgd291bGQgcmVzcGVjdGZ1bGx5IHJl
bW92ZSBpdC4NCj4+Pg0KPj4+IFBsZWFzZSBjaGVjayB3aGV0aGVyIGF0ODAzeCB3aWxsIHBhc3Mg
ZGF0YSBpZiB0aGUgU0dNSUkgY29uZmlnIGV4Y2hhbmdlDQo+Pj4gaGFzIG5vdCBjb21wbGV0ZWQg
LSBJJ20gYXdhcmUgb2Ygc29tZSBQSFlzIHRoYXQsIGFsdGhvdWdoIGxpbmsgY29tZXMgdXANCj4+
PiBvbiB0aGUgY29wcGVyIHNpZGUsIGlmIEFOIGRvZXMgbm90IGNvbXBsZXRlIG9uIHRoZSBTR01J
SSBzaWRlLCB0aGV5DQo+Pj4gd2lsbCBub3QgcGFzcyBkYXRhLCBldmVuIGlmIHRoZSBNQUMgc2lk
ZSBpcyBmb3JjZWQgdXAuDQo+Pj4NCj4+PiBJIGRvbid0IHNlZSBhbnkgY29uZmlndXJhdGlvbiBi
aXRzIGluIHRoZSA4MDMxIHRoYXQgc3VnZ2VzdCB0aGUgU0dNSUkNCj4+PiBjb25maWcgZXhjaGFu
Z2UgY2FuIGJlIGJ5cGFzc2VkLg0KPj4+DQo+Pj4+IC0gVGhlIHZzYzg1MTQgUEhZIGRyaXZlciBj
b25maWd1cmVzIFNlckRlcyBBTiBpbiBVLUJvb3QsIGJ1dCBub3QgaW4NCj4+Pj4gTGludXguIFNv
IHdlIG9ic2VydmUgdGhhdCBpZiB3ZSBkaXNhYmxlIFBIWSBjb25maWd1cmF0aW9uIGluIFUtQm9v
dCwNCj4+Pj4gaW4tYmFuZCBBTiBicmVha3MgaW4gTGludXguIFdlIGFyZSBhY3R1YWxseSB3b25k
ZXJpbmcgaG93IHdlIHNob3VsZA0KPj4+PiBmaXggdGhpczogZnJvbSB3aGF0IHlvdSB3cm90ZSBh
Ym92ZSwgaXQgc2VlbXMgb2sgdG8gaGFyZGNvZGUgU0dNSUkgQU4NCj4+Pj4gaW4gdGhlIFBIWSBk
cml2ZXIsIGFuZCBqdXN0IGlnbm9yZSBpdCBpbiB0aGUgUENTIGlmIG1hbmFnZWQgPQ0KPj4+PiAi
aW4tYmFuZC1zdGF0dXMiIGlzIG5vdCBzZXQgd2l0aCBQSFlMSU5LLiBCdXQgYXMgeW91IHNhaWQs
IGluIHRoZQ0KPj4+PiBnZW5lcmFsIGNhc2UgbWF5YmUgbm90IGFsbCBQSFlzIHdvcmsgdW50aWwg
dGhleSBoYXZlbid0IHJlY2VpdmVkIHRoZQ0KPj4+PiBBQ0sgZnJvbSB0aGUgTUFDIFBDUywgd2hp
Y2ggbWFrZXMgdGhpcyBpbnN1ZmZpY2llbnQgYXMgYSBnZW5lcmFsDQo+Pj4+IHNvbHV0aW9uLg0K
Pj4+Pg0KPj4+PiBCdXQgdGhlIDIgY2FzZXMgYWJvdmUgaWxsdXN0cmF0ZSB0aGUgbGFjayBvZiBj
b25zaXN0ZW5jeSBhbW9uZyBQSFkNCj4+Pj4gZHJpdmVycyB3LnIudC4gaW4tYmFuZCBhbmVnLg0K
Pj4+DQo+Pj4gSW5kZWVkIC0gaXQncyBzb21ldGhpbmcgb2YgYSBtaW5lIGZpZWxkIGF0IHRoZSBt
b21lbnQsIGJlY2F1c2Ugd2UgYXJlbid0DQo+Pj4gcXVpdGUgc3VyZSB3aGV0aGVyICJTR01JSSIg
bWVhbnMgdGhhdCB0aGUgUEhZIHJlcXVpcmVzIGluLWJhbmQgQU4gb3INCj4+PiBkb2Vzbid0IHBy
b3ZpZGUgaXQuIEZvciB0aGUgQnJvYWRjb20gY2FzZSBJIG1lbnRpb25lZCwgd2hlbiBpdCdzIHVz
ZWQgb24NCj4+PiBhIFNGUCwgSSd2ZSBoYWQgdG8gYWRkIGEgcXVpcmsgdG8gcGh5bGluayB0byB3
b3JrIGFyb3VuZCBpdC4NCj4+Pg0KPj4+IFRoZSBwcm9ibGVtIGlzLCBpdCdzIG5vdCBhIGNhc2Ug
dGhhdCB0aGUgTUFDIGNhbiBkZW1hbmQgdGhhdCB0aGUgUEhZDQo+Pj4gcHJvdmlkZXMgaW4tYmFu
ZCBjb25maWcgLSBzb21lIFBIWXMgYXJlIGluY2FwYWJsZSBvZiBkb2luZyBzby4gV2hhdGV2ZXIN
Cj4+PiBzb2x1dGlvbiB3ZSBjb21lIHVwIHdpdGggbmVlZHMgdG8gYmUgYSAibmVnb3RpYXRpb24i
IGJldHdlZW4gdGhlIFBIWQ0KPj4+IGRyaXZlciBhbmQgdGhlIE1BQyBkcml2ZXIgZm9yIGl0IHRv
IHdvcmsgd2VsbCBpbiB0aGUga25vd24gc2NlbmFyaW9zIC0NCj4+PiBsaWtlIHRoZSBjYXNlIHdp
dGggdGhlIEJyb2FkY29tIFBIWSBvbiBhIFNGUCB0aGF0IGNhbiBiZSBwbHVnZ2VkIGludG8NCj4+
PiBhbnkgU0ZQIHN1cHBvcnRpbmcgbmV0d29yayBpbnRlcmZhY2UuLi4NCj4+DQo+PiBTb21lIHNv
cnQgb2YgY2FwYWJpbGl0eSBuZWdvdGlhdGlvbiBkb2VzIHNlZW0gdG8gYmUgdGhlIHByb3BlciBz
b2x1dGlvbi4NCj4+IFdlIGNhbiBoYXZlIGEgbmV3IGNhcGFiaWxpdGllcyBmaWVsZCBpbiBwaHlk
ZXYgZm9yIHN5c3RlbSBpbnRlcmZhY2UNCj4+IGNhcGFiaWxpdGllcyBhbmQgbWF0Y2ggdGhhdCB3
aXRoIE1BQyBjYXBhYmlsaXRpZXMsIGNvbmZpZ3VyYXRpb24sIGZhY3Rvcg0KPj4gaW4gdGhlIHF1
aXJrcy4gIFRoZSByZXN1bHQgd291bGQgdGVsbCBpZiBhIHNvbHV0aW9uIGlzIHBvc3NpYmxlLA0K
Pj4gZXNwZWNpYWxseSB3aXRoIHF1aXJreSBQSFlzLCBhbmQgaWYgUEhZIGRyaXZlcnMgbmVlZCB0
byBlbmFibGUgQU4uDQo+Pg0KPj4gVW50aWwgd2UgaGF2ZSB0aGF0IGluIHBsYWNlLCBhbnkgcmVj
b21tZW5kZWQgYXBwcm9hY2ggZm9yIFBIWSBkcml2ZXJzLA0KPj4gaXMgaXQgYWNjZXB0YWJsZSB0
byBoYXJkY29kZSBzeXN0ZW0gc2lkZSBBTiBvbiBhcyBhIHNob3J0IHRlcm0gZml4Pw0KPj4gSSd2
ZSBqdXN0IHRlc3RlZCBWU0M4NTE0IGFuZCBpdCBkb2Vzbid0IGFsbG93IHRyYWZmaWMgdGhyb3Vn
aCBpZiBTSSBBTg0KPj4gaXMgZW5hYmxlZCBidXQgZG9lcyBub3QgY29tcGxldGUuICBXZSBkbyB1
c2UgaXQgd2l0aCBBTiBvbiBvbiBOWFANCj4+IHN5c3RlbXMsIGFuZCBpdCBvbmx5IHdvcmtzIGJl
Y2F1c2UgVS1Cb290IHNldHMgdGhpbmdzIHVwIHRoYXQgd2F5LCBidXQNCj4+IHJlbHlpbmcgb24g
VS1Cb290IGlzbid0IGdyZWF0Lg0KPj4gQXF1YW50aWEgUEhZcyB3ZSB1c2UgYWxzbyByZXF1aXJl
IEFOIHRvIGNvbXBsZXRlIGlmIGVuYWJsZWQuICBGb3IgdGhlbQ0KPj4gTGludXggZGVwZW5kcyBv
biBVLUJvb3Qgb3Igb24gUEhZIGZpcm13YXJlIHRvIGVuYWJsZSBBTi4gIEkgZG9uJ3Qga25vdw0K
Pj4gaWYgYW55b25lIG91dCB0aGVyZSB1c2VzIHRoZXNlIFBIWXMgd2l0aCBBTiBvZmYuICBXb3Vs
ZCBhIHBhdGNoIHRoYXQNCj4+IGhhcmRjb2RlcyBBTiBvbiBmb3IgYW55IG9mIHRoZXNlIFBIWXMg
YmUgYWNjZXB0YWJsZT8NCj4gDQo+IEknbSBub3Qgc3VyZSB3aHkgeW91J3JlIHRhbGtpbmcgYWJv
dXQgaGFyZC1jb2RpbmcgYW55dGhpbmcuIEFzIEkndmUNCj4gYWxyZWFkeSBtZW50aW9uZWQsIHBo
eWxpbmsgYWxsb3dzIHlvdSB0byBzcGVjaWZ5IHRvZGF5IHdoZXRoZXIgeW91DQo+IHdhbnQgdG8g
dXNlIGluLWJhbmQgQU4gb3Igbm90LCBwcm92aWRlZCB0aGUgTUFDIGltcGxlbWVudHMgaXQgYXMg
aXMNCj4gZG9uZSB3aXRoIG12bmV0YSBhbmQgbXZwcDIuDQoNCkkgd2FzIGFza2luZyBhYm91dCBQ
SFkgZHJpdmVycywgbm90IE1BQywgaW4gdGhlIG1lYW50aW1lIEkgbm90aWNlZCANCnBoeV9kZXZp
Y2UgY2FycmllcyBhIHBvaW50ZXIgdG8gcGh5bGluay4gIEkgYXNzdW1lIGl0J3MgT0sgaWYgUEhZ
IA0KZHJpdmVycyBjaGVjayBsaW5rX2FuX21vZGUgYW5kIHNldCB1cCBQSFkgc3lzdGVtIGludGVy
ZmFjZSBiYXNlZCBvbiBpdC4NCg0KVGhhbmtzIQ0KQWxleA==
