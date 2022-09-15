Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5425BA028
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 18:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiIOQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 12:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiIOQ7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 12:59:50 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80112.outbound.protection.outlook.com [40.107.8.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07E917A87;
        Thu, 15 Sep 2022 09:59:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gX0KXDA6LDGS6EIj/JMESImw+NOQIuCBMBYkpXcBXYItJESKMSetPyWf2X/+IBI8DMRpo1ICSe7V4QipuKxw2rqLgeuFM0m/HnVL1vBpOBx36LfSHfIXhzNSNeIkE2uCDNylLdE44R26fT+w5bM9//pNyDi7dydSNbg/KgJizs7e1ROC9nnT4OySvnkikIi/s8bvZ+li8xiB5OD2wD+xCJqfA52rpuTAkQd58Y/GnWWXiI82/sUAdG6qnVrb5jPuSwKT/U99awYNvkoL5Jz6Em5ei5zKR/Iyg3P4f6EqdsBf4n7a3PJ9Eg1O3c/tfBKDXUdC7DFzroFvdAVfUPN+mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1A7X7eiXaw+phrrLdHLWSgRe2XsEDpbffENvQ893Z/k=;
 b=MQFNPvj6Zz49YWIWN5//sC2RS78PWTNZmkjNnoLHr1Db1L51qTs2ufMuRxpNwu3fYFSa5vw2W3xkrwTXNiwXw/vJhpEdYeC3ube3A9/yGgXdjP3apdn+6zepCfmiOa0egEhhRU97yGSTK2RfmqrhNHTeMdeLBlAY9IEbW3xn6bvipN2bN9HBj21/e0chD8H4gD9w+BcLaLbOOB82mIXkjgse/5L33TAzmN0ISZmaqfSpTrW0re4KWATCQ3lbKTG6gGVwv58DqUW5DH/YZv+Lqq+atW7Md+fKs4R5G+G3VKoB3dWca/rKtvsGRYdv4mafxkw9t8H8lQYUidQ6gvLdBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1A7X7eiXaw+phrrLdHLWSgRe2XsEDpbffENvQ893Z/k=;
 b=XNKXBv+ArEORs59bi2ytLHDcE52TbtVQp3oL/Cuy1Z+BvSoSB6xXmjlJEsaj6/8Za5atA5jElK6L+oBuDQg1dQi73BrV1ZWHWKUYnow+6hYtjTsxr6Zx1N6aRvrfrMy74GzbGmgPHKSXYomDgkcFF0FORj4e8c9Z2iizdnn145I=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DBAPR03MB6630.eurprd03.prod.outlook.com (2603:10a6:10:194::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 16:59:46 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 16:59:46 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>
Subject: Re: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add IDs/properties
 for BCM4378
Thread-Topic: [PATCH wireless-next v2 11/12] brcmfmac: pcie: Add
 IDs/properties for BCM4378
Thread-Index: AQHYyRi3xj6oNdMJR0m5ZebHMKLX9K3gtVyAgAABjIA=
Date:   Thu, 15 Sep 2022 16:59:45 +0000
Message-ID: <20220915165943.pwhxg6yqsiapm2qx@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg8C-0064vf-SN@rmk-PC.armlinux.org.uk>
 <20220915153459.oytlibhzbngczsuo@bang-olufsen.dk>
 <YyNYs5Acdl8/zazb@shell.armlinux.org.uk>
In-Reply-To: <YyNYs5Acdl8/zazb@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DBAPR03MB6630:EE_
x-ms-office365-filtering-correlation-id: d4d65c9e-57e2-410a-f1df-08da973bb144
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9xJUguCafs0RJTqr2w9ImGl8HcEy5lwOkv/qhZC1hndfvoaeDjDQLJ5uLSzQxXLECNjPSA7UKoHSdG4kELAwcum+v4QdGPAtcvq76zohN16TuwW9CDh26PItykPkrH0DapsUNE4cl4rhSsMp0V4psZNnhCN/hOcv0HwB5UbrqgknWtAe6VVMf3cYY3mVeUDGAbSq5BfheV05LP/J2WZ5ZWfGoH4PYPpxwpPlVZsexbmODalxivEkzFMt1BOUi1X7Pr4xuJMTMGDqOsW2Dkh7RJUQ8wdCAmIWw/r6E97q3A54YBmbVf1bqH0EoSu+Lux/Y8VmAwBcfdMyn7I17xllIujPlPXXMcEFcj9pOqhWdMuqAoF/K52dOkHW4Y1mLGxnddCVhvSJhIWA2dZhQUIEvrqILae3mkCnqUdWSsAef6egdQNjD5Xt62tNOKet5FkMgfUli73UavUsOQ4r2S29aTYinxSKs+Dxh60nkYQ3TEFr+KJgFIC5gwrEwm31Ry32PcRGMBfm/7VHwp5tbAKXPoiBDUWQGAjpQyyyGJPHeTOINDpZn+aNHHtoXAfNj9c4yOyVmlwTarcMBmdSukdX72aQdlGuS/fg+7sy0JSAaKp8DcRCUp7mJcdj9RRtiG443mzcjQggq1VSGXhDudgwMzxpq2Y/Vg/lTUKX0fy1sKchz8mkt2EhjqnemW7yg8yMNvNQ+rH1X8f71Mt0h/IXXeXWKNYCxAgM2xc3SyYNgtmUBfgEdr7nfIsFS+ezDFXjL9FjQ+vi0LTmFtlwvw0aw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39850400004)(366004)(136003)(346002)(396003)(376002)(451199015)(66476007)(8936002)(8976002)(64756008)(66946007)(76116006)(8676002)(66556008)(91956017)(4326008)(66446008)(2906002)(7416002)(5660300002)(85182001)(6486002)(36756003)(71200400001)(478600001)(122000001)(38100700002)(6512007)(54906003)(6506007)(41300700001)(26005)(85202003)(316002)(6916009)(2616005)(86362001)(83380400001)(38070700005)(186003)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TWw0Ty9rbkljYzdjaFNRZ2t1WDZWeEYzd25YTURrVmVoK3ZkZ0VjTUIwdm1J?=
 =?utf-8?B?elJRWXJBUENWUEFwK21lcll3UWlxSWFDNEFWMDlLNDZnN2pDb0UvWmJpa3A4?=
 =?utf-8?B?d2FvQTVZMWxaTnlaWE5sZ3FpUEJtdUd5N3Q4V0prRGs2MUcrMzNFSDFmS3lK?=
 =?utf-8?B?YXdLS0ViREIrMTlwTWNFK3dWZFJkMHNBV3I4L1o2dFVEYkoxS3NNNjg2NFJN?=
 =?utf-8?B?RTludit4OTBiSksrNGl6UW9tNHdUNmZ6S3hmcDZtK24zUlBEL1llZGJHMXY5?=
 =?utf-8?B?VEdtS241aVRsUzRLMG0wMyt3YmxvZ3F2aStKZlZLbGlHK2w3TCtqcS9WN1g1?=
 =?utf-8?B?SjQ1LzhaVFl2SzBXTTZYS2tMeWhaalZUa1VoNmJIeTk1allnOHlOWVBaeEJ2?=
 =?utf-8?B?eDlZNk01SkNkdG00VUtDUEtUNm5JVER3elhtZmhJdDMyTm15emJOYnZhK2M1?=
 =?utf-8?B?QkxLV3NxcnRjNVZBNytYTG5RcEpvMWF5Q3ZVM3J0WDJ6bDA5QVNvUnBLMG9x?=
 =?utf-8?B?bFJlcEJHTTQvQzZOVmJIN1RjUEo1TXltcmJOUXA0Yk1lV016QWtzYnBCckFP?=
 =?utf-8?B?bDdhKy9ZdTM1bDFYSUwraTdzYXkyVnIwNU5jTWFEU3J0Wk9PVmgwa0dyZ0U2?=
 =?utf-8?B?WlZiQndaOHBCQXVZMmszMEJ6UjFkNFY0UkdTQzNLanFWZVFaVE9kTDlpbzFL?=
 =?utf-8?B?ZG9CbXRpcXBFeHk1OEF0dVI4dm9yVGhTSUFaT01YN0xKV3lDK2dOcHpwblBS?=
 =?utf-8?B?andIUzBsNG1JQi9YQ2w4T0dNK0w4QWlkbDFYTkhLUERqY1ZNTnVibCswNkpp?=
 =?utf-8?B?K1dKTDlzSi92TU1EUG1EdjlFbVR3RVZGNmRXRFNFc04zZE53a0lnRzlYRzEz?=
 =?utf-8?B?OGVnbCs2Z1Mwb0ZQYWROdjg3cUpIanJMbHJ4REtSNHNyaGtFK1hRNDBDdFV6?=
 =?utf-8?B?alNnVmg1SzJ4K0FLYzlaYlRYL2hrdVlQcnQ0a0tOZTEwbGRJSUFoSFFqQXph?=
 =?utf-8?B?ckJ3RzlvZ1RVUmQrRkRyU3pkS3MvcHBsTU4weDE3cmVrajJyUUhVaklVR1Rj?=
 =?utf-8?B?VkhCd1k4TnRBUFJNRU5ueWJnQjNEK1lFSGsxdit6dStDMVBvWUM5a21ZcWxO?=
 =?utf-8?B?UmtqaE1ORndHdTM4WlV5dm1TRlVPS0lDUzNIRVQ3bDBaUmNQT2ZDM3FOQlRy?=
 =?utf-8?B?bU9uUDcybVd2YlhlbWo3RkF3cUhqVDdORVB6cEVEcVFCMlZxV2VNOGNJUXEx?=
 =?utf-8?B?TmZZRmhIWjVCc2VKUzVBSDRPN0FJUjBoWGtzWmROTnBZTmhLRDZjbkV0WkZm?=
 =?utf-8?B?MnRLVlRCRStJOVdBOUwrRjRqekJNa3VnZmN4RmRONXhSY3VMV1FWUmhUeUhU?=
 =?utf-8?B?blZHaXN4NFFvaXZneUlxWStEdGR4WkJJSHNBcnhwREFZNmFxc0JPL1B4R0lR?=
 =?utf-8?B?R054VWU4SjQxWVd5M212Rm5NbGY3UjUybmh3NlcvOWdMOUlSZUNLemlIZisw?=
 =?utf-8?B?VEZ4bW9pQjlvNzc1aXlsdnBvd2M1QXdOTUZCVVZWV0VoMmsyb2VMcmk4R0pC?=
 =?utf-8?B?Y0R4MTIzZldudHU1OWFnSmtBeU1FaXJDU0tha2JFbXNxSENmM2F2SnJYeVlV?=
 =?utf-8?B?YXdUVzB0b29qYkRWVGgyc3hDQS95V1FMaXJDaUVFeURvVUhqV0dlVnNtYnl2?=
 =?utf-8?B?UUUzbEk1L1kwSlhncDE3cWRFL3A2bVpWbjAyb0w1M2dQZ0RmSUVEdEQ5MC9Q?=
 =?utf-8?B?eHRoRzJMSzJiZHNFSVNXdTlzMlFhaEJwQWxwZndpVUZyOXl4ZlBtUjJsTnRp?=
 =?utf-8?B?MzlzT2E1d21nYXBNTkw5SzZlbGZxcWUrdjZlbXZnY3R4TE03Z3RMdTA1UUhm?=
 =?utf-8?B?dlZZeXNoZVh2V1N6RDlTMkxwVjBnUWIvNlhjNWpuaTdQTjhaQTRlMTd2MUpo?=
 =?utf-8?B?YjNyczczZE1mQlJZQm9tTThmQXZ0eTBLZUYwOUE4c202cnYyVVFUTEZCTTFt?=
 =?utf-8?B?cTFaYisxZkh5a1RHQ28vM1h6cWV5R2Y5Vko0a01DaVBmOUM1Mit3bFcrOFRU?=
 =?utf-8?B?Q2tmdlROZFBzU08vYVNNR1VUbzFteUoyUFlIQlozYjhkRWx2ZE5NUzNmbzNN?=
 =?utf-8?B?d0dmTG5HdjBXU3IrdW0yS01uNGJwR2xtVDROMUxRZ2RGVkZLb290OFRZNmJS?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8B5039E7CC2D4A4EB412691E9202BB20@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4d65c9e-57e2-410a-f1df-08da973bb144
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 16:59:45.8828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NggymPihy1M7fl0vCCbBBL9B10Qxlmfp0HJ4Hu1HCInf65Up7aUYVWUcZBQ85IjyE3x2ORLNr6bWN/HencKXeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6630
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCBTZXAgMTUsIDIwMjIgYXQgMDU6NTQ6MTFQTSArMDEwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBUaHUsIFNlcCAxNSwgMjAyMiBhdCAwMzozNDo1OVBNICswMDAw
LCBBbHZpbiDFoGlwcmFnYSB3cm90ZToNCj4gPiBPbiBNb24sIFNlcCAxMiwgMjAyMiBhdCAxMDo1
MzozMkFNICswMTAwLCBSdXNzZWxsIEtpbmcgd3JvdGU6DQo+ID4gPiBGcm9tOiBIZWN0b3IgTWFy
dGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiA+ID4gDQo+ID4gPiBUaGlzIGNoaXAgaXMgcHJlc2Vu
dCBvbiBBcHBsZSBNMSAodDgxMDMpIHBsYXRmb3JtczoNCj4gPiA+IA0KPiA+ID4gKiBhdGxhbnRp
c2IgKGFwcGxlLGoyNzQpOiBNYWMgbWluaSAoTTEsIDIwMjApDQo+ID4gPiAqIGhvbnNodSAgICAo
YXBwbGUsajI5Myk6IE1hY0Jvb2sgUHJvICgxMy1pbmNoLCBNMSwgMjAyMCkNCj4gPiA+ICogc2hp
a29rdSAgIChhcHBsZSxqMzEzKTogTWFjQm9vayBBaXIgKE0xLCAyMDIwKQ0KPiA+ID4gKiBjYXBy
aSAgICAgKGFwcGxlLGo0NTYpOiBpTWFjICgyNC1pbmNoLCA0eCBVU0ItQywgTTEsIDIwMjApDQo+
ID4gPiAqIHNhbnRvcmluaSAoYXBwbGUsajQ1Nyk6IGlNYWMgKDI0LWluY2gsIDJ4IFVTQi1DLCBN
MSwgMjAyMCkNCj4gPiA+IA0KPiA+ID4gUmV2aWV3ZWQtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVz
LndhbGxlaWpAbGluYXJvLm9yZz4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEhlY3RvciBNYXJ0aW4g
PG1hcmNhbkBtYXJjYW4uc3Q+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9y
YWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KPiA+ID4gLS0tDQo+ID4gDQo+ID4g
UmV2aWV3ZWQtYnk6IEFsdmluIMWgaXByYWdhIDxhbHNpQGJhbmctb2x1ZnNlbi5kaz4NCj4gPiAN
Cj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMv
Y2hpcC5jICAgfCAyICsrDQo+ID4gPiAgZHJpdmVycy9uZXQvd2lyZWxlc3MvYnJvYWRjb20vYnJj
bTgwMjExL2JyY21mbWFjL3BjaWUuYyAgIHwgOCArKysrKysrKw0KPiA+ID4gIC4uLi9uZXQvd2ly
ZWxlc3MvYnJvYWRjb20vYnJjbTgwMjExL2luY2x1ZGUvYnJjbV9od19pZHMuaCB8IDIgKysNCj4g
PiA+ICAzIGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPiA+IA0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNtZm1h
Yy9jaGlwLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZt
YWMvY2hpcC5jDQo+ID4gPiBpbmRleCAyMzI5NWZjZWIwNjIuLjMwMjYxNjZhNTZjMSAxMDA2NDQN
Cj4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2JyY204MDIxMS9icmNt
Zm1hYy9jaGlwLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2Jyb2FkY29tL2Jy
Y204MDIxMS9icmNtZm1hYy9jaGlwLmMNCj4gPiA+IEBAIC03MzMsNiArNzMzLDggQEAgc3RhdGlj
IHUzMiBicmNtZl9jaGlwX3RjbV9yYW1iYXNlKHN0cnVjdCBicmNtZl9jaGlwX3ByaXYgKmNpKQ0K
PiA+ID4gIAkJcmV0dXJuIDB4MTYwMDAwOw0KPiA+ID4gIAljYXNlIENZX0NDXzQzNzUyX0NISVBf
SUQ6DQo+ID4gPiAgCQlyZXR1cm4gMHgxNzAwMDA7DQo+ID4gPiArCWNhc2UgQlJDTV9DQ180Mzc4
X0NISVBfSUQ6DQo+ID4gPiArCQlyZXR1cm4gMHgzNTIwMDA7DQo+ID4gPiAgCWRlZmF1bHQ6DQo+
ID4gPiAgCQlicmNtZl9lcnIoInVua25vd24gY2hpcDogJXNcbiIsIGNpLT5wdWIubmFtZSk7DQo+
ID4gPiAgCQlicmVhazsNCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9i
cm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
YnJvYWRjb20vYnJjbTgwMjExL2JyY21mbWFjL3BjaWUuYw0KPiA+ID4gaW5kZXggMjY5YTUxNmFl
NjU0Li4wYzYyN2YzMzA0OWUgMTAwNjQ0DQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVz
cy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQo+ID4gPiArKysgYi9kcml2ZXJz
L25ldC93aXJlbGVzcy9icm9hZGNvbS9icmNtODAyMTEvYnJjbWZtYWMvcGNpZS5jDQo+ID4gPiBA
QCAtNTksNiArNTksNyBAQCBCUkNNRl9GV19ERUYoNDM2NUMsICJicmNtZm1hYzQzNjVjLXBjaWUi
KTsNCj4gPiA+ICBCUkNNRl9GV19ERUYoNDM2NkIsICJicmNtZm1hYzQzNjZiLXBjaWUiKTsNCj4g
PiA+ICBCUkNNRl9GV19ERUYoNDM2NkMsICJicmNtZm1hYzQzNjZjLXBjaWUiKTsNCj4gPiA+ICBC
UkNNRl9GV19ERUYoNDM3MSwgImJyY21mbWFjNDM3MS1wY2llIik7DQo+ID4gPiArQlJDTUZfRldf
Q0xNX0RFRig0Mzc4QjEsICJicmNtZm1hYzQzNzhiMS1wY2llIik7DQo+ID4gPiAgDQo+ID4gPiAg
LyogZmlybXdhcmUgY29uZmlnIGZpbGVzICovDQo+ID4gPiAgTU9EVUxFX0ZJUk1XQVJFKEJSQ01G
X0ZXX0RFRkFVTFRfUEFUSCAiYnJjbWZtYWMqLXBjaWUudHh0Iik7DQo+ID4gPiBAQCAtODgsNiAr
ODksNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IGJyY21mX2Zpcm13YXJlX21hcHBpbmcgYnJjbWZf
cGNpZV9md25hbWVzW10gPSB7DQo+ID4gPiAgCUJSQ01GX0ZXX0VOVFJZKEJSQ01fQ0NfNDM2NjRf
Q0hJUF9JRCwgMHhGRkZGRkZGMCwgNDM2NkMpLA0KPiA+ID4gIAlCUkNNRl9GV19FTlRSWShCUkNN
X0NDXzQzNjY2X0NISVBfSUQsIDB4RkZGRkZGRjAsIDQzNjZDKSwNCj4gPiA+ICAJQlJDTUZfRldf
RU5UUlkoQlJDTV9DQ180MzcxX0NISVBfSUQsIDB4RkZGRkZGRkYsIDQzNzEpLA0KPiA+ID4gKwlC
UkNNRl9GV19FTlRSWShCUkNNX0NDXzQzNzhfQ0hJUF9JRCwgMHhGRkZGRkZGRiwgNDM3OEIxKSwg
LyogMyAqLw0KPiA+IA0KPiA+IFdoYXQgaXMgLyogMyAqLz8NCj4gDQo+IEhlY3RvciBzYXlzIHRo
YXQgaXQgd2FzIG1lbnRpb25lZCBpbiB0aGUgcHJpb3IgcmV2aWV3IHJvdW5kIGFzIHdlbGwuDQo+
IEl0J3MgdGhlIHJldmlzaW9uIElELiBUaGUgbWFzayBhbGxvd3MgYWxsIElEcyBmb3IgY2hpcHMg
d2hlcmUgbm8NCj4gc3BsaXQgaGFzIGJlZW4gc2VlbiwgYnV0IGlmIGEgbmV3IG9uZSBjb21lcyB1
cCB0aGF0IGNvbW1lbnQgaXMgdGhlcmUNCj4gc28gd2Uga25vdyB3aGVyZSB0byBzcGxpdCB0aGUg
bWFzay4NCg0KQWxyaWdodCwgbWFrZXMgc2Vuc2UuIElmIHlvdSBoYXBwZW4gdG8gcmUtc3BpbiB0
aGUgc2VyaWVzIHRoZW4gaXQgd291bGQNCmJlIG5pY2UgdG8gaW5jbHVkZSB0aGlzIGluZm8gaW4g
dGhlIGNvbW1pdCBtZXNzYWdlLg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
