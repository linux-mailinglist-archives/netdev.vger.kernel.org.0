Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DE31D2A80
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgENIml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:42:41 -0400
Received: from mail-vi1eur05on2078.outbound.protection.outlook.com ([40.107.21.78]:31520
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725925AbgENImk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 04:42:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5FTjEr7pOBLgGwM4iWMFeZrp6Dz9dfgYpN7uzzCG+uWpmY+jBWOPlVlY9dRjqmphlfCFreGrADEdmRlxYhsVOFZVlzvMSWmIAGXATfbS8Sie1zANviYWYpfEp0zqYKFSEJrjgtjCHX4ftuS2yNp9ua5Fdn+Ga4qrOR/+7stql5ua3z5FEnJuGE7B97WfAOytams6ttBA5SgFgqOCrDweWLRflyfSLoD0zKZk0D/aeGI07awj1t9yi4AfLispirRIj0JE8eIJGiK+Fnqr5lMDxZ6LLFNSuqlmt3ihdinrwtOlrmIrqj+nbvWmRcT8N5bxa6uUTqV9Nze8BbCkoLRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm1C/435XfBfeBahxRQxAnqCwBS63DPDFx+3ltmHuIs=;
 b=TON8YTUY8NBBWgALIbORxBnLmvPO2M/BpeTre2YGQDxd4XC6Tj0ZP5BJ+7OS0K+jNNJwQKeXAPmPt4nTKHgSrvsC1bibTwpxwNLvfVPDyU9GRe2lDIAUd52Z83GrtM3oTFh/5kNfslQ0P80VAZbnJyLcGQOf43ZMksTQNI+56d0j/Bmu/JgiZr7xVe+UxI63Bqjd5iQnaivhihX825vvnhuSs2Coe+IEPwREDHkwX/sUe47X2grlzBzp8981Or5E5WJ7V1ettkdssEPLJ8cvJmsRC/gnzwOtYmuMFPSeItRMHqm9s7vcNjIP8JiYQvw+XZ5aPg75TW7mJkoL0Avyiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm1C/435XfBfeBahxRQxAnqCwBS63DPDFx+3ltmHuIs=;
 b=LHeO1lTDBaK4WTlPtmk1aAMJ07XADWE9A0fL75xlY6sbgtzPa3NVvMROzEbLLxjFJsBXh7FxtFVMSj21VtsLMWi4pMOMvafHcXAJEbPB2mrCnxQnFmn4Op1PGpWCPHPGhAmTLbF79DnVJNSnz6WRkUsIcV01i39vX9uDCtJDHfY=
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13)
 by AM0PR04MB6370.eurprd04.prod.outlook.com (2603:10a6:208:16a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Thu, 14 May
 2020 08:42:34 +0000
Received: from AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00]) by AM0PR04MB7041.eurprd04.prod.outlook.com
 ([fe80::1cab:2a78:51cb:2a00%9]) with mapi id 15.20.2979.033; Thu, 14 May 2020
 08:42:34 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: Re: signal quality and cable diagnostic
Thread-Topic: signal quality and cable diagnostic
Thread-Index: AdYpy5i0AdWtQEK3R0eXdQs+ArOQrA==
Date:   Thu, 14 May 2020 08:42:34 +0000
Message-ID: <AM0PR04MB7041E1F0913A90F40DFB31A386BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [88.130.52.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 71c2409e-a3ab-49b8-3ed0-08d7f7e2bf87
x-ms-traffictypediagnostic: AM0PR04MB6370:
x-microsoft-antispam-prvs: <AM0PR04MB6370297786BE4BAF456BF83F86BC0@AM0PR04MB6370.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cvisnyVcwp4xdWGHs137uWcSMY9QHPjEJ5iGdPSXlyfD6DZWKqhTFugFCQOg0bWbuxhXpl5J8am1V54mBHYaNXFYY5+/fYRhXFwge2ORceLg/TlXUmgRDNrkKCqH9NigaRP4UT/jPLNeheHE11H3yU0GPl3mD2p1JfPS7MyunEh+QDwzvuhstUBpMrBHgDA/N1KhXlbkNtmgjNdDDGvjGg3prEOPHYfzZdhBVaD9mC9gJ/xZOm38d7/w3xmiXcFlqX8TuClhHHharkn0SeFUD6U9ii6qNjRSM+5MRvIVYZA92PPw77LisHjRIDl4yGU6jcVumu35sW3x8vJp463lQGtCoNfECysLwblTw6yYo/1O6MNo2JwUzsKVk8O/HEeikid8JVlmVDgWxFlFKsaMe0fvewJCo1xrFidJAYraRbemrfusZg279Qc4ywO0too/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB7041.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(9686003)(55016002)(478600001)(54906003)(8936002)(8676002)(316002)(7416002)(186003)(86362001)(2906002)(52536014)(7696005)(4326008)(64756008)(76116006)(66446008)(66946007)(66556008)(66476007)(44832011)(71200400001)(6916009)(5660300002)(6506007)(26005)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HrYqciLibJ9C8/0j0UDlyTqyBCGLLbGaJ3h489g+5OeV+P7F01ZfZtd9oCc1eAZjIdSNaKSsWwI/QB5rQOKCDbowc7uTCIoY0idzfbYCRhPRwjK659E3P3Szifqy6IliD4zDOtJ7EKYiRBa3o/Z2YgeKrDsT/4IDaIL9wx6ieT2S5oZi+rHCoRFV/wQNYlbBSEi6GbLMEQr6xkh8oc71q08KCH1YUqdFTwYJhsM4uRD+nGrvvfoiH8ICvC6FdnQHPNafoN9Lh4zbSb8hO05uFNHD/Soyir8Iqf99s9vKG4XmZJNrKTNBKsgezQ/HyCM0GM19jO3/vJh6zsu0VZzBeyEnbSwPmVGgD7hqEXdsaQ6Gm3jtY7thOMrM11X0aMV23ITMXjiUzEZv6Ja84rmVgggYz6ycFINgFebfbqS6XNP/TLV0TC9cV2vgFMRgAm5+CHT2B2Mq8Kr+7s+4rq8/+uYgBQj/dP3PSP0USrBZzPg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c2409e-a3ab-49b8-3ed0-08d7f7e2bf87
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 08:42:34.3459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbdMH9BP4X63e9ojA9/0Mc1MsVfshBc0bxeCkAgtYnX6RnVWXyg484tssUPuH0Lc+7K9zWSPRNu5Y8Fxky7HVGHZ749HXRFmXda0DzH1+3o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6370
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBNYXkgMTQsIDIwMjAgYXQgMDg6Mjg6MDBBTSArMDAwMCwgT2xla3NpaiBSZW1wZWwg
d3JvdGU6DQo+IE9uIFRodSwgTWF5IDE0LCAyMDIwIGF0IDA3OjEzOjMwQU0gKzAwMDAsIENocmlz
dGlhbiBIZXJiZXIgd3JvdGU6DQo+ID4gT24gVHVlLCBNYXkgMTIsIDIwMjAgYXQgMTA6MjI6MDFB
TSArMDIwMCwgT2xla3NpaiBSZW1wZWwgd3JvdGU6DQo+ID4NCj4gPiA+IFNvIEkgdGhpbmsgd2Ug
c2hvdWxkIHBhc3MgcmF3IFNRSSB2YWx1ZSB0byB1c2VyIHNwYWNlLCBhdCBsZWFzdCBpbiB0aGUN
Cj4gPiA+IGZpcnN0IGltcGxlbWVudGF0aW9uLg0KPiA+DQo+ID4gPiBXaGF0IGRvIHlvdSB0aGlu
ayBhYm91dCB0aGlzPw0KPiA+DQo+ID4gSGkgT2xla3NpaiwNCj4gPg0KPiA+IEkgaGFkIGEgY2hl
Y2sgYWJvdXQgdGhlIGJhY2tncm91bmQgb2YgdGhpcyBTUUkgdGhpbmcuIFRoZSB0YWJsZSB5b3Ug
cmVmZXJlbmNlIHdpdGggY29uY3JldGUgU05SIHZhbHVlcyBpcyBpbmZvcm1hdGl2ZSBvbmx5IGFu
ZCBub3QgYSByZXF1aXJlbWVudC4gVGhlIHJlcXVpcmVtZW50cyBhcmUgcmF0aGVyIGxvb3NlLg0K
PiA+DQo+ID4gVGhpcyBpcyBmcm9tIE9BOg0KPiA+IC0gT25seSBmb3IgU1FJPTAgYSBsaW5rIGxv
c3Mgc2hhbGwgb2NjdXIuDQo+ID4gLSBUaGUgaW5kaWNhdGVkIHNpZ25hbCBxdWFsaXR5IHNoYWxs
IG1vbm90b25pYyBpbmNyZWFzaW5nIC9kZWNyZWFzaW5nIHdpdGggbm9pc2UgbGV2ZWwuDQo+ID4g
LSBJdCBzaGFsbCBiZSBpbmRpY2F0ZWQgaW4gdGhlIGRhdGFzaGVldCBhdCB3aGljaCBsZXZlbCBh
IEJFUjwxMF4tMTAgKGJldHRlciB0aGFuIDEwXi0xMCkgaXMgYWNoaWV2ZWQgKGUuZy4gImZyb20g
U1FJPTMgdG8gU1FJPTcgdGhlIGxpbmsgaGFzIGEgQkVSPDEwXi0xMCAoYmV0dGVyIHRoYW4gMTBe
LTEwKSIpDQo+ID4NCj4gPiBJLmUuIFNRSSBkb2VzIG5vdCBuZWVkIHRvIGhhdmUgYSBkaXJlY3Qg
Y29ycmVsYXRpb24gd2l0aCBTTlIuIFRoZSBmdW5kYW1lbnRhbCB1bmRlcmx5aW5nIG1ldHJpYyBp
cyB0aGUgQkVSLg0KPiA+IFlvdSBjYW4gcmVwb3J0IHRoZSByYXcgU1FJIGxldmVsIGFuZCB1c2Vy
cyB3b3VsZCBoYXZlIHRvIGxvb2sgdXAgd2hhdCBpdCBtZWFucyBpbiB0aGUgcmVzcGVjdGl2ZSBk
YXRhIHNoZWV0LiBUaGVyZSBpcyBubyBndWFyYW50ZWVkIHJlbGF0aW9uIGJldHdlZW4gU1FJIGxl
dmVscyBvZiBkaWZmZXJlbnQgZGV2aWNlcywgaS5lLiBTUUkgNSBjYW4gaGF2ZSBsb3dlciBCRVIg
dGhhbiBTUUkgNiBvbiBhbm90aGVyIGRldmljZS4NCj4gPiBBbHRlcm5hdGl2ZWx5LCB5b3UgY291
bGQgcmVwb3J0IEJFUiA8IHggZm9yIHRoZSBkaWZmZXJlbnQgU1FJIGxldmVscy4gSG93ZXZlciwg
dGhpcyByZXF1aXJlcyB0aGUgaW5mb3JtYXRpb24gdG8gYmUgYXZhaWxhYmxlLiBXaGlsZSBJIGNv
dWxkIHByb3ZpZGUgdGhlc2UgZm9yIE5YUCwgaXQgbWlnaHQgbm90IGJlIGVhc2lseSBhdmFpbGFi
bGUgZm9yIG90aGVyIHZlbmRvcnMuDQo+ID4gSWYgcmVwb3J0aW5nIHJhdyBTUUksIGF0IGxlYXN0
IHRoZSBTUUkgbGV2ZWwgZm9yIEJFUjwxMF4tMTAgc2hvdWxkIGJlIHByZXNlbnRlZCB0byBnaXZl
IGFueSBtZWFuaW5nIHRvIHRoZSB2YWx1ZS4NCg0KPiBTbyB0aGUgcXVlc3Rpb24gaXMsIHdoaWNo
IHZhbHVlcyB0byBwcm92aWRlIHZpYSBLQVBJIHRvIHVzZXIgc3BhY2U/DQo+DQo+IC0gU1FJDQo+
ICBUaGUgUEhZIGNhbiBwcm9iYWJseSBtZWFzdXJlIHRoZSBTTlIgcXVpdGUgZmFzdCBhbmQgaGFz
IHNvbWUgaW50ZXJuYWwNCj4gICBmdW5jdGlvbiBvciBsb29rdXAgdGFibGUgdG8gZGVkdWN0IHRo
ZSBTUUkgZnJvbSB0aGUgbWVhc3VyZWQgU05SLg0KPg0KPiAgIElmIEkgdW5kZXJzdGFuZCB5b3Ug
Y29ycmVjdGx5LCB3ZSBjYW4gb25seSBjb21wYXJlIFNRSSB2YWx1ZXMgb2YgdGhlDQo+ICAgc2Ft
ZSBQSFksIGFzIGRpZmZlcmVudCBQSFlzIGdpdmUgZGlmZmVyZW50IFNRSXMgZm9yIHRoZSBzYW1l
IGxpbmsNCj4gICBjaGFyYWN0ZXJpc3RpY3MgKD1TTlIpLg0KPiAtIFNOUiByYW5nZQ0KPiAgIFdl
IHJlYWQgdGhlIFNRSSBmcm9tIHRoZSBQSFkgbG9vayB1cCB0aGUgU05SIHJhbmdlIGZvciB0aGF0
IHZhbHVlIGZyb20NCj4gIHRoZSBkYXRhIHNoZWV0IGFuZCBwcm92aWRlIHRoYXQgdmFsdWUgdG8g
dXNlIHNwYWNlLiBUaGlzIGdpdmVzIGENCj4gICBiZXR0ZXIgZGVzY3JpcHRpb24gb2YgdGhlIHF1
YWxpdHkgb2YgdGhlIGxpbmsuDQo+IC0gImd1ZXN0aW1hdGVkIiBCRVINCj4gICBUaGUgbWFudWZh
Y3R1cmVyIG9mIHRoZSBQSFkgaGFzIHByb2JhYmx5IGRvbmUgc29tZSBleHRlbnNpdmUgdGVzdGlu
Zw0KPiAgIHRoYXQgYSBtZWFzdXJlZCBTTlIgY2FuIGJlIGNvcnJlbGF0ZWQgdG8gc29tZSBCRVIu
IFRoaXMgdmFsdWUgbWF5IGJlDQo+ICAgcHJvdmlkZWQgaW4gdGhlIGRhdGEgc2hlZXQsIHRvby4N
Cj4NCj4gVGhlIFNOUiBzZWVtcyB0byBiZSBtb3N0IHVuaXZlcnNhbCB2YWx1ZSwgd2hlbiBpdCBj
b21lcyB0byBjb21wYXJpbmcNCj4gZGlmZmVyZW50IHNpdHVhdGlvbnMgKGRpZmZlcmVudCBsaW5r
cyBhbmQgZGlmZmVyZW50IFBIWXMpLiBUaGUNCj4gcmVzb2x1dGlvbiBvZiBCRVIgaXMgbm90IHRo
YXQgZGV0YWlsZWQsIGZvciB0aGUgTlhQIFBIWSBpcyBzYXlzIG9ubHkNCj4gIkJFUiBiZWxvdyAx
ZS0xMCIgb3Igbm90Lg0KDQpUaGUgcG9pbnQgSSB3YXMgdHJ5aW5nIHRvIG1ha2UgaXMgdGhhdCBT
UUkgaXMgaW50ZW50aW9uYWxseSBjYWxsZWQgU1FJIGFuZCBOT1QgU05SLCBiZWNhdXNlIGl0IGlz
IG5vdCBhIG1lYXN1cmUgZm9yIFNOUi4gVGhlIHN0YW5kYXJkIG9ubHkgc3VnZ2VzdCBhIG1hcHBp
bmcgb2YgU05SIHRvIFNRSSwgYnV0IHZlbmRvcnMgZG8gbm90IG5lZWQgdG8gY29tcGx5IHRvIHRo
YXQgb3IgcmVwb3J0IHRoYXQuIFRoZSBvbmx5IG1hbmRhdG9yeSByZXF1aXJlbWVudCBpcyBsaW5r
aW5nIHRvIEJFUi4gQkVSIGlzIGFsc28gd2hhdCB3b3VsZCBiZSByZXF1aXJlZCBieSBhIHVzZXIs
IGFzIHRoaXMgaXMgdGhlIG1ldHJpYyB0aGF0IGRldGVybWluZXMgd2hhdCBoYXBwZW5zIHRvIHlv
dXIgdHJhZmZpYywgbm90IHRoZSBTTlIuDQoNClNvIHdoZW4gaXQgY29tZXMgdG8gS0FQSSBwYXJh
bWV0ZXJzLCBJIHNlZSB0aGUgZm9sbG93aW5nIG9wdGlvbnMNCi0gU1FJIG9ubHkNCi0gU1FJICsg
cGx1cyBpbmRpY2F0aW9uIG9mIFNRSSBsZXZlbCBhdCB3aGljaCBCRVI8MTBeLTEwICh0aGlzIGlz
IHRoZSBvbmx5IHJlcXVpcmVkIGFuZCBzdGFuZGFyZGl6ZWQgaW5mb3JtYXRpb24pDQotIFNRSSAr
IEJFUiByYW5nZSAoYmVzdCBmb3IgdXNlcnMsIGJ1dCByZXF1aXJlcyBpbnB1dCBmcm9tIHRoZSBz
aWxpY29uIHZlbmRvcnMpDQoNClNOUiBpbiBteSBvcGluaW9uIGlzIG5laXRoZXIgYW4gb3B0aW9u
IG5vciBoZWxwZnVsLg0KDQpSZWdhcmRzLA0KDQpDaHJpc3RpYW4NCg0K
