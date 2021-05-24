Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56D138F551
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 00:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhEXWFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 18:05:33 -0400
Received: from mail-db8eur05on2077.outbound.protection.outlook.com ([40.107.20.77]:57157
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233831AbhEXWFc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 18:05:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ddMQJ+imNydWPXjkOvnPvWI5oZT4H2ht3llmlwh625Diwiv1Pg5rq3llDVdAT4mU34/hSSypSF6r/f5okNPW6HR2jf7e0jLwyUxU47wyNCS1Ss+464vs1Xo2lC46iXGlNWz9KggT6hC+XycVmHeNhM3Eq6KBnVP7CPq4WBxZXjuP+2wwr+kazrF/t3D4QiYo8/FSWpWgxTPg6WzMCK5oUuC3aF7db6ErbgsPy/jsijWfwN/hvJtT/QGkTRFs9aEVWevk1nC2DJpXnzpE+cLDVqjdnUrLf6355tT1lHiYenH5Q3GqExP3GkG+ZoZ6pxQz12UDpUfxsA1JdtLUTq21wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=275lzLkXAms73hj0nT5aA7OO5tgcC5FGBQHfT8iAuhE=;
 b=X410Nian+U2jVVP+G6hO2AAk/Ujvl0X/IIm2dcq8tYoG7YkMV9Kxa4jDb35Ud2DqM4+VdctPgEXfnw6S/pMBqj6+KRsudcHzaRwVsnYzrPuQG3q1VkB0Qwvr8ld4cj2YPHj7JbxpblXk5EVzsfmgHLeQmxplWdVv8hBOYKnxDXgSsV6uzpzPI0rJAxtNzXENiEyUgNsODDc6CzcLjwE8kYyznkj/qXhr176NcD3JxetfVSbWtFeZ/vbrIh1zFK+808jc4Ge1xEkqHGydfSt+T8+e4avRhIOo88KOPJnSFZLkFlg5gILV2NQSyC3CQW8WRBhUstkaUNmW/ALlF4JZzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=275lzLkXAms73hj0nT5aA7OO5tgcC5FGBQHfT8iAuhE=;
 b=iWhrw18CFD1MeujmP3HgYgjWamdj08uMgTVGX5P1HLbL82MfNsseiJ/hHaK9kNwHLiZCLZUfdJHTg2gi+gjgOkT8h8iduPOaKLH8BlPC6+VHprdSYWy9/4+HFN3wcb7qt9B0eeixvZ10hYoQNJ4LEZ0cqRgjhFLX5TO8jQtivms=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2510.eurprd04.prod.outlook.com (2603:10a6:800:54::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 22:04:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 22:04:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "cao88yu@gmail.com" <cao88yu@gmail.com>
Subject: Re: [PATCH net 3/3] net: dsa: Include tagger overhead when setting
 MTU for DSA and CPU ports
Thread-Topic: [PATCH net 3/3] net: dsa: Include tagger overhead when setting
 MTU for DSA and CPU ports
Thread-Index: AQHXUOR3AREE9B0IQUelbG8tISEeu6rzL50A
Date:   Mon, 24 May 2021 22:04:01 +0000
Message-ID: <20210524220400.gwqdwqrju7uzxtqi@skbuf>
References: <20210524213313.1437891-1-andrew@lunn.ch>
 <20210524213313.1437891-4-andrew@lunn.ch>
In-Reply-To: <20210524213313.1437891-4-andrew@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.52.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a09672f-c131-471d-ee3c-08d91effd6ff
x-ms-traffictypediagnostic: VI1PR0401MB2510:
x-microsoft-antispam-prvs: <VI1PR0401MB2510FF8DD5C9F042E0484521E0269@VI1PR0401MB2510.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UfQ26LloUf8EgzzOB04rVjCzP937Cv0hmPF/ZXYYQcNaPa8hzOg3B5hw6bIjAo0LWPFeZcFS0UMCYcIviXP3PAqnp6racQTMLupSIdyIu6uv6OrKsQvsB6tfP3Xxz5cIRU/L1sAGhp0rrWZiAwgeJRokp2KEIeVTkY+mOQrnPMqgMU6T/RGjR9bAmi5fT9MkRuFMSG1A7qX5X+pm96CWWZzMuMwSO8UEQe9cJnwgc3bnZYPw5dT/ZI+31N5+xNuTSgmhIhLkJRaImg3tMwAeAM+7rbzeqmt4rJZqJ3Y0Qyxm6p+4QikV5xYY3mH0qIOVn2ZvwV3Mu2C97Sl9dvzyDWxvaliOK7HLtuU/r/ko9ejtjlJ4ez7WYiwasyCHaB+b/QgrRE0SRQnwui0PMy9mk5FvNgM17SUvppgF0YgEMDc8WYcUrXatJS2lPswh7pR9azmkRtwEhqonMDHsSwwhhf6/TBaUu9hQyZPrg+kB1aU8WUf3tBA2O50p/w4VhG0uGyVhscv0rZk+B7RFKqeaQybKkppHsMMV4n1+juoRdJYeKFSXCF/HFDQLkgAG9/R4GWPMyw/MW5e/4+KYHrN/JphTZF6PM4Qt1QFBajmthiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(1076003)(122000001)(6486002)(71200400001)(83380400001)(38100700002)(6916009)(26005)(6506007)(186003)(8676002)(64756008)(91956017)(66446008)(76116006)(316002)(66556008)(54906003)(86362001)(33716001)(5660300002)(478600001)(4326008)(6512007)(44832011)(8936002)(9686003)(66946007)(2906002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bklZOFVNZ1pBeFFWOU5ITWN6cmFxTlhzYjlpd0pmaUl3bkl3RCsyMllPVytB?=
 =?utf-8?B?WTV0NlBrU3FmNTVva2ZvMVF0MXRGdVExUFhET2lTelB2dDU3MCt6OGVIUWFY?=
 =?utf-8?B?T01IakVoaDFQTkpyRU5xNy9KZVdaTzFId2Z2OE8zN1ZSeHRLU29Ya2dNNFJu?=
 =?utf-8?B?bWFhOVlxckRuWVhpbW1qWFJnQTZGK2t6OHRNZU90K0VJU2FIcG1ZN2FNb2Ny?=
 =?utf-8?B?S3FKQVJKS0s1dlFnbHk1WlF3cHkzaytjSnlTbUJEMFlhbGJFTVVvL3pRalhW?=
 =?utf-8?B?RFJ6a1QxVnpOWVZBd0N3d21ld1NYZlJ5bUh0b2FDOFM5d0NzQUFHdkVQMmJY?=
 =?utf-8?B?T1pvVEtMVmE2ajJaSHBkQU44cGZ2NlU1MzB6eVF1MURtTWdjZloxZlhDWTJ4?=
 =?utf-8?B?RjVZWTZ0bGYvUXdhSXhLUEJ3SVFHemFqS2N1YlhlcUVFTEZ2dmNrYVRIZE4x?=
 =?utf-8?B?WXhDL2JjdFNTbWFUSDFDdVZqbVVZUG4rYjl4TFgyMlgySzN2OXpJUkN1L20r?=
 =?utf-8?B?dkJFdnBZQ0x0MGdpRFZJNGF5V2tJN0syNEpDU29sQXpVRGFuUHh1R2o4NUUw?=
 =?utf-8?B?TW4vTENnZlBEV1VmYUQ4eDFTdkFpWTROSU52M3ZLUkU0S05DODlGN0NSV3lx?=
 =?utf-8?B?SHdSeFBmU2pJV1RPVkFzUzdYaUR3b1RvMUpjbkN1NzNhODBRb0ZVdG02SCs5?=
 =?utf-8?B?UkdlbTAzdDh4NmFvYU04U0cxNGFVaC9LRzlKMHdzRTBqZHBjOC9TbEJzZlZB?=
 =?utf-8?B?RXNORDVuMzBNTjlLMTJnbTF1V0t0L1hpa09LcytLK3Z2bmU0d3VGbHNvcnRY?=
 =?utf-8?B?bHBXMHF0UFh1Vmd1c2UrZW1lYkd2U3RqSVFNcVFmSnNtZDUzSzQxQWFVdVQv?=
 =?utf-8?B?VWFGUzh3R29DSFFGdjVUUUNid0tCUkp0bUt2ZlRBb1hRai90MXRmdC9iRTgw?=
 =?utf-8?B?M09YNnBhVFpzZ0E5SUIrOWtuRExUMXFWNkdncWh6bGlqNmREeks5QVYvM3Zy?=
 =?utf-8?B?NGJpQmY4M3BjRGs1M3dUTlhocmNkdG10RnpxalI5dkMvNldFb3FQT1VDNXRN?=
 =?utf-8?B?MThMd0p3cVVZWXdRREdSeVhpUmpNY0Q3SllCRDJkVUFGYTVJRnpvOWJVYkNB?=
 =?utf-8?B?Yk0yMTFoWXFxNWM2V3NGVEcwNnlmazcwdWM1WHM5SHFBcVgzTTdMTXdab053?=
 =?utf-8?B?NTduRGptVDZ3aHNNbW80NzQ1S1k4TFhUK2hyRWd5SjhzbUNZbkpySjlQR0c4?=
 =?utf-8?B?ZjBHN0psZFRjSTEwUEp4Q21JeFY2TWNGNVdOcXEyS05Na1lNU0Zzek9ESEgz?=
 =?utf-8?B?aWNSMnJtdS9USkdjOEVuQ2xpU1dLdFhZanF0cW1rdktzQUhYNm9rY0xUQUR6?=
 =?utf-8?B?aDJvMVJsalNuQmVHRDh5aFg0T2Z2U3NFUG9DTmppYlZnTklZaGZMMjRNQlk4?=
 =?utf-8?B?dzlDbXRZMjJ4RGVGaElSWDlIbkw3ZGJHR01OdUtTMW5tRlVBbjZTY0IwT2Fh?=
 =?utf-8?B?bUU2RVB5MVJLOEdVRUFTZTh5QzVuUGZ0eHJnek9Bdk5uN3l1L25NV2N4Mkc3?=
 =?utf-8?B?d3JKd0YyMi92Y2lIWmZLclpHSkQ0aEYvRnEwVFc1aWNCQ3hVbmNtREFFZHhF?=
 =?utf-8?B?bjRRcEtzY2RDNlo1YlIxbXJkWWd0SnNQUjc4bERhSG16Ym9oMk1jNlJRaHFl?=
 =?utf-8?B?bWJzWVlxTnlHQ1AzOTJoZlIvOEpKeHV1N3daQmwwUFcxMEYvTjlzT1d4aFBy?=
 =?utf-8?Q?91Zxxp1V0bY5Iki5J6j68QCIHqa2ySnWoMCqxwY?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F280DA19CF722408351C547AF0F6BB7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a09672f-c131-471d-ee3c-08d91effd6ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2021 22:04:02.0127
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ymrx0WWfXA/34mutw1ojkegY+VVjTX/Kq4HhZtdbHnOrwD7oPq6Marp4H8Mn5StyN7AP0F23b74Ul1H6R845cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2510
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXkgMjQsIDIwMjEgYXQgMTE6MzM6MTNQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+IFNhbWUgbWVtYmVycyBvZiB0aGUgTWFydmVsbCBFdGhlcm5ldCBzd2l0Y2hlcyBpbXBv
c2UgTVRVIHJlc3RyaWN0aW9ucw0KPiBvbiBwb3J0cyB1c2VkIGZvciBjb25uZWN0aW5nIHRvIHRo
ZSBDUFUgb3IgRFNBLiBJZiB0aGUgTVRVIGlzIHNldCB0b28NCj4gbG93LCB0YWdnZWQgZnJhbWVz
IHdpbGwgYmUgZGlzY2FyZGVkLiBFbnN1cmUgdGhlIHRhZ2dlciBvdmVyaGVhZCBpcw0KPiBpbmNs
dWRlZCBpbiBzZXR0aW5nIHRoZSBNVFUgZm9yIERTQSBhbmQgQ1BVIHBvcnRzLg0KPiANCj4gRml4
ZXM6IDFiYWYwZmFjMTBmYiAoIm5ldDogZHNhOiBtdjg4ZTZ4eHg6IFVzZSBjaGlwLXdpZGUgbWF4
IGZyYW1lIHNpemUgZm9yIE1UVSIpDQo+IFJlcG9ydGVkIGJ5OiDmm7nnhZwgPGNhbzg4eXVAZ21h
aWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyZXcgTHVubiA8YW5kcmV3QGx1bm4uY2g+DQo+
IC0tLQ0KDQpTb21lIHN3aXRjaGVzIGFjY291bnQgZm9yIHRoZSBEU0EgdGFnIGF1dG9tYXRpY2Fs
bHkgaW4gaGFyZHdhcmUuIFNvIGZhcg0KaXQgaGFzIGJlZW4gdGhlIGNvbnZlbnRpb24gdGhhdCBp
ZiBhIHN3aXRjaCBkb2Vzbid0IGRvIHRoYXQsIHRoZSBkcml2ZXINCnNob3VsZCwgbm90IERTQS4N
Cg0KPiAgbmV0L2RzYS9zd2l0Y2guYyB8IDE2ICsrKysrKysrKysrKysrLS0NCj4gIDEgZmlsZSBj
aGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL25ldC9kc2Evc3dpdGNoLmMgYi9uZXQvZHNhL3N3aXRjaC5jDQo+IGluZGV4IDliZjhlMjBl
Y2RmMy4uNDhjNzM3YjBiODAyIDEwMDY0NA0KPiAtLS0gYS9uZXQvZHNhL3N3aXRjaC5jDQo+ICsr
KyBiL25ldC9kc2Evc3dpdGNoLmMNCj4gQEAgLTY3LDE0ICs2NywyNiBAQCBzdGF0aWMgYm9vbCBk
c2Ffc3dpdGNoX210dV9tYXRjaChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAg
c3RhdGljIGludCBkc2Ffc3dpdGNoX210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsDQo+ICAJCQkg
IHN0cnVjdCBkc2Ffbm90aWZpZXJfbXR1X2luZm8gKmluZm8pDQo+ICB7DQo+IC0JaW50IHBvcnQs
IHJldDsNCj4gKwlzdHJ1Y3QgZHNhX3BvcnQgKmNwdV9kcDsNCj4gKwlpbnQgcG9ydCwgcmV0LCBv
dmVyaGVhZDsNCj4gIA0KPiAgCWlmICghZHMtPm9wcy0+cG9ydF9jaGFuZ2VfbXR1KQ0KPiAgCQly
ZXR1cm4gLUVPUE5PVFNVUFA7DQo+ICANCj4gIAlmb3IgKHBvcnQgPSAwOyBwb3J0IDwgZHMtPm51
bV9wb3J0czsgcG9ydCsrKSB7DQo+ICAJCWlmIChkc2Ffc3dpdGNoX210dV9tYXRjaChkcywgcG9y
dCwgaW5mbykpIHsNCj4gLQkJCXJldCA9IGRzLT5vcHMtPnBvcnRfY2hhbmdlX210dShkcywgcG9y
dCwgaW5mby0+bXR1KTsNCj4gKwkJCW92ZXJoZWFkID0gMDsNCj4gKwkJCWlmIChkc2FfaXNfY3B1
X3BvcnQoZHMsIHBvcnQpKSB7DQo+ICsJCQkJY3B1X2RwID0gZHNhX3RvX3BvcnQoZHMsIHBvcnQp
Ow0KPiArCQkJCW92ZXJoZWFkID0gY3B1X2RwLT50YWdfb3BzLT5vdmVyaGVhZDsNCj4gKwkJCX0N
Cj4gKwkJCWlmIChkc2FfaXNfZHNhX3BvcnQoZHMsIHBvcnQpKSB7DQo+ICsJCQkJCWNwdV9kcCA9
IGRzYV90b19wb3J0KGRzLCBwb3J0KS0+Y3B1X2RwOw0KPiArCQkJCQlvdmVyaGVhZCA9IGNwdV9k
cC0+dGFnX29wcy0+b3ZlcmhlYWQ7DQoNClRvbyBNdWNoIEluZGVudGF0aW9uLg0KDQo+ICsJCQl9
DQo+ICsNCj4gKwkJCXJldCA9IGRzLT5vcHMtPnBvcnRfY2hhbmdlX210dShkcywgcG9ydCwNCj4g
KwkJCQkJCSAgICAgICBpbmZvLT5tdHUgKyBvdmVyaGVhZCk7DQo+ICAJCQlpZiAocmV0KQ0KPiAg
CQkJCXJldHVybiByZXQ7DQo+ICAJCX0NCj4gLS0gDQo+IDIuMzEuMQ0KPiANCg==
