Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0130146C07B
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239523AbhLGQQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:16:37 -0500
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:40385
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234791AbhLGQQh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 11:16:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UC4Bv4dg3qOR9ZUm6Bs2/UB/VDvbGDimAgPIvPXWKuFQFKWCNHcLeZC2cmrb9bmNXlcXvGjizyDCQBX0yOoxeTDj7c/B3uh/GuJ15+AiEALe5mMm9+UgOo9J42G19mKhgHOJim9V485sGpMcYBhc4DkbBpjAUi5X4//7B6CM/SYnxKO4X+b9YwznHOJC+YkfDTNlHQa6ly7N4KS/Z6k9arKY+2HWqHZkry5maiMJn6RsX/+qJ3QX7OzB2dFvMOUF4AjL1jGImw7FtiQ7Z1VhHUuOfqJPrVSHa3nTv/5N78UHTTPIOvmVZc9XUrWx8HV+kOlTUZ3NSfr9QbDW5/p5Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpgRqYP2Jr4F7guj+FEvU+Q8sncXpM+kPYd07utCfJs=;
 b=gmE/x4Zvelwgee7Ct8A9Rqtlbw0TM4kvsnDPc8SbPpaQ1WdA7o33/uFJGphHTbMRa9ty+Q4k7WFjz/ZjCuU3HPIR0xPn+ROzNglABbmCWvW7Ms6lGJSIEQLVznz2Vj+QtiSpd0v3c/+OG633eqS8UjbzyeJlbEzibYEo3PrPGkWnBftNpsjXdNHT+taHxojT3Lta6KMyddoSD30xYhCJD1nQuhdlTh4/edInvdan5segVLYrN9DLwH+54PnU4M+3oyvOlfn8+lD/WQEhbbGI899R7UK+Oj3H56w64cIGsmcfXmMLfMuwyy/w1CkYHKvD28qePPfqH8k5IGsfYeWeTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpgRqYP2Jr4F7guj+FEvU+Q8sncXpM+kPYd07utCfJs=;
 b=oWODSla+yWX24710N8dFdRdTf6IhwaI1lFHsUiWkpU4sWMQgTW1CZ1QLkANYo9+UXaP4C1PptOc2ciKS16zfbPE15zWorAqFVH1eDnFYX6OTgzmCBrNcGsv2DIwqW8lgi05AiudFeC2xDkLVeayWY5mgdI/1ClaMukNpgxQAqOI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4221.eurprd04.prod.outlook.com (2603:10a6:803:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 16:13:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 16:13:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v6 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v6 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX64IRzggEtFTe6EqCs/YWRvNadKwnM5uA
Date:   Tue, 7 Dec 2021 16:13:03 +0000
Message-ID: <20211207161303.bvmuxt5o7m6oeivg@skbuf>
References: <20211207154839.1864114-1-clement.leger@bootlin.com>
 <20211207154839.1864114-5-clement.leger@bootlin.com>
In-Reply-To: <20211207154839.1864114-5-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d85c917f-791f-4312-63d8-08d9b99c72bc
x-ms-traffictypediagnostic: VI1PR04MB4221:EE_
x-microsoft-antispam-prvs: <VI1PR04MB42215F93B44889489F2A1746E06E9@VI1PR04MB4221.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BxDEGWxoT7THDQlDpfVu1+p3kVSR/dPG02j3m+3hWj2gwIhFo0M69YyP+mPUIQkw8zvwmuWLk2R4rIGh94bGF/w/4nDUi0W/u/OU0/UDq2ZdBm06U/Do2tDQP8lIOS8ninfLYVGJjUODu/Oep6sEdXJEKBRb8LDmgJBPk/BdnMIAsgLsIIDTXBDqLeuZsXRsHU9tGi58blWgT9VO25AD/GHDT9ZPegVJ7Mm85hbAs6gVEUAmBQ60AYAj8bJLuw6SfL3g/K8dzE5ycOq0DYH+85dpAZvF+LjQ1MBVs/SrCV83wQaT+CXdgF5o4q+EbP8AOhXGeJqFDxpiGGcGcsafBlihaYqRf79IOv7eSqXsqqA7nCf5fSbswADZZHRA0bz4RzCrpg1Xwhn0Oprja+MA65F6cpRipuYyqNHhsQrAfWr00z0NfxDaFWz9IMG48jUG43jurDLyB2Xq5hLWX0oFdjdd50UsUhknf510uF0iB48cYdMrpiKs5M/X/CHVMJvrk4cQJYn3F3h8FaVI1Gd7eSlTV4M/vkpWNzfDvmV8Nlp0ScPG/yUJ7H8vdKD6A76SRLDvCWMqQoSembaajsjdEu+qYoe1DsYRCC3evpbeWiehete+fyngwSocC/67edY2pXWcS5t1eNtZqzerAoZ+JtJKkrz2wolAOL4QoAK7qH1sHZYqYttLaS05hHiwVls1ZmKpXchDDttP9xxHww1PxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38070700005)(122000001)(6916009)(508600001)(6486002)(316002)(7416002)(71200400001)(6506007)(4326008)(186003)(38100700002)(9686003)(2906002)(6512007)(8936002)(91956017)(33716001)(76116006)(44832011)(54906003)(64756008)(66446008)(26005)(1076003)(5660300002)(66476007)(66946007)(66556008)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXludUNUZDZIaDV1SVFzSGFXcXpnRDg5WnhYbHhNaWEvM2YxekpnL1FqYlZ1?=
 =?utf-8?B?eHgrTThBY3N0L0hMSG9XZmU1bHFMelNlM3d2aE9KOVdFeFVWdHc3a3ZuWDJE?=
 =?utf-8?B?TGtTMFJFUkQ4b0hjQkU4T1o1aG9tbjNxNkRIK2FSVFVyZHUxYkRHRWdvOTEy?=
 =?utf-8?B?SjRLbEh6anJpSTlzSHZaVTZHYll2SlgyNGowMk5EMGdQbWkxK3ZoSU9wMlJV?=
 =?utf-8?B?Y3hYOFc5RHZCK1EvQ2tUaU4zTnF1ZUJla1V0bGlsaCtxY1haY2ZvZTZxanBx?=
 =?utf-8?B?TzhvTDFhTnNuQnhvRGlaVTJRL3NrWDZuMnRETUd4ZC9QZXZ6c3pRZFBvVnFs?=
 =?utf-8?B?bDJEQWozdUp1YkRyR0xXVEl4RkJBT1RKczVBbHp2bDg2OW1NWGpjV3JLNUpw?=
 =?utf-8?B?ZWZtdFJGSEhGdGdLcHg1bnhhVzloYXF1a0w2K2J3Qzgzd2czdlNBSklHeTZh?=
 =?utf-8?B?WTROK0FUUnI3RTA1d2prSmFzY0tpenVpcjM3RGJRSmIzWHVzS3k0ZzQ2dThD?=
 =?utf-8?B?MkJtdmh5OHpPTUpKd1BhUllPcTMxczdlK01iZ2JsUU92bzlTcGdJcUVZZnUr?=
 =?utf-8?B?RHUzMW52RnZ6QTNyY3NGRzRuSy9uNzZIQVFkQzdSMWRTNkN1dlB1RlJ1aWxP?=
 =?utf-8?B?Smwrc3ZKRzZQYlUzcmIyeEQ1VDdlRmhIYVI3UEpOZVNMTHhCQ3BkZ3kvRHB6?=
 =?utf-8?B?UGtzZ25QaHE2ZVluM0hxQVVKRjJiZ0RLMExHZTRjaGUwT2k5c29EU01GNVJ4?=
 =?utf-8?B?ak5Ud3ZYRDl0ZXRsU2JMS3J5bHZEektkdUpudzZxRVVyemF1S2Q5Uk5sc3Q0?=
 =?utf-8?B?SFJSaVVPWGIzdXhQS0V5NGdJdHFJOVpjT1c2eU90L2hndVBxZkRhSzllR2Rw?=
 =?utf-8?B?VnJ2NW1VR1J2ZlNZZzBIRlpMK1FMbk5wMnhxY09xcEd1SElyMmQ5UGZ2ZTkx?=
 =?utf-8?B?OSttTDdQbEpIRldLVGZHclAydi9mcGhOV1dWYVRQdDRqT3c5THZpQnFQRXdw?=
 =?utf-8?B?dkljNHNNYjRBS0lrQ0ppL1BrS3JLdEpkNjlXUWQzZmx5Ly9UNkZYSHk4OTB5?=
 =?utf-8?B?Z2VlOXppdHVmb3BSZTlyNmsyRHdMM2ZFUzFDRWJaNDNzWTBoSHBUc0pUWEhk?=
 =?utf-8?B?YzNUQkluQUlpcWY3UEp5Y3hUQmtHaXhseXhkMmkrMmdaUUdtTjVwQXEyZUtF?=
 =?utf-8?B?N3pYZzRwTG81VU8xR2xoNE9oNWIrdEpzbTRUU3E5NmppTkJQREVMWWNuS0lC?=
 =?utf-8?B?ZXo0WExnMHVSQjdDRU11bGNKdjFqOFQ3TXRVaW5iMzRJOFJ5QzNQWEhJVW5k?=
 =?utf-8?B?dlR5S05ZcDdvbEJOZ2NMb2VsNmtXOHhWMTNQMFhOKzFJNGMxSEUrZGtuWEc2?=
 =?utf-8?B?SXZKdWhqcklRSHp5YUxoTDVHVEYveXhmQms2UTErNFY1WERReS81ODBCa3lm?=
 =?utf-8?B?M1pWdmRncE1WKy9UV3pubHNWN1Y5bHJlYnNDZkVaazYyY0cwbHcvdFN5NHVY?=
 =?utf-8?B?dEdDVXZDV0p4OVdSdmdpRzFIdHB6TytuaFVzLzB4V0N0M3dVZzRyT0tEdS9p?=
 =?utf-8?B?cmw5MHdyU2NobG54UE5lSUMxT0RyWTFxTWI1Q2pXT1ZHWVp4bDZLTGY1K2N0?=
 =?utf-8?B?THRISk9SZ1p4V3VBNkQyVzUyUGpGaVg1V3dxYStXYUw0Q1FQMnFwUWRGR29t?=
 =?utf-8?B?VmpOcjJUVG1UbkViOCtKY09nbkNRZWJNZytTQk8vTmFaMzNmdDdFRzdEK3RH?=
 =?utf-8?B?VnY4QVc2UnI5cUltRTVCVlgxNFYzemF0eUhqVlIxK2M1V3hpQUVEcXpjNjl4?=
 =?utf-8?B?UFhwZktxcis4c2dMQllJZVhtRG13YWJzeXcwSTFIZUVKV3JFYU16YkVVTURn?=
 =?utf-8?B?ZGdPQ0ZLTE1yb1NQTTJ0bWFYU01DQjI4QzY3YUg3V1hkcU9mWWlTNDBrc0hF?=
 =?utf-8?B?cUxEeFdRRGIzQ1NNSWMybXVzY0grckh3VW8rVXhVK29yWkR6bU5hRHFKdG9S?=
 =?utf-8?B?blR6bDNVcnB4b3p0L1BkTXFNaXZjZEZsWENPMnM1QjRKRTRKVDF6MFhGOVRK?=
 =?utf-8?B?TzhrSzdmTUpMSUlEV1dSNTVMdVRhcTFnODREMFJmZnlrb0VDSWh0eTdHMmE2?=
 =?utf-8?B?eHpCZzRrTGdwNEVmdUtCVS9sRy9kM29nbVZ1a2dLSkk5Z29KZXdHWEFRZGVp?=
 =?utf-8?Q?MlfBZX5OBghbCrtTs/Z7Oyk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C346ABA53D28D428BCF4A5C02201D36@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d85c917f-791f-4312-63d8-08d9b99c72bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 16:13:03.9371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eWL8SNG9KOATx/atalZeahmTdEgK5XF2jvF+oFoA1pkbos55yeejX334FGHdMz766rtDDYg5VTE/RUZJfjuncQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBEZWMgMDcsIDIwMjEgYXQgMDQ6NDg6MzlQTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2Vy
IHdyb3RlOg0KPiBFdGhlcm5ldCBmcmFtZXMgY2FuIGJlIGV4dHJhY3RlZCBvciBpbmplY3RlZCBh
dXRvbm9tb3VzbHkgdG8gb3IgZnJvbQ0KPiB0aGUgZGV2aWNl4oCZcyBERFIzL0REUjNMIG1lbW9y
eSBhbmQvb3IgUENJZSBtZW1vcnkgc3BhY2UuIExpbmtlZCBsaXN0DQo+IGRhdGEgc3RydWN0dXJl
cyBpbiBtZW1vcnkgYXJlIHVzZWQgZm9yIGluamVjdGluZyBvciBleHRyYWN0aW5nIEV0aGVybmV0
DQo+IGZyYW1lcy4gVGhlIEZETUEgZ2VuZXJhdGVzIGludGVycnVwdHMgd2hlbiBmcmFtZSBleHRy
YWN0aW9uIG9yDQo+IGluamVjdGlvbiBpcyBkb25lIGFuZCB3aGVuIHRoZSBsaW5rZWQgbGlzdHMg
bmVlZCB1cGRhdGluZy4NCj4gDQo+IFRoZSBGRE1BIGlzIHNoYXJlZCBiZXR3ZWVuIGFsbCB0aGUg
ZXRoZXJuZXQgcG9ydHMgb2YgdGhlIHN3aXRjaCBhbmQNCj4gdXNlcyBhIGxpbmtlZCBsaXN0IG9m
IGRlc2NyaXB0b3JzIChEQ0IpIHRvIGluamVjdCBhbmQgZXh0cmFjdCBwYWNrZXRzLg0KPiBCZWZv
cmUgYWRkaW5nIGRlc2NyaXB0b3JzLCB0aGUgRkRNQSBjaGFubmVscyBtdXN0IGJlIHN0b3BwZWQu
IEl0IHdvdWxkDQo+IGJlIGluZWZmaWNpZW50IHRvIGRvIHRoYXQgZWFjaCB0aW1lIGEgZGVzY3Jp
cHRvciB3b3VsZCBiZSBhZGRlZCBzbyB0aGUNCj4gY2hhbm5lbHMgYXJlIHJlc3RhcnRlZCBvbmx5
IG9uY2UgdGhleSBzdG9wcGVkLg0KPiANCj4gQm90aCBjaGFubmVscyB1c2VzIHJpbmctbGlrZSBz
dHJ1Y3R1cmUgdG8gZmVlZCB0aGUgRENCcyB0byB0aGUgRkRNQS4NCj4gaGVhZCBhbmQgdGFpbCBh
cmUgbmV2ZXIgdG91Y2hlZCBieSBoYXJkd2FyZSBhbmQgYXJlIGNvbXBsZXRlbHkgaGFuZGxlZA0K
PiBieSB0aGUgZHJpdmVyLiBPbiB0b3Agb2YgdGhhdCwgcGFnZSByZWN5Y2xpbmcgaGFzIGJlZW4g
YWRkZWQgYW5kIGlzDQo+IG1vc3RseSB0YWtlbiBmcm9tIGdpYW5mYXIgZHJpdmVyLg0KPiANCj4g
Q28tZGV2ZWxvcGVkLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9v
dGxpbi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRyZSBCZWxsb25pIDxhbGV4YW5kcmUu
YmVsbG9uaUBib290bGluLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ2zDqW1lbnQgTMOpZ2VyIDxj
bGVtZW50LmxlZ2VyQGJvb3RsaW4uY29tPg0KPiAtLS0NCg0KTG9va3MgZ29vZCB0byBtZSwgdGhh
bmtzIQ0KDQpSZXZpZXdlZC1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5Abnhw
LmNvbT4=
