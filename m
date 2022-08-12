Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A29B590DDB
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 11:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiHLJCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 05:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiHLJCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 05:02:23 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBE0A98DB;
        Fri, 12 Aug 2022 02:02:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BW+IQvccxijOc9C4JcnLCPd+2zrKPd9YuUX3qOucWXzSsePR9MFYyqyWZO5NyLzQJdf6hUpqO+GD8R7iDW40M2ROzMsGJtE5ALB5DqCNdAG4wpWTwBAGIKMzP1tDg4iAeFmSvEcPDIuDNhYFYVZqAkgwlDIwLBvxQLRlCCyQ7H1CVee7WudYlgaeeJTlNGNU6LgUFAypf53Xhtn9oOW4epCSh1Nh7ss2Y+RC498E5f7Jc0fZ7chO5VdGoXaCtfgqvwNf+n6daeylJHHWArtc+y6a0DbxyUJYOiyzYIm3422HRvXGCVEs/3GPx/bYC+MQ73IzH949R6e+nx3iwQw04Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2/s1rmmVJTYIzOLAUsge1BBtiSPEfW4yeTK5zDQQFw=;
 b=LjqFDyq2nw0icQs4b9qpCpeGHEFS5MPXV6hdL60C/wNFSMHLeO6/bmssXY1duaNv7wBewZuylC5w7SCNxXG1Ew8L/6T27kRs2tDvH7L9Nu35hw/xCU3sfsW2Koo1PZ5LzStaNw06CEIlbg4GdsIp0B1O4fmo74wk3W5b9UoPgwB/SQUVucjkNFbJO7+ta/Ri3G+7+wdUUPUN1VpLBkdh6jnDIdpKjVldGZ8RpfZrYLORMIBjTfTdQbqlelsyiU9NkOcAuxI4euVY5R2EymuJAjQAmAYOyFUYoTNvuT8En8C3BeMVH+W7Tl9mnsI0muiwayLzuFtbHlPIzdEbPdeXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2/s1rmmVJTYIzOLAUsge1BBtiSPEfW4yeTK5zDQQFw=;
 b=Ra45/GKqqE0p9An/xS6Gm9hjcc5WCAMd+FLAi9rsqaXqMyMqUKw30lSf+76IjyhpEX1Ti6AoUmBGgbFFu8ZDFAz7g2XI1qOVrWbwp211y1DMYBEnVXGEf/ogVPTR9msNGJkwp6vOedn1vBU1XsLfXtoCYE6blo2dADlAVtVX5Zo=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR04MB4040.eurprd04.prod.outlook.com (2603:10a6:209:50::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Fri, 12 Aug
 2022 09:02:18 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Fri, 12 Aug 2022
 09:02:18 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Thread-Topic: [PATCH net 1/2] dt: ar803x: Document disable-hibernation
 property
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2q3dcAgAAUXIA=
Date:   Fri, 12 Aug 2022 09:02:18 +0000
Message-ID: <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
In-Reply-To: <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 297b5cff-14df-4576-de39-08da7c415c1b
x-ms-traffictypediagnostic: AM6PR04MB4040:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: haaSzgPtnRHSOkTtecrNpTqLHzE+91LrEvEGYxntgA/m96unLLTYkKNjTsl4tCOGDmfKxmD/YhbuRjzTCsOx8bznTlBNdIrsHK55qVKlb9dZ/xnh9K0xA2NnYLOM+dWWsMTJtoChuIpbXjAMBngcxMbQl05edS4pfxX8cgje0HN2afQdBogL5GgpzVc8Gde1g8sQCZznPMs3jHqrsnXQQFKh8ADPTFfoJ9rQy0P6Q367IdaI3vwqqlRT8MT+H0+DMcAHumHbwsd00ZVMv5993bXAB/4DdtOR3APQ+0iXtguNKZKqSE8IyCc+fANjjdHiYxBkeF04tCN7Ms+32c24Fo2ZMfA/cXz2bc8QWnxEmNrLDOgZgj1XYKdZWJi8YutszbSkYBNLaR/eybB0OWTiHP8JNVJL9tgK1PO14VkciRfRGK25QXfOr/7ppRqGfvoVawotizsYnA8eRWzmOu1Uv9xRLu6rLI9U0mBClS45fQhHmaP4eyj7W2ukpzHPUQxU+KJGcg87WP3bNnxUh/LBHQbfy0Sndpes2LQo5iFvqwdSxrc003+scFr/xhi1bawAFuGHb0H+picCmV8u01WE8HWJg0rS8Op7hbj1IT+Kpxs0+rnCSE2rN/ywkjs0avHgMQtkxLhFfweHUw5/ZxuazOoI5OH10+YGVVSSeoOpNXndLP+LCS1eCIicMQKbxGegpmKjfxNmYZD7Pe2GWeQMKoCuoh3Y5bl86FJmZOkQDyQarhgDDdaaCIKYTHJXKpmlUCSsui6ufk6dpc8SyJq8+YQhOqbXfUv5u1obkazYWJljiyxjMQruz5jGSZfREruV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(83380400001)(5660300002)(7416002)(44832011)(7696005)(478600001)(53546011)(6506007)(26005)(33656002)(186003)(9686003)(41300700001)(66946007)(66476007)(66446008)(76116006)(86362001)(66556008)(2906002)(38100700002)(122000001)(8676002)(64756008)(71200400001)(316002)(110136005)(921005)(55016003)(52536014)(8936002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTJjbENsTmJKMFBkbnMwWlFWOXBzdGFhd3hzbVVINGxHWlVENHZ4WXg3bGhI?=
 =?utf-8?B?MXFWQTVzbUlyczZrakRHb2VDMm0wdUY0Z1BBRlZFSDhheU1EdmRjZVVnOTZT?=
 =?utf-8?B?T0JDK0NBSGdjQkg0amJmaEQ5ZDRybGFzc1RVQWR2L1FDNWl3cU9iSWYxbTFy?=
 =?utf-8?B?OGhJU0plait6MUxPMjVWSlViaWwwMzRxRzM5TnZYZHZlbVg0VjM5OWVKK0o4?=
 =?utf-8?B?VzFmbWJpOUdBUldxbk1aekF4NTNNRTVzeWJNU2xRRWpBV243RFhJeXBETzlO?=
 =?utf-8?B?Y2hnS2NXU3pJcExtL2diOURiMWFyaVlhZ3YwTFdWTjJUN01YRU0yamZkRC9G?=
 =?utf-8?B?TjR4UE9Nb294UE9hckRYOTlsV2s3cEIzdlJIRkJtWFNiUVNoZTRDZTAxbHVs?=
 =?utf-8?B?TFQxRWNQbS9ycWNBc2c1dWdxSXFLUmVPRnlWZ2p5bWF4bGltcVhEV1BsZ0Qy?=
 =?utf-8?B?MkRrS1hORSsrMllRK09qZmtJem1qNXZrWmgzVmJ0WUxjblZheGJxKzdZTGRN?=
 =?utf-8?B?UnVQUmpmckdwTnVSTlRsRUlTODVpNHBDZ1JmZ1FXK0YweEdnTkZsbWZuY3pI?=
 =?utf-8?B?SnBtNVVDYTRzN09lWkdqS0tvOXpIK1VvdUZJNlJPZlFXTW1ZeFZDb1VnVnI0?=
 =?utf-8?B?bHJSK2NPK2V5Tm9UbWZ2YjNBRmVuNk1nQWx2VlFscWFNR0Y4WG9YZ0tVSlhL?=
 =?utf-8?B?R3Z1QVk1d2FkNlFoOXU2N2JaazVlRUlSZ2x6dlhPdGRFVTAySkJqeXlHWTBs?=
 =?utf-8?B?V2Y5RUk4ZGJOWVpWLzliR1lIWC9ZOVpSMDdOd3BKeE1vaDRFNW9QcFlaNCto?=
 =?utf-8?B?VTdXSGlDZGFWdjR6M3Bxb0dEakdYYzJocXREMFp5MUJlbjRGQVpQamNGTXly?=
 =?utf-8?B?YnU5d0xUL0JnbEhkNVM3TWc3ZXk2bUc2bk5IT1hrNVI4MDBXQWU1Y0plcmUr?=
 =?utf-8?B?L3l1d3FiV0REZUFOSXVqTmFXT2JKSmlQZ1J0OWdlRTdYdVRBNlFrNGk1RDRO?=
 =?utf-8?B?R21IelUzUGVoQXJtcGRUeldlT2hhSUYyanc0Q3lHUW1YaWtoZncrUFFsenc1?=
 =?utf-8?B?NVI2YXRveDFsMllod1BKL1dJL2VqczI1dWJnbVJPZ0lNckF1SnlSZVpuQzJy?=
 =?utf-8?B?YlYxc0RNU3l5K0hEd3pJaWxyRGIwYTFHQ2JoT0pQZkZmN1NoTXJmTFc3ZGw2?=
 =?utf-8?B?SnNGdzlWNk5ETnhxemlNUGdyZWc2UklVeTNvb0R4QURTcjZOZ2VrUER0UTU3?=
 =?utf-8?B?cmhldTBoWVhHMGQ3cGlhOWgyd051ODNqSjFqd1ZHR29VMmJIV0VZeElYMjVy?=
 =?utf-8?B?NHFidzdqM1J2MjJPWlJGVHcvdTBSUUo0NzhpNDJmcHdLRUx4ZHJHTUNham9k?=
 =?utf-8?B?WndZZmNYNVBhdHpISUQ1dzRIeUlJanlVdVJRYllSWFJJeFFVUE1VUklmUjdG?=
 =?utf-8?B?eE85c3M3Qk5XOER1THZrYjcycllUTlZGMU9ybG9hZkxGbWp2T0dJZVBobW9u?=
 =?utf-8?B?YVJUdTV4RXdhKzZnTTZsamFvSHRZYlFidWZjY0R4YVc1SW45UkY0akdkeUZ4?=
 =?utf-8?B?RGZXUEpsWFJVaXlOVHdDMGMzc2hORU5xTXN5REUxL0pVYURkQW9hMXoxVVJi?=
 =?utf-8?B?a1hTd0s1cnpOYWV3R1BpUVdNckpIMW9SbHNLMVhDdG5Kd2NYeUttV0hRNGVq?=
 =?utf-8?B?eFliMllHcm5FK1ZrQjZqT0p6dVhITnNKaU0yTTJ2S1NsVmVTVlVlakc1czFI?=
 =?utf-8?B?QUtCYzZYQkxyUXRkdW9aYXgxZ01yZllMNkpBbEd5dXcrLytlWDhnQWxUT3dE?=
 =?utf-8?B?dFFhRmFETmFVNmpCWHVqNDNRdTZsRWhpZGJnTDRCblZ2b1BxcDBuM0dRVEUz?=
 =?utf-8?B?UDNDM0ZFWjdWUCtJekg4S3pkS3dJZkliVHlyWWo1VGMwY214Rm1xcVVoWXNB?=
 =?utf-8?B?cXBXbkRISzdHdThBZTZRNHZMSnBiVWcyY1V3eUFOclo1L2wxL2RYQS9zYmJ0?=
 =?utf-8?B?OW94NDROaEVlYVROUlkxblJnYzBuLzd3enlZTm5aTFdvbUNIWkN3MTBBbTlk?=
 =?utf-8?B?b1NDa1YzZEV6ZzZNUzgxWHpFMjc4bFhydXVMaFBqT3loZ0dVdFYzUDR2VWxL?=
 =?utf-8?Q?2P1w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297b5cff-14df-4576-de39-08da7c415c1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2022 09:02:18.6082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: APoJo1e4rGahD8QKpurW12iKOfFZYuLr4XFpXalSo8YZ44Su2km8XIiSmWHxQJoKXWdXhmqlWxTz1wVvZSCBnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiAyMDIy5bm0OOac
iDEy5pelIDE1OjI4DQo+IFRvOiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT47IGFuZHJld0Bs
dW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsNCj4gbGludXhAYXJtbGludXgub3JnLnVrOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBrdWJhQGtlcm5lbC5v
cmc7IHBhYmVuaUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7DQo+IGtyenlzenRvZi5r
b3psb3dza2krZHRAbGluYXJvLm9yZzsgZi5mYWluZWxsaUBnbWFpbC5jb207DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IDEvMl0gZHQ6IGFy
ODAzeDogRG9jdW1lbnQgZGlzYWJsZS1oaWJlcm5hdGlvbg0KPiBwcm9wZXJ0eQ0KPiANCj4gT24g
MTIvMDgvMjAyMiAxNzo1MCwgd2VpLmZhbmdAbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBXZWkg
RmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPg0KPiANCj4gUGxlYXNlIHVzZSBzdWJqZWN0IHBy
ZWZpeCBtYXRjaGluZyBzdWJzeXN0ZW0uDQo+IA0KT2ssIEknbGwgYWRkIHRoZSBzdWJqZWN0IHBy
ZWZpeC4NCg0KPiA+IFRoZSBoaWJlcm5hdGlvbiBtb2RlIG9mIEF0aGVyb3MgQVI4MDN4IFBIWXMg
aXMgZGVmYXVsdCBlbmFibGVkLg0KPiA+IFdoZW4gdGhlIGNhYmxlIGlzIHVucGx1Z2dlZCwgdGhl
IFBIWSB3aWxsIGVudGVyIGhpYmVybmF0aW9uIG1vZGUgYW5kDQo+ID4gdGhlIFBIWSBjbG9jayBk
b2VzIGRvd24uIEZvciBzb21lIE1BQ3MsIGl0IG5lZWRzIHRoZSBjbG9jayB0byBzdXBwb3J0DQo+
ID4gaXQncyBsb2dpYy4gRm9yIGluc3RhbmNlLCBzdG1tYWMgbmVlZHMgdGhlIFBIWSBpbnB1dHMg
Y2xvY2sgaXMgcHJlc2VudA0KPiA+IGZvciBzb2Z0d2FyZSByZXNldCBjb21wbGV0aW9uLiBUaGVy
ZWZvcmUsIEl0IGlzIHJlYXNvbmFibGUgdG8gYWRkIGEgRFQNCj4gPiBwcm9wZXJ0eSB0byBkaXNh
YmxlIGhpYmVybmF0aW9uIG1vZGUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8
d2VpLmZhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiAgRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVl
L2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwgfCA2ICsrKysrKw0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgNiBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwNCj4gPiBiL0RvY3VtZW50
YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvcWNhLGFyODAzeC55YW1sDQo+ID4gaW5kZXgg
YjNkNDAxM2I3Y2E2Li5kMDg0MzFkNzliODMgMTAwNjQ0DQo+ID4gLS0tIGEvRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9xY2EsYXI4MDN4LnlhbWwNCj4gPiArKysgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3FjYSxhcjgwM3gueWFtbA0KPiA+IEBA
IC00MCw2ICs0MCwxMiBAQCBwcm9wZXJ0aWVzOg0KPiA+ICAgICAgICBPbmx5IHN1cHBvcnRlZCBv
biB0aGUgQVI4MDMxLg0KPiA+ICAgICAgdHlwZTogYm9vbGVhbg0KPiA+DQo+ID4gKyAgcWNhLGRp
c2FibGUtaGliZXJuYXRpb246DQo+ID4gKyAgICBkZXNjcmlwdGlvbjogfA0KPiA+ICsgICAgSWYg
c2V0LCB0aGUgUEhZIHdpbGwgbm90IGVudGVyIGhpYmVybmF0aW9uIG1vZGUgd2hlbiB0aGUgY2Fi
bGUgaXMNCj4gPiArICAgIHVucGx1Z2dlZC4NCj4gDQo+IFdyb25nIGluZGVudGF0aW9uLiBEaWQg
eW91IHRlc3QgdGhlIGJpbmRpbmdzPw0KPiANClNvcnJ5LCBJIGp1c3QgY2hlY2tlZCB0aGUgcGF0
Y2ggYW5kIGZvcmdvdCB0byBjaGVjayB0aGUgZHQtYmluZGluZ3MuDQoNCj4gVW5mb3J0dW5hdGVs
eSB0aGUgcHJvcGVydHkgZGVzY3JpYmVzIGRyaXZlciBiZWhhdmlvciBub3QgaGFyZHdhcmUsIHNv
IGl0IGlzIG5vdA0KPiBzdWl0YWJsZSBmb3IgRFQuIEluc3RlYWQgZGVzY3JpYmUgdGhlIGhhcmR3
YXJlDQo+IGNoYXJhY3RlcmlzdGljcy9mZWF0dXJlcy9idWdzL2NvbnN0cmFpbnRzLiBOb3QgZHJp
dmVyIGJlaGF2aW9yLiBCb3RoIGluIHByb3BlcnR5DQo+IG5hbWUgYW5kIHByb3BlcnR5IGRlc2Ny
aXB0aW9uLg0KPiANClRoYW5rcyBmb3IgeW91ciByZXZpZXcgYW5kIGZlZWRiYWNrLiBBY3R1YWxs
eSwgdGhlIGhpYmVybmF0aW9uIG1vZGUgaXMgYSBmZWF0dXJlIG9mIGhhcmR3YXJlLCBJIHdpbGwg
bW9kaWZ5IHRoZSBwcm9wZXJ0eSBuYW1lIGFuZCBkZXNjcmlwdGlvbiB0byBiZSBtb3JlIGluIGxp
bmUgd2l0aCB0aGUgcmVxdWlyZW1lbnRzIG9mIHRoZSBEVCBwcm9wZXJ0eS4gDQoNCj4gQmVzdCBy
ZWdhcmRzLA0KPiBLcnp5c3p0b2YNCg==
