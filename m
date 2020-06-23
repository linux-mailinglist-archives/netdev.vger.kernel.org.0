Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D44205169
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732499AbgFWLzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:55:44 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:49838
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732393AbgFWLzn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 07:55:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bk3KCschqQU8oAAfdiNfoZ2x0ZAHsyM968iMO50nUm6eIVEmLMPWxrwY5FSCmKYa+tSzXrSYJBRr8Aq0r1bFlYyE5hrJEODXEtkxSvFRWEOiFaN9ZE2gZgz+2l7l+s7ssZ4gJFmCTsJEUxK66PO3MApIjRNZqKitBfnUyyLXheSqQYqCoY7rNSMVO3X+GCJlMVvdKgDtRrkdyGpuQ7ulu/4aR4Q1q/EHwawZ3ic+CuDlmtuTShBI3HKp9OrVu3OZ+ONvT3Y4Vavjw0BZCUFwYrknCj6VKynb0OY11W2YgmZWks3G2IDuKOXvXo8F89ML3GMI57+AQt1NeIqswUi/Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXfzYR8YKjIVvJ7wd4zF7Diy8s/O9qLSpSiMW9Q8Z+Y=;
 b=nCW7d/trlzKvfUPWb5LRlz7dLWOSJn2kwdzZfCp7LMGOBPzFM20izGuo+uL0l0t5dGdxrErH8Zd3e+4PTBX2uwFwD0YBqBO+KG2Tfb+io2b89zLfyanvuKtm1tb5oyz36GHk74zal51EbsipIbXxjJrqBeCvuDJZ99jyF58QvRwac968gDIH4PURJsYrp0Y6XGGJj77Mw4ryBBWCdLGmcq3N3pcZcobw/oe8G7kEjwrg6l91w0J/mHh339zQlPnfLzyIS9YPhQnAoTaV1OLZlSxoWYVwNKfReuTLbSynSorFasKJmYGUSRrb78W6uUwxiaOjoia93hyKDigdFc+C7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tXfzYR8YKjIVvJ7wd4zF7Diy8s/O9qLSpSiMW9Q8Z+Y=;
 b=JBvzHVzK1ek4TO9LzacQIqg2EFaocrlpA6jle6OoF94Dn3nFxBu1Oa0jCcd625u+rOE8uc/NO6eW+Ey0im0BPbF74hRmxxy0ihinQiDFcTg1nUWbTDcpwT6zgEjD6pUGihl1XqhTcSFO5DyVsOMwE9u47gcNYhAE8959qsMHoY8=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6765.eurprd04.prod.outlook.com (2603:10a6:803:126::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Tue, 23 Jun
 2020 11:55:38 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::c1ea:5943:40e8:58f1%3]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 11:55:38 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "vlad@buslov.dev" <vlad@buslov.dev>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Edward Cree <ecree@solarflare.com>
Subject: RE:  Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Topic: Re: [v1,net-next 3/4] net: qos: police action add index for tc
 flower offloading
Thread-Index: AdZJSMFCe+jMFUekSzejKc1wm1DKtA==
Date:   Tue, 23 Jun 2020 11:55:37 +0000
Message-ID: <VE1PR04MB64965F4F28439370BC53539A92940@VE1PR04MB6496.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.221.90.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b4203a08-8ff0-4dfc-488a-08d8176c5883
x-ms-traffictypediagnostic: VE1PR04MB6765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6765297831AF5A066F64892492940@VE1PR04MB6765.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YEFq/7pps93RRbWvXc71OY5XDSVmHkhr64DRIEM+vhgW2ZcDlM6j/vcnKpYXntht5Y219XOjNPwMvKd1U2aacIrcMKZVHtG5l4n/O8DPhd1hkU1KG4fl1Iu4v6pxhUYJWLRKwU5AuzGz5LovCgLtegx+QjJkdd/h2/D5bq0AIYvN/9jAYHO1HoyiwCxxo+Ol8HhNGVhk746QXMkhUJEdOkY0eTWt/0+6a/4Al2Eypmw5i/AmbZ+SCVrsSx0mSpnPDNdRtJTzFNMKYtWW4NozW6ZRujKfK+mU4gzMPtvwj3j0e0dLmmp2pe/pbufs+E9Bkc/nW4OVBB8wtho+S1z4zg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(33656002)(86362001)(9686003)(2906002)(66556008)(66476007)(55016002)(66446008)(64756008)(44832011)(498600001)(66946007)(76116006)(5660300002)(110136005)(54906003)(26005)(186003)(52536014)(53546011)(8936002)(6506007)(8676002)(7696005)(83380400001)(4326008)(71200400001)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: f1iCMRgYFVMsXVbWCCfS/EwwRRy9f4HSJ8NUgYpACV8q6ilpw21H7FfsoV+MZ9qP7kYe0bCOiqvkfAN/05/YMuudMowcVlFE1wXeyqOs4uz8Xa206b31TqjXi7d9HG09O+SXqJ12TPbMcLRML4ZN5oXLevatVW062rKJzYXDhuzgPBOkNpdM4X+hr54gx1qe3Z3ZyvKMqXYFrFV6AnWv5hkgujtpS+ycOzFxFmqNI7HtWHddD3JmxWGYJOW6bEAIv9UYogbJAWfoYtge+nzvtwdPjyXU/og3AOsckpRRAtLVuK0gfGWkutFkxDtM6Ac51FIBVkvVVvKBH+XUmBBRTCCflfIHcDx0tiRcZjkMKSMGeDfrlMBjRjdhObZzmE6mhddeQ34XrEp8NRj9e8QzrtmjhS6Tkp0aa7FuDE2X0WY4/dotm9RHOgRat5iBX7IBGQ11tRy4aRaPdeI5YcohbNt53G0GwbMlBBRRtSsAVxEJE1uf35Lb26fHE1dhkGmb
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4203a08-8ff0-4dfc-488a-08d8176c5883
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 11:55:38.0081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P+KH9mU3pCdFAAPWSWAI6X9g4cYKfyZegTxxiigjByxPDF3OQfxcS3Q7Bus8BvyV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6765
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWwsDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKYW1h
bCBIYWRpIFNhbGltIDxqaHNAbW9qYXRhdHUuY29tPg0KPiBTZW50OiAyMDIw5bm0NuaciDIz5pel
IDE4OjA5DQo+IFRvOiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dDsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGlkb3NjaEBpZG9zY2gub3JnDQo+IENjOiBqaXJpQHJlc251bGxpLnVzOyB2aW5pY2l1cy5n
b21lc0BpbnRlbC5jb207IHZsYWRAYnVzbG92LmRldjsgQ2xhdWRpdQ0KPiBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQG54cC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBu
eHAuY29tPjsgQWxleGFuZHJ1IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAu
Y29tPjsgbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTsNCj4gdmlzaGFsQGNoZWxzaW8uY29tOyBz
YWVlZG1AbWVsbGFub3guY29tOyBsZW9uQGtlcm5lbC5vcmc7DQo+IGppcmlAbWVsbGFub3guY29t
OyBpZG9zY2hAbWVsbGFub3guY29tOw0KPiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsg
VU5HTGludXhEcml2ZXJAbWljcm9jaGlwLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyB4aXlvdS53
YW5nY29uZ0BnbWFpbC5jb207DQo+IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOyBwYWJsb0Bu
ZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJpMkB0aS5jb207
DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29ya3BsdW1iZXIu
b3JnOyBFZHdhcmQNCj4gQ3JlZSA8ZWNyZWVAc29sYXJmbGFyZS5jb20+DQo+IFN1YmplY3Q6IFJl
OiBbdjEsbmV0LW5leHQgMy80XSBuZXQ6IHFvczogcG9saWNlIGFjdGlvbiBhZGQgaW5kZXggZm9y
IHRjDQo+IGZsb3dlciBvZmZsb2FkaW5nDQo+IA0KPiANCj4gVGhpcyBjZXJ0YWlubHkgYnJpbmdz
IGFuIGludGVyZXN0aW5nIHBvaW50IHdoaWNoIGkgYnJvdWdodCB1cCBlYXJsaWVyIHdoZW4NCj4g
SmlyaSB3YXMgZG9pbmcgb2ZmbG9hZGluZyBvZiBzdGF0cy4NCj4gSW4gdGhpcyBjYXNlIHRoZSBh
Y3Rpb24gaW5kZXggaXMgYmVpbmcgdXNlZCBhcyB0aGUgb2ZmbG9hZGVkIHBvbGljZXIgaW5kZXgN
Cj4gKG5vdGU6IHRoZXJlJ2QgbmVlZCB0byBiZSBhIGNoZWNrIHdoZXRoZXIgdGhlIGluZGV4IGlz
IGluZmFjdCBhY2NlcHRhYmxlIHRvDQo+IHRoZSBoL3cgZXRjIHVubGVzcyB0aGVyZQ0KPiAyXjMy
IG1ldGVycyBhdmFpbGFibGUgaW4gdGhlIGhhcmR3YXJlKS4NCg0KWWVzLCBkZXZpY2Ugc2hvdWxk
IHJlcG9ydCBpbnZhbGlkIGlmIGluZGV4IGlzIG91dCBvZiByYW5nZSB3aGljaCBtZWFucyBoYXJk
d2FyZSBub3Qgc3VwcG9ydC4NCg0KPiANCj4gTXkgcXVlc3Rpb246IElzIHRoaXMgYW55IGRpZmZl
cmVudCBmcm9tIGhvdyBzdGF0cyBhcmUgc3RydWN0dXJlZD8NCg0KSSBkb24ndCBrbm93IEkgZnVs
bHkgY2F0Y2ggdGhlIHF1ZXN0aW9uLiBBcmUgeW91IHRyeWluZyB0byBnZXQgaG93IG1hbnkgZnJh
bWVzIGZvciBlYWNoIGZpbHRlciBjaGFpbiBwYXNzaW5nIG9uZSBpbmRleCBwb2xpY2luZyBhY3Rp
b24/IA0KSWYgb25lIGluZGV4IHBvbGljZSBhY3Rpb24gYmluZCB0byBtdWx0aXBsZSB0YyBmaWx0
ZXIodGhleSBzaG91bGQgaGF2ZSBkaWZmZXJudCBjaGFpbiBpbmRleCApLiBBbGwgdGhvc2UgZmls
dGVyIHNob3VsZCBnZXQgc2FtZSBpbmRleCBwb2xpY2UgYWN0aW9uIHN0YXRzIHZhbHVlIHNpbmNl
IHRoZXkgYXJlIHNoYXJpbmcgdGhlIHNhbWUgaGFyZHdhcmUgZW50cnkuIEJ1dCBJIGRvbid0IHRo
aW5rIHRoaXMgaXMgdGhlIHByb2JsZW0uDQoNCldpdGggaW5kZXggcHJvdmlkZSB0byBkZXZpY2Ug
ZHJpdmVyKG1hcCB0aGUgcy93IGFjdGlvbiBpbmRleCB0byBhIGgvdyB0YWJsZSBpbmRleCApLCB1
c2VyIGNvdWxkIGxpc3QgdGhlIHBvbGljZSBhY3Rpb25zIGxpc3QgYnkgY29tbWFuZDoNCiMgdGMg
YWN0aW9ucyBzaG93IGFjdGlvbiBwb2xpY2UNClNob3dzIHRoZSBwb2xpY2UgYWN0aW9uIHRhYmxl
IGJ5IGluZGV4Lg0KVGhhbmtzIQ0KDQo+IEluIHRoaXMgY2FzZSB5b3UgY2FuIG1hcCB0aGUgcy93
IGFjdGlvbiBpbmRleCB0byBhIGgvdyB0YWJsZSBpbmRleCAob2YNCj4gbWV0ZXJzKS4NCj4gTXkg
Y29tbWVudCB0aGVuIHdhczogaGFyZHdhcmUgaSBoYXZlIGVuY291bnRlcmVkIChhbmQgaSBwb2lu
dGVkIHRvIFA0DQo+IG1vZGVsIGFzIHdlbGwpIGFzc3VtZXMgYW4gaW5kZXhlZCB0YWJsZSBvZiBz
dGF0cy4NCj4gDQo+IGNoZWVycywNCj4gamFtYWwNCj4gDQo+IE9uIDIwMjAtMDYtMjMgMjozNCBh
Lm0uLCBQbyBMaXUgd3JvdGU6DQo+ID4gRnJvbTogUG8gTGl1IDxQby5MaXVAbnhwLmNvbT4NCj4g
Pg0KPiA+IEhhcmR3YXJlIG1heSBvd24gbWFueSBlbnRyaWVzIGZvciBwb2xpY2UgZmxvdy4gU28g
dGhhdCBtYWtlIG9uZShvcg0KPiA+ICAgbXVsdGkpIGZsb3cgdG8gYmUgcG9saWNlZCBieSBvbmUg
aGFyZHdhcmUgZW50cnkuIFRoaXMgcGF0Y2ggYWRkIHRoZQ0KPiA+IHBvbGljZSBhY3Rpb24gaW5k
ZXggcHJvdmlkZSB0byB0aGUgZHJpdmVyIHNpZGUgbWFrZSBpdCBtYXBwaW5nIHRoZQ0KPiA+IGRy
aXZlciBoYXJkd2FyZSBlbnRyeSBpbmRleC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFBvIExp
dSA8UG8uTGl1QG54cC5jb20+DQo+ID4gLS0tDQo+ID4gICBpbmNsdWRlL25ldC9mbG93X29mZmxv
YWQuaCB8IDEgKw0KPiA+ICAgbmV0L3NjaGVkL2Nsc19hcGkuYyAgICAgICAgfCAxICsNCj4gPiAg
IDIgZmlsZXMgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmggYi9pbmNsdWRlL25ldC9mbG93X29mZmxvYWQuaA0K
PiA+IGluZGV4IGMyZWYxOWM2YjI3ZC4uZWVkOTgwNzViMWFlIDEwMDY0NA0KPiA+IC0tLSBhL2lu
Y2x1ZGUvbmV0L2Zsb3dfb2ZmbG9hZC5oDQo+ID4gKysrIGIvaW5jbHVkZS9uZXQvZmxvd19vZmZs
b2FkLmgNCj4gPiBAQCAtMjMyLDYgKzIzMiw3IEBAIHN0cnVjdCBmbG93X2FjdGlvbl9lbnRyeSB7
DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGJvb2wgICAgICAgICAgICAgICAgICAgIHRydW5j
YXRlOw0KPiA+ICAgICAgICAgICAgICAgfSBzYW1wbGU7DQo+ID4gICAgICAgICAgICAgICBzdHJ1
Y3QgeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyogRkxPV19BQ1RJT05fUE9MSUNF
ICovDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHUzMiAgICAgICAgICAgICAgICAgICAgIGlu
ZGV4Ow0KPiA+ICAgICAgICAgICAgICAgICAgICAgICBzNjQgICAgICAgICAgICAgICAgICAgICBi
dXJzdDsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgdTY0ICAgICAgICAgICAgICAgICAgICAg
cmF0ZV9ieXRlc19wczsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgdTMyICAgICAgICAgICAg
ICAgICAgICAgbXR1Ow0KPiA+IGRpZmYgLS1naXQgYS9uZXQvc2NoZWQvY2xzX2FwaS5jIGIvbmV0
L3NjaGVkL2Nsc19hcGkuYyBpbmRleA0KPiA+IDZhYmE3ZDViYTFlYy4uZmRjNGM4OWNhMWZhIDEw
MDY0NA0KPiA+IC0tLSBhL25ldC9zY2hlZC9jbHNfYXBpLmMNCj4gPiArKysgYi9uZXQvc2NoZWQv
Y2xzX2FwaS5jDQo+ID4gQEAgLTM2NTksNiArMzY1OSw3IEBAIGludCB0Y19zZXR1cF9mbG93X2Fj
dGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24NCj4gKmZsb3dfYWN0aW9uLA0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICBlbnRyeS0+cG9saWNlLnJhdGVfYnl0ZXNfcHMgPQ0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHRjZl9wb2xpY2VfcmF0ZV9ieXRlc19wcyhhY3QpOw0KPiA+ICAg
ICAgICAgICAgICAgICAgICAgICBlbnRyeS0+cG9saWNlLm10dSA9IHRjZl9wb2xpY2VfdGNmcF9t
dHUoYWN0KTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgZW50cnktPnBvbGljZS5pbmRleCA9
IGFjdC0+dGNmYV9pbmRleDsNCj4gPiAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoaXNfdGNmX2N0
KGFjdCkpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgZW50cnktPmlkID0gRkxPV19BQ1RJ
T05fQ1Q7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgIGVudHJ5LT5jdC5hY3Rpb24gPSB0Y2Zf
Y3RfYWN0aW9uKGFjdCk7DQo+ID4NCg0KQnIsDQpQbyBMaXUNCg==
