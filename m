Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6E63335C5
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 07:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCJGVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 01:21:34 -0500
Received: from mail-db8eur05on2059.outbound.protection.outlook.com ([40.107.20.59]:37851
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229796AbhCJGVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 01:21:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qhhq2ipLsiuFfeLSdzg1h4fBdlGeTYOyQ0EYa1tOKU560ztj2OwmdiVcNnpk+GH7wRc94axVVQx3UR8shL2srvLsmunbfCniX1LpzjK89+Fkt6ReohHzdj0fydsBA4MoNUt0/ydAqqW1qEYMZo2D8rKMSTJ7N1C7g2F5SJk1y8g21gyB0efwmSqKZ24Twfzl/lGIYic7a4A3Jy8zWAs3UK1zqqPIApbdRUilVbZhofKfnRpm8FJojcx6S80j43tW6s3FLERJ0O09dFRPVm6NgPCuTcqe5m2KwzSQm4OSQxFWSSobWw3tBNLMjXpyhE7xOej3oa0HoY84CEfN6Khvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSnh3XiLiNBvoKArUqfvENgTwH35ON248j1txtZeXfY=;
 b=FzFe3leebyyZbvM4A8bU94IukMz/B5sthfywtTeseZmOSy41Zg3EzJAFFbnN3ZN05lBq4IIW3OluzIQaJcwJHSoSaEdm0JA1thDAHCVkZHInXWqK2cB71h76uHFb6Ty5YpHoHjFAWMmPFssqqtVnLr5zsUMZG0fo40oBelzFLsOGnsDitPSsByKsrcMFOToCwfIfl6HzgQ+pkFimedqHndXjvGqKSxu7GL8ENm/64oi903xtS1DBfvdIKlzQpAVI0eNtVANlRQRI9j5FkGUqGpWso9eJbyXA0q3M2QIGnhvhFyQVkavcDPTXRMkxkJOmPouI5Y9ATkl5sAXzG072xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kSnh3XiLiNBvoKArUqfvENgTwH35ON248j1txtZeXfY=;
 b=CFVYsKng7qV8mKqzFv0acjfkpL4rWkYdEk01nP1n1rLpf4v4JD+enUyyf1gPPoedOV0NXSgNbvJzoiTARzVonbtY7+++yTTzuNV0gF6ZfctoOIiD+ABEBKuTBfIPVM94PVdTV3mzhrVgCPalz3yRDmRIN4GnSbmJwrcQknVxEB8=
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com (2603:10a6:10:1f2::23)
 by DB8PR04MB6700.eurprd04.prod.outlook.com (2603:10a6:10:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 06:21:05 +0000
Received: from DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::c8ee:206e:b77c:7337]) by DBBPR04MB7818.eurprd04.prod.outlook.com
 ([fe80::c8ee:206e:b77c:7337%7]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 06:21:05 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: RE:  [PATCH net 2/2] net: enetc: allow hardware timestamping on TX
 queues with tc-etf enabled
Thread-Topic: [PATCH net 2/2] net: enetc: allow hardware timestamping on TX
 queues with tc-etf enabled
Thread-Index: AdcVdWtY8p7Hm+AXQA2eXJDvBAZCmw==
Date:   Wed, 10 Mar 2021 06:21:05 +0000
Message-ID: <DBBPR04MB7818BF360948C482D9088B4292919@DBBPR04MB7818.eurprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [221.218.98.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b3dbe53a-3800-4fdb-1202-08d8e38caf95
x-ms-traffictypediagnostic: DB8PR04MB6700:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6700F7EABA83543FDE3CE28D92919@DB8PR04MB6700.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ro3Q4yWUhYFew6nE70iTnjVFKd5I1ryj7Jz1HmA3wWRPNeA4iiP4G5ZeZtqUKt0KCntgeTxAE6C8dxpLaMtRRWyDgNegZ5Ssmqfj3oR91xhXolfhg04tJyPzJECALWRO5jUY/dnsYPuLIt0Ag8xfm5YOZkGtpfDCRvV0v4EnhTwmDgqn34an3Ze6A7tisTdjUk3YMEGxou3eTLPen1rgBFxllcQ2pJEauiF4r6toXFSxrOSSMpVTo2kz1VQD+sbOBFcHq8+Ujp2191cudeQ0hBLAxU7T6jINrTfgDnxL3fsamp9lyQYxK01ZQcS7eeH1v30MgTW+9sGPcbMNi6tt0KJr+jj4luOaSsiBDgHZU0cKR2BBY8Lt3yXpqb1FHmrmInN8ZFaooRM9QDg3HEcAyNhb5lJEUWwx/sn2+7zffGGTNoP2IhkbVVQGGz0e9NMhyTbQjxYJu8TahvKbsK156H9F9pm+PGMevJuBG9ZsdXOrLqDxzlKuPMo/gVyAeOwXgvCpi4REwIuBaYZgGYN1iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBPR04MB7818.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39840400004)(346002)(396003)(376002)(136003)(66556008)(26005)(6506007)(53546011)(55016002)(8936002)(52536014)(9686003)(66446008)(66946007)(76116006)(83380400001)(64756008)(2906002)(186003)(478600001)(33656002)(54906003)(66476007)(110136005)(5660300002)(7696005)(44832011)(86362001)(71200400001)(8676002)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?V05xUlZvQThNaDNaYUwycXZNSzQ2eS9OVzVUQWh4QXZ3YzhRYTErT3ZPcnU5?=
 =?gb2312?B?d0FqcnIzQi92RGU5VjFoTllweUNOV3VaLzZoTDNYT3RmUThpTUs2aXFOem5F?=
 =?gb2312?B?QjQ4RFg0dzJ5VXBYazJKRVZTbmN5ditZaEs1VVU3TG5YY2h6WVVkV1JCbTlQ?=
 =?gb2312?B?am5hZHdiaEFXMXhOSXpWNkhPVExXbFR4Mnd3dlF2d1BjQzk0WnM0SXR1MnNV?=
 =?gb2312?B?VFB3VkdhRzA1KzcrT2NBYTA5K3J1UUdSQXRmUGNhUGZvTUZscyt6UUNQOS9w?=
 =?gb2312?B?R0ZMeklXNU41UytHczNNVGpkZW5HWnQwQU80cUE0eDBoMWZJc0FRNm00MkFj?=
 =?gb2312?B?bkFtVU1yL3BxNlNHR3ZLSnRPOUE0cHJVVWlXZ0YwZzRxSUxKUmdxMWlnaUo2?=
 =?gb2312?B?V3d5NGlVU1dEclRPb0NHdDErREd6ek9SZmRpT0JianhWNk5vcTRKU2NudEd4?=
 =?gb2312?B?cHFWdUdtand2WkMzaGprdW81VTZGalBYYTBMelJJQmpOT3k4OGFPUk9leTBw?=
 =?gb2312?B?LzQ5RXliWHRwSHR4c2xQRTJYQWlHMERyc1VIandGM0NtUGxoNy9JZ2JsdUtY?=
 =?gb2312?B?T3ErNmR1SWhjSGhBSFZwaDdkVkF5dVp0U2krcVhPZy9oeXZzK0N2bnJZU3Vs?=
 =?gb2312?B?WVVnWXhLVzd6T2xqTysvMGUxMXlXOGFXeHlZSTFhY0ZzbllYNGQyd0JkL2tB?=
 =?gb2312?B?NnJMdzd3N2E2RXBRVW5XSkQxK1NBcGxxZXJ6VVBPVkc3dzlrN3ovdzRSYXhG?=
 =?gb2312?B?S2puQ2VUd2lqbFoxRnU5ZHJtTDlNcEFhekg3RmJ6Z2g5NTRDazI0ZE52UHRn?=
 =?gb2312?B?SlQzS2dkVURZeEl3Yy9iNlNLckNBendocm5oNHhFTGpteXV0NG4yOFU2Y213?=
 =?gb2312?B?SDZtdWEyUFJ4QzNsWGYxN0pualEyMDNWWHBpNWwvaEh2WnlBd1pmRzNBQm5j?=
 =?gb2312?B?eGVyVm5TbjNQMFFDa2UxNXlCOXZwWVBlSlI4SzljQ2ZEc1hydDcrcUVEN1Bx?=
 =?gb2312?B?eUJkTWI5RVNnQ0g2OUZFQVZHQ0ViMlFWOFpPV3JrYS91L0JHUUxnRzFjSC9Z?=
 =?gb2312?B?T0pyWjYrQVBaQUk4emFMQkg4ZGlBeVY2TVlRNCt2YUxtZitiUzhnL3h6TkxR?=
 =?gb2312?B?WGRoc29oSGVSSXh4UHNmT0ExM1gzN3BOMHJyZ2l6UG9xTjBOb0RmMklTMkNQ?=
 =?gb2312?B?MGlBd212bkx6Nk5pSGZuMkVadVFieVp5R3FyNkVSZ1ZWYXpHdkp3dHpFZkRr?=
 =?gb2312?B?Njlpd09NM1o4VXB6OElWVGxnbG1EUGMrbHRPT2M0YXBUR202cDNhNVBaWi9F?=
 =?gb2312?B?TWdEd0kzVUdSYWN3alNsK0Zrb25DS1dqT0tIc0FDOThKeHlZM0JmV2IvcVhZ?=
 =?gb2312?B?ZlVFKzJtMnZqSVpYY253U2RsR3h4QkZtdlNxSXFDZXdzZzVneldiT2EyeGRL?=
 =?gb2312?B?ejhSRFlrblgyYlZsVDFQcWFMMzF5MjZ4dk9JM3B4RGVFbitBZUJKRktsMDlq?=
 =?gb2312?B?TEZ4TTlCT09DQjRrSllOKzEzUCtQeGR1OWEyVHpjVUcxQXNMeEcrRmNvYWRU?=
 =?gb2312?B?OGtTUVgvcFRTV3RmWlV4V2ZCUGthNHRVTEl6VjRaV0dmdDcrVHZCSWRMYzhw?=
 =?gb2312?B?ZGlYRm11bVZITzFxd1k4U1Q4MFc3b0wwajNSaE9LUDNvU25uWmtqbG4yUEdI?=
 =?gb2312?B?aXk1ZWhGZ3hYcTZxVjE2VXg4UVZsd014YzArYU8vM3lzcXVXZHRXYmNmMGhQ?=
 =?gb2312?Q?fc+CfLEMwrTfx+CXPI=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBPR04MB7818.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3dbe53a-3800-4fdb-1202-08d8e38caf95
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 06:21:05.2359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: viRLcxHYf8BtaKogJ+oJHQVaokcMwA3inPauhjc7wP1XSchWcCtL7s9aPd4d7KDq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6700
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T2sgdG8gbWUuDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVmxhZGlt
aXIgT2x0ZWFuIDxvbHRlYW52QGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqM9TCN8jVIDIxOjI0
DQo+IFRvOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2lj
aW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFBvIExp
dSA8cG8ubGl1QG54cC5jb20+DQo+IENjOiBBbGV4YW5kcnUgTWFyZ2luZWFuIDxhbGV4YW5kcnUu
bWFyZ2luZWFuQG54cC5jb20+OyBDbGF1ZGl1IE1hbm9pbA0KPiA8Y2xhdWRpdS5tYW5vaWxAbnhw
LmNvbT47IE1pY2hhZWwgV2FsbGUgPG1pY2hhZWxAd2FsbGUuY2M+OyBWbGFkaW1pcg0KPiBPbHRl
YW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgVmluaWNpdXMgQ29zdGEgR29tZXMNCj4gPHZp
bmljaXVzLmdvbWVzQGludGVsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldCAyLzJdIG5ldDog
ZW5ldGM6IGFsbG93IGhhcmR3YXJlIHRpbWVzdGFtcGluZyBvbiBUWA0KPiBxdWV1ZXMgd2l0aCB0
Yy1ldGYgZW5hYmxlZA0KPiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBGcm9tOiBWbGFk
aW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPiANCj4gVGhlIHR4dGltZSBp
cyBwYXNzZWQgdG8gdGhlIGRyaXZlciBpbiBza2ItPnNrYl9tc3RhbXBfbnMsIHdoaWNoIGlzIGFj
dHVhbGx5IGluIGENCj4gdW5pb24gd2l0aCBza2ItPnRzdGFtcCAodGhlIHBsYWNlIHdoZXJlIHNv
ZnR3YXJlIHRpbWVzdGFtcHMgYXJlIGtlcHQpLg0KPiANCj4gU2luY2UgY29tbWl0IGI1MGE1Yzcw
ZmZhNCAoIm5ldDogYWxsb3cgc2ltdWx0YW5lb3VzIFNXIGFuZCBIVyB0cmFuc21pdA0KPiB0aW1l
c3RhbXBpbmciKSwgX19zb2NrX3JlY3ZfdGltZXN0YW1wIGhhcyBzb21lIGxvZ2ljIGZvciBtYWtp
bmcgc3VyZSB0aGF0DQo+IHRoZSB0d28gY2FsbHMgdG8gc2tiX3RzdGFtcF90eDoNCj4gDQo+IHNr
Yl90eF90aW1lc3RhbXAoc2tiKSAjIFNvZnR3YXJlIHRpbWVzdGFtcCBpbiB0aGUgZHJpdmVyDQo+
IC0+IHNrYl90c3RhbXBfdHgoc2tiLCBOVUxMKQ0KPiANCj4gYW5kDQo+IA0KPiBza2JfdHN0YW1w
X3R4KHNrYiwgJnNoaHd0c3RhbXBzKSAjIEhhcmR3YXJlIHRpbWVzdGFtcCBpbiB0aGUgZHJpdmVy
DQo+IA0KPiB3aWxsIGJvdGggZG8gdGhlIHJpZ2h0IHRoaW5nIGFuZCBpbiBhIHJhY2UtZnJlZSBt
YW5uZXIsIG1lYW5pbmcgdGhhdA0KPiBza2JfdHhfdGltZXN0YW1wIHdpbGwgZGVsaXZlciBhIGNt
c2cgd2l0aCB0aGUgc29mdHdhcmUgdGltZXN0YW1wIG9ubHksIGFuZA0KPiBza2JfdHN0YW1wX3R4
IHdpdGggYSBub24tTlVMTCBod3RzdGFtcHMgYXJndW1lbnQgd2lsbCBkZWxpdmVyIGEgY21zZyB3
aXRoDQo+IHRoZSBoYXJkd2FyZSB0aW1lc3RhbXAgb25seS4NCj4gDQo+IFdoeSBhcmUgcmFjZXMg
ZXZlbiBwb3NzaWJsZT8gV2VsbCwgYmVjYXVzZSBhbHRob3VnaCB0aGUgc29mdHdhcmUgdGltZXN0
YW1wDQo+IHNrYi0+dHN0YW1wIGlzIHByaXZhdGUgcGVyIHNrYiwgdGhlIGhhcmR3YXJlIHRpbWVz
dGFtcA0KPiBza2ItPnNrYl9od3RzdGFtcHMoc2tiKQ0KPiBsaXZlcyBpbiBza2Jfc2hpbmZvKHNr
YiksIGFuIGFyZWEgd2hpY2ggaXMgc2hhcmVkIGJldHdlZW4gc2ticyBhbmQgdGhlaXIgY2xvbmVz
Lg0KPiBBbmQgc2tiX3RzdGFtcF90eCB3b3JrcyBieSBjbG9uaW5nIHRoZSBwYWNrZXRzIHdoZW4g
dGltZXN0YW1waW5nIHRoZW0sDQo+IHRoZXJlZm9yZSBhdHRlbXB0aW5nIHRvIHBlcmZvcm0gaGFy
ZHdhcmUgdGltZXN0YW1waW5nIG9uIGFuIHNrYidzIGNsb25lIHdpbGwNCj4gYWxzbyBjaGFuZ2Ug
dGhlIGhhcmR3YXJlIHRpbWVzdGFtcCBvZiB0aGUgb3JpZ2luYWwgc2tiLiBBbmQgdGhlIG9yaWdp
bmFsIHNrYg0KPiBtaWdodCBoYXZlIGJlZW4geWV0IGFnYWluIGNsb25lZCBmb3Igc29mdHdhcmUg
dGltZXN0YW1waW5nLCBhdCBhbiBlYXJsaWVyIHN0YWdlLg0KPiANCj4gU28gdGhlIGxvZ2ljIGlu
IF9fc29ja19yZWN2X3RpbWVzdGFtcCBjYW4ndCBiZSBhcyBzaW1wbGUgYXMgc2F5aW5nICJkb2Vz
IHRoaXMNCj4gc2tiIGhhdmUgYSBoYXJkd2FyZSB0aW1lc3RhbXA/IGlmIHllcyBJJ2xsIHNlbmQg
dGhlIGhhcmR3YXJlIHRpbWVzdGFtcCB0byB0aGUNCj4gc29ja2V0LCBvdGhlcndpc2UgSSdsbCBz
ZW5kIHRoZSBzb2Z0d2FyZSB0aW1lc3RhbXAiLCBwcmVjaXNlbHkgYmVjYXVzZSB0aGUNCj4gaGFy
ZHdhcmUgdGltZXN0YW1wIGlzIHNoYXJlZC4NCj4gSW5zdGVhZCwgaXQncyBxdWl0ZSB0aGUgb3Ro
ZXIgd2F5IGFyb3VuZDogX19zb2NrX3JlY3ZfdGltZXN0YW1wIHNheXMgImRvZXMgdGhpcw0KPiBz
a2IgaGF2ZSBhIHNvZnR3YXJlIHRpbWVzdGFtcD8gaWYgeWVzLCBJJ2xsIHNlbmQgdGhlIHNvZnR3
YXJlIHRpbWVzdGFtcCwNCj4gb3RoZXJ3aXNlIHRoZSBoYXJkd2FyZSBvbmUiLiBUaGlzIHdvcmtz
IGJlY2F1c2UgdGhlIHNvZnR3YXJlIHRpbWVzdGFtcCBpcyBub3QNCj4gc2hhcmVkIHdpdGggY2xv
bmVzLg0KPiANCj4gQnV0IHRoYXQgbWVhbnMgd2UgaGF2ZSBhIHByb2JsZW0gd2hlbiB3ZSBhdHRl
bXB0IGhhcmR3YXJlIHRpbWVzdGFtcGluZw0KPiB3aXRoIHNrYnMgdGhhdCBkb24ndCBoYXZlIHRo
ZSBza2ItPnRzdGFtcCA9PSAwLiBfX3NvY2tfcmVjdl90aW1lc3RhbXAgd2lsbCBzYXkNCj4gIm9o
LCB5ZWFoLCB0aGlzIG11c3QgYmUgc29tZSBzb3J0IG9mIG9kZCBjbG9uZSIgYW5kIHdpbGwgbm90
IGRlbGl2ZXIgdGhlDQo+IGhhcmR3YXJlIHRpbWVzdGFtcCB0byB0aGUgc29ja2V0LiBBbmQgdGhp
cyBpcyBleGFjdGx5IHdoYXQgaXMgaGFwcGVuaW5nIHdoZW4NCj4gd2UgaGF2ZSB0eHRpbWUgZW5h
YmxlZCBvbiB0aGUgc29ja2V0OiBhcyBtZW50aW9uZWQsIHRoYXQgaXMgcHV0IGluIGEgdW5pb24g
d2l0aA0KPiBza2ItPnRzdGFtcCwgc28gaXQgaXMgcXVpdGUgZWFzeSB0byBtaXN0YWtlIGl0Lg0K
PiANCj4gRG8gd2hhdCBvdGhlciBkcml2ZXJzIGRvIChpbnRlbCBpZ2IvaWdjKSBhbmQgd3JpdGUg
emVybyB0byBza2ItPnRzdGFtcCBiZWZvcmUNCj4gdGFraW5nIHRoZSBoYXJkd2FyZSB0aW1lc3Rh
bXAuIEl0J3Mgb2Ygbm8gdXNlIHRvIHVzIG5vdyAod2UncmUgYWxyZWFkeSBvbiB0aGUNCj4gVFgg
Y29uZmlybWF0aW9uIHBhdGgpLg0KPiANCj4gRml4ZXM6IDBkMDhjOWVjN2Q2ZSAoImVuZXRjOiBh
ZGQgc3VwcG9ydCB0aW1lIHNwZWNpZmljIGRlcGFydHVyZSBiYXNlIG9uIHRoZQ0KPiBxb3MgZXRm
IikNCj4gQ2M6IFZpbmljaXVzIENvc3RhIEdvbWVzIDx2aW5pY2l1cy5nb21lc0BpbnRlbC5jb20+
DQo+IFNpZ25lZC1vZmYtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5j
b20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRj
LmMgfCA2ICsrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5j
DQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2VuZXRjL2VuZXRjLmMNCj4gaW5k
ZXggMzBkN2Q0ZTgzOTAwLi4wOTQ3MTMyOWYzYTMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZyZWVzY2FsZS9lbmV0Yy9lbmV0Yy5jDQo+IEBAIC0zNDQsNiArMzQ0LDEyIEBAIHN0
YXRpYyB2b2lkIGVuZXRjX3RzdGFtcF90eChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCB1NjQNCj4gdHN0
YW1wKQ0KPiAgICAgICAgIGlmIChza2Jfc2hpbmZvKHNrYiktPnR4X2ZsYWdzICYgU0tCVFhfSU5f
UFJPR1JFU1MpIHsNCj4gICAgICAgICAgICAgICAgIG1lbXNldCgmc2hod3RzdGFtcHMsIDAsIHNp
emVvZihzaGh3dHN0YW1wcykpOw0KPiAgICAgICAgICAgICAgICAgc2hod3RzdGFtcHMuaHd0c3Rh
bXAgPSBuc190b19rdGltZSh0c3RhbXApOw0KPiArICAgICAgICAgICAgICAgLyogRW5zdXJlIHNr
Yl9tc3RhbXBfbnMsIHdoaWNoIG1pZ2h0IGhhdmUgYmVlbiBwb3B1bGF0ZWQgd2l0aA0KPiArICAg
ICAgICAgICAgICAgICogdGhlIHR4dGltZSwgaXMgbm90IG1pc3Rha2VuIGZvciBhIHNvZnR3YXJl
IHRpbWVzdGFtcCwNCj4gKyAgICAgICAgICAgICAgICAqIGJlY2F1c2UgdGhpcyB3aWxsIHByZXZl
bnQgdGhlIGRpc3BhdGNoIG9mIG91ciBoYXJkd2FyZQ0KPiArICAgICAgICAgICAgICAgICogdGlt
ZXN0YW1wIHRvIHRoZSBzb2NrZXQuDQo+ICsgICAgICAgICAgICAgICAgKi8NCj4gKyAgICAgICAg
ICAgICAgIHNrYi0+dHN0YW1wID0ga3RpbWVfc2V0KDAsIDApOw0KPiAgICAgICAgICAgICAgICAg
c2tiX3RzdGFtcF90eChza2IsICZzaGh3dHN0YW1wcyk7DQo+ICAgICAgICAgfQ0KPiAgfQ0KPiAt
LQ0KPiAyLjI1LjENCg0KUmV2aWV3ZWQtYnk6IFBvIExpdSA8cG8ubGl1QG54cC5jb20+DQoNCkJy
LA0KUG8gTGl1DQoNCg==
