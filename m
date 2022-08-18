Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0764A597B2E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242620AbiHRBuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiHRBuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:50:35 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80071.outbound.protection.outlook.com [40.107.8.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41329AF98;
        Wed, 17 Aug 2022 18:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGeUIVE0Q7EawiiWgrJvvRjsab8VALUqOdwE5UFXKYUh/HkIRqBbHoF/13gE1XjRQaltDLzxZBqwM1EQ9GjvJ5dW3vI3Qf24BMj6wz+6Yw0h0S2wISuc1At22yIO/iDLCHlGTbXpXNQBLLKpJFJUuLnpAIR5yLVPN9e/13ZQ7nCvjVow0X2uo0K/14O79nNxBqO5Z5RTBdl5cE+4H+VPrRY/dpzj3cH6jeIDJDeqIaO85aKJTla5ES1eaoxtd+tEgNA2luH+PwXSSiOFu36ZxS1hD/og0MtHrGAgxbqh1iAkPLg3mAn9yxaHKM23shLoPtGfLwDDk1N/p5VAhsxlQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nw4LkKNdRjpSkyW5pdT81059/p0QpTA0ObONr0oDd8A=;
 b=c7laHLFXE5wlQzVZT24IM41dRHWhn9Uzvacj0tJLZzR3DR1o3F5JhszowOYxS5JK/CJ2HjXEXZxveTOqt6ZdYjNHKY8jYFO1VTae/BIo0PF1umTDVc88AG+lcGPBulTUNSYxuVNYD9aHwnXiggmWiVa0UFXAS39sj0EHdHuyJkN4qsQh6LsVyMdsgTNSY/1doMVelUcjlpT+bRw+B9rztYlJ0l1XwnVpP70Y6L+XujWtG0iW82BfwwVMXbffkcpPPLsMjbrv9v4uVtvia7wlWgCEbCvvKp727SmY7gZMTxdwgxJQGBaA24YZ9kRo4nwTYIe3/bvwR5D12ns94M/qNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nw4LkKNdRjpSkyW5pdT81059/p0QpTA0ObONr0oDd8A=;
 b=Pu5dg+8rTVuYlncpzetbWrfBfa34jRINGPmXLSdpM+GyPjw/djSCuCtwMoG4wbTmDpkFKQGBqeVEmOTM1nmWwi7KLjvQiMlEsvf9GmguL4L6XqgrIayWKp7ytaRELSWTtW+mS3E8o+H+yHS14/IHeHBOjnJ4/YqEvnjcF3nh6JU=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM6PR04MB5800.eurprd04.prod.outlook.com (2603:10a6:20b:a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 01:50:32 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 01:50:32 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
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
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2rT8AAgAQh61CABHNrAIAAAETwgAAGjICAAAEjYA==
Date:   Thu, 18 Aug 2022 01:50:31 +0000
Message-ID: <DB9PR04MB810645A6D88C56E27CBCC41D886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com> <YvZggGkdlAUuQ1NG@lunn.ch>
 <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2TwkThceuU+m5l@lunn.ch>
 <DB9PR04MB8106FF32F683295860D4939F886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2ZeWPTZkIlh4t2@lunn.ch>
In-Reply-To: <Yv2ZeWPTZkIlh4t2@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bee14f41-b5c1-4f20-eaa0-08da80bc08fd
x-ms-traffictypediagnostic: AM6PR04MB5800:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zhE9fYcHBQAuO4TxxvBCkhyEHicVNRsCpYsQkZfCo6uba/ArQD8gVkel7f30mlXi3lMnKq9Qju4YsAbbt77F4nACz2aY3YRNB9GnnYltdONwizyZXUHtfIM1XYTLFbM+RVx9pAAjwMMUHODfhaYUoJU9ZA4BeOGtsnnmHgDYQS5iA7b/SMXTQPeu7RAarTP0NMDLblO2t1AUrx09j6eeddYF1rtkUpTQ4MEeW5I0WsLqgbVLtbe7EUZPuWmmtx1lqsIIGVJRHFXP/IrD/hAvGMT+nScNfGOpKxn/3ZXtun8jy6AXXNy2ciTQofSGDkK5TPvOoMWuUtNZapeokEaTsOBThvk4n2R5hhs/H1gPFlp69nhy18EeWQYRPwE212QqSV8JVnqGCGZ4UIdlFCAckIj6++padX0f/ISN7BA8Zi9qrPjK7DMKmfrGQaE+JJoovZo0PTpalMBjJMT9c2pWcXMzyDyzx5Y2A3o7NBOhE5EirRvWdhC8Vgcx1dYwYizjcNaSkrfceVc4eA2ywtMOusPDgROhZeVLoFAdgzuTzVOF1Hw24BbYVn/fcu9qPAx/x4IUAR/cMrVkh9lmZCDZR1jcmWUrZCZeSET2plurZdzQ/gv7CgKub75RscdkH06mF8onLqljhAhe1cOVyWRE3cgvUbehISAPP5yMk6rLiwI7q4OqgrAj8eVAyYbYmnBusvNUijMB7L6hBwktiOT23hJSV1kjHCXd/kICsbT4cn8Q5jtswbqWIZgx4uX8IUZK4kz5ZdFqizQTBDUwLtHykw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(2906002)(8676002)(64756008)(54906003)(6916009)(76116006)(316002)(66446008)(66556008)(66476007)(5660300002)(55016003)(122000001)(7416002)(4326008)(44832011)(52536014)(8936002)(38100700002)(66946007)(6506007)(33656002)(186003)(478600001)(38070700005)(53546011)(7696005)(71200400001)(83380400001)(86362001)(41300700001)(9686003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cDZnS2dBdWNQclA4Zm5vSGJHektkTXViSUVFK2Rtc0w3Z3RyQ3RUUUxWMVhr?=
 =?gb2312?B?OTdGZEx6MmlvVEVZZjZkeDF2KzZSaGptWUdWQWh3THFCcFZ5OE9DSS84V0Nw?=
 =?gb2312?B?dWtldW91NlZ1N2hzTXZ1b0RydEJLTFVFYmFkb2g4a09ZSG5Gb3ErR2RBczFk?=
 =?gb2312?B?alZBV05zbnlUWHpHMEExSmFLZlFOY1JNYStGZnBMQUtYS1RreEtuOElzbWl3?=
 =?gb2312?B?NE1heTJBVzVxL29BUGxZSDlKb0dSUWYxejFPcmJ0MEZuelhSNGV4RXkwUWFr?=
 =?gb2312?B?ZWRsM09GbnQ4dDZ1b2JZWGFLUmZZdElQczJEWDhtam4wSkNCcXFDL1EyMTBa?=
 =?gb2312?B?MDZHaTJjS1JRWWJkQkVnYWdPSXpLTEhNK01aMGRBNDV5ZXdLTWo0VXVZQ2ZB?=
 =?gb2312?B?QUd2ejEvcFIzczZlTnJwYWpheUMwR3FOQUMwSjVXeTlSdmE2T01Ubnk2QmYy?=
 =?gb2312?B?UUZmaUtjK2FjY21pMjZiOENMUTlidjZuYkg0ZkxSbE1VRC9UMy9CSFk4anhy?=
 =?gb2312?B?R2x1Z01pMGNEeEdBWmk0Y3Rzazl3SHk4Qk9kKzlaeGpuamdpa1AvZUtlTlJN?=
 =?gb2312?B?WWxhUkxHODErSlBLZ0h1WWExcmg1QXZ1c2UzQnFBdThvYklVRTBXVE5xbXE4?=
 =?gb2312?B?RXBMR21JS3lKT20ybTFsaUhnZVFISGlrR0tnTDkxNk94N20rWUJzRjFVbWx5?=
 =?gb2312?B?L09NekNIL1lldlBaSlo2UnJ2QkVQb1pvWkZTQlJqZzVldGNiK0VjMGdUZmt2?=
 =?gb2312?B?ajMySlRMUm5vV1BMNWdZK05ZNS9pUC9zL0l0L2wxc28xWnV0WFR1TFlBUm84?=
 =?gb2312?B?SEtwZTdoYW1DanFlL2c2WU81d09rWXV3RTRoMEdnZktJeUVuTmtRb05pek03?=
 =?gb2312?B?VVltdWloYjBnNVNZWDhIMkxhNFg2Ti8wcFJtQkhxdEI1ZCtVd1FqUWFNOVNS?=
 =?gb2312?B?djRmUm5xUVFqOTErNzFVRWhOSHpLL0loV0x2V2U3eGdKKytxVUxQeHcvc3Zk?=
 =?gb2312?B?V0VEZW9nMUlDVWhwS0NGSVNRY2tHTld6UW1BaWt3ZjBYQTJ4ZDRYVk9Tc3BQ?=
 =?gb2312?B?SkNaK3NCZDZhUVdkbzBYMENkZnVBTUdlTW5JaVRvY3hsaHpxQ08zNVFWSHhw?=
 =?gb2312?B?L0NqdzgyczZLcnNKeVBsK1d3K2VrelRxbFk1N3RMZmM4OHoxZ01VakFHWDh3?=
 =?gb2312?B?MWF0dHZFQ1hhM29lTG9QQWFPRk1zYzBzTkRoS3RVaytKaFhtWmRwRnZRYith?=
 =?gb2312?B?MXlCVTN0WE44K1ZhS0FrUTQxbkxMMEFOQnVFRG9iWHBOZHVFVnZtQ0U3TGh4?=
 =?gb2312?B?aHNRV3MxUnFYKzlDUGdnWGdDdXQzeUtnOUdYdmhtd29vVmlDUFZRMHpmOTdZ?=
 =?gb2312?B?RFJyeUVZN0lidFd1Q2xPbDVHSmUvdCtiQS9FeVM3Qm5HMjFha2xtdlEza28x?=
 =?gb2312?B?ZGdNcUVvZFg5bmpGMEVBdUloRCtyd1Q3STg2dkU5U2EybWZVK05ra01jaHFC?=
 =?gb2312?B?OHVKdmFCVVUzazIzMEwyT0NwK2o3WVRycWo3L2N2WjdCeWNkejJ6SS9YNzlJ?=
 =?gb2312?B?M2crWkZIK1Y3VXhNTFE3T1VDWHFaYnplNnE0M2gzdkxqa05PR3lHUGZWTWxM?=
 =?gb2312?B?bEJTY2p6ZUthaWl5ODJVSjhYSXVBcTlKQXBZTWpIMFgrSlA5Tlg5ZVBHR1VF?=
 =?gb2312?B?VG9jNUVqQlBmcXdjR3crNHFaK0NVNnNqR2lnQkx1Nk5BZm9Gd2JvNEkraVRF?=
 =?gb2312?B?bkVITEl3QjJ0SEZkMlNHZDNpSExKc1FlWmlGMlhsMy9yR3FlQlpNbm4vakNk?=
 =?gb2312?B?a1NRR2hzS1RtTFc3enNKdDRmM3huL3Nnb0NKY3F4dTYwaFVCd3lEbERLbHFF?=
 =?gb2312?B?eHlpaFZVUWhOZ2I2c1VvQ2phejZUOUUrMWtvV0RIMG5mMFFDR1VpVnhPK1JV?=
 =?gb2312?B?ZTJSYkhYVzlDbzRZZ3U4bDhMbjJEdWxBblhidlBQT01zbDRvNFFDRGI0UUdV?=
 =?gb2312?B?QkRYV0hkK1YrMjhBOVBBSUJWandOdnlTcnNVZ1hSRldDbnpzRVEvNDBkdDJ0?=
 =?gb2312?B?cGh6enE1RHJQU3ZOVG9SdE5PdTJzai9ZYjVXd1c1YzdIS2phYWhJWklTMzdO?=
 =?gb2312?Q?VWuc=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bee14f41-b5c1-4f20-eaa0-08da80bc08fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 01:50:31.8786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sK6CDcPeqmxdO8SIM3z2kTKcfVeGXT5hhnVeQhi29mAWynEg7zysbW2/+oD6MczwU3qwfFDzF/upZS8R8t7HGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo41MIxOMjVIDk6NDQNCj4gVG86IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFy
bWxpbnV4Lm9yZy51azsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNv
bTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwu
b3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IGYuZmFpbmVsbGlAZ21haWwu
Y29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldCAxLzJdIGR0OiBhcjgwM3g6IERvY3VtZW50IGRpc2FibGUtaGliZXJuYXRpb24NCj4gcHJv
cGVydHkNCj4gDQo+ID4gWWVzLCBhZnRlciB0aGUgUEhZIGVudGVycyBoaWJlcm5hdGlvbiBtb2Rl
IHRoYXQgdGhlIFJYX0NMSyBzdG9wDQo+ID4gdGlja2luZywgYnV0IGZvciBzdG1tYWMsIGl0IGlz
IGVzc2VudGlhbCB0aGF0IFJYX0NMSyBvZiBQSFkgaXMgcHJlc2VudA0KPiA+IGZvciBzb2Z0d2Fy
ZSByZXNldCBjb21wbGV0aW9uLiBPdGhlcndpc2UsIHRoZSBzdG1tYWMgaXMgZmFpbGVkIHRvDQo+
ID4gY29tcGxldGUgdGhlIHNvZnR3YXJlIHJlc2V0IGFuZCBjYW4gbm90IGluaXQgRE1BLg0KPiAN
Cj4gU28gdGhlIFJYX0NMSyBpcyBtb3JlIHRoYW4gdGhlIHJlY292ZXJlZCBjbG9jayBmcm9tIHRo
ZSBiaXQgc3RyZWFtIG9uIHRoZQ0KPiB3aXJlLiBUaGUgUEhZIGhhcyBhIHdheSB0byBnZW5lcmF0
ZSBhIGNsb2NrIHdoZW4gdGhlcmUgaXMgbm8gYml0IHN0cmVhbT8NCj4gDQo+IFRvIG1lLCBpdCBz
b3VuZHMgbGlrZSB5b3VyIGhhcmR3YXJlIGRlc2lnbiBpcyB3cm9uZywgYW5kIGl0IHNob3VsZCBi
ZSB1c2luZyB0aGUNCj4gMjVNSHogcmVmZXJlbmNlIGNsb2NrLiBBbmQgd2hhdCB5b3UgYXJlIHBy
b3Bvc2luZyBpcyBhIHdvcmthcm91bmQgZm9yIHRoaXMNCj4gaGFyZHdhcmUgcHJvYmxlbS4NCj4g
DQo+IEFueXdheSwgaSBhZ3JlZSB3aXRoIFJ1c3NlbGwsIGEgRFQgcHJvcGVydHkgaXMgZmluZS4g
QnV0IHBsZWFzZSBtYWtlIGl0IGNsZWFyIGluDQo+IHRoZSBiaW5kaW5nIGRvY3VtZW50YXRpb24g
dGhhdCBkaXNhYmxpbmcgaGliZXJuYXRpb24gaGFzIHRoZSBzaWRlIGFmZmVjdCBvZg0KPiBrZWVw
aW5nIHRoZSBSWF9DTEsgdGlja2luZyB3aGVuIHRoZXJlIGlzIG5vIGxpbmsuIFRoYXQgaXMgcHJv
YmFibHkgd2hhdCBwZW9wbGUNCj4gd2FudCB0aGlzIGZvciwgbm90IHRvIGFjdHVhbCBkaXNhYmxl
IGhpYmVybmF0aW9uLg0KPiANCk9rLCBJIHdpbGwgcmVtb2RpZnkgdGhlIGRlc2NyaXB0aW9uIG9m
IHRoZSBwcm9wZXJ0eSB0byBtYWtlIGl0IG1vcmUgY2xlYXIsIHRoYW5rcyENCg0KPiAJQW5kcmV3
DQo=
