Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B725324F6D
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233956AbhBYLtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:49:02 -0500
Received: from mail-eopbgr130089.outbound.protection.outlook.com ([40.107.13.89]:29509
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229571AbhBYLsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:48:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUgpUfnsbeIunEosZs+hI1UUESln+G7FomnaSRY9ClnnxfvAWGVM0SELJBY1jVNGOGXQheoEGBm7k0r5RSLfagPScZTPdIrGKjnESFJ03yLQBuXsICI1XwEsHpRdwbfNkD3QEAkUZmfX+Chd0mSFwe8i33gJjQWwae+fCUOBxU+3oP+dsEeiRvVcsIDiCHEjgHxK39chXWTKL8FsO0t94Yiivdt9g174+e3Ei0fLDCRsfsbyjs7X4ATANVpVl2RJGQ6oCvhLqze1sQSdzZpRVunM7H1htdhYv3lMi3UyAKBCDR9ONDSqBtWPUcmKJv6Fr8yF6J3lblvvEJG2Cofv0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0K3hhBC2Yu7ze7Z88niQVJq9/JpUzxhPUaOVBtV2kU=;
 b=mLJFwGIlToimuj+HpcmbjrhgWCpFKScdAHvbA0LIF0b5jfKVOGrL435LHqd2XufoITs1PHJhZedhm9W1gK3D6SMEcnSaX86aiIltdNEa1cTEcCe7KqAQLikWpix7y7tBNO33AT5E+FqrO5FoInsLHycAZ9gfxyroB0dgg+cpRjWf9RQ8LM6A8NjpvUmyaruzsFrtzZV2uGdal8uDovtD98/bK1PY6FosI0FtCj7HJCYnwnCQ6lodWWLkwTMpTG5hX/uuZtxRv1wKz+MRXf6Yy67PtgA3WfcdpltHX9cBPcWLaC+NRIM4/Bh7ggyNBPDsfOKuDeol7/NWzPUoAvmI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0K3hhBC2Yu7ze7Z88niQVJq9/JpUzxhPUaOVBtV2kU=;
 b=WVKOC7tJq8M/I9aZzn98qlo0F/hJ5qSfg8foRWrTZZJUAMWg23Er39BSJ3ETqMbnc5kZfoBTy4rfqdDnS41GBCU3dqAKHHB5htBDwWun26xZ152iSeEn0W8xW7EMSkv/hgES0fTuzP7J5u+9+R9CQv8Y3rGclYICaX8iJecsPms=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB8027.eurprd04.prod.outlook.com (2603:10a6:10:1e6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Thu, 25 Feb
 2021 11:48:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 11:48:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     netdev <netdev@vger.kernel.org>, dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Topic: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAulgAgADVycCAAA0VAIAAlLYw
Date:   Thu, 25 Feb 2021 11:48:05 +0000
Message-ID: <DB8PR04MB679510F099C88F6B4BA10970E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YDZOMpUYZrijdFli@lunn.ch>
 <DB8PR04MB6795FAE4C1736AABDCA75FA7E69E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YDcMgr2rvcFvs746@lunn.ch>
In-Reply-To: <YDcMgr2rvcFvs746@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b6b209f9-071f-42df-57d0-08d8d98336ad
x-ms-traffictypediagnostic: DBBPR04MB8027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB802705145DDB9CECCF15DAABE69E9@DBBPR04MB8027.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mDFdI20EXgMwfdjMBwuGHKrqrmyuiDI6SWMmLPiK6+MSYZKYV9wJap8b7sSqJB5VjMlPMNWmP3iFUl4hIF8/riLTBfts/BW1k3h1eHNkdqqBOZ98nwcffjiLXjbY9H/Tsg9P1F40mwGUQqqk7b8XPWeQWHUtpwQekriMS2h9GeZoNz/cUT5baoL9E1RU3ONX3kK8WE6Ovp7OrRSXC13Fsg70PwnKE0241mJCSBH/f5W+4//aEVnexzg05Q18acM0XaIDSorhbV23dsShCtwNsH03idNLX45Fj3xoIfvzaB2tUnQJUm5OMtDKC/XdCklZWo+goHdecwEzqEUj+0KalQzLtbA/EfNKd9C8AEi5BOCwuVduktnvtiSAbV1yD/DYmE1gNODKi15U0CpziKryLY67iVxgkomCdwau3lbfpkJthBuIux2JUvGbRqOOrPmdNaXiASB6o68RURS4DaecLRi8zYGeQSwZUGpJGcz61TbkwxbmWC5Ny3eUDu+wjsbg1R16UPfmACv9XktI1JFLow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(110136005)(83380400001)(86362001)(4326008)(2906002)(76116006)(71200400001)(8936002)(478600001)(8676002)(316002)(186003)(54906003)(53546011)(9686003)(6506007)(66556008)(52536014)(26005)(66476007)(66946007)(7696005)(64756008)(5660300002)(33656002)(66446008)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?SUNWeldYSG5hbUlRSk1Td0hVcVBaTzBzemJhTGpicmZTRzFtT3NWaWgyUDZY?=
 =?gb2312?B?bElvMkNvY2pWRzltSzArQXdZajZHRjJaSTBURUhzZmV6WFVDL3l1dzhTNmlk?=
 =?gb2312?B?cndjY21WU1ozc2tyNmFNNVJJOHhwQ2t3UXFGSTRBRS9UejBMRXZWdmRoWk53?=
 =?gb2312?B?S3g3WG1qT3FtVi9TRWpodW9Xc2M2MDdIOTJkY0ZNN0RXcWNUa2doZmEzc2ho?=
 =?gb2312?B?UU4yMFBUM0V5Mm1tS3Y2cDl3YlFydUF5Z25nWE9HVzAvWWZBZGlWNExMVlBa?=
 =?gb2312?B?RHVwNDVUQXNweWloREp0bUlFU1lrK0RPbTYwTDB5R2I5SVIrRGx4dzhKOTZ2?=
 =?gb2312?B?TGxudDk0NzJFRFF4ZEc5dFVtS2QrY1ZZVXY3OGljcy9ZWUlWN05UYWsvb3BM?=
 =?gb2312?B?b3NZSmJ1NkpONVZmNkJHcmpkd3k4b0pkTmJUYW9MUFNNUzdRVGFxM3ZIVlo2?=
 =?gb2312?B?Um8wUXQ5NVVnZVhYYlJzb1oxdVY5V0dQTisyZXdCZHpLQnU5WkVxMGhueTJG?=
 =?gb2312?B?ZEl5QTdjWkNkZ2ZOVFVWdjliaDJvSjFhaVBCU05JUVI5SlJaU1Zyd1pnWk9t?=
 =?gb2312?B?U2FWZzNBejM2QVN4N3NHM0FpcjlnVkhLb0dEeXRrRnFEdmxXM3JHVFJRTkJy?=
 =?gb2312?B?dkl5MXYzV3VTTndkZ1BldFAzam5RUHVVQWZLdHVtVjJxa3c2QjhpQk0vU0lz?=
 =?gb2312?B?SzliTFhGNnZvNm9adTdRdGlMUUdXbEt0a0tMSTltWWFRTVFDWkZBeUZvWDMr?=
 =?gb2312?B?Y1l6RlNkY3h6RDU1dXdReWp2NXlHdmt5UVlQMVlxWFF2Y1Y5QjlDVlNoRDd2?=
 =?gb2312?B?VmpBOTlVSUdqTnRqb2pLUlk1S3hPdVUrVW43REFkMzZ6Q1BNcVJuMktjVFFl?=
 =?gb2312?B?YnB0THJSMG03SWgyS3Z1bHU3Mmg1eU9GNXlOclhQWUkxdmVrRTZSRDk1M2VE?=
 =?gb2312?B?MVVHTkZjV1BHbkMzME95Ujg5alB4VXdSM0xvalkwUnZyRGthUEdMVzRQdHBk?=
 =?gb2312?B?d0pTSFg1clNTWmhFdllTVlc3cHFlYlZYMVl0N3NRQm1ndjZudFFtTzVlYjND?=
 =?gb2312?B?S3ZTbEsrRWhoTysyNTBEb0dVSTdoRTdRd0ZOQVVoa0wwL2hmc0p2eVVpRzhH?=
 =?gb2312?B?dks0UUhVdUVZTS9ja2hwQVNTKzltUXJuZGN5blZUaFRiL2pSdEx1L3RBQ3pE?=
 =?gb2312?B?OEJUUEs3OG9XMHBVNUY3cWoyN2dKQWhYbUpEbEUxdm05RkRKeGhNeGpma0cv?=
 =?gb2312?B?c0lHcDRrRGlzcFRvT1hXamNjOXN0REFVK1RDWEozZTYwMmtzNGRxWk9US3hw?=
 =?gb2312?B?SDlhRDlHaWY5MERlaEtic1I0aGU3aTI3YjdVcm5aRG5BRHRrUE94amtSZVJJ?=
 =?gb2312?B?Qjl4cmFuV2Zvc3BCSkxvc3c0cmVCc0x6bWZ4SDlHM1ZBMDRNUGdwVCtSSVdh?=
 =?gb2312?B?czdBRHpyeFNoSThMbDIwYjg0alE4WjFzZWJIY1k4VkhlVThOeFBLZC9QbzlY?=
 =?gb2312?B?cm9Uang4VXhxQk5Dek5kNjFJbUMvRGs3RE5DWjFHQlVyRUNEL0NqVHRhSEgz?=
 =?gb2312?B?aitxcG1qVWtPU2VJVzV3cUJiOFo1UFh0bXNuTTNWa0RXZTlNRmZPY0UrNWJE?=
 =?gb2312?B?Uy9QNkQra21uY2dJOFFTWCtaQisvYm9vY1BRZHBPZ1lRZGIydFlLYU8vd2hO?=
 =?gb2312?B?VmNMT3I2Nis5YWR6Y2VUSE1aR1JpSmtoNFN6NDNOQjB1US9jMVVaTGZadFJp?=
 =?gb2312?Q?F9T0/gX/ZPz6HqPsUuV3c022Bv92K7O/qpN+bUM?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b209f9-071f-42df-57d0-08d8d98336ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2021 11:48:05.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 02svF3ZONA6eDcUjyreRzhqvYFJbTVUAh2xqZ2R9do9TDF5O4CIP7hpRe+wLhoT/vwelysjC9NGbuASNwJ0AFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB8027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqMtTCMjXI1SAxMDozNA0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IG5ldGRldiA8bmV0ZGV2QHZnZXIu
a2VybmVsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQtbmV4dCAwLzNdIG5ldDog
c3RtbWFjOiBpbXBsZW1lbnQgY2xvY2tzDQo+IA0KPiA+IEhpIEFuZHJldywNCj4gPg0KPiANCj4g
PiBJIGRvbid0IGhhdmUgZXhwZXJpZW5jZSB3aXRoIEV0aGVybmV0IHN3aXRjaCwgYWNjb3JkaW5n
IHRvIHlvdXINCj4gPiBwb2ludHMsIHlvdSBtZWFuIHdlIGNhbiBjb25uZWN0IFNUTU1BQyB0byBh
biBFdGhlcm5ldCBzd2l0Y2gsIGFuZCB0aGVuDQo+ID4gRXRoZXJuZXQgc3dpdGNoIG1hbmFnZWQg
U1RNTUFDIGJ5IHRoZSBNRElPIGJ1cyBidXQgd2l0aG91dCBjaGVja2luZw0KPiA+IHdoZXRoZXIg
U1RNTUFDIGludGVyZmFjZSBpcyBvcGVuZWQgb3Igbm90LCBzbyBTVE1NQUMgbmVlZHMgY2xvY2tz
IGZvcg0KPiA+IE1ESU8gZXZlbiBpbnRlcmZhY2UgaXMgY2xvc2VkLCByaWdodD8NCj4gDQo+IENv
cnJlY3QuIFRoZSBNRElPIGJ1cyBoYXMgYSBkaWZmZXJlbnQgbGlmZSBjeWNsZSB0byB0aGUgTUFD
LiBJZiBhbnkgb2YNCj4gc3RtbWFjX3hnbWFjMl9tZGlvX3JlYWQoKSwgc3RtbWFjX3hnbWFjMl9t
ZGlvX3dyaXRlKCksDQo+IHN0bW1hY19tZGlvX3JlYWQoKSwgYW5kIHN0bW1hY19tZGlvX3dyaXRl
KCkgbmVlZCBjbG9ja3MgdGlja2luZywgeW91IG5lZWQNCj4gdG8gZW5zdXJlIHRoZSBjbG9jayBp
cyB0aWNraW5nLCBiZWNhdXNlIHRoZXNlIGZ1bmN0aW9ucyBjYW4gYmUgY2FsbGVkIHdoaWxlIHRo
ZQ0KPiBpbnRlcmZhY2UgaXMgbm90IG9wZW5lZC4NCg0KSGkgQW5kcmV3LA0KDQpUaGFua3MgZm9y
IHlvdSBleHBsYW5hdGlvbiwgSSBzdGlsbCBkb24ndCBxdWl0ZSB1bmRlcnN0YW5kIHdoYXQgdGhl
IHVzZSBjYXNlIGl0IGlzLCBjb3VsZCB5b3UgZ2l2ZSBtZSBtb3JlIGRldGFpbHMsIHRoYW5rcyBh
IGxvdCENCkFGQUlLIG5vdywgdGhlcmUgYXJlIHR3byBjb25uZWN0aW9ucyBtZXRob2RzLCB3ZSBj
YW4gYWJzdHJhY3QgdGhlIGxheWVyOg0KCU1BQyA8LT4gTUFDLCB0aGVyZSBpcyBubyBQSFkgYXR0
YWNoZWQuIEl0IHNlZW1zIHRvIGtub3cgYXMgRml4ZWQgbGluaywgcmlnaHQ/DQoJTUFDK1BIWSA8
LT4gUEhZK01BQw0KRnJvbSB5b3VyIGV4cHJlc3Npb24sIHlvdSBzaG91bGQgdXNlIGFuIGV4dGVy
bmFsIEV0aGVybmV0IHN3aXRjaCwgaWYgeWVzLCB3aHkgRXRoZXJuZXQgc3dpdGNoIG5lZWRzIHRv
IHVzZSBNRElPIGJ1cyB0byBhY2Nlc3MgYW5vdGhlciBNQUMncyhTVE1NQUMpIFBIWT8NCg0KIA0K
PiA+ID4gWW91IHNhaWQgeW91IGNvcGllZCB0aGUgRkVDIGRyaXZlci4gVGFrZSBhIGxvb2sgYXQg
dGhhdCwgaXQgd2FzDQo+ID4gPiBpbml0aWFsbHkgYnJva2VuIGluIHRoaXMgd2F5LCBhbmQgaSBu
ZWVkZWQgdG8gZXh0ZW5kIGl0IHdoZW4gaSBnb3QgYQ0KPiA+ID4gYm9hcmQgd2l0aCBhbiBFdGhl
cm5ldCBzd2l0Y2ggYXR0YWNoZWQgdG8gdGhlIEZFQy4NCj4gPg0KPiANCj4gPiBDb3VsZCB5b3Ug
cG9pbnQgbWUgaG93IHRvIGltcGxlbWVudCBjbG9ja3MgbWFuYWdlbWVudCB0byBjb3ZlciBhYm92
ZQ0KPiA+IEV0aGVybmV0IHN3aXRjaCBjYXNlPyBPciBjYW4gd2UgdXBzdHJlYW0gdGhpcyBmaXJz
dCBhbmQgdGhlbiBmaXggaXQNCj4gPiBsYXRlciBmb3Igc3VjaCBjYXNlPw0KPiANCj4gSSBhY3R1
YWxseSBnb3QgaXMgd3Jvbmcgb24gdGhlIGZpcnN0IGF0dGVtcHQuIFNvIHlvdSBuZWVkIHRvIGxv
b2sgYXQ6DQo+IA0KPiA0MmVhNDQ1N2FlIG5ldDogZmVjOiBub3JtYWxpemUgcmV0dXJuIHZhbHVl
IG9mIHBtX3J1bnRpbWVfZ2V0X3N5bmMoKSBpbg0KPiBNRElPIHdyaXRlDQo+IDE0ZDJiN2MxYTkg
bmV0OiBmZWM6IGZpeCBpbml0aWFsIHJ1bnRpbWUgUE0gcmVmY291bnQgOGZmZjc1NWU5ZiBuZXQ6
IGZlYzogRW5zdXJlDQo+IGNsb2NrcyBhcmUgZW5hYmxlZCB3aGlsZSB1c2luZyBtZGlvIGJ1cw0K
PiANCj4gQW5kIG5vLCB5b3UgY2Fubm90IGZpeCBpdCBsYXRlciwgYmVjYXVzZSB5b3VyIHBhdGNo
ZXMgcG90ZW50aWFsbHkgYnJlYWsgZXhpc3RpbmcNCj4gc3lzdGVtcyB1c2luZyBhbiBFdGhlcm5l
dCBzd2l0Y2guIFNlZToNCj4gDQo+IG9tbWl0IGRhMjlmMmQ4NGJkMTAyMzRkZjU3MGI3ZjA3Y2Jk
MDE2NmU3MzgyMzANCj4gQXV0aG9yOiBKb3NlIEFicmV1IDxKb3NlLkFicmV1QHN5bm9wc3lzLmNv
bT4NCj4gRGF0ZTogICBUdWUgSmFuIDcgMTM6MzU6NDIgMjAyMCArMDEwMA0KPiANCj4gICAgIG5l
dDogc3RtbWFjOiBGaXhlZCBsaW5rIGRvZXMgbm90IG5lZWQgTURJTyBCdXMNCj4gDQo+ICAgICBX
aGVuIHVzaW5nIGZpeGVkIGxpbmsgd2UgZG9uJ3QgbmVlZCB0aGUgTURJTyBidXMgc3VwcG9ydC4N
Cj4gDQo+IC4uLg0KPiAgICAgVGVzdGVkLWJ5OiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxp
QGdtYWlsPiAjIExhbW9ibyBSMSAoZml4ZWQtbGluayArDQo+IE1ESU8gc3ViIG5vZGUgZm9yIHJv
Ym9zd2l0Y2gpLg0KPiANCj4gU28gdGhlcmUgYXJlIGJvYXJkcyB3aGljaCBtYWtlIHVzZSBvZiBh
IHN3aXRjaCBhbmQgTURJTy4gRmxvcmlhbiBtaWdodA0KPiBob3dldmVyIGJlIGFibGUgdG8gcnVu
IHRlc3RzIGZvciB5b3UsIGlmIHlvdSBhc2sgaGltLg0KDQpIaSBGbG9yaWFuLA0KDQpJIGFtIGN1
cmlvdXMgYWJvdXQgIiBmaXhlZC1saW5rICsgTURJTyBzdWIgbm9kZSBmb3Igcm9ib3N3aXRjaCAi
LCBob3cgZG9lcyB0aGlzIGltcGxlbWVudD8NCg0KRmxvcmlhbiwgQW5kcmV3LCBJIHdpbGwgc2Vu
ZCBhIFYyLCBpdCBjb3VsZCBzdGlsbCBoYXMgZGVmZWN0cy4gV2VsY29tZSB0byByZXZpZXcgdGhl
IHBhdGNoLCBJIGRvbid0IGV4cGVjdCBpdCB0byBicmVhayBleGlzdGluZyBzeXN0ZW1zLiBUaGFu
a3MuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiANCj4gICAgQW5kcmV3DQo=
