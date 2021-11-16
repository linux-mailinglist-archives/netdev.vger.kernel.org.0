Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F4145453B46
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhKPU60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:58:26 -0500
Received: from mail-co1nam11on2088.outbound.protection.outlook.com ([40.107.220.88]:2272
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229899AbhKPU6Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:58:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERvHQGEEaLiQsVO7f1ex2/G6+r1A4n08Vs6Dsjbezufl27j/eg3qhJl9ZWyyUIg5LekH+6ZQfW4PyoBfary4a43t7cTfCJPLxGNyzxsnHtjXUYdJhn6BMHOxLn7HRKX2wdHzvpbb/M5qJpK7QOH8a/hQdoTRvHL6xFDjr0gwlvQDgBgA4U1Lgy9PjhYbKgfjVXBK1igeiYqr56Lwvh95XPdtWFd5qUJ96bzDOy4DHwzyxMZ+U0AuMhJkTB7n8+ozc6v2MLMbuebV4PCHoeEpChInkREM5KOWmFmMpT3XS9NzjRCrR2RByDEQ7wU1FEDX/UnNaKVXUc8hzw8XbujArQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bpQ//AylUfxcZJB7YyR7HvuHPQvTkTp2KJZBOZRjKJo=;
 b=Z4yHDX4umHvMTi7hAR8bQI0D8u9VMLHUp2TgGljH3ooyL9IKrSGtYaNkUHFqVLpfWi/S7TM2RG4w4Tykj2BEzEvY+aWeUwY5fl1shb7Q2jicqWIJLk7rXSUj0aSkM8Fq9rM3Hx9G9eskkIuwEJuaCc2B0mN/p2NfZ4HUGVYT9Q99sHcCrLUQ5Rp1dgQmcRQTJUCfF5xfHUpYAAz5+230REa+P4eOPWCT4P4S7sdnZVsBdSxx13FBIk2sqifIzsCVg7DgHbkPsLu18bSWhRnhmCvSab60G9QTPfK1O3cKt1FfLv3ww/BPqnx3JhCLUOEEc+U+Dm1gxlj+d2xdv0+N5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bpQ//AylUfxcZJB7YyR7HvuHPQvTkTp2KJZBOZRjKJo=;
 b=jgGp1S0lksyDwrb5s82yQBAo+tiLSci7RIFD6vIxir6REONN714CBGlJhCmNW/t/yE8JGE9ZX8On5SkA1xzPmWMkNC18NVaZY4mVHWHn4i7bueqS86aqfiRCJzdkkI2ndjjl6xqn6tP9csvsU7bdKIWrMN28jZEeAkXExy8nVJBpzXiYAugMfsixsuop/eV4byl3pg7SDoL+cY564u+ag3C4WOE6iALuy3oIx7LrvrFNL6TYrrcjNBAMLM3Vjfm+7qbowVzzc1gh51JgFPuf8kPNpruckMj9xtCXDJfvHdTrI/J9kUrU0l4BWwQvNQkiIOiGdMjLvfmEmais2pjd0w==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB2712.namprd12.prod.outlook.com (2603:10b6:a03:65::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 20:55:27 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 20:55:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "hanyihao@vivo.com" <hanyihao@vivo.com>, Chris Mi <cmi@nvidia.com>
CC:     "kernel@vivo.com" <kernel@vivo.com>
Subject: Re: [PATCH] net/mlx5:using swap() instead of tmp variable
Thread-Topic: [PATCH] net/mlx5:using swap() instead of tmp variable
Thread-Index: AQHX0HsOgmPt0SHW2Em726F6lktfIqvxXxuAgBVYfgA=
Date:   Tue, 16 Nov 2021 20:55:26 +0000
Message-ID: <5f4ab1e4f9bbb08ad4a7a1f0f176b6571a4539ea.camel@nvidia.com>
References: <20211103062111.3286-1-hanyihao@vivo.com>
         <bb52fc1b-4e95-bc5e-6aa9-82b9b35967cf@nvidia.com>
In-Reply-To: <bb52fc1b-4e95-bc5e-6aa9-82b9b35967cf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cc7a1044-3e4f-4498-74f1-08d9a9436aec
x-ms-traffictypediagnostic: BYAPR12MB2712:
x-microsoft-antispam-prvs: <BYAPR12MB2712F73E544AC30896C5B8B1B3999@BYAPR12MB2712.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:497;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iw3FNKAvdWRCwoRMJTI0ekecSfnpTXRrDu48DKsAkaai2VyNryqE5GQRFDyXbzq8LdwI1cOYifJaYBSz2wHf8H+Yii1csQZJMm4hnguAfv3mQJ8dgD02woyoIR3t7FEMoB3+hPWMsoTuNPdHpPc6z3VbD+WsU3TUb9jDtV5EXJkwMMx8WZ6yFnHMMjjNbx/5sb9UkhSEyQxiBFum7GhiewB4VOOMz8ZBph9py6WL1SnSCY9nuijpv4Rhu14RaGmgpF2sLKCfvqD9GJgSJoU60fBhT349cvazqOkwdwSL+qR3l9yGdamFqTyfqBdPLYPWQqwvn4T+JNyRie1jFogqSQdL6gQ2BwOjCv2loV8UWQ6Xz1TOl+PEvaPSm1XKTIe2yH+CgtPVaTFoA1G4lFcwpl6iTgPu0nsWeummlY7KPhYcFDOqcDvg/6Y5qyN9X6jWLyLOxbrIZhQ18wP4bS12BxYBZ9y96f3hxKL6tmPhjWFTOEmJ6s0GaXcB3CgZLdGaAVZqy+gWgAc12Kjc7hSPUcTrPnwU+XfK2RG9Nys2axmtl3onbDOUCvP+FT1x0IJuYaNJeVpQjUsDbuWVLGvmMf8PtsmYddLuvj+LJiQQ/vPcQTb4HRHHQQMzMrxlBykHfevDMu+XuZVViYIW3p0fnr8F0hdrwbVbyUTPEEnJhYaAZpGqpLxBm/aY9W3MbGAVVIJ+6Nw0NVwoq8ILlt3YFlny+YvczIVk/tAgZsPdC84=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(4326008)(122000001)(186003)(5660300002)(66556008)(86362001)(38100700002)(6636002)(36756003)(53546011)(71200400001)(66446008)(6512007)(6506007)(26005)(8936002)(64756008)(110136005)(6486002)(76116006)(83380400001)(2906002)(508600001)(316002)(66946007)(38070700005)(2616005)(921005)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0FLb015SXlaUnU2RmxJcFlLamNseUhyK2pzc2hKNFFoZmFKTWgrVDloL00v?=
 =?utf-8?B?cTNweHVoZmhHT2t0d242SlJsKzdEdU5tOC9xSU5McVd5VWJnL3F0SzVtMzl6?=
 =?utf-8?B?NWxsUlhIUHhTYXhEU3F6N1IxZFM0WGlZb1hZeTYyUkoxUHgrb1BTVlZ5VDE4?=
 =?utf-8?B?V2NaV0YrU1R1SHRoY1liRjdyMFQyVTh2bGJRL2FGWGJDSUNxbUV6Q3VvZ1dK?=
 =?utf-8?B?UElSSXpXQWp2VlNlQUdoMHlnWUNlSllEQjJPdTA3KzNEWHZ0QjJnSXB2THVl?=
 =?utf-8?B?cU5oRUVaMG10bzdBSkV0cjE4MEZEWEUrS2ROVkNCaFJKNlJHOFlnWVJWci90?=
 =?utf-8?B?Q1VBbHlDN1h6SmFaQ01VckphcWxaU2doT0N0aGlSQlNKMVBNaGREa0VxYWRV?=
 =?utf-8?B?ZXdZVlA1MzhJdEpSeno2cGZ4eHU5bEovdEVxbDJjK0NBQlllWXltdVhHRHR0?=
 =?utf-8?B?MDNWbDVUcUM0YjRUTXNkYTQ3THd1QWphVWVDT21HZzFsMmxJeDkvQldjelIw?=
 =?utf-8?B?OCtlbU9ia1VRekJpNENYK1k1aEIybmN3NXQvWm1jaTBFdWMzOENJTDNtU1dy?=
 =?utf-8?B?TG9HQVdKM2hpWFFNU2ZGRkN2NHBCVE5xazJWN245SzQ4dGJmMUdPSG9zL0Ji?=
 =?utf-8?B?SUJadVE3dkpIc05BQkc3RVRBc0NXNFZjQlllS0I5amk0NVdTZjNvOUw2Vmcy?=
 =?utf-8?B?UnZ2WGFUU1h5NzlkVXVZWm8vNFNOMTRmaG1LTjhHTU1iNEs1WXRNTkpCTkN4?=
 =?utf-8?B?aTFIT2RXLzM4akVqc0N1U0pLcDZtYURkZ2VTUEg3Qm5NZWxoMVR6VkJaL0FU?=
 =?utf-8?B?VlVWV2JPK3hjbU9Ra0psaUpIZmhIUzgvMCs3YXdzZm50dGkvQ0sxR1h2b1Bw?=
 =?utf-8?B?dFpuWWNwTm9hakRSNUxNaFd0b3MvYmppUDF4U25LTWxNLy91b0JDeURXN25M?=
 =?utf-8?B?OFNERmc3ZkZ2VXdzVk9CU0ZodWxkVG0xeE1KOGVjY1JiZXR1Tk4rTExhK0Ev?=
 =?utf-8?B?dHVDbTMxRXJjYWcwM0NtaUdkaUJDKzkzdjJkSTlTbzk0RVRqTG1tQU5VS2Nq?=
 =?utf-8?B?WXF1cS9Ub3FraWNMcW85amF0Zk9PTUdsbEJHVWVRTlJIOVBrYmxMcnhveW56?=
 =?utf-8?B?SmFwb1pRQ2I4ZHJlS0RCU3FjVlpwNlMydDBOaFE2dmhnTFZleGRkY0c0M2Z3?=
 =?utf-8?B?dmtXNEZLa1h3SEtBamk0ZjhPLzhrVTM0am56YkZyYndJdm81OE1WTHBxMkd3?=
 =?utf-8?B?UmVKVzBmN0RVclcvcWh4MnAvS3BCS2J6dDY4VzY3eGhmb1ZlVS8rRVNteXVq?=
 =?utf-8?B?eThUaHJOVE14UTZySUdLSmFjbk95eUkvV0hxQko3WjBUNC9tYWZiSHJaaTVC?=
 =?utf-8?B?ZXFlMnZMUjh3MXdGMEk3ZFFjaFN6MkRUSG5XRW1FQmJPdUU3dnluSTVXVThn?=
 =?utf-8?B?NUdWKzg4dVd3M0M5Y1ViYzlLczJMVzQ0NDBSMEVhNUF2b0E4Zy9TYVNOM1Mz?=
 =?utf-8?B?SnZJRVFVQS9JaytDaGZNS3NJUVhHMDJpS1AvQmlseGxqcithYnhZR0Q2bEVH?=
 =?utf-8?B?cW5jV3RUMExCdmZIOC9ZbVZhQlBEd2xQK3VkVG50TU5EMXpGVEhkL0l3Y0s3?=
 =?utf-8?B?azlKUFFWeDRqMVJmcnp4WFpvMy9NYk9sbWdycytPWHU5S3Uwb1ZUaU1QVm9z?=
 =?utf-8?B?bjB5YmtJVU1JNGs1enBEVU90dEVpTy93UStiT1JXM1JISVJhR0RJeFB6QTh4?=
 =?utf-8?B?MG5CM3JwTnpYTzlrbjJEWFFqMm80RkpNZnJzcUF3diszUUVIMXBSZUprc1Ra?=
 =?utf-8?B?TFppNFJMc2Z4NUFJcUc5Si9yZGNhbWRKOWNsY0wyR25kVS9OOWY5c1h1cHdZ?=
 =?utf-8?B?eGxaVGJaMkwzOW5TNlZSVS9yQ2hkbXkvWXl0aWo2aU80YzJObjB4bGVJeWVj?=
 =?utf-8?B?Nm01cXR1M01ZVXBtYmNxaTF2cGEzaFNCbEEvSGZnRHI1ZnZtZjBzM2UyUkk1?=
 =?utf-8?B?eFhRbW90SGY4YTZ1UkxlcGdDWmtOYVdNU2JxNmZLYnZwa2U5dkRmb0dVWnNZ?=
 =?utf-8?B?bUtWclhTeis5dnNqc3RjSldudVlxd0tXalluWkt2enAwenlYYnQ4dFgrZjlt?=
 =?utf-8?B?d2ZNT1VxZ2ZMN1lvR3VrZm00Ym5FNGgvMVpWSkY1RGgrclhNTEZ2aUFGTmQ0?=
 =?utf-8?Q?lCnUQaa6Wwaj3YOqANjFcu9zcEAuaM+QvFjKvWokzFs7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A38FD073B75E2940A1EA04FD4325D03F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7a1044-3e4f-4498-74f1-08d9a9436aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:55:26.8861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vxnEjRZLc0xulPh9oQoXQAaIbGuU200T9ePLkep4sDOpVZmz24F/cDqCShZoeu4v1BdoIU83MFtgA/0MuvzG3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTExLTAzIGF0IDA4OjU3ICswMjAwLCBSb2kgRGF5YW4gd3JvdGU6DQo+IA0K
PiANCj4gT24gMjAyMS0xMS0wMyA4OjIxIEFNLCBZaWhhbyBIYW4gd3JvdGU6DQo+ID4gc3dhcCgp
IHdhcyB1c2VkIGluc3RlYWQgb2YgdGhlIHRtcCB2YXJpYWJsZSB0byBzd2FwIHZhbHVlcw0KPiA+
IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFlpaGFvIEhhbiA8aGFueWloYW9Adml2by5jb20+DQo+ID4g
LS0tDQo+ID4gwqAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3Rj
X2N0LmMgfCA1ICstLS0tDQo+ID4gwqAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCA0
IGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3RjX2N0LmMNCj4gPiBpbmRleCA3NDBjZDZmMDg4Yjgu
LmQ0YjRmMzI2MDNmMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jDQo+ID4gQEAgLTkwNywxMiArOTA3LDkgQEAg
bWx4NV90Y19jdF9zaGFyZWRfY291bnRlcl9nZXQoc3RydWN0DQo+ID4gbWx4NV90Y19jdF9wcml2
ICpjdF9wcml2LA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWx4NV9jdF90dXBsZSByZXZf
dHVwbGUgPSBlbnRyeS0+dHVwbGU7DQo+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBtbHg1X2N0
X2NvdW50ZXIgKnNoYXJlZF9jb3VudGVyOw0KPiA+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgbWx4
NV9jdF9lbnRyeSAqcmV2X2VudHJ5Ow0KPiA+IC3CoMKgwqDCoMKgwqDCoF9fYmUxNiB0bXBfcG9y
dDsNCj4gPiDCoCANCj4gPiDCoMKgwqDCoMKgwqDCoMKgLyogZ2V0IHRoZSByZXZlcnNlZCB0dXBs
ZSAqLw0KPiA+IC3CoMKgwqDCoMKgwqDCoHRtcF9wb3J0ID0gcmV2X3R1cGxlLnBvcnQuc3JjOw0K
PiA+IC3CoMKgwqDCoMKgwqDCoHJldl90dXBsZS5wb3J0LnNyYyA9IHJldl90dXBsZS5wb3J0LmRz
dDsNCj4gPiAtwqDCoMKgwqDCoMKgwqByZXZfdHVwbGUucG9ydC5kc3QgPSB0bXBfcG9ydDsNCj4g
PiArwqDCoMKgwqDCoMKgwqBzd2FwKHJldl90dXBsZS5wb3J0LnNyYywgcmV2X3R1cGxlLnBvcnQu
ZHN0KTsNCj4gPiDCoCANCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJldl90dXBsZS5hZGRyX3R5
cGUgPT0gRkxPV19ESVNTRUNUT1JfS0VZX0lQVjRfQUREUlMpIHsNCj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoF9fYmUzMiB0bXBfYWRkciA9IHJldl90dXBsZS5pcC5zcmNfdjQ7
DQo+ID4gDQo+IA0KPiANCj4ganVzdCBzbWFsbCBjb21tZW50IG9uIHRoZSB0aXRsZS4NCj4gbWlz
c2luZyBhIHNwYWNlIGluIHRoZSBjb21taXQgdGl0bGUgYWZ0ZXIgdGhlIGNvbG9uLg0KPiBJIGFs
c28gdGhpbmsgdGhlIHByZWZpeCBzaG91bGQgYmUgIm5ldC9tbHg1ZTogQ1QsIC4uLiINCj4gDQo+
IFJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbnZpZGlhLmNvbT4NCg0KRml4ZWQgdXAgYW5k
IGFwcGxpZWQgdG8gbmV0LW5leHQtbWx4NS4NCg0K
