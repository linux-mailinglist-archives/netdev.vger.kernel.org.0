Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F68418387
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhIYRUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Sep 2021 13:20:49 -0400
Received: from mail-vi1eur05on2117.outbound.protection.outlook.com ([40.107.21.117]:21216
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229542AbhIYRUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Sep 2021 13:20:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7spL1SmyXidzT+P9NTThqrBX9p4ieZ5I87r/nnP2PImRwTYbIS7ns5NEHLZgNJzUHDO5AE7kDAGBrHMEJNbMkfC0Dly8X81ePnS4hZucEA677Mj4Qsj3L5STXeZYQ6Bk8AsbAhViITA/cHQ912aBkgl5pP+0UcCsLBHmA/hCk6JoXmIFIOtmK3xyWQd6bPi9FTOwWWYpuiu5J86lxvoBTRMKK4lp5Zyobo9AkmekHkSCn10BI0YdhMoTOdWdnis3e7sNi+zdTzwrTRD0jwFKE46gNnyhQMEoT0uCboBamPCnaQJqVk/VdoAxjKd09v8wU84+vQH3vAX22wXJc8/hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=21JABPnfUNg5fea4d5Ha5VE7yera50Dh847W6U3XsSg=;
 b=lDuHDGpHAzEl4jkRIplNmue5wAp5cj3nGlKw29ygG1w5lHb9UPQbE0u2YPXJ7z0689j4pjqy6pVUzihO45m6fDsObGhuBsep+Zr76/B7OukVNtkFwsQsqeH3VgqIBxOraGkyYrU8xwo2SxN4nwAvRKuiaq1VZILaHr/FafEA6qtqpAJhOtnMrhfwsLzvOdY82cWNffF86FFga8X0RJcxlWrtE8rPzSRoysf/o0LEkkpMqPeYHCFkjZn4Ga6+ZmYpuehF11CG6h+ke9q/4Boy/xXYjEBhTtyZ3CKOOmLCqlPOjkrO5EgFtEew21tOsL2k/oMPknUoZFXJPgv4mfAYIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=21JABPnfUNg5fea4d5Ha5VE7yera50Dh847W6U3XsSg=;
 b=P/0SW7+d0W0zSccP22WDnOX32gM/+y7HlGuaNGoNpdH3BnKseGuUSP5kwvF8US3OkaN/AaC38nlt1dzU0PLA3hT76szyHaX+yHrJIK2nmHo+NdmZY3zJZAnxqHRnyTIO6QdAuXLmCYtzI8CriVJdiYgrchBSxt3Cl7UJ1qoGB6Y=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2139.eurprd03.prod.outlook.com (2603:10a6:3:1d::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4544.15; Sat, 25 Sep 2021 17:19:10 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d550:ffc2:ab2e:8167%6]) with mapi id 15.20.4523.018; Sat, 25 Sep 2021
 17:19:10 +0000
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
Subject: Re: [PATCH net-next 6/6 v6] net: dsa: rtl8366: Drop and depromote
 pointless prints
Thread-Topic: [PATCH net-next 6/6 v6] net: dsa: rtl8366: Drop and depromote
 pointless prints
Thread-Index: AQHXshDWjAABwkfsyUOhhTcFnwOwa6u0/sWA
Date:   Sat, 25 Sep 2021 17:19:10 +0000
Message-ID: <05c9283a-d7f7-b3ef-af3d-c750eecc7b98@bang-olufsen.dk>
References: <20210925132311.2040272-1-linus.walleij@linaro.org>
 <20210925132311.2040272-7-linus.walleij@linaro.org>
In-Reply-To: <20210925132311.2040272-7-linus.walleij@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2fed4a3-4180-4a65-f9c1-08d9804896be
x-ms-traffictypediagnostic: HE1PR0301MB2139:
x-microsoft-antispam-prvs: <HE1PR0301MB2139595B0E1594DA2066F58883A59@HE1PR0301MB2139.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5TqmR7EAiWUc8A0BvR40VSXxQ+Echuq9EKP9HnrVAywbDHY3v2DDWr7/bBP1ezrYvU2Ifp2EICVZIVZNGsxH04LIMVqGLNlrTl/R0qidieQhUtQMbEZhf75IcDhCgTT1/XPn6AaAZQtiDUJy1QTnRFbdDpgyNhl494DLFoQJyAeb2SXst/ogCVa4wKmp0odY1FPBqHRgagrYxSHMk+5ZCpPHmRQnczRb8IazIuwyPIO1kRKwad5UJmskywFH7qbOpQAjlhlP8E4LZtlBohKu/a6AYrtxaIskk5iYY6PrpaSrWhu6sqsS8w4f9B79zO8TErZMoGZO6/f4gA7uKn9LYg1cv20X1OAULMiD7YHjjARN4onxSofV/elh3kJzGj4HPgATWT5pwUl6jB+Il1QepvE+IBQYf/ce8dNRA5JkMDzzygmdhVlxq2sjjNPapEo0GSjudJcN/wjdnaI0+VhqrBw8GAjmDUGwbxUaxDWgmJ8HHmUXkohX60EoLa37aUdAnZRaJWHwYMGtLjh8uIczBaoi4/rAGpq3osuA25fDbwRO9u2NxixF9mDVFHx7psiXRxgIDwhktEXCk0OaKztBDZJE5uQDW1ABNHnaSGlnUoS5LUheiyVJ/15MxhuelVei9pb/cvV6E+fPymV2cfadIeqLlZYjYXpTPd+M/VvjX5ffdfBJsPSdyifYs7QuhUCy1wG4Q9B2R+6rWzeniCaj9NRDUCPIB+39EG+9BisqtRKzV1Zuitb0u4f7/q079Rv1Dktah/+wXz7G4XSzXV3CcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(53546011)(6512007)(66476007)(6486002)(8936002)(76116006)(64756008)(31686004)(4326008)(26005)(54906003)(110136005)(8976002)(8676002)(66556008)(66446008)(5660300002)(2906002)(38070700005)(66946007)(2616005)(38100700002)(85202003)(7416002)(6506007)(36756003)(86362001)(508600001)(186003)(71200400001)(31696002)(85182001)(83380400001)(122000001)(66574015)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHhaT0hSL01VRnJNRWllekJTS1JRK3RmT05laU1pWldPNityTnhGbDUxZG9o?=
 =?utf-8?B?NUl1bUdaU0RIMnRtKzZmMFVLYVgyaUM1ZU5OOThTOEtaNzdrNWo1eU8zTEJj?=
 =?utf-8?B?dk1lRFRaKzY2REFGaTR1Skwrdk40MG0vVDlrQWhCNTNxc0JITFZUcUlnVmVw?=
 =?utf-8?B?dTFtREdPRTBnM0lBUnQ1aHFDU0VpRWJjbVQ1enFEN0l0OHhEb2o0d2lmQU4z?=
 =?utf-8?B?c2x4TXFQR1VRRmNrcVpvdWh2Y2NCb2hwbnNtanVCK2FXT1JuSEpvRFVpZHV3?=
 =?utf-8?B?VTJKVzlKYzVmNlpuZmF1QUFpZVdZc3o1cElrNmpTVGJCaTF1NU5xb08rcW84?=
 =?utf-8?B?QXVOMHdWMkdZWjJ2dU4xdVlKeUxmWXp6UE4vRmZzVFFsa00zd2I5TVl5VDFv?=
 =?utf-8?B?dkZ3K1dEaWpkRFZoc2RpSy82K0VuWWd1aDIvVlpHWFJ2aXpJbjdOaXZpMDdo?=
 =?utf-8?B?dnVTTFVzT09oMmRwSVFVUXg0VXY0NCtIeWNtdy8xc2xhMjR2bnBuWW9nTll1?=
 =?utf-8?B?N1FmclFsMUVnSUlNbUhzUEt4dll2ZEVreXFEZFVFQzhtdGNiRmd4R3MxeEZn?=
 =?utf-8?B?NXpFZWVsYTdKbU1zVnBoNTF2cEc5Ty90NjZqUVpOdHVBd2hnamo4U1MrcFpH?=
 =?utf-8?B?L2tFZ3UxQW5ZSnlUMmxVRVR5TXN3Ym9QWE5MV3hwS1VQZHNLRlVMQjJBQ3o3?=
 =?utf-8?B?Z0E2NEh1OENnNWdYeTJhRnVmVG5KTkFjZVd0d1ZJOWh2aC9QbjdSY3NFSmhu?=
 =?utf-8?B?MnFVVzR5dkhhK2ptYnJ0c2d5SSt2SzB3OTliOHZSZzEvMGVUNFFkU3pEajQ3?=
 =?utf-8?B?WVVuakhDVDRabmF2YUkyYmJmV2ZSVkJla2Z0TURqbGdIeW9Kcm9BamVnMko5?=
 =?utf-8?B?Qm5HZWxyQndyR1EyL2pJRjJ4Wi91c08rV1Z5TVh2elRDeWx1MHFiMGtjUGlv?=
 =?utf-8?B?dXV1UUJ1a0F0QVhyaHB1Y3ExNzBlclVReHhkWUNhakFKaHFHNjVuZ3JMZk5O?=
 =?utf-8?B?UHJNRk1VM0p4NWluNDRtalRoUXpuRDRrK1VkQzNXM2VNakUyNDgxa2lmSUxw?=
 =?utf-8?B?eVgzTXNXZGhBYlBMaWZab085bEp4MWJlUG96di81YUZub0VJSGVRUmNtaTRM?=
 =?utf-8?B?UktzNmEzblBISXlMZWg0Vll2N0w4RURpMFRYZm1JaURkT1ZQUWlTSXFIVll5?=
 =?utf-8?B?NU8yYUV3eTc2RkU3Z0g5T0grZ29MTkNJZi93UzhhNTdQdlRpdEtqRlJvdkNG?=
 =?utf-8?B?YnhDTGtINDdycUt1YzdlUmRWRXhwbHowK0pMTW1lT0pkZGd6NyszOThtS2h2?=
 =?utf-8?B?L0lCclFzNjlFYjgvVXVGWEZORDVMYTFpNmorOFJGZytSSnpML0VQL0YvcnQ5?=
 =?utf-8?B?bnBjNFQ1Y2pneVoxdHF4ZnBla3VCS21MZFIvQUVLSTljVjBGQWZCZ285VnZI?=
 =?utf-8?B?ajdiU2RiUnZYcHdhNHFBTVQyWVJNYzI2TStuWHp4bjhrbFRSbWxVUG9ucTRP?=
 =?utf-8?B?V1V4N2FoWFllcWFObGpOOFhvcWVXZWpQZGU0Y05iTzVmRFN2cjhiQTU0aVBB?=
 =?utf-8?B?MTVTblJ5alhLOC9CeXNCeTBZUklVZEt2UnJtcElNUC9UN3k2THM5UFNyckxO?=
 =?utf-8?B?NzZhSTNiVlNHczVodzZueDlHUC9qandldWk3QVU3QlJPbDJOQ1NCcjhwbjha?=
 =?utf-8?B?cDl2YWt0d1NGWmt2eXhONUhGRm9JaWNqeG1JWlJsK3FQZmpKQVVzcmx2YS9l?=
 =?utf-8?B?eXk5NFNBbitQc2hTSVQvRG10c1F3cmZsK3JRdWw3VjBuRjFkUm1TT2x2dEhZ?=
 =?utf-8?B?M1Z1OVl4YlExbHFqMFEzdz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8DF407D6522A61488590A2BAD16681BA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2fed4a3-4180-4a65-f9c1-08d9804896be
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2021 17:19:10.3535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyKV/LpWsw5OvmILLYDi4huDbGxaeUDBN+o4e4X+NoFWfyVxcDsHwuvY++5jJUyLugaRXmz2nBQRWvCawps6QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8yNS8yMSAzOjIzIFBNLCBMaW51cyBXYWxsZWlqIHdyb3RlOg0KPiBXZSBkb24ndCBuZWVk
IGEgbWVzc2FnZSBmb3IgZXZlcnkgVkxBTiBhc3NvY2lhdGlvbiwgZGJnDQo+IGlzIGZpbmUuIFRo
ZSBtZXNzYWdlIGFib3V0IGFkZGluZyB0aGUgRFNBIG9yIENQVQ0KPiBwb3J0IHRvIGEgVkxBTiBp
cyBkaXJlY3RseSBtaXNsZWFkaW5nLCB0aGlzIGlzIHBlcmZlY3RseQ0KPiBmaW5lLg0KPiANCj4g
Q2M6IFZsYWRpbWlyIE9sdGVhbiA8b2x0ZWFudkBnbWFpbC5jb20+DQo+IENjOiBNYXVyaSBTYW5k
YmVyZyA8c2FuZGJlcmdAbWFpbGZlbmNlLmNvbT4NCj4gQ2M6IEFsdmluIMWgaXByYWdhIDxhbHNp
QGJhbmctb2x1ZnNlbi5kaz4NCj4gQ2M6IERFTkcgUWluZ2ZhbmcgPGRxZmV4dEBnbWFpbC5jb20+
DQo+IFJldmlld2VkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogTGludXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3Jn
Pg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNl
bi5kaz4NCg0KPiBDaGFuZ2VMb2cgdjUtPnY2Og0KPiAtIE5vIGNoYW5nZXMganVzdCByZXNlbmRp
bmcgd2l0aCB0aGUgcmVzdCBvZiB0aGUNCj4gICAgcGF0Y2hlcy4NCj4gQ2hhbmdlTG9nIHY0LT52
NToNCj4gLSBDb2xsZWN0IEZsb3JpYW5zIHJldmlldyB0YWcuDQo+IENoYW5nZUxvZyB2MS0+djQ6
DQo+IC0gTmV3IHBhdGNoIHRvIGRlYWwgd2l0aCBjb25mdXNpbmcgbWVzc2FnZXMgYW5kIHRvbyB0
YWxrYXRpdmUNCj4gICAgRFNBIGJyaWRnZS4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3J0
bDgzNjYuYyB8IDExICsrKystLS0tLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9u
cygrKSwgNyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2Ev
cnRsODM2Ni5jIGIvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjYuYw0KPiBpbmRleCBmODE1Y2QxNmFk
NDguLmJiNjE4OWFlZGNkNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3J0bDgzNjYu
Yw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcnRsODM2Ni5jDQo+IEBAIC0zMTgsMTIgKzMxOCw5
IEBAIGludCBydGw4MzY2X3ZsYW5fYWRkKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQs
DQo+ICAgCQlyZXR1cm4gcmV0Ow0KPiAgIAl9DQo+ICAgDQo+IC0JZGV2X2luZm8oc21pLT5kZXYs
ICJhZGQgVkxBTiAlZCBvbiBwb3J0ICVkLCAlcywgJXNcbiIsDQo+IC0JCSB2bGFuLT52aWQsIHBv
cnQsIHVudGFnZ2VkID8gInVudGFnZ2VkIiA6ICJ0YWdnZWQiLA0KPiAtCQkgcHZpZCA/ICIgUFZJ
RCIgOiAibm8gUFZJRCIpOw0KPiAtDQo+IC0JaWYgKGRzYV9pc19kc2FfcG9ydChkcywgcG9ydCkg
fHwgZHNhX2lzX2NwdV9wb3J0KGRzLCBwb3J0KSkNCj4gLQkJZGV2X2VycihzbWktPmRldiwgInBv
cnQgaXMgRFNBIG9yIENQVSBwb3J0XG4iKTsNCj4gKwlkZXZfZGJnKHNtaS0+ZGV2LCAiYWRkIFZM
QU4gJWQgb24gcG9ydCAlZCwgJXMsICVzXG4iLA0KPiArCQl2bGFuLT52aWQsIHBvcnQsIHVudGFn
Z2VkID8gInVudGFnZ2VkIiA6ICJ0YWdnZWQiLA0KPiArCQlwdmlkID8gIiBQVklEIiA6ICJubyBQ
VklEIik7DQoNCnMvIiBQVklEIi8iUFZJRCIvDQoNCj4gICANCj4gICAJbWVtYmVyIHw9IEJJVChw
b3J0KTsNCj4gICANCj4gQEAgLTM1Niw3ICszNTMsNyBAQCBpbnQgcnRsODM2Nl92bGFuX2RlbChz
dHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgIAlzdHJ1Y3QgcmVhbHRla19zbWkg
KnNtaSA9IGRzLT5wcml2Ow0KPiAgIAlpbnQgcmV0LCBpOw0KPiAgIA0KPiAtCWRldl9pbmZvKHNt
aS0+ZGV2LCAiZGVsIFZMQU4gJTA0eCBvbiBwb3J0ICVkXG4iLCB2bGFuLT52aWQsIHBvcnQpOw0K
PiArCWRldl9kYmcoc21pLT5kZXYsICJkZWwgVkxBTiAlZCBvbiBwb3J0ICVkXG4iLCB2bGFuLT52
aWQsIHBvcnQpOw0KPiAgIA0KPiAgIAlmb3IgKGkgPSAwOyBpIDwgc21pLT5udW1fdmxhbl9tYzsg
aSsrKSB7DQo+ICAgCQlzdHJ1Y3QgcnRsODM2Nl92bGFuX21jIHZsYW5tYzsNCj4gDQoNCg==
