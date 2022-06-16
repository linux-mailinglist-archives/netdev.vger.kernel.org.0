Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445E154D931
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 06:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358596AbiFPEQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 00:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358632AbiFPEQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 00:16:06 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130043.outbound.protection.outlook.com [40.107.13.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA5759B80;
        Wed, 15 Jun 2022 21:15:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U0drbaIubAFwZzRbWz2X1OAkkZBCJRxh5+r47Bn8+N14kDWlqGPSQZ7IYEPJ+tiykxDDpda6RXuf3iRZUW7fCTd8TfUIozrAQPEYLa5F63KTA8Zf40n13c1b/RdbuPrVJMUJh+DR9r60yW1YAtLeGSRrVNONPP2mRASsrP0MueMmlwtquzLMi56gtEvufLqqBsUzP37aXieuRMJ+FL+0Pd80nAAjoiPOcuHlFs+fDqhFno5mcaBae6/FnHY4T+5PWkHFgDFEzN5fYYl8JQqRJugoZXCY5X3MA9QfTq38kkcOPpV3X5QGEvEbaSI5JB60w53UyI7ZA7vnHtaDzuhidg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T9Fnjt+bSqY+skUlIf6cQL89zHYvfHdE/kMMH2uuUrI=;
 b=nSQMQApdIHYwv7/BrLY8iRm0lClsyi8KBbuwKhX3JGWAiBnEvaXBJd/g8N49+1VYBuyCpULVNdr5Aro6kN7TvzusEKrM5LBzJX6L//z0TAYclvL8D4iStgbJFgPNBl98NqtHy1ZllIOLD4qNmQ996mFM5K7PxGtsLzpMa1biVQfeiYEQPoazpHijTkqHm5K/PHxTlq8ScKIODJjK3Ud5c+YWik++QS+ifP2S8lFOx9uCjCnLHdQl/gMMpMZ8jBNyzChamd4QtSn9NV0cg5FQyDYK2CvCg3rnFtULcPMdseH0FEregfuSbPL57b0bpiF9u1Fq/Otnqn5UpKO/4DUeGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9Fnjt+bSqY+skUlIf6cQL89zHYvfHdE/kMMH2uuUrI=;
 b=Iei3QojjMmBWw1JBTRHJMiJT3WLgGUDom1wXlM5Bl7IagnYhrqC+90ia+EOpuufhNzuK7lMoFOjOYOv8dbt51Nn+Ov4O4DT8z5Ro0aMWd30e3qxn9LqtuVaZi00Cmd58POaqGk63olv6KdXgk4OTEumxQmI3tFpZf0p8EzTZH+k=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by AS1PR04MB9406.eurprd04.prod.outlook.com (2603:10a6:20b:4da::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Thu, 16 Jun
 2022 04:15:55 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::e046:14d1:f87d:4255]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::e046:14d1:f87d:4255%5]) with mapi id 15.20.5353.013; Thu, 16 Jun 2022
 04:15:55 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "fido_max@inbox.ru" <fido_max@inbox.ru>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, "Y.B. Lu" <yangbo.lu@nxp.com>
Subject: =?gb2312?B?u9i4tDogW0VYVF0gUmU6IFtuZXRdIG5ldDogZHNhOiBmZWxpeDogdXBkYXRl?=
 =?gb2312?B?IGJhc2UgdGltZSBvZiB0aW1lLWF3YXJlIHNoYXBlciB3aGVuIGFkanVzdGlu?=
 =?gb2312?Q?g_PTP_time?=
Thread-Topic: [EXT] Re: [net] net: dsa: felix: update base time of time-aware
 shaper when adjusting PTP time
Thread-Index: AQHYgGgjQ5kS+dWa4kyjUSm6E4KQ4q1RWQ4AgAAJboA=
Date:   Thu, 16 Jun 2022 04:15:55 +0000
Message-ID: <DB8PR04MB57851DCC1C4C13FA201ECA16F0AC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20220615033610.35983-1-xiaoliang.yang_1@nxp.com>
 <20220615195820.53bae850@kernel.org>
In-Reply-To: <20220615195820.53bae850@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d518d87d-8e1b-4dfe-b5a1-08da4f4ee8d6
x-ms-traffictypediagnostic: AS1PR04MB9406:EE_
x-microsoft-antispam-prvs: <AS1PR04MB94066855D5D80BDA31225578F0AC9@AS1PR04MB9406.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u6XpLk/LbZ3UsjlzFhA7nEa8q1uFDvAUZ3FRWhi0SZuj8/cFLln4UCGoXca36/oZploGKi6Klva5A+5AKXHayosbPHUL7jLzPK4ehbZrvpo8+NLlSgkY0mLjRSliqqV1zU48PBnoYddOG+5I0otomkab6oZEJq4KlG/at4lo3U1bSoRtohHH8sL4rAJXd1uHRkhUKwnEg2g+KyGRW98aNg35ObqzZ1VyjNu6N5H7P1CUjRT77vB3fpI7/Etl9etaOtO0AW3msxT+MBpfQquk4bwFKiO2TIknYbYZH4tkX6EnF4rUl007MJi4SRgGAjyvxQ7JBaFje4+CNGycdDMJ9gS/+Smk4j4B2MiwcbBuNrqRU94rhQY9vteWGw1vL/uRnhVwMzu05961AM0Jtu+czehzYf60HtpkgK64X2x2BjeePTKrUqlTljZUQDqYthMbZYM76bao6yyvg1Zi84G5KoOTrV5JKvk4TcV/XSN/rUpsObp4fDhNL4Ui0ombg2DO8gjFtEYoO3J8lKDm76O9V7NTsAZc4JApWZY8wI6lDJApGfx+XORZSgZvs3NSH1wYaF1S/NVa1BqT2AHKigUzghUGbjEkc5lqJOiwbLr28kUsmgHb+XFq35ZVLNRhrTZrktKjo9hxjTmE3TJQP7Tg2sPN4tN56XOkW9L3pvul0JRzaKVDIiw9mqTn6Nkxq5eKW5WRLAPzPK2IW8VJFMAr4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(76116006)(55016003)(66946007)(38070700005)(5660300002)(7416002)(224303003)(71200400001)(64756008)(83380400001)(6506007)(66556008)(7696005)(122000001)(66446008)(66476007)(33656002)(4326008)(52536014)(186003)(8936002)(6916009)(86362001)(9686003)(2906002)(508600001)(316002)(54906003)(26005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Uml1UE1FRkJLQXlwTmZhRVF4NGNnRUV0ZUxyUzlNbXI3bWs2RjBSV1laUEJt?=
 =?gb2312?B?SWdTazFYWGQ5Y0xnUk9yV1VHaTl0SjFBSDBXa0RJbFQ4cTVLalhVWnkwRmE2?=
 =?gb2312?B?ZHk1Q2kzOW9VRmZNTElJVEhKcU5HYSthQ1hQR3ZaeHg2MEVIOG9qYVpYUkUr?=
 =?gb2312?B?S3dweGdsalFrak9Yci9wNFM1WGVySlpnWHdtNXh4SHFLS2hrL2tPWW42U1hh?=
 =?gb2312?B?Z0MzMjNYMzNsT2pHZW9iZUZaeDZheXZOaTNTclhEQmZicWE4clZiTUhkSTZp?=
 =?gb2312?B?Y1dHSjZOamhTL2lEdldXWGxBdlJoVDJ0S3dEWTAvMlUxSzFtQ3J2cHZGWmpz?=
 =?gb2312?B?ZkhVVTJ1b1BUUkZBaDJ4L1JkN2hta0JsSU5zWTg3eHExcGJVR0tMbDVaUGpa?=
 =?gb2312?B?WXNTR2c0M3dWaERRS0lQeUJuTmRMdzNYdmxTeEREM2JFOXpRN1hob0RkWDRu?=
 =?gb2312?B?TFA3S0hOcFdIWkV6RFlIRUN0U08rUFdlejV1eFRZKzduekEzcmZCZ1B6SmI3?=
 =?gb2312?B?WjY0akw0Y1RsOTA1K2VmMlRndkxtMUNLOWI5R2I2dXhpZmVRNXZvR1lQbU02?=
 =?gb2312?B?cERXMjBoamlZcTNoeDdGQktvRGlTTEU3ajlkOVc5OVFVYWZWYk1EUkZ4dnBu?=
 =?gb2312?B?aktvK3VFcnRMYWVhT3NjNkpGbXhMaTF4Y1V3RUg3amp1aG5kUVdqWUhJd2lE?=
 =?gb2312?B?WExTTXZXTWhyNXdyOUs4OGJzWTdER0dWVHgwaURlSTYySGdzK280M2F0bzBo?=
 =?gb2312?B?TGpGcGF1Mm01ZlltcFlPUk5kZTBSNTNOSzlFaG9pSTVNWEZ0NG9iZC93dWJL?=
 =?gb2312?B?NGc4bXltQnA0SGxNNm5hUG9QZkZqc2FSL044NjJGN0xEZEEwWGx3anlrWE5n?=
 =?gb2312?B?a2cyQW1TSlRGZ0xTc3V5UDBZRnhGNFB4QjRsaTRFTGxYWUI4ZEhEd2N6ZzZy?=
 =?gb2312?B?RTlmZEhoVmM3VjczNkxqWWpzbThBMGZwSFA1NnBHTHpyZHhobjcyS3Z1cVpk?=
 =?gb2312?B?cG1mMkg3S0lzZURxTnF0bTE4eXcyOEJ6aDgwZlA3cVFZY1A0UG9kT1dlV3Vh?=
 =?gb2312?B?MHpsZnNZellLZ0dzTDhlMnphMVpUTEFnL1U0MjRFNDFTSEdhSlVoSUdSaUtu?=
 =?gb2312?B?YXdyZzcxN3V4SXYrR2pSekpSS3BuMk9mV1c1Zi9oQ2RBMnkvN24xVG1qWHFE?=
 =?gb2312?B?WlhIUmZVc2UwV2hDOUpEWE40bi9MeTVUR3FQSEtkOThnQU5sdHh4YklnNlE0?=
 =?gb2312?B?QnYvZ01ZNlY4MXZPZHpxdE5ORERKdnByaS80Um9mcEtiRjVBSXRCOVZlUnlP?=
 =?gb2312?B?Y01TMEh3YU9xWUU3ajBQTUdTUnI1UkJ3YjR0YWh0enBtd1puT2ZVYkg4STMz?=
 =?gb2312?B?Q2tuS0NsTHNEOTltTjVBWHZ3NEJXUVBnVXo2TXFQZndGWGUxSThPZXd6dUtY?=
 =?gb2312?B?WGVwVEV1L25FcGRMQnpjdVRtNGpDQW94bHRsOFFyK0wrWlB0MUtMa1pSU2hS?=
 =?gb2312?B?QjlqNlNaTUk3cVRRdVJ0R3djZXF2VXNTNEo5THdyNjNlY3BxeUk3aER3ZVJV?=
 =?gb2312?B?OFRiZ1FnWWtOd2JaSjg3dWxZMzd2VWI0V2JuNnR5WGQybzVPbThTU21USDZp?=
 =?gb2312?B?bWRmbGtmQ01ZWHVxY28rZEFHQndrc1pXWDgvQTRJUXhiMXQ4NGZlZ3NlMlZI?=
 =?gb2312?B?VDhjbDlJZnVjVEJKYnpjVGtSakt3R203SE1KM3JabDhwNVJOeTVZVE1oNDVu?=
 =?gb2312?B?VmRqNzQxTlZabnhvdzBxamxxTFByTXlKaGxJTVZzZnI5aGxXVmpSb2xXQXo5?=
 =?gb2312?B?TUxRR25yZVR5QmRzcFpXNjBFT25IalNOUStscXlsZllxZDQwNkw2eVpvV1J2?=
 =?gb2312?B?S1hBRlZPZWZzMGJNMzRPL0ZtaW5qeVFzNVJ0UGxvYmFQV2RoWlF3bm0vaUgz?=
 =?gb2312?B?QXNKTEF0N1d0bUJhWklTT2hCeDVQMm1nWktNTzcvcmZIT25hbWtkTERzTm4x?=
 =?gb2312?B?NTBzQTM4OG5XNEduM0M0UXdtRDdIQW5XaXQ4N3ZSaVduSnVuMVdmd29hRFVP?=
 =?gb2312?B?OVdCZll5b01NZzVmbTgzL2xTZ0IzcUJrTVNSZjhRSGlHaHVOdzRZSTdiODRT?=
 =?gb2312?B?MlBnSWtJZVBrMG1VN3lpZDJEQTlPeVUzLzdkWVpkM0pqVGhlaVFFMkgydi9v?=
 =?gb2312?B?MHY1TzBWb1hsZ1E2aWhlMGprRjMyQzNhOFFuN1lyYzltSXR2MCt3RTQ5NG9X?=
 =?gb2312?B?MWNZM3gwT1NCblJ2UTVXTVJIR0RRd0VMM0FZN05Bd1lXaW9CRmg4TFZpb1VO?=
 =?gb2312?B?Z0hRWTczNHlhU25ibEEvTU9WZkNqcE53WHk4dDR4M2xlMEJNYUw4QT09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d518d87d-8e1b-4dfe-b5a1-08da4f4ee8d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2022 04:15:55.8618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RV505z/ag8SvKjRJ7HQ0QU4DAhXhNUhvMYBK07QNdMuZG4Oy8bBc1wXRKC/Y8jlD5y8por2WgkEiH3RB00NtXpHz511BFLy7ieWqsJ7qzrk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9406
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAxNiBKdW4gMjAyMiAxMDo1OToxMCArMDgwMCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAxNSBKdW4gMjAyMiAxMTozNjoxMCArMDgwMCBYaWFvbGlhbmcgWWFuZyB3cm90
ZToNCj4gPiBXaGVuIGFkanVzdGluZyB0aGUgUFRQIGNsb2NrLCB0aGUgYmFzZSB0aW1lIG9mIHRo
ZSBUQVMgY29uZmlndXJhdGlvbg0KPiA+IHdpbGwgYmVjb21lIHVucmVsaWFibGUuIFdlIG5lZWQg
cmVzZXQgdGhlIFRBUyBjb25maWd1cmF0aW9uIGJ5IHVzaW5nIGENCj4gPiBuZXcgYmFzZSB0aW1l
Lg0KPiA+DQo+ID4gRm9yIGV4YW1wbGUsIGlmIHRoZSBkcml2ZXIgZ2V0cyBhIGJhc2UgdGltZSAw
IG9mIFFidiBjb25maWd1cmF0aW9uDQo+ID4gZnJvbSB1c2VyLCBhbmQgY3VycmVudCB0aW1lIGlz
IDIwMDAwLiBUaGUgZHJpdmVyIHdpbGwgc2V0IHRoZSBUQVMgYmFzZQ0KPiA+IHRpbWUgdG8gYmUg
MjAwMDAuIEFmdGVyIHRoZSBQVFAgY2xvY2sgYWRqdXN0bWVudCwgdGhlIGN1cnJlbnQgdGltZQ0K
PiA+IGJlY29tZXMgMTAwMDAuIElmIHRoZSBUQVMgYmFzZSB0aW1lIGlzIHN0aWxsIDIwMDAwLCBp
dCB3aWxsIGJlIGENCj4gPiBmdXR1cmUgdGltZSwgYW5kIFRBUyBlbnRyeSBsaXN0IHdpbGwgc3Rv
cCBydW5uaW5nLiBBbm90aGVyIGV4YW1wbGUsIGlmDQo+ID4gdGhlIGN1cnJlbnQgdGltZSBiZWNv
bWVzIHRvIGJlIDEwMDAwMDAwIGFmdGVyIFBUUCBjbG9jayBhZGp1c3QsIGENCj4gPiBsYXJnZSB0
aW1lIG9mZnNldCBjYW4gY2F1c2UgdGhlIGhhcmR3YXJlIHRvIGhhbmcuDQo+ID4NCj4gPiBUaGlz
IHBhdGNoIGludHJvZHVjZXMgYSB0YXNfY2xvY2tfYWRqdXN0KCkgZnVuY3Rpb24gdG8gcmVzZXQg
dGhlIFRBUw0KPiA+IG1vZHVsZSBieSB1c2luZyBhIG5ldyBiYXNlIHRpbWUgYWZ0ZXIgdGhlIFBU
UCBjbG9jayBhZGp1c3RtZW50LiBUaGlzDQo+ID4gY2FuIGF2b2lkIGlzc3VlcyBhYm92ZS4NCj4g
Pg0KPiA+IER1ZSB0byBQVFAgY2xvY2sgYWRqdXN0bWVudCBjYW4gb2NjdXIgYXQgYW55IHRpbWUs
IGl0IG1heSBjb25mbGljdA0KPiA+IHdpdGggdGhlIFRBUyBjb25maWd1cmF0aW9uLiBXZSBpbnRy
b2R1Y2UgYSBuZXcgVEFTIGxvY2sgdG8gc2VyaWFsaXplDQo+ID4gdGhlIGFjY2VzcyB0byB0aGUg
VEFTIHJlZ2lzdGVycy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFhpYW9saWFuZyBZYW5nIDx4
aWFvbGlhbmcueWFuZ18xQG54cC5jb20+DQo+IA0KPiBZb3UgbWlzc2VkIHNvbWUgQ0NzICguL3Nj
cmlwdHMvZ2V0X21haW50YWluZXIucGwpIGFuZCB0aGVyZSBuZWVkcyB0byBiZSBhDQo+IEZpeGVz
IHRhZyBpZiB5b3UncmUgdGFyZ2V0aW5nIG5ldC4NClRoYW5rcywgSSB3aWxsIGNoZWNrIHRoZSBt
YWludGFpbmVycyBsaXN0IGFuZCBhZGQgdGhlbS4gVGhpcyBwYXRjaCBhZGRzIGEgbmV3DQpmdW5j
dGlvbiB0aGF0IHJlY29uZmlndXJlIHRoZSBiYXNldGltZSBvZiBUQVMgdG8gc3VwcG9ydCB0aGUg
UFRQIGNsb2NrDQphZGp1c3RtZW50IGNhc2UuIEl0IHNlZW1zIG5vdCBhbiBvYnZpb3VzIGJ1ZyBm
aXggcGF0Y2gsIG1heWJlIGl0J3MgYmV0dGVyIHRvDQpzZW5kIGl0IHRvIG5ldC1uZXh0Lg0K
