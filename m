Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1ED73A7753
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhFOGsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:48:42 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:51968
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229493AbhFOGsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 02:48:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSJaMheWqPKqJLy1NkvipIQkvORp4i0N3Nluj8NFROly0Ph1aC0XrOIlwOlZJgaWaFXezarOmbGd/Z6gIlJVixKRMFLi5kD2B2OvbMdi8TnYlilhbS6dnSxEHvrHoyqnMMOXOhMccWZUq3LuP0Lcm3EeaA71b5SA+WqDaAkoWgtaLjIirCrR477+HMOfrFlSiciNNUIZgH7imf0DzSECsIOoyXL6cdCpMzlPQ9ZaIurRESKruVcumZBm1Fw1mLAk0iKrmR2ziW29rMUs+IlfLsFZ52QszlcIZKeE0qO3VrBD3558LsGptL9K4ZHRmvL8Ai6RzoUYI4+5adyWKnM31w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMrHahKi8lMsV/AP4jJ78LM8mMtP8zVKZgIwKErWmlg=;
 b=Ma430iP5yYUbPFsleJmAThwdDmwkXldiUM6O0ANeVgHG4R10x6kux8RFhFrbIYX5+UC8L9+TeialqpI616BMDL5yruhgivxlJ3i9pDwAxe7TOUvF2hwFv76RAnxCW3cH9H2B/t/NiiiKhUpWJL5625wFco4PxqzqKQGOB+b2S2EWFXce0/NoM8QJtDWPOFxJerYXTt0XDCDSvQwIzChn1T2QHIymvvPNtf378yD8P8OEyo5moIEjBSima42ezEJ6Hf0h0e2tkokvbq0nNzF1cvfAyOZ5jlUQGBTYU7xf+3aZMVBvK5faWVQiIxVRxiAgXxsFky0fD/lQo6HqfCYmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMrHahKi8lMsV/AP4jJ78LM8mMtP8zVKZgIwKErWmlg=;
 b=HvS57R6p859XKiMB72WMYQmguIJ0bDQ4HRKiGwbxyOxlav3wmxTshOy4aGBqFxztfdfrVaqvOl9dLM/07GX1Wdhym7vMvlRNkgPcE1jAGsP8Jr7oo3qMlU1yO8QeMigDIytQe4pFxhWLrncJ+78Bpu6YPsxaUDCW0gLxMHPgF2U=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5787.eurprd04.prod.outlook.com (2603:10a6:10:ac::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Tue, 15 Jun
 2021 06:46:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 06:46:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Topic: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Thread-Index: AQHXXqdJJp2Y2RcztU6Ho2b70gc0WqsPQnYAgAVNuXA=
Date:   Tue, 15 Jun 2021 06:46:34 +0000
Message-ID: <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
In-Reply-To: <20210611.132514.1451796354248475314.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9782313b-cfa2-4317-33e9-08d92fc9516f
x-ms-traffictypediagnostic: DB8PR04MB5787:
x-microsoft-antispam-prvs: <DB8PR04MB578799BE9D51832AD66936D6E6309@DB8PR04MB5787.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jUPJg3cO3Wmkd4uj8+cGf2eKehVBS6vKpyEj6bqt49hjLH2SqoF8QpFhZEKwmXdgtApc0kZIT+kHgRAYVzwkNpmlHGpqMXy2b2yQ9S5CkncqV2oPLhm3/MKmKwSyGyaEPSEBN1GgXOrB/eGY8DXb2FNUEFk9/FyEgxs7VmyiPYDJu76HV6NCTNvT9JVFpu/4VTZBzqqKEuD+9Qr37DQv4KN1NFN3WznZlaqSFyfHtdQM/4+AoHTt4EBXMxHtsWl10S95Voc0a9Fj48DRPX7UwF3zsNyPW/aJRSkdt4+ETUTFg51NMWbvK7pRaZ463qEakC2fRX28aM+8UbapyjkJPrvWAIfjs7EsWFQqRePbEznBEQAXOgoScQ6D2+cntQD83E9Nhp5JzFmqB/D7HAOOhMBLhP8s/VHkb6zYSlWXaZWDO0SNcpW14U78snNBxPCkGO/WOkdUExfBuatkQ6cwp1YashT/drR4SNvYZp1I7oxVwJcriBQpJ3zTNzrW2YyL/E37+JF6g6Zj3YXppA7+jRi/uutB0/YgAOXc9gGUOmDoNU83lVJIB023StvW4wcuUE4akv5sZppsN+/6flzh+eUuLIxaILofOgZfR+0APsgvkHRo/4jjZyuusuOPbkAfX9oQtVvEYh2vELytM+i4B7dFunNMY0gQnESK6wUlp3jxXa53OLRE/PpK6QU1rd6cxQGgX7wFn2EGHYQfQ/ysgA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(366004)(39860400002)(83380400001)(33656002)(478600001)(316002)(45080400002)(54906003)(9686003)(8676002)(52536014)(5660300002)(55016002)(966005)(71200400001)(6916009)(122000001)(86362001)(8936002)(38100700002)(2906002)(66476007)(64756008)(66556008)(66946007)(76116006)(26005)(186003)(4326008)(53546011)(7696005)(6506007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?RnhoWmx4RDBSTHBLVk1IOVdJM2lGdklDNFFNUnZqU2t3bUxKV1lOdlUwNy9Q?=
 =?gb2312?B?TVlRQm1tVDZwZnhKRGQyY0dOSGJSTmFnRHBhN2I3bjhjbVlkdU5NMENiU0po?=
 =?gb2312?B?bDN1ekYxWU82V0d6WTJ5bE1nS0x6NTZSb29SUFVFcjA1SnN3Q25HbVFEYkZT?=
 =?gb2312?B?bEthSDRwVlZmME95VFV2TzIvUmNibzQwUDdBRERLemRTdjBCcXZSSGN4eFRq?=
 =?gb2312?B?dTVKRU1hL2lWMkNvRWthZ0NiS01RMEJ2MGxmTzFPQnR4Q2FlOEtJUlBCbDh2?=
 =?gb2312?B?NVhsUlFDdVVwSnZYNEMvRGtKVDJxd2o2b3cxS0pBZGZMK3JncEV1M2ZIcktj?=
 =?gb2312?B?QUdrSzVzVjBYU3VWNm9aZkYvMzdvdHRGcjlLR1VMdkhkSDRkOHhCbXQ2cUUz?=
 =?gb2312?B?SUxHV3k5cUFKRXB2RWZZeURtOUd1M1BzemFoRDlHTnlIOFJRaTgwMDNNV3Zj?=
 =?gb2312?B?dktxdk1MS052Q3dSNUpsdGlXdGdXb1pHWGZXQUU1SytYSS9tUlY5a1ZJMm1T?=
 =?gb2312?B?am4weEtIdzY5eFJIMG5qRUdubkpkUFppZlNDK1VYYjNCV1Iyd0t5Mm1vdDhH?=
 =?gb2312?B?TDc2Vi9JY0gzd0RuWmRVK3UrMFJMTVQxNFNUeGkxQjJsMHZSNmY5K2hEaXFy?=
 =?gb2312?B?bVJORU4zMDFpb1dyTWZRTXpIYkFNWmlzLzN2ZEYxUTVkQ2RpOTJqWnEwTXU2?=
 =?gb2312?B?bVpNV244aFEyVXcwK09XeW5OcWlCM2V1ejU4V2FnbkMyN3ZvNUpzcmNhTWJm?=
 =?gb2312?B?QlJnL29Hd3J5bHhZWmZGRjZQbmJER04vYXNiUmE5UE9jTTlXWVhmOXY5Y1pm?=
 =?gb2312?B?eGhnbUwxUFZhRis2TndWWUc0SXFHcUtoaTdTQy9rYzJlcFlIV0xRRGczblRk?=
 =?gb2312?B?VGx2RGNoRVZIY0ZmZGNUUVBUNXdiY3JlaExkbXdYQTBtWXNMbEgybDgzV1Qy?=
 =?gb2312?B?MitmcEdYck90OS81ZVBFaytBaU9UMmlqOW44VEVITkhmM1paRnpmdUt0MGxr?=
 =?gb2312?B?R08xeGtvaEVhRkg2TVdPa0E3NFNNaTVlR0QwMWwxV2xVdDVlTlZ3V3lqQTh3?=
 =?gb2312?B?UnZRVERrUlVhMUJDSXlyNFprakp6YzZDTHFjVEhvcWEzaFJJTU9TRXVReUZu?=
 =?gb2312?B?WTV5ZkNwQ0hXR204TjZORkJUcVFkcTBndmNIZEJJWkhrTjVuK256OUw2RHBQ?=
 =?gb2312?B?RWxkdUZ1bUxoQnRpVUVrTVhhYXl2K0tvdXB1OHhsQWZFdW05bGNCYVlnbFBP?=
 =?gb2312?B?NGg4ckZJbzhwUmdTbTJESzJqYU9mdkZIcE1QYWoxbVJmWFNXSm0rMlV5OW1V?=
 =?gb2312?B?UHBIWFZyZnNkUC9nMzg3NUd5cTBSaExhcXpJZlJpOHo0MmpGcjkvTVprZzRT?=
 =?gb2312?B?S0lZVTFBZWk1UWNBZDJJKzMrQ0Iva3c1Z2gzK09zUVRyM29LYzNwQzBtbzVC?=
 =?gb2312?B?RlA3eEhRaEhCa1pLOHdHRUFTUC9MK2lhRkpKWGhXSGpwaUlMNWNJRDBEbm12?=
 =?gb2312?B?NGtyVmUyNVVkSlhIQnJ5ZVNFVmQvZ3RXTUI3aGNUbkVQdkZYbzhXWVlNaFB5?=
 =?gb2312?B?OFRxdm9MVmhYbXdBankyS0t6V2dSN1JCRFIxbyswUXFWNWtlTG5ZM3VRbUxV?=
 =?gb2312?B?bktPY2gwY2w5WGlyN2Z1YXhXK3FlRUQva3NzdjhUMVE1WElDUlIzTmlKVEFu?=
 =?gb2312?B?bVNVQ3FNKzRqTWMyQzE3UUpiTm10MVd3V3VDUDEvR1VJcGllREZXMU5QdmQv?=
 =?gb2312?Q?TD6KI4WvwRNlscCo24=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9782313b-cfa2-4317-33e9-08d92fc9516f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2021 06:46:34.9386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P15cqu823KRAfDmaNe5se1/gfL9aYKoS7jtO4FnGvlU4liBOgn9OJk/NboFSv1JpN8Wx7tIKt3mQ8VWtbfUovQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5787
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBEYXZpZCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZp
ZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IFNlbnQ6IDIwMjHE6jbUwjEyyNUgNDoy
NQ0KPiBUbzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGt1
YmFAa2VybmVsLm9yZzsgZnJpZWRlci5zY2hyZW1wZkBrb250cm9uLmRlOyBhbmRyZXdAbHVubi5j
aDsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYyIG5ldC1uZXh0IDAvMl0gbmV0OiBmZWM6IGZpeCBU
WCBiYW5kd2lkdGggZmx1Y3R1YXRpb25zDQo+IA0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5n
cWluZy56aGFuZ0BueHAuY29tPg0KPiBEYXRlOiBGcmksIDExIEp1biAyMDIxIDE3OjUwOjAzICsw
ODAwDQo+IA0KPiA+IFRoaXMgcGF0Y2ggc2V0IGludGVuZHMgdG8gZml4IFRYIGJhbmR3aWR0aCBm
bHVjdHVhdGlvbnMsIGFueSBmZWVkYmFjayB3b3VsZA0KPiBiZSBhcHByZWNpYXRlZC4NCj4gPg0K
PiA+IC0tLQ0KPiA+IENoYW5nZUxvZ3M6DQo+ID4gCVYxOiByZW1vdmUgUkZDIHRhZywgUkZDIGRp
c2N1c3Npb25zIHBsZWFzZSB0dXJuIHRvIGJlbG93Og0KPiA+DQo+IGh0dHBzOi8vZXVyMDEuc2Fm
ZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmxvcmUua2Vy
DQo+IG5lbC5vcmclMkZsa21sJTJGWUswQ2U1WXhSMldZYnJBbyU0MGx1bm4uY2glMkZUJTJGJmFt
cDtkYXRhPTA0JTcNCj4gQzAxJTdDcWlhbmdxaW5nLnpoYW5nJTQwbnhwLmNvbSU3QzQ1Yjc4NmM4
NWEyOTRiM2VhOWVjMDhkOTJkMTcwOQ0KPiAwYyU3QzY4NmVhMWQzYmMyYjRjNmZhOTJjZDk5YzVj
MzAxNjM1JTdDMCU3QzAlN0M2Mzc1OTAzOTkyMjU2NDUNCj4gNzU5JTdDVW5rbm93biU3Q1RXRnBi
R1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlqb2lWMmx1TXpJDQo+IGlMQ0pCVGlJNklr
MWhhV3dpTENKWFZDSTZNbjAlM0QlN0MxMDAwJmFtcDtzZGF0YT1DRmVMNHJOV3FOczRYYw0KPiAy
TnF0QmlReGV4NCUyRlhBVWhFWFdRcmVmdEZoblk0JTNEJmFtcDtyZXNlcnZlZD0wDQo+ID4gCVYy
OiBjaGFuZ2UgZnVuY3Rpb25zIHRvIGJlIHN0YXRpYyBpbiB0aGlzIHBhdGNoIHNldC4gQW5kIGFk
ZCB0aGUNCj4gPiAJdC1iIHRhZy4NCj4gDQo+IFBsZWFzZSBmaXggdGhlc2Ugd2FybmluZ3MgaW4g
cGF0Y2ggIzI6DQo+IA0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxv
b2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZwYXRjaHcNCj4gb3JrLmhvcHRvLm9yZyUyRnN0YXRp
YyUyRm5pcGElMkY0OTg3MjklMkYxMjMxNTIxMSUyRmJ1aWxkX2FsbG1vZGNvbmZpDQo+IGdfd2Fy
biUyRnN1bW1hcnkmYW1wO2RhdGE9MDQlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5jb20l
DQo+IDdDNDViNzg2Yzg1YTI5NGIzZWE5ZWMwOGQ5MmQxNzA5MGMlN0M2ODZlYTFkM2JjMmI0YzZm
YTkyY2Q5OWM1YzMwDQo+IDE2MzUlN0MwJTdDMCU3QzYzNzU5MDM5OTIyNTY0NTc1OSU3Q1Vua25v
d24lN0NUV0ZwYkdac2IzZDhleQ0KPiBKV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklp
TENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJQ0KPiA3QzEwMDAmYW1wO3NkYXRhPWViNFVq
eDJGS09udTVNNDFqMVJuUExDQm9Fb0dmUWlDTyUyQk81TXpJc1h5RQ0KPiAlM0QmYW1wO3Jlc2Vy
dmVkPTANCg0KSSBjYW4ndCByZXByb2R1Y2UgdGhlc2Ugd2FybmluZ3Mgd2l0aCAiIG1ha2UgQVJD
SD1hcm02NCBhbGxtb2Rjb25maWciLCBjb3VsZCB5b3UgcGxlYXNlIHNob3cgbWUgdGhlIGNvbW1h
bmQgeW91IHVzZWQ/IFRoYW5rcy4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IFRo
YW5rIHlvdS4NCg==
