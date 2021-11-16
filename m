Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C3453B4B
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhKPU7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:59:33 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:51040
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229899AbhKPU7c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:59:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQXi9RjA9QT7Kdzuylnh0/RO3YDuFpNcJQQ3mM4HA52/zlF4lk1LMu+BoOIo04DNDB1lMNwDigqRHrtGZ6NDOKizI69Eq9ZUb2mCIJNeix6+U0R54XzG7jSb17w+EQn3yGx3ddH547fXUplCXxTFw2W2XHQs4xA4VhpsZiJzdBWVhGpefIJ+bju8883K0JW/VieLKihdz/0pBQW5LSDjfh2q5vW6nYd8JY3ohBuyMOZp+ANFoJfVYVSPpXLu+HS5kXjF6bCDHAEAIs9CiXIv67M5gPeyJWK8Tf2Lqs8WEmJB7KAR/wR/f1ewxGcWn+fzoen0eArw/RcAzGfOzyFHkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXSSVjhNnlavz0s4G9WV8M+o9gVg4lQbWXboB9BXA7E=;
 b=SzdRHeSLY9h7MMw2TW+hIHbU/wcq/N+sZKDW0667XCKzjRusFmlzEYmZgErPQcvtwK2qe1Ta36+EwkJA47ITiq5Zsk6x1mqO9qwqbqsJIS2R/rNO373SSMEoOKmtqQHIIiKiH2eP9c0Uw/KYq4n22b/O4gTOcBbPTB5Gh288jhkMCve3i+lrgu7wT/vlbQjqvJW74ATAr+uYpTyyVfF7/U1vDfmpmvqeRzhW/ReGriIiR8Bi1ebyaJKqrEhWRCUQfodFB3CFEHxEfPQNI1557VClP5uGrNIG8xZpwguvIExN9TCNQvuMfAOnDiN2kPIuDGKosMxFH9CP/f2yOOXeDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXSSVjhNnlavz0s4G9WV8M+o9gVg4lQbWXboB9BXA7E=;
 b=Fzz+0umZz8Lk/kW4evEDzHcSSrPO2+XQ/VWE/MutsfqWfR66EJNH8NZKue0Q0gWnsF98E9X8OTzgwX34YARz0kK7vh2V19ji8Rhyxb9QcxAST80g9Xy3FbNJ/R9v4nuALyWDvsk9by866a6n0hARv9sONA+Su34gVPDRVUe+pTelIkoFzjEpU6aaxsKFNXZor6X7O1vvYddOVmxFhOmHyi1aVGZSk+ekGFw9crSzO7NuqjKgOZYkRFeHpbkCGRIjsA2NCnlAZ562RjX4mawzhQ9/BlJG2vJw/FAXhxQdgczna1qB8EdEuYdesfE52gt9WsFkffXl0c9WEQfBoyNkVg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2661.namprd12.prod.outlook.com (2603:10b6:a03:67::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 20:56:33 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 20:56:33 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "davidcomponentone@gmail.com" <davidcomponentone@gmail.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "zealci@zte.com.cn" <zealci@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mi <cmi@nvidia.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        "yang.guang5@zte.com.cn" <yang.guang5@zte.com.cn>
Subject: Re: [PATCH] net/mlx5: use swap() to make code cleaner
Thread-Topic: [PATCH] net/mlx5: use swap() to make code cleaner
Thread-Index: AQHX0RnMjnbed+9b5kWJ8gjf9VlaXKwGtqoA
Date:   Tue, 16 Nov 2021 20:56:33 +0000
Message-ID: <b09fae8a2ac505b302047cbb5a17be05d7da3302.camel@nvidia.com>
References: <20211104011737.1028163-1-yang.guang5@zte.com.cn>
In-Reply-To: <20211104011737.1028163-1-yang.guang5@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ea2ba1d-75d6-4eef-ef40-08d9a943925e
x-ms-traffictypediagnostic: BYAPR12MB2661:
x-microsoft-antispam-prvs: <BYAPR12MB266149BC150F0EF6CD2E5D58B3999@BYAPR12MB2661.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B2XWv7kjYRTSRvEyE9lHWSSjgmRrnqHQNUXkyNyse2WrCKRmS9aPEYjL3RNOv4I7Lvw3GGUlpNvjz+U/fOk8DxNADSnpQaMM4jw1FXI3PPg5a5LadhAY8oeSdPylPJa6ydDTZfRikBFUDRSfSUEZELaqHjRYHZ7nqmFB1m5wsm/FZyN/jvWx9vSHJHjNpaATvxS/C7pTIdRYrS79GXwURZRpQzqpnSQ4LvgrjthbD2IZJRXfp4PCl5xLbdGJOBU8WVEckM210KUD35BFL7B71OTBLqYTjyR/QfH919pkLBaSjm/RR5GOFRA4Ss8sD18ZlV3o7r24bNTs2h3SMGHY+5xbJa1cV7g92uU5FIQAP8Z/llzb5jX7cUjhYzHWq1czWwsxm1pBXsUHkIW5W6WsNWErIWD+eTxfOm+O3f96xNa4m/35UwxpTMMge5SF3AVwLccvhPQzrrGs3Hm6L4XAi3NuGbZegu2pm+XWnFsZf5m8ZkXGdnX7eY4/t7lSRDq9dsmx+4gMU/nFWj6k0mu4kd/d62GV8jU8hAN9LTnxaSTtB0svCK+N3UWExQkMGE7tv6utSdTlj2iEBqDeGahas8R07zsEs+SzlBA2IxoHNoXeCMehMlG7y/roI705KuP+1rcg8k+3udtUc64tBjTY4xm0JpXSDb9FPR/nbPyRRNTQOL+i3tni1TjfpU4BSzLUv9Vi3DkkSShws+gPxuO8BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(38070700005)(8936002)(6916009)(6512007)(122000001)(4326008)(316002)(5660300002)(71200400001)(36756003)(38100700002)(26005)(8676002)(66946007)(76116006)(83380400001)(508600001)(66476007)(6506007)(6486002)(2616005)(64756008)(66446008)(2906002)(54906003)(186003)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WThtZlJJNFFRcDJSVDlqbm1WaHRZY1lPL250L09PODlSS1NEc25STnJqcnZh?=
 =?utf-8?B?bHVTbzdsZTJKaU1PQ2R5Y3k2b2VtbkZSWXU3NzdkTkUrVDgzTTF4T0FOZHVY?=
 =?utf-8?B?cmxpUHpQUGlRanR5eHRCQzhEUVpEbTh6QTJURFg5V1lyOFozK1dLdFo4Rnoz?=
 =?utf-8?B?YUI0SEcwMWFZWE93WWZUUjVnT0pVNnFTdDdrd1IydkgzVmdSUHo5bDI5YWp2?=
 =?utf-8?B?RDRYQzc3eHZ3L0N3SERIOGJteWRtU3d4V2wvcHh2a2hKbjU3LzNvT3V4Mldk?=
 =?utf-8?B?WHc4UkFLMkZ2dlQrNUVGZlpXNEFZbmFEVWxsWDVCdS9mZUgyU0FpT3VVOG1y?=
 =?utf-8?B?NWVPcFVNQzhqYnE1SUFwZ3F0SExFaHBIdXBBbzJzZ2hpQm5BaUdzOFVpMXFz?=
 =?utf-8?B?aDl3M2U1NGtzN1FKdzMxK0dhejVCY255SkdGQVZLblViU29BaElCMFdjQWhQ?=
 =?utf-8?B?TkQwREV0WVRsZ05DK1FocVpHL3hWOXZKUk1DN1pDSDMwbkdwd0tzRnRCTHJ4?=
 =?utf-8?B?YVRxNWVJYmFuRkpyQTBYN3VQaHMzVW5SZUJ6ckhRdGxFeXVNT0JKUCs4N2ZP?=
 =?utf-8?B?WCtoZmZVeWd3VTV6MFp1U05CZTdhaVlBbDBSamlMb1BsZWoraWliUS9QVDJ1?=
 =?utf-8?B?eTd4M0pNUEtpSkJubzZiakJtK1VtaUNnaDZBcWx0S29nZWF0Q1hVREF2c3V2?=
 =?utf-8?B?azc2SVpVRTIxcXVNaDVodkxmQ2lNNjFmaVFuZzdRaDRMOFZ2V1RuTytobzdC?=
 =?utf-8?B?eHd5WmxvWW5xQkpDWVZQeUYzM1VpM0xTN0RWd0RWdmsrUWx5MC9hZlpOSG81?=
 =?utf-8?B?SG1GelgrcTBRbnIxaGcwTWxNaXNONTd2di85d0p0Y1RNTnN3SGlZQ3lXZW5O?=
 =?utf-8?B?NW5PL3diNzY4QlBiUU9wakZQUU85T2JxM2kwZUc2OFVvZ1VXTkw0c2hhN0Yy?=
 =?utf-8?B?SGVDMmtNcnZ3dWdkd3lIZGQrMmVxUitnZDQ3Nmo0Z2Vpckd3UjlEU0h5dEYz?=
 =?utf-8?B?TThzdllIRExpSytDVmF2TjhRZ25udURlMk9ZVmUxNTBhNW9RMjhOQmhDQTdi?=
 =?utf-8?B?bzdJRFE2YUZkVDlDWS9Cd01mSnRYZUhhME4wREVNclhIZ2dMWHVHVlRvK3Q3?=
 =?utf-8?B?ZGEzWkRJanNsNm5zTVdTZ0tkOXZ2R0VOaW1uZXBGRllBME1NNXd5V1loTmdV?=
 =?utf-8?B?bGxudGUzYTNLaDdMYkUyZUNUSnZOQ0laQlpoTkpjREVsWEtIQWRmRlYrczRj?=
 =?utf-8?B?dTEzbTVMWk5EeDJqeXV5NGo3ZThNaWc0ZWNMQ0tPUmhjL0tJeUx5MWx4dDFs?=
 =?utf-8?B?WmlXMGNZQVpuNnJ2RHl3Tkh0ZUpERmIzRTZ1cEkzSnk3NWYwOG1BbVhnQUFl?=
 =?utf-8?B?dEpQbVRodGk1T281di80dlZZTzc0VVZKOGNrTGhnZTdXYkgzaDFsTHpWbEtw?=
 =?utf-8?B?MkQ3cVpPT2V6My9SekxlR0poQ0laTU1VWXMwclpzTGlDdGhqVmQxVlM5S0M4?=
 =?utf-8?B?Mk1mRHk5bmQyc1V5dHRlSEJ4NENiNDhTMkl1RXdBSDQzeGVpekZ5QzhUNERG?=
 =?utf-8?B?S0ZDanNlVHRqcGJZbFV4VVhUTS9jVVlmT0ZZK2MrelMyMlk0UkVSekRGa29z?=
 =?utf-8?B?TXUvUlRrcEg1SjhNUUUrZ1ZqUThQcyt2eFVTcHpSME1HaVhEWDl4UUp4NUVY?=
 =?utf-8?B?VnRaLys1NjhrK3EwRkZHYTJEaG1rRnU0WS9MZ28vaXR3ZW1zNTREczF0U0VI?=
 =?utf-8?B?ZU1NY1RFRk9GRTVCdUVRZDdpaEp2TGZoYVFnaG1pUk4zWkVZUzFvNHFidlhI?=
 =?utf-8?B?SnpJMGlUMzVIekpYaWRvWTQyeGFPUTBSVkU4dHg3WDBrcEtLYWZuQWt5MTRE?=
 =?utf-8?B?NTFGMkhWajVnMnBGS0M1MU8zR2dLaXU0bDY4VkFNVi9makQzbXVtekdvbGxD?=
 =?utf-8?B?ZUMrdUFadUI5VlZUVlZKRDN2d241Qml3SkN2MUcvNHR0Y29iU2pnOCtibUpJ?=
 =?utf-8?B?dzQyVzVJYlUycXB4VFA5Z2c1WEk2MkZuWEZIQWNQbWg0VXg4OGFNcXo3V1R2?=
 =?utf-8?B?NHc1bkUwdjZ6U2hFZkxhSkdrTFhGWmNDZkNkS3VVSHFJOURGbnp3eGx1amFK?=
 =?utf-8?B?S0FoeS9xeGk4UUVhczQzQ2g2RERYdUZVdGd3L2E2aDVCU0J1dUVMS2k4VFFq?=
 =?utf-8?Q?EPxqhkB0WGAXW3YpRkHP7i+3gOMoY1HDwnwRR7leU26j?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D6730699A52C74D8E7D47DD76626950@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea2ba1d-75d6-4eef-ef40-08d9a943925e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:56:33.1133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8lnI1AvHulgfJwhMUrnlijAbiYhkVmDXiIzGlfKZ/QRJ6Eh3snvtSRnJauNjkseHB6f+mM3nwA7ywihbwvBIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2661
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTExLTA0IGF0IDA5OjE3ICswODAwLCBkYXZpZGNvbXBvbmVudG9uZUBnbWFp
bC5jb20gd3JvdGU6DQo+IEZyb206IFlhbmcgR3VhbmcgPHlhbmcuZ3Vhbmc1QHp0ZS5jb20uY24+
DQo+IA0KPiBVc2UgdGhlIG1hY3JvICdzd2FwKCknIGRlZmluZWQgaW4gJ2luY2x1ZGUvbGludXgv
bWlubWF4LmgnIHRvIGF2b2lkDQo+IG9wZW5jb2RpbmcgaXQuDQo+IA0KPiBSZXBvcnRlZC1ieTog
WmVhbCBSb2JvdCA8emVhbGNpQHp0ZS5jb20uY24+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbmcgR3Vh
bmcgPHlhbmcuZ3Vhbmc1QHp0ZS5jb20uY24+DQo+IC0tLQ0KPiDCoGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jIHwgNSArLS0tLQ0KPiDCoDEgZmlsZSBj
aGFuZ2VkLCAxIGluc2VydGlvbigrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYw0KPiBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+IGlu
ZGV4IGMxYzZlNzRjNzljNC4uOGNlNGI2MTEyMTY5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYw0KPiBAQCAtOTA3LDEy
ICs5MDcsOSBAQCBtbHg1X3RjX2N0X3NoYXJlZF9jb3VudGVyX2dldChzdHJ1Y3QNCj4gbWx4NV90
Y19jdF9wcml2ICpjdF9wcml2LA0KPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IG1seDVfY3RfdHVw
bGUgcmV2X3R1cGxlID0gZW50cnktPnR1cGxlOw0KPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0IG1s
eDVfY3RfY291bnRlciAqc2hhcmVkX2NvdW50ZXI7DQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
bWx4NV9jdF9lbnRyeSAqcmV2X2VudHJ5Ow0KPiAtwqDCoMKgwqDCoMKgwqBfX2JlMTYgdG1wX3Bv
cnQ7DQo+IMKgDQo+IMKgwqDCoMKgwqDCoMKgwqAvKiBnZXQgdGhlIHJldmVyc2VkIHR1cGxlICov
DQo+IC3CoMKgwqDCoMKgwqDCoHRtcF9wb3J0ID0gcmV2X3R1cGxlLnBvcnQuc3JjOw0KPiAtwqDC
oMKgwqDCoMKgwqByZXZfdHVwbGUucG9ydC5zcmMgPSByZXZfdHVwbGUucG9ydC5kc3Q7DQo+IC3C
oMKgwqDCoMKgwqDCoHJldl90dXBsZS5wb3J0LmRzdCA9IHRtcF9wb3J0Ow0KPiArwqDCoMKgwqDC
oMKgwqBzd2FwKHJldl90dXBsZS5wb3J0LnNyYywgcmV2X3R1cGxlLnBvcnQuZHN0KTsNCj4gwqAN
Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChyZXZfdHVwbGUuYWRkcl90eXBlID09IEZMT1dfRElTU0VD
VE9SX0tFWV9JUFY0X0FERFJTKSB7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
X19iZTMyIHRtcF9hZGRyID0gcmV2X3R1cGxlLmlwLnNyY192NDsNCg0KQW4gaWRlbnRpY2FsIHBh
dGNoIHdhcyBhbHJlYWR5IHN1Ym1pdHRlZCB0aGUgZGF5IGJlZm9yZS4NClRoYW5rcyBmb3IgdGhl
IGVmZm9ydCAhDQoNCg==
