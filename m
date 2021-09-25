Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BBE418382
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhIYRRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 13:17:46 -0400
Received: from mail-vi1eur05on2097.outbound.protection.outlook.com ([40.107.21.97]:7361
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229511AbhIYRRp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 13:17:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WVxmVEWypfMmoSiIhgFwEKfmrbGHvSVE6mwHjIJFzJMuPGHnrgOp0U4xqIIYc4JGK/psxcZu8DECturaq62SfC50mZz1E2iBIDKoeMDQC8ijjbcp3LQvr+Kc57DyhowMOxkTrVs6ngDlO7gJfJlfQFggj943Pvw4gef8PdzxhLyM8wXKhcUAxIR/PCrki9L/fkSv1JMLBE8qTfeMp9H3q0fkseC6VeTapy1RtOSxW7U9WLvK2c78jrZ8DPjnQX/XjQmZmQ0caV/dWM+6mqCyOe+uAGOXxqrR/+Yz+A+CbjMmavdd+6rvBnXt/sOSUk1kfhWcikh/mfJpUZuJvSezwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=BQsankjKL6p7yIQCL9KDYa3fCmDPviEMGg2qy4XeF+0=;
 b=m7s36//BclHing7hZ+PDqFg+/37OWc7Ws7wAR4zdJA8KUvrKUgzwFh8Q0fUerCCzVIN3XLQRkzRlroc7o/2jlmMDhdQkLLSWZ59un3XBbReT1WpkAaPvnMPw/cYCyk9VXC+mpUHsBMTv7UyOEXkUD9CiFhEsK8FjM7e5hlZzKfm6+hY+1ecgdNJkMwxqLf7SMhDUv9iwtwmJBtFPq1pPop/wBk0/8MaPZTAO171FaHgC7fab0MxAp8Iql3AjO2aAfNJ4zMD9t1dCXjcDm5KYA7NIUptfNn7QfhgkgJ4YMHfgGut260cXzMstnXWSZNnlowSrIe/5Gzu0FU/89/U9gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BQsankjKL6p7yIQCL9KDYa3fCmDPviEMGg2qy4XeF+0=;
 b=m0FfO8Uhu77SKWC0sG/AAMVUzdmEnvcuu1rwUrMATn0aM7xMaeVKbkSOU5Ryx31JFgv89LUydt9oMzTohxQGW/TzBSohsRgGd7LJiGOrlGD3d0ItftdYGOXdM3iG3RdQxijSylAQwKDClwPPNp9Vg5mET/UjBMGRAbvs+J9ZNeU=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2139.eurprd03.prod.outlook.com (2603:10a6:3:1d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Sat, 25 Sep 2021 17:16:07 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4523.018; Sat, 25 Sep 2021
 17:16:07 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 4/6 v6] net: dsa: rtl8366rb: Fix off-by-one bug
Thread-Topic: [PATCH net-next 4/6 v6] net: dsa: rtl8366rb: Fix off-by-one bug
Thread-Index: AQHXshDTUNEV6xp+lk2MXpySkjL/GKu0/esA
Date:   Sat, 25 Sep 2021 17:16:07 +0000
Message-ID: <6b42fde0-86cf-0f22-ef10-9d1b8f3044ad@bang-olufsen.dk>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-5-linus.walleij@linaro.org>
In-Reply-To: <20210925132311.2040272-5-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0de2075c-9313-4d17-688e-08d98048299c
x-ms-traffictypediagnostic: HE1PR0301MB2139:
x-microsoft-antispam-prvs: <HE1PR0301MB21390D9E7B94B3DB73D155FD83A59@HE1PR0301MB2139.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rZXaW0RlLaddi84jnUFKnYUm6XF4PRN7ad3KnjCMd17ihAC0RJ3P2KsF1DNw233tRB9OV6rrLdrjEW7hUxj8KDhX5ylYIP7v2tGZkRQJqDBB0GAnR4ZVflgw3S0OFNV77HyGWCh+dJCGGIhPmQThzRNnKHnaZmOTm0FRdRN6laFxy9fKn41OFblLJMJewCxM0pAu2VJL28DfKdZ+wR/IMwgVRimjF6zyHIjEMLWPMxSuzzhwMezVrZSxWKDw3E6q+/lgR5XC7VpS6ns3x1rAq3h4+/Vj1nHZzo7atOg+1VnTEWfXwmSFKWynqKQOoJ+2hRaSmJWdpwTIgLT/7KFV3Ql+dYmlXYjFDIt/nziCcTdPhSy/W4r9GVL4EORWZqEBrCMbIf9G85/9CTDu0auKEvCPFfXRlcZ9/HrZXvyPyRmvYQVtMY6W/I2D4t5RtDLV/TNdY3lIfifwGwpMeGSPRfNR9p1XzpH4Na6i+EeGTImVnOfM0jn6Bf50kQ3bZShqQ9yILXZqBnVhaZn3t3xz0m70Rq3H7POSeAwjElEl5vuCtcLv8n3csLmCJ3a9didVCiqvobxebCuEPZmQq/DcmaZlxVkK6jKq3D4tA+yTmzqUSW7dJ570XRTP+uxSavbUyVptXZefgtxiQMEmnan6k4+UsWRvv1I+lj4vtYAnlL1HImsIr8xYTZ14LJ75qAHP63RIZEij0gbQdZqlC2BBZIPXQrdPp1G3yowiEdddAPuLE9Y60v/e6ZK4CN2T5i65onpA70g1FItBu+IHnlrJ9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(53546011)(6512007)(66476007)(6486002)(8936002)(76116006)(64756008)(31686004)(4326008)(26005)(54906003)(110136005)(8976002)(8676002)(66556008)(66446008)(5660300002)(2906002)(38070700005)(66946007)(2616005)(38100700002)(85202003)(7416002)(6506007)(36756003)(86362001)(508600001)(186003)(71200400001)(31696002)(85182001)(83380400001)(122000001)(66574015)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVBINE5hNTZOUGljNldPdUxKd1pEWlhSc2wwbW1kbE5LSkFaOEhnMTFyeDIr?=
 =?utf-8?B?ZGJBWTJoK1RNZ1kxeENCVmxidlhzNG9jNHhWZHpwNk5qWlNOc1RRZHQ2UjE2?=
 =?utf-8?B?aU5ZdzE2eEFNenBzNi9NczVNZElVZ0pMbEtRZ0pPR0tWbEs3WW5jd2VZR0FK?=
 =?utf-8?B?NmNRaDdQY0pocVhnN1pGOXp4cUMrS0JLZ3BYRkZIeUhwa1NXOG82dktmL3dW?=
 =?utf-8?B?SjN2dDFWU0Jjb01mTG9JL0MyN0JaRlcra3FpclpxZlVORXZxMFVmNUxBQnNv?=
 =?utf-8?B?WXFuN1B6WjZpRjQ4c1dBZzFaYzhEWmJKWHZxQ0dReG1Md3BWYnA4Wk1nRHM5?=
 =?utf-8?B?Qjg4eXV0cmI1RHRKcjJ3M0dmajU3bTk2RmlxV1p5dTM1WHF3bkd5UFlQRWtP?=
 =?utf-8?B?YWEwVjU4QWlBT3RxQjAxd2pObkVjWG01VU5zTjVwdDYxTHM2OTAxU3FMYmRi?=
 =?utf-8?B?NjgvYnRrU21mUUhyTkxKSTZTY3lpTTYxd0J0NFhrNWlUVUhGUlNWaDBzMW85?=
 =?utf-8?B?bXZsZGhlcFZmQzc5K2Z5RmdDUHNMazlkYXV3bGxEOGdFMnBsbjdwak0wUDlt?=
 =?utf-8?B?Tm1ldjFWZjFzeERobFVKMm5iZXh0WVRqWWIyOFliMjNGazJsUlAzVVVCUEZy?=
 =?utf-8?B?YzRPazIvRXdZVnZMWHRnVmVITXQyTWs4RFluRStHUjdUOCtiK21RSVlLRU10?=
 =?utf-8?B?dzFlZGROQkpsb3RuVHl1WlpHejdnRWdWb05JT2lmNUpnMStZdHZ3Y08yVVdm?=
 =?utf-8?B?WndLY0xLL08xTDhTSE1XbVFqMURxWGNzY0FFVUJ1eDdUalNaR2VtOHU3RUc5?=
 =?utf-8?B?WDZFcFNnUW8yUGdGOFBub2dzMnBmNWNzczU0YlppRDZMNmdXMTJYRVU4NEJQ?=
 =?utf-8?B?aCtVTWsxenY1QVVhVG1hTTRIZENXdDhWQklGR1pZZHpScEh5aFdsZ281cE1H?=
 =?utf-8?B?THZlSitIdVR5TmI0YlBpZ0V4eVJla3RlWWd6V092NmE2eWN0UnVlWTBFUm10?=
 =?utf-8?B?MXVIMWk5alpoTEtCM2JKT1RVNk1QTFV3UXB5Zm53QUF4UnpaS3NxbnFZbHkw?=
 =?utf-8?B?K29JSWpueE0yZ2g1WVpEZ3FBWnNISW52bk4ra1NwSk1JT1hkQU0yd0J2WlFY?=
 =?utf-8?B?NWxaMW5reGJVVVBoZlFEdkpVZXhES21oVWU1S00vbVA0d2ptTlpPRENsT2N6?=
 =?utf-8?B?VjgreTQ4VnFXeGlOeXd1UnM2eUdnckxpQmJRQ0dvbmFCSlZzVWd4RTZuaFli?=
 =?utf-8?B?SnpydDNHRysxeWViRFlMMkV3SUZZUFU4MDB4azV3RW1sZ0tqMkN4Vm5tR3hi?=
 =?utf-8?B?czBvc25yS1dTU2dZZStwZ1NpZFo5ejlaMUN4eGx3cnkzbTFMKzhycHZlTWpV?=
 =?utf-8?B?bysxUUhLNUM0Zmxpem1ueEpzWnAxTDJETllpVitaYW9yR2d1Z09OdnBTRWFM?=
 =?utf-8?B?TlgyVjJZVVdBOUhEckhMUWNvdTlBc0xhcDE0ajZRR0s2UUtuT1BNNC9uSHQw?=
 =?utf-8?B?MzhieU1nYTk3NS9QZEwzejJxd2k2b0pWclBieFBQL0xGU2ZSdzZvS2d2SWdW?=
 =?utf-8?B?RzJRNU1RNHZpcE5kZlBYcmppb2pMQVYycFNqQVBZeG5RWFg0dUlrWDZiVjA4?=
 =?utf-8?B?R1AwWE8xZmVtclV2WVpVRG9VMUQxN1R1ZFhWQlJmamhKUEdiaGJ0Q2hpaGVQ?=
 =?utf-8?B?dVQxZG1zdmdYYjlHT2FEeUN6eDdkMjZHSm1KcUxJVlVidEdxTGh3dFFUdVN5?=
 =?utf-8?B?aGVVdEJBQ3BSbmU0UHpiUzRwTC9BWXIxRzJRUkFvbzZsUk50ZGxuOEF3a0hh?=
 =?utf-8?B?RDNCcW5WT3dQUW10YmFFZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <628C0404ED481E4588E513CCCC9A0907@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0de2075c-9313-4d17-688e-08d98048299c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 17:16:07.2213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BqEssaQ6ADPt6MaZuyGiE7FPhFEiUsBP9Ow6s6v3ReglJtqcjyViADrXv8ASVR91P5wjvQu78it1ldawrE5lbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8yNS8yMSAzOjIzIFBNLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPiBUaGUgbWF4IFZMQU4g
bnVtYmVyIHdpdGggbm9uLTRLIFZMQU4gYWN0aXZhdGVkIGlzIDE1LCBhbmQgdGhlDQo+IHJhbmdl
IGlzIDAuLjE1LiBOb3QgMTYuDQo+IA0KPiBUaGUgaW1wYWN0IHNob3VsZCBiZSBsb3cgc2luY2Ug
d2UgYnkgZGVmYXVsdCBoYXZlIDRLIFZMQU4gYW5kDQo+IHRodXMgaGF2ZSA0MDk1IFZMQU5zIHRv
IHBsYXkgd2l0aCBpbiB0aGlzIHN3aXRjaC4gVGhlcmUgd2lsbA0KPiBub3QgYmUgYSBwcm9ibGVt
IHVubGVzcyB0aGUgY29kZSBpcyByZXdyaXR0ZW4gdG8gb25seSB1c2UNCj4gMTYgVkxBTnMuDQo+
IA0KPiBGaXhlczogZDg2NTI5NTZjZjM3ICgibmV0OiBkc2E6IHJlYWx0ZWstc21pOiBBZGQgUmVh
bHRlayBTTUkgZHJpdmVyIikNCj4gQ2M6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5j
b20+DQo+IENjOiBNYXVyaSBTYW5kYmVyZyA8c2FuZGJlcmdAbWFpbGZlbmNlLmNvbT4NCj4gQ2M6
IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4gQ2M6IERFTkcgUWluZ2Zh
bmcgPGRxZmV4dEBnbWFpbC5jb20+DQo+IENjOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxp
QGdtYWlsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVp
akBsaW5hcm8ub3JnPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNp
QGJhbmctb2x1ZnNlbi5kaz4NCg0KPiBDaGFuZ2VMb2cgdjUtPnY2Og0KPiAtIE5vIGNoYW5nZXMg
anVzdCByZXNlbmRpbmcgd2l0aCB0aGUgcmVzdCBvZiB0aGUNCj4gICAgcGF0Y2hlcy4NCj4gQ2hh
bmdlTG9nIHY0LT52NToNCj4gLSBBZGQgc29tZSBtb3JlIHRleHQgZGVzY3JpYmluZyB0aGF0IHRo
aXMgaXMgbm90IGEgY3JpdGljYWwgYnVnLg0KPiAtIEFkZCBGaXhlcyB0YWcNCj4gQ2hhbmdlTG9n
IHYxLT52NDoNCj4gLSBOZXcgcGF0Y2ggZm9yIGEgYnVnIGRpc2NvdmVyZWQgd2hlbiBmaXhpbmcg
dGhlIG90aGVyIGlzc3Vlcy4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5j
IHwgMiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigt
KQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYyBiL2RyaXZl
cnMvbmV0L2RzYS9ydGw4MzY2cmIuYw0KPiBpbmRleCAyYzY2YTBjMmVlNTAuLjZmMjVlZTU3MDY5
ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjZyYi5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9ydGw4MzY2cmIuYw0KPiBAQCAtMTQ1MCw3ICsxNDUwLDcgQEAgc3RhdGlj
IGludCBydGw4MzY2cmJfc2V0X21jX2luZGV4KHN0cnVjdCByZWFsdGVrX3NtaSAqc21pLCBpbnQg
cG9ydCwgaW50IGluZGV4KQ0KPiAgIA0KPiAgIHN0YXRpYyBib29sIHJ0bDgzNjZyYl9pc192bGFu
X3ZhbGlkKHN0cnVjdCByZWFsdGVrX3NtaSAqc21pLCB1bnNpZ25lZCBpbnQgdmxhbikNCj4gICB7
DQo+IC0JdW5zaWduZWQgaW50IG1heCA9IFJUTDgzNjZSQl9OVU1fVkxBTlM7DQo+ICsJdW5zaWdu
ZWQgaW50IG1heCA9IFJUTDgzNjZSQl9OVU1fVkxBTlMgLSAxOw0KPiAgIA0KPiAgIAlpZiAoc21p
LT52bGFuNGtfZW5hYmxlZCkNCj4gICAJCW1heCA9IFJUTDgzNjZSQl9OVU1fVklEUyAtIDE7DQo+
IA0KDQo=
