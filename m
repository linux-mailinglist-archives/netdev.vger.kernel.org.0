Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4E66B4158
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 14:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjCJNvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 08:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjCJNvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 08:51:52 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2070.outbound.protection.outlook.com [40.107.6.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3811910DE5E;
        Fri, 10 Mar 2023 05:51:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5PI4S/qWiWaMzexzgyRWc1yR8RiNyvbf6XQ6tKHXgjoztqF2x7Le3VHSzr7zLAwzqP3+W1y7grvH7IUsu0Kf+pTBzj8ZVU8BgO6bhS6jk9sNayGIHZgmaTl6tiXxnJje5QDmDLf7VHIqQj0hdCtOv3/pfWAP8h+s4E2DtfqUm5FIL22SVwkzSsnoWzEAaHrP5noYVcvYdyIYLJG53gKKiHdsGvpzRRAG11xp2xP3eZw7mHLl5DaKgq9XDqhpD8TImXPpk82DKVr3ELVVCoT4/00QAWoYpGmUgWyeoyoIsOna7nW4Me0n99wn1TcoxLoL+5e3Dn06Q+aBwY2HBui+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z01fFIiPozEeZ9U25X3qpeuefS5C7Pw9OPFxjUBBAIU=;
 b=P4mpvxc1Cs66xtidooBgBhtOsjCUCSV0NEtdQ6E9Coc7Y10lJhNijxP8FGFULGGJH6+ZdIM+IjOnr0zmabH5H7PdcDEu2+8DRHGPdLT+LgWWXYKFdxa0Nkbb0cTndI+0CP0Mq/frymABgrbci7m88O5uiVXMGMMoyTnN1Xn0+8NokAOYmQBiliEurofoXQWDeDH4G2SiVGU/mlKbtV98l2d2R89Gwr+bSaj+izfDLDnGevMqgmpq8FylNuct547AOrGjvhMBKl4Af2uWVnKtPYQzSYvZo/YBg4FBJXRlFws69lrl1696cARmgq+yNxS9LPaAyf+UzK6SQCowAMCYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z01fFIiPozEeZ9U25X3qpeuefS5C7Pw9OPFxjUBBAIU=;
 b=gPGCZASLAxlXdJJjeCr2btUmuZROvMHTtxxQUs5q4gAlNzjnPjaVLdaqlyFmk2Moxesw+Dm/0/rXxk6jcEjlOTSEWpsatIy+Y2/RaxEWPqUldBmnM4Ns+N+MpGThfd3z/yUfo2TNRe83BTOlNp37onGyKLZMbElL2zog5Re9fN8=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS8PR04MB7639.eurprd04.prod.outlook.com (2603:10a6:20b:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 13:51:48 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 13:51:48 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     Francesco Dolcini <francesco@dolcini.it>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "alok.a.tiwari@oracle.com" <alok.a.tiwari@oracle.com>,
        "hdanton@sina.com" <hdanton@sina.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: RE: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for
 NXP Bluetooth chipsets
Thread-Topic: [EXT] Re: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support
 for NXP Bluetooth chipsets
Thread-Index: AQHZTFTz7I8HL7cZs0WTN4pxjl5wrK7t3v4AgAYME5CAABzigIAAADgQ
Date:   Fri, 10 Mar 2023 13:51:48 +0000
Message-ID: <AM9PR04MB8603DA275FB41A5A22491D3AE7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
 <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
 <ZAX/HHyy2yL76N0K@francesco-nb.int.toradex.com>
 <AM9PR04MB860372E06283EA79BD341998E7BA9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ZAsp9fm779DR0Vuz@francesco-nb.int.toradex.com>
In-Reply-To: <ZAsp9fm779DR0Vuz@francesco-nb.int.toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS8PR04MB7639:EE_
x-ms-office365-filtering-correlation-id: 449585b5-f581-42ff-03e1-08db216e982f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hcxMeCgNgUA3FDkFhrk5N9N0bCuvhdh1fnd1js1zDSl4g6cF7HAr43WsW63mRAygQeYABivLRx+9Z5SuoOq2Nki9bc0UgstjJAOw5aF5TNYVg9fPnPv0z0R0k3XCRtUv/n3e6t6G3l2DnRrDQG2+wP4meia31QGlFC3APF4Kd1+PLO4W9ciAwOvOI9Ng0LfEmtvgxj+cDt6v/PBdZV+kJknBjeuEh9+Tr/Zt53BDAkgBxz7wcXOznV3X89qo4Gzs5ZZx6GR0QxKsQEsvl0dfIc91+mteVS+CikAST3zeIdXMoTelfcqMlxJMTBw3LVaWKwuau9/kQQOaYQGsca8gBpnRICEqZ1t0JxhT+DjFCFbv0ZV6W+WgVNwGZakxUCoG8gWweheuFoPaj2saNcgwAMIH3fSpkfzWcs0lupqYv1gyofuMKcYhB7ilvEV5DVL6HLH63GdjmuBG3ZIqFzPsOo6vs/eOPZwOZkDnv3CCmZT9bhrnq0jq2JTRWhE/QC3TsY3aVMjdlDPdCxqJrVg+AI1bMjiAmqu2oq9HFdJsgW/EL+ttyiUdFyhklnN7MDC3Bs9uLWgvidqEFJAH2IopKmk2uj1iPSTo8EKO2c8AriQSju3hC8yXRfKnSlbnpo7Q5o8euKCSRdj/2WuFhtpH+m+/fJeIS/4SkZZjYymcn6qx4ZINZaW0QRM3T4UWIY7ygH1Bx3l7/kDxMs5hCOrqIXB7G2VhJ0fnCOZiefN1hc4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199018)(9686003)(186003)(122000001)(38100700002)(2906002)(38070700005)(86362001)(41300700001)(55236004)(7416002)(8936002)(5660300002)(52536014)(6506007)(26005)(66946007)(76116006)(66556008)(8676002)(66446008)(66476007)(6916009)(4326008)(64756008)(316002)(33656002)(83380400001)(7696005)(54906003)(71200400001)(478600001)(55016003)(354624003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SlQxcnA0UWh2Q0dKRkIwbTNSWHpVMDhEdFVpZ0E2TGdSRHFNZmZNNUlmNnpD?=
 =?utf-8?B?WnFuc0xoQWl5VThpWjBFcHkxaEhiRDI1bFNBYi8zd0VaNmszRm12QWNJS3Er?=
 =?utf-8?B?d1R6Z1lyTUhEdi9uOHQwbVRDMnB4OUlqQ0lIS2pYRnI3NUFxaGduTzI4OFEr?=
 =?utf-8?B?MXNYdisrb2hrcGk4M1ZzWXNvNzB0TE1ERTR5Qzl4UVpFVUlFUmMrMHdHZHIv?=
 =?utf-8?B?dk5Ud3owV1laTVJ0R1J1L09tUmZtVFQySlYrL2JpYStUMmQzcE5KUWxYZ0NP?=
 =?utf-8?B?Sk9jR3BUQ0RQK0JBWEtMZXFndm5lNkYyVTRZNmM2NW02Q2xWZ1puSlJJQUFC?=
 =?utf-8?B?SGFtRGUxdlZ3LzNRQkhkNEh2b2phZXpsNWYrN1F6QkNNVDl3cGNwU2c4Ulk5?=
 =?utf-8?B?Qkt5NDhJSmFxU3lZOU94UUlHQUgvOGsxQUtZOUswdlRrcjRScVhseGVVSVdi?=
 =?utf-8?B?TVh4T2t3S1FmTjVDdWxMZkNFK1E3T0ZoMi9ZMVdQb3Q5UVpOYU9heGNOVUt1?=
 =?utf-8?B?a2Qzem9jdnk0VitSVjY3Q0FaOFFkRFkybHJpQzJZRnlENXI0bXF5ZnRpdVdG?=
 =?utf-8?B?Ull6MkNlYTV5c0Q3Y1BpdmZWT0QyOHRNNTN2czU0L1ZqY3pEdjZqd0tEVVhq?=
 =?utf-8?B?Z1lEQzZLWENhM0licllIVEtmQjBLR0pEczF6UXgrbGpUN2NUZUR1b1VsZEhT?=
 =?utf-8?B?Yy93aWlObE5zTTBrQkRoS3RaU09OR3ZDSDZXM1V0dlRpYkVQODZHSTZVQUF2?=
 =?utf-8?B?bFRUNzR0cmt1b21qWldTRnZpdy83ZG1GdWtxdlU0N2ZpUkNPdkFlTjZLQzJ4?=
 =?utf-8?B?Ny9yT2lDVytNZDdwT3FkYUVRK1ZaWkxadkY0c1FNRmFaOGxjVWFtb2FDUXZp?=
 =?utf-8?B?YTZYR0x1NnM3R3hYVGxtRlVpdG1YblNPM2FCRk14MjRnWTlORW8vVXhZMDNw?=
 =?utf-8?B?cCtrcjJzNEwwRWo0Z0U5VlNGNVNqekI0eTVUWXBob0JwbWZxVjZCN3lWWG9m?=
 =?utf-8?B?YktBSkRTeEZPWldjZDJwNkgrczh2ZjdEenZhYk5ZSlVLK1NYZFZQY1U2Z3N6?=
 =?utf-8?B?bVZLWFdYR21kQnZFWkR5Q1hzaWwzYnpwaW16WUZzdGJ6cGtsbDF3cGlqSjdj?=
 =?utf-8?B?RC9xTVFyaHVkQnE0MDVvRTB0V2VPNlcvc3ZzQWUvakxhVnpUMFZyK2xTMlRY?=
 =?utf-8?B?NFVWRUMreGVrbXdZd1ptNm1OOXVvekViZ3Bjak1kSUFNcDFKNWI3V01jZWY5?=
 =?utf-8?B?RUZpMFF1SkpydS93ZGRVUmdNeTNMUWhuUWUvR2ZVTEJmQzB3ejZnWklha0pa?=
 =?utf-8?B?UE9ranhmc2JFbDUraTFzcklVcnZ1dS9JL0o2RzdQR2VWaU1NS3hxMmIyOVdN?=
 =?utf-8?B?Ni9PWkV2NEFLZnhLbUszUjB1YXpncmIzT1dBUXRjK0ZyTVVSZ1RRM0FKTlRL?=
 =?utf-8?B?T2h0dno4MUgxa3RZMVozWS82dy9IK3FTOFVESHVrb3R1ZUc3SHc1d0luWlVi?=
 =?utf-8?B?S3Qvb3NsVGp4c3YvVWJ2cVExS00yWk5TMm1JdFN3QXFRTldvUVlhNDM1NjVv?=
 =?utf-8?B?QTNsUy9rdHozOFRLRHUvZkl5R0tRM0N3ZU1MWjFqcVF3c0RCeVNjTStoTFdh?=
 =?utf-8?B?OXJwY2FNSWRwTUFYbFdSY2EwYjJmOFlCTEtlOVVQcUFKQkM0UVk3VndPMDNV?=
 =?utf-8?B?UGFCdlRiZThSSC9uWDF6VTFLZ0RXSTI1VTlnNk9GU1ZyVUhkNk9ZTzlCM3VZ?=
 =?utf-8?B?OUptSmJTakpXQmltRXJ3OEh0M25qOVY2U21kSTY0WldITmF6eTE0WDRyVG1V?=
 =?utf-8?B?MWgyREVVSGc3VHdFMnhhdGlHb1JMendpYkpWRjEyT1lqMVJoYjRTKzVvZmJ6?=
 =?utf-8?B?SWk1Sm5pWFZPWXhoc0ttMWhzMCtPN1pscGpYSlQxbmdrTkI5ZDdpME1FblJm?=
 =?utf-8?B?UkpHVnAzY0xMSVArSk9uOXFXMUVaUzV0U0s0YnVObEs5LzlHTXJxOFVwN2Fa?=
 =?utf-8?B?V3ZGeWJSNEpnblJUeElWNTdBRit4OFVobExscUZKYXVuSi9uaDlyWVJ6UERK?=
 =?utf-8?B?NHRHTUY0SlNXdG81dDVXdHZ1a3pRM3pPbnVWRTdMbTNvQ3c0N080dGF3aC81?=
 =?utf-8?B?Umx6Q1ZLV2dMTzQvUjhSWmh4TlV4NDYyTUhWTWZzckk1Q2hIYy95Q1JUNE9W?=
 =?utf-8?B?ZWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449585b5-f581-42ff-03e1-08db216e982f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 13:51:48.6082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGaFaFw0C7jqAvXBeMmMdI0lyVUxfxZhQczUys7k536mfSj0hCvsxvUQAhDRs9RfOt8X8QJfPTD5ssJqs3YMA/nov5ppf5Z5v9c/wsXH4mE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7639
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRnJhbmNlc2NvDQoNCj4gDQo+IE9uIEZyaSwgTWFyIDEwLCAyMDIzIGF0IDEyOjA5OjA5UE0g
KzAwMDAsIE5lZXJhaiBzYW5qYXkga2FsZSB3cm90ZToNCj4gPiA+ID4gKyNkZWZpbmUgRklSTVdB
UkVfVzg5ODcgICAgICAgIm54cC91YXJ0dWFydDg5ODdfYnQuYmluIg0KPiA+ID4gPiArI2RlZmlu
ZSBGSVJNV0FSRV9XODk5NyAgICAgICAibnhwL3VhcnR1YXJ0ODk5N19idF92NC5iaW4iDQo+ID4g
PiA+ICsjZGVmaW5lIEZJUk1XQVJFX1c5MDk4ICAgICAgICJueHAvdWFydHVhcnQ5MDk4X2J0X3Yx
LmJpbiINCj4gPiA+ID4gKyNkZWZpbmUgRklSTVdBUkVfSVc0MTYgICAgICAgIm54cC91YXJ0aXc0
MTZfYnRfdjAuYmluIg0KPiA+ID4gPiArI2RlZmluZSBGSVJNV0FSRV9JVzYxMiAgICAgICAibnhw
L3VhcnRzcGlfbjYxeF92MS5iaW4uc2UiDQo+ID4gPg0KPiA+ID4gV2hlcmUgYXJlIHRoaXMgZmls
ZXMgY29taW5nIGZyb20/IFdoZXJlIGNhbiBJIGRvd25sb2FkIHRob3NlPw0KPiA+ID4gSXMgbG9h
ZGluZyBhIGNvbWJvIGZpcm13YXJlIGZyb20gdGhlIG13aWZpZXggZHJpdmVyIHN1cHBvcnRlZD8N
Cj4gPiBXZSBhcmUgd29ya2luZyBvbiBzdWJtaXR0aW5nIHRoZXNlIGZpbGVzIHRvIGxpbnV4LWZp
cm13YXJlLiBUaGV5IHdpbGwNCj4gPiBiZSBhdmFpbGFibGUgdW5kZXIgbnhwLyBkaXJlY3Rvcnkg
b25jZSBtZXJnZWQuDQo+IA0KPiBXaGF0IGFib3V0IHRoZSBjb21ibyBmaXJtd2FyZSB0aGF0IHdv
dWxkIGJlIGRvd25sb2FkZWQgYnkgbXdpZmlleA0KPiBkcml2ZXI/IEhvdyBpcyB0aGlzIHN1cHBv
c2VkIHRvIGludGVyYWN0IHdpdGggaXQ/DQpJZiBjb21ibyBmaXJtd2FyZSBpcyBsb2FkZWQgYnkg
dGhlIG13aWZpZXgsIHRoZW4gdGhpcyBkcml2ZXIgd291bGQgbm90IGRldGVjdCBhbnkgYm9vdGxv
YWRlciBzaWduYXR1cmVzLCBhbmQgd291bGQgc2tpcCBGVyBkb3dubG9hZGluZyBhbmQgbW92ZSBv
bi4gUGxlYXNlIGNoZWNrIHRoZSBueHBfc2V0dXAoKSBmdW5jdGlvbi4NCg0KPiANCj4gPiA+ID4g
KyNkZWZpbmUgSENJX05YUF9QUklfQkFVRFJBVEUgMTE1MjAwICNkZWZpbmUNCj4gSENJX05YUF9T
RUNfQkFVRFJBVEUNCj4gPiA+ID4gKzMwMDAwMDANCj4gPiA+IFdoYXQgaWYgdGhlIFVBUlQgZGV2
aWNlIGRvZXMgbm90IHN1cHBvcnQgMzAwMDAwMCBiYXVkcmF0ZSAodGhpbmsgYXQNCj4gPiA+IGxp
bWl0YXRpb24gb24gdGhlIGNsb2NrIHNvdXJjZS9kaXZpZGVyIG9mIHRoZSBVQVJUKT8gU2hvdWxk
bid0IHRoaXMNCj4gPiA+IGJlIGNvbmZpZ3VyYWJsZT8NCj4gPiBXZSBoYXZlIG5vdGVkIHRoaXMg
cmVxdWlyZW1lbnQgYW5kIGRlY2lkZWQgdG8gZGVzaWduIGFuZCBpbXBsZW1lbnQgb24NCj4gPiB0
aGlzIGluIHVwY29taW5nIHBhdGNoZXMgYWxvbmcgd2l0aCBvdGhlciBuZXcgZmVhdHVyZXMuICBX
ZSBoYXZlIGENCj4gPiBudW1iZXIgb2YgY3VzdG9tZXJzIG91dCB0aGVyZSB3aG8gaGF2ZSBiZWVu
IHVzaW5nIHRoZXNlIGNoaXBzIGFzIHdlbGwNCj4gPiBhcyB0aGUgbGVnYWN5IE1hcnZlbGwgY2hp
cHMsIHdoaWNoIG5lZWQgRlcgZG93bmxvYWQgYXQgMzAwMDAwMA0KPiA+IGJhdWRyYXRlLCBhbmQg
c28gZmFyIHRoZXJlIHdlcmUgbm8gaXNzdWVzIHJlcG9ydGVkLiAgVXNpbmcgYSBsb3dlcg0KPiA+
IHN0YW5kYXJkIGJhdWRyYXRlIGFmZmVjdHMgdGhlIHRpbWUgaXQgdGFrZXMgdG8gZG93bmxvYWQg
dGhlIEZXLCB3aGljaA0KPiA+IHdlIGFyZSB0cnlpbmcgdG8ga2VlcCBzdHJpY3RseSB1bmRlciA1
IHNlY29uZHMuDQo+IA0KPiBvaywganVzdCBmb3IgeW91IHRvIGtub3cgb3VyIGhhcmR3YXJlLCB1
c2luZyBOWFAgU29DLCB3aWxsIG5vdCB3b3JrIHdpdGggdGhpcw0KPiBiYXVkcmF0ZSAobm8gd2F5
IHRvIGhhdmUgaXQgZ2l2ZW4gdGhlIGNsb2NrIHRyZWUgd2UgaGF2ZSkuDQpHb3QgaXQhIFdlIHdp
bGwgd29yayBvbiB0aGlzIHJlcXVpcmVtZW50IGZvciBzdXJlIGFuZCBjb21lIHVwIHdpdGggc29t
ZXRoaW5nIHNvb24gaW4gdGhlIG5leHQgcGF0Y2ggZm9yIHRoaXMgZHJpdmVyLg0KRllJLCBmaXJt
d2FyZSBkb3dubG9hZCB0YWtlcyBhcm91bmQgMjAgc2Vjb25kcyBhdCAxMTUyMDAgYmF1ZHJhdGUs
IHdoaWNoIGlzIGhpZ2hseSB1bmFjY2VwdGFibGUgYnkgbWFueSBjdXN0b21lcnMuIPCfmIoNCg0K
VGhhbmtzLA0KTmVlcmFqDQo=
