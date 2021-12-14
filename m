Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C3347393F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 01:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhLNAEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 19:04:12 -0500
Received: from mail-dm6nam10on2069.outbound.protection.outlook.com ([40.107.93.69]:21473
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242899AbhLNAEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 19:04:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WixrD2JjQasNQRwJAt3J/dmBMhYruv0DebiAi1jF/hfIsnCgG1mf7jGgV+ObRjnLboxRuYic2lgHYh/MNV2QBz4mbMbuX05qL+DcmWIucN2RK70t1M0aoP8dlm7wVljfWigVHgiaRf8A4N5iULrrxL/43iOtx4NnhyJD3x/Qq2anA3alss8D9v5pHqf/pKvCVauUHl2SkC8rAw6agw644hKWNSqGGHKXhCpDIHcKtlRD2JgLevMZYaeBCm6Nvrs8KouUtWPEm5LrXQVSLqcdkumuu/K5GeogXtqju1ozNA4BEsxRiCNWxSQZUhjsfxsIBirHkEYmIwnd00ppf2zlMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM5wvihzyymOD+8t3cJQwdrvZ41paT4XGed00ANSWlA=;
 b=cpkop5p0Nca+fOfGXWex9Pj1Gbm5iaUR8+4XWoRIAgVcEKjPQ6aGhFEMF7+01Aq2kfmmmrpOCG/wkr8O92UUPqkJLZGYtyxu6IX2r4RE1Ijt7hKvrVlL7dEDiFQ6jtUW/GDyG60OcpyayTOw+XvLyNmBlFkd+2rMS+WydleEg47fhiOzqJLu1cd6iGR1rzBOEJYMRp4xUGK9DVtzOOUQEdqo84wQmoRNtsvx7PTHlJlv1xo9BmT9nrmTeqLyH3sV31QaxvVqIAV9K4VrsqLtyBB54503BkU51yFelCsKlGiofrugBNqcP9WPuD3RiIsI5/Bx4UDB8uePZj+DgCuQZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM5wvihzyymOD+8t3cJQwdrvZ41paT4XGed00ANSWlA=;
 b=mwP15BTi8xsrNiw2rtGZuB8jhi8n/DPkvHyVVlpvAn6ZnePMTpFPXFzbPv9pl6qLtaDPzMgqnldxKKBqU884/m2Y0TXD8szZU0CjoRX0j7iqrG6voEtycCKeSOL55DYhqGVyCY8DnElF3/I0BadZcLKXeof+yqhF3Jdi69vzIGI5EfidJUtLg4qjSOkvBYBg3t/Zac54/WUrZWjD0OB7KN+sdy0t3dO4rW3oqFTf26jewO2mocVqkYmF1z5aWfMpSrr1NHZNRjPznkjm6H49rmtVuZIZQnIMKb70uEzyaQZCditH3YR2ZaG+R0L4FX3EO6I4gKCu/jOfmEuLvVMrHg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2903.namprd12.prod.outlook.com (2603:10b6:a03:139::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 14 Dec
 2021 00:04:09 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.017; Tue, 14 Dec 2021
 00:04:09 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Leon Romanovsky <leonro@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/4] Add support to multiple RDMA priorities for
 FDB rules
Thread-Topic: [PATCH mlx5-next 0/4] Add support to multiple RDMA priorities
 for FDB rules
Thread-Index: AQHX5urMc9afNtnb2ESLfzg/WiIg7KwnaxqAgAnDTIA=
Date:   Tue, 14 Dec 2021 00:04:09 +0000
Message-ID: <6559a3845b34fcfd75f1b7ecd08ad5e0508a9fe5.camel@nvidia.com>
References: <20211201193621.9129-1-saeed@kernel.org>
         <20211207185849.GA119105@nvidia.com>
In-Reply-To: <20211207185849.GA119105@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d977ed85-b03d-4c0a-02c4-08d9be9540f6
x-ms-traffictypediagnostic: BYAPR12MB2903:EE_
x-microsoft-antispam-prvs: <BYAPR12MB2903A5FF326CFD32B907AE3AB3759@BYAPR12MB2903.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N94dJ8j9ftmDhDLq46YRY2E28wvsP7gZeN0cHv9ldanLoEQlssa+7YCD1IfSvqDGCWWOToo4SzFIfXXs5PoPHwcNVsQHnh/OdgXv8N7bQIbra1i1Frhcj3lTgGVao5Rf4Z7YOdp1FW66bIIMPFdOej2XOl8aC7T6aAlJXuB8dGqariAtfaS60Dztcv3wSEeNOr9vXT0QXtohkEsNxTiawH+IhWeVhtFwyQBcBECg1ywoqJezO9XYtnbH4zoYM+EQKH65rCg4ZPsJXPdNJygfgEn1NF4wCMaAzCRTT4nh8lbtchMtXjNCChboT8359VSe75BNYWwA2vLhBltQYOMDs4KUjacExIbCVg9xGRzbHnptEYr6SBTGszBDDvacIRtHLzAToeMj1dOl9+L1hDRxdCPyLcRS0gACEhk0eooyhajPNd6XceXDwv6YrZuDnD9DOE3WpDTJZbGdqEdgbPNFRLkA90CjRskAfWKsAUmjHJ2Rj5rOl9RIGgntY+A9ZwYzo+vJ/SJqmipI4S5bg9j/WmN/dt8EROsAwq1+clZ/ei9tUFNdb0lCWpIQe+GHikuLGQbZcEZB4aW5wTVkOJXzPs9sfIObirtQ9744KfTcW7/bdlNT8web9Z4wiOfsVDgI8b1pwFFBG5m+LBaFiux6hAUEO4umyDkaKl64HM/ZQ1jbtgJm06MPrACK7G+3M27FteM9pr3uycKwnmNdM6kkqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(6862004)(76116006)(5660300002)(66946007)(508600001)(66556008)(64756008)(66446008)(316002)(8936002)(37006003)(54906003)(86362001)(8676002)(38070700005)(36756003)(83380400001)(2906002)(71200400001)(2616005)(26005)(6506007)(6486002)(122000001)(38100700002)(6636002)(186003)(4326008)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3RQekN3NlpndUFMNXIycUFRTWtpUWcvaDR1c1ZYb2dhNFFkUGhha1h6TlJQ?=
 =?utf-8?B?cUFaeUtlRWxWbENiWGkxTmtrTWlEMlozSVFCUXh2YXFFUUlRM3RXVk5oQXpY?=
 =?utf-8?B?T1gwWEM5bVFyY05ENzlRK1FWOVFReWhDQ1FNcms2dlh1Ri9WcWxKU2NoeEND?=
 =?utf-8?B?bXdLTXk4RWltTTB5b2VTQXY4VFcwdS9peDVuekxibG4yeWRqMGgxVU9wRVRP?=
 =?utf-8?B?N3hHaGRsM3BEUUpqc0VadlpuUnN2dWN2YWJiTXpFdUV3Z2daUjBQV0t6V2px?=
 =?utf-8?B?Ni93bU91WG0xUHYyUkpSTVcwVG4vY1hhS1d1bk1wYXlTaGFIbGdWc3UvaHRU?=
 =?utf-8?B?OVJVUGlkY0krUUQyOTRWRTBjVUxqanJBOUxkTVlaOFlyVW81NGp0MFNuWlI3?=
 =?utf-8?B?UVZVVXowNy9nNGxuU1FjL3pWNUoraWRNMkR6eVZ3K1JzWGhlSFpJYmNoZ3oy?=
 =?utf-8?B?bmlmWnZqTXJrb2R1THppRm9IY2hodWNTWnNCMTZXSFdUaTRpaUFSRnB3Q0F0?=
 =?utf-8?B?Q2tVZlRuZkQ3UUdsTmk0T2VCYnFlUDRnY3VzOE5LbjdiOVU2bisyeVVwZUVa?=
 =?utf-8?B?MERmVDVrZzFtWFFKLzJxZUNRNzNNeXIycjN6TFFFMEZKRnIvK2lORE00YmVl?=
 =?utf-8?B?QXUxWWl3TlF3ZzBRTHR0Wm82QWMxZDNVWjN5aWVJdUVJZS9iWXZZMFFmelJP?=
 =?utf-8?B?dStzNTdxTTd3cDdoenZoM0dOYkwyS0xjS090ME1ZVzZNOUswNlBIbFlwbDY3?=
 =?utf-8?B?eEsxbHV4WkYxcStsc2UrU0QrSERVUEl1NkNwMnpPT1hkOUtmSnREbVJqYS9i?=
 =?utf-8?B?L2hWSElsaU1MTWNoRGRGL2hNVStONytVK2NvVWphc1dPVUsrQnQzTGpxeXVy?=
 =?utf-8?B?Vm5hajlGYzkvNjdHOWRlMlNVOHRqUDFFMFJJcGhySExGU3BVeS9kNkZmNy9L?=
 =?utf-8?B?dHZHVzBVK3IrbUNVYzEwcVZoaWQzckQyREFZam1DUTdRSUNJKy9uVW4yUU5D?=
 =?utf-8?B?N2UzQlorMS94Z2RGQ0x5eU9IczFJdmEyaHhxU3dWN3UzbEZ6aXBmalBBMkhw?=
 =?utf-8?B?L0ltQm56ZExGTjlLNkMxRklUTTJLTmFFaTRDa09iWS9uMk5mRWpqTFM2Zklt?=
 =?utf-8?B?NHE4TWkyKzFhTVdsY0lSOTA5VlNZaWtMY2FsN25vcTE3Ukwwd2RGb2xoUndP?=
 =?utf-8?B?dDVidU0vOTA1Tk9udm1jYi9TWWZPRVZEWTZCdFhFejQyaGF1eldJb3djUDRp?=
 =?utf-8?B?Yml4RUE5ZE8zcktZcjlKTmRPN1lGdThMTDY2d0dCL0t4aExsY3JOanJwUnBt?=
 =?utf-8?B?NjBhTjJPVjJpQ3c4UUFTRExUakFEelNyMGwzVDU1OVRMNGVLZW9QN2JqU0dD?=
 =?utf-8?B?OUZhZFNqWDQvTmtYb3V1YlRLZjh1M24zOFkxZi9pRGJPWW1Pamg4MklJK1Ay?=
 =?utf-8?B?VG9PSGVMNHRRTll6RXc5K29YeXFWVzk1cFgwQ0RvblNibzFZTHp2SmtxQlNP?=
 =?utf-8?B?RDZnd3BtdWE5YklVR09ta0VnRTZUbksyTWV4Vm43UXg1NTZCVVFIUUhLUk5B?=
 =?utf-8?B?a3NUTFNjaXVEQmhnY2lvU0V3dG1JbzFkM0FjaGFrMkYxcUhDL1lQb3llbFlI?=
 =?utf-8?B?WmxRbENiWkZxK0x4ajQvd0ozTDZ5UDA2K3BjaUJxdTdZZ1FVWHRIQWZ4UGJF?=
 =?utf-8?B?RWNXRnRsY1ZGemcySFFLUFB3UEFsTU5BUVM4VkhJMG9mWTgzU2llNlJVWjBQ?=
 =?utf-8?B?VytVMnhDbGM3ckg2Lzd4WkUrQmVmeFovYXdCdjBiVURDVUppK2RRalJsSzhX?=
 =?utf-8?B?VHFVdWhSZGRQQ3dOZENOQjJYQWJ6Z29INlpaT3FLbW9hLzdPaTQybFEwRG4v?=
 =?utf-8?B?SVp4OUxUOTFubXJyUnpUejFPNmJrcFNpOVRXUzhXMWlUVFRkdXlzWDZnSURa?=
 =?utf-8?B?OUl4TVdkUkpkVlRBQnBtaStIbURYS0ZldlRmWlFndTA1ZWd3VWNaa1UyZ3lU?=
 =?utf-8?B?Q2tCcy9PUGJpaS9QMnc0ZGhWRVp3M0hyaC9TMSs4Z3h6U2pydXl4SkFXbXVi?=
 =?utf-8?B?M2p2S3pnN2FyV1VsNkZqd1RlS1N0bXRwcDV6NVIvUFZONFRuVGJkWjc4dXhN?=
 =?utf-8?B?Y3hHZy9JaDBHVks2V25venZvMENaRGxCdVlxVndBZG81ZWk1OXBEcmZnbTky?=
 =?utf-8?Q?VJMygEkapm6aOniAB0IjyA8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27536FD3A1748744B46110C77CA61B2C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d977ed85-b03d-4c0a-02c4-08d9be9540f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 00:04:09.7271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZpDiVEYy4b2OuLlV+ioQ6Gi4Yl9WzFjN213ZgHBh9aNznkMIy/npPz3/iGLlmUabHmxGqBAAPE7Hic019nd+nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEyLTA3IGF0IDE0OjU4IC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFdlZCwgRGVjIDAxLCAyMDIxIGF0IDExOjM2OjE3QU0gLTA4MDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4N
Cj4gPiANCj4gPiBDdXJyZW50bHksIHRoZSBkcml2ZXIgaWdub3JlcyB0aGUgdXNlcidzIHByaW9y
aXR5IGZvciBmbG93IHN0ZWVyaW5nDQo+ID4gcnVsZXMgaW4gRkRCIG5hbWVzcGFjZS4gQ2hhbmdl
IGl0IGFuZCBjcmVhdGUgdGhlIHJ1bGUgaW4gdGhlIHJpZ2h0DQo+ID4gcHJpb3JpdHkuDQo+ID4g
DQo+ID4gSXQgd2lsbCBhbGxvdyB0byBjcmVhdGUgRkRCIHN0ZWVyaW5nIHJ1bGVzIGluIHVwIHRv
IDE2IGRpZmZlcmVudA0KPiA+IHByaW9yaXRpZXMuDQo+ID4gDQo+ID4gTWFvciBHb3R0bGllYiAo
NCk6DQo+ID4gwqAgbmV0L21seDU6IFNlcGFyYXRlIEZEQiBuYW1lc3BhY2UNCj4gPiDCoCBuZXQv
bWx4NTogUmVmYWN0b3IgbWx4NV9nZXRfZmxvd19uYW1lc3BhY2UNCj4gPiDCoCBuZXQvbWx4NTog
Q3JlYXRlIG1vcmUgcHJpb3JpdGllcyBmb3IgRkRCIGJ5cGFzcyBuYW1lc3BhY2UNCj4gPiDCoCBS
RE1BL21seDU6IEFkZCBzdXBwb3J0IHRvIG11bHRpcGxlIHByaW9yaXRpZXMgZm9yIEZEQiBydWxl
cw0KPiA+IA0KPiA+IMKgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUvZnMuY8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgfCAxOCArKy0tLQ0KPiA+IMKgZHJpdmVycy9pbmZpbmliYW5kL2h3
L21seDUvbWx4NV9pYi5owqDCoMKgwqDCoMKgwqDCoMKgIHzCoCAzICstDQo+ID4gwqAuLi4vbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jbWQuY8KgIHzCoCA0ICstDQo+ID4gwqAu
Li4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9mc19jb3JlLmMgfCA3Ng0KPiA+ICsr
KysrKysrKysrKysrKy0tLS0NCj4gPiDCoGluY2x1ZGUvbGludXgvbWx4NS9mcy5owqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDEgKw0KPiA+IMKgNSBmaWxl
cyBjaGFuZ2VkLCA3NSBpbnNlcnRpb25zKCspLCAyNyBkZWxldGlvbnMoLSkNCj4gDQo+IERpZCB5
b3Ugd2FudCB0aGlzIHRvIGdvIHRvIHRoZSByZG1hIHRyZWU/IElmIHNvIGl0IHNlZW1zIGZpbmUs
IHBsZWFzZQ0KPiB1cGRhdGUgdGhlIHNoYXJlZCBicmFuY2gNCj4gDQoNClllcywgYXBwbGllZC4N
Cg==
