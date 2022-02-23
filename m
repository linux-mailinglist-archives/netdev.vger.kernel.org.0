Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67384C1048
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 11:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiBWK3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 05:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbiBWK3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 05:29:06 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F68C7C7
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 02:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JK9m668rRVcgYFWDWvl+sfM/gsf0urSQeJGjqTQNKFNNJbKYXCRfjEgPxOtvJEHCYlLttOf9FOnNBixGDoW9pDxorEqEINawS+QssVn2nAA1vZtTogIS+B5RyZD6J1EA/Ulx6shObn6zrjTxp9KM9h+WVRWawsQxhnDez4/tKqByoRVmIq+D38FcmTDJvnZfeE7mC5CyL3jGt7dvO/5BqvkXGaeRjm1w9hLfJhD/N2nLFfBkY91rHdsK/JUT3blDJOHUNe5x/XyGTnh1UFF7MTDhHV8+qABUoh7hNco37P23M1vOyx/p+dGRJv1ZF34l8/zbD/lA+hWRv+amnbcFTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=szLiQB4E74ryBlKEzWL1OQ7rT5MsAyd/Ss9pHGLTX08=;
 b=hHxj7oyyIaI75wDjzQkI8+1YuxnXj9Jv++V0+vy91fYbyC5WXzrpjhmZ8LWMHi594vj2rMrrFIknxcDNjAMuyMUzlygr83N0gNpGCc4avjyl4LWdufmtS4Uc0pe7v57MzyWtcyWmDjcsD/vR3XdKFvZrQazDfP6zHfmh1skPnWkxaZz9fL/Ui6nAdvhVWrdvRY6OEt2Y4I9ObQaD9ssyuHTwLgKtysyetF6hJCi6djTVCtEJfPhtrnzoxKW/gUAVj3JRxvEUKRsvbpn3AKTefOUBaPLxI/v0C+GhOzbJQfVF+RRemdOe4Q6qlTmJkY1/R4mNjqQuDqi+pX99xNH/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=szLiQB4E74ryBlKEzWL1OQ7rT5MsAyd/Ss9pHGLTX08=;
 b=at7ANwxqvc0gGqrN1mEIBQVTrVZNCQ2/mNYcbs2uiZNbDqVgFfj/boF0wcKYuJhvcBufiSf1K7gRyqwRMLbYx8Y0M911CDYSDH22/0LsLboqjlS2VTgKGXn4XAoAFr/E2hf3rhlSAqRGy9rLjvglin8SSDkHjCGfNytdX7LqW9M=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by AS8PR04MB8072.eurprd04.prod.outlook.com (2603:10a6:20b:3f6::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 10:28:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d19c:f6ff:814a:e0c3]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d19c:f6ff:814a:e0c3%9]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 10:28:34 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: RE: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Thread-Topic: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Thread-Index: AQHYKIyscA7G5aKyYkaL59ObHIcYZKyg7Uug
Date:   Wed, 23 Feb 2022 10:28:34 +0000
Message-ID: <DB8PR04MB6795F51CEFF0DE50E57C9FFBE63C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20220223080918.3751233-1-s.hauer@pengutronix.de>
In-Reply-To: <20220223080918.3751233-1-s.hauer@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd0e015e-e691-49c4-f7e1-08d9f6b73f35
x-ms-traffictypediagnostic: AS8PR04MB8072:EE_
x-microsoft-antispam-prvs: <AS8PR04MB8072CDE49C8AD67DEEB4B9FAE63C9@AS8PR04MB8072.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igkIdHByI8Pe7U1gYj1X01vlfIenwYIekVGT4u6hfP4LE0yA6u8eyZ7H/m/popxBjt931FiHztPEqUp4YhZ1oi9XCaqq1N4AsW9ILiFP4guF2ntJa7eLUKyrxeX2gLRBF13QJBHEkuUDxVobHukGr9JO3FKBu/doBeHCJnaPEklef3mj5STqxM1YsFdssvZPzvHOlrAmNTkFhgi5uwOwZVOzUu4LuPucyXC1OFMGED9vgNKn3icr1r99K1lJneoz9mdpc96GJnbImvtlVMy1UdMANm2rFIkRWRH1oDqLrKyJCFo9uzJDLTEP+/qXBcepk7H5Zg2FHDMKuL2jl+ZG5945Ypb6DVdmbYIHOrLsPJ+c9LcBKaZ2ZEknHa9BQtg4ug4rpC1yPMs33amnVTWXtFBBm4SmsShMKuC7Wbzpquw1AlQq07/SCQ+z3XX+9rzYdkUW9MxiZ8NYb88NOQAOWr2qY2DgCAiijXjZUKrFWvqTjxd0adlHVHSNoAdaXcvgjl1p0CjYJy6vkjLGMe0NNnp4X0Z6HyaFlLDKhoyJqm/OWyZVZ2ZpvB9KetOZEXEw3CPaM1O4Cx+IX+KNgTKqUb2qh5LOXmjGqVAkpOY3J4Z/qqGN5pSCtpc1GXYpDQ5ZFFoxfH+1IW7736/KqODL8Vrx8So5mbjGEZ9urZZM1A3PdKS0vpVPx6/3Xse6njKWh1tUzD/RIsOFR8zBl4cEuxcA40fHpcZ1g/tS1BU6U9mn4UddfVJFXxZ+1VRrmF1HmtOo4yqUoSKU8r2dEWRlwtsBJ1hcThp41EUOPdD4rPM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(83380400001)(2906002)(186003)(26005)(9686003)(6506007)(55016003)(53546011)(7696005)(8936002)(86362001)(8676002)(64756008)(66446008)(54906003)(4326008)(110136005)(38100700002)(316002)(5660300002)(71200400001)(52536014)(38070700005)(966005)(33656002)(66476007)(66556008)(66946007)(76116006)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?NzUwZmtsQnFPVGp4YlNKSG9uZ2Y3YkZqUkVxOTl5YjVDNG5hNE51WWdtMHl4?=
 =?gb2312?B?QUNVaTFXcng1c2R2cDk3Mjc5YVJ0b1A1ckQwdXJEZGhlaHZCV0RKR1E2VHAx?=
 =?gb2312?B?VkFZS0VScmhIaEFpUFpyUXlseHVDTlZrUFY0WmJWZkZmSFRLdi9tZmppTFdX?=
 =?gb2312?B?RUE0MkdoUUJpOVlwSnJqeEZlR2tUZUhLUFpKeXBSVnU5Tk1qcEs2cUROVVFo?=
 =?gb2312?B?V3NQcm1VUVlMUFFEeERheUxVZ29JU3FSTVU4QmhvaDlDTTNPSzk2ZXEweFNS?=
 =?gb2312?B?QysvQTkxYSt1UUcxZnJHU3R3elVWdFI4R3N2MHhFeDUrWThWaUIwT3Q5MFI0?=
 =?gb2312?B?OGNuQnlockpzTHdMRUFPaUxKWUtvUVhtc0x5SStncHV1RnluSjVDTlJkVlZr?=
 =?gb2312?B?aTRESEloeVhNUnp3MHNBTzhIRjZ2TWhXai9Xc0JwOVFQRjdwUTdiRFJaR3lZ?=
 =?gb2312?B?NXIzV01HYkh1UVhTRHp2bWVjejV2UitrbFkyaCtYSWw3V25pa3VKc1loQStI?=
 =?gb2312?B?SGNxZnF4ZlBrNzk0L25pTkF6Zm5TWXdCNHd3Y1ZyV1daRWVoRlBlU25VbHFC?=
 =?gb2312?B?dEFvR001V2RsQ2NXSGMvSjRNYjBQbXd5WDQ5cnk0NTlUOG9saCt3S2IzQXpC?=
 =?gb2312?B?cnRZczBsQk9GVG1Wbkl5bHo5SUpHaTdNOEZhZHFUcVQ5ODVxT0ZmYkY4NFlu?=
 =?gb2312?B?VEZETlBGM3FaZER2Qi9UWWdRM1FyNE91NFAvaVZsdG81bEN0UnJUajg0RXdj?=
 =?gb2312?B?OS9FQVpTcWsxc1NheXZlWk1lZ2RSTFRNRmlHOStpSE1yZkMzNDZLMWlabzFM?=
 =?gb2312?B?L20xTmIyTzZBdnVUTzVQb2oycThUTm8rMTZvR1NHT21iSk1LZk1US21hSFFt?=
 =?gb2312?B?TGJSc3RZZHlvNFo4cU8wUDhZUE5UUFFrN2JNVTh1YWpiTHFleFd2bjA4L3V5?=
 =?gb2312?B?R29vbndLdSt5R09iejk0NlhIb2VXRGd0STBaeUEyYlJscS82Q1N2aTduOXdK?=
 =?gb2312?B?cWYzV2NzK1ZQNG1PcGpYTE03MDRoMmNGeCt4cDdrK3U4Z296ZHBYVTdEODVJ?=
 =?gb2312?B?RlJhbWNSMU1rMGQxUklYd2tlS3NtREdGcjEybFNyN1dLeDdseGJSTkJvc1ZX?=
 =?gb2312?B?dWZicEtrSUFIV2I5L1BvUmsxalcrWGlXbm15T0JxZjRVekdlVUZRcHRyUEF1?=
 =?gb2312?B?VXU3eXNwT1RrTEd6eUdzeDFNeTRrL0pKV29odk5QeHUzRStraUF4c1FjUHdu?=
 =?gb2312?B?VG5JRVV2S2hkS1dVRzNWa0FaVWt6UFZZUVE1MEU3dmdEL3QwNUUyVGpQaXpK?=
 =?gb2312?B?YzU4dGFNQ3pLZGJhWUd6aWRlcmVFbXhwYzRNY05kVnFUUkZUYW1QekpTbWE4?=
 =?gb2312?B?amgwNDVFSkJyN0hCOGhQQ3NkUUt2bSt3V09uYm9mejlHcy92YXJ4eTB0M2JE?=
 =?gb2312?B?MXY3M1Q0L0Y2M2ExTCtCcm9vN05sODhsQjdYbHE0ck0vODNsZ21Wc0IwVHc3?=
 =?gb2312?B?Rk1lVVBUOGM4dmx4OENsVzNyYTJtV0Z3bVR5RWo2SE5UMS9XYVpuQ3U5TmNU?=
 =?gb2312?B?ZW9xR0FPT3ZoVXNMdmpFRnNnajlaREdvKzBBb3lnei9LSis0a0dHR3V4NlNR?=
 =?gb2312?B?UVZ3UVdKM2Zrc3QydSs0eS9XWFQvM0tsM2dhZ0pFNkluQU9Qekdpa2xYeDc2?=
 =?gb2312?B?VytQaDlGWXBOTXd5VUR3M1pNSEptWGpubVk5Qlpma3ROVGp1ejZod2k5dVhw?=
 =?gb2312?B?YzlhSWZwMUx6QmxTMlFidXNwdUIwcDhhczdMZy92bU5DNWxaSnRkcEVjUVFU?=
 =?gb2312?B?czV0a29BdjFWZDNDMXBvWkcrTFhYR3VVL3FGMU9Pb3pRRG9lalpXeS82REc4?=
 =?gb2312?B?aXRiZjBtSTNrV1NpcVdGUDhqUmJoUE82VzdHMlQ2bCtsSm5LRzEyRFpkWXpZ?=
 =?gb2312?B?a1l6SmFUUlVQcDRRUVowUFZVem9IakdRcTR0b2RpMlgwYmFMbjI3N0dVR29D?=
 =?gb2312?B?MWJCUHJIZFNTeWFNUjkzUWluei9YMDdWdmQ4QUpKMjBmRTFRTTlMNUFXTFlM?=
 =?gb2312?B?RlUzVFB5UUZ0VDR1NUZPazNiS1RSM0dldStkVzlPR1FqWXFuZVRNTWVYRFZi?=
 =?gb2312?B?bzMxUXFVbkRNeGZBVExiRVpkYkoyeWNHMytESkVSbXV4VDQzZDZyNVF3MVVi?=
 =?gb2312?B?eEE9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0e015e-e691-49c4-f7e1-08d9f6b73f35
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 10:28:34.8960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPNGYQq72A/7H44OYdf4ch47KfUOipt0x6hr8fHCbx1kxrOG1p0V91cASCyB1QVob/LtYC9LaGgt8zgfa/H5oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8072
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTYXNjaGEsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2Fz
Y2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIyxOoy1MIyM8jV
IDE2OjA5DQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBKb2FraW0gWmhhbmcg
PHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IGtlcm5lbEBwZW5ndXRyb25peC5kZTsgQWhtYWQgRmF0b3VtDQo+IDxhLmZh
dG91bUBwZW5ndXRyb25peC5kZT47IFNhc2NoYSBIYXVlciA8cy5oYXVlckBwZW5ndXRyb25peC5k
ZT4NCj4gU3ViamVjdDogW1BBVENIXSBuZXQ6IGZlYzogZXRodG9vbDogZml4IHVuYmFsYW5jZWQg
SVJRIHdha2UgZGlzYWJsZQ0KPiANCj4gRnJvbTogQWhtYWQgRmF0b3VtIDxhLmZhdG91bUBwZW5n
dXRyb25peC5kZT4NCj4gDQo+IFVzZXJzcGFjZSBjYW4gdHJpZ2dlciBhIGtlcm5lbCB3YXJuaW5n
IGJ5IHVzaW5nIHRoZSBldGh0b29sIGlvY3RscyB0byBkaXNhYmxlDQo+IFdvTCwgd2hlbiBpdCB3
YXMgbm90IGVuYWJsZWQgYmVmb3JlOg0KPiANCj4gICAkIGV0aHRvb2wgLXMgZXRoMCB3b2wgZCA7
IGV0aHRvb2wgLXMgZXRoMCB3b2wgZA0KPiAgIFVuYmFsYW5jZWQgSVJRIDU0IHdha2UgZGlzYWJs
ZQ0KPiAgIFdBUk5JTkc6IENQVTogMiBQSUQ6IDE3NTMyIGF0IGtlcm5lbC9pcnEvbWFuYWdlLmM6
OTAwDQo+IGlycV9zZXRfaXJxX3dha2UrMHgxMDgvMHgxNDgNCj4gDQo+IFRoaXMgaXMgYmVjYXVz
ZSBmZWNfZW5ldF9zZXRfd29sIGhhcHBpbHkgY2FsbHMgZGlzYWJsZV9pcnFfd2FrZSwgZXZlbiBp
ZiB0aGUNCj4gd2FrZSBJUlEgaXMgYWxyZWFkeSBkaXNhYmxlZC4NCg0KSSBoYXZlIG5vdCBmb3Vu
ZCBkaXNhYmxlX2lycV93YWtlIGluIGZlY19lbmV0X3NldF93b2wuDQpodHRwczovL2VsaXhpci5i
b290bGluLmNvbS9saW51eC92NS4xNy1yYzUvc291cmNlL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Zy
ZWVzY2FsZS9mZWNfbWFpbi5jI0wyODgyDQoNCj4gTG9va2luZyBhdCBvdGhlciBkcml2ZXJzLCBs
aWtlIGxwY19ldGgsIHN1Z2dlc3RzIHRoZSB3YXkgdG8gZ28gaXMgdG8gZG8gd2FrZQ0KPiBJUlEg
ZW5hYmxpbmcvZGlzYWJsaW5nIGluIHRoZSBzdXNwZW5kL3Jlc3VtZSBjYWxsYmFja3MuDQo+IERv
aW5nIHNvIGF2b2lkcyB0aGUgd2FybmluZyBhdCBubyBsb3NzIG9mIGZ1bmN0aW9uYWxpdHkuDQoN
CkZFQyBkb25lIGFzIHRoaXMgd2F5Og0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgv
djUuMTctcmM1L3NvdXJjZS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4u
YyNMNDA3NQ0KaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjUuMTctcmM1L3NvdXJj
ZS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYyNMNDExOQ0KDQo+IFRo
aXMgb25seSBhZmZlY3RzIHVzZXJzcGFjZSB3aXRoIG9sZGVyIGV0aHRvb2wgdmVyc2lvbnMuIE5l
d2VyIG9uZXMgdXNlDQo+IG5ldGxpbmsgYW5kIGRpc2FibGluZyBiZWZvcmUgZW5hYmxpbmcgd2ls
bCBiZSByZWZ1c2VkIGJlZm9yZSByZWFjaGluZyB0aGUNCj4gZHJpdmVyLg0KDQpBaGgsIHdoYXQg
SSBtaXN1bmRlcnN0YW5kPyBBbGwgdGhlIGRlc2NyaXB0aW9uIG1ha2VzIG1lIGNvbmZ1c2lvbi4g
UGxlYXNlIHVzZSB0aGUgbGF0ZXN0IGtlcm5lbC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+IEZpeGVzOiBkZTQwZWQzMWIzYzUgKCJuZXQ6IGZlYzogYWRkIFdha2Utb24tTEFOIHN1
cHBvcnQiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBBaG1hZCBGYXRvdW0gPGEuZmF0b3VtQHBlbmd1dHJv
bml4LmRlPg0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNjaGEgSGF1ZXIgPHMuaGF1ZXJAcGVuZ3V0cm9u
aXguZGU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWlu
LmMgfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gaW5kZXggNzk2
MTMzZGU1MjdlNC4uNDRhMGM4OWQ3NmRkNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
ZnJlZXNjYWxlL2ZlY19tYWluLmMNCj4gQEAgLTQwNTUsNiArNDA1NSw5IEBAIHN0YXRpYyBpbnQg
X19tYXliZV91bnVzZWQgZmVjX3N1c3BlbmQoc3RydWN0DQo+IGRldmljZSAqZGV2KQ0KPiAgCXN0
cnVjdCBuZXRfZGV2aWNlICpuZGV2ID0gZGV2X2dldF9kcnZkYXRhKGRldik7DQo+ICAJc3RydWN0
IGZlY19lbmV0X3ByaXZhdGUgKmZlcCA9IG5ldGRldl9wcml2KG5kZXYpOw0KPiANCj4gKwlpZiAo
ZGV2aWNlX21heV93YWtldXAoJm5kZXYtPmRldikgJiYgZmVwLT53YWtlX2lycSA+IDApDQo+ICsJ
CWVuYWJsZV9pcnFfd2FrZShmZXAtPndha2VfaXJxKTsNCj4gKw0KPiAgCXJ0bmxfbG9jaygpOw0K
PiAgCWlmIChuZXRpZl9ydW5uaW5nKG5kZXYpKSB7DQo+ICAJCWlmIChmZXAtPndvbF9mbGFnICYg
RkVDX1dPTF9GTEFHX0VOQUJMRSkgQEAgLTQxMzcsNiArNDE0MCw5DQo+IEBAIHN0YXRpYyBpbnQg
X19tYXliZV91bnVzZWQgZmVjX3Jlc3VtZShzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+ICAJfQ0KPiAg
CXJ0bmxfdW5sb2NrKCk7DQo+IA0KPiArCWlmIChkZXZpY2VfbWF5X3dha2V1cCgmbmRldi0+ZGV2
KSAmJiBmZXAtPndha2VfaXJxID4gMCkNCj4gKwkJZGlzYWJsZV9pcnFfd2FrZShmZXAtPndha2Vf
aXJxKTsNCj4gKw0KPiAgCXJldHVybiAwOw0KPiANCj4gIGZhaWxlZF9jbGs6DQo+IC0tDQo+IDIu
MzAuMg0KDQo=
