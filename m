Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23B937646C
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 13:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhEGL1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 07:27:36 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:55182
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229537AbhEGL1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 07:27:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZNCtgK4ftgEYtmFyV1vZl9r+1mC7o4U4Q3bfSnY+B276SItpJCJJ5oRam7z6oRyp9cidYC6xv672k/O0ss8Pd3PeWH0ezd6DlAvyt4bM5hlRCPxpuEZrgPsCDRY/N7YlNLbasHeKu9cLxYe+EtEqucX6BunZwoAPJfl/1STQkxDhPwXX08IyFmTdthuVQ/gCzqZvMVn0myfJUNtwM1hvAToEcE2HjlAzjjM/IU3MQ0Myymdd4JRmEB4q8pjInWmoRRxWVTkDNwYANs1TT71gNKzgoeWKg3wnj+79Dvr92MunHv6yxYu8Ara2EEnuvC2jjqm1EOm1SuapV487S+T4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFem0918/XIY5YWk0jtq7YAhytA7zex/6q+fnnoy64o=;
 b=gXnd9n9KRU9E6T7hBvKBFIstHbh0+PLrte/ByOq6GYg1f5UKTQBLn3o7dx1qVCwavxlgxieetRD4sWnr48MWO9j8+g4E4V0TRxP7+2KEBrP+HHUXRnYHdYTtdT85UDkcWKAkZlbnfeCBdCqyT5/FD+A1XM9kHa8a6b23Q3dw0omtwXIflkk+ACzP7mX3slQVutPzC6CLZj1GzSFM9m5K8krKMtaSpvdNgGniHAps7p+2EJ2f7nWiESXZIOF1ssaM2KPA02omXFBsH4TUyKgC9zgOY7KedTK2V6vmiGBbsI3BSiLgDovc0ntaKXV7emKb7jwglb7R2Mif/mvx6wwGkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TFem0918/XIY5YWk0jtq7YAhytA7zex/6q+fnnoy64o=;
 b=AWvybLiBEtJUsdYWtQISk0ntnM0ujbrbJcF1egkTsmhhuUB12+OD4x6BZpSTLM2I15xRHWTiZ1Mpj0WcNfhk7QCZWpQbKDn5LsnxCpXfrnoR97lC0+L5yeBCpPB3ZATr3DifChiORumbWncGiYjZTzEdVmMyX/Mi7ZXgBgKefTw=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB6PR0401MB2422.eurprd04.prod.outlook.com (2603:10a6:4:50::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 11:26:32 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc%6]) with mapi id 15.20.4108.027; Fri, 7 May 2021
 11:26:32 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Topic: [net-next, v2, 3/7] net: dsa: free skb->cb usage in core driver
Thread-Index: AQHXOn8Jr4d6SG7MRkyMg7TxAYZcc6rKZYAAgA2IDNA=
Date:   Fri, 7 May 2021 11:26:32 +0000
Message-ID: <DB7PR04MB5017DD1C470A06A66ADBB5DEF8579@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210426093802.38652-1-yangbo.lu@nxp.com>
 <20210426093802.38652-4-yangbo.lu@nxp.com> <87y2d2noe5.fsf@waldekranz.com>
In-Reply-To: <87y2d2noe5.fsf@waldekranz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eb6dd04c-1b96-409d-86e7-08d9114af759
x-ms-traffictypediagnostic: DB6PR0401MB2422:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB24223966DD5A18D352314416F8579@DB6PR0401MB2422.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hzMpIT0sp24RmooMxHaf6HV8FcwEDfjkm5CAbUFpGD5rGSup6mTLIkidTRqjaNU0TSD06f0kmW3zGjwqepFNVViPY8kfcSKOz+AwS7t6hy/MIVj4X3NxY33T2HOW0BSf69rByQG5bOiVAb+ML0+KzmoPkvn48r2rukW+QCGFiesvsljOE3G04UIUrPq1MMzXAT9Ij0hQr8EomYy5A6MFTxStsdR67r6XUzc0q6dxZM2GJu/8G9U89jIMq4ZN4ktribrE2j88t7GZQh8wmdYHBHkVNXcHlsT2dR/jRJybCPxFOCtGGi5f+bQpwlg8ruYGNvxULzaiN19JE7dQJPo7bh6gIB/pUmAyXVJTYepK1NXVoku/HZfNxEM2dBhfYYIWnfkknnjq998qi4Um4QuK0wQo/4jm4ZHp0fVGePLJjObWYgBuzwAs8d8PQMb+kp6grEfrFxLgLFXTfsnpvcoyGXNbFs2odtchYGMbnuhNWn04BtSqHdid4pGZAEFDiCilkGK6Y2Qc/mM4hhPkS+9apc0mNjv/BbQvCjVzIrUETdhbZd5eU2jWGcchb95J1xhh37vFbG/aiEOiGlVDyv0UbnFit/66Yz/i5wfNFbxooNo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(39850400004)(346002)(396003)(478600001)(316002)(7696005)(55016002)(52536014)(33656002)(83380400001)(76116006)(66446008)(66556008)(26005)(66946007)(38100700002)(5660300002)(71200400001)(7416002)(54906003)(4326008)(66476007)(9686003)(186003)(53546011)(2906002)(6506007)(110136005)(122000001)(8676002)(8936002)(64756008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SzhPeGZSR2RHWlY5Zyt5bGZZMkpmMWY4SG9lTlRKS2ZZa3JueDdVck9YVXgr?=
 =?gb2312?B?ZlNzbGU4eXN4eDloLzhaL1Y1R3lmYTBqNzBBSUJxNGdjbk4wTXhZc0oxYW9I?=
 =?gb2312?B?S2I1L2s4NThOMmF6KzJLUjN3VlBqQXZhc3BjZUk3dW1VaU9DN0EwOTd0SHFw?=
 =?gb2312?B?WERKWTdZZmtzM2xWdUpZUVpwZVk5UUU0T2ppS1RQYTI2K0g4M1F6bXk4SUtr?=
 =?gb2312?B?RnI0NXJGZStKempxV0FGZkEvRXlnejRyRXB2UHZMWW5EaEsvNkZJek1xN01V?=
 =?gb2312?B?M0tmMjlFdENVMjU0aUxoRGU4bTNPNXRJYk83WllnSU0wWlpURkQvLzU2cFRv?=
 =?gb2312?B?aHQ3bEZJQytPQUFmTEU0RW9rdjVrNzIwMEdUb0plNlM1MFUwQ0VCTmFuZ2NC?=
 =?gb2312?B?VG5nazVhSkJHUGFORjZkY2ZtWkdaczNwN3RBL2s0KzNrQVF3SXlzak8wZ0dR?=
 =?gb2312?B?RnlwZGJaNS9OL28vMlNmS0VHM3BETGFpckdrdlppVU5KUW5IWm02ZTVhOThj?=
 =?gb2312?B?QlpFNk1tQXlVVGVJZjhLcjltdnJOYnEvN1lmTWU0WVVSLzFIaU1nem82UFdO?=
 =?gb2312?B?S0d6K0FNZWNmRlFNL0huUnExcmg5dW14d1RiUGtROE1rcmFueDlmeVNFTCty?=
 =?gb2312?B?WGpvWXQ1ZXFKeUVFN2pQaS9NQkc1RWpUSXdXQzh3V0tlTE9hSEFrTTRmS1ZC?=
 =?gb2312?B?eG9wa21YVk9UL3IrOWhLZStkZlAxYU9pYjhoOWpoT2YxMjNZRCtCZnc1TzNa?=
 =?gb2312?B?THdQZVoramVJemRLVGNoWTZScExxTzB3M3ViQWlPcHpCTFYzRzRrZG1KYXkv?=
 =?gb2312?B?bkQ3c3VNazJKRFptOHROWG9aWjV0UTlzTGVIUGpMZmRxemQzWnkxb0tNZkRV?=
 =?gb2312?B?NUFVUVM1bXgycXZLb1dNajl6d2dJVFdTWkp0eXM4eFQ4WEJmMFpTSUpaaTlV?=
 =?gb2312?B?OUxKdURDUmFBY3pNcm9QdFhKSjlDT0IvRmQ3UDdHWDVZYXdMRFdiQWd6d2tl?=
 =?gb2312?B?NU1KdDdQYzNVdTFSNW13VjRBQVNFSmNQQUluWmhaYmV6ckpJUm9ldVdOOGZY?=
 =?gb2312?B?RXlJRDNDMjVLN3RHY1B2Sk00Z2h0ckNCR3BFMEpZS3p6MTBHZzBDSnJXY2I2?=
 =?gb2312?B?WUN5REtwUTVlUEh2N2JLeXUwK2MwRUFTR0F4VEttalJUMzZkQk9lMFdzcFBO?=
 =?gb2312?B?bldCZ25kWlpUUFE4ZWdRSUFpL2NiTXJTaHFyamFaR3NMVlUza1R0SVpZcUxC?=
 =?gb2312?B?RDVyMHZFNUJBbXVhTlo1Q2h5L1hOMzNBZXVyamxVdUxBazBUMnZyclRZZmE0?=
 =?gb2312?B?d3dERCtiS0NSVCtFZDkvU1FsZTV3WVNmY3dLTVJvNFIrRE1WUEJuemZSdzIv?=
 =?gb2312?B?eDY5VGRaUnN5TitJa1dzMHBPdkRZRHhWSTBYRDE1Qnd5N0hmdE50WkNjMVpm?=
 =?gb2312?B?bnFnSXFhcFF3SXZYTEl3THdUVld2c2JyN0UrS3VIR2pDM3JZZWFHeUt1WS9R?=
 =?gb2312?B?NGFDeWs2c3BHYTRwRU1ldTVYUzF4WWNtaHBTUHNzMVJDVmF2TVNKaXBmQXAr?=
 =?gb2312?B?LzNmVG4xa2hXOHN4S0VDcnVjQVYzUEIrK3RrT3VlTVpHV29qc0M4YnZQb3hS?=
 =?gb2312?B?VHczTkFPNEJTdXBDdEhoKy91QkFMaXZCOHBtdk9zVjE4TllkeHNBNDNOMVYr?=
 =?gb2312?B?WXU2OE1LVTJuUkJzLy9GM2hKL3BXVjBuK0c5WURKR3hoZXJ2R0owT2l6SFAx?=
 =?gb2312?Q?Zur29Fx1MID/aIMCFEPIVb9rK3xS6WjBoZzXJB+?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb6dd04c-1b96-409d-86e7-08d9114af759
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 11:26:32.3478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DEAkTydiwlTDlT9maQHxlEmdGtnEx0ErVt6KCRMMN7jujfz7Gl2oAhXua0wxIhxfv24P9b7W1SXdSR+rxWkrLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBUb2JpYXMgV2FsZGVrcmFueiA8
dG9iaWFzQHdhbGRla3JhbnouY29tPg0KPiBTZW50OiAyMDIxxOo01MIyOcjVIDQ6MzANCj4gVG86
IFkuYi4gTHUgPHlhbmdiby5sdUBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBD
YzogWS5iLiBMdSA8eWFuZ2JvLmx1QG54cC5jb20+OyBSaWNoYXJkIENvY2hyYW4NCj4gPHJpY2hh
cmRjb2NocmFuQGdtYWlsLmNvbT47IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54
cC5jb20+Ow0KPiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQo+IEpvbmF0aGFuIENvcmJldCA8Y29yYmV0QGx3
bi5uZXQ+OyBLdXJ0IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47DQo+IEFuZHJldyBM
dW5uIDxhbmRyZXdAbHVubi5jaD47IFZpdmllbiBEaWRlbG90IDx2aXZpZW4uZGlkZWxvdEBnbWFp
bC5jb20+Ow0KPiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47IENsYXVk
aXUgTWFub2lsDQo+IDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPjsgQWxleGFuZHJlIEJlbGxvbmkN
Cj4gPGFsZXhhbmRyZS5iZWxsb25pQGJvb3RsaW4uY29tPjsgVU5HTGludXhEcml2ZXJAbWljcm9j
aGlwLmNvbTsNCj4gbGludXgtZG9jQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW25ldC1uZXh0LCB2MiwgMy83XSBuZXQ6IGRzYTog
ZnJlZSBza2ItPmNiIHVzYWdlIGluIGNvcmUgZHJpdmVyDQo+IA0KPiBPbiBNb24sIEFwciAyNiwg
MjAyMSBhdCAxNzozNywgWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4gd3JvdGU6DQo+ID4g
RnJlZSBza2ItPmNiIHVzYWdlIGluIGNvcmUgZHJpdmVyIGFuZCBsZXQgZGV2aWNlIGRyaXZlcnMg
ZGVjaWRlIHRvIHVzZQ0KPiA+IG9yIG5vdC4gVGhlIHJlYXNvbiBoYXZpbmcgYSBEU0FfU0tCX0NC
KHNrYiktPmNsb25lIHdhcyBiZWNhdXNlDQo+ID4gZHNhX3NrYl90eF90aW1lc3RhbXAoKSB3aGlj
aCBtYXkgc2V0IHRoZSBjbG9uZSBwb2ludGVyIHdhcyBjYWxsZWQNCj4gPiBiZWZvcmUgcC0+eG1p
dCgpIHdoaWNoIHdvdWxkIHVzZSB0aGUgY2xvbmUgaWYgYW55LCBhbmQgdGhlIGRldmljZQ0KPiA+
IGRyaXZlciBoYXMgbm8gd2F5IHRvIGluaXRpYWxpemUgdGhlIGNsb25lIHBvaW50ZXIuDQo+ID4N
Cj4gPiBBbHRob3VnaCBmb3Igbm93IHB1dHRpbmcgbWVtc2V0KHNrYi0+Y2IsIDAsIDQ4KSBhdCBi
ZWdpbm5pbmcgb2YNCj4gPiBkc2Ffc2xhdmVfeG1pdCgpIGJ5IHRoaXMgcGF0Y2ggaXMgbm90IHZl
cnkgZ29vZCwgdGhlcmUgaXMgc3RpbGwgd2F5IHRvDQo+ID4gaW1wcm92ZSB0aGlzLiBPdGhlcndp
c2UsIHNvbWUgb3RoZXIgbmV3IGZlYXR1cmVzLCBsaWtlIG9uZS1zdGVwDQo+IA0KPiBDb3VsZCB5
b3UgcGxlYXNlIGV4cGFuZCBvbiB0aGlzIGltcHJvdmVtZW50Pw0KPiANCj4gVGhpcyBtZW1zZXQg
bWFrZXMgaXQgaW1wb3NzaWJsZSB0byBjYXJyeSBjb250cm9sIGJ1ZmZlciBpbmZvcm1hdGlvbiBm
cm9tDQo+IGRyaXZlciBjYWxsYmFja3MgdGhhdCBydW4gYmVmb3JlIC5uZG9fc3RhcnRfeG1pdCwg
Zm9yDQo+IGV4YW1wbGUgLm5kb19zZWxlY3RfcXVldWUsIHRvIGEgdGFnZ2VyJ3MgLnhtaXQuDQo+
IA0KPiBJdCBzZWVtcyB0byBtZSB0aGF0IGlmIHRoZSBkcml2ZXJzIGFyZSB0byBoYW5kbGUgdGhl
IENCIGludGVybmFsbHkgZnJvbSBub3cgb24sDQo+IHRoYXQgc2hvdWxkIGdvIGZvciBib3RoIHNl
dHRpbmcgYW5kIGNsZWFyaW5nIG9mIHRoZSByZXF1aXJlZCBmaWVsZHMuDQo+IA0KDQpGb3IgdGhl
IHRpbWVzdGFtcGluZyBjYXNlLCBkc2Ffc2tiX3R4X3RpbWVzdGFtcCBtYXkgbm90IHRvdWNoIC5w
b3J0X3R4dHN0YW1wIGNhbGxiYWNrLCBzbyB3ZSBoYWQgdG8gcHV0IHNrYi0+Y2IgaW5pdGlhbGl6
YXRpb24gYXQgYmVnaW5uaW5nIG9mIGRzYV9zbGF2ZV94bWl0Lg0KVG8gYXZvaWQgYnJlYWtpbmcg
ZnV0dXJlIHNrYi0+Y2IgdXNhZ2UgeW91IG1lbnRpb25lZCwgZG8geW91IHRoaW5rIHdlIGNhbiBi
YWNrIHRvIFZsYWRpbWlyJ3MgaWRlYSBpbml0aWFsaXppbmcgb25seSBmaWVsZCByZXF1aXJlZCwg
b3IgZXZlbiBqdXN0IGFkZCBhIGNhbGxiYWNrIGZvciBjYiBpbml0aWFsaXphdGlvbiBmb3IgdGlt
ZXN0YW1waW5nPw0KDQpUaGFua3MuDQoNCg0KPiA+IHRpbWVzdGFtcCB3aGljaCBuZWVkcyBhIGZs
YWcgb2Ygc2tiIG1hcmtlZCBpbiBkc2Ffc2tiX3R4X3RpbWVzdGFtcCgpLA0KPiA+IGFuZCBoYW5k
bGVzIGFzIG9uZS1zdGVwIHRpbWVzdGFtcCBpbiBwLT54bWl0KCkgd2lsbCBmYWNlIHNhbWUNCj4g
PiBzaXR1YXRpb24uDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBZYW5nYm8gTHUgPHlhbmdiby5s
dUBueHAuY29tPg0KDQo=
