Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2A737A4BB
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEKKl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 06:41:26 -0400
Received: from mail-eopbgr60060.outbound.protection.outlook.com ([40.107.6.60]:32064
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229892AbhEKKlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 06:41:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PPG8WkRndJvlH0fym/MsZPlNpyx/ofTX3/2QeGsAA6VLwGDJ5HYpxYlCaRf5IQWnHYac5v8RTTtr5i8CtUNImrI52wloXBF7XE354Ax7hd3z5hmAKAIA9aisuIQWSfkRMKuVUYedCjob4U4vHEzlEVrcpYJ5E71GsTkxSAup5odFUQkRVBrkrf8F7L35C/1yq+chqCQbB4vUw94+ZkbPW8/xtrD+0QUZJ5F9mLuQlT895pgqxihFbA4AZ04EiaVgpPrT/JSZb5NiTJhrJydPUSbv/FbLgjU3P/SurlJ5pjl11/ANnaduagIeUVf+fN3acvM8qKUVY/0OT3XAOkBsOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7wrba5kvkuzjIpjF4ZpVqEPVd2fC3XLdhG3a2Cv2hw=;
 b=hUDeiMn8iyuxeoX534IKLZ+BnzCEvQJbfNaqhYL+DVkJNQKZMyHJdt1P8pnh0X8n+fbtUUfhGu15Br8kyqjAN30EjnPoJU6I5ol/V7gfe5Tfij4KlsjC90HWeZNG36EYg30FHF4ZMML8ePG71N5RXHA3MCL7BV83Bn+hXLMjpR0t+1h5N4Xkt6EKit3MstgBiCAtcylvr2d/EieQWb1F6D6P5Sl/z2QiI3XMbEeHP/plHRFpFFnXhkLwPih4YGWKt46Qhtl3yTIzViOzfbsjWCYwlYF9eY4Ze8lyaWEbXcmDJEW8M13uCo2dyCZJ5u7gWe4RddaXfDjqGNXhOSOPUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j7wrba5kvkuzjIpjF4ZpVqEPVd2fC3XLdhG3a2Cv2hw=;
 b=felNdvlG1Ika/fai/cNJaBcZVgcsSU44hTg26wrkH0s+VKZjCeyxMSfbv9i28qyqmS+u7HQPc3UYvAtwMxiDTDxSs32iORVufvKOdGI90w4OP3AupDywL3haK5Pn6w9ioiE9lnx87u2+eB0aptZgCYnctNg8KLWIDRz2mmh2Fh4=
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com (2603:10a6:10:1b::21)
 by DBAPR04MB7399.eurprd04.prod.outlook.com (2603:10a6:10:1a8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Tue, 11 May
 2021 10:40:16 +0000
Received: from DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc]) by DB7PR04MB5017.eurprd04.prod.outlook.com
 ([fe80::854e:3ceb:76a4:21fc%6]) with mapi id 15.20.4108.032; Tue, 11 May 2021
 10:40:15 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Topic: [net-next 0/6] ptp: support virtual clocks for multiple domains
Thread-Index: AQHXQx2n9odSkzWl/E2JdNuSb7aRparZ90oAgAIIfCCAAV+UAIAAqM9Q
Date:   Tue, 11 May 2021 10:40:15 +0000
Message-ID: <DB7PR04MB501793F21441B465A45E0699F8539@DB7PR04MB5017.eurprd04.prod.outlook.com>
References: <20210507085756.20427-1-yangbo.lu@nxp.com>
 <20210508191718.GC13867@hoboy.vegasvil.org>
 <DB7PR04MB50172689502A71C4F2D08890F8549@DB7PR04MB5017.eurprd04.prod.outlook.com>
 <20210510231832.GA28585@hoboy.vegasvil.org>
In-Reply-To: <20210510231832.GA28585@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84f0cb7b-8edb-4e99-e0d0-08d914692a0b
x-ms-traffictypediagnostic: DBAPR04MB7399:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB7399DCAEF011735FD21A91CDF8539@DBAPR04MB7399.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aVubQnZ2sd9m79pqrP5n5XIQeunfqA4ohFOrgZ7gZBKLsqBowsu3Kme4ZzrvC6R70g6LeZ3KUL2VUjLLcu0udK/TpohbeQatgaJqOZnqnEvQNaRCL/7QZaQBJUeGcOx6PG9c1K2xbXYBMfakHhpQHxVtwFXTtm9D4MxMb87vccs2cfoUXhw3iCPPgGeDi8OfalhKiWyUwofcvGdPNm2W+O2ooe6x+nA4LqBVNYVRrwlIkBihhAtlJ0o4yi4ff3GAphGyNOQ3lddoZetb6DIHRzPG9YGW6y/fUpbuotUUX+CwoYgsYxq+PO62wDlwyLhuLi+JpAnF7/459HcMBElIGmTlZKfDZyZb/G3enJkY/kLmiSQORU/NF53fZViwfQ0c9kIzvSBMVA2q+zbAII3piJ6HfYjeP7WRw5ibBRwKaB4bj2DlQUfQVjbkSp3PWd5hhpV11LPax/ZC6PzO+stQ00lfffP+9L+JCEEmLntUcUcPe64v9KPjvYaumH3CkO36+QmbhM6dmnFh4pS8h1hGm0/kfJ8/fLN5+r4LZWBWgNch7r3NWkI8ZAb9zVPY73iwHrQntEn5yflIK/1fnWQnannRs99z7sl05IoEYauEFmQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5017.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39850400004)(7696005)(33656002)(9686003)(71200400001)(64756008)(53546011)(2906002)(83380400001)(6506007)(52536014)(186003)(6916009)(5660300002)(55016002)(66946007)(76116006)(54906003)(8936002)(122000001)(66476007)(316002)(38100700002)(4326008)(66446008)(86362001)(478600001)(26005)(8676002)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NTJ0YUVNVFQ2ZHJ2M2JUV0ZuNndpbXpkT2RLemo0REUzejRtbkEzU2pObGd4?=
 =?gb2312?B?SE85U0NEalFzVWlpa0d6M2VWdkRONE1ESDJ0UUg0OTdSeWNWRE1Qcm0vek9s?=
 =?gb2312?B?ayt4cjJMYmNBRWNpalBJR2RzS0xRN1BtSTM4bURaNkV3TldpQm1HZTQyK2pZ?=
 =?gb2312?B?NUpGVnVVcGFydWlkSjJtTjRGSFJNZGcvOEE2bitGL3dCdnRnUE9GWnpkMWpW?=
 =?gb2312?B?cnZtU0FTRk5ERnA4S0h3eWFJeHdkWmlTaldFRFVQMEZLK29yR1hseFlJQzQr?=
 =?gb2312?B?NzU1aVorck9IOStBampmbVFTSVRiVHZvQWR1aW01UmE1N3NRaHUrZHM1NWtn?=
 =?gb2312?B?UjFndk1qVXRvd2FEeDRDTGlTV1lXV3U1OWU2b3FJRUNsVDBleVZ0dTkrR1NC?=
 =?gb2312?B?cncyUmlwVWlRWjR3dW1RcU9wWk8vdmJ1ZEg0bC9sZkxUTkRtYWJRNC9mQUox?=
 =?gb2312?B?QVE4UEZsanQ2SlVRM0d2QWlGbUJ0TWZ6TmtUV1UrMC8zZ3ozdytxN0diTTFR?=
 =?gb2312?B?VW5LdFBORW5pYkQ2VU1xWkVzY2dZU0c5MG5md1Y2V2FtaUxVNWJham9kbFVN?=
 =?gb2312?B?TnVPYjBrOXJScHdMM1BLejZNSnBMR0tqZVlodWhVTm16RWszR0txZldlSGkz?=
 =?gb2312?B?WFBsNzhodVNzc3F5MDMzM1NoajhQN2xLTmdBQ3lYeTZDVWtXTTZtS2V5NW4w?=
 =?gb2312?B?ZVdtNTlQMVdGYUk5ZExsRnByZ2dUTUgvWW0wNEVyZ3NtMHhCaHFnRitGOEdO?=
 =?gb2312?B?MFp4YkIycjd0RzB1aG1JWFBDREMrcDVZTUNOWXh3cHJsYVlKK0JncGJnWkNk?=
 =?gb2312?B?R094RkJWSi8vTExKcXYzZTdFYjdCc3BPMmxsSWUxbGVnSzQrZ1RxRzJhKzZE?=
 =?gb2312?B?aHg5bU5HM1dBMVo5VzVRSE9pNlNPNDE4ZVJhYWNUeWJyRkR2d1NPMGFaSkVX?=
 =?gb2312?B?YTJtbjZKVmFEUUp0cTRPSmhGWGRMeTJ2Ymh1UmJwU0lDY0I0UjJYdURWS056?=
 =?gb2312?B?ZndpOWtMdS94VVJPcU1McHl4YW82SmNxTy9RWDBsRmVLcWE0dE1sUzY0Skhh?=
 =?gb2312?B?TExERmxnT0FydFJNMjRVWC84TysrZWxqYm5KTVp4dWl5SEdtaUpZcDdvdEVv?=
 =?gb2312?B?b0RYbEpLenRMSTd6SmlvbE9uUXIvUnlaRE5waEpOVzl1elBpcUdoTjF3a3ZD?=
 =?gb2312?B?dlNCZVBKQVArZzNicnMyOHNHaVZqZ0dSVzE3b3dwbmlySEZBUzh1K3pQb3Fl?=
 =?gb2312?B?Q2xOMnZNRmhBc0oxc3pvS1ZzeEFVZkltQ1RSK055d2RZMWNPRExFTHAzTG1J?=
 =?gb2312?B?ck5RSmluYkYxMEkxekxpVS9rdHVLYW1GVUZvL0M5L0ltN0lEVHBmZURxcW10?=
 =?gb2312?B?TUc1NkV1a0c1bEc4NHdSV2ZuVzE2ejRnczZCTTVRanB2bktlTDFyMnJrUmxa?=
 =?gb2312?B?YmE4cVdmMnl4T2FjSGZMRDJUdGw1dGhEWjFsSTJhOWJLUWRqaFRlSEUxaHNT?=
 =?gb2312?B?M2kydkFidWhMRlQvTEU3Ry95UWdRemRrMUpUdjYxTjJOTE93MmViMjBlbmRB?=
 =?gb2312?B?bEF6T0NlNzdaM0kwTTRHNGVRcS9wQkFSK25rOVhEdmYwdEQrZ3p2QVhqc084?=
 =?gb2312?B?dzVMWXMxaEI3cGlBdzVlNEhJSi9qYXE2SUpXRmVLcUFQR1ByWU9mOXRqWG1M?=
 =?gb2312?B?aExQc1pRRDcyU2Z2OUxBbXNuekVpMUhxSGtJZjlRNzVGSFNVT05ENkdhUlNK?=
 =?gb2312?Q?eNdRF0gG6k2iM2Dn0vkqNcz/o09jWEDa9BHw8J/?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5017.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f0cb7b-8edb-4e99-e0d0-08d914692a0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 10:40:15.8299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYfHdXyeCRDPbfI4D5lBQQ+ERpxuIJci2QcsZiyv6fqI6LWFqx5Rri1eR6y94LsbZNPXe0BqPPhEhG1IJdGjgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSaWNo
YXJkIENvY2hyYW4gPHJpY2hhcmRjb2NocmFuQGdtYWlsLmNvbT4NCj4gU2VudDogMjAyMcTqNdTC
MTHI1SA3OjE5DQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
OyBDbGF1ZGl1DQo+IE1hbm9pbCA8Y2xhdWRpdS5tYW5vaWxAbnhwLmNvbT47IEpha3ViIEtpY2lu
c2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbbmV0LW5leHQgMC82XSBwdHA6
IHN1cHBvcnQgdmlydHVhbCBjbG9ja3MgZm9yIG11bHRpcGxlIGRvbWFpbnMNCj4gDQo+IE9uIE1v
biwgTWF5IDEwLCAyMDIxIGF0IDAzOjA0OjM5QU0gKzAwMDAsIFkuYi4gTHUgd3JvdGU6DQo+IA0K
PiA+IFRoZXJlIG1heSBiZSBzb21lIG1pc3VuZGVyc3RhbmRpbmcuIEluIHRoZSBleGFtcGxlLCBk
b21haW4gMSwgMiwgMyBhcmUNCj4gYmFzZWQgb24gUFRQIHZpcnR1YWwgY2xvY2tzIHB0cDEsIHB0
cDIgYW5kIHB0cDMgd2hpY2ggYXJlIHV0aWxpemluZyB0aGVpciBvd24NCj4gdGltZWNvdW50ZXIu
DQo+ID4gVGhlIGNsb2NrIGFkanVzdG1lbnQgb24gdGhlbSB3b24ndCBhZmZlY3QgZWFjaCBvdGhl
ci4gVGhlIGV4YW1wbGUgd29ya2VkDQo+IGZpbmUgaW4gbXkgdmVyaWZpY2F0aW9uLg0KPiANCj4g
T2theSwgbm93IEkgdGhpbmsgSSB1bmRlcnN0YW5kIHdoYXQgeW91IGFyZSBzdWdnZXN0aW5nLiAg
U3RpbGwsIHRoZXJlIGFyZSBpc3N1ZXMNCj4geW91IGhhdmVuJ3QgY29uc2lkZXJlZC4NCj4gDQo+
ID4gSSBtZWFuIGlmIHRoZSBwaHlzaWNhbCBjbG9jayBrZWVwcyBmcmVlIHJ1bm5pbmcsIGFsbCB2
aXJ0dWFsIGNsb2NrcyB1dGlsaXppbmcgdGhlaXINCj4gb3duIHRpbWVyY291bnRlciBjYW4gd29y
ayBmaW5lIGluZGVwZW5kZW50bHkgd2l0aG91dCBhZmZlY3Rpbmcgb24gZWFjaA0KPiBvdGhlci4N
Cj4gDQo+IFJpZ2h0LiAgVGhpcyBpcyBjcml0aWNhbCENCj4gDQo+ID4gSWYgdGhlIHBoeXNpY2Fs
IGNsb2NrIGhhcyBjaGFuZ2Ugb24gZnJlcXVlbmN5LCB0aGVyZSBpcyBhbHNvIHdheSB0byBtYWtl
IHRoZQ0KPiBjaGFuZ2Ugbm90IGFmZmVjdCB2aXJ0dWFsIGNsb2Nrcy4NCj4gPiBGb3IgZXhhbXBs
ZSwgd2hlbiB0aGVyZSBpcyArMTIgcHBtIGNoYW5nZSBvbiBwaHlzaWNhbCBjbG9jaywganVzdCBn
aXZlIC0xMg0KPiBwcG0gY2hhbmdlIG9uIHZpcnR1YWwgY2xvY2tzLg0KPiANCj4gVGhhdCB3aWxs
IGNhdXNlIGlzc3VlcyBpbiB2ZXJ5IG1hbnkgY2FzZXMuDQo+IA0KPiBGb3IgZXhhbXBsZSwgd2hh
dCBoYXBwZW5zIHdoZW4gdGhlICJyZWFsIiBjbG9jayBzZWVzIGEgbGFyZ2Ugb2Zmc2V0LCBhbmQg
aXQNCj4gZG9lc24ndCBzdGVwLCBidXQgcmF0aGVyIGFwcGxpZXMgdGhlIG1heGltdW0gZnJlcXVl
bmN5IG9mZnNldCB0byBzbGV3IHRoZQ0KPiBjbG9jaz8gIFRoYXQgbWF4aW11bSBtaWdodCBiZSBs
YXJnZXIgdGhhdCB0aGUgbWF4IHBvc3NpYmxlIGluIHRoZSB2aXJ0dWFsDQo+IGNsb2Nrcy4gIEV2
ZW4gd2l0aCBzbWFsbGVyIGZyZXF1ZW5jeSBvZmZzZXRzLCB0aGUgdW4tc3luY2hyb25pemVkLCBx
dWFzaQ0KPiByYW5kb20gY2hhbmdlcyBpbiB0aGUgInJlYWwiIGNsb2NrIHdpbGwgc3BvaWwgdGhl
IHZpcnR1YWwgY2xvY2tzLiAgSSB3b24ndA0KPiBzdXBwb3J0IHN1Y2ggYW4gYXBwcm9hY2guDQo+
IA0KDQpXaGF0IEkgdGhvdWdodCB3YXMgaW4gY29kZSB3cml0aW5nIHJlZ2lzdGVycyB0byBhZGp1
c3QgcGh5c2ljYWwgY2xvY2sgZnJlcXVlbmN5LCBhbmQgaW1tZWRpYXRlbHkgYWRqdXN0aW5nIHZp
cnR1YWwgY2xvY2tzIGluIG9wcG9zaXRlIGRpcmVjdGlvbi4NCk1ha2UgdGhlIG9wZXJhdGlvbnMg
YXRvbWljIGJ5IGxvY2tpbmcuIEFzc3VtZSB0aGUgY29kZSBleGVjdXRpb24gaGFzIGEgREVMQVks
IGFuZCB0aGUgZnJlcXVlbmN5IGFkanVzdGVkIGlzIFBQTS4NClRoZW4gdGhlIHRpbWUgZXJyb3Ig
YWZmZWN0aW5nIG9uIHZpcnR1YWwgY2xvY2sgd2lsbCBiZSBERUxBWSAqIFBQTS4gSSdtIG5vdCBz
dXJlIHdoYXQgdGhlIERFTEFZIHZhbHVlIHdpbGwgYmUgb24gb3RoZXIgcGxhdGZvcm1zLg0KSnVz
dCBmb3IgZXhhbXBsZSwgZm9yIDF1cyBkZWxheSwgMTAwMHBwbSBhZGp1c3RtZW50IHdpbGwgaGF2
ZSAxbnMgdGltZSBlcnJvci4NCg0KQnV0IGluZGVlZCwgdGhpcyBhcHByb2FjaCBtYXkgYmUgbm90
IGZlYXNpYmxlIGFzIHlvdSBzYWlkLiBFc3BlY2lhbGx5IGl0IGlzIGFkanVzdGluZyBjbG9jayBp
biBtYXggZnJlcXVlbmN5LCBhbmQgdGhlcmUgYXJlIG1hbnkgdmlydHVhbCBjbG9ja3MuDQpUaGUg
dGltZSBlcnJvciBtYXkgYmUgbGFyZ2UgZW5vdWdoIHRvIGNhdXNlIGlzc3Vlcy4gKEknbSBub3Qg
c3VyZSB3aGV0aGVyIEkgdW5kZXJzdGFuZCB5b3UgY29ycmVjdGx5LCBzb3JyeS4pDQoNClNvLCBh
IHF1ZXN0aW9uIGlzLCBmb3IgaGFyZHdhcmUgd2hpY2ggc3VwcG9ydHMgb25seSBvbmUgUFRQIGNs
b2NrLCBjYW4gbXVsdGlwbGUgZG9tYWlucyBiZSBzdXBwb3J0ZWQgd2hlcmUgcGh5c2ljYWwgY2xv
Y2sgYWxzbyBwYXJ0aWNpcGF0ZXMgaW4gc3luY2hyb25pemF0aW9uIG9mIGEgZG9tYWluPw0KKEJl
Y2F1c2Ugc29tZXRpbWUgdGhlIHBoeXNpY2FsIGNsb2NrIGlzIHJlcXVpcmVkIHRvIGJlIHN5bmNo
cm9uaXplZCBmb3IgVFNOIHVzaW5nLCBvciBvdGhlciB1c2FnZXMuKQ0KRG8geW91IHRoaW5rIGl0
J3MgcG9zc2libGU/DQoNCj4gSG93ZXZlciwgaWYgdGhlICJyZWFsIiBjbG9jayBpcyBndWFyYW50
ZWVkIHRvIHN0YXkgZnJlZSBydW5uaW5nLCBhbmQgdGhlIHZpcnR1YWwNCj4gY2xvY2tzIGdpdmUg
dXAgYW55IGhvcGUgb2YgcHJvZHVjaW5nIHBlcmlvZGljIG91dHB1dHMsIHRoZW4geW91ciBpZGVh
IG1pZ2h0DQo+IHdvcmsuDQo+IA0KPiBUaGlua2luZyBvdXQgbG91ZDogWW91IGNvdWxkIG1ha2Ug
YSBzeXNmcyBrbm9iIHRoYXQgY29udmVydHMgYSAicmVhbCINCj4gY2xvY2sgaW50byB0d28gb3Ig
bW9yZSB2aXJ0dWFsIGNsb2Nrcy4gIEZvciBleGFtcGxlOg0KPiANCj4gICAgIGNhdCAvc3lzL2Ns
YXNzL3B0cC9wdHAwL251bWJlcl92Y2xvY2tzDQo+ICAgICAwICMgcHRwMCBpcyBhICJyZWFsIiBj
bG9jaw0KPiANCj4gICAgIGVjaG8gMyA+IC9zeXMvY2xhc3MvcHRwL3B0cDAvbnVtYmVyX3ZjbG9j
a3MNCj4gICAgICMgVGhpcyByZXNldHMgdGhlIGZyZXF1ZW5jeSBvZmZzZXQgdG8gemVybyBhbmQg
Y3JlYXRlcyB0aHJlZQ0KPiAgICAgIyBuZXcgY2xvY2tzIHVzaW5nIHRpbWVjb3VudGVyIG51bWVy
aWMgYWRqdXN0bWVudCwgcHRwMCwgMSwgYW5kIDIuDQo+ICAgICAjIHB0cDAgbG9zZXMgaXRzIHBl
cmlvZGljIG91dHB1dCBhYmlsaXRpZXMuDQo+ICAgICAjIHB0cDAgaXMgbm93IGEgdmlydHVhbCBj
bG9jaywganVzdCBsaWtlIHB0cDEgYW5kIDIuDQo+IA0KPiAgICAgZWNobyAwID4gL3N5cy9jbGFz
cy9wdHAvcHRwMC9udW1iZXJfdmNsb2Nrcw0KPiAgICAgIyBiYWNrIHRvIG5vcm1hbCBhZ2Fpbi4N
Cj4gDQo+IEluIGFkZGl0aW9uIHRvIHRoYXQsIHlvdSB3aWxsIG5lZWQgYSB3YXkgdG8gbWFrZSB0
aGUgcmVsYXRpb25zaGlwcyBiZXR3ZWVuIHRoZQ0KPiBjbG9ja3MgYW5kIHRoZSBuZXR3b3JrIGlu
dGVyZmFjZXMgZGlzY292ZXJhYmxlLg0KDQpBZ3JlZS4gVGhpcyBzaG91bGQgYmUgZG9uZSBjYXJl
ZnVsbHkgYW5kIGV2ZXJ5dGhpbmcgc2hvdWxkIGJlIGNvbnNpZGVyZWQuDQpXaWxsIGNvbnZlcnRp
bmcgcGh5c2ljYWwgY2xvY2sgcHRwMCB0byB2aXJ0dWFsIGNsb2NrIHB0cDAgaW50cm9kdWNlIG1v
cmUgZWZmb3J0IHRvIGltcGxlbWVudCwNCmNvbXBhcmluZyB0byBrZWVwIHBoeXNpY2FsIGNsb2Nr
IHB0cDAgYnV0IGxpbWl0IHRvIHVzZSBpdD8NCg0KPiANCj4gSXQgbmVlZHMgbW9yZSB0aG91Z2h0
IGFuZCBjYXJlZnVsIGRlc2lnbiwgYnV0IEkgdGhpbmsgaGF2aW5nDQo+IGNsb2NrX2dldHRpbWUo
KSBhdmFpbGFibGUgZm9yIHRoZSBkaWZmZXJlbnQgY2xvY2tzIHdvdWxkIGJlIG5pY2UgdG8gaGF2
ZSBmb3IgdGhlDQo+IGFwcGxpY2F0aW9ucy4NCg0KVGhhbmsgeW91LiBUaGVuIHJlZ2FyZGluZyB0
aGUgZG9tYWluIHRpbWVzdGFtcCwgZG8geW91IHRoaW5rIGl0J3MgcHJvcGVyIHRvIGRvIHRoZSBj
b252ZXJzaW9uIGluIGtlcm5lbCBhcyBJIGltcGxlbWVudGVkLg0KDQo+IA0KPiBUaGFua3MsDQo+
IFJpY2hhcmQNCg==
