Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D83566162
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 04:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbiGECpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 22:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiGECpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 22:45:15 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80079.outbound.protection.outlook.com [40.107.8.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993EEA478;
        Mon,  4 Jul 2022 19:45:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVrxBs07YtuY3TUTCvrQnxRh3RtS4rqL3uSoJVofr01EjsxsQI9R/ttmbqVlCk8Ya3HSMIRX/1ZmFqkZNXJJDsWEL8giXVZIkN0ilPkm7xGwNTm6r7+ZDNkQihGFBbWB+L4jrFzsAi3zuLkRiH9M+0KZCi5lNw4ZHknKDejBuCCzOewayHe6IDMpe9sHSnEtoSYIyuwqe61URkFjzLDPn949Pt12xpuV3ZKJmr5mjXLrBjukoaOPf0tGXv79qdLbX8oScIYZ8M/Nz4ysV8irNoAVc3Bx/3gafLPx3IR96FPJiYGkPgFDJwuuGCvYELivSpm1vUCswLmrhfY36BsLuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/K0lzqXLw122Bs81LvMDSffR4/+CN//t3Zz0/OuTnJU=;
 b=gO4DZi1YJIXoUW5PWT5GtJL4zF3Y7EOsAuke+WrF3puVeIRn6xzMTI/qSaxa8ct7uOZLWiXNFgTNnxSOVVY8zFwx0Fs5eEcxbiG/LdRViCc2S6pMcJvluFiXRWf5JZQRJcLurXO4YKDlEu/siiB0wnWPEKIhRnVpaV536OIxAmWDfK964I0UBSct7zZGMDh/Z2X64pS3Z2Se/xnpHSpp4/W8GqkIT9M1rxA+cYwmPXgiTREin4mhmBhN3TSYh1jtP7ijwMg8u9vLVj19FNsoCw/B1gnc+tDH3Dp1QzHTF5bWAxaFisQDRrJAvOGPoiWCDwQ/fWse+iNlNL5y1OHiNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/K0lzqXLw122Bs81LvMDSffR4/+CN//t3Zz0/OuTnJU=;
 b=imoN85vBlNIVnj5lO/yZ7u6DnU3mt2Y4jwHY7wnEKrP8M1Q8JcnQDLmePlUoANTGFKHzdbKcRPZ+ctoSfLaBeLtTyDqSrBaDaI3rcn0ku1CUyZmhhnV79drAXd7/K0rm5rF9QSa3+9tQ2TMLvLsPZyIUFAGjz4iEWMa91xkm5kA=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by DB7PR04MB5387.eurprd04.prod.outlook.com (2603:10a6:10:8b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 02:45:11 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::b00b:10eb:e562:4654%8]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 02:45:10 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     Aisheng Dong <aisheng.dong@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>, Jacky Bai <ping.bai@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "festevam@gmail.com" <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [EXT] Re: [PATCH 2/3] arm64: dts: imx8ulp: Add the fec support
Thread-Topic: [EXT] Re: [PATCH 2/3] arm64: dts: imx8ulp: Add the fec support
Thread-Index: AQHYj0v7LJmFKydeqk2ZSwBHyUcdKa1tys6AgAEwNnA=
Date:   Tue, 5 Jul 2022 02:45:10 +0000
Message-ID: <AM9PR04MB9003A7CE12B40492CB23619788819@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-3-wei.fang@nxp.com>
 <751e1ec6-2d34-44f6-a6c3-775df8a3cea2@pengutronix.de>
In-Reply-To: <751e1ec6-2d34-44f6-a6c3-775df8a3cea2@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0baa6828-9e2b-40d5-c727-08da5e30613e
x-ms-traffictypediagnostic: DB7PR04MB5387:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: skIECaDquwtAWmrJgiehqInpbK5+w1NZSqMqiLI0PMwDfAFlfr3oah7f45mG2CBz1pam3IdEi3No110gGp/v+qfCqHKkpcSaFJG2UYHdf4mcndWg5JaNHvejSw+JvNgCIyb354nn0ykPuoO/KQNHBER0BtyeRnJUvjjBf0hF+7K4KegUxpFDkYy6cpF2g2/Mn02CKcxFlVqqCGNikJbhBBmi70dZm/20ZMg5ByxYEPoSnzytcGtRpX93LgkLYdAE/9Qk1P9afKB0ZCTLXdFZcJK+ryNzIW9Ne+SBrM386t+BJ3E3BzCZyLvBcI5O05TVKv9rtwcP1HTg6hO2pSFgCehMhkek5LyT+x7tpII9MoV2jQjqRSad3ddIP4oSLUxVB68lQlCxPrFa+MViWs2TSAePMIDPmzISDxLlQwQ+WHMdWXMSbHMj/gGwpe9gS+Lz3lZd3NsTjjTVnTGvrkUBq/cZdXt1Chavg7ZnKJjUiK5mFvn4SJX/ZZeBj03ob0FzGIBntRAOwOCI/y3tQQnbjLoOOOqhgv9svp8lYyzpYztrFyxuSi8d8zcHyK632Es6VkjOVSKyaLOZJ7sX8FXDUFd4IX+zOpU7yRsqoJnef80+L8L5yptDAWoAc+YCevj/ymeng+oEiZXK5sPqnL+NiAebrq6/SuzW9ObkrtaM4iPAKJBWFypdGmk4gztusneVNrE4DgMyKdSApeqRhmEAhibMsqN/eCSSNcssxnj1FYGQPYkbmz4dY31H3HnceTjazSvPvb7ORzJnzJyuA0bri3KoKg1YlaKwDAD9ers4ybk7MT7Ryqq+wK9w8fHsGTrd+J0BW4tLHqV9QwjYesv0bfc+9HMPWN+J0cGmPV1f8Lc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(136003)(366004)(39860400002)(376002)(478600001)(38100700002)(966005)(71200400001)(186003)(33656002)(7696005)(6506007)(41300700001)(53546011)(110136005)(2906002)(66446008)(316002)(122000001)(54906003)(8936002)(7416002)(44832011)(5660300002)(86362001)(45080400002)(38070700005)(52536014)(26005)(9686003)(83380400001)(55016003)(66556008)(66476007)(64756008)(66946007)(76116006)(8676002)(4326008)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ekd1T0pqbHAxYzg3Q3ljVXdnTkQ2aENKTDNEeStQMFpSYkpzZk9ReXBpSWhs?=
 =?gb2312?B?OW15emtLR0pZUGxPQzBrWEhZcW9DRS9QRnUyT2hSdGtaZlJ0SDlrK0ZnVEpv?=
 =?gb2312?B?QlNpK1B3TElacGhMY0dteXQ0SnkyTm1hL3lWUzFNc0c0a2wxNmRhc0Q0eVFQ?=
 =?gb2312?B?ak5Rb0VPU3lIVHVhS0VGeUhKdmIwZC9EUW5nVnFmdmsweW45WmNMZitIejM1?=
 =?gb2312?B?MEpSZ0JHRWhFTWwyTWkxcUVTcXdQR2cxZWRGajFVSU9Gdkl4a3lQa2c3OEwr?=
 =?gb2312?B?c1NhZFNzeTBTeVkxbWZuRUZKSnZ1TE1UaUtldXFvMGowUlZzS2o5dHR5K1ZZ?=
 =?gb2312?B?ckM0dTg2UUhMNUFqZGplNEcxTjVKR0lpY3c1TFd0ZWRjdkcyZ2liQ2xudFBm?=
 =?gb2312?B?S2M4cVYzb2poK0FMUzZZTDFTSWJQWCsrY3NFUnlvZVU2VnNwL0NSa1V1TVNQ?=
 =?gb2312?B?eWtEc1FMaVBBOGw5UDFvQVdMWmxXSjJHZnRLYnNhbCt2S2RXaWIzQ0tqeVBl?=
 =?gb2312?B?VzdMOGxOREJnVTV5TkpWdEk1THpxMjFaVGI4enU1VUR1ZTM5dHJGUUt1cXRk?=
 =?gb2312?B?Z3dma2Z2aVhobitjTjVScXdsR0dXRW9wN1BSamJPMkppNEMwUzR3ZWRLdFl0?=
 =?gb2312?B?V0YrSFN4MENrdUJyYTl6c09meTJjdGE1SDBVUW1RdUkrNVN1WHRuczVHTytl?=
 =?gb2312?B?blQ3dmVGbmlVMjVBNnVWM0NvL2phTXdIUDhVNm9GaGRXd2d5eUtGZUU3WUcv?=
 =?gb2312?B?WnNuU0sxV0pWT0lpSVZkOG1aMXVnRmdmZ2JrMWQ1d21tU1A4TTM2dldWZ25F?=
 =?gb2312?B?clpKbzI1Z01Qd1lCdm9Gamp2U0krd3RDSEdYb2pOZ0NuL1JxUzd0b0FUN2Jz?=
 =?gb2312?B?NzJDdWkvVlYweGEySDNESE5yK0MwUlJSU2J6S2krbG9Ta1Fqd3NVdXR1ZG5y?=
 =?gb2312?B?VnpZWkpxencyT2E4ZWJUekVxVFVHSnQ0OXdPSDlFSFRsbldZZXliVjFqM0FK?=
 =?gb2312?B?QzNheHBaNXBIK1RYNkVmckhJSFFnZEZ1TG5uSXlxaVFmL1ZRYTB3SUdFVlRt?=
 =?gb2312?B?eE03VzdDNnVSK0JKbnV1dzB2VzI3aHNzbDN4MXRjWUVHRmlEb2tnR1p1dGEr?=
 =?gb2312?B?NnZFRmJ5UkNKczIvRmpmREdPcktFbFg1aHlZSDdMVU9Kdzh4ZThLci9jdlNV?=
 =?gb2312?B?aWhsc3NOQ01zV1doOUZmVVk3cjdENHNDdFF2cFAybWZkeVNYUGRpcUt2R0RD?=
 =?gb2312?B?WG5ob1NjWkxLWldWNUVLSUZUaDNmRjdJbVVYMGZ5b244MEEweUlGMWtwcGtD?=
 =?gb2312?B?Wm00eWM2MzVkR29iMk5GTDhLZG9La09EcTFpK1JkcktkTEcrUUlaM1d4WitO?=
 =?gb2312?B?ZkdxMytMMXpjYlRPRTdHeDVjZnNsTU1XaUdvUDc2bmVNbmwvWTZ0cC8vMlhL?=
 =?gb2312?B?ZDFOSjZNQ0VUZ0RwRlIyMTV3cUhldUNlUTNnMDFrSm91QlpaSEJPdUdsTWZQ?=
 =?gb2312?B?WG44UDRiUUdXZXUvL3JLeTdpQ1k3TjZCcWdVR2RnNittcFlxckNyYTJEemp4?=
 =?gb2312?B?QTdNVVU1eHR2ZGRxVDdEeU1iOEdrcFlRTFRxQmFwaTBEdStpS00zQ1dnUGdD?=
 =?gb2312?B?TGRxVVpZTDZ1TVBzQWxXQnFGc0M2eDlQRWJ4aVlYMUgwVnJyTjUyZW9EOE96?=
 =?gb2312?B?em9LbFA3TXA4dDEzZWpudFp4aStpMzh3eE5LcVdHdXNJMDQ1U2liTmF2d2p0?=
 =?gb2312?B?RkpUYVNUa2dwZnEzTWo2RUxObytoU2lZT0NjUFFCL2dFMUNRNWVmaEJEdktr?=
 =?gb2312?B?T0Nic3dXK2dzN1JmYXVSMDM1UVBMNHExWmtLS2dGRWEyUG04Y0ZRNEtZZk8y?=
 =?gb2312?B?czU4QTcrVFZuenZuMnZYOVphNUJHWGRGNDJmSmdZcnpoZUlUV2xUcWVQOHVj?=
 =?gb2312?B?anlwS21DRkNkalZHYWZyQWxNUTRETWc2SlkxZllWZzlUYlNHMWVYck8vcWFp?=
 =?gb2312?B?RWl4Uk9GeXFWM0ExK1NhTHB0OEo3TUxLcGhxVlFmTWpCWjVkbnRFcE5GRWVD?=
 =?gb2312?B?cjI0bFJvVU9NNVlMTE5CQ29MaHZNUzMrcVo0UitFR01wbXFkY2N0V1oyaEx6?=
 =?gb2312?Q?jpBA=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0baa6828-9e2b-40d5-c727-08da5e30613e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2022 02:45:10.9135
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vrs94/FTdqA8ykh9qsNpSP6JccAtQ8lRKjcdbPK7muOlg5S/wLv3e6fufOjtfmHeCNqQTBaKszQoI/wvBmdhag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5387
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWhtYWQ6DQoNCglUaGFua3MgZm9yIHlvdXIgcmVwbHkuIGNsb2NrX2V4dF9ybWlpIGFuZCBj
bG9ja19leHRfdHMgaW5kZWVkIGJlbG9uZyBpbnRvIGJvYXJkIERULCBJIHdpbGwgbW92ZSB0aGVt
IHRvIGlteC44dWxwLWV2ay5kdHMgYW5kIHJlc3VibWl0IHRoZSBwYXRjaC4gQW5kIHJlZmVyIHRv
IGlteDh1bHAgcmVmZXJlbmNlIG1hbnVhbCwgdGhlIGVuZXRfY2xrX3JlZiBvbmx5IGhhcyBleHRl
cm5hbCBjbG9jayBzb3VyY2UsIHNvIGl0IGlzIHJlbGF0ZWQgdG8gc3BlY2lmaWNhbCBib2FyZC4g
VGhlcmVmb3JlLCBjYW4gSSBkZWxldGUgdGhlIGVuZXRfY2xrX3JlZiBjbG9jayBpbiBpbXg4dWxw
LmR0c2kgKGFzIHNob3duIGJlbG93KSBhbmQgb3ZlcnJpZGUgdGhlIGNsb2NrIGFuZCBjbG9jay1u
YW1lcyBwcm9wZXJ0aWVzIGluIGlteDh1bHAtZXZrLmR0cyA/DQoNCj4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgY2xvY2tzID0gPCZjZ2MxIElNWDhVTFBfQ0xLX1hCQVJfRElWQlVTPiwN
Cj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPCZwY2M0IElNWDhVTFBf
Q0xLX0VORVQ+LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA8JmNn
YzEgSU1YOFVMUF9DTEtfRU5FVF9UU19TRUw+Ow0KPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICBjbG9jay1uYW1lcyA9ICJpcGciLCAiYWhiIiwgInB0cCI7DQoNCg0KLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCkZyb206IEFobWFkIEZhdG91bSA8YS5mYXRvdW1AcGVuZ3V0cm9uaXgu
ZGU+IA0KU2VudDogMjAyMsTqN9TCNMjVIDE1OjA3DQpUbzogV2VpIEZhbmcgPHdlaS5mYW5nQG54
cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtl
cm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyByb2JoK2R0QGtlcm5lbC5vcmc7IGtyenlzenRv
Zi5rb3psb3dza2krZHRAbGluYXJvLm9yZzsgc2hhd25ndW9Aa2VybmVsLm9yZzsgcy5oYXVlckBw
ZW5ndXRyb25peC5kZQ0KQ2M6IEFpc2hlbmcgRG9uZyA8YWlzaGVuZy5kb25nQG54cC5jb20+OyBk
ZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgUGVuZyBGYW4gPHBlbmcuZmFuQG54cC5jb20+OyBK
YWNreSBCYWkgPHBpbmcuYmFpQG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29t
Pjsga2VybmVsQHBlbmd1dHJvbml4LmRlOyBzdWRlZXAuaG9sbGFAYXJtLmNvbTsgZmVzdGV2YW1A
Z21haWwuY29tOyBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmcNClN1YmplY3Q6
IFtFWFRdIFJlOiBbUEFUQ0ggMi8zXSBhcm02NDogZHRzOiBpbXg4dWxwOiBBZGQgdGhlIGZlYyBz
dXBwb3J0DQoNCkNhdXRpb246IEVYVCBFbWFpbA0KDQpIZWxsbyBXZWksDQoNCk9uIDA0LjA3LjIy
IDEyOjEwLCBXZWkgRmFuZyB3cm90ZToNCj4gKyAgICAgY2xvY2tfZXh0X3JtaWk6IGNsb2NrLWV4
dC1ybWlpIHsNCj4gKyAgICAgICAgICAgICBjb21wYXRpYmxlID0gImZpeGVkLWNsb2NrIjsNCj4g
KyAgICAgICAgICAgICBjbG9jay1mcmVxdWVuY3kgPSA8NTAwMDAwMDA+Ow0KPiArICAgICAgICAg
ICAgICNjbG9jay1jZWxscyA9IDwwPjsNCj4gKyAgICAgICAgICAgICBjbG9jay1vdXRwdXQtbmFt
ZXMgPSAiZXh0X3JtaWlfY2xrIjsNCj4gKyAgICAgfTsNCj4gKw0KPiArICAgICBjbG9ja19leHRf
dHM6IGNsb2NrLWV4dC10cyB7DQo+ICsgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJmaXhlZC1j
bG9jayI7DQo+ICsgICAgICAgICAgICAgI2Nsb2NrLWNlbGxzID0gPDA+Ow0KPiArICAgICAgICAg
ICAgIGNsb2NrLW91dHB1dC1uYW1lcyA9ICJleHRfdHNfY2xrIjsNCj4gKyAgICAgfTsNCg0KSG93
IGFyZSB0aGVzZSBTb0Mtc3BlY2lmaWM/IFRoZXkgc291bmQgbGlrZSB0aGV5IGJlbG9uZyBpbnRv
IGJvYXJkIERULg0KDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsb2NrcyA9IDwm
Y2djMSBJTVg4VUxQX0NMS19YQkFSX0RJVkJVUz4sDQo+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIDwmcGNjNCBJTVg4VUxQX0NMS19FTkVUPiwNCj4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgPCZjZ2MxIElNWDhVTFBfQ0xLX0VORVRfVFNfU0VM
PiwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPCZjbG9ja19leHRf
cm1paT47DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsb2NrLW5hbWVzID0gImlw
ZyIsICJhaGIiLCAicHRwIiwgDQo+ICsgImVuZXRfY2xrX3JlZiI7DQoNCkkgdGhpbmsgdGhlIGRl
ZmF1bHQgc2hvdWxkIGJlIHRoZSBvdGhlciB3YXkgcm91bmQsIGFzc3VtZSBNQUMgdG8gcHJvdmlk
ZSByZWZlcmVuY2UgY2xvY2sgYW5kIGFsbG93IG92ZXJyaWRlIG9uIGJvYXJkLWxldmVsIGlmIFBI
WSBkb2VzIGl0IGluc3RlYWQuDQoNCkNoZWVycywNCkFobWFkDQoNCg0KLS0NClBlbmd1dHJvbml4
IGUuSy4gICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8DQpTdGV1ZXJ3YWxkZXIgU3RyLiAyMSAgICAgICAgICAgICAgICAgICAgICAgfCBodHRw
czovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cCUzQSUy
RiUyRnd3dy5wZW5ndXRyb25peC5kZSUyRiZhbXA7ZGF0YT0wNSU3QzAxJTdDd2VpLmZhbmclNDBu
eHAuY29tJTdDOWRhZDAzNjdkNTRiNDI3YzVlODAwOGRhNWQ4YmQ5MTIlN0M2ODZlYTFkM2JjMmI0
YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3OTI1MTUyNDczNTM1NjUzJTdDVW5rbm93
biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJU
aUk2SWsxaGFXd2lMQ0pYVkNJNk1uMCUzRCU3QzMwMDAlN0MlN0MlN0MmYW1wO3NkYXRhPTN0a3Fz
VG9xcTclMkJ2TkRrQzdaYU1tMERzaXN1Z0Rwa1ZRWENyMnpxUGJGOCUzRCZhbXA7cmVzZXJ2ZWQ9
MCAgfA0KMzExMzcgSGlsZGVzaGVpbSwgR2VybWFueSAgICAgICAgICAgICAgICAgIHwgUGhvbmU6
ICs0OS01MTIxLTIwNjkxNy0wICAgIHwNCkFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2
ICAgICAgICAgICB8IEZheDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQo=
