Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEAE39590D
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 12:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbhEaKkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 06:40:33 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:49478
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230518AbhEaKka (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 06:40:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVZk66QESxH3qV+7nMPY+NWZbd4B09AzP8PC1tidx0vL3VpUKBQeZjl/k7MMwixDE1lohLYHF/V9FxntoIukLY7QpEiQfsGb+sNyr+VZKOZWpZTKKxbtUtGPK0PxEOduz2tIG6II/z5aVQLBn1tT4gN/4BvxO1m7e+xBTGX+qcWf29EKYKbdL3ZiU42K2xHG+mDgWLYtCMuFhrt+ApUBRFucMMJFlE5wfSc+zrUPIUEW43tFzyLJTQF6OvbCO0LMORK80dx7+JDDNT6wL98NjXMclxKViB4AhW2tooc6FUSagUJ/jqad54lhT7pv6OhueKX1oLyYf1FaxpsOcltu8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umGSg0AkD2piawKJ74xj1ApEPnBZD/5CPH6M5sSVm6M=;
 b=MOYC3EoBTf5Ih8SD104K+TX2W2hLgbmdT5PuVRYbd338w1PgKruPEOYSdnfxIhuflp3GeVmOtO8XHBnyrenTDvRliXW+DFDysJCu/JmT5wD/+FGBKAM6rOzL70EUAHyrI5uZnJIVQ655njWrfo4tQH+UAxTsrfh959Zc9TsMDnGbq0qdRHuuHt2bc5GWNNGe3YYRN4Yyv0Ve9crJY0Ln73I2kwIPs2cMtT96QmU6eLCiFeVJwGg4yYjvOd8xuevCcn22du9o30Dom7sQ+nDgEJICIE6FHB1pagJmCbWgpSURIJ5J0nv9pZXjA8lxHPS5vme5w9Xklt8vnDA5X6Wx3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=umGSg0AkD2piawKJ74xj1ApEPnBZD/5CPH6M5sSVm6M=;
 b=XL21R2Qkdn+cEtTVqGoh9Fp6/aD1Pzk4vQg/geypTaFjTdFs8o2II7Ehtv/0xk8AdxzY7jNmb3iF2GEicfkADaiOKvwJQ3Pj6nlC7M+IkvpnyoUbWM+U9tfyUzz0w/9TmkvoxY8yl+JeGkY8EOSN3tmOQgjVxcFnJ16IsdTQuUM=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DB6PR0401MB2232.eurprd04.prod.outlook.com (2603:10a6:4:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Mon, 31 May
 2021 10:38:49 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::605f:7d36:5e2d:ebdd%7]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 10:38:49 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next, v2, 1/7] ptp: add ptp virtual clock driver framework
Thread-Topic: [net-next, v2, 1/7] ptp: add ptp virtual clock driver framework
Thread-Index: AQHXTfl68BPm4qUoAU2ajK58ww1YLKrxmAcAgAvdKjA=
Date:   Mon, 31 May 2021 10:38:49 +0000
Message-ID: <DB7PR04MB5017DF46553B6A433DC0075AF83F9@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210521043619.44694-1-yangbo.lu@nxp.com>
 <20210521043619.44694-2-yangbo.lu@nxp.com>
 <20210523212418.GG29980@hoboy.vegasvil.org>
In-Reply-To: <20210523212418.GG29980@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e77e63f2-2348-4341-95e0-08d9242046de
x-ms-traffictypediagnostic: DB6PR0401MB2232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0401MB2232AAF84B6121AA202C7129F83F9@DB6PR0401MB2232.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zs/e82nW6UsaqPLRzPjLGawjsLldp+jqGeo49CaLowMrzmjT+yOBqZUe6jw7Zd3Q+Q8hIQuiL0EPQ4ksmmqueej48hYzC5FEhUTy01J3ofAh4DKgnu+l8w8z7fZ0Uhb/uU6jRbbN42iEOYTu/G4y3nH0SBu/r5ii6wMu3bedNmeUUyCxfS3ObBy7ZSbWDdZUY3x9eR9Zg8zO6gTH+KGxuJ9JjYgabSTz3uyfawKexuCf37up4w/bsaR5seOmemIWTodeGR2sNJfuWH9IBS7OsNzQ2KYjRkYdaee8IQdJcu19fCY+nfEmgayx4czAibreR8CBTwb5Jut5Z+au1tbHybGFoUqBAf5PM89dX81Ws7t0OTSTre2zeR1FI2aXsepx0+HwhUECr8PW4qA9Yl84luwQzKHjbx0Ecydl0DeD7S4wvmdFN6yJN2oZ/GrWxaPNLXLAXJKPdMXkdUppGbtrrA6KeSUXM7NepM4DBPLLpSTpfg7/qH9d6QvmXaE3+I4RBOyFvUVMvfz8BrX5TVWDBbahp/cVuntkPKpx/lEx93RbdOKursCSrEUCmIKlDVPyCdDFv6U9U3M+rQAPQnqzuVUciFVIXdSdY0L6TzBbAZM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(39850400004)(136003)(396003)(83380400001)(71200400001)(8676002)(26005)(8936002)(64756008)(66476007)(76116006)(66946007)(53546011)(86362001)(186003)(66556008)(6506007)(6916009)(55016002)(66446008)(52536014)(5660300002)(54906003)(2906002)(316002)(9686003)(38100700002)(4326008)(122000001)(33656002)(7696005)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Zk82ZEtLaEVqNXBRa0hzWDZ4Mm9xNC9ud1ZXZlFZdDdnUDArU0p2S1kycjk3?=
 =?gb2312?B?SjlwS3FEeGJ6Si96VmdqUU0yMW1TQ0tJZzRVbFFjLzJueEJkVm1VSVlRVFZ6?=
 =?gb2312?B?bUowVjJPQjBZTmI5eVoweTRGeFJ5T3ZTVXgrRDFvZW5oTFpyNjR1TXdDOHZa?=
 =?gb2312?B?My9IU2VQbFlpbE5iUzZ1WHVUL2lwM2hWMjQwWmVoRlJ5SXMremdZNGVNTTJt?=
 =?gb2312?B?TGRLZWJnMHB0YXN2V2N0OGltNXVLSlZpdE1yQ0pRdFlNNFFCR044TU9CUi9L?=
 =?gb2312?B?NVpEb2JpTGx4NjU2WU9uSE5oZXRabVM2QnhnczJIdUdacXFQQmZ4cWhuZlla?=
 =?gb2312?B?SzlYV0hBSzh2NndDd1JXZUd0WkNPdmxyejVJRjNrS0h3emJoa0duV0thSWtu?=
 =?gb2312?B?anVBM2Z2cnRlWVJSSlNJOWRNY2RMOHBqZFk4NW83YzJCOTZDTllTbEx4Umk5?=
 =?gb2312?B?K3ZLMU9Kcm1NUk8rTUJMc0I4NE9WQlZlRkhuN3JyamxuR1FwWkFqQ2U5MmpF?=
 =?gb2312?B?NE8yeWJUR0YxdTlzUDZ4d1EybWRsQjB4a2J6dmJjazRSVHhZQ0RQYXNCeVBY?=
 =?gb2312?B?WTJZbW42TDhxYmZYL20zU0Z6Vm9GM25pd1dtTFVMcW50b24xV2wxaE04aVNZ?=
 =?gb2312?B?dXppakc4Nlgzd2crd21YcW1TYi9ZVUhHSm05U2wwQzhhc2JGeWs1WExNZERK?=
 =?gb2312?B?eDlpNnV2NkhrNFRuYWRZeHVlQU1pcWh3NEZUQ1ZvUFhsV1BWanVub29qNENS?=
 =?gb2312?B?b3J2SnFIZGVuNmFTeFVoakhBM0s0T1VUQlVtUzZZTTVUTlFJeDIwUXNaS2FU?=
 =?gb2312?B?emRTZkd4VXoxTG5UZlNpYXpHM0lWZjQ4Yi9EZHVrMFd2TElMSlg2U0VtSlo0?=
 =?gb2312?B?blhzc1lJdmpVcWdaK1FYRjNJQ0MrRXJaN3BodUlsUlRqUEtGRk1qa2hZRlVJ?=
 =?gb2312?B?RFNzQ0JKZllvL1NIQWgvZkJ1TlBhUTRKd21KdUxHYXJXQVFaNnVraGhXTnp6?=
 =?gb2312?B?dGFaMjRwNzhBSE1HUzh2ZnRudFlhaTNPN0tjNHpLQTJVNEpnbTU1TUQvanpM?=
 =?gb2312?B?RkhyN1BDTDFlcFhjTFltWkVCdGNMekJpZEVxYkpJU28wWVQ5dDRUTjd0RFRj?=
 =?gb2312?B?UjBIbnY5a2hPQVZMSVMwOWNLYTZ4RzVvZXJ0UDBhRFVuMEtqamR2Z1g0S0ZV?=
 =?gb2312?B?bTdmdktpdEw2a3phRGNGMWJEby80UTRGZllkaWZ4RURGWkFXOVA3S0hNdi9t?=
 =?gb2312?B?ek5JenpmeW9NQ0xMazFCaXc3YjFuOTZuSVowT2hpaGNocVhXRXdGdDBBUDJH?=
 =?gb2312?B?cVZaZmdidEEyTmtZTFMwY012a05LcWQ2MkpseXkxczRnTHlydmpqYzF6UVlL?=
 =?gb2312?B?MHNnY2Q2WElpY09wMUs4b2crN0pGWVlxb3dYMWVKVHdVcy9lYW0zOVlwZEpH?=
 =?gb2312?B?Zll0N0prY04xYU5DMEpZd2R4TlA3enJQQnFKUlVLSHhrUXo2SjJuYUNNbkFn?=
 =?gb2312?B?SlBLR2h0aTlLcEhRN2owN21ENHhSamVtcUY3dFZEN05HdXA5dWhUOEdzVFFl?=
 =?gb2312?B?dXpCR1JZS1o2UngxK2dGNUI5ajJ1VFAxano4OUxRc2JIbklneEUrczNjWTI2?=
 =?gb2312?B?Tys0UHlhckZzM24yNVVsTHJMWHpyZjJOck11TnFQVXpCOG52Ryt1dDJsZ1c1?=
 =?gb2312?B?UnF6L3JUejR2VnpIbURWVmdESVpaMktqSmlXUDZwVTVvTUtZOTl2UHNHNW94?=
 =?gb2312?Q?dFwzWZgYs33yISz70D6DnnJDpe5hK8ys8TMlCgg?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e77e63f2-2348-4341-95e0-08d9242046de
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2021 10:38:49.4972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UXiR6Ee9iw2Q1kKe/BjcO6mxCjPg3hKBNmBs9ZvikdMGf7BwxpYPd/a5gLfDng7NCXAuTjM2m2yaQlexT+nqNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNoYXJkIENvY2hyYW4gPHJp
Y2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTCMjTI1SA1OjI0DQo+IFRv
OiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBDbGF1ZGl1DQo+IE1h
bm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQsIHYyLCAxLzddIHB0cDogYWRkIHB0cCB2
aXJ0dWFsIGNsb2NrIGRyaXZlciBmcmFtZXdvcmsNCj4gDQo+IE9uIEZyaSwgTWF5IDIxLCAyMDIx
IGF0IDEyOjM2OjEzUE0gKzA4MDAsIFlhbmdibyBMdSB3cm90ZToNCj4gPiBUaGlzIHBhdGNoIGlz
IHRvIGFkZCBwdHAgdmlydHVhbCBjbG9jayBkcml2ZXIgZnJhbWV3b3JrIHdoaWNoIGp1c3QNCj4g
PiBleHBvcnRzIGVzc2VudGlhbCBBUElzLg0KPiA+DQo+ID4gQSBuZXcgbWVtYmVyIGlzIGFkZGVk
IGZvciBwdHBfY2xvY2tfaW5mbyBzdHJ1Y3R1cmUuIERldmljZSBkcml2ZXIgY2FuDQo+ID4gcHJv
dmlkZSBpbml0aWFsIGN5Y2xlY291bnRlciBpbmZvIGZvciBwdHAgdmlydHVhbCBjbG9jayB2aWEg
dGhpcw0KPiA+IG1lbWJlciwgYmVmb3JlIG5vcm1hbGx5IHJlZ2lzdGVyaW5nIHB0cCBjbG9jay4N
Cj4gDQo+IFdoeSBub3QgcHJvdmlkZSB0aGlzIGluIHRoZSBQSEMgY2xhc3MgbGF5ZXIsIGFuZCBt
YWtlIGl0IHdvcmsgZm9yIGV2ZXJ5IGRyaXZlcg0KPiB3aXRob3V0IGFsdGVyYXRpb24/DQoNClRo
YXQncyBiZXR0ZXIuIFdpbGwgaW1wbGVtZW50IGluIHYzLg0KDQo+IA0KPiA+ICsvKioNCj4gPiAr
ICogc3RydWN0IHB0cF92Y2xvY2tfY2MgLSBwdHAgdmlydHVhbCBjbG9jayBjeWNsZSBjb3VudGVy
IGluZm8NCj4gPiArICoNCj4gPiArICogQGNjOiAgICAgICAgICAgICAgIGN5Y2xlY291bnRlciBz
dHJ1Y3R1cmUNCj4gPiArICogQHJlZnJlc2hfaW50ZXJ2YWw6IHRpbWUgaW50ZXJ2YWwgdG8gcmVm
cmVzaCB0aW1lIGNvdW50ZXIsIHRvIGF2b2lkIDY0LWJpdA0KPiA+ICsgKiAgICAgICAgICAgICAg
ICAgICAgb3ZlcmZsb3cgZHVyaW5nIGRlbHRhIGNvbnZlcnNpb24uIEZvciBleGFtcGxlLA0KPiB3
aXRoDQo+ID4gKyAqICAgICAgICAgICAgICAgICAgICBjYy5tdWx0IHZhbHVlIDJeMjgsICB0aGVy
ZSBhcmUgMzYgYml0cyBsZWZ0IG9mIGN5Y2xlDQo+ID4gKyAqICAgICAgICAgICAgICAgICAgICBj
b3VudGVyLiBXaXRoIDEgbnMgY291bnRlciByZXNvbHV0aW9uLCB0aGUNCj4gb3ZlcmZsb3cgdGlt
ZQ0KPiA+ICsgKiAgICAgICAgICAgICAgICAgICAgaXMgMl4zNiBucyB3aGljaCBpcyA2OC43IHMu
IFRoZSByZWZyZXNoX2ludGVydmFsDQo+IG1heSBiZQ0KPiA+ICsgKiAgICAgICAgICAgICAgICAg
ICAgKDYwICogSFopIGxlc3MgdGhhbiA2OC43IHMuDQo+ID4gKyAqIEBtdWx0X2ZhY3RvcjogICAg
ICBwYXJhbWV0ZXIgZm9yIGNjLm11bHQgYWRqdXN0bWVudCBjYWxjdWxhdGlvbiwgc2VlDQo+IGJl
bG93DQo+ID4gKyAqIEBkaXZfZmFjdG9yOiAgICAgICBwYXJhbWV0ZXIgZm9yIGNjLm11bHQgYWRq
dXN0bWVudCBjYWxjdWxhdGlvbiwgc2VlDQo+IGJlbG93DQo+IA0KPiBKdXN0IHVzZSAgbXVsdCA9
IDIxNDc0ODM2NDggPSAweDgwMDAwMDAwIGFuZCBkaXYgPSAzMS4NCj4gDQo+IFJlYWQgdGhlIHJl
YWwgUEhDIHVzaW5nIC5nZXR0aW1lKCkgYW5kIHRoZW4gbWFzayBvZmYgdGhlIGhpZ2ggMzIgYml0
cy4NCj4gDQo+IEFycmFuZ2UgYSBrdGhyZWFkIHRvIHJlYWQgb25jZSBldmVyeSA0IChiZXR0ZXIg
Mikgc2Vjb25kcyB0byBrZWVwIHRoZSB0aW1lDQo+IHZhbHVlIGNvcnJlY3QuDQo+IA0KPiBTZWU/
DQoNCkkgc2VlLiBJIHRoaW5rIHlvdSBtZWFudCB1c2luZyBiZWxvdyBkZWZpbml0aW9ucyBmb3Ig
Y3ljbGVjb3VudGVyLA0KDQojZGVmaW5lIFBUUF9WQ0xPQ0tfQ0NfTVVMVCAgICAgICAgICAgICAo
MSA8PCAzMSkNCiNkZWZpbmUgUFRQX1ZDTE9DS19DQ19TSElGVCAgICAgICAgICAgIDMxDQojZGVm
aW5lIFBUUF9WQ0xPQ0tfQ0NfTVVMVF9OVU0gICAgICAgICAoMSA8PCA5KQ0KI2RlZmluZSBQVFBf
VkNMT0NLX0NDX01VTFRfREVNICAgICAgICAgMTU2MjVVTEwNCiNkZWZpbmUgUFRQX1ZDTE9DS19D
Q19SRUZSRVNIX0lOVEVSVkFMIChIWiAqIDIpDQoNCg0KPiANCj4gVGhhbmtzLA0KPiBSaWNoYXJk
DQoNCg==
