Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FC04C48C3
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiBYP0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:26:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiBYPZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:25:58 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8163E1DCCE3
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:25:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivHbdm2+1DImpQsGi5G+P+AkaJ/ufxniNvBx9EzOVglXbZ10cN3VgFAQlNpjLBGuXU8hGJ/vF4hBMGNzVfF5bn7+YVKycB0+7GxlngkIOmu1faSaiaiXfyhIvOE3uSdD1LFRD0//PAjS6+c3Vi9u0UHqrbmjvV9A0t1jgzVvlXd3qF/74ywIKf22TAss2rfyUP1LH7lhqiGLh+WAyGmNIZL26bYhYp8riGi/KKn63hTR8ZzZyBiiOXRnMql9APsqMH3IbSqudetyKk4RQ8vXsLrdvHgnodYSb7KdzaRCI4i2+s6GSr6jG7USZdndLxuurs+8wvbxnwJYwYmw1IJnSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glCffz38trWfDtmqn18tiPB3l5p5C0SPf7Icb902v0I=;
 b=OLm53rS1sZjfqEXsdSuQu2EIPU2tK9vs27sFprj9q9gXHbHc445vuflaOrxfZJoUKtQRDvw+uXvZgRZELRTOEXCzzt4sLsnwGBxnQw3sKmrj2Qf0R6WzjfTJWp2fzWUJ1YQzEnBxm2KhaAyslZvBmw8tbgtji5Vu10l4HmfLTw05pgIR4wymZxnx6aWhjdlv1rvTPvV88mwDu62liPzbYJ53EqtKGSThYNXhrgWmJZHLx6mUaNLi+lC+H9paHkYSgKmNBWqEd5V1l7WanpmGk59xAa3sOUlZNOIFj3irnYnaqGUxhP7OvIs4nvpbkydqep8ndH6+OME9OODRKF4+mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glCffz38trWfDtmqn18tiPB3l5p5C0SPf7Icb902v0I=;
 b=BVG2zMuSw9/5xkrO2bIza3mDWNIpHyGfhQSnmbfzj4sQBI7v25G3UFiUt387MjyrrtjRXlcYtFlIIfX9mCzXtypR1bi9hHI1tnmdYT9aHc5wcMdiAjTIrhIz4u85VCf4HBJbRzf8LMneNLUDXOkjGpHz5OMwSByDZpRgbFZ/unM=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4867.eurprd04.prod.outlook.com (2603:10a6:208:ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 15:25:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 15:25:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?TWFyZWsgQmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Thread-Topic: [PATCH RFC net-next 1/4] net: dsa: ocelot: populate
 supported_interfaces
Thread-Index: AQHYKlTujAnpuROkTE6489+MCwM7d6ykYyIA
Date:   Fri, 25 Feb 2022 15:25:21 +0000
Message-ID: <20220225152520.b2b52fri6bkyckes@skbuf>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgi-00Akie-In@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNbgi-00Akie-In@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38018afa-2f40-4643-db29-08d9f8730974
x-ms-traffictypediagnostic: AM0PR04MB4867:EE_
x-microsoft-antispam-prvs: <AM0PR04MB4867479810213154F4B54446E03E9@AM0PR04MB4867.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yyQybuqP8QV3XDb1/42c5sgyLJvOfiBNouKpaUsJ1n2DH57PfWV8hfpOW7jCYRLfktxOBZJP+VGfdj1bbQ/uCr9/6vsnVVv63ngqoGD1EXXB/2IzgfFAZ+F+vu4GeqzbepuiNgBCZMb4p7mQwinVxzOHeIvmWSkX5/f5nwcUFZCXcM6j1kS7fRx2jZtnEBbaqRhFiVwGCleVc3kVK8lfBImC957eUHUL+l6PeJnccYzGOAt9BuMMs2oAPJ4wdNgkKb4Ez8NaXzxvRb3YSsxa6WLzufhmNQ7gvwXzYuxKZCyGTLDd2VeY+PlX9/TQL0Ljs1ZkOufRh7/gjXa+09TNiG3h5XrsFhXHmfSL/VjFqEFSEPtXi51LWHnkOD1N42Km1DlaUQkaBaGTP0n3nreTDkHOPakktkV6p1T1hbnT2hG54XPhkhnS/CeRtpMGUZleej9lSRGWzsyQfjk/gY+Y5DVvwsZgrNwMWcRNq8iHgm3rQam/O+TBY5xdAd/y/tl1Army+tQSGp6FxfaYzvL4Jmv7YBtBsmW2uT2cVqTagdOzzXLE0FuE7stZVH3J+ta+XJPURYqVuRXD5C6OA/hN2rAoHi1UmSOGS0dhNu6wbC0DSqARCFPekMmsTA+CjIfb/KsT7Bih3KTw2l/scmv9pXIuFf8qBBU/jmquBnogM0lW8uEirfSbC3M7D3pzGTUkLEST73GaS8SBw/rR/WMmqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(8676002)(33716001)(4326008)(26005)(86362001)(2906002)(38070700005)(316002)(6512007)(54906003)(91956017)(6506007)(9686003)(66476007)(66446008)(66556008)(66946007)(64756008)(76116006)(83380400001)(5660300002)(122000001)(6486002)(8936002)(186003)(508600001)(7416002)(71200400001)(44832011)(1076003)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0g2bm1rcUkxb1NNRzBIdGE0M1JDVFg0dzJOWjAzYTZEV2tRKzZQbHl2aHV3?=
 =?utf-8?B?aklnN3RvNnJuUFRSdUt5NFhGNE84SEN1WlZ5cTdWYmFpYlNKVjFxOWc0dGlV?=
 =?utf-8?B?aFdkbkE1QkVoTEc3UEh1ODZ5Sml4Z0IxQ1lmaTF2S2JESmN6cmFEVVlWcFFJ?=
 =?utf-8?B?MStCRDJaZS9EK3c0OGd5T29ZUFFvZS9Cd3E5M2VHN1NEY3hiSFRXZWF1bXU3?=
 =?utf-8?B?Q1BNNGtXcXJoWTQvWjBuNStjVUlsaVVmZU45QUpqL3NnZXVHNmZzUDlEcUUx?=
 =?utf-8?B?VHRuL2tPY3dyZXk4eVVTZkhYSkRsck1PYlZMZnRzZDFudXN3bi9RWWd2aGc1?=
 =?utf-8?B?ZU14N0cvNHVCeGdacmZySU05RTVTcFc5YnNWMFJtM1V1dGtoeGVkbXh3STU1?=
 =?utf-8?B?ZTE0VEdnY0FxamRXSmNnWTM3dnQzblhobjh6Y2VtUDB4dU5ESmF4WVJiNUpp?=
 =?utf-8?B?U3NCRjhMWXpzUlh4aStRdmpYRGN2STdJaUhGd0ZWbnlMQ2R2Z1ZjVG02OTQr?=
 =?utf-8?B?NXdwNU1hYkdQSjhaUGxDVndLYmJ3UE1iUjNQQlIrd0NGZDhmcGNuVURvZlRS?=
 =?utf-8?B?SkRTM3JIZHl2TmtkNmdBSnZhaGE0eGVBMnhZM2JaQkdRYjFQaGd6Vi9nT1Fa?=
 =?utf-8?B?TklVcHZWck1ZOUZVc0M1S3dCMmZVaHJwTGVLMzFhd3F2bGlqWEVIdEpqQ2Ux?=
 =?utf-8?B?VHRjQ2RsWk4rdWtXZVFoTkEzSEtqMVN2STRBTEhjTDFsQUhTTFVQRWgwaUVs?=
 =?utf-8?B?RmhMb29aT3lHTmtGSVFUZGY4WURpV3RIL0hLeUJueTFBUFRzeThKa2dqeXYv?=
 =?utf-8?B?N01xYjYwVDlrK0lWeHp2TmswUm5mOHlkM1l5MldpbGt3UjdIeE93dHpVbXRC?=
 =?utf-8?B?MEJoZzhkWlhIaURCbFA4ajdLU0ZNNDcwSWpSRVZKblV3RWdJcFZMVjBRYXd0?=
 =?utf-8?B?UEhMb1BIMWhuaGhMcjV0VHh6d2FTWUlmVUZnbGFEZTl3YkhVTkVxV1RFdk53?=
 =?utf-8?B?aEJ4MisrcFVYYUhXWFdRc2Q5WkNOWm9Fcy9URll3N1FQNE56SVRLdWduTmFs?=
 =?utf-8?B?VXJLUWZEZityazVhMGlTd0EyWXRpd3Z2c0ZaV1VMTWhEOTUyTGtBM092Y1dw?=
 =?utf-8?B?aFhaNThKRHBpR1JZeG1kZURMRFpxQUlGVWRJaTlsbUs4SmNxd25tV25zMHRj?=
 =?utf-8?B?bHVNWnFwNHpzcW83bGtVVGd4RlFpcTQ3dk9YODhEM29YdDJiMEJqTGRXVEVZ?=
 =?utf-8?B?cFMwdVBsMUhZSjlXL3NlVnFUdWtIeHI5c1N5emNzcG1hdm9KOGZQOXVkRzZq?=
 =?utf-8?B?NDE4dXhqdTJvdFRNUkl4S3JiWkF2alBQeU1SMVFiZWNueEhjQXQ2KzB0ZUVy?=
 =?utf-8?B?VXp5bkd4c2tVS1JNaFMvbTdnVGhkcytIOGViQ1BiSDN3enEvVU1JUHpWdzdQ?=
 =?utf-8?B?bGVZek55Zy9KcnAxc2xmM3JJdjE1ck1VL3N0L3dUM1ducGJnRGg0d0VRQzFD?=
 =?utf-8?B?N296TGg0QzNrOFVhYnpMWTV2b3lkemNzWVQxVm1CMWJ1R0Ftdm1WNk5SaFlM?=
 =?utf-8?B?VjE2TW5uOHJEUGdLM2VFT2Vab2JlNFQwbE9TNVEzampEbFdBK0ZvVWd2V3U4?=
 =?utf-8?B?Y2d4QWlhZExuN1k5bXY5SmYxazJKSEpiZkdWS0F5QWs1Mk1yYjFZMk9kMzlT?=
 =?utf-8?B?SGFQOUhJYnQ1TXVzaHo1aEJ3c2dhU1o1RFVBc2lJT0xmOFlobEJSb2dOak5l?=
 =?utf-8?B?MmZWWUl1amFlWmFpenJXVWR5dXcxL0ZiWjBUSzVLRHB0VTdJZCtTOWRRUG1l?=
 =?utf-8?B?SzN3TVFjWU9Ud3g0ck41RFRUWGcrdHc0RDBOVFNjTkpLSjkyYXg5NVVHNEJw?=
 =?utf-8?B?MmVwUnZZbm5ZclpERHRVdzZZbW1mTUpkbFpnd0pFMkx0eSs0c2hrS2NsZE4w?=
 =?utf-8?B?emlrZEdHMW5IS2NHVzg4YnZiUkpveHdTZGR5a0E0SmhINmNTd2FEemV6Y3Rk?=
 =?utf-8?B?SVZrUnR3OG01cUpEWGE0OEd4VjRmNXRLd2VpcjBSQ0QrZjh6YnErdkt0QVpH?=
 =?utf-8?B?MU91L2lVdHh5WnBOSkN5YWQrZFp5VEdvOUlEbXZ2R1BvV1Q5OUZONFFOb2JP?=
 =?utf-8?B?UTZlYnM0RzZ6dXlDV3VNNFlWWHllLzNkRUZpZE92MjVoNEpNMlg2dnNSNkc3?=
 =?utf-8?Q?ADlTger4mK5B1Eh6jC923Ls=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B665670D3BFB54BA4B025CF77DBAF24@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38018afa-2f40-4643-db29-08d9f8730974
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 15:25:21.1810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zm2uMLbMbiYTPQk+10iaLixynpzaOFGbZ0CHVGYHlbKy4XDobSE0wVCJyuflcBk6NeZVz8Pl5AfMp4crncMn+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4867
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDI6MzU6MTZQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBQb3B1bGF0ZSB0aGUgc3VwcG9ydGVkIGludGVyZmFjZXMgYml0bWFw
IGZvciB0aGUgT2NlbG90IERTQSBzd2l0Y2hlcy4NCj4gDQo+IFRoZSBmZWxpeF92c2M5OTU5IGFu
ZCBzZXZpbGxlX3ZzYzk5NTMgc3ViLWRyaXZlcnMgb25seSBzdXBwb3J0cyBhDQo+IHNpbmdsZSBp
bnRlcmZhY2UgbW9kZSwgZGVmaW5lZCBieSBvY2Vsb3RfcG9ydC0+cGh5X21vZGUsIHNvIHdlIGlu
ZGljYXRlDQo+IG9ubHkgdGhpcyBpbnRlcmZhY2UgbW9kZSB0byBwaHlsaW5rLg0KPiANCj4gU2ln
bmVkLW9mZi1ieTogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxybWsra2VybmVsQGFybWxpbnV4Lm9y
Zy51az4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMgICAgICAgICAg
IHwgMTEgKysrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguaCAgICAg
ICAgICAgfCAgMiArKw0KPiAgZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeF92c2M5OTU5LmMg
ICB8IDEwICsrKysrKysrKysNCj4gIGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3Qvc2V2aWxsZV92c2M5
OTUzLmMgfCAxMCArKysrKysrKysrDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDMzIGluc2VydGlvbnMo
KykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMgYi9k
cml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMNCj4gaW5kZXggOTk1OTQwN2ZlZGU4Li45ZTA1
YjE4OTQwYzEgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXguYw0K
PiArKysgYi9kcml2ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4LmMNCj4gQEAgLTc3OCw2ICs3Nzgs
MTYgQEAgc3RhdGljIGludCBmZWxpeF92bGFuX2RlbChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGlu
dCBwb3J0LA0KPiAgCXJldHVybiBvY2Vsb3Rfdmxhbl9kZWwob2NlbG90LCBwb3J0LCB2bGFuLT52
aWQpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgdm9pZCBmZWxpeF9waHlsaW5rX2dldF9jYXBzKHN0
cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50IHBvcnQsDQo+ICsJCQkJICAgc3RydWN0IHBoeWxpbmtf
Y29uZmlnICpjb25maWcpDQo+ICt7DQo+ICsJc3RydWN0IG9jZWxvdCAqb2NlbG90ID0gZHMtPnBy
aXY7DQo+ICsJc3RydWN0IGZlbGl4ICpmZWxpeCA9IG9jZWxvdF90b19mZWxpeChvY2Vsb3QpOw0K
PiArDQo+ICsJaWYgKGZlbGl4LT5pbmZvLT5waHlsaW5rX2dldF9jYXBzKQ0KPiArCQlmZWxpeC0+
aW5mby0+cGh5bGlua19nZXRfY2FwcyhvY2Vsb3QsIHBvcnQsIGNvbmZpZyk7DQo+ICt9DQoNClVw
IHVudGlsIHRoZSBlbmQgdGhlIGltcGxlbWVudGF0aW9ucyBmb3IgdnNjOTk1MyBhbmQgdnNjOTk1
OSByZW1haW4NCmlkZW50aWNhbCwgc28gcGxlYXNlIHJlbW92ZSBmZWxpeC0+aW5mby0+cGh5bGlu
a19nZXRfY2FwcyBhbmQga2VlcCBhDQpjb21tb24gaW1wbGVtZW50YXRpb24gZm9yIGJvdGguDQoN
Cj4gKw0KPiAgc3RhdGljIHZvaWQgZmVsaXhfcGh5bGlua192YWxpZGF0ZShzdHJ1Y3QgZHNhX3N3
aXRjaCAqZHMsIGludCBwb3J0LA0KPiAgCQkJCSAgIHVuc2lnbmVkIGxvbmcgKnN1cHBvcnRlZCwN
Cj4gIAkJCQkgICBzdHJ1Y3QgcGh5bGlua19saW5rX3N0YXRlICpzdGF0ZSkNCj4gQEAgLTE1ODcs
NiArMTU5Nyw3IEBAIGNvbnN0IHN0cnVjdCBkc2Ffc3dpdGNoX29wcyBmZWxpeF9zd2l0Y2hfb3Bz
ID0gew0KPiAgCS5nZXRfZXRodG9vbF9zdGF0cwkJPSBmZWxpeF9nZXRfZXRodG9vbF9zdGF0cywN
Cj4gIAkuZ2V0X3NzZXRfY291bnQJCQk9IGZlbGl4X2dldF9zc2V0X2NvdW50LA0KPiAgCS5nZXRf
dHNfaW5mbwkJCT0gZmVsaXhfZ2V0X3RzX2luZm8sDQo+ICsJLnBoeWxpbmtfZ2V0X2NhcHMJCT0g
ZmVsaXhfcGh5bGlua19nZXRfY2FwcywNCj4gIAkucGh5bGlua192YWxpZGF0ZQkJPSBmZWxpeF9w
aHlsaW5rX3ZhbGlkYXRlLA0KPiAgCS5waHlsaW5rX21hY19jb25maWcJCT0gZmVsaXhfcGh5bGlu
a19tYWNfY29uZmlnLA0KPiAgCS5waHlsaW5rX21hY19saW5rX2Rvd24JCT0gZmVsaXhfcGh5bGlu
a19tYWNfbGlua19kb3duLA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9m
ZWxpeC5oIGIvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeC5oDQo+IGluZGV4IDkzOTVhYzEx
OWQzMy4uYjE5NWUzZjRkZjdmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2Evb2NlbG90
L2ZlbGl4LmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeC5oDQo+IEBAIC00
MSw2ICs0MSw4IEBAIHN0cnVjdCBmZWxpeF9pbmZvIHsNCj4gIA0KPiAgCWludAkoKm1kaW9fYnVz
X2FsbG9jKShzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QpOw0KPiAgCXZvaWQJKCptZGlvX2J1c19mcmVl
KShzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QpOw0KPiArCXZvaWQJKCpwaHlsaW5rX2dldF9jYXBzKShz
dHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LA0KPiArCQkJCSAgICBzdHJ1Y3QgcGh5bGlu
a19jb25maWcgKmNvbmZpZyk7DQo+ICAJdm9pZAkoKnBoeWxpbmtfdmFsaWRhdGUpKHN0cnVjdCBv
Y2Vsb3QgKm9jZWxvdCwgaW50IHBvcnQsDQo+ICAJCQkJICAgIHVuc2lnbmVkIGxvbmcgKnN1cHBv
cnRlZCwNCj4gIAkJCQkgICAgc3RydWN0IHBoeWxpbmtfbGlua19zdGF0ZSAqc3RhdGUpOw0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeF92c2M5OTU5LmMgYi9kcml2
ZXJzL25ldC9kc2Evb2NlbG90L2ZlbGl4X3ZzYzk5NTkuYw0KPiBpbmRleCAzM2YwY2VhZTM4MWQu
LmExYmUwZTkxZGRlNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxp
eF92c2M5OTU5LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeF92c2M5OTU5
LmMNCj4gQEAgLTk0MCw2ICs5NDAsMTUgQEAgc3RhdGljIGludCB2c2M5OTU5X3Jlc2V0KHN0cnVj
dCBvY2Vsb3QgKm9jZWxvdCkNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiArc3RhdGljIHZv
aWQgdnNjOTk1OV9waHlsaW5rX2dldF9jYXBzKHN0cnVjdCBvY2Vsb3QgKm9jZWxvdCwgaW50IHBv
cnQsDQo+ICsJCQkJICAgICBzdHJ1Y3QgcGh5bGlua19jb25maWcgKmNvbmZpZykNCj4gK3sNCj4g
KwlzdHJ1Y3Qgb2NlbG90X3BvcnQgKm9jZWxvdF9wb3J0ID0gb2NlbG90LT5wb3J0c1twb3J0XTsN
Cj4gKw0KPiArCV9fc2V0X2JpdChvY2Vsb3RfcG9ydC0+cGh5X21vZGUsDQo+ICsJCSAgY29uZmln
LT5zdXBwb3J0ZWRfaW50ZXJmYWNlcyk7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyB2b2lkIHZzYzk5
NTlfcGh5bGlua192YWxpZGF0ZShzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LA0KPiAg
CQkJCSAgICAgdW5zaWduZWQgbG9uZyAqc3VwcG9ydGVkLA0KPiAgCQkJCSAgICAgc3RydWN0IHBo
eWxpbmtfbGlua19zdGF0ZSAqc3RhdGUpDQo+IEBAIC0yMjM3LDYgKzIyNDYsNyBAQCBzdGF0aWMg
Y29uc3Qgc3RydWN0IGZlbGl4X2luZm8gZmVsaXhfaW5mb192c2M5OTU5ID0gew0KPiAgCS5wdHBf
Y2FwcwkJPSAmdnNjOTk1OV9wdHBfY2FwcywNCj4gIAkubWRpb19idXNfYWxsb2MJCT0gdnNjOTk1
OV9tZGlvX2J1c19hbGxvYywNCj4gIAkubWRpb19idXNfZnJlZQkJPSB2c2M5OTU5X21kaW9fYnVz
X2ZyZWUsDQo+ICsJLnBoeWxpbmtfZ2V0X2NhcHMJPSB2c2M5OTU5X3BoeWxpbmtfZ2V0X2NhcHMs
DQo+ICAJLnBoeWxpbmtfdmFsaWRhdGUJPSB2c2M5OTU5X3BoeWxpbmtfdmFsaWRhdGUsDQo+ICAJ
LnByZXZhbGlkYXRlX3BoeV9tb2RlCT0gdnNjOTk1OV9wcmV2YWxpZGF0ZV9waHlfbW9kZSwNCj4g
IAkucG9ydF9zZXR1cF90YwkJPSB2c2M5OTU5X3BvcnRfc2V0dXBfdGMsDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9kc2Evb2NlbG90L3NldmlsbGVfdnNjOTk1My5jIGIvZHJpdmVycy9uZXQv
ZHNhL29jZWxvdC9zZXZpbGxlX3ZzYzk5NTMuYw0KPiBpbmRleCBmMmYxNjA4YTQ3NmMuLjJkYjUx
NDk0YjFhOSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9zZXZpbGxlX3Zz
Yzk5NTMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2Evb2NlbG90L3NldmlsbGVfdnNjOTk1My5j
DQo+IEBAIC05MTMsNiArOTEzLDE1IEBAIHN0YXRpYyBpbnQgdnNjOTk1M19yZXNldChzdHJ1Y3Qg
b2NlbG90ICpvY2Vsb3QpDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyB2b2lk
IHZzYzk5NTNfcGh5bGlua19nZXRfY2FwcyhzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0
LA0KPiArCQkJCSAgICAgc3RydWN0IHBoeWxpbmtfY29uZmlnICpjb25maWcpDQo+ICt7DQo+ICsJ
c3RydWN0IG9jZWxvdF9wb3J0ICpvY2Vsb3RfcG9ydCA9IG9jZWxvdC0+cG9ydHNbcG9ydF07DQo+
ICsNCj4gKwlfX3NldF9iaXQob2NlbG90X3BvcnQtPnBoeV9tb2RlLA0KPiArCQkgIGNvbmZpZy0+
c3VwcG9ydGVkX2ludGVyZmFjZXMpOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgdm9pZCB2c2M5OTUz
X3BoeWxpbmtfdmFsaWRhdGUoc3RydWN0IG9jZWxvdCAqb2NlbG90LCBpbnQgcG9ydCwNCj4gIAkJ
CQkgICAgIHVuc2lnbmVkIGxvbmcgKnN1cHBvcnRlZCwNCj4gIAkJCQkgICAgIHN0cnVjdCBwaHls
aW5rX2xpbmtfc3RhdGUgKnN0YXRlKQ0KPiBAQCAtMTEwNSw2ICsxMTE0LDcgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBmZWxpeF9pbmZvIHNldmlsbGVfaW5mb192c2M5OTUzID0gew0KPiAgCS5udW1f
dHhfcXVldWVzCQk9IE9DRUxPVF9OVU1fVEMsDQo+ICAJLm1kaW9fYnVzX2FsbG9jCQk9IHZzYzk5
NTNfbWRpb19idXNfYWxsb2MsDQo+ICAJLm1kaW9fYnVzX2ZyZWUJCT0gdnNjOTk1M19tZGlvX2J1
c19mcmVlLA0KPiArCS5waHlsaW5rX2dldF9jYXBzCT0gdnNjOTk1M19waHlsaW5rX2dldF9jYXBz
LA0KPiAgCS5waHlsaW5rX3ZhbGlkYXRlCT0gdnNjOTk1M19waHlsaW5rX3ZhbGlkYXRlLA0KPiAg
CS5wcmV2YWxpZGF0ZV9waHlfbW9kZQk9IHZzYzk5NTNfcHJldmFsaWRhdGVfcGh5X21vZGUsDQo+
ICAJLmluaXRfcmVnbWFwCQk9IG9jZWxvdF9yZWdtYXBfaW5pdCwNCj4gLS0gDQo+IDIuMzAuMg0K
Pg==
