Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134B93F484A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbhHWKJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:09:42 -0400
Received: from mail-eopbgr60105.outbound.protection.outlook.com ([40.107.6.105]:43122
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233322AbhHWKJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 06:09:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P5V5PJ0YWJmzEisodaHRagz5nf7/Ouyo4caYjhjtkK0SipUe3/MJ+NsWJjCs6/cPL3Vx9C8ByGXggW6hPJ2UceA4xwe8eMXQcXhMUtvDlBSulH+4y1u6pPFSlLxzEsKPR14WxOlg6qSsRQnTu3qfIvwNqtI++gwASoZtbwTCx2SSBF1+Km8bYcUoJDjW5twVgaUEXOSyduT7moOHc+TuGHnTiuu44t8vGA6I5Vq9APFqHhupTLPbtyF0XB6h+GtN9jnrebvVJBdkfxfdYONM7DuPTyzDojgCe7aRpANVVZODoCpFSHDMAwigDFcoupeDDTCaX1zSNLeqOCyF3tLLvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk3Jkfx+VUh01YaylY97ROqwv8UOPZPBswYfSgmYkas=;
 b=lz+VtVuR+2ugQ3rouM2PfAIky5VXEA/WbUcQ4stOfyQWJJpLany3X9cqwohpwwBu9YuIog1P/DyKjynh+c1Gj9wcye3iJuvmkNhX7jSdsqEvTCPyV0trhA+OCQt/d7hlrftIVNKLzJ613nbsBe1tqw+qJEBQRBiiwNYk8Ga6nO5dS+oZvWDH6pfivgHArpzZdsIxBZWO60pJO0xtICoYnLDA9qCC8XOZktVW5GiRqUHbSkV3Y811blLAMguf9h9QOLEevSwKpxJYR2XFg80L3NW4F8QtgVoeJMfvQLMxHckHnbKvRkZgl/qYJFrkVeZUZReptnYKpeQMYGITxir5Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rk3Jkfx+VUh01YaylY97ROqwv8UOPZPBswYfSgmYkas=;
 b=PeUnAzDV1nFPKtZALIQCDfWWniCNw9k5yfVr/T/iP7DG4dfeQGgSwnmPKCh/UldJt9AE6lNv6ASqLKWYphMxRa9ixzBCaGUgEqkfAOMMBDvLRA3uVbNKfKMefAqXH7JnYz8lIn74eW9+sadk6jm3b797EW3T7JbkEvhY0ftKK8A=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB3065.eurprd03.prod.outlook.com (2603:10a6:7:60::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4436.22; Mon, 23 Aug 2021 10:08:54 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::7cc8:2d4:32b3:320f%5]) with mapi id 15.20.4415.024; Mon, 23 Aug 2021
 10:08:54 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXl4yCe3G+ndzNv0qmlobhUV7pTauAJPMAgAAF4oCAAB5mgIAAlWyA
Date:   Mon, 23 Aug 2021 10:08:54 +0000
Message-ID: <eb43db6e-8d60-1b35-a921-e70034316bc3@bang-olufsen.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-5-alvin@pqrs.dk> <YSLX7qhyZ4YGec83@lunn.ch>
 <283675c4-90cf-6e5c-8178-5e3eba7592ba@bang-olufsen.dk>
 <YSL2XcUmb7PO5H0y@lunn.ch>
In-Reply-To: <YSL2XcUmb7PO5H0y@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ab6251d-0d0e-4f6b-7b81-08d9661e0390
x-ms-traffictypediagnostic: HE1PR03MB3065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR03MB306588EB5967A865A52A558183C49@HE1PR03MB3065.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Hsr2UbWIEfQV0dwvgz2zVRbcsu7t2tGf/DE8YFv1xxEuH6luflqHz7QGvkCg8xPK8xF+YQyqlGhiM7sm4YWkCQiAmWEfqoEht9VA2yZGxNqr9+lGZz1h9BUmTjd0k7frucsSfW7NirSHgQ6zkG9QUiJA5tOpB7p/2zq4IwZJQoUg5znEE+fo94UF35ptbgy8tbHrGX5/df5DstXoiy+5/N9g7E5NDbJY9KfPMhPwr4DgseR0gUFDsgxbJHXPjqUwk6nCpbrAsgOAOcIc0QAKSqK7qiQHKQcB8zR7BKL9hXVzSuKLB5bgaX+4HfoxsqSCOjn3tIsrob/fU9vK6VAlTzJIsGCMs8jkozk+5SvruXB0RkaM6k4RANgsaZjyJWsal7qbl58avBj0/gRfVoNU06wP34+bmR9Xp1WdMadewZ6dWB16+c4o8nLSyQ4z20rS/StQXj+MUAgFNgeEIt5SW25x0kMzIp26YXoao5tYnXJty6zpVU3r/UH+g8te1rUsBlCCfSxVaijyny9ipAgE/eT8kKK8+yldt65MPdAjuvlDcetQK+N8PYXXUuozmQ8PDS68rT0gLtlYkg6nJ2jOxyFYMYYIoUsOVlVJpw9A7UvdjOaLv0lxu4pL76h9i9NOevRmcxdu9SvcyLIywQ+N3nND88DlchSXr0KmOJyGi/YdiRE5V2mV336Exf0EC6TpO9OwI21bWK4ximkFKgSbqP+zhgNEJTFN3PqOSzmAZnxkfEOE/hxTPRupBDGp6MUnY7GgFnusOCPINgVMQJsA+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(2616005)(85202003)(508600001)(83380400001)(31686004)(53546011)(6506007)(6486002)(26005)(31696002)(186003)(8976002)(7416002)(86362001)(2906002)(38070700005)(8676002)(4326008)(85182001)(71200400001)(122000001)(38100700002)(76116006)(91956017)(316002)(6512007)(5660300002)(54906003)(66946007)(66476007)(64756008)(66446008)(66556008)(6916009)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmpDbTJIV2E1QUUzZlRvM1p1NjZTQ1ZwUmVmNmgxTHpPcG42aTN4WllLdVFi?=
 =?utf-8?B?T0gwK2I2RkxHMHBOaDlKOVd4QzBSWlBRai92cGdONjFsYTVnMElmajZHTHpM?=
 =?utf-8?B?a0NUaUxLOG9yeWs0MlladU1BcDZOZHRMdXZaVysycDFhMktMU0YwaUloNkdJ?=
 =?utf-8?B?c0hsN3pvcE5SWlZmSk90T04zRCtLMHRjd0hrWTY5VTJhR1NHbERuVENxY3Iz?=
 =?utf-8?B?Tis1Z2ZQR3g2VHRMMHhuVUFTNnFtZDJITVlQdzM0QkVYZVoxOFdXN0FPMytK?=
 =?utf-8?B?eUZpdk1xL2hreWZjaXRvRU1OUmg5S0JWYzl3bElGQTFpekczaWFkME9Beng5?=
 =?utf-8?B?OGNLRFRJdmE0UW5HcStEcDNDSzJ3QWpWS1liK2FhNXFxVjlvZk9aWnNnMjM0?=
 =?utf-8?B?Zit3eVlsRU55aEpKbFlEYnlFMWsvSHRuYUd4ank3OXJtRXR6SzVlc2xEVWtX?=
 =?utf-8?B?R0dDb2taYVFlcHdpN3BCS1YzTEMvajlmeUhySWdTN0hMTmNlVEpDcmJUeDJ2?=
 =?utf-8?B?VDFleml2di81UzZ0MUtUMk5pOHozQTI2K1NucUpaSncvN1pzeHNUSmZPNWFw?=
 =?utf-8?B?WTJYL3VaQ0F6VEY2dndnTFpTMGhQaFlIb2tTaUJQNWNxaDdYalkzaVVXUHRC?=
 =?utf-8?B?aEpRM2RSd2t1eTFIUE5acmFmQ2pGMDRnUWlvL0JkTUxoOWw3bmNkV0lRTEx5?=
 =?utf-8?B?TnlsdjM2SFZSTVdLY0luY09sYnJjamJsN0tQUmZNUVRQdWNuUWJUMC9BeVpR?=
 =?utf-8?B?bHJHcXVLS2ZGV1E2NjhmaitML3MwUEtmbFVwK3E3QjJtVUtucDZ0bU1KWGxy?=
 =?utf-8?B?MDZvNUtuM1ByQzhVSFkzWHpiaUg5dFN5ZDVET01rSnVCMEF6eHEzMjM3SkJm?=
 =?utf-8?B?cmxhMmtDTEhVYTl3SHo1TXA4V2YrU3pVa2tKN1VsenhkVHdlU3JWMmNqMFdI?=
 =?utf-8?B?b0QrZHQ2ci9JTFFRL0JBQ1RURmgxeVF5dzZZRmhSckFMVmYySStlM09RNng3?=
 =?utf-8?B?VnZLcHE0TFo1NmRGcHB5Um5IZ1lUVnVVT01tMkVDT1JjZ2FmU2hHZWNBam55?=
 =?utf-8?B?UjRvdWhsSGw1alQ0dE92ZVBYYnpPWThLRWg2THdjbWlaYUVtQjdldEx4ZnVO?=
 =?utf-8?B?elViM3ZGa2FyYUl2UlE4d1VCYm9wMnNNdnFMZGFNem9lbGpxemtKZExLUHhM?=
 =?utf-8?B?UjRzL3QzWFhLUGg3NFp5NVRDZElRaGMxOGc2TUZvbGxIbllKRjVmWWlRUFVD?=
 =?utf-8?B?SDVLQUErUUY2WmZCVWlrWElXYjNSVGpZS2NQbHBvakgycG5ISVdCWFBQS1dj?=
 =?utf-8?B?VC9OZno5S0JtOElXTXRqbGQ3YnE4enl6OFk0SmlNS0hRbWpPZVRYRzB4RmRH?=
 =?utf-8?B?ZkdpTUd3b1BwM1lEeHZnZHo4ZkNuaWtpYW1BUzBPUndiM2lvdDdzVTR0b0E2?=
 =?utf-8?B?NVVaMVBTZWFUNThHTkwvT3hrdVRZRWdGMlpWZHdmV2dUMHE3NVlBdTNmVjdU?=
 =?utf-8?B?MmxMNi8vZVdmclg3MDJLNEFxa2N2ajRQSFlGdEhaSHhETkJudGVYTGI1dmJx?=
 =?utf-8?B?T3U5dFpRZERUeXRncDgwUWNtVFJpR3FBNjk4aWxiNTNtMElwSmdxZ1Vqclhq?=
 =?utf-8?B?MWczaUVOWlAvd2xTRUs1WDFyZWhXTzNTblRjblNPeDkvd085U1h3aXJhU1po?=
 =?utf-8?B?ckdGMSs1dzFXTzAzdkxSZUNvTkpWZGd0Q2xicCtyMEd6bG9mZXpMank1U3Yw?=
 =?utf-8?Q?mkqeUx6Ou7mUHWlyEcFDOzsK0KKRr5oV7fhKSnm?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97B4B8D834F01249B01DEDAEE8984019@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ab6251d-0d0e-4f6b-7b81-08d9661e0390
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2021 10:08:54.2409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TKCYl8LmnNaLekAWLaimNCGOGR4VYXBB3TGAh4DhXwIvBEe0fSSmIOpgrAJr/Js4G9n4MPsaNckNrabwqlVwCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB3065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yMy8yMSAzOjE0IEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IEp1c3QgdG8gY2xhcmlm
eSwgdGhpcyBtZWFucyBJIHNob3VsZCBzZXQgdGhlIHBoeXNpY2FsIHBvcnQgbnVtYmVyIGluIHRo
ZQ0KPj4gcmVnIGZpZWxkIG9mIHRoZSBkZXZpY2UgdHJlZT8gaS5lLjoNCj4+DQo+PiAJcG9ydEA0
IHsNCj4+IAkJcmVnID0gPDY+OyAvKiA8LS0tIGluc3RlYWQgb2YgPDQ+PyAqLw0KPj4gCQlsYWJl
bCA9ICJjcHUiOw0KPj4gCQlldGhlcm5ldCA9IDwmZmVjMT47DQo+PiAJCXBoeS1tb2RlID0gInJn
bWlpLWlkIjsNCj4+IAkJZml4ZWQtbGluayB7DQo+PiAJCQlzcGVlZCA9IDwxMDAwPjsNCj4+IAkJ
CWZ1bGwtZHVwbGV4Ow0KPj4gCQkJcGF1c2U7DQo+PiAJCX07DQo+PiAJfTsNCj4gDQo+IFllcywg
dGhpcyBpcyBmaW5lLg0KPiANCj4+Pj4gK3N0YXRpYyBpbnQgcnRsODM2NW1iX3BvcnRfZW5hYmxl
KHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+Pj4+ICsJCQkJIHN0cnVjdCBwaHlf
ZGV2aWNlICpwaHkpDQo+Pj4+ICt7DQo+Pj4+ICsJc3RydWN0IHJlYWx0ZWtfc21pICpzbWkgPSBk
cy0+cHJpdjsNCj4+Pj4gKwlpbnQgdmFsOw0KPj4+PiArDQo+Pj4+ICsJaWYgKGRzYV9pc191c2Vy
X3BvcnQoZHMsIHBvcnQpKSB7DQo+Pj4+ICsJCS8qIFBvd2VyIHVwIHRoZSBpbnRlcm5hbCBQSFkg
YW5kIHJlc3RhcnQgYXV0b25lZ290aWF0aW9uICovDQo+Pj4+ICsJCXZhbCA9IHJ0bDgzNjVtYl9w
aHlfcmVhZChzbWksIHBvcnQsIE1JSV9CTUNSKTsNCj4+Pj4gKwkJaWYgKHZhbCA8IDApDQo+Pj4+
ICsJCQlyZXR1cm4gdmFsOw0KPj4+PiArDQo+Pj4+ICsJCXZhbCAmPSB+Qk1DUl9QRE9XTjsNCj4+
Pj4gKwkJdmFsIHw9IEJNQ1JfQU5SRVNUQVJUOw0KPj4+PiArDQo+Pj4+ICsJCXJldHVybiBydGw4
MzY1bWJfcGh5X3dyaXRlKHNtaSwgcG9ydCwgTUlJX0JNQ1IsIHZhbCk7DQo+Pj4+ICsJfQ0KPj4+
DQo+Pj4gVGhlcmUgc2hvdWxkIG5vdCBiZSBhbnkgbmVlZCB0byBkbyB0aGlzLiBwaHlsaWIgc2hv
dWxkIGRvIGl0LiBJbg0KPj4+IGdlbmVyYWxseSwgeW91IHNob3VsZCBub3QgbmVlZCB0byB0b3Vj
aCBhbnkgUEhZIHJlZ2lzdGVycywgeW91IGp1c3QNCj4+PiBuZWVkIHRvIGFsbG93IGFjY2VzcyB0
byB0aGUgUEhZIHJlZ2lzdGVycy4NCj4+DQo+PiBXaWxsIHBoeWxpYiBhbHNvIHRoZSBvcHBvc2l0
ZSB3aGVuIHRoZSBpbnRlcmZhY2UgaXMgYWRtaW5pc3RyYXRpdmVseSBwdXQNCj4+IGRvd24gKGUu
Zy4gaXAgbGluayBzZXQgZGV2IHN3cDIgZG93bik/IFRoZSBzd2l0Y2ggZG9lc24ndCBzZWVtIHRv
IGhhdmUNCj4+IGFueSBvdGhlciBoYW5kbGUgZm9yIHN0b3BwaW5nIHRoZSBmbG93IG9mIHBhY2tl
dHMgZnJvbSBhIHBvcnQgZXhjZXB0IHRvDQo+PiBwb3dlciBkb3duIHRoZSBpbnRlcm5hbCBQSFks
IGhlbmNlIHdoeSBJIHB1dCB0aGlzIGluIGZvciBwb3J0X2Rpc2FibGUuDQo+PiBGb3IgcG9ydF9l
bmFibGUgSSBqdXN0IGRpZCB0aGUgb3Bwb3NpdGUgYnV0IEkgY2FuIHNlZSB3aHkgaXQncyBub3QN
Cj4+IG5lY2Vzc2FyeS4NCj4gDQo+IFdoZW4gdGhlIE1BQyBhbmQgUEhZIGFyZSBhdHRhY2hlZCBw
aHlfYXR0YWNoX2RpcmVjdCgpIGdldHMgY2FsbGVkLA0KPiB3aGljaCBjYWxscyBwaHlfcmVzdW1l
KHBoeWRldik7IFRoZSBnZW5lcmljIGltcGxlbWVudGF0aW9uIGNsZWFycyB0aGUNCj4gQk1DUl9Q
RE9XTiBiaXQuDQo+IA0KPiBwaHlfZGV0YWNoKCkgd2lsbCBzdXNwZW5kIHRoZSBQSFksIHdoaWNo
IHNldHMgdGhlIEJNQ1JfUERPV04gYml0Lg0KPiANCj4gQnV0IHRoZXJlIGFyZSB0d28gZGlmZmVy
ZW50IHNjaGVtZXMgZm9yIGRvaW5nIHRoaXMuICBTb21lIE1BQyBkcml2ZXJzDQo+IGNvbm5lY3Qg
dGhlIFBIWSBkdXJpbmcgcHJvYmUuIE90aGVycyBkbyBpdCBhdCBvcGVuLiBEU0EgZG9lcyBpdCBh
dA0KPiBwcm9iZS4gU28gdGhpcyBpcyBnZW5lcmljIGZlYXR1cmUgaXMgbm90IGdvaW5nIHRvIHdv
cmsgZm9yIHlvdS4gWW91DQo+IG1pZ2h0IHdhbnQgdG8gcHV0IHNvbWUgcHJpbnRrKCkgaW4gcGh5
X3N1c3BlbmQgYW5kIHBoeV9yZXN1bWUgdG8gY2hlY2sNCj4gdGhhdC4NCg0KVGhhbmtzLCBJIHdp
bGwgZG91YmxlIGNoZWNrLg0KDQo+IA0KPiBTbywgc2V0dGluZy9jbGVhcmluZyB0aGUgUERPV04g
Yml0IGRvZXMgc2VlbXMgcmVhc29uYWJsZS4gQnV0IHBsZWFzZQ0KPiBkb2N1bWVudCBpbiB0aGUg
ZnVuY3Rpb25zIHdoeSB5b3UgYXJlIGRvaW5nIHRoaXMuIEFsc28sIGRvbid0IHJlc3RhcnQNCj4g
YXV0b25lZy4gVGhhdCByZWFsbHkgc2hvdWxkIGJlIHVwIHRvIHBoeWxpYiwgYW5kIGl0IHNob3Vs
ZCBiZQ0KPiB0cmlnZ2VyZWQgYnkgcGh5bGlua19zdGFydCgpIHdoaWNoIHNob3VsZCBiZSBjYWxs
ZWQgZGlyZWN0bHkgYWZ0ZXINCj4gcG9ydF9lbmFibGUoKS4NCg0KVW5kZXJzdG9vZC4gSSdsbCBy
ZXZpZXcgdGhlIG5lY2Vzc2l0eSBvZiB0aGVzZSBjYWxscyBhbmQgYWRkIGEgY29tbWVudCANCmlu
IHYyIGlmIEkga2VlcCB0aGVtLg0KDQo+IA0KPiAJQW5kcmV3DQo+IA0K
