Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8D86A6C62
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 13:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCAMcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 07:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjCAMcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 07:32:13 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2056.outbound.protection.outlook.com [40.107.104.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63683CE05;
        Wed,  1 Mar 2023 04:32:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qnz8VxnnqtJXbyv7m4RA7plm5CrYDMDz7nVKSgH5kaimfGUqL3HraoREfQyeKEL35zN/VugBLwLNSF8+2CiK0g0dh2FP0t5e8+8CATNMvug+iZIw3wAnvFI3by9izwe9M5kwIZEtMj2JxL3dEzJ5fJwMRjMGc+CQjS1CgybrnVS0M3FEOKFocmJdOCygKwnXrSBJG1F1L6cjdWmQmJ2LQTztx9sO72XoAf0sQ8qNVkqlXtI+bUFueUTOSS7JVC71XXtQxyNK7q9gSP7Tp3nbhfzA/mI2EYa8rKSDY2774NB8XxxcgWy5FSxMuChq5j5IpB7GD1FZux5EV2Ky+p5cPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+YsLAjDV18pRBaEfC5x57YFbbX1oDARzEGlrTCGD9Tc=;
 b=kgOqnkLxKocnQt6NMVsOBsfCrd4T3cREPuxlkXrKLPJE3tJbEWLdcqk6yKjTBRPsXHvo+5vNgWr+6k7zp4jTUpffsYFltgSsjfJjZ3NuhDx7JIlbX99mV1yVNYAmybCb9nJqfJ7YjzDt06cT5Q8vWzYp3Yau4xNzqxRRj0nHKwAOEC9iq2N3w6YkfDFdXsQyoVM052Y1l65lCBPKjAg7nLbw1/KifwAYUYj39lJPh32mD4GaboDl9WUaYfafjfR4ZdSpcH45qrkrAdMvb0a8e7FRYghQEnihy19zPLwtO0XQ+C8yDJb5HfC5hgSZk+INahW7Jw2ph9EFiHCC7xLllw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+YsLAjDV18pRBaEfC5x57YFbbX1oDARzEGlrTCGD9Tc=;
 b=Y2zHpSte+nXJcSqv6MQvdElxa6ZgM7RY8kQcfiRR7yM4s4myVsb/0lMKg7nBhxZXkclnalnLcDwu3HSLndRQaJTn2koocoohiLxwORoGYnM+6GKfmqEDQjsiprlMZaGwBoroqhyHrwwXcikpeaJ2ZbenB95QpTskDYdpwZ3vsyjyGmdXLsX51e5LSbkll8KtDCK8SUknkDJOZ9/ScxxxNvkcnD75NXVjVj/YrFbuGn1fpJqmcNojR9imP02KYBqpeTRRMhW0bF9z0RjFOIeYMRJfSUGxhNYJsRtVT4eiEtnwO6+PYQsWAA7rmi+4D9g5O0XldxLTT5SwcT3JS2NMsA==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB8013.eurprd08.prod.outlook.com (2603:10a6:20b:572::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 12:32:08 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::27d4:87f6:273e:4a80%7]) with mapi id 15.20.6134.025; Wed, 1 Mar 2023
 12:32:08 +0000
From:   Ken Sloat <ken.s@variscite.com>
To:     =?utf-8?B?TnVubyBTw6E=?= <noname.nuno@gmail.com>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ken Sloat <ken.s@variscite.com>
Subject: RE: [PATCH v2 1/2] net: phy: adin: Add flags to allow disabling of
 fast link down
Thread-Topic: [PATCH v2 1/2] net: phy: adin: Add flags to allow disabling of
 fast link down
Thread-Index: AQHZS6WUJoETapLTTU6PD9TwANhvf67liPQAgABSHhA=
Date:   Wed, 1 Mar 2023 12:32:08 +0000
Message-ID: <DU0PR08MB9003511098F64F0DCAC2F013ECAD9@DU0PR08MB9003.eurprd08.prod.outlook.com>
References: <20230228144056.2246114-1-ken.s@variscite.com>
         <20230228184956.2309584-1-ken.s@variscite.com>
 <8f1b8b57a963d457714e2ea008761f05d8848814.camel@gmail.com>
In-Reply-To: <8f1b8b57a963d457714e2ea008761f05d8848814.camel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DU0PR08MB9003:EE_|AS8PR08MB8013:EE_
x-ms-office365-filtering-correlation-id: 9af2cd58-bf59-4b7b-b221-08db1a50f91d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+AY9EfuHdiVvi7xWz5TN5k0u8W3YFAcmiRhvIedTtjOsw7+oLKV1VyMPyxGN46v3mqfPgtTWPwvfsBx959oBHAKOMWBd0vPzYbxV4mbryZU0R59spDWkKVcsjUm1V0RM9O2XeHfx+BU+pjQZ8xtrS5dW8GV+PkWtVjiQlvq3PPTXn0O0wIYVx6HafrnFnxydHK5wGDsaTxwYqES2NpgZh18FCWY5cZ09o4jerPJlrO1yNrodPy7ELj7oC2gpgB2l5bhqmT43lQaDjjpiD1dFSCDpMz6jcZ1BLAZ9kMQD+d4vOYjlfrvuJhg9jjfbMt4z2EnaMAh4OM1nkIGLcUUZfDIORwykTq44lPqNyIJKvqqSNIiObGXZeW2idHvK01Hl35JUxoFTwZTZMChfNHxCDol7aAIijPQhgkUGAP1quJNRw/+MoEeMNJ9qp2QAA79XwD2sTutqHOeDT8ccHVy5IRoj0zpsXONOD8nCsMXBKrfVwj5gCFgh+LDef1IooVXU04xkThzyEG4ylG3KFQ5qWzweuttCGkVS0ClFCGp2w5vPTJILLQQzOtL7wTe0zp12Ra5XRgCkhArOmJ94w1wzOXIBitdE/pduAXij1ZdkSlgGqwZASke/qVokzOjb5DOmoXDQIRaCHmPyvUOuQQ97CGCF7dGkAayyO2wHDAGyV23dbYcp7l/ZVCyhgzOgMLEaF2VnnJHUgWYje+Aty960g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39850400004)(136003)(396003)(366004)(346002)(451199018)(33656002)(54906003)(316002)(83380400001)(478600001)(71200400001)(107886003)(7696005)(6506007)(53546011)(26005)(9686003)(186003)(8936002)(2906002)(52536014)(38070700005)(41300700001)(86362001)(66946007)(5660300002)(7416002)(55016003)(66556008)(64756008)(66446008)(6916009)(76116006)(38100700002)(122000001)(4326008)(66476007)(8676002)(66899018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RCtQdWM3dzVyQXlUTlZxeVdQbmQ4MFMvUE90QTVnRUtDT3hsUmxxZFhHRkdU?=
 =?utf-8?B?eGNLWmFGWE9IM0tNcnk3UVBPUURyNXA2KzIwN1haSlJoOXhkOUdzYzVwejZK?=
 =?utf-8?B?cnlteUYzNExjMS95ZmlEaWh0R1FybGZPU2ZtenMybFJ4QXJEQlh6U3pxZ0JW?=
 =?utf-8?B?SHc5NWFHVlRkelNOUFI2eFlab1k0RHVvRis0a0dWcGcxcm9vak1VT3lxNTNr?=
 =?utf-8?B?Sm5BNmowS1lUNllNTytsUkhFK09FeFpVaDc2VlZ4Q2piOFBxNTBzbW1odlFC?=
 =?utf-8?B?Yi9VZGhFc3NxejNNS1VzZHhCdEVjZ2JXbk9MN2V0dXVpVnBySU84QlpkK1Fz?=
 =?utf-8?B?MzNDbFhDdDNoSFRDRWtpVzVydGE5UVRTZko0ZlAxUkxZQjhhMG5TaXlWdldt?=
 =?utf-8?B?WWJBdzJXY0wrZWNEcW1sUkdHcFJtSHV2dnYvZmxNV2tIY3ZoZ0JocjNIVmNy?=
 =?utf-8?B?M0pzbmdVR1ZMWjN5Qmt5QllENzRaY1huS0p0WWkvUmxIQ3h1M2xMTldwZXdG?=
 =?utf-8?B?YWFsVk1ObVI4L3JjdlArREVKdS9KeDJjMjJ6a1hiL3FkR0p3RXBhWnRsUGNW?=
 =?utf-8?B?UnVHaFFjQ1ZEb0l1ajZlU0pQQkk5WkJkZzA5ZXN4K1dUbnBEdTVHblg3SDFW?=
 =?utf-8?B?VERTYTk4cy9YZm9QRlZSZ2FoOU9vUWdJbEFveFVHWUhIWWZCck95U2tjMUFV?=
 =?utf-8?B?M0xUM0J0MFd5VmFjV1cvZjcwNTEydXE1cHhBTHc4QjVYeGdvb0syNUtYaVRZ?=
 =?utf-8?B?VnhNS3RWUm90RkJSL1k2dHh3Sk1uRDVsd3hkZkJlcC9lVGprMWk4Z2Qzd1JT?=
 =?utf-8?B?dnlONG9yU2JGQUdyR3ZzckFaU2dBbUxoYUg4ajhVMWFaakFUc0FZeStEVlhI?=
 =?utf-8?B?Q1lyRjRFRTlGME1COHpESkZLYzU3aVdidmgzNEFBcnBrUTNwWFd4M0RjcWtR?=
 =?utf-8?B?dXNoS0p5VkdYMmE4Tk1NQzJYbXNqQVUrdHNQVEdQeDFPdjNLWExsSHU3aWJX?=
 =?utf-8?B?MTRxVDJqMkNEZW9hK2lsbkFIb0RaUEQ3Wk9ncDB1c3M0VS9jS3QvaDVTK0NS?=
 =?utf-8?B?VDFpRkFCS2VWajE4aUtMbXFYUEgybkp5ODA2WTNnOFZwVkZPQ3QyMk5uVlIx?=
 =?utf-8?B?dzRZUHNLZ1pQckZPNnJHR3ZKVGp3dTIrSVIwTW9LR0J5MkwyTDUxK0h5VUNn?=
 =?utf-8?B?Ym9LRHZGSDA5N0hxano0bjFaMk8yWjJhRXhCR1c4Y3dEWEorSks4UTNyYlJE?=
 =?utf-8?B?RUR1dG5YdHgrQUdYTDU2MGNPSHF0WENRUlJMdDBKZUJKaC9HZ25ZdWJuSGtQ?=
 =?utf-8?B?NjlEZ1lxV3BNVWw3eTZNTTAxVDFqMWZXUzgxSFhXamVScFFHRUtZSWpKRzk4?=
 =?utf-8?B?S1RwVEdkck9lUkdGUFRvUXRYZGo1c2RicGRiQkhIQnZ4WWRzRFc0OHNmNFM2?=
 =?utf-8?B?bHZFZjZLSDdDWXF4MStmUjJMaUxQN1dicS90bEczWkJDcnF1ZGEvLzRyU3Bl?=
 =?utf-8?B?OTVPR3FtWFVyd2N0d3V0Qk5qTnhHK1dsSHBuUXlWNm1UNHcxQ2pqRVduMVNR?=
 =?utf-8?B?bkx4MFRrRlo4VlZaY0p2aE1OZHUyMUhLdm5ZSDMzN0oyTENEZ0NyOGFkbCtQ?=
 =?utf-8?B?RW0yVTZuTVJsQ1NtdEIyZ2l3S2NXOUswTW5oQm9pd056TDZHQVl5ZmNpdmtB?=
 =?utf-8?B?TTNnR0dPNG5Cdkd6dkdyVzhaTzlUOVNLcDZhR0QxWFNkME40b0RraHh4T25H?=
 =?utf-8?B?cC9BbDZzWVVuUnREUXlRSDIrMkttcnBpRXQzQWpBZ2RGajVJOFN0dm1LSlUy?=
 =?utf-8?B?SnZXekJkMnVYcTVuRTdueDVnWm9lQjBSRTJxRWpKYnpIbnB0RDA1d1lGSjBq?=
 =?utf-8?B?VWVyVElRTFB3ZU9HVm9oU2J0Yyt0MHF2eWs1dDRKYlNSRi9xcEZEVTZFaG1I?=
 =?utf-8?B?VDZJVDFLRVVYcjBseEJUNHJySEo3KzRiU3RtMjVZT3BvUFpIYTVWaDIwYmlL?=
 =?utf-8?B?UExwT1NBcDc3ekJtMVJhZlA4VVBQTnF0SmprL1hXUnBuUEFmZjd4N2grYlFS?=
 =?utf-8?B?ek9vZWVJRmMzUTJPdXlUSTVJSnBxZC9qOEdLNlB4TkhBNUVsbyt3V2JyRWkv?=
 =?utf-8?Q?+5aRWqRWuIUudWbzoAzIz59hL?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af2cd58-bf59-4b7b-b221-08db1a50f91d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2023 12:32:08.0361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qO58YrjEpqhwI/VdS7bHbrRweCcbCgJ0MaPy1AfeDEe7zbHVrTQTwuzQ7s0dJbgpjsSxGxXk9ZWeYtTsW0C95g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTnVubywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBOdW5vIFPD
oSA8bm9uYW1lLm51bm9AZ21haWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDEsIDIw
MjMgMjozNCBBTQ0KPiBUbzogS2VuIFNsb2F0IDxrZW4uc0B2YXJpc2NpdGUuY29tPg0KPiBDYzog
cGFiZW5pQHJlZGhhdC5jb207IGVkdW1hemV0QGdvb2dsZS5jb207IE1pY2hhZWwgSGVubmVyaWNo
DQo+IDxtaWNoYWVsLmhlbm5lcmljaEBhbmFsb2cuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxk
YXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFJv
YiBIZXJyaW5nDQo+IDxyb2JoK2R0QGtlcm5lbC5vcmc+OyBBbmRyZXcgTHVubiA8YW5kcmV3QGx1
bm4uY2g+OyBIZWluZXIgS2FsbHdlaXQNCj4gPGhrYWxsd2VpdDFAZ21haWwuY29tPjsgUnVzc2Vs
bCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+OyBBbGV4YW5kcnUNCj4gVGFjaGljaSA8YWxl
eGFuZHJ1LnRhY2hpY2lAYW5hbG9nLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRl
dmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjIgMS8yXSBuZXQ6IHBoeTogYWRpbjogQWRkIGZsYWdzIHRv
IGFsbG93IGRpc2FibGluZyBvZiBmYXN0DQo+IGxpbmsgZG93bg0KPiANCj4gT24gVHVlLCAyMDIz
LTAyLTI4IGF0IDEzOjQ5IC0wNTAwLCBLZW4gU2xvYXQgd3JvdGU6DQo+ID4gIkVuaGFuY2VkIExp
bmsgRGV0ZWN0aW9uIiBpcyBhbiBBREkgUEhZIGZlYXR1cmUgdGhhdCBhbGxvd3MgZm9yDQo+ID4g
ZWFybGllciBkZXRlY3Rpb24gb2YgbGluayBkb3duIGlmIGNlcnRhaW4gc2lnbmFsIGNvbmRpdGlv
bnMgYXJlIG1ldC4NCj4gPiBBbHNvIGtub3duIG9uIG90aGVyIFBIWXMgYXMgIkZhc3QgTGluayBE
b3duLCIgdGhpcyBmZWF0dXJlIGlzIGZvciB0aGUNCj4gPiBtb3N0IHBhcnQgZW5hYmxlZCBieSBk
ZWZhdWx0IG9uIHRoZSBQSFkuIFRoaXMgaXMgbm90IHN1aXRhYmxlIGZvciBhbGwNCj4gPiBhcHBs
aWNhdGlvbnMgYW5kIGJyZWFrcyB0aGUgSUVFRSBzdGFuZGFyZCBhcyBleHBsYWluZWQgaW4gdGhl
IEFESQ0KPiA+IGRhdGFzaGVldC4NCj4gPg0KPiA+IFRvIGZpeCB0aGlzLCBhZGQgb3ZlcnJpZGUg
ZmxhZ3MgdG8gZGlzYWJsZSBmYXN0IGxpbmsgZG93biBmb3INCj4gPiAxMDAwQkFTRS1UIGFuZCAx
MDBCQVNFLVRYIHJlc3BlY3RpdmVseSBieSBjbGVhcmluZyBhbnkgcmVsYXRlZCBmZWF0dXJlDQo+
ID4gZW5hYmxlIGJpdHMuDQo+ID4NCj4gPiBUaGlzIG5ldyBmZWF0dXJlIHdhcyB0ZXN0ZWQgb24g
YW4gQURJTjEzMDAgYnV0IGFjY29yZGluZyB0byB0aGUNCj4gPiBkYXRhc2hlZXQgYXBwbGllcyBl
cXVhbGx5IGZvciAxMDBCQVNFLVRYIG9uIHRoZSBBRElOMTIwMC4NCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEtlbiBTbG9hdCA8a2VuLnNAdmFyaXNjaXRlLmNvbT4NCj4gPiAtLS0NCj4gPiBDaGFu
Z2VzIGluIHYyOg0KPiA+IMKgLUNoYW5nZSAiRkxEIiBub21lbmNsYXR1cmUgdG8gY29tbW9ubHkg
dXNlZCAiRmFzdCBMaW5rIERvd24iIHBocmFzZQ0KPiA+IGluDQo+ID4gwqDCoMKgIHNvdXJjZSBj
b2RlIGFuZCBiaW5kaW5ncy4gQWxzbyBkb2N1bWVudCB0aGlzIGluIHRoZSBjb21taXQNCj4gPiBj
b21tZW50cy4NCj4gPiDCoC1VdGlsaXplIHBoeV9jbGVhcl9iaXRzX21tZCgpIGluIHJlZ2lzdGVy
IGJpdCBvcGVyYXRpb25zLg0KPiA+DQo+ID4gwqBkcml2ZXJzL25ldC9waHkvYWRpbi5jIHwgNDMN
Cj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiDCoDEg
ZmlsZSBjaGFuZ2VkLCA0MyBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvcGh5L2FkaW4uYyBiL2RyaXZlcnMvbmV0L3BoeS9hZGluLmMgaW5kZXgNCj4gPiBk
YTY1MjE1ZDE5YmIuLjBiYWI3ZTRkM2UyOSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9w
aHkvYWRpbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvcGh5L2FkaW4uYw0KPiA+IEBAIC02OSw2
ICs2OSwxNSBAQA0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9FRUVfQ0FQX1JFR8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgMHg4MDAwDQo+ID4gwqAjZGVmaW5lIEFESU4xMzAw
X0VFRV9BRFZfUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDgwMDEN
Cj4gPiDCoCNkZWZpbmUgQURJTjEzMDBfRUVFX0xQQUJMRV9SRUfCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAweDgwMDINCj4gPiArI2RlZmluZSBBRElOMTMw
MF9GTERfRU5fUkVHwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAweDhFMjcgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfUENTX0VSUl8xMDBf
RU7CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBCSVQoNykgI2RlZmluZQ0KPiA+
ICtBRElOMTMwMF9GTERfUENTX0VSUl8xMDAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoEJJVCg2KSAjZGVmaW5lDQo+ID4gK0FESU4xMzAwX0ZMRF9TTENSX09VVF9TVFVDS18x
MDBfRU7CoMKgwqBCSVQoNSkgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RV
Q0tfMTAwMF9FTsKgwqBCSVQoNCkgI2RlZmluZQ0KPiA+ICtBRElOMTMwMF9GTERfU0xDUl9JTl9a
REVUXzEwMF9FTsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgQklUKDMpICNkZWZpbmUNCj4gPiAr
QURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDAwX0VOwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
QklUKDIpICNkZWZpbmUNCj4gPiArQURJTjEzMDBfRkxEX1NMQ1JfSU5fSU5WTERfMTAwX0VOwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgQklUKDEpICNkZWZpbmUNCj4gPiArQURJTjEzMDBfRkxEX1NM
Q1JfSU5fSU5WTERfMTAwMF9FTsKgwqDCoEJJVCgwKQ0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9D
TE9DS19TVE9QX1JFR8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoDB4OTQwMA0KPiA+IMKgI2RlZmluZSBBRElOMTMwMF9MUElfV0FLRV9FUlJfQ05UX1JFR8Kg
wqDCoMKgwqDCoMKgwqDCoMKgMHhhMDAwDQo+ID4NCj4gPiBAQCAtNTA4LDYgKzUxNywzNiBAQCBz
dGF0aWMgaW50IGFkaW5fY29uZmlnX2Nsa19vdXQoc3RydWN0IHBoeV9kZXZpY2UNCj4gPiAqcGh5
ZGV2KQ0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgQURJTjEzMDBfR0VfQ0xLX0NGR19NQVNLLCBzZWwpOw0KPiA+IMKgfQ0KPiA+
DQo+ID4gK3N0YXRpYyBpbnQgYWRpbl9mYXN0X2Rvd25fZGlzYWJsZShzdHJ1Y3QgcGh5X2Rldmlj
ZSAqcGh5ZGV2KSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGRldmljZSAqZGV2ID0gJnBo
eWRldi0+bWRpby5kZXY7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IHJjOw0KPiA+ICsNCj4gPiAr
wqDCoMKgwqDCoMKgwqBpZiAoZGV2aWNlX3Byb3BlcnR5X3JlYWRfYm9vbChkZXYsICJhZGksZGlz
YWJsZS1mYXN0LWRvd24tDQo+ID4gMTAwMGJhc2UtdCIpKSB7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHJjID0gcGh5X2NsZWFyX2JpdHNfbW1kKHBoeWRldiwgTURJT19NTURf
VkVORDEsDQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEFESU4xMzAwX0ZMRF9FTl9SRUcs
DQo+ID4gKw0KPiA+IEFESU4xMzAwX0ZMRF9QQ1NfRVJSXzEwMDBfRU4gfA0KPiA+ICsNCj4gPiBB
RElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwMF9FTiB8DQo+ID4gKw0KPiA+IEFESU4xMzAw
X0ZMRF9TTENSX0lOX1pERVRfMTAwMF9FTiB8DQo+ID4gKw0KPiA+IEFESU4xMzAwX0ZMRF9TTENS
X0lOX0lOVkxEXzEwMDBfRU4pOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBp
ZiAocmMgPCAwKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgcmV0dXJuIHJjOw0KPiA+ICvCoMKgwqDCoMKgwqDCoH0NCj4gPiArDQo+ID4gK8KgwqDC
oMKgwqDCoMKgaWYgKGRldmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woZGV2LCAiYWRpLGRpc2FibGUt
ZmFzdC1kb3duLQ0KPiA+IDEwMGJhc2UtdHgiKSkgew0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBwaHlfY2xlYXJfYml0c19tbWQocGh5ZGV2LCBNRElPX01NRF9WRU5EMSwNCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgQURJTjEzMDBfRkxEX0VOX1JFRywNCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgQURJTjEzMDBfRkxEX1BDU19FUlJfMTAwX0VODQo+ID4gfA0K
PiA+ICsNCj4gPiBBRElOMTMwMF9GTERfU0xDUl9PVVRfU1RVQ0tfMTAwX0VOIHwNCj4gPiArDQo+
ID4gQURJTjEzMDBfRkxEX1NMQ1JfSU5fWkRFVF8xMDBfRU4gfA0KPiA+ICsNCj4gPiBBRElOMTMw
MF9GTERfU0xDUl9JTl9JTlZMRF8xMDBfRU4pOw0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZiAocmMgPCAwKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIHJjOw0KPiA+ICvCoMKgwqDCoMKgwqDCoH0NCj4gDQo+IFRo
aXMgaXMgbm90IGV4YWN0bHkgd2hhdCBJIGhhZCBpbiBtaW5kLi4uIEkgd2FzIHN1Z2dlc3Rpbmcg
c29tZXRoaW5nIGxpa2UNCj4gY2FjaGluZyB0aGUgY29tcGxldGUgImJpdHMgd29yZCIgaW4gYm90
aCBvZiB5b3VyIGlmKCkgc3RhdGVtZW50cyBhbmQgdGhlbg0KPiBqdXN0IGNhbGxpbmcgcGh5X2Ns
ZWFyX2JpdHNfbW1kKCkgb25jZS4gSWYgSSdtIG5vdCBtaXNzaW5nIHNvbWV0aGluZw0KPiBvYnZp
b3VzLCBzb21ldGhpbmcgbGlrZSB0aGlzOg0KPiANCj4gdTE2IGJpdHMgPSAwOyAvL29yIGFueSBv
dGhlciBuYW1lIG1vcmUgYXBwcm9wcmlhdGUNCj4gDQo+IGlmIChkZXZpY2VfcHJvcGVydHlfcmVh
ZF9ib29sKC4uLikpDQo+IAliaXRzID0gQURJTjEzMDBfRkxEX1BDU19FUlJfMTAwMF9FTiB8IC4u
Lg0KPiANCj4gaWYgKGRldmljZV9wcm9wZXJ0eV9yZWFkX2Jvb2woKSkNCj4gCWJpdHMgfD0gLi4u
DQo+IA0KPiBpZiAoIWJpdHMpDQo+IAlyZXR1cm4gMDsNCj4gDQo+IHJldHVybiBwaHlfY2xlYXJf
Yml0c19tbWQoKTsNCj4gDQo+IERvZXMgdGhpcyBzb3VuZCBzYW5lIHRvIHlvdT8NCj4gDQo+IEFu
eXdheXMsIHRoaXMgaXMgYWxzbyBub3QgYSBiaWcgZGVhbC4uLg0KWWVzLCBJIGFncmVlIHRoYXQg
d291bGQgYmUgY2xlYW5lci4gSSB3aWxsIGFkanVzdC4NCg0KPiANCj4gLSBOdW5vIFPDoQ0KDQpU
aGFua3MNCg0KU2luY2VyZWx5LA0KS2VuIFNsb2F0DQo=
