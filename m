Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E846BB467
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjCONVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbjCONVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:21:40 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2092.outbound.protection.outlook.com [40.107.8.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6C256142;
        Wed, 15 Mar 2023 06:21:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTI6vb0XCr2IU+lgLWh1bP0e2L7tM9GckZiVvF/vMU5FtCGUNbt3znQoUBKLqEOEzes/pVjyXK+5x5g6FCHXa+oKG0EtPmqyMLJecnuW0/Td/NpZYOP51IqpBaDBhEyQJhobZxJRMKLs1k3dX6TOu2TA1Aezg6mjN+1bsr5vN9kZ/xGIhSpZh/oxLqjA8PJJN2x6b+3WC6dDFmTnC24svxuhybQ4WZv7D9gP3mLS/0it4qLYOb3HL3BaLItFDYA443/newZ6/GysKVl+t17uLzpXzDa2N8xSDhAiZOYj0POyOjMCMX0l1GBECzC09RsropXhTnpV2frPOVBCZ0KAlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D9ZVbxjeMDAvC5s3fENf4t6oZSP3Q8ke2OSisZvPJnw=;
 b=MvcR3JJEcPWkEGNbMuoo7SrJLL8v8P1+DYSjpGj+Hy/D9FTpPZ/5WyZ2wPBZug5kaIMUG8qzsp7VsjIqUJEHXckVRNIgatZujgvk8B4+l8SiQpQR+m5TYVAH/1t5mj8bPTgxUFzR16/rn4ue/GeBDCHtmHypAb+ZP1Yfqd5cD//ThoZXO/sj+qcGSKpIg8r4jF7qWlLYalRpGD4LOxr5JAFXqQ0B6ocmyFO1ww+9/ZyCJeqarDoiFFoJimlwvCEPv+DIkOr3xRZwvTPEuZ6MmWpRLqXrP5dfkfBx2fKd1x0n6FKKEFquHlcDIrFB45DB8+qWU5m2hDMUTh6wZpjJ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D9ZVbxjeMDAvC5s3fENf4t6oZSP3Q8ke2OSisZvPJnw=;
 b=lZPgj3NXpf4ZOvOQhleCyJCgMviy5Oeo4HYu3TVynJuGVeuHmGcNBBJFJWMGeBfxv3jy01Q2FulAMwhNozvP8MMvUKDu+GsgW4Lrb5MKbmngEIyaumlcE3QI1d1AZosf5zw9FfDq8BNhFMunHBasWkz6fjlnB914oe8PwNzGV7A=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM7PR03MB6657.eurprd03.prod.outlook.com (2603:10a6:20b:1ba::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:21:35 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba%6]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:21:35 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Thread-Topic: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Thread-Index: AQHZVz9lTE+uGaFSQUSC6VTaAJPT/q7706EA
Date:   Wed, 15 Mar 2023 13:21:35 +0000
Message-ID: <20230315132134.3xzj7nemljhgtqbg@bang-olufsen.dk>
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|AM7PR03MB6657:EE_
x-ms-office365-filtering-correlation-id: eb6cd2a5-8996-4e5b-1143-08db25583383
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PbzKrk+QJ5dO1AyJwWwn+Ze+h3Ld+aAduQsALpjlCwJimJDsjLkOUGz4mO1J4e/hIP8MjfYyGF+oJ2vJR/9jgrERcboyNRg701W62DyvsytWLDXRu1bcJlkf2q8+dPs89DmSK1yiwmgeP5S69lAOos3tEfflwiqYv+v0vnxwTD70dZAqd+8MJW38hlxVH73lkxJbs/JVMcZxNVDmVwV9B113/nO/8QT8qth9AXzUIscsL2Edp6CZ0b5V/gc8q8e+o4lmLxeG/aKPJwWHXNgeaBHVa4l8IuCXDX2bIbP/HrzhJxM4ceAc68B88+OxazpRE/8VZombat4mFdNHzfhgtwNSYjSDFMF5Q9hHA+SNlzRaKKeQNG9rTz5m0UCemvT3zTnfznTJm7gXdEKWg/V9Tkv+yf48c5/rPceppSCNaUtNRLnljK2lLYY/1CdAu7rwzRCYcQh399XUWgsa93k4NVw3CRF/xBSwWRN1wgFODzFzfP4gjdBUCQgxHwS7ObaQChHD5Q6LQjv1auk/uCXLbW9H/pCdEBGFCuwDasWEAUG06uWaRJN026xvHI+awAXYM1tyy+LhOkLEWH54KLN0c2VL4BSitv3lHY2k0bnoGoAddWxA4oCBLZ4jFKcYcbPE+S5yh6VUlR+eU9Tvunkojlg4wCfGvLZHNNSHB+yDUoXDS6bTfHxqNu942PJD3gmJ2gcmI5L66ynsdlP5ahMw+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(396003)(346002)(376002)(136003)(366004)(451199018)(85202003)(85182001)(36756003)(6486002)(122000001)(6506007)(6512007)(1076003)(26005)(186003)(83380400001)(2616005)(66574015)(5660300002)(8936002)(8976002)(7416002)(86362001)(4326008)(6916009)(41300700001)(2906002)(38070700005)(38100700002)(8676002)(71200400001)(64756008)(66446008)(66476007)(66556008)(76116006)(66946007)(91956017)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDl3eXFicENoeE9mUU5vZS9HSWpaWTh0MDN6K0NxY09PM0hmVUJXbTJDazhR?=
 =?utf-8?B?U3l5ZldTbUZqaVA0N0ZCSVdEM2lBQUJIc1BVVkx4endRWW5xM0kwS0VTcFNR?=
 =?utf-8?B?RlZiVUFOcFJDTkhIenkzd2ZxdkY2MkE2WmtFMW1KMVdCVVpUZS8rT1FlZUNa?=
 =?utf-8?B?emkyV21oMXRLL2dOZ3dMLys5UXZmcDY4RDVhZVhlaDdSNlltOURQYjFqVUZ0?=
 =?utf-8?B?S0pQa2djOEl5R25vODBqbWh0bmNzVlFGUGNrVi9UN1QxZ2dyTEY4Njh0bXh4?=
 =?utf-8?B?T1JtUFpOaTlZY1Q2ZU5wc0ZxRmR6MEpLZjVISmtVRjJ2ZHBCdGpGWlMrNEZX?=
 =?utf-8?B?K1pXengxU1NjbGRBQ3MrWEYrVmJscHd3M3RzZTFSZ1lOdjFLMkd6QnNPMmRa?=
 =?utf-8?B?K202N2NxZEdBejYrWHdodlJIY2Zxb0s4R3cyWmtNLzlEU0FJdmVETXdRWEZi?=
 =?utf-8?B?bHl3OVdnNFF4MkdsdXJ0eFBObUl6NVlMVHl1bUx6WlBMeFkraHJqNFJQbHJG?=
 =?utf-8?B?NGNjTGs5c05JWVhCNnFWUklUaEZzakdBWTF3US9Cb3BNUmlGT1JmSllqSHZV?=
 =?utf-8?B?MTh2elcrU3pHMWxiRXBnVTdrVnNLemh5OTRmWEhvNUxKaFc5Yk4rSUQwSjk3?=
 =?utf-8?B?VVhycnNoTS9Jc25mSkhUWFRIRUR5OTVDalgwS1BSa3NqNUU4SkxYcjN3T2JQ?=
 =?utf-8?B?Z2FndjBraks0ZmpFbDJtajZnL21LQng5bEVWaTYra1F6aWg4ZDR4NlYrRGhZ?=
 =?utf-8?B?SlR5RTVLYnZTOWlLVmxGVUJ6NjdRc3M5Q1hJVUlubm1iOUNlK2hSdU5KaGNK?=
 =?utf-8?B?N01DUkdJUUg0M2IxRTlUaGRKZ3pQcklVbk84eUVRZml4YzVmTW1jNlFydHdD?=
 =?utf-8?B?a0hPMmlXMGZVUTZRQ1E2VjI4eEVvSXpySS93Mml0UmYrSVpUdXR1dFVCdGhy?=
 =?utf-8?B?MWVMUGliYUY4c2U1Q29OQlF6VTVjKzhEU2ZuTFVKdERxeGk2L3ZuemxyZXBO?=
 =?utf-8?B?bi9aR1ZXZU05bUxjMTRuRDI2TU01RzNJbjRuazIxTlpXWEpuRVkxekpOTlVV?=
 =?utf-8?B?K3J5ZjRyZnV1Q29zeGJVcE80QVc3ZC9PalNpblRPYTVpdXFzRzNPSXBQWGhi?=
 =?utf-8?B?WXZ3WWswZEVpTFVWUGxlclBLMmcvMi9VeTE0NVgxVFJKQXU3RHhGNmZML1BM?=
 =?utf-8?B?TW9rT1IzcXMzOW1rSkZqcCtVclVDT28xTzNwWWIzWnBBV2F5clFXczdlOHp1?=
 =?utf-8?B?SWFMNDd5elFpSWFVZXFKL2IyQ3I2VllFQVdCTWliTEdOM0pzZ1pzMWcxaGdj?=
 =?utf-8?B?Vys2SGlycGJ4b2dMT1lEVm9lYlpPbkcwbFo0YVZwcXF4Z25Ec1BBVkJwVGRW?=
 =?utf-8?B?dDFjVWhHSmYzYTFYZE9BZkxzbGhTNEI0K1JxVVl2OVJHYWFrTkhBNWx4MXNI?=
 =?utf-8?B?VzhoTEFFN3NoSDBVNHc2cXpJVEZZNXJSSzl4enl4QkRIZTMxOUozT1JzTlVv?=
 =?utf-8?B?L2d6QVdISFFnZ3BTaUFQamFqQW43ODFVQXl5cE5rVmIzbTVSbEVsMlVRdUt0?=
 =?utf-8?B?aFhOQTVhT0o4MXZsUnJWbThqY3BGeFJpL3VCVi90ZytEUkpod2VUbWU2Z08y?=
 =?utf-8?B?ckVzSjRKSlNVQzFad05CZTRVTlVrWXMyMFRGWDI4UStTUm9aOWoxTlYrNTJO?=
 =?utf-8?B?anpLSzJWSFkrOE9ZaktNcGVlR05Xb01rWlFSWFVlQ1g3QTJJMTQ3Nkp0K0hD?=
 =?utf-8?B?REt6RGJnbXo1bGF3blpXZm9UYlhwRk1ZdDZTSzduNlhDMEdsRnVFZ3V4RXdv?=
 =?utf-8?B?dVhkdEJENEg0cjdyamptL3ZvOFdoeVhpQW1sWWRzcDk0UTIwY25DTFBVamVq?=
 =?utf-8?B?bExvaGkrMk0vVHZIcU4reENKVGRaSzJmemc0WDhhUjU5akhKZVBlQkhMM1lk?=
 =?utf-8?B?T2Q2c1drMWNTTEE0RHJCWXpMbmpNL2Y0N1dHYlAwdjJhN0I0ODEvcmRnQ2tp?=
 =?utf-8?B?UUdPMklyZUxId2JCYklxYldYZkZMSTJnMTU3ZEEzRTBNdHZ3UnpEaGMwV3hN?=
 =?utf-8?B?dHc5Qk1MVFVJTWc5R0xOR1krb1dtMmw0eEZ6cGd2Z2h4R3pSU0dRYlNjQUd6?=
 =?utf-8?B?UHJ1WDZrOUkrSS9ac2syT09OQVl5akR3dnBnNzU4c1ZxeFE1VThWNmFNVWxt?=
 =?utf-8?B?MFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE32F1789D1BA844B0FCBB5BE46B0FDE@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6cd2a5-8996-4e5b-1143-08db25583383
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 13:21:35.4165
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qHmGkbwZQi0J0k/LtfbOIcs308Q/ogqF0MsNPeQLGVoNFTRvxIocnFAu845qzd6vvqoxzAd90w4h1lgsI4ydsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6657
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBNYXIgMTUsIDIwMjMgYXQgMDI6MDk6MTVQTSArMDEwMCwgQWhtYWQgRmF0b3VtIHdy
b3RlOg0KPiBUaGUgcHJvYmUgZnVuY3Rpb24gc2V0cyBwcml2LT5jaGlwX2RhdGEgdG8gKHZvaWQg
Kilwcml2ICsgc2l6ZW9mKCpwcml2KQ0KPiB3aXRoIHRoZSBleHBlY3RhdGlvbiB0aGF0IHByaXYg
aGFzIGVub3VnaCB0cmFpbGluZyBzcGFjZS4NCj4gDQo+IEhvd2V2ZXIsIG9ubHkgcmVhbHRlay1z
bWkgYWN0dWFsbHkgYWxsb2NhdGVkIHRoaXMgY2hpcF9kYXRhIHNwYWNlLg0KPiBEbyBsaWtld2lz
ZSBpbiByZWFsdGVrLW1kaW8gdG8gZml4IG91dC1vZi1ib3VuZHMgYWNjZXNzZXMuDQo+IA0KPiBG
aXhlczogYWFjOTQwMDEwNjdkICgibmV0OiBkc2E6IHJlYWx0ZWs6IGFkZCBuZXcgbWRpbyBpbnRl
cmZhY2UgZm9yIGRyaXZlcnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBaG1hZCBGYXRvdW0gPGEuZmF0
b3VtQHBlbmd1dHJvbml4LmRlPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdh
IDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCg0KTWFrZXMgbWUgd29uZGVyIGhvdyB0aGUgc3dpdGNo
ZXMgd29ya2VkIG92ZXIgTURJTyBhbGwgdGhpcyB0aW1lLi4uIEkNCmd1ZXNzIGl0IHdhcyBkdW1i
IGx1Y2suDQoNCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3JlYWx0ZWstbWRpby5jIHwgMiAr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1tZGlvLmMgYi9k
cml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYw0KPiBpbmRleCAzZTU0ZmFjNWY5
MDIuLjNiMjJkM2Y3YWQ5OSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsv
cmVhbHRlay1tZGlvLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsvcmVhbHRlay1t
ZGlvLmMNCj4gQEAgLTE1Miw3ICsxNTIsNyBAQCBzdGF0aWMgaW50IHJlYWx0ZWtfbWRpb19wcm9i
ZShzdHJ1Y3QgbWRpb19kZXZpY2UgKm1kaW9kZXYpDQo+ICAJaWYgKCF2YXIpDQo+ICAJCXJldHVy
biAtRUlOVkFMOw0KPiAgDQo+IC0JcHJpdiA9IGRldm1fa3phbGxvYygmbWRpb2Rldi0+ZGV2LCBz
aXplb2YoKnByaXYpLCBHRlBfS0VSTkVMKTsNCj4gKwlwcml2ID0gZGV2bV9remFsbG9jKCZtZGlv
ZGV2LT5kZXYsIHNpemVvZigqcHJpdikgKyB2YXItPmNoaXBfZGF0YV9zeiwgR0ZQX0tFUk5FTCk7
DQo+ICAJaWYgKCFwcml2KQ0KPiAgCQlyZXR1cm4gLUVOT01FTTsNCj4gIA0KPiAtLSANCj4gMi4z
MC4yDQo+
