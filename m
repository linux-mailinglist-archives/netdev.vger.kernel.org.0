Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEEE3822DC
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhEQCrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:47:23 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:50406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229661AbhEQCrX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 May 2021 22:47:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VsfJd0/sWHogqquk6IH4qyYw7CrAmSY34CASgZ0RlEjqhkZ2SkJywJTgaSh3MzRvu2jbP7I0z1LDrQA4xCZxXxZiTUh8nXxkrhf3IcuMDUxoX2JYg1YnlzfzXf9FqI6vhjhl79BAPKof0VOdzWgQE35QlbfdUsNnA7zV+ZZyB7fhB2ozoctTCfEjjgHX+RQv/he3CcsVZg1N85tuSb7QXNXCjb/EyRDmNabsEBnAwGGktpLhCPUaBrMPXOluFGdfiGhlk+sPnjP6TZqm4kPWlQnlFy05Bdfd2bOUajTL0aAlVUBBOlYbeKccLZsLhxWEfDv97qV3fPPfPhN64tyCng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvPUmXy5Rikp+OthOuF4WpsSYUhk4C5X+PWJMtcqEO0=;
 b=miRrRaiH2opxDmJy9c+oAkywpms2gMnv3bxd9tklseObKvpYoXklQKA1hKriiYoyXgJUYgdDPyOGdsNl6iqa30pCrQTOvkbXUvvxwcXOPV8sl/s4cgmjnqxJKgijY9VB3bP3moYWbUkTcmoyiu85nS+okh1oCkyyQyhPB3xbHXW+qJfCzUjC6umw/zaU5ajvoyCxX9FX7oaUcr2Rm0EgFhFO6YwcF7A4QjcXSD5NxdAxkAwUBJo2i9J+uR626DRnrJgkpxLouT0/RUGnWuJz860EtQAKqFj+aafRyAxiDzcq5zgS1rpLA6oDAernMI3P3W7iCqa0kDyp88HItI+qAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvPUmXy5Rikp+OthOuF4WpsSYUhk4C5X+PWJMtcqEO0=;
 b=Dx7IQ7a0khAKy/TY2O8oyyyMU4eltVRbIUh/IIbPDdh5iiLsml/pm8Y+W5C9yiPeXkPnPbqvN1HIkkmySqS5BhGFRxF8vkWpNgWWVoS3Ou2greSC7YvuTdzBeYwjcbu4mkp7V3+sQjOu1sDHfO90egB74cmiyH+zheLXkD8AhUQ=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DBBPR04MB8041.eurprd04.prod.outlook.com (2603:10a6:10:1e2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 02:46:05 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc%6]) with mapi id 15.20.4129.031; Mon, 17 May 2021
 02:46:05 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Topic: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Index: AQHXQx2n9odSkzWl/E2JdNuSb7aRparZ90oAgAIIfCCAAV+UAIAAqM9QgABsJgCAAq33AIACKTUAgAO7qvA=
Date:   Mon, 17 May 2021 02:46:05 +0000
Message-ID: <DB7PR04MB5017A20680D117571A568905F82D9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210510231832.GA28585@hoboy.vegasvil.org>
 <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210511154948.GB23757@hoboy.vegasvil.org>
 <DB7PR04MB5017D35C76AAEDEE0319DA12F8509@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210514174458.GB19576@hoboy.vegasvil.org>
In-Reply-To: <20210514174458.GB19576@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c8382bd-2c1c-4899-791e-08d918ddeadc
x-ms-traffictypediagnostic: DBBPR04MB8041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB804149EA84691071FF693D90F82D9@DBBPR04MB8041.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OnA4vhIKmoqYLPv/JFviQkeeFFFRYHOcN0xNBr8XSTzv38UCK1ytRQNn9HW9Ox1zJHC2ysC33nUYn2BK7xRoVWm02Mc5P3+8jvsqUxL50pqgelBa+smHZ+iLGEWAsi6CMs53+GQr4XxOnWBrtjP8b1SObtHY67x9Hcr9Z0VHUCiccD4yYDwUJzf/5cUzeyimepCTAAJPGx+L7SkZ7apjZlyE/PPXwNJ+fVtiNzXEIeI7JIk/uikw6CHM+Fbu1Vh1DfQMhWpJJkCn+PSI9tRCrPNN/u9LNN+DbN4REzRtftPRzhvPyoCflhoaAPX25eG9NjkuSEzMa9JY28DCgSdL3uUN6HlvK8ZtjJa1/J6B72l1RSrWPBUev47PQ2aMX/MDCNA7n9S1OiMFFrFz6nMqtBwX0SPi8znZPjeQKX9HYklnnGcM01rXPxwHArl+n3/o5nu/GqdNhlv58rexcE+LN9/6DB+8vHt5X37skkebLnaDozn19tgEiWzHBpVIUJ4u9eUEkJG5FBZJAy99EwbDMbUMz74TQsk6xQr8DkcYUjP3MN8NhYXtiOx9rThbkpnV1+KXWxap8YKPCMpl5GpxZ9DDrv1EBFKlAl0znrBnbKI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(5660300002)(8676002)(66946007)(186003)(86362001)(66446008)(64756008)(8936002)(38100700002)(122000001)(66556008)(83380400001)(71200400001)(6506007)(53546011)(4326008)(9686003)(55016002)(6916009)(7696005)(26005)(2906002)(54906003)(33656002)(316002)(76116006)(66476007)(52536014)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?T1FyR0ZqdldEVU44NFRaamZkVFpaUEFMWVdaRWFEcm0wQkxDcGRhcjBJanRo?=
 =?gb2312?B?cXlNcC9oRVBWUmJnZWg5eWE3M0lLVDV6bE40TGNFK2p1VllTZnAxMFVMS250?=
 =?gb2312?B?dnRNQkcyRGNnK0p6bUZ3MmQ5UGl2c0VCNGV1REthUVFPVXlGMHR0Y1l4Y2Vo?=
 =?gb2312?B?WXgveFBWaDFCSjkrRHZlWkJQOGxJTzYxUFpVV3daSjh1Z2tIc212YjFDVmFr?=
 =?gb2312?B?bDVWM2RBUGpHb0RKbDFwV1E3Vjc5dmtwMEZscUtaOHcwZm9IRUhqY1lqVzI5?=
 =?gb2312?B?alZHSi9ORUIrcWE4TUZoSE9NYnRVc3p2UlhJY3pqbER1eWV1WER4R2F2cDYx?=
 =?gb2312?B?eHlkNGtnS0xRZWpmQWNxMmw4ZGg2RDY4MkJ0ZlJLNzRSRkNVZWlabVFKTGxO?=
 =?gb2312?B?VkNiV29EczZkWkJRWExrYWN5VHAwUWY1S1pYNWorZW5FWngyVGFhbUpWeGhz?=
 =?gb2312?B?bUtaTHpGZFlVUXFWV3NRVUE1eWpIeWdWQTRWUHFNcGRHajF2cmhkYzBlN1Ns?=
 =?gb2312?B?MTF0TG1qNWYzdVNUZUxGMkpHRTZJTkc1WGJCMkRXSFUyZkF4bWtvVWVhKys2?=
 =?gb2312?B?eG5kUHNvQmNsSUQwd0RvdXBiWXlTNTI1dFFNd21yZ1g1ek56MWVzbm82SERF?=
 =?gb2312?B?dlIvTkoxTG51NDhJYkpzWFB2eFVGTVJGditLdXNwSGpzd1RxWjVFdHZoZGp6?=
 =?gb2312?B?WWMzZGVpdmp2YVVFSjdGb1RUNUNJVWZYd2twV3JHTzR4MWVzNk04R3g5aW1j?=
 =?gb2312?B?UVprVTVaWG53RCtvRkVPVHU1RHB2RXkvYVZ6REJoeUQwbkN1bFIwOW5BNmtx?=
 =?gb2312?B?TWNnZkVCUHpBNURBRmc2ZGhiYnIwVGJGNnNLZngraDBTSjNwT3R3dllvS1dH?=
 =?gb2312?B?QzJVVWJBcExYL2tRTjd0N1drdGRJMXQ0U09DRFJ6RWQrUVNUQkxDMGNqK2gy?=
 =?gb2312?B?SmY3SXZlZlduMWZtdHZNVGkzT1N1c1UxdVFELzFlb3NPV1BLajJJSlU4M1BV?=
 =?gb2312?B?TDduK3cydUxFZGlUaS9FK0hrRFlPaXhCbVN6Uk1Ia2NxOENpNkMyYlJ4Y0ty?=
 =?gb2312?B?OXY5UXBjNGhDT0d4R2VvVGpoU0ZuQ2JuN3BuR0c1K25nTjJTd2lNTnRkRnJW?=
 =?gb2312?B?UjNKWnBRQllicjE4bWc5WW1EZkJMUjE3NnlmUkprd1pSSUxGWnlUZ0szYjUx?=
 =?gb2312?B?czh4b29zSnJObGJJeTcyVjcyZkh1UFM4NEhES2c2cXV0cnRJUVBuUHovZ3J4?=
 =?gb2312?B?SExLNFN2ZjRST0I0Z1h4TGE0bGY1S0crbkR1KzJjdUtiWUNsSlMzdEVNQXRN?=
 =?gb2312?B?dnpldWVrR3FxdEZ4VWFmZU1uRDVxbFZsWmlWTWV5cXFON0tXQUtObCtDVG00?=
 =?gb2312?B?SnhIWHVCUnJ0NGVjK1Z3eG1DNWIzOWxSS1lKME14dVBpQTZ4b3hPc0dqWkp0?=
 =?gb2312?B?TVpOaXhRZnlZQzMwQ0xDNHR2c1ZxVTEwc1E0TllLN0RHanRkTXdXalJUK245?=
 =?gb2312?B?dGZFeXRaalhBSG9mREpCdW5BZDJ5TDRzdXMyYzh1RFJoRTF5SFFrRmd3cFNB?=
 =?gb2312?B?LzhVTnpIcjRDcHdnS1cxclNQQWZsTCtrZS8xalo3bUdKVE12dVpMN3I4VkZI?=
 =?gb2312?B?cEwwM2hhUCtwTEU1Ri9Yc1RGYzI4cW9uMTZGcys2SzdRaEpCZUIyMXJ0dVlu?=
 =?gb2312?B?bndoZlU0YU54RDhEd1MxdXlGaEc3dWhIVXhDT08vc1ZpUllmMGhOWFlLTEpp?=
 =?gb2312?Q?t+Z2XcfSWeTjRGxYIDquVCBrCSd+d2uPWFxD/1S?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c8382bd-2c1c-4899-791e-08d918ddeadc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2021 02:46:05.5513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JR4rVc6N6GwczOW0Oxx/OrRzV2IAl30XedWjFDZp26yMm6AGC72ZEP9kgGph7mbh8x7SVKMET3eunl9Z7kAlSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8041
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMTXI1SAxOjQ1DQo+IFRv
OiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBDbGF1ZGl1DQo+IE1h
bm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgMC82XSBwdHA6IHN1cHBvcnQgdmlydHVh
bCBjbG9ja3MgZm9yIG11bHRpcGxlIGRvbWFpbnMNCj4gDQo+IE9uIEZyaSwgTWF5IDE0LCAyMDIx
IGF0IDA2OjQxOjI4QU0gKzAwMDAsIFkuYi4gTHUgd3JvdGU6DQo+ID4gSSBnaXZlIHVwIHN1cHBv
cnRpbmcgcGh5c2ljYWwgY2xvY2sgYW5kIHRoZSB0aW1lY291bnRlcnMgYWRqdXN0aW5nIGF0IHRo
ZQ0KPiBzYW1lIHRpbWUsIGJ1dCBJIG1heSBjb250aW51ZSB0byBzdXBwb3J0IHZpcnR1YWwgY2xv
Y2sgcGVyIHlvdXIgc3VnZ2VzdGlvbi4NCj4gDQo+IE9rYXksIHNvIHRoZSBwaHlzaWNhbCBjbG9j
ayBzdGF5cyBmcmVlIHJ1bm5pbmcgd2hlbiB2aXJ0dWFsIGNsb2NrcyBhcmUgYWN0aXZlLg0KDQpZ
ZXMuDQoNCj4gDQo+ID4gR2V0dGluZyBiYWNrIHRvIHlvdXIgdXNlciBzcGFjZSBpZGVhLCBJJ2Qg
bGlrZSB0byB1bmRlcnN0YW5kIGZ1cnRoZXIgdG8gc2VlIGlmIEkNCj4gY2FuIG1ha2Ugc29tZSBj
b250cmlidXRpb24uDQo+ID4gQWN0dWFsbHkgSSBjYW4ndCB0aGluayBvdXQgaG93IHRvIHRyYWNr
ICh0aGVyZSBpcyBub3QgdGltZWNvdW5lciBsaWtlIGluIGtlcm5lbCkNCj4gaW4gYSBlYXN5IHdh
eSwgYW5kIEkgaGF2ZSBzb21lIGNvbmNlcm5zIHRvby4NCj4gDQo+IE1heWJlIEkgd2FzIG5vdCBj
bGVhciBiZWZvcmUuICBZb3UgY2FuIGltcGxlbWVudCB0aGUgdmlydHVhbCBjbG9ja3MgaW4gdGhl
DQo+IGtlcm5lbC4gIFVzZXIgc3BhY2Ugd2lsbCBub3QgbmVlZCB0byBiZSBpbnZvbHZlZC4NCj4g
DQoNClRoYW5rIHlvdSB2ZXJ5IG11Y2ggdG8gbWFrZSBpdCBjbGVhciBmb3IgbWUuDQoNCj4gSXQg
aXMgZWFzeSBmb3IgdGhlIGtlcm5lbCB0byBoaWRlIHRoZSBwaHlzaWNhbCBjbG9jayB3aGVuIHZp
cnR1YWwgY2xvY2tzIGFyZQ0KPiBjcmVhdGVkIGZyb20gaXQuDQo+IA0KPiBUaGFua3MsDQo+IFJp
Y2hhcmQNCg0K
