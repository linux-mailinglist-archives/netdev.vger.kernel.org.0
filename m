Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8BB46BCFA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhLGNze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:55:34 -0500
Received: from mail-eopbgr20070.outbound.protection.outlook.com ([40.107.2.70]:17399
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232089AbhLGNzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 08:55:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFoi3KTXmb01nI7F//UREWlIH7/SsJ/noB9EqFlVFuIqpuuNqe1rWuL2sWf9DP9bSHNzymDkp11GG2VNKW67la8+O+ecgT6iw9tc8888ypIa6Nd0vNaT/qk9onLrfQfQAx6C9SUNyGORMD0fSdBTqEuHtFiklVRyRfEzW6TzCJx2DgJ6VRlQ240dngS0LdXthlbRRqbKHL6vpwEh/eQ4a/j8skq1CJK2aMfzKKAxW35972/p36L5LR45GggdtF8R/uBD1nDrQR0fzn/bN1DV8X9GN3Wn4RMGhJHG+JHP0289Hitgy5pmGYqP5+O41DGFlDCwMC0FwG1je8z4xNITQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NRI5tv5VmlQnudXct3gTreM7SjSUoDEMpRPn/ZVJBAo=;
 b=XhOuwlNMjGd/K1Tpxe8ZWNT39W7X8i2QnHeq6O7m1YWH0PSX0lWxtad6ItFd9kK4Fpwlb24uigRLAYHmLN2XRFt3g6I4oOtIV1/6rKjAJ6dmXciJES7+sxCyS09gBOnfteQRVCmw3RLV2pTWU1C6+p2iyLb8XB3ZS0uC7hfVeDCzbHU8bbbYNZQ3byQqyq+jFLGdIAYfUwAqwjBUvP6+jP8fivrN6pMysQqrLjQWfHGvreoFJMVYV5O6FASLzqTBS8NRyLQgbT1UrvEAod7GOo4WlPWfRx378KtG6gHvG82h9+47aIhwa7fIVj2Sus9N5rJuu+SWDortlSeK3A2kmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRI5tv5VmlQnudXct3gTreM7SjSUoDEMpRPn/ZVJBAo=;
 b=Fy3ezUerl07hS+GBnRl0l36zusRCDSL/oJVBgi5aGK5glVBvPyPjOCwbHdR+3HDo2pCvAsnzdi2TOclfnOwSIY8zx38Hv5AQ/o0mFfQpehx8SMhu9TpiexdMm2NO7jIuqFsow52vZU+Ln6bOZ8blUZblt6GGQkynbueCi5Tv8kk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 13:52:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 13:52:01 +0000
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
Subject: Re: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v5 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX60pT2N9heOAMh0yw/W+Yi1Q3QKwnDKEA
Date:   Tue, 7 Dec 2021 13:52:01 +0000
Message-ID: <20211207135200.qvjaw6vkazfcmuvk@skbuf>
References: <20211207090853.308328-1-clement.leger@bootlin.com>
 <20211207090853.308328-5-clement.leger@bootlin.com>
In-Reply-To: <20211207090853.308328-5-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a41efe1-6072-4e44-1ea2-08d9b988be77
x-ms-traffictypediagnostic: VI1PR04MB5342:EE_
x-microsoft-antispam-prvs: <VI1PR04MB53426270AD7E2D0EDFD61F5CE06E9@VI1PR04MB5342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDe2da+GqX2s0c/s3e86EX2gLSs/S8smQBPdYzfwnhhhi4Glar2KlOrxdu/IPkE971Y6yMtgYXHOcvNvo28kRpK3uITmfssaPwaH5Pd8fVNWr4owWbw+rW95nPIAtcybwkE2TiZLJrNC4TEq6vWJRf8cejhc/1Z0hieCPCK3OdYkNWdcY4QgyVJNeAYXTykfejUievHQdv18obcn6k0XXawOe7/WQ/rd5i5bQ2yEwv44me3a+ksIHJLSzEW8PgnexW8UiZcG5U7FoWAeKSK4BW9km8Def0DU4fX6S4xS5g1gR7mZQzfU9mlUpQ/+CRE1vYXbS0OChkeuijOsCDkf59BfPXKTkMj4URF0Y7mqMODBf1ZfC08SH1U3JNVsh8j42mIN3gzfc0YU3kQfTtiOs6dari0smSpC0DaogmidLB9cfnWy7TgcnU9KQ+ih1xNNEhINb5b9pULfUmPbFe9iJtcWmkgsSunZsmZoSRN3XJepPIHvncsE1auOHdoQgknVWB/fP09Aie8qb5F13f2UUV6tAPXy8tE0Y4XkExevlMhMSJSllpP0NrOaphptJLVj7/GdOP/4U7azuCiSvOLYD4A8qv4Ot7IGxv+r3MSMH7VyllZtKQsdJBkgHIlGpkR1W8MHIq3XmTUbKjVhtbJuYhUB/1OM2c9FVoj45Y6HXoZpSeL1EH0+gf/S/s0rQjjO/xngyNJf8gAekMS3iaa0fQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(44832011)(2906002)(8936002)(66574015)(6506007)(33716001)(4326008)(1076003)(26005)(91956017)(9686003)(6486002)(66556008)(64756008)(76116006)(7416002)(6512007)(66946007)(8676002)(38100700002)(83380400001)(66446008)(86362001)(6916009)(38070700005)(71200400001)(508600001)(186003)(316002)(5660300002)(66476007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nm1lMHpLY1hlOFdVb3V5emd6UFNZTDJYeGVWRThRL2lqS3VGY3dTRGpLU0o4?=
 =?utf-8?B?azFLNEJ5V0F4cnROclhHUklFbXFXOWJoZUcrZjZUM2JGd3piZlBBNFBzZS9o?=
 =?utf-8?B?Z1IvaXZ4QlBta0xsVzFmU1Z4VkdnZFJVNWtPWkFCTFluMXR4UWQ3WDFuMkhi?=
 =?utf-8?B?WGZud1NXa2VvaWZrZnBjWFhFeERrejNRTXVNS202MFF1bHJHck95c3ZqQ3pi?=
 =?utf-8?B?UGdYV3M1bFIvQVJFa3k5T3dxalNtb3VlYUVHVERwb1RLOWErTWZFZEgzYXpj?=
 =?utf-8?B?bjhWeUROb3Y4SWpDZXN2Z1NLVzVxdUxkM1R2K1dEQll1dFpWYjRBa2laZ3pW?=
 =?utf-8?B?bzRxZmV5Ukc3SHBlTzJ5ejd4bzFTUURHQVByVUdNYnhhTWdteWZvSnk0NDk1?=
 =?utf-8?B?QmZLeitQRTFKVlhEamc4c0RLSENDdFdjOGczbUlyMjNtRWd6Z3dvOXRKOGdt?=
 =?utf-8?B?MWIvbWZyZWFLbnhFOEdVc1V3UHVOSy9EUUZ5QVJFYmN0Q01vTjRmb2VzN2Ro?=
 =?utf-8?B?eWVpRFppc2QvQ0psaFBwYW9GUzhzSmZEd0xLcnpYaWVtTGE4eElJczdwRGkr?=
 =?utf-8?B?VmJ3UjFNUEFvREJwdVQ2ZkVnWnlwK0tjZjIwVnk1cVlYZmFLdnhCMFIwaTR3?=
 =?utf-8?B?cmJmWlZJaFpOQThUVEhRY043NkVsaVV6YlV3L01Oa2xqUUNxcmpJS3RBYTRk?=
 =?utf-8?B?WnVJenFiSzEvZTlBY1lJeFR5SVdHc3pxeDgzNmQxanY5cVlIbCt1Tk1EV0Fn?=
 =?utf-8?B?ZnphUjJGTGo3VVNaenVGL0NtcVFLZHM4VlNJd21ab2pMNFpUWUVxUC9EMXpV?=
 =?utf-8?B?dGFmRFBmKzhPdDhjSmloWVpUdVZQOWx1RkMyVm1FYUhjZXRwMWpTSlNSNEF5?=
 =?utf-8?B?NDJFU0ZNVGpOalVKaWVubVVMM21wY1lGYlRRTDZNTjgvdkNOK0RseFgrTzg0?=
 =?utf-8?B?K1JIL3NibVRyZFlyRDRsNERjT0dNRy9ZaXJxNGNhckZIRmphU09mdDVtSm1r?=
 =?utf-8?B?dWw2WW0rcFcxUWt6QlB2L0JZTkR6YmxiZzJtNEZOOU1qcFc1YnYxMm94NStq?=
 =?utf-8?B?ZWdkS2Jmc09vYXI3TmZHUlRpaFpHMDBhSlZsc0R2VWFLYm9DdUhBVWpmVnZ2?=
 =?utf-8?B?QmRPa0gyS0pEaDU2NWNPRER0c0VGTHZvVDhWMTBoNnJCeVZtN1FWd3JCVVBQ?=
 =?utf-8?B?aTl2all2WTJFdFM3NTFlNXRKRGhHTzRmSzV2RXByZ1hpdlZjNnh1NTI1a1FH?=
 =?utf-8?B?Y1VhTlI4YW85d2ErTlNoUXNkbEFWOHMvanZLdis4R3R0TDdVbFRaVHE5aXkw?=
 =?utf-8?B?emNqb3NLRGZ6eG9KemU2NE5xLys5Nmk2RjZGUHU0b2Y3NGtEeDIrTHhqUmFU?=
 =?utf-8?B?L1M1aE5lVXdxam85bFVJeXNFMFBmYW5EaXM0ampsbUZMUWNpZTJmdWptRC9Y?=
 =?utf-8?B?d0cxYlVzVEpDZFJrY3liUk1rek8yWnVLMkZvKzdhRGYwRkYwRWF5djFKajJD?=
 =?utf-8?B?ZTVXTy80NXVHdDZsYVY2bzFFbndtK2VmcXZrc1VTMTQ4am1rSHNON2Z0VFdr?=
 =?utf-8?B?RFAzcmNrVzdMbjNTeGVMN1I3dEhPZE9NRTZ1cTFac3RzeDVPMnArUTNnK2Ja?=
 =?utf-8?B?K2I3SVJRWU83QVg4NC9Udk9jc0ZkQ2h4WlkvMlBIQkZGNFdyZ1E4ZzBSeDE5?=
 =?utf-8?B?OUNXbmhDanUwN3lsaHhSRy9nbmY3Wmc2emJ6OHNvbitNQTBRVWJOK2w0L1R0?=
 =?utf-8?B?WlFXa2tvdnVTM2RocTdvakdyei81d3lnOVpvWWdGM2svQWN5a0lmNzZNRzlu?=
 =?utf-8?B?YkxqOXA5MFg5V1ZkUVR1cTJ5UmVBcytBaUtJRS82TzJWTnkvNlFFSzZ2N1Mr?=
 =?utf-8?B?bTdPZHI1VUFSRGwzYzZqeUtPdVZWbzgxZkVhV0cyaUFCcEN1aDQwend6ZXdj?=
 =?utf-8?B?RzJHMm5rVTh3bFZabUdTUFh1aGl0OUZ4VkRvUGE0TW9Nc1pGT1E3UWQwUzRh?=
 =?utf-8?B?aVhWcm1XbnRqK1dGV2VLb1hCT0xEek4yTnlPa3gvSGxqU2hSaUVoZ1JDcXNC?=
 =?utf-8?B?alZ3dDAyeTAwSEVvYU5IbUVWMlMxNk9jb2FRcmJYcnhaMjFjYnBsM2EzdE0v?=
 =?utf-8?B?ZXJPVE1JOGpxdjFDWnR3RTYwNGlDeHJJQ081TW9FTEllMll2KytiNWtJcXk5?=
 =?utf-8?Q?K43msqQsRiVJ8xow+LZAaR0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <334E3B3A07A0AD4AA189B13BAE17DB66@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a41efe1-6072-4e44-1ea2-08d9b988be77
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 13:52:01.1335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1QRDYbNb3HEQ/gvEZzRoeA/GH5Y/ErLt5xmiPJ3L55c91qKRxvyDKZeSnFBITvZU6zvUw9mZkFSCGwGph8RFrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBEZWMgMDcsIDIwMjEgYXQgMTA6MDg6NTNBTSArMDEwMCwgQ2zDqW1lbnQgTMOpZ2Vy
IHdyb3RlOg0KPiBFdGhlcm5ldCBmcmFtZXMgY2FuIGJlIGV4dHJhY3RlZCBvciBpbmplY3RlZCBh
dXRvbm9tb3VzbHkgdG8gb3IgZnJvbQ0KPiB0aGUgZGV2aWNl4oCZcyBERFIzL0REUjNMIG1lbW9y
eSBhbmQvb3IgUENJZSBtZW1vcnkgc3BhY2UuIExpbmtlZCBsaXN0DQo+IGRhdGEgc3RydWN0dXJl
cyBpbiBtZW1vcnkgYXJlIHVzZWQgZm9yIGluamVjdGluZyBvciBleHRyYWN0aW5nIEV0aGVybmV0
DQo+IGZyYW1lcy4gVGhlIEZETUEgZ2VuZXJhdGVzIGludGVycnVwdHMgd2hlbiBmcmFtZSBleHRy
YWN0aW9uIG9yDQo+IGluamVjdGlvbiBpcyBkb25lIGFuZCB3aGVuIHRoZSBsaW5rZWQgbGlzdHMg
bmVlZCB1cGRhdGluZy4NCj4NCj4gVGhlIEZETUEgaXMgc2hhcmVkIGJldHdlZW4gYWxsIHRoZSBl
dGhlcm5ldCBwb3J0cyBvZiB0aGUgc3dpdGNoIGFuZA0KPiB1c2VzIGEgbGlua2VkIGxpc3Qgb2Yg
ZGVzY3JpcHRvcnMgKERDQikgdG8gaW5qZWN0IGFuZCBleHRyYWN0IHBhY2tldHMuDQo+IEJlZm9y
ZSBhZGRpbmcgZGVzY3JpcHRvcnMsIHRoZSBGRE1BIGNoYW5uZWxzIG11c3QgYmUgc3RvcHBlZC4g
SXQgd291bGQNCj4gYmUgaW5lZmZpY2llbnQgdG8gZG8gdGhhdCBlYWNoIHRpbWUgYSBkZXNjcmlw
dG9yIHdvdWxkIGJlIGFkZGVkIHNvIHRoZQ0KPiBjaGFubmVscyBhcmUgcmVzdGFydGVkIG9ubHkg
b25jZSB0aGV5IHN0b3BwZWQuDQo+DQo+IEJvdGggY2hhbm5lbHMgdXNlcyByaW5nLWxpa2Ugc3Ry
dWN0dXJlIHRvIGZlZWQgdGhlIERDQnMgdG8gdGhlIEZETUEuDQo+IGhlYWQgYW5kIHRhaWwgYXJl
IG5ldmVyIHRvdWNoZWQgYnkgaGFyZHdhcmUgYW5kIGFyZSBjb21wbGV0ZWx5IGhhbmRsZWQNCj4g
YnkgdGhlIGRyaXZlci4gT24gdG9wIG9mIHRoYXQsIHBhZ2UgcmVjeWNsaW5nIGhhcyBiZWVuIGFk
ZGVkIGFuZCBpcw0KPiBtb3N0bHkgdGFrZW4gZnJvbSBnaWFuZmFyIGRyaXZlci4NCj4NCj4gQ28t
ZGV2ZWxvcGVkLWJ5OiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxp
bi5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRyZSBCZWxsb25pIDxhbGV4YW5kcmUuYmVs
bG9uaUBib290bGluLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ2zDqW1lbnQgTMOpZ2VyIDxjbGVt
ZW50LmxlZ2VyQGJvb3RsaW4uY29tPg0KPiAtLS0NCg0KPiArc3RhdGljIHZvaWQgb2NlbG90X2Zk
bWFfc2VuZF9za2Ioc3RydWN0IG9jZWxvdCAqb2NlbG90LA0KPiArCQkJCSBzdHJ1Y3Qgb2NlbG90
X2ZkbWEgKmZkbWEsIHN0cnVjdCBza19idWZmICpza2IpDQo+ICt7DQo+ICsJc3RydWN0IG9jZWxv
dF9mZG1hX3R4X3JpbmcgKnR4X3JpbmcgPSAmZmRtYS0+dHhfcmluZzsNCj4gKwlzdHJ1Y3Qgb2Nl
bG90X2ZkbWFfdHhfYnVmICp0eF9idWY7DQo+ICsJc3RydWN0IG9jZWxvdF9mZG1hX2RjYiAqZGNi
Ow0KPiArCWRtYV9hZGRyX3QgZG1hOw0KPiArCXUxNiBuZXh0X2lkeDsNCj4gKw0KPiArCWRjYiA9
ICZ0eF9yaW5nLT5kY2JzW3R4X3JpbmctPm5leHRfdG9fdXNlXTsNCj4gKwl0eF9idWYgPSAmdHhf
cmluZy0+YnVmc1t0eF9yaW5nLT5uZXh0X3RvX3VzZV07DQo+ICsJaWYgKCFvY2Vsb3RfZmRtYV90
eF9kY2Jfc2V0X3NrYihvY2Vsb3QsIHR4X2J1ZiwgZGNiLCBza2IpKSB7DQo+ICsJCWRldl9rZnJl
ZV9za2JfYW55KHNrYik7DQo+ICsJCXJldHVybjsNCj4gKwl9DQo+ICsNCj4gKwluZXh0X2lkeCA9
IG9jZWxvdF9mZG1hX2lkeF9uZXh0KHR4X3JpbmctPm5leHRfdG9fdXNlLA0KPiArCQkJCQlPQ0VM
T1RfRkRNQV9UWF9SSU5HX1NJWkUpOw0KPiArCS8qIElmIHRoZSBGRE1BIFRYIGNoYW4gaXMgZW1w
dHksIHRoZW4gZW5xdWV1ZSB0aGUgRENCIGRpcmVjdGx5ICovDQo+ICsJaWYgKG9jZWxvdF9mZG1h
X3R4X3JpbmdfZW1wdHkoZmRtYSkpIHsNCj4gKwkJZG1hID0gb2NlbG90X2ZkbWFfaWR4X2RtYSh0
eF9yaW5nLT5kY2JzX2RtYSwgdHhfcmluZy0+bmV4dF90b191c2UpOw0KPiArCQlvY2Vsb3RfZmRt
YV9hY3RpdmF0ZV9jaGFuKG9jZWxvdCwgZG1hLCBNU0NDX0ZETUFfSU5KX0NIQU4pOw0KPiArCX0g
ZWxzZSB7DQo+ICsJCS8qIENoYWluIHRoZSBEQ0JzICovDQo+ICsJCWRjYi0+bGxwID0gb2NlbG90
X2ZkbWFfaWR4X2RtYSh0eF9yaW5nLT5kY2JzX2RtYSwgbmV4dF9pZHgpOw0KPiArCX0NCj4gKwlz
a2JfdHhfdGltZXN0YW1wKHNrYik7DQo+ICsNCj4gKwl0eF9yaW5nLT5uZXh0X3RvX3VzZSA9IG5l
eHRfaWR4Ow0KDQpZb3UndmUgZGVjaWRlZCBhZ2FpbnN0IG1vdmluZyB0aGVzZSBiZWZvcmUgb2Nl
bG90X2ZkbWFfYWN0aXZhdGVfY2hhbj8NClRoZSBza2IgbWF5IGJlIGZyZWVkIGJ5IG9jZWxvdF9m
ZG1hX3R4X2NsZWFudXAoKSBiZWZvcmUNCnNrYl90eF90aW1lc3RhbXAoKSBoYXMgYSBjaGFuY2Ug
dG8gcnVuLCBpcyB0aGlzIG5vdCB0cnVlPw0KDQo+ICt9DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF92c2M3NTE0LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tc2NjL29jZWxvdF92c2M3NTE0LmMNCj4gaW5kZXggY2QzZWIxMDFmMTU5Li5iZWU4ODNhMGI1
YjggMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X3ZzYzc1
MTQuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tc2NjL29jZWxvdF92c2M3NTE0LmMN
Cj4gQEAgLTE4LDYgKzE4LDcgQEANCj4NCj4gICNpbmNsdWRlIDxzb2MvbXNjYy9vY2Vsb3RfdmNh
cC5oPg0KPiAgI2luY2x1ZGUgPHNvYy9tc2NjL29jZWxvdF9oc2lvLmg+DQo+ICsjaW5jbHVkZSAi
b2NlbG90X2ZkbWEuaCINCj4gICNpbmNsdWRlICJvY2Vsb3QuaCINCj4NCj4gICNkZWZpbmUgVlND
NzUxNF9WQ0FQX1BPTElDRVJfQkFTRQkJCTEyOA0KPiBAQCAtMjc1LDYgKzI3NiwxOCBAQCBzdGF0
aWMgY29uc3QgdTMyIG9jZWxvdF9wdHBfcmVnbWFwW10gPSB7DQo+ICAJUkVHKFBUUF9DTEtfQ0ZH
X0FESl9GUkVRLAkJCTB4MDAwMGE4KSwNCj4gIH07DQo+DQo+ICtzdGF0aWMgY29uc3QgdTMyIG9j
ZWxvdF9mZG1hX3JlZ21hcFtdID0gew0KPiArCVJFRyhQVFBfUElOX0NGRywJCQkJMHgwMDAwMDAp
LA0KPiArCVJFRyhQVFBfUElOX1RPRF9TRUNfTVNCLAkJCTB4MDAwMDA0KSwNCj4gKwlSRUcoUFRQ
X1BJTl9UT0RfU0VDX0xTQiwJCQkweDAwMDAwOCksDQo+ICsJUkVHKFBUUF9QSU5fVE9EX05TRUMs
CQkJCTB4MDAwMDBjKSwNCj4gKwlSRUcoUFRQX1BJTl9XRl9ISUdIX1BFUklPRCwJCQkweDAwMDAx
NCksDQo+ICsJUkVHKFBUUF9QSU5fV0ZfTE9XX1BFUklPRCwJCQkweDAwMDAxOCksDQo+ICsJUkVH
KFBUUF9DRkdfTUlTQywJCQkJMHgwMDAwYTApLA0KPiArCVJFRyhQVFBfQ0xLX0NGR19BREpfQ0ZH
LAkJCTB4MDAwMGE0KSwNCj4gKwlSRUcoUFRQX0NMS19DRkdfQURKX0ZSRVEsCQkJMHgwMDAwYTgp
LA0KPiArfTsNCg0KZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfdnNjNzUxNC5jOjI3
OToxODogd2FybmluZzog4oCYb2NlbG90X2ZkbWFfcmVnbWFw4oCZIGRlZmluZWQgYnV0IG5vdCB1
c2VkIFstV3VudXNlZC1jb25zdC12YXJpYWJsZT1dDQogIDI3OSB8IHN0YXRpYyBjb25zdCB1MzIg
b2NlbG90X2ZkbWFfcmVnbWFwW10gPSB7DQogICAgICB8ICAgICAgICAgICAgICAgICAgXn5+fn5+
fn5+fn5+fn5+fn5+DQoNCk5vdCB0byBtZW50aW9uIHRoaXMgaXNuJ3QgZXZlbiB0aGUgRkRNQSBy
ZWdtYXAuDQoNCj4gKw0KPiAgc3RhdGljIGNvbnN0IHUzMiBvY2Vsb3RfZGV2X2dtaWlfcmVnbWFw
W10gPSB7DQo+ICAJUkVHKERFVl9DTE9DS19DRkcsCQkJCTB4MCksDQo+ICAJUkVHKERFVl9QT1JU
X01JU0MsCQkJCTB4NCksDQo+IEBAIC0xMDQ4LDYgKzEwNjEsNyBAQCBzdGF0aWMgaW50IG1zY2Nf
b2NlbG90X3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJCXsgUzEsICJz
MSIgfSwNCj4gIAkJeyBTMiwgInMyIiB9LA0KPiAgCQl7IFBUUCwgInB0cCIsIDEgfSwNCj4gKwkJ
eyBGRE1BLCAiZmRtYSIsIDEgfSwNCj4gIAl9Ow==
