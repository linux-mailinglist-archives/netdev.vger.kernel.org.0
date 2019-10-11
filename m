Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12CDED34C9
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfJKAEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:04:06 -0400
Received: from mail-eopbgr60059.outbound.protection.outlook.com ([40.107.6.59]:56384
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726096AbfJKAEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 20:04:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZfW28UHq2SiDgbtOhY5jpDymm5QvXRCd+7RHcPsJ+bB2ACwJu1W9/I2cyirMrFvJ/o/Q09ULEePqNXjOJ9Od3Ag8OTgaN3QBbYbam/DS/a/Chsrn/28Yw3sSmyh9KMyyE5y2AdeMe9nL4VRP0sCUjJRI7ClckNInW0iwQ94iJBeSxWm5KHJwh4FTpKtYmyUPB6tRxG0dhWmziaI5ebDpBdQEPKUc4mysbMNbg9l4Hv7mx//XfG34IjbIIuhQt375o3E/R6n7zl1hznjfK+fD6FHIp6PcUy4bbJFf9cYlLWqjp9VIE1q1WPehPmbXiumj45D+VJMtJMikIVHXW6tG0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAsIwOG5zThbl2IluDl1cEkIbu8RaDtk2ahPqR/4vzw=;
 b=crYVjPEmxYUhfeK+845t7eP5MbWArNJFfe75T98igFfyH0Ns0J92WGvg03xbym3hFm8mVUSHI0vNHEzN7yaZ0rwO5Q/pvyWV1aJqqkdxwZHQjQA+vjbwaro419q8hPz8knU1kPdjK9VvZ+e+Pm6KZLKHwfMl1DpX8nIAiekdhZ/1gBp2RozD+E7KfpR6ADGq7oBhf0zVKPs25Ge9TO5AUjWLlDdIpSEeWtXr14VAfa5ExE3oDaqlIHvyMuMmdaTHcsEw72L//JPMQ811/PpTEWqo7MCqez8MFJ7QjT1kPJI/bBWVK9YUfb5/MU6AMmCSU7CqWiQSb+JFmdgIZ6EFKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAsIwOG5zThbl2IluDl1cEkIbu8RaDtk2ahPqR/4vzw=;
 b=HvSM+J2vQEPpNhM+mLrfP26db0qczwYZWOwrxF0PZJcj33uX8w6aQoc7ZXuF0P0Wt5gAKowAezhq3y/zxipF0I5S+Xt2NGPdeuG2BF0zTlhX9cntYVMEvx68I0MmOuI/giUKzoQGXjG8sgGwJbl5ot98+KeShRoADIeVBIJ4824=
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com (52.134.72.18) by
 DB3PR0402MB3801.eurprd04.prod.outlook.com (52.134.65.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 11 Oct 2019 00:03:22 +0000
Received: from DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0]) by DB3PR0402MB3916.eurprd04.prod.outlook.com
 ([fe80::d469:ad51:2bec:19f0%6]) with mapi id 15.20.2347.016; Fri, 11 Oct 2019
 00:03:22 +0000
From:   Anson Huang <anson.huang@nxp.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "swboyd@chromium.org" <swboyd@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional()
 to avoid error message
Thread-Topic: [PATCH 1/2] net: fec_main: Use
 platform_get_irq_byname_optional() to avoid error message
Thread-Index: AQHVforZimETp53I4UOLcQPYAMVf3qdUghaAgAAN4TA=
Date:   Fri, 11 Oct 2019 00:03:22 +0000
Message-ID: <DB3PR0402MB3916FF4583577B182D9BF60CF5970@DB3PR0402MB3916.eurprd04.prod.outlook.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
 <20191010160811.7775c819@cakuba.netronome.com>
In-Reply-To: <20191010160811.7775c819@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=anson.huang@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e661453-35e3-478b-f927-08d74dde6e31
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DB3PR0402MB3801:|DB3PR0402MB3801:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3801A20EDBA690F79C05CC02F5970@DB3PR0402MB3801.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(199004)(189003)(33656002)(54906003)(14454004)(25786009)(316002)(52536014)(478600001)(86362001)(5660300002)(6246003)(4326008)(7696005)(8936002)(74316002)(81156014)(81166006)(15650500001)(66946007)(102836004)(8676002)(305945005)(486006)(6506007)(76116006)(64756008)(66066001)(229853002)(99286004)(6916009)(256004)(2906002)(55016002)(66446008)(11346002)(14444005)(446003)(9686003)(76176011)(476003)(44832011)(3846002)(6116002)(71200400001)(66476007)(26005)(66556008)(6436002)(186003)(71190400001)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR0402MB3801;H:DB3PR0402MB3916.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T9LQXO4hcoRGgWPuelxypd99CJ7//lku+4GbbPgXYpkJ1Zp+qd4cHZYdT8UmhVHz+WRvG2/pDjvHBEMzTN+Tw3xzZD9ms1M6B9D3Y1gvU1SHmws3Oh6bfaPzE2c7iKGcsRYAapBycqr+7U9AHSxGrIABQirN2/jdCD85WkArOLdPChSHaXDePkTRbZ2SKRpDbu9tBp8xbi1/ssdy4iJWfgkM46bLlMtjOT8RCwauJA352UN9SGYewFQ3phqXj8NPgQGBJbNyqviyzDZWbX7GKKWVu3KgHP1Z1K/VLVdNDbGIB3EdgXIG2ExWC+MLjSD3F9+yutCsOAxlWbDkU2Y9oja7s8Jk0MEhLsjHRVJ6yL/dXUAO1zFwanf+McZbNJZPlu67qtKYCkp+czAdACtAA9w4qe9ovSVpOj4DfY81WTM=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e661453-35e3-478b-f927-08d74dde6e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 00:03:22.1852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKF5wlgxSns01UT3RNww3GS9sk4DOtaO064sqO/wnmZ5x7R5LgdQfvk82vMoxT9/6wjxQF1PQUROhN4R70C2zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3801
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksIEpha3ViDQoNCj4gT24gV2VkLCAgOSBPY3QgMjAxOSAxODoxNTo0NyArMDgwMCwgQW5zb24g
SHVhbmcgd3JvdGU6DQo+ID4gRmFpbGVkIHRvIGdldCBpcnEgdXNpbmcgbmFtZSBpcyBOT1QgZmF0
YWwgYXMgZHJpdmVyIHdpbGwgdXNlIGluZGV4IHRvDQo+ID4gZ2V0IGlycSBpbnN0ZWFkLCB1c2Ug
cGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0aW9uYWwoKSBpbnN0ZWFkIG9mDQo+ID4gcGxhdGZv
cm1fZ2V0X2lycV9ieW5hbWUoKSB0byBhdm9pZCBiZWxvdyBlcnJvciBtZXNzYWdlIGR1cmluZw0K
PiA+IHByb2JlOg0KPiA+DQo+ID4gWyAgICAwLjgxOTMxMl0gZmVjIDMwYmUwMDAwLmV0aGVybmV0
OiBJUlEgaW50MCBub3QgZm91bmQNCj4gPiBbICAgIDAuODI0NDMzXSBmZWMgMzBiZTAwMDAuZXRo
ZXJuZXQ6IElSUSBpbnQxIG5vdCBmb3VuZA0KPiA+IFsgICAgMC44Mjk1MzldIGZlYyAzMGJlMDAw
MC5ldGhlcm5ldDogSVJRIGludDIgbm90IGZvdW5kDQo+ID4NCj4gPiBGaXhlczogNzcyM2Y0YzVl
Y2RiICgiZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBBZGQgYW4gZXJyb3IgbWVzc2FnZSB0bw0KPiA+
IHBsYXRmb3JtX2dldF9pcnEqKCkiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEFuc29uIEh1YW5nIDxB
bnNvbi5IdWFuZ0BueHAuY29tPg0KPiANCj4gSGkgQW5zb24sDQo+IA0KPiBsb29rcyBsaWtlIHRo
ZXJlIG1heSBiZSBzb21lIGRlcGVuZGVuY3kgd2hpY2ggaGF2ZW4ndCBsYW5kZWQgaW4gdGhlDQo+
IG5ldHdvcmtpbmcgdHJlZSB5ZXQ/ICBCZWNhdXNlIHRoaXMgZG9lc24ndCBidWlsZDoNCj4gDQo+
IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jOiBJbiBmdW5jdGlvbiDi
gJhmZWNfcHJvYmXigJk6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFp
bi5jOjM1NjE6OTogZXJyb3I6IGltcGxpY2l0IGRlY2xhcmF0aW9uDQo+IG9mIGZ1bmN0aW9uIOKA
mHBsYXRmb3JtX2dldF9pcnFfYnluYW1lX29wdGlvbmFs4oCZOyBkaWQgeW91IG1lYW4NCj4g4oCY
cGxhdGZvcm1fZ2V0X2lycV9vcHRpb25hbOKAmT8gWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24t
ZGVjbGFyYXRpb25dDQo+ICAzNTYxIHwgICBpcnEgPSBwbGF0Zm9ybV9nZXRfaXJxX2J5bmFtZV9v
cHRpb25hbChwZGV2LCBpcnFfbmFtZSk7DQo+ICAgICAgIHwgICAgICAgICBefn5+fn5+fn5+fn5+
fn5+fn5+fn5+fn5+fn5+fn5+fg0KPiAgICAgICB8ICAgICAgICAgcGxhdGZvcm1fZ2V0X2lycV9v
cHRpb25hbA0KPiBjYzE6IHNvbWUgd2FybmluZ3MgYmVpbmcgdHJlYXRlZCBhcyBlcnJvcnMNCj4g
DQo+IENvdWxkIHlvdSBwbGVhc2UgcmVwb3N0IG9uY2UgdGhhdCdzIHJlc29sdmVkPyAgUGxlYXNl
IGFkZCBBbmR5J3MgYW5kDQo+IFN0ZXBoZW4ncyBhY2tzIHdoZW4gcmVwb3N0aW5nLg0KPiANCj4g
VGhhbmsgeW91IQ0KDQpTb3JyeSwgSSBkaWQgdGhpcyBwYXRjaCBzZXQgYmFzZWQgb24gbGludXgt
bmV4dCB0cmVlLCB0aGUgYmVsb3cgcGF0Y2ggaXMgbGFuZGluZw0Kb24gTGludXgtbmV4dCB0cmVl
IG9uIE9jdCA1dGgsIHNvIG1heWJlIG5ldHdvcmsgdHJlZSBpcyBOT1Qgc3luYyB3aXRoIExpbnV4
LW5leHQgdHJlZT8NCkkgc2F3IG1hbnkgb3RoZXIgc2ltaWxhciBwYXRjaGVzIGFyZSBhbHJlYWR5
IGxhbmRpbmcgb24gTGludXgtbmV4dCB0cmVlIGFsc28sIHNvIHdoYXQNCmRvIHlvdSBzdWdnZXN0
IEkgc2hvdWxkIGRvPyBPciBjYW4geW91IHN5bmMgdGhlIG5ldHdvcmsgdHJlZSB3aXRoIExpbnV4
LW5leHQgdHJlZSBmaXJzdD8gSSBkbw0KTk9UIGtub3cgdGhlIHJ1bGUvc2NoZWR1bGUgb2YgbmV0
d29yayB0cmVlIHVwZGF0ZSB0byBMaW51eC1uZXh0Lg0KDQpjb21taXQgZjFkYTU2N2YxZGMxYjU1
ZDE3OGI4ZjJkMGNmZTgzNTM4NThhYWMxOQ0KQXV0aG9yOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2Vk
ZUByZWRoYXQuY29tPg0KRGF0ZTogICBTYXQgT2N0IDUgMjM6MDQ6NDcgMjAxOSArMDIwMA0KDQog
ICAgZHJpdmVyIGNvcmU6IHBsYXRmb3JtOiBBZGQgcGxhdGZvcm1fZ2V0X2lycV9ieW5hbWVfb3B0
aW9uYWwoKQ0KDQp0aGFua3MsDQpBbnNvbg0KDQo=
