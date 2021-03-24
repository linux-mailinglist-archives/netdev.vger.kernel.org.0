Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAF234784B
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbhCXMVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:21:07 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:51335
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234072AbhCXMUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:20:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFTjEjfGkHzQDeNTFeoHzXLeGeghusiR5OUp1TtJjgFh1Qov8/Q7SbhVk6d/yDWC4hlVlNUKVFAGGYCgKkdhDRjzm1ghyCGG8i9QUmf71QQdCuk6VOUq7aD8VNxxwDqcSfV1/T5c2zcG9+6mSWkg+4EgbO0IYimRcG2m+4AJRjEISHmHQH43YVaswgLOBWvbDmghx4rb3hPMudd73QPq7wlxaK4G3LWXlymvB6rXELOCL+076qWdk4jcUBSa3gAIdX8kkHzypYj+ThtDMhzcHX8CyKqbfpnFFxpGha7aWUNtr7c0yi+oEfmAJ830dplK0Wr2r1Y68gXdDyppZv6BLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=id28mjYlTR0+Ob3wJ+KR52x2NnGNKZkAMJejxM1txjg=;
 b=PvHFjYaznpXwG4hHuMyYEVXPrnJSv8OpO0MpTn6x86M6tr116ybCW1kqNucfDSd6hrY7Ln8tzLPKwQ+iK1ZCV3vrK8opUhRRR1jPUGv9araQjRJJJErJvXMK3Hp0dEyw3mS3V9hcShQwnFvleCVRwHo+Twk0366RUDwqYoPE1gQ/9je6IrzGRHCPIjmiuyi171G6+k5Y2GH0Clw81pqxxvC+EEzCmJ0Yh1B97Ig/DwMqyMaWVfeNMw3ECwF+ynXIy/Dfj2TXxjHZ3FChC8H3udn5PrCfid91GbaFVod5PYgYeWnfM/KgY0KvZcyTMF4z7x9dN5HXE6mDicvhZ/HqCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=id28mjYlTR0+Ob3wJ+KR52x2NnGNKZkAMJejxM1txjg=;
 b=H1s1nlsffvK5QnFsOi17Qr8omrVGHk4PM533UWU/HJA80aZI6KGV7MGN+vzucdNqEz1nyFmpRe+9nXSMe8whCH2FRxd9hcYksWVjUudXIh4un9a8REnysPWGwFbs03uaZSwWJ2uNkShXFfUgQ2k3ys3pkhNs2z/jwbto0HQ8QXk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 12:20:50 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.3977.025; Wed, 24 Mar 2021
 12:20:50 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jon Hunter <jonathanh@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Topic: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Thread-Index: AQHXIJuN/Okb/PN4nkWB+yH0VnH6i6qTC9Ow
Date:   Wed, 24 Mar 2021 12:20:50 +0000
Message-ID: <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
In-Reply-To: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 91d1ac8e-c813-4d88-46ec-08d8eebf4307
x-ms-traffictypediagnostic: DBAPR04MB7336:
x-microsoft-antispam-prvs: <DBAPR04MB7336EB49B50685991BCA2B94E6639@DBAPR04MB7336.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e3HaEVjwFyVLuUupyj+4RRLwZw8Wxg3Mb50dM3E4PBHCiuiHvx4JqGe25oXN1DKeA+uEWJ2pKPoSfFMuOpfcKyygxGE2EOmYzNUdQZno5PZ96D9iLUTq+YznA6caOak5ab27s5s0RaTODV49O3k0elfN7QbYse1bJvsroFbqKMMduIIf5LtjZflFzwdjcDJ3M6i8mL9KDz2rZlp21QvzfnJ5m73GaLwF1k63vHkoA5drsYgZYfSScdJgCMqJfQDZwJFK7aCSZJss/DCKEXOdPbtkJHaOxqxwdeDbeUuaPC/OaCb1OBKDZWPSeEVslOIveptUFFgYkSwol9NR8OO1xoazu31SHqJfOXHTpOO6V6OSRBqq3pyc2TTmZYvBYepguo2rEuxXd3ugvHIAwyyMCe/O2Wi1gl2AZd1SfVEcYUo7w8idq+KmyPy/VGBfDtu9xaU83aTJG6rkORjdiF7ODd1I3yMIkryAFuy0NbVlenAdOxMYFchjd0nPhIxddTuAEJJUVQE1oQe9DXhV0WCxYgJ4mZwreQOKVtAmjw5oFsKtdGhu/EpyhXqBI8uv59Fr/n9kxnLXTPp0MvlecVeZHaB89KfpKzY51I5Ncclj+i9+FQibxwKOiy3CtV6fZ+WgUW3EHD9mayIcIBYw8qfv4UjTQZ+vDyVHN9+y9YLSfyc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(64756008)(2906002)(5660300002)(86362001)(9686003)(6916009)(55016002)(33656002)(54906003)(38100700001)(66556008)(316002)(66446008)(66476007)(76116006)(8936002)(6506007)(7696005)(71200400001)(478600001)(83380400001)(8676002)(52536014)(186003)(4326008)(66946007)(53546011)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?QUZJR1FESlgyblBaZHV2USsweStRQk9MSzVNdU84NFQrbFVyeENPZThaQUVp?=
 =?utf-8?B?cndQMW1WUkliM1I2TzZLaVVMZ0R5Ym9abWdYYjErUjkrM3NKMVBYZkxXdFZE?=
 =?utf-8?B?S3hadmkxYUN2b1pEeVd6VDNiLzYyOGFiRm51SXZTcXBQZXlJMTRyZTMrLzlu?=
 =?utf-8?B?djMweWhpVWZlMk9QRS9wSTFucitXRDRjVTBybkhkN0pLYmYxalZtTXNWSDlh?=
 =?utf-8?B?SVUxcEJJdm5MNjhMUE8xNnpQalJhQlMzQXdxYnRxb1NvTFFVamwxQWhXZ2Fk?=
 =?utf-8?B?cm1MUGkrS0R3bmdRNjFMSXArSDFoMVJmMFlzcEdLKzVXTDNHTCsvOElxUU96?=
 =?utf-8?B?bFdlejFqUlhZdVFtZHdPYWQxZ0RhWldvODlralpPQjlyNDZucjBWWUNoOUpL?=
 =?utf-8?B?LzZMZlN1aVl3a2hvaTZXWjVuZUx1MjJPb1dCdlBFYStXNVdBT3hWQ0RyMGUr?=
 =?utf-8?B?QitIZDlWZDI0c210czd1Q05ySUlNays2dXdCT3lCN1hjT2ZEaG5pTjlrdlVr?=
 =?utf-8?B?VjJKekF0OU1IcTBHUTdpQjkrK1NFTTZhT0U1SnVTampGYkxidWt1SFVDZTg0?=
 =?utf-8?B?UTdMbVZ5RmJzMlcvK1FwTEg3eW9QN2FxNFJnWnpubXhYQlduRy9QWGgzT2lx?=
 =?utf-8?B?c00xMEJUU1BVeXQ0dXpEcDFNSE5HMDNvUzZ3aWxCRGFEVWx4R1B3STNUaytv?=
 =?utf-8?B?NlJaSTdKL2VTblhyS01XNmFubTUza2VPS1dYUmZNZTVuN0lpemFucnZKVFNR?=
 =?utf-8?B?Q0xnUWNxVVdKRGkwenhOREtTeEdUdTZMK0xDSkg5TGNOOHBqcU9tdWRjSVpD?=
 =?utf-8?B?MzVjWVZ2ZFo5cFpXTXlFYVh5SHpOOW9HZjc1cm5JSDZDNWdOYkMrZERVanVK?=
 =?utf-8?B?a3VzTjlPRkxKdXVqcXpPcFdIMCt6MGtQcDdJVEZTbi92a3FrZHUrd2t5aGRq?=
 =?utf-8?B?RUZWdm5kZzJrS2hGT0p0QXdaTG9hZVFEeTlpK2hNbnJtclJEbmRQTmJNM1Yz?=
 =?utf-8?B?dlBWRmFFSkhlUndNOC9oMEs5VkVjVWdmUFVTSzdidjBoODY4cmF0eXpWeU1J?=
 =?utf-8?B?UTJFaGVjQk5qcFBpTWVVT1FNNnhJdDQwejFuTU9icE02UUQvZnJEU29YVm54?=
 =?utf-8?B?cXdwWldPU2tiejMxak9VcFgrV0hKS0Z5K3VzRXhXbTBHZ0NPVmwzRitES2xR?=
 =?utf-8?B?WnF0U3hHTXBrUlBweUZGa3JEVUY0eVVSYllwblNkKzBvdCtUSlFPOVZ5UUp0?=
 =?utf-8?B?dTZMcy92NHhUTVZ1UTlRR21CV0ZZUzQ0WG9od2laM2JocFJPeXovWkpXRDIw?=
 =?utf-8?B?ZnZMZmNueUE5NGVkN2RsQVE1RHJEc2RLUFJiR3VSQ05SQ3RuMHhUMmNMV0Y2?=
 =?utf-8?B?MEpFMTZScmNHK3dJRHExVXlma2RtbUpkSDQvNmFFZVNQNm5rbTI5UU5CMWh5?=
 =?utf-8?B?MTdsQ1VEYXpna1BsOXZ1V3ZHbFA5bjdMQy9PUHlXNTFtVnRjUWorUTdtVCtC?=
 =?utf-8?B?KzcxWUs1UWZDK0Q4WW5zYUJTSVhrTTNGdENUY1BMUmJzM0Y2ZzNHS2lJTURL?=
 =?utf-8?B?Y0IwdlBZdVFmL0hTUG9JWWRHVkp6U1RyaVBSS1pFOGg3ekdBWjRNQjFVTktl?=
 =?utf-8?B?dzNYdkkxY3FjMFZiL2VyM2wwa0hBR0ZDYUNIc2hWN1lOdnBicWUwUlFXQlNR?=
 =?utf-8?B?VUJKRm5wTnJ4Q1Z2UDdXTU1KTlpuaXRmdmtDdFlqb0M5ZFlQR0dFLzQ0UFJX?=
 =?utf-8?Q?j1WboN3p06ZjysOl8TS8MjiynSXZ01LZY4knxrW?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d1ac8e-c813-4d88-46ec-08d8eebf4307
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 12:20:50.2982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: STVaWToQ6PmeT7BZIFuugG//i1TCFZbmy+yQk3QoYyAox3yI5/FjsOUboKVt5rgXqvDTVZbbnf1SdX3rlmbaGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvbiBIdW50ZXIgPGpvbmF0
aGFuaEBudmlkaWEuY29tPg0KPiBTZW50OiAyMDIx5bm0M+aciDI05pelIDE4OjUxDQo+IFRvOiBK
b2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KPiBDYzogbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZz47IGxpbnV4LXRlZ3JhIDxsaW51eC10ZWdyYUB2Z2VyLmtlcm5lbC5vcmc+
Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KPiBTdWJqZWN0OiBSZWdyZXNz
aW9uIHY1LjEyLXJjMzogbmV0OiBzdG1tYWM6IHJlLWluaXQgcnggYnVmZmVycyB3aGVuIG1hYw0K
PiByZXN1bWUgYmFjaw0KPiANCj4gSGkgSm9ha2ltLA0KPiANCj4gU3RhcnRpbmcgd2l0aCB2NS4x
Mi1yYzMgSSBub3RpY2VkIHRoYXQgb25lIG9mIG91ciBib2FyZHMsIFRlZ3JhMTg2IEpldHNvbiBU
WDIsDQo+IHdhcyBub3QgbG9uZyByZXN1bWluZyBmcm9tIHN1c3BlbmQuIEJpc2VjdCBwb2ludHMg
dG8gY29tbWl0IDljNjNmYWFhOTMxZQ0KPiAoIm5ldDogc3RtbWFjOiByZS1pbml0IHJ4IGJ1ZmZl
cnMgd2hlbiBtYWMgcmVzdW1lIGJhY2siKSBhbmQgcmV2ZXJ0aW5nIHRoaXMgb24NCj4gdG9wIG9m
IG1haW5saW5lIGZpeGVzIHRoZSBwcm9ibGVtLg0KPiANCj4gSW50ZXJlc3RpbmdseSwgdGhlIGJv
YXJkIGFwcGVhcnMgdG8gcGFydGlhbGx5IHJlc3VtZSBmcm9tIHN1c3BlbmQgYW5kIEkgc2VlDQo+
IGV0aGVybmV0IGFwcGVhciB0byByZXN1bWUgLi4uDQo+IA0KPiAgZHdjLWV0aC1kd21hYyAyNDkw
MDAwLmV0aGVybmV0IGV0aDA6IGNvbmZpZ3VyaW5nIGZvciBwaHkvcmdtaWkgbGluayAgbW9kZQ0K
PiAgZHdtYWM0OiBNYXN0ZXIgQVhJIHBlcmZvcm1zIGFueSBidXJzdCBsZW5ndGggIGR3Yy1ldGgt
ZHdtYWMNCj4gMjQ5MDAwMC5ldGhlcm5ldCBldGgwOiBObyBTYWZldHkgRmVhdHVyZXMgc3VwcG9y
dCBmb3VuZCAgZHdjLWV0aC1kd21hYw0KPiAyNDkwMDAwLmV0aGVybmV0IGV0aDA6IExpbmsgaXMg
VXAgLSAxR2Jwcy9GdWxsIC0gZmxvdyAgY29udHJvbCByeC90eA0KPiANCj4gSSBkb24ndCBzZWUg
YW55IGNyYXNoLCBidXQgdGhlbiBpdCBoYW5ncyBhdCBzb21lIHBvaW50LiBQbGVhc2Ugbm90ZSB0
aGF0IHRoaXMNCj4gYm9hcmQgaXMgdXNpbmcgTkZTIGZvciBtb3VudGluZyB0aGUgcm9vdGZzLg0K
PiANCj4gTGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IG1vcmUgaW5mbyBJIGNhbiBwcm92aWRl
IG9yIHRlc3RzIEkgY2FuIHJ1bi4NCg0KSGkgSm9uLA0KDQpTb3JyeSBmb3IgdGhpcyBicmVha2Fn
ZSBhdCB5b3VyIHNpZGUuDQoNCllvdSBtZWFuIG9uZSBvZiB5b3VyIGJvYXJkcz8gRG9lcyBvdGhl
ciBib2FyZHMgd2l0aCBTVE1NQUMgY2FuIHdvcmsgZmluZT8NCg0KV2UgZG8gZGFpbHkgdGVzdCB3
aXRoIE5GUyB0byBtb3VudCByb290ZnMsIG9uIGlzc3VlIGZvdW5kLiBBbmQgSSBhZGQgdGhpcyBw
YXRjaCBhdCB0aGUgcmVzdW1lIHBhdGNoLCBhbmQgb24gZXJyb3IgY2hlY2ssIHRoaXMgc2hvdWxk
IG5vdCBicmVhayBzdXNwZW5kLg0KSSBldmVuIGRpZCB0aGUgb3Zlcm5pZ2h0IHN0cmVzcyB0ZXN0
LCB0aGVyZSBpcyBubyBpc3N1ZSBmb3VuZC4NCg0KQ291bGQgeW91IHBsZWFzZSBkbyBtb3JlIHRl
c3QgdG8gc2VlIHdoZXJlIHRoZSBpc3N1ZSBoYXBwZW4/DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtp
bSBaaGFuZw0KPiBUaGFua3MNCj4gSm9uDQo+IA0KDQo=
