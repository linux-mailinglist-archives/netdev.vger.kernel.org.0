Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF924432BF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 17:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbhKBQeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 12:34:21 -0400
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:63860
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234822AbhKBQL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 12:11:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oaYoMuPtiaaP3z6ngN+nA5PjK1E/GkiSmO9f/zIz2NSFVEd7OzHhkfdTl4nN1y4CqSM4HjaIon0O3YXVRqzTvO/U9Anmczj+Gtmf+TdQWzs5cyFotW8JEVCvqXIk/MfaY7m19CIHV+IW8t1zoCZZFq8V9/p7suRUbMJr/SY/quox9W+hpYj8gWZ7V2nrEUDijeQV1kFUiUnwx0s24jreWvm3hA9oQeWFtB2MjqEczMCJmPkZkqOG/D/xjXQzn2iTwuTmZbM/ra0PqbLi6LtoIJBmmtRTbVR9BQ/oYJCzdpDvx7sO/KiwB4mx2Bb/7HGaQK3QB+79mmZFKFsn6fPK7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yykBHC4q0MPUQ5d4AJVAKx99BrdZfKtzQEz3WFu0NY8=;
 b=kA2WrfsesCzvYM865lWk3lu+uzh/uk3rG9PfmPeWcNpUlqgHMOl7cFiYT9zt+1/Hh7HJg03tFKVvSs9NjcoQGTYLWI2AejtUSGwbKAlo1SRULs3bZgmBK/L2zgqEPBf2z87KfeJ7bGeB08FgxlMwvdN3BiXmWSuPrx46fo+U4OxBe6zX4hLS//c5hPiW42hXglKl+ycG7GK5AtADFViiRynE14KaNDz33q9ChAeYZvohr6Xbtu7karDNsx0fuCr13RNyTVOSbPxMqBJXhIm1U5WdFZraMpemogkU3C8Fs/XEj0RdTJhVVVui5jZOy7OAigWNbeGXlpaEfBO6/J6rcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yykBHC4q0MPUQ5d4AJVAKx99BrdZfKtzQEz3WFu0NY8=;
 b=TZM/80Q2VUVZWgoGOUhVjwIAvPk//JPknxo5FZhMSjl+kqLMjA60U785Mcm1v4PkgXtADbNnrP1eG/xbUd/fWf0856XIiNVXOhqAkxdHCxlj36m8dNA5fnjn3DgnOk7Ch+VKYbEtv7TQFHCZvBU5w9fcvtjtwW8Q52HFy3O3VRllSor05a/HxRG+Qm0xIbEoL5bj1VuC8OD69/TjVRX+ZX2vfxTn432qhvnmR346Ey58K6tUM0hRupds5zKB3MFnNjbUQYm3HeVG4Xr3AxrpEq7SAmOl3BDBobANSCIQAMFgVtdIuKYXB9H7PkJqB+1dPz4TXBbJUc7SjY9X3cW2NA==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 2 Nov
 2021 16:08:52 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 16:08:52 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net] ethtool: fix ethtool msg len calculation for pause
 stats
Thread-Topic: [PATCH net] ethtool: fix ethtool msg len calculation for pause
 stats
Thread-Index: AQHXz6EZjp05BCw+C0ei8dTnJmF0uavwaJeA
Date:   Tue, 2 Nov 2021 16:08:52 +0000
Message-ID: <502b2fdb44dfb579eaa00ca912b836eb8075e367.camel@nvidia.com>
References: <20211102042120.3595389-1-kuba@kernel.org>
In-Reply-To: <20211102042120.3595389-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e0409c0-1490-464a-755e-08d99e1b102b
x-ms-traffictypediagnostic: BY5PR12MB4212:
x-microsoft-antispam-prvs: <BY5PR12MB4212AE2D8A46A1B8D59FCCD9B38B9@BY5PR12MB4212.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SYLfswlz+UoJR0y83wBb1lLWkTA00SbJddrqOk5elcbz/8TvYrdDeGkA7Ft7IQbbx+Ls7YdVe0SA6oxvVaslHaChrAHd95SIHIvb+dWYWSPiHSFdq0+MSdovVlCHWleyKfw2JdRl88MNc1vu7lxQSaKaF6mHDhD9a2BjFy5+FB30X3tajnJIL+ohv6GhKhJZKTzjWmGK/vEmqhj63o17lcZ3UhcSPmnswRBUn09chen+yQwZK4cPIeuxHdivsUkCcHKQoWHAt8lksVdDx0+SEuPqs7wPCfhsTIN9+4B8HdVMe/v+O+JgARKpqEtCrVVu4gXzed0SuolORgQKnFCZ2CF4fDK4+bQyt0sIL9GiydraGrwGe61u6yINju1s045ti5QvvHMcLB6tsrLMvJkglzr01T/DKKgUzhOpWfRSmygFfPrf/1Bu43+jWDw3V82FbFhwOF/+b6UUkLx75atBshN71y9TgMj33AZvffuJrEacoqfcX3piOWgrWCl04jKmVbs9+sjAscMjy0HjYu9z0DAnw7g5pLrafGj6yr8n4YwHXaRDFr8+Wb9lLUGNPoJnt2RrxRvLJo9nGMbzdM8s85KClep0gMbNXHzBZ8TpFGRNpXBFtPz7x4x29peoP0S3MGRQQ9rnA5nhd0gG65K1MdTl+YBL+HCuPOV0FwGM6Nu4f+8dL2KiKzHPb70m8yNkZnV+aPX+AHLtTWMlT3ksnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(38100700002)(110136005)(66556008)(66446008)(64756008)(66476007)(54906003)(6512007)(66946007)(38070700005)(86362001)(8936002)(8676002)(316002)(4326008)(186003)(508600001)(83380400001)(2616005)(5660300002)(6506007)(71200400001)(76116006)(6486002)(36756003)(26005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnNqK2tiNXpwRHdRcGtmQTdMVy93RHovZUx6NS8wS3Y0Q2pGV2hGalZZWjhs?=
 =?utf-8?B?QnlRS3Y2Qmlkc0ZzNmVoSWtzemIvK3hrQjJpZlNFdHlJZmx4TjhBZlZ0TWJQ?=
 =?utf-8?B?cGh0QTlqeDA1M0VYZEJVT0EwcXRXVVlIbG9aT3BwbERrckxDVWVQUUd4UFZX?=
 =?utf-8?B?YmRSajBnOU1RVUI3STN0RS91NTBnVHdtV3V2WThzYy9jempnR0lMM2hQR3Vj?=
 =?utf-8?B?OUc2cklaOGtBd0ovaXMzWGJ5UGxYbnNGV1ptU0doa3FKdXREM0Z1OHdrckJT?=
 =?utf-8?B?TWRXUUdJSitJMDhiNzdlK1hzRklVSlhvRWRld1ZjeWMrUVRhYWY4T0I3eURu?=
 =?utf-8?B?MkZLZEhPL25uTjJrVW5Ub1dUWncxRUVzYTBFOUF4dXNZclJjczVjdDQ0eFhU?=
 =?utf-8?B?UnJNYXJFaXdnalR5dGIwemt6OVFLQ1F6WnE3dmN0S2FySFkrcUdnc2laSUtP?=
 =?utf-8?B?WnUxcXdGVDhWMTIvVXBGSEpqRHowcVo5NmRxNEQ4N0J5NjFhb0w2eGRzSE5P?=
 =?utf-8?B?SHFpYVVzdFRWWC9lOHY2NFphOUtxb01YK1dibSszdzY0T2k4MnNzOTU5cWRW?=
 =?utf-8?B?V1BoYTh0VCtkU2NFd3IxUHBwY2dQZkhRQmxDclZLenJBM2Z6bk5xNXBzM2Zo?=
 =?utf-8?B?U3FkN1U4VlVPR21YanBzbUdqdXgxMk1LNWxCY2xOcWRuanZDN0k5YThiMmhJ?=
 =?utf-8?B?empWVXBvL2RkTW9CVkQxeXB0UEpxNW12bnpPQWwreUlFSzVDUUlUdmtvSGlZ?=
 =?utf-8?B?MjBWc05pdjNjMWUwdXgrYWlxNjl5a0NuZ1plVzRjOHJIOVZ2Tm5Udk5jYkJO?=
 =?utf-8?B?c2NPcVBTbDYzQlVvSEdhVEZWNFlKemF3QVpUMmU5MzBtTldqRStaSGN5RzEz?=
 =?utf-8?B?QjRwZ1IxeDlKb0p2WWh5Ukw1UElTalBOZm4xWGd2bFlyM2FnbURoejJnSGNr?=
 =?utf-8?B?eXFGdzZSZFBrcUpRR2pxMC90V0JqQUR3N0syQXF5V3kyT3c0bXg0UWl3UVM4?=
 =?utf-8?B?ZDhlU2w3bEhiL0d5ZUJDckdYVjZnNnBzY0JVRHFnRHY2SE8vMVR3RFpQQ0pR?=
 =?utf-8?B?OEN1TEIvR3ltWE9rQXNsek1jREY5Q29hWUxLeUpiYnZmV1EzUkhRenJ1NVdr?=
 =?utf-8?B?cnE3dlE2VS9iR0ozRGlQSkhsalNDNG1KcEFnVlZscmpsOXcyY05sNGlIRTZu?=
 =?utf-8?B?VnFVQkhtV2NvZXpqT0NvQUVjTVF5YnNCQ1FLZEhvRmhEYmtoRTIvdzNtWjFn?=
 =?utf-8?B?QVFvVmY0bnZDY2ZFUjFFYVgzTWFhTHFTeVNsTG1adXRjVXRVMENKT3BHY0dE?=
 =?utf-8?B?Uk1mUWs3cDVWb1owZzFhUEF0endmd2hlYmEyNmVEbWh3RDFUTGhSekE5T2xU?=
 =?utf-8?B?NDJ1QUhQMnMwMTR1eXFNVWtIZjMvdjlzR0JrTFQzWDlBaE9zOHpYMitCQ3lZ?=
 =?utf-8?B?VEpSRjl6UEQxQnhINFBVSUI2UnNsZktZQnNvay9lTDdRR3hGRmRjdGcwZ1RZ?=
 =?utf-8?B?SXE4N01zcEkyQzBZOHhHODRGNGU5cjBoTXI2RDdxWUZJOU1aeHBOMmJ4b2lx?=
 =?utf-8?B?cTh5Y0dFSjVXRXgyNnF3L2Y5OUtDcUZnaFNxL245VzJKNk94Zitpc3ZRS3dC?=
 =?utf-8?B?SlMyekhyZG9UaXNKazZQNXpEakhRczh6dDRwbndsVTRxTXQySEp5TlEvUUd4?=
 =?utf-8?B?eHlINVN0RGUrc3hEK3g3aHZCeVQ1UHFpOWRkanc4c2J1cDNSNE5TMURoYjNv?=
 =?utf-8?B?Rmxqd1EvQnAwbllsM2JUdVJtajhZRFVyZW9jdlpwUlkrNkloN0thV3g2MnFj?=
 =?utf-8?B?cDNQejRFcUd3SEg4TGp1Slc5dmVwbkNOZVcwbEZoVlZBR3g3RGZxSWxKdzJO?=
 =?utf-8?B?VGV4OVlCQUR2bFR2QlcwaFdqRERNNGJzZEUwZGhPMFV0ZUx2VEx2THA0cDVo?=
 =?utf-8?B?V3dKMWZ3VG1sWFRmQWxSSUthSHFUdTg3d1pHeEJDaG5jczdCbVJ4VHltVjNs?=
 =?utf-8?B?RkNWcVJaVms1ZFBDME9UMUFIbzQwZTc3czJacGszeGtxT09xMkcxTnNzR3hu?=
 =?utf-8?B?WkxqOFpHb0U3ZDMxUkhwL095YkI0ZnB6OEY2MWtuak1ZTXR2cEJrd0N0NG5S?=
 =?utf-8?B?K2d6NWdOOGpCWDRaZGZ0NW01SldvVC91dnRWQ3h0L0cxNW1QQi9ENjdBUEY1?=
 =?utf-8?Q?oCXuJWfqtBfHZqvnXMYRwmt6FwXQ+ZEED5qZx3bJhrcy?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF651EA22F014743823045458C63D844@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0409c0-1490-464a-755e-08d99e1b102b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 16:08:52.1179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3sNiVS6dGNYGEn4Jhbh5C+s5ly52RAc/QtE8CZkCheeS0uIo7AZ/gumJKZauWYW2JudrVH29+ApyuykllMphHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTExLTAxIGF0IDIxOjIxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gRVRIVE9PTF9BX1BBVVNFX1NUQVRfTUFYIGlzIHRoZSBNQVggYXR0cmlidXRlIGlkLA0KPiBz
byB3ZSBuZWVkIHRvIHN1YnRyYWN0IG5vbi1zdGF0cyBhbmQgYWRkIG9uZSB0bw0KPiBnZXQgYSBj
b3VudCAoSU9XIC0yKzEgPT0gLTEpLg0KPiANCj4gT3RoZXJ3aXNlIHdlJ2xsIHNlZToNCj4gDQo+
IMKgIGV0aG5sIGNtZCAyMTogY2FsY3VsYXRlZCByZXBseSBsZW5ndGggNDAsIGJ1dCBjb25zdW1l
ZCA1Mg0KPiANCj4gRml4ZXM6IDlhMjdhMzMwMjdmMiAoImV0aHRvb2w6IGFkZCBzdGFuZGFyZCBw
YXVzZSBzdGF0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5l
bC5vcmc+DQoNClJldmlld2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+
DQoNCj4gLS0tDQo+IMKgbmV0L2V0aHRvb2wvcGF1c2UuYyB8IDIgKy0NCj4gwqAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9u
ZXQvZXRodG9vbC9wYXVzZS5jIGIvbmV0L2V0aHRvb2wvcGF1c2UuYw0KPiBpbmRleCA5MDA5ZjQx
MjE1MWUuLmM5MTcxMjM0MTMwYiAxMDA2NDQNCj4gLS0tIGEvbmV0L2V0aHRvb2wvcGF1c2UuYw0K
PiArKysgYi9uZXQvZXRodG9vbC9wYXVzZS5jDQo+IEBAIC01Nyw3ICs1Nyw3IEBAIHN0YXRpYyBp
bnQgcGF1c2VfcmVwbHlfc2l6ZShjb25zdCBzdHJ1Y3QNCj4gZXRobmxfcmVxX2luZm8gKnJlcV9i
YXNlLA0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJlcV9iYXNlLT5mbGFncyAmIEVUSFRPT0xfRkxB
R19TVEFUUykNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuICs9IG5sYV90b3Rh
bF9zaXplKDApICvCoMKgwqDCoMKgwqDCoMKgLyogX1BBVVNFX1NUQVRTICovDQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5sYV90b3RhbF9zaXplXzY0
Yml0KHNpemVvZih1NjQpKSAqDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoChFVEhUT09MX0FfUEFVU0VfU1RBVF9NQVggLSAy
KTsNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgKEVUSFRPT0xfQV9QQVVTRV9TVEFUX01BWCAtIDEpOw0KDQpNYXliZSBmb3Ig
bmV0LW5leHQgd2UgY2FuIGltcHJvdmUgcmVhZGFiaWxpdHkgaGVyZS4NCkp1c3QgYnkgc3Rhcmlu
ZyBhdCB0aGVzZSBsaW5lcywgeW91J2QgdGhpbmsgdGhhdCB0aGlzIHNob3VsZCd2ZSBiZWVuDQoo
RVRIVE9PTF9BX1BBVVNFX1NUQVRfTUFYICsgMSksIG9yIGV2ZW4gYmV0dGVyLCBqdXN0DQooRVRI
VE9PTF9BX1BBVVNFX1NUQVRfQ05UKSAvKiBDb3VudCBvZiBvbmx5IHN0YXRzICovDQoNCm1heWJl
IHdlIG5lZWQgdG8gc2VwYXJhdGUgc3RhdHMgZnJvbSBub24tc3RhdHMsIG9yIGRlZmluZQ0KRVRI
VE9PTF9BX1BBVVNFX1NUQVRfQ05UIHdoZXJlIGl0IG5lZWRzIHRvIGJlIGRlZmluZWQuDQoNCg==
