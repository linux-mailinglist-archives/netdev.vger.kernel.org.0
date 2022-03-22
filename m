Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC004E3B7C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 10:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbiCVJMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 05:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiCVJMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 05:12:01 -0400
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2129.outbound.protection.outlook.com [40.107.255.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3AC7E589;
        Tue, 22 Mar 2022 02:10:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVEBw2DpiGxrX3fh8CCD4BCDozpUljAakCI7WMbbN/ygbtwzp6oWbVcJbBiXOBVB6bxDzg5us/8/EfLIspgyHplEq4y6YspjADZeRQuEYXLCyluBAeDDyV7GaFtceeHHXLIZ95ADh4dfH0EMM/vLhuAtyM5BltMSvf1tre51+vXGv2t2hWsFJ8FlYeC7qPh19BHvj/xRjxwWUfSsQaK4YCqPpqAZyYooD2v3/VtS8LQ3Y0VKJGrLflclUvEoGwRGS6e+oesGg2RK2zndUUVdTkVUzcpxftdQNCOfKWQ2xs+0sDmClKaE8o9eTL0oq/kb8P9YixLrEJYTx+n/4dY3IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0GOadY8wjRS4P7H6OQf0zYhzqc2SpOIY12nVYug/P8=;
 b=El6gebkVUr67QTF5CCrgHIhBPD0t/KfXuRTeLna46tePeXpfIRsyBcgEx5TK/dICFkNa0OYVUs0eyvUFXt3UN8efqwjDQHSPLBvyBlH4n7NngDktl0QAKtMtK2c0+6njv+gppAvZ/2QfTdpcCZu3ehlb4fRI5ox7bj8npsFKdnrnHbZvLMLIHNcX2kmgew/zlycpWOE+DEJU1hxoZhur/jS5GM2IACpO3Tur5m2DSL73xbG638JufzGpFw5RtsOIkRL+ji0cZiKHQn39BJITIOq4u3Kq1KQ6woF9XHZHoK7MZow4LY8dpE1hyfjreGt4HoYFaft206ua0VCSU4pVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0GOadY8wjRS4P7H6OQf0zYhzqc2SpOIY12nVYug/P8=;
 b=gIfMretgXAEJOxPE7I/UWteoFwSPnnaGSf5ftN3H10aZe2zSWNXKIheILA8eiQoD2Nvx59dGBm9GaRdwQ1EozqvZgJ7SaduH+SgZyLaRVD6fFVEhtWO61SmSDQOcAAjNGqiJ3EO1nGUN4cA7H1XtFT2wo5ZpYmyf0+DSwU1qb47ioj2st5QOVfh3W0cgGv8Q0K1eW+I6L13y4NFRoeRUw25LoPEzywl9UQKIC1khXEOdvaHWIPtWVhkL3XWfsvgf6JI9P4ef5cOD71ZAqxoHfU7PDad4i2CdsLFf4cZfPVhfqHS06LU9oEfhKZuVWbTgtaiP4NUzB3uX4mgPnQGxSg==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by TYAPR06MB2335.apcprd06.prod.outlook.com (2603:1096:404:18::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Tue, 22 Mar
 2022 09:10:28 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::e175:c8be:f868:447%5]) with mapi id 15.20.5081.023; Tue, 22 Mar 2022
 09:10:28 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH 0/2] Add reset deassertion for Aspeed MDIO
Thread-Topic: [PATCH 0/2] Add reset deassertion for Aspeed MDIO
Thread-Index: AQHYPPFxAnAfoEafR0q0cBMTgEqZAKzJv48AgAD+4aA=
Date:   Tue, 22 Mar 2022 09:10:28 +0000
Message-ID: <HK0PR06MB283430933D2FE015531B52749C179@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220321070131.23363-1-dylan_hung@aspeedtech.com>
 <YjhrUrXzLxvKtDP8@lunn.ch>
In-Reply-To: <YjhrUrXzLxvKtDP8@lunn.ch>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f57fd5e-7233-4427-4e99-08da0be3cf0d
x-ms-traffictypediagnostic: TYAPR06MB2335:EE_
x-microsoft-antispam-prvs: <TYAPR06MB23355021FE18D39643DD9CF39C179@TYAPR06MB2335.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m/Gr0wV/hqw82bzjhUYo8YXlzOtXP/8xWGlqkAdx8vr4gYVmsZhQX4rggts+mEh3QOIat0YCTAlQrKDr8gmNhFJtV9/wsj8iv+L5mn006pfroGYB5NgE0Ko085mUIhai2y3Cf7TwIC0CnwNFlBqe0sALyPcI/E5L5nYFFMV6jFtQ33DoO6cNGe+Wfi4SoGjitb1Mpf5hbOkQaaOzYDl+0j4r0FBZEIpEocyZcV1B1n36n3hD7qaLCWzxjjldoW4pnbBC8yQ+HzrQAlrLM7S9a7Tlv2lnXKlVidJjVEsXpBPMYdPzbKFWk6ki3v1/N6zd0VXSxlzHolZPi+ncOujqizr0S/ZpKtowgj0pMPw9qqUQMX41ONHdmf3pRGbY0XFguXPLkeTdAoFyCaHa4MCPqruFrxggDE0pmkYfvJKLDz3Ip5YHaA9HHOXgMsqB6TtgruymZTDMFd8mJFYoNU/U3YGlY3nHAQpmK4sQxw5Dg3FAVPUgkSYgec1Vj6B1aEgC1HIw/CliOnWUoaS7PdGpIcqkqX+PnC21abM2Uqcscd8YYxVt8flcYl3fFCynI1GVarPdO1YnOw1BgSG0wGTqQm8MMP6tT+OizmVjLT4dGsuUHWtzmMaUFzGTXk2YpQxaG+n9wHA9rg84lG9dhHE+Qdnx9UnHKSrW7tXauDwa1p6qobsjSyDh53ECtYpx1J3ldy/us3UZI1RxVDKjsPnr/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39840400004)(366004)(136003)(376002)(346002)(53546011)(66446008)(33656002)(186003)(26005)(8676002)(64756008)(66476007)(66946007)(66556008)(9686003)(55016003)(7696005)(6506007)(71200400001)(38070700005)(7416002)(8936002)(5660300002)(2906002)(4326008)(76116006)(52536014)(86362001)(316002)(38100700002)(54906003)(122000001)(508600001)(83380400001)(107886003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?VjQvSm1PbGlKNWRRQnRNdlkybDBHMTgrMzhDellybHQ1VUx3Y0JCZGpmVXVoZHBK?=
 =?big5?B?bVVSVmFoWTBvdWRaUjBPNE1RdWFWRjdVYjU3VUdzanNOcWFrcDRYUHNKQU52TitK?=
 =?big5?B?RGxZQ3NoT285aExkWlk2WEpnbC9oR1Z5NStJWmdlWmVyWHhlZFVkN1E4WVdiaDgr?=
 =?big5?B?ajgvZktiUk5pVWpObXJqeUVWQnRMQS9kWDJnYVBCTm9DM2R3VDBCUlZEeG9yZ1hm?=
 =?big5?B?aE96ZHZKSjM4dkxCdzU1cS9aSnVxQ21nUXdTam00cWlwSzJsdEoraUlwb2Vvaktu?=
 =?big5?B?cEp5a1pYTGFGaTBhcEw1VmM3NmlCd1IxWEhjamQzTGlSeUpNYWdVRm5vQzMreE5h?=
 =?big5?B?RmZyQzhTb09hcTYvSENUb3JqUlNiVU9QcnNLRGFZVUk0MnB1N3UyaDM2bERYalVG?=
 =?big5?B?d2l2MU5hNnRqa2JnMksyYXUrRjJhVXlPRkFka0MwRHNBM2N5LzZPbmlDZ1lTakVT?=
 =?big5?B?ZmdaQlRJM2NEclplSXRvUXBkb01vNmFZOEVwZW1rNGs2eXlhakNzcW9HalFzL25P?=
 =?big5?B?VGVEZFFXaHlzZ3czM09NaFU0cXg0UStvaGpFemw0cFNWa241Z3F0WnRqdGtYZXZP?=
 =?big5?B?anVjNmZuU1hJOWtvSkxIbG9RM2paTkowdVY5cCt5UnIxeFNSc0JWS2xWbFdLeUll?=
 =?big5?B?cXRyZlJSTFB5TGdCekJUSWNQeFJveFpFOVJMdmU3dHhrdWNYTmlXc0pveUIwTkNv?=
 =?big5?B?VXNSSnFkR2xQTTkzTWlqRUFLb0NvU2NWcStaVHJzQ0pQcHVaV1FRWWE4aHIzM29l?=
 =?big5?B?VVRMMWYrekRpTzMzQ0YwbmU0NW9kalllbHRkTVdPbjlzcmN5OXJSdCt3cGVWcU9o?=
 =?big5?B?aG5iWFhIWU9zYW5QdE9LS3V1emYyZWFpOGVmRVlEL2NLQVJTa1k3ZG5VMHNOd0pN?=
 =?big5?B?eXRTd3BuVG1mTzROYnJVM0tKMWJMcDBGalc4NXlJckNFVTM2c3hmM3lJMHFCVW9r?=
 =?big5?B?STcvbXRUTStkMXUzRkt4MjVoV2l3czFWbGJidGpHUndaNnhHWlB6TElVdnJPekll?=
 =?big5?B?bG5ieU5NeWVMeUVDUlFieU5jaEZlWVAwajIySXp4SERQb1NEdnV4T0lCMTVFRjlF?=
 =?big5?B?TFdtN0U4aFJvZU5BWW1CeERYOS9FcVI3c3Vya2xtYUwzVnUzQXB5WFBJeFBnSTlP?=
 =?big5?B?UTdURStHd2pTUjhHc2ovSzgwclRaOG41Tjc2RHdrc2x3cjBNOU96Q2dwdjlSR1lG?=
 =?big5?B?WjVWamV6cW1ndkp4Zi9GNHFXRlpXeVJYellBMWdTd0dxaGIyQVBFYjJHR1grMlRv?=
 =?big5?B?NmlXR3lka3F6UjB2UjJuRk13Z3N6K3JISk4ycytaZ3IxRzlTbHlqZ1pVTTNBU01P?=
 =?big5?B?MFczSjJhdVpvYmRCaUNXYnJRc3ZjTGtEbnJSdDBaaGZlelFBZ1lGWm1HMkYvMHB4?=
 =?big5?B?ejE1Q2pQbE1wMzY0YTVpL3ZnZzhIM3RvNVArandPUCtXYnRkTlh3bVF6bU9RUGw1?=
 =?big5?B?c3FpK1VwVm5UVXQxQWozeTg3VStSVVFQQ05jdHlGQWttS0JDRURjWGh6WmhmY28w?=
 =?big5?B?RCtqcXFPZ2toNFlpRG5nQmRLNEJzaWlaem41N2pSNGQ5S3h1dkZqYXdFb2FTbkxI?=
 =?big5?B?U0tvRGpyTnYxSHZQdVZPdEhlQzlGUW9uemdOcVJndVN1SlVNWnF1aG5rdGF2ekRt?=
 =?big5?B?S2c0cmRWQmFGbVdxbmJkNVdKTXpKelhubVErZHh2YkNWbmxnbG0xaWVjZHdHWk54?=
 =?big5?B?L0wwKzFvcWU1U3NYYllQZno3ZGRPWXBRaENZNkxwT0FVNGZkbFZPTzFwdkl0dEox?=
 =?big5?B?bi9icTBrK0IzYloyeUxxc3NUR3I3VUZFaWlVb01UdlB2TkJCU0ZOclN2NWVOeFha?=
 =?big5?B?UWpEdEI0SjV1N1dOTmJONUUzOWowMmhWYzdzQlJnQmQxb3lYclhKZVlTRkdFZ2FQ?=
 =?big5?B?VVJKOU5BPT0=?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f57fd5e-7233-4427-4e99-08da0be3cf0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2022 09:10:28.4490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EZviLM48Y6jWNUmrCPRijCBPXzjOYxtfeqa1iuvJyrv+wNp1IzOvrNMkUVH5TNZFE4lxhN2Nzp7FcvAAALzHkE/ez8RYPiekhUpNKU7Hy4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJl
dyBMdW5uIFttYWlsdG86YW5kcmV3QGx1bm4uY2hdDQo+IFNlbnQ6IDIwMjKmfjOk6zIxpOkgODox
MSBQTQ0KPiBUbzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6
IHJvYmgrZHRAa2VybmVsLm9yZzsgam9lbEBqbXMuaWQuYXU7IGFuZHJld0Bhai5pZC5hdTsNCj4g
aGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4ga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsgcC56YWJlbEBw
ZW5ndXRyb25peC5kZTsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS1r
ZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsNCj4gbGludXgtYXNwZWVkQGxpc3RzLm96bGFicy5v
cmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IEJNQy1TVyA8Qk1DLVNXQGFzcGVlZHRlY2guY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IDAvMl0gQWRkIHJlc2V0IGRlYXNzZXJ0aW9uIGZvciBBc3BlZWQgTURJTw0KPiANCj4gT24gTW9u
LCBNYXIgMjEsIDIwMjIgYXQgMDM6MDE6MjlQTSArMDgwMCwgRHlsYW4gSHVuZyB3cm90ZToNCj4g
PiBBZGQgbWlzc2luZyByZXNldCBkZWFzc2VydGlvbiBmb3IgQXNwZWVkIE1ESU8uIFRoZXJlIGFy
ZSA0IE1ESU9zDQo+ID4gZW1iZWRkZWQgaW4gQXNwZWVkIEFTVDI2MDAgYW5kIHNoYXJlIG9uZSBy
ZXNldCBjb250cm9sIGJpdCBTQ1U1MFszXS4NCj4gDQo+IElzIHRoZSByZXNldCBsaW1pdGVkIHRv
IHRoZSBNRElPIGJ1cyBtYXN0ZXJzLCBvciBhcmUgUEhZcyBvbmUgdGhlIGJ1cw0KPiBwb3RlbnRp
YWxseSBhbHNvIHJlc2V0Pw0KDQpJdCBpcyBsaW1pdGVkIHRvIHRoZSBNRElPIGJ1cyBtYXN0ZXJz
Lg0KDQo+IA0KPiBXaG8gYXNzZXJ0cyB0aGUgcmVzZXQgaW4gdGhlIGZpcnN0IHBsYWNlPyANCg0K
VGhlIGhhcmR3YXJlIGFzc2VydHMgdGhlIHJlc2V0IGJ5IGRlZmF1bHQuDQoNCj4gRG9uJ3QgeW91
IHdhbnQgdGhlIGZpcnN0IE1ESU8gYnVzIHRvDQo+IHByb2JlIHRvIGFzc2VydCBhbmQgdGhlbiBk
ZWFzc2VydCB0aGUgcmVzZXQgaW4gb3JkZXIgdGhhdCBhbGwgdGhlIGhhcmR3YXJlIGlzDQo+IHJl
c2V0Pw0KDQpEbyBJIHN0aWxsIG5lZWQgdG8gYWRkIGEgcmVzZXQgYXNzZXJ0aW9uL2RlYXNzZXJ0
aW9uIGlmIHRoZSBoYXJkd2FyZSBhc3NlcnRzIHRoZSByZXNldCBieSBkZWZhdWx0Pw0KDQo+IA0K
PiAgICAgQW5kcmV3DQoNCi0tDQpEeWxhbg0KDQo=
