Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5300C3AB2D2
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 13:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhFQLnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 07:43:10 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:23860
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232558AbhFQLnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 07:43:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK3UgD06wbF0Og6VzQK/5gumM1UMwVrmdQChdStIiX492VVQawog2JNDEonUvMPT+xeMpznsMhz4xsVj1fpPsF4wKNLocX/xAvntnz8c5hIasKFF5AExHyyXX6L0TTl3K30NtZ1vW+0k7/2rGprv+ly5LdPLZFBhqYkq4N9BnxeXa44+rLyR/ZDUPJXqbUaDyuOdMk1Gr0PCz7g++MYuw5k+mOBIY3ASkidhlZ1pbXiiGFpvcAW5l5RcLKOyrjXPUmDyf0RjF9RPqCP6+l4zjuReKimQ86JEj1eb1xDTunYgt7GfXApVtm68zGLXSUGW2AKF2kePvAby5bn1IQa37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbYDV0JS7q3oDJ1NeCpKrs6IXagzrZZH1njsrfZBqtc=;
 b=FlsFvsFVHTjQnzfsYPKnE39C+V7lkY6aaoO2hkcz6l8hz1zWns7N7PDARV8XW9t5L0YUWSIHe0q9ysmtdP4je2RoMBu+io6Ck888gSiCjFyEV8KMeGvIpEe6R3ohuEPIGt/fAB/Qm6MlRBHKZv3HP70LTCDEJ2mwV61b+/Z7UCphScOntOlPjkirgWzGHjxafJYc8xG0+oR/mT6SBDacaHi1LqV9FWl1Q+RBNi0wr5GcMS3dRm92QX1t29rOAFElpf9mgiEuSQIJjCpTdN+MFbfUZnWvGjS66nxmk/pEUP7o/7qomEz/28Qv5Zd3KI7m33l5Vau6ge8JA8q9z2GCvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KbYDV0JS7q3oDJ1NeCpKrs6IXagzrZZH1njsrfZBqtc=;
 b=h4RSfjxDh4Od26VpcrK+ED/VhyIx0QfUUevMTzpimERnTQhloNjTBVZwpnPa+pWcPZVTvFQdS12FFQsfjJsOeDIYqRhovOqp626kgR7fxFI4KKwqNj9FSSgf5a0smBJGU1VE/04IZ1Vl5uEBVPl7LzITqu09G+aiyDxYL/9g4XQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3769.eurprd04.prod.outlook.com (2603:10a6:8:f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 11:40:58 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::f5e8:4886:3923:e92e%8]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 11:40:58 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXXqdJJp2Y2RcztU6Ho2b70gc0WqsPQnYAgAVNuXCAAHYrgIABTjKQgABO7oCAAXlFgA==
Date:   Thu, 17 Jun 2021 11:40:58 +0000
Message-ID: <DB8PR04MB679584EA53A9842D10C33B1EE60E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMicuzWwAKz5ffWB@lunn.ch>
 <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMn3Sd65rzvKasEb@lunn.ch>
In-Reply-To: <YMn3Sd65rzvKasEb@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5589d0b-879b-4dcf-727f-08d93184c660
x-ms-traffictypediagnostic: DB3PR0402MB3769:
x-microsoft-antispam-prvs: <DB3PR0402MB37695C55D268AA6576FEE10EE60E9@DB3PR0402MB3769.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +uzD4Lf20pc47cePvAs+NyCydt6WicxEqUpsLd4spCuyOFR8/C6psA/+SqxLG7uBoCIvdMnFwTrvk6myR0Rg9gDq9AmsNzYb5m3/RriRVf2Y+E8JBR5ru5Xq26DBgvE0SCdyibdaRR/ct73gvkqoh4x3t09lntDc6uiLrxp8MBDz0NBj1TDq45cuu23UgimJm5GKq6ax0hzfjeLNOw64sTv5lGsXEi+sev4e2su7qslTpx79LiDmIrIVFLnqkvsdJ04YtNiR1M2DNHligC3kyNl1voPwbDnSa3rc65TB8hzpE/XqdktJ8Mx8txq1FzlBenC32TpieKMLUdUt++Jvw6KC8Y5x8yGCPB7OwWMjRkZs6r5I+GYFucxjEa2kkP2NvjvSRNB1geChRGfF/w3KDIUSQ4DavXB9WyCWZDqBuXZVR0tZpaCTEKZ6Nd2QgmQhVvL5t1FWs49A5y9/NwHiFsVv8vZ5dYhGIR0ioTsY0iUSGOBpF1FC+lTmDbt8n0MLPUggolybzgZyf7V3isvDaq2RLdPaTI7pMxxOvVV6nvHEo6YP/fTOtDbWKGN/DZO7IE/hQD4diPY0Mr73hCzxQh9Tspd8hWy4SU5vHUqlNG8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(396003)(376002)(346002)(316002)(52536014)(54906003)(2906002)(86362001)(122000001)(71200400001)(38100700002)(33656002)(5660300002)(6916009)(8676002)(9686003)(6506007)(53546011)(4326008)(26005)(76116006)(66446008)(66556008)(64756008)(66476007)(55016002)(66946007)(186003)(83380400001)(7696005)(8936002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q2dQUFBTMG5pZlhwK1daaGRNcE92MlMrNW9nYU1ZdCtZMGxGMFdWZ0NrQ3NJ?=
 =?gb2312?B?cEdmdGo5UTc5YUlPNUlBY3JBd1VodTJRSmVpYjhzK294amo1bVlKWHRLQzJC?=
 =?gb2312?B?dlJVMEtKWk9qMGFpa1Znak9aZFFZaStIazdXK0VGSEtGcm5WNDJNaVhLT1Fq?=
 =?gb2312?B?dzEvT3AxVXlYeE4vL2hQMXVDeUMzOUJHWElXcU9Cc1ExaHhkZ2J6U1dYZHZD?=
 =?gb2312?B?T2VRTjA4VUN6ZnVsREpYTDBCQzJLV1V4UU80K1dIeUtlZnFsM1ZCRWNWTnJr?=
 =?gb2312?B?dk1oNDFwS25OdVdheDFWTkVLdEx5Z1pRYS9MQzNTYmd0aDZ5MFNMYVgyZ0Fh?=
 =?gb2312?B?VThlZ21rKzVBVDNXT1gwZWRFcUtUcm5RbHNLeHVHUk4wb1hWZ1AxN0NzK09o?=
 =?gb2312?B?cGljeTA3ZUJES2RxdHRKbGJYL1RjN2VzaGlKamR4VGlwcEg5ZERNUXRQYzAv?=
 =?gb2312?B?aUNaUksxWDNXbXlNWXZ3NERtRXROdFVCUzY1RmZOeENQY05yN2oxK0xkTEJL?=
 =?gb2312?B?RnlEVGFhV1BrblduNkJWNTY2QUVnMWdkRld5ZVdtMFVsbS9hRHk0alB2a1Yr?=
 =?gb2312?B?OUw5Z00weUszMHZzam5oY044NjY3dFNUMWlNd1VkZ3pxTkhwME42WnYrSHZD?=
 =?gb2312?B?WEFDblhicWQxR1hjME54SDNma0x1Y3FJODB3RUppc1dHNjNLa2dzMUVRSmk3?=
 =?gb2312?B?TmlYQ0RZY0J0a1o2U3hxSSt4a2FnUUcwdCtrekVQRjlWQnF4T1JEQ1JJTHJk?=
 =?gb2312?B?NmdqM2k0VFkvTnJickxIaWZmaEMvYXZaTldVNUhVb2l5YnVXL1VFVHZEUEhh?=
 =?gb2312?B?L25ST1RXTStsQndWNmQ0VXZnNmc2azUxZ0djaStrVWI5R2dFZHR2U3dkSC9E?=
 =?gb2312?B?VTdjcDdYQnV5c2V4QkpWQkEybGZMR25lQWZTRVJ3L1V6RHFsa05DQ1A0MkRW?=
 =?gb2312?B?VXJNNlZMTW56SHRnV0Q4MVhMSDJGT1RNVVdRd3FpWHp5NUpOT1BLdDBiS2tS?=
 =?gb2312?B?dzBzOTRRdzlHM3I0anVSdzZmNy9tV0dNdENDZ2Y2enNjRDU2RUNHWXJ4Y29w?=
 =?gb2312?B?QUFlSkJBWFBmaHdpT0huSWdJQXV2citNZUFjRTlzU2N0Q0xrRXRaVjRiTVZ5?=
 =?gb2312?B?Zm5uSkhBUXNlbktyTlpDelc0RmFDc3NQVE1DRkcyYjI5elcrTnlhRENkYitI?=
 =?gb2312?B?dHFOTnYxM0h2TlMyeFd0bnZhblRWemhaQTk1cm9SMzBOYTVsZzZBK1pFTW9K?=
 =?gb2312?B?aDZEMEI0eUVSYmxYWUJnVHJwSnNublRWT1NMSnc1dkVRY2dLckJzU1dvUGtr?=
 =?gb2312?B?OGJSd25DRDV0WmlQTDVMZHd5TTRqS096QWZBQXJlNHJrVTA5MXQrc1BTQ3Rv?=
 =?gb2312?B?VUFuNldMRW53VWhnL1lLUUF1RTdZV3gvb1hvVkFFQzNRZFRFZEJJQ3kxSHc1?=
 =?gb2312?B?d1craGxKb09weHVWTGhQVkcxUWJia2xzMmRocG1ZamVhcDV4MTVxSVhLVjYv?=
 =?gb2312?B?ZGFNWHA1NW5PclNvdGFNT0k4QThoZ3ZwQW1hTWRlS3FxdDZwWUhaM2tpeTFC?=
 =?gb2312?B?KzVMWWd6cEMvZGljWno3d2dIRWdrWDc0QWMxQVpXVjFIL25CSXdlMFZVRHlw?=
 =?gb2312?B?M1VRYzh2eWZZMk01OWszZWluT2d6L3N0YzlBK3dXenBFYUVyTkJ3eHdOMGp4?=
 =?gb2312?B?ZWVKYWVJSVBUaEZSMS9PdUVZaHRkTEY3eGhmSmhBYjl4Y2Q3Szl1OCs0L1BM?=
 =?gb2312?Q?ZLpZaIIYZvJiwrfcdE294SkiRelwldvY0uutBwx?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5589d0b-879b-4dcf-727f-08d93184c660
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jun 2021 11:40:58.2025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZn1MjvpX7hVCjc7xzyPIk7jyJPDAitQSuG6oiSyqLcBc36+IlcM19UnAwFnmdUDDH/LX7/lO6h7UHBqMzk7Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3769
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5k
cmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIxxOo21MIxNsjVIDIxOjA2DQo+
IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogRGF2aWQg
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsga3ViYUBrZXJuZWwub3JnOw0KPiBmcmllZGVy
LnNjaHJlbXBmQGtvbnRyb24uZGU7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMiBuZXQtbmV4dCAw
LzJdIG5ldDogZmVjOiBmaXggVFggYmFuZHdpZHRoIGZsdWN0dWF0aW9ucw0KPiANCj4gPiBJIHRy
eSBiZWxvdyBidWlsZCBvcHRpb25zLCBhbHNvIGNhbid0IHJlcHJvZHVjZSB0aGlzIGlzc3VlLCBz
byByZWFsbHkgZG9uJ3Qga25vdw0KPiBob3cgdG8gZml4IGl0Lg0KPiA+DQo+ID4gbWFrZSBBUkNI
PWFybTY0IGRpc3RjbGVhbg0KPiA+IG1ha2UgQVJDSD1hcm02NCBhbGxtb2Rjb25maWcNCj4gPiBt
YWtlIC1qOCBBUkNIPWFybTY0IENST1NTX0NPTVBJTEU9YWFyY2g2NC1saW51eC1nbnUtIFc9MSAv
IG1ha2UgLWo4DQo+IEFSQ0g9YXJtNjQgQ1JPU1NfQ09NUElMRT1hYXJjaDY0LWxpbnV4LWdudS0g
Vz0yIC8gbWFrZSAtajgNCj4gQVJDSD1hcm02NCBDUk9TU19DT01QSUxFPWFhcmNoNjQtbGludXgt
Z251LSBXPTMNCj4gPg0KPiA+IEkgc2F3IG1hbnkgdW5yZWxhdGVkIHdhcm5pbmdzLi4uDQo+IA0K
PiBUaGVuIGl0IGNvdWxkIGJlIHNwYXJzZS4gSW5zdGFsbCBzcGFyc2UgYW5kIHVzZSBDPTEuDQoN
CkFmdGVyIGFwcGx5aW5nIHRoZSBwYXRjaCAjMiwgSSB0cmllZCB0byB1c2UgQz0xIHllc3RlcmRh
eSwgSSBkb3VibGUgY2hlY2sgaXQgdG9kYXksIHN0aWxsIG5vIHdhcm5pbmdzLiBBbnl0aGluZyBJ
IG1pc3Npbmc/DQoNCiQgbWFrZSAtajggQVJDSD1hcm02NCBDUk9TU19DT01QSUxFPWFhcmNoNjQt
bGludXgtZ251LSBXPTEsQz0xDQogIENBTEwgICAgc2NyaXB0cy9hdG9taWMvY2hlY2stYXRvbWlj
cy5zaA0KICBDQUxMICAgIHNjcmlwdHMvY2hlY2tzeXNjYWxscy5zaA0KICBDSEsgICAgIGluY2x1
ZGUvZ2VuZXJhdGVkL2NvbXBpbGUuaA0KICBDSEsgICAgIGtlcm5lbC9raGVhZGVyc19kYXRhLnRh
ci54eg0KICBDQyBbTV0gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5v
DQogIExEIFtNXSAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZlYy5vDQogIE1PRFBP
U1QgbW9kdWxlcy1vbmx5LnN5bXZlcnMNCiAgR0VOICAgICBNb2R1bGUuc3ltdmVycw0KICBDQyBb
TV0gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWMubW9kLm8NCiAgTEQgW01dICBk
cml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmtvDQoNCkJlc3QgUmVnYXJkcywNCkpv
YWtpbSBaaGFuZw0KPiAgICAgIEFuZHJldw0K
