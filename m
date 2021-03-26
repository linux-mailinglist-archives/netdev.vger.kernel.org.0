Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D8534A339
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 09:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCZIgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 04:36:53 -0400
Received: from mail-eopbgr30047.outbound.protection.outlook.com ([40.107.3.47]:8773
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229682AbhCZIgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 04:36:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBVrMswr827Hf12rLUzmba+SJwUt0svU3SPqThABb+REcTnibApkKWdr5vfmRtAVtiRDCyHaqoOdJ7Eu3eDTzECvio2HTMjVFHYQP8A3Q5fbLaJo8ladDRjHJF0L+XXz4DlmikTvGvLFwpt2tLH17NP3/BsFHX0YK+paP30WeB1sVev6G1IbW0BjOWT955y84SKh5wvtF6CxOBudJJdxzSLBpUrtgn4UKrQehPgUAdCAmmQCqpVbXnvxo54AoXSeYA7aO+Oq097jNeLVEzLfmJczWtbGJ+Mf1lwRA7/3wAYTHVucTM92No1nc+RljSCAP7b7pEf05TsmKJRUk0IQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvtGSzOZbKe6FlA22y5RFvr4yovbF0APIz8z+waD0Go=;
 b=ABXOkuZ0nBRkRWtoMO8YF+Xxm2Z5/7yeH8F+IMqQ+uzQEs4wbB0FDWTvC1kciv9dteGOx+igcshT6e9CU1bcD1a6IcY0KA+98B2OTzYpAFkNmu56MTcINnMNjPIWrBBvyleHhGPK+cwqOPxkmD85ruTJF0+8HjUpXMKsMQhrPIChHzA5VxWq+QN2LKZ4PjAO0Ws8B/t0eQHx+Q0XUGFNZ2twH1wz5g9CVR1J6gbt0ZINfb8Esavje1AKug9kNJPNm0nwZyjZAXw7zFVFoXuO0gwg1YCioAfYbJ7ZFUnHmTF3quKq78RczOM8EWYV0S+krjuSHAxD1awIAEXYOE9QWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xvtGSzOZbKe6FlA22y5RFvr4yovbF0APIz8z+waD0Go=;
 b=ZdQDahaV9pHq7KfcQ/DhfEANwABXsWpIo+SSzLturBM76iET6tTv+aE9ktm3FqVIKqCoaGGRp7GYrjBLVf4sbNOJDkLJro6zJDFhtVONvNw9U9+i16MQ/35w9vur+y1Ar+yMJvgS1CZjTHxepI31pFcEZ7uyyq03tL0jKJgSGxI=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7994.eurprd04.prod.outlook.com (2603:10a6:10:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Fri, 26 Mar
 2021 08:36:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Fri, 26 Mar 2021
 08:36:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: FEC unbind/bind feature
Thread-Topic: FEC unbind/bind feature
Thread-Index: AdchTA4mhHE+X6FhQBmQJxJLMagesAAKJ/aAACgNBSAAAM4PMA==
Date:   Fri, 26 Mar 2021 08:36:35 +0000
Message-ID: <DB8PR04MB67952CC10ADC4A656963D871E6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <DB8PR04MB6795E5896375A9A9FED55A84E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YFyF0dEgjN562aT8@lunn.ch>
 <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB679514359C626505E956981BE6619@DB8PR04MB6795.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dcecee1a-9d99-46f1-4ef2-08d8f03243ee
x-ms-traffictypediagnostic: DBBPR04MB7994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB7994306C3524A2F42F2FC07FE6619@DBBPR04MB7994.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aceOPe7pT9yX6qHNqqvx42TBvq6rML6Onf30WykhuJIsuNTq+U2nqcT3iLC9o+CznKXpamx+Q/InyjLneh1bbG3L4GbUmSpeGqz3FjO6663IrZ1zTGQipkgBxO/Q+zfD+6lbyyh/gyxwx7gMvzaZTQljCRm8yGfaxNSZs5mgYa9ylaeItbph290kuqDLhhpk9JLoqfo/q/9zVbM0972+g1/+3FvMEtYY+0MazRgPteppMv2pwYifjuK6lgkY2FK22mIqkJU8uUur3+kYKWz55JpLChqu0Hokn+RHOIHB4+N6V2zWyNnsfVv+/WsJoLjn5RNiSTqUDn4/iJ3cPeYsE3SfsqCQMbhx+NiQL5rnxo+qAhahuxIOvt7brlxVs5sWwbobWe7fnzWbM9UGeDOaeT87YQjZOhoRzEXMuTZ6FkZ+5Q9r084u3Ql2sGqdQi6XLURm9ByZJcz8lyJa2AybMgHh9qv1D2eccfcmbVZqseeOTRdltTqj89jJMLyMzaCZXCsM4yOmFgm9Sd9ynrPcl1Za9weQ1cxTkSALFMhFM7uc3VpwdM16hYU5zsoQINaeqsgoykht5C/E4uSSwKgw1LaDoaXAkakOgdjLfL/YDU4o/VtCaMVk0ZmCXmvPoFEfPexJlQe8Xs6SOuiLFkBiiS2v6W60Bc/k+DQ5kEToOU/iClUSAf+hnFPiG6yDXwXcHyuJvoAAiR0P/1R5taiFagc1Zu3eGN840wxlG1lLt6w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(83380400001)(26005)(9686003)(2940100002)(186003)(84040400003)(55016002)(38100700001)(54906003)(316002)(33656002)(5660300002)(52536014)(6506007)(53546011)(86362001)(45080400002)(478600001)(64756008)(66946007)(2906002)(66476007)(71200400001)(76116006)(66446008)(8676002)(110136005)(66556008)(7696005)(8936002)(3480700007)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?RmZVTng3R0dtWXBFZHlTbytZc0ZteTRIcVZzbkdaZEhWbE5GWlhidjZSOXVW?=
 =?gb2312?B?MG1OSUVKbTJxem9hRDJPKzNLbWYzY2RpQnhxd05jaXVFbm9xcW5wZ0hxWVBE?=
 =?gb2312?B?azdoS1I0WkJBVVYrYTBXOE5tcHNDdm1WcUNwUEpzbG1LMzAzRHFDVTFqUVI3?=
 =?gb2312?B?eHF6aStXd25iQTlQdUJwem54Z3ZPN1F2Nnh0ZXB2MWpOd2QrWXBjRC9DR0hO?=
 =?gb2312?B?QUZNalVOV1c5SGx2Vy9IY0hnWWFLeGwxQXhFbWQvNjA3S0d6RVpSWU5NV3Rp?=
 =?gb2312?B?WXZSeGVnZDNVS013ZjF3ckpKcTN5amQ3SGpKN29TcnZjN3ZCTmcybGVkVUFu?=
 =?gb2312?B?Q0M1QndVbnU1NlEzWVVOY1JFOHZyR2V4Rit1Q3ZGd3dMWlFSOG1TcUs1Vy95?=
 =?gb2312?B?aHVYSEtRdEtxTkhodUxPaXhkRS9Yc2lFMXZManZiUGNUdnVuOG5McWtJZzBN?=
 =?gb2312?B?alNhZ3l2dVM1TUJkMnpVQWcvMTFqbU01UldwcWRQL2lmNkJjU3VxVHZqa0RY?=
 =?gb2312?B?L0x6RzJrbDRKUEgzbGtkb2lIdm1zbFFmeHduT2VMSjlPMExuNFBFUENiUm9q?=
 =?gb2312?B?TXZzRTZjZ2M1Y01KaGI4d3BMV2NHYWl5Yjh5VGdpVHN6ckY0Y1hFc3hTV2wx?=
 =?gb2312?B?cXBLSjlnNHJ5NUFwTmkyV0pTNGdab1RFOUZMKzdYRmV4SXZyU3BBRVZCbjFW?=
 =?gb2312?B?aHJ6Y0lYMTVDWklMNG9YZExRN1RGZDJUMW5oc1RKSmRBcmd3L3hQK05XVHpY?=
 =?gb2312?B?eVAxL29hdjZPQjI5NUFvbURRR2JJVnpyam53S1RGSEtROGdjdlZycGdyaUNy?=
 =?gb2312?B?L2F1Zm1oa0VTa0JPUmNzQk51bSszeHlUZEJuYVA2NzBVRW51Mjl1eDZDem5a?=
 =?gb2312?B?UmtQeXoySEdZNDlZQ0NtNUxEMkRRQnVyMkw1MitOTUtIeVpuMVplNHNIbzJR?=
 =?gb2312?B?ZStJUU5yRFQ0TVNPUFNUOS9DQ2dQTWh3M3N3K0tvMkFPM3BYUjhZdmhYWFM2?=
 =?gb2312?B?TkxLUjQyUU1yUXNJZ243Mmo3Vi9pQ1VQWEw5NGFpVDB6cUFjbzQxeHo4b0tQ?=
 =?gb2312?B?WEZrSHA1Zk1EZXA5Qmk1NDZoOGx6bVRuVlFqKzVjNXdobU50TUpjT1JudXJT?=
 =?gb2312?B?SzlTQUZ6NHF2RXdBT1o2WTJZeEtHSDJkQzNEdGdiMDhUOXgvem5kY3hHYVdG?=
 =?gb2312?B?cXFqSmhSMHhzNTJKcmF4TTgvYVlPdEFuTERwWS8wblVHVENBWXZUNFNaTlc3?=
 =?gb2312?B?TzcxeU5kbGdTdzcrRy9GeWZsd28wNysyUmtMK09FM1NaZGlLMllFZWxvZ2Fn?=
 =?gb2312?B?NVorVTMwc2NRa1RCbjZaL3FQM1RYbjZBbGtsN0V6VW9WUmg3RmRxbmhYRzFQ?=
 =?gb2312?B?SFVmd0w1bHo3TEZocitVRkpYTWF4NXJuWklUaEgxZ2lCNkNHb1E3ZGt4Smlr?=
 =?gb2312?B?cjZpcjRTUTlCT2pIVER4N1BjWEtWMitja1l4RmhJZTJSTERyOVZkSHhvNnpk?=
 =?gb2312?B?Q0YrazdsNUl1UjZydzBYMWpaK3NlTHFwTk1ZZTlBL1BvQXhGZ1FFaUloeUNO?=
 =?gb2312?B?czF4T0xsb3VSbzZaemViaG51c1RrYnFrQ0dJQUVwOHNHSTg2bEcwRkkvRUJY?=
 =?gb2312?B?ZnlTUkgwZzdzTHJmMVh0M1lqTDAvMlVVN3hPb3lXdXd5S3N4MGFLc2ZtMXBa?=
 =?gb2312?B?QnBITVQwWlkxTVk2Q0JZcExqaWlwNFlxYm9pR0xYT0RuU0FTVXBvTXlaOVJ0?=
 =?gb2312?Q?Gy//CSNN36U7oiSC3FTtWAkVCK9OuO3VNgSGha3?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcecee1a-9d99-46f1-4ef2-08d8f03243ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 08:36:35.0442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2z3vCmNRu7oaCyyWNDsBn37AxEf5tBJUjYcBCLCQRB3Y6uw4fg582C2kVgu4LEbxKejlDF+d6yv6CRww13VqxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7994
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjHE6jPUwjI2yNUgMTY6MDMNCj4gVG86
IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gQ2M6IEZsb3JpYW4gRmFpbmVsbGkgPGYu
ZmFpbmVsbGlAZ21haWwuY29tPjsgaGthbGx3ZWl0MUBnbWFpbC5jb207DQo+IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUkU6IEZFQyB1bmJpbmQvYmluZCBmZWF0dXJlDQo+IA0K
PiANCj4gSGkgQW5kcmV3LA0KPiANCj4gVGhhbmtzIGZvciB5b3VyIGtpbmRseSByZXBseSENCj4g
DQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBBbmRyZXcgTHVubiA8
YW5kcmV3QGx1bm4uY2g+DQo+ID4gU2VudDogMjAyMcTqM9TCMjXI1SAyMDo0NQ0KPiA+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiA+IENjOiBGbG9yaWFuIEZh
aW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT47IGhrYWxsd2VpdDFAZ21haWwuY29tOw0KPiA+
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWJqZWN0OiBSZTogRkVDIHVuYmluZC9iaW5k
IGZlYXR1cmUNCj4gPg0KPiA+IE9uIFRodSwgTWFyIDI1LCAyMDIxIGF0IDA4OjA0OjU4QU0gKzAw
MDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiA+DQo+ID4gPiBIaSBBbmRyZXcsIEZsb3JpYW4s
IEhlaW5lcg0KPiA+ID4NCj4gPiA+IFlvdSBhcmUgYWxsIEV0aGVybmV0IE1ESU8gYnVzIGFuZCBQ
SFkgZXhwZXJ0cywgSSBoYXZlIHNvbWUgcXVlc3Rpb25zDQo+ID4gPiBtYXkNCj4gPiBuZWVkIHlv
dXIgaGVscCwgdGhhbmtzIGEgbG90IGluIGFkdmFuY2UuDQo+ID4gPg0KPiA+ID4gRm9yIG1hbnkg
Ym9hcmQgZGVzaWducywgaWYgaXQgaGFzIGR1YWwgTUFDIGluc3RhbmNlcywgdGhleSBhbHdheXMN
Cj4gPiA+IHNoYXJlIG9uZQ0KPiA+IE1ESU8gYnVzIHRvIHNhdmUgUElOcy4gU3VjaCBhcywgaS5N
WDZVTCBFVksgYm9hcmQ6DQo+ID4NCj4gPiBQbGVhc2Ugd3JhcCB5b3VyIGxpbmVzIGF0IGFyb3Vu
ZCA3NSBjaGFyYWN0ZXJzLiBTdGFuZGFyZCBuZXRpcXVldHRlDQo+ID4gcnVsZXMgZm9yIGVtYWls
cyBhcHBseSB0byBhbGwgTGludXggbGlzdHMuDQo+IA0KPiBPaywgdGhhbmtzLg0KPiANCj4gPiA+
DQo+ID4gPiAmZmVjMSB7DQo+ID4gPiAJcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsNCj4gPiA+
IAlwaW5jdHJsLTAgPSA8JnBpbmN0cmxfZW5ldDE+Ow0KPiA+ID4gCXBoeS1tb2RlID0gInJtaWki
Ow0KPiA+ID4gCXBoeS1oYW5kbGUgPSA8JmV0aHBoeTA+Ow0KPiA+ID4gCXBoeS1zdXBwbHkgPSA8
JnJlZ19wZXJpXzN2Mz47DQo+ID4gPiAJc3RhdHVzID0gIm9rYXkiOw0KPiA+ID4gfTsNCj4gPiA+
DQo+ID4gPiAmZmVjMiB7DQo+ID4gPiAJcGluY3RybC1uYW1lcyA9ICJkZWZhdWx0IjsNCj4gPiA+
IAlwaW5jdHJsLTAgPSA8JnBpbmN0cmxfZW5ldDI+Ow0KPiA+ID4gCXBoeS1tb2RlID0gInJtaWki
Ow0KPiA+ID4gCXBoeS1oYW5kbGUgPSA8JmV0aHBoeTE+Ow0KPiA+ID4gCXBoeS1zdXBwbHkgPSA8
JnJlZ19wZXJpXzN2Mz47DQo+ID4gPiAJc3RhdHVzID0gIm9rYXkiOw0KPiA+ID4NCj4gPiA+IAlt
ZGlvIHsNCj4gPiA+IAkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQo+ID4gPiAJCSNzaXplLWNlbGxz
ID0gPDA+Ow0KPiA+ID4NCj4gPiA+IAkJZXRocGh5MDogZXRoZXJuZXQtcGh5QDIgew0KPiA+ID4g
CQkJY29tcGF0aWJsZSA9ICJldGhlcm5ldC1waHktaWQwMDIyLjE1NjAiOw0KPiA+ID4gCQkJcmVn
ID0gPDI+Ow0KPiA+ID4gCQkJbWljcmVsLGxlZC1tb2RlID0gPDE+Ow0KPiA+ID4gCQkJY2xvY2tz
ID0gPCZjbGtzIElNWDZVTF9DTEtfRU5FVF9SRUY+Ow0KPiA+ID4gCQkJY2xvY2stbmFtZXMgPSAi
cm1paS1yZWYiOw0KPiA+ID4NCj4gPiA+IAkJfTsNCj4gPiA+DQo+ID4gPiAJCWV0aHBoeTE6IGV0
aGVybmV0LXBoeUAxIHsNCj4gPiA+IAkJCWNvbXBhdGlibGUgPSAiZXRoZXJuZXQtcGh5LWlkMDAy
Mi4xNTYwIjsNCj4gPiA+IAkJCXJlZyA9IDwxPjsNCj4gPiA+IAkJCW1pY3JlbCxsZWQtbW9kZSA9
IDwxPjsNCj4gPiA+IAkJCWNsb2NrcyA9IDwmY2xrcyBJTVg2VUxfQ0xLX0VORVQyX1JFRj47DQo+
ID4gPiAJCQljbG9jay1uYW1lcyA9ICJybWlpLXJlZiI7DQo+ID4gPiAJCX07DQo+ID4gPiAJfTsN
Cj4gPiA+IH07DQo+ID4gPg0KPiA+ID4gRm9yIEZFQyBkcml2ZXIgbm93LCB0aGVyZSBpcyBhIHBh
dGNoIGZyb20gRmFiaW8gdG8gcHJldmVudA0KPiA+ID4gdW5iaW5kL2JpbmQgZmVhdHVyZSBzaW5j
ZSBkdWFsIEZFQyBjb250cm9sbGVycyBzaGFyZSBvbmUgTURJTyBidXMuDQo+ID4gPiAoaHR0cHM6
Ly9ldXIwMS5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJG
JTJGZw0KPiA+ID4gaXQNCj4gPiA+IC5rZXJuZWwub3JnJTJGcHViJTJGc2NtJTJGbGludXglMkZr
ZXJuZWwlMkZnaXQlMkZuZXh0JTJGbGludXgtbmV4dC4NCj4gZw0KPiA+ID4gaQ0KPiA+IHQNCj4g
PiA+ICUyRmNvbW1pdCUyRmRyaXZlcnMlMkZuZXQlMkZldGhlcm5ldCUyRmZyZWVzY2FsZSUyRmZl
Y19tYWluLmMlM0YNCj4gaA0KPiA+ICUzRG5lDQo+ID4gPg0KPiA+DQo+IHh0LTIwMjEwMzI0JTI2
aWQlM0QyNzJiYjBlOWU4Y2RjNzZlMDRiYWVlZmEwY2Q0MzAxOWRhYTA4NDFiJmFtcDsNCj4gPiBk
YXRhPTANCj4gPiA+DQo+ID4NCj4gNCU3QzAxJTdDcWlhbmdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3
QzRhYzI2NmYxZWY1MTRiZDA5ZTljMDhkOGVmOGINCj4gPiBlZTMzJQ0KPiA+ID4NCj4gPg0KPiA3
QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2Mzc1MjI3MzE1NjE1
MDUzMDgNCj4gPiAlN0NVbmtuDQo+ID4gPg0KPiA+DQo+IG93biU3Q1RXRnBiR1pzYjNkOGV5SldJ
am9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaA0KPiA+IGFXd2kNCj4g
PiA+DQo+ID4NCj4gTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1kc3RHQUlod0h0THQz
WVc5RDhwOEw1Y05weElXTA0KPiA+IGgzd0t6UW1McA0KPiA+ID4gb0dHZ0UlM0QmYW1wO3Jlc2Vy
dmVkPTApIElmIHdlIHVuYmluZCBmZWMyIGFuZCB0aGVuIGZlYzEgY2FuJ3Qgd29yaw0KPiA+ID4g
c2luY2UgTURJTyBidXMgaXMgY29udHJvbGxlZCBieSBGRUMxLCBGRUMyIGNhbid0IHVzZSBpdCBp
bmRlcGVuZGVudGx5Lg0KPiA+ID4NCj4gPiA+IE15IHF1ZXN0aW9uIGlzIHRoYXQgaWYgd2Ugd2Fu
dCB0byBpbXBsZW1lbnQgdW5iaW5kL2JpbmQgZmVhdHVyZSwNCj4gPiA+IHdoYXQgbmVlZA0KPiA+
IHdlIGRvPw0KPiA+DQo+ID4gT25lIG9wdGlvbiBpcyB5b3UgdW5iaW5kIEZFQzEgZmlyc3QsIGFu
ZCB0aGVuIEZFQzIuDQo+IA0KPiBZZXMsIHlvdSBhcmUgcmlnaHQuIEl0IHNob3VsZCBiZSBhbHdh
eXMgZmluZSBmb3Igc2luZ2xlIEZFQyBjb250cm9sbGVyLCBhbmQNCj4gdW5iaW5kL2JpbmQgb25l
IGJ5IG9uZSBzaG91bGQgYWxzbyBiZSBmaW5lIGZvciBkdWFsIEZFQyBjb250cm9sbGVycyB3aGlj
aCBzaGFyZQ0KPiBvbmUgTURJTyBidXMuIEkgdGVzdCBvbiBpLk1YNlVMLCBpLk1YOE1NL01QLg0K
PiANCj4gPiA+IEl0IHNlZW1zIHRvIGFic3RyYWN0IGFuIGluZGVwZW5kZW50IE1ESU8gYnVzIGZv
ciBkdWFsIEZFQyBpbnN0YW5jZXMuDQo+ID4gPiBJIGxvb2sgYXQgdGhlIE1ESU8gZHQgYmluZGlu
Z3MsIGl0IHNlZW1zIHN1cHBvcnQgc3VjaCBjYXNlIGFzIGl0IGhhcw0KPiA+ID4gInJlZyINCj4g
PiA+IHByb3BlcnR5LiAoRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZGlv
LnlhbWwpDQo+ID4NCj4gPiBZb3UgY2FuIGhhdmUgZnVsbHkgc3RhbmRhbG9uZSBNRElPIGJ1cyBk
cml2ZXJzLiBZb3UgZ2VuZXJhbGx5IGRvIHRoaXMNCj4gPiB3aGVuIHRoZSBNRElPIGJ1cyByZWdp
c3RlcnMgYXJlIGluIHRoZWlyIG93biBhZGRyZXNzIHNwYWNlLCB3aGljaCB5b3UNCj4gPiBjYW4g
aW9yZW1hcCgpIHNlcGFyYXRlbHkgZnJvbSB0aGUgTUFDIHJlZ2lzdGVycy4gVGFrZSBhIGxvb2sg
aW4NCj4gZHJpdmVycy9uZXQvbWRpby8uDQoNCk9uZSBtb3JlIGFkZCwgeWVzLCBJIGFtIGxvb2tp
bmcgdGhlIGRyaXZlcnMvbmV0L21kaW8sIGl0IGlzIGJldHRlciB0byBpbXBsZW1lbnQgc3RhbmRh
bG9uZSBNRElPIGRyaXZlciB3aGVuIHdyaXRpbmcgdGhlIE1BQyBkcml2ZXIgYXQgdGhlIGJlZ2lu
bmluZy4NCk5vdyBpZiBJIGFic3RyYWN0IE1ESU8gZHJpdmVyIGZyb20gRkVDIGRyaXZlciwgZHQg
YmluZGluZ3Mgd291bGQgY2hhbmdlLCBpdCB3aWxsIGJyZWFrIGFsbCBleGlzdGluZyBpbXBsZW1l
bnRhdGlvbnMgaW4gdGhlIGtlcm5lbCBiYXNlZCBvbiBGRUMgZHJpdmVyLCBsZXQgdGhlbSBjYW4n
dCB3b3JrLg0KSG93IHRvIGNvbXBhdGlibGUgdGhlIGxlZ2FjeSBkdCBiaW5kaW5ncz8gSSBoYXZl
IG5vIGlkZWEgbm93LiBBdCB0aGUgc2FtZSB0aW1lLCBJIGFsc28gZmVlbCB0aGF0IGl0IHNlZW1z
IG5vdCBuZWNlc3NhcnkgdG8gcmV3cml0ZSBpdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpo
YW5nDQo+ID4gPiBGcm9tIHlvdXIgb3BpbmlvbnMsIGRvIHlvdSB0aGluayBpdCBpcyBuZWNlc3Nh
cnkgdG8gaW1wcm92ZSBpdD8NCj4gPg0KPiA+IFdoYXQgaXMgeW91IHVzZSBjYXNlIGZvciB1bmJp
bmRpbmcvYmluZGluZyB0aGUgRkVDPw0KPiANCj4gVXNlcnMgbWF5IHdhbnQgdG8gdW5iaW5kIEZF
QyBkcml2ZXIsIGFuZCB0aGVuIGJpbmQgdG8gRkVDIFVJTyBkcml2ZXIsIHN1Y2ggYXMNCj4gZm9y
IERQREsgdXNlIGNhc2UgdG8gaW1wcm92ZSB0aGUgdGhyb3VnaHB1dC4NCj4gDQo+IEJlc3QgUmVn
YXJkcywNCj4gSm9ha2ltIFpoYW5nDQo+ID4gICAgICBBbmRyZXcNCg==
