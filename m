Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB2F597B16
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 03:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242207AbiHRB3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 21:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbiHRB3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 21:29:22 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2062.outbound.protection.outlook.com [40.107.21.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49B4A0611;
        Wed, 17 Aug 2022 18:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3E66lzU7BU1oqEsPauhqV60hgVfIwPqRrrAx8DL5wn5hagmctSji4WzJiX+UXiJO1M7BR8MpdK119iEnMb1RcOpineGsNaun+bofJCJw6IzRmTtVu/xWdTJDIXKHpFliIFTJwH7o4wiOBhI4iheBTA7zPSEIQjC3aEtL0Qgsp6dCBhzzqHxXAe/LlCz5GiuPA521N0OVGtMfedNq75tFmtOnGkP6Pz6zl7tmc6+iqMfmNXp3/LS+PwikNsT0SxkbCTvLXOPhgozQHlg5pC536SsWxP/pJGlX824uXPI/DT6hOVhQd0mwA4UsfI51MYSQ5mlp3HxWCPuIwEUoQIs2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6g7PO4prRhhyFgCyXxfReu7MsLSCfT/OxsFFkj8vt+Y=;
 b=c9U5VYUEiKfedZgA2QVptmGVeuvS4TiWOd7gSNGzpET5l2HW0g11YUeN5fjhNJjenfbQWQWUdxSpinbNsx3k4/raEq5UxFgHpHGZ4xUDSC5lOYNiVMPiLXgFClZJ/TG+uWkH1oAIPz4FnNSG2OOT4Y1bRo29iKTVlZCBPBVUwVQNIo2ob5lXeD4cqAm2Tup2b0bXYQ7BtW/dN+PJPMzq/Vap3UXycOGIGke5WBWxZKx2bopLzi4bYOYLR1f8jjKgqoqOQu4p+rc4NjOpJM+PqzHelo+5mkvkaJIa7WuKqrx0jGeJfu6B1qb7ZPO+522GTYatKc7ROw8LwgOrP8Nbqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6g7PO4prRhhyFgCyXxfReu7MsLSCfT/OxsFFkj8vt+Y=;
 b=fI2wV4xA8qhovVolRCgpHyDRs4vis9Dps0K1OTNSi40CEr/vCytXB0HmmTzrEhaxw2Tv5rF0Vj8A6zLTT+FfpFc1Min+j5A6t9LqKsgxA1UhTqi3AzQFCE4fjihwYDUjD8ByMzIFi5xZevyMRlORrPVGwbRtjYBrst+irvcQGiY=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PAXPR04MB8974.eurprd04.prod.outlook.com (2603:10a6:102:20d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 01:29:18 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Thu, 18 Aug 2022
 01:29:18 +0000
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
Thread-Index: AQHYrhiZCawC+L8jOkCFO9wn08ratK2rT8AAgAQh61CABHNrAIAAAETw
Date:   Thu, 18 Aug 2022 01:29:18 +0000
Message-ID: <DB9PR04MB8106FF32F683295860D4939F886D9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com> <YvZggGkdlAUuQ1NG@lunn.ch>
 <DB9PR04MB8106F2BFD8150A1C76669F9C88689@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <Yv2TwkThceuU+m5l@lunn.ch>
In-Reply-To: <Yv2TwkThceuU+m5l@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2421b636-c374-4c0e-7a2b-08da80b911d3
x-ms-traffictypediagnostic: PAXPR04MB8974:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hSZRSDU5VUopy/yEk02Xpfhvg1rMSu6SOfGxYSTMP32dGUV2gZzOn8PcjEn9wFzkVvQDQdlgkuHPRhkz0iuZoKAEC0QCpDKGHR/BEJhJXMZlb3hoF9jGz2RSDwxaekwV+87KaARexSc0sF0jZtqXoG4g1QPnOZkuDRtIHDAs8pqtvM7elFjdpo0wdQPFJe8QSbrtMOE6MQ/UKxSby6wbuT7iCn3wOaetSvPzTjvvSFkrg0gVr/ZxlQZpDfUPBCxpRx5+AbXisli0K/0dl+06sgoyZr/Hn6fBDREwZgv/WRzSpSamGvaz9r6ZYsPLe0QMVn0bP+rkWd4bJQ3tyixwC+NCQU4R1b9LGbubpUNz/xmZBtDy11pvX1WLS/IcnPULrpKh1nzn3slKj61DT0XaB15GJ7i45sA3H5TQWSknPMZOR1QI9n5yW/FUyiqCjw0+CV1D0NX8KHVk7FLmoa41OYiCSWISgsAQ63pVKisYENqu5InjFgY1p6Z5BhNyGSMP8GBYKijZdp83s1bmg46cK0uAkD6byfookxfo1LdqLu96CQZpkPc780TrjxgTxalrtkdRFfZbcs41YqqajalhfyTYZWYaSycff+4haibXAyvAttD2wpT3qTDNdXI/I0yqBmZyTP8iOtDDc++ga0Qtl5RF3zc5bKAzZjK5Ut0uONdMuTjB6Tvizif2T0a3r7rjDTjW804RPAr4MeywSlf/UOtQHw6+wrLF+jORZHzBHYHASwJ5RuLVofLWDCtCmp3ZXw1bpVfyj1EbTuJFunXsFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(366004)(39860400002)(396003)(346002)(6916009)(54906003)(316002)(478600001)(41300700001)(55016003)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(4326008)(8676002)(44832011)(2906002)(52536014)(7416002)(5660300002)(8936002)(122000001)(71200400001)(38100700002)(33656002)(86362001)(38070700005)(186003)(6506007)(53546011)(9686003)(7696005)(26005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?bWtUeDFwR3JVb1kzaVFlTTBlbWZQWlE4K1pZK296TFVGSUYvNDJ6QW0yTU16?=
 =?gb2312?B?UnR4NjRpdFV4WEhHRHNUTVVtdmEvTkM5WStFaHFhUEhUNDNUUEx3a0Iydm0v?=
 =?gb2312?B?b2YxV0xBUUFtZTV1RTN4aWxhcnlTUk1xazJ5em5CMXJ0TW1LSmJNRTFkZUdB?=
 =?gb2312?B?SmNHS0NqMDhiSzN2STJZVVZLdjEvcGNYOVQvY1FmUkdVNDY4V0lITkc4dGpL?=
 =?gb2312?B?Rm1tY092QmRWNUpQMXBUSW9Lem41SEREUlNnSmNFb3BJWmtpN0NrZzJnRnNQ?=
 =?gb2312?B?OFAwVkJid2tBWVV0V3JMVnlCOS9JVTkwZFd4MHRheG5DbDlyZFBybmV1Tk1F?=
 =?gb2312?B?NVRQaGw4dDd0Sytmei9SWk5tS05YSFlLY1FHa0tWSFdHTGNkZGNtNCsvK1FZ?=
 =?gb2312?B?eDRtUllzaGhVbEE3a080K3p6bC90aG5XTVhUQnRLdEx1V2NvT2pvWlM2RUtU?=
 =?gb2312?B?TGtyckZvTTdEbWUzdEQ2RFluOXQyaVRTMThtNFJiL01uQllhMm1sVUlGT3hm?=
 =?gb2312?B?WTZQRWl1aWVrbkVQN1BEaktZc0hma1Q2TE5Hc3JJVTJGREZFZVdKNjFvSGdL?=
 =?gb2312?B?UU5YL1BWcThkemw1MVN2Nkp1c01qZ2gvOVdFZ2RLQmQ5OWNIV0hsWEdEN1I4?=
 =?gb2312?B?SXJkL2hCYkdSQjVLL1hHRy9CNmNCL1FGMmlyRHQ4TEtQdFRYRnJmNUcwRGxo?=
 =?gb2312?B?N3I0TnRIZ3NpTTNNTjlzVzUvTTZWN3ljeHNZTndNd1R5VlZ4c3BBVlNvbjB2?=
 =?gb2312?B?dUpiN1N5QjNtTWVleGZlK3dyZnBrMGhsTSsyZThFTUpLTVlFUVBuMXlleVZJ?=
 =?gb2312?B?aWVQazJHdXF6OEQ3S21hREp0Wm9DcGVDczJ2UnhxdTBGRGhTSVNzVC9qbFVq?=
 =?gb2312?B?eFhoS3ArS24xeThUOVVZalUzbTJBSEtyTUpKR3pleU83UTBRa2NiWFpWNzVn?=
 =?gb2312?B?eWNqTWFVUUFyTnlpSWgxUTBxYU1XbUFzUEpad0ZSMkxFYmJxOXNlNTNPS2xK?=
 =?gb2312?B?NUFIMHIrblBpdXVMSzNaYyt4aEZUR052NW1rL0t6VC9BZkgwczRwS1BKcE9R?=
 =?gb2312?B?ZGF1RTczZVN0VWJKMmRsSVluS1owbldpMkZMbzR1LzEvVjZHTndzTDFZeHoy?=
 =?gb2312?B?ZmRVdkxkd3hzS1hJQmFGZ2tXdWR1aHl6WGIwakNWemdCc2xzRXpiclZ2Z3dq?=
 =?gb2312?B?OENMU1QvYUFZeDRmZHAzYXFPZVVvTEJzOS9QVDZLdGNLRmhVSlluQ3FMZ2Yy?=
 =?gb2312?B?WWtnWm9OblNqOEowYUxXaU5NYXJQV3I2clZWRUtVTWl4TWZpbEhOQ1N5RUQz?=
 =?gb2312?B?dUlTUjNFNXlUUUN4Uko3bVVZY2JiRUhZQXdOVjc3cmt4Z05rQkFMQTJoYlFw?=
 =?gb2312?B?L2pFQURKWHUrNGdoaDc2Z0xqTHVzTnQ5dEJTQ0Q1ZGd0K3Z0dWVORkEzR01i?=
 =?gb2312?B?eG8yVlhXcU1malowQ1dRbzFaYTlLaWY4aytHdndDTEtvUEhiNDRIZ0tOb1pZ?=
 =?gb2312?B?R0NhUHhZYzZhU3gzdmFueEtiWUZXeVM2cXIrL0M5RkY3RTNuS2NFUk5ZNCti?=
 =?gb2312?B?M1YvS3Z1bmd4Z0F5VFYvbmJGK3lZTGpVNmlnMUM2QlFNK3VNNEdXcmxpUE1Q?=
 =?gb2312?B?Tk9sei9BenViRWpWdGgybG8veGV1Ti9sdVg1UGRRV091QzB3WnYrSGVFdHlB?=
 =?gb2312?B?UDczdHRzeDg1S0lPZDI4OFBjTWNlRnB1Tzl5WVk5UnJGRTJlS3lzZ2VoT2NL?=
 =?gb2312?B?aUYrQy9qKy9hYmNZVURpMEliS1BQNjFlN3ZycEVSdWRraWZqcXhXUkU5M2Zl?=
 =?gb2312?B?QVF2UG9STERZK1M1RFJDdmxqa1U0T0I0MXBUMUMyV1MrUDNQMDRTWUNZeWJQ?=
 =?gb2312?B?VXVQWnl3STFIWDM0VGI3QmZmSFJURVFYT2pqcnppZi9uajB5MUE2eTY2UkEz?=
 =?gb2312?B?M3ZFdXJMZjF1dVVYc3JtRmx3aGlEelVlbThOREU0U2dyT0Z1Y1RCT2hCM2xr?=
 =?gb2312?B?UkhZbUZ3YXZKUFJ5ODJVT0NHSnlNaFdHTVE4YkJxWjhBdkQ1UjVHTW5VV01P?=
 =?gb2312?B?MVZyY2JsUE1RMjVhdFBiRDZNa0VnVUhIVnltdE9RVnJMTVFBUFd3T1VjcFl5?=
 =?gb2312?Q?t1lQ=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2421b636-c374-4c0e-7a2b-08da80b911d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 01:29:18.2411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xfT4P+UW3MLNp7dqQtnVmGt/eacgccC/2ExWZdU3ToKNITJPpJDOPB/ySAN6qiIEIC3aROxnJlQOhE5BUwwOVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8974
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
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo41MIxOMjVIDk6MjANCj4gVG86IFdlaSBGYW5n
IDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFy
bWxpbnV4Lm9yZy51azsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNv
bTsga3ViYUBrZXJuZWwub3JnOyBwYWJlbmlAcmVkaGF0LmNvbTsNCj4gcm9iaCtkdEBrZXJuZWwu
b3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc7IGYuZmFpbmVsbGlAZ21haWwu
Y29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9y
ZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldCAxLzJdIGR0OiBhcjgwM3g6IERvY3VtZW50IGRpc2FibGUtaGliZXJuYXRpb24NCj4gcHJv
cGVydHkNCj4gDQo+ID4gSGkgQW5kcmV3LA0KPiA+DQo+ID4gCVlvdXIgc3VnZ2VzdGlvbiBpcyBp
bmRlZWQgYW4gZWZmZWN0aXZlIHNvbHV0aW9uLCBidXQgSSBjaGVja2VkIGJvdGgNCj4gPiB0aGUg
ZGF0YXNoZWV0IGFuZCB0aGUgZHJpdmVyIG9mIEFSODAzeCBQSFlzIGFuZCBmb3VuZCB0aGF0IHRo
ZQ0KPiA+IHFjYSxjbGstb3V0LWZyZXF1ZW5jeSBhbmQgdGhlIHFjYSxrZWVwLXBsbC1lbmFibGVk
IHByb3BlcnRpZXMgYXJlIGFzc29jaWF0ZWQNCj4gd2l0aCB0aGUgQ0xLXzI1TSBwaW4gb2YgQVI4
MDN4IFBIWXMuDQo+ID4gQnV0IHRoZXJlIGlzIGEgY2FzZSB0aGF0IENMS18yNU0gcGluIGlzIG5v
dCB1c2VkIG9uIHNvbWUgcGxhdGZvcm1zLg0KPiA+IFRha2luZyBvdXIgaS5NWDhEWEwgcGxhdGZv
cm0gYXMgYW4gZXhhbXBsZSwgdGhlIHN0bW1hYyBhbmQgQVI4MDMxIFBIWQ0KPiA+IGFyZSBhcHBs
aWVkIG9uIHRoaXMgcGxhdGZvcm0sIGJ1dCB0aGUgQ0xLXzI1TSBwaW4gb2YgQVI4MDMxIGlzIG5v
dA0KPiA+IHVzZWQuIFNvIHdoZW4gSSB1c2VkIHRoZSBtZXRob2QgeW91IG1lbnRpb25lZCBhYm92
ZSwgaXQgZGlkIG5vdCB3b3JrDQo+ID4gYXMgZXhwZWN0ZWQuIEluIHRoaXMgY2FzZSwgd2UgY2Fu
IG9ubHkgZGlzYWJsZSB0aGUgaGliZXJuYXRpb24gbW9kZSBvZg0KPiA+IEFSODAzeCBQSFlzIGFu
ZCBrZWVwIHRoZSBSWF9DTEsgYWx3YXlzIG91dHB1dHRpbmcgYSB2YWxpZCBjbG9jayBzbyB0aGF0
IHRoZQ0KPiBzdG1tYWMgY2FuIGNvbXBsZXRlIHRoZSBzb2Z0d2FyZSByZXNldCBvcGVyYXRpb24u
DQo+IA0KPiBXaGF0IGhhcHBlbnMgdG8gdGhlIFJYX0NMSyB3aGVuIHlvdSB1bnBsdWcgdGhlIGNh
YmxlPyBJdCBpcyBubyBsb25nZXINCj4gcmVjZWl2aW5nIGFueXRoaW5nLCBzbyBpIHdvdWxkIGV4
cGVjdCB0aGUgUlhfQ0xLIHRvIHN0b3AgdGlja2luZy4gRG9lcyB0aGF0DQo+IGNhdXNlIHByb2Js
ZW1zIGZvciB0aGUgTUFDPw0KPiANClllcywgYWZ0ZXIgdGhlIFBIWSBlbnRlcnMgaGliZXJuYXRp
b24gbW9kZSB0aGF0IHRoZSBSWF9DTEsgc3RvcCB0aWNraW5nLCBidXQNCmZvciBzdG1tYWMsIGl0
IGlzIGVzc2VudGlhbCB0aGF0IFJYX0NMSyBvZiBQSFkgaXMgcHJlc2VudCBmb3Igc29mdHdhcmUg
cmVzZXQNCmNvbXBsZXRpb24uIE90aGVyd2lzZSwgdGhlIHN0bW1hYyBpcyBmYWlsZWQgdG8gY29t
cGxldGUgdGhlIHNvZnR3YXJlIHJlc2V0DQphbmQgY2FuIG5vdCBpbml0IERNQS4NCg0KPiAgICAg
IEFuZHJldw0K
