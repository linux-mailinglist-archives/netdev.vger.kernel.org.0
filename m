Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A96242BA87
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 10:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhJMIgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 04:36:08 -0400
Received: from mail-eopbgr00098.outbound.protection.outlook.com ([40.107.0.98]:56718
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229830AbhJMIgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 04:36:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWaE8o0dW6jgeH8DdAGAiE5cOx2/ed9d8Q4henbMs9IN7XhJ8DjEmaZFxtIDWnQKyj85p0kuLJohUAauwLl+AN8pQwB83sbmkMi0ZMO6WoQpa0+5+KD21s+D5k0jcxpKb5pEP5gxqh1XVFDMIC8sMlBSaceEsYNW7SrySA+HPc1N/W2lYrGWoWR0tv48YqPTmJK1gFX9/DeC/pcBdYdS4Aup/2D2ZLP+HmBNhSxIIywjMefXzvrtVU+oFSKzHpR0NDbNHAb1b0SwLmzkcoFaYYfpJtxzSkPxh/kkA6oIN+NMIwJaoyz7wSJ//LXrBBtDyEFG9fUrKhJ9gG4LeH9Xuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lrr0xkyWU+4nn38vVTtBjVxQzyJyKoDjTDBt+9MfLUg=;
 b=ak93jkw2mNShXtPiCaKCOOdmulioB/ZyYIpMUAQHvKSlLOynqY2z1F0CouTJBbq7C0GkZc8DsUHVDjNtDFbxvyjz6RXKUmy28QpC6HqVsrkgwHSbm6vnx7wfAaBpPWfNFgcLuxYWs2QTWemrE3IOoW23EZfSfMlESmxEIzGlhJc3VQ6akph6x0Ri1CEymproFcYu/0gpAv3Ijwi4lJXI1DLR8QMsUDG7mHW1ugrxeXNe5uzORpQ3+w4O6EoTOOjlAoKytvsNCwtEjGxe6ZINEffbkt009qfW7w6rY6pTqSyHt4dM6YopGMhNmh+dQoAW0VUxcnMt3Qf067BWDFZRuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrr0xkyWU+4nn38vVTtBjVxQzyJyKoDjTDBt+9MfLUg=;
 b=pHbcRcDD4ZCrkSvyE68LUtaJ6EOsg1TpJVe5PoXJqODubl7yM+/x5zHBS9xBxk78HpHYkCcbMdmC6tCjqYvePddzKkR0589f9xckI+VuDucYSEx/NHAzeli+SibJLl9NwCBOCvhITzYlqiPvLChGUFhgGIQCVa2jWLY475JnhFo=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR03MB3066.eurprd03.prod.outlook.com (2603:10a6:7:62::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.22; Wed, 13 Oct 2021 08:33:37 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:33:37 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Jakub Kicinski <kuba@kernel.org>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Topic: [PATCH net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Thread-Index: AQHXv2Xnxc/wFCiERUe0xn+KS7nXfavPfGuAgAEez4A=
Date:   Wed, 13 Oct 2021 08:33:36 +0000
Message-ID: <bde59012-8394-d31b-24c4-018cbfe0ed57@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-6-alvin@pqrs.dk>
 <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211012082703.7b31e73b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b1538abb-5ca6-4d02-af53-08d98e2426d6
x-ms-traffictypediagnostic: HE1PR03MB3066:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR03MB306671939719347BD209B1B483B79@HE1PR03MB3066.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeDYmig+KUuijAlEXSH/KjVI0TFdoIfaA4SQrEbmw9Ws+y9BvvN+mH4W92iyzQiyzGxM2mxcXB34bB1XrzNuvMg1c2haRf/2NjT0/X6/znjQJdw2V9nUN4zjBrq3UUfhGN6HdgNPNsQt7XhTgBqG8lt/BF8hw8gTrxsUy4itAQEmbMXlPc04HhMnNmeP/ZXjyuF1yYoZgngZ0Xu4yQGM/2TTyjKE8+vchqTTviBKMHzcR3NCqSHc78KCPnGFMg5/MqtfPD8dAshNkD/PWonH/2Z5DsU1aOR+C1l7g76zhxtYyKziFSTE78PHg/erZpJ5g5QzUMplH5pwZG+BL9UTDTfNakYQP2NoYF83dEFh1jHSkA76xBQC0Lg+Pn+Na6CCyj35gE7/eLOAsEgy/JYIuLMJ1ya6Crooo3F+DZpr1BZ1ndp+u56PaEzolOl3T21EKEjqQHO6nXj7ETJJA4HnV3VSHwalvBxmBBcQJviQLpxez+JymPBWainpA9+PXKv9lc9qzkfeJKiyY/LhucU8Cg7BudEbImHTmpZJRj0GjomPM2I+1VBLi5BS73sj2cOr2tHiELZdIqNE6g6JVk/SRiSgHwZdQoBodk+mRHKUX7T6i89WrqKfvKTQsrCAnUQlYryFuy/1vM3ayzLmSGwWlVF/9oMr0SoxdIIdQGNAOf6QSKqzxxCPM8k/4xyoXq4NMNuFacmHVKpbQqSuO73Jp7W9Na+8kV/D9oMBrcS6wUiTGfLGMUXhbYizkk4/R9MgH87E/BQH6X9kbS40PVvEhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(53546011)(85182001)(76116006)(8976002)(66946007)(122000001)(7416002)(6486002)(6506007)(91956017)(4326008)(31686004)(66446008)(38070700005)(38100700002)(36756003)(66574015)(54906003)(186003)(66556008)(2906002)(110136005)(83380400001)(8676002)(66476007)(31696002)(6512007)(64756008)(86362001)(508600001)(8936002)(71200400001)(85202003)(316002)(26005)(5660300002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTdIa3prOVdabm5oL1EvR0tBRDNmSzZaVWNkclJEeWRSZU5kbFVKMUhnaERW?=
 =?utf-8?B?bFVxWG5UVGtDa3ZMZVVzL1RyM25iQ0doc1FMK3JFQlZyNFBpUnc1ajlyMzVR?=
 =?utf-8?B?RFFEM1pqMHV0UURMbDhMd1k1UW9qdTZFQWdRaFlDOE51TWNkK0xVcTJkeXFn?=
 =?utf-8?B?b3FuUUF5a2VrejlXY2RXODdDS1lKMnJFckplRlVoczhwaGprd3g3dXVHeUpH?=
 =?utf-8?B?SGt2OFhlTU9RYzlCWlVvZ2pkTnZ5WVJLNHVLRStlbXc0ZmdzWFZYQmxTc281?=
 =?utf-8?B?MWN4cnA0ZHcrSEdjTFZ0Y2tOK25senozd3VVZml6bE1DbU1iNlhEZW94d0V4?=
 =?utf-8?B?dnd5Q0pkWVl2bnJCUTZxY3B5d3lSM0Fwb1hTZFNXSFJITmc5K3ViR3ozendy?=
 =?utf-8?B?aWlGSTBMd1FFTXVrcnAxdGtlVHc4TXp0WWtUTThJK1MydkpieUJIM3BWcGMr?=
 =?utf-8?B?YlZwaUpzYW9qT0tlR0hxTy94TnVOMVlUbENHcVdYMkliWDQzd2tLR3lkK2oy?=
 =?utf-8?B?eHJZV2s1THpYQjlHSkZCRklHMkRWRkY2b1VtS3Q1RGFDMmpoZlIrQTNTYVFh?=
 =?utf-8?B?YVo1SVkrWHljYVpiZGNsQ2ZHb0dQZ09VNnBGUEFTNmFET0NBZWoyUGxkRUZv?=
 =?utf-8?B?SmhvYXRxSE5WYVgzdGtJT1lUcUZBclAyeWFMRVRRbjRlZEZmNFpGK1dpeWdF?=
 =?utf-8?B?Nm8xbksySit6RHBEOGdWNEVpbHNsdzlKYWdkVTBqRXNxMVR5RDV4dkhHTmNz?=
 =?utf-8?B?TC8vNjMxRHd5cS9YZkl4N0tUMHoyZ0xkeXV2MGVnMTNmb2RERXlZUU0xaWpP?=
 =?utf-8?B?UU90RXAzYU83eE5EWnNTVisvWHNFb1NTMlRoMWNIckNvVTdvTGhYanA1TVJ3?=
 =?utf-8?B?dDEyaUI1NDErT2FDNEMxUEdwS2NBMlBzeEVBMWhqU0J1WlRJY0g0N2V4dTF6?=
 =?utf-8?B?R3pvdWdYbjd0U0dZWGl5eDJHWmlJSmFnaENnZHhyb09Qd1E2M09VaFROUEpp?=
 =?utf-8?B?d3dtRDVodE5GYVRMZTBFRDhNZ28xQWFIcEVlR01DZGJSUUYwVkRBTU1CdnBC?=
 =?utf-8?B?VTVla2p3TEpzYXRIKzJOekJnRUlWV1M2b1FKM01OT05nd1VJbjcwOTZCbVIv?=
 =?utf-8?B?QkRxc2RTeHBRdzlZazRaNWdPVkdSbUhXTFVJOW0vcUJiQmUzaHdiZ2Fwd1hQ?=
 =?utf-8?B?SURia2ZTUDl2NUZHYlpCRU45Z2Fnc0FINnViRGI3T1VZY1lnUzE3d2l5eWNH?=
 =?utf-8?B?QTVpelRrSTJzZVlWZGxyUkgyb2FtbVptcFM4V3R4NzllbTJzdFArSzVKekZ6?=
 =?utf-8?B?OVZ4VWZLVkswQWNIQ05aTkliUTNhY29GZlVGc0oySXFIV0FpbTUvc3l3bitr?=
 =?utf-8?B?UGtOU3RLczJEUmg2UCtEcmk0bG4xTDYrcVlsd3RBazNBdVZoZEJwTm94RDBt?=
 =?utf-8?B?N3loN00xbmc5bXhEdzBneEJhVElJVFZ6czIrYW5UaDA3a1YvNDdWdEZXeXY0?=
 =?utf-8?B?S3ZBekJhMWs4VCtQdWxsbWUvTDRsdGx4QU9KRlRxRCthcElJOGc3WVhpaDFq?=
 =?utf-8?B?WUIxZE1lOW5LeUtqc29naUIrTWRxUStuS3lzZm5hN1d4d0dNS2Zac2c3dnNI?=
 =?utf-8?B?eTd2dEc0TFdxLzFva1VzZWdkMTNRUlZHRzJmVDlqVFpTeG0rYkEzamthTkZp?=
 =?utf-8?B?NWNJZFJJWEJhZGdPTUUyZEpnRnN0OE04ekFXWjFLN0dBbjM4VmhPZ0FnVWFH?=
 =?utf-8?Q?ppa88MFNC3dE+oq4T3mSNakhqr56u8qOmomYy8B?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F44B717D6C80E46AEE17DAC4CD533FF@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1538abb-5ca6-4d02-af53-08d98e2426d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:33:36.9897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cqqnle7WG/GaWXf+UW3/6gpT8BR0RFI8GduHW9JP81mi7sySeFbZ4mSa/D6YNU5WXz339R8pJThPk1kUS/g+mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB3066
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTIvMjEgNToyNyBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFR1ZSwgMTIg
T2N0IDIwMjEgMTQ6MzU6NTQgKzAyMDAgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiArCXsgMCwg
NCwgMiwgImRvdDNTdGF0c0ZDU0Vycm9ycyIgfSwNCj4+ICsJeyAwLCA2LCAyLCAiZG90M1N0YXRz
U3ltYm9sRXJyb3JzIiB9LA0KPj4gKwl7IDAsIDgsIDIsICJkb3QzSW5QYXVzZUZyYW1lcyIgfSwN
Cj4+ICsJeyAwLCAxMCwgMiwgImRvdDNDb250cm9sSW5Vbmtub3duT3Bjb2RlcyIgfSwNCj4gLi4u
DQo+IA0KPiBZb3UgbXVzdCBleHBvc2UgY291bnRlcnMgdmlhIGV4aXN0aW5nIHN0YW5kYXJkIEFQ
SXMuDQo+IA0KPiBZb3Ugc2hvdWxkIGltcGxlbWVudCB0aGVzZSBldGh0b29sIG9wczoNCg0KSSBp
bXBsZW1lbnQgdGhlIGRzYV9zd2l0Y2hfb3BzIGNhbGxiYWNrIC5nZXRfZXRodG9vbF9zdGF0cywg
dXNpbmcgYW4gDQpleGlzdGluZyBmdW5jdGlvbiBydGw4MzY2X2dldF9ldGh0b29sX3N0YXRzIGlu
IHRoZSBzd2l0Y2ggaGVscGVyIGxpYnJhcnkgDQpydGw4MzY2LmMuIEl0IHdhcyBteSB1bmRlcnN0
YW5kaW5nIHRoYXQgdGhpcyBpcyB0aGUgY29ycmVjdCB3YXkgdG8gDQpleHBvc2UgY291bnRlcnMg
d2l0aGluIHRoZSBEU0EgZnJhbWV3b3JrIC0gcGxlYXNlIGNvcnJlY3QgbWUgaWYgdGhhdCBpcyAN
Cndyb25nLg0KDQpUaGUgc3RydWN0dXJlIHlvdSBoaWdobGlnaHQgaXMganVzdCBzb21lIGludGVy
bmFsIGdsdWUgdG8gc29ydCBvdXQgdGhlIA0KaW50ZXJuYWwgcmVnaXN0ZXIgbWFwcGluZy4gSSBi
b3Jyb3dlZCB0aGUgYXBwcm9hY2ggZnJvbSB0aGUgZXhpc3RpbmcgDQpydGw4MzY2cmIuYyBSZWFs
dGVrIFNNSSBzdWJkcml2ZXIuDQoNCj4gDQo+IAl2b2lkCSgqZ2V0X2V0aF9waHlfc3RhdHMpKHN0
cnVjdCBuZXRfZGV2aWNlICpkZXYsDQo+IAkJCQkgICAgIHN0cnVjdCBldGh0b29sX2V0aF9waHlf
c3RhdHMgKnBoeV9zdGF0cyk7DQo+IAl2b2lkCSgqZ2V0X2V0aF9tYWNfc3RhdHMpKHN0cnVjdCBu
ZXRfZGV2aWNlICpkZXYsDQo+IAkJCQkgICAgIHN0cnVjdCBldGh0b29sX2V0aF9tYWNfc3RhdHMg
Km1hY19zdGF0cyk7DQo+IAl2b2lkCSgqZ2V0X2V0aF9jdHJsX3N0YXRzKShzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LA0KPiAJCQkJICAgICAgc3RydWN0IGV0aHRvb2xfZXRoX2N0cmxfc3RhdHMgKmN0
cmxfc3RhdHMpOw0KPiAJdm9pZAkoKmdldF9ybW9uX3N0YXRzKShzdHJ1Y3QgbmV0X2RldmljZSAq
ZGV2LA0KPiAJCQkJICBzdHJ1Y3QgZXRodG9vbF9ybW9uX3N0YXRzICpybW9uX3N0YXRzLA0KPiAJ
CQkJICBjb25zdCBzdHJ1Y3QgZXRodG9vbF9ybW9uX2hpc3RfcmFuZ2UgKipyYW5nZXMpOw0KPiAN
Cj4+ICtzdGF0aWMgaW50IHJ0bDgzNjVtYl9zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+
PiArew0KPj4gKwlzdHJ1Y3QgcmVhbHRla19zbWkgKnNtaSA9IGRzLT5wcml2Ow0KPj4gKwlzdHJ1
Y3QgcnRsODM2NW1iICptYjsNCj4+ICsJaW50IHJldDsNCj4+ICsJaW50IGk7DQo+PiArDQo+PiAr
CW1iID0gc21pLT5jaGlwX2RhdGE7DQo+IA0KPiBkcml2ZXJzL25ldC9kc2EvcnRsODM2NW1iLmM6
MTQyODoyMDogd2FybmluZzogdmFyaWFibGUg4oCYbWLigJkgc2V0IGJ1dCBub3QgdXNlZCBbLVd1
bnVzZWQtYnV0LXNldC12YXJpYWJsZV0NCj4gICAxNDI4IHwgIHN0cnVjdCBydGw4MzY1bWIgKm1i
Ow0KPiAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgXn4NCj4gDQoNCldvb3BzLCBJIHdpbGwg
Zml4IHRoaXMgaW4gdjIuIFRoYW5rcy4NCg0K
